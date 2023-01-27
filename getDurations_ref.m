%---------------------------------------------------------------------------------
% Script to get recorded and single units timestamps duration for each block.
% This script arranges the duration in a N rows x M columns matrix where N is
% LFP_M1, LFP_Cb, Timestamps_M1, Timestamps_Cb, Turncated timestamp to a nearest
% integer. M colums indicate blocks: Sleep1, Bmi1/Reach1, Sleep2, Bmi1/Reach1
% Author@ Aamir Abbasi
%---------------------------------------------------------------------------------
clear;clc;close all;

rootpath = 'C:\Users\AbbasiM\Desktop\';

blockNames    = dir([rootpath,'I061\Data2\I061-200505*']);
plxfiles_eNe1 = dir([rootpath,'bmi-merged-plx\','BMI_zBus-200310-092524_I061-200505*_eNe1_1.plx']);
plxfiles_eTe1 = dir([rootpath,'bmi-merged-plx\','BMI_zBus-200310-092524_I061-200505*_eTe1_1.plx']);

durMAT = [];
block_no = 1;
for i=1:length(blockNames)
  
  disp(blockNames(i).name);
  
  [lenLFP_M1, lenLFP_Cb] = fn_getLFPLength([rootpath,'I061\Data2\',blockNames(i).name]);
  [~, ~, dur_M1] = fn_readPlxFile([rootpath,'bmi-merged-plx\',plxfiles_eNe1(i).name],0,1);
  [~, ~, dur_Cb] = fn_readPlxFile([rootpath,'bmi-merged-plx\',plxfiles_eTe1(i).name],0,1);
  
  durations = [lenLFP_M1;lenLFP_Cb;dur_M1;dur_Cb;...
                    floor(min([lenLFP_M1;lenLFP_Cb;dur_M1;dur_Cb]))];
  durMAT = [durMAT, durations];
  currentblock = blockNames(i).name; 
  if i+1<=length(blockNames)
    nexttblock = blockNames(i+1).name;
  end
  
  if strcmp(currentblock(1:11),nexttblock(1:11)) == 0
    save([rootpath,'bmi-files-mat\','Durations_',currentblock(6:11),num2str(block_no),'.mat'],'durMAT'); 
    block_no = block_no+1;
    durMAT = [];
  end
  
  if i==length(blockNames)
    save([rootpath,'bmi-files-mat\','Durations_',currentblock(6:11),num2str(block_no),'.mat'],'durMAT'); 
  end
  
end

