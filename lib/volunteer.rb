class Volunteer
  attr_reader(:name, :id, :project_id)

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
    @project_id = attributes.fetch(:project_id)
  end

  def ==(another_volunteer)
    self.name.==(another_volunteer.name)
  end

  def save
    result = DB.exec("INSERT INTO volunteers (name, project_id) VALUES ('#{@name}', #{@project_id}) RETURNING id;")
    @id = result.first.fetch('id').to_i
  end

  def self.all
    volunteers_in_db = DB.exec("SELECT * FROM volunteers;")
    volunteers = []
    volunteers_in_db.each do |volunteer|
      name = volunteer.fetch('name')
      id = volunteer.fetch('id')
      project_id = volunteer.fetch('project_id')
      volunteers.push(Volunteer.new({:name => name, :id => id, :project_id => project_id}))
    end
    volunteers
  end
end
