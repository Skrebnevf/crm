require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
# require 'rails_helper'

RSpec.describe RequestForQuatation, type: :model do
  it "should have author_id column" do
    expect(RequestForQuatation.column_names).to include("author_id")
  end

  it "should not have legacy assignment columns" do
    expect(RequestForQuatation.column_names).not_to include("assign_to_procurement")
    expect(RequestForQuatation.column_names).not_to include("assign_to_sales")
  end
end
