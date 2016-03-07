class WizardsController < ApplicationController
  def new
    @wizard = Wizard.new
  end

  def create
    @wizard = Wizard.new(wizard_params)
    if @wizard.save
      sign_in(@wizard)
      redirect_to courses_url
    else
      flash.now[:errors] = @wizard.errors.full_messages
      render :new
    end
  end

  private
  def wizard_params
    params.require(:wizard).permit(:password, :username)
  end
end
