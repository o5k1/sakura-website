#!\Perl64\bin\perl

use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

use My::Base;
use My::PrintMenu;
use My::Operation;

#Inizializzazione variabili base
my $q = new CGI;
#my $session = CGI::Session->load() or die $!;

#checkSession($session);

my %path = (   add_piatto => 'add-piatto.cgi',
               mod_piatto => 'mod-piatto.cgi',
               del_piatto => 'private-menu-cibi.cgi',
);

printStartHtml('Bevande - Men&ugrave; - Sakura');

#my $message = checkDelete($q, "cibo/portata/piatto");

print $q->a({-href => 'menu.cgi'}, 'Torna alle categorie menù');

#print "<p>$message</p>";

printMenuBevande(0, \%path);

printEndHtml();


exit 0;
