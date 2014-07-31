Rails.configuration.middleware.use(IsItWorking::Handler) do |h|
  # Check the ActiveRecord database connection without spawning a new thread
     h.check :active_record, :async => false
  #     # Check the mail server configured for ActionMailer
     h.check :action_mailer if ActionMailer::Base.delivery_method == :smtp
end
