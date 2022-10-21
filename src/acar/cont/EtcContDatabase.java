package acar.cont;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.client.*;
import acar.car_office.*;
import acar.common.*;
import acar.util.*;

public class EtcContDatabase
{
	private Connection conn = null;
	public static ContDatabase db;
	
	public static ContDatabase getInstance()
	{
		if(ContDatabase.db == null)
			ContDatabase.db = new ContDatabase();
		return ContDatabase.db;	
	}	
	

 	private DBConnectionManager connMgr = null;

    private void getConnection()
    {
    	try
    	{
	    	if(connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if(conn == null)
			{
	        	conn = connMgr.getConnection("acar");
	        }
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


	/**
	 *	������������Ʈ
	 *	s_kd - 1:������ȣ , 2:����, 3:�����ڵ�
	 */
	public Vector getExistingCarList(String s_kd, String t_wd, String car_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+  merge(a) */ "+
				"        b.car_no, a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.car_nm, c.car_name, c.car_comp_id, nvl(b.off_ls,'0') off_ls,"+
				"        decode(b.prepare,'4','-','5','-','6','-', decode(i.rent_st,'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','��������','6','��������','7','��������','8','������','11','�����','12','����Ʈ', '-') ) rent_st_nm,"+
				"        decode(i.cust_st, '', '', '1',replace(l.firm_nm,'(��)',''), '4','�Ƹ���ī '||j.user_nm) cust_nm, decode(i.car_mng_id,'','',nvl(substr(i.deli_dt,1,8),'����')) deli_dt, substr(i.ret_dt,1,8) ret_dt"+
				" from   cont_n_view a, car_reg b, car_nm c, car_etc g,"+
				"        (select a.* from rent_cont a, (select car_mng_id, max(nvl(deli_dt,decode(use_st,'1','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b where a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and nvl(a.deli_dt,decode(a.use_st,'1','0000000000',a.deli_plan_dt))=b.deli_dt) i, client l, users j, "+
				"        (select car_mng_id from cont where nvl(use_yn,'Y')='Y' and car_st in ('1','3') group by car_mng_id) d "+
				" where  nvl(a.use_yn,'Y')='Y' and a.car_st='2' and nvl(b.off_ls,'0') not in ('5','6')"+
				"        and a.car_mng_id=b.car_mng_id  "+
				"	and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=c.car_id(+)  and    g.car_seq=c.car_seq(+)   \n"+
                       		"        and a.car_mng_id=i.car_mng_id(+) and i.cust_id=l.client_id(+) and i.cust_id=j.user_id(+)"+
				"        and a.car_mng_id=d.car_mng_id(+) and d.car_mng_id is null ";

		if(!car_cd.equals("")) query += " and c.car_cd='"+car_cd+"'";

		if(s_kd.equals("1"))	query += " and b.car_no like '%"+t_wd+"%'";
		if(s_kd.equals("2"))	query += " and b.car_nm||c.car_name like upper('%"+t_wd+"%')";
		if(s_kd.equals("3"))	query += " and decode(i.cust_st, '', '', '1',replace(l.firm_nm,'(��)',''), '4','�Ƹ���ī') like upper('%"+t_wd+"%')";
		if(s_kd.equals("4"))	query += " and decode(b.prepare,'4','-','5','-','6','-', decode(i.rent_st,'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','��������','6','��������','7','��������','8','������','11','�����','12','����Ʈ', '-') ) like upper('%"+t_wd+"%')";

		query += " order by b.car_no";

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
	 *	������������Ʈ
	 *	s_kd - 1:������ȣ , 2:����, 3:�����ڵ�
	 */
	public Vector getExistingCarList(String s_kd, String t_wd, String car_cd, String car_gu)
	{		
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+  merge(a) */ "+
				"        b.car_no, a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.car_nm, c.car_name, c.car_comp_id, nvl(b.off_ls,'0') off_ls, b.maint_st_dt, b.maint_end_dt, TRUNC(to_number(to_date(substr(b.maint_end_dt, 0,4) || substr(b.init_reg_dt, 5, 8),'YYYYMMDD')-sysdate)) AS maint_est_days, b.prepare, b.ncar_spe_dc_amt, "+
				"        decode(b.prepare,'4','-','5','-','6','-', decode(i.rent_st,'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','��������','6','��������','7','��������','8','������','11','�����','12','����Ʈ', '-') ) rent_st_nm,"+
				"        decode(i.cust_st, '', '', '1',replace(l.firm_nm,'(��)',''), '4','�Ƹ���ī '||j.user_nm) cust_nm, decode(i.car_mng_id,'','',nvl(substr(i.deli_dt,1,8),'����')) deli_dt, substr(i.ret_dt,1,8) ret_dt"+
				" from   cont_n_view a, car_reg b, car_nm c,  car_etc g,"+
				"        (select a.* from rent_cont a, (select car_mng_id, max(nvl(deli_dt,decode(use_st,'1','0000000000',deli_plan_dt))) deli_dt from rent_cont where use_st in ('1','2') group by car_mng_id) b where a.use_st in ('1','2') and a.car_mng_id=b.car_mng_id and nvl(a.deli_dt,decode(a.use_st,'1','0000000000',a.deli_plan_dt))=b.deli_dt) i, client l, users j, "+
				"        (select car_mng_id from cont where nvl(use_yn,'Y')='Y' and car_st in ('1','3') group by car_mng_id) d "+
				" where  nvl(a.use_yn,'Y')='Y' and a.car_st='2' and nvl(b.off_ls,'0') not in ('5','6')"+
				"        and a.car_mng_id=b.car_mng_id "+
				"	and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=c.car_id(+)  and    g.car_seq=c.car_seq(+)   \n"+
				"        and a.car_mng_id=i.car_mng_id(+) and i.cust_id=l.client_id(+) and i.cust_id=j.user_id(+)"+
				"        and a.car_mng_id=d.car_mng_id(+) and d.car_mng_id is null ";

		if(car_gu.equals("3")) query += " and b.car_use='1'";

		if(!car_cd.equals("")) query += " and c.car_cd='"+car_cd+"'";

		if(s_kd.equals("1"))	query += " and b.car_no like '%"+t_wd+"%'";
		if(s_kd.equals("2"))	query += " and b.car_nm||c.car_name like upper('%"+t_wd+"%')";
		if(s_kd.equals("3"))	query += " and decode(i.cust_st, '', '', '1',replace(l.firm_nm,'(��)',''), '4','�Ƹ���ī') like upper('%"+t_wd+"%')";
		if(s_kd.equals("4"))	query += " and decode(b.prepare,'4','-','5','-','6','-', decode(i.rent_st,'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','��������','6','��������','7','��������','8','������','11','�����','12','����Ʈ', '-') ) like upper('%"+t_wd+"%')";

		query += " order by b.car_no";
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
	 *	����������� ������������Ʈ
	 *	s_kd - 1:������ȣ , 2:����, 3:�����ڵ�
	 */
	public Vector getReservationCarList(String s_kd, String t_wd, String car_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+  merge(a) */ "+
				"        b.car_no, a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.car_nm, c.car_name, c.car_comp_id, nvl(b.off_ls,'0') off_ls,"+
				"        decode(b.prepare,'4','-','5','-','6','-', decode(i.rent_st,'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','��������','6','��������','7','��������','8','������','11','�����','12','����Ʈ', '-') ) rent_st_nm,"+
				"        decode(i.cust_st, '', '', '1',replace(l.firm_nm,'(��)',''), '4','�Ƹ���ī') cust_nm, substr(i.deli_dt,1,8) deli_dt, substr(i.ret_dt,1,8) ret_dt, i.rent_s_cd "+
				" from   cont_n_view a, car_reg b, car_nm c,  car_etc g,"+
				"        (select a.* "+
				"         from   rent_cont a, "+
				"                (select car_mng_id, max(nvl(deli_dt,decode(use_st,'1','0000000000',deli_plan_dt))) deli_dt from rent_cont where rent_st='10' and use_st in ('1','2','3','4') group by car_mng_id) b "+
				"         where  a.rent_st='10' and a.use_st in ('1','2','3','4') "+
				"                and a.car_mng_id=b.car_mng_id and nvl(a.deli_dt,decode(a.use_st,'1','0000000000',a.deli_plan_dt))=b.deli_dt "+
				"         ) i, "+
				"         client l"+
				" where  "+
				"        nvl(a.use_yn,'Y')='Y' and  "+
				"        nvl(b.off_ls,'0') not in ('5','6') and "+
				"        a.car_mng_id=b.car_mng_id "+
				"	and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=c.car_id(+)  and    g.car_seq=c.car_seq(+)   \n"+			
				"        and a.car_mng_id=i.car_mng_id "+
				"		 and i.cust_id=l.client_id(+)"+
				"        and a.car_st in ('1','3') "+
				"        ";

		if(!car_cd.equals("")) query += " and c.car_cd='"+car_cd+"'";

		if(s_kd.equals("1"))	query += " and b.car_no like '%"+t_wd+"%'";
		if(s_kd.equals("2"))	query += " and b.car_nm||c.car_name like upper('%"+t_wd+"%')";
		if(s_kd.equals("3"))	query += " and decode(i.cust_st, '', '', '1',replace(l.firm_nm,'(��)',''), '4','�Ƹ���ī') like upper('%"+t_wd+"%')";
		if(s_kd.equals("4"))	query += " and decode(b.prepare,'4','-','5','-','6','-', decode(i.rent_st,'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','��������','6','��������','7','��������','8','������','11','�����','12','����Ʈ', '-') ) like upper('%"+t_wd+"%')";

		query += " order by b.car_no";

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
	 *	����������� ������������Ʈ
	 *	s_kd - 1:������ȣ , 2:����, 3:�����ڵ�
	 */
	public Vector getReservationCarList(String s_kd, String t_wd, String car_cd, String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select /*+  merge(a) */ "+
				"        b.car_no, a.car_mng_id, a.rent_mng_id, a.rent_l_cd, b.car_nm, c.car_name, c.car_comp_id, nvl(b.off_ls,'0') off_ls,"+
				"        decode(b.prepare,'4','-','5','-','6','-', decode(i.rent_st,'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','��������','6','��������','7','��������','8','������','11','�����','12','����Ʈ', '-') ) rent_st_nm,"+
				"        decode(i.cust_st, '', '', '1',replace(l.firm_nm,'(��)',''), '4','�Ƹ���ī') cust_nm, substr(i.deli_dt,1,8) deli_dt, substr(i.ret_dt,1,8) ret_dt, i.rent_s_cd "+
				" from   cont_n_view a, car_reg b, car_nm c,  car_etc g,"+
				"        (select a.* "+
				"         from   rent_cont a "+
//				"                (select car_mng_id, max(nvl(deli_dt,decode(use_st,'1','0000000000',deli_plan_dt))) deli_dt from rent_cont where rent_st='10' and use_st in ('1','2','3','4') group by car_mng_id) b "+
				"         where  a.rent_st='10' and a.use_st in ('1','2','3','4') "+
//				"                and a.car_mng_id=b.car_mng_id and nvl(a.deli_dt,decode(a.use_st,'1','0000000000',a.deli_plan_dt))=b.deli_dt "+
				"         ) i, "+
				"         client l, (select car_mng_id, max(reg_dt||rent_l_cd) max_cont_cd from cont where car_st<>'4' group by car_mng_id) e "+ //
				" where  "+
//				"        nvl(a.use_yn,'Y')='Y' and  "+
//				"        nvl(b.off_ls,'0') not in ('5','6') and "+
				"        a.car_mng_id=b.car_mng_id "+
				"	and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"+
                       		"	and g.car_id=c.car_id(+)  and    g.car_seq=c.car_seq(+)   \n"+
				"        and a.car_mng_id=i.car_mng_id "+
				"		 and i.cust_id=l.client_id(+)"+
				"        and a.car_mng_id=e.car_mng_id and a.reg_dt||a.rent_l_cd=e.max_cont_cd "+		
//				"        and a.car_st<>'2'"+
				"        ";

		if(!car_cd.equals(""))		query += " and c.car_cd='"+car_cd+"'";
		if(!client_id.equals(""))	query += " and l.client_id='"+client_id+"'";

		if(s_kd.equals("1"))	query += " and b.car_no like '%"+t_wd+"%'";
		if(s_kd.equals("2"))	query += " and b.car_nm||c.car_name like upper('%"+t_wd+"%')";
		if(s_kd.equals("3"))	query += " and decode(i.cust_st, '', '', '1',replace(l.firm_nm,'(��)',''), '4','�Ƹ���ī') like upper('%"+t_wd+"%')";
		if(s_kd.equals("4"))	query += " and decode(b.prepare,'4','-','5','-','6','-', decode(i.rent_st,'1','�ܱ�뿩','2','�������','3','������','9','�������','10','��������','4','�����뿩','5','��������','6','��������','7','��������','8','������','11','�����','12','����Ʈ', '-') ) like upper('%"+t_wd+"%')";

		query += " order by b.car_no";


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
	 *	�̰�����Ȳ
	 */
	public Vector getLcStartStat2List(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT '1' st, a.rent_mng_id, a.rent_l_cd, d.firm_nm, c.car_no, C.CAR_NM, c.init_reg_dt, \n"+
				"        DECODE(a.car_gu,'0','�縮��','1','����') car_gu, \n"+
				"        a.rent_dt, a.dlv_dt, \n"+
				"        e.car_rent_st, e.car_rent_et, \n"+
				"        decode(REPLACE(f.to_dt,' ',''),'0000',f.to_req_dt,f.to_dt) to_dt, \n"+
				"        CASE WHEN f2.to_dt IS NOT NULL AND a.rent_dt <= f2.to_dt THEN decode(REPLACE(f2.to_dt,' ',''),'0000',f2.to_req_dt,f2.to_dt) ELSE '' end to_dt2, \n"+
				"        g.user_nm \n"+
				" FROM   FEE b, CONT a, CAR_REG c, CLIENT d, TAECHA e, \n"+
				//����ȣ ���� �뿩�����ε� Ź��
				"        (SELECT rent_mng_id, rent_l_cd, min(to_req_dt) to_req_dt, min(to_dt) to_dt FROM CONSIGNMENT where cons_cau='1' GROUP BY rent_mng_id, rent_l_cd) f, \n"+
				//������ȣ ���� �뿩�����ε� �ֱ�Ź��
				"        (SELECT car_mng_id, max(to_req_dt) to_req_dt, max(to_dt) to_dt FROM CONSIGNMENT where cons_cau='1' GROUP BY car_mng_id) f2, \n"+
				"        USERS g \n"+
				" WHERE  b.rent_start_dt IS NULL AND b.RENT_ST='1'  \n"+
				"        AND b.rent_mng_id=a.rent_mng_id AND b.rent_l_cd=a.rent_l_cd AND a.car_st in ('1','3','5') AND nvl(a.use_yn,'Y')='Y' \n"+
				"        AND a.car_mng_id=c.car_mng_id  \n"+
				"        AND a.client_id=d.client_id \n"+
				"        AND a.rent_mng_id=e.rent_mng_id(+) AND a.rent_l_cd=e.rent_l_cd(+) and nvl(e.no,'0')='0' \n"+
				"        AND a.rent_mng_id=f.rent_mng_id(+) AND a.rent_l_cd=f.rent_l_cd(+) \n"+
				"        AND a.car_mng_id=f2.car_mng_id(+) \n"+
				"        AND a.BUS_ID=g.user_id  \n"+
				"        ";

		String search = "";
		String what = "";
			
		if(!gubun1.equals(""))			query += " and g.br_id='"+gubun1+"'";


		if(s_kd.equals("1"))	what = "d.firm_nm";
		if(s_kd.equals("2"))	what = "upper(a.rent_l_cd)";	
		if(s_kd.equals("3"))	what = "c.car_no";
		if(s_kd.equals("4"))	what = "g.user_nm";	

			
		if(!what.equals("") && !s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	
		
		//���ʵ���� �˻��̸� �������Ʈ�� ���̰��Ѵ�.		
		if(s_kd.equals("4") && !t_wd.equals("")){
			query += " union all "+
		            " SELECT '2' st, a.rent_mng_id, a.rent_l_cd, d.firm_nm, c.car_no, j.CAR_NM, decode(a.dlv_dt,'','�����','�̵��') init_reg_dt, \n"+
					"        DECODE(a.car_gu,'0','�縮��','1','����') car_gu, \n"+
					"        a.rent_dt, a.dlv_dt, \n"+
					"        e.car_rent_st, e.car_rent_et, decode(REPLACE(f.to_dt,' ',''),'0000',f.to_req_dt,f.to_dt) to_dt, \n"+
					"        CASE WHEN f2.to_dt IS NOT NULL AND a.rent_dt <= f2.to_dt THEN decode(REPLACE(f2.to_dt,' ',''),'0000',f2.to_req_dt,f2.to_dt) ELSE '' end to_dt2, \n"+					
					"        g.user_nm \n"+
					" FROM   FEE b, CONT a, CAR_REG c, CLIENT d, TAECHA e, \n"+
					"        (SELECT rent_mng_id, rent_l_cd, min(to_req_dt) to_req_dt, min(to_dt) to_dt FROM CONSIGNMENT where cons_cau='1' GROUP BY rent_mng_id, rent_l_cd) f, USERS g, \n"+
					//������ȣ ���� �뿩�����ε� �ֱ�Ź��
					"        (SELECT car_mng_id, max(to_req_dt) to_req_dt, max(to_dt) to_dt FROM CONSIGNMENT where cons_cau='1' GROUP BY car_mng_id) f2, \n"+					
					"        car_etc h, car_nm i, car_mng j "+ 
					" WHERE  b.rent_start_dt IS NULL AND b.RENT_ST='1'  \n"+
					"        AND b.rent_mng_id=a.rent_mng_id AND b.rent_l_cd=a.rent_l_cd AND a.car_st in ('1','3','5') AND nvl(a.use_yn,'Y')='Y' \n"+
					"        AND a.car_mng_id=c.car_mng_id(+) and c.car_mng_id is null   \n"+
					"        AND a.client_id=d.client_id \n"+
					"        AND a.rent_mng_id=e.rent_mng_id(+) AND a.rent_l_cd=e.rent_l_cd(+) and nvl(e.no,'0')='0' \n"+
					"        AND a.rent_mng_id=f.rent_mng_id(+) AND a.rent_l_cd=f.rent_l_cd(+) \n"+
					"        AND a.car_mng_id=f2.car_mng_id(+) \n"+					
					"        AND a.BUS_ID=g.user_id  \n"+
					"        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd and h.car_id=i.car_id and h.car_seq=i.car_seq and i.car_comp_id=j.car_comp_id and i.car_cd=j.code "+
					"        and g.user_nm='"+t_wd+"'";
			
		}
		
		query += " order by 1, 8 desc, 9, 10";


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
	  		e.printStackTrace();
			System.out.println("[EtcContDatabase:getLcStartStat2List]\n"+e);
			System.out.println("[EtcContDatabase:getLcStartStat2List]\n"+query);

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
	 *	������Ȳ
	 */
	public Vector getLcStartStat3List(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String dt1 = "";
		String dt2 = "";

		dt1 = "substr(b.rent_start_dt,1,6)";
		dt2 = "b.rent_start_dt";

		if(gubun3.equals("2")){
			dt1 = "to_char(e.user_dt1,'YYYYMM')";
			dt2 = "to_char(e.user_dt1,'YYYYMMDD')";
		}

		query = " SELECT a.rent_mng_id, a.rent_l_cd, d.firm_nm, c.car_no, C.CAR_NM, \n"+
				"        g.car_deli_dt, b.rent_start_dt, b.rent_end_dt,   \n"+
				"        (b.fee_s_amt+b.fee_v_amt) AS fee_amt,  \n"+
				"        (b.fee_s_amt+b.fee_v_amt-b.inv_s_amt-b.inv_v_amt) AS cha_amt, \n"+
				"        b.con_mon, b.fee_pay_tm, TO_CHAR(e.user_dt1,'YYYYMMDD') as reg_dt, h.user_nm \n"+
				" FROM   FEE b, CONT a, CAR_REG c, CLIENT d, CONT_ETC g, \n"+
				"        (SELECT * FROM DOC_SETTLE WHERE doc_st='16') e, \n"+
				"        (SELECT * FROM CLS_CONT WHERE cls_st IN ('4','5')) f, \n"+
				"        USERS h \n"+
				" WHERE  b.RENT_ST='1' \n"+
				"        ";		

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun2.equals("5"))		query += " and "+dt2+" like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
		
		query += "       AND b.rent_mng_id=a.rent_mng_id AND b.rent_l_cd=a.rent_l_cd \n"+
				"        AND a.car_mng_id=c.car_mng_id \n"+
				"        AND a.client_id=d.client_id \n"+
				"        AND a.rent_mng_id=g.rent_mng_id AND a.rent_l_cd=g.rent_l_cd \n"+
				"        AND a.rent_l_cd=e.doc_id \n"+
				"        AND a.rent_mng_id=f.rent_mng_id(+) AND a.reg_dt=f.reg_dt(+) AND f.rent_l_cd IS NULL \n"+
				"        AND a.BUS_ID=h.user_id  \n"+
				"        ";

		String search = "";
		String what = "";
			
		if(!gubun1.equals(""))			query += " and h.br_id='"+gubun1+"'";


		if(s_kd.equals("1"))	what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(c.car_no, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(h.user_nm, ' '))";	

			
		if(!what.equals("") && !s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}else{

		}	
		
		if(gubun3.equals("1")){
			query += " ORDER BY b.rent_start_dt, to_char(e.user_dt1,'YYYYMMDD') ";
		}else if(gubun3.equals("2")){
			query += " ORDER BY to_char(e.user_dt1,'YYYYMMDD'), b.rent_start_dt ";
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
	  		e.printStackTrace();
			System.out.println("[EtcContDatabase:getLcStartStat3List]\n"+e);
			System.out.println("[EtcContDatabase:getLcStartStat3List]\n"+query);

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
	 *	�����ٹ̵����Ȳ
	 */
	public Vector getLcStartStat4List(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "", query3 = "";

		query1 =	" SELECT a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.no as taecha_no, '����' gubun, '' rent_st, e.firm_nm, \n"+
					"        a.car_no, F.CAR_NM, NVL(a.car_rent_dt,b.rent_dt) AS rent_dt, a.car_rent_st AS rent_start_dt, a.car_rent_et AS rent_end_dt, \n"+
					"        d.t_use_s_dt AS use_s_dt, d.t_use_e_dt AS use_e_dt, d.f_use_s_dt, g.user_nm, g.br_id, \n"+
 			        "        CASE WHEN SYSDATE-ADD_MONTHS(TO_DATE(NVL(d.t_use_e_dt,a.car_rent_st),'YYYYMMDD'),1) > -5 THEN 'Y' ELSE 'N' END red_yn, g2.user_nm as doc_user_nm1, g3.user_nm as doc_user_nm2  \n"+
					" FROM   TAECHA a, CONT b, FEE c, \n"+
					"        ( SELECT rent_mng_id, rent_l_cd, taecha_no, \n"+
					"                COUNT(DECODE(tm_st2,'2',rent_l_cd)) t_cnt, COUNT(DECODE(tm_st2,'0',rent_l_cd)) f_cnt, \n"+
					"                min(DECODE(tm_st2,'2',use_s_dt)) t_use_s_dt, \n"+
					"                max(DECODE(tm_st2,'2',use_e_dt)) t_use_e_dt, \n"+
					"                min(DECODE(tm_st2,'0',use_s_dt)) f_use_s_dt, \n"+
					"                max(DECODE(tm_st2,'0',use_e_dt)) f_use_e_dt \n"+
					"         FROM   SCD_FEE \n"+
					"         GROUP BY rent_mng_id, rent_l_cd, taecha_no \n"+
					"        ) d, \n"+
					"        CLIENT e, CAR_REG f, users g, cont_etc h, \n"+
					"        ( select * from cls_cont where cls_st in ('4','5') ) y, \n"+
					"        ( select * from doc_settle where doc_st='16' ) i, users g2, users g3 \n"+
					" WHERE  a.rent_fee>0 and a.car_rent_st is not null    		                --���뿩�� �ְ�, \n"+
					"        and nvl(a.req_st,'1')='1'											--û���� \n"+
					"        and nvl(a.tae_st,'1')='1' 											--��꼭����  \n"+
					"        AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \n"+
					"        AND b.rent_dt>='20140101'											--2014�⵵ ���к���  \n"+
					"        AND NVL(b.use_yn,'Y')='Y'											--������  \n"+
					"        AND b.car_st in ('1','3','5')										--���뿩��� \n"+
					"        AND b.rent_mng_id=c.rent_mng_id AND b.rent_l_cd=c.rent_l_cd  \n"+
					"        AND c.RENT_ST='1' 													--���ʰ�� \n"+
					"        AND nvl(c.fee_chk,'0')<>'1'										--�ϻ�ϳ��� �ƴ� \n"+
					"        and c.prv_dlv_yn='Y' 												--��������� �ִ� \n"+
					"        AND a.rent_mng_id=d.rent_mng_id(+) AND a.rent_l_cd=d.rent_l_cd(+) and a.no=d.taecha_no(+) \n"+
					"        AND (NVL(a.CAR_RENT_ST,'99999999') <> NVL(d.t_use_s_dt,'99999999') OR NVL(a.CAR_RENT_ET,'99999999') <> NVL(d.t_use_e_dt,'99999999')) --���������ϰ� �����ٻ��� �������� �ٸ��� \n"+
					"        AND b.client_id=e.client_id \n"+
					"        AND a.car_mng_id=f.car_mng_id \n"+   
					"        AND b.rent_mng_id=y.rent_mng_id(+) AND b.reg_dt=y.reg_dt(+) \n"+
					"        AND a.car_mng_id<>NVL(b.car_mng_id,'000000')						--��Ī������ ����  \n"+
					"        and b.bus_id=g.user_id "+
					"        AND b.rent_mng_id=h.rent_mng_id AND b.rent_l_cd=h.rent_l_cd  \n"+
					"        and b.rent_dt >= nvl(decode(y.rent_mng_id,'',h.rent_suc_dt,y.cls_dt),b.rent_dt) "+
					"        and b.rent_l_cd=i.doc_id and i.user_id1=g2.user_id and i.user_id2=g3.user_id "+
					"        ";

		query2 =	" SELECT b.rent_mng_id, b.rent_l_cd, b.car_mng_id, '' taecha_no, DECODE(c.rent_st,'1','����','����') gubun, c.rent_st, e.firm_nm,  \n"+
					"        f.car_no, F.CAR_NM, DECODE(c.rent_st,'1',b.rent_dt,c.rent_dt) AS rent_dt, c.rent_start_dt, c.rent_end_dt,  \n"+
					"        d.f_use_s_dt AS use_s_dt, d.f_use_e_dt AS use_e_dt, d.f_use_s_dt, g.user_nm, g.br_id, \n"+
			        "        CASE WHEN SYSDATE-ADD_MONTHS(TO_DATE(c.rent_start_dt,'YYYYMMDD'),1) > -10 THEN 'Y' ELSE 'N' END red_yn, g2.user_nm as doc_user_nm1, g3.user_nm as doc_user_nm2  \n"+ 
					" FROM   CONT b, FEE c, \n"+
					"        ( SELECT rent_mng_id, rent_l_cd, rent_st, \n"+
					"                 COUNT(DECODE(tm_st2,'2',rent_l_cd)) t_cnt, COUNT(DECODE(tm_st2,'0',rent_l_cd)) f_cnt, \n"+
					"                 min(DECODE(tm_st2,'2',use_s_dt)) t_use_s_dt,  \n"+
					"                 max(DECODE(tm_st2,'2',use_e_dt)) t_use_e_dt, \n"+
					"                 min(DECODE(tm_st2,'0',use_s_dt)) f_use_s_dt,  \n"+
					"                 max(DECODE(tm_st2,'0',use_e_dt)) f_use_e_dt \n"+
					"          FROM   SCD_FEE \n"+
					"          GROUP BY rent_mng_id, rent_l_cd, rent_st \n"+
					"        ) d,  \n"+
					"        CLIENT e, CAR_REG f, users g, cont_etc h, \n"+
					"        ( select * from cls_cont where cls_st in ('4','5') ) y, \n"+
					"        ( select * from doc_settle where doc_st='16' ) i, users g2, users g3 \n"+
					" WHERE  DECODE(c.rent_st,'1',b.rent_dt,c.rent_dt)>='20140101'               --2014�⵵ ���к���  \n"+
					"        AND NVL(b.use_yn,'Y')='Y'                                           --������  \n"+
					"        AND b.car_st in ('1','3','5')                                       --���뿩��� \n"+
					"        AND b.rent_mng_id=c.rent_mng_id AND b.rent_l_cd=c.rent_l_cd  \n"+
					"        AND c.rent_start_dt IS NOT NULL AND c.FEE_S_AMT>0 \n"+
					"        AND nvl(c.fee_chk,'0')<>'1'                                         --�ϻ�ϳ��� �ƴ� \n"+
					"        and (c.con_mon-nvl(c.pere_r_mth,0))>0                               --���ô뿩�ᰡ �Ѱ������� ���� ��� ���� \n"+
					"        AND c.rent_mng_id=d.rent_mng_id(+) AND c.rent_l_cd=d.rent_l_cd(+) AND c.RENT_ST=d.rent_st(+) AND d.f_use_s_dt IS null \n"+
					"        AND b.client_id=e.client_id \n"+
					"        AND b.car_mng_id=f.car_mng_id \n"+   
					"        AND b.rent_mng_id=y.rent_mng_id(+) AND b.reg_dt=y.reg_dt(+) \n"+
					"        and DECODE(c.rent_st,'1',b.bus_id,c.EXT_AGNT)=g.user_id "+
					"        AND b.rent_mng_id=h.rent_mng_id AND b.rent_l_cd=h.rent_l_cd  \n"+
					"        and DECODE(c.rent_st,'1',b.rent_dt,c.rent_dt) >= nvl(decode(y.rent_mng_id,'',h.rent_suc_dt,y.cls_dt),DECODE(c.rent_st,'1',b.rent_dt,c.rent_dt)) "+
					"        and b.rent_l_cd=i.doc_id and i.user_id1=g2.user_id and i.user_id2=g3.user_id "+
					"        ";


		query = " select * from ( "+query1+" union all "+query2+" ) where rent_dt is not null ";

		String search = "";
		String what = "";
			
		if(!gubun1.equals("")){
			query += " and br_id='"+gubun1+"'";
		}

		if(s_kd.equals("1"))	what = "upper(nvl(firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(car_no, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(user_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(doc_user_nm1, ' '))";	
		if(s_kd.equals("6"))	what = "upper(nvl(doc_user_nm2, ' '))";	
			
		if(!what.equals("") && !s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		if(gubun2.equals("1"))	query += " and gubun='����'";
		if(gubun2.equals("2"))	query += " and gubun='����'";
		if(gubun2.equals("3"))	query += " and gubun='����'";
		
		query += " order by red_yn DESC, decode(rent_st,'0','9','1','1','2'), rent_start_dt";



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
	  		e.printStackTrace();
			System.out.println("[EtcContDatabase:getLcStartStat4List]\n"+e);
			System.out.println("[EtcContDatabase:getLcStartStat4List]\n"+query);

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
	 *	�����ٵ����Ȳ
	 */
	public Vector getLcStartStat5List(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String dt1 = "";
		String dt2 = "";

		dt1 = "substr(c.rent_start_dt,1,6)";
		dt2 = "c.rent_start_dt";

		if(gubun3.equals("2")){
			dt1 = "substr(d.f_reg_dt,1,6)";
			dt2 = "d.f_reg_dt";
		}

		query =	" SELECT b.rent_mng_id, b.rent_l_cd, b.car_mng_id, DECODE(c.rent_st,'1','����','����') gubun, c.rent_st, e.firm_nm,  \n"+
					"        f.car_no, F.CAR_NM, DECODE(c.rent_st,'1',b.rent_dt,c.rent_dt) AS rent_dt, c.rent_start_dt, c.rent_end_dt,  \n"+
					"        d.f_use_s_dt AS use_s_dt, d.f_use_e_dt AS use_e_dt, d.f_use_s_dt, g.user_nm, g.br_id, \n"+
			        "        d.f_reg_dt \n"+ 
					" FROM   CONT b, FEE c, \n"+
					"        ( SELECT rent_mng_id, rent_l_cd, rent_st, \n"+
					"                 COUNT(DECODE(tm_st2,'2',rent_l_cd)) t_cnt, COUNT(DECODE(tm_st2,'0',rent_l_cd)) f_cnt, \n"+
					"                 min(DECODE(tm_st2,'2',use_s_dt)) t_use_s_dt, \n"+
					"                 max(DECODE(tm_st2,'2',use_e_dt)) t_use_e_dt, \n"+
					"                 min(DECODE(tm_st2,'0',use_s_dt)) f_use_s_dt, \n"+
					"                 max(DECODE(tm_st2,'0',use_e_dt)) f_use_e_dt, \n"+
					"                 min(DECODE(tm_st2,'0',nvl(cng_dt,update_dt))) f_reg_dt  \n"+
					"          FROM   SCD_FEE \n"+
					"          GROUP BY rent_mng_id, rent_l_cd, rent_st \n"+
					"        ) d,  \n"+
					"        CLIENT e, CAR_REG f, users g, cont_etc h, \n"+
					"        ( select * from cls_cont where cls_st in ('4','5') ) y \n"+
					" WHERE  b.car_st in ('1','3','5')                                       --���뿩��� \n"+
					"        ";

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun2.equals("5"))		query += " and "+dt2+" like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
			

		query += 	"        AND b.rent_mng_id=c.rent_mng_id AND b.rent_l_cd=c.rent_l_cd  \n"+
					"        AND c.rent_start_dt IS NOT NULL AND c.FEE_S_AMT>0 \n"+
					"        AND nvl(c.fee_chk,'0')<>'1'                                         --�ϻ�ϳ��� �ƴ� \n"+
					"        and (c.con_mon-nvl(c.pere_r_mth,0))>0                               --���ô뿩�ᰡ �Ѱ������� ���� ��� ���� \n"+
					"        AND c.rent_mng_id=d.rent_mng_id AND c.rent_l_cd=d.rent_l_cd AND c.RENT_ST=d.rent_st \n"+
					"        AND b.client_id=e.client_id \n"+
					"        AND b.car_mng_id=f.car_mng_id \n"+   
					"        AND b.rent_mng_id=y.rent_mng_id(+) AND b.reg_dt=y.reg_dt(+) \n"+
					"        and DECODE(c.rent_st,'1',b.bus_id,c.EXT_AGNT)=g.user_id "+
					"        AND b.rent_mng_id=h.rent_mng_id AND b.rent_l_cd=h.rent_l_cd  \n"+
					"        and DECODE(c.rent_st,'1',b.rent_dt,c.rent_dt) >= nvl(decode(y.rent_mng_id,'',h.rent_suc_dt,y.cls_dt),DECODE(c.rent_st,'1',b.rent_dt,c.rent_dt)) "+
					"        ";



		String search = "";
		String what = "";
			
		if(!gubun1.equals("")){
			query += " and g.br_id='"+gubun1+"'";
		}

		if(s_kd.equals("1"))	what = "upper(nvl(e.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(f.car_no, ' '))";
		if(s_kd.equals("4"))	what = "upper(nvl(g.user_nm, ' '))";	
			
		if(!what.equals("") && !s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		
		query += " order by "+dt2+", c.rent_start_dt ";



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
	  		e.printStackTrace();
			System.out.println("[EtcContDatabase:getLcStartStat5List]\n"+e);
			System.out.println("[EtcContDatabase:getLcStartStat5List]\n"+query);

		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}	

	//�����Ȳ-�������İ���
	public Vector getBusAnalysisRentList(String s_kd, String t_wd, String s_dt, String e_dt, String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

			query = " SELECT a.rent_mng_id, a.rent_l_cd, a.rent_dt, b.client_id, b.firm_nm, c.user_nm, F.CAR_NM||' '||e.car_name as car_name, \n"+
					"        DECODE(a.car_gu,'0','�縮��','1','����') car_gu, \n"+
					"        decode(a.rent_st,'1','�ű�','2','����','3','����','4','����','5','����','6','�縮��','7','�縮��') rent_st,  \n"+
					"        DECODE(a.car_st,'1','��Ʈ','3','����') car_st, \n"+
					"        DECODE(g.rent_way,'1','�Ϲݽ�','�⺻��') rent_way,  \n"+
					"        a.use_yn, h.bus_cau \n"+
					" FROM   CONT a, CLIENT b, USERS c, CAR_ETC d, CAR_NM e, CAR_MNG f, FEE g, FEE_ETC h  \n"+
					" ";

			if(gubun1.equals(""))  gubun1 = "1";
				
			if(gubun1.equals("1")) query += " WHERE  a.rent_dt BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'01' AND TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'31'";
			if(gubun1.equals("2")) query += " WHERE  a.rent_dt BETWEEN TO_CHAR(SYSDATE,'YYYYMM')||'01' AND TO_CHAR(SYSDATE,'YYYYMM')||'31'";

			if(!gubun2.equals("")) query += " AND c.user_nm = '"+gubun2+"' ";

			query += " AND a.car_st IN ('1','3') \n"+
					 " AND a.client_id=b.client_id \n"+
					 " AND a.BUS_ID=c.user_id \n"+
					 " AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd \n"+
					 " AND d.car_id=e.car_id AND d.car_seq=e.car_seq \n"+
					 " AND e.car_comp_id=f.car_comp_id AND e.car_cd=F.CODE \n"+
					 " AND a.rent_mng_id=g.rent_mng_id AND a.rent_l_cd=g.rent_l_cd AND g.RENT_ST='1' \n"+
					 " AND a.rent_mng_id=h.rent_mng_id AND a.rent_l_cd=h.rent_l_cd AND h.RENT_ST='1' \n"+
					 " ";

			String search = "";
			String what = "";
			
			if(s_kd.equals("1"))	what = "b.firm_nm";
			if(s_kd.equals("2"))	what = "F.CAR_NM";		
			
			if(!what.equals("") && !t_wd.equals(""))	query += " and "+what+" like '%"+t_wd+"%'  \n";

			query += " ORDER BY a.rent_dt DESC, rent_mng_id";


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
			System.out.println("[EtcContDatabase:getBusAnalysisRentList]\n"+e);
			System.out.println("[EtcContDatabase:getBusAnalysisRentList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	//������Ȳ-�������İ���
	public Vector getBusAnalysisEstiList(String s_kd, String t_wd, String s_dt, String e_dt, String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

			query = " SELECT a.est_id, a.set_code, a.rent_dt, a.est_nm, a.est_type, a.job, c.user_nm, F.CAR_NM||' '||e.car_name as car_name, \n"+
					"        DECODE(a.est_type,'F','����','�縮��') car_gu, \n"+
					"        b.nm, a.a_b, a.rg_8_amt, (a.fee_s_amt+a.fee_v_amt) AS fee_amt, a.use_yn, a.reg_dt, a.set_code, decode(a.bus_yn,'Y','���)','N','�̰��)') bus_yn, a.bus_cau  \n"+
                    " FROM   ESTIMATE a, USERS c, CAR_NM e, CAR_MNG f, (SELECT * FROM CODE WHERE c_st='0009') b \n"+
					" ";

			if(gubun1.equals(""))  gubun1 = "1";
				
			if(gubun1.equals("1")) query += " WHERE  a.rent_dt BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'01' AND TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'31'";
			if(gubun1.equals("2")) query += " WHERE  a.rent_dt BETWEEN TO_CHAR(SYSDATE,'YYYYMM')||'01' AND TO_CHAR(SYSDATE,'YYYYMM')||'31'";

			if(!gubun2.equals("")) query += " AND c.user_nm = '"+gubun2+"' ";

			query += " and a.est_type in ('F','L','S') \n"+
				     " AND a.FEE_S_AMT >0  \n"+
					 " AND nvl(a.job,'org')='org' and a.rent_st is null \n"+
					 " AND a.a_b >5 \n"+
					 " AND a.reg_id=c.user_id \n"+
					 " AND a.car_id=e.car_id AND a.car_seq=e.car_seq \n"+
					 " AND a.car_comp_id=f.car_comp_id AND a.car_cd=F.CODE \n"+
					 " AND a.a_a=b.nm_cd \n"+
					 " ";

			String search = "";
			String what = "";
			
			if(s_kd.equals("1"))	what = "a.est_nm";
			if(s_kd.equals("2"))	what = "F.CAR_NM";		
			
			if(!what.equals("") && !t_wd.equals(""))	query += " and "+what+" like '%"+t_wd+"%'  \n";

			query += " ORDER BY a.rent_dt DESC, a.reg_dt desc ";


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
			System.out.println("[EtcContDatabase:getBusAnalysisEstiList]\n"+e);
			System.out.println("[EtcContDatabase:getBusAnalysisEstiList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	//������Ȳ-�������İ���
	public Vector getBusAnalysisStatList(String s_kd, String t_wd, String s_dt, String e_dt, String gubun1, String gubun2, String gubun3)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

			//�����İ���
			query = " SELECT a.rent_mng_id, a.rent_l_cd, a.rent_dt, b.client_id, b.firm_nm, c.user_nm, F.CAR_NM||' '||e.car_name as car_name, \n"+
					"        DECODE(a.car_gu,'0','�縮��','1','����') car_gu, \n"+
					"        decode(a.rent_st,'1','�ű�','2','����','3','����','4','����','5','����','6','�縮��','7','�縮��') rent_st,  \n"+
					"        DECODE(a.car_st,'1','��Ʈ','3','����') car_st, \n"+
					"        DECODE(g.rent_way,'1','�Ϲݽ�','�⺻��') rent_way,  \n"+
					"        a.use_yn, h.bus_cau, h.bus_cau_dt, nvl(h.bus_cau_score,0) as bus_cau_score \n"+
					" FROM   CONT a, CLIENT b, USERS c, CAR_ETC d, CAR_NM e, CAR_MNG f, FEE g, FEE_ETC h  \n"+
					" where  h.bus_yn='Y' ";

			if(gubun1.equals(""))  gubun1 = "1";
				
			if(gubun1.equals("1")) query += " AND  decode(h.bus_cau_dt,'',a.rent_dt,to_char(h.bus_cau_dt,'YYYYMMDD')) BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'01' AND TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'31'";
			if(gubun1.equals("2")) query += " AND  decode(h.bus_cau_dt,'',a.rent_dt,to_char(h.bus_cau_dt,'YYYYMMDD')) BETWEEN TO_CHAR(SYSDATE,'YYYYMM')||'01' AND TO_CHAR(SYSDATE,'YYYYMM')||'31'";
			if(gubun1.equals("3")){				
				if(!s_dt.equals("") && !e_dt.equals("")) query += " AND decode(h.bus_cau_dt,'',a.rent_dt,to_char(h.bus_cau_dt,'YYYYMMDD')) between replace('"+s_dt+"', '-','') and replace('"+e_dt+"', '-','') \n";
			}

			if(!gubun2.equals("")) query += " AND c.user_nm = '"+gubun2+"' ";

			query += " AND a.car_st IN ('1','3') \n"+
					 " AND a.client_id=b.client_id \n"+
					 " AND a.BUS_ID=c.user_id \n"+
					 " AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd \n"+
					 " AND d.car_id=e.car_id AND d.car_seq=e.car_seq \n"+
					 " AND e.car_comp_id=f.car_comp_id AND e.car_cd=F.CODE \n"+
					 " AND a.rent_mng_id=g.rent_mng_id AND a.rent_l_cd=g.rent_l_cd AND g.RENT_ST='1' \n"+
					 " AND a.rent_mng_id=h.rent_mng_id AND a.rent_l_cd=h.rent_l_cd AND h.RENT_ST='1' \n"+
					 " ";

			String search = "";
			String what = "";
			
			if(s_kd.equals("1"))	what = "b.firm_nm";
			if(s_kd.equals("2"))	what = "F.CAR_NM";		
			
			if(!what.equals("") && !t_wd.equals(""))	query += " and "+what+" like '%"+t_wd+"%'  \n";

			query += " ORDER BY decode(h.bus_cau_score,'',0,1), nvl(h.bus_cau_dt,to_date(a.rent_dt,'YYYYMMDD')) desc, a.rent_dt desc, a.rent_mng_id";


			//�������İ���
			if(gubun3.equals("2")){
				
				query = " SELECT a.est_id, a.set_code, a.rent_dt, a.est_nm, a.est_type, a.job, c.user_nm, F.CAR_NM||' '||e.car_name as car_name, \n"+
						"        DECODE(a.est_type,'F','����','�縮��') car_gu, \n"+
						"        b.nm, a.a_b, a.rg_8_amt, (a.fee_s_amt+a.fee_v_amt) AS fee_amt, a.use_yn, a.reg_dt, a.set_code, "+
						"        decode(a.bus_yn,'Y','���)','N','�̰��)') bus_yn, a.bus_cau, a.bus_cau_dt, nvl(a.bus_cau_score,0) as bus_cau_score  \n"+
				        " FROM   ESTIMATE a, USERS c, CAR_NM e, CAR_MNG f, (SELECT * FROM CODE WHERE c_st='0009') b \n"+
						" where  a.bus_yn='N' ";

				if(gubun1.equals(""))  gubun1 = "1";
					
				if(gubun1.equals("1")) query += " AND  decode(a.bus_cau_dt,'',a.rent_dt,to_char(a.bus_cau_dt,'YYYYMMDD')) BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'01' AND TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'31'";
				if(gubun1.equals("2")) query += " AND  decode(a.bus_cau_dt,'',a.rent_dt,to_char(a.bus_cau_dt,'YYYYMMDD')) BETWEEN TO_CHAR(SYSDATE,'YYYYMM')||'01' AND TO_CHAR(SYSDATE,'YYYYMM')||'31'";
				if(gubun1.equals("3")){				
					if(!s_dt.equals("") && !e_dt.equals("")) query += " AND decode(a.bus_cau_dt,'',a.rent_dt,to_char(a.bus_cau_dt,'YYYYMMDD')) between replace('"+s_dt+"', '-','') and replace('"+e_dt+"', '-','') \n";
				}

				if(!gubun2.equals("")) query += " AND c.user_nm = '"+gubun2+"' ";

				query += " and a.est_type in ('F','L','S') \n"+
					     " AND a.FEE_S_AMT >0  \n"+
						 " AND nvl(a.job,'org')='org' and a.rent_st is null \n"+
//						 " AND a.a_b >5 \n"+
						 " AND a.reg_id=c.user_id \n"+
						 " AND a.car_id=e.car_id AND a.car_seq=e.car_seq \n"+
						 " AND a.car_comp_id=f.car_comp_id AND a.car_cd=F.CODE \n"+
						 " AND a.a_a=b.nm_cd \n"+
						 " ";

			
				if(s_kd.equals("1"))	what = "a.est_nm";
				if(s_kd.equals("2"))	what = "F.CAR_NM";		
			
				if(!what.equals("") && !t_wd.equals(""))	query += " and "+what+" like '%"+t_wd+"%'  \n";

				query += " ORDER BY decode(a.bus_cau_score,'',0,1), nvl(a.bus_cau_dt,to_date(a.rent_dt,'YYYYMMDD')) desc, a.rent_dt desc, a.reg_dt ";

			}


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
			System.out.println("[EtcContDatabase:getBusAnalysisStatList]\n"+e);
			System.out.println("[EtcContDatabase:getBusAnalysisStatList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	//���İ�������Ʈ �������
	public boolean updateBaScore(String gubun3, String ba_code, String ba_score)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query =  " update fee_etc set bus_cau_score="+ba_score+" where rent_l_cd='"+ba_code+"' and rent_st='1' ";

		if(gubun3.equals("2")){

			   query =  " update estimate set bus_cau_score="+ba_score+" where est_id='"+ba_code+"' ";

		}


		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
		    pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

			System.out.println("[EtcContDatabase:updateBaScore]\n"+query);
	  	} catch (Exception e) {
			System.out.println("[EtcContDatabase:updateBaScore]\n"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				if(pstmt != null)	pstmt.close();
				conn.setAutoCommit(true);
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}

	/**
	 *	����� �����Ȳ
	 */
	public Vector getStatDeptListM(String st, String mode, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";
		String stat_st = "d";
		 		
		b_query =   " select \n"+
					"        a.rent_l_cd, decode(a.bus_st,'7',decode(b.rent_st,'1','1000',nvl(b.brch_id,a.brch_id)),DECODE(b.rent_st,'1',a.brch_id,nvl(b.brch_id,a.brch_id))) as brch_id, \n"+
					"        DECODE(a.car_st,'4','����Ʈ',DECODE(b.rent_st,'1',DECODE(a.car_gu,'0','�縮��','1','����'),'����')) rent_st, \n"+
				    "        DECODE(b.rent_way,'1','�Ϲݽ�','�⺻��') rent_way, \n"+
				    "        CASE WHEN TO_NUMBER(b.con_mon) BETWEEN  0 AND 12 THEN '12' \n"+
                    "             WHEN TO_NUMBER(b.con_mon) BETWEEN 13 AND 24 THEN '24' \n"+
                    "             WHEN TO_NUMBER(b.con_mon) BETWEEN 25 AND 36 THEN '36' \n"+
                    "             WHEN TO_NUMBER(b.con_mon) BETWEEN 37 AND 48 THEN '48' \n"+
                    "             WHEN TO_NUMBER(b.con_mon) > 48 THEN '60' \n"+
                    "             END con_mon, \n"+
                    "        decode(b.rent_st,'1',a.rent_dt,b.rent_dt) rent_dt, k.firm_nm, g.car_no, l.car_nm||' '||d.car_name as car_name, i.user_nm \n"+
				    " from   cont a, fee b, car_etc c, car_nm d, car_mng l, car_reg g, cls_cont e, fee_etc h, \n"+
				    "        (select rent_mng_id, rent_l_cd, cls_dt, cls_st, reg_dt reg_dt from cls_cont where cls_st in ('4','5')) f, users i, client k \n"+
				    " where  a.car_st in ('1','3','4') and a.client_id not in ('000228') and a.client_id=k.client_id \n";

		if(!gubun3.equals(""))	b_query += " and decode(a.bus_st,'7',decode(b.rent_st,'1','1000',nvl(b.brch_id,a.brch_id)),DECODE(b.rent_st,'1',a.brch_id,nvl(b.brch_id,a.brch_id)))='"+gubun3+"' ";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		
		dt1 = "substr(decode(b.rent_st,'1',a.rent_dt,b.rent_dt),1,6)";
		dt2 = "decode(b.rent_st,'1',a.rent_dt,b.rent_dt)";


		if(gubun1.equals("1"))				b_query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";		
		else if(gubun1.equals("2"))			b_query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD') \n";		
		else if(gubun1.equals("3"))			b_query += " and "+dt2+" = to_char(sysdate-2,'YYYYMMDD') \n";		
		else if(gubun1.equals("7"))			b_query += " and "+dt2+" = to_char(sysdate-3,'YYYYMMDD') \n";		
		else if(gubun1.equals("4"))			b_query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' \n";
		else if(gubun1.equals("5"))			b_query += " and "+dt2+" like TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%' \n";
		else if(gubun1.equals("6"))			b_query += " and "+dt2+" like TO_CHAR(ADD_MONTHS(SYSDATE,-2),'YYYYMM')||'%' \n";
		else if(gubun1.equals("9")){
			if(!st_dt.equals("") && end_dt.equals(""))	b_query += " and "+dt2+" like replace('"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) b_query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		b_query += "      and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				   "      and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+ 
				   "      and c.car_id=d.car_id and c.car_seq=d.car_seq and d.car_comp_id=l.car_comp_id and d.car_cd=l.code \n"+
				   "      and a.car_mng_id=g.car_mng_id(+) \n"+
				   "      and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.cls_st,'0') not in ('7','10') \n"+
				   "      and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+) \n"+
				   "      and a.rent_mng_id=f.rent_mng_id(+) and a.reg_dt=f.reg_dt(+) \n"+
				   "      and case when f.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),f.reg_dt)  then '' else f.rent_l_cd end is null \n"+
				   "      and decode(b.rent_st,'1',a.bus_id,nvl(b.ext_agnt,a.bus_id))=i.user_id "+
				   " ";				

		//����
		if(mode.equals("1")) 		b_query += " and a.car_st in ('1','3') and b.rent_st = '1' and a.car_gu = '1' \n";

		//�縮��+�߰���
		if(mode.equals("2")) 		b_query += " and a.car_st in ('1','3') and b.rent_st = '1' and a.car_gu <> '1' \n";

		//����
		if(mode.equals("3")) 		b_query += " and a.car_st in ('1','3') and b.rent_st <> '1' \n";

		//����Ʈ
		if(mode.equals("4")) 		b_query += " and a.car_st='4' and b.rent_st <> '1' \n";

		if(gubun4.equals("1"))		b_query += " and b.rent_way='3' \n";
		if(gubun4.equals("2"))		b_query += " and b.rent_way='1' \n";
		if(gubun4.equals("12"))		b_query += " and TO_NUMBER(b.con_mon) BETWEEN  0 AND 12 \n";
		if(gubun4.equals("24"))		b_query += " and TO_NUMBER(b.con_mon) BETWEEN 13 AND 24 \n";
		if(gubun4.equals("36"))		b_query += " and TO_NUMBER(b.con_mon) BETWEEN 25 AND 36 \n";
		if(gubun4.equals("48"))		b_query += " and TO_NUMBER(b.con_mon) BETWEEN 37 AND 48 \n";
		if(gubun4.equals("60"))		b_query += " and TO_NUMBER(b.con_mon) > 48 \n";

		
		//����Ʈ	
		if(st.equals("list")){
			query = b_query + " order by 6 ";
		}else{

			query = " select b.brch_id, decode(a.br_id,'1000','������Ʈ',c.br_nm) br_nm, \n";

			query += " count(decode(b.rent_st,'����', b.rent_l_cd)) cnt1_0, \n";	
			query += " count(decode(b.rent_st,'�縮��',b.rent_l_cd)) cnt1_1, \n";	
			query += " count(decode(b.rent_st,'����', b.rent_l_cd)) cnt1_2, \n";	
			query += " count(decode(b.rent_st,'����Ʈ',b.rent_l_cd)) cnt1_3, \n";	
			query += " count(decode(b.rent_st,'����Ʈ','',b.rent_l_cd)) cnt1_4, \n";	
			query += " count(decode(b.rent_way,'�⺻��', b.rent_l_cd)) cnt2_0, \n";	
			query += " count(decode(b.rent_way,'�Ϲݽ�', b.rent_l_cd)) cnt2_1, \n";	
			query += " count(decode(b.rent_st,'����Ʈ','',b.rent_l_cd)) cnt2_2, \n";	
			query += " count(decode(b.con_mon,'12', b.rent_l_cd)) cnt3_0, \n";	
			query += " count(decode(b.con_mon,'24', b.rent_l_cd)) cnt3_1, \n";	
			query += " count(decode(b.con_mon,'36', b.rent_l_cd)) cnt3_2, \n";	
			query += " count(decode(b.con_mon,'48', b.rent_l_cd)) cnt3_3, \n";	
			query += " count(decode(b.con_mon,'60', b.rent_l_cd)) cnt3_4, \n";	
			query += " count(decode(b.rent_st,'����Ʈ','',b.rent_l_cd)) cnt3_5 \n";	


			query += " from "+
					"       ( SELECT DECODE(a.dept_id,'1000',a.dept_id,a.br_id) br_id "+
					"         FROM   USERS a, BRANCH b "+
					"         WHERE  a.use_yn='Y' AND a.dept_id<>'8888' AND a.br_id=b.br_id "+
					"         GROUP BY DECODE(a.dept_id,'1000',a.dept_id,a.br_id) ) a, ("+b_query+") b, BRANCH c \n"+
					" where a.br_id=b.brch_id(+) and a.br_id=c.br_id(+) "+
					" group by b.brch_id, decode(a.br_id,'1000','������Ʈ',c.br_nm) \n"+
					" order by decode(decode(a.br_id,'1000','������Ʈ',c.br_nm),'����','��','������Ʈ','?R', decode(a.br_id,'1000','������Ʈ',c.br_nm)) \n"+
					" ";

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
			System.out.println("[EtcContDatabase:getStatDeptListM]"+e);
			System.out.println("[EtcContDatabase:getStatDeptListM]"+query);
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


  /****************************************************************************************
	*******************************************   agent
    ****************************************************************************************/


	//������
	public Vector getContListAgent(String s_kd, String t_wd, String andor, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String ck_acar_id, String sa_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

			query = " select   \n"+
					"        a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, nvl(d.rent_dt,a.rent_dt) as rent_dt, nvl(c.rent_suc_dt,y.cls_dt) as rent_suc_dt, a.use_yn, \n"+
					"        b.firm_nm, b.client_nm, e.r_site as site_nm, \n"+
					"        j.car_nm, f.car_no, f.init_reg_dt, f.car_doc_no, f.car_num, \n"+
					"        decode(nvl(f.car_ext,h.car_ext),'1','����','2','����','3','�λ�','4','����','5','����','6','��õ','7','��õ','8','����','9','����','10','�뱸') car_ext, \n"+
					"        decode(m.rent_st,'1','','����') ext_st, \n"+
					"        decode(m.rent_st,'1','',decode(sign(to_date(d.rent_dt,'YYYYMMDD')-to_date(y.cls_dt,'YYYYMMDD')),1,'����',0,'����','')) ext_st2, \n"+
					"        decode(y.cls_st,'4','��������','5','���°�') cng_st, \n"+
					"        decode(a.rent_st,'1','�ű�','2','����','3','����','4','����','5','����','6','�縮��','7','�縮��') rent_st,  \n"+
					"        decode(a.bus_st, '1','���ͳ�','2','�������','3','��ü�Ұ�','4','ī�޷α�','5','��ȭ���','6','������ü', '7', '������Ʈ','8','�����') bus_st, \n"+
					"        decode(nvl(a.car_gu,a.reg_id),'1','����','0','�縮��','2','�߰���','3','����Ʈ') car_gu, \n"+
					"        decode(a.car_st,'1','��Ʈ','2','����','3','����','4','����Ʈ','5','�����뿩') car_st,  \n"+
					"        decode(d.rent_way,'1','�Ϲݽ�','2','�����','3','�⺻��') rent_way, \n"+
				 	"        decode(o.cls_st,'1','��ุ��','2','�ߵ�����','3','�����Һ���','4','��������','5','���°�','6','�Ű�','7','���������','8','���Կɼ�','9','����','10','����������', '15', '����') cls_st, \n"+
					"        a.dlv_dt, d.con_mon as ext_mon, m.con_mon, m.rent_start_dt, m.rent_end_dt,  \n"+
			        "        nvl(decode(d.rent_st, '1', a.bus_id, d.ext_agnt),a.bus_id) bus_id, decode(d.rent_st,'1',c.bus_agnt_id,mm.bus_agnt_id) bus_agnt_id, a.bus_id2, \n"+
					"        k.user_nm as bus_nm, k.user_m_tel as bus_m_tel,  \n"+
					"        nvl(qu.user_nm,l.user_nm) bus_agnt_nm, nvl(qu.user_m_tel,l.user_m_tel) bus_agnt_m_tel, \n"+
					"        n.user_nm bus_nm2, n.user_m_tel as bus2_m_tel,  \n"+
					"        a.mng_id, u.user_nm as mng_nm, u.user_m_tel as mng_m_tel,  \n"+
					"        a.mng_id2, u2.user_nm as mng_nm2, u2.user_m_tel as mng_m_tel2,  \n"+
					"        a.bus_id3, decode(d.ext_agnt,'',x.user_nm,k.user_nm) as bus_nm3, decode(d.ext_agnt,'',x.user_m_tel,k.user_m_tel) as bus3_m_tel,  \n"+
					"        a.sanction_id, s.user_nm as sanction_nm, \n"+
				    "        z.ins_com_id,\n"+
					"        decode(length(a.sanction),8,decode(sign(to_date(a.sanction,'YYYYMMDD')-to_date(DECODE(sign(to_date(TO_CHAR(SYSDATE,'YYYYMMDD'),'YYYYMMDD')-to_date(nvl(d.rent_dt,a.rent_dt),'YYYYMMDD')),-1,TO_CHAR(SYSDATE,'YYYYMMDD'),nvl(d.rent_dt,a.rent_dt)),'YYYYMMDD')),-1,'�̰�',1,'��û',0,'��û','�̰�'),'�̰�') sanction_st, "+
					"        m.rent_st as fee_rent_st \n"+
					" from \n"+
					"		 cont a, client b, cont_etc c, fee d, client_site e, car_reg f, \n"+
					"		 car_etc h, car_nm i, car_mng j, users k, users l, users n, users s, users u, \n"+
					"		 ( select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, sum(con_mon) con_mon, min(nvl(rent_start_dt,'')) rent_start_dt, max(nvl(rent_end_dt,'')) rent_end_dt \n"+
					"		   from   fee  \n"+
					"          group by rent_mng_id, rent_l_cd \n"+
					"        ) m, \n"+
					"        cls_cont o, \n"+
					"	     users x,  \n"+
					"	     ( select * from cls_cont where cls_st in ('4','5')) y, \n"+
					"        ( select a.car_mng_id, a.ins_com_id  from insur a, ins_cls b  where  a.car_mng_id = b.car_mng_id(+) and a.ins_st = b.ins_st(+) and  to_char(sysdate,'YYYYMMDD')  between to_char(to_date(a.ins_start_dt,'YYYYMMDD') + 1 , 'yyyymmdd')  and decode(b.car_mng_id, null, a.ins_exp_dt, b.exp_dt)  ) z, \n"+
					"        fee_etc mm,  \n"+
				    "        users qu, users u2,  \n"+
					"        (select * from commi where agnt_st='1') g, \n"+
                    "        (SELECT client_id, min(rent_dt) rent_dt FROM CONT where bus_id='"+ck_acar_id+"' GROUP BY client_id) p, fee d2 \n"+
					" where  \n"+
					"        a.car_st not in ('2','4','5') "+
					"        and a.client_id=b.client_id \n"+
					"        and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) \n"+
					"        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
					"        and a.client_id=e.client_id(+) and a.r_site=e.seq(+) \n"+
					"        and a.car_mng_id=f.car_mng_id(+) \n"+
					"        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd \n"+
					"        and h.car_id=i.car_id and h.car_seq=i.car_seq and i.car_comp_id=j.car_comp_id and i.car_cd=j.code \n"+
					"        and nvl(decode(d.rent_st, '1', a.bus_id, d.ext_agnt),a.bus_id)=k.user_id \n"+					
					"        and c.bus_agnt_id=l.user_id(+) \n"+
					"        and a.bus_id2=n.user_id(+) \n"+
					"        and d.rent_mng_id=m.rent_mng_id and d.rent_l_cd=m.rent_l_cd and d.rent_st=m.rent_st \n"+
					"        and a.rent_mng_id=o.rent_mng_id(+) and a.rent_l_cd=o.rent_l_cd(+) \n"+
					"        and a.sanction_id=s.user_id(+) \n"+
					"        and a.mng_id=u.user_id(+) \n"+
					"        and a.bus_id3=x.user_id(+) \n"+
					"        and a.rent_mng_id=y.rent_mng_id(+) and a.reg_dt=y.reg_dt(+) \n"+
					"        and a.car_mng_id=z.car_mng_id(+) \n"+
					"        and d.rent_mng_id=mm.rent_mng_id(+) and d.rent_l_cd=mm.rent_l_cd(+) and d.rent_st=mm.rent_st(+) \n"+
					"        and mm.bus_agnt_id=qu.user_id(+) \n"+
					"        and a.mng_id2=u2.user_id(+) \n"+
					"        and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+) \n"+
					"        and a.client_id=p.client_id(+) \n"+
					"        and c.rent_mng_id=d2.rent_mng_id(+) and c.rent_l_cd=d2.rent_l_cd(+) and c.suc_rent_st=d2.rent_st(+) \n"+
					"        and decode(c.rent_suc_dt,'',decode(p.client_id,'',decode(g.emp_id,'"+sa_code+"','"+ck_acar_id+"',decode(d.ext_agnt,'"+ck_acar_id+"','"+ck_acar_id+"',a.bus_id)),'"+ck_acar_id+"'),d2.ext_agnt)='"+ck_acar_id+"' \n"+
					" ";

			query += " and case when a.bus_id<>'"+ck_acar_id+"' and g.emp_id<>'"+sa_code+"' and p.client_id is not null and a.rent_dt < p.rent_dt then 'N' else 'Y' end = 'Y' ";

	
			if(gubun1.equals("Y"))	query += " and nvl(a.use_yn,'Y')='Y'";
			if(gubun1.equals("N"))	query += " and a.use_yn='N'";
			if(gubun1.equals("0"))	query += " and a.use_yn is null";

			if(gubun3.equals("1"))	query += " and d.rent_way='1'";
			if(gubun3.equals("2"))	query += " and d.rent_way in ('2','3')";
			if(gubun3.equals("10")) query += " and a.car_st='1'";
			if(gubun3.equals("11")) query += " and a.car_st='3'";
			if(gubun3.equals("12")) query += " and d.rent_st='1' and a.rent_st='1'";
			if(gubun3.equals("13")) query += " and d.rent_st='1' and a.rent_st='4'";
			if(gubun3.equals("14")) query += " and d.rent_st='1' and a.rent_st='3'";


			if(!gubun2.equals("")) query += " and nvl(c.mng_br_id,a.brch_id)='"+gubun2+"'";

			String search = "";
			String what = "";

			String dt1 = "";
			String dt2 = "";

			dt1 = "substr(decode(d.rent_st,'1',a.rent_dt,d.rent_dt),1,6)";
			dt2 = "decode(d.rent_st,'1',a.rent_dt,d.rent_dt)";

			if(gubun4.equals("2")){
				dt1 = "substr(nvl(c.rent_suc_dt,y.cls_dt),1,6)";
				dt2 = "nvl(c.rent_suc_dt,y.cls_dt)";
			}

			if(gubun5.equals("4"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";				//���
			else if(gubun5.equals("5"))		query += " and "+dt2+" like TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%'";	//����
			else if(gubun5.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";				//����
			else if(gubun5.equals("2"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";			//����
			else if(gubun5.equals("3"))		query += " and "+dt2+" between to_char(sysdate-1,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') ";//2��
			else if(gubun5.equals("6")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}

			
			if(s_kd.equals("1"))	what = "upper(nvl(b.firm_nm||e.r_site, ' '))";
			if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
			if(s_kd.equals("3"))	what = "upper(nvl(f.car_no||' '||f.first_car_no, ' '))";		
			if(s_kd.equals("4"))	what = "upper(nvl(f.car_doc_no, ' '))";	
			if(s_kd.equals("5"))	what = "upper(nvl(f.car_num, ' '))";	
			if(s_kd.equals("9"))	what = "upper(nvl(nvl(qu.user_nm,l.user_nm), ' '))";	
			if(s_kd.equals("10"))	what = "upper(nvl(n.user_nm, ' '))";	
			if(s_kd.equals("11"))	what = "upper(nvl(u.user_nm, ' '))";	
			if(s_kd.equals("13"))	what = "upper(nvl(b.client_nm||e.site_jang, ' '))";
			if(s_kd.equals("16"))	what = "upper(nvl(j.car_nm, ' '))";
			if(s_kd.equals("19"))	what = "upper(nvl(b.enp_no||b.ssn||e.enp_no, ' '))";
			
			if(!what.equals("") && !t_wd.equals("")){
				if(t_wd.indexOf("'") != -1)					t_wd = AddUtil.replace(t_wd,"'","");

				query += " and "+what+" like upper('%"+t_wd+"%')  \n";
				query += " order by a.use_yn desc, a.rent_dt desc, a.rent_mng_id desc, a.reg_dt desc, a.update_dt desc \n";
			}else{
					if(s_kd.equals("10")){ //���������
						query += " and a.bus_id2 is null order by a.rent_dt, a.rent_start_dt \n";
					}else{
						//������ ����Ʈ
						/*�°������*/query += " and nvl(a.use_yn,'Y')='Y' and b.client_id<>'000228' and a.car_st in ('1','3') \n"; //������ ����Ʈ���� �������� ����Ʈ�� ����

						//�̰�,����,�縮��,����,�°��
						query += " order by decode(y.cls_st,'5',decode(sign(to_date(d.rent_start_dt)-to_date(y.cls_dt,'YYYYMMDD')),1,0,0,0,1),0), "+
							     "          decode(y.cls_st||decode(m.rent_st,'1','',decode(sign(to_date(d.rent_dt,'YYYYMMDD')-to_date(y.cls_dt,'YYYYMMDD')),1,'����',0,'����','')),'5', nvl(c.rent_suc_dt,y.cls_dt), nvl(d.rent_dt,a.rent_dt)) desc, "+
								 "          a.use_yn desc, decode(d.rent_st,'1',1,2), decode(nvl(a.car_gu,a.reg_id),'0','1','2','2','1','3') desc, a.rent_st desc \n";
					}
			}


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
			System.out.println("[EtcContDatabase:getContListAgent]\n"+e);
			System.out.println("[EtcContDatabase:getContListAgent]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	//�����Ȳ�� ����Ʈ ��ȸ
	public Vector getRentBoardInsList(String s_kd, String t_wd, String gubun1, String gubun2, String st_dt, String end_dt, String mod_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String r_query = "";

		query = " SELECT e.client_st, e.firm_nm, DECODE(e.client_st,'2',text_decrypt(e.ssn, 'pw'),e.enp_no) ssn, DECODE(a.car_st,1,'��Ʈ','3','����') car_st, \n"+
				"        H.CAR_NM, g.car_name, SUBSTR(f.reg_est_dt,1,8) reg_est_dt, d.est_car_no as car_no, d.car_num, \n"+
				"        (f.CAR_CS_AMT + f.CAR_CV_AMT + f.OPT_CS_AMT +f.OPT_CV_AMT + f.CLR_CS_AMT + f.CLR_CV_AMT-f.tax_dc_s_amt-f.tax_dc_v_amt) tot_amt, \n"+
				"        DECODE(s.INSURANT,'1','�Ƹ���ī','2','��') AS insurant, DECODE(s.INSUR_PER,'1','�Ƹ���ī','2','��') AS insur_per, \n"+
				"        a.DRIVING_AGE, a.GCP_KD, a.BACDT_KD, "+
				"        CASE WHEN e.client_st<>'2' and g.car_name not like '%9�ν�%' AND g.s_st > '101' AND g.s_st < '600' AND g.s_st <> '409' and s.com_emp_yn ='Y' THEN '����' ELSE '�̰���' END com_emp_yn, "+
				"        r2.com_nm b_com_nm, r2.model_nm as b_model_nm, r2.serial_no as b_serial_no, r2.tint_amt as b_amt, \n"+
				"        g.car_id, g.car_seq, v.jg_g_16, v.jg_g_17, g.CAR_COMP_ID, s.hook_yn, s.top_cng_yn \n"+	//�����ؽ�ƼĿ�߱޴�󿩺�, ��������
				" from   cont a, fee b, car_reg c, car_pur d, client e, car_etc f, car_nm g, car_mng h, cont_etc s, esti_jg_var v, \n"+
				"        (SELECT * FROM CAR_TINT WHERE tint_st='3' AND tint_yn='Y') r2, \n"+
				" 		 (SELECT sh_code, max(seq) seq FROM esti_jg_var GROUP BY sh_code) v2 \n"+
				" WHERE  nvl(a.use_yn,'Y')='Y' and decode(a.rent_l_cd,'S114KK5S00001','1',a.car_st)<>'2' and a.car_gu='1' \n"+
				"        and c.init_reg_dt is null \n"+
				"        and d.dlv_est_dt is not NULL \n"+
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' \n"+
				" 		 and a.car_mng_id=c.car_mng_id(+) \n"+
				" 		 and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
				" 		 and a.client_id=e.client_id \n"+
				" 		 and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd \n"+
				" 		 and f.car_id=g.car_id and f.car_seq=g.car_seq and g.car_comp_id=h.car_comp_id and g.car_cd=h.code \n"+
				"        and a.rent_mng_id=s.rent_mng_id and a.rent_l_cd=s.rent_l_cd \n"+
				"        and a.rent_mng_id=r2.rent_mng_id(+) and a.rent_l_cd=r2.rent_l_cd(+) \n"+
				"        and  g.jg_code=v.sh_code AND v.sh_code=v2.sh_code AND v.seq=v2.seq \n"+
				" ";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(s_kd.equals("1"))	what = "upper(nvl(e.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(nvl(c.car_no,d.est_car_no), ' '))";
		if(s_kd.equals("6"))	what = "upper(nvl(nvl(c.car_ext,f.car_ext)||decode(nvl(c.car_ext,f.car_ext),'1','����','2','����','3','�λ�','4','����','5','����','6','��õ','7','��õ','8','����','9','����','10','�뱸'), ' '))";	
		if(s_kd.equals("7"))	what = "upper(nvl(decode(d.udt_st,'1','����','2','�λ�����','3','��������','4','��','5','�뱸����','6','��������',''), ' '))";	
		if(s_kd.equals("10"))	what = "SUBSTR( f.reg_est_dt, 1, 8 )";	
		if(s_kd.equals("99"))	what = "decode(a.car_st,'3','����','��Ʈ')";
		
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		if(gubun1.equals("1")){//�����
			dt1		= "substr(d.dlv_est_dt,1,6)";
			dt2		= "substr(d.dlv_est_dt,1,8)";
		}else if(gubun1.equals("2")){//��Ͽ���
			dt1		= "substr(f.reg_est_dt,1,6)";
			dt2		= "substr(f.reg_est_dt,1,8)";
		}else if(gubun1.equals("5")){//������Ͽ���
			dt1		= "substr(f.reg_est_dt,1,6)";
			dt2		= "substr(f.reg_est_dt,1,8)";
		}

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("4"))		query += " and "+dt2+" = to_char(sysdate+1,'YYYYMMDD')";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		query += " order by a.car_st, decode(nvl(c.car_ext,f.car_ext), '1','1', '2','2', '3','5', '4','6', '5','7', '6','2', '7','3', '8','4', '9','9', '10','10'), d.udt_est_dt, d.udt_st, f.reg_est_dt, a.rent_dt, e.firm_nm, h.car_nm \n";



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
			System.out.println("[EtcContDatabase:getRentBoardInsList]\n"+e);
			System.out.println("[EtcContDatabase:getRentBoardInsList]\n"+query);
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

	//�����Ȳ�� ����Ʈ ��ȸ
	public Hashtable getRentBoardIns(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " SELECT e.client_st, e.firm_nm, DECODE(e.client_st,'2',substr(text_decrypt(e.ssn, 'pw'),1,6),e.enp_no) ssn, DECODE(a.car_st,1,'��Ʈ','3','����','5','�����뿩','') car_st, \n"+
				"        H.CAR_NM, g.car_name, SUBSTR(f.reg_est_dt,1,8) reg_est_dt, d.est_car_no as car_no, d.car_num, \n"+
				"        (f.CAR_CS_AMT + f.CAR_CV_AMT + f.OPT_CS_AMT +f.OPT_CV_AMT + f.CLR_CS_AMT + f.CLR_CV_AMT-f.tax_dc_s_amt-f.tax_dc_v_amt) tot_amt, \n"+
				"        DECODE(s.INSURANT,'1','�Ƹ���ī','2','��') AS insurant, DECODE(s.INSUR_PER,'1','�Ƹ���ī','2','��') AS insur_per, \n"+
				"        a.DRIVING_AGE, a.GCP_KD, a.BACDT_KD, "+
				"        CASE WHEN e.client_st <> '2' and g.car_name not like '%9�ν�%' AND g.s_st > '101' AND g.s_st < '600' AND g.s_st <> '409' and s.com_emp_yn ='Y' THEN '����' ELSE '�̰���' END com_emp_yn, "+
				"        r2.com_nm b_com_nm, r2.model_nm as b_model_nm, r2.serial_no as b_serial_no, r2.tint_amt as b_amt, \n"+
				"        DECODE(s.LKAS_YN,null,'N',s.LKAS_YN) as LKAS_YN, DECODE(s.LDWS_YN,null,'N',s.LDWS_YN) as LDWS_YN, DECODE(s.AEB_YN,null,'N',s.AEB_YN) as AEB_YN, \n"+
				"        DECODE(s.FCW_YN,null,'N',s.FCW_YN) as FCW_YN, DECODE(s.HOOK_YN,null,'N',s.HOOK_YN) as HOOK_YN, DECODE(s.EV_YN,null,'N',s.EV_YN) as EV_YN, "+
				"        DECODE(s.LEGAL_YN,null,'N',s.LEGAL_YN) as LEGAL_YN, "+
				"		 opt, g.CAR_COMP_ID, s.others_device, DECODE(s.top_cng_yn,null,'N',s.top_cng_yn) as top_cng_yn  \n"+
				" from   cont a, fee b, car_reg c, car_pur d, client e, car_etc f, car_nm g, car_mng h, cont_etc s, \n"+
				"        (SELECT * FROM CAR_TINT WHERE tint_st='3' AND tint_yn='Y') r2 \n"+
				" WHERE  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' "+
				"        and nvl(a.use_yn,'Y')='Y' and decode(a.rent_l_cd,'S114KK5S00001','1',a.car_st)<>'2' and a.car_gu='1' \n"+
				"        and c.init_reg_dt is null \n"+
				"        and d.dlv_est_dt is not NULL \n"+
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' \n"+
				" 		 and a.car_mng_id=c.car_mng_id(+) \n"+
				" 		 and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
				" 		 and a.client_id=e.client_id \n"+
				" 		 and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd \n"+
				" 		 and f.car_id=g.car_id and f.car_seq=g.car_seq and g.car_comp_id=h.car_comp_id and g.car_cd=h.code \n"+
				"        and a.rent_mng_id=s.rent_mng_id and a.rent_l_cd=s.rent_l_cd \n"+
				"        and a.rent_mng_id=r2.rent_mng_id(+) and a.rent_l_cd=r2.rent_l_cd(+) \n"+
				" ";

		try {
								
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
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
			System.out.println("[EtcContDatabase:getRentBoardIns]\n"+e);
			System.out.println("[EtcContDatabase:getRentBoardIns]\n"+query);
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


	public boolean updateContEtcComEmpSac(String rent_mng_id, String rent_l_cd, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = " update CONT_ETC set "+
						" com_emp_sac_id	= ?, "+
						" com_emp_sac_dt	= to_char(sysdate,'YYYYMMDD') "+
						" where RENT_MNG_ID = ? and RENT_L_CD = ? ";
		try 
		{
			conn.setAutoCommit(false);
				
			pstmt = conn.prepareStatement(query);			
			pstmt.setString(1, user_id);
			pstmt.setString(2, rent_mng_id);
			pstmt.setString(3, rent_l_cd);
		    pstmt.executeUpdate();
			pstmt.close();
			conn.commit();
		    
	  	} catch (Exception e) {
	  		System.out.println("[EtcContDatabase:updateContEtcComEmpSac]\n"+e);
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

	//������ �����Ȳ�� ����Ʈ ��ȸ
	public float getAddRentChaAmtPer(String rent_mng_id, String rent_l_cd, String rent_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;		
		String query = "";
		float cha_amt_per = 0;

		query = " SELECT decode(fee_s_amt,0,0,abs(trunc((inv_s_amt-fee_s_amt)/fee_s_amt*100,1))) per from fee where rent_mng_id='"+rent_mng_id+"' and rent_l_cd='"+rent_l_cd+"' and rent_st='"+rent_st+"' ";

		try {
								
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		    	
			if(rs.next())
			{				
				cha_amt_per = rs.getString("per")==null?0:AddUtil.parseFloat(rs.getString("per"));
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[EtcContDatabase:getAddRentChaAmtPer]\n"+e);
			System.out.println("[EtcContDatabase:getAddRentChaAmtPer]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return cha_amt_per;
		}		
	}

	//������
	public Vector getContListAgent_20160614(String s_kd, String t_wd, String andor, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String ck_acar_id, String sa_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

			query = " select   \n"+
					"        a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, nvl(d.rent_dt,a.rent_dt) as rent_dt, nvl(c.rent_suc_dt,y.cls_dt) as rent_suc_dt, a.use_yn, \n"+
					"        b.firm_nm, b.client_nm, e.r_site as site_nm, \n"+
					"        j.car_nm, f.car_no, f.init_reg_dt, f.car_doc_no, f.car_num, \n"+
					"        decode(nvl(f.car_ext,h.car_ext),'1','����','2','����','3','�λ�','4','����','5','����','6','��õ','7','��õ','8','����','9','����','10','�뱸') car_ext, \n"+
					"        decode(m.rent_st,'1','','����') ext_st, \n"+
					"        decode(m.rent_st,'1','',decode(sign(to_date(d.rent_dt,'YYYYMMDD')-to_date(y.cls_dt,'YYYYMMDD')),1,'����',0,'����','')) ext_st2, \n"+
					"        decode(y.cls_st,'4','��������','5','���°�') cng_st, \n"+
					"        decode(a.rent_st,'1','�ű�','2','����','3','����','4','����','5','����','6','�縮��','7','�縮��') rent_st,  \n"+
					"        decode(a.bus_st, '1','���ͳ�','2','�������','3','��ü�Ұ�','4','ī�޷α�','5','��ȭ���','6','������ü', '7', '������Ʈ','8','�����') bus_st, \n"+
					"        decode(nvl(a.car_gu,a.reg_id),'1','����','0','�縮��','2','�߰���','3','����Ʈ') car_gu, \n"+
					"        decode(a.car_st,'1','��Ʈ','2','����','3','����','4','����Ʈ','5','�����뿩') car_st,  \n"+
					"        decode(d.rent_way,'1','�Ϲݽ�','2','�����','3','�⺻��') rent_way, \n"+
				 	"        decode(o.cls_st,'1','��ุ��','2','�ߵ�����','3','�����Һ���','4','��������','5','���°�','6','�Ű�','7','���������','8','���Կɼ�','9','����','10','����������', '15', '����') cls_st, \n"+
					"        a.dlv_dt, d.con_mon as ext_mon, m.con_mon, m.rent_start_dt, m.rent_end_dt,  \n"+
			        "        nvl(decode(d.rent_st, '1', a.bus_id, d.ext_agnt),a.bus_id) bus_id, decode(d.rent_st,'1',c.bus_agnt_id,mm.bus_agnt_id) bus_agnt_id, a.bus_id2, \n"+
					"        k.user_nm as bus_nm, k.user_m_tel as bus_m_tel, "+
					"        decode(k3.dept_id,'',k2.dept_id,decode(k4.dept_id,'',k3.dept_id,k4.dept_id)) dept_id, \n"+
					"        nvl(qu.user_nm,l.user_nm) bus_agnt_nm, nvl(qu.user_m_tel,l.user_m_tel) bus_agnt_m_tel, \n"+
					"        n.user_nm bus_nm2, n.user_m_tel as bus2_m_tel,  \n"+
					"        a.sanction_id, "+
				    "        z.ins_com_id,\n"+
					"        decode(length(a.sanction),8,decode(sign(to_date(a.sanction,'YYYYMMDD')-to_date(DECODE(sign(to_date(TO_CHAR(SYSDATE,'YYYYMMDD'),'YYYYMMDD')-to_date(nvl(d.rent_dt,a.rent_dt),'YYYYMMDD')),-1,TO_CHAR(SYSDATE,'YYYYMMDD'),nvl(d.rent_dt,a.rent_dt)),'YYYYMMDD')),-1,'�̰�',1,'��û',0,'��û','�̰�'),'�̰�') sanction_st, "+
					"        m.rent_st as fee_rent_st, p2.f_rent_mon, TO_CHAR(ADD_MONTHS(nvl(p2.rent_start_dt,sysdate),50)-1,'YYYYMMDD') add_mon50_dt \n"+
					" from \n"+
					"		 cont a, client b, cont_etc c, fee d, client_site e, car_reg f, \n"+
					"		 car_etc h, car_nm i, car_mng j, users k, users k2, users l, users n, "+
					"		 ( select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, sum(con_mon) con_mon, min(nvl(rent_start_dt,'')) rent_start_dt, max(nvl(rent_end_dt,'')) rent_end_dt \n"+
					"		   from   fee  \n"+
					"          group by rent_mng_id, rent_l_cd \n"+
					"        ) m, \n"+
					"        cls_cont o, \n"+
					"	     ( select rent_mng_id, rent_l_cd, cls_st, cls_dt, reg_dt from cls_cont where cls_st in ('4','5')) y, \n"+
                    "        ( select a.car_mng_id, a.ins_com_id    \n"+ 
                    "          from   insur a, ins_cls b   \n"+ 
                    "          where  a.car_mng_id = b.car_mng_id(+) and a.ins_st = b.ins_st(+)   \n"+ 
                    "                 AND a.ins_start_dt <= TO_CHAR(sysdate-1,'YYYYMMDD')  \n"+ 
                    "                 AND ( (b.car_mng_id IS NULL and a.ins_exp_dt > TO_CHAR(sysdate,'YYYYMMDD'))  OR   (b.car_mng_id IS NOT NULL AND b.exp_dt >  TO_CHAR(sysdate,'YYYYMMDD')) )  \n"+ 
			        "        ) z, \n"+ 
					"        fee_etc mm,  \n"+
				    "        users qu, "+
					"        (select rent_mng_id, rent_l_cd, emp_id from commi where agnt_st='1') g, \n"+
                    "        (SELECT client_id, min(rent_dt) rent_dt, min(rent_start_dt) rent_start_dt, NVL(trunc(months_between(sysdate, TO_DATE(min(rent_start_dt), 'YYYYMMDD')),0),0) f_rent_mon FROM CONT where bus_id='"+ck_acar_id+"' and client_id<>'000228' GROUP BY client_id) p, \n"+
                    "        (SELECT client_id, min(rent_dt) rent_dt, min(rent_start_dt) rent_start_dt, NVL(trunc(months_between(sysdate, TO_DATE(min(rent_start_dt), 'YYYYMMDD')),0),0) f_rent_mon FROM CONT GROUP BY client_id) p2, \n"+
					"        fee d2, cont a2, cont a3, users k3, users k4 \n"+
					" where  \n"+
					"        a.car_st not in ('2','4','5') "+
					"        and a.client_id=b.client_id \n"+
					"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
					"        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
					"        and a.client_id=e.client_id(+) and a.r_site=e.seq(+) \n"+
					"        and a.car_mng_id=f.car_mng_id(+) \n"+
					"        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd \n"+
					"        and h.car_id=i.car_id and h.car_seq=i.car_seq and i.car_comp_id=j.car_comp_id and i.car_cd=j.code \n"+
				    "        AND ((d.RENT_ST='1' AND a.BUS_ID = k.user_id)  OR (d.RENT_ST<>'1' and d.ext_agnt is not null AND d.ext_agnt = k.user_id)  OR (d.RENT_ST<>'1' and d.ext_agnt is null AND a.bus_id = k.user_id )) \n"+
					"        and a.bus_id=k2.user_id \n"+
					"        and c.bus_agnt_id=l.user_id(+) \n"+
					"        and a.bus_id2=n.user_id \n"+
					"        and d.rent_mng_id=m.rent_mng_id and d.rent_l_cd=m.rent_l_cd and d.rent_st=m.rent_st \n"+
					"        and a.rent_mng_id=o.rent_mng_id(+) and a.rent_l_cd=o.rent_l_cd(+) \n"+
					"        and a.rent_mng_id=y.rent_mng_id(+) and a.reg_dt=y.reg_dt(+) \n"+
					"        and a.car_mng_id=z.car_mng_id(+) \n"+
					"        and d.rent_mng_id=mm.rent_mng_id and d.rent_l_cd=mm.rent_l_cd and d.rent_st=mm.rent_st \n"+
					"        and mm.bus_agnt_id=qu.user_id(+) \n"+
					"        and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+) \n"+
					"        and a.client_id=p.client_id(+) \n"+
					"        and a.client_id=p2.client_id \n"+
					"        and c.rent_suc_m_id=d2.rent_mng_id(+) and c.rent_suc_l_cd=d2.rent_l_cd(+) and c.suc_rent_st=d2.rent_st(+) \n"+
					"        and c.rent_suc_m_id=a3.rent_mng_id(+) and c.rent_suc_l_cd=a3.rent_l_cd(+) \n"+
					"        and y.rent_mng_id=a2.rent_mng_id(+) and y.rent_l_cd=a2.rent_l_cd(+) "+
					"        and a2.bus_id=k3.user_id(+) and a3.bus_id=k4.user_id(+) "+
				    "        and ( nvl(a2.bus_id,'')='"+ck_acar_id+"' or nvl(a3.bus_id,'')='"+ck_acar_id+"' or nvl(d2.ext_agnt,'')='"+ck_acar_id+"' or (p.client_id is not null and a.rent_dt >= p.rent_dt) or g.emp_id ='"+sa_code+"' or d.ext_agnt='"+ck_acar_id+"' or a.bus_id='"+ck_acar_id+"' ) "+
					" ";


	
			if(gubun1.equals("Y"))	query += " and a.use_yn='Y'";
			if(gubun1.equals("N"))	query += " and a.use_yn='N'";
			if(gubun1.equals("0"))	query += " and a.use_yn is null";

			if(gubun3.equals("1"))	query += " and d.rent_way='1'";
			if(gubun3.equals("2"))	query += " and d.rent_way in ('2','3')";
			if(gubun3.equals("10")) query += " and a.car_st='1'";
			if(gubun3.equals("11")) query += " and a.car_st='3'";
			if(gubun3.equals("12")) query += " and d.rent_st='1' and a.rent_st='1'";
			if(gubun3.equals("13")) query += " and d.rent_st='1' and a.rent_st='4'";
			if(gubun3.equals("14")) query += " and d.rent_st='1' and a.rent_st='3'";

			if(!gubun2.equals("")) query += " and (c.mng_br_id='"+gubun2+"' OR (c.mng_br_id is null and a.brch_id='"+gubun2+"' ))";

			String search = "";
			String what = "";

			String dt1 = "";
			String dt2 = "";

			//���(����)����
			if(gubun4.equals("1")){

				//���
				if(gubun5.equals("4"))			query += " and ( (d.rent_st='1' and a.rent_dt like to_char(sysdate,'YYYYMM')||'%') or (d.rent_st<>'1' and a.rent_dt like to_char(sysdate,'YYYYMM')||'%') ) ";
				//����
				else if(gubun5.equals("5"))		query += " and ( (d.rent_st='1' and a.rent_dt like to_char(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%') or (d.rent_st<>'1' and a.rent_dt like to_char(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%') ) ";
				//����
                else if(gubun5.equals("1"))		query += " and ( (d.rent_st='1' and a.rent_dt=to_char(sysdate,'YYYYMMDD')) or (d.rent_st<>'1' and d.rent_dt=to_char(sysdate,'YYYYMMDD')) ) ";
				//����				
                else if(gubun5.equals("2"))		query += " and ( (d.rent_st='1' and a.rent_dt=to_char(sysdate-1,'YYYYMMDD')) or (d.rent_st<>'1' and d.rent_dt=to_char(sysdate-1,'YYYYMMDD')) ) ";
				//2��
				else if(gubun5.equals("3"))		query += " and ( (d.rent_st='1' and a.rent_dt between to_char(sysdate-1,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD')) or (d.rent_st<>'1' and d.rent_dt between to_char(sysdate-1,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD')) ) ";
                //�Ⱓ 
				else if(gubun5.equals("6")){
					if(!st_dt.equals("") && !end_dt.equals("")) query += " and ( (d.rent_st='1' and a.rent_dt between '"+st_dt+"' and '"+end_dt+"') or (d.rent_st<>'1' and d.rent_dt between '"+st_dt+"' and '"+end_dt+"') ) ";
				}

			//�°�����
			}else if(gubun4.equals("2")){

				dt1 = "substr(c.rent_suc_dt,1,6)";
				dt2 = "c.rent_suc_dt";

				if(gubun5.equals("4"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";				//���
				else if(gubun5.equals("5"))		query += " and "+dt2+" like TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%'";	//����
				else if(gubun5.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";				//����
				else if(gubun5.equals("2"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";			//����
				else if(gubun5.equals("3"))		query += " and "+dt2+" between to_char(sysdate-1,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') ";//2��
				else if(gubun5.equals("6")){
					if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between '"+st_dt+"' and '"+end_dt+"'";
				}

			}

			
			if(s_kd.equals("1"))	what = "upper(b.firm_nm||e.r_site)";
			if(s_kd.equals("2"))	what = "a.rent_l_cd";	
			if(s_kd.equals("3"))	what = "f.car_no||' '||f.first_car_no";		
			if(s_kd.equals("4"))	what = "f.car_doc_no";	
			if(s_kd.equals("5"))	what = "f.car_num";	
			if(s_kd.equals("9"))	what = "nvl(qu.user_nm,l.user_nm)";	
			if(s_kd.equals("10"))	what = "n.user_nm";	
			if(s_kd.equals("13"))	what = "upper(b.client_nm||e.site_jang)";
			if(s_kd.equals("16"))	what = "j.car_nm";
			if(s_kd.equals("19"))	what = "b.enp_no||b.ssn||e.enp_no";
			
			if(!what.equals("") && !t_wd.equals("")){
				if(t_wd.indexOf("'") != -1)					t_wd = AddUtil.replace(t_wd,"'","");

				if(s_kd.equals("1")||s_kd.equals("2")||s_kd.equals("5")||s_kd.equals("13")){	
					query += " and "+what+" like upper('%"+t_wd+"%') \n";
				}else{
					query += " and "+what+" like '%"+t_wd+"%' \n";
				}

				query += " order by a.use_yn desc, a.rent_dt desc, a.rent_mng_id desc, a.reg_dt desc, a.update_dt desc \n";
			}else{
					if(s_kd.equals("10")){ //���������
						query += " and a.bus_id2 is null order by a.rent_dt, a.rent_start_dt \n";
					}else{
						//������ ����Ʈ
						/*�°������*/query += " and (a.use_yn is null or a.use_yn='Y') and b.client_id<>'000228' and a.car_st in ('1','3') \n"; //������ ����Ʈ���� �������� ����Ʈ�� ����

						//�̰�,����,�縮��,����,�°��
						query += " order by decode(y.cls_st,'5',decode(sign(to_date(d.rent_start_dt)-to_date(y.cls_dt,'YYYYMMDD')),1,0,0,0,1),0), "+
							     "          decode(y.cls_st||decode(m.rent_st,'1','',decode(sign(to_date(d.rent_dt,'YYYYMMDD')-to_date(y.cls_dt,'YYYYMMDD')),1,'����',0,'����','')),'5', nvl(c.rent_suc_dt,y.cls_dt), nvl(d.rent_dt,a.rent_dt)) desc, "+
								 "          a.use_yn desc, decode(d.rent_st,'1',1,2), decode(nvl(a.car_gu,a.reg_id),'0','1','2','2','1','3') desc, a.rent_st desc \n";
					}
			}


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
			System.out.println("[EtcContDatabase:getContListAgent_20160614]\n"+e);
			System.out.println("[EtcContDatabase:getContListAgent_20160614]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	//���ź����ݰ���
	public Vector getEcarPurSubList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String search = "";
		String what = "";

		query = " select a.RENT_MNG_ID, a.RENT_L_CD, c.car_mng_id, \n"+
				"        e.FIRM_NM, b.DLV_DT, b.use_yn, c.CAR_NO, c.CAR_NUM, c.INIT_REG_DT, h.nm, g.car_nm||' '||f.CAR_NAME as car_nm,  \n"+
				"        (a.car_fs_amt+a.sd_cs_amt-a.dc_cs_amt) car_fs_amt, \n"+
				"        (a.car_fv_amt+a.sd_cv_amt-a.dc_cv_amt) car_fv_amt, \n"+
				"        nvl(d.ext_s_amt,0) ext_s_amt, d.ext_est_dt, d.ext_pay_amt, d.ext_pay_dt, nvl(u.attach_seq,'') attach_seq \n"+

				" from   car_etc a, cont b, car_reg c, (select * from scd_ext where ext_st='7' and ext_tm='1') d, client e, car_nm f, car_mng g, code h, \n"+
 			    "        (SELECT substr(content_seq,1,6) car_mng_id, max(seq) attach_seq FROM ACAR_ATTACH_FILE WHERE ISDELETED = 'N' and content_code = 'CAR_CHANGE' group by substr(content_seq,1,6) ) u, \n"+
				"        (select sh_code, max(jg_g_7) jg_g_7 from esti_jg_var WHERE jg_g_7 in ('1','2') and jg_g_8='1' group by sh_code) i, cls_cont j, "+
				"        (select rent_mng_id, reg_dt from cls_cont where cls_st in ('4','5')) y"+		

				" where  \n"+
//				"        a.ecar_pur_sub_amt>0 and a.ecar_pur_sub_st='2' and \n"+
				"        a.ecar_pur_sub_amt>0 and nvl(b.use_yn,'Y')='Y' and b.car_gu='1' \n"+
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and b.car_mng_id=c.car_mng_id(+) \n"+
				"        and a.rent_l_cd=d.rent_l_cd(+) \n"+
				"        and b.client_id=e.client_id  \n"+
				"        and a.car_id=f.car_id and a.car_seq=f.car_seq  \n"+
				"        and f.car_comp_id=g.car_comp_id and f.car_cd=g.code \n"+
				"        and f.car_comp_id=h.code and h.c_st='0001'  \n"+
				"        and c.car_mng_id=u.car_mng_id(+) "+
				"        and f.jg_code=i.sh_code "+
				"        and a.rent_mng_id=j.rent_mng_id(+) and a.rent_l_cd=j.rent_l_cd(+) and nvl(j.cls_st,'0')<>'7' \n"+
				"        and b.rent_mng_id=y.rent_mng_id(+) and b.reg_dt=y.reg_dt(+) and y.rent_mng_id is null  \n"+
			    " ";

			if(gubun1.equals("1"))	query += " and d.ext_est_dt is not null "; //û��
			if(gubun1.equals("2"))	query += " and d.ext_est_dt is null "; //��û��
			if(gubun1.equals("3"))	query += " and d.ext_est_dt is not null and d.ext_pay_dt is null"; //���Ա�

			if(s_kd.equals("1"))	what = "upper(e.firm_nm)";
			if(s_kd.equals("2"))	what = "a.rent_l_cd";	
			if(s_kd.equals("3"))	what = "c.car_no";		
			if(s_kd.equals("4"))	what = "h.nm";	
			if(s_kd.equals("5"))	what = "g.car_nm";	
			if(s_kd.equals("6"))	what = "c.init_reg_dt";	
			
			if(!what.equals("") && !t_wd.equals("")){
				if(t_wd.indexOf("'") != -1)					t_wd = AddUtil.replace(t_wd,"'","");

				if(s_kd.equals("1")||s_kd.equals("2")){	
					query += " and "+what+" like upper('%"+t_wd+"%') \n";
				}else if(s_kd.equals("6")){	
					query += " and "+what+" like replace('%"+t_wd+"%','-','') \n";
				}else{
					query += " and "+what+" like '%"+t_wd+"%' \n";
				}
				query += " order by c.init_reg_dt desc \n";
			}else{
				if(gubun1.equals("1"))	query += " order by d.ext_est_dt desc \n";
				if(gubun1.equals("2"))	query += " order by c.init_reg_dt desc \n";
				if(gubun1.equals("3"))	query += " order by d.ext_est_dt desc \n";
			}

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
			System.out.println("[EtcContDatabase:getEcarPurSubList]\n"+e);
			System.out.println("[EtcContDatabase:getEcarPurSubList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	//��ຯ���� ���� ���躯���� �޽��� ���� ����
	public String getContCngInsCngMsg(String rent_mng_id, String rent_l_cd, String rent_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;		
		String query = "";
		String msg = "";

		query = " select chr(13)||'['||b.car_no||"+
				"        ','||b.car_nm||"+
				"        ','||c.firm_nm||"+
				"        ','||decode(c.CLIENT_ST,'2',substr(text_decrypt(c.ssn, 'pw'),1,6),c.enp_no)||"+
				"        ','||e.ins_start_dt|| "+
				"        ','||e.ins_exp_dt|| "+
				"        ','||e.ins_con_no|| "+
				"        ']' as msg \n"+
				" from   cont a, car_reg b, client c, fee d, insur e, ins_com f, ins_cls g \n"+
				" where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' \n"+ 
				"        and a.car_mng_id=b.car_mng_id \n"+
				"        and a.client_id=c.CLIENT_id \n"+
				"        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and d.rent_st='"+rent_st+"' \n"+
				"        and a.car_mng_id=e.car_mng_id "+
			    "        and e.car_mng_id=g.car_mng_id(+) and e.ins_st=g.ins_st(+) "+
				"	     and to_char(sysdate,'YYYYMMDD') between e.ins_start_dt and decode(g.car_mng_id,'',e.ins_exp_dt,g.exp_dt) \n"+
				"        and e.ins_com_id=f.ins_com_id \n"+
			    " ";

		try {
								
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		    	
			if(rs.next())
			{				
				msg = rs.getString("msg");
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[EtcContDatabase:getContCngInsCngMsg]\n"+e);
			System.out.println("[EtcContDatabase:getContCngInsCngMsg]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return msg;
		}		
	}

	/*
	 *	��ຯ�濡 ���� ���躯�� ��û�ϱ�
	*/
	public String call_sp_ins_cng_req(String sub, String cd1, String cd2, String cd3)
	{
    	getConnection();
    	
    	String query = "{CALL P_INS_CNG_REQ (?,?,?,?)}";

		String sResult = "0";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);			
			cstmt.setString(1, sub);
			cstmt.setString(2, cd1);
			cstmt.setString(3, cd2);
			cstmt.setString(4, cd3);			
			cstmt.execute();
			cstmt.close();			
		} catch (SQLException e) {
			System.out.println("[EtcContDatabase:call_sp_ins_cng_req]\n"+e);
			e.printStackTrace();
			sResult = "1";
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	

	//����Ʈ �������� ������� ����ϱ� - ����� ���� ã��
	public String getShResSeq(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null; 
		ResultSet rs = null;		
		String query = "";
		String seq = "";

		query = " select b.seq "+
				" from   cont_etc a, sh_res b \n"+
				" where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' \n"+ 
				"        and a.spe_est_id=b.est_id \n"+
			    " ";

		try {
								
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		    	
			if(rs.next())
			{				
				seq = rs.getString("seq");
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[EtcContDatabase:getShResSeq]\n"+e);
			System.out.println("[EtcContDatabase:getShResSeq]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return seq;
		}		
	}

	//�߰��� �����Ȳ�� ����Ʈ ��ȸ
	public Vector getRentBoardAcList(String s_kd, String t_wd, String gubun1, String gubun2, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  a.rent_mng_id, a.rent_l_cd, a.car_mng_id, b.rent_st, a.rent_dt, "+
				"         f.sh_init_reg_dt, f.sh_km, f.colo, d.est_car_no, d.pur_pay_dt, "+
				"         h.car_nm, g.car_name, "+
				"         d.dlv_brch, "+
				"         decode(nvl(c.car_ext,f.car_ext),'1','����','2','����','3','�λ�','4','����','5','����','6','��õ','7','��õ','8','����','9','����','10','�뱸') car_ext "+
				" from    cont a, fee b, car_reg c, car_pur d, client e, car_etc f, car_nm g, car_mng h "+
				" where "+
 				"         a.car_gu='2' and a.rent_dt>'20161130' and a.car_mng_id is null and nvl(a.use_yn,'Y')='Y' "+
				"         and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' "+
				"         and a.car_mng_id=c.car_mng_id(+)"+
				"         and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd"+
				"         and a.client_id=e.client_id"+
				"         and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd"+
				"         and f.car_id=g.car_id and f.car_seq=g.car_seq and g.car_comp_id=h.car_comp_id and g.car_cd=h.code"+
				" ";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(s_kd.equals("1"))	what = "d.est_car_no";
		if(s_kd.equals("2"))	what = "h.car_nm||g.car_name";
		if(s_kd.equals("3"))	what = "d.dlv_brch";			
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like '%"+t_wd+"%' ";
		}	

		dt1		= "substr(f.reg_est_dt,1,6)";
		dt2		= "substr(f.reg_est_dt,1,8)";

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("4"))		query += " and "+dt2+" = to_char(sysdate+1,'YYYYMMDD')";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		
		query += " order by f.reg_est_dt, a.rent_dt, e.firm_nm, a.car_st, h.car_nm";

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
			System.out.println("[EtcContDatabase:getRentBoardAcList]\n"+e);
			System.out.println("[EtcContDatabase:getRentBoardAcList]\n"+query);
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

	//��ǰ�غ��Ȳ �����ڷ�
	public Hashtable getRentBoardSubAcCase(String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select '��Ʈ' car_st, d.car_nm, c.car_name, e.car_num, e.est_car_no, e.tmp_drv_no, e.dlv_ext, b.sh_km, \n"+
				"        (b.car_fs_amt) car_amt, \n"+
				"        trunc((b.car_fs_amt)*2/100,-1) tax2, \n"+
				"        trunc((b.car_fs_amt)*3/100,-1) tax3, \n"+
				"        trunc((b.car_fs_amt)*4/100,-1) tax4, \n"+
				"        trunc((b.car_fs_amt)*5/100,-1) tax5, \n"+
				"        trunc((b.car_fs_amt)*6/100,-1) tax6, \n"+
				"        trunc((b.car_fs_amt)*7/100,-1) tax7, \n"+

				"        decode(e.acq_cng_yn,'Y',f.nm,'N','') acq_cng_com, \n"+
				"        f.app_st, substr(c.s_st,1,1) s_st, c.s_st as s_st2, c.diesel_yn, nvl(h.jg_g_7,'') jg_j_7, \n"+
				"        e.pur_pay_dt, a.dlv_dt, e.dlv_est_dt "+
				" from   cont a, car_etc b, car_nm c, car_mng d, car_pur e, fee_etc g, esti_exam h, \n"+
				"        (select * from code where c_st='0003' and code<>'0000') f \n"+
				" where  a.rent_l_cd='"+rent_l_cd+"' \n"+
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and b.car_id=c.car_id and b.car_seq=c.car_seq \n"+
				"        and c.car_comp_id=d.car_comp_id and c.car_cd=d.code \n"+
				"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
				"        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd and g.rent_st='1' \n"+
				"        and g.bc_est_id=h.est_id(+) \n"+
				"        and e.cpt_cd=f.code(+) \n"+				
				" order by e.est_car_no "+
				" ";


		try {
								
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
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
			System.out.println("[AddContDatabase:getRentBoardSubAcCase]\n"+e);
			System.out.println("[AddContDatabase:getRentBoardSubAcCase]\n"+query);
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

	//�߰��� ����������Ȳ�� ����Ʈ ��ȸ
	public Vector getRentBoardInsAcList(String s_kd, String t_wd, String gubun1, String gubun2, String st_dt, String end_dt, String mod_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String r_query = "";

		query = " SELECT e.client_st, e.firm_nm, DECODE(e.client_st,'2',text_decrypt(e.ssn, 'pw'),e.enp_no) ssn, '��Ʈ' car_st, \n"+
				"        H.CAR_NM, g.car_name, d.est_car_no as car_no, d.car_num, \n"+
				"        (f.CAR_fS_AMT + f.CAR_fV_AMT) tot_amt, \n"+
				"        DECODE(s.INSURANT,'1','�Ƹ���ī','2','��') AS insurant, DECODE(s.INSUR_PER,'1','�Ƹ���ī','2','��') AS insur_per, \n"+
				"        a.DRIVING_AGE, a.GCP_KD, a.BACDT_KD, "+
				"        '�̰���' as com_emp_yn, "+
				"        '' b_com_nm, '' b_model_nm, '' b_serial_no, 0 b_amt \n"+
				" from   cont a, fee b, car_reg c, car_pur d, client e, car_etc f, car_nm g, car_mng h, cont_etc s \n"+
				" WHERE  a.car_gu='2' and a.rent_dt>'20161130' and a.car_mng_id is null and nvl(a.use_yn,'Y')='Y' \n"+
				"        and c.init_reg_dt is null \n"+
				"        and d.pur_est_dt is not NULL \n"+
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' \n"+
				" 		 and a.car_mng_id=c.car_mng_id(+) \n"+
				" 		 and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
				" 		 and a.client_id=e.client_id \n"+
				" 		 and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd \n"+
				" 		 and f.car_id=g.car_id and f.car_seq=g.car_seq and g.car_comp_id=h.car_comp_id and g.car_cd=h.code \n"+
				"        and a.rent_mng_id=s.rent_mng_id and a.rent_l_cd=s.rent_l_cd \n"+
				" ";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(s_kd.equals("1"))	what = "d.est_car_no";
		if(s_kd.equals("2"))	what = "h.car_nm||g.car_name";
		if(s_kd.equals("3"))	what = "d.dlv_brch";			
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like '%"+t_wd+"%' ";
		}	

		dt1		= "substr(f.reg_est_dt,1,6)";
		dt2		= "substr(f.reg_est_dt,1,8)";

		if(gubun2.equals("1"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("3"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("4"))		query += " and "+dt2+" = to_char(sysdate+1,'YYYYMMDD')";
		else if(gubun2.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		
		query += " order by f.reg_est_dt, a.rent_dt, e.firm_nm, a.car_st, h.car_nm";


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
			System.out.println("[EtcContDatabase:getRentBoardInsAcList]\n"+e);
			System.out.println("[EtcContDatabase:getRentBoardInsAcList]\n"+query);
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

	//�߰��� ����������Ȳ�� ����Ʈ ��ȸ
	public Hashtable getRentBoardInsAc(String rent_mng_id, String rent_l_cd)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		String r_query = "";

		query = " SELECT e.client_st, e.firm_nm, DECODE(e.client_st,'2',substr(text_decrypt(e.ssn, 'pw'),1,6),e.enp_no) ssn, '��Ʈ' car_st, \n"+
				"        H.CAR_NM, g.car_name, d.est_car_no as car_no, d.car_num, \n"+
				"        (f.CAR_fS_AMT + f.CAR_fV_AMT) tot_amt, \n"+
				"        DECODE(s.INSURANT,'1','�Ƹ���ī','2','��') AS insurant, DECODE(s.INSUR_PER,'1','�Ƹ���ī','2','��') AS insur_per, \n"+
				"        a.DRIVING_AGE, a.GCP_KD, a.BACDT_KD, "+
				"        CASE WHEN e.client_st <> '2' and g.car_name not like '%9�ν�%' AND g.s_st > '101' AND g.s_st < '600' AND g.s_st <> '409' and NVL(s.com_emp_yn,'Y') ='Y' THEN '����' ELSE '�̰���' END com_emp_yn, "+
				"        '' b_com_nm, '' b_model_nm, '' b_serial_no, 0 b_amt ,\n"+
				"        DECODE(s.LKAS_YN,null,'N',s.LKAS_YN) as LKAS_YN, DECODE(s.LDWS_YN,null,'N',s.LDWS_YN) as LDWS_YN, DECODE(s.AEB_YN,null,'N',s.AEB_YN) as AEB_YN, \n"+
				"        DECODE(s.FCW_YN,null,'N',s.FCW_YN) as FCW_YN, DECODE(s.HOOK_YN,null,'N',s.HOOK_YN) as HOOK_YN, DECODE(s.EV_YN,null,'N',s.EV_YN) as EV_YN, opt, s.others_device, \n"+
				"        DECODE(s.LEGAL_YN,null,'N',s.LEGAL_YN) as LEGAL_YN, DECODE(s.top_cng_yn,null,'N',s.top_cng_yn) as top_cng_yn \n"+
				" from   cont a, fee b, car_reg c, car_pur d, client e, car_etc f, car_nm g, car_mng h, cont_etc s \n"+
				" WHERE  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and a.car_gu='2' and a.rent_dt>'20161130' and a.car_mng_id is null and nvl(a.use_yn,'Y')='Y' \n"+
				"        and c.init_reg_dt is null \n"+
				"        and d.pur_est_dt is not NULL \n"+
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' \n"+
				" 		 and a.car_mng_id=c.car_mng_id(+) \n"+
				" 		 and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
				" 		 and a.client_id=e.client_id \n"+
				" 		 and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd \n"+
				" 		 and f.car_id=g.car_id and f.car_seq=g.car_seq and g.car_comp_id=h.car_comp_id and g.car_cd=h.code \n"+
				"        and a.rent_mng_id=s.rent_mng_id and a.rent_l_cd=s.rent_l_cd \n"+
				" ";


		try {
								
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
	    	ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
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
			System.out.println("[EtcContDatabase:getRentBoardInsAc]\n"+e);
			System.out.println("[EtcContDatabase:getRentBoardInsAc]\n"+query);
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

	//�߰��� ����������Ȳ�� ����Ʈ ��ȸ
	public Vector getContBcExtList()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String r_query = "";

		query = " SELECT a.rent_mng_id, a.rent_l_cd, e.rent_st, a.car_mng_id "+
                "  from  cont a,  fee e, fee_etc c, car_pur d, car_etc b, cont_etc f, "+
                "        (select * from cls_cont where cls_st in ('4','5')) y, "+
                "        (select rent_mng_id, rent_l_cd, emp_id from commi where AGNT_ST = '2' ) cm, "+
                "        (select rent_mng_id, rent_l_cd, emp_id, commi, dlv_con_commi, dlv_tns_commi, agent_commi from COMMI where AGNT_ST = '1'  AND (dlv_con_commi+dlv_tns_commi+agent_commi)>0) cm2, "+
                "        (select rent_mng_id, rent_l_cd, emp_id, commi from commi where AGNT_ST = '4' AND commi>0  ) cm3, "+
                "        fee e2, ESTI_EXAM g, "+
                "        (SELECT rent_mng_id, rent_l_cd, emp_id FROM COMMI WHERE agnt_st='1') cm4 "+
                "  WHERE "+
                "        a.car_st NOT IN ('2','4','5') "+
                "        and a.client_id not in ('000231','000228','000539') "+
                "        and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd "+
                "        and e.rent_start_dt >= '20170201' "+
                "        and e.rent_mng_id=c.rent_mng_id and e.rent_l_cd=c.rent_l_cd and e.rent_st = c.rent_st and nvl(c.bc_s_a,0) = 0 "+
                "        and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd "+
                "        and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd "+
                "        and a.rent_mng_id = f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) "+
                "        and a.rent_mng_id = cm.rent_mng_id(+) and a.rent_l_cd=cm.rent_l_cd(+) "+
                "        and a.rent_mng_id = cm2.rent_mng_id(+) and a.rent_l_cd=cm2.rent_l_cd(+) "+
                "        and a.rent_mng_id = cm3.rent_mng_id(+) and a.rent_l_cd=cm3.rent_l_cd(+) "+
                "        and a.rent_mng_id=y.rent_mng_id(+) and a.reg_dt=y.reg_dt(+) "+
                "        and e.rent_mng_id = e2.rent_mng_id(+) and e.rent_l_cd = e2.rent_l_cd(+) and (e.rent_st-1)=e2.rent_st(+) "+
                "        and nvl(y.cls_dt,nvl(e.rent_dt,a.rent_dt))<=nvl(e.rent_dt,a.rent_dt) "+
                "        AND c.bc_est_id=g.est_id(+) "+
                "        and a.rent_mng_id = cm4.rent_mng_id(+) and a.rent_l_cd=cm4.rent_l_cd(+) \n"+
				" ";

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
			System.out.println("[EtcContDatabase:getContBcExtList]\n"+e);
			System.out.println("[EtcContDatabase:getContBcExtList]\n"+query);
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

	/*
	 *	��ຯ�濡 ���� ���躯�� ��û�ϱ�
	*/
	public String call_sp_message_send(String gubun, String sub, String cd1, String cd2, String user_id)
	{
    	getConnection();
    	
    	String query = "{CALL P_MESSAGE_SEND (?,?,?,?,?)}";

		String sResult = "0";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);			
			cstmt.setString(1, gubun);
			cstmt.setString(2, sub);
			cstmt.setString(3, cd1);
			cstmt.setString(4, cd2);
			cstmt.setString(5, user_id);			
			cstmt.execute();
			cstmt.close();			
		} catch (SQLException e) {
			System.out.println("[EtcContDatabase:call_sp_message_send]\n"+e);
			System.out.println("[EtcContDatabase:call_sp_message_send]gubun="+gubun);
			System.out.println("[EtcContDatabase:call_sp_message_send]sub="+sub);
			System.out.println("[EtcContDatabase:call_sp_message_send]cd1="+cd1);
			System.out.println("[EtcContDatabase:call_sp_message_send]cd2="+cd2);
			System.out.println("[EtcContDatabase:call_sp_message_send]user_id="+user_id);
			e.printStackTrace();
			sResult = "1";
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	

	//������
	public Vector getContListAgent_20181022(String s_kd, String t_wd, String andor, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String st_dt, String end_dt, String ck_acar_id, String sa_code)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

			query = " select   \n"+
					"        a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, nvl(d.rent_dt,a.rent_dt) as rent_dt, nvl(c.rent_suc_dt,y.cls_dt) as rent_suc_dt, a.use_yn, \n"+
					"        b.firm_nm, b.client_nm, e.r_site as site_nm, \n"+
					"        j.car_nm, f.car_no, f.init_reg_dt, f.car_doc_no, f.car_num, \n"+
					"        nvl(ec.nm, ec2.nm) car_ext, \n"+
					"        decode(m.rent_st,'1','','����') ext_st, \n"+
					"        decode(m.rent_st,'1','',decode(sign(to_date(d.rent_dt,'YYYYMMDD')-to_date(y.cls_dt,'YYYYMMDD')),1,'����',0,'����','')) ext_st2, \n"+
					"        decode(y.cls_st,'4','��������','5','���°�') cng_st, \n"+
					"        decode(a.rent_st,'1','�ű�','2','����','3','����','4','����','5','����','6','�縮��','7','�縮��') rent_st,  \n"+
					"        decode(a.bus_st, '1','���ͳ�','2','�������','3','��ü�Ұ�','4','ī�޷α�','5','��ȭ���','6','������ü', '7', '������Ʈ','8','�����') bus_st, \n"+
					"        decode(nvl(a.car_gu,a.reg_id),'1','����','0','�縮��','2','�߰���','3','����Ʈ') car_gu, \n"+
					"        decode(a.car_st,'1','��Ʈ','2',decode(a.car_gu,'2','�߰���','����'),'3','����','4','����Ʈ','5','�����뿩') car_st,  \n"+
					"        decode(d.rent_way,'1','�Ϲݽ�','2','�����','3','�⺻��') rent_way, \n"+
				 	"        decode(o.cls_st,'1','��ุ��','2','�ߵ�����','3','�����Һ���','4','��������','5','���°�','6','�Ű�','7','���������','8','���Կɼ�','9','����','10','����������', '15', '����') cls_st, \n"+
					"        a.dlv_dt, d.con_mon as ext_mon, m.con_mon, m.rent_start_dt, m.rent_end_dt,  \n"+
			        "        nvl(decode(d.rent_st, '1', a.bus_id, d.ext_agnt),a.bus_id) bus_id, "+
					"        k.user_nm as bus_nm, k.user_m_tel as bus_m_tel,  \n"+
					"        a.bus_id2, \n"+
					"        n.user_nm bus_nm2, n.user_m_tel as bus2_m_tel,  \n"+
					"        u.user_nm as bus_agnt_nm, \n"+
				    "        z.ins_com_id,\n"+
					"        decode(length(a.sanction),8,decode(sign(to_date(a.sanction,'YYYYMMDD')-to_date(DECODE(sign(to_date(TO_CHAR(SYSDATE,'YYYYMMDD'),'YYYYMMDD')-to_date(nvl(d.rent_dt,a.rent_dt),'YYYYMMDD')),-1,TO_CHAR(SYSDATE,'YYYYMMDD'),nvl(d.rent_dt,a.rent_dt)),'YYYYMMDD')),-1,'�̰�',1,'��û',0,'��û','�̰�'),'�̰�') sanction_st, "+
					"        m.rent_st as fee_rent_st, a.reg_step \n"+
					" from \n"+
					"		 cont a, client b, cont_etc c, fee d, client_site e, car_reg f, \n"+
					"		 car_etc h, car_nm i, car_mng j, users k, "+
					"	     users n, "+
					"	     users u, \n"+
					"		 ( select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, sum(con_mon) con_mon, min(nvl(rent_start_dt,'')) rent_start_dt, max(nvl(rent_end_dt,'')) rent_end_dt \n"+
					"		   from   fee  \n"+
					"          group by rent_mng_id, rent_l_cd \n"+
					"        ) m, \n"+
					"        cls_cont o, \n"+
				    "        ( select rent_mng_id, reg_dt, cls_dt, cls_st from cls_cont where cls_st in ('4','5')) y, \n"+ 
                    "        ( select a.car_mng_id, a.ins_com_id    \n"+ 
                    "          from   insur a, ins_cls b   \n"+ 
                    "          where  a.car_mng_id = b.car_mng_id(+) and a.ins_st = b.ins_st(+)   \n"+ 
                    "                 AND a.ins_start_dt <= TO_CHAR(sysdate-1,'YYYYMMDD')  \n"+ 
                    "                 AND ( (b.car_mng_id IS NULL and a.ins_exp_dt > TO_CHAR(sysdate,'YYYYMMDD'))  OR   (b.car_mng_id IS NOT NULL AND b.exp_dt >  TO_CHAR(sysdate,'YYYYMMDD')) )  \n"+ 
			        "        ) z, \n"+ 
					"        fee_etc mm,  \n"+
					"        (select a.car_mng_id from cont a, commi c \n"+
					"    where  a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd and a.car_gu='2' and c.agnt_st = '6'   AND a.car_mng_id IS NOT NULL group by a.car_mng_id) ac, \n"+ 
					"    (select * from code where c_st='0032') ec, (select * from code WHERE c_st='0032') ec2 \n"+ 
					" where  a.car_st in ('1','3') and a.agent_users like '%"+ck_acar_id+"/%'\n"+
					"        and a.client_id=b.client_id \n"+
					"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
					"        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"+
					"        and a.client_id=e.client_id(+) and a.r_site=e.seq(+) \n"+
					"        and a.car_mng_id=f.car_mng_id(+) \n"+
					"        and a.rent_mng_id=h.rent_mng_id and a.rent_l_cd=h.rent_l_cd \n"+
					"        and h.car_id=i.car_id and h.car_seq=i.car_seq and i.car_comp_id=j.car_comp_id and i.car_cd=j.code \n"+
				    "        AND ((d.RENT_ST='1' AND a.BUS_ID = k.user_id)  OR (d.RENT_ST<>'1' and d.ext_agnt is not null AND d.ext_agnt = k.user_id)  OR (d.RENT_ST<>'1' and d.ext_agnt is null AND a.bus_id = k.user_id )) \n"+
					"        and a.bus_id2=n.user_id \n"+
					"        and d.rent_mng_id=m.rent_mng_id and d.rent_l_cd=m.rent_l_cd and d.rent_st=m.rent_st \n"+
					"        and a.rent_mng_id=o.rent_mng_id(+) and a.rent_l_cd=o.rent_l_cd(+) \n"+
					"        and mm.bus_agnt_id=u.user_id(+) \n"+
					"        and a.rent_mng_id=y.rent_mng_id(+) and a.reg_dt=y.reg_dt(+) \n"+
					"        and a.car_mng_id=z.car_mng_id(+) \n"+
					"        and d.rent_mng_id=mm.rent_mng_id and d.rent_l_cd=mm.rent_l_cd and d.rent_st=mm.rent_st \n"+
					"        and a.car_mng_id=ac.car_mng_id(+) and f.car_ext = ec.nm_cd(+) and h.car_ext = ec2.nm_cd(+) \n"+
					" ";

	
			if(gubun1.equals("Y")) query += " and a.use_yn='Y'";
			if(gubun1.equals("N")) query += " and a.use_yn='N'";
			if(gubun1.equals("0")) query += " and a.use_yn is null";
			if(gubun1.equals("R")) query += " and a.use_yn='Y' and a.car_st='2' ";
			if(gubun1.equals("E")) query += " and a.use_yn='Y' and d.fee_chk='1' ";
			if(gubun1.equals("F")) query += " and nvl(a.use_yn,'Y')='Y' and h.car_origin='2' ";//������
			if(gubun1.equals("C")) query += " and ac.car_mng_id is not null ";//�ڻ�����

			if(gubun3.equals("1"))  query += " and a.car_st<>'2' and d.rent_way='1'";
			if(gubun3.equals("2"))  query += " and a.car_st<>'2' and d.rent_way in ('2','3')";
			if(gubun3.equals("3"))  query += " and a.car_st<>'2' and a.car_gu='1'";
			if(gubun3.equals("4"))  query += " and a.car_st<>'2' and a.car_gu='0'";
			if(gubun3.equals("5"))  query += " and a.car_gu='2'";
			if(gubun3.equals("6"))  query += " and a.car_st<>'2' and d.rent_st<>'1'";
			if(gubun3.equals("7"))  query += " and a.car_st<>'2' and y.cls_st='5'";
			if(gubun3.equals("8"))  query += " and a.car_st<>'2' and y.cls_st='4'";
			if(gubun3.equals("10")) query += " and a.car_st='1'";
			if(gubun3.equals("11")) query += " and a.car_st='3'";
			if(gubun3.equals("9"))  query += " and a.car_st<>'2' and a.bus_st='7'";
			if(gubun3.equals("20")) query += " and a.rent_st in ('3','4') and d.rent_way='3' and d.rent_st='1' and k.loan_st='2' and n.loan_st='2'";
			if(gubun3.equals("12")) query += " and a.car_st<>'2' and d.rent_st='1' and a.rent_st='1'";
			if(gubun3.equals("13")) query += " and a.car_st<>'2' and d.rent_st='1' and a.rent_st='4'";
			if(gubun3.equals("14")) query += " and a.car_st<>'2' and d.rent_st='1' and a.rent_st='3'";
			if(gubun3.equals("15")) query += " and a.car_st='5'";


			if(!gubun2.equals("")) query += " and (c.mng_br_id='"+gubun2+"' OR (c.mng_br_id is null and a.brch_id='"+gubun2+"' ))";

			String search = "";
			String what = "";

			String dt1 = "";
			String dt2 = "";

			//���(����)����
			if(gubun4.equals("1")){

				//���
				if(gubun5.equals("4"))			query += " and ( (d.rent_st='1' and a.rent_dt like to_char(sysdate,'YYYYMM')||'%') or (d.rent_st<>'1' and a.rent_dt like to_char(sysdate,'YYYYMM')||'%') ) ";
				//����
				else if(gubun5.equals("5"))		query += " and ( (d.rent_st='1' and a.rent_dt like to_char(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%') or (d.rent_st<>'1' and a.rent_dt like to_char(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%') ) ";
				//����
                else if(gubun5.equals("1"))		query += " and ( (d.rent_st='1' and a.rent_dt=to_char(sysdate,'YYYYMMDD')) or (d.rent_st<>'1' and d.rent_dt=to_char(sysdate,'YYYYMMDD')) ) ";
				//����				
                else if(gubun5.equals("2"))		query += " and ( (d.rent_st='1' and a.rent_dt=to_char(sysdate-1,'YYYYMMDD')) or (d.rent_st<>'1' and d.rent_dt=to_char(sysdate-1,'YYYYMMDD')) ) ";
				//2��
				else if(gubun5.equals("3"))		query += " and ( (d.rent_st='1' and a.rent_dt between to_char(sysdate-1,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD')) or (d.rent_st<>'1' and d.rent_dt between to_char(sysdate-1,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD')) ) ";
                //�Ⱓ 
				else if(gubun5.equals("6")){
					if(!st_dt.equals("") && !end_dt.equals("")) query += " and ( (d.rent_st='1' and a.rent_dt between '"+st_dt+"' and '"+end_dt+"') or (d.rent_st<>'1' and d.rent_dt between '"+st_dt+"' and '"+end_dt+"') ) ";
				}

			//�°�����
			}else if(gubun4.equals("2")){

				dt1 = "substr(c.rent_suc_dt,1,6)";
				dt2 = "c.rent_suc_dt";

				if(gubun5.equals("4"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";				//���
				else if(gubun5.equals("5"))		query += " and "+dt2+" like TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%'";	//����
				else if(gubun5.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";				//����
				else if(gubun5.equals("2"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";			//����
				else if(gubun5.equals("3"))		query += " and "+dt2+" between to_char(sysdate-1,'YYYYMMDD') and to_char(sysdate,'YYYYMMDD') ";//2��
				else if(gubun5.equals("6")){
					if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between '"+st_dt+"' and '"+end_dt+"'";
				}

			}
			
			if(s_kd.equals("1"))	what = "upper(b.firm_nm||e.r_site)";
			if(s_kd.equals("2"))	what = "a.rent_l_cd";	
			if(s_kd.equals("3"))	what = "f.car_no||' '||f.first_car_no";		
			if(s_kd.equals("4"))	what = "f.car_doc_no";	
			if(s_kd.equals("5"))	what = "f.car_num";	
			if(s_kd.equals("8"))	what = "k.user_nm";	
			if(s_kd.equals("10"))	what = "n.user_nm";	
			if(s_kd.equals("9"))	what = "u.user_nm";	
			if(s_kd.equals("13"))	what = "upper(nvl(b.client_nm||e.site_jang, ' '))";
			if(s_kd.equals("16"))	what = "upper(j.car_nm)";
			if(s_kd.equals("19"))	what = "b.enp_no||TEXT_DECRYPT(b.ssn, 'pw' )||TEXT_DECRYPT(e.enp_no, 'pw' ) ";
			if(s_kd.equals("20"))	what = "i.jg_code";
			if(s_kd.equals("22"))	what = "c.grt_suc_l_cd";
			
			if(!what.equals("") && !t_wd.equals("")){
				if(!s_kd.equals("1") && !s_kd.equals("2") && !s_kd.equals("3") && !gubun1.equals("R") && !gubun1.equals("C"))		query += " and a.car_st<>'2'";				//������ȣ �˻��� �ƴѰ�� �������� ����
				if(t_wd.indexOf("'") != -1)					t_wd = AddUtil.replace(t_wd,"'","");
				if(s_kd.equals("14")||s_kd.equals("17")||s_kd.equals("18"))	t_wd = AddUtil.replace(t_wd,"-","");

				if(s_kd.equals("1")||s_kd.equals("2")||s_kd.equals("13")||s_kd.equals("16")){	
					query += " and "+what+" like upper('%"+t_wd+"%') \n";
				}else{
					query += " and "+what+" like '%"+t_wd+"%' \n";
				}

				if(s_kd.equals("14") && !gubun1.equals("R") && !gubun1.equals("C") && !gubun3.equals("5")) query += " and b.client_id<>'000228'\n";	

				if(s_kd.equals("14")||s_kd.equals("23")) query += " and a.car_st in ('1','3') \n";	 //������� �˻��� ������,����Ʈ�� �������� �ʴ´�.

				if(s_kd.equals("17"))		query += " order by a.use_yn desc, f.init_reg_dt desc, f.car_doc_no desc  \n";
				else  						query += " order by a.use_yn desc, a.rent_dt desc, a.rent_mng_id desc, a.reg_dt desc, a.update_dt desc \n";
			}else{
				//����ȸ�� / GPS���� / ������ / �̽�ĵ / �߰���
				if(gubun1.equals("I") || gubun1.equals("G") || gubun1.equals("R") || gubun1.equals("C") || gubun1.equals("J") || gubun1.equals("E") || gubun3.equals("5")){
				}else{
					if(s_kd.equals("10")){ //���������
						query += " and a.bus_id2 is null order by a.rent_dt, a.rent_start_dt \n";
					}else{
						//������ ����Ʈ
						/*�°������*/query += " and (a.use_yn is null or a.use_yn='Y') and b.client_id<>'000228' and a.car_st in ('1','3','5') \n"; //������ ����Ʈ���� �������� ����Ʈ�� ����

						//�̰�,����,�縮��,����,�°��
						query += " order by decode(y.cls_st,'5',decode(sign(to_date(d.rent_start_dt)-to_date(y.cls_dt,'YYYYMMDD')),1,0,0,0,1),0), "+
							     "          decode(y.cls_st||decode(m.rent_st,'1','',decode(sign(to_date(d.rent_dt,'YYYYMMDD')-to_date(y.cls_dt,'YYYYMMDD')),1,'����',0,'����','')),'5', nvl(c.rent_suc_dt,y.cls_dt), nvl(d.rent_dt,a.rent_dt)) desc, "+
								 "          a.use_yn desc, decode(d.rent_st,'1',1,2), decode(nvl(a.car_gu,a.reg_id),'0','1','2','2','1','3') desc, a.rent_st desc \n";
					}
				}
			}



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
			System.out.println("[EtcContDatabase:getContListAgent_20181022]\n"+e);
			System.out.println("[EtcContDatabase:getContListAgent_20181022]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }

	//������ : �������ó��
	public boolean updateContSanctionCancel2(String m_id, String l_cd, String rent_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query = " update cont set "+
					   "    	sanction_date=(SELECT nvl(chk_dt,reg_dt) FROM fee_etc WHERE rent_mng_id=? and rent_l_cd=? AND rent_st=?), "+
					   "    	sanction     =(SELECT TO_CHAR(nvl(chk_dt,reg_dt),'YYYYMMDD') FROM fee_etc WHERE rent_mng_id=? and rent_l_cd=? AND rent_st=?) "+
					   "    	where rent_mng_id=? and rent_l_cd=? ";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, m_id);
			pstmt.setString(2, l_cd);
			pstmt.setString(3, rent_st);
			pstmt.setString(4, m_id);
			pstmt.setString(5, l_cd);
			pstmt.setString(6, rent_st);
			pstmt.setString(7, m_id);
			pstmt.setString(8, l_cd);
			pstmt.executeUpdate();
		    pstmt.close();
		    conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddContDatabase:updateContSanctionCancel2]\n"+e);
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

	//������ �����ϱ�
	public boolean deleteContExt(String rent_mng_id, String rent_l_cd, String rent_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;
		PreparedStatement pstmt5 = null;
		PreparedStatement pstmt6 = null;
		PreparedStatement pstmt7 = null;

		boolean flag = true;

		String query1  = " update cont set "+
					     "    	rent_end_dt=(SELECT max(rent_end_dt) rent_end_dt FROM fee WHERE rent_mng_id=? and rent_l_cd=? AND rent_st=to_char(to_number(?)-1)) "+
					     "    	where rent_mng_id=? and rent_l_cd=? ";
		String query2  = " delete from fee			    where rent_mng_id=? and rent_l_cd=? and rent_st=?";
		String query3  = " delete from fee_etc			where rent_mng_id=? and rent_l_cd=? and rent_st=?";
		String query4  = " delete from scd_ext			where rent_mng_id=? and rent_l_cd=? and rent_st=?";
		String query5  = " delete from gua_ins			where rent_mng_id=? and rent_l_cd=? and rent_st=?";
		String query6  = " update fine set rent_st=to_char(to_number(?)-1) where rent_mng_id=? and rent_l_cd=? and rent_st=? ";
		String query7  = " update stat_rent_month set fee_rent_st=to_char(to_number(?)-1) where rent_mng_id=? and rent_l_cd=? and fee_rent_st=? ";

//		System.out.println("[AddContDatabase:deleteContExt ������ ����]\n"+rent_l_cd+", "+rent_st);

		try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query1);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			pstmt.setString(3, rent_st);
			pstmt.setString(4, rent_mng_id);
			pstmt.setString(5, rent_l_cd);
		    pstmt.executeUpdate();
			pstmt.close();

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, rent_mng_id);
			pstmt2.setString(2, rent_l_cd);
			pstmt2.setString(3, rent_st);
		    pstmt2.executeUpdate();
			pstmt2.close();

			pstmt3 = conn.prepareStatement(query3);
			pstmt3.setString(1, rent_mng_id);
			pstmt3.setString(2, rent_l_cd);
			pstmt3.setString(3, rent_st);
		    pstmt3.executeUpdate();
			pstmt3.close();

			pstmt4 = conn.prepareStatement(query4);
			pstmt4.setString(1, rent_mng_id);
			pstmt4.setString(2, rent_l_cd);
			pstmt4.setString(3, rent_st);
		    pstmt4.executeUpdate();
			pstmt4.close();

			pstmt5 = conn.prepareStatement(query5);
			pstmt5.setString(1, rent_mng_id);
			pstmt5.setString(2, rent_l_cd);
			pstmt5.setString(3, rent_st);
		    pstmt5.executeUpdate();
			pstmt5.close();

			pstmt6 = conn.prepareStatement(query6);
			pstmt6.setString(1, rent_st);
			pstmt6.setString(2, rent_mng_id);
			pstmt6.setString(3, rent_l_cd);
			pstmt6.setString(4, rent_st);
		    pstmt6.executeUpdate();
			pstmt6.close();

			pstmt7 = conn.prepareStatement(query7);
			pstmt7.setString(1, rent_st);
			pstmt7.setString(2, rent_mng_id);
			pstmt7.setString(3, rent_l_cd);
			pstmt7.setString(4, rent_st);
		    pstmt7.executeUpdate();
			pstmt7.close();

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[AddContDatabase:deleteContExt]\n"+e);
	  		e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt3 != null)	pstmt3.close();
				if(pstmt4 != null)	pstmt4.close();
				if(pstmt5 != null)	pstmt5.close();
				if(pstmt6 != null)	pstmt6.close();
				if(pstmt7 != null)	pstmt7.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}	

	//�ڵ�������Ȱ������
	public Vector getComDirDocList(String s_kd, String t_wd, String s_dt, String e_dt, String gubun1, String gubun2, String gubun3)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

			query = " SELECT a.doc_no, b.use_yn, b.rent_mng_id, b.rent_l_cd, b.rent_dt, c.rent_start_dt, d.firm_nm, e.car_no, e.car_nm, f.user_nm AS bus_nm,  \r\n" + 
					"       decode(b.rent_st,'1','�ű�','2','����','3','����','4','����','5','����','6','�縮��','7','�縮��') rent_st, "+
					"       decode(b.bus_st, '1','���ͳ�','2','�������','3','��ü�Ұ�','4','ī�޷α�','5','��ȭ���','6','������ü', '7', '������Ʈ','8','�����') bus_st,\r\n" + 
					"       decode(h.pur_bus_st, '1','��ü����','2','�����������','4','������Ʈ') pur_bus_st,\r\n" + 
					"       DECODE(h.dir_pur_yn,'Y','Ư�����','��Ÿ(��ü)���') dir_pur_yn,\r\n" + 
					"       DECODE(g.dlv_con_commi_yn,'Y','����','����') dlv_con_commi_yn, \r\n" + 
					"       DECODE(g.dir_pur_commi_yn,'Y','�����̰�����','N','�����̰��Ұ���') dir_pur_commi_yn,\r\n" + 
					"       DECODE(a.doc_no,'','�̵��','���') doc_reg_st, a.user_dt1\r\n" + 
					"FROM   cont b, (SELECT * FROM doc_settle WHERE doc_st='17') a, fee c, client d, car_reg e, users f, cont_etc g, car_pur h, car_etc i, car_nm j\r\n" + 
					"WHERE  b.rent_dt >= '20190610' AND b.car_gu='1'\r\n" + 
					"       AND b.rent_l_cd=a.doc_id(+)\r\n" + 
					"       AND b.rent_mng_id=c.rent_mng_id AND b.rent_l_cd=c.rent_l_cd AND c.RENT_ST='1'\r\n" + 
					"       AND b.client_id=d.client_id AND d.client_st='1'\r\n" + 
					"       AND b.car_mng_id=e.car_mng_id \r\n" + 
					"       AND b.BUS_ID=f.user_id\r\n" + 
					"       AND b.rent_mng_id=g.rent_mng_id AND b.rent_l_cd=g.rent_l_cd\r\n" + 
					"       AND b.rent_mng_id=h.rent_mng_id AND b.rent_l_cd=h.rent_l_cd AND h.dir_pur_yn='Y' \r\n" +  //AND h.pur_bus_st<>'4' 
					"       AND b.rent_mng_id=i.rent_mng_id AND b.rent_l_cd=i.rent_l_cd\r\n" +  
					"       AND i.car_id=j.car_id AND i.car_seq=j.car_seq AND j.car_comp_id='0001' ";

			if(gubun1.equals(""))  gubun1 = "2";
			
			//����
			if(gubun1.equals("1")) query += " AND c.rent_start_dt BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'01' AND TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'31'";
			//���
			if(gubun1.equals("2")) query += " AND c.rent_start_dt BETWEEN TO_CHAR(SYSDATE,'YYYYMM')||'01' AND TO_CHAR(SYSDATE,'YYYYMM')||'31'";
			//�Ⱓ
			if(gubun1.equals("3")){				
				if(!s_dt.equals("") && !e_dt.equals("")) query += " AND c.rent_start_dt between replace('"+s_dt+"', '-','') and replace('"+e_dt+"', '-','') \n";
			}

			if(!gubun2.equals("")) query += " AND f.user_nm = '"+gubun2+"' ";

			String search = "";
			String what = "";
			
			if(s_kd.equals("1"))	what = "d.firm_nm";
			if(s_kd.equals("2"))	what = "e.CAR_NM||j.car_name";		
			
			if(!what.equals("") && !t_wd.equals(""))	query += " and "+what+" like '%"+t_wd+"%'  \n";

			query += " ORDER BY c.rent_start_dt desc";

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
			System.out.println("[EtcContDatabase:getComDirDocList]\n"+e);
			System.out.println("[EtcContDatabase:getComDirDocList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
    }
	
	//������Ű��ϰ���
		public Vector getDigitalKeyList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
			String search = "";
			String what = "";
			
			query = " --������Ű\r\n" + 
					"           SELECT a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.enp_no, DECODE(h.rent_suc_dt,'','','�°�') suc_st,\r\n" + 
					"			            c.init_reg_dt, c.car_no, c.car_num, nvl(c.car_nm,e2.car_nm) car_nm, e.car_name, e.car_comp_id, d.opt, \r\n" + 
					"					        f.user_nm AS bus_nm, f2.user_nm AS bus_nm2, \r\n" + 
					"                  g.reg_id, g.reg_dt, g.com_reg_dt, g.com_cls_dt, g.firm_nm AS com_firm_nm, g.etc, g.firm_tel, replace(g.firm_tel,'-','') firm_tel2, g.start_dt, g.end_dt    \r\n" + 
					"					 FROM   cont a, client b, car_reg c, car_etc d, car_nm e, car_mng e2, users f, users f2, car_key_digital g, cont_etc h, fee i \r\n" + 
					"					 WHERE  a.client_id=b.client_id \r\n" + 
					"					        AND a.car_mng_id=c.car_mng_id \r\n" + 
					"					        AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd \r\n" + 
					"					        AND d.car_id=e.car_id AND d.car_seq=e.car_seq and e.car_comp_id=e2.car_comp_id and e.car_cd=e2.code \r\n" + 
					"					        AND a.BUS_ID=f.user_id\r\n" + 
					"                  AND a.BUS_ID2=f2.user_id\r\n" + 
					"                  AND a.rent_mng_id=h.rent_mng_id AND a.rent_l_cd=h.rent_l_cd\r\n" + 
					"                  AND a.rent_mng_id=i.rent_mng_id AND a.rent_l_cd=i.rent_l_cd and i.rent_st='1' and i.rent_start_dt is not null		  \r\n" + //
					//"                  and e.jg_code in ('2176','2177','3191','3192','3193','3276','3277','3278','3279','4149','4150','5171','5172','5173','5271','5272','5273','5274','6161','6162','6271','6272') \r\n"+
					/*
					"                  AND (\r\n" + 
					"                        ( c.car_nm = '�Ÿ DN8' AND e.car_name LIKE '%����Ʈ%����Ʈ%' AND REPLACE(d.opt,' ','') LIKE '%����Ʈ���̽�%' ) OR\r\n" + 
					"                        ( c.car_nm = '�Ÿ DN8' AND e.car_name LIKE '%�����%����Ʈ%' AND REPLACE(d.opt,' ','') LIKE '%����Ʈ���̽�%' ) OR\r\n" +
					"                        ( c.car_nm = '�Ÿ DN8' AND e.car_name LIKE '%�����̾�' AND REPLACE(d.opt,' ','') LIKE '%��Ƽ�̵����÷���%' ) OR\r\n" + 
					"                        ( c.car_nm = '�Ÿ DN8' AND e.car_name LIKE '%�����̾�%�йи�%' AND REPLACE(d.opt,' ','') LIKE '%��Ƽ�̵����÷���2%') OR\r\n" + 
					"                        ( c.car_nm = '�Ÿ DN8' AND e.car_name LIKE '%�����̾�%�йи�%' AND REPLACE(d.opt,' ','') LIKE '%����Ʈ��ũ%') OR\r\n" +
					"                        ( c.car_nm = '�Ÿ DN8' AND e.car_name LIKE '%�����̾�%�з��Ͼ�%' ) OR\r\n" + 
					"                        ( c.car_nm = '�Ÿ DN8' AND e.car_name LIKE '%�ν��۷��̼�%' ) OR\r\n" + 
					"                        ( c.car_nm = '�Ÿ DN8 ���̺긮��' AND e.car_name LIKE '%����Ʈ%' AND REPLACE(d.opt,' ','') LIKE '%����Ʈ���̽�%' ) OR\r\n" + 
					"                        ( c.car_nm = '�Ÿ DN8 ���̺긮��' AND e.car_name LIKE '%�����̾�%' AND REPLACE(d.opt,' ','') LIKE '%��Ƽ�̵����÷�����%'  ) OR\r\n" +
					"                        ( c.car_nm = '�Ÿ DN8 ���̺긮��' AND e.car_name LIKE '%�����̾�%�йи�%' AND REPLACE(d.opt,' ','') LIKE '%����Ʈ��ũ%') OR\r\n" +
					"                        ( c.car_nm = '�Ÿ DN8 ���̺긮��' AND e.car_name LIKE '%�����̾�%�з��Ͼ�%' ) OR\r\n" + 
					"                        ( c.car_nm = '�Ÿ DN8 ���̺긮��' AND e.car_name LIKE '%�ν��۷��̼�%' ) OR\r\n" + 
					"                        ( c.car_nm = '�Ÿ DN8 LPG' AND e.car_name LIKE '%����Ʈ%����Ʈ%' AND REPLACE(d.opt,' ','') LIKE '%����Ʈ���̽�3%' ) OR\r\n" + 
					"                        ( c.car_nm = '�Ÿ DN8 LPG' AND e.car_name LIKE '%����Ʈ%����Ʈ%' AND REPLACE(d.opt,' ','') LIKE '%����Ʈ���̽���%'  ) OR\r\n" +
					"                        ( c.car_nm = '�Ÿ DN8 LPG' AND e.car_name LIKE '%���%' AND REPLACE(d.opt,' ','') LIKE '%��Ƽ�̵����÷���2%') OR\r\n" + 
					"                        ( c.car_nm = '�Ÿ DN8 LPG' AND e.car_name LIKE '%���%' AND REPLACE(d.opt,' ','') LIKE '%��Ƽ�̵����÷�����%') OR\r\n" +
					"                        ( c.car_nm = '�Ÿ DN8 LPG' AND e.car_name LIKE '%�����̾�%%' ) OR\r\n" + 
					"                        ( c.car_nm = '�Ÿ DN8 LPG' AND e.car_name LIKE '%�ν��۷��̼�%' ) OR\r\n" + 
					"                        ( c.car_nm = '���׽ý� GV80' ) OR\r\n" + 
					"                        ( c.car_nm = '���׽ý� G80 (RG3)' and e.car_cd='111' ) OR\r\n" +					
					"                        ( e.car_comp_id='0002' AND REPLACE(d.opt,' ','') LIKE '%����ƮĿ��Ʈ%' )\r\n" + 
					"                      )\r\n" + 
					*/
					"                  AND a.rent_mng_id=g.rent_mng_id(+) AND a.rent_l_cd=g.rent_l_cd(+)   \r\n" + 
				    " ";

				if(gubun1.equals("3"))	query += " and a.use_yn='Y' and g.com_reg_dt is null "; //�̵��
				if(gubun1.equals("4"))	query += " and g.com_reg_dt is not null "; //���
				if(gubun1.equals("2"))	query += " and g.reg_dt is not null and com_reg_dt is null "; //��û
				
				if(s_kd.equals("1"))	what = "upper(b.firm_nm)||g.firm_nm";
				if(s_kd.equals("2"))	what = "a.rent_l_cd";	
				if(s_kd.equals("3"))	what = "c.car_no";		
				if(s_kd.equals("5"))	what = "c.car_nm||e.car_name";	
				if(s_kd.equals("6"))	what = "c.init_reg_dt";	
				if(s_kd.equals("7"))	what = "f.user_nm||f2.user_nm";
				
				if(!what.equals("") && !t_wd.equals("")){
					if(t_wd.indexOf("'") != -1)					t_wd = AddUtil.replace(t_wd,"'","");

					if(s_kd.equals("1")||s_kd.equals("2")){	
						query += " and "+what+" like upper('%"+t_wd+"%') \n";
					}else if(s_kd.equals("6")){	
						query += " and "+what+" like replace('%"+t_wd+"%','-','') \n";
					}else{
						query += " and "+what+" like '%"+t_wd+"%' \n";
					}
					query += " order by c.init_reg_dt desc, a.rent_dt \n";
					
				}else{
					if(gubun1.equals("3"))	query += " order by decode(c.init_reg_dt,'',1,0), decode(g.reg_dt,'',1,0), g.reg_dt desc, c.init_reg_dt desc, a.rent_dt \n";					
					if(gubun1.equals("4"))	query += " order by g.com_reg_dt desc \n";
				}


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
				System.out.println("[EtcContDatabase:getDigitalKeyList]\n"+e);
				System.out.println("[EtcContDatabase:getDigitalKeyList]\n"+query);
		  		e.printStackTrace();
			} finally {
				try{
	                if(rs != null) rs.close();
	                if(pstmt != null) pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return vt;
			}
	    }
		
		//������Ű��������
		public Vector getDigitalKeyClsList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
			String search = "";
			String what = "";
			
			query = " --������Ű\r\n" + 
					"           SELECT a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.enp_no, DECODE(h.rent_suc_dt,'','','�°�') suc_st,\r\n" + 
					"			       c.init_reg_dt, c.car_no, c.car_num, c.car_nm, e.car_comp_id,  \r\n" + 
					"				   f.user_nm AS bus_nm, f2.user_nm AS bus_nm2, "+
					"                  decode(i.cls_st,'1','��ุ��','2','�ߵ�����','3','�����Һ���','4','��������','5','����̰�','6','�Ű�','7','���������','8','���Կɼ�','9','����','10','����������') cls_st, i.cls_dt, \r\n" + 
					"                  g.reg_id, g.reg_dt, g.com_reg_dt, g.com_cls_dt, g.firm_nm AS com_firm_nm, g.etc, g.firm_tel, replace(g.firm_tel,'-','') firm_tel2, g.start_dt, g.end_dt \r\n" + 
					"					 FROM   cont a, client b, car_reg c, car_etc d, car_nm e, users f, users f2, car_key_digital g, cont_etc h, cls_cont i \r\n" + 
					"					 WHERE  "
					+ "a.use_yn='N' and "
					+ " a.client_id=b.client_id \r\n" + 
					"					        AND a.car_mng_id=c.car_mng_id \r\n" + 
					"					        AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd \r\n" + 
					"					        AND d.car_id=e.car_id AND d.car_seq=e.car_seq \r\n" + 
					"					        AND a.BUS_ID=f.user_id\r\n" + 
					"                  AND a.BUS_ID2=f2.user_id\r\n" + 
					"                  AND a.rent_mng_id=h.rent_mng_id AND a.rent_l_cd=h.rent_l_cd\r\n" + 
					"                  AND a.rent_mng_id=g.rent_mng_id AND a.rent_l_cd=g.rent_l_cd \r\n" + 
					"                  AND a.rent_mng_id=i.rent_mng_id AND a.rent_l_cd=i.rent_l_cd \r\n" +
				    " ";

				if(gubun1.equals("3"))	query += " and g.com_cls_dt is null "; //�̵��
				if(gubun1.equals("4"))	query += " and g.com_cls_dt is not null "; //���
				
				if(s_kd.equals("1"))	what = "upper(b.firm_nm)||g.firm_nm";
				if(s_kd.equals("2"))	what = "a.rent_l_cd";	
				if(s_kd.equals("3"))	what = "c.car_no";		
				if(s_kd.equals("5"))	what = "c.car_nm||e.car_name";	
				if(s_kd.equals("6"))	what = "c.init_reg_dt";	
				if(s_kd.equals("7"))	what = "f.user_nm||f2.user_nm";
				
				if(!what.equals("") && !t_wd.equals("")){
					if(t_wd.indexOf("'") != -1)					t_wd = AddUtil.replace(t_wd,"'","");

					if(s_kd.equals("1")||s_kd.equals("2")){	
						query += " and "+what+" like upper('%"+t_wd+"%') \n";
					}else if(s_kd.equals("6")){	
						query += " and "+what+" like replace('%"+t_wd+"%','-','') \n";
					}else{
						query += " and "+what+" like '%"+t_wd+"%' \n";
					}
					query += " order by c.init_reg_dt desc \n";
					
				}else{
					if(gubun1.equals("3"))	query += " order by i.cls_dt desc \n";					
					if(gubun1.equals("4"))	query += " order by g.com_cls_dt desc \n";
				}


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
				System.out.println("[EtcContDatabase:getDigitalKeyClsList]\n"+e);
				System.out.println("[EtcContDatabase:getDigitalKeyClsList]\n"+query);
		  		e.printStackTrace();
			} finally {
				try{
	                if(rs != null) rs.close();
	                if(pstmt != null) pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return vt;
			}
	    }		
		
		//������Ű ����
		public boolean updateCarDigitalKey(String gubun, String m_id, String l_cd, String act_dt, String act_id)
		{
			getConnection();
			PreparedStatement pstmt = null;
			boolean flag = true;
			
			String query = " update car_key_digital set ";
			
			if(gubun.equals("com_reg")) {
				query += " com_reg_dt=replace(?,'-',''), com_reg_id=? ";
			}
				
			if(gubun.equals("com_cls")) {
				query += " com_cls_dt=replace(?,'-',''), com_cls_id=? ";
			}

			query += " where RENT_MNG_ID=? and RENT_L_CD=? ";
			
			try 
			{
				conn.setAutoCommit(false);

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, act_dt);
				pstmt.setString(2, act_id);
				pstmt.setString(3, m_id);
				pstmt.setString(4, l_cd);				
			    pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
			    
		  	} catch (Exception e) {
				System.out.println("[EtcContDatabase:updateCarDigitalKey]\n"+e);
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
		
		//������Ű ���
		public boolean insertCarDigitalKey(Hashtable ht)
		{
			getConnection();
			PreparedStatement pstmt = null;
			boolean flag = true;
			
			String query = " insert into car_key_digital\r\n" + 
					"	     (rent_mng_id, rent_l_cd, reg_id,\r\n" + 
					"         firm_nm, etc, firm_tel,\r\n" + 
					"         start_dt, end_dt\r\n" + 
					"        ) values\r\n" + 
					"	     (?, ?, ?, ?, ?, REPLACE(?,'-',''), REPLACE(?,'-',''), REPLACE(?,'-','') \r\n" +
					"        ) ";
			
			try 
			{
				conn.setAutoCommit(false);

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, String.valueOf(ht.get("RENT_MNG_ID")));
				pstmt.setString(2, String.valueOf(ht.get("RENT_L_CD")));
				pstmt.setString(3, String.valueOf(ht.get("REG_ID")));
				pstmt.setString(4, String.valueOf(ht.get("FIRM_NM")));				
				pstmt.setString(5, String.valueOf(ht.get("ETC")));
				pstmt.setString(6, String.valueOf(ht.get("FIRM_TEL")));
				pstmt.setString(7, String.valueOf(ht.get("START_DT")));
				pstmt.setString(8, String.valueOf(ht.get("END_DT")));
			    pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
			    
		  	} catch (Exception e) {
				System.out.println("[EtcContDatabase:insertCarDigitalKey]\n"+e);
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
		
		//������Ű ����
		public boolean updateCarDigitalKey(Hashtable ht)
		{
			getConnection();
			PreparedStatement pstmt = null;
			boolean flag = true;
			
			String query = " update car_key_digital set firm_nm=?, etc=?, firm_tel=REPLACE(?,'-',''), start_dt=REPLACE(?,'-',''), end_dt=REPLACE(?,'-','') ";
			
			query += " where RENT_MNG_ID=? and RENT_L_CD=? ";
			
			try 
			{
				conn.setAutoCommit(false);

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, String.valueOf(ht.get("FIRM_NM")));				
				pstmt.setString(2, String.valueOf(ht.get("ETC")));
				pstmt.setString(3, String.valueOf(ht.get("FIRM_TEL")));
				pstmt.setString(4, String.valueOf(ht.get("START_DT")));
				pstmt.setString(5, String.valueOf(ht.get("END_DT")));
				pstmt.setString(6, String.valueOf(ht.get("RENT_MNG_ID")));
				pstmt.setString(7, String.valueOf(ht.get("RENT_L_CD")));
			    pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
			    
		  	} catch (Exception e) {
				System.out.println("[EtcContDatabase:updateCarDigitalKey]\n"+e);
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
		
		//������Ű ����
		public boolean deleteCarDigitalKey(Hashtable ht)
		{
			getConnection();
			PreparedStatement pstmt = null;
			boolean flag = true;
			
			String query = " delete from car_key_digital where RENT_MNG_ID=? and RENT_L_CD=? ";
			
			try 
			{
				conn.setAutoCommit(false);

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, String.valueOf(ht.get("RENT_MNG_ID")));
				pstmt.setString(2, String.valueOf(ht.get("RENT_L_CD")));
			    pstmt.executeUpdate();
				pstmt.close();
				
				conn.commit();
			    
		  	} catch (Exception e) {
				System.out.println("[EtcContDatabase:deleteCarDigitalKey]\n"+e);
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
		
		public Hashtable getDigitalKey(String m_id, String l_cd)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Hashtable ht = new Hashtable();
	        String query = "";

			query = " select * from car_key_digital where rent_mng_id='"+m_id+"' and rent_l_cd='"+l_cd+"' ";

			try {
					pstmt = conn.prepareStatement(query);
			    	rs = pstmt.executeQuery();
		    		ResultSetMetaData rsmd = rs.getMetaData();
				while(rs.next())
				{				
					for(int pos =1; pos <= rsmd.getColumnCount();pos++)
					{
						 String columnName = rsmd.getColumnName(pos);
						 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim()/**/);
					}
				}
				rs.close();
				pstmt.close();
			} catch (SQLException e) {
				System.out.println("[EtcContDatabase:getDigitalKey]"+ e);
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
		
		

		//�ɻ��ڷ�
		public Vector getContReviewList(String client_id)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
			String search = "";
			String what = "";
			
			query = " SELECT DISTINCT\r\n" + 
					"       a.use_yn, DECODE(a.use_yn,'Y','����','N','����','�̰�') use_yn_nm, \r\n" + 
					"       g.car_no, g.car_nm,\r\n" + 
					"       a.rent_l_cd, \r\n" + 
					"       DECODE(d.rent_st,'1',a.rent_dt,d.rent_dt) rent_dt, \r\n" + 
					"       d.rent_st,  \r\n" + 
					"       DECODE(a.car_gu,'0','�縮��','1','����','2','�߰���') car_gu,\r\n" + 
					"       DECODE(a.car_st,'1','��Ʈ','3','����','4','����Ʈ') car_st, \r\n" + 
					"       DECODE(d.rent_way,'3','�⺻��','�Ϲݽ�') rent_way,\r\n" + 
					"       DECODE(b.rent_suc_dt,'',DECODE(d.rent_st,'1',decode(a.rent_st,'1','�ű�','3','����','4','����','�ű�'),TO_NUMBER(d.rent_st)-1||'������'),'���°�') rent_type,\r\n" + 
					"       DECODE(f.cls_st,'1','��ุ��','2','�ߵ�����','3','�����Һ���','4','��������','5','���°�','6','�Ű�','7','���������','8','���Կɼ�','9','����','10','����������', '15', '����','-') cls_st, \r\n" +
					"       decode(a.bus_st, '1','���ͳ�','2','�������','3','��ü�Ұ�','4','ī�޷α�','5','��ȭ���','6','������ü', '7', '������Ʈ','8','�����') bus_st,\r\n" + 					
					"       d.con_mon,\r\n" + 
					"       b.rent_suc_dt, d2.rent_start_dt, \r\n" + 
					"       f.cls_dt, d2.rent_end_dt,   \r\n" + 
					"       b.dec_etc, --�ſ���\r\n" + 
					"       c.remark, --�뿩����\r\n" + 
					"       a.others, --�������\r\n" + 
					"       d.fee_cdt, --�뿩���\r\n" +
					"       e.con_etc, --��༭Ư�����\r\n" +
					"       e.bc_etc, --����ȿ��\r\n" + 
					"       e.bus_cau, --���ü�����\r\n" + 
					"       b.cls_etc, --�������\r\n" + 
					"       NVL(h.tot_serv_cnt,0) tot_serv_cnt, NVL(h.tot_serv_amt,0) tot_serv_amt, --������Ȳ \r\n" + 
					"       NVL(h.tot_serv_amt1,0) tot_serv_amt1, NVL(h.tot_serv_amt2,0) tot_serv_amt2, NVL(h.tot_serv_amt3,0) tot_serv_amt3, \r\n" + 
					"       NVL(h.tot_serv_amt4,0) tot_serv_amt4, NVL(h.tot_serv_amt5,0) tot_serv_amt5, NVL(h.tot_serv_amt6,0) tot_serv_amt6, NVL(h.tot_serv_amt7,0) tot_serv_amt7,\r\n" + 
					"       NVL(i.tot_accid_cnt,0) tot_accid_cnt, --�����Ȳ\r\n" + 
					"       NVL(j1.dly_cnt,0) dly_cnt1, NVL(j1.dly_amt,0) dly_amt1, --��ü��Ȳ,\r\n" + 
					"       NVL(j2.dly_cnt,0) dly_cnt2, NVL(j2.dly_amt,0) dly_amt2, --��ü��Ȳ,\r\n" +
					"       NVL(j3.dly_cnt,0) dly_cnt3, NVL(j3.dly_amt,0) dly_amt3, --��ü��Ȳ,\r\n" +
					"       NVL(k.over_dist,0) over_dist, NVL(k.r_over_amt,0) r_over_amt --�ʰ������߰��뿩��       \r\n" + 
					"FROM   cont a, cont_etc b, car_etc c, fee d, fee_etc e, cls_cont f, car_reg g, \r\n" +
					"       (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt from fee group by rent_mng_id, rent_l_cd) d2, \r\n"+
					"       (SELECT b.rent_mng_id, b.car_mng_id, COUNT(0) tot_serv_cnt, SUM(b.tot_amt) tot_serv_amt,\r\n" + 
					"               SUM(DECODE(b.serv_st,'1',b.tot_amt)) tot_serv_amt1,\r\n" + 
					"               SUM(DECODE(b.serv_st,'2',b.tot_amt)) tot_serv_amt2,\r\n" + 
					"               SUM(DECODE(b.serv_st,'3',b.tot_amt)) tot_serv_amt3,\r\n" + 
					"               SUM(DECODE(b.serv_st,'7',b.tot_amt)) tot_serv_amt4,\r\n" + 
					"               SUM(DECODE(b.serv_st,'11',b.tot_amt)) tot_serv_amt5,\r\n" + 
					"               SUM(DECODE(b.serv_st,'12',b.tot_amt)) tot_serv_amt6,\r\n" + 
					"               SUM(DECODE(b.serv_st,'13',b.tot_amt)) tot_serv_amt7\r\n" + 
					"        FROM cont a, service b \r\n" + 
					"        WHERE a.client_id='"+client_id+"' AND a.rent_mng_id=b.rent_mng_id AND b.tot_amt>0 \r\n" + 
					"        GROUP BY b.rent_mng_id, b.car_mng_id ) h,\r\n" + 
					"       (SELECT b.rent_mng_id, b.car_mng_id, COUNT(0) tot_accid_cnt \r\n" + 
					"        FROM cont a, accident b \r\n" + 
					"        WHERE a.client_id='"+client_id+"' AND a.rent_mng_id=b.rent_mng_id  \r\n" + 
					"        GROUP BY b.rent_mng_id, b.car_mng_id ) i,\r\n" + 
					"       ( SELECT  b.rent_mng_id, b.rent_l_cd, COUNT(0) dly_cnt, SUM(b.ext_s_amt+b.ext_v_amt) dly_amt\r\n" + 
					"              FROM cont a, scd_ext b\r\n" + 
					"              WHERE a.client_id='"+client_id+"' AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \r\n" + 
					"              AND b.bill_yn='Y' AND (b.ext_s_amt+b.ext_v_amt) >0 AND b.ext_pay_dt IS NULL\r\n" + 
					"              GROUP BY b.rent_mng_id, b.rent_l_cd) j1, \r\n" + 
					"       (SELECT  b.rent_mng_id, b.rent_l_cd, "+
					"                COUNT(0) dly_cnt, SUM(b.fee_s_amt+b.fee_v_amt) dly_amt\r\n" + 
					"              FROM cont a, scd_fee b\r\n" + 
					"              WHERE a.client_id='"+client_id+"' AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \r\n" + 
					"              AND b.bill_yn='Y' AND (b.fee_s_amt+b.fee_v_amt) >0 and b.tm_st2<>'4' AND b.rc_dt IS NULL AND b.r_fee_est_dt < TO_CHAR(SYSDATE,'YYYYMMDD')\r\n" + 
					"              GROUP BY b.rent_mng_id, b.rent_l_cd) j2,  \r\n" + 
					"       (SELECT  b.rent_mng_id, b.rent_l_cd, "+
					"                SUM(b.dly_days) dly_cnt, SUM(b.dly_fee) dly_amt\r\n" + 
					"              FROM cont a, scd_fee b\r\n" + 
					"              WHERE a.client_id='"+client_id+"' AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \r\n" + 					 
					"              GROUP BY b.rent_mng_id, b.rent_l_cd) j3,  \r\n" + 
					"       cls_etc_over k   \r\n" + 
					"WHERE  a.client_id='"+client_id+"'\r\n" + 
					"       AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \r\n" + 
					"       AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd\r\n" + 
					"       AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd \r\n" +
					"       AND d.rent_mng_id=d2.rent_mng_id AND d.rent_l_cd=d2.rent_l_cd and d.rent_st=d2.rent_st \r\n" +
					"       AND d.rent_mng_id=e.rent_mng_id AND d.rent_l_cd=e.rent_l_cd and d.rent_st=e.rent_st \r\n" + 
					"       AND a.rent_mng_id=f.rent_mng_id(+) AND a.rent_l_cd=f.rent_l_cd(+)\r\n" + 
					"       AND a.car_mng_id=g.car_mng_id(+)\r\n" + 
					"       AND a.rent_mng_id=h.rent_mng_id(+) AND a.car_mng_id=h.car_mng_id(+)\r\n" + 
					"       AND a.rent_mng_id=i.rent_mng_id(+) AND a.car_mng_id=i.car_mng_id(+)\r\n" + 
					"       AND a.rent_mng_id=j1.rent_mng_id(+) AND a.rent_l_cd=j1.rent_l_cd(+)\r\n" + 
					"       AND a.rent_mng_id=j2.rent_mng_id(+) AND a.rent_l_cd=j2.rent_l_cd(+)\r\n" +
					"       AND a.rent_mng_id=j3.rent_mng_id(+) AND a.rent_l_cd=j3.rent_l_cd(+)\r\n" +
					"       AND a.rent_mng_id=k.rent_mng_id(+) AND a.rent_l_cd=k.rent_l_cd(+)\r\n" + 
					"ORDER BY 6, 5 \r\n" +
				    " ";

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
				System.out.println("[EtcContDatabase:getContReviewList]\n"+e);
				System.out.println("[EtcContDatabase:getContReviewList]\n"+query);
		  		e.printStackTrace();
			} finally {
				try{
	                if(rs != null) rs.close();
	                if(pstmt != null) pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return vt;
			}
	    }	
		
		/*
		 *	��������� ���������� ó��
		*/
		public String call_sp_com_pre_cls_cont(String rent_mng_id, String rent_l_cd)
		{
	    	getConnection();
	    	
	    	String query = "{CALL P_COM_PRE_CLS_CONT (?,?)}";

			String sResult = "0";
			
			CallableStatement cstmt = null;
			
			try {
				cstmt = conn.prepareCall(query);			
				cstmt.setString(1, rent_mng_id);
				cstmt.setString(2, rent_l_cd);
				cstmt.execute();
				cstmt.close();			
			} catch (SQLException e) {
				System.out.println("[EtcContDatabase:call_sp_com_pre_cls_cont]\n"+e);
				e.printStackTrace();
				sResult = "1";
			} finally {
				try{
				     if(cstmt != null)	cstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return sResult;
			}
		}
		
		//������Ű2��ϰ���
				public Vector getDigitalKey2List(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3)
				{
					getConnection();
					PreparedStatement pstmt = null;
					ResultSet rs = null;
					Vector vt = new Vector();
					String query = "";
					String search = "";
					String what = "";
					
					query = " --������Ű2\r\n" + 
							"           SELECT a.rent_mng_id, a.rent_l_cd, b.firm_nm, b.enp_no, DECODE(h.rent_suc_dt,'','','�°�') suc_st,\r\n" + 
							"			       c.init_reg_dt, c.car_no, c.car_num, nvl(c.car_nm,e2.car_nm) car_nm, e.car_name, e.car_comp_id, d.opt, \r\n" + 
							"			       f.user_nm AS bus_nm, f2.user_nm AS bus_nm2, \r\n" + 
							"                  g.reg_id, g.reg_dt, g.com_reg_dt, g.com_cls_dt, g.firm_nm AS com_firm_nm, g.etc, g.firm_tel, replace(g.firm_tel,'-','') firm_tel2, g.start_dt, g.end_dt \r\n" + 
							"			FROM   cont a, client b, car_reg c, car_etc d, car_nm e, car_mng e2, users f, users f2, car_key_digital g, cont_etc h, fee i \r\n" + 
							"			WHERE  a.client_id=b.client_id \r\n" + 
							"			       AND a.car_mng_id=c.car_mng_id \r\n" + 
							"			       AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd and d.digital_key2='Y' \r\n" + 
							"			       AND d.car_id=e.car_id AND d.car_seq=e.car_seq and e.car_comp_id=e2.car_comp_id and e.car_cd=e2.code \r\n" + 
							"			       AND a.BUS_ID=f.user_id\r\n" + 
							"                  AND a.BUS_ID2=f2.user_id\r\n" + 
							"                  AND a.rent_mng_id=h.rent_mng_id AND a.rent_l_cd=h.rent_l_cd\r\n" + 
							"                  AND a.rent_mng_id=i.rent_mng_id AND a.rent_l_cd=i.rent_l_cd and i.rent_st='1' and i.rent_start_dt is not null \r\n" +							
							"                  AND a.rent_mng_id=g.rent_mng_id(+) AND a.rent_l_cd=g.rent_l_cd(+) \r\n" + 
						    " ";

						//if(gubun1.equals("3"))	query += " and a.use_yn='Y' and g.com_reg_dt is null "; //�̵��
						//if(gubun1.equals("4"))	query += " and g.com_reg_dt is not null "; //���
						//if(gubun1.equals("2"))	query += " and g.reg_dt is not null and com_reg_dt is null "; //��û
						
						if(s_kd.equals("1"))	what = "upper(b.firm_nm)||g.firm_nm";
						if(s_kd.equals("2"))	what = "a.rent_l_cd";	
						if(s_kd.equals("3"))	what = "c.car_no";		
						if(s_kd.equals("5"))	what = "c.car_nm||e.car_name";	
						if(s_kd.equals("6"))	what = "c.init_reg_dt";	
						if(s_kd.equals("7"))	what = "f.user_nm||f2.user_nm";
						
						if(!what.equals("") && !t_wd.equals("")){
							if(t_wd.indexOf("'") != -1)					t_wd = AddUtil.replace(t_wd,"'","");

							if(s_kd.equals("1")||s_kd.equals("2")){	
								query += " and "+what+" like upper('%"+t_wd+"%') \n";
							}else if(s_kd.equals("6")){	
								query += " and "+what+" like replace('%"+t_wd+"%','-','') \n";
							}else{
								query += " and "+what+" like '%"+t_wd+"%' \n";
							}
						}
						
						query += " order by c.init_reg_dt desc, a.rent_dt \n";


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
						System.out.println("[EtcContDatabase:getDigitalKey2List]\n"+e);
						System.out.println("[EtcContDatabase:getDigitalKey2List]\n"+query);
				  		e.printStackTrace();
					} finally {
						try{
			                if(rs != null) rs.close();
			                if(pstmt != null) pstmt.close();
						}catch(Exception ignore){}
						closeConnection();
						return vt;
					}
			    }
				
				public Hashtable getTempHighTech(String car_mng_id, String car_no)
				{
					getConnection();
					PreparedStatement pstmt = null;
					ResultSet rs = null;
					Hashtable ht = new Hashtable();
			        String query = "";

					query = " select * from temp_hightech where car_mng_id='"+car_mng_id+"' and car_no='"+car_no+"' ";

					try {
							pstmt = conn.prepareStatement(query);
					    	rs = pstmt.executeQuery();
				    		ResultSetMetaData rsmd = rs.getMetaData();
						while(rs.next())
						{				
							for(int pos =1; pos <= rsmd.getColumnCount();pos++)
							{
								 String columnName = rsmd.getColumnName(pos);
								 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim()/**/);
							}
						}
						rs.close();
						pstmt.close();
					} catch (SQLException e) {
						System.out.println("[EtcContDatabase:getTempHighTech]"+ e);
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
				
				public Hashtable getTaechaScdDayAllChk(String rent_l_cd)
				{
					getConnection();
					PreparedStatement pstmt = null;
					ResultSet rs = null;
					Hashtable ht = new Hashtable();
			        String query = "";

					query = " SELECT CASE WHEN a.use_s_dt<>b.use_s_dt OR a.use_e_dt<>b.use_e_dt THEN 'Y' ELSE 'N' END red_yn\r\n"
							+ "FROM \r\n"
							+ "      (SELECT min(car_rent_st) use_s_dt, MAX(car_rent_et) use_e_dt FROM taecha WHERE rent_l_cd='"+rent_l_cd+"') a,\r\n"
							+ "      (SELECT min(use_s_dt) use_s_dt, MAX(use_e_dt) use_e_dt FROM scd_fee WHERE rent_l_cd='"+rent_l_cd+"' AND tm_st2='2') b ";

					try {
							pstmt = conn.prepareStatement(query);
					    	rs = pstmt.executeQuery();
				    		ResultSetMetaData rsmd = rs.getMetaData();
						while(rs.next())
						{				
							for(int pos =1; pos <= rsmd.getColumnCount();pos++)
							{
								 String columnName = rsmd.getColumnName(pos);
								 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim()/**/);
							}
						}
						rs.close();
						pstmt.close();
					} catch (SQLException e) {
						System.out.println("[EtcContDatabase:getTaechaScdDayAllChk]"+ e);
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
				
	
}
