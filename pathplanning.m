clear all
clc
%设置起始点
init_x = 20;
init_y = 20;

%设置目标点
end_x = 700;
end_y = 700;

goal(1) = end_x;
goal(2) = end_y;

%建立树，根节点为起始点Tree.v(1)
Tree.v(1).x = init_x;
Tree.v(1).y = init_y;
Tree.v(1).xFather = init_x;  %根节点的父节点仍是它本身
Tree.v(1).yFather = init_y;
Tree.v(1).dis = 0; %从父节点到该节点的距离

ArriveDis=10; %距离终点的阈值

count=length(Tree.v);   %*******length(Tree.v)指的是结构体Tree里v的个数，也即点的个数！！！！！！！！！！！！！！！！

%读取地图
figure(1);
map = im2bw(imread('map.bmp'));  %读取图片并二值化作为地图
imshow(map);
mapX = size(map,1);%地图x轴长度
mapY = size(map,2);%地图y轴长度


hold on;
plot(init_x, init_y, 'ro', 'MarkerSize',5, 'MarkerFaceColor','r');
plot(end_x, end_y, 'go', 'MarkerSize',5, 'MarkerFaceColor','b');% 绘制起点和目标点

for iter1=1:5000    %大循环：给一个足够大的数去做下面的循环，直至找到所有的p_new
  for n=1:5000  %小循环：给一个足够大的数去做下面的循环，直至找到一个p_new
    %Step 1: 在地图中随机采样一个点p_rand 但是p_rand不能是在障碍物上
    %当是原点坐标或在障碍物上，就重新随机
    p_rand(1)= round(rand() * mapX);   %随机生成X轴坐标，rand()生成的是0~1均匀分布的随机数，乘以X轴范围再向上取整，数便为[1,X轴长度]间的整数
    p_rand(2)= round(rand() * mapY);   %随机生成Y轴坐标  
    if p_rand(1) < 1   
          p_rand(1) = 1;
       else if p_rand(1) > mapX
          p_rand(1) = mapX;
           end
     end
     if p_rand(2) < 1
          p_rand(2) = 1;
       else if p_rand(2) > mapY
          p_rand(2) = mapY;
           end
    end   
    while (p_rand(1) == 1 && p_rand(2) == 1) || (map(p_rand(1),p_rand(2)) == 0)  %当是原点或在障碍物上
        p_rand(1) = round(rand() * mapX); % 重新生成p_rand点
        p_rand(2) = round(rand() * mapY);
        if p_rand(1) < 1   
          p_rand(1) = 1;
       else if p_rand(1) > mapX
          p_rand(1) = mapX;
           end
        end
        if p_rand(2) < 1
           p_rand(2) = 1;
        else if p_rand(2) > mapY
           p_rand(2) = mapY;
            end
        end   
    end

    p_near=[];
    %Step 2: 遍历树的每个点，从树中找到最近邻近点p_near 
    min_distance = 1000;  %先随机赋一个值
    index = 1;  %index先指向根节点
    for i = 1:count     
        distance = sqrt( ( Tree.v(i).x - p_rand(1) )^2 + ( Tree.v(i).y - p_rand(2) )^2 );    %计算树中的每个点和p_rand点之间的距离
        if distance < min_distance
            min_distance = distance;  %把当前计算出来的距离赋给min_distance，最后min_distance里保存的是最小距离
            index = i;   %保存最小距离对应的点
        end
    end
    p_near(1) = Tree.v(index).x; %保存距离随机点距离最近的点
    p_near(2) = Tree.v(index).y;

    p_new=[];
    %Step 3: 由距离随机点最近的点向随机点的方向以Delta的步长扩展得到p_new节点
    Delta = 10;  %步长设置为10
    p_new(1) = p_near(1) + round( ( p_rand(1) - p_near(1) ) * Delta/(min_distance+1) );  %求出扩展一个步长后的x坐标，cos*R，注意不要除以0
    p_new(2) = p_near(2) + round( ( p_rand(2) - p_near(2) ) * Delta/(min_distance+1) );  %求出扩展一个步长后的y坐标，sin*R
    %防止坐标计算到负数造成错误
    if p_new(1) < 1
       p_new(1) = 1;
    else if p_new(1) >=mapX
        p_new(1) = mapX-1;     
        end
    end
    if p_new(2) < 1
        p_new(2) = 1;
    else if p_new(2) >=mapY
        p_new(2) = mapY-1;           
        end
    end

  %检查p_new节点是否触碰到障碍物  因为是二值化图像，白色为1，黑色为0 黑色即为障碍物
  %注意p_new(1)代表的是列x，p_new(2)是行y，因此判断的时候需要写map(p_new(2),p_new(1)) 
  %而不是map(p_new(1),p_new(2))    
    if map(p_new(2),p_new(1)) == 1    %这个索引貌似还是有点问题，会超出数组，把xy轴调成一样像素之后好了
        count=count+1;
        break;
    end
  end

  %Step 4: 将p_new插入树，count仍为叶子的数量   
  Tree.v(count).x = p_new(1);         
  Tree.v(count).y = p_new(2); 
  Tree.v(count).xFather = p_near(1);    
  Tree.v(count).yFather = p_near(2);
  Tree.v(count).dist = min_distance;

  new_distance = sqrt( ( p_new(1) - end_x )^2 + ( p_new(2) - end_y )^2 );  %计算新点相对终点的距离，小于一定阈值则判定到达终点
  if new_distance <= ArriveDis
      plot(p_new(1), p_new(2), 'bo', 'MarkerSize',2, 'MarkerFaceColor','b'); % 绘制p_new
      line( [p_new(1) p_near(1)], [p_new(2) p_near(2)], 'Marker','.','LineStyle','-'); %连接p_near和p_new
      line( [end_x p_new(1)], [end_y p_new(2)], 'Marker','.','LineStyle','-'); %连接p_Target和p_new
      break;
  end
  
  %Step 6:将x_near和x_new之间的路径画出来
  plot(p_new(1), p_new(2), 'bo', 'MarkerSize',2, 'MarkerFaceColor','b'); % 绘制p_new
  line( [p_new(1) p_near(1)], [p_new(2) p_near(2)], 'Marker','.','LineStyle','-'); %连接p_near和p_new
  hold on;     %要多次在同一张图上绘制线段，所以使用plot后需要接上hold on命令
  pause(0.01); %暂停时间
end






