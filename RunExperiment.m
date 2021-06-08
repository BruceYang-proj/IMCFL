% This script is used to run the Experiment with the setting as follow

clc;
clear;
addpath(genpath(pwd));
ExperimentNumber='0001';
setting=load('setting.mat');
op=setting.op;

Alg=[1];
% 1 IMCFL
% 2 MultiIGNMF

DataSet=[1];
% 1 MF


Runtimes=20;
NewIstPct=10;
alglen=length(Alg);
DSlen=length(DataSet);
EvalData=cell(alglen,DSlen);

for algi=1:alglen
   [~,~,Algname]=GetAlgorithmByIndex(Alg(algi));
    EvalData{algi+1,1}=Algname;
end
for dsi =1:DSlen
    [~,~,DSname]=ExtractDataByNum(DataSet(dsi));
    EvalData{1,dsi+1}=DSname;
end

for algi=1:alglen
    for dsi =1:DSlen
        [Evldata]=Experiment_cell(Alg(algi),DataSet(dsi),Runtimes,NewIstPct);
        EvalData{algi+1,dsi+1}=Evldata;
    end
end
dirname={op.evlfp,'\mat\',datestr(date)};
dirname=cell2mat(dirname);
if exist(dirname)==0 
    mkdir(dirname);
end
matname={dirname,'\EprtData',ExperimentNumber,'.mat'};
matname=cell2mat(matname);
save(matname,'EvalData');
Plot_CellEvl_data(EvalData,ExperimentNumber);