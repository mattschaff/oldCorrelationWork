function analyzeBeforeTrial = analyzeBeforeTrial( )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% load data
    load('Data/correlation_data_ap.mat');
    neuronData = dayCollector(21).StructuredNeuronData;
    %window length range
    windowLengthSet = 4:8;
    %percent correct range
    percentCorrectSet = [.4,.6,.8,1];
    %get number of trials
    numTrials = numel(neuronData(1).trials);
    responsePerTrial = [neuronData(1).trials.monkey_response];
    %start loop
    collectorArray = [];
    for w=1:numel(windowLengthSet)
        windowLength = windowLengthSet(w);
        for j=1:numel(percentCorrectSet)-1
            for t=1:numTrials
                if t < windowLength+1
                    continue;
                end
                responsesInWindow = responsePerTrial(t-windowLength+1:t);
                percentCorrectInWindow = numel(responsesInWindow(responsesInWindow == 0))/numel(responsesInWindow);
                if (percentCorrectInWindow > percentCorrectSet(j) && percentCorrectInWindow < percentCorrectSet(j+1)) 
                    noise_corr_pre = correlateBeforeTrial(neuronData,t-windowLength+1, t);
                    collectorArray = [collectorArray; windowLength percentCorrectSet(j) noise_corr_pre];
                end
                if t == 5
                    %break;
                end
            end
        end
    end
   figure
    mesh(collectorArray(:,1), collectorArray(:,2), collectorArray(:,3));
    disp(collectorArray);
    %save collectorArray;
end

