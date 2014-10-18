class Goal < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :motivations

  accepts_nested_attributes_for :motivations

  validates :title, :user, :category, presence: true
  delegate :name, to: :user, prefix: true

  scope :available_for_all, -> { where(shared: true).where(approved: true) }


  def motivations_attributes=(attrs)
    not_empty_attrs = Hash[attrs.find_all{|k,v| (v[:source] + v[:title]).present?}]
    super(not_empty_attrs)
  end
end
