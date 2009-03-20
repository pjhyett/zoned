module Zoned
  def zoned(date_or_time)
    return date_or_time unless timezone_offset
    date_or_time.utc + timezone_offset
  end
  alias :z :zoned
  
  protected
    def timezone_offset
      controller.send(:cookies)['timezone'].to_i
    end
end
