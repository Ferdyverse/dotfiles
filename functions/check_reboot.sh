#!/usr/bin/env bash

get_latest_installed_kernel() {
    local latest_kernel=""

    # Works on Arch and many other distros: one folder per installed kernel.
    if [ -d /usr/lib/modules ]; then
        latest_kernel=$(find /usr/lib/modules -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null | sort -V | tail -n 1)
    fi

    # Fallback for distros exposing kernel images directly in /boot.
    if [ -z "$latest_kernel" ] && compgen -G "/boot/vmlinuz-*" >/dev/null; then
        latest_kernel=$(printf '%s\n' /boot/vmlinuz-* | sed 's#^.*/vmlinuz-##' | sort -V | tail -n 1)
    fi

    echo "$latest_kernel"
}

# Check for kernel updates
check_kernel_update() {
    if ! $IS_WSL; then
        running_kernel=$(uname -r)
        installed_kernel=$(get_latest_installed_kernel)

        if [ -z "$installed_kernel" ]; then
            log "DEBUG" "Could not determine installed kernel version."
            return 1
        fi

        if [ "$running_kernel" != "$installed_kernel" ]; then
            log "WARNING" "Reboot required: Kernel mismatch (running: $running_kernel, installed: $installed_kernel)"
            reboot_prompt "A new kernel version is installed. Reboot is recommended."
            return 0
        fi
    fi

    return 1
}

# Check with needs-restarting (for yum or dnf systems)
check_needs_restarting() {
    if command -v needs-restarting >/dev/null 2>&1; then
        if needs-restarting -r >/dev/null 2>&1; then
            log "WARNING" "Reboot required: Some processes need restarting."
            reboot_prompt "A reboot is recommended to apply updates."
            return 0
        fi
    fi
}

# Check systemd reboot flag
check_systemd_reboot_flag() {
    if loginctl show-session "$(loginctl | awk '/seat0/{print $1}')" -p RebootToRestart | grep -q yes; then
        log "WARNING" "Reboot required: Systemd indicates reboot is pending."
        reboot_prompt "A reboot is required to complete changes."
        return 0
    fi
}

# Check for dpkg/kernel updates (Debian/Ubuntu systems)
check_dpkg_reboot() {
    if ! command -v dpkg >/dev/null 2>&1; then
        return 1
    fi

    if dpkg -l | grep -E '^ii.*linux-image-[0-9]' | grep -q "$(uname -r | sed 's/-[^-]*$//')"; then
        log "WARNING" "Reboot required: New kernel installed but not running."
        reboot_prompt "A reboot is required to load the new kernel."
        return 0
    fi

    return 1
}

# Check for boot ID changes
check_boot_id_change() {
    last_boot_id=$(cat /proc/sys/kernel/random/boot_id)
    saved_boot_id="$HOME/.local/state/dotfiles/reboot-check/boot_id"

    mkdir -p "$(dirname "$saved_boot_id")"

    if [ ! -f "$saved_boot_id" ]; then
        echo "$last_boot_id" >"$saved_boot_id"
        return 1
    fi

    if [ "$last_boot_id" != "$(cat "$saved_boot_id")" ]; then
        echo "$last_boot_id" >"$saved_boot_id"
        log "DEBUG" "Boot ID changed since last check."
        return 1
    fi

    return 1
}

# Check with rebootmgrctl (for SUSE or rebootmgr systems)
check_rebootmgr() {
    if command -v rebootmgrctl >/dev/null 2>&1 && rebootmgrctl status | grep -q "reboot required"; then
        log "WARNING" "Reboot required: rebootmgr indicates a reboot is pending."
        reboot_prompt "Reboot is required to finalize updates."
        return 0
    fi
}

# Main function to check if a reboot is needed
check_reboot_needed() {
    # Check for standard reboot-required files
    if [ -f /run/reboot-required ] || [ -f /var/run/reboot-required ]; then
        log "WARNING" "Reboot required: A flag file indicates a reboot is needed."
        reboot_prompt "System update requires a reboot to complete."
        return 0
    fi

    # Check for kernel updates
    check_kernel_update && return 0

    # Check with needs-restarting
    check_needs_restarting && return 0

    # Check other methods
    check_systemd_reboot_flag && return 0
    check_dpkg_reboot && return 0
    check_boot_id_change && return 0
    # check_rebootmgr && return 0

    log "INFO" "No reboot required or could not determine."
    return 1
}

# Source this file and call check_reboot_needed to use.
