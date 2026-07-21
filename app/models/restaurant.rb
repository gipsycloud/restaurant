class Restaurant < ApplicationRecord
    has_many :users, dependent: :destroy
    has_many :tables, dependent: :destroy
    has_many :menus, dependent: :destroy
    has_many :orders, through: :tables, dependent: :destroy
    has_many :reservations, through: :tables

    validates :name, presence: true
    validates :address, presence: true
    validates :phone, presence: true, format: { 
      with: /\A\+959\d{9}\z/,
      message: "must be in the format +959123456789"
    }
  end