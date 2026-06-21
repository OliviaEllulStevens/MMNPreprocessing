%Script #8
%Operates on individual subject data
%Uses the output from Script #7: Average_ERPs.m
%This script loads the low-pass filtered averaged ERP waveforms from Script #7, plots the difference waveforms, parent waveforms, ICA-corrected and uncorrected HEOG, and ICA-corrected VEOG,
%and saves pdfs of all of the plots in the graphs folder located within each subjects's data folder.

close all; clearvars;

%Location of the main study directory, based on where this script is saved
%This method of specifying the study directory only works if you run the script; for running individual lines of code, replace the study directory with the path on your computer, e.g.: 
%DIR = /Users/KappenmanLab/ERP_CORE/MMN
DIR = '/Users/oliviastevens/Documents/ERP_CORE-master/MMN_Experimental-OliviaScripts';

%List of subjects to process, based on the name of the folder that contains that subject's data
SUB = {'82', '83'};	

%**********************************************************************************************************************************************************************

%%%% Produces individual subject ERPs
%%%% - Parent waves (standards & deviants)
%%%% - MMN Difference Waves 
%%%% - Finds out if MMN is in expected window (~100-250ms)

%Set baseline correction period in milliseconds
baselinecorr = '-200 0';

%Set x-axis scale in milliseconds
%xscale = [-200.0 800.0   -200:200:800];
xscale = [-100 300   -100:100:300];

%Set y-axis scale in microvolts for the EEG channels for the parent waves
yscale_EEG_parent = [-15.0 15.0   -15:10:15];

%Set y-axis scale in microvolts for the EEG channels for the difference waves
%yscale_EEG_diff = [-10.0 10.0   -10:2:10];
yscale_EEG_diff = [-3.0 3.0   -3:1:3];

% %Set y-axis scale in microvolts for the ICA-corrected and uncorrected bipolar HEOG channels
% yscale_HEOG = [-15.0 15.0   -15:5:15];

%Set y-axis scale in microvolts for the ICA-corrected monopolar VEOG signals and corrected bipolar VEOG signal
yscale_VEOG = [-25.0 25.0   -25:10:25];

%Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    
%Loop through each subject listed in SUB
for i = 1:length(SUB)

    %Define subject path based on study directory and subject ID of current subject
    Subject_Path = [DIR filesep SUB{i} filesep];

    %Load the low-pass filtered averaged ERP waveforms outputted from Script #7 in .erp ERPLAB file format
    ERP = pop_loaderp('filename', [SUB{i} '_MMN_erp_ar_diff_waves_lpfilt.erp'], 'filepath', Subject_Path);    
    
    %Plot the MMN deviant and standard parent waveforms at the key electrode sites of interest (Fz, FCz, Cz, CPz)
    ERP = pop_ploterps( ERP, [9 10], [32 34 35 18] , 'Box', [2 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
    save2pdf([Subject_Path 'graphs' filesep SUB{i} '_MMN_Parent_Waves.pdf']);
    close all
    
    %syntax pop_ploterps( ERP,  [BINS_TO_PLOT],  [CHANNELS_TO_PLOT],  ...options... )

    %Plot the MMN deviant-minus-standard difference waveform at the key electrode sites of interest (Fz, FCz, Cz, CPz)
    ERP = pop_ploterps( ERP, [11], [32 34 35 18] , 'Box', [2 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_diff);
    save2pdf([Subject_Path 'graphs' filesep SUB{i} '_MMN_Difference_Wave.pdf']);
    close all

    %Plot the MMN deviant and standard parent waveforms at all electrode sites
    ERP = pop_ploterps( ERP, [9 10], [1:40] , 'Box', [6 7], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
    save2pdf([Subject_Path 'graphs' filesep SUB{i} '_MMN_Parent_Waves_All_Channels.pdf']);
    close all

    %Plot the MMN deviant-minus-standard difference waveform at all electrode sites
    ERP = pop_ploterps( ERP, [11], [1:40] , 'Box', [6 7], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_diff);
    save2pdf([Subject_Path 'graphs' filesep SUB{i} '_MMN_Difference_Wave_All_Channels.pdf']);
    close all
  
    %Plot the parent (deviant and standard conditions) ICA-corrected and uncorrected bipolar HEOG signals 
    % ERP = pop_ploterps( ERP, [1 2], [32 34] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_HEOG);
    % save2pdf([Subject_Path 'graphs' filesep SUB{i} '_MMN_HEOG.pdf']);
    % close all
    
    %Plot the parent (deviant and standard conditions) ICA-corrected monopolar VEOG signals and corrected bipolar VEOG signal
    ERP = pop_ploterps( ERP, [9 10], [37 38 40] , 'Box', [2 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_VEOG);
    save2pdf([Subject_Path 'graphs' filesep SUB{i} '_MMN_VEOG.pdf']);
    close all

%End subject loop
end

%*************************************************************************************************************************************
