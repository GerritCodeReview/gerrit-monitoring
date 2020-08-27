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

import os
import sys

sys.path.append(os.path.dirname(__file__))

from globals.grid_row import GridRow
from globals.dashboard import GerritDashboard

from panels.gerrit.process.system_load import panel as system_load_panel
from panels.gerrit.process.memory import panel as memory_panel
from panels.gerrit.process.cpu import panel as cpu_panel
from panels.gerrit.process.gc import panel as gc_panel
from panels.gerrit.process.threads import panel as threads_panel
from panels.gerrit.process.file_descriptors import panel as file_descriptors_panel
from panels.gerrit.process.jgit_block_cache import panel as jgit_block_cache_panel

dashboard = GerritDashboard(
    title="Gerrit - Process",
    rows=[
        GridRow(panels=[system_load_panel, memory_panel,],),
        GridRow(panels=[cpu_panel, gc_panel],),
        GridRow(panels=[threads_panel, file_descriptors_panel],),
        GridRow(panels=[jgit_block_cache_panel],),
    ],
).auto_panel_ids()
