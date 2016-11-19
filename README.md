# Project: Words 4 Music

### [Project Description](doc/Project4_desc.md)

![image](http://cdn.newsapi.com.au/image/v1/f7131c018870330120dbe4b73bb7695c?width=650)

Term: Fall 2016

+ [Data link](https://courseworks2.columbia.edu/courses/11849/files/folder/Project_Files?preview=763391)-(**courseworks login required**)
+ [Data description](doc/readme.html)
+ Contributor's name: Hayoung Kim
+ Project title: Words for music
+ Project summary: 

	- Objective: To predict (recommend) lyrics words using music features from a set of 2350 songs
	- Method: Item-to-Item collaborate filtering 
		(Reference: ‘Recommendation based on similarities’, github teaching material) 

	- Steps
		1. Extracted 46 features from 15 basic features based on logical reasoning
		2. Divided dataset into 2 parts for testing (30%)
		3. Generated distance matrix that represents ‘cosine distance’ between features in each set
		4. Picked most similar N music for each test song based on the distance matrix above (tried several N’s here)
		5. Took weighted means of N songs to predict the counts of 5000 words for each test song
		6. Ranked the count data of each test song
		7. Chose N=30 as a compromise 
		(As N increases, average predictive rank sum (evaluation criterion) becomes smaller, while variance increases)
		8. Generated recommendations for 100 test songs with the same algorithm & N=30
	
Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
