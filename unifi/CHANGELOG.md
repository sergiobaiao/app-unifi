# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- **Migration to UniFi OS Server**: Transitioned the app from the standalone UniFi Network Application to the full UniFi OS Server environment (based on `lemker/unifi-os-server`).
- **Init System**: Moved from `s6-overlay` to `systemd` to support the multi-service architecture of UniFi OS.
- **Base Image**: Switched base image to `ghcr.io/lemker/unifi-os-server:latest`.
- **Primary UI Port**: Updated the default management port to `11443`.
- **Add-on Branding**: Updated metadata and labels to reflect the Home Assistant "App" nomenclature.

### Added
- **Privileged Mode**: Added requirement for `full_access` and specific system capabilities (`SYS_ADMIN`, `NET_ADMIN`) to support systemd and internal services.
- **Port Mappings**: Added numerous ports for UniFi OS services including DNS (53), DHCP (67), RTP (5005), and Site Supervisor (11084).
- **Persistence Logic**: Added automatic symlinking of UniFi OS core directories to the persistent `/data` partition.

### Fixed
- **Cloudflare TURN**: Included patching of `libubnt_webrtc_jni.so` (via base image) to ensure remote access compatibility.

### Removed
- **s6-overlay**: Completely removed s6-overlay scripts and configuration as they are incompatible with the new systemd-based architecture.
- **Memory Options**: Removed manual `memory_max` and `memory_init` options from configuration as resource management is now handled internally by UniFi OS.
