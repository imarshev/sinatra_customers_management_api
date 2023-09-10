module ResponseHelper
  def object_attributes(object)
    hash = object.attributes.compact
    object.valid? ? hash[:url] = "#{ENV['HOST']}/customers/#{object.id}" : hash[:errors] = object.errors.full_messages
    hash
  end

  def post_bulk_customers(body)
    customers = body.map { |hash| Customer.create(permitted_params(hash)) }

    return { status: 409, body: { failed: customers.map { |c| object_attributes(c) } } } unless customers.any?(&:valid?)

    {
      status: 201,
      body: {
        created: customers.select(&:valid?).map { |c| object_attributes(c) },
        failed: customers.select(&:invalid?).map { |c| object_attributes(c) }
      }
    }
  end
end
