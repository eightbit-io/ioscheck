#!/usr/bin/env ruby

require 'fileutils'

if ARGV.empty?
	abort ( "USAGE: ruby bincheckios.rb [PATH TO BINARY]" )
else
	path_to_binary = ARGV[0]
end

binary = File.basename( path_to_binary, ".*" )

output = File.new( binary + "_binary_check)output.txt", "w+" )

#PIE Check

pie_check = `otool -hv #{ binary } | grep PIE`

output.puts "POSITION INDEPENDENT EXECUTABLE:\n\n"

if pie_check == ''
	output.puts "Binary has not been compiled with PIE [ISSUE]\n\n"
else
	output.puts "Binary has been compiled with PIE\n\n"
end

output.puts "$ otool -hv #{ binary } | grep PIE\n"
output.puts "#{ pie_check.strip() }\n\n"

#Stack Smashing Protection Check

stack_check = `otool -Iv #{ binary } | grep stack`

output.puts "STACK SMASHING PROTECTION:\n\n"

if stack_check == ''
	output.puts "Binary has not been compiled with Stack Smashing Protection [ISSUE]\n\n"
else
	output.puts "Binary has been compiled with Stack Smashing Protection\n\n"
end

output.puts "$ otool -Iv #{ binary } | grep stack\n"
output.puts "#{ stack_check.strip() }\n\n"

#ARC Check

arc_check = `otool -Iv #{ binary } | grep _objc_release`

output.puts "AUTOMATIC REFERENCE COUNTING:\n\n"

if arc_check == ''
	output.puts "Application does not use Automatic Reference Counting\n\n"
else
	output.puts "Application uses Automatic Reference Counting\n\n"
end

output.puts "$ otool -Iv #{ binary } | grep _objc_release\n"
output.puts "#{ arc_check.strip() }\n\n"

#Symbol Table

