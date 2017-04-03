function test_lag_audioplayer()

    global time_before_play

    fs = 44100;
    x  = randn(fs,1);
    
    p = audioplayer(x, fs);
    p.TimerFcn = @timer_callback;
    p.StartFcn = @start_callback;
    p.UserData = struct();
    p.UserData.time_sample = [];
    
    time_before_play = tic();
    playblocking(p);
    
    ts = p.UserData.time_sample;
    plot(ts(1,:), ts(2,:), '+');
    hold on
    plot(p.UserData.start_time, 1, 'v')
    
    ts = ts(:, ts(2,:)>1);
    
    pl = polyfit(ts(2,:), ts(1,:), 1);
    
    plot(polyval(pl, [1, max(ts(2,:))]), [1, max(ts(2,:))], '-')
    hold off
    
    legend({'Samples', 'Time in start callback', 'Linear fit on samples'}, 'Location', 'northwest');
    
    xlabel('Time (s)')
    ylabel('Sampler number')
    
    set(gcf, 'PaperPosition', [0, 0, 6, 5]);
    print(gcf, 'test_lag_audioplayer.png', '-dpng', '-r300');

%-------
function start_callback(obj, event)
    global time_before_play
    
    obj.UserData.start_time = toc(time_before_play);

%-------
function timer_callback(obj, event)
    global time_before_play
    
    t = toc(time_before_play);
    s = obj.CurrentSample;

    obj.UserData.time_sample = [obj.UserData.time_sample, [t; s]];