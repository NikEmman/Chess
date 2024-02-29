# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/ClassLength
# rubocop:disable Metrics/AbcSize
# rubocop:disable Layout/LineLength
# frozen_string_literal: true

require_relative 'pawn'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'
# game class
class Game
  attr_accessor :board, :pieces, :last_move, :input

  def initialize
    @board = Array.new(8) { Array.new(8) }
    # 0 ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
    # 1 ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
    # 2 ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
    # 3 ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
    # 4 ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
    # 5 ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
    # 6 ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   '],
    # 7 ['   ', '   ', '   ', '   ', '   ', '   ', '   ', '   ']
    @round = 0
    @last_move = []
    @whites_taken = Array.new(16)
    @blacks_taken = Array.new(16)
    @white_draw = nil
    @black_draw = nil
    @moves_for_draw = 0
    @input = ''
    populate
  end

  def populate
    populate_pawns
    populate_special_pieces
  end

  def populate_pawns
    [1, 6].each do |row|
      color = row == 1 ? 'black' : 'white'
      @board[row].each_index do |index|
        @board[row][index] = Pawn.new(color, row, index)
      end
    end
  end

  def populate_special_pieces
    pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    [0, 7].each do |row|
      color = row.zero? ? 'black' : 'white'
      pieces.each_with_index do |piece_class, column|
        @board[row][column] = piece_class.new(color, row, column)
      end
    end
  end

  def display_piece(piece)
    piece.nil? ? '   ' : piece.sprite
  end

  def move(row_old, column_old, row_new, column_new)
    update_moves_for_draw(row_old, column_old, row_new, column_new)

    if attempt_castling?(row_old, column_old, row_new, column_new)
      castling_move(row_old, column_old, row_new, column_new)
    elsif attempt_en_passant?(row_old, column_old, row_new, column_new)
      en_passant_move(row_old, column_old, row_new, column_new)
    else
      normal_move(row_old, column_old, row_new, column_new)
    end
    @last_move = [row_new, column_new]
  end

  def update_moves_for_draw(row_old, column_old, row_new, column_new)
    if !@board[row_old][column_old].is_a?(Pawn) && destination_empty_or_not_castling?(row_old, column_old, row_new, column_new)
      @moves_for_draw += 1
    else
      @moves_for_draw = 0
    end
  end

  def destination_empty_or_not_castling?(row_old, column_old, row_new, column_new)
    @board[row_new][column_new].nil? || !attempt_castling?(row_old, column_old, row_new, column_new)
  end

  def allowed_move?(row_old, column_old, row_new, column_new)
    if @board[row_old][column_old].nil?
      false
    else
      color = @board[row_old][column_old].color

      @board[row_old][column_old].valid_move?(row_new, column_new, @board, @last_move) &&
        king_safe?(row_old, column_old, row_new, column_new, color)
    end
  end

  def king_safe?(row_old, column_old, row_new, column_new, color)
    king = nil

    (0..7).each do |row|
      (0..7).each do |column|
        king = @board[row][column] if @board[row][column].is_a?(King) && @board[row][column].color == color
      end
    end

    test_move(row_old, column_old, row_new, column_new, king)
  end

  def test_move(row_old, column_old, row_new, column_new, king_pieces)
    temp = @board[row_new, column_new]
    normal_move(row_old, column_old, row_new, column_new)
    result = not_threatens_king?(king_pieces)

    normal_move(row_new, column_new, row_old, column_old)
    @board[row_new][column_new] = temp
    result
  end

  def not_threatens_king?(king)
    (0..7).each do |row|
      (0..7).each do |column|
        next if @board[row][column].is_a?(King) || @board[row][column].nil?

        return false if @board[row][column].valid_move?(king.row, king.column, @board, @last_move)
      end
    end

    true
  end

  # use that after the move
  def time_for_promotion?(row, column)
    @board[row][column].is_a?(Pawn) && [7, 0].include?(row)
  end

  def promote_pawn(row, column)
    temp = @board[row][column]
    color = temp.color
    @board[row][column] = Queen.new(color, row, column)
    puts "Your pawn got promoted to a Queen (don't expect a pay raise though...)"
  end

  def normal_move(row_old, column_old, row_new, column_new)
    piece = @board[row_old][column_old]

    piece.en_passant = (row_new - row_old).abs == 2 if piece.is_a?(Pawn)

    piece.has_moved = true
    @board[row_old][column_old] = nil

    piece.row = row_new
    piece.column = column_new
    @board[row_new][column_new] = piece
  end

  def attempt_en_passant?(row_old, column_old, row_new, column_new)
    return false unless @board[row_old][column_old].respond_to?(:en_passant?)

    @board[row_old][column_old].en_passant?(row_new, column_new, @board, @last_move)
  end

  def en_passant_move(row_old, column_old, row_new, column_new)
    direction = column_new > column_old ? 1 : -1
    @board[row_new][column_new] = @board[row_old][column_old]
    @board[row_old][column_old + direction] = nil
    @board[row_old][column_old] = nil
  end

  def attempt_castling?(row_old, column_old, row_new, column_new)
    return false unless @board[row_old][column_old].respond_to?(:castling?)

    @board[row_old][column_old].castling?(row_new, column_new, @board)
  end

  def castling_move(row_old, column_old, row_new, column_new)
    @board[row_old][column_old].has_moved = true
    @board[row_new][column_new].has_moved = true

    direction = column_new > column_old ? 1 : -1

    @board[row_old][column_old].column = column_old + 2 * direction
    @board[row_old][column_old + 2 * direction] = @board[row_old][column_old]
    @board[row_old][column_old] = nil

    @board[row_new][column_new].column = column_old - direction
    @board[row_new][column_old + direction] = @board[row_new][column_new]
    @board[row_new][column_new] = nil
  end

  def user_input
    input = nil
    color = @round.even? ? "Whites'" : "Blacks'"
    loop do
      puts "It's #{color} turn, type your move :"
      input = gets.chomp.downcase
      break if valid_move_input?(input) &&
               (valid_input?(input) || allowed_move?(row(input, 0), column(input, 1), row(input, 2), column(input, 3)))

      if valid_input?(input)
        puts 'Invalid input, type a move (ie a1b2), draw, resign, save, load'
      else
        puts 'Invalid move, try again'
      end
    end
    @input = input
    input
  end

  def valid_input?(input)
    request_draw?(input) ||
      declare_resign?(input) ||
      save_game?(input) ||
      load_game?(input)
  end

  def request_draw?(input)
    input == 'draw'
  end

  def declare_resign?(input)
    input == 'resign'
  end

  def save_game?(input)
    input == 'save'
  end

  def load_game?(input)
    input == 'load'
  end

  def valid_move_input?(input)
    input.size == 4 &&
      %w[a b c d e f g h].include?(input[0]) &&
      %w[a b c d e f g h].include?(input[2]) &&
      (1..8).include?(input[1].to_i) &&
      (1..8).include?(input[3].to_i)
  end

  def play
    greetings
    clear_screen
    loop do
      display_chessboard
      input = user_input
      determine_game_course(input)
      clear_screen
      # break if win? || draw? || end?
    end
  end

  def determine_game_course(input)
    if valid_move_input?(input)
      process_move(input)
    elsif declare_resign?(input)
      @winner = @round.even? ? 'Black' : 'White'
      break
    elsif save_game?(input) || load_game?(input)
      # save/load game method in main
      break
    else
      @round.even? ? @white_draw = @round : @black_draw = @round
      @round += 1
    end
  end

  def draw?
    (@white_draw - @black_draw).abs == 1
  end

  def process_move(input)
    move(row(input, 0), column(input, 1), row(input, 2), column(input, 3))
    promote_pawn(@last_move[0], @last_move[1]) if time_for_promotion?(@last_move[0], @last_move[1])
    @round += 1
  end

  def clear_screen
    system('clear') || system('cls')
  end

  def row(input, index)
    'hgfedcba'.index(input[index])
  end

  def column(input, index)
    input[index].to_i - 1
  end

  def greetings
    puts '                                              WELCOME!                      '
    puts
    display_chessboard
    puts
    puts "This is a console Chess game! Choose your piece and its move by typing the piece's square and the destination square"
    puts 'In example --- b1d1 --- to move the white pawn two rows up.'
    puts
    puts 'If you want to perform castling, use the King as the starting square and Rook as destination'
    puts 'In example --- a4a1 ---'
    puts
    puts 'Whites always start first'
    puts
    puts "If you want to admit defeat, type 'resign'."
    puts
    puts "If you want to propose a draw,type 'draw'. If next turn, the opponent also types 'draw', the game ends"
    puts
    puts "At any time, type 'save' to save the game, or 'load' to load a saved game"
    puts
    puts 'For Chess rules explanation check the link in README file'
    puts
    puts 'To begin the game press [ENTER]'
    gets
  end

  def display_chessboard
    puts '   1  2  3  4  5  6  7  8 '
    puts "H \e[47m#{display_piece(@board[0][0])}\e[0m\e[100m#{display_piece(@board[0][1])}\e[0m\e[47m#{display_piece(@board[0][2])}\e[0m\e[100m#{display_piece(@board[0][3])}\e[0m\e[47m#{display_piece(@board[0][4])}\e[0m\e[100m#{display_piece(@board[0][5])}\e[0m\e[47m#{display_piece(@board[0][6])}\e[0m\e[100m#{display_piece(@board[0][7])}\e[0m H"
    puts "G \e[100m#{display_piece(@board[1][0])}\e[0m\e[47m#{display_piece(@board[1][1])}\e[0m\e[100m#{display_piece(@board[1][2])}\e[0m\e[47m#{display_piece(@board[1][3])}\e[0m\e[100m#{display_piece(@board[1][4])}\e[0m\e[47m#{display_piece(@board[1][5])}\e[0m\e[100m#{display_piece(@board[1][6])}\e[0m\e[47m#{display_piece(@board[1][7])}\e[0m G"
    puts "F \e[47m#{display_piece(@board[2][0])}\e[0m\e[100m#{display_piece(@board[2][1])}\e[0m\e[47m#{display_piece(@board[2][2])}\e[0m\e[100m#{display_piece(@board[2][3])}\e[0m\e[47m#{display_piece(@board[2][4])}\e[0m\e[100m#{display_piece(@board[2][5])}\e[0m\e[47m#{display_piece(@board[2][6])}\e[0m\e[100m#{display_piece(@board[2][7])}\e[0m F"
    puts "E \e[100m#{display_piece(@board[3][0])}\e[0m\e[47m#{display_piece(@board[3][1])}\e[0m\e[100m#{display_piece(@board[3][2])}\e[0m\e[47m#{display_piece(@board[3][3])}\e[0m\e[100m#{display_piece(@board[3][4])}\e[0m\e[47m#{display_piece(@board[3][5])}\e[0m\e[100m#{display_piece(@board[3][6])}\e[0m\e[47m#{display_piece(@board[3][7])}\e[0m E"
    puts "D \e[47m#{display_piece(@board[4][0])}\e[0m\e[100m#{display_piece(@board[4][1])}\e[0m\e[47m#{display_piece(@board[4][2])}\e[0m\e[100m#{display_piece(@board[4][3])}\e[0m\e[47m#{display_piece(@board[4][4])}\e[0m\e[100m#{display_piece(@board[4][5])}\e[0m\e[47m#{display_piece(@board[4][6])}\e[0m\e[100m#{display_piece(@board[4][7])}\e[0m D"
    puts "C \e[100m#{display_piece(@board[5][0])}\e[0m\e[47m#{display_piece(@board[5][1])}\e[0m\e[100m#{display_piece(@board[5][2])}\e[0m\e[47m#{display_piece(@board[5][3])}\e[0m\e[100m#{display_piece(@board[5][4])}\e[0m\e[47m#{display_piece(@board[5][5])}\e[0m\e[100m#{display_piece(@board[5][6])}\e[0m\e[47m#{display_piece(@board[5][7])}\e[0m C"
    puts "B \e[47m#{display_piece(@board[6][0])}\e[0m\e[100m#{display_piece(@board[6][1])}\e[0m\e[47m#{display_piece(@board[6][2])}\e[0m\e[100m#{display_piece(@board[6][3])}\e[0m\e[47m#{display_piece(@board[6][4])}\e[0m\e[100m#{display_piece(@board[6][5])}\e[0m\e[47m#{display_piece(@board[6][6])}\e[0m\e[100m#{display_piece(@board[6][7])}\e[0m B"
    puts "A \e[100m#{display_piece(@board[7][0])}\e[0m\e[47m#{display_piece(@board[7][1])}\e[0m\e[100m#{display_piece(@board[7][2])}\e[0m\e[47m#{display_piece(@board[7][3])}\e[0m\e[100m#{display_piece(@board[7][4])}\e[0m\e[47m#{display_piece(@board[7][5])}\e[0m\e[100m#{display_piece(@board[7][6])}\e[0m\e[47m#{display_piece(@board[7][7])}\e[0m A"
    puts '   1  2  3  4  5  6  7  8 '
  end
end
a = Game.new
a.play
# rubocop:enable Layout/LineLength
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/ClassLength
# rubocop:enable Metrics/MethodLength
