(function () {
    'use strict';

    var tab = document.getElementsByClassName("nav-item");
    var info = document.getElementById("information");

    function deactive() {
    	for (var i = 0; i < tab.length; i++) {
    		tab[i].children[0].className = "nav-link";
    	}
    }

    function active(id) {
    	id.className = "nav-link active";
    }

    function removeInfo(remove) {
    	while (remove.firstChild) {
    		remove.removeChild(remove.firstChild);
    	}
    }

    for (var i = 0; i < tab.length; i++) {
    	let className = tab[i].children[0].className;
    	let id = document.getElementById(tab[i].children[0].id)
    	let planetName = tab[i].children[0].innerHTML;
    	tab[i].addEventListener("click", function() {
    		deactive();
    		active(id);
    		removeInfo(info);
    		fetch("planets.json").then(function(response) {
		    	return response.json();
		    }).then(function(data) {
    			for (var i = 0; i < data.length; i++) {
    				if (planetName === data[i].name) {
    					var string = "<h2>" + planetName + "</h2>";
    					string += "<hr><p>" + data[i].details + "</p><ul>";
    					if (typeof data[i].summary.Discovery != "undefined") {
    						string += "<li><b>Discovery: </b>" + data[i].summary.Discovery + "</li>";
    					}
    					if (typeof data[i].summary["Named for"] != "undefined") {
    						string += "<li><b>Named for: </b>" + data[i].summary["Named for"] + "</li>";
    					}
    					if (typeof data[i].summary.Diameter != "undefined") {
    						string += "<li><b>Diameter: </b>" + data[i].summary.Diameter + "</li>";
    					}
    					if (typeof data[i].summary.Orbit != "undefined") {
    						string += "<li><b>Orbit: </b>" + data[i].summary.Orbit + "</li>";
    					}
    					if (typeof data[i].summary.Day != "undefined") {
    						string += "<li><b>Day: </b>" + data[i].summary.Day + "</li>";
    					}
    					info.innerHTML = string;
    				}
    			}
		    })
    	});
    }

}());


