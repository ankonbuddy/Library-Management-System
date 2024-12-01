using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Linq;
using System.Web;

namespace CityLibrary.Models
{
    public class CityLibraryDAL
    {
        static string connectionString = ConfigurationManager.ConnectionStrings["conString"].ToString();
        SqlConnection con = new SqlConnection(connectionString);
        public String GetReaderById(int id)
        {
            String readerName = null;
            SqlCommand cmd = new SqlCommand("SELECT ReaderName FROM Reader WHERE Reader_id=@id",con);
            cmd.Parameters.AddWithValue("@id", id);
            try
            {
                con.Open();
                readerName = cmd.ExecuteScalar().ToString();
            }
            catch (Exception)
            {
                readerName = null;
            }
            finally
            {
                cmd.Dispose();
                con.Close();
            }
            return readerName;
        }

        public DataTable Search(int? docId, string docTitle, string pubName)
        {
            DataTable dt = new DataTable();
            SqlCommand cmd = null;            
            if (docId != null && String.IsNullOrEmpty(docTitle) && String.IsNullOrEmpty(pubName))
            {
                cmd = new SqlCommand("SELECT DocId,Title,Pdate,Pub_Name FROM Document D inner join Publisher P ON D.PublisherID = P.Publisher_id WHERE DocId=@docId", con);
                cmd.Parameters.AddWithValue("@docId", docId);                    
            }
            else if (docId == null && !String.IsNullOrEmpty(docTitle) && String.IsNullOrEmpty(pubName))
            {
                cmd = new SqlCommand("SELECT DocId,Title,Pdate,Pub_Name FROM Document D inner join Publisher P ON D.PublisherID = P.Publisher_id WHERE Title=@docTitle", con);
                cmd.Parameters.AddWithValue("@docTitle", docTitle);
            }
            else if (docId == null && String.IsNullOrEmpty(docTitle) && !String.IsNullOrEmpty(pubName))
            {
                cmd = new SqlCommand("SELECT DocId,Title,Pdate,Pub_Name FROM Document D inner join Publisher P ON D.PublisherID = P.Publisher_id WHERE Pub_Name=@pubName", con);
                cmd.Parameters.AddWithValue("@pubName", pubName);
            }
            else if (docId == null && !String.IsNullOrEmpty(docTitle) && !String.IsNullOrEmpty(pubName))
            {
                cmd = new SqlCommand("SELECT DocId,Title,Pdate,Pub_Name FROM Document D inner join Publisher P ON D.PublisherID = P.Publisher_id WHERE Pub_Name=@pubName AND Title=@docTitle", con);
                cmd.Parameters.AddWithValue("@pubName", pubName);
                cmd.Parameters.AddWithValue("@docTitle", docTitle);

            }
            else if (docId != null && String.IsNullOrEmpty(docTitle) && !String.IsNullOrEmpty(pubName))
            {
                cmd = new SqlCommand("SELECT DocId,Title,Pdate,Pub_Name FROM Document D inner join Publisher P ON D.PublisherID = P.Publisher_id WHERE Pub_Name=@pubName AND DocId=@docId", con);
                cmd.Parameters.AddWithValue("@pubName", pubName);
                cmd.Parameters.AddWithValue("@docId", docId);
            }
            else if (docId != null && !String.IsNullOrEmpty(docTitle) && !String.IsNullOrEmpty(pubName))
            {
                cmd = new SqlCommand("SELECT DocId,Title,Pdate,Pub_Name FROM Document D inner join Publisher P ON D.PublisherID = P.Publisher_id WHERE Pub_Name=@pubName AND DocId=@docId AND Title=@docTitle", con);
                cmd.Parameters.AddWithValue("@pubName", pubName);
                cmd.Parameters.AddWithValue("@docId", docId);
                cmd.Parameters.AddWithValue("@docTitle", docTitle);
            }
            else if (docId != null && !String.IsNullOrEmpty(docTitle) && String.IsNullOrEmpty(pubName))
            {
                cmd = new SqlCommand("SELECT DocId,Title,Pdate,Pub_Name FROM Document D inner join Publisher P ON D.PublisherID = P.Publisher_id WHERE Title=@docTitle AND DocId=@docId", con);
                cmd.Parameters.AddWithValue("@docTitle", docTitle);
                cmd.Parameters.AddWithValue("@docId", docId);
            }
            else
            {
                return null;
            }
            try
            {
                con.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dt);
            }
            catch (Exception)
            {
                dt = null;                                
            }            
            return dt;
        }

        public int DocumentCheckout(int readerId, int docId, int copyNo, int libId)
        {
            int result = -2;
            SqlCommand cmd = new SqlCommand("spCheckout", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@readerId", readerId);
            cmd.Parameters.AddWithValue("@docId", docId);
            cmd.Parameters.AddWithValue("@copyNo", copyNo);
            cmd.Parameters.AddWithValue("@libId", libId);
            var resultParam = cmd.Parameters.Add("@result",SqlDbType.Int);
            resultParam.Direction = ParameterDirection.Output;
            try
            {
                con.Open();
                cmd.ExecuteNonQuery();
                result = Convert.ToInt32(resultParam.Value);
            }
            catch (Exception)
            {
                result = -2;
            }
            finally
            {
                con.Close();
            }            
            return result;
        }

        public int DocumentReturn(int readerId, int docId, int copyNo, int libId)
        {
            int result = -2;
            SqlCommand cmd = new SqlCommand("spReturn", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@readerId", readerId);
            cmd.Parameters.AddWithValue("@docId", docId);
            cmd.Parameters.AddWithValue("@copyNo", copyNo);
            cmd.Parameters.AddWithValue("@libId", libId);
            var resultParam = cmd.Parameters.Add("@result", SqlDbType.Int);
            resultParam.Direction = ParameterDirection.Output;
            try
            {
                con.Open();
                cmd.ExecuteNonQuery();
                result = Convert.ToInt32(resultParam.Value);
            }
            catch (Exception)
            {
                result = -2;
            }
            finally
            {
                con.Close();
            }
            return result;
        }

        public DataTable GetDocumentDetailsFromTitle(string docTitle)
        {
            DataTable dt = new DataTable();
            SqlCommand cmd = new SqlCommand("SELECT D.DocID, Title, Pub_Name, C.LibId, Name, CopyNo from Document D inner join Copy C on D.DocId=C.DocID inner join Publisher P on D.PublisherID=P.Publisher_id inner join Branch B ON B.Libid=C.LibId WHERE Title=@docTitle", con);
            cmd.Parameters.AddWithValue("@docTitle",docTitle);
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            try
            {
                con.Open();
                adapter.Fill(dt);
            }
            catch (Exception)
            {
                                
            }
            return dt;
        }

        public int DocumentReserve(int readerId, int docId, int copyNo, int libId, DateTime resDate)
        {
            int result = -3;
            SqlCommand cmd = new SqlCommand("spReserve", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@readerId", readerId);
            cmd.Parameters.AddWithValue("@docId", docId);
            cmd.Parameters.AddWithValue("@copyNo", copyNo);
            cmd.Parameters.AddWithValue("@libId", libId);
            cmd.Parameters.AddWithValue("@resDate", resDate.Date);
            var resultParam = cmd.Parameters.Add("@result", SqlDbType.Int);
            resultParam.Direction = ParameterDirection.Output;
            try
            {
                con.Open();
                cmd.ExecuteNonQuery();
                result = Convert.ToInt32(resultParam.Value);
            }
            catch (Exception)
            {
                result = -3;
            }
            finally
            {
                con.Close();
            }
            return result;
        }

        public string GetFine(int readerId, int docId, int copyNo, int libId)
        {
            string fine = null;
            SqlCommand cmd = new SqlCommand("select MAX(BorDateTime) from BOR_Transaction BT inner join Borrows B on BT.BorNumber=B.BorNumber where ReaderId=@readerID and DocID=@docId and Copyno=@copyNo and LibId=@libId and RetDateTime is null", con);
            cmd.Parameters.AddWithValue("@readerID", readerId);
            cmd.Parameters.AddWithValue("@docId", docId);
            cmd.Parameters.AddWithValue("@copyNo", copyNo);
            cmd.Parameters.AddWithValue("@libId", libId);
            try
            {
                con.Open();
                object d = cmd.ExecuteScalar();
                if (d is DBNull)
                {
                    fine = "You either have not borrowed this book or have already returned it.";
                }
                else
                {
                    DateTime dt = (DateTime)d;
                    int days = (DateTime.Today - dt).Days;
                    if (days > 20)
                    {
                        fine = ((days - 20) * 20).ToString();
                    }
                    else
                    {
                        fine = "No Fine";
                    }
                }
            }
            catch (Exception e)
            {
                fine = "Some error occurred";
            }
            finally
            {
                con.Close();
            }
            return fine;
        }

        public DataTable ReservedDocuments(int readerId)
        {
            DataTable dt = new DataTable();
            SqlCommand cmd = new SqlCommand("spGetReservedDocs", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@readerId", readerId);
            try
            {
                con.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dt);
            }
            catch (Exception)
            {
                dt = null;
            }
            return dt;
        }

        public DataTable GetDocuments(string pubName)
        {
            DataTable dt = new DataTable();            
            SqlCommand cmd = new SqlCommand("select DocId,Title from Document D inner join Publisher P on D.PublisherID=P.Publisher_id where Pub_Name = @pubName", con);
            cmd.Parameters.AddWithValue("@pubName", pubName);
            try
            {
                con.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dt);
            }
            catch (Exception)
            {
                dt = null;
            }
            return dt;
        }
    }
}