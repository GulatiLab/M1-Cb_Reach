%% Field-Field Coherence 
%% Get Cross-frequency coherence using eeglab
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
            ,'I061\Data\I061-200509-122650'...
            ,'I050\Data\I050-191218-130447'...
            ,'I050\Data\I050-191219-141503'...
            ,'I050\Data\I050-191220-135239'...
            ,'I050\Data\I050-191221-141352'...
            ,'I050\Data\I050-191223-160416'...
            ,'I060\Data\I060-200310-143141'...
            ,'I060\Data\I060-200311-140222'...
            ,'I060\Data\I060-200312-134253'...
            ,'I060\Data\I060-200313-142005'...
            ,'I060\Data\I060-200314-160410'...
            ,'I061\Data\I061-200505-144749'...
            ,'I061\Data\I061-200506-142306'...
            ,'I061\Data\I061-200507-131918'...
            ,'I061\Data\I061-200508-142120'...
            ,'I061\Data\I061-200509-150451'};           

tic;          
for i=1:length(bmiBlocks)
  
  disp(bmiBlocks{i});
  
  % Clear shared variables
  clear e_* l_* trial_* times freqs tmp med
  
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
  
  % Split trials in to early and late
  e_trial_data1_cmr = trial_data1_cmr(:,:,1:floor(size(trial_data1_cmr,3)/3));  
  l_trial_data1_cmr = trial_data1_cmr(:,:,end-floor(size(trial_data1_cmr,3)/3)+1:end);  
  
  % Split trials in early and late
  e_trial_data2_cmr = trial_data2_cmr(:,:,1:floor(size(trial_data2_cmr,3)/3));  
  l_trial_data2_cmr = trial_data2_cmr(:,:,end-floor(size(trial_data2_cmr,3)/3)+1:end);  
  
  % Get Cross-Field Spectrum for early trials 
  for j=1:size(e_trial_data1_cmr,1)
    data1 = squeeze(e_trial_data1_cmr(j,1:8000,:));
    for k=1:size(e_trial_data2_cmr,1)
    cprintf('blue',[bmiBlocks{i}(end-17:end),' CMR early Ch_M1: ',num2str(j),' Ch_Cb: ',num2str(k)]);
    data2 = squeeze(e_trial_data2_cmr(k,1:8000,:));
    [e_coher_cmr(j,:,:,k),~,times,freqs,~,e_cohangle_cmr(j,:,:,k),~]...
      = newcrossf(data1(:)',data2(:)',8000,[-4000 4000],Fs,[0.01 0.1],'type','coher','freqs', [0 60]);    
    end
  end
  
  % Get Cross-Field Spectrum for late trials 
  for j=1:size(l_trial_data1_cmr,1)
    data1 = squeeze(l_trial_data1_cmr(j,1:8000,:));
    for k=1:size(l_trial_data2_cmr,1)
    cprintf('blue',[bmiBlocks{i}(end-17:end),' CMR late Ch_M1: ',num2str(j),' Ch_Cb: ',num2str(k)]);
    data2 = squeeze(l_trial_data2_cmr(k,1:8000,:));
    [l_coher_cmr(j,:,:,k),~,times,freqs,~,l_cohangle_cmr(j,:,:,k),~]...
      = newcrossf(data1(:)',data2(:)',8000,[-4000 4000],Fs,[0.01 0.1],'type','coher','freqs', [0 60]);    
    end
  end  
    
  save([rootpath,bmiBlocks{i},'\FFC_EL_CMR.mat'],...
    'e_coher_cmr','e_cohangle_cmr',...
    'l_coher_cmr','l_cohangle_cmr',...
    'times','freqs','-v7.3');   
                                       
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
  
  % Split trials in to early and late
  e_trial_data1_erp = trial_data1_erp(:,:,1:floor(size(trial_data1_erp,3)/3));  
  l_trial_data1_erp = trial_data1_erp(:,:,end-floor(size(trial_data1_erp,3)/3)+1:end);  
  
  % Split trials in to early and late
  e_trial_data2_erp = trial_data2_erp(:,:,1:floor(size(trial_data2_erp,3)/3));  
  l_trial_data2_erp = trial_data2_erp(:,:,end-floor(size(trial_data2_erp,3)/3)+1:end); 
  
  % Get Cross-Field Spectrum for early trials 
  for j=1:size(e_trial_data1_erp,1)
    data1 = squeeze(e_trial_data1_erp(j,1:8000,:));
    for k=1:size(e_trial_data2_erp,1)
    cprintf('blue',[bmiBlocks{i}(end-17:end),' ERP early Ch_M1: ',num2str(j),' Ch_Cb: ',num2str(k)]);
    data2 = squeeze(e_trial_data2_erp(k,1:8000,:));
    [e_coher_erp(j,:,:,k),~,times,freqs,~,e_cohangle_erp(j,:,:,k),~]...
      = newcrossf(data1(:)',data2(:)',8000,[-4000 4000],Fs,[0.01 0.1],'type','coher','freqs', [0 60]);    
    end
  end
  
  % Get Cross-Field Spectrum for late trials 
  for j=1:size(l_trial_data1_erp,1)
    data1 = squeeze(l_trial_data1_erp(j,1:8000,:));
    for k=1:size(l_trial_data2_erp,1)
    cprintf('blue',[bmiBlocks{i}(end-17:end),' ERP late Ch_M1: ',num2str(j),' Ch_Cb: ',num2str(k)]);
    data2 = squeeze(l_trial_data2_erp(k,1:8000,:));
    [l_coher_erp(j,:,:,k),~,times,freqs,~,l_cohangle_erp(j,:,:,k),~]...
      = newcrossf(data1(:)',data2(:)',8000,[-4000 4000],Fs,[0.01 0.1],'type','coher','freqs', [0 60]);
    end
  end  

  save([rootpath,bmiBlocks{i},'\FFC_EL_ERP.mat'],...
    'e_coher_erp','e_cohangle_erp',...
    'l_coher_erp','l_cohangle_erp',...
    'times','freqs','-v7.3');  

end
close;
runTime = toc;
disp(['done! time elapsed (hours) - ', num2str(runTime/3600)]);
