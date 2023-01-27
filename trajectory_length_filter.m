function filt_traj_struct = trajectory_length_filter(traj_struct,filt_ratio)
traj_cell = {traj_struct.data};
size_cell = cellfun(@size,traj_cell,'UniformOutput', false);
size_array = cell2mat(size_cell');
s_size_array = sort(size_array(:,2));
min_comp_len = size_array(round(length(s_size_array)*filt_ratio),2);
filt_traj_struct = traj_struct;
filt_traj_struct(size_array(:,2)>min_comp_len) = [];
    


