class MenusItemsController < ApplicationController
  before_action :set_menus_item, only: %i[ show edit update destroy ]

  # GET /menus_items or /menus_items.json
  def index
    @menus_items = MenusItem.all
  end

  # GET /menus_items/1 or /menus_items/1.json
  def show
  end

  # GET /menus_items/new
  def new
    @menus_item = MenusItem.new
  end

  # GET /menus_items/1/edit
  def edit
  end

  # POST /menus_items or /menus_items.json
  def create
    @menus_item = MenusItem.new(menus_item_params)

    respond_to do |format|
      if @menus_item.save
        format.html { redirect_to @menus_item, notice: "Menus item was successfully created." }
        format.json { render :show, status: :created, location: @menus_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @menus_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /menus_items/1 or /menus_items/1.json
  def update
    respond_to do |format|
      if @menus_item.update(menus_item_params)
        format.html { redirect_to @menus_item, notice: "Menus item was successfully updated." }
        format.json { render :show, status: :ok, location: @menus_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @menus_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /menus_items/1 or /menus_items/1.json
  def destroy
    @menus_item.destroy!

    respond_to do |format|
      format.html { redirect_to menus_items_path, status: :see_other, notice: "Menus item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_menus_item
      @menus_item = MenusItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def menus_item_params
      params.require(:menus_item).permit(:item_id, :menu_id)
    end
end
