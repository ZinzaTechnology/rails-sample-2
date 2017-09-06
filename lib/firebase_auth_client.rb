require "google/apis/identitytoolkit_v3"
require "googleauth"

class FirebaseAuthClient
  def initialize
    @service = Google::Apis::IdentitytoolkitV3::IdentityToolkitService.new
    firebase_admin_key = JSON.parse Base64.strict_decode64(ENV["FIRESTORE_CREDENTIALS"])

    # create file admin credentials
    file_admin_path = "tmp/#{SecureRandom.hex(16)}.json"
    File.open(file_admin_path, "w+") { |f| f.write(firebase_admin_key.to_json) }
    file = File.open(file_admin_path)

    @service.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: file,
      scope: [
        "https://www.googleapis.com/auth/identitytoolkit"
      ].join(" ")
    )

    # close and delete file admin
    file.close
    File.delete(file_admin_path)
  end

  def get_user(uid:)
    get_account_info(local_id: [uid])&.users&.first
  end

  def update_user(uid:, params:)
    update_params = { local_id: uid }.merge(params)
    request = Google::Apis::IdentitytoolkitV3::SetAccountInfoRequest.new(update_params)
    @service.set_account_info(request)
  end

  def get_account_info(params)
    request = Google::Apis::IdentitytoolkitV3::GetAccountInfoRequest.new(params)
    @service.get_account_info(request)
  end
end
