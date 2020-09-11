% plySlicer
clear
close all
plotSlices = false;  %% Set to false if using parfor
disp('Importing ply file...')

[ply.Vertices, ply.Faces] = plyRead('myPLY.ply',1);
xyz = ply.Vertices;
TRI = ply.Faces;

slicePoints = linspace(min(xyz(:,1)),max(xyz(:,2)),1000);
slicePlane = [1 0 0];
disp('Slicing!')
tic
parfor s = 1:length(slicePoints)
    slicePoint = [slicePoints(s) 0 0];
    
    vert_planeSide = dot(xyz-repmat(slicePoint,size(xyz,1),1),repmat(slicePlane,size(xyz,1),1),2);
    vAbove = vert_planeSide>0;
    vBelow = vert_planeSide<=0;
    
    
    %     FaceSides = [vAbove(TRI(:,1)) vAbove(TRI(:,2)) vAbove(TRI(:,3))];
    FaceSides = vAbove(TRI);
    %     FaceSides = cast(FaceSides,'uint64');
    
    FaceIntersected = sum(FaceSides,2) == 1 | sum(FaceSides,2) == 2;
    if any(FaceIntersected)
        modeSide = mode(FaceSides(FaceIntersected,:),2);
        findCommonVert = ~(FaceSides(FaceIntersected,:) == repmat(modeSide,1,3));
        [row,col] = find(findCommonVert);
        [sortedRow,idx] = sort(row);
        commonVert = col(idx);
        
        ComputeFaces = find(FaceIntersected);
        ComputeVerts = TRI(ComputeFaces,:);
        ComputeEdges = zeros(size(ComputeFaces,1)*2,2);
        kk = 0;
        for ii = 1:size(ComputeFaces,1)
            uniqueVerts = find([1 2 3]~=commonVert(ii));
            for jj = 1:2
                kk = kk+1;
                ComputeEdges(kk,1) = ComputeVerts(ii,commonVert(ii));
                ComputeEdges(kk,2) = ComputeVerts(ii,uniqueVerts(jj));
            end
        end
        
        tempSlicePlane = repmat(slicePlane,size(ComputeEdges,1),1);
        tempSlicePoint = repmat(slicePoint,size(ComputeEdges,1),1);
        
        rI = dot(tempSlicePlane,(tempSlicePoint-xyz(ComputeEdges(:,1),:)),2)./dot(tempSlicePlane,(xyz(ComputeEdges(:,2),:)-xyz(ComputeEdges(:,1),:)),2);
        xyzInter = xyz(ComputeEdges(:,1),:) + [rI rI rI].*(xyz(ComputeEdges(:,2),:)-xyz(ComputeEdges(:,1),:));
        
        if plotSlices == true
            if s == 1
                hf = figure();
                sPlot = scatter3(xyzInter(:,1),xyzInter(:,2),xyzInter(:,3),'.');
                ax = gca;
                ax.XLim = [min(xyz(:,1)) max(xyz(:,1))];
                ax.YLim = [min(xyz(:,2)) max(xyz(:,2))];
                ax.ZLim = [min(xyz(:,3)) max(xyz(:,3))];
                axis vis3d
            else
                sPlot.XData = xyzInter(:,1);
                sPlot.YData = xyzInter(:,2);
                sPlot.ZData = xyzInter(:,3);
            end
            drawnow
        end
    end
end
toc
%%
% uniqueComputeVerts = ComputeVerts(sortedRow,commonVert);
%
% computedEdgeIntersection = false(length(ComputeFaces),2);
%
% % ComputeEdges =
% % for ii = 1:numel(computed
% length(find(FaceIntersected))