require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
# require 'rails_helper'

RSpec.describe RequestForQuatation, type: :model do
  describe "Creation" do
    it "generates a UUID before creation" do
      rfq = create(:request_for_quatation, uuid: nil)
      expect(rfq.uuid).to be_present
      expect(rfq.uuid.length).to eq(36)
    end

    it "automatically creates a SignedJob when RFQ is created as accepted" do
      rfq = create(:request_for_quatation, accepted: true)
      expect(rfq.signed_jobs.count).to eq(1)
      expect(rfq.signed_jobs.first.user_id).to eq(rfq.user_id)
    end
  end

  describe "State transitions and Locking" do
    it "automatically creates a SignedJob when RFQ status changes to accepted" do
      rfq = create(:request_for_quatation, accepted: false)
      expect(rfq.signed_jobs.any?).to be_falsey

      rfq.update(accepted: true)
      expect(rfq.reload.signed_jobs.count).to eq(1)
    end

    it "correctly reports locked state when accepted or denied" do
      rfq = build(:request_for_quatation)
      expect(rfq.locked?).to be_falsey

      rfq.accepted = true
      expect(rfq.locked?).to be_truthy

      rfq.accepted = false
      rfq.denied = true
      expect(rfq.locked?).to be_truthy
    end
  end
end
