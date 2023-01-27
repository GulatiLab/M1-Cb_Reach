function [rti_seconds, rri_seconds] = calc_post_reach_intervals(data,framerate)
% Calculates the intervals between reach onset and pellet touch and between
% reach onset and retract onset.
%
% Inputs:
%       data            - GUI data from the video
% 
% Internal Variables:
%       framerate: the framerate of the camera that the exeperiment was
%       recorded with (frames/sec)
%
% Outputs:
%       rti_seconds     - the intervals between reach and touch
%       rri_seconds     - the intervals between reach and retract

rti_frames = zeros(length(data),1);
rri_frames = zeros(length(data),1);

for j=1:length(data)
    clear framestr framenum f_onset f_pellet f_retract
    framestr  = data{j,2};
    framenum  = str2num(char(framestr));
    if isempty(data{j,3})
        rti_frames(j) = -framerate;
        rri_frames(j) = -framerate;
        disp(['Empty at Trial ',string(j)])
        continue
    end
    if (data{j,3} ~= '1') && (data{j,3} ~= '0')
        %disp('Trial Ignored')
        rti_frames(j) = -framerate;
        rri_frames(j) = -framerate;
    elseif data{j,3} == '1'
        if length(framenum) > 2
            f_reach   = framenum(length(framenum)-2);
            f_touch   = framenum(length(framenum)-1);
            f_retract = framenum(length(framenum));
            rti_frames(j) = f_touch   - f_reach;
            rri_frames(j) = f_retract - f_reach;
            if (rti_frames(j) < 0) || (rri_frames(j) < 0)
                disp(['Error at Trial ',string(j)])
            end
        else
            rti_frames(j) = -framerate;
            rri_frames(j) = -framerate;
            disp(['Error at Trial ',string(j)])
        end
    else
        if isempty(find(framenum==1,1)) == 0
            x = find(framenum == 1);
            if x > 4
                f_reach   = framenum(x-4);
                f_touch   = framenum(length(framenum)-3);
                f_retract = framenum(length(framenum)-1);
                rti_frames(j) = f_touch   - f_reach;
                rri_frames(j) = f_retract - f_reach;
                if (rti_frames(j) < 0) || (rri_frames(j) < 0)
                    disp(['Error at Trial ',string(j)])
                end
            else
                rti_frames(j) = -framerate;
                rri_frames(j) = -framerate;
                disp(['Error at Trial ',string(j)])
            end
        else
            rti_frames(j) = -framerate;
            rri_frames(j) = -framerate;
            disp(['No retract at Trial ',string(j)])
        end
    end
end

rti_seconds = rti_frames * (1/framerate);
rri_seconds = rri_frames * (1/framerate);

end