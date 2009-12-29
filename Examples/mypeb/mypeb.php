<?php
	/** NOTE this requires the use of the mypeb PHP extension http://code.google.com/p/mypeb/ **/

echo "\n\nRUNNING MYPEB Erlang Bridge Tests\n\n";

$link = peb_connect('erlnode',  'secret');
echo "The link is: " . $link;
if (!$link) { 
    die('Could not connect: ' . peb_error()); 
} 

$msg = peb_encode('[~a,~p,~s]', array( "echo",
                                   array($link,'getinfo'),
                                   "Hello World"
                                  ) 
                 );
                 
//The sender must include a reply address.  use ~p to format a link identifier to a valid Erlang pid.

peb_send_byname('erlnode',$msg,$link); 

$message = peb_receive($link);
$rs= peb_decode( $message) ;
print_r($rs);

$serverpid = $rs[0][0];

peb_close($link); 
?>