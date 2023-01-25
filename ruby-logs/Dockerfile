FROM cimg/ruby:2.7.5-node

USER root
WORKDIR /app

COPY Gemfile* ./
RUN bundle install --without development test --deployment --quiet

# Copy the main application.
COPY . ./
RUN bundle install --without development test --deployment --quiet
RUN chmod 777 ./docker-entrypoint.sh
RUN chmod 777 ./run.sh

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["/app/run.sh"]
