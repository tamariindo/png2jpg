#!/usr/bin/ruby

require "colorize"
require "mini_magick"

$pngs = Dir[]
$png_counter = 0
$total_size = 0
$final_size = 0

def get_pattern
	puts "\nBy default, this script looks for PNG files by using this pattern: \"*png\""
	print "Do you want to use a different pattern?(Y/n): "
	input = gets.chomp.downcase

	if input == "y" then
                print "Please enter the new pattern, e.g., \"__*png\", make sure you include the \"png\": "
                pattern = gets.chomp.downcase
		begin
			$pngs = Dir[pattern]
		rescue 
			puts "\nSorry, try another pattern..."
			exit(true)
		end
	elsif input == "n" then
		$pngs = Dir["*png"]
	else
		exit(true)
        end
end

def get_size(png)
	return ("%.2f" % ((File.size(png).to_f)/1000000)).to_f
end

def png_counter
	$png_counter = 0
	$pngs.each do |png|
		$png_counter += 1
		$total_size += get_size(png)
	end

	if $png_counter > 0 then
		puts "\nPNG found: #{$png_counter}"
		puts "Total size: ~#{'%.2f' % ($total_size)}MB"
	else 
		puts "No PNG found..."
		exit(true)
	end
end

def converter(delete=false)
	count = 1
	$pngs.each do |png|
		f_name = File.basename(png, ".png")
		puts "\nConverting(#{count}/#{$png_counter}) #{png}"
		puts "Initial size: #{get_size(png)}MB"
		img = MiniMagick::Image.open(png)
		img.format "jpg"
		img.write "#{f_name}.jpg"
		puts "Final size:  " + get_size("#{f_name}.jpg").to_s + "MB"
		$final_size += get_size("#{f_name}.jpg")
		delete ? File.delete(png) : nil
		
		count += 1
	end
end

def main
	puts <<-'EOF'
                    ___  _             
                   |__ \(_)            
  _ __  _ __   __ _   ) |_ _ __   __ _ 
 | '_ \| '_ \ / _` | / /| | '_ \ / _` |
 | |_) | | | | (_| |/ /_| | |_) | (_| |
 | .__/|_| |_|\__, |____| | .__/ \__, |
 | |           __/ |   _/ | |     __/ |
 |_|          |___/   |__/|_|    |___/ 

	EOF
	get_pattern
	png_counter

	print "\nDo you want to convert these files to JPG?(Y/n): "
	input = gets.chomp.downcase
	
	if input == "y" then
		print "Do you want to delete the PNG file after its conversion?(Y/n): "
		input = gets.chomp.downcase
		if input == "y" then
			converter(true)
		elsif input == "n" then
			converter
		else
			exit(true)
		end
	else 
		exit(true)
	end

	puts "\nInitial size: ~#{'%.2f' % ($total_size)}MB"
        puts "Final size:   ~#{'%.2f' % ($final_size)}MB"
end

main
