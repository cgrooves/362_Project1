classdef DLTFrame
    
    properties
        mCalibrationPoints
        mCalibrationImageRight
        mCalibrationImageLeft
        
        mL
        mR
    end
    
    methods
        %--------------------------
        function self = DLTFrame(calibration_object, uvL, uvR)
            % set properties
            self.mCalibrationPoints = calibration_object;
            self.mCalibrationImageRight = uvR;
            self.mCalibrationImageLeft = uvL;
            
            % calibrate the frame
            [self.mL, self.mR] = self.calibrate();
        end
        %---------------------------
        function [mL, mR] = calibrate(self)
           
            n = size(self.mCalibrationPoints,1);
            
            if size(self.mCalibrationPoints,1) < 6
                fprintf('Insufficient calibration points\n')
                return
            end
            
            % make FL and FR matrices
            FL = zeros(2*n,11);
            FR = zeros(2*n,11);
            
            % make an iterator for the rows
            % make an iterator for the points
            i = 1;
            r = 1;
            
            % get calibration x,y,z points
            x = self.mCalibrationPoints(:,1);
            y = self.mCalibrationPoints(:,2);
            z = self.mCalibrationPoints(:,3);
            
            % get L,R image u and v points
            uL = self.mCalibrationImageLeft(:,1);
            vL = self.mCalibrationImageLeft(:,2);
            
            uR = self.mCalibrationImageRight(:,1);
            vR = self.mCalibrationImageRight(:,2);
            
            % fill FL and FR
            while i <= n
                % Left Matrix
                % first row
                FL(r,1) = x(i);
                FL(r,2) = y(i);
                FL(r,3) = z(i);
                FL(r,4) = 1;

                FL(r,9) = -uL(i)*x(i);
                FL(r,10) = -uL(i)*y(i);
                FL(r,11) = -uL(i)*z(i);
                
                % second row
                FL(r+1,5) = x(i);
                FL(r+1,6) = y(i);
                FL(r+1,7) = z(i);
                FL(r+1,8) = 1;
                
                FL(r+1,9) = -vL(i)*x(i);
                FL(r+1,10) = -vL(i)*y(i);
                FL(r+1,11) = -vL(i)*z(i);
                
                % Right Matrix
                % first row
                FR(r,1) = x(i);
                FR(r,2) = y(i);
                FR(r,3) = z(i);
                FR(r,4) = 1;

                FR(r,9) = -uR(i)*x(i);
                FR(r,10) = -uR(i)*y(i);
                FR(r,11) = -uR(i)*z(i);
                
                % second row
                FR(r+1,5) = x(i);
                FR(r+1,6) = y(i);
                FR(r+1,7) = z(i);
                FR(r+1,8) = 1;
                
                FR(r+1,9) = -vR(i)*x(i);
                FR(r+1,10) = -vR(i)*y(i);
                FR(r+1,11) = -vR(i)*z(i);
                
                % increment row and point counters
                i = i + 1;
                r = r + 2;
                
            end
            
            % gL and gR matrices
            gL = zeros(2*n,1);
            gR = zeros(2*n,1);
            
            % fill gL, gR matrices
            i = 1;
            r = 1;
            while i <= n
                
                gL(r) = uL(i);
                gL(r+1) = vL(i);
                
                gR(r) = uR(i);
                gR(r+1) = vR(i);
            
                i = i + 1;
                r = r + 2;
            end
            
            % calculate L and R matrices
            mL = (FL' * FL) \ FL' * gL;
            mR = (FR' * FR) \ FR' * gR;
            
        end
        %--------------------
        function point3d = point(self,image_left,image_right)
            
            uL = image_left(1);
            vL = image_left(2);
            uR = image_right(1);
            vR = image_right(2);
            
            L = self.mL;
            R = self.mR;
            
            % make Q matrix
            Q = zeros(4,3);
            
            Q(1,1) = L(1) - L(9)*uL;
            Q(1,2) = L(2) - L(10)*uL;
            Q(1,3) = L(3) - L(11)*uL;
            Q(2,1) = L(5) - L(9)*vL;
            Q(2,2) = L(6) - L(10)*vL;
            Q(2,3) = L(7) - L(11)*vL;
            
            Q(3,1) = R(1) - R(9)*uR;
            Q(3,2) = R(2) - R(10)*uR;
            Q(3,3) = R(3) - R(11)*uR;
            Q(4,1) = R(5) - R(9)*vR;
            Q(4,2) = R(6) - R(10)*vR;
            Q(4,3) = R(7) - R(11)*vR;
            
            % make q matrix
            q = zeros(4,1);
            
            q(1) = uL - L(4);
            q(2) = vL - L(8);
            q(3) = uR - R(4);
            q(4) = vR - R(8);
            
            % solve for x,y,z
            point3d = (Q' * Q) \ Q' * q;           
        end
        %-------------------------
            
    end            
end
