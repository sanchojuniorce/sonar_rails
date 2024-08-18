# Use a imagem oficial do Ruby como base
FROM ruby:3.2.2

# Instale dependências do sistema
RUN apt-get update -qq && apt-get install -y nodejs sqlite3

RUN apt-get install -y nodejs npm
RUN npm install -g sonarqube-scanner


# Defina o diretório de trabalho
WORKDIR /myapp

# Copie o Gemfile e o Gemfile.lock para o diretório de trabalho
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# Instale as gems
RUN gem install bundler -v 2.5.5 && bundle install

# Copie o restante do código da aplicação
COPY . /myapp

# Comando para iniciar o servidor Rails
CMD ["rails", "server", "-b", "0.0.0.0"]