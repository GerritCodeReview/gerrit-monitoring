{
  new(show=true,
      format='short',
      label='',
      logBase=1,):: {
        format: format,
        label: label,
        logBase: logBase,
  },
  latency: self.new(
    label='Latency',
    format='s',
  ),
  cache_misses: self.new(
    label='Cache Misses',
    format='percent',
  ),
}
