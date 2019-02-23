zbv_sources = [
  'main.vala',
  'obs.vala',
  'config.vala',
]

zbv_deps = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('libsoup-2.4'),
  dependency('libxml-2.0'),
  meson.get_compiler('vala').find_library('posix'),
]

executable('zbv', zbv_sources,
  vala_args: '--target-glib=2.58',  dependencies: zbv_deps,
  install: true,
)