class BaseUserAttribute < ApplicationRecord
  validates :name, uniqueness: true
  validates :name, :possible_values, presence: true
  serialize :possible_values, JSON
end
