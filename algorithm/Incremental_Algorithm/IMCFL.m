function [Buffer,V]=IMCFL(x_pur,Buffer,option)
% This is the incremental algorithm called IMCFL
% updated by Bruce Yang April.23,2020     --init 
% updated by Bruce Yang July.30,2020     --cell 
    nmode=length(x_pur);
    mc=option.mc;
    op=option.IMCFL; 
    alpha=op.alpha;
    beta=op.beta;
    mi=op.mi;
    rand('state',2);

%-----------Parameter init-------------------------  
%     option.Premode="Norm"; 
    x=cell(1,nmode);
    for i=1:nmode
        x{i}=x_pur(i).data;
    end

    if isempty(Buffer)
        Uc=cell(1,nmode);
        UI=cell(1,nmode);
        VI=cell(1,nmode);
        vi=cell(1,nmode);
        W=cell(1,nmode);
        D=cell(1,nmode);
        X=x;

        for i=1:nmode
            [mFea,nSmp]=size(x{i});
            U=Preprocess(rand(mFea,mc+mi));
            Uc{i}=U(:,1:mc);
            UI{i}=U(:,mc+1:mc+mi);
            vi{i}=Preprocess(rand(mi,nSmp)')';
            VI{i}=[];
            W{i}=ConStrtW(x{i},x{i},op.Graph);
            Dcol=sum(W{i},2);
            D{i}=spdiags(Dcol,0,nSmp,nSmp);
        end
        v=Preprocess(rand(mc,nSmp)')';
        V=[];

    else
        Uc=Buffer.Uc;
        UI=Buffer.UI;
        VI=Buffer.VI;
        X=Buffer.X;
        V=Buffer.V;

        vi=cell(1,nmode);
        W=cell(1,nmode);
        D=cell(1,nmode);
  
        [~,nSmp]=size(x{1});
        for i=1:nmode
            [~,nSmp]=size(x{i});
            X{i}=[X{i},x{i}];
            vi{i}=Preprocess(rand(mi,nSmp)')';
            W{i}=ConStrtW(x{i},X{i},op.Graph); 
            W{i}=W{i};
            Dcol=sum(W{i},1)';
            Dtmp=spdiags(Dcol,0,nSmp,nSmp);
            D{i}=[zeros(size(X{i},2)-nSmp,nSmp);Dtmp];
        end
        v=Preprocess(rand(mc,nSmp)')';
        
    end
    %     X contains all the X

   
%----------------------------------------------------

%------------iterative update------------------------

    for it=1:op.MaxItr
% ----------updateU-----------------
        AV=[V,v];
        for i=1:nmode
            UcM=0.5*beta*getM(Uc{i})*Uc{i};
            UIM=0.5*beta*getM(UI{i})*UI{i};
            AVI=[VI{i},vi{i}]; 
            Uc{i}=Uc{i}.*((X{i}*AV')./max(Uc{i}*(AV*AV')+UI{i}*AVI*AV'+UcM,1e-10));
            UI{i}=UI{i}.*((X{i}*AVI')./max(UI{i}*(AVI*AVI')+Uc{i}*AV*AVI'+UIM,1e-10));  

        end
% ----------updatev-----------------
        udv_up=(0);
        udv_down=(0);
        for i=1:nmode
            udv_up=udv_up+Uc{i}'*x{i}+alpha*AV*W{i};
            udv_down=udv_down+Uc{i}'*Uc{i}*v+Uc{i}'*UI{i}*vi{i}+alpha*AV*D{i};
            vi{i}=vi{i}.*((UI{i}'*x{i})./max(UI{i}'*UI{i}*vi{i}+UI{i}'*Uc{i}*v,1e-10));
        end
        v=v.*(udv_up./max(udv_down,1e-10));
    end
%----------------------------------------------------

%------------Parameter Integration-------------------
    V=[V,v];
  
    Buffer.Uc=Uc;
    Buffer.UI=UI;
    Buffer.X=X;
    Buffer.V=V;
    for i=1:nmode
       VI{i}=[VI{i},vi{i}];
    end
    Buffer.VI=VI;
   
%----------------------------------------------------
end


function [M]=getM(U)
%     M=diag(1./diag((U*U').^0.5));
    M=diag(1./sum(U.^2,2).^0.5);
end

function [W] = ConStrtW(x,X,option)

%----------Parameter set------------------------
    if ~exist('option','var')
        option =[];
    end
    if ~isfield(option,'WeightMode')
        option.WeightMode = 'HeatKernel';
    end
    if ~isfield(option,'k')
        option.k =5;
    end
    x=x';
    X=X';
    [nrow_x,~]=size(x);
    [nrow_X,~]=size(X);
    ln=nrow_X-nrow_x;

    switch option.WeightMode
        case 'HeatKernel'
             W_d=EuDist(x,X);
    end

    k=option.k;
    [dump,idx] = sort(W_d,2);
    idx = idx(:,2:k+1);
    dump = dump(:,2:k+1);   
    
    switch option.WeightMode
        case 'HeatKernel'
            t = mean(mean(W_d));
            dump = exp(-dump/(2*t^2));
    end   
    
    clear W_d; 
    
    Wx=ln+1:1:nrow_X;
    G(:,1) = repmat(Wx',k,1);
    G(:,2) = reshape(idx,[],1);
    G(:,3) = reshape(dump,[],1);
    
    G = sparse(G(:,1),G(:,2),G(:,3),nrow_X,nrow_X);
    G = max(G,G');
    W=G(:,ln+1:nrow_X);
end


function D = EuDist(fea_a,fea_b)
%EUDIST Efficiently Compute the Euclidean Distance Matrix by Exploring the
%Matlab matrix operations.
%Refered to Deng Cai
%   D = EuDist(fea_a,fea_b)
%   fea_a:    nSample_a * nFeature
%   fea_b:    nSample_b * nFeature
%   D:      nSample_a * nSample_a
%       or  nSample_a * nSample_b
%
%    Examples:
%
%       a = rand(500,10);
%       b = rand(1000,10);
%
%       A = EuDist2(a); % A: 500*500
%       D = EuDist2(a,b); % D: 500*1000

    if (~exist('fea_b','var')) || isempty(fea_b)
        aa = sum(fea_a.*fea_a,2);
        ab = fea_a*fea_a';
        
        if issparse(aa)
            aa = full(aa);
        end

        D = bsxfun(@plus,aa,aa') - 2*ab;
        D(D<0) = 0;
        D = sqrt(D);
        D = max(D,D');
    else
        aa = sum(fea_a.*fea_a,2);
        bb = sum(fea_b.*fea_b,2);
        ab = fea_a*fea_b';

        if issparse(aa)
            aa = full(aa);
            bb = full(bb);
        end

        D = bsxfun(@plus,aa,bb') - 2*ab;
        D(D<0) = 0; 
        D = sqrt(D);
    end
end


