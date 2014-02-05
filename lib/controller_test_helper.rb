# This monkey patch injects the locale in the controller's params
# Reason: ActionController::TestCase doesn't support "default_url_options"
#
# Example: when the request you are testing needs the locale, e.g.
#   get :show, :id => 1, :locale => 'en'
#
# if the monkey patch was loaded, you can just do:
#   get :show, :id => 1

class ActionController::TestCase
  module Behavior
    def process_with_default_locale(action, parameters = nil, session = nil, flash = nil, http_method = 'GET')
      parameters = { :locale => I18n.default_locale.to_s }.merge(parameters || {} )
      process_without_default_locale(action, parameters, session, flash, http_method)
    end
    alias_method_chain :process, :default_locale
  end
end

module ActionDispatch::Assertions::RoutingAssertions
  def assert_recognizes_with_default_locale(expected_options, path, extras = {}, message=nil)
    expected_options = { :locale => I18n.default_locale.to_s }.merge(expected_options || {} )
    assert_recognizes_without_default_locale(expected_options, path, extras, message)
  end
  alias_method_chain :assert_recognizes, :default_locale
end
