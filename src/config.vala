using Posix;
namespace Zbv {
    enum Version {
        TUMBLEWEED,
        LEAP_15,
        LEAP_42,
        ERROR
    }
    class Config : Object {
        public static string get_username () {
            return "username";
        }
        public static string get_password () {
            return "password";
        }
        public static Zbv.Version get_os() {
            Posix.system("""
cat /etc/os-release | grep -i name | cut -d = -f2 | head -n 1 > /tmp/version
            """);
            var file = File.new_for_path ("/tmp/version");
            if (!file.query_exists ()) {
                GLib.stderr.printf ("File '%s' doesn't exist.\n", file.get_path ());
                return Zbv.Version.ERROR;
            }
            string[] lines = {};
            try {
                var dis = new DataInputStream (file.read ());
                string line;
                while ((line = dis.read_line (null)) != null) {
                    lines += line;
                }
            } catch (Error e) {
                error ("%s", e.message);
            }
            if (lines[0].contains ("Tumbleweed")) {
                return Zbv.Version.TUMBLEWEED;
            } else if (lines[0].contains ("")) {
                
            }
            return Zbv.Version.ERROR;
        }
    }
}
