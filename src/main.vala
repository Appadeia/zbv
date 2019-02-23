/* main.vala
 *
 * Copyright 2019 Carson Black
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
using Posix;
using GLib;
using Soup;

public class Main : Object {
    public static string install;
    public static string search;
    public static GLib.OptionContext opts;
    private const GLib.OptionEntry[] options = {
		// --install
		{"install", 'i', 0, OptionArg.STRING, ref install, "Install application", null},
        
        // --search
        {"search", 's', 0, OptionArg.STRING, ref search, "Install application", null},
		// list terminator
		{ null }
	};
	public static int main (string[] args) 
	{
	    int count = args.length;
	    Zbv.Config.get_os();
		try {
			opts = new OptionContext ("- useless zypper wrapper that i'm writing to learn vala");
			opts.set_help_enabled (true);
			opts.add_main_entries (options, null);
			opts.parse (ref args);
		} catch (OptionError e) {
			print ("error: %s\n", e.message);
			print ("Run '%s --help' to see a full list of available command line options.\n", args[0]);
			return 0;
		}
		if (count == 1) {
	        print ("Run '%s --help' to see a full list of available command line options.\n", args[0]);
		    return 0;
		}
		int flags = 0;
		if (install != null) {
		    flags++;
		}
		if (search != null) {
		    flags++;
		}
		if (flags != 1) {
		    print ("Error: too many arguments.\n");
		    print ("Run '%s --help' to see a full list of available command line options.\n", args[0]);
		}
		if (search != null) {
		    Zbv.Obs.search(search);
		}
	    return 0;
	}
}
