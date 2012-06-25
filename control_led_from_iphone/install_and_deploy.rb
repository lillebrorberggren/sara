#!/bin/bash

#directorylist = %x[find . -name '*test.rb' | sort]
path_to_pipe = '/Users/danielberggren/Pipes/my_pipe'
# phph-kod $array = split("\n", file_get_contents('filename'));
#$pipe = fopen('/Users/danielberggren/Dropbox/projects/control_led_from_iphone/resources','r+');

# SKAPA PIPES
# 0 Rensa för att få väldefinierat tillstånd
result  = %x[rm -r resources/]
# 1 Skapa katalog för pipe lokalt under arbetskatalog /resources
result  = %x[mkdir resources]
# 2 Skapa pipe i katalogen med mkfifo my_pipe
result  = %x[mkfifo my_pipe]
# 3 Ändra läs och skrivrättigheter på pipen till chmod a+rw my_pipe
result  = %x[chmod a+rw my_pipe]

# SKAPA PHP RESOURCES
# 1 Kopiera php-katalogen till /Library/WebServer/Documents
#fortsätt här result  = %x[cp src-php /Library/WebServer/Documents/php]

