# transmission-tracker-add

A script tool for adding trackers to Transmission using pre-configured tracker lists.

## Prerequisites

### Get Tracker Lists

Download recommended files from these projects:

* [ngosang/trackerslist](https://github.com/ngosang/trackerslist)
* [XIU2/TrackersListCollection](https://github.com/XIU2/TrackersListCollection)

### For Arch Linux Users

Install via [archlinuxcn/repo](https://github.com/archlinuxcn/repo):

```shell
sudo pacman --sync trackerslist-git
# or
sudo pacman --sync trackerslist-collection-git
```

## Installation

1. Clone the repository:

```shell
git clone https://github.com/roaldclark/transmission-tracker-add.git
cd transmission-tracker-add
```

2. Install with correct file ownership (set OWNER to match your Transmission user):

```shell
sudo OWNER=transmission make install
```

## Configuration

1. Configure environment variables:

```shell
sudo vim /etc/default/transmission-tracker-add
---
# Transmission RPC authentication (replace with your actual credentials)
AUTH=user:password

# Path to pre-configured tracker list (default for archlinuxcn/trackerslist-git package)
TRACKER_FILE=/usr/share/trackerslist/trackers/trackers_all.txt
```

2. Stop Transmission service:

```shell
sudo systemctl stop transmission.service
```

3. Add these in `/var/lib/transmission/.config/transmission-daemon/settings.json`:

```
    "script-torrent-added-enabled": true,
    "script-torrent-added-filename": "/usr/local/lib/transmission-tracker-add/transmission-tracker-add",
```

> If installed via package manager, the script path should be `/usr/lib/transmission-tracker-add/transmission-tracker-add` instead.

4. Restart the service:

```shell
sudo systemctl start transmission.service
```

## Note

* If using manually downloaded tracker lists, update the `TRACKER_FILE` path.

* Verify tracker updates via the Transmission Web Interface or `journalctl --follow --unit transmission.service`.

* Not for Private Trackers. This script lacks dedicated processing for them.
