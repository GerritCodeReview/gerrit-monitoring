import yaml

from .abstract import AbstractConfigManager


class DefaultConfigManager(AbstractConfigManager):
    """Config manager for unencrypted files
    """

    def _parse(self):
        with open(self.config_path, "r") as f:
            config = yaml.load(f, Loader=yaml.SafeLoader)

        return config
