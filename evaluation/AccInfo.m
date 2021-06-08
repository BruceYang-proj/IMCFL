function ACC = AccInfo(L1,L2)
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

sum_acc=0;
for i=1:size(G,2)
    sum_acc=sum_acc+max(G(:,i))/sum(sum(G));
end
ACC=sum_acc;
% %disp(['聚类的总纯度为' num2str(Pur)]);%num2str 将数值转换成字符串


%     num=size(A);
% 
% A=L1;
% label=L2;
% nclass=max(A);
% AL=[A,label];
% i=1;
% allacc=0;
% while i<=nclass
%     al=AL(AL(:,2)==i,:);
%     [cnum,~]=size(al);
%     max_jacc=0;
%     j=1;
%     while j<=nclass
%         [ncol,~]=size(al(al(:,1)==j,:));
%         max_jacc=max(max_jacc,ncol);
%         j=j+1;
%     end
%     allacc=allacc+max_jacc/cnum;
%     i=i+1;
% end
% ACC=allacc/nclass;
% Pur=ACC;
end