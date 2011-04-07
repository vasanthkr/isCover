%% Initialization
clear;
load 'testPair';    % S_a, S_b
N = size(S_a, 2);   % Frames in time-series
D = 12;             % Descriptor length
h = 2;              % Prediction horizon

%% Learn optimal TAR coefficients
[m tau K As medoids] = bestTAR(S_a, h);

fprintf('Best parameters:\n');
fprintf('  m   = %d\n', m);
fprintf('  tau = %d\n', tau);
fprintf('  K   = %d\n', K);

%% Compute optimal transposition
% temporary
S_b = circshift(S_a, [4 0]);

[S_bt OTI] = musicalTranspose(S_b, S_a);

%% Predict S_b using As and compute errors
[~, error] = predictWithTAR(S_bt, h, m, tau, As, medoids);
error