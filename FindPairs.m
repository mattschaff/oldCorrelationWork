function List = FindPairs(BrainRegion)

%go to directory

%get filenames
if(strcmp('A1',BrainRegion))
 disp(['Loading A1 files...']);    
 load FnTNdata_A1.mat
 FileNames = dataC.files;
 FileNames = FileNames(2:end);
else
  disp(['Loading AL files...']);     
  load FnTNdata_AL2.mat;
  FileNames=dataC.files;
  FileNames = FileNames(2:end);
end

FoundAlready=[];
for(i=1:length(FileNames))
   temp=char(FileNames(i));
   if(length(temp)>=8)
     if(isempty(strmatch(temp(1:8),FoundAlready))) %if not already found, add in
       disp(['Adding in ' temp(1:8)]);
       FoundAlready = [FoundAlready {temp(1:8)}];
     end    
   else
     disp([temp ' is not valid']);     
   end 
end
disp(['  ']);

%going to be ugly but what the hell.
Counter=1; Signal=[];Noise=[];Fano=[];NoisebySignal=[]; SignalAndNoise=[];
for(i=1:length(FoundAlready))  
  idx=[];  
  for(j=1:length(FileNames))
    temp=char(FileNames(j));  
    if(~isempty(strmatch(FoundAlready(i),temp)))
      idx=[idx j];%store indices
    end
  end
  
  %now that found all file names from same session, create all combos 
   if(length(idx)>=2)
     ComboList=nchoosek(idx,2); 
     %now calculate signal and noise Rxx for all pairs
     for(lcl=1:size(ComboList,1))
       %first see if auditory..if auditory then do
       if (CheckAuditory(BrainRegion,ComboList(lcl,1)) && CheckAuditory(BrainRegion,ComboList(lcl,2)))
         disp([char(FileNames(ComboList(lcl,1 ))) ' and ' char(FileNames(ComboList(lcl,2))) ' are auditory...down we go']);disp([' ']);
     %    [Signal(Counter).Rhit,Signal(Counter).Phit,Signal(Counter).Rmiss,Signal(Counter).Pmiss]=SignalCorrelation(dataC,ComboList(lcl,1),ComboList(lcl,2));
     %    [Noise(Counter).Ar, Noise(Counter).Ap, Noise(Counter).Al, Noise(Counter).Au, Noise(Counter).Sr, Noise(Counter).Sp, Noise(Counter).Sl, Noise(Counter).Su, Noise(Counter).Hr, Noise(Counter).Hp, Noise(Counter).Hl, Noise(Counter).Hu, Noise(Counter).Mr, Noise(Counter).Mp, Noise(Counter).Ml, Noise(Counter).Mu,Noise(Counter).BootA,Noise(Counter).BootS,Noise(Counter).BootH,Noise(Counter).BootM]=NoiseCorrelation(dataC,ComboList(lcl,1),ComboList(lcl,2));
       %  [NoisebySignal(Counter).SbNHits,NoisebySignal(Counter).SbNMiss]=NoisebySignalCorrelation(FileNames(ComboList(lcl,1)),FileNames(ComboList(lcl,2)));
      %    [SignalAndNoise(Counter).SRhit,SignalAndNoise(Counter).SPhit,SignalAndNoise(Counter).SRmiss,SignalAndNoise(Counter).SPmiss,...
      %    SignalAndNoise(Counter).NRhit,SignalAndNoise(Counter).NPhit,SignalAndNoise(Counter).NRmiss,SignalAndNoise(Counter).NPmiss]=SignalNoise(dataC,ComboList(lcl,1),ComboList(lcl,2));

         Counter=Counter+1;
       else
         disp(['Either ' char(FileNames(ComboList(lcl,2))) ' or ' char(FileNames(ComboList(lcl,2))) ' isn''t auditory...sadness']);disp(['  ']);
       end
     end
   else
     disp([char(FoundAlready(i)) ' has only one cell so don''t do correlation']);disp([' ']);    
   end     
end
   
%%%need to do Fano separately...
% Counter=1;
% for(i=1:length(FoundAlready))  
%   idx=[];  
%   for(j=1:length(FileNames))
%     temp=char(FileNames(j));  
%     if(~isempty(strmatch(FoundAlready(i),temp)))
%       idx=[idx j];%store indices
%     end
%   end
%   for(iidx=1:length(idx))
%       idx(iidx);
%     if (CheckAuditory(BrainRegion,idx(iidx)))
%       [Fano(Counter).H,Fano(Counter).M]=FanoFunction(dataC,idx(iidx));
%       Counter=Counter+1;
%     end
%   end
% end


%%need to do SignalNoiseFano separately...
Counter=1;
for(i=1:length(FoundAlready))  
  idx=[];  
  for(j=1:length(FileNames))
    temp=char(FileNames(j));  
    if(~isempty(strmatch(FoundAlready(i),temp)))
      idx=[idx j];%store indices
    end
  end
  for(iidx=1:length(idx))
      idx(iidx);
    if (CheckAuditory(BrainRegion,idx(iidx)))
      [FanoSignalNoise(Counter).FSN]=FanoFunctionNoiseTrials(dataC,idx(iidx));
      Counter=Counter+1;
    end
  end
end

%eval(['save ' BrainRegion '_Signal.mat Signal']); 
%eval(['save ' BrainRegion '_Noise.mat Noise']); 
%eval(['save ' BrainRegion '_Fano.mat Fano']);
%eval(['save ' BrainRegion '_SignalAndNoise.mat SignalAndNoise']); 
%eval(['save ' BrainRegion '_NoisebySignal.mat NoisebySignal']);
eval(['save ' BrainRegion '_FanoSignalNoise.mat FanoSignalNoise']);