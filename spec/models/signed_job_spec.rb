require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

RSpec.describe SignedJob, type: :model do
  describe "Creation and Identifiers" do
    it "generates a UUID before creation" do
      sj = create(:signed_job, uuid: nil)
      expect(sj.uuid).to be_present
    end

    it "generates a Document ID based on RFQ data" do
      rfq = create(:request_for_quatation, accepted: true, income_payment_to: "LV", outcome_payment_from: "TR")
      sj = rfq.signed_jobs.first
      expect(sj.doc_id).to start_with("LVTR")
    end
  end

  describe "State and Lifecycle" do
    it "automatically sets status to completed when end_of_time_project is set" do
      sj = create(:signed_job, status: "in_progress", end_of_time_project: nil)
      sj.update(end_of_time_project: Date.today)
      expect(sj.status).to eq("completed")
      expect(sj.completed?).to be_truthy
    end
  end

  describe "Visibility" do
    it "returns all records in 'my' scope for any user" do
      user1 = create(:user)
      user2 = create(:user)
      sj1 = create(:signed_job, user: user1)
      sj2 = create(:signed_job, user: user2)

      expect(SignedJob.my(user1)).to include(sj1, sj2)
      expect(SignedJob.my(user2)).to include(sj1, sj2)
    end
  end
end
