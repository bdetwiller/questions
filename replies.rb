
class Reply
  attr_accessor :body, :question_id, :parent_id, :author_id
  attr_reader :id

  def initialize(attributes)
    @id = attributes['id']
    @body = attributes['body']
    @parent_id = attributes['parent_id']
    @question_id = attributes['question_id']
    @author_id = attributes['author_id']
  end

  def self.find_by_id(id)
    query = <<-SQL
      SELECT *
        FROM question_replies
        WHERE id = ?
    SQL
    attributes = QuestionsDatabase.instance.execute(query, id)[0]
    Reply.new(attributes)
  end

  def self.most_replied
    query = <<-SQL
      SELECT a.id, a.body, a.question_id, a.parent_id, a.author_id COUNT(*) AS num_replies
        FROM question_replies a JOIN question_replies b
        ON (a.id = b.parent_id)
        GROUP BY b.parent_id
        ORDER BY COUNT(*) DESC
    SQL

    Reply.new(QuestionsDatabase.instance.execute(query)[0])
  end

  def replies
    query = <<-SQL
      SELECT *
        FROM question_replies
        WHERE parent_id = ?
    SQL

    hashes = QuestionsDatabase.instance.execute(query, @id)
    hashes.map do |attributes|
      Reply.new(attributes)
    end
  end

end