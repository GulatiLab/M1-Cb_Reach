function [M1_snapshots, Cb_snapshots] = snapshot_extraction(M1_LFP_t, Cb_LFP_t, WAVE2_t, M1_Fs, Cb_Fs, Wave_Fs, Oseconds, data, snapshot_seconds_left, snapshot_seconds_right)
% Takes block-long LFP data set and breaks it into snapshots centered on
% the an event.
%
% Inputs:
%       M1_LFP_t                - The block-long LFP trace for M1 (chan x time)
%       Cb_LFP_t                - The block-long LFP trace for Cerebellum (chan x time)
%       WAVE2_t                 - The block-long signal record
%       Fs                      - Sample rate (per second) of LFP recording
%       Oseconds                - Time (in seconds) between the start signal (two pulses) and the event 
%       data                    - GUI data from the video
%
% Internal Variables:
%       snapshot_seconds_left   - Margin to the left (into the past) from the center event of the snapshot
%       snapshot_seconds_right  - Margin to the right (into the future) from the center event of the snapshot
%
% Outputs:
%       M1_snapshots            - LFP snapshots of the M1 (chan x time x trial)
%       Cb_snapshots            - LFP snapshots of the Cerebellum (chan x time x trial)

threshold = max(WAVE2_t)*0.1;
binary_wave=WAVE2_t>threshold;

pulse_onsets = diff(binary_wave)>0.5;
[pulse_timestamps] = find(pulse_onsets == 1)+1;
trial_count = length(data(:,1));


% %For using door open signal.
% diff_pulse_timestamps = [diff(pulse_timestamps) inf];
% 
% pulse_clusters = zeros(1,length(diff_pulse_timestamps));
% for n = 1:length(diff_pulse_timestamps)
%     
%     pulse_count = 1;
%     
%     while (n+pulse_count-1) <= length(diff_pulse_timestamps) && diff_pulse_timestamps(n+pulse_count-1) < 700
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
    %For I127 when using the door open signal the 1 in start_times_bool at index 131 on day 2 is an error and days 5 and 6 are totaly unusable. Using the video start signal is required. 
end



M1_snapshots = zeros(size(M1_LFP_t,1),round(snapshot_seconds_left*M1_Fs) + round(snapshot_seconds_right*M1_Fs) + 1,length(start_times));
Cb_snapshots = zeros(size(Cb_LFP_t,1),round(snapshot_seconds_left*Cb_Fs) + round(snapshot_seconds_right*Cb_Fs) + 1,length(start_times));

for j=1:length(start_times)
    if str2double(data{j,3}) < 2
        M1_snapshot_zero = round(start_times(j)*M1_Fs/Wave_Fs) + round(Oseconds(j)*M1_Fs);
        Cb_snapshot_zero = round(start_times(j)*Cb_Fs/Wave_Fs) + round(Oseconds(j)*Cb_Fs);
        
        M1_snapshot_start_ticks = M1_snapshot_zero - round(snapshot_seconds_left * M1_Fs);
        M1_snapshot_end_ticks = M1_snapshot_zero + round(snapshot_seconds_right * M1_Fs);
        
        Cb_snapshot_start_ticks = Cb_snapshot_zero - round(snapshot_seconds_left * Cb_Fs);
        Cb_snapshot_end_ticks = Cb_snapshot_zero + round(snapshot_seconds_right * Cb_Fs);
        
        if size(M1_LFP_t,2) < M1_snapshot_end_ticks
            M1_snapshot_end_ticks = size(M1_LFP_t,2);
        end
        M1_snapshots(:,:,j) = M1_LFP_t(:,M1_snapshot_start_ticks:M1_snapshot_end_ticks);
        
        if size(Cb_LFP_t,2) < Cb_snapshot_end_ticks
            Cb_snapshot_end_ticks = size(Cb_LFP_t,2);
        end
        Cb_snapshots(:,:,j) = Cb_LFP_t(:,Cb_snapshot_start_ticks:Cb_snapshot_end_ticks);
    end
end

end