class Templates::MatrixProgram < ApplicationRecord
  belongs_to :has_programs, polymorphic: true
end
