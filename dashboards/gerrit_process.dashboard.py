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
