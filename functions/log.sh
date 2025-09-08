#!/usr/bin/env bash

# Logging-Funktion
log() {
    local type="$1"
    local message="$2"
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    case "$type" in
        "INFO")
            echo -e "[$timestamp] [INFO]: $message"
            ;;
        "CINFO")
            echo -e "${CYAN}[$timestamp] [INFO]: $message${NC}"
            ;;
        "SUCCESS")
            echo -e "${GREEN}[$timestamp] [SUCCESS]: $message${NC}"
            ;;
        "WARNING")
            echo -e "${YELLOW}[$timestamp] [WARNING]: $message${NC}"
            ;;
        "ERROR")
            echo -e "${RED}[$timestamp] [ERROR]: $message${NC}"
            ;;
        "DEBUG")
            if $SHOW_DEBUG; then
                echo -e "${PURPLE}[$timestamp] [DEBUG]: $message${NC}"
            fi
            ;;
        *)
            echo -e "${BLUE}[$timestamp] [LOG]: $message${NC}"
            ;;
    esac
}
