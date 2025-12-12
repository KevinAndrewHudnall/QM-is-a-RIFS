function [S, S_log] = Simulate_QM_RIFS_Born_Sampled(maxDepth, nPaths, p0, lambda_Z, mu_X, pZ)
% Simulate_QM_RIFS_Born_Sampled
% ------------------------------
% Sample nPaths quantum measurement branches of length maxDepth.
%
% OUTPUTS (column-oriented):
%   S      : maxDepth x nPaths
%            Column b is one branch.
%            S(k,b) = cumulative Born mass up to step k along branch b.
%            Values in (0,1], monotonically decreasing in k for each column.
%
%   S_log  : maxDepth x nPaths
%            S_log(k,b) = log S(k,b).
%            Non-positive, decreasing toward -inf (entropy-like).
%
% INPUTS:
%   maxDepth : number of measurement steps per path
%   nPaths   : number of sampled branches (e.g. 1e4)
%   p0       : 1x2 initial probability vector [p0 p1]
%   lambda_Z : bias parameter for Z-setting
%   mu_X     : bias parameter for X-setting
%   pZ       : probability of choosing Z-setting (else X-setting)

    if nargin < 1 || isempty(maxDepth), maxDepth = 30; end
    if nargin < 2 || isempty(nPaths),   nPaths   = 1e4; end
    if nargin < 3 || isempty(p0),       p0       = [0.5, 0.5]; end
    if nargin < 4 || isempty(lambda_Z), lambda_Z = 0.9; end
    if nargin < 5 || isempty(mu_X),     mu_X     = 0.6; end
    if nargin < 6 || isempty(pZ),       pZ       = 0.5; end

    % Normalize initial state
    p0 = p0(:)' ./ sum(p0);

    % Simple likelihood vectors for two "measurement settings"
    l_Z = [lambda_Z, 1 - lambda_Z];
    l_X = [mu_X,     1 - mu_X];

    % Preallocate: rows = depth, cols = paths
    S     = zeros(maxDepth, nPaths);
    S_log = zeros(maxDepth, nPaths);

    for b = 1:nPaths
        p       = p0;
        mass    = 1;     % start with unit mass
        logMass = 0;     % log(1) = 0

        for k = 1:maxDepth
            % Choose setting (Z or X)
            if rand < pZ
                l_vec = l_Z;
            else
                l_vec = l_X;
            end

            % Sample outcome 0 or 1 based on current p
            outcome = (rand >= p(1));   % 0 w.p. p(1), 1 w.p. p(2)
            idx     = outcome + 1;

            % Born probability of this outcome under this setting
            pi_out = p(idx) * l_vec(idx);

            if pi_out <= 0
                mass    = 0;
                logMass = -Inf;
            else
                mass    = mass    * pi_out;
                logMass = logMass + log(pi_out);
            end

            % Update state p via normalized Born-like update
            weights = p .* l_vec;
            Z_norm  = sum(weights);
            if Z_norm > 0
                p = weights / Z_norm;
            else
                p = [0.5, 0.5];
            end

            % Store: depth k, branch b
            S(k,b)     = mass;
            S_log(k,b) = logMass;
        end
    end
end
