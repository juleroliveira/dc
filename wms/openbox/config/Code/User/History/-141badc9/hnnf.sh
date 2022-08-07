#!/bin/bash

echo $(ip a | grep 'scope global dynamic noprefixroute' | awk '{print $2}' | head -1)

