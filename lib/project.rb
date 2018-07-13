class Project
  attr_reader(:id, :title)

  def initialize(attributes)
    @title = attributes.fetch(:title)
    @id = attributes.fetch(:id)
  end

  def ==(another_project)
    self.title.==(another_project.title)
  end
end
