class Goal < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  has_many :motivations
  has_many :goal_in_lists
  has_many :goal_lists, through: :goal_in_lists

  accepts_nested_attributes_for :motivations

  validates :title, :user, :category, :motivations, presence: true
  delegate :name, to: :user, prefix: true

  scope :available_for_all, -> { where(shared: true).where(approved: true) }

  delegate :name, to: :category, prefix: true
  delegate :name, to: :user, prefix: true


  def motivations_attributes=(attrs)
    not_empty_attrs = Hash[attrs.find_all{|k,v| (v[:source] + v[:title]).present?}]
    super(not_empty_attrs)
  end

  def share!
    update_attribute(:shared, true)
  end
end
