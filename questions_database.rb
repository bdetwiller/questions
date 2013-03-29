require 'singleton'
require 'sqlite3'
require_relative 'users'
require_relative 'questions'
require_relative 'replies'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super("questions.db")
    self.results_as_hash = true
    self.type_translation = true
  end
end
