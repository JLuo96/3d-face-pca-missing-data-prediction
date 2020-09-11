% read the shapes of 20 ply files in folder 'exports'
folder = 'exports';
filePattern = fullfile(folder, '*.ply');
theFiles = dir(filePattern);
for k = 1 : length(theFiles)
    path = fullfile(theFiles(k).folder, theFiles(k).name);
    % a= plyshape(path);
    [a, f] = plyRead(path, 0);
    n = size(a);
    a = reshape(a, [n(1)*n(2), 1]);
    if k==1
        faces = a;
    else
        faces = horzcat(faces, a);
    end
end
size(faces);

% calculate the mean face, and substract it
M = mean(faces, 2);
faces = faces - repmat(M,1,20);

% calcuate the svd, and v are all the eigenvectors we need
[u, s, v] = svd(faces', 'econ');
scores = faces' * v;   % calculate the weights for one of 20 faces

new=v*scores';         % calculate the reconstruction of 20 faces
[faces(:,1),new(:,1)]; % notice the values are the same

v = v(:, 1:15);            % only use first 15 component of pca

% read another face
[a, f] = plyRead('exports1/25.ply', 0);
n = size(a);
% reshape
a1 = reshape(a, [n(1)*n(2), 1]);
a1 = a1 - M; 

% % map new faces and calculate the error
w = v'* a1; % Solve for weight
recon = v * w;
[recon, a1];

err_m = mae(a1+M, M)     % mae between a1 and mean face

err = mae(recon, a1)     % mae between reconstruction and ground true


% remove some points
vm = v;
for k = 1 : 47439
    % if a(k, 1) > 0 & a(k, 2) < 0
    % if a(k, 2) < 0
    % if a(k, 2) > 15 & a(k, 2) < 55 & a(k, 1) < 60 & a(k, 1) > -60  % eye missing
    % if a(k, 1) < 20 & a(k, 1) > -20 & a(k, 2) < 30 & a(k, 2) > -20   % nose missing
    if a (k, 1) < 35 & a(k, 1) > -35 & a(k, 2) < -20 & a(k, 2) > -40  % mouth missing
        a(k, 1) = 0;
        a(k, 2) = 0;
        a(k, 3) = 0;
        vm(k, :) = 0;
        vm(k+47439, :) = 0;
        vm(k+47439*2, :) = 0;
    end
end

% % remove certain number of random points
% for k = 1 : 10000
%     r = randperm(47439, 1);
%     missed(r, :) = 0;
%     missed_v(r, :) = 0;
% end

% am = a3;
% vm = v;
% for k = 1 : 35579
%     r = randperm(47439, 1);
%     r = k;
%     am(r) = 0;
%     am(r+47439) = 0;
%     am(r+47439*2) = 0;
%     vm(r, :) = 0;
%     vm(r+47439, :) = 0;
%     vm(r+47439*2, :) = 0;
% end

% reshape
a3 = reshape(a, [n(1)*n(2), 1]);
a3 = a3 - M;                     

% w1 = missed_v' * missed;
w1 = vm' * a3;
% w1 = v(1:exist_num,:)' * a3(1:exist_num,:);           % get weights
recon1 = v * w1;
[recon1, faces(:, 1)];
err1 = mae(recon1, a1)


out = reshape(recon1+M, [n(1), n(2)]); % add reconstruction with mean
% a = reshape(M, [n(1), n(2)]); % add reconstruction with mean

plyWrite(out,f,'output.ply');
plyWrite(a,f,'input.ply');

% cloud_out = pointCloud(out, 'Color', c);   
% pcwrite(cloud_out, 'output.ply');  % pcwrite(): write vertice, color into ply file. but not triangle
% 
% cloud_in = pointCloud(a, 'Color', c);   
% pcwrite(cloud_in, 'input.ply');  % pcwrite(): write vertice, color into ply file. but not triangle
