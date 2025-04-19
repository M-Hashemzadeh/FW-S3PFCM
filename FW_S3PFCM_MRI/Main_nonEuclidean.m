clear, close all,clc

path = 'E:\festival_con\Jornal Paper\Taymaz Farshi\DataSet\original';
exResPath = 'matlab\Results';

imagefiles = dir([path,'\*.tif']);
nfiles = length(imagefiles);    % Number of files found
for ii = 1 : nfiles
    currentfilename = imagefiles(ii).name;
    currentfoldername = imagefiles(ii).folder;
    I = imread([currentfoldername,'\',currentfilename]);
    currentfilename=currentfilename(1:end-4);
    
    fid = fopen(['Results\',currentfilename ,'\Data.txt'],'r');
    Data = [];
    frewind(fid);
    for i = 1:3
        k = fgetl(fid);
        Num = str2double(regexp(k,'\d*','match'));
        Data = [Data;Num];
    end
    fclose(fid);
    [label,rgb,Eticets] = Coloring(I,Data');
    mkdir('Results_nonEuclidean',currentfilename);
    
    imwrite(rgb,['Results_nonEuclidean\',currentfilename ,'\Segmented.bmp'])
    imwrite(label2rgb(label),['Results_nonEuclidean\',currentfilename ,'\Label.bmp'])
    
    save(['Results_nonEuclidean\',currentfilename,'\Lable'],'label')
    save(['Results_nonEuclidean\',currentfilename],'label')
    
    [ F,F2,Q ] = Performance_Eval(numel(Eticets),rgb,label,Data );
    
    mkdir('Results_nonEuclidean\NumOfSeg');
    fileID1 = fopen(['Results_nonEuclidean\NumOfSeg\',currentfilename ,'.txt'],'w');
    fprintf(fileID1,'%d ',numel(Eticets));
    fclose(fileID1);
    
    fileID = fopen(['Results_nonEuclidean\',currentfilename ,'\Data.txt'],'w');
    result = round(Data);
    [a,b,c] =size(result);
    for i =1:a
        for j = 1:b
            fprintf(fileID,'%d ',result(i,j));
        end
        fprintf(fileID,'\n');
    end
    fprintf(fileID,'\n \n');
    fprintf(fileID,'\n \n Number of segment = %d',numel(Eticets));
    fprintf(fileID,'\n \nF = %s ',num2str(F));
    fprintf(fileID,'\n \nF = %s',num2str(F2));
    fprintf(fileID,'\n \nF = %s',num2str(Q));
    fclose(fileID);
    
    disp('Finish.');
    close all
end

