#!/bin/bash
# network-helper.sh - Helper script for NetworkScrambler

# Validate input parameters
if [ $# -lt 2 ]; then
    echo "Usage: $0 <command> <interface> [additional_params...]"
    exit 1
fi

COMMAND="$1"
INTERFACE="$2"
shift 2

# Validate interface exists
if ! ip link show "$INTERFACE" > /dev/null 2>&1; then
    echo "Error: Interface $INTERFACE does not exist"
    exit 1
fi

case "$COMMAND" in
    "apply_netem")
        # Expected parameters: delay delayVar delayVarPct loss lossVar lossPct
        if [ $# -ne 6 ]; then
            echo "Usage: apply_netem <interface> <delay> <delayVar> <delayVarPct> <loss> <lossVar> <lossPct>"
            exit 1
        fi
        DELAY="$1"
        DELAY_VAR="$2"
        DELAY_VAR_PCT="$3"
        LOSS="$4"
        LOSS_VAR="$5"
        LOSS_PCT="$6"
        
        # Build netem command parts
        NETEM_PARTS=""
        
        # Add delay if specified (delay must come first)
        if [ "$DELAY" != "0" ] && [ "$DELAY" != "0.0" ]; then
            DELAY_PART="delay ${DELAY}ms"
            if [ "$DELAY_VAR" != "0" ] && [ "$DELAY_VAR" != "0.0" ]; then
                DELAY_PART="$DELAY_PART ${DELAY_VAR}ms"
                if [ "$DELAY_VAR_PCT" != "0" ] && [ "$DELAY_VAR_PCT" != "0.0" ]; then
                    DELAY_PART="$DELAY_PART ${DELAY_VAR_PCT}%"
                fi
            fi
            NETEM_PARTS="$DELAY_PART"
        fi
        
        # Add packet loss if specified (use correct syntax: loss random PERCENT)
        if [ "$LOSS" != "0" ] && [ "$LOSS" != "0.0" ]; then
            LOSS_PART="loss random ${LOSS}%"
            # Note: tc netem loss random only supports correlation, not variation like delay
            # The variation and percentage parameters from GUI don't directly map to tc syntax
            # For now, we'll use just the base loss percentage
            if [ -n "$NETEM_PARTS" ]; then
                NETEM_PARTS="$NETEM_PARTS $LOSS_PART"
            else
                NETEM_PARTS="$LOSS_PART"
            fi
        fi
        
        # Build and execute the final command
        if [ -n "$NETEM_PARTS" ]; then
            NETEM_CMD="tc qdisc add dev $INTERFACE root netem $NETEM_PARTS"
            echo "Executing: $NETEM_CMD"
            eval $NETEM_CMD
        else
            echo "No network emulation parameters specified"
            exit 1
        fi
        ;;
    "reset")
        tc qdisc del dev "$INTERFACE" root 2>/dev/null || true
        ;;
    *)
        echo "Error: Unknown command $COMMAND"
        exit 1
        ;;
esac

echo "Command executed successfully"
