#!/bin/sh

release_ctl eval --mfa "LibTen.ReleaseTasks.migrate/0" -- "$@"
