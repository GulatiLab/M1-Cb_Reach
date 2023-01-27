function [data_out, Fds] = filter_RS4_sev_data(data_in, chan_counts)

ds_lfp_all_areas = resample(double(data_in.data(1,:))',1,24)';
ds_lfp_all_areas = nan(size(data_in.data,1), size(ds_lfp_all_areas,2));
for i = 1:size(data_in.data,1)
    % ---- Filtered LFP data -------------------------
    % High pass filter
    CutOff_freqs = 0.1;
    Wn = CutOff_freqs./data_in.fs;
    filterOrder = 3;
    [b,a] = butter(filterOrder,Wn,'high');
    data_line = double(data_in.data(i,:));
    data_line = filtfilt(b,a,data_line);
    
    % Low pass filter
    CutOff_freqs = 300;
    Wn = CutOff_freqs./data_in.fs;
    filterOrder = 3;
    [b,a] = butter(filterOrder,Wn,'low');
    data_line = filtfilt(b,a,data_line);
    
    % Notch filter parameters to remove 60Hz line noise
    d = designfilt('bandstopiir','FilterOrder',2, ...
        'HalfPowerFrequency1',59.9,'HalfPowerFrequency2',60.1, ...
        'DesignMethod','butter','SampleRate',data_in.fs);
    data_line = filtfilt(d,data_line);
    
    
    % Resample to 1kHz
    ds_lfp_all_areas(i,:) = resample(data_line',1,24)';
end
Fds = data_in.fs/24;

data_out = cell(length(chan_counts),1); 
chan_start = 1;
chan_end = 0;
for area = 1:length(chan_counts)
    chan_end = chan_end + chan_counts(area);
    data_out{area} = ds_lfp_all_areas(chan_start:chan_end,:);
    chan_start = chan_start + chan_counts(area);
end
    