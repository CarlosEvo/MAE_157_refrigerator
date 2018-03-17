% Clean up
clc; close all;

if ~exist('data', 'var')
    load('data.mat');
end

%% Functions

quality = @(f, g, mix) (mix - f) ./ (g - f);
mix = @(f, g, x) sum([f, g] .* [1 - x, x]);
COP = @(H2, H3, H4) (H3 - H2) ./ (H4 - H3);
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
