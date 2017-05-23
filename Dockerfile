FROM kalilinux/kali-linux-docker

RUN apt-get update

RUN apt-get update && apt-get install -y \
	ruby2.3-dev \
	sudo \
	postgresql-9.6 \
	libpq-dev \
	git \
	build-essential \
	zlib1g-dev
RUN gem update --system

RUN mkdir /opt/gitrob
RUN git clone https://github.com/michenriksen/gitrob /opt/gitrob
RUN gem install gitrob

EXPOSE 8000

ENTRYPOINT ["/bin/bash"]
