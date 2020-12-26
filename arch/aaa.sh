#!/bin/bash
a=`echo abbbb`
if [[ $a == *"bb"* ]]; then echo error; fi