class Notifier < ActionMailer::Base
  default :from => "donotreply@dl.tufts.edu"

  def feedback(params)
    @params = params

    return mail(:to => Settings.tdl_feedback_address,
      :from => params[:email],
      :subject => Settings.tdl_feedback_subject).deliver
  end


  def pngizer_failure(params)
    @params = params

    return mail(:to => Settings.pngizer_failure_address,
      :subject => "pngizerd failure for #{params[:pid]}").deliver
  end


  def videoizer_failure(params)
    @params = params

    return mail(:to => Settings.videoizer_failure_address,
      :subject => "videoizerd failure for #{params[:pid]}").deliver
  end
end
