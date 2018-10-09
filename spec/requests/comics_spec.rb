require 'rails_helper'

RSpec.describe 'Comics API', type: :request do
  # initialize test data
  let!(:comics) { create_list(:comic, 10) }
  let(:comic_id) { comics.first.id }

  # Test suite for GET /comics
  describe 'GET /comics' do
    # make HTTP get request before each example
    before { get '/comics' }

    it 'returns comics' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /comics/:id
  describe 'GET /comics/:id' do
    before { get "/comics/#{comic_id}" }

    context 'when the record exists' do
      it 'returns the comic' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(comic_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:comic_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find comic/)
      end
    end
  end

  # Test suite for POST /comics
  describe 'POST /comics' do
    # valid payload
    let(:valid_attributes) { { name: 'Spiderman', description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam non euismod quam, vitae cursus ligula. Donec dignissim dui elit, id venenatis nibh consectetur in. Suspendisse potenti. Quisque vel est viverra, posuere ante vitae, posuere eros. Curabitur fermentum nibh dolor, eu facilisis urna condimentum a. Praesent id leo varius, elementum leo a, blandit eros. Pellentesque in nunc ac arcu vestibulum ultricies a non urna. Sed feugiat nulla a nulla pharetra posuere. Etiam sed pharetra felis. Pellentesque aliquet tincidunt viverra. Quisque rutrum molestie turpis a sagittis. Vestibulum sed quam et augue volutpat lacinia in vitae erat. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar risus at arcu ornare porttitor.', is_public: true, is_comments_active: true } }

    context 'when the request is valid' do
      before { post '/comics', params: valid_attributes }

      it 'creates a comic' do
        expect(json['name']).to eq('Spiderman')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/comics', params: { name: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Created by can't be blank/)
      end
    end
  end

  # Test suite for PUT /comics/:id
  describe 'PUT /comics/:id' do
    let(:valid_attributes) { { name: 'Batman' } }

    context 'when the record exists' do
      before { put "/comics/#{comic_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /comics/:id
  describe 'DELETE /comics/:id' do
    before { delete "/comics/#{comic_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
