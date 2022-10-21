package acar.biz_partner;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.common.*;
import oracle.jdbc.*;
import oracle.sql.*;

public class BizPartnerDatabase
{
	private Connection conn = null;
	public static BizPartnerDatabase db;
	
	public static BizPartnerDatabase getInstance()
	{
		if(BizPartnerDatabase.db == null)
			BizPartnerDatabase.db = new BizPartnerDatabase();
		return BizPartnerDatabase.db;
	}	
	

 	private DBConnectionManager connMgr = null;

    private void getConnection()
    {
    	try
    	{
	    	if(connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if(conn == null)
	        	conn = connMgr.getConnection("ebank");				
	    }catch(Exception e){
	    	System.out.println(" i can't get a connection........");
	    }
	}
	
	private void closeConnection()
	{
		if ( conn != null ) 
		{
			connMgr.freeConnection("ebank", conn);
			conn = null;
		}		
	}


	public boolean insertErpTrans(ErpTransBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;

		int tran_dt_seq = 0;
		int tran_cnt = 0;

		String query1 = " select nvl(max(tran_dt_seq)+1,1) as tran_dt_seq from ebank.erp_trans where tran_dt=replace(?,'-','')";

		String query2 = " select nvl(max(tran_cnt)+1,0) as tran_cnt from ebank.erp_trans where actseq=?";

		String query3 = " insert into ebank.erp_trans "+
						" ( "+
						"		 tran_dt, tran_cnt, tran_dt_seq, biz_reg_no, "+
						"        out_bank_id, out_acct_no, comp_name, user_id, user_name, out_bank_name, "+
						"        in_bank_id, in_bank_name, in_acct_no, receip_owner_name, "+
						"        tran_amt, remark, out_acct_memo, in_acct_memo, cms_code, "+
						"        actseq, err_code "+
						" )"+
						" values"+
						" ("+
						"        replace(?,'-',''), ?, ?, replace(?,'-',''), "+
						"        ?, replace(?,'-',''), ?, ?, ?, ?, "+
						"        ?, ?, replace(?,'-',''), ?, "+
						"        ?, ?, ?, ?, ?, "+
						"        ?, '000'  "+
						" )";

		try 
		{

			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString(1,	bean.getTran_dt());
	    	rs1 = pstmt1.executeQuery();
			if(rs1.next())
			{
				tran_dt_seq = rs1.getInt(1);
			}
			rs1.close();
			pstmt1.close();

			pstmt3 = conn.prepareStatement(query2);
			pstmt3.setString(1,	bean.getActseq());
	    	rs2 = pstmt3.executeQuery();
			if(rs2.next())
			{
				tran_cnt = rs2.getInt(1);
			}
			rs2.close();
			pstmt3.close();


			pstmt2 = conn.prepareStatement(query3);
			pstmt2.setString(1,  bean.getTran_dt            ());
			pstmt2.setInt   (2,  tran_cnt                     );
			pstmt2.setInt   (3,  tran_dt_seq                  );
			pstmt2.setString(4,  bean.getBiz_reg_no			());
			pstmt2.setString(5,  bean.getOut_bank_id		());
			pstmt2.setString(6,  bean.getOut_acct_no		());
			pstmt2.setString(7,  bean.getComp_name			());
			pstmt2.setString(8,  bean.getUser_id			());
			pstmt2.setString(9,  bean.getUser_name			());
			pstmt2.setString(10, bean.getOut_bank_name		());
			pstmt2.setString(11, bean.getIn_bank_id			());
			pstmt2.setString(12, bean.getIn_bank_name		());
			pstmt2.setString(13, bean.getIn_acct_no			());
			pstmt2.setString(14, bean.getReceip_owner_name	());
			pstmt2.setInt   (15, bean.getTran_amt			());
			pstmt2.setString(16, bean.getRemark				());
			pstmt2.setString(17, bean.getOut_acct_memo		());
			pstmt2.setString(18, bean.getIn_acct_memo		());
			pstmt2.setString(19, bean.getCms_code			());
			pstmt2.setString(20, bean.getActseq				());

		    pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();
			

	  	} catch (Exception e) {
			System.out.println("[BizPartnerDatabase:insertErpTrans]"+ e);

			System.out.println("[bean.getTran_dt            ()]"+ bean.getTran_dt           ());
			System.out.println("[tran_cnt                     ]"+ tran_cnt                    );
			System.out.println("[tran_dt_seq                  ]"+ tran_dt_seq                 );
			System.out.println("[bean.getBiz_reg_no			()]"+ bean.getBiz_reg_no		());
			System.out.println("[bean.getOut_bank_id		()]"+ bean.getOut_bank_id		());
			System.out.println("[bean.getOut_acct_no		()]"+ bean.getOut_acct_no		());
			System.out.println("[bean.getComp_name			()]"+ bean.getComp_name			());
			System.out.println("[bean.getUser_id			()]"+ bean.getUser_id			());
			System.out.println("[bean.getUser_name			()]"+ bean.getUser_name			());
			System.out.println("[bean.getOut_bank_name		()]"+ bean.getOut_bank_name		());
			System.out.println("[bean.getIn_bank_id			()]"+ bean.getIn_bank_id		());
			System.out.println("[bean.getIn_bank_name		()]"+ bean.getIn_bank_name		());
			System.out.println("[bean.getIn_acct_no			()]"+ bean.getIn_acct_no		());
			System.out.println("[bean.getReceip_owner_name	()]"+ bean.getReceip_owner_name	());
			System.out.println("[bean.getTran_amt			()]"+ bean.getTran_amt			());
			System.out.println("[bean.getRemark				()]"+ bean.getRemark			());
			System.out.println("[bean.getOut_acct_memo		()]"+ bean.getOut_acct_memo		());
			System.out.println("[bean.getIn_acct_memo		()]"+ bean.getIn_acct_memo		());
			System.out.println("[bean.getCms_code			()]"+ bean.getCms_code			());
			System.out.println("[bean.getActseq				()]"+ bean.getActseq			());

	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
                if(rs1 != null )		rs1.close();
                if(rs2 != null )		rs2.close();
           		if(pstmt1 != null)		pstmt1.close();
				if(pstmt2 != null)		pstmt2.close();
				if(pstmt3 != null)		pstmt3.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}

	public boolean updateErpTransAct(ErpTransBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = " update ebank.erp_trans set "+
						"		 out_acct_no		=replace(?,'-',''), "+
						"        in_bank_id			=?, "+
						"        in_bank_name		=?, "+
						"        in_acct_no			=replace(?,'-',''),	"+
						"        receip_owner_name	=?, "+
						"        in_acct_memo		=?, "+
						"        cms_code			=?, "+
						"        tran_amt			=?, "+
						"        out_bank_id		=?, "+
						"        out_bank_name		=?  "+
						"        "+
						" where actseq = ?"+
						" ";

		try 
		{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  bean.getOut_acct_no			().trim());
			pstmt.setString(2,  bean.getIn_bank_id			());
			pstmt.setString(3,  bean.getIn_bank_name		());
			pstmt.setString(4,  bean.getIn_acct_no			().trim());
			pstmt.setString(5,  bean.getReceip_owner_name	());
			pstmt.setString(6,  bean.getIn_acct_memo		());
			pstmt.setString(7,  bean.getCms_code			());
			pstmt.setInt   (8,  bean.getTran_amt			());
			pstmt.setString(9,  bean.getOut_bank_id			());
			pstmt.setString(10, bean.getOut_bank_name		());
			pstmt.setString(11, bean.getActseq				());

		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
			

	  	} catch (Exception e) {
			System.out.println("[BizPartnerDatabase:updateErpTransAct]"+ e);

			System.out.println("[bean.getOut_acct_no		()]"+ bean.getOut_acct_no		());
			System.out.println("[bean.getIn_bank_id			()]"+ bean.getIn_bank_id		());
			System.out.println("[bean.getIn_bank_name		()]"+ bean.getIn_bank_name		());
			System.out.println("[bean.getIn_acct_no			()]"+ bean.getIn_acct_no		());
			System.out.println("[bean.getReceip_owner_name	()]"+ bean.getReceip_owner_name	());
			System.out.println("[bean.getIn_acct_memo		()]"+ bean.getIn_acct_memo		());
			System.out.println("[bean.getCms_code			()]"+ bean.getCms_code			());
			System.out.println("[bean.getTran_amt			()]"+ bean.getTran_amt			());
			System.out.println("[bean.getActseq				()]"+ bean.getActseq			());

	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
           		if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}

	public boolean deleteErpTransAct(String actseq)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = " delete from ebank.erp_trans "+
					   " where actseq = ? and err_code<>'005' "+
					   " ";
		try 
		{

			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1,  actseq);

		    pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
			

	  	} catch (Exception e) {
			System.out.println("[BizPartnerDatabase:deleteErpTransAct]"+ e);
			System.out.println("[BizPartnerDatabase:deleteErpTransAct]"+ query);
			System.out.println("[BizPartnerDatabase:deleteErpTransAct]"+ actseq);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
           		if(pstmt != null)		pstmt.close();
			}catch(Exception ignore){}			
				closeConnection();
			return flag;
		}			
	}

	public ErpTransBean getErpTransCase(String actseq)
	{
		getConnection();
		ErpTransBean bean = new ErpTransBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"";

		query = " select * from erp_trans where actseq=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString   (1, actseq);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next()){
				bean.setTran_dt				(rs.getString(1)==null?"":rs.getString(1));
				bean.setTran_cnt			(rs.getInt   (2));
				bean.setTran_dt_seq			(rs.getInt   (3));
				bean.setBiz_reg_no			(rs.getString(4) ==null?"":rs.getString(4));
				bean.setOut_bank_id			(rs.getString(5) ==null?"":rs.getString(5));
				bean.setOut_acct_no			(rs.getString(6) ==null?"":rs.getString(6));
				bean.setComp_name			(rs.getString(7) ==null?"":rs.getString(7));
				bean.setUser_id				(rs.getString(8) ==null?"":rs.getString(8));
				bean.setUser_name			(rs.getString(9) ==null?"":rs.getString(9));
				bean.setOut_bank_name		(rs.getString(10)==null?"":rs.getString(10));
				bean.setIn_bank_id			(rs.getString(11)==null?"":rs.getString(11));
				bean.setIn_bank_name		(rs.getString(12)==null?"":rs.getString(12));
				bean.setIn_acct_no			(rs.getString(13)==null?"":rs.getString(13));
				bean.setReceip_owner_name	(rs.getString(14)==null?"":rs.getString(14));
				bean.setTran_amt			(rs.getInt   (15));
				bean.setTran_fee			(rs.getInt   (16));
				bean.setTran_remain			(rs.getInt   (17));
				bean.setTran_tm				(rs.getString(18)==null?"":rs.getString(18));
				bean.setRemark				(rs.getString(19)==null?"":rs.getString(19));
				bean.setOut_acct_memo		(rs.getString(20)==null?"":rs.getString(20));
				bean.setIn_acct_memo		(rs.getString(21)==null?"":rs.getString(21));
				bean.setCms_code			(rs.getString(22)==null?"":rs.getString(22));
				bean.setErr_code			(rs.getString(23)==null?"":rs.getString(23));
				bean.setErr_reason			(rs.getString(24)==null?"":rs.getString(24));
				bean.setActseq				(rs.getString(25)==null?"":rs.getString(25));
            }
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[BizPartnerDatabase:getErpTransCase]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}

/*
	public ErpTransBean getErpTransCase(String actseq, String tran_dt, String tran_cnt, String tran_dt_seq)
	{
		getConnection();
		ErpTransBean bean = new ErpTransBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = 	"";

		query = " select * from erp_trans where actseq=? and tran_dt=? and tran_cnt=? and tran_dt_seq=? ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString   (1, actseq);
			pstmt.setString   (2, tran_dt);
			pstmt.setString   (3, tran_cnt);
			pstmt.setString   (4, tran_dt_seq);
	    	rs = pstmt.executeQuery();
    	
			if(rs.next()){
				bean.setTran_dt				(rs.getString(1)==null?"":rs.getString(1));
				bean.setTran_cnt			(rs.getInt   (2));
				bean.setTran_dt_seq			(rs.getInt   (3));
				bean.setBiz_reg_no			(rs.getString(4) ==null?"":rs.getString(4));
				bean.setOut_bank_id			(rs.getString(5) ==null?"":rs.getString(5));
				bean.setOut_acct_no			(rs.getString(6) ==null?"":rs.getString(6));
				bean.setComp_name			(rs.getString(7) ==null?"":rs.getString(7));
				bean.setUser_id				(rs.getString(8) ==null?"":rs.getString(8));
				bean.setUser_name			(rs.getString(9) ==null?"":rs.getString(9));
				bean.setOut_bank_name		(rs.getString(10)==null?"":rs.getString(10));
				bean.setIn_bank_id			(rs.getString(11)==null?"":rs.getString(11));
				bean.setIn_bank_name		(rs.getString(12)==null?"":rs.getString(12));
				bean.setIn_acct_no			(rs.getString(13)==null?"":rs.getString(13));
				bean.setReceip_owner_name	(rs.getString(14)==null?"":rs.getString(14));
				bean.setTran_amt			(rs.getInt   (15));
				bean.setTran_fee			(rs.getInt   (16));
				bean.setTran_remain			(rs.getInt   (17));
				bean.setTran_tm				(rs.getString(18)==null?"":rs.getString(18));
				bean.setRemark				(rs.getString(19)==null?"":rs.getString(19));
				bean.setOut_acct_memo		(rs.getString(20)==null?"":rs.getString(20));
				bean.setIn_acct_memo		(rs.getString(21)==null?"":rs.getString(21));
				bean.setCms_code			(rs.getString(22)==null?"":rs.getString(22));
				bean.setErr_code			(rs.getString(23)==null?"":rs.getString(23));
				bean.setErr_reason			(rs.getString(24)==null?"":rs.getString(24));
				bean.setActseq				(rs.getString(25)==null?"":rs.getString(25));
            }
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[BizPartnerDatabase:getErpTransCase]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return bean;
		}
	}
*/

	public Vector getErpDemandCurrentList(String s_clsfy, String s_kd, String t_wd, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		
		query = "select a.bank_id, a.tran_clsfy, a.remark, a.erp_fms_yn, a.bank_name, a.acct_num,  b.bank_nm, b.bank_no, a.tran_date, a.tran_date_seq, a.tran_content, decode(a.tran_clsfy, '1', a.tran_amt, 0) ip_amt, decode(a.tran_clsfy, '1', 0, a.tran_amt) out_amt , a.tran_remain, a.tran_branch, a.erp_fms_yn \n"+
				" from EBANK.ERP_DEMAND_CURRENT a, amazoncar.erp_bank  b  \n"+
				" where a.tran_date > '20100308' and  a.bank_id = b.bank_id(+) and a.acct_num = b.acct_num(+) and a.acct_num <> '140007754041'  ";

		if(s_kd.equals("1"))			query += " and a.tran_date like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))		query += " and a.bank_name like '%"+t_wd+"%'";
	
		query += " order by  a.bank_id, a.acct_num, a.tran_date, a.tran_date_seq";

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
			System.out.println("[BizPartnerDatabase:getErpDemandCurrentList]\n"+e);			
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
	
	/* 신한 집금 처리 완료등록  - 1 :해당건 처리, 3:카드사입금처리 4:보험사환급처리
     */
     
    public boolean updateDemandErpFmsYn(String bank_id, String acct_num, String tran_dt , String tran_seq) 
    {
      	getConnection();
        PreparedStatement pstmt = null;
        String query = "";
        boolean flag = true;
 		                
        query = " update EBANK.ERP_DEMAND_CURRENT set erp_fms_yn = 'Y'  where bank_id = ? and acct_num = ? and tran_date = replace(?, '-', '') and tran_date_seq = ? ";			 
         
       try{
            conn.setAutoCommit(false);
           
            pstmt = conn.prepareStatement(query);            
            pstmt.setString(1, bank_id	);               
            pstmt.setString(2, acct_num	);
            pstmt.setString(3, tran_dt	);               
            pstmt.setString(4, tran_seq	);
                   
            pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

    
    	} catch (Exception e) {
    		System.out.println("[BizPartnerDatabase:updateDemandErpFmsYn]\n"+e);
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
	
}
