function [X,A]=Extract_MF_data(option)
    load('Muti_Feature.mat');
    
    X(1).data=MF_216';
    X(2).data=MF_240';
    X(3).data=MF_47';
    X(4).data=MF_64';
    X(5).data=MF_76';
  
%   create label
    nClass=10;   
    nSmp=size(X(1).data,2);
    
    A=1:1:nClass;
    A=repmat(A',[1,nSmp/nClass]);
    A=reshape(A',[nSmp,1]);
   
    if (~exist('option','var'))
%          option='Maxmin';
        option='Maxmin';
    end
    option='Maxmin';
    for i=1:length(X)
        X(i).data=Preprocess(X(i).data',option)';
    end
end