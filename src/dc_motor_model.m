function sys = dc_motor_model()
% DC_MOTOR_MODEL
% Returns the transfer function of the DC motor.

    % Motor parameters
    R  = 1;       % Armature resistance [Ohm]
    L  = 0.5;     % Armature inductance [H]
    J  = 0.01;    % Rotor inertia [kg.m^2]
    b  = 0.1;     % Viscous friction coefficient
    Kt = 0.01;    % Torque constant
    Ke = 0.01;    % Back EMF constant

    % Transfer function
    num = Kt;

    den = [L*J, L*b,R*J, R*b + Kt*Ke];

    sys = tf(num, den);
end