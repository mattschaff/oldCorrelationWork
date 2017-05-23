function analyzeBeforeTrial = analyzeBeforeTrial( )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% load data
    load('Data/correlation_data_ap.mat');
    neuronData = dayCollector(21).StructuredNeuronData;
    %window length range
    windowLengthSet = 4:12;
    %percent correct range
    percentCorrectSet = [.2,.4,.6,.8,1];
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
                if (windowLength == 5) 
                    %disp([percentCorrectInWindow percentCorrectSet(j) percentCorrectSet(j+1)]);
                end
                if (percentCorrectInWindow > percentCorrectSet(j) && percentCorrectInWindow <= percentCorrectSet(j+1))
                    noise_corr_pre = correlateBeforeTrial(neuronData,t-windowLength+1, t);
                    if (isnan(noise_corr_pre))
                        continue;
                    end
                    collectorArray = [collectorArray; windowLength percentCorrectSet(j) noise_corr_pre];
                end
            end
        end
    end
    %build summary array
    summaryArray = [];
    for w=1:numel(windowLengthSet)
        windowLength = windowLengthSet(w);
        for j=1:numel(percentCorrectSet)-1
            correctIndices = find(collectorArray(:,1) == windowLength & collectorArray(:,2) == percentCorrectSet(j));
            summaryArray = [summaryArray; windowLength percentCorrectSet(j) mean(collectorArray(correctIndices, 3))];
        end
    end
    %build 3D exportable "Zarray" from summary array
    ZArray = [];
    for w=1:numel(windowLengthSet)
        windowLength = windowLengthSet(w);
        for j=1:numel(percentCorrectSet)-1
            correctIndices = find(collectorArray(:,1) == windowLength & collectorArray(:,2) == percentCorrectSet(j));
            ZArray(w,j) = mean(collectorArray(correctIndices, 3));
        end
    end
    nc_prestim_by_performance = struct; 
    nc_prestim_by_performance.Y_windowLengthRange = windowLengthSet;
    nc_prestim_by_performance.X_performanceRange = [.2,.4,.6,.8];
    nc_prestim_by_performance.Z_noiseCorrPreStim = ZArray;
    save nc_prestim_by_performance;
    YArray = windowLengthSet;
    XArray = [.2,.4,.6,.8];
    figure
    surf(XArray, YArray, ZArray);
    
end

