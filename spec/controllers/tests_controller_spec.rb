require 'spec_helper'

RSpec.describe TestsController, type: :controller do
  let(:user) { create(:user) }

  before do
    user = FactoryBot.create(:user)
    sign_in user
  end

  let(:valid_attributes) do
    {
      title: "Valid title",
      body: "This body is long enough",
      question: "Yes"
    }
  end

  let(:invalid_attributes) do
    {
      title: nil,
      body: "short",
      question: "No"
    }
  end

  describe "GET #index" do
    it "assigns a new Test as @test and all tests as @tests" do
      test = Test.create!(valid_attributes)
      get :index
      expect(assigns(:test)).to be_a_new(Test)
      expect(assigns(:tests)).to eq([test])
      expect(response).to render_template(:index)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Test and redirects" do
        expect do
          post :create, params: { test: valid_attributes }
        end.to change(Test, :count).by(1)
        expect(response).to redirect_to(tests_path)
      end
    end

    context "with invalid params" do
      it "does not create a Test and renders index" do
        expect do
          post :create, params: { test: invalid_attributes }
        end.not_to change(Test, :count)
        expect(assigns(:test)).to be_a_new(Test)
        expect(assigns(:tests)).to match_array(Test.all)
        expect(response).to render_template(:index)
      end
    end
  end

  describe "PATCH #update" do
    let!(:test_record) { Test.create!(valid_attributes) }

    context "with valid params" do
      it "updates the requested test and redirects" do
        patch :update, params: { id: test_record.id, test: { title: "Updated title" } }
        expect(test_record.reload.title).to eq("Updated title")
        expect(response).to redirect_to(tests_path)
      end
    end

    context "with invalid params" do
      it "does not update and renders index with status 422" do
        patch :update, params: { id: test_record.id, test: { title: nil } }
        expect(test_record.reload.title).to eq(valid_attributes[:title])
        expect(assigns(:test)).to be_a_new(Test)
        expect(assigns(:tests)).to match_array(Test.all)
        expect(assigns(:edit_id)).to eq(test_record.id)
        expect(response.status).to eq(422)
        expect(response).to render_template(:index)
      end
    end

    context "with blank update fields" do
      it "still keeps original values" do
        patch :update, params: { id: test_record.id, test: { title: "", body: "", question: "" } }
        expect(test_record.reload.title).to eq(valid_attributes[:title])
        expect(assigns(:test)).to be_a_new(Test)
        expect(assigns(:edit_id)).to eq(test_record.id)
        expect(response.status).to eq(422)
      end
    end

    context "with invalid params" do
      it "does not update and renders index with status 422" do
        patch :update, params: { id: test_record.id, test: { title: nil } }
        expect(test_record.reload.title).to eq(valid_attributes[:title])
        expect(assigns(:test)).to be_a_new(Test)
        expect(assigns(:tests)).to eq(Test.all)
        expect(assigns(:edit_id)).to eq(test_record.id)
        expect(response.status).to eq(422)
        expect(response).to render_template(:index)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:test_record) { Test.create!(valid_attributes) }

    it "destroys the requested test and redirects" do
      expect do
        delete :destroy, params: { id: test_record.id }
      end.to change(Test, :count).by(-1)
      expect(response).to redirect_to(tests_path)
    end

    it "redirects to tests_path if test does not exist" do
      delete :destroy, params: { id: 9999 }
      expect(response).to redirect_to(tests_path)
      expect(flash[:alert]).to be_present if defined?(flash)
    end
  end
end
