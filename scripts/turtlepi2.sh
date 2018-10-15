#!/bin/bash
screen -d -m -S turtlewallet bash -c './turtle-service -w mywallet -p changeme --rpc-password test --bind-port 8070 --bind-address 0.0.0.0 --daemon-address turtlenode.turtlepi.org --daemon-port 11898'
