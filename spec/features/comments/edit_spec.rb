require 'rails_helper'

feature 'Comment Edit action' do
  given(:admin) { create(:user, admin: true) }
  given(:user) { create(:user) }
  given(:wrong_user) { create(:user) }
  given!(:category) { create(:category) }
  given!(:post) { create(:post, category: category, user: user) }
  given!(:comment) { create(:comment, post: post, user: user) }

  scenario 'guest tries to edit comment' do
    visit post_path(post)

    within ".comment_#{comment.id}" do
      expect(page).to have_content comment.body
      expect(page).to_not have_link "Change your comment"
    end

    visit edit_comment_path(comment)
    expect(page).to have_content "You need to sign in or sign up before continuing."
  end

  scenario 'wrong user tries to edit comment' do
    sign_in(wrong_user)
    visit post_path(post)

    within ".comment_#{comment.id}" do
      expect(page).to have_content comment.body
      expect(page).to_not have_link "Change your comment"
    end

    visit edit_comment_path(comment)
    expect(page).to have_content "You are not authorized to access this page."
  end

  scenario 'user tries to edit comment' do
    sign_in(user)
    visit post_path(post)

    within ".comment_#{comment.id}" do
      expect(page).to have_content comment.body
      expect(page).to have_link "Change your comment"
      click_on "Change your comment"
    end

    expect(page).to have_button "Update Comment"
    fill_in "Change your comment", with: "EditedComment"
    click_on "Update Comment"

    within ".comment_#{comment.id}" do
      expect(page).to have_content "EditedComment"
    end
  end

  scenario 'admin tries to edit comment' do
    sign_in(admin)
    visit post_path(post)

    within ".comment_#{comment.id}" do
      expect(page).to have_content comment.body
      expect(page).to have_link "Change your comment"
      click_on "Change your comment"
    end

    expect(page).to have_button "Update Comment"
    fill_in "Change your comment", with: "AdminEditedComment"
    click_on "Update Comment"

    within ".comment_#{comment.id}" do
      expect(page).to have_content "AdminEditedComment"
    end
  end
end
