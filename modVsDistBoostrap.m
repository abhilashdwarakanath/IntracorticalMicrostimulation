function [ciFirst, ciLast] = modVsDistBoostrap(meanSignalMod,errSignalMod,nBoot)

% Initialize arrays to store the bootstrap sums
bootSumFirst = zeros(nBoot, 1);
bootSumLast = zeros(nBoot, 1);

% Perform bootstrap
for i = 1:nBoot
	% Generate bootstrap sample
	bootSample = arrayfun(@(m, e) unifrnd(m - e, m + e), meanSignalMod, errSignalMod);

	% Compute sum of differences for first three and last three data points
	bootSumFirst(i) = sum(diff(bootSample(1:3)));
	bootSumLast(i) = sum(diff(bootSample(4:6)));
end

% Compute 95% confidence intervals
ciFirst = prctile(bootSumFirst, [2.5 97.5]);
ciLast = prctile(bootSumLast, [2.5 97.5]);

% Display results
fprintf('95%% CI for sum of differences of first three data points: [%f, %f]\n', ciFirst(1), ciFirst(2));
fprintf('95%% CI for sum of differences of last three data points: [%f, %f]\n', ciLast(1), ciLast(2));