%Welcome to Block Drop
%The objective of this game is to dodge the falling blocks
%Good Luck!


%Version 1.0
%At the moment, player can move around while trying to collect coins and
%avoid falling blocks
%players score increases when a coin is collected and the block slows its
%falling speed as well. As the game goes on, the falling speed is increased

%Areas of Improvement
%Add intro screen, add reset function so the code will restart without
%having to close the window

function Block_Drop

%-----------------------------VARIABLES-----------------------------------%

clear;clc;close all;

global obj_post
global obj
gameover = 0;               %if true, game will end
obj_post = [50,0];          %starting point of player
speed = 6;                  %speed of player
fall_speed = 4;             %speed of the block   
score = 0;                  %starting score
coin_position=[randi([10,90]),randi([10,30])];
coin = [];
check = [];
round = [];
coin_amount = 0;
coin_val = 50;
coin_color = [0.9020    0.8510    0.1608];
fall_speed_min = 3;
intro = true;
scrboard = [];
crush = [];
crush_cent = [];



%-------------------------------SETUP-------------------------------------%





%------------------------------INTRO--------------------------------------%

%Add an intro, had difficulty generating the play screen with two while
%loops, the thing is just being a real bitch for real
create_figure;

%-------------------------------GAME--------------------------------------%

timer = 0;
round = 1;
while gameover == 0
    drop_crush;
    check = obj_post;
    collect;
    collision;
        if crush_cent(2) < -120
            spawn_block;
        end
    if timer == 140*3*round
        fall_speed = fall_speed*1.5;
        round = round + 1;
    end
         %changes falling speed every couple of rounds
    refresh;
    pause(.025);           %adjusts frame rate
end
over;
%----------------------------FUNCTIONS------------------------------------%

function move(~,event)     %controls
    if ~gameover
    switch event.Key
        case 'leftarrow'
            if obj_post(1) > 2
            obj_post(1) = obj_post(1) - speed;
            end
        case 'rightarrow'
            if obj_post(1) < 98
            obj_post(1) = obj_post(1) + speed;
            end
        case 'uparrow'
            if obj_post(2) < 100
            obj_post(2) = obj_post(2) + speed;
            end
        case 'downarrow'
            if obj_post(2) > 0 
            obj_post(2) = obj_post(2) - speed;
            end
    end
    set(obj,'Xdata',obj_post(1),'Ydata',obj_post(2))
    end
        switch event.Key
            case 'r'
            if intro
            intro = 0; % for making the intro
            elseif gameover
                reset;
            end
        end
end
function create_figure
figure('KeyPressFcn',@move,'color','white');                %window
axes('Xlim',[0,100],'Ylim',[-20,120],'color','blue');
rectangle('Position',[0,-20,100,18],'FaceColor','green');   %ground
scrboard = annotation('textbox',[.5,.80,.1,.1],...          %scoreboard
    'string',score,'linestyle','none','fontsize',15);

obj = line(obj_post(1),obj_post(2),'color','red',...        %player
    'marker','.','markersize',50);

crush_cent = [randi([20,80]),100];                          %block
crush = rectangle('position',[(crush_cent(1)-10),...
    (crush_cent(2)),20,20],'facecolor','black');
coin = line(coin_position(1),coin_position(2),'marker','.','markersize',50,...
    'color',coin_color);
end
function drop_crush        %slowly drops block
    crush_cent(2) = crush_cent(2)-fall_speed;
end
function collision         %checks if player and block collided
    if abs(crush_cent(1)-check(1))<12 && abs(crush_cent(2)-check(2))<5
        gameover = 1;
    end    
end
function spawn_block       %spawns new block and updates score
    crush_cent = [obj_post(1)+randi([-10,10]),100];
crush = rectangle('position',[(crush_cent(1)-10),...
    (crush_cent(2)),20,20],'facecolor','black');
end
function collect
    if abs(coin_position(1)-check(1))<5 && abs(coin_position(2)-check(2))<5
            fall_speed = fall_speed*.95;
                if fall_speed < fall_speed_min
                    fall_speed = fall_speed_min;
                end
            coin_position = [randi([10,90]),randi([10,30])];
            coin_amount = coin_amount + coin_val;
            score = num2str(coin_amount);
            set(scrboard,'string',score)
                if timer == randi([0,140*round])
                    coin_position = [randi([10,90]),randi([10,30])];
                end
    end 
end
function refresh
        set(coin,'Xdata',coin_position(1),'Ydata',coin_position(2))
        timer = timer + 1; 
        set(crush,'position',[(crush_cent(1)-10),(crush_cent(2)),20,20])
        check = obj_post;
end
function over
    annotation('textbox',[.4,.4,.2,.25],'backgroundcolor','white',...
'fontsize',20,'string',"Game over Press Space to ccontinue!");
end   
function reset
        coin_amount = 0;
        score = num2str(coin_amount);
        set(scrboard,'string',score);
        crush_cent = [obj_post(1)+randi([-10,10]),100];
        crush = rectangle('position',[(crush_cent(1)-10),...
    (crush_cent(2)),20,20],'facecolor','black');    
        timer = 0;
        gameover = 0;
end
end