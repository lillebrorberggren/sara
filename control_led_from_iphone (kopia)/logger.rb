
puts "Start logging..."

while 1
	result = %x[cat < my_pipe]

	puts result
	
	sleep 0.1 
	
	#puts "New flush..."
end