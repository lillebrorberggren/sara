#!/usr/bin/env ruby

# Dave's Tetris clone, Dave Barker 2010 

# (Requires rubygame, rsdl, sdl, sdl_graphics, sdl_ttf and ruby >= 1.9)
# (Make sure you put Chalkduster.ttf if working directory)

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


# Code was started from this great rubygame template: 
#  http://rubygame.org/wiki/Generic_Game_Template

require 'rubygems'
require 'rubygame'

$TileSize = 20
$Colours = [:blue, :red, :pink, :green, :cyan, :purple, :yellow]

$Pieces = [["    ,  # ,  # , ## ",
            "    ,    , #  , ###",
            "    , ## , #  , #  ",
            "    ,    , ###,   #"],
           ["    , ## , ## ,    "],
           ["    ,    ,####,    ",
            "  # ,  # ,  # ,  # "],
           ["    ,  ##, ## ,    ",
            "    , #  , ## ,  # "],
           ["    ,  # , ###,    ",
            "    ,  # ,  ##,  # ",
            "    ,    , ###,  # ",
            "    ,  # , ## ,  # "]]

def parse_piece_string(s)
  s.chars.each_with_object([]) do |c, result|
    case c
    when " " then result << false
    when "," then next
    else result << true
    end
  end
end

def load_pieces(pieces)
  pieces.collect do |piece|
    piece.collect {|rotation| parse_piece_string rotation}
  end
end

class Array
  def rand_item
    self[rand(self.length)]
  end
end

class Piece
  @@type_width = 4
  @@types = load_pieces($Pieces)

  def initialize
    @type = @@types.rand_item
    @rotation = 0
    @x = 0
    @y = 0
    @colour = $Colours.rand_item
  end

  def squares(piece=current)
    Enumerator.new do |yielder|
      piece.each_with_index do |tile, i|
        x, y = coords(i)
        yielder.yield(@x+x, @y+y, @colour) if tile
      end
    end
  end

  def move(x, y, map) 
    unless collision?(map, x, y)
      @x += x
      @y += y
    end
  end

  def drop(map)
    @y += 1 while not collision?(map, 0, 1)
  end      

  def rotate(map)
    @rotation = next_rotation unless collision?(map, 0, 0, @type[next_rotation])
  end

  def update(map)
    if collision?(map, 0, 1)
      squares.each {|x, y, colour| map.set(x, y, colour)}
      initialize
    end
  end

  private

  def current
    @type[@rotation]
  end
  
  def next_rotation
    if @rotation > @type.count - 2
      return 0
    else
      return @rotation + 1
    end
  end

  def coords(p)
    [p % @@type_width, p / @@type_width]
  end
   
  def collision?(map, x_offset, y_offset, piece=current)
    squares(piece).any? {|x, y, c| not map.free?(x + x_offset, y + y_offset)}
  end
end

class Map
  def initialize(w, h)
    @w = w
    @h = h
    @tiles = Array.new(h) {Array.new(w, nil)}
  end

  def set(x, y, colour)
    @tiles[y][x] = colour
  end
  
  def squares
    Enumerator.new do |yielder|
      @tiles.each_with_index do |line, y|
        line.each_with_index do |colour, x|
          yielder.yield(x, y, colour) if colour
        end
      end
    end
  end

  def free?(x, y)
    x >= 0 and x < @w and y >= 0 and y < @h and not @tiles[y][x]
  end

  def update
    points = 0
    shift_lines! {|line| points += 1 if line.all?}
    points
  end

  private

  def shift_lines!
    @tiles.each_with_index {|line, y| shift_line(y) if yield line}
  end
  
  def shift_line(y)
    case y
      when 0
      @tiles[y].fill(nil)
      when 1..@h
      @tiles[y] = @tiles[y - 1]
      shift_line(y - 1)
    end
  end
end

class Game
  def initialize(w, h, speed, font_file)
    # Setup rubygame stuff
    @screen = Rubygame::Screen.new([w * $TileSize, h * $TileSize], 0, 
                                   [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF])
    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 30
    Rubygame::TTF.setup
    @ttf = Rubygame::TTF.new(font_file, 20)

    # Setup the game of tetris
    @screen.title = "Tetris"
    @map = Map.new(w, h)
    @piece = Piece.new
    @background = :white
    @speed = speed
    @step = 0
    @score = 0
  end
  
  def run
    loop do
      update(@clock.tick)
      draw
    end
  end
  
  def update(time_delta)
    # Process the event queue
    @queue.each do |ev|
      case ev
      when Rubygame::KeyDownEvent
        case(ev.key)
        when Rubygame::K_LEFT
          @piece.move(-1, 0, @map)
        when Rubygame::K_RIGHT
          @piece.move(1, 0, @map)
        when Rubygame::K_DOWN
          @piece.move(0, 1, @map)
        when Rubygame::K_UP
          @piece.rotate(@map)
        when Rubygame::K_SPACE
          @piece.drop(@map)
        end
      when Rubygame::QuitEvent
        Rubygame.quit
        exit        
      end
    end
    # Update the game state
    @step += time_delta
    if @step > @speed
      @step -= @speed
      @piece.move(0, 1, @map)
    end
    @piece.update(@map) {|x, y, colour| @map.set(x, y, colour)}
    @score += @map.update
  end
  
  def draw_square(x, y, colour, border=true)
    # Setup the points for SDL
    x_pos = x * $TileSize
    y_pos = y * $TileSize
    pt1 = [x_pos, y_pos]
    pt2 = [x_pos + $TileSize, y_pos + $TileSize]
    # Draw the square and then the border
    @screen.draw_box_s(pt1, pt2, colour)
    @screen.draw_box(pt1, pt2, :black) if border
  end
  
  def draw
    @screen.fill(@background)
    
    draw_squares = lambda {|x, y, colour| draw_square(x, y, colour)}
    @piece.squares.each &draw_squares
    @map.squares.each &draw_squares

    @ttf.render("Score: " + @score.to_s, true, :black).blit(@screen, [0,0])
    @screen.flip
  end
end

# Useage
#game = Game.new(10, 20, 1000, "Chalkduster.ttf")
game = Game.new(10, 20, 1000, "chalkdust.ttf")
game.run