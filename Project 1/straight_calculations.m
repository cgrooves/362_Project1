addpath ./'Code From Caleb'
object = load('calibrated_dlt_object');
frame = object.frame;

left_green = load('./Left_Straight_pics/Left_Straight_Green.txt');
right_green = load('./Right_Straight_pics/Right_Straight_Green.txt');

n = size(left_green,1);

position3d = zeros(n,3);

for i = 1:n
    
    left = left_green(i,:); % get current left point
    right = right_green(i,:); % get current right point
    
    % get 3d point, store in position3d
    position3d(i,:) = frame.point(left,right);
    
end

n = size(position3d,1);

% framerate was 30 frames/sec, sample frame rate was 15/sec
dt = 1/15;

% clip beginning/end frames off for central difference approximation
velocity_vector = zeros(n-2,3);
% vector of velocities using central difference approximation
for i = 2:(n-1)
    
    velocity_vector(i-1,1) = (position3d(i+1,1)-position3d(i-1,1))/(2*dt);
    velocity_vector(i-1,2) = (position3d(i+1,2)-position3d(i-1,2))/(2*dt);
    velocity_vector(i-1,3) = (position3d(i+1,3)-position3d(i-1,3))/(2*dt);
    
end

velocity_mag = zeros(n-2,1);

% get velocity magnitude
for i = 1:size(velocity_mag,1) 
    velocity_mag(i,1) = sqrt(velocity_vector(i,1)^2+velocity_vector(i,2)^2 ...
    +velocity_vector(i,3)^2);
end

k = 0.0175; % inches/pixel - conversion factor

left2d = load('Left_Straight_Pics/Left_Straight_Green.txt');

origin = [524.75,959.75];

n = size(left2d,1);

points2d = zeros(n,2);

for i = 1:n
    % convert from pixels to abs. coordinates
    points2d(i,1) = (left2d(i,1)-origin(1))*k;
    points2d(i,2) = (left2d(i,2)-origin(2))*-k;
    
end

% framerate was 30 frames/sec, sample frame rate was 15/sec
dt = 1/15;

% clip beginning/end frames off for central difference approximation
velocity2d = zeros(n-2,2);
% vector of velocities using central difference approximation
for i = 2:(n-1)
    
    velocity2d(i-1,1) = (points2d(i+1,1)-points2d(i-1,1))/(2*dt);
    velocity2d(i-1,2) = (points2d(i+1,2)-points2d(i-1,2))/(2*dt);
    
end

velocity2d_mag = zeros(n-2,1);

% get velocity magnitude
for i = 1:size(velocity2d_mag,1) 
    velocity2d_mag(i,1) = sqrt(velocity2d(i,1)^2+velocity2d(i,2)^2);
end

close

% plot 2 camera method 3d position points trajectory
plot3(position3d(:,1),position3d(:,3),position3d(:,2),'b:')
set(gca,'dataaspectratio',[1 1 1])
hold on

% plot 1 camera method using average z value for 2d points
avg_z = mean(position3d(:,3));
z2d = zeros(size(points2d,1),1);
z2d(:) = avg_z;
plot3(points2d(:,1),z2d,points2d(:,2),'r:')

% plot theoretical trajectory

% straight trajectory
center_straight = [8.26310793571569;8.50461638854701;0.663525083813644]';
theta = linspace(0,2*pi);
R = 13.5/2;
trajectory = zeros(100,3);

trajectory(:,1) = R*cos(theta);
trajectory(:,2) = R*sin(theta);
trajectory(:,3) = zeros(100,1);

trajectory_straight(:,1) = trajectory(:,1)+center_straight(1);
trajectory_straight(:,2) = trajectory(:,2)+center_straight(2);
trajectory_straight(:,3) = trajectory(:,3)+center_straight(3);
plot3(trajectory_straight(:,1),trajectory_straight(:,3),trajectory_straight(:,2),'k--')



% plot 3d position
figure(1)
% set plot options
legend('2 Camera Method','1 Camera Method','Theoretical Trajectory')
title('Green Ball Trajectory (Angled)')
% title('Green Ball Trajectory (Straight)')
xlabel('X Position (in)')
ylabel('Z Position (in)')
zlabel('Y Position (in)')
grid('on')


% plot velocities
figure(2)
dt = 1/15;
n = size(velocity_mag,1);
t = linspace(0,dt*n,n);

plot(t,velocity_mag,'b:')
hold on
plot(t,velocity2d_mag,'r:')
xlabel('Time (sec)')
ylabel('Velocity (in/sec)')
title('Velocity of Ball (Straight)')
legend('2 Camera Method','1 Camera Method')
