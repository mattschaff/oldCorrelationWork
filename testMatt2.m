function testMatt2 = testMatt2( startNeuron, endNeuron )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

        
%plan
    % load aud neurons
    AudNeuronIDContainer = load('A1_AuditoryNeurons.mat');
    %get fieldnames
    AudNeuronIDs = AudNeuronIDContainer.Aud;
    % load & extract raw neuron non-neuron data
    RawData = load('FnTNdata_A1.mat');
    cor = RawData.dataC.codes.data(:,find(strcmp('error_LV', RawData.dataC.codes.name),1));
    TNR = RawData.dataC.codes.data(:,find(strcmp('TNR_LV', RawData.dataC.codes.name),1));
    ses = RawData.dataC.codes.data(:,find(strcmp('sess', RawData.dataC.codes.name),1));
    stm = RawData.dataC.codes.data(:,find(strcmp('stim1', RawData.dataC.codes.name),1));
    files = RawData.dataC.files;
    % extract neuron spike data
    spikes = RawData.dataC.spikes(:,2);
    
    % loop through total neurons, pick only aud neurons
        %get number of neurons
        numAudNeurons = numel(AudNeuronIDs);
        %loop
        NeuronCollector = [];
        neuronCount = 0;
        for i=1:numAudNeurons
            %skip neurons that don't matter
            if AudNeuronIDs(i) < startNeuron
                continue
            end
            if AudNeuronIDs(i) > endNeuron
                continue
            end
            %extract data per neuron
            iSes = ses==AudNeuronIDs(i);
            spk_indiv = spikes(iSes);
            cor_indiv = cor(iSes);
            TNR_indiv = TNR(iSes);
            ses_indiv = ses(iSes); %this will always be the same number
            stm_indiv = stm(iSes);
            % save neuron metadata
            neuronCount = neuronCount + 1;
            NeuronCollector(neuronCount).ID = AudNeuronIDs(i);
            NeuronCollector(neuronCount).trials = [];
            %loop through trials
            trial_count = 0; 
            for j=1:numel(ses_indiv)
                trial_count = trial_count + 1;
                %load basic trial info into collector
                    %TONE
                    NeuronCollector(neuronCount).trials(trial_count).TNR = TNR_indiv(j);
                    %stim on
                    NeuronCollector(neuronCount).trials(trial_count).stim_on = stm_indiv(j);
                    %monkey response
                    NeuronCollector(neuronCount).trials(trial_count).monkey_response = cor_indiv(j);
                %load spike data into collector
                    % first, align all to stim on and then get spike rates from all trials in session
                    spikes_indiv_ses = spk_indiv{j};
                    for k = 1:numel(spikes_indiv_ses)
                        % align to stim on
                        spikes_indiv_ses(k) = spikes_indiv_ses(k) - stm_indiv(j);
                        spikes_indiv_ses(k) = spikes_indiv_ses(k)*1000; % convert to ms
                    end
                    NeuronCollector(neuronCount).trials(trial_count).spikes = spikes_indiv_ses;
                    NeuronCollector(neuronCount).trials(trial_count).spike_sum = sum(spikes_indiv_ses>=0 & spikes_indiv_ses<= 750);
                    NeuronCollector(neuronCount).trials(trial_count).spike_sum_pre450 = sum(spikes_indiv_ses>=-450 & spikes_indiv_ses<= 0);
                    NeuronCollector(neuronCount).trials(trial_count).spike_sum_first375 = sum(spikes_indiv_ses>=0 & spikes_indiv_ses<= 375);
                    NeuronCollector(neuronCount).trials(trial_count).spike_sum_last375 = sum(spikes_indiv_ses>375 & spikes_indiv_ses<= 750);
            end
            %detrend spike sum
            NeuronCollector(neuronCount).trend_spike_sum_array = [gauss_smooth([NeuronCollector(neuronCount).trials.spike_sum],10)];
            NeuronCollector(neuronCount).spike_sum_array = transpose([NeuronCollector(neuronCount).trials.spike_sum]);
            NeuronCollector(neuronCount).detrended_spike_sum_array = NeuronCollector(neuronCount).spike_sum_array - NeuronCollector(neuronCount).trend_spike_sum_array;
            %detrend pre 450 spike sum
            NeuronCollector(neuronCount).trend_spike_sum_array_pre450 = [gauss_smooth([NeuronCollector(neuronCount).trials.spike_sum_pre450],10)];
            NeuronCollector(neuronCount).spike_sum_array_pre450 = transpose([NeuronCollector(neuronCount).trials.spike_sum_pre450]);
            NeuronCollector(neuronCount).detrended_spike_sum_array_pre450 = NeuronCollector(neuronCount).spike_sum_array_pre450 - NeuronCollector(neuronCount).trend_spike_sum_array_pre450;
            %get TNR array
            NeuronCollector(neuronCount).TNR_array = TNR_indiv;
            %reload detrended data into neuroncollector
            signal_trial_count = 0;
            for h=1:numel(ses_indiv)
                %throw out catch trials
                if isnan(TNR_indiv(h))
                    continue
                end
                signal_trial_count = signal_trial_count + 1;
                %TONE
                    NeuronCollector(neuronCount).sig_trials(signal_trial_count).TNR = TNR_indiv(h);
                    %stim on
                    NeuronCollector(neuronCount).sig_trials(signal_trial_count).stim_on = stm_indiv(h);
                    %monkey response
                    NeuronCollector(neuronCount).sig_trials(signal_trial_count).monkey_response = cor_indiv(h);
                %spikes
                NeuronCollector(neuronCount).sig_trials(signal_trial_count).spike_sum_D = NeuronCollector(neuronCount).detrended_spike_sum_array(h);
                NeuronCollector(neuronCount).sig_trials(signal_trial_count).spike_sum_pre_D = NeuronCollector(neuronCount).detrended_spike_sum_array_pre450(h);
            end
        end
        filename = char(strcat('NeuronData_', num2str(startNeuron), '_', num2str(endNeuron), '_', string(datetime('now','TimeZone','local','Format','MMM-d-y-HH:mm:ss-Z'))));
        save(filename, 'NeuronCollector');
end

