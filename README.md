# Project: Association mining of music and text

### [Project Description](doc/Project4_desc.md)

![image](http://cdn.newsapi.com.au/image/v1/f7131c018870330120dbe4b73bb7695c?width=650)

+ Term: Fall 2016
+ Contributor's name: Shuli Song <ss4962@columbia.edu>
+ Project Summary: This project explored the association between music features and lyrics words from a subset of songs in the [million song data](http://labrosa.ee.columbia.edu/millionsong/). A **lyric words recommender algorithms** is created for a piece of music (using its music features).

### Data Source:
 [A set of 2350 songs from the million song data project](https://courseworks2.columbia.edu/courses/11849/files/folder/Project_Files?preview=763391)-[**coursework login required**]. This is a hacking challenge where the organizer is interested in exploring a collection of creative lyrics recommender methods that the participating data scientists can come with. The participants are encouraged to discuss online and exchange ideas. 

The data set released contain:
+ `Common_id.txt`: ids for the songs that have both lyrics and sound analysis information. 2350 in total;
+ `lyr.Rdata`: dim: 2350*5001. [bag-of-words](https://en.wikipedia.org/wiki/Bag-of-words_model) for 2350 songs stored in an `R` dataframe;
+ `data.zip`: [h5](https://en.wikipedia.org/wiki/Hierarchical_Data_Format) format music feature files for the 2350 songs;
+ `msm_dataset_train.txt` original text of the lyrics data. (Potentially can be used for [n-gram](https://en.wikipedia.org/wiki/N-gram) models).

### Process Flow

+ 1. Use [Topic modeling](https://cran.r-project.org/web/packages/topicmodels/vignettes/topicmodels.pdf) to determine 10 topics.
+ 2. For music features, I followed the instruction on [Echo Nest analyze documentation](http://developer.echonest.com/docs/v4/_static/AnalyzeDocumentation_2.2.pdf) and chose the main audio features, which are [**'segments_pitches'**] and [**'segments_timbre'**].
+ 3. The dimensions of segments depended on the acutal length of the song and thus differe across different songs. To deal with this problem, I limited the songs to a certain number of segments. More specifically, I limited it to a matrix of 12*500, where songs longer than that can be trimmed and those shorter than that got appended (like for a song with length 480 you repeat the first 20 beats). 
+ 4. Used [**ridge regression**] and [**cross-validation**] to fit the best model to build a connection between music features and topics. 
+ 5. Do prediction on the [test data](https://courseworks2.columbia.edu/courses/11849/files/800763/download?wrap=1) -[**coursework login required**] which contains music features (only the "analysis" part) of 100 songs and produce a ranking (with the most likely being the first) of candidate lyric words from the given dictionary of 5000 words.

### R Version
Not very version sensitive, just use some new version.

### Packages
This algorithm uses packages:

+ library(rhdf5)
+ library(topicmodels)
+ library(glmnet)
+ library(MASS)
