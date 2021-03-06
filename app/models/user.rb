class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable,
         :trackable, :validatable
  devise :omniauthable, omniauth_providers: [:github, :twitter]

  has_many :goals    # Goals which created by user
  has_one :goal_list # Goals to be done

  delegate :goal_in_lists, to: :goal_list

  def goal_list
    super || (build_goal_list.save! && goal_list)
  end

  def grouped_goals_in_list
    goal_in_lists.group_by{ |goal_in_list| goal_in_list.aasm_state }
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email || "email-#{SecureRandom.uuid}@example.com"
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
    end
  end

end
