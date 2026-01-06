# 🐳 Docker Usage Guide

`sap-config-guard` is available as a Docker image for easy deployment in CI/CD pipelines and containerized environments.

## Quick Start

### Pull the Image

```bash
docker pull sap-config-guard:latest
```

### Run Validation

```bash
# Validate a configuration directory
docker run --rm -v $(pwd)/config:/app/configs:ro sap-config-guard:latest validate /app/configs/prod

# With custom schema
docker run --rm \
  -v $(pwd)/config:/app/configs:ro \
  -v $(pwd)/schema.yaml:/app/schema.yaml:ro \
  sap-config-guard:latest validate /app/configs/prod --schema /app/schema.yaml
```

### Compare Environments

```bash
docker run --rm \
  -v $(pwd)/config:/app/configs:ro \
  sap-config-guard:latest diff \
    dev=/app/configs/dev \
    qa=/app/configs/qa \
    prod=/app/configs/prod
```

## Build from Source

### Build the Image

```bash
# Build locally
docker build -t sap-config-guard:latest .

# Build with specific tag
docker build -t sap-config-guard:v0.1.0 .
```

### Test the Build

```bash
# Test the CLI
docker run --rm sap-config-guard:latest --help

# Test with example configs
docker run --rm \
  -v $(pwd)/examples/config:/app/configs:ro \
  sap-config-guard:latest validate /app/configs/dev
```

## Docker Compose

Use `docker-compose.yml` for easier development:

```bash
# Build and start
docker-compose build
docker-compose up

# Run specific command
docker-compose run --rm sap-config-guard validate /app/configs/dev

# Compare environments
docker-compose run --rm sap-config-guard diff \
  dev=/app/configs/dev \
  qa=/app/configs/qa \
  prod=/app/configs/prod
```

## CI/CD Integration

### GitHub Actions

```yaml
- name: Validate SAP Config
  run: |
    docker run --rm \
      -v ${{ github.workspace }}/config:/app/configs:ro \
      sap-config-guard:latest \
      validate /app/configs/prod --environment prod --fail-on-warning
```

### Jenkins

```groovy
stage('Validate Config') {
    steps {
        sh '''
            docker run --rm \
              -v ${WORKSPACE}/config:/app/configs:ro \
              sap-config-guard:latest \
              validate /app/configs/prod --environment prod --fail-on-warning
        '''
    }
}
```

### GitLab CI

```yaml
validate-config:
  image: sap-config-guard:latest
  script:
    - sap-config-guard validate ./config/prod --environment prod --fail-on-warning
```

## Volume Mounts

The Docker image expects configuration files to be mounted as volumes:

```bash
# Single config directory
-v $(pwd)/config:/app/configs:ro

# Multiple directories
-v $(pwd)/config/dev:/app/configs/dev:ro
-v $(pwd)/config/qa:/app/configs/qa:ro
-v $(pwd)/config/prod:/app/configs/prod:ro

# With custom schema
-v $(pwd)/schema.yaml:/app/schema.yaml:ro
```

## Security

The Docker image runs as a non-root user (`sapguard`, UID 1000) for security.

## Image Size

The image is based on `python:3.11-slim` and uses multi-stage builds to minimize size (~100MB).

## Troubleshooting

### Permission Issues

If you encounter permission issues with mounted volumes:

```bash
# Check file permissions
ls -la config/

# Fix permissions if needed
chmod -R 644 config/**/*
```

### Path Issues

Always use absolute paths inside the container:

```bash
# ✅ Correct
docker run --rm -v $(pwd)/config:/app/configs:ro sap-config-guard:latest validate /app/configs/prod

# ❌ Wrong
docker run --rm -v $(pwd)/config:/app/configs:ro sap-config-guard:latest validate ./configs/prod
```

---

For more information, see the main [README.md](README.md).

