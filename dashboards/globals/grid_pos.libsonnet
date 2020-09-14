local defaults = import './defaults.libsonnet';

local TOTAL_WIDTH = 24;
local DEFAULT_HEIGHT = 11;

{
  new(
    row,
    column,
    total_columns=2,
    height=DEFAULT_HEIGHT
  ):: {
    local width = TOTAL_WIDTH / total_columns,

    x: column * width,
    y: row * height,
    w: width,
    h: height,
  },
}
