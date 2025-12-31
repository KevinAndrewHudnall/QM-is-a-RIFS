# Quantum measurement defines a Random Iterated Function System (RIFS)

This repository contains code and data supporting the figures in the manuscript:

**"Quantum measurement defines a Random Iterated Function System"**  
Kevin Hudnall

## Contents
- `src/Simulate_QM_RIFS_Born_Sampled.m` — simulates sampled measurement histories and returns `S` and `S_log`
- `scripts/plot_qm_rifs_panels.m` — generates the three panels used in the paper:
  - mean contraction ⟨log S(k,·)⟩
  - terminal log-mass histogram log S(k_max,·)
  - multifractal scaling exponent τ(q)
- `data/QM_is_a_RIFS_Data.mat` — data used for the manuscript figure(s)

## Requirements
- MATLAB R2019b or newer should work (no toolboxes required).

## Quickstart (reproduce the plots)
From the repo root:

```matlab
addpath('src');
[S, S_log] = Simulate_QM_RIFS_Born_Sampled(30, 1e4, [0.5 0.5], 0.9, 0.6, 0.5);
run('scripts/plot_qm_rifs_panels.m');
