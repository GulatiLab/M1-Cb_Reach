function [lenLFP_M1, lenLFP_Cb] = get_LFP_length(filepath)
%----------------------------------------------------------------------------
% Function to get the duration of TDT block recording by 
% reading the length of the LFP signals. 
% Author@ Aamir Abbasi
% INPUT -
%   -- filepath: file path of the TDT block where .mat files are located
% OUTPUT - 
%   -- lenLFP_M1: Duration of M1 LEF signals
%   -- lenLFP_M1: Duration of Cb LEF signals 
%----------------------------------------------------------------------------

fileNames = {'LFP_M1.mat','LFP_Cb.mat'};
for j = 1:length(fileNames)
  file = fileNames{j};
  load([filepath,'\',file],'L*','Fs_lfp');
  if exist('LFPs2','var') == 1
    lenLFP_Cb = size(LFPs2,2)/Fs_lfp;
  end
  if exist('LFPs1','var') == 1
    lenLFP_M1 = size(LFPs1,2)/Fs_lfp;
  end
  clear LFPs1 LFPs2
end

