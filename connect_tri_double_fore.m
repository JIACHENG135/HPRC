function [C_s_cor_all,C_b_cor_all,Nodes_all,ori,size_z]=connect_tri_double_fore(wing_string,number,ratio)
[ori,size_z]=gene_ori_size(wing_string,number);
save size_z
C_s_cor_all = [];
C_b_cor_all = [];
Nodes_all=[];
counter=0;
for i =1:length(ori)
    [C_s_cor,C_b_cor,Nodes] = td_t_bar_gene(ori(i,:),size_z(i));
    
    if ori(i)<ratio
%     if size(i)>0.01
        counter = counter +1;
        C_s_cor_all = [C_s_cor_all;C_s_cor];
        C_b_cor_all = [C_b_cor_all;C_b_cor];
        if counter>1
%             disp('laotie 666')
            %% Skin outline and innerbone horizontal
            C_s_cor_all = [C_s_cor_all;Nodes_all(4*(counter-2)+2,:) Nodes(2,:)...
                ;Nodes_all(4*(counter-2)+3,:) Nodes(3,:);Nodes_all(4*(counter-2)+4,:) Nodes(4,:)];
            C_b_cor_all = [C_b_cor_all; Nodes_all(4*(counter-2)+1,:) Nodes(1,:)];
            %% inner strings
            C_s_cor_all = [C_s_cor_all;Nodes_all(4*(counter-2)+1,:) Nodes(2,:)...
                ;Nodes_all(4*(counter-2)+1,:) Nodes(3,:);Nodes_all(4*(counter-2)+1,:) Nodes(4,:)];
            C_s_cor_all = [C_s_cor_all;Nodes_all(4*(counter-2)+2,:) Nodes(1,:)...
                ;Nodes_all(4*(counter-2)+3,:) Nodes(1,:);Nodes_all(4*(counter-2)+4,:) Nodes(1,:)];
        end
        Nodes_all = [Nodes_all;Nodes];

    end
end

end

