function new_traj_struct = interpolate_trajectories(traj_struct)
if isempty(traj_struct)
    new_traj_struct = traj_struct;
    return
end
new_traj_struct = traj_struct;
epoch_starts = reshape([traj_struct.epochStarts],length(traj_struct(1).epochStarts),length(traj_struct));
traj_lengths = [traj_struct.T];
epoch_bounds = cat(1,epoch_starts,(traj_lengths));
epoch_lengths = diff(epoch_bounds);
for epoch = 1:size(epoch_lengths,1)
    max_epoch_len = max(epoch_lengths(epoch,:));
    if epoch ~= size(epoch_lengths,1)
        max_epoch_len = max_epoch_len+1;
    end
    for i = 1:length(new_traj_struct)
        data = traj_struct(i).data(:,epoch_bounds(epoch,i):(epoch_bounds(epoch+1,i)));
        if epoch_bounds(epoch,i) == (epoch_bounds(epoch+1,i))
            new_times = ones(1,max_epoch_len) * epoch_bounds(epoch,i);
        else
            new_times = epoch_bounds(epoch,i):(size(data,2)-1)/(max_epoch_len-1):(epoch_bounds(epoch+1,i));
        end
        if length(new_times) ~= max_epoch_len
            error('Something went wrong')
        end
        if epoch_bounds(epoch,i) == (epoch_bounds(epoch+1,i))
            new_data = ones(max_epoch_len,size(data,1)) .* data';
        else
            new_data = interp1(epoch_bounds(epoch,i):(epoch_bounds(epoch+1,i)),data',new_times);
        end
        if epoch ~= size(epoch_lengths,1)
            new_data(end,:) = [];
        end
        if epoch == 1 
            new_traj_struct(i).data = new_data';
            new_traj_struct(i).time_steps = new_times;
            new_traj_struct(i).epochStarts = 1;
        else
            new_traj_struct(i).epochStarts = [new_traj_struct(i).epochStarts length(new_traj_struct(i).data)+1];
            new_traj_struct(i).data = cat(2,new_traj_struct(i).data,new_data');
            new_traj_struct(i).time_steps = [new_traj_struct(i).time_steps new_times];
            
        end
    end
end