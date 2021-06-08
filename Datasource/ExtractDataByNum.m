function [X,A,name]=ExtractDataByNum(DataSetNum,option)
% Extract data from indicated dataset,and preprocess the data in the way
% indicated by option.Return include the data matrix,each column represent 
% an instance, and the label correspondingly.
% notice that a language represents a view in reuters 
   addpath(genpath(pwd));
   if (~exist('option','var'))
        option=[];
   end
   switch DataSetNum  
       case 1
           [X,A]=Extract_MF_data(option);
           [X,A]=AdjSeq(X,A,'random');
           name='MF';  
   end
end