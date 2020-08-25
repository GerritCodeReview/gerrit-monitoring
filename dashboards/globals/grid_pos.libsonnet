local defaults = import './defaults.libsonnet';

{
  new(
    row,
    column,
  ):: {
    x: column * defaults.panels.width,
    y: row * defaults.panels.height,
    w: defaults.panels.width,
    h: defaults.panels.height,
  },
}
