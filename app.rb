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
  @id = params[:squad_id].to_i
  squad = @conn.exec("SELECT * FROM squads WHERE squad_id=$1", [params[:squad_id].to_i])
  @squad = squad[0]
  erb :squadedit
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
  student = @conn.exec("SELECT * FROM students WHERE student_id=$1", [params[:student_id].to_i])
  @student = student[0]
  erb :studentedit
end

#Post 
post '/squads' do
  @conn.exec("INSERT INTO squads (name, mascot) VALUES ($1, $2)", [params[:name],params[:mascot]])
  redirect '/squads'
end

post '/squads/:squad_id/students' do
  @conn.exec("INSERT INTO students (name, age, spirit_animal, squad_id) VALUES ($1, $2, $3, $4)", [params[:name], params[:age].to_i, params[:animal], params[:squadid].to_i])
  redirect "/squads/#{params[:squadid].to_i}/students"
end

#PUTS
put '/squads/:squad_id/students/:student_id' do
  @conn.exec("UPDATE students SET name=$1, age=$2, spirit_animal=$3, squad_id=$4 WHERE student_id=$5", [params[:name], params[:age].to_i, params[:spirit_animal], params[:squadid].to_i, params[:student_id].to_i])
  redirect "/squads/#{params[:squadid]}/students/#{params[:student_id]}"
end

put '/squads/:squad_id' do
  @conn.exec("UPDATE squads SET name=$1, mascot=$2 WHERE squad_id=$3", [params[:name], params[:mascot], params[:squad_id].to_i])
  redirect "/squads/#{params[:squad_id].to_i}"
end

#DELETE
delete '/squads/:squad_id' do
  @conn.exec("DELETE FROM squads WHERE squad_id=$1", [params[:squad_id].to_i])
  redirect "/squads"
end

delete '/squads/:squad_id/students/:student_id' do
  @conn.exec("DELETE FROM students WHERE student_id=$1", [params[:student_id].to_i])
  redirect "/squads/#{params['squad_id']}/students"
end













