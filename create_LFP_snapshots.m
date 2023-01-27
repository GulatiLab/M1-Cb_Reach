function [snapshots]=create_LFP_snapshots(LFP_trace,center_timestamps,limits,Fs)
if ~ismatrix(LFP_trace)
    error('The LFP trace is not a matrix. Size should be [channels x samples].')
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
center_timestamps = shiftdim(center_timestamps,-1);
center_timestamps = round(center_timestamps*Fs);
limits = round(limits*Fs);
ss_relative_idxs = limits(1):limits(2);
snapshot_idxs = ss_relative_idxs + center_timestamps;
snapshot_idxs = reshape(snapshot_idxs,[1,length(snapshot_idxs(:))]);
snapshots = nan(size(LFP_trace,1), size(snapshot_idxs,2));
for x = 1:size(LFP_trace,1)
    snapshots(1,:) = LFP_trace(1,snapshot_idxs);
end
snapshots = reshape(snapshots,[size(LFP_trace,1),length(ss_relative_idxs),length(center_timestamps)]);
