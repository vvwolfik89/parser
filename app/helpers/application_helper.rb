module ApplicationHelper
  def custom_form_for(object, *args, &block)
    options = args.extract_options!
    simple_form_for(object, *(args << options.merge(builder: CustomFormBuilder)), &block)
  end

  def bootstrap3_form_options(options = {})
    {
      html: { class: "form-horizontal #{options[:html_class]}" }.merge(options[:html] || {}),
      # wrapper: options[:wrapper] || :horizontal_form,
      wrapper_mappings: {
        check_boxes: :horizontal_radio_and_checkboxes,
        radio_buttons: :horizontal_radio_and_checkboxes,
        file: :horizontal_file_input,
        boolean: :horizontal_boolean,
        ckeditor: :vertical_file_input
      }
    }
  end

  def paginate(objects, options = {})
    options.reverse_merge!(theme: 'twitter-bootstrap-4')

    super(objects, options)
  end
end
