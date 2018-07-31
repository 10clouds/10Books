FROM elixir:1.6.5
RUN apt-get update && apt-get install -y yarn
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mkdir /app
WORKDIR /app
COPY mix.exs mix.lock /app/
RUN mix deps.get
RUN mix deps.compile
# Compile the app only when source code changes (ie. don't make config changes trigger a rebuild)
ADD lib /app/
RUN mix compile
ADD . /app