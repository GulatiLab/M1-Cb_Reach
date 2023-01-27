function [reach_snapshots, touch_snapshots, retract_snapshots, long_trials] = create_event_centered_snapshots(reach_touch_interval, reach_retract_interval, bad_trials, snapshots, Fs, ss_radius, orig_center)
% Takes standard snapshots centered on the reach onset and creates 3 small
% snapshots centered on the reach onset, the pellet touch, and the retract
% onset.
%
% Inputs:
%       reach_touch_interval    - the interval between the reach onset and pellet touch for each trial
%       reach_retract_interval  - the interval between the reach onset and retract onset for each trial
%       bad_trials              - trials to be ommited from analysis
%       snapshots               - the standard-sized snapshots (channel x time x trial)
%       Fs                      - Sample rate (per second) of LFP recording
%       ss_radius               - the time radius around the center of the new snapshots
%       orig_center             - location in the original snapshot of the reach onset
%
% Outputs:
%       reach_snapshots         - array of small snapshots centered on reach onset
%       touch_snapshots         - array of small snapshots centered on touch onset
%       retract_snapshots       - array of small snapshots centered on retract onset
%       long_trials             - indices that were removed


reach_touch_interval(bad_trials) = [];
reach_retract_interval(bad_trials) = [];

ss_size = size(snapshots);
ss_size = [ss_size ones(1,3-length(ss_size))];
frame_max = round((orig_center+ss_radius)*Fs);
frame_min = round((orig_center-ss_radius)*Fs);

reach_snapshots = zeros(ss_size(1),1+frame_max-frame_min,ss_size(3));
touch_snapshots = zeros(ss_size(1),1+frame_max-frame_min,ss_size(3));
retract_snapshots = zeros(ss_size(1),1+frame_max-frame_min,ss_size(3));

long_trials = [];
for i = 1:ss_size(3)
    if (frame_max+round(reach_retract_interval(i)*Fs)) > ss_size(2)
        long_trials = [long_trials i];
    elseif (reach_touch_interval(i) > 0) && (reach_retract_interval(i) > 0)
        reach_snapshots(:,:,i) = snapshots(:,frame_min:frame_max,i);
        touch_snapshots(:,:,i) = snapshots(:,(frame_min:frame_max)+round(reach_touch_interval(i)*Fs),i);
        retract_snapshots(:,:,i) = snapshots(:,(frame_min:frame_max)+round(reach_retract_interval(i)*Fs),i);
    else
        long_trials = [long_trials i];
    end
end
reach_snapshots(:,:,long_trials) = [];
touch_snapshots(:,:,long_trials) = [];
retract_snapshots(:,:,long_trials) = [];
end