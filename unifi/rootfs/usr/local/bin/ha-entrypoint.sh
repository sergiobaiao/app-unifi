#!/bin/bash
# ==============================================================================
# Home Assistant Community App: UniFi OS Server
# Bridges Home Assistant options with UOS environment
# ==============================================================================

# Parse options
if [ -f /data/options.json ]; then
    export UOS_SYSTEM_IP=$(jq -r '.system_ip // empty' /data/options.json)
fi

# tmpfs mounts for systemd
echo "Mounting tmpfs directories..."
mount -t tmpfs tmpfs /run -o mode=0755,nosuid,nodev
mount -t tmpfs tmpfs /run/lock -o mode=0755,nosuid,nodev
mount -t tmpfs tmpfs /tmp -o mode=1777,nosuid,nodev

# Ensure cgroups are writable
mount -o remount,rw /sys/fs/cgroup

# Data persistence mapping
# UOS stores state in multiple directories. 
# We must ensure these are symlinked to the HA /data partition.
for dir in /var/lib/unifi /var/lib/postgresql /var/lib/mongodb /var/lib/rabbitmq /etc/unifi-core /etc/unifi-os; do
    base=$(basename "$dir")
    data_dir="/data/$base"
    
    # If the directory exists but is not a symlink to /data, move and link
    if [ -d "$dir" ] && [ ! -L "$dir" ]; then
        echo "Moving $dir to $data_dir for persistence..."
        mkdir -p "$data_dir"
        cp -a "$dir/." "$data_dir/"
        rm -rf "$dir"
    fi
    
    # Ensure link exists
    if [ ! -L "$dir" ]; then
        mkdir -p "$data_dir"
        ln -sf "$data_dir" "$dir"
    fi
done

# Execute lemker's entrypoint
# shellcheck disable=SC1091
exec /root/uos-entrypoint.sh
