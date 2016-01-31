function manageNav(){
	if (screen.width < 1024) {
	    var nav = document.getElementById("nav-menu");
	    if(nav.className == "")
	    	nav.className = "hidden";
	    else
	    	nav.className = "";
	}
}

function manageMenu(portata){
	var section = document.getElementById(portata);
	if(section.className == "")
	    section.className = "hidden";
	else
	    section.className = "";
}