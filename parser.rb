require 'json'
require 'csv'

# class that takes only .json and .csv files from ./input and parses them
# parsed data is an Array of Hashes, each Hash has file_name as a key and content of this file as value
class Parser
	attr_accessor :files

	def initialize
		@files = Dir.glob('./input/*.{json,csv}')
	end

	def parse_files
		@files.inject({}) { |acc, f| acc.merge json?(f) ? parse_json(f) : parse_csv(f) }
	end

	private

	def json?(file_name)
		cut_file_name(file_name).split('.').last == 'json'
	end

	def cut_file_name(file_name)
		file_name.gsub('./input/', '')
	end

	def parse_json(file_name)
		{ cut_file_name(file_name) => JSON.parse(File.read(file_name)).flatten }
	end

	def parse_csv(file_name)
		{ cut_file_name(file_name) => CSV.parse(File.read(file_name), converters: [CSV::Converters[:integer]]).map { |a| Hash[ ["name", "cost"].zip(a) ] }.drop(1) }
	end
end