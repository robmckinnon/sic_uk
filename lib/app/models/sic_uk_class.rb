# SIC(2003) example
# Class       15.11     Production and preserving of meat
#
# SIC(2007) example
# Class       10.11     Processing and preserving of meat
class SicUkClass < ActiveRecord::Base

  belongs_to :sic_uk_group, :sic_uk_division, :sic_uk_subsection, :sic_uk_section
  has_many :sic_uk_subclasses

end
