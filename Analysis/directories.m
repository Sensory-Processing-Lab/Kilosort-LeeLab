function fpath = directories(PC_name,animal_name,session_name)
% Select PC name : Chamber_T, 426_Analysis 426_John

if strcmp(PC_name,'426_John')
    start_path = 'C:\Users\John.Lee\';
    kilo_path = 'copy\KiloSort';
elseif strcmp(PC_name,'Chamber_T') || strcmp(PC_name,'426_Analysis')
    start_path = 'C:\Users\Seth\';
    kilo_path = 'KiloSort';
end

addpath(genpath(fullfile(start_path, 'Documents\GitHub\', kilo_path))); % path to kilosort folder
addpath(genpath(fullfile(start_path, 'Documents\GitHub\npy-matlab'))); % path to npy-matlab scripts
addpath(genpath(fullfile(start_path,'Documents\GitHub\analysis-tools')));

addpath(fullfile('C:\DATA\OpenEphys\', animal_name));
fpath = fullfile('C:\DATA\OpenEphys\', animal_name, filesep, session_name);% where on disk do you want the simulation? ideally and SSD...