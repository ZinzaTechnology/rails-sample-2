class ValidEmailValidator < ActiveModel::EachValidator
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  def validate_each(record, attribute, value)
    record.errors.add(attribute, "is invalid.") if value.present? && !VALID_EMAIL_REGEX.match?(value)
  end
end
