-- --------------- HASHTAGS ---------------------- --

CREATE TABLE hashtags (
name varchar(60) NOT NULL,
PRIMARY KEY (name)
);

INSERT INTO hashtags (name)
  VALUES
  ("#summer"),
  ("#fall"),
  ("#winter"),
  ("#spring"),
  ("#fun"),
  ("#basic"),
  ("#millenial"),
  ("#nerdystuff"),
  ("#fitspo"),
  ("#starbucks"),
  ("#healthy"),
  ("#fitness"),
  ("#vegan"),
  ("#gains"),
  ("#fashion"),
  ("#hypebeast"),
  ("#lit"),
  ("#party"),
  ("#notmypresident");

-- --------------- LOCATIONS ---------------------- --

CREATE TABLE locations (
locationID int NOT NULL AUTO_INCREMENT,
lat decimal(9,6),
lon decimal(9,6),
locationName varchar(50),
PRIMARY KEY (locationID)
);

INSERT INTO locations (lat, lon, locationName)
  VALUES
  (145.502610,-73.576435, "Bronfman Building"),
  (45.496874,-73.578037, "McConnell Building"),
  -- unemployment facility is JMSB lmao --
  (45.495508,-73.579184, "Unemployment Facility"),
  (45.496067,-73.569315, "Bell Centre"),
  (45.508873,-73.588057, "Mount Royal");

-- --------------- MEDIA FILES ------------------- --

CREATE TABLE mediaFiles (
fileID int NOT NULL AUTO_INCREMENT,
filepath varchar (60),
PRIMARY KEY (fileID)
);
-- Post contains media file, so when a post is deleted, so is the media file

INSERT INTO mediaFiles (filepath)
    VALUES
    ('instagram/media/vids/323456.mp4'),
    ('instagram/media/vids/123416.mov'),
    ('instagram/media/pics/223426.jpg'),
    ('instagram/media/pics/333453.png'),
    ('instagram/media/vids/344456.mp4'),
    ('instagram/media/vids/987643.mp4'),
    ('instagram/media/pics/100001.png'),
    ('instagram/media/pics/696969.jpg'),
    ('instagram/media/vids/968574.mp4');


-- --------------- PROFILES ------------------- --

CREATE TABLE profiles (
profileID int NOT NULL AUTO_INCREMENT,
profileName VARCHAR(60),
PRIMARY KEY (profileID)
);

INSERT INTO profiles (profileName)
    VALUES
      ("Basic"),
      ("Hipster"),
      ("Fitness Enthusiasts"),
      ("Club & Partygoers"),
      ("Social Justice Warriors"),
      ("Techies");

-- --------------- USERS ------------------- --

CREATE TABLE users (
userID int NOT NULL AUTO_INCREMENT,
userName varchar (20) NOT NULL,
password varchar (40) NOT NULL,
website varchar (30),
bio varchar(100),
email varchar (30),
phone varchar (20),
gender  varchar (8),
PRIMARY KEY (userID)
);

INSERT INTO users (userName, password, website, bio, email, phone, gender)
    VALUES
       ("darth_vader", "theforce", "kfnfkd.instagram.com", "", "", "514-123-4567", "female"),
       ("voldemort", "avadakedavra", "niflsfs.instagram.com", "hogwarts biggest threat. Hiking enthusiast.", "voldemort@mail.hogwarts.com", "", "male"),
       ("frodo", "lordrings", "", "One ring to rule them all", "myprecious@lordoftherings.com", "514-234-5678", "male"),
       ("Michael_Phelps", "swimming", "phelps.pool.com", "Just keep swimming", "mphelps@swimming.com", "514-345-6789","male"),
       ("Indiana_Jones", "hwalton", "indianajones.instagram.com", "George Lucas Fan", "indianajones@walton.com", "514-567-6899", "male");


-- --------------- POSTS ------------------- --

CREATE TABLE posts (
postID int NOT NULL AUTO_INCREMENT,
posterID int NOT NULL,
timePosted DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
locationID int DEFAULT NULL,
campaignID int DEFAULT NULL,
PRIMARY KEY (postID),
FOREIGN KEY (posterID)
  REFERENCES users(userID)
  -- when user deletes account, posts are removed
  ON DELETE CASCADE,
FOREIGN KEY (locationID)
  REFERENCES locations(locationID)
  ON DELETE SET NULL
);

INSERT INTO posts (posterID, timePosted, locationID, campaignID)
    VALUES
      (1, '2018-03-21 23:11:33', 1,  NULL),
      (1, '2018-03-15 02:03:45', 2,  3),
      (3, '2017-12-26 13:11:34', NULL, NULL),
      (4, '2018-01-01 07:34:12', 3, NULL),
      (5, '2018-02-15 15:46:22', 1, NULL );


-- --------------- ADD ONS ------------------- --

CREATE TABLE addOns (
addonID int NOT NULL AUTO_INCREMENT,
addonName VARCHAR (40) NOT NULL,
addOnsFilePath varchar(60) NOT NULL,
latAvailable decimal(9,6),
longAvailable decimal(9,6),
startDate DATETIME DEFAULT NULL,
endDate DATETIME DEFAULT NULL,
PRIMARY KEY (addonID)
);

INSERT INTO addOns (addonName, addOnsFilePath, latAvailable, longAvailable, startDate, endDate)
 VALUES
    ("Lit Filter", "instagram/media/filter/323456.png", 145.502610, -73.576435, '2018-01-15 12:11:33', '2018-02-08 15:34:55'),
    ("Taco Bell", "instagram/media/filter/123456.png", NULL, NULL, '2017-09-15 12:11:33', '2018-06-08 15:34:55'),
    ("Love", 'instagram/media/filter/223426.png', 45.496067, -73.569315, '2017-09-15 12:11:33', '2017-12-08 15:34:55'),
    ("McGill", 'instagram/media/filter/434342.png', NULL, NULL, '2018-05-15 12:11:33', '2018-12-08 15:34:55'),
    ("MTL", "instagram/media/filter/981234.png", NULL, NULL, '2017-09-15 12:11:33', '2018-06-08 15:34:55');

-- --------------- COMMENTS  ---------------------- --

CREATE TABLE comments (
commentID int NOT NULL AUTO_INCREMENT,
content varchar(255) NOT NULL,
timePosted DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
userID int NOT NULL,
postID Int NOT NULL,
replyID int DEFAULT NULL,
PRIMARY KEY (commentID),
FOREIGN KEY (userID)
REFERENCES users(userID)
ON DELETE CASCADE,
FOREIGN KEY (postID)
REFERENCES posts(postID)
ON DELETE CASCADE,
FOREIGN KEY (replyID)
REFERENCES comments(commentID)
ON DELETE SET NULL
);
-- When a user’s account is deleted, all their comments are deleted
-- When a post is deleted, all the comments are deleted
-- When a reply to a comment is deleted, the comment remains, but reply disappears

INSERT INTO comments (content, userID, postID)
  VALUES
  ("Tings", 1, 1),
  ("Lit", 2 ,1),
  ("Wow", 1, 2),
  ("So many TINGS", 5, 3),
  ("Eggplants and peaches", 4, 3);

-- Inserting replies
INSERT INTO comments (content, userID, postID, replyID)
  VALUES
    ("More tings", 3, 1, 1),
    ("More lit", 4, 1, 2),
    ("Much Wow", 5, 2, 3),
    ("So many MORE TINGS", 3, 3, 4),
    ("Tings, eggplants and peaches", 4, 3, 4);


-- --------------- TARGETS HASHTAG ---------------- --

CREATE TABLE targetsHashtag (
profileID int NOT NULL,
hashtagName VARCHAR(60) NOT NULL,
PRIMARY KEY(hashtagName, profileID),
FOREIGN KEY(hashtagName)
	REFERENCES hashtags(name)
	ON DELETE CASCADE,
FOREIGN KEY(profileID)
	REFERENCES profiles(profileID)
	ON DELETE CASCADE
);
-- Both are primary keys as well

INSERT INTO targetsHashtag (profileID, hashtagName)
   VALUES
     (1, "#starbucks"),
     (1, "#basic"),
     (1, "#summer"),
     (1, "#fall"),
     (1, "#spring"),
     (1, "#notmypresident"),
     (2, "#millenial"),
     (2, "#vegan"),
     (2, "#fashion"),
     (2, "#hypebeast"),
     (3, "#fitspo"),
     (3, "#healthy"),
     (3, "#fitness"),
     (3, "#vegan"),
     (3, "#gains"),
     (4, "#lit"),
     (4, "#party"),
     (5, "#notmypresident"),
     (6, "#nerdystuff");

-- --------------- CAMPAIGNS ------------------- --

CREATE TABLE campaigns (
campaignID int NOT NULL AUTO_INCREMENT,
name varchar (40) NOT NULL,
company varchar (40) NOT NULL,
timeStart DATETIME NOT NULL,
timeEnd DATETIME NOT NULL,
postID INT DEFAULT NULL,
PRIMARY KEY (campaignID),
FOREIGN KEY (postID)
REFERENCES posts (postID)
ON DELETE SET NULL
);
-- A post represents an ad, and when an ad is deleted, the campaign still runs

INSERT INTO campaigns (name, company, timeStart, timeEnd, postID)
    VALUES
    ("UnboxUrPhone", "Samsung", '2018-01-15 12:11:33', '2018-02-08 15:34:55', NULL),
    ("OurPhonesNoFire", "Samsung", '2017-09-15 12:11:33', '2018-06-08 15:34:55', 1),
    ("OnlyOnSwitch", "Nintendo", '2017-09-15 12:11:33', '2017-12-08 15:34:55', NULL),
    ("WeAccept", "AirBnB", '2018-05-15 12:11:33', '2018-12-08 15:34:55', NULL),
    ("BigThanks", "Amazon", '2018-05-15 12:11:33', '2018-12-08 15:34:55', NULL),
    ("Originals","Adidas", '2017-09-15 12:11:33', '2018-06-08 15:34:55', NULL);

-- Adding campaignID foreign key constraint to posts TABLE

ALTER TABLE posts
ADD FOREIGN KEY (campaignID) REFERENCES campaigns(campaignID);

-- --------------- TARGETS PROFILES ---------------- --

CREATE TABLE targetsProfiles (
profileID int NOT NULL,
campaignID int NOT NULL,
PRIMARY KEY (profileID, campaignID),
FOREIGN KEY(profileID)
	REFERENCES profiles(profileID)
	ON DELETE CASCADE,
FOREIGN KEY(campaignID)
	REFERENCES campaigns(campaignID)
	ON DELETE CASCADE
);

INSERT INTO targetsProfiles (profileID, campaignID)
  VALUES
    (1, 1),
    (1, 6),
    (2, 6),
    (3, 1),
    (4, 6),
    (4, 1),
    (5, 4),
    (5, 2),
    (5, 3);

-- Both are primary keys as well

-- --------------- CONTAINS MEDIA ------------------- --
/* because posts can consist of albums which contain
multiple media files */

CREATE TABLE containsMedia (
postID int NOT NULL,
mediaID int NOT NULL,
PRIMARY KEY (postID, mediaID),
FOREIGN KEY (postID)
REFERENCES posts(postID)
ON DELETE CASCADE,
FOREIGN KEY (mediaID)
REFERENCES mediaFiles(fileID)
ON DELETE CASCADE
);

INSERT INTO containsMedia (postID, mediaID)
    VALUES
        (1, 1),
        (1, 2),
        (1, 3),
        (2, 4),
        (3, 5),
        (4, 6),
        (4, 7),
        (5, 8),
        (5, 9);

 -- --------------- CONTAIN HASHTAGS  ---------------- --

CREATE TABLE containsHashtag(
postID int NOT NULL,
hashtagName VARCHAR(60) NOT NULL,
PRIMARY KEY(hashtagName, postID),
FOREIGN KEY(hashtagName)
  REFERENCES hashtags(name)
  ON DELETE CASCADE,
FOREIGN KEY(postID)
  REFERENCES posts(postID)
  ON DELETE CASCADE
);

-- You need a hashtag for a post to contain a hashtag and vice versa

INSERT INTO containsHashtag (postID, hashtagName)
 VALUES
    (1, "#summer"),
    (1, "#basic"),
    (1, "#millenial"),
    (1, "#fitspo"),
    (1, "#fitness"),
    -- assume postID 2 has no hashtags
    (3, "#gains"),
    (3, "#vegan"),
    (3, "#healthy"),
    (4, "#party"),
    (4, "#lit"),
    (5, "#hypebeast"),
    (5, "#fashion");

-- --------------- IS TAGGED IN ------------------- --

-- 1080 by 1080 pixels for instagram post

CREATE TABLE isTaggedin (
xPosition int(4) NOT NULL
  CHECK (xPosition > 0 AND yPosition <= 1080),
yPosition int(4) NOT NULL
  CHECK (xPosition > 0 and yPosition <= 1080),
userID int NOT NULL,
postID int NOT NULL,
PRIMARY KEY (xPosition, yPosition, postID, userID),
FOREIGN KEY (postID)
  REFERENCES posts(postID)
  ON DELETE CASCADE,
FOREIGN KEY (userID)
  REFERENCES users(userID)
  ON DELETE CASCADE
);
-- When a post is deleted, there is not more media to be tagged in
-- When a user is deleted, there is nothing to be tagged as you have to tag a user

INSERT INTO isTaggedin (xPosition, yPosition, userID, postID)
      VALUES
         (720, 1080, 1 ,2),
         (100, 250, 5 ,2),
         (100, 300, 3 ,2),
         (500, 1000, 1 ,3),
         (50, 75, 4, 3),
         (20, 1003, 5, 4),
         (913, 1, 1, 5),
         (333, 333, 1, 5),
         (700, 100, 4, 5);

-- --------------- LIKES POST ------------------- --

CREATE TABLE likesPost(
userID int NOT NULL,
postID int NOT NULL,
timeLiked DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY(userID, postID),
FOREIGN KEY(userID)
  REFERENCES users(userID)
  ON DELETE CASCADE,
FOREIGN KEY(postID)
  REFERENCES posts(postID)
  ON DELETE CASCADE
);
-- You need a user to like a post, and a post for a post to be liked

INSERT INTO likesPost (userID, postID)
    VALUES
        (1, 2),
        (1, 5),
        (1, 3),
        (1, 4),
        (2, 5),
        (4, 2),
        (4, 4),
        (3, 5),
        (4, 3);

-- --------------- SAVES POST ------------------- --

CREATE TABLE savesPost(
userID int NOT NULL,
postID int NOT NULL,
timeSaved DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY(userID, postID),
FOREIGN KEY(userID)
  REFERENCES users(userID)
  ON DELETE CASCADE,
FOREIGN KEY(postID)
  REFERENCES posts(postID)
  ON DELETE CASCADE
);
-- You need a user to save a post, and a post for a post to be saved

INSERT INTO savesPost (userID, postID)
     VALUES
         (1, 1),
         (2, 1),
         (2, 3),
         (4, 4),
         (5, 5);

-- --------------- PROFILED AS ------------------- --

CREATE TABLE profiledAs(
userID int NOT NULL,
profileID int NOT NULL,
PRIMARY KEY(userID, profileID),
  FOREIGN KEY(userID)
  REFERENCES users(userID)
ON DELETE CASCADE,
FOREIGN KEY(profileID)
  REFERENCES profiles(profileID)
  ON DELETE CASCADE
);
-- You need a user to be profiled, and a profile to profile a user

INSERT INTO profiledAs (userID, profileID)
  VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (2, 2),
    (4, 4),
    (5, 1);


-- --------------- USER FOLLOWS ---------------- --

CREATE TABLE userFollows (
userID int NOT NULL,
followingID int NOT NULL,
PRIMARY KEY (userID, followingID),
FOREIGN KEY (userID)
  REFERENCES users(userID)
  ON DELETE CASCADE,
FOREIGN KEY (followingID)
  REFERENCES users(userID)
  ON DELETE CASCADE
);
-- You need a user to follow another user

INSERT INTO userFollows (userID, followingID)
  VALUES
    (1,2),
    (1,3),
    (1,4),
    (1,5),
    (3,2),
    (3,4),
    (4,2),
    (5,4),
    (5,2);

-- --------------- STORIES ---------------- --

CREATE TABLE stories (
storyID int NOT NULL AUTO_INCREMENT,
userID int NOT NULL,
timePosted DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
latPosted decimal(9,6) DEFAULT NULL,
lonPosted decimal(9,6) DEFAULT NULL,
addonID int DEFAULT NULL,
pollID int DEFAULT NULL,
PRIMARY KEY (storyID),
FOREIGN KEY (userID)
  REFERENCES users(userID)
  ON DELETE CASCADE,
FOREIGN KEY (addonID)
  REFERENCES addOns(addonID)
  ON DELETE SET NULL
);

-- Assume the database stores expired stories (>24hrs)

INSERT INTO stories (userID, timePosted, latPosted, lonPosted, addonID, pollID)
  VALUES
    (2, '2018-01-15 12:11:33', NULL, NULL, 1, NULL),
    (2, '2018-02-28 01:11:33', NULL, NULL, NULL, 1),
    (2, CURRENT_TIMESTAMP, 145.502610, -73.576435, 3, 2),
    (3, '2018-01-15 04:11:33', NULL, NULL, 4, 3),
    (3, '2018-03-15 12:11:33', 145.502610, -73.576435, NULL, 4),
    (3, CURRENT_TIMESTAMP, 45.496067, -73.569315, 3, 5),
    (4, '2018-02-01 22:11:33',145.502610,-73.576435, NULL, NULL ),
    (4, '2018-02-15 14:11:33', 145.502610,-73.576435, 2, NULL),
    (5,CURRENT_TIMESTAMP, NULL, NULL, NULL, NULL);

-- --------------- POLLS ---------------- --
-- assume max two options
-- using bit to represent bool (1,0,NULL)

CREATE TABLE polls (
pollID int NOT NULL AUTO_INCREMENT,
question VARCHAR (40),
option1Text VARCHAR (20),
option2Text VARCHAR (20),
option1Value bit DEFAULT 1,
option2Value bit DEFAULT 0,
PRIMARY KEY (pollID)
);

INSERT INTO polls (question, option1Text, option2Text)
  VALUES
    ("Who badder?", "Danny", "Perron"),
    ("How many Animesh?", "Animesh^1", "Animesh^2"),
    ("Will I graduate?", "Yes", "No"),
    ("Am I basic?", "Hell Yes", "Naw bebe"),
    ("Are we getting lit tonight?", "Litty City", "Study man");

-- --------------- VOTES ON ---------------- --

-- each user can only particpate ONCE in each poll

CREATE TABLE votesOn (
userID int NOT NULL,
pollID int NOT NULL,
vote bit NOT NULL,
PRIMARY KEY (userID, pollID),
FOREIGN KEY (userID)
  REFERENCES users(userID)
  ON DELETE CASCADE,
FOREIGN KEY (pollID)
  REFERENCES polls(pollID)
  ON DELETE CASCADE
);

INSERT INTO votesOn (userID, pollID, vote)
  VALUES
    (2, 1, 0),
    (3, 1, 0),
    (4, 1, 0),
    (5, 1, 1),
    (2, 2, 0),
    (3, 2, 0),
    (4, 2, 1),
    (3, 3, 0),
    (4, 3, 1),
    (5, 4, 0);

-- --------------- CONVERSATIONS ---------------- --

-- assuming many users can be a part of many conversations (including groups >2)

CREATE TABLE conversations (
convID int NOT NULL AUTO_INCREMENT,
groupName VARCHAR(20) DEFAULT NULL,
user1 int NOT NULL,
user2 int NOT NULL,
user3 int DEFAULT NULL,
user4 int DEFAULT NULL,
PRIMARY KEY (convID),
-- when user deletes their profile, their convos are removed
FOREIGN KEY (user1)
  REFERENCES users(userID)
  ON DELETE CASCADE,
FOREIGN KEY (user2)
  REFERENCES users(userID)
  ON DELETE CASCADE,
FOREIGN KEY (user3)
  REFERENCES users(userID)
  ON DELETE CASCADE,
FOREIGN KEY (user4)
  REFERENCES users(userID)
  ON DELETE CASCADE
);

INSERT INTO conversations (groupName, user1, user2, user3, user4)
  VALUES
    (NULL, 1, 2, NULL, NULL),
    (NULL, 2, 3, NULL, NULL),
    ("Ciroc Boyz", 1, 2, 3, NULL),
    ("Meme Gods", 1, 2, 3, 4),
    (NULL, 3, 4, NULL, NULL),
    (NULL, 4, 1, NULL ,NULL);

-- --------------- MESSAGES ---------------- --

-- MESSAGES include convID, senderID (userID), optional post ID, optional story ID--

CREATE TABLE messages (
messageID INT NOT NULL AUTO_INCREMENT,
convID INT NOT NULL,
senderID INT NOT NULL,
content VARCHAR(500) NOT NULL,
-- can send posts through messages
postID INT DEFAULT NULL,
-- can send stories through messages
storyID INT DEFAULT NULL,
timeSent DATETIME DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (messageID),
FOREIGN KEY (convID)
  REFERENCES conversations(convID)
  ON DELETE CASCADE,
FOREIGN KEY (senderID)
  REFERENCES users(userID)
  ON DELETE CASCADE,
-- when post is deleted, in convo will show up as null
FOREIGN KEY (postID)
  REFERENCES posts(postID)
  ON DELETE SET NULL,
-- when story is deleted, in convo will show up as null
FOREIGN KEY (storyID)
  REFERENCES stories(storyID)
  ON DELETE SET NULL
);

INSERT INTO messages (senderID, convID, content, postID, storyID, timeSent)
  VALUES

    (1, 1, "wow this ting eh", 1, NULL, '2018-01-15 03:11:33'),
    (2, 1, "ehhhhhhh issa ting eh fam!!", NULL, NULL, '2018-01-15 04:11:33'),
    (1, 1, "ya issa baddie ahlie lit 1hunnid", NULL, NULL, '2018-01-15 05:11:33'),
    (1, 2, "yo peep my story", NULL, 1, CURRENT_TIMESTAMP),
    (1, 3, "SAFTB!!!", NULL, NULL, '2018-03-17 12:11:33'),
    (1, 3, "whaddup squad", NULL, NULL, '2018-03-17 13:11:33'),
    (2, 3, "whole squad turnt AF", NULL, NULL, '2018-03-17 13:15:33'),
    (3, 3, "anyone down to lift", 2, NULL, '2018-03-17 14:07:33'),
    (2, 3, "ya already there peep my ting", NULL, NULL, '2018-03-17 14:29:33'),
    (3, 3, "FERDA", NULL, NULL, '2018-03-17 18:07:33'),
    (1, 4, "Yo check this meme lol", 3, NULL, '2018-03-20 18:07:33'),
    (2, 4, "roflcopter", NULL, NULL, '2018-03-20 20:07:33'),
    (3, 4, "Je pense this is better", 4, NULL, '2018-03-20 23:07:33'),
    (4, 4, "Vader this is u on friday night", 5, NULL, '2018-03-20 23:21:33'),
    (2, 4, "yall stfu I'm tryna study", NULL, NULL, '2018-03-20 23:33:33'),
    (3, 5, "wassup shawty", NULL, NULL,'2018-01-15 03:11:33'),
    (4, 5, "get out of my DMs", NULL, NULL, CURRENT_TIMESTAMP),
    (4, 6, "yo", NULL, NULL, '2018-03-17 18:07:33'),
    (4, 6, "buy my mixtape", NULL, NULL, '2018-03-20 18:07:33'),
    (1, 6, "naw", NULL, NULL, CURRENT_TIMESTAMP);
