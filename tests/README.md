# Tests Directory

This directory contains all test-related files for the ODA Frontend project, organized into the following subdirectories:

## Directory Structure

```
tests/
├── shell/           # Shell scripts for testing infrastructure, deployment, and configuration
│   ├── test-container-registry.sh
│   ├── test-deploy.sh
│   ├── test-docker-login-mgc.sh
│   ├── test-docker-login-v2.sh
│   ├── test-docker-login-v3.sh
│   ├── test-magalu-api.sh
│   ├── test-mgc-cli.sh
│   ├── test-registry-domains.sh
│   └── monitor-canary.sh
├── unit/            # Unit tests (if moved from src)
└── integration/     # Integration tests
```

## Running Tests

### Shell Tests

Shell tests can be run from the project root directory:

```bash
# Run a specific shell test
bash tests/shell/test-deploy.sh

# Make the script executable first (alternative)
chmod +x tests/shell/test-deploy.sh
./tests/shell/test-deploy.sh
```

### React Unit Tests

React unit tests remain in their original locations within the src directory and can be run using:

```bash
npm test
# or
npm run test
```
