function x = parameters_distanceS()


x.PC_name = '426_Analysis';
x.animal_name = 'M56E';
% x.list_data_name = [x.animal_name '_unit_list']; %Do not modify this
x.list_data_name = 'unit_list'; %Do not modify this


switch x.PC_name
    case '426_Analysis'
        addpath('C:\Users\Seth\Documents\GitHub\Kilosort-Wanglab\tjdS');
        x.save_dir = fullfile('D:\Data\Units', filesep, x.animal_name);
        try
            addpath(x.save_dir);
        catch
            error('path not found')
        end
        
    case '426_Analysis_CI'
        
end



x.hole_number = 1;
x.track_number = 5;
x.depth = 905;
x.hemi = 'L';
x.segment_list = {    
'M56E0052'
'M56E0053'
'M56E0054'
'M56E0055'
'M56E0056'
'M56E0057'
'M56E0059'
'M56E0060'
'M56E0061'
'M56E0062'
'M56E0063'



};






