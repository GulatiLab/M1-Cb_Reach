clear;clc;close all;

origin_rootpath = 'Z:/M1_Cb_Reach/';
rootpath = 'Z:/Pierson_Data_Analysis/';

new_origin_rootpath = 'C:/Users/FleischerP/Documents/MATLAB/HPC_files/raw_data/';
new_rootpath = 'C:/Users/FleischerP/Documents/MATLAB/HPC_files/data/';

animal = 'I060';

if strcmp(animal, 'I060')
    %I060 Settings
    training_block_names = {'I050-200316-135106' 'I050-200316-162539';
                            'I050-200317-113531' 'I050-200317-144149';
                            'I050-200318-115517' 'I050-200318-144712';
                            'I050-200319-112351' 'I050-200319-141221';
                            'I050-200320-112028' 'I050-200320-140715'};

       sleep_block_names = {'I050-200316-115829' 'I050-200316-145422';
                            'I050-200317-092828' 'I050-200317-122703';
                            'I050-200318-095036' 'I050-200318-123956';
                            'I050-200319-092129' 'I050-200319-121123';
                            'I050-200320-092309' 'I050-200320-120325'};
                    
    durFiles = ['Durations_200316';'Durations_200317';'Durations_200318';'Durations_200319';'Durations_200320'];

elseif strcmp(animal, 'I061')
    %I061 Settings
    training_block_names = {['TDT_data/I061-200511-135832';'TDT_data/I061-200511-142659'] ['TDT_data/I061-200511-162529'];
                            ['TDT_data/I061-200512-122518'] ['TDT_data/I061-200512-151526'];
                            ['TDT_data/I061-200513-111020'] ['TDT_data/I061-200513-135834'];
                            ['TDT_data/I061-200514-120137'] ['TDT_data/I061-200514-145444'];
                            ['TDT_data/I061-200515-113618'] ['TDT_data/I061-200515-142605']};
                    
       sleep_block_names = {['TDT_data/I061-200511-105824';'TDT_data/I061-200511-123320'] ['TDT_data/I061-200511-150921'];
                            ['TDT_data/I061-200512-102347'] ['TDT_data/I061-200512-131257'];
                            ['TDT_data/I061-200513-090705'] ['TDT_data/I061-200513-115747'];
                            ['TDT_data/I061-200514-094708'] ['TDT_data/I061-200514-125245'];
                            ['TDT_data/I061-200515-093406'] ['TDT_data/I061-200515-122415']};
        
    durFiles = ['Durations_200511';'Durations_200512';'Durations_200513';'Durations_200514';'Durations_200515'];                        
end

codes_filename = {'_PreSleep' '_PostSleep'};
block_names = {'Training1' 'Training2'};
days = 5;
blocks = length(block_names);

auditory_evoked_response_removal = 0; %Centered at door-open signal    (9)
   motor_evoked_response_removal = 0; %Centered at reach onset         (11)

tag = '';
if auditory_evoked_response_removal
    tag = [tag '_AER']; %#ok<UNRCH> Depending on the evoked response removal settings tag2 may remain empty. This is the intended behavior.
end
if motor_evoked_response_removal
    tag = [tag '_MER']; %#ok<UNRCH> Depending on the evoked response removal settings tag2 may remain unchanged. This is the intended behavior.
end

cd('C:/Users/FleischerP/Documents/MATLAB')

%All load calls used in HPC script; For reference
%load([rootpath,animal,'/Bad_channels.mat']);

%load([rootpath,animal,'/Day',char(string(day)),'/',block_names{block},'/Normalized_Snapshots', tag, '.mat']);
%load([rootpath,animal,'/Day',char(string(day)),'/',block_names{block},'/Bad_trials.mat']);
%load([rootpath,animal,'/Day',char(string(day)),'/',block_names{block},'/spiketrain_snapshots_full.mat']);
%load([origin_rootpath,animal,'/Day',char(string(day)),'/Reach_Vids/Results/D',char(string(day)),codes_filename{block},'_GUI.mat']);

%clear old data
if(exist(new_rootpath,'dir'))
    rmdir(new_rootpath, 's')
end
if(exist(new_origin_rootpath,'dir'))
    rmdir(new_origin_rootpath, 's')
end

%Standard day/block files
mkdir(new_rootpath,animal)
mkdir([new_origin_rootpath,animal])
copyfile([rootpath,animal,'/Bad_channels.mat'],...
    [new_rootpath,animal,'/Bad_channels.mat']); %Always
for day = 1:days
    mkdir([new_rootpath,animal,'/Day',char(string(day))])
    mkdir([new_origin_rootpath,animal,'/Day',char(string(day)),'/Reach_Vids/Results/'])
    for block = 1:blocks
        mkdir([new_rootpath,animal,'/Day',char(string(day)),'/',block_names{block}])
        copyfile([rootpath,animal,'/Day',char(string(day)),'/',block_names{block},'/Normalized_Snapshots', tag, '.mat'],...
            [new_rootpath,animal,'/Day',char(string(day)),'/',block_names{block},'/Normalized_Snapshots', tag, '.mat']);
        copyfile([rootpath,animal,'/Day',char(string(day)),'/',block_names{block},'/Bad_trials.mat'],...
            [new_rootpath,animal,'/Day',char(string(day)),'/',block_names{block},'/Bad_trials.mat']);
        copyfile([rootpath,animal,'/Day',char(string(day)),'/',block_names{block},'/spiketrain_snapshots_full.mat'],...
            [new_rootpath,animal,'/Day',char(string(day)),'/',block_names{block},'/spiketrain_snapshots_full.mat']);
        copyfile([rootpath,animal,'/Day',char(string(day)),'/',block_names{block},'/GUI_data.mat'],...
            [new_rootpath,animal,'/Day',char(string(day)),'/',block_names{block},'/GUI_data.mat']);
    end
end
 
%Non-standard day/block files (sleep blocks, sub-blocks, etc.)
for day = 1:days
    
end
