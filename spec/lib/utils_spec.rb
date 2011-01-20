#encoding: utf-8
require 'spec_helper'

describe Utils do

  describe :parse_size do

    it "should return size in bits" do
      Utils.parse_size("1 MB").should == 1.megabyte
    end

    it "should return correct size" do
      [
          { :string => "1 MB", :size => 1.megabyte },
          { :string => "10 MB", :size => 10.megabytes },
          { :string => "0 MB", :size => 0 },
          { :string => "1.3 GB", :size => 1.3.gigabytes },
          { :string => "1 GB", :size => 1.gigabyte },
          { :string => "2 GB", :size => 2.gigabytes },
          { :string => "1.79 GB", :size => 1.79.gigabytes }
      ].each do |size|
        Utils.parse_size(size[:string]).should == size[:size]
      end
    end

    it "should return 0 if nil passed" do
      Utils.parse_size(nil).should == 0
    end

    it "should return 0 if malformed string passed" do
      Utils.parse_size("  asd 212").should == 0
    end

  end

end