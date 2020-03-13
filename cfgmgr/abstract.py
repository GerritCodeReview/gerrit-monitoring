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

from passlib.apache import HtpasswdFile


class AbstractConfigManager(abc.ABC):
    """Provide abstract base class to implement config
    managers that can e.g. handle different encryption methods.
    """

    def __init__(self, config_path):
        self.config_path = config_path

        self.requires_htpasswd = [
            ["loki"],
            ["prometheus", "server"],
        ]

    def get_config(self):
        """Parse the configuration and return it as a dictionary.

        Returns:
            dict -- Dictionary containing the unencrypted configuration as parsed
              from the file
        """

        config = self._parse()
        for component in self.requires_htpasswd:
            section = config
            for i in component:
                section = section[i]
            section["htpasswd"] = self._create_htpasswd_entry(
                section["username"], section["password"]
            )
        return config

    @staticmethod
    def _create_htpasswd_entry(username, password):
        htpasswd = HtpasswdFile()
        htpasswd.set_password(username, password)
        return htpasswd.to_string()[:-1]

    @abc.abstractmethod
    def _parse(self):
        pass
