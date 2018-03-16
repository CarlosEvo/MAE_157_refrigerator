% Clean up
clc; close all;

if ~exist('data', 'var')
    load('data.mat');
end

%% Functions

quality = @(f, g, mix) (mix - f) ./ (g - f);
mix = @(f, g, x) sum([f, g] .* [1 - x, x]);

AXV_3;

TCX_1;

TCX_2;
