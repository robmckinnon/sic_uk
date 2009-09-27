# Install hook code here
# path = File.join(File.dirname(__FILE__), '..', '..', '..')

begin
  puts `cd #{RAILS_ROOT}; ./script/generate migration create_sic_uk_tables`
rescue Exception => e
  puts e.to_s
end

migration_file = `ls #{RAILS_ROOT}/db/migrate/*create_sic_uk_tables.rb`


# if File.exist?(migration_file)
  migration = IO.read("#{RAILS_ROOT}/vendor/plugins/sic-uk/data/create_sic_uk_tables.rb")
  puts "creating migration: #{migration}"
  File.open(migration_file, 'w') {|file| file.write(migration)}

  puts "trying to run: #{migration_file}"
  puts `cd #{RAILS_ROOT}; rake db:migrate`
# else
  # puts "cannot find: #{migration_file}"
# end
