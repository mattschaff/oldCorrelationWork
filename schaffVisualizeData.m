function VisualizeData = schaffVisualizeData( neuron_comparisons )
%SCHAFFVISUALIZEDATA Summary of this function goes here
%   Detailed explanation goes here
	%overall figure
    set(figure, 'Position', [100, 100, 1049, 895]);
    %scatter
        subplot(2,2,1);
        
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
        subplot(2,2,2);
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
        axis([1,4,0,.3]);
        ylabel('Noise Correlation');
        title('Noise Correlation for Cohort 143-160');
            %t test
            [h,p] = ttest([neuron_comparisons.noise_corr_0], [neuron_comparisons.noise_corr_1], 'Alpha',0.05);
            disp([h,p]);
            xlabel(strcat('p = ', num2str(p)));
            %sig in graph
            if h == 1
                xt = get(gca, 'XTick');
                yt = get(gca, 'YTick');
                hold on;
                plot([2, 3], [max(y_values)*1.4, max(y_values)*1.4], '-k',  [2.5], [max(y_values)*1.5], '*k');
                hold off;
            end
    %noise correlation +S
        subplot(2,2,3);
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
        axis([1,4,0,.3]);
        ylabel('Noise Correlation');
        title('(+S) Noise Correlation for Cohort 143-160');
            %t test
            [h,p] = ttest([neuron_comparisons([neuron_comparisons.signal_correlation] >= 0).noise_corr_0], [neuron_comparisons([neuron_comparisons.signal_correlation] >= 0).noise_corr_1], 'Alpha',0.05);
            disp([h,p]);
            xlabel(strcat('p = ', num2str(p)));
            %sig in graph
            if h == 1
                xt = get(gca, 'XTick');
                yt = get(gca, 'YTick');
                hold on;
                plot([2, 3], [max(y_values)*1.4, max(y_values)*1.4], '-k',  [2.5], [max(y_values)*1.5], '*k');
                hold off;
            end
    %noise correlation -S
        subplot(2,2,4);
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
        axis([1,4,0,.3]);
        ylabel('Noise Correlation');
        title('(-S) Noise Correlation for Cohort 143-160');
        %t test
            [h,p] = ttest([neuron_comparisons([neuron_comparisons.signal_correlation] <= 0).noise_corr_0], [neuron_comparisons([neuron_comparisons.signal_correlation] <= 0).noise_corr_1], 'Alpha',0.05);
            disp([h,p]);
            xlabel(strcat('p = ', num2str(p)));
            %sig in graph
            if h == 1
                xt = get(gca, 'XTick');
                yt = get(gca, 'YTick');
                hold on;
                plot([2, 3], [max(y_values)*1.4, max(y_values)*1.4], '-k',  [2.5], [max(y_values)*1.5], '*k');
                hold off;
            end    
    
    suptitle('Cohort 143-160');
    %close figures
    %delete(findall(0,'Type','figure'))
end

