require 'rails_helper'

feature 'Post Edit action' do
  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given(:admin) { create(:user, admin: true) }
  given!(:category) { create(:category) }
  given!(:post) { create(:post, category: category, user: user) }
  given!(:post_image) { create(:post_image, post_imageble: post) }

  scenario 'admin tries to edit post', js: true do
    sign_in(admin)
    visit post_path(post)

    expect(page).to have_content post.title
    expect(page).to have_content post.body

    within ".post_image_#{post_image.id}" do
      expect(page).to have_css("img[src*='cat.jpg']")
      expect(page).to_not have_link 'delete image'
    end

    expect(page).to have_link "Edit"

    click_on "Edit"
    expect(page).to have_content "Edit post #{post.title}"

    within ".post_image_#{post_image.id}" do
      expect(page).to have_css("img[src*='cat.jpg']")
      expect(page).to have_link 'delete image'
      click_on 'delete image'
    end
    expect(page).to_not have_css ".post_image_#{post_image.id}"

    fill_in "Title", with: "EditedTitle"
    fill_in "Body", with: "EditedBody"
    click_on "Update Post"

    expect(page).to have_content "EditedTitle"
    expect(page).to have_content "EditedBody"
  end

  scenario 'user tries to edit post', js: true do
    sign_in(user)
    visit post_path(post)

    expect(page).to have_content post.title
    expect(page).to have_content post.body

    within ".post_image_#{post_image.id}" do
      expect(page).to have_css("img[src*='cat.jpg']")
      expect(page).to_not have_link 'delete image'
    end

    expect(page).to have_link "Edit"

    click_on "Edit"
    expect(page).to have_content "Edit post #{post.title}"

    within ".post_image_#{post_image.id}" do
      expect(page).to have_css("img[src*='cat.jpg']")
      expect(page).to have_link 'delete image'
      click_on 'delete image'
    end
    expect(page).to_not have_css ".post_image_#{post_image.id}"

    fill_in "Title", with: "EditedTitle"
    fill_in "Body", with: "EditedBody"
    click_on "Update Post"

    expect(page).to have_content "EditedTitle"
    expect(page).to have_content "EditedBody"
  end

  scenario 'wrong user tries to edit post' do
    sign_in(wrong_user)
    visit post_path(post)

    expect(page).to have_content post.title
    expect(page).to have_content post.body

    within ".post_image_#{post_image.id}" do
      expect(page).to have_css("img[src*='cat.jpg']")
      expect(page).to_not have_link 'delete image'
    end

    expect(page).to_not have_link "Edit"

    visit edit_post_path(post)
    expect(page).to_not have_content "Edit post #{post.title}"
    expect(page).to have_content "You are not authorized to access this page."
  end

  scenario 'guest tries to edit post' do
    visit post_path(post)
    expect(page).to have_content post.title
    expect(page).to have_content post.body

    within ".post_image_#{post_image.id}" do
      expect(page).to have_css("img[src*='cat.jpg']")
      expect(page).to_not have_link 'delete image'
    end

    expect(page).to_not have_link "Edit"

    visit edit_post_path(post)
    expect(page).to_not have_content "Edit post #{post.title}"
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
