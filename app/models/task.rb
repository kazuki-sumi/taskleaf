class Task < ApplicationRecord
  validates :name, presence: true, length: {maximum: 30}
  validate :validate_name_not_including_comma

  belongs_to :user
  
  scope :recent, -> {order(created_at: :desc)}
  
  private
  
  def validate_name_not_including_comma
    # 後置if文
    # addメソッド：特定の属性(オブジェクトの持つデータ)に関連するエラーメッセージを手動で追加できる。属性とエラーメッセージを引数とする
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end

end
