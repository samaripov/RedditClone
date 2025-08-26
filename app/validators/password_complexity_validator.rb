class PasswordComplexityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    record.errors.add(attribute, "Must contain at least one lowercase letter") unless value.match?(/[a-z]/)
    record.errors.add(attribute, "Must contain at least one uppercase letter") unless value.match?(/[A-Z]/)
    record.errors.add(attribute, "Must contain at least one digit") unless value.match?(/[0-9]/)
    record.errors.add(attribute, "Must contain at least one special character") unless value.match?(/[!@#$%^&*()_+\-=]/)
  end
end
