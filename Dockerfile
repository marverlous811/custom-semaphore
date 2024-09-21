FROM python:3.10.12-slim-bullseye

ARG KUBESPRAY_VERSION=v2.25.0
ARG SEMAPHORE_VERSION=2.8.90
ARG ARCH=linux_amd64

# Set default environment variables 
ENV SEMAPHORE_DB_USER=semaphore
ENV SEMAPHORE_DB_PASS=semaphore
ENV SEMAPHORE_DB_HOST=postgres
ENV SEMAPHORE_DB_PORT=5432
ENV SEMAPHORE_DB_DIALECT=postgres
ENV SEMAPHORE_DB=semaphore
ENV SEMAPHORE_PLAYBOOK_PATH=/tmp/semaphore/
ENV SEMAPHORE_ADMIN_PASSWORD=changeme
ENV SEMAPHORE_ADMIN_NAME=admin
ENV SEMAPHORE_ADMIN_EMAIL=admin@localhost
ENV SEMAPHORE_ADMIN=admin
ENV SEMAPHORE_ACCESS_KEY_ENCRYPTION=gs72mPntFATGJs9qK0pQ0rKtfidlexiMjYCH9gWKhTU=

RUN apt-get -y update && apt-get -y install git wget gettext
RUN git clone -b $KUBESPRAY_VERSION --single-branch --depth 1 https://github.com/kubernetes-sigs/kubespray /tmp/kubespray
RUN cd /tmp/kubespray && pip install -U -r requirements.txt

RUN cd /tmp && wget https://github.com/ansible-semaphore/semaphore/releases/download/v${SEMAPHORE_VERSION}/semaphore_${SEMAPHORE_VERSION}_${ARCH}.deb
RUN dpkg -i /tmp/semaphore_${SEMAPHORE_VERSION}_${ARCH}.deb

COPY config_template.json /semaphore/config_template.json
COPY entrypoint.sh /semaphore/entrypoint.sh
RUN chmod +x /semaphore/entrypoint.sh

RUN rm -rf /tmp/kubespray && rm -rf /tmp/semaphore_2.8.90_linux_amd64.deb
ENTRYPOINT ["/semaphore/entrypoint.sh"]