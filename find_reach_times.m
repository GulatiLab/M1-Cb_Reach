function [Oseconds] = find_reach_times(data,offset,framerate)
% Use GUI data to construct a list of time intervals (in seconds) between
% the trial start signal (two pulses) and the reach onset.
%
% Inputs:
%       data        - GUI data from the video
%
% Outputs:
%       Oseconds    - time intervals (in seconds) between trial start and reach onset 


Oframes = zeros(length(data),1);

for j=1:length(data)
    clear framestr framenum f_onset f_pellet f_retract
    framestr  = data{j,2};
    framenum  = str2num(char(framestr));
    if isempty(data{j,3})
        Oframes(j) = -framerate;
        disp(['Empty at Trial ',string(j)])
        continue
    end
    if (data{j,3} ~= '1') && (data{j,3} ~= '0')
        disp('Trial Ignored')
        Oframes(j) = -framerate;
    elseif data{j,3} == '1'
        if length(framenum) > 2
            f_onset   = framenum(length(framenum)-2);
            Oframes(j) = f_onset - 1;
        else
            Oframes(j) = -framerate;
            disp(['Error at Trial ',string(j)])
        end
        if framenum(length(framenum)) < 2
            Oframes(j) = -framerate;
            disp(['Error at Trial ',string(j)])
        end
    else
        if isempty(find(framenum==1,1)) == 0
            x = find(framenum == 1);
            if x > 4
                f_onset   = framenum(x-4);
                Oframes(j) = f_onset - 1;
            else
                Oframes(j) = -framerate;
                disp(['Error at Trial ',string(j)])
            end
        else
            x = find(framenum == 0,1);
            if isempty(x) == 1
                f_onset  = framenum(length(framenum));
            else
                if x > 2
                    f_onset  = framenum(x-2);
                else
                    Oframes(j) = -framerate;
                    disp(['Error at Trial ',string(j)])
                end
            end
            Oframes(j) = f_onset - 1;
        end
    end
end

Oseconds = (Oframes * (1/framerate)) + offset;
end

