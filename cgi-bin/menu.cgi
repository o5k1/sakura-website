#!\Perl64\bin\perl

use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use XML::LibXML;

use My::Base;

#Inizializzazione variabili base
my $q = new CGI;

printStartHtml('Men&ugrave; - Sakura');

   print "<div class='panel'>";
   
   print $q->h3('Categorie men&ugrave;');
   print $q->p('Scegli la categoria');
   
   print "<ul>
            <li><a href='menu-cibi.cgi'>Cibi</a></li>
            <li><a href='menu-bevande.cgi'>Bevande</a></li>
         </ul>";
         
   # Spazio pubblicitario dei menu fissi
   
   print "</div>";

printEndHtml();

exit 0;
