class V2::ComicsController < ApplicationController
  def index
    json_response({ message: 'API version 2'})
  end
end
