require 'rails_helper'

feature 'user can create category' do
  given(:user) { create(:user) }
  given(:admin) { create(:user, admin: true) }

  scenario 'default user tries to create category' do
    sign_in(user)
    visit root_path

    expect(page).to_not have_link 'Add new category'
  end

  scenario 'guest tries to create category' do
    visit root_path

    expect(page).to_not have_link 'Add new category'
  end

  describe 'admin actions' do
    before do
      sign_in(admin)
      visit root_path
    end

    scenario 'admin tries to create category' do
      expect(page).to have_link 'Add new category'
      click_on 'Add new category'
      expect(page).to have_css "#category_name"
      # save_and_open_page
      expect(page).to have_content "Create a new category"

      fill_in 'Name', with: "Test category"
      click_on 'Create Category'

      expect(page).to have_css ".category_#{Category.find_by(name: 'Test category').id}"
      expect(page).to have_content 'Test category'
    end
  end
end
