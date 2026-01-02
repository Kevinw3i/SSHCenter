class ServerGroup < ApplicationRecord
  has_many :servers, dependent: :destroy
  has_many :group_memberships, dependent: :destroy
  has_many :users, through: :group_memberships

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
