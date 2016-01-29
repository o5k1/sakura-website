#!\Perl64\bin\perl

use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session;

my $q = new CGI;
my $username = $q->param('username');
my $password = $q->param('password');

# Parte da FARE ???
#my $xp = XML::XPath->new(filename => '../data/amministratori.xml');
#$xpath_exp='//admin[username/text()="'.$username.'" and password/text()="'.$password.'"]';
#my $nodeset = $xp->find($xpath_exp);

#if ($nodeset->size eq 1) {
if ($username eq 'admin' && $password eq 'admin') {
   my $session = new CGI::Session(undef, $q, {Directory=>File::Spec->tmpdir});
   #my $session = new CGI::Session();
   $session->expire('60m');
   $session->param('username', $username);
   print $session->header(-location=>"private-menu.cgi");
}
else {
   print $q->header(-location=>"../public-html/accesso-negato.html");
}