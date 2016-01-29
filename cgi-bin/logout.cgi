#!\Perl64\bin\perl

use strict;
use warnings;
use CGI;
use CGI::Session;

my $session = CGI::Session->load() or print "Location: ../login.html\n\n";
   $session->delete();

print "Location: ../public-html/login.html\n\n";
   
exit 0;
