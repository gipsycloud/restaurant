class Reservation < ApplicationRecord
  belongs_to :table

  has_many :orders, dependent: :nullify

  validates :customer_name, presence: true
  validates :phone, presence: true
  validates :guest_count, presence: true, numericality: { greater_than: 0 }
  validetes :reserved_at, presence: true