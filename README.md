# Quantum Measurement as a Random Iterated Function System (RIFS)

This repository contains code and data supporting the figures in the manuscript:

**"Quantum Measurement is a Random Iterated Function System"**  
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

## Using the provided dataset
load('data/QM_is_a_RIFS_Data.mat');  % should load S and S_log (and/or parameters)
run('scripts/plot_qm_rifs_panels.m');

## Notes on Parameters
- `maxDepth` = number of measurement steps (k)
- `nPaths` = number of sampled histories (N)
- `lambda_Z`, `mu_X` are likelihood weights for the two measurement settings
- `pZ` is the probability of choosing the Z-setting at each step (else X)

## Citation
Create a file `CITATION.cff`:

```yaml
cff-version: 1.2.0
message: "If you use this code/data, please cite the associated manuscript."
type: software
title: "Quantum Measurement as a Random Iterated Function System (RIFS) — code and data"
authors:
  - family-names: Hudnall
    given-names: Kevin
license: MIT
repository-code: https://github.com/<YOUR_GITHUB_USERNAME>/<REPO_NAME>
