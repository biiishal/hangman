# Game class controls the game loop and gives option to the player
# to load or save game as well.

module Hangman

  class Game
    attr_accessor :display_word, :winning_word, :player, :chances
    def initialize(player)
      @chances = 7
      @player = player
      @@dictionary = File.open(@@dictionary_path).map { |word| word.strip }
    end

    def update_winning_word
      @winning_word ||= @@dictionary.sample.split('')
      @display_word ||= Array.new(winning_word.length)
    end

    def solicit_move
      "Enter a guess character : "
    end

    def compare_guess(guess)
      idx = @winning_word.index(guess)
      @winning_word[idx] = nil
      { char: guess, idx: idx }
    end

    def update_display_word(input)
      display_word[input.fetch(:idx)] = input.fetch(:char)
    end

    def display_progress
      puts display_word.to_s + "  Your score:" +player.score.to_s
    end

    def game_win_message
      "Congratulations you won the game!"
    end

    def game_over_message
      "You lost."
    end

    def save_progress
      file = File.open(@@save_path, "w")
      file.write(self.to_yaml)
      file.close
    end

    def load_progress
      YAML.load_file(@@save_path).play
    end

    def check_game_progress
      if display_word.none? { |e| e.nil? }
        @player.score += 1
        puts game_win_message
        binding.pry
        reset
      elsif @chances == 0
        puts game_over_message
        reset
      end
      binding.pry
    end

    def reset
      update_winning_word
      @chances = 7
    end

    def play
      update_winning_word
      binding.pry
      while true
        display_progress
        puts solicit_move
        guess = gets.chomp
        if winning_word.include?(guess)
          update_display_word(compare_guess(guess))
        else
          @chances -= 1
        end
        check_game_progress
      end
    end

    private

    @@dictionary_path = "./data/dictionary.txt"
    @@save_path = "./data/save_data.yml"

  end
end