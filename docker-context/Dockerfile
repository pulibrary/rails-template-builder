#-----------------------------------------
# First steps just provide us with
# something like a local dev environment.
#----------------------------------------- 

FROM debian:bookworm-slim AS build-stage

# Keep update and install in the same RUN so if there are additional installs,
# they won't be based on a stale layer.
RUN apt-get update && \
    apt-get install -y \
      make gcc git \
      ruby-dev nodejs yarnpkg

# This is the directory that will be copied: Everything goes in here.
RUN mkdir rails-template
WORKDIR rails-template

# Running asdf inside docker is awkward. For example, see: https://stackoverflow.com/a/73999702
# Instead, we just capture the versions used and build .tool-versions.
RUN ruby --version | ruby -pe 'gsub(/(ruby \d+\.\d+\.\d+).*/, "\\1")' > .tool-versions && \
    node --version | ruby -pe 'gsub("v", "nodejs ")' >> .tool-versions && \
    yarnpkg --version | ruby -pe 'gsub(/^/, "yarn ")' >> .tool-versions

#-------------------------------------
# Steps below recapitulate what would
# be done in a local dev environment.
#-------------------------------------

RUN gem install bundler

RUN bundle init
RUN bundle add rails
RUN bundle exec rails new .

RUN bundle add rspec
# RUN bundle exec rspec init

# Keep Rubocop auto-correct at the end the build,
# so that everything added earlier can be cleaned up. 
COPY .rubocop.yml .
RUN bundle add bixby
RUN bundle exec rubocop --auto-correct-all --disable-uncorrectable 

#--------------------------------------------------
# At the end, we export only the rails directory:
# None of the other usual root directories
# (bin, var, tmp, etc, dev, etc.) are included.
#--------------------------------------------------

FROM scratch AS export-stage
COPY --from=build-stage /rails-template /
