#!/bin/bash

# Accept input file or stream from bash argument
if [ "$1" ]; then
    input="$1"
    output_dir="output"
    
    # Create output directory if it doesn't exist
    mkdir -p "$output_dir"
    
    # Start RTMP streaming without showing logs
    ffmpeg -re -stream_loop -1 -i "$input" -c:v copy -c:a aac -strict experimental -f flv rtmp://localhost/live/test >/dev/null 2>&1 &
    
    # Store the output file in the output folder without showing logs
    ffmpeg -i rtmp://localhost/live/test -c:v libx264 -c:a aac -strict -2 -f hls -hls_time 10 -hls_playlist_type event "$output_dir/output.m3u8" >/dev/null 2>&1 &
    
    # Delete files older than 10 minutes (600 seconds) without showing logs
    find "$output_dir" -type f -mmin +10 -delete >/dev/null 2>&1
    
else
    echo "Please provide the input video/stream"
fi
