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
      error.innerHTML = "I campi segnati da <span class='red'>*</span> non possono essere vuoti.";
      var userLabel = document.getElementById('user');
      var passLabel = document.getElementById('pass');

      userLabel.innerHTML = "Username <span class='red'>*</span>";
      passLabel.innerHTML = "Password <span class='red'>*</span>";

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
   /*var nome = document.getElementsByName('nome');
   var prezzo = document.getElementsByName('prezzo');
   var descrizione = document.getElementsByName('descrizione');

   if (nome.innerHTML == "") {

   }*/

   return true;
}

function checkFormPiatto() {

   return true;
}
