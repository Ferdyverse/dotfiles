#!/bin/bash

# Logging-Funktion
log() {
    local type="$1"
    local message="$2"
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    case "$type" in
        "INFO")
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
        "DESCRIPTION")
            echo -e "${PURPLE}[$timestamp] [ERROR]: $message${NC}"
            ;;
        *)
            echo -e "${BLUE}[$timestamp] [LOG]: $message${NC}"
            ;;
    esac
}
