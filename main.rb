# rubocop:disable Metrics/MethodLength
# frozen_string_literal: true

require_relative './lib/game'
require 'tty-prompt'
require 'pry-byebug'

# create save/load game methods

# fix display pieces taken next to board
# main class
class Main
  attr_accessor :game

  def initialize
    @game = Game.new
  end

  def play
    loop do
      @game.play
      if @game.input == 'save'
        game_save
      elsif @game.input == 'load'
        load_game
      end
      announce_game_result(@game)
      check_restart(@game)
      break if @game.input == 'exit' || %w[Win Draw].include?(@game.game_result)
    end
  end

  def announce_game_result(game)
    if game.game_result == 'Win'
      puts "It is a win for #{game.winner}!!!"
    elsif game.game_result == 'Draw'
      puts "What a game! It's a draw!!"
    end
  end

  def game_save
    Dir.mkdir('saved_games') unless File.exist?('saved_games')
    save_name = acquire_saved_game_name
    File.write("saved_games/#{save_name}.yml", YAML.dump(@game))
  end

  def acquire_saved_game_name
    puts 'Type a name for the save file:'
    gets.chomp
  end

  # def game_load
  #   YAML.load_file('save00.yml', permitted_classes: [Game, Rook, Pawn, Queen, Bishop, King, Knight])
  # end

  def load_game
    prompt = TTY::Prompt.new

    Dir.mkdir('saved_games') unless File.exist?('saved_games')
    saved_games = Dir.glob('saved_games/*.yml')

    save_to_load = prompt.select('Choose your destiny?', saved_games)

    @game = YAML.load_file(save_to_load, permitted_classes: [Game, Rook, Pawn, Queen, Bishop, King, Knight])

    # puts 'Saved games:'
    # saved_games.each do |filename|
    #   puts filename
    # end

    # print 'Enter the name of the save to load: '
    # save_to_load = gets.chomp

    # if saved_games.include?(save_to_load)
    #   # @game = YAML.load(File.read(save_to_load))
    #   @game = YAML.load_file(save_to_load, permitted_classes: [Game, Rook, Pawn, Queen, Bishop, King, Knight])
    # else
    #   puts 'No save found with that name.'
    # end
  end

  def check_restart(game)
    return unless %w[Win,Draw].include?(game.game_result)

    puts 'Do you want to play again? [Y/N] :'
    answer = gets.chomp.downcase
    return unless answer == 'y'

    @game = Game.new
  end
end
# rubocop:enable Metrics/MethodLength
