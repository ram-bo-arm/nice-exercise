<?php

function execute($cmd, $stdin=null, &$stdout, &$stderr, $timeout=false)
{
    $pipes = array();
    $process = proc_open(
        $cmd,
        array(array('pipe','r'),array('pipe','w'),array('pipe','w')),
        $pipes
    );
    $start = time();
    $stdout = '';
    $stderr = '';

    if(is_resource($process))
    {
        stream_set_blocking($pipes[0], 0);
        stream_set_blocking($pipes[1], 0);
        stream_set_blocking($pipes[2], 0);
        fwrite($pipes[0], $stdin);
        fclose($pipes[0]);
    }

    while(is_resource($process))
    {
        //echo ".";
        $stdout .= stream_get_contents($pipes[1]);
        $stderr .= stream_get_contents($pipes[2]);

        if($timeout !== false && time() - $start > $timeout)
        {
            proc_terminate($process, 9);
            return 1;
        }

        $status = proc_get_status($process);
        if(!$status['running'])
        {
            fclose($pipes[1]);
            fclose($pipes[2]);
            proc_close($process);
            return $status['exitcode'];
        }

        usleep(100000);
    }

    return 1;
}

$con = mysqli_connect("10.0.1.10", "web", "web_pass");
if (!$con)
{
  die('Could not connect: ' . mysqli_error());
}

$result = mysqli_query($con,"SHOW FULL PROCESSLIST");

echo "<big><big><b><font color='blue' face='Courier New'>show full processlist</b></big></big>";

echo "<br/>";
echo "<br/>";


printf("<table border='1' >\n");
printf("<tr><th>Id</th><th>Host</th><th>db</th> <th>Command</th><th>Time</th></tr>\n");
while ($row=mysqli_fetch_array($result)) {
    printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td> %s</td></tr>\n", $row["Id"], $row["Host"], $row["db"],$row["Command"], $row["Time"]);
}
printf("</table>\n");

mysqli_close($con);


echo "<br/>";
echo "<br/>";


echo "<big><big><b><font color='blue'>traceroute  wix.com</big></big>";
echo "<br/>";
echo "<br/>";

//$command="sudo traceroute -I wix.com |  grep -v 'traceroute to'| awk '{printf \"%-3s %-50s %-20s %-10s %-10s %-10s\\n\", $1,$2,$3,$4,$6,$8}'";
echo "<table border='1' >";
$command="sudo -S traceroute -I wix.com |  grep -v 'traceroute to'| awk '{printf \"<tr><td>%-3s</td><td>%-50s</td><td>%-10s</td><td>%-10s</td><td>%-10s</td></tr>\", $1,$2,$4,$6,$8}'";
execute($command,null, $out, $out, 120);
echo "$out";
echo "</table>";


//$connection = ssh2_connect('10.0.1.10', 22);
//
//if (ssh2_auth_pubkey_file($connection, 'ubuntu',
//                          '/var/www/.ssh/web_key.openssh',
//                          '/var/www/.ssh/web_key', '')) {
//    echo "\n";
//    echo "<table border='1' >";
//    $command="sudo traceroute -I wix.com |  grep -v 'traceroute to'| awk '{printf \"<tr><td>%-3s</td><td>%-50s</td><td>%-10s</td><td>%-10s</td><td>%-10s</td></tr>\", $1,$2,$4,$6,$8}'";
//    $stream =ssh2_exec($connection, $command);
//    $errorStream = ssh2_fetch_stream($stream, SSH2_STREAM_STDERR);
//    stream_set_blocking($errorStream, true);
//    stream_set_blocking($stream, true);
//
//    echo stream_get_contents($stream);
//    echo "</table>";
//
//    fclose($errorStream);
//   fclose($stream);
//} else {
//  die('Public Key Authentication Failed');
//}



?>
