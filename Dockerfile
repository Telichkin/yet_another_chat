FROM elixir:latest

ENV MIX_ENV prod
ENV CHAT /opt/app
ENV ASSETS ${CHAT}/assets

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

WORKDIR ${CHAT}

RUN mix local.hex --force
RUN mix local.rebar --force

COPY mix.* ./

RUN mix deps.get --only prod
RUN mix deps.compile

COPY . .
RUN mix compile

WORKDIR ${ASSETS}

RUN npm install
RUN npm run deploy

WORKDIR ${CHAT}

RUN mix phx.digest
