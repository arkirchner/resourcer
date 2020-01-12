module FormHelper
  def form_input_class(instance, field)
    return "form-control" unless instance.validated?
    return "form-control is-invalid" if instance.errors[field].any?
    "form-control is-valid"
  end

  def form_input_errors(instance, field)
    errors = instance.errors[field]
    return unless errors.any?

    tag.div class: "invalid-feedback" do
      errors.each do |error|
        concat error
        concat tag.br
      end
    end
  end
end
