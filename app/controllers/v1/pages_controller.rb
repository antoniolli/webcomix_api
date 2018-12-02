module V1
  class PagesController < ApplicationController
    before_action :set_comic
    before_action :set_comic_page, only: [:show, :update, :update_number, :destroy]
    skip_before_action :authorize_request, only: [:index, :show]

    # GET /comics/:comic_id/pages
    def index
      payload = []
      @comic.pages.each do |page|
        temp = page.attributes
        temp["url"] = page.image.attachment ? url_for(page.image) : ''
        payload.push(temp)
      end
      json_response(payload)
    end

    # GET /comics/:comic_id/pages/:id
    def show
      payload = @page.attributes
      payload["url"] = @page.image.attachment ? url_for(@page.image) : ''
      json_response(payload)
    end

    # POST /comics/:comic_id/pages
    def create
      page = @comic.pages.create!(page_params)
      page.image.attach(page_params[:image])
      json_response(page, :created)
    end

    # PUT /comics/:comic_id/pages/:id
    def update
      @page.update(page_params)
      head :no_content
    end

    # PUT /comics/:comic_id/pages/:id
    def update_number
      @page.update_attribute('number', params[:number])
      head :no_content
    end

    # DELETE /comics/:comic_id/pages/:id
    def destroy
      @page.destroy
      head :no_content
    end

    private

    def page_params
      params.permit(:title, :number, :is_public, :comic_id, :image, :page_id, :id, :page)
    end

    def set_comic
      @comic = Comic.find(params[:comic_id])
    end

    def set_comic_page
      @page = @comic.pages.find_by!(id: params[:id]) if @comic
    end
  end
end
