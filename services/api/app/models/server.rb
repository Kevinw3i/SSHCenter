class Server < ApplicationRecord
  belongs_to :server_group, optional: true

  IPV4_REGEX = /\A(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}\z/

  validates :site, :env, :role, :ip, presence: true
  validates :ip, format: { with: IPV4_REGEX }

  before_validation :normalize_fields

  private

  def normalize_fields
    self.site = site.to_s.strip
    self.env = env.to_s.strip
    self.role = role.to_s.strip
    self.ip = ip.to_s.strip
  end
end
