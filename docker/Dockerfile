FROM java:8-jre

MAINTAINER HaenselAMS <inifo@haensel-ams.com>

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
RUN echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.4 main" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list

RUN apt-get update \
 && apt-get install -y curl build-essential bison openssl libreadline5 libreadline-dev git zlib1g zlib1g-dev libssl-dev libxslt-dev libxml2-dev libpq-dev subversion autoconf mongodb-org-shell mongodb-org-tools awscli vim htop

# Install RVM
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && curl -L https://get.rvm.io | bash -s stable
RUN ln -s /usr/local/rvm ~/.rvm
RUN /bin/bash -l -c "/etc/profile.d/rvm.sh && rvm requirements"
RUN /bin/bash -l -c "/etc/profile.d/rvm.sh && rvm install jruby-9.1.7.0 --default"
RUN /bin/bash -l -c "/etc/profile.d/rvm.sh && gem install bundler --no-ri --no-rdoc"

# Checkout Snowplow repo
WORKDIR /
RUN git clone https://github.com/haensel-ams/snowplow.git
WORKDIR /snowplow
RUN git checkout r88-hams

WORKDIR /snowplow/3-enrich/emr-etl-runner
RUN ./build.sh

RUN /bin/bash -l -c "source ~/.rvm/scripts/rvm && rvm install jruby-9.1.6.0 --default"

WORKDIR /mnt

#COPY entrypoint.sh /
#RUN chmod +x /entrypoint.sh

#ENTRYPOINT ["/entrypoint.sh"]
