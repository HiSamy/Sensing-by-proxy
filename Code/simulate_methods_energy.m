function [occ_mat,safe_strategy,fixed_strategy,...
    sbp_strategy,bn_strategy,mlp_strategy,...
    log_strategy,safe_vio,fixed_vio,sbp_vio,...
    bn_vio,mlp_vio,log_vio] = simulate_methods...
    (schedule_mat,Ra,Rp,area,thres,adjust_occ_log,...
    adjust_occ_mlp,adjust_occ_bn,other_occ_vec)
load ../Data/confmat_comb.mat
sim_num = 1000;
occ_mat = [];
safe_strategy = nan(1,sim_num);
fixed_strategy = nan(1,sim_num);
sbp_strategy = nan(1,sim_num);
bn_strategy = nan(1,sim_num);
mlp_strategy = nan(1,sim_num);
log_strategy = nan(1,sim_num);
safe_vio = nan(sim_num,24);
fixed_vio = nan(sim_num,24);
sbp_vio = nan(sim_num,24);
bn_vio = nan(sim_num,24);
mlp_vio = nan(sim_num,24);
log_vio = nan(sim_num,24);
for sim_i = 1:sim_num
    occ_vec = draw_distribution(schedule_mat,0:9);
    occ_mat = [occ_mat;occ_vec];
    %% safe strategy: 
    %0-8,23-24,0occupancy,max occupancy for the rest 
    vent_num = 0;
    max_occ = max(occ_vec);
    vio_vec = zeros(1,24);
    for hour_j = 1:24
        if hour_j<8||hour_j>=23
            est_occ = 0;
            vent_num = vent_num+area*Ra;
        else
            est_occ = max_occ;
            vent_num = vent_num+area*Ra+max_occ*Rp;
        end
        if est_occ<occ_vec(hour_j)-thres % two people lower
            vio_vec(hour_j) = 1;
        end
    end
    safe_strategy(sim_i) = vent_num;
    safe_vio(sim_i,:) = vio_vec;
    %% fixed strategy
    % 0-8,20-24,0occupancy,max occupancy for the rest 
    vent_num = 0;
    max_occ = max(occ_vec);
    vio_vec = zeros(1,24);
    for hour_j = 1:24
        if hour_j<8||hour_j>=20
            est_occ = 0;
            vent_num = vent_num+area*Ra;
        else
            est_occ = max_occ;
            vent_num = vent_num+area*Ra+max_occ*Rp;
        end
        if est_occ<occ_vec(hour_j)-thres % several people lower
            vio_vec(hour_j) = 1;
        end
    end
    fixed_strategy(sim_i) = vent_num;
    fixed_vio(sim_i,:) = vio_vec;
    %% sbp strategy
    % classify according to the confusion matrix
    vent_num = 0;
    vio_vec = zeros(1,24);
    for hour_j = 1:24
        true_occ = occ_vec(hour_j);
        est_occ = draw_distribution(confmat_sbp(:,true_occ+1),0:7);
        vent_num = vent_num+area*Ra+est_occ*Rp;
        if est_occ<true_occ-thres % several people lower
            vio_vec(hour_j) = 1;
        end
    end
    sbp_strategy(sim_i) = vent_num;
    sbp_vio(sim_i,:) = vio_vec;
    %% bn strategy
    % classify according to the confusion matrix
    vent_num = 0;
    vio_vec = zeros(1,24);
    for hour_j = 1:24
        true_occ = occ_vec(hour_j);
        est_occ = draw_distribution(confmat_bn(:,true_occ+1),other_occ_vec)+...
            adjust_occ_bn;
        vent_num = vent_num+area*Ra+est_occ*Rp;
        if est_occ<true_occ-thres % several people lower
            vio_vec(hour_j) = 1;
        end
    end
    bn_strategy(sim_i) = vent_num;
    bn_vio(sim_i,:) = vio_vec;
    %% log strategy
    % classify according to the confusion matrix
    vent_num = 0;
    vio_vec = zeros(1,24);
    for hour_j = 1:24
        true_occ = occ_vec(hour_j);
        est_occ = draw_distribution(confmat_log(:,true_occ+1),other_occ_vec)+...
            adjust_occ_log;
        vent_num = vent_num+area*Ra+est_occ*Rp;
        if est_occ<true_occ-thres % several people lower
            vio_vec(hour_j) = 1;
        end
    end
    log_strategy(sim_i) = vent_num;
    log_vio(sim_i,:) = vio_vec;
    %% mlp strategy
    % classify according to the confusion matrix
    vent_num = 0;
    vio_vec = zeros(1,24);
    for hour_j = 1:24
        true_occ = occ_vec(hour_j);
        est_occ = draw_distribution(confmat_mlp(:,true_occ+1),other_occ_vec)+...
            adjust_occ_mlp;
        vent_num = vent_num+area*Ra+est_occ*Rp;
        if est_occ<true_occ-thres % several people lower
            vio_vec(hour_j) = 1;
        end
    end
    mlp_strategy(sim_i) = vent_num;
    mlp_vio(sim_i,:) = vio_vec;
end