function Auditory = CheckAuditory(BrainRegion,idx)

%take in file..find its place in the original list and then see if auditory
%or not...this is mostly a game of file logistics, as opposed, to something
%that is computationally intensive...


if(strcmp('A1',BrainRegion))  
  load A1_AuditoryNeurons
else
  load AL_AuditoryNeurons
end


if(~isempty(find(idx==Aud)))
  Auditory=1;
else
  Auditory=0;
end

