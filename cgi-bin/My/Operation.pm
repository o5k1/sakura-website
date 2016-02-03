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

   my ($q, $info, $error, $textForm, $oldData) = @_;
   my $nomeLista = $q->param('nomeLista');  # nome portata
   my $idLista = $q->param('idLista');      # id portata
   my $idElemento = $q->param('idElemento');
   
   my $href = "private-menu-cibi.cgi"; # Fisso
   my $hfile = $textForm->{hfile};
   my $toggetto = $textForm->{toggetto};
   my $hoggetto = "piatto";
   my $htitle = $textForm->{htitle}.$toggetto; # Cambia in base a quale lista ha premuto il pulsante ADD
   my $hlegend = $textForm->{hlegend}; # Cambia in base a quale lista ha premuto il pulsante ADD

   #print $q->a({-href => $href},'Torna al menù');

   print "<div class='form'>";
   print $q->h3($htitle);
      
   if ($info ne '') {
      print "<p class='allright'>$info</p>";
            if($info eq 'Inserimento effettuato con successo!') {
               print "<a href='private-menu-cibi.cgi'>Torna indietro</a>";
            }
            elsif ($info eq 'Modifiche effettuate con successo!') {
               print "<a href='private-menu-cibi.cgi'>Torna indietro</a>";
            }
   }
   
   if ($error ne '') {
      print "<ul class='errorList'>
               $error
             </ul>";
   }
   
   My::Base::printStartFormJS($textForm->{sname}."-in", $hfile, 'post');
      print "<fieldset>";
               #<legend>$hlegend</legend>";

      print "<p>";
         #print $q->label({-id => 'nome'}, 'Nome '.$hoggetto);
         print "<label id='identifier'>Id $hoggetto <span class='errorjs'></span></label>";
         print "<input type='text' name='id' value='".$oldData->{identifier}."' />";
      print "</p>";

      print "<p>";
         #print $q->label({-id => 'nome'}, 'Nome '.$hoggetto);
         print "<label id='nome'>Nome $hoggetto <span class='errorjs'></span></label>";
         print $q->textarea(-name => 'nome', -value => $oldData->{name});
      print "</p>";
      
      print "<p>";
         #print $q->label({-id => 'numero'}, 'Numero piatto');
         print "<label id='numero'>Numero <span class='errorjs'></span></label>";
         print "<input type='text' name='numero' value='".$oldData->{numero}."' />";
      print "</p>";
      
      print "<p>";
         #print $q->label({-id => 'prezzo'}, 'Prezzo (&euro;)');
         print "<label id='prezzo'>Prezzo (&euro;) <span class='errorjs'></span></label>";
         print "<input type='text' name='prezzo' value='".$oldData->{prezzo}."' />";
      print "</p>";
      
      print "<p>";
         #print $q->label({-id => 'descrizione'}, 'Descrizione');
         print "<label id='descrizione'>Descrizione <span class='errorjs'></span></label>";
         print $q->textarea(-name => 'descrizione', -value => $oldData->{descrizione});
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

   print "</div>";
      
   My::Base::printEndForm();
   
}




#-----------------------------SEZIONE-BEVANDE--------------------------------------------------

#
sub printFormBevanda {

   my ($q, $info, $error, $textForm, $oldData) = @_;
   my $nomeLista = $q->param('nomeLista');
   my $idLista = $q->param('idLista');
   my $idBevanda = $q->param('idElemento');
   
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
   print $q->h3($htitle);
   
   if ($info ne '') {
      print "<p class='allright'>$info</p>";
      if($info eq 'Inserimento effettuato con successo!') {
         print "<a href='private-menu-bevande.cgi'>Torna indietro</a>";
      }
      elsif ($info eq 'Modifiche effettuate con successo!') {
               print "<a href='private-menu-bevande.cgi'>Torna indietro</a>";
            }
   }
   
   if ($error ne '') {
      print "<ul id='errorList'>
               $error
             </ul>";
   }
   
   My::Base::printStartFormJS($textForm->{sname}."-in", $hfile, 'post');
      print "<fieldset>";
               #<legend>$hlegend</legend>";

      print "<p>";
         #print $q->label({-id => 'nome'}, 'Nome '.$hoggetto);
         print "<label id='identifier'>Id $hoggetto <span class='errorjs'></span></label>";
         print "<input type='text' name='id' value='".$oldData->{identifier}."' />";
      print "</p>";

      print "<p>";
         #print $q->label({-id => 'nome'}, 'Nome '.$hoggetto);
         print "<label id='nome'>Nome $hoggetto <span class='errorjs'></span></label>";
         print $q->textarea(-name => 'nome', -value => $oldData->{name});
      print "</p>";
      
      print "<p>";
         #print $q->label({-id => 'prezzo'}, 'Prezzo (&euro;)');
         print "<label id='prezzo'>Prezzo (&euro;) <span class='errorjs'></span></label>";
         print "<input type='text' name='prezzo' value='".$oldData->{prezzo}."' />";
      print "</p>";
      
      print "<p>";
         #print $q->label({-id => 'descrizione'}, 'Descrizione');
         print "<label id='descrizione'>Descrizione <span class='errorjs'></span></label>";
         print $q->textarea(-name => 'descrizione', -value => $oldData->{descrizione});
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

   print "</div>";
      
   My::Base::printEndForm();
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
      
         return "<p class='error'>Nessuna corrispondenza di '$nome' nel database, nessuna rimozione effettuata. ($query)</p>" # Debug
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
    return $ret;
}

sub checkNumero {
   my $ret="";
   if(!$_[0]){
      $ret=$ret."<li>Il campo numero piatto non deve essere vuoto.</li>";
   }
   if(!($_[0] =~ m/^[0-9]{1}[0-9]{0,2}[a-z]{0,1}$/)){
      $ret=$ret."<li>Il campo numero piatto deve essere costituito da un numero (obbligatorio) e una lettera (opzionale).</li>";
   }
}

sub checkPrezzo{
    my $ret="";
    if(!$_[0] || !($_[0] =~ m/^[0-9]{1}[0-9]{0,3},[0-9]{2}/)){
         $ret=$ret."<li>Il campo prezzo deve contenere un numero seguito dalla virgola e 2 cifre decimali.</li>";
    }
    return $ret;
}

sub checkDesc{
    my $ret="";
    if(length $_[0]>800){
        $ret=$ret."<li>La descrizione deve avere al massimo 800 caratteri.</li>";
    }
    return $ret;
}

#
sub checkIdBevanda{
   my $ret="";
   my $id = $_[0];
   if(My::Base::existElement("//vino[\@id = '$id']") || 
         My::Base::existElement("//birra[\@id = '$id']") ||
            My::Base::existElement("//bevanda[\@id = '$id']") ) {
         
         $ret=$ret."<li>Il nome inserito esiste già.</li>";
   }
   return $ret;
}

#
sub checkIdPiatto{
   my $ret="";
   my $id = $_[0];
   if(My::Base::existElement("//piatto[\@id = '$id']")) {
         
         $ret=$ret."<li>Il nome inserito esiste già.</li>";
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
