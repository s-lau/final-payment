module BootstrapForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    # compatibility with HAML???
    # just remove .html_safe after block.call
    def control_group(label_name, label_options = {}, &block)
      content_tag :div, class: "control-group"  do
        label_options[:class] = 'control-label'
        content_tag(:label, label_name, label_options).html_safe +
        content_tag(:div, class: 'controls') do
          block.call#.html_safe
        end
      end
    end
  end
end
