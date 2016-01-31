#!\Perl64\bin\perl

use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use Encode qw(decode encode);

use My::Base;
use My::Operation;

my $session = CGI::Session->load() or die $!;

checkSession($session);

my $q = new CGI;
my $path = "Modifica bevanda";
my $breadcrump = "<a href='private-menu.cgi'>Menù categorie</a> &gt;&gt; <a href='private-menu-cibi.cgi'>Menù cibi</a> &gt;&gt; Modifica bevanda";

printStartHtml('Modifica bevanda - Area Riservata', $breadcrump);

# Verifica parametri
if ($q->param('mod-bevanda')) {

   #print "<p>Parametri da inserire: ".$q->param('nome')."-".$q->param('prezzo')."-".$q->param('descrizione')."</p>";

   my $error = '';
   
   # Dati generali
   my $idLista = $q->param('idLista');
   my $nomeLista = $q->param('nomeLista');
   my $oldId = $q->param('idElemento'); # Campo hidden vecchio
   
   # Dati nuovi
   my $newNome = $q->param('nome');
      $error .= checkNome($newNome);
      
   my $newPrezzo = $q->param('prezzo');
      $error .= checkPrezzo($newPrezzo);
   my $newDesc = $q->param('descrizione');
      $error .= checkDesc($newDesc);
      
   my $newId = toCamelCase($newNome);
      if ($newId ne $oldId) { # Il controllo sull'id è fatto solo se questo risulta diverso dal vecchio
         $error .= checkIdBevanda($newId);
      }
   
   
   if ($error ne '') { # Se ci sono degli errori
      
      my %textForm = (htitle => 'Modifica bevanda: ',
                      toggetto => $newNome,
                      hfile => 'mod-bevanda.cgi',
                      hlegend => 'Inserisci nuovi dati per modificare la bevanda selezionata',
                      svalue => 'Modifica',
                      sname => 'mod-bevanda'
                     );
   
      my %oldData = (name => $newNome,
                     prezzo => $newPrezzo,
                     descrizione => $newDesc
                     );
   
      printFormBevanda($q, 'Ops! Ci sono degli errori nei dati inseriti:', $error, \%textForm, \%oldData);
   }
   
   else {
      my $doc = My::Base::initLibXML();
      $doc->findnodes("menu/bevande/listaBevande/bevanda[\@id = '$oldId']/nome/text()")->get_node(1)->setData($newNome);
      $doc->findnodes("menu/bevande/listaBevande/bevanda[\@id = '$oldId']/prezzo/text()")->get_node(1)->setData($newPrezzo);
      
      if ($doc->findnodes("menu/bevande/listaBevande/bevanda[\@id = '$oldId']/descrizione") ne '') {
            # Distruggo nodo <descrizione>
            my ($description) = $doc->findnodes("menu/bevande//bevanda[\@id = '$oldId']/descrizione");
                  $description->unbindNode;
         
         if ($newDesc ne '') { # aggiorno nodo <descrizione> (ricostruendolo)
         
            my $description = "<descrizione>$newDesc</descrizione>";
            my $parser = XML::LibXML->new(); 
            
            if (eval{$description=$parser->parse_balanced_chunk($description);}) {
               my $padre = $doc->findnodes("menu/bevande//bevanda[\@id = '$oldId']");
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
               my $padre = $doc->findnodes("menu/bevande//bevanda[\@id = '$oldId']");
               if($padre){
               $padre->get_node(1)->appendChild($description) || die('Non riesco a trovare il padre');
               }
            } else {
               $error.="<li>I campi dati devono contenere tag html validi</li>";
            }
         }
      }
      
      
      # Aggiorno per ultimo l'id
      my ($node) = $doc->findnodes("menu/bevande//bevanda/\@id[.='$oldId']");
      $node->setValue($newId);
      
      My::Base::writeFile($doc);
      
      #print "modifiche effettuate";
      
      my %textForm = (htitle => 'Modifica bevanda: ',
                      toggetto => $newNome,
                      hfile => 'mod-bevanda.cgi',
                      hlegend => 'Inserisci nuovi dati per modificare la bevanda selezionata',
                      svalue => 'Modifica',
                      sname => 'mod-bevanda'
                     );
   
      my %oldData = (name => $newNome,
                     prezzo => $newPrezzo,
                     descrizione => $newDesc
                     );
      
      printFormBevanda($q, 'Modifiche effettuate con successo!', $error, \%textForm, \%oldData);
   } 
}

elsif ($q->param('mod')) {

      # Raccolgo parametri:
      my $oldNome = $q->param('nome');
      my $oldPrezzo = $q->param('prezzo');
      my $oldDesc = $q->param('descrizione');

      my %textForm = (htitle => 'Modifica bevanda: ',
                      toggetto => $oldNome,
                      hfile => 'mod-bevanda.cgi',
                      hlegend => 'Inserisci nuovi dati per modificare la bevanda selezionata',
                      svalue => 'Modifica',
                      sname => 'mod-bevanda'
                     );
               
      my %oldData = (name => $oldNome,
                     prezzo => $oldPrezzo,
                     descrizione => $oldDesc
                     );

      printFormBevanda($q, 'Attenzione! Una volta confermate le modifiche non sarà possibile tornare indietro.', '', \%textForm, \%oldData);
}

else { 
   # Se si ha la sessione aperta e si ha il link diretto alla pagina
   print "<div class='panel'>
            <h3>Ops!</h3>
            <p>Per accedere a questa pagina è necessario passare per la pagina <a href='private-menu-cibi.cgi'>Menù cibi</a></p>
         <div>
         ";
}

printEndHtml();

#------------------------------------------------------------------------------


exit 0;
