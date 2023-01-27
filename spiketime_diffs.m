function [diffs, idx1, idx2] = spiketime_diffs(timestamps1, timestamps2, window)

if ~isvector(timestamps1) 
    warning('timestamps1 is not a vector')
end
if ~isvector(timestamps2)
    warning('timestamps2 is not a vector')
end
%make timestamps Nx1 vectors
timestamps1 = timestamps1(:);
timestamps2 = timestamps2(:);

ts1_mat = repmat(timestamps1,1,length(timestamps2));
ts2_mat = repmat(timestamps2',length(timestamps1),1);

diff_mat = ts1_mat - ts2_mat;

idx1_mat = repmat([1:length(timestamps1)]',1,length(timestamps2));
idx2_mat = repmat([1:length(timestamps2)],length(timestamps1),1);

diffs = diff_mat(:);
idx1 = idx1_mat(:);
idx2 = idx2_mat(:);

out_of_bounds = (diffs < window(1)) | (diffs > window(2));
diffs(out_of_bounds) = [];
idx1(out_of_bounds) = [];
idx2(out_of_bounds) = [];
