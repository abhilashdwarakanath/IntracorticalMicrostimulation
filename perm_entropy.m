function pe = perm_entropy(data, m, r)
% PERM_ENTROPY Computes the permutation entropy of a 2D array.
%
%   PE = PERM_ENTROPY(DATA, M, R) computes the permutation entropy of a 2D
%   array DATA using a symbolic time series approach. M is the embedding
%   dimension and R is the radius for determining similarity between
%   patterns. The permutation entropy is computed using the formula:
%
%       PE = -sum(P .* log2(P))
%
%   where P is the normalized frequency of each permutation pattern in the
%   symbolic time series.
%
%   Example:
%       >> data = rand(100, 50);
%       >> pe = perm_entropy(data, 3, 0.2)

if nargin < 2
    m = 3;
end
if nargin < 3
    r = 0.2 * std(data);
end

n_channels = size(data, 1);
n_trials = size(data, 2);
n_samples = size(data, 3);

pe = zeros(n_channels, n_trials);

for i = 1:n_channels
    for j = 1:n_trials
        time_series = squeeze(data(i, j, :))';
        
        % Symbolize time series
        symbols = zeros(n_samples-m+1, 1);
        for k = 1:n_samples-m+1
            pattern = time_series(k:k+m-1);
            pattern_dist = abs(pattern - pattern');
            pattern_dist(pattern_dist > r) = 0;
            pattern_code = sum(pattern_dist .* (2.^(0:m-1)'), 2) + 1;
            symbols(k) = pattern_code;
        end
        
        % Compute frequency of each pattern
        freq = hist(symbols, 1:(2^m));
        prob = freq / sum(freq);
        
        % Compute permutation entropy
        pe(i,j,:) = -sum(prob .* log2(prob));
    end
end

end