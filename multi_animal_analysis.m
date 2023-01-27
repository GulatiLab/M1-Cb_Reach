clear;clc;close all;


if isunix
    cd('/common/fleischerp/');
    origin_rootpath = '/common/fleischerp/raw_data/';
    rootpath = '/common/fleischerp/data/';
else
    restoredefaultpath()
    origin_rootpath = 'Z:/M1_Cb_Reach/';
    rootpath = 'D:/Pierson_Data_Analysis/';
end

%I060, I086, I089, I107, I110, and I122 have no behavoral anomalies 
%I061 and I064 didn't show improved rate of success 
%I076 handedness was determined incorrectly
%I089 had intense noise in Cb so Cb results are not saved if I089 is in the animals list. Sleep blocks were skipped in days 4 and 5 so sleep analysis was not run
%I096 has a day 5 success rate < 30%
%I110 did not have an implant in M1 so M1 results are not saved if I110 is in the animals list. No Sleep blocks were performed so sleep analysis was not run
animals = {'I060' 'I086' 'I107' 'I122'}; %Good:{'I060' 'I086' 'I089' 'I107' 'I110' 'I122'};, Bad: {'I061' 'I064' 'I076' 'I096'}

BO_animals = {}; %'I027' 'I031' 'I033' 'I039' 'I073' 'I075' 'I111' 'I112'};, Bad?: {'I119' 'I127'}

animal_data = cell(1, (length(animals) + length(BO_animals)));
for animal_idx = 1:length(animals)
    load([rootpath,animals{animal_idx},'/Shared_Data.mat'])
    animal_data(animal_idx) = {shared_data};
end

animals = [animals BO_animals];
for animal_idx = (length(animals) + 1 - length(BO_animals)):length(animals)
    load([rootpath,'behavior_only_animals/',animals{animal_idx},'/Shared_Data.mat'])
    animal_data(animal_idx) = {shared_data};
end
clear shared_data
                % 0: Behavior video only, 1: Reach analysis, 2: sleep analysis
                %  0  1  1  1  3  -  4  1  1  0  1  1  1* 1  1  2  2  2  1  1  2  2  3  0         
                %  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24
enabled = logical([0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  1]); %Enables or disables various data processing. Enabled processes that require earlier, disabled processes will attempt to load data.


%% 1: Success Rate Graphs (Lemke 1c, bottom right)
if enabled(1)
    days = [[1;2] [4;5]];
    success_rate = zeros(length(animals), size(days, 2));
    tbl = zeros(0,3);
    for animal_idx = 1:length(animal_data)
        animal_success = animal_data{animal_idx}.day_success_rate(1,:)./animal_data{animal_idx}.day_success_rate(2,:);
        success_rate(animal_idx,:) = nanmean(animal_success(days),1);
        
        for epoch = 1:size(days,2)
            outcomes = [ones(sum(animal_data{animal_idx}.day_success_rate(1,days(:,epoch))),1);zeros(sum(animal_data{animal_idx}.day_success_rate(2,days(:,epoch)) - animal_data{animal_idx}.day_success_rate(1,days(:,epoch))),1)];
            animal_vec = ones(length(outcomes),1) * animal_idx;
            epoch_vec = ones(length(outcomes),1) * epoch;
            tbl = cat(1,tbl,[outcomes,epoch_vec,animal_vec]);
        end
    end
    y = 1:length(animals);
    y = repmat(y', [1 size(success_rate,2)]);
    z = 1:size(success_rate,2);
    z = repmat(z, [size(success_rate,1) 1]);
    tbl = array2table(tbl,'VariableNames',{'data','day','animal'});
    %tbl.day = nominal(tbl.day);
    tbl.animal = nominal(tbl.animal);
    formula = 'data ~ 1 + day + (1 | animal)';
    lme_all = fitlme(tbl,formula);
    
    
    figure
    bar(mean(days,1), mean(success_rate,1))
    hold on
    line(mean(days,1), success_rate', 'LineWidth', 1) %, 'Color', [.7 .7 .7])
    errorbar(mean(days,1), mean(success_rate,1), std(success_rate,0,1)/sqrt(length(animals)), std(success_rate,0,1)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    axis([mean(days(:,1),1)-2 mean(days(:,end))+2 0 1])
    p_val = coefTest(lme_all);
    title(['P-val: ', num2str(p_val)]);
    saveas(gcf,[rootpath, '/Success_Rate.fig'])
    hold off
    close all
    clearvars -except rootpath origin_rootpath animals enabled animal_data BO_animals;
end

%% 2: LFP Power Graphs (Lemke 2b right)

if enabled(2)
    fast_only = false;
    days = [[1;2] [4;5]];
    SvF_days = [5];
    M1_power = zeros(length(animals), size(days, 2));
    Cb_power = zeros(length(animals), size(days, 2));
    M1_table = zeros(0,3);
    Cb_table = zeros(0,3);
    
    M1_SvF_power = zeros(length(animals), 2);
    Cb_SvF_power = zeros(length(animals), 2);
    M1_SvF_table = zeros(0,3);
    Cb_SvF_table = zeros(0,3);
    for animal_idx = 1:length(animals)
        if fast_only
            M1_day_spectral_power = animal_data{animal_idx}.M1_fast_day_spectral_power;
            Cb_day_spectral_power = animal_data{animal_idx}.Cb_fast_day_spectral_power;
        else
            M1_day_spectral_power = animal_data{animal_idx}.M1_day_spectral_power;
            Cb_day_spectral_power = animal_data{animal_idx}.Cb_day_spectral_power;
        end
        for epoch = 1:size(days,2)
            epoch_powers = zeros(1,0);
            for day = days(:,epoch)'
                epoch_powers = cat(2, epoch_powers, mean(M1_day_spectral_power{day}, 1));
            end
            M1_power(animal_idx, epoch) = mean(epoch_powers,'omitnan');
            M1_table = cat(1, M1_table, [epoch_powers', (ones(length(epoch_powers),1) * epoch), (ones(length(epoch_powers),1) * animal_idx)]);
            
            epoch_powers = zeros(1,0);
            for day = days(:,epoch)'
                epoch_powers = cat(2, epoch_powers, mean(Cb_day_spectral_power{day}, 1));
            end
            Cb_power(animal_idx, epoch) = mean(epoch_powers,'omitnan');
            Cb_table = cat(1, Cb_table, [epoch_powers', (ones(length(epoch_powers),1) * epoch), (ones(length(epoch_powers),1) * animal_idx)]);
        end
        
        M1_animal_succ_powers = zeros(1,0);
        M1_animal_fail_powers = zeros(1,0);
        Cb_animal_succ_powers = zeros(1,0);
        Cb_animal_fail_powers = zeros(1,0);
        for day = SvF_days
            M1_animal_succ_powers = cat(2, M1_animal_succ_powers, mean(animal_data{animal_idx}.M1_day_succ_spectral_power{day},1));
            M1_animal_fail_powers = cat(2, M1_animal_fail_powers, mean(animal_data{animal_idx}.M1_day_fail_spectral_power{day},1));
            Cb_animal_succ_powers = cat(2, Cb_animal_succ_powers, mean(animal_data{animal_idx}.Cb_day_succ_spectral_power{day},1));
            Cb_animal_fail_powers = cat(2, Cb_animal_fail_powers, mean(animal_data{animal_idx}.Cb_day_fail_spectral_power{day},1));
        end
        M1_SvF_power(animal_idx, 1) = mean(M1_animal_succ_powers);
        M1_SvF_power(animal_idx, 2) = mean(M1_animal_fail_powers);
        Cb_SvF_power(animal_idx, 1) = mean(Cb_animal_succ_powers);
        Cb_SvF_power(animal_idx, 2) = mean(Cb_animal_fail_powers);
        
        M1_SvF_table = cat(1, M1_SvF_table, [M1_animal_succ_powers', (ones(length(M1_animal_succ_powers),1)), (ones(length(M1_animal_succ_powers),1) * animal_idx)]);
        M1_SvF_table = cat(1, M1_SvF_table, [M1_animal_fail_powers', (zeros(length(M1_animal_fail_powers),1)), (ones(length(M1_animal_fail_powers),1) * animal_idx)]);
        Cb_SvF_table = cat(1, Cb_SvF_table, [Cb_animal_succ_powers', (ones(length(Cb_animal_succ_powers),1)), (ones(length(Cb_animal_succ_powers),1) * animal_idx)]);
        Cb_SvF_table = cat(1, Cb_SvF_table, [Cb_animal_fail_powers', (zeros(length(Cb_animal_fail_powers),1)), (ones(length(Cb_animal_fail_powers),1) * animal_idx)]);
    end
    M1_table = array2table(M1_table,'VariableNames',{'data','day','animal'});
    formula = 'data ~ 1 + day + (1 | animal)';
    M1_lme_all = fitlme(M1_table,formula);
    Cb_table = array2table(Cb_table,'VariableNames',{'data','day','animal'});
    formula = 'data ~ 1 + day + (1 | animal)';
    Cb_lme_all = fitlme(Cb_table,formula);
    
    M1_SvF_table = array2table(M1_SvF_table,'VariableNames',{'data','outcome','animal'});
    formula = 'data ~ 1 + outcome + (1 | animal)';
    M1_lme_SvF = fitlme(M1_SvF_table,formula);
    Cb_SvF_table = array2table(Cb_SvF_table,'VariableNames',{'data','outcome','animal'});
    formula = 'data ~ 1 + outcome + (1 | animal)';
    Cb_lme_SvF = fitlme(Cb_SvF_table,formula);
    
    figure
    hold on
    bar(mean(days,1), mean(M1_power,1));
    line(mean(days,1), M1_power', 'LineWidth', 1) %, 'Color', [.7 .7 .7])
    errorbar(mean(days,1), mean(M1_power,1), std(M1_power,0,1)/sqrt(length(animals)), std(M1_power,0,1)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    p_val = coefTest(M1_lme_all);
    title(['P-val: ', num2str(p_val)]);
    if sum(strcmp(animals,'I110')) == 0
        if fast_only
            saveas(gcf,[rootpath, '/M1_fast_power.fig'])
        else
            saveas(gcf,[rootpath, '/M1_power.fig'])
        end
    end
    hold off
    close all
    
    figure
    hold on
    bar(mean(days,1), mean(Cb_power,1));
    line(mean(days,1), Cb_power', 'LineWidth', 1) %, 'Color', [.7 .7 .7])
    errorbar(mean(days,1), mean(Cb_power,1), std(Cb_power,0,1)/sqrt(length(animals)), std(Cb_power,0,1)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    p_val = coefTest(Cb_lme_all);
    title(['P-val: ', num2str(p_val)]);
    if sum(strcmp(animals,'I089')) == 0
        if fast_only
            saveas(gcf,[rootpath, '/Cb_fast_power.fig'])
        else
            saveas(gcf,[rootpath, '/Cb_power.fig'])
        end
    end
    hold off
    close all
    
    figure
    hold on
    bar(1:-1:0, mean(M1_SvF_power,1));
    line(1:-1:0, M1_SvF_power', 'LineWidth', 1) %, 'Color', [.7 .7 .7])
    errorbar(1:-1:0, mean(M1_SvF_power,1), std(M1_SvF_power,0,1)/sqrt(length(animals)), std(M1_SvF_power,0,1)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    p_val = coefTest(M1_lme_SvF);
    title(['P-val: ', num2str(p_val)]);
    if sum(strcmp(animals,'I110')) == 0
        saveas(gcf,[rootpath, '/M1_SvF_power.fig'])
    end
    hold off
    close all
    
    figure
    hold on
    bar(1:-1:0, mean(Cb_SvF_power,1));
    line(1:-1:0, Cb_SvF_power', 'LineWidth', 1) %, 'Color', [.7 .7 .7])
    errorbar(1:-1:0, mean(Cb_SvF_power,1), std(Cb_SvF_power,0,1)/sqrt(length(animals)), std(Cb_SvF_power,0,1)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    p_val = coefTest(Cb_lme_SvF);
    title(['P-val: ', num2str(p_val)]);
    if sum(strcmp(animals,'I089')) == 0
        saveas(gcf,[rootpath, '/Cb_SvF_power.fig'])
    end
    hold off
    close all
    
    clearvars -except rootpath origin_rootpath animals enabled animal_data BO_animals;
end

%% 3: LFP Coherence Graphs (Lemke 2c right)

if enabled(3)
    days = [[1;2] [4;5]];
    Field_Coherence = zeros(length(animals), size(days, 2));
    tbl = zeros(0,3);
    for animal_idx = 1:length(animals)
        epoch_trials = animal_data{animal_idx}.M1_Cb_reach_trial_num;
        epoch_trials = sum(epoch_trials,2);
        epoch_trials = epoch_trials(days);
        epoch_trial_sum = sum(epoch_trials,1);
        day_weight = epoch_trials./epoch_trial_sum;
        
        day_LFP_LFP_coherence = animal_data{animal_idx}.day_LFP_LFP_coherence;
        day_means = mean(day_LFP_LFP_coherence,2,'omitnan')';
        day_means = day_means(days);
        day_means = day_means .* day_weight;
        Field_Coherence(animal_idx,:) = sum(day_means,1);
%         %Epoch mean weighted by number of trials on each day
%         for epoch = 1:size(days,2)
%             epoch_cohs = animal_data{animal_idx}.day_LFP_LFP_coherence(days(:,epoch),:);
%             epoch_cohs = epoch_cohs .* day_weight(:,epoch);
%             epoch_cohs = sum(epoch_cohs,1);
%             tbl = cat(1, tbl, [epoch_cohs', (ones(length(epoch_cohs),1) * epoch), (ones(length(epoch_cohs),1) * animal_idx)]);
%         end
        %Unmodified Day Coh. More table entries, no weighting.
        for epoch = 1:size(days,2)
            epoch_cohs = animal_data{animal_idx}.day_LFP_LFP_coherence(days(:,epoch),:);
            epoch_cohs = epoch_cohs(:)';
            tbl = cat(1, tbl, [epoch_cohs', (ones(length(epoch_cohs),1) * epoch), (ones(length(epoch_cohs),1) * animal_idx)]);
        end
    end
    tbl = array2table(tbl,'VariableNames',{'data','day','animal'});
    %tbl.day = nominal(tbl.day);
    tbl.animal = nominal(tbl.animal);
    formula = 'data ~ 1 + day + (1 | animal)';
    lme_all = fitlme(tbl,formula);
    
    figure
    hold on
    bar(mean(days,1), mean(Field_Coherence,1));
    line(mean(days,1), Field_Coherence', 'LineWidth', 1) %, 'Color', [.7 .7 .7])
    errorbar(mean(days,1), mean(Field_Coherence,1), std(Field_Coherence,0,1)/sqrt(length(animals)), std(Field_Coherence,0,1)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    p_val = coefTest(lme_all);
    title(['P-val: ', num2str(p_val)]);
    if (sum(strcmp(animals,'I089')) == 0) && (sum(strcmp(animals,'I110')) == 0)
        saveas(gcf,[rootpath, '/Field_Coherence.fig'])
    end
    hold off
    close all
    clearvars -except rootpath origin_rootpath animals enabled animal_data BO_animals;
end
    
%% 4: ITC Graphs (Lemke 2d bottom)

if enabled(4)
    days = [[1;2] [4;5]];
    M1_reach_ITC_tbl = zeros(0, 3);
    M1_touch_ITC_tbl = zeros(0, 3);
    M1_retract_ITC_tbl = zeros(0, 3);
    Cb_reach_ITC_tbl = zeros(0, 3);
    Cb_touch_ITC_tbl = zeros(0, 3);
    Cb_retract_ITC_tbl = zeros(0, 3);
    
    M1_reach_ITC_mean = zeros(length(animals), size(days, 2));
    M1_touch_ITC_mean = zeros(length(animals), size(days, 2));
    M1_retract_ITC_mean = zeros(length(animals), size(days, 2));
    Cb_reach_ITC_mean = zeros(length(animals), size(days, 2));
    Cb_touch_ITC_mean = zeros(length(animals), size(days, 2));
    Cb_retract_ITC_mean = zeros(length(animals), size(days, 2));
    for animal_idx = 1:length(animals)
%         %Un-weighted calculation
%         mean_ITC = mean(animal_data{animal_idx}.M1_reach_delta_ITC,2)';
%         M1_reach_ITC_mean(animal_idx,:) = mean(mean_ITC(days),1);
%         mean_ITC = mean(animal_data{animal_idx}.M1_touch_delta_ITC,2)';
%         M1_touch_ITC_mean(animal_idx,:) = mean(mean_ITC(days),1);
%         mean_ITC = mean(animal_data{animal_idx}.M1_retract_delta_ITC,2)';
%         M1_retract_ITC_mean(animal_idx,:) = mean(mean_ITC(days),1);
%         mean_ITC = mean(animal_data{animal_idx}.Cb_reach_delta_ITC,2)';
%         Cb_reach_ITC_mean(animal_idx,:) = mean(mean_ITC(days),1);
%         mean_ITC = mean(animal_data{animal_idx}.Cb_touch_delta_ITC,2)';
%         Cb_touch_ITC_mean(animal_idx,:) = mean(mean_ITC(days),1);
%         mean_ITC = mean(animal_data{animal_idx}.Cb_retract_delta_ITC,2)';
%         Cb_retract_ITC_mean(animal_idx,:) = mean(mean_ITC(days),1);
        
        %Weighted calculation
        day_weight = sum(animal_data{animal_idx}.M1_reach_trial_num,2)';
        day_weight = day_weight(days)./sum(day_weight(days),1);
        mean_ITC = mean(animal_data{animal_idx}.M1_reach_delta_ITC,2)';
        M1_reach_ITC_mean(animal_idx,:) = sum(mean_ITC(days) .* day_weight,1);
        mean_ITC = mean(animal_data{animal_idx}.M1_touch_delta_ITC,2)';
        M1_touch_ITC_mean(animal_idx,:) = sum(mean_ITC(days) .* day_weight,1);
        mean_ITC = mean(animal_data{animal_idx}.M1_retract_delta_ITC,2)';
        M1_retract_ITC_mean(animal_idx,:) = sum(mean_ITC(days) .* day_weight,1);
        
        day_weight = sum(animal_data{animal_idx}.Cb_reach_trial_num,2)';
        day_weight = day_weight(days)./sum(day_weight(days),1);
        mean_ITC = mean(animal_data{animal_idx}.Cb_reach_delta_ITC,2)';
        Cb_reach_ITC_mean(animal_idx,:) = sum(mean_ITC(days) .* day_weight,1);
        mean_ITC = mean(animal_data{animal_idx}.Cb_touch_delta_ITC,2)';
        Cb_touch_ITC_mean(animal_idx,:) = sum(mean_ITC(days) .* day_weight,1);
        mean_ITC = mean(animal_data{animal_idx}.Cb_retract_delta_ITC,2)';
        Cb_retract_ITC_mean(animal_idx,:) = sum(mean_ITC(days) .* day_weight,1);
        
        for epoch = 1:size(days,2)
            ITC = animal_data{animal_idx}.M1_reach_delta_ITC(days(:,epoch),:);
            ITC = ITC(:);
            M1_reach_ITC_tbl = cat(1,M1_reach_ITC_tbl,[ITC, (ones(length(ITC),1) * epoch), (ones(length(ITC),1) * animal_idx)]);
            
            ITC = animal_data{animal_idx}.M1_touch_delta_ITC(days(:,epoch),:);
            ITC = ITC(:);
            M1_touch_ITC_tbl = cat(1,M1_touch_ITC_tbl,[ITC, (ones(length(ITC),1) * epoch), (ones(length(ITC),1) * animal_idx)]);
            
            ITC = animal_data{animal_idx}.M1_retract_delta_ITC(days(:,epoch),:);
            ITC = ITC(:);
            M1_retract_ITC_tbl = cat(1,M1_retract_ITC_tbl,[ITC, (ones(length(ITC),1) * epoch), (ones(length(ITC),1) * animal_idx)]);
            
            ITC = animal_data{animal_idx}.Cb_reach_delta_ITC(days(:,epoch),:);
            ITC = ITC(:);
            Cb_reach_ITC_tbl = cat(1,Cb_reach_ITC_tbl,[ITC, (ones(length(ITC),1) * epoch), (ones(length(ITC),1) * animal_idx)]);
            
            ITC = animal_data{animal_idx}.Cb_touch_delta_ITC(days(:,epoch),:);
            ITC = ITC(:);
            Cb_touch_ITC_tbl = cat(1,Cb_touch_ITC_tbl,[ITC, (ones(length(ITC),1) * epoch), (ones(length(ITC),1) * animal_idx)]);
            
            ITC = animal_data{animal_idx}.Cb_retract_delta_ITC(days(:,epoch),:);
            ITC = ITC(:);
            Cb_retract_ITC_tbl = cat(1,Cb_retract_ITC_tbl,[ITC, (ones(length(ITC),1) * epoch), (ones(length(ITC),1) * animal_idx)]);
        end
    end
    
    M1_all_ITC_tbl = [M1_reach_ITC_tbl,   (ones(size(M1_reach_ITC_tbl,1),1)*1);
                      M1_touch_ITC_tbl,   (ones(size(M1_touch_ITC_tbl,1),1)*2);
                      M1_retract_ITC_tbl, (ones(size(M1_retract_ITC_tbl,1),1)*3)];
    Cb_all_ITC_tbl = [Cb_reach_ITC_tbl,   (ones(size(Cb_reach_ITC_tbl,1),1)*1);
                      Cb_touch_ITC_tbl,   (ones(size(Cb_touch_ITC_tbl,1),1)*2);
                      Cb_retract_ITC_tbl, (ones(size(Cb_retract_ITC_tbl,1),1)*3)];
                  
    all_ITC_tbl = array2table(M1_all_ITC_tbl,'VariableNames',{'data','day','animal','move'});
    %all_ITC_tbl.day = nominal(all_ITC_tbl.day);
    all_ITC_tbl.animal = nominal(all_ITC_tbl.animal);
    all_ITC_tbl.move = nominal(all_ITC_tbl.move);
    all_ITC_formula = 'data ~ day * move + (1 | animal)'; % + (1 | animal:day) + (1 | animal:move)';
    all_ITC_lme = fitlme(all_ITC_tbl, all_ITC_formula);
    anova(all_ITC_lme);
    
    all_ITC_tbl = array2table(Cb_all_ITC_tbl,'VariableNames',{'data','day','animal','move'});
    %all_ITC_tbl.day = nominal(all_ITC_tbl.day);
    all_ITC_tbl.animal = nominal(all_ITC_tbl.animal);
    all_ITC_tbl.move = nominal(all_ITC_tbl.move);
    all_ITC_formula = 'data ~ day * move + (1 | animal)'; % + (1 | animal:day) + (1 | animal:move)';
    all_ITC_lme = fitlme(all_ITC_tbl, all_ITC_formula);
    anova(all_ITC_lme);
    
                      
    figure
    hold on
    tbl = array2table(M1_reach_ITC_tbl,'VariableNames',{'data','day','animal'});
    %tbl.day = nominal(tbl.day);
    tbl.animal = nominal(tbl.animal);
    formula = 'data ~ 1 + day + (1 | animal)';
    lme_all = fitlme(tbl,formula);
    p_val = coefTest(lme_all);
    title(['P-val: ', num2str(p_val)]);
    
    bar(mean(days,1), mean(M1_reach_ITC_mean,1));
    line(mean(days,1), M1_reach_ITC_mean', 'LineWidth', 1) %, 'Color', [.7 .7 .7])
    errorbar(mean(days,1), mean(M1_reach_ITC_mean,1), std(M1_reach_ITC_mean,0,1)/sqrt(length(animals)), std(M1_reach_ITC_mean,0,1)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    if sum(strcmp(animals,'I110')) == 0
        saveas(gcf,[rootpath, '/M1_reach_ITC.fig'])
    end
    hold off
    close all
    
    figure
    hold on
    tbl = array2table(M1_touch_ITC_tbl,'VariableNames',{'data','day','animal'});
    %tbl.day = nominal(tbl.day);
    tbl.animal = nominal(tbl.animal);
    formula = 'data ~ 1 + day + (1 | animal)';
    lme_all = fitlme(tbl,formula);
    p_val = coefTest(lme_all);
    title(['P-val: ', num2str(p_val)]);
    
    bar(mean(days,1), mean(M1_touch_ITC_mean,1));
    line(mean(days,1), M1_touch_ITC_mean', 'LineWidth', 1) %, 'Color', [.7 .7 .7])
    errorbar(mean(days,1), mean(M1_touch_ITC_mean,1), std(M1_touch_ITC_mean,0,1)/sqrt(length(animals)), std(M1_touch_ITC_mean,0,1)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    if sum(strcmp(animals,'I110')) == 0
        saveas(gcf,[rootpath, '/M1_touch_ITC.fig'])
    end
    hold off
    close all
    
    figure
    hold on
    tbl = array2table(M1_retract_ITC_tbl,'VariableNames',{'data','day','animal'});
    %tbl.day = nominal(tbl.day);
    tbl.animal = nominal(tbl.animal);
    formula = 'data ~ 1 + day + (1 | animal)';
    lme_all = fitlme(tbl,formula);
    p_val = coefTest(lme_all);
    title(['P-val: ', num2str(p_val)]);
    
    bar(mean(days,1), mean(M1_retract_ITC_mean,1));
    line(mean(days,1), M1_retract_ITC_mean', 'LineWidth', 1) %, 'Color', [.7 .7 .7])
    errorbar(mean(days,1), mean(M1_retract_ITC_mean,1), std(M1_retract_ITC_mean,0,1)/sqrt(length(animals)), std(M1_retract_ITC_mean,0,1)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    if sum(strcmp(animals,'I110')) == 0
        saveas(gcf,[rootpath, '/M1_retract_ITC.fig'])
    end
    hold off
    close all
    
    figure
    hold on
    tbl = array2table(Cb_reach_ITC_tbl,'VariableNames',{'data','day','animal'});
    %tbl.day = nominal(tbl.day);
    tbl.animal = nominal(tbl.animal);
    formula = 'data ~ 1 + day + (1 | animal)';
    lme_all = fitlme(tbl,formula);
    p_val = coefTest(lme_all);
    title(['P-val: ', num2str(p_val)]);
    
    bar(mean(days,1), mean(Cb_reach_ITC_mean,1));
    line(mean(days,1), Cb_reach_ITC_mean', 'LineWidth', 1) %, 'Color', [.7 .7 .7])
    errorbar(mean(days,1), mean(Cb_reach_ITC_mean,1), std(Cb_reach_ITC_mean,0,1)/sqrt(length(animals)), std(Cb_reach_ITC_mean,0,1)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    if sum(strcmp(animals,'I089')) == 0
        saveas(gcf,[rootpath, '/Cb_reach_ITC.fig'])
    end
    hold off
    close all
    
    figure
    hold on
    tbl = array2table(Cb_touch_ITC_tbl,'VariableNames',{'data','day','animal'});
    %tbl.day = nominal(tbl.day);
    tbl.animal = nominal(tbl.animal);
    formula = 'data ~ 1 + day + (1 | animal)';
    lme_all = fitlme(tbl,formula);
    p_val = coefTest(lme_all);
    title(['P-val: ', num2str(p_val)]);
    
    bar(mean(days,1), mean(Cb_touch_ITC_mean,1));
    line(mean(days,1), Cb_touch_ITC_mean', 'LineWidth', 1) %, 'Color', [.7 .7 .7])
    errorbar(mean(days,1), mean(Cb_touch_ITC_mean,1), std(Cb_touch_ITC_mean,0,1)/sqrt(length(animals)), std(Cb_touch_ITC_mean,0,1)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    if sum(strcmp(animals,'I089')) == 0
        saveas(gcf,[rootpath, '/Cb_touch_ITC.fig'])
    end
    hold off
    close all
    
    figure
    hold on
    tbl = array2table(Cb_retract_ITC_tbl,'VariableNames',{'data','day','animal'});
    %tbl.day = nominal(tbl.day);
    tbl.animal = nominal(tbl.animal);
    formula = 'data ~ 1 + day + (1 | animal)';
    lme_all = fitlme(tbl,formula);
    p_val = coefTest(lme_all);
    title(['P-val: ', num2str(p_val)]);
    
    bar(mean(days,1), mean(Cb_retract_ITC_mean,1));
    line(mean(days,1), Cb_retract_ITC_mean', 'LineWidth', 1) %, 'Color', [.7 .7 .7])
    errorbar(mean(days,1), mean(Cb_retract_ITC_mean,1), std(Cb_retract_ITC_mean,0,1)/sqrt(length(animals)), std(Cb_retract_ITC_mean,0,1)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    if sum(strcmp(animals,'I089')) == 0
        saveas(gcf,[rootpath, '/Cb_retract_ITC.fig'])
    end
    hold off
    close all
    clearvars -except rootpath origin_rootpath animals enabled animal_data BO_animals;
end
    
%% 5: GPFA Factor Correlation (Lemke supp 12b)

if enabled(5)
    days = [[1;2] [4;5]];
    M1_succ_traj_corr = zeros(length(animals), size(days, 2));
    M1_fail_traj_corr = zeros(length(animals), size(days, 2));
    M1_all_traj_corr = zeros(length(animals), size(days, 2));
    Cb_succ_traj_corr = zeros(length(animals), size(days, 2));
    Cb_fail_traj_corr = zeros(length(animals), size(days, 2));
    Cb_all_traj_corr = zeros(length(animals), size(days, 2));
    
    M1_full_tbl = cell(3,size(days, 2)); %S/F,epoch
    Cb_full_tbl = cell(3,size(days, 2)); %S/F,epoch
    
    animal = zeros(size(M1_succ_traj_corr));
    for animal_idx = 1:length(animals)
        M1_succ_traj_corr(animal_idx,:) = mean(animal_data{animal_idx}.M1_succ_traj_corr(days),1,'omitnan');
        M1_fail_traj_corr(animal_idx,:) = mean(animal_data{animal_idx}.M1_fail_traj_corr(days),1,'omitnan');
        M1_all_traj_corr(animal_idx,:) = mean(animal_data{animal_idx}.M1_all_traj_corr(days),1,'omitnan');
        Cb_succ_traj_corr(animal_idx,:) = mean(animal_data{animal_idx}.Cb_succ_traj_corr(days),1,'omitnan');
        Cb_fail_traj_corr(animal_idx,:) = mean(animal_data{animal_idx}.Cb_fail_traj_corr(days),1,'omitnan');
        Cb_all_traj_corr(animal_idx,:) = mean(animal_data{animal_idx}.Cb_all_traj_corr(days),1,'omitnan');
        
        for epoch = 1:size(days, 2)
            data = animal_data{animal_idx}.M1_succ_traj_corr_full{days(:,epoch)};
            data(:,3) = animal_idx;
            M1_full_tbl{1,epoch} = cat(1,M1_full_tbl{1,epoch},data);
            
            data = animal_data{animal_idx}.M1_fail_traj_corr_full{days(:,epoch)};
            data(:,3) = animal_idx;
            M1_full_tbl{2,epoch} = cat(1,M1_full_tbl{2,epoch},data);
            
            data = animal_data{animal_idx}.M1_all_traj_corr_full{days(:,epoch)};
            data(:,3) = animal_idx;
            M1_full_tbl{3,epoch} = cat(1,M1_full_tbl{3,epoch},data);
            
            data = animal_data{animal_idx}.Cb_succ_traj_corr_full{days(:,epoch)};
            data(:,3) = animal_idx;
            Cb_full_tbl{1,epoch} = cat(1,Cb_full_tbl{1,epoch},data);
            
            data = animal_data{animal_idx}.Cb_fail_traj_corr_full{days(:,epoch)};
            data(:,3) = animal_idx;
            Cb_full_tbl{2,epoch} = cat(1,Cb_full_tbl{2,epoch},data);
            
            data = animal_data{animal_idx}.Cb_all_traj_corr_full{days(:,epoch)};
            data(:,3) = animal_idx;
            Cb_full_tbl{3,epoch} = cat(1,Cb_full_tbl{3,epoch},data);
        end
    end
    
    %M1 Success trials across epoch
    tbl = zeros(0,3);
    for epoch = 1:size(days, 2)
        e_data = M1_full_tbl{1,epoch};
        e_data(:,2) = epoch;
        tbl = [tbl;e_data]; %#ok<AGROW>
    end
    tbl = array2table(tbl,'VariableNames',{'data','relavent_condition','irrelevant_condition'});
    %tbl.relavent_condition = nominal(tbl.relavent_condition);
    tbl.irrelevant_condition = nominal(tbl.irrelevant_condition);
    formula = 'data ~ 1 + relavent_condition + (1 | irrelevant_condition)';
    lme_all = fitlme(tbl,formula);
    p_val = coefTest(lme_all);
        
    figure
    hold on
    line(mean(days,1), M1_succ_traj_corr', 'LineWidth', 1)
    errorbar(mean(days,1), mean(M1_succ_traj_corr,1,'omitnan'), std(M1_succ_traj_corr,0,1,'omitnan')/sqrt(length(animals)), std(M1_succ_traj_corr,0,1,'omitnan')/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    axis([mean(days(:,1))-1 mean(days(:,end))+1 0 1])
    ylabel('Trajectory Correlation');
    title(['P-val: ', num2str(p_val)]);
    if sum(strcmp(animals,'I110')) == 0
        saveas(gcf,[rootpath, '/M1_succ_traj_corr.fig'])
    end
    hold off
    close all
    
    %M1 Fail trials across epoch
    tbl = zeros(0,3);
    for epoch = 1:size(days, 2)
        e_data = M1_full_tbl{2,epoch};
        e_data(:,2) = epoch;
        tbl = [tbl;e_data]; %#ok<AGROW>
    end
    tbl = array2table(tbl,'VariableNames',{'data','relavent_condition','irrelevant_condition'});
    %tbl.relavent_condition = nominal(tbl.relavent_condition);
    tbl.irrelevant_condition = nominal(tbl.irrelevant_condition);
    formula = 'data ~ 1 + relavent_condition + (1 | irrelevant_condition)';
    lme_all = fitlme(tbl,formula);
    p_val = coefTest(lme_all);
    
    figure
    hold on
    line(mean(days,1), M1_fail_traj_corr', 'LineWidth', 1)
    errorbar(mean(days,1), mean(M1_fail_traj_corr,1,'omitnan'), std(M1_fail_traj_corr,0,1,'omitnan')/sqrt(length(animals)), std(M1_fail_traj_corr,0,1,'omitnan')/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    axis([mean(days(:,1))-1 mean(days(:,end))+1 0 1])
    ylabel('Trajectory Correlation');
    title(['P-val: ', num2str(p_val)]);
    if sum(strcmp(animals,'I110')) == 0
        saveas(gcf,[rootpath, '/M1_fail_traj_corr.fig'])
    end
    hold off
    close all
    
    %M1 all trials across epoch
    tbl = zeros(0,3);
    for epoch = 1:size(days, 2)
        e_data = M1_full_tbl{3,epoch};
        e_data(:,2) = epoch;
        tbl = [tbl;e_data]; %#ok<AGROW>
    end
    tbl = array2table(tbl,'VariableNames',{'data','relavent_condition','irrelevant_condition'});
    %tbl.relavent_condition = nominal(tbl.relavent_condition);
    tbl.irrelevant_condition = nominal(tbl.irrelevant_condition);
    formula = 'data ~ 1 + relavent_condition + (1 | irrelevant_condition)';
    lme_all = fitlme(tbl,formula);
    p_val = coefTest(lme_all);
    
    figure
    hold on
    line(mean(days,1), M1_all_traj_corr', 'LineWidth', 1)
    errorbar(mean(days,1), mean(M1_all_traj_corr,1,'omitnan'), std(M1_all_traj_corr,0,1,'omitnan')/sqrt(length(animals)), std(M1_all_traj_corr,0,1,'omitnan')/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    axis([mean(days(:,1))-1 mean(days(:,end))+1 0 1])
    ylabel('Trajectory Correlation');
    title(['P-val: ', num2str(p_val)]);
    if sum(strcmp(animals,'I110')) == 0
        saveas(gcf,[rootpath, '/M1_all_traj_corr.fig'])
    end
    hold off
    close all
    
    %Cb Success trials across epoch
    tbl = zeros(0,3);
    for epoch = 1:size(days, 2)
        e_data = Cb_full_tbl{1,epoch};
        e_data(:,2) = epoch;
        tbl = [tbl;e_data]; %#ok<AGROW>
    end
    tbl = array2table(tbl,'VariableNames',{'data','relavent_condition','irrelevant_condition'});
    %tbl.relavent_condition = nominal(tbl.relavent_condition);
    tbl.irrelevant_condition = nominal(tbl.irrelevant_condition);
    formula = 'data ~ 1 + relavent_condition + (1 | irrelevant_condition)';
    lme_all = fitlme(tbl,formula);
    p_val = coefTest(lme_all);
    
    figure
    hold on
    line(mean(days,1), Cb_succ_traj_corr', 'LineWidth', 1)
    errorbar(mean(days,1), mean(Cb_succ_traj_corr,1,'omitnan'), std(Cb_succ_traj_corr,0,1,'omitnan')/sqrt(length(animals)), std(Cb_succ_traj_corr,0,1,'omitnan')/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    axis([mean(days(:,1))-1 mean(days(:,end))+1 0 1])
    ylabel('Trajectory Correlation');
    title(['P-val: ', num2str(p_val)]);
    if sum(strcmp(animals,'I089')) == 0
        saveas(gcf,[rootpath, '/Cb_succ_traj_corr.fig'])
    end
    hold off
    close all
    
    %Cb Fail trials across epoch
    tbl = zeros(0,3);
    for epoch = 1:size(days, 2)
        e_data = Cb_full_tbl{2,epoch};
        e_data(:,2) = epoch;
        tbl = [tbl;e_data]; %#ok<AGROW>
    end
    tbl = array2table(tbl,'VariableNames',{'data','relavent_condition','irrelevant_condition'});
    %tbl.relavent_condition = nominal(tbl.relavent_condition);
    tbl.irrelevant_condition = nominal(tbl.irrelevant_condition);
    formula = 'data ~ 1 + relavent_condition + (1 | irrelevant_condition)';
    lme_all = fitlme(tbl,formula);
    p_val = coefTest(lme_all);
    
    figure
    hold on
    line(mean(days,1), Cb_fail_traj_corr', 'LineWidth', 1)
    errorbar(mean(days,1), mean(Cb_fail_traj_corr,1,'omitnan'), std(Cb_fail_traj_corr,0,1,'omitnan')/sqrt(length(animals)), std(Cb_fail_traj_corr,0,1,'omitnan')/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    axis([mean(days(:,1))-1 mean(days(:,end))+1 0 1])
    ylabel('Trajectory Correlation');
    title(['P-val: ', num2str(p_val)]);
    if sum(strcmp(animals,'I089')) == 0
        saveas(gcf,[rootpath, '/Cb_fail_traj_corr.fig'])
    end
    hold off
    close all
    
    %Cb all trials across epoch
    tbl = zeros(0,3);
    for epoch = 1:size(days, 2)
        e_data = Cb_full_tbl{3,epoch};
        e_data(:,2) = epoch;
        tbl = [tbl;e_data]; %#ok<AGROW>
    end
    tbl = array2table(tbl,'VariableNames',{'data','relavent_condition','irrelevant_condition'});
    %tbl.relavent_condition = nominal(tbl.relavent_condition);
    tbl.irrelevant_condition = nominal(tbl.irrelevant_condition);
    formula = 'data ~ 1 + relavent_condition + (1 | irrelevant_condition)';
    lme_all = fitlme(tbl,formula);
    p_val = coefTest(lme_all);
    
    figure
    hold on
    line(mean(days,1), Cb_all_traj_corr', 'LineWidth', 1)
    errorbar(mean(days,1), mean(Cb_all_traj_corr,1,'omitnan'), std(Cb_all_traj_corr,0,1,'omitnan')/sqrt(length(animals)), std(Cb_all_traj_corr,0,1,'omitnan')/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    axis([mean(days(:,1))-1 mean(days(:,end))+1 0 1])
    ylabel('Trajectory Correlation');
    title(['P-val: ', num2str(p_val)]);
    if sum(strcmp(animals,'I089')) == 0
        saveas(gcf,[rootpath, '/Cb_all_traj_corr.fig'])
    end
    hold off
    close all
    
    
    for day_idx = 1:size(days,2)
        day = mean(days(:,day_idx),1);

        %M1 Days trials Success vs Fail
        tbl = zeros(0,3);
        for outcome = 1:2
            e_data = M1_full_tbl{outcome,day_idx};
            e_data(:,2) = outcome;
            tbl = [tbl;e_data]; %#ok<AGROW>
        end
        tbl = array2table(tbl,'VariableNames',{'data','relavent_condition','irrelevant_condition'});
        tbl.relavent_condition = nominal(tbl.relavent_condition);
        tbl.irrelevant_condition = nominal(tbl.irrelevant_condition);
        formula = 'data ~ 1 + relavent_condition + (1 | irrelevant_condition)';
        lme_all = fitlme(tbl,formula);
        p_val = coefTest(lme_all);
        
        M1_day_corrs = [M1_succ_traj_corr(:,day_idx)'; M1_fail_traj_corr(:,day_idx)'];
        figure
        hold on
        line([1 2], M1_day_corrs, 'LineWidth', 1)
        errorbar([1 2], mean(M1_day_corrs,2), std(M1_day_corrs,0,2)/sqrt(length(animals)), std(M1_day_corrs,0,2)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
        axis([0.5 2.5 0 1])
        xticks([1 2])
        xticklabels({'Success','Failure'})
        ylabel('Trajectory Correlation');
        title(['P-val: ', num2str(p_val)]);
        if sum(strcmp(animals,'I110')) == 0
            saveas(gcf,[rootpath, '/M1_SvF_traj_corr_day', num2str(day), '.fig'])
        end
        hold off
        close all
        
        %Cb Days trials Success vs Fail
        tbl = zeros(0,3);
        for outcome = 1:2
            e_data = Cb_full_tbl{outcome,day_idx};
            e_data(:,2) = outcome;
            tbl = [tbl;e_data]; %#ok<AGROW>
        end
        tbl = array2table(tbl,'VariableNames',{'data','relavent_condition','irrelevant_condition'});
        tbl.relavent_condition = nominal(tbl.relavent_condition);
        tbl.irrelevant_condition = nominal(tbl.irrelevant_condition);
        formula = 'data ~ 1 + relavent_condition + (1 | irrelevant_condition)';
        lme_all = fitlme(tbl,formula);
        p_val = coefTest(lme_all);
        
        Cb_day_corrs = [Cb_succ_traj_corr(:,day_idx)'; Cb_fail_traj_corr(:,day_idx)'];
        figure
        hold on
        line([1 2], Cb_day_corrs, 'LineWidth', 1)
        errorbar([1 2], mean(Cb_day_corrs,2), std(Cb_day_corrs,0,2)/sqrt(length(animals)), std(Cb_day_corrs,0,2)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
        axis([0.5 2.5 0 1])
        xticks([1 2])
        xticklabels({'Success','Failure'})
        ylabel('Trajectory Correlation');
        title(['P-val: ', num2str(p_val)]);
        if sum(strcmp(animals,'I089')) == 0
            saveas(gcf,[rootpath, '/Cb_SvF_traj_corr_day', num2str(day), '.fig'])
        end
        hold off
        close all
    end
    
    clearvars -except rootpath origin_rootpath animals enabled animal_data BO_animals;
end

%% 6: Velocity Profile Correlation - I076 ONLY (Lemke 2021 Fig 1e)

if enabled(6)
    load([rootpath,'I076/Shared_Data.mat'])
    
    reach_corr = zeros(1,6);
    for day = 1:6
        reach_corr_x = corr(shared_data.reach_mean_velocity{day}(1,:)', shared_data.reach_mean_velocity{6}(1,:)');
        reach_corr_y = corr(shared_data.reach_mean_velocity{day}(2,:)', shared_data.reach_mean_velocity{6}(2,:)');
        reach_corr(day) = mean([reach_corr_x reach_corr_y]);
    end
    plot(reach_corr);
    saveas(gcf,[rootpath, '/Velocity_Correlation.fig'])
    close all
    clearvars -except rootpath origin_rootpath animals enabled animal_data BO_animals;
end

%% 7: Online and Offline coherenece changes (Lemke 2021 Fig 2d)

if enabled(7)
    all_online_coh_changes = [];
    all_offline_coh_changes = [];
    edges = -0.1:0.01:0.1;
    for animal_idx = 1:length(animals)
        load([rootpath,animals{animal_idx},'\online_offline_coh_changes.mat'])
        all_online_coh_changes = [all_online_coh_changes online_coh_changes(:)]; %#ok<AGROW>
        all_offline_coh_changes = [all_offline_coh_changes online_coh_changes(:)]; %#ok<AGROW>
    end
    counts = histcounts(online_coh_changes,edges);
    bar(edges(2:end)-.005,counts);
    saveas(gcf,[rootpath, '/online_coherence.fig'])
    close all
    
    counts = histcounts(offline_coh_changes,edges);
    bar(edges(2:end)-.005,counts);
    saveas(gcf,[rootpath, '/offline_coherence.fig'])
    close all
    clearvars -except rootpath origin_rootpath animals enabled animal_data BO_animals;
end

%% 8: Combined Sorted z-Scored Firing-Rate Heatmaps

if enabled(8)
    map_data = cell(1,4); %Dim1: [M1 increase neurons, M1 decrease neurons, Cb increase neurons, Cb decrease neurons]
    map_idxs = cell(1,4); %Dim1: [M1 increase neurons, M1 decrease neurons, Cb increase neurons, Cb decrease neurons]
    id_strings = ['_M1_increasing'; '_M1_decreasing'; '_Cb_increasing'; '_Cb_decreasing'];
    bin_size = 25; %In miliseconds
    hist_indexes = (-4000+(bin_size/2)):bin_size:(4000-(bin_size/2));
    win_indexes = hist_indexes(logical((hist_indexes <= 1500).*(hist_indexes >= -1000)));
    for day=1:5
        map_data{1} = zeros(0,length(win_indexes));
        map_data{2} = zeros(0,length(win_indexes));
        map_data{3} = zeros(0,length(win_indexes));
        map_data{4} = zeros(0,length(win_indexes));
        
        map_idxs{1} = zeros(0,1);
        map_idxs{2} = zeros(0,1);
        map_idxs{3} = zeros(0,1);
        map_idxs{4} = zeros(0,1);
        for animal_idx = 1:length(animals)
            load([rootpath,animals{animal_idx},'/Day',char(string(day)),'/sorted_firing_rates.mat']);
            
            map_data{1} = cat(1,map_data{1},inc_M1_day_hist_smooth);
            map_data{2} = cat(1,map_data{2},dec_M1_day_hist_smooth);
            map_data{3} = cat(1,map_data{3},inc_Cb_day_hist_smooth);
            map_data{4} = cat(1,map_data{4},dec_Cb_day_hist_smooth);
            
            [~, M1_maxs] = max(inc_M1_day_hist_smooth, [], 2);
            [~, M1_mins] = min(dec_M1_day_hist_smooth, [], 2);
            [~, Cb_maxs] = max(inc_Cb_day_hist_smooth, [], 2);
            [~, Cb_mins] = min(dec_Cb_day_hist_smooth, [], 2);
            
            map_idxs{1} = cat(1,map_idxs{1},M1_maxs);
            map_idxs{2} = cat(1,map_idxs{2},M1_mins);
            map_idxs{3} = cat(1,map_idxs{3},Cb_maxs);
            map_idxs{4} = cat(1,map_idxs{4},Cb_mins);
        end
        
        [~, map_idxs{1}] = sort(map_idxs{1});
        [~, map_idxs{2}] = sort(map_idxs{2});
        [~, map_idxs{3}] = sort(map_idxs{3});
        [~, map_idxs{4}] = sort(map_idxs{4});
        
        map_data{1} = map_data{1}(map_idxs{1},:);
        map_data{2} = map_data{2}(map_idxs{2},:);
        map_data{3} = map_data{3}(map_idxs{3},:);
        map_data{4} = map_data{4}(map_idxs{4},:);
        
        for i=1:4
            if ~(i > 2 && sum(strcmp(animals,'I089')) == 1) && ~(i < 3 && sum(strcmp(animals,'I110')) == 1)
                if isempty(map_data{i})
                    figure
                    title('No Data')
                    saveas(gcf, [rootpath,'/Day',char(string(day)),id_strings(i,:),'_firing_rate.fig']);
                    close all;
                elseif size(map_data{i},1) == 1
                    figure
                    title('Single Data')
                    saveas(gcf, [rootpath,'/Day',char(string(day)),id_strings(i,:),'_firing_rate.fig']);
                    close all;
                else
                    figure
                    pcolor(win_indexes,size(map_data{i},1):-1:1,map_data{i})
                    shading interp
                    caxis([-2 5])
                    colorbar
                    saveas(gcf, [rootpath,'/Day',char(string(day)),id_strings(i,:),'_firing_rate.fig']);
                    close all;
                end
            end
        end
        
    end
    clearvars -except rootpath origin_rootpath animals enabled animal_data BO_animals;
end

%% 9: Reach Trajectory Correlations

if enabled(9)
    days = [[1] [5]];
    x_traj_corr = zeros(length(animals), size(days, 2));
    y_traj_corr = zeros(length(animals), size(days, 2));
    mean_traj_corr = zeros(length(animals), size(days, 2));
    for animal_idx = 1:length(animal_data)
        x_traj_corr(animal_idx,:) = mean(animal_data{animal_idx}.x_trajectory_consistency(days),1);
        y_traj_corr(animal_idx,:) = mean(animal_data{animal_idx}.y_trajectory_consistency(days),1);
        mean_traj_corr(animal_idx,:) = mean((animal_data{animal_idx}.x_trajectory_consistency(days) + animal_data{animal_idx}.y_trajectory_consistency(days))/2,1);
    end
    traj_corr = mean_traj_corr; %change this to plot x, y, or the mean of both.
    
    figure
    hold on
    line(mean(days,1), traj_corr', 'LineWidth', 1) %, 'Color', [.7 .7 .7])
    errorbar(mean(days,1), mean(traj_corr,1), std(traj_corr,0,1)/sqrt(length(animals)), std(traj_corr,0,1)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    axis([mean(days(:,1),1)-2 mean(days(:,end))+2 0 1])
    saveas(gcf,[rootpath, '/Trajectory_Correlations.fig'])
    hold off
    close all
    clearvars -except rootpath origin_rootpath animals enabled animal_data BO_animals;
end

%% 10: Reach Duration with Mixed Effects Test

if enabled(10)
    days = [[1;2] [4;5]];
    animal_times = cell(length(animals),size(days,2));
    animal_times_succ = cell(length(animals),size(days,2));
    animal_times_fail = cell(length(animals),size(days,2));
    rt_mean_reach_durs = nan(length(animals),size(days,2));
    rr_mean_reach_durs = nan(length(animals),size(days,2));
    rt_mean_reach_durs_s = nan(length(animals),size(days,2));
    rr_mean_reach_durs_s = nan(length(animals),size(days,2));
    rt_mean_reach_durs_f = nan(length(animals),size(days,2));
    rr_mean_reach_durs_f = nan(length(animals),size(days,2));
    rt_tbl = zeros(0,3);
    rr_tbl = zeros(0,3);
    rt_tbl_s = zeros(0,3);
    rr_tbl_s = zeros(0,3);
    rt_tbl_f = zeros(0,3);
    rr_tbl_f = zeros(0,3);
    for a = 1:length(animals)
        if a > (length(animals) - length(BO_animals))
            load(['D:\Pierson_Data_Analysis\behavior_only_animals\',animals{a},'/Parameters.mat'])
        else
            load([rootpath,animals{a},'/Parameters.mat'])
        end
        for epoch = 1:size(days,2)
            animal_times{a,epoch} = nan(0,3);
            animal_times_succ{a,epoch} = nan(0,3);
            animal_times_fail{a,epoch} = nan(0,3);
            idx = 0;
            idx_s = 0;
            idx_f = 0;
            for day = days(:,epoch)'
                for block = 1:param.blocks
                    data = animal_data{a}.GUI_data{day,block};
                    for trial = 1:size(data,1)
                        frame_nums = str2num(char(data{trial,2})); %#ok<ST2NM>
                        outcome = str2double(data{trial,3});
                        if outcome == 1
                            reach_onset = frame_nums(end-2);
                            touch = frame_nums(end-1);
                            retract = frame_nums(end);
                            idx_s = idx_s+1;
                            animal_times_succ{a,epoch}(idx_s,:) = [reach_onset/param.Camera_framerate, touch/param.Camera_framerate, retract/param.Camera_framerate];
                        elseif outcome == 0 && frame_nums(end) == 1
                            reach_onset = frame_nums(end-4);
                            touch = frame_nums(end-3);
                            retract = frame_nums(end-1);
                            idx_f = idx_f+1;
                            animal_times_fail{a,epoch}(idx_f,:) = [reach_onset/param.Camera_framerate, touch/param.Camera_framerate, retract/param.Camera_framerate];
                        else
                            continue
                        end
                        idx = idx+1;
                        animal_times{a,epoch}(idx,:) = [reach_onset/param.Camera_framerate, touch/param.Camera_framerate, retract/param.Camera_framerate];
                    end
                end
            end
            rt_data = animal_times{a,epoch}(:,2) - animal_times{a,epoch}(:,1);
            rt_tbl = cat(1, rt_tbl, [rt_data, (ones(length(rt_data),1) * epoch), (ones(length(rt_data),1) * a)]);
            rt_mean_reach_durs(a,epoch) = nanmean(animal_times{a,epoch}(:,2) - animal_times{a,epoch}(:,1));
            
            rr_data = animal_times{a,epoch}(:,3) - animal_times{a,epoch}(:,1);
            rr_tbl = cat(1, rr_tbl, [rr_data, (ones(length(rr_data),1) * epoch), (ones(length(rr_data),1) * a)]);
            rr_mean_reach_durs(a,epoch) = nanmean(animal_times{a,epoch}(:,3) - animal_times{a,epoch}(:,1));
            
            rt_data_s = animal_times_succ{a,epoch}(:,2) - animal_times_succ{a,epoch}(:,1);
            rt_tbl_s = cat(1, rt_tbl_s, [rt_data_s, (ones(length(rt_data_s),1) * epoch), (ones(length(rt_data_s),1) * a)]);
            rt_mean_reach_durs_s(a,epoch) = nanmean(animal_times_succ{a,epoch}(:,2) - animal_times_succ{a,epoch}(:,1));
            
            rr_data_s = animal_times_succ{a,epoch}(:,3) - animal_times_succ{a,epoch}(:,1);
            rr_tbl_s = cat(1, rr_tbl_s, [rr_data_s, (ones(length(rr_data_s),1) * epoch), (ones(length(rr_data_s),1) * a)]);
            rr_mean_reach_durs_s(a,epoch) = nanmean(animal_times_succ{a,epoch}(:,3) - animal_times_succ{a,epoch}(:,1));
            
            rt_data_f = animal_times_fail{a,epoch}(:,2) - animal_times_fail{a,epoch}(:,1);
            rt_tbl_f = cat(1, rt_tbl_f, [rt_data_f, (ones(length(rt_data_f),1) * epoch), (ones(length(rt_data_f),1) * a)]);
            rt_mean_reach_durs_f(a,epoch) = nanmean(animal_times_fail{a,epoch}(:,2) - animal_times_fail{a,epoch}(:,1));
            
            rr_data_f = animal_times_fail{a,epoch}(:,3) - animal_times_fail{a,epoch}(:,1);
            rr_tbl_f = cat(1, rr_tbl_f, [rr_data_f, (ones(length(rr_data_f),1) * epoch), (ones(length(rr_data_f),1) * a)]);
            rr_mean_reach_durs_f(a,epoch) = nanmean(animal_times_fail{a,epoch}(:,3) - animal_times_fail{a,epoch}(:,1));
            
        end
    end
    
    rt_tbl = array2table(rt_tbl,'VariableNames',{'data','Reach_Time','Animal'});
    %rt_tbl.Reach_Time = nominal(rt_tbl.Reach_Time);
    rt_tbl.Animal = nominal(rt_tbl.Animal);
    formula = 'data ~ 1 + Reach_Time + (1 | Animal)';
    lme_all = fitlme(rt_tbl,formula);
    
    figure
    hold on
    bar(mean(days,1), nanmean(rt_mean_reach_durs,1));
    line(mean(days,1), rt_mean_reach_durs', 'LineWidth', 1) %, 'Color', [.7 .7 .7])
    errorbar(mean(days,1), nanmean(rt_mean_reach_durs,1), nanstd(rt_mean_reach_durs,0,1)/sqrt(length(animals)), nanstd(rt_mean_reach_durs,0,1)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    axis([mean(days(:,1),1)-1 mean(days(:,end))+1 0 1.5])
    p_val = coefTest(lme_all);
    title(['P-val: ', num2str(p_val)]);
    saveas(gcf,[rootpath, '/Reach_Touch_Durations_bad.fig'])
    hold off
    close all
    
    rr_tbl = array2table(rr_tbl,'VariableNames',{'data','Reach_Time','Animal'});
    %rr_tbl.Reach_Time = nominal(rr_tbl.Reach_Time);
    rr_tbl.Animal = nominal(rr_tbl.Animal);
    formula = 'data ~ 1 + Reach_Time + (1 | Animal)';
    lme_all = fitlme(rr_tbl,formula);
    
    figure
    hold on
    bar(mean(days,1), nanmean(rr_mean_reach_durs,1));
    line(mean(days,1), rr_mean_reach_durs', 'LineWidth', 1) %, 'Color', [.7 .7 .7])
    errorbar(mean(days,1), nanmean(rr_mean_reach_durs,1), nanstd(rr_mean_reach_durs,0,1)/sqrt(length(animals)), nanstd(rr_mean_reach_durs,0,1)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    axis([mean(days(:,1),1)-1 mean(days(:,end))+1 0 1.5])
    p_val = coefTest(lme_all);
    title(['P-val: ', num2str(p_val)]);
    saveas(gcf,[rootpath, '/Reach_Retract_Durations_bad.fig'])
    hold off
    close all
    
    
    rt_tbl_s = array2table(rt_tbl_s,'VariableNames',{'data','Reach_Time','Animal'});
    %rt_tbl_s.Reach_Time = nominal(rt_tbl_s.Reach_Time);
    rt_tbl_s.Animal = nominal(rt_tbl_s.Animal);
    formula = 'data ~ 1 + Reach_Time + (1 | Animal)';
    lme_all = fitlme(rt_tbl_s,formula);
    
    figure
    hold on
    bar(mean(days,1), nanmean(rt_mean_reach_durs_s,1));
    line(mean(days,1), rt_mean_reach_durs_s', 'LineWidth', 1) %, 'Color', [.7 .7 .7])
    errorbar(mean(days,1), nanmean(rt_mean_reach_durs_s,1), nanstd(rt_mean_reach_durs_s,0,1)/sqrt(length(animals)), nanstd(rt_mean_reach_durs_s,0,1)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    axis([mean(days(:,1),1)-1 mean(days(:,end))+1 0 1.5])
    p_val = coefTest(lme_all);
    title(['P-val: ', num2str(p_val)]);
    saveas(gcf,[rootpath, '/Reach_Touch_Durations_succ_bad.fig'])
    hold off
    close all
    
    rr_tbl_s = array2table(rr_tbl_s,'VariableNames',{'data','Reach_Time','Animal'});
    %rr_tbl_s.Reach_Time = nominal(rr_tbl_s.Reach_Time);
    rr_tbl_s.Animal = nominal(rr_tbl_s.Animal);
    formula = 'data ~ 1 + Reach_Time + (1 | Animal)';
    lme_all = fitlme(rr_tbl_s,formula);
    
    figure
    hold on
    bar(mean(days,1), nanmean(rr_mean_reach_durs_s,1));
    line(mean(days,1), rr_mean_reach_durs_s', 'LineWidth', 1) %, 'Color', [.7 .7 .7])
    errorbar(mean(days,1), nanmean(rr_mean_reach_durs_s,1), nanstd(rr_mean_reach_durs_s,0,1)/sqrt(length(animals)), nanstd(rr_mean_reach_durs_s,0,1)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    axis([mean(days(:,1),1)-1 mean(days(:,end))+1 0 1.5])
    p_val = coefTest(lme_all);
    title(['P-val: ', num2str(p_val)]);
    saveas(gcf,[rootpath, '/Reach_Retract_Durations_succ_bad.fig'])
    hold off
    close all
    
    
    rt_tbl_f = array2table(rt_tbl_f,'VariableNames',{'data','Reach_Time','Animal'});
    %rt_tbl_f.Reach_Time = nominal(rt_tbl_f.Reach_Time);
    rt_tbl_f.Animal = nominal(rt_tbl_f.Animal);
    formula = 'data ~ 1 + Reach_Time + (1 | Animal)';
    lme_all = fitlme(rt_tbl_f,formula);
    
    figure
    hold on
    bar(mean(days,1), nanmean(rt_mean_reach_durs_f,1));
    line(mean(days,1), rt_mean_reach_durs_f', 'LineWidth', 1) %, 'Color', [.7 .7 .7])
    errorbar(mean(days,1), nanmean(rt_mean_reach_durs_f,1), nanstd(rt_mean_reach_durs_f,0,1)/sqrt(length(animals)), nanstd(rt_mean_reach_durs_f,0,1)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    axis([mean(days(:,1),1)-1 mean(days(:,end))+1 0 1.5])
    p_val = coefTest(lme_all);
    title(['P-val: ', num2str(p_val)]);
    saveas(gcf,[rootpath, '/Reach_Touch_Durations_fail_bad.fig'])
    hold off
    close all
    
    rr_tbl_f = array2table(rr_tbl_f,'VariableNames',{'data','Reach_Time','Animal'});
    %rr_tbl_f.Reach_Time = nominal(rr_tbl_f.Reach_Time);
    rr_tbl_f.Animal = nominal(rr_tbl_f.Animal);
    formula = 'data ~ 1 + Reach_Time + (1 | Animal)';
    lme_all = fitlme(rr_tbl_f,formula);
    
    figure
    hold on
    bar(mean(days,1), nanmean(rr_mean_reach_durs_f,1));
    line(mean(days,1), rr_mean_reach_durs_f', 'LineWidth', 1) %, 'Color', [.7 .7 .7])
    errorbar(mean(days,1), nanmean(rr_mean_reach_durs_f,1), nanstd(rr_mean_reach_durs_f,0,1)/sqrt(length(animals)), nanstd(rr_mean_reach_durs_f,0,1)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    axis([mean(days(:,1),1)-1 mean(days(:,end))+1 0 1.5])
    p_val = coefTest(lme_all);
    title(['P-val: ', num2str(p_val)]);
    saveas(gcf,[rootpath, '/Reach_Retract_Durations_fail_bad.fig'])
    hold off
    close all
    
    clearvars -except rootpath origin_rootpath animals enabled animal_data BO_animals;
end

%% 11: Spike-phase CDF

if enabled(11)
    
    days = [[1] [5]];
    days_SvF = [5];
    
    pairs_dispname = ['M1Ch-M1Nrn'; 'M1Ch-CbNrn'; 'CbCh-M1Nrn'; 'CbCh-CbNrn'];
    pairs_varname = ['M1Ch_M1Nrn'; 'M1Ch_CbNrn'; 'CbCh_M1Nrn'; 'CbCh_CbNrn'];
    edge_exp = -5:0.1:5;
    edges = exp(edge_exp);
    bin_centers = (diff(edges)/2) + edges(1:end-1);
    color_grad = [[0:1/(size(days,2)-1):1]', zeros(size(days,2),1), [1:-1/(size(days,2)-1):0]'];
    for pair = 1:4
        figure
        all_Zs_cell = cell(1,size(days,2));
        percents = nan(1,size(days,2));
        title_string = pairs_dispname(pair,:);
        for epoch = 1:size(days,2)
            all_z_counts = zeros(1,length(edges)-1);
            all_Zs = zeros(1,0);
            for a = 1:length(animals)
                spike_Zs = eval(['animal_data{a}.spike_phase_data.',pairs_varname(pair,:),'_stats{days(:,epoch)}']);
                if isempty(spike_Zs)
                    spike_Zs = nan(2,0);
                end
                spike_Zs = spike_Zs(1,:);
                [z_counts, ~] = histcounts(spike_Zs,edges);
                all_z_counts = all_z_counts + z_counts;
                all_Zs = [all_Zs, spike_Zs]; %#ok<AGROW>
            end
            all_Zs_cell{epoch} = all_Zs;
            cum_count = cumsum(all_z_counts);
            z_ratio_cum = cum_count/length(all_Zs);
            line(bin_centers,z_ratio_cum','Color',color_grad(epoch,:));
            percents(epoch) = (1-z_ratio_cum(find(edges > 3, 1)-1))*100;
            title_string = [title_string, ', E', num2str(epoch), ': ', num2str(percents(epoch)), '%']; %#ok<AGROW>
        end
        all_P_scores = zeros(1,0);
        for epoch1 = 1:size(days,2)
            for epoch2 = (epoch1+1):size(days,2)
                [~, p_score] = kstest2(all_Zs_cell{epoch1}, all_Zs_cell{epoch2});
                all_P_scores = [all_P_scores, p_score]; %#ok<AGROW>
            end
        end
        title_string = [title_string, ', P:',num2str(mean(all_P_scores))]; %#ok<AGROW>
        title(title_string);
        line([3 3], [0 1], 'Color', [0 0 0], 'LineStyle','--');
        set(gca, 'XScale', 'log')
        xlim([bin_centers(1) bin_centers(end)])
        if pair == 1 || (sum(strcmp(animals,'I089')) == 0 && sum(strcmp(animals,'I110')) == 0) || (pair == 1 && sum(strcmp(animals,'I110')) == 0) || (pair == 4 && sum(strcmp(animals,'I089')) == 0)
            saveas(gcf,[rootpath,'/Phase_non-uniformity_cdf_', pairs_dispname(pair,:), '.fig']);
        end
        close all;
        
        for epoch = 1:size(days_SvF,2)
            all_Z_counts_succ = zeros(1,length(edges)-1);
            all_Zs_succ = zeros(1,0);
            all_Z_counts_fail = zeros(1,length(edges)-1);
            all_Zs_fail = zeros(1,0);
            for a = 1:length(animals)
                spike_Zs = eval(['animal_data{a}.spike_phase_data.',pairs_varname(pair,:),'_stats_succ{days_SvF(:,epoch)}']);
                if isempty(spike_Zs)
                    spike_Zs = nan(2,0);
                end
                spike_Zs = spike_Zs(1,:);
                [z_counts, ~] = histcounts(spike_Zs,edges);
                all_Z_counts_succ = all_Z_counts_succ + z_counts;
                all_Zs_succ = [all_Zs_succ, spike_Zs]; %#ok<AGROW>
                
                spike_Zs = eval(['animal_data{a}.spike_phase_data.',pairs_varname(pair,:),'_stats_fail{days_SvF(:,epoch)}']);
                if isempty(spike_Zs)
                    spike_Zs = nan(2,0);
                end
                spike_Zs = spike_Zs(1,:);
                [z_counts, ~] = histcounts(spike_Zs,edges);
                all_Z_counts_fail = all_Z_counts_fail + z_counts;
                all_Zs_fail = [all_Zs_fail, spike_Zs]; %#ok<AGROW>
            end
            figure
            
            cum_count = cumsum(all_Z_counts_succ);
            z_ratio_cum = cum_count/length(all_Zs_succ);
            line(bin_centers,z_ratio_cum','Color',[0, 0, 1]);
            succ_percent = (1-z_ratio_cum(find(edges > 3, 1)-1))*100;
            
            cum_count = cumsum(all_Z_counts_fail);
            z_ratio_cum = cum_count/length(all_Zs_fail);
            line(bin_centers,z_ratio_cum','Color',[1, 0, 0]);
            fail_percent = (1-z_ratio_cum(find(edges > 3, 1)-1))*100;
            
            [~, p_score] = kstest2(all_Zs_succ, all_Zs_fail);
            title([pairs_dispname(pair,:), ', S: ', num2str(succ_percent), '%, F: ', num2str(fail_percent), '%, P:',num2str(p_score)]);
            
            line([3 3], [0 1], 'Color', [0 0 0], 'LineStyle','--');
            set(gca, 'XScale', 'log')
            xlim([bin_centers(1) bin_centers(end)])
            if pair == 1 || (sum(strcmp(animals,'I089')) == 0 && sum(strcmp(animals,'I110')) == 0) || (pair == 1 && sum(strcmp(animals,'I110')) == 0) || (pair == 4 && sum(strcmp(animals,'I089')) == 0)
                saveas(gcf,[rootpath,'/Phase_non-uniformity_cdf_day', num2str(mean(days_SvF(:,epoch))), '_', pairs_dispname(pair,:), '_SvF.fig']);
            end
            close all;
        end
    end
    clearvars -except rootpath origin_rootpath animals enabled animal_data BO_animals;
end

%% 12: Neural Activity Template Correlation 

if enabled(12)
    days = [[1;2] [4;5]];
    M1_mean_animal_corrs = nan(length(animals), size(days,2));
    Cb_mean_animal_corrs = nan(length(animals), size(days,2));
    M1_all_trial_corrs = cell(1,size(days,1));
    Cb_all_trial_corrs = cell(1,size(days,1));
    M1_tbl = zeros(0,3);
    Cb_tbl = zeros(0,3);
    for epoch = 1:size(days,2)
        for a = 1:length(animals)
            M1_corrs = [animal_data{a}.M1_neuron_activity_template_correlation{days(:,epoch)}];
            Cb_corrs = [animal_data{a}.Cb_neuron_activity_template_correlation{days(:,epoch)}];
            M1_mean_animal_corrs(a,epoch) = mean(M1_corrs);
            Cb_mean_animal_corrs(a,epoch) = mean(Cb_corrs);
            M1_all_trial_corrs{epoch} = cat(2,M1_all_trial_corrs{epoch},M1_corrs);
            Cb_all_trial_corrs{epoch} = cat(2,Cb_all_trial_corrs{epoch},Cb_corrs);
            M1_tbl = cat(1, M1_tbl, [M1_corrs', (ones(length(M1_corrs),1) * epoch), (ones(length(M1_corrs),1) * a)]);
            Cb_tbl = cat(1, Cb_tbl, [Cb_corrs', (ones(length(Cb_corrs),1) * epoch), (ones(length(Cb_corrs),1) * a)]);
        end
    end
    
    figure
    hold on
    M1_tbl = array2table(M1_tbl,'VariableNames',{'data','Reach_Time','Animal'});
    %M1_tbl.Reach_Time = nominal(M1_tbl.Reach_Time);
    M1_tbl.Animal = nominal(M1_tbl.Animal);
    formula = 'data ~ 1 + Reach_Time + (1 | Animal)';
    lme_all = fitlme(M1_tbl,formula);
    p_val = coefTest(lme_all);
    title(['P-val: ', num2str(p_val)]);
    
    bar(mean(days,1),cellfun(@mean,M1_all_trial_corrs));
    line(mean(days,1), M1_mean_animal_corrs', 'LineWidth', 1) %, 'Color', [.7 .7 .7])
    errorbar(mean(days,1), cellfun(@mean,M1_all_trial_corrs), cellfun(@std,M1_all_trial_corrs)./sqrt(cellfun(@length,M1_all_trial_corrs)), cellfun(@std,M1_all_trial_corrs)./sqrt(cellfun(@length,M1_all_trial_corrs)), 'Color', [0 0 0], 'LineWidth', 2);
    axis([mean(days(:,1),1)-1 mean(days(:,end))+1 0 0.6])
    if sum(strcmp(animals,'I110')) == 0
        saveas(gcf,[rootpath, '/Template_Match_M1_all.fig'])
    end
    hold off
    close all
    
    figure
    hold on
    Cb_tbl = array2table(Cb_tbl,'VariableNames',{'data','Reach_Time','Animal'});
    %Cb_tbl.Reach_Time = nominal(Cb_tbl.Reach_Time);
    Cb_tbl.Animal = nominal(Cb_tbl.Animal);
    formula = 'data ~ 1 + Reach_Time + (1 | Animal)';
    lme_all = fitlme(Cb_tbl,formula);
    p_val = coefTest(lme_all);
    title(['P-val: ', num2str(p_val)]);
    
    bar(mean(days,1),cellfun(@mean,Cb_all_trial_corrs));
    line(mean(days,1), Cb_mean_animal_corrs', 'LineWidth', 1) %, 'Color', [.7 .7 .7])
    errorbar(mean(days,1), cellfun(@mean,Cb_all_trial_corrs), cellfun(@std,Cb_all_trial_corrs)./sqrt(cellfun(@length,Cb_all_trial_corrs)), cellfun(@std,Cb_all_trial_corrs)./sqrt(cellfun(@length,Cb_all_trial_corrs)), 'Color', [0 0 0], 'LineWidth', 2);
    axis([mean(days(:,1),1)-1 mean(days(:,end))+1 0 0.6])
    if sum(strcmp(animals,'I089')) == 0
        saveas(gcf,[rootpath, '/Template_Match_Cb_all.fig'])
    end
    hold off
    close all
    clearvars -except rootpath origin_rootpath animals enabled animal_data BO_animals;
end

%% 13: Mean event-centered LFPs across all trials and channels

if enabled(13)
    addpath(genpath('Z:\Matlab for analysis'))
    days = [[1] [5]];
    M1_trial_snapshots = cell(3,size(days,2));
    Cb_trial_snapshots = cell(3,size(days,2));
    for epoch = 1:size(days,2)
        for day = days(:,epoch)
            for a = 1:length(animals)
                split_temp = num2cell(animal_data{a}.M1_reach_filt_LFPs{day}, [1 2]);
                trial_list = vertcat(split_temp{:});
                M1_trial_snapshots{1,epoch} = cat(1, M1_trial_snapshots{1,epoch}, trial_list);
                
                split_temp = num2cell(animal_data{a}.M1_touch_filt_LFPs{day}, [1 2]);
                trial_list = vertcat(split_temp{:});
                M1_trial_snapshots{2,epoch} = cat(1, M1_trial_snapshots{2,epoch}, trial_list);
                
                split_temp = num2cell(animal_data{a}.M1_retract_filt_LFPs{day}, [1 2]);
                trial_list = vertcat(split_temp{:});
                M1_trial_snapshots{3,epoch} = cat(1, M1_trial_snapshots{3,epoch}, trial_list);
                
                split_temp = num2cell(animal_data{a}.Cb_reach_filt_LFPs{day}, [1 2]);
                trial_list = vertcat(split_temp{:});
                Cb_trial_snapshots{1,epoch} = cat(1, Cb_trial_snapshots{1,epoch}, trial_list);
                
                split_temp = num2cell(animal_data{a}.Cb_touch_filt_LFPs{day}, [1 2]);
                trial_list = vertcat(split_temp{:});
                Cb_trial_snapshots{2,epoch} = cat(1, Cb_trial_snapshots{2,epoch}, trial_list);
                
                split_temp = num2cell(animal_data{a}.Cb_retract_filt_LFPs{day}, [1 2]);
                trial_list = vertcat(split_temp{:});
                Cb_trial_snapshots{3,epoch} = cat(1, Cb_trial_snapshots{3,epoch}, trial_list);
            end
        end
        
    end
    
    M1_plot_x = -762:763;
    Cb_plot_x = -762:763;
    
    if sum(strcmp(animals,'I110')) == 0
        shadedErrorBar(M1_plot_x, mean(M1_trial_snapshots{1,1},1), [mean(M1_trial_snapshots{1,1},1) + (std(M1_trial_snapshots{1,1},0,1)/sqrt(size(M1_trial_snapshots{1,1},1))); mean(M1_trial_snapshots{1,1},1) - (std(M1_trial_snapshots{1,1},0,1)/sqrt(size(M1_trial_snapshots{1,1},1)))],'r-');
        line([0,0],[-0.08,0.08], 'Color', 'green', 'LineWidth', 1, 'LineStyle', '--')
        saveas(gcf,[rootpath, '/Mean_reach_LFP_M1_D1.fig'])
        close all
        
        shadedErrorBar(M1_plot_x, mean(M1_trial_snapshots{2,1},1), [mean(M1_trial_snapshots{2,1},1) + (std(M1_trial_snapshots{2,1},0,1)/sqrt(size(M1_trial_snapshots{2,1},1))); mean(M1_trial_snapshots{2,1},1) - (std(M1_trial_snapshots{2,1},0,1)/sqrt(size(M1_trial_snapshots{2,1},1)))],'r-');
        line([0,0],[-0.08,0.08], 'Color', 'blue', 'LineWidth', 1, 'LineStyle', '--')
        saveas(gcf,[rootpath, '/Mean_touch_LFP_M1_D1.fig'])
        close all
        
        shadedErrorBar(M1_plot_x, mean(M1_trial_snapshots{3,1},1), [mean(M1_trial_snapshots{3,1},1) + (std(M1_trial_snapshots{3,1},0,1)/sqrt(size(M1_trial_snapshots{3,1},1))); mean(M1_trial_snapshots{3,1},1) - (std(M1_trial_snapshots{3,1},0,1)/sqrt(size(M1_trial_snapshots{3,1},1)))],'r-');
        line([0,0],[-0.08,0.08], 'Color', 'black', 'LineWidth', 1, 'LineStyle', '--')
        saveas(gcf,[rootpath, '/Mean_retract_LFP_M1_D1.fig'])
        close all
        
        shadedErrorBar(M1_plot_x, mean(M1_trial_snapshots{1,2},1), [mean(M1_trial_snapshots{1,2},1) + (std(M1_trial_snapshots{1,2},0,1)/sqrt(size(M1_trial_snapshots{1,2},1))); mean(M1_trial_snapshots{1,2},1) - (std(M1_trial_snapshots{1,2},0,1)/sqrt(size(M1_trial_snapshots{1,2},1)))],'r-');
        line([0,0],[-0.08,0.08], 'Color', 'green', 'LineWidth', 1, 'LineStyle', '--')
        saveas(gcf,[rootpath, '/Mean_reach_LFP_M1_D5.fig'])
        close all
        
        shadedErrorBar(M1_plot_x, mean(M1_trial_snapshots{2,2},1), [mean(M1_trial_snapshots{2,2},1) + (std(M1_trial_snapshots{2,2},0,1)/sqrt(size(M1_trial_snapshots{2,2},1))); mean(M1_trial_snapshots{2,2},1) - (std(M1_trial_snapshots{2,2},0,1)/sqrt(size(M1_trial_snapshots{2,2},1)))],'r-');
        line([0,0],[-0.08,0.08], 'Color', 'blue', 'LineWidth', 1, 'LineStyle', '--')
        saveas(gcf,[rootpath, '/Mean_touch_LFP_M1_D5.fig'])
        close all
        
        shadedErrorBar(M1_plot_x, mean(M1_trial_snapshots{3,2},1), [mean(M1_trial_snapshots{3,2},1) + (std(M1_trial_snapshots{3,2},0,1)/sqrt(size(M1_trial_snapshots{3,2},1))); mean(M1_trial_snapshots{3,2},1) - (std(M1_trial_snapshots{3,2},0,1)/sqrt(size(M1_trial_snapshots{3,2},1)))],'r-');
        line([0,0],[-0.08,0.08], 'Color', 'black', 'LineWidth', 1, 'LineStyle', '--')
        saveas(gcf,[rootpath, '/Mean_retract_LFP_M1_D5.fig'])
        close all
    end
    
    if sum(strcmp(animals,'I089')) == 0
        shadedErrorBar(Cb_plot_x, mean(Cb_trial_snapshots{1,1},1), [mean(Cb_trial_snapshots{1,1},1) + (std(Cb_trial_snapshots{1,1},0,1)/sqrt(size(Cb_trial_snapshots{1,1},1))); mean(Cb_trial_snapshots{1,1},1) - (std(Cb_trial_snapshots{1,1},0,1)/sqrt(size(Cb_trial_snapshots{1,1},1)))],'g-');
        line([0,0],[-0.08,0.08], 'Color', 'green', 'LineWidth', 1, 'LineStyle', '--')
        saveas(gcf,[rootpath, '/Mean_reach_LFP_Cb_D1.fig'])
        close all
        
        shadedErrorBar(Cb_plot_x, mean(Cb_trial_snapshots{2,1},1), [mean(Cb_trial_snapshots{2,1},1) + (std(Cb_trial_snapshots{2,1},0,1)/sqrt(size(Cb_trial_snapshots{2,1},1))); mean(Cb_trial_snapshots{2,1},1) - (std(Cb_trial_snapshots{2,1},0,1)/sqrt(size(Cb_trial_snapshots{2,1},1)))],'g-');
        line([0,0],[-0.08,0.08], 'Color', 'blue', 'LineWidth', 1, 'LineStyle', '--')
        saveas(gcf,[rootpath, '/Mean_touch_LFP_Cb_D1.fig'])
        close all
        
        shadedErrorBar(Cb_plot_x, mean(Cb_trial_snapshots{3,1},1), [mean(Cb_trial_snapshots{3,1},1) + (std(Cb_trial_snapshots{3,1},0,1)/sqrt(size(Cb_trial_snapshots{3,1},1))); mean(Cb_trial_snapshots{3,1},1) - (std(Cb_trial_snapshots{3,1},0,1)/sqrt(size(Cb_trial_snapshots{3,1},1)))],'g-');
        line([0,0],[-0.08,0.08], 'Color', 'black', 'LineWidth', 1, 'LineStyle', '--')
        saveas(gcf,[rootpath, '/Mean_retract_LFP_Cb_D1.fig'])
        close all
        
        shadedErrorBar(Cb_plot_x, mean(Cb_trial_snapshots{1,2},1), [mean(Cb_trial_snapshots{1,2},1) + (std(Cb_trial_snapshots{1,2},0,1)/sqrt(size(Cb_trial_snapshots{1,2},1))); mean(Cb_trial_snapshots{1,2},1) - (std(Cb_trial_snapshots{1,2},0,1)/sqrt(size(Cb_trial_snapshots{1,2},1)))],'g-');
        line([0,0],[-0.08,0.08], 'Color', 'green', 'LineWidth', 1, 'LineStyle', '--')
        saveas(gcf,[rootpath, '/Mean_reach_LFP_Cb_D5.fig'])
        close all
        
        shadedErrorBar(Cb_plot_x, mean(Cb_trial_snapshots{2,2},1), [mean(Cb_trial_snapshots{2,2},1) + (std(Cb_trial_snapshots{2,2},0,1)/sqrt(size(Cb_trial_snapshots{2,2},1))); mean(Cb_trial_snapshots{2,2},1) - (std(Cb_trial_snapshots{2,2},0,1)/sqrt(size(Cb_trial_snapshots{2,2},1)))],'g-');
        line([0,0],[-0.08,0.08], 'Color', 'blue', 'LineWidth', 1, 'LineStyle', '--')
        saveas(gcf,[rootpath, '/Mean_touch_LFP_Cb_D5.fig'])
        close all
        
        shadedErrorBar(Cb_plot_x, mean(Cb_trial_snapshots{3,2},1), [mean(Cb_trial_snapshots{3,2},1) + (std(Cb_trial_snapshots{3,2},0,1)/sqrt(size(Cb_trial_snapshots{3,2},1))); mean(Cb_trial_snapshots{3,2},1) - (std(Cb_trial_snapshots{3,2},0,1)/sqrt(size(Cb_trial_snapshots{3,2},1)))],'g-');
        line([0,0],[-0.08,0.08], 'Color', 'black', 'LineWidth', 1, 'LineStyle', '--')
        saveas(gcf,[rootpath, '/Mean_retract_LFP_Cb_D5.fig'])
        close all
    end
    rmpath(genpath('Z:\Matlab for analysis'))
    clearvars -except rootpath origin_rootpath animals enabled animal_data BO_animals;
end

%% 14: Canonical Correlation Graphs

if enabled(14)
    days = [[1;2] [4;5]];
    x_vals = nan(1,prod([length(animals) size(days,2)]));
    y_vals = nan(size(x_vals));
    animal_label = nan(size(x_vals));
    i = 1;
    for a = 1:length(animals)
        start = i;
        for epoch = 1:size(days,2)
            M1_subspace_activity = nan(1,0);
            Cb_subspace_activity = nan(1,0);
            for day = (days(:,epoch))'
                M1_subspace_activity = [M1_subspace_activity; animal_data{a}.M1_subspace_activity{day}]; %#ok<AGROW>
                Cb_subspace_activity = [Cb_subspace_activity; animal_data{a}.Cb_subspace_activity{day}]; %#ok<AGROW>
            end

            %Check for skiped days
            if isempty(M1_subspace_activity)
                x_vals(i) = [];
                y_vals(i) = [];
                animal_label(i) = [];
            else
                x_vals(i) = mean(days(:,epoch));
                y_vals(i) = corr(M1_subspace_activity, Cb_subspace_activity);
                animal_label(i) = a;
                i = i+1;
            end
        end
        y_vals(start:(i-1)) = y_vals(start:(i-1))-mean(y_vals(start:(i-1)));
        %y_vals(start:(i-1)) = y_vals(start:(i-1))/std(y_vals(start:(i-1)));
    end
    b1 = (x_vals')\(y_vals');
    liney = b1*x_vals;
    figure
    hold on
    for a = 1:length(animals)
        scatter(x_vals(animal_label == a), y_vals(animal_label == a), 10, 'filled')
    end
    plot(x_vals, liney);
    if sum(strcmp(animals,'I089')) == 0 && sum(strcmp(animals,'I110')) == 0
        saveas(gcf,[rootpath, '/Canonical_Correlation.fig'])
    end
    hold off
    close all
    clearvars -except rootpath origin_rootpath animals enabled animal_data BO_animals;
end

%% 15: Nueral Decoding R^2

if enabled(15)
    days = [1:5];
    SvF_days = [5];
    
    M1_data = nan(length(animals),size(days,2));
    Cb_data = nan(length(animals),size(days,2));
    comb_data = nan(length(animals),size(days,2));
    M1_tbl = zeros(0,3);
    Cb_tbl = zeros(0,3);
    comb_tbl = zeros(0,3);
    for epoch = 1:size(days,2)
        for a = 1:length(animals)
            data = animal_data{a}.M1_r2s(days(:,epoch));
            M1_data(a,epoch) = mean(data);
            M1_tbl = cat(1, M1_tbl, [data, (ones(length(data),1) * epoch), (ones(length(data),1) * a)]);
            
            data = animal_data{a}.Cb_r2s(days(:,epoch));
            Cb_data(a,epoch) = mean(data);
            Cb_tbl = cat(1, Cb_tbl, [data, (ones(length(data),1) * epoch), (ones(length(data),1) * a)]);
            
            data = animal_data{a}.comb_r2s(days(:,epoch));
            comb_data(a,epoch) = mean(data);
            comb_tbl = cat(1, comb_tbl, [data, (ones(length(data),1) * epoch), (ones(length(data),1) * a)]);
        end
    end
    
    figure
    hold on
    M1_tbl = array2table(M1_tbl,'VariableNames',{'data','Epoch','Animal'});
    %M1_tbl.Epoch = nominal(M1_tbl.Epoch);
    M1_tbl.Animal = nominal(M1_tbl.Animal);
    formula = 'data ~ 1 + Epoch + (1 | Animal)';
    lme_all = fitlme(M1_tbl,formula);
    p_val = coefTest(lme_all);
    title(['P-val: ', num2str(p_val)]);
    
    x = ones(length(animals), size(days,2));
    x = x .* (1:size(days,2));
    for i = 1:size(x,1)
        scatter(x(i,:),M1_data(i,:),'filled');
    end
    y = ((lme_all.Coefficients(2,2).Estimate)*(1:size(days,2)))+(lme_all.Coefficients(1,2).Estimate);
    plot(x,y)
    %axis([mean(days(:,1),1)-1 mean(days(:,end))+1 0 0.6])
    if sum(strcmp(animals,'I110')) == 0
        saveas(gcf,[rootpath, '/Neural_Decoding_M1_scatter.fig'])
    end
    hold off
    close all
    
%     bar(mean(days,1),mean(M1_data,1));
%     line(mean(days,1), mean(M1_data,1), 'LineWidth', 1) %, 'Color', [.7 .7 .7])
%     errorbar(mean(days,1), mean(M1_data,1), std(M1_data,0,1)./sqrt(length(animals)), std(M1_data,0,1)./sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
%     %axis([mean(days(:,1),1)-1 mean(days(:,end))+1 0 0.6])
%     saveas(gcf,[rootpath, '/Neural_Decoding_M1.fig'])
%     hold off
%     close all
    
    figure
    hold on
    Cb_tbl = array2table(Cb_tbl,'VariableNames',{'data','Epoch','Animal'});
    %Cb_tbl.Epoch = nominal(Cb_tbl.Epoch);
    Cb_tbl.Animal = nominal(Cb_tbl.Animal);
    formula = 'data ~ 1 + Epoch + (1 | Animal)';
    lme_all = fitlme(Cb_tbl,formula);
    p_val = coefTest(lme_all);
    title(['P-val: ', num2str(p_val)]);
    
    x = ones(length(animals), size(days,2));
    x = x .* (1:size(days,2));
    for i = 1:size(x,1)
        scatter(x(i,:),Cb_data(i,:),'filled');
    end
    y = ((lme_all.Coefficients(2,2).Estimate)*(1:size(days,2)))+(lme_all.Coefficients(1,2).Estimate);
    plot(x,y)
    %axis([mean(days(:,1),1)-1 mean(days(:,end))+1 0 0.6])
    if sum(strcmp(animals,'I089')) == 0
        saveas(gcf,[rootpath, '/Neural_Decoding_Cb_scatter.fig'])
    end
    hold off
    close all
    
%     bar(mean(days,1),mean(Cb_data,1));
%     line(mean(days,1), mean(Cb_data,1), 'LineWidth', 1) %, 'Color', [.7 .7 .7])
%     errorbar(mean(days,1), mean(Cb_data,1), std(Cb_data,0,1)./sqrt(length(animals)), std(Cb_data,0,1)./sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
%     %axis([mean(days(:,1),1)-1 mean(days(:,end))+1 0 0.6])
%     if sum(strcmp(animals,'I089')) == 0
%         saveas(gcf,[rootpath, '/Neural_Decoding_Cb.fig'])
%     end
%     hold off
%     close all

    figure
    hold on
    comb_tbl = array2table(comb_tbl,'VariableNames',{'data','Epoch','Animal'});
    %comb_tbl.Epoch = nominal(comb_tbl.Epoch);
    comb_tbl.Animal = nominal(comb_tbl.Animal);
    formula = 'data ~ 1 + Epoch + (1 | Animal)';
    lme_all = fitlme(comb_tbl,formula);
    p_val = coefTest(lme_all);
    title(['P-val: ', num2str(p_val)]);
    
    x = ones(length(animals), size(days,2));
    x = x .* (1:size(days,2));
    for i = 1:size(x,1)
        scatter(x(i,:),comb_data(i,:),'filled');
    end
    y = ((lme_all.Coefficients(2,2).Estimate)*(1:size(days,2)))+(lme_all.Coefficients(1,2).Estimate);
    plot(x,y)
    %axis([mean(days(:,1),1)-1 mean(days(:,end))+1 0 0.6])
    if sum(strcmp(animals,'I089')) == 0 && sum(strcmp(animals,'I110')) == 0
        saveas(gcf,[rootpath, '/Neural_Decoding_comb_scatter.fig'])
    end
    hold off
    close all
    
%     bar(mean(days,1),mean(comb_data,1));
%     line(mean(days,1), mean(comb_data,1), 'LineWidth', 1) %, 'Color', [.7 .7 .7])
%     errorbar(mean(days,1), mean(comb_data,1), std(comb_data,0,1)./sqrt(length(animals)), std(comb_data,0,1)./sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
%     %axis([mean(days(:,1),1)-1 mean(days(:,end))+1 0 0.6])
%     if sum(strcmp(animals,'I089')) == 0
%         saveas(gcf,[rootpath, '/Neural_Decoding_comb.fig'])
%     end
%     hold off
%     close all
    
    M1_data = nan(length(animals),2);
    Cb_data = nan(length(animals),2);
    comb_data = nan(length(animals),2);
    M1_tbl = zeros(0,3);
    Cb_tbl = zeros(0,3);
    comb_tbl = zeros(0,3);
    for day = SvF_days
        for a = 1:length(animals)
            M1_data(a,1) = animal_data{a}.M1_r2s_fail(day);
            M1_data(a,2) = animal_data{a}.M1_r2s_succ(day);
            M1_tbl = cat(1, M1_tbl, [M1_data(a,:)', [0; 1], (ones(2,1) * a)]);
            
            Cb_data(a,1) = animal_data{a}.Cb_r2s_fail(day);
            Cb_data(a,2) = animal_data{a}.Cb_r2s_succ(day);
            Cb_tbl = cat(1, Cb_tbl, [Cb_data(a,:)', [0; 1], (ones(2,1) * a)]);
            
            comb_data(a,1) = animal_data{a}.comb_r2s_fail(day);
            comb_data(a,2) = animal_data{a}.comb_r2s_succ(day);
            comb_tbl = cat(1, comb_tbl, [comb_data(a,:)', [0; 1], (ones(2,1) * a)]);
        end
        
        figure
        hold on
        M1_tbl = array2table(M1_tbl,'VariableNames',{'data','Outcome','Animal'});
        M1_tbl.Outcome = nominal(M1_tbl.Outcome);
        M1_tbl.Animal = nominal(M1_tbl.Animal);
        formula = 'data ~ 1 + Outcome + (1 | Animal)';
        lme_all = fitlme(M1_tbl,formula);
        p_val = coefTest(lme_all);
        title(['P-val: ', num2str(p_val)]);
        
        bar([1 2], mean(M1_data,1));
        line([1 2], mean(M1_data,1), 'LineWidth', 1) %, 'Color', [.7 .7 .7])
        errorbar([1 2], mean(M1_data,1), std(M1_data,0,1)./sqrt(length(animals)), std(M1_data,0,1)./sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
        %axis([mean(days(:,1),1)-1 mean(days(:,end))+1 0 0.6])
        xticklabels({'Failure','Success'})
        if sum(strcmp(animals,'I110')) == 0
            saveas(gcf,[rootpath, '/Neural_Decoding_M1_SvF_day', num2str(day), '.fig'])
        end
        hold off
        close all
        
        figure
        hold on
        Cb_tbl = array2table(Cb_tbl,'VariableNames',{'data','Outcome','Animal'});
        Cb_tbl.Outcome = nominal(Cb_tbl.Outcome);
        Cb_tbl.Animal = nominal(Cb_tbl.Animal);
        formula = 'data ~ 1 + Outcome + (1 | Animal)';
        lme_all = fitlme(Cb_tbl,formula);
        p_val = coefTest(lme_all);
        title(['P-val: ', num2str(p_val)]);
        
        bar([1 2], mean(Cb_data,1));
        line([1 2], mean(Cb_data,1), 'LineWidth', 1) %, 'Color', [.7 .7 .7])
        errorbar([1 2], mean(Cb_data,1), std(Cb_data,0,1)./sqrt(length(animals)), std(Cb_data,0,1)./sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
        %axis([mean(days(:,1),1)-1 mean(days(:,end))+1 0 0.6])
        xticklabels({'Failure','Success'})
        if sum(strcmp(animals,'I089')) == 0
            saveas(gcf,[rootpath, '/Neural_Decoding_Cb_SvF_day', num2str(day), '.fig'])
        end
        hold off
        close all
        
        figure
        hold on
        comb_tbl = array2table(comb_tbl,'VariableNames',{'data','Outcome','Animal'});
        comb_tbl.Outcome = nominal(comb_tbl.Outcome);
        comb_tbl.Animal = nominal(comb_tbl.Animal);
        formula = 'data ~ 1 + Outcome + (1 | Animal)';
        lme_all = fitlme(comb_tbl,formula);
        p_val = coefTest(lme_all);
        title(['P-val: ', num2str(p_val)]);
        
        bar([1 2], mean(Cb_data,1));
        line([1 2], mean(Cb_data,1), 'LineWidth', 1) %, 'Color', [.7 .7 .7])
        errorbar([1 2], mean(comb_data,1), std(comb_data,0,1)./sqrt(length(animals)), std(comb_data,0,1)./sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
        %axis([mean(days(:,1),1)-1 mean(days(:,end))+1 0 0.6])
        xticklabels({'Failure','Success'})
        if sum(strcmp(animals,'I089')) == 0 &&sum(strcmp(animals,'I110')) == 0
            saveas(gcf,[rootpath, '/Neural_Decoding_comb_SvF_day', num2str(day), '.fig'])
        end
        hold off
        close all
    end
end

%% 16: Spiking Analysis for Sleep Spindle Cycles 

if enabled(16)
    
    addpath(genpath('Z:\Matlab for analysis'))
    
    days = 1:5;%[1];
    group_names = {'Tail' 'Peak'};
    group_cycles = [[1;10] [5;6]];%[[1;2;9;10] [4;5;6;7]];
    c_group_cycles = [5;6];%[4;5;6;7];
    M1_spike_counts = nan(size(animal_data{1}.M1_spindle_cycle_spike_counts{days(1)},1),0);
    M1_prefered_phases = nan(size(M1_spike_counts));
    M1_phase_locking_values = nan(size(M1_spike_counts));
    M1_animal_ids = nan(size(M1_spike_counts));
    Cb_spike_counts = nan(size(animal_data{1}.Cb_spindle_cycle_spike_counts{days(1)},1),0);
    Cb_prefered_phases = nan(size(Cb_spike_counts));
    Cb_phase_locking_values = nan(size(Cb_spike_counts));
    Cb_animal_ids = nan(size(Cb_spike_counts));
    
    c_M1_spike_counts = nan(size(animal_data{1}.M1_spindle_cycle_spike_counts{days(1)},1),0);
    c_M1_prefered_phases = nan(size(M1_spike_counts));
    c_M1_phase_locking_values = nan(size(M1_spike_counts));
    c_M1_animal_ids = nan(size(M1_spike_counts));
    c_Cb_spike_counts = nan(size(animal_data{1}.Cb_spindle_cycle_spike_counts{days(1)},1),0);
    c_Cb_prefered_phases = nan(size(Cb_spike_counts));
    c_Cb_phase_locking_values = nan(size(Cb_spike_counts));
    c_Cb_animal_ids = nan(size(Cb_spike_counts));
    for a = 1:length(animals)
        M1_spike_counts = cat(2, M1_spike_counts, animal_data{a}.M1_spindle_cycle_spike_counts{days});
        M1_prefered_phases = cat(2, M1_prefered_phases, animal_data{a}.M1_spindle_cycle_prefered_phases{days});
        M1_phase_locking_values = cat(2, M1_phase_locking_values, animal_data{a}.M1_spindle_cycle_phase_locking_values{days});
        M1_animal_ids = cat(2, M1_animal_ids, ones(size(M1_spike_counts,1), size(M1_spike_counts,2) - size(M1_animal_ids,2)) * a);
        Cb_spike_counts = cat(2, Cb_spike_counts, animal_data{a}.Cb_spindle_cycle_spike_counts{days});
        Cb_prefered_phases = cat(2, Cb_prefered_phases, animal_data{a}.Cb_spindle_cycle_prefered_phases{days});
        Cb_phase_locking_values = cat(2, Cb_phase_locking_values, animal_data{a}.Cb_spindle_cycle_phase_locking_values{days});
        Cb_animal_ids = cat(2, Cb_animal_ids, ones(size(Cb_spike_counts,1), size(Cb_spike_counts,2) - size(Cb_animal_ids,2)) * a);
        
        c_M1_spike_counts = cat(2, c_M1_spike_counts, animal_data{a}.c_M1_spindle_cycle_spike_counts{days});
        c_M1_prefered_phases = cat(2, c_M1_prefered_phases, animal_data{a}.c_M1_spindle_cycle_prefered_phases{days});
        c_M1_phase_locking_values = cat(2, c_M1_phase_locking_values, animal_data{a}.c_M1_spindle_cycle_phase_locking_values{days});
        c_M1_animal_ids = cat(2, c_M1_animal_ids, ones(size(c_M1_spike_counts,1), size(c_M1_spike_counts,2) - size(c_M1_animal_ids,2)) * a);
        c_Cb_spike_counts = cat(2, c_Cb_spike_counts, animal_data{a}.c_Cb_spindle_cycle_spike_counts{days});
        c_Cb_prefered_phases = cat(2, c_Cb_prefered_phases, animal_data{a}.c_Cb_spindle_cycle_prefered_phases{days});
        c_Cb_phase_locking_values = cat(2, c_Cb_phase_locking_values, animal_data{a}.c_Cb_spindle_cycle_phase_locking_values{days});
        c_Cb_animal_ids = cat(2, c_Cb_animal_ids, ones(size(c_Cb_spike_counts,1), size(c_Cb_spike_counts,2) - size(c_Cb_animal_ids,2)) * a);
    end
    M1_spike_counts = reshape(M1_spike_counts(group_cycles',:),[size(group_cycles,2) (size(group_cycles,1)*size(M1_spike_counts,2))]);
    M1_prefered_phases = reshape(M1_prefered_phases(group_cycles',:),[size(group_cycles,2) (size(group_cycles,1)*size(M1_prefered_phases,2))]);
    M1_phase_locking_values = reshape(M1_phase_locking_values(group_cycles',:),[size(group_cycles,2) (size(group_cycles,1)*size(M1_phase_locking_values,2))]);
    M1_animal_ids = reshape(M1_animal_ids(group_cycles',:),[size(group_cycles,2) (size(group_cycles,1)*size(M1_animal_ids,2))]);
    Cb_spike_counts = reshape(Cb_spike_counts(group_cycles',:),[size(group_cycles,2) (size(group_cycles,1)*size(Cb_spike_counts,2))]);
    Cb_prefered_phases = reshape(Cb_prefered_phases(group_cycles',:),[size(group_cycles,2) (size(group_cycles,1)*size(Cb_prefered_phases,2))]);
    Cb_phase_locking_values = reshape(Cb_phase_locking_values(group_cycles',:),[size(group_cycles,2) (size(group_cycles,1)*size(Cb_phase_locking_values,2))]);
    Cb_animal_ids = reshape(Cb_animal_ids(group_cycles',:),[size(group_cycles,2) (size(group_cycles,1)*size(Cb_animal_ids,2))]);
    
    c_M1_spike_counts = reshape(c_M1_spike_counts(c_group_cycles',:),[size(c_group_cycles,2) (size(c_group_cycles,1)*size(c_M1_spike_counts,2))]);
    c_M1_prefered_phases = reshape(c_M1_prefered_phases(c_group_cycles',:),[size(c_group_cycles,2) (size(c_group_cycles,1)*size(c_M1_prefered_phases,2))]);
    c_M1_phase_locking_values = reshape(c_M1_phase_locking_values(c_group_cycles',:),[size(c_group_cycles,2) (size(c_group_cycles,1)*size(c_M1_phase_locking_values,2))]);
    c_M1_animal_ids = reshape(c_M1_animal_ids(c_group_cycles',:),[size(c_group_cycles,2) (size(c_group_cycles,1)*size(c_M1_animal_ids,2))]);
    c_Cb_spike_counts = reshape(c_Cb_spike_counts(c_group_cycles',:),[size(c_group_cycles,2) (size(c_group_cycles,1)*size(c_Cb_spike_counts,2))]);
    c_Cb_prefered_phases = reshape(c_Cb_prefered_phases(c_group_cycles',:),[size(c_group_cycles,2) (size(c_group_cycles,1)*size(c_Cb_prefered_phases,2))]);
    c_Cb_phase_locking_values = reshape(c_Cb_phase_locking_values(c_group_cycles',:),[size(c_group_cycles,2) (size(c_group_cycles,1)*size(c_Cb_phase_locking_values,2))]);
    c_Cb_animal_ids = reshape(c_Cb_animal_ids(c_group_cycles',:),[size(c_group_cycles,2) (size(c_group_cycles,1)*size(c_Cb_animal_ids,2))]);
    
    group_names = [group_names {'Control'}];
    group_idxs = 1:length(group_names);
    
    M1_tbl_ar = [M1_spike_counts(1,:)',ones(size(M1_spike_counts,2),1),M1_animal_ids(1,:)';M1_spike_counts(2,:)',(ones(size(M1_spike_counts,2),1)*2),M1_animal_ids(2,:)'];
    M1_tbl_ar = [M1_tbl_ar; [c_M1_spike_counts(1,:)',(ones(size(c_M1_spike_counts,2),1)*3),c_M1_animal_ids(1,:)']];
    
    %ANOVA to test for a non-specific significant factor
    M1_tbl = array2table(M1_tbl_ar,'VariableNames',{'data','Group','Animal'});
    M1_tbl.Group = nominal(M1_tbl.Group);
    M1_tbl.Animal = nominal(M1_tbl.Animal);
    formula = 'data ~ 1 + Group + (1 | Animal)';
    glme_all = fitglme(M1_tbl,formula);
    p_val_all = coefTest(glme_all);
    %Alt method
    %[~, anova_table] = anova1(M1_tbl_ar(1,:),M1_tbl_ar(2,:));
    %p_val_all = anova_table{2,5};
    
    animal_means = nan(length(group_idxs), length(animals));
    for group = group_idxs
        group_tbl = M1_tbl(M1_tbl.Group == nominal(group),:);
        for a = 1:length(animals)
            g_a_tbl = group_tbl(group_tbl.Animal == nominal(a),'data');
            animal_means(group,a) = mean(g_a_tbl.data,1,'omitnan');
        end
    end
    
    % 3 Pair-wise Mixed-effect tests
    M1_tbl = array2table(M1_tbl_ar(M1_tbl_ar(:,2) ~= 3,:),'VariableNames',{'data','Group','Animal'});
    M1_tbl.Group = nominal(M1_tbl.Group);
    M1_tbl.Animal = nominal(M1_tbl.Animal);
    lme_all = fitlme(M1_tbl,formula);
    p_val_TvP = coefTest(lme_all);
    M1_tbl = array2table(M1_tbl_ar(M1_tbl_ar(:,2) ~= 2,:),'VariableNames',{'data','Group','Animal'});
    M1_tbl.Group = nominal(M1_tbl.Group);
    M1_tbl.Animal = nominal(M1_tbl.Animal);
    lme_all = fitlme(M1_tbl,formula);
    p_val_TvC = coefTest(lme_all);
    M1_tbl = array2table(M1_tbl_ar(M1_tbl_ar(:,2) ~= 1,:),'VariableNames',{'data','Group','Animal'});
    M1_tbl.Group = nominal(M1_tbl.Group);
    M1_tbl.Animal = nominal(M1_tbl.Animal);
    lme_all = fitlme(M1_tbl,formula);
    p_val_PvC = coefTest(lme_all);
    
    hold on
    bar(group_idxs, [mean(M1_spike_counts,2,'omitnan'); mean(c_M1_spike_counts,2,'omitnan')])
    plot(group_idxs, animal_means)
    errorbar(group_idxs, [mean(M1_spike_counts,2,'omitnan'); mean(c_M1_spike_counts,2,'omitnan')], [std(M1_spike_counts,0,2,'omitnan')./sqrt(size(M1_spike_counts,2)); std(c_M1_spike_counts,0,2,'omitnan')./sqrt(size(c_M1_spike_counts,2))], [std(M1_spike_counts,0,2,'omitnan')./sqrt(size(M1_spike_counts,2)); std(c_M1_spike_counts,0,2,'omitnan')./sqrt(size(c_M1_spike_counts,2))], 'Color', [0 0 0], 'LineWidth', 2);
    xticks(group_idxs)
    xticklabels(group_names)
    title(['TvP P-val: ', num2str(p_val_TvP), '  TvC P-val: ', num2str(p_val_TvC), '  PvC P-val: ', num2str(p_val_PvC)]);
    if sum(strcmp(animals,'I110')) == 0
        saveas(gcf,[rootpath, '/M1_spindel_spikes_per_cycle.fig'])
    end
    hold off
    close all
    
    %Prefered Phase uses unit vector summation to find mean and circular Watson-Williams test to determine significant differences; no error bars possible
    [vect_x, vect_y] = pol2cart(M1_prefered_phases,1);
    [theta, ~] = cart2pol(mean(vect_x,2,'omitnan'),mean(vect_y,2,'omitnan'));
    [vect_x, vect_y] = pol2cart(c_M1_prefered_phases,1);
    [c_theta, ~] = cart2pol(mean(vect_x,2,'omitnan'),mean(vect_y,2,'omitnan'));
    theta = [theta; c_theta];
    
    animal_means = nan(length(group_idxs), length(animals));
    animal_vect = M1_tbl_ar(M1_tbl_ar(:,2) == 1,3);
    for group = group_idxs
        for a = 1:length(animals)
            bool_vect = animal_vect == a;
            if group == group_idxs(end)
                bool_vect = [bool_vect'; bool_vect'];
                bool_vect = bool_vect(:);
                [vect_x, vect_y] = pol2cart(c_M1_prefered_phases(:,bool_vect),1);
                [animal_means(group,a),~] = cart2pol(mean(vect_x,2,'omitnan'),mean(vect_y,2,'omitnan'));
            else
                [vect_x, vect_y] = pol2cart(M1_prefered_phases(group,bool_vect),1);
                [animal_means(group,a),~] = cart2pol(mean(vect_x,2,'omitnan'),mean(vect_y,2,'omitnan'));
            end
            
        end
    end
            
    %TODO: ANOVA to test for a non-specific significant factor
    % Use CircularANOVA()
    try
        [p_val_TvP, ~] = circ_wwtest(M1_prefered_phases(1,~isnan(M1_prefered_phases(1,:))),M1_prefered_phases(2,~isnan(M1_prefered_phases(2,:))));
    catch
        p_val_TvP = -1;
    end
    try
        [p_val_TvC, ~] = circ_wwtest(M1_prefered_phases(1,~isnan(M1_prefered_phases(1,:))),c_M1_prefered_phases(1,~isnan(c_M1_prefered_phases(1,:))));
    catch
        p_val_TvC = -1;
    end
    try
        [p_val_PvC, ~] = circ_wwtest(M1_prefered_phases(2,~isnan(M1_prefered_phases(2,:))),c_M1_prefered_phases(1,~isnan(c_M1_prefered_phases(1,:))));
    catch
        p_val_PvC = -1;
    end
    hold on
    bar(group_idxs, theta)
    plot(group_idxs, animal_means)
    xticks(group_idxs)
    xticklabels(group_names)
    ylim([-pi, pi])
    title(['TvP P-val: ', num2str(p_val_TvP), '  TvC P-val: ', num2str(p_val_TvC), '  PvC P-val: ', num2str(p_val_PvC)]); %-1 means both are near uniform
    if sum(strcmp(animals,'I110')) == 0
        saveas(gcf,[rootpath, '/M1_spindel_prefered_phase.fig'])
    end
    hold off
    close all
    
    M1_tbl_ar = [M1_phase_locking_values(1,:)',ones(size(M1_phase_locking_values,2),1),M1_animal_ids(1,:)';M1_phase_locking_values(2,:)',(ones(size(M1_phase_locking_values,2),1)*2),M1_animal_ids(2,:)'];
    M1_tbl_ar = [M1_tbl_ar; [c_M1_phase_locking_values(1,:)',(ones(size(c_M1_phase_locking_values,2),1)*3),c_M1_animal_ids(1,:)']];
    
    %ANOVA to test for a non-specific significant factor
    M1_tbl = array2table(M1_tbl_ar,'VariableNames',{'data','Group','Animal'});
    M1_tbl.Group = nominal(M1_tbl.Group);
    M1_tbl.Animal = nominal(M1_tbl.Animal);
    formula = 'data ~ 1 + Group + (1 | Animal)';
    glme_all = fitglme(M1_tbl,formula);
    p_val_all = coefTest(glme_all);
    %Alt method
    %[~, anova_table] = anova1(M1_tbl_ar(1,:),M1_tbl_ar(2,:));
    %p_val_all = anova_table{2,5};
    
    animal_means = nan(length(group_idxs), length(animals));
    for group = group_idxs
        group_tbl = M1_tbl(M1_tbl.Group == nominal(group),:);
        for a = 1:length(animals)
            g_a_tbl = group_tbl(group_tbl.Animal == nominal(a),'data');
            animal_means(group,a) = mean(g_a_tbl.data,1,'omitnan');
        end
    end
    
    formula = 'data ~ 1 + Group + (1 | Animal)';
    % 3 Pair-wise Mixed-effect tests
    M1_tbl = array2table(M1_tbl_ar(M1_tbl_ar(:,2) ~= 3,:),'VariableNames',{'data','Group','Animal'});
    M1_tbl.Group = nominal(M1_tbl.Group);
    M1_tbl.Animal = nominal(M1_tbl.Animal);
    lme_all = fitlme(M1_tbl,formula);
    p_val_TvP = coefTest(lme_all);
    M1_tbl = array2table(M1_tbl_ar(M1_tbl_ar(:,2) ~= 2,:),'VariableNames',{'data','Group','Animal'});
    M1_tbl.Group = nominal(M1_tbl.Group);
    M1_tbl.Animal = nominal(M1_tbl.Animal);
    lme_all = fitlme(M1_tbl,formula);
    p_val_TvC = coefTest(lme_all);
    M1_tbl = array2table(M1_tbl_ar(M1_tbl_ar(:,2) ~= 1,:),'VariableNames',{'data','Group','Animal'});
    M1_tbl.Group = nominal(M1_tbl.Group);
    M1_tbl.Animal = nominal(M1_tbl.Animal);
    lme_all = fitlme(M1_tbl,formula);
    p_val_PvC = coefTest(lme_all);
    
    hold on
    bar(group_idxs, [mean(M1_phase_locking_values,2,'omitnan'); mean(c_M1_phase_locking_values,2,'omitnan')])
    plot(group_idxs, animal_means)
    errorbar(group_idxs, [mean(M1_phase_locking_values,2,'omitnan'); mean(c_M1_phase_locking_values,2,'omitnan')], [std(M1_phase_locking_values,0,2,'omitnan')./sqrt(size(M1_phase_locking_values,2)); std(c_M1_phase_locking_values,0,2,'omitnan')./sqrt(size(c_M1_phase_locking_values,2))], [std(M1_phase_locking_values,0,2,'omitnan')./sqrt(size(M1_phase_locking_values,2)); std(c_M1_phase_locking_values,0,2,'omitnan')./sqrt(size(c_M1_phase_locking_values,2))], 'Color', [0 0 0], 'LineWidth', 2);
    xticks(group_idxs)
    xticklabels(group_names)
    title(['TvP P-val: ', num2str(p_val_TvP), '  TvC P-val: ', num2str(p_val_TvC), '  PvC P-val: ', num2str(p_val_PvC)]);
    if sum(strcmp(animals,'I110')) == 0
        saveas(gcf,[rootpath, '/M1_spindel_phase_locking.fig'])
    end
    hold off
    close all
    
    Cb_tbl_ar = [Cb_spike_counts(1,:)',ones(size(Cb_spike_counts,2),1),Cb_animal_ids(1,:)';Cb_spike_counts(2,:)',(ones(size(Cb_spike_counts,2),1)*2),Cb_animal_ids(2,:)'];
    Cb_tbl_ar = [Cb_tbl_ar; [c_Cb_spike_counts(1,:)',(ones(size(c_Cb_spike_counts,2),1)*3),c_Cb_animal_ids(1,:)']];
    
    %ANOVA to test for a non-specific significant factor
    Cb_tbl = array2table(Cb_tbl_ar,'VariableNames',{'data','Group','Animal'});
    Cb_tbl.Group = nominal(Cb_tbl.Group);
    Cb_tbl.Animal = nominal(Cb_tbl.Animal);
    formula = 'data ~ 1 + Group + (1 | Animal)';
    glme_all = fitglme(Cb_tbl,formula);
    p_val_all = coefTest(glme_all);
    %Alt method
    %[~, anova_table] = anova1(Cb_tbl_ar(1,:),Cb_tbl_ar(2,:));
    %p_val_all = anova_table{2,5};
    
    animal_means = nan(length(group_idxs), length(animals));
    for group = group_idxs
        group_tbl = Cb_tbl(Cb_tbl.Group == nominal(group),:);
        for a = 1:length(animals)
            g_a_tbl = group_tbl(group_tbl.Animal == nominal(a),'data');
            animal_means(group,a) = mean(g_a_tbl.data,1,'omitnan');
        end
    end
    
    formula = 'data ~ 1 + Group + (1 | Animal)';
    % 3 Pair-wise Mixed-effect tests
    Cb_tbl = array2table(Cb_tbl_ar(Cb_tbl_ar(:,2) ~= 3,:),'VariableNames',{'data','Group','Animal'});
    Cb_tbl.Group = nominal(Cb_tbl.Group);
    Cb_tbl.Animal = nominal(Cb_tbl.Animal);
    lme_all = fitlme(Cb_tbl,formula);
    p_val_TvP = coefTest(lme_all);
    Cb_tbl = array2table(Cb_tbl_ar(Cb_tbl_ar(:,2) ~= 2,:),'VariableNames',{'data','Group','Animal'});
    Cb_tbl.Group = nominal(Cb_tbl.Group);
    Cb_tbl.Animal = nominal(Cb_tbl.Animal);
    lme_all = fitlme(Cb_tbl,formula);
    p_val_TvC = coefTest(lme_all);
    Cb_tbl = array2table(Cb_tbl_ar(Cb_tbl_ar(:,2) ~= 1,:),'VariableNames',{'data','Group','Animal'});
    Cb_tbl.Group = nominal(Cb_tbl.Group);
    Cb_tbl.Animal = nominal(Cb_tbl.Animal);
    lme_all = fitlme(Cb_tbl,formula);
    p_val_PvC = coefTest(lme_all);
    
    hold on
    bar(group_idxs, [mean(Cb_spike_counts,2,'omitnan'); mean(c_Cb_spike_counts,2,'omitnan')])
    plot(group_idxs, animal_means)
    errorbar(group_idxs, [mean(Cb_spike_counts,2,'omitnan'); mean(c_Cb_spike_counts,2,'omitnan')], [std(Cb_spike_counts,0,2,'omitnan')./sqrt(size(Cb_spike_counts,2)); std(c_Cb_spike_counts,0,2,'omitnan')./sqrt(size(c_Cb_spike_counts,2))], [std(Cb_spike_counts,0,2,'omitnan')./sqrt(size(Cb_spike_counts,2)); std(c_Cb_spike_counts,0,2,'omitnan')./sqrt(size(c_Cb_spike_counts,2))], 'Color', [0 0 0], 'LineWidth', 2);
    xticks(group_idxs)
    xticklabels(group_names)
    title(['TvP P-val: ', num2str(p_val_TvP), '  TvC P-val: ', num2str(p_val_TvC), '  PvC P-val: ', num2str(p_val_PvC)]);
    if sum(strcmp(animals,'I089')) == 0
        saveas(gcf,[rootpath, '/Cb_spindel_spikes_per_cycle.fig'])
    end
    hold off
    close all
    
    %Prefered Phase uses unit vector summation to find mean and circular Watson-Williams test to determine significant differences; no error bars possible
    [vect_x, vect_y] = pol2cart(Cb_prefered_phases,1);
    [theta, ~] = cart2pol(mean(vect_x,2,'omitnan'),mean(vect_y,2,'omitnan'));
    [vect_x, vect_y] = pol2cart(c_Cb_prefered_phases,1);
    [c_theta, ~] = cart2pol(mean(vect_x,2,'omitnan'),mean(vect_y,2,'omitnan'));
    theta = [theta; c_theta];
    
    animal_means = nan(length(group_idxs), length(animals));
    animal_vect = Cb_tbl_ar(Cb_tbl_ar(:,2) == 1,3);
    for group = group_idxs
        for a = 1:length(animals)
            bool_vect = animal_vect == a;
            if group == group_idxs(end)
                bool_vect = [bool_vect'; bool_vect'];
                bool_vect = bool_vect(:);
                [vect_x, vect_y] = pol2cart(c_Cb_prefered_phases(:,bool_vect),1);
                [animal_means(group,a),~] = cart2pol(mean(vect_x,2,'omitnan'),mean(vect_y,2,'omitnan'));
            else
                [vect_x, vect_y] = pol2cart(Cb_prefered_phases(group,bool_vect),1);
                [animal_means(group,a),~] = cart2pol(mean(vect_x,2,'omitnan'),mean(vect_y,2,'omitnan'));
            end
            
        end
    end
    
    try
        [p_val_TvP, ~] = circ_wwtest(Cb_prefered_phases(1,~isnan(Cb_prefered_phases(1,:))),Cb_prefered_phases(2,~isnan(Cb_prefered_phases(2,:))));
    catch
        p_val_TvP = -1;
    end
    try
        [p_val_TvC, ~] = circ_wwtest(Cb_prefered_phases(1,~isnan(Cb_prefered_phases(1,:))),c_Cb_prefered_phases(1,~isnan(c_Cb_prefered_phases(1,:))));
    catch
        p_val_TvC = -1;
    end
    try
        [p_val_PvC, ~] = circ_wwtest(Cb_prefered_phases(2,~isnan(Cb_prefered_phases(2,:))),c_Cb_prefered_phases(1,~isnan(c_Cb_prefered_phases(1,:))));
    catch
        p_val_PvC = -1;
    end
    hold on
    bar(group_idxs, theta)
    plot(group_idxs, animal_means)
    xticks(group_idxs)
    xticklabels(group_names)
    ylim([-pi, pi])
    title(['TvP P-val: ', num2str(p_val_TvP), '  TvC P-val: ', num2str(p_val_TvC), '  PvC P-val: ', num2str(p_val_PvC)]); %-1 means both are near uniform
    if sum(strcmp(animals,'I089')) == 0
        saveas(gcf,[rootpath, '/Cb_spindel_prefered_phase.fig'])
    end
    hold off
    close all
    
    Cb_tbl_ar = [Cb_phase_locking_values(1,:)',ones(size(Cb_phase_locking_values,2),1),Cb_animal_ids(1,:)';Cb_phase_locking_values(2,:)',(ones(size(Cb_phase_locking_values,2),1)*2),Cb_animal_ids(2,:)'];
    Cb_tbl_ar = [Cb_tbl_ar; [c_Cb_phase_locking_values(1,:)',(ones(size(c_Cb_phase_locking_values,2),1)*3),c_Cb_animal_ids(1,:)']];
    
    %ANOVA to test for a non-specific significant factor
    Cb_tbl = array2table(Cb_tbl_ar,'VariableNames',{'data','Group','Animal'});
    Cb_tbl.Group = nominal(Cb_tbl.Group);
    Cb_tbl.Animal = nominal(Cb_tbl.Animal);
    formula = 'data ~ 1 + Group + (1 | Animal)';
    glme_all = fitglme(Cb_tbl,formula);
    p_val_all = coefTest(glme_all);
    %Alt method
    %[~, anova_table] = anova1(Cb_tbl_ar(1,:),Cb_tbl_ar(2,:));
    %p_val_all = anova_table{2,5};
    
    animal_means = nan(length(group_idxs), length(animals));
    for group = group_idxs
        group_tbl = Cb_tbl(Cb_tbl.Group == nominal(group),:);
        for a = 1:length(animals)
            g_a_tbl = group_tbl(group_tbl.Animal == nominal(a),'data');
            animal_means(group,a) = mean(g_a_tbl.data,1,'omitnan');
        end
    end
    
    formula = 'data ~ 1 + Group + (1 | Animal)';
    % 3 Pair-wise Mixed-effect tests
    Cb_tbl = array2table(Cb_tbl_ar(Cb_tbl_ar(:,2) ~= 3,:),'VariableNames',{'data','Group','Animal'});
    Cb_tbl.Group = nominal(Cb_tbl.Group);
    Cb_tbl.Animal = nominal(Cb_tbl.Animal);
    lme_all = fitlme(Cb_tbl,formula);
    p_val_TvP = coefTest(lme_all);
    Cb_tbl = array2table(Cb_tbl_ar(Cb_tbl_ar(:,2) ~= 2,:),'VariableNames',{'data','Group','Animal'});
    Cb_tbl.Group = nominal(Cb_tbl.Group);
    Cb_tbl.Animal = nominal(Cb_tbl.Animal);
    lme_all = fitlme(Cb_tbl,formula);
    p_val_TvC = coefTest(lme_all);
    Cb_tbl = array2table(Cb_tbl_ar(Cb_tbl_ar(:,2) ~= 1,:),'VariableNames',{'data','Group','Animal'});
    Cb_tbl.Group = nominal(Cb_tbl.Group);
    Cb_tbl.Animal = nominal(Cb_tbl.Animal);
    lme_all = fitlme(Cb_tbl,formula);
    p_val_PvC = coefTest(lme_all);
    
    hold on
    bar(group_idxs, [mean(Cb_phase_locking_values,2,'omitnan'); mean(c_Cb_phase_locking_values,2,'omitnan')])
    plot(group_idxs, animal_means)
    errorbar(group_idxs, [mean(Cb_phase_locking_values,2,'omitnan'); mean(c_Cb_phase_locking_values,2,'omitnan')], [std(Cb_phase_locking_values,0,2,'omitnan')./sqrt(size(Cb_phase_locking_values,2)); std(c_Cb_phase_locking_values,0,2,'omitnan')./sqrt(size(c_Cb_phase_locking_values,2))], [std(Cb_phase_locking_values,0,2,'omitnan')./sqrt(size(Cb_phase_locking_values,2)); std(c_Cb_phase_locking_values,0,2,'omitnan')./sqrt(size(c_Cb_phase_locking_values,2))], 'Color', [0 0 0], 'LineWidth', 2);
    xticks(group_idxs)
    xticklabels(group_names)
    title(['TvP P-val: ', num2str(p_val_TvP), '  TvC P-val: ', num2str(p_val_TvC), '  PvC P-val: ', num2str(p_val_PvC)]);
    if sum(strcmp(animals,'I089')) == 0
        saveas(gcf,[rootpath, '/Cb_spindel_phase_locking.fig'])
    end
    hold off
    close all
    
    rmpath(genpath('Z:\Matlab for analysis'))
end

%% 17: Nested Spindle Counts S1 vs S2

if enabled(17)
    days = 1:5;
    M1_data = nan(0,3);
    Cb_data = nan(0,3);
    for a = 1:length(animals)
        S1_data = animal_data{a}.M1_spindle_rate(1,:,days);
        S2_data = animal_data{a}.M1_spindle_rate(2,:,days);
        M1_data = cat(1, M1_data, [S1_data(:), ones(length(S1_data(:)),1), (ones(length(S1_data(:)),1) * a)]);
        M1_data = cat(1, M1_data, [S2_data(:), (ones(length(S2_data(:)),1) * 2), (ones(length(S2_data(:)),1) * a)]);
        
        S1_data = animal_data{a}.Cb_spindle_rate(1,:,:);
        S2_data = animal_data{a}.Cb_spindle_rate(2,:,:);
        Cb_data = cat(1, Cb_data, [S1_data(:), ones(length(S1_data(:)),1), (ones(length(S1_data(:)),1) * a)]);
        Cb_data = cat(1, Cb_data, [S2_data(:), (ones(length(S2_data(:)),1) * 2), (ones(length(S2_data(:)),1) * a)]);
    end
    
    M1_tbl = array2table(M1_data,'VariableNames',{'data','Block','Animal'});
    M1_tbl.Block = nominal(M1_tbl.Block);
    M1_tbl.Animal = nominal(M1_tbl.Animal);
    Cb_tbl = array2table(Cb_data,'VariableNames',{'data','Block','Animal'});
    Cb_tbl.Block = nominal(Cb_tbl.Block);
    Cb_tbl.Animal = nominal(Cb_tbl.Animal);
    formula = 'data ~ 1 + Block + (1 | Animal)';
    
    S1_data = M1_data(M1_data(:,2) == 1,1);
    S2_data = M1_data(M1_data(:,2) == 2,1);
    lme_all = fitlme(M1_tbl,formula);
    p_val = coefTest(lme_all);
    hold on
    bar([1,2], [mean(S1_data,1,'omitnan'), mean(S2_data,1,'omitnan')])
    errorbar([1,2], [mean(S1_data,1,'omitnan'), mean(S2_data,1,'omitnan')], [std(S1_data,0,1,'omitnan')./sqrt(size(S1_data,1)), std(S2_data,0,1,'omitnan')./sqrt(size(S2_data,1))], [std(S1_data,0,1,'omitnan')./sqrt(size(S1_data,1)), std(S2_data,0,1,'omitnan')./sqrt(size(S2_data,1))], 'Color', [0 0 0], 'LineWidth', 2);
    xticks([1,2])
    xticklabels({'Sleep 1', 'Sleep 2'})
    title(['P-val: ', num2str(p_val)]);
    if sum(strcmp(animals,'I110')) == 0
        saveas(gcf,[rootpath, '/M1_nested_spindel_rate.fig'])
    end
    hold off
    close all
    
    S1_data = Cb_data(Cb_data(:,2) == 1,1);
    S2_data = Cb_data(Cb_data(:,2) == 2,1);
    lme_all = fitlme(Cb_tbl,formula);
    p_val = coefTest(lme_all);
    hold on
    bar([1,2], [mean(S1_data,1,'omitnan'), mean(S2_data,1,'omitnan')])
    errorbar([1,2], [mean(S1_data,1,'omitnan'), mean(S2_data,1,'omitnan')], [std(S1_data,0,1,'omitnan')./sqrt(size(S1_data,1)), std(S2_data,0,1,'omitnan')./sqrt(size(S2_data,1))], [std(S1_data,0,1,'omitnan')./sqrt(size(S1_data,1)), std(S2_data,0,1,'omitnan')./sqrt(size(S2_data,1))], 'Color', [0 0 0], 'LineWidth', 2);
    xticks([1,2])
    xticklabels({'Sleep 1', 'Sleep 2'})
    title(['P-val: ', num2str(p_val)]);
    if sum(strcmp(animals,'I110')) == 0
        saveas(gcf,[rootpath, '/Cb_nested_spindel_rate.fig'])
    end
    hold off
    close all
end

%% 18: Reach Assembly Reappearance Durring Sleep

if enabled(18)
    days = 1:5;
    for a = 1:length(animals)
        
    end
end

%% 19: Normalize and Sum LFP Phase Differences Hisograms

if enabled(19)
    days = [[1] [5]];
    all_data = cell(size(days,2),1);
    for epoch = 1:size(days,2)
        all_data{epoch} = zeros(1,0);
        for a = 1:length(animals)
            for day = days(:,epoch)'
                for block = 1:2
                    uiopen([rootpath, animals{a}, '\Day', num2str(day), '\Training', num2str(block), '\Filter_Compare\peak_phase_lag.fig'],1)
                    cur_fig = gcf;
                    fig_data = allchild(get(cur_fig,'CurrentAxes'));
                    bin_edges = fig_data(1).BinEdges;
                    hist_data = fig_data(1).Data;
                    close all
                    all_data{epoch} = [all_data{epoch}, hist_data];
                end
            end
        end
        histogram(all_data{epoch},bin_edges);
        if sum(strcmp(animals,'I089')) == 0 && sum(strcmp(animals,'I110')) == 0
            saveas(gcf,[rootpath, '/peak_phase_lag_epoch', num2str(epoch), '.fig'])
        end
        close all
    end
end

%% 20: Sum Spike Cross-Correlograms

if enabled(20)
    days = [[1] [5]];
    all_data = zeros(size(days,2),1);
    for epoch = 1:size(days,2)
        for a = 1:length(animals)
            for day = days(:,epoch)'
                uiopen([rootpath, animals{a}, '\Day', num2str(day), '\Cross_correlation.fig'],1)
                cur_fig = gcf;
                fig_data = allchild(get(cur_fig,'CurrentAxes'));
                fig_xdata = fig_data(1).XData;
                fig_ydata = fig_data(1).YData;
                close all
                if ~isnan(fig_ydata(1))
                    all_data = all_data + zeros(size(days,2), size(fig_ydata,2));
                    all_data(epoch,:) = all_data(epoch,:) + fig_ydata;
                end
            end
        end
        bar(fig_xdata, all_data(epoch,:), 'EdgeColor', [0.0 0.0 0.0], 'FaceColor', [0.0 0.0 0.0], 'LineWidth', 1);
        box off
        hold on
        line([0 0], [ceil(max(all_data(epoch,:))), floor(min(all_data(epoch,:)))], 'Color', 'green', 'LineStyle', '--')
        if sum(strcmp(animals,'I089')) == 0 && sum(strcmp(animals,'I110')) == 0
            saveas(gcf,[rootpath, '/Cross_correlation_epoch', num2str(epoch), '.fig'])
        end
        close all
    end
end

%% 21: Plot M1 Spindle Co-firing 

if enabled(21)
    cycles = [[5;6], [1;10]];
    cycle_lables = {'Peak', 'Tail'};
    days = [1,2,3,4,5];
    control_offsets = [-5, -10];
    time_data = zeros(0, size(cycles,2));
    val_data = zeros(0, size(cycles,2));
    c_time_data = zeros(0, size(cycles,2));
    c_val_data = zeros(0, size(cycles,2));
    animal_data = zeros(0, size(cycles,2));
    c_animal_data = zeros(0, size(cycles,2));
    for day = days
        for a = 1:length(animals)
            for block = 1:2
                load([rootpath, animals{a}, '\Day', num2str(day), '\Sleep', num2str(block), '\Spindle_cofiring_data_M1.mat'])
                
                time_data = [time_data; reshape(peak_time(:,cycles(:)),[],size(cycles,2))];
                val_data = [val_data; reshape(peak_val(:,cycles(:)),[],size(cycles,2))];
                animal_data = [animal_data; repmat(a,[size(val_data,1)-size(animal_data,1),2])];
                                
                for c_o = control_offsets
                    load([rootpath, animals{a}, '\Day', num2str(day), '\Sleep', num2str(block), '\Spindle_cofiring_data_M1_C', num2str(c_o), '.mat'])
                    c_time_data = [c_time_data; reshape(peak_time(:,cycles(:)),[],size(cycles,2))];
                    c_val_data = [c_val_data; reshape(peak_val(:,cycles(:)),[],size(cycles,2))];
                    c_animal_data = [c_animal_data; repmat(a,[size(val_data,1)-size(c_animal_data,1),2])];
                end
            end
        end
    end
    
    for i = 1:size(cycles, 2)
        cycle_lables{size(cycles, 2)+i} = ['Control ', cycle_lables{i}];
    end
    
    animal_means = nan(length(animals),4);
    for a = 1:length(animals)
        animal_means(a,:) = [mean(val_data(animal_data(:,1) == a,:),1), mean(c_val_data(c_animal_data(:,1) == a,:),1)];
    end
    
    hold on
    bar(1:length(cycle_lables), [mean(val_data,1), mean(c_val_data,1)])
    errorbar(1:length(cycle_lables), [mean(val_data,1) mean(c_val_data,1)], [std(val_data,0,1,'omitnan')./sqrt(size(val_data,1)), std(c_val_data,0,1,'omitnan')./sqrt(size(c_val_data,1))], [std(val_data,0,1,'omitnan')./sqrt(size(val_data,1)), std(c_val_data,0,1,'omitnan')./sqrt(size(c_val_data,1))], 'Color', [0 0 0], 'LineWidth', 2);
    plot(animal_means')
    xticks(1:length(cycle_lables))
    xticklabels(cycle_lables)
    saveas(gcf,[rootpath, '/M1_spindel_cofiring_prob.fig'])
    close all
    
    animal_means = nan(length(animals),4);
    for a = 1:length(animals)
        animal_means(a,:) = [mean(time_data(animal_data(:,1) == a,:),1), mean(c_time_data(c_animal_data(:,1) == a,:),1)];
    end
    
    hold on
    bar(1:length(cycle_lables), [mean(time_data,1), mean(c_time_data,1)])
    errorbar(1:length(cycle_lables), [mean(time_data,1) mean(c_time_data,1)], [std(time_data,0,1,'omitnan')./sqrt(size(time_data,1)), std(c_time_data,0,1,'omitnan')./sqrt(size(c_time_data,1))], [std(time_data,0,1,'omitnan')./sqrt(size(time_data,1)), std(c_time_data,0,1,'omitnan')./sqrt(size(c_time_data,1))], 'Color', [0 0 0], 'LineWidth', 2);
    plot(animal_means')
    xticks(1:length(cycle_lables))
    xticklabels(cycle_lables)
    saveas(gcf,[rootpath, '/M1_spindel_cofiring_time.fig'])
    close all
end

%% 22: Plot CB Spindle Co-firing 

if enabled(22)
    cycles = [[5;6], [1;10]];
    cycle_lables = {'Peak', 'Tail'};
    days = [1,2,3,4,5];
    control_offsets = [-5, -10];
    time_data = zeros(0, size(cycles,2));
    val_data = zeros(0, size(cycles,2));
    c_time_data = zeros(0, size(cycles,2));
    c_val_data = zeros(0, size(cycles,2));
    animal_data = zeros(0, size(cycles,2));
    c_animal_data = zeros(0, size(cycles,2));
    for day = days
        for a = 1:length(animals)
            for block = 1:2
                load([rootpath, animals{a}, '\Day', num2str(day), '\Sleep', num2str(block), '\Spindle_cofiring_data_Cb.mat'])
                
                time_data = [time_data; reshape(peak_time(:,cycles(:)),[],size(cycles,2))];
                val_data = [val_data; reshape(peak_val(:,cycles(:)),[],size(cycles,2))];
                animal_data = [animal_data; repmat(a,[size(val_data,1)-size(animal_data,1),2])];
                                
                for c_o = control_offsets
                    load([rootpath, animals{a}, '\Day', num2str(day), '\Sleep', num2str(block), '\Spindle_cofiring_data_Cb_C', num2str(c_o), '.mat'])
                    c_time_data = [c_time_data; reshape(peak_time(:,cycles(:)),[],size(cycles,2))];
                    c_val_data = [c_val_data; reshape(peak_val(:,cycles(:)),[],size(cycles,2))];
                    c_animal_data = [c_animal_data; repmat(a,[size(val_data,1)-size(c_animal_data,1),2])];
                end
            end
        end
    end
    
    for i = 1:size(cycles, 2)
        cycle_lables{size(cycles, 2)+i} = ['Control ', cycle_lables{i}];
    end
    
    animal_means = nan(length(animals),4);
    for a = 1:length(animals)
        animal_means(a,:) = [mean(val_data(animal_data(:,1) == a,:),1), mean(c_val_data(c_animal_data(:,1) == a,:),1)];
    end
    
    hold on
    bar(1:length(cycle_lables), [mean(val_data,1), mean(c_val_data,1)])
    errorbar(1:length(cycle_lables), [mean(val_data,1) mean(c_val_data,1)], [std(val_data,0,1,'omitnan')./sqrt(size(val_data,1)), std(c_val_data,0,1,'omitnan')./sqrt(size(c_val_data,1))], [std(val_data,0,1,'omitnan')./sqrt(size(val_data,1)), std(c_val_data,0,1,'omitnan')./sqrt(size(c_val_data,1))], 'Color', [0 0 0], 'LineWidth', 2);
    plot(animal_means')
    xticks(1:length(cycle_lables))
    xticklabels(cycle_lables)
    saveas(gcf,[rootpath, '/Cb_spindel_cofiring_prob.fig'])
    close all
    
    animal_means = nan(length(animals),4);
    for a = 1:length(animals)
        animal_means(a,:) = [mean(time_data(animal_data(:,1) == a,:),1), mean(c_time_data(c_animal_data(:,1) == a,:),1)];
    end
    
    hold on
    bar(1:length(cycle_lables), [mean(time_data,1), mean(c_time_data,1)])
    errorbar(1:length(cycle_lables), [mean(time_data,1) mean(c_time_data,1)], [std(time_data,0,1,'omitnan')./sqrt(size(time_data,1)), std(c_time_data,0,1,'omitnan')./sqrt(size(c_time_data,1))], [std(time_data,0,1,'omitnan')./sqrt(size(time_data,1)), std(c_time_data,0,1,'omitnan')./sqrt(size(c_time_data,1))], 'Color', [0 0 0], 'LineWidth', 2);
    plot(animal_means')
    xticks(1:length(cycle_lables))
    xticklabels(cycle_lables)
    saveas(gcf,[rootpath, '/Cb_spindel_cofiring_time.fig'])
    close all
end

%% 23: GPFA Factor Correlation (Lemke supp 12b)

if enabled(23)
    days = [[1;2] [4;5]];
    M1_succ_traj_corr = zeros(length(animals), size(days, 2));
    M1_fail_traj_corr = zeros(length(animals), size(days, 2));
    M1_all_traj_corr = zeros(length(animals), size(days, 2));
    Cb_succ_traj_corr = zeros(length(animals), size(days, 2));
    Cb_fail_traj_corr = zeros(length(animals), size(days, 2));
    Cb_all_traj_corr = zeros(length(animals), size(days, 2));
    
    M1_full_tbl = cell(2,size(days, 2)); %S/F,epoch
    Cb_full_tbl = cell(2,size(days, 2)); %S/F,epoch
    
    animal = zeros(size(M1_succ_traj_corr));
    for animal_idx = 1:length(animals)
        
        M1_succ_traj_corr(animal_idx,:) = mean(cellfun(@mean,animal_data{animal_idx}.M1_succ_traj_corr_full2(days)),1,'omitnan');
        M1_fail_traj_corr(animal_idx,:) = mean(cellfun(@mean,animal_data{animal_idx}.M1_fail_traj_corr_full2(days)),1,'omitnan');
        Cb_succ_traj_corr(animal_idx,:) = mean(cellfun(@mean,animal_data{animal_idx}.Cb_succ_traj_corr_full2(days)),1,'omitnan');
        Cb_fail_traj_corr(animal_idx,:) = mean(cellfun(@mean,animal_data{animal_idx}.Cb_fail_traj_corr_full2(days)),1,'omitnan');

%         M1_succ_traj_corr(animal_idx,:) = mean(animal_data{animal_idx}.M1_succ_traj_corr(days),1,'omitnan');
%         M1_fail_traj_corr(animal_idx,:) = mean(animal_data{animal_idx}.M1_fail_traj_corr(days),1,'omitnan');
%         M1_all_traj_corr(animal_idx,:) = mean(animal_data{animal_idx}.M1_all_traj_corr(days),1,'omitnan');
%         Cb_succ_traj_corr(animal_idx,:) = mean(animal_data{animal_idx}.Cb_succ_traj_corr(days),1,'omitnan');
%         Cb_fail_traj_corr(animal_idx,:) = mean(animal_data{animal_idx}.Cb_fail_traj_corr(days),1,'omitnan');
%         Cb_all_traj_corr(animal_idx,:) = mean(animal_data{animal_idx}.Cb_all_traj_corr(days),1,'omitnan');
        
        for epoch = 1:size(days, 2)
            data = animal_data{animal_idx}.M1_succ_traj_corr_full2{days(:,epoch)};
            data(:,3) = animal_idx;
            M1_full_tbl{1,epoch} = cat(1,M1_full_tbl{1,epoch},data);
            
            data = animal_data{animal_idx}.M1_fail_traj_corr_full2{days(:,epoch)};
            data(:,3) = animal_idx;
            M1_full_tbl{2,epoch} = cat(1,M1_full_tbl{2,epoch},data);
            
%             data = animal_data{animal_idx}.M1_all_traj_corr_full{days(:,epoch)};
%             data(:,3) = animal_idx;
%             M1_full_tbl{3,epoch} = cat(1,M1_full_tbl{3,epoch},data);
            
            data = animal_data{animal_idx}.Cb_succ_traj_corr_full2{days(:,epoch)};
            data(:,3) = animal_idx;
            Cb_full_tbl{1,epoch} = cat(1,Cb_full_tbl{1,epoch},data);
            
            data = animal_data{animal_idx}.Cb_fail_traj_corr_full2{days(:,epoch)};
            data(:,3) = animal_idx;
            Cb_full_tbl{2,epoch} = cat(1,Cb_full_tbl{2,epoch},data);
            
%             data = animal_data{animal_idx}.Cb_all_traj_corr_full{days(:,epoch)};
%             data(:,3) = animal_idx;
%             Cb_full_tbl{3,epoch} = cat(1,Cb_full_tbl{3,epoch},data);
        end
    end
    
    %M1 Success trials across epoch
    tbl = zeros(0,3);
    for epoch = 1:size(days, 2)
        e_data = M1_full_tbl{1,epoch};
        e_data(:,2) = epoch;
        tbl = [tbl;e_data]; %#ok<AGROW>
    end
    tbl = array2table(tbl,'VariableNames',{'data','relavent_condition','irrelevant_condition'});
    %tbl.relavent_condition = nominal(tbl.relavent_condition);
    tbl.irrelevant_condition = nominal(tbl.irrelevant_condition);
    formula = 'data ~ 1 + relavent_condition + (1 | irrelevant_condition)';
    lme_all = fitlme(tbl,formula);
    p_val = coefTest(lme_all);
        
    figure
    hold on
    line(mean(days,1), M1_succ_traj_corr', 'LineWidth', 1)
    errorbar(mean(days,1), mean(M1_succ_traj_corr,1,'omitnan'), std(M1_succ_traj_corr,0,1,'omitnan')/sqrt(length(animals)), std(M1_succ_traj_corr,0,1,'omitnan')/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    axis([mean(days(:,1))-1 mean(days(:,end))+1 0 1])
    ylabel('Trajectory Correlation');
    title(['P-val: ', num2str(p_val)]);
    if sum(strcmp(animals,'I110')) == 0
        saveas(gcf,[rootpath, '/M1_succ_traj_corr-2.fig'])
    end
    hold off
    close all
    
    %M1 Fail trials across epoch
    tbl = zeros(0,3);
    for epoch = 1:size(days, 2)
        e_data = M1_full_tbl{2,epoch};
        e_data(:,2) = epoch;
        tbl = [tbl;e_data]; %#ok<AGROW>
    end
    tbl = array2table(tbl,'VariableNames',{'data','relavent_condition','irrelevant_condition'});
    %tbl.relavent_condition = nominal(tbl.relavent_condition);
    tbl.irrelevant_condition = nominal(tbl.irrelevant_condition);
    formula = 'data ~ 1 + relavent_condition + (1 | irrelevant_condition)';
    lme_all = fitlme(tbl,formula);
    p_val = coefTest(lme_all);
    
    figure
    hold on
    line(mean(days,1), M1_fail_traj_corr', 'LineWidth', 1)
    errorbar(mean(days,1), mean(M1_fail_traj_corr,1,'omitnan'), std(M1_fail_traj_corr,0,1,'omitnan')/sqrt(length(animals)), std(M1_fail_traj_corr,0,1,'omitnan')/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    axis([mean(days(:,1))-1 mean(days(:,end))+1 0 1])
    ylabel('Trajectory Correlation');
    title(['P-val: ', num2str(p_val)]);
    if sum(strcmp(animals,'I110')) == 0
        saveas(gcf,[rootpath, '/M1_fail_traj_corr-2.fig'])
    end
    hold off
    close all
    
%     %M1 all trials across epoch
%     tbl = zeros(0,3);
%     for epoch = 1:size(days, 2)
%         e_data = M1_full_tbl{3,epoch};
%         e_data(:,2) = epoch;
%         tbl = [tbl;e_data]; %#ok<AGROW>
%     end
%     tbl = array2table(tbl,'VariableNames',{'data','relavent_condition','irrelevant_condition'});
%     %tbl.relavent_condition = nominal(tbl.relavent_condition);
%     tbl.irrelevant_condition = nominal(tbl.irrelevant_condition);
%     formula = 'data ~ 1 + relavent_condition + (1 | irrelevant_condition)';
%     lme_all = fitlme(tbl,formula);
%     p_val = coefTest(lme_all);
%     
%     figure
%     hold on
%     line(mean(days,1), M1_all_traj_corr', 'LineWidth', 1)
%     errorbar(mean(days,1), mean(M1_all_traj_corr,1,'omitnan'), std(M1_all_traj_corr,0,1,'omitnan')/sqrt(length(animals)), std(M1_all_traj_corr,0,1,'omitnan')/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
%     axis([mean(days(:,1))-1 mean(days(:,end))+1 0 1])
%     ylabel('Trajectory Correlation');
%     title(['P-val: ', num2str(p_val)]);
%     if sum(strcmp(animals,'I110')) == 0
%         saveas(gcf,[rootpath, '/M1_all_traj_corr.fig'])
%     end
%     hold off
%     close all
    
    %Cb Success trials across epoch
    tbl = zeros(0,3);
    for epoch = 1:size(days, 2)
        e_data = Cb_full_tbl{1,epoch};
        e_data(:,2) = epoch;
        tbl = [tbl;e_data]; %#ok<AGROW>
    end
    tbl = array2table(tbl,'VariableNames',{'data','relavent_condition','irrelevant_condition'});
    %tbl.relavent_condition = nominal(tbl.relavent_condition);
    tbl.irrelevant_condition = nominal(tbl.irrelevant_condition);
    formula = 'data ~ 1 + relavent_condition + (1 | irrelevant_condition)';
    lme_all = fitlme(tbl,formula);
    p_val = coefTest(lme_all);
    
    figure
    hold on
    line(mean(days,1), Cb_succ_traj_corr', 'LineWidth', 1)
    errorbar(mean(days,1), mean(Cb_succ_traj_corr,1,'omitnan'), std(Cb_succ_traj_corr,0,1,'omitnan')/sqrt(length(animals)), std(Cb_succ_traj_corr,0,1,'omitnan')/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    axis([mean(days(:,1))-1 mean(days(:,end))+1 0 1])
    ylabel('Trajectory Correlation');
    title(['P-val: ', num2str(p_val)]);
    if sum(strcmp(animals,'I089')) == 0
        saveas(gcf,[rootpath, '/Cb_succ_traj_corr-2.fig'])
    end
    hold off
    close all
    
    %Cb Fail trials across epoch
    tbl = zeros(0,3);
    for epoch = 1:size(days, 2)
        e_data = Cb_full_tbl{2,epoch};
        e_data(:,2) = epoch;
        tbl = [tbl;e_data]; %#ok<AGROW>
    end
    tbl = array2table(tbl,'VariableNames',{'data','relavent_condition','irrelevant_condition'});
    %tbl.relavent_condition = nominal(tbl.relavent_condition);
    tbl.irrelevant_condition = nominal(tbl.irrelevant_condition);
    formula = 'data ~ 1 + relavent_condition + (1 | irrelevant_condition)';
    lme_all = fitlme(tbl,formula);
    p_val = coefTest(lme_all);
    
    figure
    hold on
    line(mean(days,1), Cb_fail_traj_corr', 'LineWidth', 1)
    errorbar(mean(days,1), mean(Cb_fail_traj_corr,1,'omitnan'), std(Cb_fail_traj_corr,0,1,'omitnan')/sqrt(length(animals)), std(Cb_fail_traj_corr,0,1,'omitnan')/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
    axis([mean(days(:,1))-1 mean(days(:,end))+1 0 1])
    ylabel('Trajectory Correlation');
    title(['P-val: ', num2str(p_val)]);
    if sum(strcmp(animals,'I089')) == 0
        saveas(gcf,[rootpath, '/Cb_fail_traj_corr-2.fig'])
    end
    hold off
    close all
    
%     %Cb all trials across epoch
%     tbl = zeros(0,3);
%     for epoch = 1:size(days, 2)
%         e_data = Cb_full_tbl{3,epoch};
%         e_data(:,2) = epoch;
%         tbl = [tbl;e_data]; %#ok<AGROW>
%     end
%     tbl = array2table(tbl,'VariableNames',{'data','relavent_condition','irrelevant_condition'});
%     %tbl.relavent_condition = nominal(tbl.relavent_condition);
%     tbl.irrelevant_condition = nominal(tbl.irrelevant_condition);
%     formula = 'data ~ 1 + relavent_condition + (1 | irrelevant_condition)';
%     lme_all = fitlme(tbl,formula);
%     p_val = coefTest(lme_all);
%     
%     figure
%     hold on
%     line(mean(days,1), Cb_all_traj_corr', 'LineWidth', 1)
%     errorbar(mean(days,1), mean(Cb_all_traj_corr,1,'omitnan'), std(Cb_all_traj_corr,0,1,'omitnan')/sqrt(length(animals)), std(Cb_all_traj_corr,0,1,'omitnan')/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
%     axis([mean(days(:,1))-1 mean(days(:,end))+1 0 1])
%     ylabel('Trajectory Correlation');
%     title(['P-val: ', num2str(p_val)]);
%     if sum(strcmp(animals,'I089')) == 0
%         saveas(gcf,[rootpath, '/Cb_all_traj_corr.fig'])
%     end
%     hold off
%     close all
    
    
    for day_idx = 1:size(days,2)
        day = mean(days(:,day_idx),1);

        %M1 Days trials Success vs Fail
        tbl = zeros(0,3);
        for outcome = 1:2
            e_data = M1_full_tbl{outcome,day_idx};
            e_data(:,2) = outcome;
            tbl = [tbl;e_data]; %#ok<AGROW>
        end
        tbl = array2table(tbl,'VariableNames',{'data','relavent_condition','irrelevant_condition'});
        tbl.relavent_condition = nominal(tbl.relavent_condition);
        tbl.irrelevant_condition = nominal(tbl.irrelevant_condition);
        formula = 'data ~ 1 + relavent_condition + (1 | irrelevant_condition)';
        lme_all = fitlme(tbl,formula);
        p_val = coefTest(lme_all);
        
        M1_day_corrs = [M1_succ_traj_corr(:,day_idx)'; M1_fail_traj_corr(:,day_idx)'];
        figure
        hold on
        line([1 2], M1_day_corrs, 'LineWidth', 1)
        errorbar([1 2], mean(M1_day_corrs,2), std(M1_day_corrs,0,2)/sqrt(length(animals)), std(M1_day_corrs,0,2)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
        axis([0.5 2.5 0 1])
        xticks([1 2])
        xticklabels({'Success','Failure'})
        ylabel('Trajectory Correlation');
        title(['P-val: ', num2str(p_val)]);
        if sum(strcmp(animals,'I110')) == 0
            saveas(gcf,[rootpath, '/M1_SvF_traj_corr_day', num2str(day), '-2.fig'])
        end
        hold off
        close all
        
        %Cb Days trials Success vs Fail
        tbl = zeros(0,3);
        for outcome = 1:2
            e_data = Cb_full_tbl{outcome,day_idx};
            e_data(:,2) = outcome;
            tbl = [tbl;e_data]; %#ok<AGROW>
        end
        tbl = array2table(tbl,'VariableNames',{'data','relavent_condition','irrelevant_condition'});
        tbl.relavent_condition = nominal(tbl.relavent_condition);
        tbl.irrelevant_condition = nominal(tbl.irrelevant_condition);
        formula = 'data ~ 1 + relavent_condition + (1 | irrelevant_condition)';
        lme_all = fitlme(tbl,formula);
        p_val = coefTest(lme_all);
        
        Cb_day_corrs = [Cb_succ_traj_corr(:,day_idx)'; Cb_fail_traj_corr(:,day_idx)'];
        figure
        hold on
        line([1 2], Cb_day_corrs, 'LineWidth', 1)
        errorbar([1 2], mean(Cb_day_corrs,2), std(Cb_day_corrs,0,2)/sqrt(length(animals)), std(Cb_day_corrs,0,2)/sqrt(length(animals)), 'Color', [0 0 0], 'LineWidth', 2);
        axis([0.5 2.5 0 1])
        xticks([1 2])
        xticklabels({'Success','Failure'})
        ylabel('Trajectory Correlation');
        title(['P-val: ', num2str(p_val)]);
        if sum(strcmp(animals,'I089')) == 0
            saveas(gcf,[rootpath, '/Cb_SvF_traj_corr_day', num2str(day), '-2.fig'])
        end
        hold off
        close all
    end
    
    clearvars -except rootpath origin_rootpath animals enabled animal_data BO_animals;
end

%% 24: Block 1 vs 2 Success Rate and Reach Duration

if enabled(24)
    days = [[1;2] [4;5]];
    data = nan(0,6); %(epoch, animal, block, outcome, touch_delay, retract_delay)
    for a = 1:length(animals)
        if a > (length(animals) - length(BO_animals))
            load(['D:\Pierson_Data_Analysis\behavior_only_animals\',animals{a},'/Parameters.mat'])
        else
            load([rootpath,animals{a},'/Parameters.mat'])
        end
        if param.blocks ~= 2
            error()
        end
        for epoch = 1:size(days,2)
            for day = days(:,epoch)'
                for block = 1:param.blocks
                    gui_data = animal_data{a}.GUI_data{day,block};
                    for trial = 1:size(gui_data,1)
                        frame_nums = str2num(char(gui_data{trial,2})); %#ok<ST2NM>
                        outcome = str2double(gui_data{trial,3});
                        if outcome == 1 
                            reach = frame_nums(end-2);
                            touch = frame_nums(end-1);
                            retract = frame_nums(end);
                        elseif outcome == 0 && frame_nums(end) == 1
                            reach = frame_nums(end-4);
                            touch = frame_nums(end-3);
                            retract = frame_nums(end-1);
                        else
                            continue
                        end
                        data_line = [epoch, a, block, outcome, (touch - reach)/param.Camera_framerate, (retract - reach)/param.Camera_framerate];
                        data = cat(1, data, data_line);
                    end
                end
            end
        end
    end
    for epoch = 1:size(days,2)
        e_data = data(data(:,1) == epoch,:);
        idx_of_interest = 4; %4 = outcome; 5 = touch_delay; 6 = retract_delay
        data_of_interest = [mean(e_data(e_data(:,3) == 1,idx_of_interest)), mean(e_data(e_data(:,3) == 2,idx_of_interest))];
        bar(1:2,data_of_interest)
        close all
        
        e_data = data(data(:,1) == epoch,:);
        idx_of_interest = 5; %4 = outcome; 5 = touch_delay; 6 = retract_delay
        data_of_interest = [mean(e_data(e_data(:,3) == 1,idx_of_interest)), mean(e_data(e_data(:,3) == 2,idx_of_interest))];
        bar(1:2,data_of_interest)
        close all
        
        e_data = data(data(:,1) == epoch,:);
        idx_of_interest = 6; %4 = outcome; 5 = touch_delay; 6 = retract_delay
        data_of_interest = [mean(e_data(e_data(:,3) == 1,idx_of_interest)), mean(e_data(e_data(:,3) == 2,idx_of_interest))];
        bar(1:2,data_of_interest)
        close all
    end
    clearvars -except rootpath origin_rootpath animals enabled animal_data BO_animals;
end
        
beep
disp 'Analysis Complete.'