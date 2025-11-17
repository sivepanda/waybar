#!/bin/bash

ddcutil getvcp 10 \
  | sed -n 's/.*current value = *\([0-9]\+\).*/\1/p'

