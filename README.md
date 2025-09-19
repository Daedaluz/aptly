# Aptly Docker GPG Entrypoint

This repository provides a minimal Docker setup for running [Aptly](https://www.aptly.info/) with automated GPG key management for CI/CD and reproducible builds.

## Features
- **Automatic GPG Key Generation:**
  - If no GPG key exists, a new one is generated on container start.
  - Key parameters (name, email, comment) are configurable via environment variables.
- **Key Import Support:**
  - If the `GPG_KEY` environment variable is set (containing an ASCII-armored private key), it will be imported and used instead of generating a new key.
- **Public Key Export:**
  - The public key is exported in ASCII-armored format to `/data/public/aptly-signing-key.asc` for easy download and client use.
- **Persistent Keyring:**
  - The GPG keyring is stored in `/data/.gnupg` for persistence across container restarts.
- **Aptly API Serve:**
  - The container runs `aptly api serve` with configuration from `/etc/aptly/aptly.yml`.

## Image Availability

A multi-architecture (amd64, arm64) image is automatically built and published to GitHub Container Registry (GHCR) on every push to `master`:

```
ghcr.io/daedaluz/aptly-api:latest
```

## Usage

### Build the Image Locally
```sh
docker build -t aptly-api .
```

### Run the Container
```sh
docker run -v $(pwd)/data:/data -p 8080:8080 ghcr.io/daedaluz/aptly-api:latest
```

### Environment Variables
- `GPG_KEY_NAME` – Name for generated GPG key (default: `CI_CD_Aptly`)
- `GPG_KEY_EMAIL` – Email for generated GPG key (default: `ci-cd@localhost`)
- `GPG_KEY_COMMENT` – Comment for generated GPG key (default: `Aptly CI/CD Signing Key`)
- `GPG_KEY` – (Optional) ASCII-armored private key to import instead of generating a new one

### Public Key Download
After startup, the public key is available at:
```
/data/public/aptly-signing-key.asc
```

## File Overview
- `Dockerfile` – Installs Aptly, sets up volumes, and configures the environment
- `entrypoint.sh` – Handles GPG key management and starts the Aptly API server
- `etc/aptly.yml` – Example Aptly configuration (customize as needed)

## License
MIT
