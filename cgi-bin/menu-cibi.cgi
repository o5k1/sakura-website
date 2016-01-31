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

my %path = (   add_piatto => 'add-piatto.cgi',
               mod_piatto => 'mod-piatto.cgi',
               del_piatto => 'private-menu-cibi.cgi',
);

printStartHtml('Cibi - Menù - Sakura', "<a href='private-menu.cgi'>Menù categorie</a> &gt;&gt; Menù cibi");

printMenuCibi(0, \%path);

printEndHtml();


exit 0;
