(function() {
   'use strict';
    function disappear() {
        document.getElementById("output").classList.add("hide");
    }

    function appear() {
        document.getElementById("output").classList.remove("hide");
    }

    function blink() {
        appear();

        var t = setTimeout(function() {
            blink()
        }, 4000);

        t = setTimeout(function() {
            disappear()
        }, 2000);

        // blink();
    }
    blink();
}());

