%% Superheat investigation
results_superheat = struct();
results_superheat.DeltaP = estm([...
    data.P3(idx_2) - data.P2(idx_2),...
    data.P3(idx_3) - data.P2(idx_3)...
]);

% Visualization
fig = figure;
hold on;

% TXV_1
plot(...
    [...
        results_TXV_1.S_1, results_TXV_1.S_2, results_TXV_1.S_3_g, results_TXV_1.S_3,...
        results_TXV_1.S_4, results_TXV_1.S_5, results_TXV_1.S_1...
    ],...
    [...
        results_TXV_1.H_1, results_TXV_1.H_2, results_TXV_1.H_3_g, results_TXV_1.H_3,...
        results_TXV_1.H_4, results_TXV_1.H_5, results_TXV_1.H_1...
    ],...
    'o-'...
);

% TXV_2
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
plot(...
    [R12_sat.S_f; R12_sat.S_g(end: -1: 1)],...
    [R12_sat.H_f; R12_sat.H_g(end: -1: 1)],...
    '-'...
);

formatFig(...
    fig, 'figures/superheat_HS',...
    'XLabel', 'Entropy $S\ (J/kg \cdot K)$',...
    'YLabel', 'Enthalpy $H\ (J/kg)$',...
    'axisScale', 'linear',...
    'legends', {'TXV Cycle 1', 'TXV Cycle 2', 'Saturation Dome'}...
);
close(fig);
