require 'sinatra'
require 'pry'
require 'pg'
require 'better_errors'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

set :conn, PG.connect(dbname: 'squadlab') 

before do
  @conn = settings.conn
end

#Root
get '/' do
  redirect '/squads'
end

#GET

get '/squads' do
  squads_all = []

  @conn.exec("SELECT * FROM squads ORDER BY squad_id ASC") do |result|
    result.each{|squad| squads_all << squad}
  end

  @squads = squads_all
  erb :index
end

get '/squads/new' do
  erb :squadnew
end

get '/squads/:squad_id/students/new' do
  squad = @conn.exec("SELECT * FROM squads WHERE squad_id=$1", [params[:squad_id].to_i])
  @squad = squad[0]
  erb :studentnew
end

get '/squads/:squad_id' do
  squad = @conn.exec("SELECT * FROM squads WHERE squad_id=$1", [params[:squad_id].to_i])
  @squad = squad[0]
  erb :squadshow
end

get '/squads/:squad_id/edit' do
end

get '/squads/:squad_id/students' do
  students = []
  # @conn.exec("SELECT * FROM squads JOIN students ON squads.squad_id=students.student_id WHERE squads.squad_id=$1", [params[:squad_id]]) do |result|
  @conn.exec("SELECT * FROM students WHERE squad_id=$1",[params[:squad_id].to_i]) do |result|
    puts result
    result.each {|student| students << student}
  end
  squad = @conn.exec("SELECT * FROM squads WHERE squad_id=$1", [params[:squad_id].to_i])
  @squad = squad[0]
  @students = students
  erb :studentshow
end

get '/squads/:squad_id/students/:student_id' do
  student = @conn.exec("SELECT * FROM students WHERE student_id=$1", [params[:student_id].to_i])
  @student = student[0]
  squad = @conn.exec("SELECT * FROM squads WHERE squad_id=$1", [params[:squad_id].to_i])
  @squad = squad[0]
  erb :studentdetail
end

get '/squads/:squad_id/students/:student_id/edit' do 
end

#Post 
post '/squads' do

end

post '/squads/:squad_id/students' do
end

#PUTS
put '/squads/:squad_id/:student_id' do

end

put '/squads/:squad_id/:students' do
end

#DELETE
delete '/squads/:squad_id' do

end

delete '/squads/:squad_id/students/:student_id' do
end













