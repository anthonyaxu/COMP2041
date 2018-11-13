(function () {
    'use strict';

    const url = "https://jsonplaceholder.typicode.com/users";

    const out = document.getElementById("output");

    fetch(url).then(function(response) {
        return response.json();
    }).then(function(data) {
        for (var i = 0; i < data.length; i++) {
            var listItem = document.createElement('ul');
            listItem.innerHTML = "<div class='user'><h2>" + data[i].name + "</h2><p>" + data[i].company.catchPhrase + "</p> </div>";
            out.appendChild(listItem);
        }
    });

}());

