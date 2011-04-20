function [ m_best tau_best K_best alpha_best As_best medoids_best ] = bestRBF(S, h)
%BESTTAR Summary of this function goes here
%   Detailed explanation goes here

[D N] = size(S);

% space of values for grid search
m_range = [2 3 4 5 7 9 12 15];
tau_range = [1 2 6 9 15];
K_range = [2 3 4 5 6 7 8 9 10 12 15 20 30 40 50];
alpha_range = [0.5 0.75 1 1.25 1.5 2 2.5 3 3.5 4 5 7 9];

% initialize default best values
m_best = -1;
tau_best = -1;
K_best = -1;
alpha_best = -1;
B_best = [];
medoids_best = [];
error_best = inf;


%% estimate variance

eraseLength = 0;
%% grid-search over parameter space
for m = m_range
    for tau = tau_range
        
        
        w = (m-1) * tau; % embedding window
        
        sigmasq = ones(1,D);
        
        %vectorLength =  N-w+h;
        for d = 1:D
            %sigmasq(d) = (mean(S(d, w+h+1:N).^2) - mean(S(d, w+h+1:N))^2) * vectorLength/(vectorLength-1);
            sigmasq(d) = var(S(d,w+h+1:N));
        end
        
        
        % construct S_x
        S_x = zeros(D*m, N-w-h);
        for n = w+1:N-h
            sx_n = [];
            for j = n-w:tau:n
                sx_n = [S(:,j)' sx_n];
            end
            S_x(:, n-w) = sx_n;
        end
        
        for alpha = alpha_range
            for K = K_range
                
                % compute the TAR coefficients
                [B medoids label rho] = modelRBF(S(:, w+1+h:N), S_x, K, alpha);
                
                % make predictions at horizon h
                S_pred = zeros(D, N-w-h);
                
                for n = 1:N-w-h
                    Phi_n = zeros(1,K+1);
                    Phi_n(1) = 1;
                    for i=1:K
                        Phi_n(i+1) = phi(norm(S_x(:,n)-medoids(:,i),2),alpha,rho(i));
                    end
                
                    S_pred(:,n) = B * Phi_n';
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
                
                for i=1:eraseLength
                    fprintf('\b');
                end
                eraseLength = fprintf('[%2d|%2d|%2d] error: %2.5f\r', m, tau, K, error);
                
                % if smaller error, update best values
                if (error < error_best)
                    
                    % debug
                    %    fprintf('*');
                    
                    error_best = error;
                    m_best = m;
                    tau_best = tau;
                    K_best = K;
                    alpha_best = alpha;
                    B_best = B;
                    medoids_best = medoids;
                end
                
                %debug
                %fprintf('\n');
            end
        end % K_range
    end % tau_range
end % m_range

end

