require 'spec_helper'

describe TorrentsController do

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'download'" do
    it "should be successful" do
      get 'download'
      response.should be_success
    end
  end

  describe "GET 'reject'" do
    it "should be successful" do
      get 'reject'
      response.should be_success
    end
  end

end
