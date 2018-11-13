(function() {
	'use strict';

	const item_1 = document.getElementById('item-1');
	item_1.addEventListener('click', collapse1);

	const item_2 = document.getElementById('item-2');
	item_2.addEventListener('click', collapse2);

  	function collapse1() {
  		document.getElementById('item-1-content').style.display = 'none';
  	}

  	function collapse2() {
  		document.getElementById('item-2-content').style.display = "none";
  	}

}());

