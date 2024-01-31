#!/bin/sh -e
#
#  Copyright 2024, Roger Brown
#
#  This file is part of rhubarb-geek-nz/curl-qnx
#
#  This program is free software: you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by the
#  Free Software Foundation, either version 3 of the License, or (at your
#  option) any later version.
# 
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>
#
# $Id: QNX 81 2024-01-28 21:33:48Z rhubarb-geek-nz $
#

VERSION=8.5.0
PKGNAME=curl

rm -rf $PKGNAME-$VERSION

trap 'rm -rf $PKGNAME-$VERSION' 0

tar xfz $PKGNAME-$VERSION.tar.gz

(
	set -e
	cd $PKGNAME-$VERSION

	ACCEPT_INFERIOR_RM_PROGRAM=yes LIBS=-lsocket ./configure CPPFLAGS='-DFD_SETSIZE=64' --without-ssl --disable-shared --disable-libcurl-option --disable-largefile

	make

	make DESTDIR=$(pwd)/dist install

	cat >$PKGNAME.qpg <<EOF
<QPG:Generation>
   <QPG:Options>
      <QPG:User unattended="no" verbosity="2" listfiles="yes"/>
      <QPG:Defaults type="qnx_package"/>
      <QPG:Source></QPG:Source>
      <QPG:Release number="+"/>
      <QPG:Build></QPG:Build>
      <QPG:FileSorting strip="yes"/>
      <QPG:Package targets="combine"/>
      <QPG:Repository generate="yes"/>
      <QPG:FinalDir></QPG:FinalDir>
      <QPG:Cleanup></QPG:Cleanup>
   </QPG:Options>

   <QPG:Responsible>
      <QPG:Company></QPG:Company>
      <QPG:Department></QPG:Department>
      <QPG:Group></QPG:Group>
      <QPG:Team></QPG:Team>
      <QPG:Employee></QPG:Employee>
      <QPG:EmailAddress></QPG:EmailAddress>
   </QPG:Responsible>

   <QPG:Values>
      <QPG:Files>
         <QPG:Add file="dist/usr/local/bin/$PKGNAME" install="/usr/local/bin/" tos="qnx6"/>
      </QPG:Files>

      <QPG:PackageFilter>
         <QPM:PackageManifest>
            <QPM:PackageDescription>
               <QPM:PackageType>Application</QPM:PackageType>
               <QPM:FileVersion>2.6</QPM:FileVersion>
               <QPM:DateCode>4bbe8479</QPM:DateCode>
            </QPM:PackageDescription>

            <QPM:ProductDescription>
               <QPM:ProductName>$PKGNAME</QPM:ProductName>
               <QPM:ProductIdentifier>$PKGNAME</QPM:ProductIdentifier>
               <QPM:VendorName>Public</QPM:VendorName>
               <QPM:VendorInstallName>public</QPM:VendorInstallName>
               <QPM:AuthorName>Daniel Stenberg</QPM:AuthorName>
               <QPM:ProductDescriptionShort>command line tool for transferring data with URL syntax</QPM:ProductDescriptionShort>
               <QPM:ProductDescriptionLong>Curl is a client to get documents and files from or send documents to a server using any of the supported protocols (HTTP, HTTPS, FTP, FTPS, TFTP, DICT, TELNET, LDAP, or FILE). The command is designed to work without user interaction or any kind of interactivity.</QPM:ProductDescriptionLong>
            </QPM:ProductDescription>

            <QPM:ReleaseDescription>
               <QPM:ReleaseVersion>$VERSION</QPM:ReleaseVersion>
               <QPM:ReleaseUrgency>Medium</QPM:ReleaseUrgency>
               <QPM:ReleaseStability>Stable</QPM:ReleaseStability>
               <QPM:ReleaseNoteMinor>General release</QPM:ReleaseNoteMinor>
               <QPM:ReleaseNoteMajor>General release</QPM:ReleaseNoteMajor>
               <QPM:ReleaseCopyright>Copyright (c) 1996 - 2024, Daniel Stenberg, daniel@haxx.se, and many contributors</QPM:ReleaseCopyright>
            </QPM:ReleaseDescription>

            <QPM:ContentDescription>
               <QPM:ContentTopic xmlmultiple="true">Applications/Internet</QPM:ContentTopic>
               <QPM:ContentKeyword>$PKGNAME</QPM:ContentKeyword>
               <QPM:DisplayEnvironment xmlmultiple="true">Console</QPM:DisplayEnvironment>
               <QPM:TargetAudience xmlmultiple="true">User</QPM:TargetAudience>
               <QPM:TargetOS>qnx6</QPM:TargetOS>
            </QPM:ContentDescription>
         </QPM:PackageManifest>
      </QPG:PackageFilter>

      <QPG:PackageFilter proc="none" target="none">
         <QPM:PackageManifest></QPM:PackageManifest>
      </QPG:PackageFilter>

      <QPG:PackageFilter proc="x86" target="none">
         <QPM:PackageManifest></QPM:PackageManifest>
      </QPG:PackageFilter>
   </QPG:Values>
</QPG:Generation>
EOF

	packager -u $PKGNAME.qpg
)

mv $PKGNAME-$VERSION/*.qpr .
