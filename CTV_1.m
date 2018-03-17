%% CTV_1

results_CTV_1 = struct(...
    'P_1', [], 'v_1', [], 'H_1', [],...
    'P_2', [], 'v_2', [], 'H_2', [], 'x_2', [],...
    'P_3', [], 'v_3', [], 'H_3', [],...
    'P_3_g', [], 'v_3_g', [],...
    'P_4', [], 'v_4', [],...
    'v_4_ideal', [], 'T_4_ideal', [],...
    'v_4_work', [], 'T_4_work', [], 'H_4_work', [],...
    'P_5', [], 'v_5', []...
);

idx_4 = 7;

% #1: T1 gives specific volume (saturated liquid)
results_CTV_1.P_1 = data.P1(idx_4);
results_CTV_1.v_1 = interp1(R12_sat.T, R12_sat.v_f, data.T1(idx_4));
results_CTV_1.H_1 = interp1(R12_sat.T, R12_sat.H_f, data.T1(idx_4));

% #2: same enthalpy, T2 gives quality x
results_CTV_1.P_2 = data.P2(idx_4);
results_CTV_1.H_2 = results_CTV_1.H_1;
H_2_f = interp1(R12_sat.T, R12_sat.H_f, data.T2(idx_4));
H_2_g = interp1(R12_sat.T, R12_sat.H_g, data.T2(idx_4));
v_2_f = interp1(R12_sat.T, R12_sat.v_f, data.T2(idx_4));
v_2_g = interp1(R12_sat.T, R12_sat.v_g, data.T2(idx_4));
results_CTV_1.x_2 = quality(H_2_f, H_2_g, results_CTV_1.H_2);
results_CTV_1.v_2 = mix(v_2_f, v_2_g, results_CTV_1.x_2);

% #3_g: isobaric, isothermal
results_CTV_1.P_3_g = results_CTV_1.P_2;
results_CTV_1.v_3_g = interp1(R12_sat.P, R12_sat.v_g, data.P2(idx_4));

% #3: pressure table
results_CTV_1.P_3 = data.P3(idx_4);
[T, P] = meshgrid(R12_P_8.T, (290: 10: 310) .* 1000);
results_CTV_1.v_3 = interp2(...
    T, P, [R12_P_8.v_290, R12_P_8.v_300, R12_P_8.v_310].',...
    data.T3(idx_4), data.P3(idx_4)...
);
results_CTV_1.H_3 = interp2(...
    T, P, [R12_P_8.H_290, R12_P_8.H_300, R12_P_8.H_310].',...
    data.T3(idx_4), data.P3(idx_4)...
);
results_CTV_1.S_3 = interp2(...
    T, P, [R12_P_8.S_290, R12_P_8.S_300, R12_P_8.S_310].',...
    data.T3(idx_4), data.P3(idx_4)...
);

% #4
% Experimental Value
results_CTV_1.P_4 = data.P4(idx_4);
[T, P] = meshgrid(R12_P_16.T, [1200, 1300] .* 1000);
results_CTV_1.v_4 = interp2(...
    T, P,...
    [R12_P_16.v_1200, R12_P_16.v_1300].',...
    data.T5(idx_4), data.P4(idx_4)...
);

% Value based on work done by compressor (use H & P)
results_CTV_1.H_4_work = results_CTV_1.H_3 + 600 ./ data.mass(idx_4);
results_CTV_1.T_4_work = fzero(...
    @(T_4_work) interp2(...
        T, P,...
        [R12_P_16.H_1200, R12_P_16.H_1300].',...
        T_4_work, data.P4(idx_4)...
    ) - results_CTV_1.H_4_work,...
    data.T5(idx_4) + 50 ...
);
results_CTV_1.v_4_work = interp2(...
    T, P,...
    [R12_P_16.v_1200, R12_P_16.v_1300].',...
    results_CTV_1.T_4_work, data.P4(idx_4)...
);

% Ideal value
results_CTV_1.S_4_ideal = results_CTV_1.S_3;
results_CTV_1.T_4_ideal = fzero(...
    @(T_4_ideal) interp2(...
        T, P,...
        [R12_P_16.S_1200, R12_P_16.S_1300].',...
        T_4_ideal, data.P4(idx_4)...
    ) - results_CTV_1.S_4_ideal,...
    data.T5(idx_4) + 10 ...
);
results_CTV_1.v_4_ideal = interp2(...
    T, P,...
    [R12_P_16.v_1200, R12_P_16.v_1300].',...
    results_CTV_1.T_4_ideal, data.P4(idx_4)...
);

% #5: isobaric, isothermal
results_CTV_1.P_5 = results_CTV_1.P_1;
results_CTV_1.v_5 = interp1(R12_sat.P, R12_sat.v_g, data.P1(idx_4));

% H-S Diagram
fig = figure;
hold on;

% Experimental cycle
plot(...
    [...
        results_CTV_1.v_1, results_CTV_1.v_2, results_CTV_1.v_3_g, results_CTV_1.v_3,...
        results_CTV_1.v_4, results_CTV_1.v_5, results_CTV_1.v_1...
    ],...
    [...
        results_CTV_1.P_1, results_CTV_1.P_2, results_CTV_1.P_3_g, results_CTV_1.P_3,...
        results_CTV_1.P_4, results_CTV_1.P_5, results_CTV_1.P_1...
    ],...
    'o-'...
);
text(...
    [...
        results_CTV_1.v_1, results_CTV_1.v_2, results_CTV_1.v_3_g,...
        results_CTV_1.v_3, results_CTV_1.v_4, results_CTV_1.v_5,...
    ],...
    [...
        results_CTV_1.P_1, results_CTV_1.P_2, results_CTV_1.P_3_g,...
        results_CTV_1.P_3, results_CTV_1.P_4, results_CTV_1.P_5...
    ] + 5e4,...
    {'1', '2', '3''', '3', '4', '5'}...
);

% Ideal cycle
plot(...
    [results_CTV_1.v_3, results_CTV_1.v_4_ideal, results_CTV_1.v_5],...
    [results_CTV_1.P_3, results_CTV_1.P_4, results_CTV_1.P_5],...
    'o--'...
);
text(results_CTV_1.v_4_ideal, results_CTV_1.P_4 + 5e4, '4''');

% Work cycle
plot(...
    [results_CTV_1.v_3, results_CTV_1.v_4_work, results_CTV_1.v_5],...
    [results_CTV_1.P_3, results_CTV_1.P_4, results_CTV_1.P_5],...
    'o--'...
);
text(results_CTV_1.v_4_work, results_CTV_1.P_4 + 5e4, '4''''');

% Saturation dome
plot(...
    [R12_sat.v_f; R12_sat.v_g(end: -1: 1)],...
    [R12_sat.P; R12_sat.P(end: -1: 1)],...
    '-'...
);
formatFig(...
    fig, 'figures/CTV_1_PV',...
    'XLabel', 'Specific Volume $v\ (m^3 / kg)$',...
    'YLabel', 'Pressure $P\ (Pa)$',...
    'XLim', [0, 0.075],...
    'YLim', [0, 2e6],...
    'axisScale', 'linear',...
    'legends', {'Experimental Cycle', 'Ideal Cycle', 'Compressor Cycle', 'Saturation Dome'}...
);
close(fig);

results_CTV_1 = struct2table(results_CTV_1);
