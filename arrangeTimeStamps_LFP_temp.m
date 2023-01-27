%% -------------------------------------------------------------------------------
% RUN THIS SCRIPT IF A SINGLE DAY IS ORGANIZED IN 4 BLOCKS 
% Turncate LFP, WAV channel and TimsStamps to a whole number in seconds
% This whole number comes from the duration matricies saved as a .mat files
% Author@ AAMIR ABBASI
%---------------------------------------------------------------------------------
clear;clc;close all;

rootpath = 'Z:\M1_Cb_Reach\I060\';
rootfolder = 'TDT_Data\';

blockNames    = dir([rootpath,rootfolder,'I050-200316*']);
plxfiles_eNe1 = dir([rootpath,'PlexonSortedData\','SORTED_M1_Day1.plx']);
plxfiles_eTe1 = dir([rootpath,'PlexonSortedData\','SORTED_Cb_Day1.plx']);
durationFiles = dir([rootpath,'Durations_200316.mat']);
ii = 1; kk = 1;
for j=1:length(plxfiles_eNe1)
  
  disp('reading plx files...');
  
  % Read concatanated and sorted plx files and the durations matrix of a single day
  [TimeStamps1, Waves1, ~] = fn_readPlxFile([rootpath,'PlexonSortedData\',plxfiles_eNe1(j).name]);
  [TimeStamps2, Waves2, ~] = fn_readPlxFile([rootpath,'PlexonSortedData\',plxfiles_eTe1(j).name]);
%   TimeStamps2 = TimeStamps1(1:16,:);
%   TimeStamps1 = TimeStamps1(17:end,:);
%   Waves2 = Waves1(1:16,:);
%   Waves1 = Waves1(17:end,:);
  load([rootpath,'',durationFiles(j).name]);
  
  % Loop over all the blocks of a single day
  for i=ii:length(blockNames)
    
    disp(blockNames(i).name);
    
    % Read LFP_M1, LFP_Cb and Wave files of a single blcok
    matFiles = dir([rootpath,rootfolder,blockNames(i).name,'\','*.mat']);
    for k=1:length(matFiles)
      load([rootpath,rootfolder,blockNames(i).name,'\',matFiles(k).name]);
    end
    
    % Turncate samples of the LFP and WAVE channels
    turncation_samp = round(durMAT(5,kk)*Fs);
    if exist('lfp_M1','var') == 1
      LFPs1 = lfp_M1(:,1:turncation_samp);
      save([rootpath,rootfolder,blockNames(i).name,'\','LFP_M1_Truncated.mat'],'LFPs1','Fs');
      clear LFPs1 lfp_M1
    end
    if exist('LFPs1','var') == 1
      LFPs1 = LFPs1(:,1:turncation_samp);
      save([rootpath,rootfolder,blockNames(i).name,'\','LFP_M1_Truncated.mat'],'LFPs1','Fs');
      clear LFPs1
    end
    if exist('lfp_Cb','var') == 1
      LFPs2 = lfp_Cb(:,1:turncation_samp);
      save([rootpath,rootfolder,blockNames(i).name,'\','LFP_Cb_Truncated.mat'],'LFPs2','Fs');
      clear LFPs2 lfp_Cb
    end
    if exist('LFPs2','var') == 1
      LFPs2 = LFPs2(:,1:turncation_samp);
      save([rootpath,rootfolder,blockNames(i).name,'\','LFP_Cb_Truncated.mat'],'LFPs2','Fs');
      clear LFPs2
    end
    if exist('WAVE','var') == 1
      WAVE = WAVE(1:turncation_samp);
      save([rootpath,rootfolder,blockNames(i).name,'\','WAV_Truncated.mat'],'WAVE','Fs');
      clear WAVE
    end
    if exist('wav','var') == 1
      WAVE = wav(1:turncation_samp);
      save([rootpath,rootfolder,blockNames(i).name,'\','WAV_Truncated.mat'],'WAVE','Fs');
      clear wav WAVE
    end
    kk = kk+1;
    
    % Get current block and the next block id
    currentblock = blockNames(i).name;
    if i+1<=length(blockNames)
      nextblock = blockNames(i+1).name;
    end
    
    % Switch to next day
    if strcmp(currentblock(1:11),nextblock(1:11)) == 0 || i==length(blockNames)
      
      % Extract block specific timestamps from the TimeStamps1&2 and Waves1&2
      TimeStamps1_S1 = cell(size(TimeStamps1,1),size(TimeStamps1,2));
      TimeStamps1_B1 = cell(size(TimeStamps1,1),size(TimeStamps1,2));
      TimeStamps1_S2 = cell(size(TimeStamps1,1),size(TimeStamps1,2));
      TimeStamps1_B2 = cell(size(TimeStamps1,1),size(TimeStamps1,2));
      
      TimeStamps2_S1 = cell(size(TimeStamps2,1),size(TimeStamps2,2));
      TimeStamps2_B1 = cell(size(TimeStamps2,1),size(TimeStamps2,2));
      TimeStamps2_S2 = cell(size(TimeStamps2,1),size(TimeStamps2,2));
      TimeStamps2_B2 = cell(size(TimeStamps2,1),size(TimeStamps2,2));
      
      Waves1_S1 = cell(size(TimeStamps1,1),size(TimeStamps1,2));
      Waves1_B1 = cell(size(TimeStamps1,1),size(TimeStamps1,2));
      Waves1_S2 = cell(size(TimeStamps1,1),size(TimeStamps1,2));
      Waves1_B2 = cell(size(TimeStamps1,1),size(TimeStamps1,2));
      
      Waves2_S1 = cell(size(TimeStamps2,1),size(TimeStamps2,2));
      Waves2_B1 = cell(size(TimeStamps2,1),size(TimeStamps2,2));
      Waves2_S2 = cell(size(TimeStamps2,1),size(TimeStamps2,2));
      Waves2_B2 = cell(size(TimeStamps2,1),size(TimeStamps2,2));
      
      % For M1 units
      for ch = 1:size(TimeStamps1,1)
        for u = 2:size(TimeStamps1,2)
     
          if ~isempty(TimeStamps1{ch,u})
            ts1 = cell2mat(TimeStamps1(ch,u));
            w1 = cell2mat(Waves1(ch,u));
            
            ts1_S1 = ts1(ts1<durMAT(5,1));
            TimeStamps1_S1{ch,u} = ts1_S1;
            Waves1_S1{ch,u} = w1(:,1:length(ts1_S1));
            
            valid_ind = logical((ts1>durMAT(3,1)).*(ts1<(durMAT(5,2)+durMAT(3,1))));
            ts1_B1 = ts1(valid_ind)-durMAT(3,1);
            TimeStamps1_B1{ch,u} = ts1_B1;
            Waves1_B1{ch,u} = w1(:,valid_ind);
            
            valid_ind = logical((ts1>durMAT(3,1)+durMAT(3,2)).*(ts1<(durMAT(3,1)+durMAT(3,2)+durMAT(5,3))));
            ts1_S2 = ts1(valid_ind)-(durMAT(3,1)+durMAT(3,2));
            TimeStamps1_S2{ch,u} = ts1_S2;
            Waves1_S2{ch,u} = w1(:,valid_ind);
            
            valid_ind = logical((ts1>durMAT(3,1)+durMAT(3,2)+durMAT(3,3)).*(ts1<durMAT(5,4)+durMAT(3,1)+durMAT(3,2)+durMAT(3,3)));
            ts1_B2 = ts1(valid_ind)-(durMAT(3,1)+durMAT(3,2)+durMAT(3,3));
            TimeStamps1_B2{ch,u} = ts1_B2;
            Waves1_B2{ch,u} = w1(:,valid_ind);
          end
          
        end
      end
      
      % For Cb units
      for ch = 1:size(TimeStamps2,1)
        for u = 2:size(TimeStamps2,2)
          
          if ~isempty(TimeStamps2{ch,u})
            ts2 = cell2mat(TimeStamps2(ch,u));
            w2 = cell2mat(Waves2(ch,u));
            
            ts2_S1 = ts2(ts2<durMAT(5,1));
            TimeStamps2_S1{ch,u} = ts2_S1;
            Waves2_S1{ch,u} = w2(:,1:length(ts2_S1));
            
            valid_ind = logical((ts2>durMAT(4,1)).*(ts2<(durMAT(5,2)+durMAT(4,1))));
            ts2_B1 = ts2(valid_ind)-durMAT(4,1);
            TimeStamps2_B1{ch,u} = ts2_B1;
            Waves2_B1{ch,u} = w2(:,valid_ind);
            
            valid_ind = logical((ts2>durMAT(4,1)+durMAT(4,2)).*(ts2<(durMAT(4,1)+durMAT(4,2)+durMAT(5,3))));
            ts2_S2 = ts2(valid_ind)-(durMAT(4,1)+durMAT(4,2));
            TimeStamps2_S2{ch,u} = ts2_S2;
            Waves2_S2{ch,u} = w2(:,valid_ind);
            
            valid_ind = logical((ts2>durMAT(4,1)+durMAT(4,2)+durMAT(4,3)).*(ts2<durMAT(5,4)+durMAT(4,1)+durMAT(4,2)+durMAT(4,3)));
            ts2_B2 = ts2(valid_ind)-(durMAT(4,1)+durMAT(4,2)+durMAT(4,3));
            TimeStamps2_B2{ch,u} = ts2_B2;
            Waves2_B2{ch,u} = w2(:,valid_ind);
          end
        end
      end
      
      save([rootpath,rootfolder,blockNames(i-3).name,'\Timestamps_S1.mat'],'TimeStamps1_S1','TimeStamps2_S1');
      save([rootpath,rootfolder,blockNames(i-2).name,'\Timestamps_B1.mat'],'TimeStamps1_B1','TimeStamps2_B1');
      save([rootpath,rootfolder,blockNames(i-1).name,'\Timestamps_S2.mat'],'TimeStamps1_S2','TimeStamps2_S2');
      save([rootpath,rootfolder,blockNames(i).name,'\Timestamps_B2.mat'],'TimeStamps1_B2','TimeStamps2_B2');
      
      save([rootpath,rootfolder,blockNames(i-3).name,'\Waves_S1.mat'],'Waves1_S1','Waves2_S1');
      save([rootpath,rootfolder,blockNames(i-2).name,'\Waves_B1.mat'],'Waves1_B1','Waves2_B1');
      save([rootpath,rootfolder,blockNames(i-1).name,'\Waves_S2.mat'],'Waves1_S2','Waves2_S2');
      save([rootpath,rootfolder,blockNames(i).name,'\Waves_B2.mat'],'Waves1_B2','Waves2_B2');
      
      ii=i+1; kk=1; break;
    end
  end
end
