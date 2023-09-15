#!/bin/bash
envsubst '$REMOTE_WRITE_URL' < /etc/agent/agent.template.yaml > /etc/agent/agent.yaml
grafana-agent --config.file=/etc/agent/agent.yaml --metrics.wal-directory=/etc/agent/data