# Papertrail Formula

This [formula](https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html) configures the Papertrail [remote_syslog2](https://github.com/papertrail/remote_syslog2) agent. If you want to configure `rsyslog` for use with Papertrail, check out the [documentation on the Papertrail website](http://help.papertrailapp.com/kb/configuration/configuring-remote-syslog-from-unixlinux-and-bsdos-x/).

## Supported Platforms

* RHEL 6 / CentOS 6
* RHEL 7 / CentOS 7
* Amazon Linux 2017.03
* Ubuntu 14.04
* Ubuntu 16.04
* Debian 9

## Usage

### Quickstart

1. Set the pillar attributes `papertrail.destination_host`, `papertrail.destination_port`, and at least one file/directory in `files`.

```yaml
papertrail:
  files:
    - /var/log/syslog
    - /var/log/apache2/*.log
  destination_host: YOUR-HOST-HERE
  destination_port: YOUR-PORT-HERE
```

2. Include `papertrail` in your state file or `top.sls`, depending on which ever you prefer.

In a state:

```yaml
include:
  - papertrail
```

in `top.sls`:

```yaml
base:
  '*':
    - papertrail
```

This will install `remote_syslog2` with the configured settings you set in Pillar.

## Pillar attributes

This Salt formula only has one state, which does all setup and configuration. There are a number of Pillar items you can configure, all of which mirror the configuration items found in the `remote_syslog2` [README](https://github.com/papertrail/remote_syslog2#configuration).

- `files`

  A list of files or patterns to send to Papertrail.

  Example:
  ```yaml
  papertrail:
    files:
      - /tmp/test.log
      - /srv/foo.txt
      - /var/log/*.bar
      - path: /srv/foo.txt
        tag: foo_file
   ```

- `exclude_files`

  A list of files or patterns to exclude.

  Example:
  ```yaml
  papertrail:
    exclude_files:
      - /tmp/exlude.log
      - /srv/dont-include.log
      - /var/log/skip-me.log
  ```

- `exclude_patterns`:

  A regex of log message patterns to exclude.

  Example:
  ```yaml
  papertrail:
    exclude_patterns:
      - '\d+ things'
  ```
- `hostname`

  Override the default hostname.

  Example:
  ```yaml
  papertrail:
    hostname: 'my-super-awesome-hostname'
  ```

- `destination_host`, `destination_port`, & `destination_protocol`

  The Papertrail host, port, and protocol for sending your logs to. These are required. Protocol defaults to `tls`.

  Example:
  ```yaml
  papertrail:
    destination_host: YOUR-HOST-HERE
    destination_port: YOUR-PORT-HERE
    destination_protocol: 'tls'
  ```

- `new_file_check_interval`

  Overrides the default file check interval.

  Example:
  ```yaml
  papertrail:
    new_file_check_interval: 30
  ```

- `version`

  Use a different version of `remote_syslog` than the default. The default is specified in `map.jinja`.

  Example:
  ```yaml
  papertrail:
    version: 0.18
  ```

## Testing

### Unit tests

No unit tests are written at this time.

### Integration tests

1. Run `kitchen test`
2. Take a break--it takes a bit to run the full suite.

The pillar test data is located in `test-pillar.yaml`.

#### Testing Amazon Linux

Testing Amazon Linux through `test-kitchen` requires a bit more setup:

1. Ensure `kitchen-ec2` is installed: `chef gem install kitchen-ec2`
2. Update `.kitchen.yml` to have the correct AWS key ID you're going to use
3. Set `security_group_ids` in the driver section to include a security group accessible from your laptop. Not setting this will use the `default` security group.
4. Set `transport.ssh_key` to the path of your SSH key. It looks for `id_rsa` by default.

## License and Authors

**License**: See [LICENSE](LICENSE.md)

**Author:** Mike Julian (@mjulian)
