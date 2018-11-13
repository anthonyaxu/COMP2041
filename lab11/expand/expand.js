(function() {
	'use strict';
  
	const item_1 = document.getElementById('item-1');
    document.getElementById('item-1-content').style.display = 'block';
    item_1.addEventListener('click', collapse1);

    const item_2 = document.getElementById('item-2');
    document.getElementById('item-2-content').style.display = 'block'
    item_2.addEventListener('click', collapse2);

    function collapse1() {
        if (document.getElementById('item-1-content').style.display == 'block') {
            document.getElementById('item-1-content').style.display = "none";
        } else {
            document.getElementById('item-1-content').style.display = 'block';
        }
        var element = document.getElementById('item-1');
        if (element.innerHTML == 'expand_less') {
            element.innerHTML = 'expand_more';
        } else {
            element.innerHTML = 'expand_less';
        }
    }

    function collapse2() {
        if (document.getElementById('item-2-content').style.display == 'block') {
            document.getElementById('item-2-content').style.display = "none";
        } else {
            document.getElementById('item-2-content').style.display = 'block';
        }
        var element = document.getElementById('item-2');
        if (element.innerHTML == 'expand_less') {
            element.innerHTML = 'expand_more';
        } else {
            element.innerHTML = 'expand_less';
        }
    }

}());

