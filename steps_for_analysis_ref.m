%%%% Author - Aamir Abbasi
%%%% BMI Data Analysis Gulati Lab
%% Read TDT blocks and save each block to a mat file
clc; clear; close;
root = 'Z:\TDTData\BMI_zBus-200310-092524\';
cd(root);

blockNames = dir('I*');
for i = 1:length(blockNames)
  blockpath = strcat(blockNames(i).name);
  disp(blockpath);
  
  if ~exist(strcat(blockpath,'\LFP_M1.mat'),'file') || ~exist(strcat(blockpath,'\WAV.mat'),'file')...
      || ~exist(strcat(blockpath,'\LFP_Cb.mat'),'file')
    
    % Read stream data from a TDT block
    data = TDTbin2mat(blockpath,'TYPE',4);
    
    % Extract and save wave channel
    wav = data.streams.Wav1.data;
    fs = data.streams.Wav1.fs;
    save(strcat(blockpath,'\WAV.mat'),'wav','fs');
    
    % Extract and save M1 LFP
    lfp_M1 = data.streams.LFP1.data;
    fs = data.streams.LFP1.fs;
    save(strcat(blockpath,'\LFP_M1.mat'),'lfp_M1','fs');
    
    % Extract and save Cb LFP
    lfp_Cb = data.streams.LFP2.data;
    fs = data.streams.LFP2.fs;
    save(strcat(blockpath,'\LFP_Cb.mat'),'lfp_Cb','fs');
    
    %save(strcat(blockpath,'\SU_CONT.mat'),'su_cont','-v7.3');
  end
  
  %     snips = data.snips.eNe1;
  %     if ~exist(strcat(blockpath,'\SNIPS.mat'),'file')
  %         save(strcat(blockpath,'\SNIPS.mat'),'snips');
  %     end
end

%% -------------------------------------------------------------------------------
% Script to get recorded and single units timestamps duration for each block.
% This script arranges the duration in a N rows x M columns matrix where N is
% LFP_M1, LFP_Cb, Timestamps_M1, Timestamps_Cb, Turncated timestamp to a nearest
% integer. M colums indicate blocks: Sleep1, Bmi1/Reach1, Sleep2, Bmi1/Reach1
%---------------------------------------------------------------------------------
clear;clc;close all;

rootpath = 'Z:\TDTData\BMI_zBus-200310-092524\';

blockNames = dir([rootpath,'I050*']);
plxfiles_eNe1 = dir([rootpath,'Reaching_Plx\','B*_eNe1_1.plx']);
plxfiles_eTe1 = dir([rootpath,'Reaching_Plx\','B*_eTe1_1.plx']);

durMAT = [];
block_no = 1;
for i=1:length(blockNames)
  
  disp(blockNames(i).name);
  
  [lenLFP_M1, lenLFP_Cb] = fn_getLFPLength([rootpath,blockNames(i).name]);
  [~, ~, dur_M1] = fn_readPlxFile([rootpath,'Reaching_Plx\',plxfiles_eNe1(i).name],0,1);
  [~, ~, dur_Cb] = fn_readPlxFile([rootpath,'Reaching_Plx\',plxfiles_eTe1(i).name],0,1);
  
  durations = [lenLFP_M1;lenLFP_Cb;dur_M1;dur_Cb;...
    floor(min([lenLFP_M1;lenLFP_Cb;dur_M1;dur_Cb]))];
  durMAT = [durMAT, durations];
  currentblock = blockNames(i).name;
  if i+1<=length(blockNames)
    nextblock = blockNames(i+1).name;
  end
  
  if strcmp(currentblock(1:11),nextblock(1:11)) == 0
    save([rootpath,'Durations_',currentblock(6:11),num2str(block_no),'.mat'],'durMAT');
    block_no = block_no+1;
    durMAT = [];
  end
  
  if i==length(blockNames)
    save([rootpath,'Durations_',currentblock(6:11),num2str(block_no),'.mat'],'durMAT');
  end
  
end

%% -------------------------------------------------------------------------------
% Script to resample LFPs and WAVE channesl from 1017Hz to 1000Hz.
% Turncate LFP, WAV channel and TimsStamps to a whole number in seconds
% This whole number comes from the duration matricies saved as a .mat files
%---------------------------------------------------------------------------------
clear;clc;close all;

rootpath = 'C:\Users\AbbasiM\Desktop\';

blockNames    = dir([rootpath,'bmi-files-mat\I060*']);
plxfiles_eNe1 = dir([rootpath,'bmi-merged-plx\','SORTED*_eNe1_1_mrg.plx']);
plxfiles_eTe1 = dir([rootpath,'bmi-merged-plx\','SORTED*_eTe1_1_mrg.plx']);
durationFiles = dir([rootpath,'bmi-files-mat\Durations*.mat']);
ii = 1;
kk = 1;
for j=1:length(plxfiles_eNe1)
  
  % Read concatanated and sorted plx files and the durations matrix of a single day
  [TimeStamps1, Waves1, ~] = fn_readPlxFile([rootpath,'bmi-merged-plx\',plxfiles_eNe1(j).name]);
  [TimeStamps2, Waves2, ~] = fn_readPlxFile([rootpath,'bmi-merged-plx\',plxfiles_eTe1(j).name]);
  load([rootpath,'bmi-files-mat\',durationFiles(j).name]);
  
  % Loop over all the blocks of a single day
  for i=ii:length(blockNames)
    
    disp(blockNames(i).name);
    
    % Get current block and the next block id
    currentblock = blockNames(i).name;
    if i+1<=length(blockNames)
      nextblock = blockNames(i+1).name;
    end
    
    % Read LFP_M1, LFP_Cb and Wave files of a single blcok
    if strcmp(currentblock(1:11),nextblock(1:11)) == 1
      matFiles = dir([rootpath,'bmi-files-mat\',blockNames(i).name,'\','*.mat']);
      for k=1:length(matFiles)
        load([rootpath,'bmi-files-mat\',blockNames(i).name,'\',matFiles(k).name]);
      end
    end
    
    % Turncate samples of the LFP and WAVE channels
    turncation_samp = round(durMAT(5,kk)*fs);
    if exist('lfp_M1','var') == 1
      LFPs1 = lfp_M1(:,1:turncation_samp);
      Fs = fs;
      save([rootpath,'bmi-files-mat\',blockNames(i).name,'\','LFP_M1_Turncated.mat'],'LFPs1','Fs');
    end
    if exist('LFPs1','var') == 1
      LFPs1 = LFPs1(:,1:turncation_samp);
      save([rootpath,'bmi-files-mat\',blockNames(i).name,'\','LFP_M1_Turncated.mat'],'LFPs1','Fs');
    end
    if exist('lfp_Cb','var') == 1
      LFPs2 = lfp_Cb(:,1:turncation_samp);
      Fs = fs;
      save([rootpath,'bmi-files-mat\',blockNames(i).name,'\','LFP_Cb_Turncated.mat'],'LFPs2','Fs');
    end
    if exist('LFPs2','var') == 1
      LFPs2 = LFPs2(:,1:turncation_samp);
      save([rootpath,'bmi-files-mat\',blockNames(i).name,'\','LFP_Cb_Turncated.mat'],'LFPs2','Fs');
    end
    if exist('WAVE','var') == 1
      WAVE = lfp_M1(:,1:turncation_samp);
      save([rootpath,'bmi-files-mat\',blockNames(i).name,'\','WAV_Turncated.mat'],'WAVE','fs');
    end
    if exist('wav','var') == 1
      WAVE = lfp_M1(:,1:turncation_samp);
      Fs = fs;
      save([rootpath,'bmi-files-mat\',blockNames(i).name,'\','WAV_Turncated.mat'],'WAVE','fs');
    end
    
    kk = kk+1;
    % Switch to next day
    if strcmp(currentblock(1:11),nextblock(1:11)) == 0 || i==length(blockNames)
      
      % Extract block specific timestamps from the TimeStamps1&2
      TimeStamps1_S1 = cell(size(TimeStamps1,1),size(TimeStamps1,2));
      TimeStamps1_B1 = cell(size(TimeStamps1,1),size(TimeStamps1,2));
      TimeStamps1_S2 = cell(size(TimeStamps1,1),size(TimeStamps1,2));
      TimeStamps1_B2 = cell(size(TimeStamps1,1),size(TimeStamps1,2));
      
      TimeStamps2_S1 = cell(size(TimeStamps1,1),size(TimeStamps1,2));
      TimeStamps2_B1 = cell(size(TimeStamps1,1),size(TimeStamps1,2));
      TimeStamps2_S2 = cell(size(TimeStamps1,1),size(TimeStamps1,2));
      TimeStamps2_B2 = cell(size(TimeStamps1,1),size(TimeStamps1,2));
      
      for ch = 1:size(TimeStamps1,1)
        for u = 2:size(TimeStamps1,2)
          
          if ~isempty(TimeStamps1{ch,u}) || ~isempty(TimeStamps2{ch,u})
            ts1 = cell2mat(TimeStamps1(ch,u));
            ts2 = cell2mat(TimeStamps2(ch,u));
            
            ts1_S1 = ts1(ts1<durMAT(5,1));
            ts2_S1 = ts2(ts2<durMAT(5,1));
            TimeStamps1_S1{ch,u} = ts1_S1;
            TimeStamps2_S1{ch,u} = ts2_S1;
            
            valid_ind = logical((ts1>durMAT(3,1)).*(ts1<(durMAT(5,2)+durMAT(3,1))));
            valid_ind_2 = logical((ts2>durMAT(4,1)).*(ts2<(durMAT(5,2)+durMAT(4,1))));
            ts1_B1 = ts1(valid_ind)-durMAT(3,1);
            ts2_B1 = ts2(valid_ind_2)-durMAT(4,1);
            TimeStamps1_B1{ch,u} = ts1_B1;
            TimeStamps2_B1{ch,u} = ts2_B1;
            
            valid_ind = logical((ts1>durMAT(3,1)+durMAT(3,2)).*(ts1<(durMAT(3,1)+durMAT(3,2)+durMAT(5,3))));
            valid_ind_2 = logical((ts2>durMAT(4,1)+durMAT(4,2)).*(ts2<(durMAT(4,1)+durMAT(4,2)+durMAT(5,3))));
            ts1_S2 = ts1(valid_ind)-(durMAT(3,1)+durMAT(3,2));
            ts2_S2 = ts2(valid_ind_2)-(durMAT(4,1)+durMAT(4,2));
            TimeStamps1_S2{ch,u} = ts1_S2;
            TimeStamps2_S2{ch,u} = ts2_S2;
            
            valid_ind = logical((ts1>durMAT(3,1)+durMAT(3,2)+durMAT(3,3)).*(ts1<durMAT(5,4)+durMAT(3,1)+durMAT(3,2)+durMAT(3,3)));
            valid_ind_2 = logical((ts2>durMAT(4,1)+durMAT(4,2)+durMAT(4,3)).*(ts2<durMAT(5,4)+durMAT(4,1)+durMAT(4,2)+durMAT(4,3)));
            ts1_B2 = ts1(valid_ind)-(durMAT(3,1)+durMAT(3,2)+durMAT(3,3));
            ts2_B2 = ts2(valid_ind_2)-(durMAT(4,1)+durMAT(4,2)+durMAT(4,3));
            TimeStamps1_B2{ch,u} = ts1_B2;
            TimeStamps2_B2{ch,u} = ts2_B2;
          end
        end
      end
      save([rootpath,'bmi-files-mat\',blockNames(i-3).name,'\Timestamps_S1.mat'],'TimeStamps1_S1','TimeStamps2_S1');
      save([rootpath,'bmi-files-mat\',blockNames(i-2).name,'\Timestamps_B1.mat'],'TimeStamps1_B1','TimeStamps2_B1');
      save([rootpath,'bmi-files-mat\',blockNames(i-1).name,'\Timestamps_S2.mat'],'TimeStamps1_S2','TimeStamps2_S2');
      save([rootpath,'bmi-files-mat\',blockNames(i).name,'\Timestamps_B2.mat'],'TimeStamps1_B2','TimeStamps2_B2');
      ii=i+1; kk=1; break;
    end
  end
end

%%%%%%%% GENERATE RASTERS AND PSTH FOR ALL NEURONS %%%%%%%%%%%%%%%%
%% Load two BMI blocks data from the same day
clc; clear; close all;
disp('running');
rootpath = 'C:\Users\AbbasiM\Desktop\I061\Data2\';
savepath = 'C:\Users\AbbasiM\Desktop\I061\Figs2\';

%%%%%%%%%%%%%%%%%%%%%%%%%  LIST OF BLOCK ID FOR RAT I050  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auto  bmiBlocks = {'I050-191217-103432','I050-191217-113230'}; tStart = 1; tStop = 73;
% Day1  bmiBlocks = {'I050-191218-112504','I050-191218-130447'}; tStart = 42,25; tStop  = 97,80;
% Day2  bmiBlocks = {'I050-191219-105728','I050-191219-141503'}; tStart = 21,1; tStop  = 80,56;
% Day3  bmiBlocks = {'I050-191220-104050','I050-191220-135239'}; tStart = 17,1; tStop  = 84,61;
% Day4  bmiBlocks = {'I050-191221-121617','I050-191221-141352'}; tStart = 1,12; tStop  = 95,65;
% Day5  bmiBlocks = {'I050-191223-133408','I050-191223-160416'}; tStart = 1,1; tStop  = 97,43;
% Day6  bmiBlocks = {'I050-191224-105024','I050-191224-121153'}; tStart = 27,1; tStop  = 74;21;

%%%%%%%%%%%%%%%%%%%%%%%%%  LIST OF BLOCK ID FOR RAT I060  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auto  bmiBlocks = {'I060-200309-121246'}; tStart = 1; tStop = 73;
% Day1  bmiBlocks = {'I060-200310-112339','I060-200310-143141'}; tStart = 32,1; tStop  = 230,124;
% Day2  bmiBlocks = {'I060-200311-114150','I060-200311-140222'}; tStart = 21,1; tStop  = 110,124;
% Day3  bmiBlocks = {'I060-200312-111249','I060-200312-134253'}; tStart = 11,1; tStop  = 126,84;
% Day4  bmiBlocks = {'I060-200313-113905','I060-200313-142005'}; tStart = 74,1; tStop  = 148,100;
% Day5  bmiBlocks = {'I060-200314-131648','I060-200314-160410'}; tStart = 15,1; tStop  = 122,46;

%%%%%%%%%%%%%%%%%%%%%%%%%  LIST OF BLOCK ID FOR RAT I061  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auto  bmiBlocks = {'I061-200504-122708','I061-200504-124440'}; 
% Day1  bmiBlocks = {'I061-200505-131845','I061-200505-144749'}; tStart = 6,1; tStop  = 119,62;
% Day2  bmiBlocks = {'I061-200506-110632','I061-200506-142306'}; tStart = 6,1; tStop  = 221,198;
% Day3  bmiBlocks = {'I061-200507-111109','I061-200507-131918'}; tStart = 51,1; tStop  = 138,102;
% Day4  bmiBlocks = {'I061-200508-120338','I061-200508-142120'}; tStart = 11,1; tStop  = 181,170;
% Day5  bmiBlocks = {'I061-200509-122650','I061-200509-150451'}; tStart = 8,1; tStop  = 183,58;

bmiBlocks = {'I061-200505-131845','I061-200505-144749'};
for i=1:length(bmiBlocks)
  
  disp(bmiBlocks{i});
  
  % Read Timestamps files from a single blcok
  matFiles = dir([rootpath, bmiBlocks{i},'\','*.mat']);
  for k=1:length(matFiles)
    load([rootpath, bmiBlocks{i},'\',matFiles(k).name]);
  end
  
  % Get performance curves and rasters
  before_zero = 4;
  after_zero = 7;
  if i==1
    if strcmp(bmiBlocks{i},'I060-200311-114150')==1
      [performance_B1,all_trials_B1, rtrials_onset_B1,rewards_onset_B1] = fn_getPerformanceTimestamps_I060_200311(WAVE,Fs,1,1);
    else
      [performance_B1,all_trials_B1, rtrials_onset_B1,rewards_onset_B1] = fn_getPerformanceTimestamps(WAVE,Fs,1,1);
    end
    tStart = 1;
    tStop  = 118;
    TimeStamps2_B1 = TimeStamps2_B1(1:4:end,:);
    [PSTH1_B1,PSTH2_B1,bins_B1] = fn_getPSTH(TimeStamps1_B1,all_trials_B1,Fs,[savepath,bmiBlocks{i},'\'],tStart,tStop,TimeStamps2_B1,0,before_zero,after_zero,0);
    fn_getRasters(TimeStamps1_B1,all_trials_B1,rewards_onset_B1,Fs,[savepath,bmiBlocks{i},'\'],tStart,tStop,TimeStamps2_B1,0,before_zero,15,0);
    save([rootpath,bmiBlocks{1},'\Events_Performance_PSTH.mat'],'performance_B1','all_trials_B1','rtrials_onset_B1','rewards_onset_B1','PSTH1_B1','PSTH2_B1','bins_B1');
  else
    if strcmp(bmiBlocks{i},'I060-200311-140222')==1
      [performance_B2,all_trials_B2, rtrials_onset_B2,rewards_onset_B2] = fn_getPerformanceTimestamps_I060_200311(WAVE,Fs,2,1);
    else
      [performance_B2,all_trials_B2, rtrials_onset_B2,rewards_onset_B2] = fn_getPerformanceTimestamps(WAVE,Fs,1,1);
    end
    tStart = 1;
    tStop  = 62;
    TimeStamps2_B2 = TimeStamps2_B2(1:4:end,:);
    [PSTH1_B2,PSTH2_B2,bins_B2] = fn_getPSTH(TimeStamps1_B2,all_trials_B2,Fs,[savepath,bmiBlocks{i},'\'],tStart,tStop,TimeStamps2_B2,0,before_zero,after_zero,0);
    fn_getRasters(TimeStamps1_B2,all_trials_B2,rewards_onset_B2,Fs,[savepath,bmiBlocks{i},'\'],tStart,tStop,TimeStamps2_B2,0,before_zero,15,0);
    save([rootpath,bmiBlocks{2},'\Events_Performance_PSTH.mat'],'performance_B2','all_trials_B2','rtrials_onset_B2','rewards_onset_B2','PSTH1_B2','PSTH2_B2','bins_B2');
  end
  
end
disp('done');

%%%%%%%%%%%%% PERFORMANCE CURVE ANALYSIS %%%%%%%%%%%%%%%%
%% Plot learning curves for all the sessions for visual inspection
clear;clc;close all;
disp('running');
rootpath = 'C:\Users\AbbasiM\Desktop\';
bmiBlocks =  { 'I060\Data\I060-200310-112339'...
  ,'I060\Data\I060-200311-114150'...
  ,'I060\Data\I060-200312-111249'...
  ,'I060\Data\I060-200313-113905'...
  ,'I060\Data\I060-200314-131648'...
  ,'I050\Data\I050-191218-112504'...
  ,'I050\Data\I050-191219-105728'...
  ,'I050\Data\I050-191220-104050'...
  ,'I050\Data\I050-191221-121617'...
  ,'I050\Data\I050-191223-133408'};

tstart = [32,21,11,74,15,42,21,17,1,1];
tstop  = [230,110,126,148,122,97,80,84,95,97];
day = 0;

figure('Color','white','Position',get(0,'Screensize'));
for i=1:length(bmiBlocks)
  
  disp(bmiBlocks{i});
  
  % Read performance data
  matFiles = dir([rootpath, bmiBlocks{i},'\','E*.mat']);
  for k=1:length(matFiles)
    load([rootpath, bmiBlocks{i},'\',matFiles(k).name],'per*');
  end
  
  % Performance during BMI1 and BMI2
  valid_perf = performance_B1(tstart(i):tstop(i));
  
  % Get current block and the next block id
  currentblock = bmiBlocks{i}(1:4);
  if i+1<=length(bmiBlocks)
    nextblock = bmiBlocks{i+1}(1:4);
  end
  
  % Plot
  day = day+1; subplot(2,3,day);
  plot(valid_perf,'r','LineWidth',2);
  title(['RAT-',bmiBlocks{i}(1:4),'-Day-',num2str(day)]); ylim([0,16]);
  
  % Switch to next day
  if strcmp(currentblock,nextblock) == 0
    day = 0;
    figure('Color','white','Position',get(0,'Screensize'));
  end
  
end
%% Analyze learning curves session by session
clear;clc;close all;
disp('running');
rootpath = 'Z:\Aamir\BMI\';
bmiBlocks =  { 'I061\Data\I061-200505-131845'...
              ,'I061\Data\I061-200506-110632'...
              ,'I061\Data\I061-200507-111109'...
              ,'I061\Data\I061-200508-120338'...
              ,'I061\Data\I061-200509-122650'};

% bmiBlocks =  { 'I060\Data\I060-200310-112339'...
%               ,'I060\Data\I060-200311-114150'...
%               ,'I060\Data\I060-200312-111249'...
%               ,'I060\Data\I060-200313-113905'...
%               ,'I060\Data\I060-200314-131648'...
%               ,'I050\Data\I050-191218-112504'...
%               ,'I050\Data\I050-191219-105728'...
%               ,'I050\Data\I050-191220-104050'...
%               ,'I050\Data\I050-191221-121617'...
%               ,'I050\Data\I050-191223-133408'};

% Valid trial markers
tstart = [6, 6, 51, 11, 8]; %[32,21,11,74,15,42,21,17,1,1];
tstop  = [118, 221, 138, 181, 183]; %[230,110,126,148,122,97,80,84,95,97];

% Early late classification based on visual inspection
early_trials_end = [70, 50, 40, 30,  60 ];%[39,30,63,18,59,24,30,39,47,21];
late_trials_end = [113, 216, 88, 170, 170];%[199,89,116,75,108,53,60,68,95,97];

for i=1:length(bmiBlocks)
  
  disp(bmiBlocks{i});
  
  % Read performance data
  matFiles = dir([rootpath, bmiBlocks{i},'\','E*.mat']);
  for k=1:length(matFiles)
    load([rootpath, bmiBlocks{i},'\',matFiles(k).name],'per*');
  end
  
  % Performance during BMI1 and BMI2
  valid_pref = performance_B1(tstart(i):tstop(i));
  
  % Stats
  early  = valid_pref(1:early_trials_end(i));
  late   = valid_pref(early_trials_end(i)+1:late_trials_end(i));
  if length(early)<=length(late)
    [h,p_val] = ttest(early,late(length(late)-length(early)+1:end),'Tail','right');
    mean_perf =[mean(early),mean(late(length(late)-length(early)+1:end))];
  elseif length(early)>=length(late)
    [h,p_val] = ttest(early(1:length(late)),late,'Tail','right');
    mean_perf =[mean(early(1:length(late))),mean(late)];
  end
  
  % Save
  save([rootpath,bmiBlocks{i},'\Performance_stats_early_late.mat'],'valid_pref','h','p_val','mean_perf');
end
disp('done');

%% Show Robust learning and Poor learning sessions
clear;clc;close all;
disp('running');
rootpath = 'Z:\Aamir\BMI\';
bmiBlocks =  { 'I060\Data\I060-200310-112339'...
              ,'I060\Data\I060-200311-114150'...
              ,'I060\Data\I060-200312-111249'...
              ,'I060\Data\I060-200313-113905'...
              ,'I060\Data\I060-200314-131648'...
              ,'I050\Data\I050-191218-112504'...
              ,'I050\Data\I050-191219-105728'...
              ,'I050\Data\I050-191220-104050'...
              ,'I050\Data\I050-191221-121617'...
              ,'I050\Data\I050-191223-133408'...
              ,'I061\Data\I061-200505-131845'...
              ,'I061\Data\I061-200506-110632'...
              ,'I061\Data\I061-200507-111109'...
              ,'I061\Data\I061-200508-120338'...
              ,'I061\Data\I061-200509-122650'};

for i=1:length(bmiBlocks)
  
  disp(bmiBlocks{i});
  
  % Read performance stats
  matFiles = dir([rootpath, bmiBlocks{i},'\','Performance_stats_early_late.mat']);
  for k=1:length(matFiles)
    load([rootpath, bmiBlocks{i},'\',matFiles(k).name]);
  end
  
  % Tag sessions as RL or PL
  session_tags(i,:) = [h p_val];
  
end
disp('done')

%% Generate performance early late bar plots for robust learning sessions
clc;clear;close all;
rootpath = 'Z:\Aamir\BMI\';
bmiBlocks =  { 'I060\Data\I060-200310-112339'...
              ,'I060\Data\I060-200312-111249'...
              ,'I060\Data\I060-200313-113905'...
              ,'I060\Data\I060-200314-131648'...
              ,'I050\Data\I050-191218-112504'...
              ,'I050\Data\I050-191220-104050'...
              ,'I050\Data\I050-191221-121617'...
              ,'I061\Data\I061-200506-110632'...
              ,'I061\Data\I061-200508-120338'...
              ,'I061\Data\I061-200509-122650'};

for i=1:length(bmiBlocks)
  load([rootpath,bmiBlocks{i},'\Performance_stats_early_late.mat'],'mean_perf');
  mean_perf_consolidated(i,:) = mean_perf(1:2);
end

figure('Color','white'); hold all;
bar(mean(mean_perf_consolidated));
errorbar([1,2],mean(mean_perf_consolidated),std(mean_perf_consolidated)/(size(mean_perf_consolidated,1)-1),'.');
scatter(ones(size(mean_perf_consolidated,1),1),mean_perf_consolidated(:,1));
scatter(ones(size(mean_perf_consolidated,1),1)*2,mean_perf_consolidated(:,2));
plot(mean_perf_consolidated','k')
[~,pVal] = ttest(mean_perf_consolidated(:,1),mean_perf_consolidated(:,2));

%% Generate an example learning curve for Robust Learning
clear; clc; close all;
rootpath = 'C:\Users\AbbasiM\Desktop\I060\Data\';
filename = dir([rootpath,'Day_1*']);
load([rootpath,filename.name],'consolidated_perf','transition_trial','mean_perf');
valid_pref(valid_pref>15) = 15;
figure('Color','white');
tsmooth_window = 10;
% plot(consolidated_perf,'r','LineWidth',2);
plot(smooth(valid_pref,tsmooth_window,'moving'),'r','LineWidth',2);
xlim([0,200]); ylim([0,16]);
vline(transition_trial,'k'); hline(mean_perf(1),'k');

%% Percentage of successful vs unsucessful for robust learning sessions
clc;clear;close all;
rootpath = 'Z:\Aamir\BMI\';
bmiBlocks =  { 'I060\Data\I060-200310-112339'...
              ,'I060\Data\I060-200312-111249'...
              ,'I060\Data\I060-200313-113905'...
              ,'I060\Data\I060-200314-131648'...
              ,'I050\Data\I050-191218-112504'...
              ,'I050\Data\I050-191220-104050'...
              ,'I050\Data\I050-191221-121617'...
              ,'I061\Data\I061-200506-110632'...
              ,'I061\Data\I061-200508-120338'...
              ,'I061\Data\I061-200509-122650'};

for i=1:length(bmiBlocks)
  load([rootpath,bmiBlocks{i},'\Performance_stats_early_late.mat'],'valid_pref');
  tOutcome(i,2) = sum(valid_pref<15)/length(valid_pref)*100; % unsuccessful
  tOutcome(i,1) = sum(valid_pref>=15)/length(valid_pref)*100; % successful
end

figure('Color','white'); hold all;
bar(mean(tOutcome));
errorbar([1,2],mean(tOutcome),std(tOutcome)/(size(tOutcome,1)-1),'.');
scatter(ones(size(tOutcome,1),1),tOutcome(:,1));
scatter(ones(size(tOutcome,1),1)*2,tOutcome(:,2));
plot(tOutcome','k')
[~,pV] = ttest(tOutcome(:,1),tOutcome(:,2));

%% Generate example learning curve for a poor learning session
clear; clc; close all;
rootpath = 'C:\Users\AbbasiM\Desktop\';
load([rootpath,'I050\Data\I050-191223-133408','\Performance_stats_early_late.mat'],'mean_perf','valid_pref');

figure('Color','white');
tsmooth_window = 20;
% plot(consolidated_perf,'r','LineWidth',2);
plot(smooth(valid_pref,tsmooth_window,'moving'),'r','LineWidth',2);
xlim([0,95]); ylim([0,16]);
hline(mean_perf(1),'k');

%% Generate performance early late bar plots for poor learning sessions
clc;clear;close all;
rootpath = 'C:\Users\AbbasiM\Desktop\';
bmiBlocks =  { 'I060\Data\I060-200311-114150'...
  ,'I050\Data\I050-191219-105728'...
  ,'I050\Data\I050-191223-133408'};

for i=1:length(bmiBlocks)
  load([rootpath,bmiBlocks{i},'\Performance_stats_early_late.mat'],'mean_perf');
  mean_perf_consolidated(i,:) = mean_perf(1:2);
end

figure('Color','white'); hold all;
bar(mean(mean_perf_consolidated));
errorbar([1,2],mean(mean_perf_consolidated),std(mean_perf_consolidated)/(size(mean_perf_consolidated,1)-1),'.');
scatter(ones(size(mean_perf_consolidated,1),1),mean_perf_consolidated(:,1));
scatter(ones(size(mean_perf_consolidated,1),1)*2,mean_perf_consolidated(:,2));
plot(mean_perf_consolidated','k')
[~,pVal] = ttest(mean_perf_consolidated(:,1),mean_perf_consolidated(:,2));

%% Percentage of successful vs unsucessful trials for poor learning sessions
clc;clear;close all;
rootpath = 'C:\Users\AbbasiM\Desktop\';
bmiBlocks =  { 'I060\Data\I060-200311-114150'...
  ,'I050\Data\I050-191219-105728'...
  ,'I050\Data\I050-191223-133408'};

for i=1:length(bmiBlocks)
  load([rootpath,bmiBlocks{i},'\Performance_stats_early_late.mat'],'valid_pref');
  tOutcome(i,1) = sum(valid_pref<5)/length(valid_pref)*100; % successful
  tOutcome(i,2) = sum(valid_pref>=5)/length(valid_pref)*100; % unsuccessful
end

figure('Color','white'); hold all;
bar(mean(tOutcome));
errorbar([1,2],mean(tOutcome),std(tOutcome)/(size(tOutcome,1)-1),'.');
scatter(ones(size(tOutcome,1),1),tOutcome(:,1));
scatter(ones(size(tOutcome,1),1)*2,tOutcome(:,2));
plot(tOutcome','k')
[~,pV] = ttest(tOutcome(:,1),tOutcome(:,2));

%% %%%%%%%%%%%%%%%%%%%%%%%  LIST OF BLOCK ID FOR RAT I050  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auto  bmiBlocks = {'I050-191217-103432','I050-191217-113230'}; tStart = 1; tStop = 73;
% Day1  bmiBlocks = {'I050-191218-112504','I050-191218-130447'}; tStart = 42,25; tStop  = 97,80;
% Day2  bmiBlocks = {'I050-191219-105728','I050-191219-141503'}; tStart = 21,1; tStop  = 80,56;
% Day3  bmiBlocks = {'I050-191220-104050','I050-191220-135239'}; tStart = 17,1; tStop  = 84,61;
% Day4  bmiBlocks = {'I050-191221-121617','I050-191221-141352'}; tStart = 1,12; tStop  = 95,65;
% Day5  bmiBlocks = {'I050-191223-133408','I050-191223-160416'}; tStart = 1,1; tStop  = 97,43;
% Day6  bmiBlocks = {'I050-191224-105024','I050-191224-121153'}; tStart = 27,1; tStop  = 74;21;

%%%%%%%%%%%%%%%%%%%%%%%%%  LIST OF BLOCK ID FOR RAT I060  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auto  bmiBlocks = {'I060-200309-121246'}; tStart = 1; tStop = 73;
% Day1  bmiBlocks = {'I060-200310-112339','I060-200310-143141'}; tStart = 32,1; tStop  = 230,124;
% Day2  bmiBlocks = {'I060-200311-114150','I060-200311-140222'}; tStart = 21,1; tStop  = 110,124;
% Day3  bmiBlocks = {'I060-200312-111249','I060-200312-134253'}; tStart = 11,1; tStop  = 126,84;
% Day4  bmiBlocks = {'I060-200313-113905','I060-200313-142005'}; tStart = 74,1; tStop  = 148,100;
% Day5  bmiBlocks = {'I060-200314-131648','I060-200314-160410'}; tStart = 15,1; tStop  = 122,46;

%%%%%%%%%%%%%%%%%%%%%%%%%  LIST OF BLOCK ID FOR RAT I061  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auto  bmiBlocks = {'I061-200504-122708','I061-200504-124440'}; 
% Day1  bmiBlocks = {'I061-200505-131845','I061-200505-144749'}; tStart = 6,1; tStop  = 119,62;
% Day2  bmiBlocks = {'I061-200506-110632','I061-200506-142306'}; tStart = 6,1; tStop  = 221,198;
% Day3  bmiBlocks = {'I061-200507-111109','I061-200507-131918'}; tStart = 51,1; tStop  = 138,102;
% Day4  bmiBlocks = {'I061-200508-120338','I061-200508-142120'}; tStart = 11,1; tStop  = 181,170;
% Day5  bmiBlocks = {'I061-200509-122650','I061-200509-150451'}; tStart = 8,1; tStop  = 183,58;
%% Get trajectories of the pipe (EXAMPLE)
clear; clc; close all;
disp('running');
rootpath = 'Z:\Aamir\BMI\';
bmiBlocks =  { 'I060\Data\I060-200310-112339'...
              ,'I060\Data\I060-200312-111249'...
              ,'I060\Data\I060-200313-113905'...
              ,'I060\Data\I060-200314-131648'...
              ,'I050\Data\I050-191218-112504'...
              ,'I050\Data\I050-191220-104050'...
              ,'I050\Data\I050-191221-121617'...
              ,'I061\Data\I061-200506-110632'...
              ,'I061\Data\I061-200508-120338'...
              ,'I061\Data\I061-200509-122650'};

before_zero = 4;
after_zero = 15;

% List of Tp and Tn
Tp_chs = [23,24,27,27,27-16,25-16,18-16,6,13,6];
Tn_chs = [22,22, 5,12,NaN, NaN, NaN,27,8,27];

% Valid trial markers
tStart = [32,11,74,15,42,17,1,6,11,8];
tStop  = [230,126,148,122,97,84,95,221,181,183];

for i=length(bmiBlocks)
  
  disp(bmiBlocks{i});
 
  % Read Timestamps file 
  matFiles = {'Timestamps_B1.mat', 'WAV_Turncated.mat'};
  for k=1:length(matFiles)
    if isfile([rootpath, bmiBlocks{i},'\',matFiles{k}])
      load([rootpath, bmiBlocks{i},'\',matFiles{k}]);
    else
      load([rootpath, bmiBlocks{i},'\','Timestamps.mat']);
    end
    
  end
  
  % Reassign variable names 
  TimeStamps = TimeStamps1_B1;

  % Get PSTH
  [performance, all_trials, rtrials_onset,~] = fn_getPerformanceTimestamps(WAVE,Fs);
  [psth_tp, psth_tn] = fn_getPSTHforPipeTrajectory(TimeStamps,all_trials,Fs,Tp_chs(i),Tn_chs(i),...
                                                   tStart(i),tStop(i),before_zero,after_zero);
  
  % Get valid performance
  valid_perf = performance(tStart(i):tStop(i));
  
  % Plot trajectory
  figure;
  if ~isempty(psth_tn)
    subplot(1,1,1);plot(mean(psth_tp(valid_perf>=15,:))-mean(psth_tn(valid_perf>=15,:))); hold on;
    subplot(1,1,1);plot(mean(psth_tp(valid_perf<=5,:))-mean(psth_tn(valid_perf<=5,:)));
    xlim([2000,6000]); vline(4000,'k-');
  else
    subplot(1,1,1);plot(mean(psth_tp(valid_perf>=15,:))); hold on;
    subplot(1,1,1);plot(mean(psth_tp(valid_perf<=5,:)));
    xlim([2000,6000]); vline(4000,'k-');
  end
end
disp('done');

%% -----------------------------------------
%%%%%%%% EXAMPLE Tp NEURON %%%%%%%%%%%%%%%%
%% Generate example PSTHs of direct Tp unit
clear;clc;close all;
disp('running');
rootpath = 'Z:\Aamir\BMI\I060\Data\';
bmiBlocks =  {'I060-200314-131648'};
load([rootpath, bmiBlocks{1},'\','Events_Performance_PSTH.mat'],'PSTH1*');

% Example Tp unit
Tp_ch = 27; Tp_sc = 5;
psth = PSTH1_B1{Tp_ch,Tp_sc};
psth_early = psth(20:2:50,:);
psth_late1 = psth(55:1:end,:);

%Plot Tp example
figure('Color','white');

x = 1:size(psth_early,2);
win_smooth = 501;

subplot(1,2,1);hold on;
y = mean(psth_early);
z = std(psth_early)/sqrt(size(psth_early,1)-1);
y = smooth(y,win_smooth+2000,'sgolay')';
z = smooth(z,win_smooth+2000,'sgolay')';
patch([x fliplr(x)], [y+z fliplr(y-z)], 'k');
plot(x,y,'g','LineWidth',2);
xlim([2000 8000]); ylim([0,60]);
vline(4000,'k');

subplot(1,2,2); hold on;
y = mean(psth_late1);
z = std(psth_late1)/sqrt(size(psth_late1,1)-1);
y = smooth(y,win_smooth,'sgolay')';
z = smooth(z,win_smooth,'sgolay')';
patch([x fliplr(x)], [y+z fliplr(y-z)], 'k');
plot(x,y,'g','LineWidth',2);
xlim([2000 8000]); ylim([0,60]);
vline(4000,'k');
disp('done');

%% Generate rasters for example Tp unit
clear;clc;
disp('running...');
rootpath = 'C:\Users\AbbasiM\Desktop\I060\Data\';
bmiBlocks =  {'I060-200314-131648'};
matFiles = dir([rootpath, bmiBlocks{1},'\','T*.mat']);
load([rootpath, bmiBlocks{1},'\',matFiles(1).name],'TimeStamps1*');
matFiles = dir([rootpath, bmiBlocks{1},'\','E*.mat']);
load([rootpath, bmiBlocks{1},'\',matFiles(1).name],'all*');
matFiles = dir([rootpath, bmiBlocks{1},'\','WAV*.mat']);
load([rootpath, bmiBlocks{1},'\',matFiles(1).name],'Fs');
figure('Color','white');

% Example Tp unit
Tp_ch = 27; Tp_sc = 5;
ts = TimeStamps1_B1{Tp_ch,Tp_sc};
ts = ts(1:end);

% Plot rasters
before_zero = 2; after_zero = 4;
events = all_trials_B1;
h1 = subplot(1,2,1);
h2 = subplot(1,2,2);
for n = 1:length(events)
  time = ((events(n)/Fs)-before_zero):((events(n)/Fs)+after_zero);
  valid_inds = logical((ts>time(1)).*(ts<time(end)));
  raster = ts(valid_inds)-time(1);
  if n>20 && n<50
    set(gcf,'CurrentAxes',h1);
    for r=1:length(raster)
      line([raster(r) raster(r)],[0 0.5]+n,'Color','r');
    end
    vline(before_zero,'k');
  elseif n>60 && n<90
    set(gcf,'CurrentAxes',h2);
    for r=1:length(raster)
      line([raster(r) raster(r)],[0 0.5]+n,'Color','r');
    end
    vline(before_zero,'k');
  end
end
disp('done');

%% Generate waveform plot and ISI distribution for the exaple Tp unit
clear;clc;close all;
disp('running...');
rootpath = 'C:\Users\AbbasiM\Desktop\I060\Data\';
bmiBlocks =  {'I060-200314-131648'};
load([rootpath, bmiBlocks{1},'\','Timestamps_B1.mat'],'TimeStamps1*');
load([rootpath, bmiBlocks{1},'\','Waves_B1.mat'],'Waves1*');

% Example Tp unit
Tp_ch = 27; Tp_sc = 5;
ts = TimeStamps1_B1{Tp_ch,Tp_sc};
wf = Waves1_B1{Tp_ch,Tp_sc};

% Figure
figure('Color','white');

% Plot waveforms
subplot(1,2,1); hold on;
plot(wf(:,1:2:1000),'Color',[0.7 0.7 0.7]);
plot(mean(wf(:,1:2:1000),2),'k','LineWidth',1.5);

% Get ISI distribution
for i=1:length(ts)-1
  ISI(i) = ts(i+1)-ts(i);
end

% Plot ISI distribution
subplot(1,2,2);
histogram(ISI(ISI<=0.1),100);
xlim([0,0.1]);

%%%%%%%% EXAMPLE Tn NEURON %%%%%%%%%%%%%%%%
%% Generate example PSTHs of direct Tn unit
clear;clc;close all;
disp('running');
rootpath = 'Z:\Aamir\BMI\I060\Data\';
bmiBlocks =  {'I060-200312-111249'};
matFiles = dir([rootpath, bmiBlocks{1},'\','E*.mat']);
load([rootpath, bmiBlocks{1},'\',matFiles(1).name],'PSTH1*');

% Example Tn unit
Tn_ch = 22; Tn_sc = 4;
psth = PSTH1_B1{Tn_ch,Tn_sc};
psth_early = psth(1:2:40,:);
psth_late1 = psth(61:110,:);

% Plot Tn example
figure('Color','white');

x = 1:size(psth_early,2);
win_smooth = 501;

subplot(1,2,1);hold on
y = mean(psth_early);
z = std(psth_early)/sqrt(size(psth_early,1)-1);
y = smooth(y,win_smooth+2000,'sgolay')';
z = smooth(z,win_smooth+2000,'sgolay')';
patch([x fliplr(x)], [y+z fliplr(y-z)], 'k');
plot(x,y,'g','LineWidth',2);
xlim([2000 8000]); ylim([0,30]);
vline(4000,'k');

subplot(1,2,2); hold on;
y = mean(psth_late1);
z = std(psth_late1)/sqrt(size(psth_late1,1)-1);
y = smooth(y,win_smooth,'sgolay')';
z = smooth(z,win_smooth,'sgolay')';
patch([x fliplr(x)], [y+z fliplr(y-z)], 'k');
plot(x,y,'g','LineWidth',2);
xlim([2000 8000]); ylim([0,30]);
vline(4000,'k');
disp('done');

%% Generate rasters for example Tn unit
clear;clc;close all;
disp('running');
rootpath = 'C:\Users\AbbasiM\Desktop\I060\Data\';
bmiBlocks =  {'I060-200312-111249'};
matFiles = dir([rootpath, bmiBlocks{1},'\','T*.mat']);
load([rootpath, bmiBlocks{1},'\',matFiles(1).name],'TimeStamps1*');
matFiles = dir([rootpath, bmiBlocks{1},'\','E*.mat']);
load([rootpath, bmiBlocks{1},'\',matFiles(1).name],'all*');
matFiles = dir([rootpath, bmiBlocks{1},'\','WAV*.mat']);
load([rootpath, bmiBlocks{1},'\',matFiles(1).name],'Fs');

figure('Color','white');

% Example Tn unit
Tn_ch = 22; Tn_sc = 4;
ts = TimeStamps1_B1{Tn_ch,Tn_sc};
before_zero = 2; after_zero = 4;
events = all_trials_B1;
h1 = subplot(1,2,1);
h2 = subplot(1,2,2);
for n = 1:length(events)
  time = ((events(n)/Fs)-before_zero):((events(n)/Fs)+after_zero);
  valid_inds = logical((ts>time(1)).*(ts<time(end)));
  raster = ts(valid_inds)-time(1);
  if n>0 && n<30
    set(gcf,'CurrentAxes',h1);
    for r=1:length(raster)
      line([raster(r) raster(r)],[0 0.5]+n,'Color','r');
    end
    vline(before_zero,'k');
  elseif n>62 && n<92
    set(gcf,'CurrentAxes',h2);
    for r=1:length(raster)
      line([raster(r) raster(r)],[0 0.5]+n,'Color','r');
    end
    vline(before_zero,'k');
  end
end

disp('done');

%% Generate waveform plot and ISI distribution for the example Tn unit
clear;clc;close all;
disp('running...');
rootpath = 'C:\Users\AbbasiM\Desktop\I060\Data\';
bmiBlocks =  {'I060-200312-111249'};
load([rootpath, bmiBlocks{1},'\','Timestamps_B1.mat'],'TimeStamps1*');
load([rootpath, bmiBlocks{1},'\','Waves_B1.mat'],'Waves1*');

% Example Tp unit
Tn_ch = 22; Tn_sc = 4;
ts = TimeStamps1_B1{Tn_ch,Tn_sc};
wf = Waves1_B1{Tn_ch,Tn_sc};

% Figure
figure('Color','white');

% Plot waveforms
subplot(1,2,1); hold on;
plot(wf(:,1:2:1000),'Color',[0.7 0.7 0.7]);
plot(mean(wf(:,1:2:1000),2),'k','LineWidth',1.5);

% Get ISI distribution
for i=1:length(ts)-1
  ISI(i) = ts(i+1)-ts(i);
end

% Plot ISI distribution
subplot(1,2,2);
histogram(ISI(ISI<=0.1),100);
xlim([0,0.1]);

%%%%%%%% PSTH LATENCY ANALYSIS %%%%%%%%%%%%%%%%
%%  Average M1 PSTHs for direct neurons, either Tp or Tn
%   around trial start
clear;clc;close all;
disp('running');
rootpath = 'Z:\Aamir\BMI\';
cd(rootpath);
bmiBlocks =  { 'I060\Data\I060-200310-112339'...
              ,'I060\Data\I060-200312-111249'...
              ,'I060\Data\I060-200313-113905'...
              ,'I060\Data\I060-200314-131648'...
              ,'I050\Data\I050-191218-112504'...
              ,'I050\Data\I050-191220-104050'...
              ,'I050\Data\I050-191221-121617'...
              ,'I061\Data\I061-200506-110632'...
              ,'I061\Data\I061-200508-120338'...
              ,'I061\Data\I061-200509-122650'};
            
% List of Tp and Tn
Tp_chs = [23,24,27,27,27-16,25-16,18-16,6,13,6];
Tn_chs = [22,22, 5,12,NaN, NaN, NaN,27,8,27];

% Valid trial markers
tStart = [32,11,74,15,42,17,1,6,11,8];
tStop  = [230,126,148,122,97,84,95,221,181,183];

% bmiBlocks =  { 'I060\Data\I060-200310-112339'...
%               ,'I060\Data\I060-200311-114150'...
%               ,'I060\Data\I060-200312-111249'...
%               ,'I060\Data\I060-200313-113905'...
%               ,'I060\Data\I060-200314-131648'...
%               ,'I050\Data\I050-191218-112504'...
%               ,'I050\Data\I050-191219-105728'...
%               ,'I050\Data\I050-191220-104050'...
%               ,'I050\Data\I050-191221-121617'...
%               ,'I050\Data\I050-191223-133408'...
%               ,'I061\Data\I061-200505-131845'...
%               ,'I061\Data\I061-200506-110632'...
%               ,'I061\Data\I061-200507-111109'...
%               ,'I061\Data\I061-200508-120338'...
%               ,'I061\Data\I061-200509-122650'};

% % List of Tp and Tn
% Tp_chs = [23,12,24,27,27,27-16,32-16,25-16,18-16,31-16,25,6,29,13,6];
% Tn_chs = [22,27,22, 5,12,NaN, NaN, NaN,NaN,NaN,15,27,25,8,27];
% 
% % Valid trial markers
% tStart = [32,21,11,74,15,42,21,17,1,1,6,6,51,11,8];
% tStop  = [230,110,126,148,122,97,80,84,95,97,118,221,138,181,183];

s_psth_M1_tp = [];
f_psth_M1_tp = [];
s_psth_M1_tn = [];
f_psth_M1_tn = [];

for i=1:length(bmiBlocks)
  
  disp(bmiBlocks{i});
  
  % Read psth data
  matFiles = dir([rootpath, bmiBlocks{i},'\','Eve*.mat']);
  for k=1:length(matFiles)
    load([rootpath, bmiBlocks{i},'\',matFiles(k).name],'PSTH*','perf*');
  end
  
  % Get valid performance
  valid_perf = performance_B1(tStart(i):tStop(i));
  
  % M1 PSTH Tp
  for ch = Tp_chs(i)
    for u = 2:size(PSTH1_B1,2)
      psth = PSTH1_B1{ch,u};
      if ~isempty(psth)
        tmp = psth(valid_perf>=15,:);
        s_psth_M1_tp = [s_psth_M1_tp;mean(tmp)];

        tmp = psth(valid_perf<5,:);
        f_psth_M1_tp = [f_psth_M1_tp;mean(tmp)];
      end
    end
  end
  
  % M1 PSTH Tn
  if ~isnan(Tn_chs(i))
    for ch = Tn_chs(i)
      for u = 2:size(PSTH1_B1,2)
        psth = PSTH1_B1{ch,u};
        if ~isempty(psth)
          s_psth_M1_tn = [s_psth_M1_tn;mean(psth(valid_perf>=15,:))];
          f_psth_M1_tn = [f_psth_M1_tn;mean(psth(valid_perf<5,:))];
        end
      end
    end
  end
  
  % save
  %save([rootpath,bmiBlocks{i},'\Modulation_depth.mat'],'mod_depth1_B1','mod_depth2_B1');
end
disp('done!');

%% Plots
close all;

time = 1:4000; % in ms

% Get normalized FR for Tp
m_tmp = mean(s_psth_M1_tp(:,time),2);
std_tmp = std(s_psth_M1_tp(:,time),[],2);
norm_s_psth_M1_tp = bsxfun(@minus,s_psth_M1_tp,m_tmp);
norm_s_psth_M1_tp = bsxfun(@rdivide,norm_s_psth_M1_tp,std_tmp);

m_tmp = mean(f_psth_M1_tp(:,time),2);
std_tmp = std(f_psth_M1_tp(:,time),[],2);
norm_f_psth_M1_tp = bsxfun(@minus,f_psth_M1_tp,m_tmp);
norm_f_psth_M1_tp = bsxfun(@rdivide,norm_f_psth_M1_tp,std_tmp);

% Plot populaton PSTH of Tp
figure; plot(mean(norm_s_psth_M1_tp));
hold on;plot(mean(norm_f_psth_M1_tp));
xlim([2000 8000]);vline(4000,'k');

% Get normalized FR for Tn
m_tmp = mean(s_psth_M1_tn(:,time),2);
std_tmp = std(s_psth_M1_tn(:,time),[],2);
norm_s_psth_M1_tn = bsxfun(@minus,s_psth_M1_tn,m_tmp);
norm_s_psth_M1_tn = bsxfun(@rdivide,norm_s_psth_M1_tn,std_tmp);

m_tmp = mean(f_psth_M1_tn(:,time),2);
std_tmp = std(f_psth_M1_tn(:,time),[],2);
norm_f_psth_M1_tn = bsxfun(@minus,f_psth_M1_tn,m_tmp);
norm_f_psth_M1_tn = bsxfun(@rdivide,norm_f_psth_M1_tn,std_tmp);

% Plot populaton PSTH of Tn
figure; plot(mean(norm_s_psth_M1_tn));
hold on;plot(mean(norm_f_psth_M1_tn));
xlim([2000 8000]);vline(4000,'k');

% % Plot individual neuron slow
% figure; plot(s_psth_M1_tp');xlim([2000 8000]);vline(4000,'k');
% figure; plot(s_psth_M1_tn');xlim([2000 8000]);vline(4000,'k');
% 
% % Plot individual neuron fast
% figure; plot(f_psth_M1_tp');xlim([2000 8000]);vline(4000,'k');
% figure; plot(f_psth_M1_tn');xlim([2000 8000]);vline(4000,'k');
% 
% % Population pipe trajectory
% figure; plot(mean(s_psth_M1_tp)-mean(s_psth_M1_tn));
% hold on;plot(mean(f_psth_M1_tp)-mean(f_psth_M1_tn)); 
% xlim([2000 8000]);vline(4000,'k');

%%%%%%%% PSTH MODULATION DEPTH ANALYSIS %%%%%%%%%%%%%%%%
%%  Classification of direct/indirect and unrelated units
%  Directs in M1 are user defined during the experiment
%  Calculate and save modulation depth
clear;clc;close all;
disp('running');
rootpath = 'Z:\Aamir\BMI\';
bmiBlocks =  { 'I060\Data\I060-200310-112339'...
              ,'I060\Data\I060-200311-114150'...
              ,'I060\Data\I060-200312-111249'...
              ,'I060\Data\I060-200313-113905'...
              ,'I060\Data\I060-200314-131648'...
              ,'I050\Data\I050-191218-112504'...
              ,'I050\Data\I050-191219-105728'...
              ,'I050\Data\I050-191220-104050'...
              ,'I050\Data\I050-191221-121617'...
              ,'I050\Data\I050-191223-133408'...
              ,'I061\Data\I061-200505-131845'...
              ,'I061\Data\I061-200506-110632'...
              ,'I061\Data\I061-200507-111109'...
              ,'I061\Data\I061-200508-120338'...
              ,'I061\Data\I061-200509-122650'};

% List of Tp and Tn
Tp_chs = [23,12,24,27,27,27-16,32-16,25-16,18-16,31-16,25,6,29,13,6];
Tn_chs = [22,27,22, 5,12,NaN, NaN, NaN,NaN,NaN,15,27,25,8,27];

for i=11:length(bmiBlocks)
  
  disp(bmiBlocks{i});
  
  % Read psth data
  matFiles = dir([rootpath, bmiBlocks{i},'\','E*.mat']);
  for k=1:length(matFiles)
    load([rootpath, bmiBlocks{i},'\',matFiles(k).name],'PSTH*');
  end
  
  % Get Tp and Tn channels for a current block
  tp = Tp_chs(i);
  tn = Tp_chs(i);
  
  % M1 PSTH modulation depth
  mod_depth1_B1 = cell(size(PSTH1_B1,1),size(PSTH1_B1,2));
  for ch = 1:size(PSTH1_B1,1)
    for u = 1:size(PSTH1_B1,2)
      psth = PSTH1_B1{ch,u};
      if ~isempty(psth)
        psth_late = psth(round(size(psth,1)/2):size(psth,1),:);
        mean_psth_late = mean(psth_late);
        baseline_mean_psth_late = mean(mean_psth_late(1000:3000));
        baseline_std_psth_late  = std(mean_psth_late(1000:3000));
        peak_mean_psth_late_mx = max(mean_psth_late(4001:6000));
        peak_mean_psth_late_mn = min(mean_psth_late(4001:6000));
        perct_mod = round((peak_mean_psth_late_mx-baseline_mean_psth_late)/baseline_mean_psth_late*100);
        mod_depth1_B1{ch,u} = [baseline_mean_psth_late, baseline_std_psth_late, peak_mean_psth_late_mx];
        if ch==tp || ch==tn
          mod_depth1_B1{ch,u} = [mod_depth1_B1{ch,u} abs(perct_mod) 2]; % direct units
        else
          if peak_mean_psth_late_mx > (baseline_mean_psth_late+2.5*baseline_std_psth_late)
            mod_depth1_B1{ch,u} = [mod_depth1_B1{ch,u} perct_mod 1]; % indirect units
          elseif peak_mean_psth_late_mn < (baseline_mean_psth_late-2.5*baseline_std_psth_late)
            mod_depth1_B1{ch,u} = [mod_depth1_B1{ch,u} abs(perct_mod) 1]; % indirect units
          else
            mod_depth1_B1{ch,u} = [mod_depth1_B1{ch,u} perct_mod 0]; % unrelated units
          end
        end
      end
    end
  end
  
  % Cb PSTH modulation depth
  mod_depth2_B1 = cell(size(PSTH2_B1,1),size(PSTH2_B1,2));
  for ch = 1:size(PSTH2_B1,1)
    for u = 2:size(PSTH2_B1,2)
      psth = PSTH2_B1{ch,u};
      if ~isempty(psth)
        psth_late = psth(round(size(psth,1)/2):size(psth,1),:);
        mean_psth_late = mean(psth_late);
        baseline_mean_psth_late = mean(mean_psth_late(1000:3000));
        baseline_std_psth_late  = std(mean_psth_late(1000:3000));
        peak_mean_psth_late_mx = max(mean_psth_late(4001:6000));
        peak_mean_psth_late_mn = min(mean_psth_late(4001:6000));
        perct_mod = round((peak_mean_psth_late_mx-baseline_mean_psth_late)/baseline_mean_psth_late*100);
        mod_depth2_B1{ch,u} = [baseline_mean_psth_late, baseline_std_psth_late, peak_mean_psth_late_mx];
        if peak_mean_psth_late_mx > (baseline_mean_psth_late+2.5*baseline_std_psth_late)
          mod_depth2_B1{ch,u} = [mod_depth2_B1{ch,u} perct_mod 1]; % indirect units
        elseif peak_mean_psth_late_mn < (baseline_mean_psth_late-2.5*baseline_std_psth_late)
          mod_depth2_B1{ch,u} = [mod_depth2_B1{ch,u} abs(perct_mod) 1]; % indirect units
        else
          mod_depth2_B1{ch,u} = [mod_depth2_B1{ch,u} perct_mod 0]; % unrelated units
        end
      end
    end
  end
  
  % save
  save([rootpath,bmiBlocks{i},'\Modulation_depth.mat'],'mod_depth1_B1','mod_depth2_B1');
end
disp('done!');

%% Generate modulation depth figures
%  Percentage of direct/indirect and unrelated units
%  Distribution of percentage change of modulation depth
clear;clc;close all;
disp('running');
rootpath = 'Z:\Aamir\BMI\';
bmiBlocks =  { 'I060\Data\I060-200310-112339'...
              ,'I060\Data\I060-200312-111249'...
              ,'I060\Data\I060-200313-113905'...
              ,'I060\Data\I060-200314-131648'...
              ,'I050\Data\I050-191218-112504'...
              ,'I050\Data\I050-191220-104050'...
              ,'I050\Data\I050-191221-121617'...
              ,'I061\Data\I061-200506-110632'...
              ,'I061\Data\I061-200508-120338'...
              ,'I061\Data\I061-200509-122650'};
% bmiBlocks =  { 'I060\Data\I060-200310-112339'...
%               ,'I060\Data\I060-200311-114150'...
%               ,'I060\Data\I060-200312-111249'...
%               ,'I060\Data\I060-200313-113905'...
%               ,'I060\Data\I060-200314-131648'...
%               ,'I050\Data\I050-191218-112504'...
%               ,'I050\Data\I050-191219-105728'...
%               ,'I050\Data\I050-191220-104050'...
%               ,'I050\Data\I050-191221-121617'...
%               ,'I050\Data\I050-191223-133408'...
%               ,'I061\Data\I061-200505-131845'...
%               ,'I061\Data\I061-200506-110632'...
%               ,'I061\Data\I061-200507-111109'...
%               ,'I061\Data\I061-200508-120338'...
%               ,'I061\Data\I061-200509-122650'};

md_stats_M1 = [];
md_stats_Cb = [];
for i=1:length(bmiBlocks)
  
  disp(bmiBlocks{i});
  
  % Read modulation depth data
  matFiles = dir([rootpath, bmiBlocks{i},'\','Mod*.mat']);
  for k=1:length(matFiles)
    load([rootpath, bmiBlocks{i},'\',matFiles(k).name],'mod*');
  end
  
  % M1 PSTH modulation depth
  for ch = 1:size(mod_depth1_B1,1)
    for u = 1:size(mod_depth1_B1,2)
      md = mod_depth1_B1{ch,u};
      if ~isempty(md)
        md_stats_M1 = [md_stats_M1;md(end-1:end)];
      end
    end
  end
  
  % Cb PSTH modulation depth
  for ch = 1:size(mod_depth2_B1,1)
    for u = 1:size(mod_depth2_B1,2)
      md = mod_depth2_B1{ch,u};
      if ~isempty(md)
        md_stats_Cb = [md_stats_Cb;md(end-1:end)];
      end
    end
  end
end

% get classification of M1 units
direct = length(md_stats_M1(md_stats_M1(:,2)==2));
indirect = length(md_stats_M1(md_stats_M1(:,2)==1));
unrelated = length(md_stats_M1(md_stats_M1(:,2)==0));

% plot classification of M1 units as percentage
figure('Color','white');
p = pie([direct indirect unrelated]);
pText = findobj(p,'Type','text');
percentValues = get(pText,'String');
txt = {'tr_d- ','tr_i- ','t_u- '};
combinedtxt = strcat(txt,percentValues');
pText(1).String = combinedtxt(1);
pText(2).String = combinedtxt(2);
pText(3).String = combinedtxt(3);

% get percentage of modulation
direct    = md_stats_M1(md_stats_M1(:,2)==2);
indirect  = md_stats_M1(md_stats_M1(:,2)==1);
unrelated = md_stats_M1(md_stats_M1(:,2)==0);

% plot distribution of percentage change in modulation
figure('Color','white');
subplot(3,1,1);hist(direct,30); xlim([-100,400]);
subplot(3,1,2);hist(indirect,100);xlim([-100,400]);
subplot(3,1,3);hist(unrelated,20);xlim([-100,400]);

% get classification of Cb units
indirect = length(md_stats_Cb(md_stats_Cb(:,2)==1))/length(md_stats_Cb);
unrelated = length(md_stats_Cb(md_stats_Cb(:,2)==0))/length(md_stats_Cb);

% plot classification of Cb units as percentage
figure('Color','white');
p = pie([indirect unrelated]);
pText = findobj(p,'Type','text');
percentValues = get(pText,'String');
txt = {'tr_i- ','t_u- '};
combinedtxt = strcat(txt,percentValues');
pText(1).String = combinedtxt(1);
pText(2).String = combinedtxt(2);

% get percentage of modulation
indirect  = md_stats_Cb(md_stats_Cb(:,2)==1);
unrelated = md_stats_Cb(md_stats_Cb(:,2)==0);

% plot distribution of percentage change in modulation
figure('Color','white');
subplot(2,1,1);hist(indirect,20); xlim([-100,400]);
subplot(2,1,2);hist(unrelated,10);xlim([-100,400]);

%% Population PSTH of indirect and unrelated units in M1
clear;clc;close all;
disp('running');
rootpath = 'Z:\Aamir\BMI\';
bmiBlocks =  { 'I060\Data\I060-200310-112339'...
              ,'I060\Data\I060-200312-111249'...
              ,'I060\Data\I060-200313-113905'...
              ,'I060\Data\I060-200314-131648'...
              ,'I050\Data\I050-191218-112504'...
              ,'I050\Data\I050-191220-104050'...
              ,'I050\Data\I050-191221-121617'...
              ,'I061\Data\I061-200506-110632'...
              ,'I061\Data\I061-200508-120338'...
              ,'I061\Data\I061-200509-122650'};
% bmiBlocks =  { 'I060\Data\I060-200310-112339'...
%               ,'I060\Data\I060-200311-114150'...
%               ,'I060\Data\I060-200312-111249'...
%               ,'I060\Data\I060-200313-113905'...
%               ,'I060\Data\I060-200314-131648'...
%               ,'I050\Data\I050-191218-112504'...
%               ,'I050\Data\I050-191219-105728'...
%               ,'I050\Data\I050-191220-104050'...
%               ,'I050\Data\I050-191221-121617'...
%               ,'I050\Data\I050-191223-133408'...
%               ,'I061\Data\I061-200505-131845'...
%               ,'I061\Data\I061-200506-110632'...
%               ,'I061\Data\I061-200507-111109'...
%               ,'I061\Data\I061-200508-120338'...
%               ,'I061\Data\I061-200509-122650'};
            
% Valid trial markers
% tStart = [32,21,11,74,15,42,21,17,1,1,6,6,51,11,8];
% tStop  = [230,110,126,148,122,97,80,84,95,97,118,221,138,181,183];

% Valid trial markers
tStart = [32,11,74,15,42,17,1,6,11,8];
tStop  = [230,126,148,122,97,84,95,221,181,183];

% Initialization
s_psth_M1_ti = [];
f_psth_M1_ti = [];

md_stats_M1 = [];
md_stats_Cb = [];

for i=1:length(bmiBlocks)
  
  disp(bmiBlocks{i});
  
  % Read modulation depth data
  matFiles = dir([rootpath, bmiBlocks{i},'\','Mod*.mat']);
  for k=1:length(matFiles)
    load([rootpath, bmiBlocks{i},'\',matFiles(k).name],'mod*');
  end
  
  % Read psth data
  matFiles = dir([rootpath, bmiBlocks{i},'\','E*.mat']);
  for k=1:length(matFiles)
    load([rootpath, bmiBlocks{i},'\',matFiles(k).name],'PSTH*','perf*');
  end
  
  % Rearrange psth and md cell array
  PSTH = PSTH1_B1(:);
  PSTH = PSTH(~cellfun('isempty',PSTH));
  
  MD = mod_depth1_B1(:);
  MD = MD(~cellfun('isempty',MD));
  
  % Get valid performance
  valid_perf = performance_B1(tStart(i):tStop(i));
  
  % M1 PSTH modulation depth
  for ch = 1:size(mod_depth1_B1,1)
    for u = 1:size(mod_depth1_B1,2)
      md = mod_depth1_B1{ch,u};
      psth = PSTH1_B1{ch,u};
      if ~isempty(md)
        md_stats_M1 = [md_stats_M1;md(end)];
      end
      if ~isempty(psth)
        tmp = psth(valid_perf>=15,:);
        s_psth_M1_ti = [s_psth_M1_ti;mean(tmp)];
        
        tmp = psth(valid_perf<5,:);
        f_psth_M1_ti = [f_psth_M1_ti;mean(tmp)];
      end
    end
  end
end
disp('done!');

%% Plot indirect and unrelated cells
close all;
s_indirects = s_psth_M1_ti(md_stats_M1==1,:);
f_indirects = f_psth_M1_ti(md_stats_M1==1,:);

% Plot populaton PSTH of indirects
figure; plot(mean(s_indirects));
hold on;plot(mean(f_indirects));
xlim([2000 8000]);vline(4000,'k');

% Plot individual neuron slow
% figure; plot(s_indirects');xlim([2000 8000]);vline(4000,'k');
% figure; plot(f_indirects');xlim([2000 8000]);vline(4000,'k');

s_unrelated = s_psth_M1_ti(md_stats_M1==0,:);
f_unrelated = f_psth_M1_ti(md_stats_M1==0,:);

% Plot populaton PSTH of unrelated
figure; plot(mean(s_unrelated));
hold on;plot(mean(f_unrelated));
xlim([2000 8000]);vline(4000,'k');

%%%%%%%% EXAMPLE OF A MODULATED CEREBELLUM UNIT %%%%%%%%%%%%%%%%
%% Generate example PSTHs for example Cb indirect unit
clear;clc;close all;
disp('running');
rootpath = 'C:\Users\AbbasiM\Desktop\I060\Data\';
bmiBlocks =  {'I060-200312-111249'};
matFiles = dir([rootpath, bmiBlocks{1},'\','E*.mat']);
load([rootpath, bmiBlocks{1},'\',matFiles(1).name],'PSTH2*');

% Example Tp unit
Tp_ch = 1; Tp_sc = 2;
psth = PSTH2_B1{Tp_ch,Tp_sc};
psth = psth(1:110,:);

% Plot Tp example
figure('Color','white');

x = 1:size(psth,2);
win_smooth = 801;

subplot(1,2,1);hold on
y = mean(psth);
z = std(psth)/sqrt(size(psth,1)-1);
y = smooth(y,win_smooth,'rloess')';
z = smooth(z,win_smooth,'rloess')';
patch([x fliplr(x)], [y+z fliplr(y-z)], 'k');
plot(x,y,'g','LineWidth',2);
xlim([2000 8000]); ylim([0,4]);
vline(4000,'k');

%% Generate rasters for example Cb indirect unit
clear;clc;close all;
disp('running');
rootpath = 'C:\Users\AbbasiM\Desktop\I060\Data\';
bmiBlocks =  {'I060-200312-111249'};
matFiles = dir([rootpath, bmiBlocks{1},'\','T*.mat']);
load([rootpath, bmiBlocks{1},'\',matFiles(1).name],'TimeStamps2*');
matFiles = dir([rootpath, bmiBlocks{1},'\','E*.mat']);
load([rootpath, bmiBlocks{1},'\',matFiles(1).name],'all*');
matFiles = dir([rootpath, bmiBlocks{1},'\','WAV*.mat']);
load([rootpath, bmiBlocks{1},'\',matFiles(1).name],'Fs');
figure('Color','white');

% Example Tp unit
Tp_ch = 1; Tp_sc = 2;
ts = TimeStamps2_B1{Tp_ch,Tp_sc};
before_zero = 2; after_zero = 4;
events = all_trials_B1;
h1 = subplot(1,2,1);
h2 = subplot(1,2,2);
for n = 1:length(events)
  time = ((events(n)/Fs)-before_zero):((events(n)/Fs)+after_zero);
  valid_inds = logical((ts>time(1)).*(ts<time(end)));
  raster = ts(valid_inds)-time(1);
  if n>10 && n<50
    set(gcf,'CurrentAxes',h1);
    for r=1:length(raster)
      line([raster(r) raster(r)],[0 0.5]+n,'Color','r');
    end
    vline(before_zero,'k');
  end
end
disp('done');

%% Generate waveform plot and ISI distribution for the example Cerebellar indirect unit
clear;clc;close all;
disp('running...');
rootpath = 'C:\Users\AbbasiM\Desktop\I060\Data\';
bmiBlocks =  {'I060-200312-111249'};
load([rootpath, bmiBlocks{1},'\','Timestamps_B1.mat'],'TimeStamps2*');
load([rootpath, bmiBlocks{1},'\','Waves_B1.mat'],'Waves2*');

% Example Tp unit
Tn_ch = 1; Tn_sc = 2;
m_wf = ([mean(Waves2_B1{Tn_ch,Tn_sc},2) mean(Waves2_B1{Tn_ch+1,Tn_sc},2) ...
  mean(Waves2_B1{Tn_ch+2,Tn_sc},2) mean(Waves2_B1{Tn_ch+3,Tn_sc},2)])';

sem_wf = ([std(Waves2_B1{Tn_ch,Tn_sc},[],2)...
  std(Waves2_B1{Tn_ch+1,Tn_sc},[],2)...
  std(Waves2_B1{Tn_ch+2,Tn_sc},[],2)...
  std(Waves2_B1{Tn_ch+3,Tn_sc},[],2)])';

% Figure
figure('Color','white');

% Plot waveforms
x = (1:length(m_wf));
for i=1:size(m_wf,1)
  subplot(1,4,i); hold on;
  patch([x fliplr(x)], [m_wf(i,:)+sem_wf(i,:) fliplr(m_wf(i,:)-sem_wf(i,:))],'k');
  plot(x,m_wf(i,:),'r','LineWidth',2);
end

% Get ISI distribution
ts = TimeStamps2_B1{Tn_ch+1,Tn_sc};
for i=1:length(ts)-1
  ISI(i) = ts(i+1)-ts(i);
end

% Plot ISI distribution
subplot(1,2,2);
hist(ISI(ISI<=0.1),100,'EdgeAlpha','none','FaceColor','k');
xlim([0,0.1]);

disp('done!')
%%%%%%%%%%%%%%%%%% LFP ANALYSIS STARTS HERE %%%%%%%%%%%%%%%%%%%%%
%% Get collated lfp signals after rejecting bad trials and channels
clear;clc;close all;
disp('running...');
rootpath = 'Z:\Aamir\BMI\';
bmiBlocks = {'I050\Data\I050-191218-112504'...
            ,'I050\Data\I050-191219-105728'...
            ,'I050\Data\I050-191220-104050'...
            ,'I050\Data\I050-191221-121617'...
            ,'I050\Data\I050-191223-133408'...
            ,'I060\Data\I060-200310-112339'...
            ,'I060\Data\I060-200311-114150'...
            ,'I060\Data\I060-200312-111249'...
            ,'I060\Data\I060-200313-113905'...
            ,'I060\Data\I060-200314-131648'...
            ,'I061\Data\I061-200505-131845'...
            ,'I061\Data\I061-200506-110632'...
            ,'I061\Data\I061-200507-111109'...
            ,'I061\Data\I061-200508-120338'...
            ,'I061\Data\I061-200509-122650'};

% Valid trial markers
tStart = [42,21,17,1,1,32,21,11,74,15,6,6,51,11,8];
tStop  = [97,80,84,95,97,230,110,126,148,122,118,221,138,181,183];

for i=11:length(bmiBlocks)
  
  disp(bmiBlocks{i});
  
  % Read LFP signals, trial markers and performance
  matFiles = dir([rootpath, bmiBlocks{i},'\','LFP*Turncated.mat']);
  for k=1:length(matFiles)
    load([rootpath, bmiBlocks{i},'\',matFiles(k).name]);
  end
  load([rootpath, bmiBlocks{i},'\','Events_Performance_PSTH.mat'],'all_trial*','rtrials_onse*','performanc*');
  
  % Reassign common variable names 
  if exist('all_trials_B1','var') == 1
    all_trials = all_trials_B1;
  elseif exist('all_trials_B2','var') == 1
    all_trials = all_trials_B2;
  end
  
  if exist('all_trials_B1','var') == 1
    rtrials_onset = rtrials_onset_B1;
  elseif exist('all_trials_B2','var') == 1
    rtrials_onset = rtrials_onset_B2;
  end
  
  if exist('all_trials_B1','var') == 1
    performance = performance_B1;
  elseif exist('all_trials_B2','var') == 1
    performance = performance_B2;
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FOR M1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Check for bad LFP channel(s) by visual inspection
  badchans1 = fn_checkLFPChans(LFPs1,1:size(LFPs1,2));
  
  % Get valid trials
  valid_trials      = all_trials(tStart(i):tStop(i));
  valid_rtrials     = rtrials_onset(tStart(i):tStop(i));
  valid_performance = performance(tStart(i):tStop(i));
  
  % Collate LFP signals around trial start
  trial_data1 = fn_collateTrialData(LFPs1,valid_trials,round(4*Fs),round(4*Fs));
  
  % Remove bad channels
  trial_data1(badchans1,:,:) = [];
  
  % Check for bad trials after removing bad channel(s)
  badtrials = fn_visualizeTrialData(trial_data1,[]);
  
  % Remove bad trials
  trial_data1(:,:,badtrials)= [];
  valid_performance(badtrials)=[];
  valid_rtrials(badtrials)=[];
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FOR CEREBELLUM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Check for bad LFP channel(s) by visual inspection
  badchans2 = fn_checkLFPChans(LFPs2,1:size(LFPs2,2));
  
  % Collate LFP signals around trial start
  trial_data2 = fn_collateTrialData(LFPs2,valid_trials,round(4*Fs),round(4*Fs));
  
  % Remove bad channels
  trial_data2(badchans2,:,:) = [];
  
  % Remove bad trials
  trial_data2(:,:,badtrials)= [];
  
  % Save collated lfps
  save([rootpath, bmiBlocks{i},'\','Collated_LFP.mat'],...
      'trial_data1','trial_data2','valid_performance',...
      'valid_rtrials','Fs','badtrials','badchans1','badchans2');
  
end
disp('done');

%% Get Event-Related Spectral Perturbation (ERSP)
clear;clc;close all;
disp('running...');
rootpath = 'Z:\Aamir\BMI\';
bmiBlocks = {'I050\Data\I050-191218-112504'...
            ,'I050\Data\I050-191219-105728'...
            ,'I050\Data\I050-191220-104050'...
            ,'I050\Data\I050-191221-121617'...
            ,'I050\Data\I050-191223-133408'...
            ,'I060\Data\I060-200310-112339'...
            ,'I060\Data\I060-200311-114150'...
            ,'I060\Data\I060-200312-111249'...
            ,'I060\Data\I060-200313-113905'...
            ,'I060\Data\I060-200314-131648'...
            ,'I061\Data\I061-200505-131845'...
            ,'I061\Data\I061-200506-110632'...
            ,'I061\Data\I061-200507-111109'...
            ,'I061\Data\I061-200508-120338'...
            ,'I061\Data\I061-200509-122650'};

for i=1:length(bmiBlocks)
  
  disp(bmiBlocks{i});
  
  % Read collated LFP matrix
  load([rootpath, bmiBlocks{i},'\','Collated_LFP.mat']);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FOR M1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Clear variables common with M1
  clear trial_data_n ersp_data trial_data1_erp 
  
  % Z-scoring
  for j=1:size(trial_data1,1)
    tmp = reshape(squeeze(trial_data1(j,:,:)),1,[]);
    trial_data_n(j,:,:) = (trial_data1(j,:,:)-mean(tmp))./std(tmp);
  end
  
  % Median subtraction
  med = median(trial_data_n,1);
  trial_data1_cmr = bsxfun(@minus,trial_data_n,med);
  
  % Get Event=Related Spectral Perturbation (ERSP) using eeglab for M1 without ERP subtraction
  for j=1:size(trial_data1_cmr,1)
    disp(['Ch_',num2str(j)]);
    data = squeeze(trial_data1_cmr(j,1:8000,:));
    [~,~,~,times,freqs,~,~,ersp_data(j,:,:,:)] = newtimef(data,8000,[-4000 4000],Fs,[0.01 0.1],...
      'baseline',NaN,'freqs', [0 60],'verbose','off','trialbase','on');
    clf;
  end
  
  % Get normalized ESRP data generated before subtracting ERP
  data     = ersp_data.*conj(ersp_data);
  bl       = mean(data(:,:,times>-1500&times<-500,:),3);
  bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
  datanorm = bsxfun(@minus,data,bl);
  ersp_datanorm1_cmr = bsxfun(@rdivide,datanorm,bl_std);
  
  % ERP subtraction (Channel by Channel)
  for ch=1:size(trial_data1_cmr,1)
    single_channel_data = squeeze(trial_data1_cmr(ch,:,:));
    mean_erp = mean(single_channel_data,2);
    trial_data1_erp(ch,:,:) = bsxfun(@minus,single_channel_data,mean_erp);
  end
  
  % Get Event=Related Spectral Perturbation (ERSP) using eeglab for M1 with ERP subtraction
  for j=1:size(trial_data1_erp,1)
    disp(['Ch_',num2str(j)]);
    data = squeeze(trial_data1_erp(j,1:8000,:));
    [~,~,~,times,freqs,~,~,ersp_data(j,:,:,:)] = newtimef(data,8000,[-4000 4000],Fs,[0.01 0.1],...
      'baseline',NaN,'freqs', [0 60],'verbose','off','trialbase','on');
    clf;
  end
  
  % Get normalized ESRP data generated after subtracting ERP
  data = ersp_data.*conj(ersp_data);
  bl       = mean(data(:,:,times>-1500&times<-500,:),3);
  bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
  datanorm = bsxfun(@minus,data,bl);
  ersp_datanorm1_erp = bsxfun(@rdivide,datanorm,bl_std);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FOR CEREBELLUM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Clear variables common with M1
  clear trial_data_n ersp_data trial_data2_erp
  
  % Z-scoring
  for j=1:size(trial_data2,1)
    tmp = reshape(squeeze(trial_data2(j,:,:)),1,[]);
    trial_data_n(j,:,:) = (trial_data2(j,:,:)-mean(tmp))./std(tmp);
  end
  
  % Median subtraction CMR
  med = median(trial_data_n,1);
  trial_data2_cmr = bsxfun(@minus,trial_data_n,med);
  
  % Get Event=Related Spectral Perturbation (ERSP) using eeglab for Cb without ERP subtraction
  for j=1:size(trial_data2_cmr,1)
    disp(['Ch_',num2str(j)]);
    data = squeeze(trial_data2_cmr(j,1:8000,:));
    [~,~,~,times,freqs,~,~,ersp_data(j,:,:,:)] = newtimef(data,8000,[-4000 4000],Fs,[0.01 0.1],...
      'baseline',NaN,'freqs', [0 60],'verbose','off','trialbase','on');
    clf;
  end
  
  % Get normalized ESRP data generated before subtracting ERP
  data = ersp_data.*conj(ersp_data);
  bl=mean(data(:,:,times>-1500&times<-500,:),3);
  bl_std=std(data(:,:,times>-1500&times<-500,:),[],3);
  datanorm=bsxfun(@minus,data,bl);
  ersp_datanorm2_cmr = bsxfun(@rdivide,datanorm,bl_std);
  
  % ERP subtraction (Channel by Channel)
  for ch=1:size(trial_data2_cmr,1)
    single_channel_data = squeeze(trial_data2_cmr(ch,:,:));
    mean_erp = mean(single_channel_data,2);
    trial_data2_erp(ch,:,:) = bsxfun(@minus,single_channel_data,mean_erp);
  end
  
  % Get Event=Related Spectral Perturbation (ERSP) using eeglab for Cb with ERP subtraction
  for j=1:size(trial_data2_erp,1)
    disp(['Ch_',num2str(j)]);
    data = squeeze(trial_data2_erp(j,1:8000,:));
    [~,~,~,times,freqs,~,~,ersp_data(j,:,:,:)] = newtimef(data,8000,[-4000 4000],Fs,[0.01 0.1],...
      'baseline',NaN,'freqs', [0 60],'verbose','off','trialbase','on');
    clf;
  end
  
  % Get normalized ESRP data generated after subtracting ERP
  data = ersp_data.*conj(ersp_data);
  bl=mean(data(:,:,times>-1500&times<-500,:),3);
  bl_std=std(data(:,:,times>-1500&times<-500,:),[],3);
  datanorm=bsxfun(@minus,data,bl);
  ersp_datanorm2_erp = bsxfun(@rdivide,datanorm,bl_std);
  
  % Save
  save([rootpath, bmiBlocks{i},'\','ERSP.mat'],'ersp_datanorm1_cmr','ersp_datanorm1_erp',...
    'ersp_datanorm2_cmr','ersp_datanorm2_erp','times','freqs');  
end
close;
disp('done');

%% Get Inter-Trial Coherence (ITC)
clear;clc;close all;
disp('running...');
rootpath = 'Z:\Aamir\BMI\';
bmiBlocks = {'I050\Data\I050-191218-112504'...
            ,'I050\Data\I050-191219-105728'...
            ,'I050\Data\I050-191220-104050'...
            ,'I050\Data\I050-191221-121617'...
            ,'I050\Data\I050-191223-133408'...
            ,'I060\Data\I060-200310-112339'...
            ,'I060\Data\I060-200311-114150'...
            ,'I060\Data\I060-200312-111249'...
            ,'I060\Data\I060-200313-113905'...
            ,'I060\Data\I060-200314-131648'...
            ,'I061\Data\I061-200505-131845'...
            ,'I061\Data\I061-200506-110632'...
            ,'I061\Data\I061-200507-111109'...
            ,'I061\Data\I061-200508-120338'...
            ,'I061\Data\I061-200509-122650'};

for i=1:length(bmiBlocks)
  
  disp(bmiBlocks{i});
  
  % Read collated LFP matrix
  load([rootpath, bmiBlocks{i},'\','Collated_LFP.mat']);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FOR M1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Clear variables common with M1
  clear trial_data_n ersp_data itc trial_data1_erp 
  
  % Z-scoring
  for j=1:size(trial_data1,1)
    tmp = reshape(squeeze(trial_data1(j,:,:)),1,[]);
    trial_data_n(j,:,:) = (trial_data1(j,:,:)-mean(tmp))./std(tmp);
  end
  
  % Median subtraction
  med = median(trial_data_n,1);
  trial_data1_cmr = bsxfun(@minus,trial_data_n,med);
  
  % Split trials in to slow, intermediate and fast
  u_trial_data1_cmr = trial_data1_cmr(:,:,valid_performance>=15);  
  s_trial_data1_cmr = trial_data1_cmr(:,:,logical((valid_performance<15).*(valid_performance>=10)));
  i_trial_data1_cmr = trial_data1_cmr(:,:,logical((valid_performance<10).*(valid_performance>5)));
  f_trial_data1_cmr = trial_data1_cmr(:,:,valid_performance<=5);

  % Get ITC of unsuccessful trials using eeglab for M1 without ERP subtraction
  for j=1:size(u_trial_data1_cmr,1)
    disp(['Ch_',num2str(j)]);
    data = squeeze(u_trial_data1_cmr(j,1:8000,:));
    [~,itc(j,:,:),~,times,freqs,~,~,~] = newtimef(data,8000,[-4000 4000],Fs,[0.01 0.1],...
      'baseline',NaN,'freqs', [0 60],'verbose','off','trialbase','on');
    clf;
  end
  
  % Get normalized ITC data generated before subtracting ERP
  data     = abs(itc);
  bl       = mean(data(:,:,times>-1500&times<-500,:),3);
  bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
  datanorm = bsxfun(@minus,data,bl);
  u_itc_datanorm1_cmr = bsxfun(@rdivide,datanorm,bl_std);
  clear itc  
  
  % Get ITC of slow trials using eeglab for M1 without ERP subtraction
  for j=1:size(s_trial_data1_cmr,1)
    disp(['Ch_',num2str(j)]);
    data = squeeze(s_trial_data1_cmr(j,1:8000,:));
    [~,itc(j,:,:),~,times,freqs,~,~,~] = newtimef(data,8000,[-4000 4000],Fs,[0.01 0.1],...
      'baseline',NaN,'freqs', [0 60],'verbose','off','trialbase','on');
    clf;
  end
  
  % Get normalized ITC data generated before subtracting ERP
  data     = abs(itc);
  bl       = mean(data(:,:,times>-1500&times<-500,:),3);
  bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
  datanorm = bsxfun(@minus,data,bl);
  s_itc_datanorm1_cmr = bsxfun(@rdivide,datanorm,bl_std);
  clear itc
  
  % Get ITC of intermediate trials using eeglab for M1 without ERP subtraction
  for j=1:size(i_trial_data1_cmr,1)
    disp(['Ch_',num2str(j)]);
    data = squeeze(i_trial_data1_cmr(j,1:8000,:));
    [~,itc(j,:,:),~,times,freqs,~,~,~] = newtimef(data,8000,[-4000 4000],Fs,[0.01 0.1],...
      'baseline',NaN,'freqs', [0 60],'verbose','off','trialbase','on');
    clf;
  end
  
  % Get normalized ITC data generated before subtracting ERP
  data     = abs(itc);
  bl       = mean(data(:,:,times>-1500&times<-500,:),3);
  bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
  datanorm = bsxfun(@minus,data,bl);
  i_itc_datanorm1_cmr = bsxfun(@rdivide,datanorm,bl_std);
  clear itc 
  
  % Get ITC of fast trials using eeglab for M1 without ERP subtraction
  for j=1:size(f_trial_data1_cmr,1)
    disp(['Ch_',num2str(j)]);
    data = squeeze(f_trial_data1_cmr(j,1:8000,:));
    [~,itc(j,:,:),~,times,freqs,~,~,~] = newtimef(data,8000,[-4000 4000],Fs,[0.01 0.1],...
      'baseline',NaN,'freqs', [0 60],'verbose','off','trialbase','on');
    clf;
  end
  
  % Get normalized ITC data generated before subtracting ERP
  data     = abs(itc);
  bl       = mean(data(:,:,times>-1500&times<-500,:),3);
  bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
  datanorm = bsxfun(@minus,data,bl);
  f_itc_datanorm1_cmr = bsxfun(@rdivide,datanorm,bl_std);  
  clear itc
  
  % ERP subtraction (Channel by Channel)
  for ch=1:size(trial_data1_cmr,1)
    single_channel_data = squeeze(trial_data1_cmr(ch,:,:));
    mean_erp = mean(single_channel_data,2);
    trial_data1_erp(ch,:,:) = bsxfun(@minus,single_channel_data,mean_erp);
  end
  
  % Split trials in to slow, intermediate and fast
  u_trial_data1_erp = trial_data1_erp(:,:,valid_performance>=15);
  s_trial_data1_erp = trial_data1_erp(:,:,logical((valid_performance<15).*(valid_performance>=10)));
  i_trial_data1_erp = trial_data1_erp(:,:,logical((valid_performance<10).*(valid_performance>5)));
  f_trial_data1_erp = trial_data1_erp(:,:,valid_performance<=5);

  % Get ITC of unsuccessful trials using eeglab for M1 with ERP subtraction
  for j=1:size(u_trial_data1_erp,1)
    disp(['Ch_',num2str(j)]);
    data = squeeze(u_trial_data1_erp(j,1:8000,:));
    [~,itc(j,:,:),~,times,freqs,~,~,~] = newtimef(data,8000,[-4000 4000],Fs,[0.01 0.1],...
      'baseline',NaN,'freqs', [0 60],'verbose','off','trialbase','on');
    clf;
  end
  
  % Get normalized ITC data generated before subtracting ERP
  data     = abs(itc);
  bl       = mean(data(:,:,times>-1500&times<-500,:),3);
  bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
  datanorm = bsxfun(@minus,data,bl);
  u_itc_datanorm1_erp = bsxfun(@rdivide,datanorm,bl_std);
  clear itc
  
  % Get ITC of slow trials using eeglab for M1 with ERP subtraction
  for j=1:size(s_trial_data1_erp,1)
    disp(['Ch_',num2str(j)]);
    data = squeeze(s_trial_data1_erp(j,1:8000,:));
    [~,itc(j,:,:),~,times,freqs,~,~,~] = newtimef(data,8000,[-4000 4000],Fs,[0.01 0.1],...
      'baseline',NaN,'freqs', [0 60],'verbose','off','trialbase','on');
    clf;
  end
  
  % Get normalized ITC data generated before subtracting ERP
  data     = abs(itc);
  bl       = mean(data(:,:,times>-1500&times<-500,:),3);
  bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
  datanorm = bsxfun(@minus,data,bl);
  s_itc_datanorm1_erp = bsxfun(@rdivide,datanorm,bl_std);
  clear itc
  
  % Get ITC of intermediate trials using eeglab for M1 without ERP subtraction
  for j=1:size(i_trial_data1_erp,1)
    disp(['Ch_',num2str(j)]);
    data = squeeze(i_trial_data1_erp(j,1:8000,:));
    [~,itc(j,:,:),~,times,freqs,~,~,~] = newtimef(data,8000,[-4000 4000],Fs,[0.01 0.1],...
      'baseline',NaN,'freqs', [0 60],'verbose','off','trialbase','on');
    clf;
  end
  
  % Get normalized ITC data generated before subtracting ERP
  data     = abs(itc);
  bl       = mean(data(:,:,times>-1500&times<-500,:),3);
  bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
  datanorm = bsxfun(@minus,data,bl);
  i_itc_datanorm1_erp = bsxfun(@rdivide,datanorm,bl_std);
  clear itc 
  
  % Get ITC of fast trials using eeglab for M1 without ERP subtraction
  for j=1:size(f_trial_data1_erp,1)
    disp(['Ch_',num2str(j)]);
    data = squeeze(f_trial_data1_erp(j,1:8000,:));
    [~,itc(j,:,:),~,times,freqs,~,~,~] = newtimef(data,8000,[-4000 4000],Fs,[0.01 0.1],...
      'baseline',NaN,'freqs', [0 60],'verbose','off','trialbase','on');
    clf;
  end
  
  % Get normalized ITC data generated before subtracting ERP
  data     = abs(itc);
  bl       = mean(data(:,:,times>-1500&times<-500,:),3);
  bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
  datanorm = bsxfun(@minus,data,bl);
  f_itc_datanorm1_erp = bsxfun(@rdivide,datanorm,bl_std);  
  clear itc
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FOR CEREBELLUM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Clear variables common with M1
  clear trial_data_n ersp_data itc_data2_cmr itc_data2_erp trial_data2_erp
  
  % Z-scoring
  for j=1:size(trial_data2,1)
    tmp = reshape(squeeze(trial_data2(j,:,:)),1,[]);
    trial_data_n(j,:,:) = (trial_data2(j,:,:)-mean(tmp))./std(tmp);
  end
  
  % Median subtraction CMR
  med = median(trial_data_n,1);
  trial_data2_cmr = bsxfun(@minus,trial_data_n,med);
  
  % Split trials in to slow, intermediate and fast
  u_trial_data2_cmr = trial_data2_cmr(:,:,valid_performance>=15);  
  s_trial_data2_cmr = trial_data2_cmr(:,:,logical((valid_performance<15).*(valid_performance>=10)));
  i_trial_data2_cmr = trial_data2_cmr(:,:,logical((valid_performance<10).*(valid_performance>5)));
  f_trial_data2_cmr = trial_data2_cmr(:,:,valid_performance<=5);

  % Get ITC of unsuccessful trials using eeglab for M1 without ERP subtraction
  for j=1:size(u_trial_data2_cmr,1)
    disp(['Ch_',num2str(j)]);
    data = squeeze(u_trial_data2_cmr(j,1:8000,:));
    [~,itc(j,:,:),~,times,freqs,~,~,~] = newtimef(data,8000,[-4000 4000],Fs,[0.01 0.1],...
      'baseline',NaN,'freqs', [0 60],'verbose','off','trialbase','on');
    clf;
  end
  
  % Get normalized ITC data generated before subtracting ERP
  data     = abs(itc);
  bl       = mean(data(:,:,times>-1500&times<-500,:),3);
  bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
  datanorm = bsxfun(@minus,data,bl);
  u_itc_datanorm2_cmr = bsxfun(@rdivide,datanorm,bl_std);
  clear itc  
  
  % Get ITC of slow trials using eeglab for M1 without ERP subtraction
  for j=1:size(s_trial_data2_cmr,1)
    disp(['Ch_',num2str(j)]);
    data = squeeze(s_trial_data2_cmr(j,1:8000,:));
    [~,itc(j,:,:),~,times,freqs,~,~,~] = newtimef(data,8000,[-4000 4000],Fs,[0.01 0.1],...
      'baseline',NaN,'freqs', [0 60],'verbose','off','trialbase','on');
    clf;
  end
  
  % Get normalized ITC data generated before subtracting ERP
  data     = abs(itc);
  bl       = mean(data(:,:,times>-1500&times<-500,:),3);
  bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
  datanorm = bsxfun(@minus,data,bl);
  s_itc_datanorm2_cmr = bsxfun(@rdivide,datanorm,bl_std);
  clear itc
  
  % Get ITC of intermediate trials using eeglab for M1 without ERP subtraction
  for j=1:size(i_trial_data2_cmr,1)
    disp(['Ch_',num2str(j)]);
    data = squeeze(i_trial_data2_cmr(j,1:8000,:));
    [~,itc(j,:,:),~,times,freqs,~,~,~] = newtimef(data,8000,[-4000 4000],Fs,[0.01 0.1],...
      'baseline',NaN,'freqs', [0 60],'verbose','off','trialbase','on');
    clf;
  end
  
  % Get normalized ITC data generated before subtracting ERP
  data     = abs(itc);
  bl       = mean(data(:,:,times>-1500&times<-500,:),3);
  bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
  datanorm = bsxfun(@minus,data,bl);
  i_itc_datanorm2_cmr = bsxfun(@rdivide,datanorm,bl_std);
  clear itc 
  
  % Get ITC of fast trials using eeglab for M1 without ERP subtraction
  for j=1:size(f_trial_data2_cmr,1)
    disp(['Ch_',num2str(j)]);
    data = squeeze(f_trial_data2_cmr(j,1:8000,:));
    [~,itc(j,:,:),~,times,freqs,~,~,~] = newtimef(data,8000,[-4000 4000],Fs,[0.01 0.1],...
      'baseline',NaN,'freqs', [0 60],'verbose','off','trialbase','on');
    clf;
  end
  
  % Get normalized ITC data generated before subtracting ERP
  data     = abs(itc);
  bl       = mean(data(:,:,times>-1500&times<-500,:),3);
  bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
  datanorm = bsxfun(@minus,data,bl);
  f_itc_datanorm2_cmr = bsxfun(@rdivide,datanorm,bl_std);  
  clear itc
  
  % ERP subtraction (Channel by Channel)
  for ch=1:size(trial_data2_cmr,1)
    single_channel_data = squeeze(trial_data2_cmr(ch,:,:));
    mean_erp = mean(single_channel_data,2);
    trial_data2_erp(ch,:,:) = bsxfun(@minus,single_channel_data,mean_erp);
  end
  
  % Split trials in to slow, intermediate and fast
  u_trial_data2_erp = trial_data2_erp(:,:,valid_performance>=15);
  s_trial_data2_erp = trial_data2_erp(:,:,logical((valid_performance<15).*(valid_performance>=10)));
  i_trial_data2_erp = trial_data2_erp(:,:,logical((valid_performance<10).*(valid_performance>5)));
  f_trial_data2_erp = trial_data2_erp(:,:,valid_performance<=5);

  % Get ITC of unsuccessful trials using eeglab for M1 with ERP subtraction
  for j=1:size(u_trial_data2_erp,1)
    disp(['Ch_',num2str(j)]);
    data = squeeze(u_trial_data2_erp(j,1:8000,:));
    [~,itc(j,:,:),~,times,freqs,~,~,~] = newtimef(data,8000,[-4000 4000],Fs,[0.01 0.1],...
      'baseline',NaN,'freqs', [0 60],'verbose','off','trialbase','on');
    clf;
  end
  
  % Get normalized ITC data generated before subtracting ERP
  data     = abs(itc);
  bl       = mean(data(:,:,times>-1500&times<-500,:),3);
  bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
  datanorm = bsxfun(@minus,data,bl);
  u_itc_datanorm2_erp = bsxfun(@rdivide,datanorm,bl_std);
  clear itc
  
  % Get ITC of slow trials using eeglab for M1 with ERP subtraction
  for j=1:size(s_trial_data2_erp,1)
    disp(['Ch_',num2str(j)]);
    data = squeeze(s_trial_data2_erp(j,1:8000,:));
    [~,itc(j,:,:),~,times,freqs,~,~,~] = newtimef(data,8000,[-4000 4000],Fs,[0.01 0.1],...
      'baseline',NaN,'freqs', [0 60],'verbose','off','trialbase','on');
    clf;
  end
  
  % Get normalized ITC data generated before subtracting ERP
  data     = abs(itc);
  bl       = mean(data(:,:,times>-1500&times<-500,:),3);
  bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
  datanorm = bsxfun(@minus,data,bl);
  s_itc_datanorm2_erp = bsxfun(@rdivide,datanorm,bl_std);
  clear itc
  
  % Get ITC of intermediate trials using eeglab for M1 without ERP subtraction
  for j=1:size(i_trial_data2_erp,1)
    disp(['Ch_',num2str(j)]);
    data = squeeze(i_trial_data2_erp(j,1:8000,:));
    [~,itc(j,:,:),~,times,freqs,~,~,~] = newtimef(data,8000,[-4000 4000],Fs,[0.01 0.1],...
      'baseline',NaN,'freqs', [0 60],'verbose','off','trialbase','on');
    clf;
  end
  
  % Get normalized ITC data generated before subtracting ERP
  data     = abs(itc);
  bl       = mean(data(:,:,times>-1500&times<-500,:),3);
  bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
  datanorm = bsxfun(@minus,data,bl);
  i_itc_datanorm2_erp = bsxfun(@rdivide,datanorm,bl_std);
  clear itc 
  
  % Get ITC of fast trials using eeglab for M1 without ERP subtraction
  for j=1:size(f_trial_data2_erp,1)
    disp(['Ch_',num2str(j)]);
    data = squeeze(f_trial_data2_erp(j,1:8000,:));
    [~,itc(j,:,:),~,times,freqs,~,~,~] = newtimef(data,8000,[-4000 4000],Fs,[0.01 0.1],...
      'baseline',NaN,'freqs', [0 60],'verbose','off','trialbase','on');
    clf;
  end
  
  % Get normalized ITC data generated before subtracting ERP
  data     = abs(itc);
  bl       = mean(data(:,:,times>-1500&times<-500,:),3);
  bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
  datanorm = bsxfun(@minus,data,bl);
  f_itc_datanorm2_erp = bsxfun(@rdivide,datanorm,bl_std);  
  clear itc
  
  % Save  
  save([rootpath, bmiBlocks{i},'\','ITC.mat'],...
    'u_itc_datanorm1_cmr','s_itc_datanorm1_cmr','i_itc_datanorm1_cmr','f_itc_datanorm1_cmr',...
    'u_itc_datanorm2_cmr','s_itc_datanorm2_cmr','i_itc_datanorm2_cmr','f_itc_datanorm2_cmr',...
    'u_itc_datanorm1_erp','s_itc_datanorm1_erp','i_itc_datanorm1_erp','f_itc_datanorm1_erp',...
    'u_itc_datanorm2_erp','s_itc_datanorm2_erp','i_itc_datanorm2_erp','f_itc_datanorm2_erp');
  
end
close;
disp('done');

%% Plot trial by trial power (DELTA BAND)
%%%%%%%%%%%%%%%%%%%%%%%%%  LIST OF BLOCK ID FOR RAT I050  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auto  bmiBlocks = {'I050-191217-103432','I050-191217-113230'}; tStart = 1; tStop = 73;
% Day1  bmiBlocks = {'I050-191218-112504','I050-191218-130447'}; tStart = 42,25; tStop  = 97,80;
% Day2  bmiBlocks = {'I050-191219-105728','I050-191219-141503'}; tStart = 21,1; tStop  = 80,56;
% Day3  bmiBlocks = {'I050-191220-104050','I050-191220-135239'}; tStart = 17,1; tStop  = 84,61;
% Day4  bmiBlocks = {'I050-191221-121617','I050-191221-141352'}; tStart = 1,12; tStop  = 95,65;
% Day5  bmiBlocks = {'I050-191223-133408','I050-191223-160416'}; tStart = 1,1; tStop  = 97,43;
% Day6  bmiBlocks = {'I050-191224-105024','I050-191224-121153'}; tStart = 27,1; tStop  = 74;21;

%%%%%%%%%%%%%%%%%%%%%%%%%  LIST OF BLOCK ID FOR RAT I060  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auto  bmiBlocks = {'I060-200309-121246'}; tStart = 1; tStop = 73;
% Day1  bmiBlocks = {'I060-200310-112339','I060-200310-143141'}; tStart = 32,1; tStop  = 230,124;
% Day2  bmiBlocks = {'I060-200311-114150','I060-200311-140222'}; tStart = 21,1; tStop  = 110,124;
% Day3  bmiBlocks = {'I060-200312-111249','I060-200312-134253'}; tStart = 11,1; tStop  = 126,84;
% Day4  bmiBlocks = {'I060-200313-113905','I060-200313-142005'}; tStart = 74,1; tStop  = 148,100;
% Day5  bmiBlocks = {'I060-200314-131648','I060-200314-160410'}; tStart = 15,1; tStop  = 122,46;
clear;clc;
disp('plotting...');
rootpath = 'Z:\Aamir\BMI\';
bmiBlocks =  { 'I061\Data\I061-200505-131845'...
              ,'I061\Data\I061-200506-110632'...
              ,'I061\Data\I061-200507-111109'...
              ,'I061\Data\I061-200508-120338'...
              ,'I061\Data\I061-200509-122650'};
% bmiBlocks =  { 'I060\Data\I060-200310-112339'...
%               ,'I060\Data\I060-200311-114150'...
%               ,'I060\Data\I060-200312-111249'...
%               ,'I060\Data\I060-200313-113905'...
%               ,'I060\Data\I060-200314-131648'...
%               ,'I050\Data\I050-191218-112504'...
%               ,'I050\Data\I050-191219-105728'...
%               ,'I050\Data\I050-191220-104050'...
%               ,'I050\Data\I050-191221-121617'...
%               ,'I050\Data\I050-191223-133408'};


% Plot
figure('Color','white','Position',get(0,'Screensize'));
  
for i=1:length(bmiBlocks)
  
  % Initialize 
%   pwr_M1 = [];
%   pwr_Cb = [];
  
  % Load ERSP data for the current block
  load([rootpath, bmiBlocks{i},'\','ERSP.mat']);
  
  % Load performance and rewarded trials
  load([rootpath,bmiBlocks{i},'\Collated_LFP.mat'],'valid_performance','valid_rtrials');
  valid_rtrials = valid_rtrials~=0;
  
  % Get M1 delta band ersp successful vs unsuccessful avg across chans
  freq_band = logical((freqs>=0.1).*(freqs<=4));
  pwr_M1 = squeeze(mean(mean(ersp_datanorm1_erp(:,freq_band,:,:),1),2));
  
  % Get Cb ersp successful vs unsuccessful avg across chans
  pwr_Cb = squeeze(mean(mean(ersp_datanorm2_erp(:,freq_band,:,:),1),2));
    
  subplot(1,4,1); imagesc(times,1,pwr_M1');
  colorbar; caxis([0 3]); ylim([1,length(valid_performance)]);
  xlim([-1000 1500]); title('All-trials_M_1');
  
  subplot(1,4,2); imagesc(times,1,pwr_Cb');
  colorbar; caxis([0 3]); ylim([1,length(valid_performance)]);
  xlim([-1000 1500]); title('All-trials_C_b');
  
  subplot(1,4,3); imagesc(valid_rtrials'); ylim([1,length(valid_performance)]);
  
  subplot(1,4,4); 
  plot(valid_performance,'k','LineWidth',1.5); xlim([1,length(valid_performance)]);
  camroll(-90);
  
  suptitle('DELTA POWER 0.1-4Hz');
  
  saveas(gcf,['C:\Users\AbbasiM\Box\BMI_figures\','Delta_power_all_trials-',bmiBlocks{i}(11:21),'.tiff']); clf
  
end
close;
disp('done!');

%% Plot trial by trial power (ALPHA BAND)
clear;clc;
disp('plotting...');
rootpath = 'Z:\Aamir\BMI\';
bmiBlocks =  { 'I061\Data\I061-200505-131845'...
              ,'I061\Data\I061-200506-110632'...
              ,'I061\Data\I061-200507-111109'...
              ,'I061\Data\I061-200508-120338'...
              ,'I061\Data\I061-200509-122650'};

% bmiBlocks =  { 'I060\Data\I060-200310-112339'...
%               ,'I060\Data\I060-200311-114150'...
%               ,'I060\Data\I060-200312-111249'...
%               ,'I060\Data\I060-200313-113905'...
%               ,'I060\Data\I060-200314-131648'...
%               ,'I050\Data\I050-191218-112504'...
%               ,'I050\Data\I050-191219-105728'...
%               ,'I050\Data\I050-191220-104050'...
%               ,'I050\Data\I050-191221-121617'...
%               ,'I050\Data\I050-191223-133408'};


% Plot
figure('Color','white','Position',get(0,'Screensize'));
  
for i=1:length(bmiBlocks)
  
  % Initialize 
%   pwr_M1 = [];
%   pwr_Cb = [];
  
  % Load ERSP data for the current block
  load([rootpath, bmiBlocks{i},'\','ERSP.mat']);
  
  % Load performance and rewarded trials
  load([rootpath,bmiBlocks{i},'\Collated_LFP.mat'],'valid_performance','valid_rtrials');
  valid_rtrials = valid_rtrials~=0;
  
  % Get M1 delta band ersp successful vs unsuccessful avg across chans
  freq_band = logical((freqs>=0.1).*(freqs<=4));
  pwr_M1 = squeeze(mean(mean(ersp_datanorm1_erp(:,freq_band,:,:),1),2));
  
  % Get Cb ersp successful vs unsuccessful avg across chans
  pwr_Cb = squeeze(mean(mean(ersp_datanorm2_erp(:,freq_band,:,:),1),2));
    
  subplot(1,4,1); imagesc(times,1,pwr_M1');
  colorbar; caxis([0 3]); ylim([1,length(valid_performance)]);
  xlim([-1000 1500]); title('All-trials_M_1');
  
  subplot(1,4,2); imagesc(times,1,pwr_Cb');
  colorbar; caxis([0 3]); ylim([1,length(valid_performance)]);
  xlim([-1000 1500]); title('All-trials_C_b');
  
  subplot(1,4,3); imagesc(valid_rtrials'); ylim([1,length(valid_performance)]);
  
  subplot(1,4,4); 
  plot(valid_performance,'k','LineWidth',1.5); xlim([1,length(valid_performance)]);
  camroll(-90);
  
  suptitle('ALPHA POWER 8-14Hz');
  
  saveas(gcf,['C:\Users\AbbasiM\Box\BMI_figures\','Alpha_power_all_trials-',bmiBlocks{i}(11:21),'.tiff']); clf
  
end
close;
disp('done!');


%% Plot trial by trial power (THETA BAND)
clear;clc;
disp('plotting...');
rootpath = 'Z:\Aamir\BMI\';
bmiBlocks =  { 'I061\Data\I061-200505-131845'...
              ,'I061\Data\I061-200506-110632'...
              ,'I061\Data\I061-200507-111109'...
              ,'I061\Data\I061-200508-120338'...
              ,'I061\Data\I061-200509-122650'};

% bmiBlocks =  { 'I060\Data\I060-200310-112339'...
%               ,'I060\Data\I060-200311-114150'...
%               ,'I060\Data\I060-200312-111249'...
%               ,'I060\Data\I060-200313-113905'...
%               ,'I060\Data\I060-200314-131648'...
%               ,'I050\Data\I050-191218-112504'...
%               ,'I050\Data\I050-191219-105728'...
%               ,'I050\Data\I050-191220-104050'...
%               ,'I050\Data\I050-191221-121617'...
%               ,'I050\Data\I050-191223-133408'};


% Plot
figure('Color','white','Position',get(0,'Screensize'));
  
for i=1:length(bmiBlocks)
  
  % Initialize 
%   pwr_M1 = [];
%   pwr_Cb = [];
  
  % Load ERSP data for the current block
  load([rootpath, bmiBlocks{i},'\','ERSP.mat']);
  
  % Load performance and rewarded trials
  load([rootpath,bmiBlocks{i},'\Collated_LFP.mat'],'valid_performance','valid_rtrials');
  valid_rtrials = valid_rtrials~=0;
  
  % Get M1 delta band ersp successful vs unsuccessful avg across chans
  freq_band = logical((freqs>=0.1).*(freqs<=4));
  pwr_M1 = squeeze(mean(mean(ersp_datanorm1_erp(:,freq_band,:,:),1),2));
  
  % Get Cb ersp successful vs unsuccessful avg across chans
  pwr_Cb = squeeze(mean(mean(ersp_datanorm2_erp(:,freq_band,:,:),1),2));
    
  subplot(1,4,1); imagesc(times,1,pwr_M1');
  colorbar; caxis([0 3]); ylim([1,length(valid_performance)]);
  xlim([-1000 1500]); title('All-trials_M_1');
  
  subplot(1,4,2); imagesc(times,1,pwr_Cb');
  colorbar; caxis([0 3]); ylim([1,length(valid_performance)]);
  xlim([-1000 1500]); title('All-trials_C_b');
  
  subplot(1,4,3); imagesc(valid_rtrials'); ylim([1,length(valid_performance)]);
  
  subplot(1,4,4); 
  plot(valid_performance,'k','LineWidth',1.5); xlim([1,length(valid_performance)]);
  camroll(-90);
  
  suptitle('THETA POWER 4-8Hz');
  
  saveas(gcf,['C:\Users\AbbasiM\Box\BMI_figures\','Theta_power_all_trials-',bmiBlocks{i}(11:21),'.tiff']); clf
  
end
close;
disp('done!');

%% Plot trial by trial power (BROAD-BAND)
clear;clc;
disp('plotting...');
rootpath = 'Z:\Aamir\BMI\';
bmiBlocks =  { 'I061\Data\I061-200505-131845'...
              ,'I061\Data\I061-200506-110632'...
              ,'I061\Data\I061-200507-111109'...
              ,'I061\Data\I061-200508-120338'...
              ,'I061\Data\I061-200509-122650'};

% bmiBlocks =  { 'I060\Data\I060-200310-112339'...
%               ,'I060\Data\I060-200311-114150'...
%               ,'I060\Data\I060-200312-111249'...
%               ,'I060\Data\I060-200313-113905'...
%               ,'I060\Data\I060-200314-131648'...
%               ,'I050\Data\I050-191218-112504'...
%               ,'I050\Data\I050-191219-105728'...
%               ,'I050\Data\I050-191220-104050'...
%               ,'I050\Data\I050-191221-121617'...
%               ,'I050\Data\I050-191223-133408'};


% Plot
figure('Color','white','Position',get(0,'Screensize'));
  
for i=1:length(bmiBlocks)
  
  % Initialize 
%   pwr_M1 = [];
%   pwr_Cb = [];
  
  % Load ERSP data for the current block
  load([rootpath, bmiBlocks{i},'\','ERSP.mat']);
  
  % Load performance and rewarded trials
  load([rootpath,bmiBlocks{i},'\Collated_LFP.mat'],'valid_performance','valid_rtrials');
  valid_rtrials = valid_rtrials~=0;
  
  % Get M1 delta band ersp successful vs unsuccessful avg across chans
  freq_band = logical((freqs>=0.1).*(freqs<=4));
  pwr_M1 = squeeze(mean(mean(ersp_datanorm1_erp(:,freq_band,:,:),1),2));
  
  % Get Cb ersp successful vs unsuccessful avg across chans
  pwr_Cb = squeeze(mean(mean(ersp_datanorm2_erp(:,freq_band,:,:),1),2));
    
  subplot(1,4,1); imagesc(times,1,pwr_M1');
  colorbar; caxis([0 3]); ylim([1,length(valid_performance)]);
  xlim([-1000 1500]); title('All-trials_M_1');
  
  subplot(1,4,2); imagesc(times,1,pwr_Cb');
  colorbar; caxis([0 3]); ylim([1,length(valid_performance)]);
  xlim([-1000 1500]); title('All-trials_C_b');
  
  subplot(1,4,3); imagesc(valid_rtrials'); ylim([1,length(valid_performance)]);
  
  subplot(1,4,4); 
  plot(valid_performance,'k','LineWidth',1.5); xlim([1,length(valid_performance)]);
  camroll(-90);
  
  suptitle('BROADBAND POWER 0.1-20Hz');
  
  saveas(gcf,['C:\Users\AbbasiM\Box\BMI_figures\','Broadband_power_all_trials-',bmiBlocks{i}(11:21),'.tiff']); clf
  
end
close;
disp('done!');

%% Plot ERSP EARLY VS LATE
clear;clc;close all;
disp('plotting...');

rootpath = 'Z:\Aamir\BMI\';
bmiBlocks =  { 'I061\Data\I061-200505-131845'...
              ,'I061\Data\I061-200506-110632'...
              ,'I061\Data\I061-200507-111109'...
              ,'I061\Data\I061-200508-120338'...
              ,'I061\Data\I061-200509-122650'};
            
% bmiBlocks =  { 'I060\Data\I060-200310-112339'...
%               ,'I060\Data\I060-200311-114150'...
%               ,'I060\Data\I060-200312-111249'...
%               ,'I060\Data\I060-200313-113905'...
%               ,'I060\Data\I060-200314-131648'...
%               ,'I050\Data\I050-191218-112504'...
%               ,'I050\Data\I050-191219-105728'...
%               ,'I050\Data\I050-191220-104050'...
%               ,'I050\Data\I050-191221-121617'...
%               ,'I050\Data\I050-191223-133408'};
            
figure('Color','white','Position',get(0,'Screensize'));
for i=1:length(bmiBlocks)
  
  % Load ERSP data for the current block
  load([rootpath, bmiBlocks{i},'\','Collated_LFP_ERSP.mat'],'e_ersp_datanorm1_B1_erp','l_ersp_datanorm1_B1_erp'...
    ,'e_ersp_datanorm2_B1_erp','l_ersp_datanorm2_B1_erp','times','freqs');
  
  % Plot M1 ersp early vs late
  eT_M1(i,:,:) = squeeze(mean(mean(e_ersp_datanorm1_B1_erp,4),1));
  lT_M1(i,:,:) = squeeze(mean(mean(l_ersp_datanorm1_B1_erp,4),1));
  
  subplot(2,6,1); imagesc(times,freqs,squeeze(eT_M1(i,:,:))); vline(0,'k');
  axis xy; colorbar; caxis([0 2.5]); xlim([-1000 1500]); ylim([0 20]); title('Early')
  subplot(2,6,2); imagesc(times,freqs,squeeze(lT_M1(i,:,:))); vline(0,'k');
  axis xy; colorbar; caxis([0 2.5]); xlim([-1000 1500]); ylim([0 20]); title('Late')
  
  % Plot Cb ersp early vs late
  eT_Cb(i,:,:) = squeeze(mean(mean(e_ersp_datanorm2_B1_erp,4),1));
  lT_Cb(i,:,:) = squeeze(mean(mean(l_ersp_datanorm2_B1_erp,4),1));
  
  subplot(2,6,7); imagesc(times,freqs,squeeze(eT_Cb(i,:,:)));vline(0,'k');
  axis xy; colorbar; caxis([0 20]); xlim([-1000 1500]); ylim([0 20]);
  subplot(2,6,8); imagesc(times,freqs,squeeze(lT_Cb(i,:,:)));vline(0,'k');
  axis xy; colorbar; caxis([0 20]); xlim([-1000 1500]); ylim([0 20]);
  
  % Plot delta frequency 
  freq_band = logical((freqs>=0.1).*(freqs<4));
  a = squeeze(mean(mean(e_ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1));
  b = squeeze(mean(mean(l_ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1));
  subplot(2,6,3); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  e_delta_pwr_M1(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  l_delta_pwr_M1(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(0,'k'); title('delta 0.1-4Hz')
  
  a = squeeze(mean(mean(e_ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1));
  b = squeeze(mean(mean(l_ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1));
  subplot(2,6,9); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  e_delta_pwr_Cb(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  l_delta_pwr_Cb(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(0,'k')
  
  % Plot theta frequency
  freq_band = logical((freqs>=4).*(freqs<=8));
  a = squeeze(mean(mean(e_ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1));
  b = squeeze(mean(mean(l_ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1));
  subplot(2,6,4); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  e_theta_pwr_M1(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  l_theta_pwr_M1(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(0,'k'); title('theta 4-8Hz')
  
  a = squeeze(mean(mean(e_ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1));
  b = squeeze(mean(mean(l_ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1));
  subplot(2,6,10); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  e_theta_pwr_Cb(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  l_theta_pwr_Cb(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(0,'k')
  
  % Plot alpha frequency 
  freq_band = logical((freqs>=8).*(freqs<=14));
  a = squeeze(mean(mean(e_ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1));
  b = squeeze(mean(mean(l_ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1));
  subplot(2,6,5); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  e_alpha_pwr_M1(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  l_alpha_pwr_M1(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(0,'k'); title('alpha 8-14Hz')
  
  a = squeeze(mean(mean(e_ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1));
  b = squeeze(mean(mean(l_ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1));
  subplot(2,6,11); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  e_alpha_pwr_Cb(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  l_alpha_pwr_Cb(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(0,'k')
  
  % Plot broadband frequency
  freq_band = logical((freqs>=0.1).*(freqs<=20));
  a = squeeze(mean(mean(e_ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1));
  b = squeeze(mean(mean(l_ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1));
  subplot(2,6,6); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  e_bb_pwr_M1(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  l_bb_pwr_M1(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(0,'k'); title('broadband 0.1-20Hz')
  
  a = squeeze(mean(mean(e_ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1));
  b = squeeze(mean(mean(l_ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1));
  subplot(2,6,12); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  e_bb_pwr_Cb(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  l_bb_pwr_Cb(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(0,'k')
  legend('Early', 'Late');
  
  saveas(gcf,['C:\Users\AbbasiM\Box\BMI_figures\','EL_power-',bmiBlocks{i}(11:21),'.tiff']); clf
end

% plot average across sessions
subplot(2,6,1); imagesc(times,freqs,squeeze(mean(eT_M1,1)));vline(0,'k');
axis xy; colorbar; caxis([0 2.5]); xlim([-1000 1500]); ylim([0 20]);
subplot(2,6,2); imagesc(times,freqs,squeeze(mean(lT_M1,1)));vline(0,'k');
axis xy; colorbar; caxis([0 2.5]); xlim([-1000 1500]); ylim([0 20]);
subplot(2,6,7); imagesc(times,freqs,squeeze(mean(eT_Cb,1)));vline(0,'k');
axis xy; colorbar; caxis([0 20]); xlim([-1000 1500]); ylim([0 20]);
subplot(2,6,8); imagesc(times,freqs,squeeze(mean(lT_Cb,1)));vline(0,'k');
axis xy; colorbar; caxis([0 20]); xlim([-1000 1500]); ylim([0 20]);

% Plot average delta frequency
subplot(2,6,3); hold on;
x = times;
y = mean(e_delta_pwr_M1,1);
z = std(e_delta_pwr_M1,[],1)/sqrt(size(e_delta_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(l_delta_pwr_M1,1);
z = std(l_delta_pwr_M1,[],1)/sqrt(size(l_delta_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(e_delta_pwr_M1,1),'k');
plot(x,mean(l_delta_pwr_M1,1),'k');
xlim([-1000 1500]); vline(0,'k'); title('delta 0.1-4Hz')

subplot(2,6,9); hold on;
x = times;
y = mean(e_delta_pwr_Cb,1);
z = std(e_delta_pwr_Cb,[],1)/sqrt(size(e_delta_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(l_delta_pwr_Cb,1);
z = std(l_delta_pwr_Cb,[],1)/sqrt(size(l_delta_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(e_delta_pwr_Cb,1),'k');
plot(x,mean(l_delta_pwr_Cb,1),'k');
xlim([-1000 1500]); vline(0,'k')

% Plot average theta frequency
subplot(2,6,4); hold on;
x = times;
y = mean(e_theta_pwr_M1,1);
z = std(e_theta_pwr_M1,[],1)/sqrt(size(e_theta_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(l_theta_pwr_M1,1);
z = std(l_theta_pwr_M1,[],1)/sqrt(size(l_theta_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(e_theta_pwr_M1,1),'k');
plot(x,mean(l_theta_pwr_M1,1),'k');
xlim([-1000 1500]); vline(0,'k'); title('theta 4Hz-8Hz')

subplot(2,6,10); hold on;
x = times;
y = mean(e_theta_pwr_Cb,1);
z = std(e_theta_pwr_Cb,[],1)/sqrt(size(e_theta_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(l_theta_pwr_Cb,1);
z = std(l_theta_pwr_Cb,[],1)/sqrt(size(l_theta_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(e_theta_pwr_Cb,1),'k');
plot(x,mean(l_theta_pwr_Cb,1),'k');
xlim([-1000 1500]); vline(0,'k')

% Plot average alpha frequency
subplot(2,6,5); hold on;
x = times;
y = mean(e_alpha_pwr_M1,1);
z = std(e_alpha_pwr_M1,[],1)/sqrt(size(e_alpha_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(l_alpha_pwr_M1,1);
z = std(l_alpha_pwr_M1,[],1)/sqrt(size(l_alpha_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(e_alpha_pwr_M1,1),'k');
plot(x,mean(l_alpha_pwr_M1,1),'k');
xlim([-1000 1500]); vline(0,'k'); title('alpha 8Hz-14Hz')

subplot(2,6,11); hold on;
x = times;
y = mean(e_alpha_pwr_Cb,1);
z = std(e_alpha_pwr_Cb,[],1)/sqrt(size(e_alpha_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(l_alpha_pwr_Cb,1);
z = std(l_alpha_pwr_Cb,[],1)/sqrt(size(l_alpha_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(e_alpha_pwr_Cb,1),'k');
plot(x,mean(l_alpha_pwr_Cb,1),'k');
xlim([-1000 1500]); vline(0,'k')

% Plot broadband frequency
subplot(2,6,6); hold on;
x = times;
y = mean(e_bb_pwr_M1,1);
z = std(e_bb_pwr_M1,[],1)/sqrt(size(e_bb_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(l_bb_pwr_M1,1);
z = std(l_bb_pwr_M1,[],1)/sqrt(size(l_bb_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(e_bb_pwr_M1,1),'k');
plot(x,mean(l_bb_pwr_M1,1),'k');
xlim([-1000 1500]); vline(450,'k'); title('broadband 0.1Hz-20Hz')

subplot(2,6,12); hold on;
x = times;
y = mean(e_bb_pwr_Cb,1);
z = std(e_bb_pwr_Cb,[],1)/sqrt(size(e_bb_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(l_bb_pwr_Cb,1);
z = std(l_bb_pwr_Cb,[],1)/sqrt(size(l_bb_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(e_bb_pwr_Cb,1),'k');
plot(x,mean(l_bb_pwr_Cb,1),'k');
xlim([-1000 1500]); vline(450,'k')
legend('Early', 'Late');

saveas(gcf,['C:\Users\AbbasiM\Box\BMI_figures\','EL_power-average.tiff']);

close;
disp('done');

%% Plot ERSP SUCCESSFUL VS UNSUCCESSFUL FOR RL SESSIONS
clear;clc;close all;
disp('plotting...');
rootpath = 'Z:\Aamir\BMI\';
bmiBlocks = {  'I060\Data\I060-200310-112339'...
              ,'I060\Data\I060-200312-111249'...
              ,'I060\Data\I060-200313-113905'...
              ,'I060\Data\I060-200314-131648'...
              ,'I050\Data\I050-191218-112504'...
              ,'I050\Data\I050-191220-104050'...
              ,'I050\Data\I050-191221-121617'...              
              ,'I061\Data\I061-200506-110632'...
              ,'I061\Data\I061-200508-120338'...
              ,'I061\Data\I061-200509-122650'};
              
% bmiBlocks =  { 'I061\Data\I061-200505-131845'...
%               ,'I061\Data\I061-200506-110632'...
%               ,'I061\Data\I061-200507-111109'...
%               ,'I061\Data\I061-200508-120338'...
%               ,'I061\Data\I061-200509-122650'};

% bmiBlocks =  { 'I060\Data\I060-200310-112339'...
%               ,'I060\Data\I060-200311-114150'...
%               ,'I060\Data\I060-200312-111249'...
%               ,'I060\Data\I060-200313-113905'...
%               ,'I060\Data\I060-200314-131648'...
%               ,'I050\Data\I050-191218-112504'...
%               ,'I050\Data\I050-191219-105728'...
%               ,'I050\Data\I050-191220-104050'...
%               ,'I050\Data\I050-191221-121617'...
%               ,'I050\Data\I050-191223-133408'};


% Plot
figure('Color','white','Position',get(0,'Screensize'));
  
for i=1:length(bmiBlocks)
  
  % display current block
  disp(bmiBlocks(i));

  % Load ERSP data for the current block
  load([rootpath, bmiBlocks{i},'\','ERSP.mat']);
  
  % Load performance and rewarded trials
  load([rootpath,bmiBlocks{i},'\Collated_LFP.mat'],'valid_performance','valid_rtrials');
  
  % Plot M1 ersp unsuccessful vs successful
  uT_M1(i,:,:) = squeeze(mean(mean(ersp_datanorm1_erp(:,:,:,valid_performance>=15),4),1));
  sT_M1(i,:,:) = squeeze(mean(mean(ersp_datanorm1_erp(:,:,:,valid_performance<=5),4),1));
  
  subplot(2,6,1); imagesc(times,freqs,squeeze(uT_M1(i,:,:))); vline(450,'k');
  axis xy; colorbar; caxis([0 2.5]); xlim([-1000 1500]); ylim([0 20]); title('Unsuccessful')
  subplot(2,6,2); imagesc(times,freqs,squeeze(sT_M1(i,:,:))); vline(450,'k');
  axis xy; colorbar; caxis([0 2.5]); xlim([-1000 1500]); ylim([0 20]); title('Successful')
  
  % Plot Cb ersp unsuccessful vs successful
  uT_Cb(i,:,:) = squeeze(mean(mean(ersp_datanorm2_erp(:,:,:,valid_performance>=15),4),1));
  sT_Cb(i,:,:) = squeeze(mean(mean(ersp_datanorm2_erp(:,:,:,valid_performance<=5),4),1));
  
  subplot(2,6,7); imagesc(times,freqs,squeeze(uT_Cb(i,:,:)));vline(450,'k');
  axis xy; colorbar; caxis([0 20]); xlim([-1000 1500]); ylim([0 20]);
  subplot(2,6,8); imagesc(times,freqs,squeeze(sT_Cb(i,:,:)));vline(450,'k');
  axis xy; colorbar; caxis([0 20]); xlim([-1000 1500]); ylim([0 20]);
  
  % Plot delta frequency 
  freq_band = logical((freqs>=0.1).*(freqs<=4));
  a = squeeze(mean(mean(ersp_datanorm1_erp(:,freq_band,:,valid_performance>=15),4),1));
  b = squeeze(mean(mean(ersp_datanorm1_erp(:,freq_band,:,valid_performance<=5),4),1));
  subplot(2,6,3); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  u_delta_pwr_M1(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  s_delta_pwr_M1(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(450,'k'); title('delta 0.1-4Hz')
  
  a = squeeze(mean(mean(ersp_datanorm2_erp(:,freq_band,:,valid_performance>=15),4),1));
  b = squeeze(mean(mean(ersp_datanorm2_erp(:,freq_band,:,valid_performance<=5),4),1));
  subplot(2,6,9); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  u_delta_pwr_Cb(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  s_delta_pwr_Cb(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(450,'k')
  
  % Plot theta frequency
  freq_band = logical((freqs>=3).*(freqs<=6));
  a = squeeze(mean(mean(ersp_datanorm1_erp(:,freq_band,:,valid_performance>=15),4),1));
  b = squeeze(mean(mean(ersp_datanorm1_erp(:,freq_band,:,valid_performance<=5),4),1));
  subplot(2,6,4); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  u_theta_pwr_M1(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  s_theta_pwr_M1(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(450,'k'); title('theta 3-6Hz')
  
  a = squeeze(mean(mean(ersp_datanorm2_erp(:,freq_band,:,valid_performance>=15),4),1));
  b = squeeze(mean(mean(ersp_datanorm2_erp(:,freq_band,:,valid_performance<=5),4),1));
  subplot(2,6,10); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  u_theta_pwr_Cb(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  s_theta_pwr_Cb(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(450,'k')
  
  % Plot alpha frequency 
  freq_band = logical((freqs>=6).*(freqs<=14));
  a = squeeze(mean(mean(ersp_datanorm1_erp(:,freq_band,:,valid_performance>=15),4),1));
  b = squeeze(mean(mean(ersp_datanorm1_erp(:,freq_band,:,valid_performance<=5),4),1));
  subplot(2,6,5); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  u_alpha_pwr_M1(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  s_alpha_pwr_M1(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(450,'k'); title('alpha 6-14Hz')
  
  a = squeeze(mean(mean(ersp_datanorm2_erp(:,freq_band,:,valid_performance>=15),4),1));
  b = squeeze(mean(mean(ersp_datanorm2_erp(:,freq_band,:,valid_performance<=5),4),1));
  subplot(2,6,11); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  u_alpha_pwr_Cb(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  s_alpha_pwr_Cb(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(450,'k')
  
  % Plot broadband frequency
  freq_band = logical((freqs>=0.1).*(freqs<=20));
  a = squeeze(mean(mean(ersp_datanorm1_erp(:,freq_band,:,valid_performance>=15),4),1));
  b = squeeze(mean(mean(ersp_datanorm1_erp(:,freq_band,:,valid_performance<=5),4),1));
  subplot(2,6,6); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  u_bb_pwr_M1(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  s_bb_pwr_M1(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(450,'k'); title('broadband 0.1-20Hz')
  
  a = squeeze(mean(mean(ersp_datanorm2_erp(:,freq_band,:,valid_performance>=15),4),1));
  b = squeeze(mean(mean(ersp_datanorm2_erp(:,freq_band,:,valid_performance<=5),4),1));
  subplot(2,6,12); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  u_bb_pwr_Cb(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  s_bb_pwr_Cb(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(450,'k')
  legend('Unsuccessful', 'Successful');
  
  saveas(gcf,['C:\Users\AbbasiM\Box\BMI_figures\','US_power-',bmiBlocks{i}(11:21),'.tiff']); clf
end

% plot average across sessions
subplot(2,6,1); imagesc(times,freqs,squeeze(mean(uT_M1,1)));vline(450,'k');
axis xy; colorbar; caxis([0 2.5]); xlim([-1000 1500]); ylim([0 20]);
subplot(2,6,2); imagesc(times,freqs,squeeze(mean(sT_M1,1)));vline(450,'k');
axis xy; colorbar; caxis([0 2.5]); xlim([-1000 1500]); ylim([0 20]);
subplot(2,6,7); imagesc(times,freqs,squeeze(mean(uT_Cb,1)));vline(450,'k');
axis xy; colorbar; caxis([0 20]); xlim([-1000 1500]); ylim([0 20]);
subplot(2,6,8); imagesc(times,freqs,squeeze(mean(sT_Cb,1)));vline(450,'k');
axis xy; colorbar; caxis([0 20]); xlim([-1000 1500]); ylim([0 20]);

% Plot average delta frequency
subplot(2,6,3); hold on;
x = times;
y = mean(u_delta_pwr_M1,1);
z = std(u_delta_pwr_M1,[],1)/sqrt(size(u_delta_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(s_delta_pwr_M1,1);
z = std(s_delta_pwr_M1,[],1)/sqrt(size(s_delta_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(u_delta_pwr_M1,1),'k');
plot(x,mean(s_delta_pwr_M1,1),'k');
xlim([-1000 1500]); vline(450,'k'); title('delta 0.1-4Hz')

subplot(2,6,9); hold on;
x = times;
y = mean(u_delta_pwr_Cb,1);
z = std(u_delta_pwr_Cb,[],1)/sqrt(size(u_delta_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(s_delta_pwr_Cb,1);
z = std(s_delta_pwr_Cb,[],1)/sqrt(size(s_delta_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(u_delta_pwr_Cb,1),'k');
plot(x,mean(s_delta_pwr_Cb,1),'k');
xlim([-1000 1500]); vline(450,'k')

% Plot average theta frequency
subplot(2,6,4); hold on;
x = times;
y = mean(u_theta_pwr_M1,1);
z = std(u_theta_pwr_M1,[],1)/sqrt(size(u_theta_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(s_theta_pwr_M1,1);
z = std(s_theta_pwr_M1,[],1)/sqrt(size(s_theta_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(u_theta_pwr_M1,1),'k');
plot(x,mean(s_theta_pwr_M1,1),'k');
xlim([-1000 1500]); vline(450,'k'); title('theta 3-6Hz')

subplot(2,6,10); hold on;
x = times;
y = mean(u_theta_pwr_Cb,1);
z = std(u_theta_pwr_Cb,[],1)/sqrt(size(u_theta_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(s_theta_pwr_Cb,1);
z = std(s_theta_pwr_Cb,[],1)/sqrt(size(s_theta_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(u_theta_pwr_Cb,1),'k');
plot(x,mean(s_theta_pwr_Cb,1),'k');
xlim([-1000 1500]); vline(450,'k')

% Plot average alpha frequency
subplot(2,6,5); hold on;
x = times;
y = mean(u_alpha_pwr_M1,1);
z = std(u_alpha_pwr_M1,[],1)/sqrt(size(u_alpha_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(s_alpha_pwr_M1,1);
z = std(s_alpha_pwr_M1,[],1)/sqrt(size(s_alpha_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(u_alpha_pwr_M1,1),'k');
plot(x,mean(s_alpha_pwr_M1,1),'k');
xlim([-1000 1500]); vline(450,'k'); title('alpha 6Hz-14Hz')

subplot(2,6,11); hold on;
x = times;
y = mean(u_alpha_pwr_Cb,1);
z = std(u_alpha_pwr_Cb,[],1)/sqrt(size(u_alpha_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(s_alpha_pwr_Cb,1);
z = std(s_alpha_pwr_Cb,[],1)/sqrt(size(s_alpha_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(u_alpha_pwr_Cb,1),'k');
plot(x,mean(s_alpha_pwr_Cb,1),'k');
xlim([-1000 1500]); vline(450,'k')

% Plot broadband frequency
subplot(2,6,6); hold on;
x = times;
y = mean(u_bb_pwr_M1,1);
z = std(u_bb_pwr_M1,[],1)/sqrt(size(u_bb_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(s_bb_pwr_M1,1);
z = std(s_bb_pwr_M1,[],1)/sqrt(size(s_bb_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(u_bb_pwr_M1,1),'k');
plot(x,mean(s_bb_pwr_M1,1),'k');
xlim([-1000 1500]); vline(450,'k'); title('broadband 0.1Hz-20Hz')

subplot(2,6,12); hold on;
x = times;
y = mean(u_bb_pwr_Cb,1);
z = std(u_bb_pwr_Cb,[],1)/sqrt(size(u_bb_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(s_bb_pwr_Cb,1);
z = std(s_bb_pwr_Cb,[],1)/sqrt(size(s_bb_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(u_bb_pwr_Cb,1),'k');
plot(x,mean(s_bb_pwr_Cb,1),'k');
xlim([-1000 1500]); vline(450,'k')
legend('Unsuccessful', 'Successful');

saveas(gcf,['C:\Users\AbbasiM\Box\BMI_figures\','US_power-average.tiff']);

close;
disp('done');

%% Plot ERSP Robust Learning (RL) VS Poor Learning (PL)
clear;clc;close all;
disp('plotting...');
rootpath = 'C:\Users\AbbasiM\Desktop\';
bmiBlocks =  { 'I060\Data\I060-200310-112339'...
              ,'I060\Data\I060-200312-111249'...
              ,'I060\Data\I060-200313-113905'...
              ,'I060\Data\I060-200314-131648'...
              ,'I050\Data\I050-191218-112504'...
              ,'I050\Data\I050-191220-104050'...
              ,'I050\Data\I050-191221-121617'...
              ,'I060\Data\I060-200311-114150'... % Last three blocks are PL sessions
              ,'I050\Data\I050-191219-105728'...
              ,'I050\Data\I050-191223-133408'};
            
figure('Color','white','Position',get(0,'Screensize'));
j = 1;
for i=1:length(bmiBlocks)
  
  % Load ERSP data for the current block
  load([rootpath, bmiBlocks{i},'\','Collated_LFP_ERSP.mat'],'u_ersp_datanorm1_B1_erp','s_ersp_datanorm1_B1_erp'...
    ,'u_ersp_datanorm2_B1_erp','s_ersp_datanorm2_B1_erp','times','freqs');
  
  % concatanate u_ersp and s_ersp
  ersp_datanorm1_B1_erp = cat(4,u_ersp_datanorm1_B1_erp, s_ersp_datanorm1_B1_erp);
  ersp_datanorm2_B1_erp = cat(4,u_ersp_datanorm2_B1_erp, s_ersp_datanorm2_B1_erp);
  
  if i < 8
    
    % Robust learning sessions
    RL_M1(i,:,:) = squeeze(mean(mean(ersp_datanorm1_B1_erp,4),1));
    RL_Cb(i,:,:) = squeeze(mean(mean(ersp_datanorm2_B1_erp,4),1));
    
    % get average delta frequency
    freq_band = logical((freqs>=0.1).*(freqs<=4));
    RL_delta_pwr_M1(i,:) = mean(squeeze(mean(mean(ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1)),1);
    RL_delta_pwr_Cb(i,:) = mean(squeeze(mean(mean(ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1)),1);
    
    % get average theta frequency
    freq_band = logical((freqs>=4).*(freqs<=8));
    RL_theta_pwr_M1(i,:) = mean(squeeze(mean(mean(ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1)),1);
    RL_theta_pwr_Cb(i,:) = mean(squeeze(mean(mean(ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1)),1);
    
    % get average alpha frequency
    freq_band = logical((freqs>=8).*(freqs<=14));
    RL_alpha_pwr_M1(i,:) = mean(squeeze(mean(mean(ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1)),1);
    RL_alpha_pwr_Cb(i,:) = mean(squeeze(mean(mean(ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1)),1);
    
    % get average broadband frequency
    freq_band = logical((freqs>=0.1).*(freqs<=20));
    RL_bb_pwr_M1(i,:) = mean(squeeze(mean(mean(ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1)),1);
    RL_bb_pwr_Cb(i,:) = mean(squeeze(mean(mean(ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1)),1);
    
  elseif i >=8
    
    % Poor learning sessions
    PL_M1(j,:,:) = squeeze(mean(mean(ersp_datanorm1_B1_erp,4),1));
    PL_Cb(j,:,:) = squeeze(mean(mean(ersp_datanorm2_B1_erp,4),1));
    
    % get average delta frequency
    freq_band = logical((freqs>=0.1).*(freqs<=4));
    PL_delta_pwr_M1(j,:) = mean(squeeze(mean(mean(ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1)),1);
    PL_delta_pwr_Cb(j,:) = mean(squeeze(mean(mean(ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1)),1);
    
    % get average theta frequency
    freq_band = logical((freqs>=4).*(freqs<=8));
    PL_theta_pwr_M1(j,:) = mean(squeeze(mean(mean(ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1)),1);
    PL_theta_pwr_Cb(j,:) = mean(squeeze(mean(mean(ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1)),1);
    
    % get average alpha frequency
    freq_band = logical((freqs>=8).*(freqs<=14));
    PL_alpha_pwr_M1(j,:) = mean(squeeze(mean(mean(ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1)),1);
    PL_alpha_pwr_Cb(j,:) = mean(squeeze(mean(mean(ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1)),1);
    
    % get average broadband frequency
    freq_band = logical((freqs>=0.1).*(freqs<=20));
    PL_bb_pwr_M1(j,:) = mean(squeeze(mean(mean(ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1)),1);
    PL_bb_pwr_Cb(j,:) = mean(squeeze(mean(mean(ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1)),1);
    
    j = j + 1;
  end
 
end

% plot average across sessions
subplot(2,6,1); imagesc(times,freqs,squeeze(mean(PL_M1,1)));vline(0,'k');
axis xy; colorbar; caxis([0 2.5]); xlim([-1000 1500]); ylim([0 20]); title('Poor Learning');
subplot(2,6,2); imagesc(times,freqs,squeeze(mean(RL_M1,1)));vline(0,'k');
axis xy; colorbar; caxis([0 2.5]); xlim([-1000 1500]); ylim([0 20]); title('Robust Learning');
subplot(2,6,7); imagesc(times,freqs,squeeze(mean(PL_Cb,1)));vline(0,'k');
axis xy; colorbar; caxis([0 10]); xlim([-1000 1500]); ylim([0 20]);
subplot(2,6,8); imagesc(times,freqs,squeeze(mean(RL_Cb,1)));vline(0,'k');
axis xy; colorbar; caxis([0 10]); xlim([-1000 1500]); ylim([0 20]);

% Plot average delta frequency
subplot(2,6,3); hold on;
x = times;
y = mean(PL_delta_pwr_M1,1);
z = std(PL_delta_pwr_M1,[],1)/sqrt(size(PL_delta_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(RL_delta_pwr_M1,1);
z = std(RL_delta_pwr_M1,[],1)/sqrt(size(RL_delta_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(PL_delta_pwr_M1,1),'k');
plot(x,mean(RL_delta_pwr_M1,1),'k');
xlim([-1000 1500]); vline(0,'k'); title('delta 0.1-4Hz')

subplot(2,6,9); hold on;
x = times;
y = mean(PL_delta_pwr_Cb,1);
z = std(PL_delta_pwr_Cb,[],1)/sqrt(size(PL_delta_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(RL_delta_pwr_Cb,1);
z = std(RL_delta_pwr_Cb,[],1)/sqrt(size(RL_delta_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(PL_delta_pwr_Cb,1),'k');
plot(x,mean(RL_delta_pwr_Cb,1),'k');
xlim([-1000 1500]); vline(0,'k')

% Plot average theta frequency
subplot(2,6,4); hold on;
x = times;
y = mean(PL_theta_pwr_M1,1);
z = std(PL_theta_pwr_M1,[],1)/sqrt(size(PL_theta_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(RL_theta_pwr_M1,1);
z = std(RL_theta_pwr_M1,[],1)/sqrt(size(RL_theta_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(PL_theta_pwr_M1,1),'k');
plot(x,mean(RL_theta_pwr_M1,1),'k');
xlim([-1000 1500]); vline(0,'k'); title('theta 4Hz-6Hz')

subplot(2,6,10); hold on;
x = times;
y = mean(PL_theta_pwr_Cb,1);
z = std(PL_theta_pwr_Cb,[],1)/sqrt(size(PL_theta_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(RL_theta_pwr_Cb,1);
z = std(RL_theta_pwr_Cb,[],1)/sqrt(size(RL_theta_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(PL_theta_pwr_Cb,1),'k');
plot(x,mean(RL_theta_pwr_Cb,1),'k');
xlim([-1000 1500]); vline(0,'k')

% Plot average alpha frequency
subplot(2,6,5); hold on;
x = times;
y = mean(PL_alpha_pwr_M1,1);
z = std(PL_alpha_pwr_M1,[],1)/sqrt(size(PL_alpha_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(RL_alpha_pwr_M1,1);
z = std(RL_alpha_pwr_M1,[],1)/sqrt(size(RL_alpha_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(PL_alpha_pwr_M1,1),'k');
plot(x,mean(RL_alpha_pwr_M1,1),'k');
xlim([-1000 1500]); vline(0,'k'); title('alpha 6Hz-14Hz')

subplot(2,6,11); hold on;
x = times;
y = mean(PL_alpha_pwr_Cb,1);
z = std(PL_alpha_pwr_Cb,[],1)/sqrt(size(PL_alpha_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(RL_alpha_pwr_Cb,1);
z = std(RL_alpha_pwr_Cb,[],1)/sqrt(size(RL_alpha_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(PL_alpha_pwr_Cb,1),'k');
plot(x,mean(RL_alpha_pwr_Cb,1),'k');
xlim([-1000 1500]); vline(0,'k')

% Plot broadband frequency
subplot(2,6,6); hold on;
x = times;
y = mean(PL_bb_pwr_M1,1);
z = std(PL_bb_pwr_M1,[],1)/sqrt(size(PL_bb_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(RL_bb_pwr_M1,1);
z = std(RL_bb_pwr_M1,[],1)/sqrt(size(RL_bb_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(PL_bb_pwr_M1,1),'k');
plot(x,mean(RL_bb_pwr_M1,1),'k');
xlim([-1000 1500]); vline(0,'k'); title('broadband 0.1Hz-20Hz')

subplot(2,6,12); hold on;
x = times;
y = mean(PL_bb_pwr_Cb,1);
z = std(PL_bb_pwr_Cb,[],1)/sqrt(size(PL_bb_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(RL_bb_pwr_Cb,1);
z = std(RL_bb_pwr_Cb,[],1)/sqrt(size(RL_bb_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(PL_bb_pwr_Cb,1),'k');
plot(x,mean(RL_bb_pwr_Cb,1),'k');
xlim([-1000 1500]); vline(0,'k')
legend('PL', 'RL');

saveas(gcf,['C:\Users\AbbasiM\Box\BMI_figures\','PLRL_power-average.tiff']);

disp('done');

%% Plot ERSP FAST VS SLOW TRIALS 
clear;clc;close all;
disp('plotting...');
rootpath = 'C:\Users\AbbasiM\Desktop\';
bmiBlocks =  { 'I060\Data\I060-200310-112339'...
              ,'I060\Data\I060-200314-131648'...
              ,'I050\Data\I050-191223-133408'};
            
figure('Color','white','Position',get(0,'Screensize'));
for i=1:length(bmiBlocks)
  
  % Load ERSP data for the current block
  load([rootpath, bmiBlocks{i},'\','Collated_LFP_ERSP.mat'],'u_ersp_datanorm1_B1_erp','s_ersp_datanorm1_B1_erp'...
    ,'u_ersp_datanorm2_B1_erp','s_ersp_datanorm2_B1_erp','times','freqs');
  
  % Load performance and rewarded trials
  load([rootpath,bmiBlocks{i},'\Collated_LFP.mat'],'valid_performance','valid_rtrials');
  
  % concatanate u_ersp and s_ersp
  ersp_datanorm1_B1_erp = cat(4,u_ersp_datanorm1_B1_erp, s_ersp_datanorm1_B1_erp);
  ersp_datanorm2_B1_erp = cat(4,u_ersp_datanorm2_B1_erp, s_ersp_datanorm2_B1_erp);
  
  % split M1 trials in slow and fast (under or over 10 sec)
  u_ersp_datanorm1_B1_erp = ersp_datanorm1_B1_erp(:,:,:,valid_performance>=10);
  s_ersp_datanorm1_B1_erp = ersp_datanorm1_B1_erp(:,:,:,valid_performance<10);  
  
  % Plot M1 ersp slow vs fast
  uT_M1(i,:,:) = squeeze(mean(mean(u_ersp_datanorm1_B1_erp,4),1));
  sT_M1(i,:,:) = squeeze(mean(mean(s_ersp_datanorm1_B1_erp,4),1));
  
  subplot(2,6,1); imagesc(times,freqs,squeeze(uT_M1(i,:,:))); vline(0,'k');
  axis xy; colorbar; caxis([0 2.5]); xlim([-1000 1500]); ylim([0 20]); title('Slow-over10s');
  subplot(2,6,2); imagesc(times,freqs,squeeze(sT_M1(i,:,:))); vline(0,'k');
  axis xy; colorbar; caxis([0 2.5]); xlim([-1000 1500]); ylim([0 20]); title('Fast-under10s');
  
  % split Cb trials in slow and fast (under or over 10 sec)
  u_ersp_datanorm2_B1_erp = ersp_datanorm2_B1_erp(:,:,:,valid_performance>=10);
  s_ersp_datanorm2_B1_erp = ersp_datanorm2_B1_erp(:,:,:,valid_performance<10);
  
  % Plot Cb ersp unsuccessful vs successful
  uT_Cb(i,:,:) = squeeze(mean(mean(u_ersp_datanorm2_B1_erp,4),1));
  sT_Cb(i,:,:) = squeeze(mean(mean(s_ersp_datanorm2_B1_erp,4),1));
  
  subplot(2,6,7); imagesc(times,freqs,squeeze(uT_Cb(i,:,:)));vline(0,'k');
  axis xy; colorbar; caxis([0 20]); xlim([-1000 1500]); ylim([0 20]);
  subplot(2,6,8); imagesc(times,freqs,squeeze(sT_Cb(i,:,:)));vline(0,'k');
  axis xy; colorbar; caxis([0 20]); xlim([-1000 1500]); ylim([0 20]);
  
  % Plot delta frequency 
  freq_band = logical((freqs>=0.1).*(freqs<=4));
  a = squeeze(mean(mean(u_ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1));
  b = squeeze(mean(mean(s_ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1));
  subplot(2,6,3); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  u_delta_pwr_M1(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  s_delta_pwr_M1(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(0,'k'); title('delta 0.1-4Hz')
  
  a = squeeze(mean(mean(u_ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1));
  b = squeeze(mean(mean(s_ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1));
  subplot(2,6,9); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  u_delta_pwr_Cb(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  s_delta_pwr_Cb(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(0,'k')
  
  % Plot theta frequency
  freq_band = logical((freqs>=4).*(freqs<=8));
  a = squeeze(mean(mean(u_ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1));
  b = squeeze(mean(mean(s_ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1));
  subplot(2,6,4); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  u_theta_pwr_M1(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  s_theta_pwr_M1(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(0,'k'); title('theta 4-8Hz')
  
  a = squeeze(mean(mean(u_ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1));
  b = squeeze(mean(mean(s_ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1));
  subplot(2,6,10); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  u_theta_pwr_Cb(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  s_theta_pwr_Cb(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(0,'k')
  
  % Plot alpha frequency 
  freq_band = logical((freqs>=8).*(freqs<=14));
  a = squeeze(mean(mean(u_ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1));
  b = squeeze(mean(mean(s_ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1));
  subplot(2,6,5); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  u_alpha_pwr_M1(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  s_alpha_pwr_M1(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(0,'k'); title('alpha 8-14Hz')
  
  a = squeeze(mean(mean(u_ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1));
  b = squeeze(mean(mean(s_ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1));
  subplot(2,6,11); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  u_alpha_pwr_Cb(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  s_alpha_pwr_Cb(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(0,'k')
  
  % Plot broadband frequency
  freq_band = logical((freqs>=0.1).*(freqs<=20));
  a = squeeze(mean(mean(u_ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1));
  b = squeeze(mean(mean(s_ersp_datanorm1_B1_erp(:,freq_band,:,:),4),1));
  subplot(2,6,6); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  u_bb_pwr_M1(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  s_bb_pwr_M1(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(0,'k'); title('broadband 0.1-20Hz')
  
  a = squeeze(mean(mean(u_ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1));
  b = squeeze(mean(mean(s_ersp_datanorm2_B1_erp(:,freq_band,:,:),4),1));
  subplot(2,6,12); hold on;
  x = times;
  y = mean(a,1);
  z = std(a,[],1)/sqrt(size(a,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);
  u_bb_pwr_Cb(i,:) = mean(a,1);
  
  y = mean(b,1);
  z = std(b,[],1)/sqrt(size(b,1)-1);
  patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);
  s_bb_pwr_Cb(i,:) = mean(b,1);
  
  plot(x,mean(a,1),'k');
  plot(x,mean(b,1),'k');
  xlim([-1000 1500]); vline(0,'k')
  legend('Slow', 'Fast');
  
  saveas(gcf,['C:\Users\AbbasiM\Box\BMI_figures\','SF_power-',bmiBlocks{i}(11:21),'.tiff']); clf
end

% plot average across sessions
subplot(2,6,1); imagesc(times,freqs,squeeze(mean(uT_M1,1)));vline(0,'k');
axis xy; colorbar; caxis([0 2.5]); xlim([-1000 1500]); ylim([0 20]); title('Slow-under10s');
subplot(2,6,2); imagesc(times,freqs,squeeze(mean(sT_M1,1)));vline(0,'k');
axis xy; colorbar; caxis([0 2.5]); xlim([-1000 1500]); ylim([0 20]); title('Fast-over10s');
subplot(2,6,7); imagesc(times,freqs,squeeze(mean(uT_Cb,1)));vline(0,'k');
axis xy; colorbar; caxis([0 20]); xlim([-1000 1500]); ylim([0 20]);
subplot(2,6,8); imagesc(times,freqs,squeeze(mean(sT_Cb,1)));vline(0,'k');
axis xy; colorbar; caxis([0 20]); xlim([-1000 1500]); ylim([0 20]);

% Plot average delta frequency
subplot(2,6,3); hold on;
x = times;
y = mean(u_delta_pwr_M1,1);
z = std(u_delta_pwr_M1,[],1)/sqrt(size(u_delta_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(s_delta_pwr_M1,1);
z = std(s_delta_pwr_M1,[],1)/sqrt(size(s_delta_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(u_delta_pwr_M1,1),'k');
plot(x,mean(s_delta_pwr_M1,1),'k');
xlim([-1000 1500]); vline(0,'k'); title('delta 0.1-4Hz')

subplot(2,6,9); hold on;
x = times;
y = mean(u_delta_pwr_Cb,1);
z = std(u_delta_pwr_Cb,[],1)/sqrt(size(u_delta_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(s_delta_pwr_Cb,1);
z = std(s_delta_pwr_Cb,[],1)/sqrt(size(s_delta_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(u_delta_pwr_Cb,1),'k');
plot(x,mean(s_delta_pwr_Cb,1),'k');
xlim([-1000 1500]); vline(0,'k')

% Plot average theta frequency
subplot(2,6,4); hold on;
x = times;
y = mean(u_theta_pwr_M1,1);
z = std(u_theta_pwr_M1,[],1)/sqrt(size(u_theta_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(s_theta_pwr_M1,1);
z = std(s_theta_pwr_M1,[],1)/sqrt(size(s_theta_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(u_theta_pwr_M1,1),'k');
plot(x,mean(s_theta_pwr_M1,1),'k');
xlim([-1000 1500]); vline(0,'k'); title('theta 4Hz-6Hz')

subplot(2,6,10); hold on;
x = times;
y = mean(u_theta_pwr_Cb,1);
z = std(u_theta_pwr_Cb,[],1)/sqrt(size(u_theta_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(s_theta_pwr_Cb,1);
z = std(s_theta_pwr_Cb,[],1)/sqrt(size(s_theta_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(u_theta_pwr_Cb,1),'k');
plot(x,mean(s_theta_pwr_Cb,1),'k');
xlim([-1000 1500]); vline(0,'k')

% Plot average alpha frequency
subplot(2,6,5); hold on;
x = times;
y = mean(u_alpha_pwr_M1,1);
z = std(u_alpha_pwr_M1,[],1)/sqrt(size(u_alpha_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(s_alpha_pwr_M1,1);
z = std(s_alpha_pwr_M1,[],1)/sqrt(size(s_alpha_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(u_alpha_pwr_M1,1),'k');
plot(x,mean(s_alpha_pwr_M1,1),'k');
xlim([-1000 1500]); vline(0,'k'); title('alpha 6Hz-14Hz')

subplot(2,6,11); hold on;
x = times;
y = mean(u_alpha_pwr_Cb,1);
z = std(u_alpha_pwr_Cb,[],1)/sqrt(size(u_alpha_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(s_alpha_pwr_Cb,1);
z = std(s_alpha_pwr_Cb,[],1)/sqrt(size(s_alpha_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(u_alpha_pwr_Cb,1),'k');
plot(x,mean(s_alpha_pwr_Cb,1),'k');
xlim([-1000 1500]); vline(0,'k')

% Plot broadband frequency
subplot(2,6,6); hold on;
x = times;
y = mean(u_bb_pwr_M1,1);
z = std(u_bb_pwr_M1,[],1)/sqrt(size(u_bb_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(s_bb_pwr_M1,1);
z = std(s_bb_pwr_M1,[],1)/sqrt(size(s_bb_pwr_M1,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(u_bb_pwr_M1,1),'k');
plot(x,mean(s_bb_pwr_M1,1),'k');
xlim([-1000 1500]); vline(0,'k'); title('broadband 0.1Hz-20Hz')

subplot(2,6,12); hold on;
x = times;
y = mean(u_bb_pwr_Cb,1);
z = std(u_bb_pwr_Cb,[],1)/sqrt(size(u_bb_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.8 .4 .4],'EdgeColor',[.8 .4 .4]);

y = mean(s_bb_pwr_Cb,1);
z = std(s_bb_pwr_Cb,[],1)/sqrt(size(s_bb_pwr_Cb,1)-1);
patch([x fliplr(x)], [y+z fliplr(y-z)], [.4 .4 .8],'EdgeColor',[.4 .4 .8]);

plot(x,mean(u_bb_pwr_Cb,1),'k');
plot(x,mean(s_bb_pwr_Cb,1),'k');
xlim([-1000 1500]); vline(0,'k')
legend('Slow', 'Fast');

saveas(gcf,['C:\Users\AbbasiM\Box\BMI_figures\','SF_power-average.tiff']);

disp('done');

%% Gather consolidated power for EL or US or PLRL or SF  groups in different frequency bands
%  -----------------------------------------------------------------------------------------
%% Early-Late (EL)
clear;clc;close all;
disp('running...');
rootpath = 'C:\Users\AbbasiM\Desktop\';
bmiBlocks =  { 'I060\Data\I060-200310-112339'...
              ,'I060\Data\I060-200311-114150'...
              ,'I060\Data\I060-200312-111249'...
              ,'I060\Data\I060-200313-113905'...
              ,'I060\Data\I060-200314-131648'...
              ,'I050\Data\I050-191218-112504'...
              ,'I050\Data\I050-191219-105728'...
              ,'I050\Data\I050-191220-104050'...
              ,'I050\Data\I050-191221-121617'...
              ,'I050\Data\I050-191223-133408'};

EL_M1_delta = [];            
EL_Cb_delta = [];    
EL_M1_theta = [];            
EL_Cb_theta = [];  
EL_M1_alpha = [];            
EL_Cb_alpha = [];  

for i=1:length(bmiBlocks)
  
  % Load ERSP data for the current block
  load([rootpath, bmiBlocks{i},'\','Collated_LFP_ERSP.mat'],'e_ersp_datanorm1_B1_erp','l_ersp_datanorm1_B1_erp'...
    ,'e_ersp_datanorm2_B1_erp','l_ersp_datanorm2_B1_erp','times','freqs');
  
  % Intialize time and frequecy of interest
  time_window  = logical((times>0).*(times<1000));
  d_freq_band  = logical((freqs>=0.1).*(freqs<4));
  t_freq_band  = logical((freqs>=4).*(freqs<=8));
  a_freq_band  = logical((freqs>=8).*(freqs<=14));
  bb_freq_band = logical((freqs>=0.1).*(freqs<=20));
  
  % Get delta frequency in M1 LFP
  a = squeeze(mean(mean(mean(e_ersp_datanorm1_B1_erp(:,d_freq_band,time_window,:),4),3),2));
  b = squeeze(mean(mean(mean(l_ersp_datanorm1_B1_erp(:,d_freq_band,time_window,:),4),3),2));
  
  EL_M1_delta = [EL_M1_delta; (1:length(a))' a ones(length(a),1) repmat(str2num(bmiBlocks{i}(3:4)), length(a),1)];  
  EL_M1_delta = [EL_M1_delta; (1:length(b))' b ones(length(b),1)*2 repmat(str2num(bmiBlocks{i}(3:4)), length(b),1)];
  
  % Get delta frequency in Cb LFP
  a = squeeze(mean(mean(mean(e_ersp_datanorm2_B1_erp(:,d_freq_band,time_window,:),4),3),2));
  b = squeeze(mean(mean(mean(l_ersp_datanorm2_B1_erp(:,d_freq_band,time_window,:),4),3),2));
  
  EL_Cb_delta = [EL_Cb_delta; (1:length(a))' a ones(length(a),1) repmat(str2num(bmiBlocks{i}(3:4)), length(a),1)];  
  EL_Cb_delta = [EL_Cb_delta; (1:length(b))' b ones(length(b),1)*2 repmat(str2num(bmiBlocks{i}(3:4)), length(b),1)];   

    
  % Get theta frequency in M1 LFP
  a = squeeze(mean(mean(mean(e_ersp_datanorm1_B1_erp(:,t_freq_band,time_window,:),4),3),2));
  b = squeeze(mean(mean(mean(l_ersp_datanorm1_B1_erp(:,t_freq_band,time_window,:),4),3),2));

  EL_M1_theta = [EL_M1_theta; (1:length(a))' a ones(length(a),1) repmat(str2num(bmiBlocks{i}(3:4)), length(a),1)];  
  EL_M1_theta = [EL_M1_theta; (1:length(b))' b ones(length(b),1)*2 repmat(str2num(bmiBlocks{i}(3:4)), length(b),1)];  
  
  % Get theta frequency in Cb LFP
  a = squeeze(mean(mean(mean(e_ersp_datanorm2_B1_erp(:,t_freq_band,time_window,:),4),3),2));
  b = squeeze(mean(mean(mean(l_ersp_datanorm2_B1_erp(:,t_freq_band,time_window,:),4),3),2));

  EL_Cb_theta = [EL_Cb_theta; (1:length(a))' a ones(length(a),1) repmat(str2num(bmiBlocks{i}(3:4)), length(a),1)];  
  EL_Cb_theta = [EL_Cb_theta; (1:length(b))' b ones(length(b),1)*2 repmat(str2num(bmiBlocks{i}(3:4)), length(b),1)];   
  
  % Get alpha frequency in M1 LFP
  a = squeeze(mean(mean(mean(e_ersp_datanorm1_B1_erp(:,a_freq_band,time_window,:),4),3),2));
  b = squeeze(mean(mean(mean(l_ersp_datanorm1_B1_erp(:,a_freq_band,time_window,:),4),3),2));

  EL_M1_alpha = [EL_M1_alpha; (1:length(a))' a ones(length(a),1) repmat(str2num(bmiBlocks{i}(3:4)), length(a),1)];  
  EL_M1_alpha = [EL_M1_alpha; (1:length(b))' b ones(length(b),1)*2 repmat(str2num(bmiBlocks{i}(3:4)), length(b),1)];    
  
  % Get alpha frequency in Cb LFP
  a = squeeze(mean(mean(mean(e_ersp_datanorm2_B1_erp(:,a_freq_band,time_window,:),4),3),2));
  b = squeeze(mean(mean(mean(l_ersp_datanorm2_B1_erp(:,a_freq_band,time_window,:),4),3),2));

  EL_Cb_alpha = [EL_Cb_alpha; (1:length(a))' a ones(length(a),1) repmat(str2num(bmiBlocks{i}(3:4)), length(a),1)];  
  EL_Cb_alpha = [EL_Cb_alpha; (1:length(b))' b ones(length(b),1)*2 repmat(str2num(bmiBlocks{i}(3:4)), length(b),1)];   
  
end

save([rootpath,'EL_Consolidated.mat'],'EL_M1_delta','EL_M1_theta','EL_M1_alpha','EL_Cb_delta','EL_Cb_theta','EL_Cb_alpha'); 
disp('done!');

%% Unsuccessful-Successful (US)
clear;clc;close all;
disp('running...');
rootpath = 'C:\Users\AbbasiM\Desktop\';
bmiBlocks =  { 'I060\Data\I060-200310-112339'...
              ,'I060\Data\I060-200311-114150'...
              ,'I060\Data\I060-200312-111249'...
              ,'I060\Data\I060-200313-113905'...
              ,'I060\Data\I060-200314-131648'...
              ,'I050\Data\I050-191218-112504'...
              ,'I050\Data\I050-191219-105728'...
              ,'I050\Data\I050-191220-104050'...
              ,'I050\Data\I050-191221-121617'...
              ,'I050\Data\I050-191223-133408'};

US_M1_delta = [];            
US_Cb_delta = [];    
US_M1_theta = [];            
US_Cb_theta = [];  
US_M1_alpha = [];            
US_Cb_alpha = [];  

for i=1:length(bmiBlocks)
  
  % Load ERSP data for the current block
  load([rootpath, bmiBlocks{i},'\','Collated_LFP_ERSP.mat'],'u_ersp_datanorm1_B1_erp','s_ersp_datanorm1_B1_erp'...
    ,'u_ersp_datanorm2_B1_erp','s_ersp_datanorm2_B1_erp','times','freqs');
  
  % Intialize time and frequecy of interest
  time_window  = logical((times>0).*(times<1000));
  d_freq_band  = logical((freqs>=0.1).*(freqs<4));
  t_freq_band  = logical((freqs>=4).*(freqs<=8));
  a_freq_band  = logical((freqs>=8).*(freqs<=14));
  bb_freq_band = logical((freqs>=0.1).*(freqs<=20));
  
  % Get delta frequency in M1 LFP
  a = squeeze(mean(mean(mean(u_ersp_datanorm1_B1_erp(:,d_freq_band,time_window,:),4),3),2));
  b = squeeze(mean(mean(mean(s_ersp_datanorm1_B1_erp(:,d_freq_band,time_window,:),4),3),2));
  
  US_M1_delta = [US_M1_delta; (1:length(a))' a ones(length(a),1) repmat(str2num(bmiBlocks{i}(3:4)), length(a),1)];  
  US_M1_delta = [US_M1_delta; (1:length(b))' b ones(length(b),1)*2 repmat(str2num(bmiBlocks{i}(3:4)), length(b),1)];
  
  % Get delta frequency in Cb LFP
  a = squeeze(mean(mean(mean(u_ersp_datanorm2_B1_erp(:,d_freq_band,time_window,:),4),3),2));
  b = squeeze(mean(mean(mean(s_ersp_datanorm2_B1_erp(:,d_freq_band,time_window,:),4),3),2));
  
  US_Cb_delta = [US_Cb_delta; (1:length(a))' a ones(length(a),1) repmat(str2num(bmiBlocks{i}(3:4)), length(a),1)];  
  US_Cb_delta = [US_Cb_delta; (1:length(b))' b ones(length(b),1)*2 repmat(str2num(bmiBlocks{i}(3:4)), length(b),1)];   

    
  % Get theta frequency in M1 LFP
  a = squeeze(mean(mean(mean(u_ersp_datanorm1_B1_erp(:,t_freq_band,time_window,:),4),3),2));
  b = squeeze(mean(mean(mean(s_ersp_datanorm1_B1_erp(:,t_freq_band,time_window,:),4),3),2));

  US_M1_theta = [US_M1_theta; (1:length(a))' a ones(length(a),1) repmat(str2num(bmiBlocks{i}(3:4)), length(a),1)];  
  US_M1_theta = [US_M1_theta; (1:length(b))' b ones(length(b),1)*2 repmat(str2num(bmiBlocks{i}(3:4)), length(b),1)];  
  
  % Get theta frequency in Cb LFP
  a = squeeze(mean(mean(mean(u_ersp_datanorm2_B1_erp(:,t_freq_band,time_window,:),4),3),2));
  b = squeeze(mean(mean(mean(s_ersp_datanorm2_B1_erp(:,t_freq_band,time_window,:),4),3),2));

  US_Cb_theta = [US_Cb_theta; (1:length(a))' a ones(length(a),1) repmat(str2num(bmiBlocks{i}(3:4)), length(a),1)];  
  US_Cb_theta = [US_Cb_theta; (1:length(b))' b ones(length(b),1)*2 repmat(str2num(bmiBlocks{i}(3:4)), length(b),1)];   
  
  % Get alpha frequency in M1 LFP
  a = squeeze(mean(mean(mean(u_ersp_datanorm1_B1_erp(:,a_freq_band,time_window,:),4),3),2));
  b = squeeze(mean(mean(mean(s_ersp_datanorm1_B1_erp(:,a_freq_band,time_window,:),4),3),2));

  US_M1_alpha = [US_M1_alpha; (1:length(a))' a ones(length(a),1) repmat(str2num(bmiBlocks{i}(3:4)), length(a),1)];  
  US_M1_alpha = [US_M1_alpha; (1:length(b))' b ones(length(b),1)*2 repmat(str2num(bmiBlocks{i}(3:4)), length(b),1)];    
  
  % Get alpha frequency in Cb LFP
  a = squeeze(mean(mean(mean(u_ersp_datanorm2_B1_erp(:,a_freq_band,time_window,:),4),3),2));
  b = squeeze(mean(mean(mean(s_ersp_datanorm2_B1_erp(:,a_freq_band,time_window,:),4),3),2));

  US_Cb_alpha = [US_Cb_alpha; (1:length(a))' a ones(length(a),1) repmat(str2num(bmiBlocks{i}(3:4)), length(a),1)];  
  US_Cb_alpha = [US_Cb_alpha; (1:length(b))' b ones(length(b),1)*2 repmat(str2num(bmiBlocks{i}(3:4)), length(b),1)];   
  
end

save([rootpath,'US_Consolidated.mat'],'US_M1_delta','US_M1_theta','US_M1_alpha','US_Cb_delta','US_Cb_theta','US_Cb_alpha'); 
disp('done!');

%% Slow-Fast (SF)
clear;clc;close all;
disp('running...');
rootpath = 'C:\Users\AbbasiM\Desktop\';
bmiBlocks =  { 'I060\Data\I060-200310-112339'...
              ,'I060\Data\I060-200314-131648'...
              ,'I060\Data\I060-200311-114150'...
              ,'I050\Data\I050-191223-133408'};

SF_M1_delta = [];            
SF_Cb_delta = [];    
SF_M1_theta = [];            
SF_Cb_theta = [];  
SF_M1_alpha = [];            
SF_Cb_alpha = [];  

for i=1:length(bmiBlocks)
  
  % Load ERSP data for the current block
  load([rootpath, bmiBlocks{i},'\','Collated_LFP_ERSP.mat'],'u_ersp_datanorm1_B1_erp','s_ersp_datanorm1_B1_erp'...
    ,'u_ersp_datanorm2_B1_erp','s_ersp_datanorm2_B1_erp','times','freqs');
  
  % Intialize time and frequecy of interest
  time_window  = logical((times>0).*(times<1000));
  d_freq_band  = logical((freqs>=0.1).*(freqs<4));
  t_freq_band  = logical((freqs>=4).*(freqs<=8));
  a_freq_band  = logical((freqs>=8).*(freqs<=14));
  bb_freq_band = logical((freqs>=0.1).*(freqs<=20));
  
  % Load performance and rewarded trials
  load([rootpath,bmiBlocks{i},'\Collated_LFP.mat'],'valid_performance','valid_rtrials');
  
  % concatanate u_ersp and s_ersp
  ersp_datanorm1_B1_erp = cat(4,u_ersp_datanorm1_B1_erp, s_ersp_datanorm1_B1_erp);
  ersp_datanorm2_B1_erp = cat(4,u_ersp_datanorm2_B1_erp, s_ersp_datanorm2_B1_erp);
  
  % split M1 trials in slow and fast (under or over 10 sec)
  u_ersp_datanorm1_B1_erp = ersp_datanorm1_B1_erp(:,:,:,valid_performance>=10);
  s_ersp_datanorm1_B1_erp = ersp_datanorm1_B1_erp(:,:,:,valid_performance<10);
  
  % Get delta frequency in M1 LFP
  a = squeeze(mean(mean(mean(u_ersp_datanorm1_B1_erp(:,d_freq_band,time_window,:),4),3),2));
  b = squeeze(mean(mean(mean(s_ersp_datanorm1_B1_erp(:,d_freq_band,time_window,:),4),3),2));
  
  SF_M1_delta = [SF_M1_delta; (1:length(a))' a ones(length(a),1) repmat(str2num(bmiBlocks{i}(3:4)), length(a),1)];  
  SF_M1_delta = [SF_M1_delta; (1:length(b))' b ones(length(b),1)*2 repmat(str2num(bmiBlocks{i}(3:4)), length(b),1)];
  
  % Get delta frequency in Cb LFP
  a = squeeze(mean(mean(mean(u_ersp_datanorm2_B1_erp(:,d_freq_band,time_window,:),4),3),2));
  b = squeeze(mean(mean(mean(s_ersp_datanorm2_B1_erp(:,d_freq_band,time_window,:),4),3),2));
  
  SF_Cb_delta = [SF_Cb_delta; (1:length(a))' a ones(length(a),1) repmat(str2num(bmiBlocks{i}(3:4)), length(a),1)];  
  SF_Cb_delta = [SF_Cb_delta; (1:length(b))' b ones(length(b),1)*2 repmat(str2num(bmiBlocks{i}(3:4)), length(b),1)];   

    
  % Get theta frequency in M1 LFP
  a = squeeze(mean(mean(mean(u_ersp_datanorm1_B1_erp(:,t_freq_band,time_window,:),4),3),2));
  b = squeeze(mean(mean(mean(s_ersp_datanorm1_B1_erp(:,t_freq_band,time_window,:),4),3),2));

  SF_M1_theta = [SF_M1_theta; (1:length(a))' a ones(length(a),1) repmat(str2num(bmiBlocks{i}(3:4)), length(a),1)];  
  SF_M1_theta = [SF_M1_theta; (1:length(b))' b ones(length(b),1)*2 repmat(str2num(bmiBlocks{i}(3:4)), length(b),1)];  
  
  % Get theta frequency in Cb LFP
  a = squeeze(mean(mean(mean(u_ersp_datanorm2_B1_erp(:,t_freq_band,time_window,:),4),3),2));
  b = squeeze(mean(mean(mean(s_ersp_datanorm2_B1_erp(:,t_freq_band,time_window,:),4),3),2));

  SF_Cb_theta = [SF_Cb_theta; (1:length(a))' a ones(length(a),1) repmat(str2num(bmiBlocks{i}(3:4)), length(a),1)];  
  SF_Cb_theta = [SF_Cb_theta; (1:length(b))' b ones(length(b),1)*2 repmat(str2num(bmiBlocks{i}(3:4)), length(b),1)];   
  
  % Get alpha frequency in M1 LFP
  a = squeeze(mean(mean(mean(u_ersp_datanorm1_B1_erp(:,a_freq_band,time_window,:),4),3),2));
  b = squeeze(mean(mean(mean(s_ersp_datanorm1_B1_erp(:,a_freq_band,time_window,:),4),3),2));

  SF_M1_alpha = [SF_M1_alpha; (1:length(a))' a ones(length(a),1) repmat(str2num(bmiBlocks{i}(3:4)), length(a),1)];  
  SF_M1_alpha = [SF_M1_alpha; (1:length(b))' b ones(length(b),1)*2 repmat(str2num(bmiBlocks{i}(3:4)), length(b),1)];    
  
  % Get alpha frequency in Cb LFP
  a = squeeze(mean(mean(mean(u_ersp_datanorm2_B1_erp(:,a_freq_band,time_window,:),4),3),2));
  b = squeeze(mean(mean(mean(s_ersp_datanorm2_B1_erp(:,a_freq_band,time_window,:),4),3),2));

  SF_Cb_alpha = [SF_Cb_alpha; (1:length(a))' a ones(length(a),1) repmat(str2num(bmiBlocks{i}(3:4)), length(a),1)];  
  SF_Cb_alpha = [SF_Cb_alpha; (1:length(b))' b ones(length(b),1)*2 repmat(str2num(bmiBlocks{i}(3:4)), length(b),1)];   
  
end

save([rootpath,'SF_Consolidated.mat'],'SF_M1_delta','SF_M1_theta','SF_M1_alpha','SF_Cb_delta','SF_Cb_theta','SF_Cb_alpha'); 
disp('done!');

%% Plot and perform mixed effects analysis 
% ------------------------------------------
%% Plot Early-Late
clear;clc;close all;
rootpath = 'C:\Users\AbbasiM\Desktop\';
load([rootpath,'EL_Consolidated.mat']);

figure('Color','white','Position',get(0,'Screensize'));

% Plot delta power M1
grp1 = EL_M1_delta(EL_M1_delta(:,3)==1,2); % early
grp2 = EL_M1_delta(EL_M1_delta(:,3)==2,2); % late
subplot(231); bar([mean(grp1), mean(grp2)]); hold on
errorbar(1,mean(grp1),std(grp1)/(size(grp1,1)-1),'.');
errorbar(2,mean(grp2),std(grp2)/(size(grp2,1)-1),'.');
title('delta_M_1');

% Plot theta power M1
grp1 = EL_M1_theta(EL_M1_theta(:,3)==1,2); % early
grp2 = EL_M1_theta(EL_M1_theta(:,3)==2,2); % late
subplot(232); bar([mean(grp1), mean(grp2)]); hold on
errorbar(1,mean(grp1),std(grp1)/(size(grp1,1)-1),'.');
errorbar(2,mean(grp2),std(grp2)/(size(grp2,1)-1),'.');
title('theta_M_1');

% Plot alpha power M1
grp1 = EL_M1_alpha(EL_M1_alpha(:,3)==1,2); % early
grp2 = EL_M1_alpha(EL_M1_alpha(:,3)==2,2); % late
subplot(233); bar([mean(grp1), mean(grp2)]); hold on
errorbar(1,mean(grp1),std(grp1)/(size(grp1,1)-1),'.');
errorbar(2,mean(grp2),std(grp2)/(size(grp2,1)-1),'.');
title('alpha_M_1');

% Plot delta power Cb
grp1 = EL_Cb_delta(EL_Cb_delta(:,3)==1,2); % early
grp2 = EL_Cb_delta(EL_Cb_delta(:,3)==2,2); % late
subplot(234); bar([mean(grp1), mean(grp2)]); hold on
errorbar(1,mean(grp1),std(grp1)/(size(grp1,1)-1),'.');
errorbar(2,mean(grp2),std(grp2)/(size(grp2,1)-1),'.');
title('delta_C_b');

% Plot theta power Cb
grp1 = EL_Cb_theta(EL_Cb_theta(:,3)==1,2); % early
grp2 = EL_Cb_theta(EL_Cb_theta(:,3)==2,2); % late
subplot(235); bar([mean(grp1), mean(grp2)]); hold on
errorbar(1,mean(grp1),std(grp1)/(size(grp1,1)-1),'.');
errorbar(2,mean(grp2),std(grp2)/(size(grp2,1)-1),'.');
title('theta_C_b');

% Plot alpha power Cb
grp1 = EL_Cb_alpha(EL_Cb_alpha(:,3)==1,2); % early
grp2 = EL_Cb_alpha(EL_Cb_alpha(:,3)==2,2); % late
subplot(236); bar([mean(grp1), mean(grp2)]); hold on
errorbar(1,mean(grp1),std(grp1)/(size(grp1,1)-1),'.');
errorbar(2,mean(grp2),std(grp2)/(size(grp2,1)-1),'.');
title('alpha_C_b');

saveas(gcf,['C:\Users\AbbasiM\Box\BMI_figures\','EL_bar_plots.tiff']);

%% Mixed-effects Early-Late
clear;clc;close all;
rootpath = 'C:\Users\AbbasiM\Desktop\';
load([rootpath,'EL_Consolidated.mat']);

tbl = array2table(EL_M1_delta,'VariableNames',{'channel','power','EarlyLate','RatID'});
formula = 'power ~ 1 + EarlyLate + (1 | RatID)';
lme_EL_delta_M1 = fitlme(tbl,formula);

tbl = array2table(EL_M1_theta,'VariableNames',{'channel','power','EarlyLate','RatID'});
formula = 'power ~ 1 + EarlyLate + (1 | RatID)';
lme_EL_theta_M1 = fitlme(tbl,formula);

tbl = array2table(EL_M1_alpha,'VariableNames',{'channel','power','EarlyLate','RatID'});
formula = 'power ~ 1 + EarlyLate + (1 | RatID)';
lme_EL_alpha_M1 = fitlme(tbl,formula);

tbl = array2table(EL_Cb_delta,'VariableNames',{'channel','power','EarlyLate','RatID'});
formula = 'power ~ 1 + EarlyLate + (1 | RatID)';
lme_EL_delta_Cb = fitlme(tbl,formula);

tbl = array2table(EL_Cb_theta,'VariableNames',{'channel','power','EarlyLate','RatID'});
formula = 'power ~ 1 + EarlyLate + (1 | RatID)';
lme_EL_theta_Cb = fitlme(tbl,formula);

tbl = array2table(EL_Cb_alpha,'VariableNames',{'channel','power','EarlyLate','RatID'});
formula = 'power ~ 1 + EarlyLate + (1 | RatID)';
lme_EL_alpha_Cb = fitlme(tbl,formula);

%% Plot Unsuccessful-Successful
clear;clc;close all;
rootpath = 'C:\Users\AbbasiM\Desktop\';
load([rootpath,'US_Consolidated.mat']);

figure('Color','white','Position',get(0,'Screensize'));

% Plot delta power M1
grp1 = US_M1_delta(US_M1_delta(:,3)==1,2); % early
grp2 = US_M1_delta(US_M1_delta(:,3)==2,2); % late
subplot(231); bar([mean(grp1), mean(grp2)]); hold on
errorbar(1,mean(grp1),std(grp1)/(size(grp1,1)-1),'.');
errorbar(2,mean(grp2),std(grp2)/(size(grp2,1)-1),'.');
title('delta_M_1');

% Plot theta power M1
grp1 = US_M1_theta(US_M1_theta(:,3)==1,2); % early
grp2 = US_M1_theta(US_M1_theta(:,3)==2,2); % late
subplot(232); bar([mean(grp1), mean(grp2)]); hold on
errorbar(1,mean(grp1),std(grp1)/(size(grp1,1)-1),'.');
errorbar(2,mean(grp2),std(grp2)/(size(grp2,1)-1),'.');
title('theta_M_1');

% Plot alpha power M1
grp1 = US_M1_alpha(US_M1_alpha(:,3)==1,2); % early
grp2 = US_M1_alpha(US_M1_alpha(:,3)==2,2); % late
subplot(233); bar([mean(grp1), mean(grp2)]); hold on
errorbar(1,mean(grp1),std(grp1)/(size(grp1,1)-1),'.');
errorbar(2,mean(grp2),std(grp2)/(size(grp2,1)-1),'.');
title('alpha_M_1');

% Plot delta power Cb
grp1 = US_Cb_delta(US_Cb_delta(:,3)==1,2); % early
grp2 = US_Cb_delta(US_Cb_delta(:,3)==2,2); % late
subplot(234); bar([mean(grp1), mean(grp2)]); hold on
errorbar(1,mean(grp1),std(grp1)/(size(grp1,1)-1),'.');
errorbar(2,mean(grp2),std(grp2)/(size(grp2,1)-1),'.');
title('delta_C_b');

% Plot theta power Cb
grp1 = US_Cb_theta(US_Cb_theta(:,3)==1,2); % early
grp2 = US_Cb_theta(US_Cb_theta(:,3)==2,2); % late
subplot(235); bar([mean(grp1), mean(grp2)]); hold on
errorbar(1,mean(grp1),std(grp1)/(size(grp1,1)-1),'.');
errorbar(2,mean(grp2),std(grp2)/(size(grp2,1)-1),'.');
title('theta_C_b');

% Plot alpha power Cb
grp1 = US_Cb_alpha(US_Cb_alpha(:,3)==1,2); % early
grp2 = US_Cb_alpha(US_Cb_alpha(:,3)==2,2); % late
subplot(236); bar([mean(grp1), mean(grp2)]); hold on
errorbar(1,mean(grp1),std(grp1)/(size(grp1,1)-1),'.');
errorbar(2,mean(grp2),std(grp2)/(size(grp2,1)-1),'.');
title('alpha_C_b');

saveas(gcf,['C:\Users\AbbasiM\Box\BMI_figures\','US_bar_plots.tiff']);

%% Mixed-effects Unsuccessful-Successful
clear;clc;close all;
rootpath = 'C:\Users\AbbasiM\Desktop\';
load([rootpath,'US_Consolidated.mat']);

tbl = array2table(US_M1_delta,'VariableNames',{'channel','power','EarlyLate','RatID'});
formula = 'power ~ 1 + EarlyLate + (1 | RatID)';
lme_US_delta_M1 = fitlme(tbl,formula);

tbl = array2table(US_M1_theta,'VariableNames',{'channel','power','EarlyLate','RatID'});
formula = 'power ~ 1 + EarlyLate + (1 | RatID)';
lme_US_theta_M1 = fitlme(tbl,formula);

tbl = array2table(US_M1_alpha,'VariableNames',{'channel','power','EarlyLate','RatID'});
formula = 'power ~ 1 + EarlyLate + (1 | RatID)';
lme_US_alpha_M1 = fitlme(tbl,formula);

tbl = array2table(US_Cb_delta,'VariableNames',{'channel','power','EarlyLate','RatID'});
formula = 'power ~ 1 + EarlyLate + (1 | RatID)';
lme_US_delta_Cb = fitlme(tbl,formula);

tbl = array2table(US_Cb_theta,'VariableNames',{'channel','power','EarlyLate','RatID'});
formula = 'power ~ 1 + EarlyLate + (1 | RatID)';
lme_US_theta_Cb = fitlme(tbl,formula);

tbl = array2table(US_Cb_alpha,'VariableNames',{'channel','power','EarlyLate','RatID'});
formula = 'power ~ 1 + EarlyLate + (1 | RatID)';
lme_US_alpha_Cb = fitlme(tbl,formula);

%% Plot Slow-Fast
clear;clc;close all;
rootpath = 'C:\Users\AbbasiM\Desktop\';
load([rootpath,'SF_Consolidated.mat']);

figure('Color','white','Position',get(0,'Screensize'));

% Plot delta power M1
grp1 = SF_M1_delta(SF_M1_delta(:,3)==1,2); % slow
grp2 = SF_M1_delta(SF_M1_delta(:,3)==2,2); % fast
subplot(231); bar([mean(grp1), mean(grp2)]); hold on
errorbar(1,mean(grp1),std(grp1)/(size(grp1,1)-1),'.');
errorbar(2,mean(grp2),std(grp2)/(size(grp2,1)-1),'.');
title('delta_M_1');

% Plot theta power M1
grp1 = SF_M1_theta(SF_M1_theta(:,3)==1,2); % slow
grp2 = SF_M1_theta(SF_M1_theta(:,3)==2,2); % fast
subplot(232); bar([mean(grp1), mean(grp2)]); hold on
errorbar(1,mean(grp1),std(grp1)/(size(grp1,1)-1),'.');
errorbar(2,mean(grp2),std(grp2)/(size(grp2,1)-1),'.');
title('theta_M_1');

% Plot alpha power M1
grp1 = SF_M1_alpha(SF_M1_alpha(:,3)==1,2); % slow
grp2 = SF_M1_alpha(SF_M1_alpha(:,3)==2,2); % fast
subplot(233); bar([mean(grp1), mean(grp2)]); hold on
errorbar(1,mean(grp1),std(grp1)/(size(grp1,1)-1),'.');
errorbar(2,mean(grp2),std(grp2)/(size(grp2,1)-1),'.');
title('alpha_M_1');

% Plot delta power Cb
grp1 = SF_Cb_delta(SF_Cb_delta(:,3)==1,2); % slow
grp2 = SF_Cb_delta(SF_Cb_delta(:,3)==2,2); % fast
subplot(234); bar([mean(grp1), mean(grp2)]); hold on
errorbar(1,mean(grp1),std(grp1)/(size(grp1,1)-1),'.');
errorbar(2,mean(grp2),std(grp2)/(size(grp2,1)-1),'.');
title('delta_C_b');

% Plot theta power Cb
grp1 = SF_Cb_theta(SF_Cb_theta(:,3)==1,2); % slow
grp2 = SF_Cb_theta(SF_Cb_theta(:,3)==2,2); % fast
subplot(235); bar([mean(grp1), mean(grp2)]); hold on
errorbar(1,mean(grp1),std(grp1)/(size(grp1,1)-1),'.');
errorbar(2,mean(grp2),std(grp2)/(size(grp2,1)-1),'.');
title('theta_C_b');

% Plot alpha power Cb
grp1 = SF_Cb_alpha(SF_Cb_alpha(:,3)==1,2); % slow
grp2 = SF_Cb_alpha(SF_Cb_alpha(:,3)==2,2); % fast
subplot(236); bar([mean(grp1), mean(grp2)]); hold on
errorbar(1,mean(grp1),std(grp1)/(size(grp1,1)-1),'.');
errorbar(2,mean(grp2),std(grp2)/(size(grp2,1)-1),'.');
title('alpha_C_b');

saveas(gcf,['C:\Users\AbbasiM\Box\BMI_figures\','SF_bar_plots.tiff']);

%% Mixed-effects Slow-Fast
clear;clc;
rootpath = 'C:\Users\AbbasiM\Desktop\';
load([rootpath,'SF_Consolidated.mat']);

tbl = array2table(SF_M1_delta,'VariableNames',{'channel','power','EarlyLate','RatID'});
formula = 'power ~ 1 + EarlyLate + (1 | RatID)';
lme_SF_delta_M1 = fitlme(tbl,formula);

tbl = array2table(SF_M1_theta,'VariableNames',{'channel','power','EarlyLate','RatID'});
formula = 'power ~ 1 + EarlyLate + (1 | RatID)';
lme_SF_theta_M1 = fitlme(tbl,formula);

tbl = array2table(SF_M1_alpha,'VariableNames',{'channel','power','EarlyLate','RatID'});
formula = 'power ~ 1 + EarlyLate + (1 | RatID)';
lme_SF_alpha_M1 = fitlme(tbl,formula);

tbl = array2table(SF_Cb_delta,'VariableNames',{'channel','power','EarlyLate','RatID'});
formula = 'power ~ 1 + EarlyLate + (1 | RatID)';
lme_SF_delta_Cb = fitlme(tbl,formula);

tbl = array2table(SF_Cb_theta,'VariableNames',{'channel','power','EarlyLate','RatID'});
formula = 'power ~ 1 + EarlyLate + (1 | RatID)';
lme_SF_theta_Cb = fitlme(tbl,formula);

tbl = array2table(SF_Cb_alpha,'VariableNames',{'channel','power','EarlyLate','RatID'});
formula = 'power ~ 1 + EarlyLate + (1 | RatID)';
lme_SF_alpha_Cb = fitlme(tbl,formula);

%% Field-Field Coherence 
%% Get Cross-frequency coherence usinng eeglab
clear;clc;close all;
disp('running...');
rootpath = 'Z:\Aamir\BMI\';
bmiBlocks = {'I050\Data\I050-191218-112504'...
            ,'I050\Data\I050-191219-105728'...
            ,'I050\Data\I050-191220-104050'...
            ,'I050\Data\I050-191221-121617'...
            ,'I050\Data\I050-191223-133408'...
            ,'I060\Data\I060-200310-112339'...
            ,'I060\Data\I060-200311-114150'...
            ,'I060\Data\I060-200312-111249'...
            ,'I060\Data\I060-200313-113905'...
            ,'I060\Data\I060-200314-131648'...
            ,'I061\Data\I061-200505-131845'...
            ,'I061\Data\I061-200506-110632'...
            ,'I061\Data\I061-200507-111109'...
            ,'I061\Data\I061-200508-120338'...
            ,'I061\Data\I061-200509-122650'};
 
for i=6:10%length(bmiBlocks)
  
  % Clear shared variables
  clear u_* s_* i_* f_* trial_* times freqs tmp med
  
  % Read collated LFP matrix
  load([rootpath, bmiBlocks{i},'\','Collated_LFP.mat']);
    
  % Z-scoring M1 LFP data
  trial_data1_n = zeros(size(trial_data1));
  for j=1:size(trial_data1,1)
    tmp = reshape(squeeze(trial_data1(j,:,:)),1,[]);
    trial_data1_n(j,:,:) = (trial_data1(j,:,:)-mean(tmp))./std(tmp);
  end
  
  % Z-scoring Cb LFP data
  trial_data2_n = zeros(size(trial_data2));
  for j=1:size(trial_data2,1)
    tmp = reshape(squeeze(trial_data2(j,:,:)),1,[]);
    trial_data2_n(j,:,:) = (trial_data2(j,:,:)-mean(tmp))./std(tmp);
  end
  
  % Median subtraction CMR M1
  med = squeeze(median(trial_data1_n,1));
  for j=1:size(trial_data1_n,1)
    trial_data1_cmr(j,:,:) = bsxfun(@minus,squeeze(trial_data1_n(j,:,:)),med);
  end
  
  % Median subtraction CMR Cb
  med = squeeze(median(trial_data2_n,1));
  for j=1:size(trial_data2_n,1)
    trial_data2_cmr(j,:,:) = bsxfun(@minus,squeeze(trial_data2_n(j,:,:)),med);
  end
  
  % Split trials in to unsuccessful, slow, intermediate and fast
  u_trial_data1_cmr = trial_data1_cmr(:,:,valid_performance>=15);  
  s_trial_data1_cmr = trial_data1_cmr(:,:,logical((valid_performance<15).*(valid_performance>=10)));
  i_trial_data1_cmr = trial_data1_cmr(:,:,logical((valid_performance<10).*(valid_performance>5)));
  f_trial_data1_cmr = trial_data1_cmr(:,:,valid_performance<=5);
  
  % Split trials in to unsuccessful, slow, intermediate and fast
  u_trial_data2_cmr = trial_data2_cmr(:,:,valid_performance>=15);  
  s_trial_data2_cmr = trial_data2_cmr(:,:,logical((valid_performance<15).*(valid_performance>=10)));
  i_trial_data2_cmr = trial_data2_cmr(:,:,logical((valid_performance<10).*(valid_performance>5)));
  f_trial_data2_cmr = trial_data2_cmr(:,:,valid_performance<=5);
  
  % Get Cross-Field Spectrum for unsuccessful trials 
  for j=1:size(u_trial_data1_cmr,1)
    data1 = squeeze(u_trial_data1_cmr(j,1:8000,:));
    for k=1:size(u_trial_data2_cmr,1)
    cprintf('blue',[bmiBlocks{i}(end-17:end),' CMR unsuccessful Ch_M1: ',num2str(j),' Ch_Cb: ',num2str(k)]);
    data2 = squeeze(u_trial_data2_cmr(k,1:8000,:));
    [u_coher_cmr(j,:,:,k),~,times,freqs,~,u_cohangle_cmr(j,:,:,k),u_crossspec_cmr(j,:,:,:,k)]...
      = newcrossf(data1(:)',data2(:)',8000,[-4000 4000],Fs,[0.01 0.1],'type','coher','freqs', [0 60]);
    end
  end
  
  % Get Cross-Field Spectrum for slow trials 
  for j=1:size(s_trial_data1_cmr,1)
    data1 = squeeze(s_trial_data1_cmr(j,1:8000,:));
    for k=1:size(s_trial_data2_cmr,1)
    cprintf('blue',[bmiBlocks{i}(end-17:end),' CMR slow Ch_M1: ',num2str(j),' Ch_Cb: ',num2str(k)]);
    data2 = squeeze(s_trial_data2_cmr(k,1:8000,:));
    [s_coher_cmr(j,:,:,k),~,times,freqs,~,s_cohangle_cmr(j,:,:,k),s_crossspec_cmr(j,:,:,:,k)]...
      = newcrossf(data1(:)',data2(:)',8000,[-4000 4000],Fs,[0.01 0.1],'type','coher','freqs', [0 60]);
    end
  end  
  
  % Get Cross-Field Spectrum for intermediate trials 
  for j=1:size(i_trial_data1_cmr,1)
    data1 = squeeze(i_trial_data1_cmr(j,1:8000,:));
    for k=1:size(i_trial_data2_cmr,1)
    cprintf('blue',[bmiBlocks{i}(end-17:end),' CMR intermediate Ch_M1: ',num2str(j),' Ch_Cb: ',num2str(k)]);
    data2 = squeeze(i_trial_data2_cmr(k,1:8000,:));
    [i_coher_cmr(j,:,:,k),~,times,freqs,~,i_cohangle_cmr(j,:,:,k),i_crossspec_cmr(j,:,:,:,k)]...
      = newcrossf(data1(:)',data2(:)',8000,[-4000 4000],Fs,[0.01 0.1],'type','coher','freqs', [0 60]);
    end
  end
  
  % Get Cross-Field Spectrum for fast trials 
  for j=1:size(f_trial_data1_cmr,1)
    data1 = squeeze(f_trial_data1_cmr(j,1:8000,:));
    for k=1:size(f_trial_data2_cmr,1)
    cprintf('blue',[bmiBlocks{i}(end-17:end),' CMR fast Ch_M1: ',num2str(j),' Ch_Cb: ',num2str(k)]);
    data2 = squeeze(f_trial_data2_cmr(k,1:8000,:));
    [f_coher_cmr(j,:,:,k),~,times,freqs,~,f_cohangle_cmr(j,:,:,k),f_crossspec_cmr(j,:,:,:,k)]...
      = newcrossf(data1(:)',data2(:)',8000,[-4000 4000],Fs,[0.01 0.1],'type','coher','freqs', [0 60]);
    end
  end
  
  save([rootpath,bmiBlocks{i},'\FFC_CMR.mat'],...
    'u_coher_cmr','u_cohangle_cmr','u_crossspec_cmr',...
    's_coher_cmr','s_cohangle_cmr','s_crossspec_cmr',...
    'i_coher_cmr','i_cohangle_cmr','i_crossspec_cmr',...
    'f_coher_cmr','f_cohangle_cmr','f_crossspec_cmr',...
    'times','freqs'); 
                                       
  %--------------------------- After ERP substraction --------------------------- % 
  % ERP subtraction (Channel by Channel) for M1
  for ch=1:size(trial_data1_cmr,1)
    single_channel_data = squeeze(trial_data1_cmr(ch,:,:));
    mean_erp = mean(single_channel_data,2);
    trial_data1_erp(ch,:,:) = bsxfun(@minus,single_channel_data,mean_erp);
  end
  
  % ERP subtraction (Channel by Channel) for Cb
  for ch=1:size(trial_data2_cmr,1)
    single_channel_data = squeeze(trial_data2_cmr(ch,:,:));
    mean_erp = mean(single_channel_data,2);
    trial_data2_erp(ch,:,:) = bsxfun(@minus,single_channel_data,mean_erp);
  end
  
  % Split trials in to unsuccessful, slow, intermediate and fast
  u_trial_data1_erp = trial_data1_erp(:,:,valid_performance>=15);  
  s_trial_data1_erp = trial_data1_erp(:,:,logical((valid_performance<15).*(valid_performance>=10)));
  i_trial_data1_erp = trial_data1_erp(:,:,logical((valid_performance<10).*(valid_performance>5)));
  f_trial_data1_erp = trial_data1_erp(:,:,valid_performance<=5);
  
  % Split trials in to unsuccessful, slow, intermediate and fast
  u_trial_data2_erp = trial_data2_erp(:,:,valid_performance>=15);  
  s_trial_data2_erp = trial_data2_erp(:,:,logical((valid_performance<15).*(valid_performance>=10)));
  i_trial_data2_erp = trial_data2_erp(:,:,logical((valid_performance<10).*(valid_performance>5)));
  f_trial_data2_erp = trial_data2_erp(:,:,valid_performance<=5);  
  
  % Get Cross-Field Spectrum for unsuccessful trials 
  for j=1:size(u_trial_data1_erp,1)
    data1 = squeeze(u_trial_data1_erp(j,1:8000,:));
    for k=1:size(u_trial_data2_erp,1)
    cprintf('blue',[bmiBlocks{i}(end-17:end),' ERP unsuccessful Ch_M1: ',num2str(j),' Ch_Cb: ',num2str(k)]);
    data2 = squeeze(u_trial_data2_erp(k,1:8000,:));
    [u_coher_erp(j,:,:,k),~,times,freqs,~,u_cohangle_erp(j,:,:,k),u_crossspec_erp(j,:,:,:,k)]...
      = newcrossf(data1(:)',data2(:)',8000,[-4000 4000],Fs,[0.01 0.1],'type','coher','freqs', [0 60]);
    end
  end
  
  % Get Cross-Field Spectrum for slow trials 
  for j=1:size(s_trial_data1_erp,1)
    data1 = squeeze(s_trial_data1_erp(j,1:8000,:));
    for k=1:size(s_trial_data2_erp,1)
    cprintf('blue',[bmiBlocks{i}(end-17:end),' ERP slow Ch_M1: ',num2str(j),' Ch_Cb: ',num2str(k)]);
    data2 = squeeze(s_trial_data2_erp(k,1:8000,:));
    [s_coher_erp(j,:,:,k),~,times,freqs,~,s_cohangle_erp(j,:,:,k),s_crossspec_erp(j,:,:,:,k)]...
      = newcrossf(data1(:)',data2(:)',8000,[-4000 4000],Fs,[0.01 0.1],'type','coher','freqs', [0 60]);
    end
  end  
  
  % Get Cross-Field Spectrum for intermediate trials 
  for j=1:size(i_trial_data1_erp,1)
    data1 = squeeze(i_trial_data1_erp(j,1:8000,:));
    for k=1:size(i_trial_data2_erp,1)
    cprintf('blue',[bmiBlocks{i}(end-17:end),' ERP intermediate Ch_M1: ',num2str(j),' Ch_Cb: ',num2str(k)]);
    data2 = squeeze(i_trial_data2_erp(k,1:8000,:));
    [i_coher_erp(j,:,:,k),~,times,freqs,~,i_cohangle_erp(j,:,:,k),i_crossspec_erp(j,:,:,:,k)]...
      = newcrossf(data1(:)',data2(:)',8000,[-4000 4000],Fs,[0.01 0.1],'type','coher','freqs', [0 60]);
    end
  end
  
  % Get Cross-Field Spectrum for fast trials 
  for j=1:size(f_trial_data1_erp,1)
    data1 = squeeze(f_trial_data1_erp(j,1:8000,:));
    for k=1:size(f_trial_data2_erp,1)
    cprintf('blue',[bmiBlocks{i}(end-17:end),' ERP fast Ch_M1: ',num2str(j),' Ch_Cb: ',num2str(k)]);
    data2 = squeeze(f_trial_data2_erp(k,1:8000,:));
    [f_coher_erp(j,:,:,k),~,times,freqs,~,f_cohangle_erp(j,:,:,k),f_crossspec_erp(j,:,:,:,k)]...
      = newcrossf(data1(:)',data2(:)',8000,[-4000 4000],Fs,[0.01 0.1],'type','coher','freqs', [0 60]);
    end
  end
  
  save([rootpath,bmiBlocks{i},'\FFC_ERP.mat'],...
    'u_coher_erp','u_cohangle_erp','u_crossspec_erp',...
    's_coher_erp','s_cohangle_erp','s_crossspec_erp',...
    'i_coher_erp','i_cohangle_erp','i_crossspec_erp',...
    'f_coher_erp','f_cohangle_erp','f_crossspec_erp',...
    'times','freqs'); 
end
close;
disp('done');

%% Plot Field-Field Coherence (FFC)
clear;clc;close all;
disp('running...');
rootpath  = 'Z:\Aamir\BMI\I061\Data\';
bmiBlocks = {'I061-200508-120338', 'I061-200509-122650'};

for i=1:length(bmiBlocks)
  
  disp(bmiBlocks{i});
  
  % Read FFC data
  load([rootpath, bmiBlocks{i},'\','FFC.mat']);
  
  % Classify into slow/early and fast/late trials 
  slow = coh_datanorm_epr(:,:,valid_performance>=15);
  fast = coh_datanorm_erp(:,:,valid_performance<=5);
   
  % Plot
  slow = squeeze(mean(slow,3)); 
  fast = squeeze(mean(fast,3));

  h = figure('Color','white');
  subplot(2,2,1); pcolor(times,freqs,squeeze(mean(uT_M1,1)));vline(0.069,'k');
  shading interp; colorbar; caxis([0 6]); xlim([-1000 1500]); ylim([0 15]); title('Slow-over10s');
  subplot(2,2,2); pcolor(times,freqs,squeeze(mean(sT_M1,1)));vline(0.069,'k');
  shading interp; colorbar; caxis([0 6]); xlim([-1000 1500]); ylim([0 15]); title('Fast-under10s');

end

%% BMI1 and BMI2 spike-field coherence for I060-200310
%% Get Cross-frequency coherence usinng eeglab
clear;clc;close all;
disp('running...');
rootpath  = 'C:\Users\AbbasiM\Desktop\';
bmiBlocks = {'I060\Data\I060-200310-112339', 'I060\Data\I060-200310-143141'};


resampFs = 1000;
for i=1%:length(bmiBlocks)
  
  disp(bmiBlocks{i});
  
  % Clear shared variables
  clear trial_data1_n trial_data2_n trial_data1_erp trial_data1_erp trial_data1_cmr trial_data1_cmr...
    trial_data2_erp trial_data2_erp trial_data2_cmr trial_data2_cmr y1 y2
  
  % Load collated LFP matrix
  load([rootpath, bmiBlocks{i},'\','Collated_LFP.mat']);
  
  % Load PSTHs 
  load([rootpath, bmiBlocks{i},'\','Events_Performance_PSTH.mat'],'PSTH*');
  if mod(i,2)==1
    tmp = PSTH1_B1(:);
    counter = 1;
    for j=1:length(tmp)
       if ~isempty(tmp{j})
         psth1(counter,:,:) = tmp{j}';
         counter = counter+1;
       end
    end
    tmp = PSTH2_B1(:);
    counter = 1;
    for j=1:length(tmp)
       if ~isempty(tmp{j})
         psth2(counter,:,:) = tmp{j}';
         counter = counter+1;
       end
    end
  elseif mod(i,2)==0
    clear psth1 psth2
    tmp = PSTH1_B2(:);
    for j=1:length(tmp)
       if ~isempty(tmp{j})
         psth1(j,:,:) = tmp{j}';
       end
    end
    tmp = PSTH2_B2(:);
    for j=1:length(tmp)
       if ~isempty(tmp{j})
         psth2(j,:,:) = tmp{j}';
       end
    end
  end
  
  % Z-scoring M1 LFP data
  trial_data1_n = zeros(size(trial_data1));
  for j=1:size(trial_data1,1)
    tmp = reshape(squeeze(trial_data1(j,:,:)),1,[]);
    trial_data1_n(j,:,:) = (trial_data1(j,:,:)-mean(tmp))./std(tmp);
  end
  
  % Z-scoring Cb LFP data
  trial_data2_n = zeros(size(trial_data2));
  for j=1:size(trial_data2,1)
    tmp = reshape(squeeze(trial_data2(j,:,:)),1,[]);
    trial_data2_n(j,:,:) = (trial_data2(j,:,:)-mean(tmp))./std(tmp);
  end
  
  % Median subtraction CMR M1
  med = median(trial_data1_n,1);
  trial_data1_cmr = bsxfun(@minus,trial_data1_n,med);
  
  % Median subtraction CMR Cb
  med = median(trial_data2_n,1);
  trial_data2_cmr = bsxfun(@minus,trial_data2_n,med);
  
  % Take mean across channel of M1 and Cb
  trial_data1_cmr = mean(trial_data1_cmr,1);
  trial_data2_cmr = mean(trial_data2_cmr,1);
  
  % Resample M1 LFP to 1000Hz. 
  for j=1:size(trial_data1_cmr,1)
    x = squeeze(trial_data1_cmr(1,:,:));
    [p,q] = rat(resampFs/Fs);
    y1(j,:,:) = resample(x,p,q);
  end
  
  % Equate the size of M1 Unit PSTHs and M1 LFP
  psth1 = psth1(:,1:8000,1:size(trial_data1_cmr,3));
  trial_data1_cmr_resamp = y1(:,1:8000,:);
  
  % Resample Cb LFP to 1000Hz. 
  for j=1:size(trial_data2_cmr,1)
    x = squeeze(trial_data2_cmr(1,:,:));
    [p,q] = rat(resampFs/Fs);
    y2(j,:,:) = resample(x,p,q);
  end
  
  % Equate the size of Cb Unit PSTHs and Cb LFP
  psth2 = psth2(:,1:8000,1:size(trial_data2_cmr,3));
  trial_data2_cmr_resamp = y2(:,1:8000,:);
  
  % Get Spike-Field Coherence using eeglab for M1 Spikes-Cb LFP without ERP subtraction
  set(0,'DefaultFigureVisible','off');
  for j=1:size(psth1,1)
    for k=1:size(psth1,3)
      disp(['Ch_',num2str(j)]);
      data1 = squeeze(psth1(j,1:6500,k));
      data2 = squeeze(trial_data2_cmr_resamp(1,1:6500,k));
      [coh_cmr_m1Cb(j,:,:,k),~,times,freqs,~,cohangle_cmr_m1Cb(j,:,:,k),allcoher_cmr_m1Cb(j,:,:,k),~,~] = newcrossf(data1,data2,6500,[-4000 2500],Fs,[0.01 0.1]...
        ,'type','coher','baseline',NaN,'freqs', [0 60]);
      clf;
    end
  end
  set(0,'DefaultFigureVisible','on');
  
%   % Get normalized FFC data generated before subtracting ERP
%   data     = allcoher.*conj(allcoher);
%   bl       = mean(data(:,:,times>-1500&times<-500,:),3);
%   bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
%   datanorm = bsxfun(@minus,data,bl);
%   coher_datanorm_cmr_m1Cb = bsxfun(@rdivide,datanorm,bl_std);
  
  % Get Spike-Field Coherence using eeglab for Cb Spikes-M1 LFP without ERP subtraction
  set(0,'DefaultFigureVisible','off');
  for j=1:size(psth2,1)
    for k=1:size(psth2,3)
      disp(['Ch_',num2str(j)]);
      data1 = squeeze(psth2(j,1:6500,k));
      data2 = squeeze(trial_data1_cmr_resamp(1,1:6500,k));
      [coh_cmr_Cbm1(j,:,:,k),~,times,freqs,~,cohangle_cmr_Cbm1(j,:,:,k),allcoher_cmr_Cbm1(j,:,:,k),~,~] = newcrossf(data1,data2,6500,[-4000 2500],Fs,[0.01 0.1]...
        ,'type','coher','baseline',NaN,'freqs', [0 60]);
      clf;
    end
  end
  set(0,'DefaultFigureVisible','on');
  
%   % Get normalized FFC data generated before subtracting ERP
%   data     = allcoher.*conj(allcoher);
%   bl       = mean(data(:,:,times>-1500&times<-500,:),3);
%   bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
%   datanorm = bsxfun(@minus,data,bl);
%   coher_datanorm_cmr_Cbm1 = bsxfun(@rdivide,datanorm,bl_std);
  
  % ERP subtraction (Channel by Channel) for M1
  for ch=1:size(trial_data1_cmr,1)
    single_channel_data = squeeze(trial_data1_cmr(ch,:,:));
    mean_erp = mean(single_channel_data,2);
    trial_data1_erp(ch,:,:) = bsxfun(@minus,single_channel_data,mean_erp);
  end
  
  % ERP subtraction (Channel by Channel) for Cb
  for ch=1:size(trial_data2_cmr,1)
    single_channel_data = squeeze(trial_data2_cmr(ch,:,:));
    mean_erp = mean(single_channel_data,2);
    trial_data2_erp(ch,:,:) = bsxfun(@minus,single_channel_data,mean_erp);
  end
  
  % Take mean across channel of M1 and Cb
  trial_data1_erp = mean(trial_data1_erp,1);
  trial_data2_erp = mean(trial_data2_erp,1);
  
  % Resample M1 LFP to 1000Hz. 
  for j=1:size(trial_data1_erp,1)
    x = squeeze(trial_data1_erp(1,:,:));
    [p,q] = rat(resampFs/Fs);
    y1(j,:,:) = resample(x,p,q);
  end
  
  % Equate the size of M1 Unit PSTHs and M1 LFP
  trial_data1_erp_resamp = y1(:,1:8000,:);
  
  % Resample Cb LFP to 1000Hz. 
  for j=1:size(trial_data2_erp,1)
    x = squeeze(trial_data2_erp(1,:,:));
    [p,q] = rat(resampFs/Fs);
    y2(j,:,:) = resample(x,p,q);
  end
  
  % Equate the size of Cb Unit PSTHs and Cb LFP
  trial_data2_erp_resamp = y2(:,1:8000,:);  
  
  % Get Spike-Field Coherence using eeglab for M1 Spikes-Cb LFP with ERP subtraction
  set(0,'DefaultFigureVisible','off');
  for j=1:size(psth1,1)
    for k=1:size(psth1,3)
      disp(['Ch_',num2str(j)]);
      data1 = squeeze(psth1(j,1:6500,k));
      data2 = squeeze(trial_data2_erp_resamp(1,1:6500,k));
      [coh_erp_m1Cb(j,:,:,k),~,times,freqs,~,cohangle_erp_m1Cb(j,:,:,k),allcoher_erp_m1Cb(j,:,:,k),~,~] = newcrossf(data1,data2,6500,[-4000 2500],Fs,[0.01 0.1]...
        ,'type','coher','baseline',NaN,'freqs', [0 60]);
      clf;
    end
  end
  set(0,'DefaultFigureVisible','on');
  
  % Get normalized FFC data generated before subtracting ERP
%   data     = allcoher.*conj(allcoher);
%   bl       = mean(data(:,:,times>-1500&times<-500,:),3);
%   bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
%   datanorm = bsxfun(@minus,data,bl);
%   coher_datanorm_erp_m1Cb = bsxfun(@rdivide,datanorm,bl_std);
  
  % Get Spike-Field Coherence using eeglab for Cb Spikes-M1 LFP with ERP subtraction
  set(0,'DefaultFigureVisible','off');
  for j=1:size(psth2,1)
    for k=1:size(psth2,3)
      disp(['Ch_',num2str(j)]);
      data1 = squeeze(psth2(j,1:6500,k));
      data2 = squeeze(trial_data1_erp_resamp(1,1:6500,k));
      [coh_erp_Cbm1(j,:,:,k),~,times,freqs,~,cohangle_erp_Cbm1(j,:,:,k),allcoher_erp_Cbm1(j,:,:,k),~,~] = newcrossf(data1,data2,6500,[-4000 2500],Fs,[0.01 0.1]...
        ,'type','coher','baseline',NaN,'freqs', [0 60]);
      clf;
    end
  end
  set(0,'DefaultFigureVisible','on');
  
  % Get normalized FFC data generated before subtracting ERP
%   data     = allcoher.*conj(allcoher);
%   bl       = mean(data(:,:,times>-1500&times<-500,:),3);
%   bl_std   = std(data(:,:,times>-1500&times<-500,:),[],3);
%   datanorm = bsxfun(@minus,data,bl);
%   coher_datanorm_erp_Cbm1 = bsxfun(@rdivide,datanorm,bl_std);
  
  save([rootpath,bmiBlocks{i},'\SFC2.mat'],'allcoher_erp_m1Cb','cohangle_erp_m1Cb','coh_erp_m1Cb',...
                                          'allcoher_erp_Cbm1','cohangle_erp_Cbm1','coh_erp_Cbm1',...
                                          'allcoher_cmr_m1Cb','cohangle_cmr_m1Cb','coh_cmr_m1Cb',...
                                          'allcoher_cmr_Cbm1','cohangle_cmr_Cbm1','coh_cmr_Cbm1',...
                                          'times','freqs','valid_performance');

end

%% Get Cross-frequency coherence usinng chronux function
clear;clc;close all;
disp('running...');
rootpath  = 'C:\Users\AbbasiM\Desktop\';
bmiBlocks = {'I060\Data\I060-200310-112339', 'I060\Data\I060-200310-143141'};

for i=1:length(bmiBlocks)
  
  disp(bmiBlocks{i});
  
  % Read collated LFP matrix
  load([rootpath, bmiBlocks{i},'\','Collated_LFP.mat']);
  
  % Define parameters for the chronux function
  movingwin = [1 0.1];
  params.Fs       = Fs;
  params.fpass    = [0 20];
  params.tapers   = [10 19];
  params.trialave = 0;
  params.pad      = 0;
  params.err      = [2 0.05];
  
  % Clear shared variables
  clear trial_data1_n trial_data2_n
  
  % Z-scoring M1 LFP data
  trial_data1_n = zeros(size(trial_data1));
  for j=1:size(trial_data1,1)
    tmp = reshape(squeeze(trial_data1(j,:,:)),1,[]);
    trial_data1_n(j,:,:) = (trial_data1(j,:,:)-mean(tmp))./std(tmp);
  end
  
  % Z-scoring Cb LFP data
  trial_data2_n = zeros(size(trial_data2));
  for j=1:size(trial_data2,1)
    tmp = reshape(squeeze(trial_data2(j,:,:)),1,[]);
    trial_data2_n(j,:,:) = (trial_data2(j,:,:)-mean(tmp))./std(tmp);
  end
  
  % Median subtraction CMR M1
  med = median(trial_data1_n,1);
  trial_data1_cmr = bsxfun(@minus,trial_data1_n,med);
  
  % Median subtraction CMR Cb
  med = median(trial_data2_n,1);
  trial_data2_cmr = bsxfun(@minus,trial_data2_n,med);
  
  % Take mean across channel of M1 and Cb
  trial_data1_cmr = mean(trial_data1_cmr,1);
  trial_data2_cmr = mean(trial_data2_cmr,1);
  
  % Get Cross-Frequency Spectrum using eeglab for M1-Cb without ERP subtraction
  data1 = squeeze(trial_data1_cmr(1,:,:));
  data2 = squeeze(trial_data2_cmr(1,:,:));
  [coh,phi_cmr,~,~,~,times,freqs,~,~,~]=cohgramc(data1,data2,movingwin,params);
  
  % Get normalized coherence data before subtracting ERP
  data     = coh;
  bl       = mean(data,2);
  bl_std   = std(data,[],2);
  datanorm = bsxfun(@minus,data,bl);
  coh_datanorm_cmr = bsxfun(@rdivide,datanorm,bl_std);
  
  % ERP subtraction (Channel by Channel) for M1
  for ch=1:size(trial_data1_cmr,1)
    single_channel_data = squeeze(trial_data1_cmr(ch,:,:));
    mean_erp = mean(single_channel_data,2);
    trial_data1_erp(ch,:,:) = bsxfun(@minus,single_channel_data,mean_erp);
  end
  
  % ERP subtraction (Channel by Channel) for Cb
  for ch=1:size(trial_data2_cmr,1)
    single_channel_data = squeeze(trial_data2_cmr(ch,:,:));
    mean_erp = mean(single_channel_data,2);
    trial_data2_erp(ch,:,:) = bsxfun(@minus,single_channel_data,mean_erp);
  end
  
  % Take mean across channel of M1 and Cb
  trial_data1_erp = mean(trial_data1_erp,1);
  trial_data2_erp = mean(trial_data2_erp,1);
  
  % Get Cross-Frequency Spectrum using eeglab for M1-Cb with ERP subtraction
  data1 = squeeze(trial_data1_erp(1,:,:));
  data2 = squeeze(trial_data2_erp(1,:,:));
  [coh,phi_erp,~,~,~,times,freqs,~,~,~]=cohgramc(data1,data2,movingwin,params);
  
  % Get normalized coherence data after subtracting ERP
  data     = coh;
  bl       = mean(data,2);
  bl_std   = std(data,[],2);
  datanorm = bsxfun(@minus,data,bl);
  coh_datanorm_erp = bsxfun(@rdivide,datanorm,bl_std);
  
  % Classify into slow/early and fast/late trials for M1
  slow1 = coh_datanorm_cmr(:,:,valid_performance>=15);
  fast1 = coh_datanorm_cmr(:,:,valid_performance<=5);
  
  % Classify into slow/early and fast/late trials for Cb
  slow2 = coh_datanorm_cmr(:,:,valid_performance>=15);
  fast2 = coh_datanorm_cmr(:,:,valid_performance<=5);  

end
close;
disp('done');


