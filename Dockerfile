FROM ruby:2.7-alpine
LABEL maintainer="Armin Kirchner"

# Common Rails requirements
RUN apk add --no-cache \
    nodejs-current \
    nodejs-npm \
    yarn \
    gcompat \
    libpq \
    tzdata \
    imagemagick \
    diffutils \
    && rm -rf /usr/share/man /tmp/* /var/cache/apk/*

ENV PORT=8080 \
    RAILS_ENV=production \
    RACK_ENV=production \
    NODE_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true

RUN mkdir -p /app /app/tmp
WORKDIR /app

COPY Gemfile Gemfile.lock package.json yarn.lock /app/
RUN set -x \
    && apk add --no-cache --virtual build-dependencies \
         python2 \
         build-base \
         postgresql-dev \
    && gem install bundler foreman \
    && bundle install --without development test \
         --jobs $(nproc) \
         --retry 2 \
         --deployment \
    && yarn install \
    && apk del build-dependencies \
         python2 \
         build-base \
         postgresql-dev \
    && rm -rf /usr/share/man /tmp/* /var/cache/apk/*

EXPOSE 8080
COPY . /app/
RUN SECRET_KEY_BASE=dummy bundle exec rake assets:precompile
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
