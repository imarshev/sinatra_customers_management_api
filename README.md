# sinatra_customers_management_api
This project is an API for managing a customer database. It has been developed using Ruby Sinatra and PostgreSQL

## Features
* API Key Authentication.
* Creating new customers through a JSON API.
* Viewing customer details by ID.
* Paginated listing of customers with the ability to specify the number of items per page.
## Technologies
* Ruby
* Sinatra
* PostgreSQL
* Docker
## Installation
### Clone the repository to your local machine:
```
git clone https://github.com/imarshev/sinatra_customers_management_api.git
cd sinatra_customers_management_api
```
## Running the Application

### Running the Application Locally (without Docker)

1. Install all necessary gems:
```
bundle install
```
2. Set up a .env file with the appropriate values derived from .env.example
3. Create database:
```
bundle exec rake db:create
```
4. Run the database migration:
```
bundle exec rake db:migrate
```
5. Run the app:
```
bundle exec rackup -o 0.0.0.0 -p 4567
```

### Running the Application using Docker
1. Install Docker and Docker Compose. Ruby should be installed on your machine.
2. Build and run the application using Docker Compose:
```
docker-compose up --build
```

The application will be accessible at http://localhost:4567.

## Working with the API
Use an HTTP client such as curl or Postman to interact with the API.

## Request Examples:
Create new customers:
```
curl -X POST -H "Content-Type: application/json" -H "API_KEY: your_api_key" -d '[{"name": "John Doe", "email": "john.doe@example.com"}, {"name": "Jane Doe", "email": "jane.doe@example.com"}]' http://localhost:4567/customers/new
```
Get a list of all customers:
```
curl -X GET -H "API_KEY: your_api_key" http://localhost:4567/customers
```

Get customer information by ID:
```
curl -X GET -H "API_KEY: your_api_key" http://localhost:4567/customers/1
```



