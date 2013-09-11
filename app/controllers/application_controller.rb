class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller 
  include Blacklight::Controller
  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 

  #layout 'blacklight'
  layout 'tdl-bootstrap'

  before_filter :add_remove_js_css, :add_my_own_assets
  rescue_from ActiveFedora::ObjectNotFoundError, :with => :error_generic

  def add_remove_js_css
    # javascript_includes.map{|js_links| js_links.delete("accordion") if js_links.include?({:plugin=>:blacklight})}
    #    stylesheet_links << ["mycss",{:media=>"all"}]
  end

  def add_my_own_assets
    stylesheet_links << "tdl"

    # You can do something similar with javascript files too:
    javascript_includes << "tdl"
  end

  def error_generic

      flash[:notice] = "The object you have reached does not exist. If you have questions, you can <a href='/contact'>contact DCA</a>"
      redirect_to root_path

  end

  protect_from_forgery
end
