require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:admin) { create(:user, admin: true) }
  let!(:category) { create(:category) }
  let!(:first_post) { create(:post, category: category, user: user) }

  describe "GET #edit" do
    let!(:comment) { create(:comment, post: first_post, user: user) }

    context 'guest' do
      it "render show edit" do
        get :edit, params: { id: comment }
        expect(response).to_not render_template(:edit)
      end
    end

    context 'wrong user' do
      before { sign_in(another_user) }

      it "render show edit" do
        get :edit, params: { id: comment }
        expect(response).to_not render_template(:edit)
      end
    end

    context 'author' do
      before { sign_in(user) }

      it "render show edit" do
        get :edit, params: { id: comment }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "PATCH #update" do
    let!(:comment) { create(:comment, post: first_post, user: user) }

    context 'guest' do
      it 'tries to update comment' do
        patch :update, params: { id: comment, comment: { body: 'newBody' } }
        comment.reload

        expect(comment.body).to_not eq 'newBody'
      end
    end

    context 'another user' do
      before { sign_in(another_user) }
      it 'tries to update comment' do
        patch :update, params: { id: comment, comment: { body: 'newBody' } }
        comment.reload

        expect(comment.body).to_not eq 'newBody'
      end
    end

    context 'author' do
      before { sign_in(user) }

      it 'tries to update comment' do
        patch :update, params: { id: comment, comment: { body: 'newBody' } }
        comment.reload

        expect(comment.body).to eq 'newBody'
      end

      it 'tries to update comment with invalid attr' do
        patch :update, params: { id: comment, comment: attributes_for(:comment, :invalid_comment) }
        comment.reload

        expect(comment.body).to eq 'MyComment'
      end

      it 'redirect to show after update' do
        patch :update, params: { id: comment, comment: { body: 'newBody' } }
        expect(response).to redirect_to post_path(comment.post)
      end

      it 're-render edit if not updated' do
        patch :update, params: { id: comment, comment: attributes_for(:comment, :invalid_comment) }
        expect(response).to render_template(:edit)
      end
    end

    context 'admin' do
      before { sign_in(admin) }

      it 'tries to update comment' do
        patch :update, params: { id: comment, comment: { body: 'newBody' } }
        comment.reload

        expect(comment.body).to eq 'newBody'
      end

      it 'tries to update comment with invalid attr' do
        patch :update, params: { id: comment, comment: attributes_for(:comment, :invalid_comment) }
        comment.reload

        expect(comment.body).to eq 'MyComment'
      end

      it 'redirect to show after update' do
        patch :update, params: { id: comment, comment: { body: 'newBody' } }
        expect(response).to redirect_to post_path(comment.post)
      end

      it 're-render edit if not updated' do
        patch :update, params: { id: comment, comment: attributes_for(:comment, :invalid_comment) }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "POST #create" do
    context 'guest' do
      it 'tries to create comment' do
        expect do
          post :create, params: { post_id: first_post, comment: attributes_for(:comment), format: :js }
        end.to_not change(Comment, :count)
      end
    end

    context 'user' do
      before { sign_in(user) }

      it 'tries to create comment' do
        expect do
          post :create, params: { post_id: first_post, comment: attributes_for(:comment), format: :js }
        end.to change(Comment, :count).by(1)
      end

      it 'tries to create comment with invalid attr' do
        expect do
          post :create, params: { post_id: first_post, comment: attributes_for(:comment, :invalid_comment), format: :js }
        end.to_not change(Comment, :count)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:comment) { create(:comment, post: first_post, user: user) }

    context 'guest' do
      it 'tries to create comment' do
        expect do
          delete :destroy, params: { id: comment, format: :js }
        end.to_not change(Comment, :count)
      end
    end

    context 'wrong user' do
      before { sign_in(another_user) }

      it 'tries to create comment' do
        expect do
          delete :destroy, params: { id: comment, format: :js }
        end.to_not change(Comment, :count)
      end
    end

    context 'author' do
      before { sign_in(user) }

      it 'tries to create comment' do
        expect do
          delete :destroy, params: { id: comment, format: :js }
        end.to change(Comment, :count).by(-1)
      end
    end

    context 'admin' do
      before { sign_in(admin) }

      it 'tries to create comment' do
        expect do
          delete :destroy, params: { id: comment, format: :js }
        end.to change(Comment, :count).by(-1)
      end
    end
  end
end
