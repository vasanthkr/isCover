function [ m_best tau_best K_best As medoids ] = bestTAR(S, h)
%BESTTAR Summary of this function goes here
%   Detailed explanation goes here

[D N] = size(S);

% space of values for grid search
m_range = [1 2 3 4 5 7 9 12 15];
tau_range = [1 2 6 9 15];
K_range = [1 2 3 4 5 6 7 8 9 10 12 15 20 30 40 50];

for m = m_range
    for tau = tau_range       
        w = (m-1) * tau; % embedding window
        
        % construct S_x
        S_x = zeros(D*m, N-w-h);
        for n = w+1:N-h
            sx_n = [];
            for j = n-w:tau:n
                sx_n = [S(:,j)' sx_n];
            end
            S_x(:, n-w) = sx_n;
        end
        
        for K = K_range        
            % compute the TAR coefficients
            [As medoids] = modelTAR(S(:, w+1+h), S_x, K);
            
            % TODO
            
        end % K_range
    end % tau_range
end % m_range

end

