class Templates::MatrixUser < ApplicationRecord
  serialize :programs, Array
  belongs_to :user, optional: true

  validates :name, presence: true

  validates :reaction, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 10}
  validates :intuition, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 10}
  validates :logic, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 10}
  validates :willpower, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 10}

  validates :computer, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 7}
  validates :cybercombat, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 7}
  validates :data_search, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 7}
  validates :electronic_warfare, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 7}
  validates :hacking, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 7}
end
