# Config Management

The configuration in the `config.yaml` contains secrets and should not be openly
accessible. To secure the data contained within it, the values can be encrypted
using a tool called [`sops`](https://github.com/mozilla/sops). This tool will use
a key to encrypt the values of the yaml file. Access to the key allows decryption of the values.
As long as the key is not compromised, the encrypted file can be shared securely between collaborators.

The process of using `sops` is described below.

## Install `sops`

On OSX, `sops` can be installed using brew:

```sh
brew install sops
```

## Using a local PGP key

### Install GPG

Install `gpg`:

```sh
brew install gpg
```

You might need to add this to your `.bashrc` or `.zshrc` to enable `sops` to work
correctly with `gpg` [1]:

```sh
GPG_TTY=$(tty)
export GPG_TTY
```

### Create GPG-key (first time only)

Create a key by running the following command and following the instructions on
the screen:

```sh
gpg --gen-key
```

### Encrypt the config-file

Run the following command to encode the file:

```sh
sops \
  --encrypt \
  --in-place \
  --encrypted-regex '(password|htpasswd|cert|key|apiUrl|caCert|secret|accessToken)$' \
  --pgp \
    `gpg --fingerprint "$EMAIL" | \
     grep pub -A 1 | \
     grep -v pub | \
     sed s/\ //g` \
  $FILE_TO_ENCODE
```

`$EMAIL` refers to the email used during the creation of the GPG key.

Alternatively, the `gerrit-monitoring.py encrypt`-script can be used to encrypt
the file:

```sh
pipenv run python ./gerrit-monitoring.py \
  --config config.yaml \
  encrypt \
  --enc-method "pgp" \
  --pgp-id "abcde1234"
```

The gpg-key used to encrypt the file can be selected by giving the fingerprint,
key ID or part of the unique ID to the `--pgp-id`-argument. This identifier has to
be unique among the keys in the GPG keystore.

### Export GPG-key

For other developers or build servers to be able to decrypt the configuration,
the key has to be exported:

```sh
gpg --export -a "$EMAIL" > public.key
gpg --export-secret-key -a "$EMAIL" > private.key
```

On the receiving computer the key has to be imported by running:

```sh
gpg --import public.key
gpg --allow-secret-key-import --import private.key
```

## Encrypt using HashiCorp Vault

### Install `vault` CLI tool

On OSX, `vault` can be installed using brew:

```sh
brew install vault
```

### Log into vault

Use the CLI to log into your vault instance:

```sh
vault login -method=<auth-method> -address=https://vault.example.com
```

### Create a key to use for encryption (first time only)

To use sops with HashiCorp Vault, a secret engine of type transit containing
at least one key has to be created:

```sh
vault secrets enable -path=some-engine transit
vault write sops/keys/some-key type=rsa-4096
```

### Encrypt the config-file

Run the following command to encode the file:

```sh
sops \
  --encrypt \
  --in-place \
  --encrypted-regex '(password|htpasswd|cert|key|apiUrl|caCert|secret|accessToken)$' \
  --hc-vault-transit https://vault.example.com/v1/some-engine/keys/some-key \
  $FILE_TO_ENCODE
```

Alternatively, the `gerrit-monitoring.py encrypt`-script can be used to encrypt
the file:

```sh
pipenv run python ./gerrit-monitoring.py \
  --config config.yaml \
  encrypt \
  --enc-method "vault" \
  --vault-url https://vault.example.com \
  --vault-engine some-engine \
  --vault-key some-key
```

## Decrypt file

To decrypt the file, run:

```sh
sops --in-place -d $FILE_TO_DECODE
```

## Links

[1] https://github.com/mozilla/sops/issues/304
