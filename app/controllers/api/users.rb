module Api
  class Users < Grape::API
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers 
    resource :users do
      desc 'Ping'
      get 'ping' do
        { ping: 'pong' }
      end

      desc 'Return list of users'
      get '', Serializer: UserSerializer do
        User.all
      end

      desc 'Create a new user or find existing user'
      params do
        requires :ip_address, type: String
      end
      post 'connexion' do
        user = User.find_by(ip_address: params[:ip_address])
        if user
          QuoteSerializer.new(user.quotes.active.last)
        else
          user = User.create!(
            ip_address: params[:ip_address],
            token: SecureRandom.hex(10)
          )
          user.quotes.create!
        end
      end

      desc 'return a user given a token or ip_address'
      params do
        optional :token, type: String
        optional :ip_address, type: String
        at_least_one_of :token, :ip_address
      end
      get 'connexion' do
        if params[:token]
          user = User.find_by(token: params[:token])
        elsif params[:ip_address]
          user = User.find_by(ip_address: params[:ip_address])
        end
        if user
          Quoterializer.new(user.quotes.active.last)
        else
          error!('User not found', 404)
        end
      end
    end
  end
end
