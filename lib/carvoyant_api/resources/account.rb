module CarvoyantAPI
  class AccountJsonFormatter
    include ActiveResource::Formats::JsonFormat

    def decode(json)
      ActiveSupport::JSON.decode(json)["account"]
    end
  end

  class Account < Base
    self.format = AccountJsonFormatter.new
    self.primary_key = :id

    schema do
      integer "id"
      string "firstName", "lastName", "username", "dateCreated", "email", "zipcode", "phone", "timeZone", "preferredContact", "accessToken"
    end
  end
end