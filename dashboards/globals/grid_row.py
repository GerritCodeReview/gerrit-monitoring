import attr

from grafanalib.core import Row, Pixels


@attr.s
class GridRow(Row):
    height = attr.ib(Pixels(400))
