#!/usr/bin/env bash

freshclam && clamscan --infected --recursive /data
