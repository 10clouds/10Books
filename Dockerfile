#
# Pull mix dependencies to have phoenix
# packages available for yarn install
################################################
FROM elixir:alpine as deps

RUN mkdir /app
WORKDIR /app

COPY mix.exs mix.lock ./

RUN MIX_ENV=prod mix do local.hex --force, deps.get

#
# Install yarn dependencies and build
# production js
################################################
FROM node:11.15.0-alpine as assets-build

RUN apk --no-cache add python make g++

RUN mkdir /app
WORKDIR /app

COPY assets/ ./assets
COPY --from=deps app/deps/ ./deps

RUN cd assets && yarn && yarn build

#
# Build distillery release
################################################
FROM elixir:alpine as release

RUN mkdir /app
WORKDIR /app

COPY --from=deps app/deps/ ./deps
COPY --from=assets-build app/priv/static/ ./priv/static
COPY . .

RUN MIX_ENV=prod mix do local.hex --force, \
                        local.rebar --force, \
                        phx.digest, \
                        distillery.release --verbose --no-tar

#
# RUN distillery release on minial alpine
################################################
FROM alpine

RUN apk add --no-cache ncurses-libs openssl bash

COPY --from=release /app/_build/prod/rel/lib_ten/ /app

ENV REPLACE_OS_VARS=true
ENV APP_NAME=lib_ten
ENV APP_VERSION=0.0.1
ENV PORT 80

VOLUME /app/uploads

ENTRYPOINT ["/app/bin/lib_ten"]
CMD ["foreground"]
