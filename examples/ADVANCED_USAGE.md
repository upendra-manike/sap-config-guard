# 🚀 Advanced Usage Examples

This guide shows advanced usage patterns for `sap-config-guard`.

## Custom Schema Validation

Create a custom schema file for your specific requirements:

```yaml
# custom-schema.yaml
required:
  - SAP_CLIENT
  - SAP_API_URL
  - CUSTOM_PARAM

patterns:
  SAP_CLIENT: "^[0-9]{3}$"
  CUSTOM_PARAM: "^[A-Z]+$"

forbidden_in_prod:
  - localhost
  - test
```

Use it:

```bash
sap-config-guard validate ./config/prod --schema ./custom-schema.yaml
```

## Multiple File Formats

`sap-config-guard` supports multiple file formats. Examples are provided:

### .env Format
```bash
sap-config-guard validate examples/config/dev/.env
```

### JSON Format
```bash
sap-config-guard validate examples/config/dev/config.json
```

### YAML Format
```bash
sap-config-guard validate examples/config/dev/config.yaml
```

### Properties Format
```bash
sap-config-guard validate examples/config/dev/config.properties
```

## Directory Loading

Load all config files from a directory:

```bash
# Loads .env, config.properties, config.yaml, config.json
sap-config-guard validate examples/config/dev/
```

## Python API Usage

### Basic Validation

```python
from sap_config_guard import validate
from pathlib import Path

results, is_valid = validate(
    config_path="./config/prod",
    environment="prod",
    fail_on_warning=True
)

if not is_valid:
    for result in results:
        print(f"{result.level.value}: {result.message}")
    exit(1)
```

### Custom Schema

```python
from sap_config_guard.core.validator import ConfigValidator
from sap_config_guard.core.schema import ConfigSchema
from pathlib import Path

# Load custom schema
schema = ConfigSchema(Path("./custom-schema.yaml"))
validator = ConfigValidator(schema=schema)

results, is_valid = validator.validate(
    config_path=Path("./config/prod"),
    environment="prod"
)
```

### Environment Comparison

```python
from sap_config_guard import compare_environments

diff_results = compare_environments({
    "dev": "./config/dev",
    "qa": "./config/qa",
    "prod": "./config/prod"
})

for diff in diff_results:
    if diff.status == "different":
        print(f"⚠️  {diff.key} differs: {diff.environments}")
    elif diff.status == "missing":
        print(f"❌ {diff.key} missing in: {diff.message}")
```

## CI/CD Integration Patterns

### Pre-commit Hook

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash
sap-config-guard validate ./config/dev --environment dev
if [ $? -ne 0 ]; then
    echo "❌ Configuration validation failed"
    exit 1
fi
```

### GitHub Actions Workflow

```yaml
name: Validate Configs

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: '3.10'
      - run: pip install sap-config-guard
      - name: Validate Dev
        run: sap-config-guard validate ./config/dev
      - name: Validate QA
        run: sap-config-guard validate ./config/qa --environment qa
      - name: Validate Prod
        run: sap-config-guard validate ./config/prod --environment prod --fail-on-warning
      - name: Check Drift
        run: |
          sap-config-guard diff \
            dev=./config/dev \
            qa=./config/qa \
            prod=./config/prod \
            --fail-on-drift
```

### Jenkins Pipeline

```groovy
pipeline {
    agent any
    
    stages {
        stage('Validate Configs') {
            steps {
                sh '''
                    pip install sap-config-guard
                    sap-config-guard validate ./config/dev
                    sap-config-guard validate ./config/prod --environment prod --fail-on-warning
                '''
            }
        }
        
        stage('Check Drift') {
            steps {
                sh '''
                    sap-config-guard diff \
                      dev=./config/dev \
                      qa=./config/qa \
                      prod=./config/prod \
                      --fail-on-drift
                '''
            }
        }
    }
}
```

## Docker Usage

### Single Command

```bash
docker run --rm \
  -v $(pwd)/config:/app/configs:ro \
  sap-config-guard:latest \
  validate /app/configs/prod --environment prod
```

### Docker Compose

```yaml
version: '3.8'
services:
  validate:
    image: sap-config-guard:latest
    volumes:
      - ./config:/app/configs:ro
    command: validate /app/configs/prod --environment prod --fail-on-warning
```

## Filtering Results

### Show Only Errors

```python
from sap_config_guard import validate
from sap_config_guard.core.validator import ValidationLevel

results, is_valid = validate("./config/prod", environment="prod")

errors = [r for r in results if r.level == ValidationLevel.ERROR]
for error in errors:
    print(error)
```

### Show Only Warnings

```python
warnings = [r for r in results if r.level == ValidationLevel.WARNING]
for warning in warnings:
    print(warning)
```

## Programmatic Schema Creation

```python
from sap_config_guard.core.schema import ConfigSchema
from sap_config_guard.core.validator import ConfigValidator

# Create schema programmatically
schema_dict = {
    'required': ['MY_PARAM'],
    'patterns': {'MY_PARAM': r'^[A-Z]+$'},
    'forbidden_in_prod': ['test']
}

# Note: ConfigSchema expects a YAML file, but you can create a temporary one
import yaml
import tempfile
from pathlib import Path

with tempfile.NamedTemporaryFile(mode='w', suffix='.yaml', delete=False) as f:
    yaml.dump(schema_dict, f)
    schema_path = Path(f.name)

schema = ConfigSchema(schema_path)
validator = ConfigValidator(schema=schema)
```

## Batch Processing

```python
from pathlib import Path
from sap_config_guard import validate

config_dirs = [
    "./config/dev",
    "./config/qa",
    "./config/prod"
]

all_valid = True
for config_dir in config_dirs:
    results, is_valid = validate(config_dir)
    if not is_valid:
        print(f"❌ {config_dir} failed validation")
        all_valid = False
    else:
        print(f"✅ {config_dir} is valid")

if not all_valid:
    exit(1)
```

---

For more examples, see the [examples/](examples/) directory.

