#!\Perl64\bin\perl

use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use XML::LibXML;

use My::Base;
use My::PrintMenu;
use My::Operation;

#Inizializzazione variabili base
my $q = new CGI;
my $session = CGI::Session->load() or die $!;

checkSession($session);

my %path = (   add_piatto => 'add-piatto.cgi',
               mod_piatto => 'mod-piatto.cgi',
               del_piatto => 'private-menu-cibi.cgi',
);

printStartHtml('Cibi - Menù - Area Riservata', "<a href='private-menu.cgi'>Menù categorie</a> &gt;&gt; Menù cibi");

my $message = checkDelete($q, "cibo/portata/piatto");

#print $q->a({-href => 'private-menu.cgi'}, 'Torna alle categorie menù');

if ($message ne '') {
   print "<p>$message</p>";
}

printMenuCibi(1, \%path);

printEndHtml();


exit 0;
