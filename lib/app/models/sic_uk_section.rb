# SIC(2003) example
# Section     D         Manufacturing
#
# SIC(2007) example
# SECTION     C         MANUFACTURING
class SicUkSection < ActiveRecord::Base

  has_many :sic_uk_subsections
  has_many :sic_uk_divisions
  has_many :sic_uk_groups
  has_many :sic_uk_classes
  has_many :sic_uk_subclasses

end
