function [data_analysis, data_aqua, data_CFU, AquA_fileName] = loadAnalysisData(sortedFileNames, experiment)
    % Function to load analysis data, AQuA2 data, and CFU data for a given experiment.
    %
    % Inputs:
    %   FilesAll - Cell array of file paths for all experiments.
    %   experiment - Index of the experiment to process.
    %
    % Outputs:
    %   data_analysis - Loaded analysis data from the specified .mat file.
    %   data_aqua - Loaded AQuA2 data.
    %   data_CFU - Loaded CFU data.


    % Load analysis .mat file
    data_analysis = load(sortedFileNames{experiment});
    features = data_analysis.resultsRaw.Row; % Extract features (optional)
    results_complete = data_analysis.resultsRaw.Variables; % Extract variables (optional)

    % Construct AQuA2 directory path
    if experiment == 37
        fileTemp_parts = strsplit(data_analysis.filename, '_');
        aqua_directory = fullfile('D:\2photon\Simone\Simone_Macrophages\', ...
            fileTemp_parts{1,1}, '\', ...
            [fileTemp_parts{1,2} '_' fileTemp_parts{1,3}], '\AQuA2\', ...
            [fileTemp_parts{1,1} '_' fileTemp_parts{1,2} '_' fileTemp_parts{1,3} '_reg_green_Substack(1-927)']);
        AquA_fileName = [data_analysis.filename '_AQuA2.mat'];
    else
        fileTemp_parts = strsplit(data_analysis.filename, '_');
        aqua_directory = fullfile('D:\2photon\Simone\Simone_Macrophages\', ...
            fileTemp_parts{1}, ...
            [fileTemp_parts{2} '_' fileTemp_parts{3}], '\AQuA2\', ...
            [fileTemp_parts{1} '_' fileTemp_parts{2} '_' fileTemp_parts{3} '_run1_reg_Z01_green_Substack(1-927)']);
        AquA_fileName = [data_analysis.filename '_AQuA2.mat'];
    end

    % Load AQuA2.mat file
    fullFilePath = fullfile(aqua_directory, AquA_fileName);
    data_aqua = load(fullFilePath);

    % Construct CFU directory path
    CFU_directory = fullfile('D:\2photon\Simone\Simone_Macrophages\', ...
        fileTemp_parts{1}, ...
        [fileTemp_parts{2} '_' fileTemp_parts{3}], '\AQuA2\');
    CFU_fileName = [data_analysis.filename '_AQuA_res_cfu.mat'];

    % Load CFU.mat file
    CFU_FilePath = fullfile(CFU_directory, CFU_fileName);
    data_CFU = load(CFU_FilePath);
end
