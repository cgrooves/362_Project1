object = load('calibrated_dlt_object');
frame = object.frame;

% left_green = load('./Left_Angled_pics/Left_Angled_Green.txt');
% right_green = load('./Right_Angled_pics/Right_Angled_Green.txt');

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

get_2d_points

generate_figures