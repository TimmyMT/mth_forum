require 'rails_helper'

feature 'Comment Create action' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:category) { create(:category) }
  given!(:post) { create(:post, category: category, user: user) }

  scenario 'guest tries to add comment' do
    visit post_path(post)
    expect(page).to have_content post.title
    expect(page).to_not have_content "Add your comment"
    expect(page).to_not have_css ".form-control"
    expect(page).to_not have_content "Create Comment"
  end

  scenario 'another user tries to add comment', js: true do
    sign_in(another_user)
    visit post_path(post)

    expect(page).to have_content post.title
    expect(page).to have_content "Add your comment"
    expect(page).to have_css ".form-control"
    expect(page).to have_button "Create Comment"

    fill_in "Add your comment", with: "FirstComment"
    click_on "Create Comment"
    expect(page).to have_content "FirstComment"
  end


  scenario 'author tries to add comment', js: true do
    sign_in(user)
    visit post_path(post)

    expect(page).to have_content post.title
    expect(page).to have_content "Add your comment"
    expect(page).to have_css ".form-control"
    expect(page).to have_button "Create Comment"

    fill_in "Add your comment", with: "SecondComment"
    click_on "Create Comment"
    expect(page).to have_content "SecondComment"
  end
end
