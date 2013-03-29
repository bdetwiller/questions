
class User
  attr_accessor :fname, :lname, :is_instructor
  attr_reader :id

  def initialize(attributes)
    @id = attributes['id'] || nil
    @is_instructor = attributes['is_instructor'] || 0
    @fname = attributes['fname']
    @lname = attributes['lname']
  end

  def self.get_user(first_name, last_name)
    query = <<-SQL
      SELECT *
        FROM users
        WHERE fname = ? AND lname = ?
    SQL
    attributes = QuestionsDatabase.instance.execute(query, first_name, last_name)[0]
    User.new(attributes)
  end

  def self.find_by_id(id)
    query = <<-SQL
      SELECT *
        FROM users
        WHERE id = ?
    SQL
    attributes = QuestionsDatabase.instance.execute(query, id)[0]
    User.new(attributes)
  end

  def self.all
    query = <<-SQL
      SELECT *
        FROM users
    SQL
    hashes = QuestionsDatabase.instance.execute(query)

    hashes.map do |attributes|
      User.new(attributes)
    end
  end

  def save
    if @id.nil?
      query = <<-SQL
        INSERT INTO users
          ('fname', 'lname', 'is_instructor')
          VALUES (?,?,?)
      SQL
      QuestionsDatabase.instance.execute(query, @fname, @lname, @is_instructor)
    else
      query = <<-SQL
        UPDATE users
        SET 'fname'=?, 'lname'=?, 'is_instructor'=?
        WHERE id = ?
      SQL
      QuestionsDatabase.instance.execute(query, @fname, @lname, @is_instructor, @id)
    end

  end

  def asked_questions
    query = <<-SQL
      SELECT questions.id, title, body, author_id
        FROM users JOIN questions ON (users.id = questions.author_id)
        WHERE users.id = ?
    SQL

    hashes = QuestionsDatabase.instance.execute(query, @id)

    hashes.map do |attributes|
      Question.new(attributes)
    end
  end

  def replies
    query = <<-SQL
      SELECT question_replies.id, body, question_id, parent_id, author_id
        FROM users JOIN question_replies ON (users.id = author_id)
        WHERE users.id = ?
    SQL

    hashes = QuestionsDatabase.instance.execute(query, @id)

    hashes.map do |attributes|
      Reply.new(attributes)
    end
  end

  def average_karma
    #REV: Nie use of RUby to get things done.
    questions = asked_questions
    questions.inject(0) {|total, question| total += question.num_likes} / questions.count
  end

end