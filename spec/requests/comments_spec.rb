require 'rails_helper'

RSpec.describe 'Comments API' do
  # Initialize the test data
  let(:user) { create(:user) }
  let!(:comic) { create(:comic, user_id: user.id, is_public: true, is_comments_active: true) }
  let(:image) { FilesTestHelper.png }
  let!(:pages) { create_list(:page, 20, comic_id: comic.id, image: image) }
  let(:comic_id) { comic.id }
  let(:page_id) { pages.first.id }
  let(:headers) { valid_headers }

  # Test suite for GET /comics/:comic_id/pages
  describe 'GET /comments/:comic_id/:page_id' do
    before { get "/comments/#{comic_id}/#{page_id}", params: {}, headers: headers }

    context 'when page exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all comments' do
        expect(json.size).to eq(20)
      end
    end

    context 'when page does not exist' do
      let(:page_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match("Couldn't find Page with 'id'=0")
      end
    end
  end

  # Test suite for POST /comics/:comic_id/:pages_id
  describe 'POST /comments/:comic_id/:page_id' do
    let(:valid_attributes) {
      {
        message: "any message text"  }
      }

      context 'when request attributes are valid' do
        before do
          post "/comments/#{comic_id}/#{page_id}", params: valid_attributes, headers: headers
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'when an invalid request' do
        before { post "/comments/#{comic_id}/#{page_id}", params: {}, headers: headers }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a failure message' do
          expect(response.body).to match("Validation failed: Title can't be blank, Number can't be blank, Is public can't be blank")
        end
      end
    end

  # Test suite for PUT /comics/:comic_id/pages/:id
  describe 'PUT /comments/:comic_id/:page_id/:comment_id' do
    let(:valid_attributes) { { message: "New message" }.to_json }

    before do
      put "/comments/#{comic_id}/#{page_id}/#{comment_id}", params: valid_attributes, headers: headers
    end

    context 'when comment exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the comment' do
        updated_comment = comment.find_by(comment_id: comment_id)
        expect(updated_comment.message).to match("New message")
      end
    end

    context 'when the comment does not exist' do
      let(:comment_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Comment/)
      end
    end
  end

  # Test suite for DELETE /comics/:id
  describe 'DELETE /comments/:comic_id/:page_id/:comment_id' do
    before { delete "/comments/#{comic_id}/#{page_id}/#{comment_id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
