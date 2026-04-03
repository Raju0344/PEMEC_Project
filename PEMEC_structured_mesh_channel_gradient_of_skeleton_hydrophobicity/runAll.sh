#!/bin/bash

source functions.sh

# PARAMETERS (EDIT FOR YOUR STUDY)
velocities=(0.1 0.2 0.5)
contactAngles=(120 140 160)

np=4   # number of processors

mkdir -p cases

for U in "${velocities[@]}"
do
    for CA in "${contactAngles[@]}"
    do
        caseName="case_U${U}_CA${CA}"
        caseDir="cases/$caseName"

        echo "================================="
        echo "Creating $caseName"
        echo "================================="

        cp -r baseCase $caseDir

        modify_case $caseDir $U $CA

        run_case $caseDir $np

        post_process $caseDir

    done
done

echo "ALL SIMULATIONS COMPLETED"

