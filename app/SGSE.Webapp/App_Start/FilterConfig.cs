using Parqueo.Webapp.App_Filters;
using System.Web.Mvc;

namespace SGSE.Webapp
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new MessagesActionFilter());
            filters.Add(new HandleErrorAttribute());
        }
    }
}
