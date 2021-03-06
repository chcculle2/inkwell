class User < ActiveRecord::Base
  has_many :authentications
  has_many :friends
  has_many :orders  
  has_many :occasions, :through => :friends

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable,#, :validatable,
  :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  attr_accessible :email, :password, :password_confirmation, :remember_me,
  :first_name, :last_name, :street_address, :city, :state,
  :zipcode, :provider, :uid, :name

  after_create :send_welcome_email

  validates_presence_of :email, :encrypted_password
  validates :email, uniqueness: true
  validates_confirmation_of :password

  def password_required?
    password.blank?
  end

  def name
    first_name + " " + last_name
  end

  def orders_without_cards
    selected_orders = orders.select{|order| order.status == "no_card"}
    selected_orders.sort{|x,y|y.created_at <=> x.created_at}.map{|order| order.occasion}
  end

  def orders_in_cart
    orders.select { |order| order.status == "in_cart" }
  end

  def orders_in_cart_total
     orders_in_cart.inject(0) {|sum, order| sum += order.card.price}
  end 

  def future_orders
    orders.reject{|order| order.upcoming?}.sort_by { |order| Date.today - order.event_date }
  end

  def upcoming_orders
    orders.select{|order| order.upcoming?}.sort_by { |order| Date.today - order.event_date  }
  end


  def facebook
    oauth_token = self.authentications.find_by_provider('facebook').oauth_token
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    block_given? ? yield(@facebook) : @facebook
    rescue Koala::Facebook::APIError => e
      logger.info e.to_s
    nil
  end

  def get_facebook_friends
    friends = facebook.get_connections("me", "friends", "fields"=>"name,birthday,picture")
    friends.sort{|a,b| a['name'] <=> b['name']}
  end

  def authenticated_with_facebook?
    if self.authentications.find_by_provider('facebook')
      return self.authentications.find_by_provider('facebook').oauth_expires_at > Time.now
    end
    false
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver
  end
end
