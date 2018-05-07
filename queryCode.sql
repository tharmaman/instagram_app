-- Find below 25 example queries
-- Each query seeks to demonstrate a particular business use case for Instagram
-- Either as a user, or for Instagram's internal analytics


-- 1. Display all the posts (SELECT filepath) taken at Bronfman Building by users
SELECT u.userName, cm.postID ,mf.filepath
FROM mediaFiles mf, containsMedia cm, posts p, users u
WHERE mf.fileID = cm.mediaID
AND cm.postID = p.postID
AND p.posterID = u.userID
AND mf.fileID IN
  (SELECT cm.mediaID FROM containsMedia cm WHERE cm.postID IN
    (SELECT p.postID FROM posts p, locations l WHERE p.locationID = l.locationID AND l.locationName = "Bronfman Building"
    )
  );

-- 2. Select all messages that were in a direct conversation between ONLY darth_vader and voldemort (between ONLY user 1 and 2), show if they sent a post or story along with the message
SELECT u.userName, m.content, m.storyID, m.postID, m.timeSent FROM users u, messages m, conversations c WHERE u.userID = m.senderID AND m.convID = c.convID AND c.convID IN (SELECT convID from conversations where user1 IN
  (SELECT userID FROM users WHERE userName = "darth_vader" OR userName = "voldemort")
  AND user2 IN
  (SELECT userID FROM users WHERE userName = "darth_vader" OR userName = "voldemort")
  AND user3 IS NULL
  AND user4 IS NULL
);

-- 3. Count the number of videos (identified by a .mov and .mp4 extension on filepath) on Instagram
SELECT COUNT(fileID) AS numVideoFiles
FROM mediaFiles
WHERE filePath LIKE "%.mov"
OR filePath LIKE "%.mp4";

-- 4. Display the transcript of the most active group conversation (again identify if a post or story was sent with the message or not)
SELECT u.userName, m.content, m.storyID, m.postID, m.timeSent FROM users u, messages m, conversations c WHERE u.userID = m.senderID AND m.convID = c.convID AND c.convID =
  (
    SELECT convID FROM
    (
      SELECT convID, activity FROM

      (
        SELECT convID, (COUNT(*)) as activity FROM messages GROUP BY convID

      ) AS maxCount

      GROUP BY convID

      HAVING activity =

          (
            SELECT MAX(activity) FROM
            (
              SELECT convID, (COUNT(*)) as activity FROM messages GROUP BY convID

            ) AS maxCount2
          )

    ) AS finalMax
  )
ORDER BY m.timeSent ASC;

-- 5. Select the userNames of inactive users AKA no likes

SELECT userName
FROM
  (
    SELECT u.userName, u.userID, COUNT(lp.userID) as numberLikes FROM users u LEFT JOIN likesPost lp ON u.userID = lp.userID GROUP BY userID HAVING numberLikes = 0
  ) as inactiveUsernames;

-- 6. Select all posts with a certain hashtag (#summer)
-- -- Note: There are three results because the post is of type "Album" (has more than one mediaFile attached to it meaning that users can scroll through the media files)

SELECT m.filePath
FROM mediaFiles as m, containsHashtag as ch, posts AS p, containsMedia as cm, hashtags AS h
WHERE ch.hashtagName = "#summer"
ANd h.name = ch.hashtagName
AND ch.postID = p.postID
AND p.postID = cm.postID
AND cm.mediaID = m.fileID;

-- 7. Show all posts where two specific users are tagged in
SELECT postID
FROM isTaggedin AS iti
WHERE postID IN
  (SELECT iti.postID FROM isTaggedin AS iti WHERE iti.userID = 3)
AND postID IN
  (SELECT iti.postID FROM isTaggedin AS iti WHERE iti.userID = 5)
GROUP BY postID;

-- 8. Select all users tagged in a certain post  (based on post ID = 4)
SELECT users.userName
FROM users, isTaggedin
WHERE users.userID=isTaggedin.userID
AND isTaggedin.postID=4;

-- 9. Select all posts with no hashtags
SELECT DISTINCT postID
FROM posts
WHERE postID NOT IN
  (SELECT DISTINCT posts.postID
  FROM posts, containsHashtag
  WHERE posts.postID=containsHashtag.postID);

-- 10. Select all sponsored posts
SELECT postID FROM posts WHERE campaignID IS NOT NULL;

-- 11. Select the companies with more than one campaign
SELECT campaigns.company, posts.campaignID
FROM campaigns, posts
WHERE campaigns.campaignID=posts.campaignID
GROUP BY campaignID HAVING COUNT(posts.campaignID)>1;

-- 12. Most active poll
SELECT pollID,
COUNT(userID) as timesVoted
FROM votesOn
GROUP BY pollID ORDER BY timesVoted DESC LIMIT 1;


-- 13. Select all stories which are more than 24h old
-- -- Note: uses the TIMESTAMPDIFF() function to work the difference between both Current_Timestamp and timePOsted
SELECT storyID
FROM stories
WHERE TIMESTAMPDIFF(HOUR, timePosted, CURRENT_TIMESTAMP) > 24;

-- 14. Select all the posts created in the last 30 minutes
SELECT postID
FROM posts
WHERE TIMESTAMPDIFF(MINUTE, timePosted, CURRENT_TIMESTAMP) <= 30;

-- 15. Select the average number of followers per user
SELECT AVG(f.followers)
FROM
(
  SELECT followingID, COUNT(userID) AS followers
  FROM userFollows
  GROUP BY followingID
) AS f;

-- 16. Select all polls in which a specific user voted in
SELECT pollID FROM votesOn WHERE userID=3;

-- 17. Select the user with the most followers
SELECT followingID, count(followingID) as totalfollowers
FROM userFollows
GROUP BY followingID
ORDER BY totalfollowers DESC LIMIT 1;

-- 18. Select companies with multiple campaigns
SELECT campaigns.company, posts.campaignID
FROM campaigns, posts
WHERE campaigns.campaignID=posts.campaignID
GROUP BY campaignID
HAVING COUNT(posts.campaignID)>1;

-- 19. Select all users who haven't saved anything
SELECT userName
FROM users where userName NOT IN
  (SELECT DISTINCT users.userName
  FROM users, posts
  WHERE users.userID=posts.posterID);

-- 20. Select the most used filter
SELECT addonID, COUNT(storyID) as timesUsed
FROM stories
WHERE addonID IS NOT NULL
GROUP BY addonID
ORDER BY timesUsed DESC LIMIT 1;

-- 21.Find Percentage of female users
SELECT
(SELECT count(userID) FROM users WHERE gender = "female")
/
(SELECT count(*) FROM users) AS femaleProportion;

-- 22. Select all comments made by a specific user
SELECT userID, commentID, content
FROM comments
WHERE userID=1;

-- 23. Select the last message for each user
SELECT senderID, MAX(timeSent) AS latestMessage
FROM messages
GROUP BY senderID;

-- 24. Select all male users (and corresponding post) who like a post containing a particular hashtag

 SELECT u.userID, p.postID
 FROM users AS u, likesPost AS l, posts AS p
 WHERE u.gender = "male"
 AND l.userID = u.userID
 AND l.postID = p.postID
 AND p.postID IN (SELECT ch.postID
                  FROM containsHashtag AS ch, hashtags AS h
                  WHERE h.name = "#vegan"
                  AND ch.hashtagName = h.name);

-- 25. Select all users tagged in any post taken at a particular location and calculates how many times they were tagged at that one location

SELECT u.userID, COUNT(u.userID) AS timesTaggedAtLocation
FROM users AS u, isTaggedin AS iti, posts AS p
WHERE u.userID = iti.userID
AND iti.postID = p.postID
AND p.postID IN
  (SELECT p.postID
     FROM  posts AS p, locations as l
     WHERE p.locationID = l.locationID
     AND l.locationName= "Bronfman Building")
GROUP BY u.userID;
