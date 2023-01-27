function short_idx = length_filter(GUI_data, length_bounds, framerate)
%length_bounds is in the form [min_length max_length] in ms
%framerate is the video framerate in ms/frame

if length(length_bounds(:)) ~= 2
    error('Error: Length_bounds does not have exactly 2 values');
end
if ~isfloat(length_bounds)
    error('Error: Length_bounds is not a number');
end
short_idx = 1:size(GUI_data,1);
for i = flip(short_idx)
    frame_data = str2num(GUI_data{i,2});
    if strcmp(GUI_data{i,3},'0')
        if frame_data(end) ~= 1
            short_idx(i) = [];
        elseif ((frame_data(end-1) - frame_data(end-4)) * framerate) < length_bounds(1)
            short_idx(i) = [];
        elseif ((frame_data(end-1) - frame_data(end-4)) * framerate) > length_bounds(1)
            short_idx(i) = [];
        end
    else
        if ((frame_data(end) - frame_data(end-2)) * framerate) < length_bounds(1)
            short_idx(i) = [];
        elseif ((frame_data(end) - frame_data(end-2)) * framerate) > length_bounds(1)
            short_idx(i) = [];
        end
    end
end