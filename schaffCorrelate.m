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
                        %whole trial
                        noise_corr = corrcoef([neuronA.trials.spike_sum], [neuronB.trials.spike_sum]);
                        neuron_comparisons(comparison_count).noise_correlation = noise_corr(1,2);
                        %responses
                            %0
                            noise_corr_0 = corrcoef([neuronA.trials([neuronA.trials.monkey_response] == 0).spike_sum], [neuronB.trials([neuronB.trials.monkey_response] == 0).spike_sum]);
                            neuron_comparisons(comparison_count).noise_corr_0 = noise_corr_0(1,2);
                            %1
                            noise_corr_1 = corrcoef([neuronA.trials([neuronA.trials.monkey_response] == 1).spike_sum], [neuronB.trials([neuronB.trials.monkey_response] == 1).spike_sum]);
                            neuron_comparisons(comparison_count).noise_corr_1 = noise_corr_1(1,2);
                            %2
                            noise_corr_2 = corrcoef([neuronA.trials([neuronA.trials.monkey_response] == 2).spike_sum], [neuronB.trials([neuronB.trials.monkey_response] == 2).spike_sum]);
                            neuron_comparisons(comparison_count).noise_corr_2 = noise_corr_2(1,2);
                        %first half of trial
                        noise_corr_first = corrcoef([neuronA.trials.spike_sum_first375], [neuronB.trials.spike_sum_first375]);
                        neuron_comparisons(comparison_count).noise_corr_first = noise_corr_first(1,2);
                        %second half of trial
                        noise_corr_second = corrcoef([neuronA.trials.spike_sum_last375], [neuronB.trials.spike_sum_last375]);
                        neuron_comparisons(comparison_count).noise_corr_second = noise_corr_second(1,2);
                    %loop through different tones
                    neuron_comparisons(comparison_count).noise_corr_by_TNR = [];
                    A_signal = [];
                    B_signal = [];
                    A_signal_0 = [];
                    A_signal_1 = [];
                    A_signal_2 = [];
                    B_signal_0 = [];
                    B_signal_1 = [];
                    B_signal_2 = [];
                    for t=1:nTNR
                        %disp(TNRs(t));
                        TNRindexB = neuronB.trials([neuronB.trials.TNR] == TNRs(t));
                        TNRindexA = neuronA.trials([neuronA.trials.TNR] == TNRs(t));
                        noise_corr = corrcoef([TNRindexA.spike_sum],[TNRindexB.spike_sum]);
                        neuron_comparisons(comparison_count).noise_corr_by_TNR(t).noise_corr = noise_corr(1,2);
                        
                        %signal
                        A_signal(t) = mean([TNRindexA.spike_sum]);
                        B_signal(t) = mean([TNRindexB.spike_sum]);
                        %signal responses
                           %0
                           A_signal_0(t) = mean([TNRindexA([TNRindexA.monkey_response] == 0).spike_sum]);
                           B_signal_0(t) = mean([TNRindexB([TNRindexB.monkey_response] == 0).spike_sum]);
                           %1
                           A_signal_1(t) = mean([TNRindexA([TNRindexA.monkey_response] == 1).spike_sum]);
                           B_signal_1(t) = mean([TNRindexB([TNRindexB.monkey_response] == 1).spike_sum]);
                           %2
                           A_signal_2(t) = mean([TNRindexA([TNRindexA.monkey_response] == 2).spike_sum]);
                           B_signal_2(t) = mean([TNRindexB([TNRindexB.monkey_response] == 2).spike_sum]);
                    end
                    signal_corr = corrcoef(A_signal, B_signal);
                    signal_corr_0 = corrcoef(A_signal_0, B_signal_0);
                    signal_corr_1 = corrcoef(A_signal_1, B_signal_1);
                    signal_corr_2 = corrcoef(A_signal_2, B_signal_2);
                    neuron_comparisons(comparison_count).signal_correlation = signal_corr(1,2);
                    neuron_comparisons(comparison_count).signal_corr_0 = signal_corr_0(1,2);
                    neuron_comparisons(comparison_count).signal_corr_1 = signal_corr_1(1,2);
                    neuron_comparisons(comparison_count).signal_corr_2 = signal_corr_2(1,2);
                end
            end
            
            
            filename = char(strcat('neuron_comparisons_', string(datetime('now','TimeZone','local','Format','MMM-d-y-HH:mm:ss-Z'))));
            %save neuron_comparisons;
            %forPlot = [[neuron_comparisons.noise_corr_0], [neuron_comparisons.noise_corr_1], [neuron_comparisons.noise_corr_2]];
            %boxplot(forPlot);
            save(filename, 'neuron_comparisons');
            %scatter([neuron_comparisons.noise_correlation],[neuron_comparisons.signal_correlation]);
            
end

