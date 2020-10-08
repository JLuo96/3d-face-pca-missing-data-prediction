function plotPlyError(a,b, colorrange)
% function plotPlyError(a,b, colorrange)
%
%     Show a 3D plot of the mesh error between two meshes
% 
%     a,b - ply files in struct format, a.Vertices, a.Faces
%     colorrange - optional set the [black, red] error range, default [0,max]
%
% JED 10/7/20

%% compute the difference between the vertices
d=a.Vertices-b.Vertices;
x=d(:,1);
y=d(:,2);
z=d(:,3);
d=(x.*x+ y.*y +z.*z).^0.5;

%% If colorrange doesnt exists then set to full range
if ~exist('colorrange','var')
    colorrange=[0 max(d)];
end

% Scale the error information
sd=max(0,d-colorrange(1));
sd=sd./(colorrange(2)-colorrange(1));

%% Draw the face
clf
p = patch(a);
set(p,'FaceColor','c','FaceLighting','flat','LineStyle','none');

ax1 = gca;
ax1.Visible = 'off';
ax1.Tag = 'MyAxes';
axis equal;
axis vis3d;
rot = rotate3d;
rot.Enable = 'on';



%% Set the color to the error distance
set(p,'FaceLighting','none')
set(p,'FaceColor','interp')
set(p,'FaceVertexCData',[sd,0*sd,0*sd]) 

%% Add some labels
e=calcPlyError(a,b);
str=sprintf('MAE: %.3f - MSE: %.3f - Min: %.3f - Q1: %.3f - Median: %.3f - Q3: %.3f - Max: %.3f - ColorRange: (%.1f,%.1f)',e(1), e(2), e(3), e(4), e(5), e(6), e(7),colorrange(1),colorrange(2));
annotation('textbox', [0 1 0 0], 'String', str);