# frozen_string_literal: true

require "test_helper"
require "zip"
require "fileutils"

class CallReportTest < Minitest::Test
  def test_fetch_returns_dataframe_with_mocked_selenium
    call_report = FfiecAsDataframe::CallReport.new(Date.new(2023, 12, 31))
    
    mock_driver = nil
    mock_options = Minitest::Mock.new
    mock_options.expect(:add_argument, nil, [String])
    mock_options.expect(:prefs=, nil, [Hash])
    
    original_mktmpdir = Dir.method(:mktmpdir)
    Dir.define_singleton_method(:mktmpdir) do |*args, &block|
      original_mktmpdir.call(*args) do |tmpdir|
        mock_driver = MockWebDriver.new(tmpdir)
        block.call(tmpdir)
      end
    end
    
    begin
      Selenium::WebDriver::Chrome::Options.stub :new, mock_options do
        Selenium::WebDriver.stub :for, lambda { |*args| mock_driver } do
          Object.stub :sleep, nil do
            result = call_report.fetch
            
            assert_instance_of Polars::DataFrame, result
            assert result.height > 0
            assert_includes result.columns, "IDRSSD"
          end
        end
      end
      
      assert mock_driver.quit_called, "WebDriver quit should be called"
      mock_options.verify
    ensure
      Dir.singleton_class.send(:remove_method, :mktmpdir)
      Dir.define_singleton_method(:mktmpdir, original_mktmpdir)
    end
  end

  def test_initialization_with_defaults
    call_report = FfiecAsDataframe::CallReport.new
    
    assert_instance_of Date, call_report.dt
    assert_nil call_report.tag
    assert_equal({}, call_report.opts)
  end

  def test_initialization_with_custom_date
    custom_date = Date.new(2022, 12, 31)
    call_report = FfiecAsDataframe::CallReport.new(custom_date)
    
    assert_equal custom_date, call_report.dt
  end

  def test_initialization_with_table_filter
    call_report = FfiecAsDataframe::CallReport.new(Date.today, 'RC')
    
    assert_equal 'RC', call_report.tag
  end

  def test_initialization_with_options
    opts = {headless: false}
    call_report = FfiecAsDataframe::CallReport.new(Date.today, nil, opts)
    
    assert_equal opts, call_report.opts
  end
end

class MockWebDriver
  attr_reader :quit_called, :download_dir
  
  def initialize(tmpdir)
    @quit_called = false
    @download_dir = tmpdir
  end
  
  def get(url)
  end
  
  def find_elements(selector)
    if selector[:css]&.include?('ListBox1')
      [MockElement.new('Call Reports -- Single Period')]
    elsif selector[:css]&.include?('DatesDropDownList')
      [
        MockElement.new('03/31/2023'),
        MockElement.new('12/31/2023')
      ]
    elsif selector[:css]&.include?('Download_0')
      create_test_zip_file
      [MockElement.new('Download')]
    else
      []
    end
  end
  
  def find_element(selector)
    MockElement.new('Download Button')
  end
  
  def action
    MockAction.new
  end
  
  def quit
    @quit_called = true
  end
  
  private
  
  def create_test_zip_file
    return unless @download_dir
    
    zip_path = File.join(@download_dir, "FFIEC_CDR_Call_12312023.zip")
    
    csv_content = "IDRSSD\tFDIC Certificate Number\tTest Column\n" \
                  "12345\t10057\tValue1\n" \
                  "67890\t3850\tValue2\n"
    
    Zip::File.open(zip_path, create: true) do |zipfile|
      zipfile.get_output_stream("FFIEC_CDR_Call_Report_12312023.txt") do |f|
        f.write csv_content
      end
    end
  end
  
  def method_missing(method, *args, &block)
    nil
  end
end

class MockElement
  attr_reader :text
  
  def initialize(text = '')
    @text = text
  end
  
  def click
  end
  
  def present?
    true
  end
end

class MockAction
  def move_to(element)
    self
  end
  
  def perform
  end
end
