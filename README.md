# Two-Phase Flow Simulation in PEM Electrolyzer Anode Channels

<div align="center">

![OpenFOAM](https://img.shields.io/badge/Solver-OpenFOAM-blue?style=flat-square&logo=openfoam)
![Method](https://img.shields.io/badge/Method-VOF%20%7C%20interFoam-teal?style=flat-square)
![Language](https://img.shields.io/badge/Language-C%2B%2B%20%7C%20Python-informational?style=flat-square)
![Mesh](https://img.shields.io/badge/Mesh-ANSYS%202025R1-red?style=flat-square)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=flat-square)
![Thesis](https://img.shields.io/badge/M.Tech%20Thesis-24MT0344-orange?style=flat-square)

<br/>

> **CFD investigation of gas–liquid two-phase flow dynamics in structured mesh and straight hollow anode channels of a PEM water electrolysis cell, with focus on surface wettability gradients and oxygen bubble removal.**

</div>

---

## Demo


<div align="center">

<!-- STRAIGHT HOLLOW CHANNEL — slug flow development -->
### Straight Hollow Channel · Slug Flow Formation
![Straight hollow channel slug flow GIF](assets/gifs/straight_hollow_channel.gif)
*Oxygen volume fraction field — slug flow development at I = 2.0 A cm⁻² (t = 0 → 5 ms)*

<br/>

<!-- STRUCTURED MESH CHANNEL — dispersed bubble transport -->
### Structured Mesh Channel · Dispersed Bubble Transport
![Structured mesh channel dispersed flow GIF](assets/gifs/structure_mesh_channel.gif)
*Oxygen volume fraction field — dispersed bubble break-up and upward transport (t = 0 → 5 ms)*

<br/>

<!-- GRADIENT WETTABILITY — 150-130-110 best case 
### Gradient Wettability · 150°–130°–110° Configuration
![Gradient contact angle best case GIF](assets/gifs/gradient_150_130_110.gif)
*Directed capillary transport — best-performing wettability gradient configuration*
-->

</div>

---

## Table of Contents

- [Overview](#overview)
- [Physics & Methodology](#physics--methodology)
- [Channel Configurations](#channel-configurations)
- [Wettability Configurations](#wettability-configurations)
- [Computational Setup](#computational-setup)
- [Key Results](#key-results)
- [Project Structure](#project-structure)
- [How to Run](#how-to-run)
- [Dependencies](#dependencies)
- [Results Visualization](#results-visualization)
- [Citation](#citation)

---

## Overview

Oxygen gas generated at the anode catalyst layer of a PEM electrolyzer forms bubbles that accumulate in the anode flow channel, blocking liquid water from reaching the electrode surface. This raises mass-transport overpotential and degrades cell performance at high current densities.

This study uses the **Volume of Fluid (VOF)** method in **OpenFOAM** to investigate:

- Bubble nucleation, growth, coalescence, and slug flow formation in a **straight hollow channel**
- Mechanical bubble splitting and capillary-driven transport in a **structured mesh channel**
- Effect of **uniform skeleton hydrophobicity** (θ = 70°, 90°, 130°) on oxygen discharge
- Effect of **gradient contact angle configurations** (6 cases) on directed capillary transport

All simulations are conducted at a reference current density of **2.0 A cm⁻²** and operating temperature of **353.15 K (80 °C)**.

---

## Physics & Methodology

### Governing Equations

The VOF model solves the following conservation equations for the water–oxygen mixture:

**Continuity**
```
∂ρ/∂t + ∇·(ρU) = 0
```

**Momentum**
```
∂(ρU)/∂t + ∇·(ρUU) = −∇p + µ∇²U + ρg + Fσ
```

**Volume Fraction Transport**
```
∂α/∂t + U·∇α = 0
```

**CSF Surface Tension Force**
```
Fσ = σ · [(ρw + ρO₂) / (2ρref)] · κ · ∇α
```

**Interface Curvature**
```
κ = −∇·(∇α / |∇α|)
```

**Wall Contact Angle Boundary Condition**
```
η_wall = η_w · cos θ + η_t · sin θ
```

### Phase Volume Fraction Interpretation

| α value | Physical state |
|---------|---------------|
| `α = 1` | Pure liquid water |
| `α = 0` | Pure oxygen gas |
| `0 < α < 1` | Gas–liquid interface |

### Mixture Properties

```
ρ_mix  = α·ρ_w   + (1 − α)·ρ_O₂
µ_mix  = α·µ_w   + (1 − α)·µ_O₂
U_mix  = α·U_w   + (1 − α)·U_O₂
```

---

## Channel Configurations

| Parameter | Straight Hollow Channel | Structured Mesh Channel |
|-----------|------------------------|------------------------|
| Channel length | 10.0 mm | 10.0 mm |
| Channel height | 0.6 mm | 0.6 mm |
| Channel width | 0.6 mm | 0.6 mm |
| Skeleton fiber diameter | — | 0.1 mm |
| Skeleton width | — | 0.1 mm |
| Fiber center-to-center (x) | — | 0.3 mm |
| Fiber center-to-center (z) | — | 0.8 mm |
| L/GDL surface contact angle | 90° | 90° |
| Channel wall contact angle | 90° | 90° |

The **structured mesh channel** embeds a repeating fiber skeleton in which each unit cell consists of two perpendicular fibers, forming a 3D lattice that mechanically intercepts growing bubbles and generates capillary pressure gradients.

---

## Wettability Configurations

### Uniform Contact Angle Cases

| Case Label | Top θ | Side θ | Bottom θ | Type |
|-----------|-------|--------|----------|------|
| `SMC-70` | 70° | 70° | 70° | Uniform |
| `SMC-90` | 90° | 90° | 90° | Uniform |
| `SMC-130` | 130° | 130° | 130° | Uniform |

### Gradient Contact Angle Cases

| Case Label | Top θ | Side θ | Bottom θ | Type |
|-----------|-------|--------|----------|------|
| `Grad-70-50-30` | 70° | 50° | 30° | Decreasing ↓ |
| `Grad-110-90-70` | 110° | 90° | 70° | Decreasing ↓ |
| `Grad-150-130-110` | 150° | 130° | 110° | Decreasing ↓ |
| `Grad-30-50-70` | 30° | 50° | 70° | Increasing ↑ |
| `Grad-70-90-110` | 70° | 90° | 110° | Increasing ↑ |
| `Grad-110-130-150` | 110° | 130° | 150° | Increasing ↑ |

> **Note:** L/GDL surface fixed at θ = 70° · Channel walls fixed at θ = 130° across all cases.

---

## Computational Setup

### Operating Conditions

| Parameter | Value |
|-----------|-------|
| Operating temperature | 353.15 K (80 °C) |
| Operating pressure (outlet) | 1.0 atm |
| Reference current density | 2.0 A cm⁻² |
| Liquid water density | 970 kg m⁻³ |
| Oxygen gas density | 1.42 kg m⁻³ |
| Liquid water viscosity | 2.414 × 10⁻⁵ × 10^(247.8/(T−140)) kg m⁻¹s⁻¹ |
| Oxygen viscosity | 2.34 × 10⁻⁵ N s m⁻² |
| Surface tension coefficient | 0.0625 N m⁻¹ |
| Gravitational acceleration | 9.81 m s⁻² |

### Boundary Conditions

| Boundary | Type | Value |
|----------|------|-------|
| Channel initial state | Initial condition | α_water = 1.0, α_oxygen = 0.0 |
| Water inlet | Velocity inlet | Constant; α_water = 1.0 |
| Channel outlet | Pressure outlet | 1.0 atm (101,325 Pa) |
| Channel top & side walls | No-slip + contact angle | u = 0; θ = 130° |
| L/GDL surface (channel bottom) | Mass flux inlet (O₂) | Constant O₂ flux; θ = 70° |
| Skeleton fiber surfaces | No-slip + contact angle | u = 0; θ varies (see table above) |

### Numerical Schemes

| Setting | Choice |
|---------|--------|
| Solver | `interFoam` (OpenFOAM) |
| Interface scheme | MULES (bounded VOF) |
| Pressure–velocity coupling | PISO algorithm |
| Spatial discretization | Second-order |
| Time integration | First-order implicit (Euler) |
| Adaptive time stepping | Courant number Co ≤ 0.5 |
| Mesh type | Structured hexahedral |
| Grid independence threshold | < 2% variation in S_g^avg |

---

## Key Results

### 1 · Channel Comparison at I = 2.0 A cm⁻²

| Metric | Straight Hollow | Structured Mesh |
|--------|----------------|----------------|
| Quasi-steady L/GDL O₂ saturation | 0.70 – 0.90 | 0.20 – 0.25 |
| Flow regime | Slug / annular | Dispersed bubble |
| Pressure drop (t = 5 ms) | ~5 Pa | ~110 Pa |
| Time to quasi-steady state | 40 – 80 ms | ~50 ms |

### 2 · Effect of Uniform Skeleton Contact Angle

```
L/GDL oxygen saturation (quasi-steady):

  θ = 70°  ████████████████████░░░  High
  θ = 90°  █████████████░░░░░░░░░░  Medium
  θ = 130° ██████░░░░░░░░░░░░░░░░░  Low  ← Best uniform case
```

### 3 · Best Gradient Configuration: `Grad-150-130-110`

- **Lowest quasi-steady oxygen saturation** of all 9 configurations tested
- Directed capillary gradient pulls bubbles upward while maintaining water supply at the electrode
- Outperforms uniform 130° case despite similar average contact angle
- **Pressure drop unchanged** — wettability optimization is hydraulically cost-free

### 4 · Gradient Direction Matters

```
Decreasing gradient (hydrophobic top → hydrophilic bottom):
  ↑ Drives O₂ upward → lower L/GDL saturation ✓

Increasing gradient (hydrophilic top → hydrophobic bottom):
  ↓ Pushes O₂ toward L/GDL → higher saturation ✗
```

---

## Project Structure

```
pem-electrolyzer-vof/
│
├── 0/                          # Initial & boundary conditions
│   ├── alpha.water             # Volume fraction field
│   ├── U                       # Velocity field
│   └── p_rgh                   # Modified pressure field
│
├── constant/
│   ├── transportProperties     # Fluid properties (density, viscosity, σ)
│   ├── g                       # Gravitational acceleration
│   └── triSurface/             # STL geometry files
│       ├── straight_channel.stl
│       └── structured_mesh_channel.stl
│
├── system/
│   ├── controlDict             # Solver settings, time step, Co max
│   ├── fvSchemes               # Discretization schemes
│   ├── fvSolution              # PISO settings, tolerances
│   └── MeshFileAsAnsysFluentInput           # Mesh generation
│
├── cases/
│   ├── straight_hollow/        # Baseline straight channel case
│   ├── SMC-70/                 # Uniform θ = 70°
│   ├── SMC-90/                 # Uniform θ = 90°
│   ├── SMC-130/                # Uniform θ = 130°
│   ├── Grad-70-50-30/
│   ├── Grad-110-90-70/
│   ├── Grad-150-130-110/       # Best performing case
│   ├── Grad-30-50-70/
│   ├── Grad-70-90-110/
│   └── Grad-110-130-150/
│
├── postProcessing/
│   ├── oxygen_saturation/      # L/GDL surface S_g^avg time series
│   ├── pressure_drop/          # Inlet–outlet ΔP data
│   └── vof_snapshots/          # Volume fraction field dumps
│
├── scripts/
│   ├── run_all_cases.sh        # Batch submission script
│   ├── plot_saturation.py      # Time-history plots (matplotlib)
│   ├── plot_pressure_drop.py   # Bar chart comparisons
│   └── extract_vof_snapshots.py
│
├── assets/
│   ├── gifs/                   # ← Place simulation GIFs here
│   │   ├── straight_channel_slug_flow.gif
│   │   ├── structured_mesh_dispersed.gif
│   │   └── gradient_150_130_110.gif
│   └── figures/
│       ├── channel_geometry.png
│       ├── mesh_structured.png
│       └── boundary_conditions.png
│
├── mesh/
│   ├── straight_channel.msh    # Exported from ANSYS Meshing 2025 R1
│   └── structured_mesh.msh
│
└── README.md
```

---

## How to Run

### Prerequisites

```bash
# Verify OpenFOAM installation (v10 or ESI v2206+)
openfoam --version
blockMesh --version
```

### Step 1 · Generate the Mesh

```bash
cd cases/structured_mesh_SMC-130
blockMesh
checkMesh
```

### Step 2 · Set Initial Conditions

```bash
# Channel fully filled with liquid water at t = 0
setFields
```

### Step 3 · Run the Simulation

```bash
# Single case
interFoam > log.interFoam 2>&1 &

# Monitor convergence
tail -f log.interFoam | grep "Courant"
```

### Step 4 · Run All Cases (Batch)

```bash
chmod +x scripts/run_all_cases.sh
./scripts/run_all_cases.sh
```

### Step 5 · Post-Process Results

```bash
# Extract oxygen saturation at L/GDL surface
postProcess -func "surfaceFieldValue" -latestTime

# Plot time histories
python3 scripts/plot_saturation.py

# Visualize in ParaView
paraFoam &
```

---

## Dependencies

| Tool | Version | Purpose |
|------|---------|---------|
| OpenFOAM | v10 / ESI v2206 | CFD solver (interFoam) |
| ANSYS Meshing | 2025 R1 | Mesh generation |
| ParaView | 5.11+ | 3D visualization & GIF export |
| Python | 3.9+ | Post-processing & plotting |
| NumPy | ≥ 1.24 | Numerical operations |
| Matplotlib | ≥ 3.7 | Result plots |
| pandas | ≥ 2.0 | Data handling |

Install Python dependencies:

```bash
pip install numpy matplotlib pandas scipy
```

---

## Results Visualization

### Generating GIFs from ParaView

1. Open ParaView → `File > Load State` → select `assets/paraview_state.pvsm`
2. Set the color map to `alpha.water` (blue = water, red = oxygen)
3. `File > Save Animation` → export as `.gif` or `.mp4`
4. Place output files in `assets/gifs/`

### Key Output Variables

| Variable | Description |
|----------|-------------|
| `alpha.water` | Water volume fraction field (0 = O₂, 1 = H₂O) |
| `p_rgh` | Dynamic pressure field |
| `U` | Mixture velocity vector field |
| `S_g_avg` | Time-averaged L/GDL surface oxygen saturation |
| `delta_P` | Inlet–outlet pressure drop |

---


---

## Acknowledgements

This work was carried out as part of the M.Tech thesis program. Simulations were performed using the open-source CFD platform OpenFOAM. Mesh generation was done using ANSYS Meshing 2025 R1. The structured mesh channel design is inspired by the work of Wu et al. on fiber skeleton geometries in PEMEC anode channels.

---

<div align="center">

**24MT0344 · M.Tech Thesis · CFD & Multiphase Flow**

</div>
