#!/bin/zsh
test_func(){
    func_a=$1
    func_b=$2
    func_c=$(( $func_a + $func_b ))
    return func_c
}

test_func 12 34