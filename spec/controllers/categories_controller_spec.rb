require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:user, admin: true) }

  describe "GET #index" do
    let!(:categories) { create_list(:category, 3) }
    before { get :index }

    it "show array of categories" do
      expect(assigns(:categories)).to match_array(categories)
    end

    it "render index view" do
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    let!(:category) { create(:category, name: "TestCat") }

    before { get :show, params: { id: category } }

    it "render show view" do
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    context 'guest' do
      it 'redirect sign in' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'just user' do
      before { sign_in(user) }
      it 'redirect sign in' do
        get :new
        expect(response).to redirect_to root_path
      end
    end

    context 'admin' do
      before { sign_in(admin) }
      it 'render new view' do
        get :new
        expect(response).to render_template(:new)
      end
    end
  end

  describe "POST #create" do
    context 'guest' do
      it 'tries to create post' do
        expect do
          post :create, params: { post: attributes_for(:post) }
        end.to_not change(Post, :count)
      end
    end

    context 'just user' do
      before { sign_in(user) }

      it 'not saves a new post' do
        expect do
          post :create, params: { category: attributes_for(:category) }
        end.to_not change(Category, :count)
      end
    end

    context 'admin' do
      before { sign_in(admin) }

      context 'valid post' do
        it 'saves a new post' do
          expect do
            post :create, params: { category: attributes_for(:category) }
          end.to change(Category, :count).by(1)
        end

        it 'redirect to show view' do
          post :create, params: { category: attributes_for(:category) }
          expect(response).to redirect_to categories_path
        end
      end

      context 'not valid post' do
        it 'not saves not valid post' do
          expect do
            post :create, params: { category: attributes_for(:category, :invalid_category) }
          end.to_not change(Category, :count)
        end

        it 're render to new view' do
          post :create, params: { category: attributes_for(:category, :invalid_category) }
          expect(response).to render_template(:new)
        end
      end

    end
  end

  describe "GET #edit" do
    let!(:category) { create(:category) }

    context 'guest' do
      it 'redirect to sign_in' do
        get :edit, params: { id: category }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'just user' do
      before { sign_in(user) }
      context 'guest' do
        it 'redirect to sign_in' do
          get :edit, params: { id: category }
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'admin' do
      before { sign_in(admin) }
      context 'guest' do
        it 'redirect to sign_in' do
          get :edit, params: { id: category }
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe "PATCH #update" do
    let!(:category) { create(:category) }

    before { get :edit, params: { id: category } }

    context 'guest' do
      it 'tries to change category' do
        patch :update, params: { id: category, category: { name: 'newName' } }
        category.reload

        expect(category.name).to_not eq 'newName'
      end
    end

    context 'author' do
      before { sign_in(user) }
      it 'tries to change category' do
        patch :update, params: { id: category, category: { name: 'newName' } }
        category.reload

        expect(category.name).to_not eq 'newName'
      end
    end

    context 'admin' do
      before { sign_in(admin) }

      it 'tries to change category' do
        patch :update, params: { id: category, category: { name: 'newName' } }
        category.reload

        expect(category.name).to eq 'newName'
      end

      it 'redirects to updated attributes' do
        patch :update, params: { id: category, category: attributes_for(:category) }
        expect(response).to redirect_to categories_path
      end

      context 'not valid attr' do
        before { patch :update, params: { id: category, category: attributes_for(:category, :invalid_category) } }

        it 'does not change category' do
          category.reload
          expect(category.name).to eq 'MyCategory'
        end

        it 're render edit view' do
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:category) { create(:category) }

    context 'guest' do
      it 'deletes category' do
        expect do
          delete :destroy, params: { id: category }
        end.to_not change(Category, :count)
      end
    end

    context 'just user' do
      before { sign_in(user) }

      it 'deletes category' do
        expect do
          delete :destroy, params: { id: category }
        end.to_not change(Category, :count)
      end
    end

    context 'admin' do
      before { sign_in(admin) }

      it 'deletes category' do
        expect do
          delete :destroy, params: { id: category }
        end.to change(Category, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: category }
        expect(response).to redirect_to categories_path
      end
    end
  end
end
