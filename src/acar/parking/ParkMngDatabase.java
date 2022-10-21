/**
 * 주차장관리
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2008. 9. 2
 * @ last modify date : 
 */

package acar.parking;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.exception.DatabaseException;
import acar.exception.DataSourceEmptyException;


public class ParkMngDatabase
{
	private Connection conn = null;
	public static ParkMngDatabase db;
	private DBConnectionManager connMgr = null;
	// Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 


	public static ParkMngDatabase getInstance() throws DatabaseException 
	{
		if(ParkMngDatabase.db == null)
			ParkMngDatabase.db = new ParkMngDatabase();
		return ParkMngDatabase.db;
	}	
		

    private void getConnection()
    {
    	try
    	{
	    	if(connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if(conn == null)
	        	conn = connMgr.getConnection("acar");				
	    }catch(Exception e){
	    	System.out.println(" i can't get a connection........");
	    }
	}	

        
	private void closeConnection()
	{
		if ( conn != null ) 
		{
			connMgr.freeConnection("acar", conn);
			conn = null;
		}		
	}
	
	
    
}