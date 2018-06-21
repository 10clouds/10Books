FROM elixir:alpine as deps

RUN mkdir /app
WORKDIR /app

COPY mix.exs mix.lock ./

RUN mix local.hex --force
RUN MIX_ENV=prod mix deps.get


################################################
FROM node:alpine as assets-build

RUN mkdir /app
WORKDIR /app

COPY assets/ ./assets
COPY --from=deps app/deps/ ./deps

RUN cd assets && yarn && yarn build


################################################
FROM elixir:alpine as release

RUN mkdir /app
WORKDIR /app

COPY --from=deps app/deps/ ./deps
COPY --from=assets-build app/priv/static/ ./priv/static
COPY . .

RUN mix do local.hex --force, local.rebar --force
RUN MIX_ENV=prod mix do phx.digest, release --verbose --no-tar


################################################
FROM alpine as server

RUN apk add --no-cache ncurses-libs openssl bash

COPY --from=release /app/_build/prod/rel/lib_ten/ /app

ENV REPLACE_OS_VARS=true
ENV APP_NAME=lib_ten
ENV APP_VERSION=0.0.1
ENV PORT=4000
