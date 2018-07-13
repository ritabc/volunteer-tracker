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
  @project = Project.find(:id)
  erb(:project)
end

get('/update-project/:id') do
  @project = Project.find(:id)
  erb(:update_project)
end

patch('/project/:id') do
  title = params.fetch('title')
  @project = Project.find(:id)
  @project.update({:title => title})
end
