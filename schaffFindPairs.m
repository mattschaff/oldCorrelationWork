function schaffFindPairs = schaffFindPairs()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    AudNeuronIDContainer = load('A1_AuditoryNeurons.mat');
    %get fieldnames
    AudNeuronIDs = AudNeuronIDContainer.Aud;
    % load & extract raw neuron non-neuron data
    RawData = load('FnTNdata_A1.mat');
    ses = RawData.dataC.codes.data(:,find(strcmp('sess', RawData.dataC.codes.name),1));
     % loop through total neurons, pick only aud neurons
        %get number of neurons
        numAudNeurons = numel(AudNeuronIDs);
        %loop
        NeuronCollector = [];
        neuronCount = 0;
        currentDay = 0;
        dayCollector = [];
        for i=2:numAudNeurons
            %extract data per neuron
            iSes = ses==AudNeuronIDs(i);
            num_trials = numel(ses(iSes)); %this will always be the same number
            num_trials_before = numel(ses(ses==AudNeuronIDs(i-1)));
            %if the number of trials is the same as before
            if (1 < i && num_trials_before == num_trials)
                if (currentDay == 0 || isempty(find(dayCollector(currentDay).neurons == AudNeuronIDs(i-1)))) 
                    currentDay = currentDay + 1;
                    dayCollector(currentDay).neurons = [AudNeuronIDs(i-1), AudNeuronIDs(i)];
                else
                   dayCollector(currentDay).neurons = [dayCollector(currentDay).neurons, AudNeuronIDs(i)];
                end
            end
            % save neuron metadata
        end
        %loop through days
        for i=1:numel(dayCollector)
            if (i==4)
                continue;
            end
            %disp([dayCollector(i).neurons]);
            dayCollector(i).num_neurons = numel(dayCollector(i).neurons);
            dayCollector(i).StructuredNeuronData = testMatt2(min(dayCollector(i).neurons), max(dayCollector(i).neurons));
            dayCollector(i).Correlations = schaffCorrelateDetrended(dayCollector(i).StructuredNeuronData);
        end
        filename = char(strcat('CorrelationOutput_', string(datetime('now','TimeZone','local','Format','MMM-d-y-HH:mm:ss'))));
        %save(filename, 'dayCollector');
end

