function [snapshots]=create_spike_bin_snapshots(spike_timestamps,center_timestamps,limits,Fs)
if ~isrow(spike_timestamps)
    error('The timestamps of the spikes is not a row vector.')
end
if iscolumn(center_timestamps)
    center_timestamps = center_timestamps';
end
if ~isrow(center_timestamps)
    error('The timestamps of the snapshot centers is not a row vector.')
end
if ~(isrow(limits) && length(limits) == 2)
    error('limits must be a row vector of length 2.')
end
if ~(isscalar(Fs))
    error('Fs must be scalar.')
end
limits = round(limits*Fs);
ss_relative_idxs = limits(1):limits(2);
ss_bin_edges = [ss_relative_idxs ss_relative_idxs(end)+diff(ss_relative_idxs(1:2))];
ss_bin_edges = ss_bin_edges - (diff(ss_relative_idxs(1:2)) / 2);

snapshots = nan(1,length(ss_relative_idxs),length(center_timestamps));
for event = 1:length(center_timestamps)
    spike_snapshot_idxs = spike_timestamps > center_timestamps(event)+limits(1) & spike_timestamps < center_timestamps(event)+limits(2);
    snapshot_timestamps = spike_timestamps(spike_snapshot_idxs);
    snapshot_timestamps = snapshot_timestamps - center_timestamps(event);
    snapshot_timestamps = round(snapshot_timestamps * Fs);
    snapshots(1,:,event) = histcounts(snapshot_timestamps,ss_bin_edges);
end