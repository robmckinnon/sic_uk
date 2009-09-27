# SIC(2003) example
# Group       15.1      Production, processing and preserving of meat and meat products
#
# SIC(2007) example
# Group       10.1      Processing and preserving of meat and production of meat products
class SicUkGroup < ActiveRecord::Base

  belongs_to :sic_uk_division
  belongs_to :sic_uk_subsection
  belongs_to :sic_uk_section

  has_many :sic_uk_classes
  has_many :sic_uk_subclasses

end
