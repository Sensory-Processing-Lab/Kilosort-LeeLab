function separate_probes()


tic
addpath(genpath('D:\GitHub\Kilosort2')) % path to kilosort folder

addpath(genpath('D:\\GitHub\npy-matlab')) % path to npy-matlab scripts

addpath(genpath('D:\GitHub\NPMK\NPMK'))

fname1 = 'continuous.dat';
fpath_main = 'D:\DATA\Reversal Learning\TSn003\2024-10-30_13-50-34';
filepath    = fullfile(fpath_main, filesep, fname1);
% Big_buff = [];
% tic

% intializing parameters
NchanTOT = 64*3;
ntbuff = 64;
NT= 32*1024 + ntbuff;
NTbiff = NT; %+ 3*ntbuff; 
bytes       = get_file_size(filepath); % size in bytes of raw binary
nTimepoints = floor(bytes/NchanTOT/2); % number of total timepoints
Nbatch      = ceil(nTimepoints /NT); 


fpath = {};
fpath.A = fullfile(fpath_main,filesep,'probeA');
if ~exist(fpath.A, 'dir'); mkdir(fpath.A); end
fpath.B = fullfile(fpath_main,filesep,'probeB');
if ~exist(fpath.B, 'dir'); mkdir(fpath.B); end
fpath.C = fullfile(fpath_main,filesep,'probeC');
if ~exist(fpath.C, 'dir'); mkdir(fpath.C); end


fid = fopen(filepath,'r');
fidA = fopen(fullfile(fpath.A,filesep,fname1),'w');
fidB = fopen(fullfile(fpath.B,filesep,fname1),'w');
fidC = fopen(fullfile(fpath.C,filesep,fname1),'w');

fprintf('Time %3.0fs. Loading raw data and separating to individual probes... \n', toc);


for ibatch = 1:Nbatch
% offset = max(0,2*NchanTOT*(NT * (2-1))); % number of samples to start reading at.
    offset = 2*NchanTOT*NTbiff*(ibatch-1);
    fseek(fid, offset, 'bof'); % fseek to batch start in raw file
    buff = fread(fid, [NchanTOT NTbiff], '*int16');
    fwrite(fidA,buff(1:64,:),'*int16');
    fwrite(fidB,buff(65:64*2,:),'*int16');
    fwrite(fidC,buff(129:64*3,:),'*int16');
end

fclose(fid); fclose(fidA); fclose(fidB); fclose(fidC);
fprintf('Time %3.0fs. Finished separating to individual probes... \n', toc);