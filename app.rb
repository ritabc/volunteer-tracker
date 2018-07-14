require('sinatra')
require("sinatra/reloader")
also_reload('lib/**/*.rb')
require('./lib/project')
require('./lib/volunteer')
require('pg')
require('pry')

DB = PG.connect({:dbname => 'volunteer_tracker'})

get('/') do
  @projects = Project.all
  erb(:index)
end

post('/') do
  title = params.fetch('title')
  project = Project.new({:title => title, :id => nil})
  project.save
  @projects = Project.all
  erb(:index)
end

get('/projects/:id') do
  project_id = params.fetch('id').to_i
  @project = Project.find(project_id)
  erb(:project)
end

get('/projects/:id/edit') do
  project_id = params.fetch('id').to_i
  @project = Project.find(project_id)
  erb(:edit_project)
end

patch('/projects/:id') do
  project_id = params.fetch('id').to_i
  title = params.fetch('title')
  @project = Project.find(project_id)
  @project.update({:title => title})
  erb(:project)
end

delete('/project-deleted') do
  project_id = params.fetch('project_id').to_i
  project = Project.find(project_id)
  project.delete
  @projects = Project.all
  erb(:index)
end

get('/volunteers/:id') do
  volunteer_id = params.fetch('id').to_i
  @volunteer = Volunteer.find(volunteer_id)
  erb(:volunteer)
end

patch('/volunteers/:id') do
  volunteer_id = params.fetch('id').to_i
  name = params.fetch('name')
  @volunteer = Volunteer.find(volunteer_id)
  @volunteer.update({:name => name})
  erb(:volunteer)
end

post('/volunteer-added') do
  project_id = params.fetch('project_id').to_i
  volunteer_name = params.fetch('name')
  volunteer = Volunteer.new({:id => nil, :name => volunteer_name, :project_id => project_id})
  volunteer.save
  @project = Project.find(project_id)
  erb(:project)
end
