#!/bin/bash

# Check for gpg keys:
GPG_KEY_NAME="${GPG_KEY_NAME:-CI_CD_Aptly}" # Default name
GPG_KEY_EMAIL="${GPG_KEY_EMAIL:-ci-cd@localhost}" # Default email
GPG_KEY_COMMENT="${GPG_KEY_COMMENT:-Aptly CI/CD Signing Key}" # Default comment
PUBLIC_DIR="/data/public"

mkdir -p "$GNUPGHOME" "$PUBLIC_DIR"
chmod 700 "$GNUPGHOME"

# Check if a secret key for the email already exists
if ! gpg --homedir "$GNUPGHOME" --list-secret-keys "$GPG_KEY_EMAIL" >/dev/null 2>&1; then
  echo "[entrypoint] No GPG key found for $GPG_KEY_EMAIL, generating new key..."
  cat >keygen.batch <<EOF
    Key-Type: RSA
    Key-Length: 4096
    Subkey-Type: RSA
    Subkey-Length: 4096
    Name-Real: $GPG_KEY_NAME
    Name-Comment: $GPG_KEY_COMMENT
    Name-Email: $GPG_KEY_EMAIL
    Expire-Date: 0
    %no-protection
    %commit
EOF
  gpg --homedir "$GNUPGHOME" --batch --generate-key keygen.batch
  rm -f keygen.batch
else
  echo "[entrypoint] GPG key for $GPG_KEY_EMAIL already exists."
fi

# Export the armoured public key for download
PUBKEY_FILE="$PUBLIC_DIR/aptly-signing-key.asc"
gpg --homedir "$GNUPGHOME" --armor --export "$GPG_KEY_EMAIL" > "$PUBKEY_FILE"
echo "[entrypoint] Exported public key to $PUBKEY_FILE"
exec aptly api serve -config /etc/aptly/aptly.yml