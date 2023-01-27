function traj_correlation = trajectory_consistency_calc2(varargin)
traj_struct = varargin{1};
if nargin == 2
    traj_mean = varargin{2};
end
traj_correlation = zeros(size(traj_struct,3),1);
for i = 1:size(traj_struct,3)
    if nargin == 1
        traj_mean = mean(traj_struct(:,:,[1:(i-1) (i+1):end]),3);
    end
    traj = traj_struct(:,:,i);
    traj = traj(:,1:size(traj_mean,2));
    dim_corr = eye(size(traj_mean,1)) .* corr(traj', traj_mean');
    traj_correlation(i) = mean(sum(dim_corr));
end