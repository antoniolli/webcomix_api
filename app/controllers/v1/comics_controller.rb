module V1
  class ComicsController < ApplicationController
    before_action :set_comic, only: [:show, :update, :destroy]
    skip_before_action :authorize_request, only: [:index, :show, :search]

    # GET /comics
    def index
      @comics = Comic.where(:is_public => true)
      payload = get_url(@comics)
      json_response(payload)
    end

    # POST /comics
    def create
      @comic = current_user.comics.create!(comic_params)
      @comic.cover.attach(comic_params[:cover])
      json_response(@comic, :created)
    end

    # GET /comics/:id
    def show
      payload = @comic.attributes
      payload["author"] = User.find(@comic.user_id).name
      payload["url"] = @comic.cover.attachment ? url_for(@comic.cover) : ''
      temp = []
      @comic.pages.each do |page|
        pag = page.attributes
        pag["url"] = page.image.attachment ? url_for(page.image) : ''
        temp.push(pag) if page.is_public == true
      end
      payload["pages"] = temp
      json_response(payload)
    end

    def follow
      payload = { followed: true }
      json_response(payload)
    end

    # PUT /comics/:id
    def update
      @comic.update_attributes(comic_params)
      @comic.cover.attach(comic_params[:cover]) if comic_params[:cover]
      json_response(@comic)
    end

    # DELETE /comics/:id
    def destroy
      @comic.destroy
      head :no_content
    end

    # GET /comics/user/:id
    def all_by_user
      @comics = current_user.comics
      payload = get_url(@comics)
      json_response(payload)
    end

    # GET /comics/user/:id
    def by_user
      comic = current_user.comics.find(params[:id])
      payload = comic.attributes
      payload['url'] = comic.cover.attachment ? url_for(comic.cover) : ''
      json_response(payload)
    end

    # GET /comics/user/:id
    def search
      keyword = "%#{params[:by_word]}%"
      usersT = Arel::Table.new(:users)
      comicsT = Arel::Table.new(:comics)
      params_matches_string = ->(param){
        comicsT[param].matches(keyword)
      }
      params_matches_string_user = ->(param){
        usersT[param].matches(keyword)
      }

      @comics = Comic.joins(:user).where(params_matches_string.(:name).or(params_matches_string_user.(:name)))
      payload = get_url(@comics)
      json_response(payload)
    end

    private

    def comic_params
      # whitelist params
      params.permit(:name, :description, :is_public, :is_comments_active, :user_id, :cover, :by_word)
    end

    def set_comic
      @comic = Comic.find(params[:id])
    end

    def get_url(comics)
      payload = []
      comics.each do |comic|
        temp = comic.attributes
        temp["author"] = User.find(comic.user_id).name
        temp["url"] = comic.cover.attachment ? url_for(comic.cover) : ''
        payload.push(temp)
      end
      return payload
    end
  end
end
