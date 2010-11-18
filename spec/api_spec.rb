require 'spec_helper'

require 'rest_client'
require 'nokogiri'
require 'json'

SITE = 'http://localhost:3000'

describe 'Rollcall RESTful API' do
  before do
    @rand = rand(99999)
    @client = RestClient::Resource.new(SITE)
  end
  
  describe 'XML' do
    it "should create a User and return the new User's data and metadata" do
      user = create_test_user
    
      user.xpath('//username').text.should == @username
      user.xpath('//password').text.should == @password
      user.xpath('//display-name').text.should == "Test User #{@rand}"
      user.xpath('//kind').text.should == "Student"
      user.xpath('//metadata/foo').text.should == "bar"
      user.xpath('//metadata/test').text.should == "123"
    end
  
  
    it 'should log in with valid credentials and return the Session data with a token' do
      user = create_test_user
    
      xml = @client['login.xml'].post(
        :session => {
          :username => @username,
          :password => @password,
        }
      )
    
      session = Nokogiri::XML(xml)
    
      session.xpath('//user-id').text.should == @user.xpath('//id').text
    
      token = session.xpath('//token').text
    
      xml = @client["login/validate_token/#{@username}/#{token}.xml"].get
    
      session_validated = Nokogiri::XML(xml)
    
      session_validated.xpath('//user-id').text.should == session.xpath('//user-id').text
    end
  
  
    it 'should reject logins with invalid credentials' do
      user = create_test_user
    
      lambda {
        @client['login.xml'].post(
          :session => {
            :username => "INVALID USERNAME",
            :password => @password,
          }
        )
      }.should raise_exception(RestClient::Request::Unauthorized)
    
      lambda {
        @client['login.xml'].post(
          :session => {
            :username => @username,
            :password => "INVALID PASSWORD",
          }
        )
      }.should raise_exception(RestClient::Request::Unauthorized)
    
      # test blank username/password
      lambda {
        @client['login.xml'].post(
          :session => {
            :username => ""
          }
        )
      }.should raise_exception(RestClient::Request::Unauthorized)
    end
  
    
    it "should create an Curnit, Run, and Group and return the new Curnit's, Run's, and Group's data and metadata" do    
      curnit = create_test_curnit
    
      curnit.xpath('//name').text.should_not be_blank
      curnit.xpath('//metadata/creator').text.should_not be_blank
    
      run = create_test_run(curnit.xpath('//id').text)
    
      run.xpath('//name').text.should_not be_blank
      run.xpath('//metadata/start-time').text.should_not be_blank
    
      group = create_test_group(curnit.xpath('//id').text)
    
      group.xpath('//name').text.should_not be_blank
      group.xpath('//metadata/nested').text.should_not be_blank
    end
  
  
    it "should add and remove various members to/from a Group" do
      curnit = create_test_curnit
      run = create_test_run(curnit.xpath('//id').text)
    
      group1 = create_test_group(curnit.xpath('//id').text)
      group1_id = group1.xpath('//group/id').text
      group2 = create_test_group(curnit.xpath('//id').text)
      group2_id = group2.xpath('//group/id').text
    
      user1 = create_test_user
      user1_id = user1.xpath('//id').text
    
      user2 = create_test_user
      user2_id = user2.xpath('//id').text
    
      group1 = add_item_to_group(group1, user1)
      group1.xpath("//member/id[text()='#{user1_id}']").text.should == user1_id
      group1 = add_item_to_group(group1, user2)
      group1.xpath("//member/id[text()='#{user2_id}']").text.should == user2_id
    
      group2 = add_item_to_group(group2, user2)
      group2.xpath("//member/id[text()='#{user2_id}']").text.should == user2_id
      group2.xpath("//member/id[text()='#{user1_id}']").should be_empty # user1 wasn't added so shouldn't be there
    
      group1 = add_item_to_group(group1, group2)
      group1.xpath("//member/id[text()='#{group2_id}']").text.should == group2_id
    
      group1 = remove_item_from_group(group1, user1)
      group1.xpath("//member/id[text()='#{user1_id}']").should be_empty
    end
  end
  
  describe 'JSON' do
    it "should create a User and return the new User's data and metadata" do
      user = create_test_user('json')
    
      user['user']['username'].should == @username
      user['user']['password'].should == @password
      user['user']['display_name'].should == "Test User #{@rand}"
      user['user']['kind'].should == "Student"
      user['user']['metadata']['foo'].should == "bar"
      user['user']['metadata']['test'].should == "123"
    end
    
    it 'should log in with valid credentials and return the Session data with a token' do
      user = create_test_user('json')
    
      json = @client['login.json'].post(
        :session => {
          :username => @username,
          :password => @password,
        }
      )
    
      session = JSON.parse!(json)
    
      session['session']['user_id'].should == @user['user']['id']
    
      token = session['session']['token']
    
      json = @client["login/validate_token/#{@username}/#{token}.json"].get
    
      session_validated = JSON.parse!(json)
    
      session_validated['session']['user_id'].should == session['session']['user_id']
    end
    
    it "should create an Curnit, Run, and Group and return the new Curnit's, Run's, and Group's data and metadata" do    
      curnit = create_test_curnit('json')
    
      curnit['curnit']['name'].should_not be_blank
      curnit['curnit']['metadata']['creator'].should_not be_blank
    
      run = create_test_run(curnit['curnit']['id'], 'json')
    
      run['run']['name'].should_not be_blank
      run['run']['metadata']['start-time'].should_not be_blank
    
      group = create_test_group(curnit['curnit']['id'], 'json')
    
      group['group']['name'].should_not be_blank
      group['group']['metadata']['nested'].should_not be_blank
    end
    
    it "should add and remove various members to/from a Group" do
      curnit = create_test_curnit('json')
      run = create_test_run(curnit['curnit']['id'], 'json')
    
      group1 = create_test_group(curnit['curnit']['id'], 'json')
      group1_id = group1['group']['id']
      group2 = create_test_group(curnit['curnit']['id'], 'json')
      group2_id = group2['group']['id']
    
      user1 = create_test_user('json')
      user1_id = user1['user']['id']
    
      user2 = create_test_user('json')
      user2_id = user2['user']['id']
    
      group1 = add_item_to_group(group1, user1, 'json')
      group1['group']['members'].find{|u| u['user']['id'] == user1_id}['user']['id'].should == user1_id
      group1 = add_item_to_group(group1, user2, 'json')
      group1['group']['members'].find{|u| u['user']['id'] == user2_id}['user']['id'].should == user2_id
    
      group2 = add_item_to_group(group2, user2, 'json')
      group2['group']['members'].find{|u| u['user']['id'] == user2_id}['user']['id'].should == user2_id
      group2['group']['members'].find{|u| u['user']['id'] == user1_id}.nil?.should be_true # user1 wasn't added so shouldn't be there
    
      group1 = add_item_to_group(group1, group2, 'json')
      group1['group']['members'].find{|m| m['group'] && m['group']['id'] == group2_id}['group']['id'].should == group2_id
    
      group1 = remove_item_from_group(group1, user1, 'json')
      group1['group']['members'].find{|m| m['user'] && m['user']['id'] == user1_id}.nil?.should be_true
    end
  end
  
  
  def create_test_user(format = 'xml')
    @username = "test-user-#{@rand}"
    @password = "testtest#{@rand}"
    
    resp = @client['users.'+format].post(
      :user => {
        :username => @username,
        :password => @password,
        :display_name => "Test User #{@rand}",
        :kind => 'Student',
        :metadata => {'foo' => 'bar', 'test' => 123}
      }
    )
    
    @user = parse_response(resp, format)
    
    return @user
  end
  
  def create_test_group(run_id, format = 'xml')
    resp = @client['groups.'+format].post(
      :group => {
        :name => "Test Group #{@rand}",
        :run_id => run_id,
        :metadata => {'nested' => {:what => "happened?"}} # FIXME: doesn't work
      }
    )
    
    @group = parse_response(resp, format)
    
    return @group
  end
  
  def create_test_run(curnit_id, format = 'xml')
    resp = @client['runs.'+format].post(
      :run => {
        :name => "Test Run #{@rand}",
        :curnit_id => curnit_id,
        :metadata => {'start-time' => Time.now}
      }
    )
    
    @run = parse_response(resp, format)
    
    return @run
  end
  
  def create_test_curnit(format = 'xml')
    resp = @client['curnits.'+format].post(
      :curnit => {
        :name => "Test Curnit #{@rand}",
        :metadata => {'creator' => 'test'}
      }
    )
    
    @curnit = parse_response(resp, format)
    
    return @curnit
  end
  
  def add_item_to_group(group, item, format = 'xml')
    if format == 'xml'
      group_id = group.root.xpath('id').text
      item_id = item.root.xpath('id').text
      item_type = item.root.name.camelcase
    else
      group_id = group['group']['id']
      item_id = item[item.keys.first]['id']
      item_type = item.keys.first.classify
    end
    
    resp = @client["groups/#{group_id}/add_member."+format].put(
      :member => {
        :id => item_id,
        :type => item_type,
      }
    )
    
    parse_response(resp, format)
  end
  
  def remove_item_from_group(group, item, format = 'xml')
    if format == 'xml'
      group_id = group.root.xpath('id').text
      item_id = item.root.xpath('id').text
      item_type = item.root.name.camelcase
    else
      group_id = group['group']['id']
      item_id = item[item.keys.first]['id']
      item_type = item.keys.first.classify
    end
    
    resp = @client["groups/#{group_id}/remove_member."+format].put(
      :member => {
        :id => item_id,
        :type => item_type,
      }
    )
    
    parse_response(resp, format)
  end
  
  def parse_response(resp, format)
    if format == 'xml'
      Nokogiri::XML(resp)
    elsif format == 'json'
      JSON.parse!(resp)
    else
      raise ArgumentError, "#{format.inspect} is not a valid format!"
    end
  end
end