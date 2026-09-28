function [J, closed_sys] = pid_obj(x)
% PID_OBJ
% Calculates the PID performance cost and closed-loop system.
%
% Input:
%   x = [Kp Ki Kd]
%
% Outputs:
%   J          = objective function value
%   closed_sys = closed-loop transfer function

    Kp = x(1);
    Ki = x(2);
    Kd = x(3);

    % Plant
    sys = dc_motor_model();

    % PID controller
    C = pid(Kp, Ki, Kd);

    % Closed loop
    closed_sys = feedback(sys*C, 1);

    % Simulation
    dt = 0.01;
    t = 0:dt:10;

    % Step response
    y = step(closed_sys, t);

    % Error
    e = 1 - y;

    % Cost function
%     J = trapz(t, sqrt(abs(e)));
      J = trapz(t, abs(e));
end