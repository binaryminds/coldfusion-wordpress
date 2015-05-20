<cfcomponent displayname="Wordpress">

	<cfscript>
		this.username = "";
		this.password = "";
		this.blog_url = "";
	</cfscript>
	
	<cffunction name="init">
		<cfargument name="username" required="true" type="string" />
		<cfargument name="password" required="true" type="string" />
		<cfargument name="blog_url" required="true" type="string" />
		<cfset this.username = arguments.username>
		<cfset this.password = arguments.password>
		<cfset this.blog_url = arguments.blog_url>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="post">
		<cfargument name="title" required="true" type="string" />
		<cfargument name="description" required="true" type="string" />
		
		<cfargument name="keywords" required="false" type="string" default="" />
		<cfargument name="category" required="false" type="string" default="" />
		<cfargument name="allow_comments" required="false" type="numeric" default=1 />
		
		<cfargument name="username" required="false" type="string" default="#this.username#" />
		<cfargument name="password" required="false" type="string" default="#this.password#" />
		<cfargument name="blog_url" required="false" type="string" default="#this.blog_url#" />
		<cftry>
			<cfsavecontent variable="xml">
				<cfoutput>
					<?xml version="1.0" encoding="iso-8859-1"?> 
					<methodCall> 
					<methodName>metaWeblog.newPost</methodName> 
					<params> 
					 <param><value><int>0</int></value></param>
					 <param><value><string>#arguments.username#</string></value></param> 
					 <param><value><string>#arguments.password#</string></value></param> 
					 <param><value>
						<struct> 
					    <member><name>title</name><value><string>#arguments.title#</string></value></member> 
					    <member><name>description</name> 
					     <value> 
					      
					      	#HTMLEditFormat(arguments.description)#
					       
					     </value> 
					    </member> 
					    <member><name>mt_allow_comments</name><value><int>#arguments.allow_comments#</int></value></member> 
					    <member><name>mt_allow_pings</name><value><int>1</int></value></member> 
					    <member><name>post_type</name><value><string>post</string></value></member> 
					    <member><name>mt_keywords</name><value><string>#arguments.keywords#</string></value></member> 
					    <member><name>categories</name><value>
					      <array>
					       <data>
					        <value>
					         <string>#arguments.category#</string>
					        </value>
					       </data>
					      </array>
					     </value>
					    </member>
					   </struct>
					  </value>
					 </param>
					 <param><value><boolean>1</boolean></value></param> 
					</params> 
					</methodCall>
				</cfoutput>
			</cfsavecontent>
			
			<cfhttp url="#arguments.blog_url#/xmlrpc.php" method="post">
				<cfhttpparam type="body" value="#xml#" />
			</cfhttp>
			<cfreturn xmlparse(cfhttp.filecontent)>
			<cfcatch>
				<cfset result = StructNew()>
				<cfset result['error'] = cfcatch.message>
				<cfreturn result>
			</cfcatch>
		</cftry>
	</cffunction>



	<cffunction name="postComment">
		<cfargument name="message" required="true" type="string" />
		<cfargument name="postid" required="true" type="string" />
		
		<cfargument name="username" required="false" type="string" default="#this.username#" />
		<cfargument name="password" required="false" type="string" default="#this.password#" />
		<cfargument name="blog_url" required="false" type="string" default="#this.blog_url#" />
		<cftry>
			<cfsavecontent variable="xml">
				<cfoutput>
				<?xml version="1.0"?>
				<methodCall>
				<methodName>wp.newComment</methodName>
				<params>
					<param><value><int>0</int></value></param>
					<param><value><string>#arguments.username#</string></value></param> 
					<param><value><string>#arguments.password#</string></value></param>
					<param><value><int>#arguments.postid#</int></value></param>
					<param>
						<value>
							<struct>
								<member>
									<name>comment_parent</name>
									<value>
										<int></int>
									</value>
								</member>
								<member>
									<name>content</name>
									<value>
										<string>#arguments.message#</string>
									</value>
								</member>
								<member>
									<name>author</name>
									<value>
										<string>#arguments.username#</string>
									</value>
								</member>
								<member>
									<name>author_url</name>
									<value>
										<string></string>
									</value>
								</member>
								<member>
									<name>author_email</name>
									<value>
										<string></string>
									</value>
								</member>
							</struct>
						</value>
					</param>
				</params>
				</methodCall>
				</cfoutput>
			</cfsavecontent>
			
			<cfhttp url="#arguments.blog_url#/xmlrpc.php" method="post">
				<cfhttpparam type="body" value="#xml#" />
			</cfhttp>
			<cfreturn xmlparse(cfhttp.filecontent)>
			<cfcatch>
				<cfset result = StructNew()>
				<cfset result['error'] = cfcatch.message>
				<cfreturn result>
			</cfcatch>
		</cftry>
	</cffunction>



	<cffunction name="getComments">
		<cfargument name="postid" required="false" type="numeric" default=1 />
		
		<cfargument name="username" required="false" type="string" default="#this.username#" />
		<cfargument name="password" required="false" type="string" default="#this.password#" />
		<cfargument name="blog_url" required="false" type="string" default="#this.blog_url#" />
		<cftry>
			<cfsavecontent variable="xml">
				<cfoutput>
					<?xml version="1.0"?>
					<methodCall>
					  <methodName>wp.getComments</methodName>
					  <params>
					    <param><value><int>0</int></value></param>
					 	<param><value><string>#arguments.username#</string></value></param> 
					 	<param><value><string>#arguments.password#</string></value></param> 
					    <param>
					      <value>
					        <struct>
					          <member>
					            <name>post_id</name>
					            <value>
					              <int>#arguments.postid#</int>
					            </value>
					          </member>
					        </struct>
					      </value>
					    </param>
					  </params>
					</methodCall>
				</cfoutput>
			</cfsavecontent>
			
			<cfhttp url="#arguments.blog_url#/xmlrpc.php" method="post">
				<cfhttpparam type="body" value="#xml#" />
			</cfhttp>
			<cfreturn xmlparse(cfhttp.filecontent)>
			<cfcatch>
				<cfset result = StructNew()>
				<cfset result['error'] = cfcatch.message>
				<cfreturn result>
			</cfcatch>
		</cftry>
	</cffunction>


	<cffunction name="getUsersBlogs">
		<cfargument name="username" required="false" type="string" default="#this.username#" />
		<cfargument name="password" required="false" type="string" default="#this.password#" />
		<cfargument name="blog_url" required="false" type="string" default="#this.blog_url#" />
		<cftry>
			<cfsavecontent variable="xml">
				<cfoutput>
					<?xml version="1.0" encoding="iso-8859-1"?> 
					<methodCall> 
					<methodName>wp.getUsersBlogs</methodName> 
					<params> 
					 <param><value><string>#arguments.username#</string></value></param> 
					 <param><value><string>#arguments.password#</string></value></param> 
					</params> 
					</methodCall>
				</cfoutput>
			</cfsavecontent>
			
			<cfhttp url="#arguments.blog_url#/xmlrpc.php" method="post">
				<cfhttpparam type="body" value="#xml#" />
			</cfhttp>
			<cfset r = xmlsearch(xmlparse(cfhttp.filecontent), '//member[name="blogName"]/value/*') />
			<cfreturn "#r[1].xmlText#">
			<cfcatch>
				<cfset result = StructNew()>
				<cfset result['error'] = cfcatch.message>
				<cfreturn result>
			</cfcatch>
		</cftry>
	</cffunction>


</cfcomponent>
