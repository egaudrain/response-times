% This test is to determine if a function really returns the keypress time
% or if it returns the time the function was called.

%ptb_path = genpath('~/Library/Matlab/Psychtoolbox');
%addpath(ptb_path);


import java.awt.*;
import java.awt.event.*;

rob = Robot;

%------- Psychtoolbox
figure(1);

t0 = GetSecs();

rob.keyPress(KeyEvent.VK_1);

t1 = GetSecs();

pause(1);

[~,t2, k, ~] = KbCheck();

% If KbCheck works as advertised, then t2 should be between t0 and t1.

plot([0, 1, 2], [t0, t2, t1]-t0, '-o')
ylabel('Time relative to t0 (s)')
set(gca, 'XTick', 0:2, 'XTickLabel', {'t0', 't2', 't1'})
xlabel('t2 should be between t0 and t1')
title('Psychtoolbox KbCheck')

print(gcf, 'benchmark_1_PsychKbCheck.png', '-dpng', '-r200');

%------- Psychtoolbox KbQueueCheck
figure(2);

KbQueueCreate();
KbQueueStart();

t0 = GetSecs();

%rob.keyPress(KeyEvent.VK_1);
input('Press a key', 's');

t1 = GetSecs();

pause(1);

[~, t2] = KbQueueCheck();
t2 = min(t2(t2~=0));
KbQueueStop();

% If KbCheck works as advertised, then t2 should be between t0 and t1.

plot([0, 1, 2], [t0, t2, t1]-t0, '-o')
ylabel('Time relative to t0 (s)')
set(gca, 'XTick', 0:2, 'XTickLabel', {'t0', 't2', 't1'})
xlabel('t2 should be between t0 and t1')
title('Psychtoolbox KbQueueCheck')

print(gcf, 'benchmark_1_PsychKbQueueCheck.png', '-dpng', '-r200');

%------- PyKeyPress
figure(3);

t0 = GetSecs();

rob.keyPress(KeyEvent.VK_1);

t1 = GetSecs();

pause(1);

q = struct();
q.from = t0;
q.first = 1;

resp = pyKeyPress_query(q);
t2 = resp.body.t;

% If KbCheck works as advertised, then t2 should be between t0 and t1.

plot([0, 1, 2], [t0, t2, t1]-t0, '-o')
ylabel('Time relative to t0 (s)')
set(gca, 'XTick', 0:2, 'XTickLabel', {'t0', 't2', 't1'})
xlabel('t2 should be between t0 and t1')
title('pyKeyPress')


print(gcf, 'benchmark_1_pyKeyPress.png', '-dpng', '-r200');


