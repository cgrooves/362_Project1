function convertVideo2Jpg()

%store working directory for future use
working_dir = pwd;

%ask user for location of video file
[file_name, folder_name] = uigetfile('./*', 'Pick a Video to Convert to jpg files');

%move to that folder and read video as object
cd(folder_name)
video = VideoReader(file_name);

%ask user how many frames to skip at a time
buf = input('Enter the number of frames you want to skip at a time (default is 1):\n');
if isempty(buf)
    step = 1
else
    step = buf

%read each frame and make a string name to store it to file
counter = 1;
for counter=1:step:video.NumberOfFrames
    img = read(video,counter);
    filename = [sprintf('%06d',counter) '.jpg'];
    fullname = fullfile(folder_name,filename);
    imwrite(img,fullname)    % Write out to a jpg file (img1.jpg, img2.jpg, etc.)
    counter = counter + 1;
end

%go back to original directory
cd(working_dir);

end