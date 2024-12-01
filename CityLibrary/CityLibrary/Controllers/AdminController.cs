using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CityLibrary.Models;
using System.Data;
using System.Text.RegularExpressions;

namespace CityLibrary.Controllers
{
    public class AdminController : Controller
    {
        private CityLibraryAdminDAL dal = new CityLibraryAdminDAL();
        [HttpGet]
        public ActionResult Index()
        {
            return View();
        }        
        [HttpPost]
        public ActionResult Index(string adminId, string adminPass)
        {
            if (!String.IsNullOrEmpty(adminId) && !String.IsNullOrEmpty(adminPass))
            {
                string id = ConfigurationManager.AppSettings["adminId"].ToString();
                string pass = ConfigurationManager.AppSettings["adminPass"].ToString();
                if (adminId.Equals(id) && adminPass.Equals(pass))
                {
                    HttpContext.Session["adminId"] = adminId;
                    HttpContext.Session["readerName"] = null;
                    HttpContext.Session["readerId"] = null;
                    return RedirectToAction("Main");
                }
                else
                {
                    return View();
                }
            }
            else
            {
                return View();
            }
        }
        [HttpGet]
        public ActionResult Main()
        {
            if (HttpContext.Session["adminId"] == null)
            {
                return RedirectToAction("Index","Home");
            }
            return View();
        }
        [HttpGet]
        public ActionResult AddDocument()
        {
            if (HttpContext.Session["adminId"] == null)
            {
                return RedirectToAction("Index", "Home");
            }
            ViewBag.msg = null;
            return View();
        }
        [HttpPost]
        public ActionResult AddDocument(string docTitle, DateTime pdate,int publisherId, int libId, int copyno, string position)
        {
            string msg = "Some error occurred. Document is not added";
            msg = dal.AddDocument(docTitle, pdate.Date, publisherId, libId, copyno, position);
            ViewBag.msg = msg;
            return View();
        }
        [HttpGet]
        public ActionResult Search()
        {
            if (HttpContext.Session["adminId"] == null)
            {
                return RedirectToAction("Index", "Home");
            }
            ViewBag.msg = null;
            return View();
        }
        [HttpPost]
        public ActionResult Search(int docId, int libId, int copyno)
        {
                string msg = dal.CheckDocumentStatus(docId, libId, copyno);                
                ViewBag.msg = "Status: " + msg;
                return View();            
        }
        [HttpGet]
        public ActionResult AddReader()
        {
            if (HttpContext.Session["adminId"] == null)
            {
                return RedirectToAction("Index", "Home");
            }
            ViewBag.msg = null;
            return View();
        }
        [HttpPost]
        public ActionResult AddReader(string readerName, string type, string phoneNo, string address)
        {
            string pattern = "^[0-9]*$";
            Match match = Regex.Match(phoneNo, pattern);
            if (readerName.Length > 20)
            {
                ViewBag.msg = "Reader name is too long";
                return View();
            }
            else if (match.Success == false)
            {
                ViewBag.msg = "Invalid phone no. Besure to enter ''+1''";
                return View();
            }
            else if (address.Length > 50)
            {
                ViewBag.msg = "Too long address";
                return View();
            }
            else
            {
                ViewBag.msg = dal.AddReader(readerName, type, phoneNo, address);
                return View();
            }
        }
        [HttpGet]
        public ActionResult BranchInfo()
        {
            if (HttpContext.Session["adminId"] == null)
            {
                return RedirectToAction("Index", "Home");
            }
            ViewBag.msg = null;
            return View();
        }
        [HttpPost]
        public ActionResult BranchInfo(int? libId)
        {
            DataTable dt = new DataTable();
            dt = dal.GetBranchesInfo(libId);
            return View("Branch_Information", dt);
        }
        [HttpGet]
        public ActionResult FrequentBorrowers()
        {
            if (HttpContext.Session["adminId"] == null)
            {
                return RedirectToAction("Index", "Home");
            }
            return View("Frequent_Borrowers");
        }
        [HttpPost]
        public ActionResult FrequentBorrowers(int libId)
        {
            DataTable dt = new DataTable();
            dt = dal.GetTopBorrowers(libId);
            return View(dt);
        }
        [HttpGet]
        public ActionResult MostBorrowedBooks()
        {
            if (HttpContext.Session["adminId"] == null)
            {
                return RedirectToAction("Index", "Home");
            }
            return View();
        }
        [HttpPost]
        public ActionResult MostBorrowedBooks(int libId)
        {
            DataTable dt = new DataTable();
            dt = dal.GetTopBorrowedBooks(libId);
            return View("Most_Borrowed_Books",dt);
        }
        [HttpGet]
        public ActionResult MostPopularbooks()
        {
            if (HttpContext.Session["adminId"] == null)
            {
                return RedirectToAction("Index", "Home");
            }
            return View();
        }
        [HttpPost]
        public ActionResult MostPopularbooks(int year)
        {
            DataTable dt = new DataTable();
            dt = dal.GetMostPopularBooks(year);
            ViewBag.year = year;
            return View("Most_Popular_Books", dt);
        }
        [HttpGet]
        public ActionResult AverageFine()
        {
            if (HttpContext.Session["adminId"] == null)
            {
                return RedirectToAction("Index", "Home");
            }
            DataTable dt = dal.GetAvgFinePerReader();
            return View(dt);
        }
        public ActionResult Quit()
        {
            HttpContext.Session["adminId"] = null;
            return RedirectToAction("Index", "Home");
        }
	}
}