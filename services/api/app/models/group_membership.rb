class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :server_group

  validates :user_id, uniqueness: { scope: :server_group_id }
end
