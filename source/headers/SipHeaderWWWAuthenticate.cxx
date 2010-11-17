/*
  Copyright (C) 2005, 2004 Erik Eliasson, Johan Bilien
  
  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

/*
 * Authors: Erik Eliasson <eliasson@it.kth.se>
 *          Johan Bilien <jobi@via.ecp.fr>
*/


/* Name
 * 	SipHeaderValueWWWAuthenticate.cxx
 * Author
 * 	Erik Eliasson, eliasson@it.kth.se
 * Purpose
 * 
*/

#include<config.h>

#include<libmsip/SipHeaderWWWAuthenticate.h>

using namespace std;

MRef<SipHeaderValue *> wwwAuthFactory(const string &build_from){
	                return new SipHeaderValueWWWAuthenticate(build_from);
}

SipHeaderFactoryFuncPtr sipHeaderWWWAuthenticateFactory=wwwAuthFactory;


const string sipHeaderValueWWWAuthenticationTypeStr = "WWW-Authenticate";
		
SipHeaderValueWWWAuthenticate::SipHeaderValueWWWAuthenticate(const string &build_from)
		: SipHeaderValueProxyAuthenticate(SIP_HEADER_TYPE_WWWAUTHENTICATE,sipHeaderValueWWWAuthenticationTypeStr, build_from)
{
}

SipHeaderValueWWWAuthenticate::~SipHeaderValueWWWAuthenticate(){

}
		
