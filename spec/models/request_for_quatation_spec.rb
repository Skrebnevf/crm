require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
# require 'rails_helper'

RSpec.describe RequestForQuatation, type: :model do
  describe "Creation and UUID" do
    it "generates a UUID before creation" do
      rfq = create(:request_for_quatation, uuid: nil)
      expect(rfq.uuid).to be_present
      expect(rfq.uuid.length).to eq(36)
    end
  end

  describe "SignedJob Auto-creation" do
    it "automatically creates a SignedJob when RFQ is created as accepted" do
      rfq = create(:request_for_quatation, accepted: true)
      expect(rfq.signed_jobs.count).to eq(1)
      expect(rfq.signed_jobs.first.user_id).to eq(rfq.user_id)
    end

    it "automatically creates a SignedJob when RFQ status changes to accepted" do
      rfq = create(:request_for_quatation, accepted: false)
      expect(rfq.signed_jobs.any?).to be_falsey

      rfq.update(accepted: true)
      expect(rfq.reload.signed_jobs.count).to eq(1)
    end
  end

  describe "State and Visibility" do
    it "correctly reports locked state when accepted or denied" do
      rfq = build(:request_for_quatation)
      expect(rfq.locked?).to be_falsey

      rfq.accepted = true
      expect(rfq.locked?).to be_truthy

      rfq.accepted = false
      rfq.denied = true
      expect(rfq.locked?).to be_truthy
    end

    it "returns all records in 'my' scope for any user" do
      user1 = create(:user)
      user2 = create(:user)
      rfq1 = create(:request_for_quatation, user: user1)
      rfq2 = create(:request_for_quatation, user: user2)

      expect(RequestForQuatation.my(user1)).to include(rfq1, rfq2)
      expect(RequestForQuatation.my(user2)).to include(rfq1, rfq2)
    end
  end
end
