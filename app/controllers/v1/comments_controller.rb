module V1
  class CommentsController < ApplicationController
    before_action :set_comic_page, only: [:index, :show, :create, :update, :destroy, :author_destroy]
    before_action :set_comments, only: [:index, :show]
    skip_before_action :authorize_request, only: [:index, :show]

    # GET /comments/:comic_id/pages/:page_id
    def index
      payload = []
      @comments.each do |comment|
        user = User.find(comment.user_id)
        temp = comment.attributes
        temp['name'] = user.name
        temp['url'] = user.avatar.attachment ? url_for(user.avatar) : ''
        payload.push(temp)
      end
        json_response(payload)
    end

    # GET /comments/:comic_id/pages/:page_id/:id
    def show
      comment = @page.comments.find(params[:id])
      json_response(comment)
    end

    # POST /comments/:comic_id/pages/:page_id
    def create
      comment = @page.comments.create(user: current_user, message: params[:message])
      json_response(comment, :created)
    end

    # PUT /comments/:comic_id/pages/:page_id/:id
    def update
      comment = @page.comments.find(params[:id])
      comment.message = params[:message]
      comment.save if (current_user.id == comment.user_id)
      head :no_content
    end

    # DELETE /comments/:comic_id/pages/:page_id/:id
    def destroy
      comment = @page.comments.find(params[:id])
      comment.destroy if (current_user.id == comment.user_id)
      head :no_content
    end

    # DELETE /comments/:comic_id/pages/:page_id/:id
    def author_destroy
      comment = @page.comments.find(params[:id])
      comment.destroy
      head :no_content
    end

    private

    def comment_params
      params.permit(:message, :comic_id, :page_id, :id)
    end

    def set_comic_page
      comic = Comic.find(params[:comic_id])
      @page = comic.pages.find(params[:page_id])
    end

    def set_comments
      @comments = @page.comments
    end
  end
end
