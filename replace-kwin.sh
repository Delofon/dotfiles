#!/usr/bin/env bash

systemctl --user mask plasma-kwin_x11
systemctl --user daemon-reload
systemctl --user enable plasma-i3

