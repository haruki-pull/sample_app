class User < ApplicationRecord
    before_save { self.email = email.downcase }
    #存在性のvalidation
    validates :name, presence: true
    validates :email, presence: true
    #長さのvalidation
    validates :name,  presence: true, length: { maximum: 50 }
    #VALID～は大文字なので定数扱い
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }
end
