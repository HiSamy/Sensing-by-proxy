function [return_val supply_val blackboard_val] = ...
    baseline_calibration(return_ori,supply_ori,blackboard_ori,...
    startind,endind)
for i = 2:length(return_ori)
    if return_ori(i)<=0
        return_ori(i) = return_ori(i-1);
    end
end
for i = 2:length(supply_ori)
    if supply_ori(i)<=0
        supply_ori(i) = supply_ori(i-1);
    end
end
for i = 2:length(blackboard_ori)
    if blackboard_ori(i)<=0
        blackboard_ori(i) = blackboard_ori(i-1);
    end
end
offset_ret = mean(return_ori(startind:endind))-400;
offset_sup = mean(supply_ori(startind:endind))-400;
offset_black = mean(blackboard_ori(startind:endind))-400;

return_val = return_ori-offset_ret;
supply_val = supply_ori-offset_sup;
blackboard_val = blackboard_ori-offset_black;

