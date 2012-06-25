#!/usr/bin/env ruby

require "rubygems"
require "rubygame"

include Rubygame

# Set up the TrueType Font module
TTF.setup
point_size = 20
$font = TTF.new "DejaVuSans-Bold.ttf", point_size

@screen = Screen.open [ 640, 480]

# Render some text to a new surface using the TrueType font.  Using render_utf8
# is good because players might input text with accents or other non-ASCII text
smooth = true
YELLOW = [ 0xee, 0xee, 0x33]
@text_surface = $font.render_utf8 "Hello TrueType text!", smooth, YELLOW

# Determine the dimensions in pixels of the area used to render the text.  The
# "topleft" of the returned rectangle is at [ 0, 0]
rt = @text_surface.make_rect

# Re-use the "topleft" of the rectangle to indicate where the text should
# appear on screen ( in this case, 8 pixels from the top right hand corner of
# the screen
rt.topleft = [ @screen.width - 8 - rt.width,  8]

# Copy the pixels of the rendered text to the screen
@text_surface.blit @screen, rt

@screen.flip
@event_queue = EventQueue.new
@event_queue.enable_new_style_events
until @event_queue.wait().is_a? Events::KeyPressed
end