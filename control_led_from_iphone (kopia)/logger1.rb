
puts "Start logging..."

while 1
	#result = %x[cat < my_pipe]
    file = File.open("my_pipe")
    
	first_line = file.gets
	
	first_int = /\d+/.match(first_line).to_s.to_i
	
	puts "first_line #{first_line}"
	puts "first_int #{first_int}"
	
	if first_int > 0 then
		puts "Turning LED on"
	else
		puts "Turning LED off"
	end
	
	sleep 0.1 
	
end