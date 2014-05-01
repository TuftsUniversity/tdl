class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller 
  include Blacklight::Controller
  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 

  #layout 'blacklight'
  layout 'tdl-bootstrap'

  rescue_from ActiveFedora::ObjectNotFoundError, :with => :error_generic

  rescue_from Hydra::AccessDenied, CanCan::AccessDenied do |exception|
    render(file: "public/401", status: :unauthorized, layout: nil)
  end

  rescue_from DeviseLdapAuthenticatable::LdapException, Net::LDAP::LdapError do |exception|
    render :text => exception, :status => 500
  end

  def error_generic
      flash[:retrieval] = "The object you have reached does not exist. If you have questions, you can <a href='/contact'>contact DCA</a>"
      redirect_to root_path
  end

  protect_from_forgery
end
