# SIC(2003) example
# Subsection  DA        Manufacture of Food Products, Beverages and Tobacco
#
# SIC(2007) n/a
class SicUkSubsection < ActiveRecord::Base

  belongs_to :sic_uk_section
  has_many :sic_uk_divisions, :sic_uk_groups, :sic_uk_classes, :sic_uk_subclasses

end
