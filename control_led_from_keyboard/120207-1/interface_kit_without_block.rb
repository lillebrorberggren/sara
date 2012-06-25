#!/usr/bin/env ruby
#>rsdl interface_kit_without_block.rb
require 'rubygems'
require 'phidgets-ffi'
require "rubygame"

# -------------------------------
# Set up phidget
# -------------------------------
puts "Library Version: #{Phidgets::FFI.library_version}"

ifkit = Phidgets::InterfaceKit.new 
		
ifkit.on_attach  do |device, obj|
	 
    puts "Device attributes: #{device.attributes} attached"
    puts "Class: #{device.device_class}"
	puts "Id: #{device.id}"
	puts "Serial number: #{device.serial_number}"
	puts "Version: #{device.version}"
	puts "# Digital inputs: #{device.inputs.size}"
	puts "# Digital outputs: #{device.outputs.size}"
	puts "# Analog inputs: #{device.sensors.size}"
	  
	sleep 1	

	if(device.sensors.size > 0)
		device.ratiometric = false
	    device.sensors[0].data_rate = 64
		device.sensors[0].sensitivity = 15

		puts "Sensivity: #{device.sensors[0].sensitivity}"
		puts "Data rate: #{device.sensors[0].data_rate}"
		puts "Data rate max: #{device.sensors[0].data_rate_max}"  
		puts "Data rate min: #{device.sensors[0].data_rate_min}"  	
		puts "Sensor value[0]: #{device.sensors[0].to_i}"  	
		puts "Raw sensor value[0]: #{device.sensors[0].raw_value}"
		  
		device.outputs[0].state = true
		device.outputs[1].state = true
		sleep 1 #allow time for digital output 0's state to be set
		puts "Is digital output 0's state on? ... #{device.outputs[0].on?}"
    end
end
	 
ifkit.on_detach  do |device, obj|
    puts "on_detach"
	puts "#{device.attributes.inspect} detached"
end

ifkit.on_error do |device, obj, code, description|
	puts "Error #{code}: #{description}"
end

ifkit.on_input_change do |device, input, state, obj|
    puts "Input #{input.index}'s state has changed to #{state}"
end

ifkit.on_output_change do |device, output, state, obj|
    puts "Output #{output.index}'s state has changed to #{state}"
end
  
ifkit.on_sensor_change do |device, input, value, obj|
 	puts "Sensor #{input.index}'s value has changed to #{value}"
end 

puts "Init of phidget completed"

# -------------------------------
# Set up ruby game
# -------------------------------

# puts "Start logging..."
# 
# while 1
#     file = File.open("my_pipe")
#     
# 	first_line = file.gets
# 	
# 	first_int = /\d+/.match(first_line).to_s.to_i
# 	
# 	puts "first_line #{first_line}"
# 	puts "first_int #{first_int}"
# 	
# 	if first_int > 0 then
# 		puts "Turning LED on"
# 		ifkit.outputs[0].state = true
# 	else
# 		puts "Turning LED off"
# 		ifkit.outputs[0].state = false
# 	end
# 	
# 	sleep 0.1 
# 	
# end

# Open a window with a drawable area measuring 640x480 pixels 
@screen = Rubygame::Screen.open [ 640, 480]

# Set the title of the window
@screen.title = "Hello Rubygame World!"

# Create a queue to receive events+
#  + events such as "the mouse has moved", "a key has been pressed" and so on
@event_queue = Rubygame::EventQueue.new
    
# Use new style events so that this software will work with Rubygame 3.0
@event_queue.enable_new_style_events
    
# Wait for an event
while event = @event_queue.wait
    
  # Show the details of the event
  p event
    
  if event.is_a? Rubygame::Events::KeyPressed then
   puts "Key pressed  #{event.key}"
   case event.key
	when :right
	   puts "right key pressed"
	   ifkit.outputs[0].state = true
	when :left
	   puts "left key pressed"   
	   ifkit.outputs[0].state = false
	when :up
	   puts "up key pressed"
	   ifkit.outputs[1].state = true
	when :down
	   puts "down key pressed"
	   ifkit.outputs[1].state = false
   end
  end
  
  # Stop this loop if the user closes the window
  break if event.is_a? Rubygame::Events::QuitRequested
end

# -------------------------------
# Deallocating resources
# -------------------------------

puts "Turning LEDs off"
ifkit.outputs[0].state = false
ifkit.outputs[1].state = false
ifkit.close
