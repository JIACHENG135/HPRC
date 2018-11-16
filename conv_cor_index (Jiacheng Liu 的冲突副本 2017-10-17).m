function [C_b_in_new,C_s_in_new]=conv_cor_index(C_b_in,C_s_in,N,N_new)
char_value = car2sph_ljc(N_new');
C_b_in_new = zeros(size(C_b_in));
C_s_in_new = zeros(size(C_s_in));
for i=1:length(C_b_in(:,1))
%     C_b_in_new(i,1)=find(char_value==car2sph_ljc(N(:,C_b_in(i,1))'))
%     C_b_in_new(i,2)=find(char_value==car2sph_ljc(N(:,C_b_in(i,2))'));
end
for i=1:length(C_s_in(:,1))
    C_s_in_new(i,1)=find(char_value==car2sph_ljc(N(:,C_s_in(i,1))'),1);
    C_s_in_new(i,2)=find(char_value==car2sph_ljc(N(:,C_s_in(i,2))'),1);
end
end