function Plot_CellEvl_data(Evl_Cell,EpNumber)
% Evl_matrix is a cell of evaluation info 
% which include t,NMI,PUR,ACC for each algorithm
% In this function we input the cell and plot the line for them
% each row in each cell means Attribute value,each colume means the perfromance of the indicated algorithm
   setting=load('setting.mat');
   op=setting.op;  
   dirname={op.evlfp,'\image\',datestr(date),'\EP',EpNumber};
   dirname=cell2mat(dirname);
   if exist(dirname)==0 
        mkdir(dirname);
   end
   Attribute={'time','NMI','PUR','ACC'};
   linetype={'+','o','*','.','x','d','^','v','>','<','s','p','h'};
   color={'r','g','b','c','m','y','k'};
   natrb=length(Attribute);
   nclr=length(color);
   nlty=length(linetype);
 
   AlgnameSet=Evl_Cell(2:end,1);
   DSnameSet=Evl_Cell(1,2:end);
   nAlg=length(AlgnameSet);
   nDS=length(DSnameSet);
   
   clrltyp=cell(nAlg,1);
   for Algi=1:nAlg
        clr=color{mod(Algi-1,nclr)+1};
        lty=linetype{mod(Algi-1,nlty)+1};
        clrltyp{Algi}=['-',clr,lty];
   end
   for DSi=1:nDS
        DSname=DSnameSet{DSi};
        x=Evl_Cell{2,DSi+1}(1,:);
        for atri =1:natrb
            atrbname=Attribute{atri};
            for Algi=1:nAlg
                y=Evl_Cell{Algi+1,DSi+1}(atri+1,:);
                plot(x,y,clrltyp{Algi});

                hold on;
            end

            legend(AlgnameSet,'location','northeastoutside');
            xlabel('N');
            set(get(gca,'XLabel'),'FontSize',8)
            ylabel(atrbname);

            hold off;
%             imgname=cellstr({dirname,'\',DSname,atrbname,'.eps'});
%             saveas(gcf,cell2mat(imgname),'psc2');     
            imgname=cellstr({dirname,'\',DSname,atrbname,'.png'});
            saveas(gcf,cell2mat(imgname)); 
        end 
   end
end
