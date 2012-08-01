class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name
  attr_accessor :stripe_card_token
  validates :email, :presence => true

  def name
    [first_name, last_name].join " "
  end
  
  def save_with_payment(user_stripe_card_token)
    if valid?
      
      charge = Stripe::Charge.create(
        :amount => 1900, 
        :currency => "usd",
        :card => user_stripe_card_token,
        :description => email
      )
     
      self.stripe_customer_token = user_stripe_card_token
      self.paid = 1
      self.active = 1
      save!   
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end
  
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.user_name = auth.extra.raw_info.username
      user.first_name = auth.extra.raw_info.first_name
      user.middle_name = auth.extra.raw_info.middle_name
      user.last_name = auth.extra.raw_info.last_name
      user.birth_date = Date.strptime(auth.extra.raw_info.birthday,"%m/%d/%Y")
      user.email = auth.extra.raw_info.email
      user.location = auth.extra.raw_info.location.name
      user.bio = auth.extra.raw_info.bio
      user.thumb_image = auth.info.image
      
      if auth.extra.raw_info.gender == 'male'
        user.gender = 1
      else
        user.gender = 0
      end
      
     # user.save!
    end
  end
end
