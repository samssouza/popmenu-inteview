class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token, only: [:import]
  # GET /restaurants or /restaurants.json
  def index
    @restaurants = Restaurant.all
  end

  # GET /restaurants/1 or /restaurants/1.json
  def show
  end

  # GET /restaurants/new
  def new
    @restaurant = Restaurant.new
  end

  # GET /restaurants/1/edit
  def edit
  end

  # POST /restaurants or /restaurants.json
  def create
    @restaurant = Restaurant.new(restaurant_params)

    respond_to do |format|
      if @restaurant.save
        format.html { redirect_to @restaurant, notice: "Restaurant was successfully created." }
        format.json { render :show, status: :created, location: @restaurant }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /restaurants/1 or /restaurants/1.json
  def update
    respond_to do |format|
      if @restaurant.update(restaurant_params)
        format.html { redirect_to @restaurant, notice: "Restaurant was successfully updated." }
        format.json { render :show, status: :ok, location: @restaurant }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /restaurants/1 or /restaurants/1.json
  def destroy
    @restaurant.destroy!

    respond_to do |format|
      format.html { redirect_to restaurants_path, status: :see_other, notice: "Restaurant was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def import
    json_data = request.body.read
    service = RestaurantImportService.new(json_data)
    import_job  = service.call

    if import_job.completed?
      render json: {
        status: 'success',
        import_job_id: import_job.id,
        message: 'Import completed successfully',
        logs: import_job.import_logs.to_json
      }, status: :created
    else import_job.failed?
      render json: {
        status: 'error',
        import_job_id: import_job.id,
        message: 'Import failed',
        logs: import_job.import_logs.to_json
      }, status: :unprocessable_entity
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def restaurant_params
      params.require(:restaurant).permit(
        :name,
        menus_attributes: [
        :id,
        :name,
        :_destroy,
        menus_items_attributes: [
          :id,
          :item_id,
          :price,
          :_destroy
        ]
      ])
    end
end
