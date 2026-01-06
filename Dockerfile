# Multi-stage build for sap-config-guard
FROM python:3.11-slim as builder

WORKDIR /build

# Install build dependencies
RUN pip install --no-cache-dir build

# Copy project files
COPY . .

# Build the package
RUN python -m build

# Final stage
FROM python:3.11-slim

LABEL maintainer="SAP Community"
LABEL description="sap-config-guard: Fail-fast configuration validation & environment drift detection for SAP landscapes"

WORKDIR /app

# Install the package from builder
COPY --from=builder /build/dist/*.whl /tmp/
RUN pip install --no-cache-dir /tmp/*.whl && rm -rf /tmp/*.whl

# Create a non-root user
RUN useradd -m -u 1000 sapguard && chown -R sapguard:sapguard /app
USER sapguard

# Set entrypoint
ENTRYPOINT ["sap-config-guard"]
CMD ["--help"]

