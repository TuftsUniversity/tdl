class Role < ActiveRecord::Base
  has_and_belongs_to_many :users

  attr_accessible :name
  attr_accessible :user_ids
  #attr_accessible :user_emails

  rails_admin do
      configure :users do
        inverse_of :roles
        # configuration here
      end
  end
  validates :name,
    uniqueness: true,
    format: { with: /\A[a-zA-Z0-9._-]+\z/,
      :message => "Only letters, numbers, hyphens, underscores and periods are allowed"}

end