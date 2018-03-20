#!/usr/bin/env bash

ssh -L 5901:localhost:5901 -N -f %1
