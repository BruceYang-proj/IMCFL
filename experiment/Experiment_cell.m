function [Evldata]=Experiment_cell(Alg_i,DataSet_i,Runtimes,NewIstPct)
   [Alg,type,Algname]=GetAlgorithmByIndex(Alg_i);
  
   if Alg_i==6
        op="SumToOne";
        [X,A,DSname]=ExtractDataByNum(DataSet_i,op);
   else
        [X,A,DSname]=ExtractDataByNum(DataSet_i);
   end
   Algop=Alg_Setting(X,A,DSname);
   disp([DSname,' alg ',Algname,' start'])
   
   l=fix(length(A)*NewIstPct/100);
   if strcmp(DSname,'3sources')
%         l=13;
        Algop.sizeofbuff=39;
   end
   if strcmp(DSname,'aloi60')
%         l=500;
        Algop.sizeofbuff=1000;
   end
   
   EDS=(0);
   for i=1:Runtimes
        if type==1
            Edata=ICMT(Alg,X,A,l,Algop);
        end
        if type==0
            Edata=NICMT(Alg,X,A,l,Algop);
        end
        if type==2
            Edata=OMFL(Alg,X,A,l,Algop);
        end
        if type==3
            Edata=SVNMF(Alg,X,A,l,Algop);
        end
        if type==4
            Edata=MITSI(Alg,X,A,l,Algop);
        end
        if type==5
            Edata=ICMT2(Alg,X,A,l,Algop);
        end
        EDS=EDS+Edata;
   end
   Evldata=EDS/Runtimes;
   disp([DSname,' alg ',Algname,' end'])
end
% incremental
function Evaldata=ICMT(f,X,A,l,option)
    nSmp=option.nSmp;
    times=fix(nSmp/l);
    Evaldata=zeros(5,times);
    Buffer=[];
    for i=1:times
        x=ExtractIstByColNum(X,(i-1)*l+1,i*l);
        
        T_begin=clock;
        [Buffer,V]=f(x,Buffer,option);
        T_end=clock;
        t=-etime(T_begin,T_end);
   
        e=Evaluation(V,A(1:i*l,:));
        Evaldata(:,i)=[i*l;t;e];
    end
end
% non incremental
function Evaldata=NICMT(f,X,A,l,option)
    nSmp=option.nSmp;
    Evaldata=zeros(5,fix(nSmp/l));
   
    for i=1:fix(nSmp/l)
        n=i*l;
%         n=1*l;
        X_Set=CutN(X,A,n);
   
        T_begin=clock;
        [V]=f(X_Set,option);
        T_end=clock;
        t=-etime(T_begin,T_end);
        
        e=Evaluation(V,A(1:n,:));
        Evaldata(:,i)=[n;t;e];
%         break
    end
end
function Evaldata=OMFL(f,X,A,l,option)
    nSmp=option.nSmp;
    Evaldata=zeros(5,fix(nSmp/l));
    Buffer=[];
    for i=1:fix(nSmp/l)
        x=ExtractIstByColNum(X,(i-1)*l+1,i*l);
      
        T_begin=clock;
        [Buffer,V]=f(x,Buffer,option);
        T_end=clock;
        t=-etime(T_begin,T_end);
%         e=Evaluation(Buffer.U',A(end-size(Buffer.U',2)+1:end,:));
        e=Evaluation(V,A(1:i*l,:));
        Evaldata(:,i)=[i*l;t;e];
    end
end
function Evaldata=SVNMF(f,X,A,l,option)
    nSmp=option.nSmp;
    nmode=option.nmode;
    Evaldata=zeros(5,fix(nSmp/l));
   
    for i=1:fix(nSmp/l)
        n=i*l;
        X_Set=CutN(X,A,n);
        ebest=zeros(3,1);
        tave=0;
        for m_i=1:nmode
            T_begin=clock;
            [V]=f(X_Set(m_i).data,option);
            T_end=clock;
            t=-etime(T_begin,T_end);
            e=Evaluation(V,A(1:n,:));
%             we select the max value for each criterion
            ebest=max(ebest,e);
            tave=tave+t/nmode;
        end
        Evaldata(:,i)=[n;tave;ebest];
    end
end
function Evaldata=MITSI(f,X,A,l,option)
    nSmp=option.nSmp;
    nmode=option.nmode;
    Evaldata=zeros(5,fix(nSmp/l));
%     Evaldata(2,:)=9999;
    for m_i=1:nmode
        XX(1).data=X(m_i).data;
        e=ICMT(f,XX,A,l,option);
%             we select the max value for each criterion
        Evaldata(1,:)=e(1,:);
        Evaldata(2,:)=Evaldata(2,:)+e(2,:)/nmode;
        Evaldata(3:end,:)=max(Evaldata(3:end,:),e(3:end,:));    
    end
end
function Evaldata=ICMT2(f,X,A,l,option)
    nSmp=option.nSmp;
    Evaldata=zeros(5,fix(nSmp/l));
    Var_Set=[];
    V=[];
    for i=1:fix(nSmp/l)
        x=ExtractIstByColNum(X,(i-1)*l+1,i*l);
        
        T_begin=clock;
        [v,Var_Set]=f(x,Var_Set,option);
        T_end=clock;
        t=-etime(T_begin,T_end);
        if i*l<=option.sizeofbuff
            V=Var_Set.V;
        else
            V2=Var_Set.V;
            V=[V(:,1:i*l-option.sizeofbuff),V2];
        end
        
%         V=[V,v];
        e=Evaluation(V,A(1:i*l,:));
        Evaldata(:,i)=[i*l;t;e];
    end
end
