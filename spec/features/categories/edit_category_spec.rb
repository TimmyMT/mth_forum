require 'rails_helper'

feature 'Admin can edit category' do
  given(:admin) { create(:user, admin: true) }
  given(:user) { create(:user) }
  given!(:category) { create(:category) }

  scenario 'admin tries to edit category' do
    sign_in(admin)
    visit root_path

    expect(page).to have_css ".category_#{category.id}"

    within ".category_#{category.id}" do
      expect(page).to have_content 'MyCategory'
      expect(page).to have_link "Edit"
      click_on 'Edit'
    end

    expect(page).to have_content "Edit category #{category.name}"
    fill_in "Name", with: 'EditedCategory'
    click_on 'Update Category'

    within ".category_#{category.id}" do
      expect(page).to have_content 'EditedCategory'
      expect(page).to_not have_content 'MyCategory'
    end
  end

  scenario 'user tries to edit category' do
    sign_in(user)
    visit root_path

    expect(page).to have_css ".category_#{category.id}"

    within ".category_#{category.id}" do
      expect(page).to have_content 'MyCategory'
      expect(page).to_not have_link "Edit"
    end
  end

  scenario 'guest tries to edit category' do
    visit root_path

    expect(page).to have_css ".category_#{category.id}"

    within ".category_#{category.id}" do
      expect(page).to have_content 'MyCategory'
      expect(page).to_not have_link "Edit"
    end
  end
end
