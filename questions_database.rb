require 'singleton'
require 'sqlite3'
require_relative 'users'
require_relative 'questions'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super("questions.db")
    self.results_as_hash = true
    self.type_translation = true
  end
end

# p bryant = User.get_user("Bryant","Detwiller")
# p bryant.asked_questions

p Question.most_followed(2)



