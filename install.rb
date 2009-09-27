# Install hook code here
# path = File.join(File.dirname(__FILE__), '..', '..', '..')

begin
  puts `cd #{RAILS_ROOT}; ./script/generate migration create_sic_uk_tables`
rescue Exception => e
  puts e.to_s
end

migration_file = `ls #{RAILS_ROOT}/db/migrate/*create_sic_uk_tables.rb`

puts "trying to run: #{migration_file}"

if File.exists?(migration_file)
  migration = IO.read("#{RAILS_ROOT}/vendor/plugins/sic-uk/data/create_sic_uk_tables.rb")
  File.open(migration_file, 'w') {|file| file.write(migration)}

  puts `cd #{RAILS_ROOT}; rake db:migrate`
end
