# eBook Conference Room Display based on a Amazon Kindle Touch

requirements:
* Microsoft Exchange 2010/2013 with exchange web services enabled
* "server" with ruby 2.x, zlib support and the following gems
* gem install viewpoint sinatra pp
* kindle touch with webbrowser (any tablet device with webbrowser, kindle template is provided)
* for fullscreen web browser on kindle you need a jailbroken device


##execute server
###for development (shotgun server)
gem install shotgun
shotgun -o 0.0.0.0 ewstest.rb

###for production (needs restart after every source code changes)
ruby ewstest.rb

##open interface on kindle
###http://server:9393/		(development)

###http://server:4567/ 	(production)

