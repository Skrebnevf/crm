# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

RSpec.describe "Tests", type: :request do
  describe "GET /index" do
    it "returns redirect to login" do
      get tests_path
      expect(response).to have_http_status(:redirect)
    end
  end
end
