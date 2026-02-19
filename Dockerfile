FROM ruby:3.3

LABEL author="Steve Kenworthy"

ENV HOME /home/app
ENV RAILS_ENV development
ENV RAILS_LOG_TO_STDOUT true
# Use sqlite adapter (no external DB needed)
ENV DB sqlite

RUN mkdir -p $HOME

WORKDIR $HOME

RUN apt-get update && \
    apt-get install -y imagemagick tzdata libsqlite3-dev && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

ADD . $HOME

# Use SQLite database config
RUN cp config/database.sqlite.yml config/database.yml

RUN gem install bundler && \
    bundle config set --local deployment 'true' && \
    bundle install


# Entrypoint: init DB on first run, then start server
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["entrypoint.sh"]
