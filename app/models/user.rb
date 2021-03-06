class User < ActiveRecord::Base
  has_many :picks
  has_many :performances, :through => :picks
  has_many :games, :through => :performances
  has_many :weeks, :through => :games

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def pick_this_week(week)
    self.weeks.find_by_id(week.id)
  end
end
