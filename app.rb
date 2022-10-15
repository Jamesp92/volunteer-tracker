require('sinatra')
require('sinatra/reloader')
require('./lib/project')
require('./lib/volunteer')
require('pry')
require("pg")

also_reload('lib/**/*.rb')


DB = PG.connect({:dbname => "volunteer_tracker_test"})

get('/') do
  @projects = Project.all
  erb(:projects)
end

post('/projects') do
  project = Project.new({id: nil, title: params['title']})
  project.save()
  redirect to('/')
end


get('/') do
  redirect('/projects')
end

get('/projects') do
  @projects = Project.all
  erb(:projects)
end

post('/projects') do
  @projects = Project.all
  erb(:projects)
end

get('/projects/:id') do
  @project = Project.find(params[:id].to_i)
  erb(:project)
end

get('/projects/:id/edit') do
  @project = Project.find(params[:id].to_i)
  erb(:edit_project)
end

patch('/projects/:id') do
  @project = Project.find(params[:id])
  @project.update({:title => params["title"]})
  redirect to('/projects')
end

delete('/projects/:id') do
  @project = Project.find(params[:id].to_i)
  @project.delete
  redirect to('/projects')
end


get('/projects/:id/volunteers/:volunteer_id') do
  @volunteer = Volunteer.find(params[:volunteer_id].to_i)
  @project = Project.find(params[:id].to_i)
  erb(:volunteers)
end

post('/projects/:id/volunteers') do
  @project = Project.find(params[:id].to_i())
  volunteer = Volunteer.new({:name => params[:name], :project_id => @project.id, :id => nil})
  volunteer.save()
  erb(:project)
end

get('/volunteers') do
  @volunteers = Volunteer.all
  @project = Project.find(params[:id].to_i())
  erb(:volunteers)
end
