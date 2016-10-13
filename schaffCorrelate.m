function schaffCorrelate = schaffCorrelate( NeuronData )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    %SETUP
        load(NeuronData);
        numNeurons = numel(NeuronCollector);
        %tones
        TNRs = (60:5:85)';
        nTNR = numel(TNRs);
        %loop through neurons
            firstNeuron = [];
            neuron_comparisons = [];
            comparison_count = 0;
            for i=1:numNeurons
                neuronA = NeuronCollector(i);
              firstNeuron = [firstNeuron neuronA.ID];
                %subloop through neurons
                for j=1:numNeurons
                    neuronB = NeuronCollector(j);
                    if any(firstNeuron == neuronB.ID)
                       continue
                    end
                    comparison_count = comparison_count + 1;
                    neuron_comparisons(comparison_count).neurons = [neuronA.ID, neuronB.ID];
                    %get noise correlation regardless of TNR
                    noise_corr = corrcoef([neuronA.trials.spike_sum], [neuronB.trials.spike_sum]);
                    neuron_comparisons(comparison_count).noise_correlation = noise_corr(1,2);
                    %loop through different tones
                    neuron_comparisons(comparison_count).noise_corr_by_TNR = [];
                    A_signal = [];
                    B_signal = [];
                    for t=1:nTNR
                        %disp(TNRs(t));
                        TNRindexB = neuronB.trials([neuronB.trials.TNR] == TNRs(t));
                        TNRindexA = neuronA.trials([neuronA.trials.TNR] == TNRs(t));
                        noise_corr = corrcoef([TNRindexA.spike_sum],[TNRindexB.spike_sum]);
                        neuron_comparisons(comparison_count).noise_corr_by_TNR(t).noise_corr = noise_corr(1,2);
                        
                        %signal
                        A_signal(t) = mean([TNRindexA.spike_sum]);
                        B_signal(t) = mean([TNRindexB.spike_sum]);

                    end
                    signal_corr = corrcoef(A_signal, B_signal);
                    neuron_comparisons(comparison_count).signal_correlation = signal_corr(1,2);
                end
            end
            disp(neuron_comparisons);
end

