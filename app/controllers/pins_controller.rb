class PinsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @pins = Pin.all.order('created_at DESC')
  end

  def new
    @pin = Pin.new
  end

  def create
    pin = Pin.new(pin_params)
    pin.user = current_user
    if pin.save
      redirect_to root_path, notice: "El pin fue creado exitosamente"
    else
      render :new
    end
  end

  def authenticate
    user = User.find_by(email: request.headers['HTTP_X_USER_EMAIL'])
    acces = user ? request.headers['X-API-TOKEN'] == user.api_token : false
    unless acces
    render json: { errors: "Acceso denegado" }, status: 401
    end
  end

  private
    def pin_params
      params.require(:pin).permit(:title, :image_url)
    end
end
