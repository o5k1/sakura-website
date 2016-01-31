#!\Perl64\bin\perl

use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use XML::LibXML;

   use My::Base;
   use My::Operation;

my $session = CGI::Session->load() or die $!;

checkSession($session);

#Inizializzazione variabili base
my $q = new CGI;
my $path = "Modifica piatto";
my $breadcrump = "<a href='private-menu-cibi.cgi'>Menù cibi</a> &gt; Modifica piatto";

printStartHtml('Modifica piatto - Area Amministratore', $breadcrump);

# Verifica parametri
if ($q->param('mod-piatto')) {

   #print "<p>Parametri da inserire: ".$q->param('nome')."-".$q->param('prezzo')."-".$q->param('descrizione')."</p>";

   my $error = '';
   
   # Dati generali
   my $idLista = $q->param('idLista');
   my $nomeLista = $q->param('nomeLista');
   my $oldId = $q->param('idElemento'); # Campo hidden vecchio
   
   # Dati nuovi
   my $newNome = $q->param('nome');
      $error .= checkNome($newNome);
   my $newNumero = $q->param('numero');
      $error .= checkNumero($newNumero);
   my $newPrezzo = $q->param('prezzo');
      $error .= checkPrezzo($newPrezzo);
   my $newDesc = $q->param('descrizione');
      $error .= checkDesc($newDesc);
      
   my $newId = toCamelCase($newNome);
      if ($newId ne $oldId) { # Il controllo sull'id è fatto solo se questo risulta diverso dal vecchio
         $error .= checkIdPiatto($newId);
      }
   
   
   if ($error ne '') { # Se ci sono degli errori
      
      my %textForm = (htitle => 'Modifica piatto: ',
                      toggetto => $newNome,
                      hfile => 'mod-piatto.cgi',
                      hlegend => 'Inserisci nuovi dati per modificare il piatto selezionato',
                      svalue => 'Modifica',
                      sname => 'mod-piatto'
                     );
               
      my %oldData = (name => $newNome,
                     numero => $newNumero,
                     prezzo => $newPrezzo,
                     descrizione => $newDesc
                     );

   
      printFormCibo($q, 'Ops! Ci sono degli errori nei dati inseriti:', $error, \%textForm, \%oldData);
   }
   
   else {
      my $doc = initLibXML();
      $doc->findnodes("menu/cibo/portata/piatto[\@id = '$oldId']/nome/text()")->get_node(1)->setData($newNome);
      $doc->findnodes("menu/cibo/portata/piatto[\@id = '$oldId']/prezzo/text()")->get_node(1)->setData($newPrezzo);
      
      if ($doc->findnodes("menu/cibo/portata/piatto[\@id = '$oldId']/descrizione") ne '') {
            # Distruggo nodo <descrizione>
            my ($description) = $doc->findnodes("menu/cibo//piatto[\@id = '$oldId']/descrizione");
                  $description->unbindNode;
         
         if ($newDesc ne '') { # aggiorno nodo <descrizione> (ricostruendolo)
         
            my $description = "<descrizione>$newDesc</descrizione>";
            my $parser = XML::LibXML->new(); 
            
            if (eval{$description=$parser->parse_balanced_chunk($description);}) {
               my $padre = $doc->findnodes("menu/cibo//piatto[\@id = '$oldId']");
               if($padre){
                  $padre->get_node(1)->appendChild($description) || die('Non riesco a trovare il padre');
               }
            } else {
               $error.="<li>I campi dati devono contenere tag html validi</li>";
            }
         }
      }
      else { # non esiste nodo <descrizione>
         
         if ($newDesc ne '') { # costruisco nodo <descrizione>

            my $description = "<descrizione>$newDesc</descrizione>";
            my $parser = XML::LibXML->new(); 
            
            if (eval{$description=$parser->parse_balanced_chunk($description);}) {
               my $padre = $doc->findnodes("menu/cibo//piatto[\@id = '$oldId']");
               if($padre){
               $padre->get_node(1)->appendChild($description) || die('Non riesco a trovare il padre');
               }
            } else {
               $error.="<li>I campi dati devono contenere tag html validi</li>";
            }
         }
      }
      
      
      # Aggiorno per ultimo l'id
      my ($node) = $doc->findnodes("menu/cibo//piatto/\@id[.='$oldId']");
      $node->setValue($newId);
      
      writeFile($doc);
      
      my %textForm = (htitle => 'Modifica piatto: ',
                      toggetto => $newNome,
                      hfile => 'mod-piatto.cgi',
                      hlegend => 'Inserisci nuovi dati per modificare il piatto selezionato',
                      svalue => 'Modifica',
                      sname => 'mod-piatto'
                     );
               
      my %oldData = (name => $newNome,
                     numero => $newNumero,
                     prezzo => $newPrezzo,
                     descrizione => $newDesc
                     );
      
      printFormCibo($q, 'Modifiche effettuate con successo!', $error, \%textForm, \%oldData);
   } 
}

elsif ($q->param('mod')) {

      # Raccolgo parametri:
      my $oldNome = $q->param('nome');
      my $oldNumero = $q->param('mumero');
      my $oldPrezzo = $q->param('prezzo');
      my $oldDesc = $q->param('descrizione');

      my %textForm = (htitle => 'Modifica piatto: ',
                      toggetto => $oldNome,
                      hfile => 'mod-piatto.cgi',
                      hlegend => 'Inserisci nuovi dati per modificare il piatto selezionato',
                      svalue => 'Modifica',
                      sname => 'mod-piatto'
                     );
               
      my %oldData = (name => $oldNome,
                     numero => $oldNumero,
                     prezzo => $oldPrezzo,
                     descrizione => $oldDesc
                     );

      printFormCibo($q, 'Attenzione! Una volta confermate le modifiche non sarà possibile tornare indietro.', '', \%textForm, \%oldData);
}

else {
   print "<div class='panel'>
            <h3>Ops!</h3>
            <p>Per accedere a questa pagina è necessario passare per la pagina <a href='private-menu-cibi.cgi'>Menù cibi</a></p>
         <div>
         ";
}

printEndHtml($q);


#------------------Sub-------

exit 0;
