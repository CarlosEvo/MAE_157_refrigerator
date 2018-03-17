%% CTV_2

results_CTV_2 = struct(...
    'P_1', [], 'v_1', [], 'H_1', [],...
    'P_2', [], 'v_2', [], 'H_2', [], 'x_2', [],...
    'P_3', [], 'v_3', [], 'H_3', [],...
    'P_3_g', [], 'v_3_g', [],...
    'P_4', [], 'v_4', [],...
    'v_4_ideal', [], 'T_4_ideal', [],...
    'v_4_work', [], 'T_4_work', [], 'H_4_work', [],...
    'P_5', [], 'v_5', []...
);

idx_5 = 8;

% #1: T1 gives specific volume (saturated liquid)
results_CTV_2.P_1 = data.P1(idx_5);
results_CTV_2.v_1 = interp1(R12_sat.T, R12_sat.v_f, data.T1(idx_5));
results_CTV_2.H_1 = interp1(R12_sat.T, R12_sat.H_f, data.T1(idx_5));

% #2: same enthalpy, T2 gives quality x
results_CTV_2.P_2 = data.P2(idx_5);
results_CTV_2.H_2 = results_CTV_2.H_1;
H_2_f = interp1(R12_sat.T, R12_sat.H_f, data.T2(idx_5));
H_2_g = interp1(R12_sat.T, R12_sat.H_g, data.T2(idx_5));
v_2_f = interp1(R12_sat.T, R12_sat.v_f, data.T2(idx_5));
v_2_g = interp1(R12_sat.T, R12_sat.v_g, data.T2(idx_5));
results_CTV_2.x_2 = quality(H_2_f, H_2_g, results_CTV_2.H_2);
results_CTV_2.v_2 = mix(v_2_f, v_2_g, results_CTV_2.x_2);

% #3_g: isobaric, isothermal
results_CTV_2.P_3_g = results_CTV_2.P_2;
results_CTV_2.v_3_g = interp1(R12_sat.P, R12_sat.v_g, data.P2(idx_5));

% #3: pressure table
results_CTV_2.P_3 = data.P3(idx_5);
[T, P] = meshgrid(R12_P_9.T, [320, 330] .* 1000);
results_CTV_2.v_3 = interp2(...
    T, P, [R12_P_9.v_320, R12_P_9.v_330].',...
    data.T4(idx_5), data.P3(idx_5)...
);
results_CTV_2.H_3 = interp2(...
    T, P, [R12_P_9.H_320, R12_P_9.H_330].',...
    data.T4(idx_5), data.P3(idx_5)...
);
results_CTV_2.S_3 = interp2(...
    T, P, [R12_P_9.S_320, R12_P_9.S_330].',...
    data.T4(idx_5), data.P3(idx_5)...
);

% #4
% Experimental Value
results_CTV_2.P_4 = data.P4(idx_5);
[T, P] = meshgrid(R12_P_17.T, [1400, 1500] .* 1000);
results_CTV_2.v_4 = interp2(...
    T, P,...
    [R12_P_16.v_1400(3: end), R12_P_17.v_1500].',...
    data.T5(idx_5), data.P4(idx_5)...
);

% Value based on work done by compressor (use H & P)
results_CTV_2.H_4_work = results_CTV_2.H_3 + 600 ./ data.mass(idx_5);
results_CTV_2.T_4_work = fzero(...
    @(T_4_work) interp2(...
        T, P,...
        [R12_P_16.H_1400(3: end), R12_P_17.H_1500].',...
        T_4_work, data.P4(idx_5)...
    ) - results_CTV_2.H_4_work,...
    data.T5(idx_5) + 50 ...
);
results_CTV_2.v_4_work = interp2(...
    T, P,...
    [R12_P_16.v_1400(3: end), R12_P_17.v_1500].',...
    results_CTV_2.T_4_work, data.P4(idx_5)...
);

% Ideal value
results_CTV_2.S_4_ideal = results_CTV_2.S_3;
results_CTV_2.T_4_ideal = fzero(...
    @(T_4_ideal) interp2(...
        T, P,...
        [R12_P_16.S_1400(3: end), R12_P_17.S_1500].',...
        T_4_ideal, data.P4(idx_5)...
    ) - results_CTV_2.S_4_ideal,...
    data.T5(idx_5) + 10 ...
);
results_CTV_2.v_4_ideal = interp2(...
    T, P,...
    [R12_P_16.v_1400(3: end), R12_P_17.v_1500].',...
    results_CTV_2.T_4_ideal, data.P4(idx_5)...
);

% #5: isobaric, isothermal
results_CTV_2.P_5 = results_CTV_2.P_1;
results_CTV_2.v_5 = interp1(R12_sat.P, R12_sat.v_g, data.P1(idx_5));

% H-S Diagram
fig = figure;
hold on;

% Experimental cycle
plot(...
    [...
        results_CTV_2.v_1, results_CTV_2.v_2, results_CTV_2.v_3_g, results_CTV_2.v_3,...
        results_CTV_2.v_4, results_CTV_2.v_5, results_CTV_2.v_1...
    ],...
    [...
        results_CTV_2.P_1, results_CTV_2.P_2, results_CTV_2.P_3_g, results_CTV_2.P_3,...
        results_CTV_2.P_4, results_CTV_2.P_5, results_CTV_2.P_1...
    ],...
    'o-'...
);
text(...
    [...
        results_CTV_2.v_1, results_CTV_2.v_2, results_CTV_2.v_3_g,...
        results_CTV_2.v_3, results_CTV_2.v_4, results_CTV_2.v_5,...
    ],...
    [...
        results_CTV_2.P_1, results_CTV_2.P_2, results_CTV_2.P_3_g,...
        results_CTV_2.P_3, results_CTV_2.P_4, results_CTV_2.P_5...
    ] + 5e4,...
    {'1', '2', '3''', '3', '4', '5'}...
);

% Ideal cycle
plot(...
    [results_CTV_2.v_3, results_CTV_2.v_4_ideal, results_CTV_2.v_5],...
    [results_CTV_2.P_3, results_CTV_2.P_4, results_CTV_2.P_5],...
    'o--'...
);
text(results_CTV_2.v_4_ideal, results_CTV_2.P_4 + 5e4, '4''');

% Work cycle
plot(...
    [results_CTV_2.v_3, results_CTV_2.v_4_work, results_CTV_2.v_5],...
    [results_CTV_2.P_3, results_CTV_2.P_4, results_CTV_2.P_5],...
    'o--'...
);
text(results_CTV_2.v_4_work, results_CTV_2.P_4 + 5e4, '4''''');

% Saturation dome
plot(...
    [R12_sat.v_f; R12_sat.v_g(end: -1: 1)],...
    [R12_sat.P; R12_sat.P(end: -1: 1)],...
    '-'...
);
formatFig(...
    fig, 'figures/CTV_2_PV',...
    'XLabel', 'Specific Volume $v\ (m^3 / kg)$',...
    'YLabel', 'Pressure $P\ (Pa)$',...
    'XLim', [0, 0.075],...
    'YLim', [0, 2e6],...
    'axisScale', 'linear',...
    'legends', {'Experimental Cycle', 'Ideal Cycle', 'Compressor Cycle', 'Saturation Dome'}...
);
close(fig);

results_CTV_2 = struct2table(results_CTV_2);
