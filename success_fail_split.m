function [success_subset, failure_subset] = success_fail_split(start_set, trial_data, bad_trials, trial_idx)
% Spilt start_set into two sub-sets based on whether the associated trial
% was a success or a failure.
%
% Inputs:
%       start_set           - Data set to be split (can be of arbitrary dimensionallity)
%       trial_data          - GUI data from the video
%       bad_trials          - A list of bad trials that were omitted from start_set
%       trial_idx           - the dimension of start_set that distiguishes trials
%
% Outputs:
%       succuess_subset     - the subset of start_set associated with successful trials (dimensionallity otherwise unchanged)
%       failure_subset      - the subset of start_set associated with unsuccessful trials (dimensionallity otherwise unchanged)

idx_cells = cell(1,ndims(start_set));
idx_cells(:) = {':'};
if iscell(trial_data)
    trial_codes = str2double(trial_data(:,3));
else
    trial_codes = trial_data(:,3);
end
trial_codes(bad_trials) = [];

idx_cells{trial_idx} = (trial_codes==1);
success_subset = start_set(idx_cells{:});

idx_cells{trial_idx} = (trial_codes==0);
failure_subset = start_set(idx_cells{:});

end