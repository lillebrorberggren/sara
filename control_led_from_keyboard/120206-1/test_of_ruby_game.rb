#!/usr/bin/env ruby

#>rsdl test_of_ruby_game.rb

require "rubygems"
require "rubygame"

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
    
#<Rubygame::Events::KeyPressed:0x152b0c18 @string="\357\234\202", @modifiers=[], @key=:left>
#<Rubygame::Events::KeyReleased:0x152ad89c @modifiers=[], @key=:left>

  if event.is_a? Rubygame::Events::KeyPressed then
   puts "Key pressed  #{event.key}"
   case event.key
	when :right
	   puts "right key pressed"
	when :left
	   puts "left key pressed"   
	when :up
	   puts "up key pressed"
	when :down
	   puts "down key pressed"
   end
  end
  
  # Stop this program if the user closes the window
  break if event.is_a? Rubygame::Events::QuitRequested
end