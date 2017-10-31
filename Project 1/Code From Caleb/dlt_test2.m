clc; clear; close;
% Calibration points
C = [0 0.5 0.5;
    0 0 0.5;
    0.5 0.5 0.5;
    0.5 0 0.5;
    0 0.5 0;
    0 0 0];

% calibration image points
left = [320 530;
    664 631;
    571 469;
    918 578;
    265 935;
    619 1034];

right = [219 597;
    518 687;
    523 530;
    825 621;
    190 997;
    502 1093];

test = DLTFrame(C,left,right)

imageLeft = [870 991];
imageRight = [814 1042];

test.point(imageLeft,imageRight)

