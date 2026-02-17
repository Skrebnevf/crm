require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
# require 'rails_helper'

RSpec.describe RequestForQuatation, type: :model do
  it "should have assign_to_procurement column" do
    expect(RequestForQuatation.column_names).to include("assign_to_procurement")
  end

  it "should have assign_to_sales column" do
    expect(RequestForQuatation.column_names).to include("assign_to_sales")
  end
end
