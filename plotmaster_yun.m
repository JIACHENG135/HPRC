function plotmaster_yun(qi,phii)
load Yun.mat
[a,b] = size(Hist);
lenq=a;
lenphii=b;
acceleration = zeros(lenq,lenphii);
elongation = zeros(lenq,lenphii);
position = zeros(lenq,lenphii);
travel_time = zeros(lenq,lenphii);
% Hist_temp = cell(lenq,lenphii);
% count = 0;
for i = 1:lenq
    for j = 1:lenphii
        Hist_temp = Hist{i,j};
        [acceleration(i,j),elongation(i,j),position(i,j),travel_time(i,j)]=relativity_new_yun(Hist_temp);
    end
end
%%
% acced=acceleration(:);
% nomrlized_acce = spline(sumqphi,acced,sumqphid);
% 
% accedd = reshape(nomrlized_acce,length(qid),length(phiid));
% 
% figure(1)
% surf(qid,phiid,accedd'),title('Acceleration v.s. Complexity'),xlabel('q'),ylabel('phi'),zlabel('Accelartion');

%%
figure(1)
surf(qi,phii,acceleration'),title('Acceleration v.s. Complexity'),xlabel('q'),ylabel('phi'),zlabel('Accelartion');

figure(2)
surf(qi,phii,elongation'),title('Elongation v.s. Complexity'),xlabel('q'),ylabel('phi'),zlabel('Elongation');

figure(3)
surf(qi,phii,position'),title('Position v.s. Complexity'),xlabel('q'),ylabel('phi'),zlabel('Position');

figure(4)
surf(qi,phii,travel_time'),title('Travel Time v.s. Complexity'),xlabel('q'),ylabel('phi'),zlabel('Travel_time');

figure(5)
normalized_cost = 0.2*guiyihua(acceleration')+0.8*guiyihua(elongation');
surf(qi,phii,normalized_cost),title('Normalized_cost v.s. Complexity'),xlabel('q'),ylabel('phi'),zlabel('Normalized_cost');
% save Yun.mat
end 