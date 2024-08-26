require 'polars-df'
require 'csv'
require 'zip'
require 'tempfile'
require 'selenium-webdriver'
require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/string/conversions'

module FfiecAsDataframe
  class CallReport
    # include ::HTTParty
    attr_reader :tag, :dt, :opts

    def initialize(dt= Date.today.beginning_of_quarter - 1, tbl= nil, options={})
      @tag = tbl
      @dt = dt.to_date
      @opts = options
    end

    def fetch
      prefix = 'All_Reports_'
      dte = dt.end_of_quarter
      # dir = prefix + date.year.to_s + format('%02d', date.month.to_s) + date.mday.to_s
      df = nil

      Dir.mktmpdir(nil, Dir.tmpdir) do |d|
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument('--headless') unless opts[:headless] == false
        options.prefs = {"download.default_directory": d};

        driver = Selenium::WebDriver.for :chrome, options: options
        driver.get "https://cdr.ffiec.gov/public/PWS/DownloadBulkData.aspx"
        sleep(0.2)
        driver.find_elements(css: 'select#ListBox1 option').detect{|o| o.text == 'Call Reports -- Single Period'}.click()

        dte_found = false
        dte = dte.strftime("%m/%d/%Y").to_s

        if (opt = driver.find_elements(css: 'select#DatesDropDownList option').detect{ |o| o.text == dte }).present?
          opt.click() 
        else
          dtes = driver.find_elements(css: 'select#DatesDropDownList option').map{|o| o.text.to_date }
          dte = dtes.max.strftime("%m/%d/%Y").to_s
          driver.find_elements(css: 'select#DatesDropDownList option').detect{|o| o.text == dte }.click() 
        end

        sleep(1.0)
        driver.action.move_to(driver.find_element(css: 'input#Download_0')).perform()
        driver.find_elements(css: 'input#Download_0').last.click()

        sleep(1.0)
        driver.quit

        zipfn = Dir[File.join(d,'*.zip')].first

        require 'zip'
        Zip::File.open(zipfn) do |z|
          z.each do |zf|
            # puts zf.name
            next if /^FFIEC/ !~ zf.name

            if tag.nil? || !(/\b#{tag}\b/ =~ zf.name).nil?
              txt = zf.get_input_stream.read.encode("utf-8", "binary", :undef => :replace).gsub("\r",'').gsub('"', '')
              # puts "txt = #{txt.inspect}"
              dta = CSV.parse(txt, col_sep:"\t", headers:true, converters: [:numeric])

              keys = dta.first.headers.compact
              vals = dta.map{|r| r.to_h.values }.transpose[0..(keys.length-1)]

              tmp_df = {}; (0..(keys.length-1)).to_a.each do |i| 
                if keys[i] == 'IDRSSD'
                  vals[i].map!{|v| v.to_i } 
                else
                  vals[i].map!{|v| v.to_s} if vals[i].any?{|v| v.is_a?(String)}\
                end
                tmp_df[keys[i]] = vals[i]
              end
              # puts "#{__FILE__}:#{__LINE__} tmp_df = #{tmp_df.inspect}"
              tmp_df = Polars::DataFrame.new(tmp_df).drop_nulls(subset: ['IDRSSD'])
              # puts "#{__FILE__}:#{__LINE__} tmp_df = #{tmp_df.inspect}"

              if df.nil?
                df = tmp_df.dup
              else
                df = df.join(tmp_df, on: 'IDRSSD', how: 'full')
                df = df.drop(df.columns.select{|c| /_right$/ =~ c })
                df = df.drop_nulls(subset: ['IDRSSD'])
              end
            end
          end

        end
      end

      df
    end
  end
end

