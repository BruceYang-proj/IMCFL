function [X,A]=CutN(X,A,N)
% Cut N samples from the DataSet
    nmode=length(X);
    for i=1:nmode
        X(i).data= X(i).data(:,1:N);
    end
    A=A(1:N,:);
end