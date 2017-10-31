% get right calibration points
addpath ./../"Code from Caleb"

imshow('./Left_Angled_Pics/000001.jpg')

[uL,vL] = ginput(14);

imshow('./Right_Straight_Pics/000001.jpg')

[uR,vR] = ginput(14);