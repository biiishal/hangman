# require "hangman/version"
require "yaml"

%w(version game player).each do |file|
  require_relative "./hangman/#{file}.rb"
end

module Hangman
  # Your code goes here...
end
