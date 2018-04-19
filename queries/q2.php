<!DOCTYPE html>
<html>
  <head>
    <title>Instagram</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <link href="https://fonts.googleapis.com/css?family=Raleway" rel="stylesheet" type="text/css">
    <style>
        body {
          font-family: "Raleway", Arial, sans-serif;
        }
        .feedBlock{
          margin: auto;
          width: 540px;
          height: 80px;
          border: 2px solid;
          border-color: #e6e6e6;
          background-color: white;
        }
        .feedUser {
          padding: 15px;
          font-size: large;
          color: #262626;
          font-weight: 900;
          text-transform: lowercase;
          float: left;
        }
        .feedTime {
          color: #999999;
          font-size: large;
          font-weight: 400;
          text-transform: lowercase;
          float: right;
        }
        .feedPicture {
          margin: auto;
          width: 540px;
          padding: 0px;

        }

        #feed {
          padding-top: 150px;
          padding-right: 80px;
          padding-bottom: 50px;
          padding-left: 80px;
        }

    </style>
  </head>
  <body bgcolor="#fafafa">
    <!-- !PAGE CONTENT! -->
    <div style = "max-width:1500px; padding:0px;">
      <!-- Header -->
      <header class = "w3-container w3-xlarge w3-white" style = "height: 65px; width: 100%; position: fixed; border-bottom: 2px solid; border-bottom-color: #e6e6e6; padding-top: 5px;">
        <a href='http://localhost:8888/index.php' class="w3-left w3-button w3-white">
          <img src="http://localhost:8888/instagram_logo.png" style="width:190px;height:36px;">
        </a>
        <a href="http://localhost:8888/play.html" class="w3-right w3-button w3-white" style='font-size:24px; padding-right:30px;'>Play</a>
    </div>

    <div id="feed">
      <?php
      // Displaying all the posts in the app as a newsfeed

      $user     = 'root';
      $password = 'root';
      $db       = 'instagram_schema';
      $host     = 'localhost';
      $port     = 3306;

      $conn = mysqli_connect($host, $user, $password, $db, $port);

      // query for the data
      $sql      = 'SELECT u.userName, m.content, m.storyID, m.postID, m.timeSent FROM users u, messages m, conversations c WHERE u.userID = m.senderID AND m.convID = c.convID AND c.convID IN (SELECT convID from conversations where user1 IN
        (SELECT userID FROM users WHERE userName = "darth_vader" OR userName = "voldemort")
        AND user2 IN
        (SELECT userID FROM users WHERE userName = "darth_vader" OR userName = "voldemort")
        AND user3 IS NULL
        AND user4 IS NULL
      )';
      $res      = mysqli_query($conn, $sql);


      if ($res) {
        while ($newArray=mysqli_fetch_array($res,MYSQLI_ASSOC))
          {
            echo "<div class = 'feedBlock'>
                    <div class = 'feedUser'>".$newArray['userName']."
                    </div>
                    <div>".$newArray['content']."
                    </div>
                    <div>".$newArray['storyID']."
                    </div>
                    <div>".$newArray['postID']."
                    </div>
                    <div class = 'feedTime'>".$newArray['timeSent']."
                    </div>
                  </div>";
            }
          }
      else {
        echo "query failed";
      }

      mysqli_close($conn);

      ?>
  </div>



  </body>
</html>
