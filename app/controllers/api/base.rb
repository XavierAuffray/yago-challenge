module Api
  class Base < Grape::API
    mount Api::Users
    mount Api::Quotes
    mount Api::Advices
  end
end