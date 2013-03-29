
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
    
    questions = QuestionsDatabase.instance.execute(query)
    questions.map { |attributes| Question.new(attributes) }
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
          VALUES (?, ?, ?)
      SQL
      QuestionsDatabase.instance.execute(query, @title, @body, @author_id)
    else
      query = <<-SQL
        UPDATE questions
        SET 'title'= ?, 'body'= ?
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
        LIMIT ?
    SQL
    
    questions = QuestionsDatabase.instance.execute(query, number)
    questions.map { |attributes| Question.new(attributes) }
    end
  end

  def self.most_liked(number)
    query = <<-SQL
      SELECT *, COUNT(*) AS Likes
        FROM questions JOIN question_likes
        ON (questions.id = question_likes.question_id)
        GROUP BY question_id
        ORDER BY COUNT(*) DESC
        LIMIT ?
    SQL
    
    questions = QuestionsDatabase.instance.execute(query, number)
    questions.map { |attributes| Question.new(attributes) }
    end
  end

  def followers
    query = <<-SQL
      SELECT fname, lname, users.id
        FROM users JOIN questions ON (users.id = questions.author_id)
        WHERE questions.id = ?
    SQL

    users = QuestionsDatabase.instance.execute(query, @id)
    users.map { |attributes| User.new(attributes) }
    end
  end

  def num_likes
    query = <<-SQL
      SELECT COUNT(*) AS Likes
        FROM questions JOIN question_likes
        ON (questions.id = question_likes.question_id)
        WHERE questions.id = ?
    SQL
    QuestionsDatabase.instance.execute(query, @id)[0]["Likes"]
  end

end