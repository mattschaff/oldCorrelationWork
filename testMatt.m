function hello = testMatt( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% STEPS FOR ANALYSIS
% get list of cells that are auditory cells
% get their spikes within a certain range, for on or off trials
% sum spike counts per trial for each neuron
% correlate for each pair
disp('what');
%% setup
TNRs = (60:5:85)';
nTNR = numel(TNRs);

% setup for parameters used
xmin = -500;
xmax = 3000;
sl_bin = 50;
bin = 100;
%xax = (xmin:sl_bin:xmax)';
xax = (xmin:sl_bin:xmax)';
%xax(:,2) = xax+bin;
%% asdf
    %%
file_in = 'FnTNdata_A1.mat';
load(file_in);
ss = unique(dataC.codes.data(:,11));

% get column indices first
corrIndex = find(strcmp('error_LV', dataC.codes.name),1);
TNRrIndex = find(strcmp('TNR_LV', dataC.codes.name),1);
sessIndex = find(strcmp('sess', dataC.codes.name),1);
stimIndex = find(strcmp('stim1', dataC.codes.name),1);

% extract data
cor = dataC.codes.data(:,corrIndex);
TNR = dataC.codes.data(:,TNRrIndex);
ses = dataC.codes.data(:,sessIndex);
stm = dataC.codes.data(:,stimIndex);

%extract spikes
spk_t = dataC.spikes;
spk = spk_t(:,2);

for i=1:numel(ss)
    iSes = ses==ss(i);
    %disp(['Calculating whether neuron ' num2str(ss(i)) ' is auditory ']);
    spk_Ses = spk(iSes);
    TNR_Ses = TNR(iSes);
    stm_Ses = stm(iSes);
    cor_Ses = cor(iSes);

    for j = 1:numel(spk_Ses)
        % align to stim on
        spk_Ses{j} = spk_Ses{j}-stm_Ses(j);
        spk_Ses{j} = spk_Ses{j}.*1000; % convert to ms
    end

end
% get list of cells that are auditory cells
file_in = 'A1_AuditoryNeurons.mat';
load(file_in);
disp(Aud{2});
%disp(ss);
%disp(spk(2));
end

