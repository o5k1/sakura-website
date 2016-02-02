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
our @EXPORT = qw(printStartHtml printStartHtmlPublic printEndHtml printEndHtmlPublic printStartForm printEndForm checkSession getFilename initLibXML existElement evalNode writeFile enc);
                  # Indicare i metodi da esportare

#---------------HTML--------------------------------------------------------------

sub printHeadHtml {

   my $title = $_[0];

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
}

sub printTopBarHtml {
print<<EOF;
			<div id="top-bar">
				<div id="logo">
					<h1>Sakura - Ristorante Giapponese</h1>
				</div> 
				<div id="nav-button">
					<a onclick="manageNav()" title="Menu"> &#9776; </a>
				</div>
			</div>
EOF
}

sub printPathHtml {

   my $path = $_[0];

	print "<div id=\"path\">
			<h2>$path</h2>
		</div>
		<div id=\"content\">";
}


#
sub printStartHtml {

   my ($title, $path, $nav) = @_;

   print "Content-type: text/html\n\n"; # Dico a Perl che sto stampando html

   printHeadHtml($title);

print "
   <body onload=\"manageNav(); hideElement()\">
	<div id=\"header\">
		<div id=\"fixed-info\">
			<!--<p><a id=\"city\" href=\"dove-siamo.html\">Bassano del Grappa</a> | <a id=\"tel\" href=\"tel:0424 382286\">0424 382286</a></p>-->
            <p>Area Amministratore - <a id=\"exit\" href='logout.cgi'>Esci</a></p>
		</div>";
		
   printTopBarHtml();

   if ($nav eq 'cibi') {
      print<<EOF
		<div id="nav-menu">
			   <ul>
				<li>Cibi</li>
				<li><a href="private-menu-bevande.cgi">Bevande</a></li>
			   </ul>
		    </div>
	</div>
	<div id="main">
EOF
;
} elsif ($nav eq 'bevande') {
   print<<EOF
		<div id="nav-menu">
			   <ul>
				<li><a href="private-menu-cibi.cgi">Cibi</a></li>
				<li>Bevande</li>
			   </ul>
		    </div>
	</div>
	<div id="main">
EOF
;
} else {
   print<<EOF
		<div id="nav-menu">
			   <ul>
				<li><a href="private-menu-cibi.cgi">Cibi</a></li>
				<li><a href="private-menu-bevande.cgi">Bevande</a></li>
			   </ul>
		    </div>
	</div>
	<div id="main">
EOF
;
}

   printPathHtml($path);

}


# Stampa l'html iniziale per le pagine cgi pubbliche
sub printStartHtmlPublic {

   my ($title, $path) = @_;

   print "Content-type: text/html\n\n"; # Dico a Perl che sto stampando html

   printHeadHtml($title);

print "
   <body onload=\"manageNav(); hideElement()\">
	<div id=\"header\">
		<div id=\"fixed-info\">
			<p><a id=\"city\" href=\"../public-html/dove-siamo.html\">Bassano del Grappa</a> | <a id=\"tel\" href=\"tel:0424 382286\">0424 382286</a></p>
		</div>";

   printTopBarHtml();

   print<<EOF
		<div id="nav-menu">
			   <ul>
				<li xml:lang="en"><a href="../public-html/index.html">Home</a></li>
				<li>Menù</li>
				<li><a href="../public-html/chi-siamo.html">Chi siamo</a></li>
				<li><a href="../public-html/dove-siamo.html">Dove siamo</a></li>
				<li><a href="../public-html/curiosita.html">Curiosità</a></li>
			   </ul>
		    </div>
	</div>
	<div id="main">
EOF
;
   printPathHtml($path);
}


#
sub printEndHtml {
   print<<EOF
      </div>
	</div>
	<div id="footer">
		<p>Area Amministratore - <a id="exit" href='logout.cgi'>Esci</a></p>
	</div>
</body>
</html>
EOF
}


# Stampa il footer delle pagine cgi pubbliche
sub printEndHtmlPublic {

   my $login = $_[0];

   print<<EOF
      </div>
	</div>
	<div id="footer">
		<p>Ristorante Giapponese Sakura - Specialità Sushi</p>
		<p>Bassano del Grappa (VI)</p> 
		<p>PI 02013730367 - Tel: 0424 382286</p>
EOF
;
      if (!($login)) {
         print "<p id=\"admin\"><a href=\"../cgi-bin/login.cgi\">Area amministratore</a></p>";
      }

	print "</div>
</body>
</html>";
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
                        -onSubmit => 'return checkForm()',
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
