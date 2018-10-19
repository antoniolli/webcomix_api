require 'rails_helper'

RSpec.describe 'Pages API' do
  # Initialize the test data
  let(:user) { create(:user) }
  let!(:comic) { create(:comic, user_id: user.id, is_public: true, is_comments_active: true) }
  let!(:pages) { create_list(:page, 20, comic_id: comic.id) }
  let(:comic_id) { comic.id }
  let(:page_id) { pages.first.id }
  let(:headers) { valid_headers }

  # Test suite for GET /comics/:comic_id/pages
  describe 'GET /comics/:comic_id/pages' do
    before { get "/comics/#{comic_id}/pages", params: {}, headers: headers }

    context 'when comic exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all comic pages' do
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

  # Test suite for GET /comics/:comic_id/pages/:id
  describe 'GET /comics/:comic_id/pages/:id' do
    before { get "/comics/#{comic_id}/pages/#{page_id}", params: {}, headers: headers }

    context 'when comic page exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the page' do
        expect(json["page"]["id"]).to eq(page_id)
      end
    end

    context 'when comic page does not exist' do
      let(:page_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Page/)
      end
    end
  end

  # Test suite for PUT /comics/:comic_id/pages
  describe 'POST /comics/:comic_id/pages' do
    let(:valid_attributes) {
      { title: 'Visit Narnia',
        number: 1,
        is_public: true,
        comic_id: comic.id }.to_json
      }

    context 'when request attributes are valid' do
      before do
        post "/comics/#{comic_id}/pages", params: valid_attributes, headers: headers
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/comics/#{comic_id}/pages", params: {}, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match("Validation failed: Title can't be blank, Number can't be blank, Is public can't be blank")
      end
    end
  end

  # Test suite for PUT /comics/:comic_id/pages/:id
  describe 'PUT /comics/:comic_id/pages/:id' do
    let(:valid_attributes) { { title: 'Mozart' }.to_json }

    before do
      put "/comics/#{comic_id}/pages/#{page_id}", params: valid_attributes, headers: headers
    end

    context 'when page exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the page' do
        updated_page = Page.find(page_id)
        expect(updated_page.title).to match(/Mozart/)
      end
    end

    context 'when the page does not exist' do
      let(:page_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Page/)
      end
    end
  end

  # Test suite for DELETE /comics/:id
  describe 'DELETE /comics/:id' do
    before { delete "/comics/#{comic_id}/pages/#{page_id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
