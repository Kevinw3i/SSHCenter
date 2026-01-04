class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist

  enum :role, { admin: 0, manage: 1, user: 2 }, prefix: true
  enum :open_mode, { terminal: "terminal", web: "web" }, prefix: true

  has_many :group_memberships, dependent: :destroy
  has_many :server_groups, through: :group_memberships

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :open_mode, presence: true
  validates :password, presence: true, length: { minimum: 8 }, if: :password_required?

  before_validation :normalize_username
  before_create :ensure_otp_secret!

  def otp_provisioning_uri
    totp.provisioning_uri(username)
  end

  def valid_otp?(code)
    return false if code.blank? || otp_secret.blank?

    totp.verify(code.to_s, drift_behind: 30, drift_ahead: 30)
  end

  def ensure_otp_secret!
    self.otp_secret ||= ROTP::Base32.random
  end

  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end

  def jwt_payload
    { "exp" => (Time.current + jwt_expiration_duration).to_i }
  end

  private

  def normalize_username
    self.username = username.to_s.strip.downcase
  end

  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end

  def totp
    @totp ||= ROTP::TOTP.new(otp_secret, issuer: "SSCenter")
  end

  def jwt_expiration_duration
    return 12.hours if role_admin? || role_manage?

    1.hour
  end
end
