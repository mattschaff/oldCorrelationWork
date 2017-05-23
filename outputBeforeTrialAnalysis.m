function outputBeforeTrialAnalysis = outputBeforeTrialAnalysis( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    load('nc_prestim_by_performance.mat');
    disp(nc_prestim_by_performance);
    %surf
    h = figure;
    set(h, 'Position', [100, 100, 1049, 895]);
    
    surf(nc_prestim_by_performance.X_performanceRange, nc_prestim_by_performance.Y_windowLengthRange, nc_prestim_by_performance.Z_noiseCorrPreStim);
    xlabel('Performance (% Correct)');
    ylabel('# Trials in Window');
    zlabel('Noise Correlation');
    zlabh = get(gca,'ZLabel');
    set(zlabh,'Position',get(zlabh,'Position') - [.05 0 0]);
    title('\fontsize{14} Noise Correlation in Pre-Stim Period \newline \fontsize{10} By Performance & Window Length');
    
    %bar3
    h2 = figure;
    set(h2, 'Position', [100, 100, 1049, 895]);
    bar3(nc_prestim_by_performance.Y_windowLengthRange, nc_prestim_by_performance.Z_noiseCorrPreStim);
    xlabel('Performance (% Correct)');
    ylabel('# Trials in Window');
    zlabel('Noise Correlation');
    zlabh = get(gca,'ZLabel');
    set(zlabh,'Position',get(zlabh,'Position') - [.15 0 0]);
    set(gca,'XTickLabel',nc_prestim_by_performance.X_performanceRange)
    title('\fontsize{14} Noise Correlation in Pre-Stim Period \newline \fontsize{10} By Performance & Window Length');
    disp(mean(nc_prestim_by_performance.Z_noiseCorrPreStim));
    
    %2D Bar Performance
    h3 = figure;
    set(h3, 'Position', [100, 100, 450, 1000]);
    subplot(2,1,1);
    bar(nc_prestim_by_performance.X_performanceRange, mean(nc_prestim_by_performance.Z_noiseCorrPreStim));
    xlabel('Performance (% Correct)');
    ylabel('Noise Correlation');
    title('\fontsize{10} Noise Correlation in Pre-Stim Period \newline \fontsize{8} By Performance');
    %2D Bar Performance
    subplot(2,1,2);
    bar(nc_prestim_by_performance.Y_windowLengthRange, mean(nc_prestim_by_performance.Z_noiseCorrPreStim, 2));
    xlabel('# Trials in Window');
    ylabel('Noise Correlation');
    title('\fontsize{10} Noise Correlation in Pre-Stim Period \newline \fontsize{8} By # of Trials in Window');
end

