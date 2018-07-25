using System;
using System.Globalization;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;

namespace SGSE.Common
{
    /// <summary>
    /// Proporciona métodos para el manejo general de una página
    /// </summary>
    public static class PageUtility
    {
        public static void AddMeta(Page page, string name, string content)
        {
            using (HtmlMeta htmlMeta = new HtmlMeta())
            {
                htmlMeta.Name = name;
                htmlMeta.Content = content;
                page.Header.Controls.Add(htmlMeta);
            }
        }

        private static string GetUserHostAddress()
        {
            string result = string.Empty;
            if (HttpContext.Current != null && HttpContext.Current.Request.UserHostAddress != null)
            {
                result = HttpContext.Current.Request.UserHostAddress;
            }
            return result;
        }

        private static HttpBrowserCapabilities GetBrowser()
        {
            if (HttpContext.Current != null && HttpContext.Current.Request.UserHostAddress != null)
            {
                return HttpContext.Current.Request.Browser;
            }
            return new HttpBrowserCapabilities();
        }

        public static string GetCurrentDomainName()
        {
            if (HttpContext.Current == null)
            {
                return string.Empty;
            }
            string text = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Host;
            if (HttpContext.Current.Request.Url.Port != 80)
            {
                text = text + ":" + HttpContext.Current.Request.Url.Port.ToString(CultureInfo.InvariantCulture);
            }
            return text;
        }

        public static string GetCurrentPageUrl(Page p)
        {
            if (p == null)
            {
                return string.Empty;
            }
            return p.Request.Url.AbsolutePath;
        }

        public static string GetUserIpAddress()
        {
            Page page = HttpContext.Current.Handler as Page;
            string Ip = HttpContext.Current.Request.UserHostAddress;

            if (page != null)
            {
                string text = page.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
                if (!string.IsNullOrEmpty(text))
                {
                    text = text.Split(new char[]
                    {
                        ','
                    })[0];
                }
                else
                {
                    text = page.Request.ServerVariables["REMOTE_ADDR"];
                }
                return text.Trim();
            }
            else
            {
                return Ip;
            }
        }

        public static void RefreshPage(Page page)
        {
            if (page != null)
            {
                page.Response.Redirect(page.Request.Url.AbsolutePath);
            }
        }

        public static string ResolveAbsoluteUrl(string relativeUrl)
        {
            if (HttpContext.Current != null)
            {
                return HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + VirtualPathUtility.ToAbsolute(relativeUrl);
            }
            return relativeUrl;
        }

    }
}
