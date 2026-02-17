# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

RSpec.describe "SignedJobs", type: :request do
  describe "GET /index" do
    it "returns redirect to login" do
      get signed_jobs_path
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET /show" do
    let(:signed_job) { create(:signed_job) }

    it "returns redirect to login" do
      get signed_job_path(signed_job)
      expect(response).to have_http_status(:redirect)
    end
  end
end
