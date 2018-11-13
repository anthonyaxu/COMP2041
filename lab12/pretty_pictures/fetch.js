(function () {
    'use strict';

    const url = "https://picsum.photos/200/300/?random";

    const out = document.getElementById("output");
    const loading = document.getElementById("loading");

    const more = document.getElementById("more");
    more.addEventListener("click", function() {
    	removeImages(out);
    	generateImages();
    });

    function removeImages(out) {
    	for (var i = 0; i < 5; i++) {
    		out.removeChild(out.lastChild);
    	}
    }

    function getTime() {
    	var now = new Date();
		var hour = now.getHours();
		var minutes = now.getMinutes();
		if (minutes < 10) minutes = "0" + minutes;

		var time = hour + ":" + minutes;

		return time;
    }

    var outside;

    // Renders the pictures out one by one, not all together
 // 	function getImage() {
	//     fetch(url).then(function(response) {
	//     	return response.blob();
	//     }).then(function(image) {
	//     	outside = URL.createObjectURL(image);
	//     	var img_style = document.createElement('div');
	//     	img_style.style = "width: 100%; display: flex; align-items: center; justify-content: center";

	//     	var img_post = document.createElement('div');
	//     	img_post.className = "img-post";

	//     	var img = document.createElement('img');
	//     	img.src = outside;

	//     	img_post.appendChild(img);
	//     	img_post.innerHTML += "<p>Fetched at " + getTime() + "</p>";
	//     	img_style.appendChild(img_post);

	//     	out.appendChild(img_style);
	//     });
	// }

	// function generateImages() {
	// 	for (var i = 0; i < 5; i++) {
	// 		getImage();
	// 	}
	// }

	// Horrible code
 	function generateImages() {
 		loading.style.display = "block";
	    Promise.all([fetch(url).then(function(response) { 
	    	return response.blob(); 
	    }), fetch(url).then(function(response) {
			return response.blob();
		}), fetch(url).then(function(response) {
			return response.blob();
		}), fetch(url).then(function(response) {
			return response.blob();
		}), fetch(url).then(function(response) {
			return response.blob();
		})]).then(function(values) {
	    	loading.style.display = "none";
			for (var i = 0; i < 5; i++) {
				outside = URL.createObjectURL(values[i]);

				var img_style = document.createElement('div');
				img_style.style = "width: 100%; display: flex; align-items: center; justify-content: center";

				var img_post = document.createElement('div');
				img_post.className = "img-post";
				var img = document.createElement('img');
				img.src = outside;

				img_post.appendChild(img);
				img_post.innerHTML += "<p>Fetched at " + getTime() + "</p>";

				img_style.appendChild(img_post);

				out.appendChild(img_style);
			} 		
	 	});
	}

	generateImages();

}());

