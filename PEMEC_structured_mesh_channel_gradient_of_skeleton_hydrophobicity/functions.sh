#!/bin/bash

# Function: Replace parameters
modify_case() {
    caseDir=$1
    U=$2
    CA=$3

    sed -i "s/U_INLET/$U/g" $caseDir/0/U
    sed -i "s/CA_VALUE/$CA/g" $caseDir/constant/transportProperties
}

# Function: Run simulation
run_case() {
    caseDir=$1
    np=$2

    cd $caseDir || exit

    echo "Running case: $caseDir"

    decomposePar > log.decompose

    mpirun -np $np interFoam -parallel > log.solver 2>&1

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


