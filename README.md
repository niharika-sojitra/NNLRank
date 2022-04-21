# NNLRank
**ABSTRACT**
Open-source platforms have changed the way technology has developed in the past few decades. They allow developers to engage globally and find several projects to gain ex- pertise and become skilled in their respected fields. Open-source platforms like GitHub help to maintain a thriving developing world by cre- ating a bridge between developers and employ- ers. However, it becomes difficult for devel- opers to find suitable projects for themselves which often leads to failure in project comple- tion. This slows down the progress of open- source platforms and fails to highlight the capa- bilities of developers. We propose a learning-to- rank model, neural network for list-wise rank- ing (NNLRank), to select projects to which developers are likely to contribute, in order to reduce developers’ difficulties in onboarding projects. NNLRank recommends projects for onboarding based on project characteristics and developer experience. We devise a method for optimising the neural network that uses a list- wise loss function to minimise the difference between the forecast projects list and the devel- opers’ chosen ground-truth list. We are replicating the study (Liu et al., 2018)[10] in guidance of Dr. Muhammad Asaduzzaman.
**NNLRANK**
We create a list-wise ranking model called NNL- Rank to recommend acceptable projects for a developer to join. NNLRank uses a neural network as a ranking function, which can simultaneously process a list of potential projects. It forecasts the preference scores for projects that developers would like to onboard using 16 features derived from projects and developer profile information as input. As onboarding decisions plays major role in this project, we have taken this feature as our output of model, which gives if the user boarded a particular project or not. The neural network structure, loss function, and network optimization strategy of NNLRank, on the other hand, have an impact on its performance.

**INPUT FEATURES**
1. Technical Ability 
2. Project Growth 
3. User Profile 
4. Project Time 
5.Project members 
6.Project Size 
7. Open Issues per developer 
8.Forks 
9.Network_Count 
10. Watchers 
11. Tags 
12. Star Count 
13. Star Developer 

**OUTPUT FEATURE**
Sucessful Onboarding


REFERENCES
[1]Shivani Agarwal. Ranking methods in machine learn- ing.
[2]Prof Ted Briscoe and Dr Stephen Clark. 2015. Learning to rank.
[3]Jason Brownlee. 2020. Multi-label classification with deep learning.
[4]Christopher J.C. Burges. 2010. From ranknet to lamb- darank to lambdamart: An overview. Microsoft Re- search Technical Report MSR-TR.
[5]Casey Casalnuovo, Bogdan Vasilescu, Prem Devanbu, and Vladimir Filkov. 2015. Developer onboarding in github: the role of prior social links and language experience. Proceedings of the 2015 10th Joint Meet- ing on Foundations of Software Engineering. ACM, page 817–828.
[6]Eirini Kalliamvakou, Georgios Gousios, Kelly Blincoe, Leif Singer, Daniel M. German, and Daniela Damian. 2015. The promises and perils of mining github. Pro- ceedings of the 11th working conference on mining software repositories. ACM, page 92–101.
Alexandros Karatzoglou, Linas Baltrunas, and Yue Shi. 2013. Learning to rank for information retrieval. Proceedings of the 7th ACM Conference on Recom- mender Systems, pages 493–494.
[7]TensorFlow Keras. Recommending movies: retrieval.  
[8]Scikit learn Developers. Scikit learn : Supervised learning.
[9]Xuanhui Wangnand Cheng Li, Nadav Golbandi, Michael Bendersky, and Marc Najork. 2018. The lambdaloss framework for ranking metric optimiza- tion. CIKM ’18: Proceedings of the 27th ACM Inter- national Conference on Information and Knowledge Management, page 1313–1322.
[10]Chao Liu, Dan Yang, Xiaohong Zhang, Baishakhi Ray, and Md Masudur Rahman. 2018. Recommending github projects for developer onboarding. IEEE Ac- cess, 6:52082–52094.
[11]Tie-Yan. Liu. 2009. Learning to Rank for Information Retrieval, volume 3.
[12]Tadej Matek and Svit Timej Zebec. 2016. Github open source project recommendation system. CoRR, abs/1602.02594.
[13]ShyamSundar Rajaram, Ashutosh Garg, and Xiang Zhou. 2003. Classification approach towards ranking and sorting problems. volume 2837, pages 301–312.
[14]Gregorio Robles and Jesus M. Gonzalez-Barahona. 2006. Contributor turnover in libre software projects. IFIP International Conference on Open Source Sys- tems, page 273–286.
[15]Xiaobing SU, Wenyuan XU, Xin XIA, Xiang CHEN, and Bin LI. 2018. Personalized project recommenda- tion on github. Science China Information Sciences, 61(5):1–14.
[16]Taylor, J. Guiver, S. Robertson, and T. Minka. 2008. Softrank: optimizing non-smooth rank metrics. Pro- ceedings of the 2008 International Conference on Web Search and Data Mining, page 77–86.
[17]Y.and Xie B. Zhang, Zou and Z. Zhu. 2014. Recommending relevant projects via user behaviour: an exploratory study on github. Proceedings of the 1st International Workshop on Crowd-Based Soft- ware Development Methods and Technologies, page 25–30.
[18]Tie-Yan Liu Ming-Feng Tsai Hang Li Zhe Cao, Tao Qin. 2007. Learning to rank: From pairwise approach to listwise approach. Proceedings of the 24th interna- tional conference on Machine learning(ICML), page 129–136.
