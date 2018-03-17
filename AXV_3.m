%% AXV_3

results_AXV_3 = struct();

% 15 psig data point index
idx_1 = 3;

% #1: T1 gives enthalpy and entropy (saturated liquid)
results_AXV_3.H_1 = interp1(R12_sat.T, R12_sat.H_f, data.T1(idx_1));
results_AXV_3.S_1 = interp1(R12_sat.T, R12_sat.S_f, data.T1(idx_1));

% #2: same enthalpy, T2 gives quality x
results_AXV_3.H_2 = results_AXV_3.H_1;
H_2_f = interp1(R12_sat.T, R12_sat.H_f, data.T2(idx_1));
H_2_g = interp1(R12_sat.T, R12_sat.H_g, data.T2(idx_1));
S_2_f = interp1(R12_sat.T, R12_sat.S_f, data.T2(idx_1));
S_2_g = interp1(R12_sat.T, R12_sat.S_g, data.T2(idx_1));
results_AXV_3.x_2 = quality(H_2_f, H_2_g, results_AXV_3.H_2);
results_AXV_3.S_2 = mix(S_2_f, S_2_g, results_AXV_3.x_2);

% #3_g: isobaric, isothermal
results_AXV_3.H_3_g = H_2_g;
results_AXV_3.S_3_g = S_2_g;

% #3: pressure table
[T, P] = meshgrid(R12_P_6.T, (200: 10: 230) .* 1000);
results_AXV_3.H_3 = interp2(...
    T, P, [R12_P_6.H_200, R12_P_6.H_210, R12_P_6.H_220, R12_P_6.H_230].',...
    data.T3(idx_1), data.P3(idx_1)...
);
results_AXV_3.S_3 = interp2(...
    T, P, [R12_P_6.S_200, R12_P_6.S_210, R12_P_6.S_220, R12_P_6.S_230].',...
    data.T3(idx_1), data.P3(idx_1)...
);

% #4
% Experimental Value
[T, P] = meshgrid(R12_P_16.T, [1000, 1100] .* 1000);
results_AXV_3.S_4 = interp2(...
    T, P,...
    [R12_P_15.S_1000(3: end), R12_P_16.S_1100].',...
    data.T5(idx_1), data.P4(idx_1)...
);
results_AXV_3.H_4 = interp2(...
    T, P,...
    [R12_P_15.H_1000(3: end), R12_P_16.H_1100].',...
    data.T5(idx_1), data.P4(idx_1)...
);

% Value based on work done by compressor (use H & P)
results_AXV_3.H_4_work = results_AXV_3.H_3 + 600 ./ data.mass(idx_1);
results_AXV_3.T_4_work = fzero(...
    @(T_4_work) interp2(...
        T, P,...
        [R12_P_15.H_1000(3: end), R12_P_16.H_1100].',...
        T_4_work, data.P4(idx_1)...
    ) - results_AXV_3.H_4_work,...
    data.T5(idx_1) + 100 ...
);
results_AXV_3.S_4_work = interp2(...
    T, P,...
    [R12_P_15.S_1000(3: end), R12_P_16.S_1100].',...
    results_AXV_3.T_4_work, data.P4(idx_1)...
);


% Ideal value
results_AXV_3.S_4_ideal = results_AXV_3.S_3;
results_AXV_3.T_4_ideal = fzero(...
    @(T_4_ideal) interp2(...
        T, P,...
        [R12_P_15.S_1000(3: end), R12_P_16.S_1100].',...
        T_4_ideal, data.P4(idx_1)...
    ) - results_AXV_3.S_4_ideal,...
    data.T5(idx_1) + 50 ...
);
results_AXV_3.H_4_ideal = interp2(...
    T, P,...
    [R12_P_15.H_1000(3: end), R12_P_16.H_1100].',...
    results_AXV_3.T_4_ideal, data.P4(idx_1)...
);

% #5: isobaric, isothermal
results_AXV_3.H_5 = interp1(R12_sat.T, R12_sat.H_g, data.T1(idx_1));
results_AXV_3.S_5 = interp1(R12_sat.T, R12_sat.S_g, data.T1(idx_1));

% H-S Diagram
fig = figure;
hold on;

% Experimental cycle
plot(...
    [...
        results_AXV_3.S_1, results_AXV_3.S_2, results_AXV_3.S_3_g, results_AXV_3.S_3,...
        results_AXV_3.S_4, results_AXV_3.S_5, results_AXV_3.S_1...
    ],...
    [...
        results_AXV_3.H_1, results_AXV_3.H_2, results_AXV_3.H_3_g, results_AXV_3.H_3,...
        results_AXV_3.H_4, results_AXV_3.H_5, results_AXV_3.H_1...
    ],...
    'o-'...
);
text(...
    [...
        results_AXV_3.S_1, results_AXV_3.S_2, results_AXV_3.S_3_g,...
        results_AXV_3.S_3, results_AXV_3.S_4, results_AXV_3.S_5,...
    ]...
    + [-30, 10 .* ones(1, 5)],...
    [...
        results_AXV_3.H_1, results_AXV_3.H_2, results_AXV_3.H_3_g,...
        results_AXV_3.H_3, results_AXV_3.H_4, results_AXV_3.H_5...
    ] - 5000,...
    {'1', '2', '3''', '3', '4', '5'}...
);

% Ideal cycle
plot(...
    [results_AXV_3.S_3, results_AXV_3.S_4_ideal, results_AXV_3.S_5],...
    [results_AXV_3.H_3, results_AXV_3.H_4_ideal, results_AXV_3.H_5],...
    'o--'...
);
text(results_AXV_3.S_4_ideal + 10, results_AXV_3.H_4_ideal - 5000, '4''');

% Work cycle
plot(...
    [results_AXV_3.S_3, results_AXV_3.S_4_work, results_AXV_3.S_5],...
    [results_AXV_3.H_3, results_AXV_3.H_4_work, results_AXV_3.H_5],...
    'o--'...
);
text(results_AXV_3.S_4_work + 10, results_AXV_3.H_4_work - 5000, '4''''');

% Saturation dome
plot(...
    [R12_sat.S_f; R12_sat.S_g(end: -1: 1)],...
    [R12_sat.H_f; R12_sat.H_g(end: -1: 1)],...
    '-'...
);
formatFig(...
    fig, 'figures/AXV_3_HS',...
    'XLabel', 'Entropy $S\ (J/kg \cdot K)$',...
    'YLabel', 'Enthalpy $H\ (J/kg)$',...
    'axisScale', 'linear',...
    'legends', {'Experimental Cycle', 'Ideal Cycle', 'Compressor Cycle', 'Saturation Dome'}...
);
close(fig);

% T-S Diagram
fig = figure;
hold on;

% Data
plot(...
    [...
        results_AXV_3.S_1, results_AXV_3.S_2, results_AXV_3.S_3_g, results_AXV_3.S_3,...
        results_AXV_3.S_4, results_AXV_3.S_5, results_AXV_3.S_1...
    ],...
    [...
        data.T1(idx_1), data.T2(idx_1), data.T2(idx_1), data.T3(idx_1),...
        data.T5(idx_1), data.T1(idx_1), data.T1(idx_1)...
    ],...
    'o-'...
);
text(...
    [...
        results_AXV_3.S_1, results_AXV_3.S_2, results_AXV_3.S_3_g,...
        results_AXV_3.S_3, results_AXV_3.S_4, results_AXV_3.S_5,...
    ]...
    + [-30, 10 .* ones(1, 5)],...
    [...
        data.T1(idx_1), data.T2(idx_1), data.T2(idx_1),...
        data.T3(idx_1), data.T5(idx_1), data.T1(idx_1)...
    ] - 5,...
    {'1', '2', '3''', '3', '4', '5'}...
);

% Ideal cycle
plot(...
    [results_AXV_3.S_3, results_AXV_3.S_4_ideal, results_AXV_3.S_5],...
    [data.T3(idx_1), results_AXV_3.T_4_ideal, data.T1(idx_1)],...
    'o--'...
);
text(results_AXV_3.S_4_ideal + 10, results_AXV_3.T_4_ideal - 5, '4''');

% Work cycle
plot(...
    [results_AXV_3.S_3, results_AXV_3.S_4_work, results_AXV_3.S_5],...
    [data.T3(idx_1), results_AXV_3.T_4_work, data.T1(idx_1)],...
    'o--'...
);
text(results_AXV_3.S_4_work + 10, results_AXV_3.T_4_work - 5, '4''''');

% Saturation dome
plot(...
    [R12_sat.S_f; R12_sat.S_g(end: -1: 1)],...
    [R12_sat.T; R12_sat.T(end: -1: 1)],...
    '-'...
);

% Air inlet temp
plot(results_AXV_3.S_2, data.T7(idx_1), 'x');
text(...
    results_AXV_3.S_2 + 10, data.T7(idx_1) - 5,...
    sprintf('$ T_{inlet} = %.1f K $', data.T7(idx_1)),...
    'Interpreter', 'latex'...
);

formatFig(...
    fig, 'figures/AXV_3_TS',...
    'XLabel', 'Entropy $S\ (J/kg \cdot K)$',...
    'YLabel', 'Temperature $T\ (K)$',...
    'axisScale', 'linear',...
    'legends', {'Experimental Cycle', 'Ideal Cycle', 'Compressor Cycle', 'Saturation Dome'}...
);
close(fig);

% Coefficient of performance
results_AXV_3.COP_real = COP_real(data.mass(idx_1), results_AXV_3.H_2, results_AXV_3.H_3);
results_AXV_3.COP_ideal = COP_ideal(...
    results_AXV_3.H_2, results_AXV_3.H_3, results_AXV_3.H_4_ideal...
);

% Refrigeration capacity
results_AXV_3.RC = capacity(...
    data.mass(idx_1), results_AXV_3.H_2, results_AXV_3.H_3...
);

results_AXV_3 = struct2table(results_AXV_3);
