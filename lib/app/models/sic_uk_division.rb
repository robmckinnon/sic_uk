# SIC(2003) example
# Division    15        Manufacture of Food Products and Beverages
#
# SIC(2007) example
# Division    10        Manufacture of food products
class SicUkDivision < ActiveRecord::Base

  belongs_to :sic_uk_subsection
  belongs_to :sic_uk_section

  has_many :sic_uk_groups
  has_many :sic_uk_classes
  has_many :sic_uk_subclasses

end
