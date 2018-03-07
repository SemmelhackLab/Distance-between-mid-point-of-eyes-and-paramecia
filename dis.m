function [xm, ym, centroids2, c3, dist]= dis(N)
%N: the image
% xm: x coord of mid point between eyes
% ym: y coord of mid point between eyes
% centroids2: detection of paramecia without angle selection
%c3: after selection (and possibly manual selection)
%dist: distance between paramecia and midpoint


P = 10; %smallest size counted
UB = 300; %largest size counted
to = 20; %tolerance of y coor of paramecia below the line 
         % passing through mid point and one of the eye
         % being accepted
         
NP = 0.9; % threshold in BW image --> select paramecia

%note:         
%BA2 is the original filtered paramecia location based on size
%but not filtered with location yet
         



BB = im2bw(N, 0.3);
BB0 = ~BB;
BA = bwareaopen(BB0,370); %eye: 350 to 400 %sw: <350
s = regionprops(BA,'centroid');
 centroids = cat(1, s.Centroid);
 centroids(isnan(centroids)) = [];
 [sa sb] = size(centroids);
 if sa > 2
     yce = centroids(:,2);
     yye = find(yce == max(yce));
     centroids(yye,:) = [];
 end
 
  % locate the 2 eyes and find mid point of eyes

 CE = centroids;
 
 xm = (CE(1,1) + CE(2,1))/2;
 ym = (CE(1,2) + CE(2,2))/2;
 
 % paramecia with size selection between P and UB
 BB2a = im2bw(N, NP); 
BB2 = ~BB2a;
% BA2 = bwareaopen(BB2,P);%remove small objects
% LB = 30;
% UB = 50;
BA2 = xor(bwareaopen(BB2,P),  bwareaopen(BB2,UB));

s2 = regionprops(BA2,'centroid');
 centroids2 = cat(1, s2.Centroid);
 centroids2(isnan(centroids2)) = [];



 
 
 % deleting paramecia below the line passing through midpoint 
 % and one of the eye (CE(1))
 [a2 b2] = size(centroids2);
 centroids3 = centroids2; %centroids3 will be the selected set of paramecia
 
 sl = (ym - CE(1,2))/(xm -  CE(1,1));
 
 for II = 1:a2
     x = centroids2(II,1);
     y0 = sl*(x-xm) + ym;
     yd = centroids2(II,2) - y0;
     if yd > to
         centroids3(II,:) = nan;
     end
 end
 % checking
 % figure; imshow(N); hold on; plot(x,y0,'*');plot(x,centroids2(II,2),'*', 'color','r')
         centroids3(isnan(centroids3)) = [];
         
         %c3: reshape centroids3
         [a4 b4] = size (centroids3);
         b5 = b4/2;
         b6 = b5+1;
         
         c3 = [centroids3(1:b5);centroids3(b6:b4)];
         c3 = c3';
         
         figure; imshow(N);
 figure; imshow(N); hold on; plot(c3(:,1),c3(:,2),'*');
 plot(xm,ym,'*', 'color','r');
 hold off;
 
 % manual selection of paramecia
 prompt = 'ok? ';% sample ans: 1 means ok, 2 means not and manually collect data, 3 means changing parameters
x = input(prompt);

while x ==3 | x == 2
while x == 3
    c3
     prompt = '[NP P UB]?';% sample ans: [0.8 10 300]
awe = input(prompt);
NP = awe(1);
P = awe(2);
UB = awe(3);


 BB2a = im2bw(N, NP); 
BB2 = ~BB2a;
% BA2 = bwareaopen(BB2,P);%remove small objects
% LB = 30;
% UB = 50;
BA2 = xor(bwareaopen(BB2,P),  bwareaopen(BB2,UB));

s2 = regionprops(BA2,'centroid');
 centroids2 = cat(1, s2.Centroid);
 centroids2(isnan(centroids2)) = [];



 
 
 % deleting paramecia below the line passing through midpoint 
 % and one of the eye (CE(1))
 [a2 b2] = size(centroids2);
 centroids3 = centroids2; %centroids3 will be the selected set of paramecia
 
 sl = (ym - CE(1,2))/(xm -  CE(1,1));
 
 for II = 1:a2
     x = centroids2(II,1);
     y0 = sl*(x-xm) + ym;
     yd = centroids2(II,2) - y0;
     if yd > to
         centroids3(II,:) = nan;
     end
 end
 % checking
 % figure; imshow(N); hold on; plot(x,y0,'*');plot(x,centroids2(II,2),'*', 'color','r')
         centroids3(isnan(centroids3)) = [];
         
         %c3: reshape centroids3
         [a4 b4] = size (centroids3);
         b5 = b4/2;
         b6 = b5+1;
         
         c3 = [centroids3(1:b5);centroids3(b6:b4)];
         c3 = c3';
         
         figure; imshow(N);
 figure; imshow(N); hold on; plot(c3(:,1),c3(:,2),'*');
 plot(xm,ym,'*', 'color','r');
 hold off;








     
          prompt = 'ok? ';% sample ans: 1 means ok, others are not
x = input(prompt);
end
while x == 2
    c3
     prompt = 'c3? ';% sample ans: [23 45]
c3 = input(prompt);
     figure; imshow(N); hold on; plot(c3(:,1),c3(:,2),'*');
 plot(xm,ym,'*', 'color','r');
 hold off;
          prompt = 'ok? ';% sample ans: 1 means ok, others are not
x = input(prompt);
end
end


 %distance
 [a3 b3] = size(c3);
 dist = zeros(a3,1);
 
 for i2 = 1:a3
     xe1 = c3(i2,1);
     ye1 = c3(i2,2);     
     dist(i2) = ((xe1-xm)^2 + (ye1-ym)^2)^0.5;
 end

 
 
 
 
 
 
     

 %checking
 % figure; imshow(BB);hold on;plot(centroids(:,1),centroids(:,2),'*');
 % eye mid point
 
 % figure; imshow(N);hold on;plot(centroids2(:,1),centroids2(:,2),'*');%
 % paramecia
 
 %figure; imshow(N); hold on; plot(x,y0,'*');plot(x,centroids2(II,2),'*', 'color','r');
 % selecting centroids3 based on y coor

%(x,y0) obtain the line for selecting centroids3 (and thus c3)
%  x = [1:640];
% y0=[];
% for II = 1:640
%      %x = centroids2(II,1);
%      y0(II) = sl*(x(II)-xm) + ym;
%      
%  end

end


