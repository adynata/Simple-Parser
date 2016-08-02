class TextsController < ApplicationController
  before_action :set_text, only: [:show, :edit]

  def index
    render json: Text.all
  end

  def show
    render json: Text.find(params[:id])
  end

  # GET /texts/new
  def new
    @text = Text.new
  end

  # GET /texts/1/edit
  def edit
  end

  # POST /texts
  # POST /texts.json
  def create
    @text = Text.new(text_params)
    if @text.save!
      render json: @text
    else
      flash.now[:errors] = @text.errors.full_messages
      render json: @text
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_text
      @text = Text.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def text_params
      params.require(:text).permit(:post, :id)
    end
end
