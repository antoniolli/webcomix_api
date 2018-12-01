module V1
  class ComicsController < ApplicationController
    before_action :set_comic, only: [:show, :update, :destroy]
    skip_before_action :authorize_request, only: [:index, :show]

    # GET /comics
    def index
      payload = []
      @comics = Comic.all.paginate(page: params[:page], per_page: 20)
      @comics.each do |comic|
        temp = comic.attributes
        temp["author"] = User.find(comic.user_id).name
        temp["url"] = comic.cover.attachment ? url_for(comic.cover) : ''
        payload.push(temp)
      end
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
      payload["pages"] = @comic.pages
      json_response(payload)
    end

    def follow
      payload = { followed: true }
      json_response(payload)
    end

    # PUT /comics/:id
    def update
      @comic.update(comic_params)
      head :no_content
    end

    # DELETE /comics/:id
    def destroy
      @comic.destroy
      head :no_content
    end

    # GET /comics/user/:id
    def by_user
      @comics = current_user.comics
      json_response(@comics)
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

      #@comic = Comic.includes(:user).where("name LIKE ?", "%#{keyword}%").where("name LIKE ?", "%#{keyword}%")
      json_response(@comics)
    end

    private

    def comic_params
      # whitelist params
      params.permit(:name, :description, :is_public, :is_comments_active, :user_id, :cover, :by_word)
    end

    def set_comic
      @comic = Comic.find(params[:id])
    end
  end
end
