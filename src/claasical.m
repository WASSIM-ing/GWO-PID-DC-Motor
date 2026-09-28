
clc;
clear;

C = pidtune(dc_motor_model(),'PID');
Kpc = C.Kp;
Kic = C.Ki;
Kdc = C.Kd;

fprintf('\nclassical  PID parameters:\n');
fprintf('Kp = %.6f\n', Kpc);
fprintf('Ki = %.6f\n', Kic);
fprintf('Kd = %.6f\n', Kdc);