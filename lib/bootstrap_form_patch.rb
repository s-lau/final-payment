module BootstrapForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    # compatibility with HAML???
    # just remove .html_safe after block.call
    def control_group(label_name, label_options = {}, errors = [], &block)
      content_tag :div, class: "control-group#{(' error' if errors.present?)}"  do
        label_options[:class] = 'control-label'
        content_tag(:label, label_name, label_options).html_safe +
        content_tag(:div, class: 'controls') do
          block.call#.html_safe
        end
      end
    end
    def price_field(name, *args)
      options = args.extract_options!.symbolize_keys!
      errors = @object.errors[name].any? ? @object.errors[name].join(', ') : ''
      control_group label(name), {}, errors do
        input = content_tag :div, :class => 'input-append' do
          ActionView::Helpers::FormBuilder.new(@object_name, @object, @template, @options, @proc).text_field(name) +
          content_tag(:span, @object.send(:"currency_for_#{name}").html_entity.html_safe, class: 'add-on')
        end
        input + errors
      end
    end
  end
end
