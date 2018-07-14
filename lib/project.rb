class Project
  attr_reader(:id, :title)

  def initialize(attributes)
    @title = attributes.fetch(:title)
    @id = attributes.fetch(:id)
  end

  def ==(another_project)
    self.title.==(another_project.title)
  end

  def save
    result = DB.exec("INSERT INTO projects (title) VALUES ('#{@title}') RETURNING id;")
    @id = result.first.fetch('id').to_i
  end

  def self.all
    projects_in_db = DB.exec("SELECT * FROM projects;")
    projects = []
    projects_in_db.each do |project|
      title = project.fetch('title')
      id = project.fetch('id').to_i
      projects.push(Project.new({:title => title, :id => id}))
    end
    projects
  end

  def self.find(id)
    found_project = nil
    Project.all.each do |project|
      if project.id == id
        found_project = project
      end
    end
    found_project
  end

  def volunteers
    associated_volunteers = DB.exec("SELECT * FROM volunteers WHERE project_id = #{self.id};")
    volunteers = []
    associated_volunteers.each do |volunteer|
      id = volunteer.fetch('id').to_i
      name = volunteer.fetch('name')
      project_id = volunteer.fetch('project_id').to_i
      volunteers.push(Volunteer.new({:id => id, :name => name, :project_id => project_id}))
    end
    volunteers
  end

  def update(attributes)
    @title = attributes.fetch(:title, @title)
    if @title.length > 0
      DB.exec("UPDATE projects SET title = '#{@title}' WHERE id = #{self.id};")
    end
  end

  def delete
    DB.exec("DELETE FROM projects WHERE id = #{self.id};")
  end
end
