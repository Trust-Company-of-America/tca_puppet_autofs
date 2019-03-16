FROM ruby:2.5

WORKDIR /opt/puppet

# https://github.com/puppetlabs/puppet/blob/06ad255754a38f22fb3a22c7c4f1e2ce453d01cb/lib/puppet/provider/service/runit.rb#L39
RUN mkdir -p /etc/sv

ARG PUPPET_VERSION="~> 6.0"
ARG PARALLEL_TEST_PROCESSORS=4

# Cache gems
COPY Gemfile .
RUN bundle install --without system_tests development release --path=${BUNDLE_PATH:-vendor/bundle}

COPY . .

RUN bundle install
RUN bundle exec rake test_with_coveralls

# Container should not saved
RUN exit 1
