#!/bin/bash

# nginx 起動 & VNCサーバ起動（親イメージで動く）
service nginx start
/vnc_startup.sh
