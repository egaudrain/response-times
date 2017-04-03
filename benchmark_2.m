% This test is to examine how the RT method resists to external CPU stress
% pressure.

phase_duration = 20;
stress_type = 'memory'; % or cpu

%% 1. KbCheck

figure(1)
uicontrol('Style', 'edit', 'Units', 'normalized', 'Position', [0,0,1,1]);
drawnow();

% When the figure shows, place the cursor in it and press a key
pause(30);

% Key press time arrays for no-stress and with-stress
Tk_1 = [];
Tk_2 = [];

t0 = GetSecs();
t  = t0;

fprintf('Measuring RTs with KbCheck without stress\n')

while t<t0+phase_duration
    [~,tk, k] = KbCheck();
    if any(k)
        Tk_1 = [Tk_1, tk];
    end
    t = GetSecs();
end

fprintf('Measuring RTs with KbCheck with stress\n')

stress(stress_type, phase_duration);

t0 = GetSecs();
t  = t0;

while t<t0+phase_duration
    [~,tk, k] = KbCheck();
    if any(k)
        Tk_2 = [Tk_2, tk];
    end
    t = GetSecs();
end

fprintf('Waiting for stress to wash away\n')

pause(phase_duration)

%% 2. pyKeyPress

Tp_1 = [];
Tp_2 = [];

t0 = GetSecs();
t  = t0;

fprintf('Measuring RTs with pyKeyPress without stress\n')

while t<t0+phase_duration
    q = struct();
    q.from = t;
    t = GetSecs();
    resp = pyKeyPress_query(q);
    if ~isempty(resp.body)
        Tp_1 = [Tp_1, resp.body(:).t];
    end
    pause(.1);
end

fprintf('Measuring RTs with pyKeyPress with stress\n')

stress(stress_type, phase_duration);

t0 = GetSecs();
t  = t0;

while t<t0+phase_duration
    q = struct();
    q.from = t;
    t = GetSecs();
    resp = pyKeyPress_query(q);
    if ~isempty(resp.body)
        Tp_2 = [Tp_2, resp.body(:).t];
    end
    pause(.1);
end


%--------------------------------

close all

fprintf('Waiting for stress to wash away\n')
pause(phase_duration);

figure(1)
%Tk = [Tk_1, Tk_2];
dTk_1 = diff(Tk_1);
dTk_2 = diff(Tk_2);
dTk_1 = dTk_1(dTk_1>3e-2 & dTk_1<.5);
dTk_2 = dTk_2(dTk_2>3e-2 & dTk_2<.5);
plot(dTk_1)
hold on
plot(dTk_2)
hold off
title('PsychToolbox KbCheck')

legend({sprintf('Without stress: sd=%.2fms', std(dTk_1)*1e3), sprintf('With stress: sd=%.2fms', std(dTk_2)*1e3)})

figure(2)
%Tp = [Tp_1, Tp_2];


dTp_1 = diff(Tp_1);
dTp_2 = diff(Tp_2);
dTp_1 = dTp_1(dTp_1>3e-2 & dTp_1<.5);
dTp_2 = dTp_2(dTp_2>3e-2 & dTp_2<.5);
plot(dTp_1)
hold on
plot(dTp_2)
hold off
title('pyKeyPress')

legend({sprintf('Without stress: sd=%.2fms', std(dTp_1)*1e3), sprintf('With stress: sd=%.2fms', std(dTp_2)*1e3)})


print(1, sprintf('benchmark_2_%s_PsychKbCheck.png', stress_type), '-dpng', '-r200');
print(2, sprintf('benchmark_2_%s_pyKeyPress.png', stress_type), '-dpng', '-r200');