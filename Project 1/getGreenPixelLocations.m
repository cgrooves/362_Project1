%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ME 362 - Brigham Young University %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This code is based on the file "SimpleColorDetectionByHue.m"
% on the MATLAB file exchange. The associated license file
% is included with it in order to respect the original license
% despite the fact that it has been heavily modified by
% Dr. Killpack
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [center_of_mass] = getGreenPixelLocations()
close all;	% Close all figure windows except those created by imtool.
imtool close all;	% Close all figure windows created by imtool.
workspace;	% Make sure the workspace panel is showing.

% Change the current folder to the folder of this m-file.
% (The "cd" line of code below is from Brett Shoelson of The Mathworks.)
if(~isdeployed)
    cd(fileparts(which(mfilename))); % From Brett
end

try
    % Check that user has the Image Processing Toolbox installed.
    hasIPT = license('test', 'image_toolbox');
    if ~hasIPT
        % User does not have the toolbox installed.
        message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
        reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
        if strcmpi(reply, 'No')
            % User said No, so exit.
            return;
        end
    end
    
    % Continue with the demo.  Do some initialization stuff.
    close all;
    
    % Change the current folder to the folder of this m-file.
    % (The line of code below is from Brett Shoelson of The Mathworks.)
    if(~isdeployed)
        cd(fileparts(which(mfilename)));
    end
    
    % Browse for the image files
    folder = uigetdir('./', 'Pick a Directory with Your JPG photos');
    cd(folder);
    
    %get a list of all images files in this folder
    files = dir('*.jpg');
    
    %ask the user for a file name to store the pixel values
    filename = input('please specify the file output name:\n','s');
    filename = strcat(filename,'.txt');
    
    
    % This is a user-defined parameter to adjust the size of the green
    % area to track - Keep areas only if they're bigger than this.
    buf = input('please specify the pixel area size of the green object to track (default is 500):\n');
    if isempty(buf)
        smallestAcceptableArea = 500;
    else
        smallestAcceptableArea = buf;
    end
    
    %getting the number of images to analyze
    [rows, columns] = size(files);
    numImages = rows;
    
    %initializing an empty array to store the pixel values in
    center_of_mass = zeros(numImages, 2);
    
    %for each image, we will find the centroid of green values
    for i = 1:1:numImages
        %read in the image
        [rgbImage, storedColorMap] = imread(files(i).name);
        [rows, columns, numberOfColorBands] = size(rgbImage);
        
        % If it's monochrome (indexed), convert it to color.
        % Check to see if it's an 8-bit image needed later for scaling).
        if strcmpi(class(rgbImage), 'uint8')
            % Flag for 256 gray levels.
            eightBit = true;
        else
            eightBit = false;
        end
        if numberOfColorBands == 1
            if isempty(storedColorMap)
                % Just a simple gray level image, not indexed with a stored color map.
                % Create a 3D true color image where we copy the monochrome image into all 3 (R, G, & B) color planes.
                rgbImage = cat(3, rgbImage, rgbImage, rgbImage);
            else
                % It's an indexed image.
                rgbImage = ind2rgb(rgbImage, storedColorMap);
                % ind2rgb() will convert it to double and normalize it to the range 0-1.
                % Convert back to uint8 in the range 0-255, if needed.
                if eightBit
                    rgbImage = uint8(255 * rgbImage);
                end
            end
        end
        
        % Convert RGB image to HSV
        hsvImage = rgb2hsv(rgbImage);
        
        % Extract out the H, S, and V images individually
        hImage = hsvImage(:,:,1);
        sImage = hsvImage(:,:,2);
        vImage = hsvImage(:,:,3);
        
        % Assign the low and high thresholds for green in HSV space.
        hueThresholdLow = 0.35;
        hueThresholdHigh = 0.45;
        saturationThresholdLow = 0.35;
        saturationThresholdHigh = 1;
        valueThresholdLow = 0;
        valueThresholdHigh = 0.8;
        
        % Now apply each color band's particular thresholds to the color band
        hueMask = (hImage >= hueThresholdLow) & (hImage <= hueThresholdHigh);
        saturationMask = (sImage >= saturationThresholdLow) & (sImage <= saturationThresholdHigh);
        valueMask = (vImage >= valueThresholdLow) & (vImage <= valueThresholdHigh);
        
        % Combine the masks to find where all 3 are "true."
        % Then we will have the mask of only the red parts of the image.
        coloredObjectsMask = uint8(hueMask & saturationMask & valueMask);
        
        % Get rid of small objects.  Note: bwareaopen returns a logical.
        coloredObjectsMask = uint8(bwareaopen(coloredObjectsMask, smallestAcceptableArea));
        
        % Smooth the border using a morphological closing operation, imclose().
        structuringElement = strel('disk', 4);
        coloredObjectsMask = imclose(coloredObjectsMask, structuringElement);
        
        % Fill in any holes in the regions, since they are most likely green also.
        coloredObjectsMask = imfill(logical(coloredObjectsMask), 'holes');
        [v_s, u_s] = find(coloredObjectsMask);
        if isnan(mean(u_s)) || isnan(mean(v_s))
            center_of_mass(i,1:2) = [-1, -1];
        else
            center_of_mass(i,1:2) = [mean(u_s), mean(v_s)];
        end
        figure()
        imshow(coloredObjectsMask);
        close all;
    end
    
    save(filename,'center_of_mass','-ascii');
    
catch ME
    errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
        ME.stack(1).name, ME.stack(1).line, ME.message);
    fprintf(1, '%s\n', errorMessage);
    uiwait(warndlg(errorMessage));
end

