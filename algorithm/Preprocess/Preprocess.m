function [X]=Preprocess(X,op)
% this function is used to preprocess the matrix X by col in indicated ways,include
% 
% Maxmin:   value is computed as its relative position in the column
% 
% X:nSmp*mFea
   
    if ~exist('op','var')||isempty(op)
        op='IMCFL';
    end
    
    [nrow,~]=size(X);
    if strcmp(op,'IMCFL')
        Xmax=repmat(max(X),nrow,1);
        X=X./max(Xmax,1e-10);
    end
    
    if strcmp(op,'Maxmin')
        Xmax=repmat(max(X),nrow,1);
        Xmin=repmat(min(X),nrow,1);
        X=(X-Xmin)./max((Xmax-Xmin),1e-10);
    end
end