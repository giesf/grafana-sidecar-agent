FROM ubuntu:22.04
WORKDIR /tmp/grafana
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && apt-get install -y curl \
  && apt-get install -y unzip \
  && apt-get install -y gettext \
  && apt-get install -y ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN curl -LJO https://github.com/grafana/agent/releases/download/v0.36.1/grafana-agent-linux-amd64.zip
RUN unzip grafana-agent-linux-amd64.zip
RUN mv grafana-agent-linux-amd64 /bin/grafana-agent
RUN chmod +x /bin/grafana-agent
RUN useradd -ms /bin/bash grafana
RUN mkdir -p /etc/agent/
RUN mkdir -p /etc/agent-template/
RUN chown grafana -R /etc/agent/

USER grafana

COPY --chown=grafana:grafana agent.yaml /etc/agent/agent.template.yaml
COPY --chown=grafana:grafana run.sh /app/agent/run.sh

ENTRYPOINT [ "/app/agent/run.sh" ]
CMD ["/bin/grafana-agent","--config.file=/etc/agent/agent.yaml", "--metrics.wal-directory=/etc/agent/data"]
