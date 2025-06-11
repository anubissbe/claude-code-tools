# Contributing to Claude Code Tools

Thank you for your interest in contributing to Claude Code Tools! This document provides guidelines for contributing to the project.

## 🤝 How to Contribute

### Reporting Issues

1. Check if the issue already exists in the [Issues](https://github.com/anubissbe/claude-code-tools/issues) section
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce (if applicable)
   - Expected vs actual behavior
   - System information (OS, shell, Python version)

### Suggesting Features

1. Open an issue with the "enhancement" label
2. Describe the feature and its use case
3. Provide examples if possible

### Submitting Code

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test your changes thoroughly
5. Commit with clear messages (`git commit -m 'Add amazing feature'`)
6. Push to your fork (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## 📋 Pull Request Guidelines

- **One feature per PR** - Keep pull requests focused
- **Update documentation** - Update README.md if needed
- **Add tests** - If applicable
- **Follow existing style** - Match the coding style of existing files
- **Test your changes** - Ensure all scripts work as expected

## 🧪 Testing

Before submitting:

```bash
# Test the main launcher
./cc

# Test bash utilities
source scripts/cc-utils.sh
# Run various functions

# Test Python tools
python3 python-utils/cc_tools.py --help

# Check script permissions
ls -la cc scripts/*.sh automation/*.sh
```

## 💻 Code Style

### Bash Scripts
- Use 4 spaces for indentation
- Add comments for complex logic
- Use meaningful variable names
- Quote variables: `"$var"` not `$var`
- Use `set -e` for error handling

### Python Code
- Follow PEP 8
- Use type hints where appropriate
- Add docstrings to functions
- Keep functions focused and small

## 📝 Commit Messages

Follow conventional commits:

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes
- `refactor:` Code refactoring
- `test:` Test additions/changes
- `chore:` Maintenance tasks

Example:
```
feat: add JSON merge utility to cc_tools.py

- Add merge_json function
- Support deep merging
- Add command line interface
```

## 🌟 Areas for Contribution

Current areas where contributions are welcome:

1. **New Utilities**
   - Additional bash functions
   - More Python data processing tools
   - New automation scripts

2. **Templates**
   - More language templates (Go, Rust, etc.)
   - Framework templates (Django, Express, etc.)

3. **Documentation**
   - Usage examples
   - Video tutorials
   - Translations

4. **Integration**
   - Shell completion scripts
   - Package manager support
   - Editor integrations

## 🔒 Security

- Never commit sensitive data
- Don't add external dependencies without discussion
- Report security issues privately to maintainers

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

## 🙏 Thank You!

Your contributions make Claude Code Tools better for everyone. Whether it's fixing a typo, adding a feature, or improving documentation, every contribution is valued!

If you have questions, feel free to open an issue for discussion.