class Animal < ApplicationRecord
  belongs_to :especie
  belongs_to :recinto

  validates :identificador, presence: true
  validates :identificador, uniqueness: true
  validates :genero, presence: true
  validates :especie, presence: true
  validates :recinto, presence: true
end
