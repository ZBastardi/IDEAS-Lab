%% Main FWHM Processing Script
clear; clc; close all;

% Create an 'output_plots' directory if it doesn't already exist
output_folder = 'output_plots';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Set your pixel-to-µm conversion ratio obtained in lab (40x oil immersion lens)
% Example: ratio = (µm per pixel)
pixel_to_um = 0.094429038; % Update with your exact experimental conversion factor

% SCRAPPED: Total number of files generated in ImageJ (e.g., File1.csv, File2.csv, ..., File30.csv)
% total_files = 30;

% Arrays to store resulting FWHM values
fwhm_pixels_all = zeros(10, 3);
fwhm_um_all = zeros(10, 3);

% Set visibility to 'off' so 30 figure windows don't pop up
set(0, 'DefaultFigureVisible', 'off');

% Outer loop for each Bead (S3 to S10)[cite: 5]
for bead = 1:10
    % Inner loop for each Line Profile (v1 to v3)[cite: 5]
    for view = 1:3
        % Matches S1v1.csv, S10v3.csv, etc.[cite: 26]
        filename = sprintf('S%dv%d.csv', bead, view); 
        
        % Calculate FWHM using your function[cite: 7, 10]
        [~, fwhm_um_all(bead, view)] = calculate_fwhm_group8(filename, pixel_to_um);
        
        % Construct plot output filename (e.g., Plot_S1v1.png)[cite: 26]
        save_name = sprintf('Plot_S%dv%d.png', bead, view);
        full_output_path = fullfile(output_folder, save_name);
        
        % Save current figure directly into the output folder
        saveas(gcf, full_output_path);
        
        % Close figure to clear memory
        close(gcf);
    end
end

% Restore default figure visibility
set(0, 'DefaultFigureVisible', 'on');

% Display table of FWHM
disp(fwhm_um_all);

% Flatten the 8x3 matrix into a single 30x1 column vector for global stats[cite: 5, 10]
all_fwhm_values = fwhm_um_all(:);

% Filter to exclude FWHM values from all S1 and S2 files
filtered_fwhm_values = all_fwhm_values([3:10,13:20,23:30]);
mean_fwhm = mean(filtered_fwhm_values);
std_fwhm = std(filtered_fwhm_values);

% Print final results
fprintf('Successfully saved all 30 plots to the "%s" folder!\n', output_folder);
fprintf('=== Final Results ===\n');
fprintf('Mean Experimental FWHM (filtered): %.4f µm ± %.4f µm\n', mean_fwhm, std_fwhm);