#!\Perl64\bin\perl

use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use XML::LibXML;

use My::Base;
use My::PrintMenu;

#Inizializzazione variabili base
my $q = new CGI;

printStartHtmlPublic('Menù', "Menù");

   printMenuPublic();

printEndHtmlPublic();

exit 0;
