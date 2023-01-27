function [snapshots_CHmean_removed] = evoked_response_removal(snapshots_c)
% Subtract the trial mean within each channel and timestep.
%
% Inputs:
%       snapshots_c                 - LFP snapshots (channel x time x trial)
%
% Outputs:
%       snapshots_CHmean_removed    - the input snapshots with the mean across time steps subtracted

snapshots_CHmean_removed = zeros(size(snapshots_c));
for ch=1:size(snapshots_c,1)
    single_channel_data = squeeze(snapshots_c(ch,:,:));
    mean_erp = mean(single_channel_data,2);
    snapshots_CHmean_removed(ch,:,:) = bsxfun(@minus,single_channel_data,mean_erp);
end