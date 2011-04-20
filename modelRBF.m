function [B medoids label rho] = modelRBF(S, S_x, K, alpha)
%MODELRBF Find RBF coefficients for a given time series
%   S(D x N')   : time series of descriptors.
%   S_x(MD x N'): time series of history-concatenated descriptors.
%                 (where N' = N - w - h)
%   K           : number of clusters

[D N] = size(S);
%% Cluster columns of S_x into K clusters
[label, ~, medIndex] = kmedoids(S_x, K);

%%calculate rho
rho = zeros(K,1);
for i=1:K
    A = pdist(S_x(:, label==i)');
    A2 = squareform(A);
    rho(i) = mean(mean(A2));
end

%% Filter the K medoids
medoids = S_x(:, medIndex);

%% Find AR clusters for each clusters

Phi = zeros(K+1,N);
for n=1:N
    Phi(1,n) = 1;
    for k=2:K+1
        Phi(k,n) = phi(norm(S_x(:,n)-medoids(:,k-1),2),alpha,rho(k-1));
    end
end

%B = zeros(size(S, 1), K+1);
B = (Phi' \ S')';

end

