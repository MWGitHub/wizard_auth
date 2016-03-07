# == Schema Information
#
# Table name: wizards
#
#  id         :integer          not null, primary key
#  username   :string(255)      not null, unique
#  instructor :boolean          not null, default false
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Wizard < ActiveRecord::Base
  validates(
    :username, :password_digest, :session_token, presence: true
  )
  validates :username, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }

  attr_reader :password

  has_many(
    :taught_courses,
    class_name: "Course",
    foreign_key: :instructor_id,
    primary_key: :id
  )

  has_many(
    :enrollments,
    class_name: "Enrollment",
    foreign_key: :student_id,
    primary_key: :id
  )

  after_initialize :ensure_session_token

  def self.find_by_credentials(username, password)
    wizard = Wizard.find_by(username: username)
    return nil unless wizard && wizard.valid_password?(password)
    wizard
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def valid_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_token!
    self.session_token = SecureRandom.urlsafe_base64(16)
    self.save!
    self.session_token
  end

  private
  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end
end
