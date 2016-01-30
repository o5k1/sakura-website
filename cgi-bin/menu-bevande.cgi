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

printStartHtml('Bevande - Menù - Sakura', "Menù bevande", "<a href='private-menu.cgi'>Menù categorie</a> &gt;&gt; Menù bevande");

printMenuBevande(0, \%path);

printEndHtml();


exit 0;
