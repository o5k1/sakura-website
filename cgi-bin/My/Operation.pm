#
# Modulo che raggruppa tutte le funzioni per stampare form del tipo ADD e MOD e relativi check dei parametri via cgi
#
use strict;
use warnings;
use My::Base;

   package My::Operation;

use Exporter qw(import);
our @EXPORT = qw(printFormCibo printFormBevanda checkDelete checkNome checkNumero checkPrezzo checkDesc checkIdBevanda checkIdPiatto toCamelCase); # Indicare i metodi da esportare

#------------------------------SEZIONE-CIBI----------------------------------------------------

#
sub printFormCibo { # stampo la form

   my ($q, $info, $error, $textForm, $add, $oldData) = @_;
   my $nomeLista = $q->param('nomeLista');  # nome portata
   my $idLista = $q->param('idLista');      # id portata
   my $idElemento = $q->param('identifier');
   
   my $href = "private-menu-cibi.cgi"; # Fisso
   my $hfile = $textForm->{hfile};
   my $toggetto = $textForm->{toggetto};
   my $hoggetto = "piatto";
   my $htitle = $textForm->{htitle}.$toggetto; # Cambia in base a quale lista ha premuto il pulsante ADD
   my $hlegend = $textForm->{hlegend}; # Cambia in base a quale lista ha premuto il pulsante ADD

   #print $q->a({-href => $href},'Torna al menù');

   print "<div class='form'>";


   if ($info ne '') {
      print "<p class='allright'>$info</p>";
            if($info eq 'Inserimento effettuato con successo!') {
               print "<p><a href='private-menu-cibi.cgi'>Torna indietro</a></p>";
            }
            elsif ($info eq 'Modifiche effettuate con successo!') {
               print "<p><a href='private-menu-cibi.cgi'>Torna indietro</a></p>";
            }
   }
   
   if ($error ne '') {
      print "
            <ul class='errorList'>
               $error
             </ul>
             ";
   }
   
   print "<h3>$htitle</h3>";

   My::Base::printStartFormJS($textForm->{sname}."-in", $hfile, 'post');
      print "<fieldset>";
               #<legend>$hlegend</legend>";

   if ($add) {
      print "<p>";
         print "<label id='identifier' for='inputId'>Id $hoggetto <span class='errorjs'></span></label>";
         print "<input id='inputId' type='text' name='identifier' value='".($oldData->{identifier})."' />";
      print "</p>";
   }
      print "<p>";
         print "<label id='nome' for='inputNome'>Nome $hoggetto <span class='errorjs'></span></label>";
         print $q->textarea(-id => 'inputNome', -name => 'nome', -value => $oldData->{name}, -cols => 20, -rows => 2);
      print "</p>";
      
      print "<p>";
         print "<label id='numero' for='inputNumero'>Numero <span class='errorjs'></span></label>";
         print "<input id='inputNumero' type='text' name='numero' value='".($oldData->{numero})."' />";
      print "</p>";
      
      print "<p>";
         print "<label id='prezzo' for='inputPrezzo'>Prezzo (&euro;) <span class='errorjs'></span></label>";
         print "<input id='inputPrezzo' type='text' name='prezzo' value='".($oldData->{prezzo})."' />";
      print "</p>";
      
      print "<p>";
         #print $q->label({-id => 'descrizione'}, 'Descrizione');
         print "<label id='descrizione' for='inputDesc'>Descrizione <span class='errorjs'></span></label>";
         print $q->textarea(-id => 'inputDesc', -name => 'descrizione', -value => $oldData->{descrizione}, -cols => 20, -rows => 2);
      print "</p>";

      print $q->hidden(-name => 'idElemento',
                        -value => $idElemento);
      
      print $q->hidden(-name => 'nomeLista',
                        -value => $nomeLista);
      print $q->hidden(-name => 'idLista',
                        -value => $idLista);
               
      print $q->submit(
         -id => 'submit',
         -name => ($textForm->{sname})."-in",
         -value => $textForm->{svalue}
         );

      print "</fieldset>";
      
   My::Base::printEndForm();
   
print "</div>";

}




#-----------------------------SEZIONE-BEVANDE--------------------------------------------------

#
sub printFormBevanda {

   my ($q, $info, $error, $textForm, $add, $oldData) = @_;
   my $nomeLista = $q->param('nomeLista');
   my $idLista = $q->param('idLista');
   my $idBevanda = $q->param('identifier');
   
   my $href = "private-menu-bevande.cgi"; # Fisso
   my $hfile = $textForm->{hfile};
   my $toggetto = $textForm->{toggetto};
   
   my $hoggetto = "bevanda";
      if($nomeLista eq 'Vini') {
         $hoggetto = "vino";
      } elsif($nomeLista eq 'Birre') {
         $hoggetto = "birra";
      }
   
   my $htitle = $textForm->{htitle}.$toggetto; # Cambia in base a quale lista ha premuto il pulsante ADD
   my $hlegend = $textForm->{hlegend}; # Cambia in base a quale lista ha premuto il pulsante ADD

   #print $q->a({-href => $href},'Torna al menù');

   print "<div class='form'>";
   
   if ($info ne '') {
      print "<p class='allright'>$info</p>";
         if($info eq 'Inserimento effettuato con successo!') {
            print "<p><a href='private-menu-bevande.cgi'>Torna indietro</a></p>";
         }
         elsif ($info eq 'Modifiche effettuate con successo!') {
            print "<p><a href='private-menu-bevande.cgi'>Torna indietro</a></p>";
         }
   }
   
   if ($error ne '') {
      print "
            <ul class='errorList'>
               $error
             </ul>
             ";
   }
   
   print $q->h3($htitle);

   My::Base::printStartFormJS($textForm->{sname}."-in", $hfile, 'post');
      print "<fieldset>";
               #<legend>$hlegend</legend>";

   if ($add) {
      print "<p>";
         print "<label id='identifier' for='inputId'>Id $hoggetto <span class='errorjs'></span></label>";
         print "<input id='inputId' type='text' name='identifier' value='".($oldData->{identifier})."' />";
      print "</p>";
   }
      print "<p>";
         print "<label id='nome' for='inputNome'>Nome $hoggetto <span class='errorjs'></span></label>";
         print $q->textarea(-id => 'inputNome', -name => 'nome', -value => $oldData->{name}, -cols => 20, -rows => 2);
      print "</p>";
      
      print "<p>";
         print "<label id='prezzo' for='inputPrezzo'>Prezzo (&euro;) <span class='errorjs'></span></label>";
         print "<input id='inputPrezzo' type='text' name='prezzo' value='".($oldData->{prezzo})."' />";
      print "</p>";
      
      print "<p>";
         print "<label id='descrizione' for='inputDesc'>Descrizione <span class='errorjs'></span></label>";
         print $q->textarea(-id => 'inputDesc', -name => 'descrizione', -value => $oldData->{descrizione}, -cols => 20, -rows => 2);
      print "</p>";
      
      print $q->hidden(-name => 'idElemento',
                        -value => $idBevanda);
      
      print $q->hidden(-name => 'nomeLista',
                        -value => $nomeLista);
      print $q->hidden(-name => 'idLista',
                        -value => $idLista);
               
      print $q->submit(
         -id => 'submit',
         -name => ($textForm->{sname})."-in",
         -value => $textForm->{svalue}
         );

      print "</fieldset>";
      
   My::Base::printEndForm();

print "</div>";
}


#-------------CHECK-PARAM--------------------------------------

#
sub checkDelete{

   my $q = $_[0];
   my $query = $_[1]; # cibo/portata/piatto , bevande/listaVini/vino , bevande/listaBirre/birra , bevande/listaAltreBevande/bevanda    
      if($query eq '') {die ('My::Base::checkDelete() necessita del parametro query');}

   if ($q->param('del')){
      
      my $idElemento = $q->param('idElemento');
      my $nome = $q->param('nome');
      
      if (My::Base::existElement("menu/".$query."[\@id = '$idElemento']")) {
         
         my $doc = My::Base::initLibXML();
         my ($element) = $doc->findnodes("menu/".$query."[\@id = '$idElemento']");
            $element->unbindNode;
            
         My::Base::writeFile($doc);
      
         return "<p class='allright'>Rimozione di '$nome' effettuata con successo.</p>";
      }
      else {
      
         return "<p class='error'>Nessuna corrispondenza di '$nome' nel database, nessuna rimozione effettuata. ($query - $idElemento)</p>" # Debug
      }
   }
}

#
sub checkNome{
    my $ret="";
    if(!$_[0]){
        $ret=$ret."<li>Il campo nome non deve essere vuoto.</li>";
    }
    if(length $_[0]>200) {
      $ret=$ret."<li>Il campo nome non deve superare i 200 caratteri.</li>";
    }
    if ($_[0] =~ m/<\//) { # Se trova tracce di tag
      if(!($_[0] =~ m/.{0,}<abbr title=".{1,}"(\s)?(xml\:lang="..")?>.{1,}<\/abbr>.{0,}/) &&
            !($_[0] =~ m/.{0,}<span xml:lang="..">.{1,}<\/span>.{0,}/)) {
         $ret=$ret."<li>Il nome deve contenere tag abbr e span ben formati (attenzione agli spazi superflui)</li>";
      }
    }
    return $ret;
}

#
sub checkNumero {
   my $ret="";
   if($_[0] eq ""){
      $ret=$ret."<li>Il campo numero piatto non deve essere vuoto.</li>";
   }
   if(!($_[0] =~ m/^[1-9]{1}[0-9]{0,2}[a-z]{0,1}$/)){
      $ret=$ret."<li>Il campo numero piatto deve essere costituito da un numero (obbligatorio) e una lettera (opzionale).</li>";
   }
}

#
sub checkPrezzo{
    my $ret="";
    if(!$_[0] || !($_[0] =~ m/^[0-9]{1}[0-9]{0,3}\.[0-9]{2}/)){
         $ret=$ret."<li>Il campo prezzo deve contenere un numero seguito dal punto e 2 cifre decimali.</li>";
    }
    return $ret;
}

#
sub checkDesc{
    my $ret="";
    if(length $_[0]>600){
        $ret=$ret."<li>La descrizione deve avere al massimo 600 caratteri.</li>";
    }
    if ($_[0] =~ m/<\//) {
      if(!($_[0] =~ m/.{0,}<abbr title=".{1,}"(\s)?(xml\:lang="..")?>.{1,}<\/abbr>.{0,}/) &&
            !($_[0] =~ m/.{0,}<span xml:lang="..">.{1,}<\/span>.{0,}/)) {
         $ret=$ret."<li>Il campo descrizione deve contenere tag abbr e span ben formati (attenzione agli spazi superflui)</li>";
      }
    }
    return $ret;
}

#
sub checkIdBevanda{
   my $ret="";
   my $id = $_[0];
   if($_[0] eq ""){
      $ret=$ret."<li>Il campo id non deve essere vuoto.</li>";
   }
   if(My::Base::existElement("//bevanda[\@id = '$id']")) {
         
         $ret=$ret."<li>L'id inserito esiste già.</li>";
   }
   if(!($id =~ m/^[A-Za-z]{1,}$/m)) {
         $ret=$ret."<li>L'id deve essere una parola composta da lettere maiuscole e/o minuscole, numeri senza spazi.</li>"
   }
   if(length $_[0]>50){
        $ret=$ret."<li>L'id non deve superare i 50 caratteri</li>";
   }
   return $ret;
}

#
sub checkIdPiatto{
   my $ret="";
   my $id = $_[0];
   if($_[0] eq ""){
      $ret=$ret."<li>Il campo id non deve essere vuoto.</li>";
   }
   if(My::Base::existElement("//piatto[\@id = '$id']")) {
         
         $ret=$ret."<li>L'id inserito esiste già.</li>";
   }
   if(!($id =~ m/^[A-Za-z]{1,}$/m)) {
         $ret=$ret."<li>L'id deve essere una parola composta da lettere maiuscole e/o minuscole e nessuno spazio.</li>"
   }
   if(length $_[0]>50){
        $ret=$ret."<li>L'id non deve superare i 50 caratteri</li>";
    }
   return $ret;    
}

# Prende in input una stringa e la trasforma in CamelCase
sub toCamelCase{
   my $stringa = $_[0];
      $stringa =~ s/(?<!['])(\w+)/\u\1/g; # Mette in CamelCase la stringa
      $stringa =~ s/\s//g; # Toglie gli spazi dalla stringa
   return $stringa;
}


1;
