function manageNav(){
	if (screen.width < 1024) {
	    var nav = document.getElementById("nav-menu");
	    if(nav.className == "")
	    	nav.className = "hidden";
	    else
	    	nav.className = "";
	}

}