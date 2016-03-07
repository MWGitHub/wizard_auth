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
