#!/usr/bin/perl

# obmenu-generator - schema file

=for comment

    item:      add an item inside the menu               {item => ["command", "label", "icon"]},
    cat:       add a category inside the menu             {cat => ["name", "label", "icon"]},
    sep:       horizontal line separator                  {sep => undef}, {sep => "label"},
    pipe:      a pipe menu entry                         {pipe => ["command", "label", "icon"]},
    file:      include the content of an XML file        {file => "/path/to/file.xml"},
    raw:       any XML data supported by Openbox          {raw => q(...)},
    beg:       begin of a category                        {beg => ["name", "icon"]},
    end:       end of a category                          {end => undef},
    obgenmenu: generic menu settings                {obgenmenu => ["label", "icon"]},
    exit:      default "Exit" action                     {exit => ["label", "icon"]},

=cut

# NOTE:
#    * Keys and values are case sensitive. Keep all keys lowercase.
#    * ICON can be a either a direct path to an icon or a valid icon name
#    * Category names are case insensitive. (X-XFCE and x_xfce are equivalent)

require "$ENV{HOME}/.config/obmenu-generator/config.pl";

## Text editor
my $editor = $CONFIG->{editor};

our $SCHEMA = [

    #          COMMAND                 LABEL              ICON
    {item => ['thunar .',       'File Manager', 'system-file-manager']},
    {item => ['kitty',            'Terminal',     'utilities-terminal']},
    {item => ['xdg-open http://', 'Browser',  'web-browser']},
    {item => ['obconf-qt',            'Settings',  'obconf-qt']},
    {item => ['lxappearance',            'Themes',  'preferences-desktop-theme']},
    {item => ['walper',            'Wallpaper',  'preferences-desktop-wallpaper']},

    {sep => undef},

    #          NAME            LABEL                ICON
    {cat => ['utility',     'Accessories', 'applications-utilities']},
    {cat => ['development', 'Development', 'applications-development']},
    {cat => ['education',   'Education',   'applications-science']},
    {cat => ['game',        'Games',       'applications-games']},
    {cat => ['graphics',    'Graphics',    'applications-graphics']},
    {cat => ['audiovideo',  'Multimedia',  'applications-multimedia']},
    {cat => ['network',     'Network',     'applications-internet']},
    {cat => ['office',      'Office',      'applications-office']},
    {cat => ['other',       'Other',       'applications-other']},
    {cat => ['settings',    'Settings',    'applications-accessories']},
    {cat => ['system',      'System',      'applications-system']},

    #             LABEL          ICON
    #{beg => ['My category',  'cat-icon']},
    #          ... some items ...
    #{end => undef},

    #            COMMAND     LABEL        ICON
    #{pipe => ['obbrowser', 'Disk', 'drive-harddisk']},

    ## Generic advanced settings
    #{sep       => undef},
    #{obgenmenu => ['Openbox Settings', 'applications-engineering']},
    #{sep       => undef},

    ## Custom advanced settings
    {sep => undef},
    {beg => ['Advanced Settings', 'applications-engineering']},

      # obmenu-generator category
      {beg => ['Obmenu-Generator', 'accessories-text-editor']},
        {item => ["$editor ~/.config/obmenu-generator/schema.pl", 'Menu Schema', 'text-x-generic']},
        {item => ["$editor ~/.config/obmenu-generator/config.pl", 'Menu Config', 'text-x-generic']},

        {sep  => undef},
        {item => ['obmenu-generator -s -c',    'Generate a static menu',             'accessories-text-editor']},
        {item => ['obmenu-generator -s -i -c', 'Generate a static menu with icons',  'accessories-text-editor']},
        {sep  => undef},
        {item => ['obmenu-generator -p',       'Generate a dynamic menu',            'accessories-text-editor']},
        {item => ['obmenu-generator -p -i',    'Generate a dynamic menu with icons', 'accessories-text-editor']},
        {sep  => undef},

        {item => ['obmenu-generator -d', 'Refresh cache', 'view-refresh']},
      {end => undef},

      # Openbox category
      {beg => ['Openbox', 'openbox']},
        {item => ["$editor ~/.config/openbox/autostart", 'Openbox Autostart',   'text-x-generic']},
        {item => ["$editor ~/.config/openbox/rc.xml",    'Openbox RC',          'text-x-generic']},
        {item => ["$editor ~/.config/openbox/menu.xml",  'Openbox Menu',        'text-x-generic']},
        {item => ['openbox --reconfigure',               'Reconfigure Openbox', 'openbox']},
        {item => ['openbox --restart',               'Restart Openbox', 'openbox']},
      {end => undef},
      
      # Theme
      {beg => ['Theme', 'tint2']},
        {item => ["$editor ~/.scripts/autocolorscheme.sh", 'Edit Adaptive theme', 'text-x-generic']},
        {item => ["$editor ~/.scripts/ricing.sh", 'Edit Ricing Mode', 'text-x-generic']},
        {sep  => undef},
        {item => ['~/.scripts/ricing.sh normal',               'Normal Mode', 'system-run']},
        {item => ['~/.scripts/ricing.sh rice',               'Ricing Mode', 'system-run']},
        {sep  => undef},
        {item => ['~/.scripts/colorscheme_context.sh enable',               'Enable adaptive theme', 'tint2']},
        {item => ['~/.scripts/colorscheme_context.sh disable',               'Disable adaptive theme', 'tint2']},
        {item => ['~/.scripts/colorscheme.sh',               'Refresh theme', 'tint2']},
      {end => undef},
    {end => undef},

    {sep => undef},

	## The refresh screen command
    {item => ['~/.scripts/display.sh', 'Refresh Display', 'preferences-desktop-theme']},
    
    ## The task manager command
    {item => ['missioncenter', 'Task manager', 'io.missioncenter.MissionCenter']},
    
    ## This uses the 'oblogout' menu
    {item => ['archlinux-logout', 'Power', 'application-exit']},
]
