module ApplicationHelper
  # Make your life easier,
  # define the CSRF auth token in a helper
  # and put it in all the forms!
  def authenticity_token
    "<input
        type=\"hidden\"
        name=\"authenticity_token\"
        value=\"#{ form_authenticity_token }\">".html_safe
  end
end
