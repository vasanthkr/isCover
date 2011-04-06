%% Initialization
clear;
load 'testPair';    % S_a
N = size(S_a, 2);   % Frames in time-series
D = 12;             % Descriptor length
h = 2;              % Prediction horizon

[m tau K As medoids] = bestTAR(S_a, h);

fprintf('Best parameters:\n');
fprintf('  m   = %d\n', m);
fprintf('  tau = %d\n', tau);
fprintf('  K   = %d\n', K);

