package acar.tire;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.common.*;
import oracle.jdbc.*;
import oracle.sql.*;

public class TireDatabase
{
	private Connection conn = null;
	public static TireDatabase db;
	
	public static TireDatabase getInstance()
	{
		if(TireDatabase.db == null)
			TireDatabase.db = new TireDatabase();
		return TireDatabase.db;
	}	
	

 	private DBConnectionManager connMgr = null;

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
	
	

	//한건 조회
	public TireBean getDtireMM(String seq, String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		TireBean bean = new TireBean();
		String query = "";

		query = " SELECT B.CAR_NM as dtire_carnm, a.* FROM DTIRE_MM a , CAR_REG b  WHERE a.CAR_MNG_ID = b.CAR_MNG_ID and a.seq = '"+seq+"' and a.car_mng_id = '"+car_mng_id+"' ";

		try{
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setSeq				(rs.getString("seq")		==null?"":rs.getString("seq"));
				bean.setReg_id			(rs.getString("reg_id")		==null?"":rs.getString("reg_id"));
				bean.setReg_dt			(rs.getString("reg_dt")		==null?"":rs.getString("reg_dt"));
				bean.setCar_mng_id		(rs.getString("car_mng_id")	==null?"":rs.getString("car_mng_id"));	
				bean.setDtire_note		(rs.getString("dtire_note")	==null?"":rs.getString("dtire_note"));	
				bean.setDtire_carno		(rs.getString("dtire_carno")	==null?"":rs.getString("dtire_carno"));	
				bean.setReq_nm			(rs.getString("req_nm")		==null?"":rs.getString("req_nm"));
				bean.setDtire_dt		(rs.getString("dtire_dt")	==null?"":rs.getString("dtire_dt"));
				bean.setDtire_amt		(rs.getInt("dtire_amt"));
				bean.setDtire_s_amt		(rs.getInt("dtire_s_amt"));
				bean.setDtire_v_amt		(rs.getInt("dtire_v_amt"));
				bean.setDtire_gb		(rs.getString("dtire_gb")	==null?"":rs.getString("dtire_gb"));
				bean.setDtire_yn		(rs.getString("dtire_yn")	==null?"":rs.getString("dtire_yn"));
				bean.setDtire_item1		(rs.getString("dtire_item1")	==null?"":rs.getString("dtire_item1"));
				bean.setDtire_item_amt1	(rs.getInt("dtire_item_amt1"));
				bean.setDtire_item2		(rs.getString("dtire_item2")	==null?"":rs.getString("dtire_item2"));
				bean.setDtire_item_amt2	(rs.getInt("dtire_item_amt2"));
				bean.setDtire_item3		(rs.getString("dtire_item3")	==null?"":rs.getString("dtire_item3"));
				bean.setDtire_item_amt3	(rs.getInt("dtire_item_amt3"));
				bean.setDtire_item4		(rs.getString("dtire_item4")	==null?"":rs.getString("dtire_item4"));
				bean.setDtire_item_amt4	(rs.getInt("dtire_item_amt4"));
				bean.setDtire_item5		(rs.getString("dtire_item5")	==null?"":rs.getString("dtire_item5"));
				bean.setDtire_item_amt5	(rs.getInt("dtire_item_amt5"));
				bean.setDtire_item6		(rs.getString("dtire_item6")	==null?"":rs.getString("dtire_item6"));
				bean.setDtire_item_amt6	(rs.getInt("dtire_item_amt6"));
				bean.setDtire_carnm		(rs.getString("dtire_carnm")	==null?"":rs.getString("dtire_carnm"));
				bean.setDtire_km		(rs.getInt("dtire_km"));
				bean.setRent_l_cd		(rs.getString("rent_l_cd")	==null?"":rs.getString("rent_l_cd"));
				bean.setServ_id			(rs.getString("serv_id")	==null?"":rs.getString("serv_id"));

				bean.setDtire_item_v_amt1	(rs.getInt("dtire_item_v_amt1"));



			}
			
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[TireDatabase:getDtireMM]\n"+e);
			System.out.println("[TireDatabase:getDtireMM]\n"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}				
	}


public Hashtable  getDtireMMKK(String seq, String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";


		query = " SELECT B.CAR_NM as dtire_carnm, a.* FROM DTIRE_MM a , CAR_REG b  WHERE a.CAR_MNG_ID = b.CAR_MNG_ID and a.seq = '"+seq+"' and a.car_mng_id = '"+car_mng_id+"' ";



		try {
			pstmt = conn.prepareStatement(query);
	    		rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[TireDatabase:getDtireMM]"+e);
			System.out.println("[TireDatabase:getDtireMM]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}
	
	public Hashtable  getDtireMMKK3(String seq, String car_mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";


		query = "select  nvl(g.s_cnt,0) s_cnt from   dtire_mm a, ( select car_mng_id , serv_dt, tot_amt,  count(0)  s_cnt  from SERVICE group by car_mng_id, serv_dt,tot_amt) g "+ 
			    " where a.dtire_amt=g.tot_amt(+) and a.seq = '"+seq+"' and a.car_mng_id = '"+car_mng_id+"' "+
				" and a.car_mng_id=g.car_mng_id(+)  "+
				"  AND a.dtire_dt = g.serv_dt(+)  "+
				"  and a.dtire_amt=g.tot_amt(+) ";



		try {
			pstmt = conn.prepareStatement(query);
	    		rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[TireDatabase:getDtireMMKK3]"+e);
			System.out.println("[TireDatabase:getDtireMMKK3]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}

	public Hashtable  getDtireMMKK2(String seq)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";


		query = " SELECT B.CAR_NM as dtire_carnm, a.* FROM DTIRE_MM a , CAR_REG b  WHERE a.CAR_MNG_ID = b.CAR_MNG_ID and a.seq = '"+seq+"'";


		try {
			pstmt = conn.prepareStatement(query);
	    		rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[TireDatabase:getDtireMM]"+e);
			System.out.println("[TireDatabase:getDtireMM]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}







	public String insertDtireMM(TireBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		String seq = "";

		String qry_id = " select nvl(ltrim(to_char(to_number(max(seq)+1), '000000')), '000001') seq"+
						" from dtire_mm "+
						" ";

		String query =  " insert into dtire_mm "+
						" ( seq, reg_id, reg_dt, car_mng_id, dtire_note, dtire_carno, req_nm, dtire_dt, dtire_amt, dtire_gb, dtire_item1, dtire_item_amt1,  dtire_item2, dtire_item_amt2,  dtire_item3, dtire_item_amt3,  dtire_item4, dtire_item_amt4, dtire_item5, dtire_item_amt5, dtire_item6, dtire_item_amt6, dtire_carnm, dtire_km, rent_l_cd, serv_id, dtire_s_amt, dtire_v_amt, "+
						"	dtire_item_s_amt1, dtire_item_s_amt2, dtire_item_s_amt3, dtire_item_s_amt4, dtire_item_s_amt5, dtire_item_s_amt6, dtire_item_v_amt1, dtire_item_v_amt2, dtire_item_v_amt3, dtire_item_v_amt4, dtire_item_v_amt5, dtire_item_v_amt6, dtire_item_t_amt1, dtire_item_t_amt2, dtire_item_t_amt3, dtire_item_t_amt4, dtire_item_t_amt5, dtire_item_t_amt6,  "+
						"	dtire_item_su1, dc "+
						" ) values "+
						" ( ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?, replace(?,'-',''), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ,? , ?, ?, ?, ?, ?, ?, ?, ?, "+
						"	?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?"+
						" )";



		try
		{
			conn.setAutoCommit(false);
			pstmt1 = conn.prepareStatement(qry_id);
		   	rs = pstmt1.executeQuery();
			if(rs.next())
			{
				seq = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			pstmt1.close();
			conn.commit();
		}catch(Exception e){					
	        try{
				System.out.println("[TireDatabase:insertDtireMM]"+e);
				System.out.println("[TireDatabase:insertDtireMM]"+query);
	            conn.rollback();
				e.printStackTrace();	
				flag = false;
	        }catch(SQLException _ignored){}
		}finally{
			try{
                if(rs != null )		rs.close();
	            if(pstmt1 != null)	pstmt1.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
		}

		try
		{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query);
			
			pstmt2.setString(1,  seq					  );
			pstmt2.setString(2,  bean.getReg_id			());
			pstmt2.setString(3,  bean.getCar_mng_id		());
			pstmt2.setString(4,  bean.getDtire_note		());
			pstmt2.setString(5,  bean.getDtire_carno		());
			pstmt2.setString(6,  bean.getReq_nm		());
			pstmt2.setString(7,  bean.getDtire_dt		());
			pstmt2.setInt(8,	 bean.getDtire_amt		());
			pstmt2.setString(9,  bean.getDtire_gb		());
			pstmt2.setString(10, bean.getDtire_item1		());
			pstmt2.setInt(11,	 bean.getDtire_item_amt1		());
			pstmt2.setString(12, bean.getDtire_item2		());
			pstmt2.setInt(13,	 bean.getDtire_item_amt2		());
			pstmt2.setString(14, bean.getDtire_item3		());
			pstmt2.setInt(15,	 bean.getDtire_item_amt3		());
			pstmt2.setString(16, bean.getDtire_item4		());
			pstmt2.setInt(17,	 bean.getDtire_item_amt4		());
			pstmt2.setString(18, bean.getDtire_item5		());
			pstmt2.setInt(19,	 bean.getDtire_item_amt5		());
			pstmt2.setString(20, bean.getDtire_item6		());
			pstmt2.setInt(21,	 bean.getDtire_item_amt6		());
			pstmt2.setString(22, bean.getDtire_carnm		());
			pstmt2.setInt(23,	 bean.getDtire_km		());
			pstmt2.setString(24, bean.getRent_l_cd		());
			pstmt2.setString(25, bean.getServ_id		());
			pstmt2.setInt(26,	 bean.getDtire_s_amt		());
			pstmt2.setInt(27,	 bean.getDtire_v_amt		());
			
			pstmt2.setInt(28,	 bean.getDtire_item_s_amt1		());
			pstmt2.setInt(29,	 bean.getDtire_item_s_amt2		());
			pstmt2.setInt(30,	 bean.getDtire_item_s_amt3		());
			pstmt2.setInt(31,	 bean.getDtire_item_s_amt4		());
			pstmt2.setInt(32,	 bean.getDtire_item_s_amt5		());
			pstmt2.setInt(33,	 bean.getDtire_item_s_amt6		());

			pstmt2.setInt(34,	 bean.getDtire_item_v_amt1		());
			pstmt2.setInt(35,	 bean.getDtire_item_v_amt2		());
			pstmt2.setInt(36,	 bean.getDtire_item_v_amt3		());
			pstmt2.setInt(37,	 bean.getDtire_item_v_amt4		());
			pstmt2.setInt(38,	 bean.getDtire_item_v_amt5		());
			pstmt2.setInt(39,	 bean.getDtire_item_v_amt6		());

			pstmt2.setInt(40,	 bean.getDtire_item_t_amt1		());
			pstmt2.setInt(41,	 bean.getDtire_item_t_amt2		());
			pstmt2.setInt(42,	 bean.getDtire_item_t_amt3		());
			pstmt2.setInt(43,	 bean.getDtire_item_t_amt4		());
			pstmt2.setInt(44,	 bean.getDtire_item_t_amt5		());
			pstmt2.setInt(45,	 bean.getDtire_item_t_amt6		());

			pstmt2.setInt(46,	 bean.getDtire_item_su1		());
			pstmt2.setString(47,	 bean.getDc		());



			pstmt2.executeUpdate();			
			pstmt2.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TireDatabase:insertDtireMM]\n"+e);
			System.out.println("[TireDatabase:insertDtireMM]\n"+query);
			e.printStackTrace();
	  		flag = false;
			seq = "";
			conn.rollback();
		}finally{
			try{
	            if(pstmt2 != null)	pstmt2.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return seq;
		}
	}

	public boolean updateDtireMM(TireBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update dtire_mm set "+
						"	dtire_note		= ?, "+
						"	dtire_dt		= replace(?,'-',''),  "+
						"	dtire_amt		=?, "+
						"	dtire_gb		=?, "+
						"	dtire_item1		=?, "+
						"	dtire_item_amt1	=?, "+
						"	dtire_item2		=?, "+
						"	dtire_item_amt2	=?, "+
						"	dtire_item3		=?, "+
						"	dtire_item_amt3	=?, "+
						"	dtire_item4		=?, "+
						"	dtire_item_amt4	=?, "+
						"	dtire_item5		=?, "+
						"	dtire_item_amt5	=?, "+
						"	dtire_item6		=?, "+
						"	dtire_item_amt6	=?, "+
						"	req_nm			=?, "+
						"	dtire_km		=?, "+
						"	dtire_s_amt		=?, "+
						"	dtire_v_amt		=?, "+

						"	dtire_item_s_amt1	=?, "+
						"	dtire_item_s_amt2	=?, "+
						"	dtire_item_s_amt3	=?, "+
						"	dtire_item_s_amt4	=?, "+
						"	dtire_item_s_amt5	=?, "+
						"	dtire_item_s_amt6	=?, "+

						"	dtire_item_v_amt1	=?, "+
						"	dtire_item_v_amt2	=?, "+
						"	dtire_item_v_amt3	=?, "+
						"	dtire_item_v_amt4	=?, "+
						"	dtire_item_v_amt5	=?, "+
						"	dtire_item_v_amt6	=?, "+

						"	dtire_item_t_amt1	=?, "+
						"	dtire_item_t_amt2	=?, "+
						"	dtire_item_t_amt3	=?, "+
						"	dtire_item_t_amt4	=?, "+
						"	dtire_item_t_amt5	=?, "+
						"	dtire_item_t_amt6	=?, "+

						"	dtire_item_su1	=?, "+
						"	dc	=? "+

						" where seq=?";
		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  bean.getDtire_note		());
			pstmt.setString(2,  bean.getDtire_dt		());
			pstmt.setInt(3,  bean.getDtire_amt		());
			pstmt.setString(4,  bean.getDtire_gb		());
			pstmt.setString(5,  bean.getDtire_item1		());
			pstmt.setInt(6,  bean.getDtire_item_amt1		());
			pstmt.setString(7,  bean.getDtire_item2		());
			pstmt.setInt(8,  bean.getDtire_item_amt2		());
			pstmt.setString(9,  bean.getDtire_item3		());
			pstmt.setInt(10,  bean.getDtire_item_amt3		());
			pstmt.setString(11,  bean.getDtire_item4		());
			pstmt.setInt(12,  bean.getDtire_item_amt4		());
			pstmt.setString(13,  bean.getDtire_item5		());
			pstmt.setInt(14,  bean.getDtire_item_amt5		());
			pstmt.setString(15,  bean.getDtire_item6		());
			pstmt.setInt(16,  bean.getDtire_item_amt6		());
			pstmt.setString(17,  bean.getReq_nm				());
			pstmt.setInt(18,  bean.getDtire_km		());
			pstmt.setInt(19,  bean.getDtire_s_amt		());
			pstmt.setInt(20,  bean.getDtire_v_amt		());

			pstmt.setInt(21,	 bean.getDtire_item_s_amt1		());
			pstmt.setInt(22,	 bean.getDtire_item_s_amt2		());
			pstmt.setInt(23,	 bean.getDtire_item_s_amt3		());
			pstmt.setInt(24,	 bean.getDtire_item_s_amt4		());
			pstmt.setInt(25,	 bean.getDtire_item_s_amt5		());
			pstmt.setInt(26,	 bean.getDtire_item_s_amt6		());

			pstmt.setInt(27,	 bean.getDtire_item_v_amt1		());
			pstmt.setInt(28,	 bean.getDtire_item_v_amt2		());
			pstmt.setInt(29,	 bean.getDtire_item_v_amt3		());
			pstmt.setInt(30,	 bean.getDtire_item_v_amt4		());
			pstmt.setInt(31,	 bean.getDtire_item_v_amt5		());
			pstmt.setInt(32,	 bean.getDtire_item_v_amt6		());

			pstmt.setInt(33,	 bean.getDtire_item_t_amt1		());
			pstmt.setInt(34,	 bean.getDtire_item_t_amt2		());
			pstmt.setInt(35,	 bean.getDtire_item_t_amt3		());
			pstmt.setInt(36,	 bean.getDtire_item_t_amt4		());
			pstmt.setInt(37,	 bean.getDtire_item_t_amt5		());
			pstmt.setInt(38,	 bean.getDtire_item_t_amt6		());

			pstmt.setInt(39,	 bean.getDtire_item_su1		());
			pstmt.setString(40,	 bean.getDc		());

			pstmt.setString(41,  bean.getSeq				());

			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TireDatabase:updateDtireMM]\n"+e);
			System.out.println("[TireDatabase:getDtire_note]\n"+bean.getDtire_note());
			System.out.println("[TireDatabase:getDtire_dt]\n"+bean.getDtire_dt());
			System.out.println("[TireDatabase:getDtire_amt]\n"+bean.getDtire_amt());
			System.out.println("[TireDatabase:getDtire_gb]\n"+bean.getDtire_gb());
			System.out.println("[TireDatabase:getDtire_item1]\n"+bean.getDtire_item1());
			System.out.println("[TireDatabase:getDtire_item_amt1]\n"+bean.getDtire_item_amt1());
			System.out.println("[TireDatabase:getDtire_item2]\n"+bean.getDtire_item2());
			System.out.println("[TireDatabase:getDtire_item_amt2]\n"+bean.getDtire_item_amt2());
			System.out.println("[TireDatabase:getDtire_item3]\n"+bean.getDtire_item3());
			System.out.println("[TireDatabase:getDtire_item_amt3]\n"+bean.getDtire_item_amt3());
			System.out.println("[TireDatabase:getDtire_item4]\n"+bean.getDtire_item4());
			System.out.println("[TireDatabase:getDtire_item_amt4]\n"+bean.getDtire_item_amt4());
			System.out.println("[TireDatabase:getDtire_item4]\n"+bean.getDtire_item5());
			System.out.println("[TireDatabase:getDtire_item_amt4]\n"+bean.getDtire_item_amt5());
			System.out.println("[TireDatabase:getDtire_item4]\n"+bean.getDtire_item6());
			System.out.println("[TireDatabase:getDtire_item_amt4]\n"+bean.getDtire_item_amt6());
			System.out.println("[TireDatabase:getSeq]\n"+bean.getDtire_km());
			System.out.println("[TireDatabase:getSeq]\n"+bean.getSeq());
			System.out.println("[TireDatabase:updateDtireMM]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}


public boolean updateDtireMM2(TireBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update dtire_mm set "+
						"	dtire_note		= ?, "+
						"	dtire_dt		= replace(?,'-',''),  "+
						"	dtire_amt		=?, "+
						"	dtire_gb		=?, "+
						"	dtire_item1		=?, "+
						"	dtire_item_amt1	=?, "+
						"	dtire_item2		=?, "+
						"	dtire_item_amt2	=?, "+
						"	dtire_item3		=?, "+
						"	dtire_item_amt3	=?, "+
						"	dtire_item4		=?, "+
						"	dtire_item_amt4	=?, "+
						"	dtire_item5		=?, "+
						"	dtire_item_amt5	=?, "+
						"	dtire_item6		=?, "+
						"	dtire_item_amt6	=?, "+
						"	req_nm			=?, "+
						"	dtire_km		=?, "+
						"	dtire_s_amt		=?, "+
						"	dtire_v_amt		=?, "+

						"	dtire_item_s_amt1	=?, "+
						"	dtire_item_s_amt2	=?, "+
						"	dtire_item_s_amt3	=?, "+
						"	dtire_item_s_amt4	=?, "+
						"	dtire_item_s_amt5	=?, "+
						"	dtire_item_s_amt6	=?, "+

						"	dtire_item_v_amt1	=?, "+
						"	dtire_item_v_amt2	=?, "+
						"	dtire_item_v_amt3	=?, "+
						"	dtire_item_v_amt4	=?, "+
						"	dtire_item_v_amt5	=?, "+
						"	dtire_item_v_amt6	=?, "+

						"	dtire_item_t_amt1	=?, "+
						"	dtire_item_t_amt2	=?, "+
						"	dtire_item_t_amt3	=?, "+
						"	dtire_item_t_amt4	=?, "+
						"	dtire_item_t_amt5	=?, "+
						"	dtire_item_t_amt6	=?, "+
						"	dtire_item_su1	=?, "+

						"	dc	=?, "+

							
						
						"	car_mng_id	=?, "+
						"	dtire_carno	=?, "+
						"	dtire_carnm	=?, "+
						"	rent_l_cd	=?, "+
						"	serv_id	=? "+

						" where seq=?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1,  bean.getDtire_note		());
			pstmt.setString(2,  bean.getDtire_dt		());
			pstmt.setInt(3,  bean.getDtire_amt		());
			pstmt.setString(4,  bean.getDtire_gb		());
			pstmt.setString(5,  bean.getDtire_item1		());
			pstmt.setInt(6,  bean.getDtire_item_amt1		());
			pstmt.setString(7,  bean.getDtire_item2		());
			pstmt.setInt(8,  bean.getDtire_item_amt2		());
			pstmt.setString(9,  bean.getDtire_item3		());
			pstmt.setInt(10,  bean.getDtire_item_amt3		());
			pstmt.setString(11,  bean.getDtire_item4		());
			pstmt.setInt(12,  bean.getDtire_item_amt4		());
			pstmt.setString(13,  bean.getDtire_item5		());
			pstmt.setInt(14,  bean.getDtire_item_amt5		());
			pstmt.setString(15,  bean.getDtire_item6		());
			pstmt.setInt(16,  bean.getDtire_item_amt6		());
			pstmt.setString(17,  bean.getReq_nm				());
			pstmt.setInt(18,  bean.getDtire_km		());
			pstmt.setInt(19,  bean.getDtire_s_amt		());
			pstmt.setInt(20,  bean.getDtire_v_amt		());

			pstmt.setInt(21,	 bean.getDtire_item_s_amt1		());
			pstmt.setInt(22,	 bean.getDtire_item_s_amt2		());
			pstmt.setInt(23,	 bean.getDtire_item_s_amt3		());
			pstmt.setInt(24,	 bean.getDtire_item_s_amt4		());
			pstmt.setInt(25,	 bean.getDtire_item_s_amt5		());
			pstmt.setInt(26,	 bean.getDtire_item_s_amt6		());

			pstmt.setInt(27,	 bean.getDtire_item_v_amt1		());
			pstmt.setInt(28,	 bean.getDtire_item_v_amt2		());
			pstmt.setInt(29,	 bean.getDtire_item_v_amt3		());
			pstmt.setInt(30,	 bean.getDtire_item_v_amt4		());
			pstmt.setInt(31,	 bean.getDtire_item_v_amt5		());
			pstmt.setInt(32,	 bean.getDtire_item_v_amt6		());

			pstmt.setInt(33,	 bean.getDtire_item_t_amt1		());
			pstmt.setInt(34,	 bean.getDtire_item_t_amt2		());
			pstmt.setInt(35,	 bean.getDtire_item_t_amt3		());
			pstmt.setInt(36,	 bean.getDtire_item_t_amt4		());
			pstmt.setInt(37,	 bean.getDtire_item_t_amt5		());
			pstmt.setInt(38,	 bean.getDtire_item_t_amt6		());

			pstmt.setInt(39,	 bean.getDtire_item_su1		());
			pstmt.setString(40,	 bean.getDc		());
			pstmt.setString(41,	 bean.getCar_mng_id	());
			pstmt.setString(42,	 bean.getDtire_carno		());
			pstmt.setString(43,	 bean.getDtire_carnm		());
			pstmt.setString(44,	 bean.getRent_l_cd		());
			pstmt.setString(45,	 bean.getServ_id		());

			

			pstmt.setString(46,  bean.getSeq				());

			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TireDatabase:updateDtireMM]\n"+e);
			System.out.println("[TireDatabase:getDtire_note]\n"+bean.getDtire_note());
			System.out.println("[TireDatabase:getDtire_dt]\n"+bean.getDtire_dt());
			System.out.println("[TireDatabase:getDtire_amt]\n"+bean.getDtire_amt());
			System.out.println("[TireDatabase:getDtire_gb]\n"+bean.getDtire_gb());
			System.out.println("[TireDatabase:getDtire_item1]\n"+bean.getDtire_item1());
			System.out.println("[TireDatabase:getDtire_item_amt1]\n"+bean.getDtire_item_amt1());
			System.out.println("[TireDatabase:getDtire_item2]\n"+bean.getDtire_item2());
			System.out.println("[TireDatabase:getDtire_item_amt2]\n"+bean.getDtire_item_amt2());
			System.out.println("[TireDatabase:getDtire_item3]\n"+bean.getDtire_item3());
			System.out.println("[TireDatabase:getDtire_item_amt3]\n"+bean.getDtire_item_amt3());
			System.out.println("[TireDatabase:getDtire_item4]\n"+bean.getDtire_item4());
			System.out.println("[TireDatabase:getDtire_item_amt4]\n"+bean.getDtire_item_amt4());
			System.out.println("[TireDatabase:getDtire_item4]\n"+bean.getDtire_item5());
			System.out.println("[TireDatabase:getDtire_item_amt4]\n"+bean.getDtire_item_amt5());
			System.out.println("[TireDatabase:getDtire_item4]\n"+bean.getDtire_item6());
			System.out.println("[TireDatabase:getDtire_item_amt4]\n"+bean.getDtire_item_amt6());
			System.out.println("[TireDatabase:getSeq]\n"+bean.getDtire_km());
			System.out.println("[TireDatabase:getSeq]\n"+bean.getSeq());
			System.out.println("[TireDatabase:updateDtireMM]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}


public boolean updateDtireYn(TireBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update dtire_mm set "+
						"	dtire_yn		= to_char(sysdate,'YYYYMMDD')  "+
						" where seq=? and car_mng_id = ? and rent_l_cd = ? ";
	


		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1,  bean.getSeq				());
			pstmt.setString(2,  bean.getCar_mng_id		());
			pstmt.setString(3,  bean.getRent_l_cd		());

			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TireDatabase:updateDtire_ynMM]\n"+e);
			System.out.println("[TireDatabase:updateDtire_ynMM]\n"+query);
			System.out.println("[TireDatabase:getSeq]\n"+bean.getSeq());
			System.out.println("[TireDatabase:getCar_mng_id]\n"+bean.getCar_mng_id());
			System.out.println("[TireDatabase:getRent_l_cd]\n"+bean.getRent_l_cd());
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

public boolean updateDtireDel(TireBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update dtire_mm set "+
						"	dtire_yn		= ''  "+
						" where seq=? and car_mng_id = ? and rent_l_cd = ? ";
	

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1,  bean.getSeq				());
			pstmt.setString(2,  bean.getCar_mng_id		());
			pstmt.setString(3,  bean.getRent_l_cd		());

			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TireDatabase:updateDtireDel]\n"+e);
			System.out.println("[TireDatabase:updateDtireDel]\n"+query);
			System.out.println("[TireDatabase:getSeq]\n"+bean.getSeq());
			System.out.println("[TireDatabase:getCar_mng_id]\n"+bean.getCar_mng_id());
			System.out.println("[TireDatabase:getRent_l_cd]\n"+bean.getRent_l_cd());
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}


	public boolean deleteDtireMM(TireBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " delete from dtire_mm "+
						" where seq= ? and car_mng_id = ?";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1,  bean.getSeq			());
			pstmt.setString(2,  bean.getCar_mng_id		());

			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TireDatabase:deleteDtireMM]\n"+e);
			System.out.println("[TireDatabase:deleteDtireMM]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

//정비등록내역도 삭제
public boolean deleteServ_item(String serv_id, String car_mng_id)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " delete from serv_item "+
						" where serv_id= '"+serv_id+"' and car_mng_id = '"+car_mng_id	+"' ";


		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TireDatabase:deleteServ_item]\n"+e);
			System.out.println("[TireDatabase:deleteServ_item]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

public boolean deleteService(String serv_id, String car_mng_id)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " delete from service "+
						" where serv_id= '"+serv_id+"' and car_mng_id = '"+car_mng_id	+"' ";

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TireDatabase:deleteService]\n"+e);
			System.out.println("[TireDatabase:deleteService]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	

	// 리스트 조회
	public Vector getDtireRegOffList(String id, String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subquery="";

		String search = "";
		String what = "";
		String id2 = "";

		if(id.equals("000256")){
			id2="008634";
		}
		else if(id.equals("000148")){
			id2="000092";
		}
		else if(id.equals("000156")){
			id2="006470";
		}

		if(gubun2.equals("1"))			subquery = " and serv_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		subquery = " and serv_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%'";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	subquery = " and serv_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) subquery = " and serv_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
               		
			query = " select  nvl(g.s_cnt,0) s_cnt ,  decode(a.dtire_gb,'1','일반정비','2','사고수리','3','재리스정비','4','모름') as gubun,  \n"+
				    "       c.user_nm, f.FIRM_NM, d.user_nm as req_nm2, a.*  \n"+
				     " from   dtire_mm a, users c, users d, CONT e, CLIENT f,car_reg h , \n"+ 
				  " ( select car_mng_id , serv_dt, tot_amt,  count(0)  s_cnt  from service where off_id = '"+id2+"'"+subquery+" group by car_mng_id, serv_dt,tot_amt) g"+
				" where  a.reg_id=c.user_id "+
				" and    a.req_nm=d.user_id " +
				" AND h.car_mng_id = a.CAR_MNG_ID(+) "+
				" AND a.RENT_L_CD = e.RENT_L_CD(+) AND e.CLIENT_ID = f.CLIENT_ID(+) and a.reg_id = '"+id+"' "+
				" AND a.car_mng_id = g.car_mng_id(+) AND a.dtire_dt = g.serv_dt(+) "+
				" AND a.dtire_amt=g.tot_amt(+) ";
		
		if(gubun1.equals("1")){
			query += " and nvl(g.s_cnt,0) <> 0 ";
		}
		if(gubun1.equals("2")){
			query += " and nvl(g.s_cnt,0) = 0 ";
		}
		 

		if(gubun2.equals("1"))			query += " and a.dtire_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and a.dtire_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%'";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.dtire_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.dtire_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
	
		if(s_kd.equals("1"))		query += " and a.dtire_carno || h.car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and d.user_nm like '%"+t_wd+"%'";
	
		if(sort.equals("1")){
			query += " order by a.dtire_dt,a.dtire_carno ";	
		}else{
			query += " order by a.dtire_dt desc, a.seq desc";	
		}

		try {
								
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[TireDatabase:getDtireRegOffList]\n"+e);
			System.out.println("[TireDatabase:getDtireRegOffList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}


	/**
	 *	차량번호 조회 리스트
	 */	
	
public Vector getRentSearch(String s_rent_l_cd, String s_client_nm, String s_car_no, String s_rent_s_dt, String s_kd, String t_wd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.use_yn, nvl(a.mng_id, bus_id2) as mng_id, \n"+
				"        decode(a.use_yn,'N','해지','Y','대여','','대기') use_st, u.user_nm as mng_nm, \n"+
				"        a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.rent_start_dt, a.rent_end_dt, \n"+
				"        nvl(b.car_no,nvl(g.est_car_no,nvl(g.car_num,g.rpt_no))) car_no, e.car_name, f.car_nm, \n"+
				"        b.car_y_form, b.init_reg_dt, c.firm_nm, c.client_nm, d.colo, \n"+
				"        decode(substr(b.init_reg_dt, 1,6), '','신차','신차아님') as shin_car, \n"+
				"        decode( a.car_gu, '1', '신차','신차아님' ) AS car_gu, \n"+
				"        i.cls_dt \n"+
				" from   cont a, car_reg b, car_etc d, client c, car_nm e, car_mng f, car_pur g, sui h, cls_cont i, users u  \n"+
				" where  a.rent_l_cd not like 'RM%' and a.car_mng_id=b.car_mng_id(+) \n"+
				"        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
				"        and a.client_id=c.client_id \n"+
				"        and d.car_id=e.car_id and d.car_seq=e.car_seq \n"+
				"        and e.car_comp_id=f.car_comp_id and e.car_cd=f.code \n"+
				"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd \n"+
				"        and a.car_mng_id=h.car_mng_id(+)  \n"+	
				"		 and nvl(a.mng_id, bus_id2) = u.user_id  \n "+
				"        and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) \n"+
				" ";
	
		if(s_kd.equals("1"))		query += " and nvl(c.firm_nm,c.client_nm) like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and nvl(b.car_no,g.est_car_no)||b.first_car_no like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and replace(upper(nvl(g.rpt_no, ' ')),'-','')  like replace(upper('%"+t_wd+"%'),'-','')";
		else if(s_kd.equals("4"))	query += " and nvl(b.car_num,g.car_num) like '%"+t_wd+"%'";
		else						query += " and nvl(c.firm_nm,c.client_nm) like '%"+t_wd+"%'";


		if(s_kd.equals("1"))		query += "\n order by c.firm_nm, b.car_no, a.rent_dt desc";
		else if(s_kd.equals("2"))	query += "\n order by b.car_no, a.rent_dt desc";
		else						query += "\n order by a.rent_dt desc";


		try {
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				vt.add(ht);	
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[TireDatabase:getRentSearch]"+e);
			System.out.println("[TireDatabase:getRentSearch]"+query);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	
   

   public boolean updateDtireReq_nm(TireBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update dtire_mm set "+
						"	req_nm		= ?  "+
						" where seq=? and car_mng_id = ? and rent_l_cd = ? ";
	

		try
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1,  bean.getReq_nm			());
			pstmt.setString(2,  bean.getSeq				());
			pstmt.setString(3,  bean.getCar_mng_id		());
			pstmt.setString(4,  bean.getRent_l_cd		());

			pstmt.executeUpdate();			
			pstmt.close();

			conn.commit();
		    
	  	}catch(Exception e){
			System.out.println("[TireDatabase:updateDtireReq_nm]\n"+e);
			System.out.println("[TireDatabase:updateDtireReq_nm]\n"+query);
			System.out.println("[TireDatabase:getReq_nm]\n"+bean.getReq_nm());
			System.out.println("[TireDatabase:getSeq]\n"+bean.getSeq());
			System.out.println("[TireDatabase:getCar_mng_id]\n"+bean.getCar_mng_id());
			System.out.println("[TireDatabase:getRent_l_cd]\n"+bean.getRent_l_cd());
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		}finally{
			try{
	            if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}



public Hashtable fine_serviceYN(String car_mng_id, String off_id, String serv_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Hashtable ht = new Hashtable();
		int count = 0;

		String query = "";


		query = " SELECT serv_id FROM SERVICE WHERE car_mng_id = '"+car_mng_id+"' and off_id = '"+off_id+"' and serv_dt = '"+serv_dt+"' ";


		try {
			pstmt = conn.prepareStatement(query);
	    		rs = pstmt.executeQuery(); 
			ResultSetMetaData rsmd = rs.getMetaData();

			if(rs.next()){	
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[TireDatabase:fine_serviceYN]"+e);
			System.out.println("[TireDatabase:fine_serviceYN]"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )			rs.close();
                if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
	}





}

