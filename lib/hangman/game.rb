# Game class controls the game loop and gives option to the player
# to load or save game as well.

module Hangman

  class Game
    attr_accessor :display_word, :winning_word, :player, :chances
    def initialize(player)
      @chances = 7
      @player = player
      @@dictionary = File.open(@@dictionary_path).map { |word| word.strip.downcase }
    end

    def update_winning_word
      @winning_word ||= @@dictionary.sample.split('')
      @display_word ||= Array.new(winning_word.length)
    end

    def solicit_move
      "Enter a guess character ('save' to save | 'load' to load | 'exit' to quit): "
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
      puts display_word.to_s + " Chances left:" + @chances.to_s +  "  Your score:" + player.score.to_s
    end

    def game_win_message
      "Congratulations you won the game!\n<><><><><><><><><><><><><><><><><><>\n<><><><><><><><><><><><><><><><><><>"
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
        reset
      elsif @chances == 0
        puts game_over_message
        reset
      end
    end

    def reset
      @winning_word = @@dictionary.sample.split('')
      @display_word = Array.new(winning_word.length)
      binding.pry
      puts winning_word
      @chances = 7
    end

    def handle_input(input)
      if winning_word.include?(input)
        update_display_word(compare_guess(input))
      else
        @chances -= 1
      end
      check_game_progress
    end

    def confirm_exit
      puts "Are you sure you want to exit? (y/anything)"
      if gets.chomp == "y"
        puts "Bye Bye!"
        exit
      else
        return
      end
    end

    def play
      update_winning_word
      # puts winning_word.join("")
      while true
        display_progress
        puts solicit_move
        input = gets.chomp
        case input
          when "exit"
            confirm_exit
          when "save"
            save_progress
          when "load"
            load_progress
          else
            handle_input(input)
        end
      end
    end

    private

    @@dictionary_path = "./data/dictionary.txt"
    @@save_path = "./data/save_data.yml"

  end
end