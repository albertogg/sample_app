class UsersController < ApplicationController
  
  def show
  	@user = User.find(params[:id])
  	@title = @user.name
  end

  def new
    @user = User.new
  	@title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      #handle correct
    else
      @title = "Sing up"
      render :action => 'new'
    end
    
  end

end
