class PagesController < ApplicationController
  before_action :set_comic
  before_action :set_comic_page, only: [:show, :update, :destroy]
  skip_before_action :authorize_request, only: [:index, :show]

  # GET /comics/:comic_id/pages
  def index
    json_response(@comic.pages)
  end

  # GET /comics/:comic_id/pages/:id
  def show
    json_response(@page)
  end

  # POST /comics/:comic_id/pages
  def create
    @comic.pages.create!(page_params)
    json_response(@comic, :created)
  end

  # PUT /comics/:comic_id/pages/:id
  def update
    @page.update(page_params)
    head :no_content
  end

  # DELETE /comics/:comic_id/pages/:id
  def destroy
    @page.destroy
    head :no_content
  end

  private

  def page_params
    params.permit(:title, :number, :is_public, :comic_id)
  end

  def set_comic
    @comic = Comic.find(params[:comic_id])
  end

  def set_comic_page
    @page = @comic.pages.find_by!(id: params[:id]) if @comic
  end
end
