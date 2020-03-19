# Config Management

The configuration in the `config.yaml` contains secrets and should not be openly
accessible. To secure the data contained within it, the values can be encrypted
using a tool called [`sops`](https://github.com/mozilla/sops). This tool will use
a GPG-key to encrypt the values of the yaml file. Having the PGP-key also allows
to decrypt the values and work with the file. As long as the key is not compromised,
the encrypted file can be shared securly between collaborators.

The process of using `sops` is described below.

## Install `sops`

On OSX, `sops` can be installed using brew:

```sh
brew install sops
```

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

## Create GPG-key (first time only)

Create a key by running the following command and following the instructions on
the screen:

```sh
gpg --gen-key
```

## Encrypt the config-file

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

Alternatively, the `./encrypt.sh`-script can be used to encrypt the file:

```sh
./encrypt.sh \
  [--email $EMAIL] \
  [--fingerprint $FINGERPRINT] \
  $FILE_TO_ENCODE
```

The gpg-key used to encrypt the file can be selected by directly giving the key's
fingerprint using the `--fingerprint` option or giving the email used to identify
the key using the `--email` option. The `--fingerprint` option will have preference.
At least one of these options has to be set.

## Decrypt file

To decrypt the file, run:

```sh
sops --in-place -d $FILE_TO_DECODE
```

## Export GPG-key

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

## Links

[1] https://github.com/mozilla/sops/issues/304
