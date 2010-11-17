
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

#include<config.h>

#include<libmsip/SipMessageContentMime.h>
#include<libmsip/SipMessage.h>
#include<libmsip/SipMessageContentFactory.h>
#include<libmutil/massert.h>
#include <iostream>

using namespace std;

MRef<SipMessageContent*> SipMIMEContentFactory(const std::string & buf, const std::string & ContentType) {
	return new SipMessageContentMime(buf, ContentType);
}

SipMessageContentMime::SipMessageContentMime(std::string t){
	this->ContentType = t;
	this->boundry = "boun=_dry";
	this->Message = "";
	this->uniqueboundry = "_Minisip";
}

SipMessageContentMime::SipMessageContentMime(std::string t, std::string m, std::string b) {
	this->Message = m; 
	this->ContentType = t;
	this->boundry = b;
	this->uniqueboundry = "_Minisip";
}

SipMessageContentMime::SipMessageContentMime(std::string content, std::string t) {
	size_t index2;
	std::string cont;
	this->uniqueboundry = "_Minisip";
	if(t.substr(0,9) == "multipart"){
		this->ContentType = t.substr(0 , t.find(";",0));
		index2 = t.find(";boundary=",0);
		massert(index2 != string::npos);
		this->boundry = t.substr(index2 + 10 , t.find(";",index2 + 10));

		this->Message = "";
		size_t index1 = 0;
		string part = "";

		// Find and add first bodypart
		part = "application/sdp";
		index1 = content.find(part, 0) + part.length() + 2; //hack ;)
		index2 = content.find("--"+this->boundry, index1) - 4;

		cont=part;
		SipMessageContentFactoryFuncPtr contentFactory = SipMessage::contentFactories.getFactory(cont);
		addPart(contentFactory(content.substr(index1,index2-index1+1), cont));

//		cerr << endl << "part1=" << content.substr(index1,index2-index1+1) << endl;

		// Find and add second bodypart
		part = "application/resource-lists+xml";
		index1 = content.find(part, 0) + part.length() + 2; //hack ;)
		index2 = content.rfind("--"+this->boundry+"--", content.length()) - 2;

		cont=part;
		contentFactory = SipMessage::contentFactories.getFactory(cont);
		addPart(contentFactory(content.substr(index1,index2-index1+1), cont));

//		cerr << endl << "part2=" << content.substr(index1,index2-index1+1) << endl;

	}
	else{
		this->ContentType = t;
		this->Message = content;
		this->boundry = "";
	}
}

std::string SipMessageContentMime::getString() const{
	if(ContentType.substr(0,9) == "multipart"){
		std::list <MRef<SipMessageContent*> >::const_iterator iter;
		std::string mes;
		if(Message != "")
			mes = Message + "\r\n\r\n";
		if(parts.empty())
			mes ="--" + boundry + "\r\n\r\n";
		else
			for( iter = parts.begin(); iter != parts.end()  ; iter++ ){
				mes = mes + "--" + boundry + "\r\n";
				mes = mes + "Content-type: " + (*iter)->getContentType() + "\r\n\r\n";
				mes = mes + (*iter)->getString() + "\r\n\r\n";
			}
		mes = mes + "--" + boundry + "--" + "\r\n";
		return mes;
	}
	else{
		return Message;
	}
}

std::string SipMessageContentMime::getContentType() const{
	if(ContentType.substr(0,9) == "multipart")
		return ContentType +"; boundary=" + boundry;
	else
		return ContentType;
}

void SipMessageContentMime::setBoundry(std::string b){
	this->boundry = b;
}

std::string SipMessageContentMime::getBoundry(){
	return boundry;
}
	
void SipMessageContentMime::addPart(MRef<SipMessageContent*> part){
	if( (part->getContentType()).substr(0,9) == "multipart")
		if(((SipMessageContentMime*)*part)->getBoundry() == boundry){
			((SipMessageContentMime*)*part)->setBoundry(boundry + uniqueboundry);
			uniqueboundry = uniqueboundry + "_Rules";
		}
	parts.push_back(part);
}

MRef<SipMessageContent*> SipMessageContentMime::popFirstPart() {
	if(!parts.empty()){
		MRef<SipMessageContent*> part = parts.front(); 
		parts.pop_front();
		return part;
	}
	else 
		return NULL;
}
	




