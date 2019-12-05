require 'rails_helper'

feature 'Admin can delete category' do
  given(:admin) { create(:user, admin: true) }
  given(:user) { create(:user) }
  given!(:category) { create(:category) }

  scenario 'admin tries to delete category' do
    sign_in(admin)
    visit root_path

    expect(page).to have_css ".category_#{category.id}"

    within ".category_#{category.id}" do
      expect(page).to have_content 'MyCategory'
      expect(page).to have_link "Delete"
      click_on 'Delete'
    end

    expect(page).to have_content 'Categories'
    expect(page).to_not have_content 'MyCategory'
  end

  scenario 'user tries to delete category' do
    sign_in(user)
    visit root_path

    expect(page).to have_css ".category_#{category.id}"

    within ".category_#{category.id}" do
      expect(page).to have_content 'MyCategory'
      expect(page).to_not have_link "Delete"
    end
  end

  scenario 'guest tries to delete category' do
    visit root_path

    expect(page).to have_css ".category_#{category.id}"

    within ".category_#{category.id}" do
      expect(page).to have_content 'MyCategory'
      expect(page).to_not have_link "Delete"
    end
  end
end
