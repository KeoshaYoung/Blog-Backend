require "rails_helper"

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    it "should return an array of posts" do
      user = User.create!(name: "Test", email: "test@test.com", password: "password")

      Post.create!(user_id: user.id, title: "Test Title1", body: "Test Body1", image: "Test Img1")

      Post.create!(user_id: user.id, title: "Test Title2", body: "Test Body2", image: "Test Img2")

      get "/posts.json"
      posts = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(posts.length).to eq(2)
    end
  end
end
