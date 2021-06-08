function e=Evaluation(V,A,op)
    V=V';
    V=NormalizeFea(V);
    nClass=max(A);
    if ~exist('op','var')||isempty(op)
        evalway='kmeans';
    else
        evalway=op.evalway;
    end
    switch evalway
        case 'kmeans'
            label = litekmeans(V,nClass,'Replicates',10);
        case 'svm'
            if ~isfield(op,'svmmode')
                error('no svmmode in op');
            end
            label =libsvmpredict(A,V, op.svmmode);
        case 'kmedoids'
            label=kmedoids(V,nClass,'Replicates',10);
    end
    
    
    MIhat=NMIInfo(A,label);
    ACC=AccInfo(A,label);
    PUR=PurityInfo(A,label);
%     disp(['V Clustering in the subspace. MIhat: ',num2str(MIhat)]);
%     disp(['V Clustering in the subspace. PUR: ',num2str(PUR)]);
%     disp(['V Clustering in the subspace. ACC: ',num2str(ACC)]);
    e=[MIhat;PUR;ACC];
end