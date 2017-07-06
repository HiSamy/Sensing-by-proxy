supply_return = nan(1,3);
supply_other = nan(1,3);
return_other = nan(1,3);

load ../Data/30minCycle0828.mat
startind = 1000;
endind = 42000;
cor_vec = crosscorr(return_ori(startind:endind),supply_ori(startind:endind),1);
supply_return(1) = cor_vec(2);
cor_vec = crosscorr(black_ori(startind:endind),supply_ori(startind:endind),1);
supply_other(1) = cor_vec(2);
cor_vec = crosscorr(return_ori(startind:endind),black_ori(startind:endind),1);
return_other(1) = cor_vec(2);

load ../Data/1HourCycle0929.mat
startind = 1000;
endind = 40000;
cor_vec = crosscorr(return_ori(startind:endind),supply_ori(startind:endind),1);
supply_return(2) = cor_vec(2);
cor_vec = crosscorr(black_ori(startind:endind),supply_ori(startind:endind),1);
supply_other(2) = cor_vec(2);
cor_vec = crosscorr(return_ori(startind:endind),black_ori(startind:endind),1);
return_other(2) = cor_vec(2);

load ../Data/3HourCycle0803.mat
startind = 1000;
endind = 60000;
cor_vec = crosscorr(return_ori(startind:endind),supply_ori(startind:endind),1);
supply_return(3) = cor_vec(2);
cor_vec = crosscorr(black_ori(startind:endind),supply_ori(startind:endind),1);
supply_other(3) = cor_vec(2);
cor_vec = crosscorr(return_ori(startind:endind),black_ori(startind:endind),1);
return_other(3) = cor_vec(2);

fprintf('The mean of cross-correlation \n between return and supply is: %f\n'...
    ,mean(supply_return));
fprintf('The mean of cross-correlation \n between return and blackboard is: %f\n'...
    ,mean(return_other));
fprintf('The mean of cross-correlation \n between blackboard and supply is: %f\n'...
    ,mean(supply_other));

fprintf('The std of cross-correlation \n between return and supply is: %f\n'...
    ,std(supply_return));
fprintf('The std of cross-correlation \n between return and blackboard is: %f\n'...
    ,std(return_other));
fprintf('The std of cross-correlation \n between blackboard and supply is: %f\n'...
    ,std(supply_other));