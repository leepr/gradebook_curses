require 'digest'

module DigestHelper
  def create_digest content
    Digest::SHA256.hexdigest "#{content}-#{Time.now}"
  end
end
