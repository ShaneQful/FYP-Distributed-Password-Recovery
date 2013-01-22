#!/usr/bin/ruby

class DictionarySplitter
	def initialize file_name
		file = File.open(file_name, "rb")
		@words = file.readlines
		file.close
	end

	def generate_output_files name
		count = 0
		@buckets.each do |bucket|
			File.open(name+"_#{count}", "w") do |io|  
				bucket.each do |word|
					io.print word #words still have \n @ the end
				end
			end
			count += 1
		end
	end

	def split_dictionary number_of_crackers
		@buckets = Array.new
		number_of_crackers.times do |i|
			@buckets.push Array.new()
		end
		i = 0
		@words.each do |word|
			@buckets[i % number_of_crackers].push word
			i += 1
		end
	end
end

# Usage: 
# ruby dictionary_splitter.rb world_list_file number_of_crackers name_prepended_to_output_files
# 
# Eg. for my usage
# ruby dictionary_splitter.rb password 9 rogue
if __FILE__==$0
	test = DictionarySplitter.new ARGV[0]
	test.split_dictionary ARGV[1].to_i
	test.generate_output_files ARGV[2]
end