#!/usr/bin/env ruby

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
    
  # Stop this program if the user closes the window
  break if event.is_a? Rubygame::Events::QuitRequested
end