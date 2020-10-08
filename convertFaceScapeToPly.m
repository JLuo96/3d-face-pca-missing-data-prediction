function convertFaceScapeToPly(topDirectory)
%function convertFaceScapeToPly(topDirectory)
%
%  Go through the FaceScape directory and load obj and resave in a 
%  single directory of ply files.
%
%  Save the files in topDirectory/ply/facescape_<num>_<expressionnum>.ply
%
%  topDirectory defaults to '.'
%
%  currently only deals with the first 100 and neutral expression
%
% JED 10/7/20

if ~exist('topDirectory','var')
    topDirectory='.';
end

% Make sure topDirectory is valid
d=dir([topDirectory,'/facescape_trainset_001_100']);
if (size(d,1)==0)
    disp('Invalid FaceScape topDirectory does not contain expected directories');
    return;
end

% Create a directory to write files into
if ~exist([topDirectory,'/ply'])
    mkdir(topDirectory, 'ply'); 
end

%Load each obj and resave as a ply
for i=1:100
    loadname=[topDirectory,'/facescape_trainset_001_100','/',num2str(i),'/models_reg/1_neutral.obj'];
    disp(loadname);
    savename=[topDirectory,'/ply/facescape_',num2str(i,'%03d'),'_01.ply'];
    disp(savename);
    
    face=readObj(loadname);
    plyWrite(face.v, face.f.v, savename);
end