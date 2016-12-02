function correlateBeforeTrial = correlateBeforeTrial( neuronData, trial_start, trial_end )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    %SETUP
        %load(NeuronData);
        numNeurons = numel(neuronData);
        %loop through neurons
            firstNeuron = [];
            neuron_comparisons = [];
            comparison_count = 0;
            for i=1:numNeurons
                neuronA = neuronData(i);
              firstNeuron = [firstNeuron neuronA.ID];
                %subloop through neurons
                for j=1:numNeurons
                    neuronB = neuronData(j);
                    if any(firstNeuron == neuronB.ID)
                       continue
                    end
                    comparison_count = comparison_count + 1;
                    neuron_comparisons(comparison_count).neurons = [neuronA.ID, neuronB.ID];
                    noise_corr = corrcoef([neuronA.detrended_spike_sum_array_pre450(trial_start:trial_end)], [neuronB.detrended_spike_sum_array_pre450(trial_start:trial_end)]);
                    neuron_comparisons(comparison_count).noise_corr_pre = noise_corr(1,2);
                end
            end
            %return mean noise correlation of pre-stim period
            correlateBeforeTrial = mean([neuron_comparisons.noise_corr_pre]);
            
end

