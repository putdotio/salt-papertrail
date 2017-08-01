{% from "papertrail/map.jinja" import papertrail with context %}

# This funkiness is because we're installing from Github rather than a proper repo. Determines the package
# name for the correct distro depending on settings from map.jinja.
{% set full_pkg_name = papertrail.pkg_prefix ~ papertrail.version ~ papertrail.pkg_suffix %}

{{ papertrail.pkg_name }}:
  pkg.installed:
    - sources:
      - {{ papertrail.pkg_name }}: 'https://github.com/papertrail/remote_syslog2/releases/download/v{{ papertrail.version }}/{{ full_pkg_name }}'

/etc/log_files.yml:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://papertrail/files/log_files.yml
    - template: jinja
    - context:
      log_files: {{ papertrail.files }}
      destination_host: {{ papertrail.destination_host }}
      destination_port: {{ papertrail.destination_port }}
      destination_protocol: {{ papertrail.destination_protocol }}
      {% if papertrail.exclude_files is defined %}
      exclude_files: {{ papertrail.exclude_files }}
      {% endif %}
      {% if papertrail.hostname is defined %}
      hostname: {{ papertrail.hostname }}
      {% endif %}
      {% if papertrail.exclude_patterns is defined %}
      exclude_patterns: {{ papertrail.exclude_patterns }}
      {% endif %}
      {% if papertrail.new_file_check_interval is defined %}
      new_file_check_interval: {{ papertrail.new_file_check_interval }}
      {% endif %}
      {% if papertrail.facility is defined %}
      facility: {{ papertrail.facility }}
      {% endif %}
      {% if papertrail.severity is defined %}
      severity: {{ papertrail.severity }}
      {% endif %}

remote_syslog:
  service:
    - running
    - enable: True
    - watch:
      - pkg: {{ papertrail.pkg_name }}
      - file: /etc/log_files.yml
