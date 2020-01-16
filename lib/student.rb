require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade
  attr_reader :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize(id=nil,name,grade)
    @name = name
    @grade = grade
    @id = id
  end

  def save
    if @id
      self.update
    else
      sql = "INSERT INTO students (name,grade) VALUES ('#{@name}','#{@grade}');"
      DB[:conn].execute(sql)
      @id = DB[:conn].execute("SELECT id FROM students ORDER BY id DESC LIMIT 1;")[0][0]
    end
  end

  def update
    sql = "UPDATE students SET name='#{@name}', grade='#{@grade}' WHERE id=#{@id};"
    DB[:conn].execute(sql)
  end


  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students(
          id INTEGER PRIMARY KEY,
          name TEXT,
          grade TEXT
          );"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students"
    DB[:conn].execute(sql)
  end

  def self.create(given_name,given_grade)
    new_student = Student.new(id=nil,name=given_name,grade=given_grade)
    sql = "INSERT INTO students (name,grade) VALUES ('#{new_student.name}','#{new_student.grade}');"
    DB[:conn].execute(sql)
  end

  def self.new_from_db(row)
    Student.new(row[0],row[1],row[2])
  end

  def self.find_by_name(given_name)
    sql = "SELECT * FROM students WHERE name = '#{given_name}'"
    row = DB[:conn].execute(sql)[0]
    puts "#{row}"
    Student.new(id=row[0],name=row[1],grade=row[2])
  end

end
