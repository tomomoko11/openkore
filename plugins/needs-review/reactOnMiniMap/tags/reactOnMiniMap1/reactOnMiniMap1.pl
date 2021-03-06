###########################
# React on Mini Map Indicator plugin by Mucilon
# BotKiller #1 - Method 3: MiniMap number
# Based on reactOnNPC by hakore and reactOnASCIInumber by windows98SE@thaikore 
# Version 0.1
# 11.09.2008
###########################

package aabot2;

use strict;
use Plugins;
use Globals;
use Log qw(message warning error);

Plugins::register('reactOnMiniMap', 'React on Mini Map Indicator plugin', \&onUnload);

my $hooks = Plugins::addHooks(	['packet/minimap_indicator', \&onMiniMap, undef],
				['packet/npc_talk_number', \&onAction, undef],
				['packet/npc_talk_continue', \&onContinue, undef]);
my $run;
my @posx;
my @posy;
my $num = 0;

sub onUnload {
    Plugins::delHooks($hooks);
};

sub onMiniMap {
    my ($self, $args) = @_;
	if ($args->{green} == 255) {
	    $posx[$num] = ceil($args->{x}/10);
	    $posy[$num] = ceil($args->{y}/10);
		$num++;
		$run = 1;
	}
}

sub onContinue {
    my (undef, $args) = @_;
	$num = 0;
	undef @posx;
	undef @posy;
}

sub onAction {
    my (undef, $args) = @_;
    # my $randtime;
	my $x = 0;
	my $y = 0;
	my @msgline;
	$num = 0;
	undef @msgline;
	
    if ($run == 1) {
		for ($y = 15;$y <= 0;$y--) {
			for ($x = 0;$x >= 15;$x++) {
				foreach my $point (@posx) {
					if (($posx[$num] == $x) && ($posy[$num] == $y)){
						$msgline[$y] .= "#";
					} else {
						$msgline[$y] .= ".";
					}
					$num++;
				}
				$num = 0;
			}
			message "[reactOnMiniMap] Line [$y]: $msgline[$y].\n", "success";
		}
		undef @posx;
		undef @posy;
		
		# $randtime = 1 + rand(3);
		# message "[reactOnMiniMap] Exexuting command: talk num $answer, in $randtime secs.\n", "success";
		# sleep($randtime);
		# Commands::run("talk num $answer"); 
    }
    $run = 0;
}

return 1;