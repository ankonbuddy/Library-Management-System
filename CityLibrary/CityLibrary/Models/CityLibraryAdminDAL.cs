using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Text.RegularExpressions;
using System.Linq;
using System.Web;

namespace CityLibrary.Models
{
    public class CityLibraryAdminDAL
    {
        static string connectionString = ConfigurationManager.ConnectionStrings["conString"].ToString();
        SqlConnection con = new SqlConnection(connectionString);

        public string AddDocument(string docTitle, DateTime pdate, int publisherId, int libId, int copyno, string position)
        {
            string status = "Some error occured";
            Match result = Regex.Match(position, @"");
            if (result.Success)
            {
                SqlCommand cmd = new SqlCommand("spAddDocument", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@docTitle", docTitle);
                cmd.Parameters.AddWithValue("@pdate", pdate.Date);
                cmd.Parameters.AddWithValue("@pubid", publisherId);
                cmd.Parameters.AddWithValue("@libid", libId);
                cmd.Parameters.AddWithValue("@copyno", copyno);
                cmd.Parameters.AddWithValue("@position", position);
                var outparam = cmd.Parameters.AddWithValue("@status", DbType.Int32);
                outparam.Direction = ParameterDirection.Output;
                try
                {
                    con.Open();
                    cmd.ExecuteNonQuery();
                    int value = Convert.ToInt32(outparam.Value);
                    if (value == 1)
                    {
                        status = "Document added successfully";
                    }
                    else if (value == 0)
                    {
                        status = "Publisher doesn't exist";
                    }
                    else if (value == -1)
                    {
                        status = "Branch doesn't exist";
                    }                    
                    else
                    {
                        status = "Some error occurred";
                    }
                }
                catch (Exception)
                {
                    status = "Some error occured";
                }
                finally
                {
                    con.Close();
                }
            }
            else
            {
                status = "Invalid value in the \'position\' field";
            }
            
            return status;
        }

        public string CheckDocumentStatus(int docId, int libId, int copyno)
        {
            string status = "Something went wrong";
            int value = 0;
            SqlCommand cmd = new SqlCommand("spCheckDocStatus", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@docId", docId);
            cmd.Parameters.AddWithValue("@libId", libId);
            cmd.Parameters.AddWithValue("@copyno", copyno);
            var outparam = cmd.Parameters.AddWithValue("@status", DbType.Int32);
            outparam.Direction = ParameterDirection.Output;
            try
            {
                con.Open();
                cmd.ExecuteNonQuery();
                value = (int)outparam.Value;
                if (value == 1)
                {
                    status = "Available";
                }
                else if (value == 0)
                {
                    status = "Document does not exist";
                }
                else if (value == -1)
                {
                    status = "Borrowed";
                }
                else if (value == -2)
                {
                    status = "Reserved";
                }               

            }
            catch (Exception)
            {
                status = "Something went wrong";
            }
            finally
            {
                con.Close();
            }
            return status;
        }       

        public string AddReader(string readerName, string type, string phoneNo, string address)
        {
            string status = "Error Can't add reader";            
            SqlCommand cmd = new SqlCommand("spAddReader",con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@readerName", readerName);
            cmd.Parameters.AddWithValue("@type", type);
            cmd.Parameters.AddWithValue("@phoneno", phoneNo);
            cmd.Parameters.AddWithValue("@address", address);
            try
            {
                con.Open();
                cmd.ExecuteNonQuery();
                status = "Successfully added";
            }
            catch (Exception)
            {
                status = "Error cannot add reader";                                
            }
            finally
            {
                con.Close();
            }
            return status;
        }

        public DataTable GetBranchesInfo(int? libId)
        {
            DataTable dt = new DataTable();
            SqlCommand cmd = new SqlCommand();
            if (libId == null)
            {
                cmd.CommandText = "Select Name, Location from Branch";
            }
            else
            {
                cmd.CommandText = "Select Name, Location from Branch Where Libid=@libId";
                cmd.Parameters.AddWithValue("@libId", libId);
            }
            cmd.Connection = con;            
            try
            {
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                con.Open();
                adapter.Fill(dt);
            }
            catch (Exception)
            {
                
            }
            return dt;
        }

        public DataTable GetTopBorrowers(int libId)
        {
            DataTable dt = new DataTable();
            SqlCommand cmd = new SqlCommand("SELECT TOP(10) ReaderName,COUNT(BorNumber) AS Books_Borrowed from Borrows B inner join Reader R on B.ReaderId=R.Reader_id where B.Libid=@libId GROUP BY ReaderId, ReaderName ORDER BY COUNT(BorNumber) desc", con);
            cmd.Parameters.AddWithValue("@libId", libId);
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

        public DataTable GetTopBorrowedBooks(int libId)
        {
            DataTable dt = new DataTable();
            SqlCommand cmd = new SqlCommand("SELECT TOP(10) Title,COUNT(BorNumber) AS 'Count' from Borrows B inner join Book BO on B.DocID=BO.DocId inner join Document D on D.DocId = BO.DocID WHERE B.Libid=@libId GROUP BY B.DocID, Title ORDER BY COUNT(BorNumber) desc", con);
            cmd.Parameters.AddWithValue("@libId",libId);
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

        public DataTable GetMostPopularBooks(int year)
        {
            DataTable dt = new DataTable();
            SqlCommand cmd = new SqlCommand("SELECT TOP(10) Title,COUNT(B.BorNumber) AS 'Count' from Borrows B inner join Book BO on B.DocID=BO.DocId inner join Document D on D.DocId = BO.DocID inner join BOR_Transaction BOR on BOR.BorNumber=B.BorNumber where year(BorDateTime)=@year Group By B.DocID,Title Order by Count(B.BorNumber) desc", con);
            cmd.Parameters.AddWithValue("@year", year);
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

        public DataTable GetAvgFinePerReader()
        {
            DataTable dt = new DataTable();
            SqlCommand cmd = new SqlCommand("SELECT B.ReaderId, R.ReaderName, AVG((DATEDIFF(DAY,RetDateTime,BorDateTime)-20)*0.20) as 'Avg Fine' from Reader R inner join Borrows B on R.Reader_id=B.ReaderId inner join BOR_Transaction BOR on B.BorNumber=BOR.BorNumber where RetDateTime is not null Group By B.Readerid,R.ReaderName", con);            
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
    }
}