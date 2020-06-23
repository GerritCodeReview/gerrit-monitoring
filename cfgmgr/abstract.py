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

import abc
import json

from copy import deepcopy

import python_jwt

import jwcrypto.jwk as jwk
from passlib.apache import HtpasswdFile


class AbstractConfigManager(abc.ABC):
    """Provide abstract base class to implement config
    managers that can e.g. handle different encryption methods.
    """

    def __init__(self, config_path):
        self.config_path = config_path

        self.requires_htpasswd = [
            ["logging", "loki"],
            ["monitoring", "prometheus", "server"],
        ]
        self.config = self._parse()
        if self.config["istio"]["enabled"]:
            self.jwks = self._create_jwks()

    def get_config(self):
        """Parse the configuration and return it as a dictionary.

        Returns:
            dict -- Dictionary containing the unencrypted configuration as parsed
              from the file
        """
        return self._add_computed_values()

    def get_jwt_token(self, payload):
        """Generate JWT token from the configured private key.

        Args:
            payload (dict): Token payload (https://tools.ietf.org/html/rfc7519#section-3.1)

        Returns:
            String: JWT token
        """
        private_key = jwk.JWK.from_pem(
            self.config["istio"]["jwt"]["key"].encode("utf-8")
        ).export()
        # TODO: The tokens should get a lifetime, as soon as a mechanism is in place of
        # automatically cycling them
        return python_jwt.generate_jwt(payload, jwk.JWK.from_json(private_key), "RS256")

    def _add_computed_values(self):
        config = deepcopy(self.config)

        if config["istio"]["enabled"]:
            config["istio"]["jwt"]["jwks"] = json.dumps(self.jwks)

            for gerrit in config["gerritServers"]["other"]:
                payload = {
                    "iss": config["istio"]["jwt"]["issuer"],
                    "sub": f"promtail_{gerrit['host']}",
                }
                gerrit["promtail"]["token"] = self.get_jwt_token(payload)

            payload = {
                "iss": config["istio"]["jwt"]["issuer"],
                "sub": f"promtail_cluster",
            }
            config["logging"]["promtail"] = {"token": self.get_jwt_token(payload)}
        else:
            for component in self.requires_htpasswd:
                section = config
                for i in component:
                    section = section[i]
                section["htpasswd"] = self._create_htpasswd_entry(
                    section["username"], section["password"]
                )

        return config

    def _create_jwks(self):
        public_key = jwk.JWK.from_pem(
            self.config["istio"]["jwt"]["cert"].encode("utf-8")
        ).export()
        return {"keys": [json.loads(public_key)]}

    @staticmethod
    def _create_htpasswd_entry(username, password):
        htpasswd = HtpasswdFile()
        htpasswd.set_password(username, password)
        return htpasswd.to_string()[:-1]

    @abc.abstractmethod
    def _parse(self):
        pass
