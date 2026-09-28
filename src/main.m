

%        DC MOTOR PID OPTIMIZATION USING GWO
%        Comparison with Classical PID Controller

% GWO Parameters

SearchAgents = 15;
MaxIter = 100;

% Lower and upper bounds for PID parameters
lb = [0.01 0.001 0.0001];
ub = [100 100 10];

% Number of decision variables
dim = 3;

%Objective Function

fobj = @(x) pid_obj(x);

% Run GWO

[BestScore, BestPosition, Convergence_curve] = ...
    GWO(SearchAgents, MaxIter, lb, ub, dim, fobj);


%              GWO PID PARAMETERS

Kp = BestPosition(1);
Ki = BestPosition(2);
Kd = BestPosition(3);

fprintf('\n====================================\n');
fprintf('       GWO PID PARAMETERS\n');
fprintf('====================================\n');

fprintf('Kp = %.6f\n', Kp);
fprintf('Ki = %.6f\n', Ki);
fprintf('Kd = %.6f\n', Kd);

fprintf('Best objective value = %.6f\n', BestScore);


%            CLASSICAL PID PARAMETERS

% DC Motor model

plant = dc_motor_model();



fprintf('\n====================================\n');
fprintf('    CLASSICAL PID PARAMETERS\n');
fprintf('====================================\n');

fprintf('Kpc = %.6f\n', Kpc);
fprintf('Kic = %.6f\n', Kic);
fprintf('Kdc = %.6f\n', Kdc);


%              PID CONTROLLERS

% GWO PID controller

C = pid(Kp, Ki, Kd);

% Classical PID controller

C1 = pid(Kpc, Kic, Kdc);


%             CLOSED-LOOP SYSTEMS

% GWO closed-loop system

closed_sys = feedback(plant * C, 1);

% Classical PID closed-loop system

closed_sysc = feedback(plant * C1, 1);


%               STEP RESPONSE

figure;

step(closed_sys);
hold on;

step(closed_sysc);

grid on;

legend('GWO PID', 'Classical PID', ...
       'Location', 'best');

title('GWO PID vs Classical PID');

xlabel('Time (s)');
ylabel('Output');


%             PERFORMANCE CHARACTERISTICS

info = stepinfo(closed_sys);

info1 = stepinfo(closed_sysc);

fprintf('\n====================================\n');
fprintf('       GWO PERFORMANCE\n');
fprintf('====================================\n');

disp(info);

fprintf('\n====================================\n');
fprintf('    CLASSICAL PID PERFORMANCE\n');
fprintf('====================================\n');

disp(info1);


%             GWO CONVERGENCE CURVE

figure;

plot(1:MaxIter, Convergence_curve, 'LineWidth', 2);

grid on;

title('GWO Convergence Curve');

xlabel('Iteration');

ylabel('Best Fitness');


%             PERFORMANCE COMPARISON

fprintf('\n============================================\n');
fprintf('          PERFORMANCE COMPARISON\n');
fprintf('============================================\n');

fprintf('\n                  GWO          Classical\n');

fprintf('Rise Time       %.4f        %.4f\n', ...
        info.RiseTime, info1.RiseTime);

fprintf('Settling Time   %.4f        %.4f\n', ...
        info.SettlingTime, info1.SettlingTime);

fprintf('Overshoot       %.4f        %.4f\n', ...
        info.Overshoot, info1.Overshoot);

fprintf('Peak            %.4f        %.4f\n', ...
        info.Peak, info1.Peak);

fprintf('Peak Time       %.4f        %.4f\n', ...
        info.PeakTime, info1.PeakTime);


disp(info1)