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

my $q = new CGI; # Sarà il parametro $_[0] di ogni funzione

my $nomePortata = $q->param('nomeLista');

my %textForm = (htitle => 'Aggiungi ',
                toggetto => $nomePortata,
                hfile => 'add-piatto.cgi',
                hlegend => 'Inserisci nuovi dati per aggiungere un piatto',
                svalue => 'Aggiungi',
                sname => 'add-piatto'
               );
my $path = "Aggiungi Piatto";

my $breadcrump = "<a href='private-menu.cgi'>Menù categorie</a> &gt;&gt; <a href='private-menu-cibi.cgi'>Menù cibi</a> &gt;&gt; Aggiungi piatto";

printStartHtml('Aggiungi Piatto - Area Riservata', $breadcrump);

# Verifica parametri
if ($q->param('add-piatto')) {

   #print "<p>Parametri da inserire: ".$q->param('nome')."-".$q->param('prezzo')."-".$q->param('descrizione')."</p>";
   
   my $error = '';
   
   my $nome = $q->param('nome');
      $error .= checkNome($nome);
   my $numero = $q->param('numero');
      $error .= checkNumero($numero);
   my $prezzo = $q->param('prezzo');
      $error .= checkPrezzo($prezzo);
   my $descrizione = $q->param('descrizione');
      $error .= checkDesc($descrizione);
   my $id = toCamelCase($nome);
      $error .= checkIdPiatto($id);
   my $idPortata = $q->param('idLista');
   my $nomePortata = $q->param('nomeLista');

   if ($error ne '') {
      printFormCibo($q, 'Ops! Ci sono degli errori nei dati inseriti:', $error, \%textForm);
   }
   else {
      my $doc = initLibXML();
      my $padre = $doc->findnodes("menu/cibo/portata[\@id = '$idPortata']");

      my $element = "<piatto id='$id'>
                     <nome>$nome</nome>
                     <numero>$numero</numero>
                     <prezzo>$prezzo</prezzo>
                     ";
      if ($descrizione ne '') {
         $element = $element."<descrizione>$descrizione</descrizione>
         ";
      }
      $element = $element."</piatto>
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
      
      printFormCibo($q, 'Inserimento effettuato con successo!', $error, \%textForm);
   }     
}
elsif($q->param('idLista')) {

    printFormCibo($q, '', '', \%textForm);
    
} else {
   print "<div class='panel'>
            <h3>Ops!</h3>
            <p>Per accedere a questa pagina è necessario passare per la pagina <a href='private-menu-cibi.cgi'>Menù cibi</a></p>
         <div>
         ";
}

printEndHtml();


exit 0;
