function [snapshots]=create_spike_TS_snapshots(spike_timestamps,center_timestamps,limits,Fs)
if ~isrow(spike_timestamps)
    error('The timestamps of the spikes is not a row vector.')
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

snapshots = cell(1,1,length(center_timestamps));
for event = center_timestamps
    spike_snapshot_idxs = spike_timestamps > center_timestamps(event)+limits(1) & spike_timestamps < center_timestamps(event)+limits(2);
    snapshots{event} = spike_timestamps(spike_snapshot_idxs);
    snapshots{event} = snapshots{event} - center_timestamps(event);
end