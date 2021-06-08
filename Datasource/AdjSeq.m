function [X,A]=AdjSeq(X,A,op)
% This function is used to adjust the seqence of instances in the indicated
% way
% updated by Bruce Yang Nov.26,2019     --init
    switch op
        case 'random'
            [X,A]=AdjSeqRand(X,A);
    end
end

function [X,A]=AdjSeqRand(X,A)
% Here we have some appointments about the construction of A.The class
% number of instances in A must be numbered from 1 and obey the form as
% 1,2,3....,n. Each class have same quantity of instances. The sequence
% after adjusting is as 1,2,3...n,1,2,3,...n.......1,2,3...,n and is
% returned as a column vector
    rand('state',sum(100*clock));
    nSmp=size(A,1);
    nClass=max(A);
    nmode=length(X); 
    RSeq=randperm(nSmp);
    for i=1:nmode
        X(i).data=X(i).data(:,RSeq);
    end
    A=A(RSeq);
%     make instances of same class group together
    [~,SdrSeq]=sort(A);
    for i=1:nmode
        X(i).data=X(i).data(:,SdrSeq);
    end
    A=A(SdrSeq);
    
%     find the Sequence
    ESeq=zeros(nSmp,1);
    Cqty=nSmp/nClass;
    for i=1:Cqty
        ESeq((i-1)*nClass+1:i*nClass,:)=i:Cqty:nSmp;
    end
    
%     adjust sequence of instances
    for i=1:nmode
        X(i).data=X(i).data(:,ESeq);
    end
    A=A(ESeq);
    [X,A]=RandBlock(X,A);
end

function [X,A]=RandBlock(X,A)
    
end