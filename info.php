<?php
$con = mysqli_connect("10.0.1.10", "root", "root");
if (!$con)
{
  die('Could not connect: ' . mysqli_error());
}

$result = mysqli_query($con,"SHOW FULL PROCESSLIST");
printf("<table border='1'>\n");
printf("<tr><th>Id</th><th>Host</th><th>db</th> <th>Command</th><th>Time</th></tr>\n");
while ($row=mysqli_fetch_array($result)) {
  //$process_id=$row["Id"];
  //if ($row["Time"] > 200 ) {
    //$sql="KILL $process_id";
    //mysql_query($con,$sql);
  //}
    printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td> %s</td></tr>\n", $row["Id"], $row["Host"], $row["db"],$row["Command"], $row["Time"]);
}
printf("</table>\n");

mysqli_close($con);
?>
