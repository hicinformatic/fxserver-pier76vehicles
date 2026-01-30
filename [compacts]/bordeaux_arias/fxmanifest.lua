fx_version 'cerulean'
game 'gta5'

description 'Bordeaux ARIAS (spawn: arias)'
author '12Stewartc'
version '1.0.0'

files {
    'carcols.meta',
    'carvariations.meta',
    'handling.meta',
    'vehicles.meta',
    'dlctext.meta',
    'audioconfig/*.dat151.rel',
    'audioconfig/*.dat54.rel',
    'sfx/**/*.awc',
}

data_file 'VEHICLE_METADATA_FILE' 'vehicles.meta'
data_file 'CARCOLS_FILE' 'carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'carvariations.meta'
data_file 'HANDLING_FILE' 'handling.meta'
data_file 'DLCTEXT_FILE' 'dlctext.meta'
data_file 'AUDIO_GAMEDATA' 'audioconfig/arias_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/arias_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_stewarias'
