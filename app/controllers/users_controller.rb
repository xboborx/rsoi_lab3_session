class UsersController < ApplicationController
def new

end

def create
  user = User.new(user_params)
  user.save
  response.headers["Location"]= SESSION+"users/"+user.id.to_s
  render :json => user.as_json, :status => 201
end

def createsession
  key = SecureRandom.hex(20)
 Rails.cache.write(key, params[:user_id])
  p Rails.cache.read(key)
 render :json => JSON["user_id" => params[:user_id], "key" => key], :status => 201
end

def getsession
  Rails.cache.read(params[:key])
  render :json => JSON["user_id" => Rails.cache.read(params[:key]), "key" => params[:key]], :status => 201
end


def index
  render :json => User.all.as_json
end

def view
  render :json => User.find_by_id(params[:id])
end

def validate
  user = User.find_by(:email => params[:email])
  p user.as_json


  if user && user.authenticate(params[:password])
    render :json => JSON["id" => user.id]
  else
    # If user's login doesn't work, send them back to the login form.
    render :json => JSON["status" => "not found"], :status => 404
  end
end

private

def user_params
 params.permit(:name, :email, :password)
end

end
