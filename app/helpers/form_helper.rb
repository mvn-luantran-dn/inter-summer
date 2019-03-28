module FormHelper
  def form_group_for(class_name, form, field, opts = {}, &block)
    label = opts.fetch(:label) { true }
    has_errors = form.object.errors[field].present?

    content_tag :div, class: "form-group #{class_name} #{'has-error' if has_errors}" do
      concat form.label(field, class: 'control-label') if label
      concat capture(&block)
      if has_errors
        error = form.object.errors[field].first
        concat content_tag(:span, error.to_s, class: 'help-block')
      end
    end
  end
end
