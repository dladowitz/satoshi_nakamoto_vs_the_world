class TrackersController < ApplicationController
  before_action :set_tracker, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  ALPHA_VANTAGE_URL = "https://www.alphavantage.co/query?function=TIME_SERIES_WEEKLY&apikey=#{ENV['ALPHA_VANTAGE_KEY']}"
  NOMICS_URL =        "https://api.nomics.com/v1/currencies/sparkline?key=#{ENV['NOMICS_KEY']}"

  # GET /trackers
  # GET /trackers.json
  def index
    @trackers = current_user.trackers
  end

  # GET /trackers/1
  # GET /trackers/1.json
  def show
    @crypto_asset = crypto_asset_data
    @stock_asset = stock_asset_data
  end

  # GET /trackers/new
  def new
    @tracker = Tracker.new
  end

  # GET /trackers/1/edit
  def edit
  end

  # POST /trackers
  # POST /trackers.json
  def create
    @tracker = Tracker.new(tracker_params.merge(user_id: current_user.id))

    respond_to do |format|
      if @tracker.save
        format.html { redirect_to @tracker, notice: 'Tracker was successfully created.' }
        format.json { render :show, status: :created, location: @tracker }
      else
        format.html { render :new }
        format.json { render json: @tracker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trackers/1
  # PATCH/PUT /trackers/1.json
  def update
    respond_to do |format|
      if @tracker.update(tracker_params)
        format.html { redirect_to @tracker, notice: 'Tracker was successfully updated.' }
        format.json { render :show, status: :ok, location: @tracker }
      else
        format.html { render :edit }
        format.json { render json: @tracker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trackers/1
  # DELETE /trackers/1.json
  def destroy
    @tracker.destroy
    respond_to do |format|
      format.html { redirect_to trackers_url, notice: 'Tracker was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tracker
      @tracker = Tracker.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tracker_params
      params.require(:tracker).permit(:name, :asset_one, :asset_two, :start_date)
    end

    def crypto_asset_data
      start_date = @tracker.start_date.strftime
      nomics_data = HTTParty.get(NOMICS_URL + "&start=#{start_date}T00%3A00%3A00Z")
      nomics_data.select {|asset| asset["currency"] == @tracker.asset_one}.first
    end

    def stock_asset_data
      start_date = @tracker.start_date.to_s
      data = HTTParty.get(ALPHA_VANTAGE_URL + "&symbol=#{@tracker.asset_two}")
      close_date = data["Meta Data"]["3. Last Refreshed"]

      time_series = data["Weekly Time Series"].map {|date| date[1]["4. close"] if date[0] >= start_date }.compact.reverse

      { "open" => time_series.first, "close" => time_series.last, "time_series" => time_series }
    end
end
