require 'viewpoint'
require 'pp'
require 'time'
require 'rubygems'
require 'sinatra'
include Viewpoint::EWS

set :bind, '0.0.0.0'

get '/' do	
  retrieveews("confroom1@exchange.local")
end

get '/room/:roomname' do
	retrieveews(params[:roomname])
end

get '/create/:minutes' do
	createMeeting(params[:minutes].to_i, "confroom1@exchange.local")
	retrieveews()
end

def connectews()
	endpoint = 'https://exchange.local/ews/Exchange.asmx'
	user = 'exchangeusr1'
	pass = 'password'

	cli = Viewpoint::EWSClient.new endpoint, user, pass
	# => to get all available time zones
	#pp cli.ews.get_time_zones(full=false,ids=nil)
	cli.set_time_zone("W. Europe Standard Time")
	return cli
end

def getcalendarews(usermail,cli)
	return cli.get_folder :calendar, opts = {act_as: usermail}
end

def createMeeting(minutes,usermail)
	cli=connectews()

	calendar=getcalendarews usermail, cli

	calendar.create_item(:subject => 'spontanes Meeting', :start => Time.now, :end => Time.now+minutes*60)
end

def getmeetingstring(cal, subjectstring)
	return (cal.start.strftime("%H:%M")+'-'+cal.end.strftime("%H:%M")+' / '+cal.start.strftime("%F")+' :<br> '+cal.organizer.name+' ('+cal.required_attendees.count.to_s+' Teilnehmer)<br>'+subjectstring)
end

 
def retrieveews(roomname)
	buf = File.read('template.html')

	cli=connectews()

	folder = getcalendarews roomname, cli
	
	sd = Date.today()
	ed = Date.today()+5 #look 5 days ahead

	calendaritems= folder.items_between sd, ed

	#calendaritems=folder.todays_items
	
	# => DEBUG
	#pp calendaritems.count
	
	calendaritems=calendaritems.sort_by { |calendaritems| calendaritems.start }
	calendaritems.delete_if {|calendaritems|calendaritems.end < DateTime.now()}

	timenow=DateTime.now()
	index=0
	roomfree=false
	calendaritems.each do |cal|
		# => DEBUG
		#pp index
		#pp cal.subject
		#pp cal.start.rfc3339()
		#pp timenow.rfc3339()

		if !cal.subject.nil? && index==0
			if  timenow < cal.end &&  timenow < cal.start
				buf.sub! '%starttime%', 'FREI'
				buf.sub! '%endtime%', cal.start.strftime("%H:%M")
				buf.sub! '%persons%', "0"
				buf.sub! '%organizer%', '-'
				buf.sub! '%subject%', 'Raum ist frei'

				buf.sub! '%nextmeeting%', getmeetingstring(cal, 'Besprechung')
				roomfree=true
			else
				buf.sub! '%starttime%', cal.start.strftime("%H:%M")
				buf.sub! '%endtime%', cal.end.strftime("%H:%M")
				buf.sub! '%persons%', cal.required_attendees.count.to_s
			end

			buf.sub! '%subject%', 'Besprechung'
			
			buf.sub! '%startdate%', cal.start.strftime("%F")
			buf.sub! '%organizer%', cal.organizer.name
			cal.required_attendees.each do |names|
				buf=buf

			end
		end

		if index==1 
			buf.sub! '%nextmeeting%', getmeetingstring(cal, 'Besprechung')

			if roomfree==true
				buf.sub! '%nextmeeting2%', getmeetingstring(cal, 'Besprechung')
			end

		end

		if index==2
			buf.sub! '%nextmeeting2%', getmeetingstring(cal, 'Besprechung')
		end
		index=index+1
	end
	buf.sub! '%nextmeeting%', ''
	buf.sub! '%nextmeeting2%',''
	buf.sub! '%lastupdate%', DateTime.now().strftime("%F/%H:%M:%S")
	buf.sub! '%roomurl', '/room/'+roomname
	buf
end
