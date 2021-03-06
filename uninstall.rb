migration_file = `ls #{RAILS_ROOT}/db/migrate/*create_sic_uk_tables.rb`

if migration_file && migration_file[/[^\d](\d+)_create_sic_uk_tables.rb/]
  version = $1
  puts `cd #{RAILS_ROOT}; rake db:migrate:down VERSION=#{version} --trace`
  puts "removing: #{migration_file}"
  puts `rm #{migration_file}`
end
