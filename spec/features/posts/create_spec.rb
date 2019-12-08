require 'rails_helper'

feature 'Post Create action' do
  given(:user) { create(:user) }
  given(:admin) { create(:user, admin: true) }
  given!(:category) { create(:category) }

  scenario 'admin tries to create post' do
    sign_in(admin)

    visit root_path
    expect(page).to have_link category.name
    click_on category.name

    expect(page).to have_content "Posts of Category #{category.name}"
    expect(page).to have_link "New post"

    click_on "New post"
    expect(page).to have_content "Create a new post"
    fill_in "Title", with: 'TestPostTitle'
    fill_in "Body", with: 'TestPostBody'
    click_on 'Create Post'

    expect(page).to have_content Post.last.title
    expect(page).to have_content Post.last.body
  end

  scenario 'user tries to create post' do
    sign_in(user)

    visit root_path
    expect(page).to have_link category.name
    click_on category.name

    expect(page).to have_content "Posts of Category #{category.name}"
    expect(page).to have_link "New post"

    click_on "New post"
    expect(page).to have_content "Create a new post"
    fill_in "Title", with: 'TestPostTitle'
    fill_in "Body", with: 'TestPostBody'
    click_on 'Create Post'

    expect(page).to have_content Post.last.title
    expect(page).to have_content Post.last.body
  end

  scenario 'guest tries to create post' do
    visit root_path
    expect(page).to have_link category.name
    click_on category.name
    expect(page).to have_content "Posts of Category #{category.name}"
    expect(page).to_not have_link "New post"
  end
end
