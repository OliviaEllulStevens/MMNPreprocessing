%Script #5
%Operates on individual subject data
%Uses the output from Script #4: Remove_ICA_Components.m
%This script loads the semi-continuous ICA-corrected EEG data file from Script #4, creates an Event List containing a record of all event codes and their timing, assigns events to bins using Binlister, epochs the EEG, and performs baseline correction.

close all; clearvars;

%Location of the main study directory
%This method of specifying the study directory only works if you run the script; for running individual lines of code, replace the study directory with the path on your computer, e.g.: 
%DIR = /Users/KappenmanLab/ERP_CORE/MMN
DIR = '/Users/oliviastevens/Documents/ERP_CORE-master/MMN_Experimental-OliviaScripts';

%Location of the folder that contains this script and any associated processing files
%This method of specifying the current file path only works if you run the script; for running individual lines of code, replace the current file path with the path on your computer, e.g.: 
%Current_File_Path = /Users/KappenmanLab/ERP_CORE/MMN/EEG_ERP_Processing
Current_File_Path = '/Users/oliviastevens/Documents/ERP_CORE-master/MMN_Experimental-OliviaScripts/EEG_ERP_Processing';

%List of subjects to process, based on the name of the folder that contains that subject's data
SUB = {'82', '83'};	

%%%% EVENT CODES (standards = ends in 1, deviants = ends in 2)
%%%% - 21+32
%%%% - 41+12
%%%% - 11+22
%%%% - 41+32
%%%% - 31+22
%%%% - 31+42
%%%% - 21+12
%%%% - 11+42

%% 8 bins, one code for each number ^

%%%% PAIRED BLOCK MARKERS
%%%% End marker	Start marker
%%%% 91	    8
%%%% 92	    2
%%%% 93	    7
%%%% 94	    6
%%%% 95	    5
%%%% 96	    2
%%%% 97	    1
%%%% 98	    5

%**********************************************************************************************************************************************************************

%Loop through each subject listed in SUB
for i = 1:length(SUB)

    %Open EEGLAB and ERPLAB Toolboxes  
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    
    %Define subject path based on study directory and subject ID of current subject
    Subject_Path = [DIR filesep SUB{i} filesep];

    %Load the semi-continuous ICA-corrected EEG data file outputted from Script #4 in .set EEGLAB file format
    EEG = pop_loadset( 'filename', [SUB{i} '_MMN_ds_reref_ucbip_hpfilt_ica_corr_cbip.set'], 'filepath', Subject_Path);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', [SUB{i} '_MMN_ds_reref_ucbip_hpfilt_ica_corr_cbip'], 'gui', 'off'); 

    %Create EEG Event List containing a record of all event codes and their timing
    EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', [Subject_Path SUB{i} '_MMN_Eventlist.txt'] ); 
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2, 'setname', [SUB{i} '_MMN_ds_reref_ucbip_hpfilt_ica_corr_cbip_elist'], 'savenew', [Subject_Path SUB{i} '_MMN_ds_reref_ucbip_hpfilt_ica_corr_cbip_elist.set'], 'gui', 'off');

    %Assign events to bins with Binlister; an individual trial may be assigned to more than one bin (bin assignments can be reviewed in each subject's MMN_Eventlist_Bins.txt file)
    EEG  = pop_binlister( EEG , 'BDF', [Current_File_Path filesep 'BDF_MMN.txt'], 'ExportEL', [Subject_Path SUB{i} '_MMN_Eventlist_Bins.txt'], 'IndexEL',  1, 'SendEL2', 'EEG&Text', 'UpdateEEG', 'on', 'Voutput', 'EEG' );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3, 'setname', [SUB{i} '_MMN_ds_reref_ucbip_hpfilt_ica_corr_cbip_elist_bins'], 'savenew', [Subject_Path SUB{i} '_MMN_ds_reref_ucbip_hpfilt_ica_corr_cbip_elist_bins.set'], 'gui', 'off'); 

    %Epoch the EEG into 1-second segments time-locked to the response (from -200 ms to 800 ms) and perform baseline correction using the average activity from -200 ms to 0 ms 
    EEG = pop_epochbin( EEG , [-200.0  800.0],  [-200.0  0.0]);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4, 'setname', [SUB{i} '_MMN_ds_reref_ucbip_hpfilt_ica_corr_cbip_elist_bins_epoch'], 'savenew', [Subject_Path SUB{i} '_MMN_ds_reref_ucbip_hpfilt_ica_corr_cbip_elist_bins_epoch.set'], 'gui', 'off'); 
    close all;
    
%End subject loop
end

%**********************************************************************************************************************************************************************
