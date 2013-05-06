#!/usr/bin/env ruby

path_to_binary = ARGV[0] or abort ( "USAGE: ruby ioscheck.rb [PATH TO BINARY]" )
binary = File.basename( path_to_binary, ".*" )

output = File.new( binary + "_binary_checks.txt", "w+" )

# PIE Check

pie_check = `otool -hv #{ path_to_binary } | grep PIE`
output.puts "POSITION INDEPENDENT EXECUTABLE:\n\n"

if pie_check == ''
	output.puts "Binary has not been compiled with PIE [ISSUE]\n\n"
else
	output.puts "Binary has been compiled with PIE\n\n"
end

output.puts "$ otool -hv #{ path_to_binary } | grep PIE\n"
output.puts "#{ pie_check.strip() }\n\n"

# Stack Smashing Protection Check

stack_check = `otool -Iv #{ path_to_binary } | grep stack`
output.puts "STACK SMASHING PROTECTION:\n\n"

if stack_check == ''
	output.puts "Binary has not been compiled with Stack Smashing Protection [ISSUE]\n\n"
else
	output.puts "Binary has been compiled with Stack Smashing Protection\n\n"
end

output.puts "$ otool -Iv #{ path_to_binary } | grep stack\n"
output.puts "#{ stack_check.strip() }\n\n"

# ARC Check

arc_check = `otool -Iv #{ path_to_binary } | grep _objc_release`
output.puts "AUTOMATIC REFERENCE COUNTING:\n\n"

if arc_check == ''
	output.puts "Application does not use Automatic Reference Counting\n\n"
else
	output.puts "Application uses Automatic Reference Counting\n\n"
end

output.puts "$ otool -Iv #{ path_to_binary } | grep _objc_release\n"
output.puts "#{ arc_check.strip() }\n\n"

# Symbol Table

symbol_table = File.new( binary + "_symbol_table.txt", "w+" )
symbol_table.puts "#{ `nm #{ path_to_binary }` }"

#Class Dump

class_dump = File.new( binary + "_class_dump.txt", "w+" )
class_dump_check = `class-dump-z -A #{ path_to_binary }`

if class_dump_check =~ /Command Not Found/
	class_dump.puts "class-dump-z is not installed on this system or not in your PATH."
else
	class_dump.puts class_dump_check
end

# URL Handlers

url_handlers = File.new( binary + "_url_handlers.txt", "w+" )
url_handlers.puts "#{ `strings - #{ path_to_binary } | grep "://" | grep -v "http"` }"



