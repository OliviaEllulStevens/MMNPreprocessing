%Script #9
%Operates on individual subject data
%Uses the output from Script #7: Average_ERPs.m
%This script uses the individual subject averaged ERP waveforms from Script #7 to create grand average ERP waveforms across participants both with and without a low-pass filter applied. 

close all; clearvars;

%Location of the main study directory
%This method of specifying the study directory only works if you run the script; for running individual lines of code, replace the study directory with the path on your computer, e.g.: 
%DIR = /Users/KappenmanLab/ERP_CORE/MMN
DIR = '/Users/oliviastevens/Documents/ERP_CORE-master/MMN_Experimental-OliviaScripts';

%Location of the folder that contains this script and any associated processing files
%This method of specifying the current file path only works if you run the script; for running individual lines of code, replace the current file path with the path on your computer, e.g.: 
%Current_File_Path = /Users/KappenmanLab/ERP_CORE/MMN/EEG_ERP_Processing/Grand_Average_ERPs
Current_File_Path = '/Users/oliviastevens/Documents/ERP_CORE-master/MMN_Experimental-OliviaScripts/EEG_ERP_Processing/Grand_Average_ERPs';

%List of subjects to include in the grand average ERP waveforms (i.e., subjects that were not excluded due to excessive artifacts), based on the name of the folder that contains that subject's data
SUB = {'82', '83'};	

%*************************************************************************************************************************************

%Create grand average ERP waveforms from individual subject ERPs without low-pass filter applied 

%Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

%Create a text file containing a list of ERPsets and their file locations to include in the grand average ERP waveforms
ERPset_list = fullfile(Current_File_Path, 'GA_MMN_erp_ar_diff_waves.txt');
fid = fopen(ERPset_list, 'w');
    for i = 1:length(SUB)
        Subject_Path = [DIR filesep SUB{i} filesep];
        erppath = [Subject_Path SUB{i} '_MMN_erp_ar_diff_waves.erp'];
        fprintf(fid,'%s\n', erppath);
    end
fclose(fid);

%Create a grand average ERP waveform
ERP = pop_gaverager( ERPset_list , 'ExcludeNullBin', 'on', 'SEM', 'on' );
ERP = pop_savemyerp(ERP, 'erpname', 'GA_MMN_erp_ar_diff_waves', 'filename', 'GA_MMN_erp_ar_diff_waves.erp', 'filepath', Current_File_Path, 'Warning', 'off');

%*************************************************************************************************************************************

%Create grand average ERP waveforms from individual subject ERPs with a low-pass filter applied

%Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

%Create a text file containing a list of low-pass filtered ERPsets and their file locations to include in the grand average ERP waveforms
ERPset_list = fullfile(Current_File_Path, 'GA_MMN_erp_ar_diff_waves_lpfilt.txt');
fid = fopen(ERPset_list, 'w');
    for i = 1:length(SUB)
        Subject_Path = [DIR filesep SUB{i} filesep];
        erppath = [Subject_Path SUB{i} '_MMN_erp_ar_diff_waves_lpfilt.erp'];
        fprintf(fid,'%s\n', erppath);
    end
fclose(fid);

%Create a grand average ERP waveform
ERP = pop_gaverager( ERPset_list , 'ExcludeNullBin', 'on', 'SEM', 'on' );
ERP = pop_savemyerp(ERP, 'erpname', 'GA_MMN_erp_ar_diff_waves_lpfilt', 'filename', 'GA_MMN_erp_ar_diff_waves_lpfilt.erp', 'filepath', Current_File_Path, 'Warning', 'off');

%*************************************************************************************************************************************
