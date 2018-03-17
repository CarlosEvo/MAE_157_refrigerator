%% AXV_4

results_AXV_4 = struct();

% 15 psig data point index
idx_9 = 4;

% #1: T1 gives enthalpy and entropy (saturated liquid)
results_AXV_4.H_1 = interp1(R12_sat.T, R12_sat.H_f, data.T1(idx_9));

% #2: same enthalpy, T2 gives quality x
results_AXV_4.H_2 = results_AXV_4.H_1;

% #3: pressure table
% [T, P] = meshgrid(R12_P_8.T, [290, 300, 310] .* 1000);
P_sat = interp1(R12_sat.T, R12_sat.P, data.T3(idx_9));
H_3_f = interp1(R12_sat.P, R12_sat.H_f, P_sat);
H_3_g = interp1(R12_sat.P, R12_sat.H_g, P_sat);
S_3_f = interp1(R12_sat.P, R12_sat.S_f, P_sat);
S_3_g = interp1(R12_sat.P, R12_sat.S_g, P_sat);
results_AXV_4.H_3 = interp1([1 * u.atm / u.Pa, P_sat], [H_3_f, H_3_g], data.P3(idx_9));
results_AXV_4.S_3 = interp1([1 * u.atm / u.Pa, P_sat], [S_3_f, S_3_g], data.P3(idx_9));

% #4
% Experimental Value
[T, P] = meshgrid(R12_P_16.T, [1100, 1200, 1300, 1400] .* 1000);
% Ideal value
results_AXV_4.S_4_ideal = results_AXV_4.S_3;
results_AXV_4.T_4_ideal = fzero(...
    @(T_4_ideal) interp2(...
        T, P,...
        [R12_P_16.S_1100, R12_P_16.S_1200, R12_P_16.S_1300, R12_P_16.S_1400].',...
        T_4_ideal, data.P4(idx_9), 'spline'...
    ) - results_AXV_4.S_4_ideal,...
    data.T5(idx_9) + 50 ...
);
results_AXV_4.H_4_ideal = interp2(...
    T, P,...
    [R12_P_16.S_1100, R12_P_16.S_1200, R12_P_16.H_1300, R12_P_16.H_1400].',...
    results_AXV_4.T_4_ideal, data.P4(idx_9), 'spline'...
);

% Coefficient of performance
results_AXV_4.COP_real = COP_real(data.mass(idx_9), results_AXV_4.H_2, results_AXV_4.H_3);
results_AXV_4.COP_ideal = COP_ideal(...
    results_AXV_4.H_2, results_AXV_4.H_3, results_AXV_4.H_4_ideal...
);

% Refrigeration capacity
results_AXV_4.RC = capacity(...
    data.mass(idx_9), results_AXV_4.H_2, results_AXV_4.H_3...
);

results_AXV_4 = struct2table(results_AXV_4);
