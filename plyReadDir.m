function ply=plyReadDir(pattern)
%function ply=plyReadDir(pattern)
%
%  Load a sequence of ply files matching a pattern
%
%  e.g.
%  ply=plyReadDir('models/ply/*.ply');
%  for i=1:length(ply)
%    singlePly=(ply{i});
%    plyViewer(singlePly);
%  end
%
% JED 10/7/20


% Split the directory name out since need it for imread
[dirName,filename,ext]=fileparts(pattern);

% Get list of matching files
d=dir(pattern);

% Load these images into a cell array
for i=1:size(d,1)
    fname=fullfile(dirName, d(i).name);
    disp(fname);
    [a.Vertices,a.Faces]=plyRead(fname,1);
    ply{i}=a;
    %imshow(im{i})
end