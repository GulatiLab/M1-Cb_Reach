function new_traj_struct = remove_outlier_trajectories(traj_struct, stdv_cutoff)
traj_cell = {traj_struct.data};
size_cell = cellfun(@size,traj_cell,'UniformOutput', false);
size_array = cell2mat(size_cell');
mean_length = mean(size_array(:,2));
stdv_length = std(size_array(:,2));
filter_bool = (size_array(:,2) >= (mean_length - (stdv_cutoff*stdv_length))) & (size_array(:,2) <= (mean_length + (stdv_cutoff*stdv_length)));
new_traj_struct = traj_struct(filter_bool);