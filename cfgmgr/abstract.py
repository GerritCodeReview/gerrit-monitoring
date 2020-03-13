import abc

from passlib.apache import HtpasswdFile


class AbstractConfigManager(abc.ABC):
    """Abstract config manager that provides base class to implement config
    managers that can e.g. handle different encryption methods.
    """

    def __init__(self, config_path):
        self.config_path = config_path

        self.requires_htpasswd = [
            ["loki"],
            ["prometheus", "server"],
        ]

    def get_config(self):
        """Parses the configuration and returns it as a dict.

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
