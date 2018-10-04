# class that checks data for errors and deletes hashes with errors
class Checker
	class << self
		def check_data(file_data)
			errors = []
			file_data.each do |data_hash|
				errors << check_name(data_hash)
				errors << check_cost(data_hash)
			end
			# delete hashes that contain errors
			checked_data = file_data.delete_if { |data_hash| check_name(data_hash) || check_cost(data_hash) }
			[errors.compact, checked_data]
		end

		private

		# name field should be present and its value should be a String
		def check_name(hash)
			return '"name" doesn\'t exist' if !(hash.keys.include?('name')) || (hash.keys.include?('name') && hash['name'].nil?)
			return '"name" isn\'t a String' unless hash['name'].is_a?(String)
		end

		# cost field should be present and its value should be a positive Numeric
		def check_cost(hash)
			return '"cost" doesn\'t exist' if !(hash.keys.include?('cost')) || (hash.keys.include?('cost') && hash['cost'].nil?)
			return '"cost" isn\'t a Numeric' unless hash['cost'].is_a?(Numeric)
			return '"cost" isn\'t an integer' unless hash['cost'].integer?
			return '"cost" is zero' if hash['cost'].zero?
			return '"cost" is negative' if hash['cost'].negative?
		end
	end
end