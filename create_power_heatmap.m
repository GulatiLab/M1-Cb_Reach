function [out_fig] = create_power_heatmap(data, times, freqs)
% Create a single spectrogram heat map from the data
%
% Inputs:
%       ersp_data       - ERSP data from newtimef (channel x frequency x time x trials)
%       times           - time lables for the 2nd dimension of ersp_data
%       freqs           - freqency lables for the 3rd dimension of ersp_data
%
% Outputs:
%       out_fig         - The handle to the output figure

bl=mean(data(:,:,times>-1500&times<-500,:),3);
bl_std=std(data(:,:,times>-1500&times<-500,:),[],3);
datanorm=bsxfun(@minus,data,bl);
datanorm=bsxfun(@rdivide,datanorm,bl_std);
datanormm=squeeze(mean(mean(datanorm,4),1));
out_fig = figure;
pcolor(times,freqs,datanormm)
shading interp
axis xy
axis([-1000 1500 1.5 20])
caxis([0 5])

colorbar
title('Power')
end