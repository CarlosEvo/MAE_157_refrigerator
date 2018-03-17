%% TCX_1

results_TXV_2 = struct();

idx_3 = 6;

% #1: T1 gives enthalpy and entropy (saturated liquid)
results_TXV_2.H_1 = interp1(R12_sat.T, R12_sat.H_f, data.T1(idx_3));
results_TXV_2.S_1 = interp1(R12_sat.T, R12_sat.S_f, data.T1(idx_3));

% #2: same enthalpy, T2 gives quality x
results_TXV_2.H_2 = results_TXV_2.H_1;
H_2_f = interp1(R12_sat.T, R12_sat.H_f, data.T2(idx_3));
H_2_g = interp1(R12_sat.T, R12_sat.H_g, data.T2(idx_3));
S_2_f = interp1(R12_sat.T, R12_sat.S_f, data.T2(idx_3));
S_2_g = interp1(R12_sat.T, R12_sat.S_g, data.T2(idx_3));
results_TXV_2.x_2 = quality(H_2_f, H_2_g, results_TXV_2.H_2);
results_TXV_2.S_2 = mix(S_2_f, S_2_g, results_TXV_2.x_2);

% #3_g: isobaric, isothermal
results_TXV_2.H_3_g = H_2_g;
results_TXV_2.S_3_g = S_2_g;

% #3: pressure table
[T, P] = meshgrid(R12_P_8.T, (280: 10: 310) .* 1000);
results_TXV_2.H_3 = interp2(...
    T, P, [R12_P_8.H_280, R12_P_8.H_290, R12_P_8.H_300, R12_P_8.H_310].',...
    data.T3(idx_3), data.P3(idx_3)...
);
results_TXV_2.S_3 = interp2(...
    T, P, [R12_P_8.S_280, R12_P_8.S_290, R12_P_8.S_300, R12_P_8.S_310].',...
    data.T3(idx_3), data.P3(idx_3)...
);

% #4
% Experimental Value
[T, P] = meshgrid(R12_P_16.T, [1100: 100: 1400] .* 1000);
results_TXV_2.S_4 = interp2(...
    T, P,...
    [R12_P_16.S_1100, R12_P_16.S_1200, R12_P_16.S_1300, R12_P_16.S_1400].',...
    data.T5(idx_3), data.P4(idx_3)...
);
results_TXV_2.H_4 = interp2(...
    T, P,...
    [R12_P_16.H_1100, R12_P_16.H_1200, R12_P_16.H_1300, R12_P_16.H_1400].',...
    data.T5(idx_3), data.P4(idx_3)...
);

% Value based on work done by compressor (use H & P)
results_TXV_2.H_4_work = results_TXV_2.H_3 + 600 ./ data.mass(idx_3);
results_TXV_2.T_4_work = fzero(...
    @(T_4_work) interp2(...
        T, P,...
        [R12_P_16.H_1100, R12_P_16.H_1200, R12_P_16.H_1300, R12_P_16.H_1400].',...
        T_4_work, data.P4(idx_3), 'spline'...
    ) - results_TXV_2.H_4_work,...
    data.T5(idx_3)...
);
results_TXV_2.S_4_work = interp2(...
    T, P,...
    [R12_P_16.S_1100, R12_P_16.S_1200, R12_P_16.S_1300, R12_P_16.S_1400].',...
    results_TXV_2.T_4_work, data.P4(idx_3)...
);


% Ideal value
results_TXV_2.S_4_ideal = results_TXV_2.S_3;
results_TXV_2.T_4_ideal = fzero(...
    @(T_4_ideal) interp2(...
        T, P,...
        [R12_P_16.S_1100, R12_P_16.S_1200, R12_P_16.S_1300, R12_P_16.S_1400].',...
        T_4_ideal, data.P4(idx_3), 'spline'...
    ) - results_TXV_2.S_4_ideal,...
    data.T5(idx_3)...
);
results_TXV_2.H_4_ideal = interp2(...
    T, P,...
    [R12_P_16.H_1100, R12_P_16.H_1200, R12_P_16.H_1300, R12_P_16.H_1400].',...
    results_TXV_2.T_4_ideal, data.P4(idx_3)...
);

% #5: isobaric, isothermal
results_TXV_2.H_5 = interp1(R12_sat.T, R12_sat.H_g, data.T1(idx_3));
results_TXV_2.S_5 = interp1(R12_sat.T, R12_sat.S_g, data.T1(idx_3));

% H-S Diagram
fig = figure;
hold on;

% Experimental cycle
plot(...
    [...
        results_TXV_2.S_1, results_TXV_2.S_2, results_TXV_2.S_3_g, results_TXV_2.S_3,...
        results_TXV_2.S_4, results_TXV_2.S_5, results_TXV_2.S_1...
    ],...
    [...
        results_TXV_2.H_1, results_TXV_2.H_2, results_TXV_2.H_3_g, results_TXV_2.H_3,...
        results_TXV_2.H_4, results_TXV_2.H_5, results_TXV_2.H_1...
    ],...
    'o-'...
);
text(...
    [...
        results_TXV_2.S_1, results_TXV_2.S_2, results_TXV_2.S_3_g,...
        results_TXV_2.S_3, results_TXV_2.S_4, results_TXV_2.S_5,...
    ]...
    + [-30, 10 .* ones(1, 5)],...
    [...
        results_TXV_2.H_1, results_TXV_2.H_2, results_TXV_2.H_3_g,...
        results_TXV_2.H_3, results_TXV_2.H_4, results_TXV_2.H_5...
    ] - 5000,...
    {'1', '2', '3''', '3', '4', '5'}...
);

% Ideal cycle
plot(...
    [results_TXV_2.S_3, results_TXV_2.S_4_ideal, results_TXV_2.S_5],...
    [results_TXV_2.H_3, results_TXV_2.H_4_ideal, results_TXV_2.H_5],...
    'o--'...
);
text(results_TXV_2.S_4_ideal + 10, results_TXV_2.H_4_ideal - 5000, '4''');

% Work cycle
plot(...
    [results_TXV_2.S_3, results_TXV_2.S_4_work, results_TXV_2.S_5],...
    [results_TXV_2.H_3, results_TXV_2.H_4_work, results_TXV_2.H_5],...
    'o--'...
);
text(results_TXV_2.S_4_work + 10, results_TXV_2.H_4_work - 5000, '4''''');

% Saturation dome
plot(...
    [R12_sat.S_f; R12_sat.S_g(end: -1: 1)],...
    [R12_sat.H_f; R12_sat.H_g(end: -1: 1)],...
    '-'...
);
formatFig(...
    fig, 'figures/TXV_2_HS',...
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
        results_TXV_2.S_1, results_TXV_2.S_2, results_TXV_2.S_3_g, results_TXV_2.S_3,...
        results_TXV_2.S_4, results_TXV_2.S_5, results_TXV_2.S_1...
    ],...
    [...
        data.T1(idx_3), data.T2(idx_3), data.T2(idx_3), data.T3(idx_3),...
        data.T5(idx_3), data.T1(idx_3), data.T1(idx_3)...
    ],...
    'o-'...
);
text(...
    [...
        results_TXV_2.S_1, results_TXV_2.S_2, results_TXV_2.S_3_g,...
        results_TXV_2.S_3, results_TXV_2.S_4, results_TXV_2.S_5,...
    ]...
    + [-30, 10 .* ones(1, 5)],...
    [...
        data.T1(idx_3), data.T2(idx_3), data.T2(idx_3),...
        data.T3(idx_3), data.T5(idx_3), data.T1(idx_3)...
    ] - 5,...
    {'1', '2', '3''', '3', '4', '5'}...
);

% Ideal cycle
plot(...
    [results_TXV_2.S_3, results_TXV_2.S_4_ideal, results_TXV_2.S_5],...
    [data.T3(idx_3), results_TXV_2.T_4_ideal, data.T1(idx_3)],...
    'o--'...
);
text(results_TXV_2.S_4_ideal + 10, results_TXV_2.T_4_ideal - 5, '4''');

% Work cycle
plot(...
    [results_TXV_2.S_3, results_TXV_2.S_4_work, results_TXV_2.S_5],...
    [data.T3(idx_3), results_TXV_2.T_4_work, data.T1(idx_3)],...
    'o--'...
);
text(results_TXV_2.S_4_work + 10, results_TXV_2.T_4_work - 5, '4''''');

% Saturation dome
plot(...
    [R12_sat.S_f; R12_sat.S_g(end: -1: 1)],...
    [R12_sat.T; R12_sat.T(end: -1: 1)],...
    '-'...
);

% Air inlet temp
plot(results_TXV_2.S_2, data.T7(idx_3), 'x');
text(...
    results_TXV_2.S_2 + 10, data.T7(idx_3) - 5,...
    sprintf('$ T_{inlet} = %.1f K $', data.T7(idx_3)),...
    'Interpreter', 'latex'...
);

formatFig(...
    fig, 'figures/TXV_2_TS',...
    'XLabel', 'Entropy $S\ (J/kg \cdot K)$',...
    'YLabel', 'Temperature $T\ (K)$',...
    'axisScale', 'linear',...
    'legends', {'Experimental Cycle', 'Ideal Cycle', 'Compressor Cycle', 'Saturation Dome'}...
);
close(fig);

% Coefficient of performance
results_TXV_2.COP_real = COP_real(...
    data.mass(idx_3), results_TXV_2.H_2, results_TXV_2.H_3...
);
results_TXV_2.COP_ideal = COP_ideal(...
    results_TXV_2.H_2, results_TXV_2.H_3, results_TXV_2.H_4_ideal...
);

% Refrigeration capacity
results_TXV_2.RC = capacity(...
    data.mass(idx_3), results_TXV_2.H_2, results_TXV_2.H_3...
);

results_TXV_2 = struct2table(results_TXV_2);
