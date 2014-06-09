class User < ActiveRecord::Base
  has_and_belongs_to_many :roles

  # Connects this user object to Hydra behaviors. 
  include Hydra::User

  # Connects this user object to Role behaviors. 
  include Hydra::RoleManagement::UserRoles

  # Connects this user object to Blacklights Bookmarks. 
  include Blacklight::User

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable
  devise :ldap_authenticatable, :trackable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :username, :password

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account. 
  def to_s
    username
  end

  def display_name  #update this method to return the string you would like used for the user name stored in fedora objects.
    Devise::LDAP::Adapter.get_ldap_param(self.username, "tuftsEduDisplayNameLF")[0]
  end

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def has_roles?(role_syms)
    role_syms.each do |role_sym|
      if has_role?(role_sym)
        return true
      end
    end

    return false
  end

end
