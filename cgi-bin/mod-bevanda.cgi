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
#my $path = "Modifica bevanda";
my $breadcrump = "<a href='private-menu-bevande.cgi'>Menù bevande</a> &gt; Modifica bevanda";

printStartHtml('Modifica bevanda - Area Amministratore', $breadcrump);

# Verifica parametri
if ($q->param('mod-bevanda-in')) {

   #print "<p>Parametri da inserire: ".$q->param('identifier')."-".$q->param('nome')."-".$q->param('prezzo')."-".$q->param('descrizione')."</p>";

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
   
   
   if ($error ne '') { # Se ci sono degli errori
      
      my %textForm = (htitle => 'Modifica bevanda: ',
                      toggetto => $newNome,
                      hfile => 'mod-bevanda.cgi',
                      hlegend => 'Modifica bevanda',
                      svalue => 'Modifica',
                      sname => 'mod-bevanda'
                     );
   
      my %oldData = (id => $oldId,
                     name => $newNome,
                     prezzo => $newPrezzo,
                     descrizione => $newDesc
                     );
   
      printFormBevanda($q, 'Ops! Ci sono degli errori nei dati inseriti:', $error, \%textForm, 0, \%oldData);
   }
   
   else {
      my $doc = My::Base::initLibXML();
      my $parser = XML::LibXML->new();

      my ($nome) = $doc->findnodes("menu/bevande/listaBevande/bevanda[\@id = '$oldId']/nome");
         $nome->unbindNode;
      my ($prezzo) = $doc->findnodes("menu/bevande/listaBevande/bevanda[\@id = '$oldId']/prezzo");
         $prezzo->unbindNode;

      my $nodo = "<nome>$newNome</nome>
               <prezzo>$newPrezzo</prezzo>
               ";


      if (eval{$nodo=$parser->parse_balanced_chunk($nodo);}) {
               my $padre = $doc->findnodes("menu/bevande//bevanda[\@id = '$oldId']");
               if($padre){
                  $padre->get_node(1)->appendChild($nodo) || die('Non riesco a trovare il padre');
               }
      } else {
         $error.="<li>Il campo nome deve contenere tag o entità html validi.</li>";
      }

      
      if ($doc->findnodes("menu/bevande/listaBevande/bevanda[\@id = '$oldId']/descrizione") ne '') { # C'è descrizione
            # Distruggo nodo <descrizione>
            my ($description) = $doc->findnodes("menu/bevande//bevanda[\@id = '$oldId']/descrizione");
                  $description->unbindNode;
      }

      if ($newDesc ne '') { # aggiorno nodo <descrizione> (ricostruendolo)

            my $description = "<descrizione>$newDesc</descrizione>
                  ";
            
            if (eval{$description=$parser->parse_balanced_chunk($description);}) {
               my $padre = $doc->findnodes("menu/bevande//bevanda[\@id = '$oldId']");
               if($padre){
                  $padre->get_node(1)->appendChild($description) || die('Non riesco a trovare il padre');
               }
            } else {
               $error.="<li>I campi dati devono contenere tag html validi.</li>";
            }
      }

      if ($error eq '') {

         #$doc->findnodes("menu/bevande/listaBevande/bevanda[\@id = '$oldId']/prezzo/text()")->get_node(1)->setData($newPrezzo);

      My::Base::writeFile($doc);
      
      #print "modifiche effettuate";
      
      my %textForm = (htitle => 'Modifica bevanda: ',
                      toggetto => $newNome,
                      hfile => 'mod-bevanda.cgi',
                      hlegend => 'Modifica bevanda',
                      svalue => 'Modifica',
                      sname => 'mod-bevanda'
                     );
   
      my %oldData = (id => $oldId,
                     name => $newNome,
                     prezzo => $newPrezzo,
                     descrizione => $newDesc
                     );
      
      printFormBevanda($q, 'Modifiche effettuate con successo!', $error, \%textForm, 0, \%oldData);
      }
      else {
         my %textForm = (htitle => 'Modifica bevanda: ',
                      toggetto => $newNome,
                      hfile => 'mod-bevanda.cgi',
                      hlegend => 'Modifica bevanda',
                      svalue => 'Modifica',
                      sname => 'mod-bevanda'
                     );

      my %oldData = (identifier => $oldId,
                     name => $newNome,
                     prezzo => $newPrezzo,
                     descrizione => $newDesc
                     );


      printFormBevanda($q, 'Ops! Ci sono degli errori nei dati inseriti: ', $error, \%textForm, 0, \%oldData);
      }
   }
}

elsif ($q->param('mod')) {

      # Raccolgo parametri:
      my $oldId = $q->param('idElemento');
      my $oldNome = $q->param('nome');
      my $oldPrezzo = $q->param('prezzo');
      my $oldDesc = $q->param('descrizione');

      my %textForm = (htitle => 'Modifica bevanda: ',
                      toggetto => $oldNome,
                      hfile => 'mod-bevanda.cgi',
                      hlegend => 'Modifica bevanda',
                      svalue => 'Modifica',
                      sname => 'mod-bevanda'
                     );
               
      my %oldData = (id => $oldId,
                     name => $oldNome,
                     prezzo => $oldPrezzo,
                     descrizione => $oldDesc
                     );

      printFormBevanda($q, 'Attenzione! Una volta confermate le modifiche non sarà possibile tornare indietro.', '', \%textForm, 0, \%oldData);
}

else { 
   # Se si ha la sessione aperta e si ha il link diretto alla pagina
   print "<div class='panel'>
            <h3>Ops!</h3>
            <p>Per accedere a questa pagina è necessario passare per la pagina <a href='private-menu-bevande.cgi'>Menù bevande</a></p>
         <div>
         ";
}

printEndHtml();

#------------------------------------------------------------------------------


exit 0;
