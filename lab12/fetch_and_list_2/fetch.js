(function() {
    'use strict';

    const url_users = "https://jsonplaceholder.typicode.com/users";
    const url_posts = "https://jsonplaceholder.typicode.com/posts";

    const out = document.getElementById("output");

 	var request1 = fetch(url_users).then(function(response) {
 		return response.json();
 	});

 	var request2 = fetch(url_posts).then(function(response) {
 		return response.json();
 	});

 	var combined = {"users": {}, "posts": {}};
 	Promise.all([request1, request2]).then(function(values) {
 		combined["users"] = values[0];
 		combined["posts"] = values[1];

 		for (var i = 0; i < combined["users"].length; i++) {
            var listItem = document.createElement('ul');
            var style = document.createElement('div');
            style.style = "width: 100%; display: flex; align-items: center; justify-content: center";

            var posts = "";
            var users = "";
            users = "<div class='user'><h2>" + combined["users"][i].name + "</h2><p>" + combined["users"][i].company.catchPhrase + "</p><ul class='posts'>";
            // listItem.innerHTML = "<div class='user'><h2>" + combined["users"][i].name + "</h2><p>" + combined["users"][i].company.catchPhrase + "</p><ul class='posts'>";
            for (var j = 0; j < combined["posts"].length; j++) {
            	if (combined["posts"][j].userId === combined["users"][i].id) {
            		// listItem.innerHTML += "<li class='posts'>" + combined["posts"][j].title + "</li>";
            		posts += "<li class='posts'>" + combined["posts"][j].title + "</li>";
            	}
            }
            listItem.innerHTML = users + posts;
            listItem.innerHTML += "</ul></div>";
            style.appendChild(listItem);
            out.appendChild(style);
        }
 	});

 }());

