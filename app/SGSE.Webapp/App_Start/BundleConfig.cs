using System.Web.Optimization;

namespace SGSE.Webapp
{
    public class BundleConfig
    {
        public static void RegisterBundles(BundleCollection bundles)
        {
            // CSS Base
            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/css/vendor.min.css",
                      "~/Content/css/baboon.min.css",
                      "~/Content/css/application.min.css",
                      "~/Content/vendor/splashy/splashy.min.css"));

            // CSS Login
            bundles.Add(new StyleBundle("~/Content/login").Include(
                      "~/Content/css/login.css"));

            // CSS Error
            bundles.Add(new StyleBundle("~/Content/error").Include(
                      "~/Content/css/vendor.min.css",
                      "~/Content/css/baboon.min.css",
                      "~/Content/css/application.min.css",
                      "~/Content/css/errors.min.css"));

            // Scripts 
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));
            
            // Scripts base
            bundles.Add(new ScriptBundle("~/bundles/scripts-base").Include(
                        "~/Scripts/base/vendor.min.js",
                        "~/Scripts/base/baboon.min.js"));

            // Scripts app 
            bundles.Add(new ScriptBundle("~/bundles/scripts-app").Include(
                        "~/Scripts/base/vendor.min.js",
                        "~/Scripts/base/baboon.min.js",
                        "~/Scripts/base/application.min.js"));

        }
    }
}
