%% load two ply files
[a.Vertices,a.Faces]=plyRead('1.ply',1);
[b.Vertices,b.Faces]=plyRead('2.ply',1);

%% compute the difference between the vertices
d=a.Vertices-b.Vertices;
x=d(:,1);
y=d(:,2);
z=d(:,3);
d=(x.*x+ y.*y +z.*z).^0.5;

%% Draw the face
p=plyViewer(a);
p=plyViewer(b);

%% Set the color to the error distance
set(p,'FaceLighting','none')
set(p,'FaceColor','interp')
set(p,'FaceVertexCData',[d/15+0,d*0, d*0]) % 15mm set as red
