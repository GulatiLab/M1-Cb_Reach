function traj_plot = plot_trajectories_alt(traj_struct)
traj_plot = figure;
for i = 1:length(traj_struct)
    d1_data = traj_struct(i).data(1,:);
    d2_data = traj_struct(i).data(2,:);
    d1_data_adj = d1_data;
    d2_data_adj = d2_data;
    epochs = traj_struct(i).epochStarts;
    colors = traj_struct(i).epochColors;
    d1_data_adj = d1_data_adj / d1_data_adj(epochs(2));
    d2_data_adj = d2_data_adj / d2_data_adj(epochs(2));
    %line(d2_data_adj(1:epochs(2)), d1_data_adj(1:epochs(2)),'Color', colors(1,:));
    line(d2_data_adj(epochs(2):epochs(3)), d1_data_adj(epochs(2):epochs(3)),'Color', colors(2,:));
    %line(d2_data_adj(epochs(3):length(d2_data_adj)), d1_data_adj(epochs(3):length(d1_data_adj)),'Color', colors(3,:));
end
