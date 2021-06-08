function NMI = NMIInfo(L1,L2)
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
sumG = sum(G(:));
%求每个class和每个cluster的计算结果
nmi_up=0;
for i=1:nClass
    for j=1:nClass2
        nmi_up=nmi_up+(G(i,j)*log((sumG*G(i,j))/(sum(G(i,:))*sum(G(:,j)))+eps));
    end
end
sum_class=0;
for i=1:nClass2
    sum_class=sum_class+(sum(G(:,i))*log(sum(G(:,i))/(sumG+eps)));
end
sum_cluster=0;
for j=1:nClass
    sum_cluster=sum_cluster+(sum(G(j,:))*log(sum(G(j,:))/(sumG+eps)));
end
nmi_down=sqrt(sum_class*sum_cluster);
NMI=nmi_up/nmi_down;
%disp(['NMI为' num2str(NMI)]);
end