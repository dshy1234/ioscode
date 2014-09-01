function simulation()

% ar condition, focal length and code size
ar.fx = 650; %% 649.590771179639773;
ar.fy = 650; %% 653.240978126455161;
ar.codeSize = 0.5;
ar.imageSize = [480 640];
   
% code pose
p = getRTMatrix([pi/10, 0, pi/40], [0.05 0 5]);

% code original coordinates
codeOriginalPositionWorld = cat(1, [0 0 0;1 0 0;1 1 0;0 1 0]' * ar.codeSize * 1, [1 1 1 1]);

% rotate and translate code by pose matrix
codePositionWorld = p * codeOriginalPositionWorld;

% projected code into image plane
codeProjectedPosition = project(ar.fx, ar.fy, codePositionWorld);

pointsOnImageCoordinates = codeProjectedPosition .* repmat([1 -1]', 1, 4) + repmat([ar.imageSize(2)/2 ar.imageSize(1)/2]', 1, 4)

if 0
    % test data
    pointsOnImageCoordinates = [383.045563,175.191971; 320.699646,179.691986; 326.058777,239.484299; 391.187256,234.685532]';
    normalizedCodeProjectedPosition = (pointsOnImageCoordinates - repmat([ar.imageSize(2)/2 ar.imageSize(1)/2]', 1, 4)) ./ repmat([ar.fx -ar.fy]', 1, 4)
else
    % normalize a code's position on image by focal length
    normalizedCodeProjectedPosition = codeProjectedPosition ./ repmat([ar.fx ar.fy]', 1, 4);
end

% estimate code pose matrix from normalize a code's position on image
estimatedP = pose_estimation(ar, normalizedCodeProjectedPosition);

estimatedP

% rendering simulation
img = imread('../resource/code02.png');

drawCode(codePositionWorld, img);

hold on;

% exchenge y-z in order to assign z axis to a depth direction 
line([-0.5 0.5 0.5 -0.5 -0.5], [1 1 1 1 1], [-0.5 -0.5 0.5 0.5 -0.5]);
line([0 0], [1 1], [-0.5 0.5]);
line([-0.5 0.5], [1 1],[0 0]);
line([0 codePositionWorld(1,1)], [0 codePositionWorld(3,1)], [0 codePositionWorld(2,1)]);
line([0 codePositionWorld(1,2)], [0 codePositionWorld(3,2)], [0 codePositionWorld(2,2)]);
line([0 codePositionWorld(1,3)], [0 codePositionWorld(3,3)], [0 codePositionWorld(2,3)]);
line([0 codePositionWorld(1,4)], [0 codePositionWorld(3,4)], [0 codePositionWorld(2,4)]);

drawCode(cat(1, normalizedCodeProjectedPosition*1, [1 1 1 1]), img);

daspect([1 1 1]);
hold off;
view(60, 15);

end

function drawCode(code, img)
% exchenge y-z in order to assign z axis to a depth direction 
x = [[code(1,1) code(1,2)]; [code(1,4) code(1,3)]];
z = [[code(2,1) code(2,2)]; [code(2,4) code(2,3)]];
y = [[code(3,1) code(3,2)]; [code(3,4) code(3,3)]];
h = surf(x,y,z, img,...
         'FaceColor','texturemap',...
         'EdgeColor','none');
end