package cust.pay;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.client.*;
import acar.common.*;
import acar.cont.*;

public class PayDatabase
{
	private Connection conn = null;
	public static PayDatabase db;
	
	public static PayDatabase getInstance()
	{
		if(PayDatabase.db == null)
			PayDatabase.db = new PayDatabase();
		return PayDatabase.db;	
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
		}		
	}



	//세금계산서-----------------------------------------------------------------------------------------------------------------

	//세금계산서 리스트
	public Vector getTaxList(String client_id, String r_site, String s_yy, String s_mm, String s_dd, String s_site, String s_car_no, String s_car_comp_id, String s_car_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
       	query = " select a.*, (a.tax_supply+a.tax_value) tax_amt, nvl(b.firm_nm,b.client_nm) firm_nm,"+
				" decode(a.item_id, '','-', 0,'-', '보기') item_st, nvl(d.print_cnt,0) print_cnt,"+
				" e.pubcode, decode(g.status,'25','수신자미등록','30','수신자미확인','35','수신자미승인','50','수신자승인','60','수신거부','65','수신자발행취소요청','99','발급취소','') status"+
				" from tax a, client b, client_site c,"+
				" (select tax_no, count(*) print_cnt from print_mng group by tax_no) d,"+
				" saleebill e, eb_status f,"+
				" (select a.pubcode, a.status from eb_history a, (select pubcode, max(statusdate) statusdate from eb_history group by pubcode) b where a.pubcode=b.pubcode and a.statusdate=b.statusdate) g"+
				" where a.tax_st='O' and nvl(a.gubun,'1')<>'13'"+//
				" and a.client_id=b.client_id and a.client_id=c.client_id(+) and a.seq=c.seq(+) and a.tax_no=d.tax_no(+)"+
				" and a.resseq=e.resseq(+) and e.pubcode=f.pubcode(+) and f.pubcode=g.pubcode(+)"+
				" and a.client_id='"+client_id+"' ";
	
		if(!r_site.equals(""))							query += " and a.seq='"+r_site+"'";

		if(!s_yy.equals("0") && !s_mm.equals("0"))		query += " and a.tax_dt like '"+s_yy+s_mm+"%'";
		else if(!s_yy.equals("0") && s_mm.equals("0"))	query += " and a.tax_dt like '"+s_yy+"%'";
		if(!s_site.equals(""))							query += " and c.r_site like '%"+s_site+"%'";
		if(!s_car_no.equals(""))						query += " and a.car_no like '%"+s_car_no+"%'";

		query += " order by a.tax_dt desc";

		try 
		{
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		} catch (SQLException e) {
			System.out.println("[PayDatabase:getTaxList]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				rs.close();
				stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	//세금계산서 당일현항
	public Vector getTaxListToday(String client_id, String r_site)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
       	query = " select a.*, (a.tax_supply+a.tax_value) tax_amt, nvl(b.firm_nm,b.client_nm) firm_nm,"+
				" decode(a.item_id, '','-', 0,'-', '보기') item_st, nvl(d.print_cnt,0) print_cnt"+
				" from tax a, client b, client_site c,"+
				" (select tax_no, count(*) print_cnt from print_mng group by tax_no) d"+
				" where a.tax_st='O' and nvl(a.gubun,'1')<>'13' and a.client_id=b.client_id and a.client_id=c.client_id(+) and a.seq=c.seq(+) and a.tax_no=d.tax_no(+)"+
				" and a.client_id='"+client_id+"' and tax_dt like to_char(sysdate,'YYYYMM')||'%'";
	
		if(!r_site.equals(""))							query += " and a.seq='"+r_site+"'";

		query += " order by a.tax_dt desc";

		try 
		{
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		} catch (SQLException e) {
			System.out.println("[PayDatabase:getTaxList]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				rs.close();
				stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	//출력관리 리스트
	public Vector getPrintList(String member_id, String tax_no, String item_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
       	query = " select print_ip, to_char(print_dt,'YYYYMMDDHH24MI') print_dt from print_mng";

		if(!tax_no.equals("")) query+= " where tax_no='"+tax_no+"'";
		if(!item_id.equals("")) query+= " where item_id='"+item_id+"'";


		query +=" order by print_dt desc";

		try 
		{
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		} catch (SQLException e) {
			System.out.println("[PayDatabase:getTaxList]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				rs.close();
				stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	//세금계산서
	public Hashtable getTaxCase(String tax_no)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		

       	query = " select a.*, b.*, c.*,"+
				" decode(a.gubun,'13',b.user_nm,d.firm_nm) firm_nm,"+
				" decode(a.gubun,'13','',d.client_nm) client_nm,"+
				" decode(a.gubun,'13', TEXT_DECRYPT(b.user_ssn, 'pw' ) ,d.enp_no) enp_no,"+
				" decode(a.gubun,'13',b.addr,d.o_addr) o_addr,"+
				" decode(a.gubun,'13','',d.bus_cdt) bus_cdt,"+
				" decode(a.gubun,'13','',d.bus_itm) bus_itm, nvl(d.tm_print_yn,'Y') tm_print_yn "+
				" from tax a, users b, branch c, client d"+
				" where a.client_id=b.user_id(+) and a.branch_g=c.br_id(+) and a.client_id=d.client_id and a.tax_no='"+tax_no+"'";
/*
       	query = " select a.*, c.*, d.*"+
				" from tax a, branch c, client d"+
				" where a.branch_g=c.br_id and a.client_id=d.client_id and a.tax_no like '%"+tax_no+"%'";
*/	
/*       	query = " select a.*, b.*, nvl(c.firm_nm,c.client_nm) firm_nm"+
				" from tax a, branch b, client c"+
				" where a.branch_g=b.br_id and a.client_id=c.client_id and a.tax_no='"+tax_no+"'";
*/

		try 
		{
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
		} catch (SQLException e) {
			System.out.println("[PayDatabase:getTaxCase]\n"+e);
			System.out.println("[PayDatabase:getTaxCase]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				rs.close();
				stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
    }

	//세금계산서
	public Hashtable getTaxAccidCase(String item_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		

       	query = " select a.*, b.*, c.*, d.*, nvl(b.item_dt,to_char(a.reg_dt,'YYYYMMDD')) tax_dt"+
				" from tax_item_list a, tax_item b, users e, branch c, client d"+
				" where a.item_id='"+item_id+"' and a.item_id=b.item_id and b.item_man=e.user_nm and 'S1'=c.br_id(+) and b.client_id=d.client_id  ";
		try 
		{
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
		} catch (SQLException e) {
			System.out.println("[PayDatabase:getTaxAccidCase]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				rs.close();
				stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
    }


	//계약현황 상세내역-계약번호로 조회
	public Hashtable getLongRentCaseH(String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		

		query = " select a.*, c.car_nm||' '||b.car_name car_name, d.p_zip, d.p_addr"+
				" from cont_view a, cont d, car_nm b, car_mng c"+
				" where a.rent_l_cd='"+rent_l_cd+"'"+
				" and a.rent_l_cd=d.rent_l_cd"+
				" and a.car_id=b.car_id and a.car_seq=b.car_seq"+
				" and b.car_comp_id=c.car_comp_id and b.car_cd=c.code";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			if(rs.next())
			{			
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{				
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim()/**/);
				}
			}
		} catch (SQLException e) {
			System.out.println("[PayDatabase:getLongRentCaseH]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				rs.close();
				pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
    }

	//출력관리 등록
    public int insertPrint(String member_id, String print_ip, String print_st, String tax_no, String item_id)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
        String query = "";
        String query1 = "";
		int print_id = 0;
        int count = 0;
		if(member_id.equals("")) member_id="amazoncar";
                
		query = " insert into print_mng(member_id, print_id, print_dt, print_ip, print_st, tax_no, item_id)"+
				" values (?,?,sysdate,?,?,?,?)";

        query1 = " select nvl(max(print_id)+1,1) from print_mng where member_id=?";
		
        try{
            conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query1);
			pstmt1.setString(1, member_id.trim());
			rs = pstmt1.executeQuery();
            if(rs.next())
			{
				print_id = rs.getInt(1);
            }

            pstmt = conn.prepareStatement(query);
			pstmt.setString(1, member_id.trim());
			pstmt.setInt(2, print_id);
			pstmt.setString(3, print_ip.trim());
			pstmt.setString(4, print_st.trim());
			pstmt.setString(5, tax_no.trim());
			pstmt.setString(6, item_id.trim());
            count = pstmt.executeUpdate();

	  	} catch (Exception e) {
			System.out.println("[PayDatabase:insertPrint]\n"+e);
			e.printStackTrace();
		} finally {
			try{	
				rs.close();
				pstmt.close();
	            pstmt1.close();
		        conn.commit();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
    }


	//거래명세서-----------------------------------------------------------------------------------------------------------------

	//거래명세서 리스트
	public Vector getDocList(String client_id, String r_site, String s_yy, String s_mm, String s_dd, String s_site, String s_car_no, String s_car_comp_id, String s_car_cd)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
       	query = " select a.*, nvl(b.firm_nm,b.client_nm) firm_nm, decode(c.r_site,'','', '('||c.r_site||')') r_site,"+
				" decode(d.tax_no, '','-', 0,'-', '보기') tax_st, d.tax_no, nvl(e.print_cnt,0) print_cnt"+
				" from tax_item a, client b, client_site c, tax f,"+
				" (select item_id, min(tax_no) tax_no from tax where tax_st='O' group by item_id having count(*) > 0) d,"+
				" (select item_id, count(*) print_cnt from print_mng group by item_id) e"+
				" where a.client_id=b.client_id and a.client_id=c.client_id(+) and a.seq=c.seq(+)"+
				" and a.item_id=d.item_id(+) and a.item_id=e.item_id(+)"+
				" and a.item_id=f.item_id(+) and nvl(f.tax_st,'O')='O'"+
				" and a.client_id='"+client_id+"' ";
	
		if(!r_site.equals(""))							query += " and a.seq='"+r_site+"'";

		if(!s_yy.equals("0") && !s_mm.equals("0"))		query += " and a.item_dt like '"+s_yy+s_mm+"%'";
		else if(!s_yy.equals("0") && s_mm.equals("0"))	query += " and a.item_dt like '"+s_yy+"%'";
		if(!s_site.equals(""))							query += " and c.r_site like '%"+s_site+"%'";

		query += " order by a.item_id";

		try 
		{
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		} catch (SQLException e) {
			System.out.println("[PayDatabase:getTaxList]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				rs.close();
				stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	//거래명세서
	public Hashtable getDocCase(String item_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";		
       	query = " select a.*, nvl(b.firm_nm,b.client_nm) firm_nm, c.r_site, decode(c.r_site,'','', '('||c.r_site||')') r_site2, nvl(b.tm_print_yn,'Y') tm_print_yn "+
				" from tax_item a, client b, client_site c"+
				" where a.client_id=b.client_id and a.client_id=c.client_id(+) and a.seq=c.seq(+)"+
				" and a.item_id='"+item_id+"' ";
			
		try 
		{
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
		} catch (SQLException e) {
			System.out.println("[PayDatabase:getDocCase]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				rs.close();
				stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}
    }

	//거래명세서 내용 리스트
	public Vector getTaxItemList(String item_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
       	query = " select * from tax_item_list where item_id='"+item_id+"'";
		query += " order by item_seq";

		try 
		{
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		} catch (SQLException e) {
			System.out.println("[PayDatabase:getTaxItemList]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				rs.close();
				stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	//거래명세서 기타 내용 리스트
	public Vector getTaxItemKiList(String item_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
       	query = " select * from tax_item_ki where item_id='"+item_id+"'";
		query += " order by item_ki_seq";

		try 
		{
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
		} catch (SQLException e) {
			System.out.println("[PayDatabase:getTaxItemKiList]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				rs.close();
				stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }


	//인쇄정보--------------------------------------------------------------------------------------------------------------

	//인쇄정보 리스트
	public Vector getPrintList(String s_gubun1, String s_gubun2, String s_gubun3, String s_gubun4, String s_kd, String t_wd, String s_yy, String s_mm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query1 = "";
		String query2 = "";
		String sub_qu = "";
		
		if(s_gubun3.equals("")){

			query1 =" select '1' gubun, a.tax_no, a.item_id, a.client_id, a.seq,"+ 
					" nvl(b.firm_nm,b.client_nm) firm_nm, b.client_nm, c.r_site as r_site_nm, "+ 
					" a.tax_dt as dt, (a.tax_supply+a.tax_value) as amt,"+ 
					" to_char(d.print_dt,'YYYYMMDDHH24MI') as print_dt, d.print_ip, d.member_id"+ 
					" from tax a, client b, client_site c, print_mng d,"+ 
					" (select tax_no, max(print_dt) print_dt from print_mng where print_st='1' group by tax_no) e"+ 
					" where a.client_id=b.client_id"+ 
					" and a.client_id=c.client_id(+) and a.seq=c.seq(+)"+ 
					" and a.tax_no=e.tax_no(+)"+ 
					" and e.tax_no=d.tax_no(+) and e.print_dt=d.print_dt(+)";

			query2 =" select '2' gubun, '' tax_no, a.item_id, a.client_id, a.seq,"+ 
					" nvl(b.firm_nm,b.client_nm) firm_nm, b.client_nm, c.r_site as r_site_nm, "+ 
					" a.item_dt as dt, (a.item_hap_num) as amt,"+ 
					" to_char(d.print_dt,'YYYYMMDDHH24MI') as print_dt, d.print_ip, d.member_id"+ 
					" from tax_item a, client b, client_site c, print_mng d,"+ 
					" (select item_id, max(print_dt) print_dt from print_mng where print_st='2' group by item_id) e"+ 
					" where a.client_id=b.client_id"+ 
					" and a.client_id=c.client_id(+) and a.seq=c.seq(+)"+ 
					" and a.item_id=e.item_id(+)"+ 
					" and e.item_id=d.item_id(+) and e.print_dt=d.print_dt(+)";

		}else{

			query1 =" select '1' gubun, a.tax_no, a.item_id, a.client_id, a.seq,"+ 
					" nvl(b.firm_nm,b.client_nm) firm_nm, b.client_nm, c.r_site as r_site_nm, "+ 
					" a.tax_dt as dt, (a.tax_supply+a.tax_value) as amt,"+ 
					" to_char(d.print_dt,'YYYYMMDDHH24MI') as print_dt, d.print_ip, d.member_id"+ 
					" from tax a, client b, client_site c, print_mng d,"+ 
					" (select tax_no, max(print_dt) print_dt from print_mng where print_st='1' group by tax_no) e,"+ 
					" (select client_id from cont where bus_id2='"+s_gubun3+"' group by client_id) g"+
					" where a.client_id=b.client_id"+ 
					" and a.client_id=c.client_id(+) and a.seq=c.seq(+)"+ 
					" and a.tax_no=e.tax_no(+)"+ 
					" and e.tax_no=d.tax_no(+) and e.print_dt=d.print_dt(+)"+
					" and a.client_id=g.client_id";

			query2 =" select '2' gubun, '' tax_no, a.item_id, a.client_id, a.seq,"+ 
					" nvl(b.firm_nm,b.client_nm) firm_nm, b.client_nm, c.r_site as r_site_nm, "+ 
					" a.item_dt as dt, (a.item_hap_num) as amt,"+ 
					" to_char(d.print_dt,'YYYYMMDDHH24MI') as print_dt, d.print_ip, d.member_id"+ 
					" from tax_item a, client b, client_site c, print_mng d,"+ 
					" (select item_id, max(print_dt) print_dt from print_mng where print_st='2' group by item_id) e,"+ 
					" (select client_id from cont where bus_id2='"+s_gubun3+"' group by client_id) g"+
					" where a.client_id=b.client_id"+ 
					" and a.client_id=c.client_id(+) and a.seq=c.seq(+)"+ 
					" and a.item_id=e.item_id(+)"+ 
					" and e.item_id=d.item_id(+) and e.print_dt=d.print_dt(+)"+
					" and a.client_id=g.client_id";

		}

		query = "select * from ("+query1 +" union all "+query2+")";


		if(s_gubun1.equals("1"))		query += " where gubun='1'";
		else if(s_gubun1.equals("2"))	query += " where gubun='2'";

		if(s_gubun2.equals("Y"))		query += " and print_dt is not null";
		else if(s_gubun2.equals("N"))	query += " and print_dt is null";

		if(!s_yy.equals("") && !s_mm.equals(""))		query += " and dt like '"+s_yy+s_mm+"%'";
		else if(!s_yy.equals("") && s_mm.equals(""))	query += " and dt like '"+s_yy+"%'";

		if(s_kd.equals("1"))		query += " and firm_nm||client_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("2"))	query += " and client_nm like '%"+t_wd+"%'";
		else if(s_kd.equals("3"))	query += " and member_id like '%"+t_wd+"%'";

		query +=" ORDER BY print_dt, dt, firm_nm||client_nm, nvl(seq,'0')";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim()/**/);
				}
				vt.add(ht);	
			}
		} catch (SQLException e) {
			System.out.println("[PayDatabase:getPrintList]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				rs.close();
				pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }
    
     	/*   -----------------------------------------------------------------------------------  mobile  -------------------------------------------------------------------------------------------------------------------------------------------------------- */
        
    //계약현황 리스트 - 대차료 제외 20100120
	public Vector getTaxList2(String client_id, String r_site, String s_yy, String s_mm, String s_dd, String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";	
		String search = "";
		String search_dt = "";
		
		query = " select"+
				" a.tax_no, a.tax_dt, a.tax_g, a.tax_supply, a.tax_value, (a.tax_supply+a.tax_value) tax_amt, a.tax_bigo,"+
				" decode(a.unity_chk,'1','통합',decode(a.gubun,'1',a.fee_tm||'회','-')) fee_tm,"+
				" decode(c.status,'25','수신자미등록','30','수신자미확인','35','수신자미승인','50','수신자승인','60','수신거부','65','수신자발행취소요청','99','발급취소',decode(b.pubcode,'','대기','수신자미확인')) status,"+
				" decode(a.tax_type,'2',e.enp_no,decode(d.client_st,'2', TEXT_DECRYPT(d.ssn, 'pw' )  ,d.enp_no)) enp_no,"+
				" a.client_id, a.seq, a.tax_type, a.item_id, a.resseq, b.pubcode, "+
				" a.reg_dt, a.fee_tm as tm, a.gubun "+
				" from tax a, saleebill b,"+
				" (select a.pubcode, a.status from eb_history a, (select pubcode, max(statusdate) statusdate from eb_history where status not in ('11','14') group by pubcode) b where a.status not in ('11','14') and a.pubcode=b.pubcode and a.statusdate=b.statusdate) c,"+
				" client d, client_site e"+
				" where nvl(a.gubun,'1') not in ('13')  and a.tax_st<>'C' and a.client_id='"+client_id+"'"+//20100419 대차료 제외 해제:이세로를 통한 문의옴
				" and a.resseq=b.resseq(+) and b.pubcode=c.pubcode(+)"+
				" and a.client_id=d.client_id and a.client_id=e.client_id(+) and a.seq=e.seq(+) and nvl(a.rent_l_cd,'1')<>'A'";

		if(!r_site.equals(""))		query += " and a.seq='"+r_site+"'";

		if(gubun1.equals("1"))		search_dt = "a.tax_dt";

		//기간검색
		if(gubun2.equals("1"))		query += " and "+search_dt+" = to_char(sysdate,'YYYYMMDD')";
		if(gubun2.equals("2"))		query += " and "+search_dt+" like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun2.equals("3"))		query += " and "+search_dt+" like to_char(sysdate,'YYYY')||'%'";
		if(gubun2.equals("4")){
			if(!s_yy.equals("") && !s_mm.equals(""))	query +=" and "+search_dt+" between replace( '"+s_yy+"' , '-', '')  and  replace('"+s_mm+"' , '-', '')  ";
			if(!s_yy.equals("") && s_mm.equals(""))		query += " and "+search_dt+" like '"+s_yy+"%'";
		}

		if(s_kd.equals("1"))		search = " a.tax_no";
		else if(s_kd.equals("2"))	search = " a.tax_g";
		else if(s_kd.equals("3"))	search = " a.tax_bigo";

		if(!t_wd.equals(""))		query += " and "+search+" like '%"+t_wd+"%'";
			
		if(asc.equals("0"))			query += " order by a.tax_dt desc, a.resseq desc, "+search+" asc ";
		if(asc.equals("1"))			query += " order by a.tax_dt desc, a.resseq desc, "+search+" desc ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[LongRentDatabase:getTaxList2]\n"+e);
			System.out.println("[LongRentDatabase:getTaxList2]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null)		rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	 
	 
	 // 면책금 cms 관련 내용 리스트 - 출금일
	
	public String getTaxItemCmsCustDt(String item_id)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String cms_cust_dt = "";
		String query = "";	
		
			
       	query = " select s.cust_plan_dt from tax_item_list t, cont a, cust c, client cc, service s  where t.gubun = '7' and  t.item_id='"+item_id+"'" +
       	        " and  t.rent_l_cd = a.rent_l_cd and a.rent_l_cd = c.code and a.client_id = cc.client_id and  c.cbit = '2' " +
       	        " and  nvl(cc.etc_cms, 'Y') = 'Y' and t.item_dt = s.cust_req_dt and t.rent_l_cd = s.rent_l_cd and rownum = 1 " ;
       	        	
		try{
				stmt = conn.createStatement();
	    		rs = stmt.executeQuery(query);
	    					
	            if(rs.next())
	            {
				    cms_cust_dt = rs.getString(1);
	            }
				rs.close();
				stmt.close();
	
		} catch (Exception e) {
				System.out.println("[PayDatabase:getTaxItemCmsCustDt]\n"+e);
				System.out.println("[PayDatabase:getTaxItemCmsCustDt]\n"+query);
				e.printStackTrace();
		} finally {
				try{	
					if(rs != null)		rs.close();
					if(stmt != null)	stmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return cms_cust_dt;
		}
    }
    
    	//tax_no 조회
   public String getTaxNoItemId(String item_id)
	{
		getConnection();
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        String tax_no = "";
                
		query = " select tax_no from tax where item_id='"+item_id+"'";
		
        try{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
            if(rs.next())
            {
			    tax_no = rs.getString(1);
            }
			rs.close();
			pstmt.close();

	  	} catch (Exception e) {
			System.out.println("[PayDatabase:getTaxNoItemId]\n"+e);
			System.out.println("[PayDatabase:getTaxNoItemId]\n"+query);
			e.printStackTrace();
		} finally {
			try{	
				if(rs != null)		rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return tax_no;
		}
    }


		//거래명세서 계약현황 리스트 - 대차료 제외 20100120 휴차료 제외 20100225
	public Vector getDocList2(String client_id, String r_site, String s_yy, String s_mm, String s_dd, String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String sort, String asc)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";	
		String search = "";
		String search_dt = "";
		
		query = " select"+
				"        a.client_id, a.seq,"+
				"        a.item_id, a.item_dt, decode(a.seq,'',nvl(c.enp_no,TEXT_DECRYPT(c.ssn, 'pw' ) ),nvl(d.enp_no,nvl(c.enp_no,TEXT_DECRYPT(c.ssn, 'pw' ) ))) enp_no,"+
				"        c.firm_nm, d.r_site, a.item_hap_num, b.item_g||decode(b.cnt,1,'','외'||b.cnt||'건') item_g,"+
				"        e.tax_no, s.resseq, s.pubcode "+
				" from   tax_item a,"+
				"        ( select item_id, count(item_id) cnt, min(nvl(item_car_no,rent_l_cd)||' '||item_g) item_g, max(gubun) gubun "+
				"          from   tax_item_list "+
				"          where  item_g not in ('대차료','휴차료') "+
				"          and nvl(gubun,'1') not in ('13') "+
				"          group by item_id) b,"+
				"        client c, client_site d, tax e, saleebill s "+
				" where"+
				"        a.client_id='"+client_id+"'"+
				"        and nvl(a.use_yn,'Y')='Y'"+
				"        and a.item_id=b.item_id"+
				"        and a.client_id=c.client_id"+
				"        and a.client_id=d.client_id(+) and a.seq=d.seq(+)"+
				"        and a.item_id=e.item_id(+)  "+//and nvl(e.gubun,'0') not in ('11') //20100419 대차료 제외 해제 : 이세로를 통한 문의
				"        and e.resseq=s.resseq(+) "+
//				"        and (nvl(e.tax_st,'0')='O' or b.gubun='12')"+
				" ";

		if(!r_site.equals(""))		query += " and a.seq='"+r_site+"'";

		if(gubun1.equals("1"))		search_dt = "a.item_dt";

		//기간검색
		if(gubun2.equals("1"))		query += " and "+search_dt+" = to_char(sysdate,'YYYYMMDD')";
		if(gubun2.equals("2"))		query += " and "+search_dt+" like to_char(sysdate,'YYYYMM')||'%'";
		if(gubun2.equals("3"))		query += " and "+search_dt+" like to_char(sysdate,'YYYY')||'%'";
		if(gubun2.equals("4")){
			if(!s_yy.equals("") && !s_mm.equals(""))	query += " and "+search_dt+" between replace( '"+s_yy+"' , '-', '')  and  replace('"+s_mm+"' , '-', '')  ";
			if(!s_yy.equals("") && s_mm.equals(""))		query += " and "+search_dt+" like '"+s_yy+"%'";
		}

		if(s_kd.equals("1"))		search = " a.item_id";
		else if(s_kd.equals("2"))	search = " d.r_site";
		else if(s_kd.equals("3"))	search = " b.item_g";

		if(!t_wd.equals(""))		query += " and "+search+" like '%"+t_wd+"%'";
			
		if(asc.equals("0"))			query += " order by "+search+" asc ";
		if(asc.equals("1"))			query += " order by "+search+" desc ";

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
			{				
				Hashtable ht = new Hashtable();
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[PayDatabase:getDocList2]\n"+e);
			System.out.println("[PayDatabase:getDocList2]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null)		rs.close();
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }


    

}