function [errorVec, vdist] = calcPlyError(a,b, printFlag)
% function [errorVec, vdist] = calcPlyError(a,b, printFlag)
%
%   Error between two ply files, specified as any of:
%      a.Vertices, 3 column xyz matrix, or 1 column matrix
%
%   printFlag - causes the errors to be printed to the console
%
%   errorVec=[mean_absolute_err, MSE, Min, Quartile1, Median, Quartile3, Max]
%
%   vdist - vector of vertexwise euclidean distance
%
%  JED 10/7/20

% If print exists then set flag
if ~exist('printFlag','var')
    printFlag=false;
else
    printFlag=true;
end

% If input is a struct convert to 3 column data format
if isstruct(a)
    a=a.Vertices;
end
if isstruct(b)
    b=b.Vertices;
end

% If input is in column vector, then convert to 3 column xyz data
if size(a,2)==1
    a=reshape(a,[],3);
end
if size(b,2)==1
    b=reshape(b,[],3);
end

% MSE in euclidean space
d=(a-b);
d=d.^2;
d=sum(d,2);
error_MSE=mean(d);
d=d.^(1/2); % Euclidean distance for each point pair
error_MAE=mean(d);

% Min error
error_min=min(d);

% Median error
error_median=quantile(d,[.25 .50 .75]);

% Max error
error_max=max(d);

% The complete error vector
errorVec = [ error_MAE, error_MSE, error_min, error_median, error_max];

% Print the output if requested
if printFlag
    str=sprintf('MAE: %.3f - MSE: %.3f - Min: %.3f - Q1: %.3f - Median: %.3f - Q3: %.3f - Max: %.3f',error_MAE, error_MSE, error_min, error_median(1), error_median(2), error_median(3), error_max);
    disp(str);
end

