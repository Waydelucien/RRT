1 参考文档  
1.1  
https://zhuanlan.zhihu.com/p/474945524  
参考了绝大部分。  
1.2  
https://blog.csdn.net/qq_34213260/article/details/106226929?ops_request_misc=&request_id=&biz_id=102&utm_term=rrt%E7%AE%97%E6%B3%95%E8%B7%AF%E5%BE%84%E8%A7%84%E5%88%92matlab&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-0-106226929.nonecase&spm=1018.2226.3001.4187  
参考了循环部分。  
  
2 存在问题及改进  
2.1   
问题：参考文档1.1中写的for...continue语句有问题，整体逻辑不清晰。  
改进方法：重写循环！两层循环：内层循环可以返回一个满足要求的p_new，外层循环找到所有p_new，并绘制路线。  
2.2  
问题：参考文档1.1中，当p_rand和p_new重合时，min_distance为0，被除数为零，计算得到的p_new为NaN。  
改进方法：在公式中min_distance后面+1。  
2.3  
问题：参考文档1.1中map索引出错  
改进方法：把自制的地图x和y轴大小调整成一样的了，能跑通，不过根本问题没有解决。  
