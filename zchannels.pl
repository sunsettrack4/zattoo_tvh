#!/usr/bin/perl

#      Copyright (C) 2017-2019 Jan-Luca Neumann
#      https://github.com/sunsettrack4/zattoo_tvh/
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with zattoo_tvh. If not, see <http://www.gnu.org/licenses/>.

#
# ZATTOO CHANNEL M3U + PIPE.SH CREATOR
#

use strict;
use warnings;

binmode STDOUT, ":utf8";
use utf8;

use JSON;
use Cwd qw(cwd);

# USE WORK DIR
my $dir = cwd;

# USE MAIN DIR
my $main = cwd;
$main =~ s/\/work//g;

# READ JSON INPUT FILE
my $json;
{
    local $/; #Enable 'slurp' mode
    open my $fh, "<", "$dir/channels_file" or die;
    $json = <$fh>;
    close $fh;
}

# READ OPTIONS FILE
my $options;
{
    local $/; #Enable 'slurp' mode
    open my $fh, "<", "$main/user/options" or die;
    $options = <$fh>;
    close $fh;
}

# READ PROVIDER INFO
my $user;
{
    open my $fh, "<", "$dir/provider" or die;
	$user = <$fh>;
	chomp $user;
    close $fh;
}

# READ JSON
my $ch_file = decode_json($json);

# SET UP VALUES
my @ch_groups = @{ $ch_file->{'channel_groups'} };

print "#EXTM3U\n";

foreach my $ch_groups ( @ch_groups ) {
	my @channels = @{ $ch_groups->{'channels'} };
	my $group    = $ch_groups->{'name'};
	
	foreach my $channels ( @channels ) {
		my $name    = $channels->{'title'};
		my $service = $channels->{'title'} =~ s/\//\\\\\//g;
		my $chid    = $channels->{'cid'};
		my $alias   = $channels->{'display_alias'};
		
		# IF FIRST CHANNEL TYPE IS "AVAILABLE", PRINT M3U LINE
		if( defined $channels->{'qualities'}[0]{'availability'} ) {
			if( $channels->{'qualities'}[0]{'availability'} eq "available" ) {
				my $logo = $channels->{'qualities'}[0]{'logo_black_84'};
				$logo =~ s/84x48.png/210x120.png/g;
				
				print "#EXTINF:0001 tvg-id=\"" . $chid . "\" group-title=\"" . $group . "\" tvg-logo=\"https://images.zattic.com" . $logo . "\", " . $name . "\n";
				print "pipe://" . $main . "/chpipe/" . $alias . ".sh\n";
				
				# CREATE PIPE SCRIPT
				open(my $ph, '>', "$main/chpipe/$alias.sh");
				
				# BASIC LINES
				print $ph "#!/bin/bash\n";
				print $ph "cd $main\n";
				print $ph "session=\$(<user/session)\n";
				print $ph "curl -i -s -X POST -H \"Content-Type: application/x-www-form-urlencoded\" -H \"Accept: application/x-www-form-urlencoded\" --cookie \"\$session\" --data \"stream_type=hls&https_watch_urls=True&timeshift=10800\" https://$user/zapi/watch/live/$chid | grep \"{\" | sed 's/.*\"watch_urls\": \\[{\"url\": \"//g;s/\", .*//g;' > work/chlink && PIPE=\$(sed '/zahs/{s/https:/http:/g;s/zahs.tv.*/zahs.tv/g;s/\\//\\\\\\//g;};/akamaized/{s/https:/http:/g;s/akamaized.net.*/akamaized.net/g;s/\\//\\\\\\//g;}' work/chlink) && curl -s \$(<work/chlink) | \\\n";
				
				# QUALITY SETTING	
				if( $options =~ /chpipe 4/ ) {
					print $ph "grep -E \"live-8000|live-5000|live-3000|live-2999|live-1500\" | sed \"2,5d;s/.*/#\\!\\/bin\\/bash\\n\\/usr\\/bin\\/ffmpeg -loglevel fatal -i \$PIPE\\/& -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal -metadata service_name='$service' pipe:1/g;\" > chpipe.sh\n";
				} elsif( $options =~ /chpipe 3/ ) {
					print $ph "grep -E \"live-3000|live-2999|live-1500\" | sed \"2,5d;s/.*/#\\!\\/bin\\/bash\\n\\/usr\\/bin\\/ffmpeg -loglevel fatal -i \$PIPE\\/& -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal -metadata service_name='$service' pipe:1/g;\" > chpipe.sh\n";
				} elsif( $options =~ /chpipe 2/ ) {
					print $ph "grep -E \"live-1500\" | sed \"2,5d;s/.*/#\\!\\/bin\/bash\\n\\/usr\\/bin\\/ffmpeg -loglevel fatal -i \$PIPE\\/& -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal -metadata service_name='$service' pipe:1/g;\" > chpipe.sh\n";
				} elsif( $options =~ /chpipe 1/ ) {
					print $ph "grep -E \"live-900\" | sed \"2,5d;s/.*/#\\!\\/bin\/bash\\n\\/usr\\/bin\\/ffmpeg -loglevel fatal -i \$PIPE\\/& -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal -metadata service_name='$service' pipe:1/g;\" > chpipe.sh\n";
				} elsif( $options =~ /chpipe 0/ ) {
					print $ph "grep -E \"live-600\" | sed \"2,5d;s/.*/#\\!\\/bin\/bash\\n\\/usr\\/bin\\/ffmpeg -loglevel fatal -i \$PIPE\\/& -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal -metadata service_name='$service' pipe:1/g;\" > chpipe.sh\n";
				}
				
				print $ph "bash chpipe.sh";
				
				close $ph;
				
			
			# ELSE IF SECOND CHANNEL TYPE IS "AVAILABLE", PRINT M3U LINE
			} elsif( defined $channels->{'qualities'}[1]{'availability'} ) {
				if( $channels->{'qualities'}[1]{'availability'} eq "available" ) {
					my $logo = $channels->{'qualities'}[1]{'logo_black_84'};
					$logo =~ s/84x48.png/210x120.png/g;
					
					print "#EXTINF:0001 tvg-id=\"" . $chid . "\" group-title=\"" . $group . "\" tvg-logo=\"https://images.zattic.com" . $logo . "\", " . $name . "\n";
					print "pipe://" . $main . "/chpipe/" . $alias . ".sh\n";
					
					# CREATE PIPE SCRIPT
					open(my $ph, '>', "$main/chpipe/$alias.sh");
					
					# BASIC LINES
					print $ph "#!/bin/bash\n";
					print $ph "cd $main\n";
					print $ph "session=\$(<user/session)\n";
					print $ph "curl -i -s -X POST -H \"Content-Type: application/x-www-form-urlencoded\" -H \"Accept: application/x-www-form-urlencoded\" --cookie \"\$session\" --data \"stream_type=hls&https_watch_urls=True&timeshift=10800\" https://$user/zapi/watch/live/$chid | grep \"{\" | sed 's/.*\"watch_urls\": \\[{\"url\": \"//g;s/\", .*//g;' > work/chlink && PIPE=\$(sed '/zahs/{s/https:/http:/g;s/zahs.tv.*/zahs.tv/g;s/\\//\\\\\\//g;};/akamaized/{s/https:/http:/g;s/akamaized.net.*/akamaized.net/g;s/\\//\\\\\\//g;}' work/chlink) && curl -s \$(<work/chlink) | \\\n";
					
					# QUALITY SETTING	
					if( $options =~ /chpipe 4/ ) {
						print $ph "grep -E \"live-8000|live-5000|live-3000|live-2999|live-1500\" | sed \"2,5d;s/.*/#\\!\\/bin\\/bash\\n\\/usr\\/bin\\/ffmpeg -loglevel fatal -i \$PIPE\\/& -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal -metadata service_name='$service' pipe:1/g;\" > chpipe.sh\n";
					} elsif( $options =~ /chpipe 3/ ) {
						print $ph "grep -E \"live-3000|live-2999|live-1500\" | sed \"2,5d;s/.*/#\\!\\/bin\\/bash\\n\\/usr\\/bin\\/ffmpeg -loglevel fatal -i \$PIPE\\/& -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal -metadata service_name='$service' pipe:1/g;\" > chpipe.sh\n";
					} elsif( $options =~ /chpipe 2/ ) {
						print $ph "grep -E \"live-1500\" | sed \"2,5d;s/.*/#\\!\\/bin\/bash\\n\\/usr\\/bin\\/ffmpeg -loglevel fatal -i \$PIPE\\/& -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal -metadata service_name='$service' pipe:1/g;\" > chpipe.sh\n";
					} elsif( $options =~ /chpipe 1/ ) {
						print $ph "grep -E \"live-900\" | sed \"2,5d;s/.*/#\\!\\/bin\/bash\\n\\/usr\\/bin\\/ffmpeg -loglevel fatal -i \$PIPE\\/& -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal -metadata service_name='$service' pipe:1/g;\" > chpipe.sh\n";
					} elsif( $options =~ /chpipe 0/ ) {
						print $ph "grep -E \"live-600\" | sed \"2,5d;s/.*/#\\!\\/bin\/bash\\n\\/usr\\/bin\\/ffmpeg -loglevel fatal -i \$PIPE\\/& -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal -metadata service_name='$service' pipe:1/g;\" > chpipe.sh\n";
					}
					
					print $ph "bash chpipe.sh";
					
					close $ph;
				}
			}
		}
	}
}
				

