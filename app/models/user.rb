class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :phone_number, numericality: true, length:{ is: 10 }

  has_many :restaurants
  has_many :orders

  # has_attached_file :picture,
  #   styles: { medium: "300x300>", thumb: "100x100>" }
  after_create :send_welcome_email
  after_create :subscribe_to_newsletter

  private

  def send_welcome_email
    if self.restaurant_owner?
      UserMailer.welcome_owner(self).deliver_now
    else
      UserMailer.welcome_customer(self).deliver_now
    end
  end


  def subscribe_to_newsletter
    # binding.pry
    SubscribeToNewsletter.new(self).run
  end
  # validates_attachment_content_type :picture,
  #   content_type: /\Aimage\/.*\z/
end

