clear;
warning off all;

%% initialization
load FBigData;

numOfFiles = size(files,1);
D = 12;             % Descriptor length
h = 10;             % Prediction horizon
ksi_TAR = zeros(numOfFiles,numOfFiles);
ksi_RBF = zeros(numOfFiles,numOfFiles);

% correct
temp = S_a{8};
S_a{8} = S_a{6};
S_a{6} = temp;
temp = files{8};
files{8} = files{6};
files{6} = temp;


%% compute the relevance matrix
rel = zeros(numOfFiles, numOfFiles);
rel(1:6, 1:6) = 1;
rel(7:11, 7:11) = 1;
rel(12:17, 12:17) = 1;
rel(18:26, 18:26) = 1;
rel(27:33, 27:33) = 1;
rel(34:37, 34:37) = 1;
rel(38:45, 38:45) = 1;
rel(46:53, 46:53) = 1;
rel(54:62, 54:62) = 1;
rel(63:66, 63:66) = 1;


%% do pairwise comparison
for i = 1:numOfFiles
    fprintf('Base song (%d/66): %s\n',i,files{i});
    curS_a = S_a{i};
    N = size(curS_a, 2);   % Frames in time-series
    
    % Learn optimal coefficients
    [m_TAR tau_TAR K_TAR As medoids_TAR] = bestTAR(curS_a, h);
    [m_RBF tau_RBF K_RBF alpha B medoids_RBF rho] = bestRBF(curS_a, h);
     
    %fprintf('Best parameters:\n');
    %fprintf('  m_TAR   = %d\n', m);
    %fprintf('  tau = %d\n', tau);
    %fprintf('  K   = %d\n', K);
    
    for j = 1:numOfFiles
        fprintf('$');
        %fprintf('Song to compare: %s\n',files{j});
        curS_b = S_a{j};
        
        % Compute optimal transposition
        [S_bt OTI] = musicalTranspose(curS_b, curS_a);
        
        % Predict S_b and compute errors
        [~, err_TAR] = predictWithTAR(S_bt, h, m_TAR, tau_TAR, As, medoids_TAR);
        [~, err_RBF] = predictWithRBF(S_bt, h, m_RBF, tau_RBF, alpha, B, medoids_RBF, rho);
        
        % write to ksi
        ksi_TAR(i,j) = err_TAR;
        ksi_RBF(i,j) = err_RBF;
        
        %fprintf('Prediction error: %2.5f\n', error(num));
    end
end

%% Compute MAP
diss_TAR = ksi_TAR + ksi_TAR';
diss_RBF = ksi_RBF + ksi_RBF';

%diss_TAR = ksi_TAR;
%diss_RBF = ksi_RBF;

% create a relevance matrix;;
% rel(i,j)

for i = 1:numOfFiles
    unsorted_TAR = diss_TAR(:, i);
    unsorted_RBF = diss_RBF(:, i);
    unsorted_TAR(i) = [];
    unsorted_RBF(i) = [];
    
    unsorted_r = rel(:, i);
    unsorted_r(i) = [];
    
    [sorted_TAR IX_TAR] = sort(unsorted_TAR);
    [sorted_RBF IX_RBF] = sort(unsorted_RBF);
    sorted_r_TAR = unsorted_r(IX_TAR);
    sorted_r_RBF = unsorted_r(IX_RBF);
    
    % compute MAP for song
    C = sum(unsorted_r);
    map_TAR = 0;
    map_RBF = 0;
    for j = 1:size(sorted)
        map_TAR = map_TAR + (sum(sorted_r_TAR(1:j)) * sorted_r_TAR(j))/j;
        map_RBF = map_RBF + (sum(sorted_r_RBF(1:j)) * sorted_r_RBF(j))/j;
    end
    map_TAR = map_TAR / C
    map_RBF = map_RBF / C
end
