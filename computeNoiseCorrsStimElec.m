function [noise_correlations,p] = computeNoiseCorrsStimElec(spike_rasters,center_electrode,t,range)

%% Specify time window for signal energy calculation

[~,tStart] = min(abs(t-range(1)));
[~,tEnd] = min(abs(t-range(2)));

% Generate a list of pairs of channels
pairs = [repmat((1:96)', 1, 1), repmat(center_electrode, 96, 1)];
pairs = pairs(pairs(:, 1) ~= pairs(:, 2), :); % Remove [44 44]

% Initialize a matrix to hold the noise correlations for each pair
num_pairs = size(pairs, 1);
noise_correlations = zeros(1,num_pairs);
p_values = zeros(1,num_pairs);

% Loop through each pair of channels
for i = 1:size(pairs, 1)
    chan1 = pairs(i, 1);
    chan2 = pairs(i, 2);
    
    % Extract the spike rasters for the current pair of channels
    spike_rasters_pair = spike_rasters([chan1, chan2], :, :);
    
    % Extract each neuron from the spike rasters pair and squeeze
    neuron1 = squeeze(spike_rasters_pair(1, :, tStart+1:tEnd));
    neuron2 = squeeze(spike_rasters_pair(2, :, tStart+1:tEnd));

    % Sum spikes, get the mean across trials and remove from each trial

    sumNeuron1 = sum(neuron1,2)./(0.001);
    sumNeuron2 = sum(neuron2,2)./(0.001);

    meanNeuron1 = mean(sumNeuron1);
    meanNeuron2 = mean(sumNeuron2);
    
    neuron1_centered = sumNeuron1 - meanNeuron1;
    neuron2_centered = sumNeuron2 - meanNeuron2;

    % Compute the across-trial noise correlation for the current pair of neurons
    [noise_corr,p] = corrcoef(neuron1_centered, neuron2_centered);

    % Store the across-trial noise correlation in the appropriate location in the
    % noise_correlations matrix
    noise_correlations(1,i) = noise_corr(1,2);

    p_values(1,i) = p(1,2);

end
