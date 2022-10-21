/**
 * 자산관리
 */
package acar.asset;

import java.util.*;
import java.sql.*;
import acar.util.*;
import java.io.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;
import acar.offls_actn.*;

import org.json.simple.JSONObject;
import org.json.simple.JSONArray;

public class AssetDatabase {

    private static AssetDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
  
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized AssetDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new AssetDatabase();
        return instance;
    }
    
    private AssetDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }


	//자산관리----------------------------------------------------------------------------------------------------------------
    public AssetVarBean getAssetVarCase(String a_a, String seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        AssetVarBean bean = new AssetVarBean();
        String query = "";
        
        query = " select * from asset_var where a_a='"+a_a+"'";

		if(seq.equals("")){
			query += " and seq = (select max(seq) from asset_var where a_a='"+a_a+"')";
		}else{
			query += " and seq='"+seq+"'";
		}

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            if(rs.next()){
				bean.setA_a(rs.getString("A_A"));
			    bean.setSeq(rs.getString("SEQ"));
			    bean.setB_1(rs.getFloat("B_1"));
			    bean.setB_2(rs.getString("B_2"));
			    bean.setB_3(rs.getString("B_3"));
			    bean.setB_4(rs.getString("B_4"));
			    bean.setB_5(rs.getString("B_5"));
			    bean.setC_1(rs.getString("C_1"));
			    bean.setC_2(rs.getFloat("C_2"));
			    bean.setC_3(rs.getString("C_3"));
			    bean.setC_4(rs.getString("C_4"));
			    bean.setC_5(rs.getString("C_5"));
			    bean.setD_1(rs.getString("D_1"));
			    bean.setD_2(rs.getString("D_2"));
			    bean.setD_3(rs.getString("D_3"));
			    bean.setD_4(rs.getString("D_4"));
			    bean.setD_5(rs.getString("D_5"));
			    bean.setA_1(rs.getString("A_1"));
			              									
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[AssetDatabase:getAssetVarCase]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }
    
    public String insertAssetVar(AssetVarBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
    	Statement stmt = null;
        ResultSet rs = null;
        String query1 = "";
		String query2 = "";
		String seq = "";
        int count = 0;

		query1 = " SELECT nvl(lpad(max(SEQ)+1,2,'0'),'01') FROM ASSET_VAR ";
			
        query2 = " INSERT INTO ASSET_VAR"+
				" (a_a, seq,    b_1, b_2, b_3, b_4, b_5, "+
				"  c_1, c_2, c_3, c_4, c_5,   d_1, d_2, d_3, d_4, d_5, a_1 "+
				"  ) "+	
				" values \n"+
	            " ( ?, ?,     ?, ?, replace(?,'-',''), replace(?,'-',''), ?,"+
				"   ?, ?, replace(?,'-',''), replace(?,'-',''), ?,    ?, ?, replace(?,'-',''), replace(?,'-',''), ? , ? )";
			
           
       try{
            con.setAutoCommit(false);

            //seq 생성
            stmt = con.createStatement();
            rs = stmt.executeQuery(query1);
            if(rs.next())
            	seq = rs.getString(1);
            rs.close();
      		stmt.close();

            pstmt = con.prepareStatement(query2);
            pstmt.setString(1, bean.getA_a().trim());
            pstmt.setString(2, seq.trim());
            pstmt.setFloat(3, bean.getB_1());
            pstmt.setString(4, bean.getB_2());
            pstmt.setString(5, bean.getB_3());
            pstmt.setString(6, bean.getB_4());
            pstmt.setString(7, bean.getB_5());
            pstmt.setString(8, bean.getC_1());
            pstmt.setFloat(9, bean.getC_2());
            pstmt.setString(10, bean.getC_3());
            pstmt.setString(11, bean.getC_4());
            pstmt.setString(12, bean.getC_5());
            pstmt.setString(13, bean.getD_1());
            pstmt.setString(14, bean.getD_2());
            pstmt.setString(15, bean.getD_3());
            pstmt.setString(16, bean.getD_4());
            pstmt.setString(17, bean.getD_5());     
            pstmt.setString(18, bean.getA_1());               
           
			count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(Exception se){
            try{
				System.out.println("[AssetDatabase:insertAssetVar]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return seq;
    }

  
    public int updateAssetVar(AssetVarBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE ASSET_VAR SET"+
				" b_1=?, b_2=?, b_3=replace(?,'-',''), b_4=replace(?,'-',''), b_5=?, "+
				" c_1=?, c_2=?, c_3=replace(?,'-',''), c_4=replace(?,'-',''), c_5=?, "+
				" d_1=?, d_2=?, d_3=replace(?,'-',''), d_4=replace(?,'-',''), d_5=?, "+
				" a_1=? "+
				" WHERE a_a=? AND seq=?\n";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);  
            
            pstmt.setFloat(1, bean.getB_1());
            pstmt.setString(2, bean.getB_2());
            pstmt.setString(3, bean.getB_3());
            pstmt.setString(4, bean.getB_4().trim());
            pstmt.setString(5, bean.getB_5().trim());
         
            pstmt.setString(6, bean.getC_1());
            pstmt.setFloat(7, bean.getC_2());
            pstmt.setString(8, bean.getC_3());
            pstmt.setString(9, bean.getC_4().trim());
            pstmt.setString(10, bean.getC_5().trim());
         
            pstmt.setString(11, bean.getD_1());
            pstmt.setString(12, bean.getD_2());
            pstmt.setString(13, bean.getD_3());
            pstmt.setString(14, bean.getD_4().trim());
            pstmt.setString(15, bean.getD_5().trim());   
            
            pstmt.setString(16, bean.getA_1().trim());      
         
			pstmt.setString(17, bean.getA_a().trim());
			pstmt.setString(18, bean.getSeq().trim());
    	

            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AssetDatabase:updateAssetVar]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

  
	public AssetVarBean getAssetVarList(String gubun1) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		AssetVarBean bean = new AssetVarBean();
		String query = "";

		query = " select * from asset_var b "+
				" where b.a_a = '" + gubun1 + "' and seq = (select max(seq) from asset_var a where a.a_a=b.a_a ) "+
				" order by 1,2 ";

		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
	    	
	    	  if(rs.next()){
					bean.setA_a(rs.getString("A_A"));
				    bean.setSeq(rs.getString("SEQ"));
				    bean.setB_1(rs.getFloat("B_1"));
				    bean.setB_2(rs.getString("B_2"));
				    bean.setB_3(rs.getString("B_3"));
				    bean.setB_4(rs.getString("B_4"));
				    bean.setB_5(rs.getString("B_5"));	
				    bean.setC_1(rs.getString("C_1"));
				    bean.setC_2(rs.getFloat("C_2"));
					bean.setC_3(rs.getString("C_3"));
				    bean.setC_4(rs.getString("C_4"));
				    bean.setC_5(rs.getString("C_5"));	
				    bean.setD_1(rs.getString("D_1"));
				    bean.setD_2(rs.getString("D_2"));
				    bean.setD_3(rs.getString("D_3"));
				    bean.setD_4(rs.getString("D_4"));
				    bean.setD_5(rs.getString("D_5"));	
				    bean.setA_1(rs.getString("A_1"));	
				 
	            }
	            rs.close();
	            pstmt.close();
        }catch(SQLException se){
			System.out.println("[AssetDatabase:getAssetVarList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

  // 처분된건 제외 - st:3 5년 상각건 (자산양수차량) 
	public Vector getAssetList(String st, String  gubun , String gubun_nm) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
        String subQuery = "";
        
        
       	/*리스*/
       	if(st.equals("1")){		subQuery += " and a.car_use='1'";
		/*렌트*/
		}else if(st.equals("2")){	subQuery += " and a.car_use='2'  ";
			
		/*렌트*/
	//	}else if(st.equals("3")){	subQuery += " and a.car_use='2' and a.car_gu = '2' ";	
	    }    
					/*조회구분*/
		if(!gubun_nm.equals("")){
			if (gubun.equals("car_no")) {
				subQuery += " and c.car_no like '%"+gubun_nm+ "%'";
			} else if (gubun.equals("get_date")) {
				subQuery += " and a.get_date like '%"+gubun_nm+ "%'";
			} else if (gubun.equals("asset_code")) {
				subQuery += " and a.asset_code like '%"+gubun_nm+ "%'";	
			} else {
				subQuery += " and c.car_y_form like '%"+gubun_nm+ "%'";
			}	
		}
			
		query = " select a.asset_code, a.asset_name, a.get_date, a.get_gubun, a.guant,  a.life_exist, a.ndepre_rate, \n" +
		        "        a.depr_method, a.deprf_yn, ya.gisu, ya.get_amt, ya.book_dr, ya.book_cr, ya.jun_reser, ya.dep_amt, yg.jun_gdep, yg.gdep_mamt , yg.gdep_amt,  c.car_no,   m.assch_date ,  a.car_gu, a.dlv_dt ,  g.assch_date gov_date, g.cap_amt  gov_amt , \n" +
		        "   	  case when nvl(m.s_sup_amt, 0)  > 0 then m.s_sup_amt else  case when m.assch_rmk like '%폐%' then m.sale_amt  when m.assch_rmk like '%매각%' then nvl(m.s_sup_amt ,  round(m.sale_amt/1.1) )   when m.assch_rmk like '%매입옵션%' then nvl(m.s_sup_amt, round(m.sale_amt/1.1) )   else 0 end end sup_amt 	\n" +
		         	" from   fassetma a,  ( select * from  fassetmove where assch_type = '3' )  m,  ( select * from  fassetmove where ma_chk = 'G'   )  g ,   \n " +
				"      ( select * from  fyassetdep  where gisu =  (select  max(gisu) from fyassetdep ) ) ya,  car_reg c, " +
				"      (select * from fyassetdep_green  where gisu =  (select  max(gisu) from fyassetdep_green )) yg \n " +
		        " where  a.asset_code = ya.asset_code and a.asset_code = m.asset_code(+)  and a.car_mng_id = c.car_mng_id(+)  and a.asset_code  = g.asset_code(+)   \n " +
		        "   and   a.asset_code = yg.asset_code(+)    "+ subQuery + " and a.deprf_yn <> '6'  order by 9 asc, 3 asc ";		        
	       		  
	
	// 상각마감 후 이월전의 자료는 _bak2		   ( select car_mng_id , sum(tax_supply) tax_supply  from tax where gubun = '6' and tax_st = 'O' group by car_mng_id ) t,    nvl(t.tax_supply, round(m.sale_amt/1.1) )  
	/*		query = " select a.asset_code, a.asset_name, a.get_date, a.get_gubun, a.guant,  a.life_exist, a.ndepre_rate, " +
		        " a.depr_method, a.deprf_yn, ya.gisu, ya.get_amt, ya.book_dr, ya.book_cr, ya.jun_reser, ya.dep_amt,  c.car_no  from fassetma_bak2 a, ( select * from  fyassetdep_bak2 where gisu = (select max(gisu) from fyassetdep_bak2 )) ya , car_reg c " +
		        " where a.asset_code = ya.asset_code and a.car_mng_id = c.car_mng_id(+) "+	subQuery + " and a.deprf_yn <> '6'  order by 9 asc, 3 asc ";
	*/			  		  

		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
		


	
	  // 처분된건 제외-전기 -  자산테이블_bak2
	public Vector getAssetList_j(String st, String  gubun , String gubun_nm) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
        String subQuery = "";
        
        
       	/*리스*/
       	if(st.equals("1")){		subQuery += " and a.car_use='1'";
		/*렌트*/
		}else if(st.equals("2")){	subQuery += " and a.car_use='2'";
	    }    
					/*조회구분*/
		if(!gubun_nm.equals("")){
			if (gubun.equals("car_no")) {
				subQuery += " and c.car_no like '%"+gubun_nm+ "%'";
			} else if (gubun.equals("get_date")) {
				subQuery += " and a.get_date like '%"+gubun_nm+ "%'";
			} else if (gubun.equals("asset_code")) {
				subQuery += " and a.asset_code like '%"+gubun_nm+ "%'";	
			} else {
				subQuery += " and c.car_y_form like '%"+gubun_nm+ "%'";
			}	
		}
				
	// 상각마감 후 이월전의 자료는 _bak2		
	/*
	 	query = " select a.asset_code, a.asset_name, a.get_date, a.get_gubun, a.guant,  a.life_exist, a.ndepre_rate, " +
	   	        		"  a.depr_method, a.deprf_yn, ya.gisu, ya.get_amt, ya.book_dr, ya.book_cr, ya.jun_reser, ya.dep_amt,  ya.gdep_amt, c.car_no ,  m.assch_date ," +
	   	  	    	"   case when m.assch_rmk like '%폐차%' then m.sale_amt when m.assch_rmk like '%폐기%' then m.sale_amt  when m.assch_rmk like '%매각%' then round(m.sale_amt/1.1)  when m.assch_rmk like '%매입옵션%' then round(m.sale_amt/1.1)  else 0 end  sup_amt "+	   	        		
		        		" from fassetma_bak2 a, ( select * from  fassetmove_bak2 where assch_type = '3' )  m, ( select * from  fyassetdep_bak2 where gisu = (select max(gisu) from fyassetdep_bak2 )) ya , car_reg c " +
		        		" where a.asset_code = ya.asset_code  and a.asset_code = m.asset_code(+) and a.car_mng_id = c.car_mng_id(+) "+	subQuery + " and a.deprf_yn <> '6'  order by 9 asc, 3 asc ";
	*/	
		
		query = " select a.asset_code, a.asset_name, a.get_date, a.get_gubun, a.guant,  a.life_exist, a.ndepre_rate, \n" +
		        "        a.depr_method, a.deprf_yn, ya.gisu, ya.get_amt, ya.book_dr, ya.book_cr, ya.jun_reser, ya.dep_amt, yg.jun_gdep, yg.gdep_mamt, yg.gdep_amt,  c.car_no,   m.assch_date ,  a.car_gu, a.dlv_dt , g.assch_date gov_date, g.cap_amt  gov_amt , \n" +
		       //    	        	"       case when m.assch_rmk like '%폐%' then m.sale_amt  when m.assch_rmk like '%매각%' then nvl(m.s_sup_amt ,  round(m.sale_amt/1.1) )   when m.assch_rmk like '%매입옵션%' then nvl(m.s_sup_amt, round(m.sale_amt/1.1) )   else 0 end  sup_amt "+	   
		        "   	  case when nvl(m.s_sup_amt, 0)  > 0 then m.s_sup_amt else  case when m.assch_rmk like '%폐%' then m.sale_amt  when m.assch_rmk like '%매각%' then nvl(m.s_sup_amt ,  round(m.sale_amt/1.1) )   when m.assch_rmk like '%매입옵션%' then nvl(m.s_sup_amt, round(m.sale_amt/1.1) )   else 0 end end sup_amt 	\n" +
		         	" from   fassetma_bak2 a,  ( select * from  fassetmove_bak2 where assch_type = '3' )  m,   ( select * from  fassetmove_bak2 where ma_chk = 'G'   )  g ,  \n " +
				"      ( select * from  fyassetdep_bak2  where gisu =  (select  max(gisu) from fyassetdep_bak2 ) ) ya,  car_reg c, " +
				"      (select * from fyassetdep_green_bak2  where gisu =  (select  max(gisu) from fyassetdep_green_bak2 )) yg \n " +
		        " where  a.asset_code = ya.asset_code and a.asset_code = m.asset_code(+)  and a.car_mng_id = c.car_mng_id(+) and a.asset_code  = g.asset_code(+)   \n " +
		        "   and   a.asset_code = yg.asset_code(+)    "+ subQuery + " and a.deprf_yn <> '6'  order by 9 asc, 3 asc ";		 
	
	
		/*        
			query = " select a.asset_code, a.asset_name, a.get_date, a.get_gubun, a.guant,  6 life_exist,  0.166 ndepre_rate, \n" +
		        "        a.depr_method, a.deprf_yn, ya.gisu, ya.get_amt, ya.book_dr, ya.book_cr, ya.jun_reser, ya.dep_amt, yg.jun_gdep, yg.gdep_mamt, yg.gdep_amt,  c.car_no,   m.assch_date , \n" +
		       //    	        	"       case when m.assch_rmk like '%폐%' then m.sale_amt  when m.assch_rmk like '%매각%' then nvl(m.s_sup_amt ,  round(m.sale_amt/1.1) )   when m.assch_rmk like '%매입옵션%' then nvl(m.s_sup_amt, round(m.sale_amt/1.1) )   else 0 end  sup_amt "+	   
		        "   	  case when nvl(m.s_sup_amt, 0)  > 0 then m.s_sup_amt else  case when m.assch_rmk like '%폐%' then m.sale_amt  when m.assch_rmk like '%매각%' then nvl(m.s_sup_amt ,  round(m.sale_amt/1.1) )   when m.assch_rmk like '%매입옵션%' then nvl(m.s_sup_amt, round(m.sale_amt/1.1) )   else 0 end end sup_amt 	\n" +
		         	" from   fassetma_bak2 a,  ( select * from  fassetmove_bak2 where assch_type = '3' )  m,    \n " +
				"      ( select * from  fyassetdep_bak3  where gisu =  (select  max(gisu) from fyassetdep_bak3 ) ) ya,  car_reg c, " +
				"      (select * from fyassetdep_green_bak3  where gisu =  (select  max(gisu) from fyassetdep_green_bak3 )) yg \n " +
		        " where  a.asset_code = ya.asset_code and a.asset_code = m.asset_code(+)  and a.car_mng_id = c.car_mng_id(+) \n " +
		        "   and   a.asset_code = yg.asset_code(+)    "+ subQuery + " and a.deprf_yn <> '6'  order by 9 asc, 3 asc ";		 
		    */               
			
		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetList_j]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	
	// 처분된건 제외 - 5년상각기준(2016년부터 가능) 
	public Vector getAssetList11(String st, String  gubun , String gubun_nm) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
        String subQuery = "";
        
        
       	/*리스*/
       	if(st.equals("1")){		subQuery += " and a.car_use='1'";
		/*렌트*/
		}else if(st.equals("2")){	subQuery += " and a.car_use='2'";
	    }    
					/*조회구분*/
		if(!gubun_nm.equals("")){
			if (gubun.equals("car_no")) {
				subQuery += " and c.car_no like '%"+gubun_nm+ "%'";
			} else if (gubun.equals("get_date")) {
				subQuery += " and a.get_date like '%"+gubun_nm+ "%'";
			} else if (gubun.equals("asset_code")) {
				subQuery += " and a.asset_code like '%"+gubun_nm+ "%'";	
			} else {
				subQuery += " and c.car_y_form like '%"+gubun_nm+ "%'";
			}	
		}
			
		query = " select a.asset_code, a.asset_name, a.get_date, a.get_gubun, a.guant,  a.life_exist, a.ndepre_rate, " +
		        "        a.depr_method, a.deprf_yn, ya.gisu, ya.get_amt, ya.book_dr, ya.book_cr, ya.jun_reser, ya.dep_amt,  c.car_no,    m.assch_date ,   " +
		       //    	        	"       case when m.assch_rmk like '%폐%' then m.sale_amt  when m.assch_rmk like '%매각%' then nvl(m.s_sup_amt ,  round(m.sale_amt/1.1) )   when m.assch_rmk like '%매입옵션%' then nvl(m.s_sup_amt, round(m.sale_amt/1.1) )   else 0 end  sup_amt "+	   
		        "   	  case when nvl(m.s_sup_amt, 0)  > 0 then m.s_sup_amt else  case when m.assch_rmk like '%폐%' then m.sale_amt  when m.assch_rmk like '%매각%' then nvl(m.s_sup_amt ,  round(m.sale_amt/1.1) )   when m.assch_rmk like '%매입옵션%' then nvl(m.s_sup_amt, round(m.sale_amt/1.1) )   else 0 end end sup_amt 	 "+	
		         	" from   fassetma a,  ( select * from  fassetmove where assch_type = '3'  and assch_date like '2011%' )  m,    \n " +
		//		"      ( select * from  fyassetdep5  where gisu =  (select  max(gisu) from fyassetdep5 ) ) ya,  car_reg c " +
				"      ( select * from  fyassetdep5  where gisu = '2011' ) ya,  car_reg c " +
//		        " where  a.asset_code = ya.asset_code and a.asset_code = m.asset_code(+)  and a.car_mng_id = c.car_mng_id(+)   "+ subQuery + " and a.deprf_yn <> '6'  order by 9 asc, 3 asc ";		
		             " where  a.asset_code = ya.asset_code and a.asset_code = m.asset_code(+)  and a.car_mng_id = c.car_mng_id(+)   "+ subQuery + "   order by 9 asc, 3 asc ";		// 매각건 포함               
	        
		        		        				  
	
	// 상각마감 후 이월전의 자료는 _bak2		   ( select car_mng_id , sum(tax_supply) tax_supply  from tax where gubun = '6' and tax_st = 'O' group by car_mng_id ) t,    nvl(t.tax_supply, round(m.sale_amt/1.1) )  
	/*		query = " select a.asset_code, a.asset_name, a.get_date, a.get_gubun, a.guant,  a.life_exist, a.ndepre_rate, " +
		        " a.depr_method, a.deprf_yn, ya.gisu, ya.get_amt, ya.book_dr, ya.book_cr, ya.jun_reser, ya.dep_amt,  c.car_no  from fassetma_bak2 a, ( select * from  fyassetdep_bak2 where gisu = (select max(gisu) from fyassetdep_bak2 )) ya , car_reg c " +
		        " where a.asset_code = ya.asset_code and a.car_mng_id = c.car_mng_id(+) "+	subQuery + " and a.deprf_yn <> '6'  order by 9 asc, 3 asc ";
	*/			  		  

		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetList11]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	
		// 처분된건 제외 - 5년상각기준(2016년부터 가능) 
	public Vector getAssetList11(String st, String  gubun , String gubun_nm, String s_year ) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
        String subQuery = "";
        
        
       	/*리스*/
       	if(st.equals("1")){		subQuery += " and a.car_use='1'";
		/*렌트*/
		}else if(st.equals("2")){	subQuery += " and a.car_use='2'";
	    }    
					/*조회구분*/
		if(!gubun_nm.equals("")){
			if (gubun.equals("car_no")) {
				subQuery += " and c.car_no like '%"+gubun_nm+ "%'";
			} else if (gubun.equals("get_date")) {
				subQuery += " and a.get_date like '%"+gubun_nm+ "%'";
			} else if (gubun.equals("asset_code")) {
				subQuery += " and a.asset_code like '%"+gubun_nm+ "%'";	
			} else {
				subQuery += " and c.car_y_form like '%"+gubun_nm+ "%'";
			}	
		}
			
		query = " select a.asset_code, a.asset_name, a.get_date, a.get_gubun, a.guant,  a.life_exist, a.ndepre_rate, " +
		        "        a.depr_method,decode(m.assch_date, null, decode(a.deprf_yn, '2', '2', '4', '4', decode(ya.dep_amt, 0, '4' , '2') ) ,'5') deprf_yn, ya.gisu, ya.get_amt, ya.book_dr, ya.book_cr, ya.jun_reser, ya.dep_amt,  c.car_no,    m.assch_date ,   " +
		       //    	        	"       case when m.assch_rmk like '%폐%' then m.sale_amt  when m.assch_rmk like '%매각%' then nvl(m.s_sup_amt ,  round(m.sale_amt/1.1) )   when m.assch_rmk like '%매입옵션%' then nvl(m.s_sup_amt, round(m.sale_amt/1.1) )   else 0 end  sup_amt "+	   
		        "   	  case when nvl(m.s_sup_amt, 0)  > 0 then m.s_sup_amt else  case when m.assch_rmk like '%폐%' then m.sale_amt  when m.assch_rmk like '%매각%' then nvl(m.s_sup_amt ,  round(m.sale_amt/1.1) )   when m.assch_rmk like '%매입옵션%' then nvl(m.s_sup_amt, round(m.sale_amt/1.1) )   else 0 end end sup_amt 	 "+	
		         	" from   fassetma a,  ( select * from  fassetmove where assch_type = '3'  and assch_date like '" + s_year + "%' )  m,    \n " +
		//		"      ( select * from  fyassetdep5  where gisu =  (select  max(gisu) from fyassetdep5 ) ) ya,  car_reg c " +
				"      ( select * from  fyassetdep5  where gisu = '" + s_year + "' ) ya,  car_reg c " +
//		        " where  a.asset_code = ya.asset_code and a.asset_code = m.asset_code(+)  and a.car_mng_id = c.car_mng_id(+)   "+ subQuery + " and a.deprf_yn <> '6'  order by 9 asc, 3 asc ";		
		             " where  a.asset_code = ya.asset_code and a.asset_code = m.asset_code(+)  and a.car_mng_id = c.car_mng_id(+)   "+ subQuery + "   order by 9 asc, 3 asc ";		// 매각건 포함               
	        
		        		        				  
	
	// 상각마감 후 이월전의 자료는 _bak2		   ( select car_mng_id , sum(tax_supply) tax_supply  from tax where gubun = '6' and tax_st = 'O' group by car_mng_id ) t,    nvl(t.tax_supply, round(m.sale_amt/1.1) )  
	/*		query = " select a.asset_code, a.asset_name, a.get_date, a.get_gubun, a.guant,  a.life_exist, a.ndepre_rate, " +
		        " a.depr_method, a.deprf_yn, ya.gisu, ya.get_amt, ya.book_dr, ya.book_cr, ya.jun_reser, ya.dep_amt,  c.car_no  from fassetma_bak2 a, ( select * from  fyassetdep_bak2 where gisu = (select max(gisu) from fyassetdep_bak2 )) ya , car_reg c " +
		        " where a.asset_code = ya.asset_code and a.car_mng_id = c.car_mng_id(+) "+	subQuery + " and a.deprf_yn <> '6'  order by 9 asc, 3 asc ";
	*/			  		  

		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetList11]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
		
	
	  // 처분된건 제외
	public Vector getAssetSaleList(String dt, String  ref_dt1 , String ref_dt2) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
        String subQuery = "";
              
		String f_date1="";
		String t_date1="";
	
			
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		
		if(dt.equals("2")) {
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("3")) {
			f_date1 = s_year+ "0101";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}

		
		query = " select a.asset_code, a.asset_name, a.get_date, a.get_gubun, a.guant,  a.life_exist, m.sale_amt, m.assch_date, \n" +
		        " a.depr_method, a.deprf_yn, ya.gisu, ya.get_amt, ya.book_dr, ya.book_cr, ya.jun_reser, ya.dep_amt,  c.car_no \n " +
		        " from fassetma a,  fassetmove m, ( select * from  fyassetdep where gisu = (select max(gisu) from fyassetdep where gisu  =substr('" + f_date1 + "', 1, 4) )) ya , car_reg c \n " +
		        " where a.asset_code = ya.asset_code and a.asset_code = m.asset_code and m.assch_type = '3' and m.assch_date between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  \n" + 
		        "  and  a.car_mng_id = c.car_mng_id(+) order by 8 asc, 3 asc ";
				  
		
		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetSaleList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	  // 처분된건 제외
	public Vector getAssetSaleList(String ref_dt1, String ref_dt2, String gubun, String s_kd ) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
        String subQuery = "";
        String gubunQuery = "";
         
        if (!gubun.equals("") ) {        
			 if(gubun.equals("1")){					gubunQuery = "and   a.car_use = '" + gubun + "'";		}        
	         else{									gubunQuery = "and   a.car_use = '" + gubun + "'";       } 				
  		}     
		
		query = " select a.asset_code, a.asset_name, a.get_date, a.get_gubun, a.guant,  a.life_exist, m.sale_amt, m.assch_date, \n" +
		        " a.depr_method, a.deprf_yn, ya.gisu, ya.get_amt, ya.book_dr, ya.book_cr, ya.jun_reser, ya.dep_amt,  c.car_no \n " +
		        " from fassetma a,  fassetmove m, ( select * from  fyassetdep where gisu = (select max(gisu) from fyassetdep where gisu  =substr('" + ref_dt1 + "', 1, 4) )) ya , car_reg c \n " +
		        " where a.asset_code = ya.asset_code and a.asset_code = m.asset_code and m.assch_type = '3' and m.assch_date between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 + "','-','')  \n" + 
		        "  and  a.car_mng_id = c.car_mng_id(+) " + gubunQuery +
		        " order by 8 asc, 3 asc ";
				  
		
		try {
					
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetSaleList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	  // 매각현황 :s_au -> M:매입옵션, P:폐차 -구매보조금 포함 ( 20170111)
	public Vector getAssetSaleList(String chk1, String ref_dt1, String ref_dt2, String s_kd, String s_au, String t_wd, String sort, String asc, String gubun, String gubun_nm ) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	        String subQuery = "";
	        String gubunQuery = "";
	        String assetQuery = "";
                 String dtQuery = "";
           	    
		if(chk1.equals("2"))			dtQuery = " and m.assch_date like to_char(sysdate,'YYYYMM')||'%'";
		else if(chk1.equals("1"))		dtQuery = " and m.assch_date like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";		
		else if(chk1.equals("3")){		
			dtQuery = " and m.assch_date between replace('"+ref_dt1+"', '-','') and replace('"+ref_dt2+"', '-','')";
		}
		
		 
      		if (!s_kd.equals("") ) {        
			 if(s_kd.equals("1")){					gubunQuery = "and   a.car_use = '" + s_kd + "'";		}	        
	         else if(s_kd.equals("2")){				gubunQuery = "and   a.car_use = '" + s_kd + "'";		} 				
			 else if(s_kd.equals("3")){				gubunQuery = "and   a.car_use = '2' and c.fuel_kd in ('3','5','6') ";		} 				
			 else if(s_kd.equals("4")){				gubunQuery = "and   a.car_use = '2' and c.fuel_kd not in ('3','5','6')";		} 				
  		}     
		
		if (!s_au.equals("") ) {        
	       		 if (s_au.equals("M")){						subQuery = "and m.assch_rmk  in ( '매입옵션' ) and s.actn_id is null ";       } 		
	                   else if (s_au.equals("P")){			subQuery = "and m.assch_rmk  like '%폐%' ";       } 
	                   else if (s_au.equals("S")){			subQuery = "and m.assch_rmk  in ( '매각' ) and s.actn_id is null ";       } 		
	                   else if (s_au.equals("A")){			subQuery = "and s.actn_id is not null ";       } 		
	                   else 				     {			subQuery = "and s.actn_id = '" + s_au + "'";       } 	
  		}  
  		
  	   if (!t_wd.equals("") ) {        
			assetQuery = "and   a.asset_code = '" + t_wd + "'";		        
	          				
  		}       				
  					/*조회구분*/
		if(!gubun_nm.equals("")){
			if (gubun.equals("car_no")) {
				subQuery += " and c.car_no like '%"+gubun_nm+ "%'";
		
			}	
		}
		 		
		query = " select a.asset_code, a.asset_name, a.get_date, a.get_gubun, a.guant,  a.life_exist, m.sale_amt,  m.assch_date, case when m.assch_rmk like '%폐차%' then '폐차' when m.assch_rmk like '%폐기%' then '폐차'  else m.assch_rmk end assch_rmk , \n" +
		        "        a.depr_method, a.deprf_yn, ya.gisu, ya.get_amt, ya.book_dr, ya.book_cr, ya.jun_reser, ya.dep_amt,  c.car_no, nvl(s.actn_id,'') actn_id ,   nvl(m.s_sup_amt, round(m.sale_amt/1.1) )   sup_amt, \n " +
		          "        c.fuel_kd, s.km, decode(c.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, nvl(m.client_id2, '99') client_id2,   \n"+
			    "        TRUNC(MONTHS_BETWEEN(TO_DATE(replace(m.assch_date,'-',''), 'YYYYMMDD'), TO_DATE(replace(decode(a.car_gu , '2', a.dlv_dt, a.get_date),'-',''), 'YYYYMMDD'))) use_mon , a.car_mng_id,  yg.gdep_amt  \n"+
		 //     " from   fassetma a,  fassetmove m, ( select * from  fyassetdep where gisu = (select max(gisu) from fyassetdep where gisu  =substr('" + f_date1 + "', 1, 4) )) ya , car_reg c, apprsl s \n " +
		        " from   fassetma a,  fassetmove m,  \n"+
				"	     ( select a.* from  fyassetdep a, (select asset_code, max(gisu) gisu from fyassetdep group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) ya, \n"+
			   "       ( select a.asset_code, a.gisu, a.jun_gdep, a.gdep_amt from  fyassetdep_green a, (select asset_code, max(gisu) gisu from fyassetdep_green group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) yg,  \n"+
				"	     car_reg c, apprsl s,  \n " +
				"	     (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq \n"+
		        " where a.asset_code = ya.asset_code and a.asset_code = m.asset_code and m.assch_type = '3'  "+ dtQuery +	
		        "   and a.asset_code = yg.asset_code(+)   \n " +
		        "  and  a.car_mng_id = c.car_mng_id(+) and a.car_mng_id = s.car_mng_id(+) and c.car_mng_id = sq.car_mng_id(+) \n" + gubunQuery +  subQuery +  assetQuery;
		        
		if(sort.equals("0"))		query += " order by 8 desc, 18 ";
		else if(sort.equals("1"))	query += " order by 18 asc , 8 desc ";
		
		try {
					
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetSaleList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	
	  // 매각현황 :s_au -> M:매입옵션, P:폐차
	public Vector getAssetSaleList(String chk1, String ref_dt1, String ref_dt2, String s_kd, String s_au, String t_wd, String sort, String asc ) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
        String subQuery = "";
        String gubunQuery = "";
        String assetQuery = "";
     
        String f_date1="";
		String t_date1="";
	
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		
		if(chk1.equals("1")) {
			f_date1 = AddUtil.getDate(4);	
			t_date1 = AddUtil.getDate(4);	
		}
		
		if(chk1.equals("2")) {
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
					
		if(chk1.equals("3")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}  
		 
        if (!s_kd.equals("") ) {        
			 if(s_kd.equals("1")){					gubunQuery = "and   a.car_use = '" + s_kd + "'";		}        
	         else{									gubunQuery = "and   a.car_use = '" + s_kd + "'";       } 				
  		}     
		
		if (!s_au.equals("") ) {        
		//	 if(s_au.equals("000502")){					subQuery = "and   s.actn_id = '" + s_au + "'";		}        
	         	//	else if (s_au.equals("004242")){			subQuery = "and   s.actn_id = '" + s_au + "'";       } 	
	         	//	else if (s_au.equals("011723")){			subQuery = "and   s.actn_id = '" + s_au + "'";       } 	
		 //	else if (s_au.equals("003226")){			subQuery = "and   s.actn_id = '" + s_au + "'";       } 	
		 //	else if (s_au.equals("013222")){			subQuery = "and   s.actn_id = '" + s_au + "'";       } 	
	                    if (s_au.equals("M")) {				         subQuery = "and   m.assch_rmk  in ( '매입옵션', '매각' ) and s.actn_id is null ";       } 		
	                    else if (s_au.equals("P")) {			         subQuery = "and   (m.assch_rmk  like '%폐차% ) or ( m.assch_rmk  like '%폐기% ) ";       } 
	                    else {								subQuery = "and   s.actn_id = '" + s_au + "'";       } 	
  		}  
  		
  	   if (!t_wd.equals("") ) {        
			assetQuery = "and   a.asset_code = '" + t_wd + "'";		        
	          				
  		}     
  	 		
  	  		  		
		query = " select a.asset_code, a.asset_name, a.get_date, a.get_gubun, a.guant,  a.life_exist, m.sale_amt,  m.assch_date, case when m.assch_rmk like '%폐차%' then '폐차' when m.assch_rmk like '%폐기%' then '폐차'  else m.assch_rmk end assch_rmk , \n" +
		        "        a.depr_method, a.deprf_yn, ya.gisu, ya.get_amt, ya.book_dr, ya.book_cr, ya.jun_reser, ya.dep_amt,  c.car_no, nvl(s.actn_id,'') actn_id , round(m.sale_amt/1.1) sup_amt, \n " +
			    "        c.fuel_kd, s.km, decode(c.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, nvl(m.client_id2, '99') client_id2,  \n"+
			    "        TRUNC(MONTHS_BETWEEN(TO_DATE(replace(m.assch_date,'-',''), 'YYYYMMDD'), TO_DATE(replace(a.get_date,'-',''), 'YYYYMMDD'))) use_mon , a.car_mng_id,  yg.gdep_amt \n"+
		 //     " from   fassetma a,  fassetmove m, ( select * from  fyassetdep where gisu = (select max(gisu) from fyassetdep where gisu  =substr('" + f_date1 + "', 1, 4) )) ya , car_reg c, apprsl s \n " +
		        " from   fassetma a,  fassetmove m,  \n"+
				"	     ( select a.* from  fyassetdep a, (select asset_code, max(gisu) gisu from fyassetdep group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) ya, \n"+
				  "       ( select a.asset_code, a.gisu, a.jun_gdep, a.gdep_amt from  fyassetdep_green a, (select asset_code, max(gisu) gisu from fyassetdep_green group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) yg,  \n"+
				"	     car_reg c, apprsl s,  \n " +
				"	     (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq \n"+
		        " where a.asset_code = ya.asset_code and a.asset_code = m.asset_code and m.assch_type = '3' \n"+
		        "   and a.asset_code = yg.asset_code(+)   \n " +
				"  and  m.assch_date between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  \n" + 
		        "  and  a.car_mng_id = c.car_mng_id(+) and a.car_mng_id = s.car_mng_id(+) and c.car_mng_id = sq.car_mng_id(+) \n" + gubunQuery +  subQuery +  assetQuery;
		        
		if(sort.equals("0"))		query += " order by 8 desc, 18 ";
		else if(sort.equals("1"))	query += " order by 18 asc , 8 desc ";
		
		try {
					
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetSaleList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
			
		  // 매각현황 :s_au -> M:매입옵션, P:폐차
	public Hashtable getAssetSaleList(String car_mng_id ) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
     
  		  		
		query = " select  a.car_use, m.sale_amt, m.assch_date, ya.get_amt, ya.book_dr, ya.jun_reser, ya.dep_amt,  yg.gdep_amt ,  nvl(m.s_sup_amt,  round(m.sale_amt/1.1)) sup_amt ,  m.client_id2   \n " +
		        "	from fassetma a,  fassetmove m,   \n " +
		        " ( select * from fyassetdep  where gisu =  (select  max(gisu) from fyassetdep ) ) ya , \n " +		    
		        " ( select * from fyassetdep_green  where gisu =  (select  max(gisu) from fyassetdep_green  ) ) yg \n " +	
		        " where a.asset_code = ya.asset_code and a.asset_code = m.asset_code and m.assch_type = '3'  \n" + 
		        "    and  a.asset_code = yg.asset_code(+)     \n " +	     
		        "  and   a.car_mng_id = '" + car_mng_id + "'";
		  
				try {
					
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetSaleList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}
	
	
	//고정자산 미등록 리스트 조회 - 일정시점 후 )
	public Vector getAssetNoMaRegList()throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
			
			
		query=" select a.rent_mng_id, a.rent_l_cd, a.dlv_dt , b.car_mng_id, b.car_no, b.init_reg_dt, b.car_use, a.car_gu " +
			  "		from cont a, car_reg b   " +
			  "			 where nvl(a.use_yn, 'Y') = 'Y' and a.dlv_dt like '200801%'   " +
			  "			 and a.car_mng_id = b.car_mng_id and a.car_gu in ('1', '2')	  " +
			  " 			 and a.car_st<>'2' and a.rent_l_cd not like 'RM%'	 order by dlv_dt	 ";		
		
		try {
				pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetNoRegList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}


	//자산 master 등록
	public boolean insertAassetMa(AssetMaBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		Statement stmt = null;
			
		String seq = "";
		String gubun = "";
		String query_seq = "";
		 
        int count = 0;
        
        String query = "";
     
        boolean flag = true;
         
        if (bean.getCar_use().equals("1")) {
        	gubun = "C";
        } else {
        	gubun = "A";
        }		
     				
        query_seq = "select '" + gubun + "' || nvl(ltrim(to_char(to_number(max(substr(asset_code,2,6))+1), '000000')), '000001') from fassetma where substr(asset_code, 1,1) = '" + gubun + "' ";	
         	
        query = "insert into fassetma (asset_code, asset_name, gettm_gu, ven_name, get_date, get_gubun, "+
						" guant, get_amt, life_exist, ndepre_rate, sdepre_type, sdepre_rate, " +
						" depr_method, depre_fyy, rdepr_syy, rdepr_term, deprf_yn, " +
						" jun_reser, jun_qdep, gasset_code, insert_id, insert_date, car_use, car_mng_id , acct_code "+
						" ) values("+
						" ?, ?, ?, ?,  replace(?, '-', ''), ?, "+
						" ?, ?, ?, ?, ?, ?, "+
						" ?, ?, ?, ?, ?, "+
						" ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ? , ? )";
           
       try{
            con.setAutoCommit(false);
            
            stmt = con.createStatement();
            rs = stmt.executeQuery(query_seq);
         //   System.out.println(query_seq);
            if(rs.next())
            	seq = rs.getString(1).trim();
            rs.close();
			stmt.close();
						
            pstmt = con.prepareStatement(query);
            
           	pstmt.setString(1, seq);
			pstmt.setString(2, bean.getAsset_name());
		    pstmt.setString(3, bean.getGettm_gu());
			pstmt.setString(4, bean.getVen_name());
			pstmt.setString(5, bean.getGet_date());
			pstmt.setString(6, bean.getGet_gubun());
			
			pstmt.setInt(7, bean.getGuant());
			pstmt.setInt(8, bean.getGet_amt());
			pstmt.setFloat(9, bean.getLife_exist());
			pstmt.setFloat(10, bean.getNdepre_rate());
			pstmt.setString(11, bean.getSdepre_type());
			pstmt.setFloat(12, bean.getSdepre_rate());
			
			pstmt.setString(13, bean.getDepr_method());
			pstmt.setString(14, bean.getDepre_fyy());
			pstmt.setString(15, bean.getRdepr_syy());
			pstmt.setInt(16, bean.getRdepr_term());
			pstmt.setString(17, bean.getDeprf_yn());
			
			pstmt.setInt(18, bean.getJun_reser());
			pstmt.setInt(19, bean.getJun_qdep());
			pstmt.setString(20, bean.getGasset_code());
			pstmt.setString(21, bean.getInsert_id());
			pstmt.setString(22, bean.getCar_use());
			pstmt.setString(23, bean.getCar_mng_id());
			pstmt.setString(24, bean.getAcct_code());
			
		//	System.out.println(seq + " || " +  bean.getAsset_name() );		
					
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
            	flag = false;
                con.rollback();
                System.out.println(se);
            }catch(SQLException _ignored){}
            
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return flag;
    }
    
    
	//자산 삭제 
	public boolean deleteAssetMa(String asset_code, String car_mng_id) throws DatabaseException, DataSourceEmptyException{
	
	   Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
     
    		
		boolean flag = true;
		
		PreparedStatement pstmt = null;//자산 master
		PreparedStatement pstmt2 = null; //자산 변동
		PreparedStatement pstmt3 = null; //상각월 내역
		PreparedStatement pstmt4 = null; // 상각 년데이타
		PreparedStatement pstmt5 = null; // car_reg 변경
		
		String query = "";
			
		query = " DELETE FROM fassetma "+
				" WHERE asset_code  = ? ";

		String query2 = "";
			
		query2 = " DELETE FROM fassetmove "+
				" WHERE asset_code  = ? ";

		String query3 = "";
			
		query3 = " DELETE FROM fassetdep "+
				" WHERE asset_code  = ? ";
				
		String query4 = "";
			
		query4 = " DELETE FROM fyassetdep "+
				" WHERE asset_code  = ? ";
		
		String query5 = "";
			
		query5 = " UPDATE CAR_REG set asset_yn = 'N', f1_chk = 'N',  f2_chk = 'N', f3_chk = 'N' , f8_chk = 'N' "+
				" WHERE car_mng_id = ? ";
			        
		try 
		{
			con.setAutoCommit(false);
			
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	asset_code);
			
			pstmt.executeUpdate();

			pstmt2 = con.prepareStatement(query2);
			pstmt2.setString	(1,	asset_code);
			pstmt2.executeUpdate();

			pstmt3 = con.prepareStatement(query3);
			pstmt3.setString	(1,	asset_code);
			pstmt3.executeUpdate();
			
			pstmt4 = con.prepareStatement(query4);
			pstmt4.setString	(1,	asset_code);
			pstmt4.executeUpdate();
			
			pstmt5 = con.prepareStatement(query5);
			pstmt5.setString	(1,	car_mng_id);
			pstmt5.executeUpdate();
			
		    pstmt.close();
		    pstmt2.close();
		    pstmt3.close();
		    pstmt4.close();
		    pstmt5.close();
		            
			con.commit();
			
	     }catch(SQLException se){
            try{
            	flag = false;
                con.rollback();
                System.out.println(se);
            }catch(SQLException _ignored){}
            
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
            
                if(pstmt != null) pstmt.close();
                if(pstmt2 != null) pstmt.close();
                if(pstmt3 != null) pstmt.close();
                if(pstmt4 != null) pstmt.close();
                if(pstmt5 != null) pstmt.close();
                        
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return flag;
    }
	
    
    	//고정자산 변경 미등록 리스트 조회 - 등록/매입공채, 취득세, 특소세, 매각/폐기 )
	public Vector getAssetNoMoveRegList()throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
			
		// 등록/매입공채
			
		query=" select car_mng_id, car_no, car_use, reg_pay_dt as assch_date, '1' as assch_type,  '등록세' as assch_rmk , reg_amt as cap_amt , 0 as  sale_quant, 0 as sale_amt from car_reg where reg_pay_dt like '200801%' and reg_amt > 0  and nvl(f1_chk, 'N' ) = 'N'  " +
			  "	union all " +
			  " select car_mng_id, car_no, car_use, reg_pay_dt as assch_date, '1' as assch_type,  '매입공채' as assch_rmk , loan_s_amt as cap_amt , 0 as  sale_quant, 0 as sale_amt from car_reg where reg_pay_dt like '200801%' and loan_s_amt > 0 and nvl(f7_chk, 'N' ) = 'N'   " +
			  "	union all " +
			  "	select car_mng_id, car_no, car_use,  acq_ex_dt as assch_date , '1'  as assch_type ,  '취득세'  as assch_rmk  , acq_amt as cap_amt , 0 as  sale_quant, 0 as sale_amt from car_reg  where acq_ex_dt like '200801%' and  acq_amt > 0  and nvl(f2_chk, 'N' ) = 'N'  " +
			  "	union all " +
			  "	select a.car_mng_id, b.car_no, b.car_use, a.pay_dt as assch_date , '1'  as assch_type ,  '개별소비세'  as assch_rmk, a.pay_amt as cap_amt, 0 as  sale_quant, 0 as sale_amt from car_tax a , car_reg b where a.car_mng_id = b.car_mng_id and a.pay_dt like '200801%' " +
			  " order by 1, 3";
		
		try {
				pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetNoRegList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	//자산 move 등록
	public int insertAssetMove(AssetMoveBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
        PreparedStatement pstmt = null;
        ResultSet rs = null;
		Statement stmt = null;
			
		int seq = 0;
		String gubun = "";
		String query_seq = "";
		 
        int count = 0;
        
        String query = "";
     
        boolean flag = true;
     				
        query_seq = "select nvl(max(assch_seri)+1, 1)  from fassetmove where asset_code = '" + bean.getAsset_code() + "' ";	
         	
        query = "insert into fassetmove (asset_code, assch_seri,  "+
						" assch_date, assch_type, assch_rmk, cap_amt, sale_quant, sale_amt, sh_car_amt , s_sup_amt,  client_id2 " +
						" ) values("+
						" ?, ?, " +  
						" replace(?, '-', ''), ?,  ?, ?, ?, ?, ? , ?, ?)";
           
       try{
            con.setAutoCommit(false);
            
            stmt = con.createStatement();
            rs = stmt.executeQuery(query_seq);
         //   System.out.println(query_seq);
            if(rs.next())
            	seq = rs.getInt(1);
            rs.close();
			stmt.close();
						
            pstmt = con.prepareStatement(query);
            
           	pstmt.setString(1, bean.getAsset_code());
           	pstmt.setInt(2, seq);
				    
			pstmt.setString(3, bean.getAssch_date());
			pstmt.setString(4, bean.getAssch_type());
			pstmt.setString(5, bean.getAssch_rmk());
			pstmt.setInt(6, bean.getCap_amt());
			pstmt.setInt(7, bean.getSale_quant());
			pstmt.setInt(8, bean.getSale_amt());
			pstmt.setInt(9, bean.getSh_car_amt());
			pstmt.setInt(10, bean.getS_sup_amt());
			pstmt.setString(11, bean.getClient_id2());
			
		//	System.out.println(seq + " || " +  bean.getAsset_name() );		
					
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
            	count = 0;
                con.rollback();
                System.out.println(se);
            }catch(SQLException _ignored){}
            
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return seq;
    }
	
	//차량관리번호로 자산코드 가져가기
	public String getAsset_info(String car_mng_id, String car_no, String asset_code,  String gubun)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt_ch = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		ResultSet rs_ch = null;
		String asset_info = "";
		int count = 0;
		String query = "";
			
		if (gubun.equals("code")) {
			query	= " SELECT asset_code from fassetma where car_mng_id = '"+car_mng_id+"'";
		} else {
			query	= " SELECT asset_name from fassetma where asset_code = '"+asset_code+"'";
		}

		try {
			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();    
	    		
			if(rs.next()){				
				asset_info = rs.getString(1);
			}
	
			rs.close();
            pstmt.close();
            
		} catch (SQLException e) {
			System.out.println("[AssetDatabase:getAsset_code]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return asset_info;
	}
	
	//고정자산 등록master 리스트 조회 - 일정시점 후 )
	public Vector getAassetMaList()throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
			
			
		query=" select a.rent_mng_id, a.rent_l_cd, a.dlv_dt , b.car_mng_id, b.car_no, b.init_reg_dt, b.car_use, a.car_gu " +
			  "		from cont a, car_reg b   " +
			  "			 where nvl(a.use_yn, 'Y') = 'Y' and a.dlv_dt like '200801%'   " +
			  "			 and a.car_mng_id = b.car_mng_id and a.car_gu in ('1', '2')	  " +
			  " 			 and a.car_st<>'2' and a.rent_l_cd not like 'RM%' order by dlv_dt	 ";		
		
		try {
				pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetMaList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	//해당년도 자산 master 등록
	public boolean insertYassetDep(YassetDepBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
        PreparedStatement pstmt = null;
    			
		int seq = 0;
		String gubun = "";
			 
        int count = 0;
        
        String query = "";
     
        boolean flag = true;
                  	
        query = "insert into fyassetdep (asset_code, gisu, dep_type, get_amt, book_dr, book_cr, jun_reser, jun_qdep, "+
						" dep_amt, sdep_amt, dep_edit, sdep_edit, qdep_amt, reser_dr, reser_cr, insert_id, insert_date  " +
						" ) values("+
						" ?, ?, ?, ?, ?, ?, ?, ?, " +  
						" ?, ?, ?, ?, ?, ?,?, ?, to_char(sysdate,'YYYYMMDD'))";
           
       try{
            con.setAutoCommit(false);
            
        						
            pstmt = con.prepareStatement(query);
            
           	pstmt.setString(1, bean.getAsset_code());
           	pstmt.setString(2, bean.getGisu());
			pstmt.setString(3, bean.getDep_type());
		    pstmt.setInt(4, bean.getGet_amt());
		    pstmt.setInt(5, bean.getBook_dr());
		    pstmt.setInt(6, bean.getBook_cr());
		    pstmt.setInt(7, bean.getJun_reser());
		    pstmt.setInt(8, bean.getJun_qdep());
		    
		    pstmt.setInt(9, bean.getDep_amt());
		    pstmt.setInt(10, bean.getSdep_amt());
		    pstmt.setInt(11, bean.getDep_edit());
		    pstmt.setInt(12, bean.getSdep_edit());
		    pstmt.setInt(13, bean.getQdep_amt());
		    pstmt.setInt(14, bean.getReser_dr());	   
		    pstmt.setInt(15, bean.getReser_cr());
			pstmt.setString(16, bean.getInsert_id());
	
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
            	flag = false;
                con.rollback();
                System.out.println(se);
            }catch(SQLException _ignored){}
            
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
            
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return flag;
    }
    
    /*
	 *	자산 취득 master 호출
	*/
	public String call_sp_insert_assetmaster(String s_year, String s_month, String user_id)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	String query = "{CALL P_INSERT_assetmaster (?,?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
						
			cstmt = con.prepareCall(query);
					
			cstmt.setString(1, s_year);
			cstmt.setString(2, s_month);
			cstmt.setString(3, user_id);
			cstmt.registerOutParameter( 4, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(4); // 결과값
			
			cstmt.close();
		
		} catch (SQLException e) {
			System.out.println("[AssetDatabase:call_sp_insert_assetmaster]"+e);
			e.printStackTrace();
		} finally {
			try{
            if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return sResult;
	}
			
	/*
	 *	자산 변동 move 호출
	*/
	public String call_sp_insert_assetmove(String s_year, String s_month, String user_id)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	String query = "{CALL P_INSERT_assetmove (?,?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
						
			cstmt = con.prepareCall(query);
					
			cstmt.setString(1, s_year);
			cstmt.setString(2, s_month);
			cstmt.setString(3, user_id);
			cstmt.registerOutParameter( 4, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(4); // 결과값
			cstmt.close();
	
		} catch (SQLException e) {
			System.out.println("[AssetDatabase:call_sp_insert_assetmove]"+e);
			sResult = e.getMessage();
			e.printStackTrace();
		} finally {
			try{
            if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		
		return sResult;
	}	
	
	/*
	 *	자산 변동 move 호출 (특소세)
	*/
	public String call_sp_insert_assetmove_s(String s_year, String s_month, String user_id)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	String query = "{CALL P_INSERT_assetmove_s (?,?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
						
			cstmt = con.prepareCall(query);
					
			cstmt.setString(1, s_year);
			cstmt.setString(2, s_month);
			cstmt.setString(3, user_id);
			cstmt.registerOutParameter( 4, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(4); // 결과값
			cstmt.close();
	
		} catch (SQLException e) {
			System.out.println("[AssetDatabase:call_sp_insert_assetmove_s]"+e);
			sResult = e.getMessage();
			e.printStackTrace();
		} finally {
			try{
            if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		
		return sResult;
	}	
	
	
	/*
	 *	자산 매각 move2 호출
	*/
	public String call_sp_insert_assetmove2(String s_year, String s_month, String user_id)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	String query = "{CALL P_INSERT_assetmove2 (?,?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
						
			cstmt = con.prepareCall(query);
					
			cstmt.setString(1, s_year);
			cstmt.setString(2, s_month);
			cstmt.setString(3, user_id);
			cstmt.registerOutParameter( 4, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(4); // 결과값
			
			cstmt.close();
		
		} catch (SQLException e) {
			System.out.println("[AssetDatabase:call_sp_insert_assetmove2]"+e);
			e.printStackTrace();
		} finally {
			try{
            if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return sResult;
	}	
	
		/*
	 *	자산 매각 move2 호출
	*/
	public String call_sp_insert_assetmove2_off(String s_year, String s_month, String car_mng_id, String user_id)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	String query = "{CALL P_INSERT_assetmove2_off (?,?,?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
						
			cstmt = con.prepareCall(query);
					
			cstmt.setString(1, s_year);
			cstmt.setString(2, s_month);
			cstmt.setString(3, car_mng_id);
			cstmt.setString(4, user_id);
			cstmt.registerOutParameter( 5, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(5); // 결과값
			
			cstmt.close();
		
		} catch (SQLException e) {
			System.out.println("[AssetDatabase:call_sp_insert_assetmove2_off]"+e);
			e.printStackTrace();
		} finally {
			try{
            if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return sResult;
	}	
	
	
	/*
	 *	자산 변동 move 호출
	*/
	public String call_sp_insert_assetmove4(String s_year, String user_id)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	String query = "{CALL P_INSERT_assetmove4 (?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
						
			cstmt = con.prepareCall(query);
					
			cstmt.setString(1, s_year);
			cstmt.setString(2, user_id);
			cstmt.registerOutParameter( 3, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값
			cstmt.close();
	
		} catch (SQLException e) {
			System.out.println("[AssetDatabase:call_sp_insert_assetmove4]"+e);
			sResult = e.getMessage();
			e.printStackTrace();
		} finally {
			try{
            if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		
		return sResult;
	}	
	
	
	/*
	 *	자산 년이월 호출
	*/
	public String call_sp_insert_yassetdep(String s_year, String user_id)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	String query = "{CALL P_INSERT_yassetdep (?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
						
			cstmt = con.prepareCall(query);
					
			cstmt.setString(1, s_year);
			cstmt.setString(2, user_id);
			cstmt.registerOutParameter( 3, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값
			
			cstmt.close();
		
		} catch (SQLException e) {
			System.out.println("[AssetDatabase:call_sp_insert_yassetdep]"+e);
			e.printStackTrace();
		} finally {
			try{
            if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return sResult;
	}	
	
	
	 public AssetMaBean getAssetMa(String asset_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        AssetMaBean bean = new AssetMaBean();
        String query = "";
        
        query = " select a.*, c.car_no, c.first_car_no , ya.gisu , e.pay_st from fassetma a, car_reg c, cont b, car_etc e, " +
        		" ( select * from  fyassetdep where gisu = (select max(gisu) from fyassetdep where asset_code ='"+ asset_code+"' )) ya " + 
                " where a.asset_code = ya.asset_code and a.asset_code='"+asset_code+"' and a.car_mng_id = c.car_mng_id(+) " +
                "   and a.car_mng_id = b.car_mng_id(+) and b.rent_mng_id = e.rent_mng_id and b.rent_l_cd = e.rent_l_cd ";

        try{
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
            if(rs.next()){
            	
				bean.setAsset_code(rs.getString("ASSET_CODE"));
			    bean.setAsset_name(rs.getString("ASSET_NAME"));
			    bean.setGet_date(rs.getString("GET_DATE"));
			    bean.setGet_gubun(rs.getString("GET_GUBUN"));
			    bean.setGuant(rs.getInt("GUANT"));
			    bean.setGet_amt(rs.getInt("GET_AMT"));
			    bean.setLife_exist(rs.getFloat("LIFE_EXIST"));
			    bean.setNdepre_rate(rs.getFloat("NDEPRE_RATE"));
			    bean.setDepr_method(rs.getString("DEPR_METHOD"));
			    bean.setDeprf_yn(rs.getString("DEPRF_YN"));
			    bean.setJun_reser(rs.getInt("JUN_RESER"));
			    bean.setJun_qdep(rs.getInt("JUN_QDEP"));
			    bean.setGasset_code(rs.getString("GASSET_CODE"));
			    bean.setCar_use(rs.getString("CAR_USE"));
			    bean.setCar_mng_id(rs.getString("CAR_MNG_ID"));
			    bean.setAcct_code(rs.getString("ACCT_CODE"));
			    bean.setVen_name(rs.getString("VEN_NAME"));
			    bean.setCar_no(rs.getString("CAR_NO"));
			    bean.setFirst_car_no(rs.getString("FIRST_CAR_NO"));
			    bean.setGisu(rs.getString("GISU"));
			    bean.setPay_st(rs.getString("PAY_ST"));
			    bean.setDlv_dt(rs.getString("DLV_DT"));
			    
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[AssetDatabase:getAssetMa]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }
	
		//고정자산 변경 리스트 조회 - 일정시점 후 )
	public Vector getAssetMoveList(String asset_code)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		//차량구매관련 추가	
     /*   query=" select b.asset_code, 1 as assch_seri, b.asset_name, b.get_date as assch_date, '1' as assch_type, '차량대금' assch_rmk, decode(cc.car_gu, '1', nvl(ce.car_fs_amt,0) + nvl(ce.sd_cs_amt,0) - nvl(ce.dc_cs_amt,0), nvl(fe.sh_amt,0)/1.1 )  as cap_amt, 0 as sale_quant, 0 as sale_amt, b.DEPRF_YN	" +
              "   from  car_reg  a, fassetma b , car_etc ce , cont cc , (select * from  fee_etc where rent_st = '1' ) fe  " +
	  	      "  where nvl(cc.use_yn, 'Y') = 'Y'  and cc.car_mng_id = a.car_mng_id  and cc.rent_mng_id = ce.rent_mng_id and cc.rent_l_cd = ce.rent_l_cd  and cc.rent_mng_id = fe.rent_mng_id(+) and cc.rent_l_cd = fe.rent_l_cd(+) " +
	          "    and   a.car_mng_id = b.car_mng_id and  b.asset_code ='" + asset_code + "' and nvl(b.ma_chk,'N') = 'N'  " +
			  "  union all	" +	
  		      " select a.asset_code, a.assch_seri, b.asset_name, a.assch_date, a.assch_type, a.assch_rmk, a.cap_amt, a.sale_quant, a.sale_amt, b.DEPRF_YN, a.	from fassetmove a, fassetma b  " +
			  "		 where a.asset_code = b.asset_code	and  a.asset_code ='" + asset_code + "'" +
			  " 	   order by  4 , 2 ";		
		*/	  
				     query=" select a.asset_code, a.assch_seri, b.asset_name, a.assch_date, a.assch_type, a.assch_rmk, a.cap_amt, a.sale_quant, a.sale_amt, b.DEPRF_YN, nvl(a.ma_chk, 'D') ma_chk  	from fassetmove a, fassetma b  " +
			  "		 where a.asset_code = b.asset_code	and  a.asset_code ='" + asset_code + "'" +
			  " 	   order by  4 , 2 ";		  
		
		try {
				pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetMoveList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
			//고정자산 상각 리스트 조회 - 일정시점 후 )
	public Vector getAssetDepList(String asset_code)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
			
			
		query="  select a.*, b.DEPRF_YN , g.gdep_amt, g.gdep_mamt  from fyassetdep a, fassetma b , fyassetdep_green g  \n " + 
			  	   " where a.asset_code = b.asset_code	and  a.asset_code ='" + asset_code + "'" +
                "  and a.asset_code=g.asset_code(+) \n " + 
                "  and a.gisu = g.gisu(+)  \n " + 
			  	   "  order by 2 	";

		
		try {
				pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetDepList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	
			//고정자산 기수/월별 상각금액 )
	public Vector getAssetDepStat(String gubun1)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select ym, sum(amt1) amt1 , sum(amt2) amt2, sum(g_amt1) g_amt1, sum(g_amt2) g_amt2 "+
						"		from (   "+
						"		select  "+
						"						 a.gisu ||a.asset_mm ym,  "+
						"						 sum(decode(b.car_use,'1', a.dep_mamt)) amt1,  "+
						"					     sum(decode(b.car_use,'2', a.dep_mamt)) amt2 ,  "+
						"					     0 g_amt1, "+
						"					     0 g_amt2   "+
						"			from  fassetma b,  fassetdep a     "+
						"			 where b.asset_code = a.asset_code "+
						"				 and a.gisu like  '%"+gubun1+"%'  "+
						"				 group by a.gisu, a.asset_mm  "+
						"		union all   "+
						"		 select  "+
						"						 a.gisu ||a.asset_mm ym,  "+
						"						  0 amt1,  "+
						"					     0 amt2 , "+
						"					     sum(decode(b.car_use,'1', a.gdep_mamt) ) g_amt1,  "+
						"					     sum(decode(b.car_use,'2', a.gdep_mamt) )  g_amt2   "+
						"			from  fassetma b,  fassetdep_green a  "+
						"			 where b.asset_code = a.asset_code   "+
						"				 and a.gisu like   '%"+gubun1+"%'  "+
						"				 group by a.gisu, a.asset_mm  "+
						"		)  "+
						"		group by ym  "+
						"		order by 1  ";
/*
	    query = " select"+
				" a.gisu ||a.asset_mm ym,"+
				"  sum(decode(b.car_use,'1',a.dep_mamt)) amt1,"+
			    " sum(decode(b.car_use,'2',a.dep_mamt)) amt2 ,"+
			    " sum(decode(b.car_use,'1',a.gdep_mamt)  ) g_amt1, "+
			    " sum(decode(b.car_use,'2',a.gdep_mamt) )  g_amt2 "+
				" from fassetdep a, fassetma b, fassetdep_green c "+
				" where a.asset_code = b.asset_code  and b.asset_code = c.asset_code(+) " ;
*/		
//		if(!gubun1.equals(""))		query += " and a.gisu like '%"+gubun1+"%'  and c.gisu  like '%"+gubun1+"%'  " ;

//		query += " group by a.gisu, a.asset_mm order by a.gisu, a.asset_mm";

		try {
				pstmt = con.prepareStatement(query);
			
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
			System.out.println("[AssetDatabase:getAssetDepStat]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	
	//자산 월상각 리스트
	public Vector getAssetDepYmList(String asset_ym, String gubun1) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		/*			
		query = " select"+
				" b.asset_code, b.asset_name, c.car_no, b.get_date, b.life_exist, b.ndepre_rate, nvl(a.dep_mamt, 0) dep_mamt, d.dep_edit, nvl(ac.ac_dep_mamt, 0) ac_dep_mamt  , nvl(a.gdep_mamt, 0) gdep_mamt   "+
			    " from fassetma b, car_reg c , fyassetdep d , " +
			    " (select asset_code, gisu, nvl(dep_mamt, 0) dep_mamt,  nvl(gdep_mamt, 0) gdep_mamt   from fassetdep  where  gisu ||asset_mm ='"+asset_ym+"' ) a, " +
			    " (select asset_code, nvl(sum(dep_mamt),0) ac_dep_mamt from fassetdep where  gisu =substr('" + asset_ym+"',1,4) and  gisu ||asset_mm <'" +asset_ym+"' group by asset_code) ac " +
				" where d.dep_edit > 0 and b.car_mng_id=c.car_mng_id(+)"+
				" and b.asset_code= a.asset_code (+) "+
				" and b.asset_code= d.asset_code "+
				" and b.asset_code= ac.asset_code(+) "+
				" and d.gisu = substr('" + asset_ym+"',1,4)";
		*/		
				
		query = "select  \n" +
					"			 b.asset_code, b.asset_name, c.car_no, b.get_date, b.life_exist, b.ndepre_rate, nvl(a.dep_mamt, 0) dep_mamt, d.dep_edit, nvl(ac.ac_dep_mamt, 0) ac_dep_mamt  , nvl(a.gdep_mamt, 0) gdep_mamt   \n" +
					"				  from fassetma b, car_reg c , fyassetdep d ,  \n" +
					"			  ( select a.asset_code, a.gisu, nvl(a.dep_mamt, 0) dep_mamt , nvl(b.gdep_mamt, 0) gdep_mamt   \n" +
					"		          from fassetdep a, ( select  * from  fassetdep_green  where gisu ||asset_mm ='" +asset_ym+"' )  b    \n" +
					"		          where  a.gisu ||a.asset_mm ='" +asset_ym+"'   \n" +
					"		                  and a.asset_code = b.asset_code(+)  ) a,       \n" +
					"				(select a.asset_code, nvl(sum(a.dep_mamt),0) ac_dep_mamt , nvl(sum(b.gdep_mamt),0) ac_gdep_mamt   \n" +
					"		   from fassetdep a, ( select  * from  fassetdep_green  where gisu = substr('" + asset_ym+"',1,4) and  gisu ||asset_mm <'" +asset_ym+"'  )  b    \n" +
					"		   where  a.gisu = substr('" + asset_ym+"',1,4) and  a.gisu || a.asset_mm  <'" +asset_ym+"'    \n" +
					"		          and a.asset_code = b.asset_code(+)   \n" +
					"		   group by a.asset_code) ac  \n" +
					"			 where d.dep_edit > 0 and b.car_mng_id=c.car_mng_id(+)  \n" +
			//		"			 where d.dep_edit > 0 and b.car_mng_id=c.car_mng_id(+)  and b.deprf_yn <> '6'  \n" +
					"				and b.asset_code= a.asset_code (+)  and b.asset_code= d.asset_code  \n" +
					"		     	 and b.asset_code= ac.asset_code(+)   \n" +
			    	"             and d.gisu = substr('" + asset_ym+"',1,4)";
				

		if(!gubun1.equals("")) query += " and b.car_use ='"+gubun1+"'";

		query += " order by b.asset_code, b.get_date ";
		
	//	System.out.println("query="+query);

		try {
			pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetDepYmList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	public int updateAssetMa(AssetMaBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE FASSETMA SET "+
				" asset_name=?, life_exist=?, ndepre_rate=? "+
				" WHERE asset_code=? \n";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);  
            
            pstmt.setString(1, bean.getAsset_name());
            pstmt.setFloat(2, bean.getLife_exist());
            pstmt.setFloat(3, bean.getNdepre_rate());
            pstmt.setString(4, bean.getAsset_code().trim());
            
      
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AssetDatabase:updateAssetMa]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
	
	/*
	 *	자산 수정 후 상각재계산
	*/
	public String call_sp_insert_assetdep(String s_year, String asset_code, String user_id)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	String query = "{CALL P_INSERT_assetdep (?,?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
						
			cstmt = con.prepareCall(query);
					
			cstmt.setString(1, s_year);
			cstmt.setString(2, asset_code);
			cstmt.setString(3, user_id);
			cstmt.registerOutParameter( 4, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(4); // 결과값
			
			cstmt.close();
		
		} catch (SQLException e) {
			System.out.println("[AssetDatabase:call_sp_insert_assetdep]"+e);
			e.printStackTrace();
		} finally {
			try{
            if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return sResult;
	}	
	
		/*
	 *	자산변동이 발생된 후 상각 재계산
	*/
	public String call_sp_insert_assetmove3(String s_year, String asset_code, String user_id)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	String query = "{CALL P_INSERT_assetmove3 (?,?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
						
			cstmt = con.prepareCall(query);
					
			cstmt.setString(1, s_year);
			cstmt.setString(2, asset_code);
			cstmt.setString(3, user_id);
			cstmt.registerOutParameter( 4, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(4); // 결과값
			
			cstmt.close();
		
		} catch (SQLException e) {
			System.out.println("[AssetDatabase:call_sp_insert_assetmove3]"+e);
			e.printStackTrace();
		} finally {
			try{
            if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return sResult;
	}	
	
	
	/*
	 *	자산상각 복원- 당해년도 매각 이외의 변동이 없을 때 가능.
	*/
	public String call_sp_insert_assetmove_ret(String s_year, String asset_code, String user_id)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	String query = "{CALL P_INSERT_YASSETDEP_RET (?,?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
						
			cstmt = con.prepareCall(query);
					
			cstmt.setString(1, s_year);
			cstmt.setString(2, asset_code);
			cstmt.setString(3, user_id);
			cstmt.registerOutParameter( 4, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(4); // 결과값
			
			cstmt.close();
		
		} catch (SQLException e) {
			System.out.println("[AssetDatabase:call_sp_insert_assetmove_ret]"+e);
			e.printStackTrace();
		} finally {
			try{
            if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return sResult;
	}	
	
	/*
	 *	자산상각 복원- 당해년도 매각 이외의 변동이 없을 때 가능.
	*/
	
		public String call_sp_insert_assetmove_green_ret(String s_year, String asset_code, String user_id)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	String query = "{CALL .P_INSERT_ASSETMOVE_GREEN_RET (?,?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
						
			cstmt = con.prepareCall(query);
					
			cstmt.setString(1, s_year);
			cstmt.setString(2, asset_code);
			cstmt.setString(3, user_id);
			cstmt.registerOutParameter( 4, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(4); // 결과값
			
			cstmt.close();
		
		} catch (SQLException e) {
			System.out.println("[AssetDatabase:call_sp_insert_assetmove_green_ret]"+e);
			e.printStackTrace();
		} finally {
			try{
            if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return sResult;
	}	
	
	
	//당기이월 기수 check
	public String getMaxgisu()throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt_ch = null;
		ResultSet rs = null;
	
		String gisu = "";
		int count = 0;
		String query = "";
			
		query	= " SELECT max(gisu) from fassetdep ";
		

		try {
			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();    
	    		
			if(rs.next()){				
				gisu = rs.getString(1);
			}
	
			rs.close();
            pstmt.close();
            
		} catch (SQLException e) {
			System.out.println("[AssetDatabase:getMaxgisu]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return gisu;
	}
	
	/*
	 *	변동자산 임의등록 후 상각재계산
	*/
	public String call_sp_insert_assetmove1(String asset_code, int assch_seri, String user_id)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	String query = "{CALL P_INSERT_assetmove1 (?,?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
						
			cstmt = con.prepareCall(query);
					
			cstmt.setString(1, asset_code);
			cstmt.setInt(2, assch_seri);
			cstmt.setString(3, user_id);
			cstmt.registerOutParameter( 4, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(4); // 결과값
			
			cstmt.close();
		
		} catch (SQLException e) {
			System.out.println("[AssetDatabase:call_sp_insert_assetdep]"+e);
			e.printStackTrace();
		} finally {
			try{
            if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return sResult;
	}	
	
	
	 /**
     * 매각사항 -  자동전표 발행 
	 * -.
     */
    public AssetMoveBean [] getAssetSaleListAll( String ref_dt1, String ref_dt2, String gubun, String gubun_nm, String q_sort_nm, String q_sort, String gubun2 ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
//        String subQuery = "";
        String gubunQuery = "";
        String sortQuery = "";
        
        String query = "";
        
//      subQuery = "and nvl(a.use_yn,'Y')='Y' and a.car_mng_id is not null and nvl(b.prepare,'1')<>'4'\n";	
	
	      if(gubun2.equals("1")){			gubunQuery =  "and ap.actn_id = cl.client_id(+)  and ss.client_id = cl2.client_id(+)  and au.actn_st = '4' \n";	} //경매장 
          else if(gubun2.equals("2")){	         gubunQuery =  "  and ss.client_id = cl.client_id(+) and ss.client_id = cl2.client_id(+)  and au.actn_st is null  and a.assch_rmk not in ('매입옵션' )  \n";	}				
          	    
    	if(q_sort_nm.equals("1")){			sortQuery = "order by nvl(c.firm_nm,client_nm) " + q_sort + "\n";				}
    	else if(q_sort_nm.equals("5")){	    sortQuery = "order by  a.assch_date " + q_sort + "\n";							}
       	else{								sortQuery = "order by b.init_reg_dt, c.firm_nm " + q_sort + "\n";				}        	
          
         if(gubun2.equals("3")){	  //임시 - 매각수수료 발행위해 - 연초 자산이월전 수수료 발행건 처리	    
	        	    	query = "select  m.ASSET_CODE, 0 ASSCH_SERI,  se.comm_dt ASSCH_DATE ,  '3' ASSCH_TYPE, 0 SALE_AMT ,  b.car_nm asset_name,  m.acct_code, ss.client_id client_id2, \n" 
				+ "b.car_mng_id as CAR_MNG_ID, b.car_no,  nvl(se.comm_yn, 'N') as COMM_YN, nvl(se.sale_yn, 'N') as SALE_YN, cl.ven_code VEN_CODE , nvl(ss.enp_no, text_decrypt(ss.ssn, 'pw') )   car_nm ,  \n"
	        	+ " decode( cl2.client_st , '2', text_decrypt(cl2.ssn, 'pw') , cl2.enp_no)  client_tax   "    			
				+ " from  fassetma m, car_reg b, auction au , sui_etc se, apprsl ap, client cl , sui ss , client cl2 \n" //--, code j
				+ " where se.comm_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')\n"
				+ " and se.car_mng_id = b.car_mng_id  \n"
				+ " and se.car_mng_id = m.car_mng_id  \n"
				+ " and se.car_mng_id = au.car_mng_id(+)  \n"
				+ " and se.car_mng_id = ap.car_mng_id(+)  \n"
				+ " and se.car_mng_id = ss.car_mng_id  \n"
				+ " and ap.actn_id = cl.client_id(+)   \n" //경매장 
				+ " and ss.client_id = cl2.client_id(+)   \n" //낙찰자 
				+ " and au.actn_st = '4' order by se.comm_dt desc ";		
      } else {
		    query = "select a.ASSET_CODE, a.ASSCH_SERI,   a.ASSCH_DATE, a.ASSCH_TYPE, a.SALE_AMT,  m.asset_name, m.acct_code, ss.client_id client_id2, \n" 
				+ "b.car_mng_id as CAR_MNG_ID, b.car_no, nvl(se.comm_yn, 'N') as COMM_YN, nvl(se.sale_yn, 'N') as SALE_YN, cl.ven_code VEN_CODE , nvl(ss.enp_no, text_decrypt(ss.ssn, 'pw') )   car_nm , \n"
				+ " decode( cl2.client_st , '2', text_decrypt(cl2.ssn, 'pw') , cl2.enp_no)  client_tax   "   
				+ "from fassetmove a, fassetma m, car_reg b, auction au , sui_etc se, apprsl ap, client cl , sui ss , client cl2  \n" //--, code j
				+ "where a.assch_date between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')\n"
				+ "and a.assch_type = '3' and a.asset_code = m.asset_code \n"
				+ "and m.car_mng_id = b.car_mng_id(+)  \n"
				+ "and m.car_mng_id = au.car_mng_id(+)  \n"
				+ "and m.car_mng_id = se.car_mng_id(+)  \n"
				+ "and m.car_mng_id = ap.car_mng_id(+)  \n"
				+ "and m.car_mng_id = ss.car_mng_id  \n"			
				+ gubunQuery
				+ sortQuery;       	
        }			

  //	   System.out.println("qurey="+ query);
        Collection col = new ArrayList();
        try{
            pstmt = con.prepareStatement(query);
            //pstmt.setString(1, c_st.trim());
            rs = pstmt.executeQuery(query);
            while(rs.next()){
				col.add(makeAssetMoveBean(rs));
            }

            rs.close();
            pstmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (AssetMoveBean[])col.toArray(new AssetMoveBean[0]);
    }
    
    	/**
     * 자동차 등록 리스트 - 등록전표
     */
    private AssetMoveBean makeAssetMoveBean(ResultSet results) throws DatabaseException {

        try {
            AssetMoveBean bean = new AssetMoveBean();

		    bean.setAsset_code(results.getString("ASSET_CODE"));	
		    bean.setAssch_seri(results.getInt("ASSCH_SERI"));	
		    bean.setAsset_name(results.getString("ASSET_NAME"));	
		    bean.setAcct_code(results.getString("ACCT_CODE"));			
		    bean.setAssch_date(results.getString("ASSCH_DATE"));				
		    bean.setAssch_type(results.getString("ASSCH_TYPE"));					
		    bean.setSale_amt(results.getInt("SALE_AMT"));					
		    
		    bean.setCar_mng_id(results.getString("CAR_MNG_ID"));					
			bean.setCar_no(results.getString("CAR_NO"));	
			bean.setCar_nm(results.getString("CAR_NM"));	
			
			bean.setComm_yn(results.getString("COMM_YN"));	
			bean.setSale_yn(results.getString("SALE_YN"));		
			
			bean.setVen_code(results.getString("VEN_CODE"));	
			bean.setClient_id2(results.getString("CLIENT_ID2"));				
			bean.setClient_tax(results.getString("CLIENT_TAX"));				
     
     		
            return bean;
        }catch (SQLException e) {
			System.out.println(e);
			throw new DatabaseException(e.getMessage());
        }

	}
	
	public Offls_sui_etcBean getInfoComm(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Offls_sui_etcBean bean = new Offls_sui_etcBean();
        String query = "";
        
        query = " select a.*, c.car_no from sui_etc a, car_reg c " +
        	    " where a.car_mng_id='"+car_mng_id+"' and a.car_mng_id = c.car_mng_id(+) ";
   
        try{
                      
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
    		
            if(rs.next()){
            	
    			bean.setCar_mng_id(rs.getString("CAR_MNG_ID"));
			    bean.setComm_yn(rs.getString("COMM_YN"));
			    bean.setComm1_sup(rs.getInt("COMM1_SUP"));
			    bean.setComm1_vat(rs.getInt("COMM1_VAT"));
			    bean.setComm1_tot(rs.getInt("COMM1_TOT"));
			    bean.setComm2_sup(rs.getInt("COMM2_SUP"));
			    bean.setComm2_vat(rs.getInt("COMM2_VAT"));
			    bean.setComm2_tot(rs.getInt("COMM2_TOT"));
			    bean.setComm3_sup(rs.getInt("COMM3_SUP"));
			    bean.setComm3_vat(rs.getInt("COMM3_VAT"));
			    bean.setComm3_tot(rs.getInt("COMM3_TOT"));
			    bean.setComm4_sup(rs.getInt("COMM4_SUP"));
			    bean.setComm4_vat(rs.getInt("COMM4_VAT"));
			    bean.setComm4_tot(rs.getInt("COMM4_TOT"));
			    bean.setComm_date(rs.getString("COMM_DT"));
			    bean.setCar_no(rs.getString("CAR_NO"));
			    bean.setCommfile(rs.getString("COMMFILE"));
						    
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[AssetDatabase:getInfoComm]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }
    
      	//고정자산  변경 미등록 리스트 조회 - 등록/매입공채 )
	public Vector getAssetNoMoveRegList(String s_year, String s_month)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
			
		// 등록/매입공채/취득세
			
		query=" select a.car_mng_id, a.car_no,  a.reg_pay_dt as assch_date, a.reg_amt as cap_amt from car_reg a, cont b where a.car_mng_id = b.car_mng_id and a.reg_pay_dt like '"+s_year+ s_month + "%' and a.reg_amt > 0 and nvl(a.f1_chk, 'N' ) = 'N'  and nvl(b.use_yn, 'Y') = 'Y'  \n" +
		      " union all \n" +
		      " select a.car_mng_id, a.car_no,  a.reg_pay_dt as assch_date, a.loan_s_amt as cap_amt from car_reg a, cont b where a.car_mng_id = b.car_mng_id and a.reg_pay_dt like '"+s_year+ s_month + "%' and a.loan_s_amt > 0 and nvl(a.f7_chk, 'N' ) = 'N'  and nvl(b.use_yn, 'Y') = 'Y'  \n" +
		      " union all \n" +
		      " select a.car_mng_id, a.car_no,  a.acq_ex_dt as assch_date, a.acq_amt as cap_amt from car_reg a, cont b where a.car_mng_id = b.car_mng_id and a.acq_ex_dt like '"+s_year+ s_month + "%' and a.acq_amt > 0 and nvl(a.f2_chk, 'N' ) = 'N'   and nvl(b.use_yn, 'Y') = 'Y'  \n" +
		      " order by 3, 2";
		
		try {
				
				pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetNoMoveRegList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	public Offls_sui_etcBean getInfoSale(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Offls_sui_etcBean bean = new Offls_sui_etcBean();
        String query = "";
        				  				  
        query = " select a.car_mng_id, a.car_use, m.assch_date as comm_date,  c.car_no, c.car_nm, c.first_car_no, m.sale_amt, nvl(m.s_sup_amt, round(m.sale_amt/1.1) )  sup_amt, nvl(ss.client_id, m.client_id2)  client_id, ss.sui_nm, \n" +
        		" nvl(se.comm1_sup,0)+nvl(se.comm1_vat,0)+nvl(se.comm2_sup,0)+nvl(se.comm2_vat,0)+nvl(se.comm3_sup,0)+nvl(se.comm3_vat,0)+nvl(se.comm4_sup,0)+nvl(se.comm4_vat,0) as comm_amt, \n" +
        		" nvl(ya.get_amt,0)+nvl(ya.book_dr,0) as get_amt, \n" +
        		" nvl(ya.jun_reser,0)+nvl(ya.dep_amt,0) as adep_amt ,  \n" +
        		" nvl(yg.gdep_amt,0) as gdep_amt \n" +
        		" from sui_etc se, fassetmove m , fassetma a, car_reg c , sui ss,   \n" +
        		"      ( select * from  fyassetdep where gisu = (select max(gisu) from fyassetdep) ) ya , \n " +
        		"      ( select asset_code, gisu, jun_gdep, gdep_amt  from  fyassetdep_green  where gisu = (select max(gisu) from fyassetdep_green ) ) yg \n " +
        	    " where a.car_mng_id='"+car_mng_id+"' and a.asset_code = m.asset_code and  m.assch_type = '3'  \n " +
        	    " and   a.asset_code = ya.asset_code and a.asset_code = yg.asset_code(+)  and   a.car_mng_id = c.car_mng_id(+) and  a.car_mng_id = se.car_mng_id(+) "+
        	    " and   a.car_mng_id = ss.car_mng_id(+) ";
    
        try{
                      
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
    		
            if(rs.next()){
            	
    			bean.setCar_mng_id(rs.getString("CAR_MNG_ID"));
    			bean.setCar_use(rs.getString("CAR_USE"));
    			bean.setCar_nm(rs.getString("CAR_NM"));
    			bean.setComm_date(rs.getString("COMM_DATE"));
    		    bean.setCar_no(rs.getString("CAR_NO"));
    		    bean.setFirst_car_no(rs.getString("FIRST_CAR_NO"));
			    bean.setSale_amt(rs.getInt("SALE_AMT"));
			    bean.setComm_amt(rs.getInt("COMM_AMT"));
			    bean.setGet_amt(rs.getInt("GET_AMT"));
			    bean.setAdep_amt(rs.getInt("ADEP_AMT"));
			    bean.setGdep_amt(rs.getInt("GDEP_AMT"));
			    bean.setSui_nm(rs.getString("SUI_NM"));
			    bean.setClient_id(rs.getString("CLIENT_ID"));
			    bean.setSup_amt(rs.getInt("SUP_AMT"));
								    
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[AssetDatabase:getInfoSale]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }
    
    
    	public Offls_sui_etcBean getInfoSale1(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Offls_sui_etcBean bean = new Offls_sui_etcBean();
        String query = "";
        				  				  
        query = " select a.car_mng_id, a.car_use, m.assch_date as comm_date,  c.car_no, c.car_nm, c.first_car_no, m.sale_amt, nvl(m.s_sup_amt, round(m.sale_amt/1.1) )  sup_amt, m.client_id2  client_id, \n" +        	
        		" nvl(ya.get_amt,0)+nvl(ya.book_dr,0) as get_amt, \n" +
        		" nvl(ya.jun_reser,0)+nvl(ya.dep_amt,0) as adep_amt \n" +
        		" from fassetmove m , fassetma a, car_reg c , \n" +
        		"      ( select * from  fyassetdep where gisu = (select max(gisu) from fyassetdep) ) ya \n " +
        	    " where a.car_mng_id='"+car_mng_id+"' and a.asset_code = m.asset_code and  m.assch_type = '3'  \n " +
        	    " and   a.asset_code = ya.asset_code and  a.car_mng_id = c.car_mng_id(+)  ";
        try{
                      
            pstmt = con.prepareStatement(query);  		    		
    		rs = pstmt.executeQuery();
    		
            if(rs.next()){
            	
    			bean.setCar_mng_id(rs.getString("CAR_MNG_ID"));
    			bean.setCar_use(rs.getString("CAR_USE"));
    			bean.setCar_nm(rs.getString("CAR_NM"));
    			bean.setComm_date(rs.getString("COMM_DATE"));
    		    bean.setCar_no(rs.getString("CAR_NO"));
    		    bean.setFirst_car_no(rs.getString("FIRST_CAR_NO"));
			    bean.setSale_amt(rs.getInt("SALE_AMT"));		
			    bean.setGet_amt(rs.getInt("GET_AMT"));
			    bean.setAdep_amt(rs.getInt("ADEP_AMT"));			
			    bean.setClient_id(rs.getString("CLIENT_ID"));
			    bean.setSup_amt(rs.getInt("SUP_AMT"));
								    
            }
            rs.close();
            pstmt.close();
        }catch(SQLException se){
			System.out.println("[AssetDatabase:getInfoSale]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }
    
    
    public int insertSuiEtc(Offls_sui_etcBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
         
      				       
        query = " INSERT INTO SUI_ETC  ( "+
				" car_mng_id, comm_dt, comm1_sup, comm1_vat, comm1_tot, " +
				" comm2_sup, comm2_vat, comm2_tot , comm3_sup, comm3_vat, comm3_tot, comm4_sup, comm4_vat , comm4_tot ) "+
				" values \n"+
                " ( ?, replace(?,'-',''),  ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?, 0, 0, 0 )"; 
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);  
            
            pstmt.setString(1, bean.getCar_mng_id());
            pstmt.setString(2, bean.getComm_date());
            pstmt.setInt(3, bean.getComm1_sup());
            pstmt.setInt(4, bean.getComm1_vat());
            pstmt.setInt(5, bean.getComm1_tot());
            pstmt.setInt(6, bean.getComm2_sup());
            pstmt.setInt(7, bean.getComm2_vat());
            pstmt.setInt(8, bean.getComm2_tot());
            pstmt.setInt(9, bean.getComm3_sup());
            pstmt.setInt(10, bean.getComm3_vat());
            pstmt.setInt(11, bean.getComm3_tot());
			//추가 20121228 - 류길선
  //          pstmt.setInt(12, bean.getComm4_sup());
 //           pstmt.setInt(13, bean.getComm4_vat());
//            pstmt.setInt(14, bean.getComm4_tot());
                               
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AssetDatabase:insertSuiEtc]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    
    public int updateSuiEtc(Offls_sui_etcBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE SUI_ETC SET"+
				" comm_dt=replace(?,'-',''), comm1_sup = ?, comm1_vat=?, comm1_tot=?, "+
				" comm2_sup = ?, comm2_vat=?, comm2_tot=?, comm3_sup = ?, comm3_vat=?, comm3_tot=?  " + // + comm4_sup = ?, comm4_vat=?, comm4_tot=? " +
				" WHERE car_mng_id =?  ";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);  
            
            pstmt.setString(1, bean.getComm_date());
            pstmt.setInt(2, bean.getComm1_sup());
            pstmt.setInt(3, bean.getComm1_vat());
            pstmt.setInt(4, bean.getComm1_tot());
            pstmt.setInt(5, bean.getComm2_sup());
            pstmt.setInt(6, bean.getComm2_vat());
            pstmt.setInt(7, bean.getComm2_tot());
            pstmt.setInt(8, bean.getComm3_sup());
            pstmt.setInt(9, bean.getComm3_vat());
            pstmt.setInt(10, bean.getComm3_tot());
			//추가 20121228 - 류길선
   //         pstmt.setInt(11, bean.getComm4_sup());
  //          pstmt.setInt(12, bean.getComm4_vat());
  //          pstmt.setInt(13, bean.getComm4_tot());

            pstmt.setString(11, bean.getCar_mng_id());
            
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AssetDatabase:updateSuiEtc]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

	public int updateSuiEtcComm(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE SUI_ETC SET"+
				" comm_yn= 'Y'"+
				" WHERE car_mng_id ='" + car_mng_id + "' and  nvl(comm_yn, 'N') = 'N' \n";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);  
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AssetDatabase:updateSuiEtcComm]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    
    public int updateSuiEtcSale(String car_mng_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE SUI_ETC SET"+
				" sale_yn= 'Y'"+
				" WHERE car_mng_id ='" + car_mng_id + "' and  nvl(sale_yn, 'N') = 'N' \n";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);  
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AssetDatabase:updateSuiEtcSale]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    
	//매각 관련 수수료 등록 여부	
	public int getSuiEtcCount(String car_mng_id)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
			
		int count = 0;
		String query = "";
			
		query	= " SELECT count(*)  from sui_etc where car_mng_id = '"+car_mng_id+"'";
		
		try {
			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();    
	    		
			if(rs.next()){				
				count = rs.getInt(1);
			}
			rs.close();
            pstmt.close();
            
		} catch (SQLException e) {
			System.out.println("[AssetDatabase:getSuiEtcCount]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return count;
	}
    
  
    public Vector getAssetGetListAll( String ref_dt1, String ref_dt2, String gubun ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
       	Vector vt = new Vector();
        String subQuery = "";
        String gubunQuery = "";
    
        String query = "";
           
         if (!gubun.equals("") ) {        
			 if(gubun.equals("1")){					gubunQuery = "and   b.car_use = '" + gubun + "'";		}        
	         else{									gubunQuery = "and   b.car_use = '" + gubun + "'";       } 				
  		}
	
		
	    query=" select cr.car_no, b.car_use,  b.asset_code, 1 as assch_seri, b.asset_name, b.get_date as assch_date, '1' as assch_type, '차량대금' assch_rmk, nvl(ce.car_fs_amt,0) + nvl(ce.sd_cs_amt,0) - nvl(ce.dc_cs_amt,0)  as cap_amt, 0 as sale_quant, 0 as sale_amt, b.DEPRF_YN	" +
              "   from  car_reg  a, fassetma b , car_etc ce , cont cc, car_reg cr  " +
	  	      "  where nvl(cc.use_yn, 'Y') = 'Y'  and cc.car_mng_id = a.car_mng_id  and cc.rent_mng_id = ce.rent_mng_id and cc.rent_l_cd = ce.rent_l_cd " +
	          "    and   a.car_mng_id = b.car_mng_id and b.car_mng_id = cr.car_mng_id(+) and nvl(b.ma_chk, 'N')  = 'N' and cc.dlv_dt between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')" + gubunQuery + 
			  "  union all	" +	
  		      " select cr.car_no, b.car_use, a.asset_code, a.assch_seri, b.asset_name, a.assch_date, a.assch_type, a.assch_rmk, a.cap_amt, a.sale_quant, a.sale_amt, b.DEPRF_YN	from fassetmove a, fassetma b, car_reg cr  " +
			  "		 where a.asset_code = b.asset_code  and a.assch_type = '1' and  b.car_mng_id = cr.car_mng_id(+) and a.assch_date between replace('" + ref_dt1 + "','-','') and replace('" + ref_dt2 +"','-','')" + gubunQuery + 
			  " 	   order by 6, 4, 2 ";		
	

  	//   System.out.println("getAssetGetListAll qurey="+ query);
  
        try{
         	pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetGetListAll]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
     
     //취득현황
       public Vector getAssetGetListAll( String chk1, String ref_dt1, String ref_dt2, String gubun ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
       
               	
        PreparedStatement pstmt = null;
        ResultSet rs = null;
       	Vector vt = new Vector();
        String subQuery = "";
        String gubunQuery = "";
        String dtQuery = "";       
        String query = "";
        
       String f_date1="";
		String t_date1="";
	/*
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		
		s_month = AddUtil.addZero(s_month);
	 	
	 	CommonDataBase.getInstance().addMonth(AddUtil.getDate() , -1) ;	
			
		if(chk1.equals("1")) {
			f_date1 = CommonDataBase.getInstance().addMonth(AddUtil.getDate() , -1) ;	
			t_date1 = CommonDataBase.getInstance().addMonth(AddUtil.getDate() , -1);	
		}
		
		if(chk1.equals("2")) {
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
					
		if(chk1.equals("3")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}  
         
      */   
        
        if (!gubun.equals("") ) {        
			 if(gubun.equals("1")){					gubunQuery = "and   b.car_use = '" + gubun + "'";		}        
	         else{									gubunQuery = "and   b.car_use = '" + gubun + "'";       } 				
  		}
  		  		  		
  		if(chk1.equals("2"))			dtQuery = " and a.assch_date like to_char(sysdate,'YYYYMM')||'%'";
		else if(chk1.equals("1"))		dtQuery = " and a.assch_date like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";		
		else if(chk1.equals("3")){		
			dtQuery = " and a.assch_date between replace('"+ref_dt1+"', '-','') and replace('"+ref_dt2+"', '-','')";
		}
		
		
		
	/*
	    query=" select cr.car_no, b.car_use,  b.asset_code, 1 as assch_seri, b.asset_name, b.get_date as assch_date, '1' as assch_type, '차량대금' assch_rmk, decode(cc.car_gu, '1', nvl(ce.car_fs_amt,0) + nvl(ce.sd_cs_amt,0) - nvl(ce.dc_cs_amt,0), nvl(fe.sh_amt,0)/1.1 )  as cap_amt, 0 as sale_quant, 0 as sale_amt, b.DEPRF_YN	" +
              "   from  car_reg  a, fassetma b , car_etc ce , cont cc, car_reg cr , fee_etc fe " +
	  	      "  where nvl(cc.use_yn, 'Y') = 'Y'  and cc.car_mng_id = a.car_mng_id  and cc.rent_mng_id = ce.rent_mng_id and cc.rent_l_cd = ce.rent_l_cd and cc.rent_mng_id = fe.rent_mng_id(+) and cc.rent_l_cd = fe.rent_l_cd(+) and fe.rent_st = '1' " +
	          "    and   a.car_mng_id = b.car_mng_id and b.car_mng_id = cr.car_mng_id(+) and cc.dlv_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 +"','-','')" + gubunQuery + 
			  "  union all	" +	
  		      " select cr.car_no, b.car_use, a.asset_code, a.assch_seri, b.asset_name, a.assch_date, a.assch_type, a.assch_rmk, a.cap_amt, a.sale_quant, a.sale_amt, b.DEPRF_YN	from fassetmove a, fassetma b, car_reg cr  " +
			  "		 where a.asset_code = b.asset_code  and a.assch_type = '1' and  b.car_mng_id = cr.car_mng_id(+) and a.assch_date between replace('" + f_date1 + "','-','') and replace('" + t_date1 +"','-','')" + gubunQuery + 
			  " 	   order by 6, 4, 2 ";	
			  추가 : 신차가 같은 기수에 중도해지되면서 재리스되는 경우발생 추가 reg_dt 체크	- master등록' 
	*/
	
	/*   query=" select cr.car_no, b.car_use,  b.asset_code, 1 as assch_seri, b.asset_name, b.get_date as assch_date, '1' as assch_type, '차량대금' assch_rmk, decode(cc.car_gu, '1', nvl(ce.car_fs_amt,0) + nvl(ce.sd_cs_amt,0) - nvl(ce.dc_cs_amt,0), nvl(fe.sh_amt,0)/1.1 )  as cap_amt, 0 as sale_quant, 0 as sale_amt, b.DEPRF_YN	\n" +
              "   from  car_reg  a, fassetma b , car_etc ce , cont cc, car_reg cr , (select * from fee_etc where rent_st = '1') fe , (select car_mng_id, min(reg_dt) reg_dt from cont where car_st<>'4' group by car_mng_id ) cm \n" +
	  	     // "  where nvl(cc.use_yn, 'Y') = 'Y'  and cc.car_mng_id = a.car_mng_id  and cc.rent_mng_id = ce.rent_mng_id and cc.rent_l_cd = ce.rent_l_cd and cc.rent_mng_id = fe.rent_mng_id(+) and cc.rent_l_cd = fe.rent_l_cd(+)  " +
	  	      "  where cc.car_mng_id = cm.car_mng_id and cc.reg_dt = cm.reg_dt and cc.car_mng_id = a.car_mng_id  and cc.rent_mng_id = ce.rent_mng_id and cc.rent_l_cd = ce.rent_l_cd and cc.rent_mng_id = fe.rent_mng_id(+) and cc.rent_l_cd = fe.rent_l_cd(+)  \n" +
	          "    and   a.car_mng_id = b.car_mng_id and b.car_mng_id = cr.car_mng_id(+) and nvl(b.ma_chk, 'N')  = 'N'  and cc.dlv_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 +"','-','')" + gubunQuery + 
	    */ 
	         
	/*    query=" select cr.car_no, b.car_use, a.asset_code, a.assch_seri, b.asset_name, a.assch_date, a.assch_type, a.assch_rmk, a.cap_amt, a.sale_quant, a.sale_amt, b.DEPRF_YN	from fassetmove a, fassetma b, car_reg cr  " +
			  "		  where a.asset_code = b.asset_code  and a.assch_type = '1' and nvl(a.ma_chk, 'N') = 'Y' and  b.car_mng_id = cr.car_mng_id(+) and a.assch_date between replace('" + f_date1 + "','-','') and replace('" + t_date1 +"','-','')" + gubunQuery +    
			  "   union all	" +	
  		     " select cr.car_no, b.car_use, a.asset_code, a.assch_seri, b.asset_name, a.assch_date, a.assch_type, a.assch_rmk, a.cap_amt, a.sale_quant, a.sale_amt, b.DEPRF_YN	from fassetmove a, fassetma b, car_reg cr  " +
			  "		 where a.asset_code = b.asset_code  and a.assch_type = '1' and  b.car_mng_id = cr.car_mng_id(+) and  nvl(a.ma_chk, 'N') = 'N' and a.assch_date between replace('" + f_date1 + "','-','') and replace('" + t_date1 +"','-','')" + gubunQuery + 
			  " 	   order by 6, 4, 2 ";		
  
     query=" select cr.car_no, b.car_use, a.asset_code, a.assch_seri, b.asset_name, a.assch_date, a.assch_type, a.assch_rmk, a.cap_amt, a.sale_quant, a.sale_amt, b.DEPRF_YN	from fassetmove a, fassetma b, car_reg cr  " +
			  "		 where a.asset_code = b.asset_code  and a.assch_type = '1' and  nvl(a.ma_chk, 'N')  = 'Y'   and  b.car_mng_id = cr.car_mng_id(+) and a.assch_date between replace('" + f_date1 + "','-','') and replace('" + t_date1 +"','-','')" + gubunQuery + 
			  "  union all	" +	
  		      " select cr.car_no, b.car_use, a.asset_code, a.assch_seri, b.asset_name, a.assch_date, a.assch_type, a.assch_rmk, a.cap_amt, a.sale_quant, a.sale_amt, b.DEPRF_YN	from fassetmove a, fassetma b, car_reg cr  " +
			  "		 where a.asset_code = b.asset_code  and a.assch_type = '1' and assch_rmk = '차량대금'   and  b.car_mng_id = cr.car_mng_id(+) and a.assch_date between replace('" + f_date1 + "','-','') and replace('" + t_date1 +"','-','')" + gubunQuery + 
			  " 	   order by 6, 4, 2 ";		
  */
		 query= " select cr.car_no, b.car_use, a.asset_code,  b.asset_name, a.assch_date,  a.assch_rmk, a.cap_amt  \n"+
					 "  from fassetmove a, fassetma b, car_reg cr  \n"+
					 "		 where a.asset_code = b.asset_code  and a.assch_type = '1' and  nvl(a.ma_chk, 'N')  in ( 'Y'  , 'N' )  \n"+
					 "         and  b.car_mng_id = cr.car_mng_id(+) " + dtQuery +  gubunQuery + 			
					"   order by 5, 3, 1  ";
			    
        try{
         	pstmt = con.prepareStatement(query);
		    rs = pstmt.executeQuery();
		    
 	//		   System.out.println("getAssetGetListAll qurey="+ query);
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
			System.out.println("[AssetDatabase:getAssetGetListAll]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	} 
	
	     //취득현황 - 차량대금만 
       public Vector getAssetGetListAll1( String chk1, String ref_dt1, String ref_dt2, String gubun ) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
       	Vector vt = new Vector();
        String subQuery = "";
        String gubunQuery = "";
               
        String query = "";
        
        String f_date1="";
		String t_date1="";
	
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		
		if(chk1.equals("1")) {
			f_date1 = AddUtil.getDate(4);	
			t_date1 = AddUtil.getDate(4);	
		}
		
		if(chk1.equals("2")) {
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
					
		if(chk1.equals("3")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}  
           
        if (!gubun.equals("") ) {        
			 if(gubun.equals("1")){					gubunQuery = "and   b.car_use = '" + gubun + "'";		}        
	         else{									gubunQuery = "and   b.car_use = '" + gubun + "'";       } 				
  		}
	
		//   query=" select cr.car_no, b.car_use,  b.asset_code, 1 as assch_seri, b.asset_name, b.get_date as assch_date, '1' as assch_type, '차량대금' assch_rmk, decode(cc.car_gu, '1', nvl(ce.car_fs_amt,0) + nvl(ce.sd_cs_amt,0) - nvl(ce.dc_cs_amt,0), nvl(fe.sh_amt,0)/1.1 )  as cap_amt, 0 as sale_quant, 0 as sale_amt, b.DEPRF_YN	\n" +
         //     "   from  car_reg  a, fassetma b , car_etc ce , cont cc, car_reg cr , (select * from fee_etc where rent_st = '1') fe , (select car_mng_id, min(reg_dt) reg_dt from cont where car_st<>'4' group by car_mng_id ) cm \n" +
	  	     // "  where nvl(cc.use_yn, 'Y') = 'Y'  and cc.car_mng_id = a.car_mng_id  and cc.rent_mng_id = ce.rent_mng_id and cc.rent_l_cd = ce.rent_l_cd and cc.rent_mng_id = fe.rent_mng_id(+) and cc.rent_l_cd = fe.rent_l_cd(+)  " +
	  	   //   "  where cc.car_mng_id = cm.car_mng_id and cc.reg_dt = cm.reg_dt and cc.car_mng_id = a.car_mng_id  and cc.rent_mng_id = ce.rent_mng_id and cc.rent_l_cd = ce.rent_l_cd and cc.rent_mng_id = fe.rent_mng_id(+) and cc.rent_l_cd = fe.rent_l_cd(+)  \n" +
	      //    "    and   a.car_mng_id = b.car_mng_id and b.car_mng_id = cr.car_mng_id(+) and nvl(b.ma_chk, 'N')  = 'N'  and cc.dlv_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 +"','-','')" + gubunQuery + 
		
		/*   query=" select cr.car_no, b.car_use, a.asset_code, a.assch_seri, b.asset_name, a.assch_date, a.assch_type, a.assch_rmk, a.cap_amt, a.sale_quant, a.sale_amt, b.DEPRF_YN	from fassetmove a, fassetma b, car_reg cr  " +
			  "		 where a.asset_code = b.asset_code  and a.assch_type = '1' and  nvl(a.ma_chk, 'N')  = 'Y'   and  b.car_mng_id = cr.car_mng_id(+) and a.assch_date between replace('" + f_date1 + "','-','') and replace('" + t_date1 +"','-','')" + gubunQuery + 
			  "  union all	" +	
  		      " select cr.car_no, b.car_use, a.asset_code, a.assch_seri, b.asset_name, a.assch_date, a.assch_type, a.assch_rmk, a.cap_amt, a.sale_quant, a.sale_amt, b.DEPRF_YN	from fassetmove a, fassetma b, car_reg cr  " +
			  "		 where a.asset_code = b.asset_code  and a.assch_type = '1' and assch_rmk = '차량대금'   and  b.car_mng_id = cr.car_mng_id(+) and a.assch_date between replace('" + f_date1 + "','-','') and replace('" + t_date1 +"','-','')" + gubunQuery + 
			  " 	   order by 6, 4, 2 ";		
  */
		 query=" 		  select a.car_no, a.car_use, a.asset_code, a.asset_name, a.assch_date, '차량대금' as assch_rmk,  sum(a.cap_amt)  cap_amt \n"+
					" from ( \n"+
					" select cr.car_no, b.car_use, a.asset_code,  b.asset_name, a.assch_date,  a.cap_amt  \n"+
					"  from fassetmove a, fassetma b, car_reg cr  \n"+
					"		 where a.asset_code = b.asset_code  and a.assch_type = '1' and  nvl(a.ma_chk, 'N')  = 'Y'  \n"+
					"         and  b.car_mng_id = cr.car_mng_id(+) and a.assch_date between replace('" + f_date1 + "','-','') and replace('" + t_date1 +"','-','')" + gubunQuery + 			
					"  union all	 \n"+
					"   select cr.car_no, b.car_use, a.asset_code,  b.asset_name, a.assch_date,  a.cap_amt  \n"+
					"   from fassetmove a, fassetma b, car_reg cr  \n"+
					"		 where a.asset_code = b.asset_code  and a.assch_type = '1'  and  nvl(a.ma_chk, 'N')  = 'N' and assch_rmk  like '차량대금%'    \n"+
					"         and  b.car_mng_id = cr.car_mng_id(+) and a.assch_date between replace('" + f_date1 + "','-','') and replace('" + t_date1 +"','-','')" + gubunQuery + 
					" ) a \n"+
					"   group by a.car_no, a.car_use, a.asset_code, a.asset_name, a.assch_date \n"+
					"   order by 5, 3, 1  ";
   
       
        try{
         	pstmt = con.prepareStatement(query);
		    rs = pstmt.executeQuery();
		    
 	//		   System.out.println("qurey="+ query);
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
			System.out.println("[AssetDatabase:getAssetGetListAll]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	} 
	
   
     /*
	 *	차량대금 끝전 처리
	*/
	public String call_sp_update_assetmaster(String s_year, String s_month, String s_gubun, String user_id)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	String query = "{CALL P_UPDATE_assetmaster (?,?,?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
						
			cstmt = con.prepareCall(query);
					
			cstmt.setString(1, s_year);
			cstmt.setString(2, s_month);
			cstmt.setString(3, s_gubun);
			cstmt.setString(4, user_id);
			cstmt.registerOutParameter( 5, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(5); // 결과값
			
			cstmt.close();
		
		} catch (SQLException e) {
			System.out.println("[AssetDatabase:call_sp_update_assetmaster]"+e);
			e.printStackTrace();
		} finally {
			try{
            if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return sResult;
	}
	
	  // 상각현황 -취득금액중 취득세 만큼 차이날 수 있다. (취득세는 전월 취득을 당월에 납부하므로)
	public Vector getAssetList(String chk1, String ref_dt1, String ref_dt2, String gubun, String s_kd , String r_year, String f_month, String t_month) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
        String subQuery = "";
        String gubunQuery = "";
     
        String f_date1="";
		String t_date1="";
		
		String f_asset_date = r_year+ f_month + "01";   //상각기간 : 현재 회계기수 여야 함
		String t_asset_date = r_year+ t_month + "31";   //상각기간 : 현재 회계기수 여야 함
	
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		
		if(chk1.equals("1")) {
			f_date1 = AddUtil.getDate(4);	
			t_date1 = AddUtil.getDate(4);	
		}
		
		if(chk1.equals("2")) {
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
					
		if(chk1.equals("3")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}  
		 
        if (!gubun.equals("") ) {        
			 if(gubun.equals("1")){					gubunQuery = "and   a.car_use = '" + gubun + "'";		}        
	         else{									gubunQuery = "and   a.car_use = '" + gubun + "'";       } 				
  		}   
  		
  		query = " select aa.asset_code, a.asset_name, a.get_date, aa.car_no, a.ndepre_rate, a.life_exist, a.depr_method, a.deprf_yn, aa.get_amt + aa.cap_amt t1, \n " +
  		    	" sum ( case when aa.asset_mm between  '" + f_month + "' and  '" + t_month + "' then 0 else aa.book_mdr end ) t2, \n " +
  				" sum ( case when aa.asset_mm between  '" + f_month + "' and  '" + t_month + "' then 0 else aa.dep_mamt end ) t3, \n " +
  				" sum ( case when aa.asset_mm between  '" + f_month + "' and  '" + t_month + "' then aa.book_mdr else 0 end ) t4, \n " +
  				" sum ( case when aa.asset_mm between  '" + f_month + "' and  '" + t_month + "' then aa.book_mcr else 0 end ) t6, \n " +
  				" sum ( case when aa.asset_mm between  '" + f_month + "' and  '" + t_month + "' then aa.reser_mcr else 0 end ) t7, \n " +
  				"  aa.b_book_mdr   b2,  aa.b_dep_mamt   b3, \n " +
  				" sum ( case when aa.asset_mm between  '" + f_month + "' and  '" + t_month + "' then aa.dep_mamt else 0 end ) t8  from  (  \n " +
  				"  select a.asset_code,  da.asset_mm, da.book_mdr, da.book_mcr, da.dep_mamt, da.reser_mcr, ba.book_mdr as b_book_mdr, ba.book_mcr as b_book_mcr, ba.dep_mamt as b_dep_mamt, \n " +
  				"  		  ya.get_amt, c.car_no, nvl(m.cap_amt, 0) cap_amt  \n " +
  				"  from fassetma a, \n " +
  				"    ( select asset_code, sum(cap_amt) cap_amt  from  fassetmove where assch_type = '1' and assch_date between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') group by asset_code ) m ,  \n" + 
  		    	"    ( select * from  fyassetdep where gisu = (select max(gisu) from fyassetdep where gisu  ='" + r_year + "' )) ya , car_reg c,  \n " +
		        "    ( select * from  fassetdep where gisu = (select max(gisu) from fyassetdep where gisu  = '" + r_year + "' )) da,  \n " +
		        "    ( select  asset_code, sum(book_mdr) book_mdr, sum(book_mcr) book_mcr, sum(dep_mamt) dep_mamt from  fassetdep where gisu = (select max(gisu) from fyassetdep where gisu  < '" + r_year + "' ) group by asset_code ) ba   \n " +
		        " 	where a.asset_code = ya.asset_code  and a.asset_code = da.asset_code  and a.asset_code = ba.asset_code(+) and a.asset_code = m.asset_code(+) and a.get_date between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  \n" + 
		        "  		and  da.gisu = '" + r_year + "' and  da.asset_mm between '01' and '" + t_month + "' \n " +
		        "  		and  a.car_mng_id = c.car_mng_id(+) " + gubunQuery +
		        "  ) aa , fassetma a  \n " +
				" where aa.asset_code = a.asset_code \n " +
				" group by  aa.asset_code, a.asset_name, a.get_date, aa.car_no, a.ndepre_rate, a.life_exist, a.depr_method, a.deprf_yn, aa.get_amt, aa.cap_amt, aa.b_book_mdr, aa.b_dep_mamt \n " +
			    " order by 3 asc, 1 asc ";
				  
		
		try {
					
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	
	

	
	  // 처분된건 제외
	public Vector getAssetList(String st,  String t_month) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
        String subQuery = "";
        
        
       	/*리스*/
       	if(st.equals("1")){		subQuery += " and a.car_use='1'";
		/*렌트*/
		}else if(st.equals("2")){	subQuery += " and a.car_use='2'";
	    }    
	
	
		query = " select a.asset_code, a.asset_name, a.get_date, a.get_gubun,   \n" +
	    		" a.deprf_yn, ya.gisu, ya.get_amt,  ya.book_dr, ya.book_cr, ya.jun_reser,  \n" +
	   			" c.car_no, da.book_amdr, da.book_mdr, da.book_amcr, da.book_mcr, da.dep_mamt , da.dep_amamt , ya.dep_amt,  \n" +
	   			" yg.jun_gdep, yg.gdep_mamt , yg.gdep_amt , a.dlv_dt , a.car_gu ,  g.assch_date gov_date, g.cap_amt  gov_amt   \n" +
	    		" from fassetma a, car_reg c,  \n" +
	    		" ( select asset_code, sum(case when asset_mm = '"+t_month +"' then book_mdr else 0 end ) book_mdr, sum(case when asset_mm = '"+t_month +"' then 0 else book_mdr end ) book_amdr, sum(case when asset_mm = '"+t_month +"' then 0 else book_mcr end) book_amcr,  sum(case when asset_mm = '"+t_month +"' then book_mcr else 0 end) book_mcr , "+
			    "   sum(case when asset_mm = '"+t_month +"' then dep_mamt else 0 end) dep_mamt , sum(case when asset_mm = '"+t_month +"' then 0 else dep_mamt end) dep_amamt \n" +
			 	" from  fassetdep where gisu = (select max(gisu) from fassetdep ) and  asset_mm <='"+t_month +"' \n" +
			    " group by  asset_code, gisu ) da, \n" +
			    " ( select * from  fassetmove where ma_chk = 'G'   )  g , \n" +
  				"  (select asset_code, gisu, get_amt, jun_reser, book_dr, book_cr, dep_amt  from  fyassetdep where gisu = (select max(gisu) from fyassetdep )) ya , \n" +
				"  (select * from fyassetdep_green  where gisu =  (select  max(gisu) from fyassetdep_green )) yg \n " +
				" where a.asset_code = da.asset_code and a.asset_code = ya.asset_code and a.car_mng_id = c.car_mng_id(+) and a.asset_code  = g.asset_code(+)  and  a.asset_code = yg.asset_code(+) "+subQuery + " and a.deprf_yn <> '6'   \n" +
      			"  order by 5 asc,  3 asc ";
		
		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	
	  // 처분된건 제외
	public Vector getAssetList1(String st,  String t_month,  String r_year) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
        String subQuery = "";
        
        
       	/*리스*/
       	if(st.equals("1")){		subQuery += " and a.car_use='1'";
		/*렌트*/
		}else if(st.equals("2")){	subQuery += " and a.car_use='2'";
	    }    
		
			query = " select a.asset_code, a.asset_name, a.get_date, a.get_gubun,  \n" +
	    		" a.deprf_yn, ya.gisu, ya.get_amt,  ya.book_dr, ya.book_cr, ya.jun_reser,  \n" +
	   			" c.car_no, da.book_amdr, da.book_mdr, da.book_amcr, da.book_mcr, da.dep_mamt , da.dep_amamt , dga.gdep_mamt , dga.gdep_amamt , yg.jun_gdep , a.gov_amt, nvl(mv.assch_date, '0000' ) assch_date  \n" +
	    		" from fassetma a, car_reg c,    \n" +
	    		" ( select assch_date, asset_code from fassetmove where ma_chk = 'G' ) mv,    \n" +
	    		" ( select asset_code, sum(case when asset_mm = '"+t_month +"' then book_mdr else 0 end ) book_mdr, sum(case when asset_mm = '"+t_month +"' then 0 else book_mdr end ) book_amdr, sum(case when asset_mm = '"+t_month +"' then 0 else book_mcr end) book_amcr,  sum(case when asset_mm = '"+t_month +"' then book_mcr else 0 end) book_mcr , "+
			    "   sum(case when asset_mm = '"+t_month +"' then dep_mamt else 0 end) dep_mamt , sum(case when asset_mm = '"+t_month +"' then 0 else dep_mamt end) dep_amamt  \n" +
			   	" from  fassetdep where gisu = (select max(gisu) from fyassetdep where gisu  = '" + r_year + "' )  and  asset_mm <='"+t_month +"' \n" +
			    " group by  asset_code, gisu ) da, \n" +
			   	" ( select asset_code,    sum(case when asset_mm = '"+t_month +"' then gdep_mamt else 0 end) gdep_mamt , sum(case when asset_mm = '"+t_month +"' then 0 else gdep_mamt end) gdep_amamt  \n" +
			 	" from  fassetdep_green where gisu = (select max(gisu) from fassetdep_green where gisu  = '" + r_year + "' )  and  asset_mm <='"+t_month +"' \n" +
			    " group by  asset_code, gisu ) dga, \n" +
			   "  (select asset_code, gisu, get_amt, jun_reser, book_dr, book_cr, dep_amt  from  fyassetdep where gisu = (select max(gisu) from fyassetdep where gisu  = '" + r_year + "' )) ya,  \n" +
			   "  (select asset_code, gisu, jun_gdep, gdep_amt , gdep_mamt  from  fyassetdep_green  where gisu = (select max(gisu) from fyassetdep_green where gisu  = '" + r_year + "' )) yg,  \n" +
  				"  (select asset_code, '6' deprf_yn  from  fyassetdep where gisu < (select max(gisu) from fyassetdep where gisu  < '" + r_year + "' ) and book_cr > 0) ma   \n" +
				"  where a.asset_code = da.asset_code and a.asset_code = dga.asset_code(+)  and a.asset_code = ya.asset_code and a.asset_code = yg.asset_code(+)  and a.car_mng_id = c.car_mng_id(+) "+subQuery + " \n" +
				//매각조건 - 당기전 매각은 제외함
				" and a.asset_code = ma.asset_code(+) and  a.asset_code = mv.asset_code(+) and nvl(ma.deprf_yn, '0') <>  '6'  \n" +			
      			"  order by 5 asc,  3 asc ";


		/* - 현금 구입차량	
			query = " select a.asset_code, a.asset_name, a.get_date, a.get_gubun,   \n" +
	    		" a.deprf_yn, ya.gisu, ya.get_amt,  ya.book_dr, ya.book_cr, ya.jun_reser,  \n" +
	    		"  c.car_no, c.car_nm, c.init_reg_dt, nvl(ce.car_fs_amt, 0) + nvl(ce.car_fv_amt, 0) - nvl(ce.dc_cs_amt, 0)  - nvl(ce.dc_cv_amt, 0)  + nvl(ce.sd_cs_amt, 0)  + nvl(ce.sd_cv_amt, 0)  car_amt,  \n" +
	    		" cc.use_yn,  c.car_no, da.book_amdr, da.book_mdr, da.book_amcr, da.book_mcr, da.dep_mamt , da.dep_amamt \n" +
	    		" from fassetma a, car_reg c,  allot b, car_etc ce ,  cont cc, \n" +
	    		" ( select asset_code, sum(case when asset_mm = '"+t_month +"' then book_mdr else 0 end ) book_mdr, sum(case when asset_mm = '"+t_month +"' then 0 else book_mdr end ) book_amdr, sum(case when asset_mm = '"+t_month +"' then 0 else book_mcr end) book_amcr,  sum(case when asset_mm = '"+t_month +"' then book_mcr else 0 end) book_mcr , "+
			    "   sum(case when asset_mm = '"+t_month +"' then dep_mamt else 0 end) dep_mamt , sum(case when asset_mm = '"+t_month +"' then 0 else dep_mamt end) dep_amamt \n" +
			 	" from  fassetdep where gisu = (select max(gisu) from fyassetdep where gisu  = '" + r_year + "' )  and  asset_mm <='"+t_month +"' \n" +
			    " group by  asset_code, gisu ) da, \n" +
			          "  (select asset_code, gisu, get_amt, jun_reser, book_dr, book_cr, dep_amt  from  fyassetdep where gisu = (select max(gisu) from fyassetdep where gisu  = '" + r_year + "' )) ya,  \n" +
  				"  (select asset_code, '6' deprf_yn  from  fyassetdep where gisu < (select max(gisu) from fyassetdep where gisu  < '" + r_year + "' ) and book_cr > 0) ma   \n" +
				"  where    a.car_mng_id = cc.car_mng_id and cc.use_yn = 'Y' and cc.car_st <> '4'  and cc.rent_mng_id = b.rent_mng_id(+) and cc.rent_l_cd  = b.rent_l_cd(+) and b.lend_dt is null \n" +
				" and cc.rent_mng_id  = ce.rent_mng_id(+) and cc.rent_l_cd = ce.rent_l_cd(+)  \n" +
				" and   a.asset_code = da.asset_code and a.asset_code = ya.asset_code and a.car_mng_id = c.car_mng_id(+) "+subQuery + " \n" +
				//매각조건 - 당기전 매각은 제외함
				" and a.asset_code = ma.asset_code(+)  and nvl(ma.deprf_yn, '0') <>  '6'  \n" +			
      			"  order by  c.init_reg_dt asc ";
      		*/	
        
		try {
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetList1]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
			
	
		//당기이월 기수 check
	public String getMove_dt(String asset_code)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt_ch = null;
		ResultSet rs = null;
	
		String assch_date = "";
		int count = 0;
		String query = "";
			
		query	= " SELECT assch_date from fassetmove where asset_code = '"+ asset_code + "' and  assch_type = '3' ";
		

		try {
			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();    
	    		
			if(rs.next()){				
				assch_date = rs.getString(1);
			}
	
			rs.close();
            pstmt.close();
            
		} catch (SQLException e) {
			System.out.println("[AssetDatabase:getMove_dt]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return assch_date;
	}
	
	  /**
     * 수수료증빙
     */
    public int updateSuiCommScan(String car_mng_id, String file_name )throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int count = 0;
                	
	    query=" UPDATE  sui_etc SET commfile = ? WHERE car_mng_id =?  ";				
		
        
        try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);  
            pstmt.setString(1, file_name);
            pstmt.setString(2, car_mng_id);
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AssetDatabase:updateSuiCommScan]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }
    
 	
	  // 매각현황 :s_au -> M:매입옵션, P:폐차
	public Vector getAssetIncomList() throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";    
  		  	  		  
  		 query = "   SELECT decode(c.car_use||c.an_st, '17', '3', '18', '3', '19', '3', '27', '4', '28', '4', '29', '4', c.car_use) gubun,  C.*  FROM ( 	 \n"+
  			       "          select  decode(car_use, '1', '1', '2', '2', decode(actn_id, '000000', '2', '111111', '2', '999999', '2', '5') ) car_use, actn_id,   decode(actn_id, '000000', 7, '000502', 1, '013011', 2,  '003226', 3, '011723', 4, '013222', 11, '020385', 6,  '022846',  10, '111111', 8,  9) an_st, \n"+
  		       //            "	 select car_use,  actn_id,   decode(actn_id, '000000', 8, '000502', 1, '013011', 2,  '003226', 3, '011723', 4, '013222', 5, '020385', 6,  '111111', 7,  9) an_st, \n"+
  		      //              "	 select car_use,  actn_id,   decode(actn_id, '000000', 9, '000502', 1, '013011', 2, '004242', 3, '003226', 4, '011723', 5, '013222', 6, '020385', 7,  '111111', 8,  10) an_st, \n"+
				 "			sum(decode(assch_yy, '2012', 1, 0)) cnt1,   "+
				 "			sum(decode(assch_yy, '2013', 1, 0)) cnt2,   "+
				 "			sum(decode(assch_yy, '2014', 1, 0)) cnt3,   "+
				 "			sum(decode(assch_yy, '2015', 1, 0)) cnt4,   "+
				 "			sum(decode(assch_yy, '2016', 1, 0)) cnt5,  \n"+
				 "	 	  	sum(decode(assch_yy, '2012', (sup_amt - (get_amt + book_dr - jun_reser - dep_amt - gdep_amt )), 0)) amt1,   "+
		    	 "	 	   	sum(decode(assch_yy, '2013', (sup_amt - (get_amt + book_dr - jun_reser - dep_amt - gdep_amt )), 0)) amt2,   "+
				 "			sum(decode(assch_yy, '2014', (sup_amt - (get_amt + book_dr - jun_reser - dep_amt - gdep_amt )), 0)) amt3,  "+
				 "			sum(decode(assch_yy, '2015', (sup_amt - (get_amt + book_dr - jun_reser - dep_amt - gdep_amt )), 0)) amt4,   "+
				 "			sum(decode(assch_yy, '2016', (sup_amt - (get_amt + book_dr - jun_reser - dep_amt - gdep_amt )), 0)) amt5   \n"+
				 "			from (   \n"+ 
                 "                select b.asset_code, b.assch_yy, decode(b.car_use , '1', '1', decode(b.fuel_kd, '3', '5', '5', '5', '6', '5', '2') ) car_use , decode(b.assch_rmk, '폐차', '111111', '매입옵션', '000000', b.actn_id) actn_id,  \n"+   
           //        "                select b.asset_code, b.assch_yy, b.car_use, decode(b.assch_rmk, '폐차', '999999', '매입옵션', '000000', b.actn_id) actn_id,  \n"+   
           //      "                       b.get_amt, b.book_dr, b.jun_reser, b.dep_amt, decode(b.assch_rmk, '폐차', b.sale_amt, b.sup_amt) sup_amt  999999 :폐차  \n"+   
                 "                       b.get_amt, b.book_dr, b.jun_reser, b.dep_amt,  b.gdep_amt, b.sup_amt \n"+   
                 "                from (   \n"+
		         "                select a.asset_code, m.sale_amt, substr(m.assch_date,1,4) assch_yy, a.car_use,   c.fuel_kd,   case when m.assch_rmk like '%폐차%' then '폐차' when m.assch_rmk like '%폐기%' then '폐차'  else m.assch_rmk end assch_rmk,  \n"+   
		         "                   ya.get_amt, ya.book_dr, ya.book_cr, ya.jun_reser, ya.dep_amt, yg.gdep_amt,  nvl (decode( s.actn_id, '003226', '020385', '011723', '020385','013222', '022846', s.actn_id  ) , decode(m.assch_rmk, '매입옵션', '000000', '매각', '111111') )  actn_id,  \n"+   
		         "   	  case when nvl(m.s_sup_amt, 0)  > 0 then m.s_sup_amt else  case when m.assch_rmk like '%폐%' then m.sale_amt  when m.assch_rmk like '%매각%' then nvl(m.s_sup_amt ,  round(m.sale_amt/1.1) )   when m.assch_rmk like '%매입옵션%' then nvl(m.s_sup_amt, round(m.sale_amt/1.1) )   else 0 end end sup_amt 	 "+	
		   //      "      round(m.sale_amt/1.1) sup_amt   \n"+   
		         "                           from fassetma a,  fassetmove m,  \n"+   
		         "                        ( select a.* from  fyassetdep a, (select asset_code, max(gisu) gisu from fyassetdep group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) ya ,   \n"+   
		         "                        ( select a.* from  fyassetdep_green  a, (select asset_code, max(gisu) gisu from fyassetdep_green  group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) yg ,   \n"+   
		         "                                car_reg c, apprsl s    \n"+   
		         "                            where a.asset_code = ya.asset_code and a.asset_code = yg.asset_code(+) and a.asset_code = m.asset_code and m.assch_type = '3' and m.assch_date >= '20120101'   \n"+   
		         "                               and  a.car_mng_id = c.car_mng_id(+) and a.car_mng_id = s.car_mng_id(+)   \n"+   
                 "                ) b    \n"+   
		         "         ) a     \n"+
		         "      group by  decode(car_use, '1', '1', '2', '2', decode(actn_id, '000000', '2', '111111', '2', '999999', '2', '5') ) ,  actn_id  \n"+
		         "  )  c         \n"+          
	 		"   order by gubun, car_use, an_st, actn_id          ";				       	     		  			  		  	
				
		try {
					
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetIncomList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

 // 매각현황 :s_au -> M:매입옵션, P:폐차
	public Vector getAssetIncomList2(String gubun1 , int s_year, int e_year) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";    
		String sub_query = "";  
		String f_year = Integer.toString(s_year);
		int s_year_m = s_year -1;	
		
		
  		if(!gubun1.equals("")){//차종구분(소형,중형,대형 ........ 이런것들)
			if(gubun1.equals("1"))			sub_query += " AND decode(f.s_st, '101','100', '102','112', '105','104', decode(substr(f.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', f.s_st)) = '104' and  f.car_comp_id < '0006' \n";
			else if(gubun1.equals("2"))		sub_query += " AND decode(f.s_st, '101','100', '102','112', '105','104', decode(substr(f.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', f.s_st)) = '103' and  f.car_comp_id < '0006'  \n";
			else if(gubun1.equals("3"))		sub_query += " AND decode(f.s_st, '101','100', '102','112', '105','104', decode(substr(f.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', f.s_st)) = '112' and  f.car_comp_id < '0006'  \n";
			else if(gubun1.equals("4"))		sub_query += " AND decode(f.s_st, '101','100', '102','112', '105','104', decode(substr(f.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', f.s_st)) = '302' and  f.car_comp_id < '0006'  \n";			
			else if(gubun1.equals("5"))		sub_query += " AND decode(f.s_st, '101','100', '102','112', '105','104', decode(substr(f.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', f.s_st)) = '301' and  f.car_comp_id < '0006'  \n";			
			else if(gubun1.equals("6"))		sub_query += " AND decode(f.s_st, '101','100', '102','112', '105','104', decode(substr(f.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', f.s_st)) = '401' and  f.car_comp_id < '0006'  \n";			
			else if(gubun1.equals("7"))		sub_query += " AND decode(f.s_st, '101','100', '102','112', '105','104', decode(substr(f.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', f.s_st)) = '801' and  f.car_comp_id < '0006'  \n";
			else if(gubun1.equals("8"))		sub_query += " AND decode(f.s_st, '101','100', '102','112', '105','104', decode(substr(f.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', f.s_st)) = '300' and  f.car_comp_id < '0006'  \n";
			else if(gubun1.equals("9"))		sub_query += " AND decode(f.s_st, '101','100', '409','100', '102','112', '105','104', decode(substr(f.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', f.s_st)) = '100' and  f.car_comp_id < '0006'  \n";
			else if(gubun1.equals("10"))	sub_query += " AND decode(f.s_st, '101','100', '102','112', '105','104', decode(substr(f.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', f.s_st)) = '701' and  f.car_comp_id < '0006'  \n";
			
			else if(gubun1.equals("20"))	sub_query += " AND f.car_comp_id > '0005' \n";
		}  	  		  
  		 query = "   SELECT decode(c.car_use||c.an_st, '17', '3', '18', '3', '19', '3', '27', '4', '28', '4', '29', '4', c.car_use) gubun,  C.*  FROM ( 	 \n"+
  			      "          select  decode(car_use, '1', '1', '2', '2', decode(actn_id, '000000', '2', '111111', '2', '999999', '2', '5') ) car_use, actn_id,   decode(actn_id, '000000', 7, '000502', 1, '013011', 2, '061796', 3, '003226', 4, '011723', 5, '013222', 11, '020385', 6,  '022846',  10, '048691',  12,  '111111', 8,  9) an_st, \n" ;
  		     	     
			 	for (int i = s_year ; i <= e_year ; i++){		      	          
					query += " sum(decode(to_number(assch_yy),"+(i)+", 1, 0 )) cnt"+(i-s_year_m)+", \n";			
		     	}
			 	
			 	for (int i = s_year ; i <= e_year ; i++){		      	          
					query += " sum(decode(to_number(assch_yy), "+(i)+", (sup_amt - (get_amt + book_dr - jun_reser - dep_amt - gdep_amt )), 0)) amt"+(i-s_year_m)+", \n";			
		     	}  		 
				
			 query +="	'' chk 	from (   \n"+ 
              "                select b.asset_code, b.assch_yy, decode(b.car_use , '1', '1', decode(b.fuel_kd, '3', '5', '5', '5', '6', '5', '2') ) car_use , decode(b.assch_rmk, '폐차', '111111', '매입옵션', '000000', b.actn_id) actn_id,  \n"+   
              "                       b.get_amt, b.book_dr, b.jun_reser, b.dep_amt, b.sup_amt , b.gdep_amt \n"+   
               "                from (   \n"+
		         "                select  DISTINCT(c.car_mng_id),a.asset_code, m.sale_amt, substr(m.assch_date,1,4) assch_yy, a.car_use,   c.fuel_kd,   case when m.assch_rmk like '%폐차%' then '폐차' when m.assch_rmk like '%폐기%' then '폐차'  else m.assch_rmk end assch_rmk,  \n"+   
		         "                   ya.get_amt, ya.book_dr, ya.book_cr, ya.jun_reser, ya.dep_amt,  nvl(yg.gdep_amt,0) gdep_amt ,  nvl (decode( s.actn_id, '003226', '020385', '011723', '020385','013222', '022846', s.actn_id  ) , decode(m.assch_rmk, '매입옵션', '000000', '매각', '111111') )  actn_id,  \n"+   
		         "   	  case when nvl(m.s_sup_amt, 0)  > 0 then m.s_sup_amt else  case when m.assch_rmk like '%폐%' then m.sale_amt  when m.assch_rmk like '%매각%' then nvl(m.s_sup_amt ,  round(m.sale_amt/1.1) )   when m.assch_rmk like '%매입옵션%' then nvl(m.s_sup_amt, round(m.sale_amt/1.1) )   else 0 end end sup_amt 	 "+	
		         "                       from fassetma a,  fassetmove m,   car_reg c, apprsl s, cont e , car_etc d, car_nm f , \n"+   
		         "                      ( select a.* from  fyassetdep a, (select asset_code, max(gisu) gisu from fyassetdep group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) ya ,   \n"+   
		   		   "                      ( select a.* from  fyassetdep_green  a , (select asset_code, max(gisu) gisu from fyassetdep_green  group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) yg   \n"+   
		         "                            where a.asset_code = ya.asset_code and a.asset_code = m.asset_code and m.assch_type = '3' and m.assch_date >= '" + f_year + "' \n"+   
		         "									   and a.asset_code = yg.asset_code(+)   \n"+   
		         "                               and  a.car_mng_id = c.car_mng_id(+) and a.car_mng_id = s.car_mng_id(+)    \n"+   
				 "						AND c.car_mng_id = e.car_mng_id AND e.rent_mng_id = d.rent_mng_id AND e.rent_l_cd = d.rent_l_cd AND d.car_id = f.car_id AND d.car_seq = f.car_seq    \n"+ sub_query+
                 "                ) b    \n"+   
		         "         ) a     \n"+
		         "      group by  decode(car_use, '1', '1', '2', '2', decode(actn_id, '000000', '2', '111111', '2', '999999', '2', '5') ) ,  actn_id  \n"+
		         "  )  c         \n"+          
	 		"   order by gubun, car_use, an_st, actn_id          ";				       	     		  			  		  	
				
		try {
				
			  			
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetIncomList2]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
		
  // 매각현황 :s_au -> M:매입옵션, P:폐차
	 
	public Vector getAssetIncomList(String s_yy) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";      		  	
		
		 query = "   SELECT decode(c.car_use||c.an_st, '17', '3', '18', '3', '19', '3', '27', '4', '28', '4', '29', '4', c.car_use) gubun,  C.*  FROM ( 	 \n"+
		                   "        select  decode(car_use, '1', '1', '2', '2', decode(actn_id, '000000', '2', '111111', '2', '999999', '2', '5') ) car_use, actn_id,   decode(actn_id, '000000', 7, '000502', 1, '013011', 2,  '003226', 3, '011723', 4, '013222', 11, '020385', 6, '022846', 10,  '111111', 8,  9) an_st, \n"+
  		//                   "	 select car_use,  actn_id,   decode(actn_id, '000000', 8, '000502', 1, '013011', 2,  '003226', 3, '011723', 4, '013222', 5, '020385', 6,  '111111', 7,  9) an_st, \n"+
  		                   
	//          query = "   SELECT decode(c.car_use||c.an_st, '18', '3', '19', '3', '110', '3', '28', '4', '29', '4', '210', '4', c.car_use) gubun,  C.*  FROM ( 	 \n"+
  	//	                   "	 select car_use,  actn_id,   decode(actn_id, '000000', 9, '000502', 1, '013011', 2, '004242', 3, '003226', 4, '011723', 5, '013222', 6, '020385', 7,  '111111', 8,  10)  an_st, \n"+  	
				"			sum(decode(assch_mm, '01', 1, 0)) cnt1,  "+ 
				"			sum(decode(assch_mm, '02', 1, 0)) cnt2,  "+ 
				"			sum(decode(assch_mm, '03', 1, 0)) cnt3,  "+ 
				"			sum(decode(assch_mm, '04', 1, 0)) cnt4,  "+ 
                "           sum(decode(assch_mm, '05', 1, 0)) cnt5,  "+ 
                "           sum(decode(assch_mm, '06', 1, 0)) cnt6,   \n"+
                "           sum(decode(assch_mm, '07', 1, 0)) cnt7,  "+ 
                "           sum(decode(assch_mm, '08', 1, 0)) cnt8,  "+ 
                "           sum(decode(assch_mm, '09', 1, 0)) cnt9,  "+ 
                "           sum(decode(assch_mm, '10', 1, 0)) cnt10, "+  
                "          	sum(decode(assch_mm, '11', 1, 0)) cnt11,  "+ 
                "           sum(decode(assch_mm, '12', 1, 0)) cnt12,  \n"+
	       		"         	sum(decode(assch_mm, '01', (sup_amt - (get_amt + book_dr - jun_reser - dep_amt - gdep_amt )), 0)) amt1,  "+ 
	       		"			sum(decode(assch_mm, '02', (sup_amt - (get_amt + book_dr - jun_reser - dep_amt - gdep_amt )), 0)) amt2,  "+ 
	       		"			sum(decode(assch_mm, '03', (sup_amt - (get_amt + book_dr - jun_reser - dep_amt - gdep_amt )), 0)) amt3, "+ 
                "          	sum(decode(assch_mm, '04', (sup_amt - (get_amt + book_dr - jun_reser - dep_amt - gdep_amt )), 0)) amt4,  "+ 
                "          	sum(decode(assch_mm, '05', (sup_amt - (get_amt + book_dr - jun_reser - dep_amt - gdep_amt )), 0)) amt5,   "+ 
                "          	sum(decode(assch_mm, '06', (sup_amt - (get_amt + book_dr - jun_reser - dep_amt - gdep_amt )), 0)) amt6,  \n"+
                "          	sum(decode(assch_mm, '07', (sup_amt - (get_amt + book_dr - jun_reser - dep_amt - gdep_amt )), 0)) amt7,   "+ 
                "          	sum(decode(assch_mm, '08', (sup_amt - (get_amt + book_dr - jun_reser - dep_amt - gdep_amt )), 0)) amt8,   "+ 
                "          	sum(decode(assch_mm, '09', (sup_amt - (get_amt + book_dr - jun_reser - dep_amt - gdep_amt )), 0)) amt9,   "+ 
                "          	sum(decode(assch_mm, '10', (sup_amt - (get_amt + book_dr - jun_reser - dep_amt - gdep_amt )), 0)) amt10,   "+ 
                "          	sum(decode(assch_mm, '11', (sup_amt - (get_amt + book_dr - jun_reser - dep_amt - gdep_amt )), 0)) amt11,   "+ 
                "          	sum(decode(assch_mm, '12', (sup_amt - (get_amt + book_dr - jun_reser - dep_amt - gdep_amt )), 0)) amt12   "+ 
				"			from (         \n"+		
				" 				select b.asset_code, b.assch_mm,  decode(b.car_use , '1', '1', decode(b.fuel_kd, '3', '5', '5', '5', '6', '5', '2') ) car_use , decode(b.assch_rmk, '폐차', '111111', '매입옵션', '000000', b.actn_id) actn_id,  \n"+   
                "                       b.get_amt, b.book_dr, b.jun_reser, b.dep_amt, b.sup_amt, b.gdep_amt  \n"+   
                "                from (   \n"+
		        "                select a.asset_code, m.sale_amt, substr(m.assch_date,5,2) assch_mm, a.car_use,    c.fuel_kd,  case when m.assch_rmk like '%폐차%' then '폐차' when m.assch_rmk like '%폐기%' then '폐차'  else m.assch_rmk end assch_rmk,  \n"+   
		        "                   ya.get_amt, ya.book_dr, ya.book_cr, ya.jun_reser, ya.dep_amt, nvl(yg.gdep_amt,0) gdep_amt,  nvl (decode(s.actn_id , '003226', '020385', '011723', '020385', '013222', '022846',  s.actn_id )   ,     decode(m.assch_rmk, '매입옵션', '000000', '매각', '111111') )  actn_id,  \n"+   
		        "   	  case when nvl(m.s_sup_amt, 0)  > 0 then m.s_sup_amt else  case when m.assch_rmk like '%폐%' then m.sale_amt  when m.assch_rmk like '%매각%' then nvl(m.s_sup_amt ,  round(m.sale_amt/1.1) )   when m.assch_rmk like '%매입옵션%' then nvl(m.s_sup_amt, round(m.sale_amt/1.1) )   else 0 end end sup_amt 	 "+	
		        "                           from fassetma a,  fassetmove m,  car_reg c, apprsl s  ,  \n"+   
		        "   ( select a.* from  fyassetdep a, (select asset_code, max(gisu) gisu from fyassetdep group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) ya ,   \n"+   
		        "   ( select a.* from  fyassetdep_green  a, (select asset_code, max(gisu) gisu from fyassetdep_green  group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) yg    \n"+   
		        "                            where a.asset_code = ya.asset_code and a.asset_code = m.asset_code and m.assch_type = '3' and m.assch_date like '"+s_yy + "%' \n"+   
		        "									   and a.asset_code = yg.asset_code(+)   \n"+   
		        "                               and  a.car_mng_id = c.car_mng_id(+) and a.car_mng_id = s.car_mng_id(+)   \n"+   
		 		"                ) b    \n"+                               
		        "          ) a  \n"+
		        "       group by decode(car_use, '1', '1', '2', '2', decode(actn_id, '000000', '2', '111111', '2', '999999', '2', '5') ) ,  actn_id      "+ 
		        "  )  c         \n"+          
	 		"   order by gubun, car_use, an_st, actn_id          ";			
		  	
				
		try {
					
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetIncomList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	 // 매각현황 :s_au -> M:매입옵션, P:폐차
	 
	public Vector getAssetIncomList2(String s_yy, String gubun1 ) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";      		  	
		String sub_query = "";   
			
		
  		if(!gubun1.equals("")){//차종구분(소형,중형,대형 ........ 이런것들)
			if(gubun1.equals("1"))			sub_query += " AND decode(f.s_st, '101','100', '102','112', '105','104', decode(substr(f.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', f.s_st)) = '104' and  f.car_comp_id < '0006' \n";
			else if(gubun1.equals("2"))		sub_query += " AND decode(f.s_st, '101','100', '102','112', '105','104', decode(substr(f.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', f.s_st)) = '103' and  f.car_comp_id < '0006'  \n";
			else if(gubun1.equals("3"))		sub_query += " AND decode(f.s_st, '101','100', '102','112', '105','104', decode(substr(f.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', f.s_st)) = '112' and  f.car_comp_id < '0006'  \n";
			else if(gubun1.equals("4"))		sub_query += " AND decode(f.s_st, '101','100', '102','112', '105','104', decode(substr(f.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', f.s_st)) = '302' and  f.car_comp_id < '0006'  \n";			
			else if(gubun1.equals("5"))		sub_query += " AND decode(f.s_st, '101','100', '102','112', '105','104', decode(substr(f.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', f.s_st)) = '301' and  f.car_comp_id < '0006'  \n";			
			else if(gubun1.equals("6"))		sub_query += " AND decode(f.s_st, '101','100', '102','112', '105','104', decode(substr(f.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', f.s_st)) = '401' and  f.car_comp_id < '0006'  \n";			
			else if(gubun1.equals("7"))		sub_query += " AND decode(f.s_st, '101','100', '102','112', '105','104', decode(substr(f.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', f.s_st)) = '801' and  f.car_comp_id < '0006'  \n";
			else if(gubun1.equals("8"))		sub_query += " AND decode(f.s_st, '101','100', '102','112', '105','104', decode(substr(f.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', f.s_st)) = '300' and  f.car_comp_id < '0006'  \n";
			else if(gubun1.equals("9"))		sub_query += " AND decode(f.s_st, '101','100', '409','100', '102','112', '105','104', decode(substr(f.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', f.s_st)) = '100' and  f.car_comp_id < '0006'  \n";
			else if(gubun1.equals("10"))	sub_query += " AND decode(f.s_st, '101','100', '102','112', '105','104', decode(substr(f.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', f.s_st)) = '701' and  f.car_comp_id < '0006'  \n";
			
			else if(gubun1.equals("20"))	sub_query += " AND f.car_comp_id > '0005' \n";
		}  	  	
		 query = "   SELECT decode(c.car_use||c.an_st, '17', '3', '18', '3', '19', '3', '27', '4', '28', '4', '29', '4', c.car_use) gubun,  C.*  "+
				 "   FROM ( 	 \n"+
		                   "        select  decode(car_use, '1', '1', '2', '2', decode(actn_id, '000000', '2', '111111', '2', '999999', '2', '5') ) car_use, "+
						   "	            actn_id,   "+
						   "                decode(actn_id, '000000', 7, '000502', 1, '013011', 2,  '061796', 3, '003226', 4, '011723', 5, '013222', 11, '020385', 6, '022846', 10, '048691', 12 ,  '111111', 8,  9) an_st, \n";
    
					   for (int i = 1 ; i <= 12 ; i++){		      	          
						query += " sum(decode(to_number(assch_mm),"+(i)+", 1, 0 )) cnt"+(i)+", \n";			
						}
						
						for (int i = 1 ; i <= 12 ; i++){		      	          
						query += " sum(decode(to_number(assch_mm), "+(i)+", (sup_amt - (get_amt + book_dr - jun_reser - dep_amt - gdep_amt )), 0)) amt"+(i)+", \n";			
						}  
			
						query +="	'' chk	from (         \n"+		
							" 				select b.asset_code, b.assch_mm,  decode(b.car_use , '1', '1', decode(b.fuel_kd, '3', '5', '5', '5', '6', '5', '2') ) car_use , "+
							"	                   decode(b.assch_rmk, '폐차', '111111', '매입옵션', '000000', b.actn_id) actn_id,  \n"+   
						//  "                      b.get_amt, b.book_dr, b.jun_reser, b.dep_amt, decode(b.assch_rmk, '폐차', b.sale_amt, b.sup_amt) sup_amt  \n"+   
					        "                      b.get_amt, b.book_dr, b.jun_reser, b.dep_amt, b.sup_amt, b.gdep_amt \n"+   
			                "                from  (   \n"+
						    "						select DISTINCT(c.car_mng_id),a.asset_code, m.sale_amt, substr(m.assch_date,5,2) assch_mm, a.car_use,    c.fuel_kd, "+
							"							   case when m.assch_rmk like '%폐차%' then '폐차' when m.assch_rmk like '%폐기%' then '폐차'  else m.assch_rmk end assch_rmk,  \n"+   
					        "                              ya.get_amt, ya.book_dr, ya.book_cr, ya.jun_reser, ya.dep_amt, nvl(yg.gdep_amt,0)  gdep_amt, "+
							"	                           nvl ( decode(s.actn_id , '003226', '020385', '011723', '020385', '013222', '022846',  s.actn_id ), decode(m.assch_rmk, '매입옵션', '000000', '매각', '111111') )  actn_id, \n"+   
					        "   	                       case when nvl(m.s_sup_amt, 0)  > 0 then m.s_sup_amt else  case when m.assch_rmk like '%폐%' then m.sale_amt  when m.assch_rmk like '%매각%' then nvl(m.s_sup_amt ,  round(m.sale_amt/1.1) )   when m.assch_rmk like '%매입옵션%' then nvl(m.s_sup_amt, round(m.sale_amt/1.1) )   else 0 end end sup_amt 	 "+	
					     // "                              round(m.sale_amt/1.1) sup_amt   \n"+   
					        "                       from   fassetma a,  fassetmove m,  \n"+   
						    "                              ( select a.* from  fyassetdep a, (select asset_code, max(gisu) gisu from fyassetdep group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) ya ,   \n"+   
					        "                              ( select a.* from  fyassetdep_green  a, (select asset_code, max(gisu) gisu from fyassetdep_green  group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) yg ,   \n"+   
						    "                              car_reg c, apprsl s, cont e , car_etc d, car_nm f \n"+   
					        "                       where  a.asset_code = ya.asset_code and a.asset_code = yg.asset_code(+)  and a.asset_code = m.asset_code and m.assch_type = '3' and m.assch_date like '"+s_yy + "%' \n"+   
					        "                              and  a.car_mng_id = c.car_mng_id(+) and a.car_mng_id = s.car_mng_id(+)   \n"+   
							"		                       AND c.car_mng_id = e.car_mng_id AND e.rent_mng_id = d.rent_mng_id AND e.rent_l_cd = d.rent_l_cd AND d.car_id = f.car_id AND d.car_seq = f.car_seq    \n"+ sub_query+
					 		"                      ) b    \n"+                               
					        "       ) a  \n"+
					        "       group by decode(car_use, '1', '1', '2', '2', decode(actn_id, '000000', '2', '111111', '2', '999999', '2', '5') ) ,  actn_id      "+ 
				 "  )  c         \n"+          
	 			 "   order by gubun, car_use, an_st, actn_id         ";			
		  	
				
		try {
					
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetIncomList2]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	//
	
	
	 // mobile    매각현황 :s_au -> M:매입옵션, P:폐차 , 
	public Vector getAssetIncomList(String s_yy, String s_mm) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";    
  		  /*	  		  
  		 query = "   SELECT decode(c.car_use||c.an_st, '17', '3', '18', '3', '19', '3', '27', '4', '28', '4', '29', '4', c.car_use) gubun,  C.*  FROM ( 	 \n"+
  			       "          select  decode(car_use, '1', '1', '2', '2', decode(actn_id, '000000', '2', '111111', '2', '999999', '2', '5') ) car_use, actn_id,   decode(actn_id, '000000', 7, '000502', 1, '013011', 2,  '003226', 3, '011723', 4, '013222', 11, '020385', 6,  '022846',  10, '111111', 8,  9) an_st, \n"+
  		   		   "			sum(1) cnt,   "+				
				 "			sum(sup_amt) sup_amt,   "+
				 "			sum(sup_amt - (get_amt + book_dr - jun_reser - dep_amt -gdep_amt  ) ) amt   \n"+
				 "			from (   \n"+ 
              "                select b.asset_code, b.assch_yy, decode(b.car_use , '1', '1', decode(b.fuel_kd, '3', '5', '5', '5', '6', '5', '2') ) car_use , decode(b.assch_rmk, '폐차', '111111', '매입옵션', '000000', b.actn_id) actn_id,  \n"+   
               "                       b.get_amt, b.book_dr, b.jun_reser, b.dep_amt, b.gdep_amt , b.sup_amt \n"+   
               "                from (   \n"+
		         "                select a.asset_code, m.sale_amt, substr(m.assch_date,1,4) assch_yy, a.car_use,   c.fuel_kd,   case when m.assch_rmk like '%폐차%' then '폐차' when m.assch_rmk like '%폐기%' then '폐차'  else m.assch_rmk end assch_rmk,  \n"+   
		         "                   ya.get_amt, ya.book_dr, ya.book_cr, ya.jun_reser, ya.dep_amt, nvl(yg.gdep_amt,0) gdep_amt, nvl (decode( s.actn_id, '003226', '020385', '011723', '020385','013222', '022846', s.actn_id  ) , decode(m.assch_rmk, '매입옵션', '000000', '매각', '111111') )  actn_id,  \n"+   
		         "   	  case when nvl(m.s_sup_amt, 0)  > 0 then m.s_sup_amt else  case when m.assch_rmk like '%폐%' then m.sale_amt  when m.assch_rmk like '%매각%' then nvl(m.s_sup_amt ,  round(m.sale_amt/1.1) )   when m.assch_rmk like '%매입옵션%' then nvl(m.s_sup_amt, round(m.sale_amt/1.1) )   else 0 end end sup_amt 	 "+	
		         "                           from fassetma a,  fassetmove m,    \n"+   
		         "                      ( select a.* from  fyassetdep a, (select asset_code, max(gisu) gisu from fyassetdep group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) ya ,   \n"+   
		         "                      ( select a.* from  fyassetdep_green a, (select asset_code, max(gisu) gisu from fyassetdep_green group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) yg ,   \n"+   
		         "                                car_reg c, apprsl s    \n"+   
		         "                            where a.asset_code = ya.asset_code  and a.asset_code = yg.asset_code(+)  and a.asset_code = m.asset_code and m.assch_type = '3'   \n"+   
		         "                               and m.assch_date  like  '" + s_yy + s_mm + "%'  \n"+   
		         "                               and  a.car_mng_id = c.car_mng_id(+) and a.car_mng_id = s.car_mng_id(+)   \n"+   
                 "                ) b    \n"+   
		         "         ) a     \n"+
		         "      group by  decode(car_use, '1', '1', '2', '2', decode(actn_id, '000000', '2', '111111', '2', '999999', '2', '5') ) ,  actn_id  \n"+
		         "  )  c         \n"+          
	 		"   order by gubun, car_use, an_st, actn_id          ";				   
	 		*/	 		
			
		 query = "	SELECT decode(c.car_use||c.an_st, '17', '3', '18', '3', '19', '3', '27', '4', '28', '4', '29', '4', c.car_use) gubun,  C.*  FROM (   \n"+
					 "	select car_use , actn_id , an_st , sum(cnt) cnt , sum(sup_amt) sup_amt , sum(amt) amt from (  \n"+
					 "	select '1' car_use , '000502' actn_id,  1 an_st , 0 cnt , 0 sup_amt, 0 amt from dual   \n"+
					 " 	union   \n"+
					 "	select '1' car_use , '013011' actn_id,  2 an_st , 0 cnt , 0 sup_amt, 0 amt from dual  \n"+
					 "  union   \n"+
					 "	select '1' car_use , '061796' actn_id,  3 an_st , 0 cnt , 0 sup_amt, 0 amt from dual   \n"+
					 "	union  \n"+
					 "	select '1' car_use , '020385' actn_id,  6 an_st , 0 cnt , 0 sup_amt, 0 amt from dual  \n"+
					 "	union   \n"+
					 "	select '1' car_use , '022846' actn_id,  10 an_st , 0 cnt , 0 sup_amt, 0 amt from dual  \n"+
					 "	union  \n"+
					 "	select '1' car_use , '048691' actn_id,  11 an_st , 0 cnt , 0 sup_amt, 0 amt from dual  \n"+
					 "	union  \n"+
					 "	select '2' car_use , '000502' actn_id,  1 an_st , 0 cnt , 0 sup_amt, 0 amt from dual  \n"+
					 "	union   \n"+
					 "	select '2' car_use , '013011' actn_id,  2 an_st , 0 cnt , 0 sup_amt, 0 amt from dual  \n"+
					 "  union   \n"+
					 "	select '2' car_use , '061796' actn_id,  3 an_st , 0 cnt , 0 sup_amt, 0 amt from dual   \n"+
					 "	union  \n"+
					 "	select '2' car_use , '020385' actn_id,  6 an_st , 0 cnt , 0 sup_amt, 0 amt from dual  \n"+
					 "	union  \n"+
					 "	select '2' car_use , '022846' actn_id,  10 an_st , 0 cnt , 0 sup_amt, 0 amt from dual  \n"+
					 "	union  \n"+
					 "	select '2' car_use , '048691' actn_id,  11 an_st , 0 cnt , 0 sup_amt, 0 amt from dual  \n"+
					 "	union  \n"+
					 "	select '5' car_use , '000502' actn_id,  1 an_st , 0 cnt , 0 sup_amt, 0 amt from dual  \n"+
					 "	union  \n"+
					 "	select '5' car_use , '013011' actn_id,  2 an_st , 0 cnt , 0 sup_amt, 0 amt from dual  \n"+
					 "	union  \n"+
					 "	select '5' car_use , '061796' actn_id,  3 an_st , 0 cnt , 0 sup_amt, 0 amt from dual  \n"+
					 "	union  \n"+
					 "	select '5' car_use , '020385' actn_id,  6 an_st , 0 cnt , 0 sup_amt, 0 amt from dual  \n"+
					 "	union   \n"+
					 "	select '5' car_use , '022846' actn_id,  10 an_st , 0 cnt , 0 sup_amt, 0 amt from dual  \n"+
					 "	union  \n"+
					 "	select '5' car_use , '048691' actn_id,  11 an_st , 0 cnt , 0 sup_amt, 0 amt from dual  \n"+
					 "	union  \n"+
					 "	select '1' car_use , '000000' actn_id,  7 an_st , 0 cnt , 0 sup_amt, 0 amt from dual  \n"+
					 "	union   \n"+
					 "	select '1' car_use , '111111' actn_id,  8 an_st , 0 cnt , 0 sup_amt, 0 amt from dual  \n"+
					 "	union  \n"+
					 "	select '2' car_use , '000000' actn_id,  7 an_st , 0 cnt , 0 sup_amt, 0 amt from dual  \n"+
					 "	union   \n"+
					 "	select '2' car_use , '111111' actn_id,  8 an_st , 0 cnt , 0 sup_amt, 0 amt from dual   \n"+
					 "	union  \n"+
					 "	select  decode(car_use, '1', '1', '2', '2', decode(actn_id, '000000', '2', '111111', '2', '999999', '2', '5') ) car_use, actn_id,   decode(actn_id, '000000', 7, '000502', 1, '013011', 2, '061796', 3, '003226', 4, '011723', 5, '013222', 11, '020385', 6,  '022846',  10, '048691',  11, '111111', 8,  9) an_st,  \n"+
					 "	            sum(1) cnt,    \n"+
					 "	            sum(sup_amt) sup_amt,   \n"+
					 "	        sum(sup_amt - (get_amt + book_dr - jun_reser - dep_amt -gdep_amt  ) ) amt    \n"+
					 "	            from (   \n"+
					 "	              select b.asset_code, b.assch_yy, decode(b.car_use , '1', '1', decode(b.fuel_kd, '3', '5', '5', '5', '6', '5', '2') ) car_use , decode(b.assch_rmk, '폐차', '111111', '매입옵션', '000000', b.actn_id) actn_id,  \n"+
					 "	                      b.get_amt, b.book_dr, b.jun_reser, b.dep_amt, b.gdep_amt , b.sup_amt    \n"+
					 "	               from (   \n"+
					 "	                 select a.asset_code, m.sale_amt, substr(m.assch_date,1,4) assch_yy, a.car_use,   c.fuel_kd,   case when m.assch_rmk like '%폐차%' then '폐차' when m.assch_rmk like '%폐기%' then '폐차'  else m.assch_rmk end assch_rmk,   \n"+
					 "	                    ya.get_amt, ya.book_dr, ya.book_cr, ya.jun_reser, ya.dep_amt, nvl(yg.gdep_amt,0) gdep_amt, nvl (decode( s.actn_id, '003226', '020385', '011723', '020385','013222', '022846', s.actn_id  ) , decode(m.assch_rmk, '매입옵션', '000000', '매각', '111111') )  actn_id,   \n"+
					 "	          case when nvl(m.s_sup_amt, 0)  > 0 then m.s_sup_amt else  case when m.assch_rmk like '%폐%' then m.sale_amt  when m.assch_rmk like '%매각%' then nvl(m.s_sup_amt ,  round(m.sale_amt/1.1) )   when m.assch_rmk like '%매입옵션%' then nvl(m.s_sup_amt, round(m.sale_amt/1.1) )   else 0 end end sup_amt 	  \n"+
					 "	                            from fassetma a,  fassetmove m,     \n"+
					 "	                       ( select a.* from  fyassetdep a, (select asset_code, max(gisu) gisu from fyassetdep group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) ya ,   \n"+
					 "	                       ( select a.* from  fyassetdep_green a, (select asset_code, max(gisu) gisu from fyassetdep_green group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) yg ,    \n"+
					 "	                                 car_reg c, apprsl s    \n"+
					 "	                             where a.asset_code = ya.asset_code  and a.asset_code = yg.asset_code(+)  and a.asset_code = m.asset_code and m.assch_type = '3'   \n"+
					 "	                                and m.assch_date  like   '" + s_yy + s_mm + "%'  \n"+   
					 "	                                and  a.car_mng_id = c.car_mng_id(+) and a.car_mng_id = s.car_mng_id(+)   \n"+
					 "	                 ) b     \n"+
					 "	          ) a     \n"+
					 "	       group by  decode(car_use, '1', '1', '2', '2', decode(actn_id, '000000', '2', '111111', '2', '999999', '2', '5') ) ,  actn_id   \n"+
					 "	 ) d   \n"+
					"	 group by car_use , actn_id , an_st  \n"+
					"	) c   \n"+
					"	order by gubun, car_use, an_st, actn_id        "; 	            
	
		try {
					
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetIncomList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	

	  // 경매낙찰현황-계약정보-재출품수수료 검색.out_amt
	public Hashtable getSearch_auction(String car_mng_id ) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
     
  		  		
		query = " SELECT OUT_AMT*0.1 AS out_amt_vat, OUT_AMT -(OUT_AMT*0.1) AS out_amt_sup, out_amt FROM AUCTION WHERE car_mng_id = '" + car_mng_id + "'";
		  
				try {
					
		    pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getSearch_auction]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return ht;
	}

     
     // 자산II - 세무서보고 차량댓수(자산 - 계산서 기준)
 
         	public Vector getAssetCarStat(String gubun1)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					        
		query = " 	       select gisu||mm mon,  sum(decode(gubun,'1', car_cnt, 0)) b_cnt1,  0  i_cnt1,    0  o_cnt1, sum(decode(gubun,'2', car_cnt, 0)) b_cnt2,  0  i_cnt2,    0  o_cnt2  " +
			     "			    from fasset_car  " +     
			     "			       where gisu like '"+gubun1+"%'" +
			     "			       group by gisu, mm \n  " +     
			     "			   union all    \n  " +     
			     "			   select mon, sum(b_cnt1), sum(i_cnt1), sum(o_cnt1), sum(b_cnt2), sum(i_cnt2), sum(o_cnt2)  " +     
			     "			  from ( \n  " +     
			     "			      select	 substr(get_date, 1, 6) mon ,   0  b_cnt1,  count(decode(car_use,'1', 1)) i_cnt1, 0  o_cnt1,   0  b_cnt2,  count(decode(car_use,'2', 1)) i_cnt2,  0  o_cnt2  " +     
			     "	                             from fassetma   " +     			
			 //    "			                     where  deprf_yn <> '6' and   get_date like '"+gubun1+"%'" +
			      "			                     where   get_date like '"+gubun1+"%'" +
			     "			           group by substr(get_date, 1, 6) " +     
			     "			        union all    " +     
			     "			       select	 substr(b.assch_date, 1, 6) mon ,  0  b_cnt1,    0  i_cnt1,  count(decode(a.car_use,'1', 1)) o_cnt1,    0  b_cnt2,  0  i_cnt2,   count(decode(a.car_use,'2', 1)) i_cnt2   " +     
			     "			                     from fassetma a 	, fassetmove b	  " +     	
			//     "			                     where  a.deprf_yn <> '6' and a.asset_code = b.asset_code and b.assch_type  = '3' and b.assch_date like'"+gubun1+"%'" +
			     "			                     where   a.asset_code = b.asset_code and b.assch_type  = '3' and b.assch_date like'"+gubun1+"%'" +
			     "			           group by substr(b.assch_date, 1, 6)  \n  " +     	
			     "			  ) group by mon  \n " +     	
			     "			  order by 1   ";
				
		try {
				pstmt = con.prepareStatement(query);
			
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
			System.out.println("[AssetDatabase:getAssetCarStat]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}


    // 자산II -  5년기준 자산 
    public Vector getAssetCarStat(String gubun1, String gubun2, String gubun, String gubun_nm )throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            	throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery = "";
		
			/*조회구분*/
		if(!gubun_nm.equals("")){
			if (gubun.equals("car_no")) {
				subQuery += " and c.car_no like '%"+gubun_nm+ "%'";
			} else if (gubun.equals("get_date")) {
				subQuery += " and a.get_date like '%"+gubun_nm+ "%'";
			} else if (gubun.equals("asset_code")) {
				subQuery += " and a.asset_code like '%"+gubun_nm+ "%'";				
			}	
		}
		
		query = " 	 select a.* , b.asset_name ,  case when nvl(m.s_sup_amt, 0)  > 0 then m.s_sup_amt else  case when m.assch_rmk like '%폐%' then m.sale_amt  when m.assch_rmk like '%매각%' then nvl(m.s_sup_amt ,  round(m.sale_amt/1.1) )   when m.assch_rmk like '%매입옵션%' then nvl(m.s_sup_amt, round(m.sale_amt/1.1) )   else 0 end end sup_amt ,  \n "+
		          " t.*  \n " +
			      "	from asset a, fassetma b, car_reg c , ( select * from fassetmove where assch_type = '3'    and assch_date  like '" + gubun1  + "%'  ) m  ,  ass_tax t  \n" +
		               "  where a.asset_code = b.asset_code and b.car_mng_id =  c.car_mng_id(+)   and a.asset_code = m.asset_code(+)  \n " +	
			           "   and b.car_mng_id = t.car_mng_id(+)  \n " +	
		               "  and a.ayear = '" + gubun1 + "' and a.gubun = '" + gubun2 + "'" + subQuery	 + "\n"  +               
		 //              "  order by seq ";
				" order by decode(a.sale_date, null, decode(a.dep_amt, 0 , 5, 2 ) , 6) asc, a.get_date asc ";
		
		try {
				pstmt = con.prepareStatement(query);
				
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
			System.out.println("[AssetDatabase:getAssetCarStat]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

       /**
	 *	차령별 매각 현황
	 */
	public Vector getAssetIncomCarAgeList(String mode, int f_year)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query_in = "";
		
		int f_year_m = f_year -1;	
		
		 query_in = " select a.asset_code, a.car_use, m.assch_date, decode(c.fuel_kd, '3', '1', '5', '1', '6', '1', '2') fuel_kd, \n"+
              			"  decode(c.car_kd,  '4', '1', '5', '1', '6', '2', '7', '2', '8', '2', '3' ) car_kd,  \n"+
              			" TRUNC(MONTHS_BETWEEN(TO_DATE(replace(m.assch_date,'-',''), 'YYYYMMDD'), TO_DATE(replace(decode(a.car_gu, '2', a.dlv_dt, a.get_date),'-',''), 'YYYYMMDD'))) car_age \n"+
			          "             from fassetma a,  fassetmove m, car_reg c    \n"+
			          "               where a.asset_code = m.asset_code and m.assch_type = '3'     \n"+             
			          "               and  a.car_mng_id = c.car_mng_id(+) and m.assch_date > '20121231'      \n"+       
			         	" ";		    
	       
		//리스
		if(mode.equals("1")) 		query_in += " and a.car_use= '1'  \n";

		//렌트
		if(mode.equals("2")) 		query_in += " and a.car_use= '2'  \n";

		//
		query = "      select car_use,   decode( car_use , '1', decode(a.car_kd, '1', '1', '2', '2', '3'), '2',  decode(a.fuel_kd, '1', '4', '2', '5') ) gubun,    \n";       
	
	
		for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){			       	          
				query += " count(decode(to_number(substr(assch_date,1,4)),"+(i)+",asset_code)) cnt"+(i-f_year_m )+", \n";					
		}
		
		for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){			       	          
				query += "nvl( sum(decode(to_number(substr(assch_date,1,4)),"+(i)+",car_age)) , 0) age"+(i-f_year_m )+", \n";			
		}
	
		query += " count(asset_code) cnt0 , sum(car_age) age0 \n"+
				" from   ("+query_in+")  a \n"+
		                  "  group by  a.car_use, decode( a.car_use , '1', decode(a.car_kd, '1', '1', '2', '2', '3'), '2',  decode(a.fuel_kd, '1', '4', '2', '5') )       \n"+
   				"  order by  1, 2	 \n"+
				" ";	
					
			try {
				pstmt = con.prepareStatement(query);
			
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
				System.out.println("[AssetDatabase:getAssetIncomCarAgeList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
		
	/****************************************************************************************
	*******************************************   smart
    ****************************************************************************************/

	//자산매각현황
	public Vector  getAssetSaleList(String s_yy, String s_mm)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
		String search = "";
		String search_dt = "";

		query = " select a.asset_code, a.asset_name, a.get_date, a.get_gubun, a.guant,  a.life_exist, m.sale_amt,  m.assch_date, case when m.assch_rmk like '%폐차%' then '폐차' when m.assch_rmk like '%폐기%' then '폐차'  else m.assch_rmk end assch_rmk , \n" +
		        "        a.depr_method, a.deprf_yn, ya.gisu, ya.get_amt, ya.book_dr, ya.book_cr, ya.jun_reser, ya.dep_amt,  c.car_no, nvl(s.actn_id,'') actn_id , b.firm_nm, round(m.sale_amt/1.1) sup_amt, \n " +
			    "        c.fuel_kd, s.km, decode(c.car_mng_id, sq.car_mng_id, 1, 0) ACCIDENT_YN, \n"+
			    "        TRUNC(MONTHS_BETWEEN(TO_DATE(replace(m.assch_date,'-',''), 'YYYYMMDD'), TO_DATE(replace(a.get_date,'-',''), 'YYYYMMDD'))) use_mon ,  yg.gdep_amt  \n"+
		        " from   fassetma a,  fassetmove m,  \n"+
				"	     ( select a.* from  fyassetdep a, (select asset_code, max(gisu) gisu from fyassetdep group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) ya, \n"+
				"	     ( select a.* from  fyassetdep_green a, (select asset_code, max(gisu) gisu from fyassetdep_green  group by asset_code) b where a.asset_code = b.asset_code and a.gisu = b.gisu ) yg, \n"+
				"	     car_reg c, apprsl s, client b,  \n " +
				"	     (select distinct ac.car_mng_id CAR_MNG_ID from accident ac, car_reg re where ac.car_mng_id=re.car_mng_id) sq \n"+
		       " where a.asset_code = ya.asset_code \n " +
		       "   and a.asset_code = yg.asset_code(+)   \n " +
		      "    and a.asset_code = m.asset_code and m.assch_type = '3' and s.actn_id=b.client_id(+) \n";

		search_dt = "m.assch_date";

		if(!s_yy.equals("") && !s_mm.equals(""))	query += " and "+search_dt+" like '%"+s_yy+s_mm+"%' \n";
		if(!s_yy.equals("") && s_mm.equals(""))		query += " and "+search_dt+" like '%"+s_yy+"%' \n";


		query +="  and  a.car_mng_id = c.car_mng_id(+) and a.car_mng_id = s.car_mng_id(+) and c.car_mng_id = sq.car_mng_id(+) \n" +
				" ";
		        

		query += " order by 8 desc, 18 ";

		 					
		try {
			pstmt = con.prepareStatement(query);
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

		} catch (SQLException e) {
				System.out.println("[AssetDatabase:getAssetSaleList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
	
	
	// 처분된건 제외

	public JSONArray getAssetListJson(String st, String  gubun , String gubun_nm) throws DatabaseException, DataSourceEmptyException
	{
       Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		
		String query = "";
       String subQuery = "";
        
        
      	//  리스 
       	if(st.equals("1")){		subQuery += " and a.car_use='1'";
		//렌트
		}else if(st.equals("2")){	subQuery += " and a.car_use='2'";
	    }    
			//조회구분
		if(!gubun_nm.equals("")){
			if (gubun.equals("car_no")) {
				subQuery += " and c.car_no like '%"+gubun_nm+ "%'";
			} else if (gubun.equals("get_date")) {
				subQuery += " and a.get_date like '%"+gubun_nm+ "%'";
			} else if (gubun.equals("asset_code")) {
				subQuery += " and a.asset_code like '%"+gubun_nm+ "%'";	
			} else {
				subQuery += " and c.car_y_form like '%"+gubun_nm+ "%'";
			}	
		}
			
		query = " select a.asset_code, a.asset_name, a.get_date, a.get_gubun, a.guant,  a.life_exist, a.ndepre_rate, " +
		        "        a.depr_method, a.deprf_yn, ya.gisu, ya.get_amt, ya.book_dr, ya.book_cr, ya.jun_reser, ya.dep_amt,  c.car_no,    m.assch_date ,   " +
		       //    	        	"       case when m.assch_rmk like '%폐%' then m.sale_amt  when m.assch_rmk like '%매각%' then nvl(m.s_sup_amt ,  round(m.sale_amt/1.1) )   when m.assch_rmk like '%매입옵션%' then nvl(m.s_sup_amt, round(m.sale_amt/1.1) )   else 0 end  sup_amt "+	   
		        "   	  case when nvl(m.s_sup_amt, 0)  > 0 then m.s_sup_amt else  case when m.assch_rmk like '%폐%' then m.sale_amt  when m.assch_rmk like '%매각%' then nvl(m.s_sup_amt ,  round(m.sale_amt/1.1) )   when m.assch_rmk like '%매입옵션%' then nvl(m.s_sup_amt, round(m.sale_amt/1.1) )   else 0 end end sup_amt 	 "+	
		         	" from   fassetma a,  ( select * from  fassetmove where assch_type = '3' )  m,    \n " +
				"      ( select * from  fyassetdep  where gisu =  (select  max(gisu) from fyassetdep ) ) ya,  car_reg c " +
		        " where  a.asset_code = ya.asset_code and a.asset_code = m.asset_code(+)  and a.car_mng_id = c.car_mng_id(+)   "+ subQuery + " and a.deprf_yn <> '6'  order by 9 asc, 3 asc ";		        
	    
		 		        				  
	
		try {
		    pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
	    		         	    
    		ResultSetMetaData rsmd = rs.getMetaData();    	
    	
    		while(rs.next())
			{				
				   JSONObject obj = new JSONObject();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 obj.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName));
				}
				jsonArray.add(obj);	
			}
			
			rs.close();
          pstmt.close();
          

		} catch (SQLException e) {
			System.out.println("[AssetDatabase:getAssetList]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return jsonArray;
	}

	
		//그린카 국고보조금 관련  여부	
	public int getGreenCarCount(String asset_code)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
			
		int count = 0;
		String query = "";
			
		query	= " SELECT count(0)  from fassetmove  where asset_code = '"+asset_code+"' and  assch_type = '1' and nvl(MA_CHK, 'N') = 'G' ";
		
		try {
			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();    
	    		
			if(rs.next()){				
				count = rs.getInt(1);
			}
			rs.close();
            pstmt.close();
            
		} catch (SQLException e) {
			System.out.println("[AssetDatabase:getGreenCarCount]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return count;
	}
	
	
	/*
	 *	자산 변동 move 호출 (구매보조금 - 상각관련)
	*/
	public String call_sp_insert_assetmove_green(String s_year, String s_month, String user_id)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	String query = "{CALL P_INSERT_ASSETMOVE_GREEN (?,?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
						
			cstmt = con.prepareCall(query);
					
			cstmt.setString(1, s_year);
			cstmt.setString(2, s_month);
			cstmt.setString(3, user_id);
			cstmt.registerOutParameter( 4, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(4); // 결과값
			cstmt.close();
	
		} catch (SQLException e) {
			System.out.println("[AssetDatabase:call_sp_insert_assetmove_green]"+e);
			sResult = e.getMessage();
			e.printStackTrace();
		} finally {
			try{
            if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		
		return sResult;
	}	
	
	
		//자산 삭제 
	public boolean updateAssetMaDeprf_yn(String asset_code) throws DatabaseException, DataSourceEmptyException{
	
	   Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
     
    		
		boolean flag = true;
		
		PreparedStatement pstmt = null;//자산 master
	
		String query = "";
			
		query = "update fassetma  set  deprf_yn = '6'  "+
				" WHERE asset_code  = ? ";
					        
		try 
		{
			con.setAutoCommit(false);
			
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	asset_code);
			
			pstmt.executeUpdate();
			
		   pstmt.close();
		 		            
			con.commit();
			
	     }catch(SQLException se){
            try{
            	flag = false;
                con.rollback();
                System.out.println(se);
            }catch(SQLException _ignored){}
            
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
            
                if(pstmt != null) pstmt.close();
                                   
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return flag;
    }
	
    /*
	 *	차량대금 끝전 처리
	*/
	public String call_sp_update_assetmaster_deprf_yn(String s_year, String s_month, String user_id)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
    	
    	String query = "{CALL P_UPDATE_assetmaster_deprf_yn (?,?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
						
			cstmt = con.prepareCall(query);
					
			cstmt.setString(1, s_year);
			cstmt.setString(2, s_month);
			cstmt.setString(3, user_id);
			cstmt.registerOutParameter( 4, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(4); // 결과값
			
			cstmt.close();
		
		} catch (SQLException e) {
			System.out.println("[AssetDatabase:call_sp_update_assetmaster_deprf_yn]"+e);
			e.printStackTrace();
		} finally {
			try{
            if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return sResult;
	}
	
	
	 // 자산II -  5년기준 자산  - 폼형식1
    public Vector getAssetCarStat1(String gubun1, String gubun2, String gubun, String gubun_nm )throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            	throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery = "";
		
			/*조회구분*/
		if(!gubun_nm.equals("")){
			if (gubun.equals("car_no")) {
				subQuery += " and c.car_no like '%"+gubun_nm+ "%'";
			} else if (gubun.equals("get_date")) {
				subQuery += " and a.get_date like '%"+gubun_nm+ "%'";
			} else if (gubun.equals("asset_code")) {
				subQuery += " and a.asset_code like '%"+gubun_nm+ "%'";				
			}	
		}
		
		query = " 	 select a.* , b.asset_name, c.car_no , b.deprf_yn   \n "+	
			      "	from asset5 a, fassetma b, car_reg c  \n " +	
		               "  where a.asset_code = b.asset_code and b.car_mng_id =  c.car_mng_id(+)    \n " +		
		               "  and a.gisu = '" + gubun1 + "' and a.gubun = '" + gubun2 + "'" + subQuery	 + "\n"  +   
		     " order by b.deprf_yn asc, a.get_date asc ";
		
		try {
				pstmt = con.prepareStatement(query);
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
			System.out.println("[AssetDatabase:getAssetCarStat]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
			connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}
    
    
    //폐차인 경우에 한해서 reg_dt update
    public int updateAssetMove(String asset_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
                
        query = " UPDATE FASSETMOVE SET "+
				" reg_dt = to_char(sysdate , 'yyyymmdd') "+
				" WHERE asset_code=? and assch_type = '3' and assch_rmk = '폐차' \n";
           
       try{
            con.setAutoCommit(false);
                        
            pstmt = con.prepareStatement(query);  
            
            pstmt.setString(1, asset_code);
            
            count = pstmt.executeUpdate();
             
            pstmt.close();
            con.commit();
        }catch(Exception se){
            try{
				System.out.println("[AssetDatabase:updateAssetMove]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

}

