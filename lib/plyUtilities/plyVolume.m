function plyVol = plyVolume(filename)
[ply.vertices,ply.faces] = plyRead(filename,1);

%% Unvectorized
% pXYZ = mean(ply.vertices);
% tetVol = zeros(size(ply.faces,1),1);
% for ii = 1:size(ply.faces,1)
%     a = ply.vertices(ply.faces(ii,1),:);
%     b = ply.vertices(ply.faces(ii,2),:);
%     c = ply.vertices(ply.faces(ii,3),:);
%
%     tetVol(ii) = dot((a-pXYZ),cross((b-pXYZ),(c-pXYZ)))/6;
% end
% plyVol = sum(tetVol);

%% Vectorized (Very Fast)
pXYZ = repmat(mean(ply.vertices),size(ply.faces,1),1);
a = ply.vertices(ply.faces(:,1),:);
b = ply.vertices(ply.faces(:,2),:);
c = ply.vertices(ply.faces(:,3),:);

plyVol = dot((a-pXYZ),cross((b-pXYZ),(c-pXYZ)))/6;