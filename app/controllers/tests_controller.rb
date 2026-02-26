# frozen_string_literal: true

class TestsController < ApplicationController
  before_action { @current_tab = :tests }
  def index
    @test = Test.new
    @tests = Test.order(created_at: :desc)
  end

  def create
    @test = Test.new(test_params)
    if @test.save
      redirect_to tests_path
    else
      @tests = Test.order(created_at: :desc)
      render :index
    end
  end

  def update
    @edited_test = Test.find(params[:id])

    if @edited_test.update(test_params)
      redirect_to tests_path
    else
      @test = Test.new
      @tests = Test.all
      @edit_id = @edited_test.id
      render :index, status: :unprocessable_content
    end
  end

  def destroy
    @test = Test.find_by(id: params[:id])
    if @test
      @test.destroy
      redirect_to tests_path, notice: "Test deleted successfully."
    else
      redirect_to tests_path, alert: "Test not found."
    end
  end

  private

  def test_params
    params.require(:test).permit(:title, :body, :question)
  end
end
