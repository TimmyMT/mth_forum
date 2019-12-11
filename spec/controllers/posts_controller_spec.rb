require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:admin) { create(:user, admin: true) }
  let!(:category) { create(:category) }

  describe "GET #show" do
    let!(:post) { create(:post, category: category, user: user) }
    before { get :show, params: { id: post } }

    it "render show view" do
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    context "guest" do
      before { get :new, params: { category_id: category } }
      it 'tries to get new view' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "user" do
      before do
        sign_in(user)
        get :new, params: { category_id: category }
      end

      it 'tries to get new view' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    let!(:post) { create(:post, user: user, category: category) }

    context 'guest' do
      before { get :edit, params: { id: post, category_id: category } }
      it 'tries to get edit view' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'user' do
      before do
        sign_in(user)
        get :edit, params: { id: post, category_id: category }
      end

      it 'tries to get edit view' do
        expect(response).to render_template(:edit)
      end
    end

    context 'user' do
      before do
        sign_in(admin)
        get :edit, params: { id: post, category_id: category }
      end

      it 'tries to get edit view' do
        expect(response).to render_template(:edit)
      end
    end

    context 'another user' do
      before do
        sign_in(another_user)
        get :edit, params: { id: post, category_id: category }
      end

      it 'tries to get edit view' do
        expect(response).to_not render_template(:edit)
      end
    end
  end

  describe "POST #create" do
    context 'guest' do
      it 'tries to create new post' do
        expect do
          post :create, params: { category_id: category, post: attributes_for(:post) }
        end.to_not change(Post, :count)
      end
    end

    context 'user' do
      before { sign_in(user) }

      it 'tries to create new post with valid attr' do
        expect do
          post :create, params: { category_id: category, post: attributes_for(:post) }
        end.to change(Post, :count).by(1)
      end

      it 'tries to create new post with not valid attr' do
        expect do
          post :create, params: { category_id: category, post: attributes_for(:post, :invalid_post) }
        end.to_not change(Post, :count)
      end

      it 'redirect after create' do
        post :create, params: { category_id: category, post: attributes_for(:post) }
        expect(response).to redirect_to post_path(Post.last)
      end

      it 're-render new' do
        post :create, params: { category_id: category, post: attributes_for(:post, :invalid_post) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    let!(:post) { create(:post, category: category, user: user) }

    context 'guest' do
      it 'tries to update post' do
        patch :update, params: { id: post, category_id: category, post: { title: 'newTitle', body: 'newBody' } }
        post.reload

        expect(post.title).to_not eq 'newTitle'
        expect(post.body).to_not eq 'newBody'
      end
    end

    context 'another user' do
      before { sign_in(another_user) }
      it 'tries to update post' do
        patch :update, params: { id: post, category_id: category, post: { title: 'newTitle', body: 'newBody' } }
        post.reload

        expect(post.title).to_not eq 'newTitle'
        expect(post.body).to_not eq 'newBody'
      end
    end

    context 'author' do
      before { sign_in(user) }

      it 'tries to update post' do
        patch :update, params: { id: post, category_id: category, post: { title: 'newTitle', body: 'newBody' } }
        post.reload

        expect(post.title).to eq 'newTitle'
        expect(post.body).to eq 'newBody'
      end

      it 'tries to update post with invalid attr' do
        patch :update, params: { id: post, category_id: category, post: attributes_for(:post, :invalid_post) }
        post.reload

        expect(post.title).to eq 'MyString'
        expect(post.body).to eq 'MyText'
      end

      it 'redirect to show after update' do
        patch :update, params: { id: post, category_id: category, post: { title: 'newTitle', body: 'newBody' } }
        expect(response).to redirect_to post_path(post)
      end

      it 're-render edit if not updated' do
        patch :update, params: { id: post, category_id: category, post: attributes_for(:post, :invalid_post) }
        expect(response).to render_template(:edit)
      end
    end

    context 'admin' do
      before { sign_in(admin) }

      it 'tries to update post' do
        patch :update, params: { id: post, category_id: category, post: { title: 'newTitle', body: 'newBody' } }
        post.reload

        expect(post.title).to eq 'newTitle'
        expect(post.body).to eq 'newBody'
      end

      it 'tries to update post with invalid attr' do
        patch :update, params: { id: post, category_id: category, post: attributes_for(:post, :invalid_post) }
        post.reload

        expect(post.title).to eq 'MyString'
        expect(post.body).to eq 'MyText'
      end

      it 'redirect to show after update' do
        patch :update, params: { id: post, category_id: category, post: { title: 'newTitle', body: 'newBody' } }
        expect(response).to redirect_to post_path(post)
      end

      it 're-render edit if not updated' do
        patch :update, params: { id: post, category_id: category, post: attributes_for(:post, :invalid_post) }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:post) { create(:post, category: category, user: user) }

    context 'guest' do
      it 'tries to delete post' do
        expect do
          delete :destroy, params: { id: post, category_id: category }
        end.to_not change(Post, :count)
      end

      it 'redirect to sign_in' do
        delete :destroy, params: { id: post, category_id: category }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'not author' do
      before { sign_in(another_user) }

      it 'tries to delete post' do
        expect do
          delete :destroy, params: { id: post, category_id: category }
        end.to_not change(Post, :count)
      end
    end

    context 'author' do
      before { sign_in(user) }

      it 'tries to delete post' do
        expect do
          delete :destroy, params: { id: post, category_id: category }
        end.to change(Post, :count).by(-1)
      end

      it 'redirect after deleted' do
        delete :destroy, params: { id: post, category_id: category }
        expect(response).to redirect_to category_path(category)
      end
    end

    context 'admin' do
      before { sign_in(admin) }

      it 'tries to delete post' do
        expect do
          delete :destroy, params: { id: post, category_id: category }
        end.to change(Post, :count).by(-1)
      end

      it 'redirect after deleted' do
        delete :destroy, params: { id: post, category_id: category }
        expect(response).to redirect_to category_path(category)
      end
    end
  end
end
