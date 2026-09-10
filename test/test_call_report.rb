# frozen_string_literal: true

require 'set'
require 'bundler/setup'
require_relative '../lib/ffiec_as_dataframe'

failures = []
failures << 'version' if defined?(FfiecAsDataframe::VERSION) ? FfiecAsDataframe::VERSION.to_s.empty? : (defined?(FFiecAsDataframe::VERSION) ? FFiecAsDataframe::VERSION.to_s.empty? : true)
mod = defined?(FfiecAsDataframe::CallReport) ? FfiecAsDataframe : FFiecAsDataframe
report = mod::CallReport.new
failures << 'instantiate' unless report.is_a?(mod::CallReport)
failures << 'fetch' unless report.respond_to?(:fetch)

if failures.empty?
  puts 'test_call_report: ok'
else
  abort "test_call_report failed: #{failures.join(', ')}"
end
