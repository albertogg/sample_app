# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do
  before(:each) do
  	@attr = { 
              :name => "Example name", 
              :email => "example@mail.com", 
              :password => "foobar",
              :password_confirmation => "foobar"
            }	
  end

  it "should create a new instance given the attibutes" do
  	User.create!(@attr)
  end

  it "should require a name" do
  	no_name_user = User.new(@attr.merge(:name => ""))
  	no_name_user.should_not be_valid
  end

  it "should require an email" do
  	no_email_user = User.new(@attr.merge(:email => ""))
  	no_email_user.should_not be_valid
  end

  it "should reject names that are too long" do
  	long_name = "a" * 51
  	long_name_user = User.new(@attr.merge(:name => long_name))
  	long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
  	addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
  	addresses.each do |address|
  		valid_email_address = User.new(@attr.merge(:email => address))
  		valid_email_address.should be_valid
  	end
  end

  it "should reject invalid email address" do
  	addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
  	addresses.each do |address|
  		invalid_email_address = User.new(@attr.merge(:email => address))
  		invalid_email_address.should_not be_valid
  	end
  end

  it "should reject duplicate email addresses" do
  	User.create!(@attr)
  	user_with_duplicate_email = User.new(@attr)
  	user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
  	upcase_email = @attr[:email].upcase
  	User.create!(@attr.merge(:email => upcase_email))
  	user_with_duplicate_email = User.new(@attr)
  	user_with_duplicate_email.should_not be_valid
  end

  describe "password validations" do

    it "should require password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
      should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
      should_not be_valid
    end

    it "should reject short password" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long password" do
      long = "l" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end

  end

  describe "password encryption" do

    before (:each) do
      @user = User.create!(@attr)
    end

    it "should encrypt password" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

      describe "has_password? method" do

        it "should be true if password match" do
          @user.has_password?(@attr[:password]).should be_true
        end

        it "should be false if password don't match" do
          @user.has_password?("invalid").should be_false
        end
        
      end
  end
end
