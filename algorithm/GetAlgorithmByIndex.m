function [Al,type,Algname]=GetAlgorithmByIndex(i)
    switch i
        case 1
            Al=@IMCFL;
            type=1;
    end
    Algname=func2str(Al);
   
end