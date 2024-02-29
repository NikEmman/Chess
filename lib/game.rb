# rubocop:disable Metrics/MethodLength
# rubocop:disable Style/EachForSimpleLoop
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
  attr_accessor :board, :pieces, :last_move

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
    populate
  end

  def populate
    @board[6].each_index do |index|
      @board[6][index] = Pawn.new('white', 6, index)
      @board[1][index] = Pawn.new('black', 1, index)
    end
    @board[1][2] = Pawn.new('black', 1, 2)
    @board[7][2] = Pawn.new('black', 7, 2)
    [0, 7].each do |i|
      @board[7][i] = Rook.new('white', 7, i)
      # @board[0][i] = Rook.new('black', 0, i)
    end
    # [1, 6].each do |i|
    #   @board[7][i] = Knight.new('white', 7, i)
    #   @board[0][i] = Knight.new('black', 0, i)
    # end
    # [2, 5].each do |i|
    #   @board[7][i] = Bishop.new('white', 7, i)
    #   @board[0][i] = Bishop.new('black', 0, i)
    # end
    #  @board[7][3] = Queen.new('white', 7, 3)
    @board[0][3] = Queen.new('black', 0, 3)
    @board[7][4] = King.new('white', 7, 4)
    @board[0][4] = King.new('black', 0, 4)
  end

  def display_piece(piece)
    piece.nil? ? '   ' : piece.sprite
  end

  def move(row_old, column_old, row_new, column_new)
    return 'Invalid move, try again' unless allowed_move?(row_old, column_old, row_new, column_new)

    if attempt_castling?(row_old, column_old, row_new, column_new)
      castling_move(row_old, column_old, row_new, column_new)
    elsif attempt_en_passant?(row_old, column_old, row_new, column_new)
      en_passant_move(row_old, column_old, row_new, column_new)
    else
      normal_move(row_old, column_old, row_new, column_new)
    end
    @last_move = [row_new, column_new]
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
    @board[row_new, column_new] = temp
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

  # def normal_move(row_old, column_old, row_new, column_new)
  #   if @board[row_old][column_old].is_a?(Pawn) && (row_new - row_old).abs == 2

  #     @board[row_old][column_old].en_passant = true
  #   elsif @board[row_old][column_old].is_a?(Pawn) && (row_new - row_old).abs == 1
  #     @board[row_old][column_old].en_passant = false
  #   end
  #   @board[row_old][column_old].has_moved = true
  #   temp = @board[row_old][column_old]
  #   @board[row_old][column_old] = nil
  #   temp.row = row_new
  #   temp.column = column_new
  #   @board[row_new][column_new] = temp
  # end

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
# a = Game.new
# a.populate
# a.display_chessboard
# a.move(6, 1, 4, 1)
# a.display_chessboard
# gets
# rubocop:enable Layout/LineLength
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/ClassLength
# rubocop:enable Style/EachForSimpleLoop
# rubocop:enable Metrics/MethodLength
