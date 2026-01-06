# 🚀 Quick Start Guide

Get `sap-config-guard` up and running in 5 minutes!

## Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/sap-config-guard.git
cd sap-config-guard

# Install in development mode
pip install -e .
```

## First Validation

```bash
# Validate the example dev configuration
sap-config-guard validate examples/config/dev
```

You should see warnings about:
- HTTP (instead of HTTPS) - OK for dev
- Missing secure keys - OK for dev

## Compare Environments

```bash
# Compare all example environments
sap-config-guard diff dev=examples/config/dev qa=examples/config/qa prod=examples/config/prod
```

This shows all configuration differences between environments.

## Validate Production (Strict)

```bash
# This will fail because dev config has localhost
sap-config-guard validate examples/config/dev --environment prod --fail-on-warning
```

## Use in Your Project

1. Create your config files (`.env`, `.properties`, `.yaml`, or `.json`)
2. Optionally create a custom `schema.yaml` for your rules
3. Run validation in your CI/CD pipeline

```bash
sap-config-guard validate ./config/prod --environment prod --fail-on-warning
```

## Next Steps

- Read the full [README.md](README.md) for detailed documentation
- Check [examples/](examples/) for more usage patterns
- Customize `sap_config_guard/rules/sap_rules.yaml` for your needs

---

**That's it! You're ready to use sap-config-guard** 🎉

