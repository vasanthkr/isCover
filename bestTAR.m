function [ m_best tau_best K_best As_best medoids_best ] = bestTAR(S, h)
%BESTTAR Summary of this function goes here
%   Detailed explanation goes here

[D N] = size(S);

% space of values for grid search
m_range = [2 3 4 5 7 9 12 15];
tau_range = [1 2 6 9 15];
K_range = [2 3 4 5 6 7 8 9 10 12 15 20 30 40 50];

% initialize default best values
m_best = -1;
tau_best = -1;
K_best = -1;
As_best = [];
medoids_best = [];
error_best = inf;


%% estimate variance
sigmasq = ones(D);
for d = 1:D
    sigmasq(d) = (mean(S(d, :).^2) - mean(S(d, :))^2) * N/(N-1);
end

%% grid-search over parameter space
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
            [As medoids label] = modelTAR(S(:, w+1+h:N), S_x, K);
            
            % make predictions at horizon h
            S_pred = zeros(D, n-w-h);
            for n = 1:N-w-h
                S_pred(:, n) = As(:,:,label(n)) * S_x(:, n);
            end
            
            error = 0;
            
            % compute the prediction error
            for n = w+1:N-h
                for d = 1:D
                    error = error + (1/D) * ((S_pred(d, n-w) - S(d, n+h))^2 )/sigmasq(d);
                end
            end
            error = error / (N-h-w);
            
            % debug
            %fprintf('[%2d|%2d|%2d] error: %2.5f', m, tau, K, error);
            
            % if smaller error, update best values
            if (error < error_best)
                
                % debug
            %    fprintf('*');
                
                error_best = error;
                m_best = m;
                tau_best = tau;
                K_best = K;
                As_best = As;
                medoids_best = medoids;
            end
            
            %debug
            %fprintf('\n');
        end % K_range
    end % tau_range
end % m_range

end

