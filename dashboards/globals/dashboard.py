import attr

from grafanalib.core import (
    Dashboard,
    Time,
)

from .templates import gerrit_instances

REFRESH_FREQUENCY = "1m"
SCHEMA_VERSION = 12
TIME = Time("now-24h", "now")


@attr.s
class GerritDashboard(Dashboard):
    title = attr.ib("Gerrit - Process")
    templating = attr.ib(gerrit_instances)
    sharedCrosshair = attr.ib(True)
    editable = attr.ib(False)
    refresh = attr.ib(REFRESH_FREQUENCY)
    schemaVersion = attr.ib(SCHEMA_VERSION)
    time = attr.ib(TIME)
