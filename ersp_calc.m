function [ersp_data, itc_data, times, freqs] = ersp_calc(snapshots_c, Fs)
% Calculate ERSP and ITC data with newtimef().
%
% Inputs:
%       snapshots_c     - LFP data to use with newtimef (chan x time x trial)
%       Fs              - Sample rate (per second) of LFP recording
%
% Outputs:
%       ersp_data       - ersp results from newtimef (chan x frequency x time x trial)
%       itc_data        - itc results from newtimef (chan x frequency x time x trial)
%       times           - time lables for the 2nd dimension of the ersp and itc data
%       freqs           - frequency lables for the 3rd dimension of the ersp and itc data

set(0,'DefaultFigureVisible','off');

sz=size(snapshots_c);
ersp_data=zeros(sz(1),117,200,size(snapshots_c,3));
itc_data=zeros(sz(1),117,200);
frames=round(6.5 * Fs);

if isempty(snapshots_c)
    freqs = 1.5:(58.5/116):60;
    times = -3314:(5102/199):1788;
else
    for i=1:sz(1)
        clear data
        data=squeeze(snapshots_c(i,1:frames,:));
        
        [~,itc_data(i,:,:),~,times,freqs,~,~,ersp_data(i,:,:,:)] = newtimef(data,frames,[round(-4 * Fs) round(2.5 * Fs)],Fs,[2 0.5],...
            'baseline',NaN,'freqs', [1.5 60],'verbose','off','trialbase','on');
        close all
    end
end

set(0,'DefaultFigureVisible','on');
end