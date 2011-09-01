module WatchrActions
  def self.run_spec(file)
    unless File.exist?(file)
      puts "#{file} does not exist"
      return
    end

    puts "Running #{file}"
    system "rspec #{file}"
  end
end

watch(/^lib\/(?:sorted\/)?(.*).rb/) do |m|
  WatchrActions.run_spec("spec/#{m[1]}_spec.rb")
end

watch(/^spec\/.*_spec.rb/) do |m|
  WatchrActions.run_spec(m[0])
end

watch(/^lib\/sorted\/finders\/active_record.rb/) do |m|
  WatchrActions.run_spec('spec/sorted_spec.rb')
end

