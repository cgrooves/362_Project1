k = 0.0175; % inches/pixel - conversion factor

% left2d = load('Left_Angled_Pics/Left_Angled_Green.txt');
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
