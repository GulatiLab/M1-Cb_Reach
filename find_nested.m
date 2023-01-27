function [nested_idxs] = find_nested(ref_event_times,test_event_times,nesting_threshold)
if isempty(ref_event_times) || isempty(test_event_times)
    nested_idxs = [];
    return
end

ref_event_times = squeeze(ref_event_times);
test_event_times = squeeze(test_event_times);
if ~isvector(ref_event_times)
    error('Reference timestamps are not a vector')
end
if ~isvector(test_event_times)
    error('Test timestamps are not a vector')
end

diffs = test_event_times - ref_event_times';
diffs(diffs < 0) = inf;
nearest_dist = min(diffs,[],1);
nested_idxs = nearest_dist < nesting_threshold;
