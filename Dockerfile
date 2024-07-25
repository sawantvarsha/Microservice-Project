# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Base stage for common dependencies
FROM python:3.10.8-slim@sha256:49749648f4426b31b20fca55ad854caa55ff59dc604f2f76b57d814e0a47c181 as base

# Builder stage to install additional packages and build dependencies
FROM base as builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget g++ \
    && rm -rf /var/lib/apt/lists/*

# Install grpc_health_probe
ENV GRPC_HEALTH_PROBE_VERSION=v0.4.18
RUN wget -qO /bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe

# Copy and install Python dependencies
WORKDIR /recommendationservice
COPY requirements.txt .
RUN pip install -r requirements.txt

# Final stage for the application
FROM base as final

# Enable unbuffered logging
ENV PYTHONUNBUFFERED=1

# Copy Python dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.10/ /usr/local/lib/python3.10/

# Copy application code
COPY . .

# Set listening port
ENV PORT=8080
EXPOSE 8080

# Entrypoint command to start the application
ENTRYPOINT ["python", "recommendation_server.py"]

# Copy grpc_health_probe binary from builder stage
COPY --from=builder /bin/grpc_health_probe /bin/grpc_health_probe
