#!\Perl64\bin\perl

use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use Encode qw(decode encode);

use My::Base;
use My::Operation;

my $q = new CGI;
my $session = CGI::Session->load() or die $!;

checkSession($session);

printStartHtml('Aggiungi bevanda - Area Riservata');

# Che listaBevande ha chiamato AGGIUNGI?
my $toggetto = "bevanda";
      if($q->param('nomeLista') eq 'Vini') {
         $toggetto = "vino";
      } elsif($q->param('nomeLista') eq 'Birre') {
         $toggetto = "birra";
      }

my %textForm = (htitle => 'Aggiungi ',
                toggetto => $toggetto,
                hfile => 'add-bevanda.cgi',
                hlegend => 'Inserisci nuovi dati per aggiungere una bevanda',
                svalue => 'Aggiungi',
                sname => 'add-bevanda'
               );


# Verifica parametri
if ($q->param('add-bevanda')) {

    print "<p>Parametri da inserire: ".$q->param('nome')."-".$q->param('prezzo')."-".$q->param('descrizione')."</p>";

   my $error = '';
   
   my $nome = $q->param('nome');
      $error .= checkNome($nome);
   my $prezzo = $q->param('prezzo');
      $error .= checkPrezzo($prezzo);
   my $descrizione = $q->param('descrizione');
      $error .= checkDesc($descrizione);
   my $id = toCamelCase($nome);
      $error .= checkIdBevanda($id);
   my $idLista = $q->param('idLista');
   my $nomeLista = $q->param('nomeLista');
   
   if ($error ne '') {
      printFormBevanda($q, 'Ops! Ci sono degli errori nei dati inseriti:', $error, \%textForm);
   }
   else {
      my $doc = My::Base::initLibXML();
      my $padre = $doc->findnodes("menu/bevande/listaBevande[\@id = '$idLista']");

      my $element = "<bevanda id='$id'>
                     <nome>$nome</nome>
                     <prezzo>$prezzo</prezzo>
                     ";
      if ($descrizione ne '') {
         $element = $element."<descrizione>$descrizione</descrizione>
         ";
      }
      $element = $element."
      </bevanda>
      ";

      if ($padre) {
         my $nodo;
         my $parser = XML::LibXML->new(); 
         
         if (eval{$nodo=$parser->parse_balanced_chunk($element);}) {
            $padre->get_node(1)->appendChild($nodo) || die('Non riesco a trovare il padre');
         }
         else {
            $error.="<li>I campi dati devono contenere tag html corretti</li>";
         }
         
         My::Base::writeFile($doc)
      }
      
      printFormBevanda($q, 'Inserimento effettuato con successo!', $error, \%textForm);
   } 
}
elsif($q->param('idLista')) {

   printFormBevanda($q, '', '', \%textForm);
   
} else {
   print $session->header(-location=>"../public-html/accesso-negato.html");
}

printEndHtml();

exit 0;
