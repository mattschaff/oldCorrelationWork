function [SignalNoiseFano]=FanoFunctionNoiseTrials(dataC,Cell1)


xmin = 0;
xmax = 740;
sl_bin = 10;
bin = 10;
foo = (xmin:sl_bin:xmax)';
foo(:,2) = foo+bin;
xax=foo;

% get column indices first
corr = find(strcmp('error_LV', dataC.codes.name),1);
TNRr = find(strcmp('TNR_LV', dataC.codes.name),1);
sess = find(strcmp('sess', dataC.codes.name),1);
stim = find(strcmp('stim1', dataC.codes.name),1);
levr = find(strcmp('lev_rel',dataC.codes.name),1);

% extract data
cor = dataC.codes.data(:,corr);
TNR = dataC.codes.data(:,TNRr);
ses = dataC.codes.data(:,sess);
stm = dataC.codes.data(:,stim);
lvr = dataC.codes.data(:,levr);

% extract spikes
spk_t = dataC.spikes;
spk = spk_t(:,2);
ss = unique(dataC.codes.data(:,11));

TNRs = (60:5:85)';

%calculate fano factor for hit trials only; miss trials..so first
%find them..simultaneous, Hits/misses for one is hits/misses for other

iSes1 = ses==ss(Cell1); %references master list of auditory and non-auditory neurons
% NEURAL Extract stuff required
spk_Ses1 = spk(iSes1);
TNR_Ses1 = TNR(iSes1);
stm_Ses1 = stm(iSes1);
lvr_Ses1 = lvr(iSes1);
cor_Ses1 = cor(iSes1);


% align all to stim on and then get spike rates from all trials in session
for j = 1:numel(stm_Ses1)
% align to stim on
spk_Ses1{j} = spk_Ses1{j}-stm_Ses1(j);
spk_Ses1{j} = spk_Ses1{j}.*1000; % convert to ms
end

for j=1:6
  Signal{j} = spk_Ses1(TNR_Ses1==TNRs(j)); %hits and misses 
  %spk_Tins{j} = spk_Ses(TNR_Ses==TNRs(j) & cor_Ses==0); %for hits only 
end
      
% Create selection arrays
Noise=spk_Ses1(isnan(TNR_Ses1)); %noise trials



for k=1:size(xax,1)
  tfoo=[]; %reset for each k  
  for n = 1:6 %hits 1
    for m = 1:size(Signal{n},1)
      tfoo=[tfoo (sum(Signal{n}{m}>=xax(k,1) & Signal{n}{m}<=xax(k,2)))];
    end
  end %n = 1:nTNR
  SignalNoiseFano(1,k)= nanvar(tfoo)/nanmean(tfoo);
end


for k=1:size(xax,1)
  tfoo=[];
  for m = 1:size(Noise,1)
    tfoo=[ tfoo sum(Noise{m}>=xax(k,1) & Noise{m}<=xax(k,2))];
  end
  SignalNoiseFano(2,k)= nanvar(tfoo)/nanmean(tfoo);
end


