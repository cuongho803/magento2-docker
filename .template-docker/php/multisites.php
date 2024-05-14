<?php
if(!function_exists('isHttpHost')){
    function isHttpHost($host)
    {
        if (!isset($_SERVER['HTTP_HOST'])) {
            return false;
        }
        return $_SERVER['HTTP_HOST'] ===  $host;
    }
}

if (isHttpHost("project.local"))
{
    $_SERVER["MAGE_RUN_CODE"] = "b2b";
    $_SERVER["MAGE_RUN_TYPE"] = "store";
}
