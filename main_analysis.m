clear;clc;close all;


if isunix
    cd('/common/fleischerp/');
    origin_rootpath = '/common/fleischerp/raw_data/';
    rootpath = '/common/fleischerp/data/';
    code_rootpath = '';
else
    restoredefaultpath()
    origin_rootpath = 'Z:/M1_Cb_Reach/';
    rootpath = 'D:/Pierson_Data_Analysis/';
    code_rootpath = 'C:/Users/FleischerP/Documents/MATLAB/';
end

animal = 'I086';
regen_params = true;

if ~exist([rootpath,animal,'/Shared_Data.mat'],'file')
    shared_data = struct();
    save([rootpath,animal,'/Shared_Data.mat'], 'shared_data');
end

if exist([rootpath,animal,'/Parameters.mat'],'file') && ~regen_params
    load([rootpath,animal,'/Parameters.mat'])
else
    if exist([rootpath,animal,'/Parameters.mat'],'file')
        load([rootpath,animal,'/Parameters.mat'])
    else
        param = struct();
    end

    if strcmp(animal, 'I060')
        %I060 Settings
        param.training_block_names = {'TDT_data/I050-200316-135106' 'TDT_data/I050-200316-162539';
                                      'TDT_data/I050-200317-113531' 'TDT_data/I050-200317-144149';
                                      'TDT_data/I050-200318-115517' 'TDT_data/I050-200318-144712';
                                      'TDT_data/I050-200319-112351' 'TDT_data/I050-200319-141221';
                                      'TDT_data/I050-200320-112028' 'TDT_data/I050-200320-140715'};

           param.sleep_block_names = {'I050-200316-115829' 'I050-200316-145422';
                                      'I050-200317-092828' 'I050-200317-122703';
                                      'I050-200318-095036' 'I050-200318-123956';
                                      'I050-200319-092129' 'I050-200319-121123';
                                      'I050-200320-092309' 'I050-200320-120325'};
                    
        param.durFiles = ['Durations_200316';'Durations_200317';'Durations_200318';'Durations_200319';'Durations_200320'];
        param.WAV_video_offset = 0.25;
        param.Camera_framerate = 25; %In hz
        param.dom_hand = 'left';
        param.M1_shant_site_num = 1;
        param.Cb_shant_site_num = 4;
        param.M1_neurons = 6;
        param.Cb_neurons = 6;
        param.M1_spike_wave_Fs = 24414;
        param.Cb_spike_wave_Fs = 24414;

    elseif strcmp(animal, 'I061')
        %I061 Settings
        param.training_block_names = {['TDT_data/TDT_data/I061-200511-135832';'TDT_data/TDT_data/I061-200511-142659'] ['TDT_data/TDT_data/I061-200511-162529'];
                                      ['TDT_data/TDT_data/I061-200512-122518'] ['TDT_data/TDT_data/I061-200512-151526'];
                                      ['TDT_data/TDT_data/I061-200513-111020'] ['TDT_data/TDT_data/I061-200513-135834'];
                                      ['TDT_data/TDT_data/I061-200514-120137'] ['TDT_data/TDT_data/I061-200514-145444'];
                                      ['TDT_data/TDT_data/I061-200515-113618'] ['TDT_data/TDT_data/I061-200515-142605']};
                    
           param.sleep_block_names = {['TDT_data/TDT_data/I061-200511-105824';'TDT_data/TDT_data/I061-200511-123320'] ['TDT_data/TDT_data/I061-200511-150921'];
                                      ['TDT_data/TDT_data/I061-200512-102347'] ['TDT_data/TDT_data/I061-200512-131257'];
                                      ['TDT_data/TDT_data/I061-200513-090705'] ['TDT_data/TDT_data/I061-200513-115747'];
                                      ['TDT_data/TDT_data/I061-200514-094708'] ['TDT_data/TDT_data/I061-200514-125245'];
                                      ['TDT_data/TDT_data/I061-200515-093406'] ['TDT_data/TDT_data/I061-200515-122415']};
        
        param.durFiles = ['Durations_200511';'Durations_200512';'Durations_200513';'Durations_200514';'Durations_200515'];
        param.WAV_video_offset = 0.25;
        param.Camera_framerate = 25; %In hz
        param.dom_hand = 'left';
        param.M1_shant_site_num = 1;
        param.Cb_shant_site_num = 4;
        param.M1_neurons = 6;
        param.Cb_neurons = 12;
        param.M1_spike_wave_Fs = 24414;
        param.Cb_spike_wave_Fs = 24414;
        
    elseif strcmp(animal, 'I064')
        param.training_block_names = {['I064-200713-122227'] ['I064-200713-150141'];
                                      ['I064-200714-112650'] ['I064-200714-142951'];
                                      ['I064-200715-124653'] ['I064-200715-151426'];
                                      ['I064-200716-111934'] ['I064-200716-143134'];
                                      ['I064-200717-105528'] ['I064-200717-135405']};
                    
           param.sleep_block_names = {['I064-200713-104904'] ['I064-200713-132826'];
                                      ['I064-200714-092202'] ['I064-200714-122631'];
                                      ['I064-200715-111430'] ['I064-200715-134154'];
                                      ['I064-200716-091742'] ['I064-200716-122853'];
                                      ['I064-200717-085341'] ['I064-200717-115259']};
        
        param.durFiles = ['Durations_200713';'Durations_200714';'Durations_200715';'Durations_200716';'Durations_200717'];
        param.WAV_video_offset = 0.25;
        param.LFP_path = 'RS4_Data';
        param.Wave_path = 'Wave_Channels';
        param.Spike_path = 'RS4_Data';
        param.Camera_framerate = 25; %In hz
        param.dom_hand = 'right';
        param.M1_shant_site_num = 1;
        param.Cb_shant_site_num = 4;
        param.M1_neurons = 27;
        param.Cb_neurons = 16;
        param.M1_spike_wave_Fs = 24414;
        param.Cb_spike_wave_Fs = 24414;
        
    elseif strcmp(animal, 'I076')
        param.training_block_names = {['I076-201207-122019'] ['I076-201207-155657'];
                                      ['I076-201208-113010'] ['I076-201208-152911'];
                                      ['I076-201209-115653'] ['I076-201209-150030'];
                                      ['I076-201210-114806'] ['I076-201210-143519'];
                                      ['I076-201211-113827'] ['I076-201211-142237'];
                                      ['I076-201212-111646'] []};
                    
           param.sleep_block_names = {['I076-201207-100346'] ['I076-201207-135540'];
                                      ['I076-201208-092637'] ['I076-201208-125538'];
                                      ['I076-201209-095419'] ['I076-201209-125751'];
                                      ['I076-201210-094626'] ['I076-201210-123308'];
                                      ['I076-201211-093156'] ['I076-201211-121942'];
                                      [] []};
        
        param.durFiles = ['Durations_201207';'Durations_201208';'Durations_201209';'Durations_201210';'Durations_201211'];
        param.WAV_video_offset = 0.25;
        param.LFP_path = 'Wave_Channels';
        param.Wave_path = 'Wave_Channels';
        param.Spike_path = 'RS4_Data';
        param.Camera_framerate = 75; %In hz
        param.dom_hand = 'right';
        param.M1_shant_site_num = 1;
        param.Cb_shant_site_num = 16;
        param.M1_neurons = 31;
        param.Cb_neurons = 30;
        param.M1_spike_wave_Fs = 24414;
        param.Cb_spike_wave_Fs = 24414;
        
    elseif strcmp(animal, 'I086')
        param.training_block_names = {['I086-210517-125705'] ['I086-210517-155945'];
                                      ['I086-210518-115542'] ['I086-210518-145742'];
                                      ['I086-210519-105747'] ['I086-210519-141210';'I086-210519-144001'];
                                      ['I086-210520-110050'] ['I086-210520-135125'];
                                      ['I086-210521-114421'] ['I086-210521-143545']};
                    
           param.sleep_block_names = {['I086-210517-095239';'I086-210517-115522'] ['I086-210517-143132'];
                                      ['I086-210518-094149'] ['I086-210518-125139'];
                                      ['I086-210519-085503'] ['I086-210519-120941'];
                                      ['I086-210520-094043'] ['I086-210520-115044'];
                                      ['I086-210521-094113'] ['I086-210521-123217']};
        
        param.durFiles = ['Durations_210517';'Durations_210518';'Durations_210519';'Durations_210520';'Durations_210521'];
        param.WAV_video_offset = 0.25;
        param.LFP_path = 'Wave_Channels';
        param.Wave_path = 'Wave_Channels';
        param.Spike_path = 'RS4_Data';
        param.Camera_framerate = 75; %In hz
        param.dom_hand = 'left';
        param.M1_shant_site_num = 1;
        param.Cb_shant_site_num = 16;
        param.M1_neurons = 14;
        param.Cb_neurons = 29;
        param.M1_spike_wave_Fs = 24414;
        param.Cb_spike_wave_Fs = 24414;
        
    elseif strcmp(animal, 'I089')
        param.training_block_names = {['I089-210628-125348'] ['I089-210628-160118'];
                                      ['I089-210629-121558'] ['I089-210629-153649'];
                                      ['I089-210630-121607'] ['I089-210630-142231'];
                                      ['I089-210701-140609'] [''];
                                      ['I089-210702-093934'] ['']};
                    
           param.sleep_block_names = {['I089-210628-101715'] ['I089-210628-135858'];
                                      ['I089-210629-095128'] ['I089-210629-133454'];
                                      ['I089-210630-110141'] ['I089-210630-131628'];
                                      [''] [''];
                                      [''] ['']};
        
        param.durFiles = ['Durations_210628';'Durations_210629';'Durations_210630';'Durations_210701';'Durations_210702'];
        param.WAV_video_offset = 0.25;
        param.LFP_path = 'Wave_Channels';
        param.Wave_path = 'Wave_Channels';
        param.Spike_path = 'RS4_Data';
        param.Camera_framerate = 75; %In hz
        param.dom_hand = 'right';
        param.M1_shant_site_num = 1;
        param.Cb_shant_site_num = 4;
        param.M1_neurons = 15;
        param.Cb_neurons = 23;
        param.M1_spike_wave_Fs = 24414;
        param.Cb_spike_wave_Fs = 24414;
        
    elseif strcmp(animal, 'I096')
        param.training_block_names = {['I096-211025-122116'] ['I096-211025-153916'];
                                      ['I096-211026-120626'] ['I096-211026-153106'];
                                      ['I096-211027-120654'] ['I096-211027-151750'];
                                      ['I096-211028-115354'] ['I096-211028-153632'];
                                      ['I096-211029-112213'] ['I096-211029-142122']};
                    
           param.sleep_block_names = {['I096-211025-102012'] ['I096-211025-133733'];
                                      ['I096-211026-100034'] ['I096-211026-132815'];
                                      ['I096-211027-100439'] ['I096-211027-131521'];
                                      ['I096-211028-095201'] ['I096-211028-132627'];
                                      ['I096-211029-095822'] ['I096-211029-121913']};
        
        param.durFiles = ['Durations_211025';'Durations_211026';'Durations_211027';'Durations_211028';'Durations_211029'];
        param.WAV_video_offset = 0.25;
        param.LFP_path = 'Wave_Channels';
        param.Wave_path = 'Wave_Channels';
        param.Spike_path = 'RS4_Data';
        param.Camera_framerate = 75; %In hz
        param.dom_hand = 'left';
        param.M1_shant_site_num = 1;
        param.Cb_shant_site_num = 16;
        param.M1_neurons = 12;
        param.Cb_neurons = 25;
        param.M1_spike_wave_Fs = 24414;
        param.Cb_spike_wave_Fs = 24414;
        
        
    elseif strcmp(animal, 'I107')
        param.training_block_names = {['I107-211213-130247'] ['I107-211213-153419'];
                                      ['I107-211214-112244'] ['I107-211214-134922'];
                                      ['I107-211215-111931'] ['I107-211215-133736'];
                                      ['I107-211216-112253'] ['I107-211216-132418'];
                                      ['I107-211217-113515'] ['I107-211217-132608']};
                    
           param.sleep_block_names = {['I107-211213-102326'; 'I107-211213-112822'] ['I107-211213-140250'];
                                      ['I107-211214-095126'] ['I107-211214-121752'];
                                      ['I107-211215-094711'] ['I107-211215-120600'];
                                      ['I107-211216-101622'] ['I107-211216-122235'];
                                      ['I107-211217-100739'; 'I107-211217-110845'] ['I107-211217-122433']};
        
        param.durFiles = ['Durations_211213';'Durations_211214';'Durations_211215';'Durations_211216';'Durations_211217'];
        param.WAV_video_offset = 0.25;
        param.LFP_path = 'Wave_Channels';
        param.Wave_path = 'Wave_Channels';
        param.Spike_path = 'RS4_Data';
        param.Camera_framerate = 75; %In hz
        param.dom_hand = 'right';
        param.M1_shant_site_num = 1;
        param.Cb_shant_site_num = 16;
        param.M1_neurons = 10;
        param.Cb_neurons = 21;
        param.M1_spike_wave_Fs = 24414;
        param.Cb_spike_wave_Fs = 24414;
        
    elseif strcmp(animal, 'I096')
        param.training_block_names = {['I096-211025-122116'] ['I096-211025-153916'];
                                      ['I096-211026-120626'] ['I096-211026-153106'];
                                      ['I096-211027-120654'] ['I096-211027-151750'];
                                      ['I096-211028-115354'] ['I096-211028-153632'];
                                      ['I096-211029-112213'] ['I096-211029-142122']};
                    
           param.sleep_block_names = {['I096-211025-102012'] ['I096-211025-133733'];
                                      ['I096-211026-100034'] ['I096-211026-132815'];
                                      ['I096-211027-100439'] ['I096-211027-131521'];
                                      ['I096-211028-095201'] ['I096-211028-132627'];
                                      ['I096-211029-095822'] ['I096-211029-121913']};
        
        param.durFiles = ['Durations_211025';'Durations_211026';'Durations_211027';'Durations_211028';'Durations_211029'];
        param.WAV_video_offset = 0.25;
        param.LFP_path = 'Wave_Channels';
        param.Wave_path = 'Wave_Channels';
        param.Spike_path = 'RS4_Data';
        param.Camera_framerate = 75; %In hz
        param.dom_hand = 'left';
        param.M1_shant_site_num = 1;
        param.Cb_shant_site_num = 16;
        param.M1_neurons = 12;
        param.Cb_neurons = 25;
        param.M1_spike_wave_Fs = 24414;
        param.Cb_spike_wave_Fs = 24414;
        
        
    elseif strcmp(animal, 'I110')
        param.training_block_names = {['I110-220314-103449'];
                                      ['I110-220315-094310'];
                                      ['I110-220316-095503'];
                                      ['I110-220317-095141'];
                                      ['I110-220318-095739']};
                    
           param.sleep_block_names = cell(5,0);
        
        param.durFiles = ['Durations_220314';'Durations_220315';'Durations_220316';'Durations_220317';'Durations_220318'];
        param.WAV_video_offset = 0.25;
        param.LFP_path = 'Wave_Channels';
        param.Wave_path = 'Wave_Channels';
        param.Spike_path = 'RS4_Data';
        param.Camera_framerate = 87; %In hz
        param.dom_hand = 'right';
        param.M1_shant_site_num = 0;
        param.Cb_shant_site_num = 32;
        param.M1_neurons = 0;
        param.Cb_neurons = 21;
        param.M1_spike_wave_Fs = 24414;
        param.Cb_spike_wave_Fs = 24414;
        
    elseif strcmp(animal, 'I122')
        param.training_block_names = {['I122-220801-121250'] ['I122-220801-155534'];
                                      ['I122-220802-111151'] ['I122-220802-143241'];
                                      ['I122-220803-112007'] ['I122-220803-143210'];
                                      ['I122-220804-110810'] ['I122-220804-142609'];
                                      ['I122-220805-111043'] ['I122-220805-142332']};
                    
           param.sleep_block_names = {['I122-220801-094046'] ['I122-220801-135342'];
                                      ['I122-220802-091025'] ['I122-220802-123043'; 'I122-220802-133300'];
                                      ['I122-220803-091853'] ['I122-220803-123008'];
                                      ['I122-220804-090709'] ['I122-220804-122036'];
                                      ['I122-220805-090917'] ['I122-220805-122214']};
        
        param.durFiles = ['Durations_220801';'Durations_220802';'Durations_220803';'Durations_220804';'Durations_220805'];
        param.WAV_video_offset = 0;
        param.LFP_path = 'Wave_Channels';
        param.Wave_path = 'Wave_Channels';
        param.Spike_path = 'RS4_Data';
        param.Camera_framerate = 303; %In hz
        param.dom_hand = 'right';
        param.M1_shant_site_num = 1;
        param.Cb_shant_site_num = 16;
        param.M1_neurons = 19;
        param.Cb_neurons = 16;
        param.M1_spike_wave_Fs = 24414;
        param.Cb_spike_wave_Fs = 24414;
        
    end
    
    
    param.codes_filename = {'_PreSleep' '_PostSleep'};
    param.block_names = {'Training1' 'Training2'};
    param.s_block_names = {'Sleep1' 'Sleep2'};
    param.days = 5;
    param.blocks = size(param.training_block_names,2);
    save([rootpath,animal,'/Parameters.mat'], 'param');
end

          %0 0 0 0 0 0 0 0 0  -  -  1  1  1  1  2  1  1  1  1  1  1  1  2  1  1  1  2  0  1  1  2  1  1  2  -  3  3  3  2                                    
          %1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40  
enabled = [0 0 0 0 0 0 0 0 0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0,...  %Enables or disables various data processing. Enabled processes that require earlier, disabled processes will attempt to load data.
...         2  2  1* 2  2  1  1* 3  -  1  1  -  1  0  1  1  1  1  2  1  1  1  2* 2        3                                          
...       %41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100
            1  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0]; %Enables or disables various data processing. Enabled processes that require earlier, disabled processes will attempt to load data.


%% Read TDT bins (1)
if enabled(1)
    disp('Block 1...')
    addpath(genpath('Z:\Matlab for analysis\TDTMatlabSDK\TDTSDK\TDTbin2mat'))
    for day=1:param.days
        for block=1:param.blocks
            tbn = param.training_block_names{day, block};
            for sub_block = 1:size(tbn,1)
                if strcmp(animal, 'I064')
                    all_data = SEV2mat([origin_rootpath,animal,'/',param.LFP_path,'/',tbn(sub_block,:)]);
                    [filtered_data, Fs_lfp] = filter_RS4_sev_data(all_data.RSn1,[32 32]);
                    LFPs1 = filtered_data{1};
                    LFPs2 = filtered_data{2};
                    save([origin_rootpath,animal,'/',param.LFP_path,'/',tbn(sub_block,:),'/LFP_M1.mat'],'LFPs1','Fs_lfp');
                    save([origin_rootpath,animal,'/',param.LFP_path,'/',tbn(sub_block,:),'/LFP_Cb.mat'],'LFPs2','Fs_lfp');
                    
                    wave_data = TDTbin2mat([origin_rootpath,animal,'/',param.Wave_path,'/',tbn(sub_block,:)],'TYPE',4);
                    Wave1 = wave_data.streams.Wav1.data;
                    Wave2 = wave_data.streams.Wav2.data;
                    Fs_wave = wave_data.streams.Wav1.fs;
                    save([origin_rootpath,animal,'/',param.Wave_path,'/',tbn(sub_block,:),'/WAV.mat'],'Wave1','Wave2','Fs_wave');

                elseif strcmp(animal, 'I076') || strcmp(animal, 'I086') ||  strcmp(animal, 'I089') ||  strcmp(animal, 'I096') ||  strcmp(animal, 'I107') || strcmp(animal, 'I110') || strcmp(animal, 'I122')
                    if ~strcmp(tbn, '')
                        all_data = TDTbin2mat([origin_rootpath,animal,'/',param.Wave_path,'/',tbn(sub_block,:)],'TYPE',4);
                        
                        
                        % Extract and save M1 LFP
                        if isfield(all_data.streams,'LFP1')
                            LFPs1 = all_data.streams.LFP1.data;
                            Fs_lfp = all_data.streams.LFP1.fs; %#ok<NASGU>
                        else
                            LFPs1 = zeros(0,size(all_data.streams.LFP2.data,2));
                            Fs_lfp = all_data.streams.LFP2.fs; %#ok<NASGU>
                        end
                        save([origin_rootpath,animal,'/',param.LFP_path,'/',tbn(sub_block,:),'/LFP_M1.mat'],'LFPs1','Fs_lfp','-v7.3');
                        
                        
                        % Extract and save Cb LFP
                        if isfield(all_data.streams,'LFP2')
                            LFPs2 = all_data.streams.LFP2.data;
                            Fs_lfp = all_data.streams.LFP2.fs;
                        else
                            LFPs2 = zeros(0,size(all_data.streams.LFP1.data,2));
                            Fs_lfp = all_data.streams.LFP1.fs;
                        end
                        save([origin_rootpath,animal,'/',param.LFP_path,'/',tbn(sub_block,:),'/LFP_Cb.mat'],'LFPs2','Fs_lfp','-v7.3');
                        
                        
                        Wave1 = all_data.streams.Wav1.data;
                        Wave2 = all_data.streams.Wav2.data;
                        Wave3 = all_data.streams.Wav3.data;
                        Fs_wave = all_data.streams.Wav1.fs;
                        
                        save([origin_rootpath,animal,'/',param.Wave_path,'/',tbn(sub_block,:),'/WAV.mat'],'Wave1','Wave2','Wave3','Fs_wave');
                    end
                else
                    all_data = TDTbin2mat([origin_rootpath,animal,'/',tbn(sub_block,:)],'TYPE',4);
                    
                    % Extract and save wave channel
                    Wave1 = all_data.streams.Wav1.data;
                    Wave2 = all_data.streams.Wav2.data;
                    Fs_wave = all_data.streams.Wav1.fs;
                    save([origin_rootpath,animal,'/',tbn(sub_block,:),'/WAV.mat'],'Wave1','Wave2','Fs_wave');
                    
                    % Extract and save M1 LFP
                    LFPs1 = all_data.streams.LFP1.data;
                    Fs_lfp = all_data.streams.LFP1.fs; %#ok<NASGU>
                    save([origin_rootpath,animal,'/',tbn(sub_block,:),'/LFP_M1.mat'],'LFPs1','Fs_lfp','-v7.3');
                    
                    % Extract and save Cb LFP
                    LFPs2 = all_data.streams.LFP2.data;
                    Fs_lfp = all_data.streams.LFP2.fs;
                    save([origin_rootpath,animal,'/',tbn(sub_block,:),'/LFP_Cb.mat'],'LFPs2','Fs_lfp','-v7.3');
                    
                    clear all_data Wave1 Wave2 Fs_wave LFPs1 LFPs2 fs_lfp
                end
                
            end
        end
        
        for block=1:size(param.sleep_block_names, 2)
            sbn = param.sleep_block_names{day, block};
            for sub_block = 1:size(sbn,1)
                
                if strcmp(animal, 'I064')
                    all_data = SEV2mat([origin_rootpath,animal,'/',param.LFP_path,'/',sbn(sub_block,:)]);
                    [filtered_data, Fs_lfp] = filter_RS4_sev_data(all_data.RSn1,[32 32]);
                    LFPs1 = filtered_data{1};
                    LFPs2 = filtered_data{2};
                    save([origin_rootpath,animal,'/',param.LFP_path,'/',sbn(sub_block,:),'/LFP_M1.mat'],'LFPs1','Fs_lfp');
                    save([origin_rootpath,animal,'/',param.LFP_path,'/',sbn(sub_block,:),'/LFP_Cb.mat'],'LFPs2','Fs_lfp');
                    
                    wave_data = TDTbin2mat([origin_rootpath,animal,'/',param.Wave_path,'/',sbn(sub_block,:)],'TYPE',4);
                    Wave1 = wave_data.streams.Wav1.data;
                    Wave2 = wave_data.streams.Wav2.data;
                    Fs_wave = wave_data.streams.Wav1.fs;
                    save([origin_rootpath,animal,'/',param.Wave_path,'/',sbn(sub_block,:),'/WAV.mat'],'Wave1','Wave2','Fs_wave');
 
                elseif strcmp(animal, 'I076') || strcmp(animal, 'I086') ||  strcmp(animal, 'I089') ||  strcmp(animal, 'I096') ||  strcmp(animal, 'I107') ||  strcmp(animal, 'I110') || strcmp(animal, 'I122')
                    if ~strcmp(sbn, '')
                        all_data = TDTbin2mat([origin_rootpath,animal,'/',param.Wave_path,'/',sbn(sub_block,:)],'TYPE',4);
                        
                        % Extract and save M1 LFP
                        LFPs1 = all_data.streams.LFP1.data;
                        Fs_lfp = all_data.streams.LFP1.fs; %#ok<NASGU>
                        save([origin_rootpath,animal,'/',param.LFP_path,'/',sbn(sub_block,:),'/LFP_M1.mat'],'LFPs1','Fs_lfp','-v7.3');
                        
                        % Extract and save Cb LFP
                        LFPs2 = all_data.streams.LFP2.data;
                        Fs_lfp = all_data.streams.LFP2.fs;
                        save([origin_rootpath,animal,'/',param.LFP_path,'/',sbn(sub_block,:),'/LFP_Cb.mat'],'LFPs2','Fs_lfp','-v7.3');
                        
                        Wave1 = all_data.streams.Wav1.data;
                        Wave2 = all_data.streams.Wav2.data;
                        Wave3 = all_data.streams.Wav3.data;
                        Fs_wave = all_data.streams.Wav1.fs;
                        
                        save([origin_rootpath,animal,'/',param.Wave_path,'/',sbn(sub_block,:),'/WAV.mat'],'Wave1','Wave2','Wave3','Fs_wave');
                    end
                else
                    all_data = TDTbin2mat([origin_rootpath,animal,'/',sbn(sub_block,:)],'TYPE',4);
                    
                    % Extract and save wave channel
                    Wave1 = all_data.streams.Wav1.data;
                    Wave2 = all_data.streams.Wav2.data;
                    Fs_wave = all_data.streams.Wav1.fs;
                    save([origin_rootpath,animal,'/',sbn(sub_block,:),'/WAV.mat'],'Wave1','Wave2','Fs_wave');
                    
                    % Extract and save M1 LFP
                    LFPs1 = all_data.streams.LFP1.data;
                    Fs_lfp = all_data.streams.LFP1.fs; %#ok<NASGU>
                    save([origin_rootpath,animal,'/',sbn(sub_block,:),'/LFP_M1.mat'],'LFPs1','Fs_lfp','-v7.3');
                    
                    % Extract and save Cb LFP
                    LFPs2 = all_data.streams.LFP2.data;
                    Fs_lfp = all_data.streams.LFP2.fs;
                    save([origin_rootpath,animal,'/',sbn(sub_block,:),'/LFP_Cb.mat'],'LFPs2','Fs_lfp','-v7.3');
                    
                    clear all_data Wave1 Wave2 Fs_wave LFPs1 LFPs2 Fs_lfp
                end
            end
        end
    end
    rmpath(genpath('Z:\Matlab for analysis\TDTMatlabSDK\TDTSDK\TDTbin2mat'))
end

%% Create Duration Files (2)
if enabled(2)
    disp('Block 2...')
    for day=1:param.days
        durMAT = nan(5,size(cat(1,param.sleep_block_names{day,:}, param.training_block_names{day,:}),1));
        dM_idx = 0;
        for block=1:param.blocks
            if all([day,block] <= size(param.sleep_block_names))
                sbn = param.sleep_block_names{day, block};
                for sub_block = 1:size(sbn,1)
                    dM_idx = dM_idx + 1;
                    ssbn = sbn(sub_block,:);
                    if strcmp(animal, 'I076') || strcmp(animal, 'I086') || strcmp(animal, 'I089') ||  strcmp(animal, 'I096') ||  strcmp(animal, 'I107') ||  strcmp(animal, 'I110') || strcmp(animal, 'I122')
                        ssbn = [param.LFP_path,'/',ssbn]; %#ok<AGROW>
                    elseif strcmp(animal, 'I064')
                        ssbn = [param.LFP_path,'/',ssbn]; %#ok<AGROW>
                    end
                    %[lenLFP_M1, lenLFP_Cb] = get_LFP_length([origin_rootpath,animal,'/',ssbn]);
                    durMAT(1:2,dM_idx) = get_LFP_length([origin_rootpath,animal,'/',ssbn]);
                    
                    
                    if strcmp(animal, 'I086') && day == 4 && block ==1
                        durMAT(5,dM_idx) = 4200;
                    else
                        durMAT(5,dM_idx) = floor(min(durMAT(1:4,dM_idx)));
                    end
                end
            end
            if all([day,block] <= size(param.training_block_names))
                tbn = param.training_block_names{day, block};
                for sub_block = 1:size(tbn,1)
                    dM_idx = dM_idx + 1;
                    tsbn = tbn(sub_block,:);
                    if strcmp(animal, 'I076') || strcmp(animal, 'I086')  || strcmp(animal, 'I089') ||  strcmp(animal, 'I096') ||  strcmp(animal, 'I107') ||  strcmp(animal, 'I110') || strcmp(animal, 'I122')
                        tsbn = [param.LFP_path,'/',tsbn]; %#ok<AGROW>
                    elseif strcmp(animal, 'I064')
                        tsbn = [param.LFP_path,'/',tsbn]; %#ok<AGROW>
                    end
                    %[lenLFP_M1, lenLFP_Cb] = get_LFP_length([origin_rootpath,animal,'/',tsbn]);
                    
                    [M1L, CbL] = get_LFP_length([origin_rootpath,animal,'/',tsbn]);
                    durMAT(1:2,dM_idx) = [M1L; CbL];
                    durMAT(5,dM_idx) = floor(min(durMAT(1:4,dM_idx)));
                    
                end
            end
        end
        
        save([origin_rootpath,animal,'/',param.durFiles(day,:),'.mat'],'durMAT');
        clearvars -except code_rootpath day rootpath origin_rootpath animal param enabled;
    end 
    clear day
end

%% Identify Bad Channels (3)
%Displays the block LFP and prompts the user to enter an array
if enabled(3)
    disp('Block 3...')
    all_M1_bad_chans = [];
    all_Cb_bad_chans = [];
    for day=1:param.days
        for block=1:param.blocks
            tbn = param.training_block_names{day, block};
            for sub_block = 1:size(tbn,1)
                if strcmp(animal, 'I076') || strcmp(animal, 'I064') || strcmp(animal, 'I086') || strcmp(animal, 'I089') ||  strcmp(animal, 'I096') ||  strcmp(animal, 'I107') ||  strcmp(animal, 'I110') || strcmp(animal, 'I122')
                    load([origin_rootpath,animal,'/',param.LFP_path,'/',tbn(sub_block,:),'/LFP_M1.mat']);
                else
                    load([origin_rootpath,animal,'/',tbn(sub_block,:),'/LFP_M1.mat']);
                end
                param.M1_Fs = Fs_lfp;
                if strcmp(animal, 'I076') || strcmp(animal, 'I064') || strcmp(animal, 'I086') || strcmp(animal, 'I089') ||  strcmp(animal, 'I096') ||  strcmp(animal, 'I107') ||  strcmp(animal, 'I110') || strcmp(animal, 'I122')
                    load([origin_rootpath,animal,'/',param.LFP_path,'/',tbn(sub_block,:),'/LFP_Cb.mat']);
                else
                    load([origin_rootpath,animal,'/',tbn(sub_block,:),'/LFP_Cb.mat']);
                end
                param.Cb_Fs = Fs_lfp;
                
                hold on
                for c = 1:size(LFPs1,1)
                    plot(LFPs1(c,1:min(1000000,size(LFPs1,2)))+(c*0.001))
                end
                new_M1_bad_chans = input(['M1: Surround multiple bad channels with square brackets. Press return when done.' newline]);
                
                close all
                
                hold on
                for c = 1:size(LFPs2,1)
                    plot(LFPs2(c,1:min(1000000,size(LFPs2,2)))+(c*0.001))
                end
                new_Cb_bad_chans = input(['Cb: Surround multiple bad channels with square brackets. Press return when done.' newline]);
                
                hold off
                close all
                
                all_M1_bad_chans = [all_M1_bad_chans, new_M1_bad_chans]; %#ok<AGROW>
                all_Cb_bad_chans = [all_Cb_bad_chans, new_Cb_bad_chans]; %#ok<AGROW>
            end
        end
    end
    [ct, ch] = hist(all_M1_bad_chans,unique(all_M1_bad_chans));
    disp('M1: Surround the channels you wish to exclude with square brackets. Press return when done.')
    disp(ch)
    disp(ct)
    M1_bad_chans = sort(input(''));
    
    [ct, ch] = hist(all_Cb_bad_chans,unique(all_Cb_bad_chans));
    disp('Cb: Surround the channels you wish to exclude with square brackets. Press return when done.')
    disp(ch)
    disp(ct)
    Cb_bad_chans = sort(input(''));
    
    if ~exist([rootpath,animal],'dir')
        mkdir([rootpath,animal]);
    end
    
    param.M1_bad_chans = M1_bad_chans;
    param.M1_chans = size(LFPs1,1);
    good_chans = 1:param.M1_chans;
    good_chans(M1_bad_chans) = [];
    param.M1_good_chans = good_chans;
    
    param.Cb_bad_chans = Cb_bad_chans;
    param.Cb_chans = size(LFPs2,1);
    good_chans = 1:param.Cb_chans;
    good_chans(Cb_bad_chans) = [];
    param.Cb_good_chans = good_chans;
    
    save([rootpath,animal,'/Parameters.mat'],'param');
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Truncation (4)

if enabled(4)
    disp('Block 4...')
    for day=1:param.days
        if ~exist([rootpath,animal,'/Day',num2str(day)],'dir')
            mkdir([rootpath,animal,'/Day',num2str(day)]);
        end
        load([origin_rootpath,animal,'/',param.durFiles(day,:),'.mat']);
        dM_idx = 0;
        for block=1:size(param.s_block_names,2)
            if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.s_block_names{block}],'dir')
                mkdir([rootpath,animal,'/Day',num2str(day),'/',param.s_block_names{block}]);
            end
        end
        for block=1:param.blocks
            if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block}],'dir')
                mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block}]);
            end
            M1_LFP_t = nan(param.M1_chans,0);
            Cb_LFP_t = nan(param.Cb_chans,0);
            WAVE1_t = nan(1,0);
            WAVE2_t = nan(1,0);
            WAVE3_t = nan(1,0);

            if all([day,block] <= size(param.sleep_block_names))
                sbn = param.sleep_block_names{day, block};
                for sub_block = 1:size(sbn,1)
                    dM_idx = dM_idx + 1;
                    
%                 load([origin_rootpath,animal,'/',sbn(sub_block,:),'/LFP_M1.mat']);
%                 load([origin_rootpath,animal,'/',sbn(sub_block,:),'/LFP_Cb.mat']);
%                 load([origin_rootpath,animal,'/',sbn(sub_block,:),'/WAV.mat']);
%
%                 Fs = Fs_lfp;
%                 truncation_samp = round(durMAT(5,dM_idx)*Fs);
%
%                 M1_LFP_t = cat(2, M1_LFP_t, LFPs1(:,1:truncation_samp));
%                 Cb_LFP_t = cat(2, Cb_LFP_t, LFPs2(:,1:truncation_samp));
%                 WAVE1_t = cat(2, WAVE1_t, Wave1(1:truncation_samp));
%                 WAVE2_t = cat(2, WAVE2_t, Wave2(1:truncation_samp));
                end
                
%             save([rootpath,animal,'/Day',num2str(day),'/',block_names_sleep{block},'/LFP_M1_Truncated.mat'],'M1_LFP_t','Fs');
%             save([rootpath,animal,'/Day',num2str(day),'/',block_names_sleep{block},'/LFP_Cb_Truncated.mat'],'Cb_LFP_t','Fs');
%             save([rootpath,animal,'/Day',num2str(day),'/',block_names_sleep{block},'/WAV_Truncated.mat'],'WAVE1_t','WAVE2_t','Fs');
            end
            
            if all([day,block] <= size(param.training_block_names))
                tbn = param.training_block_names{day, block};
                for sub_block = 1:size(tbn,1)
                    dM_idx = dM_idx + 1;
                    
                    if strcmp(animal, 'I076') || strcmp(animal, 'I064') || strcmp(animal, 'I086') || strcmp(animal, 'I089') ||  strcmp(animal, 'I096') ||  strcmp(animal, 'I107') ||  strcmp(animal, 'I110') ||  strcmp(animal, 'I122')
                        load([origin_rootpath,animal,'/',param.LFP_path,'/',tbn(sub_block,:),'/LFP_M1.mat']);
                        load([origin_rootpath,animal,'/',param.LFP_path,'/',tbn(sub_block,:),'/LFP_Cb.mat']);
                        load([origin_rootpath,animal,'/',param.Wave_path,'/',tbn(sub_block,:),'/WAV.mat']);
                    else
                        load([origin_rootpath,animal,'/',tbn(sub_block,:),'/LFP_M1.mat']);
                        load([origin_rootpath,animal,'/',tbn(sub_block,:),'/LFP_Cb.mat']);
                        load([origin_rootpath,animal,'/',tbn(sub_block,:),'/WAV.mat']);
                    end
                    
                    
                    
                    M1_truncation_samp = floor(durMAT(5,dM_idx)*param.M1_Fs);
                    Cb_truncation_samp = floor(durMAT(5,dM_idx)*param.Cb_Fs);
                    param.Wave_Fs = Fs_wave;
                    Wave_truncation_samp = floor(durMAT(5,dM_idx)*param.Wave_Fs);
                    
                    if isempty(LFPs1)
                        M1_LFP_t = zeros(0,(size(M1_LFP_t,2)+M1_truncation_samp));
                    else
                        M1_LFP_t = cat(2, M1_LFP_t, LFPs1(:,1:M1_truncation_samp));
                    end
                    if isempty(LFPs2)
                        Cb_LFP_t = zeros(0,(size(Cb_LFP_t,2)+Cb_truncation_samp));
                    else
                        Cb_LFP_t = cat(2, Cb_LFP_t, LFPs2(:,1:Cb_truncation_samp));
                    end
                    
                    if length(WAVE1_t) < Wave_truncation_samp
                        Wave1(Wave_truncation_samp) = 0;
                        Wave2(Wave_truncation_samp) = 0;
                        if exist('Wave3','var')
                            Wave3(Wave_truncation_samp) = 0;
                        end
                    end
                    
                    WAVE1_t = cat(2, WAVE1_t, Wave1(1:Wave_truncation_samp));
                    WAVE2_t = cat(2, WAVE2_t, Wave2(1:Wave_truncation_samp));
                    if exist('Wave3','var')
                        WAVE3_t = cat(2, WAVE3_t, Wave3(1:Wave_truncation_samp));
                    end
                    
                end
                
                if strcmp(animal,'I061') && day == 4 && block == 2
                    M1_LFP_t = M1_LFP_t(:,floor(param.M1_Fs * 8 * 60):end);
                    Cb_LFP_t = Cb_LFP_t(:,floor(param.Cb_Fs * 8 * 60):end);
                    WAVE1_t = WAVE1_t(:,floor(param.Wave_Fs * 8 * 60):end);
                    WAVE2_t = WAVE2_t(:,floor(param.Wave_Fs * 8 * 60):end);
                end
                
                save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/LFP_M1_Truncated.mat'],'M1_LFP_t');
                save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/LFP_Cb_Truncated.mat'],'Cb_LFP_t');
                save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/WAV_Truncated.mat'],'WAVE1_t','WAVE2_t');
                if exist('Wave3','var')
                    save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/WAV_Truncated.mat'],'WAVE1_t','WAVE2_t','WAVE3_t');
                end
            end
            save([rootpath,animal,'/Parameters.mat'],'param');
            
            clearvars -except code_rootpath day block dM_idx durMAT rootpath origin_rootpath animal param enabled;
        end
    end
    clear day block dM_idx durMAT;
end

%% Swap WAVE files (4.1)
% This swaps the contents of the WAVE variables. This is nesissary if the
% wave channels were swapped durring recording. As it is not a regular part
% of analysis it cannot be enabled through the enabled variable. Wave1
% should be trial number. Wave2 should be door open and outcome. Wave3 (if
% it exists) should be camera frames.

if false
    beep %#ok<UNRCH> 
    warning('WAVE files are about to be swapped. Proceed? y/n')
    conf = input('','s');
    if strcmp(conf, 'y')    
        for day=1:param.days
            for block=1:param.blocks
                load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/WAV_Truncated.mat']);
                temp = WAVE1_t;
                WAVE1_t = WAVE3_t;
                WAVE3_t = WAVE2_t;
                WAVE2_t = temp;
                
                save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/WAV_Truncated.mat'],'WAVE1_t','WAVE2_t','WAVE3_t');
                clear temp;
            end
        end
    elseif strcmp(conf, 'n')
        disp('Aborting.')
    else
        disp('Unrecognised responce. Aborting.')
    end
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Alter WAVE files (4.2)
% This is for altering the contents of the WAVE variables. This is
% nesissary to correct errors durring recording such as inverted signals or
% mixxed signal due to cable shorts. As it is not a regular part of
% analysis it cannot be enabled through the enabled variable. Wave1 should
% be trial number. Wave2 should be door open and outcome. Wave3 (if it
% exists) should be camera frames.

if false
    beep %#ok<UNRCH> 
    warning('WAVE files are about to be altered. Proceed? y/n')
    conf = input('','s');
    if ~strcmp(conf, 'y') && ~strcmp(conf, 'n')
        disp('Unrecognised responce. Aborting.')
    end
    if strcmp(conf, 'y')
        for day=[2]
            for block=[2]
                load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/WAV_Truncated.mat']);
                WAVE1_t(1:300000) = 0;
                WAVE2_t(1:300000) = 0;
                WAVE3_t(1:300000) = 0;
                save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/WAV_Truncated.mat'],'WAVE1_t','WAVE2_t','WAVE3_t');
                clear temp;
            end
        end
    end
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end


%% Reach Time Coding (5)

if enabled(5)
    disp('Block 5...')
    load([rootpath,animal,'/Shared_Data.mat'])
    shared_data.GUI_data = cell(param.days, param.blocks);
    for day=1:param.days
        for block=1:param.blocks
            
            clear data;
            
            if exist([origin_rootpath,animal,'/Day',num2str(day),'/Reach_Vids/Results/D',num2str(day),param.codes_filename{block},'_GUI.mat'], 'file')
                load([origin_rootpath,animal,'/Day',num2str(day),'/Reach_Vids/Results/D',num2str(day),param.codes_filename{block},'_GUI.mat']);
            else
                warning('Original GUI data not found. Loading local copy.')
                load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            end
            trial_outcomes = cellfun(@str2double,data(:,3));
            if length(trial_outcomes(trial_outcomes < 2)) < 2 %minimum number of trials where the rat reaches for a pellet on the arm
                warning(['Too few reaches in day ', num2str(day), ', block ', num2str(block), '. Converting forcepts reaches to normal reaches.'])
                trial_outcomes(trial_outcomes>3) = trial_outcomes(trial_outcomes>3) - 4;
                data(:,3) = cellstr(num2str(trial_outcomes));
            end
            Oseconds = find_reach_times(data,param.WAV_video_offset,param.Camera_framerate);
            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat'],'data');
            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/reach_onset_delays.mat'],'Oseconds');
            
            shared_data.GUI_data{day,block} = data;
            
            clearvars -except code_rootpath day block rootpath origin_rootpath animal param enabled shared_data;
        end
    end
    save([rootpath,animal,'/Shared_Data.mat'], 'shared_data')
    clear day block shared_data;
end

%% Snapshot Extraction (6)

if enabled(6)
    disp('Block 6...')
    addpath(genpath('Z:\Matlab for analysis\eeglab\functions'))
    rmpath(genpath('Z:\Matlab for analysis\eeglab\functions\octavefunc\signal'))
    for day=1:param.days
        for block=1:param.blocks
                           
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/reach_onset_delays.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/LFP_M1_Truncated.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/LFP_Cb_Truncated.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/WAV_Truncated.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            
            [M1_snapshots_raw, Cb_snapshots_raw] = snapshot_extraction(M1_LFP_t, Cb_LFP_t, WAVE2_t, param.M1_Fs, param.Cb_Fs, param.Wave_Fs, Oseconds, data, 4, 4);
            
            if isempty(M1_LFP_t)
                M1_1_4_filt_LFP = M1_LFP_t;
                M1_3_6_filt_LFP = M1_LFP_t;
                M1_6_14_filt_LFP = M1_LFP_t;
            else
                M1_1_4_filt_LFP = eegfilt(M1_LFP_t, param.M1_Fs, 1, 4);
                M1_3_6_filt_LFP = eegfilt(M1_LFP_t, param.M1_Fs, 3, 6);
                M1_6_14_filt_LFP = eegfilt(M1_LFP_t, param.M1_Fs, 6, 14);
            end
            if isempty(Cb_LFP_t)
                Cb_1_4_filt_LFP = Cb_LFP_t;
                Cb_3_6_filt_LFP = Cb_LFP_t;
                Cb_6_14_filt_LFP = Cb_LFP_t;
            else
                Cb_1_4_filt_LFP = eegfilt(Cb_LFP_t, param.Cb_Fs, 1, 4);
                Cb_3_6_filt_LFP = eegfilt(Cb_LFP_t, param.Cb_Fs, 3, 6);
                Cb_6_14_filt_LFP = eegfilt(Cb_LFP_t, param.Cb_Fs, 6, 14);
            end
            
            [M1_1_4_snapshots_raw, Cb_1_4_snapshots_raw] = snapshot_extraction(M1_1_4_filt_LFP, Cb_1_4_filt_LFP, WAVE2_t, param.M1_Fs, param.Cb_Fs, param.Wave_Fs, Oseconds, data, 4, 4);
            [M1_3_6_snapshots_raw, Cb_3_6_snapshots_raw] = snapshot_extraction(M1_3_6_filt_LFP, Cb_3_6_filt_LFP, WAVE2_t, param.M1_Fs, param.Cb_Fs, param.Wave_Fs, Oseconds, data, 4, 4);
            [M1_6_14_snapshots_raw, Cb_6_14_snapshots_raw] = snapshot_extraction(M1_6_14_filt_LFP, Cb_6_14_filt_LFP, WAVE2_t, param.M1_Fs, param.Cb_Fs, param.Wave_Fs, Oseconds, data, 4, 4);
            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/LFP_Snapshots.mat'],'M1_snapshots_raw','Cb_snapshots_raw','M1_1_4_snapshots_raw', 'Cb_1_4_snapshots_raw','M1_3_6_snapshots_raw', 'Cb_3_6_snapshots_raw','M1_6_14_snapshots_raw', 'Cb_6_14_snapshots_raw');
            
            clearvars -except code_rootpath day block rootpath origin_rootpath animal param enabled;
        end
    end
    rmpath(genpath('Z:\Matlab for analysis\eeglab\functions'))
    clear day block;
end

%% Modify Bad Channels (6.9)

if false
    disp('M1: Surround the channels you wish to exclude with square brackets. Press return when done.')
    M1_bad_chans = sort(input(''));
    
    disp('Cb: Surround the channels you wish to exclude with square brackets. Press return when done.')
    Cb_bad_chans = sort(input(''));
    
    if ~exist([rootpath,animal],'dir')
        mkdir([rootpath,animal]);
    end
    
    param.M1_bad_chans = M1_bad_chans;
    good_chans = 1:param.M1_chans;
    good_chans(M1_bad_chans) = [];
    param.M1_good_chans = good_chans;
    
    param.Cb_bad_chans = Cb_bad_chans;
    good_chans = 1:param.Cb_chans;
    good_chans(Cb_bad_chans) = [];
    param.Cb_good_chans = good_chans;
    
    save([rootpath,animal,'/Parameters.mat'],'param');
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Identify Bad Trials (7)
        
if enabled(7)
    disp('Block 7...')
    for day=1:param.days
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/LFP_Snapshots.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/reach_onset_delays.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            
            outcomes = cellfun(@str2num,data(:,3));
            bad_outcome_trials = 1:size(data,1);
            bad_outcome_trials(outcomes == 1 | outcomes == 0) = [];
            
            if isempty(M1_snapshots_raw)
                M1_bad_trials = bad_outcome_trials;
            else
                M1_bad_trials=visualizeTrialData(M1_snapshots_raw,param.M1_bad_chans,outcomes);
                M1_bad_trials = sort([M1_bad_trials, bad_outcome_trials]);
            end
            if isempty(Cb_snapshots_raw)
                Cb_bad_trials = bad_outcome_trials;
            else
                Cb_bad_trials=visualizeTrialData(Cb_snapshots_raw,param.Cb_bad_chans,outcomes);
                Cb_bad_trials = sort([Cb_bad_trials, bad_outcome_trials]);
            end
            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat'],'M1_bad_trials','Cb_bad_trials');
            
            clearvars -except code_rootpath day block rootpath origin_rootpath animal param enabled;
        end
    end
    clear day block;
end

%% Normalize Good Data (8)

if enabled(8)
    disp('Block 8...')
    M1_block_lengths = zeros(size(param.block_names));
    Cb_block_lengths = zeros(size(param.block_names));
    all_M1_snapshots = [];
    all_Cb_snapshots = [];
    all_M1_1_4_snapshots = [];
    all_Cb_1_4_snapshots = [];
    all_M1_3_6_snapshots = [];
    all_Cb_3_6_snapshots = [];
    all_M1_6_14_snapshots = [];
    all_Cb_6_14_snapshots = [];
    for day=1:param.days
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/LFP_Snapshots.mat']);
            
            M1_snapshots_raw(param.M1_bad_chans,:,:)=[];
            M1_snapshots_raw(:,:,M1_bad_trials)=[];
            Cb_snapshots_raw(param.Cb_bad_chans,:,:)=[];
            Cb_snapshots_raw(:,:,Cb_bad_trials)=[];
            
            M1_block_lengths(day, block) = size(M1_snapshots_raw, 3);
            Cb_block_lengths(day, block) = size(Cb_snapshots_raw, 3);
            
            all_M1_snapshots = cat(3,all_M1_snapshots,M1_snapshots_raw);
            all_Cb_snapshots = cat(3,all_Cb_snapshots,Cb_snapshots_raw);
            
            M1_1_4_snapshots_raw(param.M1_bad_chans,:,:) = []; 
            M1_3_6_snapshots_raw(param.M1_bad_chans,:,:) = []; 
            M1_6_14_snapshots_raw(param.M1_bad_chans,:,:) = []; 
            Cb_1_4_snapshots_raw(param.Cb_bad_chans,:,:) = []; 
            Cb_3_6_snapshots_raw(param.Cb_bad_chans,:,:) = []; 
            Cb_6_14_snapshots_raw(param.Cb_bad_chans,:,:) = []; 
            
            M1_1_4_snapshots_raw(:,:,M1_bad_trials) = []; 
            M1_3_6_snapshots_raw(:,:,M1_bad_trials) = []; 
            M1_6_14_snapshots_raw(:,:,M1_bad_trials) = []; 
            Cb_1_4_snapshots_raw(:,:,Cb_bad_trials) = []; 
            Cb_3_6_snapshots_raw(:,:,Cb_bad_trials) = []; 
            Cb_6_14_snapshots_raw(:,:,Cb_bad_trials) = []; 
            
            all_M1_1_4_snapshots = cat(3,all_M1_1_4_snapshots,M1_1_4_snapshots_raw);
            all_Cb_1_4_snapshots = cat(3,all_Cb_1_4_snapshots,Cb_1_4_snapshots_raw);
            all_M1_3_6_snapshots = cat(3,all_M1_3_6_snapshots,M1_3_6_snapshots_raw);
            all_Cb_3_6_snapshots = cat(3,all_Cb_3_6_snapshots,Cb_3_6_snapshots_raw);
            all_M1_6_14_snapshots = cat(3,all_M1_6_14_snapshots,M1_6_14_snapshots_raw);
            all_Cb_6_14_snapshots = cat(3,all_Cb_6_14_snapshots,Cb_6_14_snapshots_raw);
            
%             M1_1_4_snapshots = M1_1_4_snapshots_raw;
%             M1_3_6_snapshots = M1_3_6_snapshots_raw;
%             M1_6_14_snapshots = M1_6_14_snapshots_raw;
%             Cb_1_4_snapshots = Cb_1_4_snapshots_raw;
%             Cb_3_6_snapshots = Cb_3_6_snapshots_raw;
%             Cb_6_14_snapshots = Cb_6_14_snapshots_raw;
%             
%             save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Filtered_LFP_Snapshots.mat'],'M1_1_4_snapshots', 'Cb_1_4_snapshots','M1_3_6_snapshots', 'Cb_3_6_snapshots','M1_6_14_snapshots', 'Cb_6_14_snapshots');
        end
    end
    
    [all_M1_snapshots_n, all_M1_snapshots_c] = normalize(all_M1_snapshots);
    [all_Cb_snapshots_n, all_Cb_snapshots_c] = normalize(all_Cb_snapshots);
    [all_M1_1_4_snapshots_n, all_M1_1_4_snapshots_c] = normalize(all_M1_1_4_snapshots);
    [all_Cb_1_4_snapshots_n, all_Cb_1_4_snapshots_c] = normalize(all_Cb_1_4_snapshots);
    [all_M1_3_6_snapshots_n, all_M1_3_6_snapshots_c] = normalize(all_M1_3_6_snapshots);
    [all_Cb_3_6_snapshots_n, all_Cb_3_6_snapshots_c] = normalize(all_Cb_3_6_snapshots);
    [all_M1_6_14_snapshots_n, all_M1_6_14_snapshots_c] = normalize(all_M1_6_14_snapshots);
    [all_Cb_6_14_snapshots_n, all_Cb_6_14_snapshots_c] = normalize(all_Cb_6_14_snapshots);
    
    for day=1:param.days
        for block=1:param.blocks
            M1_snapshots_n = all_M1_snapshots_n(:,:,1:M1_block_lengths(day, block));
            all_M1_snapshots_n(:,:,1:M1_block_lengths(day, block)) = [];
            M1_snapshots_c = all_M1_snapshots_c(:,:,1:M1_block_lengths(day, block));
            all_M1_snapshots_c(:,:,1:M1_block_lengths(day, block)) = [];
            
            Cb_snapshots_n = all_Cb_snapshots_n(:,:,1:Cb_block_lengths(day, block));
            all_Cb_snapshots_n(:,:,1:Cb_block_lengths(day, block)) = [];
            Cb_snapshots_c = all_Cb_snapshots_c(:,:,1:Cb_block_lengths(day, block));
            all_Cb_snapshots_c(:,:,1:Cb_block_lengths(day, block)) = [];
            
            M1_1_4_snapshots_n = all_M1_1_4_snapshots_n(:,:,1:M1_block_lengths(day, block));
            all_M1_1_4_snapshots_n(:,:,1:M1_block_lengths(day, block)) = [];
            M1_1_4_snapshots = all_M1_1_4_snapshots_c(:,:,1:M1_block_lengths(day, block));
            all_M1_1_4_snapshots_c(:,:,1:M1_block_lengths(day, block)) = [];
            
            Cb_1_4_snapshots_n = all_Cb_1_4_snapshots_n(:,:,1:Cb_block_lengths(day, block));
            all_Cb_1_4_snapshots_n(:,:,1:Cb_block_lengths(day, block)) = [];
            Cb_1_4_snapshots = all_Cb_1_4_snapshots_c(:,:,1:Cb_block_lengths(day, block));
            all_Cb_1_4_snapshots_c(:,:,1:Cb_block_lengths(day, block)) = [];
            
            M1_3_6_snapshots_n = all_M1_3_6_snapshots_n(:,:,1:M1_block_lengths(day, block));
            all_M1_3_6_snapshots_n(:,:,1:M1_block_lengths(day, block)) = [];
            M1_3_6_snapshots = all_M1_3_6_snapshots_c(:,:,1:M1_block_lengths(day, block));
            all_M1_3_6_snapshots_c(:,:,1:M1_block_lengths(day, block)) = [];
            
            Cb_3_6_snapshots_n = all_Cb_3_6_snapshots_n(:,:,1:Cb_block_lengths(day, block));
            all_Cb_3_6_snapshots_n(:,:,1:Cb_block_lengths(day, block)) = [];
            Cb_3_6_snapshots = all_Cb_3_6_snapshots_c(:,:,1:Cb_block_lengths(day, block));
            all_Cb_3_6_snapshots_c(:,:,1:Cb_block_lengths(day, block)) = [];
            
            M1_6_14_snapshots_n = all_M1_6_14_snapshots_n(:,:,1:M1_block_lengths(day, block));
            all_M1_6_14_snapshots_n(:,:,1:M1_block_lengths(day, block)) = [];
            M1_6_14_snapshots = all_M1_6_14_snapshots_c(:,:,1:M1_block_lengths(day, block));
            all_M1_6_14_snapshots_c(:,:,1:M1_block_lengths(day, block)) = [];
            
            Cb_6_14_snapshots_n = all_Cb_6_14_snapshots_n(:,:,1:Cb_block_lengths(day, block));
            all_Cb_6_14_snapshots_n(:,:,1:Cb_block_lengths(day, block)) = [];
            Cb_6_14_snapshots = all_Cb_6_14_snapshots_c(:,:,1:Cb_block_lengths(day, block));
            all_Cb_6_14_snapshots_c(:,:,1:Cb_block_lengths(day, block)) = [];
            
            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Normalized_full_Snapshots.mat'],'M1_snapshots_n','Cb_snapshots_n','M1_snapshots_c','Cb_snapshots_c');
            
            M1_snapshots = M1_snapshots_c;
            Cb_snapshots = Cb_snapshots_c;
            
            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Normalized_Snapshots.mat'],'M1_snapshots','Cb_snapshots');
            
            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Filtered_LFP_Snapshots.mat'],'M1_1_4_snapshots', 'Cb_1_4_snapshots','M1_3_6_snapshots', 'Cb_3_6_snapshots','M1_6_14_snapshots', 'Cb_6_14_snapshots');
            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Filtered_LFP_full_Snapshots.mat'],'M1_1_4_snapshots', 'Cb_1_4_snapshots','M1_3_6_snapshots', 'Cb_3_6_snapshots','M1_6_14_snapshots', 'Cb_6_14_snapshots', 'M1_1_4_snapshots_n', 'Cb_1_4_snapshots_n','M1_3_6_snapshots_n', 'Cb_3_6_snapshots_n','M1_6_14_snapshots_n', 'Cb_6_14_snapshots_n');
        end
    end
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Record number of good trials(9)

if enabled(9)
    load([rootpath,animal,'/Shared_Data.mat'])
    shared_data.M1_reach_trial_num = nan(param.days,param.blocks);
    shared_data.Cb_reach_trial_num = nan(param.days,param.blocks);
    shared_data.M1_Cb_reach_trial_num = nan(param.days,param.blocks);
    for day=1:param.days
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat'])
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            all_bad_trials = union(M1_bad_trials, Cb_bad_trials);
            shared_data.M1_reach_trial_num(day,block) = size(data,1) - length(M1_bad_trials);
            shared_data.Cb_reach_trial_num(day,block) = size(data,1) - length(Cb_bad_trials);
            shared_data.M1_Cb_reach_trial_num(day,block) = size(data,1) - length(all_bad_trials);
        end
    end
    save([rootpath,animal,'/Shared_Data.mat'], 'shared_data')
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

% %% Recenter Snapshots (10)
% 
% if enabled(10)
%     tag2 = '';
%     if auditory_evoked_response_removal
%         tag2 = [tag2 '_AER']; %#ok<UNRCH> Depending on the evoked response removal settings tag2 may remain empty. This is the intended behavior.
%     end
%     for day=1:param.days
%         for block=1:param.blocks
%             
%             load([rootpath,animal,'/Day',num2str(day),'/',block_names{block},'/reach_onset_delays.mat']);
%             load([rootpath,animal,'/Day',num2str(day),'/',block_names{block},'/Normalized_full_Snapshots', tag2, '.mat']);
%             load([rootpath,animal,'/Day',num2str(day),'/',block_names{block},'/Bad_trials.mat']);
%             
%             M1_Oseconds = Oseconds;
%             Cb_Oseconds = Oseconds;
%             M1_Oseconds(M1_bad_trials)=[];
%             Cb_Oseconds(Cb_bad_trials)=[];
%             
%             [M1_channels, M1_ticks, M1_trials] = size(M1_snapshots_c);
%             [Cb_channels, Cb_ticks, Cb_trials] = size(Cb_snapshots_c);
%             M1_snapshots = zeros(M1_channels, round(8*Fs)+1, M1_trials);
%             Cb_snapshots = zeros(Cb_channels, round(8*Fs)+1, Cb_trials);
%             
%             for trial=1:M1_trials
%                 M1_snapshots(:,:,trial) = M1_snapshots_c(:,round(M1_Oseconds(trial) * Fs):(round(M1_Oseconds(trial) * Fs) + round(8 * Fs)),trial);
%             end
%             for trial=1:Cb_trials
%                 Cb_snapshots(:,:,trial) = Cb_snapshots_c(:,round(Cb_Oseconds(trial) * Fs):(round(Cb_Oseconds(trial) * Fs) + round(8 * Fs)),trial);
%             end
%             
%             save([rootpath,animal,'/Day',num2str(day),'/',block_names{block},'/Normalized_Snapshots', tag2, '.mat'], 'M1_snapshots', 'Cb_snapshots', 'Fs');
%             
%             clearvars -except code_rootpath tag2 tag rootpath origin_rootpath animal block_names training_block_names sleep_block_names day days block blocks durFiles enabled param auditory_evoked_response_removal motor_evoked_response_removal codes_filename;
%         end
%     end
%     clear day block tag2;
% end
% 
% %% Correct Motor Evoked Response (11)
% 
% if enabled(11)
%     tag2 = '';
%     if auditory_evoked_response_removal
%         tag2 = [tag2 '_AER']; %#ok<UNRCH> Depending on the evoked response removal settings tag2 may remain empty. This is the intended behavior.
%     end
%     for day=1:param.days
%         for block=1:param.blocks
%             load([rootpath,animal,'/Day',num2str(day),'/',block_names{block},'/Normalized_Snapshots', tag2, '.mat']);
%             
%             M1_snapshots = evoked_response_removal(M1_snapshots);
%             Cb_snapshots = evoked_response_removal(Cb_snapshots);
%             save([rootpath,animal,'/Day',num2str(day),'/',block_names{block},'/Normalized_Snapshots', tag2, '_MER.mat'], 'M1_snapshots', 'Cb_snapshots', 'Fs');
%             
%             clearvars -except code_rootpath tag2 tag rootpath origin_rootpath animal block_names training_block_names sleep_block_names day days block blocks durFiles enabled param auditory_evoked_response_removal motor_evoked_response_removal codes_filename;
%         end
%     end
%     clear day block tag2;
% end

%% ERSP and ITC Calculation (12)
        
if enabled(12)
    disp('Block 12...')
    addpath(genpath('Z:\Matlab for analysis\eeglab\functions'))
    for day=1:param.days
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Normalized_Snapshots', '.mat']);
            
            [M1_ersp_data, M1_itc_data, M1_times, M1_freqs] = ersp_calc(M1_snapshots, param.M1_Fs);
            [Cb_ersp_data, Cb_itc_data, Cb_times, Cb_freqs] = ersp_calc(Cb_snapshots, param.Cb_Fs);
            
            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/ERSP_reach', '.mat'],'M1_ersp_data','Cb_ersp_data','M1_times', 'M1_freqs','Cb_times', 'Cb_freqs', '-v7.3')
            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/ITC_reach', '.mat'],'M1_itc_data','Cb_itc_data','M1_times', 'M1_freqs','Cb_times', 'Cb_freqs', '-v7.3')
            
            clearvars -except code_rootpath day block rootpath origin_rootpath animal param enabled M1_times M1_freqs Cb_times Cb_freqs;
        end
    end
    rmpath(genpath('Z:\Matlab for analysis\eeglab\functions'))
    clear day block M1_times M1_freqs Cb_times Cb_freqs;
end

%% Create ERSP Heatmaps and Bar Graphs (13)

if enabled(13)
    disp('Block 13...')
    freq_range = [1.5 4];  %in hz
    time_range = [-250 750]; %in ms
    day_M1_means = zeros(1,param.days);
    day_Cb_means = zeros(1,param.days);
    day_M1_err = zeros(1,param.days);
    day_Cb_err = zeros(1,param.days);
    days_to_plot = [1 5];
    power_inc_thresh = 0.5;
    
    M1_day_ch_means = cell(1, param.days);
    Cb_day_ch_means = cell(1, param.days);
    for day=1:param.days
        day_M1_ersp = [];
        day_Cb_ersp = [];
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/ERSP_reach', '.mat']);
            
            %M1_heatmap = create_power_heatmap((M1_ersp_data .* conj(M1_ersp_data)), times, freqs);
            M1_heatmap = create_power_heatmap(abs(M1_ersp_data), M1_times, M1_freqs);
            saveas(M1_heatmap, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/M1_power_heatmap', '.fig'])
            close all
            
            %Cb_heatmap = create_power_heatmap((Cb_ersp_data .* conj(Cb_ersp_data)), times, freqs);
            Cb_heatmap = create_power_heatmap(abs(Cb_ersp_data), Cb_times, Cb_freqs);
            saveas(Cb_heatmap, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Cb_power_heatmap', '.fig'])
            close all
            
            %real_data = M1_ersp_data .* conj(M1_ersp_data);
            real_data = abs(M1_ersp_data);
            data_mean = mean(real_data(:,:,M1_times>-1500&M1_times<-500,:),3);
            data_std = std(real_data(:,:,M1_times>-1500&M1_times<-500,:),[],3);
            zs_data = (real_data-data_mean) ./ data_std;
            day_M1_ersp = cat(4, day_M1_ersp, zs_data(:,(M1_freqs>=freq_range(1)) & (M1_freqs<=freq_range(2)),(M1_times>=time_range(1)) & (M1_times<=time_range(2)),:));
            
            %real_data = Cb_ersp_data .* conj(Cb_ersp_data);
            real_data = abs(Cb_ersp_data);
            data_mean = mean(real_data(:,:,Cb_times>-1500&Cb_times<-500,:),3);
            data_std = std(real_data(:,:,Cb_times>-1500&Cb_times<-500,:),[],3);
            zs_data = (real_data-data_mean) ./ data_std;
            day_Cb_ersp = cat(4, day_Cb_ersp, zs_data(:,(Cb_freqs>=freq_range(1)) & (Cb_freqs<=freq_range(2)),(Cb_times>=time_range(1)) & (Cb_times<=time_range(2)),:));
            
            clear M1_heatmap Cb_heatmap M1_ersp_data Cb_ersp_data times freqs;
        end
        M1_day_ch_means{day} = squeeze(mean(mean(day_M1_ersp,3),2));
        Cb_day_ch_means{day} = squeeze(mean(mean(day_Cb_ersp,3),2));
        
        day_M1_means(day) = mean(day_M1_ersp(:));
        day_Cb_means(day) = mean(day_Cb_ersp(:));
        day_M1_err(day) = std(mean(mean(mean(day_M1_ersp,4),3),2))/sqrt(size(day_M1_ersp,1));
        day_Cb_err(day) = std(mean(mean(mean(day_Cb_ersp,4),3),2))/sqrt(size(day_Cb_ersp,1));
        close all;
        clear day_M1_ersp day_Cb_ersp;
    end
    
    bar(days_to_plot, day_M1_means(days_to_plot));
    hold on
    er = errorbar(days_to_plot, day_M1_means(days_to_plot), day_M1_err(days_to_plot), day_M1_err(days_to_plot));
    er.Color = [0 0 0];                            
    er.LineStyle = 'none';
    saveas(gcf, [rootpath,animal,'/M1_power_changes.fig']);
    hold off
    close all;
    
    bar(days_to_plot, day_Cb_means(days_to_plot));
    hold on
    er = errorbar(days_to_plot, day_Cb_means(days_to_plot), day_Cb_err(days_to_plot), day_Cb_err(days_to_plot));
    er.Color = [0 0 0];                            
    er.LineStyle = 'none';
    saveas(gcf, [rootpath,animal,'/Cb_power_changes.fig']);
    hold off
    close all;
    
    param.M1_increasing_power_channels = param.M1_good_chans((mean(M1_day_ch_means{param.days},2) - mean(M1_day_ch_means{1},2)) >= power_inc_thresh);
    param.Cb_increasing_power_channels = param.Cb_good_chans((mean(Cb_day_ch_means{param.days},2) - mean(Cb_day_ch_means{1},2)) >= power_inc_thresh);
    save([rootpath,animal,'/Parameters.mat'],'param');
    
    load([rootpath,animal,'/Shared_Data.mat'])
    shared_data.M1_day_spectral_power = M1_day_ch_means;
    shared_data.Cb_day_spectral_power = Cb_day_ch_means;
    save([rootpath,animal,'/Shared_Data.mat'], 'shared_data')
    
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Plot Average Success and Fail LFP (14)

if enabled(14)
    disp('Block 14...')
    for day=1:param.days
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Normalized_Snapshots', '.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Filtered_LFP_Snapshots.mat']); %M1_1_4_snapshots
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat']);
            
            [M1_succ_snapshots, M1_fail_snapshots] = success_fail_split(M1_snapshots, data, M1_bad_trials, 3);
            [Cb_succ_snapshots, Cb_fail_snapshots] = success_fail_split(Cb_snapshots, data, Cb_bad_trials, 3);
            [M1_succ_filt, M1_fail_filt] = success_fail_split(M1_1_4_snapshots, data, M1_bad_trials, 3);
            [Cb_succ_filt, Cb_fail_filt] = success_fail_split(Cb_1_4_snapshots, data, Cb_bad_trials, 3);
            
            x_axis = round(-4 * param.M1_Fs):round(4 * param.M1_Fs);
            if isempty(M1_succ_snapshots)
                disp(['Day: ', num2str(day), ', Block: ', num2str(block), ' - No successful M1 trials'])
            elseif isempty(M1_fail_snapshots)
                disp(['Day: ', num2str(day), ', Block: ', num2str(block), ' - No failure M1 trials'])
            else
                M1_ave_succ_snapshots = mean(mean(M1_succ_snapshots, 1), 3);
                M1_ave_fail_snapshots = mean(mean(M1_fail_snapshots, 1), 3);
                M1_succ_snapshots_filt = mean(mean(M1_succ_filt, 1), 3);
                M1_fail_snapshots_filt = mean(mean(M1_fail_filt, 1), 3);
                [M1_succ_snapshots_filt, ~] = normalize(M1_succ_snapshots_filt);
                [M1_fail_snapshots_filt, ~] = normalize(M1_fail_snapshots_filt);
                plot(x_axis,M1_succ_snapshots_filt,x_axis,M1_fail_snapshots_filt)
                legend('Successes','Failures')
                axis([-750 750 -3 3])
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/M1_Ave_LFP', '.fig'])
                close all
            end
            
            x_axis = round(-4 * param.Cb_Fs):round(4 * param.Cb_Fs);
            if isempty(Cb_succ_snapshots)
                disp(['Day: ', num2str(day), ', Block: ', num2str(block), ' - No successful Cb trials'])
            elseif isempty(Cb_fail_snapshots)
                disp(['Day: ', num2str(day), ', Block: ', num2str(block), ' - No failure Cb trials'])
            else
                Cb_ave_succ_snapshots = mean(mean(Cb_succ_snapshots, 1), 3);
                Cb_ave_fail_snapshots = mean(mean(Cb_fail_snapshots, 1), 3);
                Cb_succ_snapshots_filt = mean(mean(Cb_succ_filt, 1), 3);
                Cb_fail_snapshots_filt = mean(mean(Cb_fail_filt, 1), 3);
                [Cb_succ_snapshots_filt, ~] = normalize(Cb_succ_snapshots_filt);
                [Cb_fail_snapshots_filt, ~] = normalize(Cb_fail_snapshots_filt);
                plot(x_axis,Cb_succ_snapshots_filt,x_axis,Cb_fail_snapshots_filt)
                legend('Successes','Failures')
                axis([-750 750 -3 3])
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Cb_Ave_LFP', '.fig'])
                close all
            end
            
            clearvars -except code_rootpath day block rootpath origin_rootpath animal param enabled;
        end
    end
    clear day block;
end

%% Individual Channel ERSP Heatmaps (15)

if enabled(15)
    disp('Block 15...')
    for day=1:param.days
        M1_day_ersp_data = [];
        Cb_day_ersp_data = [];
        for block=1:param.blocks
            
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/ERSP_reach', '.mat']);
            M1_day_ersp_data = cat(4, M1_day_ersp_data, M1_ersp_data);
            Cb_day_ersp_data = cat(4, Cb_day_ersp_data, Cb_ersp_data);
            
        end
        if param.M1_chans == 0
            M1_channels_heatmap = create_channel_power_heatmap(M1_day_ersp_data, M1_times, M1_freqs, 'empty', param.M1_bad_chans);
        else
            M1_channels_heatmap = create_channel_power_heatmap(M1_day_ersp_data, M1_times, M1_freqs, 'M1', param.M1_bad_chans);
        end
        for a = 1:length(M1_channels_heatmap.Children)
            M1_channels_heatmap.Children(a);
            caxis([0 1.5]);
        end
        saveas(M1_channels_heatmap, [rootpath,animal,'/Day',num2str(day),'/M1_channels_power_heatmaps', '.fig']);
        close all
        if param.Cb_chans == 0
            Cb_channels_heatmap = create_channel_power_heatmap(Cb_day_ersp_data, Cb_times, Cb_freqs, 'empty', param.Cb_bad_chans);
        elseif param.Cb_chans == 32
            Cb_channels_heatmap = create_channel_power_heatmap(Cb_day_ersp_data, Cb_times, Cb_freqs, 'Cb', param.Cb_bad_chans);
        elseif param.Cb_chans == 64
            Cb_channels_heatmap = create_channel_power_heatmap(Cb_day_ersp_data, Cb_times, Cb_freqs, 'Cb_poly', param.Cb_bad_chans);
        end
        for a = 1:length(Cb_channels_heatmap.Children)
            Cb_channels_heatmap.Children(a);
            caxis([0 1.5]);
        end
        saveas(Cb_channels_heatmap, [rootpath,animal,'/Day',num2str(day),'/Cb_channels_power_heatmaps', '.fig']);
        close all
        
        clearvars -except code_rootpath day rootpath origin_rootpath animal param enabled;

    end
    clear day;
end

%% Create Specific Channel ERSP Heatmaps (16)

if enabled(16)
    disp('Block 16...')
    M1_channels_of_interest = [20]; %17, 8, 11 
    Cb_channels_of_interest = [45];
    for day=1:param.days
        M1_day_ersp_data = [];
        Cb_day_ersp_data = [];
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/ERSP_reach', '.mat']);
            
            M1_day_ersp_data = cat(4, M1_day_ersp_data, M1_ersp_data);
            Cb_day_ersp_data = cat(4, Cb_day_ersp_data, Cb_ersp_data);
        end
        for M1_channel_num = find(ismembaer(param.M1_good_chans,M1_channels_of_interest))
            %M1_channel_heatmap = create_power_heatmap((M1_day_ersp_data(M1_channel_num,:,:,:) .* conj(M1_day_ersp_data(M1_channel_num,:,:,:))), times, freqs);
            M1_channel_heatmap = create_power_heatmap(abs(M1_day_ersp_data(M1_channel_num,:,:,:)), M1_times, M1_freqs);
            saveas(M1_channel_heatmap, [rootpath,animal,'/Day',num2str(day),'/M1_channel_', num2str(param.M1_good_chans(M1_channel_num)), '_full_day_power_heatmaps', '.fig']);
            close all
        end
        for Cb_channel_num = find(ismember(param.Cb_good_chans,Cb_channels_of_interest))
            %Cb_channel_heatmap = create_power_heatmap((Cb_day_ersp_data(Cb_channel_num,:,:,:) .* conj(Cb_day_ersp_data(Cb_channel_num,:,:,:))), times, freqs);
            Cb_channel_heatmap = create_power_heatmap(abs(Cb_day_ersp_data(Cb_channel_num,:,:,:)), Cb_times, Cb_freqs);
            caxis([0 10])
            saveas(Cb_channel_heatmap, [rootpath,animal,'/Day',num2str(day),'/Cb_channel_', num2str(param.Cb_good_chans(Cb_channel_num)), '_full_day_power_heatmaps', '.fig']);
            close all
        end
        
        clearvars -except code_rootpath rootpath origin_rootpath animal param enabled day M1_channels_of_interest Cb_channels_of_interest;
    end
    clear day M1_channels_of_interest Cb_channels_of_interest;
end

%% Plot Success Rate (17)

if enabled(17)
    disp('Block 17...')
    success_rate = [];
    day_starts = zeros(1,param.days);
    day_succ_rate = zeros(2,param.days);

    for day=1:param.days
        day_starts(day) = length(success_rate)+1;
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            trial_codes = str2double(data(:,3));
            trial_results = trial_codes(trial_codes < 2);
            trial_results = trial_results==1;
            success_rate = [success_rate; trial_results]; %#ok<AGROW>
        end
        day_succ_rate(1,day) = sum(success_rate(day_starts(day):end));
        day_succ_rate(2,day) = 1+length(success_rate)-day_starts(day);
    end
    success_rate = smooth(success_rate,60);
    plot(1:length(success_rate), success_rate, 'g-')
    for i = 1:param.days
        line([day_starts(i) day_starts(i)], [0 1], 'Color', 'yellow', 'LineStyle', '--')
    end
    

    shared_data.day_success_rate = day_succ_rate;
    save([rootpath,animal,'/Shared_Data.mat'], 'shared_data')

    saveas(gcf, [rootpath,animal,'/success_rate.fig']);
    close all;
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Create Success vs. Fail Heatmaps (18)

if enabled(18)
    disp('Block 18...')
    freq_range = [1.5 4];  %in hz
    time_range = [-250 750]; %in ms
    M1_day_ch_succ_means = cell(1,param.days);
    M1_day_ch_fail_means = cell(1,param.days);
    Cb_day_ch_succ_means = cell(1,param.days);
    Cb_day_ch_fail_means = cell(1,param.days);
    for day=1:param.days
        day_M1_succ_ersp = [];
        day_M1_fail_ersp = [];
        day_Cb_succ_ersp = [];
        day_Cb_fail_ersp = [];
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/ERSP_reach', '.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat']);
            
            [M1_succ_ersp, M1_fail_ersp] = success_fail_split(M1_ersp_data, data, M1_bad_trials, 4);
            [Cb_succ_ersp, Cb_fail_ersp] = success_fail_split(Cb_ersp_data, data, Cb_bad_trials, 4);
            
            real_data = abs(M1_succ_ersp);
            data_mean = mean(real_data(:,:,M1_times>-1500&M1_times<-500,:),3);
            data_std = std(real_data(:,:,M1_times>-1500&M1_times<-500,:),[],3);
            zs_data = (real_data-data_mean) ./ data_std;
            day_M1_succ_ersp = cat(4, day_M1_succ_ersp, zs_data(:,(M1_freqs>=freq_range(1)) & (M1_freqs<=freq_range(2)),(M1_times>=time_range(1)) & (M1_times<=time_range(2)),:));
            
            real_data = abs(M1_fail_ersp);
            data_mean = mean(real_data(:,:,M1_times>-1500&M1_times<-500,:),3);
            data_std = std(real_data(:,:,M1_times>-1500&M1_times<-500,:),[],3);
            zs_data = (real_data-data_mean) ./ data_std;
            day_M1_fail_ersp = cat(4, day_M1_fail_ersp, zs_data(:,(M1_freqs>=freq_range(1)) & (M1_freqs<=freq_range(2)),(M1_times>=time_range(1)) & (M1_times<=time_range(2)),:));
            
            real_data = abs(Cb_succ_ersp);
            data_mean = mean(real_data(:,:,Cb_times>-1500&Cb_times<-500,:),3);
            data_std = std(real_data(:,:,Cb_times>-1500&Cb_times<-500,:),[],3);
            zs_data = (real_data-data_mean) ./ data_std;
            day_Cb_succ_ersp = cat(4, day_Cb_succ_ersp, zs_data(:,(Cb_freqs>=freq_range(1)) & (Cb_freqs<=freq_range(2)),(Cb_times>=time_range(1)) & (Cb_times<=time_range(2)),:));
            
            real_data = abs(Cb_fail_ersp);
            data_mean = mean(real_data(:,:,Cb_times>-1500&Cb_times<-500,:),3);
            data_std = std(real_data(:,:,Cb_times>-1500&Cb_times<-500,:),[],3);
            zs_data = (real_data-data_mean) ./ data_std;
            day_Cb_fail_ersp = cat(4, day_Cb_fail_ersp, zs_data(:,(Cb_freqs>=freq_range(1)) & (Cb_freqs<=freq_range(2)),(Cb_times>=time_range(1)) & (Cb_times<=time_range(2)),:));
            
            if isempty(M1_succ_ersp)
                disp(['Day: ', num2str(day), ', Block: ', num2str(block), ' - No successful M1 trials'])
            elseif isempty(M1_fail_ersp)
                disp(['Day: ', num2str(day), ', Block: ', num2str(block), ' - No failure M1 trials'])
            else
                %M1_succ_heatmap = create_power_heatmap((M1_succ_ersp .* conj(M1_succ_ersp)), times, freqs);
                M1_succ_heatmap = create_power_heatmap(abs(M1_succ_ersp), M1_times, M1_freqs);
                saveas(M1_succ_heatmap, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/M1_succ_power_heatmap', '.fig']);
                close all;
                
                %M1_fail_heatmap = create_power_heatmap((M1_fail_ersp .* conj(M1_fail_ersp)), times, freqs);
                M1_fail_heatmap = create_power_heatmap(abs(M1_fail_ersp), M1_times, M1_freqs);
                saveas(M1_fail_heatmap, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/M1_fail_power_heatmap', '.fig']);
                close all;
            end
            
            if isempty(Cb_succ_ersp)
                disp(['Day: ', num2str(day), ', Block: ', num2str(block), ' - No successful Cb trials'])
            elseif isempty(Cb_fail_ersp)
                disp(['Day: ', num2str(day), ', Block: ', num2str(block), ' - No failure Cb trials'])
            else
                %Cb_succ_heatmap = create_power_heatmap((Cb_succ_ersp .* conj(Cb_succ_ersp)), times, freqs);
                Cb_succ_heatmap = create_power_heatmap(abs(Cb_succ_ersp), Cb_times, Cb_freqs);
                saveas(Cb_succ_heatmap, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Cb_succ_power_heatmap', '.fig']);
                close all;
                
                %Cb_fail_heatmap = create_power_heatmap((Cb_fail_ersp .* conj(Cb_fail_ersp)), times, freqs);
                Cb_fail_heatmap = create_power_heatmap(abs(Cb_fail_ersp), Cb_times, Cb_freqs);
                saveas(Cb_fail_heatmap, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Cb_fail_power_heatmap', '.fig']);
                close all;
            end
            
            
        end
        M1_day_ch_succ_means{day} = squeeze(mean(mean(day_M1_succ_ersp,3),2));
        M1_day_ch_fail_means{day} = squeeze(mean(mean(day_M1_fail_ersp,3),2));
        Cb_day_ch_succ_means{day} = squeeze(mean(mean(day_Cb_succ_ersp,3),2));
        Cb_day_ch_fail_means{day} = squeeze(mean(mean(day_Cb_fail_ersp,3),2));
    end
    load([rootpath,animal,'/Shared_Data.mat'])
    shared_data.M1_day_succ_spectral_power = M1_day_ch_succ_means;
    shared_data.M1_day_fail_spectral_power = M1_day_ch_fail_means;
    shared_data.Cb_day_succ_spectral_power = Cb_day_ch_succ_means;
    shared_data.Cb_day_fail_spectral_power = Cb_day_ch_fail_means;
    save([rootpath,animal,'/Shared_Data.mat'], 'shared_data')
    
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Calculate Inter-event Intervals (19)

if enabled(19)
    disp('Block 19...')
    for day=1:param.days
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            
            [reach_touch_interval, reach_retract_interval] = calc_post_reach_intervals(data,param.Camera_framerate);
            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/inter_event_intervals.mat'], 'reach_touch_interval', 'reach_retract_interval');
            
            clearvars -except code_rootpath day block rootpath origin_rootpath animal param enabled;
        end
    end
    clear day block;
end

%% Create IEI Time Course (20)

if enabled(20)
    disp('Block 20...')
    window_size = 30;
    all_reach_touch_interval = [];
    all_reach_retract_interval = [];
    day_starts = zeros(1,param.days);
    for day=1:param.days
        day_starts(day) = length(all_reach_touch_interval)+1;
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/inter_event_intervals.mat']);
            all_reach_touch_interval = [all_reach_touch_interval; reach_touch_interval(reach_touch_interval ~= -1)]; %#ok<AGROW>
            all_reach_retract_interval = [all_reach_retract_interval; reach_retract_interval(reach_retract_interval ~= -1)]; %#ok<AGROW>
        end
    end
    averaged_reach_touch_interval = smooth(all_reach_touch_interval,30);
    averaged_reach_retract_interval = smooth(all_reach_retract_interval,30);
    plot(1:length(averaged_reach_touch_interval), averaged_reach_touch_interval, 'b-', 1:length(averaged_reach_retract_interval), averaged_reach_retract_interval, 'k-', 1:length(all_reach_retract_interval), all_reach_retract_interval, 'k.', 1:length(all_reach_touch_interval), all_reach_touch_interval, 'b.', 'LineWidth', 2, 'MarkerSize', 3)
    %axis([1 length(averaged_reach_touch_interval) 0 2.5])
    legend('Ave touch','Ave retract','All retract','All touch')
    for i = 1:param.days
        line([day_starts(i) day_starts(i)], [0 2.5], 'Color', 'yellow', 'LineStyle', '--')
    end
    saveas(gcf,[rootpath,animal,'/Inter-event_time_course.fig']);
    save([rootpath,animal,'/IEI_time_course.mat'],'all_reach_touch_interval','all_reach_retract_interval','averaged_reach_touch_interval','averaged_reach_retract_interval');
    close all
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Create Small Event Centered Snapshots (21)

if enabled(21)
    disp('Block 21...')
    for day=1:param.days
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Normalized_Snapshots', '.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/inter_event_intervals.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat']);
            
            [M1_reach_snapshots, M1_touch_snapshots, M1_retract_snapshots] = create_event_centered_snapshots(reach_touch_interval, reach_retract_interval, M1_bad_trials, M1_snapshots, param.M1_Fs, 2, 4);
            [Cb_reach_snapshots, Cb_touch_snapshots, Cb_retract_snapshots] = create_event_centered_snapshots(reach_touch_interval, reach_retract_interval, Cb_bad_trials, Cb_snapshots, param.Cb_Fs, 2, 4);
            
            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Event_centered_snapshots', '.mat'],'M1_reach_snapshots','M1_touch_snapshots','M1_retract_snapshots','Cb_reach_snapshots','Cb_touch_snapshots','Cb_retract_snapshots')
            clearvars -except code_rootpath day block rootpath origin_rootpath animal param enabled;
        end
    end
    clear day block;
end

%% Calculate Event-centered ERPs and ITCs (22)

if enabled(22)
    disp('Block 22...')
    for day=1:param.days
        M1_day_reach_snapshots = [];
        M1_day_touch_snapshots = [];
        M1_day_retract_snapshots = [];
        Cb_day_reach_snapshots = [];
        Cb_day_touch_snapshots = [];
        Cb_day_retract_snapshots = [];
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Event_centered_snapshots', '.mat']);
            
            M1_day_reach_snapshots = cat(3, M1_day_reach_snapshots, M1_reach_snapshots);
            M1_day_touch_snapshots = cat(3, M1_day_touch_snapshots, M1_touch_snapshots);
            M1_day_retract_snapshots = cat(3, M1_day_retract_snapshots, M1_retract_snapshots);
            Cb_day_reach_snapshots = cat(3, Cb_day_reach_snapshots, Cb_reach_snapshots);
            Cb_day_touch_snapshots = cat(3, Cb_day_touch_snapshots, Cb_touch_snapshots);
            Cb_day_retract_snapshots = cat(3, Cb_day_retract_snapshots, Cb_retract_snapshots);
            
            [M1_reach_ersp_data, M1_reach_itc_data, times, freqs] = small_ersp_calc(M1_reach_snapshots, param.M1_Fs); %#ok<ASGLU>
            [M1_touch_ersp_data, M1_touch_itc_data, ~, ~] = small_ersp_calc(M1_touch_snapshots, param.M1_Fs);
            [M1_retract_ersp_data, M1_retract_itc_data, ~, ~] = small_ersp_calc(M1_retract_snapshots, param.M1_Fs);
            [Cb_reach_ersp_data, Cb_reach_itc_data, ~, ~] = small_ersp_calc(Cb_reach_snapshots, param.Cb_Fs);
            [Cb_touch_ersp_data, Cb_touch_itc_data, ~, ~] = small_ersp_calc(Cb_touch_snapshots, param.Cb_Fs);
            [Cb_retract_ersp_data, Cb_retract_itc_data, ~, ~] = small_ersp_calc(Cb_retract_snapshots, param.Cb_Fs);
            
            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Event_centered_ERSP_reach', '.mat'],'M1_reach_ersp_data', 'M1_touch_ersp_data', 'M1_retract_ersp_data','Cb_reach_ersp_data', 'Cb_touch_ersp_data', 'Cb_retract_ersp_data','times','freqs','-v7.3')
            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Event_centered_ITC_reach', '.mat'],'M1_reach_itc_data', 'M1_touch_itc_data', 'M1_retract_itc_data','Cb_reach_itc_data', 'Cb_touch_itc_data', 'Cb_retract_itc_data','times','freqs','-v7.3')
            
            
        end
        [M1_day_reach_ersp_data, M1_day_reach_itc_data, times, freqs] = small_ersp_calc(M1_day_reach_snapshots, param.M1_Fs);
        [M1_day_touch_ersp_data, M1_day_touch_itc_data, ~, ~] = small_ersp_calc(M1_day_touch_snapshots, param.M1_Fs);
        [M1_day_retract_ersp_data, M1_day_retract_itc_data, ~, ~] = small_ersp_calc(M1_day_retract_snapshots, param.M1_Fs);
        [Cb_day_reach_ersp_data, Cb_day_reach_itc_data, ~, ~] = small_ersp_calc(Cb_day_reach_snapshots, param.Cb_Fs);
        [Cb_day_touch_ersp_data, Cb_day_touch_itc_data, ~, ~] = small_ersp_calc(Cb_day_touch_snapshots, param.Cb_Fs);
        [Cb_day_retract_ersp_data, Cb_day_retract_itc_data, ~, ~] = small_ersp_calc(Cb_day_retract_snapshots, param.Cb_Fs);
        
        save([rootpath,animal,'/Day',num2str(day),'/Event_centered_ERSP_reach', '.mat'],'M1_day_reach_ersp_data', 'M1_day_touch_ersp_data', 'M1_day_retract_ersp_data','Cb_day_reach_ersp_data', 'Cb_day_touch_ersp_data', 'Cb_day_retract_ersp_data','times','freqs','-v7.3')
        save([rootpath,animal,'/Day',num2str(day),'/Event_centered_ITC_reach', '.mat'],'M1_day_reach_itc_data', 'M1_day_touch_itc_data', 'M1_day_retract_itc_data','Cb_day_reach_itc_data', 'Cb_day_touch_itc_data', 'Cb_day_retract_itc_data','times','freqs','-v7.3')
    end
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Plot Average ITC across Days (23)

if enabled(23)
    disp('Block 23...')
    
    reach_range = [-500, 500]; %[0, 1000]; %in ms
    touch_range = [-500, 500]; %[-250, 750];
    retract_range = [-500, 500]; %[-500, 500];
    delta_range = [0.1 3]; %hz
    theta_range = [3 6]; %hz
    
    M1_reach_ITC_ave_delta = zeros(param.days,length(param.M1_good_chans));
    M1_touch_ITC_ave_delta = zeros(param.days,length(param.M1_good_chans));
    M1_retract_ITC_ave_delta = zeros(param.days,length(param.M1_good_chans));
    Cb_reach_ITC_ave_delta = zeros(param.days,length(param.Cb_good_chans));
    Cb_touch_ITC_ave_delta = zeros(param.days,length(param.Cb_good_chans));
    Cb_retract_ITC_ave_delta = zeros(param.days,length(param.Cb_good_chans));
    
    M1_reach_ITC_ave_theta = zeros(param.days,length(param.M1_good_chans));
    M1_touch_ITC_ave_theta = zeros(param.days,length(param.M1_good_chans));
    M1_retract_ITC_ave_theta = zeros(param.days,length(param.M1_good_chans));
    Cb_reach_ITC_ave_theta = zeros(param.days,length(param.Cb_good_chans));
    Cb_touch_ITC_ave_theta = zeros(param.days,length(param.Cb_good_chans));
    Cb_retract_ITC_ave_theta = zeros(param.days,length(param.Cb_good_chans));
    for day=1:param.days
        load([rootpath,animal,'/Day',num2str(day),'/Event_centered_ITC_reach', '.mat']);

        M1_reach_ITC_ave_delta(day,:) = mean(mean(abs(M1_day_reach_itc_data(:,logical((freqs<delta_range(2)).*(freqs>delta_range(1))),logical((times<reach_range(2)).*(times>reach_range(1))))),3),2);
        M1_touch_ITC_ave_delta(day,:) = mean(mean(abs(M1_day_touch_itc_data(:,logical((freqs<delta_range(2)).*(freqs>delta_range(1))),logical((times<touch_range(2)).*(times>touch_range(1))))),3),2);
        M1_retract_ITC_ave_delta(day,:) = mean(mean(abs(M1_day_retract_itc_data(:,logical((freqs<delta_range(2)).*(freqs>delta_range(1))),logical((times<touch_range(2)).*(times>retract_range(1))))),3),2);
        
        M1_reach_ITC_ave_theta(day,:) = mean(mean(abs(M1_day_reach_itc_data(:,logical((freqs<theta_range(2)).*(freqs>theta_range(1))),logical((times<reach_range(2)).*(times>reach_range(1))))),3),2);
        M1_touch_ITC_ave_theta(day,:) = mean(mean(abs(M1_day_touch_itc_data(:,logical((freqs<theta_range(2)).*(freqs>theta_range(1))),logical((times<touch_range(2)).*(times>touch_range(1))))),3),2);
        M1_retract_ITC_ave_theta(day,:) = mean(mean(abs(M1_day_retract_itc_data(:,logical((freqs<theta_range(2)).*(freqs>theta_range(1))),logical((times<touch_range(2)).*(times>retract_range(1))))),3),2);
        
        Cb_reach_ITC_ave_delta(day,:) = mean(mean(abs(Cb_day_reach_itc_data(:,logical((freqs<delta_range(2)).*(freqs>delta_range(1))),logical((times<reach_range(2)).*(times>reach_range(1))))),3),2);
        Cb_touch_ITC_ave_delta(day,:) = mean(mean(abs(Cb_day_touch_itc_data(:,logical((freqs<delta_range(2)).*(freqs>delta_range(1))),logical((times<touch_range(2)).*(times>touch_range(1))))),3),2);
        Cb_retract_ITC_ave_delta(day,:) = mean(mean(abs(Cb_day_retract_itc_data(:,logical((freqs<delta_range(2)).*(freqs>delta_range(1))),logical((times<touch_range(2)).*(times>retract_range(1))))),3),2);
        
        Cb_reach_ITC_ave_theta(day,:) = mean(mean(abs(Cb_day_reach_itc_data(:,logical((freqs<theta_range(2)).*(freqs>theta_range(1))),logical((times<reach_range(2)).*(times>reach_range(1))))),3),2);
        Cb_touch_ITC_ave_theta(day,:) = mean(mean(abs(Cb_day_touch_itc_data(:,logical((freqs<theta_range(2)).*(freqs>theta_range(1))),logical((times<touch_range(2)).*(times>touch_range(1))))),3),2);
        Cb_retract_ITC_ave_theta(day,:) = mean(mean(abs(Cb_day_retract_itc_data(:,logical((freqs<theta_range(2)).*(freqs>theta_range(1))),logical((times<touch_range(2)).*(times>retract_range(1))))),3),2);

    end
    
    load([rootpath,animal,'/Shared_Data.mat']);
    
    shared_data.M1_reach_delta_ITC = M1_reach_ITC_ave_delta;
    bar(mean(M1_reach_ITC_ave_delta,2));
    axis([0.5 5.5 0 .6])
    saveas(gcf,[rootpath,animal,'/delta_ITC_Reach_M1', '.fig'])
    close all
    
    shared_data.M1_touch_delta_ITC = M1_touch_ITC_ave_delta;
    bar(mean(M1_touch_ITC_ave_delta,2))
    axis([0.5 5.5 0 .6])
    saveas(gcf,[rootpath,animal,'/delta_ITC_Touch_M1', '.fig'])
    close all
    
    shared_data.M1_retract_delta_ITC = M1_retract_ITC_ave_delta;
    bar(mean(M1_retract_ITC_ave_delta,2))
    axis([0.5 5.5 0 .6])
    saveas(gcf,[rootpath,animal,'/delta_ITC_Retract_M1', '.fig'])
    close all
    
    shared_data.Cb_reach_delta_ITC = Cb_reach_ITC_ave_delta;
    bar(mean(Cb_reach_ITC_ave_delta,2))
    axis([0.5 5.5 0 .6])
    saveas(gcf,[rootpath,animal,'/delta_ITC_Reach_Cb', '.fig'])
    close all
    
    shared_data.Cb_touch_delta_ITC = Cb_touch_ITC_ave_delta;
    bar(mean(Cb_touch_ITC_ave_delta,2))
    axis([0.5 5.5 0 .6])
    saveas(gcf,[rootpath,animal,'/delta_ITC_Touch_Cb', '.fig'])
    close all
    
    shared_data.Cb_retract_delta_ITC = Cb_retract_ITC_ave_delta;
    bar(mean(Cb_retract_ITC_ave_delta,2))
    axis([0.5 5.5 0 .6])
    saveas(gcf,[rootpath,animal,'/delta_ITC_Retract_Cb', '.fig'])
    close all
    
    save([rootpath,animal,'/Shared_Data.mat'], 'shared_data')
    
    %Early-Late graphs
    day_means = M1_reach_ITC_ave_delta;
    el_means = [mean([day_means(1,:); day_means(2,:)],1); mean([day_means(4,:); day_means(5,:)],1)];
    day_stdvs = std(day_means,0,2);
    el_stdvs = [mean([day_stdvs(1), day_stdvs(2)]) mean([day_stdvs(4), day_stdvs(5)])];
    bar(mean(el_means,2))
    hold on
    er = errorbar(mean(el_means,2),el_stdvs/sqrt(size(day_means,2)));
    er.Color = [0 0 0];                            
    er.LineStyle = 'none';
    axis([0.5 2.5 0 .2])
    saveas(gcf,[rootpath,animal,'/EL_delta_ITC_Reach_M1', '.fig'])
    hold off
    close all
    
    day_means = M1_touch_ITC_ave_delta;
    el_means = [mean([day_means(1,:); day_means(2,:)],1); mean([day_means(4,:); day_means(5,:)],1)];
    day_stdvs = std(day_means,0,2);
    el_stdvs = [mean([day_stdvs(1), day_stdvs(2)]) mean([day_stdvs(4), day_stdvs(5)])];
    bar(mean(el_means,2))
    hold on
    er = errorbar(mean(el_means,2),el_stdvs/sqrt(size(day_means,2)));
    er.Color = [0 0 0];                            
    er.LineStyle = 'none';
    axis([0.5 2.5 0 .2])
    saveas(gcf,[rootpath,animal,'/EL_delta_ITC_Touch_M1', '.fig'])
    close all
    
    day_means = M1_retract_ITC_ave_delta;
    el_means = [mean([day_means(1,:); day_means(2,:)],1); mean([day_means(4,:); day_means(5,:)],1)];
    day_stdvs = std(day_means,0,2);
    el_stdvs = [mean([day_stdvs(1), day_stdvs(2)]) mean([day_stdvs(4), day_stdvs(5)])];
    bar(mean(el_means,2))
    hold on
    er = errorbar(mean(el_means,2),el_stdvs/sqrt(size(day_means,2)));
    er.Color = [0 0 0];                            
    er.LineStyle = 'none';
    axis([0.5 2.5 0 .2])
    saveas(gcf,[rootpath,animal,'/EL_delta_ITC_Retract_M1', '.fig'])
    close all
    
    day_means = Cb_reach_ITC_ave_delta;
    el_means = [mean([day_means(1,:); day_means(2,:)],1); mean([day_means(4,:); day_means(5,:)],1)];
    day_stdvs = std(day_means,0,2);
    el_stdvs = [mean([day_stdvs(1), day_stdvs(2)]) mean([day_stdvs(4), day_stdvs(5)])];
    bar(mean(el_means,2))
    hold on
    er = errorbar(mean(el_means,2),el_stdvs/sqrt(size(day_means,2)));
    er.Color = [0 0 0];                            
    er.LineStyle = 'none';
    axis([0.5 2.5 0 .2])
    saveas(gcf,[rootpath,animal,'/EL_delta_ITC_Reach_Cb', '.fig'])
    close all
    
    day_means = Cb_touch_ITC_ave_delta;
    el_means = [mean([day_means(1,:); day_means(2,:)],1); mean([day_means(4,:); day_means(5,:)],1)];
    day_stdvs = std(day_means,0,2);
    el_stdvs = [mean([day_stdvs(1), day_stdvs(2)]) mean([day_stdvs(4), day_stdvs(5)])];
    bar(mean(el_means,2))
    hold on
    er = errorbar(mean(el_means,2),el_stdvs/sqrt(size(day_means,2)));
    er.Color = [0 0 0];                            
    er.LineStyle = 'none';
    axis([0.5 2.5 0 .2])
    saveas(gcf,[rootpath,animal,'/EL_delta_ITC_Touch_Cb', '.fig'])
    close all
    
    day_means = Cb_retract_ITC_ave_delta;
    el_means = [mean([day_means(1,:); day_means(2,:)],1); mean([day_means(4,:); day_means(5,:)],1)];
    day_stdvs = std(day_means,0,2);
    el_stdvs = [mean([day_stdvs(1), day_stdvs(2)]) mean([day_stdvs(4), day_stdvs(5)])];
    bar(mean(el_means,2))
    hold on
    er = errorbar(mean(el_means,2),el_stdvs/sqrt(size(day_means,2)));
    er.Color = [0 0 0];                            
    er.LineStyle = 'none';
    axis([0.5 2.5 0 .2])
    saveas(gcf,[rootpath,animal,'/EL_delta_ITC_Retract_Cb', '.fig'])
    close all
    
    
    bar(mean(M1_reach_ITC_ave_theta,2));
    axis([0.5 5.5 0 .6])
    saveas(gcf,[rootpath,animal,'/theta_ITC_Reach_M1', '.fig'])
    close all
    
    bar(mean(M1_touch_ITC_ave_theta,2));
    axis([0.5 5.5 0 .6])
    saveas(gcf,[rootpath,animal,'/theta_ITC_Touch_M1', '.fig'])
    close all
    
    bar(mean(M1_retract_ITC_ave_theta,2));
    axis([0.5 5.5 0 .6])
    saveas(gcf,[rootpath,animal,'/theta_ITC_Retract_M1', '.fig'])
    close all
    
    bar(mean(Cb_reach_ITC_ave_theta,2));
    axis([0.5 5.5 0 .6])
    saveas(gcf,[rootpath,animal,'/theta_ITC_Reach_Cb', '.fig'])
    close all
    
    bar(mean(Cb_touch_ITC_ave_theta,2));
    axis([0.5 5.5 0 .6])
    saveas(gcf,[rootpath,animal,'/theta_ITC_Touch_Cb', '.fig'])
    close all
    
    bar(mean(Cb_retract_ITC_ave_theta,2));
    axis([0.5 5.5 0 .6])
    saveas(gcf,[rootpath,animal,'/theta_ITC_Retract_Cb', '.fig'])
    close all
    
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Event-Tagged LFP plots (24)

if enabled(24)
    disp('Block 24...')
        
    M1_trials_of_interest = {[93],[10, 13];...
                             [],[];...
                             [],[];...
                             [],[];...
                             [20],[]};
    Cb_trials_of_interest = {[93],[10, 13];...
                             [],[];...
                             [],[];...
                             [],[];...
                             [20],[]};
    for day=1:param.days
        for block=1:param.blocks
            
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Normalized_full_Snapshots', '.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Filtered_LFP_full_Snapshots.mat']); %M1_1_4_snapshots
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/inter_event_intervals.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat']);
            
            [M1_snapshots, Cb_snapshots] = get_common_good_data(M1_snapshots_n, Cb_snapshots_n, M1_bad_trials, Cb_bad_trials, 3);
            [M1_filt, Cb_filt] = get_common_good_data(M1_1_4_snapshots_n, Cb_1_4_snapshots_n, M1_bad_trials, Cb_bad_trials, 3);
            common_bad_trials = unique([M1_bad_trials, Cb_bad_trials]);
            common_good_trials = 1:size(data,1);
            common_good_trials(common_bad_trials) = [];
            main_trial_num = 1:(size(M1_snapshots,3));
            
            [M1_succ_snapshots, M1_fail_snapshots] = success_fail_split(M1_snapshots, data, common_bad_trials, 3);
            [Cb_succ_snapshots, Cb_fail_snapshots] = success_fail_split(Cb_snapshots, data, common_bad_trials, 3);
            [M1_succ_filt, M1_fail_filt] = success_fail_split(M1_filt, data, common_bad_trials, 3);
            [Cb_succ_filt, Cb_fail_filt] = success_fail_split(Cb_filt, data, common_bad_trials, 3);
            [succ_main_trial_num, fail_main_trial_num] = success_fail_split(main_trial_num, data, common_bad_trials, 2);
            M1_time_course = round(-4*param.M1_Fs):round(4*param.M1_Fs);
            Cb_time_course = round(-4*param.Cb_Fs):round(4*param.Cb_Fs);
            
            M1_reach_touch_interval = reach_touch_interval;
            M1_reach_retract_interval = reach_retract_interval;
            Cb_reach_touch_interval = reach_touch_interval;
            Cb_reach_retract_interval = reach_retract_interval;
            
            M1_reach_touch_interval(common_bad_trials) = [];
            M1_reach_retract_interval(common_bad_trials) = [];
            Cb_reach_touch_interval(common_bad_trials) = [];
            Cb_reach_retract_interval(common_bad_trials) = [];
            
            
            [M1_reach_touch_interval_succ, ~] = success_fail_split(M1_reach_touch_interval, data, common_bad_trials, 1);
            [M1_reach_retract_interval_succ, ~] = success_fail_split(M1_reach_retract_interval, data, common_bad_trials, 1);
            [Cb_reach_touch_interval_succ, ~] = success_fail_split(Cb_reach_touch_interval, data, common_bad_trials, 1);
            [Cb_reach_retract_interval_succ, ~] = success_fail_split(Cb_reach_retract_interval, data, common_bad_trials, 1);
            
            if isempty(M1_fail_snapshots)
                disp(['Day: ', num2str(day), ', Block: ', num2str(block), ' - No failure M1 trials'])
            end
            if isempty(M1_succ_snapshots)
                disp(['Day: ', num2str(day), ', Block: ', num2str(block), ' - No successful M1 trials'])
            else
%                 figure
%                 for i = 1:size(M1_succ_snapshots,3)
%                     subplot(5,ceil(size(M1_succ_snapshots,3)/5),i);
%                     M1_succ_snapshots_mean = mean(M1_succ_snapshots(:,:,i),1);
%                     M1_succ_shapshots_filt = eegfilt(M1_succ_snapshots_mean, Fs, 3.0, 6.0);
%                     plot(time_course,M1_succ_snapshots_mean,'r-')%,time_course,M1_succ_snapshots(10,:,i),'m-')
%                     line(time_course, M1_succ_shapshots_filt, 'Color', 'black');
%                     axis([round(-.8*Fs) round(1.2*Fs) -2 2])
%                     line([0 0], [-2 2], 'Color', 'green', 'LineStyle', '--')
%                     line([(M1_reach_touch_interval_succ(i)*Fs) (M1_reach_touch_interval_succ(i)*Fs)], [-2 2], 'Color', 'blue', 'LineStyle', '--')
%                     line([(M1_reach_retract_interval_succ(i)*Fs) (M1_reach_retract_interval_succ(i)*Fs)], [-2 2], 'Color', 'black', 'LineStyle', '--');
%                 end
%                 saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/',block_names{block},'/M1_All_success_Trials_LFP', '.fig']);
%                 close all;
%                 
%                 figure
%                 for i = 1:size(Cb_succ_snapshots,3)
%                     subplot(5,ceil(size(Cb_succ_snapshots,3)/5),i);
%                     Cb_succ_snapshots_mean = mean(Cb_succ_snapshots(:,:,i),1);
%                     Cb_succ_shapshots_filt = eegfilt(Cb_succ_snapshots_mean, Fs, 3.0, 6.0);
%                     plot(time_course,Cb_succ_snapshots_mean,'g-')%, time_course,Cb_succ_snapshots(10,:,i),'c-')
%                     line(time_course, Cb_succ_shapshots_filt, 'Color', 'black');
%                     axis([round(-.8*Fs) round(1.2*Fs) -2 2])
%                     line([0 0], [-2 2], 'Color', 'green', 'LineStyle', '--')
%                     line([(Cb_reach_touch_interval_succ(i)*Fs) (Cb_reach_touch_interval_succ(i)*Fs)], [-2 2], 'Color', 'blue', 'LineStyle', '--')
%                     line([(Cb_reach_retract_interval_succ(i)*Fs) (Cb_reach_retract_interval_succ(i)*Fs)], [-2 2], 'Color', 'black', 'LineStyle', '--');
%                 end
%                 saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/',block_names{block},'/Cb_All_success_Trials_LFP', '.fig']);
%                 close all;
                
                for i1 = 0:20:size(M1_succ_snapshots,3)-1
                    figure
                    for i2 = 1:min(20,size(M1_succ_snapshots,3)-i1)
                        subplot(5,8,(i2*2)-1);
                        i = i1 + i2;
                        M1_succ_snapshots_mean = mean(M1_succ_snapshots(:,:,i),1);
                        M1_succ_filt_mean = mean(M1_succ_filt(:,:,i),1); 
                        plot(M1_time_course,M1_succ_snapshots_mean,'r-')%,time_course,M1_succ_snapshots(10,:,i),'m-')
                        line(M1_time_course, M1_succ_filt_mean, 'Color', 'black');
                        axis([round(-.8*param.M1_Fs) round(1.2*param.M1_Fs) -0.5 0.5])
                        line([0 0], [-0.5 0.5], 'Color', 'green', 'LineStyle', '--')
                        line([(M1_reach_touch_interval_succ(i)*param.M1_Fs) (M1_reach_touch_interval_succ(i)*param.M1_Fs)], [-2 2], 'Color', 'blue', 'LineStyle', '--')
                        line([(M1_reach_retract_interval_succ(i)*param.M1_Fs) (M1_reach_retract_interval_succ(i)*param.M1_Fs)], [-2 2], 'Color', 'black', 'LineStyle', '--');
                        title(num2str(common_good_trials(succ_main_trial_num(i))));
                        
                        subplot(5,8,(i2*2));
                        Cb_succ_snapshots_mean = mean(Cb_succ_snapshots(:,:,i),1);
                        Cb_succ_filt_mean = mean(Cb_succ_filt(:,:,i),1); 
                        plot(Cb_time_course,Cb_succ_snapshots_mean,'g-')%, time_course,Cb_succ_snapshots(10,:,i),'c-')
                        line(Cb_time_course, Cb_succ_filt_mean, 'Color', 'black');
                        axis([round(-.8*param.Cb_Fs) round(1.2*param.Cb_Fs) -0.5 0.5])
                        line([0 0], [-0.5 0.5], 'Color', 'green', 'LineStyle', '--')
                        line([(Cb_reach_touch_interval_succ(i)*param.Cb_Fs) (Cb_reach_touch_interval_succ(i)*param.Cb_Fs)], [-2 2], 'Color', 'blue', 'LineStyle', '--')
                        line([(Cb_reach_retract_interval_succ(i)*param.Cb_Fs) (Cb_reach_retract_interval_succ(i)*param.Cb_Fs)], [-2 2], 'Color', 'black', 'LineStyle', '--');
                    end
                    saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/All_success_Trials_LFP_compare',num2str((i1/20)+1), '.fig']);
                    close all;
                end
                
                for true_trial_num = M1_trials_of_interest{day,block}
                    trial = find(common_good_trials == true_trial_num);
                    succ_trial = find(succ_main_trial_num == trial);
                    figure
                    for chan = 1:size(M1_succ_snapshots,1)
                        subplot(5,ceil(size(M1_succ_snapshots,1)/5),chan);
                        M1_succ_shapshot_filt = M1_succ_filt(chan,:,succ_trial); %snapshot is not long enough to provide data about frequencies slower than 1.125
                        plot(M1_time_course,M1_succ_snapshots(chan,:,succ_trial),'r-')
                        line(M1_time_course, M1_succ_shapshot_filt, 'Color', 'black');
                        axis([round(-.8*param.M1_Fs) round(1.2*param.M1_Fs) -2 2])
                        line([0 0], [-2 2], 'Color', 'green', 'LineStyle', '--')
                        line([(M1_reach_touch_interval_succ(succ_trial)*param.M1_Fs) (M1_reach_touch_interval_succ(succ_trial)*param.M1_Fs)], [-2 2], 'Color', 'blue', 'LineStyle', '--')
                        line([(M1_reach_retract_interval_succ(succ_trial)*param.M1_Fs) (M1_reach_retract_interval_succ(succ_trial)*param.M1_Fs)], [-2 2], 'Color', 'black', 'LineStyle', '--');
                    end
                    saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/M1_All_channels_Trial_',num2str(true_trial_num),'_LFP', '.fig']);
                    close all;
                end
                
                for true_trial_num = Cb_trials_of_interest{day,block}
                    trial = find(common_good_trials == true_trial_num);
                    succ_trial = find(succ_main_trial_num == trial);
                    figure
                    for chan = 1:size(Cb_succ_snapshots,1)
                        subplot(5,ceil(size(Cb_succ_snapshots,1)/5),chan);
                        Cb_succ_shapshot_filt = Cb_succ_filt(chan,:,succ_trial); %snapshot is not long enough to provide data about frequencies slower than 1.125
                        plot(Cb_time_course,Cb_succ_snapshots(chan,:,succ_trial),'g-')
                        line(Cb_time_course, Cb_succ_shapshot_filt, 'Color', 'black');
                        axis([round(-.8*param.Cb_Fs) round(1.2*param.Cb_Fs) -2 2])
                        line([0 0], [-2 2], 'Color', 'green', 'LineStyle', '--')
                        line([(Cb_reach_touch_interval_succ(succ_trial)*param.Cb_Fs) (Cb_reach_touch_interval_succ(succ_trial)*param.Cb_Fs)], [-2 2], 'Color', 'blue', 'LineStyle', '--')
                        line([(Cb_reach_retract_interval_succ(succ_trial)*param.Cb_Fs) (Cb_reach_retract_interval_succ(succ_trial)*param.Cb_Fs)], [-2 2], 'Color', 'black', 'LineStyle', '--');
                    end
                    saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Cb_All_channels_Trial_',num2str(true_trial_num),'_LFP', '.fig']);
                    close all;
                end
            end
            clearvars -except code_rootpath rootpath origin_rootpath animal param enabled day block Cb_trials_of_interest M1_trials_of_interest;
        end
    end
    clear day block Cb_trials_of_interest M1_trials_of_interest;
end

%% Calculate LFP/LFP Coherence Data (25)

if enabled(25)
    disp('Block 25...')
    addpath(genpath('Z:/Matlab for analysis/chronux_2_10/chronux/spectral_analysis'))
    addpath(genpath('Z:/Matlab for analysis/eeglab/functions'))
    M1_channels_of_interest = param.M1_increasing_power_channels;
    Cb_channels_of_interest = param.Cb_increasing_power_channels;
    if isempty(M1_channels_of_interest)
        M1_channels_of_interest = param.M1_good_chans;
    else
        M1_channels_of_interest = intersect(M1_channels_of_interest, param.M1_good_chans);
    end
    if isempty(Cb_channels_of_interest)
        Cb_channels_of_interest = param.Cb_good_chans;
    else
        Cb_channels_of_interest = intersect(Cb_channels_of_interest, param.Cb_good_chans);
    end
        
    coh_params.Fs = param.M1_Fs;
    coh_params.fpass = [0 20];
    coh_params.tapers = [3 5];
    coh_params.trialave = 0;
    coh_params.pad = 1;
    coh_params.err = [2 0.05];
    for day=1:param.days
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Normalized_Snapshots.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat']);
            if isempty(M1_snapshots)
                continue
            end
            [M1_snapshots, Cb_snapshots] = get_common_good_data(M1_snapshots, Cb_snapshots, M1_bad_trials, Cb_bad_trials, 3);
            if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/LFP-LFP_Spectral_Coherence_alt'],'dir')
                mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/LFP-LFP_Spectral_Coherence_alt']);
            end
            
            for M1_chan = find(ismember(param.M1_good_chans,M1_channels_of_interest))
                for Cb_chan = find(ismember(param.Cb_good_chans,Cb_channels_of_interest))
%                     %Version 1 (chronux)
%                     [coh,phi_cmr,~,~,~,coh_times,coh_freqs,~,~,~] = cohgramc(squeeze(M1_snapshots(M1_chan,:,:)), squeeze(Cb_snapshots(Cb_chan,:,:)), [1 .025], coh_params);
%                     coh_times = (coh_times - 4) * coh_params.Fs;
%                     coh = coh';
                    
                    %Version 2 (eeglab)
                    M1_snapshots_flat = M1_snapshots(M1_chan,:,:);
                    M1_snapshots_flat = M1_snapshots_flat(:);
                    Cb_snapshots_flat = Cb_snapshots(Cb_chan,:,:);
                    Cb_snapshots_flat = Cb_snapshots_flat(:);
                    [coh,~,coh_times,coh_freqs,~,coh_angle,~] = newcrossf(M1_snapshots_flat, Cb_snapshots_flat, size(M1_snapshots,2),[-4000 4000],param.M1_Fs,[0.01 0.1],'type','coher','freqs', [0 60]);
                    phi_cmr = [];
                    
                    save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/LFP-LFP_Spectral_Coherence_alt/M1ch',num2str(param.M1_good_chans(M1_chan)),'_Cbch',num2str(param.Cb_good_chans(Cb_chan)),'_data', '.mat'], 'coh', 'phi_cmr', 'coh_times', 'coh_freqs');
                    close all
                end
            end
            
            clearvars -except code_rootpath rootpath origin_rootpath animal param enabled day block params M1_channels_of_interest Cb_channels_of_interest coh_params;
        end
    end
    rmpath(genpath('Z:/Matlab for analysis/chronux_2_10/chronux/spectral_analysis'))
    rmpath(genpath('Z:/Matlab for analysis/eeglab/functions'))
    clear day block params M1_channels_of_interest Cb_channels_of_interest;
end

%% Create LFP/LFP Coherence Heatmaps (26)

if enabled(26)
    disp('Block 26...')
    M1_channels_of_interest = param.M1_increasing_power_channels;
    Cb_channels_of_interest = param.Cb_increasing_power_channels;
    if isempty(M1_channels_of_interest)
        M1_channels_of_interest = param.M1_good_chans;
    else
        M1_channels_of_interest = intersect(M1_channels_of_interest, param.M1_good_chans);
    end
    if isempty(Cb_channels_of_interest)
        Cb_channels_of_interest = param.Cb_good_chans;
    else
        Cb_channels_of_interest = intersect(Cb_channels_of_interest, param.Cb_good_chans);
    end
    
    for day=1:param.days
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Normalized_Snapshots.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat']);
            if isempty(M1_snapshots)
                continue
            end
            for M1_chan = find(ismember(param.M1_good_chans,M1_channels_of_interest))
                for Cb_chan = find(ismember(param.Cb_good_chans,Cb_channels_of_interest))
            
                    load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/LFP-LFP_Spectral_Coherence_alt/M1ch',num2str(param.M1_good_chans(M1_chan)),'_Cbch',num2str(param.Cb_good_chans(Cb_chan)),'_data', '.mat']);
                    
                    figure;
                    %subplot(1,2,1)
                    pcolor(coh_times,coh_freqs,squeeze(mean(coh, 3)))
                    shading interp
                    axis xy
                    axis([-1000 1500 1.5 20])
                    caxis([0 0.8])
                    colorbar
                    title('Coherence Magnitude')
                    
%                     subplot(1,2,2)
%                     pcolor(coh_times,coh_freqs,squeeze(mean(phi_cmr, 3))')
%                     shading interp
%                     axis xy
%                     axis([-1000 1500 1.5 20])
%                     caxis([0 0.8])
%                     colorbar
%                     title('Coherence Phase')
                    
                    saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/LFP-LFP_Spectral_Coherence_alt/M1ch',num2str(param.M1_good_chans(M1_chan)),'_Cbch',num2str(param.Cb_good_chans(Cb_chan)),'_heatmap', '.fig']);
                    saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/LFP-LFP_Spectral_Coherence_alt/M1ch',num2str(param.M1_good_chans(M1_chan)),'_Cbch',num2str(param.Cb_good_chans(Cb_chan)),'_heatmap', '.tiff']);
                    close all
                end
            end
            clearvars -except code_rootpath rootpath origin_rootpath animal param enabled day block M1_channels_of_interest Cb_channels_of_interest;
        end
    end
    clear day block M1_channels_of_interest Cb_channels_of_interest;
end

%% Create LFP/LFP Mean Coherence Heatmaps (27)

if enabled(27)
    disp('Block 27...')
    M1_channels_of_interest = param.M1_increasing_power_channels;
    Cb_channels_of_interest = param.Cb_increasing_power_channels;
    if isempty(M1_channels_of_interest)
        M1_channels_of_interest = param.M1_good_chans;
    else
        M1_channels_of_interest = intersect(M1_channels_of_interest, param.M1_good_chans);
    end
    if isempty(Cb_channels_of_interest)
        Cb_channels_of_interest = param.Cb_good_chans;
    else
        Cb_channels_of_interest = intersect(Cb_channels_of_interest, param.Cb_good_chans);
    end
    
    freq_range = [1.5 4];
    time_range = [-250 750];
    all_day_coh = nan(param.days,(length(M1_channels_of_interest) * length(Cb_channels_of_interest) * param.blocks));
    min_ersp_increase = 0;
    
    first_day_M1 = [];
    first_day_Cb = [];
    last_day_M1 = [];
    last_day_Cb = [];
    for block=1:param.blocks
        load([rootpath,animal,'/Day',num2str(1),'/',param.block_names{block},'/ERSP_reach', '.mat']);
        first_day_M1 = cat(4,first_day_M1,abs(M1_ersp_data));
        first_day_Cb = cat(4,first_day_Cb,abs(Cb_ersp_data));
        load([rootpath,animal,'/Day',num2str(param.days),'/',param.block_names{block},'/ERSP_reach', '.mat']);
        last_day_M1 = cat(4,last_day_M1,abs(M1_ersp_data));
        last_day_Cb = cat(4,last_day_Cb,abs(Cb_ersp_data));
    end
    freq_idxs_M1 = (M1_freqs > freq_range(1)) & (M1_freqs < freq_range(2));
    time_idxs_M1 = (M1_times > time_range(1)) & (M1_times < time_range(2));
    freq_idxs_Cb = (Cb_freqs > freq_range(1)) & (Cb_freqs < freq_range(2));
    time_idxs_Cb = (Cb_times > time_range(1)) & (Cb_times < time_range(2));

    for day=1:param.days
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Normalized_Snapshots.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat']);
            if isempty(M1_snapshots)
                continue
            end
            
            all_cohs = [];
            chan_idx = 0;
            M1_chan_idx = 0;
            for M1_chan = M1_channels_of_interest
                M1_chan_idx = M1_chan_idx +1;
                Cb_chan_idx = 0;
                for Cb_chan = Cb_channels_of_interest
                    Cb_chan_idx = Cb_chan_idx +1;
                    chan_idx = chan_idx + 1;
                    load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/LFP-LFP_Spectral_Coherence_alt/M1ch',num2str(M1_chan),'_Cbch',num2str(Cb_chan),'_data', '.mat']);
                    %'coh', 'phi_cmr', 'coh_times', 'coh_freqs'
                    all_cohs = cat(3, all_cohs, coh);
                end
            end
            
            figure;
            pcolor(coh_times,coh_freqs,squeeze(mean(all_cohs, 3)))
            shading interp
            axis xy
            axis([-1000 1500 1.5 20])
            caxis([0 0.8])
            colorbar
            title('Coherence Magnitude')
            saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/LFP-LFP_Spectral_Coherence_alt/Mean_coherence_heatmap', '.fig']);
            close all
            
            freq_idxs = (coh_freqs > freq_range(1)) & (coh_freqs < freq_range(2));
            time_idxs = (coh_times > time_range(1)) & (coh_times < time_range(2));
            if exist('day_coh', 'var')
                day_coh = cat(3, day_coh, all_cohs(freq_idxs, time_idxs, :));
            else
                day_coh = all_cohs(freq_idxs, time_idxs, :);
            end
        end
        if ~exist('day_coh', 'var')
            continue
        end
        day_coh = mean(day_coh,2);
        day_coh = cat(3, day_coh, nan(size(day_coh,1), size(day_coh,2), (size(all_day_coh,2) - size(day_coh,3))));
        all_day_coh(day,:) = mean(day_coh,1);
        clear day_coh
    end
    load([rootpath,animal,'/Shared_Data.mat'])
    shared_data.day_LFP_LFP_coherence = all_day_coh;
    save([rootpath,animal,'/Shared_Data.mat'], 'shared_data')
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Pull out Specific Event Tagged LFP plot for M1 and Cb (28)

if enabled(28)
    disp('Block 28...')
    day = 5;
    block = 1;      %1;           1
    trial = 20;     %10;          50
    true_M1_channel = 31;%8,9;         16
    true_Cb_channel = 32;%1,4,9,16,29; 1,9,23,25
   
    M1_channel = find(true_M1_channel == param.M1_good_chans);
    Cb_channel = find(true_Cb_channel == param.Cb_good_chans);
    
    uiopen([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/M1_All_channels_Trial_',num2str(trial),'_LFP', '.fig'],1);
    M1_fig = gcf;
    subplot(5, ceil(numel(M1_fig.Children)/5), M1_channel);
    f = figure;
    h = subplot(1,1,1);
    copyobj(allchild(get(M1_fig,'CurrentAxes')),h);
    saveas(f, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/M1_Channel_',num2str(true_M1_channel),'_Trial_',num2str(trial),'_LFP', '.fig']);
    close all

    uiopen([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Cb_All_channels_Trial_',num2str(trial),'_LFP', '.fig'],1);
    Cb_fig = gcf;
    subplot(5, ceil(numel(Cb_fig.Children)/5), Cb_channel);
    f = figure;
    h = subplot(1,1,1);
    copyobj(allchild(get(Cb_fig,'CurrentAxes')),h);
    saveas(f, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Cb_Channel_',num2str(true_Cb_channel),'_Trial_',num2str(trial),'_LFP', '.fig']);
    close all
    
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Extract Spike Timestamp Data (29) *If this breaks when running some legacy data examine the block after this one for solutions*

if enabled(29)
    disp('Block 29...')
    addpath(genpath('Z:\BMI_Analysis'))
    addpath(genpath('Z:\Matlab Offline Files SDK'))
    addpath(genpath([code_rootpath, 'RunSpykingCircusSorter-master']))
    addpath(genpath('Z:\Matlab for analysis\TDTMatlabSDK\TDTSDK\TDTbin2mat'))

    extract_waveforms = true;
    param.M1_mua_neurons = cell(5,1);
    param.Cb_mua_neurons = cell(5,1);
    s_err = false;
    
    if param.M1_shant_site_num == 1
        M1_shant_name = 'Channel';
        M1_shant_name_short = 'Ch';
    elseif param.M1_shant_site_num == 4
        M1_shant_name = 'Tetrode';
        M1_shant_name_short = 'tet';
    elseif param.M1_shant_site_num == 16
        M1_shant_name = 'Polytrode';
        M1_shant_name_short = 'poly';
    elseif param.M1_shant_site_num == 0
        M1_shant_name = 'none';
        M1_shant_name_short = 'none';
    else
        error('Unrecognised M1 shant type')
    end
    
    if param.Cb_shant_site_num == 1
        Cb_shant_name = 'Channel';
        Cb_shant_name_short = 'Ch';
    elseif param.Cb_shant_site_num == 4
        Cb_shant_name = 'Tetrode';
        Cb_shant_name_short = 'tet';
    elseif param.Cb_shant_site_num == 16 || param.Cb_shant_site_num == 32
        Cb_shant_name = 'Polytrode';
        Cb_shant_name_short = 'poly';
    else
        error('Unrecognised Cb shant type')
    end
    
    for day=1:param.days
        %if strcmp(animal,'I060') || strcmp(animal,'I061') ||  strcmp(animal, 'I064')
            
        %else
            param.M1_mua_neurons{day} = zeros(param.M1_chans,param.M1_neurons);
            param.Cb_mua_neurons{day} = zeros(param.Cb_chans,param.Cb_neurons);
            
            param.M1_neuron_chans{day} = nan(param.M1_chans,param.M1_neurons);
            param.Cb_neuron_chans{day} = nan(param.Cb_chans,param.Cb_neurons);
            
            load([origin_rootpath,animal,'/',param.durFiles(day,:),'.mat']);
            
            sb_idxs = cell(1,4);
            sub_block_names = [];
            prev_last_idx = 0;
            if size(param.sleep_block_names,2) > 0
                sb_idxs{1} = 1:size(param.sleep_block_names{day,1},1);
                prev_last_idx = sb_idxs{1}(end);
                sub_block_names = [sub_block_names ; param.sleep_block_names{day,1}]; %#ok<AGROW>
            else
                sb_idxs{1} = nan(1,0);
            end
            if size(param.training_block_names,2) > 0
                sb_idxs{2} = (1:size(param.training_block_names{day,1},1)) + prev_last_idx;
                prev_last_idx = sb_idxs{2}(end);
                sub_block_names = [sub_block_names ; param.training_block_names{day,1}]; %#ok<AGROW>
            else
                sb_idxs{2} = nan(1,0);
            end
            if size(param.sleep_block_names,2) > 1
                sb_idxs{3} = (1:size(param.sleep_block_names{day,2},1)) + prev_last_idx;
                prev_last_idx = sb_idxs{3}(end);
                sub_block_names = [sub_block_names ; param.sleep_block_names{day,2}]; %#ok<AGROW>
            else
                sb_idxs{3} = nan(1,0);
            end
            if size(param.training_block_names,2) > 1
                sb_idxs{4} = (1:size(param.training_block_names{day,2},1)) + prev_last_idx;
                prev_last_idx = sb_idxs{4}(end);
                sub_block_names = [sub_block_names ; param.training_block_names{day,2}]; %#ok<AGROW>
            else
                sb_idxs{4} = nan(1,0);
            end
            
            if size(durMAT,2) ~= length([sb_idxs{:}])
                error('Sub-Block count mismatch')
            end
            
            for block = 1:4
                M1_spike_timestamps = cell(param.M1_chans,param.M1_neurons);
                M1_spike_waves = cell(param.M1_chans,param.M1_neurons);
                Cb_spike_timestamps = cell(param.Cb_chans,param.Cb_neurons);
                Cb_spike_waves = cell(param.Cb_chans,param.Cb_neurons);
                if mod(block,2) %sleep blocks
                    save([rootpath,animal,'/Day',num2str(day),'/',param.s_block_names{ceil(block/2)},'/Spike_timestamps.mat'], 'M1_spike_timestamps', 'Cb_spike_timestamps');
                    save([rootpath,animal,'/Day',num2str(day),'/',param.s_block_names{ceil(block/2)},'/Spike_waveforms.mat'], 'M1_spike_waves', 'Cb_spike_waves', '-v7.3');
                else
                    save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block/2},'/Spike_timestamps.mat'], 'M1_spike_timestamps', 'Cb_spike_timestamps');
                    save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block/2},'/Spike_waveforms.mat'], 'M1_spike_waves', 'Cb_spike_waves', '-v7.3');
                end
            end
            
            %M1 spike times
            if param.M1_chans == 0
                block_spikes = cell(0,3);
            else
                block_spikes = cell((param.M1_chans/param.M1_shant_site_num),3);
            end
            chan_vect = 0:((param.M1_chans/param.M1_shant_site_num)-1);
            if isnan(chan_vect)
                chan_vect = [];
            end
            for chan = chan_vect
                spike_times = double(readNPY([origin_rootpath,animal,'\',param.Spike_path,'\',animal,'-', param.durFiles(day,11:16), '_DAT_files\M1\',M1_shant_name,'_', num2str(chan), '\SU_CONT_M1_',M1_shant_name_short,'_', num2str(chan), '_0\SU_CONT_M1_',M1_shant_name_short,'_', num2str(chan), '_0.GUI\spike_times.npy']));
                spike_clusters = readNPY([origin_rootpath,animal,'\',param.Spike_path,'\',animal,'-', param.durFiles(day,11:16), '_DAT_files\M1\',M1_shant_name,'_', num2str(chan), '\SU_CONT_M1_',M1_shant_name_short,'_', num2str(chan), '_0\SU_CONT_M1_',M1_shant_name_short,'_', num2str(chan), '_0.GUI\spike_clusters.npy']);
                cluster_info = tdfread([origin_rootpath,animal,'\',param.Spike_path,'\',animal,'-', param.durFiles(day,11:16), '_DAT_files\M1\',M1_shant_name,'_', num2str(chan), '\SU_CONT_M1_',M1_shant_name_short,'_', num2str(chan), '_0\SU_CONT_M1_',M1_shant_name_short,'_', num2str(chan), '_0.GUI\cluster_info.tsv']); 
                dat_chan = (chan*param.M1_shant_site_num)+1;
                
                if param.M1_neurons < sum(strcmp(string(cluster_info.group),'good ') | strcmp(string(cluster_info.group),'mua  ') | strcmp(string(cluster_info.group),'good') | strcmp(string(cluster_info.group),'mua '))
                    disp(['param.M1_neurons needs to be increased to ', num2str(length(unique(spike_clusters)))])
                    param.M1_neurons = length(unique(spike_clusters));
                    s_err = true;
                elseif ~s_err
                    %get waveforms
                    for sub_block = 1:size(sub_block_names,1)
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\',animal,'-', param.durFiles(day,11:16), '_DAT_files\M1\',M1_shant_name,'_', num2str(chan), '\SU_CONT_M1_',M1_shant_name_short,'_', num2str(chan), '_', num2str(sub_block-1), '.dat'],'r');
                        sb_chan_full_wave = fread(fiD,'float32');
                        sb_chan_full_wave = reshape(sb_chan_full_wave,param.M1_shant_site_num,length(sb_chan_full_wave)/param.M1_shant_site_num);
                        fclose(fiD);
                        
                        durMAT(3,sub_block) = length(sb_chan_full_wave)/param.M1_spike_wave_Fs;
                        
                        %Sort spiketimes into sub-blocks
                        sb_spike_times = spike_times(spike_times <= size(sb_chan_full_wave,2));
                        sb_spike_clusters = spike_clusters(1:length(sb_spike_times));
                        spike_clusters(1:length(sb_spike_times)) = [];
                        spike_times(1:length(sb_spike_times)) = [];
                        spike_times = spike_times - size(sb_chan_full_wave,2);
                        
                        sb_waves = nan(30, length(sb_spike_times), param.M1_shant_site_num);
                        for i = 1:length(sb_spike_times)
                            t_stamp = sb_spike_times(i);
                            if (t_stamp + 22) <= size(sb_chan_full_wave,2) && (t_stamp - 7) > 0
                                for j = 1:param.M1_shant_site_num
                                    sb_waves(:,i,j) = sb_chan_full_wave(j,t_stamp - 7:t_stamp + 22);
                                end
                            end
                        end
                        clear sb_chan_full_wave
                        
                        %Truncate
                        sb_spike_times(sb_spike_times > (durMAT(5,sub_block)*param.M1_spike_wave_Fs)) = [];
                        sb_spike_clusters = sb_spike_clusters(1:length(sb_spike_times));
                        sb_waves = sb_waves(:,1:length(sb_spike_times),:);
                        
                        %Concatinate into blocks
                        for block = 1:4
                            if ismember(sub_block, sb_idxs{block}) 
                                block_spikes{chan+1,1} = [block_spikes{chan+1,1}; (sb_spike_times + (sum(durMAT(5,sb_idxs{block}(sb_idxs{block}<sub_block)))*param.M1_spike_wave_Fs))];
                                block_spikes{chan+1,2} = [block_spikes{chan+1,2}; sb_spike_clusters];
                                block_spikes{chan+1,3} = [block_spikes{chan+1,3}, sb_waves];
                                
                                if sub_block == sb_idxs{block}(end)
                                    if mod(block,2) %sleep blocks
                                        load([rootpath,animal,'/Day',num2str(day),'/',param.s_block_names{ceil(block/2)},'/Spike_timestamps.mat']);
                                        load([rootpath,animal,'/Day',num2str(day),'/',param.s_block_names{ceil(block/2)},'/Spike_waveforms.mat']);
                                    else %training blocks
                                        load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block/2},'/Spike_timestamps.mat']);
                                        load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block/2},'/Spike_waveforms.mat']);
                                    end
                                    
                                    cell_idx = 0;
                                    for neuron = 1:length(cluster_info.cluster_id)
                                        if (strcmp(cluster_info.group(neuron,:),'good ') || strcmp(cluster_info.group(neuron,:),'mua  ') || strcmp(cluster_info.group(neuron,:),'good') || strcmp(cluster_info.group(neuron,:),'mua '))
                                            cell_idx = cell_idx+1;
                                            if strcmp(cluster_info.group(neuron,:),'mua  ') || strcmp(cluster_info.group(neuron,:),'mua ')
                                                param.M1_mua_neurons{day}(dat_chan,cell_idx) = true;
                                            end
                                            param.M1_neuron_chans{day}(dat_chan,cell_idx) = cluster_info.ch(neuron);
                                            M1_spike_timestamps{dat_chan,cell_idx} = block_spikes{chan+1,1}(block_spikes{chan+1,2} == cluster_info.cluster_id(neuron))';
                                            
                                            for sub_chan = 0:(param.M1_shant_site_num-1)
                                                M1_spike_waves{dat_chan + sub_chan,cell_idx} = block_spikes{chan+1,3}(:, block_spikes{chan+1,2} == cluster_info.cluster_id(neuron),sub_chan+1);
                                            end
                                            M1_spike_timestamps{dat_chan,cell_idx} = M1_spike_timestamps{dat_chan,cell_idx}/param.M1_spike_wave_Fs;
                                        end
                                    end
                                    
                                    if mod(block,2) %sleep blocks
                                        save([rootpath,animal,'/Day',num2str(day),'/',param.s_block_names{ceil(block/2)},'/Spike_timestamps.mat'], 'M1_spike_timestamps', 'Cb_spike_timestamps');
                                        save([rootpath,animal,'/Day',num2str(day),'/',param.s_block_names{ceil(block/2)},'/Spike_waveforms.mat'], 'M1_spike_waves', 'Cb_spike_waves', '-v7.3');
                                    else
                                        save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block/2},'/Spike_timestamps.mat'], 'M1_spike_timestamps', 'Cb_spike_timestamps');
                                        save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block/2},'/Spike_waveforms.mat'], 'M1_spike_waves', 'Cb_spike_waves', '-v7.3');
                                    end
                                    block_spikes = cell((param.M1_chans/param.M1_shant_site_num),3);
                                end
                            end
                        end
                    end
                end
            end
            clear block_spikes sb_waves sb_chan_full_wave
            
            %Cb spike times
            if param.Cb_chans == 0
                block_spikes = cell(0,3);
            else
                block_spikes = cell((param.Cb_chans/param.Cb_shant_site_num),2);
            end
            shant_vect = 0:((param.Cb_chans/param.Cb_shant_site_num)-1);
            if isnan(shant_vect)
                shant_vect = [];
            end
            for shant = shant_vect
                spike_times = double(readNPY([origin_rootpath,animal,'\',param.Spike_path,'\',animal,'-', param.durFiles(day,11:16), '_DAT_files\Cb\',Cb_shant_name,'_', num2str(shant), '\SU_CONT_Cb_',Cb_shant_name_short,'_', num2str(shant), '_0\SU_CONT_Cb_',Cb_shant_name_short,'_', num2str(shant), '_0.GUI\spike_times.npy']));
                spike_clusters = readNPY([origin_rootpath,animal,'\',param.Spike_path,'\',animal,'-', param.durFiles(day,11:16), '_DAT_files\Cb\',Cb_shant_name,'_', num2str(shant), '\SU_CONT_Cb_',Cb_shant_name_short,'_', num2str(shant), '_0\SU_CONT_Cb_',Cb_shant_name_short,'_', num2str(shant), '_0.GUI\spike_clusters.npy']);
                cluster_info = tdfread([origin_rootpath,animal,'\',param.Spike_path,'\',animal,'-', param.durFiles(day,11:16), '_DAT_files\Cb\',Cb_shant_name,'_', num2str(shant), '\SU_CONT_Cb_',Cb_shant_name_short,'_', num2str(shant), '_0\SU_CONT_Cb_',Cb_shant_name_short,'_', num2str(shant), '_0.GUI\cluster_info.tsv']); 
                dat_shant = (shant*param.Cb_shant_site_num)+1;
                
                if param.Cb_neurons < sum(strcmp(string(cluster_info.group),'good ') | strcmp(string(cluster_info.group),'mua  ') | strcmp(string(cluster_info.group),'good') | strcmp(string(cluster_info.group),'mua '))
                    disp(['param.Cb_neurons needs to be increased to ', num2str(length(unique(spike_clusters)))])
                    param.Cb_neurons = length(unique(spike_clusters));
                    s_err = true;
                elseif ~s_err
                    good_cluster_idxs = (strcmp(string(cluster_info.group),'good ') | strcmp(string(cluster_info.group),'mua  ') | strcmp(string(cluster_info.group),'good') | strcmp(string(cluster_info.group),'mua '));
                    all_good_clusters = cluster_info.cluster_id(good_cluster_idxs);
                    
                    %Sort spiketimes into sub-blocks
                    sb_spike_times = cell(1,size(sub_block_names,1));
                    sb_spike_clusters = cell(1,size(sub_block_names,1));
                    for sub_block = 1:size(sub_block_names,1)
                        chan_SEV = SEV2mat([origin_rootpath,animal,'\',param.Spike_path,'\',sub_block_names(sub_block,:)],'CHANNEL',1);
                        chan_full_wave = chan_SEV.RSn1.data;
                        clear chan_SEV
                        
                        if isempty(chan_full_wave)
                            durMAT(4,sub_block) = durMAT(3,sub_block);
                        else
                            durMAT(4,sub_block) = length(chan_full_wave)/param.Cb_spike_wave_Fs;
                        end
                        
                        sb_spike_times{sub_block} = spike_times(spike_times <= size(chan_full_wave,2));
                        sb_spike_clusters{sub_block} = spike_clusters(1:length(sb_spike_times{sub_block}));
                        spike_clusters(1:length(sb_spike_times{sub_block})) = [];
                        spike_times(1:length(sb_spike_times{sub_block})) = [];
                        spike_times = spike_times - size(chan_full_wave,2);
                        clear chan_full_wave
                        
                        %Truncate
                        sb_spike_times{sub_block}(sb_spike_times{sub_block} > (durMAT(5,sub_block)*param.Cb_spike_wave_Fs)) = [];
                        sb_spike_clusters{sub_block} = sb_spike_clusters{sub_block}(1:length(sb_spike_times{sub_block}));
                        
                        
                    end
                    
                    for sub_block = 1:size(sub_block_names,1)
                        
                        if extract_waveforms
                            clear sb_full_wave
                            fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\',animal,'-', param.durFiles(day,11:16), '_DAT_files\Cb\',Cb_shant_name,'_', num2str(shant), '\SU_CONT_Cb_',Cb_shant_name_short,'_', num2str(shant), '_', num2str(sub_block-1), '.dat'],'r');
                            sb_full_wave = fread(fiD,'float32');
                            sb_full_wave = reshape(sb_full_wave,param.Cb_shant_site_num,length(sb_full_wave)/param.Cb_shant_site_num);
                            fclose(fiD);
                        end
                        
                        %Convert to Seconds and zero to block start
                        for check_block = 1:4
                            sb_ordinal = find(sub_block == sb_idxs{check_block});
                            if ~isempty(sb_ordinal)
                                block = check_block;
                                sb_offset = 0;
                                for prev_sb = 1:(sb_ordinal-1)
                                    sb_offset = sb_offset + durMAT(4,sub_block-prev_sb);
                                end
                                sb_spike_times{sub_block} = sb_spike_times{sub_block}/param.Cb_spike_wave_Fs;
                                sb_spike_times{sub_block} = sb_spike_times{sub_block}+sb_offset;
                            end
                        end
                        
                        if mod(block,2) %sleep blocks
                            load([rootpath,animal,'/Day',num2str(day),'/',param.s_block_names{ceil(block/2)},'/Spike_timestamps.mat']);
                            load([rootpath,animal,'/Day',num2str(day),'/',param.s_block_names{ceil(block/2)},'/Spike_waveforms.mat']);
                        else %training blocks
                            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block/2},'/Spike_timestamps.mat']);
                            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block/2},'/Spike_waveforms.mat']);
                        end
                        
                        for channel = 0:(param.Cb_shant_site_num-1)
                            chan_clusters = cluster_info.ch == channel & good_cluster_idxs;
                            if sum(chan_clusters)
                                
%                                 %From raw
%                                 chan_SEV = SEV2mat([origin_rootpath,animal,'\',param.Spike_path,'\',sub_block_names(sub_block,:)],'CHANNEL',channel+1+param.M1_chans);
%                                 
%                                 %TODO: Median subtraction
%                                 
%                                 % High pass filter
%                                 CutOff_freqs = 300;
%                                 Wn = CutOff_freqs./chan_SEV.RSn1.fs;
%                                 filterOrder = 2;
%                                 [b,a] = butter(filterOrder,Wn,'high');
%                                 chan_full_wave = double(chan_SEV.RSn1.data);
%                                 chan_full_wave = filtfilt(b,a,chan_full_wave);
%                                 
%                                 % Low pass filter
%                                 CutOff_freqs = 5000;
%                                 Wn = CutOff_freqs./chan_SEV.RSn1.fs;
%                                 filterOrder = 2;
%                                 [b,a] = butter(filterOrder,Wn,'low');
%                                 chan_full_wave = filtfilt(b,a,chan_full_wave);
%
%                                 %Change the two 'sb_full_wave's below to 'chan_full_wave' and in the 2nd change 'channel' to '1' in the indexing.
                                
                                cluster_num = 0;
                                for cluster = cluster_info.cluster_id(chan_clusters)'
                                    cluster_num = cluster_num + 1;
                                    cluster_spike_times = sb_spike_times{sub_block}(sb_spike_clusters{sub_block} == cluster);
                                    cluster_spike_waves = nan(30,length(cluster_spike_times));
                                    for i = 1:size(cluster_spike_waves,2)
                                        t_stamp = round(cluster_spike_times(i)*param.Cb_spike_wave_Fs);
                                        if extract_waveforms
                                            if (t_stamp + 22) <= size(sb_full_wave,2) && (t_stamp - 7) > 0
                                                cluster_spike_waves(:,i) = sb_full_wave(channel+1,t_stamp - 7:t_stamp + 22);
                                            end
                                        end
                                    end
                                    
                                    %Concatinate into blocks
                                    cell_idx = find(all_good_clusters == cluster);
                                    Cb_spike_timestamps{dat_shant,cell_idx} = cat(2,Cb_spike_timestamps{dat_shant,cell_idx},cluster_spike_times');
                                    Cb_spike_waves{dat_shant + (channel),cell_idx} = cat(2,Cb_spike_waves{dat_shant + (channel),cell_idx},cluster_spike_waves);
                                    param.Cb_neuron_chans{day}(dat_shant,cell_idx) = channel;
                                    
                                    cluster_groups = cluster_info.group(chan_clusters,:);
                                    if strcmp(cluster_groups(cluster_num,:),'mua  ') || strcmp(cluster_groups(cluster_num,:),'mua ')
                                        param.Cb_mua_neurons{day}(dat_shant,cell_idx) = true;
                                    end
                                end
                            end
                        end
                        
                        if mod(block,2) %sleep blocks
                            save([rootpath,animal,'/Day',num2str(day),'/',param.s_block_names{ceil(block/2)},'/Spike_timestamps.mat'], 'M1_spike_timestamps', 'Cb_spike_timestamps');
                            save([rootpath,animal,'/Day',num2str(day),'/',param.s_block_names{ceil(block/2)},'/Spike_waveforms.mat'], 'M1_spike_waves', 'Cb_spike_waves', '-v7.3');
                        else %training blocks
                            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block/2},'/Spike_timestamps.mat'], 'M1_spike_timestamps', 'Cb_spike_timestamps');
                            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block/2},'/Spike_waveforms.mat'], 'M1_spike_waves', 'Cb_spike_waves', '-v7.3');
                        end
                        
                    end
                end
            end
            clear block_spikes sb_waves sb_chan_full_wave
            
        %end
        clearvars -except code_rootpath rootpath origin_rootpath animal param enabled day s_err M1_shant_name M1_shant_name_short Cb_shant_name Cb_shant_name_short extract_waveforms;
    end
    save([rootpath,animal,'/Parameters.mat'],'param');
    rmpath(genpath('Z:\BMI_Analysis'))
    rmpath(genpath('Z:\Matlab Offline Files SDK'))
    rmpath(genpath([code_rootpath, 'RunSpykingCircusSorter-master']))
    rmpath(genpath('Z:\Matlab for analysis\TDTMatlabSDK\TDTSDK\TDTbin2mat'))
    clear day s_err M1_shant_name M1_shant_name_short Cb_shant_name Cb_shant_name_short;
end

%% Legacy Rename Spike Timestamp Data *DO NOT USE - integrate into (29) as needed*

if false
    error('Bad Block') %#ok<UNRCH>
    addpath(genpath('Z:\BMI_Analysis'))
    addpath(genpath('Z:\Matlab Offline Files SDK'))
    addpath(genpath([code_rootpath, 'RunSpykingCircusSorter-master']))

    param.M1_mua_neurons = cell(5,1);
    param.Cb_mua_neurons = cell(5,1);
    s_err = false;
    
    for day=1:param.days
        if strcmp(animal,'I060')
            param.M1_mua_neurons{day} = zeros(param.M1_chans,param.M1_neurons);
            param.Cb_mua_neurons{day} = zeros(param.Cb_chans,param.Cb_neurons);
            %Super simple, everything is already done
            for block=1:param.blocks
                load([origin_rootpath,animal,'/',param.training_block_names{day, block},'/Timestamps_B',num2str(block),'.mat']);
                load([origin_rootpath,animal,'/',param.training_block_names{day, block},'/Waves_B',num2str(block),'.mat']);
            end
            TimeStamps2_B1(setdiff(1:param.Cb_chans,1:4:param.Cb_chans),:) = cell(24,6); %#ok<SAGROW>
            TimeStamps2_B2(setdiff(1:param.Cb_chans,1:4:param.Cb_chans),:) = cell(24,6); %#ok<SAGROW>
        elseif strcmp(animal,'I061')
            param.M1_neurons = 6;
            param.Cb_neurons = 12;
            
            param.M1_mua_neurons{day} = zeros(param.M1_chans,param.M1_neurons);
            param.Cb_mua_neurons{day} = zeros(param.Cb_chans,param.Cb_neurons);
            
            load([origin_rootpath,animal,'/',param.durFiles(day,:),'.mat']);
            sbn1 = param.sleep_block_names{day, 1};
            sbn1 = sbn1(1,10:end);
            
            %All I061's M1 recordings come from plexon. 
            %Get the day's sorted M1 data 
            [TimeStamps1_day, Waves1_day, ~] = fn_readPlxFile([origin_rootpath,animal,'/PLX_Converted/SORTED_TDT_data_',sbn1,'_eNe1_1_mrg.plx']);
            %Get a 1D list of the day's spike times before sorting
            [TimeStamps1_day_unsort, ~, ~] = fn_readPlxFile([origin_rootpath,animal,'/PLX_Converted/TDT_data_',sbn1,'_eNe1_1_mrg.plx']);
            TimeStamps1_day_unsort = sort([TimeStamps1_day_unsort{:}]);
            
            %The LFP duration is the best aproximation of the spike duration
            durMAT(3,:) = durMAT(1,:);
            
            %Pre-allocation
            TimeStamps1_S1 = cell(32,param.M1_neurons);
            TimeStamps2_S1 = cell(32,param.Cb_neurons);
            TimeStamps1_B1 = cell(32,param.M1_neurons);
            TimeStamps2_B1 = cell(32,param.Cb_neurons);
            TimeStamps1_S2 = cell(32,param.M1_neurons);
            TimeStamps2_S2 = cell(32,param.Cb_neurons);
            TimeStamps1_B2 = cell(32,param.M1_neurons);
            TimeStamps2_B2 = cell(32,param.Cb_neurons);
            
            Waves1_S1 = cell(32,param.M1_neurons);
            Waves2_S1 = cell(32,param.Cb_neurons);
            Waves1_S2 = cell(32,param.M1_neurons);
            Waves2_S2 = cell(32,param.Cb_neurons);
            Waves1_B1 = cell(32,param.M1_neurons);
            Waves2_B1 = cell(32,param.Cb_neurons);
            Waves1_B2 = cell(32,param.M1_neurons);
            Waves2_B2 = cell(32,param.Cb_neurons);
            
            if day == 1
                %On day 1 the cerbellum data comes from plexon too
                %Get the day's sorted Cb data 
                [TimeStamps2_day, Waves2_day, ~] = fn_readPlxFile([origin_rootpath,animal,'/PLX_Converted/SORTED_TDT_data_',sbn1,'_eTe1_1_mrg.plx']);
                %Get a 1D list of the day's spike times before sorting
                [TimeStamps2_day_unsort, ~, ~] = fn_readPlxFile([origin_rootpath,animal,'/PLX_Converted/TDT_data_',sbn1,'_eTe1_1_mrg.plx']);
                TimeStamps2_day_unsort = sort([TimeStamps2_day_unsort{:}]);
                
                %The LFP duration is the best aproximation of the spike duration
                durMAT(4,:) = durMAT(2,:);
                
                %Pre-allocate vectors for the differences between timestamps in sub-block arrays and the day array
                sleep_offset1 = zeros(1,3);
                sleep_offset2 = zeros(1,3);
                train_offset1 = zeros(1,4);
                train_offset2 = zeros(1,4);
                
                %Day 1 has extra sub-blocks so some additional arrays need to be pre-allocated
                TimeStamps1_B3 = cell(32,param.M1_neurons);
                TimeStamps2_B3 = cell(32,param.Cb_neurons);
                TimeStamps1_S3 = cell(32,param.M1_neurons);
                TimeStamps2_S3 = cell(32,param.Cb_neurons);
                TimeStamps1_B4 = cell(32,param.M1_neurons);
                TimeStamps2_B4 = cell(32,param.Cb_neurons);
                
                Waves1_B3 = cell(32,param.M1_neurons);
                Waves2_B3 = cell(32,param.Cb_neurons);
                Waves1_S3 = cell(32,param.M1_neurons);
                Waves2_S3 = cell(32,param.Cb_neurons);
                Waves1_B4 = cell(32,param.M1_neurons);
                Waves2_B4 = cell(32,param.Cb_neurons);
                
                
                slp_idx = 1;
                trn_idx = 1;
                for block=1:2
                    sbn = param.sleep_block_names{day, block};
                    tbn = param.training_block_names{day, block};

                    %Remove the spikes that occured during the sleep block
                    for sub_block = 1:size(sbn,1)
                        %Read the 1D unsorted block data
                        [sleep_timestamps1, ~, ~] = fn_readPlxFile([origin_rootpath,animal,'/PLX_Converted/TDT_data_',sbn(sub_block,10:end),'_eNe1_1.plx']);
                        sleep_timestamps1 = sort([sleep_timestamps1{:}]);
                        [sleep_timestamps2, ~, ~] = fn_readPlxFile([origin_rootpath,animal,'/PLX_Converted/TDT_data_',sbn(sub_block,10:end),'_eTe1_1.plx']);
                        sleep_timestamps2 = sort([sleep_timestamps2{:}]);
                        
                        %Find the difference between the timestamps in the day record and the block record. i.e. The length of all the blocks that came before
                        sleep_offset1(slp_idx) = TimeStamps1_day_unsort(1) - sleep_timestamps1(1);
                        sleep_offset2(slp_idx) = TimeStamps2_day_unsort(1) - sleep_timestamps2(1);
                        
                        %subtract the offset from the unsorted day record
                        TimeStamps1_day_unsort = TimeStamps1_day_unsort - sleep_offset1(slp_idx);
                        TimeStamps2_day_unsort = TimeStamps2_day_unsort - sleep_offset2(slp_idx);
                        
                        %Remove all timestamps in day record that occured within the block
                        TimeStamps1_day_unsort(TimeStamps1_day_unsort <= sleep_timestamps1(end)) = [];
                        TimeStamps2_day_unsort(TimeStamps2_day_unsort <= sleep_timestamps2(end)) = [];
                        
                        slp_idx = slp_idx + 1;
                    end
                    
                    %Remove the spikes that occured during the training block
                    if block == 1 %Do ommited sub-block
                        %Read the 1D unsorted block data
                        [train_timestamps1, ~, ~] = fn_readPlxFile([origin_rootpath,animal,'/PLX_Converted/TDT_data_I061-200511-134729_eNe1_1.plx']);
                        train_timestamps1 = sort([train_timestamps1{:}]);
                        [train_timestamps2, ~, ~] = fn_readPlxFile([origin_rootpath,animal,'/PLX_Converted/TDT_data_I061-200511-134729_eTe1_1.plx']);
                        train_timestamps2 = sort([train_timestamps2{:}]);
                        
                        %Find the difference between the timestamps in the day record and the block record. i.e. The length of all the blocks that came before
                        train_offset1(trn_idx) = TimeStamps1_day_unsort(1) - train_timestamps1(1);
                        train_offset2(trn_idx) = TimeStamps2_day_unsort(1) - train_timestamps2(1);
                        
                        %subtract the offset from the sorted day record
                        TimeStamps1_day_unsort = TimeStamps1_day_unsort - train_offset1(trn_idx);
                        TimeStamps2_day_unsort = TimeStamps2_day_unsort - train_offset2(trn_idx);
                        
                        %Remove all timestamps in day record that occured within the block
                        TimeStamps1_day_unsort(TimeStamps1_day_unsort <= train_timestamps1(end)) = [];
                        TimeStamps2_day_unsort(TimeStamps2_day_unsort <= train_timestamps2(end)) = [];
                        
                        trn_idx = trn_idx + 1;
                    end
                    for sub_block = 1:size(tbn,1)
                        %Read the 1D unsorted block data
                        [train_timestamps1, ~, ~] = fn_readPlxFile([origin_rootpath,animal,'/PLX_Converted/TDT_data_',tbn(sub_block,10:end),'_eNe1_1.plx']);
                        train_timestamps1 = sort([train_timestamps1{:}]);
                        [train_timestamps2, ~, ~] = fn_readPlxFile([origin_rootpath,animal,'/PLX_Converted/TDT_data_',tbn(sub_block,10:end),'_eNe1_1.plx']);
                        train_timestamps2 = sort([train_timestamps2{:}]);
                        
                        %Find the difference between the timestamps in the day record and the block record. i.e. The length of all the blocks that came before
                        train_offset1(trn_idx) = TimeStamps1_day_unsort(1) - train_timestamps1(1);
                        train_offset2(trn_idx) = TimeStamps2_day_unsort(1) - train_timestamps2(1);
                        
                        %subtract the offset from the sorted day record
                        TimeStamps1_day_unsort = TimeStamps1_day_unsort - train_offset1(trn_idx);
                        TimeStamps2_day_unsort = TimeStamps2_day_unsort - train_offset2(trn_idx);
                        
                        %Remove all timestamps in day record that occured within the block
                        TimeStamps1_day_unsort(TimeStamps1_day_unsort <= train_timestamps1(end)) = [];
                        TimeStamps2_day_unsort(TimeStamps2_day_unsort <= train_timestamps2(end)) = [];
                        
                        trn_idx = trn_idx + 1;
                    end
                end
                %Use offset values and sorted, merged timestamp array to create arrays of sorted timestamps for each sub-block
                for i = 1:length(TimeStamps1_S1(:))
                    TimeStamps1_day{i} = TimeStamps1_day{i} - sleep_offset1(1);
                    TimeStamps1_S1{i} = TimeStamps1_day{i}(TimeStamps1_day{i} >= 0 & TimeStamps1_day{i} < sleep_offset1(2));
                    TimeStamps1_day{i} = TimeStamps1_day{i} - sleep_offset1(2);
                    TimeStamps1_S2{i} = TimeStamps1_day{i}(TimeStamps1_day{i} >= 0 & TimeStamps1_day{i} < train_offset1(1));
                    TimeStamps1_day{i} = TimeStamps1_day{i} - train_offset1(1);
                    TimeStamps1_B1{i} = TimeStamps1_day{i}(TimeStamps1_day{i} >= 0 & TimeStamps1_day{i} < train_offset1(2));
                    TimeStamps1_day{i} = TimeStamps1_day{i} - train_offset1(2);
                    TimeStamps1_B2{i} = TimeStamps1_day{i}(TimeStamps1_day{i} >= 0 & TimeStamps1_day{i} < train_offset1(3));
                    TimeStamps1_day{i} = TimeStamps1_day{i} - train_offset1(3);
                    TimeStamps1_B3{i} = TimeStamps1_day{i}(TimeStamps1_day{i} >= 0 & TimeStamps1_day{i} < sleep_offset1(3));
                    TimeStamps1_day{i} = TimeStamps1_day{i} - sleep_offset1(3);
                    TimeStamps1_S3{i} = TimeStamps1_day{i}(TimeStamps1_day{i} >= 0 & TimeStamps1_day{i} < train_offset1(4));
                    TimeStamps1_day{i} = TimeStamps1_day{i} - train_offset1(4);
                    TimeStamps1_B4{i} = TimeStamps1_day{i}(TimeStamps1_day{i} >= 0);
                    
                    Waves1_S1{i} = Waves1_day{i}(:,1:length(TimeStamps1_S1{i}));
                    if ~isempty(Waves1_S1{i})
                        Waves1_day{i}(:,1:length(TimeStamps1_S1{i})) = [];
                    end
                    Waves1_S2{i} = Waves1_day{i}(:,1:length(TimeStamps1_S2{i}));
                    if ~isempty(Waves1_S2{i})
                        Waves1_day{i}(:,1:length(TimeStamps1_S2{i})) = [];
                    end
                    Waves1_B1{i} = Waves1_day{i}(:,1:length(TimeStamps1_B1{i}));
                    if ~isempty(Waves1_B1{i})
                        Waves1_day{i}(:,1:length(TimeStamps1_B1{i})) = [];
                    end
                    Waves1_B2{i} = Waves1_day{i}(:,1:length(TimeStamps1_B2{i}));
                    if ~isempty(Waves1_B2{i})
                        Waves1_day{i}(:,1:length(TimeStamps1_B2{i})) = [];
                    end
                    Waves1_B3{i} = Waves1_day{i}(:,1:length(TimeStamps1_B3{i}));
                    if ~isempty(Waves1_B3{i})
                        Waves1_day{i}(:,1:length(TimeStamps1_B3{i})) = [];
                    end
                    Waves1_S3{i} = Waves1_day{i}(:,1:length(TimeStamps1_S3{i}));
                    if ~isempty(Waves1_S3{i})
                        Waves1_day{i}(:,1:length(TimeStamps1_S3{i})) = [];
                    end
                    Waves1_B4{i} = Waves1_day{i}(:,1:length(TimeStamps1_B4{i}));
                    if ~isempty(Waves1_B4{i})
                        Waves1_day{i}(:,1:length(TimeStamps1_B4{i})) = [];
                    end
                    
                    TimeStamps2_day{i} = TimeStamps2_day{i} - sleep_offset2(1);
                    TimeStamps2_S1{i} = TimeStamps2_day{i}(TimeStamps2_day{i} >= 0 & TimeStamps2_day{i} < sleep_offset2(2));
                    TimeStamps2_day{i} = TimeStamps2_day{i} - sleep_offset2(2);
                    TimeStamps2_S2{i} = TimeStamps2_day{i}(TimeStamps2_day{i} >= 0 & TimeStamps2_day{i} < train_offset2(1));
                    TimeStamps2_day{i} = TimeStamps2_day{i} - train_offset2(1);
                    TimeStamps2_B1{i} = TimeStamps2_day{i}(TimeStamps2_day{i} >= 0 & TimeStamps2_day{i} < train_offset2(2));
                    TimeStamps2_day{i} = TimeStamps2_day{i} - train_offset2(2);
                    TimeStamps2_B2{i} = TimeStamps2_day{i}(TimeStamps2_day{i} >= 0 & TimeStamps2_day{i} < train_offset2(3));
                    TimeStamps2_day{i} = TimeStamps2_day{i} - train_offset2(3);
                    TimeStamps2_B3{i} = TimeStamps2_day{i}(TimeStamps2_day{i} >= 0 & TimeStamps2_day{i} < sleep_offset2(3));
                    TimeStamps2_day{i} = TimeStamps2_day{i} - sleep_offset2(3);
                    TimeStamps2_S3{i} = TimeStamps2_day{i}(TimeStamps2_day{i} >= 0 & TimeStamps2_day{i} < train_offset2(4));
                    TimeStamps2_day{i} = TimeStamps2_day{i} - train_offset2(4);
                    TimeStamps2_B4{i} = TimeStamps2_day{i}(TimeStamps2_day{i} >= 0);
                    
                    Waves2_S1{i} = Waves2_day{i}(:,1:length(TimeStamps2_S1{i}));
                    if ~isempty(Waves2_S1{i})
                        Waves2_day{i}(:,1:length(TimeStamps2_S1{i})) = [];
                    end
                    Waves2_S2{i} = Waves2_day{i}(:,1:length(TimeStamps2_S2{i}));
                    if ~isempty(Waves2_S2{i})
                        Waves2_day{i}(:,1:length(TimeStamps2_S2{i})) = [];
                    end
                    Waves2_B1{i} = Waves2_day{i}(:,1:length(TimeStamps2_B1{i}));
                    if ~isempty(Waves2_B1{i})
                        Waves2_day{i}(:,1:length(TimeStamps2_B1{i})) = [];
                    end
                    Waves2_B2{i} = Waves2_day{i}(:,1:length(TimeStamps2_B2{i}));
                    if ~isempty(Waves2_B2{i})
                        Waves2_day{i}(:,1:length(TimeStamps2_B2{i})) = [];
                    end
                    Waves2_B3{i} = Waves2_day{i}(:,1:length(TimeStamps2_B3{i}));
                    if ~isempty(Waves2_B3{i})
                        Waves2_day{i}(:,1:length(TimeStamps2_B3{i})) = [];
                    end
                    Waves2_S3{i} = Waves2_day{i}(:,1:length(TimeStamps2_S3{i}));
                    if ~isempty(Waves2_S3{i})
                        Waves2_day{i}(:,1:length(TimeStamps2_S3{i})) = [];
                    end
                    Waves2_B4{i} = Waves2_day{i}(:,1:length(TimeStamps2_B4{i}));
                    if ~isempty(Waves2_B4{i})
                        Waves2_day{i}(:,1:length(TimeStamps2_B4{i})) = [];
                    end
                end
                %Rename the sub-blocks to match parameters and DurMAT
                
                TimeStamps1_B1 = TimeStamps1_B2;
                TimeStamps2_B1 = TimeStamps2_B2;
                TimeStamps1_B2 = TimeStamps1_B3;
                TimeStamps2_B2 = TimeStamps2_B3;
                TimeStamps1_B3 = TimeStamps1_B4;
                TimeStamps2_B3 = TimeStamps2_B4;
                
                Waves1_B1 = Waves1_B2;
                Waves2_B1 = Waves2_B2;
                Waves1_B2 = Waves1_B3;
                Waves2_B2 = Waves2_B3;
                Waves1_B3 = Waves1_B4;
                Waves2_B3 = Waves2_B4;
                
                clear Waves1_B4 Waves2_B4 TimeStamps1_B4 TimeStamps2_B4;
                
                %save data in source directory
                B_idx = 1;
                for block = 1:size(param.training_block_names,2)
                    for sBlock = 1:size(param.training_block_names{day,block},1)
                        save([origin_rootpath,animal,'/',param.training_block_names{day, block}(sBlock,:),'/Timestamps_B',num2str(B_idx),'.mat'], ['TimeStamps1_B', num2str(B_idx)], ['TimeStamps2_B', num2str(B_idx)]);
                        save([origin_rootpath,animal,'/',param.training_block_names{day, block}(sBlock,:),'/Waves_B',num2str(B_idx),'.mat'], ['Waves1_B', num2str(B_idx)], ['Waves2_B', num2str(B_idx)]);
                    end
                end
                
                %Truncate spiketimes and waves
                for n_idx = 1:length(TimeStamps1_B1(:))
                    if ~isempty(TimeStamps1_B1{n_idx})
                        TimeStamps1_B1{n_idx} = TimeStamps1_B1{n_idx}(TimeStamps1_B1{n_idx} <= (durMAT(5,3) * param.M1_spike_wave_Fs));
                        Waves1_B1{n_idx} = Waves1_B1{n_idx}(:,TimeStamps1_B1{n_idx} <= (durMAT(5,3) * param.M1_spike_wave_Fs));
                    end
                    
                    if ~isempty(TimeStamps1_B2{n_idx})
                        TimeStamps1_B1{n_idx} = [TimeStamps1_B1{n_idx}, TimeStamps1_B2{n_idx}(TimeStamps1_B2{n_idx} <= (durMAT(5,4) * param.M1_spike_wave_Fs))];
                        Waves1_B1{n_idx} = cat(2, Waves1_B1{n_idx}, Waves1_B2{n_idx}(:,TimeStamps1_B2{n_idx} <= (durMAT(5,4) * param.M1_spike_wave_Fs)));
                    end
                end
                for n_idx = 1:length(TimeStamps2_B1(:))
                    if ~isempty(TimeStamps2_B1{n_idx})
                        TimeStamps2_B1{n_idx} = TimeStamps2_B1{n_idx}(TimeStamps2_B1{n_idx} <= (durMAT(5,3) * param.Cb_spike_wave_Fs));
                        Waves2_B1{n_idx} = Waves2_B1{n_idx}(:,TimeStamps2_B1{n_idx} <= (durMAT(5,3) * param.Cb_spike_wave_Fs));
                    end
                    
                    if ~isempty(TimeStamps2_B2{n_idx})
                        TimeStamps2_B1{n_idx} = [TimeStamps2_B1{n_idx}, TimeStamps2_B2{n_idx}(TimeStamps2_B2{n_idx} <= (durMAT(5,4) * param.Cb_spike_wave_Fs))];
                        Waves2_B1{n_idx} = cat(2, Waves2_B1{n_idx}, Waves2_B2{n_idx}(:,TimeStamps2_B2{n_idx} <= (durMAT(5,4) * param.Cb_spike_wave_Fs)));
                    end
                end
                
                TimeStamps1_B2 = TimeStamps1_B3;
                Waves1_B2 = Waves1_B3;
                for n_idx = 1:length(TimeStamps1_B2(:))
                    if ~isempty(TimeStamps1_B2{n_idx})
                        TimeStamps1_B2{n_idx} = TimeStamps1_B2{n_idx}(TimeStamps1_B2{n_idx} <= (durMAT(5,6) * param.M1_spike_wave_Fs));
                        Waves1_B2{n_idx} = Waves1_B2{n_idx}(:,(TimeStamps1_B2{n_idx} <= (durMAT(5,6) * param.M1_spike_wave_Fs)));
                    end
                end
                
                TimeStamps2_B2 = TimeStamps2_B3;
                Waves2_B2 = Waves2_B3;
                for n_idx = 1:length(TimeStamps2_B2(:))
                    if ~isempty(TimeStamps2_B2{n_idx})
                        TimeStamps2_B2{n_idx} = TimeStamps2_B2{n_idx}(TimeStamps2_B2{n_idx} <= (durMAT(5,6) * param.Cb_spike_wave_Fs));
                        Waves2_B2{n_idx} = Waves2_B2{n_idx}(:,(TimeStamps2_B2{n_idx} <= (durMAT(5,6) * param.Cb_spike_wave_Fs)));
                    end
                end
                TimeStamps2_B1(setdiff(1:param.Cb_chans,1:4:param.Cb_chans),:) = cell(24,param.Cb_neurons);
                TimeStamps2_B2(setdiff(1:param.Cb_chans,1:4:param.Cb_chans),:) = cell(24,param.Cb_neurons);
            else
                %Procedure for Days 2-5
                
                %Do the M1 plexon part
                sleep_offset1 = zeros(1,2);
                train_offset1 = zeros(1,2);
                slp_idx = 1;
                trn_idx = 1;
                for block=1:2
                    sbn = param.sleep_block_names{day, block};
                    tbn = param.training_block_names{day, block};

                    %Remove the spikes that occured during the sleep block
                    for sub_block = 1:size(sbn,1)
                        %Read the 1D unsorted block data
                        [sleep_timestamps1, ~, ~] = fn_readPlxFile([origin_rootpath,animal,'/PLX_Converted/TDT_data_',sbn(sub_block,10:end),'_eNe1_1.plx']);
                        sleep_timestamps1 = sort([sleep_timestamps1{:}]);
                        
                         %Find the difference between the timestamps in the day record and the block record. i.e. The length of all the blocks that came before
                        sleep_offset1(slp_idx) = TimeStamps1_day_unsort(1) - sleep_timestamps1(1);
                        
                        %subtract the offset from the unsorted day record
                        TimeStamps1_day_unsort = TimeStamps1_day_unsort - sleep_offset1(slp_idx);
                        
                        %Remove all timestamps in day record that occured within the block
                        TimeStamps1_day_unsort(TimeStamps1_day_unsort <= sleep_timestamps1(end)) = [];
                        
                        slp_idx = slp_idx + 1;
                    end
                    
                    %Remove the spikes that occured during the training block
                    for sub_block = 1:size(tbn,1)
                        %Read the 1D unsorted block data
                        [train_timestamps1, ~, ~] = fn_readPlxFile([origin_rootpath,animal,'/PLX_Converted/TDT_data_',tbn(sub_block,10:end),'_eNe1_1.plx']);
                        train_timestamps1 = sort([train_timestamps1{:}]);
                        
                        %Find the difference between the timestamps in the day record and the block record. i.e. The length of all the blocks that came before
                        train_offset1(trn_idx) = TimeStamps1_day_unsort(1) - train_timestamps1(1);
                        
                        %subtract the offset from the sorted day record
                        TimeStamps1_day_unsort = TimeStamps1_day_unsort - train_offset1(trn_idx);
                        
                        %Remove all timestamps in day record that occured within the block
                        TimeStamps1_day_unsort(TimeStamps1_day_unsort <= train_timestamps1(end)) = [];
                        
                        trn_idx = trn_idx + 1;
                    end
                end
                
                %Use offset values and sorted, merged timestamp array to create arrays of sorted timestamps for each sub-block
                for i = 1:length(TimeStamps1_S1(:))
                    TimeStamps1_day{i} = TimeStamps1_day{i} - sleep_offset1(1);
                    TimeStamps1_S1{i} = TimeStamps1_day{i}(TimeStamps1_day{i} >= 0 & TimeStamps1_day{i} < train_offset1(1));
                    TimeStamps1_day{i} = TimeStamps1_day{i} - train_offset1(1);
                    TimeStamps1_B1{i} = TimeStamps1_day{i}(TimeStamps1_day{i} >= 0 & TimeStamps1_day{i} < sleep_offset1(2));
                    TimeStamps1_day{i} = TimeStamps1_day{i} - sleep_offset1(2);
                    TimeStamps1_S2{i} = TimeStamps1_day{i}(TimeStamps1_day{i} >= 0 & TimeStamps1_day{i} < train_offset1(2));
                    TimeStamps1_day{i} = TimeStamps1_day{i} - train_offset1(2);
                    TimeStamps1_B2{i} = TimeStamps1_day{i}(TimeStamps1_day{i} >= 0);
                    
                    Waves1_S1{i} = Waves1_day{i}(:,1:length(TimeStamps1_S1{i}));
                    if ~isempty(Waves1_S1{i})
                        Waves1_day{i}(:,1:length(TimeStamps1_S1{i})) = [];
                    end
                    Waves1_B1{i} = Waves1_day{i}(:,1:length(TimeStamps1_B1{i}));
                    if ~isempty(Waves1_B1{i})
                        Waves1_day{i}(:,1:length(TimeStamps1_B1{i})) = [];
                    end
                    Waves1_S2{i} = Waves1_day{i}(:,1:length(TimeStamps1_S2{i}));
                    if ~isempty(Waves1_S2{i})
                        Waves1_day{i}(:,1:length(TimeStamps1_S2{i})) = [];
                    end
                    Waves1_B2{i} = Waves1_day{i}(:,1:length(TimeStamps1_B2{i}));
                    if ~isempty(Waves1_B2{i})
                        Waves1_day{i}(:,1:length(TimeStamps1_B2{i})) = [];
                    end
                end
                
                %Do the Cb npy and dat part
                %Data is separated into tetrodes. Extract block durations from full-block waveform data
                for chan = 0:7
                    spike_times = double(readNPY([origin_rootpath,animal,'\TDT_Data\TDT_data\I061-', param.durFiles(day,11:16), '_DAT_files\Cb\Tetrode_', num2str(chan), '\SU_CONT_Cb_tet_', num2str(chan), '_0\SU_CONT_Cb_tet_', num2str(chan), '_0.GUI\spike_times.npy']));
                    spike_clusters = readNPY([origin_rootpath,animal,'\TDT_Data\TDT_data\I061-', param.durFiles(day,11:16), '_DAT_files\Cb\Tetrode_', num2str(chan), '\SU_CONT_Cb_tet_', num2str(chan), '_0\SU_CONT_Cb_tet_', num2str(chan), '_0.GUI\spike_clusters.npy']);
                    cluster_info = tdfread([origin_rootpath,animal,'\TDT_Data\TDT_data\I061-', param.durFiles(day,11:16), '_DAT_files\Cb\Tetrode_', num2str(chan), '\SU_CONT_Cb_tet_', num2str(chan), '_0\SU_CONT_Cb_tet_', num2str(chan), '_0.GUI\cluster_info.tsv']);
                    
                    if (param.Cb_neurons - 1) < max(spike_clusters)
                        error(['param.Cb_neurons needs to be increased to ', num2str(max(spike_clusters)+1)])
                    end
                    
                    %get waveforms
                    fiD = fopen([origin_rootpath,animal,'\TDT_Data\TDT_data\I061-', param.durFiles(day,11:16), '_DAT_files\Cb\Tetrode_', num2str(chan), '\SU_CONT_Cb_tet_', num2str(chan), '_0.dat'],'r');
                    chan_full_wave_S1 = fread(fiD,'float32');
                    chan_full_wave_S1 = reshape(chan_full_wave_S1,4,length(chan_full_wave_S1)/4);
                    fiD = fopen([origin_rootpath,animal,'\TDT_Data\TDT_data\I061-', param.durFiles(day,11:16), '_DAT_files\Cb\Tetrode_', num2str(chan), '\SU_CONT_Cb_tet_', num2str(chan), '_1.dat'],'r');
                    chan_full_wave_B1 = fread(fiD,'float32');
                    chan_full_wave_B1 = reshape(chan_full_wave_B1,4,length(chan_full_wave_B1)/4);
                    fiD = fopen([origin_rootpath,animal,'\TDT_Data\TDT_data\I061-', param.durFiles(day,11:16), '_DAT_files\Cb\Tetrode_', num2str(chan), '\SU_CONT_Cb_tet_', num2str(chan), '_2.dat'],'r');
                    chan_full_wave_S2 = fread(fiD,'float32');
                    chan_full_wave_S2 = reshape(chan_full_wave_S2,4,length(chan_full_wave_S2)/4);
                    fiD = fopen([origin_rootpath,animal,'\TDT_Data\TDT_data\I061-', param.durFiles(day,11:16), '_DAT_files\Cb\Tetrode_', num2str(chan), '\SU_CONT_Cb_tet_', num2str(chan), '_3.dat'],'r');
                    chan_full_wave_B2 = fread(fiD,'float32');
                    chan_full_wave_B2 = reshape(chan_full_wave_B2,4,length(chan_full_wave_B2)/4);
                                                            
                    %Set durMAT for Cb spikes
                    durMAT(4,:) = [length(chan_full_wave_S1), length(chan_full_wave_B1), length(chan_full_wave_S2), length(chan_full_wave_B2)];
                    
                    %sort spiketimes into blocks
                    spike_times_S1 = spike_times(spike_times <= size(chan_full_wave_S1,2));
                    spike_clusters_S1 = spike_clusters(1:length(spike_times_S1));
                    spike_clusters(1:length(spike_times_S1)) = [];
                    spike_times(1:length(spike_times_S1)) = [];
                    spike_times = spike_times - size(chan_full_wave_S1,2);
                    
                    spike_times_B1 = spike_times(spike_times <= size(chan_full_wave_B1,2));
                    spike_clusters_B1 = spike_clusters(1:length(spike_times_B1));
                    spike_clusters(1:length(spike_times_B1)) = [];
                    spike_times(1:length(spike_times_B1)) = [];
                    spike_times = spike_times - size(chan_full_wave_B1,2);
                    
                    spike_times_S2 = spike_times(spike_times <= size(chan_full_wave_S2,2));
                    spike_clusters_S2 = spike_clusters(1:length(spike_times_S2));
                    spike_clusters(1:length(spike_times_S2)) = [];
                    spike_times(1:length(spike_times_S2)) = [];
                    spike_times = spike_times - size(chan_full_wave_S2,2);
                    
                    spike_times_B2 = spike_times(spike_times <= size(chan_full_wave_B2,2));
                    spike_clusters_B2 = spike_clusters(1:length(spike_times_B2));
                    
                    %sort timestamps into neurons
                    dat_chan = (chan*4)+1;
                    for neuron = 1:param.Cb_neurons
                        
                        if size(cluster_info.group,1) >= neuron && (strcmp(cluster_info.group(neuron,:),'good ') || strcmp(cluster_info.group(neuron,:),'mua  '))
                            if strcmp(cluster_info.group(neuron,:),'mua  ')
                                param.Cb_mua_neurons{day}(dat_chan,neuron) = 1;
                            end
                            TimeStamps2_S1{dat_chan,neuron} = spike_times_S1(spike_clusters_S1 == (neuron-1))';
                            TimeStamps2_B1{dat_chan,neuron} = spike_times_B1(spike_clusters_B1 == (neuron-1))';
                            TimeStamps2_S2{dat_chan,neuron} = spike_times_S2(spike_clusters_S2 == (neuron-1))';
                            TimeStamps2_B2{dat_chan,neuron} = spike_times_B2(spike_clusters_B2 == (neuron-1))';
                        end
                        
                        %sort waveforms into the sub-channels of the neuron's tetrode 
                        for sub_chan = 0:3
                            
                            Waves2_S1{dat_chan + sub_chan,neuron} = zeros(30,length(TimeStamps2_S1{dat_chan,neuron}));
                            for i = 1:length(TimeStamps2_S1{dat_chan,neuron})
                                t_stamp = TimeStamps2_S1{dat_chan,neuron}(i);
                                if (t_stamp + 22) <= size(chan_full_wave_S1,2) && (t_stamp - 7) > 0
                                    Waves2_S1{dat_chan + sub_chan,neuron}(:,i) = chan_full_wave_S1(sub_chan+1,t_stamp - 7:t_stamp + 22);
                                end
                            end
                            
                            Waves2_B1{dat_chan + sub_chan,neuron} = zeros(30,length(TimeStamps2_B1{dat_chan,neuron}));
                            for i = 1:length(TimeStamps2_B1{dat_chan,neuron})
                                t_stamp = TimeStamps2_B1{dat_chan,neuron}(i);
                                if (t_stamp + 22) <= size(chan_full_wave_B1,2) && (t_stamp - 7) > 0
                                    Waves2_B1{dat_chan + sub_chan,neuron}(:,i) = chan_full_wave_B1(sub_chan+1,t_stamp - 7:t_stamp + 22);
                                end
                            end
                            
                            Waves2_S2{dat_chan + sub_chan,neuron} = zeros(30,length(TimeStamps2_S2{dat_chan,neuron}));
                            for i = 1:length(TimeStamps2_S2{dat_chan,neuron})
                                t_stamp = TimeStamps2_S2{dat_chan,neuron}(i);
                                if (t_stamp + 22) <= size(chan_full_wave_S2,2) && (t_stamp - 7) > 0
                                    Waves2_S2{dat_chan + sub_chan,neuron}(:,i) = chan_full_wave_S2(sub_chan+1,t_stamp - 7:t_stamp + 22);
                                end
                            end
                            
                            Waves2_B2{dat_chan + sub_chan,neuron} = zeros(30,length(TimeStamps2_B2{dat_chan,neuron}));
                            for i = 1:length(TimeStamps2_B2{dat_chan,neuron})
                                t_stamp = TimeStamps2_B2{dat_chan,neuron}(i);
                                if (t_stamp + 22) <= size(chan_full_wave_B2,2) && (t_stamp - 7) > 0
                                    Waves2_B2{dat_chan + sub_chan,neuron}(:,i) = chan_full_wave_B2(sub_chan+1,t_stamp - 7:t_stamp + 22);
                                end
                            end
                        end
                        TimeStamps2_S1{dat_chan,neuron} = TimeStamps2_S1{dat_chan,neuron}/param.Cb_spike_wave_Fs;
                        TimeStamps2_B1{dat_chan,neuron} = TimeStamps2_B1{dat_chan,neuron}/param.Cb_spike_wave_Fs;
                        TimeStamps2_S2{dat_chan,neuron} = TimeStamps2_S2{dat_chan,neuron}/param.Cb_spike_wave_Fs;
                        TimeStamps2_B2{dat_chan,neuron} = TimeStamps2_B2{dat_chan,neuron}/param.Cb_spike_wave_Fs;
                    end
                end
                
                %save data in source directory
                for block = 1:size(param.training_block_names,2)
                    save([origin_rootpath,animal,'/',param.training_block_names{day, block},'/Timestamps_B',num2str(block),'.mat'], ['TimeStamps1_B', num2str(block)], ['TimeStamps2_B', num2str(block)]);
                    save([origin_rootpath,animal,'/',param.training_block_names{day, block},'/Waves_B',num2str(block),'.mat'], ['Waves1_B', num2str(block)], ['Waves2_B', num2str(block)], '-v7.3');
                end
                
                %Truncate spiketimes and waves
                for n_idx = 1:length(TimeStamps1_B1(:))
                    if ~isempty(TimeStamps1_B1{n_idx})
                        TimeStamps1_B1{n_idx} = TimeStamps1_B1{n_idx}(TimeStamps1_B1{n_idx} <= durMAT(5,2));
                        Waves1_B1{n_idx} = Waves1_B1{n_idx}(:,(TimeStamps1_B1{n_idx} <= durMAT(5,2)));
                    end
                end
                for n_idx = 1:length(TimeStamps2_B1(:))
                    if ~isempty(TimeStamps2_B1{n_idx})
                        TimeStamps2_B1{n_idx} = TimeStamps2_B1{n_idx}(TimeStamps2_B1{n_idx} <= durMAT(5,2));
                        Waves2_B1{n_idx} = Waves2_B1{n_idx}(:,(TimeStamps2_B1{n_idx} <= durMAT(5,2)));
                        Waves2_B1{n_idx+1} = Waves2_B1{n_idx+1}(:,(TimeStamps2_B1{n_idx} <= durMAT(5,2)));
                        Waves2_B1{n_idx+2} = Waves2_B1{n_idx+2}(:,(TimeStamps2_B1{n_idx} <= durMAT(5,2)));
                        Waves2_B1{n_idx+3} = Waves2_B1{n_idx+3}(:,(TimeStamps2_B1{n_idx} <= durMAT(5,2)));
                    end
                end
                for n_idx = 1:length(TimeStamps1_B2(:))
                    if ~isempty(TimeStamps1_B2{n_idx})
                        TimeStamps1_B2{n_idx} = TimeStamps1_B2{n_idx}(TimeStamps1_B2{n_idx} <= durMAT(5,4));
                        Waves1_B2{n_idx} = Waves1_B2{n_idx}(:,(TimeStamps1_B2{n_idx} <= durMAT(5,4)));
                    end
                end
                for n_idx = 1:length(TimeStamps1_B2(:))
                    if ~isempty(TimeStamps2_B2{n_idx})
                        TimeStamps2_B2{n_idx} = TimeStamps2_B2{n_idx}(TimeStamps2_B2{n_idx} <= durMAT(5,4));
                        Waves2_B2{n_idx} = Waves2_B2{n_idx}(:,(TimeStamps2_B2{n_idx} <= (durMAT(5,4) * param.Cb_spike_wave_Fs)));
                        Waves2_B2{n_idx+1} = Waves2_B2{n_idx+1}(:,(TimeStamps2_B2{n_idx} <= durMAT(5,4)));
                        Waves2_B2{n_idx+2} = Waves2_B2{n_idx+2}(:,(TimeStamps2_B2{n_idx} <= durMAT(5,4)));
                        Waves2_B2{n_idx+3} = Waves2_B2{n_idx+3}(:,(TimeStamps2_B2{n_idx} <= durMAT(5,4)));
                    end
                end
                
            end 
        elseif strcmp(animal,'I076')
            param.M1_neurons = 31;
            param.Cb_neurons = 30;
            
            param.M1_mua_neurons{day} = zeros(param.M1_chans,param.M1_neurons);
            param.M1_neuron_chans{day} = nan(param.M1_chans,param.M1_neurons);
            param.Cb_mua_neurons{day} = zeros(param.Cb_chans,param.Cb_neurons);
            param.Cb_neuron_chans{day} = nan(param.Cb_chans,param.Cb_neurons);
            
            load([origin_rootpath,animal,'/',param.durFiles(day,:),'.mat']);
            sbn1 = param.sleep_block_names{day, 1};
            sbn1 = sbn1(1,10:end);
            
            %The LFP duration is the best aproximation of the spike duration
            durMAT(3,:) = durMAT(1,:);
            
            %Pre-allocation
            TimeStamps1_S1 = cell(32,param.M1_neurons);
            TimeStamps2_S1 = cell(64,param.Cb_neurons);
            TimeStamps1_B1 = cell(32,param.M1_neurons);
            TimeStamps2_B1 = cell(64,param.Cb_neurons);
            TimeStamps1_S2 = cell(32,param.M1_neurons);
            TimeStamps2_S2 = cell(64,param.Cb_neurons);
            TimeStamps1_B2 = cell(32,param.M1_neurons);
            TimeStamps2_B2 = cell(64,param.Cb_neurons);
            
            Waves1_S1 = cell(32,param.M1_neurons);
            Waves2_S1 = cell(64,param.Cb_neurons);
            Waves1_S2 = cell(32,param.M1_neurons);
            Waves2_S2 = cell(64,param.Cb_neurons);
            Waves1_B1 = cell(32,param.M1_neurons);
            Waves2_B1 = cell(64,param.Cb_neurons);
            Waves1_B2 = cell(32,param.M1_neurons);
            Waves2_B2 = cell(64,param.Cb_neurons);
            
            %M1 spike times
            for chan = 0:31
                spike_times = double(readNPY([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_0\SU_CONT_M1_Ch_', num2str(chan), '_0.GUI\spike_times.npy']));
                spike_clusters = readNPY([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_0\SU_CONT_M1_Ch_', num2str(chan), '_0.GUI\spike_clusters.npy']);
                cluster_info = tdfread([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_0\SU_CONT_M1_Ch_', num2str(chan), '_0.GUI\cluster_info.tsv']);
                
                if (param.M1_neurons - 1) < max(spike_clusters)
                    error(['param.M1_neurons needs to be increased to ', num2str(max(spike_clusters)+1)])
                end
                
                %get waveforms
                if day == 1
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_2.dat'],'r');
                    chan_full_wave_S1 = fread(fiD,'float32');
                    chan_full_wave_S1 = reshape(chan_full_wave_S1,1,length(chan_full_wave_S1)/1);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_4.dat'],'r');
                    chan_full_wave_B1 = fread(fiD,'float32');
                    chan_full_wave_B1 = reshape(chan_full_wave_B1,1,length(chan_full_wave_B1)/1);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_5.dat'],'r');
                    chan_full_wave_S2 = fread(fiD,'float32');
                    chan_full_wave_S2 = reshape(chan_full_wave_S2,1,length(chan_full_wave_S2)/1);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_6.dat'],'r');
                    chan_full_wave_B2 = fread(fiD,'float32');
                    chan_full_wave_B2 = reshape(chan_full_wave_B2,1,length(chan_full_wave_B2)/1);
                    fclose(fiD);
                    
                    %Get the false-start blocks so that those parts can be removed from the spike train
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_0.dat'],'r');
                    chan_full_wave_bad1 = fread(fiD,'float32');
                    chan_full_wave_bad1 = reshape(chan_full_wave_bad1,1,length(chan_full_wave_bad1)/1);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_1.dat'],'r');
                    chan_full_wave_bad2 = fread(fiD,'float32');
                    chan_full_wave_bad2 = reshape(chan_full_wave_bad2,1,length(chan_full_wave_bad2)/1);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_3.dat'],'r');
                    chan_full_wave_bad3 = fread(fiD,'float32');
                    chan_full_wave_bad3 = reshape(chan_full_wave_bad3,1,length(chan_full_wave_bad3)/1);
                    fclose(fiD);
                else
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_0.dat'],'r');
                    chan_full_wave_S1 = fread(fiD,'float32');
                    chan_full_wave_S1 = reshape(chan_full_wave_S1,1,length(chan_full_wave_S1)/1);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_1.dat'],'r');
                    chan_full_wave_B1 = fread(fiD,'float32');
                    chan_full_wave_B1 = reshape(chan_full_wave_B1,1,length(chan_full_wave_B1)/1);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_2.dat'],'r');
                    chan_full_wave_S2 = fread(fiD,'float32');
                    chan_full_wave_S2 = reshape(chan_full_wave_S2,1,length(chan_full_wave_S2)/1);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_3.dat'],'r');
                    chan_full_wave_B2 = fread(fiD,'float32');
                    chan_full_wave_B2 = reshape(chan_full_wave_B2,1,length(chan_full_wave_B2)/1);
                    fclose(fiD);
                end
                
                %Set durMAT for M1 spikes
                durMAT(3,:) = [length(chan_full_wave_S1)/param.M1_spike_wave_Fs, length(chan_full_wave_B1)/param.M1_spike_wave_Fs, length(chan_full_wave_S2)/param.M1_spike_wave_Fs, length(chan_full_wave_B2)/param.M1_spike_wave_Fs];
                
                %sort spiketimes into blocks
                if(day == 1)
                    %remove first two bad blocks
                    spike_times_bad1 = spike_times(spike_times <= size(chan_full_wave_bad1,2));
                    spike_clusters_bad1 = spike_clusters(1:length(spike_times_bad1));
                    spike_clusters(1:length(spike_times_bad1)) = [];
                    spike_times(1:length(spike_times_bad1)) = [];
                    spike_times = spike_times - size(chan_full_wave_bad1,2);
                    
                    spike_times_bad2 = spike_times(spike_times <= size(chan_full_wave_bad2,2));
                    spike_clusters_bad2 = spike_clusters(1:length(spike_times_bad2));
                    spike_clusters(1:length(spike_times_bad2)) = [];
                    spike_times(1:length(spike_times_bad2)) = [];
                    spike_times = spike_times - size(chan_full_wave_bad2,2);
                    
                    clear chan_full_wave_bad1 chan_full_wave_bad2 spike_times_bad1 spike_times_bad2 spike_clusters_bad1 spike_clusters_bad2
                end
                
                spike_times_S1 = spike_times(spike_times <= size(chan_full_wave_S1,2));
                spike_clusters_S1 = spike_clusters(1:length(spike_times_S1));
                spike_clusters(1:length(spike_times_S1)) = [];
                spike_times(1:length(spike_times_S1)) = [];
                spike_times = spike_times - size(chan_full_wave_S1,2);
                
                if(day == 1)
                    %remove final bad block
                    spike_times_bad3 = spike_times(spike_times <= size(chan_full_wave_bad3,2));
                    spike_clusters_bad3 = spike_clusters(1:length(spike_times_bad3));
                    spike_clusters(1:length(spike_times_bad3)) = [];
                    spike_times(1:length(spike_times_bad3)) = [];
                    spike_times = spike_times - size(chan_full_wave_bad3,2);
                    
                    clear chan_full_wave_bad3 spike_times_bad3 spike_clusters_bad3
                end
                
                spike_times_B1 = spike_times(spike_times <= size(chan_full_wave_B1,2));
                spike_clusters_B1 = spike_clusters(1:length(spike_times_B1));
                spike_clusters(1:length(spike_times_B1)) = [];
                spike_times(1:length(spike_times_B1)) = [];
                spike_times = spike_times - size(chan_full_wave_B1,2);
                
                spike_times_S2 = spike_times(spike_times <= size(chan_full_wave_S2,2));
                spike_clusters_S2 = spike_clusters(1:length(spike_times_S2));
                spike_clusters(1:length(spike_times_S2)) = [];
                spike_times(1:length(spike_times_S2)) = [];
                spike_times = spike_times - size(chan_full_wave_S2,2);
                
                spike_times_B2 = spike_times(spike_times <= size(chan_full_wave_B2,2));
                spike_clusters_B2 = spike_clusters(1:length(spike_times_B2));
                
                %sort timestamps into neurons
                dat_chan = (chan)+1;
                for neuron = 1:param.M1_neurons
                    
                    if size(cluster_info.group,1) >= neuron && (strcmp(cluster_info.group(neuron,:),'good ') || strcmp(cluster_info.group(neuron,:),'mua  '))
                        if strcmp(cluster_info.group(neuron,:),'mua  ')
                            param.M1_mua_neurons{day}(dat_chan,neuron) = 1;
                        end
                        param.M1_neuron_chans{day}(dat_chan,neuron) = cluster_info.ch(neuron);
                        TimeStamps1_S1{dat_chan,neuron} = spike_times_S1(spike_clusters_S1 == (neuron-1))';
                        TimeStamps1_B1{dat_chan,neuron} = spike_times_B1(spike_clusters_B1 == (neuron-1))';
                        TimeStamps1_S2{dat_chan,neuron} = spike_times_S2(spike_clusters_S2 == (neuron-1))';
                        TimeStamps1_B2{dat_chan,neuron} = spike_times_B2(spike_clusters_B2 == (neuron-1))';
                    end
                    
                    %sort waveforms into the sub-channels of the neuron's tetrode
                    
                    Waves1_S1{dat_chan,neuron} = zeros(30,length(TimeStamps1_S1{dat_chan,neuron}));
                    for i = 1:length(TimeStamps1_S1{dat_chan,neuron})
                        t_stamp = TimeStamps1_S1{dat_chan,neuron}(i);
                        if (t_stamp + 22) <= size(chan_full_wave_S1,2) && (t_stamp - 7) > 0
                            Waves1_S1{dat_chan,neuron}(:,i) = chan_full_wave_S1(1,t_stamp - 7:t_stamp + 22);
                        end
                    end
                    
                    Waves1_B1{dat_chan,neuron} = zeros(30,length(TimeStamps1_B1{dat_chan,neuron}));
                    for i = 1:length(TimeStamps1_B1{dat_chan,neuron})
                        t_stamp = TimeStamps1_B1{dat_chan,neuron}(i);
                        if (t_stamp + 22) <= size(chan_full_wave_B1,2) && (t_stamp - 7) > 0
                            Waves1_B1{dat_chan,neuron}(:,i) = chan_full_wave_B1(1,t_stamp - 7:t_stamp + 22);
                        end
                    end
                    
                    Waves1_S2{dat_chan,neuron} = zeros(30,length(TimeStamps1_S2{dat_chan,neuron}));
                    for i = 1:length(TimeStamps1_S2{dat_chan,neuron})
                        t_stamp = TimeStamps1_S2{dat_chan,neuron}(i);
                        if (t_stamp + 22) <= size(chan_full_wave_S2,2) && (t_stamp - 7) > 0
                            Waves1_S2{dat_chan,neuron}(:,i) = chan_full_wave_S2(1,t_stamp - 7:t_stamp + 22);
                        end
                    end
                    
                    Waves1_B2{dat_chan,neuron} = zeros(30,length(TimeStamps1_B2{dat_chan,neuron}));
                    for i = 1:length(TimeStamps1_B2{dat_chan,neuron})
                        t_stamp = TimeStamps1_B2{dat_chan,neuron}(i);
                        if (t_stamp + 22) <= size(chan_full_wave_B2,2) && (t_stamp - 7) > 0
                            Waves1_B2{dat_chan,neuron}(:,i) = chan_full_wave_B2(1,t_stamp - 7:t_stamp + 22);
                        end
                    end
                    TimeStamps1_S1{dat_chan,neuron} = TimeStamps1_S1{dat_chan,neuron}/param.M1_spike_wave_Fs;
                    TimeStamps1_B1{dat_chan,neuron} = TimeStamps1_B1{dat_chan,neuron}/param.M1_spike_wave_Fs;
                    TimeStamps1_S2{dat_chan,neuron} = TimeStamps1_S2{dat_chan,neuron}/param.M1_spike_wave_Fs;
                    TimeStamps1_B2{dat_chan,neuron} = TimeStamps1_B2{dat_chan,neuron}/param.M1_spike_wave_Fs;
                end
            end
            
            %Cb spike times
            for poly = 0:3
                spike_times = double(readNPY([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_0\SU_CONT_Cb_poly_', num2str(poly), '_0.GUI\spike_times.npy']));
                spike_clusters = readNPY([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_0\SU_CONT_Cb_poly_', num2str(poly), '_0.GUI\spike_clusters.npy']);
                cluster_info = tdfread([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_0\SU_CONT_Cb_poly_', num2str(poly), '_0.GUI\cluster_info.tsv']);
                
                if (param.Cb_neurons - 1) < max(spike_clusters)
                    error(['param.Cb_neurons needs to be increased to ', num2str(max(spike_clusters)+1)])
                end
                
                %get waveforms Day 1 has diferent numbers in the final file name
                if day == 1
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_2.dat'],'r');
                    chan_full_wave_S1 = fread(fiD,'float32');
                    chan_full_wave_S1 = reshape(chan_full_wave_S1,16,length(chan_full_wave_S1)/16);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_4.dat'],'r');
                    chan_full_wave_B1 = fread(fiD,'float32');
                    chan_full_wave_B1 = reshape(chan_full_wave_B1,16,length(chan_full_wave_B1)/16);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_5.dat'],'r');
                    chan_full_wave_S2 = fread(fiD,'float32');
                    chan_full_wave_S2 = reshape(chan_full_wave_S2,16,length(chan_full_wave_S2)/16);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_6.dat'],'r');
                    chan_full_wave_B2 = fread(fiD,'float32');
                    chan_full_wave_B2 = reshape(chan_full_wave_B2,16,length(chan_full_wave_B2)/16);
                    fclose(fiD);
                    
                    %Get the false-start blocks so that those parts can be removed from the spike train
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_0.dat'],'r');
                    chan_full_wave_bad1 = fread(fiD,'float32');
                    chan_full_wave_bad1 = reshape(chan_full_wave_bad1,16,length(chan_full_wave_bad1)/16);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_1.dat'],'r');
                    chan_full_wave_bad2 = fread(fiD,'float32');
                    chan_full_wave_bad2 = reshape(chan_full_wave_bad2,16,length(chan_full_wave_bad2)/16);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_3.dat'],'r');
                    chan_full_wave_bad3 = fread(fiD,'float32');
                    chan_full_wave_bad3 = reshape(chan_full_wave_bad3,16,length(chan_full_wave_bad3)/16);
                    fclose(fiD);
                else
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_0.dat'],'r');
                    chan_full_wave_S1 = fread(fiD,'float32');
                    chan_full_wave_S1 = reshape(chan_full_wave_S1,16,length(chan_full_wave_S1)/16);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_1.dat'],'r');
                    chan_full_wave_B1 = fread(fiD,'float32');
                    chan_full_wave_B1 = reshape(chan_full_wave_B1,16,length(chan_full_wave_B1)/16);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_2.dat'],'r');
                    chan_full_wave_S2 = fread(fiD,'float32');
                    chan_full_wave_S2 = reshape(chan_full_wave_S2,16,length(chan_full_wave_S2)/16);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I076-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_3.dat'],'r');
                    chan_full_wave_B2 = fread(fiD,'float32');
                    chan_full_wave_B2 = reshape(chan_full_wave_B2,16,length(chan_full_wave_B2)/16);
                    fclose(fiD);
                end
                
                %Set durMAT for Cb spikes
                durMAT(4,:) = [length(chan_full_wave_S1)/param.Cb_spike_wave_Fs, length(chan_full_wave_B1)/param.Cb_spike_wave_Fs, length(chan_full_wave_S2)/param.Cb_spike_wave_Fs, length(chan_full_wave_B2)/param.Cb_spike_wave_Fs];
                
                %sort spiketimes into blocks
                if(day == 1)
                    %remove first two bad blocks
                    spike_times_bad1 = spike_times(spike_times <= size(chan_full_wave_bad1,2));
                    spike_clusters_bad1 = spike_clusters(1:length(spike_times_bad1));
                    spike_clusters(1:length(spike_times_bad1)) = [];
                    spike_times(1:length(spike_times_bad1)) = [];
                    spike_times = spike_times - size(chan_full_wave_bad1,2);
                    
                    spike_times_bad2 = spike_times(spike_times <= size(chan_full_wave_bad2,2));
                    spike_clusters_bad2 = spike_clusters(1:length(spike_times_bad2));
                    spike_clusters(1:length(spike_times_bad2)) = [];
                    spike_times(1:length(spike_times_bad2)) = [];
                    spike_times = spike_times - size(chan_full_wave_bad2,2);
                    
                    clear chan_full_wave_bad1 chan_full_wave_bad2 spike_times_bad1 spike_times_bad2 spike_clusters_bad1 spike_clusters_bad2
                end
                
                spike_times_S1 = spike_times(spike_times <= size(chan_full_wave_S1,2));
                spike_clusters_S1 = spike_clusters(1:length(spike_times_S1));
                spike_clusters(1:length(spike_times_S1)) = [];
                spike_times(1:length(spike_times_S1)) = [];
                spike_times = spike_times - size(chan_full_wave_S1,2);
                
                if(day == 1)
                    %remove final bad block
                    spike_times_bad3 = spike_times(spike_times <= size(chan_full_wave_bad3,2));
                    spike_clusters_bad3 = spike_clusters(1:length(spike_times_bad3));
                    spike_clusters(1:length(spike_times_bad3)) = [];
                    spike_times(1:length(spike_times_bad3)) = [];
                    spike_times = spike_times - size(chan_full_wave_bad3,2);
                    
                    clear chan_full_wave_bad3 spike_times_bad3 spike_clusters_bad3
                end
                
                spike_times_B1 = spike_times(spike_times <= size(chan_full_wave_B1,2));
                spike_clusters_B1 = spike_clusters(1:length(spike_times_B1));
                spike_clusters(1:length(spike_times_B1)) = [];
                spike_times(1:length(spike_times_B1)) = [];
                spike_times = spike_times - size(chan_full_wave_B1,2);
                
                spike_times_S2 = spike_times(spike_times <= size(chan_full_wave_S2,2));
                spike_clusters_S2 = spike_clusters(1:length(spike_times_S2));
                spike_clusters(1:length(spike_times_S2)) = [];
                spike_times(1:length(spike_times_S2)) = [];
                spike_times = spike_times - size(chan_full_wave_S2,2);
                
                spike_times_B2 = spike_times(spike_times <= size(chan_full_wave_B2,2));
                spike_clusters_B2 = spike_clusters(1:length(spike_times_B2));
                
                %sort timestamps into neurons
                dat_chan = (poly*16)+1;
                for neuron = 1:param.Cb_neurons
                    
                    if size(cluster_info.group,1) >= neuron && (strcmp(cluster_info.group(neuron,:),'good ') || strcmp(cluster_info.group(neuron,:),'mua  '))
                        if strcmp(cluster_info.group(neuron,:),'mua  ')
                            param.Cb_mua_neurons{day}(dat_chan,neuron) = 1;
                        end
                        param.Cb_neuron_chans{day}(dat_chan,neuron) = cluster_info.ch(neuron);
                        TimeStamps2_S1{dat_chan,neuron} = spike_times_S1(spike_clusters_S1 == (neuron-1))';
                        TimeStamps2_B1{dat_chan,neuron} = spike_times_B1(spike_clusters_B1 == (neuron-1))';
                        TimeStamps2_S2{dat_chan,neuron} = spike_times_S2(spike_clusters_S2 == (neuron-1))';
                        TimeStamps2_B2{dat_chan,neuron} = spike_times_B2(spike_clusters_B2 == (neuron-1))';
                    end
                    
                    %sort waveforms into the sub-channels of the neuron's tetrode
                    for sub_chan = 0:15
                        
                        Waves2_S1{dat_chan + sub_chan,neuron} = zeros(30,length(TimeStamps2_S1{dat_chan,neuron}));
                        for i = 1:length(TimeStamps2_S1{dat_chan,neuron})
                            t_stamp = TimeStamps2_S1{dat_chan,neuron}(i);
                            if (t_stamp + 22) <= size(chan_full_wave_S1,2) && (t_stamp - 7) > 0
                                Waves2_S1{dat_chan + sub_chan,neuron}(:,i) = chan_full_wave_S1(sub_chan+1,t_stamp - 7:t_stamp + 22);
                            end
                        end
                        
                        Waves2_B1{dat_chan + sub_chan,neuron} = zeros(30,length(TimeStamps2_B1{dat_chan,neuron}));
                        for i = 1:length(TimeStamps2_B1{dat_chan,neuron})
                            t_stamp = TimeStamps2_B1{dat_chan,neuron}(i);
                            if (t_stamp + 22) <= size(chan_full_wave_B1,2) && (t_stamp - 7) > 0
                                Waves2_B1{dat_chan + sub_chan,neuron}(:,i) = chan_full_wave_B1(sub_chan+1,t_stamp - 7:t_stamp + 22);
                            end
                        end
                        
                        Waves2_S2{dat_chan + sub_chan,neuron} = zeros(30,length(TimeStamps2_S2{dat_chan,neuron}));
                        for i = 1:length(TimeStamps2_S2{dat_chan,neuron})
                            t_stamp = TimeStamps2_S2{dat_chan,neuron}(i);
                            if (t_stamp + 22) <= size(chan_full_wave_S2,2) && (t_stamp - 7) > 0
                                Waves2_S2{dat_chan + sub_chan,neuron}(:,i) = chan_full_wave_S2(sub_chan+1,t_stamp - 7:t_stamp + 22);
                            end
                        end
                        
                        Waves2_B2{dat_chan + sub_chan,neuron} = zeros(30,length(TimeStamps2_B2{dat_chan,neuron}));
                        for i = 1:length(TimeStamps2_B2{dat_chan,neuron})
                            t_stamp = TimeStamps2_B2{dat_chan,neuron}(i);
                            if (t_stamp + 22) <= size(chan_full_wave_B2,2) && (t_stamp - 7) > 0
                                Waves2_B2{dat_chan + sub_chan,neuron}(:,i) = chan_full_wave_B2(sub_chan+1,t_stamp - 7:t_stamp + 22);
                            end
                        end
                    end
                    TimeStamps2_S1{dat_chan,neuron} = TimeStamps2_S1{dat_chan,neuron}/param.Cb_spike_wave_Fs;
                    TimeStamps2_B1{dat_chan,neuron} = TimeStamps2_B1{dat_chan,neuron}/param.Cb_spike_wave_Fs;
                    TimeStamps2_S2{dat_chan,neuron} = TimeStamps2_S2{dat_chan,neuron}/param.Cb_spike_wave_Fs;
                    TimeStamps2_B2{dat_chan,neuron} = TimeStamps2_B2{dat_chan,neuron}/param.Cb_spike_wave_Fs;
                end
            end
            
            %save data in source directory
            for block = 1:size(param.training_block_names,2)
                save([origin_rootpath,animal,'\',param.Spike_path,'\',param.training_block_names{day, block},'/Timestamps_B',num2str(block),'.mat'], ['TimeStamps1_B', num2str(block)], ['TimeStamps2_B', num2str(block)]);
                save([origin_rootpath,animal,'\',param.Spike_path,'\',param.training_block_names{day, block},'/Waves_B',num2str(block),'.mat'], ['Waves1_B', num2str(block)], ['Waves2_B', num2str(block)], '-v7.3');
            end
            
            %Truncate spiketimes and waves
            for n_idx = 1:length(TimeStamps1_B1(:))
                if ~isempty(TimeStamps1_B1{n_idx})
                    TimeStamps1_B1{n_idx} = TimeStamps1_B1{n_idx}(TimeStamps1_B1{n_idx} <= durMAT(5,2));
                    Waves1_B1{n_idx} = Waves1_B1{n_idx}(:,(TimeStamps1_B1{n_idx} <= durMAT(5,2)));
                end
            end
            for n_idx = 1:length(TimeStamps2_B1(:))
                if ~isempty(TimeStamps2_B1{n_idx})
                    TimeStamps2_B1{n_idx} = TimeStamps2_B1{n_idx}(TimeStamps2_B1{n_idx} <= durMAT(5,2));
                    for i = 0:15
                        Waves2_B1{n_idx+i} = Waves2_B1{n_idx+i}(:,(TimeStamps2_B1{n_idx} <= durMAT(5,2)));
                    end
                end
            end
            for n_idx = 1:length(TimeStamps1_B2(:))
                if ~isempty(TimeStamps1_B2{n_idx})
                    TimeStamps1_B2{n_idx} = TimeStamps1_B2{n_idx}(TimeStamps1_B2{n_idx} <= durMAT(5,4));
                    Waves1_B2{n_idx} = Waves1_B2{n_idx}(:,(TimeStamps1_B2{n_idx} <= durMAT(5,4)));
                end
            end
            for n_idx = 1:length(TimeStamps1_B2(:))
                if ~isempty(TimeStamps2_B2{n_idx})
                    TimeStamps2_B2{n_idx} = TimeStamps2_B2{n_idx}(TimeStamps2_B2{n_idx} <= durMAT(5,4));
                    for i = 0:15
                        Waves2_B2{n_idx+i} = Waves2_B2{n_idx+i}(:,(TimeStamps2_B2{n_idx} <= durMAT(5,4)));
                    end
                end
            end
        elseif false %strcmp(animal,'I086')
            param.M1_neurons = 28;
            param.Cb_neurons = 29;
            s_err = false;
            param.M1_mua_neurons{day} = zeros(param.M1_chans,param.M1_neurons);
            param.M1_neuron_chans{day} = nan(param.M1_chans,param.M1_neurons);
            param.Cb_mua_neurons{day} = zeros(param.Cb_chans,param.Cb_neurons);
            param.Cb_neuron_chans{day} = nan(param.Cb_chans,param.Cb_neurons);
            
            load([origin_rootpath,animal,'/',param.durFiles(day,:),'.mat']);
            sbn1 = param.sleep_block_names{day, 1};
            sbn1 = sbn1(1,10:end);
            
            %The LFP duration is the best aproximation of the spike duration
            durMAT(3,:) = durMAT(1,:);
            
            %Pre-allocation
            TimeStamps1_S1 = cell(32,param.M1_neurons);
            TimeStamps2_S1 = cell(64,param.Cb_neurons);
            TimeStamps1_B1 = cell(32,param.M1_neurons);
            TimeStamps2_B1 = cell(64,param.Cb_neurons);
            TimeStamps1_S2 = cell(32,param.M1_neurons);
            TimeStamps2_S2 = cell(64,param.Cb_neurons);
            TimeStamps1_B2 = cell(32,param.M1_neurons);
            TimeStamps2_B2 = cell(64,param.Cb_neurons);
            
            Waves1_S1 = cell(32,param.M1_neurons);
            Waves2_S1 = cell(64,param.Cb_neurons);
            Waves1_S2 = cell(32,param.M1_neurons);
            Waves2_S2 = cell(64,param.Cb_neurons);
            Waves1_B1 = cell(32,param.M1_neurons);
            Waves2_B1 = cell(64,param.Cb_neurons);
            Waves1_B2 = cell(32,param.M1_neurons);
            Waves2_B2 = cell(64,param.Cb_neurons);
            
            %M1 spike times
            for chan = 0:31
                spike_times = double(readNPY([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_0\SU_CONT_M1_Ch_', num2str(chan), '_0.GUI\spike_times.npy']));
                spike_clusters = readNPY([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_0\SU_CONT_M1_Ch_', num2str(chan), '_0.GUI\spike_clusters.npy']);
                cluster_info = tdfread([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_0\SU_CONT_M1_Ch_', num2str(chan), '_0.GUI\cluster_info.tsv']);
                
                if (param.M1_neurons - 1) < max(spike_clusters)
                    disp(['param.M1_neurons needs to be increased to ', num2str(max(spike_clusters)+1)])
                    s_err = true;
                else
                    
                    %get waveforms
                    
                    if day == 1
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_0.dat'],'r');
                        chan_full_wave_S1_1 = fread(fiD,'float32');
                        chan_full_wave_S1_1 = reshape(chan_full_wave_S1_1,1,length(chan_full_wave_S1_1)/1);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_1.dat'],'r');
                        chan_full_wave_S1_2 = fread(fiD,'float32');
                        chan_full_wave_S1_2 = reshape(chan_full_wave_S1_2,1,length(chan_full_wave_S1_2)/1);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_2.dat'],'r');
                        chan_full_wave_B1 = fread(fiD,'float32');
                        chan_full_wave_B1 = reshape(chan_full_wave_B1,1,length(chan_full_wave_B1)/1);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_3.dat'],'r');
                        chan_full_wave_S2 = fread(fiD,'float32');
                        chan_full_wave_S2 = reshape(chan_full_wave_S2,1,length(chan_full_wave_S2)/1);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_4.dat'],'r');
                        chan_full_wave_B2 = fread(fiD,'float32');
                        chan_full_wave_B2 = reshape(chan_full_wave_B2,1,length(chan_full_wave_B2)/1);
                        fclose(fiD);
                    elseif day == 3
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_0.dat'],'r');
                        chan_full_wave_S1 = fread(fiD,'float32');
                        chan_full_wave_S1 = reshape(chan_full_wave_S1,1,length(chan_full_wave_S1)/1);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_1.dat'],'r');
                        chan_full_wave_B1 = fread(fiD,'float32');
                        chan_full_wave_B1 = reshape(chan_full_wave_B1,1,length(chan_full_wave_B1)/1);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_2.dat'],'r');
                        chan_full_wave_S2 = fread(fiD,'float32');
                        chan_full_wave_S2 = reshape(chan_full_wave_S2,1,length(chan_full_wave_S2)/1);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_3.dat'],'r');
                        chan_full_wave_B2_1 = fread(fiD,'float32');
                        chan_full_wave_B2_1 = reshape(chan_full_wave_B2_1,1,length(chan_full_wave_B2_1)/1);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_4.dat'],'r');
                        chan_full_wave_B2_2 = fread(fiD,'float32');
                        chan_full_wave_B2_2 = reshape(chan_full_wave_B2_2,1,length(chan_full_wave_B2_2)/1);
                        fclose(fiD);
                    else
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_0.dat'],'r');
                        chan_full_wave_S1 = fread(fiD,'float32');
                        chan_full_wave_S1 = reshape(chan_full_wave_S1,1,length(chan_full_wave_S1)/1);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_1.dat'],'r');
                        chan_full_wave_B1 = fread(fiD,'float32');
                        chan_full_wave_B1 = reshape(chan_full_wave_B1,1,length(chan_full_wave_B1)/1);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_2.dat'],'r');
                        chan_full_wave_S2 = fread(fiD,'float32');
                        chan_full_wave_S2 = reshape(chan_full_wave_S2,1,length(chan_full_wave_S2)/1);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_3.dat'],'r');
                        chan_full_wave_B2 = fread(fiD,'float32');
                        chan_full_wave_B2 = reshape(chan_full_wave_B2,1,length(chan_full_wave_B2)/1);
                        fclose(fiD);
                    end
                    
                    %Set durMAT for M1 spikes
                    if day == 1
                        durMAT(3,:) = [length(chan_full_wave_S1_1)/param.M1_spike_wave_Fs, length(chan_full_wave_S1_2)/param.M1_spike_wave_Fs, length(chan_full_wave_B1)/param.M1_spike_wave_Fs, length(chan_full_wave_S2)/param.M1_spike_wave_Fs, length(chan_full_wave_B2)/param.M1_spike_wave_Fs];
                        chan_full_wave_S1 = [chan_full_wave_S1_1 chan_full_wave_S1_2];
                    elseif day ==3
                        durMAT(3,:) = [length(chan_full_wave_S1)/param.M1_spike_wave_Fs, length(chan_full_wave_S1)/param.M1_spike_wave_Fs, length(chan_full_wave_B1)/param.M1_spike_wave_Fs, length(chan_full_wave_S2)/param.M1_spike_wave_Fs, length(chan_full_wave_B2_1)/param.M1_spike_wave_Fs, length(chan_full_wave_B2_2)/param.M1_spike_wave_Fs];
                        chan_full_wave_B2 = [chan_full_wave_B2_1 chan_full_wave_B2_2];
                    else
                        durMAT(3,:) = [length(chan_full_wave_S1)/param.M1_spike_wave_Fs, length(chan_full_wave_B1)/param.M1_spike_wave_Fs, length(chan_full_wave_S2)/param.M1_spike_wave_Fs, length(chan_full_wave_B2)/param.M1_spike_wave_Fs];
                    end
                                                
                    %sort spiketimes into blocks
                    spike_times_S1 = spike_times(spike_times <= size(chan_full_wave_S1,2));
                    spike_clusters_S1 = spike_clusters(1:length(spike_times_S1));
                    spike_clusters(1:length(spike_times_S1)) = [];
                    spike_times(1:length(spike_times_S1)) = [];
                    spike_times = spike_times - size(chan_full_wave_S1,2);
                    
                    spike_times_B1 = spike_times(spike_times <= size(chan_full_wave_B1,2));
                    spike_clusters_B1 = spike_clusters(1:length(spike_times_B1));
                    spike_clusters(1:length(spike_times_B1)) = [];
                    spike_times(1:length(spike_times_B1)) = [];
                    spike_times = spike_times - size(chan_full_wave_B1,2);
                    
                    spike_times_S2 = spike_times(spike_times <= size(chan_full_wave_S2,2));
                    spike_clusters_S2 = spike_clusters(1:length(spike_times_S2));
                    spike_clusters(1:length(spike_times_S2)) = [];
                    spike_times(1:length(spike_times_S2)) = [];
                    spike_times = spike_times - size(chan_full_wave_S2,2);
                    
                    spike_times_B2 = spike_times(spike_times <= size(chan_full_wave_B2,2));
                    spike_clusters_B2 = spike_clusters(1:length(spike_times_B2));
                    
                    %sort timestamps into neurons
                    dat_chan = (chan)+1;
                    for neuron = 1:param.M1_neurons
                        
                        if size(cluster_info.group,1) >= neuron && (strcmp(cluster_info.group(neuron,:),'good ') || strcmp(cluster_info.group(neuron,:),'mua  '))
                            if strcmp(cluster_info.group(neuron,:),'mua  ')
                                param.M1_mua_neurons{day}(dat_chan,neuron) = 1;
                            end
                            param.M1_neuron_chans{day}(dat_chan,neuron) = cluster_info.ch(neuron);
                            TimeStamps1_S1{dat_chan,neuron} = spike_times_S1(spike_clusters_S1 == (neuron-1))';
                            TimeStamps1_B1{dat_chan,neuron} = spike_times_B1(spike_clusters_B1 == (neuron-1))';
                            TimeStamps1_S2{dat_chan,neuron} = spike_times_S2(spike_clusters_S2 == (neuron-1))';
                            TimeStamps1_B2{dat_chan,neuron} = spike_times_B2(spike_clusters_B2 == (neuron-1))';
                        end
                        
                        %sort waveforms into the sub-channels of the neuron's tetrode
                        
                        Waves1_S1{dat_chan,neuron} = zeros(30,length(TimeStamps1_S1{dat_chan,neuron}));
                        for i = 1:length(TimeStamps1_S1{dat_chan,neuron})
                            t_stamp = TimeStamps1_S1{dat_chan,neuron}(i);
                            if (t_stamp + 22) <= size(chan_full_wave_S1,2) && (t_stamp - 7) > 0
                                Waves1_S1{dat_chan,neuron}(:,i) = chan_full_wave_S1(1,t_stamp - 7:t_stamp + 22);
                            end
                        end
                        
                        Waves1_B1{dat_chan,neuron} = zeros(30,length(TimeStamps1_B1{dat_chan,neuron}));
                        for i = 1:length(TimeStamps1_B1{dat_chan,neuron})
                            t_stamp = TimeStamps1_B1{dat_chan,neuron}(i);
                            if (t_stamp + 22) <= size(chan_full_wave_B1,2) && (t_stamp - 7) > 0
                                Waves1_B1{dat_chan,neuron}(:,i) = chan_full_wave_B1(1,t_stamp - 7:t_stamp + 22);
                            end
                        end
                        
                        Waves1_S2{dat_chan,neuron} = zeros(30,length(TimeStamps1_S2{dat_chan,neuron}));
                        for i = 1:length(TimeStamps1_S2{dat_chan,neuron})
                            t_stamp = TimeStamps1_S2{dat_chan,neuron}(i);
                            if (t_stamp + 22) <= size(chan_full_wave_S2,2) && (t_stamp - 7) > 0
                                Waves1_S2{dat_chan,neuron}(:,i) = chan_full_wave_S2(1,t_stamp - 7:t_stamp + 22);
                            end
                        end
                        
                        Waves1_B2{dat_chan,neuron} = zeros(30,length(TimeStamps1_B2{dat_chan,neuron}));
                        for i = 1:length(TimeStamps1_B2{dat_chan,neuron})
                            t_stamp = TimeStamps1_B2{dat_chan,neuron}(i);
                            if (t_stamp + 22) <= size(chan_full_wave_B2,2) && (t_stamp - 7) > 0
                                Waves1_B2{dat_chan,neuron}(:,i) = chan_full_wave_B2(1,t_stamp - 7:t_stamp + 22);
                            end
                        end
                        TimeStamps1_S1{dat_chan,neuron} = TimeStamps1_S1{dat_chan,neuron}/param.M1_spike_wave_Fs;
                        TimeStamps1_B1{dat_chan,neuron} = TimeStamps1_B1{dat_chan,neuron}/param.M1_spike_wave_Fs;
                        TimeStamps1_S2{dat_chan,neuron} = TimeStamps1_S2{dat_chan,neuron}/param.M1_spike_wave_Fs;
                        TimeStamps1_B2{dat_chan,neuron} = TimeStamps1_B2{dat_chan,neuron}/param.M1_spike_wave_Fs;
                    end
                end
            end
            
            %Cb spike times
            for poly = 0:3
                spike_times = double(readNPY([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_0\SU_CONT_Cb_poly_', num2str(poly), '_0.GUI\spike_times.npy']));
                spike_clusters = readNPY([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_0\SU_CONT_Cb_poly_', num2str(poly), '_0.GUI\spike_clusters.npy']);
                cluster_info = tdfread([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_0\SU_CONT_Cb_poly_', num2str(poly), '_0.GUI\cluster_info.tsv']);
                
                if (param.Cb_neurons - 1) < max(spike_clusters)
                    disp(['param.Cb_neurons needs to be increased to ', num2str(max(spike_clusters)+1)])
                    s_err = true;
                else
                
                    if day == 1
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_0.dat'],'r');
                        chan_full_wave_S1_1 = fread(fiD,'float32');
                        chan_full_wave_S1_1 = reshape(chan_full_wave_S1_1,16,length(chan_full_wave_S1_1)/16);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_1.dat'],'r');
                        chan_full_wave_S1_2 = fread(fiD,'float32');
                        chan_full_wave_S1_2 = reshape(chan_full_wave_S1_2,16,length(chan_full_wave_S1_2)/16);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_2.dat'],'r');
                        chan_full_wave_B1 = fread(fiD,'float32');
                        chan_full_wave_B1 = reshape(chan_full_wave_B1,16,length(chan_full_wave_B1)/16);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_3.dat'],'r');
                        chan_full_wave_S2 = fread(fiD,'float32');
                        chan_full_wave_S2 = reshape(chan_full_wave_S2,16,length(chan_full_wave_S2)/16);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_4.dat'],'r');
                        chan_full_wave_B2 = fread(fiD,'float32');
                        chan_full_wave_B2 = reshape(chan_full_wave_B2,16,length(chan_full_wave_B2)/16);
                        fclose(fiD);
                    elseif day == 3
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_0.dat'],'r');
                        chan_full_wave_S1 = fread(fiD,'float32');
                        chan_full_wave_S1 = reshape(chan_full_wave_S1,16,length(chan_full_wave_S1)/16);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_1.dat'],'r');
                        chan_full_wave_B1 = fread(fiD,'float32');
                        chan_full_wave_B1 = reshape(chan_full_wave_B1,16,length(chan_full_wave_B1)/16);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_2.dat'],'r');
                        chan_full_wave_S2 = fread(fiD,'float32');
                        chan_full_wave_S2 = reshape(chan_full_wave_S2,1,length(chan_full_wave_S2)/1);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_3.dat'],'r');
                        chan_full_wave_B2_1 = fread(fiD,'float32');
                        chan_full_wave_B2_1 = reshape(chan_full_wave_B2_1,16,length(chan_full_wave_B2_1)/16);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_4.dat'],'r');
                        chan_full_wave_B2_2 = fread(fiD,'float32');
                        chan_full_wave_B2_2 = reshape(chan_full_wave_B2_2,16,length(chan_full_wave_B2_2)/16);
                        fclose(fiD);
                    else
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_0.dat'],'r');
                        chan_full_wave_S1 = fread(fiD,'float32');
                        chan_full_wave_S1 = reshape(chan_full_wave_S1,16,length(chan_full_wave_S1)/16);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_1.dat'],'r');
                        chan_full_wave_B1 = fread(fiD,'float32');
                        chan_full_wave_B1 = reshape(chan_full_wave_B1,16,length(chan_full_wave_B1)/16);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_2.dat'],'r');
                        chan_full_wave_S2 = fread(fiD,'float32');
                        chan_full_wave_S2 = reshape(chan_full_wave_S2,16,length(chan_full_wave_S2)/16);
                        fclose(fiD);
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(poly), '\SU_CONT_Cb_poly_', num2str(poly), '_3.dat'],'r');
                        chan_full_wave_B2 = fread(fiD,'float32');
                        chan_full_wave_B2 = reshape(chan_full_wave_B2,16,length(chan_full_wave_B2)/16);
                        fclose(fiD);
                    end
                    
                    %Set durMAT for Cb spikes
                    if day == 1
                        durMAT(4,:) = [length(chan_full_wave_S1_1)/param.Cb_spike_wave_Fs, length(chan_full_wave_S1_2)/param.Cb_spike_wave_Fs, length(chan_full_wave_B1)/param.Cb_spike_wave_Fs, length(chan_full_wave_S2)/param.Cb_spike_wave_Fs, length(chan_full_wave_B2)/param.Cb_spike_wave_Fs];
                        chan_full_wave_S1 = [chan_full_wave_S1_1 chan_full_wave_S1_2];
                    elseif day ==3
                        durMAT(4,:) = [length(chan_full_wave_S1)/param.Cb_spike_wave_Fs, length(chan_full_wave_S1)/param.Cb_spike_wave_Fs, length(chan_full_wave_B1)/param.Cb_spike_wave_Fs, length(chan_full_wave_S2)/param.Cb_spike_wave_Fs, length(chan_full_wave_B2_1)/param.Cb_spike_wave_Fs, length(chan_full_wave_B2_2)/param.Cb_spike_wave_Fs];
                        chan_full_wave_B2 = [chan_full_wave_B2_1 chan_full_wave_B2_2];
                    else
                        durMAT(4,:) = [length(chan_full_wave_S1)/param.Cb_spike_wave_Fs, length(chan_full_wave_B1)/param.Cb_spike_wave_Fs, length(chan_full_wave_S2)/param.Cb_spike_wave_Fs, length(chan_full_wave_B2)/param.Cb_spike_wave_Fs];
                    end
                    
                    %sort spiketimes into blocks
                    spike_times_S1 = spike_times(spike_times <= size(chan_full_wave_S1,2));
                    spike_clusters_S1 = spike_clusters(1:length(spike_times_S1));
                    spike_clusters(1:length(spike_times_S1)) = [];
                    spike_times(1:length(spike_times_S1)) = [];
                    spike_times = spike_times - size(chan_full_wave_S1,2);
                    
                    spike_times_B1 = spike_times(spike_times <= size(chan_full_wave_B1,2));
                    spike_clusters_B1 = spike_clusters(1:length(spike_times_B1));
                    spike_clusters(1:length(spike_times_B1)) = [];
                    spike_times(1:length(spike_times_B1)) = [];
                    spike_times = spike_times - size(chan_full_wave_B1,2);
                    
                    spike_times_S2 = spike_times(spike_times <= size(chan_full_wave_S2,2));
                    spike_clusters_S2 = spike_clusters(1:length(spike_times_S2));
                    spike_clusters(1:length(spike_times_S2)) = [];
                    spike_times(1:length(spike_times_S2)) = [];
                    spike_times = spike_times - size(chan_full_wave_S2,2);
                    
                    spike_times_B2 = spike_times(spike_times <= size(chan_full_wave_B2,2));
                    spike_clusters_B2 = spike_clusters(1:length(spike_times_B2));
                    
                    %sort timestamps into neurons
                    dat_chan = (poly*16)+1;
                    for neuron = 1:param.Cb_neurons
                        
                        if size(cluster_info.group,1) >= neuron && (strcmp(cluster_info.group(neuron,:),'good ') || strcmp(cluster_info.group(neuron,:),'mua  '))
                            if strcmp(cluster_info.group(neuron,:),'mua  ')
                                param.Cb_mua_neurons{day}(dat_chan,neuron) = 1;
                            end
                            param.Cb_neuron_chans{day}(dat_chan,neuron) = cluster_info.ch(neuron);
                            TimeStamps2_S1{dat_chan,neuron} = spike_times_S1(spike_clusters_S1 == (neuron-1))';
                            TimeStamps2_B1{dat_chan,neuron} = spike_times_B1(spike_clusters_B1 == (neuron-1))';
                            TimeStamps2_S2{dat_chan,neuron} = spike_times_S2(spike_clusters_S2 == (neuron-1))';
                            TimeStamps2_B2{dat_chan,neuron} = spike_times_B2(spike_clusters_B2 == (neuron-1))';
                        end
                        
                        %sort waveforms into the sub-channels of the neuron's tetrode
                        for sub_chan = 0:15
                            
                            Waves2_S1{dat_chan + sub_chan,neuron} = zeros(30,length(TimeStamps2_S1{dat_chan,neuron}));
                            for i = 1:length(TimeStamps2_S1{dat_chan,neuron})
                                t_stamp = TimeStamps2_S1{dat_chan,neuron}(i);
                                if (t_stamp + 22) <= size(chan_full_wave_S1,2) && (t_stamp - 7) > 0
                                    Waves2_S1{dat_chan + sub_chan,neuron}(:,i) = chan_full_wave_S1(sub_chan+1,t_stamp - 7:t_stamp + 22);
                                end
                            end
                            
                            Waves2_B1{dat_chan + sub_chan,neuron} = zeros(30,length(TimeStamps2_B1{dat_chan,neuron}));
                            for i = 1:length(TimeStamps2_B1{dat_chan,neuron})
                                t_stamp = TimeStamps2_B1{dat_chan,neuron}(i);
                                if (t_stamp + 22) <= size(chan_full_wave_B1,2) && (t_stamp - 7) > 0
                                    Waves2_B1{dat_chan + sub_chan,neuron}(:,i) = chan_full_wave_B1(sub_chan+1,t_stamp - 7:t_stamp + 22);
                                end
                            end
                            
                            Waves2_S2{dat_chan + sub_chan,neuron} = zeros(30,length(TimeStamps2_S2{dat_chan,neuron}));
                            for i = 1:length(TimeStamps2_S2{dat_chan,neuron})
                                t_stamp = TimeStamps2_S2{dat_chan,neuron}(i);
                                if (t_stamp + 22) <= size(chan_full_wave_S2,2) && (t_stamp - 7) > 0
                                    Waves2_S2{dat_chan + sub_chan,neuron}(:,i) = chan_full_wave_S2(sub_chan+1,t_stamp - 7:t_stamp + 22);
                                end
                            end
                            
                            Waves2_B2{dat_chan + sub_chan,neuron} = zeros(30,length(TimeStamps2_B2{dat_chan,neuron}));
                            for i = 1:length(TimeStamps2_B2{dat_chan,neuron})
                                t_stamp = TimeStamps2_B2{dat_chan,neuron}(i);
                                if (t_stamp + 22) <= size(chan_full_wave_B2,2) && (t_stamp - 7) > 0
                                    Waves2_B2{dat_chan + sub_chan,neuron}(:,i) = chan_full_wave_B2(sub_chan+1,t_stamp - 7:t_stamp + 22);
                                end
                            end
                        end
                        TimeStamps2_S1{dat_chan,neuron} = TimeStamps2_S1{dat_chan,neuron}/param.Cb_spike_wave_Fs;
                        TimeStamps2_B1{dat_chan,neuron} = TimeStamps2_B1{dat_chan,neuron}/param.Cb_spike_wave_Fs;
                        TimeStamps2_S2{dat_chan,neuron} = TimeStamps2_S2{dat_chan,neuron}/param.Cb_spike_wave_Fs;
                        TimeStamps2_B2{dat_chan,neuron} = TimeStamps2_B2{dat_chan,neuron}/param.Cb_spike_wave_Fs;
                    end
                end
            end
            if ~s_err
                %save data in source directory
                for block = 1:size(param.training_block_names,2)
                    save([origin_rootpath,animal,'\',param.Spike_path,'\',param.training_block_names{day, block},'/Timestamps_B',num2str(block),'.mat'], ['TimeStamps1_B', num2str(block)], ['TimeStamps2_B', num2str(block)]);
                    save([origin_rootpath,animal,'\',param.Spike_path,'\',param.training_block_names{day, block},'/Waves_B',num2str(block),'.mat'], ['Waves1_B', num2str(block)], ['Waves2_B', num2str(block)], '-v7.3');
                end
                
                %Truncate spiketimes and waves
                for n_idx = 1:length(TimeStamps1_B1(:))
                    if ~isempty(TimeStamps1_B1{n_idx})
                        TimeStamps1_B1{n_idx} = TimeStamps1_B1{n_idx}(TimeStamps1_B1{n_idx} <= durMAT(5,2));
                        Waves1_B1{n_idx} = Waves1_B1{n_idx}(:,(TimeStamps1_B1{n_idx} <= durMAT(5,2)));
                    end
                end
                for n_idx = 1:length(TimeStamps2_B1(:))
                    if ~isempty(TimeStamps2_B1{n_idx})
                        TimeStamps2_B1{n_idx} = TimeStamps2_B1{n_idx}(TimeStamps2_B1{n_idx} <= durMAT(5,2));
                        for i = 0:15
                            Waves2_B1{n_idx+i} = Waves2_B1{n_idx+i}(:,(TimeStamps2_B1{n_idx} <= durMAT(5,2)));
                        end
                    end
                end
                for n_idx = 1:length(TimeStamps1_B2(:))
                    if ~isempty(TimeStamps1_B2{n_idx})
                        TimeStamps1_B2{n_idx} = TimeStamps1_B2{n_idx}(TimeStamps1_B2{n_idx} <= durMAT(5,4));
                        Waves1_B2{n_idx} = Waves1_B2{n_idx}(:,(TimeStamps1_B2{n_idx} <= durMAT(5,4)));
                    end
                end
                for n_idx = 1:length(TimeStamps1_B2(:))
                    if ~isempty(TimeStamps2_B2{n_idx})
                        TimeStamps2_B2{n_idx} = TimeStamps2_B2{n_idx}(TimeStamps2_B2{n_idx} <= durMAT(5,4));
                        for i = 0:15
                            Waves2_B2{n_idx+i} = Waves2_B2{n_idx+i}(:,(TimeStamps2_B2{n_idx} <= durMAT(5,4)));
                        end
                    end
                end
            end
        elseif strcmp(animal,'I086')
            param.M1_mua_neurons{day} = zeros(param.M1_chans,param.M1_neurons);
            param.M1_neuron_chans{day} = nan(param.M1_chans,param.M1_neurons);
            param.Cb_mua_neurons{day} = zeros(param.Cb_chans,param.Cb_neurons);
            param.Cb_neuron_chans{day} = nan(param.Cb_chans,param.Cb_neurons);
            
            load([origin_rootpath,animal,'/',param.durFiles(day,:),'.mat']);
            sbn1 = param.sleep_block_names{day, 1};
            sbn1 = sbn1(1,10:end);
            
            s1_sb_idxs = 1:size(param.sleep_block_names{day,1},1);
            t1_sb_idxs = (1:size(param.training_block_names{day,1},1)) + s1_sb_idxs(end);
            s2_sb_idxs = (1:size(param.sleep_block_names{day,2},1)) + t1_sb_idxs(end);
            t2_sb_idxs = (1:size(param.training_block_names{day,2},1)) + s2_sb_idxs(end);
            if size(durMAT,2) ~= length([s1_sb_idxs, t1_sb_idxs, s2_sb_idxs, t2_sb_idxs])
                error('Sub-Block count mismatch')
            end
            sub_block_names = [param.sleep_block_names{day,1}; param.training_block_names{day,1}; param.sleep_block_names{day,2}; param.training_block_names{day,2}];
            
%             %The LFP duration is the best aproximation of the spike duration
%             durMAT(3,:) = durMAT(1,:);
            
            %Pre-allocation
            TimeStamps1_S1 = cell(32,param.M1_neurons);
            TimeStamps2_S1 = cell(64,param.Cb_neurons);
            TimeStamps1_B1 = cell(32,param.M1_neurons);
            TimeStamps2_B1 = cell(64,param.Cb_neurons);
            TimeStamps1_S2 = cell(32,param.M1_neurons);
            TimeStamps2_S2 = cell(64,param.Cb_neurons);
            TimeStamps1_B2 = cell(32,param.M1_neurons);
            TimeStamps2_B2 = cell(64,param.Cb_neurons);
            
            Waves1_S1 = cell(32,param.M1_neurons);
            Waves2_S1 = cell(64,param.Cb_neurons);
            Waves1_S2 = cell(32,param.M1_neurons);
            Waves2_S2 = cell(64,param.Cb_neurons);
            Waves1_B1 = cell(32,param.M1_neurons);
            Waves2_B1 = cell(64,param.Cb_neurons);
            Waves1_B2 = cell(32,param.M1_neurons);
            Waves2_B2 = cell(64,param.Cb_neurons);
            
            %M1 spike times
            block_spikes = cell(4,(param.M1_chans/param.M1_shant_site_num),3);
            for chan = 0:((param.M1_chans/param.M1_shant_site_num)-1)
                spike_times = double(readNPY([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_0\SU_CONT_M1_Ch_', num2str(chan), '_0.GUI\spike_times.npy']));
                spike_clusters = readNPY([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_0\SU_CONT_M1_Ch_', num2str(chan), '_0.GUI\spike_clusters.npy']);
                cluster_info(chan+1) = tdfread([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_0\SU_CONT_M1_Ch_', num2str(chan), '_0.GUI\cluster_info.tsv']);
                
                if param.M1_neurons < length(unique(spike_clusters))
                    disp(['param.M1_neurons needs to be increased to ', num2str(length(unique(spike_clusters)))])
                    param.M1_neurons = length(unique(spike_clusters));
                    s_err = true;
                elseif ~s_err
                    %get waveforms
                    for sub_block = 1:size(sub_block_names,1)
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_', num2str(sub_block-1), '.dat'],'r');
                        sb_chan_full_wave = fread(fiD,'float32');
                        sb_chan_full_wave = reshape(sb_chan_full_wave,param.M1_shant_site_num,length(sb_chan_full_wave)/param.M1_shant_site_num);
                        fclose(fiD);
                        
                        durMAT(3,sub_block) = length(sb_chan_full_wave)/param.M1_spike_wave_Fs;
                        
                        %Sort spiketimes into sub-blocks
                        sb_spike_times = spike_times(spike_times <= size(sb_chan_full_wave,2));
                        sb_spike_clusters = spike_clusters(1:length(sb_spike_times));
                        spike_clusters(1:length(sb_spike_times)) = [];
                        spike_times(1:length(sb_spike_times)) = [];
                        spike_times = spike_times - size(sb_chan_full_wave,2);
                        
                        sb_waves = nan(30, length(sb_spike_times), param.M1_shant_site_num);
                        for i = 1:length(sb_spike_times)
                            t_stamp = sb_spike_times(i);
                            if (t_stamp + 22) <= size(sb_chan_full_wave,2) && (t_stamp - 7) > 0
                                for j = 1:param.M1_shant_site_num
                                    sb_waves(:,i,j) = sb_chan_full_wave(j,t_stamp - 7:t_stamp + 22);
                                end
                            end
                        end
                        
                        %Truncate
                        sb_spike_times(sb_spike_times > (durMAT(5,sub_block)*param.M1_spike_wave_Fs)) = [];
                        sb_spike_clusters = sb_spike_clusters(1:length(sb_spike_times));
                        sb_waves = sb_waves(:,1:length(sb_spike_times),:);
                        
                        %Concatinate into blocks
                        if ismember(sub_block, s1_sb_idxs)
                            block_spikes{1,chan+1,1} = [block_spikes{1,chan+1,1}; (sb_spike_times + (sum(durMAT(5,s1_sb_idxs(s1_sb_idxs<sub_block)))*param.M1_spike_wave_Fs))];
                            block_spikes{1,chan+1,2} = [block_spikes{1,chan+1,2}; sb_spike_clusters];
                            block_spikes{1,chan+1,3} = [block_spikes{1,chan+1,3}, sb_waves];
                        elseif ismember(sub_block, t1_sb_idxs)
                            block_spikes{2,chan+1,1} = [block_spikes{2,chan+1,1}; (sb_spike_times + (sum(durMAT(5,t1_sb_idxs(t1_sb_idxs<sub_block)))*param.M1_spike_wave_Fs))];
                            block_spikes{2,chan+1,2} = [block_spikes{2,chan+1,2}; sb_spike_clusters];
                            block_spikes{2,chan+1,3} = [block_spikes{2,chan+1,3}, sb_waves];
                        elseif ismember(sub_block, s2_sb_idxs)
                            block_spikes{3,chan+1,1} = [block_spikes{3,chan+1,1}; (sb_spike_times + (sum(durMAT(5,s2_sb_idxs(s2_sb_idxs<sub_block)))*param.M1_spike_wave_Fs))];
                            block_spikes{3,chan+1,2} = [block_spikes{3,chan+1,2}; sb_spike_clusters];
                            block_spikes{3,chan+1,3} = [block_spikes{3,chan+1,3}, sb_waves];
                        elseif ismember(sub_block, t2_sb_idxs)
                            block_spikes{4,chan+1,1} = [block_spikes{4,chan+1,1}; (sb_spike_times + (sum(durMAT(5,t1_sb_idxs(t1_sb_idxs<sub_block)))*param.M1_spike_wave_Fs))];
                            block_spikes{4,chan+1,2} = [block_spikes{4,chan+1,2}; sb_spike_clusters];
                            block_spikes{4,chan+1,3} = [block_spikes{4,chan+1,3}, sb_waves];
                        end
                    end
                end
            end
            clear sb_waves sb_chan_full_wave
            
            if ~s_err
                for block = 1:size(block_spikes,1)
                    M1_spike_timestamps = cell(param.M1_chans,param.M1_neurons);
                    M1_spike_waves = cell(param.M1_chans,param.M1_neurons);
                    for chan = 0:((param.M1_chans/param.M1_shant_site_num)-1)
                        dat_chan = (chan*param.M1_shant_site_num)+1;
                        for neuron = 1:length(cluster_info(chan+1).cluster_id)
                            if (strcmp(cluster_info(chan+1).group(neuron,:),'good ') || strcmp(cluster_info(chan+1).group(neuron,:),'mua  ') || strcmp(cluster_info(chan+1).group(neuron,:),'good') || strcmp(cluster_info(chan+1).group(neuron,:),'mua '))
                                if strcmp(cluster_info(chan+1).group(neuron,:),'mua  ') || strcmp(cluster_info(chan+1).group(neuron,:),'mua ')
                                    param.M1_mua_neurons{day}(dat_chan,neuron) = 1;
                                end
                                param.M1_neuron_chans{day}(dat_chan,neuron) = cluster_info(chan+1).ch(neuron);
                                M1_spike_timestamps{dat_chan,neuron} = block_spikes{block,chan+1,1}(block_spikes{block,chan+1,2} == cluster_info(chan+1).cluster_id(neuron))';
                                
                                for sub_chan = 0:(param.M1_shant_site_num-1)
                                    M1_spike_waves{dat_chan + sub_chan,neuron} = block_spikes{block,chan+1,3}(:, block_spikes{block,chan+1,2} == cluster_info(chan+1).ch(neuron),sub_chan+1);
                                end
                                M1_spike_timestamps{dat_chan,neuron} = M1_spike_timestamps{dat_chan,neuron}/param.M1_spike_wave_Fs;
                            end
                        end
                        
                    end
                    if block == 1 || block ==3 %sleep blocks
                        
                    else %training blocks
                        save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block/2},'/Spike_timestamps.mat'], 'M1_spike_timestamps', 'M1_spike_waves','-v7.3');
                    end
                end
                clear M1_spike_waves cluster_info
            end
            
            %Cb spike times
            block_spikes = cell(4,(param.Cb_chans/param.Cb_shant_site_num),3);
            for chan = 0:((param.Cb_chans/param.Cb_shant_site_num)-1)
                spike_times = double(readNPY([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(chan), '\SU_CONT_Cb_poly_', num2str(chan), '_0\SU_CONT_Cb_poly_', num2str(chan), '_0.GUI\spike_times.npy']));
                spike_clusters = readNPY([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(chan), '\SU_CONT_Cb_poly_', num2str(chan), '_0\SU_CONT_Cb_poly_', num2str(chan), '_0.GUI\spike_clusters.npy']);
                cluster_info(chan+1) = tdfread([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(chan), '\SU_CONT_Cb_poly_', num2str(chan), '_0\SU_CONT_Cb_poly_', num2str(chan), '_0.GUI\cluster_info.tsv']);
                
                if param.Cb_neurons < length(unique(spike_clusters))
                    disp(['param.Cb_neurons needs to be increased to ', num2str(length(unique(spike_clusters)))])
                    param.Cb_neurons = length(unique(spike_clusters));
                    s_err = true;
                elseif ~s_err
                    %get waveforms
                    for sub_block = 1:size(sub_block_names,1)
                        fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I086-', param.durFiles(day,11:16), '_DAT_files\Cb\Polytrode_', num2str(chan), '\SU_CONT_Cb_poly_', num2str(chan), '_', num2str(sub_block-1), '.dat'],'r');
                        sb_chan_full_wave = fread(fiD,'float32');
                        sb_chan_full_wave = reshape(sb_chan_full_wave,param.Cb_shant_site_num,length(sb_chan_full_wave)/param.Cb_shant_site_num);
                        fclose(fiD);
                        
                        durMAT(4,sub_block) = length(sb_chan_full_wave)/param.Cb_spike_wave_Fs;
                        
                        %Sort spiketimes into sub-blocks
                        sb_spike_times = spike_times(spike_times <= size(sb_chan_full_wave,2));
                        sb_spike_clusters = spike_clusters(1:length(sb_spike_times));
                        spike_clusters(1:length(sb_spike_times)) = [];
                        spike_times(1:length(sb_spike_times)) = [];
                        spike_times = spike_times - size(sb_chan_full_wave,2);
                        
                        sb_waves = nan(30, length(sb_spike_times), param.Cb_shant_site_num);
                        for i = 1:length(sb_spike_times)
                            t_stamp = sb_spike_times(i);
                            if (t_stamp + 22) <= size(sb_chan_full_wave,2) && (t_stamp - 7) > 0
                                for j = 1:param.Cb_shant_site_num
                                    sb_waves(:,i,j) = sb_chan_full_wave(j,t_stamp - 7:t_stamp + 22);
                                end
                            end
                        end
                        
                        %Truncate
                        sb_spike_times(sb_spike_times > (durMAT(5,sub_block)*param.Cb_spike_wave_Fs)) = [];
                        sb_spike_clusters = sb_spike_clusters(1:length(sb_spike_times));
                        sb_waves = sb_waves(:,1:length(sb_spike_times),:);
                        
                        %Concatinate into blocks
                        if ismember(sub_block, s1_sb_idxs)
                            block_spikes{1,chan+1,1} = [block_spikes{1,chan+1,1}; (sb_spike_times + (sum(durMAT(5,s1_sb_idxs(s1_sb_idxs<sub_block)))*param.Cb_spike_wave_Fs))];
                            block_spikes{1,chan+1,2} = [block_spikes{1,chan+1,2}; sb_spike_clusters];
                            block_spikes{1,chan+1,3} = [block_spikes{1,chan+1,3}, sb_waves];
                        elseif ismember(sub_block, t1_sb_idxs)
                            block_spikes{2,chan+1,1} = [block_spikes{2,chan+1,1}; (sb_spike_times + (sum(durMAT(5,t1_sb_idxs(t1_sb_idxs<sub_block)))*param.Cb_spike_wave_Fs))];
                            block_spikes{2,chan+1,2} = [block_spikes{2,chan+1,2}; sb_spike_clusters];
                            block_spikes{2,chan+1,3} = [block_spikes{2,chan+1,3}, sb_waves];
                        elseif ismember(sub_block, s2_sb_idxs)
                            block_spikes{3,chan+1,1} = [block_spikes{3,chan+1,1}; (sb_spike_times + (sum(durMAT(5,s2_sb_idxs(s2_sb_idxs<sub_block)))*param.Cb_spike_wave_Fs))];
                            block_spikes{3,chan+1,2} = [block_spikes{3,chan+1,2}; sb_spike_clusters];
                            block_spikes{3,chan+1,3} = [block_spikes{3,chan+1,3}, sb_waves];
                        elseif ismember(sub_block, t2_sb_idxs)
                            block_spikes{4,chan+1,1} = [block_spikes{4,chan+1,1}; (sb_spike_times + (sum(durMAT(5,t1_sb_idxs(t1_sb_idxs<sub_block)))*param.Cb_spike_wave_Fs))];
                            block_spikes{4,chan+1,2} = [block_spikes{4,chan+1,2}; sb_spike_clusters];
                            block_spikes{4,chan+1,3} = [block_spikes{4,chan+1,3}, sb_waves];
                        end
                        clear sb_waves sb_chan_full_wave
                    end
                end
            end
            clear spike_times
            
            if ~s_err
                for block = 1:size(block_spikes,1)
                    Cb_spike_timestamps = cell(param.Cb_chans,param.Cb_neurons);
                    Cb_spike_waves = cell(param.Cb_chans,param.Cb_neurons);
                    for chan = 0:((param.Cb_chans/param.Cb_shant_site_num)-1)
                        dat_chan = (chan*param.Cb_shant_site_num)+1;
                        for neuron = 1:length(cluster_info(chan+1).cluster_id)
                            if (strcmp(cluster_info(chan+1).group(neuron,:),'good ') || strcmp(cluster_info(chan+1).group(neuron,:),'mua  ') || strcmp(cluster_info(chan+1).group(neuron,:),'good') || strcmp(cluster_info(chan+1).group(neuron,:),'mua '))
                                if strcmp(cluster_info(chan+1).group(neuron,:),'mua  ') || strcmp(cluster_info(chan+1).group(neuron,:),'mua ')
                                    param.Cb_mua_neurons{day}(dat_chan,neuron) = 1;
                                end
                                param.Cb_neuron_chans{day}(dat_chan,neuron) = cluster_info(chan+1).ch(neuron);
                                Cb_spike_timestamps{dat_chan,neuron} = block_spikes{block,chan+1,1}(block_spikes{block,chan+1,2} == cluster_info(chan+1).cluster_id(neuron))';
                                
                                for sub_chan = 0:(param.Cb_shant_site_num-1)
                                    Cb_spike_waves{dat_chan + sub_chan,neuron} = block_spikes{block,chan+1,3}(:, block_spikes{block,chan+1,2} == cluster_info(chan+1).ch(neuron),sub_chan+1);
                                end
                                Cb_spike_timestamps{dat_chan,neuron} = Cb_spike_timestamps{dat_chan,neuron}/param.Cb_spike_wave_Fs;
                                
                            end
                        end
                        
                    end
                    if block == 1 || block ==3 %sleep blocks
                        
                    else %training blocks
                        load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_timestamps.mat']);
                        save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_timestamps.mat'], 'M1_spike_timestamps', 'M1_spike_waves', 'Cb_spike_timestamps', 'Cb_spike_waves', '-v7.3');
                    end
                end
                clear M1_spike_waves Cb_spike_waves
            end
            
        elseif strcmp(animal,'I064')
            param.M1_neurons = 27;
            param.Cb_neurons = 16;
            
            param.M1_mua_neurons{day} = zeros(param.M1_chans,param.M1_neurons);
            param.M1_neuron_chans{day} = nan(param.M1_chans,param.M1_neurons);
            param.Cb_mua_neurons{day} = zeros(param.Cb_chans,param.Cb_neurons);
            param.Cb_neuron_chans{day} = nan(param.Cb_chans,param.Cb_neurons);
            
            load([origin_rootpath,animal,'/',param.durFiles(day,:),'.mat']);
            sbn1 = param.sleep_block_names{day, 1};
            sbn1 = sbn1(1,10:end);
            
            %The LFP duration is the best aproximation of the spike duration
            durMAT(3,:) = durMAT(1,:);
            
            %Pre-allocation
            TimeStamps1_S1 = cell(32,param.M1_neurons);
            TimeStamps2_S1 = cell(32,param.Cb_neurons);
            TimeStamps1_B1 = cell(32,param.M1_neurons);
            TimeStamps2_B1 = cell(32,param.Cb_neurons);
            TimeStamps1_S2 = cell(32,param.M1_neurons);
            TimeStamps2_S2 = cell(32,param.Cb_neurons);
            TimeStamps1_B2 = cell(32,param.M1_neurons);
            TimeStamps2_B2 = cell(32,param.Cb_neurons);
            
            Waves1_S1 = cell(32,param.M1_neurons);
            Waves2_S1 = cell(32,param.Cb_neurons);
            Waves1_S2 = cell(32,param.M1_neurons);
            Waves2_S2 = cell(32,param.Cb_neurons);
            Waves1_B1 = cell(32,param.M1_neurons);
            Waves2_B1 = cell(32,param.Cb_neurons);
            Waves1_B2 = cell(32,param.M1_neurons);
            Waves2_B2 = cell(32,param.Cb_neurons);
            
            %M1 spike times
            for chan = 0:31
                spike_times = double(readNPY([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_0\SU_CONT_M1_Ch_', num2str(chan), '_0.GUI\spike_times.npy']));
                spike_clusters = readNPY([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_0\SU_CONT_M1_Ch_', num2str(chan), '_0.GUI\spike_clusters.npy']);
                cluster_info = tdfread([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_0\SU_CONT_M1_Ch_', num2str(chan), '_0.GUI\cluster_info.tsv']);
                
                if (param.M1_neurons - 1) < max(spike_clusters)
                    error(['param.M1_neurons needs to be increased to ', num2str(max(spike_clusters)+1)])
                end
                
                %get waveforms
                if day == 0
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_2.dat'],'r');
                    chan_full_wave_S1 = fread(fiD,'float32');
                    chan_full_wave_S1 = reshape(chan_full_wave_S1,1,length(chan_full_wave_S1)/1);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_4.dat'],'r');
                    chan_full_wave_B1 = fread(fiD,'float32');
                    chan_full_wave_B1 = reshape(chan_full_wave_B1,1,length(chan_full_wave_B1)/1);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_5.dat'],'r');
                    chan_full_wave_S2 = fread(fiD,'float32');
                    chan_full_wave_S2 = reshape(chan_full_wave_S2,1,length(chan_full_wave_S2)/1);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_6.dat'],'r');
                    chan_full_wave_B2 = fread(fiD,'float32');
                    chan_full_wave_B2 = reshape(chan_full_wave_B2,1,length(chan_full_wave_B2)/1);
                    fclose(fiD);
                    
                    %Get the false-start blocks so that those parts can be removed from the spike train
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_0.dat'],'r');
                    chan_full_wave_bad1 = fread(fiD,'float32');
                    chan_full_wave_bad1 = reshape(chan_full_wave_bad1,1,length(chan_full_wave_bad1)/1);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_1.dat'],'r');
                    chan_full_wave_bad2 = fread(fiD,'float32');
                    chan_full_wave_bad2 = reshape(chan_full_wave_bad2,1,length(chan_full_wave_bad2)/1);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_3.dat'],'r');
                    chan_full_wave_bad3 = fread(fiD,'float32');
                    chan_full_wave_bad3 = reshape(chan_full_wave_bad3,1,length(chan_full_wave_bad3)/1);
                    fclose(fiD);
                else
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_0.dat'],'r');
                    chan_full_wave_S1 = fread(fiD,'float32');
                    chan_full_wave_S1 = reshape(chan_full_wave_S1,1,length(chan_full_wave_S1)/1);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_1.dat'],'r');
                    chan_full_wave_B1 = fread(fiD,'float32');
                    chan_full_wave_B1 = reshape(chan_full_wave_B1,1,length(chan_full_wave_B1)/1);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_2.dat'],'r');
                    chan_full_wave_S2 = fread(fiD,'float32');
                    chan_full_wave_S2 = reshape(chan_full_wave_S2,1,length(chan_full_wave_S2)/1);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\M1\Channel_', num2str(chan), '\SU_CONT_M1_Ch_', num2str(chan), '_3.dat'],'r');
                    chan_full_wave_B2 = fread(fiD,'float32');
                    chan_full_wave_B2 = reshape(chan_full_wave_B2,1,length(chan_full_wave_B2)/1);
                    fclose(fiD);
                end
                
                %Set durMAT for M1 spikes
                durMAT(3,:) = [length(chan_full_wave_S1)/param.M1_spike_wave_Fs, length(chan_full_wave_B1)/param.M1_spike_wave_Fs, length(chan_full_wave_S2)/param.M1_spike_wave_Fs, length(chan_full_wave_B2)/param.M1_spike_wave_Fs];
                
                %sort spiketimes into blocks - delete if un-used
                if(day == 0)
                    %remove first two bad blocks
                    spike_times_bad1 = spike_times(spike_times <= size(chan_full_wave_bad1,2));
                    spike_clusters_bad1 = spike_clusters(1:length(spike_times_bad1));
                    spike_clusters(1:length(spike_times_bad1)) = [];
                    spike_times(1:length(spike_times_bad1)) = [];
                    spike_times = spike_times - size(chan_full_wave_bad1,2);
                    
                    spike_times_bad2 = spike_times(spike_times <= size(chan_full_wave_bad2,2));
                    spike_clusters_bad2 = spike_clusters(1:length(spike_times_bad2));
                    spike_clusters(1:length(spike_times_bad2)) = [];
                    spike_times(1:length(spike_times_bad2)) = [];
                    spike_times = spike_times - size(chan_full_wave_bad2,2);
                    
                    clear chan_full_wave_bad1 chan_full_wave_bad2 spike_times_bad1 spike_times_bad2 spike_clusters_bad1 spike_clusters_bad2
                end
                
                spike_times_S1 = spike_times(spike_times <= size(chan_full_wave_S1,2));
                spike_clusters_S1 = spike_clusters(1:length(spike_times_S1));
                spike_clusters(1:length(spike_times_S1)) = [];
                spike_times(1:length(spike_times_S1)) = [];
                spike_times = spike_times - size(chan_full_wave_S1,2);
                
                if(day == 0)
                    %remove final bad block
                    spike_times_bad3 = spike_times(spike_times <= size(chan_full_wave_bad3,2));
                    spike_clusters_bad3 = spike_clusters(1:length(spike_times_bad3));
                    spike_clusters(1:length(spike_times_bad3)) = [];
                    spike_times(1:length(spike_times_bad3)) = [];
                    spike_times = spike_times - size(chan_full_wave_bad3,2);
                    
                    clear chan_full_wave_bad3 spike_times_bad3 spike_clusters_bad3
                end
                
                spike_times_B1 = spike_times(spike_times <= size(chan_full_wave_B1,2));
                spike_clusters_B1 = spike_clusters(1:length(spike_times_B1));
                spike_clusters(1:length(spike_times_B1)) = [];
                spike_times(1:length(spike_times_B1)) = [];
                spike_times = spike_times - size(chan_full_wave_B1,2);
                
                spike_times_S2 = spike_times(spike_times <= size(chan_full_wave_S2,2));
                spike_clusters_S2 = spike_clusters(1:length(spike_times_S2));
                spike_clusters(1:length(spike_times_S2)) = [];
                spike_times(1:length(spike_times_S2)) = [];
                spike_times = spike_times - size(chan_full_wave_S2,2);
                
                spike_times_B2 = spike_times(spike_times <= size(chan_full_wave_B2,2));
                spike_clusters_B2 = spike_clusters(1:length(spike_times_B2));
                
                %sort timestamps into neurons
                dat_chan = (chan)+1;
                for neuron = 1:param.M1_neurons
                    
                    if size(cluster_info.group,1) >= neuron && (strcmp(cluster_info.group(neuron,:),'good ') || strcmp(cluster_info.group(neuron,:),'mua  '))
                        if strcmp(cluster_info.group(neuron,:),'mua  ')
                            param.M1_mua_neurons{day}(dat_chan,neuron) = 1;
                        end
                        param.M1_neuron_chans{day}(dat_chan,neuron) = cluster_info.ch(neuron);
                        TimeStamps1_S1{dat_chan,neuron} = spike_times_S1(spike_clusters_S1 == (neuron-1))';
                        TimeStamps1_B1{dat_chan,neuron} = spike_times_B1(spike_clusters_B1 == (neuron-1))';
                        TimeStamps1_S2{dat_chan,neuron} = spike_times_S2(spike_clusters_S2 == (neuron-1))';
                        TimeStamps1_B2{dat_chan,neuron} = spike_times_B2(spike_clusters_B2 == (neuron-1))';
                    end
                    
                    %sort waveforms into the sub-channels of the neuron's tetrode
                    
                    Waves1_S1{dat_chan,neuron} = zeros(30,length(TimeStamps1_S1{dat_chan,neuron}));
                    for i = 1:length(TimeStamps1_S1{dat_chan,neuron})
                        t_stamp = TimeStamps1_S1{dat_chan,neuron}(i);
                        if (t_stamp + 22) <= size(chan_full_wave_S1,2) && (t_stamp - 7) > 0
                            Waves1_S1{dat_chan,neuron}(:,i) = chan_full_wave_S1(1,t_stamp - 7:t_stamp + 22);
                        end
                    end
                    
                    Waves1_B1{dat_chan,neuron} = zeros(30,length(TimeStamps1_B1{dat_chan,neuron}));
                    for i = 1:length(TimeStamps1_B1{dat_chan,neuron})
                        t_stamp = TimeStamps1_B1{dat_chan,neuron}(i);
                        if (t_stamp + 22) <= size(chan_full_wave_B1,2) && (t_stamp - 7) > 0
                            Waves1_B1{dat_chan,neuron}(:,i) = chan_full_wave_B1(1,t_stamp - 7:t_stamp + 22);
                        end
                    end
                    
                    Waves1_S2{dat_chan,neuron} = zeros(30,length(TimeStamps1_S2{dat_chan,neuron}));
                    for i = 1:length(TimeStamps1_S2{dat_chan,neuron})
                        t_stamp = TimeStamps1_S2{dat_chan,neuron}(i);
                        if (t_stamp + 22) <= size(chan_full_wave_S2,2) && (t_stamp - 7) > 0
                            Waves1_S2{dat_chan,neuron}(:,i) = chan_full_wave_S2(1,t_stamp - 7:t_stamp + 22);
                        end
                    end
                    
                    Waves1_B2{dat_chan,neuron} = zeros(30,length(TimeStamps1_B2{dat_chan,neuron}));
                    for i = 1:length(TimeStamps1_B2{dat_chan,neuron})
                        t_stamp = TimeStamps1_B2{dat_chan,neuron}(i);
                        if (t_stamp + 22) <= size(chan_full_wave_B2,2) && (t_stamp - 7) > 0
                            Waves1_B2{dat_chan,neuron}(:,i) = chan_full_wave_B2(1,t_stamp - 7:t_stamp + 22);
                        end
                    end
                    TimeStamps1_S1{dat_chan,neuron} = TimeStamps1_S1{dat_chan,neuron}/param.M1_spike_wave_Fs;
                    TimeStamps1_B1{dat_chan,neuron} = TimeStamps1_B1{dat_chan,neuron}/param.M1_spike_wave_Fs;
                    TimeStamps1_S2{dat_chan,neuron} = TimeStamps1_S2{dat_chan,neuron}/param.M1_spike_wave_Fs;
                    TimeStamps1_B2{dat_chan,neuron} = TimeStamps1_B2{dat_chan,neuron}/param.M1_spike_wave_Fs;
                end
            end
            
            %Cb spike times
            for poly = 0:7
                spike_times = double(readNPY([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\Cb\Tetrode_', num2str(poly), '\SU_CONT_Cb_tet_', num2str(poly), '_0\SU_CONT_Cb_tet_', num2str(poly), '_0.GUI\spike_times.npy']));
                spike_clusters = readNPY([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\Cb\Tetrode_', num2str(poly), '\SU_CONT_Cb_tet_', num2str(poly), '_0\SU_CONT_Cb_tet_', num2str(poly), '_0.GUI\spike_clusters.npy']);
                cluster_info = tdfread([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\Cb\Tetrode_', num2str(poly), '\SU_CONT_Cb_tet_', num2str(poly), '_0\SU_CONT_Cb_tet_', num2str(poly), '_0.GUI\cluster_info.tsv']);
                
                if (param.Cb_neurons - 1) < max(spike_clusters)
                    error(['param.Cb_neurons needs to be increased to ', num2str(max(spike_clusters)+1)])
                end
                
                %delete if un-needed
                if day == 0
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\Cb\Tetrode_', num2str(poly), '\SU_CONT_Cb_tet_', num2str(poly), '_2.dat'],'r');
                    chan_full_wave_S1 = fread(fiD,'float32');
                    chan_full_wave_S1 = reshape(chan_full_wave_S1,4,length(chan_full_wave_S1)/4);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\Cb\Tetrode_', num2str(poly), '\SU_CONT_Cb_tet_', num2str(poly), '_4.dat'],'r');
                    chan_full_wave_B1 = fread(fiD,'float32');
                    chan_full_wave_B1 = reshape(chan_full_wave_B1,4,length(chan_full_wave_B1)/4);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\Cb\Tetrode_', num2str(poly), '\SU_CONT_Cb_tet_', num2str(poly), '_5.dat'],'r');
                    chan_full_wave_S2 = fread(fiD,'float32');
                    chan_full_wave_S2 = reshape(chan_full_wave_S2,4,length(chan_full_wave_S2)/4);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\Cb\Tetrode_', num2str(poly), '\SU_CONT_Cb_tet_', num2str(poly), '_6.dat'],'r');
                    chan_full_wave_B2 = fread(fiD,'float32');
                    chan_full_wave_B2 = reshape(chan_full_wave_B2,4,length(chan_full_wave_B2)/4);
                    fclose(fiD);
                    
                    %Get the false-start blocks so that those parts can be removed from the spike train
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\Cb\Tetrode_', num2str(poly), '\SU_CONT_Cb_tet_', num2str(poly), '_0.dat'],'r');
                    chan_full_wave_bad1 = fread(fiD,'float32');
                    chan_full_wave_bad1 = reshape(chan_full_wave_bad1,4,length(chan_full_wave_bad1)/4);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\Cb\Tetrode_', num2str(poly), '\SU_CONT_Cb_tet_', num2str(poly), '_1.dat'],'r');
                    chan_full_wave_bad2 = fread(fiD,'float32');
                    chan_full_wave_bad2 = reshape(chan_full_wave_bad2,4,length(chan_full_wave_bad2)/4);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\Cb\Tetrode_', num2str(poly), '\SU_CONT_Cb_tet_', num2str(poly), '_3.dat'],'r');
                    chan_full_wave_bad3 = fread(fiD,'float32');
                    chan_full_wave_bad3 = reshape(chan_full_wave_bad3,4,length(chan_full_wave_bad3)/4);
                    fclose(fiD);
                else
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\Cb\Tetrode_', num2str(poly), '\SU_CONT_Cb_tet_', num2str(poly), '_0.dat'],'r');
                    chan_full_wave_S1 = fread(fiD,'float32');
                    chan_full_wave_S1 = reshape(chan_full_wave_S1,4,length(chan_full_wave_S1)/4);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\Cb\Tetrode_', num2str(poly), '\SU_CONT_Cb_tet_', num2str(poly), '_1.dat'],'r');
                    chan_full_wave_B1 = fread(fiD,'float32');
                    chan_full_wave_B1 = reshape(chan_full_wave_B1,4,length(chan_full_wave_B1)/4);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\Cb\Tetrode_', num2str(poly), '\SU_CONT_Cb_tet_', num2str(poly), '_2.dat'],'r');
                    chan_full_wave_S2 = fread(fiD,'float32');
                    chan_full_wave_S2 = reshape(chan_full_wave_S2,4,length(chan_full_wave_S2)/4);
                    fclose(fiD);
                    fiD = fopen([origin_rootpath,animal,'\',param.Spike_path,'\I064-', param.durFiles(day,11:16), '_DAT_files\Cb\Tetrode_', num2str(poly), '\SU_CONT_Cb_tet_', num2str(poly), '_3.dat'],'r');
                    chan_full_wave_B2 = fread(fiD,'float32');
                    chan_full_wave_B2 = reshape(chan_full_wave_B2,4,length(chan_full_wave_B2)/4);
                    fclose(fiD);
                end
                
                %Set durMAT for Cb spikes
                durMAT(4,:) = [length(chan_full_wave_S1)/param.Cb_spike_wave_Fs, length(chan_full_wave_B1)/param.Cb_spike_wave_Fs, length(chan_full_wave_S2)/param.Cb_spike_wave_Fs, length(chan_full_wave_B2)/param.Cb_spike_wave_Fs];
                
                %sort spiketimes into blocks
                if(day == 0)
                    %remove first two bad blocks
                    spike_times_bad1 = spike_times(spike_times <= size(chan_full_wave_bad1,2));
                    spike_clusters_bad1 = spike_clusters(1:length(spike_times_bad1));
                    spike_clusters(1:length(spike_times_bad1)) = [];
                    spike_times(1:length(spike_times_bad1)) = [];
                    spike_times = spike_times - size(chan_full_wave_bad1,2);
                    
                    spike_times_bad2 = spike_times(spike_times <= size(chan_full_wave_bad2,2));
                    spike_clusters_bad2 = spike_clusters(1:length(spike_times_bad2));
                    spike_clusters(1:length(spike_times_bad2)) = [];
                    spike_times(1:length(spike_times_bad2)) = [];
                    spike_times = spike_times - size(chan_full_wave_bad2,2);
                    
                    clear chan_full_wave_bad1 chan_full_wave_bad2 spike_times_bad1 spike_times_bad2 spike_clusters_bad1 spike_clusters_bad2
                end
                
                spike_times_S1 = spike_times(spike_times <= size(chan_full_wave_S1,2));
                spike_clusters_S1 = spike_clusters(1:length(spike_times_S1));
                spike_clusters(1:length(spike_times_S1)) = [];
                spike_times(1:length(spike_times_S1)) = [];
                spike_times = spike_times - size(chan_full_wave_S1,2);
                
                if(day == 0)
                    %remove final bad block
                    spike_times_bad3 = spike_times(spike_times <= size(chan_full_wave_bad3,2));
                    spike_clusters_bad3 = spike_clusters(1:length(spike_times_bad3));
                    spike_clusters(1:length(spike_times_bad3)) = [];
                    spike_times(1:length(spike_times_bad3)) = [];
                    spike_times = spike_times - size(chan_full_wave_bad3,2);
                    
                    clear chan_full_wave_bad3 spike_times_bad3 spike_clusters_bad3
                end
                
                spike_times_B1 = spike_times(spike_times <= size(chan_full_wave_B1,2));
                spike_clusters_B1 = spike_clusters(1:length(spike_times_B1));
                spike_clusters(1:length(spike_times_B1)) = [];
                spike_times(1:length(spike_times_B1)) = [];
                spike_times = spike_times - size(chan_full_wave_B1,2);
                
                spike_times_S2 = spike_times(spike_times <= size(chan_full_wave_S2,2));
                spike_clusters_S2 = spike_clusters(1:length(spike_times_S2));
                spike_clusters(1:length(spike_times_S2)) = [];
                spike_times(1:length(spike_times_S2)) = [];
                spike_times = spike_times - size(chan_full_wave_S2,2);
                
                spike_times_B2 = spike_times(spike_times <= size(chan_full_wave_B2,2));
                spike_clusters_B2 = spike_clusters(1:length(spike_times_B2));
                
                %sort timestamps into neurons
                dat_chan = (poly*4)+1;
                for neuron = 1:param.Cb_neurons
                    
                    if size(cluster_info.group,1) >= neuron && (strcmp(cluster_info.group(neuron,:),'good ') || strcmp(cluster_info.group(neuron,:),'mua  '))
                        if strcmp(cluster_info.group(neuron,:),'mua  ')
                            param.Cb_mua_neurons{day}(dat_chan,neuron) = 1;
                        end
                        param.Cb_neuron_chans{day}(dat_chan,neuron) = cluster_info.ch(neuron);
                        TimeStamps2_S1{dat_chan,neuron} = spike_times_S1(spike_clusters_S1 == (neuron-1))';
                        TimeStamps2_B1{dat_chan,neuron} = spike_times_B1(spike_clusters_B1 == (neuron-1))';
                        TimeStamps2_S2{dat_chan,neuron} = spike_times_S2(spike_clusters_S2 == (neuron-1))';
                        TimeStamps2_B2{dat_chan,neuron} = spike_times_B2(spike_clusters_B2 == (neuron-1))';
                    end
                    
                    %sort waveforms into the sub-channels of the neuron's tetrode
                    for sub_chan = 0:3
                        
                        Waves2_S1{dat_chan + sub_chan,neuron} = zeros(30,length(TimeStamps2_S1{dat_chan,neuron}));
                        for i = 1:length(TimeStamps2_S1{dat_chan,neuron})
                            t_stamp = TimeStamps2_S1{dat_chan,neuron}(i);
                            if (t_stamp + 22) <= size(chan_full_wave_S1,2) && (t_stamp - 7) > 0
                                Waves2_S1{dat_chan + sub_chan,neuron}(:,i) = chan_full_wave_S1(sub_chan+1,t_stamp - 7:t_stamp + 22);
                            end
                        end
                        
                        Waves2_B1{dat_chan + sub_chan,neuron} = zeros(30,length(TimeStamps2_B1{dat_chan,neuron}));
                        for i = 1:length(TimeStamps2_B1{dat_chan,neuron})
                            t_stamp = TimeStamps2_B1{dat_chan,neuron}(i);
                            if (t_stamp + 22) <= size(chan_full_wave_B1,2) && (t_stamp - 7) > 0
                                Waves2_B1{dat_chan + sub_chan,neuron}(:,i) = chan_full_wave_B1(sub_chan+1,t_stamp - 7:t_stamp + 22);
                            end
                        end
                        
                        Waves2_S2{dat_chan + sub_chan,neuron} = zeros(30,length(TimeStamps2_S2{dat_chan,neuron}));
                        for i = 1:length(TimeStamps2_S2{dat_chan,neuron})
                            t_stamp = TimeStamps2_S2{dat_chan,neuron}(i);
                            if (t_stamp + 22) <= size(chan_full_wave_S2,2) && (t_stamp - 7) > 0
                                Waves2_S2{dat_chan + sub_chan,neuron}(:,i) = chan_full_wave_S2(sub_chan+1,t_stamp - 7:t_stamp + 22);
                            end
                        end
                        
                        Waves2_B2{dat_chan + sub_chan,neuron} = zeros(30,length(TimeStamps2_B2{dat_chan,neuron}));
                        for i = 1:length(TimeStamps2_B2{dat_chan,neuron})
                            t_stamp = TimeStamps2_B2{dat_chan,neuron}(i);
                            if (t_stamp + 22) <= size(chan_full_wave_B2,2) && (t_stamp - 7) > 0
                                Waves2_B2{dat_chan + sub_chan,neuron}(:,i) = chan_full_wave_B2(sub_chan+1,t_stamp - 7:t_stamp + 22);
                            end
                        end
                    end
                    TimeStamps2_S1{dat_chan,neuron} = TimeStamps2_S1{dat_chan,neuron}/param.Cb_spike_wave_Fs;
                    TimeStamps2_B1{dat_chan,neuron} = TimeStamps2_B1{dat_chan,neuron}/param.Cb_spike_wave_Fs;
                    TimeStamps2_S2{dat_chan,neuron} = TimeStamps2_S2{dat_chan,neuron}/param.Cb_spike_wave_Fs;
                    TimeStamps2_B2{dat_chan,neuron} = TimeStamps2_B2{dat_chan,neuron}/param.Cb_spike_wave_Fs;
                end
            end
            
            %save data in source directory
            for block = 1:size(param.training_block_names,2)
                save([origin_rootpath,animal,'\',param.Spike_path,'\',param.training_block_names{day, block},'/Timestamps_B',num2str(block),'.mat'], ['TimeStamps1_B', num2str(block)], ['TimeStamps2_B', num2str(block)]);
                save([origin_rootpath,animal,'\',param.Spike_path,'\',param.training_block_names{day, block},'/Waves_B',num2str(block),'.mat'], ['Waves1_B', num2str(block)], ['Waves2_B', num2str(block)], '-v7.3');
            end
            
            %Truncate spiketimes and waves
            for n_idx = 1:length(TimeStamps1_B1(:))
                if ~isempty(TimeStamps1_B1{n_idx})
                    TimeStamps1_B1{n_idx} = TimeStamps1_B1{n_idx}(TimeStamps1_B1{n_idx} <= durMAT(5,2));
                    Waves1_B1{n_idx} = Waves1_B1{n_idx}(:,(TimeStamps1_B1{n_idx} <= durMAT(5,2)));
                end
            end
            for n_idx = 1:length(TimeStamps2_B1(:))
                if ~isempty(TimeStamps2_B1{n_idx})
                    TimeStamps2_B1{n_idx} = TimeStamps2_B1{n_idx}(TimeStamps2_B1{n_idx} <= durMAT(5,2));
                    for i = 0:3
                        Waves2_B1{n_idx+i} = Waves2_B1{n_idx+i}(:,(TimeStamps2_B1{n_idx} <= durMAT(5,2)));
                    end
                end
            end
            for n_idx = 1:length(TimeStamps1_B2(:))
                if ~isempty(TimeStamps1_B2{n_idx})
                    TimeStamps1_B2{n_idx} = TimeStamps1_B2{n_idx}(TimeStamps1_B2{n_idx} <= durMAT(5,4));
                    Waves1_B2{n_idx} = Waves1_B2{n_idx}(:,(TimeStamps1_B2{n_idx} <= durMAT(5,4)));
                end
            end
            for n_idx = 1:length(TimeStamps2_B2(:))
                if ~isempty(TimeStamps2_B2{n_idx})
                    TimeStamps2_B2{n_idx} = TimeStamps2_B2{n_idx}(TimeStamps2_B2{n_idx} <= durMAT(5,4));
                    for i = 0:3
                        Waves2_B2{n_idx+i} = Waves2_B2{n_idx+i}(:,(TimeStamps2_B2{n_idx} <= durMAT(5,4)));
                    end
                end
            end
        else
            error('Unrecognized animal ID');
        end
        
        %Rename and save
        if ~strcmp(animal, 'I086')
            var_idx = 1;
            for block = 1:length(param.block_names)
                M1_spike_timestamps = eval(['TimeStamps1_B', num2str(var_idx)]);
                M1_spike_waves = eval(['Waves1_B', num2str(var_idx)]);
                Cb_spike_timestamps = eval(['TimeStamps2_B', num2str(var_idx)]);
                Cb_spike_waves = eval(['Waves2_B', num2str(var_idx)]);
                
                save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_timestamps.mat'], 'M1_spike_timestamps', 'Cb_spike_timestamps', 'M1_spike_waves', 'Cb_spike_waves','-v7.3');
                var_idx = var_idx+1;
            end
        end
        
        clearvars -except code_rootpath rootpath origin_rootpath animal param enabled day s_err;
    end
    save([rootpath,animal,'/Parameters.mat'],'param');
    rmpath(genpath('Z:\BMI_Analysis'))
    rmpath(genpath('Z:\Matlab Offline Files SDK'))
    rmpath(genpath([code_rootpath, 'RunSpykingCircusSorter-master']))
    clear day s_err;
end

%% Create Spiketrain Snapshots (30)

if enabled(30)
    disp('Block 30...')
%     addpath(genpath('Z:\Matlab for analysis'))
%     Fs = 1017.3;
%     bin_size = 25; %In miliseconds
%     hist_indexes = (-4000+(bin_size/2)):bin_size:(4000-(bin_size/2));
    for day=1:param.days
%         M1_day = cell(32,6);
%         Cb_day = cell(32,6);
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_timestamps.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/reach_onset_delays.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/WAV_Truncated.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
                        
            [M1_spike_snapshots_full, Cb_spike_snapshots_full_temp] = spike_snapshot_extraction(M1_spike_timestamps, Cb_spike_timestamps, WAVE2_t, param.M1_Fs, param.Cb_Fs, param.Wave_Fs, Oseconds, data, 4, 4);
            Cb_spike_snapshots_full = cell(size(Cb_spike_snapshots_full_temp));
            Cb_spike_snapshots_full(1:4:size(Cb_spike_snapshots_full_temp,1),:) = Cb_spike_snapshots_full_temp(1:4:size(Cb_spike_snapshots_full_temp,1),:);
            
%             for chan = 1:32
%                 for node = 1:6
%                     M1_day{chan,node} = [M1_day{chan,node}, M1_spike_snapshots_full{chan,node,:}];
%                     Cb_day{chan,node} = [Cb_day{chan,node}, Cb_spike_snapshots_full{chan,node,:}];
%                 end
%             end

            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/spiketrain_snapshots_full.mat'], 'M1_spike_snapshots_full', 'Cb_spike_snapshots_full');

            clearvars -except code_rootpath rootpath origin_rootpath animal param enabled day block;
        end
    end
    clear day block;
end

%% Identify task-related sub-set and create Single-Neuron Spike Histograms and Rasters (31)

if enabled(31)
    disp('Block 31...')
    save_figs = true;
    addpath(genpath('Z:\Matlab for analysis'))
    bin_size = 25; %In miliseconds
    hist_indexes = (-4000+(bin_size/2)):bin_size:(4000-(bin_size/2)); %In miliseconds
    M1_hist_indexes = (hist_indexes+4000)*param.M1_Fs/1000;
    Cb_hist_indexes = (hist_indexes+4000)*param.Cb_Fs/1000;
    bp = barsdefaultParams;
    bp.prior_id = 'POISSON';
    bp.dparams = 4;
    bp.use_logspline = 0;
    
    baseline_range = [-4000 -2000];
    roi_boundaries = [-350 850];
    window_width = 200;
    window_step_size = 25; %In miliseconds
    param.M1_task_related_neurons = cell(param.days,1);
    param.Cb_task_related_neurons = cell(param.days,1);
    task_related_sdv_threshold = 1.25;
    wave_plot_num = 200;
    
    win_size = ceil(window_width/bin_size);
    step_size = ceil(window_step_size/bin_size);
    if roi_boundaries(2) - roi_boundaries(1) < window_width
        error('Window larger than the region of interest')
    end
    if max([baseline_range, roi_boundaries]) > 4000 || min([baseline_range, roi_boundaries]) < -4000
        error('Baseline range or region of interest is outside of snapshot range')
    end
    
    multiphasic_time_window = [250 500]; %In miliseconds
    multiphasic_sdv_threshold = 0.25;
    param.smoothing_param = 0.00001; %SmoothingParam recomended to be 1/(1+(h^3/6)) where h is the spacing between data points, i.e. the bin width. This would be roughly 0.0004. This wasn't low enough.
    param.M1_multiphasic_neurons = cell(param.days,1);
    param.Cb_multiphasic_neurons = cell(param.days,1);
        
    for day=1:param.days
        M1_day_bins = zeros(param.M1_chans, param.M1_neurons, length(hist_indexes));
        Cb_day_bins = zeros(param.Cb_chans, param.Cb_neurons, length(hist_indexes));
        
        param.M1_multiphasic_neurons{day} = false(param.M1_chans, param.M1_neurons);
        param.Cb_multiphasic_neurons{day} = false(param.Cb_chans, param.Cb_neurons);
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/spiketrain_snapshots_full.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_timestamps.mat']);
            if exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_waveforms.mat'], 'file')
                load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_waveforms.mat']);
            end
            
            if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_Figures'],'dir')
                mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_Figures']);
            end
            
            [chans, codes, trials] = size(M1_spike_snapshots_full);
            num_neurons = sum(sum(~cellfun('isempty',M1_spike_timestamps)));
            all_M1_neuron_ave_hz = zeros(num_neurons,8000/bin_size);
            all_M1_neuron_alt_hist = zeros(num_neurons,8000/bin_size);
            all_M1_neuron_trial_bins = zeros(num_neurons,8000/bin_size,trials);
            neuron_num = 1;
            for chan = 1:param.M1_shant_site_num:chans
                for code = 1:codes
                    clear bins bin_tags ave_hz trial_raster* raster_*
                    if isempty(M1_spike_timestamps{chan, code})
                        continue
                    end
                    bins = zeros(1,8000/bin_size);
                    all_trial_bins = zeros(trials,8000/bin_size);
                    raster_x = [];
                    raster_y = [];
                    for trial = 1:trials
                        bin_tags = M1_spike_snapshots_full{chan, code, trial};
                        [trial_bins, ~] = hist(bin_tags, M1_hist_indexes);
                        all_trial_bins(trial,:) = trial_bins;
                        bins = bins + trial_bins;
                        trial_raster_x = (bin_tags*1000/param.M1_Fs)-4000;
                        trial_raster_y = ones(size(trial_raster_x)) * trial;
                        raster_x = [raster_x trial_raster_x]; %#ok<AGROW>
                        raster_y = [raster_y trial_raster_y]; %#ok<AGROW>
                    end
                    if isempty(all_trial_bins)
                        std_err = zeros(1,size(all_trial_bins,2));
                    else
                        std_err = std(all_trial_bins);%/sqrt(trials);
                    end
                    if trials==0
                        ave_hz = zeros(size(bins));
                    else
                        ave_hz = (bins/trials)*(1000/bin_size);
                    end
                    if exist('M1_spike_waves','var')
                        wave_win_len = size(M1_spike_waves{chan, code},1);
                    end
                    
                    M1_day_bins(chan,code,:) = M1_day_bins(chan,code,:) + shiftdim(bins,-1);
                    
                    hist_figure = figure;
                    subplot(4,3,1:9)
                    spike_hist = bar(hist_indexes,ave_hz,'FaceColor',[1 0.6 0.6]);
                    
%                     clear peth2
%                     peth2.fit = barsP(ave_hz,[0 8]/Fs,trials,bp);
%                     s_ave_hz = peth2.fit.mean';
                    clear ss_fit
                    ss_fit = fit(hist_indexes', ave_hz', 'smoothingspline', 'SmoothingParam', param.smoothing_param);
                    s_ave_hz = ss_fit(hist_indexes(1):hist_indexes(end))';
                    
                    %Determine if multiphasic
                    [a_corr, lags] = xcorr(s_ave_hz);
                    base_mean = mean(a_corr((lags >= 100) & (lags <= multiphasic_time_window(1))));
                    base_sdv = std(a_corr((lags >= 100) & (lags <= multiphasic_time_window(1))));
                    intrest_mean = mean(a_corr((lags >= multiphasic_time_window(1)) & (lags <= multiphasic_time_window(2))));
                    param.M1_multiphasic_neurons{day}(chan,code) =  intrest_mean > (base_mean + (multiphasic_sdv_threshold * base_sdv));
                    smooth_rate_line = line(hist_indexes(1):hist_indexes(end),s_ave_hz,'Color',[1 0 0]);
                    xlabel('Time (ms)');
                    ylabel('Spike Rate (hz)');
                    
                    subplot(4,3,10)
                    if exist('M1_spike_waves','var')
                        num_waves = min(size(M1_spike_waves{chan, code},2),wave_plot_num);
                        hold on
                        plot((-6:(wave_win_len-7))/((param.M1_spike_wave_Fs)/1000),M1_spike_waves{chan, code}(:,1:num_waves)*1000,'Color',[.7 .7 .7])
                        plot((-6:(wave_win_len-7))/((param.M1_spike_wave_Fs)/1000),mean(M1_spike_waves{chan, code}(:,1:num_waves),2)*1000,'Color',[.9 .1 .1],'LineWidth',2.0)
                    end
                    xlabel('Time (ms)');
                    ylabel('Voltage (mV)');
                    if save_figs
                        saveas(hist_figure,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_Figures/M1_spiking_histogram_channel', num2str(chan), '_cell', num2str(code), '.tiff']);
                        saveas(hist_figure,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_Figures/M1_spiking_histogram_channel', num2str(chan), '_cell', num2str(code), '.fig']);
                    end
                    close all
                    spike_raster = figure;
                    plot([raster_x; raster_x],[0; 1]+raster_y,'LineWidth',1,'Color',rgb('Red'));%spike_raster = scatter(raster_x,raster_y,'r.');
                    xlabel('Time (ms)');
                    ylabel('Spike Occurences (by trial)');
                    if save_figs
                        saveas(spike_raster',[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_Figures/M1_spiking_raster_channel', num2str(chan), '_cell', num2str(code), '.tiff']);
                        saveas(spike_raster,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_Figures/M1_spiking_raster_channel', num2str(chan), '_cell', num2str(code), '.fig']);
                    end
                    close all
                    
%                     peth2.fit = barsP(std_err,[0 8]/Fs,trials,bp);
%                     s_std_err = [s_ave_hz + peth2.fit.mean'; s_ave_hz - peth2.fit.mean'];
                    clear ss_fit
                    ss_fit = fit(hist_indexes', std_err', 'smoothingspline', 'SmoothingParam', param.smoothing_param);
                    s_std_err = [(s_ave_hz + ss_fit(hist_indexes(1):hist_indexes(end))'); (s_ave_hz - ss_fit(hist_indexes(1):hist_indexes(end))')];
                    
                    shadedErrorBar(hist_indexes(1):hist_indexes(end), s_ave_hz, s_std_err,'r-');
                    temp = gcf;
                    axis([-1000 1500 0 temp.CurrentAxes.YLim(2)]);
                    xlabel('Time (ms)');
                    ylabel('Spike Rate (hz)');
                    if save_figs
                        saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_Figures/M1_firing_rate_channel', num2str(chan), '_cell', num2str(code), '.fig']);
                    end
                    close all
                    
                    all_M1_neuron_ave_hz(neuron_num,:) = ave_hz;
                    all_M1_neuron_alt_hist(neuron_num,:) = bins;
                    all_M1_neuron_trial_bins(neuron_num,:,:) = all_trial_bins';
                    neuron_num = neuron_num + 1;
                end
            end
            all_M1_neuron_hist = (all_M1_neuron_ave_hz*trials)*(bin_size/1000);
            
            [chans, codes, trials] = size(Cb_spike_snapshots_full);
            num_neurons = sum(sum(~cellfun('isempty',Cb_spike_timestamps)));
            all_Cb_neuron_ave_hz = zeros(num_neurons,8000/bin_size);
            all_Cb_neuron_trial_bins = zeros(num_neurons,8000/bin_size,trials);
            neuron_num = 1;
            for chan = 1:param.Cb_shant_site_num:chans
                for code = 1:codes
                    if isempty(Cb_spike_timestamps{chan, code})
                        continue
                    end
                    bins = zeros(1,8000/bin_size);
                    all_trial_bins = zeros(trials,8000/bin_size);
                    raster_x = [];
                    raster_y = [];
                    for trial = 1:trials
                        bin_tags = Cb_spike_snapshots_full{chan, code, trial};
                        [trial_bins, ~] = hist(bin_tags, Cb_hist_indexes);
                        all_trial_bins(trial,:) = trial_bins;
                        bins = bins + trial_bins;
                        trial_raster_x = (bin_tags*1000/param.M1_Fs)-4000;
                        trial_raster_y = ones(size(trial_raster_x)) * trial;
                        raster_x = [raster_x trial_raster_x]; %#ok<AGROW>
                        raster_y = [raster_y trial_raster_y]; %#ok<AGROW>
                    end
                    if isempty(all_trial_bins)
                        std_err = zeros(1,size(all_trial_bins,2));
                    else
                        std_err = std(all_trial_bins);%/sqrt(trials);
                    end
                    if trials==0
                        ave_hz = zeros(size(bins));
                    else
                        ave_hz = (bins/trials)*(1000/bin_size);
                    end
                    
                    Cb_day_bins(chan,code,:) = Cb_day_bins(chan,code,:) + shiftdim(bins,-1);
                    
                    hist_figure = figure;
                    subplot(4,3,1:9)
                    spike_hist = bar(hist_indexes,ave_hz,'FaceColor',[0.8 0.9 0.7]);
                    
%                     clear peth2
%                     peth2.fit = barsP(ave_hz,[0 8]/Fs,trials,bp);
%                     s_ave_hz = peth2.fit.mean';
                    clear ss_fit
                    ss_fit = fit(hist_indexes', ave_hz', 'smoothingspline', 'SmoothingParam', param.smoothing_param);
                    s_ave_hz = ss_fit(hist_indexes(1):hist_indexes(end))';
                    
                    %Determine if multiphasic
                    [a_corr, lags] = xcorr(s_ave_hz);
                    base_mean = mean(a_corr((lags >= 100) & (lags <= multiphasic_time_window(1))));
                    base_sdv = std(a_corr((lags >= 100) & (lags <= multiphasic_time_window(1))));
                    intrest_mean = mean(a_corr((lags >= multiphasic_time_window(1)) & (lags <= multiphasic_time_window(2))));
                    param.Cb_multiphasic_neurons{day}(chan,code) =  intrest_mean > (base_mean + (multiphasic_sdv_threshold * base_sdv));
                    
                    smooth_rate_line = line(hist_indexes(1):hist_indexes(end),s_ave_hz,'Color',[0 .8 0]);
                    if exist('Cb_spike_waves','var') && ~strcmp(animal,'I060')
                        wave_idx = find(~cellfun(@isempty,Cb_spike_waves(chan:(chan+param.Cb_shant_site_num-1), code)));
                        wave_win_len = size(Cb_spike_waves{(chan+wave_idx-1), code},1);
                        wave_win1_end = wave_win_len-7;
                    end
                    
                    xlabel('Time (ms)');
                    ylabel('Spike Rate (hz)');
                    subplot(4,3,10)
                    if exist('Cb_spike_waves','var') && ~strcmp(animal,'I060')
                        num_waves = min(size(Cb_spike_waves{(chan+wave_idx-1), code},2),wave_plot_num);
                        hold on
                        if ~isfield(param,'Cb_neuron_chans')
                            plot((-6:((wave_win_len)-7))/((param.Cb_spike_wave_Fs)/1000),[Cb_spike_waves{(chan+wave_idx-1), code}(:,1:num_waves)]*1000,'Color',[.7 .7 .7])
                            plot((-6:((wave_win_len)-7))/((param.Cb_spike_wave_Fs)/1000),[mean(Cb_spike_waves{(chan+wave_idx-1), code}(:,1:num_waves),2)]*1000,'Color',[0.9 0.1 0.1],'LineWidth',2.0)
                        elseif ~isnan(param.Cb_neuron_chans{day}(chan,code))
                            subplot(4,3,10)
                            plot((-6:(wave_win_len-7))/((param.Cb_spike_wave_Fs)/1000),[Cb_spike_waves{(chan+param.Cb_neuron_chans{day}(chan,code)), code}(:,1:num_waves)]*1000,'Color',[.7 .7 .7])
                            plot((-6:((wave_win_len)-7))/((param.Cb_spike_wave_Fs)/1000),[mean(Cb_spike_waves{(chan+param.Cb_neuron_chans{day}(chan,code)), code}(:,1:num_waves),2)]*1000,'Color',[0.9 0.1 0.1],'LineWidth',2.0)
                        else
                            error('I think something weird happened.')
                        end
                    end
                    xlabel('Time (ms)'); %We'll need to change this to a scale bar rather than the x-axis
                    ylabel('Voltage (mV)');
                    if save_figs
                        saveas(hist_figure,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_Figures/Cb_spiking_histogram_channel', num2str(chan), '_cell', num2str(code), '.tiff']);
                        saveas(hist_figure,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_Figures/Cb_spiking_histogram_channel', num2str(chan), '_cell', num2str(code), '.fig']);
                    end
                    close all
                    
                    spike_raster = figure;
                    plot([raster_x; raster_x],[0; 1]+raster_y,'LineWidth',1,'Color',rgb('Green')); %spike_raster = scatter(raster_x,raster_y,'g.');
                    xlabel('Time (ms)');
                    ylabel('Spike Occurences (by trial)')
                    if save_figs
                        saveas(spike_raster,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_Figures/Cb_spiking_raster_channel', num2str(chan), '_cell', num2str(code), '.tiff']);
                        saveas(spike_raster,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_Figures/Cb_spiking_raster_channel', num2str(chan), '_cell', num2str(code), '.fig']);
                    end
                    close all
                    
%                     peth2.fit = barsP(std_err,[0 8]/Fs,trials,bp);
%                     s_std_err = [s_ave_hz + peth2.fit.mean'; s_ave_hz - peth2.fit.mean'];
                    clear ss_fit
                    ss_fit = fit(hist_indexes', std_err', 'smoothingspline', 'SmoothingParam', param.smoothing_param);
                    s_std_err = [(s_ave_hz + ss_fit(hist_indexes(1):hist_indexes(end))'); (s_ave_hz - ss_fit(hist_indexes(1):hist_indexes(end))')];
                    
                    shadedErrorBar(hist_indexes(1):hist_indexes(end), s_ave_hz, s_std_err,'g-');
                    temp = gcf;
                    axis([-1000 1500 0 temp.CurrentAxes.YLim(2)]);
                    xlabel('Time (ms)');
                    ylabel('Spike Rate (hz)');
                    if save_figs
                        saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_Figures/Cb_firing_rate_channel', num2str(chan), '_cell', num2str(code), '.fig']);
                    end
                    close all
                    
                    all_Cb_neuron_ave_hz(neuron_num,:) = ave_hz;
                    all_Cb_neuron_trial_bins(neuron_num,:,:) = all_trial_bins';
                    neuron_num = neuron_num + 1;
                end
            end
            all_Cb_neuron_hist = (all_Cb_neuron_ave_hz*trials)*(bin_size/1000);
            
            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/neuron_firing_rates.mat'], 'all_M1_neuron_ave_hz', 'all_Cb_neuron_ave_hz', 'all_M1_neuron_hist', 'all_Cb_neuron_hist'); %, 'all_M1_neuron_trial_bins', 'all_Cb_neuron_trial_bins');
        end
        
        baselines = mean(M1_day_bins(:, :, hist_indexes >= baseline_range(1) & hist_indexes < baseline_range(2)), 3);
        std_dev = std(M1_day_bins(:, :, hist_indexes >= baseline_range(1) & hist_indexes < baseline_range(2)), 0, 3);
        region_of_interest = M1_day_bins(:, :, hist_indexes >= roi_boundaries(1) & hist_indexes < roi_boundaries(2));
        steps = 0:step_size:(size(region_of_interest,3) - win_size);
        window_means = zeros(size(M1_day_bins,1),size(M1_day_bins,2),length(steps));
        for i = 1:length(steps)
            window_means(:,:,i) = mean(region_of_interest(:,:,1+steps(i):win_size+steps(i)),3);
        end
        high_mod = window_means > (baselines + (std_dev * task_related_sdv_threshold));
        low_mod = window_means < (baselines - (std_dev * task_related_sdv_threshold));
        M1_task_rel = logical(sum(cat(3, high_mod, low_mod), 3));
        
        baselines = mean(Cb_day_bins(:, :, hist_indexes >= baseline_range(1) & hist_indexes < baseline_range(2)), 3);
        std_dev = std(Cb_day_bins(:, :, hist_indexes >= baseline_range(1) & hist_indexes < baseline_range(2)), 0, 3);
        region_of_interest = Cb_day_bins(:, :, hist_indexes >= roi_boundaries(1) & hist_indexes < roi_boundaries(2));
        steps = 0:step_size:(size(region_of_interest,3) - win_size);
        window_means = zeros(size(Cb_day_bins,1),size(Cb_day_bins,2),length(steps));
        for i = 1:length(steps)
            window_means(:,:,i) = mean(region_of_interest(:,:,1+steps(i):win_size+steps(i)),3);
        end
        high_mod = window_means > (baselines + (std_dev * task_related_sdv_threshold));
        low_mod = window_means < (baselines - (std_dev * task_related_sdv_threshold));
        Cb_task_rel = logical(sum(cat(3, high_mod, low_mod), 3));
        
        param.M1_task_related_neurons{day} = M1_task_rel;
        param.Cb_task_related_neurons{day} = Cb_task_rel;
        
        save([rootpath,animal,'/Parameters.mat'],'param');
        
    end
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
    rmpath(genpath('Z:\Matlab for analysis'))
end

%% Create Single-Trial Spike Histograms and Rasters (32)
if enabled(32)
    disp('Block 32...')
    day = 5;
    block = 1;
    true_trial_num = 20;
    
    bin_size = 1; %In miliseconds
    hist_indexes = (-4000+(bin_size/2)):bin_size:(4000-(bin_size/2));
    
    load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/spiketrain_snapshots_full.mat']);
    load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/inter_event_intervals.mat']);
    load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_timestamps.mat']);
    load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
    
    outcomes = cellfun(@str2num,data(:,3));
    trial = true_trial_num - sum(outcomes(1:true_trial_num)>1);
    bin_centers = (-4000+(bin_size/2)):bin_size:(4000-(bin_size/2));
    
    M1_trial_spikes = M1_spike_snapshots_full(:,:,trial);
    Cb_trial_spikes = Cb_spike_snapshots_full(:,:,trial);
    
    neuron_bin_cell = cellfun(@(x)(histcounts(x,0:(param.M1_Fs*bin_size)/1000:param.M1_Fs*8)),M1_trial_spikes,'UniformOutput',false);
    neuron_bin_mat = cell2mat(neuron_bin_cell(:));
    trial_bins = sum(neuron_bin_mat,1);
    %smooth trial_bins
    clear ss_fit
    ss_fit = fit(hist_indexes', trial_bins', 'smoothingspline', 'SmoothingParam', param.smoothing_param);
    trial_bins = ss_fit(hist_indexes)';
    %divide trial_bins by number of active neurons to get ave spikes per neuron
    neuron_spike_counts = sum(neuron_bin_mat,2);
    neuron_bin_mat(neuron_spike_counts == 0,:) = [];
    %multiply trial_bins by 1000/bin_size to get ave hz
    trial_bins = trial_bins*((1000/bin_size)/size(neuron_bin_mat,1));
    
    raster_y = neuron_bin_mat .* (1:size(neuron_bin_mat,1))';
    raster_x = neuron_bin_mat .* (bin_centers);
    raster_x(raster_y == 0) = [];
    raster_y(raster_y == 0) = [];
    
    hold on
    peth_figure = line(bin_centers,trial_bins,'Color',[1 0 0]);
    line([0 0], [-1 max(trial_bins)], 'Color', 'green', 'LineStyle', '--')
    line([(reach_touch_interval(true_trial_num)*param.M1_Fs) (reach_touch_interval(true_trial_num)*param.M1_Fs)], [-1 max(trial_bins)], 'Color', 'blue', 'LineStyle', '--')
    line([(reach_retract_interval(true_trial_num)*param.M1_Fs) (reach_retract_interval(true_trial_num)*param.M1_Fs)], [-1 max(trial_bins)], 'Color', 'black', 'LineStyle', '--')
    axis([-500 1000 -1 max(trial_bins)])
    hold off
    saveas(peth_figure, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_Figures/M1_peth_trial', num2str(true_trial_num), '.fig']);
    close all;
    
    hold on
    raster_figure = plot(raster_x(:),[0 1]+raster_y(:),'LineWidth',2,'Color',rgb('Red')); %raster_figure = scatter(raster_x(:), raster_y(:),'r.');
    line([0 0], [0 size(neuron_bin_mat,2)], 'Color', 'green', 'LineStyle', '--')
    line([(reach_touch_interval(true_trial_num)*param.M1_Fs) (reach_touch_interval(true_trial_num)*param.M1_Fs)], [0 size(neuron_bin_mat,2)], 'Color', 'blue', 'LineStyle', '--')
    line([(reach_retract_interval(true_trial_num)*param.M1_Fs) (reach_retract_interval(true_trial_num)*param.M1_Fs)], [0 size(neuron_bin_mat,2)], 'Color', 'black', 'LineStyle', '--')
    axis([-500 1000 0 (size(neuron_bin_mat,1)+1)])
    hold off
    saveas(raster_figure, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_Figures/M1_raster_trial', num2str(true_trial_num), '.fig']);
    close all;
    
    neuron_bin_cell = cellfun(@(x)(histcounts(x,0:(param.Cb_Fs*bin_size)/1000:param.Cb_Fs*8)),Cb_trial_spikes,'UniformOutput',false);
    neuron_bin_mat = cell2mat(neuron_bin_cell(:));
    trial_bins = sum(neuron_bin_mat,1);
    %smooth trial_bins
    clear ss_fit
    ss_fit = fit(hist_indexes', trial_bins', 'smoothingspline', 'SmoothingParam', param.smoothing_param);
    trial_bins = ss_fit(hist_indexes)';
    %divide trial_bins by number of channels to get ave spikes per channel
    %multiply trial_bins by 1000/bin_size to get ave hz
    trial_bins = trial_bins*((1000/bin_size)/size(neuron_bin_mat,1));
    
    neuron_spike_counts = sum(neuron_bin_mat,2);
    neuron_bin_mat(neuron_spike_counts == 0,:) = [];
    raster_y = neuron_bin_mat .* (1:size(neuron_bin_mat,1))';
    raster_x = neuron_bin_mat .* (bin_centers);
    raster_x(raster_y == 0) = [];
    raster_y(raster_y == 0) = [];
    
    hold on
    peth_figure = line(bin_centers,trial_bins,'Color',[0 1 0]);
    line([0 0], [-1 max(trial_bins)], 'Color', 'green', 'LineStyle', '--')
    line([(reach_touch_interval(true_trial_num)*param.Cb_Fs) (reach_touch_interval(true_trial_num)*param.Cb_Fs)], [-1 max(trial_bins)], 'Color', 'blue', 'LineStyle', '--')
    line([(reach_retract_interval(true_trial_num)*param.Cb_Fs) (reach_retract_interval(true_trial_num)*param.Cb_Fs)], [-1 max(trial_bins)], 'Color', 'black', 'LineStyle', '--')
    axis([-500 1000 -1 max(trial_bins)])
    hold off
    saveas(peth_figure, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_Figures/Cb_peth_trial', num2str(true_trial_num), '.fig']);
    close all;
    
    hold on
    raster_figure = plot(raster_x(:),[0 1]+raster_y(:),'LineWidth',2,'Color',rgb('Green')); %raster_figure = scatter(raster_x(:), raster_y(:),'g.');
    line([0 0], [0 size(neuron_bin_mat,2)], 'Color', 'green', 'LineStyle', '--')
    line([(reach_touch_interval(true_trial_num)*param.Cb_Fs) (reach_touch_interval(true_trial_num)*param.Cb_Fs)], [0 size(neuron_bin_mat,2)], 'Color', 'blue', 'LineStyle', '--')
    line([(reach_retract_interval(true_trial_num)*param.Cb_Fs) (reach_retract_interval(true_trial_num)*param.Cb_Fs)], [0 size(neuron_bin_mat,2)], 'Color', 'black', 'LineStyle', '--')
    axis([-500 1000 0 (size(neuron_bin_mat,1)+1)])
    hold off
    saveas(raster_figure, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_Figures/Cb_raster_trial', num2str(true_trial_num), '.fig']);
    close all;
    
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Create Neuron Spike-rate Changes Sorted by Peak Timing (33)

if enabled(33)
    disp('Block 33...')
    addpath(genpath('Z:\Matlab for analysis\BARS'))
    bin_size = 25; %In miliseconds
    hist_indexes = (-4000+(bin_size/2)):bin_size:(4000-(bin_size/2));
    zs_subset = logical(hist_indexes);%logical(hist_indexes <= -2000);
    hm_subset = logical((hist_indexes <= 1500).*(hist_indexes >= -1000));
    win_indexes = hist_indexes(logical((hist_indexes <= 1500).*(hist_indexes >= -1000)));
    
    bp = barsdefaultParams;
    bp.prior_id = 'POISSON';
    bp.dparams = 4;
    bp.use_logspline = 0;
    
    for day=1:param.days
        M1_day_hist = [];
        trials = 0;
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/neuron_firing_rates.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/spiketrain_snapshots_full.mat']);
            
            trials = trials + size(M1_spike_snapshots_full,3);
            
            if isempty(M1_day_hist)
                M1_day_hist = all_M1_neuron_hist;
                Cb_day_hist = all_Cb_neuron_hist;
            else
                if ~isempty(all_M1_neuron_hist)
                    M1_day_hist = M1_day_hist + all_M1_neuron_hist;
                end
                if ~isempty(all_Cb_neuron_hist)
                    Cb_day_hist = Cb_day_hist + all_Cb_neuron_hist;
                end
            end
        end
        
        M1_day_hist(~sum(M1_day_hist,2),:) = []; %#ok<SAGROW>
        neuron_num = size(M1_day_hist,1);
        M1_day_hist_smooth = zeros(size(M1_day_hist));
        for i = 1:neuron_num
%             peth2.fit = barsP(M1_day_hist(i,:),[0 8]/1017.3,trials,bp);
%             M1_day_hist_smooth(i,:) = peth2.fit.mean;
            ss_fit = fit((1:length(M1_day_hist(i,:)))', M1_day_hist(i,:)', 'smoothingspline', 'SmoothingParam', param.smoothing_param);
            M1_day_hist_smooth(i,:) = ss_fit(1:length(M1_day_hist(i,:)))';
        end
        
        data_mean = mean(M1_day_hist_smooth(:,zs_subset),2);
        data_std = std(M1_day_hist_smooth(:,zs_subset),[],2);
        M1_zs_data = (M1_day_hist_smooth - data_mean)./data_std;
        M1_zs_data = M1_zs_data(:,hm_subset);
        
        M1_inc_max = max(M1_zs_data,[],2);
        M1_dec_min = min(M1_zs_data,[],2);
        max_wins = (M1_inc_max) > abs(M1_dec_min);
        
        inc_M1_day_hist_smooth = M1_zs_data(max_wins,:);
        dec_M1_day_hist_smooth = M1_zs_data(~max_wins,:);
        M1_inc_max = M1_inc_max(max_wins);
        M1_dec_min = M1_dec_min(~max_wins);

        num_inc = length(M1_inc_max);
        num_dec = length(M1_dec_min);
        M1_inc_times = zeros(1,num_inc);
        M1_dec_times = zeros(1,num_dec);
        for i = 1:num_inc
            M1_inc_times(i) = find(inc_M1_day_hist_smooth(i,:) == M1_inc_max(i),1);
        end
        for i = 1:num_dec
            M1_dec_times(i) = find(dec_M1_day_hist_smooth(i,:) == M1_dec_min(i),1);
        end
        
        [M1_inc_times, M1_inc_sort_idx] = sort(M1_inc_times);
        M1_inc_max = M1_inc_max(M1_inc_sort_idx);
        inc_M1_day_hist_smooth = inc_M1_day_hist_smooth(M1_inc_sort_idx,:);
        [M1_dec_times, M1_dec_sort_idx] = sort(M1_dec_times);
        M1_dec_min = M1_dec_min(M1_dec_sort_idx);
        dec_M1_day_hist_smooth = dec_M1_day_hist_smooth(M1_dec_sort_idx,:);
        
        Cb_day_hist(~sum(Cb_day_hist,2),:) = [];
        neuron_num = size(Cb_day_hist,1);
        Cb_day_hist_smooth = zeros(size(Cb_day_hist));
        for i = 1:neuron_num
            Cb_day_hist_smooth(i,:) = smooth(Cb_day_hist(i,:),8);
        end
        
        data_mean = mean(Cb_day_hist_smooth(:,zs_subset),2);
        data_std = std(Cb_day_hist_smooth(:,zs_subset),[],2);
        Cb_zs_data = (Cb_day_hist_smooth - data_mean)./data_std;
        Cb_zs_data = Cb_zs_data(:,hm_subset);
        
        Cb_inc_max = max(Cb_zs_data,[],2);
        Cb_dec_min = min(Cb_zs_data,[],2);
        max_wins = (Cb_inc_max) > abs(Cb_dec_min);
        
        inc_Cb_day_hist_smooth = Cb_zs_data(max_wins,:);
        dec_Cb_day_hist_smooth = Cb_zs_data(~max_wins,:);
        Cb_inc_max = Cb_inc_max(max_wins);
        Cb_dec_min = Cb_dec_min(~max_wins);
        
        num_inc = length(Cb_inc_max);
        num_dec = length(Cb_dec_min);
        Cb_inc_times = zeros(1,num_inc);
        Cb_dec_times = zeros(1,num_dec);
        for i = 1:num_inc
            Cb_inc_times(i) = find(inc_Cb_day_hist_smooth(i,:) == Cb_inc_max(i),1);
        end
        for i = 1:num_dec
            Cb_dec_times(i) = find(dec_Cb_day_hist_smooth(i,:) == Cb_dec_min(i),1);
        end
        
        [Cb_inc_times, Cb_inc_sort_idx] = sort(Cb_inc_times);
        Cb_inc_max = Cb_inc_max(Cb_inc_sort_idx);
        inc_Cb_day_hist_smooth = inc_Cb_day_hist_smooth(Cb_inc_sort_idx,:);
        [Cb_dec_times, Cb_dec_sort_idx] = sort(Cb_dec_times);
        Cb_dec_min = Cb_dec_min(Cb_dec_sort_idx);
        dec_Cb_day_hist_smooth = dec_Cb_day_hist_smooth(Cb_dec_sort_idx,:);
        
        save([rootpath,animal,'/Day',num2str(day),'/sorted_firing_rates.mat'], 'inc_M1_day_hist_smooth', 'dec_M1_day_hist_smooth', 'M1_inc_sort_idx', 'M1_dec_sort_idx', 'inc_Cb_day_hist_smooth', 'dec_Cb_day_hist_smooth', 'Cb_inc_sort_idx', 'Cb_dec_sort_idx');
        
    end
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
    rmpath(genpath('Z:\Matlab for analysis\BARS'))
end

%% Create Sorted z-Scored Firing-Rate Heatmap (34)

if enabled(34)
    disp('Block 34...')
    map_data = cell(1,4); %Dim1: [M1 increase neurons, M1 decrease neurons, Cb increase neurons, Cb decrease neurons]
    id_strings = ['/M1_increasing'; '/M1_decreasing'; '/Cb_increasing'; '/Cb_decreasing'];
    bin_size = 25; %In miliseconds
    hist_indexes = (-4000+(bin_size/2)):bin_size:(4000-(bin_size/2));
    win_indexes = hist_indexes(logical((hist_indexes <= 1500).*(hist_indexes >= -1000)));
    for day=1:param.days
        load([rootpath,animal,'/Day',num2str(day),'/sorted_firing_rates.mat']);
        
        map_data{1} = inc_M1_day_hist_smooth;
        map_data{2} = dec_M1_day_hist_smooth;
        map_data{3} = inc_Cb_day_hist_smooth;
        map_data{4} = dec_Cb_day_hist_smooth;
        
        for i=1:4
            if isempty(map_data{i})
                figure
                title('No Data')
                saveas(gcf, [rootpath,animal,'/Day',num2str(day),id_strings(i,:),'_firing_rate.fig']);
                close all;
            elseif size(map_data{i},1) == 1
                figure
                title('Single Data')
                saveas(gcf, [rootpath,animal,'/Day',num2str(day),id_strings(i,:),'_firing_rate.fig']);
                close all;
            else
                figure
                pcolor(win_indexes,size(map_data{i},1):-1:1,map_data{i})
                shading flat
                caxis([-2 5])
                colorbar
                saveas(gcf, [rootpath,animal,'/Day',num2str(day),id_strings(i,:),'_firing_rate.fig']);
                close all;
            end
        end
    end
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Calculate Spike/LFP Coherence Data (35)

if enabled(35)
    disp('Block 35...')
    addpath(genpath('Z:/Matlab for analysis/chronux_2_10/chronux/spectral_analysis'))
    addpath(genpath('Z:/Matlab for analysis/eeglab/functions'))
    M1_channels_of_interest = [2];  %  I060: 12 I076: 15 I061: 29 I064: 28 I086: 9  I089: 2, 26
    Cb_channels_of_interest = [7]; %  I060: 8  I076: 23 I061: 20 I064: 17 I086: 57 I089: 7
    if isempty(M1_channels_of_interest)
        M1_channels_of_interest = 1:param.M1_chans;
    end
    if isempty(Cb_channels_of_interest)
        Cb_channels_of_interest = 1:param.Cb_chans;
    end
    M1_channels_of_interest = find(ismember(param.M1_good_chans, M1_channels_of_interest));
    Cb_channels_of_interest = find(ismember(param.Cb_good_chans, Cb_channels_of_interest));
    
    M1_neurons_of_interest = {[],...
                              [],...
                              [],...
                              [],...
                              []};
    Cb_neurons_of_interest = {[],... 
                              [],...
                              [],...
                              [],...
                              []};
    if isempty([M1_neurons_of_interest{:} Cb_neurons_of_interest{:}])
        M1_neurons_of_interest = {1:(param.M1_chans*param.M1_neurons), 1:(param.M1_chans*param.M1_neurons), 1:(param.M1_chans*param.M1_neurons), 1:(param.M1_chans*param.M1_neurons), 1:(param.M1_chans*param.M1_neurons)};
        Cb_neurons_of_interest = {1:(param.Cb_chans*param.Cb_neurons), 1:(param.Cb_chans*param.Cb_neurons), 1:(param.Cb_chans*param.Cb_neurons), 1:(param.Cb_chans*param.Cb_neurons), 1:(param.Cb_chans*param.Cb_neurons)};
    end
    
    coh_params.Fs = param.M1_Fs;
    coh_params.fpass = [0 20];
    coh_params.tapers = [3 5];
    coh_params.trialave = 0;
    coh_params.pad = 1;
    coh_params.err = [2 0.05];
    
    min_spikes = 20;
    kern_stdv = 25; %100
    if kern_stdv == 0
        M1_kernel = [1];
        Cb_kernel = [1];
    else
        M1_kernel = gausswin(round(16*param.M1_Fs),round(16*param.M1_Fs)/kern_stdv);
        Cb_kernel = gausswin(round(16*param.Cb_Fs),round(16*param.Cb_Fs)/kern_stdv);
    end
    
    for day=1:param.days
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Normalized_Snapshots', '.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/spiketrain_snapshots_full.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            
            trial_codes = str2double(data(:,3));
            no_reach_trials = (1:size(data,1));
            no_reach_trials = no_reach_trials(trial_codes>1);
            
            all_bad_trials = union(M1_bad_trials, Cb_bad_trials);
            [M1_snapshots, Cb_snapshots] = get_common_good_data(M1_snapshots, Cb_snapshots, M1_bad_trials, Cb_bad_trials, 3);
            [M1_spike_snapshots, ~] = get_common_good_data(M1_spike_snapshots_full, M1_snapshots, no_reach_trials, all_bad_trials, 3);
            [Cb_spike_snapshots, ~] = get_common_good_data(Cb_spike_snapshots_full, Cb_snapshots, no_reach_trials, all_bad_trials, 3);
            
            if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt'],'dir')
                mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt']);
            end
            
            for lfp_chan_num = M1_channels_of_interest
                lfp_chan = find(param.M1_good_chans==lfp_chan_num);
                if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/M1_Channel',num2str(param.M1_good_chans(lfp_chan))],'dir')
                    mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/M1_Channel',num2str(param.M1_good_chans(lfp_chan))]);
                end
                neuron_idx = 0;
                for s_chan = 1:param.M1_chans
                    for code = 1:param.M1_neurons
                        neuron_idx = neuron_idx + 1;
                        if ismember(neuron_idx,M1_neurons_of_interest{day})
                            if ((length([M1_spike_snapshots{s_chan,code,:}]) / size(M1_spike_snapshots,3)) >= min_spikes) && (param.M1_good_chans(lfp_chan) ~= s_chan)
                                
%                                 %Ver 1 (chronux with binned spikes)
%                                 LFP_snapshots = squeeze(M1_snapshots(lfp_chan,:,:));
%                                 M1_spike_bins = zeros(8139,size(M1_spike_snapshots,3));
%                                 for trial = 1:size(M1_spike_snapshots,3)
%                                     [bins, bin_limits] = binspikes([M1_spike_snapshots{s_chan,code,trial}]/param.M1_Fs,param.M1_Fs,[0 8]);
%                                     if sum(bins) >= min_spikes
%                                         M1_spike_bins(:,trial) = conv(bins,M1_kernel,'same');
%                                     end
%                                 end
%                                 LFP_snapshots(:,sum(M1_spike_bins,1) == 0) = [];
%                                 M1_spike_bins(:,sum(M1_spike_bins,1) == 0) = [];
%                                 [coh,phi_cmr,~,~,~,coh_times,coh_freqs,~,~,~,~] = cohgramcpb(LFP_snapshots, M1_spike_bins, [1 .025], coh_params);
%                                 coh = permute(coh,[2,1,3]);
%                                 
%                                 %Ver 2 (Chronux with spike times)
%                                 M1_struct_spikes = struct();
%                                 for trial = 1:size(M1_spike_snapshots,3)
%                                     M1_struct_spikes(trial).snapshot = [M1_spike_snapshots{s_chan,code,trial}]/Fs;
%                                 end
%                                 [coh,phi_cmr,~,~,~,coh_times,coh_freqs,~,~,~,~] = cohgramcpt(squeeze(M1_snapshots(lfp_chan,:,:)),M1_struct_spikes,[1 .025],params,1);
                                
                                %Ver 3 (eeglab: trials concatenated (I think))
                                LFP_snapshots = squeeze(M1_snapshots(lfp_chan,:,:));
                                M1_spike_bins = zeros(8139,size(M1_spike_snapshots,3));
                                for trial = 1:size(M1_spike_snapshots,3)
                                    [bins, bin_limits] = binspikes([M1_spike_snapshots{s_chan,code,trial}]/param.M1_Fs,param.M1_Fs,[0 8]);
                                    if sum(bins) >= min_spikes
                                        M1_spike_bins(:,trial) = conv(bins,M1_kernel,'same');
                                    end
                                end
                                LFP_snapshots(:,sum(M1_spike_bins,1) == 0) = [];
                                M1_spike_bins(:,sum(M1_spike_bins,1) == 0) = [];
                                LFP_snapshots_flat = LFP_snapshots(:);
                                spike_bins_flat = M1_spike_bins(:);
                                %TODO what is the equivilent of phi_cmr for newcrossf
                                [cross_trial_coh,~,coh_times,coh_freqs,~,~,cross_spec,x_pspec,y_pspec] = newcrossf(LFP_snapshots_flat, spike_bins_flat, size(M1_snapshots,2),[-4000 4000],param.M1_Fs,[0.01 0.1],'type','coher','freqs', [0 60]);
                                %coh = abs(cross_spec ./ sqrt((x_pspec .* conj(x_pspec)).*(y_pspec .* conj(y_pspec)))); %cross_spec may still be complex; abs() if nessisary                                     %
                                coh = cross_trial_coh;
                                phi_cmr = [];
                                
%                                 %Ver 4 (eeglab trial-by-trial (I think))
%                                 LFP_snapshots = squeeze(M1_snapshots(lfp_chan,:,:));
%                                 coh = nan(120,200,size(M1_spike_snapshots,3));
%                                 for trial = 1:size(M1_spike_snapshots,3)
%                                     [bins, bin_limits] = binspikes([M1_spike_snapshots{s_chan,code,trial}]/Fs,Fs,[0 8]);
%                                     if sum(bins) >= min_spikes
%                                         [coh(:,:,trial),~,coh_times,coh_freqs,~,~,cross_spec,x_pspec,y_pspec] = newcrossf(LFP_snapshots(:,trial),conv(bins,kernel,'same'), size(M1_snapshots,2),[-4000 4000],Fs,[0.01 0.1],'type','coher','freqs', [0 60]);
%                                     end
%                                 end
%                                 coh(:,:,isnan(coh(1,1,:))) = [];
                                
                                close all
                                coh_times = -4000:(8000/(length(coh_times)-1)):4000;
                                save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/M1_Channel',num2str(param.M1_good_chans(lfp_chan)),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data', '.mat'], 'coh', 'coh_times', 'coh_freqs')
                            end
                        end
                    end
                end
                
                neuron_idx = 0;
                for s_chan = 1:param.Cb_chans
                    for code = 1:param.Cb_neurons
                        neuron_idx = neuron_idx + 1;
                        if ismember(neuron_idx,Cb_neurons_of_interest{day})
                            if (length([Cb_spike_snapshots{s_chan,code,:}]) / size(Cb_spike_snapshots,3)) >= min_spikes
                                
%                                 %Ver 1
%                                 LFP_snapshots = squeeze(M1_snapshots(lfp_chan,:,:));
%                                 Cb_spike_bins = zeros(8139,size(Cb_spike_snapshots,3));
%                                 for trial = 1:size(Cb_spike_snapshots,3)
%                                     [bins, bin_limits] = binspikes([Cb_spike_snapshots{s_chan,code,trial}]/param.Cb_Fs,param.Cb_Fs,[0 8]);
%                                     if sum(bins) >= min_spikes
%                                         Cb_spike_bins(:,trial) = conv(bins,Cb_kernel,'same');
%                                     end
%                                 end
%                                 LFP_snapshots(:,sum(Cb_spike_bins,1) == 0) = [];
%                                 Cb_spike_bins(:,sum(Cb_spike_bins,1) == 0) = [];
%                                 [coh,phi_cmr,~,~,~,coh_times,coh_freqs,~,~,~,~] = cohgramcpb(LFP_snapshots, Cb_spike_bins, [1 .025], coh_params);
%                                 coh = permute(coh,[2,1,3]);
%                                 
%                                 %Ver 2
%                                 Cb_struct_spikes = struct();
%                                 for trial = 1:size(Cb_spike_snapshots,3)
%                                     Cb_struct_spikes(trial).snapshot = [Cb_spike_snapshots{s_chan,code,trial}]/Fs;
%                                 end
%                                 [coh,phi_cmr,~,~,~,coh_times,coh_freqs,~,~,~,~] = cohgramcpt(squeeze(M1_snapshots(lfp_chan,:,:)),Cb_struct_spikes,[1 .025],params,1);
                                
                                %Ver 3
                                LFP_snapshots = squeeze(M1_snapshots(lfp_chan,:,:));
                                Cb_spike_bins = zeros(8139,size(Cb_spike_snapshots,3));
                                for trial = 1:size(Cb_spike_snapshots,3)
                                    [bins, bin_limits] = binspikes([Cb_spike_snapshots{s_chan,code,trial}]/param.Cb_Fs,param.Cb_Fs,[0 8]);
                                    if sum(bins) >= min_spikes
                                        Cb_spike_bins(:,trial) = conv(bins,Cb_kernel,'same');
                                    end
                                end
                                LFP_snapshots(:,sum(Cb_spike_bins,1) == 0) = [];
                                Cb_spike_bins(:,sum(Cb_spike_bins,1) == 0) = [];
                                LFP_snapshots_flat = LFP_snapshots(:);
                                spike_bins_flat = Cb_spike_bins(:);
                                %TODO what is the equivilent of phi_cmr for newcrossf
                                [cross_trial_coh,~,coh_times,coh_freqs,~,~,cross_spec,x_pspec,y_pspec] = newcrossf(LFP_snapshots_flat, spike_bins_flat, size(M1_snapshots,2),[-4000 4000],param.Cb_Fs,[0.01 0.1],'type','coher','freqs', [0 60]);
                                %coh = abs(cross_spec ./ sqrt((x_pspec .* conj(x_pspec)).*(y_pspec .* conj(y_pspec)))); %cross_spec may still be complex; abs() if nessisary                                     %
                                coh = cross_trial_coh;
                                phi_cmr = [];
                                
%                                 %Ver 4
%                                 LFP_snapshots = squeeze(M1_snapshots(lfp_chan,:,:));
%                                 coh = nan(120,200,size(Cb_spike_snapshots,3));
%                                 for trial = 1:size(Cb_spike_snapshots,3)
%                                     [bins, bin_limits] = binspikes([Cb_spike_snapshots{s_chan,code,trial}]/Fs,Fs,[0 8]);
%                                     if sum(bins) >= min_spikes
%                                         [coh(:,:,trial),~,coh_times,coh_freqs,~,~,cross_spec,x_pspec,y_pspec] = newcrossf(LFP_snapshots(:,trial),conv(bins,kernel,'same'), size(M1_snapshots,2),[-4000 4000],Fs,[0.01 0.1],'type','coher','freqs', [0 60]);
%                                     end
%                                 end
%                                 coh(:,:,isnan(coh(1,1,:))) = [];
                                
                                close all
                                coh_times = -4000:(8000/(length(coh_times)-1)):4000;
                                save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/M1_Channel',num2str(param.M1_good_chans(lfp_chan)),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data', '.mat'], 'coh', 'coh_times', 'coh_freqs')
                            end
                        end
                    end
                end
            end
            
            for lfp_chan_num = Cb_channels_of_interest
                lfp_chan = find(param.Cb_good_chans==lfp_chan_num);
                
                if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan))],'dir')
                    mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan))]);
                end
                neuron_idx = 0;
                for s_chan = 1:param.M1_chans
                    for code = 1:param.M1_neurons
                        neuron_idx = neuron_idx + 1;
                        if ismember(neuron_idx,M1_neurons_of_interest{day})
                            if (length([M1_spike_snapshots{s_chan,code,:}]) / size(M1_spike_snapshots,3)) >= min_spikes
                                
%                                 %Ver 1
%                                 LFP_snapshots = squeeze(Cb_snapshots(lfp_chan,:,:));
%                                 M1_spike_bins = zeros(8139,size(M1_spike_snapshots,3));
%                                 for trial = 1:size(M1_spike_snapshots,3)
%                                     [bins, bin_limits] = binspikes([M1_spike_snapshots{s_chan,code,trial}]/param.M1_Fs,param.M1_Fs,[0 8]);
%                                     if sum(bins) >= min_spikes
%                                         M1_spike_bins(:,trial) = conv(bins,M1_kernel,'same');
%                                     end
%                                 end
%                                 LFP_snapshots(:,sum(M1_spike_bins,1) == 0) = [];
%                                 M1_spike_bins(:,sum(M1_spike_bins,1) == 0) = [];
%                                 [coh,phi_cmr,~,~,~,coh_times,coh_freqs,~,~,~,~] = cohgramcpb(LFP_snapshots, M1_spike_bins, [1 .025], coh_params);
%                                 coh = permute(coh,[2,1,3]);
%                                 
%                                 %Ver 2
%                                 M1_struct_spikes = struct();
%                                 for trial = 1:size(M1_spike_snapshots,3)
%                                     M1_struct_spikes(trial).snapshot = [M1_spike_snapshots{s_chan,code,trial}]/Fs;
%                                 end
%                                 [coh,phi_cmr,~,~,~,coh_times,coh_freqs,~,~,~,~] = cohgramcpt(squeeze(Cb_snapshots(lfp_chan,:,:)),M1_struct_spikes,[1 .025],params,1);
                                
                                %Ver 3
                                LFP_snapshots = squeeze(Cb_snapshots(lfp_chan,:,:));
                                M1_spike_bins = zeros(8139,size(M1_spike_snapshots,3));
                                for trial = 1:size(M1_spike_snapshots,3)
                                    [bins, bin_limits] = binspikes([M1_spike_snapshots{s_chan,code,trial}]/param.Cb_Fs,param.Cb_Fs,[0 8]);
                                    if sum(bins) >= min_spikes
                                        M1_spike_bins(:,trial) = conv(bins,M1_kernel,'same');
                                    end
                                end
                                LFP_snapshots(:,sum(M1_spike_bins,1) == 0) = [];
                                M1_spike_bins(:,sum(M1_spike_bins,1) == 0) = [];
                                LFP_snapshots_flat = LFP_snapshots(:);
                                spike_bins_flat = M1_spike_bins(:);
                                %TODO what is the equivilent of phi_cmr for newcrossf
                                [cross_trial_coh,~,coh_times,coh_freqs,~,~,cross_spec,x_pspec,y_pspec] = newcrossf(LFP_snapshots_flat, spike_bins_flat, size(M1_snapshots,2),[-4000 4000],param.M1_Fs,[0.01 0.1],'type','coher','freqs', [0 60]);
                                %coh = abs(cross_spec ./ sqrt((x_pspec .* conj(x_pspec)).*(y_pspec .* conj(y_pspec)))); %cross_spec may still be complex; abs() if nessisary                                     %
                                coh = cross_trial_coh;
                                phi_cmr = [];
                                
%                                 %Ver 4
%                                 LFP_snapshots = squeeze(Cb_snapshots(lfp_chan,:,:));
%                                 coh = nan(120,200,size(M1_spike_snapshots,3));
%                                 for trial = 1:size(M1_spike_snapshots,3)
%                                     [bins, bin_limits] = binspikes([M1_spike_snapshots{s_chan,code,trial}]/Fs,Fs,[0 8]);
%                                     if sum(bins) >= min_spikes
%                                         [coh(:,:,trial),~,coh_times,coh_freqs,~,~,cross_spec,x_pspec,y_pspec] = newcrossf(LFP_snapshots(:,trial),conv(bins,kernel,'same'), size(M1_snapshots,2),[-4000 4000],Fs,[0.01 0.1],'type','coher','freqs', [0 60]);
%                                     end
%                                 end
%                                 coh(:,:,isnan(coh(1,1,:))) = [];
                                
                                close all
                                coh_times = -4000:(8000/(length(coh_times)-1)):4000;
                                save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan)),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data', '.mat'], 'coh', 'coh_times', 'coh_freqs')
                            end
                        end
                    end
                end
                
                neuron_idx = 0;
                for s_chan = 1:param.Cb_chans
                    for code = 1:param.Cb_neurons
                        neuron_idx = neuron_idx + 1;
                        if ismember(neuron_idx,Cb_neurons_of_interest{day})
                            if ((length([Cb_spike_snapshots{s_chan,code,:}]) / size(Cb_spike_snapshots,3)) >= min_spikes) && (param.Cb_good_chans(lfp_chan) ~= (ceil(s_chan/4)*4)-3)
                                
%                                 %Ver 1
%                                 LFP_snapshots = squeeze(Cb_snapshots(lfp_chan,:,:));
%                                 Cb_spike_bins = zeros(8139,size(Cb_spike_snapshots,3));
%                                 for trial = 1:size(Cb_spike_snapshots,3)
%                                     [bins, bin_limits] = binspikes([Cb_spike_snapshots{s_chan,code,trial}]/param.Cb_Fs,param.Cb_Fs,[0 8]);
%                                     if sum(bins) >= min_spikes
%                                         Cb_spike_bins(:,trial) = conv(bins,Cb_kernel,'same');
%                                     end
%                                 end
%                                 LFP_snapshots(:,sum(Cb_spike_bins,1) == 0) = [];
%                                 Cb_spike_bins(:,sum(Cb_spike_bins,1) == 0) = [];
%                                 [coh,phi_cmr,~,~,~,coh_times,coh_freqs,~,~,~,~] = cohgramcpb(LFP_snapshots, Cb_spike_bins, [1 .025], coh_params);
%                                 coh = permute(coh,[2,1,3]);
%                                 
%                                 %Ver 2
%                                 Cb_struct_spikes = struct();
%                                 for trial = 1:size(Cb_spike_snapshots,3)
%                                     Cb_struct_spikes(trial).snapshot = [Cb_spike_snapshots{s_chan,code,trial}]/Fs;
%                                 end
%                                 [coh,phi_cmr,~,~,~,coh_times,coh_freqs,~,~,~,~] = cohgramcpt(squeeze(Cb_snapshots(lfp_chan,:,:)),Cb_struct_spikes,[1 .025],params,1);
                                
                                %Ver 3
                                LFP_snapshots = squeeze(Cb_snapshots(lfp_chan,:,:));
                                Cb_spike_bins = zeros(8139,size(Cb_spike_snapshots,3));
                                for trial = 1:size(Cb_spike_snapshots,3)
                                    [bins, bin_limits] = binspikes([Cb_spike_snapshots{s_chan,code,trial}]/param.Cb_Fs,param.Cb_Fs,[0 8]);
                                    if sum(bins) >= min_spikes
                                        Cb_spike_bins(:,trial) = conv(bins,Cb_kernel,'same');
                                    end
                                end
                                LFP_snapshots(:,sum(Cb_spike_bins,1) == 0) = [];
                                Cb_spike_bins(:,sum(Cb_spike_bins,1) == 0) = [];
                                LFP_snapshots_flat = LFP_snapshots(:);
                                spike_bins_flat = Cb_spike_bins(:);
                                %TODO what is the equivilent of phi_cmr for newcrossf
                                [cross_trial_coh,~,coh_times,coh_freqs,~,~,cross_spec,x_pspec,y_pspec] = newcrossf(LFP_snapshots_flat, spike_bins_flat, size(M1_snapshots,2),[-4000 4000],param.Cb_Fs,[0.01 0.1],'type','coher','freqs', [0 60]);
                                %coh = abs(cross_spec ./ sqrt((x_pspec .* conj(x_pspec)).*(y_pspec .* conj(y_pspec)))); %cross_spec may still be complex; abs() if nessisary                                     %
                                coh = cross_trial_coh;
                                phi_cmr = [];
                                
%                                 %Ver 4
%                                 LFP_snapshots = squeeze(Cb_snapshots(lfp_chan,:,:));
%                                 coh = nan(120,200,size(Cb_spike_snapshots,3));
%                                 for trial = 1:size(Cb_spike_snapshots,3)
%                                     [bins, bin_limits] = binspikes([Cb_spike_snapshots{s_chan,code,trial}]/Fs,Fs,[0 8]);
%                                     if sum(bins) >= min_spikes
%                                         [coh(:,:,trial),~,coh_times,coh_freqs,~,~,cross_spec,x_pspec,y_pspec] = newcrossf(LFP_snapshots(:,trial),conv(bins,kernel,'same'), size(M1_snapshots,2),[-4000 4000],Fs,[0.01 0.1],'type','coher','freqs', [0 60]);
%                                     end
%                                 end
%                                 coh(:,:,isnan(coh(1,1,:))) = [];
                                
                                close all
                                coh_times = -4000:(8000/(length(coh_times)-1)):4000;
                                save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan)),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data', '.mat'], 'coh', 'coh_times', 'coh_freqs')
                            end
                        end
                    end
                end
            end
            
            clearvars -except code_rootpath rootpath origin_rootpath animal param enabled coh_params M1_kernel Cb_kernel min_spikes day block M1_channels_of_interest M1_neurons_of_interest Cb_channels_of_interest Cb_neurons_of_interest;
        end
    end
    clear coh_params kernel min_spikes day block M1_channels_of_interest M1_neurons_of_interest Cb_channels_of_interest Cb_neurons_of_interest;
    rmpath(genpath('Z:/Matlab for analysis/chronux_2_10/chronux/spectral_analysis'))
    rmpath(genpath('Z:/Matlab for analysis/eeglab/functions'))
end

%% Parallel Calculation of Spike/LFP Coherence Data (35.5)

if false 
    if isunix  %#ok<UNRCH>
        addpath(genpath('/common/fleischerp/HPC_code'))
        addpath(genpath('/common/fleischerp/3rd_party_code'))
    else
        addpath(genpath('Z:/Matlab for analysis/chronux_2_10/chronux/spectral_analysis'))
    end
    worker_num = 6;
    max_chans = max(param.M1_chans, param.Cb_chans);
    max_neurons = max(param.M1_neurons, param.Cb_neurons);
    parallel_structs_M1_M1 = repmat(struct('Fs',0,'LFP_snapshot',[],'spike_bins',[],'save_path', ''),[param.days,param.blocks,max_chans,max_chans,max_neurons]);
    parallel_structs_M1_Cb = repmat(struct('Fs',0,'LFP_snapshot',[],'spike_bins',[],'save_path', ''),[param.days,param.blocks,max_chans,max_chans,max_neurons]);
    parallel_structs_Cb_M1 = repmat(struct('Fs',0,'LFP_snapshot',[],'spike_bins',[],'save_path', ''),[param.days,param.blocks,max_chans,max_chans,max_neurons]);
    parallel_structs_Cb_Cb = repmat(struct('Fs',0,'LFP_snapshot',[],'spike_bins',[],'save_path', ''),[param.days,param.blocks,max_chans,max_chans,max_neurons]);
    M1_channels_of_interest = [];
    Cb_channels_of_interest = []; %5,7,8,27
    if isempty([M1_channels_of_interest Cb_channels_of_interest])
        M1_channels_of_interest = 1:param.M1_chans; %22
        Cb_channels_of_interest = 1:param.Cb_chans; %29
    end
    
    M1_neurons_of_interest = {[],...
                              [],...
                              [],...
                              [],...
                              []};
    Cb_neurons_of_interest = {[],... 
                              [],...
                              [],...
                              [],...
                              []};
    if isempty([M1_neurons_of_interest{:} Cb_neurons_of_interest{:}])
        M1_neurons_of_interest = {ones(param.M1_chans, param.M1_neurons), ones(param.M1_chans, param.M1_neurons), ones(param.M1_chans, param.M1_neurons), ones(param.M1_chans, param.M1_neurons), ones(param.M1_chans, param.M1_neurons)};
        Cb_neurons_of_interest = {ones(param.Cb_chans, param.Cb_neurons), ones(param.Cb_chans, param.Cb_neurons), ones(param.Cb_chans, param.Cb_neurons), ones(param.Cb_chans, param.Cb_neurons), ones(param.Cb_chans, param.Cb_neurons)};
    end
    
    min_spikes = 8;
    kern_stdv = 100;
    M1_kernel = gausswin(round(16*param.M1_Fs),round(16*param.M1_Fs)/kern_stdv);
    Cb_kernel = gausswin(round(16*param.Cb_Fs),round(16*param.Cb_Fs)/kern_stdv);
    
    for day=1:param.days
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Normalized_Snapshots.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/spiketrain_snapshots_full.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            
            trial_codes = str2double(data(:,3));
            no_reach_trials = (1:size(data,1));
            no_reach_trials = no_reach_trials(trial_codes>1);
            
            all_bad_trials = union(M1_bad_trials, Cb_bad_trials);
            [M1_snapshots, Cb_snapshots] = get_common_good_data(M1_snapshots, Cb_snapshots, M1_bad_trials, Cb_bad_trials, 3);
            [M1_spike_snapshots, ~] = get_common_good_data(M1_spike_snapshots_full, M1_snapshots, no_reach_trials, all_bad_trials, 3);
            [Cb_spike_snapshots, ~] = get_common_good_data(Cb_spike_snapshots_full, Cb_snapshots, no_reach_trials, all_bad_trials, 3);
            
            if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt'],'dir')
                mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt']);
            end
            
            for M1_lfp_chan = find(ismember(param.M1_good_chans,M1_channels_of_interest))
                if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/M1_Channel',num2str(param.M1_good_chans(M1_lfp_chan))],'dir')
                    mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/M1_Channel',num2str(param.M1_good_chans(M1_lfp_chan))]);
                end
                for M1_neuron_chan = 1:param.M1_chans
                    for M1_neuron_num = 1:param.M1_neurons
                        if ~isempty(M1_lfp_chan) && M1_neurons_of_interest{day}(M1_neuron_chan, M1_neuron_num)
                                    
                            %Ver 1
                            LFP_snapshots = squeeze(M1_snapshots(M1_lfp_chan,:,:));
                            M1_spike_bins = zeros(size(M1_snapshots,2),size(M1_spike_snapshots,3));
                            for trial = 1:size(M1_spike_snapshots,3)
                                [bins, bin_limits] = binspikes([M1_spike_snapshots{M1_neuron_num,M1_neuron_num,trial}]/param.M1_Fs,param.M1_Fs,[0 8]);
                                if sum(bins) >= min_spikes
                                    M1_spike_bins(:,trial) = conv(bins,M1_kernel,'same');
                                end
                            end
                            LFP_snapshots(:,sum(M1_spike_bins,1) == 0) = [];
                            M1_spike_bins(:,sum(M1_spike_bins,1) == 0) = [];
                            if ~isempty(M1_spike_bins)
                                parallel_structs_M1_M1(day,block,M1_lfp_chan,M1_neuron_chan,M1_neuron_num) = struct('Fs',param.M1_Fs,'LFP_snapshot',LFP_snapshots,'spike_bins',M1_spike_bins,'save_path',[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/M1_Channel',num2str(param.M1_good_chans(M1_lfp_chan)),'/M1_Ch',num2str(M1_neuron_chan),'_code',num2str(M1_neuron_num),'_coherence_data.mat']);
                            end
                        end
                    end
                end
                
                for Cb_neuron_chan = 1:param.Cb_chans
                    for Cb_neuron_num = 1:param.Cb_neurons
                        if ~isempty(M1_lfp_chan) && Cb_neurons_of_interest{day}(Cb_neuron_chan, Cb_neuron_num)
                                    
                            %Ver 1
                            LFP_snapshots = squeeze(M1_snapshots(M1_lfp_chan,:,:));
                            Cb_spike_bins = zeros(size(Cb_snapshots,2),size(Cb_spike_snapshots,3));
                            for trial = 1:size(Cb_spike_snapshots,3)
                                [bins, bin_limits] = binspikes([Cb_spike_snapshots{Cb_neuron_chan,Cb_neuron_num,trial}]/param.Cb_Fs,param.Cb_Fs,[0 8]);
                                if sum(bins) >= min_spikes
                                    Cb_spike_bins(:,trial) = conv(bins,Cb_kernel,'same');
                                end
                            end
                            LFP_snapshots(:,sum(Cb_spike_bins,1) == 0) = [];
                            Cb_spike_bins(:,sum(Cb_spike_bins,1) == 0) = [];
                            if ~isempty(Cb_spike_bins)
                                parallel_structs_M1_Cb(day,block,M1_lfp_chan,Cb_neuron_chan,Cb_neuron_num) = struct('Fs',param.M1_Fs,'LFP_snapshot',LFP_snapshots,'spike_bins',Cb_spike_bins,'save_path',[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/M1_Channel',num2str(param.M1_good_chans(M1_lfp_chan)),'/Cb_Ch',num2str(Cb_neuron_chan),'_code',num2str(Cb_neuron_num),'_coherence_data.mat']);
                            end
                        end
                    end
                end
            end
            
            for Cb_lfp_chan = find(ismember(param.Cb_good_chans,Cb_channels_of_interest))
                if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/Cb_Channel',num2str(param.Cb_good_chans(Cb_lfp_chan))],'dir')
                    mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/Cb_Channel',num2str(param.Cb_good_chans(Cb_lfp_chan))]);
                end
                for M1_neuron_chan = 1:param.M1_chans
                    for M1_neuron_num = 1:param.M1_neurons
                        if ~isempty(Cb_lfp_chan) && M1_neurons_of_interest{day}(M1_neuron_chan, M1_neuron_num)
                            
                            %Ver 1
                            LFP_snapshots = squeeze(Cb_snapshots(Cb_lfp_chan,:,:));
                            M1_spike_bins = zeros(size(M1_snapshots,2),size(M1_spike_snapshots,3));
                            for trial = 1:size(M1_spike_snapshots,3)
                                [bins, bin_limits] = binspikes([M1_spike_snapshots{M1_neuron_chan,M1_neuron_num,trial}]/param.M1_Fs,param.M1_Fs,[0 8]);
                                if sum(bins) >= min_spikes
                                    M1_spike_bins(:,trial) = conv(bins,M1_kernel,'same');
                                end
                            end
                            LFP_snapshots(:,sum(M1_spike_bins,1) == 0) = [];
                            M1_spike_bins(:,sum(M1_spike_bins,1) == 0) = [];
                            if ~isempty(M1_spike_bins)
                                parallel_structs_Cb_M1(day,block,Cb_lfp_chan,M1_neuron_chan,M1_neuron_num) = struct('Fs',param.Cb_Fs,'LFP_snapshot',LFP_snapshots,'spike_bins',M1_spike_bins,'save_path',[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/Cb_Channel',num2str(param.Cb_good_chans(Cb_lfp_chan)),'/M1_Ch',num2str(M1_neuron_chan),'_code',num2str(M1_neuron_num),'_coherence_data.mat']);
                            end
                        end
                    end
                end
                
                for Cb_neuron_chan = 1:param.Cb_chans
                    for Cb_neuron_num = 1:param.Cb_neurons
                        if ~isempty(Cb_lfp_chan) && Cb_neurons_of_interest{day}(Cb_neuron_chan, Cb_neuron_num)
                            
                            %Ver 1
                            LFP_snapshots = squeeze(Cb_snapshots(Cb_lfp_chan,:,:));
                            Cb_spike_bins = zeros(size(Cb_snapshots,2),size(Cb_spike_snapshots,3));
                            for trial = 1:size(Cb_spike_snapshots,3)
                                [bins, bin_limits] = binspikes([Cb_spike_snapshots{Cb_neuron_chan,Cb_neuron_num,trial}]/param.Cb_Fs,param.Cb_Fs,[0 8]);
                                if sum(bins) >= min_spikes
                                    Cb_spike_bins(:,trial) = conv(bins,Cb_kernel,'same');
                                end
                            end
                            LFP_snapshots(:,sum(Cb_spike_bins,1) == 0) = [];
                            Cb_spike_bins(:,sum(Cb_spike_bins,1) == 0) = [];
                            if ~isempty(Cb_spike_bins)
                                parallel_structs_Cb_Cb(day,block,Cb_lfp_chan,Cb_neuron_chan,Cb_neuron_num) = struct('Fs',param.Cb_Fs,'LFP_snapshot',LFP_snapshots,'spike_bins',Cb_spike_bins,'save_path',[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/Cb_Channel',num2str(param.Cb_good_chans(Cb_lfp_chan)),'/Cb_Ch',num2str(Cb_neuron_chan),'_code',num2str(Cb_neuron_num),'_coherence_data.mat']);
                            end
                        end
                    end
                end
            end
        end
    end
    
    parallel_structs = cat(6,parallel_structs_M1_M1,parallel_structs_M1_Cb,parallel_structs_Cb_M1,parallel_structs_Cb_Cb);
    parpool('local',worker_num);
    parfor i = 1:length(parallel_structs(:))
        if ~isempty(parallel_structs(i).save_path)
            spike_field_par_calc_alt(parallel_structs(i));
        end
    end
    delete(gcp('nocreate'))
    
    clear params parallel_structs parallel_structs_M1_M1 parallel_structs_M1_Cb parallel_structs_Cb_M1 parallel_structs_Cb_Cb worker_num kernel min_spikes day block M1_channels_of_interest M1_neurons_of_interest Cb_channels_of_interest Cb_neurons_of_interest;
    if isunix
        rmpath(genpath('/common/fleischerp/HPC_code'))
        rmpath(genpath('/common/fleischerp/3rd_party_code'))
    else
        rmpath(genpath('Z:/Matlab for analysis/chronux_2_10/chronux/spectral_analysis'))
    end
    
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Plot Spike/LFP Coherence Data (36) !!Obsolete. Use 44!!

if false
    M1_channels_of_interest = [31]; %#ok<UNRCH>
    Cb_channels_of_interest = [28]; %#ok<*NBRAK>
    if isempty([M1_channels_of_interest Cb_channels_of_interest])
        M1_channels_of_interest = 1:param.M1_chans;
        Cb_channels_of_interest = 1:param.Cb_chans;
    end
    
    M1_neurons_of_interest = {[],...
                              [],...
                              [],...
                              [],...
                              []};
    Cb_neurons_of_interest = {[],... 
                              [],...
                              [],...
                              [],...
                              []};
    if isempty([M1_neurons_of_interest{:} Cb_neurons_of_interest{:}])
        M1_neurons_of_interest = {1:(param.M1_chans*param.M1_neurons), 1:(param.M1_chans*param.M1_neurons), 1:(param.M1_chans*param.M1_neurons), 1:(param.M1_chans*param.M1_neurons), 1:(param.M1_chans*param.M1_neurons)};
        Cb_neurons_of_interest = {1:(param.Cb_chans*param.Cb_neurons), 1:(param.Cb_chans*param.Cb_neurons), 1:(param.Cb_chans*param.Cb_neurons), 1:(param.Cb_chans*param.Cb_neurons), 1:(param.Cb_chans*param.Cb_neurons)};
    end
    
    for day=1:param.days               
        for block=1:param.blocks       
            for lfp_chan = 1:max(param.M1_chans, param.Cb_chans)  
                if ismember(param.M1_good_chans(lfp_chan),M1_channels_of_interest)
                    neuron_idx = 0;
                    for s_chan = 1:max(param.M1_chans, param.Cb_chans) 
                        for code = 1:1:max(param.M1_neurons, param.Cb_neurons)
                            neuron_idx = neuron_idx + 1;
                            if ismember(neuron_idx,M1_neurons_of_interest{day})
                                if exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/M1_Channel',num2str(param.M1_good_chans(lfp_chan)),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data', '.mat'], 'file')
                                    load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/M1_Channel',num2str(param.M1_good_chans(lfp_chan)),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data', '.mat'])
                                    
                                    figure;
                                    pcolor(coh_times,coh_freqs,squeeze(mean(coh, 3)))
                                    shading interp
                                    axis xy
                                    axis([-1000 1500 1.5 20])
                                    caxis([0 0.8])
                                    colorbar
                                    title('Coherence Magnitude')
                                    
                                    saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/M1_Channel',num2str(param.M1_good_chans(lfp_chan)),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_heatmap', '.fig']);
                                    close all
                                end
                            end
                            
                            if ismember(neuron_idx,Cb_neurons_of_interest{day}) 
                                if exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/M1_Channel',num2str(param.M1_good_chans(lfp_chan)),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data', '.mat'], 'file')
                                    load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/M1_Channel',num2str(param.M1_good_chans(lfp_chan)),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data', '.mat'])

                                    figure;
                                    pcolor(coh_times,coh_freqs,squeeze(mean(coh, 3)))
                                    shading interp
                                    axis xy
                                    axis([-1000 1500 1.5 20])
                                    caxis([0 0.8])
                                    colorbar
                                    title('Coherence Magnitude')
            
                                    saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/M1_Channel',num2str(param.M1_good_chans(lfp_chan)),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_heatmap', '.fig'])
                                    close all
                                end
                            end
                        end
                    end
                end
                
                if ismember(param.Cb_good_chans(lfp_chan),Cb_channels_of_interest)
                    neuron_idx = 0;
                    for s_chan = 1:max(param.M1_chans, param.Cb_chans) 
                        for code = 1:1:max(param.M1_neurons, param.Cb_neurons)
                            neuron_idx = neuron_idx + 1;
                            if ismember(neuron_idx,M1_neurons_of_interest{day})
                                if exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan)),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data', '.mat'], 'file')
                                    load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan)),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data', '.mat'])

                                    figure;
                                    pcolor(coh_times,coh_freqs,squeeze(mean(coh, 3)))
                                    shading interp
                                    axis xy
                                    axis([-1000 1500 1.5 20])
                                    caxis([0 0.8])
                                    colorbar
                                    title('Coherence Magnitude')
                                    
                                    saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan)),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_heatmap', '.fig'])
                                    close all
                                end
                            end
                            
                            if ismember(neuron_idx,Cb_neurons_of_interest{day})
                                if exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan)),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data', '.mat'], 'file')
                                    load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan)),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data', '.mat'])
                                    
                                    figure;
                                    pcolor(coh_times,coh_freqs,squeeze(mean(coh, 3)))
                                    shading interp
                                    axis xy
                                    axis([-1000 1500 1.5 20])
                                    caxis([0 0.8])
                                    colorbar
                                    title('Coherence Magnitude')

                                    saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan)),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_heatmap', '.fig'])
                                    close all
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Collect Data for DataHigh package (GPFA Neural Trajectory Analysis) (37)

if enabled(37)
    disp('Block 37...')
    task_related_only = true;
    for day=1:param.days
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/spiketrain_snapshots_full.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_timestamps.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/inter_event_intervals.mat']);
            
            if task_related_only
                idxs = repmat(param.M1_task_related_neurons{day},1,1,size(M1_spike_snapshots_full,3));
                M1_spike_snapshots_full(~idxs) = {[]};
                M1_spike_timestamps(~param.M1_task_related_neurons{day}) = {[]};
                idxs = repmat(param.Cb_task_related_neurons{day},1,1,size(Cb_spike_snapshots_full,3));
                Cb_spike_snapshots_full(~idxs) = {[]};
                Cb_spike_timestamps(~param.Cb_task_related_neurons{day}) = {[]};
            end
            
            trial_codes = str2double(data(:,3));
            reach_retract_interval(trial_codes > 1) = [];
            M1_reach_retract_interval = round(reach_retract_interval*1000);
            Cb_reach_retract_interval = round(reach_retract_interval*1000);
            trial_codes(trial_codes > 1) = [];
            [M1_chans, M1_codes, trials] = size(M1_spike_snapshots_full);
            [Cb_chans, Cb_codes, ~] = size(Cb_spike_snapshots_full);
            num_neurons = sum(sum(~cellfun('isempty',M1_spike_timestamps)));
            %all_M1_neuron_ave_hz = zeros(num_neurons,8000/bin_size);
            %all_M1_neuron_alt_hist = zeros(num_neurons,8000/bin_size);
            neuron_num = 1;
            M1_GPFA_data = repmat(struct('data',[],'condition','','epochStarts', 1, 'epochColors', [0,0,0]),trials,1);
            Cb_GPFA_data = repmat(struct('data',[],'condition','','epochStarts', 1, 'epochColors', [0,0,0]),trials,1);
            for trial = 1:trials
                if trial_codes(trial) == 1
                    M1_GPFA_data(trial).condition = 'success';
                    M1_GPFA_data(trial).epochStarts = [1, 251, min(4001,251+M1_reach_retract_interval(trial))];
                    M1_GPFA_data(trial).epochColors = [0.7000,0.7000,0.7000;0,0.7000,0;0,0,0];
                    
                    Cb_GPFA_data(trial).condition = 'success';
                    Cb_GPFA_data(trial).epochStarts = [1, 251, min(4001,251+Cb_reach_retract_interval(trial))];
                    Cb_GPFA_data(trial).epochColors = [0.7000,0.7000,0.7000;0,0.7000,0;0,0,0];
                elseif reach_retract_interval(trial) > 0 
                    M1_GPFA_data(trial).condition = 'failure';
                    M1_GPFA_data(trial).epochStarts = [1, 251, min(4001,251+M1_reach_retract_interval(trial))];
                    M1_GPFA_data(trial).epochColors = [0.7000,0.7000,0.7000;1,0,0;0,0,0];
                    
                    Cb_GPFA_data(trial).condition = 'failure';
                    Cb_GPFA_data(trial).epochStarts = [1, 251, min(4001,251+Cb_reach_retract_interval(trial))];
                    Cb_GPFA_data(trial).epochColors = [0.7000,0.7000,0.7000;1,0,0;0,0,0];
                else
                    continue
                end
                M1_neuron_idx = 0;
                Cb_neuron_idx = 0;
                for chan = 1:M1_chans
                    for code = 1:M1_codes
                        if ~isempty(M1_spike_timestamps{chan, code})
                            M1_neuron_idx = M1_neuron_idx + 1;
                            [spike_hist, bin_edges] = histcounts(M1_spike_snapshots_full{chan,code,trial}-(4*param.M1_Fs),-4*param.M1_Fs:param.M1_Fs/1000:4*param.M1_Fs);
                            M1_GPFA_data(trial).data(M1_neuron_idx,:) = spike_hist(3750:min(4250+M1_reach_retract_interval(trial),length(spike_hist)));
                        end
                    end
                end
                
                for chan = 1:Cb_chans
                    for code = 1:Cb_codes
                        if ~isempty(Cb_spike_timestamps{chan, code})
                            Cb_neuron_idx = Cb_neuron_idx + 1;
                            [spike_hist, bin_edges] = histcounts(Cb_spike_snapshots_full{chan,code,trial}-(4*param.Cb_Fs),-4*param.Cb_Fs:param.Cb_Fs/1000:4*param.Cb_Fs);
                            Cb_GPFA_data(trial).data(Cb_neuron_idx,:) = spike_hist(3750:min(4250+Cb_reach_retract_interval(trial),length(spike_hist)));
                        end
                    end
                end
            end
            M1_GPFA_data(cellfun(@isempty,{M1_GPFA_data.condition})) = [];
            Cb_GPFA_data(cellfun(@isempty,{Cb_GPFA_data.condition})) = [];
            
            save ([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GPFA_data.mat'], 'M1_GPFA_data', 'Cb_GPFA_data')
            clearvars -except code_rootpath rootpath origin_rootpath animal param enabled day block day_GPFA_data task_related_only;
        end        
    end
    clear day block day_GPFA_data task_related_only;
end

%% Create GPFA Neural Trajectories with DataHigh (38)
%Create trajectories on 1st screen. 10 ms window, 1hz minimum firing rate. Default everything else.
%Save on 2nd screen. There should be an M1 and Cb save for each day.

if enabled(38)
    disp('Block 38...')
    
    addpath(genpath([code_rootpath, 'DataHigh1.3']))
    disp('Use 10ms time bins and 1hz min spikes.')
    for day=1:param.days
        
        M1_day_GPFA_data = [];
        Cb_day_GPFA_data = [];
        for block=1:param.blocks
            load ([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GPFA_data.mat'])
            M1_day_GPFA_data = cat(1, M1_day_GPFA_data, M1_GPFA_data);
            Cb_day_GPFA_data = cat(1, Cb_day_GPFA_data, Cb_GPFA_data);
        end
        disp(['Day ',num2str(day)])
        DataHigh(M1_day_GPFA_data,'DimReduce')
        input('Press enter when done')
        DataHigh(Cb_day_GPFA_data,'DimReduce')
        input('Press enter when done')
    end
    rmpath(genpath([code_rootpath, 'DataHigh1.3']))
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Calculate Mean Success Trajectory and Consistency of Each Trial From that Mean(39)

if enabled(39)
    disp('Block 39...')
    M1_all_traj_corr = nan(param.days,3);
    Cb_all_traj_corr = nan(param.days,3);
    M1_all_traj_corr_full = cell(param.days,3);
    Cb_all_traj_corr_full = cell(param.days,3);
    
    M1_factors = 2;
    Cb_factors = 2;
    num_plot_trials = inf;
    for day = 1:param.days
        M1_day_GPFA_data = [];
        for block=1:param.blocks
            load ([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GPFA_data.mat'])
            M1_day_GPFA_data = cat(1, M1_day_GPFA_data, M1_GPFA_data);
            
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/inter_event_intervals.mat']);
            reach_touch_interval(reach_touch_interval == -1) = [];
            if block == 1
                day_reach_touch_interval = round(reach_touch_interval*100);
            else
                day_reach_touch_interval = cat(1,day_reach_touch_interval,round(reach_touch_interval*100));
            end
        end
        
        if exist([rootpath,animal,'/Day',num2str(day),'/M1_2PC_factors.mat'],'file')
            load([rootpath,animal,'/Day',num2str(day),'/M1_2PC_factors.mat']);
            M1_traj = D;
            clear D
        else
            M1_traj = struct();
            M1_traj = repmat(M1_traj,0,1);
        end
        
        if exist([rootpath,animal,'/Day',num2str(day),'/Cb_2PC_factors.mat'],'file')
            load([rootpath,animal,'/Day',num2str(day),'/Cb_2PC_factors.mat']);
            Cb_traj = D;
            clear D
        else
            Cb_traj = struct();
            Cb_traj = repmat(Cb_traj,0,1);
        end
        
        for i = 1:length(M1_traj)
            touch_time = min(day_reach_touch_interval(i)+26,400);
            M1_traj(i).epochStarts = [M1_traj(i).epochStarts(1:2) touch_time M1_traj(i).epochStarts(3)];
            M1_traj(i).data = M1_traj(i).data(1:M1_factors,:);
        end
        for i = 1:length(Cb_traj)
            touch_time = min(day_reach_touch_interval(i)+26,400);
            Cb_traj(i).epochStarts = [Cb_traj(i).epochStarts(1:2) touch_time Cb_traj(i).epochStarts(3)];
            Cb_traj(i).data = Cb_traj(i).data(1:Cb_factors,:);
        end
        
        succ_bool = cellfun(@(x)(strcmp(x,'success')),{M1_day_GPFA_data.condition});
        succ_bool = repmat(succ_bool',1,3);
        %M1_traj = M1_traj(succ_bool);
        %Cb_traj = Cb_traj(succ_bool);
        %Find mean and stdv trajectory length
        %Remove trajectories that differ from mean by more than an stdv
        %M1_traj = remove_outlier_trajectories(M1_traj, 1.0);
        if ~isempty(M1_traj)
            %Interpolate remaining trajectories and find mean trajectory
            M1_traj_i = interpolate_trajectories(M1_traj);
            [M1_succ_traj, M1_fail_traj] = success_fail_split(M1_traj_i,succ_bool,[],1);
            
            M1_mean_trajectory = trajectory_mean_calc(M1_succ_traj);
            %Plot the 20 trajectories that differ the least from the mean trajectory
            M1_traj_sq_errors = trajectory_error_calc(M1_traj_i, M1_mean_trajectory);
            [M1_traj_sq_errors, sort_idx] = sort(M1_traj_sq_errors);
            M1_traj_i = M1_traj_i(sort_idx);
            M1_plot_num = min(length(M1_traj_i), 20);
            M1_plots = plot_trajectories(M1_traj_i(1:M1_plot_num));
            %Plot mean (red) and mean of the 20 member subset (purple)
            line(M1_mean_trajectory(2,:),M1_mean_trajectory(1,:),'Color',[1 0 0],'LineWidth',2)
            M1_mean_trajectory_2 = trajectory_mean_calc(M1_traj_i(1:M1_plot_num));
            line(M1_mean_trajectory_2(2,:),M1_mean_trajectory_2(1,:),'Color',[1 0 1],'LineWidth',2)
            saveas(M1_plots,[rootpath,animal,'/Day',num2str(day),'/trajectories_M1_diff.fig']);
            close all
            
            %Plot the 20 trajectories that are the most correlated with the mean trajectory
            M1_succ_traj_corr = trajectory_consistency_calc(M1_succ_traj);
            M1_fail_traj_corr = trajectory_consistency_calc(M1_fail_traj, M1_mean_trajectory);
            M1_traj_corr = trajectory_consistency_calc(M1_traj_i, M1_mean_trajectory);
            [M1_traj_corr, sort_idx] = sort(M1_traj_corr);
            M1_traj_i = M1_traj_i(sort_idx);
            M1_plot_num = min(length(M1_traj_i), 20);
            M1_plots = plot_trajectories_alt(M1_traj_i(1:M1_plot_num));
            %Plot mean (red) and mean of the 20 member subset (purple)
            line(M1_mean_trajectory(2,:),M1_mean_trajectory(1,:),'Color',[1 0 0],'LineWidth',2)
            M1_mean_trajectory_2 = trajectory_mean_calc(M1_traj_i(1:M1_plot_num));
            line(M1_mean_trajectory_2(2,:),M1_mean_trajectory_2(1,:),'Color',[1 0 1],'LineWidth',2)
            saveas(M1_plots,[rootpath,animal,'/Day',num2str(day),'/trajectories_M1.fig']);
            close all
            
            epoch_colors = [0.7,0.7,0.7; 1,0,1; 0,0,0];
            
            %Plot Success and Failure factors separately
            [M1_succ_traj, M1_fail_traj] = success_fail_split(M1_traj,succ_bool,[],1);
            for factor_idx = 1:M1_factors
                if num_plot_trials < length(M1_succ_traj)
                    plot_trials = randperm(length(M1_succ_traj),num_plot_trials);
                else
                    plot_trials = 1:length(M1_succ_traj);
                end
                figure
                for i = plot_trials
                    data = M1_succ_traj(i).data(factor_idx,:);
                    epochs = M1_succ_traj(i).epochStarts;
                    line(1:epochs(2), data(1:epochs(2)),'Color', epoch_colors(1,:));
                    line(epochs(2):epochs(3), data(epochs(2):epochs(3)),'Color', epoch_colors(2,:));
                    line(epochs(3):length(data), data(epochs(3):end),'Color', epoch_colors(3,:));
                end
                mean_factor = M1_mean_trajectory(factor_idx,:);
                line(1:length(mean_factor), mean_factor,'Color', [0 0 0],'LineWidth',2);
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Factor', num2str(factor_idx), '_M1_succ.fig']);
                close all
                
                if num_plot_trials < length(M1_fail_traj)
                    plot_trials = randperm(length(M1_fail_traj),num_plot_trials);
                else
                    plot_trials = 1:length(M1_fail_traj);
                end
                figure
                for i = plot_trials
                    data = M1_fail_traj(i).data(factor_idx,:);
                    epochs = M1_fail_traj(i).epochStarts;
                    line(1:epochs(2), data(1:epochs(2)),'Color', epoch_colors(1,:));
                    line(epochs(2):epochs(3), data(epochs(2):epochs(3)),'Color', epoch_colors(2,:));
                    line(epochs(3):length(data), data(epochs(3):end),'Color', epoch_colors(3,:));
                end
                mean_factor = M1_mean_trajectory(factor_idx,:);
                line(1:length(mean_factor), mean_factor,'Color', [0 0 0],'LineWidth',2);
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Factor', num2str(factor_idx), '_M1_fail.fig']);
                close all
            end
            
            M1_all_traj_corr(day,1) = mean(M1_succ_traj_corr);
            M1_all_traj_corr(day,2) = mean(M1_fail_traj_corr);
            M1_all_traj_corr(day,3) = mean(M1_traj_corr);
            M1_all_traj_corr_full{day,1} = M1_succ_traj_corr;
            M1_all_traj_corr_full{day,2} = M1_fail_traj_corr;
            M1_all_traj_corr_full{day,3} = M1_traj_corr;
            
            M1_traj_i = trajectory_length_filter(M1_traj_i, .25);
            
            M1_plots = plot_trajectories(M1_traj_i);
        end
        
        %Find mean and stdv trajectory length
        %Remove trajectories that differ from mean by more than an stdv
        %Cb_traj = remove_outlier_trajectories(Cb_traj, 1.0);
        if ~isempty(Cb_traj)
            %Interpolate remaining trajectories and find mean trajectory
            Cb_traj_i = interpolate_trajectories(Cb_traj);
            [Cb_succ_traj, Cb_fail_traj] = success_fail_split(Cb_traj_i,succ_bool,[],1);
            
            Cb_mean_trajectory = trajectory_mean_calc(Cb_succ_traj);
            %Plot the 20 trajectories that differ the least from the mean trajectory
            Cb_traj_sq_errors = trajectory_error_calc(Cb_traj_i, Cb_mean_trajectory);
            [Cb_traj_sq_errors, sort_idx] = sort(Cb_traj_sq_errors);
            Cb_traj_i = Cb_traj_i(sort_idx);
            Cb_plot_num = min(length(Cb_traj_i), 20);
            Cb_plots = plot_trajectories(Cb_traj_i(1:Cb_plot_num));
            %Plot mean (red) and mean of the 20 member subset (purple)
            line(Cb_mean_trajectory(2,:),Cb_mean_trajectory(1,:),'Color',[1 0 0],'LineWidth',2)
            Cb_mean_trajectory_2 = trajectory_mean_calc(Cb_traj_i(1:Cb_plot_num));
            line(Cb_mean_trajectory_2(2,:),Cb_mean_trajectory_2(1,:),'Color',[1 0 1],'LineWidth',2)
            saveas(Cb_plots,[rootpath,animal,'/Day',num2str(day),'/trajectories_Cb_diff.fig']);
            close all
            %Plot the 20 trajectories that are the most correlated with the mean trajectory
            Cb_succ_traj_corr = trajectory_consistency_calc(Cb_succ_traj);
            Cb_fail_traj_corr = trajectory_consistency_calc(Cb_fail_traj, Cb_mean_trajectory);
            Cb_traj_corr = trajectory_consistency_calc(Cb_traj_i, Cb_mean_trajectory);
            [Cb_traj_corr, sort_idx] = sort(Cb_traj_corr);
            Cb_traj_i = Cb_traj_i(sort_idx);
            Cb_plot_num = min(length(Cb_traj_i), 20);
            Cb_plots = plot_trajectories_alt(Cb_traj_i(1:Cb_plot_num));
            %Plot mean (red) and mean of the 20 member subset (purple)
            line(Cb_mean_trajectory(2,:),Cb_mean_trajectory(1,:),'Color',[1 0 0],'LineWidth',2)
            Cb_mean_trajectory_2 = trajectory_mean_calc(Cb_traj_i(1:Cb_plot_num));
            line(Cb_mean_trajectory_2(2,:),Cb_mean_trajectory_2(1,:),'Color',[1 0 1],'LineWidth',2)
            saveas(Cb_plots,[rootpath,animal,'/Day',num2str(day),'/trajectories_Cb.fig']);
            close all
            
            epoch_colors = [0.7,0.7,0.7; 1,0.4,0; 0,0,0];
            
            %Plot Success and Failure factors separately
            [Cb_succ_traj, Cb_fail_traj] = success_fail_split(Cb_traj,succ_bool,[],1);
            for factor_idx = 1:Cb_factors
                if num_plot_trials < length(Cb_succ_traj)
                    plot_trials = randperm(length(Cb_succ_traj),num_plot_trials);
                else
                    plot_trials = 1:length(Cb_succ_traj);
                end
                figure
                for i = plot_trials
                    data = Cb_succ_traj(i).data(factor_idx,:);
                    epochs = Cb_succ_traj(i).epochStarts;
                    line(1:epochs(2), data(1:epochs(2)),'Color', epoch_colors(1,:));
                    line(epochs(2):epochs(3), data(epochs(2):epochs(3)),'Color', epoch_colors(2,:));
                    line(epochs(3):length(data), data(epochs(3):end),'Color', epoch_colors(3,:));
                end
                mean_factor = Cb_mean_trajectory(factor_idx,:);
                line(1:length(mean_factor), mean_factor,'Color', [0 0 0],'LineWidth',2);
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Factor', num2str(factor_idx), '_Cb_succ.fig']);
                close all
                
                if num_plot_trials < length(Cb_fail_traj)
                    plot_trials = randperm(length(Cb_fail_traj),num_plot_trials);
                else
                    plot_trials = 1:length(Cb_fail_traj);
                end
                figure
                for i = plot_trials
                    data = Cb_fail_traj(i).data(factor_idx,:);
                    epochs = Cb_fail_traj(i).epochStarts;
                    line(1:epochs(2), data(1:epochs(2)),'Color', epoch_colors(1,:));
                    line(epochs(2):epochs(3), data(epochs(2):epochs(3)),'Color', epoch_colors(2,:));
                    line(epochs(3):length(data), data(epochs(3):end),'Color', epoch_colors(3,:));
                end
                mean_factor = Cb_mean_trajectory(factor_idx,:);
                line(1:length(mean_factor), mean_factor,'Color', [0 0 0],'LineWidth',2);
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Factor', num2str(factor_idx), '_Cb_fail.fig']);
                close all
            end
            
            Cb_all_traj_corr(day,1) = mean(Cb_succ_traj_corr);
            Cb_all_traj_corr(day,2) = mean(Cb_fail_traj_corr);
            Cb_all_traj_corr(day,3) = mean(Cb_traj_corr);
            Cb_all_traj_corr_full{day,1} = Cb_succ_traj_corr;
            Cb_all_traj_corr_full{day,2} = Cb_fail_traj_corr;
            Cb_all_traj_corr_full{day,3} = Cb_traj_corr;
            
            Cb_traj_i = trajectory_length_filter(Cb_traj_i, .25);
            
            Cb_plots = plot_trajectories(Cb_traj_i);
        end

    end
    load([rootpath,animal,'/Shared_Data.mat'])
    shared_data.M1_succ_traj_corr = M1_all_traj_corr(:,1)';
    shared_data.M1_fail_traj_corr = M1_all_traj_corr(:,2)';
    shared_data.M1_all_traj_corr = M1_all_traj_corr(:,3)';
    shared_data.Cb_succ_traj_corr = Cb_all_traj_corr(:,1)';
    shared_data.Cb_fail_traj_corr = Cb_all_traj_corr(:,2)';
    shared_data.Cb_all_traj_corr = Cb_all_traj_corr(:,3)';
    
    shared_data.M1_succ_traj_corr_full = M1_all_traj_corr_full(:,1)';
    shared_data.M1_fail_traj_corr_full = M1_all_traj_corr_full(:,2)';
    shared_data.M1_all_traj_corr_full = M1_all_traj_corr_full(:,3)';
    shared_data.Cb_succ_traj_corr_full = Cb_all_traj_corr_full(:,1)';
    shared_data.Cb_fail_traj_corr_full = Cb_all_traj_corr_full(:,2)';
    shared_data.Cb_all_traj_corr_full = Cb_all_traj_corr_full(:,3)';
    save([rootpath,animal,'/Shared_Data.mat'], 'shared_data')
    
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
    close all
end

%% Spike Occurence to Filtered LFP Phase (40-old) (This probably won't be used again but it feels bad to delete)

if false
    addpath('Z:\Matlab for analysis\circStat2008\sis_data\matlab code\nhp data\MATLAB files\circStat2008');
    M1_channels_of_interest = [6]; %  I060: 6 I076: 15 I061: 29 I064: 28 I086: 21 I089: 2
    Cb_channels_of_interest = [7]; %  I060: 7 I076: 23 I061: 20 I064: 17 I086: 15 I089: 7
    edge_exp = -5:0.1:5;
    edges = exp(edge_exp);
    window_start = 3.75;
    window_end = 4.75;
    if isempty(M1_channels_of_interest)
        M1_channels_of_interest = 1:param.M1_chans;
    end
    if isempty(Cb_channels_of_interest)
        Cb_channels_of_interest = 1:param.Cb_chans;
    end
    
    M1_neurons_of_interest = {1:(param.M1_chans*param.M1_neurons), 1:(param.M1_chans*param.M1_neurons), 1:(param.M1_chans*param.M1_neurons), 1:(param.M1_chans*param.M1_neurons), 1:(param.M1_chans*param.M1_neurons)};
    Cb_neurons_of_interest = {1:(param.Cb_chans*param.Cb_neurons), 1:(param.Cb_chans*param.Cb_neurons), 1:(param.Cb_chans*param.Cb_neurons), 1:(param.Cb_chans*param.Cb_neurons), 1:(param.Cb_chans*param.Cb_neurons)};
        
    M1_min_spikes = 8;
    Cb_min_spikes = 4;
    
    M1Ch_M1Nrn_stats = cell(1,param.days);
    M1Ch_CbNrn_stats = cell(1,param.days);
    CbCh_M1Nrn_stats = cell(1,param.days);
    CbCh_CbNrn_stats = cell(1,param.days);
    
    for day=1:param.days
        M1Ch_M1Nrn_spike_phase = cell(param.M1_chans,param.M1_chans,param.M1_neurons);
        M1Ch_CbNrn_spike_phase = cell(param.M1_chans,param.Cb_chans,param.Cb_neurons);
        CbCh_M1Nrn_spike_phase = cell(param.Cb_chans,param.M1_chans,param.M1_neurons);
        CbCh_CbNrn_spike_phase = cell(param.Cb_chans,param.Cb_chans,param.Cb_neurons);
        for block=1:param.blocks
            if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data'],'dir')
                mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data']);
            end
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Normalized_Snapshots', '.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Filtered_LFP_Snapshots.mat']); %M1_1_4_snapshots
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/spiketrain_snapshots_full.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/neuron_firing_rates.mat']);
            
            M1_spike_snapshots_full(~param.M1_task_related_neurons{day}(:,:,ones(1,size(M1_spike_snapshots_full,3)))) = cell(1);
            Cb_spike_snapshots_full(~param.Cb_task_related_neurons{day}(:,:,ones(1,size(Cb_spike_snapshots_full,3)))) = cell(1);
            
            trial_codes = str2double(data(:,3));
            no_reach_trials = (1:size(data,1));
            no_reach_trials = no_reach_trials(trial_codes>1);
            
            all_bad_trials = union(M1_bad_trials, Cb_bad_trials);
            [M1_snapshots, Cb_snapshots] = get_common_good_data(M1_snapshots, Cb_snapshots, M1_bad_trials, Cb_bad_trials, 3);
            [M1_spike_snapshots, ~] = get_common_good_data(M1_spike_snapshots_full, M1_snapshots, no_reach_trials, all_bad_trials, 3);
            [Cb_spike_snapshots, ~] = get_common_good_data(Cb_spike_snapshots_full, Cb_snapshots, no_reach_trials, all_bad_trials, 3);
            [M1_filt, Cb_filt] = get_common_good_data(M1_1_4_snapshots, Cb_1_4_snapshots, M1_bad_trials, Cb_bad_trials, 3);
            
            for lfp_chan = 1:length(param.M1_good_chans)
                if ismember(param.M1_good_chans(lfp_chan),M1_channels_of_interest)
                    if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(lfp_chan))],'dir')
                        mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(lfp_chan))]);
                    end
                    neuron_idx = 0;
                    for s_chan = 1:param.M1_chans
                        for code = 1:param.M1_neurons
                            neuron_idx = neuron_idx + 1;
                            if ismember(neuron_idx,M1_neurons_of_interest{day})
                                if ((length([M1_spike_snapshots{s_chan,code,:}]) / size(M1_spike_snapshots,3)) >= M1_min_spikes) && (param.M1_good_chans(lfp_chan) ~= s_chan)
                                    %--do calc--
                                    %calc mean lfp across trials
                                    LFP_mean = mean(M1_snapshots(lfp_chan,:,:),3);
                                    %filter lfp
                                    LFP_filt = mean(M1_filt(lfp_chan,:,:),3);
                                    %tally spikes across trials
                                    block_spike_times = [M1_spike_snapshots{s_chan,code,:}];
                                    block_spike_times = block_spike_times((block_spike_times > window_start*param.M1_Fs) & (block_spike_times < window_end*param.M1_Fs));
                                    %calc phase of lfp at each spike time
                                    hilbert_LFP = hilbert(LFP_filt);
                                    inst_phase = unwrap(angle(hilbert_LFP));%inst phase
                                    radial_phase = mod(inst_phase,2*pi);
                                    spike_phases = radial_phase(round(block_spike_times+1));
                                    %store data for comparison to other brain area equivalents
                                    save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(lfp_chan)),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phases', '.mat'],'spike_phases');
                                    %plot
                                    phase_hist = polarhistogram(spike_phases,12,'FaceColor', [.8 0 0], 'FaceAlpha', 1);
                                    saveas(phase_hist,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(lfp_chan)),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phase_histogram', '.fig'])
                                    close all;
                                    
                                    M1Ch_M1Nrn_spike_phase{lfp_chan,s_chan,code} = [M1Ch_M1Nrn_spike_phase{lfp_chan,s_chan,code} spike_phases];
                                end
                            end
                        end
                    end
                    neuron_idx = 0;
                    for s_chan = 1:param.Cb_chans
                        for code = 1:param.Cb_neurons
                            neuron_idx = neuron_idx + 1;
                            if ismember(neuron_idx,Cb_neurons_of_interest{day})
                                if (length([Cb_spike_snapshots{s_chan,code,:}]) / size(Cb_spike_snapshots,3)) >= Cb_min_spikes
                                    %--do calc--
                                    %calc mean lfp across trials
                                    LFP_mean = mean(M1_snapshots(lfp_chan,:,:),3);
                                    %filter lfp
                                    LFP_filt = mean(M1_filt(lfp_chan,:,:),3);
                                    %tally spikes across trials
                                    block_spike_times = [Cb_spike_snapshots{s_chan,code,:}];
                                    block_spike_times = block_spike_times((block_spike_times > window_start*param.M1_Fs) & (block_spike_times < window_end*param.M1_Fs));
                                    %calc phase of lfp at each spike time
                                    hilbert_LFP = hilbert(LFP_filt);
                                    inst_phase = unwrap(angle(hilbert_LFP));%inst phase
                                    radial_phase = mod(inst_phase,2*pi);
                                    spike_phases = radial_phase(round(block_spike_times+1));
                                    %store data for comparison to other brain area equivalents
                                    save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(lfp_chan)),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phases', '.mat'],'spike_phases');
                                    %plot
                                    phase_hist = polarhistogram(spike_phases,12,'FaceColor', [.8 0 0], 'FaceAlpha', 1);
                                    saveas(phase_hist,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(lfp_chan)),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phase_histogram', '.fig'])
                                    close all;
                                    
                                    M1Ch_CbNrn_spike_phase{lfp_chan,s_chan,code} = [M1Ch_CbNrn_spike_phase{lfp_chan,s_chan,code} spike_phases];
                                    
                                    
                                    
                                end
                            end
                        end
                    end
                end
            end
            
            for lfp_chan = 1:length(param.Cb_good_chans)
                if ismember(param.Cb_good_chans(lfp_chan),Cb_channels_of_interest)
                    if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan))],'dir')
                        mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan))]);
                    end
                    M1_neurons_zscores = nan(param.M1_chans,param.M1_neurons);
                    Cb_neurons_zscores = nan(param.Cb_chans,param.Cb_neurons);
                    M1_neurons_pscores = nan(param.M1_chans,param.M1_neurons);
                    Cb_neurons_pscores = nan(param.Cb_chans,param.Cb_neurons);
                    neuron_idx = 0;
                    for s_chan = 1:param.M1_chans
                        for code = 1:param.M1_neurons
                            neuron_idx = neuron_idx + 1;
                            if ismember(neuron_idx,M1_neurons_of_interest{day})
                                if (length([M1_spike_snapshots{s_chan,code,:}]) / size(M1_spike_snapshots,3)) >= M1_min_spikes
                                    %--do calc--
                                    %calc mean lfp across trials
                                    LFP_mean = mean(Cb_snapshots(lfp_chan,:,:),3);
                                    %filter lfp
                                    LFP_filt = mean(Cb_filt(lfp_chan,:,:),3);
                                    %tally spikes across trials
                                    block_spike_times = [M1_spike_snapshots{s_chan,code,:}];
                                    block_spike_times = block_spike_times((block_spike_times > window_start*param.Cb_Fs) & (block_spike_times < window_end*param.Cb_Fs));
                                    %calc phase of lfp at each spike time
                                    hilbert_LFP = hilbert(LFP_filt);
                                    inst_phase = unwrap(angle(hilbert_LFP));%inst phase
                                    radial_phase = mod(inst_phase,2*pi);
                                    spike_phases = radial_phase(round(block_spike_times+1));
                                    %store data for comparison to other brain area equivalents
                                    save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan)),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phases', '.mat'],'spike_phases');
                                    %plot
                                    phase_hist = polarhistogram(spike_phases,12,'FaceColor', [.8 0 0], 'FaceAlpha', 1);
                                    saveas(phase_hist,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan)),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phase_histogram', '.fig'])
                                    close all;
                                    
                                    CbCh_M1Nrn_spike_phase{lfp_chan,s_chan,code} = [CbCh_M1Nrn_spike_phase{lfp_chan,s_chan,code} spike_phases];
                                    
                                    %temp code to make the rest of Lemke fig 3b
                                    if param.Cb_good_chans(lfp_chan) == 28 && s_chan == 16 && code == 2 && day == 5
                                        %disp('Here');
                                    end
                                end
                            end
                        end
                    end
                    neuron_idx = 0;
                    for s_chan = 1:param.Cb_chans
                        for code = 1:param.Cb_neurons
                            neuron_idx = neuron_idx + 1;
                            if ismember(neuron_idx,Cb_neurons_of_interest{day})
                                if ((length([Cb_spike_snapshots{s_chan,code,:}]) / size(Cb_spike_snapshots,3)) >= Cb_min_spikes) && (param.Cb_good_chans(lfp_chan) ~= (ceil(s_chan/4)*4)-3)
                                    %--do calc--
                                    %calc mean lfp across trials
                                    LFP_mean = mean(Cb_snapshots(lfp_chan,:,:),3);
                                    %filter lfp
                                    LFP_filt = mean(Cb_filt(lfp_chan,:,:),3);
                                    %tally spikes across trials
                                    block_spike_times = [Cb_spike_snapshots{s_chan,code,:}];
                                    block_spike_times = block_spike_times((block_spike_times > window_start*param.Cb_Fs) & (block_spike_times < window_end*param.Cb_Fs));
                                    %calc phase of lfp at each spike time
                                    hilbert_LFP = hilbert(LFP_filt);
                                    inst_phase = unwrap(angle(hilbert_LFP));%inst phase
                                    radial_phase = mod(inst_phase,2*pi);
                                    spike_phases = radial_phase(round(block_spike_times+1));
                                    %store data for comparison to other brain area equivalents
                                    save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan)),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phases', '.mat'],'spike_phases', 'radial_phase', 'LFP_filt');
                                    %plot
                                    phase_hist = polarhistogram(spike_phases,12,'FaceColor', [.8 0 0], 'FaceAlpha', 1);
                                    saveas(phase_hist,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan)),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phase_histogram', '.fig'])
                                    close all;
                                    
                                    CbCh_CbNrn_spike_phase{lfp_chan,s_chan,code} = [CbCh_CbNrn_spike_phase{lfp_chan,s_chan,code} spike_phases];
                                end
                            end
                        end
                    end
                end
            end
        end    
    
        for lfp_chan = 1:length(param.M1_good_chans)
            if ismember(param.M1_good_chans(lfp_chan),M1_channels_of_interest)
                neuron_idx = 0;
                M1_spikes_Zs = nan(param.M1_chans,param.M1_neurons);
                M1_spikes_Ps = nan(param.M1_chans,param.M1_neurons);
                Cb_spikes_Zs = nan(param.Cb_chans,param.Cb_neurons);
                Cb_spikes_Ps = nan(param.Cb_chans,param.Cb_neurons);
                for s_chan = 1:param.M1_chans
                    for code = 1:param.M1_neurons
                        neuron_idx = neuron_idx + 1;
                        if ismember(neuron_idx,M1_neurons_of_interest{day}) && ~isempty(M1Ch_M1Nrn_spike_phase{lfp_chan,s_chan,code})
                            [M1_spikes_Ps(s_chan,code),M1_spikes_Zs(s_chan,code)] = circ_rtest(M1Ch_M1Nrn_spike_phase{lfp_chan,s_chan,code});
                        end
                    end
                end
                neuron_idx = 0;
                for s_chan = 1:param.Cb_chans
                    for code = 1:param.Cb_neurons
                        neuron_idx = neuron_idx + 1;
                        if ismember(neuron_idx,Cb_neurons_of_interest{day}) && ~isempty(M1Ch_CbNrn_spike_phase{lfp_chan,s_chan,code})
                            [Cb_spikes_Ps(s_chan,code),Cb_spikes_Zs(s_chan,code)] = circ_rtest(M1Ch_CbNrn_spike_phase{lfp_chan,s_chan,code});
                        end
                    end
                end
                M1_spikes_Ps(isnan(M1_spikes_Ps)) = [];
                Cb_spikes_Ps(isnan(Cb_spikes_Ps)) = [];
                M1_spikes_Zs(isnan(M1_spikes_Zs)) = [];
                Cb_spikes_Zs(isnan(Cb_spikes_Zs)) = [];
                    
                M1Ch_M1Nrn_stats{day} = [M1_spikes_Zs; M1_spikes_Ps];
                M1Ch_CbNrn_stats{day} = [Cb_spikes_Zs; Cb_spikes_Ps];
            end
        end
        for lfp_chan = 1:length(param.Cb_good_chans)
            if ismember(param.Cb_good_chans(lfp_chan),Cb_channels_of_interest)
                neuron_idx = 0;
                M1_spikes_Zs = nan(param.M1_chans,param.M1_neurons);
                M1_spikes_Ps = nan(param.M1_chans,param.M1_neurons);
                Cb_spikes_Zs = nan(param.Cb_chans,param.Cb_neurons);
                Cb_spikes_Ps = nan(param.Cb_chans,param.Cb_neurons);
                for s_chan = 1:param.M1_chans
                    for code = 1:param.M1_neurons
                        neuron_idx = neuron_idx + 1;
                        if ismember(neuron_idx,M1_neurons_of_interest{day}) && ~isempty(CbCh_M1Nrn_spike_phase{lfp_chan,s_chan,code})
                            [M1_spikes_Ps(s_chan,code),M1_spikes_Zs(s_chan,code)] = circ_rtest(CbCh_M1Nrn_spike_phase{lfp_chan,s_chan,code});
                        end
                    end
                end
                neuron_idx = 0;
                for s_chan = 1:param.Cb_chans
                    for code = 1:param.Cb_neurons
                        neuron_idx = neuron_idx + 1;
                        if ismember(neuron_idx,Cb_neurons_of_interest{day}) && ~isempty(CbCh_CbNrn_spike_phase{lfp_chan,s_chan,code})
                            [Cb_spikes_Ps(s_chan,code),Cb_spikes_Zs(s_chan,code)] = circ_rtest(CbCh_CbNrn_spike_phase{lfp_chan,s_chan,code});
                        end
                    end
                end
                M1_spikes_Ps(isnan(M1_spikes_Ps)) = [];
                Cb_spikes_Ps(isnan(Cb_spikes_Ps)) = [];
                M1_spikes_Zs(isnan(M1_spikes_Zs)) = [];
                Cb_spikes_Zs(isnan(Cb_spikes_Zs)) = [];
                    
                CbCh_M1Nrn_stats{day} = [M1_spikes_Zs; M1_spikes_Ps];
                CbCh_CbNrn_stats{day} = [Cb_spikes_Zs; Cb_spikes_Ps];
            end
        end
    end
    
    load([rootpath,animal,'/Shared_Data.mat'])
    shared_data.spike_phase_data = cell(4,param.days);
    shared_data.spike_phase_data(1,:) = M1Ch_M1Nrn_stats;
    shared_data.spike_phase_data(2,:) = M1Ch_CbNrn_stats;
    shared_data.spike_phase_data(3,:) = CbCh_M1Nrn_stats;
    shared_data.spike_phase_data(4,:) = CbCh_CbNrn_stats;
    save([rootpath,animal,'/Shared_Data.mat'], 'shared_data')
    
    for day = 1:param.days
        
    end
    
    spike_Ps = M1Ch_M1Nrn_stats{1}(2,:);
    percent_sig_D1 = sum(spike_Ps <= 0.05)/length(spike_Ps);
    [z_counts, ~] = histcounts(M1Ch_M1Nrn_stats{1}(1,:),edges);
    cum_count = cumsum(z_counts);
    z_ratio_cum = cum_count/length(spike_Ps);
    bin_centers = edges(1:end-1) + 0.05;
    figure
    line(bin_centers,z_ratio_cum,'Color',[1 0.2 0.2]);
    
    
    spike_Ps = M1Ch_M1Nrn_stats{5}(2,:);
    percent_sig_D5 = sum(spike_Ps <= 0.05)/length(spike_Ps);
    [z_counts, ~] = histcounts(M1Ch_M1Nrn_stats{5}(1,:),edges);
    cum_count = cumsum(z_counts);
    z_ratio_cum = cum_count/length(spike_Ps);
    bin_centers = edges(1:end-1) + 0.05;
    line(bin_centers,z_ratio_cum,'Color',[0.8 0 0]);
    line([3 3], [0 1], 'Color', [0 0 0], 'LineStyle','--');
    title(['M1Ch-M1Nrn D1:',num2str(percent_sig_D1*100),'% D5:',num2str(percent_sig_D1*100),'%']);
    set(gca, 'XScale', 'log')
    saveas(gcf,[rootpath,animal,'/Phase_non-uniformity_cdf_M1Ch-M1Nrn', '.fig']);
    close all;
    
    spike_Ps = M1Ch_CbNrn_stats{1}(2,:);
    percent_sig_D1 = sum(spike_Ps <= 0.05)/length(spike_Ps);
    [z_counts, ~] = histcounts(M1Ch_CbNrn_stats{1}(1,:),edges);
    cum_count = cumsum(z_counts);
    z_ratio_cum = cum_count/length(spike_Ps);
    bin_centers = edges(1:end-1) + 0.05;
    figure
    line(bin_centers,z_ratio_cum,'Color',[1 0.2 0.2]);
    
    spike_Ps = M1Ch_CbNrn_stats{5}(2,:);
    percent_sig_D5 = sum(spike_Ps <= 0.05)/length(spike_Ps);
    [z_counts, ~] = histcounts(M1Ch_CbNrn_stats{5}(1,:),edges);
    cum_count = cumsum(z_counts);
    z_ratio_cum = cum_count/length(spike_Ps);
    bin_centers = edges(1:end-1) + 0.05;
    line(bin_centers,z_ratio_cum,'Color',[0.8 0 0]);
    line([3 3], [0 1], 'Color', [0 0 0], 'LineStyle','--');
    title(['M1Ch-CbNrn D1:',num2str(percent_sig_D1*100),'% D5:',num2str(percent_sig_D1*100),'%']);
    set(gca, 'XScale', 'log')
    saveas(gcf,[rootpath,animal,'/Phase_non-uniformity_cdf_M1Ch-CbNrn', '.fig']);
    close all;
    
    
    spike_Ps = CbCh_M1Nrn_stats{1}(2,:);
    percent_sig_D1 = sum(spike_Ps <= 0.05)/length(spike_Ps);
    [z_counts, ~] = histcounts(CbCh_M1Nrn_stats{1}(1,:),edges);
    cum_count = cumsum(z_counts);
    z_ratio_cum = cum_count/length(spike_Ps);
    bin_centers = edges(1:end-1) + 0.05;
    figure
    line(bin_centers,z_ratio_cum,'Color',[0.2 1 0.2]);
    
    spike_Ps = CbCh_M1Nrn_stats{5}(2,:);
    percent_sig_D5 = sum(spike_Ps <= 0.05)/length(spike_Ps);
    [z_counts, ~] = histcounts(CbCh_M1Nrn_stats{5}(1,:),edges);
    cum_count = cumsum(z_counts);
    z_ratio_cum = cum_count/length(spike_Ps);
    bin_centers = edges(1:end-1) + 0.05;
    line(bin_centers,z_ratio_cum,'Color',[0 0.8 0]);
    line([3 3], [0 1], 'Color', [0 0 0], 'LineStyle','--');
    title(['CbCh-M1Nrn D1:',num2str(percent_sig_D1*100),'% D5:',num2str(percent_sig_D5*100),'%']);
    set(gca, 'XScale', 'log')
    saveas(gcf,[rootpath,animal,'/Phase_non-uniformity_cdf_CbCh-M1Nrn', '.fig']);
    close all;
    
    
    spike_Ps = CbCh_CbNrn_stats{1}(2,:);
    percent_sig_D1 = sum(spike_Ps <= 0.05)/length(spike_Ps);
    [z_counts, ~] = histcounts(CbCh_CbNrn_stats{1}(1,:),edges);
    cum_count = cumsum(z_counts);
    z_ratio_cum = cum_count/length(spike_Ps);
    bin_centers = edges(1:end-1) + 0.05;
    figure
    line(bin_centers,z_ratio_cum,'Color',[0.2 1 0.2]);
    
    spike_Ps = CbCh_CbNrn_stats{5}(2,:);
    percent_sig_D5 = sum(spike_Ps <= 0.05)/length(spike_Ps);
    [z_counts, ~] = histcounts(CbCh_CbNrn_stats{5}(1,:),edges);
    cum_count = cumsum(z_counts);
    z_ratio_cum = cum_count/length(spike_Ps);
    bin_centers = edges(1:end-1) + 0.05;
    line(bin_centers,z_ratio_cum,'Color',[0 0.8 0]);
    line([3 3], [0 1], 'Color', [0 0 0], 'LineStyle','--');
    title(['CbCh-CbNrn D1:',num2str(percent_sig_D1*100),'% D5:',num2str(percent_sig_D5*100),'%']);
    set(gca, 'XScale', 'log')
    saveas(gcf,[rootpath,animal,'/Phase_non-uniformity_cdf_CbCh-CbNrn', '.fig']);
    close all;

    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
    rmpath('Z:\Matlab for analysis\circStat2008\sis_data\matlab code\nhp data\MATLAB files\circStat2008');
end

%% Spike Occurence to Filtered LFP Phase (40)

if enabled(40)
    disp('Block 40...')
    addpath('Z:\Matlab for analysis\circStat2008\sis_data\matlab code\nhp data\MATLAB files\circStat2008');
    
    edge_exp = -5:0.1:5;
    edges = exp(edge_exp);
    bin_centers = edges(1:end-1) + diff(edges)/2;
    window_start = 3.75;
    window_end = 4.75;
    
    %Notes: I086, M1: 16 has even better S vs F but bad D1 vs D5
    M1_channels_of_interest = [9]; %   I060: 6 I076: 15 I061: 29 I064: 28 I086: 9  I089: 2, 26 I096: 7 9 32  I107: 20 (maybe 18 or 22)                           110: N/A        122: 5
    Cb_channels_of_interest = [57]; %  I060: 7 I076: 23 I061: 20 I064: 17 I086: 57 I089: 7     I096: 55      I107: 28, 45 (and many others with smaller effects) 110: 38, 36, 41 122: 20
    if isinf(M1_channels_of_interest)
        M1_channels_of_interest = 1:param.M1_chans;
    end
    if isinf(Cb_channels_of_interest)
        Cb_channels_of_interest = 1:param.Cb_chans;
    end
    M1_channels_of_interest = find(ismember(param.M1_good_chans, M1_channels_of_interest));
    Cb_channels_of_interest = find(ismember(param.Cb_good_chans, Cb_channels_of_interest));
    
    M1_neurons_of_interest = param.M1_task_related_neurons;
    Cb_neurons_of_interest = param.Cb_task_related_neurons;
    if isempty(M1_neurons_of_interest)
        M1_neurons_of_interest = {ones(param.M1_chans,param.M1_neurons), ones(param.M1_chans,param.M1_neurons), ones(param.M1_chans,param.M1_neurons), ones(param.M1_chans,param.M1_neurons), ones(param.M1_chans,param.M1_neurons)};
    end
    if isempty(Cb_neurons_of_interest)
        Cb_neurons_of_interest = {ones(param.Cb_chans,param.Cb_neurons), ones(param.Cb_chans,param.Cb_neurons), ones(param.Cb_chans,param.Cb_neurons), ones(param.Cb_chans,param.Cb_neurons), ones(param.Cb_chans,param.Cb_neurons)};
    end
        
    M1_min_spikes = 8;
    Cb_min_spikes = 4;
    
    spike_phase_stats = struct;
    spike_phase_stats.M1_chans = M1_channels_of_interest;
    spike_phase_stats.Cb_chans = Cb_channels_of_interest;
    spike_phase_stats.M1Ch_M1Nrn_stats = cell(1,param.days);
    spike_phase_stats.M1Ch_CbNrn_stats = cell(1,param.days);
    spike_phase_stats.CbCh_M1Nrn_stats = cell(1,param.days);
    spike_phase_stats.CbCh_CbNrn_stats = cell(1,param.days);
    spike_phase_stats.M1Ch_M1Nrn_stats_succ = cell(1,param.days);
    spike_phase_stats.M1Ch_CbNrn_stats_succ = cell(1,param.days);
    spike_phase_stats.CbCh_M1Nrn_stats_succ = cell(1,param.days);
    spike_phase_stats.CbCh_CbNrn_stats_succ = cell(1,param.days);
    spike_phase_stats.M1Ch_M1Nrn_stats_fail = cell(1,param.days);
    spike_phase_stats.M1Ch_CbNrn_stats_fail = cell(1,param.days);
    spike_phase_stats.CbCh_M1Nrn_stats_fail = cell(1,param.days);
    spike_phase_stats.CbCh_CbNrn_stats_fail = cell(1,param.days);
    
    for day=1:param.days
        M1Ch_M1Nrn_spike_phase = cell(length(M1_channels_of_interest),param.M1_chans,param.M1_neurons);
        M1Ch_CbNrn_spike_phase = cell(length(M1_channels_of_interest),param.Cb_chans,param.Cb_neurons);
        CbCh_M1Nrn_spike_phase = cell(length(Cb_channels_of_interest),param.M1_chans,param.M1_neurons);
        CbCh_CbNrn_spike_phase = cell(length(Cb_channels_of_interest),param.Cb_chans,param.Cb_neurons);
        M1Ch_M1Nrn_spike_phase_succ = cell(length(M1_channels_of_interest),param.M1_chans,param.M1_neurons);
        M1Ch_CbNrn_spike_phase_succ = cell(length(M1_channels_of_interest),param.Cb_chans,param.Cb_neurons);
        CbCh_M1Nrn_spike_phase_succ = cell(length(Cb_channels_of_interest),param.M1_chans,param.M1_neurons);
        CbCh_CbNrn_spike_phase_succ = cell(length(Cb_channels_of_interest),param.Cb_chans,param.Cb_neurons);
        M1Ch_M1Nrn_spike_phase_fail = cell(length(M1_channels_of_interest),param.M1_chans,param.M1_neurons);
        M1Ch_CbNrn_spike_phase_fail = cell(length(M1_channels_of_interest),param.Cb_chans,param.Cb_neurons);
        CbCh_M1Nrn_spike_phase_fail = cell(length(Cb_channels_of_interest),param.M1_chans,param.M1_neurons);
        CbCh_CbNrn_spike_phase_fail = cell(length(Cb_channels_of_interest),param.Cb_chans,param.Cb_neurons);
        for block=1:param.blocks
            if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data'],'dir')
                mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data']);
            end
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Normalized_Snapshots', '.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Filtered_LFP_Snapshots.mat']); %M1_1_4_snapshots
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/spiketrain_snapshots_full.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/neuron_firing_rates.mat']);
            
            trial_codes = str2double(data(:,3));
            no_reach_trials = (1:size(data,1));
            no_reach_trials = no_reach_trials(trial_codes>1);
            
            all_bad_trials = union(M1_bad_trials, Cb_bad_trials);
            trial_codes(union(no_reach_trials, all_bad_trials)) = [];
            [M1_snapshots, Cb_snapshots] = get_common_good_data(M1_snapshots, Cb_snapshots, M1_bad_trials, Cb_bad_trials, 3);
            [M1_spike_snapshots, ~] = get_common_good_data(M1_spike_snapshots_full, M1_snapshots, no_reach_trials, all_bad_trials, 3);
            [Cb_spike_snapshots, ~] = get_common_good_data(Cb_spike_snapshots_full, Cb_snapshots, no_reach_trials, all_bad_trials, 3);
            [M1_filt, Cb_filt] = get_common_good_data(M1_1_4_snapshots, Cb_1_4_snapshots, M1_bad_trials, Cb_bad_trials, 3);
            
            num_trials = size(M1_spike_snapshots,3);
            
            for lfp_chan = 1:length(M1_channels_of_interest)
                if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(M1_channels_of_interest(lfp_chan)))],'dir')
                    mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(M1_channels_of_interest(lfp_chan)))]);
                end
                for s_chan = 1:param.M1_chans
                    for code = 1:param.M1_neurons
                        if M1_neurons_of_interest{day}(s_chan,code)
                            if ((length([M1_spike_snapshots{s_chan,code,:}]) / size(M1_spike_snapshots,3)) >= M1_min_spikes)
                                spike_phases = nan(1,0);
                                spike_phases_succ = nan(1,0);
                                spike_phases_fail = nan(1,0);
                                all_phases = nan(1,0);
                                all_phases_succ = nan(1,0);
                                all_phases_fail = nan(1,0);
                                spike_num_idx = 1;
                                for trial = 1:num_trials
                                    M1_spike_snapshots{s_chan,code,trial}(M1_spike_snapshots{s_chan,code,trial}<(window_start*param.M1_Fs)) = [];
                                    M1_spike_snapshots{s_chan,code,trial}(M1_spike_snapshots{s_chan,code,trial}>(window_end*param.M1_Fs)) = [];
                                    %calc phase of lfp
                                    hilbert_LFP = hilbert(M1_filt(M1_channels_of_interest(lfp_chan),:,trial));
                                    inst_phase = unwrap(angle(hilbert_LFP));%inst phase
                                    radial_phase = mod(inst_phase,2*pi);
                                    %get phase of lfp at each spike time
                                    spike_phases = [spike_phases, radial_phase(round(M1_spike_snapshots{s_chan,code,trial}+1))]; %#ok<AGROW>
                                    all_phases = [all_phases, radial_phase]; %#ok<AGROW>
                                    spike_num_idx = spike_num_idx+length(M1_spike_snapshots{s_chan,code,trial});
                                    if trial_codes(trial) == 0
                                        spike_phases_fail = [spike_phases_fail, radial_phase(round(M1_spike_snapshots{s_chan,code,trial}+1))]; %#ok<AGROW>
                                        all_phases_fail = [all_phases_fail, radial_phase]; %#ok<AGROW>
                                    else
                                        spike_phases_succ = [spike_phases_succ, radial_phase(round(M1_spike_snapshots{s_chan,code,trial}+1))]; %#ok<AGROW>
                                        all_phases_succ = [all_phases_succ, radial_phase]; %#ok<AGROW>
                                    end
                                end
                                %store data for comparison to other brain area equivalents
                                save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(M1_channels_of_interest(lfp_chan))),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phases', '.mat'], 'spike_phases', 'spike_phases_fail', 'spike_phases_succ', 'all_phases', 'all_phases_fail', 'all_phases_succ');
                                %plot
                                phase_hist = polarhistogram(spike_phases,12,'FaceColor', [.8 0 0], 'FaceAlpha', 1);
                                saveas(phase_hist,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(M1_channels_of_interest(lfp_chan))),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phase_histogram', '.fig'])
                                close all;
                                
                                M1Ch_M1Nrn_spike_phase{lfp_chan,s_chan,code} = [M1Ch_M1Nrn_spike_phase{lfp_chan,s_chan,code} spike_phases];
                                M1Ch_M1Nrn_spike_phase_succ{lfp_chan,s_chan,code} = [M1Ch_M1Nrn_spike_phase_succ{lfp_chan,s_chan,code} spike_phases_succ];
                                M1Ch_M1Nrn_spike_phase_fail{lfp_chan,s_chan,code} = [M1Ch_M1Nrn_spike_phase_fail{lfp_chan,s_chan,code} spike_phases_fail];
                            end
                        end
                    end
                end
                for s_chan = 1:param.Cb_chans
                    for code = 1:param.Cb_neurons
                        if Cb_neurons_of_interest{day}(s_chan,code)
                            if (length([Cb_spike_snapshots{s_chan,code,:}]) / size(Cb_spike_snapshots,3)) >= Cb_min_spikes
                                spike_phases = nan(1,0);
                                spike_phases_succ = nan(1,0);
                                spike_phases_fail = nan(1,0);
                                all_phases = nan(1,0);
                                all_phases_succ = nan(1,0);
                                all_phases_fail = nan(1,0);
                                spike_num_idx = 1;
                                for trial = 1:num_trials
                                    Cb_spike_snapshots{s_chan,code,trial}(Cb_spike_snapshots{s_chan,code,trial}<(window_start*param.Cb_Fs)) = [];
                                    Cb_spike_snapshots{s_chan,code,trial}(Cb_spike_snapshots{s_chan,code,trial}>(window_end*param.Cb_Fs)) = [];
                                    %calc phase of lfp
                                    hilbert_LFP = hilbert(M1_filt(M1_channels_of_interest(lfp_chan),:,trial));
                                    inst_phase = unwrap(angle(hilbert_LFP));%inst phase
                                    radial_phase = mod(inst_phase,2*pi);
                                    %get phase of lfp at each spike time
                                    spike_phases = [spike_phases, radial_phase(round(Cb_spike_snapshots{s_chan,code,trial}+1))]; %#ok<AGROW>
                                    all_phases = [all_phases, radial_phase]; %#ok<AGROW>
                                    spike_num_idx = spike_num_idx+length(Cb_spike_snapshots{s_chan,code,trial});
                                    if trial_codes(trial) == 0
                                        spike_phases_fail = [spike_phases_fail, radial_phase(round(Cb_spike_snapshots{s_chan,code,trial}+1))]; %#ok<AGROW>
                                        all_phases_fail = [all_phases_fail, radial_phase]; %#ok<AGROW>
                                    else
                                        spike_phases_succ = [spike_phases_succ, radial_phase(round(Cb_spike_snapshots{s_chan,code,trial}+1))]; %#ok<AGROW>
                                        all_phases_succ = [all_phases_succ, radial_phase]; %#ok<AGROW>
                                    end
                                end
                                %store data for comparison to other brain area equivalents
                                save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(M1_channels_of_interest(lfp_chan))),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phases', '.mat'], 'spike_phases', 'spike_phases_fail', 'spike_phases_succ', 'all_phases', 'all_phases_fail', 'all_phases_succ');
                                %plot
                                phase_hist = polarhistogram(spike_phases,12,'FaceColor', [.8 0 0], 'FaceAlpha', 1);
                                saveas(phase_hist,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(M1_channels_of_interest(lfp_chan))),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phase_histogram', '.fig'])
                                close all;
                                
                                M1Ch_CbNrn_spike_phase{lfp_chan,s_chan,code} = [M1Ch_CbNrn_spike_phase{lfp_chan,s_chan,code} spike_phases];
                                M1Ch_CbNrn_spike_phase_succ{lfp_chan,s_chan,code} = [M1Ch_CbNrn_spike_phase_succ{lfp_chan,s_chan,code} spike_phases_succ];
                                M1Ch_CbNrn_spike_phase_fail{lfp_chan,s_chan,code} = [M1Ch_CbNrn_spike_phase_fail{lfp_chan,s_chan,code} spike_phases_fail];
                            end
                        end
                    end
                end
                mean_filt = mean(M1_filt(M1_channels_of_interest(lfp_chan),:,:),3);
                x = -4000:8000/(length(mean_filt)-1):4000;
                %x = 1:length(mean_filt);
                %x = x - (4 * param.M1_Fs);
                plot(x,mean_filt)
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Ch', num2str(param.M1_good_chans(M1_channels_of_interest(lfp_chan))), '_mean_filtered_LFP.fig'])
                close all
                
                hilbert_LFP = hilbert(mean_filt);
                inst_phase = unwrap(angle(hilbert_LFP));%inst phase
                radial_phase = mod(inst_phase,2*pi);
                plot(x,radial_phase)
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Ch', num2str(param.M1_good_chans(M1_channels_of_interest(lfp_chan))), '_mean_filtered_LFP_phase.fig'])
                close all
            end
            
            for lfp_chan = 1:length(Cb_channels_of_interest)
                if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(Cb_channels_of_interest(lfp_chan)))],'dir')
                    mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(Cb_channels_of_interest(lfp_chan)))]);
                end
                for s_chan = 1:param.M1_chans
                    for code = 1:param.M1_neurons
                        if M1_neurons_of_interest{day}(s_chan,code)
                            if (length([M1_spike_snapshots{s_chan,code,:}]) / size(M1_spike_snapshots,3)) >= M1_min_spikes
                                spike_phases = nan(1,0);
                                spike_phases_succ = nan(1,0);
                                spike_phases_fail = nan(1,0);
                                all_phases = nan(1,0);
                                all_phases_succ = nan(1,0);
                                all_phases_fail = nan(1,0);
                                spike_num_idx = 1;
                                for trial = 1:num_trials
                                    M1_spike_snapshots{s_chan,code,trial}(M1_spike_snapshots{s_chan,code,trial}<(window_start*param.M1_Fs)) = [];
                                    M1_spike_snapshots{s_chan,code,trial}(M1_spike_snapshots{s_chan,code,trial}>(window_end*param.M1_Fs)) = [];
                                    %calc phase of lfp
                                    hilbert_LFP = hilbert(Cb_filt(Cb_channels_of_interest(lfp_chan),:,trial));
                                    inst_phase = unwrap(angle(hilbert_LFP));%inst phase
                                    radial_phase = mod(inst_phase,2*pi);
                                    %get phase of lfp at each spike time
                                    spike_phases = [spike_phases, radial_phase(round(M1_spike_snapshots{s_chan,code,trial}+1))]; %#ok<AGROW>
                                    all_phases = [all_phases, radial_phase]; %#ok<AGROW>
                                    spike_num_idx = spike_num_idx+length(M1_spike_snapshots{s_chan,code,trial});
                                    if trial_codes(trial) == 0
                                        spike_phases_fail = [spike_phases_fail, radial_phase(round(M1_spike_snapshots{s_chan,code,trial}+1))]; %#ok<AGROW>
                                        all_phases_fail = [all_phases_fail, radial_phase]; %#ok<AGROW>
                                    else
                                        spike_phases_succ = [spike_phases_succ, radial_phase(round(M1_spike_snapshots{s_chan,code,trial}+1))]; %#ok<AGROW>
                                        all_phases_succ = [all_phases_succ, radial_phase]; %#ok<AGROW>
                                    end
                                end
                                %store data for comparison to other brain area equivalents
                                save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(Cb_channels_of_interest(lfp_chan))),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phases', '.mat'], 'spike_phases', 'spike_phases_fail', 'spike_phases_succ', 'all_phases', 'all_phases_fail', 'all_phases_succ');
                                %plot
                                phase_hist = polarhistogram(spike_phases,12,'FaceColor', [.8 0 0], 'FaceAlpha', 1);
                                saveas(phase_hist,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(Cb_channels_of_interest(lfp_chan))),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phase_histogram', '.fig'])
                                close all;
                                
                                CbCh_M1Nrn_spike_phase{lfp_chan,s_chan,code} = [CbCh_M1Nrn_spike_phase{lfp_chan,s_chan,code} spike_phases];
                                CbCh_M1Nrn_spike_phase_succ{lfp_chan,s_chan,code} = [CbCh_M1Nrn_spike_phase_succ{lfp_chan,s_chan,code} spike_phases_succ];
                                CbCh_M1Nrn_spike_phase_fail{lfp_chan,s_chan,code} = [CbCh_M1Nrn_spike_phase_fail{lfp_chan,s_chan,code} spike_phases_fail];
                            end
                        end
                    end
                end
                for s_chan = 1:param.Cb_chans
                    for code = 1:param.Cb_neurons
                        if Cb_neurons_of_interest{day}(s_chan,code)
                            if ((length([Cb_spike_snapshots{s_chan,code,:}]) / size(Cb_spike_snapshots,3)) >= Cb_min_spikes) && (Cb_channels_of_interest(lfp_chan) ~= (ceil(s_chan/4)*4)-3)
                                spike_phases = nan(1,0);
                                spike_phases_succ = nan(1,0);
                                spike_phases_fail = nan(1,0);
                                all_phases = nan(1,0);
                                all_phases_succ = nan(1,0);
                                all_phases_fail = nan(1,0);
                                spike_num_idx = 1;
                                for trial = 1:num_trials
                                    Cb_spike_snapshots{s_chan,code,trial}(Cb_spike_snapshots{s_chan,code,trial}<(window_start*param.Cb_Fs)) = [];
                                    Cb_spike_snapshots{s_chan,code,trial}(Cb_spike_snapshots{s_chan,code,trial}>(window_end*param.Cb_Fs)) = [];
                                    %calc phase of lfp
                                    hilbert_LFP = hilbert(Cb_filt(Cb_channels_of_interest(lfp_chan),:,trial));
                                    inst_phase = unwrap(angle(hilbert_LFP));%inst phase
                                    radial_phase = mod(inst_phase,2*pi);
                                    %get phase of lfp at each spike time
                                    spike_phases = [spike_phases, radial_phase(round(Cb_spike_snapshots{s_chan,code,trial}+1))]; %#ok<AGROW>
                                    all_phases = [all_phases, radial_phase]; %#ok<AGROW>
                                    spike_num_idx = spike_num_idx+length(Cb_spike_snapshots{s_chan,code,trial});
                                    if trial_codes(trial) == 0
                                        spike_phases_fail = [spike_phases_fail, radial_phase(round(Cb_spike_snapshots{s_chan,code,trial}+1))]; %#ok<AGROW>
                                        all_phases_fail = [all_phases_fail, radial_phase]; %#ok<AGROW>
                                    else
                                        spike_phases_succ = [spike_phases_succ, radial_phase(round(Cb_spike_snapshots{s_chan,code,trial}+1))]; %#ok<AGROW>
                                        all_phases_succ = [all_phases_succ, radial_phase]; %#ok<AGROW>
                                    end
                                end
                                %store data for comparison to other brain area equivalents
                                save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(Cb_channels_of_interest(lfp_chan))),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phases', '.mat'], 'spike_phases', 'spike_phases_fail', 'spike_phases_succ', 'all_phases', 'all_phases_fail', 'all_phases_succ');
                                %plot
                                phase_hist = polarhistogram(spike_phases,12,'FaceColor', [.8 0 0], 'FaceAlpha', 1);
                                saveas(phase_hist,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(Cb_channels_of_interest(lfp_chan))),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phase_histogram', '.fig'])
                                close all;
                                
                                CbCh_CbNrn_spike_phase{lfp_chan,s_chan,code} = [CbCh_CbNrn_spike_phase{lfp_chan,s_chan,code} spike_phases];
                                CbCh_CbNrn_spike_phase_succ{lfp_chan,s_chan,code} = [CbCh_CbNrn_spike_phase_succ{lfp_chan,s_chan,code} spike_phases_succ];
                                CbCh_CbNrn_spike_phase_fail{lfp_chan,s_chan,code} = [CbCh_CbNrn_spike_phase_fail{lfp_chan,s_chan,code} spike_phases_fail];
                            end
                        end
                    end
                end
                mean_filt = mean(Cb_filt(Cb_channels_of_interest(lfp_chan),:,:),3);
                x = -4000:8000/(length(mean_filt)-1):4000;
                %x = 1:length(mean_filt);
                %x = x - (4 * param.M1_Fs);;
                plot(x,mean_filt)
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Ch', num2str(param.Cb_good_chans(Cb_channels_of_interest(lfp_chan))), '_mean_filtered_LFP.fig'])
                close all
                
                hilbert_LFP = hilbert(mean_filt);
                inst_phase = unwrap(angle(hilbert_LFP));%inst phase
                radial_phase = mod(inst_phase,2*pi);
                plot(x,radial_phase)
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Ch', num2str(param.Cb_good_chans(Cb_channels_of_interest(lfp_chan))), '_mean_filtered_LFP_phase.fig'])
                close all
            end
        end    
    
        for lfp_chan = 1:length(M1_channels_of_interest)
            neuron_idx = 0;
            M1_spikes_Zs = nan(param.M1_chans,param.M1_neurons);
            M1_spikes_Ps = nan(param.M1_chans,param.M1_neurons);
            Cb_spikes_Zs = nan(param.Cb_chans,param.Cb_neurons);
            Cb_spikes_Ps = nan(param.Cb_chans,param.Cb_neurons);
            M1_spikes_Zs_succ = nan(param.M1_chans,param.M1_neurons);
            M1_spikes_Ps_succ = nan(param.M1_chans,param.M1_neurons);
            Cb_spikes_Zs_succ = nan(param.Cb_chans,param.Cb_neurons);
            Cb_spikes_Ps_succ = nan(param.Cb_chans,param.Cb_neurons);
            M1_spikes_Zs_fail = nan(param.M1_chans,param.M1_neurons);
            M1_spikes_Ps_fail = nan(param.M1_chans,param.M1_neurons);
            Cb_spikes_Zs_fail = nan(param.Cb_chans,param.Cb_neurons);
            Cb_spikes_Ps_fail = nan(param.Cb_chans,param.Cb_neurons);
            for s_chan = 1:param.M1_chans
                for code = 1:param.M1_neurons
                    neuron_idx = neuron_idx + 1;
                    if ~isempty(M1Ch_M1Nrn_spike_phase{lfp_chan,s_chan,code})
                        [M1_spikes_Ps(s_chan,code),M1_spikes_Zs(s_chan,code)] = circ_rtest(M1Ch_M1Nrn_spike_phase{lfp_chan,s_chan,code});
                    end
                    if ~isempty(M1Ch_M1Nrn_spike_phase_succ{lfp_chan,s_chan,code})
                        [M1_spikes_Ps_succ(s_chan,code),M1_spikes_Zs_succ(s_chan,code)] = circ_rtest(M1Ch_M1Nrn_spike_phase_succ{lfp_chan,s_chan,code});
                    end
                    if ~isempty(M1Ch_M1Nrn_spike_phase_fail{lfp_chan,s_chan,code})
                        [M1_spikes_Ps_fail(s_chan,code),M1_spikes_Zs_fail(s_chan,code)] = circ_rtest(M1Ch_M1Nrn_spike_phase_fail{lfp_chan,s_chan,code});
                    end
                end
            end
            neuron_idx = 0;
            for s_chan = 1:param.Cb_chans
                for code = 1:param.Cb_neurons
                    neuron_idx = neuron_idx + 1;
                    if ~isempty(M1Ch_CbNrn_spike_phase{lfp_chan,s_chan,code})
                        [Cb_spikes_Ps(s_chan,code),Cb_spikes_Zs(s_chan,code)] = circ_rtest(M1Ch_CbNrn_spike_phase{lfp_chan,s_chan,code});
                    end
                    if ~isempty(M1Ch_CbNrn_spike_phase_succ{lfp_chan,s_chan,code})
                        [Cb_spikes_Ps_succ(s_chan,code),Cb_spikes_Zs_succ(s_chan,code)] = circ_rtest(M1Ch_CbNrn_spike_phase_succ{lfp_chan,s_chan,code});
                    end
                    if ~isempty(M1Ch_CbNrn_spike_phase_fail{lfp_chan,s_chan,code})
                        [Cb_spikes_Ps_fail(s_chan,code),Cb_spikes_Zs_fail(s_chan,code)] = circ_rtest(M1Ch_CbNrn_spike_phase_fail{lfp_chan,s_chan,code});
                    end
                end
            end
            M1_spikes_Ps(isnan(M1_spikes_Ps)) = [];
            Cb_spikes_Ps(isnan(Cb_spikes_Ps)) = [];
            M1_spikes_Zs(isnan(M1_spikes_Zs)) = [];
            Cb_spikes_Zs(isnan(Cb_spikes_Zs)) = [];
            M1_spikes_Ps_succ(isnan(M1_spikes_Ps_succ)) = [];
            Cb_spikes_Ps_succ(isnan(Cb_spikes_Ps_succ)) = [];
            M1_spikes_Zs_succ(isnan(M1_spikes_Zs_succ)) = [];
            Cb_spikes_Zs_succ(isnan(Cb_spikes_Zs_succ)) = [];
            M1_spikes_Ps_fail(isnan(M1_spikes_Ps_fail)) = [];
            Cb_spikes_Ps_fail(isnan(Cb_spikes_Ps_fail)) = [];
            M1_spikes_Zs_fail(isnan(M1_spikes_Zs_fail)) = [];
            Cb_spikes_Zs_fail(isnan(Cb_spikes_Zs_fail)) = [];
            
            spike_phase_stats.M1Ch_M1Nrn_stats{day} = [(M1_spikes_Zs(:)'); (M1_spikes_Ps(:)')];
            spike_phase_stats.M1Ch_CbNrn_stats{day} = [(Cb_spikes_Zs(:)'); (Cb_spikes_Ps(:)')];
            spike_phase_stats.M1Ch_M1Nrn_stats_succ{day} = [(M1_spikes_Zs_succ(:)'); (M1_spikes_Ps_succ(:)')];
            spike_phase_stats.M1Ch_CbNrn_stats_succ{day} = [(Cb_spikes_Zs_succ(:)'); (Cb_spikes_Ps_succ(:)')];
            spike_phase_stats.M1Ch_M1Nrn_stats_fail{day} = [(M1_spikes_Zs_fail(:)'); (M1_spikes_Ps_fail(:)')];
            spike_phase_stats.M1Ch_CbNrn_stats_fail{day} = [(Cb_spikes_Zs_fail(:)'); (Cb_spikes_Ps_fail(:)')];
        end
        for lfp_chan = 1:length(Cb_channels_of_interest)
            neuron_idx = 0;
            M1_spikes_Zs = nan(param.M1_chans,param.M1_neurons);
            M1_spikes_Ps = nan(param.M1_chans,param.M1_neurons);
            Cb_spikes_Zs = nan(param.Cb_chans,param.Cb_neurons);
            Cb_spikes_Ps = nan(param.Cb_chans,param.Cb_neurons);
            M1_spikes_Zs_succ = nan(param.M1_chans,param.M1_neurons);
            M1_spikes_Ps_succ = nan(param.M1_chans,param.M1_neurons);
            Cb_spikes_Zs_succ = nan(param.Cb_chans,param.Cb_neurons);
            Cb_spikes_Ps_succ = nan(param.Cb_chans,param.Cb_neurons);
            M1_spikes_Zs_fail = nan(param.M1_chans,param.M1_neurons);
            M1_spikes_Ps_fail = nan(param.M1_chans,param.M1_neurons);
            Cb_spikes_Zs_fail = nan(param.Cb_chans,param.Cb_neurons);
            Cb_spikes_Ps_fail = nan(param.Cb_chans,param.Cb_neurons);
            for s_chan = 1:param.M1_chans
                for code = 1:param.M1_neurons
                    neuron_idx = neuron_idx + 1;
                    if ~isempty(CbCh_M1Nrn_spike_phase{lfp_chan,s_chan,code})
                        [M1_spikes_Ps(s_chan,code),M1_spikes_Zs(s_chan,code)] = circ_rtest(CbCh_M1Nrn_spike_phase{lfp_chan,s_chan,code});
                    end
                    if ~isempty(CbCh_M1Nrn_spike_phase_succ{lfp_chan,s_chan,code})
                        [M1_spikes_Ps_succ(s_chan,code),M1_spikes_Zs_succ(s_chan,code)] = circ_rtest(CbCh_M1Nrn_spike_phase_succ{lfp_chan,s_chan,code});
                    end
                    if ~isempty(CbCh_M1Nrn_spike_phase_fail{lfp_chan,s_chan,code})
                        [M1_spikes_Ps_fail(s_chan,code),M1_spikes_Zs_fail(s_chan,code)] = circ_rtest(CbCh_M1Nrn_spike_phase_fail{lfp_chan,s_chan,code});
                    end
                end
            end
            neuron_idx = 0;
            for s_chan = 1:param.Cb_chans
                for code = 1:param.Cb_neurons
                    neuron_idx = neuron_idx + 1;
                    if ~isempty(CbCh_CbNrn_spike_phase{lfp_chan,s_chan,code})
                        [Cb_spikes_Ps(s_chan,code),Cb_spikes_Zs(s_chan,code)] = circ_rtest(CbCh_CbNrn_spike_phase{lfp_chan,s_chan,code});
                    end
                    if ~isempty(CbCh_CbNrn_spike_phase_succ{lfp_chan,s_chan,code})
                        [Cb_spikes_Ps_succ(s_chan,code),Cb_spikes_Zs_succ(s_chan,code)] = circ_rtest(CbCh_CbNrn_spike_phase_succ{lfp_chan,s_chan,code});
                    end
                    if ~isempty(CbCh_CbNrn_spike_phase_fail{lfp_chan,s_chan,code})
                        [Cb_spikes_Ps_fail(s_chan,code),Cb_spikes_Zs_fail(s_chan,code)] = circ_rtest(CbCh_CbNrn_spike_phase_fail{lfp_chan,s_chan,code});
                    end
                end
            end
            M1_spikes_Ps(isnan(M1_spikes_Ps)) = [];
            Cb_spikes_Ps(isnan(Cb_spikes_Ps)) = [];
            M1_spikes_Zs(isnan(M1_spikes_Zs)) = [];
            Cb_spikes_Zs(isnan(Cb_spikes_Zs)) = [];
            M1_spikes_Ps_succ(isnan(M1_spikes_Ps_succ)) = [];
            Cb_spikes_Ps_succ(isnan(Cb_spikes_Ps_succ)) = [];
            M1_spikes_Zs_succ(isnan(M1_spikes_Zs_succ)) = [];
            Cb_spikes_Zs_succ(isnan(Cb_spikes_Zs_succ)) = [];
            M1_spikes_Ps_fail(isnan(M1_spikes_Ps_fail)) = [];
            Cb_spikes_Ps_fail(isnan(Cb_spikes_Ps_fail)) = [];
            M1_spikes_Zs_fail(isnan(M1_spikes_Zs_fail)) = [];
            Cb_spikes_Zs_fail(isnan(Cb_spikes_Zs_fail)) = [];
            
            spike_phase_stats.CbCh_M1Nrn_stats{day} = [(M1_spikes_Zs(:)'); (M1_spikes_Ps(:)')];
            spike_phase_stats.CbCh_CbNrn_stats{day} = [(Cb_spikes_Zs(:)'); (Cb_spikes_Ps(:)')];
            spike_phase_stats.CbCh_M1Nrn_stats_succ{day} = [(M1_spikes_Zs_succ(:)'); (M1_spikes_Ps_succ(:)')];
            spike_phase_stats.CbCh_CbNrn_stats_succ{day} = [(Cb_spikes_Zs_succ(:)'); (Cb_spikes_Ps_succ(:)')];
            spike_phase_stats.CbCh_M1Nrn_stats_fail{day} = [(M1_spikes_Zs_fail(:)'); (M1_spikes_Ps_fail(:)')];
            spike_phase_stats.CbCh_CbNrn_stats_fail{day} = [(Cb_spikes_Zs_fail(:)'); (Cb_spikes_Ps_fail(:)')];
        end
    end
    
    load([rootpath,animal,'/Shared_Data.mat'])
    shared_data.spike_phase_data = spike_phase_stats;
    save([rootpath,animal,'/Shared_Data.mat'], 'shared_data')
    
    for day = 1:param.days
        if ~isempty(spike_phase_stats.M1Ch_M1Nrn_stats_fail{day})
            spike_Ps = spike_phase_stats.M1Ch_M1Nrn_stats_fail{day}(2,:);
            percent_sig_D1 = sum(spike_Ps <= 0.05)/length(spike_Ps);
            fail_Zs = spike_phase_stats.M1Ch_M1Nrn_stats_fail{day}(1,:);
            [z_counts, ~] = histcounts(fail_Zs,edges);
            cum_count = cumsum(z_counts);
            z_ratio_cum = cum_count/length(spike_Ps);
            figure
            line(bin_centers,z_ratio_cum,'Color',[1 0.2 0.2]);
            
            spike_Ps = spike_phase_stats.M1Ch_M1Nrn_stats_succ{day}(2,:);
            percent_sig_D5 = sum(spike_Ps <= 0.05)/length(spike_Ps);
            succ_Zs = spike_phase_stats.M1Ch_M1Nrn_stats_succ{day}(1,:);
            [z_counts, ~] = histcounts(succ_Zs,edges);
            cum_count = cumsum(z_counts);
            z_ratio_cum = cum_count/length(spike_Ps);
            if isempty(succ_Zs) || isempty(fail_Zs)
                p_score = nan;
            else
                [~, p_score] = kstest2(succ_Zs, fail_Zs);
            end
            line(bin_centers,z_ratio_cum,'Color',[0.8 0 0]);
            line([3 3], [0 1], 'Color', [0 0 0], 'LineStyle','--');
            title(['M1Ch-M1Nrn F:',num2str(percent_sig_D1*100),'% S:',num2str(percent_sig_D5*100),'% P:',num2str(p_score)]);
            set(gca, 'XScale', 'log')
            xlim([bin_centers(1) bin_centers(end)])
            saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Phase_non-uniformity_cdf_M1Ch-M1Nrn_SvF', '.fig']);
            close all;
        end
        
        if ~isempty(spike_phase_stats.M1Ch_CbNrn_stats_fail{day})
            spike_Ps = spike_phase_stats.M1Ch_CbNrn_stats_fail{day}(2,:);
            percent_sig_D1 = sum(spike_Ps <= 0.05)/length(spike_Ps);
            fail_Zs = spike_phase_stats.M1Ch_CbNrn_stats_fail{day}(1,:);
            [z_counts, ~] = histcounts(fail_Zs,edges);
            cum_count = cumsum(z_counts);
            z_ratio_cum = cum_count/length(spike_Ps);
            figure
            line(bin_centers,z_ratio_cum,'Color',[1 0.2 0.2]);
            
            spike_Ps = spike_phase_stats.M1Ch_CbNrn_stats_succ{day}(2,:);
            percent_sig_D5 = sum(spike_Ps <= 0.05)/length(spike_Ps);
            succ_Zs = spike_phase_stats.M1Ch_CbNrn_stats_succ{day}(1,:);
            [z_counts, ~] = histcounts(succ_Zs,edges);
            cum_count = cumsum(z_counts);
            z_ratio_cum = cum_count/length(spike_Ps);
            if isempty(succ_Zs) || isempty(fail_Zs)
                p_score = nan;
            else
                [~, p_score] = kstest2(succ_Zs, fail_Zs);
            end
            line(bin_centers,z_ratio_cum,'Color',[0.8 0 0]);
            line([3 3], [0 1], 'Color', [0 0 0], 'LineStyle','--');
            title(['M1Ch-CbNrn F:',num2str(percent_sig_D1*100),'% S:',num2str(percent_sig_D5*100),'% P:',num2str(p_score)]);
            set(gca, 'XScale', 'log')
            xlim([bin_centers(1) bin_centers(end)])
            saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Phase_non-uniformity_cdf_M1Ch-CbNrn_SvF', '.fig']);
            close all;
        end
        
        if ~isempty(spike_phase_stats.CbCh_M1Nrn_stats_fail{day})
            spike_Ps = spike_phase_stats.CbCh_M1Nrn_stats_fail{day}(2,:);
            percent_sig_D1 = sum(spike_Ps <= 0.05)/length(spike_Ps);
            fail_Zs = spike_phase_stats.CbCh_M1Nrn_stats_fail{day}(1,:);
            [z_counts, ~] = histcounts(fail_Zs,edges);
            cum_count = cumsum(z_counts);
            z_ratio_cum = cum_count/length(spike_Ps);
            figure
            line(bin_centers,z_ratio_cum,'Color',[0.2 1 0.2]);
            
            spike_Ps = spike_phase_stats.CbCh_M1Nrn_stats_succ{day}(2,:);
            percent_sig_D5 = sum(spike_Ps <= 0.05)/length(spike_Ps);
            succ_Zs = spike_phase_stats.CbCh_M1Nrn_stats_succ{day}(1,:);
            [z_counts, ~] = histcounts(succ_Zs,edges);
            cum_count = cumsum(z_counts);
            z_ratio_cum = cum_count/length(spike_Ps);
            if isempty(succ_Zs) || isempty(fail_Zs)
                p_score = nan;
            else
                [~, p_score] = kstest2(succ_Zs, fail_Zs);
            end
            line(bin_centers,z_ratio_cum,'Color',[0 0.8 0]);
            line([3 3], [0 1], 'Color', [0 0 0], 'LineStyle','--');
            title(['CbCh-M1Nrn F:',num2str(percent_sig_D1*100),'% S:',num2str(percent_sig_D5*100),'% P:',num2str(p_score)]);
            set(gca, 'XScale', 'log')
            xlim([bin_centers(1) bin_centers(end)])
            saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Phase_non-uniformity_cdf_CbCh-M1Nrn_SvF', '.fig']);
            close all;
        end
        
        if ~isempty(spike_phase_stats.CbCh_CbNrn_stats_fail{day})
            spike_Ps = spike_phase_stats.CbCh_CbNrn_stats_fail{day}(2,:);
            percent_sig_D1 = sum(spike_Ps <= 0.05)/length(spike_Ps);
            fail_Zs = spike_phase_stats.CbCh_CbNrn_stats_fail{day}(1,:);
            [z_counts, ~] = histcounts(fail_Zs,edges);
            cum_count = cumsum(z_counts);
            z_ratio_cum = cum_count/length(spike_Ps);
            figure
            line(bin_centers,z_ratio_cum,'Color',[0.2 1 0.2]);
            
            spike_Ps = spike_phase_stats.CbCh_CbNrn_stats_succ{day}(2,:);
            percent_sig_D5 = sum(spike_Ps <= 0.05)/length(spike_Ps);
            succ_Zs = spike_phase_stats.CbCh_CbNrn_stats_succ{day}(1,:);
            [z_counts, ~] = histcounts(succ_Zs,edges);
            cum_count = cumsum(z_counts);
            z_ratio_cum = cum_count/length(spike_Ps);
            if isempty(succ_Zs) || isempty(fail_Zs)
                p_score = nan;
            else
                [~, p_score] = kstest2(succ_Zs, fail_Zs);
            end
            line(bin_centers,z_ratio_cum,'Color',[0 0.8 0]);
            line([3 3], [0 1], 'Color', [0 0 0], 'LineStyle','--');
            title(['CbCh-CbNrn F:',num2str(percent_sig_D1*100),'% S:',num2str(percent_sig_D5*100),'% P:',num2str(p_score)]);
            set(gca, 'XScale', 'log')
            xlim([bin_centers(1) bin_centers(end)])
            saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Phase_non-uniformity_cdf_CbCh-CbNrn_SvF', '.fig']);
            close all;
        end
    end
    
    if ~isempty(spike_phase_stats.M1Ch_M1Nrn_stats{1})
        spike_Ps = spike_phase_stats.M1Ch_M1Nrn_stats{1}(2,:);
        percent_sig_D1 = sum(spike_Ps <= 0.05)/length(spike_Ps);
        day1_Zs = spike_phase_stats.M1Ch_M1Nrn_stats{1}(1,:);
        [z_counts, ~] = histcounts(day1_Zs,edges);
        cum_count = cumsum(z_counts);
        z_ratio_cum = cum_count/length(spike_Ps);
        figure
        line(bin_centers,z_ratio_cum,'Color',[1 0.2 0.2]);
        
        spike_Ps = spike_phase_stats.M1Ch_M1Nrn_stats{5}(2,:);
        percent_sig_D5 = sum(spike_Ps <= 0.05)/length(spike_Ps);
        day5_Zs = spike_phase_stats.M1Ch_M1Nrn_stats{5}(1,:);
        [z_counts, ~] = histcounts(day5_Zs,edges);
        cum_count = cumsum(z_counts);
        z_ratio_cum = cum_count/length(spike_Ps);
        if isempty(day1_Zs) || isempty(day5_Zs)
            p_score = nan;
        else
            [~, p_score] = kstest2(day1_Zs, day5_Zs);
        end
        line(bin_centers,z_ratio_cum,'Color',[0.8 0 0]);
        line([3 3], [0 1], 'Color', [0 0 0], 'LineStyle','--');
        title(['M1Ch-M1Nrn D1:',num2str(percent_sig_D1*100),'% D5:',num2str(percent_sig_D5*100),'% P:',num2str(p_score)]);
        set(gca, 'XScale', 'log')
        xlim([bin_centers(1) bin_centers(end)])
        saveas(gcf,[rootpath,animal,'/Phase_non-uniformity_cdf_M1Ch-M1Nrn', '.fig']);
        close all;
    end
    
    if ~isempty(spike_phase_stats.M1Ch_CbNrn_stats{1})
        spike_Ps = spike_phase_stats.M1Ch_CbNrn_stats{1}(2,:);
        percent_sig_D1 = sum(spike_Ps <= 0.05)/length(spike_Ps);
        day1_Zs = spike_phase_stats.M1Ch_CbNrn_stats{1}(1,:);
        [z_counts, ~] = histcounts(day1_Zs,edges);
        cum_count = cumsum(z_counts);
        z_ratio_cum = cum_count/length(spike_Ps);
        figure
        line(bin_centers,z_ratio_cum,'Color',[1 0.2 0.2]);
        
        spike_Ps = spike_phase_stats.M1Ch_CbNrn_stats{5}(2,:);
        percent_sig_D5 = sum(spike_Ps <= 0.05)/length(spike_Ps);
        day5_Zs = spike_phase_stats.M1Ch_CbNrn_stats{5}(1,:);
        [z_counts, ~] = histcounts(day5_Zs,edges);
        cum_count = cumsum(z_counts);
        z_ratio_cum = cum_count/length(spike_Ps);
        if isempty(day1_Zs) || isempty(day5_Zs)
            p_score = nan;
        else
            [~, p_score] = kstest2(day1_Zs, day5_Zs);
        end
        line(bin_centers,z_ratio_cum,'Color',[0.8 0 0]);
        line([3 3], [0 1], 'Color', [0 0 0], 'LineStyle','--');
        title(['M1Ch-CbNrn D1:',num2str(percent_sig_D1*100),'% D5:',num2str(percent_sig_D5*100),'% P:',num2str(p_score)]);
        set(gca, 'XScale', 'log')
        xlim([bin_centers(1) bin_centers(end)])
        saveas(gcf,[rootpath,animal,'/Phase_non-uniformity_cdf_M1Ch-CbNrn', '.fig']);
        close all;
    end
    
    if ~isempty(spike_phase_stats.CbCh_M1Nrn_stats{1})
        spike_Ps = spike_phase_stats.CbCh_M1Nrn_stats{1}(2,:);
        percent_sig_D1 = sum(spike_Ps <= 0.05)/length(spike_Ps);
        day1_Zs = spike_phase_stats.CbCh_M1Nrn_stats{1}(1,:);
        [z_counts, ~] = histcounts(day1_Zs,edges);
        cum_count = cumsum(z_counts);
        z_ratio_cum = cum_count/length(spike_Ps);
        figure
        line(bin_centers,z_ratio_cum,'Color',[0.2 1 0.2]);
        
        spike_Ps = spike_phase_stats.CbCh_M1Nrn_stats{5}(2,:);
        percent_sig_D5 = sum(spike_Ps <= 0.05)/length(spike_Ps);
        day5_Zs = spike_phase_stats.CbCh_M1Nrn_stats{5}(1,:);
        [z_counts, ~] = histcounts(day5_Zs,edges);
        cum_count = cumsum(z_counts);
        z_ratio_cum = cum_count/length(spike_Ps);
        if isempty(day1_Zs) || isempty(day5_Zs)
            p_score = nan;
        else
            [~, p_score] = kstest2(day1_Zs, day5_Zs);
        end
        line(bin_centers,z_ratio_cum,'Color',[0 0.8 0]);
        line([3 3], [0 1], 'Color', [0 0 0], 'LineStyle','--');
        title(['CbCh-M1Nrn D1:',num2str(percent_sig_D1*100),'% D5:',num2str(percent_sig_D5*100),'% P:',num2str(p_score)]);
        set(gca, 'XScale', 'log')
        xlim([bin_centers(1) bin_centers(end)])
        saveas(gcf,[rootpath,animal,'/Phase_non-uniformity_cdf_CbCh-M1Nrn', '.fig']);
        close all;
    end
    
    if ~isempty(spike_phase_stats.CbCh_CbNrn_stats{1})
        spike_Ps = spike_phase_stats.CbCh_CbNrn_stats{1}(2,:);
        percent_sig_D1 = sum(spike_Ps <= 0.05)/length(spike_Ps);
        day1_Zs = spike_phase_stats.CbCh_CbNrn_stats{1}(1,:);
        [z_counts, ~] = histcounts(day1_Zs,edges);
        cum_count = cumsum(z_counts);
        z_ratio_cum = cum_count/length(spike_Ps);
        figure
        line(bin_centers,z_ratio_cum,'Color',[0.2 1 0.2]);
        
        spike_Ps = spike_phase_stats.CbCh_CbNrn_stats{5}(2,:);
        percent_sig_D5 = sum(spike_Ps <= 0.05)/length(spike_Ps);
        day5_Zs = spike_phase_stats.CbCh_CbNrn_stats{5}(1,:);
        [z_counts, ~] = histcounts(day5_Zs,edges);
        cum_count = cumsum(z_counts);
        z_ratio_cum = cum_count/length(spike_Ps);
        if isempty(day1_Zs) || isempty(day5_Zs)
            p_score = nan;
        else
            [~, p_score] = kstest2(day1_Zs, day5_Zs);
        end
        line(bin_centers,z_ratio_cum,'Color',[0 0.8 0]);
        line([3 3], [0 1], 'Color', [0 0 0], 'LineStyle','--');
        title(['CbCh-CbNrn D1:',num2str(percent_sig_D1*100),'% D5:',num2str(percent_sig_D5*100),'% P:',num2str(p_score)]);
        set(gca, 'XScale', 'log')
        xlim([bin_centers(1) bin_centers(end)])
        saveas(gcf,[rootpath,animal,'/Phase_non-uniformity_cdf_CbCh-CbNrn', '.fig']);
        close all;
    end

    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
    rmpath('Z:\Matlab for analysis\circStat2008\sis_data\matlab code\nhp data\MATLAB files\circStat2008');
end

%% M1 vs Cb Filtered LFP and Phase differences (41)

if enabled(41)
    disp('Block 41...')
    M1_channels_of_interest = []; % *OPTIONAL* I060: 6 I086: 9  I089: 2, 26 I107: 20     110: N/A        122: 5
    Cb_channels_of_interest = []; % *OPTIONAL* I060: 7 I086: 57 I089: 7     I107: 28, 45 110: 38, 36, 41 122: 20
    
    coh_threshold = 0;
    coh_win_start = -250; %in ms
    coh_win_end = 750; %in ms
    
    if param.M1_Fs ~= param.Cb_Fs
        error('Different sampling rates detected. Section needs to be modified to handle that situation')
    end
    
    plot_x_axis = round(-param.M1_Fs):round(param.M1_Fs);
    hist_bin_edges = -pi:pi/22:pi;
    
    for day=1:param.days
        for block=1:param.blocks
            %load LFP
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Normalized_Snapshots', '.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Filtered_LFP_Snapshots.mat']); %M1_1_4_snapshots
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Filter_Compare'],'dir')
                mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Filter_Compare']);
            end
            
            [M1_filt_succ, M1_filt_fail]  = success_fail_split(M1_1_4_snapshots,data,M1_bad_trials,3);
            [Cb_filt_succ, Cb_filt_fail]  = success_fail_split(Cb_1_4_snapshots,data,Cb_bad_trials,3);
            
            if isempty(M1_filt_succ)
                disp(['No succsessful trials for day ', num2str(day), ', block ', num2str(block),'.'])
                continue
            end
            
            %mean across trials
            M1_mean_filt_succ = mean(M1_filt_succ,3);
            Cb_mean_filt_succ = mean(Cb_filt_succ,3);
            M1_mean_filt_fail = mean(M1_filt_fail,3);
            Cb_mean_filt_fail = mean(Cb_filt_fail,3);
                      
            %Create phase trace for each mean
            M1_phase = zeros(size(M1_mean_filt_succ));
            Cb_phase = zeros(size(Cb_mean_filt_succ));
            for M1_i = 1:size(M1_snapshots,1)
                hilbert_LFP = hilbert(M1_mean_filt_succ(M1_i,:));
                inst_phase = unwrap(angle(hilbert_LFP));%inst phase
                inst_phase = inst_phase + pi;
                M1_phase(M1_i,:) = mod(inst_phase,2*pi);
                M1_phase(M1_i,:) = M1_phase(M1_i,:) - pi;
            end
            for Cb_i = 1:size(Cb_snapshots,1)
                hilbert_LFP = hilbert(Cb_mean_filt_succ(Cb_i,:));
                inst_phase = unwrap(angle(hilbert_LFP));%inst phase
                inst_phase = inst_phase + pi;
                Cb_phase(Cb_i,:) = mod(inst_phase,2*pi);
                Cb_phase(Cb_i,:) = Cb_phase(Cb_i,:) - pi;
            end
            
            %Save?
            
            %Phase difference compare
            max_bin_centers = nan(size(M1_snapshots,1),size(Cb_snapshots,1));
            for M1_i = 1:size(M1_snapshots,1)
                for Cb_i = 1:size(Cb_snapshots,1)
                    %Histograms:  -250ms to  +750ms
                    if ismember(param.M1_good_chans(M1_i),param.M1_increasing_power_channels) && ismember(param.Cb_good_chans(Cb_i),param.Cb_increasing_power_channels)
                        load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/LFP-LFP_Spectral_Coherence_alt/M1ch',num2str(param.M1_good_chans(M1_i)),'_Cbch',num2str(param.Cb_good_chans(Cb_i)),'_data', '.mat']);
                        coh_window = coh(coh_freqs < 6, coh_times > coh_win_start & coh_times < coh_win_end, :);
                        coh_mean = mean(coh_window(:));
                        if coh_mean <= coh_threshold
                            continue
                        end
                        
                        phase_diff = M1_phase(M1_i,:) - Cb_phase(Cb_i,:) + pi;
                        phase_diff = mod(phase_diff, 2*pi);
                        phase_diff = phase_diff - pi;
                        diff_hist = histcounts(phase_diff(round(3.75*param.M1_Fs):round(4.5*param.M1_Fs)),hist_bin_edges);
                        [~,max_idx] = max(diff_hist);
                        max_bin_centers(M1_i,Cb_i) = mean(hist_bin_edges([max_idx max_idx+1]));
                        
                        
                        %Single pair plots
                        if ismember(param.M1_good_chans(M1_i),M1_channels_of_interest) && ismember(param.Cb_good_chans(Cb_i),Cb_channels_of_interest)
                            f_LFP_plot = figure;
                            hold on
                            line(plot_x_axis, M1_mean_filt_succ(M1_i,(3*round(param.M1_Fs)):(5*round(param.M1_Fs))),'Color', 'red');
                            line(plot_x_axis, Cb_mean_filt_succ(Cb_i,(3*round(param.M1_Fs)):(5*round(param.M1_Fs))),'Color', 'green');
                            hold off
                            saveas(f_LFP_plot, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Filter_Compare/M1_Channel',num2str(param.M1_good_chans(M1_i)),'_Cb_Channel',num2str(param.Cb_good_chans(Cb_i)),'_filtered_LFP', '.fig'])
                            close all
                            
                            phase_plot = figure;
                            hold on
                            line(plot_x_axis, M1_phase(M1_i,(3*round(param.M1_Fs)):(5*round(param.M1_Fs))),'Color', 'red');
                            line(plot_x_axis, Cb_phase(Cb_i,(3*round(param.M1_Fs)):(5*round(param.M1_Fs))),'Color', 'green');
                            hold off
                            saveas(phase_plot, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Filter_Compare/M1_Channel',num2str(param.M1_good_chans(M1_i)),'_Cb_Channel',num2str(param.Cb_good_chans(Cb_i)),'_phase', '.fig'])
                            close all
                            
                            hist_plot = histogram(phase_diff(round(3.75*param.M1_Fs):round(4.5*param.M1_Fs)),hist_bin_edges);
                            saveas(hist_plot, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Filter_Compare/M1_Channel',num2str(param.M1_good_chans(M1_i)),'_Cb_Channel',num2str(param.Cb_good_chans(Cb_i)),'_phase_lag', '.fig'])
                            close all
                        end
                    end
                end
            end
            
            
            
            max_bin_centers(isnan(max_bin_centers(:))) = [];
            max_diff_hist = histcounts(max_bin_centers,hist_bin_edges);
            max_hist_plot = histogram(max_bin_centers,hist_bin_edges);
            saveas(max_hist_plot, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Filter_Compare/peak_phase_lag.fig'])
            close all
        end
    end
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Day filtered LFPs with mean overlay (42)

if enabled(42)
    disp('Block 42...')
    target_M1_channel = 9;
    target_Cb_channel = 57;
    num_trials = 20;
    
    M1_chan_idx = find(param.M1_good_chans == target_M1_channel);
    Cb_chan_idx = find(param.Cb_good_chans == target_Cb_channel);
    
    M1_plot_x = round(1.25*param.M1_Fs):round(2.75*param.M1_Fs);
    Cb_plot_x = round(1.25*param.Cb_Fs):round(2.75*param.Cb_Fs);
    for day = 1:param.days
        M1_day_reach_snapshots = [];
        M1_day_touch_snapshots = [];
        M1_day_retract_snapshots = [];
        Cb_day_reach_snapshots = [];
        Cb_day_touch_snapshots = [];
        Cb_day_retract_snapshots = [];
        for block = 1:param.blocks
            %load LFP traces
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Filtered_LFP_full_Snapshots.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/inter_event_intervals.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat']);
            
            good_trials = 1:(length(M1_bad_trials) + size(M1_1_4_snapshots_n,3));
            bad_trials = good_trials;
            good_trials(M1_bad_trials) = [];
            [reach, touch, retract, more_bad_trials] = create_event_centered_snapshots(reach_touch_interval, reach_retract_interval, M1_bad_trials, M1_1_4_snapshots_n, param.M1_Fs, 2, 4);
            good_trials(more_bad_trials) = [];
            bad_trials(good_trials) = [];
            [reach_succ, ~]  = success_fail_split(reach,data,bad_trials,3);
            [touch_succ, ~]  = success_fail_split(touch,data,bad_trials,3);
            [retract_succ, ~]  = success_fail_split(retract,data,bad_trials,3);
            M1_day_reach_snapshots = cat(3, M1_day_reach_snapshots, reach_succ);
            M1_day_touch_snapshots = cat(3, M1_day_touch_snapshots, touch_succ); 
            M1_day_retract_snapshots = cat(3, M1_day_retract_snapshots, retract_succ);
            
            good_trials = 1:(length(Cb_bad_trials) + size(Cb_1_4_snapshots_n,3));
            bad_trials = good_trials;
            good_trials(Cb_bad_trials) = [];
            [reach, touch, retract, more_bad_trials] = create_event_centered_snapshots(reach_touch_interval, reach_retract_interval, Cb_bad_trials, Cb_1_4_snapshots_n, param.Cb_Fs, 2, 4);
            good_trials(more_bad_trials) = [];
            bad_trials(good_trials) = [];
            [reach_succ, ~]  = success_fail_split(reach,data,bad_trials,3);
            [touch_succ, ~]  = success_fail_split(touch,data,bad_trials,3);
            [retract_succ, ~]  = success_fail_split(retract,data,bad_trials,3);
            Cb_day_reach_snapshots = cat(3, Cb_day_reach_snapshots, reach_succ); 
            Cb_day_touch_snapshots = cat(3, Cb_day_touch_snapshots, touch_succ); 
            Cb_day_retract_snapshots = cat(3, Cb_day_retract_snapshots, retract_succ); 
            
            
        end
            
        M1_reach_filt = M1_day_reach_snapshots(M1_chan_idx, M1_plot_x, :);
        M1_touch_filt = M1_day_touch_snapshots(M1_chan_idx, M1_plot_x, :);
        M1_retract_filt = M1_day_retract_snapshots(M1_chan_idx, M1_plot_x, :);
        
        Cb_reach_filt = Cb_day_reach_snapshots(Cb_chan_idx, Cb_plot_x, :);
        Cb_touch_filt = Cb_day_touch_snapshots(Cb_chan_idx, Cb_plot_x, :);
        Cb_retract_filt = Cb_day_retract_snapshots(Cb_chan_idx, Cb_plot_x, :);
        
        load([rootpath,animal,'/Shared_Data.mat'])
        shared_data.M1_reach_filt_LFPs{day} = M1_day_reach_snapshots(:, M1_plot_x, :);
        shared_data.M1_touch_filt_LFPs{day} = M1_day_touch_snapshots(:, M1_plot_x, :);
        shared_data.M1_retract_filt_LFPs{day} = M1_day_retract_snapshots(:, M1_plot_x, :);
        shared_data.Cb_reach_filt_LFPs{day} = Cb_day_reach_snapshots(:, Cb_plot_x, :);
        shared_data.Cb_touch_filt_LFPs{day} = Cb_day_touch_snapshots(:, Cb_plot_x, :);
        shared_data.Cb_retract_filt_LFPs{day} = Cb_day_retract_snapshots(:, Cb_plot_x, :);
        save([rootpath,animal,'/Shared_Data.mat'], 'shared_data')
        
        %find mean of M1 and Cb
        M1_reach_mean = mean(M1_reach_filt,3);
        M1_touch_mean = mean(M1_touch_filt,3);
        M1_retract_mean = mean(M1_retract_filt,3);
        Cb_reach_mean = mean(Cb_reach_filt,3);
        Cb_touch_mean = mean(Cb_touch_filt,3);
        Cb_retract_mean = mean(Cb_retract_filt,3);
        
        %Sort trials by sq error from mean
        M1_sq_err = M1_reach_filt - M1_reach_mean;
        M1_sq_err = M1_sq_err .^ 2;
        M1_sq_err = sum(M1_sq_err,2);
        [M1_sq_err, M1_sort_idx] = sort(M1_sq_err);
        M1_reach_filt = M1_reach_filt(:,:,M1_sort_idx);
        M1_touch_filt = M1_touch_filt(:,:,M1_sort_idx);
        M1_retract_filt = M1_retract_filt(:,:,M1_sort_idx);
        
        Cb_sq_err = Cb_reach_filt - Cb_reach_mean;
        Cb_sq_err = Cb_sq_err .^ 2;
        Cb_sq_err = sum(Cb_sq_err,2);
        [Cb_sq_err, Cb_sort_idx] = sort(Cb_sq_err);
        Cb_reach_filt = Cb_reach_filt(:,:,Cb_sort_idx);
        Cb_touch_filt = Cb_touch_filt(:,:,Cb_sort_idx);
        Cb_retract_filt = Cb_retract_filt(:,:,Cb_sort_idx);
        
        %plot mean and selected filtered trial LFPs in different colors on different figures
        figure
        subplot(1, 3, 1)
        line(M1_plot_x, squeeze(M1_reach_mean), 'Color', 'red', 'LineWidth', 2)
        line(M1_plot_x, squeeze(M1_reach_filt(:,:,1:(min(size(M1_reach_filt,3), num_trials))))', 'Color', [1 .3 .3], 'LineWidth', .25)
        ylim([-1 1]);
        
        subplot(1, 3, 2)
        line(M1_plot_x, squeeze(M1_touch_mean), 'Color', 'red', 'LineWidth', 2)
        line(M1_plot_x, squeeze(M1_touch_filt(:,:,1:(min(size(M1_touch_filt,3), num_trials))))', 'Color', [1 .3 .3], 'LineWidth', .25)
        ylim([-1 1]);
        
        subplot(1, 3, 3)
        line(M1_plot_x, squeeze(M1_retract_mean), 'Color', 'red', 'LineWidth', 2)
        line(M1_plot_x, squeeze(M1_retract_filt(:,:,1:(min(size(M1_retract_filt,3), num_trials))))', 'Color', [1 .3 .3], 'LineWidth', .25)
        ylim([-1 1]);
        saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Submovement_LFP_M1_Ch',num2str(target_M1_channel),'_means.fig'])
        close all
        
        figure
        subplot(1, 3, 1)
        line(Cb_plot_x, squeeze(Cb_reach_mean), 'Color', 'green', 'LineWidth', 2)
        line(Cb_plot_x, squeeze(Cb_reach_filt(:,:,1:(min(size(Cb_reach_filt,3), num_trials))))', 'Color', [.3 1 .3], 'LineWidth', .25)
        ylim([-1 1]);
        
        subplot(1, 3, 2)
        line(Cb_plot_x, squeeze(Cb_touch_mean), 'Color', 'green', 'LineWidth', 2)
        line(Cb_plot_x, squeeze(Cb_touch_filt(:,:,1:(min(size(Cb_touch_filt,3), num_trials))))', 'Color', [.3 1 .3], 'LineWidth', .25)
        ylim([-1 1]);
        
        subplot(1, 3, 3)
        line(Cb_plot_x, squeeze(Cb_retract_mean), 'Color', 'green', 'LineWidth', 2)
        line(Cb_plot_x, squeeze(Cb_retract_filt(:,:,1:(min(size(Cb_retract_filt,3), num_trials))))', 'Color', [.3 1 .3], 'LineWidth', .25)
        ylim([-1 1]);
        saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Submovement_LFP_Cb_Ch',num2str(target_Cb_channel),'_means.fig'])
        close all
    end
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Plot Power differences in Day 1&2 to Day 4&5 for behavior-matched trials (43)
%Success-fail split causes an error since coherence calc merges all trials. Instead, cohereence needs to be recalculated on fast success trials only.

if enabled(43)
    disp('Block 43...')
    min_freq = 1.125;
    max_freq = 3.0;
    M1_early_fast_trials = [];
    Cb_early_fast_trials = [];
    M1_late_fast_trials = [];
    Cb_late_fast_trials = [];
    early_fast_coherence = [];
    late_fast_coherence = [];
    for block = 1:param.blocks
        load([rootpath,animal,'/Day1/',param.block_names{block},'/ERSP_reach', '.mat']);
        load([rootpath,animal,'/Day1/',param.block_names{block},'/GUI_data.mat']);
        load([rootpath,animal,'/Day1/',param.block_names{block},'/Bad_trials.mat']);
        M1_data = data;
        Cb_data = data;
        M1_data(M1_bad_trials,:) = [];
        Cb_data(Cb_bad_trials,:) = [];
        shared_data_all = get_common_good_data(M1_data, Cb_data, M1_bad_trials, Cb_bad_trials, 1);
        [M1_ersp_data, ~] = success_fail_split(M1_ersp_data,M1_data,[],4);
        [M1_data,~] = success_fail_split(M1_data,M1_data,[],1);
        [Cb_ersp_data, ~] = success_fail_split(Cb_ersp_data,Cb_data,[],4);
        [Cb_data,~] = success_fail_split(Cb_data,Cb_data,[],1);
        [shared_data,~] = success_fail_split(shared_data_all,shared_data_all,[],1);
        
        M1_fast_idx = length_filter(M1_data, [200 400], 25);
        Cb_fast_idx = length_filter(Cb_data, [200 400], 25);
        shared_fast_idx = length_filter(shared_data, [200 400], 25);
        
        M1_early_fast_trials = cat(4, M1_early_fast_trials, M1_ersp_data(:,(M1_freqs >= min_freq) & (M1_freqs <= max_freq),:,M1_fast_idx));
        Cb_early_fast_trials = cat(4, Cb_early_fast_trials, Cb_ersp_data(:,(Cb_freqs >= min_freq) & (Cb_freqs <= max_freq),:,Cb_fast_idx));
        
        block_fast_coherence = zeros(length(param.M1_good_chans)*length(param.Cb_good_chans), 285, 4, length(shared_fast_idx));
        chan_idx = 1;
        for M1_chan = param.M1_good_chans
            for Cb_chan = param.Cb_good_chans
                if exist([rootpath,animal,'/Day1/',param.block_names{block},'/LFP-LFP_Spectral_Coherence_alt/M1ch',num2str(M1_chan),'_Cbch',num2str(Cb_chan),'_data', '.mat'], 'file')
                    load([rootpath,animal,'/Day1/',param.block_names{block},'/LFP-LFP_Spectral_Coherence_alt/M1ch',num2str(M1_chan),'_Cbch',num2str(Cb_chan),'_data', '.mat']);
                    [coh,~] = success_fail_split(coh,shared_data_all,[],3);
                    block_fast_coherence(chan_idx,:,:,:) = coh(:,(coh_freqs >= min_freq) & (coh_freqs <= max_freq),shared_fast_idx);
                    chan_idx = chan_idx + 1;
                end
            end
        end
        early_fast_coherence = cat(4, early_fast_coherence, block_fast_coherence);
        
        
        load([rootpath,animal,'/Day2/',param.block_names{block},'/ERSP_reach', '.mat']);
        load([rootpath,animal,'/Day2/',param.block_names{block},'/GUI_data.mat']);
        load([rootpath,animal,'/Day2/',param.block_names{block},'/Bad_trials.mat']);
        M1_data = data;
        Cb_data = data;
        M1_data(M1_bad_trials,:) = [];
        Cb_data(Cb_bad_trials,:) = [];
        shared_data_all = get_common_good_data(M1_data, Cb_data, M1_bad_trials, Cb_bad_trials, 1);
        [M1_ersp_data, ~] = success_fail_split(M1_ersp_data,M1_data,[],4);
        [M1_data,~] = success_fail_split(M1_data,M1_data,[],1);
        [Cb_ersp_data, ~] = success_fail_split(Cb_ersp_data,Cb_data,[],4);
        [Cb_data,~] = success_fail_split(Cb_data,Cb_data,[],1);
        [shared_data,~] = success_fail_split(shared_data_all,shared_data_all,[],1);
        
        M1_fast_idx = length_filter(M1_data, [200 400], 25);
        Cb_fast_idx = length_filter(Cb_data, [200 400], 25);
        shared_fast_idx = length_filter(shared_data, [200 400], 25);
        
        M1_early_fast_trials = cat(4, M1_early_fast_trials, M1_ersp_data(:,(M1_freqs >= min_freq) & (M1_freqs <= max_freq),:,M1_fast_idx));
        Cb_early_fast_trials = cat(4, Cb_early_fast_trials, Cb_ersp_data(:,(Cb_freqs >= min_freq) & (Cb_freqs <= max_freq),:,Cb_fast_idx));

        block_fast_coherence = zeros(length(param.M1_good_chans)*length(param.Cb_good_chans), 285, 4, length(shared_fast_idx));
        chan_idx = 1;
        for M1_chan = param.M1_good_chans
            for Cb_chan = param.Cb_good_chans
                if exist([rootpath,animal,'/Day2/',param.block_names{block},'/LFP-LFP_Spectral_Coherence_alt/M1ch',num2str(M1_chan),'_Cbch',num2str(Cb_chan),'_data', '.mat'], 'file')
                    load([rootpath,animal,'/Day2/',param.block_names{block},'/LFP-LFP_Spectral_Coherence_alt/M1ch',num2str(M1_chan),'_Cbch',num2str(Cb_chan),'_data', '.mat']);
                    [coh,~] = success_fail_split(coh,shared_data_all,[],3);
                    block_fast_coherence(chan_idx,:,:,:) = coh(:,(coh_freqs >= min_freq) & (coh_freqs <= max_freq),shared_fast_idx);
                    chan_idx = chan_idx + 1;
                end
            end
        end
        early_fast_coherence = cat(4, early_fast_coherence, block_fast_coherence);
        
        
        
        load([rootpath,animal,'/Day4/',param.block_names{block},'/ERSP_reach', '.mat']);
        load([rootpath,animal,'/Day4/',param.block_names{block},'/GUI_data.mat']);
        load([rootpath,animal,'/Day4/',param.block_names{block},'/Bad_trials.mat']);
        M1_data = data;
        Cb_data = data;
        M1_data(M1_bad_trials,:) = [];
        Cb_data(Cb_bad_trials,:) = [];
        shared_data_all = get_common_good_data(M1_data, Cb_data, M1_bad_trials, Cb_bad_trials, 1);
        [M1_ersp_data, ~] = success_fail_split(M1_ersp_data,M1_data,[],4);
        [M1_data,~] = success_fail_split(M1_data,M1_data,[],1);
        [Cb_ersp_data, ~] = success_fail_split(Cb_ersp_data,Cb_data,[],4);
        [Cb_data,~] = success_fail_split(Cb_data,Cb_data,[],1);
        [shared_data,~] = success_fail_split(shared_data_all,shared_data_all,[],1);
        
        M1_fast_idx = length_filter(M1_data, [200 400], 25);
        Cb_fast_idx = length_filter(Cb_data, [200 400], 25);
        shared_fast_idx = length_filter(shared_data, [200 400], 25);
        
        M1_late_fast_trials = cat(4, M1_late_fast_trials, M1_ersp_data(:,(M1_freqs >= min_freq) & (M1_freqs <= max_freq),:,M1_fast_idx));
        Cb_late_fast_trials = cat(4, Cb_late_fast_trials, Cb_ersp_data(:,(Cb_freqs >= min_freq) & (Cb_freqs <= max_freq),:,Cb_fast_idx));

        block_fast_coherence = zeros(length(param.M1_good_chans)*length(param.Cb_good_chans), 285, 4, length(shared_fast_idx));
        chan_idx = 1;
        for M1_chan = param.M1_good_chans
            for Cb_chan = param.Cb_good_chans
                if exist([rootpath,animal,'/Day4/',param.block_names{block},'/LFP-LFP_Spectral_Coherence_alt/M1ch',num2str(M1_chan),'_Cbch',num2str(Cb_chan),'_data', '.mat'], 'file');
                    load([rootpath,animal,'/Day4/',param.block_names{block},'/LFP-LFP_Spectral_Coherence_alt/M1ch',num2str(M1_chan),'_Cbch',num2str(Cb_chan),'_data', '.mat']);
                    [coh,~] = success_fail_split(coh,shared_data_all,[],3);
                    block_fast_coherence(chan_idx,:,:,:) = coh(:,(coh_freqs >= min_freq) & (coh_freqs <= max_freq),shared_fast_idx);
                    chan_idx = chan_idx + 1;
                end
            end
        end
        late_fast_coherence = cat(4, late_fast_coherence, block_fast_coherence);
        

        load([rootpath,animal,'/Day5/',param.block_names{block},'/ERSP_reach', '.mat']);
        load([rootpath,animal,'/Day5/',param.block_names{block},'/GUI_data.mat']);
        load([rootpath,animal,'/Day5/',param.block_names{block},'/Bad_trials.mat']);
        M1_data = data;
        Cb_data = data;
        M1_data(M1_bad_trials,:) = [];
        Cb_data(Cb_bad_trials,:) = [];
        shared_data_all = get_common_good_data(M1_data, Cb_data, M1_bad_trials, Cb_bad_trials, 1);
        [M1_ersp_data, ~] = success_fail_split(M1_ersp_data,M1_data,[],4);
        [M1_data,~] = success_fail_split(M1_data,M1_data,[],1);
        [Cb_ersp_data, ~] = success_fail_split(Cb_ersp_data,Cb_data,[],4);
        [Cb_data,~] = success_fail_split(Cb_data,Cb_data,[],1);
        [shared_data,~] = success_fail_split(shared_data_all,shared_data_all,[],1);
        
        M1_fast_idx = length_filter(M1_data, [200 400], 25);
        Cb_fast_idx = length_filter(Cb_data, [200 400], 25);
        shared_fast_idx = length_filter(shared_data, [200 400], 25);
        
        M1_late_fast_trials = cat(4, M1_late_fast_trials, M1_ersp_data(:,(M1_freqs >= min_freq) & (M1_freqs <= max_freq),:,M1_fast_idx));
        Cb_late_fast_trials = cat(4, Cb_late_fast_trials, Cb_ersp_data(:,(Cb_freqs >= min_freq) & (Cb_freqs <= max_freq),:,Cb_fast_idx));

        block_fast_coherence = zeros(length(param.M1_good_chans)*length(param.Cb_good_chans), 285, 4, length(shared_fast_idx));
        chan_idx = 1;
        for M1_chan = param.M1_good_chans
            for Cb_chan = param.Cb_good_chans
                if exist([rootpath,animal,'/Day5/',param.block_names{block},'/LFP-LFP_Spectral_Coherence_alt/M1ch',num2str(M1_chan),'_Cbch',num2str(Cb_chan),'_data', '.mat'], 'file');
                    load([rootpath,animal,'/Day5/',param.block_names{block},'/LFP-LFP_Spectral_Coherence_alt/M1ch',num2str(M1_chan),'_Cbch',num2str(Cb_chan),'_data', '.mat']);
                    [coh,~] = success_fail_split(coh,shared_data_all,[],3);
                    block_fast_coherence(chan_idx,:,:,:) = coh(:,(coh_freqs >= min_freq) & (coh_freqs <= max_freq),shared_fast_idx);
                    chan_idx = chan_idx + 1;
                end
            end
        end
        late_fast_coherence = cat(4, late_fast_coherence, block_fast_coherence);
    end
    
    %make plots
    M1_early_fast_trials = abs(M1_early_fast_trials);
    M1_late_fast_trials = abs(M1_late_fast_trials);
    M1_power_plot = figure;
    line([1 5],[mean(M1_early_fast_trials(:))/std(M1_early_fast_trials(:)), mean(M1_late_fast_trials(:))/std(M1_late_fast_trials(:))],'Color',[0 0 0]);
    %errorbar([1 5], [mean(M1_early_fast_trials(:)), mean(M1_late_fast_trials(:))], [std(M1_early_fast_trials(:)), std(M1_late_fast_trials(:))], [std(M1_early_fast_trials(:)), std(M1_late_fast_trials(:))])
    %line([1 5], [mean(M1_early_fast_trials(:)); mean(M1_late_fast_trials(:))]','Color',[0.5 0.5 0.5])
    axis([0 6 0.5 2.5]);
    saveas(M1_power_plot,[rootpath,animal,'/Matched_trials_power_M1', '.fig']);
    close all
    
    Cb_early_fast_trials = abs(Cb_early_fast_trials);
    Cb_late_fast_trials = abs(Cb_late_fast_trials);
    Cb_power_plot = figure;
    line([1 5],[mean(Cb_early_fast_trials(:))/std(Cb_early_fast_trials(:)), mean(Cb_late_fast_trials(:))/std(Cb_late_fast_trials(:))],'Color',[0 0 0]);
    %errorbar([1 5], [mean(Cb_early_fast_trials(:)), mean(Cb_late_fast_trials(:))], [std(Cb_early_fast_trials(:)), std(Cb_late_fast_trials(:))], [std(Cb_early_fast_trials(:)), std(Cb_late_fast_trials(:))])
    %line([1 5], [mean(Cb_early_fast_trials(:)); mean(Cb_late_fast_trials(:))]','Color',[0.5 0.5 0.5])
    axis([0 6 0.5 2.5]);
    saveas(Cb_power_plot,[rootpath,animal,'/Matched_trials_power_Cb', '.fig']);
    close all
    
    Coh_power_plot = figure;
    line([1 5],[mean(early_fast_coherence(:))/std(early_fast_coherence(:)), mean(late_fast_coherence(:))/std(late_fast_coherence(:))],'Color',[0 0 0]);
    %errorbar([1 5], [mean(early_fast_coherence(:)), mean(late_fast_coherence(:))], [std(early_fast_coherence(:)), std(late_fast_coherence(:))], [std(early_fast_coherence(:)), std(late_fast_coherence(:))])
    %line([1 5], [mean(early_fast_coherence(:)); mean(late_fast_coherence(:))]','Color',[0.5 0.5 0.5])
    axis([0 6 0.1 0.35]);
    saveas(Coh_power_plot,[rootpath,animal,'/Matched_trials_coherence_M1-Cb', '.fig']);
    close all
    
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Spike Field Coherence Heatmaps (44)

if enabled(44)
    disp('Block 44...')
    
    alt = true;
    if alt
        suff1 = '_alt';
    else
        suff1 = ''; %#ok<UNRCH>
    end
    M1_channels_of_interest = [2];  %  I060: 12 I076: 15 I061: 29 I064: 28 I086: 9  I089: 2, 26
    Cb_channels_of_interest = [7]; %  I060: 8  I076: 23 I061: 20 I064: 17 I086: 57 I089: 7
    if isempty(M1_channels_of_interest)
        M1_channels_of_interest = 1:param.M1_chans;
    end
    if isempty(Cb_channels_of_interest)
        Cb_channels_of_interest = 1:param.Cb_chans;
    end
    M1_channels_of_interest = find(ismember(param.M1_good_chans, M1_channels_of_interest));
    Cb_channels_of_interest = find(ismember(param.Cb_good_chans, Cb_channels_of_interest));
    
    M1_neurons_of_interest = {[],...
                              [],...
                              [],...
                              [],...
                              []};
    Cb_neurons_of_interest = {[],... 
                              [],...
                              [],...
                              [],...
                              []};
    if isempty([M1_neurons_of_interest{:} Cb_neurons_of_interest{:}])
       M1_neurons_of_interest = {1:(param.M1_chans*param.M1_neurons), 1:(param.M1_chans*param.M1_neurons), 1:(param.M1_chans*param.M1_neurons), 1:(param.M1_chans*param.M1_neurons), 1:(param.M1_chans*param.M1_neurons)};
       Cb_neurons_of_interest = {1:(param.Cb_chans*param.Cb_neurons), 1:(param.Cb_chans*param.Cb_neurons), 1:(param.Cb_chans*param.Cb_neurons), 1:(param.Cb_chans*param.Cb_neurons), 1:(param.Cb_chans*param.Cb_neurons)};
    end

    for day=1:param.days
        M1ch_M1nrn_day_cohs = [];
        M1ch_Cbnrn_day_cohs = [];
        Cbch_M1nrn_day_cohs = [];
        Cbch_Cbnrn_day_cohs = [];
        disp(['Day ', num2str(day)])
        for lfp_chan_num = M1_channels_of_interest
            lfp_chan = find(param.M1_good_chans==lfp_chan_num);
            neuron_idx = 0;
            for s_chan = 1:param.M1_chans
                for code = 1:param.M1_neurons
                    neuron_idx = neuron_idx + 1;
                    for block=1:param.blocks
                        %M1 LFP vs M1 spikes
                        if exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence',suff1,'/M1_Channel',num2str(lfp_chan_num),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data.mat'], 'file')
                            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence',suff1,'/M1_Channel',num2str(lfp_chan_num),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data.mat']);
                            low_spike_trials = logical(isinf(max(max(coh,[],2),[],1)) + sum(sum(isnan(coh),2),1));
                            disp(['SFC trials removed: ', num2str(sum(low_spike_trials)), '/', num2str(size(coh,3))])
                            coh(:,:,low_spike_trials) = [];
                            if ismember(neuron_idx, M1_neurons_of_interest{day}) && param.M1_task_related_neurons{day}(s_chan,code) && ~isempty(coh)
                                M1ch_M1nrn_day_cohs = cat(3, M1ch_M1nrn_day_cohs, coh);
                                pcolor(coh_times,coh_freqs,mean(coh, 3))
                                shading interp
                                axis xy
                                axis([-1000 1500 1.5 20])
                                caxis([0 0.8])
                                colorbar
                                title(['SFC M1ch', num2str(lfp_chan), 'M1nrn', num2str(s_chan),'-',num2str(code)])
                                saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence',suff1,'/M1_Channel',num2str(lfp_chan_num),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_heatmap.fig']);
                                close all
                            else
                                if exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence',suff1,'/M1_Channel',num2str(lfp_chan_num),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_heatmap.fig'], 'file')
                                    delete([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence',suff1,'/M1_Channel',num2str(lfp_chan_num),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_heatmap.fig']);
                                end
                            end
                        end
                    end
                end
            end
            
            neuron_idx = 0;
            for s_chan = 1:param.Cb_chans
                for code = 1:param.Cb_neurons
                    neuron_idx = neuron_idx + 1;
                    for block=1:param.blocks
                        %M1 LFP vs Cb spikes
                        if exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence',suff1,'/M1_Channel',num2str(lfp_chan_num),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data.mat'], 'file')
                            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence',suff1,'/M1_Channel',num2str(lfp_chan_num),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data.mat']);
                            low_spike_trials = logical(isinf(max(max(coh,[],2),[],1)) + sum(sum(isnan(coh),2),1));
                            disp(['SFC trials removed: ', num2str(sum(low_spike_trials)), '/', num2str(size(coh,3))])
                            coh(:,:,low_spike_trials) = [];
                            if ismember(neuron_idx, Cb_neurons_of_interest{day}) && param.Cb_task_related_neurons{day}(s_chan,code) && ~isempty(coh)
                                M1ch_Cbnrn_day_cohs = cat(3, M1ch_Cbnrn_day_cohs, coh);
                                pcolor(coh_times,coh_freqs,mean(coh, 3))
                                shading interp
                                axis xy
                                axis([-1000 1500 1.5 20])
                                caxis([0 0.8])
                                colorbar
                                title(['SFC M1ch', num2str(lfp_chan), 'Cbnrn', num2str(s_chan),'-',num2str(code)])
                                saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence',suff1,'/M1_Channel',num2str(lfp_chan_num),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_heatmap.fig']);
                                close all
                            else
                                if exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence',suff1,'/M1_Channel',num2str(lfp_chan_num),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_heatmap.fig'], 'file')
                                    delete([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence',suff1,'/M1_Channel',num2str(lfp_chan_num),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_heatmap.fig']);
                                end
                            end
                        end
                    end
                end
            end
        end
        for lfp_chan_num = Cb_channels_of_interest
            lfp_chan = find(param.Cb_good_chans==lfp_chan_num);
            neuron_idx = 0;
            for s_chan = 1:param.M1_chans
                for code = 1:param.M1_neurons
                    neuron_idx = neuron_idx + 1;
                    for block=1:param.blocks
                        %Cb LFP vs M1 spikes
                        if exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence',suff1,'/Cb_Channel',num2str(lfp_chan_num),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data.mat'], 'file')
                            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence',suff1,'/Cb_Channel',num2str(lfp_chan_num),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data.mat']);
                            low_spike_trials = logical(isinf(max(max(coh,[],2),[],1)) + sum(sum(isnan(coh),2),1));
                            disp(['SFC trials removed: ', num2str(sum(low_spike_trials)), '/', num2str(size(coh,3))])
                            coh(:,:,low_spike_trials) = [];
                            if ismember(neuron_idx, M1_neurons_of_interest{day}) && param.M1_task_related_neurons{day}(s_chan,code) && ~isempty(coh)
                                Cbch_M1nrn_day_cohs = cat(3, Cbch_M1nrn_day_cohs, coh);
                                pcolor(coh_times,coh_freqs,mean(coh, 3))
                                shading interp
                                axis xy
                                axis([-1000 1500 1.5 20])
                                caxis([0 0.8])
                                colorbar
                                title(['SFC Cbch', num2str(lfp_chan), 'M1nrn', num2str(s_chan),'-',num2str(code)])
                                saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence',suff1,'/Cb_Channel',num2str(lfp_chan_num),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_heatmap.fig']);
                                close all
                            else
                                if exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence',suff1,'/Cb_Channel',num2str(lfp_chan_num),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_heatmap.fig'], 'file')
                                    delete([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence',suff1,'/Cb_Channel',num2str(lfp_chan_num),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_heatmap.fig']);
                                end
                            end
                        end
                    end
                end
            end
            
            neuron_idx = 0;
            for s_chan = 1:param.Cb_chans
                for code = 1:param.Cb_neurons
                    neuron_idx = neuron_idx + 1;
                    for block=1:param.blocks
                        %Cb LFP vs Cb spikes
                        if exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence',suff1,'/Cb_Channel',num2str(lfp_chan_num),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data.mat'], 'file')
                            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence',suff1,'/Cb_Channel',num2str(lfp_chan_num),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data.mat']);
                            low_spike_trials = logical(isinf(max(max(coh,[],2),[],1)) + sum(sum(isnan(coh),2),1));
                            disp(['SFC trials removed: ', num2str(sum(low_spike_trials)), '/', num2str(size(coh,3))])
                            coh(:,:,low_spike_trials) = [];
                            if ismember(neuron_idx, Cb_neurons_of_interest{day}) && param.Cb_task_related_neurons{day}(s_chan,code) && ~isempty(coh)
                                Cbch_Cbnrn_day_cohs = cat(3, Cbch_Cbnrn_day_cohs, coh);
                                pcolor(coh_times,coh_freqs,mean(coh, 3))
                                shading interp
                                axis xy
                                axis([-1000 1500 1.5 20])
                                caxis([0 0.8])
                                colorbar
                                title(['SFC Cbch', num2str(lfp_chan), 'Cbnrn', num2str(s_chan),'-',num2str(code)])
                                saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence',suff1,'/Cb_Channel',num2str(lfp_chan_num),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_heatmap.fig']);
                                close all
                            else
                                if exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence',suff1,'/Cb_Channel',num2str(lfp_chan_num),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_heatmap.fig'], 'file')
                                    delete([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence',suff1,'/Cb_Channel',num2str(lfp_chan_num),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_heatmap.fig']);
                                end
                            end
                        end
                    end
                end
            end
        end
        if isempty(M1ch_M1nrn_day_cohs)
            figure
            title(['No Data'])
        else
            pcolor(coh_times,coh_freqs,mean(M1ch_M1nrn_day_cohs, 3))
            shading interp
            axis xy
            axis([-1000 1500 1.5 20])
            caxis([0 0.8])
            colorbar
            title(['Day' num2str(day), ' mean SFC M1ch M1nrn'])
        end
        saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/M1_Channel_M1_Neuron_coherence_heatmap.fig']);
        close all
        
        if isempty(M1ch_Cbnrn_day_cohs)
            figure
            title(['No Data'])
        else
            pcolor(coh_times,coh_freqs,mean(M1ch_Cbnrn_day_cohs, 3))
            shading interp
            axis xy
            axis([-1000 1500 1.5 20])
            caxis([0 0.8])
            colorbar
            title(['Day' num2str(day), ' mean SFC M1ch Cbnrn'])
        end
        saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/M1_Channel_Cb_Neuron_coherence_heatmap.fig']);
        close all
        
        if isempty(Cbch_M1nrn_day_cohs)
            figure
            title(['No Data'])
        else
            pcolor(coh_times,coh_freqs,mean(Cbch_M1nrn_day_cohs, 3))
            shading interp
            axis xy
            axis([-1000 1500 1.5 20])
            caxis([0 0.8])
            colorbar
            title(['Day' num2str(day), ' mean SFC Cbch M1nrn'])
        end
        saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/Cb_Channel_M1_Neuron_coherence_heatmap.fig']);
        close all
        
        if isempty(Cbch_Cbnrn_day_cohs)
            figure
            title(['No Data'])
        else
            pcolor(coh_times,coh_freqs,mean(Cbch_Cbnrn_day_cohs, 3))
            shading interp
            axis xy
            axis([-1000 1500 1.5 20])
            caxis([0 0.8])
            colorbar
            title(['Day' num2str(day), ' mean SFC Cbch Cbnrn'])
        end
        saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/Cb_Channel_Cb_Neuron_coherence_heatmap.fig']);
        close all
    end
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Single channel Spike-Field Coherence Day Mean (45)
if enabled(45)
    disp('Block 45...')
    M1_channel_of_interest = 6; %good: 6
    Cb_channel_of_interest = 7;  %good: 7, 23, 29
    
    M1_neurons_of_interest = {[],...
                              [],...
                              [],...
                              [],...
                              []};
    Cb_neurons_of_interest = {[],... 
                              [],...
                              [],...
                              [],...
                              []};
    if isempty([M1_neurons_of_interest{:} Cb_neurons_of_interest{:}])
       M1_neuron_of_interest = {1:(param.M1_chans*param.M1_neurons), 1:(param.M1_chans*param.M1_neurons), 1:(param.M1_chans*param.M1_neurons), 1:(param.M1_chans*param.M1_neurons), 1:(param.M1_chans*param.M1_neurons)};
       Cb_neuron_of_interest = {1:(param.Cb_chans*param.Cb_neurons), 1:(param.Cb_chans*param.Cb_neurons), 1:(param.Cb_chans*param.Cb_neurons), 1:(param.Cb_chans*param.Cb_neurons), 1:(param.Cb_chans*param.Cb_neurons)};
    end
    
    for day=1:param.days
        M1ch_M1nrn_day_cohs = [];
        M1ch_Cbnrn_day_cohs = [];
        Cbch_M1nrn_day_cohs = [];
        Cbch_Cbnrn_day_cohs = [];
        for block = 1:param.blocks
            neuron_idx = 0;
            for s_chan = 1:param.M1_chans
                for code = 1:param.M1_neurons
                    neuron_idx = neuron_idx + 1;
                    if ismember(neuron_idx, M1_neuron_of_interest{day}) && param.M1_task_related_neurons{day}(s_chan,code)
                        if exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/M1_Channel',num2str(M1_channel_of_interest),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data.mat'], 'file')
                            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/M1_Channel',num2str(M1_channel_of_interest),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data.mat']);
                            
                            low_spike_trials = isinf(max(max(coh,[],2),[],1));
                            coh(:,:,low_spike_trials) = [];
                            M1ch_M1nrn_day_cohs = cat(3, M1ch_M1nrn_day_cohs, coh);
                        end
                    end
                end
            end
               
            neuron_idx = 0;
            for s_chan = 1:param.Cb_chans
                for code = 1:param.Cb_neurons
                    neuron_idx = neuron_idx + 1;
                    if ismember(neuron_idx, Cb_neuron_of_interest{day}) && param.Cb_task_related_neurons{day}(s_chan,code)
                        if exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/M1_Channel',num2str(M1_channel_of_interest),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data.mat'], 'file')
                            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/M1_Channel',num2str(M1_channel_of_interest),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data.mat']);
                            low_spike_trials = isinf(max(max(coh,[],2),[],1));
                            coh(:,:,low_spike_trials) = [];
                            M1ch_Cbnrn_day_cohs = cat(3, M1ch_Cbnrn_day_cohs, coh);
                        end
                    end
                end
            end
            
            neuron_idx = 0;
            for s_chan = 1:param.M1_chans
                for code = 1:param.M1_neurons
                    neuron_idx = neuron_idx + 1;
                    if ismember(neuron_idx, M1_neuron_of_interest{day}) && param.M1_task_related_neurons{day}(s_chan,code)
                        if exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/Cb_Channel',num2str(Cb_channel_of_interest),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data.mat'], 'file')
                            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/Cb_Channel',num2str(Cb_channel_of_interest),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data.mat']);
                            low_spike_trials = isinf(max(max(coh,[],2),[],1));
                            coh(:,:,low_spike_trials) = [];
                            Cbch_M1nrn_day_cohs = cat(3, Cbch_M1nrn_day_cohs, coh);
                        end
                    end
                end
            end
               
            neuron_idx = 0;
            for s_chan = 1:param.Cb_chans
                for code = 1:param.Cb_neurons
                    neuron_idx = neuron_idx + 1;
                    if ismember(neuron_idx, Cb_neuron_of_interest{day}) && param.Cb_task_related_neurons{day}(s_chan,code)
                        if exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/Cb_Channel',num2str(Cb_channel_of_interest),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data.mat'], 'file')
                            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence_alt/Cb_Channel',num2str(Cb_channel_of_interest),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_coherence_data.mat']);
                            low_spike_trials = isinf(max(max(coh,[],2),[],1));
                            coh(:,:,low_spike_trials) = [];
                            Cbch_Cbnrn_day_cohs = cat(3, Cbch_Cbnrn_day_cohs, coh);
                        end
                    end
                end
            end
        end
        if ~isempty(M1ch_M1nrn_day_cohs)
            pcolor(coh_times,coh_freqs,mean(M1ch_M1nrn_day_cohs, 3))
            shading interp
            axis xy
            axis([-1000 1500 1.5 20])
            caxis([0 0.8])
            colorbar
            title(['Day' num2str(day), ' mean SFC M1ch M1nrn'])
            saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/M1_Channel',num2str(M1_channel_of_interest),'_M1_Neuron_coherence_heatmap.fig']);
            close all
        end

        if ~isempty(M1ch_Cbnrn_day_cohs)
            pcolor(coh_times,coh_freqs,mean(M1ch_Cbnrn_day_cohs, 3))
            shading interp
            axis xy
            axis([-1000 1500 1.5 20])
            caxis([0 0.8])
            colorbar
            title(['Day' num2str(day), ' mean SFC M1ch Cbnrn'])
            saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/M1_Channel',num2str(M1_channel_of_interest),'_Cb_Neuron_coherence_heatmap.fig']);
            close all
        end
        
        if ~isempty(Cbch_M1nrn_day_cohs)
            pcolor(coh_times,coh_freqs,mean(Cbch_M1nrn_day_cohs, 3))
            shading interp
            axis xy
            axis([-1000 1500 1.5 20])
            caxis([0 0.8])
            colorbar
            title(['Day' num2str(day), ' mean SFC Cbch M1nrn'])
            saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/Cb_Channel',num2str(Cb_channel_of_interest),'_M1_Neuron_coherence_heatmap.fig']);
            close all
        end

        if ~isempty(Cbch_Cbnrn_day_cohs)
            pcolor(coh_times,coh_freqs,mean(Cbch_Cbnrn_day_cohs, 3))
            shading interp
            axis xy
            axis([-1000 1500 1.5 20])
            caxis([0 0.8])
            colorbar
            title(['Day' num2str(day), ' mean SFC Cbch Cbnrn'])
            saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/Cb_Channel',num2str(Cb_channel_of_interest),'_Cb_Neuron_coherence_heatmap.fig']);
            close all
        end
    end
end

%% Cross Correlogram (Spike-Spike) Analysis (46)

if enabled(46)
    disp('Block 46...')
    addpath(genpath('Z:\Matlab for analysis'))
    window = [-1.0 1.0]; %in seconds
    bin_size = 0.001; %in seconds
    bin_edges = window(1):bin_size:window(2);
    bin_centers = bin_edges(1:end-1) + ((bin_edges(2) - bin_edges(1))/2);
    num_shuffles = 200;
    M1_min_spike_hz = 10;
    Cb_min_spike_hz = 5;
    M1_neurons_of_interest = param.M1_task_related_neurons;
    Cb_neurons_of_interest = param.Cb_task_related_neurons;
    
    day_trial_nums = zeros(1,param.days);
    for day = 1:param.days
        pair_xcorrs = zeros(sum(M1_neurons_of_interest{day}(:)) * sum(Cb_neurons_of_interest{day}(:)),(length(bin_edges)*2)-3);
        
        for block = 1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/spiketrain_snapshots_full.mat']);
            
            day_trial_nums(day) = day_trial_nums(day) + size(M1_spike_snapshots_full,3);
            pair_idx = 0;
            for M1_chan = 1:param.M1_chans
                for M1_code = 1:param.M1_neurons
                    if M1_neurons_of_interest{day}(M1_chan,M1_code) %param.M1_multiphasic_neurons{day}(M1_chan,Cb_code)
                        for Cb_chan = 1:param.Cb_chans
                            for Cb_code = 1:param.Cb_neurons
                                if Cb_neurons_of_interest{day}(Cb_chan,Cb_code) %param.Cb_multiphasic_neurons{day}(Cb_chan,Cb_code)
                                    pair_idx = pair_idx+1;
                                
                                    for trial = 1:size(M1_spike_snapshots_full,3)
                                        %lag counts
%                                         [diffs, d_idx1, d_idx2] = spiketime_diffs(M1_spike_snapshots_full{M1_chan,M1_code,trial}/param.M1_Fs, Cb_spike_snapshots_full{Cb_chan,Cb_code,trial}/param.Cb_Fs, window);
%                                         pair_hist = pair_hist + histcounts(diffs, bin_edges);
                                        
                                        %get raw xcorr
                                        M1_trial_hist = histcounts(M1_spike_snapshots_full{M1_chan,M1_code,trial}/param.M1_Fs, bin_edges);
                                        Cb_trial_hist = histcounts(Cb_spike_snapshots_full{Cb_chan,Cb_code,trial}/param.Cb_Fs, bin_edges);
                                        if sum(M1_trial_hist) / (window(2) - window(1)) < M1_min_spike_hz || sum(Cb_trial_hist) / (window(2) - window(1)) < Cb_min_spike_hz
                                            continue
                                        end
                                        
                                        [raw_xcorr, pair_lags] = xcorr(M1_trial_hist, Cb_trial_hist);
                                        
                                        %find baseline using shuffling
                                        shuff_xcorrs = nan(num_shuffles,length(raw_xcorr));
                                        for shuffle = 1:num_shuffles
                                            shuff_M1_trial_hist = M1_trial_hist(randperm(length(M1_trial_hist)));
                                            shuff_Cb_trial_hist = Cb_trial_hist(randperm(length(Cb_trial_hist)));
                                            shuff_xcorrs(shuffle,:) = xcorr(shuff_M1_trial_hist, shuff_Cb_trial_hist);
                                        end
                                        norm_xcorr = (raw_xcorr - mean(shuff_xcorrs,1))./std(shuff_xcorrs,0,1);
                                        if isnan(norm_xcorr(1))
                                            norm_xcorr = zeros(size(norm_xcorr));
                                        end
                                        if max(norm_xcorr) > 100
                                            error('What.')
                                        end
                                        pair_xcorrs(pair_idx,:) = pair_xcorrs(pair_idx,:) + norm_xcorr;
                                        if isnan(pair_xcorrs(pair_idx,1))
                                            error('NaN detected')
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        pair_xcorrs = pair_xcorrs / day_trial_nums(day); %values of a magnitude >2 are "significant"
        smoothed_xcorrs = smoothdata(pair_xcorrs')';
        [max_amps, max_sig_idxs] = max(abs(smoothed_xcorrs),[],2); %add indexing to smoothed_xcorrs to only look for significant correlations at certain lags
        sig_pair_idxs = find(max_amps > 2);
        [~, peak_idxs] = max(pair_xcorrs,[],2);
        neg_lags = sum(peak_idxs < (size(pair_xcorrs,2)+1)/2);
        pos_lags = sum(peak_idxs > (size(pair_xcorrs,2)+1)/2);
        zero_lags = sum(peak_idxs == (size(pair_xcorrs,2)+1)/2);
%         day_hist = day_hist/size(all_day_hists,1);
%         norm_day_hist = norm_day_hist/size(all_day_hists,1); %#ok<NASGU>
%         hist_stderr = std(all_day_hists,0,1)/sqrt(size(all_day_hists,1));
%         hist_norm_stderr = std(all_day_norm_hists,0,1)/sqrt(size(all_day_norm_hists,1));
%         
%         s_day_hist = fit((bin_edges(1:end-1)+(bin_size/2))', day_hist', 'smoothingspline', 'SmoothingParam', 0.99);
%         s_err = fit((bin_edges(1:end-1)+(bin_size/2))', hist_stderr', 'smoothingspline', 'SmoothingParam', 0.99);
%         s_err_bounds = [s_day_hist((bin_edges(1:end-1)+(bin_size/2))) + s_err((bin_edges(1:end-1)+(bin_size/2))), s_day_hist((bin_edges(1:end-1)+(bin_size/2))) - s_err((bin_edges(1:end-1)+(bin_size/2)))];
%         %line(bin_edges(1:end-1)+(bin_size/2), s_day_hist((bin_edges(1:end-1)+(bin_size/2))), 'Color', [0.0 0.0 0.0], 'LineWidth', 2);
%         shadedErrorBar(bin_edges(1:end-1)+(bin_size/2), s_day_hist((bin_edges(1:end-1)+(bin_size/2))), s_err_bounds,'k-');
        line(pair_lags*bin_size, mean(pair_xcorrs(sig_pair_idxs,:),1), 'Color', [0.4 0.4 0.4], 'LineWidth', 1);
%         line([0,0],[0, max(day_hist)+1],'Color', [0 0 1]);
%         xlim([window(1) window(2)]);
        xlabel('Time lag (s)') 
        ylabel('Number of Spikes (mean across pairs)')
        title(['Day ', num2str(day), ' M1 - Cb mean spike lag counts; Sig: ', num2str(length(sig_pair_idxs)), '/', num2str(length(max_amps))])
%         title(['Day ', num2str(day), ' M1 - Cb mean spike lag counts; N: ', num2str(neg_lags), ', P: ', num2str(pos_lags),', 0: ', num2str(zero_lags)])
%         saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Spike_lag_counts.fig'])
%         close all
%         
%         norm_day_hist = (day_hist-mean(day_hist))/std(day_hist);
%         norm_err = hist_stderr/std(day_hist);
%         s_day_hist = fit((bin_edges(1:end-1)+(bin_size/2))', norm_day_hist', 'smoothingspline', 'SmoothingParam', 0.99);
%         s_err = fit((bin_edges(1:end-1)+(bin_size/2))', norm_err', 'smoothingspline', 'SmoothingParam', 0.99);
%         s_err_bounds = [s_day_hist((bin_edges(1:end-1)+(bin_size/2))) + s_err((bin_edges(1:end-1)+(bin_size/2))), s_day_hist((bin_edges(1:end-1)+(bin_size/2))) - s_err((bin_edges(1:end-1)+(bin_size/2)))];
%         %line(bin_edges(1:end-1)+(bin_size/2), s_day_hist((bin_edges(1:end-1)+(bin_size/2))), 'Color', [0.0 0.0 0.0], 'LineWidth', 2);
%         shadedErrorBar(bin_edges(1:end-1)+(bin_size/2), s_day_hist((bin_edges(1:end-1)+(bin_size/2))), s_err_bounds,'k-');
%         line(bin_edges(1:end-1)+(bin_size/2), norm_day_hist, 'Color', [0.4 0.4 0.4], 'LineWidth', 1);
%         line([0,0],[0, max(norm_day_hist)+1],'Color', [0 0 1]);
%         xlim([window(1) window(2)]);
%         xlabel('Time lag (s)') 
%         ylabel('Number of Spikes (mean across pairs)')
%         title(['Day ', num2str(day), 'Normalized M1 - Cb mean spike lag counts '])
%         saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Spike_lag_counts_norm.fig'])
%         close all
%         
%         s_day_hist = fit((bin_edges(1:end-1)+(bin_size/2))', norm_day_hist', 'smoothingspline', 'SmoothingParam', 0.99);
%         s_err = fit((bin_edges(1:end-1)+(bin_size/2))', hist_norm_stderr', 'smoothingspline', 'SmoothingParam', 0.99);
%         s_err_bounds = [s_day_hist((bin_edges(1:end-1)+(bin_size/2))) + s_err((bin_edges(1:end-1)+(bin_size/2))), s_day_hist((bin_edges(1:end-1)+(bin_size/2))) - s_err((bin_edges(1:end-1)+(bin_size/2)))];
%         %line(bin_edges(1:end-1)+(bin_size/2), s_day_hist((bin_edges(1:end-1)+(bin_size/2))), 'Color', [0.0 0.0 0.0], 'LineWidth', 2);
%         shadedErrorBar(bin_edges(1:end-1)+(bin_size/2), s_day_hist((bin_edges(1:end-1)+(bin_size/2))), s_err_bounds,'k-');
%         line(bin_edges(1:end-1)+(bin_size/2), norm_day_hist, 'Color', [0.4 0.4 0.4], 'LineWidth', 1);
%         line([0,0],[0, max(norm_day_hist)+1],'Color', [0 0 1]);
%         xlim([window(1) window(2)]);
%         xlabel('Time lag (s)') 
%         ylabel('Percentage of Spikes (mean across pairs)')
%         title(['Day ', num2str(day), ' M1 - Cb mean spike lag percentages'])
%         saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Spike_lag_percents.fig']);
%         close all
%         
%         line(pair_lags/1000, mean(day_mean_corrs, 1), 'Color', [0.4 0.4 0.4], 'LineWidth', 1);
%         line([0,0],[0, max(mean(day_mean_corrs, 1))+1],'Color', [0 0 1]);
%         xlabel('Time lag (s)') 
%         ylabel('Correlation (mean across pairs)')
%         title(['Day ', num2str(day), ' M1 - Cb Cross Correlation'])
        saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Cross_correlation.fig'])
        close all
    end
    rmpath(genpath('Z:\Matlab for analysis'))
end

%% Cohgramcpt Spike-Field Coherence (47)

if enabled(47)
    disp('Block 47...')
    addpath(genpath('Z:/Matlab for analysis/chronux_2_10/chronux/spectral_analysis'))
    M1_channels_of_interest = [];
    Cb_channels_of_interest = [];
    if isempty([M1_channels_of_interest Cb_channels_of_interest])
        M1_channels_of_interest = param.M1_good_chans;
        Cb_channels_of_interest = param.Cb_good_chans;
    end
    
    M1_neurons_of_interest = param.M1_task_related_neurons; %cell(1,5);
    Cb_neurons_of_interest = param.Cb_task_related_neurons; %cell(1,5);
    if isempty([M1_neurons_of_interest{:} Cb_neurons_of_interest{:}])
        M1_neurons_of_interest = {ones(param.M1_chans,param.M1_neurons), ones(param.M1_chans,param.M1_neurons), ones(param.M1_chans,param.M1_neurons), ones(param.M1_chans,param.M1_neurons), ones(param.M1_chans,param.M1_neurons)};
        Cb_neurons_of_interest = {ones(param.Cb_chans,param.Cb_neurons), ones(param.Cb_chans,param.Cb_neurons), ones(param.Cb_chans,param.Cb_neurons), ones(param.Cb_chans,param.Cb_neurons), ones(param.Cb_chans,param.Cb_neurons)};
    end
    
    coh_params.Fs = param.M1_Fs;
    coh_params.fpass = [0 20];
    coh_params.tapers = [3 5];
    coh_params.trialave = 0;
    coh_params.pad = 1;
    coh_params.err = [2 0.05];
    
    for day = 1:param.days
        for block = 1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Normalized_Snapshots', '.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/spiketrain_snapshots_full.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            
            trial_codes = str2double(data(:,3));
            no_reach_trials = (1:size(data,1));
            no_reach_trials = no_reach_trials(trial_codes>1);
            all_bad_trials = union(M1_bad_trials, Cb_bad_trials);
            
            [M1_snapshots, Cb_snapshots] = get_common_good_data(M1_snapshots, Cb_snapshots, M1_bad_trials, Cb_bad_trials, 3);
            [M1_spike_snapshots, ~] = get_common_good_data(M1_spike_snapshots_full, M1_snapshots, no_reach_trials, all_bad_trials, 3);
            [Cb_spike_snapshots, ~] = get_common_good_data(Cb_spike_snapshots_full, Cb_snapshots, no_reach_trials, all_bad_trials, 3);
            
            if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence'],'dir')
                mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence']);
            end
            
            for M1_lfp_chan = find(ismember(param.M1_good_chans,M1_channels_of_interest))
                if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence/M1_Channel',num2str(param.M1_good_chans(M1_lfp_chan))],'dir')
                    mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence/M1_Channel',num2str(param.M1_good_chans(M1_lfp_chan))]);
                end
                for M1_neuron_chan = 1:param.M1_chans
                    for M1_neuron_num = 1:param.M1_neurons
                        if ~isempty(M1_lfp_chan) && M1_neurons_of_interest{day}(M1_neuron_chan, M1_neuron_num)
                            M1_struct_spikes = struct('snapshot',cell(1,size(M1_spike_snapshots,3)));
                            for trial = 1:size(M1_spike_snapshots,3)
                                M1_struct_spikes(trial).snapshot = M1_spike_snapshots{M1_neuron_chan,M1_neuron_num,trial}/param.M1_Fs;
                            end
                            [coh,phi_cmr,~,~,~,coh_times_raw,coh_freqs,~,~,~,~] = cohgramcpt(squeeze(M1_snapshots(M1_lfp_chan,:,:)),M1_struct_spikes,[1 .025],coh_params);
                            coh = permute(coh,[2,1,3]);
                            coh_times = -4000:(8000/(length(coh_times_raw)-1)):4000;
                            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence/M1_Channel',num2str(param.M1_good_chans(M1_lfp_chan)),'/M1_Ch',num2str(M1_neuron_chan),'_code',num2str(M1_neuron_num),'_coherence_data.mat'], 'coh', 'coh_times', 'coh_freqs')
                        end
                    end
                end
                for Cb_neuron_chan = 1:param.Cb_chans
                    for Cb_neuron_num = 1:param.Cb_neurons
                        if ~isempty(M1_lfp_chan) && Cb_neurons_of_interest{day}(Cb_neuron_chan, Cb_neuron_num)
                            Cb_struct_spikes = struct('snapshot',cell(1,size(Cb_spike_snapshots,3)));
                            for trial = 1:size(Cb_spike_snapshots,3)
                                Cb_struct_spikes(trial).snapshot = Cb_spike_snapshots{Cb_neuron_chan,Cb_neuron_num,trial}/param.Cb_Fs;
                            end
                            [coh,phi_cmr,~,~,~,coh_times_raw,coh_freqs,~,~,~,~] = cohgramcpt(squeeze(M1_snapshots(M1_lfp_chan,:,:)),Cb_struct_spikes,[1 .025],coh_params,param.Cb_Fs);
                            coh = permute(coh,[2,1,3]);
                            coh_times = -4000:(8000/(length(coh_times_raw)-1)):4000;
                            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence/M1_Channel',num2str(param.M1_good_chans(M1_lfp_chan)),'/Cb_Ch',num2str(Cb_neuron_chan),'_code',num2str(Cb_neuron_num),'_coherence_data.mat'], 'coh', 'coh_times', 'coh_freqs')
                        end
                    end
                end
            end
            for Cb_lfp_chan = find(ismember(param.Cb_good_chans,Cb_channels_of_interest))
                if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence/Cb_Channel',num2str(param.Cb_good_chans(Cb_lfp_chan))],'dir')
                    mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence/Cb_Channel',num2str(param.Cb_good_chans(Cb_lfp_chan))]);
                end
                for M1_neuron_chan = 1:param.M1_chans
                    for M1_neuron_num = 1:param.M1_neurons
                        if ~isempty(Cb_lfp_chan) && M1_neurons_of_interest{day}(M1_neuron_chan, M1_neuron_num)
                            M1_struct_spikes = struct('snapshot',cell(1,size(M1_spike_snapshots,3)));
                            for trial = 1:size(M1_spike_snapshots,3)
                                M1_struct_spikes(trial).snapshot = M1_spike_snapshots{M1_neuron_chan,M1_neuron_num,trial}/param.M1_Fs;
                            end
                            [coh,phi_cmr,~,~,~,coh_times_raw,coh_freqs,~,~,~,~] = cohgramcpt(squeeze(Cb_snapshots(Cb_lfp_chan,:,:)),M1_struct_spikes,[1 .025],coh_params,param.M1_Fs);
                            coh = permute(coh,[2,1,3]);
                            coh_times = -4000:(8000/(length(coh_times_raw)-1)):4000;
                            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence/Cb_Channel',num2str(param.Cb_good_chans(Cb_lfp_chan)),'/M1_Ch',num2str(M1_neuron_chan),'_code',num2str(M1_neuron_num),'_coherence_data.mat'], 'coh', 'coh_times', 'coh_freqs')
                        end
                    end
                end
                for Cb_neuron_chan = 1:param.Cb_chans
                    for Cb_neuron_num = 1:param.Cb_neurons
                        if ~isempty(Cb_lfp_chan) && Cb_neurons_of_interest{day}(Cb_neuron_chan, Cb_neuron_num)
                            Cb_struct_spikes = struct('snapshot',cell(1,size(Cb_spike_snapshots,3)));
                            for trial = 1:size(Cb_spike_snapshots,3)
                                Cb_struct_spikes(trial).snapshot = Cb_spike_snapshots{Cb_neuron_chan,Cb_neuron_num,trial}/param.Cb_Fs;
                            end
                            [coh,phi_cmr,~,~,~,coh_times_raw,coh_freqs,~,~,~,~] = cohgramcpt(squeeze(Cb_snapshots(Cb_lfp_chan,:,:)),Cb_struct_spikes,[1 .025],coh_params,param.Cb_Fs);
                            coh = permute(coh,[2,1,3]);
                            coh_times = -4000:(8000/(length(coh_times_raw)-1)):4000;
                            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence/Cb_Channel',num2str(param.Cb_good_chans(Cb_lfp_chan)),'/Cb_Ch',num2str(Cb_neuron_chan),'_code',num2str(Cb_neuron_num),'_coherence_data.mat'], 'coh', 'coh_times', 'coh_freqs')
                        end
                    end
                end
            end
        end
    end
    rmpath(genpath('Z:/Matlab for analysis/chronux_2_10/chronux/spectral_analysis'))
end

%% Parallel Cohgramcpt Spike-Field Coherence (47.5)
%(Bad: Cpt produces too many infs and NANs)

if false 
    if isunix  %#ok<UNRCH>
        addpath(genpath('/common/fleischerp/HPC_code'))
        addpath(genpath('/common/fleischerp/3rd_party_code'))
    else
        addpath(genpath('Z:/Matlab for analysis/chronux_2_10/chronux/spectral_analysis'))
    end
    
    worker_num = 24;
    parallel_structs_M1_M1 = repmat(struct('Fs',param.M1_Fs,'LFP_snapshot',[],'spike_times',struct(),'save_path', ''),[param.days,param.blocks,param.M1_chans,param.M1_chans,param.M1_neurons]);
    parallel_structs_M1_Cb = repmat(struct('Fs',param.M1_Fs,'LFP_snapshot',[],'spike_times',struct(),'save_path', ''),[param.days,param.blocks,param.M1_chans,param.Cb_chans,param.Cb_neurons]);
    parallel_structs_Cb_M1 = repmat(struct('Fs',param.Cb_Fs,'LFP_snapshot',[],'spike_times',struct(),'save_path', ''),[param.days,param.blocks,param.Cb_chans,param.M1_chans,param.M1_neurons]);
    parallel_structs_Cb_Cb = repmat(struct('Fs',param.Cb_Fs,'LFP_snapshot',[],'spike_times',struct(),'save_path', ''),[param.days,param.blocks,param.Cb_chans,param.Cb_chans,param.Cb_neurons]);
    
    M1_channels_of_interest = [];
    Cb_channels_of_interest = []; %5,7,8,27
    if isempty([M1_channels_of_interest Cb_channels_of_interest])
        M1_channels_of_interest = param.M1_good_chans; %22
        Cb_channels_of_interest = param.Cb_good_chans; %29
    end
    
    M1_neurons_of_interest = param.M1_task_related_neurons; %cell(1,5);
    Cb_neurons_of_interest = param.Cb_task_related_neurons; %cell(1,5);
    if isempty([M1_neurons_of_interest{:} Cb_neurons_of_interest{:}])
        M1_neurons_of_interest = {ones(param.M1_chans,param.M1_neurons), ones(param.M1_chans,param.M1_neurons), ones(param.M1_chans,param.M1_neurons), ones(param.M1_chans,param.M1_neurons), ones(param.M1_chans,param.M1_neurons)};
        Cb_neurons_of_interest = {ones(param.Cb_chans,param.Cb_neurons), ones(param.Cb_chans,param.Cb_neurons), ones(param.Cb_chans,param.Cb_neurons), ones(param.Cb_chans,param.Cb_neurons), ones(param.Cb_chans,param.Cb_neurons)};
    end
    
    for day=1:param.days
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Normalized_Snapshots.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/spiketrain_snapshots_full.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            
            trial_codes = str2double(data(:,3));
            no_reach_trials = (1:size(data,1));
            no_reach_trials = no_reach_trials(trial_codes>1);
            all_bad_trials = union(M1_bad_trials, Cb_bad_trials);
            
            [M1_snapshots, Cb_snapshots] = get_common_good_data(M1_snapshots, Cb_snapshots, M1_bad_trials, Cb_bad_trials, 3);
            [M1_spike_snapshots, ~] = get_common_good_data(M1_spike_snapshots_full, M1_snapshots, no_reach_trials, all_bad_trials, 3);
            [Cb_spike_snapshots, ~] = get_common_good_data(Cb_spike_snapshots_full, Cb_snapshots, no_reach_trials, all_bad_trials, 3);
            
            if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence'],'dir')
                mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence']);
            end
            
            for M1_lfp_chan = find(ismember(param.M1_good_chans,M1_channels_of_interest))
                if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence/M1_Channel',num2str(param.M1_good_chans(M1_lfp_chan))],'dir')
                    mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence/M1_Channel',num2str(param.M1_good_chans(M1_lfp_chan))]);
                end
                for M1_neuron_chan = 1:param.M1_chans
                    for M1_neuron_num = 1:param.M1_neurons
                        if ~isempty(M1_lfp_chan) && M1_neurons_of_interest{day}(M1_neuron_chan, M1_neuron_num)
                                    
                            M1_struct_spikes = struct('snapshot',cell(1,size(M1_spike_snapshots,3)));
                            for trial = 1:size(M1_spike_snapshots,3)
                                M1_struct_spikes(trial).snapshot = M1_spike_snapshots{M1_neuron_chan,M1_neuron_num,trial}/param.M1_Fs;
                            end
                            
%                             [coh,phi_cmr,~,~,~,coh_times_raw,coh_freqs,~,~,~,~] = cohgramcpt(squeeze(M1_snapshots(M1_lfp_chan,:,:)),M1_struct_spikes,[1 .025],coh_params,param.M1_Fs);
%                             coh = permute(coh,[2,1,3]);
%                             coh_times = -4000:(8000/(length(coh_times_raw)-1)):4000;
%                             save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence/M1_Channel',num2str(param.M1_good_chans(M1_lfp_chan)),'/M1_Ch',num2str(M1_neuron_chan),'_code',num2str(M1_neuron_num),'_coherence_data.mat'], 'coh', 'coh_times', 'coh_freqs')

                            parallel_structs_M1_M1(day,block,M1_lfp_chan,M1_neuron_chan,M1_neuron_num) = struct('Fs',param.M1_Fs,'LFP_snapshot',squeeze(M1_snapshots(M1_lfp_chan,:,:)),'spike_times',M1_struct_spikes,'save_path',[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence/M1_Channel',num2str(param.M1_good_chans(M1_lfp_chan)),'/M1_Ch',num2str(M1_neuron_chan),'_code',num2str(M1_neuron_num),'_coherence_data.mat']);
                        end
                    end
                end
                
                for Cb_neuron_chan = 1:param.Cb_chans
                    for Cb_neuron_num = 1:param.Cb_neurons
                        if ~isempty(M1_lfp_chan) && Cb_neurons_of_interest{day}(Cb_neuron_chan, Cb_neuron_num)
                                    
                            Cb_struct_spikes = struct('snapshot',cell(1,size(Cb_spike_snapshots,3)));
                            for trial = 1:size(Cb_spike_snapshots,3)
                                Cb_struct_spikes(trial).snapshot = Cb_spike_snapshots{Cb_neuron_chan,Cb_neuron_num,trial}/param.Cb_Fs;
                            end
                            
%                             [coh,phi_cmr,~,~,~,coh_times_raw,coh_freqs,~,~,~,~] = cohgramcpt(squeeze(M1_snapshots(M1_lfp_chan,:,:)),M1_struct_spikes,[1 .025],coh_params,param.M1_Fs);
%                             coh = permute(coh,[2,1,3]);
%                             coh_times = -4000:(8000/(length(coh_times_raw)-1)):4000;
%                             save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence/M1_Channel',num2str(param.M1_good_chans(M1_lfp_chan)),'/M1_Ch',num2str(M1_neuron_chan),'_code',num2str(M1_neuron_num),'_coherence_data.mat'], 'coh', 'coh_times', 'coh_freqs')

                            parallel_structs_M1_Cb(day,block,M1_lfp_chan,Cb_neuron_chan,Cb_neuron_num) = struct('Fs',param.M1_Fs,'LFP_snapshot',squeeze(M1_snapshots(M1_lfp_chan,:,:)),'spike_times',Cb_struct_spikes,'save_path',[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence/M1_Channel',num2str(param.M1_good_chans(M1_lfp_chan)),'/Cb_Ch',num2str(Cb_neuron_chan),'_code',num2str(Cb_neuron_num),'_coherence_data.mat']);
                        end
                    end
                end
            end
            
            for Cb_lfp_chan = find(ismember(param.Cb_good_chans,Cb_channels_of_interest))
                if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence/Cb_Channel',num2str(param.Cb_good_chans(Cb_lfp_chan))],'dir')
                    mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence/Cb_Channel',num2str(param.Cb_good_chans(Cb_lfp_chan))]);
                end
                for M1_neuron_chan = 1:param.M1_chans
                    for M1_neuron_num = 1:param.M1_neurons
                        if ~isempty(Cb_lfp_chan) && M1_neurons_of_interest{day}(M1_neuron_chan, M1_neuron_num)
                            
                            M1_struct_spikes = struct('snapshot',cell(1,size(M1_spike_snapshots,3)));
                            for trial = 1:size(M1_spike_snapshots,3)
                                M1_struct_spikes(trial).snapshot = M1_spike_snapshots{M1_neuron_chan,M1_neuron_num,trial}/param.M1_Fs;
                            end
                            
%                             [coh,phi_cmr,~,~,~,coh_times_raw,coh_freqs,~,~,~,~] = cohgramcpt(squeeze(M1_snapshots(M1_lfp_chan,:,:)),M1_struct_spikes,[1 .025],coh_params,param.M1_Fs);
%                             coh = permute(coh,[2,1,3]);
%                             coh_times = -4000:(8000/(length(coh_times_raw)-1)):4000;
%                             save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence/M1_Channel',num2str(param.M1_good_chans(M1_lfp_chan)),'/M1_Ch',num2str(M1_neuron_chan),'_code',num2str(M1_neuron_num),'_coherence_data.mat'], 'coh', 'coh_times', 'coh_freqs')

                            parallel_structs_Cb_M1(day,block,Cb_lfp_chan,M1_neuron_chan,M1_neuron_num) = struct('Fs',param.Cb_Fs,'LFP_snapshot',squeeze(Cb_snapshots(Cb_lfp_chan,:,:)),'spike_times',M1_struct_spikes,'save_path',[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence/Cb_Channel',num2str(param.Cb_good_chans(Cb_lfp_chan)),'/M1_Ch',num2str(M1_neuron_chan),'_code',num2str(M1_neuron_num),'_coherence_data.mat']);
                        end
                    end
                end
                
                for Cb_neuron_chan = 1:param.Cb_chans
                    for Cb_neuron_num = 1:param.Cb_neurons
                        if ~isempty(Cb_lfp_chan) && Cb_neurons_of_interest{day}(Cb_neuron_chan, Cb_neuron_num)
                            
                            Cb_struct_spikes = struct('snapshot',cell(1,size(Cb_spike_snapshots,3)));
                            for trial = 1:size(Cb_spike_snapshots,3)
                                Cb_struct_spikes(trial).snapshot = Cb_spike_snapshots{Cb_neuron_chan,Cb_neuron_num,trial}/param.Cb_Fs;
                            end
                            
%                             [coh,phi_cmr,~,~,~,coh_times_raw,coh_freqs,~,~,~,~] = cohgramcpt(squeeze(M1_snapshots(M1_lfp_chan,:,:)),M1_struct_spikes,[1 .025],coh_params,param.M1_Fs);
%                             coh = permute(coh,[2,1,3]);
%                             coh_times = -4000:(8000/(length(coh_times_raw)-1)):4000;
%                             save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence/M1_Channel',num2str(param.M1_good_chans(M1_lfp_chan)),'/M1_Ch',num2str(M1_neuron_chan),'_code',num2str(M1_neuron_num),'_coherence_data.mat'], 'coh', 'coh_times', 'coh_freqs')

                            parallel_structs_Cb_Cb(day,block,Cb_lfp_chan,Cb_neuron_chan,Cb_neuron_num) = struct('Fs',param.Cb_Fs,'LFP_snapshot',squeeze(Cb_snapshots(Cb_lfp_chan,:,:)),'spike_times',Cb_struct_spikes,'save_path',[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Field_Coherence/Cb_Channel',num2str(param.Cb_good_chans(Cb_lfp_chan)),'/Cb_Ch',num2str(Cb_neuron_chan),'_code',num2str(Cb_neuron_num),'_coherence_data.mat']);
                        end
                    end
                end
            end
        end
    end
    
    parallel_structs = cat(6,parallel_structs_M1_M1,parallel_structs_M1_Cb,parallel_structs_Cb_M1,parallel_structs_Cb_Cb);
    %parpool('local',worker_num);
    parfor i = 1:length(parallel_structs(:))
        if ~isempty(parallel_structs(i).save_path)
            spike_field_par_calc(parallel_structs(i));
        end
    end
    delete(gcp('nocreate'))
    
    clear params parallel_structs parallel_structs_M1_M1 parallel_structs_M1_Cb parallel_structs_Cb_M1 parallel_structs_Cb_Cb worker_num kernel min_spikes day block M1_channels_of_interest M1_neurons_of_interest Cb_channels_of_interest Cb_neurons_of_interest;
    if isunix
        rmpath(genpath('/common/fleischerp/HPC_code'))
        rmpath(genpath('/common/fleischerp/3rd_party_code'))
    else
        rmpath(genpath('Z:/Matlab for analysis/chronux_2_10/chronux/spectral_analysis'))
    end
    
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Success vs. Fail for trajectory PCs (48)

if enabled(48)
    disp('Block 48...')
    factor_num = 1;
    include_preReach_epoch = true;
    include_postRetract_epoch = true;
    include_pellet_touch = true;
    
    if include_preReach_epoch
        start_mod = -250;
    else
        start_mod = 0; %#ok<UNRCH>
    end
    if include_postRetract_epoch
        end_mod = 0;
    else
        end_mod = -250;  %#ok<UNRCH>
    end
    
    for day=1:param.days
        load([rootpath,animal,'/Day',num2str(day),'/M1_2PC_factors.mat'])
        if size(D,1) == 1
            D = D';
        end
        if include_pellet_touch
            for block = 1:param.blocks
                load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/inter_event_intervals.mat']);
                reach_touch_interval(reach_touch_interval == -1) = [];
                if block == 1
                    day_reach_touch_interval = round(reach_touch_interval*100);
                else
                    day_reach_touch_interval = cat(1,day_reach_touch_interval,(reach_touch_interval*100));
                end
            end
            for i = 1:length(D)
                D(i).epochStarts = [D(i).epochStarts(1:2) (day_reach_touch_interval(i)+26) D(i).epochStarts(3)];
            end
        end
        
        D_interp = interpolate_trajectories(D);
        trial_outcomes = repmat(cellfun(@strcmp,{D.condition},repmat({'success'},1,length(D)))',1,3);
        [data_success, data_failure] = success_fail_split(D_interp,trial_outcomes,[],1);
        factor_data = cell(1,length(data_success));
        progression_x_axis = -250:10:(size(D_interp(1).data,2)*10)-260; 
        figure
        for trial = 1:length(data_success)
            time_step = (data_success(trial).T/size(data_success(trial).data,2)) * 10;
            x_axis = (data_success(trial).time_steps * 10) - 260;
            end_points = [find(x_axis>=start_mod,1), find(x_axis>=((data_success(trial).T*10) + (end_mod-260)),1)];
            %line(x_axis(end_points(1):end_points(2)), data_success(trial).data(factor_num,end_points(1):end_points(2)),'LineWidth',0.5, 'Color',[0.5 0.5 0.5]);
            line(progression_x_axis(end_points(1):end_points(2)), data_success(trial).data(factor_num,end_points(1):end_points(2)),'LineWidth',0.5, 'Color',[0.5 0.5 0.5]);
            factor_data{trial} = data_success(trial).data(factor_num,end_points(1):end_points(2));
        end
        
        trn_factor_data = zeros(trial, min(cellfun(@length,factor_data)));
        for trial = 1:length(data_success)
            trn_factor_data(trial,:) = factor_data{trial}(1:size(trn_factor_data,2));
        end
        mean_M1_succ_factor_data = mean(trn_factor_data,1);
        stdv_M1_succ_factor_data = std(trn_factor_data);
        line(progression_x_axis, mean_M1_succ_factor_data,'LineWidth',2.0, 'Color',[0 0 0]);
        if include_preReach_epoch
            line([0 0], [-1, 1], 'Color', 'green', 'LineStyle', '--')
        end
        if include_pellet_touch
            line([progression_x_axis(data_success(trial).epochStarts(3)) progression_x_axis(data_success(trial).epochStarts(3))], [-1, 1], 'Color', 'blue', 'LineStyle', '--')
        end
        if include_postRetract_epoch
            line([progression_x_axis(end-26) progression_x_axis(end-26)], [-1, 1], 'Color', 'black', 'LineStyle', '--')
        end
        
        title(['Factor ',num2str(factor_num),' for M1 successful trials. Standard deviation from the mean: ',num2str(round(mean(std(trn_factor_data,1)),2))])
        saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/M1_success_factor_',num2str(factor_num),'.fig']);
        close all
        
        figure
        for trial = 1:length(data_failure)
            time_step = (data_failure(trial).T/size(data_failure(trial).data,2)) * 10;
            x_axis = (data_failure(trial).time_steps * 10) - 260;
            end_points = [find(x_axis>=start_mod,1), find(x_axis>=((data_failure(trial).T*10) + (end_mod-260)),1)];
            %line(x_axis(end_points(1):end_points(2)), data_failure(trial).data(factor_num,end_points(1):end_points(2)),'LineWidth',0.5, 'Color',[0.5 0.5 0.5]);
            line(progression_x_axis(end_points(1):end_points(2)), data_failure(trial).data(factor_num,end_points(1):end_points(2)),'LineWidth',0.5, 'Color',[0.5 0.5 0.5]);
            factor_data{trial} = data_failure(trial).data(factor_num,end_points(1):end_points(2));
        end
        
        trn_factor_data = zeros(trial, min(cellfun(@length,factor_data)));
        for trial = 1:length(data_failure)
            trn_factor_data(trial,:) = factor_data{trial}(1:size(trn_factor_data,2));
        end
        mean_M1_fail_factor_data = mean(trn_factor_data,1);
        stdv_M1_fail_factor_data = sqrt(mean((trn_factor_data - mean_M1_succ_factor_data).^2,1));
        line(progression_x_axis, mean_M1_fail_factor_data,'LineWidth',2.0, 'Color',[0 0 0]);
        if include_preReach_epoch
            line([0 0], [-1, 1], 'Color', 'green', 'LineStyle', '--')
        end
        if include_pellet_touch
            line([progression_x_axis(data_failure(trial).epochStarts(3)) progression_x_axis(data_failure(trial).epochStarts(3))], [-1, 1], 'Color', 'blue', 'LineStyle', '--')
        end
        if include_postRetract_epoch
            line([progression_x_axis(end-26) progression_x_axis(end-26)], [-1, 1], 'Color', 'black', 'LineStyle', '--')
        end
        
        title(['Factor ',num2str(factor_num),' for M1 failure trials. Standard deviation from the mean: ',num2str(round(mean(std(trn_factor_data,1)),2))])
        saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/M1_failure_factor_',num2str(factor_num),'.fig']);
        close all
        
        figure
        line(progression_x_axis, stdv_M1_succ_factor_data,'LineWidth',2.0, 'Color',[0 .7 0]);
        line(progression_x_axis, stdv_M1_fail_factor_data,'LineWidth',2.0, 'Color',[.5 .5 .5]);
        if include_preReach_epoch
            line([0 0], [0, 1], 'Color', 'green', 'LineStyle', '--')
        end
        if include_pellet_touch
            line([progression_x_axis(data_failure(trial).epochStarts(3)) progression_x_axis(data_failure(trial).epochStarts(3))], [0, 1], 'Color', 'blue', 'LineStyle', '--')
        end
        if include_postRetract_epoch
            line([progression_x_axis(end-26) progression_x_axis(end-26)], [0, 1], 'Color', 'black', 'LineStyle', '--')
        end
        saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/M1_mean_deviation_from_factor_',num2str(factor_num),'_mean.fig']);
        close all
        
%         load([rootpath,animal,'/Day',num2str(day),'/Cb_2PC_factors.mat'])
%         if size(D,1) == 1
%             D = D';
%         end
%         if include_pellet_touch
%             for i = 1:length(D)
%                 D(i).epochStarts = [D(i).epochStarts(1:2) (day_reach_touch_interval(i)+26) D(i).epochStarts(3)];
%             end
%         end
%         
%         D_interp = interpolate_trajectories(D);
%         trial_outcomes = repmat(cellfun(@strcmp,{D.condition},repmat({'success'},1,length(D)))',1,3);
%         [data_success, data_failure] = success_fail_split(D_interp,trial_outcomes,[],1);
%         factor_data = cell(1,length(data_success));
%         progression_x_axis = -250:10:(size(D_interp(1).data,2)*10)-260;
%         figure
%         for trial = 1:length(data_success)
%             time_step = (data_success(trial).T/size(data_success(trial).data,2)) * 10;
%             x_axis = (data_success(trial).time_steps * 10) - 260;
%             end_points = [find(x_axis>=start_mod,1), find(x_axis>=((data_success(trial).T*10) + (end_mod-260)),1)];
%             %line(x_axis(end_points(1):end_points(2)), data_success(trial).data(factor_num,end_points(1):end_points(2)),'LineWidth',0.5, 'Color',[0.5 0.5 0.5]);
%             line(progression_x_axis(end_points(1):end_points(2)), data_success(trial).data(factor_num,end_points(1):end_points(2)),'LineWidth',0.5, 'Color',[0.5 0.5 0.5]);
%             factor_data{trial} = data_success(trial).data(factor_num,end_points(1):end_points(2));
%         end
%         
%         trn_factor_data = zeros(trial, min(cellfun(@length,factor_data)));
%         for trial = 1:length(data_success)
%             trn_factor_data(trial,:) = factor_data{trial}(1:size(trn_factor_data,2));
%         end
%         mean_Cb_succ_factor_data = mean(trn_factor_data,1);
%         stdv_Cb_succ_factor_data = std(trn_factor_data);
%         line(progression_x_axis, mean_Cb_succ_factor_data,'LineWidth',2.0, 'Color',[0 0 0]);
%         if include_preReach_epoch
%             line([0 0], [-1, 1], 'Color', 'green', 'LineStyle', '--')
%         end
%         if include_pellet_touch
%             line([progression_x_axis(data_success(trial).epochStarts(3)) progression_x_axis(data_success(trial).epochStarts(3))], [-1, 1], 'Color', 'blue', 'LineStyle', '--')
%         end
%         if include_postRetract_epoch
%             line([progression_x_axis(end-26) progression_x_axis(end-26)], [-1, 1], 'Color', 'black', 'LineStyle', '--')
%         end
%         
%         title(['Factor ',num2str(factor_num),' for Cb successful trials. Standard deviation from the mean: ',num2str(round(mean(std(trn_factor_data,1)),2))])
%         saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Cb_success_factor_',num2str(factor_num),'.fig']);
%         close all
%         
%         figure
%         for trial = 1:length(data_failure)
%             time_step = (data_failure(trial).T/size(data_failure(trial).data,2)) * 10;
%             x_axis = (data_failure(trial).time_steps * 10) - 260;
%             end_points = [find(x_axis>=start_mod,1), find(x_axis>=((data_failure(trial).T*10) + (end_mod-260)),1)];
%             %line(x_axis(end_points(1):end_points(2)), data_failure(trial).data(factor_num,end_points(1):end_points(2)),'LineWidth',0.5, 'Color',[0.5 0.5 0.5]);
%             line(progression_x_axis(end_points(1):end_points(2)), data_failure(trial).data(factor_num,end_points(1):end_points(2)),'LineWidth',0.5, 'Color',[0.5 0.5 0.5]);
%             factor_data{trial} = data_failure(trial).data(factor_num,end_points(1):end_points(2));
%         end
%         
%         trn_factor_data = zeros(trial, min(cellfun(@length,factor_data)));
%         for trial = 1:length(data_failure)
%             trn_factor_data(trial,:) = factor_data{trial}(1:size(trn_factor_data,2));
%         end
%         mean_Cb_fail_factor_data = mean(trn_factor_data,1);
%         stdv_Cb_fail_factor_data = sqrt(mean((trn_factor_data - mean_Cb_succ_factor_data).^2,1));
%         line(progression_x_axis, mean_Cb_fail_factor_data,'LineWidth',2.0, 'Color',[0 0 0]);
%         if include_preReach_epoch
%             line([0 0], [-1, 1], 'Color', 'green', 'LineStyle', '--')
%         end
%         if include_pellet_touch
%             line([progression_x_axis(data_failure(trial).epochStarts(3)) progression_x_axis(data_failure(trial).epochStarts(3))], [-1, 1], 'Color', 'blue', 'LineStyle', '--')
%         end
%         if include_postRetract_epoch
%             line([progression_x_axis(end-26) progression_x_axis(end-26)], [-1, 1], 'Color', 'black', 'LineStyle', '--')
%         end
%         
%         title(['Factor ',num2str(factor_num),' for Cb failure trials. Standard deviation from the mean: ',num2str(round(mean(std(trn_factor_data,1)),2))])
%         saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Cb_failure_factor_',num2str(factor_num),'.fig']);
%         close all
%         
%         figure
%         line(progression_x_axis, stdv_Cb_succ_factor_data,'LineWidth',2.0, 'Color',[0 .7 0]);
%         line(progression_x_axis, stdv_Cb_fail_factor_data,'LineWidth',2.0, 'Color',[.5 .5 .5]);
%         if include_preReach_epoch
%             line([0 0], [0, 1], 'Color', 'green', 'LineStyle', '--')
%         end
%         if include_pellet_touch
%             line([progression_x_axis(data_failure(trial).epochStarts(3)) progression_x_axis(data_failure(trial).epochStarts(3))], [0, 1], 'Color', 'blue', 'LineStyle', '--')
%         end
%         if include_postRetract_epoch
%             line([progression_x_axis(end-26) progression_x_axis(end-26)], [0, 1], 'Color', 'black', 'LineStyle', '--')
%         end
%         saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Cb_mean_deviation_from_factor_',num2str(factor_num),'_mean.fig']);
%         close all
    end
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Read Reach Tracjectory **Ref Only**(49)

if false
    disp('Block 49...')
    touch_only = true;
    load([rootpath,'I076/Shared_Data.mat'])
    shared_data.reach_trajectory_corr = nan(6,1);
    shared_data.reach_mean_velocity = cell(6,1);
    pre_margin = 0.5; %in seconds
    post_margin = 0.5; %in seconds
    conf_threshold = 0.95;
    prefixes = {'I076D1R1-(2020_12_7)-(12h20m)-';
                'I076D1R2-(2020_12_7)-(15h56m)-';
                'I076D1R2-2-(2020_12_7)-(16h21m)-';
                'I076D2R1-(2020_12_8)-(11h29m)-';
                'I076D2R2-(2020_12_8)-(15h28m)-';
                'I076D3R1-(2020_12_9)-(11h56m)-';
                'I076D3R2-(2020_12_9)-(15h0m)-';
                'I076D4R1-(2020_12_10)-(11h48m)-';
                'I076D4R2-(2020_12_10)-(14h34m)-';
                'I076D4R2-2-(2020_12_10)-(14h41m)-';
                'I076D5R1-(2020_12_11)-(11h38m)-';
                'I076D5R1-2-(2020_12_11)-(12h2m)-';
                'I076D5R2-(2020_12_11)-(14h22m)-';
                'I076D6R-(2020_12_12)-(11h16m)-';
                'I076D6R-2-(2020_12_12)-(11h18m)-';
                'I076D6R-3-(2020_12_12)-(11h28m)-';
                'I076D6R-4-(2020_12_12)-(11h38m)-';
                'I076D6R-5-(2020_12_12)-(11h44m)-'};
    prefix_idx = 0;
    for day=1:6
        load(['Z:\M1_Cb_Reach\I076\Day',num2str(day),'\Results\D',num2str(day),'_GUI.mat'])
        successes = [1];
        fails = [0];
        %filelist = dir(['Z:\M1_Cb_Reach\I076\DLC_Data\Day',num2str(day),'\*.csv']);
        
        max_frames = 0; 
        for trial = 1:size(data,1)
            frame_nums = str2num(data{trial,2}); 
            outcome = str2num(data{trial,3}); 
            if sum(outcome == successes)
                reach_onset = frame_nums(end-2);
                touch = frame_nums(end-1);
            elseif sum(outcome == fails) && frame_nums(end) == 1
                reach_onset = frame_nums(end-4);
                touch = frame_nums(end-3);
            else
                continue; 
            end
            if touch_only
                reach_onset = touch;
            end
            frames = touch - reach_onset; %This is technicly frames-1. This works as intended. 
            if frames > max_frames
                max_frames = frames;
            end
        end
        
        
        x_coords = nan(size(data,1),max_frames+1 + round(param.Camera_framerate * pre_margin) + round(param.Camera_framerate * post_margin));
        y_coords = nan(size(data,1),max_frames+1 + round(param.Camera_framerate * pre_margin) + round(param.Camera_framerate * post_margin));
        x_veloc = nan(size(data,1),max_frames + round(param.Camera_framerate * pre_margin) + round(param.Camera_framerate * post_margin));
        y_veloc = nan(size(data,1),max_frames + round(param.Camera_framerate * pre_margin) + round(param.Camera_framerate * post_margin));
            
        for trial = 1:size(data,1)
            trial_num = str2num(data{trial,1}); %#ok<ST2NM>
            frame_nums = str2num(data{trial,2}); %#ok<ST2NM>
            outcome = str2num(data{trial,3}); %#ok<ST2NM>
            if trial_num == 1
                prefix_idx = prefix_idx+1;
            end
            if sum(outcome == successes)
                reach_onset = frame_nums(end-2);
                touch = frame_nums(end-1);
            elseif sum(outcome == fails) && frame_nums(end) == 1
                reach_onset = frame_nums(end-4);
                touch = frame_nums(end-3);
            else
                continue; 
            end
            if touch_only
                reach_onset = touch;
            end
            r_traj_data = readtable(['Z:\M1_Cb_Reach\I076\DLC_Data\Day', num2str(day), '\', prefixes{prefix_idx}, num2str(trial_num), 'DLC_resnet_50_ReachFeb5shuffle1_256500.csv'], 'HeaderLines',3);
            if touch ~= reach_onset
                interp_frames = reach_onset:(touch - reach_onset)/max_frames:touch;
                interp_diff_frames = reach_onset:(((touch-1) - reach_onset)/(max_frames-1)):(touch-1);
            end
            window_start = reach_onset - round(param.Camera_framerate * pre_margin);
            window_end = touch + round(param.Camera_framerate * post_margin);
            
            %TODO later: account for rat handedness. r/n right hand hardcoded.
            raw_traj = table2array(r_traj_data(reach_onset:touch,5:7));
            if touch_only
                if raw_traj(1,3) < conf_threshold
                    continue; %confidence at touch too low.
                end
            else
                low_conf_idx = raw_traj(:,3) < conf_threshold;
                frame_nums = 1:length(low_conf_idx);
                frame_nums(low_conf_idx) = [];
                good_x_coords = raw_traj(~low_conf_idx,1);
                good_y_coords = raw_traj(~low_conf_idx,2);
                raw_traj(:,1) = interp1(frame_nums,good_x_coords,1:length(low_conf_idx));
                raw_traj(:,2) = interp1(frame_nums,good_y_coords,1:length(low_conf_idx));
            end
            
            x_raw_diff = diff(raw_traj(:,1));
            y_raw_diff = diff(raw_traj(:,2));
            if touch == reach_onset
                x_interp = raw_traj(:,1);
                y_interp = raw_traj(:,2);
                x_interp_diff = x_raw_diff;
                y_interp_diff = y_raw_diff;
            else
                x_interp = interp1(reach_onset:touch,raw_traj(:,1),interp_frames);
                y_interp = interp1(reach_onset:touch,raw_traj(:,2),interp_frames);
                x_interp_diff = interp1(reach_onset:(touch-1),x_raw_diff,interp_diff_frames);
                y_interp_diff = interp1(reach_onset:(touch-1),y_raw_diff,interp_diff_frames);
            end
            pre_traj = table2array(r_traj_data(window_start:reach_onset,5:7));
            post_traj = table2array(r_traj_data(touch:window_end,5:7));
            
            low_conf_idx = pre_traj(:,3) < conf_threshold;
            frame_nums = 1:length(low_conf_idx);
            frame_nums(low_conf_idx) = [];
            good_x_coords = pre_traj(~low_conf_idx,1);
            good_y_coords = pre_traj(~low_conf_idx,2);
            pre_traj(:,1) = interp1(frame_nums,good_x_coords,1:length(low_conf_idx));
            pre_traj(:,2) = interp1(frame_nums,good_y_coords,1:length(low_conf_idx));
            pre_traj(1:(frame_nums(1)-1),1) = pre_traj(frame_nums(1),1);
            pre_traj(frame_nums(end)+1:end,1) = pre_traj(frame_nums(end),1);
            pre_traj(1:(frame_nums(1)-1),2) = pre_traj(frame_nums(1),2);
            pre_traj(frame_nums(end)+1:end,2) = pre_traj(frame_nums(end),2);
            
            low_conf_idx = post_traj(:,3) < conf_threshold;
            frame_nums = 1:length(low_conf_idx);
            frame_nums(low_conf_idx) = [];
            good_x_coords = post_traj(~low_conf_idx,1);
            good_y_coords = post_traj(~low_conf_idx,2);
            post_traj(:,1) = interp1(frame_nums,good_x_coords,1:length(low_conf_idx));
            post_traj(:,2) = interp1(frame_nums,good_y_coords,1:length(low_conf_idx));
            post_traj(1:(frame_nums(1)-1),1) = post_traj(frame_nums(1),1);
            post_traj(frame_nums(end)+1:end,1) = post_traj(frame_nums(end),1);
            post_traj(1:(frame_nums(1)-1),2) = post_traj(frame_nums(1),2);
            post_traj(frame_nums(end)+1:end,2) = post_traj(frame_nums(end),2);
            
            x_traj = [pre_traj(1:end-1,1); x_interp'; post_traj(2:end,1)];
            y_traj = [pre_traj(1:end-1,2); y_interp'; post_traj(2:end,2)];
            x_diff = [diff(pre_traj(:,1)); x_interp_diff'; diff(post_traj(:,1))];
            y_diff = [diff(pre_traj(:,2)); y_interp_diff'; diff(post_traj(:,2))];
            x_coords(trial,:) = x_traj';
            y_coords(trial,:) = -y_traj';
            x_veloc(trial,:) = x_diff';
            y_veloc(trial,:) = -y_diff';
            
            line(x_coords(trial,:),y_coords(trial,:),'Color', [.6 .6 .6], 'LineWidth', .5)
        end
        %calc mean position
        x_coords(isnan(x_coords(:,1)),:) = [];
        y_coords(isnan(y_coords(:,1)),:) = [];
        x_mean = mean(x_coords,1);
        y_mean = mean(y_coords,1);
        line(x_mean,y_mean,'Color', [1 .9 0], 'LineWidth', 1.5)
        saveas(gcf,['D:\Pierson_Data_Analysis\I076\Day', num2str(day), '\Reach_Trajectory.fig'])
        close all;
        
        %calculate trajectory correlation
        x_corr = corr(x_coords', x_mean');
        y_corr = corr(y_coords', y_mean');
        shared_data.reach_trajectory_corr(day) = mean([x_corr(:); y_corr(:)]);
        
        %calc mean velocity
        x_veloc(isnan(x_veloc(:,1)),:) = [];
        y_veloc(isnan(y_veloc(:,1)),:) = [];
        x_mean = mean(x_veloc,1);
        y_mean = mean(y_veloc,1);
        shared_data.reach_mean_velocity{day} = [x_mean; y_mean];
    end
    
    color_grad = [[0:1/(6-1):1]', zeros(6,1), [1:-1/(6-1):0]'];
    veloc_time_axis = ((0.5)-round(param.Camera_framerate * pre_margin):round(param.Camera_framerate * post_margin)-(0.5)) / param.Camera_framerate;
    figure
    for day = 1:6
        line(veloc_time_axis, shared_data.reach_mean_velocity{day}(1,:), 'Color', color_grad(day,:));
    end
    legend('Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5', 'Day 6')
    saveas(gcf,['D:\Pierson_Data_Analysis\I076\X_velocity_profile.fig'])
    close all;
    
    figure
    for day = 1:6
        line(veloc_time_axis, shared_data.reach_mean_velocity{day}(2,:), 'Color', color_grad(day,:));
    end
    legend('Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5', 'Day 6')
    saveas(gcf,['D:\Pierson_Data_Analysis\I076\Y_velocity_profile.fig'])
    close all;

    save([rootpath,'I076/Shared_Data.mat'], 'shared_data'); 
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Successful vs. Unsuccessful neuron PETHs and cross-bin Fano Factor (50)

if enabled(50)
    disp('Block 50...')
    bin_width = 25; %in miliseconds
    bin_edges = 0:bin_width:8000;
    bin_centers = (bin_width/2):bin_width:(8000-(bin_width/2));
    FF_window_pre = -250;
    FF_window_post = 750;
    FF_bin_idxs = (bin_centers >= (4000-FF_window_pre)) & (bin_centers <= (4000+FF_window_post));
    FF_x_axis = {'Day 1 S'; 'Day 1 F'; 'Day 2 S'; 'Day 2 F'; 'Day 3 S'; 'Day 3 F'; 'Day 4 S'; 'Day 4 F'; 'Day 5 S'; 'Day 5 F'};
    FF_M1_succ_mean = nan(1,param.days);
    FF_M1_fail_mean = nan(1,param.days);
    FF_Cb_succ_mean = nan(1,param.days);
    FF_Cb_fail_mean = nan(1,param.days);
    
    FF_M1_succ_stdv = nan(1,param.days);
    FF_M1_fail_stdv = nan(1,param.days);
    FF_Cb_succ_stdv = nan(1,param.days);
    FF_Cb_fail_stdv = nan(1,param.days);
    for day=1:param.days
        M1_neurons_of_interest = param.M1_task_related_neurons{day};
        Cb_neurons_of_interest = param.Cb_task_related_neurons{day};
        M1_day_succ_count = 0;
        M1_day_fail_count = 0;
        Cb_day_succ_count = 0;
        Cb_day_fail_count = 0;
        
        if ~exist([rootpath,animal,'/Day',num2str(day),'/Spike_Figures'],'dir')
            mkdir([rootpath,animal,'/Day',num2str(day),'/Spike_Figures']);
        end
        
        M1_succ_hist_sum = zeros(param.M1_chans, param.M1_neurons, length(bin_centers));
        M1_fail_hist_sum = zeros(param.M1_chans, param.M1_neurons, length(bin_centers));
        Cb_succ_hist_sum = zeros(param.Cb_chans, param.Cb_neurons, length(bin_centers));
        Cb_fail_hist_sum = zeros(param.Cb_chans, param.Cb_neurons, length(bin_centers));
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/spiketrain_snapshots_full.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_timestamps.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            
            outcomes = cellfun(@str2double,data(:,3)); %Do not use bad trials from file, noisey trials don't matter just like noisey channels don't
            bad_trials = 1:size(data,1);
            bad_trials(outcomes < 2) = [];
            
            [M1_successes, M1_fails] = success_fail_split(M1_spike_snapshots_full, data, bad_trials,3);
            [Cb_successes, Cb_fails] = success_fail_split(Cb_spike_snapshots_full, data, bad_trials,3);
            [M1_chans, M1_codes, M1_succ_trials] = size(M1_successes);
            M1_fail_trials = size(M1_fails,3);
            [Cb_chans, Cb_codes, Cb_succ_trials] = size(Cb_successes);
            Cb_fail_trials = size(Cb_fails,3);
            M1_day_succ_count = M1_day_succ_count + M1_succ_trials;
            M1_day_fail_count = M1_day_fail_count + M1_fail_trials;
            Cb_day_succ_count = Cb_day_succ_count + Cb_succ_trials;
            Cb_day_fail_count = Cb_day_fail_count + Cb_fail_trials;
            
            for chan = 1:M1_chans
                for code = 1:M1_codes
                    if isempty(M1_spike_timestamps{chan, code}) || ~M1_neurons_of_interest(chan, code)
                        continue
                    end
                    
                    for trial = 1:M1_succ_trials
                        timestamps = M1_successes{chan, code, trial} * (1000/param.M1_Fs);
                        trial_hist = histcounts(timestamps,bin_edges);
                        M1_succ_hist_sum(chan, code, :) = squeeze(M1_succ_hist_sum(chan, code, :))' + trial_hist;
                    end
                                        
                    for trial = 1:M1_fail_trials
                        timestamps = M1_fails{chan, code, trial} * (1000/param.M1_Fs);
                        trial_hist = histcounts(timestamps,bin_edges);
                        M1_fail_hist_sum(chan, code, :) = squeeze(M1_fail_hist_sum(chan, code, :))' + trial_hist;
                    end
                end
            end
            
            neuron_num = 1;
            for chan = 1:Cb_chans
                for code = 1:Cb_codes
                    if isempty(Cb_spike_timestamps{chan, code}) || ~Cb_neurons_of_interest(chan, code)
                        continue
                    end
            
                    for trial = 1:Cb_succ_trials
                        timestamps = Cb_successes{chan, code, trial} * (1000/param.Cb_Fs);
                        trial_hist = histcounts(timestamps,bin_edges);
                        Cb_succ_hist_sum(chan, code, :) = squeeze(Cb_succ_hist_sum(chan, code, :))' + trial_hist;
                    end
                    
                    for trial = 1:Cb_fail_trials
                        timestamps = Cb_fails{chan, code, trial} * (1000/param.Cb_Fs);
                        trial_hist = histcounts(timestamps,bin_edges);
                        Cb_fail_hist_sum(chan, code, :) = squeeze(Cb_fail_hist_sum(chan, code, :))' + trial_hist;
                    end
                end
            end
        end
        
        M1_succ_hist_sum = M1_succ_hist_sum * (1000/(bin_width * M1_day_succ_count)); %convert to spikes/sec
        Cb_succ_hist_sum = Cb_succ_hist_sum * (1000/(bin_width * Cb_day_succ_count)); %convert to spikes/sec
        
        M1_fail_hist_sum = M1_fail_hist_sum * (1000/(bin_width * M1_day_fail_count)); %convert to spikes/sec
        Cb_fail_hist_sum = Cb_fail_hist_sum * (1000/(bin_width * Cb_day_fail_count)); %convert to spikes/sec
        
        neuron_idx = 0;
        FF_M1_succ = nan(1,sum(sum(~(cellfun(@isempty,M1_spike_timestamps) | ~M1_neurons_of_interest),2),1));
        FF_M1_fail = nan(1,sum(sum(~(cellfun(@isempty,M1_spike_timestamps) | ~M1_neurons_of_interest),2),1));
        for chan = 1:M1_chans
            for code = 1:M1_codes
                if isempty(M1_spike_timestamps{chan, code}) || ~M1_neurons_of_interest(chan, code)
                    continue
                end
                neuron_idx = neuron_idx+1;
                
                bar(bin_centers, squeeze(M1_succ_hist_sum(chan, code, :)))
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Spike_Figures/M1_firing_rate_channel', num2str(chan), '_cell', num2str(code), '_success.fig']);
                close all
                
                bar(bin_centers, squeeze(M1_fail_hist_sum(chan, code, :)))
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Spike_Figures/M1_firing_rate_channel', num2str(chan), '_cell', num2str(code), '_failure.fig']);
                close all
                
                hold on
                line(bin_centers, squeeze(M1_succ_hist_sum(chan, code, :)),'Color','blue')
                line(bin_centers, squeeze(M1_fail_hist_sum(chan, code, :)),'Color','red')
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Spike_Figures/M1_firing_rate_channel', num2str(chan), '_cell', num2str(code), '_vs.fig']);
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Spike_Figures/M1_firing_rate_channel', num2str(chan), '_cell', num2str(code), '_vs.tiff']);
                hold off
                close all
                
                FF_M1_succ(neuron_idx) = var(M1_succ_hist_sum(chan, code, FF_bin_idxs))/mean(M1_succ_hist_sum(chan, code, FF_bin_idxs));
                FF_M1_fail(neuron_idx) = var(M1_fail_hist_sum(chan, code, FF_bin_idxs))/mean(M1_fail_hist_sum(chan, code, FF_bin_idxs));
            end
        end
        
        neuron_idx = 0;
        FF_Cb_succ = nan(1,sum(sum(~(cellfun(@isempty,Cb_spike_timestamps) | ~Cb_neurons_of_interest),2),1));
        FF_Cb_fail = nan(1,sum(sum(~(cellfun(@isempty,Cb_spike_timestamps) | ~Cb_neurons_of_interest),2),1));
        for chan = 1:Cb_chans
            for code = 1:Cb_codes
                if isempty(Cb_spike_timestamps{chan, code}) || ~Cb_neurons_of_interest(chan, code)
                    continue
                end
                neuron_idx = neuron_idx+1;
                
                bar(bin_centers, squeeze(Cb_succ_hist_sum(chan, code, :)))
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Spike_Figures/Cb_firing_rate_channel', num2str(chan), '_cell', num2str(code), '_success.fig']);
                close all
                
                bar(bin_centers, squeeze(Cb_fail_hist_sum(chan, code, :)))
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Spike_Figures/Cb_firing_rate_channel', num2str(chan), '_cell', num2str(code), '_failure.fig']);
                close all
                
                hold on
                line(bin_centers, squeeze(Cb_succ_hist_sum(chan, code, :)),'Color','blue')
                line(bin_centers, squeeze(Cb_fail_hist_sum(chan, code, :)),'Color','red')
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Spike_Figures/Cb_firing_rate_channel', num2str(chan), '_cell', num2str(code), '_vs.fig']);
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Spike_Figures/Cb_firing_rate_channel', num2str(chan), '_cell', num2str(code), '_vs.tiff']);
                hold off
                close all
                
                FF_Cb_succ(neuron_idx) = var(Cb_succ_hist_sum(chan, code, FF_bin_idxs))/mean(Cb_succ_hist_sum(chan, code, FF_bin_idxs));
                FF_Cb_fail(neuron_idx) = var(Cb_fail_hist_sum(chan, code, FF_bin_idxs))/mean(Cb_fail_hist_sum(chan, code, FF_bin_idxs));
            end
        end
        FF_M1_succ(isnan(FF_M1_succ)) = 0; %nans occur when no spikes fall within the range
        FF_M1_fail(isnan(FF_M1_fail)) = 0; %nans occur when no spikes fall within the range
        FF_Cb_succ(isnan(FF_Cb_succ)) = 0; %nans occur when no spikes fall within the range
        FF_Cb_fail(isnan(FF_Cb_fail)) = 0; %nans occur when no spikes fall within the range
        
        FF_M1_succ_mean(day) = mean(FF_M1_succ);
        FF_M1_fail_mean(day) = mean(FF_M1_fail);
        FF_Cb_succ_mean(day) = mean(FF_Cb_succ);
        FF_Cb_fail_mean(day) = mean(FF_Cb_fail);
        
        FF_M1_succ_stdv(day) = std(FF_M1_succ);
        FF_M1_fail_stdv(day) = std(FF_M1_fail);
        FF_Cb_succ_stdv(day) = std(FF_Cb_succ);
        FF_Cb_fail_stdv(day) = std(FF_Cb_fail);
    end
    er = errorbar(1:2:10, FF_M1_succ_mean, FF_M1_succ_stdv, FF_M1_succ_stdv);
    er.Color = [0 0 1];                            
    er.LineStyle = 'none';
    hold on
    scatter(1:2:10, FF_M1_succ_mean, 'b.', 'SizeData', 200)
    
    er = errorbar(2:2:10, FF_M1_fail_mean, FF_M1_fail_stdv, FF_M1_fail_stdv);
    er.Color = [1 0 0];                            
    er.LineStyle = 'none';
    scatter(2:2:10, FF_M1_fail_mean, 'r.', 'SizeData', 200)
    
    xticklabels(FF_x_axis);
    xtickangle(60);
    xlim([0 11])
    hold off
    saveas(gcf,[rootpath,animal,'/M1_Fano_factor.fig']);
    close all
    
    er = errorbar(1:2:10, FF_Cb_succ_mean, FF_Cb_succ_stdv, FF_Cb_succ_stdv);
    er.Color = [0 0 1];                            
    er.LineStyle = 'none';
    hold on
    scatter(1:2:10, FF_Cb_succ_mean, 'b.', 'SizeData', 200)
    
    er = errorbar(2:2:10, FF_Cb_fail_mean, FF_Cb_fail_stdv, FF_Cb_fail_stdv);
    er.Color = [1 0 0];                            
    er.LineStyle = 'none';
    scatter(2:2:10, FF_Cb_fail_mean, 'r.', 'SizeData', 200)
    
    xticklabels(FF_x_axis);
    xtickangle(60);
    xlim([0 11])
    hold off
    saveas(gcf,[rootpath,animal,'/Cb_Fano_factor.fig']);
    close all
end

%% Successful vs. Unsuccessful cross-trial Fano Factor (51)

if enabled(51)
    disp('Block 51...')
    bin_width = 100; %in miliseconds
    bin_edges = 0:bin_width:8000;
    bin_centers = (bin_width/2):bin_width:(8000-(bin_width/2));
    FF_window_pre = 300; %in miliseconds
    FF_window_post = 800; %in miliseconds
    FF_bin_idxs = (bin_centers >= (4000-FF_window_pre)) & (bin_centers <= (4000+FF_window_post));
    for day=1:param.days
        if ~exist([rootpath,animal,'/Day',num2str(day),'/Spike_Figures'],'dir')
            mkdir([rootpath,animal,'/Day',num2str(day),'/Spike_Figures']);
        end
        
        M1_neurons_of_interest = param.M1_task_related_neurons{day};
        Cb_neurons_of_interest = param.Cb_task_related_neurons{day};
        
        M1_spikes_succ = cell(param.M1_chans, param.M1_neurons, 0);
        M1_spikes_fail = cell(param.M1_chans, param.M1_neurons, 0);
        Cb_spikes_succ = cell(param.Cb_chans, param.Cb_neurons, 0);
        Cb_spikes_fail = cell(param.Cb_chans, param.Cb_neurons, 0);
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/spiketrain_snapshots_full.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_timestamps.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            
            outcomes = cellfun(@str2double,data(:,3)); %Do not use bad trials from file, noisey trials don't matter just like noisey channels don't
            bad_trials = 1:size(data,1);
            bad_trials(outcomes < 2) = [];
            
            [M1_successes, M1_fails] = success_fail_split(M1_spike_snapshots_full, data, bad_trials,3);
            [Cb_successes, Cb_fails] = success_fail_split(Cb_spike_snapshots_full, data, bad_trials,3);
            M1_spikes_succ = cat(3, M1_spikes_succ, M1_successes);
            M1_spikes_fail = cat(3, M1_spikes_fail, M1_fails);
            Cb_spikes_succ = cat(3, Cb_spikes_succ, Cb_successes);
            Cb_spikes_fail = cat(3, Cb_spikes_fail, Cb_fails);
        end
        [M1_chans, M1_codes, M1_succ_trials] = size(M1_spikes_succ);
        M1_fail_trials = size(M1_spikes_fail,3);
        [Cb_chans, Cb_codes, Cb_succ_trials] = size(Cb_spikes_succ);
        Cb_fail_trials = size(Cb_spikes_fail,3);
        M1_neuron_FF_succ = nan(M1_chans, M1_codes, length(bin_centers));
        M1_neuron_FF_fail = nan(M1_chans, M1_codes, length(bin_centers));
        Cb_neuron_FF_succ = nan(Cb_chans, Cb_codes, length(bin_centers));
        Cb_neuron_FF_fail = nan(Cb_chans, Cb_codes, length(bin_centers));
        for chan = 1:M1_chans
            for code = 1:M1_codes
                if isempty(M1_spike_timestamps{chan, code}) || ~M1_neurons_of_interest(chan, code)
                    continue
                end
                all_trials_hist = nan(M1_succ_trials, length(bin_centers));
                for trial = 1:M1_succ_trials
                    timestamps = M1_spikes_succ{chan, code, trial} * (1000/param.M1_Fs);
                    all_trials_hist(trial, :) = histcounts(timestamps,bin_edges);
                end
                bin_mean = mean(all_trials_hist, 1);
                bin_var = var(all_trials_hist, 0, 1);
                M1_neuron_FF_succ(chan, code, :) = bin_var ./ bin_mean;
                
                all_trials_hist = nan(M1_fail_trials, length(bin_centers));
                for trial = 1:M1_fail_trials
                    timestamps = M1_spikes_fail{chan, code, trial} * (1000/param.M1_Fs);
                    all_trials_hist(trial, :) = histcounts(timestamps,bin_edges);
                end
                bin_mean = mean(all_trials_hist, 1);
                bin_var = var(all_trials_hist, 0, 1);
                M1_neuron_FF_fail(chan, code, :) = bin_var ./ bin_mean;
                
                hold on
                line(bin_centers(FF_bin_idxs), squeeze(M1_neuron_FF_succ(chan, code, FF_bin_idxs)),'Color', 'Blue')
                line(bin_centers(FF_bin_idxs), squeeze(M1_neuron_FF_fail(chan, code, FF_bin_idxs)),'Color', 'Red')%'r.', 'SizeData', 200)
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Spike_Figures/M1_FF_channel', num2str(chan), '_cell', num2str(code), '.fig']);
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Spike_Figures/M1_FF_channel', num2str(chan), '_cell', num2str(code), '.tiff']);
                hold off
                close all
            end
        end
        
        for chan = 1:Cb_chans
            for code = 1:Cb_codes
                if isempty(Cb_spike_timestamps{chan, code}) || ~Cb_neurons_of_interest(chan, code)
                    continue
                end
                all_trials_hist = nan(Cb_succ_trials, length(bin_centers));
                for trial = 1:Cb_succ_trials
                    timestamps = Cb_spikes_succ{chan, code, trial} * (1000/param.Cb_Fs);
                    all_trials_hist(trial, :) = histcounts(timestamps,bin_edges);
                end
                bin_mean = mean(all_trials_hist, 1);
                bin_var = var(all_trials_hist, 0, 1);
                Cb_neuron_FF_succ(chan, code, :) = bin_var ./ bin_mean;
                
                all_trials_hist = nan(Cb_fail_trials, length(bin_centers));
                for trial = 1:Cb_fail_trials
                    timestamps = Cb_spikes_fail{chan, code, trial} * (1000/param.Cb_Fs);
                    all_trials_hist(trial, :) = histcounts(timestamps,bin_edges);
                end
                bin_mean = mean(all_trials_hist, 1);
                bin_var = var(all_trials_hist, 0, 1);
                Cb_neuron_FF_fail(chan, code, :) = bin_var ./ bin_mean;
                
                hold on
                line(bin_centers(FF_bin_idxs), squeeze(Cb_neuron_FF_succ(chan, code, FF_bin_idxs)),'Color', 'Blue')
                line(bin_centers(FF_bin_idxs), squeeze(Cb_neuron_FF_fail(chan, code, FF_bin_idxs)),'Color', 'Red')
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Spike_Figures/Cb_FF_channel', num2str(chan), '_cell', num2str(code), '.fig']);
                saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Spike_Figures/Cb_FF_channel', num2str(chan), '_cell', num2str(code), '.tiff']);
                hold off
                close all
            end
        end
        
        
        M1_mean_FF_succ = nan(1, sum(FF_bin_idxs));
        M1_mean_FF_fail = nan(1, sum(FF_bin_idxs));
        Cb_mean_FF_succ = nan(1, sum(FF_bin_idxs));
        Cb_mean_FF_fail = nan(1, sum(FF_bin_idxs));
        idx = 0;
        for bin = find(FF_bin_idxs)
            idx = idx+1;
            bin_data = M1_neuron_FF_succ(:,:,bin);
            M1_mean_FF_succ(idx) = nanmean(bin_data(:));
            bin_data = M1_neuron_FF_fail(:,:,bin);
            M1_mean_FF_fail(idx) = nanmean(bin_data(:));
            bin_data = Cb_neuron_FF_succ(:,:,bin);
            Cb_mean_FF_succ(idx) = nanmean(bin_data(:));
            bin_data = Cb_neuron_FF_fail(:,:,bin);
            Cb_mean_FF_fail(idx) = nanmean(bin_data(:));
            
            %standard deviations go here
        end
        
        hold on
        line(bin_centers(FF_bin_idxs), M1_mean_FF_succ,'Color', 'Blue')
        line(bin_centers(FF_bin_idxs), M1_mean_FF_fail,'Color', 'Red')
        saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/FF_bins_M1.fig']);
        hold off
        close all
        
        hold on
        line(bin_centers(FF_bin_idxs), Cb_mean_FF_succ,'Color', 'Blue')
        line(bin_centers(FF_bin_idxs), Cb_mean_FF_fail,'Color', 'Red')
        saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/FF_bins_Cb.fig']);
        hold off
        close all
    end
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Day 5 Success vs Fail Spike Occurence to Filtered LFP Phase (52) !!Obsolete, now built into (40)!!

if false
    addpath('Z:\Matlab for analysis\circStat2008\sis_data\matlab code\nhp data\MATLAB files\circStat2008'); %#ok<UNRCH>
    
    day = 5;
    edge_exp = -5:0.1:5;
    edges = exp(edge_exp);
    bin_centers = edges(1:end-1) + diff(edges)/2;
    window_start = 3.75;
    window_end = 4.75;
    
    %Notes: I086, M1: 16 has even better S vs F but bad D1 vs D5
    M1_channels_of_interest = [12]; %  I060: 12 I076: 15 I061: 29 I064: 28 I086: 9  I089: 2, 26
    Cb_channels_of_interest = [23]; %  I060: 8  I076: 23 I061: 20 I064: 17 I086: 57 I089: 7
    if isempty(M1_channels_of_interest)
        M1_channels_of_interest = 1:param.M1_chans;
    end
    if isempty(Cb_channels_of_interest)
        Cb_channels_of_interest = 1:param.Cb_chans;
    end
    M1_channels_of_interest = find(ismember(param.M1_good_chans, M1_channels_of_interest));
    Cb_channels_of_interest = find(ismember(param.Cb_good_chans, Cb_channels_of_interest));
    
    M1_neurons_of_interest = param.M1_task_related_neurons;
    Cb_neurons_of_interest = param.Cb_task_related_neurons;
    if isempty(M1_neurons_of_interest)
        M1_neurons_of_interest = {ones(param.M1_chans,param.M1_neurons), ones(param.M1_chans,param.M1_neurons), ones(param.M1_chans,param.M1_neurons), ones(param.M1_chans,param.M1_neurons), ones(param.M1_chans,param.M1_neurons)};
    end
    if isempty(Cb_neurons_of_interest)
        Cb_neurons_of_interest = {ones(param.Cb_chans,param.Cb_neurons), ones(param.Cb_chans,param.Cb_neurons), ones(param.Cb_chans,param.Cb_neurons), ones(param.Cb_chans,param.Cb_neurons), ones(param.Cb_chans,param.Cb_neurons)};
    end
        
    M1_min_spikes = 8;
    Cb_min_spikes = 4;
    
    M1Ch_M1Nrn_stats = cell(1,2);
    M1Ch_CbNrn_stats = cell(1,2);
    CbCh_M1Nrn_stats = cell(1,2);
    CbCh_CbNrn_stats = cell(1,2);
    
    M1Ch_M1Nrn_spike_phase = cell(param.M1_chans,param.M1_chans,param.M1_neurons,2);
    M1Ch_CbNrn_spike_phase = cell(param.M1_chans,param.Cb_chans,param.Cb_neurons,2);
    CbCh_M1Nrn_spike_phase = cell(param.Cb_chans,param.M1_chans,param.M1_neurons,2);
    CbCh_CbNrn_spike_phase = cell(param.Cb_chans,param.Cb_chans,param.Cb_neurons,2);
    for block=1:param.blocks
        if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data'],'dir')
            mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data']);
        end
        load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Normalized_Snapshots', '.mat']);
        load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Filtered_LFP_Snapshots.mat']); %M1_1_4_snapshots
        load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/spiketrain_snapshots_full.mat']);
        load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat']);
        load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
        load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/neuron_firing_rates.mat']);
        
        M1_spike_snapshots_full(~param.M1_task_related_neurons{day}(:,:,ones(1,size(M1_spike_snapshots_full,3)))) = cell(1);
        Cb_spike_snapshots_full(~param.Cb_task_related_neurons{day}(:,:,ones(1,size(Cb_spike_snapshots_full,3)))) = cell(1);
        
        trial_codes = str2double(data(:,3));
        no_reach_trials = (1:size(data,1));
        no_reach_trials = no_reach_trials(trial_codes>1);
        
        all_bad_trials = union(M1_bad_trials, Cb_bad_trials);
        [M1_snapshots, Cb_snapshots] = get_common_good_data(M1_snapshots, Cb_snapshots, M1_bad_trials, Cb_bad_trials, 3);
        [M1_spike_snapshots, ~] = get_common_good_data(M1_spike_snapshots_full, M1_snapshots, no_reach_trials, all_bad_trials, 3);
        [Cb_spike_snapshots, ~] = get_common_good_data(Cb_spike_snapshots_full, Cb_snapshots, no_reach_trials, all_bad_trials, 3);
        [M1_filt, Cb_filt] = get_common_good_data(M1_1_4_snapshots, Cb_1_4_snapshots, M1_bad_trials, Cb_bad_trials, 3);
        
        
        [M1_snapshots_succ, M1_snapshots_fail] = success_fail_split(M1_snapshots,data,all_bad_trials,3);
        [Cb_snapshots_succ, Cb_snapshots_fail] = success_fail_split(Cb_snapshots,data,all_bad_trials,3);
        [M1_spike_snapshots_succ, M1_spike_snapshots_fail] = success_fail_split(M1_spike_snapshots,data,all_bad_trials,3);
        [Cb_spike_snapshots_succ, Cb_spike_snapshots_fail] = success_fail_split(Cb_spike_snapshots,data,all_bad_trials,3);
        [M1_filt_succ, M1_filt_fail] = success_fail_split(M1_filt,data,all_bad_trials,3);
        [Cb_filt_succ, Cb_filt_fail] = success_fail_split(Cb_filt,data,all_bad_trials,3);
        
        M1_snapshots = M1_snapshots_succ;
        Cb_snapshots = Cb_snapshots_succ;
        M1_spike_snapshots = M1_spike_snapshots_succ;
        Cb_spike_snapshots = Cb_spike_snapshots_succ;
        M1_filt = M1_filt_succ;
        Cb_filt = Cb_filt_succ;
        for lfp_chan = 1:length(M1_channels_of_interest)
            if ismember(param.M1_good_chans(lfp_chan),M1_channels_of_interest)
                if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(lfp_chan))],'dir')
                    mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(lfp_chan))]);
                end
                neuron_idx = 0;
                for s_chan = 1:param.M1_chans
                    for code = 1:param.M1_neurons
                        neuron_idx = neuron_idx + 1;
                        if ismember(neuron_idx,M1_neurons_of_interest{day})
                            if ((length([M1_spike_snapshots{s_chan,code,:}]) / size(M1_spike_snapshots,3)) >= M1_min_spikes) && (param.M1_good_chans(lfp_chan) ~= s_chan)
                                %--do calc--
                                %calc mean lfp across trials
                                LFP_mean = mean(M1_snapshots(lfp_chan,:,:),3);
                                %filter lfp
                                LFP_filt = mean(M1_filt(lfp_chan,:,:),3);
                                %tally spikes across trials
                                block_spike_times = [M1_spike_snapshots{s_chan,code,:}];
                                %calc phase of lfp at each spike time
                                hilbert_LFP = hilbert(LFP_filt);
                                inst_phase = unwrap(angle(hilbert_LFP));%inst phase
                                radial_phase = mod(inst_phase,2*pi);
                                spike_phases = radial_phase(round(block_spike_times+1));
                                %store data for comparison to other brain area equivalents
                                %save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(lfp_chan)),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phases', '.mat'],'spike_phases');
                                %plot
                                phase_hist = polarhistogram(spike_phases,12,'FaceColor', [.8 0 0], 'FaceAlpha', 1);
                                %saveas(phase_hist,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(lfp_chan)),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phase_histogram', '.fig'])
                                close all;
                                
                                M1Ch_M1Nrn_spike_phase{lfp_chan,s_chan,code,1} = [M1Ch_M1Nrn_spike_phase{lfp_chan,s_chan,code,1} spike_phases];
                            end
                        end
                    end
                end
                neuron_idx = 0;
                for s_chan = 1:param.Cb_chans
                    for code = 1:param.Cb_neurons
                        neuron_idx = neuron_idx + 1;
                        if ismember(neuron_idx,Cb_neurons_of_interest{day})
                            if (length([Cb_spike_snapshots{s_chan,code,:}]) / size(Cb_spike_snapshots,3)) >= Cb_min_spikes
                                %--do calc--
                                %calc mean lfp across trials
                                LFP_mean = mean(M1_snapshots(lfp_chan,:,:),3);
                                %filter lfp
                                LFP_filt = mean(M1_filt(lfp_chan,:,:),3);
                                %tally spikes across trials
                                block_spike_times = [Cb_spike_snapshots{s_chan,code,:}];
                                %calc phase of lfp at each spike time
                                hilbert_LFP = hilbert(LFP_filt);
                                inst_phase = unwrap(angle(hilbert_LFP));%inst phase
                                radial_phase = mod(inst_phase,2*pi);
                                spike_phases = radial_phase(round(block_spike_times+1));
                                %store data for comparison to other brain area equivalents
                                %save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(lfp_chan)),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phases', '.mat'],'spike_phases');
                                %plot
                                phase_hist = polarhistogram(spike_phases,12,'FaceColor', [.8 0 0], 'FaceAlpha', 1);
                                %saveas(phase_hist,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(lfp_chan)),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phase_histogram', '.fig'])
                                close all;
                                
                                M1Ch_CbNrn_spike_phase{lfp_chan,s_chan,code,1} = [M1Ch_CbNrn_spike_phase{lfp_chan,s_chan,code,1} spike_phases];
                                
                                
                                
                            end
                        end
                    end
                end
            end
        end
        
        for lfp_chan = 1:length(param.Cb_good_chans)
            if ismember(param.Cb_good_chans(lfp_chan),Cb_channels_of_interest)
                if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan))],'dir')
                    mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan))]);
                end
                M1_neurons_zscores = nan(param.M1_chans,param.M1_neurons);
                Cb_neurons_zscores = nan(param.Cb_chans,param.Cb_neurons);
                M1_neurons_pscores = nan(param.M1_chans,param.M1_neurons);
                Cb_neurons_pscores = nan(param.Cb_chans,param.Cb_neurons);
                neuron_idx = 0;
                for s_chan = 1:param.M1_chans
                    for code = 1:param.M1_neurons
                        neuron_idx = neuron_idx + 1;
                        if ismember(neuron_idx,M1_neurons_of_interest{day})
                            if (length([M1_spike_snapshots{s_chan,code,:}]) / size(M1_spike_snapshots,3)) >= M1_min_spikes
                                %--do calc--
                                %calc mean lfp across trials
                                LFP_mean = mean(Cb_snapshots(lfp_chan,:,:),3);
                                %filter lfp
                                LFP_filt = mean(Cb_filt(lfp_chan,:,:),3);
                                %tally spikes across trials
                                block_spike_times = [M1_spike_snapshots{s_chan,code,:}];
                                %calc phase of lfp at each spike time
                                hilbert_LFP = hilbert(LFP_filt);
                                inst_phase = unwrap(angle(hilbert_LFP));%inst phase
                                radial_phase = mod(inst_phase,2*pi);
                                spike_phases = radial_phase(round(block_spike_times+1));
                                %store data for comparison to other brain area equivalents
                                %save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan)),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phases', '.mat'],'spike_phases');
                                %plot
                                phase_hist = polarhistogram(spike_phases,12,'FaceColor', [.8 0 0], 'FaceAlpha', 1);
                                %saveas(phase_hist,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan)),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phase_histogram', '.fig'])
                                close all;
                                
                                CbCh_M1Nrn_spike_phase{lfp_chan,s_chan,code,1} = [CbCh_M1Nrn_spike_phase{lfp_chan,s_chan,code,1} spike_phases];
                                
                                %temp code to make the rest of Lemke fig 3b
                                if param.Cb_good_chans(lfp_chan) == 28 && s_chan == 16 && code == 2 && day == 5
                                    %disp('Here');
                                end
                            end
                        end
                    end
                end
                neuron_idx = 0;
                for s_chan = 1:param.Cb_chans
                    for code = 1:param.Cb_neurons
                        neuron_idx = neuron_idx + 1;
                        if ismember(neuron_idx,Cb_neurons_of_interest{day})
                            if ((length([Cb_spike_snapshots{s_chan,code,:}]) / size(Cb_spike_snapshots,3)) >= Cb_min_spikes) && (param.Cb_good_chans(lfp_chan) ~= (ceil(s_chan/4)*4)-3)
                                %--do calc--
                                %calc mean lfp across trials
                                LFP_mean = mean(Cb_snapshots(lfp_chan,:,:),3);
                                %filter lfp
                                LFP_filt = mean(Cb_filt(lfp_chan,:,:),3);
                                %tally spikes across trials
                                block_spike_times = [Cb_spike_snapshots{s_chan,code,:}];
                                %calc phase of lfp at each spike time
                                hilbert_LFP = hilbert(LFP_filt);
                                inst_phase = unwrap(angle(hilbert_LFP));%inst phase
                                radial_phase = mod(inst_phase,2*pi);
                                spike_phases = radial_phase(round(block_spike_times+1));
                                %store data for comparison to other brain area equivalents
                                %save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan)),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phases', '.mat'],'spike_phases', 'radial_phase', 'LFP_filt');
                                %plot
                                phase_hist = polarhistogram(spike_phases,12,'FaceColor', [.8 0 0], 'FaceAlpha', 1);
                                %saveas(phase_hist,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan)),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phase_histogram', '.fig'])
                                close all;
                                
                                CbCh_CbNrn_spike_phase{lfp_chan,s_chan,code,1} = [CbCh_CbNrn_spike_phase{lfp_chan,s_chan,code,1} spike_phases];
                            end
                        end
                    end
                end
            end
        end
        
        M1_snapshots = M1_snapshots_fail;
        Cb_snapshots = Cb_snapshots_fail;
        M1_spike_snapshots = M1_spike_snapshots_fail;
        Cb_spike_snapshots = Cb_spike_snapshots_fail;
        M1_filt = M1_filt_fail;
        Cb_filt = Cb_filt_fail;
        for lfp_chan = 1:length(param.M1_good_chans)
            if ismember(param.M1_good_chans(lfp_chan),M1_channels_of_interest)
                if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(lfp_chan))],'dir')
                    mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(lfp_chan))]);
                end
                neuron_idx = 0;
                for s_chan = 1:param.M1_chans
                    for code = 1:param.M1_neurons
                        neuron_idx = neuron_idx + 1;
                        if ismember(neuron_idx,M1_neurons_of_interest{day})
                            if ((length([M1_spike_snapshots{s_chan,code,:}]) / size(M1_spike_snapshots,3)) >= M1_min_spikes) && (param.M1_good_chans(lfp_chan) ~= s_chan)
                                %--do calc--
                                %calc mean lfp across trials
                                LFP_mean = mean(M1_snapshots(lfp_chan,:,:),3);
                                %filter lfp
                                LFP_filt = mean(M1_filt(lfp_chan,:,:),3);
                                %tally spikes across trials
                                block_spike_times = [M1_spike_snapshots{s_chan,code,:}];
                                %calc phase of lfp at each spike time
                                hilbert_LFP = hilbert(LFP_filt);
                                inst_phase = unwrap(angle(hilbert_LFP));%inst phase
                                radial_phase = mod(inst_phase,2*pi);
                                spike_phases = radial_phase(round(block_spike_times+1));
                                %store data for comparison to other brain area equivalents
                                %save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(lfp_chan)),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phases', '.mat'],'spike_phases');
                                %plot
                                phase_hist = polarhistogram(spike_phases,12,'FaceColor', [.8 0 0], 'FaceAlpha', 1);
                                %saveas(phase_hist,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(lfp_chan)),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phase_histogram', '.fig'])
                                close all;
                                
                                M1Ch_M1Nrn_spike_phase{lfp_chan,s_chan,code,2} = [M1Ch_M1Nrn_spike_phase{lfp_chan,s_chan,code,2} spike_phases];
                            end
                        end
                    end
                end
                neuron_idx = 0;
                for s_chan = 1:param.Cb_chans
                    for code = 1:param.Cb_neurons
                        neuron_idx = neuron_idx + 1;
                        if ismember(neuron_idx,Cb_neurons_of_interest{day})
                            if (length([Cb_spike_snapshots{s_chan,code,:}]) / size(Cb_spike_snapshots,3)) >= Cb_min_spikes
                                %--do calc--
                                %calc mean lfp across trials
                                LFP_mean = mean(M1_snapshots(lfp_chan,:,:),3);
                                %filter lfp
                                LFP_filt = mean(M1_filt(lfp_chan,:,:),3);
                                %tally spikes across trials
                                block_spike_times = [Cb_spike_snapshots{s_chan,code,:}];
                                %calc phase of lfp at each spike time
                                hilbert_LFP = hilbert(LFP_filt);
                                inst_phase = unwrap(angle(hilbert_LFP));%inst phase
                                radial_phase = mod(inst_phase,2*pi);
                                spike_phases = radial_phase(round(block_spike_times+1));
                                %store data for comparison to other brain area equivalents
                                %save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(lfp_chan)),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phases', '.mat'],'spike_phases');
                                %plot
                                phase_hist = polarhistogram(spike_phases,12,'FaceColor', [.8 0 0], 'FaceAlpha', 1);
                                %saveas(phase_hist,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/M1_Channel',num2str(param.M1_good_chans(lfp_chan)),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phase_histogram', '.fig'])
                                close all;
                                
                                M1Ch_CbNrn_spike_phase{lfp_chan,s_chan,code,2} = [M1Ch_CbNrn_spike_phase{lfp_chan,s_chan,code,2} spike_phases];
                                
                                
                                
                            end
                        end
                    end
                end
            end
        end
        
        for lfp_chan = 1:length(param.Cb_good_chans)
            if ismember(param.Cb_good_chans(lfp_chan),Cb_channels_of_interest)
                if ~exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan))],'dir')
                    mkdir([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan))]);
                end
                M1_neurons_zscores = nan(param.M1_chans,param.M1_neurons);
                Cb_neurons_zscores = nan(param.Cb_chans,param.Cb_neurons);
                M1_neurons_pscores = nan(param.M1_chans,param.M1_neurons);
                Cb_neurons_pscores = nan(param.Cb_chans,param.Cb_neurons);
                neuron_idx = 0;
                for s_chan = 1:param.M1_chans
                    for code = 1:param.M1_neurons
                        neuron_idx = neuron_idx + 1;
                        if ismember(neuron_idx,M1_neurons_of_interest{day})
                            if (length([M1_spike_snapshots{s_chan,code,:}]) / size(M1_spike_snapshots,3)) >= M1_min_spikes
                                %--do calc--
                                %calc mean lfp across trials
                                LFP_mean = mean(Cb_snapshots(lfp_chan,:,:),3);
                                %filter lfp
                                LFP_filt = mean(Cb_filt(lfp_chan,:,:),3);
                                %tally spikes across trials
                                block_spike_times = [M1_spike_snapshots{s_chan,code,:}];
                                %calc phase of lfp at each spike time
                                hilbert_LFP = hilbert(LFP_filt);
                                inst_phase = unwrap(angle(hilbert_LFP));%inst phase
                                radial_phase = mod(inst_phase,2*pi);
                                spike_phases = radial_phase(round(block_spike_times+1));
                                %store data for comparison to other brain area equivalents
                                %save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan)),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phases', '.mat'],'spike_phases');
                                %plot
                                phase_hist = polarhistogram(spike_phases,12,'FaceColor', [.8 0 0], 'FaceAlpha', 1);
                                %saveas(phase_hist,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan)),'/M1_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phase_histogram', '.fig'])
                                close all;
                                
                                CbCh_M1Nrn_spike_phase{lfp_chan,s_chan,code,2} = [CbCh_M1Nrn_spike_phase{lfp_chan,s_chan,code,2} spike_phases];
                                
                                %temp code to make the rest of Lemke fig 3b
                                if param.Cb_good_chans(lfp_chan) == 28 && s_chan == 16 && code == 2 && day == 5
                                    %disp('Here');
                                end
                            end
                        end
                    end
                end
                neuron_idx = 0;
                for s_chan = 1:param.Cb_chans
                    for code = 1:param.Cb_neurons
                        neuron_idx = neuron_idx + 1;
                        if ismember(neuron_idx,Cb_neurons_of_interest{day})
                            if ((length([Cb_spike_snapshots{s_chan,code,:}]) / size(Cb_spike_snapshots,3)) >= Cb_min_spikes) && (param.Cb_good_chans(lfp_chan) ~= (ceil(s_chan/4)*4)-3)
                                %--do calc--
                                %calc mean lfp across trials
                                LFP_mean = mean(Cb_snapshots(lfp_chan,:,:),3);
                                %filter lfp
                                LFP_filt = mean(Cb_filt(lfp_chan,:,:),3);
                                %tally spikes across trials
                                block_spike_times = [Cb_spike_snapshots{s_chan,code,:}];
                                %calc phase of lfp at each spike time
                                hilbert_LFP = hilbert(LFP_filt);
                                inst_phase = unwrap(angle(hilbert_LFP));%inst phase
                                radial_phase = mod(inst_phase,2*pi);
                                spike_phases = radial_phase(round(block_spike_times+1));
                                %store data for comparison to other brain area equivalents
                                %save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan)),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phases', '.mat'],'spike_phases', 'radial_phase', 'LFP_filt');
                                %plot
                                phase_hist = polarhistogram(spike_phases,12,'FaceColor', [.8 0 0], 'FaceAlpha', 1);
                                %saveas(phase_hist,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/Cb_Channel',num2str(param.Cb_good_chans(lfp_chan)),'/Cb_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phase_histogram', '.fig'])
                                close all;
                                
                                CbCh_CbNrn_spike_phase{lfp_chan,s_chan,code,2} = [CbCh_CbNrn_spike_phase{lfp_chan,s_chan,code,2} spike_phases];
                            end
                        end
                    end
                end
            end
        end
    end
    
    for lfp_chan = 1:length(param.M1_good_chans)
        if ismember(param.M1_good_chans(lfp_chan),M1_channels_of_interest)
            neuron_idx = 0;
            M1_spikes_Zs_succ = nan(param.M1_chans,param.M1_neurons);
            M1_spikes_Ps_succ = nan(param.M1_chans,param.M1_neurons);
            Cb_spikes_Zs_succ = nan(param.Cb_chans,param.Cb_neurons);
            Cb_spikes_Ps_succ = nan(param.Cb_chans,param.Cb_neurons);
            
            M1_spikes_Zs_fail = nan(param.M1_chans,param.M1_neurons);
            M1_spikes_Ps_fail = nan(param.M1_chans,param.M1_neurons);
            Cb_spikes_Zs_fail = nan(param.Cb_chans,param.Cb_neurons);
            Cb_spikes_Ps_fail = nan(param.Cb_chans,param.Cb_neurons);
            for s_chan = 1:param.M1_chans
                for code = 1:param.M1_neurons
                    neuron_idx = neuron_idx + 1;
                    if ismember(neuron_idx,M1_neurons_of_interest{day}) && ~isempty(M1Ch_M1Nrn_spike_phase{lfp_chan,s_chan,code,1}) && ~isempty(M1Ch_M1Nrn_spike_phase{lfp_chan,s_chan,code,2})
                        [M1_spikes_Ps_succ(s_chan,code),M1_spikes_Zs_succ(s_chan,code)] = circ_rtest(M1Ch_M1Nrn_spike_phase{lfp_chan,s_chan,code,1});
                        [M1_spikes_Ps_fail(s_chan,code),M1_spikes_Zs_fail(s_chan,code)] = circ_rtest(M1Ch_M1Nrn_spike_phase{lfp_chan,s_chan,code,2});
                    end
                end
            end
            neuron_idx = 0;
            for s_chan = 1:param.Cb_chans
                for code = 1:param.Cb_neurons
                    neuron_idx = neuron_idx + 1;
                    if ismember(neuron_idx,Cb_neurons_of_interest{day}) && ~isempty(M1Ch_CbNrn_spike_phase{lfp_chan,s_chan,code,1}) && ~isempty(M1Ch_CbNrn_spike_phase{lfp_chan,s_chan,code,2})
                        [Cb_spikes_Ps_succ(s_chan,code),Cb_spikes_Zs_succ(s_chan,code)] = circ_rtest(M1Ch_CbNrn_spike_phase{lfp_chan,s_chan,code,1});
                        [Cb_spikes_Ps_fail(s_chan,code),Cb_spikes_Zs_fail(s_chan,code)] = circ_rtest(M1Ch_CbNrn_spike_phase{lfp_chan,s_chan,code,2});
                    end
                end
            end
            M1_spikes_Ps_succ(isnan(M1_spikes_Ps_succ)) = [];
            Cb_spikes_Ps_succ(isnan(Cb_spikes_Ps_succ)) = [];
            M1_spikes_Zs_succ(isnan(M1_spikes_Zs_succ)) = [];
            Cb_spikes_Zs_succ(isnan(Cb_spikes_Zs_succ)) = [];
            M1_spikes_Ps_fail(isnan(M1_spikes_Ps_fail)) = [];
            Cb_spikes_Ps_fail(isnan(Cb_spikes_Ps_fail)) = [];
            M1_spikes_Zs_fail(isnan(M1_spikes_Zs_fail)) = [];
            Cb_spikes_Zs_fail(isnan(Cb_spikes_Zs_fail)) = [];
            
            M1Ch_M1Nrn_stats{1} = [M1_spikes_Zs_succ; M1_spikes_Ps_succ];
            M1Ch_CbNrn_stats{1} = [Cb_spikes_Zs_succ; Cb_spikes_Ps_succ];
            M1Ch_M1Nrn_stats{2} = [M1_spikes_Zs_fail; M1_spikes_Ps_fail];
            M1Ch_CbNrn_stats{2} = [Cb_spikes_Zs_fail; Cb_spikes_Ps_fail];
        end
    end
    for lfp_chan = 1:length(param.Cb_good_chans)
        if ismember(param.Cb_good_chans(lfp_chan),Cb_channels_of_interest)
            neuron_idx = 0;
            M1_spikes_Zs_succ = nan(param.M1_chans,param.M1_neurons);
            M1_spikes_Ps_succ = nan(param.M1_chans,param.M1_neurons);
            Cb_spikes_Zs_succ = nan(param.Cb_chans,param.Cb_neurons);
            Cb_spikes_Ps_succ = nan(param.Cb_chans,param.Cb_neurons);
            
            M1_spikes_Zs_fail = nan(param.M1_chans,param.M1_neurons);
            M1_spikes_Ps_fail = nan(param.M1_chans,param.M1_neurons);
            Cb_spikes_Zs_fail = nan(param.Cb_chans,param.Cb_neurons);
            Cb_spikes_Ps_fail = nan(param.Cb_chans,param.Cb_neurons);
            for s_chan = 1:param.M1_chans
                for code = 1:param.M1_neurons
                    neuron_idx = neuron_idx + 1;
                    if ismember(neuron_idx,M1_neurons_of_interest{day}) && ~isempty(CbCh_M1Nrn_spike_phase{lfp_chan,s_chan,code,1}) && ~isempty(CbCh_M1Nrn_spike_phase{lfp_chan,s_chan,code,2})
                        [M1_spikes_Ps_succ(s_chan,code),M1_spikes_Zs_succ(s_chan,code)] = circ_rtest(CbCh_M1Nrn_spike_phase{lfp_chan,s_chan,code,1});
                        [M1_spikes_Ps_fail(s_chan,code),M1_spikes_Zs_fail(s_chan,code)] = circ_rtest(CbCh_M1Nrn_spike_phase{lfp_chan,s_chan,code,2});
                    end
                end
            end
            neuron_idx = 0;
            for s_chan = 1:param.Cb_chans
                for code = 1:param.Cb_neurons
                    neuron_idx = neuron_idx + 1;
                    if ismember(neuron_idx,Cb_neurons_of_interest{day}) && ~isempty(CbCh_CbNrn_spike_phase{lfp_chan,s_chan,code,1}) && ~isempty(CbCh_CbNrn_spike_phase{lfp_chan,s_chan,code,2})
                        [Cb_spikes_Ps_succ(s_chan,code),Cb_spikes_Zs_succ(s_chan,code)] = circ_rtest(CbCh_CbNrn_spike_phase{lfp_chan,s_chan,code,1});
                        [Cb_spikes_Ps_fail(s_chan,code),Cb_spikes_Zs_fail(s_chan,code)] = circ_rtest(CbCh_CbNrn_spike_phase{lfp_chan,s_chan,code,2});
                    end
                end
            end
            M1_spikes_Ps_succ(isnan(M1_spikes_Ps_succ)) = [];
            Cb_spikes_Ps_succ(isnan(Cb_spikes_Ps_succ)) = [];
            M1_spikes_Zs_succ(isnan(M1_spikes_Zs_succ)) = [];
            Cb_spikes_Zs_succ(isnan(Cb_spikes_Zs_succ)) = [];
            M1_spikes_Ps_fail(isnan(M1_spikes_Ps_fail)) = [];
            Cb_spikes_Ps_fail(isnan(Cb_spikes_Ps_fail)) = [];
            M1_spikes_Zs_fail(isnan(M1_spikes_Zs_fail)) = [];
            Cb_spikes_Zs_fail(isnan(Cb_spikes_Zs_fail)) = [];
            
            CbCh_M1Nrn_stats{1} = [M1_spikes_Zs_succ; M1_spikes_Ps_succ];
            CbCh_CbNrn_stats{1} = [Cb_spikes_Zs_succ; Cb_spikes_Ps_succ];
            CbCh_M1Nrn_stats{2} = [M1_spikes_Zs_fail; M1_spikes_Ps_fail];
            CbCh_CbNrn_stats{2} = [Cb_spikes_Zs_fail; Cb_spikes_Ps_fail];
        end
    end
    
    
    spike_Ps = M1Ch_M1Nrn_stats{2}(2,:);
    percent_sig_D1 = sum(spike_Ps <= 0.05)/length(spike_Ps);
    [z_counts, ~] = histcounts(M1Ch_M1Nrn_stats{2}(1,:),edges);
    count_ratio = z_counts/length(spike_Ps);
    z_ratio_cum = cumsum(count_ratio);
    figure
    line(bin_centers,z_ratio_cum,'Color',[1 0.2 0.2]);
    
    spike_Ps = M1Ch_M1Nrn_stats{1}(2,:);
    percent_sig_D5 = sum(spike_Ps <= 0.05)/length(spike_Ps);
    [z_counts, ~] = histcounts(M1Ch_M1Nrn_stats{1}(1,:),edges);
    count_ratio = z_counts/length(spike_Ps);
    z_ratio_cum = cumsum(count_ratio);
    line(bin_centers,z_ratio_cum,'Color',[0.8 0 0]);
    line([3 3], [0 1], 'Color', [0 0 0], 'LineStyle','--');
    title(['M1Ch-M1Nrn Fail:',num2str(percent_sig_D1*100),'% Success:',num2str(percent_sig_D5*100),'%']);
    saveas(gcf,[rootpath,animal,'/Phase_non-uniformity_cdf_M1Ch-M1Nrn_SvF', '.fig']);
    close all;
    
    
    spike_Ps = M1Ch_CbNrn_stats{2}(2,:);
    percent_sig_D1 = sum(spike_Ps <= 0.05)/length(spike_Ps);
    [z_counts, ~] = histcounts(M1Ch_CbNrn_stats{2}(1,:),edges);
    count_ratio = z_counts/length(spike_Ps);
    z_ratio_cum = cumsum(count_ratio);
    figure
    line(bin_centers,z_ratio_cum,'Color',[1 0.2 0.2]);
    
    spike_Ps = M1Ch_CbNrn_stats{1}(2,:);
    percent_sig_D5 = sum(spike_Ps <= 0.05)/length(spike_Ps);
    [z_counts, ~] = histcounts(M1Ch_CbNrn_stats{1}(1,:),edges);
    count_ratio = z_counts/length(spike_Ps);
    z_ratio_cum = cumsum(count_ratio);
    line(bin_centers,z_ratio_cum,'Color',[0.8 0 0]);
    line([3 3], [0 1], 'Color', [0 0 0], 'LineStyle','--');
    title(['M1Ch-CbNrn Fail:',num2str(percent_sig_D1*100),'% Success:',num2str(percent_sig_D5*100),'%']);
    saveas(gcf,[rootpath,animal,'/Phase_non-uniformity_cdf_M1Ch-CbNrn_SvF', '.fig']);
    close all;
    
    
    spike_Ps = CbCh_M1Nrn_stats{2}(2,:);
    percent_sig_D1 = sum(spike_Ps <= 0.05)/length(spike_Ps);
    [z_counts, ~] = histcounts(CbCh_M1Nrn_stats{2}(1,:),edges);
    count_ratio = z_counts/length(spike_Ps);
    z_ratio_cum = cumsum(count_ratio);
    figure
    line(bin_centers,z_ratio_cum,'Color',[0.2 1 0.2]);
    
    spike_Ps = CbCh_M1Nrn_stats{1}(2,:);
    percent_sig_D5 = sum(spike_Ps <= 0.05)/length(spike_Ps);
    [z_counts, ~] = histcounts(CbCh_M1Nrn_stats{1}(1,:),edges);
    count_ratio = z_counts/length(spike_Ps);
    z_ratio_cum = cumsum(count_ratio);
    line(bin_centers,z_ratio_cum,'Color',[0 0.8 0]);
    line([3 3], [0 1], 'Color', [0 0 0], 'LineStyle','--');
    title(['CbCh-M1Nrn Fail:',num2str(percent_sig_D1*100),'% Success:',num2str(percent_sig_D5*100),'%']);
    saveas(gcf,[rootpath,animal,'/Phase_non-uniformity_cdf_CbCh-M1Nrn_SvF', '.fig']);
    close all;
    
    
    spike_Ps = CbCh_CbNrn_stats{2}(2,:);
    percent_sig_D1 = sum(spike_Ps <= 0.05)/length(spike_Ps);
    [z_counts, ~] = histcounts(CbCh_CbNrn_stats{2}(1,:),edges);
    count_ratio = z_counts/length(spike_Ps);
    z_ratio_cum = cumsum(count_ratio);
    figure
    line(bin_centers,z_ratio_cum,'Color',[0.2 1 0.2]);
    
    spike_Ps = CbCh_CbNrn_stats{1}(2,:);
    percent_sig_D5 = sum(spike_Ps <= 0.05)/length(spike_Ps);
    [z_counts, ~] = histcounts(CbCh_CbNrn_stats{1}(1,:),edges);
    count_ratio = z_counts/length(spike_Ps);
    z_ratio_cum = cumsum(count_ratio);
    line(bin_centers,z_ratio_cum,'Color',[0 0.8 0]);
    line([3 3], [0 1], 'Color', [0 0 0], 'LineStyle','--');
    title(['CbCh-CbNrn Fail:',num2str(percent_sig_D1*100),'% Success:',num2str(percent_sig_D5*100),'%']);
    saveas(gcf,[rootpath,animal,'/Phase_non-uniformity_cdf_CbCh-CbNrn_SvF', '.fig']);
    close all;

    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
    rmpath('Z:\Matlab for analysis\circStat2008\sis_data\matlab code\nhp data\MATLAB files\circStat2008');
end

%% Successful vs. Unsuccessful cross-trial Fano Factor Centered on modulation point (53)

if enabled(53)
    disp('Block 53...')
    addpath(genpath('Z:\Matlab for analysis\BARS'))
    mod_bin_size = 25; %In miliseconds
    mod_pre_win = 1000; %in miliseconds
    mod_post_win = 1500; %in miliseconds
    mod_all_bin_edges = 0:mod_bin_size:8000;
    mod_all_bin_centers = mod_all_bin_edges(2:end) - (mod_bin_size/2);
    mod_win_bin_edges = (4000-mod_pre_win):mod_bin_size:(4000+mod_post_win);
    mod_win_bin_centers = mod_win_bin_edges(2:end) - (mod_bin_size/2);
    
    FF_bin_size = 100; %In miliseconds
    FF_pre_win = 300; %in miliseconds
    FF_post_win = 800; %in miliseconds
    FF_bin_centers = ((FF_bin_size/2)-FF_pre_win):FF_bin_size:(FF_post_win-(FF_bin_size/2));
    
    zs_subset = true(1,length(mod_all_bin_centers));%logical(mod_all_bin_centers <= 2000);
    hm_subset = (mod_all_bin_centers <= 5500) & (mod_all_bin_centers >= 3000);
    win_indexes = mod_all_bin_centers(hm_subset);
    
    bp = barsdefaultParams;
    bp.prior_id = 'POISSON';
    bp.dparams = 4;
    bp.use_logspline = 0;
    
    for day=1:param.days
        M1_spikes = cell(param.M1_chans, param.M1_neurons, 0);
        Cb_spikes = cell(param.Cb_chans, param.Cb_neurons, 0);
        M1_spikes_succ = cell(param.M1_chans, param.M1_neurons, 0);
        M1_spikes_fail = cell(param.M1_chans, param.M1_neurons, 0);
        Cb_spikes_succ = cell(param.Cb_chans, param.Cb_neurons, 0);
        Cb_spikes_fail = cell(param.Cb_chans, param.Cb_neurons, 0);
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/spiketrain_snapshots_full.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_timestamps.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            
            outcomes = cellfun(@str2double,data(:,3)); %Do not use bad trials from file, noisey trials don't matter just like noisey channels don't
            bad_trials = 1:size(data,1);
            bad_trials(outcomes < 2) = [];
            
            M1_spikes = cat(3, M1_spikes, M1_spike_snapshots_full);
            Cb_spikes = cat(3, Cb_spikes, Cb_spike_snapshots_full);
            [M1_successes, M1_fails] = success_fail_split(M1_spike_snapshots_full, data, bad_trials,3);
            [Cb_successes, Cb_fails] = success_fail_split(Cb_spike_snapshots_full, data, bad_trials,3);
            M1_spikes_succ = cat(3, M1_spikes_succ, M1_successes);
            M1_spikes_fail = cat(3, M1_spikes_fail, M1_fails);
            Cb_spikes_succ = cat(3, Cb_spikes_succ, Cb_successes);
            Cb_spikes_fail = cat(3, Cb_spikes_fail, Cb_fails);
        end
        
        M1_neurons_of_interest = param.M1_task_related_neurons{day} & sum(~cellfun(@isempty,M1_spikes), 3);
        Cb_neurons_of_interest = param.Cb_task_related_neurons{day} & sum(~cellfun(@isempty,Cb_spikes), 3);
        
        M1_succ_trials = size(M1_spikes_succ,3);
        M1_fail_trials = size(M1_spikes_fail,3);
        Cb_succ_trials = size(Cb_spikes_succ,3);
        Cb_fail_trials = size(Cb_spikes_fail,3);
        
        load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{1},'/Spike_timestamps.mat']);
        M1_day_hist = nan(sum(M1_neurons_of_interest(:)), length(mod_all_bin_centers));
        M1_day_hist_smooth = nan(sum(M1_neurons_of_interest(:)), length(mod_all_bin_centers));
        neuron_id = 1;
        neuron_2D_idx = nan(size(M1_day_hist,1),2);
        for chan = 1:param.M1_chans
            for code = 1:param.M1_neurons
                if isempty(M1_spike_timestamps{chan, code}) || ~M1_neurons_of_interest(chan, code)
                    continue
                end
                
                neuron_2D_idx(neuron_id,:) = [chan, code];
                M1_day_hist(neuron_id,:) = histcounts([M1_spikes{chan, code, :}], mod_all_bin_edges);
                ss_fit = fit((1:length(M1_day_hist(neuron_id,:)))', M1_day_hist(neuron_id,:)', 'smoothingspline', 'SmoothingParam', param.smoothing_param);
                M1_day_hist_smooth(neuron_id,:) = ss_fit(1:length(M1_day_hist(neuron_id,:)))';
                neuron_id = neuron_id+1;
            end
        end
        
        data_mean = mean(M1_day_hist_smooth(:,zs_subset),2);
        data_std = std(M1_day_hist_smooth(:,zs_subset),0,2);
        M1_zs_data = (M1_day_hist_smooth - data_mean)./data_std;
        M1_zs_mod_win = M1_zs_data(:,hm_subset);
        
        M1_inc_max = max(M1_zs_mod_win,[],2);
        M1_dec_min = min(M1_zs_mod_win,[],2);
        max_wins = (M1_inc_max) > abs(M1_dec_min);
        mod_vals = M1_dec_min;
        mod_vals(max_wins) = M1_inc_max(max_wins);
        
        M1_neuron_FF_succ = nan(param.M1_chans, param.M1_neurons, length(FF_bin_centers));
        M1_neuron_FF_fail = nan(param.M1_chans, param.M1_neurons, length(FF_bin_centers));
        for neuron = 1:length(mod_vals)
            mod_idx = find(M1_zs_mod_win(neuron,:) == mod_vals(neuron));
            mod_time = mod_win_bin_centers(mod_idx);
            M1_day_hist(neuron,:) = histcounts([M1_spikes{neuron_2D_idx(neuron,1), neuron_2D_idx(neuron,2), :}], mod_all_bin_edges);
            FF_bin_edges = (mod_time-FF_pre_win):FF_bin_size:(mod_time+FF_post_win);
            
            all_trials_hist = nan(M1_succ_trials, length(FF_bin_centers));
            for trial = 1:M1_succ_trials
                timestamps = M1_spikes_succ{neuron_2D_idx(neuron,1), neuron_2D_idx(neuron,2), trial} * (1000/param.M1_Fs);
                all_trials_hist(trial, :) = histcounts(timestamps,FF_bin_edges);
            end
            bin_mean = mean(all_trials_hist, 1);
            bin_var = var(all_trials_hist, 0, 1);
            M1_neuron_FF_succ(neuron_2D_idx(neuron,1), neuron_2D_idx(neuron,2), :) = bin_var ./ bin_mean;
            
            all_trials_hist = nan(M1_fail_trials, length(FF_bin_centers));
            for trial = 1:M1_fail_trials
                timestamps = M1_spikes_fail{neuron_2D_idx(neuron,1), neuron_2D_idx(neuron,2), trial} * (1000/param.M1_Fs);
                all_trials_hist(trial, :) = histcounts(timestamps,FF_bin_edges);
            end
            bin_mean = mean(all_trials_hist, 1);
            bin_var = var(all_trials_hist, 0, 1);
            M1_neuron_FF_fail(neuron_2D_idx(neuron,1), neuron_2D_idx(neuron,2), :) = bin_var ./ bin_mean;
            
            hold on
            line(FF_bin_centers, squeeze(M1_neuron_FF_succ(neuron_2D_idx(neuron,1), neuron_2D_idx(neuron,2), :)),'Color', 'Blue')
            line(FF_bin_centers, squeeze(M1_neuron_FF_fail(neuron_2D_idx(neuron,1), neuron_2D_idx(neuron,2), :)),'Color', 'Red')%'r.', 'SizeData', 200)
            saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Spike_Figures/M1_modulation_aligned_FF_channel', num2str(neuron_2D_idx(neuron,1)), '_cell', num2str(neuron_2D_idx(neuron,2)), '.fig']);
            saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Spike_Figures/M1_modulation_aligned_FF_channel', num2str(neuron_2D_idx(neuron,1)), '_cell', num2str(neuron_2D_idx(neuron,2)), '.tiff']);
            hold off
            close all
        end
        
        Cb_day_hist = nan(sum(Cb_neurons_of_interest(:)), length(mod_all_bin_centers));
        Cb_day_hist_smooth = nan(sum(Cb_neurons_of_interest(:)), length(mod_all_bin_centers));
        neuron_id = 0;
        neuron_2D_idx = nan(size(Cb_day_hist,1),2);
        for chan = 1:param.Cb_chans
            for code = 1:param.Cb_neurons
                if isempty(Cb_spike_timestamps{chan, code}) || ~Cb_neurons_of_interest(chan, code)
                    continue
                end
                neuron_id = neuron_id+1;
                neuron_2D_idx(neuron_id,:) = [chan, code];
                Cb_day_hist(neuron_id,:) = histcounts([Cb_spikes{chan, code, :}], mod_all_bin_edges);
                ss_fit = fit((1:length(Cb_day_hist(neuron_id,:)))', Cb_day_hist(neuron_id,:)', 'smoothingspline', 'SmoothingParam', param.smoothing_param);
                Cb_day_hist_smooth(neuron_id,:) = ss_fit(1:length(Cb_day_hist(neuron_id,:)))';
            end
        end
        
        data_mean = mean(Cb_day_hist_smooth(:,zs_subset),2);
        data_std = std(Cb_day_hist_smooth(:,zs_subset),0,2);
        Cb_zs_data = (Cb_day_hist_smooth - data_mean)./data_std;
        Cb_zs_mod_win = Cb_zs_data(:,hm_subset);
        
        Cb_inc_max = max(Cb_zs_mod_win,[],2);
        Cb_dec_min = min(Cb_zs_mod_win,[],2);
        max_wins = (Cb_inc_max) > abs(Cb_dec_min);
        mod_vals = Cb_dec_min;
        mod_vals(max_wins) = Cb_inc_max(max_wins);
        
        Cb_neuron_FF_succ = nan(param.Cb_chans, param.Cb_neurons, length(FF_bin_centers));
        Cb_neuron_FF_fail = nan(param.Cb_chans, param.Cb_neurons, length(FF_bin_centers));
        for neuron = 1:length(mod_vals)
            mod_idx = find(Cb_zs_mod_win(neuron,:) == mod_vals(neuron));
            mod_time = mod_win_bin_centers(mod_idx);
            Cb_day_hist(neuron,:) = histcounts([Cb_spikes{neuron_2D_idx(neuron,1), neuron_2D_idx(neuron,2), :}], mod_all_bin_edges);
            FF_bin_edges = (mod_time-FF_pre_win):FF_bin_size:(mod_time+FF_post_win);
            
            all_trials_hist = nan(Cb_succ_trials, length(FF_bin_centers));
            for trial = 1:Cb_succ_trials
                timestamps = Cb_spikes_succ{neuron_2D_idx(neuron,1), neuron_2D_idx(neuron,2), trial} * (1000/param.Cb_Fs);
                all_trials_hist(trial, :) = histcounts(timestamps,FF_bin_edges);
            end
            bin_mean = mean(all_trials_hist, 1);
            bin_var = var(all_trials_hist, 0, 1);
            Cb_neuron_FF_succ(neuron_2D_idx(neuron,1), neuron_2D_idx(neuron,2), :) = bin_var ./ bin_mean;
            
            all_trials_hist = nan(Cb_fail_trials, length(FF_bin_centers));
            for trial = 1:Cb_fail_trials
                timestamps = Cb_spikes_fail{neuron_2D_idx(neuron,1), neuron_2D_idx(neuron,2), trial} * (1000/param.Cb_Fs);
                all_trials_hist(trial, :) = histcounts(timestamps,FF_bin_edges);
            end
            bin_mean = mean(all_trials_hist, 1);
            bin_var = var(all_trials_hist, 0, 1);
            Cb_neuron_FF_fail(neuron_2D_idx(neuron,1), neuron_2D_idx(neuron,2), :) = bin_var ./ bin_mean;
            
            hold on
            line(FF_bin_centers, squeeze(Cb_neuron_FF_succ(neuron_2D_idx(neuron,1), neuron_2D_idx(neuron,2), :)),'Color', 'Blue')
            line(FF_bin_centers, squeeze(Cb_neuron_FF_fail(neuron_2D_idx(neuron,1), neuron_2D_idx(neuron,2), :)),'Color', 'Red')%'r.', 'SizeData', 200)
            saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Spike_Figures/Cb_modulation_aligned_FF_channel', num2str(neuron_2D_idx(neuron,1)), '_cell', num2str(neuron_2D_idx(neuron,2)), '.fig']);
            saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Spike_Figures/Cb_modulation_aligned_FF_channel', num2str(neuron_2D_idx(neuron,1)), '_cell', num2str(neuron_2D_idx(neuron,2)), '.tiff']);
            hold off
            close all
        end
        
        M1_mean_FF_succ = nan(1, length(FF_bin_centers));
        M1_mean_FF_fail = nan(1, length(FF_bin_centers));
        Cb_mean_FF_succ = nan(1, length(FF_bin_centers));
        Cb_mean_FF_fail = nan(1, length(FF_bin_centers));
        for bin = 1:length(FF_bin_centers)
            bin_data = M1_neuron_FF_succ(:,:,bin);
            M1_mean_FF_succ(bin) = nanmean(bin_data(:));
            bin_data = M1_neuron_FF_fail(:,:,bin);
            M1_mean_FF_fail(bin) = nanmean(bin_data(:));
            bin_data = Cb_neuron_FF_succ(:,:,bin);
            Cb_mean_FF_succ(bin) = nanmean(bin_data(:));
            bin_data = Cb_neuron_FF_fail(:,:,bin);
            Cb_mean_FF_fail(bin) = nanmean(bin_data(:));
            
            %standard deviations go here
        end
        
        hold on
        line(FF_bin_centers, M1_mean_FF_succ,'Color', 'Blue')
        line(FF_bin_centers, M1_mean_FF_fail,'Color', 'Red')
        saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/FF_modulation_aligned_bins_M1.fig']);
        hold off
        close all
        
        hold on
        line(FF_bin_centers, Cb_mean_FF_succ,'Color', 'Blue')
        line(FF_bin_centers, Cb_mean_FF_fail,'Color', 'Red')
        saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/FF_modulation_aligned_bins_Cb.fig']);
        hold off
        close all
        
    end
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
    rmpath(genpath('Z:\Matlab for analysis\BARS'))
end

%% Collect Reach Trajectory Data (54)    Ref: 49

if enabled(54)
    disp('Block 54...')
    traj_prefer = 'DLC';
    param.traj_DLC = false;
    param.traj_GUI = false;
    
    if exist([origin_rootpath,animal,'/DLC_Data'],'dir') && strcmp(traj_prefer, 'DLC')
        param.traj_DLC = true;
    else
        param.traj_GUI = true;
    end
    save([rootpath,animal,'/Parameters.mat'],'param');
    for day = 1:param.days            
        for block = 1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            if isempty(data)
                trajectory_data = struct('x_coor', [], 'y_coor', []);
                trajectory_data = repmat(trajectory_data,size(data,1));
            else
                trajectory_data(size(data,1)) = struct('x_coor', [], 'y_coor', []); 
                if param.traj_DLC
                    %Get all excel filenames
                    fileNames = dir([origin_rootpath,animal,'\DLC_Data\Day',num2str(day),'\*.csv']);
                    trial_data = cell(1,size(data,1));
                    for entry_num = 1:length(fileNames)
                        name = fileNames(entry_num).name;
                        %for each extract %s1 and %s2 from D[day]R[%s1] ... -[%s2]DLC
                        idx1 = strfind(name,'(');
                        idx1 = idx1(1);
                        file_block = name(3+length(animal)+length(num2str(day)):idx1-2);
                        if isempty(file_block)
                            file_block = '1';
                        end
                        idx1 = strfind(file_block,'-');
                        if isempty(idx1)
                            file_sub_block = 1;
                            file_block = str2double(file_block);
                        else
                            file_sub_block = file_block(idx1+1:end);
                            file_sub_block = str2double(file_sub_block);
                            file_block = file_block(1:idx1-1);
                            file_block = str2double(file_block);
                        end
                        idx1 = strfind(name,'Cam')+2;
                        good_cam = true;
                        if isempty(idx1)
                            idx1 = strfind(name,'m)-');
                        else
                            if (name(idx1+1) == '1' && strcmp(param.dom_hand,'right')) || (name(idx1+1) == '2' && strcmp(param.dom_hand,'left'))
                                good_cam = false;
                            end
                        end
                        idx2 = strfind(name,'DLC');
                        trial = name(idx1+3:idx2-1);
                        trial = str2double(trial);
                        %keep only those where %s1 == block
                        if file_block == block && good_cam
                            trial_table = readtable([origin_rootpath,animal,'\DLC_Data\Day',num2str(day),'/',fileNames(entry_num).name]);
                            
                            trial_data{file_sub_block,trial} = cellfun(@str2double,table2array(trial_table(3:end,2:4)));
                            
                        end
                    end
                    sub_block = 0;
                    for trial = 1:size(data,1)
                        if strcmp(data(trial,1),'1')
                            sub_block = sub_block+1;
                        end
%                         frame_nums = str2num(data{trial,2}); %#ok<ST2NM>
%                         if isempty(frame_nums)
%                             reach_frame = -1;
%                             touch_frame = -2;
%                             retract_frame = -3;
%                         elseif strcmp(data{trial,3}, '1') || strcmp(data{trial,3}, '5')
%                             reach_frame = frame_nums(end-2);
%                             touch_frame = frame_nums(end-1);
%                             retract_frame = frame_nums(end);
%                         elseif frame_nums(end) == 1
%                             reach_frame = frame_nums(end-4);
%                             touch_frame = frame_nums(end-3);
%                             retract_frame = frame_nums(end-1);
%                         else
%                             reach_frame = -1;
%                             touch_frame = -2;
%                             retract_frame = -3;
%                         end
                        if isempty(trial_data{sub_block,str2double(data{trial,1})})
                            trial_data{sub_block,str2double(data{trial,1})} = zeros(0,3);
                        end
                        trajectory_data(trial).x_coor = trial_data{sub_block,str2double(data{trial,1})}(:,1); %reach_frame:retract_frame
                        trajectory_data(trial).y_coor = trial_data{sub_block,str2double(data{trial,1})}(:,2); %reach_frame:retract_frame
                        trajectory_data(trial).likelihood = trial_data{sub_block,str2double(data{trial,1})}(:,3); %reach_frame:retract_frame
                    end
                elseif param.traj_GUI
                    for trial = 1:size(data,1)
                        coors = data{trial,4};
                        coors = reshape(coors,[length(coors)/2, 2]);
                        
                        trajectory_data(trial).x_coor = coors(:,1);
                        trajectory_data(trial).y_coor = coors(:,2);
                    end
                end
            end
            save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/trajectory_data.mat'], 'trajectory_data');
            clear trajectory_data
        end
    end
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Composite Reach Trajectory Plot (55)

if enabled(55)
    disp('Block 55...')
    
    for day = 1:param.days
        day_x_pos = cell(1,0);
        day_y_pos = cell(1,0);
        day_x_pos_t = cell(1,0);
        day_y_pos_t = cell(1,0);
        touch_frame = [];
        for block = 1:param.blocks
            
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/trajectory_data.mat']);
            j=0;
            for i = 1:length(trajectory_data)
                if ~isempty(trajectory_data(i).x_coor)
                    j=j+1;
                    
                    frames = str2num(data{i,2}); %#ok<ST2NM>
                    if frames(end) == 1
                        touch_frame(j) = frames(end-3) - frames(end-4); %#ok<SAGROW>
                    else
                        touch_frame(j) = frames(end-1) - frames(end-2); %#ok<SAGROW>
                    end
                    
                    %trajectory until touch frame
                    day_x_pos_t{j} = trajectory_data(i).x_coor(1:touch_frame(j));
                    day_y_pos_t{j} = trajectory_data(i).y_coor(1:touch_frame(j));
                    
                    %full trajectory
                    day_x_pos{j} = trajectory_data(i).x_coor;
                    day_y_pos{j} = trajectory_data(i).y_coor;
                end
            end
        end
        figure
        hold on
        for i = 1:length(day_x_pos)
            plot(day_x_pos{i}, -day_y_pos{i}, 'Color', [.6 .6 .6])
        end
        saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/reach traj.fig'])
        hold off
        close all
        
        figure
        hold on
        for i = 1:length(day_x_pos)
            plot(day_x_pos_t{i}, -day_y_pos_t{i}, 'Color', [.6 .6 .6])
        end
        saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/reach to touch traj.fig'])
        hold off
        close all
    end
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Reach Trajectory Velocity Profiles (56)

if enabled(56)
    disp('Block 56...')
    smooth_span = 11; %this must be an odd number
    day_means = cell(param.days,3);
    for day = 1:param.days
        day_x_vels_cell = cell(1,0);
        day_y_vels_cell = cell(1,0);
        touch_frames = zeros(1,0);
        j=0;
        touch_frame = [];
        for block = 1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/trajectory_data.mat']);
            for i = 1:length(trajectory_data)
                if ~isempty(trajectory_data(i).x_coor)
                    j=j+1;
                    day_x_vels_cell{j} = diff(trajectory_data(i).x_coor) * param.Camera_framerate;
                    day_y_vels_cell{j} = diff(trajectory_data(i).y_coor) * param.Camera_framerate;
                    
                    frames = str2num(data{i,2}); %#ok<ST2NM>
                    if frames(end) == 1
                        touch_frame(j) = frames(end-3) - frames(end-4); %#ok<SAGROW>
                    else
                        touch_frame(j) = frames(end-1) - frames(end-2); %#ok<SAGROW>
                    end
                end
            end
        end
        pre_frames = max(touch_frame);
        post_frames = max(cellfun(@length, day_x_vels_cell) - touch_frame)+1;
        day_x_vels = zeros(length(day_x_vels_cell), pre_frames + post_frames);
        day_y_vels = zeros(length(day_x_vels_cell), pre_frames + post_frames);
        day_times = ((0.5-pre_frames):(post_frames-0.5)) * (1/param.Camera_framerate);
        for i = 1:length(day_x_vels_cell)
            day_x_vels(i,pre_frames+1 - touch_frame(i):pre_frames+length(day_x_vels_cell{i})-touch_frame(i)) = day_x_vels_cell{i};
            day_y_vels(i,pre_frames+1 - touch_frame(i):pre_frames+length(day_x_vels_cell{i})-touch_frame(i)) = day_y_vels_cell{i};
        end
        day_means{day,1} = mean(day_x_vels,1);
        day_means{day,2} = mean(day_y_vels,1);
        day_means{day,3} = day_times;
    end
    color_grad = [[0:1/(param.days-1):1]', zeros(param.days,1), [1:-1/(param.days-1):0]'];
    figure
    for day = 1:param.days
        line(day_means{day,3}, smooth(day_means{day,1}, smooth_span), 'Color', color_grad(day,:));
    end
    xlim([-1 0.5])
    saveas(gcf,[rootpath,animal,'/X_velocity_profile.fig'])
    close all;
    figure
    for day = 1:param.days
        line(day_means{day,3}, smooth(day_means{day,2}, smooth_span), 'Color', color_grad(day,:));
    end
    xlim([-1 0.5])
    saveas(gcf,[rootpath,animal,'/Y_velocity_profile.fig'])
    close all;
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Reach Trajectory Correlation (57)

if enabled(57)
    disp('Block 57...')
    load([rootpath,animal,'/Shared_Data.mat'])
    
    data_to_use = 'velocity'; %'coordinates', 'velocity'
    
    shared_data.x_trajectory_consistency = nan(1,5);
    shared_data.y_trajectory_consistency = nan(1,5);
    
    day_means = cell(param.days,3);
    for day = 1:param.days
        day_x_coor_cell = cell(1,0);
        day_y_coor_cell = cell(1,0);
        
        day_x_vels_cell = cell(1,0);
        day_y_vels_cell = cell(1,0);
        touch_frames = zeros(1,0);
        j=0;
        touch_frame = [];
        for block = 1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/trajectory_data.mat'])
            for i = 1:length(trajectory_data)
                if ~isempty(trajectory_data(i).x_coor)
                    j=j+1;
                    day_x_coor_cell{j} = trajectory_data(i).x_coor;
                    day_y_coor_cell{j} = trajectory_data(i).y_coor;
                    
                    day_x_vels_cell{j} = diff(trajectory_data(i).x_coor) * param.Camera_framerate;
                    day_y_vels_cell{j} = diff(trajectory_data(i).y_coor) * param.Camera_framerate;
                    
                    frames = str2num(data{i,2}); %#ok<ST2NM>
                    if frames(end) == 1
                        touch_frame(j) = 1 + frames(end-3) - frames(end-4); %#ok<SAGROW>
                    else
                        touch_frame(j) = 1 + frames(end-1) - frames(end-2); %#ok<SAGROW>
                    end
                end
            end
        end
        
        if strcmp(data_to_use,'coordinates')
            day_x_data_cell = day_x_coor_cell;
            day_y_data_cell = day_y_coor_cell;
        elseif strcmp(data_to_use,'velocity')
            day_x_data_cell = day_x_vels_cell;
            day_y_data_cell = day_y_vels_cell;
            touch_frame = touch_frame - 1;
        else
            error('Error: Unrecognised data source')
        end
        
        max_pre_touch = max(touch_frame);
        max_post_touch = max(cellfun(@length,day_x_data_cell) - touch_frame);
        
        day_x_data = nan(length(day_x_coor_cell),max_pre_touch+max_post_touch);
        day_y_data = nan(length(day_y_coor_cell),max_pre_touch+max_post_touch);
        
        final_pre_vals = 1:(1/(max_pre_touch-1)):2;
        final_post_vals = 2:(1/max_post_touch):3;
        
        for i = 1:length(day_x_data_cell)
            init_pre_vals = 1:(1/(touch_frame(i)-1)):2;
            init_post_vals = 2:(1/(length(day_x_data_cell{i})-touch_frame(i))):3;
            
            day_x_data(i,1:max_pre_touch) = interp1(init_pre_vals,day_x_data_cell{i}(1:touch_frame(i)),final_pre_vals);
            day_x_data(i,max_pre_touch:end) = interp1(init_post_vals,day_x_data_cell{i}(touch_frame(i):end),final_post_vals);
            
            day_y_data(i,1:max_pre_touch) = interp1(init_pre_vals,day_y_data_cell{i}(1:touch_frame(i)),final_pre_vals);
            day_y_data(i,max_pre_touch:end) = interp1(init_post_vals,day_y_data_cell{i}(touch_frame(i):end),final_post_vals);
        end
        day_x_mean = mean(day_x_data,1);
        day_y_mean = mean(day_y_data,1);
        
        day_x_corrs = corr(day_x_data', day_x_mean');
        day_y_corrs = corr(day_y_data', day_y_mean');
        
        shared_data.x_trajectory_consistency(day) = mean(day_x_corrs);
        shared_data.y_trajectory_consistency(day) = mean(day_y_corrs);
    end
    save([rootpath,animal,'/Shared_Data.mat'],'shared_data')
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Neural Activity Template Matching (58)

if enabled(58)
    disp('Block 58...')
    RtG_dur_threshold = inf;
    spikes_per_trial_threshold = 1;
    bin_width = 0.02; %in seconds
    edges = -4:bin_width:4;
    analysis_window = [-1,1.25];
    baseline_window = [-4,4];
    kern_stdv = .06;
    gauss_kernel = gausswin((length(edges)-1) * 2,1/kern_stdv);
    M1_neurons_of_interest = []; %param.M1_task_related_neurons;
    Cb_neurons_of_interest = []; %param.Cb_task_related_neurons;
    if isempty(M1_neurons_of_interest)
        M1_neurons_of_interest = cell(param.days,1);
        for day = 1:param.days
            M1_neurons_of_interest{day} = ones(param.M1_chans, param.M1_neurons);
        end
    end
    if isempty(Cb_neurons_of_interest)
        Cb_neurons_of_interest = cell(param.days,1);
        for day = 1:param.days
            Cb_neurons_of_interest{day} = ones(param.Cb_chans, param.Cb_neurons);
        end
    end
    load([rootpath,animal,'/Shared_Data.mat'])
    shared_data.M1_neuron_activity_template_correlation = cell(1,param.days);
    shared_data.Cb_neuron_activity_template_correlation = cell(1,param.days);
    for day = 1:param.days
        M1_all_trial_activity = nan(length(edges(edges >= analysis_window(1) & edges < analysis_window(2))),sum(M1_neurons_of_interest{day}(:)),0);
        Cb_all_trial_activity = nan(length(edges(edges >= analysis_window(1) & edges < analysis_window(2))),sum(Cb_neurons_of_interest{day}(:)),0);
        for block = 1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/inter_event_intervals.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/spiketrain_snapshots_full.mat']);
            
            outcomes = cellfun(@str2double,data(:,3)); %Do not use bad trials from file, noisey trials don't matter just like noisey channels don't
            bad_trials = 1:size(data,1);
            bad_trials(outcomes < 2) = [];
            
            M1_succ_spiketimes = M1_spike_snapshots_full;%[M1_succ_spiketimes, ~] = success_fail_split(M1_spike_snapshots_full, data, bad_trials, 3);
            Cb_succ_spiketimes = Cb_spike_snapshots_full;%[Cb_succ_spiketimes, ~] = success_fail_split(Cb_spike_snapshots_full, data, bad_trials, 3);
            
            trial_num = 1:size(data,1);
            trial_num(bad_trials) = [];
            %[trial_num, ~] = success_fail_split(trial_num, data, bad_trials, 2);
            for trial = 1:size(M1_succ_spiketimes,3)
                if reach_touch_interval(trial_num(trial)) < RtG_dur_threshold
                    trial_data = nan(length(edges(edges >= analysis_window(1) & edges < analysis_window(2))),length(M1_neurons_of_interest{day}(:)));
                    for neuron = 1:length(M1_neurons_of_interest{day}(:))
                        if M1_neurons_of_interest{day}(neuron)
                            spike_times = M1_succ_spiketimes(:,:,trial);
                            spike_times = (spike_times{neuron}/param.M1_Fs) - 4;
                            spike_hist = histcounts(spike_times,edges);
                            smoothed_spike_rate = conv(spike_hist,gauss_kernel,'same');
                            
                            bl_data_bool = edges >= baseline_window(1) & edges < baseline_window(2);
                            bl_spike_rate = smoothed_spike_rate(bl_data_bool(1:end-1));
                            if length(spike_times) < spikes_per_trial_threshold  %Problematic: day 1, trial 7, neuron 3 (46)
                                norm_spike_rate = zeros(size(smoothed_spike_rate));
                            else
                                norm_spike_rate = (smoothed_spike_rate - mean(bl_spike_rate))/std(bl_spike_rate);
                            end
                            
                            data_bool = edges >= analysis_window(1) & edges < analysis_window(2);
                            trial_data(:,neuron) = norm_spike_rate(data_bool(1:end-1));
                        end
                    end
                    trial_data = trial_data(:,logical(M1_neurons_of_interest{day}(:)));
                    M1_all_trial_activity = cat(3, M1_all_trial_activity, trial_data);
                end
            end
            
            trial_num = 1:size(data,1);
            trial_num(bad_trials) = [];
            %[trial_num, ~] = success_fail_split(trial_num, data, bad_trials, 2);
            for trial = 1:size(Cb_succ_spiketimes,3)
                if reach_touch_interval(trial_num(trial)) < RtG_dur_threshold
                    trial_data = nan(length(edges(edges >= analysis_window(1) & edges < analysis_window(2))),length(Cb_neurons_of_interest{day}(:)));
                    for neuron = 1:length(Cb_neurons_of_interest{day}(:))
                        if Cb_neurons_of_interest{day}(neuron)
                            spike_times = Cb_succ_spiketimes(:,:,trial);
                            spike_times = (spike_times{neuron}/param.Cb_Fs) - 4;
                            spike_hist = histcounts(spike_times,edges);
                            smoothed_spike_rate = conv(spike_hist,gauss_kernel,'same');
                            
                            bl_data_bool = edges >= baseline_window(1) & edges < baseline_window(2);
                            bl_spike_rate = smoothed_spike_rate(bl_data_bool(1:end-1));
                            if length(spike_times) < spikes_per_trial_threshold
                                norm_spike_rate = zeros(size(smoothed_spike_rate));
                            else
                                norm_spike_rate = (smoothed_spike_rate - mean(bl_spike_rate))/std(bl_spike_rate);
                            end                            
                            data_bool = edges >= analysis_window(1) & edges < analysis_window(2);
                            trial_data(:,neuron) = norm_spike_rate(data_bool(1:end-1));
                        end
                    end
                    trial_data = trial_data(:,logical(Cb_neurons_of_interest{day}(:)));
                    Cb_all_trial_activity = cat(3, Cb_all_trial_activity, trial_data);
                end
            end
        end
        
        M1_all_trial_activity(:,sum(sum(M1_all_trial_activity,3),1)==0,:) = [];
        Cb_all_trial_activity(:,sum(sum(Cb_all_trial_activity,3),1)==0,:) = [];
        
        M1_template = mean(M1_all_trial_activity,3);
        [~,max_idx] = max(M1_template,[],1);
        [~, sort_idx] = sort(max_idx);
        M1_template = M1_template(:,sort_idx);
        M1_all_trial_activity = M1_all_trial_activity(:,sort_idx,:);
        M1_activity_corrs = nan(1,size(M1_all_trial_activity,3));
        for t = 1:size(M1_all_trial_activity,3)
            activity_corr = corrcoef(M1_all_trial_activity(:,:,t),M1_template);
            if isnan(activity_corr(1,2))
                M1_activity_corrs(t) = 0;
            else
                M1_activity_corrs(t) = activity_corr(1,2);
            end
        end
        
        Cb_template = mean(Cb_all_trial_activity,3);
        [~,max_idx] = max(Cb_template,[],1);
        [~, sort_idx] = sort(max_idx);
        Cb_template = Cb_template(:,sort_idx);
        Cb_all_trial_activity = Cb_all_trial_activity(:,sort_idx,:);
        Cb_activity_corrs = nan(1,size(Cb_all_trial_activity,3));
        for t = 1:size(Cb_all_trial_activity,3)
            activity_corr = corrcoef(Cb_all_trial_activity(:,:,t),Cb_template);
            if isnan(activity_corr(1,2))
                Cb_activity_corrs(t) = 0;
            else
                Cb_activity_corrs(t) = activity_corr(1,2);
            end
        end
        shared_data.M1_neuron_activity_template_correlation{day} = M1_activity_corrs;
        shared_data.Cb_neuron_activity_template_correlation{day} = Cb_activity_corrs;
        
        M1_template = M1_template';
        figure
        if size(M1_template,1) > 1
            pcolor(edges(edges >= analysis_window(1) & edges < analysis_window(2))+(bin_width/2),1:size(M1_template,1),M1_template)
            shading flat
            colorbar
        else
            title('Less than 2 neurons')
        end
        saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/M1_firing_rate_template.fig']);
        close all;
        
        figure
        if size(M1_template,1) > 1
            mean_corr_dist = abs(M1_activity_corrs - mean(M1_activity_corrs));
            [~,example_idx] = min(mean_corr_dist);
            min_corr_dist = M1_activity_corrs(example_idx);
            pcolor(edges(edges >= analysis_window(1) & edges < analysis_window(2))+(bin_width/2),1:size(M1_template,1),M1_all_trial_activity(:,:,example_idx)')
            title(['Trial ', num2str(example_idx), ' Match = ', num2str(min_corr_dist)])
            shading flat
            colorbar
        else
            title('Less than 2 neurons')
        end
        saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/M1_best_template_match.fig']);
        close all;
        
        
        Cb_template = Cb_template';
        figure
        if size(Cb_template,1) > 1
            pcolor(edges(edges >= analysis_window(1) & edges < analysis_window(2))+(bin_width/2),1:size(Cb_template,1),Cb_template)
            shading flat
            colorbar
        else
            title('Less than 2 neurons')
        end
        saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/Cb_firing_rate_template.fig']);
        close all;
        
        figure
        if size(Cb_template,1) > 1
            mean_corr_dist = abs(Cb_activity_corrs - mean(Cb_activity_corrs));
            [~,example_idx] = min(mean_corr_dist);
            min_corr_dist = Cb_activity_corrs(example_idx);
            pcolor(edges(edges >= analysis_window(1) & edges < analysis_window(2))+(bin_width/2),1:size(Cb_template,1),Cb_all_trial_activity(:,:,example_idx)')
            title(['Trial ', num2str(example_idx), ' Match = ', num2str(min_corr_dist)])
            shading flat
            colorbar
        else
            title('Less than 2 neurons')
        end
        saveas(gcf, [rootpath,animal,'/Day',num2str(day),'/Cb_best_template_match.fig']);
        close all;
        
    end
    save([rootpath,animal,'/Shared_Data.mat'],'shared_data')
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Trial-by-trial LFP of Selected Channel (59)

if enabled(59)
    disp('Block 59...')
    
    %Notes: I086, M1: 16 has even better S vs F but bad D1 vs D5
    M1_channel_of_interest = 9; %   I060: 6 I076: 15 I061: 29 I064: 28 I086: 9  I089: 2, 26
    Cb_channel_of_interest = 60; %  I060: 7 I076: 23 I061: 20 I064: 17 I086: 57 I089: 7
    
    M1_chan = find(ismember(param.M1_good_chans, M1_channel_of_interest));
    Cb_chan = find(ismember(param.Cb_good_chans, Cb_channel_of_interest));
    
    if isempty(M1_chan)
        error('Bad M1 channel.')
    end
    if isempty(Cb_chan)
        error('Bad Cb channel.')
    end
    
    %Trial nums are relative to the all trial figures
    M1_trials_of_interest = {[],[];...
                             [],[];...
                             [],[];...
                             [],[];...
                             [],[]};
    Cb_trials_of_interest = {[],[];...
                             [],[];...
                             [],[];...
                             [],[];...
                             [],[]};
                         
    for day=1:param.days
        for block=1:param.blocks
            
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Normalized_full_Snapshots', '.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Filtered_LFP_full_Snapshots.mat']); %M1_1_4_snapshots
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/inter_event_intervals.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat']);
            
            M1_snapshots = M1_snapshots_n(M1_chan,:,:);
            Cb_snapshots = Cb_snapshots_n(Cb_chan,:,:);
            M1_1_4_snapshots = M1_1_4_snapshots_n(M1_chan,:,:);
            Cb_1_4_snapshots = Cb_1_4_snapshots_n(Cb_chan,:,:);
            
            [M1_snapshots, Cb_snapshots] = get_common_good_data(M1_snapshots, Cb_snapshots, M1_bad_trials, Cb_bad_trials, 3);
            common_bad_trials = unique([M1_bad_trials, Cb_bad_trials]);
            common_good_trials = 1:size(data,1);
            common_good_trials(common_bad_trials) = [];
            main_trial_num = 1:(size(M1_snapshots,3));
            
            [M1_succ_snapshots, M1_fail_snapshots] = success_fail_split(M1_snapshots, data, common_bad_trials, 3);
            [Cb_succ_snapshots, Cb_fail_snapshots] = success_fail_split(Cb_snapshots, data, common_bad_trials, 3);
            [M1_succ_filt, M1_fail_filt] = success_fail_split(M1_1_4_snapshots, data, common_bad_trials, 3);
            [Cb_succ_filt, Cb_fail_filt] = success_fail_split(Cb_1_4_snapshots, data, common_bad_trials, 3);
            [succ_main_trial_num, fail_main_trial_num] = success_fail_split(main_trial_num, data, common_bad_trials, 2);
            
            M1_time_course = (0:(size(M1_snapshots,2)-1)) - (4 * param.M1_Fs);
            Cb_time_course = (0:(size(Cb_snapshots,2)-1)) - (4 * param.Cb_Fs);
            
            M1_reach_touch_interval = reach_touch_interval;
            M1_reach_retract_interval = reach_retract_interval;
            Cb_reach_touch_interval = reach_touch_interval;
            Cb_reach_retract_interval = reach_retract_interval;
            
            M1_reach_touch_interval(common_bad_trials) = [];
            M1_reach_retract_interval(common_bad_trials) = [];
            Cb_reach_touch_interval(common_bad_trials) = [];
            Cb_reach_retract_interval(common_bad_trials) = [];
            
            
            [M1_reach_touch_interval_succ, ~] = success_fail_split(M1_reach_touch_interval, data, common_bad_trials, 1);
            [M1_reach_retract_interval_succ, ~] = success_fail_split(M1_reach_retract_interval, data, common_bad_trials, 1);
            [Cb_reach_touch_interval_succ, ~] = success_fail_split(Cb_reach_touch_interval, data, common_bad_trials, 1);
            [Cb_reach_retract_interval_succ, ~] = success_fail_split(Cb_reach_retract_interval, data, common_bad_trials, 1);
            
            if isempty(M1_fail_snapshots)
                disp(['Day: ', num2str(day), ', Block: ', num2str(block), ' - No failure M1 trials'])
            end
            if isempty(M1_succ_snapshots)
                disp(['Day: ', num2str(day), ', Block: ', num2str(block), ' - No successful M1 trials'])
            else
%                 figure
%                 for i = 1:size(M1_succ_snapshots,3)
%                     subplot(5,ceil(size(M1_succ_snapshots,3)/5),i);
%                     M1_succ_snapshots_mean = mean(M1_succ_snapshots(:,:,i),1);
%                     M1_succ_shapshots_filt = eegfilt(M1_succ_snapshots_mean, Fs, 3.0, 6.0);
%                     plot(time_course,M1_succ_snapshots_mean,'r-')%,time_course,M1_succ_snapshots(10,:,i),'m-')
%                     line(time_course, M1_succ_shapshots_filt, 'Color', 'black');
%                     axis([round(-.8*Fs) round(1.2*Fs) -2 2])
%                     line([0 0], [-2 2], 'Color', 'green', 'LineStyle', '--')
%                     line([(M1_reach_touch_interval_succ(i)*Fs) (M1_reach_touch_interval_succ(i)*Fs)], [-2 2], 'Color', 'blue', 'LineStyle', '--')
%                     line([(M1_reach_retract_interval_succ(i)*Fs) (M1_reach_retract_interval_succ(i)*Fs)], [-2 2], 'Color', 'black', 'LineStyle', '--');
%                 end
%                 saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/',block_names{block},'/M1_All_success_Trials_LFP', '.fig']);
%                 close all;
%                 
%                 figure
%                 for i = 1:size(Cb_succ_snapshots,3)
%                     subplot(5,ceil(size(Cb_succ_snapshots,3)/5),i);
%                     Cb_succ_snapshots_mean = mean(Cb_succ_snapshots(:,:,i),1);
%                     Cb_succ_shapshots_filt = eegfilt(Cb_succ_snapshots_mean, Fs, 3.0, 6.0);
%                     plot(time_course,Cb_succ_snapshots_mean,'g-')%, time_course,Cb_succ_snapshots(10,:,i),'c-')
%                     line(time_course, Cb_succ_shapshots_filt, 'Color', 'black');
%                     axis([round(-.8*Fs) round(1.2*Fs) -2 2])
%                     line([0 0], [-2 2], 'Color', 'green', 'LineStyle', '--')
%                     line([(Cb_reach_touch_interval_succ(i)*Fs) (Cb_reach_touch_interval_succ(i)*Fs)], [-2 2], 'Color', 'blue', 'LineStyle', '--')
%                     line([(Cb_reach_retract_interval_succ(i)*Fs) (Cb_reach_retract_interval_succ(i)*Fs)], [-2 2], 'Color', 'black', 'LineStyle', '--');
%                 end
%                 saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/',block_names{block},'/Cb_All_success_Trials_LFP', '.fig']);
%                 close all;
                
                for i1 = 0:20:size(M1_succ_snapshots,3)-1
                    figure
                    for i2 = 1:min(20,size(M1_succ_snapshots,3)-i1)
                        subplot(5,8,(i2*2)-1);
                        i = i1 + i2;
                        M1_succ_snapshots_trial = M1_succ_snapshots(:,:,i);
                        M1_succ_filt_trial = M1_succ_filt(:,:,i);
                        plot(M1_time_course,M1_succ_snapshots_trial,'r-')%,time_course,M1_succ_snapshots(10,:,i),'m-')
                        line(M1_time_course, M1_succ_filt_trial, 'Color', 'black');
                        axis([round(-.8*param.M1_Fs) round(1.2*param.M1_Fs) -4 4])
                        line([0 0], [-4 4], 'Color', 'green', 'LineStyle', '--')
                        line([(M1_reach_touch_interval_succ(i)*param.M1_Fs) (M1_reach_touch_interval_succ(i)*param.M1_Fs)], [-4 4], 'Color', 'blue', 'LineStyle', '--')
                        line([(M1_reach_retract_interval_succ(i)*param.M1_Fs) (M1_reach_retract_interval_succ(i)*param.M1_Fs)], [-4 4], 'Color', 'black', 'LineStyle', '--');
                        title(num2str(common_good_trials(succ_main_trial_num(i))));
                        
                        subplot(5,8,(i2*2));
                        Cb_succ_snapshots_trial = Cb_succ_snapshots(:,:,i);
                        Cb_succ_filt_trial = Cb_succ_filt(:,:,i); 
                        plot(Cb_time_course,Cb_succ_snapshots_trial,'g-')%, time_course,Cb_succ_snapshots(10,:,i),'c-')
                        line(Cb_time_course, Cb_succ_filt_trial, 'Color', 'black');
                        axis([round(-.8*param.Cb_Fs) round(1.2*param.Cb_Fs) -4 4])
                        line([0 0], [-4 4], 'Color', 'green', 'LineStyle', '--')
                        line([(Cb_reach_touch_interval_succ(i)*param.Cb_Fs) (Cb_reach_touch_interval_succ(i)*param.Cb_Fs)], [-4 4], 'Color', 'blue', 'LineStyle', '--')
                        line([(Cb_reach_retract_interval_succ(i)*param.Cb_Fs) (Cb_reach_retract_interval_succ(i)*param.Cb_Fs)], [-4 4], 'Color', 'black', 'LineStyle', '--');
                    end
                    saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/All_success_Trials_single_Chan_compare',num2str((i1/20)+1), '.fig']);
                    close all;
                end
                
                for true_trial_num = M1_trials_of_interest{day,block}
                    trial = find(common_good_trials == true_trial_num);
                    succ_trial = find(succ_main_trial_num == trial);
                    figure
                    
                    M1_succ_shapshot_filt = M1_succ_filt(:,:,succ_trial);
                    plot(M1_time_course,M1_succ_snapshots(:,:,succ_trial),'r-')
                    line(M1_time_course, M1_succ_shapshot_filt, 'Color', 'black');
                    axis([round(-.8*param.M1_Fs) round(1.2*param.M1_Fs) -4 4])
                    line([0 0], [-4 4], 'Color', 'green', 'LineStyle', '--')
                    line([(M1_reach_touch_interval_succ(succ_trial)*param.M1_Fs) (M1_reach_touch_interval_succ(succ_trial)*param.M1_Fs)], [-4 4], 'Color', 'blue', 'LineStyle', '--')
                    line([(M1_reach_retract_interval_succ(succ_trial)*param.M1_Fs) (M1_reach_retract_interval_succ(succ_trial)*param.M1_Fs)], [-4 4], 'Color', 'black', 'LineStyle', '--');

                    saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/M1_channel_', num2str(M1_channel_of_interest), '_Trial_',num2str(true_trial_num),'_LFP', '.fig']);
                    close all;
                end
                
                for true_trial_num = Cb_trials_of_interest{day,block}
                    trial = find(common_good_trials == true_trial_num);
                    succ_trial = find(succ_main_trial_num == trial);
                    figure
                    
                    Cb_succ_shapshot_filt = Cb_succ_filt(:,:,succ_trial);
                    
                    plot(Cb_time_course,Cb_succ_snapshots(:,:,succ_trial),'g-')
                    line(Cb_time_course, Cb_succ_shapshot_filt, 'Color', 'black');
                    axis([round(-.8*param.Cb_Fs) round(1.2*param.Cb_Fs) -4 4])
                    line([0 0], [-4 4], 'Color', 'green', 'LineStyle', '--')
                    line([(Cb_reach_touch_interval_succ(succ_trial)*param.Cb_Fs) (Cb_reach_touch_interval_succ(succ_trial)*param.Cb_Fs)], [-4 4], 'Color', 'blue', 'LineStyle', '--')
                    line([(Cb_reach_retract_interval_succ(succ_trial)*param.Cb_Fs) (Cb_reach_retract_interval_succ(succ_trial)*param.Cb_Fs)], [-4 4], 'Color', 'black', 'LineStyle', '--');
                    
                    saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Cb_channel_', num2str(Cb_channel_of_interest), '_Trial_',num2str(true_trial_num),'_LFP', '.fig']);
                    close all;
                end
            end
        end
    end
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Canonical Correlation Analysis (60)

if enabled(60)
    disp('Block 60...')
    
    M1_neurons_of_interest = param.M1_task_related_neurons;
    Cb_neurons_of_interest = param.Cb_task_related_neurons;
    
    bin_width = 0.1;
    hist_window = [-.25 .75];
    edges = hist_window(1):bin_width:hist_window(2);
    
    load([rootpath,animal,'/Shared_Data.mat'])
    shared_data.canonical_coor = nan(1, param.days);
    shared_data.M1_subspace_activity = cell(1, param.days);
    shared_data.Cb_subspace_activity = cell(1, param.days);
    
    %find min number of neurons in each area across all days with 6 neurons in both M1 and Cb
    min_M1_n = inf;
    min_Cb_n = inf;
    for day=1:param.days
        M1_neurons_of_interest{day} = M1_neurons_of_interest{day} & param.M1_task_related_neurons{day};
        Cb_neurons_of_interest{day} = Cb_neurons_of_interest{day} & param.Cb_task_related_neurons{day};
        
        if sum(M1_neurons_of_interest{day}(:)) > 5 && sum(Cb_neurons_of_interest{day}(:)) > 5
            min_M1_n = min(min_M1_n, sum(M1_neurons_of_interest{day}(:)));
            min_Cb_n = min(min_Cb_n, sum(Cb_neurons_of_interest{day}(:)));
        else
            M1_neurons_of_interest{day} = false(size(M1_neurons_of_interest{day}));
            Cb_neurons_of_interest{day} = false(size(Cb_neurons_of_interest{day}));
        end
    end
    
    for day=1:param.days
        if sum(M1_neurons_of_interest{day}(:)) < min_M1_n
            continue
        end
        %remove random neurons from each area until that area's cross-day minimum is reached
        idxs = find(M1_neurons_of_interest{day});
        removed = randsample(idxs,length(idxs) - min_M1_n,false);
        M1_neurons_of_interest{day}(removed) = false;
        
        idxs = find(Cb_neurons_of_interest{day});
        removed = randsample(idxs,length(idxs) - min_Cb_n,false);
        Cb_neurons_of_interest{day}(removed) = false;
        
        M1_day_spike_snapshots = cell(param.M1_chans, param.M1_neurons,0);
        Cb_day_spike_snapshots = cell(param.Cb_chans, param.Cb_neurons,0);
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/spiketrain_snapshots_full.mat']);
            M1_day_spike_snapshots = cat(3, M1_day_spike_snapshots, M1_spike_snapshots_full);
            Cb_day_spike_snapshots = cat(3, Cb_day_spike_snapshots, Cb_spike_snapshots_full);
        end
        M1_day_spike_snapshots = reshape(M1_day_spike_snapshots, [param.M1_chans * param.M1_neurons, size(M1_day_spike_snapshots,3)]);
        M1_day_spike_snapshots = M1_day_spike_snapshots(M1_neurons_of_interest{day}(:),:);
        Cb_day_spike_snapshots = reshape(Cb_day_spike_snapshots, [param.Cb_chans * param.Cb_neurons, size(Cb_day_spike_snapshots,3)]);
        Cb_day_spike_snapshots = Cb_day_spike_snapshots(Cb_neurons_of_interest{day}(:),:);
        
        %make arrays of size (bins*trials) X neurons containing binned spike times concatenated across trials
        M1_spiking_data = nan(round((hist_window(2)-hist_window(1))/bin_width)*size(M1_day_spike_snapshots,2), min_M1_n);
        Cb_spiking_data = nan(round((hist_window(2)-hist_window(1))/bin_width)*size(Cb_day_spike_snapshots,2), min_Cb_n);
        
        for neuron = 1:min_M1_n
            neuron_data = nan(0,1);
            for trial = 1:size(M1_day_spike_snapshots,2)
                trial_data = histcounts(((M1_day_spike_snapshots{neuron,trial}/param.M1_Fs) - 4),edges);
                neuron_data = cat(1, neuron_data,trial_data');
            end
            M1_spiking_data(:,neuron) = neuron_data;
        end
        for neuron = 1:min_Cb_n
            neuron_data = nan(0,1);
            for trial = 1:size(Cb_day_spike_snapshots,2)
                trial_data = histcounts(((Cb_day_spike_snapshots{neuron,trial}/param.Cb_Fs) - 4),edges);
                neuron_data = cat(1, neuron_data,trial_data');
            end
            Cb_spiking_data(:,neuron) = neuron_data;
        end
        
        %fit CCA model: A and B are canonical coefficients, U and V are canonical variables, and r is the corrilations between the columns of U and V
        [A, B, r, U, V] = canoncorr(M1_spiking_data, Cb_spiking_data);
        
        %Plot only the top canonical component
        scatter(U(:,1), V(:,1), 10, 'filled')
        title(['r = ', num2str(corr(U(:,1), V(:,1)))])
        xlabel('M1 subspace activity') 
        ylabel('Cb subspace activity')
        saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Subspace_activity.fig']);
        close all
        
%         x = edges(1:end-1) + (diff(edges)/2);
%         y = 1:size(M1_day_spike_snapshots,2);
%         z = reshape(U(:,1), [length(x), length(y)]);
%         %Sort z by touch time
%         pcolor(x,y,z')
%         shading flat
%         %save
%         close all
%         %repeat for Cb
        
        shared_data.canonical_coor(day) = r(1);
        shared_data.M1_subspace_activity{day} = U(:,1);
        shared_data.Cb_subspace_activity{day} = V(:,1);
    end
    save([rootpath,animal,'/Shared_Data.mat'],'shared_data')
    
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Create models for Speed Decoding (61)

if enabled(61)
    disp('Block 61...')
    
    M1_neurons_of_interest = param.M1_task_related_neurons;
    Cb_neurons_of_interest = param.Cb_task_related_neurons;
    min_day_neurons = 6;
    comb_min_neurons = 5;
    M1_day_skips = nan(1,0);
    Cb_day_skips = nan(1,0);
    comb_day_skips = nan(1,0);
    
    bin_size = 20; %ms
    pre_touch_interval = 100; %ms
    post_touch_interval = 0; %ms
    max_lag = 180; %ms; Minimum lag is always 0
    lags = 0:bin_size:max_lag;
    
    frame_step = 1000/param.Camera_framerate; %ms between two frames
    
    M1_min_neurons = inf;
    Cb_min_neurons = inf;
    comb_M1_min_neurons = inf;
    comb_Cb_min_neurons = inf;
    for day = 1:param.days
        
        if iscell(M1_neurons_of_interest)
            M1_day_neurons_of_interest = M1_neurons_of_interest{day};
        else
            M1_day_neurons_of_interest = M1_neurons_of_interest;
        end
        if iscell(Cb_neurons_of_interest)
            Cb_day_neurons_of_interest = Cb_neurons_of_interest{day};
        else
            Cb_day_neurons_of_interest = Cb_neurons_of_interest;
        end
        
        if sum(M1_day_neurons_of_interest(:)) < min_day_neurons
            M1_day_skips = [M1_day_skips day]; %#ok<AGROW>
        else
            M1_min_neurons = min(M1_min_neurons,sum(M1_day_neurons_of_interest(:)));
        end
        if sum(Cb_day_neurons_of_interest(:)) < min_day_neurons
            Cb_day_skips = [Cb_day_skips day]; %#ok<AGROW>
        else
            Cb_min_neurons = min(Cb_min_neurons,sum(Cb_day_neurons_of_interest(:)));
        end
        if (sum(M1_day_neurons_of_interest(:)) < comb_min_neurons) && (sum(Cb_day_neurons_of_interest(:)) < comb_min_neurons)
            comb_day_skips = [comb_day_skips day]; %#ok<AGROW>
        else
            comb_M1_min_neurons = min(comb_M1_min_neurons,sum(M1_day_neurons_of_interest(:)));
            comb_Cb_min_neurons = min(comb_Cb_min_neurons,sum(Cb_day_neurons_of_interest(:)));
        end
        
    end
    
    for day = 1:param.days
        
        if iscell(M1_neurons_of_interest)
            M1_day_neurons_of_interest = M1_neurons_of_interest{day};
            comb_M1_day_neurons_of_interest = M1_neurons_of_interest{day};
        else
            M1_day_neurons_of_interest = M1_neurons_of_interest;
            comb_M1_day_neurons_of_interest = M1_neurons_of_interest;
        end
        if iscell(Cb_neurons_of_interest)
            Cb_day_neurons_of_interest = Cb_neurons_of_interest{day};
            comb_Cb_day_neurons_of_interest = Cb_neurons_of_interest{day};
        else
            Cb_day_neurons_of_interest = Cb_neurons_of_interest;
            comb_Cb_day_neurons_of_interest = Cb_neurons_of_interest;
        end
        
        if ~ismember(day, M1_day_skips)
            M1_NoI_idxs = find(M1_day_neurons_of_interest);
            new_M1_NoI_idxs = datasample(M1_NoI_idxs, M1_min_neurons, 'Replace', false);
            M1_day_neurons_of_interest = zeros(size(M1_day_neurons_of_interest));
            M1_day_neurons_of_interest(new_M1_NoI_idxs) = 1;
            
            M1_spike_counts = nan(0,sum(M1_day_neurons_of_interest(:))*length(lags));
        end
        
        if ~ismember(day, Cb_day_skips)
            Cb_NoI_idxs = find(Cb_day_neurons_of_interest);
            new_Cb_NoI_idxs = datasample(Cb_NoI_idxs, Cb_min_neurons, 'Replace', false);
            Cb_day_neurons_of_interest = zeros(size(Cb_day_neurons_of_interest));
            Cb_day_neurons_of_interest(new_Cb_NoI_idxs) = 1;
            
            Cb_spike_counts = nan(0,sum(Cb_day_neurons_of_interest(:))*length(lags));
        end
        
        if ~ismember(day, comb_day_skips)
            comb_M1_NoI_idxs = find(comb_M1_day_neurons_of_interest);
            new_comb_M1_NoI_idxs = datasample(comb_M1_NoI_idxs, comb_M1_min_neurons, 'Replace', false);
            comb_Cb_NoI_idxs = find(comb_Cb_day_neurons_of_interest);
            new_comb_Cb_NoI_idxs = datasample(comb_Cb_NoI_idxs, comb_Cb_min_neurons, 'Replace', false);
            
            comb_M1_day_neurons_of_interest = zeros(size(comb_M1_day_neurons_of_interest));
            comb_M1_day_neurons_of_interest(new_comb_M1_NoI_idxs) = 1;
            
            comb_Cb_day_neurons_of_interest = zeros(size(comb_Cb_day_neurons_of_interest));
            comb_Cb_day_neurons_of_interest(new_comb_Cb_NoI_idxs) = 1;

            comb_spike_counts = nan(0,(sum(comb_M1_day_neurons_of_interest(:)) + sum(comb_Cb_day_neurons_of_interest(:)))*length(lags));
        end
        
        vel_data = nan(0,1);
        outcome_data = nan(0,1);
        reach_idxs = nan(1,0);
        %reach_idxs_spike = nan(1,0);
        touch_idxs = nan(1,0);
        %touch_idxs_spike = nan(1,0);
        for block = 1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/spiketrain_snapshots_full.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/trajectory_data.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat']);
            
            trial_codes = str2double(data(:,3));
            all_good_trials = find(trial_codes < 2);
            
            for trial = 1:length(all_good_trials)
                %interpolate position data and calculate velocity
                frame_nums = str2num(data{all_good_trials(trial),2}); %#ok<ST2NM>
                if strcmp(data{all_good_trials(trial),3},'1')
                    touch_idx = 1 + round(frame_nums(end-1) - frame_nums(end-2));
                    retract_idx = 1 + round(frame_nums(end) - frame_nums(end-2));
                elseif strcmp(data{all_good_trials(trial),3},'0') && frame_nums(end) == 1
                    touch_idx = 1 + round(frame_nums(end-3) - frame_nums(end-4));
                    retract_idx = 1 + round(frame_nums(end-1) - frame_nums(end-4));
                else
                    continue
                end
                reach_idx_ms = 4000;
                touch_offset_ms = round((touch_idx-1) * frame_step);
                retract_offset_ms = round((retract_idx-1) * frame_step);
                touch_idx_ms = reach_idx_ms + touch_offset_ms;
                retract_idx_ms = reach_idx_ms + retract_offset_ms;
                touch_idx_step = round((touch_idx-1) * (frame_step/bin_size)) + 1;
                %retract_idx_step = round((touch_idx-1) * (frame_step/bin_size)) + 1;
                %bin_edges = (touch_idx_ms - (touch_offset_bin_ms + max_lag)):bin_size:(touch_idx_ms + post_touch_interval);
                bin_edges = reach_idx_ms-max_lag:bin_size:floor(retract_idx_ms/bin_size)*bin_size;
                
                
                old_steps = 0:(length(trajectory_data(all_good_trials(trial)).x_coor)-1);
                old_steps = old_steps*frame_step;
                new_steps = 0:bin_size:(floor(old_steps(end)/bin_size)*bin_size);
                
                x_coors = interp1(old_steps, trajectory_data(all_good_trials(trial)).x_coor, new_steps);
                y_coors = interp1(old_steps, trajectory_data(all_good_trials(trial)).y_coor, new_steps);
                
                x_change = diff(x_coors);
                y_change = diff(y_coors);
                tot_change = (x_change.^2) + (y_change.^2);
                tot_change = tot_change.^(0.5);
                
                x_vel = x_change'/bin_size; %pix per ms
                y_vel = y_change'/bin_size; %pix per ms
                tot_vel = tot_change'/bin_size; %pix per ms
                vel = tot_vel; %use this to set the reach data used 
                         
                reach_idxs = [reach_idxs (length(vel_data)+1)]; %#ok<AGROW>
                touch_idxs = [touch_idxs (length(vel_data) + touch_idx_step)]; %#ok<AGROW>
                vel_data = [vel_data; vel]; %#ok<AGROW>
                
                if strcmp(data{all_good_trials(trial),3},'1')
                    outcome = true(size(vel));
                else
                    outcome = false(size(vel));
                end
                outcome_data = [outcome_data; outcome]; %#ok<AGROW>
                
                %vel_window_idxs = touch_idx_step-(pre_touch_interval/bin_size):touch_idx_step+(post_touch_interval/bin_size)-1;
                
                if ~ismember(day, M1_day_skips)
                    trial_spike_data = zeros(length(bin_edges)-1, sum(M1_day_neurons_of_interest(:)));
                    neuron_idx = 0;
                    for neuron_ch = 1:size(M1_day_neurons_of_interest,1)
                        for neuron_num = 1:size(M1_day_neurons_of_interest,2)
                            if M1_day_neurons_of_interest(neuron_ch,neuron_num)
                                neuron_idx = neuron_idx+1;
                                neuron_spiketimes = M1_spike_snapshots_full{neuron_ch,neuron_num,trial};
                                neuron_spiketimes = neuron_spiketimes * 1000/param.M1_Fs;
                                trial_spike_counts = histcounts(neuron_spiketimes, bin_edges);
                                
                                trial_spike_data(:,neuron_idx) = trial_spike_counts;
                            end
                        end
                    end
                    
                    trial_lag_spike_data = nan(length(vel), size(trial_spike_data,2)*length(lags));
                    for lag_idx = 1:length(lags)
                        trial_lag_spike_data(:,1+((lag_idx-1)*size(trial_spike_data,2)):((lag_idx)*size(trial_spike_data,2))) = trial_spike_data((length(lags)+1-lag_idx):(length(lags)+length(vel)-lag_idx),:);
                    end
                    
                    M1_spike_counts = cat(1, M1_spike_counts, trial_lag_spike_data);
                end
                
                if ~ismember(day, Cb_day_skips)
                    trial_spike_data = zeros(length(bin_edges)-1, sum(Cb_day_neurons_of_interest(:)));
                    neuron_idx = 0;
                    for neuron_ch = 1:size(Cb_day_neurons_of_interest,1)
                        for neuron_num = 1:size(Cb_day_neurons_of_interest,2)
                            if Cb_day_neurons_of_interest(neuron_ch,neuron_num)
                                neuron_idx = neuron_idx+1;
                                neuron_spiketimes = Cb_spike_snapshots_full{neuron_ch,neuron_num,trial};
                                neuron_spiketimes = neuron_spiketimes * 1000/param.Cb_Fs;
                                trial_spike_counts = histcounts(neuron_spiketimes, bin_edges);
                                
                                trial_spike_data(:,neuron_idx) = trial_spike_counts;
                            end
                        end
                    end
                    
                    trial_lag_spike_data = nan(length(vel), size(trial_spike_data,2)*length(lags));
                    for lag_idx = 1:length(lags)
                        trial_lag_spike_data(:,1+((lag_idx-1)*size(trial_spike_data,2)):((lag_idx)*size(trial_spike_data,2))) = trial_spike_data((length(lags)+1-lag_idx):(length(lags)+length(vel)-lag_idx),:);
                    end
                    
                    Cb_spike_counts = cat(1, Cb_spike_counts, trial_lag_spike_data);
                end
                
                if ~ismember(day, comb_day_skips)
                    trial_spike_data = zeros(length(bin_edges)-1, sum(comb_M1_day_neurons_of_interest(:)) + sum(comb_Cb_day_neurons_of_interest(:)));
                    neuron_idx = 0;
                    for neuron_ch = 1:size(comb_M1_day_neurons_of_interest,1)
                        for neuron_num = 1:size(comb_M1_day_neurons_of_interest,2)
                            if comb_M1_day_neurons_of_interest(neuron_ch,neuron_num)
                                neuron_idx = neuron_idx+1;
                                neuron_spiketimes = M1_spike_snapshots_full{neuron_ch,neuron_num,trial};
                                neuron_spiketimes = neuron_spiketimes * 1000/param.M1_Fs;
                                trial_spike_counts = histcounts(neuron_spiketimes, bin_edges);
                                
                                trial_spike_data(:,neuron_idx) = trial_spike_counts;
                            end
                        end
                    end
                    for neuron_ch = 1:size(comb_Cb_day_neurons_of_interest,1)
                        for neuron_num = 1:size(comb_Cb_day_neurons_of_interest,2)
                            if comb_Cb_day_neurons_of_interest(neuron_ch,neuron_num)
                                neuron_idx = neuron_idx+1;
                                neuron_spiketimes = Cb_spike_snapshots_full{neuron_ch,neuron_num,trial};
                                neuron_spiketimes = neuron_spiketimes * 1000/param.Cb_Fs;
                                trial_spike_counts = histcounts(neuron_spiketimes, bin_edges);
                                
                                trial_spike_data(:,neuron_idx) = trial_spike_counts;
                            end
                        end
                    end
                    
                    trial_lag_spike_data = nan(length(vel), size(trial_spike_data,2)*length(lags));
                    for lag_idx = 1:length(lags)
                        trial_lag_spike_data(:,1+((lag_idx-1)*size(trial_spike_data,2)):((lag_idx)*size(trial_spike_data,2))) = trial_spike_data((length(lags)+1-lag_idx):(length(lags)+length(vel)-lag_idx),:);
                    end
                    
                    comb_spike_counts = cat(1, comb_spike_counts, trial_lag_spike_data);
                end
                
                %trial_vel_data = interpolated velocity %Timesteps of 20 ms with
                %trial_spike_data = binned spikes (with margens to cover all planned lags)
                %vel_data = [vel_data trial_vel_data]; %interpolated to match bin intervals. Realigned using selected lag.
                %all_spike_data = cat(1, spike_data, trial_spike_data);
            end
        end
        
        %bin_centers = ((bin_size/2) - max_lag):bin_size:(post_touch_interval-(bin_size/2));
        %M1_trials = size(M1_spike_counts,1)/length(bin_centers);
        %Cb_trials = size(Cb_spike_counts,1)/length(bin_centers);
        if ~ismember(day, M1_day_skips)
            M1_lag_spike_data = M1_spike_counts;
            
            %M1
            %split into 5 and do 5-fold cross validation using r^2
            combined_data = cat(2, vel_data, outcome_data, M1_lag_spike_data);
            separated_data = split_data(combined_data, [.2 .2 .2 .2 .2], 1);
            fold_models = cell(1,5);
            r_squared = nan(1,5);
            for fold = 1:5
                %Take the group as a hold out or test data set
                test_data = separated_data{fold};
                training_data = separated_data;
                training_data(fold) = [];
                training_data = cat(1, training_data{:});
                
                %Take the remaining groups as a training data set
                test_spike_data = test_data(:,3:end);
                test_vel_data = test_data(:,1);
                training_spike_data = training_data(:,3:end);
                training_vel_data = training_data(:,1);
                
                %split the training set into 5 and do another 5-fold cross validation using mean squared error to find the best lambda
                lam_separated_data = split_data(training_data, [.2 .2 .2 .2 .2], 1);
                lam_fold_models = cell(1,5);
                mse_evals = nan(1,5);
                for lam_fold = 1:5
                    %Take the group as a hold out or test data set
                    lam_test_data = lam_separated_data{lam_fold};
                    lam_training_data = lam_separated_data;
                    lam_training_data(lam_fold) = [];
                    lam_training_data = cat(1, lam_training_data{:});
                    
                    %Take the remaining groups as a training data set
                    lam_test_spike_data = lam_test_data(:,3:end);
                    lam_test_vel_data = lam_test_data(:,1);
                    lam_training_spike_data = lam_training_data(:,3:end);
                    lam_training_vel_data = lam_training_data(:,1);
                    
                    %Fit a model on the training set
                    lam_fold_models{lam_fold} = fitrlinear(lam_training_spike_data, lam_training_vel_data, 'Regularization', 'lasso');
                    lam_predicted_test_vel_data = predict(lam_fold_models{lam_fold},lam_test_spike_data);
                    mse_evals(lam_fold) = mean((lam_test_vel_data - lam_predicted_test_vel_data).^2);
                end
                [~, best_lam_mod_idx] = min(mse_evals);
                lambda = lam_fold_models{best_lam_mod_idx}.Lambda;
                
                %Fit a model using the best lambda on the whole training set
                fold_models{fold} = fitrlinear(training_spike_data, training_vel_data, 'Lambda', lambda, 'Regularization', 'lasso');
                predicted_test_vel_data = predict(fold_models{fold},test_spike_data);
                r_squared(lam_fold) = 1 - (sum((test_vel_data - predicted_test_vel_data).^2)/sum((test_vel_data - mean(test_vel_data)).^2));
            end
            [~, best_mod_idx] = max(r_squared);
            M1_model = fold_models{best_mod_idx};
            M1_test_vel_data = separated_data{best_mod_idx}(:,1);
            M1_test_outcome_data = logical(separated_data{best_mod_idx}(:,2));
            M1_test_spike_data = separated_data{best_mod_idx}(:,3:end);
        else
            M1_model = -1;
            M1_test_vel_data = -1;
            M1_test_outcome_data = -1;
            M1_test_spike_data = -1;
        end
        
        
        if ~ismember(day, Cb_day_skips)
            Cb_lag_spike_data = Cb_spike_counts;
            
            %Cb
            %split into 5 and do 5-fold cross validation using r^2
            combined_data = cat(2, vel_data, outcome_data, Cb_lag_spike_data);
            separated_data = split_data(combined_data, [.2 .2 .2 .2 .2], 1);
            fold_models = cell(1,5);
            r_squared = nan(1,5);
            for fold = 1:5
                %Take the group as a hold out or test data set
                test_data = separated_data{fold};
                training_data= separated_data;
                training_data(fold) = [];
                training_data = cat(1, training_data{:});
                
                %Take the remaining groups as a training data set
                test_spike_data = test_data(:,3:end);
                test_vel_data = test_data(:,1);
                training_spike_data = training_data(:,3:end);
                training_vel_data = training_data(:,1);
                
                %split the training set into 5 and do another 5-fold cross validation using mean squared error to find the best lambda
                lam_separated_data = split_data(training_data, [.2 .2 .2 .2 .2], 1);
                lam_fold_models = cell(1,5);
                mse_evals = nan(1,5);
                for lam_fold = 1:5
                    %Take the group as a hold out or test data set
                    lam_test_data = lam_separated_data{lam_fold};
                    lam_training_data = lam_separated_data(:,3:end);
                    lam_training_data = cat(1, lam_training_data{:});
                    
                    %Take the remaining groups as a training data set
                    lam_test_spike_data = lam_test_data(:,3:end);
                    lam_test_vel_data = lam_test_data(:,1);
                    lam_training_spike_data = lam_training_data(:,3:end);
                    lam_training_vel_data = lam_training_data(:,1);
                    
                    %Fit a model on the training set
                    lam_fold_models{lam_fold} = fitrlinear(lam_training_spike_data, lam_training_vel_data, 'Regularization', 'lasso');
                    lam_predicted_test_vel_data = predict(lam_fold_models{lam_fold},lam_test_spike_data);
                    mse_evals(lam_fold) = mean((lam_test_vel_data - lam_predicted_test_vel_data).^2);
                end
                [~, best_lam_mod_idx] = min(mse_evals);
                lambda = lam_fold_models{best_lam_mod_idx}.Lambda;
                
                %Fit a model using the best lambda on the whole training set
                fold_models{fold} = fitrlinear(training_spike_data, training_vel_data, 'Lambda', lambda, 'Regularization', 'lasso');
                predicted_test_vel_data = predict(fold_models{fold},test_spike_data);
                r_squared(lam_fold) = 1 - (sum((test_vel_data - predicted_test_vel_data).^2)/sum((test_vel_data - mean(test_vel_data)).^2));
            end
            [~, best_mod_idx] = max(r_squared);
            Cb_model = fold_models{best_mod_idx};
            Cb_test_vel_data = separated_data{best_mod_idx}(:,1);
            Cb_test_outcome_data = logical(separated_data{best_mod_idx}(:,2));
            Cb_test_spike_data = separated_data{best_mod_idx}(:,3:end);
        else
            Cb_model = -1;
            Cb_test_vel_data = -1;
            Cb_test_outcome_data = -1;
            Cb_test_spike_data = -1;
        end
        
        if ~ismember(day, comb_day_skips)
            comb_lag_spike_data = comb_spike_counts;
            
            %combined M1 and Cb
            %split into 5 and do 5-fold cross validation using r^2
            combined_data = cat(2, vel_data, outcome_data, comb_lag_spike_data);
            separated_data = split_data(combined_data, [.2 .2 .2 .2 .2], 1);
            fold_models = cell(1,5);
            r_squared = nan(1,5);
            for fold = 1:5
                %Take the group as a hold out or test data set
                test_data = separated_data{fold};
                training_data = separated_data;
                training_data(fold) = [];
                training_data = cat(1, training_data{:});
                
                %Take the remaining groups as a training data set
                test_spike_data = test_data(:,3:end);
                test_vel_data = test_data(:,1);
                training_spike_data = training_data(:,3:end);
                training_vel_data = training_data(:,1);
                
                %split the training set into 5 and do another 5-fold cross validation using mean squared error to find the best lambda
                lam_separated_data = split_data(training_data, [.2 .2 .2 .2 .2], 1);
                lam_fold_models = cell(1,5);
                mse_evals = nan(1,5);
                for lam_fold = 1:5
                    %Take the group as a hold out or test data set
                    lam_test_data = lam_separated_data{lam_fold};
                    lam_training_data = lam_separated_data;
                    lam_training_data(lam_fold) = [];
                    lam_training_data = cat(1, lam_training_data{:});
                    
                    %Take the remaining groups as a training data set
                    lam_test_spike_data = lam_test_data(:,3:end);
                    lam_test_vel_data = lam_test_data(:,1);
                    lam_training_spike_data = lam_training_data(:,3:end);
                    lam_training_vel_data = lam_training_data(:,1);
                    
                    %Fit a model on the training set
                    lam_fold_models{lam_fold} = fitrlinear(lam_training_spike_data, lam_training_vel_data, 'Regularization', 'lasso');
                    lam_predicted_test_vel_data = predict(lam_fold_models{lam_fold},lam_test_spike_data);
                    mse_evals(lam_fold) = mean((lam_test_vel_data - lam_predicted_test_vel_data).^2);
                end
                [~, best_lam_mod_idx] = min(mse_evals);
                lambda = lam_fold_models{best_lam_mod_idx}.Lambda;
                
                %Fit a model using the best lambda on the whole training set
                fold_models{fold} = fitrlinear(training_spike_data, training_vel_data, 'Lambda', lambda, 'Regularization', 'lasso');
                predicted_test_vel_data = predict(fold_models{fold},test_spike_data);
                r_squared(lam_fold) = 1 - (sum((test_vel_data - predicted_test_vel_data).^2)/sum((test_vel_data - mean(test_vel_data)).^2));
            end
            [~, best_mod_idx] = max(r_squared);
            comb_model = fold_models{best_mod_idx};
            comb_test_vel_data = separated_data{best_mod_idx}(:,1);
            comb_test_outcome_data = logical(separated_data{best_mod_idx}(:,2));
            comb_test_spike_data = separated_data{best_mod_idx}(:,3:end);
        else
            comb_model = -1;
            comb_test_vel_data = -1;
            comb_test_outcome_data = -1;
            comb_test_spike_data = -1;
        end
        
        save([rootpath,animal,'/Day',num2str(day),'/speed_decoding_models.mat'], 'M1_model', 'M1_test_vel_data', 'M1_test_outcome_data', 'M1_test_spike_data', 'Cb_model', 'Cb_test_vel_data', 'Cb_test_outcome_data', 'Cb_test_spike_data', 'comb_model', 'comb_test_vel_data', 'comb_test_outcome_data', 'comb_test_spike_data');
    end
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Speed Decoding model r^2 vs model with shuffeled data r^2 (62)

if enabled(62)
    disp('Block 62...')
    
    M1_r2s = nan(1,param.days);
    M1_r2s_shuff = nan(1,param.days);
    M1_r2s_succ = nan(1,param.days);
    M1_r2s_fail = nan(1,param.days);
    
    Cb_r2s = nan(1,param.days);
    Cb_r2s_shuff = nan(1,param.days);
    Cb_r2s_succ = nan(1,param.days);
    Cb_r2s_fail = nan(1,param.days);
    
    comb_r2s = nan(1,param.days);
    comb_r2s_shuff = nan(1,param.days);
    comb_r2s_succ = nan(1,param.days);
    comb_r2s_fail = nan(1,param.days);
    
    for day = 1:param.days
        load([rootpath,animal,'/Day',num2str(day),'/speed_decoding_models.mat'])
        
        if isnumeric(M1_model) 
            M1_r2s(day) = nan;
            M1_r2s_shuff(day) = nan;
        else
            M1_vel_data_pred = predict(M1_model,M1_test_spike_data);
            M1_r2s(day) = 1 - (sum((M1_test_vel_data - M1_vel_data_pred).^2)/sum((M1_test_vel_data - mean(M1_test_vel_data)).^2));
            
            shuff_idxs = randperm(length(M1_test_vel_data));
            M1_vel_shuff = M1_test_vel_data(shuff_idxs);
            M1_r2s_shuff(day) = 1 - (sum((M1_vel_shuff - M1_vel_data_pred).^2)/sum((M1_vel_shuff - mean(M1_vel_shuff)).^2));
            
            
            M1_test_vel_data_succ = M1_test_vel_data(M1_test_outcome_data);
            M1_test_spike_data_succ = M1_test_spike_data(M1_test_outcome_data,:);
            M1_vel_data_succ_pred = predict(M1_model,M1_test_spike_data_succ);
            M1_r2s_succ(day) = 1 - (sum((M1_test_vel_data_succ - M1_vel_data_succ_pred).^2)/sum((M1_test_vel_data_succ - mean(M1_test_vel_data_succ)).^2));
            
            M1_test_vel_data_fail = M1_test_vel_data(~M1_test_outcome_data);
            M1_test_spike_data_fail = M1_test_spike_data(~M1_test_outcome_data,:);
            M1_vel_data_fail_pred = predict(M1_model,M1_test_spike_data_fail);
            M1_r2s_fail(day) = 1 - (sum((M1_test_vel_data_fail - M1_vel_data_fail_pred).^2)/sum((M1_test_vel_data_fail - mean(M1_test_vel_data_fail)).^2));
            
            bar([M1_r2s_fail(day) M1_r2s_succ(day)])
            xticklabels({'Failure','Success'})
            saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/M1_Decoding_SvF.fig'])
            close all
        end
        
        if isnumeric(Cb_model)
            Cb_r2s(day) = nan;
            Cb_r2s_shuff(day) = nan;
        else
            Cb_vel_data_pred = predict(Cb_model,Cb_test_spike_data);
            Cb_r2s(day) = 1 - (sum((Cb_test_vel_data - Cb_vel_data_pred).^2)/sum((Cb_test_vel_data - mean(Cb_test_vel_data)).^2));
            
            shuff_idxs = randperm(length(Cb_test_vel_data));
            Cb_vel_shuff = Cb_test_vel_data(shuff_idxs);
            Cb_r2s_shuff(day) = 1 - (sum((Cb_vel_shuff - Cb_vel_data_pred).^2)/sum((Cb_vel_shuff - mean(Cb_vel_shuff)).^2));
            
            
            Cb_test_vel_data_succ = Cb_test_vel_data(Cb_test_outcome_data);
            Cb_test_spike_data_succ = Cb_test_spike_data(Cb_test_outcome_data,:);
            Cb_vel_data_succ_pred = predict(Cb_model,Cb_test_spike_data_succ);
            Cb_r2s_succ(day) = 1 - (sum((Cb_test_vel_data_succ - Cb_vel_data_succ_pred).^2)/sum((Cb_test_vel_data_succ - mean(Cb_test_vel_data_succ)).^2));
            
            Cb_test_vel_data_fail = Cb_test_vel_data(~Cb_test_outcome_data);
            Cb_test_spike_data_fail = Cb_test_spike_data(~Cb_test_outcome_data,:);
            Cb_vel_data_fail_pred = predict(Cb_model,Cb_test_spike_data_fail);
            Cb_r2s_fail(day) = 1 - (sum((Cb_test_vel_data_fail - Cb_vel_data_fail_pred).^2)/sum((Cb_test_vel_data_fail - mean(Cb_test_vel_data_fail)).^2));
            
            bar([Cb_r2s_fail(day) Cb_r2s_succ(day)])
            xticklabels({'Failure','Success'})
            saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Cb_Decoding_SvF.fig'])
            close all
        end
        
        if isnumeric(comb_model)
            comb_r2s(day) = nan;
            comb_r2s_shuff(day) = nan;
        else
            comb_vel_data_pred = predict(comb_model,comb_test_spike_data);
            comb_r2s(day) = 1 - (sum((comb_test_vel_data - comb_vel_data_pred).^2)/sum((comb_test_vel_data - mean(comb_test_vel_data)).^2));
            
            shuff_idxs = randperm(length(comb_test_vel_data));
            comb_vel_shuff = comb_test_vel_data(shuff_idxs);
            comb_r2s_shuff(day) = 1 - (sum((comb_vel_shuff - comb_vel_data_pred).^2)/sum((comb_vel_shuff - mean(comb_vel_shuff)).^2));
            
            
            comb_test_vel_data_succ = comb_test_vel_data(comb_test_outcome_data);
            comb_test_spike_data_succ = comb_test_spike_data(comb_test_outcome_data,:);
            comb_vel_data_succ_pred = predict(comb_model,comb_test_spike_data_succ);
            comb_r2s_succ(day) = 1 - (sum((comb_test_vel_data_succ - comb_vel_data_succ_pred).^2)/sum((comb_test_vel_data_succ - mean(comb_test_vel_data_succ)).^2));
            
            comb_test_vel_data_fail = comb_test_vel_data(~comb_test_outcome_data);
            comb_test_spike_data_fail = comb_test_spike_data(~comb_test_outcome_data,:);
            comb_vel_data_fail_pred = predict(comb_model,comb_test_spike_data_fail);
            comb_r2s_fail(day) = 1 - (sum((comb_test_vel_data_fail - comb_vel_data_fail_pred).^2)/sum((comb_test_vel_data_fail - mean(comb_test_vel_data_fail)).^2));
            
            bar([comb_r2s_fail(day) comb_r2s_succ(day)])
            xticklabels({'Failure','Success'})
            saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/Comb_Decoding_SvF.fig'])
            close all
        end
    end
    
    plot(M1_r2s)
    hold on
    %plot(M1_r2s_shuff)
    saveas(gcf,[rootpath,animal,'/M1_Decoding_Reach_Tracjectory.fig'])
    close all
    plot(Cb_r2s)
    hold on
    %plot(Cb_r2s_shuff)
    saveas(gcf,[rootpath,animal,'/Cb_Decoding_Reach_Tracjectory.fig'])
    close all
    plot(comb_r2s)
    hold on
    %plot(comb_r2s_shuff)
    saveas(gcf,[rootpath,animal,'/comb_Decoding_Reach_Tracjectory.fig'])
    close all
    
    load([rootpath,animal,'/Shared_Data.mat'])
    shared_data.M1_r2s = M1_r2s;
    shared_data.M1_r2s_succ = M1_r2s_succ;
    shared_data.M1_r2s_fail = M1_r2s_fail;
    shared_data.Cb_r2s = Cb_r2s;
    shared_data.Cb_r2s_succ = Cb_r2s_succ;
    shared_data.Cb_r2s_fail = Cb_r2s_fail;
    shared_data.comb_r2s = comb_r2s;
    shared_data.comb_r2s_succ = comb_r2s_succ;
    shared_data.comb_r2s_fail = comb_r2s_fail;
    save([rootpath,animal,'/Shared_Data.mat'], 'shared_data')
    
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Digit Trajectory Prelim

if false
    digit_path = 'Z:\M1_Cb_Reach\I086\DLC_DigitsTracking\';
    finger_start_idxs = [2 5 8 11]; %index in the csv file.
    finger_labels = cell(size(finger_start_idxs));
    coords = 3; %Code expects an x, y, liklyhood pattern.
    finger_idxs = [finger_start_idxs;(finger_start_idxs+1);(finger_start_idxs+2)];
    finger_idxs = finger_idxs(:);
    
    data_start_row = 3;
    label_row = 1;
    LH_thresh = 0.5;
    
    touch_window_pre = 100; %ms
    touch_window_post = 100; %ms
    frame_step = 1000/param.Camera_framerate;
    start_frame_rel = round(-touch_window_pre/frame_step);
    end_frame_rel = round(touch_window_post/frame_step);
    frame_rel_idxs = start_frame_rel:end_frame_rel;
    
    succ_err_val = nan(param.days, length(finger_start_idxs));
    fail_err_val = nan(param.days, length(finger_start_idxs));
    for day = 1:param.days
        succ_day_trajs =zeros(0,length(finger_start_idxs),coords,length(frame_rel_idxs)); %trials x fingers x coordinates(x,y,L) x frame
        fail_day_trajs =zeros(0,length(finger_start_idxs),coords,length(frame_rel_idxs)); %trials x fingers x coordinates(x,y,L) x frame
        for block = 1:param.blocks
            %load GUI data
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            
            %extract touch trials and touch frames
            trial_codes = str2double(data(:,3));
            succ_trials = find(trial_codes == 1);
            fail_trials = find(trial_codes == 0);
            
            succ_frame_nums = cellfun(@str2num,data(succ_trials,2),'UniformOutput',false);
            succ_event_counts = cellfun(@length,succ_frame_nums);
            succ_touch_frame_idxs = cumsum(succ_event_counts);
            succ_touch_frame_idxs = succ_touch_frame_idxs-1;
            succ_touch_frames = [succ_frame_nums{:}];
            succ_touch_frames = succ_touch_frames(succ_touch_frame_idxs);
            
            fail_frame_nums = cellfun(@str2num,data(fail_trials,2),'UniformOutput',false);
            fail_touch_frames = [fail_frame_nums{:}];
            fail_event_counts = cellfun(@length,fail_frame_nums);
            fail_last_frame_idxs = cumsum(fail_event_counts);
            fail_trials = fail_trials(fail_touch_frames(fail_last_frame_idxs)==1);
            fail_touch_frame_idxs = fail_last_frame_idxs(fail_touch_frames(fail_last_frame_idxs)==1);
            fail_touch_frame_idxs = fail_touch_frame_idxs-3;
            fail_touch_frames = fail_touch_frames(fail_touch_frame_idxs);
            
            for trial = 1:length(succ_trials)
                %load trial traj data
                filename = dir([digit_path,animal,'D',num2str(day),'R',num2str(block),'*-',num2str(succ_trials(trial)),'DLC*.csv']);
                if isempty(filename)
                    continue
                end
                traj_data = readtable([digit_path,filename.name]);
                
                %extract window of data
                window_idxs = start_frame_rel:end_frame_rel;
                window_idxs = window_idxs + succ_touch_frames(trial);
                window_data = cellfun(@str2double,table2array(traj_data(window_idxs,finger_idxs)));
                
                %concatinate window into day_trajs
                window_data = reshape(window_data,length(window_idxs),coords,length(finger_start_idxs));
                window_data = permute(window_data,[4 3 2 1]);
                succ_day_trajs = cat(1,succ_day_trajs,window_data);
                
                %read finger lables (for use in naming saves)
                if isempty(finger_labels{1})
                    for i = 1:length(finger_start_idxs)
                        finger_labels(i) = traj_data{label_row,finger_start_idxs(i)};
                    end
                end
            end
            for trial = 1:length(fail_trials)
                %load trial traj data
                filename = dir([digit_path,animal,'D',num2str(day),'R',num2str(block),'*-',num2str(fail_trials(trial)),'DLC*.csv']);
                if isempty(filename)
                    continue
                end
                traj_data = readtable([digit_path,filename.name]);
                
                %extract window of data
                window_idxs = start_frame_rel:end_frame_rel;
                window_idxs = window_idxs + fail_touch_frames(trial);
                window_data = cellfun(@str2double,table2array(traj_data(window_idxs,finger_idxs)));
                
                %concatinate window into day_trajs
                window_data = reshape(window_data,length(window_idxs),coords,length(finger_start_idxs));
                window_data = permute(window_data,[4 3 2 1]);
                fail_day_trajs = cat(1,fail_day_trajs,window_data);
                
                %read finger lables (for use in naming saves)
                if isempty(finger_labels{1})
                    for i = 1:length(finger_start_idxs)
                        finger_labels(i) = traj_data{label_row,finger_start_idxs(i)};
                    end
                end
                
            end
        end
        for f_i = 1:length(finger_labels)
            %plot success trajectories
            good_trials = false(1,size(succ_day_trajs,1));
            hold on
            for trial = 1:size(succ_day_trajs,1)
                trial_data = squeeze(succ_day_trajs(trial,f_i,:,:));
                likelihood = trial_data(3,:);
                if sum(likelihood < LH_thresh) > 0
                    continue
                end
                good_trials(trial) = true;
                
                x_coor = trial_data(1,:);
                y_coor = trial_data(2,:);
                plot(x_coor,y_coor,'Color', [.6 .6 .6]);
            end
            mean_x = squeeze(mean(succ_day_trajs(good_trials,f_i,1,:),1));
            mean_y = squeeze(mean(succ_day_trajs(good_trials,f_i,2,:),1));
            plot(mean_x,mean_y,'Color', [0 0 0], 'LineWidth', 2);
            saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/trajectories_success_', finger_labels{f_i},'.fig']);
            close all
            %calc error measure
            x_stdv = squeeze(std(succ_day_trajs(good_trials,f_i,1,:),1,1));
            y_stdv = squeeze(std(succ_day_trajs(good_trials,f_i,2,:),1,1));
            succ_err_val(day,f_i) = mean([x_stdv; y_stdv]);
            
            %plot failure trajectories
            good_trials = false(1,size(fail_day_trajs,1));
            hold on
            for trial = 1:size(fail_day_trajs,1)
                trial_data = squeeze(fail_day_trajs(trial,f_i,:,:));
                likelihood = trial_data(3,:);
                if sum(likelihood < LH_thresh) > 0
                    continue
                end
                good_trials(trial) = true;
                
                x_coor = trial_data(1,:);
                y_coor = trial_data(2,:);
                plot(x_coor,y_coor,'Color', [.6 .6 .6]);
            end
            mean_x = squeeze(mean(fail_day_trajs(good_trials,f_i,1,:),1));
            mean_y = squeeze(mean(fail_day_trajs(good_trials,f_i,2,:),1));
            plot(mean_x,mean_y,'Color', [0 0 0], 'LineWidth', 2);
            saveas(gcf,[rootpath,animal,'/Day',num2str(day),'/trajectories_failure_', finger_labels{f_i}, '.fig']);
            close all
            %calc error measure
            x_stdv = squeeze(std(fail_day_trajs(good_trials,f_i,1,:),1,1));
            y_stdv = squeeze(std(fail_day_trajs(good_trials,f_i,2,:),1,1));
            fail_err_val(day,f_i) = mean([x_stdv; y_stdv]);
        end
    end
    for f_i = 1:length(finger_labels)
        hold on
        %plot(succ_err_val(:,f_i))
        %plot(fail_err_val(:,f_i))
        plot([1,5],succ_err_val([1,5],f_i))
        plot([1,5],fail_err_val([1,5],f_i))
        xlim([0.5 (param.days+0.5)]);
        saveas(gcf,[rootpath,animal,'/traj_error_', finger_labels{f_i},'.fig']);
        close all
    end
end

%% Search for likely candidates for single-trial example of LFP and PETH effect (63)
    %Looks for higher LFP and PETH amplitude around reach/touch/retract and shorter intervals between reach/touch/retract

if enabled(63)
    se_day = 1; %day to search for an example of small effect 
    le_day = 5; %day to search for an example of large effect 
    rt_dur_min_reduction = 0;   %1 - (large effect example reach-touch interval/small effect example reach-touch interval) must be > than this number
    rr_dur_min_reduction = .25; %1 - (large effect example reach-touch interval/small effect example reach-touch interval) must be > than this number
    main_win_start  = -0.5; %begining of full displayed window.              In seconds; starting from reach onset
    main_win_end = 1.0;     %end of full displayed window.                   In seconds; starting from reach onset
    bl_win_start  = -0.5;   %begining of window used to establish baselines. In seconds; starting from reach onset
    bl_win_end    = -0.15;  %end of window used to establish baselines.      In seconds; starting from reach onset
    rtr_win_start = -0.05;  %begining of window used to establish effect.    In seconds; starting from reach onset
    rtr_win_end   = 0.15;   %end of window used to establish effect.         In seconds; starting from retract onset
    max_rr_int = 0.5;       %maximun reach-retract interval as a ratio of main_win_end
    
    LE_LFP_sd_increase_thresh = 1.1; %The standard deviation of the reach-touch-retract period should be >= baseline sd * (1+[this]) 
    LFP_baseline_max_diff = 0.3;     %The higher of the baseline sds divided by the other should be <= 1+[this]
    rtr_LFP_min_increase = 1;      %The standard deviation of the le reach-touch-retract period should be >= that of the se * (1+[this]) 
    
    LE_PETH_sd_increase_thresh = 0.3; %The standard deviation of the reach-touch-retract period should be >= baseline sd * (1+[this]) 
    PETH_baseline_max_diff = 0.3;     %The higher of the baseline sds divided by the other should be <= 1+[this]
    rtr_PETH_min_increase = 0.3;      %The standard deviation of the le reach-touch-retract period should be >= that of the se * (1+[this]) 
    
    bin_size = 0.001; %In seconds
    num_to_save = 12;
    starting_skips = 0; %Skips the first X that would have been saved. Created so if the first batch of candidates are no good, we can skip them and see others instead
    
    %collect trials
        %remove any that fail to meet the absolute criteria, are missing one of M1 or Cb, or are unsuccessful
        %establish baseline and rtr LFP and PETH values for each trial
        %LE rtrs should be above their baselines for all
        %LE rtrs should be above their baselines by a threshold for some?
        %rtr LFP mean diff between raw and filtered below a threshold
    %build 4 (M1 and CB by LFP and PETH) comparison matrixes: [D1 trials, D5 trials]
        %record nan or smth for pairs tha fail the duration reduction criteria
        %Baselines should be similar between se and le for all
        %rtrs should be higher in le for all
        %rtrs should be higher in le by a threshold for most/all
        
    %build trials lists
    for effect_size = 'sl'
        trials_struct = struct('true_trial_idx',zeros(1,1,0), 'block',zeros(1,1,0), 'rt_int',zeros(1,1,0), 'rr_int',zeros(1,1,0),...
                               'M1_LFP_filt_data',[], 'Cb_LFP_filt_data',[], 'M1_PETH_data',[], 'Cb_PETH_data',[],...
                               'M1_LFP_raw_data',[],  'Cb_LFP_raw_data',[],  'M1_rast_data',[], 'Cb_rast_data',[],...
                               'M1_baseline_LFP_sd',zeros(length(param.M1_good_chans),1,0),...
                               'M1_rtr_LFP_sd',zeros(length(param.M1_good_chans),1,0),...
                               'M1_baseline_PETH_sd',zeros(length(param.M1_good_chans),1,0),...
                               'M1_rtr_PETH_sd',zeros(length(param.M1_good_chans),1,0),...
                               'Cb_baseline_LFP_sd',zeros(length(param.Cb_good_chans),1,0),...
                               'Cb_rtr_LFP_sd',zeros(length(param.Cb_good_chans),1,0),...
                               'Cb_baseline_PETH_sd',zeros(length(param.Cb_good_chans),1,0),...
                               'Cb_rtr_PETH_sd',zeros(length(param.Cb_good_chans),1,0));
        
        eval(['day = ' effect_size 'e_day;']);
        for block = 1:param.blocks
            %Gather LFP data
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Normalized_full_Snapshots', '.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Filtered_LFP_full_Snapshots.mat']); %M1_1_4_snapshots
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/GUI_data.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/inter_event_intervals.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials.mat']);
            
            [M1_snapshots, Cb_snapshots] = get_common_good_data(M1_snapshots_n, Cb_snapshots_n, M1_bad_trials, Cb_bad_trials, 3);
            [M1_filt, Cb_filt] = get_common_good_data(M1_1_4_snapshots_n, Cb_1_4_snapshots_n, M1_bad_trials, Cb_bad_trials, 3);
            common_bad_trials = unique([M1_bad_trials, Cb_bad_trials]);
            common_good_trials = 1:size(data,1);
            common_good_trials(common_bad_trials) = [];
            
            M1_time_course = interp1([1,size(M1_snapshots,2)],[-4,4],1:size(M1_snapshots,2));
            M1_snapshots = M1_snapshots(:, M1_time_course>main_win_start & M1_time_course<main_win_end, :);
            M1_filt = M1_filt(:, M1_time_course>main_win_start & M1_time_course<main_win_end, :);
            M1_window = M1_time_course(:, M1_time_course>main_win_start & M1_time_course<main_win_end);

            Cb_time_course = interp1([1,size(Cb_snapshots,2)],[-4,4],1:size(Cb_snapshots,2));
            Cb_snapshots = Cb_snapshots(:, Cb_time_course>main_win_start & Cb_time_course<main_win_end, :);
            Cb_filt = Cb_filt(:, Cb_time_course>main_win_start & Cb_time_course<main_win_end, :);
            Cb_window = Cb_time_course(:, Cb_time_course>main_win_start & Cb_time_course<main_win_end);
            
            reach_touch_interval(common_bad_trials) = [];
            reach_retract_interval(common_bad_trials) = [];
            
            %Success only filter (can be commented out)
            [M1_snapshots, ~] = success_fail_split(M1_snapshots, data, common_bad_trials, 3);
            [Cb_snapshots, ~] = success_fail_split(Cb_snapshots, data, common_bad_trials, 3);
            [M1_filt, ~] = success_fail_split(M1_filt, data, common_bad_trials, 3);
            [Cb_filt, ~] = success_fail_split(Cb_filt, data, common_bad_trials, 3);
            [common_good_trials, ~] = success_fail_split(common_good_trials, data, common_bad_trials, 2);
            [reach_touch_interval, ~] = success_fail_split(reach_touch_interval, data, common_bad_trials, 1);
            [reach_retract_interval, ~] = success_fail_split(reach_retract_interval, data, common_bad_trials, 1);
            
            too_long_bool = reach_retract_interval > (max_rr_int * main_win_end);
            M1_snapshots(:,:,too_long_bool) = [];
            Cb_snapshots(:,:,too_long_bool) = [];
            M1_filt(:,:,too_long_bool) = [];
            Cb_filt(:,:,too_long_bool) = [];
            common_good_trials(too_long_bool) = [];
            reach_touch_interval(too_long_bool) = [];
            reach_retract_interval(too_long_bool) = [];
            
            trials_struct.block = cat(3,trials_struct.block,ones(1,1,size(common_good_trials,2))*block);
            trials_struct.true_trial_idx = cat(3,trials_struct.true_trial_idx,reshape(common_good_trials,[1,1,length(common_good_trials)]));
            trials_struct.rt_int = cat(3,trials_struct.rt_int,reshape(reach_touch_interval,[1,1,length(reach_touch_interval)]));
            trials_struct.rr_int = cat(3,trials_struct.rr_int,reshape(reach_retract_interval,[1,1,length(reach_retract_interval)]));
            trials_struct.M1_LFP_raw_data = cat(3,trials_struct.M1_LFP_raw_data,M1_snapshots);
            trials_struct.M1_LFP_filt_data = cat(3,trials_struct.M1_LFP_filt_data,M1_filt);
            trials_struct.Cb_LFP_raw_data = cat(3,trials_struct.Cb_LFP_raw_data,Cb_snapshots);
            trials_struct.Cb_LFP_filt_data = cat(3,trials_struct.Cb_LFP_filt_data,Cb_filt);
            
            %Gather spiking data
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/spiketrain_snapshots_full.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike_timestamps.mat']);
            
            outcomes = cellfun(@str2num,data(:,3));
            reach_trials = 1:size(data,1);
            reach_trials(outcomes>1) = [];
            good_reach_idxs = find(ismember(reach_trials,common_good_trials));
            M1_spike_snapshots = M1_spike_snapshots_full(:,:,good_reach_idxs);
            Cb_spike_snapshots = Cb_spike_snapshots_full(:,:,good_reach_idxs);
            
            M1_edges = interp1([0,size(M1_snapshots,2)],[0,8*param.M1_Fs],0:size(M1_snapshots,2));
            Cb_edges = interp1([0,size(Cb_snapshots,2)],[0,8*param.M1_Fs],0:size(Cb_snapshots,2));
            
            %M1 PETH and raster data
            neuron_bin_cell = cellfun(@(x)(histcounts(x,M1_edges)),M1_spike_snapshots,'UniformOutput',false);
            neuron_bin_cell = reshape(neuron_bin_cell,[size(neuron_bin_cell,1)*size(neuron_bin_cell,2), 1, size(neuron_bin_cell,3)]);
            neuron_bin_mat = cell2mat(neuron_bin_cell);
            trial_bins = sum(neuron_bin_mat,1);
            M1_PETH_data = nan(1,size(M1_snapshots,2),size(M1_snapshots,3));
            M1_rast_data = cell(1,1,size(M1_snapshots,3));
            for trial = 1:size(trial_bins,3)
                ss_fit = fit((1:length(trial_bins(:,:,trial)))', trial_bins(:,:,trial)', 'smoothingspline', 'SmoothingParam', param.smoothing_param);
                M1_PETH_trial = ss_fit(1:length(trial_bins(:,:,trial)))';
                neuron_spike_counts = sum(neuron_bin_mat(:,:,trial),2);
                neuron_bin_mat_trial = neuron_bin_mat(:,:,trial);
                neuron_bin_mat_trial(neuron_spike_counts == 0,:) = [];
                M1_PETH_data(:,:,trial) = M1_PETH_trial*((1/bin_size)/size(neuron_bin_mat,1));
                
                raster_y = neuron_bin_mat_trial .* (1:size(neuron_bin_mat_trial,1))';
                raster_x = neuron_bin_mat_trial .* (M1_window);
                raster_x(raster_y == 0) = [];
                raster_y(raster_y == 0) = [];
                M1_rast_data{trial} = [raster_x; raster_y];
            end
            trials_struct.M1_PETH_data = cat(3,trials_struct.M1_PETH_data,M1_PETH_data);
            trials_struct.M1_rast_data = cat(3,trials_struct.M1_rast_data,M1_rast_data);
            
            %Cb PETH and raster data
            neuron_bin_cell = cellfun(@(x)(histcounts(x,Cb_edges)),Cb_spike_snapshots,'UniformOutput',false);
            neuron_bin_cell = reshape(neuron_bin_cell,[size(neuron_bin_cell,1)*size(neuron_bin_cell,2), 1, size(neuron_bin_cell,3)]);
            neuron_bin_mat = cell2mat(neuron_bin_cell);
            trial_bins = sum(neuron_bin_mat,1);
            Cb_PETH_data = nan(1,size(Cb_snapshots,2),size(Cb_snapshots,3));
            Cb_rast_data = cell(1,1,size(Cb_snapshots,3));
            for trial = 1:size(trial_bins,3)
                ss_fit = fit((1:length(trial_bins(:,:,trial)))', trial_bins(:,:,trial)', 'smoothingspline', 'SmoothingParam', param.smoothing_param);
                Cb_PETH_trial = ss_fit(1:length(trial_bins(:,:,trial)))';
                neuron_spike_counts = sum(neuron_bin_mat(:,:,trial),2);
                neuron_bin_mat_trial = neuron_bin_mat(:,:,trial);
                neuron_bin_mat_trial(neuron_spike_counts == 0,:) = [];
                Cb_PETH_data(:,:,trial) = Cb_PETH_trial*((1/bin_size)/size(neuron_bin_mat,1));
                
                raster_y = neuron_bin_mat_trial .* (1:size(neuron_bin_mat_trial,1))';
                raster_x = neuron_bin_mat_trial .* (Cb_window);
                raster_x(raster_y == 0) = [];
                raster_y(raster_y == 0) = [];
                Cb_rast_data{trial} = [raster_x; raster_y];
            end
            trials_struct.Cb_PETH_data = cat(3,trials_struct.Cb_PETH_data,Cb_PETH_data);
            trials_struct.Cb_rast_data = cat(3,trials_struct.Cb_rast_data,Cb_rast_data);
            
        end

        %Sun of distance from zero
        trials_struct.M1_baseline_LFP_sd = mean(abs(trials_struct.M1_LFP_filt_data(:, M1_window>bl_win_start & M1_window<bl_win_end, :)),2);
        trials_struct.M1_rtr_LFP_sd      = mean(abs(trials_struct.M1_LFP_filt_data(:, M1_window>rtr_win_start & M1_window<rtr_win_end, :)),2);
        trials_struct.Cb_baseline_LFP_sd = mean(abs(trials_struct.Cb_LFP_filt_data(:, Cb_window>bl_win_start & Cb_window<bl_win_end, :)),2);
        trials_struct.Cb_rtr_LFP_sd      = mean(abs(trials_struct.Cb_LFP_filt_data(:, Cb_window>rtr_win_start & Cb_window<rtr_win_end, :)),2);
        
%         trials_struct.M1_baseline_PETH_sd = mean(abs(trials_struct.M1_PETH_data(:, M1_window>bl_win_start & M1_window<bl_win_end, :)),2);
%         trials_struct.M1_rtr_PETH_sd      = mean(abs(trials_struct.M1_PETH_data(:, M1_window>rtr_win_start & M1_window<rtr_win_end, :)),2);
%         trials_struct.Cb_baseline_PETH_sd = mean(abs(trials_struct.Cb_PETH_data(:, Cb_window>bl_win_start & Cb_window<bl_win_end, :)),2);
%         trials_struct.Cb_rtr_PETH_sd      = mean(abs(trials_struct.Cb_PETH_data(:, Cb_window>rtr_win_start & Cb_window<rtr_win_end, :)),2);
        
%         %Standard Deviation 
%         trials_struct.M1_baseline_LFP_sd = std(trials_struct.M1_LFP_filt_data(:, M1_window>bl_win_start & M1_window<bl_win_end, :),0,2);
%         trials_struct.M1_rtr_LFP_sd      = std(trials_struct.M1_LFP_filt_data(:, M1_window>rtr_win_start & M1_window<rtr_win_end, :),0,2);
%         trials_struct.Cb_baseline_LFP_sd = std(trials_struct.Cb_LFP_filt_data(:, Cb_window>bl_win_start & Cb_window<bl_win_end, :),0,2);
%         trials_struct.Cb_rtr_LFP_sd      = std(trials_struct.Cb_LFP_filt_data(:, Cb_window>rtr_win_start & Cb_window<rtr_win_end, :),0,2);
        
        trials_struct.M1_baseline_PETH_sd = std(trials_struct.M1_PETH_data(:, M1_window>bl_win_start & M1_window<bl_win_end, :),0,2);
        trials_struct.M1_rtr_PETH_sd      = std(trials_struct.M1_PETH_data(:, M1_window>rtr_win_start & M1_window<rtr_win_end, :),0,2);
        trials_struct.Cb_baseline_PETH_sd = std(trials_struct.Cb_PETH_data(:, Cb_window>bl_win_start & Cb_window<bl_win_end, :),0,2);
        trials_struct.Cb_rtr_PETH_sd      = std(trials_struct.Cb_PETH_data(:, Cb_window>rtr_win_start & Cb_window<rtr_win_end, :),0,2);
        
        %LE rtrs should be above their baselines by a threshold
        if strcmp(effect_size, 'l')
            trials_struct.good_M1_examples = trials_struct.M1_baseline_LFP_sd*(1+LE_LFP_sd_increase_thresh) < trials_struct.M1_rtr_LFP_sd;
            good_trials = logical(sum(trials_struct.good_M1_examples,1));
            trials_struct.good_Cb_examples = trials_struct.Cb_baseline_LFP_sd*(1+LE_LFP_sd_increase_thresh) < trials_struct.Cb_rtr_LFP_sd;
            good_trials = good_trials & logical(sum(trials_struct.good_Cb_examples,1));
            
            for field_cell = fieldnames(trials_struct)'
                field = field_cell{1};
                eval(['trials_struct.' field ' = trials_struct.' field '(:,:,good_trials);'])
            end
        end
        
        %rtr LFP mean diff between raw and filtered below a threshold?
        
        eval([effect_size 'e_trials = trials_struct;']);
    end
    
    if (size(se_trials.rt_int,3) ~= size(se_trials.rr_int,3)) || (size(le_trials.rt_int,3) ~= size(le_trials.rr_int,3)) ||...
       (size(le_trials.M1_LFP_filt_data,3) ~= size(le_trials.Cb_LFP_filt_data,3)) ||...
       (size(se_trials.M1_LFP_filt_data,3) ~= size(se_trials.Cb_LFP_filt_data,3)) ||...
       (size(se_trials.M1_LFP_filt_data,1) ~= size(le_trials.M1_LFP_filt_data,1)) ||...
       (size(se_trials.Cb_LFP_filt_data,1) ~= size(le_trials.Cb_LFP_filt_data,1))
        error('Trial or channel count mismatch.')
    end    
    
    %build 4 (M1 and CB by LFP and PETH) comparison matrixes: [D1 trials, D5 trials, chans]
    M1_LFP_comp = false(size(se_trials.M1_LFP_filt_data,3), size(le_trials.M1_LFP_filt_data,3), size(le_trials.M1_LFP_filt_data,1));
    Cb_LFP_comp = false(size(se_trials.Cb_LFP_filt_data,3), size(le_trials.Cb_LFP_filt_data,3), size(le_trials.Cb_LFP_filt_data,1));
    for se_trial = 1:size(M1_LFP_comp,1)
        for le_trial = 1:size(M1_LFP_comp,2)
            rtr_dur_test = ((le_trials.rt_int(le_trial)/se_trials.rt_int(se_trial)) <= (1-rt_dur_min_reduction)) && ((le_trials.rr_int(le_trial)/se_trials.rr_int(se_trial)) <= (1-rr_dur_min_reduction));
            M1_PETH_test = max(se_trials.M1_baseline_PETH_sd(1,1,se_trial),le_trials.M1_baseline_PETH_sd(1,1,le_trial))/min(se_trials.M1_baseline_PETH_sd(1,1,se_trial),le_trials.M1_baseline_PETH_sd(1,1,le_trial)) < (PETH_baseline_max_diff+1)...
                           && se_trials.M1_rtr_PETH_sd(1,1,se_trial) * (1+rtr_PETH_min_increase) < le_trials.M1_rtr_PETH_sd(1,1,le_trial);
            Cb_PETH_test = max(se_trials.Cb_baseline_PETH_sd(1,1,se_trial),le_trials.Cb_baseline_PETH_sd(1,1,le_trial))/min(se_trials.Cb_baseline_PETH_sd(1,1,se_trial),le_trials.Cb_baseline_PETH_sd(1,1,le_trial)) < (PETH_baseline_max_diff+1)...
                           && se_trials.Cb_rtr_PETH_sd(1,1,se_trial) * (1+rtr_PETH_min_increase) < le_trials.Cb_rtr_PETH_sd(1,1,le_trial);
            if rtr_dur_test && M1_PETH_test && Cb_PETH_test
                for chan = 1:size(M1_LFP_comp,3)
                    M1_LFP_comp(se_trial,le_trial,chan) = max(se_trials.M1_baseline_LFP_sd(chan,1,se_trial),le_trials.M1_baseline_LFP_sd(chan,1,le_trial))/min(se_trials.M1_baseline_LFP_sd(chan,1,se_trial),le_trials.M1_baseline_LFP_sd(chan,1,le_trial)) < (LFP_baseline_max_diff+1)...
                                                          && se_trials.M1_rtr_LFP_sd(chan,1,se_trial) * (1+rtr_LFP_min_increase) < le_trials.M1_rtr_LFP_sd(chan,1,le_trial);
                end
                for chan = 1:size(Cb_LFP_comp,3)
                    Cb_LFP_comp(se_trial,le_trial,chan) = max(se_trials.Cb_baseline_LFP_sd(chan,1,se_trial),le_trials.Cb_baseline_LFP_sd(chan,1,le_trial))/min(se_trials.Cb_baseline_LFP_sd(chan,1,se_trial),le_trials.Cb_baseline_LFP_sd(chan,1,le_trial)) < (LFP_baseline_max_diff+1)...
                                                          && se_trials.Cb_rtr_LFP_sd(chan,1,se_trial) * (1+rtr_LFP_min_increase) < le_trials.Cb_rtr_LFP_sd(chan,1,le_trial);
                end
            end
        end
    end
    final_comb_test = logical(sum(M1_LFP_comp,3)) & logical(sum(Cb_LFP_comp,3));
    
    disp(['Press space to save and exit.'])
    exit_viewer = false;
    fig_row = num_to_save;
    
    while ~exit_viewer
        close all
        exfig = figure;
        exfig.WindowState = 'maximized';
        total_found = 0;
        pair_idx = 0;
        num_from_save_to_skip = starting_skips;
        for se_trial = 1:size(final_comb_test,1)
            for le_trial = 1:size(final_comb_test,2)
                if final_comb_test(se_trial,le_trial)
                    M1_chans = [];
                    Cb_chans = [];
                    for chan = 1:size(M1_LFP_comp,3)
                        if M1_LFP_comp(se_trial,le_trial,chan)
                            M1_chans = [M1_chans, chan]; %#ok<AGROW>
                        end
                    end
                    for chan = 1:size(Cb_LFP_comp,3)
                        if Cb_LFP_comp(se_trial,le_trial,chan)
                            Cb_chans = [Cb_chans, chan]; %#ok<AGROW>
                        end
                    end
                    
                    
                    for M1_chan = M1_chans
                        for Cb_chan = Cb_chans
                            total_found = total_found+1;
                            if num_from_save_to_skip > 0
                                num_from_save_to_skip = num_from_save_to_skip-1;
                            elseif pair_idx < num_to_save
                                y_max = max([se_trials.M1_LFP_filt_data(M1_chan,:,se_trial), le_trials.M1_LFP_filt_data(M1_chan,:,le_trial)]);
                                y_min = min([se_trials.M1_LFP_filt_data(M1_chan,:,se_trial), le_trials.M1_LFP_filt_data(M1_chan,:,le_trial)]);
                                subplot(8,fig_row,1+(pair_idx*2)+(floor(pair_idx/6)*(3*fig_row)))
                                plot(se_trials.M1_LFP_filt_data(M1_chan,:,se_trial))
                                ylim([y_min, y_max])
                                title({['B: ', num2str(se_trials.block(se_trial)), ', T: ', num2str(se_trials.true_trial_idx(se_trial)), ','], ['M1ch: ', num2str(param.M1_good_chans(M1_chan)), ', Cbch: ', num2str(param.Cb_good_chans(Cb_chan))]})
                                subplot(8,fig_row,2+(pair_idx*2)+(floor(pair_idx/6)*(3*fig_row)))
                                plot(le_trials.M1_LFP_filt_data(M1_chan,:,le_trial))
                                ylim([y_min, y_max])
                                title({['B: ', num2str(le_trials.block(le_trial)), ', T: ', num2str(le_trials.true_trial_idx(le_trial)), ','], ['M1ch: ', num2str(param.M1_good_chans(M1_chan)), ', Cbch: ', num2str(param.Cb_good_chans(Cb_chan))]})
                                
                                y_max = max([se_trials.Cb_LFP_filt_data(Cb_chan,:,se_trial), le_trials.Cb_LFP_filt_data(Cb_chan,:,le_trial)]);
                                y_min = min([se_trials.Cb_LFP_filt_data(Cb_chan,:,se_trial), le_trials.Cb_LFP_filt_data(Cb_chan,:,le_trial)]);
                                subplot(8,fig_row,1+(pair_idx*2)+(floor(pair_idx/6)*(3*fig_row))+fig_row)
                                plot(se_trials.Cb_LFP_filt_data(Cb_chan,:,se_trial))
                                ylim([y_min, y_max])
                                subplot(8,fig_row,2+(pair_idx*2)+(floor(pair_idx/6)*(3*fig_row))+fig_row)
                                plot(le_trials.Cb_LFP_filt_data(Cb_chan,:,le_trial))
                                ylim([y_min, y_max])
                                
                                y_max = max([se_trials.M1_PETH_data(1,:,se_trial), le_trials.M1_PETH_data(1,:,le_trial)]);
                                y_min = min([se_trials.M1_PETH_data(1,:,se_trial), le_trials.M1_PETH_data(1,:,le_trial)]);
                                subplot(8,fig_row,1+(pair_idx*2)+(floor(pair_idx/6)*(3*fig_row))+(2*fig_row))
                                plot(se_trials.M1_PETH_data(1,:,se_trial))
                                ylim([y_min, y_max])
                                subplot(8,fig_row,2+(pair_idx*2)+(floor(pair_idx/6)*(3*fig_row))+(2*fig_row))
                                plot(le_trials.M1_PETH_data(1,:,le_trial))
                                ylim([y_min, y_max])
                                
                                y_max = max([se_trials.Cb_PETH_data(1,:,se_trial), le_trials.Cb_PETH_data(1,:,le_trial)]);
                                y_min = min([se_trials.Cb_PETH_data(1,:,se_trial), le_trials.Cb_PETH_data(1,:,le_trial)]);
                                subplot(8,fig_row,1+(pair_idx*2)+(floor(pair_idx/6)*(3*fig_row))+(3*fig_row))
                                plot(se_trials.Cb_PETH_data(1,:,se_trial))
                                ylim([y_min, y_max])
                                subplot(8,fig_row,2+(pair_idx*2)+(floor(pair_idx/6)*(3*fig_row))+(3*fig_row))
                                plot(le_trials.Cb_PETH_data(1,:,le_trial))
                                ylim([y_min, y_max])
                                
                                pair_idx = pair_idx+1;
                            end
                        end
                    end
                end
            end
        end
        
        [~,~,button] = ginput(1);
        switch button
            case 32 % space
                exit_viewer = true;
            case 29 % right
                starting_skips = starting_skips + num_to_save;
                if starting_skips > total_found
                    beep
                    disp(['Reached the end of the found examples.'])
                    starting_skips = starting_skips - num_to_save;
                end
            case 28 % left
                starting_skips = starting_skips - num_to_save;
                if starting_skips < 0
                    beep
                    disp(['Reached the begining of the found examples.'])
                    starting_skips = 0;
                end
        end
    end
    
    disp(['Found a total of ', num2str(total_found), ' possible examples.']);
    saveas(exfig,[rootpath,animal,'/possible_example_trials.fig']);
    close all
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Search for likely candidates for single-neuron example of polar histogram and PETH from spike phase-locking results (64)
%Uses the same parameters from (40) and requires it to have been run

if enabled(64)
    day = 5;
    M1_LFP_chan = 20;
    Cb_LFP_chan = 38;
    M1_neurons_of_interest = param.M1_task_related_neurons;
    Cb_neurons_of_interest = param.Cb_task_related_neurons;
    PL_hist_stats = struct('M1Ch_M1Nrn', [], 'M1Ch_CbNrn', [], 'CbCh_M1Nrn', [], 'CbCh_CbNrn', []);
    min_highest_count = 50;
    num_for_multi_ratio = 4;
    for LFP_area = {'M1','Cb'}
        eval(['LFP_chan = ', LFP_area{1}, '_LFP_chan;'])
        for neuron_area = {'M1','Cb'}
            eval(['neuron_num_chans = param.', neuron_area{1}, '_chans;'])
            eval(['neuron_num_codes = param.', neuron_area{1}, '_neurons;'])
            count_ratio = [];
            multi_count_ratio = [];
            neuron_chans = [];
            neuron_codes = [];
            blocks = [];
            for block = 1:param.blocks
                for s_chan = 1:neuron_num_chans
                    for code = 1:neuron_num_codes
                        eval(['neurons_of_interest = ', neuron_area{1}, '_neurons_of_interest{day};'])
                        if neurons_of_interest(s_chan,code) && exist([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/',LFP_area{1},'_Channel',num2str(LFP_chan),'/',neuron_area{1},'_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phase_histogram.fig'],'file')
                            uiopen([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Spike-Phase_Data/',LFP_area{1},'_Channel',num2str(LFP_chan),'/',neuron_area{1},'_Ch',num2str(s_chan),'_code',num2str(code),'_spike_phase_histogram.fig'],1);
                            sp_hist = gcf;
                            hist_counts = sp_hist.Children.Children.Values;
                            
                            if max(hist_counts) >= min_highest_count
                                count_ratio = [count_ratio, (max(hist_counts)/min(hist_counts))]; %#ok<AGROW>
                                neuron_chans = [neuron_chans, s_chan]; %#ok<AGROW>
                                neuron_codes = [neuron_codes, code]; %#ok<AGROW>
                                blocks = [blocks, block]; %#ok<AGROW>
                                
                                highest = maxk(hist_counts,num_for_multi_ratio);
                                lowest = mink(hist_counts,num_for_multi_ratio);
                                lowest = 1./lowest;
                                multi_ratios = highest'*lowest;
                                multi_count_ratio = [multi_count_ratio, mean(multi_ratios(:))]; %#ok<AGROW>
                            end
                            
                            close all
                        end
                    end
                end
            end
            [~,sort_idx] = sort(multi_count_ratio,'descend');
            
            multi_count_ratio = multi_count_ratio(sort_idx);
            count_ratio = count_ratio(sort_idx);
            neuron_chans = neuron_chans(sort_idx);
            neuron_codes = neuron_codes(sort_idx);
            blocks = blocks(sort_idx);
            eval(['PL_hist_stats.', LFP_area{1}, 'Ch_', neuron_area{1}, 'Nrn = [multi_count_ratio; count_ratio; blocks; neuron_chans; neuron_codes];'])
        end
    end
    save([rootpath,animal,'/Day',num2str(day),'/Phase-locking_histogram_stats.mat'], 'PL_hist_stats')
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Create Time-matched ERSP Heatmaps and Bar Graphs (65)

if enabled(65)
    disp('Block 65...')
    freq_range = [1.5 4];  %in hz
    time_range = [-250 750]; %in ms
    day_M1_means = zeros(1,param.days);
    day_Cb_means = zeros(1,param.days);
    day_M1_err = zeros(1,param.days);
    day_Cb_err = zeros(1,param.days);
    days_to_plot = [1 5];
    power_inc_thresh = 0.5;
    rr_duration_thresh = 0.3; %in seconds
    
    M1_day_ch_means = cell(1, param.days);
    Cb_day_ch_means = cell(1, param.days);
    for day=1:param.days
        day_M1_ersp = [];
        day_Cb_ersp = [];
        for block=1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/inter_event_intervals', '.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Bad_trials', '.mat']);
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/ERSP_reach', '.mat']);

            M1_reach_retract_interval = reach_retract_interval;
            M1_reach_retract_interval(M1_bad_trials) = [];
            M1_ersp_data = M1_ersp_data(:,:,:,M1_reach_retract_interval < rr_duration_thresh);
            Cb_reach_retract_interval = reach_retract_interval;
            Cb_reach_retract_interval(Cb_bad_trials) = [];
            Cb_ersp_data = Cb_ersp_data(:,:,:,Cb_reach_retract_interval < rr_duration_thresh);
            
            %M1_heatmap = create_power_heatmap((M1_ersp_data .* conj(M1_ersp_data)), times, freqs);
            M1_heatmap = create_power_heatmap(abs(M1_ersp_data), M1_times, M1_freqs);
            saveas(M1_heatmap, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/M1_fast_power_heatmap', '.fig'])
            close all
            
            %Cb_heatmap = create_power_heatmap((Cb_ersp_data .* conj(Cb_ersp_data)), times, freqs);
            Cb_heatmap = create_power_heatmap(abs(Cb_ersp_data), Cb_times, Cb_freqs);
            saveas(Cb_heatmap, [rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/Cb_fast_power_heatmap', '.fig'])
            close all
            
            %real_data = M1_ersp_data .* conj(M1_ersp_data);
            real_data = abs(M1_ersp_data);
            data_mean = mean(real_data(:,:,M1_times>-1500&M1_times<-500,:),3);
            data_std = std(real_data(:,:,M1_times>-1500&M1_times<-500,:),[],3);
            zs_data = (real_data-data_mean) ./ data_std;
            day_M1_ersp = cat(4, day_M1_ersp, zs_data(:,(M1_freqs>=freq_range(1)) & (M1_freqs<=freq_range(2)),(M1_times>=time_range(1)) & (M1_times<=time_range(2)),:));
            
            %real_data = Cb_ersp_data .* conj(Cb_ersp_data);
            real_data = abs(Cb_ersp_data);
            data_mean = mean(real_data(:,:,Cb_times>-1500&Cb_times<-500,:),3);
            data_std = std(real_data(:,:,Cb_times>-1500&Cb_times<-500,:),[],3);
            zs_data = (real_data-data_mean) ./ data_std;
            day_Cb_ersp = cat(4, day_Cb_ersp, zs_data(:,(Cb_freqs>=freq_range(1)) & (Cb_freqs<=freq_range(2)),(Cb_times>=time_range(1)) & (Cb_times<=time_range(2)),:));
            
            clear M1_heatmap Cb_heatmap M1_ersp_data Cb_ersp_data times freqs;
        end
        M1_day_ch_means{day} = squeeze(mean(mean(day_M1_ersp,3),2));
        Cb_day_ch_means{day} = squeeze(mean(mean(day_Cb_ersp,3),2));
    end

    
    load([rootpath,animal,'/Shared_Data.mat'])
    shared_data.M1_fast_day_spectral_power = M1_day_ch_means;
    shared_data.Cb_fast_day_spectral_power = Cb_day_ch_means;
    save([rootpath,animal,'/Shared_Data.mat'], 'shared_data')
    
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
end

%% Create PC space for Reactivation Analysis (66)

if enabled(66)
    disp('Block 66...')
    addpath(genpath('Z:\Matlab for analysis\PCA_cellassembly'))
    M1_neurons_of_interest = cellfun(@not,cellfun(@isnan,param.M1_neuron_chans,'UniformOutput', false),'UniformOutput', false);
    Cb_neurons_of_interest = cellfun(@not,cellfun(@isnan,param.Cb_neuron_chans,'UniformOutput', false),'UniformOutput', false);
    bin_width = 1; %in Fs
    window = [-0.5 1]; %in seconds
    
    opts.threshold.method = 'MarcenkoPastur';
    opts.Patterns.method = 'PCA';
    opts.Patterns.number_of_iterations = 1000;
    
    bin_window = round((window+4) * param.M1_Fs);
    edges = bin_window(1):bin_width:bin_window(2);
    for day = 1:param.days
        load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{1},'/spiketrain_snapshots_full.mat']);
        
        day_neurons_of_interest = find(M1_neurons_of_interest{day}(:));
        if isempty(day_neurons_of_interest)
            M1_patterns = nan;
            M1_eigenvalues = nan;
            M1_lambda_max = nan;
            M1_score = nan;
            
            figure
            title('No Neurons')
            filename=[rootpath,animal,'/Day',num2str(day),'/Corr_mat_M1.tiff'];
            saveas(gcf,filename);
            close all
            %important_PCs_M1 = [];
        else
            neuron_idx = 0;
            succ_cat_hist = nan(length(day_neurons_of_interest), size(M1_spike_snapshots_full,3)*(length(edges)-1));
            for full_neuron_idx = day_neurons_of_interest'
                neuron_idx = neuron_idx+1;
                [chan, neuron] = ind2sub(size(M1_neurons_of_interest{day}), full_neuron_idx);
                for trial = 1:size(M1_spike_snapshots_full,3)
                    time_range = ((trial-1)*(length(edges)-1))+1 : trial*(length(edges)-1);
                    succ_cat_hist(neuron_idx,time_range) = histcounts(M1_spike_snapshots_full{chan,neuron,trial}, edges);
                end
            end
            [M1_patterns, M1_eigenvalues, M1_lambda_max, M1_score] = assembly_patterns(succ_cat_hist,opts);
            
            correlationmat = corr(succ_cat_hist');
            figure(1), clf
            imagesc(correlationmat); colorbar;
            title('Correlation Matrix of Single Units During Successful Reach Trials')
            filename=[rootpath,animal,'/Day',num2str(day),'/Corr_mat_M1.tiff'];
            saveas(gcf,filename);
            close all
            %important_PCs_M1 = find(M1_eigenvalues > M1_lambda_max);
        end
        
        day_neurons_of_interest = find(Cb_neurons_of_interest{day}(:));
        if isempty(day_neurons_of_interest)
            Cb_patterns = nan;
            Cb_eigenvalues = nan;
            Cb_lambda_max = nan;
            Cb_score = nan;
            
            figure
            title('No Neurons')
            filename=[rootpath,animal,'/Day',num2str(day),'/Corr_mat_Cb.tiff'];
            saveas(gcf,filename);
            close all
            %important_PCs_Cb = [];
        else
            neuron_idx = 0;
            succ_cat_hist = nan(length(day_neurons_of_interest), size(Cb_spike_snapshots_full,3)*(length(edges)-1));
            for full_neuron_idx = day_neurons_of_interest'
                neuron_idx = neuron_idx+1;
                [chan, neuron] = ind2sub(size(Cb_neurons_of_interest{day}), full_neuron_idx);
                for trial = 1:size(Cb_spike_snapshots_full,3)
                    time_range = ((trial-1)*(length(edges)-1))+1 : trial*(length(edges)-1);
                    succ_cat_hist(neuron_idx,time_range) = histcounts(Cb_spike_snapshots_full{chan,neuron,trial}, edges);
                end
            end
            [Cb_patterns, Cb_eigenvalues, Cb_lambda_max, Cb_score] = assembly_patterns(succ_cat_hist,opts);
        
            correlationmat = corr(succ_cat_hist');
            figure(1), clf
            imagesc(correlationmat); colorbar;
            title('Correlation Matrix of Single Units During Successful Reach Trials')
            filename=[rootpath,animal,'/Day',num2str(day),'/Corr_mat_Cb.tiff'];
            saveas(gcf,filename);
            close all
            %important_PCs_Cb = find(Cb_eigenvalues > Cb_lambda_max);
        end
        
        M1_eigen_lambda_ratio = M1_eigenvalues(M1_eigenvalues > M1_lambda_max)/M1_lambda_max;
        Cb_eigen_lambda_ratio = Cb_eigenvalues(Cb_eigenvalues > Cb_lambda_max)/Cb_lambda_max;
        save([rootpath,animal,'/Day',num2str(day),'/',param.block_names{1},'/PC_reach_patterns.mat'], 'M1_patterns', 'Cb_patterns', 'M1_eigen_lambda_ratio', 'Cb_eigen_lambda_ratio');
    end
    rmpath(genpath('Z:\Matlab for analysis\PCA_cellassembly'))
end

%% New Neural Trajectory Consistency Analysis (67)

if enabled(67)
    disp('Block 67...')
    M1_factors = 2;
    Cb_factors = 2;
    reference_event = 'touch'; %'reach', touch' 'retract'
    pre_margin = 250; %in ms, use multiples of 10
    post_margin = 250; %in ms, use multiples of 10
    
    pre_margin = round(pre_margin/10);
    post_margin = round(post_margin/10);
    traj_len = pre_margin + post_margin + 1;
    M1_all_traj_corr_full = cell(param.days,3);
    Cb_all_traj_corr_full = cell(param.days,3);
    for day = 1:param.days
        day_traj_M1_succ = zeros(M1_factors,traj_len,0);
        day_traj_M1_fail = zeros(M1_factors,traj_len,0);
        day_traj_Cb_succ = zeros(M1_factors,traj_len,0);
        day_traj_Cb_fail = zeros(M1_factors,traj_len,0);
        for block = 1:param.blocks
            load([rootpath,animal,'/Day',num2str(day),'/',param.block_names{block},'/inter_event_intervals.mat']);
            reach_touch_interval(reach_touch_interval == -1) = [];
            reach_retract_interval(reach_retract_interval == -1) = [];
            
            for trial = 1:length(reach_touch_interval)
                if strcmp(reference_event,'reach')
                    event_offset = 26;
                elseif strcmp(reference_event,'touch')
                    event_offset = 26 + round(reach_touch_interval(trial)*100);
                elseif strcmp(reference_event,'retract')
                    event_offset = 26 + round(reach_retract_interval(trial)*100);
                    if event_offset ~= M1_GPFA_data(trial).epochStarts(3) %Sanity check
                        error('Sanity check failed')
                    end
                else
                    error('Unrecognized event')
                end
                
            end
        end
        
        if exist([rootpath,animal,'/Day',num2str(day),'/M1_2PC_factors.mat'],'file')
            load([rootpath,animal,'/Day',num2str(day),'/M1_2PC_factors.mat']);
            M1_traj = D;
            clear D
        else
            M1_traj = struct();
            M1_traj = repmat(M1_traj,0,1);
        end
        for trial = 1:length(M1_traj)
            if strcmp(M1_traj(trial).condition,'success')
                day_traj_M1_succ = cat(3,day_traj_M1_succ, M1_traj(trial).data(1:M1_factors,(event_offset-pre_margin):(event_offset+post_margin)));
            elseif strcmp(M1_traj(trial).condition,'failure')
                day_traj_M1_fail = cat(3,day_traj_M1_fail, M1_traj(trial).data(1:M1_factors,(event_offset-pre_margin):(event_offset+post_margin)));
            else
                error('Problem with stored outcome')
            end
        end
        
        if exist([rootpath,animal,'/Day',num2str(day),'/Cb_2PC_factors.mat'],'file')
            load([rootpath,animal,'/Day',num2str(day),'/Cb_2PC_factors.mat']);
            Cb_traj = D;
            clear D
        else
            Cb_traj = struct();
            Cb_traj = repmat(Cb_traj,0,1);
        end
        for trial = 1:length(Cb_traj)
            if strcmp(Cb_traj(trial).condition,'success')
                day_traj_Cb_succ = cat(3,day_traj_Cb_succ, Cb_traj(trial).data(1:Cb_factors,(event_offset-pre_margin):(event_offset+post_margin)));
            elseif strcmp(Cb_traj(trial).condition,'failure')
                day_traj_Cb_fail = cat(3,day_traj_Cb_fail, Cb_traj(trial).data(1:Cb_factors,(event_offset-pre_margin):(event_offset+post_margin)));
            else
                error('Problem with stored outcome')
            end
        end
        
        M1_all_traj_corr_full{day,1} = trajectory_consistency_calc2(day_traj_M1_succ);
        M1_all_traj_corr_full{day,2} = trajectory_consistency_calc2(day_traj_M1_fail, mean(day_traj_M1_succ,3));
        Cb_all_traj_corr_full{day,1} = trajectory_consistency_calc2(day_traj_Cb_succ);
        Cb_all_traj_corr_full{day,2} = trajectory_consistency_calc2(day_traj_Cb_fail, mean(day_traj_Cb_succ,3));
    end
    
    load([rootpath,animal,'/Shared_Data.mat'])
    shared_data.M1_succ_traj_corr_full2 = M1_all_traj_corr_full(:,1)';
    shared_data.M1_fail_traj_corr_full2 = M1_all_traj_corr_full(:,2)';
    shared_data.Cb_succ_traj_corr_full2 = Cb_all_traj_corr_full(:,1)';
    shared_data.Cb_fail_traj_corr_full2 = Cb_all_traj_corr_full(:,2)';
    save([rootpath,animal,'/Shared_Data.mat'], 'shared_data')
    
    clearvars -except code_rootpath rootpath origin_rootpath animal param enabled;
    close all
end

%% Reach 1vs2 Success and Reach Duration

beep
disp 'Analysis Complete.'