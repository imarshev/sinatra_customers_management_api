class Customer < ActiveRecord::Base
  PERMITTED_PARAMS = %i[first_name last_name patronymic_name email].freeze

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :patronymic_name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true

  def self.from_hash(hash)
    customer = find_or_initialize_by(email: hash[:email])
    customer.assign_attributes(hash)
    customer.save if customer.changed?
    customer
  end
end
