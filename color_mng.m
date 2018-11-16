function [g_c,l_c,gammashist,lambdahist] = color_mng()
load all.mat
gh = gammashist;
lh=lambdahist;

g_new = zeros(length(gh(:,1)),(length(gh(1,:))-2)/4);
l_new = zeros(length(lh(:,1)),(length(lh(1,:))-2)/4);

g_c_1 = zeros(size(g_new));
g_c_2 = zeros(size(g_new));
l_c_1 = zeros(size(l_new));
l_c_2 = zeros(size(l_new));
g_c = zeros(length(gh(:,1)),3,length(g_new(1,:)));
l_c = zeros(length(lh(:,1)),3,length(l_new(1,:)));
%%

s_max_col =zeros(1,(length(gh(1,:))-2)/4);
s_min_col =zeros(1,(length(gh(1,:))-2)/4);
s_mid_col = zeros(1,(length(gh(1,:))-2)/4);
b_max_col =zeros(1,(length(gh(1,:))-2)/4);
b_min_col =zeros(1,(length(gh(1,:))-2)/4);
b_mid_col =zeros(1,(length(gh(1,:))-2)/4);

gh = gh(:,3:end);
%% because ode41 call odefun 4 times each tspan >1
% and initail gammashist need 1 col
% this why col of gammashist if equal to 2 + 4*(len(t)-1)
for i =1:length(g_new(1,:))
    i
    g_new(:,i) = (gh(:,(i-1)*4+1) + gh(:,(i-1)*4+2) + gh(:,(i-1)*4+3) + gh(:,(i-1)*4+4))/4;
    l_new(:,i) = (lh(:,(i-1)*4+1) + lh(:,(i-1)*4+2) + lh(:,(i-1)*4+3) + lh(:,(i-1)*4+4))/4;
    s_max_col(i) = max(g_new(:,i));
    b_max_col(i) = max(l_new(:,i));
    s_min_col(i) = min(g_new(:,i));
    b_min_col(i) = min(l_new(:,i));
    s_mid_col(i) = median(g_new(:,i));
    b_mid_col(i) = median(l_new(:,i));
end
%%
gammashist = g_new;
lambdahist = l_new;

for i = 1:length(gammashist(1,:))
    for j = 1:length(gammashist(:,i))
        if gammashist(j,i)<s_mid_col(i)
            g_c_1(j,i) = (gammashist(j,i)-s_min_col(i)*ones(size(gammashist(j,i))))/(s_max_col(i) -s_min_col(i));
            g_c_2(j,i) = (s_max_col(i)*ones(size(gammashist(j,i))) - gammashist(j,i))/(s_max_col(i) -s_min_col(i));
%         g_c_3(:,i) = (s_max_col(i)*ones(size(gammashist(:,i))) - gammashist(:,i))/(s_max_col(i) -s_min_col(i));
        
            g_c(j,1,i) = g_c_1(j,i);
            g_c(j,2,i) = g_c_2(j,i);
    %         g_c(:,3,i)=g_c_3(:,i);
            g_c(j,3,i) = 0;
        else
            g_c_1(j,i) = (gammashist(j,i)-s_min_col(i)*ones(size(gammashist(j,i))))/(s_max_col(i) -s_min_col(i));
            g_c_3(j,i) = (s_max_col(i)*ones(size(gammashist(j,i))) - gammashist(j,i))/(s_max_col(i) -s_min_col(i));
            g_c(j,1,i) = g_c_1(j,i);
            g_c(j,3,i) = g_c_3(j,i);
    %         g_c(:,3,i)=g_c_3(:,i);
%             g_c(j,2,i) = zeros(size(g_c_1(j,i)));
            g_c(j,2,i) =0;
        end
        l_c_1(:,i) = (lambdahist(:,i)-b_min_col(i)*ones(size(lambdahist(:,i))))/(b_max_col(i) -b_min_col(i));
        l_c_2(:,i) = (b_max_col(i)*ones(size(lambdahist(:,i))) - lambdahist(:,i))/(b_max_col(i) -b_min_col(i));
        l_c_3(:,i) = (b_max_col(i)*ones(size(lambdahist(:,i))) - lambdahist(:,i))/(b_max_col(i) -b_min_col(i));

        l_c(:,1,i) = l_c_1(:,i);
        l_c(:,2,i) = l_c_2(:,i);
        l_c(:,3,i) = l_c_3(:,i);
    end
end


