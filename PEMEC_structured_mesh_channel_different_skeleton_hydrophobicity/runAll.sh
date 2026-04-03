#!/bin/bash

source functions.sh

# PARAMETERS (EDIT FOR YOUR STUDY)
contactAngles=(70 130)

# Detect total cores
total_cores=$(nproc)

# Use slightly less than max for safe.
np=$((total_cores - 2))

echo "Using $np processors out of $total_cores available"

mkdir -p cases

for CA in "${contactAngles[@]}"
do
	caseName="case_CA${CA}"
	caseDir="cases/$caseName"

	echo "================================="
	echo "Creating $caseName"
	echo "================================="

	cp -r baseCase $caseDir

	modify_case $caseDir $CA
	
	# Update decomposeParDict automatically
	sed -i "s/numberOfSubdomains.*/numberOfSubdomains $np;/" $caseDir/system/decomposeParDict

	run_case $caseDir $np

	# post_process $caseDir

done

echo "ALL SIMULATIONS COMPLETED"

