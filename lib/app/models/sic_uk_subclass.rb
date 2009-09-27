# SIC(2003) example
# Subclass    15.11/1   Slaughtering of animals other than poultry and rabbits
#
# SIC(2007) example
# Subclass    10.51/1   Liquid milk and cream production
class SicUkSubclass < ActiveRecord::Base

  belongs_to :sic_uk_class, :sic_uk_group, :sic_uk_division, :sic_uk_subsection, :sic_uk_section
  has_many :sic_uk_subclasses

end
