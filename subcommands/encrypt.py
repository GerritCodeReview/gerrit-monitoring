# Copyright (C) 2020 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import subprocess

import gnupg


ENCRYPTED_KEYS = [
    "accessToken",
    "apiUrl",
    "caCert",
    "cert",
    "htpasswd",
    "key",
    "password",
    "secret",
]


def encrypt(pgp_identifier, config_path):
    """Encrypts the config file using sops and a PGP key.

    Arguments:
        pgp_identifier {string} -- A unique identifier of the PGP key to be used.
            This can be the fingerprint, keyid or part of the uid (e.g. the email
            address)
        config_path {string} -- The path to the config file to be encrypted

    Raises:
        ValueError: Error, if no (unique) PGP key could be found
    """
    gpg = gnupg.GPG()
    gpg_keys = gpg.list_keys()
    selected_keys = list(
        filter(
            lambda k: pgp_identifier in k["fingerprint"]
            or pgp_identifier in k["keyid"]
            or len([v for v in k["uids"] if pgp_identifier in v]) > 0,
            gpg_keys,
        )
    )

    if not selected_keys:
        raise ValueError("PGP key not found.")

    if len(selected_keys) > 1:
        raise ValueError("Identifier of PGP not unique.")

    command = [
        "sops",
        "--encrypt",
        "--in-place",
        "--encrypted-regex",
        f"({'|'.join(ENCRYPTED_KEYS)})",
        "--pgp",
        selected_keys[0]["fingerprint"],
        config_path,
    ]
    subprocess.check_output(command)
