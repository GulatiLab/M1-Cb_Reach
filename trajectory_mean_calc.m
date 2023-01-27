function mean_traj = trajectory_mean_calc(traj_struct)
traj_cell = {traj_struct.data};
size_cell = cellfun(@size,traj_cell,'UniformOutput', false);
size_array = cell2mat(size_cell');
min_length = min(size_array(:,2));
traj_array = zeros(size_array(1,1),min_length,length(traj_struct));
for i = 1:min_length
    traj_array(:,i,:) = cell2mat(cellfun(@(x)(x(:,i)),traj_cell,'UniformOutput', false));
end
mean_traj = mean(traj_array,3);
    


