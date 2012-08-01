class SessionsController < ApplicationController
  def create
    @auth = env["omniauth.auth"]
    @user = User.from_omniauth(@auth)
    session[:user] = @user
  end

  def create_payment
    @user = session[:user]
    @user.email = params[:email]
    @user.first_name = params[:first_name]
    @user.last_name = params[:last_name]
    
    @user.save_with_payment(params[:user_stripe_card_token])
    
    redirect_to root_url, :notice => "Thank you #{@user.name} your payment was successfully processed!"
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end