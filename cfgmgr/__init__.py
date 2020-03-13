import yaml

from .default import DefaultConfigManager
from .sops import SopsConfigManager


def get_config_manager(config_path):
    """Looks at the config file and decides which ConfigManager is required to
    parse the config file.

    Arguments:
        config_path {string} -- Path to config file

    Returns:
        AbstractConfigManager -- ConfigManager that can parse the given config file
    """
    with open(config_path, "r") as f:
        config = yaml.load(f, Loader=yaml.SafeLoader)

    if "sops" in config.keys():
        return SopsConfigManager(config_path)

    return DefaultConfigManager(config_path)
