%% Convert obj files to ply files (only do this once, it takes a long time)
% convertFaceScapeToPly('/FaceScapeData')

%% Load the obj files to memory ( a few seconds )
ply=plyReadDir('/FaceScapeData/ply/*.ply')

%% See a ply file on the screen
plyViewer(ply{1})

%% See the error between the first two ply files
plotPlyError(ply{1},ply{2})