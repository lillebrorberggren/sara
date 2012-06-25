<html>
<head>
<title>
Car Control
</title>

<script type="text/javascript" charset="utf-8">

var startx = 0;
var starty = 0;
var xvector = 0;
var yvector = 0;


document.ontouchstart = function(e){
	var touch = e.touches[0];
	startx = touch.pageX;
	starty = touch.pageY;
	document.getElementById("touch").innerHTML = "Starting";
}

document.ontouchend = function(e){
	startx = 0;
	starty = 0;
	xvector = 0;
	yvector = 0;
	document.getElementById("touch").innerHTML = "Touch Ended";
	
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.open("GET", "newVector.php?x="+xvector+"&y="+yvector,true);
	xmlhttp.send(null);
}

document.ontouchmove = function(e){
  e.preventDefault();
  if(e.touches.length == 1){ 
    var touch = e.touches[0]; 
    xvector = touch.pageX - startx;
    yvector = - (touch.pageY - starty);
    document.getElementById("touch").innerHTML = "Current Vector " + xvector + " " + yvector;

    //var xmlhttp = new XMLHttpRequest();
    //xmlhttp.open("GET", "newVector.php?x="+xvector+"&y="+yvector,true);
    //xmlhttp.send(null);
  }
}


function sendUpdate(){
    var xmlhttp = new XMLHttpRequest();
    xmlhttp.open("GET", "newVector.php?x="+xvector+"&y="+yvector,true);
    xmlhttp.send(null);
}


setInterval("sendUpdate()",50);

</script>

</head>



<body style="background-image:url('logo.jpg');background-repeat:no-repeat;background-position: center center;">

<div style="font-size:50px" id="touch">
None
</div>

</body>
</html>
