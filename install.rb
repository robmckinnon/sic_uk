begin
  puts `cd #{RAILS_ROOT}; ./script/generate migration create_sic_uk_tables`
rescue Exception => e
  puts e.to_s
end

migration_file = `ls #{RAILS_ROOT}/db/migrate/*create_sic_uk_tables.rb`
if migration_file && migration_file[/[^\d](\d+)_create_sic_uk_tables.rb/]
  version = $1
else
  version = nil
end

begin
  puts `cd #{RAILS_ROOT}; ./script/destroy migration create_sic_uk_tables`
rescue Exception => e
  puts e.to_s
end

migration = %Q%
class CreateSicUkTables < ActiveRecord::Migration

  # SIC(2003) example
  #
  # Section     D         Manufacturing
  # Subsection  DA        Manufacture of Food Products, Beverages and Tobacco
  # Division    15        Manufacture of Food Products and Beverages
  # Group       15.1      Production, processing and preserving of meat and meat products
  # Class       15.11     Production and preserving of meat
  # Subclass    15.11/1   Slaughtering of animals other than poultry and rabbits

  # SIC(2007) example
  #
  # SECTION     C         MANUFACTURING
  # Division    10        Manufacture of food products
  # Group       10.1      Processing and preserving of meat and production of meat products
  # Class       10.11     Processing and preserving of meat
  # Subclass    10.51/1   Liquid milk and cream production

  def self.up
    foreign_keys = {
        :sic_uk_subsections => [:sic_uk_section_id],
        :sic_uk_divisions => [:sic_uk_subsection_id, :sic_uk_section_id],
        :sic_uk_groups => [:sic_uk_division_id, :sic_uk_subsection_id, :sic_uk_section_id],
        :sic_uk_classes => [:sic_uk_group_id, :sic_uk_division_id, :sic_uk_subsection_id, :sic_uk_section_id],
        :sic_uk_subclasses => [:sic_uk_class_id, :sic_uk_group_id, :sic_uk_division_id, :sic_uk_subsection_id, :sic_uk_section_id] }

    [:sic_uk_sections, :sic_uk_subsections, :sic_uk_divisions, :sic_uk_groups, :sic_uk_classes, :sic_uk_subclasses].each do |table|
      create_table table do |t|
        t.integer :year
        t.string :code
        t.string :description

        foreign_keys[table].each do |foreign_key|
          t.integer foreign_key
        end unless (table == :sic_uk_sections)

        if table == :sic_uk_classes
          t.integer :sic_uk_code
        end
      end

      foreign_keys[table].each do |foreign_key|
        add_index table, foreign_key
      end unless (table == :sic_uk_sections)
    end
  end

  def self.down
    [:sic_uk_sections, :sic_uk_subsections, :sic_uk_divisions, :sic_uk_groups, :sic_uk_classes, :sic_uk_subclasses].each do |table|
      drop_table table
    end
  end
end
%

puts "writing migration"
migration_file = "#{RAILS_ROOT}/db/migrate/#{version}_create_sic_uk_tables.rb"
File.open(migration_file, 'w') {|file| file.write(migration)}

puts "running: #{migration_file}"
puts `cd #{RAILS_ROOT}; rake db:migrate --trace`

data = IO.read(File.expand_path(File.dirname(__FILE__) + "/data/sic_uk_2003.tsv"))

@section = nil
@subsection = nil
@division = nil
@group = nil
@class = nil
@year = 2003

def add_section code, description
  @subsection = nil
  @division = nil
  @group = nil
  @class = nil
  @section = SicUkSection.create :code => code, :description => description, :year => @year
end

def add_subsection code, description
  @division = nil
  @group = nil
  @class = nil
  @subsection = SicUkSubsection.create :code => code, :description => description, :year => @year,
      :sic_uk_section_id => @section.id
end

def add_division code, description
  @group = nil
  @class = nil
  @division = SicUkDivision.create :code => code, :description => description, :year => @year,
      :sic_uk_section_id => @section.id,
      :sic_uk_subsection_id => (@subsection ? @subsection.id : nil)
end

def add_group code, description
  @class = nil
  @group = SicUkGroup.create :code => code, :description => description, :year => @year,
      :sic_uk_section_id => @section.id,
      :sic_uk_subsection_id => (@subsection ? @subsection.id : nil),
      :sic_uk_division_id => @division.id
end

def add_class code, description
  @class = SicUkClass.create :code => code, :description => description, :year => @year,
      :sic_uk_section_id => @section.id,
      :sic_uk_subsection_id => (@subsection ? @subsection.id : nil),
      :sic_uk_division_id => @division.id,
      :sic_uk_group_id => @group.id,
      :sic_uk_code => code.sub('.','').to_i
end

def add_subclass code, description
  subclass = SicUkSubclass.create :code => code, :description => description, :year => @year,
      :sic_uk_section_id => @section.id,
      :sic_uk_subsection_id => (@subsection ? @subsection.id : nil),
      :sic_uk_division_id => @division.id,
      :sic_uk_group_id => @group.id,
      :sic_uk_class_id => @class.id
end

data.each_line do |line|
  code, description = line.split("\t")
  puts "adding: #{code} #{description}"
  case code
    when /^Section ([A-Z])$/
      puts "  running: add_section"
      add_section $1, description
    when /^Subsection ([A-Z][A-Z])$/
      puts "  running: add_subsection"
      add_subsection $1, description
    when /^\d\d$/
      puts "  running: add_division"
      add_division code, description
    when /^\d\d\.\d$/
      puts "  running: add_group"
      add_group code, description
    when /^\d\d\.\d\d$/
      puts "  running: add_class"
      add_class code, description
    when /^\d\d\.\d\d\/\d$/
      puts "  running: add_subclass"
      add_subclass code, description
    else
      raise "cannot handle code: #{code}"
  end
end
