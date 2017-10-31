close

% plot3(position3d(:,1),position3d(:,3),position3d(:,2),'b:')
% set(gca,'dataaspectratio',[1 1 1])
% hold on
% 
% avg_z = mean(position3d(:,3));
% z2d = zeros(size(points2d,1),1);
% z2d(:) = avg_z;
% 
% plot3(points2d(:,1),z2d,points2d(:,2),'r:')
% legend('2 Camera Method','1 Camera Method')
% title('Green Ball Trajectory (Angled)')
% % title('Green Ball Trajectory (Straight)')
% xlabel('X Position (in)')
% ylabel('Z Position (in)')
% zlabel('Y Position (in)')
% grid('on')
% 

dt = 1/15;
n = size(velocity_mag,1);
t = linspace(0,dt*n,n);

plot(t,velocity_mag,'b:')
hold on
plot(t,velocity2d_mag,'r:')
xlabel('Time (sec)')
ylabel('Velocity (in/sec)')
% title('Velocity of Ball (Angled)')
title('Velocity of Ball (Straight)')
legend('2 Camera Method','1 Camera Method')
