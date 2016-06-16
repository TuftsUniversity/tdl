class User < ActiveRecord::Base
  has_and_belongs_to_many :roles

  # Connects this user object to Hydra behaviors. 
  include Hydra::User

  # Connects this user object to Role behaviors. 
  include Hydra::RoleManagement::UserRoles

  # Connects this user object to Blacklights Bookmarks. 
  include Blacklight::User

  devise :ldap_authenticatable, :trackable
  devise :timeoutable, :timeout_in => 60.minutes
  before_create :set_default_role


  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :password, :password_confirmation, :role_ids

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

  private

  def set_default_role
    self.roles= [Role.find_by_name('community_member')]
  end

end
