#!/usr/bin/php
<?php

function get_local_ipv4() {
  $out = split(PHP_EOL,shell_exec("/sbin/ifconfig"));
  foreach($out as $str) {
    $matches = array();
    if(preg_match('/^([a-z0-9]+)(:\d{1,2})?(\s)+Link/',$str,$matches)) {
      $ifname = $matches[1];
      if(strlen($matches[2])>0) {
        $ifname .= $matches[2];
      }
    } elseif(preg_match('/inet addr:((?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)(?:[.](?:25[0-5]|2[0-4]\d|1\d\d|[1-9]\d|\d)){3})\s/',$str,$matches)) {
      return $matches[1];
    }
  }
}


if (file_exists("/etc/cgminer.conf.template")) {
	$ip = get_local_ipv4();
	$hostname = trim(exec("hostname"));
	$ipfixed_array = explode ("." , $ip);
	$ipfixed = $ipfixed_array[2]."x".$ipfixed_array[3];
	$ver = trim(file_get_contents("/fw_ver"));
	$fixed_ver = str_replace (".", "x" ,  $ver);
	$hostname = str_replace("miner-","",$hostname);
	$current  = file_get_contents("/etc/cgminer.conf", true);
	$user  = file_get_contents("/etc/cgminer.conf.template", true);

	$user = str_replace("%%","%",$user);
	$user = str_replace("%h",$hostname,$user);
	$user = str_replace("%i",$ip,$user);
	$user = str_replace("%j",$ipfixed,$user);
	$user = str_replace("%v",$ver,$user);
	$user = str_replace("%w",$fixed_ver,$user);
	$user = str_replace("%m",trim(file_get_contents("/model_name")),$user);
	if (strcmp($user,$current)) {
		$written = file_put_contents("/etc/cgminer.conf", $user);
	} 
	//echo $user;
}
