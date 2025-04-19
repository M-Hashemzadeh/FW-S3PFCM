clear;
close all;
clc;

path = 'Tested Data';
imagefiles = dir([path,'\original','\*.tif']);
imageMasks = dir([path,'\GT','\*.tif']);
nfiles = length(imagefiles);    % Number of files found

m = {};
Header = {'Name', 'Accuracy', 'F1', 'Runtime', 'Sensitivity', 'Precision'};

for ii = 1 : nfiles
    currentfilename = imagefiles(ii).name;
    currentmaskname = imageMasks(ii).name;
    currentfoldername = imagefiles(ii).folder;
    [accurcy,fm,nmi, Runtime, Sensitivity, Precision] = main_FW_S3PFCM(currentfilename,currentmaskname, path);
    [a,b] = max(fm);
    m{ii, 1} = currentfilename;
    m{ii, 2} = accurcy(b);
    m{ii, 3} = fm(b);
    m{ii, 4} = Runtime;
    m{ii, 5} = Sensitivity(b);
    m{ii, 6} = Precision(b);
end

array2table(m, 'VariableNames', {'Name', 'Accuracy', 'F1', 'Runtime', 'Sensitivity', 'Precision'})
writetable(array2table(m, 'VariableNames', {'Name', 'Accuracy', 'F1', 'Runtime', 'Sensitivity', 'Precision'}), 'Results/Results.txt')