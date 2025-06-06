function x = parameters()


%Modify parameters based on OpenEphys and xbz output. 

addpath('C:\Users\Seth\Documents\GitHub\Kilosort-Wanglab\Analysis')
x.PC_name = '426_Analysis';
x.animal_name = 'M12E';
x.session_name = '2019-07-25_13-50-02';
x.file_type = '100';
x.xbz_file_name = 'M12E0426';
x.fpath1 = directories(x.PC_name,x.animal_name,x.session_name);
x.fpath = [x.fpath1 x.session_name];
x.fs = 30000;
x.Nb_ch = 64;
x.chanMap = [27 32 21 3 25 30 19 5 23 17 24 7 20 29 26 9 ...
    22 31 28 11 16 13 1 15 18 12 14 10 8 4 6 2 ...
    64 60 62 58 56 52 54 48 49 53 51 55 57 61 59 63 ...
    38 42 40 45 43 35 33 47 36 50 34 44 46 39 41 37];

