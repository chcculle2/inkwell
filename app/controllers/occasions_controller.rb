class OccasionsController < ApplicationController

  before_filter :authenticate_user!
  
  def index
    @upcoming_orders = current_user.upcoming_orders
    @future_orders = current_user.future_orders
  end

  def new
    @occasion = Occasion.new
  end
  
  def create

    params[:occasion][:date] = Date.strptime(params[:occasion][:date], "%m/%d/%Y") if params[:occasion][:date].class == String
    params[:occasion][:user_id] = current_user.id



    occasion = Occasion.new(params[:occasion])

    if occasion.save
      render :json => render_to_string(partial: "layouts/occasion", locals: {occasion: occasion}).to_json
    else
      # if errors render something back in json with error messages
    end
  end

  def edit
    @occasion = Occasion.find(params[:id])
    redirect_to user_root_path unless @occasion && @occasion.user == current_user
  end

  def update
    occasion = Occasion.find(params[:id])
    try_to_update(occasion, authorize_user: true)
  end

  def destroy
    Occasion.delete(params[:id])
    redirect_to occasions_path
  end

  private

  # See try_to_update in ApplicationController

#    def try_to_update(occasion)
#      if occasion && occasion.friend.user == current_user && occasion.update_attributes(params[:occasion])
#        redirect_to occasions_path
#      else
#        redirect_to user_root_path
#      end
#    end

end
