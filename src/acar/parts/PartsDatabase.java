package acar.parts;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.common.*;
import acar.util.*;

public class PartsDatabase
{
	private Connection conn = null;
	public static PartsDatabase db;
	
	public static PartsDatabase getInstance()
	{
		if(PartsDatabase.db == null)
			PartsDatabase.db = new PartsDatabase();
		return PartsDatabase.db;	
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


    public PartsBean [] getBasePartsSearchList(String t_wd, String t_wd2) 
    {
        getConnection();
	
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";
        	
        query = " SELECT parts_no , parts_nm "+			
        		" FROM   parts    where  parts_no = '"+t_wd+"'";

		if(!t_wd2.equals(""))  query += " and parts_nm like '%"+t_wd2+"%'";

		query += " order by parts_no";


        Collection<PartsBean> col = new ArrayList<PartsBean>();
        
        try {
			pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			while(rs.next()){                
			            PartsBean bean = new PartsBean();
			            bean.setParts_no	(rs.getString("PARTS_NO"));
				   bean.setParts_nm	(rs.getString("PARTS_NM"));
				
				   col.add(bean); 
		            }
		            rs.close();
		            pstmt.close();
		} catch (SQLException e) {
			System.out.println("[PartsDatabase:getBasePartsSearchList]"+e);
	  		e.printStackTrace();
		} finally {
			try{
		                if(rs != null )		rs.close();
		                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return (PartsBean[])col.toArray(new PartsBean[0]);
		}		
	}


	//부품명칭 코드 등록
	public boolean insertParts(PartsBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = " INSERT INTO parts ( "+
				"       parts_no, car_comp_id, car_cd, parts_nm, "+
				"      a_st, c_st, reg_dt, reg_id ) VALUES "+
				"	 (  upper(?),  ?,  ?,  ? , "+
				"     ?,  ?,  to_char(sysdate,'YYYYMMDD'),  ?  )";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getParts_no());
			pstmt.setString	(2,		bean.getCar_comp_id());
			pstmt.setString	(3,		bean.getCar_cd());
			pstmt.setString	(4,		bean.getParts_nm());
			
			pstmt.setString	(5,		bean.getA_st());			
			pstmt.setString	(6,		bean.getC_st());
			pstmt.setString	(7,		bean.getReg_id());
				
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[PartsDatabase:insertParts]\n"+e);
			System.out.println("[PartsDatabase:insertParts]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	//부품가격 등록
	public boolean insertPartsPrice(PriceBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;
		String query = "";
		String query_seq = "";
		int seq = 0;
			
		//seq_no 구하기
		
		query_seq = "select nvl(max(seq_no)+1, 1)  from parts_price where parts_no = '" + bean.getParts_no() + "' ";	
		 		 	
		query = " INSERT INTO parts_price ( "+
				"       parts_no, seq_no, p_s_amt, p_v_amt, r_s_amt, r_v_amt, dc_s_amt, dc_rate, "+
				"      gubun, app_dt, reg_dt, reg_id, car_comp_id, car_cd ) VALUES "+
				"	 (  upper(?),  ?,  ?,  ? ,  ?,  ?,  ?,  ?, "+
				"     ?,  replace(?, '-', '') ,  to_char(sysdate,'YYYYMMDD'),  ?, ?, ?  )";

		try 
		{
			conn.setAutoCommit(false);
			
			stmt = conn.createStatement();
		    rs = stmt.executeQuery(query_seq);
		    if(rs.next())
				seq = rs.getInt(1);

		    rs.close();
			stmt.close();

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getParts_no());
			pstmt.setInt	(2,		seq);
			pstmt.setInt	(3,		bean.getP_s_amt());
			pstmt.setInt	(4,		bean.getP_v_amt());
			pstmt.setInt	(5,		bean.getR_s_amt());
			pstmt.setInt	(6,		bean.getR_v_amt());
			pstmt.setInt	(7,		bean.getDc_s_amt());
			pstmt.setInt	(8,		bean.getDc_rate());
			
			pstmt.setString	(9,		bean.getGubun());			
			pstmt.setString	(10,		bean.getApp_dt());
			pstmt.setString	(11,		bean.getReg_id());
			pstmt.setString	(12,		bean.getCar_comp_id());
			pstmt.setString	(13,		bean.getCar_cd());
				
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[PartsDatabase:insertPartsPrice]\n"+e);
			System.out.println("[PartsDatabase:insertPartsPrice]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
			         if(stmt != null) stmt.close();
			         if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	
		//부품명칭 변경
	public boolean updatetPartsNm(String parts_no, String parts_nm)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
			
		query = "update parts "+
				"      set parts_nm =  ?    where parts_no  = ? ";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		parts_nm);
			pstmt.setString	(2,		parts_no);
	
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[PartsDatabase:updatetPartsNm]\n"+e);
			System.out.println("[PartsDatabase:updatetPartsNm]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	
 public Vector getBasePartsList(String s_kd, String t_wd, String sort, String a) 
    {
        getConnection();
	
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        Vector vt = new Vector();
        String query = "";
        String kd_query = "";        
        
        if (  !s_kd.equals("") ) { 
	        if(s_kd.equals("1"))		kd_query += "  and  a.parts_no like '%"+ t_wd + "%'";
	        else if(s_kd.equals("2"))	kd_query += "  and  a.parts_nm like '%"+ t_wd + "%'";
	}	
				
        query = " SELECT  a.parts_no , a.parts_nm, c.nm ,  cm.car_nm  , decode(a.a_st, '1',  '전모델', '한정') a_st_nm, decode(a.c_st, '1', '있슴', '없슴') c_st_nm ,  \n"+		
                   "  b.p_s_amt, b.r_s_amt , b.r_v_amt, b.reg_id, b.app_dt, a.car_comp_id, a.car_cd  \n"+			
        		" FROM   parts  a,  parts_price b,  car_mng cm, code c,   (select parts_no,  max(seq_no)  seq_no   from   parts_price   group by parts_no) bm  \n "+	
        		"  where  a.parts_no = b.parts_no  and b.parts_no = bm.parts_no  and b.seq_no = bm.seq_no \n"+			
        		"   and a.car_comp_id=c.code and c.c_st = '0001' and    a.car_comp_id=cm.car_comp_id and a.car_cd=cm.code   " + kd_query ;

		query += " order by a.parts_no ";
		
        
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
			System.out.println("[PartsDatabase:getBasePartsList]"+e);
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


	public PartsBean getPartsInfo(String parts_no)
	{
		getConnection();
		PartsBean bean = new PartsBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select a.* ,   c.nm maker_nm ,  cm.car_nm    from parts a, car_mng cm, code c  "+
						" where a.parts_no = '"+parts_no+"' and a.car_comp_id = c.code and c.c_st = '0001' and    a.car_comp_id=cm.car_comp_id and a.car_cd=cm.code   ";
		
		try {
			pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setParts_no(rs.getString("parts_no")==null?"":rs.getString("parts_no"));
				bean.setCar_comp_id(rs.getString("car_comp_id")==null?"":rs.getString("car_comp_id"));
				bean.setCar_cd(rs.getString("car_cd")==null?"":rs.getString("car_cd"));
				bean.setParts_nm(rs.getString("parts_nm")==null?"":rs.getString("parts_nm"));
				bean.setA_st(rs.getString("a_st")==null?"":rs.getString("a_st"));
				bean.setC_st(rs.getString("c_st")==null?"":rs.getString("c_st"));		
				bean.setMaker_nm(rs.getString("maker_nm")==null?"":rs.getString("maker_nm"));		
				bean.setCar_nm(rs.getString("car_nm")==null?"":rs.getString("car_nm"));						
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println(e);
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


	public PriceBean getPartsPrice(String parts_no)
	{
		getConnection();
		PriceBean bean = new PriceBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select a.* from parts_price  a,    (select parts_no,  max(seq_no)  seq_no   from   parts_price   group by parts_no) bm  "+
						" where a.parts_no = bm.parts_no and a.seq_no = bm.seq_no and  a.parts_no = '"+parts_no+"' ";

		try {
			pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{
				bean.setParts_no(rs.getString("parts_no")==null?"":rs.getString("parts_no"));
				bean.setSeq_no(rs.getInt("seq_no"));
				bean.setP_s_amt(rs.getInt("p_s_amt"));
				bean.setP_v_amt(rs.getInt("p_v_amt"));
				bean.setR_s_amt(rs.getInt("r_s_amt"));
				bean.setR_v_amt(rs.getInt("r_v_amt"));
				bean.setDc_s_amt(rs.getInt("dc_s_amt"));
				bean.setDc_rate(rs.getInt("dc_rate"));
				bean.setGubun(rs.getString("gubun")==null?"":rs.getString("gubun"));
				bean.setApp_dt(rs.getString("app_dt")==null?"":rs.getString("app_dt"));
				bean.setReg_dt(rs.getString("reg_dt")==null?"":rs.getString("reg_dt"));
				bean.setReg_id(rs.getString("reg_id")==null?"":rs.getString("reg_id"));
				
						
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println(e);
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
	
	
	/**
	 *	부품가격  리스트
	 */
	public Vector getPartsPriceList(String parts_no)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query =	" select *  from parts_price "+
						" where parts_no = '"+parts_no+"' ";

		query += " order by seq_no ";

		try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				PriceBean bean = new PriceBean();
				
				bean.setParts_no(rs.getString("parts_no")==null?"":rs.getString("parts_no"));
				bean.setSeq_no(rs.getInt("seq_no"));
				bean.setP_s_amt(rs.getInt("p_s_amt"));
				bean.setP_v_amt(rs.getInt("p_v_amt"));
				bean.setR_s_amt(rs.getInt("r_s_amt"));
				bean.setR_v_amt(rs.getInt("r_v_amt"));
				bean.setDc_s_amt(rs.getInt("dc_s_amt"));
				bean.setDc_rate(rs.getInt("dc_rate"));
				bean.setGubun(rs.getString("gubun")==null?"":rs.getString("gubun"));
				bean.setApp_dt(rs.getString("app_dt")==null?"":rs.getString("app_dt"));
				bean.setReg_dt(rs.getString("reg_dt")==null?"":rs.getString("reg_dt"));
				bean.setReg_id(rs.getString("reg_id")==null?"":rs.getString("reg_id"));				
				vt.add(bean);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println(e);
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
	
	
	//부품명칭 코드 등록
	public String insertPartsOrder(OrderBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String query = "";
		String id_query = "";
			
		query = " INSERT INTO parts_order ( "+
				"       reqseq, buy_dt, ven_code, ven_name, buy_qty, buy_s_amt, buy_v_amt, buy_amt, "+   //8
				"       trf_st1, trf_s_amt1, trf_v_amt1, trf_amt1, trf_a_amt1, trf_j_amt1, cardno1, etc1, "+  //8
				"       trf_st2, trf_s_amt2, trf_v_amt2, trf_amt2, trf_a_amt2, trf_j_amt2, cardno2, etc2, "+  //8
				"       trf_st3, trf_s_amt3, trf_v_amt3, trf_amt3, trf_a_amt3, trf_j_amt3, cardno3, etc3, "+  //8
				"      reg_dt, reg_id ) VALUES "+
				"	 ( ?, replace( ?, '-', '') ,  ?,  ?,  ?,  ?,  ?,  ?, "+
				"	  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?, "+
				"	  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?, "+
				"	  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?, "+				
				"      to_char(sysdate,'YYYYMMDD'),  ?  )";				
				
		id_query = " select to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(reqseq,9,7))+1), '0000000')), '0000001') reqseq"+
				" from parts_order "+
				" where substr(reqseq,1,8)=to_char(sysdate,'YYYYMMDD')";


		try 
		{
			conn.setAutoCommit(false);

			//새 reqseq 조회
			pstmt1 = conn.prepareStatement(id_query);
	    		rs = pstmt1.executeQuery();   	
			if(rs.next())
			{				
				bean.setReqseq(rs.getString(1));
			}
			rs.close();
			pstmt1.close();
						
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getReqseq());
			pstmt.setString	(2,		bean.getBuy_dt());
			pstmt.setString	(3,		bean.getVen_code());
			pstmt.setString	(4,		bean.getVen_name());				
			pstmt.setInt	(5,		bean.getBuy_qty());	
			pstmt.setInt	(6,		bean.getBuy_s_amt());	
			pstmt.setInt	(7,		bean.getBuy_v_amt());	
			pstmt.setInt	(8,		bean.getBuy_amt());		
			
			pstmt.setString	(9,		bean.getTrf_st1());
			pstmt.setInt	(10,		bean.getTrf_s_amt1());
			pstmt.setInt	(11,		bean.getTrf_v_amt1());
			pstmt.setInt	(12,		bean.getTrf_amt1());			
			pstmt.setInt	(13,		bean.getTrf_a_amt1());
			pstmt.setInt	(14,		bean.getTrf_j_amt1());
			pstmt.setString	(15,		bean.getCardno1());
			pstmt.setString	(16,		bean.getEtc1());			
			
			pstmt.setString	(17,		bean.getTrf_st2());
			pstmt.setInt	(18,		bean.getTrf_s_amt2());
			pstmt.setInt	(19,		bean.getTrf_v_amt2());
			pstmt.setInt	(20,		bean.getTrf_amt2());			
			pstmt.setInt	(21,		bean.getTrf_a_amt2());
			pstmt.setInt	(22,		bean.getTrf_j_amt2());
			pstmt.setString	(23,		bean.getCardno2());
			pstmt.setString	(24,		bean.getEtc2());			
			
			pstmt.setString	(25,		bean.getTrf_st3());
			pstmt.setInt	(26,		bean.getTrf_s_amt3());
			pstmt.setInt	(27,		bean.getTrf_v_amt3());
			pstmt.setInt	(28,		bean.getTrf_amt3());			
			pstmt.setInt	(29,		bean.getTrf_a_amt3());
			pstmt.setInt	(30,		bean.getTrf_j_amt3());
			pstmt.setString	(31,		bean.getCardno3());
			pstmt.setString	(32,		bean.getEtc3());			
			
			pstmt.setString	(33,		bean.getReg_id());
				
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[PartsDatabase:insertPartsOrder]\n"+e);
			System.out.println("[PartsDatabase:insertPartsOrder]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null )	    rs.close();
				if(pstmt1 != null )	pstmt1.close();
                			if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean.getReqseq();
		}
	}
	
	//부품구매내역 등록
	public boolean insertPartsItem(ItemBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
					
		query = " INSERT INTO parts_item ( "+
				"       reqseq, seq_no, parts_no, qty, "+
				"      o_s_amt, o_v_amt, o_amt , r_s_amt, r_v_amt, car_comp_id, car_cd ) VALUES "+
				"	 ( ?,  ?,  ?,  ? , "+
				"     ?,  ?,   ? , ?,  ?, ? , ? )";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getReqseq());
			pstmt.setInt	(2,		bean.getSeq_no());
			pstmt.setString	(3,		bean.getParts_no());
			pstmt.setInt	(4,		bean.getQty());
			
			pstmt.setInt	(5,		bean.getO_s_amt());			
			pstmt.setInt	(6,		bean.getO_v_amt());
			pstmt.setInt	(7,		bean.getO_amt());
			pstmt.setInt	(8,		bean.getR_s_amt());			
			pstmt.setInt	(9,		bean.getR_v_amt());
			pstmt.setString	(10,	bean.getCar_comp_id());
			pstmt.setString	(11,	bean.getCar_cd());
				
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[PartsDatabase:insertPartsItem]\n"+e);
			System.out.println("[PartsDatabase:insertPartsItem]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	public OrderBean getPartsOrder(String reqseq)
	{
		getConnection();
		OrderBean bean = new OrderBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select a.* from parts_order  a  "+
						" where a.reqseq = '"+reqseq+"' ";

		try {
			pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
    	         	             
			if(rs.next())
			{
				bean.setReqseq(rs.getString("reqseq")==null?"":rs.getString("reqseq"));
				bean.setBuy_dt(rs.getString("buy_dt")==null?"":rs.getString("buy_dt"));
				bean.setVen_code(rs.getString("ven_code")==null?"":rs.getString("ven_code"));
				bean.setVen_name(rs.getString("ven_name")==null?"":rs.getString("ven_name"));				
				bean.setBuy_qty(rs.getInt("buy_qty"));
				bean.setBuy_s_amt(rs.getInt("buy_s_amt"));
				bean.setBuy_v_amt(rs.getInt("buy_v_amt"));
				bean.setBuy_amt(rs.getInt("buy_amt"));				
			
				bean.setTrf_st1(rs.getString("trf_st1")==null?"":rs.getString("trf_st1"));
				bean.setTrf_st2(rs.getString("trf_st2")==null?"":rs.getString("trf_st2"));
				bean.setTrf_st3(rs.getString("trf_st3")==null?"":rs.getString("trf_st3"));				
				bean.setTrf_s_amt1(rs.getInt("trf_s_amt1"));
				bean.setTrf_s_amt2(rs.getInt("trf_s_amt2"));
				bean.setTrf_s_amt3(rs.getInt("trf_s_amt3"));		
				bean.setTrf_v_amt1(rs.getInt("trf_v_amt1"));
				bean.setTrf_v_amt2(rs.getInt("trf_v_amt2"));
				bean.setTrf_v_amt3(rs.getInt("trf_v_amt3"));	
				bean.setTrf_amt1(rs.getInt("trf_amt1"));
				bean.setTrf_amt2(rs.getInt("trf_amt2"));
				bean.setTrf_amt3(rs.getInt("trf_amt3"));	
				bean.setTrf_a_amt1(rs.getInt("trf_a_amt1"));
				bean.setTrf_a_amt2(rs.getInt("trf_a_amt2"));
				bean.setTrf_a_amt3(rs.getInt("trf_a_amt3"));	
				bean.setTrf_j_amt1(rs.getInt("trf_j_amt1"));
				bean.setTrf_j_amt2(rs.getInt("trf_j_amt2"));
				bean.setTrf_j_amt3(rs.getInt("trf_j_amt3"));				
				
				bean.setCardno1(rs.getString("cardno1")==null?"":rs.getString("cardno1"));
				bean.setCardno2(rs.getString("cardno2")==null?"":rs.getString("cardno2"));
				bean.setCardno3(rs.getString("cardno3")==null?"":rs.getString("cardno3"));
				bean.setEtc1(rs.getString("etc1")==null?"":rs.getString("etc1"));
				bean.setEtc2(rs.getString("etc2")==null?"":rs.getString("etc2"));
				bean.setEtc3(rs.getString("etc3")==null?"":rs.getString("etc3"));
				bean.setFile_name1(rs.getString("file_name1")==null?"":rs.getString("file_name1"));
				bean.setFile_name2(rs.getString("file_name2")==null?"":rs.getString("file_name2"));
				bean.setFile_name3(rs.getString("file_name3")==null?"":rs.getString("file_name3"));
				bean.setAutodoc_data_no1(rs.getString("autodoc_data_no1")==null?"":rs.getString("autodoc_data_no1"));
				bean.setAutodoc_data_no2(rs.getString("autodoc_data_no2")==null?"":rs.getString("autodoc_data_no2"));
				bean.setAutodoc_data_no3(rs.getString("autodoc_data_no3")==null?"":rs.getString("autodoc_data_no3"));
				
				bean.setReg_id(rs.getString("reg_id")==null?"":rs.getString("reg_id"));
				bean.setReg_dt(rs.getString("reg_dt")==null?"":rs.getString("reg_dt"));
				bean.setSac_dt(rs.getString("sac_dt")==null?"":rs.getString("sac_dt"));
				bean.setIpgo_yn(rs.getString("ipgo_yn")==null?"":rs.getString("ipgo_yn"));
				
						
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println(e);
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
	
	/**
	 *	부품가격  리스트
	 */
	public Vector getPartsItemList(String reqseq)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query =	" select  a.* ,   b.parts_nm  , c.nm maker_nm ,  cm.car_nm    from parts_item a, parts b,  car_mng cm, code c   "+
						" where    a.parts_no = b.parts_no AND a.CAR_COMP_ID = b.CAR_COMP_ID AND a.CAR_CD = b.CAR_CD and a.reqseq = '"+reqseq+"'  and   b.car_comp_id=c.code and c.c_st = '0001' and    b.car_comp_id=cm.car_comp_id and b.car_cd=cm.code  ";

		query += " order by a.seq_no ";
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
			System.out.println("[PartsDatabase:getPartsItemList]\n"+e);
			System.out.println("[PartsDatabase:getPartsItemList]\n"+query);
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
	 *	부품구매  관리
	 */
	public Vector getPartsOrderList(String s_kd, String t_wd, String st_dt, String end_dt, String gubun2 , String gubun3 )
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query ="";
		String kd_query = "";        
		String t_query = ""; 
        
		


		if(gubun2.equals("1"))			kd_query += " where  a.buy_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("6"))		kd_query += " where  a.buy_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' "; //전월
		else if(gubun2.equals("2")){
				if(!st_dt.equals("") && end_dt.equals(""))	kd_query += " where  a.buy_dt  like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) kd_query += " where  a.buy_dt  between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		} 

		if(!t_wd.equals("")){

			t_query += " and a.reg_id = '"+t_wd+"' ";
		}
		
		query =	" select  a.*  from parts_order  a " + kd_query + t_query ;


		query += " order by a.buy_dt ";


		try {
				pstmt = conn.prepareStatement(query);
		    		rs = pstmt.executeQuery();
    	
			while(rs.next())
			{
				OrderBean bean = new OrderBean();
				
				bean.setReqseq(rs.getString("reqseq")==null?"":rs.getString("reqseq"));
				bean.setBuy_dt(rs.getString("buy_dt")==null?"":rs.getString("buy_dt"));
				bean.setVen_code(rs.getString("ven_code")==null?"":rs.getString("ven_code"));
				bean.setVen_name(rs.getString("ven_name")==null?"":rs.getString("ven_name"));
				bean.setTrf_st1(rs.getString("trf_st1")==null?"":rs.getString("trf_st1"));
				bean.setTrf_st2(rs.getString("trf_st2")==null?"":rs.getString("trf_st2"));
				bean.setTrf_st3(rs.getString("trf_st3")==null?"":rs.getString("trf_st3"));
				bean.setTrf_amt1(rs.getInt("trf_amt1"));
				bean.setTrf_amt2(rs.getInt("trf_amt2"));
				bean.setTrf_amt3(rs.getInt("trf_amt3"));
		
				vt.add(bean);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println(e);
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
	
	
	public Vector getPartsOrderItemList(String s_kd, String t_wd, String st_dt, String end_dt, String gubun2 , String gubun3 )
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
					   
		String  sub_query  = " select    b.parts_no, p.parts_nm,  a.reg_id, pi.location, b.o_s_amt r_s_amt, b.qty      \n "+
					          " from parts_order a, parts_item b ,parts p   , parts_ipgo i ,parts_item_ip pi     \n "+
						"	where a.reqseq= b.reqseq and b.parts_no = p.parts_no        \n "+
						"	  and a.reqseq = i.o_reqseq and i.reqseq = pi.reqseq  and b.parts_no = pi.parts_no	 \n ";		   
					   
			if(gubun2.equals("1"))			sub_query += " and  a.buy_dt like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun2.equals("6"))		sub_query += " and  a.buy_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' "; //전월
			else if(gubun2.equals("2")){
				if(!st_dt.equals("") && end_dt.equals(""))	sub_query += " and  a.buy_dt  like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) sub_query += " and  a.buy_dt  between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			} 
			
		String query =	" select p.parts_no, p.parts_nm,  \n "+
					 "      sum( decode(p.reg_id, '000047', p.qty , 0) ) m_qty,  sum( decode(p.reg_id, '000047', p.r_s_amt , 0) )  m_r_amt,     \n "+
					"					  sum( decode(p.reg_id, '000234', p.qty , 0) ) o_qty,  sum( decode(p.reg_id, '000234', p.r_s_amt , 0) )  o_r_amt,      \n "+
					 "					  sum(  p.qty  ) t_qty,  sum(  p.r_s_amt )  t_r_amt,     \n "+
					 "                     sum( decode(p.location, 'M', p.qty , 0) ) m_l_qty,  sum( decode(p.location, 'M', p.r_s_amt , 0) )  m_l_r_amt,     \n "+
					 "					  sum( decode(p.location, 'O', p.qty , 0) ) o_l_qty,  sum( decode(p.location, 'O', p.r_s_amt , 0) )  o_l_r_amt,   \n "+  
					 "					  sum(  p.qty  ) t_l_qty,  sum(  p.r_s_amt )  t_l_r_amt    \n "+
					 "  from (  " + sub_query +
					  "  )     p    \n "+
					"    group by p.parts_no, p.parts_nm  \n "+
					 "  order by 1  \n ";
 
			
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
			System.out.println(e);
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
	 *  부품구매 삭제
	 */
	 public boolean deletePartsOrder(String reqseq)
	{
		getConnection();
		boolean flag = true;
		String query = "delete from parts_order "+
						" where  reqseq = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(true);
			pstmt = conn.prepareStatement(query);					
			pstmt.setString(1, reqseq);					
		    pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	} 
	
	/**
	 *  부품구매 삭제
	 */
	 public boolean deletePartsItem(String reqseq)
	{
		getConnection();
		boolean flag = true;
		String query = "delete from parts_item "+
						" where  reqseq = ?  ";  //2
		
		PreparedStatement pstmt = null;

		try 
		{
			conn.setAutoCommit(true);
			pstmt = conn.prepareStatement(query);					
			pstmt.setString(1, reqseq);					
		    pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
	  	} catch (Exception e) {
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	} 
		
		
	 /**
     * 첨부파일 갱신
     */
    public int updatePartsOrderScan(String reqseq, String file_name, String gubun) 
    {
       	getConnection();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int count = 0;
                
	if ( gubun.equals("1") ) {		
		    query=" UPDATE  parts_order  SET file_name1 = ? WHERE reqseq = ? ";		
	} else if  ( gubun.equals("2")) { 
		    query=" UPDATE  parts_order SET file_name2 = ? WHERE  reqseq = ? ";	
	} else  {
		    query=" UPDATE  parts_order SET file_name3 = ? WHERE  reqseq = ? ";	
	}	 				
	            
       try{
		            conn.setAutoCommit(false);
		
		            pstmt = conn.prepareStatement(query);
					pstmt.setString(1, file_name);
		            pstmt.setString(2, reqseq);		      
		            count = pstmt.executeUpdate();             

			pstmt.close();
			
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[PartsDatabase:updatePartsOrderScan]\n"+e);			
	  		e.printStackTrace();
	  		count = 0;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}			
	}
	
	
	//부품명칭 코드 등록
	public String updatePartsOrder(OrderBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
					
		query = " update  parts_order  set  "+
				"       buy_dt  =replace( ?, '-', '')  , ven_code = ? , ven_name = ? , buy_qty = ? , buy_s_amt = ? , buy_v_amt = ? , buy_amt = ? , "+   //7
				"       trf_st1 = ?,  trf_s_amt1 = ?,  trf_v_amt1 = ?, trf_amt1 = ?, trf_a_amt1 = ?, trf_j_amt1 = ?, cardno1 = ?, etc1 = ?,  file_name1= ?, "+  //9
				"       trf_st2 = ? , trf_s_amt2 = ?,  trf_v_amt2 = ?, trf_amt2 = ?, trf_a_amt2 = ?, trf_j_amt2 = ?, cardno2 = ?, etc2 = ?,  file_name2 = ?, "+  //9
				"       trf_st3 = ?,  trf_s_amt3 = ?,  trf_v_amt3 = ?, trf_amt3 = ?, trf_a_amt3 = ?, trf_j_amt3 = ?, cardno3 = ?, etc3 = ?,  file_name3 = ? "+  //9
				"     where reqseq  = ? ";		
						
		try 
		{
			conn.setAutoCommit(false);
						
			pstmt = conn.prepareStatement(query);
		
			pstmt.setString	(1,		bean.getBuy_dt());
			pstmt.setString	(2,		bean.getVen_code());
			pstmt.setString	(3,		bean.getVen_name());				
			pstmt.setInt	(4,		bean.getBuy_qty());	
			pstmt.setInt	(5,		bean.getBuy_s_amt());	
			pstmt.setInt	(6,		bean.getBuy_v_amt());		
			pstmt.setInt	(7,		bean.getBuy_amt());		
			
			pstmt.setString	(8,		bean.getTrf_st1());
			pstmt.setInt	(9,		bean.getTrf_s_amt1());
			pstmt.setInt	(10,		bean.getTrf_v_amt1());
			pstmt.setInt	(11,		bean.getTrf_amt1());			
			pstmt.setInt	(12,		bean.getTrf_a_amt1());
			pstmt.setInt	(13,		bean.getTrf_j_amt1());
			pstmt.setString	(14,		bean.getCardno1());
			pstmt.setString	(15,		bean.getEtc1());			
			pstmt.setString	(16,		bean.getFile_name1());			
			
			pstmt.setString	(17,		bean.getTrf_st2());
			pstmt.setInt	(18,		bean.getTrf_s_amt2());
			pstmt.setInt	(19,		bean.getTrf_v_amt2());
			pstmt.setInt	(20,		bean.getTrf_amt2());			
			pstmt.setInt	(21,		bean.getTrf_a_amt2());
			pstmt.setInt	(22,		bean.getTrf_j_amt2());
			pstmt.setString	(23,		bean.getCardno2());
			pstmt.setString	(24,		bean.getEtc2());	
			pstmt.setString	(25,		bean.getFile_name2());					
			
			pstmt.setString	(26,		bean.getTrf_st3());
			pstmt.setInt	(27,		bean.getTrf_s_amt3());
			pstmt.setInt	(28,		bean.getTrf_v_amt3());
			pstmt.setInt	(29,		bean.getTrf_amt3());			
			pstmt.setInt	(30,		bean.getTrf_a_amt3());
			pstmt.setInt	(31,		bean.getTrf_j_amt3());
			pstmt.setString	(32,		bean.getCardno3());
			pstmt.setString	(33,		bean.getEtc3());		
			pstmt.setString	(34,		bean.getFile_name3());					
			
			pstmt.setString	(35,		bean.getReqseq());
				
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[PartsDatabase:updatePartsOrder]\n"+e);
			System.out.println("[PartsDatabase:updatePartsOrder]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
       			if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean.getReqseq();
		}
	}
		
		//부품입고 등록
	public String insertPartsIpgo(IpgoBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String query = "";
		String id_query = "";
			
		query = " INSERT INTO parts_ipgo ( "+
				"       reqseq, o_reqseq, ip_dt,  "+   //3		
				"      reg_dt, reg_id ) VALUES "+
				"	 ( ?,  ?,  replace( ?, '-', '') ,  "+					
				"      to_char(sysdate,'YYYYMMDD'),  ?  )";				
				
		id_query = " select to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(reqseq,9,7))+1), '0000000')), '0000001') reqseq"+
				" from parts_ipgo "+
				" where substr(reqseq,1,8)=to_char(sysdate,'YYYYMMDD')";


		try 
		{
			conn.setAutoCommit(false);

			//새 reqseq 조회
			pstmt1 = conn.prepareStatement(id_query);
	    		rs = pstmt1.executeQuery();   	
			if(rs.next())
			{				
				bean.setReqseq(rs.getString(1));
			}
			rs.close();
			pstmt1.close();
						
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getReqseq());
			pstmt.setString	(2,		bean.getO_reqseq());
			pstmt.setString	(3,		bean.getIp_dt());			
			pstmt.setString	(4,		bean.getReg_id());				
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[PartsDatabase:insertPartsIpgo]\n"+e);
			System.out.println("[PartsDatabase:insertPartsIpgo]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(rs != null )	    rs.close();
				if(pstmt1 != null )	pstmt1.close();
               	if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean.getReqseq();
		}
	}		
	
	
	//부품구매내역 입고등록
	public boolean insertPartsItemIpgo(ItemIpBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
					
		query = " INSERT INTO parts_item_ip ( "+
				"       reqseq, seq_no, parts_no, qty, "+
				"      location, trans , io_yn, reg_id, reg_dt, car_comp_id, car_cd ) VALUES "+
				"	 ( ?,  ?,  ?,  ? , "+
				"     ?,  ?, ?, ?, to_char(sysdate,'YYYYMMdd'),? ,?   )";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getReqseq());
			pstmt.setInt	(2,		bean.getSeq_no());
			pstmt.setString	(3,		bean.getParts_no());
			pstmt.setInt	(4,		bean.getQty());
			
			pstmt.setString	(5,		bean.getLocation());
			pstmt.setString	(6,		bean.getTrans());
			pstmt.setString	(7,		bean.getIo_yn());
			pstmt.setString	(8,		bean.getReg_id());
			pstmt.setString	(9,		bean.getCar_comp_id());
			pstmt.setString	(10,	bean.getCar_cd());
							
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[PartsDatabase:insertPartsItemIpgo]\n"+e);
			System.out.println("[PartsDatabase:insertPartsItemIpgo]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	
	/**
	 *	재고 등록여부 구하기
	 */
	public int getPartsStockLoc(String parts_no, String location, String kisu, String mm )
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		int cnt = 0;

		query = " select  count(0)  from parts_stock   where parts_no='"+parts_no +"' and location='"+location+"' and kisu = '" + kisu +  "' and mm = '" + mm + "'";

		try {
			stmt = conn.createStatement();
		    	rs = stmt.executeQuery(query);    	
			if(rs.next())
			{				
				cnt	= rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[PartsDatabase:getPartsStockLoc]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cnt;
		}
	}


	//부품재고 마스터 등록
	public boolean insertPartsStock(StockBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
					
		query = " INSERT INTO parts_stock ( "+
				"       parts_no, location, kisu , mm,  "+
				"      reg_id, reg_dt, car_comp_id, car_cd ) VALUES "+
				"	 ( ?,  ?,  ?,  ? , "+
				"     ?,   to_char(sysdate,'YYYYMMdd'), ?, ?  )";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getParts_no());
			pstmt.setString	(2,		bean.getLocation());
			pstmt.setString	(3,		bean.getKisu());
			pstmt.setString	(4,		bean.getMm());
			pstmt.setString	(5,		bean.getReg_id());			
			pstmt.setString	(6,		bean.getCar_comp_id());
			pstmt.setString	(7,		bean.getCar_cd());
		
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[PartsDatabase:insertPartsStock]\n"+e);
			System.out.println("[PartsDatabase:insertPartsStock]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	
	//부품명칭 코드 등록
	public boolean  updatePartsStock(ItemIpBean bean, String kisu, String mm, String gubun)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
	
			
		query = " update  parts_stock  set  "+
				"       ip_qty = ip_qty + ?, ch_qty = ch_qty + ? , "+   //7				
				"       upd_id = ?,  upd_dt = to_char(sysdate,'YYYYMMdd') "+  //9
				"     where parts_no = ? and location = ? and kisu = '"+ kisu + "' and mm ='" + mm + "' ";		
						
		try 
		{
			conn.setAutoCommit(false);
						
			pstmt = conn.prepareStatement(query);
			    
		    pstmt.setInt	(1,		bean.getQty());	
			pstmt.setInt	(2,		0);		        			      								
			pstmt.setString	(3,		bean.getReg_id());						
			pstmt.setString	(4,		bean.getParts_no());
			pstmt.setString	(5,		bean.getLocation());
				
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[PartsDatabase:updatePartsStock]\n"+e);
			System.out.println("[PartsDatabase:updatePartsStock]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
       			if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	
	public boolean  updatePartsStockCh(ItemChBean bean, String kisu, String mm, String gubun)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
	
			
		query = " update  parts_stock  set  "+
				"       ip_qty = ip_qty + ?, ch_qty = ch_qty + ? , "+   //7				
				"       upd_id = ?,  upd_dt = to_char(sysdate,'YYYYMMdd') "+  //9
				"     where parts_no = ? and location = ? and kisu = '"+ kisu + "' and mm ='" + mm + "' and car_comp_id = ? and car_cd = ? ";		
						
		try 
		{
			conn.setAutoCommit(false);
						
			pstmt = conn.prepareStatement(query);
		
		    if ( gubun.equals("C") ) {
		      	pstmt.setInt	(1,		0);	
				pstmt.setInt	(2,		bean.getQty());			 
		    }else{
		      	pstmt.setInt	(1,		0);	
				pstmt.setInt	(2,		0);			 
			}
								
			pstmt.setString	(3,		bean.getReg_id());						
			pstmt.setString	(4,		bean.getParts_no());
			pstmt.setString	(5,		bean.getLocation());
			pstmt.setString	(6,		bean.getCar_comp_id());
			pstmt.setString	(7,		bean.getCar_cd());
				
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[PartsDatabase:updatePartsStock]\n"+e);
			System.out.println("[PartsDatabase:updatePartsStock]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
       			if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	

     public Vector getBasePartsLocationList(String s_kd, String t_wd, String sort, String a) 
    {
        getConnection();
	
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        Vector vt = new Vector();
        String query = "";
        String kd_query = "";        
         String s_query = "";        
        
        if (  !s_kd.equals("")  ) { 
	        if(s_kd.equals("1"))		kd_query += "  and  a.parts_no like '%"+ t_wd + "%'";
	        else if(s_kd.equals("3"))	kd_query += "  and  pa.location like '%"+ t_wd + "%'";
	}
	
	//특정부품조회가 아니면 
	 if (  t_wd.equals("") ) { 
	 		s_query += "       and   (pa.ip_qty  -  pa.ch_qty ) > 0 ";
          }
          		
    	query =  "    SELECT a.parts_no , a.parts_nm, c.nm ,  cm.car_nm  , decode(a.a_st, '1',  '전모델', '한정') a_st_nm, decode(a.c_st, '1', '있슴', '없슴') c_st_nm ,   \n"+		
                    "        pa.location,  decode(pa.location, 'M', '명진', 'O', '오토크린') location_nm,  pa.kisu, (pa.ip_qty  -  pa.ch_qty ) stock, a.CAR_CD, a.CAR_COMP_ID \n"+		
        		 "    FROM   parts  a,  car_mng cm, code c ,   \n"+		
                    "       ( select a.parts_no, a.location , a.kisu, sum(ip_qty) ip_qty,  sum(ch_qty) ch_qty  \n"+		
                    "             from parts_stock a, ( select parts_no, location, max(kisu) kisu from parts_stock group by  parts_no, location ) b  \n"+		
                    "            where a.parts_no = b.parts_no and a.location = b.location and a.kisu=b.kisu    group by a.parts_no, a.location , a.kisu ) pa  \n"+		
        		 "     WHERE  a.car_comp_id=c.code and c.c_st = '0001' and    a.car_comp_id=cm.car_comp_id and a.car_cd=cm.code   " + kd_query  +
                    "                   and a.parts_no = pa.parts_no " + s_query  +                 
		 "      ORDER BY   a.parts_no  ";
	 	
		
        
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
			System.out.println("[PartsDatabase:getBasePartsLocationList]"+e);
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

		
     public Vector getPartsChulgoList(String s_kd, String t_wd, String st_dt, String end_dt, String gubun2 , String gubun3 )
    {
        getConnection();
	
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        Vector vt = new Vector();
        String query = "";
        String kd_query = "";      
		String t_query = ""; 
        
	 	
	if(gubun2.equals("1"))			kd_query += " and  a.ch_dt like to_char(sysdate,'YYYYMM')||'%'";
	else if(gubun2.equals("6"))		kd_query += " and  a.ch_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' "; //전월
	else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	kd_query += " and  a.ch_dt  like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) kd_query += " and  a.ch_dt  between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
	} 
	
	if(!t_wd.equals("")){
		t_query += " and a.reg_id = '"+t_wd+"' ";
	}


  	query =  "   select a.reqseq, a.ch_dt, cr.car_no, ip.parts_no, ip.cnt , ip.qty, decode(ip.location, 'M', '명진', 'O', '오토크린') location_nm ,  c.firm_nm, u.user_nm  , cr.car_nm  \n"+		
			"    from parts_chulgo a,    car_reg cr ,   cont_n_view c  , users u  ,   ( select bb.reqseq, min(bb.parts_no) parts_no , max(bb.seq_no)  cnt , sum(qty) qty , min(location) location from parts_item_ch bb, parts_chulgo a  where bb.reqseq = a.reqseq group by bb.reqseq ) ip   \n"+		
			"     where a.reqseq = ip.reqseq  " + kd_query  +
			"   and a.car_mng_id = cr.car_mng_id and a.rent_l_cd = c.rent_l_cd and a.bus_id2 = u.user_id \n"+ t_query +
			 "    order by   a.ch_dt  ";
			 		
        
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
			System.out.println("[PartsDatabase:getPartsChulgoList]"+e);
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
	
	
	public ChulgoBean getPartsChulgo(String reqseq)
	{
		getConnection();
		ChulgoBean bean = new ChulgoBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select a.*   from parts_chulgo  a   "+
						" where a.reqseq = '"+reqseq + "'";

		try {
			pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
    	         	             
			if(rs.next())
			{
				bean.setReqseq(rs.getString("reqseq")==null?"":rs.getString("reqseq"));			
				bean.setCh_dt(rs.getString("ch_dt")==null?"":rs.getString("ch_dt"));
				bean.setCar_mng_id(rs.getString("car_mng_id")==null?"":rs.getString("car_mng_id"));
				bean.setRent_l_cd(rs.getString("rent_l_cd")==null?"":rs.getString("rent_l_cd"));
				bean.setBus_id2(rs.getString("bus_id2")==null?"":rs.getString("bus_id2"));
				bean.setOff_id(rs.getString("off_id")==null?"":rs.getString("off_id"));																
				bean.setReg_id(rs.getString("reg_id")==null?"":rs.getString("reg_id"));
				bean.setReg_dt(rs.getString("reg_dt")==null?"":rs.getString("reg_dt"));
				bean.setUpd_id(rs.getString("upd_id")==null?"":rs.getString("upd_id"));
				bean.setUpd_dt(rs.getString("upd_dt")==null?"":rs.getString("upd_dt"));
				bean.setSac_dt(rs.getString("sac_dt")==null?"":rs.getString("sac_dt"));		
				bean.setIpgo_dt(rs.getString("ipgo_dt")==null?"":rs.getString("ipgo_dt"));		
				bean.setChulgo_dt(rs.getString("chulgo_dt")==null?"":rs.getString("chulgo_dt"));
				bean.setI_reqseq(rs.getString("i_reqseq")==null?"":rs.getString("i_reqseq"));			
				
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println(e);
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
	
		//부품출고 등록 - 순번
	public String getPartsChulgoReqseq(String ch_dt)
	{
		getConnection();

		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String id_query = "";
		String reqseq = "";
						
		id_query = " select to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(reqseq,9,7))+1), '0000000')), '0000001') reqseq"+
				" from parts_chulgo "+
				" where substr(reqseq,1,8)=to_char(sysdate,'YYYYMMDD')";

		try 
		{
		
			//새 reqseq 조회
			pstmt1 = conn.prepareStatement(id_query);
	    		rs = pstmt1.executeQuery();   	
			if(rs.next())
			{				
				reqseq = rs.getString(1);
			}
			rs.close();
			pstmt1.close();
		
	  	} catch (Exception e) {
			System.out.println("[PartsDatabase:getPartsChulgoReqseq]\n"+e);			
			e.printStackTrace();
	  	
		} finally {
			try{
				if(rs != null )	    rs.close();
				if(pstmt1 != null )	pstmt1.close();                		
			}catch(Exception ignore){}
			closeConnection();
			return reqseq;
		}
	}		
	
	
		//부품구매내역 출고등록
	public boolean insertPartsChulgo(ChulgoBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
					
		query = " INSERT INTO parts_chulgo ( "+
				"       reqseq, ch_dt,  "+
				"       car_mng_id, rent_l_cd, bus_id2, off_id, ipgo_dt, chulgo_dt,   "+ //6
				"       reg_id, reg_dt , i_reqseq ) VALUES "+			
				"	 ( ?, replace( ?, '-', ''),   "+
				"	  ?,  ?,  ?,  ? , ?, ? ,   "+
				"      ?,  to_char(sysdate,'YYYYMMdd') , ?  )";

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getReqseq());		
			pstmt.setString	(2,		bean.getCh_dt());					
			
			pstmt.setString	(3,		bean.getCar_mng_id());
			pstmt.setString	(4,		bean.getRent_l_cd());		
			pstmt.setString	(5,		bean.getBus_id2());
			pstmt.setString	(6,		bean.getOff_id());		
			pstmt.setString	(7,		bean.getIpgo_dt());
			pstmt.setString	(8,		bean.getChulgo_dt());		
			
			pstmt.setString	(9,		bean.getReg_id());
			pstmt.setString	(10,		bean.getI_reqseq());
										
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[PartsDatabase:insertPartsChulgo]\n"+e);
			System.out.println("[PartsDatabase:insertPartsChulgo]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
		// 등록
	public boolean  updatePartsChStock(ChulgoBean bean, String kisu, String mm)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
				
		query = " update  parts_stock  set  "+
				"      ch_qty = ch_qty + ? ,  upd_id = ?,  upd_dt = to_char(sysdate,'YYYYMMdd') "+  //9
				"     where parts_no = ? and location = ? and kisu = '"+ kisu + "' and mm ='" + mm + "' ";		
						
		try 
		{
			conn.setAutoCommit(false);
						
			pstmt = conn.prepareStatement(query);		
         	pstmt.setInt	(1,		bean.getQty());				
			pstmt.setString	(2,		bean.getReg_id());						
			pstmt.setString	(3,		bean.getParts_no());
			pstmt.setString	(4,		bean.getLocation());				
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[PartsDatabase:updatePartsChStock]\n"+e);
			System.out.println("[PartsDatabase:updatePartsChStock]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
       			if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	
	
		// 등록
	public boolean  updatePartsChulgoSacDt( String reqseq, int seq_no)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
				
		query = " update  parts_chulgo  set  "+
				"      sac_dt = to_char(sysdate,'YYYYMMdd')    where reqseq = ? and seq_no = ?  ";		
						
		try 
		{
			conn.setAutoCommit(false);
						
			pstmt = conn.prepareStatement(query);
		
		    pstmt.setString	(1,		reqseq);				
			pstmt.setInt	(2,		seq_no);			
								
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[PartsDatabase:updatePartsChulgoSacDt]\n"+e);
			System.out.println("[PartsDatabase:updatePartsChulgoSacDt]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
       			if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	
	public Vector getPartsChulgoDetail(String reqseq, int seq_no)
	{
	        getConnection();
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;        
	        Vector vt = new Vector();
	        String query = "";
				
	       query = 	" select a.* , p.ipgo_dt , p.chulgo_dt,   u.user_nm, c.car_no , c.car_nm, u.user_m_tel ,  decode(f.rent_way,'1','일반식','기본식') rent_way, cd.nm dept_nm  "+
	                            "  from parts_chulgo  a,  parts_detail p, car_reg c , users u ,  ( select * from code where  c_st  = '0002' ) cd  ,  "+
	                            "   cont co,  fee f, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) g    "+
				" where a.reqseq  = p. reqseq and a.seq_no = p.seq_no and  p.car_mng_id = c.car_mng_id(+) and p.bus_id2= u.user_id(+) \n"+
				" and   p.rent_l_cd = co.rent_l_cd and   co.rent_mng_id=f.rent_mng_id and co.rent_l_cd=f.rent_l_cd "+
				" and    f.rent_mng_id=g.rent_mng_id and f.rent_l_cd=g.rent_l_cd and f.rent_st=g.rent_st "+
				"           and  u.dept_id = cd.code and  a.reqseq = '"+reqseq+"' and a.seq_no = "+seq_no;
				
	        
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
				System.out.println("[PartsDatabase:getPartsChulgoDetail]"+e);
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
	
	
	//부품구매 카드결재요청
	public boolean  updatePartsOrderSacDt(String  reqseq )
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
				
		query = " update  parts_order  set sac_dt = to_char(sysdate,'YYYYMMdd')  "+
			     "     where reqseq = ?  ";		
						
		try 
		{
			conn.setAutoCommit(false);
						
			pstmt = conn.prepareStatement(query);
		
		  	pstmt.setString	(1,		reqseq);
						
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[PartsDatabase:updatePartsOrderReqDt]\n"+e);
			System.out.println("[PartsDatabase:updatePartsOrderReqDt]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	//부품구매 카드결재요청
	public boolean  updatePartsOrderIpgo_yn(String  reqseq )
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
				
		query = " update  parts_order  set ipgo_yn = 'Y'  "+
			     "     where reqseq = ?  ";		
						
		try 
		{
			conn.setAutoCommit(false);
						
			pstmt = conn.prepareStatement(query);
		
		  	pstmt.setString	(1,		reqseq);
						
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[PartsDatabase:updatePartsOrderIpgo_yn]\n"+e);
			System.out.println("[PartsDatabase:updatePartsOrderIpgo_yn]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
     public Vector getPartsIpgoList(String s_kd, String t_wd, String st_dt, String end_dt, String gubun2 , String gubun3 )
    {
        getConnection();
	
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        Vector vt = new Vector();
        String query = "";
        String kd_query = "";      
		String t_query = "";  
        
	
	if(gubun2.equals("1"))			kd_query += " and  a.ip_dt like to_char(sysdate,'YYYYMM')||'%'";
	else if(gubun2.equals("6"))		kd_query += " and  a.ip_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' "; //전월
	else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	kd_query += " and  a.ip_dt  like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) kd_query += " and  a.ip_dt  between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
	} 
		if(!t_wd.equals("")){

			t_query += " and a.reg_id = '"+t_wd+"' ";
		}
			
		
	  query =  "   select a.reqseq, a.ip_dt, ip.parts_no, ip.cnt , ip.qty, decode(ip.location, 'M', '명진', 'O', '오토크린') location_nm, a.chulgo_yn, b.buy_amt   \n"+		
			"    from parts_ipgo a,  parts_order b, ( select bb.reqseq, min(bb.parts_no) parts_no , max(bb.seq_no)  cnt , sum(qty) qty , min(location) location from parts_item_ip bb, parts_ipgo a  where bb.reqseq = a.reqseq group by bb.reqseq ) ip   \n"+		
			"     where a.reqseq = ip.reqseq  " + kd_query  +
			"   and a.o_reqseq = b.reqseq(+)  \n"+ t_query +
			 "    order by   a.ip_dt  ";
			
        
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
			System.out.println("[PartsDatabase:getPartsIpgoList]"+e);
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
	
	public IpgoBean getPartsIpgo(String reqseq)
	{
		getConnection();
		IpgoBean bean = new IpgoBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	" select a.* from parts_ipgo  a  "+
						" where a.reqseq = '"+reqseq+"' ";

		try {
			pstmt = conn.prepareStatement(query);
		   	rs = pstmt.executeQuery();
    	         	             
			if(rs.next())
			{
				bean.setReqseq(rs.getString("reqseq")==null?"":rs.getString("reqseq"));
				bean.setO_reqseq(rs.getString("o_reqseq")==null?"":rs.getString("o_reqseq"));
				bean.setIp_dt(rs.getString("ip_dt")==null?"":rs.getString("ip_dt"));
							
				bean.setReg_id(rs.getString("reg_id")==null?"":rs.getString("reg_id"));
				bean.setReg_dt(rs.getString("reg_dt")==null?"":rs.getString("reg_dt"));
				bean.setUpd_id(rs.getString("upd_id")==null?"":rs.getString("upd_id"));
				bean.setUpd_dt(rs.getString("upd_dt")==null?"":rs.getString("upd_dt"));
				
						
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println(e);
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
	
	/**
	 *	부품가격  리스트
	 */
	public Vector getPartsItemIpList(String reqseq)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query =	" select  a.* ,   b.parts_nm  , c.nm maker_nm ,  cm.car_nm    from parts_item_ip a, parts b,  car_mng cm, code c   "+
						" where    a.parts_no = b.parts_no AND a.CAR_CD = b.CAR_CD  AND a.CAR_COMP_ID = b.CAR_COMP_ID and a.reqseq = '"+reqseq+"'  and   b.car_comp_id=c.code and c.c_st = '0001' and    b.car_comp_id=cm.car_comp_id and b.car_cd=cm.code  ";

		query += " order by a.seq_no ";
	


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
			System.out.println(e);
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
	
	
	//출고 - 정비계약정보
	public Hashtable getContViewCarCase(String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";


		query = " SELECT d.car_no, D.CAR_NM, b.user_nm, b.user_m_tel, b.dept_id,  c.nm dept_nm, DECODE(e.rent_way,'1','일반식','기본식') rent_way "+
				" FROM   CONT a, USERS b, ( select * from code where c_st = '0002' ) c, CAR_REG d,  "+
				" 		 FEE e, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) f "+
				" WHERE  a.rent_l_cd='"+rent_l_cd+"'  and a.bus_id2=b.user_id   and b.dept_id = C.CODE "+
				"        AND a.car_mng_id=d.car_mng_id "+
				"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd  "+
				"        and e.rent_mng_id=f.rent_mng_id and e.rent_l_cd=f.rent_l_cd AND e.rent_st=f.rent_st "+
				" ";

		try 
		{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[PartsDatabase:getContViewCarCase]\n"+e);
			System.out.println("[PartsDatabase:getContViewCarCase]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
    }
	
//차량번호별 거래명세서 출력	
      public Vector getPartsChulgoPrintList(String s_gubun1, String st_dt, String end_dt, String s_kd, String t_wd, String sort, String a) 
    {
        getConnection();
	
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        Vector vt = new Vector();
        String query = "";
        String kd_query = "";        
        
        
        if (  !s_kd.equals("") ) { 
	        if(s_kd.equals("1"))		kd_query += "  and  cr.car_no like '%"+ t_wd + "%'";
	        else if(s_kd.equals("2"))	kd_query += "  and  pc.reg_id    =  '"+ t_wd + "' ";
	}	
		
		
         query =  "   SELECT  pc.car_mng_id, pc.reqseq, cr.car_no, cr.car_nm, pc.ch_dt, c.firm_nm, u.user_nm , so.off_nm,          \n"+		
             	  "        sum( pi.qty * b.r_s_amt ) r_s_amt  \n"+       
		      "	        FROM     parts_chulgo pc , parts_item_ch pi,  car_reg cr , cont_n_view c  , users u,  serv_off so,  parts p, 	 \n"+	
		      "           parts_price b,   (select parts_no,  max(seq_no)  seq_no   from   parts_price   group by parts_no) bm   \n"+		
		      "       WHERE   pc.rent_l_cd = c.rent_l_cd and pc.car_mng_id =  cr.car_mng_id  and pc.bus_id2 = u.user_id   	 \n"+
		      "         AND     pc.reqseq = pi.reqseq and  pi.parts_no = p.parts_no AND pi.CAR_CD = p.CAR_CD AND pi.CAR_COMP_ID = p.CAR_COMP_ID \n"+		
		      "           AND    p.parts_no = b.parts_no  and b.parts_no = bm.parts_no  and b.seq_no = bm.seq_no \n"+	
		      "            AND pc.off_id = so.off_id(+) " + kd_query+ "\n" ;	
		      
	if(s_gubun1.equals("1")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and  pc.ch_dt  like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and  pc.ch_dt  between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
	}	      
		     
	query += "  GROUP BY   pc.car_mng_id, pc.reqseq, cr.car_no, cr.car_nm, pc.ch_dt, c.firm_nm, u.user_nm , so.off_nm ";	      	
	query += "  ORDER BY  cr.car_no,  pc.ch_dt ";
  		
	
        
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
			System.out.println("[PartsDatabase:getPartsChulgoList]"+e);
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
		
		//거래명세서
	public Vector getDocCase(String reqseq, String car_mng_id, String ch_dt )
	{
		getConnection();
		 PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
		
		query =  "   SELECT  pc.car_mng_id, pc.reqseq, cr.car_no, cr.car_nm, pc.ch_dt, c.firm_nm, u.user_nm , so.off_nm  ,    \n"+		
		      "          pi.parts_no , pi.qty , p.parts_nm,   pi.qty * b.r_s_amt   r_s_amt,   b.r_v_amt * pi.qty   r_v_amt  \n"+
		      "	        FROM     parts_chulgo pc ,  parts_item_ch pi,  car_reg cr , cont_n_view c  , users u ,  serv_off so,  parts p,	 \n"+	
		      "           parts_price b,   (select parts_no,  max(seq_no)  seq_no   from   parts_price where app_dt  <= '" + ch_dt + "'  group by parts_no) bm   \n"+		
		      "       WHERE   pc.rent_l_cd = c.rent_l_cd and pc.car_mng_id =  cr.car_mng_id  and pc.bus_id2 = u.user_id   	 \n"+		
		      "           AND     pc.reqseq = pi.reqseq and  pi.parts_no = p.parts_no AND pi.CAR_CD = p.CAR_CD AND pi.CAR_COMP_ID = p.CAR_COMP_ID \n"+		
		      "           AND    p.parts_no = b.parts_no  and b.parts_no = bm.parts_no  and b.seq_no = bm.seq_no \n"+	
		      "           AND pc.off_id = so.off_id(+)  and pc.reqseq = '"+ reqseq+ "' and pc.car_mng_id = '" + car_mng_id + "' \n"+		
		      "       ORDER BY  cr.car_no,  pc.ch_dt, pi.seq_no  ";   
		
  
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
			System.out.println("[PartsDatabase:getDocCase]"+e);
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
	
    	
       public Vector getPartsIpgoSearchList(String s_kd, String t_wd, String sort, String a) 
    {
        getConnection();
	
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        Vector vt = new Vector();
        String query = "";
        String kd_query = "";        
        
			 
	  query =  "  		select ip_dt, reqseq,  substr(max(sys_connect_by_path(parts_no||':'||parts_nm , '^')), 2) p_title  \n"+		
			"		from ( \n"+		
			"		select a.ip_dt, bb.reqseq, bb.parts_no, c.parts_nm ,  \n"+		
			"		      row_number() over(partition by a.ip_dt, bb.reqseq order by 3, 4) rn \n"+		
			"		    from parts_item_ip bb, parts_ipgo a , parts c  where bb.reqseq = a.reqseq  and bb.parts_no = c.parts_no  \n"+		
			"		    ) \n"+		
			"		 start with rn = 1 \n"+		
			"		 connect by prior ip_dt = ip_dt and  prior rn = rn-1 \n"+		
			"		 group by ip_dt   , reqseq 		"; 
		
        
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
			System.out.println("[PartsDatabase:getPartsIpgoSearchList]"+e);
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
	
		//부품구매내역 출고등록
	public boolean insertPartsItemChulgo(ItemChBean bean)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
					
		query = " INSERT INTO parts_item_ch ( "+
				"       reqseq, seq_no, parts_no, qty, "+
				"      location, reg_id, reg_dt, car_comp_id, car_cd ) VALUES "+
				"	 ( ?,  ?,  ?,  ? , "+
				"     ?,  ?, to_char(sysdate,'YYYYMMdd'), ?, ?   )";


		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		bean.getReqseq());
			pstmt.setInt	(2,		bean.getSeq_no());
			pstmt.setString	(3,		bean.getParts_no());
			pstmt.setInt	(4,		bean.getQty());
			
			pstmt.setString	(5,		bean.getLocation());
			pstmt.setString	(6,		bean.getReg_id());
			pstmt.setString	(7,		bean.getCar_comp_id());
			pstmt.setString	(8,		bean.getCar_cd());

							
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
			
	  	} catch (Exception e) {
			System.out.println("[PartsDatabase:insertPartsItemChulgo]\n"+e);
			System.out.println("[PartsDatabase:insertPartsItemChulgo]\n"+query);
			System.out.println("[PartsDatabase:insertPartsItemChulgo::getParts_no=]\n"+bean.getParts_no());
			System.out.println("[PartsDatabase:insertPartsItemChulgo::getCar_comp_id=]\n"+bean.getCar_comp_id());
			System.out.println("[PartsDatabase:insertPartsItemChulgo::getCar_cd=]\n"+bean.getCar_cd());
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	
	
	//
	public boolean  updatePartsIpgoChulgo_yn(String  reqseq )
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
				
		query = " update  parts_ipgo  set chulgo_yn = 'Y'  "+
			     "     where reqseq = ?  ";		
						
		try 
		{
			conn.setAutoCommit(false);
						
			pstmt = conn.prepareStatement(query);
		
		  	pstmt.setString	(1,		reqseq);
						
			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
	  	} catch (Exception e) {
			System.out.println("[PartsDatabase:updatePartsIpgoChulgo_yn]\n"+e);
			System.out.println("[PartsDatabase:updatePartsIpgoChulgo_yn]\n"+query);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}
	
	
	/**
	 *	부품출고  리스트
	 */
	public Vector getPartsItemChList(String reqseq)
	{
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query =	" select  a.* ,   b.parts_nm  , c.nm maker_nm ,  cm.car_nm    from parts_item_ch a, parts b,  car_mng cm, code c   "+
						" where    a.parts_no = b.parts_no AND a.CAR_CD = b.CAR_CD  AND a.CAR_COMP_ID = b.CAR_COMP_ID and a.reqseq = '"+reqseq+"'  and   b.car_comp_id=c.code and c.c_st = '0001' and    b.car_comp_id=cm.car_comp_id and b.car_cd=cm.code  ";

		query += " order by a.seq_no ";
	
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
			System.out.println(e);
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
	

 public Vector getPartsIpgoList(String s_kd, String t_wd, String sort, String a) 
    {
        getConnection();
	
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        Vector vt = new Vector();
        String query = "";
        String kd_query = "";        
        
        if (  !s_kd.equals("") ) { 
	        if(s_kd.equals("1"))		kd_query += "  and  a.parts_no like '%"+ t_wd + "%'";
	        else if(s_kd.equals("2"))	kd_query += "  and  a.parts_nm like '%"+ t_wd + "%'";
	}	
		
	  query =  "   select a.reqseq, a.ip_dt, ip.parts_no, ip.cnt , ip.qty, decode(ip.location, 'M', '명진', 'O', '오토크린') location_nm, a.chulgo_yn, b.buy_amt   \n"+		
			"    from parts_ipgo a,  parts_order b, ( select bb.reqseq, min(bb.parts_no) parts_no , max(bb.seq_no)  cnt , sum(qty) qty , min(location) location from parts_item_ip bb, parts_ipgo a  where bb.reqseq = a.reqseq group by bb.reqseq ) ip   \n"+		
			"     where a.reqseq = ip.reqseq  " + kd_query  +
			"   and a.o_reqseq = b.reqseq(+)  \n"+	
			 "    order by   a.ip_dt  desc ";		 			
		
        
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
			System.out.println("[PartsDatabase:getPartsIpgoList]"+e);
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
	
}
