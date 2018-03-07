%this is for all files in the folder(avi)
%Output: cells of dist and others as described in func 'dis'




myFolder = 'E:\Ricky\2018\Jan\Jan 24\sure';%select imput folder
subFolderName = 'D:';%select output folder
%incase you need to save automatically, if subFolderName is changed, please also change newChr below
filePattern = fullfile(myFolder, '*.avi'); %select type of files
aviFiles   = dir(filePattern);
w = length(aviFiles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




for ij = 1:w
         baseFileName = aviFiles(ij).name;
  fullFileName = fullfile(myFolder, baseFileName);
  %fprintf('Now reading %s\n', fullFileName);
  %imageArray = imread(fullFileName);
  
obj{ij} = VideoReader(fullFileName);
vid{ij} = read(obj{ij});
p = obj{ij}.NumberOfFrames;%total number of frames


% prompt = 'What is the original value? ';
% x = input(prompt)
% y = x*10
prompt = 'frames? ';% sample ans: [23 45 67]
x = input(prompt);
g = 2;
for ab = x
dist{ij,1} = baseFileName;    
[xm(ij,g), ym(ij,g), centroids2{ij,g}, c3{ij,g}, dist{ij,g}]= dis(vid{ij}(:,:,:,ab));
g= g+1;
end



end