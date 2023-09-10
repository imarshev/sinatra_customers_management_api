require 'bundler'
Bundler.require

require './models/customer'
require_relative './helpers/request_helper'
require_relative './helpers/response_helper'

Dotenv.load

class MyApp < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  include Pagy::Backend
  helpers RequestHelper
  helpers ResponseHelper

  configure do
    db_options = {
      adapter: 'postgresql', host: ENV['DB_HOST'], database: ENV['DB_NAME'],
      user: ENV['DB_USER'], password: ENV['DB_PASS']
    }

    set :database, db_options
  end

  before do
    content_type :json
    halt 401 unless request.env['HTTP_API_KEY'] == ENV['API_KEY']
  end

  not_found do
    content_type :json
    { error: 'Resource not found' }.to_json
  end

  post '/customers/new' do
    @body = parse_request_body(request.body.read)
    halt 400, { error: 'Bad request. Should be an array' }.to_json unless @body.is_a?(Array)
    result = post_bulk_customers(@body)
    halt result[:status], result[:body].to_json
  end

  get '/customers' do
    per_page = (params[:per_page] || Pagy::DEFAULT[:items]).to_i
    pagy = Pagy.new(count: Customer.count, items: per_page)

    begin
      pagy, customers = pagy(Customer.all, items: per_page, page: params[:page] || 1)
      { total_pages: pagy.pages, current_page: pagy.page, customers: }.to_json
    rescue Pagy::OverflowError, Pagy::VariableError
      halt 400, { error: 'Page not found', min_page: 1, max_page: pagy.pages }.to_json
    end
  end

  get '/customers/:id' do
    customer = Customer.find_by(id: params[:id])
    customer ? customer.to_json : (halt 404, { error: 'Customer not found' }.to_json)
  end
  run! if app_file == $PROGRAM_NAME
end
