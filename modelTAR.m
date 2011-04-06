function [As medoids label] = modelTAR(S, S_x, K)
%MODELTAR Find TAR coefficients for a given time series
%   S_a(D x N') : time series of descriptors.
%   S_x(MD x N'): time series of history-concatenated descriptors.
%                 (where N' = N - w - h)
%   K           : number of clusters

%% Cluster columns of S_x into K clusters
[label, ~, medIndex] = kmedoids(S_x, K);

%% Find AR clusters for each clusters
As = zeros(size(S, 1), size(S_x, 1), K);
for k = 1:K
    As(:, :, k) = (S_x(:,(label==k))' \ S(:, (label==k))')';
end

%% Filter the K medoids
medoids = S_x(:, medIndex);

end

