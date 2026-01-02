class Server < ApplicationRecord
  belongs_to :server_group

  validates :site, :env, :role, :ip, presence: true
end
