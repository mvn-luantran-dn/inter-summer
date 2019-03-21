module Admin::BaseHelper
  def link_to_add_fields(name, f, association, _opts = {})
    # creaate a new object given the form object, and the association name
    new_object = f.object.class.reflect_on_association(association).klass.new

    # call the fields_for function and render the fields_for to a string
    # child index is set to "new_#{association}, which would then later
    # be replaced in in javascript function add_fields
    fields = f.fields_for(association,
                          new_object,
                          child_index: "new_#{association}") do |builder|
      # render partial: _task_fields.html.erb
      render(association.to_s.singularize + '_fields', f: builder)
    end

    # call link_to_function to transform to a HTML link
    # clicking this link will then trigger add_fields javascript function
    link_to_function(name,
                     h("add_fields(this,
                       \"#{association}\", \"#{escape_javascript(fields)}\");return false;"),
                     class: 'btn btn-primary add cat-pro')
  end

  def link_to_function(name, js, opts = {})
    link_to name, '#', opts.merge(onclick: js)
  end

  def errors_for(form, field)
    content_tag(:p, form.object.errors[field].try(:first), class: 'help-block')
  end
end
