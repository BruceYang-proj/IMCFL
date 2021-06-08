function Pur = PurityInfo(L1,L2)
Label = unique(L1);
nClass = length(Label);

Label2 = unique(L2);
nClass2 = length(Label2);

G = zeros(nClass,nClass2);
for i=1:nClass
    for j=1:nClass2
        G(i,j) = sum(L1 == Label(i) & L2 == Label2(j));
    end
end

sum_purity=0;
Gsum=sum(sum(G));
for i=1:size(G,1)
%     [m,~]=max(G);
    [m2,p2]=max(max(G));
    
    G(:,p2)=0;
     sum_purity=sum_purity+m2/Gsum;
%     sum_purity=sum_purity+max(G(:,i))/sum(sum(G));
end
Pur=sum_purity;
%disp(['聚类的总纯度为' num2str(Pur)]);%num2str 将数值转换成字符串
% 
% A=L1;
% label=L2;
% nclass=max(A);
% AL=[A,label];
% i=1;
% allacc=0;
% while i<=nclass
%     al=AL(AL(:,1)==i,:);
%     [cnum,~]=size(al);
%     max_jacc=0;
%     j=1;
%     while j<=nclass
%         [ncol,~]=size(al(al(:,2)==j,:));
%         max_jacc=max(max_jacc,ncol);
%         j=j+1;
%     end
%     allacc=allacc+max_jacc/cnum;
%     i=i+1;
% end
% ACC=allacc/nclass;
% Pur=ACC;
end
