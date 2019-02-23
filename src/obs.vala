using Posix;
using Soup;
using Xml;
using Xml.XPath;

namespace Zbv {
    public class Obs : GLib.Object {
        private static string getResults(string package = "zyp") {
            // Define some variables and make objects
            Soup.Session session = new Soup.Session ();
            var builder = new StringBuilder ();
            int counter = 0;
            
            // Create a URL string for the search
            builder.append ("https://api.opensuse.org/search/published/binary/id?match=%40name%3D%27");
            builder.append (package);
            builder.append ("%27");

            // Prepare a message using the URL
            Soup.Message message = new Soup.Message ("GET", builder.str);
            
            // Prepare for authentication
            session.authenticate.connect ((msg, auth, retrying) => {
               if (counter < 1) {
                   if (retrying == true) {
                       print ("Invalid or no username or password.\n");
                   }
                   auth.authenticate(Zbv.Config.get_username (), Zbv.Config.get_password ());
                   counter++;
               } 
            });
            session.send_message(message);
            return (string) message.response_body.data;
        }
        public static void search(string package = "zyp") {
    
            
          
            
            // Let the user know we're sending the message.
            GLib.stdout.printf ("Getting results for %s\n", package);
            
            // Get the results and parse them
            string results = Zbv.Obs.getResults(package);
            print(results);
            Xml.Doc* doc = Parser.parse_doc(results);

            Zbv.Binary[] binaries = Zbv.BinaryParser.get_binaries(doc);
            foreach(Zbv.Binary bin in binaries) {
                if (Zbv.Config.get_os() == Zbv.Version.TUMBLEWEED) {
                    if (bin.repository.contains("Tumbleweed")) {
                        print("\n" + bin.name + " / " + bin.project + "\n\n");
                    }
                }
            }   
        }
    }
    public class BinaryParser : GLib.Object {
        public static Zbv.Binary[] get_binaries(Xml.Doc* doc) {
            Zbv.Binary[] bins = {};
            Xml.Node* root = doc->get_root_element ();
            for (Xml.Node* iter = root->children; iter != null; iter = iter->next) {
                if (iter->type != ElementType.ELEMENT_NODE) {
                    continue;
                }
                bins += new Zbv.Binary(iter->get_prop("name"), iter->get_prop("project"), iter->get_prop("package"), iter->get_prop("repository"), iter->get_prop("version"), iter->get_prop("release"), iter->get_prop("arch"), iter->get_prop("filename"), iter->get_prop("filepath"), iter->get_prop("baseproject"), iter->get_prop("type"));
            }
            return bins;
        }
    }
    public class Binary : GLib.Object {
        public string name { get; set; }
        public string project { get; set; }
        public string package { get; set; }
        public string repository { get; set; }
        public string version { get; set; }
        public string release { get; set; }
        public string arch { get; set; }
        public string filename { get; set; }
        public string filepath { get; set; }
        public string baseproject { get; set; }
        public string pkgtype { get; set; }
        public Binary(string name, string project, string package, string repository, string version, string release, string arch, string filename, string filepath, string baseproject, string type) {
            this.name = name;
            this.project = project;
            this.package = package;
            this.repository = repository;
            this.version = version;
            this.release = release;
            this.arch = arch;
            this.filename = filename;
            this.filepath = filepath;
            this.baseproject = baseproject;
            this.pkgtype = type;
        } 
    }   
}
