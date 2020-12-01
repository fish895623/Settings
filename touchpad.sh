#!/bin/bash

DEV=13

enabled=$(xinput list-props $DEV | awk '/^\tDevice Enabled \([0-9]+\):\t[01]/ {print $NF}')
case $enabled in                                                                
  0)     
    xinput enable "$DEV"                                                                       
    ;;                                                                          
  1)                                                                            
    xinput disable "$DEV"
    ;;                                                                          
esac
