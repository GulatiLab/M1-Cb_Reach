function [out_fig]  = create_channel_power_heatmap(ersp_data, times, freqs, area, bad_chans)
% Creates a figure with a power spectrum heatmap for each channel. The
% location of the plots in the figure corrisponds to the channels location
% in the electrode
%
% Inputs:
%       ersp_data       - ERSP data from newtimef.m (channel x time x frequency x trials)
%       times           - time lables for the 2nd dimension of ersp_data
%       freqs           - freqency lables for the 3rd dimension of ersp_data
%       area            - A tag that indicates which channel mapping to use. Current areas are 'M1' and 'Cb' (see Interal Variables below)
%       bad_chans       - A list of noisy channels that have been ommited from ersp_data
%
% Internal Variables:
%       M1_mapping      - the mapping between the channel index in the data and the possition on the electrode array implanted in M1 
%       Cb_mapping      - the mapping between the channel index in the data and the possition on the electrode array implanted in the cerebellum
%       *               - more mappings can be added as nessisary
%
% Outputs:
%       out_fig         - The handle to the output figure

M1_mapping = [17 19 21 23 18 20 22 24,...			
              26 28 30 32 25 27 29 31,...
              10 12 14 16  9 11 13 15,...
               1  3  5  7  2  4  6  8];

Cb_mapping = [8  5 20 17 16 29 28 9,...
			  6  3 23 18 15 27 26 14,...
			  4 24 21  1 32 25 13 12,...
 			  7 22 19  2 31 30 11 10];
          
Cb_poly_mapping = [17 21 26 27  8  5 15 11,...
                   18 53 49 52 47 44 16 43,...
                   22 57 25 48  7  1 12 39,...
                   30 23 58 50 40 31  4  9,...
                   61 55 62 54 36 42 35 41,...
                   63 32 29 56  3 46 33  2,...
                   19 59 24 60 10 38 13 37,...
                   28 20 64 51 34 45  6 14];
          
if strcmp(area, 'M1') == 1
    mapping = M1_mapping;
elseif strcmp(area, 'Cb') == 1
    mapping = Cb_mapping;
elseif strcmp(area, 'Cb_poly') == 1
    mapping = Cb_poly_mapping;
elseif strcmp(area, 'empty') == 1
    mapping = [];
else
    mapping = 1:32;
end



%real_ersp_data=ersp_data.*conj(ersp_data);
real_ersp_data=abs(ersp_data);
bl=mean(real_ersp_data(:,:,times>-1500&times<-500,:),3);
bl_std=std(real_ersp_data(:,:,times>-1500&times<-500,:),[],3);
datanorm=bsxfun(@minus,real_ersp_data,bl);
datanorm=bsxfun(@rdivide,datanorm,bl_std);
datanormm=squeeze(mean(datanorm,4));

out_fig = figure;
for i = 1:length(mapping)
    if ismember(mapping(i), bad_chans)
        continue
    end
    mod = 0;
    for j = 1:length(bad_chans)
        if mapping(i) > bad_chans(j)
            mod = mod + 1;
        end
    end
    if length(mapping) == 32
        subplot(4,8,i)
    elseif length(mapping) == 64
        subplot(8,8,i)
    else
        error('Something has gone wrong')
    end
    pcolor(times,freqs,squeeze(datanormm(mapping(i)-mod,:,:)))
    shading interp
    axis xy
    axis([-50 800 1.5 6])
    caxis([0 3])
    line([0 0], [1.5 6], 'Color', 'black', 'LineStyle', '--')
    
    colorbar
    %title('Power')
    
end

end