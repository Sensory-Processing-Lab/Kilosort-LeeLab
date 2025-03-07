function [O] = event_time_presentation(opentype,fpath, fname)

%{
EDIT LOG
2024/01/26 JHL
Code to convert Presentation log files into a Matlab variable integrated
into Pool.
currently event_codes are modified below. As different event_code IDs are
generated from various experiments, additional code structures will be
added to integrate this. 

For ease of use, rename all .log files into
'YYYY-MM-DD_animal_name_region.log'

2025/01/16 JHL
Updating method to detect reward outcome: 
- Included CS.
- If even a single lick is detected, it's considered licking
- Hit code output is Hit, Miss, CR and FA

%}

event_code = [211 212 2112 2122 1211 1212 12112 12122 8880];
O = {};

% event code
% Tra_R1_5kHz = 211;      Tra_R1_10kHz = 212;     Cond_R1_5kHz = 1211;    Cond_R1_10kHz = 1212;
% Tra_R2_5kHz = 2112;     Tra_R2_10kHz = 2122;    Cond_R2_5kHz = 12112;   Cond_R2_10kHz =12122;

% opentype = 1;
% if opentype == 1
% %     prompt = '230801_RL#602_AC_1200um-220112_CS_NotCuedAudRL_delay1000_HitOnly';
%     path = inputdlg(prompt);
%     filename = fopen(strcat(path{1,1}, '.log'));
% elseif opentype == 2
%     patharr = strsplit(pwd, '\');
%     path = patharr{1,length(patharr)};
%     filename = fopen(horzcat(path,'.log'));
% end


switch opentype
    case 1
        fname2 = dir(fullfile(fpath,filesep,[fname{1}(1:10),'*.log']));
        fname2 =fname2.name;
        %         f = fopen(fullfile(fpath,filesep,[fname,'*.log']));
        f = fopen(fullfile(fpath,filesep,fname2));
        
end

fromtxt=textscan(f,'%s %s %s %s %s %s %s %s %s %s %s %s %s','Delimiter','\t');
fclose(f);

l = load(fullfile(fpath,filesep,'Lick',filesep,[fname2(1:10),'_licks.mat']));
%%
txtcodearr = fromtxt{1,4};
txtcodearr2 = fromtxt{1,5};
% txtcodearr3 = fromtxt{1,3};
txtcodearr = str2double(txtcodearr(5:end,1));       % event type (code number)
txtcodearr2 = str2double(txtcodearr2(5:end,1));     % event time (10kHz)
txtcodelen = length(txtcodearr);                    % total number of events

% event time: stimulus
curr = 0;
for i=1:txtcodelen
    if txtcodearr(i) >= min(event_code)
        if sum(txtcodearr(i) == event_code) ~= 0
            curr = curr + 1;
            temp_txt(curr,1) = floor(txtcodearr2(i)/10);    % event time (ms, presentation)
            temp_txt(curr,2) = txtcodearr(i);               % event type (code number among event_code)
        end
    elseif isnan(txtcodearr(i)) % when NaN firstly appears, the task ends
        break
    end
end



O.event_code = event_code;
O.trial_type = temp_txt;
O.trial_tag = ["time (ms)", "trial_type"];

% event time: lick
curr = 1;
for i=1:size(fromtxt{1,4},1)
    if sum(double(cell2mat(fromtxt{1,3}(i)))) == 847
        lick(curr,1) = str2double(fromtxt{1,4}(i));
        lick(curr,2) = str2double(fromtxt{1,5}(i));
        curr = curr + 1;
    end
end
lick_time_temp = floor(lick(:,2)/10);


% lick overdetection
clear lick_time_ms
deterror = diff(lick_time_temp);
lick_time_ms(1,1) = lick_time_temp(1,1);
curr1 = 2;
for i = 1:size(deterror, 1)
    if deterror(i,1) > 100
        lick_time_ms(curr1,1) = lick_time_temp(i+1,1);
        curr1 = curr1 + 1;
    else
        continue
    end
end



% trial results. Only take rule stage, not conditioning stage

% log  ={};
% 
% for i = 1:13
%     for ii = 5:length(fromtxt{1})
%     log{ii-4,i} = fromtxt{i}{ii};
%         if i == 4
%             log{ii-4,i} = floor(str2double(log{ii-4,i})/10);
%         end
%     end
% end
% 
% t_ind = find([log{:,4}] == 31 | [log{:,4}] == 35 | [log{:,4}] == 41 | [log{:,4}] == 45);
% 
% h_ind = [log{t_ind,4}].';
% 
% hitcode= zeros(length(h_ind),4);
% for tr  = 1:length(h_ind)
%     if h_ind(tr) == 35
%         hitcode(tr,1) = 1;
%     elseif h_ind(tr) == 45
%         hitcode(tr,2) = 1;
%     elseif h_ind(tr) == 31
%         hitcode(tr,3) = 1;
%     elseif h_ind(tr) == 41
%         hitcode(tr,4) = 1;
%     end
% end


% lick detection and trial results 

hitcode = zeros(length(temp_txt),4);
outlick = zeros(length(temp_txt),1);
rw_on = 1500; % reward period onset and offset
rw_off = 4500;
stim_off = 500;

for tr = 1: length(temp_txt)
    if ismember(temp_txt(tr,2), [211 212 2112 2122])
        if sum((lick_time_ms>temp_txt(tr,1)+rw_on).*(lick_time_ms<temp_txt(tr,1)+rw_off)) > 0
            outlick(tr,1) = 1;
        end
    else
        if sum((lick_time_ms>temp_txt(tr,1)+stim_off).*(lick_time_ms<temp_txt(tr,1)+rw_on)) > 0
            outlick(tr,1) = 1;
        end
    end
end
        
for tr = 1:length(temp_txt)
    if outlick(tr,1) == 1
        if ismember(temp_txt(tr,2), [211 2122 1211 12122])
            hitcode(tr,1) = 1;
        else
            hitcode(tr,4) = 1;
        end
    else
        if ismember(temp_txt(tr,2), [211 2122 1211 12122])
            hitcode(tr,2) = 1;
        else
            hitcode(tr,3) = 1;
        end
    end
end
        
        



%%

O = {};
O.event_code = event_code;
O.trial_type = temp_txt;
O.trial_tag = ["time (ms)", "trial_type"];
O.hit_code = hitcode;
% O.log = log;
O.licks = l;
end
%%
% clearvars -except event_code lick lick_time_ms lick_time_temp temp_txt path
%
% save event.mat