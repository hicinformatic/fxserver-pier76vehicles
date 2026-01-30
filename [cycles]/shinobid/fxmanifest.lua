
fx_version 'cerulean'
game 'gta5'

client_script 'client.lua'

files {
	'data/**/carcols.meta',
	'data/**/carvariations.meta',
	'data/**/handling.meta',
	'data/**/vehiclelayouts.meta',
	'data/**/vehicles.meta',
	'data/**/dlctext.meta',
	'audioconfig/*.dat151.rel',
	'audioconfig/*.dat54.rel',
	'sfx/**/*.awc'
}

data_file 'HANDLING_FILE' 'data/**/handling.meta'
data_file 'DLC_TEXT_FILE' 'data/**/dlctext.meta'
data_file 'VEHICLE_METADATA_FILE' 'data/**/vehicles.meta'
data_file 'CARCOLS_FILE' 'data/**/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/**/carvariations.meta'
data_file 'VEHICLE_LAYOUTS_FILE' 'data/**/vehiclelayouts.meta'
data_file 'AUDIO_GAMEDATA' 'audioconfig/shinobid_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/shinobid_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_shinobid'
client_script 'vehicle_names.lua'