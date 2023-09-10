FROM ruby:3.2.2
WORKDIR /usr/src/app
COPY . .
RUN gem install bundler && bundle install
EXPOSE 4567
CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "4567"]
