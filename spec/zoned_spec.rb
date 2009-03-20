require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

Time::DATE_FORMATS[:full_date_time] = lambda do |time|
  time.strftime("%B %d, %Y at %l:%M%p").sub(/AM/, 'am').sub(/PM/, 'pm').gsub(/\s\s+?/, ' ')
end

describe "Zoned" do
  include Zoned
  
  def timezone_offset
    @timezone_offset
  end
  
  it 'should take convert a date into the same date in a different timezone' do
    time = Time.parse("Fri, 20 Mar 2009 14:30:00 UTC +00:00")
    time.to_s(:full_date_time).should == "March 20, 2009 at 2:30pm"
    
    @timezone_offset = -14400 # EDT timezone offset
    z(time).to_s(:full_date_time).should == "March 20, 2009 at 10:30am"
    
    @timezone_offset = -25200 # PDT timezone offset
    z(time).to_s(:full_date_time).should == "March 20, 2009 at 7:30am"
  end
end