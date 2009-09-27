# SIC(2003) example
# Section     D         Manufacturing
#
# SIC(2007) example
# SECTION     C         MANUFACTURING
class SicUkSection < ActiveRecord::Base

  has_many :sic_uk_subsections, :sic_uk_divisions, :sic_uk_groups, :sic_uk_classes, :sic_uk_subclasses

end
