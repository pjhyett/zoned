require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

# Showing the timezone in this format so we realize that the time is not
# changing timezones, but being offset in the same timezone just for looks
Time::DATE_FORMATS[:full_date_time] = lambda do |time|
  time.strftime("%B %d, %Y at %l:%M%p %Z").sub(/AM/, 'am').sub(/PM/, 'pm').gsub(/\s\s+?/, ' ')
end

describe "Zoned" do
  include Zoned
  
  before do
    Time.stub!(:now).and_return(Time.parse('Fri, 20 Mar 2009 12:00:00 EDT'))
  end
  
  def timezone_offset
    @timezone_offset
  end
  
  it 'should take convert a date into the same date in a different timezone' do
    time = Time.parse("Fri, 20 Mar 2009 14:30:00 UTC +00:00")
    time.to_s(:full_date_time).should == "March 20, 2009 at 2:30pm UTC"
    
    @timezone_offset = -14400 # EDT timezone offset
    z(time).to_s(:full_date_time).should == "March 20, 2009 at 10:30am UTC"
    
    @timezone_offset = -25200 # PDT timezone offset
    z(time).to_s(:full_date_time).should == "March 20, 2009 at 7:30am UTC"
  end
  
  it 'should convert a non-UTC time to the proper timezone' do
    time = Time.parse("Fri, 20 Mar 2009 9:30:00 PDT")
    time.to_s(:full_date_time).should == "March 20, 2009 at 12:30pm EDT"
    
    @timezone_offset = -14400 # EDT timezone offset
    z(time).to_s(:full_date_time).should == "March 20, 2009 at 12:30pm UTC"
    
    @timezone_offset = -25200 # PDT timezone offset
    z(time).to_s(:full_date_time).should == "March 20, 2009 at 9:30am UTC"
  end
end