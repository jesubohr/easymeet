class BookingTypesController < ApplicationController
  before_action :set_booking_type, only: %i[ show edit update destroy ]

  # GET /booking_types or /booking_types.json
  def index
    @booking_types = current_user.booking_types
  end

  # GET /booking_types/1 or /booking_types/1.json
  def show
  end

  # GET /booking_types/new
  def new
    @booking_type = current_user.booking_types.new
  end

  # GET /booking_types/1/edit
  def edit
  end

  # POST /booking_types or /booking_types.json
  def create
    @booking_type = current_user.booking_types.new(booking_type_params.merge(user_id: current_user.id))

    respond_to do |format|
      if @booking_type.save
        format.html { redirect_to root_path, notice: "Booking type was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /booking_types/1 or /booking_types/1.json
  def update
    respond_to do |format|
      if @booking_type.update(booking_type_params)
        format.html { redirect_to root_path, notice: "Booking type was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /booking_types/1 or /booking_types/1.json
  def destroy
    @booking_type.destroy

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Booking type was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking_type
      @booking_type = BookingType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def booking_type_params
      required_info = params.require(:booking_type).permit(:name, :location, :description, :color, :duration, :payment_required, :price)

      {
        name: required_info[:name].downcase,
        location: required_info[:location].downcase,
        description: required_info[:description],
        color: required_info[:color],
        duration: required_info[:duration],
        payment_required: required_info[:payment_required],
        price: required_info[:price]
      }
    end
end
