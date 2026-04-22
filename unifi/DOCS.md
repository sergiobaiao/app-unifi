# Home Assistant Community App: UniFi OS Server

This app runs Ubiquiti Networks' UniFi OS Server software, which
allows you to manage your UniFi network via the web browser. The app
provides a single-click installation and run solution for Home Assistant,
allowing users to get their network up, running, and updated, easily.

## Installation

The installation of this app is pretty straightforward and not different in
comparison to installing any other Home Assistant app.

1. Click the Home Assistant My button below to open the app on your Home
   Assistant instance.

   [![Open this app in your Home Assistant instance.][app-badge]][app]

1. Click the "Install" button to install the app.
1. Check the logs of the "UniFi OS Server" to see if everything went
   well.
1. Click the "OPEN WEB UI" button, and follow the initial wizard.
1. After completing the wizard, log in with the credentials just created.
1. Select Unifi Devices which you can find on the left hand. Once there, select Device Updates and Settings on the top right.
1. Scroll down to Device settings and below the `Inform Host Override` label, enter the IP or hostname of the device running Home Assistant.
1. Click the checkbox option for `Inform Host Override` so that is now "checked".
1. Hit the "Apply Changes" button to activate the settings.
1. Ready to go!

## Configuration

**Note**: _Remember to restart the app when the configuration is changed._

Example app configuration, with all available options:

```yaml
log_level: info
system_ip: 192.168.1.10
```

**Note**: _This is just an example, don't copy and paste it! Create your own!_

### Option: `log_level`

The `log_level` option controls the level of log output by the app and can
be changed to be more or less verbose, which might be useful when you are
dealing with an unknown issue. Possible values are:

- `trace`: Show every detail, like all called internal functions.
- `debug`: Shows detailed debug information.
- `info`: Normal (usually) interesting events.
- `warning`: Exceptional occurrences that are not errors.
- `error`: Runtime errors that do not require immediate action.
- `fatal`: Something went terribly wrong. App becomes unusable.

Please note that each level automatically includes log messages from a
more severe level, e.g., `debug` also shows `info` messages. By default,
the `log_level` is set to `info`, which is the recommended setting unless
you are troubleshooting.

### Option: `system_ip`

This option allows you to manually specify the IP address or hostname that
UniFi devices should use to "inform" (report back) to the controller. This
is equivalent to setting the `UOS_SYSTEM_IP` environment variable in the 
underlying container.

## UniFi OS Server Migration (IMPORTANT)

This app now runs **UniFi OS Server** (based on `lemker/unifi-os-server`). This
is a major architectural change that replaces the standalone application with
a systemd-based environment containing its own management layer, PostgreSQL,
and MongoDB services.

### Breaking Changes:
- **Data Migration:** Existing databases from the standalone application are 
  **NOT** automatically migrated. You **MUST** export a backup (`.unf` file) 
  from your old installation before upgrading, and then restore it during the 
  initial setup of UniFi OS.
- **Privileges:** This add-on now requires "Full Access" / "Privileged" mode 
  to support `systemd` and its internal services.
- **Resource Usage:** UniFi OS Server runs multiple services (PostgreSQL, 
  RabbitMQ, MongoDB, unifi-core) and will consume more memory and CPU than 
  the previous standalone version.

## Automated backups

The UniFi OS Server ships with an automated backup feature. This
feature works but has been adjusted to put the created backups in a different
location.

Backups are created in `/backup/unifi`. You can access this folder using
the normal Home Assistant methods (e.g., using Samba, Terminal, SSH).

## Manually adopting a device

Alternatively to setting up a custom inform address (installation steps 7-9)
you can manually adopt a device by following these steps:

- SSH into the device using `ubnt` as username and `ubnt` as password
- `$ mca-cli`
- `$ set-inform http://<IP of Hassio>:<controller port (default:8080)>/inform`
  - for example `$ set-inform http://192.168.1.14:8080/inform`

## Future of this app

**The standalone UniFi Network Application has reached end-of-life.**
Ubiquiti has transitioned to UniFi OS Server. This app has been updated
to provide a single-container integration for UniFi OS Server (using 
`systemd` internally), which requires elevated privileges and a manual 
data restoration path from previous versions.

## Known issues and limitations

- The AP seems stuck in "adopting" state: Please read the installation
  instructions carefully. You need to change some controller settings
  in order for this app to work properly. Using the Ubiquiti Discovery
  Tool, or SSH'ing into the AP and setting the INFORM after adopting
  will resolve this. (see: _Manually adopting a device_)
- The following error can show up in the log, but can be safely ignored:

  ```
    INFO: I/O exception (java.net.ConnectException) caught when processing
    request: Connection refused (Connection refused)
  ```

  This is a known issue, however, the app functions normally.

- Due to security policies in the UniFi OS Server software, it is
  currently impossible to add the UniFI web interface to your Home Assistant
  frontend using a `panel_iframe`.
- The broadcast feature of the EDU-type APs are currently not working with
  this app. Due to a limitation in Home Assistant, is it currently impossible
  to open the required "range" of ports needed for this feature to work.
- This app cannot support Ingress due to technical limitations of the
  UniFi software.
- During making a backup of this app via Home Assistant, this app will
  temporary shutdown and start up after the backup has finished. This prevents
  data corruption during taking the backup.

## Changelog & Releases

This repository keeps a change log using [GitHub's releases][releases]
functionality. The format of the log is based on
[Keep a Changelog][keepchangelog].

Releases are based on [Semantic Versioning][semver], and use the format
of `MAJOR.MINOR.PATCH`. In a nutshell, the version will be incremented
based on the following:

- `MAJOR`: Incompatible or major changes.
- `MINOR`: Backwards-compatible new features and enhancements.
- `PATCH`: Backwards-compatible bugfixes and package updates.

## Support

Got questions?

You have several options to get them answered:

- The [Home Assistant Community Apps Discord chat server][discord] for app
  support and feature requests.
- The [Home Assistant Discord chat server][discord-ha] for general Home
  Assistant discussions and questions.
- The Home Assistant [Community Forum][forum].
- Join the [Reddit subreddit][reddit] in [/r/homeassistant][reddit]

You could also [open an issue here][issue] GitHub.

## Authors & contributors

The original setup of this repository is by [Franck Nijhof][frenck].

For a full list of all authors and contributors,
check [the contributor's page][contributors].

## License

MIT License

Copyright (c) 2018-2026 Franck Nijhof

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[app-badge]: https://my.home-assistant.io/badges/supervisor_addon.svg
[app]: https://my.home-assistant.io/redirect/supervisor_addon/?addon=a0d7b954_unifi&repository_url=https%3A%2F%2Fgithub.com%2Fhassio-addons%2Frepository
[contributors]: https://github.com/hassio-addons/app-unifi/graphs/contributors
[discord-ha]: https://discord.gg/c5DvZ4e
[discord]: https://discord.me/hassioaddons
[forum]: https://community.home-assistant.io/t/home-assistant-community-add-on-unifi-controller/56297?u=frenck
[frenck]: https://github.com/frenck
[issue]: https://github.com/hassio-addons/app-unifi/issues
[keepchangelog]: http://keepachangelog.com/en/1.0.0/
[reddit]: https://reddit.com/r/homeassistant
[releases]: https://github.com/hassio-addons/app-unifi/releases
[semver]: http://semver.org/spec/v2.0.0.htm
