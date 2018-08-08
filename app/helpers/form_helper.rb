# frozen_string_literal: true

module FormHelper
  def form_group_for(form, field, opts = {}, &block)
    label = opts.fetch(:label) { true }
    has_errors = form.object.errors[field].present?

    content_tag :div, class: "form-group #{'has-error' if has_errors}" do
      concat form.label(field, class: 'control-label') if label
      concat capture(&block)
      if has_errors
        form.object.errors[field].each do |x|
          concat content_tag(:p, x.to_s, class: 'help-block')
        end
      end
    end
  end
end
