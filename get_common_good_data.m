function [data1_common, data2_common] = get_common_good_data(data1, data2, data1_bads, data2_bads, dim)
% Spilt start_set into two sub-sets based on whether the associated trial
% was a success or a failure.
%
% Inputs:
%       start_set           - Data set to be split (can be of arbitrary dimensionallity)
%       trial_data          - GUI data from the video
%       bad_trials          - A list of bad trials that were omitted from start_set
%       dim           - the dimension of start_set that distiguishes trials
%
% Outputs:
%       succuess_subset     - the subset of start_set associated with successful trials (dimensionallity otherwise unchanged)
%       failure_subset      - the subset of start_set associated with unsuccessful trials (dimensionallity otherwise unchanged)
data1_common = data1;
data2_common = data2;
dim_length = length(data1_bads) + size(data1_common,dim);
data1_bads = sort([data1_bads (dim_length+1)]);
data2_bads = sort([data2_bads (dim_length+1)]);
i1 = 1;
i2 = 1;
j1 = 1;
j2 = 1;
idx_cells = cell(1,ndims(data1));
idx_cells(:) = {':'};
for i = 1:dim_length
    if (data1_bads(j1) == i) && (data2_bads(j2) == i)
        j1 = j1 + 1;
        j2 = j2 + 1;
    elseif (data1_bads(j1) == i)
        idx_cells{dim} = i2;
        data2_common(idx_cells{:}) = [];
        j1 = j1 + 1;
    elseif (data2_bads(j2) == i)
        idx_cells{dim} = i1;
        data1_common(idx_cells{:}) = [];
        j2 = j2 + 1;
    else
        i1 = i1 + 1;
        i2 = i2 + 1;
    end
end


end