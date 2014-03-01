require 'nokogiri'

root_dir = "/Users/#{ENV['USER']}/Library/Application Support/Crayon Physics Deluxe"

beaten_level_names = Dir["#{root_dir}/My Solutions/*.xml"].map do |absolute|
  File.basename(absolute) =~ /(.*) - \d+-\d+.xml/
  $1
end.sort.uniq

savegame_filename = "#{root_dir}/data/player_level_list.xml"

doc = Nokogiri::XML.parse(File.read(savegame_filename))

beaten_filenames = []

doc.css('Level').each do |level|
  if beaten_level_names.include? level[:level_name]
    beaten_filenames << level[:filename]
    level[:completed] = '1'
  end
end

doc.css('StarManager').each do |star_manager|
  beaten_filenames.each do |filename|
    star_manager << doc.create_element('StarData', id: filename, value: '1')
  end
end

File.write(savegame_filename, doc.root)
