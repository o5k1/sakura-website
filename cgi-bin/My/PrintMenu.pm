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
our @EXPORT = qw(printMenuBevande printMenuCibi);

# 
sub printMenuBevande {

      my $q = new CGI;
      my ($admin, $pathR) = @_;
      my $valuta = "€";
      
      my $doc = My::Base::initLibXML();
      
      my $query = "menu/bevande/listaBevande";
      my $query2 = "./bevanda";
            
      printLinkListe($doc, $query);
      
      foreach my $listaBevande ($doc->findnodes($query)) {
         my $idLista = $listaBevande->findnodes('@id');
            $idLista = enc($idLista);
         my $nomeLista = enc($listaBevande->findnodes('./nome'));
            ($nomeLista) = ( $nomeLista =~ /<nome>(.*)<\/nome>/);
         
         print "<div class='panel'>
                  <dl class='listaBevande' id='$idLista'>";
         print "<h3>$nomeLista</h3>";
      
         if($admin) {
            My::Base::printStartForm('add-bevanda', $pathR->{add_bevanda}, 'GET');
            print $q->submit(-class => 'pulsante',
                              -name => 'add',
                              -value => 'Aggiungi '.$nomeLista);
            print $q->hidden(-name => 'idLista',
                              -value => $idLista);
            print $q->hidden(-name => 'nomeLista',
                              -value => $nomeLista);
            My::Base::printEndForm();
         }
         #print "</h3>";

   
         foreach my $bevanda ($listaBevande->findnodes($query2)){
            
               my $idBevanda = $bevanda->findnodes('@id');
                  $idBevanda = enc($idBevanda);
               my $nome = enc($bevanda->findnodes('./nome'));
                  ($nome) = ( $nome =~ /<nome>(.*)<\/nome>/); # Elimino i tag in più
               my $prezzo = enc($bevanda->findnodes('./prezzo'));
                  ($prezzo) = ( $prezzo =~ /<prezzo>(.*)<\/prezzo>/ );
               my $descrizione = enc($bevanda->findnodes('./descrizione')); 
                  ($descrizione) = ( $descrizione =~ /<descrizione>(.*)<\/descrizione>/);
               
               print "<dt>$nome <span class='prezzo'>$valuta $prezzo</span>";
         
               if($admin) {
                  My::Base::printStartForm('mod-bevanda',$pathR->{mod_bevanda}, 'GET');
                     print "<span class='pulsanti'>
                           <input class='pulsante' type='submit' name='mod' value='Modifica' />
                           <input type='hidden' name='nome' value='$nome' />
                           <input type='hidden' name='idElemento' value='$idBevanda' />
                           <input type='hidden' name='prezzo' value='$prezzo' />
                           <input type='hidden' name='descrizione' value='$descrizione' />
                         </span>";
                  My::Base::printEndForm();
                
                  My::Base::printStartForm('del-bevanda', $pathR->{private_menu}, 'GET');
                     print "<span class='pulsanti'> 
                           <input class='pulsante' type='submit' name='del' value='Rimuovi' />
                           <input type='hidden' name='nome' value='$nome' />
                           <input type='hidden' name='idElemento' value='$idBevanda' />
                        </span>";
                  My::Base::printEndForm();
               }
         
               print "</dt>";
         
               if($descrizione ne ''){
                  print "<dd>$descrizione</dd>";
               }
         }
      print "</dl>
         <p><a href='#header'>Torna all'inizio</a></p>
      </div>";
   }
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
   
   printLinkListe($doc, $query);
   
   foreach my $portata ($doc->findnodes($query)) {
      my $idPortata = $portata->findnodes('@id');
         $idPortata = enc($idPortata);
      my $nomePortata = enc($portata->findnodes('./nome'));
         ($nomePortata) = ( $nomePortata =~ /<nome>(.*)<\/nome>/);
   
      print "<div class='panel'>
               <dl class='portata' id='$idPortata'>";
      print "<h3>$nomePortata</h3>";
      
      if($admin) {
         My::Base::printStartForm('add-piatto', $pathR->{add_piatto}, 'GET');
            print "<input class='pulsante' type='submit' name='aggiungi' value='Aggiungi' />
                <input type='hidden' name='idLista' value='$idPortata' />
                 <input type='hidden' name='nomeLista' value='$nomePortata' />";
         My::Base::printEndForm();
      }
      
      #print "</h3>";
      
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
               
               print "<dt>$numero - $nome <span class='prezzo'>$valuta $prezzo</span>";
               
               if($admin) {
                  My::Base::printStartForm('mod-piatto', $pathR->{mod_piatto}, 'GET');
                  print "<span class='pulsanti'>
                           <input class='pulsante' type='submit' name='mod' value='Modifica' />
                           <input type='hidden' name='idElemento' value='$idPiatto' />
                           <input type='hidden' name='nome' value='$nome' />
                           <input type='hidden' name='numero' value='$numero' />
                           <input type='hidden' name='descrizione' value='$descrizione' />
                           <input type='hidden' name='prezzo' value='$prezzo' />
                           </span>";
                  My::Base::printEndForm();
                  
                  My::Base::printStartForm('del-piatto', $pathR->{private_menu}, 'GET');
                  print "<span class='pulsanti'>  
                           <input class='pulsante' type='submit' name='del' value='Rimuovi' />
                           <input type='hidden' name='idElemento' value='$idPiatto' />
                           <input type='hidden' name='nome' value='$nome' />
                        </span>";
                  My::Base::printEndForm();
               }
               
               print "</dt>";
               
               if($descrizione ne ""){
                  print "<dd>$descrizione</dd>";
               }      
      }
      
      print "</dl>
         <p class='end-list'><a href='#header'>Torna all'inizio</a></p>
      </div>";
   } 
}
   
   
# Da USARE dopo aver prelevato il text di un nodo   
sub enc {
   return Encode::encode('UTF-8', $_[0]);
}

sub printLinkListe {

   my ($doc, $query) = @_;
   
   
   
   print "<div class='panel'>
            <h3>Ricerca Veloce</h3>
            <ul id='fast-search'>";
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
   
1;