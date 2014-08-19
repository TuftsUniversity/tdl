class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller 
  include Blacklight::Controller
  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 

  #layout 'blacklight'
  layout 'tdl-bootstrap'

  rescue_from ActiveFedora::ObjectNotFoundError, :with => :error_generic

  if is_dark_archive
    before_filter :authenticate_user!
    before_filter :check_role!
  end

  rescue_from Hydra::AccessDenied, CanCan::AccessDenied do |exception|
    render(file: "public/401", status: :unauthorized, layout: nil)
  end

  rescue_from DeviseLdapAuthenticatable::LdapException, Net::LDAP::LdapError do |exception|
    render :text => exception, :status => 500
  end

  def check_role!
    unless devise_controller? or rails_admin_controller? or current_user.nil? or current_user.has_role? :archivist
      render(file: "public/401", status: :unauthorized, layout: nil)
    end
  end

  def rails_admin_controller?
    return false
  end

  def error_generic
      flash[:retrieval] = "The object you have reached does not exist. If you have questions, you can <a href='/contact'>contact DCA</a>"
      redirect_to root_path
  end

  protect_from_forgery
end
