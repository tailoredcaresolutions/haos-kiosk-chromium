#!/bin/bash
################################################################################
# Chromium Auto-Login Handler for Home Assistant
# Runs after Chromium launches to auto-fill HA login credentials
# Uses xdotool to simulate keyboard input on the login form
################################################################################

HA_URL="${HA_URL:-http://localhost:8123}"
HA_USERNAME="${HA_USERNAME:-}"
HA_PASSWORD="${HA_PASSWORD:-}"
LOGIN_DELAY="${LOGIN_DELAY:-5}"
HA_DASHBOARD="${HA_DASHBOARD:-}"

# Wait for Chromium to load the login page
sleep "$LOGIN_DELAY"

# Check if we're on the login page by looking for the auth form
# If already logged in (session persisted in user-data-dir), skip login
PAGE_TITLE=$(xdotool getactivewindow getwindowname 2>/dev/null || echo "")

if echo "$PAGE_TITLE" | grep -qi "Home Assistant\|Log in\|Login"; then
    echo "[chromium_login] Detected HA page, attempting auto-login..."

    # Focus the browser window
    xdotool key --clearmodifiers Tab
    sleep 0.5

    # Type username (the HA login form focuses the username field first)
    xdotool type --clearmodifiers "$HA_USERNAME"
    sleep 0.3

    # Tab to password field
    xdotool key --clearmodifiers Tab
    sleep 0.3

    # Type password
    xdotool type --clearmodifiers "$HA_PASSWORD"
    sleep 0.3

    # Press Enter to submit
    xdotool key --clearmodifiers Return
    sleep 3

    echo "[chromium_login] Login submitted, waiting for redirect..."

    # After login, navigate to the dashboard if specified
    if [ -n "$HA_DASHBOARD" ]; then
        sleep 2
        echo "[chromium_login] Login complete."
    fi
else
    echo "[chromium_login] Already logged in or page not detected, skipping..."
fi
