import subprocess
import yaml

from .abstract import AbstractConfigManager


class SopsConfigManager(AbstractConfigManager):
    """Config manager for config file encrypted with sops.
    """

    def _parse(self):
        command = ["sops", "-d", self.config_path]
        output = subprocess.check_output(command)
        return yaml.load(output, Loader=yaml.SafeLoader)
