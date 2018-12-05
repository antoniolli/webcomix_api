module V1
  class PagesController < ApplicationController
    before_action :set_comic
    before_action :set_comic_page, only: [:show, :update, :update_number, :by_user, :destroy]
    skip_before_action :authorize_request, only: [:index, :show]

    # GET /comics/:comic_id/pages
    def index
      payload = []
      @comic.pages.each do |page|
        temp = page.attributes
        temp["name"] = @comic.name
        temp["url"] = page.image.attachment ? url_for(page.image) : ''
        payload.push(temp) if page.is_public == true
      end
      json_response(payload)
    end

    # GET /comics/:comic_id/pages/:id
    def show
      payload = @page.attributes
      payload["url"] = @page.image.attachment ? url_for(@page.image) : ''
      json_response(payload) if @page.is_public == true
    end

    # POST /comics/:comic_id/pages
    def create
      page = @comic.pages.create!(page_params)
      page.image.attach(page_params[:image])
      json_response(page, :created)
    end

    # PUT /comics/:comic_id/pages/:id
    def update
      @page.update_attribute('title', params[:title])
      @page.update_attribute('number', params[:number])
      @page.image.attach(params[:image]) if params[:image]
      @page.update_attribute('is_public', params[:is_public])
      @page.save
      json_response(@page)
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

    def by_user
      if(current_user.id == @comic.user_id)
        payload = @page.attributes
        payload['url'] = @page.image.attachment ? url_for(@page.image) : ''
        json_response(payload)
      else
        json_response(null)
      end
    end

    def all_by_user
      if(current_user.id == @comic.user_id)
        payload = []
        @comic.pages.each do |page|
          temp = page.attributes
          temp["name"] = @comic.name
          temp["url"] = page.image.attachment ? url_for(page.image) : ''
          payload.push(temp)
        end
        json_response(payload)
      else
        json_response({})
      end
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
