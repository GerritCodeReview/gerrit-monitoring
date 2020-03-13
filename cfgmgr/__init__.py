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

import yaml

from .default import DefaultConfigManager
from .sops import SopsConfigManager


def get_config_manager(config_path):
    """Decide which ConfigManager is required to parse the config file.

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
