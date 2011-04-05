% [hpcp, index = findCommonTune (A, B)
% finds common tune of two musical fragments A and B (filenames)
% output:
%   hpcp  - pitch profile for B transposed to A's tune
%   index - optimal transposition index

% "Transposing Chroma Representations to a Common Key" by 
% Serrà, J. and  Gómez, E. and  Herrera, P.
% IEEE CS Conference on The Use of Symbols to Represent Music and Multimedia Objects
% 2008

% implementation by Mikhail Bessmeltsev, 2011.
	
function [hpcp, index] = findCommonTune(a,b)
% calculate tonal centroids for both
[c_a ch_a] = mirtonalcentroid(a,'Frame');
[c_b ch_b] = mirtonalcentroid(b,'Frame');

data_a = get(ch_a,'Magnitude');
data_a = cell2mat(data_a{1});
sum = ones(1,size(data_a,2))*data_a';
g_a = sum/max(sum);

data_b = get(ch_b,'Magnitude');
data_b = cell2mat(data_b{1});
sum = ones(1,size(data_b,2))*data_b';
g_b = sum/max(sum);

% now find the optimal transposition index
new_g_b = g_b;
maxdot = g_a * g_b';
argmax = 0;
for i=1:size(g_b,2)-1
    new_g_b = circshift(g_b,[0 i]);
    if (g_a * new_g_b') > maxdot
        argmax = i;
        maxdot = g_a * new_g_b';
    end
end
 hpcp = new_g_b;
 index = argmax;
end