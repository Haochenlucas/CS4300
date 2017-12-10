clear;
load('G.mat');
load('P.mat');
load('W.mat');

% parse .jpg
for i = 1: 3
    switch i
        case 1
            for j = 1:9
                im = imread(strcat('g', char(j+'0'), '.jpg'));
                im = imresize(im,[15,15]);
                im = im>50;
                g_train(j,:) = im(:);
            end
        case 2
            for j = 1:9
                im = imread(strcat('p', char(j+'0'), '.jpg'));
                im = imresize(im,[15,15]);
                im = im>50;
                p_train(j,:) = im(:);
            end
        case 3
            for j = 1:9
                im = imread(strcat('w', char(j+'0'), '.jpg'));
                im = imresize(im,[15,15]);
                im = im>50;
                w_train(j,:) = im(:);
            end
    end
end

% G.mat parser
for i = 1:9
    G(i).im = imresize(G(i).im,[15,15]);
    G(i).im = G(i).im>50;
    G_train(i,:) = G(i).im(:);
end

% P.mat parser
for i = 1:9
    P(i,1).im = imresize(P(i,1).im,[15,15]);
    P(i,1).im = P(i,1).im>50;
    P_train(i,:) = P(i,1).im(:);
end

% W.mat parser
for i = 1:9
    G(i).im = imresize(G(i).im,[15,15]);
    G(i).im = G(i).im>50;
    G_train(i,:) = G(i).im(:);
end
