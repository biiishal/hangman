# Game class controls the game loop and gives option to the player
# to load or save game as well.

module Hangman

  class Game
    # @@dictionary_path = "../data/dictionary.txt"
    attr_reader :player
    attr_accessor :display_word, :winning_word
    def initialize(player)
      @player = player
      @@dictionary = File.open("./data/dictionary.txt").map { |word| word.strip }
    end

    def update_winning_word
      winning_word = @@dictionary.sample
      display_word = Array.new(winning_word.length)
    end

    def solicit_move
      "Enter a guess character : "
    end

    def compare_guess(guess)
      { char: guess, idx: winning_word.index(guess) }
    end

    def update_display_word(input)
      display_word[input.fetch(:idx)] = input.fetch(:char)
    end

    def display_progress
      puts display_word + "  Your score:" +player.score
    end

    def game_win_message
      "Congratulations you won the game!"
    end

    def game_over_message
      "You lost."
    end

    def check_game_progress(chances)
      if display_word.none? { |e| e.nil? }
        player.score += 1
        game_win_message
      elsif chances == 0
        game_over_message
        false
      end
    end

    def play
      update_winning_word
      chances = 7
      binding.pry
      while true
        display_progress
        puts solicit_move
        guess = gets.chomp
        if winning_word.match(guess)
          update_display_word(compare_guess(guess))
        else
          chances -= 1
        end
        check_game_progress(chances)
      end
    end


  end
end