<?php

$x = $_GET["x"];
$y = $_GET["y"];

//Open pipe and write some text to it.
//Mode must be r+ or fopen will get stuck.
$pipe = fopen('/Users/danielberggren/Dropbox/projects/control_led_from_iphone/resources','r+');
fwrite($pipe,$x . "," . $y);
fclose($pipe);



?>
