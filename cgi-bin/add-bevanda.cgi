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
                hlegend => 'Nuova bevanda',
                svalue => 'Aggiungi',
                sname => 'add-bevanda'
               );
#my $path = "Aggiungi Bevanda";

my $breadcrump = "<a href='private-menu-bevande.cgi'>Menù bevande</a> &gt; Aggiungi bevanda";

printStartHtml('Aggiungi bevanda - Area Amministratore', $breadcrump);

# Verifica parametri
if ($q->param('add-bevanda-in')) {

    #print "<p>Parametri da inserire: ".$q->param('identifier')."-".$q->param('nome')."-".$q->param('prezzo')."-".$q->param('descrizione')."</p>";

   my $error = '';
   
   my $nome = $q->param('nome');
      $error .= checkNome($nome);
   my $prezzo = $q->param('prezzo');
      $error .= checkPrezzo($prezzo);
   my $descrizione = $q->param('descrizione');
      $error .= checkDesc($descrizione);
   my $id = $q->param('identifier');
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
            My::Base::writeFile($doc)
         }
         else {
            $error.="<li>I campi dati devono contenere tag html corretti.</li>";
         }
      }
      
      my $info = '';

      if ($error eq '') {
        $info = 'Inserimento effettuato con successo!';
      }


      printFormBevanda($q, $info, $error, \%textForm);
   } 
}
elsif($q->param('idLista')) {

   printFormBevanda($q, '', '', \%textForm);
   
} else {
   print "<div class='panel'>
            <h3>Ops!</h3>
            <p>Per accedere a questa pagina è necessario passare per la pagina <a href='private-menu-bevande.cgi'>Menù bevande</a></p>
         <div>
         ";
}

printEndHtml();

exit 0;
