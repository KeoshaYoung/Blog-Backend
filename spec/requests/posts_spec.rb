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

  describe "GET /posts/:id" do
    it "should return a hash with all of the appropriate attributes" do
      user = User.create!(name: "Test", email: "test@test.com", password: "password")

      Post.create!(user_id: user.id, title: "Test Title1", body: "Test Body1", image: "Test Img1")

      post_id = Post.first.id
      get "/posts/#{post_id}.json"
      post = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(post["title"]).to eq("Test Title1")
      expect(post["body"]).to eq("Test Body1")
      expect(post["image"]).to eq("Test Img1")
    end
  end

  describe "POST /posts" do
    it "should create a post" do
      user = User.create!(name: "Test", email: "test@test.com", password: "password")
      jwt = JWT.encode(
        { user_id: user.id },
        Rails.application.credentials.fetch(:secret_key_base),
        "HS256"
      )
      post "/posts.json", params: {
                            title: "Test Title3",
                            body: "Test Body3",
                            image: "Test Img3",
                          },
                          headers: { "Authorization" => "Bearer #{jwt}" }

      post = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(post["title"]).to eq("Test Title3")
      expect(post["body"]).to eq("Test Body3")
      expect(post["image"]).to eq("Test Img3")
    end
    it "should return error code for invalid data" do
      user = User.create!(name: "Test", email: "test@test.com", password: "password")
      jwt = JWT.encode(
        { user_id: user.id },
        Rails.application.credentials.fetch(:secret_key_base),
        "HS256"
      )
      post "/posts.json", params: {
                            title: "",
                            body: "Test Body3",
                            image: "Test Img3",
                          },
                          headers: { "Authorization" => "Bearer #{jwt}" }
      post = JSON.parse(response.body)
      expect(response).to have_http_status(400)
    end
  end

  # describe "PATCH /posts/:id" do
  #   it "should update a post" do
  #     user = User.create!(name: "Test", email: "test@test.com", password: "password")
  #     jwt = JWT.encode(
  #       { user_id: user.id },
  #       Rails.application.credentials.fetch(:secret_key_base),
  #       "HS256"
  #     )
  #     post "/posts/:id.json", params: {
  #                               title: "Test Title3",
  #                               body: "Test Body3",
  #                               image: "Test Img3",
  #                             },
  #                             headers: { "Authorization" => "Bearer #{jwt}" }

  #     post = JSON.parse(response.body)
  #     expect(response).to have_http_status(200)
  #   end
  # end
end
