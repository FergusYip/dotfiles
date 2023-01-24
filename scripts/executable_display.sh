#!/bin/sh

layout="$1"

if [ -z "$layout" ]; then
    echo "Please provide a layout, e.g. 'left', 'top'" >&2
    exit 1
fi

if [ "$layout" = "left" ]; then
    displayplacer "id:4C4B0E7D-043B-4D0D-8983-22BE5F416A1C res:2560x1440 hz:60 color_depth:8 scaling:off origin:(0,0) degree:0" "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1728x1117 hz:120 color_depth:8 scaling:on origin:(2560,323) degree:0"
elif [ "$layout" = "top" ]; then
    displayplacer "id:4C4B0E7D-043B-4D0D-8983-22BE5F416A1C res:2560x1440 hz:60 color_depth:8 scaling:off origin:(0,0) degree:0" "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1728x1117 hz:120 color_depth:8 scaling:on origin:(423,1440) degree:0"
fi

