<cfset username = "wordpress_username" />
<cfset password = "wordpress_password" />
<cfset blog_url = "http://wordpress.example.com" />

<cfset wp = CreateObject("component", "wordpress").init(username, password, blog_url)/>

<cfset title = "This is test post" />
<cfset description = "This is <b>TEST</b>." />

<cfset response = wp.post(title, description) />

<cfdump var="#response#" />