function testMatt2 = testMatt2( )
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
        for i=1:numAudNeurons
            %extract data per neuron
            iSes = ses==AudNeuronIDs(i);
            spk_indiv = spikes(iSes);
            cor_indiv = cor(iSes);
            TNR_indiv = TNR(iSes);
            ses_indiv = ses(iSes); %this will always be the same number
            stm_indiv = stm(iSes);
            % save neuron metadata
            NeuronCollector(i).ID = AudNeuronIDs(i);
            NeuronCollector(i).trials = [];
            %loop through trials
            signal_trial_count = 0; %signal trial count --> we're only counting signal trials
            for j=1:numel(ses_indiv)
                %throw out catch trials
                if isnan(TNR_indiv(j))
                    continue
                end
                signal_trial_count = signal_trial_count + 1;
                %load basic trial info into collector
                    %TONE
                    NeuronCollector(i).trials(signal_trial_count).TNR = TNR_indiv(j);
                    %stim on
                    NeuronCollector(i).trials(signal_trial_count).stim_on = stm_indiv(j);
                    %monkey response
                    NeuronCollector(i).trials(signal_trial_count).monkey_response = cor_indiv(j);
                %load spike data into collector
                    % first, align all to stim on and then get spike rates from all trials in session
                    spikes_indiv_ses = spk_indiv{j};
                    for k = 1:numel(spikes_indiv_ses)
                        % align to stim on
                        spikes_indiv_ses(k) = spikes_indiv_ses(k) - stm_indiv(j);
                        spikes_indiv_ses(k) = spikes_indiv_ses(k)*1000; % convert to ms
                    end
                    NeuronCollector(i).trials(signal_trial_count).spikes = spikes_indiv_ses;
                    NeuronCollector(i).trials(signal_trial_count).spike_sum = sum(spikes_indiv_ses>=0 & spikes_indiv_ses<= 750);
            end

            
        end
        save('test', 'NeuronCollector');
end

