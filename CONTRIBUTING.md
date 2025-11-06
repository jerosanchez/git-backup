# Contributing to git-backup

Thank you for your interest in contributing!

> **Note:** The installation steps below are aimed at Debian-based Linux systems (such as Ubuntu) as an example. If you are using a different operating system, please follow the appropriate instructions for your platform to install Node.js, npm, and other dependencies.

## Prerequisites

To contribute and check markdown linting, you need:

- Node.js
- npm (Node.js package manager)
- markdownlint-cli (Markdown linter)
- GNU Make

## Installation Steps

### 1. Install Node.js and npm

On most Linux systems, run:

```bash
sudo apt update
sudo apt install nodejs npm
```

### 2. Install markdownlint-cli

After Node.js and npm are installed, run:

```bash
sudo npm install -g markdownlint-cli
```

### 3. Verify Installation

Check that everything is installed:

```bash
node -v
npm -v
markdownlint --version
make --version
```

## Linting Markdown Files

A `Makefile` is provided with a `lint` target. To check all markdown files for lint issues, run:

```bash
make lint
```

This will use `markdownlint` to check all `.md` files in the project root.

## Need Help?

If you encounter any issues, please open an issue or ask for help in the repository.
