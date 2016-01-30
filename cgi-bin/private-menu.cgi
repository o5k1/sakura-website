#!\Perl64\bin\perl

# N.B. Alcuni documenti per questioni di sicurezza mettevano nel preambolo dopo \perl: '-Tw', ciò però non linka più BaseFunctions.
use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use My::Base qw(checkSession printStartHtml printEndHtml initLibXML);

#Inizializzazione variabili base
my $q = new CGI;
my $session = CGI::Session->load() or die $!;

checkSession($session);

printStartHtml('Categorie - Menù - Area Riservata', "Menù categorie");

   print "<div class='panel'>";
   
   print $q->h3('Categorie men&ugrave;');
   print $q->p('Scegli la categoria');
   
   print "<ul>
            <li><a href='private-menu-cibi.cgi'>Cibi</a></li>
            <li><a href='private-menu-bevande.cgi'>Bevande</a></li>
         </ul>";
         
   # Spazio pubblicitario dei menu fissi
   
   print "</div>";

printEndHtml();

exit 0;
