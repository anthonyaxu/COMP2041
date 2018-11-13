(function() {
    function fixTime(time) {
        if (time < 10) {
            return "0" + time;
        }
        return time;
    }
    function counter() {
        var date = new Date();
        var hour = date.getHours();
        var minute = date.getMinutes();
        var second = date.getSeconds();
        minute = fixTime(minute);
        second = fixTime(second); 
        var out = document.getElementById("output");
        out.innerHTML = hour + ":" + minute + ":" + second;
        var t = setTimeout(function() {
            counter()
        }, 500);
    }
    counter();
}());
