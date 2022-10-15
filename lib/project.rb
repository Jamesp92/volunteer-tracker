class Project
  attr_reader :id
  attr_accessor :title

  def initialize(attributes)
    @title = attributes.fetch(:title)
    @id = attributes.fetch(:id)
  end

  def ==(project_to_compare)
    self.title() == project_to_compare.title()
  end

  def self.all
    results = DB.exec("SELECT * FROM projects;")
    projects = []
    results.each do |project|
      id = project.fetch('id').to_i
      title = project.fetch('title')
      projects.push(Project.new({id: id, title: title}))
    end
    projects
  end

  def save
    result = DB.exec("INSERT INTO projects (title) VALUES ('#{@title}') RETURNING id;")
    @id = result.first().fetch('id').to_i
  end

   def self.find(id)
    project = DB.exec("SELECT * FROM projects WHERE id = #{id};").first
    if project
      title = project.fetch("title")
      id = project.fetch("id").to_i
      Project.new({:title => title, :id => id})
    else
      nil
    end
  end

  def update(attributes)
    if (attributes.has_key?(:title)) && (attributes.fetch(:title) != nil)
      @title = attributes.fetch(:title)
      DB.exec("UPDATE projects SET title = '#{@title}' WHERE id = #{@id}")
    end
  end

  def volunteers
    volunteers = []
    results = DB.exec("SELECT * FROM volunteers WHERE project_id = #{@id}")
    results.each do |volunteer|
      id = volunteer.fetch('id').to_i
      name = volunteer.fetch('name')
      project_id = volunteer.fetch('project_id').to_i
      volunteers.push(Volunteer.new({id: id, name: name, project_id: project_id}))
    end
    volunteers
  end

  def delete
    DB.exec("DELETE FROM projects WHERE id = #{@id};")
  end

  def self.clear
    DB.exec("DELETE FROM projects *;")
  end
end