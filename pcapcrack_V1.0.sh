#!/bin/bash


# Hashcat attack script for .hc22000 files Stratuscodelab V.1.0
WORDLIST_DIR="plist"
HASH_MODE=22000
TMP_DIR="/tmp/hashcat_wordlists"

mkdir -p "$TMP_DIR"

echo "Available .hc22000 files:"
echo "----------------------------------------"
ls -1 *.hc22000 2>/dev/null || {
    echo "No .hc22000 files found"
    exit 1
}
echo "----------------------------------------"

read -p "Enter the hash file to use: " HASH

if [[ ! -f "$HASH" ]]; then
    echo "Error: Hash file not found."
    exit 1
fi

echo
echo "Using hash file: $HASH"
echo "----------------------------------------"

# 🔍 PRE-CHECK: already cracked?
PRE_CRACKED=$(hashcat --show -m $HASH_MODE "$HASH")

if [[ -n "$PRE_CRACKED" ]]; then
    echo "✅ ALREADY CRACKED (from potfile)"
    echo "----------------------------------------"
    echo "$PRE_CRACKED"
    exit 0
fi

echo "Not found in potfile — starting attack"
echo "----------------------------------------"

run_hashcat () {
    local WORDLIST="$1"
    local SESSION="hc_$(basename "$WORDLIST" | tr '.' '_')"

    echo
    echo ">>> Wordlist: $(basename "$WORDLIST")"
    echo "Session: $SESSION"
    echo "----------------------------------------"

    hashcat \
        -m $HASH_MODE \
        -a 0 \
        --session "$SESSION" \
        --status --status-timer=10 \
        "$HASH" "$WORDLIST"

    echo
    echo "Checking potfile..."
    echo "----------------------------------------"

    CRACKED=$(hashcat --show -m $HASH_MODE "$HASH")

    if [[ -n "$CRACKED" ]]; then
        echo "Status...........: Cracked"
        echo
        echo "$CRACKED"
        exit 0
    fi

    echo "Status...........: Exhausted"
    echo "❌ Not cracked with this list"
    echo "----------------------------------------"
}

for ITEM in "$WORDLIST_DIR"/*; do
    [[ -f "$ITEM" ]] || continue

    case "$ITEM" in
        *.txt)
            run_hashcat "$ITEM"
            ;;
        *.tar.gz)
            echo
            echo ">>> Extracting $(basename "$ITEM")"
            EXTRACT_DIR="$TMP_DIR/$(basename "$ITEM" .tar.gz)"
            mkdir -p "$EXTRACT_DIR"

            tar -xzf "$ITEM" -C "$EXTRACT_DIR"

            for FILE in "$EXTRACT_DIR"/*; do
                [[ -f "$FILE" ]] || continue
                run_hashcat "$FILE"
            done

            rm -rf "$EXTRACT_DIR"
            ;;
    esac
done

echo
echo "All wordlists processed."
echo "No password found."

