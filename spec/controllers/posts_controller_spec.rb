require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:valid_attributes) { { title: 'Test Title', body: 'Test Body' } }
  let(:invalid_attributes) { { title: nil, body: 'Test Body' } }
  let(:post) { Post.create! valid_attributes }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: post.to_param }
      expect(response).to be_successful
    end
  end

  # describe 'POST #create' do
  #   context 'with valid parameters' do
  #     it 'creates a new Post' do
  #       expect {
  #         post posts_path, params: { post: valid_attributes }, as: :json
  #       }.to change(Post, :count).by(1)
  #     end

  #     it 'renders a JSON response with the new post' do
  #       post posts_path, params: { post: valid_attributes }, as: :json
  #       expect(response).to have_http_status(:created)
  #       expect(response.content_type).to include('application/json')
  #     end
  #   end

  #   context 'with invalid parameters' do
  #     it 'renders a JSON response with errors for the new post' do
  #       post posts_path, params: { post: invalid_attributes }
  #       expect(response).to have_http_status(:unprocessable_entity)
  #     end
  #   end
  # end

  describe 'PUT #update' do
    context 'with valid parameters' do
      let(:new_attributes) { { title: 'New Title' } }

      it 'updates the requested post' do
        put :update, params: { id: post.to_param, post: new_attributes }
        post.reload
        expect(post.title).to eq('New Title')
      end

      it 'renders a JSON response with the post' do
        put :update, params: { id: post.to_param, post: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
      end
    end

    # context 'with invalid parameters' do
    #   it 'renders a JSON response with errors for the post' do
    #     put :update, params: { id: post.to_param, post: invalid_attributes }
    #     expect(response).to have_http_status(:unprocessable_entity)
    #   end
    # end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested post' do
      post
      expect {
        delete :destroy, params: { id: post.to_param }
      }.to change(Post, :count).by(-1)
    end
  end
end
