%% plot_qm_rifs_panels.m
% Plotting script for QM-RIFS paper figures.
%
% Inputs expected in workspace:
%   S      : maxDepth x N   (cumulative Born masses)
%   S_log  : maxDepth x N   (log-masses = log(S))
%
% Usage:
%   [S, S_log] = Simulate_QM_RIFS_Born_Sampled(30, 1e4, [0.5 0.5], 0.9, 0.6, 0.5);
%   plot_qm_rifs_panels
%
% Notes:
% - S should be in (0,1], decreasing along each column.
% - S_log should be <= 0, decreasing toward -Inf.

%% ---- checks ----
assert(exist('S','var') == 1, 'Variable S not found in workspace.');
assert(exist('S_log','var') == 1, 'Variable S_log not found in workspace.');

[maxDepth, N] = size(S);
assert(all(size(S_log) == [maxDepth, N]), 'S_log must match size(S).');

% Robust handling of -Inf in log masses (can occur if any pi_out = 0)
finiteMask = isfinite(S_log);

%% ---- Figure 1: Mean contraction <log S(k,.)> (and optional <S(k,.)>) ----
k = (1:maxDepth).';

meanLogS = nan(maxDepth,1);
meanS    = nan(maxDepth,1);

for kk = 1:maxDepth
    valsLog = S_log(kk, finiteMask(kk,:));
    if ~isempty(valsLog)
        meanLogS(kk) = mean(valsLog);
    end

    valsS = S(kk, :);
    % If any exact zeros exist, mean is still fine; keep as-is
    meanS(kk) = mean(valsS);
end

fig1 = figure(1); clf(fig1);
plot(k, meanLogS, 'LineWidth', 2);
xlabel('Iteration k', 'FontSize', 14);
ylabel('<log S(k, \cdot)>', 'FontSize', 14);
title('Mean log-mass contraction', 'FontSize', 14);
grid on;

% % Optional: also show <S(k,.)> on same figure as dashed line (comment out if undesired)
% hold on;
% plot(k, meanS, '--', 'LineWidth', 2);
% legend({'<log S(k,\cdot)>','<S(k,\cdot)>'}, 'Location', 'best');
% hold off;

%% ---- Figure 2: Terminal log-mass histogram ----
terminalLog = S_log(end, :);
terminalLog = terminalLog(isfinite(terminalLog));

fig2 = figure(2); clf(fig2);
histogram(terminalLog, 200);  % 200 bins is usually plenty; adjust if needed
xlabel('log S(k_{max}, \cdot)', 'FontSize', 14);
ylabel('Count', 'FontSize', 14);
title('Terminal log-mass distribution', 'FontSize', 14);
grid on;

%% ---- Figure 3: Multifractal scaling exponent tau(q) ----
% q-range: fine sampling
qvals = linspace(-4, 4, 801);

% Use terminal masses S(end,:) (not logs) for tau(q) moments
p = S(end, :);
p = p(:)';  % row vector

% Avoid issues for negative q when p contains zeros
% If zeros can occur, replace with a small floor based on smallest positive value
pPos = p(p > 0);
if isempty(pPos)
    error('All terminal masses are zero; cannot compute tau(q).');
end
pFloor = min(pPos);
pSafe  = max(p, pFloor);  % ensures pSafe > 0 everywhere

tau = zeros(size(qvals));

for ii = 1:numel(qvals)
    q = qvals(ii);

    % Generalized moment E[p^q]
    Mq = mean(pSafe.^q);

    % Guard: if Mq is non-finite (can happen for large negative q), clip safely
    if ~isfinite(Mq) || Mq <= 0
        tau(ii) = NaN;
    else
        tau(ii) = -log(Mq) / log(maxDepth);
    end
end

fig3 = figure(3); clf(fig3);
plot(qvals, tau, 'LineWidth', 2);
xlabel('q', 'FontSize', 14);
ylabel('\tau(q)', 'FontSize', 14);
title('Multifractal scaling exponent \tau(q)', 'FontSize', 14);
grid on;
