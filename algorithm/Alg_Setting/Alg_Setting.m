function [AlgOP]=Alg_Setting(Dname)

%-----------Graph Parameter init----------------------    
    Graph=[];
    Graph.WeightMode='Cosine';
    Graph.k=1;
    AlgOP.Graph=Graph;
 
% ----------------------------------------------------

%------------Incremental Algorithm--------------------  
%   Setting of IMCFL
    IMCFL.sigema=0.01;
    IMCFL.alpha=15;
    IMCFL.mi=fix(AlgOP.mc/3);
    IMCFL.beta=0.1;
    AlgOP.IMCFL=IMCFL;

end