class Dog

attr_accessor :name, :breed
attr_reader :id

  def initialize(name:, breed:, id: nil)
    @id = id
    @name = name
    @breed= breed
  end

  def self.create_table
    sql = "CREATE TABLE dogs (id INTEGER PRIMARY KEY, name TEXT, breed TEXT)"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE dogs"
    DB[:conn].execute(sql)
  end

  def save
    sql = "INSERT INTO dogs (name, breed) VALUES (?, ?)"
    DB[:conn].execute(sql, self.name, self.breed)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
  end

  def self.create(name:, breed:)
    new_dog = Dog.new(name: name, breed: breed)
    new_dog.save
    new_dog
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM dogs WHERE id = ?"
    row = DB[:conn].execute(sql, name:, breed:)
    Dog.new(id: row[0][0], name: row[0][1], breed: row[0][2])
  end

  def self.find_or_create_by(name:, breed:)
    sql = "SELECT * FROM dogs WHERE name = ?, breed = ?"
    dog = DB[:conn].execute(sql, name, breed).flatten
    if !dog.empty?
      dog = Dog.new(id: dog[0], name: dog[1], breed: dog[2])
    else
      dog = Dog.create(name: name, breed: breed)
    end
    dog
  end

end
