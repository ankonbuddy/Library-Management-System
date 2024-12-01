using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CityLibrary.Models;
using System.Data;

namespace CityLibrary.Controllers
{
    public class UserController : Controller
    {
        private CityLibraryDAL dal = new CityLibraryDAL();
        [HttpGet]
        public ActionResult Index()
        {
            return View();
        }        
        [HttpPost]
        public ActionResult Index(int? cardno)
        {
            
            if (cardno != null)
            {
                int readerId = cardno??default(int);
                String readerName = dal.GetReaderById(readerId);
                if (!String.IsNullOrEmpty(readerName))
                {
                    HttpContext.Session["readerId"] = readerId;
                    HttpContext.Session["readerName"] = readerName;
                    HttpContext.Session["adminId"] = null;
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
            if (HttpContext.Session["readerName"] == null)
            {
                return RedirectToAction("Index", "Home");
            }
            else
            {
                return View();
            }            
        }
        [HttpGet]
        public ActionResult Search()
        {
            if (HttpContext.Session["readerName"] == null)
            {
                return RedirectToAction("Index", "Home");
            }
            else
            {
                return View();
            }
        }
        [HttpPost]
        public ActionResult Search(int? docId, string docTitle, string pubName)
        {
            DataTable dt = new DataTable();
            dt = dal.Search(docId, docTitle, pubName);
            if (dt != null)
            {
                return View("Search_Result",dt);    
            }
            else
            {
                return RedirectToAction("Search","User");
            }
        }
        [HttpGet]
        public ActionResult DocumentCheckout()
        {
            if (HttpContext.Session["readerName"] == null)
            {
                return RedirectToAction("Index", "Home");
            }
            ViewBag.msg = null;
            return View("Document_Checkout");
        }
        [HttpPost]
        public ActionResult DocumentCheckout(int docId, int copyNo, int libId)
        {
            int result = dal.DocumentCheckout(Convert.ToInt32(HttpContext.Session["readerId"]), docId, copyNo, libId);
            if (result > 0)
            {
                ViewBag.msg = "Document checkout: Success Borrow-Transaction no: " + result;
                return View("Document_Checkout");
            }
            else if (result == 0)
            {
                ViewBag.msg = "Document has been borrowed or reserved by another reader";
                return View("Document_Checkout");
            }
            else if(result == -1)
            {
                ViewBag.msg = "Cannot find requested document";
                return View("Document_Checkout");
            }
            else
            {
                ViewBag.msg = "Some Error Occurred";
                return View("Document_Checkout");
            }            
        }
        [HttpGet]
        public ActionResult DocumentReturn()
        {
            if (HttpContext.Session["readerName"] == null)
            {
                return RedirectToAction("Index", "Home");
            }
            return View();
        }
        [HttpPost]
        public ActionResult DocumentReturn(int docId, int copyNo, int libId)
        {
            int result = dal.DocumentReturn(Convert.ToInt32(HttpContext.Session["readerId"]), docId, copyNo, libId);
            if (result == 1)
            {
                ViewBag.msg = "Document return: Success";
                return View("Document_Checkout");
            }
            else if (result == 0)
            {
                ViewBag.msg = "Error occurred: Found multiple records.";
                return View("Document_Checkout");
            }
            else if (result == -1)
            {
                ViewBag.msg = "Error: You did not borrowed this document.";
                return View("Document_Checkout");
            }
            else
            {
                ViewBag.msg = "Some Error Occurred";
                return View("Document_Checkout");
            }
        }
        [HttpGet]
        public ActionResult DocumentReserve()
        {
            if (HttpContext.Session["readerName"] == null)
            {
                return RedirectToAction("Index", "Home");
            }
            ViewBag.msg = null;
            return View();
        }
        [HttpPost]
        public ActionResult DocDetails(string docTitle)
        {
            DataTable dt = new DataTable();
            dt = dal.GetDocumentDetailsFromTitle(docTitle);
            return View(dt);
        }
        [HttpPost]
        public ActionResult DocumentReserve(int docId, int copyNo, int libId, DateTime resDate)
        {
            int result = dal.DocumentReserve(Convert.ToInt32(HttpContext.Session["readerId"]), docId, copyNo, libId, resDate);
            if (result > 0)
            {
                ViewBag.msg = "Document checkout: Success Reservation no: " + result;
                return View();
            }
            else if (result == 0)
            {
                ViewBag.msg = "You have exceeded reservation limit: 10";
                return View();
            }
            else if (result == -1)
            {
                ViewBag.msg = "Document has been borrowed or reserved by another reader";
                return View();
            }
            else if (result == -2)
            {
                ViewBag.msg = "Cannot find requested document";
                return View();
            }
            else
            {
                ViewBag.msg = "Some Error Occurred";
                return View();
            }
        }
        [HttpGet]
        public ActionResult FinesDue()
        {
            if (HttpContext.Session["readerName"] == null)
            {
                return RedirectToAction("Index", "Home");
            }
            ViewBag.msg = null;
            return View();
        }
        [HttpPost]
        public ActionResult FinesDue(int docId, int copyNo, int libId)
        {
            ViewBag.msg = dal.GetFine(Convert.ToInt32(HttpContext.Session["readerId"]), docId, copyNo, libId);
            return View();
        }
        [HttpGet]
        public ActionResult ReservedDocuments()
        {
            if (HttpContext.Session["readerName"] == null)
            {
                return RedirectToAction("Index", "Home");
            }
            DataTable dt = new DataTable();
            dt = dal.ReservedDocuments(Convert.ToInt32(HttpContext.Session["readerId"]));
            return View(dt);
        }
        [HttpGet]
        public ActionResult DocumentsFromPublisher()
        {
            if (HttpContext.Session["readerName"] == null)
            {
                return RedirectToAction("Index", "Home");
            }           
            return View();
        }
        [HttpPost]
        public ActionResult DocumentsFromPublisher(string pubName)
        {
            DataTable dt = new DataTable();
            dt = dal.GetDocuments(pubName);
            return View("Documents_From_Publisher",dt);
        }        
        public ActionResult Quit()
        {
            HttpContext.Session["readerName"] = null;
            HttpContext.Session["readerId"] = null;
            return RedirectToAction("Index", "Home");
        }
	}
}