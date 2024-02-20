# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength
# rubocop:disable Layout/LineLength
# frozen_string_literal: true

# game class
class Game
  attr_accessor :board

  def initialize
    @board = Array.new(64, '  ')
  end

  def display_chessboard
    puts '  |  1 |  2 |  3 |  4 |  5 |  6 |  7 |  8 |'
    puts '  |----+----+----+----+----+----+----+----|'
    puts "H | #{@board[56]} | #{@board[57]} | #{@board[58]} | #{@board[59]} | #{@board[60]} | #{@board[61]} | #{@board[62]} | #{@board[63]} | H"
    puts '  |----+----+----+----+----+----+----+----|'
    puts "G | #{@board[48]} | #{@board[49]} | #{@board[50]} | #{@board[51]} | #{@board[52]} | #{@board[53]} | #{@board[54]} | #{@board[55]} | G"
    puts '  |----+----+----+----+----+----+----+----|'
    puts "F | #{@board[40]} | #{@board[41]} | #{@board[42]} | #{@board[43]} | #{@board[44]} | #{@board[45]} | #{@board[46]} | #{@board[47]} | F"
    puts '  |----+----+----+----+----+----+----+----|'
    puts "E | #{@board[32]} | #{@board[33]} | #{@board[34]} | #{@board[35]} | #{@board[36]} | #{@board[37]} | #{@board[38]} | #{@board[39]} | E"
    puts '  |----+----+----+----+----+----+----+----|'
    puts "D | #{@board[24]} | #{@board[25]} | #{@board[26]} | #{@board[27]} | #{@board[28]} | #{@board[29]} | #{@board[30]} | #{@board[31]} | D"
    puts '  |----+----+----+----+----+----+----+----|'
    puts "C | #{@board[16]} | #{@board[17]} | #{@board[18]} | #{@board[19]} | #{@board[20]} | #{@board[21]} | #{@board[22]} | #{@board[23]} | C"
    puts '  |----+----+----+----+----+----+----+----|'
    puts "B | #{@board[8]} | #{@board[9]} | #{@board[10]} | #{@board[11]} | #{@board[12]} | #{@board[13]} | #{@board[14]} | #{@board[15]} | B"
    puts '  |----+----+----+----+----+----+----+----|'
    puts "A | #{@board[0]} | #{@board[1]} | #{@board[2]} | #{@board[3]} | #{@board[4]} | #{@board[5]} | #{@board[6]} | #{@board[7]} | A"
    puts '  |----+----+----+----+----+----+----+----|'
    puts '  |  1 |  2 |  3 |  4 |  5 |  6 |  7 |  8 |'
  end
end
# rubocop:enable Layout/LineLength
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/AbcSize
