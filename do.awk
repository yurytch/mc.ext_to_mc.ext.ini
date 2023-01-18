#! /bin/awk -f 

BEGIN \
{
  IGNORECASE = 1 ; sz_ic[0] = "false" ; sz_ic[1] = "true" ; 
  sect ="" ;
  print "[mc.ext.ini]" ; print "Version=4.0\n"
}

/^([^#]*)(regex|type|shell|include)\/(.*)$/ \
{
  if ( 1 == section_head ) multi_sections()

  section_head = 1
    print "#" $0 # JFYI
  match( $0 , /^([^#]*)(regex|type|shell|include)\/(.*)$/ , aa ); # !!! might need to check the return
  sect = toupper(substr(aa[2],1,1)) tolower(substr(aa[2],2)) 

  rr = split($0,a,sect"/") ; if (rr<2) fail_split()
  
  # begin section header
  printf( "[" sect"/" );
  sz = a[rr] ; cond_ic = 0 ;
  if ( 1 == match(a[rr],"[Ii]/") ) { sz = substr(a[rr],3) ; cond_ic = 1; }
  # unacceptable in section headers, or just hard to read there
  sz_sane = gensub( "[\\\\/\\[\\]\\?\\$\\|\\(\\)]" , "_" , "g" , sz ); 
  printf( "%s" , sz_sane ) ; print "]" ;
  # end section header
  
  if ( 1 != match(tolower(sect),"^include$") ) # there is no IncludeIgnoreCase and no Include= in [Include/...]
  {
    print "\t" sect"=" sz
    print "\t" sect"IgnoreCase=" sz_ic[cond_ic] ;
  }
  next
}

/^([^#]*)(default\/)(.*)$/ \
{
  if ( 1 == section_head ) multi_sections()
  section_head = 1
  print "[Default]"
  next
}

/^([^#]*)(view|open|include[ \t]*[^\/])(.*)$/ \
{
  section_head = 0
  if ( 2 > split($0,a,"view|open|include[ \t]*[^/]") ) fail_split()
  print $0
  next
}

// \
{
  print ; next ;
}

END \
{}

function multi_sections () \
{
  print "FAIL: two subsequent section headers (with no actions for the preceding one), line " FNR ": " $0 ;
  exit 111 ;
}
function fail_split () \
{
  print "FAIL: splitting section header produced no right hand value, line " FNR ": " $0 ;
  exit 111 ;
}