function [ersp_diff_data, itc_diff_data, times, freqs] = ersp_diff_calc(snapshots1_c, snapshots2_c, Fs)
% Calculate ERSP and ITC data between two data sets. WIP
%
% Inputs:
%       snapshots1_c    - First data set
%       snapshots2_c    - Second data set
%       Fs              - Sample rate (per second) of LFP recording
%
%Outputs:
%       ersp_diff_data  - ERSP results (channel x ??)
%       itc_diff_data   - ITC results (channel x ??)
%       times           - time stamps corrisponding to the x axis of the ERSP/ITC results
%       freqs           - frequency bands corrisponding to the y axis of the ERSP/ITC results

set(0,'DefaultFigureVisible','off');
sz=size(snapshots1_c);
itc_diff_data=cell(sz(1),3);
ersp_diff_data=cell(sz(1),3);
frames=6500;

for i=1:sz(1)
    clear diff_data
    diff_data = {squeeze(snapshots1_c(i,1:frames,:)), squeeze(snapshots2_c(i,1:frames,:))};
    
    [ersp_diff_data(i,:),itc_diff_data(i,:),~,times,freqs,~,~] = newtimef(diff_data,frames,[-4000 2500],Fs,[2 0.5],...
        'baseline',NaN,'freqs', [1.5 60],'verbose','off','trialbase','on','commonbase','off');
    close all
end

set(0,'DefaultFigureVisible','on');
end