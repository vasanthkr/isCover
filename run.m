%% Initialization
clear;
aFileName = 'Nouvelle Vague - Too Drunk To Fuck';
bFileName = 'dead kennedys - too drunk to fuck';
a = miraudio(aFileName);
b = miraudio(bFileName);

mArray = [1 2 3 5 9 12 15];
tauArray = [1 2 6 9 15];
KArray = [1 2 3 4 5 6 7 8 10 12 15 20 30 40 50];

[c_a ch_a] = mirtonalcentroid(a,'Frame');
[c_b ch_b] = mirtonalcentroid(b,'Frame');
S_a = get(ch_a,'Magnitude');
S_a = cell2mat(S_a{1});
N = size(S_a,2);
D = 12;
h = 2; % prediction horizon

%% Learning AR
for m = mArray
 for tau = tauArray
   w = (m-1)*tau; %embedding window
   Sstar = zeros(D*m,N-w-h);
     
   for n = w+1:N-h
       sstar_n = [];
       for j=n-w:tau:n
           sstar_n = [S_a(:,j)' sstar_n];
       end
       Sstar(:,n-w) = sstar_n;
   end
   
   Shat = zeros(D, N-w-h);
   for n = w+1:N-h
       Shat(:,n-w) = S_a(:,n+h);
   end
   
   A = (Sstar' \ Shat')';
 end
end

fprintf('AR done\n');

%% Finding common tune
%[transposedHPCP_b, OTI] = findCommonTune(a, b);
