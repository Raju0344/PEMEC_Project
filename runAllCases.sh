#!/bin/bash

# Detect total cores
total_cores=$(nproc)

# Use slightly less than max for safe.
np=$((total_cores - 2))

echo "Using $np processors out of $total_cores available"

# ==============================
# CASE 1: STRAIGHT HOLLOW CHANNEL
# ==============================
cd PEMEC_straight_hollow_channel || exit

echo "Running Case 1: Straight Channel"

# Update decomposeParDict automatically
sed -i "s/numberOfSubdomains.*/numberOfSubdomains $np;/" system/decomposeParDict

decomposePar > log.decompose
mpirun --oversubscribe -np $np interFoam -parallel > log.solver 2>&1
reconstructPar > log.reconstruct

cd ..

# ==============================
# CASE 2: STRUCTURED MESH CHANNEL
# ==============================
cd PEMEC_structured_mesh_channel || exit

echo "Running Case 2: Structured Mesh"

# Update decomposeParDict automatically
sed -i "s/numberOfSubdomains.*/numberOfSubdomains $np;/" system/decomposeParDict

decomposePar > log.decompose
mpirun --oversubscribe -np $np interFoam -parallel > log.solver 2>&1
reconstructPar > log.reconstruct

cd ..

# ==============================
# CASE 3: DIFFERENT HYDROPHOBICITY
# ==============================
cd PEMEC_structured_mesh_channel_different_skeleton_hydrophobicity || exit

echo "Running Case 3: Different Hydrophobicity"

./runAll.sh

cd ..

echo "ALL CASES COMPLETED"
