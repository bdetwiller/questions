
class Question
  attr_accessor :title, :body, :author_id
  attr_reader :id

  def initialize(attributes)
    @id = attributes['id']
    @title = attributes['title']
    @body = attributes['body']
    @author_id = attributes['author_id']
  end

  def self.get_question(title, author_id)
    query = <<-SQL
      SELECT *
        FROM questions
        WHERE title = ? AND author_id = ?
    SQL
    attributes = QuestionsDatabase.instance.execute(query, title, author_id)[0]
    Question.new(attributes)
  end

  def self.all
    query = <<-SQL
      SELECT *
        FROM questions
    SQL
    hashes = QuestionsDatabase.instance.execute(query)
    #REV: very nice way to translate the hashes array into question objects
    hashes.map do |attributes|
      Question.new(attributes)
    end
  end

  def self.find_by_id(id)
    query = <<-SQL
      SELECT *
        FROM questions
        WHERE id = ?
    SQL
    attributes = QuestionsDatabase.instance.execute(query, id)[0]
    Question.new(attributes)
  end

  def save
    if @id.nil?
      query = <<-SQL
        INSERT INTO questions
          ('title', 'body', 'author_id')
          VALUES (?,?,?)
      SQL
      QuestionsDatabase.instance.execute(query, @title, @body, @author_id)
    else
      query = <<-SQL
        UPDATE questions
        SET 'title'=?, 'body'=?
        WHERE id = ?
      SQL
      QuestionsDatabase.instance.execute(query, @title, @body, @id)
    end
  end

  def asking_student
    query = <<-SQL
      SELECT fname, lname, users.id
        FROM users JOIN questions ON (users.id = questions.author_id)
        WHERE author_id = ?
    SQL

    attributes = QuestionsDatabase.instance.execute(query, @id)[0]

    User.new(attributes)
  end

  def self.most_followed(number)
    query = <<-SQL
      SELECT *, COUNT(*) AS Followers
        FROM questions JOIN questions_followers
        ON (questions.id = questions_followers.question_id)
        GROUP BY question_id
        ORDER BY COUNT(*) DESC
        #REV: just put `LIMIT ?` and number down in #execute
    SQL
    hashes = QuestionsDatabase.instance.execute(query)
    #REV: then you don't need [0..number]
    hashes[0..number].map do |attributes|
      Question.new(attributes)
    end
  end

  def self.most_liked(number)
    query = <<-SQL
      SELECT *, COUNT(*) AS Likes
        FROM questions JOIN question_likes
        ON (questions.id = question_likes.question_id)
        GROUP BY question_id
        ORDER BY COUNT(*) DESC
    SQL
    hashes = QuestionsDatabase.instance.execute(query)

    hashes[0..number].map do |attributes|
      Question.new(attributes)
    end
  end

  def followers
    query = <<-SQL
      SELECT fname, lname, users.id
        FROM users JOIN questions ON (users.id = questions.author_id)
        WHERE questions.id = ?
    SQL

    hashes = QuestionsDatabase.instance.execute(query, @id)
    hashes.map do |attributes|
      User.new(attributes)
    end
  end

  def num_likes
    query = <<-SQL
      SELECT COUNT(*)
        FROM questions JOIN question_likes
        ON (questions.id = question_likes.question_id)
        WHERE questions.id = ?
    SQL
    QuestionsDatabase.instance.execute(query, @id)[0]["COUNT(*)"]
  end

end