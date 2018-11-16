function gene_video_tail_sway(tf,theta,number,wing_string,video_name)
td = theta / tf;
% tf/td
v_1=VideoWriter([video_name '1']);
v_2=VideoWriter([video_name '2']);
v_3=VideoWriter([video_name '3']);
v_4=VideoWriter([video_name '4']);

open(v_1);
for i=1:tf*5                 
dolphin_target_generator(wing_string,td/5*i,number)
frame=getframe(gcf);
writeVideo(v_1,frame);
close(gcf)
end

close(v_1)
open(v_2);
for i=1:tf*5  
dolphin_target_generator(wing_string,td/5*(tf*5-i+1),number)
frame=getframe(gcf);
writeVideo(v_2,frame);
close(gcf)
end

close(v_2)
open(v_3);
for i=1:tf*5  
dolphin_target_generator(wing_string,-td/5*i,number)
frame=getframe(gcf);
writeVideo(v_3,frame);
close(gcf)
end

close(v_3)
open(v_4);
for i=1:tf*5  
dolphin_target_generator(wing_string,-td/5*(tf*5-i+1),number)
frame=getframe(gcf);
writeVideo(v_4,frame);
close(gcf)
end

close(v_4)
end

