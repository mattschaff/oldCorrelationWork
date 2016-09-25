function h=IsAuditory(file_in)


% modified by yec from plotTN_FractBySess.

%run TNdata_A1.mat or
%    TNdata_AL.mat





%% setup
TNRs = (60:5:85)';
nTNR = numel(TNRs);

% setup for parameters used
xmin = -500;
xmax = 3000;
sl_bin = 50;
bin = 100;
xax = (xmin:sl_bin:xmax)';
xax(:,2) = xax+bin;

if(file_in(end) == '1')
  Header='A1';
else
  Header='Al';
end

Aud=[];AudI=[];AudE=[];
%% Load files & extract data
 disp(file_in)
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

% extract spikes
spk_t = dataC.spikes;
spk = spk_t(:,2);


% for each neuron seperately
for i=1:numel(ss)
  iSes = ses==ss(i);
  disp(ss(i))
  disp(['Calculating whether ' num2str(ss(i)) ' is auditory ']);

  
  Baseline=[];
  Evoked=[];
    
    % Extract stuff required
    spk_Ses = spk(iSes);
    TNR_Ses = TNR(iSes);
    stm_Ses = stm(iSes);
    cor_Ses = cor(iSes);
    
    % align all to stim on and then get spike rates from all trials in session
    for j = 1:numel(stm_Ses)
        % align to stim on
        spk_Ses{j} = spk_Ses{j}-stm_Ses(j);
        spk_Ses{j} = spk_Ses{j}.*1000; % convert to ms
    end
    
    % Create selection arrays
    % All tone-in-noise trials including hits and misses from this session
    spk_Tin = spk_Ses(~isnan(TNR_Ses));
    % Tin trials by Tone-in-noise level also parse for correct trials
    spk_Tins = cell(nTNR,1);
    spk_Tins_C =  cell(nTNR,1);
    for j=1:nTNR
        spk_Tins{j} = spk_Ses(TNR_Ses==TNRs(j));
        spk_Tins_C{j} = spk_Ses(TNR_Ses==TNRs(j) & cor_Ses==0);
    end
    % All catch (i.e., NOISE) trials including Correct Rejections and False Alarms
    spk_Ct =  spk_Ses(isnan(TNR_Ses));
    
KeepTrackTNR=[]
    for n= 1:nTNR %sort by TNR
    foo=[]
    for m = 1:size(spk_Tins_C{n},1)
      Baseline = [Baseline sum(spk_Tins_C{n}{m}>=-750 & spk_Tins_C{n}{m}<0)];
     foo= [foo sum(spk_Tins_C{n}{m}>=0 & spk_Tins_C{n}{m}<= 750)];
    end
    KeepTrackTNR=[KeepTrackTNR nanmean(foo)]
    end
    
end

 


    
