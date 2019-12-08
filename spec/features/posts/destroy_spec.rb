require 'rails_helper'

feature 'Post Delete action' do
  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given(:admin) { create(:user, admin: true) }
  given!(:category) { create(:category) }
  given!(:post) { create(:post, category: category, user: user) }

  scenario 'admin tries to delete post' do
    sign_in(admin)
    visit post_path(post)

    expect(page).to have_content post.title
    expect(page).to have_content post.body
    expect(page).to have_link "Delete"
    click_on "Delete"

    expect(page).to have_content "Posts of Category #{category.name}"
    expect(page).to_not have_link post.title
  end

  scenario 'user tries to delete post' do
    sign_in(user)
    visit post_path(post)

    expect(page).to have_content post.title
    expect(page).to have_content post.body
    expect(page).to have_link "Delete"
    click_on "Delete"

    expect(page).to have_content "Posts of Category #{category.name}"
    expect(page).to_not have_link post.title
  end

  scenario 'wrong user tries to delete post' do
    sign_in(wrong_user)
    visit post_path(post)

    expect(page).to have_content post.title
    expect(page).to have_content post.body
    expect(page).to_not have_link "Delete"
  end

  scenario 'guest tries to delete post' do
    visit post_path(post)

    expect(page).to have_content post.title
    expect(page).to have_content post.body
    expect(page).to_not have_link "Delete"
  end
end
