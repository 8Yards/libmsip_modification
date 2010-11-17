
/*
  Copyright (C) 2005, 2004 Erik Eliasson, Johan Bilien, Joachim Orrblad
  
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
 * Authors: Joachim Orrblad <joachim[at]orrblad.com>
 *          
*/

/*
 * Authors: Prajwol Kumar Nakarmi <prajwolkumar.nakarmi@gmail.com>
 *
*/
#ifndef _SipMessageContentRCL_H
#define _SipMessageContentRCL_H

#include<libmsip/libmsip_config.h>

#include<libmsip/SipMessageContent.h>
#include<libmutil/MemObject.h>
#include<string.h>

MRef<SipMessageContent*> LIBMSIP_API SipRCLContentFactory(const std::string & buf, const std::string & ContentType);

class LIBMSIP_API SipMessageContentRCL : public SipMessageContent{
	public:
		SipMessageContentRCL(std::string ContentType);
		SipMessageContentRCL(std::string content, std::string ContentTyp);
		virtual std::string getString() const;
		virtual std::string getContentType() const;
		virtual std::string getMemObjectType() const {return "SipMessageContentRCL";}
		std::vector <std::string> getParticipantList();
	private:
		std::string contentType;
		std::vector<std::string> participants;
};

#endif


