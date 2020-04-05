FROM ruby:2.6
LABEL maintainer="Armin Kirchner"

# Sources for Node and Yarn packages
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
      && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -  \
      && echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
         tee /etc/apt/sources.list.d/yarn.list \
      && apt-get update

# Common Rails requirements
RUN DEBCONF_NOWARNINGS=yes apt-get install -y -q --no-install-recommends \
        nodejs \
        yarn

ENV PORT=8080 \
    RAILS_ENV=production \
    RACK_ENV=production \
    NODE_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock /app/
RUN gem install bundler foreman
RUN bundle install --without development test \
      --jobs $(nproc) \
      --retry 2 \
      --deployment

COPY package.json yarn.lock Gemfile.lock /app/
RUN yarn install

COPY . /app/

RUN SECRET_KEY_BASE=dummy bundle exec rake assets:precompile

ENTRYPOINT ["/app/bin/entrypoint.sh"]
CMD ["foreman", "start"]
