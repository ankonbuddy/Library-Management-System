using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CityLibrary.Controllers
{
    public class HomeController : Controller
    {
        //
        // GET: /Home/
        public ActionResult Index()
        {
            HttpContext.Session["adminId"] = null;
            HttpContext.Session["readerName"] = null;
            HttpContext.Session["readerId"] = null;
            return View();
        }
	}
}