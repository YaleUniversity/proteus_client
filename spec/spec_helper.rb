$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'proteus'
require 'savon/mock/spec_helper'
require 'webmock/rspec'
require 'simplecov'
require 'simplecov-rcov'


SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::RcovFormatter
]
SimpleCov.start
