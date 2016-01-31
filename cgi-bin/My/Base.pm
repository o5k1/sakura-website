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

   my ($title, $path) = @_;
   
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
    <link rel=\"shortcut icon\" type=\"image/png\" href=\"../public-html/images/favicon.png\"/>
    <script type=\"text/javascript\" src=\"../public-html/js/scripts.js\"></script>
</head>
      ";
      
print<<EOF;
   <body onload="manageNav()">
	<div id="header">
		<div id="fixed-info">
			<!--<p><a id="city" href="dove-siamo.html">Bassano del Grappa</a> | <a id="tel" href="tel:0424 382286">0424 382286</a></p>-->
            <p>Area Riservata - <a id="exit" href='logout.cgi'>Esci</a></p>
		</div> 
		<!--Logo come background tramite IMAGE REPLACEMENT cosicchè possa costituire informazione per il motore di ricerca (Best practice) [Orietta docet]-->
		
			<div id="top-bar">
				<div id="logo">
					<h1>Sakura - Ristorante Giapponese</h1>
				</div> 
				<div id="nav-button">
					<a onclick="manageNav()" title="Menu"> &#9776; </a>
				</div>
			</div>
		
		<!--Sostituita immagine del bottone di navigazione con il carattere come su w3school.com-->
		<!--il valore di onClick dovrà essere la funzione JS che apre il menu a scomparsa nel layout mobile.-->
		
		<div id="nav-menu">
			   <ul>
				<li xml:lang="en"><a href="../public-html/index.html">Home</a></li>
				<li><a href="menu.cgi">Menù</a></li>
				<li><a href="../public-html/chi-siamo.html">Chi siamo</a></li>
				<li><a href="../public-html/dove-siamo.html">Dove siamo</a></li>
				<li><a href="../public-html/curiosita.html">Curiosità</a></li>
			   </ul>
		    </div>
	</div>
	<div id="main">
		<!--il path svolge sia funzione di breadcrumb che di titolo della pagina, per siti che hanno un solo livello profondità non serve breadcrumb [Orietta docet] -->
EOF

	print "<div id=\"path\">
			<h2>$path</h2>
		</div>
		<div id=\"content\">";

   #if($breadcrump) {
      #print "<div id='breadcrumb'>
            #<p><a href='../public-html/index.html' xml:lang='en'>Home</a> &gt;&gt; $breadcrump</p>
            #</div>
            #";
   #}

}


#
sub printEndHtml {

   print<<EOF
      </div>
	</div>
	<div id="footer">
		<p>Ristorante Giapponese Sakura - Specialità Sushi</p>
		<p>Bassano del Grappa (VI)</p> 
		<p>PI 02013730367 - Tel: 0424 382286</p>
	</div>
</body>
</html>
EOF

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
      #my $avviso="La sessione è scaduta (dura 1 ora). ";
      $session->delete();
      print $session->header(-location=>"../public-html/accesso-negato.html");
      exit;
   }
   
   elsif($session->is_empty) {
		#my $avviso="Non hai ancora effettuato l'accesso all'area riservata.";
        #$session->delete();
        #print "Content-type: text/html\n\n Session empty";
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
