#!/usr/bin/bash

# ===== Configuration =====
CONFIG_FILE="/etc/default/transmission-tracker-add"
[ -f "${CONFIG_FILE}" ] || { echo "Error - Config file missing ${CONFIG_FILE}"; exit 1; }

# ===== Functions =====
load_config() {
    # Define allowed keys
    local allowed_vars=(AUTH HOST TRACKER_FILE)
    local key value

    # Load config
    while IFS='=' read -r key value || [[ -n "${key}" ]]; do
        # Trim whitespace from key and value
        key="${key#"${key%%[![:space:]]*}"}"
        key="${key%"${key##*[![:space:]]}"}"
        value="${value#"${value%%[![:space:]]*}"}"
        value="${value%"${value##*[![:space:]]}"}"

        # Remove surrounding quotes from value
        [[ "${value}" =~ ^\"(.*)\"$ || "${value}" =~ ^\'(.*)\'$ ]] && value="${BASH_REMATCH[1]}"

        # Only accept allowed keys
        for var in "${allowed_vars[@]}"; do
            if [[ "${key}" == "${var}" ]]; then
                export "${var}=${value}"
                break
            fi
        done
    done < "${CONFIG_FILE}"

    # Verify all required variables are set
    local missing=()
    for var in "${allowed_vars[@]}"; do
        [ -z "${!var}" ] && missing+=("${var}")
    done
    if [ "${#missing[@]}" -gt 0 ]; then
        echo "Error - Missing required configuration: ${missing[*]}"
        exit 1
    fi
}

validate_env() {
    [ -z "${TR_TORRENT_HASH}" ] && { echo "TR_TORRENT_HASH not set"; exit 1; }
    [ -z "${TR_TORRENT_ID}" ] && { echo "TR_TORRENT_ID not set"; exit 1; }
}

add_trackers() {
    local torrent_hash="${TR_TORRENT_HASH}"
    local torrent_id="${TR_TORRENT_ID}"
    local torrent_name="${TR_TORRENT_NAME}"

    echo "Processing tracker file: ${TRACKER_FILE}"
    echo "Adding trackers for ${torrent_name}..."

    while IFS= read -r TRACKER; do
        [ -z "${TRACKER}" ] && continue
        if transmission-remote "${HOST}" --auth="${AUTH}" --torrent "${torrent_hash}" --tracker-add "${TRACKER}" | grep -q 'success'; then
            printf "[%s] %s... done\n" "${torrent_id}" "${TRACKER}"
        else
            printf "[%s] %s... already added\n" "${torrent_id}" "${TRACKER}"
        fi
    done < "${TRACKER_FILE}"
}

main() {
    load_config
    validate_env
    add_trackers
}

# ===== Entry Point =====
main
