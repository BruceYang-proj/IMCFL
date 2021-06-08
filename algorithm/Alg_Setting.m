function [AlgOP]=Alg_Setting(X,A,Dname)
    AlgOP=[];
    dim=zeros(1,length(X));
    for i=1:length(X)
        dim(i)=size(X(i).data,1);
    end
    AlgOP.mc=min(max(A),min(dim));
    AlgOP.nSmp=size(X(1).data,2);
    switch Dname
        case 'MF'
%  -----------IMCFL------------------------          
            IMCFL.alpha=100;
%             IMCFL.mi=fix(AlgOP.mc);
            IMCFL.mi=2;
            IMCFL.beta=0.1;

            IMCFL.MaxItr=10;
            Graph.WeightMode='HeatKernel';
            Graph.k=5;
%             Graph.WeightMode='Cosine';
%             Graph.k=4;
            IMCFL.Graph=Graph;
            AlgOP.IMCFL=IMCFL;
%  ----------------------------------------

    end
