class Dog
  attr_accessor :name, :breed, :id

  def initialize(attributes, id = nil)
    attributes.each {|key, value| self.send(("#{key}="),value) }
  end

  def save
    if id != nil
       self.update
    else
      sql = <<-SQL
       INSERT INTO dogs (name, breed) VALUES (?, ?)
      SQL
      DB[:conn].execute(sql,[@name, @breed])
      @id = DB[:conn].execute("SELECT last_insert_rowid()")[0][0]
      self
    end
  end

  def self.create(attributes)
    dog = self.new(attributes)
    dog.save
  end

  def self.find_by_id(id)
    sql = <<-SQL
    SELECT * FROM dogs
    WHERE dogs.id = ?
    SQL
    binding.pry
    row = DB[:conn].execute(sql,id)
    self.create_from_database(row.first)
  end

  def self.create_from_database(row)
    dog = self.new(id:row[0], name:row[1], breed:row[2])
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE dogs"
    DB[:conn].execute(sql)
  end
end
