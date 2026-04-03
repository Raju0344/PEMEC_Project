#!/bin/bash

# Function: Replace parameters
modify_case() {
    caseDir=$1
    CA=$2

    sed -i "s/CA_VALUE/$CA/g" $caseDir/0/alpha.water
}

# Function: Run simulation
run_case() {
    caseDir=$1
    np=$2

    cd $caseDir || exit

    echo "Running case: $caseDir"

    decomposePar > log.decompose

    mpirun --oversubscribe -np $np interFoam -parallel > log.solver 2>&1

    reconstructPar > log.reconstruct

    cd - || exit
}

# Function: Extract results
post_process() {
    caseDir=$1

    cd $caseDir || exit

    foamToVTK > log.vtk

    cd - || exit
}


