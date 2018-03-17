% Clean up
clc; close all;

if ~exist('data', 'var')
    load('data.mat');
end

%% Functions

quality = @(f, g, mix) (mix - f) ./ (g - f);
mix = @(f, g, x) sum([f, g] .* [1 - x, x]);
COP_real = @(mass, H2, H3) mass .* (H3 - H2) ./ 600;
COP_ideal = @(H2, H3, H4) (H3 - H2) ./ (H4 - H3);
capacity = @(mass, H2, H3) mass .* (H3 - H2);

%% H-S & T-S Diagrams
AXV_3;

TXV_1;

TXV_2;

%% P-V Diagrams
CTV_1;

CTV_2;

CTV_3;

%% Superheat in TXV
superheat;

%% POC & RC vs P3
AXV_1;

AXV_2;

% Visualization
fig = figure;
hold on;
plot(...
    data.P3(1: 3) - 101325,...
    [...
        results_AXV_1.COP_real,...
        results_AXV_2.COP_real,...
        results_AXV_3.COP_real...
    ],...
    'o-'...
);
plot(...
    data.P3(1: 3) - 101325,...
    [...
        results_AXV_1.COP_ideal,...
        results_AXV_2.COP_ideal,...
        results_AXV_3.COP_ideal...
    ],...
    'o-'...
);

formatFig(...
    fig, 'figures/AXV_COP',...
    'XLabel', 'Suction Pressure $P\ (Pa)$',...
    'YLabel', 'Coefficient of Performance $COP$',...
    'YLim', [0, 4.5],...
    'legends', {'Real COP', 'Ideal COP'},...
    'axisScale', 'linear'...
);
close(fig);

system('ls figures/*.eps | xargs -I {} /Library/TeX/texbin/epstopdf {}');

save('results');
