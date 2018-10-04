require 'sql-maker' # use it to build SQL queries
require_relative './parser.rb'
require_relative './checker.rb'

# class that solves the task
class Solution
	attr_accessor :data, :builder, :result
	def initialize
		@builder = SQL::Maker.new(driver: 'psql')
		@data = Parser.new.parse_files
		@result = []
	end

	def solve
		build_sql_and_errors
		write_result
	end

	private

	# check hashes of each parsed json or csv file to have errors
	# output errors and build queries with checked data 
	def build_sql_and_errors
		@data.each do |file_name, file_data|
			errors, checked_data = Checker.check_data(file_data)
			puts file_name, errors unless errors.empty?
			checked_data.each do |hash|
				@result << @builder.insert(:items, hash)
			end
		end
	end

	def write_result
		File.open('./insert.sql', 'w+') { |f| f.puts(@result) }
	end
end