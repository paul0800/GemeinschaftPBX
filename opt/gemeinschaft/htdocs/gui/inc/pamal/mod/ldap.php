<?php
defined('PAMAL_DIR') or die('No direct access.');

class PAMAL_auth_ldap extends PAMAL_auth
{
	function PAMAL_auth_ldap()
	{
		$this->_user = $this->_getUser();
	}

	function _getUser()
	{
		$ldapproto      = gs_get_conf( 'GS_LDAP_PROTOCOL' );
		$ldapuser       = trim( @$_REQUEST['login_user'] );
		$ldapdn         = gs_get_conf( 'GS_LDAP_PROP_USER' ) . '=' . $ldapuser . ',' . gs_get_conf( 'GS_LDAP_SEARCHBASE' );
		$ldappass       =  @$_REQUEST['login_pwd'];
		$ldapsearchdn   = gs_get_conf( 'GS_LDAP_BINDDN' );
		$ldapsearchpass = gs_get_conf( 'GS_LDAP_PWD' );
		
		$ldapconn = @ ldap_connect( gs_get_conf( 'GS_LDAP_HOST' ) );
		@ ldap_set_option( $ldapconn, LDAP_OPT_PROTOCOL_VERSION, (int)$ldapproto );
		if ( !$ldapconn ) {
			gs_log( GS_LOG_WARNING, 'Unable to connect to LDAP server' );
			return false;
		}

		if ( $ldapuser== '' || $ldappass== '' )
			return false;
			
		if ( $ldapconn ) {
			$ldapbind = @ ldap_bind( $ldapconn, $ldapsearchdn, $ldapsearchpass );
			if ( $ldapbind ) {
				$searchresult = @ ldap_search( $ldapconn, 
							gs_get_conf( 'GS_LDAP_SEARCHBASE' ),
							'(' . gs_get_conf( 'GS_LDAP_PROP_UID' ) . '=' . $ldapuser . ')',
							array()
							);
				$ldapinfo = ldap_get_entries( $ldapconn, $searchresult );
				if ( $ldapinfo['count'] != 1 ) {
					gs_log( GS_LOG_DEBUG, 'Number of users found in LDAP is not 1 (' . $ldapinfo['count'] . ')' );
					return false;
				}
			}
			else
			{
				gs_log( GS_LOG_DEBUG, 'Unable to bind to LDAP server as ' . $ldapsearchdn . ', ' . ldap_error($ldapconn) );
				return false;
			}
		}
		$ldapbind = @ ldap_bind( $ldapconn, $ldapinfo[0]['dn'], $ldappass );
		if ( $ldapbind ) {
			gs_log( GS_LOG_DEBUG, 'User ' . $ldapinfo[0]['dn'] . ' found!' );
			return $ldapuser;
		}
		else
		{
			gs_log( GS_LOG_DEBUG, 'Unable to bind to LDAP server as ' . $ldapinfo[0]['dn'] . ', ' . ldap_error($ldapconn) );
			return false;
		}
	}
}
?>