function [max_a,max_elongation,max_position,travel_time]=plotA_newfigure(Hist,dt,C_s_new,S_0_percent,s_0,tf,perc)
[a,b,c]=size(Hist);
Ndhist=round(Hist.Ndhist,4);
Nhist=Hist.Nhist;
Nddhist = Hist.Nddhist;
tt=[0:dt:tf];
y=[];
index_nodes=find(Ndhist(3,:,2)~=0,1);
Ndd=[];
for i=1:length(tt)
% y=[y Ndhist(3,1,i)];
% y=[y Ndhist(3,15,i)];
y=[y Ndhist(3,index_nodes,i)];
Ndd = [Ndd Nddhist(3,index_nodes,i)];
end
% y=y;
% perc = 0.5;
T=find(abs(y(2:end))<perc,1)+1;
travel_time = T*dt;
N_new=Hist.Nhist(:,:,T);
% N_new = N_new(:,:,T);
Ndd=Ndd(1:T);
s_0_new = tenseg_percent2s0(N_new,C_s_new,S_0_percent);
delta = s_0_new - s_0;
Max_len_change=find(delta==max(delta),1);
S_max=[];
for i=1:T
    N_new = Hist.Nhist(:,:,i);
    S_max(i)=(eulerdst(N_new*(C_s_new(Max_len_change,:)'),[0;0;0])-s_0(Max_len_change))/s_0(Max_len_change);
end
t=tt(1:T);
ya=[];
for i=1:length(t)
ya=[ya Ndhist(3,index_nodes,i)];
end
yn=[];xn=[];zn=[];
for i=1:length(t)
yn=[yn Nhist(3,index_nodes,i)];
xn=[xn Nhist(2,index_nodes,i)];
zn=[zn Nhist(1,index_nodes,i)];
end
% ya=ya;
% x=0:16;
% y=tan(pi*x/20);
% xi=linspace(0,16);

% plot(x,y,'o',xi,yi)
% yd=diff(ya)/dt;
% td=t(1:length(yd));        
% xi= [0:dt:tt(T)];
% P=polyfit(0:dt:tt(T),yn,3);
% yi=P(1)*xi.^(3)+P(2)*xi.^(2)+P(3)*xi.^(1)+P(4);
% yd_new=diff(yi)/(dt);
%% plot the velocity of Nodes
% figure(1)
% plot(tt(2:end),y(2:end)),xlabel('time/s'),ylabel('velocity m/s'),title('Veloctiy v.s. Time'),hold on;
% % plot(t(find(abs(y(2:end))<perc+1,1)),y(find(abs(y(2:end))<perc+1,1)),'ro')
% % a=[' ' num2str(round((t(find(abs(y(2:end))<perc+1,1))),2))];
% % b=num2str(round(y(find(abs(y(2:end))<perc+1,1)),2));
% % str = [a,char(13,10)',b];
% % text(t(find(abs(y(2:end))<perc+1,1)),y(find(abs(y(2:end))<perc+1,1)),str);
% filepath = [pwd,'\Pictures\'];
% saveas(gcf,[filepath,'Velocity_time.jpg'])% saveas(gcf,'Veloctiy_Time.jpg');
% hold off;
%% plot the acceleration of nodes
% figure(2)
% plot(xi(1:end-1),yd_new),xlabel('time/s'),ylabel('acceleration m^2/s'),title('Acceleration v.s. Time'),hold on;
% plot(t(1:end-1),yd,'r*'),xlabel('time/s'),ylabel('acceleration m^2/s'),title('Acceleration v.s. Time'),hold on;
% 
% plot(t(find(yd_new==max(yd_new),1)),yd_new(find(yd_new==max(yd_new),1)),'ro')
% % plot(t(find(yd==max(yd),1)),yd(find(yd==max(yd),1)),'ro')
% 
% a=[' ' num2str(round(t(find(yd_new==max(yd_new),1)),4))];
% b=num2str(round(yd(find(yd_new==max(yd_new),1)),2));
% str = [a,char(13,10)',b];
% text(t(find(yd_new==max(yd_new),1)),yd(find(yd_new==max(yd_new),1)),str);
% plot(xi(1:end-1),Ndd),xlabel('time/s'),ylabel('acceleration m^2/s'),title('Acceleration v.s. Time'),hold on;
% plot(t,Ndd),xlabel('time/s'),ylabel('acceleration m^2/s'),title('Acceleration v.s. Time'),hold on;
% 
% plot(t(find(Ndd==max(Ndd),1)),Ndd(find(Ndd==max(Ndd),1)),'ro')
% % plot(t(find(yd==max(yd),1)),yd(find(yd==max(yd),1)),'ro')
% 
% a=[' ' num2str(round(t(find(Ndd==max(Ndd),1)),4))];
% b=num2str(round(Ndd(find(Ndd==max(Ndd),1)),2));
max_a = round(Ndd(find(Ndd==max(Ndd))),4);
% str = [a,char(13,10)',b];
% text(t(find(Ndd==max(Ndd),1)),Ndd(find(Ndd==max(Ndd),1)),str);
% filepath = [pwd,'\Pictures\'];
% saveas(gcf,[filepath,'Acceleration.jpg']);% saveas(gcf,'Veloctiy_Time.jpg');
% hold off;
%% plot the position of nodes
% figure(3)
% Create figure in which to plot each frame
% vid = VideoWriter('Motion','MPEG-4');
% open(vid);
% view_vec = [];
% frame_skip = 1;
% % highlight_nodes = [];
% fig = figure();
% % Determine view/axes based on Node matrix history
% [axis_vec, view_vec_derived] = tenseg_axisview(Nhist);
% % If no view vector defined, use the one derived from Nhist
% if isempty(view_vec),
% 	view_vec = view_vec_derived;
% end
% % Go through all time steps, plot, adjust axes, and write to video file
% for i=1:frame_skip:size(Nhist,3)
% 	N = Nhist(:,index_nodes,i);
% 	fig = plot3(N(1),N(2),N(3),'r*'),grid on,hold on;
% 	axis equal
%  	axis(axis_vec)
% 	
% 	% Get frame width/height and write frame (including axes) to file
% 	position = get(gcf,'Position'); % do this to include axes in video
% 	writeVideo(vid,getframe(gcf,[0 0 position(3:4)]));
% % 	writeVideo(vid,position);
% 	clf
% end
% close(vid);
% for i=1:length(t)
% % plot3(t,yn,t,xn,t,zn),xlabel('time/s'),ylabel('Z/m'),title('Postion v.s. Time'),hold on;
%     plot3(xn(i),zn(i),yn(i),'r*'),xlabel('X/m'),ylabel('Y/m'),zlabel('Z/m'),title('Trajectory/m'),hold on;
% end
% % plot(t(find(yn==min(yn))),yn(find(yn==min(yn))),'ro')
% % a=[' ' num2str(round(t(find(yn==min(yn))),4))];
% % b=num2str(round(yn(find(yn==min(yn))),2));
% % str = [a,char(13,10)',b];
% % text(t(find(yn==min(yn))),yn(find(yn==min(yn))),str);
% filepath = [pwd,'\Pictures\'];
% saveas(gcf,[filepath,'Trajectory.jpg']);
%% plot the length change of Max_change_string
% figure(4)
% plot(t,100*S_max(1:T),'r'),title('maximum elongation'),xlabel('time/s'),ylabel('elongation X 100%'),hold on
% filepath = [pwd,'\Pictures\'];
% SS=S_max(1:T);
max_elongation = max(S_max(1:T))*100;
% plot(t(find(S_max(1:T)==max(S_max(1:T)),1)),100*SS(find(SS==max(SS),1)),'ro');
% % plot(t(find(yd==max(yd),1)),yd(find(yd==max(yd),1)),'ro')
% 
% a=[' ' num2str(round(t(find(SS==max(SS),1)),4))];
% b=num2str(round(SS(find(SS==max(SS),1)),2));
% max_a = round(SS(find(SS==max(SS))));
% str = [a,char(13,10)',b];
% text(t(find(SS==max(SS),1)),100*SS(find(SS==max(SS),1)),str);
% saveas(gcf,[filepath,'Elongation_Time.jpg']);
%% plot the structure and max_change_length string
% N_simple = plotStructure.N_simple;
% C_b = plotStructure.C_b;
% C_s = plotStructure.C_s;
% Max_change_N.string_start_nodes_max_length_change = N_new(:,C_s_new(Max_len_change,:)==-1);
% Max_change_N.Snew=N_new * C_s_new(Max_len_change,:)';
% tenseg_plotljc(N_simple,C_b,C_s,5,Max_change_N);
% for i=1:length(t)
% % plot3(t,yn,t,xn,t,zn),xlabel('time/s'),ylabel('Z/m'),title('Postion v.s. Time'),hold on;
%     plot3(xn(i),zn(i),yn(i),'r.'),xlabel('X/m'),ylabel('Y/m'),zlabel('Z/m'),title('Travel distance and maximum elongation string'),hold on;
% end
% str =num2str(yn(i));
% text(xn(i),zn(i),yn(i),str);
max_position = yn(T);
% filepath = [pwd,'\Pictures\'];
% saveas(gcf,[filepath,'Structure_with_longest.jpg']);