varname = R12_P_17.Properties.VariableNames;
R12_P_17.Properties.VariableNames{1} = 'T';
R12_P_17.T = R12_P_17.T + 273.17;
for idx = 2: length(varname)

    % R12_P_3.(varname{idx}) = str2double(R12_P_3.(varname{idx}));

    if strcmp(varname{idx}(1: 3), 'Var')
        R12_P_17.(varname{idx}) = [];
        continue;
    end

    if strcmp(varname{idx}(1), 'H') || strcmp(varname{idx}(1), 'S')
        R12_P_17.(varname{idx}) = R12_P_17.(varname{idx}) .* 1000;
    end

end
