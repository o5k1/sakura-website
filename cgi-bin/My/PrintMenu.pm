# N.B. Package in cui si collocano le funzioni principali per la stampa html delle pagine inerenti al menù ristorativo
#
#
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);
use XML::LibXML;
use CGI::Session;
use Encode qw(encode);
use My::Base;

   package My::PrintMenu;

use Exporter qw(import);
our @EXPORT = qw(printMenuBevande printMenuCibi printMenuPublic);

#
sub printMenuPublic {


   my $doc = My::Base::initLibXML();

   print "
          <p class='info'>Seleziona una categoria per accedere ai nostri piatti.</p>
          ";

   printLinkListeUnit($doc, "/menu/cibo/portata", "menu/bevande/listaBevande");

   printMenuCibi(0);

   printMenuBevande(0);
}


# 
sub printMenuBevande {

      my $q = new CGI;
      my ($admin, $pathR) = @_;
      my $valuta = "€";
      
      my $doc = My::Base::initLibXML();
      
      my $query = "menu/bevande/listaBevande";
      my $query2 = "./bevanda";
            
      if ($admin) {
         printLinkListe($doc, $query);
      }

         print "<div class='panel'>
               <h3>Bevande</h3>
               ";
      
      foreach my $listaBevande ($doc->findnodes($query)) {
         my $idLista = $listaBevande->findnodes('@id');
            $idLista = enc($idLista);
         my $nomeLista = enc($listaBevande->findnodes('./nome'));
            ($nomeLista) = ( $nomeLista =~ /<nome>(.*)<\/nome>/);
         
         print "<div class='panel'>
                  <div class='list-title'>
                  <h4><a href='javascript:void(0)' onclick=\"manageMenu('$idLista')\">$nomeLista</a></h4>
                  ";

      
         if($admin) {
            My::Base::printStartForm('add-bevanda', $pathR->{add_bevanda}, 'GET');
            print "<fieldset>";
            print $q->submit(-class => 'pulsante',
                              -name => 'add',
                              -value => 'Aggiungi');
            print $q->hidden(-name => 'idLista',
                              -value => $idLista);
            print $q->hidden(-name => 'nomeLista',
                              -value => $nomeLista);
            print "</fieldset>";
            My::Base::printEndForm();
         }
         print "
               </div>
               <dl class='listaBevande' id='$idLista'>
                  ";

   
         foreach my $bevanda ($listaBevande->findnodes($query2)){
            
               my $idBevanda = $bevanda->findnodes('@id');
                  $idBevanda = enc($idBevanda);
               my $nome = enc($bevanda->findnodes('./nome'));
                  ($nome) = ( $nome =~ /<nome>(.*)<\/nome>/); # Elimino i tag in più
               my $prezzo = enc($bevanda->findnodes('./prezzo'));
                  ($prezzo) = ( $prezzo =~ /<prezzo>(.*)<\/prezzo>/ );
               my $descrizione = enc($bevanda->findnodes('./descrizione')); 
                  ($descrizione) = ( $descrizione =~ /<descrizione>(.*)<\/descrizione>/);
               
               print "<dt>- <strong>$nome</strong> <span class='prezzo'>$valuta $prezzo</span></dt>";
         
               if($admin) {
                  if ($descrizione ne '') {
                     print "<dd>$descrizione";
                  } else {
                     print "<dd>";
                  }

                  My::Base::printStartForm('mod-bevanda',$pathR->{mod_bevanda}, 'GET');
                     print "
                     <fieldset>
                           <input class='pulsante' type='submit' name='mod' value='Modifica' />
                           <input type='hidden' name='idElemento' value='$idBevanda' />
                           <input type='hidden' name='nome' value='$nome' />
                           <input type='hidden' name='prezzo' value='$prezzo' />
                           <input type='hidden' name='descrizione' value='$descrizione' />
                     </fieldset>
                     ";
                  My::Base::printEndForm();
                
                  My::Base::printStartForm('del-bevanda', $pathR->{del_bevanda}, 'GET');
                     print "
                     <fieldset>
                           <input class='pulsante' type='submit' name='del' value='Rimuovi' />
                           <input type='hidden' name='nome' value='$nome' />
                           <input type='hidden' name='idElemento' value='$idBevanda' />
                     </fieldset>
                     ";
                  My::Base::printEndForm();
                  print "</dd>";
               }
               elsif ($descrizione ne '') {
                  print "<dd>$descrizione</dd>";
               }
         }
      print "</dl>
         <p class='end-list'><a href='#header'>Torna all'inizio</a></p>
      </div>";
   }
   print "</div>";
}


#
sub printMenuCibi {

   my $q = new CGI;
   my ($admin, $pathR) = @_;
   my $valuta = "€";

   my $doc = My::Base::initLibXML();
   
   # sub printCibo() Print sezione cibo (da portare in funzione)
   my $query = "/menu/cibo/portata";   # Query primaria
   my $query2 = "./piatto";            # Query secondaria
   
   if ($admin) {
      printLinkListe($doc, $query);
   }

   print "<div class='panel'>
               <h3>Cibi</h3>
               ";
   
   foreach my $portata ($doc->findnodes($query)) {
      my $idPortata = $portata->findnodes('@id');
         $idPortata = enc($idPortata);
      my $nomePortata = enc($portata->findnodes('./nome'));
         ($nomePortata) = ( $nomePortata =~ /<nome>(.*)<\/nome>/);
   
      print "<div class='panel'>
               <div class='list-title'>
               <h4><a href='javascript:void(0)' onclick=\"manageMenu('$idPortata')\">$nomePortata</a></h4>
               ";

      
      if($admin) {
         My::Base::printStartForm('add-piatto', $pathR->{add_piatto}, 'GET');
            print "
            <fieldset>
                  <input class='pulsante' type='submit' name='aggiungi' value='Aggiungi' />
                  <input type='hidden' name='idLista' value='$idPortata' />
                  <input type='hidden' name='nomeLista' value='$nomePortata' />
            </fieldset>
            ";
         My::Base::printEndForm();
      }
      
      print "
            </div>
            <dl class='portata' id='$idPortata'>
            ";
      
      foreach my $piatto ($portata->findnodes($query2)){
               
               my $idPiatto = $piatto->findnodes('@id');
                  $idPiatto = enc($idPiatto);
               my $nome = enc($piatto->findnodes('./nome'));
                  ($nome) = ( $nome =~ /<nome>(.*)<\/nome>/); # Elimino i tag in più
               my $numero = enc($piatto->findnodes('./numero'));
                  ($numero) = ( $numero =~ /<numero>(.*)<\/numero>/);
               my $prezzo = enc($piatto->findnodes('./prezzo'));
                  ($prezzo) = ( $prezzo =~ /<prezzo>(.*)<\/prezzo>/ );
               my $descrizione = enc($piatto->findnodes('./descrizione')); 
                  ($descrizione) = ( $descrizione =~ /<descrizione>(.*)<\/descrizione>/);
               
               print "<dt>$numero - <strong>$nome</strong> <span class='prezzo'>$valuta $prezzo</span></dt>";
               
               if($admin) {
                  if ($descrizione ne '') {
                     print "<dd>$descrizione";
                  } else {
                     print "<dd>";
                  }

                  My::Base::printStartForm('mod-piatto', $pathR->{mod_piatto}, 'GET');
                  print "
                  <fieldset>
                           <input class='pulsante' type='submit' name='mod' value='Modifica' />
                           <input type='hidden' name='idElemento' value='$idPiatto' />
                           <input type='hidden' name='nome' value='$nome' />
                           <input type='hidden' name='numero' value='$numero' />
                           <input type='hidden' name='descrizione' value='$descrizione' />
                           <input type='hidden' name='prezzo' value='$prezzo' />
                  </fieldset>
                  ";
                  My::Base::printEndForm();
                  
                  My::Base::printStartForm('del-piatto', $pathR->{del_piatto}, 'GET');
                  print "
                  <fieldset>
                           <input class='pulsante' type='submit' name='del' value='Rimuovi' />
                           <input type='hidden' name='idElemento' value='$idPiatto' />
                           <input type='hidden' name='nome' value='$nome' />
                  </fieldset>
                  ";
                  My::Base::printEndForm();

                  print "\n</dd>\n";
               }
               elsif ($descrizione ne '') {
                  print "<dd>$descrizione</dd>";
               }
      }
      
      print "</dl>
         <p class='end-list'><a href='#header'>Torna all'inizio</a></p>
      </div>";
   }
   print "</div>";
}
   
   
# Da USARE dopo aver prelevato il text di un nodo   
sub enc {
   return Encode::encode('UTF-8', $_[0]);
}

sub printLinkListe {

   my ($doc, $query) = @_;

   print "<div id='fast-search' class='panel'>
            <h3>Ricerca Veloce</h3>
            <ul>";
   foreach my $lista ($doc->findnodes($query)) {
      my $idLista = $lista->findnodes('@id');
         $idLista = enc($idLista);
      my $nomeLista = enc($lista->findnodes('./nome'));
         ($nomeLista) = ( $nomeLista =~ /<nome>(.*)<\/nome>/);
      print "<li><a href='#$idLista'>$nomeLista</a></li>";
   }
   print "</ul>
         </div>";
}

sub printLinkListeUnit {

   my ($doc, $query1, $query2) = @_;

   print "<div id='fast-search' class='panel'>
            <h3>Ricerca Veloce</h3>
            <ul>";

   foreach my $lista ($doc->findnodes($query1)) {
      my $idLista = $lista->findnodes('@id');
         $idLista = enc($idLista);
      my $nomeLista = enc($lista->findnodes('./nome'));
         ($nomeLista) = ( $nomeLista =~ /<nome>(.*)<\/nome>/);
      print "<li><a href='#$idLista'>$nomeLista</a></li>";
   }

   foreach my $lista ($doc->findnodes($query2)) {
      my $idLista = $lista->findnodes('@id');
         $idLista = enc($idLista);
      my $nomeLista = enc($lista->findnodes('./nome'));
         ($nomeLista) = ( $nomeLista =~ /<nome>(.*)<\/nome>/);
      print "<li><a href='#$idLista'>$nomeLista</a></li>";
   }

   print "</ul>
         </div>";
}

   
1;
