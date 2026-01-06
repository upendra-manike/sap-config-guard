# Contributing to sap-config-guard

Thank you for your interest in contributing to `sap-config-guard`! 🎉

## Development Setup

1. **Fork and clone the repository**
   ```bash
   git clone https://github.com/yourusername/sap-config-guard.git
   cd sap-config-guard
   ```

2. **Create a virtual environment**
   ```bash
   python3 -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install in development mode**
   ```bash
   pip install -e .[dev]
   ```

## Running Tests

```bash
# Run all tests
pytest tests/ -v

# Run with coverage
pytest tests/ -v --cov=sap_config_guard --cov-report=term-missing
```

## Code Style

We use:
- **Black** for code formatting
- **flake8** for linting

```bash
# Format code
black sap_config_guard/ tests/

# Check linting
flake8 sap_config_guard/ tests/
```

## Making Changes

1. Create a feature branch
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes and add tests

3. Ensure all tests pass
   ```bash
   pytest tests/ -v
   ```

4. Format and lint your code
   ```bash
   black sap_config_guard/ tests/
   flake8 sap_config_guard/ tests/
   ```

5. Commit your changes
   ```bash
   git commit -m "Add: your feature description"
   ```

6. Push and create a Pull Request

## Pull Request Guidelines

- Provide a clear description of what the PR does
- Include tests for new functionality
- Update documentation if needed
- Ensure CI passes

## Areas for Contribution

- 🐛 Bug fixes
- ✨ New features (see roadmap in README)
- 📚 Documentation improvements
- 🧪 Additional test coverage
- 🔌 Plugin system (future)
- ☕ Java wrapper (future)

## Questions?

Open an issue or start a discussion on GitHub!

---

Thank you for contributing! 🙏

