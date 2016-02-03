function manageNav() {
	if (screen.width < 1024) {
	   var nav = document.getElementById("nav-menu");
	    if (nav.className == "") {
	    	nav.className = "hidden";
        }
	    else {
           nav.className = "";
        }
	}
}

function manageMenu(portata) {
	var section = document.getElementById(portata);
	if (section.className == "portata") {
	    section.className = "hidden";
    }
	else {
	    section.className = "portata";
    }
}


function hideElement() {
   var fastSearch = document.getElementById('fast-search');
   var endList = document.getElementsByClassName('end-list');

   if (fastSearch && endList) {
      fastSearch.className += " hidden";

      var i;

      for (i = 0; i < endList.length; i++) {
         endList[i].className += " hidden";
      }

      var portate = document.getElementsByClassName('portata');

      for (i = 0; i < portate.length; i++) {
         portate[i].className += " hidden";
      }

      var listeBevande = document.getElementsByClassName('listaBevande');

      for (i = 0; i < listeBevande.length; i++) {
         listeBevande[i].className += " hidden";
      }
   }
}


function checkLogin() {
   // prelevo parametri
   var user = document.login.username.value;
   var pass = document.login.password.value;

   var error = document.getElementById('error');

   if(user == "" && pass == "") {
      error.innerHTML = "I campi segnati da <span class='error'>*</span> non possono essere vuoti.";
      var userLabel = document.getElementById('user');
      var passLabel = document.getElementById('pass');

      userLabel.innerHTML = "Username <span class='error'>*</span>";
      passLabel.innerHTML = "Password <span class='error'>*</span>";

      return false;
   }
   else {
      return true;
   }
}


function checkForm() {

   if (document.getElementById('add-bevanda-in')) {
      //alert('checkAddBevanda()');
      return checkFormBevanda();
   }
   else if (document.getElementById('add-piatto-in')) {
      //alert('checkAddPiatto()');
      return checkFormPiatto();
   }
   else if (document.getElementById('mod-bevanda-in')) {
      //alert('checkModBevanda()');
      return checkFormBevanda();
   }
   else if (document.getElementById('mod-piatto-in')) {
      //alert('checkModPiatto()');
      return checkFormPiatto();
   }
   else {
      //alert('NO');
      return false;
   }
}

function checkFormBevanda() {
   var error = 0;

   // seleziono campo form
   var nome = document.getElementsByName('nome')[0];
   var prezzo = document.getElementsByName('prezzo')[0];
   //var descrizione = document.getElementsByName('descrizione')[0];

   // recupero la label del campo form
   var nomeLabel = document.getElementById('nome');
   var prezzoLabel = document.getElementById('prezzo');
   //var descLabel = document.getElementById('descrizione');

   if (nome.value === undefined) { // controllo dati inseriti
      error = 1;
      nomeLabel.lastChild.innerHTML = "- <span class='error'>Titolo vuoto</span>";
   }
   else {
      nomeLabel.lastChild.innerHTML = "";
   }

   if (prezzo.value === undefined || prezzo.value.search(/^[0-9]{1}[0-9]{0,3},[0-9]{2}/) != 0) {
      error = 1;
      prezzoLabel.lastChild.innerHTML = "- <span class='error'>Prezzo non valido (numero seguito da virgola e 2 cifre decimali)</span>";
   }
   else {
      prezzoLabel.lastChild.innerHTML = "";
   }

   if(error){
      alert('Dati inseriti errati! Correggi i dati inseriti nell\'area indicate con il rosso.');
      return false;
   }
   else {
     return true;
   }
   return true;
}



function checkFormPiatto() {
    var error = 0;

   // seleziono campo form
   //var id =
   var nome = document.getElementsByName('nome')[0];
   var numero = document.getElementsByName('numero')[0];
   var prezzo = document.getElementsByName('prezzo')[0];
   //var descrizione = document.getElementsByName('descrizione')[0];

   // recupero la label del campo form
   //var idLabel =
   var nomeLabel = document.getElementById('nome');
   var numeroLabel = document.getElementById('numero');
   var prezzoLabel = document.getElementById('prezzo');
   //var descLabel = document.getElementById('descrizione');


   if (nome.value == "") { // controllo dati inseriti
      error = 1;
      nomeLabel.lastChild.innerHTML = "- <span class='error'>Titolo vuoto</span>";
   }
   else {
      nomeLabel.lastChild.innerHTML = "";
   }

   if (numero.value == "" || numero.value.search(/^[0-9]{1}[0-9]{0,2}[a-z]{0,1}$/) != 0) {
      error = 1;
      numeroLabel.lastChild.innerHTML = "- <span class='error'>Prezzo non valido (numero seguito da virgola e 2 cifre decimali)</span>";
   }
   else {
      numeroLabel.lastChild.innerHTML = "";
   }

   if (prezzo.value == "" || prezzo.value.search(/^[0-9]{1}[0-9]{0,3},[0-9]{2}/) != 0) {
      error = 1;
      prezzoLabel.lastChild.innerHTML = "- <span class='error'>Prezzo non valido (numero seguito da virgola e 2 cifre decimali)</span>";
   }
   else {
      prezzoLabel.lastChild.innerHTML = "";
   }

   if(error){
      alert('Dati inseriti errati! Correggi i dati inseriti nell\'area indicate con il rosso.');
      return false;
   }
   else {
      return true;
   }

}
