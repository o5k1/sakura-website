#
#
#
use strict;
use warnings;
use CGI;
use CGI::Session;
use XML::LibXML;

   package My::Base;

use Exporter qw(import);
our @EXPORT = qw(printStartHtml printEndHtml printStartForm printEndForm checkSession getFilename initLibXML evalNode writeFile enc); 
                  # Indicare i metodi da esportare

#---------------HTML--------------------------------------------------------------
#
sub printStartHtml {

   my $title = $_[0];
   
   print "Content-type: text/html\n\n"; # Dico a Perl che sto stampando html  
   print "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Strict//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'>
   <html xmlns='http://www.w3.org/1999/xhtml'>
   <head>
	<title>$title | Sakura</title>
	<link rel=\"stylesheet\" type=\"text/css\" href=\"../public-html/css/style.css\">
	<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>
	<meta name=\"title\" content=\"Sakura - Ristorante Giapponese - Bassano del Grappa\" />
	<meta name=\"description\" content=\"Ristorante Giapponese a Bassano del Grappa. Specialità Sushi con servizio d'asporto.\" />
    <meta name=\"keywords\" content=\"Sakura, ristorante, giapponese, giappone, sushi, asporto, bassano, bassano del grappa, vicenza\" />
    <meta name=\"author\" content=\"Andrea Tombolato, Eduard Bicego, Davide Castello\" />
    <meta name=\"language\" content=\"italian it\" />
    <script type=\"text/javascript\" src=\"../public-html/js/scripts.js\"></script>
</head>
   <body>
      <div><a href='logout.cgi'>Esci</a></div>";
}


#
sub printEndHtml {

   print "</body></html>";
}


# Stampa la form con i dati passati per parametro
sub printStartForm {

   my $q = new CGI;
   my $name = $_[0];
   my $action = $_[1];
   my $method = $_[2];

   print $q->start_form(-name => $name,
                        -action => $action,
                        -method => $method,
                        enctype => &CGI::URL_ENCODED
                        );  
}


# Stampa la fine della form
sub printEndForm {

   my $q = new CGI;
   print $q->end_form();
}

#----------CHECK----------------------------------------------------------

#
sub checkSession {

   my $session = $_[0];
   
   if ($session->is_expired) {
      my $avviso="La sessione &egrave; scaduta (dura 20 min). ";
      die($avviso);
      exit;
   }
   
   elsif($session->is_empty) {
		#my $avviso="Non hai ancora effettuato l'accesso all'area riservata.";
        print $session->header(-location=>"../public-html/accesso-negato.html");
        exit;
	}   
}


#----------XML---------------------------------------------------------

#
sub getFilename {
   return "..\\data\\menu.xml";
}


#
sub initLibXML {

   my $filename = getFilename(); # ATTENZIONE path Windows
   my $parser = XML::LibXML->new();
   
   return $parser->parse_file($filename); 
}


# Restituisce 1 se la query passata come parametro ha almeno 1 match, altrimenti 0
sub existElement {

   my $query = $_[0];
   my $doc = initLibXML();
   
   if ($doc->findnodes($query) ne '') {
      return 1;
   } 
   else {
      return 0;
   }
}

# 
sub evalNode {
   
   my $element = $_[0];
   my $parser = XML::LibXML->new(); 
         
   return $parser->parse_balanced_chunk($element);
}


# Scrive il file xml in seguito alle modifiche
sub writeFile {

      my $doc = $_[0];
      my $file = getFilename(); # Da cambiare se si intende scrivere le modifiche su un altro file
      
      if($doc) {
         open(OUT, ">".$file);
         flock(OUT, 2);
         print OUT $doc->toString;
         close(OUT);
      }
}


1;
