require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

RSpec.describe Test, type: :model do
  describe "validations" do
    let(:valid_attributes) do
      {
        title: "Title",
        body: "This is a long enough body",
        question: "Yes"
      }
    end

    it "is valid with valid attributes" do
      test = Test.new(valid_attributes)
      expect(test).to be_valid
    end

    it "is invalid without title" do
      test = Test.new(valid_attributes.except(:title))
      expect(test).not_to be_valid
      expect(test.errors[:title]).to be_present
    end

    it "is invalid with short body" do
      test = Test.new(valid_attributes.merge(body: "short"))
      expect(test).not_to be_valid
      expect(test.errors[:body]).to be_present
    end

    it "is invalid with empty body" do
      test = Test.new(valid_attributes.merge(body: ""))
      expect(test).not_to be_valid
      expect(test.errors[:body]).to be_present
    end

    it "is invalid with nil body" do
      test = Test.new(valid_attributes.merge(body: nil))
      expect(test).not_to be_valid
    end

    it "is invalid with invalid question" do
      test = Test.new(valid_attributes.merge(question: "No"))
      expect(test).not_to be_valid
      expect(test.errors[:question]).to be_present
    end

    it "is invalid with empty question" do
      test = Test.new(valid_attributes.merge(question: ""))
      expect(test).not_to be_valid
    end

    it "is invalid with nil question" do
      test = Test.new(valid_attributes.merge(question: nil))
      expect(test).not_to be_valid
    end

    it "is invalid when all fields are empty" do
      test = Test.new
      expect(test).not_to be_valid
      expect(test.errors[:title]).to be_present
      expect(test.errors[:body]).to be_present
      expect(test.errors[:question]).to be_present
    end

    it "accepts allowed question values" do
      ["Yes", "Yes, of course"].each do |value|
        test = Test.new(valid_attributes.merge(question: value))
        expect(test).to be_valid
      end
    end
  end
end
