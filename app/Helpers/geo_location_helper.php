<?php //if (!defined('BASEPATH')) exit('No direct script access allowed');

/**
 * Geo Location Plugin
 *
 * @package        CodeIgniter
 * @subpackage        System
 * @category        Plugin
 */

// ------------------------------------------------------------------------

/*    
Instructions:

Load the plugin using:

     $this->load->plugin('geo_location');

Once loaded you can get user's geo location details by IP address

    $ip = $this->input->ip_address();
    $geo_data = geolocation_by_ip($ip);

    echo "Country code : ".$geo_data['country_name']."\n";
    echo "Country name : ".$geo_data['city']."\n";
    ...


NOTES:

    The get_geolocation function will use current IP address, if IP param is not given.

RETURNED DATA

The get_geolocation() function returns an associative array with this data:

  [array]
  (
    'ip'=>$ip, 
    'country_code'=>$result->CountryCode, 
    'country_name'=>$result->CountryName, 
    'region_name'=>$result->RegionName, 
    'city'=>$result->City, 
    'zip_postal_code'=>$result->ZipPostalCode, 
    'latitude'=>$result->Latitude, 
    'longitude'=>$result->Longitude, 
    'timezone'=>$result->Timezone, 
    'gmtoffset'=>$result->Gmtoffset, 
    'dstoffset'=>$result->Dstoffset
  )
*/


/**
 * Get Geo Location by Given/Current IP address
 *
 * @access    public
 * @param    string
 * @return    array
 */
if (!function_exists('get_geolocation')) {

    function get_geolocation($ip) {
	if($ip !='') {
        $data = get_meta_tags('http://www.geobytes.com/IpLocator.htm?GetLocation&template=php3.txt&IpAddress='.$ip);
        //Return the data as an array
        if(isset($data['timezone'])){
            $tzone = $data['timezone'];
        }else{
            $tzone = '+0.0';
        }
		$t_zone = '+0.0';
		switch($tzone){
			case "-12:30" : $t_zone =  "-12.5";break;
			case "-12:00" : $t_zone =  "-12.0";break;
			case "-11:30" : $t_zone =  "-11.5";break;
			case "-11:00" : $t_zone =  "-11.0";break;
			case "-10:30" : $t_zone =  "-10.5";break;
			case "-10:00" : $t_zone =  "-10.0";break;
			case "-09:30" : $t_zone =  "-9.5";break;
			case "-09:00" : $t_zone =  "-9.0";break;
			case "-08:30" : $t_zone =  "-8.5";break;
			case "-08:00" : $t_zone =  "-8.0";break;
			case "-07:30" : $t_zone =  "-7.5";break;
			case "-07:00" : $t_zone =  "-7.0";break;
			case "-06:30" : $t_zone =  "-6.5";break;
			case "-06:00" : $t_zone =  "-5.0";break;
			case "-05:30" : $t_zone =  "-5.5";break;
			case "-05:00" : $t_zone =  "-5.0";break;
			case "-04:30" : $t_zone =  "-4.5";break;
			case "-04:00" : $t_zone =  "-4.0";break;
			case "-03:30" : $t_zone =  "-3.5";break;
			case "-03:00" : $t_zone =  "-3.0";break;
			case "-02:30" : $t_zone =  "-2.5";break;
			case "-02:00" : $t_zone =  "-2.0";break;
			case "-01:30" : $t_zone =  "-1.5";break;
			case "-01:00" : $t_zone =  "-1.0";break;
			case "+12:30" : $t_zone =  "+12.5";break;
			case "+12:00" : $t_zone =  "+12.0";break;
			case "+11:30" : $t_zone =  "+11.5";break;
			case "+11:00" : $t_zone =  "+11.0";break;
			case "+10:30" : $t_zone =  "+10.5";break;
			case "+10:00" : $t_zone =  "+10.0";break;
			case "+09:30" : $t_zone =  "+9.5";break;
			case "+09:00" : $t_zone =  "+9.0";break;
			case "+08:30" : $t_zone =  "+8.5";break;
			case "+08:00" : $t_zone =  "+8.0";break;
			case "+07:30" : $t_zone =  "+7.5";break;
			case "+07:00" : $t_zone =  "+7.0";break;
			case "+06:30" : $t_zone =  "+6.5";break;
			case "+06:00" : $t_zone =  "+5.0";break;
			case "+05:45" : $t_zone =  "++5.75";break;
			case "+05:30" : $t_zone =  "+5.5";break;
			case "+05:00" : $t_zone =  "+5.0";break;
			case "+04:30" : $t_zone =  "+4.5";break;
			case "+04:00" : $t_zone =  "+4.0";break;
			case "+03:30" : $t_zone =  "+3.5";break;
			case "+03:00" : $t_zone =  "+3.0";break;
			case "+02:30" : $t_zone =  "+2.5";break;
			case "+02:00" : $t_zone =  "+2.0";break;
			case "+01:30" : $t_zone =  "+1.5";break;
			case "+01:00" : $t_zone =  "+1.0";break;
			default : $t_zone =  "+0.0";break;
		
		}
		return $t_zone;
		}
    }
}
/* End of file geo_location_pi.php */
/* Location: ./system/plugins/geo_location_pi.php */

/* Date functions inherited from ci3 system date helper file */
/**
 * Converts GMT time to a localized value
 *
 * Takes a Unix timestamp (in GMT) as input, and returns
 * at the local value based on the timezone and DST setting
 * submitted
 *
 * @access	public
 * @param	integer Unix timestamp
 * @param	string	timezone
 * @param	bool	whether DST is active
 * @return	integer
 * rewritten probably don't even need this.
 * The error happens because timezones(timezone) can return an array (whentimezone is empty), and PHP can’t multiply an array by an int. We should harden gmt_to_local() to normalize inputs and guard against non-numeric timezone values.
 * Below are safe edits that:
 * - Normalize $time to an integer timestamp if a string is passed.
 * - Resolve timezone offsets robustly:
 * - Accept numeric hours directly (e.g., -5, 5.5).
 * - Use the CI timezone codes (UM6, UTC, etc.) via timezones().
 * - Fall back to PHP timezone identifiers (e.g., America/New_York) using DateTimeZone.
 * - Treat an unexpected array from timezones() as 0 offset.
 *
 * - Apply DST only after we have a numeric offset.
 */
function gmt_to_local($time = '', $timezone = 'UTC', $dst = FALSE)
{
    if ($time == '' || $time == '0000-00-00 00:00:00')
    {
        return time();
    }

    // Normalize time to Unix timestamp
    if (!is_int($time)) {
        $time = is_numeric($time) ? (int) $time : strtotime((string) $time);
        if ($time === false) {
            $time = time();
        }
    }

    // Resolve timezone offset in seconds
    $offsetSeconds = 0;
    if (is_numeric($timezone)) {
        // Numeric hours (e.g., -5, 5.5)
        $offsetSeconds = (int) round(((float) $timezone) * 3600);
    } elseif (is_string($timezone) && $timezone !== '') {
        // Try CI timezone codes (UM6, UTC, etc.)
        $tzVal = timezones($timezone);
        if (!is_array($tzVal)) {
            $offsetSeconds = (int) round(((float) $tzVal) * 3600);
        } else {
            // Fallback: PHP timezone identifier (e.g., America/New_York)
            try {
                $dtz = new \DateTimeZone($timezone);
                $dt  = new \DateTime('@' . $time);
                $dt->setTimezone($dtz);
                $offsetSeconds = $dtz->getOffset($dt);
            } catch (\Throwable $e) {
                $offsetSeconds = 0;
            }
        }
    }

    if ($dst === TRUE)
    {
        $offsetSeconds += 3600;
    }

    return $time + $offsetSeconds;
}


/**
 * Timezones
 *
 * Returns an array of timezones.  This is a helper function
 * for various other ones in this library
 *
 * @access	public
 * @param	string	timezone
 * @return	string
 */
if ( ! function_exists('timezones'))
{
	function timezones($tz = '')
	{
		// Note: Don't change the order of these even though
		// some items appear to be in the wrong order

		$zones = array(
						'UM12'		=> -12,
						'UM11'		=> -11,
						'UM10'		=> -10,
						'UM95'		=> -9.5,
						'UM9'		=> -9,
						'UM8'		=> -8,
						'UM7'		=> -7,
						'UM6'		=> -6,
						'UM5'		=> -5,
						'UM45'		=> -4.5,
						'UM4'		=> -4,
						'UM35'		=> -3.5,
						'UM3'		=> -3,
						'UM2'		=> -2,
						'UM1'		=> -1,
						'UTC'		=> 0,
						'UP1'		=> +1,
						'UP2'		=> +2,
						'UP3'		=> +3,
						'UP35'		=> +3.5,
						'UP4'		=> +4,
						'UP45'		=> +4.5,
						'UP5'		=> +5,
						'UP55'		=> +5.5,
						'UP575'		=> +5.75,
						'UP6'		=> +6,
						'UP65'		=> +6.5,
						'UP7'		=> +7,
						'UP8'		=> +8,
						'UP875'		=> +8.75,
						'UP9'		=> +9,
						'UP95'		=> +9.5,
						'UP10'		=> +10,
						'UP105'		=> +10.5,
						'UP11'		=> +11,
						'UP115'		=> +11.5,
						'UP12'		=> +12,
						'UP1275'	=> +12.75,
						'UP13'		=> +13,
						'UP14'		=> +14
					);

		if ($tz == '')
		{
			return $zones;
		}

		if ($tz == 'GMT')
			$tz = 'UTC';

		return ( ! isset($zones[$tz])) ? 0 : $zones[$tz];
	}
}