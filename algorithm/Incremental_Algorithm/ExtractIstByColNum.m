function [x]=ExtractIstByColNum(X,n1,n2)
%   this function is used to extract part of data.
    for i=1:length(X)
        x(i).data=X(i).data(:,n1:n2);
    end
end