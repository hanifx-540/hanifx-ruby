require 'hanifx'
require 'fileutils'

# -------------------------
# Terminal Colors
class String
  def red;    "\e[31m#{self}\e[0m" end
  def green;  "\e[32m#{self}\e[0m" end
  def yellow; "\e[33m#{self}\e[0m" end
  def blue;   "\e[34m#{self}\e[0m" end
  def cyan;   "\e[36m#{self}\e[0m" end
end
HANIFX_LOGO = <<~LOGO
  [====================================]
           HANIFX-BHENC
  [====================================]
LOGO

def show_hanifx_logo
  HANIFX_LOGO.lines.each { |line| puts line.cyan }
end

show_hanifx_logo
puts "[INFO] Welcome to hanifx Gem!".green

def prompt(msg, color=:cyan)
  print "#{msg.send(color)}: "
  gets.chomp
end

def yes_no(msg, color=:yellow)
  answer = prompt(msg, color).downcase
  answer == "yes"
end

puts "\n=== Hanifx Interactive Professional Test ===".blue

# -------------------------
# 1️⃣ Manual Module Imports
modules_input = prompt("\nStep 1: Enter modules to import (comma separated), or leave empty")
import_modules = modules_input.split(",").map(&:strip).reject(&:empty?)
import_modules.each do |mod|
  begin
    require mod
    puts "[INFO] Module imported: #{mod}".green
  rescue LoadError
    puts "[WARNING] Could not import module: #{mod}".red
  end
end

# -------------------------
# 2️⃣ Text Encoding
puts "\nStep 2: Text Encoding".blue
user_text = prompt("Enter text to encode")
skip_warn_text = yes_no("Skip warning before encoding? (yes/no)")
verbose_text = yes_no("Enable verbose logging? (yes/no)")

encoded_text = Hanifx.encode_text(
  user_text,
  { skip_warning: skip_warn_text, verbose: verbose_text }
)
puts "\nEncoded Text: #{encoded_text}".green

# -------------------------
# 3️⃣ File Encoding (Manual Save, Suffix-Free)
puts "\nStep 3: File Encoding".blue
file_path = prompt("Enter file path to encode, or leave empty to skip")

unless file_path.empty?
  skip_warn_file = yes_no("Skip warning before file encoding?")
  verbose_file = yes_no("Enable verbose logging?")
  overwrite_file = yes_no("Overwrite existing encoded file if exists?")

  # Ask for exact output filename/path
  output_file_path = prompt("Enter full output file path (exactly where you want to save it)")

  # Manual file encoding using Hanifx.encode_text
  if !overwrite_file && File.exist?(output_file_path)
    puts "[WARNING] Output file exists and overwrite=false".red
  else
    FileUtils.mkdir_p(File.dirname(output_file_path))
    input_content = File.read(file_path)
    encoded_content = Hanifx.encode_text(input_content, { skip_warning: skip_warn_file, verbose: verbose_file })
    File.write(output_file_path, encoded_content)
    puts "[INFO] File encoded successfully: #{output_file_path}".green
  end
end

# -------------------------
# 4️⃣ Script Safety Check
puts "\nStep 4: Script Safety Check".blue
script_path = prompt("Enter .rb script path to check safety, or leave empty to skip")
unless script_path.empty?
  verbose_check = yes_no("Enable verbose logging for script check?")
  Hanifx.check_script(
    script_path,
    { verbose: verbose_check }
  )
end

puts "\n✅ All interactive Hanifx tests completed!".green
