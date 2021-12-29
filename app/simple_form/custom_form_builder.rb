class CustomFormBuilder < SimpleForm::FormBuilder
  include Rails.application.routes.url_helpers
  include ActionView::Context
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::FormTagHelper


end