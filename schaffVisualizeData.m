function VisualizeData = schaffVisualizeData( neuron_comparisons, numNeurons, filename )
%SCHAFFVISUALIZEDATA Summary of this function goes here
%   Detailed explanation goes here
	%overall figure
    h = figure;
    set(h, 'Visible', 'off');
    set(h, 'Position', [100, 100, 1049, 895]);
    %scatter
        subplot(3,2,1);
        
        scatter([neuron_comparisons.signal_correlation], [neuron_comparisons.noise_correlation]);
        xlabel('Signal Correlation');
        ylabel('Noise Correlation');
        title('Noise Correlation By Signal Correlation');
        hax=axes;  
        SP=1; %your point goes here 
        hold on;
        line([0 0],[0,10]);
        disp(get(gca,'ylim'));
        hold off;
    %overall noise
        subplot(3,2,2);
        %num of comparisons
        num_comparisons = numel(neuron_comparisons);
        %noise correlation
        noise_corr_0_avg = mean([neuron_comparisons.noise_corr_0]);
        noise_corr_0_sem = std2([neuron_comparisons.noise_corr_0])/sqrt(num_comparisons);
        noise_corr_1_avg = mean([neuron_comparisons.noise_corr_1]);
        noise_corr_1_sem = std2([neuron_comparisons.noise_corr_1])/sqrt(num_comparisons);
        y_values = [0, noise_corr_0_avg, noise_corr_1_avg, 0];
        sem = [0, noise_corr_0_sem, noise_corr_1_sem, 0];
        bar(y_values);
        hold on;
        errorbar(1:4,y_values,sem,'.');
        hold off;
        Labels = {'', 'HIT', 'MISS', ''};
        set(gca, 'XTick', 1:4, 'XTickLabel', Labels);
        axis([1,4,0,max(y_values) + .2]);
        ylabel('Noise Correlation');
        title('Noise Correlation');
            %t test
            [h,p] = ttest([neuron_comparisons.noise_corr_0], [neuron_comparisons.noise_corr_1], 'Alpha',0.05);
            disp([h,p]);
            xlabel(strcat('p = ', num2str(p)));
            %sig in graph
            if h == 1
                xt = get(gca, 'XTick');
                yt = get(gca, 'YTick');
                hold on;
                plot([2, 3], [max(y_values) + .1, max(y_values)+ .1], '-k',  [2.5], [max(y_values)+ .15], '*k');
                hold off;
            end
    %noise correlation +S
        subplot(3,2,3);
        noise_corr_0_avg = mean([neuron_comparisons([neuron_comparisons.signal_correlation] >= 0).noise_corr_0]);
        noise_corr_0_sem = std2([neuron_comparisons([neuron_comparisons.signal_correlation] >= 0).noise_corr_0])/sqrt(num_comparisons);
        noise_corr_1_avg = mean([neuron_comparisons([neuron_comparisons.signal_correlation] >= 0).noise_corr_1]);
        noise_corr_1_sem = std2([neuron_comparisons([neuron_comparisons.signal_correlation] >= 0).noise_corr_1])/sqrt(num_comparisons);
        y_values = [0, noise_corr_0_avg, noise_corr_1_avg, 0];
        sem = [0, noise_corr_0_sem, noise_corr_1_sem, 0];
        bar(y_values);
        hold on;
        errorbar(1:4,y_values,sem,'.');
        hold off;
        Labels = {'', 'HIT', 'MISS', ''};
        set(gca, 'XTick', 1:4, 'XTickLabel', Labels);
        axis([1,4,0,max(y_values) + .2]);
        ylabel('Noise Correlation');
        title('(+S) Noise Correlation');
            %t test
            [h,p] = ttest([neuron_comparisons([neuron_comparisons.signal_correlation] >= 0).noise_corr_0], [neuron_comparisons([neuron_comparisons.signal_correlation] >= 0).noise_corr_1], 'Alpha',0.05);
            disp([h,p]);
            xlabel(strcat('p = ', num2str(p)));
            %sig in graph
            if h == 1
                xt = get(gca, 'XTick');
                yt = get(gca, 'YTick');
                hold on;
                plot([2, 3], [max(y_values) + .1, max(y_values)+ .1], '-k',  [2.5], [max(y_values)+ .15], '*k');
                hold off;
            end
    %noise correlation -S
        subplot(3,2,4);
        noise_corr_0_avg = mean([neuron_comparisons([neuron_comparisons.signal_correlation] <= 0).noise_corr_0]);
        noise_corr_0_sem = std2([neuron_comparisons([neuron_comparisons.signal_correlation] <= 0).noise_corr_0])/sqrt(num_comparisons);
        noise_corr_1_avg = mean([neuron_comparisons([neuron_comparisons.signal_correlation] <= 0).noise_corr_1]);
        noise_corr_1_sem = std2([neuron_comparisons([neuron_comparisons.signal_correlation] <= 0).noise_corr_1])/sqrt(num_comparisons);
        y_values = [0, noise_corr_0_avg, noise_corr_1_avg, 0];
        sem = [0, noise_corr_0_sem, noise_corr_1_sem, 0];
        bar(y_values);
        hold on;
        errorbar(1:4,y_values,sem,'.');
        hold off;
        Labels = {'', 'HIT', 'MISS', ''};
        set(gca, 'XTick', 1:4, 'XTickLabel', Labels);
        axis([1,4,0,max(y_values) + .2]);
        ylabel('Noise Correlation');
        title('(-S) Noise Correlation');
        %t test
            [h,p] = ttest([neuron_comparisons([neuron_comparisons.signal_correlation] <= 0).noise_corr_0], [neuron_comparisons([neuron_comparisons.signal_correlation] <= 0).noise_corr_1], 'Alpha',0.05);
            disp([h,p]);
            xlabel(strcat('p = ', num2str(p)));
            %sig in graph
            if h == 1
                xt = get(gca, 'XTick');
                yt = get(gca, 'YTick');
                hold on;
                plot([2, 3], [max(y_values) + .1, max(y_values)+ .1], '-k',  [2.5], [max(y_values)+ .15], '*k');
                hold off;
            end    
    %noise correl before vs after
    subplot(3,2,5);
        %num of comparisons
        num_comparisons = numel(neuron_comparisons);
        %noise correlation
        noise_corr_avg = mean([neuron_comparisons.noise_correlation]);
        noise_corr_sem = std2([neuron_comparisons.noise_correlation])/sqrt(num_comparisons);
        
        noise_corr_avg_pre = mean([neuron_comparisons.noise_correlation_pre]);
        noise_corr_sem_pre = std2([neuron_comparisons.noise_correlation_pre])/sqrt(num_comparisons);

        y_values = [0, noise_corr_avg, noise_corr_avg_pre, 0];
        sem = [0, noise_corr_sem, noise_corr_sem_pre, 0];
        bar(y_values);
        hold on;
        errorbar(1:4,y_values,sem,'.');
        hold off;
        Labels = {'', 'AFTER', 'BEFORE', ''};
        set(gca, 'XTick', 1:4, 'XTickLabel', Labels);
        axis([1,4,0,max(y_values) + .2]);
        ylabel('Noise Correlation');
        title('Noise Correlation (After vs Before)');
            %t test
            [h,p] = ttest([neuron_comparisons.noise_correlation], [neuron_comparisons.noise_correlation_pre], 'Alpha',0.05);
            disp([h,p]);
            xlabel(strcat('p = ', num2str(p)));
            %sig in graph
            if h == 1
                xt = get(gca, 'XTick');
                yt = get(gca, 'YTick');
                hold on;
                plot([2, 3], [max(y_values) + .1, max(y_values)+ .1], '-k',  [2.5], [max(y_values)+ .15], '*k');
                hold off;
            end
    
    start_neuron = num2str(neuron_comparisons(1).neurons(1));
    end_neuron = num2str(neuron_comparisons(end).neurons(2));
    disp(strcat({'Cohort '}, start_neuron, '-',end_neuron));
    suptitle(strcat({'Cohort '}, start_neuron, '-',end_neuron, {' N = '}, num2str(numNeurons), {' C = '}, num2str(numel(neuron_comparisons))));
    %close figures
    %delete(findall(0,'Type','figure'))
    saveas(gcf, strcat(filename, '/', start_neuron, '-',end_neuron, '_numneurons_',num2str(numNeurons),  '.jpg'));
    close;
end

