function traj_plot = plot_trajectories(traj_struct)
traj_plot = figure;
for i = 1:length(traj_struct)
    d1_data = traj_struct(i).data(1,:);
    d2_data = traj_struct(i).data(2,:);
    epochs = traj_struct(i).epochStarts;
    colors = traj_struct(i).epochColors;
    line(d2_data(1:epochs(2)), d1_data(1:epochs(2)),'Color', colors(1,:));
    line(d2_data(epochs(2):epochs(3)), d1_data(epochs(2):epochs(3)),'Color', colors(2,:));
    line(d2_data(epochs(3):length(d2_data)), d1_data(epochs(3):length(d1_data)),'Color', colors(3,:));
end
