function traj_errors = trajectory_error_calc(traj_struct, traj_mean)
traj_errors = zeros(length(traj_struct),1);
for i = 1:length(traj_struct)
    traj = traj_struct(i).data;
    traj = traj(:,1:size(traj_mean,2));
    diff = traj - traj_mean;
    diff = diff.*diff;
    traj_errors(i) = sum(diff(:));
end
    