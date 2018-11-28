require 'rails_helper'

RSpec.describe 'Subscriber API' do
  # Initialize the test data
  let(:user) { create(:user) }
  let!(:comic) { create(:comic, user_id: user.id, is_public: true, is_comments_active: true) }
  let(:comic_id) { comic.id }
  let(:headers) { valid_headers }

  # Test suite for GET /comics/:comic_id/pages
  describe 'GET /subscribers/:comic_id' do
    before { get "/subscribers/#{comic_id}", params: {}, headers: headers }

    context 'when comic exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all subscribers' do
        expect(json.size).to eq(20)
      end
    end

    context 'when comic does not exist' do
      let(:comic_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match("Couldn't find Comic with 'id'=0")
      end
    end
  end

  # Test suite for POST /comics/:comic_id/pages
  describe 'POST /subscribers/:comic_id' do
    let(:valid_attributes) {
        { is_blocked: true,
          comic_id: comic_id  }
      }

    context 'when request attributes are valid' do
      before do
        post "/subscribers/#{comic_id}", params: valid_attributes, headers: headers
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/subscribers/#{comic_id}", params: {}, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match("Validation failed: Title can't be blank, Number can't be blank, Is public can't be blank")
      end
    end
  end

  # Test suite for PUT /comics/:comic_id/pages/:id
  describe 'PUT /subscribers/:comic_id/:user_id' do
    let(:valid_attributes) { { is_blocked: true }.to_json }

    before do
      put "/subscribers/#{comic_id}/#{user_id}", params: valid_attributes, headers: headers
    end

    context 'when subscriber exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the subscriber' do
        updated_subscriber = Subscriber.find_by(comic_id: comic_id, user_id: user_id)
        expect(updated_subscriber.is_blocked).to match(true)
      end
    end

    context 'when the subscriber does not exist' do
      let(:user_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Page/)
      end
    end
  end

  # Test suite for DELETE /comics/:id
  describe 'DELETE /subscribers/#{comic_id}' do
    before { delete "/subscribers/#{comic_id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
