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

get('/project/:id') do
  project_id = params.fetch('id').to_i
  @project = Project.find(project_id)
  erb(:project)
end

get('/update-project/:id') do
  project_id = params.fetch('id').to_i
  @project = Project.find(project_id)
  erb(:update_project)
end

patch('/project/:id') do
  project_id = params.fetch('id').to_i
  title = params.fetch('title')
  @project = Project.find(project_id)
  @project.update({:title => title})
  erb(:project)
end
