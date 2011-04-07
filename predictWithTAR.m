function [S_pred error] = predictWithTAR(S, h, m, tau, As, medoids)
%PREDICTWITHTAR Predict the time series of S with given TAR model
%   S_pred  : predicted time series (shifted left by h)
%   error   : mean squared error measure

[D N] = size(S);
K = size(As, 3); % number of clusters
w = (m-1) * tau; % embedding window

assert(size(As,1) == D, 'Dimensions of As and S incompatible!');
assert(size(As,2) == (m*D), 'm is incompatible with dimensions of As!');

%% estimate variance
sigmasq = ones(D);
for d = 1:D
    sigmasq(d) = (mean(S(d, :).^2) - mean(S(d, :))^2) * N/(N-1);
end

%% construct S_x
S_x = zeros(D*m, N-w-h);
for n = w+1:N-h
    sx_n = [];
    for j = n-w:tau:n
        sx_n = [S(:,j)' sx_n];
    end
    S_x(:, n-w) = sx_n;
end

%% make predictions as horizon h
S_pred = zeros(D, n-w-h);

label = ones(N);
% TODO: for each vector in S_x, determine its cluster label

for n = 1:N-w-h
    S_pred(:, n) = As(:,:,label(n)) * S_x(:, n);
end

%% compute the prediction error
error = 0;
for n = w+1:N-h
    for d = 1:D
        error = error + (1/D) * ((S_pred(d, n-w) - S(d, n+h))^2 )/sigmasq(d);
    end
end
error = error / (N-h-w);

end

