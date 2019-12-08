require 'rails_helper'

feature 'Comment Destroy action' do
  given(:admin) { create(:user, admin: true) }
  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given!(:category) { create(:category) }
  given!(:post) { create(:post, category: category, user: user) }
  given!(:comment) { create(:comment, post: post, user: user) }

  scenario 'guest tries to delete comment', js: true do
    visit post_path(post)

    within ".comment_#{comment.id}" do
      expect(page).to have_content comment.body
      expect(page).to_not have_link "Delete comment"
    end
  end

  scenario 'wrong user tries to delete comment', js: true do
    sign_in(wrong_user)
    visit post_path(post)

    within ".comment_#{comment.id}" do
      expect(page).to have_content comment.body
      expect(page).to_not have_link "Delete comment"
    end
  end

  scenario 'user tries to delete comment', js: true do
    sign_in(user)
    visit post_path(post)

    within ".comment_#{comment.id}" do
      expect(page).to have_content comment.body
      expect(page).to have_link "Delete comment"
      click_on "Delete comment"
    end

    expect(page).to_not have_content comment.body
  end

  scenario 'admin tries to delete comment', js: true do
    sign_in(admin)
    visit post_path(post)

    within ".comment_#{comment.id}" do
      expect(page).to have_content comment.body
      expect(page).to have_link "Delete comment"
      click_on "Delete comment"
    end

    expect(page).to_not have_content comment.body
  end
end
