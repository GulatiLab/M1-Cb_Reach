function badtrials = visualizeTrialData(trial_data,badchans,outcomes)
% Visualize raw LFP data and mark bad trials
% input: trial_data channel x time x trial

trial_data(badchans,:,:)=[]; % remove bad chans
sz=size(trial_data);
exit=0;
n=1;

init_badtrials = 1:size(outcomes,1);
init_badtrials(outcomes == 1 | outcomes == 0) = [];

while ismember(n, init_badtrials)
    n=n+1;
end
badtrials = [];
disp('press "i" to inspect current plot')

if n <= size(trial_data,3)
    fig=figure('units','normalized','outerposition',[0.1 0.1 .8 .8]);
    plot(trial_data(:,:,n)');
    xlim([1 sz(2)])
    hold on
    uicontrol('style','text','string','Bad trials','position',[50 50 80 20],'backgroundcolor',[.8 .8 .8]);
    markerframes(1)=uicontrol('style','text','string','','HorizontalAlignment','left','position',[20 125 140 140]);
    hold off
    
    while ~exit
        if outcomes(n) == 1
            title(['Trial ', num2str(n), ' +'])
        elseif outcomes(n) == 0
            title(['Trial ', num2str(n), ' -'])
        end
        [~,~,button] = ginput(1);
        switch button
            case 32 % space
                if sum(badtrials == n)
                    badtrials(badtrials==n)=[];
                else
                    badtrials=[badtrials, n];
                end
                set(markerframes(1),'string',num2str(badtrials));
            case 28 % left
                n=n-1;
                while ismember(n, init_badtrials)
                    n=n-1;
                end
            case 29 % right
                n=n+1;
                while ismember(n, init_badtrials)
                    n=n+1;
                end
            case 101 % e to exit
                exit=1;
            case 105 % i to inspect
                figure
                plot(trial_data(:,:,n)')
                input('Close inspection figure and press enter when done')
        end
        if n>sz(3)
            exit=1;
            continue
        end
        if n<1
            n=1;
        end
        plot(trial_data(:,:,n)')
        xlim([1 sz(2)])
    end
    
    close(fig);
end