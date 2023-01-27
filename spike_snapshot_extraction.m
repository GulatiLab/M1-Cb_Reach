function [M1_snapshots, Cb_snapshots] = spike_snapshot_extraction(M1_spike_timestamps, Cb_spike_timestamps, WAVE2_t, M1_Fs, Cb_Fs, Wave_Fs, Oseconds, data, snapshot_seconds_left, snapshot_seconds_right)
% Use the block-long spike time record to create snapshots containing only
% spikes that occur in close temporal proximity with an event and with time
% stamps relative to that event.
%
% Inputs:
%       M1_spike_timestamps     - The block-long spike time record from M1 (chan x spike times)
%       Cb_spike_timestamps     - The block-long spike time record from Cerebellum (chan x spike times)
%       WAVE2_t                 - The block-long signal record
%       Fs                      - Sample rate (per second) of LFP recording
%       Oseconds                - Time (in seconds) between the start signal (two pulses) and the event 
%       data                    - GUI data from the video 
%
% Outputs:
%       M1_snapshots            - spike time snapshots of the M1 (chan x spike times st x trial)
%       Cb_snapshots            - spike time snapshots of the Cerebellum (chan x spike times x trial)

trial_codes = str2double(data(:,3));

threshold = max(WAVE2_t)*0.1;
binary_wave=WAVE2_t>threshold;

pulse_onsets = diff(binary_wave)>0.5;
[pulse_timestamps] = find(pulse_onsets == 1)+1;
trial_count = length(data(:,1));

% %For using door open signal.
% diff_pulse_timestamps = [diff(pulse_timestamps) inf];
% pulse_clusters = zeros(1,length(diff_pulse_timestamps));
% for n = 1:length(diff_pulse_timestamps)
%     
%     pulse_count = 1;
%     
%     while (n+pulse_count-1) <= length(diff_pulse_timestamps) && diff_pulse_timestamps(n+pulse_count-1) < 1000
%         pulse_count = pulse_count+1;
%     end
%     
%     pulse_clusters(n) = pulse_count;
% end
% pulse_clusters = [pulse_clusters 1];
% unique_cluster_bool = [1 (diff(pulse_clusters)~=-1)];
% start_times_bool = unique_cluster_bool & (pulse_clusters == 2);
% 
% start_times = pulse_timestamps(start_times_bool);

%For using video start signal
start_times = pulse_timestamps;

if length(start_times) ~= trial_count
    error('There has been a problem identifying the trial start signals')
end


start_times(trial_codes > 1) = [];
start_times = start_times/Wave_Fs;
Oseconds(trial_codes > 1) = [];

M1_snapshots = cell(size(M1_spike_timestamps,1),size(M1_spike_timestamps,2),length(start_times));
Cb_snapshots = cell(size(Cb_spike_timestamps,1),size(Cb_spike_timestamps,2),length(start_times));

for j=1:length(start_times)
    snapshot_zero = start_times(j) + Oseconds(j);
    snapshot_start = snapshot_zero - snapshot_seconds_left;
    snapshot_end = snapshot_zero + snapshot_seconds_right;
    
    for c = 1:size(M1_spike_timestamps,1)
        for i = 1:size(M1_spike_timestamps,2)
            spike_times = M1_spike_timestamps{c,i};
            spike_times(spike_times < snapshot_start) = [];
            spike_times(spike_times > snapshot_end) = [];
            
            M1_snapshots{c,i,j} = (spike_times-snapshot_start)*M1_Fs;
        end
    end
    
    for c = 1:size(Cb_spike_timestamps,1)
        for i = 1:size(Cb_spike_timestamps,2)
            spike_times = Cb_spike_timestamps{c,i};
            spike_times(spike_times < snapshot_start) = [];
            spike_times(spike_times > snapshot_end) = [];
            
            Cb_snapshots{c,i,j} = (spike_times-snapshot_start)*Cb_Fs;
        end
    end
    
end

end