function [S_pred error] = predictWithRBF(S, h, m, tau, alpha,B, medoids, rho)
%PREDICTWITHTAR Predict the time series of S with given TAR model
%   S_pred  : predicted time series (shifted left by h)
%   error   : mean squared error measure

[D N] = size(S);
K = size(medoids,2); % number of clusters
w = (m-1) * tau; % embedding window

%assert(size(As,1) == D, 'Dimensions of As and S incompatible!');
%assert(size(As,2) == (m*D), 'm is incompatible with dimensions of As!');

%% estimate variance
sigmasq = ones(1,D);

for d = 1:D
    sigmasq(d) = var(S(d,w+h+1:N));
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
S_pred = zeros(D, N-w-h);
                
for n = 1:N-w-h
    Phi_n = zeros(1,K+1);
    Phi_n(1) = 1;
    for i=1:K
        Phi_n(i+1) = phi(norm(S_x(:,n)-medoids(:,i),2),alpha,rho(i));
    end
    
    S_pred(:,n) = B * Phi_n';
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

