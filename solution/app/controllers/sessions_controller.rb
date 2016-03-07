class SessionsController < ApplicationController
  def new
  end

  def create
    wizard = Wizard.find_by_credentials(
      params[:wizard][:username],
      params[:wizard][:password]
    )

    if wizard
      sign_in(wizard)
      redirect_to courses_url
    else
      flash.now[:errors] = ["Invalid username or password"]
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to new_session_url
  end
end
