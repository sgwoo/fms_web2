package acar.stat_mng;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.account.*;
import acar.stat_applet.*;
import acar.common.*;
import acar.admin.*;

public class StatMngDatabase
{
	private Connection conn = null;
	public static StatMngDatabase db;
	
	public static StatMngDatabase getInstance()
	{
		if(StatMngDatabase.db == null)
			StatMngDatabase.db = new StatMngDatabase();
		return StatMngDatabase.db;
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
	

	/**
	 *	����Ʈ��ȸ - ����
	 */
	public Vector getStatDebtList(String table_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query= " select"+
				" decode(save_dt, '', '', substr(save_dt, 1, 4)||'-'||substr(save_dt, 5, 2)||'-'||substr(save_dt, 7, 2)) save_dt"+
				" from "+table_nm+" where nvl(use_yn,'Y')='Y' group by save_dt order by save_dt desc ";

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
				StatDebtBean sd = new StatDebtBean();
				sd.setSave_dt(rs.getString(1));		
				vt.add(sd);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatMngDatabase:getStatDebt]"+table_nm+e);
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
	 *	������ ������� ��ȸ
	 */
	public String getMaxSaveDt(String table_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String save_dt = "";

		String query = "select max(save_dt) from "+table_nm;

		try 
		{
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next()){
				save_dt = rs.getString(1);
			}
			rs.close();
			pstmt.close();
		    
	  	} catch (Exception e) {
			System.out.println("[StatMngDatabase:getMaxSaveDt]"+table_nm+e);
			e.printStackTrace();
		} finally {
			try{	
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return save_dt;
		}			
	}

	/**
	 *	�ߺ���� Ȯ��
	 */
	public int getInsertYn(String table_nm, String today)
	{
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		int count = 0;

		String query = "select count(0) from "+table_nm+" where save_dt="+today;

		String query2 = "delete from "+table_nm+" where save_dt="+today;


		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
	    	         rs = pstmt.executeQuery();
			if(rs.next()){
				count = rs.getInt(1);
			}
			rs.close();
		    pstmt.close();

			if(count > 0){
				pstmt2 = conn.prepareStatement(query2);
				pstmt2.executeUpdate();
				pstmt2.close();
				count = 0;
			}
			
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[StatMngDatabase:getInsertYn]"+table_nm+e);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
			          if(rs != null )		rs.close();
			          if(pstmt != null)	pstmt.close();
				 if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}			
	}


	//�����������Ȳ-------------------------------------------------------------------------------

	/**
	 *	���ϱ��� ��ȸ(��������� ����)
	 */
	public Vector getStatMng(String br_id, String save_dt, String dept_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select f.nm, e.user_nm, e.user_id, e.enter_dt,"+ 
				" nvl(h.cnt,0) as c_cnt, h.cnt*3 as c_ga,"+ 
				" nvl(b.cnt,0)+nvl(i.cnt,0) as g_cnt, (nvl(b.cnt,0)*3)+(nvl(i.cnt,0)*1.5) g_ga,"+ 
				" nvl(c.cnt,0)+nvl(j.cnt,0) as p_cnt, (nvl(c.cnt,0)*1)+(nvl(j.cnt,0)*0.5) p_ga,"+ 
				" nvl(d.cnt,0)+nvl(k.cnt,0) as b_cnt, (nvl(d.cnt,0)*1)+(nvl(k.cnt,0)*0.5) b_ga,"+ 
				" (nvl(b.cnt,0)+nvl(c.cnt,0)+nvl(d.cnt,0)) as tot_cnt2,"+ 
				" (nvl(b.cnt,0)*3)+(nvl(i.cnt,0)*1.5)+(nvl(c.cnt,0)*1)+(nvl(i.cnt,0)*0.5)+(nvl(d.cnt,0)*1)+(nvl(i.cnt,0)*0.5) as tot_ga"+ 
				" from"+  
				//--�����հ�
				" (select a.mng_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') group by a.mng_id) a,"+ 
				//--�Ϲݽ�
				" (select a.mng_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' group by a.mng_id) b,"+ 
				//--�����
				" (select a.mng_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' group by a.mng_id) c,"+ 
				//--�⺻��
				" (select a.mng_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' group by a.mng_id) d,"+ 
				" users e, code f,"+ 
				//--��ü��
				" (select a.mng_id, count(0) cnt from (select a.mng_id, a.client_id, count(0) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') group by a.mng_id, a.client_id, a.r_site) a group by mng_id) h,"+ 
				//--�Ϲݽ�2
				" (select a.mng_id2 as mng_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' group by a.mng_id2) i,"+ 
				//--�����
				" (select a.mng_id2 as mng_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' group by a.mng_id2) j,"+ 
				//--�⺻��
				" (select a.mng_id2 as mng_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' group by a.mng_id2) k"+ 
				" where a.mng_id=b.mng_id(+) and a.mng_id=c.mng_id(+) and a.mng_id=d.mng_id(+) and a.mng_id=e.user_id(+) and a.mng_id=h.mng_id(+) and e.dept_id=f.code and f.c_st='0002' and f.code<>'0000'"+ 
				" and a.mng_id=i.mng_id(+) and a.mng_id=j.mng_id(+) and a.mng_id=k.mng_id(+)"+ 
				" and e.dept_id='"+dept_id+"'"+
				" order by (nvl(b.cnt,0)*3)+(nvl(i.cnt,0)*1.5)+(nvl(c.cnt,0)*1)+(nvl(i.cnt,0)*0.5)+(nvl(d.cnt,0)*1)+(nvl(i.cnt,0)*0.5) desc"; 
		
		try {

			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
				StatMngBean bean = new StatMngBean();

				bean.setDept_nm(rs.getString(1));
				bean.setUser_nm(rs.getString(2));
				bean.setUser_id(rs.getString(3));
				bean.setEnter_dt(rs.getString(4));
				bean.setClient_cnt(rs.getInt(5));
				bean.setClient_ga(rs.getFloat(6));
				bean.setGen_cnt(rs.getInt(7));
				bean.setGen_ga(rs.getFloat(8));
				bean.setPut_cnt(rs.getInt(9));
				bean.setPut_ga(rs.getFloat(10));
				bean.setBas_cnt(rs.getInt(11));
				bean.setBas_ga(rs.getFloat(12));
				bean.setTot_cnt(rs.getInt(13));
				bean.setTot_ga(rs.getFloat(14));

				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatMngDatabase:getStatMng]"+e);
			System.out.println("[StatMngDatabase:getStatMng]"+query);
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
	 *	���ϱ��� ��ȸ(�ܵ�,���� ����)-���� ����ġ
	 */
	public Vector getStatMng2(String br_id, String save_dt, String dept_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(save_dt.equals("")){

			query = " select f.nm, e.user_nm, e.user_id, e.enter_dt, "+
					" nvl(a1.cnt,0) c_cnt_o, nvl(a2.cnt,0)+nvl(a3.cnt,0) c_cnt_t,  "+
					" (nvl(a1.cnt,0)+nvl(a2.cnt,0)+nvl(a3.cnt,0)) c_cnt, "+
					" (nvl(a1.cnt,0)+nvl(a2.cnt,0)+nvl(a3.cnt,0))*3 c_ga, "+
					" nvl(b1.cnt,0) g_cnt_o, nvl(b2.cnt,0)+nvl(b3.cnt,0) g_cnt_t,  "+
					" (nvl(b1.cnt,0)+nvl(b2.cnt,0)+nvl(b3.cnt,0)) g_cnt, "+
					" (nvl(b1.cnt,0)*3)+(nvl(b2.cnt,0)+nvl(b3.cnt,0))*1.5 g_ga, "+
					" nvl(c1.cnt,0) p_cnt_o, nvl(c2.cnt,0)+nvl(c3.cnt,0) p_cnt_t,  "+
					" (nvl(c1.cnt,0)+nvl(c2.cnt,0)+nvl(c3.cnt,0)) p_cnt, "+
					" (nvl(c1.cnt,0)*1)+(nvl(c2.cnt,0)+nvl(c3.cnt,0))*0.5 p_ga, "+
					" nvl(d1.cnt,0) b_cnt_o, nvl(d2.cnt,0)+nvl(d3.cnt,0) b_cnt_t,  "+
					" (nvl(d1.cnt,0)+nvl(d2.cnt,0)+nvl(d3.cnt,0)) b_cnt, "+
					" (nvl(d1.cnt,0)*1)+(nvl(d2.cnt,0)+nvl(d3.cnt,0))*0.5 b_ga, "+
					" ((nvl(b1.cnt,0)+nvl(b2.cnt,0)+nvl(b3.cnt,0))+(nvl(c1.cnt,0)+nvl(c2.cnt,0)+nvl(c3.cnt,0))+(nvl(d1.cnt,0)+nvl(d2.cnt,0)+nvl(d3.cnt,0))) tot_cnt, "+
					" (((nvl(b1.cnt,0)*3)+(nvl(b2.cnt,0)+nvl(b3.cnt,0))*1.5)+((nvl(c1.cnt,0)*1)+(nvl(c2.cnt,0)+nvl(c3.cnt,0))*0.5)+((nvl(d1.cnt,0)*1)+(nvl(d2.cnt,0)+nvl(d3.cnt,0))*0.5)) tot_ga "+
					" from  "+
					//�������
					" (select mng_id as user_id from cont where nvl(use_yn,'Y')='Y' and client_id not in ('000231', '000228') group by mng_id) u, "+
					//��ü��=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, sum(a.cnt) cnt from (select a.bus_id2, a.client_id, count(0) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2=nvl(a.mng_id,a.bus_id2) group by a.bus_id2, a.client_id, a.r_site) a group by bus_id2) a1, "+
					//��ü��=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, sum(a.cnt) cnt from (select a.bus_id2, a.client_id, count(0) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2<>a.mng_id group by a.bus_id2, a.client_id, a.r_site) a group by bus_id2) a2, "+
					//��ü��=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, sum(a.cnt) cnt from (select a.mng_id, a.client_id, count(0) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2<>a.mng_id group by a.mng_id, a.client_id, a.r_site) a group by mng_id) a3, "+
					//�Ϲݽ�=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2=nvl(a.mng_id,a.bus_id2) group by a.bus_id2) b1, "+
					//�Ϲݽ�=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2<>a.mng_id group by a.bus_id2) b2, "+
					//�Ϲݽ�=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2<>a.mng_id group by a.mng_id) b3, "+
					//�����=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2=nvl(a.mng_id,a.bus_id2) group by a.bus_id2) c1, "+
					//�����=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2<>a.mng_id group by a.bus_id2) c2, "+
					//�����=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2<>a.mng_id group by a.mng_id) c3, "+
					//�⺻��=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2=nvl(a.mng_id,a.bus_id2) group by a.bus_id2) d1, "+
					//�⺻��=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2<>a.mng_id group by a.bus_id2) d2, "+
					//�⺻��=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2<>a.mng_id group by a.mng_id) d3, "+
					" users e, code f"+
					" where u.user_id=a1.user_id(+) and u.user_id=a2.user_id(+) and u.user_id=a3.user_id(+)  "+
					" and u.user_id=b1.user_id(+) and u.user_id=b2.user_id(+) and u.user_id=b3.user_id(+) "+
					" and u.user_id=c1.user_id(+) and u.user_id=c2.user_id(+) and u.user_id=c3.user_id(+) "+
					" and u.user_id=d1.user_id(+) and u.user_id=d2.user_id(+) and u.user_id=d3.user_id(+) "+
					" and u.user_id=e.user_id and e.dept_id=f.code(+) and f.c_st='0002' and f.code<>'0000' "+
					" and e.dept_id='"+dept_id+"'"+
					" order by (((nvl(b1.cnt,0)*3)+(nvl(b2.cnt,0)+nvl(b3.cnt,0))*1.5)+((nvl(c1.cnt,0)*1)+(nvl(c2.cnt,0)+nvl(c3.cnt,0))*0.5)+((nvl(d1.cnt,0)*1)+(nvl(d2.cnt,0)+nvl(d3.cnt,0))*0.5)) desc"; 
		}else{
			query = " select c.nm, b.user_nm, b.user_id, b.enter_dt, 0 c_cnt_o, 0 c_cnt_t, a.client_cnt, a.client_ga,"+
					" a.gen_cnt_o, a.gen_cnt_t, (a.gen_cnt_o+a.gen_cnt_t) as gen_cnt, a.gen_ga,"+
					" a.put_cnt_o, a.put_cnt_t, (a.put_cnt_o+a.put_cnt_t) as put_cnt, a.put_ga,"+
					" a.bas_cnt_o, a.bas_cnt_t, (a.bas_cnt_o+a.bas_cnt_t) as bas_cnt, a.bas_ga,"+
					" (a.gen_cnt_o+a.gen_cnt_t+a.put_cnt_o+a.put_cnt_t+a.bas_cnt_o+a.bas_cnt_t) tot_cnt,"+
					" (a.gen_ga+a.put_ga+a.bas_ga) tot_ga"+
					" from stat_mng a, users b, code c"+
					" where a.user_id=b.user_id and b.dept_id=c.code and c.c_st='0002' and c.code<>'0000'"+
					" and b.dept_id='"+dept_id+"' and a.save_dt=replace('"+save_dt+"', '-', '')"+
					" order by a.seq"; 
		}
		try {

			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
				StatMngBean bean = new StatMngBean();

				bean.setDept_nm(rs.getString(1));
				bean.setUser_nm(rs.getString(2));
				bean.setUser_id(rs.getString(3));
				bean.setEnter_dt(rs.getString(4));
				bean.setClient_cnt_o(rs.getInt(5));
				bean.setClient_cnt_t(rs.getInt(6));
				bean.setClient_cnt(rs.getInt(7));
				bean.setClient_ga(rs.getFloat(8));
				bean.setGen_cnt_o(rs.getInt(9));
				bean.setGen_cnt_t(rs.getInt(10));
				bean.setGen_cnt(rs.getInt(11));
				bean.setGen_ga(rs.getFloat(12));
				bean.setPut_cnt_o(rs.getInt(13));
				bean.setPut_cnt_t(rs.getInt(14));
				bean.setPut_cnt(rs.getInt(15));
				bean.setPut_ga(rs.getFloat(16));
				bean.setBas_cnt_o(rs.getInt(17));
				bean.setBas_cnt_t(rs.getInt(18));
				bean.setBas_cnt(rs.getInt(19));
				bean.setBas_ga(rs.getFloat(20));
				bean.setTot_cnt(rs.getInt(21));
				bean.setTot_ga(rs.getFloat(22));

				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatMngDatabase:getStatMng2]"+e);
			System.out.println("[StatMngDatabase:getStatMng2]"+query);
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
	 *	���ϱ��� ��ȸ(�ܵ�,���� ����)-���� ����ġ
	 */
	public Vector getStatMng3(String br_id, String save_dt, String dept_id, int c_o, int c_t, int g_o, int g_t1, int g_t2, int b_o, double b_t, int p_o, double p_t)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(save_dt.equals("")){

			query = " select f.nm, e.user_nm, e.user_id, e.enter_dt, "+
					" nvl(a1.cnt,0) c_cnt_o,"+
					" ( nvl(a2.cnt,0) + nvl(a3.cnt,0) ) c_cnt_t,"+
					" ( nvl(a1.cnt,0) + nvl(a2.cnt,0) + nvl(a3.cnt,0) ) c_cnt, "+
					" ( (nvl(a1.cnt,0)*"+c_o+") + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))*"+c_t+") ) c_ga, "+
					" nvl(b1.cnt,0) g_cnt_o,"+
					" ( nvl(b2.cnt,0) + nvl(b3.cnt,0) ) g_cnt_t,"+
					" ( nvl(b1.cnt,0) + nvl(b2.cnt,0) + nvl(b3.cnt,0) ) g_cnt,"+
					" ( (nvl(b1.cnt,0)*"+g_o+") + (nvl(b2.cnt,0)*decode(e.dept_id,'0001',"+g_t1+","+g_t2+")) + (nvl(b3.cnt,0)*decode(e.dept_id,'0001',"+g_t1+","+g_t2+")) ) g_ga, "+
					" nvl(c1.cnt,0) p_cnt_o,"+
					" ( nvl(c2.cnt,0) + nvl(c3.cnt,0) ) p_cnt_t,"+
					" ( nvl(c1.cnt,0) + nvl(c2.cnt,0) + nvl(c3.cnt,0)) p_cnt, "+
					" ( (nvl(c1.cnt,0)*"+p_o+") + ((nvl(c2.cnt,0)+nvl(c3.cnt,0))*"+p_t+") ) p_ga, "+
					" nvl(d1.cnt,0) b_cnt_o,"+
					" ( nvl(d2.cnt,0) + nvl(d3.cnt,0) ) b_cnt_t,"+
					" ( nvl(d1.cnt,0) + nvl(d2.cnt,0) + nvl(d3.cnt,0) ) b_cnt,"+
					" ( (nvl(d1.cnt,0)*"+b_o+") + ((nvl(d2.cnt,0)+nvl(d3.cnt,0))*"+b_t+") ) b_ga,"+
					" nvl(g1.cnt,0) cg_cnt_b1, nvl(g2.cnt,0) cg_cnt_b2, nvl(g3.cnt,0) cg_cnt_m1,"+
					" ( nvl(g1.cnt,0)*0.1+nvl(g2.cnt,0)*0.2+nvl(g3.cnt,0)*0.7 ) cg_ga,"+
					" nvl(h1.cnt,0) cb_cnt_b1, nvl(h2.cnt,0) cb_cnt_b2, nvl(h3.cnt,0) cb_cnt_m1,"+
					" ( nvl(h1.cnt,0)*0.1+nvl(h2.cnt,0)*0.2+nvl(h3.cnt,0)*0.7 ) cb_ga"+
					" from  "+
					//�������
					" (select mng_id as user_id from cont where nvl(use_yn,'Y')='Y' and client_id not in ('000231', '000228') group by mng_id) u, "+
					//��ü��=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, sum(a.cnt) cnt from (select a.bus_id2, a.client_id, count(0) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2=nvl(a.mng_id,a.bus_id2) group by a.bus_id2, a.client_id, a.r_site) a group by bus_id2) a1, "+
					//��ü��=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, sum(a.cnt) cnt from (select a.bus_id2, a.client_id, count(0) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2<>a.mng_id group by a.bus_id2, a.client_id, a.r_site) a group by bus_id2) a2, "+
					//��ü��=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, sum(a.cnt) cnt from (select a.mng_id, a.client_id, count(0) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2<>a.mng_id group by a.mng_id, a.client_id, a.r_site) a group by mng_id) a3, "+
					//�Ϲݽ�=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_mng_id is not null group by a.bus_id2) b1, "+
					//�Ϲݽ�=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.bus_id2) b2, "+
					//�Ϲݽ�=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.mng_id) b3, "+
					//�����=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_mng_id is not null group by a.bus_id2) c1, "+
					//�����=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.bus_id2) c2, "+
					//�����=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.mng_id) c3, "+
					//�⺻��=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_mng_id is not null group by a.bus_id2) d1, "+
					//�⺻��=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.bus_id2) d2, "+
					//�⺻��=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.mng_id) d3, "+
					//�Ϲݽ�=���ʿ���
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.car_mng_id is not null group by a.bus_id) g1, "+
					//�Ϲݽ�=��������
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.car_mng_id is not null group by a.bus_id2) g2, "+
					//�Ϲݽ�=�������
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.car_mng_id is not null group by a.mng_id) g3, "+
					//�⺻��/�����=���ʿ���
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way<>'1' and a.car_mng_id is not null group by a.bus_id) h1, "+
					//�⺻��/�����=��������
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way<>'1' and a.car_mng_id is not null group by a.bus_id2) h2, "+
					//�⺻��/�����=�������
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way<>'1' and a.car_mng_id is not null group by a.mng_id) h3, "+
					" users e, code f"+
					" where u.user_id=a1.user_id(+) and u.user_id=a2.user_id(+) and u.user_id=a3.user_id(+)  "+
					" and u.user_id=b1.user_id(+) and u.user_id=b2.user_id(+) and u.user_id=b3.user_id(+) "+
					" and u.user_id=c1.user_id(+) and u.user_id=c2.user_id(+) and u.user_id=c3.user_id(+) "+
					" and u.user_id=d1.user_id(+) and u.user_id=d2.user_id(+) and u.user_id=d3.user_id(+) "+
					" and u.user_id=g1.user_id(+) and u.user_id=g2.user_id(+) and u.user_id=g3.user_id(+) "+
					" and u.user_id=h1.user_id(+) and u.user_id=h2.user_id(+) and u.user_id=h3.user_id(+) "+
					" and u.user_id=e.user_id and e.dept_id=f.code(+) and f.c_st='0002' and f.code<>'0000' "+
					" and e.dept_id='"+dept_id+"'"+
					" order by ((nvl(a1.cnt,0)*"+c_o+") + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))*"+c_t+") + (nvl(b1.cnt,0)*"+g_o+") + (nvl(b2.cnt,0)*decode(e.dept_id,'0001',"+g_t1+","+g_t2+")) + (nvl(b3.cnt,0)*decode(e.dept_id,'0001',"+g_t1+","+g_t2+")) + (nvl(c1.cnt,0)*"+p_o+") + ((nvl(c2.cnt,0)+nvl(c3.cnt,0))*"+p_t+") + (nvl(d1.cnt,0)*"+b_o+") + ((nvl(d2.cnt,0)+nvl(d3.cnt,0))*"+b_t+")) desc"; 
		}else{
			query = " select c.nm, b.user_nm, b.user_id, b.enter_dt,"+
					" a.client_cnt_o, a.client_cnt_t, (a.client_cnt_o+a.client_cnt_t) as client_cnt, a.client_ga,"+
					" a.gen_cnt_o, a.gen_cnt_t, (a.gen_cnt_o+a.gen_cnt_t) as gen_cnt, a.gen_ga,"+
					" a.put_cnt_o, a.put_cnt_t, (a.put_cnt_o+a.put_cnt_t) as put_cnt, a.put_ga,"+
					" a.bas_cnt_o, a.bas_cnt_t, (a.bas_cnt_o+a.bas_cnt_t) as bas_cnt, a.bas_ga"+
					" from stat_mng a, users b, code c"+
					" where a.user_id=b.user_id and b.dept_id=c.code and c.c_st='0002' and c.code<>'0000'"+
					" and b.dept_id='"+dept_id+"' and a.save_dt=replace('"+save_dt+"', '-', '')"+
					" order by a.seq"; 
		}
		try {

			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
				StatMngBean bean = new StatMngBean();

				bean.setDept_nm(rs.getString(1));
				bean.setUser_nm(rs.getString(2));
				bean.setUser_id(rs.getString(3));
				bean.setEnter_dt(rs.getString(4));
				bean.setClient_cnt_o(rs.getInt(5));
				bean.setClient_cnt_t(rs.getInt(6));
				bean.setClient_cnt(rs.getInt(7));
				bean.setClient_ga(rs.getFloat(8));
				bean.setGen_cnt_o(rs.getInt(9));
				bean.setGen_cnt_t(rs.getInt(10));
				bean.setGen_cnt(rs.getInt(11));
				bean.setGen_ga(rs.getFloat(12));
				bean.setPut_cnt_o(rs.getInt(13));
				bean.setPut_cnt_t(rs.getInt(14));
				bean.setPut_cnt(rs.getInt(15));
				bean.setPut_ga(rs.getFloat(16));
				bean.setBas_cnt_o(rs.getInt(17));
				bean.setBas_cnt_t(rs.getInt(18));
				bean.setBas_cnt(rs.getInt(19));
				bean.setBas_ga(rs.getFloat(20));
				bean.setC_Gen_cnt_b1(rs.getInt(21));
				bean.setC_Gen_cnt_b2(rs.getInt(22));
				bean.setC_Gen_cnt_m1(rs.getInt(23));
				bean.setC_Gen_ga(rs.getFloat(24));
				bean.setC_BP_cnt_b1(rs.getInt(25));
				bean.setC_BP_cnt_b2(rs.getInt(26));
				bean.setC_BP_cnt_m1(rs.getInt(27));
				bean.setC_BP_ga(rs.getFloat(28));

				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatMngDatabase:getStatMng3]"+e);
			System.out.println("[StatMngDatabase:getStatMng3]"+query);
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
	 *	���ϱ��� ��ȸ(�ܵ�,���� ����)-���� ����ġ
	 */
	public Vector getStatMng3(String br_id, String save_dt, String dept_id, String c_o, String c_t, String g_o, String g_t, String b_o, String b_t, String p_o, String p_t)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(save_dt.equals("")){
			query = " select f.nm, e.user_nm, e.user_id, e.enter_dt, "+
					" nvl(a1.cnt,0) c_cnt_o,"+
					" ( nvl(a2.cnt,0) + nvl(a3.cnt,0) ) c_cnt_t,"+
					" ( nvl(a1.cnt,0) + nvl(a2.cnt,0) + nvl(a3.cnt,0) ) c_cnt, "+
					" ( (nvl(a1.cnt,0)*"+c_o+") + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))*"+c_t+") ) c_ga, "+
					" nvl(b1.cnt,0) g_cnt_o,"+
					" ( nvl(b2.cnt,0) + nvl(b3.cnt,0) ) g_cnt_t,"+
					" ( nvl(b1.cnt,0) + nvl(b2.cnt,0) + nvl(b3.cnt,0) ) g_cnt,"+
					" ( (nvl(b1.cnt,0)*"+g_o+") + (nvl(b2.cnt,0)*decode(e.dept_id,'0001',"+g_t+","+g_t+")) + (nvl(b3.cnt,0)*decode(e.dept_id,'0001',"+g_t+","+g_t+")) ) g_ga, "+
					" nvl(c1.cnt,0) p_cnt_o,"+
					" ( nvl(c2.cnt,0) + nvl(c3.cnt,0) ) p_cnt_t,"+
					" ( nvl(c1.cnt,0) + nvl(c2.cnt,0) + nvl(c3.cnt,0)) p_cnt, "+
					" ( (nvl(c1.cnt,0)*"+p_o+") + ((nvl(c2.cnt,0)+nvl(c3.cnt,0))*"+p_t+") ) p_ga, "+
					" nvl(d1.cnt,0) b_cnt_o,"+
					" ( nvl(d2.cnt,0) + nvl(d3.cnt,0) ) b_cnt_t,"+
					" ( nvl(d1.cnt,0) + nvl(d2.cnt,0) + nvl(d3.cnt,0) ) b_cnt,"+
					" ( (nvl(d1.cnt,0)*"+b_o+") + ((nvl(d2.cnt,0)+nvl(d3.cnt,0))*"+b_t+") ) b_ga,"+
					" nvl(g1.cnt,0) cg_cnt_b1, nvl(g2.cnt,0) cg_cnt_b2, nvl(g3.cnt,0) cg_cnt_m1,"+
					" ( nvl(g1.cnt,0)*0.1+nvl(g2.cnt,0)*0.2+nvl(g3.cnt,0)*0.7 ) cg_ga,"+
					" nvl(h1.cnt,0) cb_cnt_b1, nvl(h2.cnt,0) cb_cnt_b2, nvl(h3.cnt,0) cb_cnt_m1,"+
					" ( nvl(h1.cnt,0)*0.1+nvl(h2.cnt,0)*0.2 ) cb_ga"+//+nvl(h3.cnt,0)*0
					" from  "+
					//�������
					" (select mng_id as user_id from cont where nvl(use_yn,'Y')='Y' and client_id not in ('000231', '000228') group by mng_id) u, "+
					//��ü��=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, sum(a.cnt) cnt from (select a.bus_id2, a.client_id, count(0) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2=nvl(a.mng_id,a.bus_id2) group by a.bus_id2, a.client_id, a.r_site) a group by bus_id2) a1, "+
					//��ü��=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, sum(a.cnt) cnt from (select a.bus_id2, a.client_id, count(0) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2<>a.mng_id group by a.bus_id2, a.client_id, a.r_site) a group by bus_id2) a2, "+
					//��ü��=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, sum(a.cnt) cnt from (select a.mng_id, a.client_id, count(0) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2<>a.mng_id group by a.mng_id, a.client_id, a.r_site) a group by mng_id) a3, "+
					//�Ϲݽ�=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_mng_id is not null group by a.bus_id2) b1, "+
					//�Ϲݽ�=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.bus_id2) b2, "+
					//�Ϲݽ�=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.mng_id) b3, "+
					//�����=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_mng_id is not null group by a.bus_id2) c1, "+
					//�����=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.bus_id2) c2, "+
					//�����=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.mng_id) c3, "+
					//�⺻��=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_mng_id is not null group by a.bus_id2) d1, "+
					//�⺻��=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.bus_id2) d2, "+
					//�⺻��=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.mng_id) d3, "+
					//�Ϲݽ�=���ʿ���
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.car_mng_id is not null group by a.bus_id) g1, "+
					//�Ϲݽ�=��������
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.car_mng_id is not null group by a.bus_id2) g2, "+
					//�Ϲݽ�=�������
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.car_mng_id is not null group by a.mng_id) g3, "+
					//�⺻��/�����=���ʿ���
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way<>'1' and a.car_mng_id is not null group by a.bus_id) h1, "+
					//�⺻��/�����=��������
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way<>'1' and a.car_mng_id is not null group by a.bus_id2) h2, "+
					//�⺻��/�����=�������
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way<>'1' and a.car_mng_id is not null group by a.mng_id) h3, "+
					" users e, code f"+
					" where u.user_id=a1.user_id(+) and u.user_id=a2.user_id(+) and u.user_id=a3.user_id(+)  "+
					" and u.user_id=b1.user_id(+) and u.user_id=b2.user_id(+) and u.user_id=b3.user_id(+) "+
					" and u.user_id=c1.user_id(+) and u.user_id=c2.user_id(+) and u.user_id=c3.user_id(+) "+
					" and u.user_id=d1.user_id(+) and u.user_id=d2.user_id(+) and u.user_id=d3.user_id(+) "+
					" and u.user_id=g1.user_id(+) and u.user_id=g2.user_id(+) and u.user_id=g3.user_id(+) "+
					" and u.user_id=h1.user_id(+) and u.user_id=h2.user_id(+) and u.user_id=h3.user_id(+) "+
					" and u.user_id=e.user_id and e.dept_id=f.code(+) and f.c_st='0002' and f.code<>'0000' "+
					" and e.dept_id='"+dept_id+"'"+
					" order by ((nvl(a1.cnt,0)*"+c_o+") + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))*"+c_t+") + (nvl(b1.cnt,0)*"+g_o+") + (nvl(b2.cnt,0)*decode(e.dept_id,'0001',"+g_t+","+g_t+")) + (nvl(b3.cnt,0)*decode(e.dept_id,'0001',"+g_t+","+g_t+")) + (nvl(c1.cnt,0)*"+p_o+") + ((nvl(c2.cnt,0)+nvl(c3.cnt,0))*"+p_t+") + (nvl(d1.cnt,0)*"+b_o+") + ((nvl(d2.cnt,0)+nvl(d3.cnt,0))*"+b_t+")) desc"; 
		}else{
			query = " select c.nm, b.user_nm, b.user_id, b.enter_dt,"+
					" a.client_cnt_o, a.client_cnt_t, (a.client_cnt_o+a.client_cnt_t) as client_cnt, a.client_ga,"+
					" a.gen_cnt_o, a.gen_cnt_t, (a.gen_cnt_o+a.gen_cnt_t) as gen_cnt, a.gen_ga,"+
					" a.put_cnt_o, a.put_cnt_t, (a.put_cnt_o+a.put_cnt_t) as put_cnt, a.put_ga,"+
					" a.bas_cnt_o, a.bas_cnt_t, (a.bas_cnt_o+a.bas_cnt_t) as bas_cnt, a.bas_ga"+
					" from stat_mng a, users b, code c"+
					" where a.user_id=b.user_id and b.dept_id=c.code and c.c_st='0002' and c.code<>'0000'"+
					" and b.dept_id='"+dept_id+"' and a.save_dt=replace('"+save_dt+"', '-', '')"+
					" order by a.seq"; 
		}
		try {

			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
				StatMngBean bean = new StatMngBean();

				bean.setDept_nm(rs.getString(1));
				bean.setUser_nm(rs.getString(2));
				bean.setUser_id(rs.getString(3));
				bean.setEnter_dt(rs.getString(4));
				bean.setClient_cnt_o(rs.getInt(5));
				bean.setClient_cnt_t(rs.getInt(6));
				bean.setClient_cnt(rs.getInt(7));
				bean.setClient_ga(rs.getFloat(8));
				bean.setGen_cnt_o(rs.getInt(9));
				bean.setGen_cnt_t(rs.getInt(10));
				bean.setGen_cnt(rs.getInt(11));
				bean.setGen_ga(rs.getFloat(12));
				bean.setPut_cnt_o(rs.getInt(13));
				bean.setPut_cnt_t(rs.getInt(14));
				bean.setPut_cnt(rs.getInt(15));
				bean.setPut_ga(rs.getFloat(16));
				bean.setBas_cnt_o(rs.getInt(17));
				bean.setBas_cnt_t(rs.getInt(18));
				bean.setBas_cnt(rs.getInt(19));
				bean.setBas_ga(rs.getFloat(20));
				bean.setC_Gen_cnt_b1(rs.getInt(21));
				bean.setC_Gen_cnt_b2(rs.getInt(22));
				bean.setC_Gen_cnt_m1(rs.getInt(23));
				bean.setC_Gen_ga(rs.getFloat(24));
				bean.setC_BP_cnt_b1(rs.getInt(25));
				bean.setC_BP_cnt_b2(rs.getInt(26));
				bean.setC_BP_cnt_m1(rs.getInt(27));
				bean.setC_BP_ga(rs.getFloat(28));

				bean.setDept_id(dept_id);

				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatMngDatabase:getStatMng3]"+e);
			System.out.println("[StatMngDatabase:getStatMng3]"+query);
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
	 *	���ϱ��� ��ȸ(�ܵ�,���� ����)-���� ����ġ
	 */
	public Vector getStatMng4(String br_id, String save_dt, String dept_id, String c_o, String c_t, String g_o, String g_t, String b_o, String b_t, String p_o, String p_t, String cg_b1, String cg_b2, String cg_m1, String cb_b1, String cb_b2, String cb_m1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(save_dt.equals("")){
			query = " select f.nm, e.user_nm, e.user_id, e.enter_dt, "+
					" nvl(a1.cnt,0) c_cnt_o,"+
					" ( nvl(a2.cnt,0) + nvl(a3.cnt,0) ) c_cnt_t,"+
					" ( nvl(a1.cnt,0) + nvl(a2.cnt,0) + nvl(a3.cnt,0) ) c_cnt, "+
					" ( (nvl(a1.cnt,0)*"+c_o+") + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))*"+c_t+") ) c_ga, "+
					" nvl(b1.cnt,0) g_cnt_o,"+
					" ( nvl(b2.cnt,0) + nvl(b3.cnt,0) ) g_cnt_t,"+
					" ( nvl(b1.cnt,0) + nvl(b2.cnt,0) + nvl(b3.cnt,0) ) g_cnt,"+
					" ( (nvl(b1.cnt,0)*"+g_o+") + (nvl(b2.cnt,0)*decode(e.dept_id,'0001',"+g_t+","+g_t+")) + (nvl(b3.cnt,0)*decode(e.dept_id,'0001',"+g_t+","+g_t+")) ) g_ga, "+
					" nvl(c1.cnt,0) p_cnt_o,"+
					" ( nvl(c2.cnt,0) + nvl(c3.cnt,0) ) p_cnt_t,"+
					" ( nvl(c1.cnt,0) + nvl(c2.cnt,0) + nvl(c3.cnt,0)) p_cnt, "+
					" ( (nvl(c1.cnt,0)*"+p_o+") + ((nvl(c2.cnt,0)+nvl(c3.cnt,0))*"+p_t+") ) p_ga, "+
					" nvl(d1.cnt,0) b_cnt_o,"+
					" ( nvl(d2.cnt,0) + nvl(d3.cnt,0) ) b_cnt_t,"+
					" ( nvl(d1.cnt,0) + nvl(d2.cnt,0) + nvl(d3.cnt,0) ) b_cnt,"+
					" ( (nvl(d1.cnt,0)*"+b_o+") + ((nvl(d2.cnt,0)+nvl(d3.cnt,0))*"+b_t+") ) b_ga,"+
					" nvl(g1.cnt,0) cg_cnt_b1, nvl(g2.cnt,0) cg_cnt_b2, nvl(g3.cnt,0) cg_cnt_m1,"+
					" ( nvl(g1.cnt,0)*"+cg_b1+"+nvl(g2.cnt,0)*"+cg_b2+"+nvl(g3.cnt,0)*"+cg_m1+" ) cg_ga,"+
					" nvl(h1.cnt,0) cb_cnt_b1, nvl(h2.cnt,0) cb_cnt_b2, nvl(h3.cnt,0) cb_cnt_m1,"+
					" ( nvl(h1.cnt,0)*"+cb_b1+"+nvl(h2.cnt,0)*"+cb_b2+"+nvl(h3.cnt,0)*"+cb_m1+") cb_ga"+//+
					" from  "+
					//�������
					" (select bus_id2 as user_id from cont where nvl(use_yn,'Y')='Y' and client_id not in ('000231', '000228') group by bus_id2) u, "+
					//��ü��=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, sum(a.cnt) cnt from (select a.bus_id2, a.client_id, count(0) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2=nvl(a.mng_id,a.bus_id2) group by a.bus_id2, a.client_id, a.r_site) a group by bus_id2) a1, "+
					//��ü��=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, sum(a.cnt) cnt from (select a.bus_id2, a.client_id, count(0) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2<>a.mng_id group by a.bus_id2, a.client_id, a.r_site) a group by bus_id2) a2, "+
					//��ü��=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, sum(a.cnt) cnt from (select a.mng_id, a.client_id, count(0) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2<>a.mng_id group by a.mng_id, a.client_id, a.r_site) a group by mng_id) a3, "+
					//�Ϲݽ�=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_mng_id is not null group by a.bus_id2) b1, "+
					//�Ϲݽ�=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.bus_id2) b2, "+
					//�Ϲݽ�=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.mng_id) b3, "+
					//�����=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_mng_id is not null group by a.bus_id2) c1, "+
					//�����=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.bus_id2) c2, "+
					//�����=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.mng_id) c3, "+
					//�⺻��=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_mng_id is not null group by a.bus_id2) d1, "+
					//�⺻��=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.bus_id2) d2, "+
					//�⺻��=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.mng_id) d3, "+
					//�Ϲݽ�=���ʿ���
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.car_mng_id is not null group by a.bus_id) g1, "+
					//�Ϲݽ�=��������
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.car_mng_id is not null group by a.bus_id2) g2, "+
					//�Ϲݽ�=�������
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.car_mng_id is not null group by a.mng_id) g3, "+
					//�⺻��/�����=���ʿ���
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way<>'1' and a.car_mng_id is not null group by a.bus_id) h1, "+
					//�⺻��/�����=��������
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way<>'1' and a.car_mng_id is not null group by a.bus_id2) h2, "+
					//�⺻��/�����=�������
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way<>'1' and a.car_mng_id is not null group by a.mng_id) h3, "+
					" users e, code f"+
					" where u.user_id=a1.user_id(+) and u.user_id=a2.user_id(+) and u.user_id=a3.user_id(+)  "+
					" and u.user_id=b1.user_id(+) and u.user_id=b2.user_id(+) and u.user_id=b3.user_id(+) "+
					" and u.user_id=c1.user_id(+) and u.user_id=c2.user_id(+) and u.user_id=c3.user_id(+) "+
					" and u.user_id=d1.user_id(+) and u.user_id=d2.user_id(+) and u.user_id=d3.user_id(+) "+
					" and u.user_id=g1.user_id(+) and u.user_id=g2.user_id(+) and u.user_id=g3.user_id(+) "+
					" and u.user_id=h1.user_id(+) and u.user_id=h2.user_id(+) and u.user_id=h3.user_id(+) "+
					" and u.user_id=e.user_id and e.dept_id=f.code(+) and f.c_st='0002' and f.code<>'0000' "+
					" and e.dept_id='"+dept_id+"'"+
					" order by ((nvl(a1.cnt,0)*"+c_o+") + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))*"+c_t+") + (nvl(b1.cnt,0)*"+g_o+") + (nvl(b2.cnt,0)*decode(e.dept_id,'0001',"+g_t+","+g_t+")) + (nvl(b3.cnt,0)*decode(e.dept_id,'0001',"+g_t+","+g_t+")) + (nvl(c1.cnt,0)*"+p_o+") + ((nvl(c2.cnt,0)+nvl(c3.cnt,0))*"+p_t+") + (nvl(d1.cnt,0)*"+b_o+") + ((nvl(d2.cnt,0)+nvl(d3.cnt,0))*"+b_t+") + ( nvl(g1.cnt,0)*"+cg_b1+"+nvl(g2.cnt,0)*"+cg_b2+"+nvl(g3.cnt,0)*"+cg_m1+" ) + ( nvl(h1.cnt,0)*"+cb_b1+"+nvl(h2.cnt,0)*"+cb_b2+"+nvl(h3.cnt,0)*"+cb_m1+") ) desc"; 
		}else{
			query = " select c.nm, b.user_nm, b.user_id, b.enter_dt,"+
					" a.client_cnt_o, a.client_cnt_t, (a.client_cnt_o+a.client_cnt_t) as client_cnt, a.client_ga,"+
					" a.gen_cnt_o, a.gen_cnt_t, (a.gen_cnt_o+a.gen_cnt_t) as gen_cnt, a.gen_ga,"+
					" a.put_cnt_o, a.put_cnt_t, (a.put_cnt_o+a.put_cnt_t) as put_cnt, a.put_ga,"+
					" a.bas_cnt_o, a.bas_cnt_t, (a.bas_cnt_o+a.bas_cnt_t) as bas_cnt, a.bas_ga,"+
					" 0 cg_cnt_b1, 0 cg_cnt_b2, 0 cg_cnt_m1, 0 cg_ga, 0 cb_cnt_b1, 0 cb_cnt_b2, 0 cb_cnt_m1, 0 cb_ga"+
					" from stat_mng a, users b, code c"+
					" where a.user_id=b.user_id and b.dept_id=c.code and c.c_st='0002' and c.code<>'0000'"+
					" and b.dept_id='"+dept_id+"' and a.save_dt=replace('"+save_dt+"', '-', '')"+
					" order by a.seq"; 
		}

		try {

			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
				StatMngBean bean = new StatMngBean();
				
				bean.setDept_nm(rs.getString(1));
				bean.setUser_nm(rs.getString(2));
				bean.setUser_id(rs.getString(3));
				bean.setEnter_dt(rs.getString(4));
				bean.setClient_cnt_o(rs.getInt(5));
				bean.setClient_cnt_t(rs.getInt(6));
				bean.setClient_cnt(rs.getInt(7));
				bean.setClient_ga(rs.getFloat(8));
				bean.setGen_cnt_o(rs.getInt(9));
				bean.setGen_cnt_t(rs.getInt(10));
				bean.setGen_cnt(rs.getInt(11));
				bean.setGen_ga(rs.getFloat(12));
				bean.setPut_cnt_o(rs.getInt(13));
				bean.setPut_cnt_t(rs.getInt(14));
				bean.setPut_cnt(rs.getInt(15));
				bean.setPut_ga(rs.getFloat(16));
				bean.setBas_cnt_o(rs.getInt(17));
				bean.setBas_cnt_t(rs.getInt(18));
				bean.setBas_cnt(rs.getInt(19));
				bean.setBas_ga(rs.getFloat(20));
				bean.setC_Gen_cnt_b1(rs.getInt(21));
				bean.setC_Gen_cnt_b2(rs.getInt(22));
				bean.setC_Gen_cnt_m1(rs.getInt(23));
				bean.setC_Gen_ga(rs.getFloat(24));
				bean.setC_BP_cnt_b1(rs.getInt(25));
				bean.setC_BP_cnt_b2(rs.getInt(26));
				bean.setC_BP_cnt_m1(rs.getInt(27));
				bean.setC_BP_ga(rs.getFloat(28));

				bean.setDept_id(dept_id);

				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatMngDatabase:getStatMng4]"+e);
			System.out.println("[StatMngDatabase:getStatMng4]"+query);
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
	 *	���ϱ��� ��ȸ(�ܵ�,���� ����)-���� ����ġ
	 */
	public Vector getStatMng5(String br_id, String save_dt, String dept_id, String c_o, String c_t, String g_o, String g_t, String b_o, String b_t, String p_o, String p_t, String cg_b1, String cg_b2, String cg_m1, String cb_b1, String cb_b2, String cb_m1, String cc_o, String cc_t)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(save_dt.equals("")){
			query = " select f.nm, e.user_nm, e.user_id, e.enter_dt, "+
					" nvl(a1.cnt,0) c_cnt_o,"+
					" ( nvl(a2.cnt,0) + nvl(a3.cnt,0) ) c_cnt_t,"+
					" ( nvl(a1.cnt,0) + nvl(a2.cnt,0) + nvl(a3.cnt,0) ) c_cnt, "+
					" ( (nvl(a1.cnt,0)*"+c_o+") + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))*"+c_t+") ) c_ga, "+
					" nvl(b1.cnt,0) g_cnt_o,"+
					" ( nvl(b2.cnt,0) + nvl(b3.cnt,0) ) g_cnt_t,"+
					" ( nvl(b1.cnt,0) + nvl(b2.cnt,0) + nvl(b3.cnt,0) ) g_cnt,"+
					" ( (nvl(b1.cnt,0)*"+g_o+") + (nvl(b2.cnt,0)*decode(e.dept_id,'0001',"+g_t+","+g_t+")) + (nvl(b3.cnt,0)*decode(e.dept_id,'0001',"+g_t+","+g_t+")) ) g_ga, "+
					" nvl(c1.cnt,0) p_cnt_o,"+
					" ( nvl(c2.cnt,0) + nvl(c3.cnt,0) ) p_cnt_t,"+
					" ( nvl(c1.cnt,0) + nvl(c2.cnt,0) + nvl(c3.cnt,0)) p_cnt, "+
					" ( (nvl(c1.cnt,0)*"+p_o+") + ((nvl(c2.cnt,0)+nvl(c3.cnt,0))*"+p_t+") ) p_ga, "+
					" nvl(d1.cnt,0) b_cnt_o,"+
					" ( nvl(d2.cnt,0) + nvl(d3.cnt,0) ) b_cnt_t,"+
					" ( nvl(d1.cnt,0) + nvl(d2.cnt,0) + nvl(d3.cnt,0) ) b_cnt,"+
					" ( (nvl(d1.cnt,0)*"+b_o+") + ((nvl(d2.cnt,0)+nvl(d3.cnt,0))*"+b_t+") ) b_ga,"+
					" nvl(g1.cnt,0) cg_cnt_b1, nvl(g2.cnt,0) cg_cnt_b2, nvl(g3.cnt,0) cg_cnt_m1,"+
					" ( nvl(g1.cnt,0)*"+cg_b1+"+nvl(g2.cnt,0)*"+cg_b2+"+nvl(g3.cnt,0)*"+cg_m1+" ) cg_ga,"+
					" nvl(h1.cnt,0) cb_cnt_b1, nvl(h2.cnt,0) cb_cnt_b2, nvl(h3.cnt,0) cb_cnt_m1,"+
					" ( nvl(h1.cnt,0)*"+cb_b1+"+nvl(h2.cnt,0)*"+cb_b2+"+nvl(h3.cnt,0)*"+cb_m1+") cb_ga,"+//+
					" nvl(a1.cnt,0) cc_cnt_o,"+
					" ( nvl(a2.cnt,0) + nvl(a3.cnt,0) ) cc_cnt_t,"+
					" ( nvl(a1.cnt,0) + nvl(a2.cnt,0) + nvl(a3.cnt,0) ) cc_cnt, "+
					" ( (nvl(a1.cnt,0)*"+cc_o+") + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))*"+cc_t+") ) cc_ga"+
					" from  "+
					//�������
					" (select user_id from users where nvl(use_yn,'Y')='Y') u, "+
					//��ü��=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from (select a.bus_id2, a.client_id, count(0) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2=nvl(a.mng_id,a.bus_id2) group by a.bus_id2, a.client_id, a.r_site) a group by bus_id2) a1, "+
					//��ü��=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from (select a.bus_id2, a.client_id, count(0) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2<>a.mng_id group by a.bus_id2, a.client_id, a.r_site) a group by bus_id2) a2, "+
					//��ü��=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from (select a.mng_id, a.client_id, count(0) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2<>a.mng_id group by a.mng_id, a.client_id, a.r_site) a group by mng_id) a3, "+
					//�Ϲݽ�=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_mng_id is not null group by a.bus_id2) b1, "+
					//�Ϲݽ�=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.bus_id2) b2, "+
					//�Ϲݽ�=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.mng_id) b3, "+
					//�����=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_mng_id is not null group by a.bus_id2) c1, "+
					//�����=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.bus_id2) c2, "+
					//�����=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.mng_id) c3, "+
					//�⺻��=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_mng_id is not null group by a.bus_id2) d1, "+
					//�⺻��=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.bus_id2) d2, "+
					//�⺻��=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.mng_id) d3, "+
					//�Ϲݽ�=���ʿ���
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.car_mng_id is not null group by a.bus_id) g1, "+
					//�Ϲݽ�=��������
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.car_mng_id is not null group by a.bus_id2) g2, "+
					//�Ϲݽ�=�������
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.car_mng_id is not null group by a.mng_id) g3, "+
					//�⺻��/�����=���ʿ���
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way<>'1' and a.car_mng_id is not null group by a.bus_id) h1, "+
					//�⺻��/�����=��������
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way<>'1' and a.car_mng_id is not null group by a.bus_id2) h2, "+
					//�⺻��/�����=�������
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way<>'1' and a.car_mng_id is not null group by a.mng_id) h3, "+
					" users e, code f"+
					" where u.user_id=a1.user_id(+) and u.user_id=a2.user_id(+) and u.user_id=a3.user_id(+)  "+
					" and u.user_id=b1.user_id(+) and u.user_id=b2.user_id(+) and u.user_id=b3.user_id(+) "+
					" and u.user_id=c1.user_id(+) and u.user_id=c2.user_id(+) and u.user_id=c3.user_id(+) "+
					" and u.user_id=d1.user_id(+) and u.user_id=d2.user_id(+) and u.user_id=d3.user_id(+) "+
					" and u.user_id=g1.user_id(+) and u.user_id=g2.user_id(+) and u.user_id=g3.user_id(+) "+
					" and u.user_id=h1.user_id(+) and u.user_id=h2.user_id(+) and u.user_id=h3.user_id(+) "+
					" and u.user_id=e.user_id and e.dept_id=f.code(+) and f.c_st='0002' and f.code<>'0000' "+
					" and e.dept_id='"+dept_id+"'"+
					" and ((nvl(a1.cnt,0)) + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))) + ( nvl(g1.cnt,0)+nvl(g2.cnt,0)+nvl(g3.cnt,0) ) + ( nvl(h1.cnt,0)+nvl(h2.cnt,0)+nvl(h3.cnt,0)) ) > 0"+
					" order by ((nvl(a1.cnt,0)*"+cc_o+") + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))*"+cc_t+") + ( nvl(g1.cnt,0)*"+cg_b1+"+nvl(g2.cnt,0)*"+cg_b2+"+nvl(g3.cnt,0)*"+cg_m1+" ) + ( nvl(h1.cnt,0)*"+cb_b1+"+nvl(h2.cnt,0)*"+cb_b2+"+nvl(h3.cnt,0)*"+cb_m1+") ) desc"; 
		}else{
			query = " select c.nm, b.user_nm, b.user_id, b.enter_dt,"+
					" a.client_cnt_o, a.client_cnt_t, (a.client_cnt_o+a.client_cnt_t) as client_cnt, a.client_ga,"+
					" a.gen_cnt_o, a.gen_cnt_t, (a.gen_cnt_o+a.gen_cnt_t) as gen_cnt, a.gen_ga,"+
					" a.put_cnt_o, a.put_cnt_t, (a.put_cnt_o+a.put_cnt_t) as put_cnt, a.put_ga,"+
					" a.bas_cnt_o, a.bas_cnt_t, (a.bas_cnt_o+a.bas_cnt_t) as bas_cnt, a.bas_ga,"+
					" a.c_gen_cnt_b1, a.c_gen_cnt_b2, a.c_gen_cnt_m1, a.c_gen_ga, a.c_bp_cnt_b1, a.c_bp_cnt_b2, a.c_bp_cnt_m1, a.c_bp_ga,"+
					" a.c_client_cnt_o, a.c_client_cnt_t, (a.c_client_cnt_o+a.c_client_cnt_t) as c_client_cnt, a.c_client_ga"+
					" from stat_mng a, users b, code c"+
					" where a.user_id=b.user_id and b.dept_id=c.code and c.c_st='0002' and c.code<>'0000'"+
					" and b.dept_id='"+dept_id+"' and a.save_dt=replace('"+save_dt+"', '-', '')"+
					" order by a.seq"; 
		}

		try {

			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
				StatMngBean bean = new StatMngBean();
				
				bean.setDept_nm(rs.getString(1));
				bean.setUser_nm(rs.getString(2));
				bean.setUser_id(rs.getString(3));
				bean.setEnter_dt(rs.getString(4));
				bean.setClient_cnt_o(rs.getInt(5));
				bean.setClient_cnt_t(rs.getInt(6));
				bean.setClient_cnt(rs.getInt(7));
				bean.setClient_ga(rs.getFloat(8));
				bean.setGen_cnt_o(rs.getInt(9));
				bean.setGen_cnt_t(rs.getInt(10));
				bean.setGen_cnt(rs.getInt(11));
				bean.setGen_ga(rs.getFloat(12));
				bean.setPut_cnt_o(rs.getInt(13));
				bean.setPut_cnt_t(rs.getInt(14));
				bean.setPut_cnt(rs.getInt(15));
				bean.setPut_ga(rs.getFloat(16));
				bean.setBas_cnt_o(rs.getInt(17));
				bean.setBas_cnt_t(rs.getInt(18));
				bean.setBas_cnt(rs.getInt(19));
				bean.setBas_ga(rs.getFloat(20));
				bean.setC_Gen_cnt_b1(rs.getInt(21));
				bean.setC_Gen_cnt_b2(rs.getInt(22));
				bean.setC_Gen_cnt_m1(rs.getInt(23));
				bean.setC_Gen_ga(rs.getFloat(24));
				bean.setC_BP_cnt_b1(rs.getInt(25));
				bean.setC_BP_cnt_b2(rs.getInt(26));
				bean.setC_BP_cnt_m1(rs.getInt(27));
				bean.setC_BP_ga(rs.getFloat(28));
				bean.setC_Client_cnt_o(rs.getInt(29));
				bean.setC_Client_cnt_t(rs.getInt(30));
				bean.setC_Client_cnt(rs.getInt(31));
				bean.setC_Client_ga(rs.getFloat(32));
				bean.setDept_id(dept_id);

				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatMngDatabase:getStatMng5]"+e);
			System.out.println("[StatMngDatabase:getStatMng5]"+query);
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
	 *	���ϱ��� ��ȸ(�ܵ�,���� ����)-���� ����ġ -> �μ����� �ӿ��ڸ���..
	 */
	public Vector getStatMng6(String br_id, String save_dt, String dept_id, String c_o, String c_t, String g_o, String g_t, String b_o, String b_t, String p_o, String p_t, String cg_b1, String cg_b2, String cg_m1, String cb_b1, String cb_b2, String cb_m1, String cc_o, String cc_t)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if(save_dt.equals("")){
			query = " select f.nm, e.user_nm, e.user_id, e.enter_dt, "+
					" nvl(a1.cnt,0) c_cnt_o,"+
					" ( nvl(a2.cnt,0) + nvl(a3.cnt,0) ) c_cnt_t,"+
					" ( nvl(a1.cnt,0) + nvl(a2.cnt,0) + nvl(a3.cnt,0) ) c_cnt, "+
					" ( (nvl(a1.cnt,0)*"+c_o+") + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))*"+c_t+") ) c_ga, "+
					" nvl(b1.cnt,0) g_cnt_o,"+
					" ( nvl(b2.cnt,0) + nvl(b3.cnt,0) ) g_cnt_t,"+
					" ( nvl(b1.cnt,0) + nvl(b2.cnt,0) + nvl(b3.cnt,0) ) g_cnt,"+
					" ( (nvl(b1.cnt,0)*"+g_o+") + (nvl(b2.cnt,0)*decode(e.dept_id,'0001',"+g_t+","+g_t+")) + (nvl(b3.cnt,0)*decode(e.dept_id,'0001',"+g_t+","+g_t+")) ) g_ga, "+
					" nvl(c1.cnt,0) p_cnt_o,"+
					" ( nvl(c2.cnt,0) + nvl(c3.cnt,0) ) p_cnt_t,"+
					" ( nvl(c1.cnt,0) + nvl(c2.cnt,0) + nvl(c3.cnt,0)) p_cnt, "+
					" ( (nvl(c1.cnt,0)*"+p_o+") + ((nvl(c2.cnt,0)+nvl(c3.cnt,0))*"+p_t+") ) p_ga, "+
					" nvl(d1.cnt,0) b_cnt_o,"+
					" ( nvl(d2.cnt,0) + nvl(d3.cnt,0) ) b_cnt_t,"+
					" ( nvl(d1.cnt,0) + nvl(d2.cnt,0) + nvl(d3.cnt,0) ) b_cnt,"+
					" ( (nvl(d1.cnt,0)*"+b_o+") + ((nvl(d2.cnt,0)+nvl(d3.cnt,0))*"+b_t+") ) b_ga,"+
					" nvl(g1.cnt,0) cg_cnt_b1, nvl(g2.cnt,0) cg_cnt_b2, nvl(g3.cnt,0) cg_cnt_m1,"+
					" ( nvl(g1.cnt,0)*"+cg_b1+"+nvl(g2.cnt,0)*"+cg_b2+"+nvl(g3.cnt,0)*"+cg_m1+" ) cg_ga,"+
					" nvl(h1.cnt,0) cb_cnt_b1, nvl(h2.cnt,0) cb_cnt_b2, nvl(h3.cnt,0) cb_cnt_m1,"+
					" ( nvl(h1.cnt,0)*"+cb_b1+"+nvl(h2.cnt,0)*"+cb_b2+"+nvl(h3.cnt,0)*"+cb_m1+") cb_ga,"+//+
					" nvl(a1.cnt,0) cc_cnt_o,"+
					" ( nvl(a2.cnt,0) + nvl(a3.cnt,0) ) cc_cnt_t,"+
					" ( nvl(a1.cnt,0) + nvl(a2.cnt,0) + nvl(a3.cnt,0) ) cc_cnt, "+
					" ( (nvl(a1.cnt,0)*"+cc_o+") + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))*"+cc_t+") ) cc_ga,"+
					" ( nvl(g1.cnt,0)*"+cg_b1+"+nvl(h1.cnt,0)*"+cb_b1+") cnt_b1_ga,"+
					" ( nvl(g2.cnt,0)*"+cg_b2+"+nvl(h2.cnt,0)*"+cb_b2+") cnt_b2_ga,"+
					" ( nvl(g3.cnt,0)*"+cg_m1+"+nvl(h3.cnt,0)*"+cb_m1+") cnt_m1_ga"+
					" from  "+
					//�������
					" (select user_id from users where nvl(use_yn,'Y')='Y') u, "+
					//��ü��=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from (select a.bus_id2, a.client_id, count(0) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2=nvl(a.mng_id,a.bus_id2) group by a.bus_id2, a.client_id, a.r_site) a group by bus_id2) a1, "+
					//��ü��=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from (select a.bus_id2, a.client_id, count(0) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2<>a.mng_id group by a.bus_id2, a.client_id, a.r_site) a group by bus_id2) a2, "+
					//��ü��=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from (select a.mng_id, a.client_id, count(0) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2<>a.mng_id group by a.mng_id, a.client_id, a.r_site) a group by mng_id) a3, "+
					//�Ϲݽ�=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_mng_id is not null group by a.bus_id2) b1, "+
					//�Ϲݽ�=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.bus_id2) b2, "+
					//�Ϲݽ�=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.mng_id) b3, "+
					//�����=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_mng_id is not null group by a.bus_id2) c1, "+
					//�����=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.bus_id2) c2, "+
					//�����=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.mng_id) c3, "+
					//�⺻��=�ܵ�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_mng_id is not null group by a.bus_id2) d1, "+
					//�⺻��=����(����)
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.bus_id2) d2, "+
					//�⺻��=����(����)
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.mng_id) d3, "+
					//�Ϲݽ�=���ʿ���
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.car_mng_id is not null group by a.bus_id) g1, "+
					//�Ϲݽ�=��������
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.car_mng_id is not null group by a.bus_id2) g2, "+
					//�Ϲݽ�=�������
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.car_mng_id is not null group by a.mng_id) g3, "+
					//�⺻��/�����=���ʿ���
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way<>'1' and a.car_mng_id is not null group by a.bus_id) h1, "+
					//�⺻��/�����=��������
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way<>'1' and a.car_mng_id is not null group by a.bus_id2) h2, "+
					//�⺻��/�����=�������
					" (select nvl(a.mng_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way<>'1' and a.car_mng_id is not null group by a.mng_id) h3, "+
					" users e, code f"+
					" where u.user_id=a1.user_id(+) and u.user_id=a2.user_id(+) and u.user_id=a3.user_id(+)  "+
					" and u.user_id=b1.user_id(+) and u.user_id=b2.user_id(+) and u.user_id=b3.user_id(+) "+
					" and u.user_id=c1.user_id(+) and u.user_id=c2.user_id(+) and u.user_id=c3.user_id(+) "+
					" and u.user_id=d1.user_id(+) and u.user_id=d2.user_id(+) and u.user_id=d3.user_id(+) "+
					" and u.user_id=g1.user_id(+) and u.user_id=g2.user_id(+) and u.user_id=g3.user_id(+) "+
					" and u.user_id=h1.user_id(+) and u.user_id=h2.user_id(+) and u.user_id=h3.user_id(+) "+
					" and u.user_id=e.user_id and e.dept_id=f.code(+) and f.c_st='0002' and f.code<>'0000' "+
					" and ((nvl(a1.cnt,0)) + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))) + ( nvl(g1.cnt,0)+nvl(g2.cnt,0)+nvl(g3.cnt,0) ) + ( nvl(h1.cnt,0)+nvl(h2.cnt,0)+nvl(h3.cnt,0)) ) > 0";
      if(dept_id.equals("0004")){
  		  query += " and e.user_pos not in ('���','�븮','����','����','����') and e.loan_st is null";
		  }else{
  		  query += " and e.dept_id='"+dept_id+"' and e.loan_st in ('1','2')";
	    }
      query += " and e.user_id<>'000008'";	    
      query += " order by ((nvl(a1.cnt,0)*"+cc_o+") + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))*"+cc_t+") + ( nvl(g1.cnt,0)*"+cg_b1+"+nvl(g2.cnt,0)*"+cg_b2+"+nvl(g3.cnt,0)*"+cg_m1+" ) + ( nvl(h1.cnt,0)*"+cb_b1+"+nvl(h2.cnt,0)*"+cb_b2+"+nvl(h3.cnt,0)*"+cb_m1+") ) desc"; 
		}else{
			query = " select c.nm, b.user_nm, b.user_id, b.enter_dt,"+
					" a.client_cnt_o, a.client_cnt_t, (a.client_cnt_o+a.client_cnt_t) as client_cnt, a.client_ga,"+
					" a.gen_cnt_o, a.gen_cnt_t, (a.gen_cnt_o+a.gen_cnt_t) as gen_cnt, a.gen_ga,"+
					" a.put_cnt_o, a.put_cnt_t, (a.put_cnt_o+a.put_cnt_t) as put_cnt, a.put_ga,"+
					" a.bas_cnt_o, a.bas_cnt_t, (a.bas_cnt_o+a.bas_cnt_t) as bas_cnt, a.bas_ga,"+
					" a.c_gen_cnt_b1, a.c_gen_cnt_b2, a.c_gen_cnt_m1, a.c_gen_ga, a.c_bp_cnt_b1, a.c_bp_cnt_b2, a.c_bp_cnt_m1, a.c_bp_ga,"+
					" a.c_client_cnt_o, a.c_client_cnt_t, (a.c_client_cnt_o+a.c_client_cnt_t) as c_client_cnt, a.c_client_ga,"+
					" a.cnt_b1_ga, a.cnt_b2_ga, a.cnt_m1_ga"+
					" from stat_mng a, users b, code c"+
					" where a.user_id=b.user_id and b.dept_id=c.code and c.c_st='0002' and c.code<>'0000'"+
          " and a.save_dt=replace('"+save_dt+"', '-', '')";
      if(dept_id.equals("0004")){
  		  query += " and b.user_pos not in ('���','�븮','����','����','����') and b.loan_st is null";
		  }else{
  		  query += " and b.dept_id='"+dept_id+"' and b.loan_st in ('1','2')";
	    }          
	    
      query += " and b.user_id<>'000008'";
      
      query += " order by a.seq";
		}

		try {

			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
				StatMngBean bean = new StatMngBean();
				
				bean.setDept_nm(rs.getString(1));
				bean.setUser_nm(rs.getString(2));
				bean.setUser_id(rs.getString(3));
				bean.setEnter_dt(rs.getString(4));
				bean.setClient_cnt_o(rs.getInt(5));
				bean.setClient_cnt_t(rs.getInt(6));
				bean.setClient_cnt(rs.getInt(7));
				bean.setClient_ga(rs.getFloat(8));
				bean.setGen_cnt_o(rs.getInt(9));
				bean.setGen_cnt_t(rs.getInt(10));
				bean.setGen_cnt(rs.getInt(11));
				bean.setGen_ga(rs.getFloat(12));
				bean.setPut_cnt_o(rs.getInt(13));
				bean.setPut_cnt_t(rs.getInt(14));
				bean.setPut_cnt(rs.getInt(15));
				bean.setPut_ga(rs.getFloat(16));
				bean.setBas_cnt_o(rs.getInt(17));
				bean.setBas_cnt_t(rs.getInt(18));
				bean.setBas_cnt(rs.getInt(19));
				bean.setBas_ga(rs.getFloat(20));
				bean.setC_Gen_cnt_b1(rs.getInt(21));
				bean.setC_Gen_cnt_b2(rs.getInt(22));
				bean.setC_Gen_cnt_m1(rs.getInt(23));
				bean.setC_Gen_ga(rs.getFloat(24));
				bean.setC_BP_cnt_b1(rs.getInt(25));
				bean.setC_BP_cnt_b2(rs.getInt(26));
				bean.setC_BP_cnt_m1(rs.getInt(27));
				bean.setC_BP_ga(rs.getFloat(28));
				bean.setC_Client_cnt_o(rs.getInt(29));
				bean.setC_Client_cnt_t(rs.getInt(30));
				bean.setC_Client_cnt(rs.getInt(31));
				bean.setC_Client_ga(rs.getFloat(32));
				bean.setCnt_b1_ga(rs.getFloat(33));
				bean.setCnt_b2_ga(rs.getFloat(34));
				bean.setCnt_m1_ga(rs.getFloat(35));
				bean.setDept_id(dept_id);

				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatMngDatabase:getStatMng6]"+e);
			System.out.println("[StatMngDatabase:getStatMng6]"+query);
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
	 *	���ϱ��� ��ȸ(�ܵ�,���� ����)-���� ����ġ -> �μ����� �ӿ��ڸ���..-> ������ϱ��ؿ��� �뿩���ñ�������
	 */
	public Vector getStatMng7(String br_id, String save_dt, String dept_id, String c_o, String c_t, String g_o, String g_t, String b_o, String b_t, String p_o, String p_t, String cg_b1, String cg_b2, String cg_m1, String cb_b1, String cb_b2, String cb_m1, String cc_o, String cc_t)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		if(save_dt.equals("")){
			query = " select f.nm, e.user_nm, e.user_id, e.enter_dt, "+
					" nvl(a1.cnt,0) c_cnt_o,"+
					" ( nvl(a2.cnt,0) + nvl(a3.cnt,0) ) c_cnt_t,"+
					" ( nvl(a1.cnt,0) + nvl(a2.cnt,0) + nvl(a3.cnt,0) ) c_cnt, "+
					" ( (nvl(a1.cnt,0)*"+c_o+") + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))*"+c_t+") ) c_ga, "+
					" nvl(b1.cnt,0) g_cnt_o,"+
					" ( nvl(b2.cnt,0) + nvl(b3.cnt,0) ) g_cnt_t,"+
					" ( nvl(b1.cnt,0) + nvl(b2.cnt,0) + nvl(b3.cnt,0) ) g_cnt,"+
					" ( (nvl(b1.cnt,0)*"+g_o+") + ((nvl(b2.cnt,0)+nvl(b3.cnt,0))*"+g_t+") ) g_ga, "+
					" nvl(c1.cnt,0) p_cnt_o,"+
					" ( nvl(c2.cnt,0) + nvl(c3.cnt,0) ) p_cnt_t,"+
					" ( nvl(c1.cnt,0) + nvl(c2.cnt,0) + nvl(c3.cnt,0)) p_cnt, "+
					" ( (nvl(c1.cnt,0)*"+p_o+") + ((nvl(c2.cnt,0)+nvl(c3.cnt,0))*"+p_t+") ) p_ga, "+
					" nvl(d1.cnt,0) b_cnt_o,"+
					" ( nvl(d2.cnt,0) + nvl(d3.cnt,0) ) b_cnt_t,"+
					" ( nvl(d1.cnt,0) + nvl(d2.cnt,0) + nvl(d3.cnt,0) ) b_cnt,"+
					" ( (nvl(d1.cnt,0)*"+b_o+") + ((nvl(d2.cnt,0)+nvl(d3.cnt,0))*"+b_t+") ) b_ga,"+
					" nvl(g1.cnt,0) cg_cnt_b1, nvl(g2.cnt,0) cg_cnt_b2, nvl(g3.cnt,0) cg_cnt_m1,"+
					" ( nvl(g1.cnt,0)*"+cg_b1+"+nvl(g2.cnt,0)*"+cg_b2+"+nvl(g3.cnt,0)*"+cg_m1+" ) cg_ga,"+
					" nvl(h1.cnt,0) cb_cnt_b1, nvl(h2.cnt,0) cb_cnt_b2, nvl(h3.cnt,0) cb_cnt_m1,"+
					" ( nvl(h1.cnt,0)*"+cb_b1+"+nvl(h2.cnt,0)*"+cb_b2+"+nvl(h3.cnt,0)*"+cb_m1+") cb_ga,"+//+
					" nvl(a1.cnt,0) cc_cnt_o,"+
					" ( nvl(a2.cnt,0) + nvl(a3.cnt,0) ) cc_cnt_t,"+
					" ( nvl(a1.cnt,0) + nvl(a2.cnt,0) + nvl(a3.cnt,0) ) cc_cnt, "+
					" ( (nvl(a1.cnt,0)*"+cc_o+") + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))*"+cc_t+") ) cc_ga,"+
					" ( nvl(g1.cnt,0)*"+cg_b1+"+nvl(h1.cnt,0)*"+cb_b1+") cnt_b1_ga,"+
					" ( nvl(g2.cnt,0)*"+cg_b2+"+nvl(h2.cnt,0)*"+cb_b2+") cnt_b2_ga,"+
					" ( nvl(g3.cnt,0)*"+cg_m1+"+nvl(h3.cnt,0)*"+cb_m1+") cnt_m1_ga,"+
					" nvl(h4.cnt,0) ins_cnt_b2 "+ 
					" from  "+
					//�������
					" (select user_id from users where nvl(use_yn,'Y')='Y') u, "+
					//��ü��=�ܵ�
					" (select nvl(bus_id2,'999999') as user_id, count(0) cnt from (select bus_id2, client_id, count(0) cnt from cont_n_view  where nvl(use_yn,'Y')='Y' and car_st not in ('2','5') and bus_id2=nvl(mng_id,bus_id2) group by bus_id2, client_id, r_site) group by bus_id2) a1, "+
					//��ü��=����(����)
					" (select nvl(bus_id2,'999999') as user_id, count(0) cnt from (select bus_id2, client_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st not in ('2','5') and bus_id2<>mng_id group by bus_id2, client_id, r_site) group by bus_id2) a2, "+
					//��ü��=����(����)
					" (select nvl(mng_id,'999999') as user_id, count(0) cnt from (select mng_id, client_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st not in ('2','5') and bus_id2<>mng_id group by mng_id, client_id, r_site) group by mng_id) a3, "+
					//�Ϲݽ�=�ܵ�
					" (select nvl(bus_id2,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st not in ('2','5') and rent_way_cd='1' and bus_id2=nvl(mng_id,bus_id2) and rent_start_dt is not null group by bus_id2) b1, "+
					//�Ϲݽ�=����(����)
					" (select nvl(bus_id2,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st not in ('2','5') and rent_way_cd='1' and bus_id2<>mng_id and rent_start_dt is not null group by bus_id2) b2, "+
					//�Ϲݽ�=����(����)
					" (select nvl(mng_id, '999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st not in ('2','5') and rent_way_cd='1' and bus_id2<>mng_id and rent_start_dt is not null group by mng_id) b3, "+
					//�����=�ܵ�
					" (select nvl(bus_id2,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st not in ('2','5') and rent_way_cd='2' and bus_id2=nvl(mng_id,bus_id2) and rent_start_dt is not null group by bus_id2) c1, "+
					//�����=����(����)
					" (select nvl(bus_id2,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st not in ('2','5') and rent_way_cd='2' and bus_id2<>mng_id and rent_start_dt is not null group by bus_id2) c2, "+
					//�����=����(����)
					" (select nvl(mng_id, '999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st not in ('2','5') and rent_way_cd='2' and bus_id2<>mng_id and rent_start_dt is not null group by mng_id) c3, "+
					//�⺻��=�ܵ�
					" (select nvl(bus_id2,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st not in ('2','5') and rent_way_cd='3' and bus_id2=nvl(mng_id,bus_id2) and rent_start_dt is not null group by bus_id2) d1, "+
					//�⺻��=����(����)
					" (select nvl(bus_id2,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st not in ('2','5') and rent_way_cd='3' and bus_id2<>mng_id and rent_start_dt is not null group by bus_id2) d2, "+
					//�⺻��=����(����)
					" (select nvl(mng_id, '999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st not in ('2','5') and rent_way_cd='3' and bus_id2<>mng_id and rent_start_dt is not null group by mng_id) d3, "+
					//�Ϲݽ�=���ʿ���
					" (select nvl(bus_id, '999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st not in ('2','5') and rent_way_cd='1' and rent_start_dt is not null group by bus_id) g1, "+
					//�Ϲݽ�=��������
					" (select nvl(bus_id2,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st not in ('2','5') and rent_way_cd='1' and rent_start_dt is not null group by bus_id2) g2, "+
					//�Ϲݽ�=�������
					" (select nvl(mng_id, '999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st not in ('2','5') and rent_way_cd='1' and rent_start_dt is not null group by mng_id) g3, "+
					//�⺻��/�����=���ʿ���
					" (select nvl(bus_id, '999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st not in ('2','5') and rent_way_cd<>'1' and rent_start_dt is not null group by bus_id) h1, "+
					//�⺻��/�����=��������
					" (select nvl(bus_id2,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st not in ('2','5') and rent_way_cd<>'1' and rent_start_dt is not null group by bus_id2) h2, "+
					//�⺻��/�����=�������
					" (select nvl(mng_id, '999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st not in ('2','5') and rent_way_cd<>'1' and rent_start_dt is not null group by mng_id) h3, "+
					//�⺻��/�����- �Ǻ����ڰ� �Ƹ���ī �ܴ̿� ���� - 20101115 �߰�
					" ( select nvl(c.bus_id2,'999999') as user_id, count(0) cnt from cont_n_view c, insur i , ( select car_mng_id, max(ins_st) ins_st  from insur group by car_mng_id ) ii  where nvl(c.use_yn,'Y')='Y' and c.car_st not in ('2','5') and c.rent_way_cd <>'1' "+
         			"	 and c.car_mng_id = i.car_mng_id and c.car_mng_id = ii.car_mng_id and ii.car_mng_id = i.car_mng_id and ii.ins_st = i.ins_st and i.con_f_nm like '%�Ƹ���ī%'   and c.rent_start_dt is not null group by c.bus_id2     ) h4,  "+
          			" users e, code f"+
					" where u.user_id=a1.user_id(+) and u.user_id=a2.user_id(+) and u.user_id=a3.user_id(+)  "+
					" and u.user_id=b1.user_id(+) and u.user_id=b2.user_id(+) and u.user_id=b3.user_id(+) "+
					" and u.user_id=c1.user_id(+) and u.user_id=c2.user_id(+) and u.user_id=c3.user_id(+) "+
					" and u.user_id=d1.user_id(+) and u.user_id=d2.user_id(+) and u.user_id=d3.user_id(+) "+
					" and u.user_id=g1.user_id(+) and u.user_id=g2.user_id(+) and u.user_id=g3.user_id(+) "+
					" and u.user_id=h1.user_id(+) and u.user_id=h2.user_id(+) and u.user_id=h3.user_id(+)  and u.user_id=h4.user_id(+) "+
					" and u.user_id=e.user_id and e.dept_id=f.code(+) and f.c_st='0002' and f.code<>'0000' "+
					" and ((nvl(a1.cnt,0)) + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))) + ( nvl(g1.cnt,0)+nvl(g2.cnt,0)+nvl(g3.cnt,0) ) + ( nvl(h1.cnt,0)+nvl(h2.cnt,0)+nvl(h3.cnt,0)) ) > 0";

			if(!br_id.equals("")) query += " and e.br_id='"+br_id+"'";

			if(dept_id.equals("0004")){
  				query += " and e.user_pos not in ('���','�븮','����','����','����') and e.loan_st is null";
			}else{
  				query += " and e.dept_id='"+dept_id+"' and e.loan_st in ('1','2')";
			}	
			query += " and e.user_id<>'000008'";	    
			query += " order by ((nvl(a1.cnt,0)*"+cc_o+") + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))*"+cc_t+") + ( nvl(g1.cnt,0)*"+cg_b1+"+nvl(g2.cnt,0)*"+cg_b2+"+nvl(g3.cnt,0)*"+cg_m1+" ) + ( nvl(h1.cnt,0)*"+cb_b1+"+nvl(h2.cnt,0)*"+cb_b2+"+nvl(h3.cnt,0)*"+cb_m1+") ) desc"; 

		}else{
			query = " select c.nm, b.user_nm, b.user_id, b.enter_dt,"+
					" a.client_cnt_o, a.client_cnt_t, (a.client_cnt_o+a.client_cnt_t) as client_cnt, a.client_ga,"+
					" a.gen_cnt_o, a.gen_cnt_t, (a.gen_cnt_o+a.gen_cnt_t) as gen_cnt, a.gen_ga,"+
					" a.put_cnt_o, a.put_cnt_t, (a.put_cnt_o+a.put_cnt_t) as put_cnt, a.put_ga,"+
					" a.bas_cnt_o, a.bas_cnt_t, (a.bas_cnt_o+a.bas_cnt_t) as bas_cnt, a.bas_ga,"+
					" a.c_gen_cnt_b1, a.c_gen_cnt_b2, a.c_gen_cnt_m1, a.c_gen_ga, a.c_bp_cnt_b1, a.c_bp_cnt_b2, a.c_bp_cnt_m1, a.c_bp_ga,"+
					" a.c_client_cnt_o, a.c_client_cnt_t, (a.c_client_cnt_o+a.c_client_cnt_t) as c_client_cnt, a.c_client_ga,"+
					" a.cnt_b1_ga, a.cnt_b2_ga, a.cnt_m1_ga, a.ins_cnt_b2"+
					" from stat_mng a, users b, code c"+
					" where a.user_id=b.user_id and b.dept_id=c.code and c.c_st='0002' and c.code<>'0000'"+
					" and a.save_dt=replace('"+save_dt+"', '-', '')";

			
			if(!br_id.equals("")) query += " and b.br_id='"+br_id+"'";
	  
			if(dept_id.equals("0004")){
  				query += " and b.user_pos not in ('���','�븮','����','����','����') and b.loan_st is null";
			} else if ( dept_id.equals("0002")) { 
				query += " and b.dept_id in (  '0002', '0014', '0015' ) and b.loan_st in ('1','2')";
			} else{
			   	query += " and b.dept_id='"+dept_id+"' and b.loan_st in ('1','2')";
			}          
	    
			query += " and b.user_id<>'000008'";
      
			query += " order by a.seq";
		}

		try {

			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
	    	
			while(rs.next())
			{				
				StatMngBean bean = new StatMngBean();
				
				bean.setDept_nm(rs.getString(1));
				bean.setUser_nm(rs.getString(2));
				bean.setUser_id(rs.getString(3));
				bean.setEnter_dt(rs.getString(4));
				bean.setClient_cnt_o(rs.getInt(5));
				bean.setClient_cnt_t(rs.getInt(6));
				bean.setClient_cnt(rs.getInt(7));
				bean.setClient_ga(rs.getFloat(8));
				bean.setGen_cnt_o(rs.getInt(9));
				bean.setGen_cnt_t(rs.getInt(10));
				bean.setGen_cnt(rs.getInt(11));
				bean.setGen_ga(rs.getFloat(12));
				bean.setPut_cnt_o(rs.getInt(13));
				bean.setPut_cnt_t(rs.getInt(14));
				bean.setPut_cnt(rs.getInt(15));
				bean.setPut_ga(rs.getFloat(16));
				bean.setBas_cnt_o(rs.getInt(17));
				bean.setBas_cnt_t(rs.getInt(18));
				bean.setBas_cnt(rs.getInt(19));
				bean.setBas_ga(rs.getFloat(20));
				bean.setC_Gen_cnt_b1(rs.getInt(21));
				bean.setC_Gen_cnt_b2(rs.getInt(22));
				bean.setC_Gen_cnt_m1(rs.getInt(23));
				bean.setC_Gen_ga(rs.getFloat(24));
				bean.setC_BP_cnt_b1(rs.getInt(25));
				bean.setC_BP_cnt_b2(rs.getInt(26));
				bean.setC_BP_cnt_m1(rs.getInt(27));
				bean.setC_BP_ga(rs.getFloat(28));
				bean.setC_Client_cnt_o(rs.getInt(29));
				bean.setC_Client_cnt_t(rs.getInt(30));
				bean.setC_Client_cnt(rs.getInt(31));
				bean.setC_Client_ga(rs.getFloat(32));
				bean.setCnt_b1_ga(rs.getFloat(33));
				bean.setCnt_b2_ga(rs.getFloat(34));
				bean.setCnt_m1_ga(rs.getFloat(35));
				bean.setIns_cnt_b2(rs.getInt(36));
				bean.setDept_id(dept_id);

				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatMngDatabase:getStatMng7]"+e);
			System.out.println("[StatMngDatabase:getStatMng7]"+query);
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
	 *	���� ��ȸ
	 */
	public Vector getStatMng(String save_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select c.nm, b.user_nm, a.user_id, b.enter_dt,"+
				" a.client_cnt, a.client_ga, a.gen_cnt, a.gen_ga, a.put_cnt, a.put_ga, a.bas_cnt, a.bas_ga"+
				" from stat_mng a, users b, code c"+
				" where a.user_id=b.user_id and b.dept_id=c.code and c.c_st='0002' c.code<>'0000'"+
				" and a.save_dt=replace(?, '-', '') order by a.seq";


		try {

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, save_dt);		
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
				StatMngBean bean = new StatMngBean();

				bean.setDept_nm(rs.getString(1));
				bean.setUser_nm(rs.getString(2));
				bean.setUser_id(rs.getString(3));
				bean.setEnter_dt(rs.getString(4));
				bean.setClient_cnt(rs.getInt(5));
				bean.setClient_ga(rs.getFloat(6));
				bean.setGen_cnt(rs.getInt(7));
				bean.setGen_ga(rs.getFloat(8));
				bean.setPut_cnt(rs.getInt(9));
				bean.setPut_ga(rs.getFloat(10));
				bean.setBas_cnt(rs.getInt(11));
				bean.setBas_ga(rs.getFloat(12));

				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatMngDatabase:getStatMng(save_dt)]"+e);
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
	 *	���ϱ��� ��ȸ(�ܵ�,���� ����)-���� ����ġ
	 */
	public Vector getStatMngAvg(String br_id, String s_yy, String s_mm, String dept_id, String c_o, String c_t, String g_o, String g_t, String b_o, String b_t, String p_o, String p_t, String cg_b1, String cg_b2, String cg_m1, String cb_b1, String cb_b2, String cb_m1, String cc_o, String cc_t)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select c.nm, b.user_nm, b.user_id, b.enter_dt,"+
				" a.client_cnt_o, a.client_cnt_t, a.client_cnt, a.client_ga,"+
				" a.gen_cnt_o, a.gen_cnt_t, a.gen_cnt, a.gen_ga,"+
				" a.put_cnt_o, a.put_cnt_t, a.put_cnt, a.put_ga,"+
				" a.bas_cnt_o, a.bas_cnt_t, a.bas_cnt, a.bas_ga,"+
				" a.c_gen_cnt_b1, a.c_gen_cnt_b2, a.c_gen_cnt_m1, a.c_gen_ga,"+
				" a.c_bp_cnt_b1, a.c_bp_cnt_b2, a.c_bp_cnt_m1, a.c_bp_ga,"+
				" a.c_client_cnt_o, a.c_client_cnt_t, a.c_client_cnt, a.c_client_ga,"+
				" a.cnt_b1_ga, a.cnt_b2_ga, a.cnt_m1_ga \n"+
				" from"+
				" (select user_id, "+
				"	avg(client_cnt_o) client_cnt_o, avg(client_cnt_t) client_cnt_t, avg(client_cnt_o+client_cnt_t) client_cnt, avg(client_ga) client_ga,"+
				"	avg(gen_cnt_o) gen_cnt_o, avg(gen_cnt_t) gen_cnt_t, avg(gen_cnt_o+gen_cnt_t) gen_cnt, avg(gen_ga) gen_ga,"+
				"	avg(put_cnt_o) put_cnt_o, avg(put_cnt_t) put_cnt_t, avg(put_cnt_o+put_cnt_t) put_cnt, avg(gen_ga) put_ga,"+
				"	avg(bas_cnt_o) bas_cnt_o, avg(bas_cnt_t) bas_cnt_t, avg(bas_cnt_o+bas_cnt_t) bas_cnt, avg(bas_ga) bas_ga, \n"+

				"	avg(c_gen_cnt_b1) c_gen_cnt_b1, avg(c_gen_cnt_b2) c_gen_cnt_b2, avg(c_gen_cnt_m1) c_gen_cnt_m1, avg(c_gen_ga) c_gen_ga,"+
				"	avg(c_bp_cnt_b1) c_bp_cnt_b1, avg(c_bp_cnt_b2) c_bp_cnt_b2, avg(c_bp_cnt_m1) c_bp_cnt_m1, avg(c_bp_ga) c_bp_ga,"+
				"	avg(c_client_cnt_o) c_client_cnt_o, avg(c_client_cnt_t) c_client_cnt_t, trunc(avg(c_client_cnt_o+c_client_cnt_t),2) c_client_cnt, avg(c_client_ga) c_client_ga,"+
				"	trunc(avg(cnt_b1_ga),2) cnt_b1_ga, trunc(avg(cnt_b2_ga),2) cnt_b2_ga, trunc(avg(cnt_m1_ga),2) cnt_m1_ga "+

				"	from stat_mng where save_dt between replace('"+s_yy+"','-','') and replace('"+s_mm+"','-','') group by user_id) a,"+
				" users b, code c \n"+
				" where a.user_id=b.user_id and b.dept_id=c.code and c.c_st='0002' and c.code<>'0000' and b.loan_st in ('1', '2') \n"+
				" and b.user_id<>'000002'";

		if(!br_id.equals("")) query += " and b.br_id='"+br_id+"'";

		if(dept_id.equals("0004")){
  				query += " and b.user_pos not in ('���','�븮','����','����','����') and b.loan_st is null ";
		} else if(dept_id.equals("all") ){
				query += "  and b.dept_id in ('0001','0002', '0007', '0008','0009','0010','0011', '0012', '0013','0014','0015','0016' , '0017', '0018'  ) "+
				                 "  and b.loan_st in ('1','2') \n";		
		} else {
				query += " and b.dept_id='"+dept_id+"' and b.loan_st in ('1','2')";
		}
		
		
		query +=" order by  b.dept_id, (a.cnt_b1_ga+a.cnt_b2_ga+a.cnt_m1_ga+a.c_client_ga) desc";

		try {

			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
	    	

			while(rs.next())
			{				
				StatMngBean bean = new StatMngBean();
				
				bean.setDept_nm(rs.getString(1));
				bean.setUser_nm(rs.getString(2));
				bean.setUser_id(rs.getString(3));
				bean.setEnter_dt(rs.getString(4));
				bean.setClient_cnt_o(rs.getInt(5));
				bean.setClient_cnt_t(rs.getInt(6));
				bean.setClient_cnt(rs.getInt(7));
				bean.setClient_ga(rs.getFloat(8));
				bean.setGen_cnt_o(rs.getInt(9));
				bean.setGen_cnt_t(rs.getInt(10));
				bean.setGen_cnt(rs.getInt(11));
				bean.setGen_ga(rs.getFloat(12));
				bean.setPut_cnt_o(rs.getInt(13));
				bean.setPut_cnt_t(rs.getInt(14));
				bean.setPut_cnt(rs.getInt(15));
				bean.setPut_ga(rs.getFloat(16));
				bean.setBas_cnt_o(rs.getInt(17));
				bean.setBas_cnt_t(rs.getInt(18));
				bean.setBas_cnt(rs.getInt(19));
				bean.setBas_ga(rs.getFloat(20));
				bean.setC_Gen_cnt_b1(rs.getInt(21));
				bean.setC_Gen_cnt_b2(rs.getInt(22));
				bean.setC_Gen_cnt_m1(rs.getInt(23));
				bean.setC_Gen_ga(rs.getFloat(24));
				bean.setC_BP_cnt_b1(rs.getInt(25));
				bean.setC_BP_cnt_b2(rs.getInt(26));
				bean.setC_BP_cnt_m1(rs.getInt(27));
				bean.setC_BP_ga(rs.getFloat(28));
				bean.setC_Client_cnt_o(rs.getInt(29));
				bean.setC_Client_cnt_t(rs.getInt(30));
				bean.setC_Client_cnt(rs.getInt(31));
				bean.setC_Client_ga(rs.getFloat(32));
				bean.setCnt_b1_ga(rs.getFloat(33));
				bean.setCnt_b2_ga(rs.getFloat(34));
				bean.setCnt_m1_ga(rs.getFloat(35));

				bean.setDept_id(dept_id);

				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatMngDatabase:getStatMngAvg]"+e);
			System.out.println("[StatMngDatabase:getStatMngAvg]"+query);
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
	 *	�ڵ���������Ȳ ���
	 */
	public boolean insertStatMng(StatMngBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		int chk = 0;

		String query = " insert into stat_mng values (?, ?, ?, ?, ?, ?, ?, ?,"+
						" ?, ?, ?, ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), 'Y',"+
						" ?, ?, ?, ?, ?, ?, ?, ?,"+
						" ?, ?, ?, ?, ?, ?, ?)";	
		
		//�Է�üũ
		String query2 = "select count(0) from stat_mng where save_dt=? and seq=?";

		try 
		{
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, bean.getSave_dt());
			pstmt2.setString(2, bean.getSeq());
	    		rs = pstmt2.executeQuery();
			if(rs.next()){
				chk = rs.getInt(1);	
			}
			rs.close();
			pstmt2.close();

			if(chk==0){
				pstmt = conn.prepareStatement(query);
				pstmt.setString	(1,  bean.getSave_dt()			);		
				pstmt.setString	(2,  bean.getSeq()				);	
				pstmt.setString	(3,  bean.getUser_id()			);	
				pstmt.setInt	(4,  bean.getClient_cnt_o()		);
				pstmt.setInt	(5,  bean.getClient_cnt_t()		);
				pstmt.setFloat	(6,  bean.getClient_ga()		);
				pstmt.setInt	(7,  bean.getGen_cnt_o()		);
				pstmt.setInt	(8,  bean.getGen_cnt_t()		);
				pstmt.setFloat	(9,  bean.getGen_ga()			);
				pstmt.setInt	(10, bean.getPut_cnt_o()		);
				pstmt.setInt	(11, bean.getPut_cnt_t()		);
				pstmt.setFloat	(12, bean.getPut_ga()			);
				pstmt.setInt	(13, bean.getBas_cnt_o()		);
				pstmt.setInt	(14, bean.getBas_cnt_t()		);
				pstmt.setFloat	(15, bean.getBas_ga()			);
				pstmt.setString	(16, bean.getReg_id()			);		
				pstmt.setInt	(17, bean.getC_Gen_cnt_b1()		);
				pstmt.setInt	(18, bean.getC_Gen_cnt_b2()		);
				pstmt.setInt	(19, bean.getC_Gen_cnt_m1()		);
				pstmt.setFloat	(20, bean.getC_Gen_ga()			);
				pstmt.setInt	(21, bean.getC_BP_cnt_b1()		);
				pstmt.setInt	(22, bean.getC_BP_cnt_b2()		);
				pstmt.setInt	(23, bean.getC_BP_cnt_m1()		);
				pstmt.setFloat	(24, bean.getC_BP_ga()			);
				pstmt.setInt	(25, bean.getC_Client_cnt_o()	);
				pstmt.setInt	(26, bean.getC_Client_cnt_t()	);
				pstmt.setFloat	(27, bean.getC_Client_ga()		);
				pstmt.setFloat	(28, bean.getCnt_b1_ga()		);
				pstmt.setFloat	(29, bean.getCnt_b2_ga()		);
				pstmt.setFloat	(30, bean.getCnt_m1_ga()		);
				pstmt.setInt	(31, bean.getIns_cnt_b2()		);
			   	pstmt.executeUpdate();
				pstmt.close();
			}
					
			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[StatMngDatabase:insertStatMng]"+e);

			System.out.println("[bean.getSave_dt()			]"+bean.getSave_dt()		);
			System.out.println("[bean.getSeq()				]"+bean.getSeq()			);
			System.out.println("[bean.getUser_id()			]"+bean.getUser_id()		);
			System.out.println("[bean.getClient_cnt_o()		]"+bean.getClient_cnt_o()	);
			System.out.println("[bean.getClient_cnt_t()		]"+bean.getClient_cnt_t()	);
			System.out.println("[bean.getClient_ga()		]"+bean.getClient_ga()		);
			System.out.println("[bean.getGen_cnt_o()		]"+bean.getGen_cnt_o()		);
			System.out.println("[bean.getGen_cnt_t()		]"+bean.getGen_cnt_t()		);
			System.out.println("[bean.getGen_ga()			]"+bean.getGen_ga()			);
			System.out.println("[bean.getPut_cnt_o()		]"+bean.getPut_cnt_o()		);
			System.out.println("[bean.getPut_cnt_t()		]"+bean.getPut_cnt_t()		);
			System.out.println("[bean.getPut_ga()			]"+bean.getPut_ga()			);
			System.out.println("[bean.getBas_cnt_o()		]"+bean.getBas_cnt_o()		);
			System.out.println("[bean.getBas_cnt_t()		]"+bean.getBas_cnt_t()		);
			System.out.println("[bean.getBas_ga()			]"+bean.getBas_ga()			);
			System.out.println("[bean.getReg_id()			]"+bean.getReg_id()			);
			System.out.println("[bean.getC_Gen_cnt_b1()		]"+bean.getC_Gen_cnt_b1()	);
			System.out.println("[bean.getC_Gen_cnt_b2()		]"+bean.getC_Gen_cnt_b2()	);
			System.out.println("[bean.getC_Gen_cnt_m1()		]"+bean.getC_Gen_cnt_m1()	);
			System.out.println("[bean.getC_Gen_ga()			]"+bean.getC_Gen_ga()		);
			System.out.println("[bean.getC_BP_cnt_b1()		]"+bean.getC_BP_cnt_b1()	);
			System.out.println("[bean.getC_BP_cnt_b2()		]"+bean.getC_BP_cnt_b2()	);
			System.out.println("[bean.getC_BP_cnt_m1()		]"+bean.getC_BP_cnt_m1()	);
			System.out.println("[bean.getC_BP_ga()			]"+bean.getC_BP_ga()		);
			System.out.println("[bean.getC_Client_cnt_o()	]"+bean.getC_Client_cnt_o()	);
			System.out.println("[bean.getC_Client_cnt_t()	]"+bean.getC_Client_cnt_t()	);
			System.out.println("[bean.getC_Client_ga()		]"+bean.getC_Client_ga()	);
			System.out.println("[bean.getCnt_b1_ga()		]"+bean.getCnt_b1_ga()		);
			System.out.println("[bean.getCnt_b2_ga()		]"+bean.getCnt_b2_ga()		);
			System.out.println("[bean.getCnt_m1_ga()		]"+bean.getCnt_m1_ga()		);

			e.printStackTrace();
	  		flag = false;
			conn.rollback();
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}			
	}

	/**
	 *	���κ� ���θ���Ʈ���� ����� ����Ʈ
	 */
	public Vector getStatMngUser()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.user_id, b.user_nm "+
				" from (select mng_id as user_id from cont where nvl(use_yn,'Y')='Y' and client_id not in ('000231', '000228') group by mng_id) a, users b"+
				" where a.user_id=b.user_id order by b.dept_id desc, b.enter_dt, b.user_id";
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
			System.out.println("[StatMngDatabase:getStatMngUser]"+e);
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
	 *	���κ� ������ü ����Ʈ
	 */
	public Vector getStatMngClientList(String s_user, String s_mng_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String o_query = "";
		String t_query1 = "";
		String t_query2 = "";

		//�ܵ�
		o_query = " select DISTINCT '�ܵ�' mng_st, a.bus_id2, a.mng_id, a.client_id, a.r_site from cont a"+
				" where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')"+
				" and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.bus_id2='"+s_user+"'";
		//����
		t_query1 = " select DISTINCT '����' mng_st, a.bus_id2, a.mng_id, a.client_id, a.r_site from cont a"+
				" where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')"+
				" and a.bus_id2<>nvl(a.mng_id,a.bus_id2) and a.bus_id2='"+s_user+"'";
		//����
		t_query2 = " select DISTINCT '����' mng_st, a.bus_id2, a.mng_id, a.client_id, a.r_site from cont a"+
				" where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')"+
				" and a.bus_id2<>nvl(a.mng_id,a.bus_id2) and a.mng_id='"+s_user+"'";

		if(s_mng_st.equals("1"))		sub_query = o_query;
		else if(s_mng_st.equals("2"))	sub_query = t_query1+" union all "+t_query2;
		else							sub_query = o_query+" union all "+t_query1+" union all "+t_query2;


		query = " select DISTINCT a.mng_st, a.client_id, a.r_site, nvl(b.firm_nm,b.client_nm) firm_nm, b.client_nm, c.r_site as r_site_nm, b.o_tel, b.m_tel, nvl(d.y_cnt,0) y_cnt, nvl(e.n_cnt,0) n_cnt"+
				" from ("+sub_query+") a,"+
				" client b, client_site c,"+
				" (select client_id, nvl(r_site,' ') r_site, count(0) as y_cnt from cont where nvl(use_yn,'Y')='Y' group by client_id, r_site) d,"+
				" (select client_id, nvl(r_site,' ') r_site, count(0) as n_cnt from cont where use_yn='N' group by client_id, r_site) e"+
				" where a.client_id=b.client_id and a.client_id=c.client_id(+) and a.r_site=c.seq(+)"+
				" and a.client_id=d.client_id(+) and nvl(a.r_site,' ')=d.r_site(+) and a.client_id=e.client_id(+) and nvl(a.r_site,' ')=e.r_site(+)"+
				" order by nvl(b.firm_nm,b.client_nm)";

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
			System.out.println("[StatMngDatabase:getStatMngClientList]"+e);
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
	 *	���κ� ������ü ����Ʈ : ����ڵ�
	 */
	public String getStatMngClientUsers(String client_id, String r_site, String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String users = "";
		String query = "";
		String sub_query = "";

		if(r_site.equals("")){
			sub_query = "select "+gubun+" from cont where nvl(use_yn,'Y')='Y' and client_id='"+client_id+"' group by "+gubun;
		}else{
			sub_query = "select "+gubun+" from cont where nvl(use_yn,'Y')='Y' and client_id='"+client_id+"' and r_site='"+r_site+"' group by "+gubun;
		}

		query = " select b.user_nm"+
				" from ("+sub_query+") a, users b"+
				" where a."+gubun+"=b.user_id";

		try {

			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
				if(!users.equals("")) users = users+",";
				users = users + rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatMngDatabase:getStatMngClientUsers]"+e);
			e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return users;
		}
	}	

	//���κ� ������ü ����Ʈ : ��ü�� ���� ����Ʈ
	public Vector getClientCarList(String client_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector rtn = new Vector();
		String query = "";

		query = " select a.*, c.car_no, c.car_nm  from cont_n_view a, car_reg c where a.car_mng_id = c.car_mng_id(+) and  a.client_id='"+ client_id +"'"+
				" order by a.use_yn desc, a.rent_dt, a.rent_mng_id";

		try	{
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();

            while(rs.next())
            {
				RentListBean bean = new RentListBean();

			    bean.setRent_mng_id(rs.getString("RENT_MNG_ID"));		//������ID
			    bean.setRent_l_cd(rs.getString("RENT_L_CD"));			//����ڵ�
			    bean.setRent_dt(rs.getString("RENT_DT"));				//�������
			    bean.setDlv_dt(rs.getString("DLV_DT"));					//�������
			    bean.setClient_id(rs.getString("CLIENT_ID"));					//��ID
			    bean.setClient_nm(rs.getString("CLIENT_NM"));					//�� ��ǥ�ڸ�
			    bean.setFirm_nm(rs.getString("FIRM_NM"));						//��ȣ
			    bean.setBr_id(rs.getString("BR_ID"));						//��ȣ
			    bean.setCar_mng_id(rs.getString("CAR_MNG_ID"));					//�ڵ�������ID
			    bean.setInit_reg_dt(rs.getString("INIT_REG_DT"));					//���ʵ����
			    bean.setReg_gubun(rs.getString("REG_GUBUN"));					//���ʵ����
			    bean.setCar_no(rs.getString("CAR_NO"));						//������ȣ
			    bean.setCar_num(rs.getString("CAR_NUM"));						//�����ȣ
			    bean.setRent_way(rs.getString("RENT_WAY"));					//�뿩���
			    bean.setCon_mon(rs.getString("CON_MON"));						//�뿩����
			    bean.setCar_id(rs.getString("CAR_ID"));						//����ID
			    bean.setRent_start_dt(rs.getString("RENT_START_DT"));				//�뿩������
			    bean.setRent_end_dt(rs.getString("RENT_END_DT"));					//�뿩������
			    bean.setReg_ext_dt(rs.getString("REG_EXT_DT"));					//��Ͽ�����?
			    bean.setRpt_no(rs.getString("RPT_NO"));						//�����ȣ
			    bean.setCpt_cd(rs.getString("CPT_CD"));						//�����ڵ�
			    bean.setBus_id2(rs.getString("BUS_ID2"));					
			    bean.setMng_id(rs.getString("MNG_ID"));					
				bean.setUse_yn(rs.getString("USE_YN"));					
				bean.setRent_st(rs.getString("RENT_ST"));					
				bean.setCls_st(rs.getString("CLS_ST"));					
				bean.setCar_st(rs.getString("CAR_ST"));					
				bean.setScan_file(rs.getString("SCAN_FILE"));					
				bean.setR_site(rs.getString("R_SITE"));					
				bean.setCar_nm(rs.getString("CAR_NM"));					
			    
			    rtn.add(bean);
            }
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[StatMngDatabase:getContList_View]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null )		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return rtn;
		}
    }

	/**
	 *	���κ� �������� ����Ʈ
	 */
	public Vector getStatMngCarList(String s_user, String s_mng_way, String s_mng_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String o_query = "";
		String t_query1 = "";
		String t_query2 = "";
		String where = "";

		if(!s_mng_way.equals(""))	where = " and a.rent_way_cd='"+s_mng_way+"'";
		
		//�ܵ�
		o_query = " select DISTINCT '�ܵ�' mng_st, a.rent_mng_id, a.rent_l_cd, a.bus_id2, a.mng_id, a.car_mng_id from cont_n_view a"+
				" where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.car_mng_id is not null"+
				" and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.bus_id2='"+s_user+"'"+where;
		//����
		t_query1 = " select DISTINCT '����' mng_st, a.rent_mng_id, a.rent_l_cd, a.bus_id2, a.mng_id, a.car_mng_id from cont_n_view a"+
				" where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.car_mng_id is not null"+
				" and a.bus_id2<>nvl(a.mng_id,a.bus_id2) and a.bus_id2='"+s_user+"'"+where;
		//����
		t_query2 = " select DISTINCT '����' mng_st, a.rent_mng_id, a.rent_l_cd, a.bus_id2, a.mng_id, a.car_mng_id from cont_n_view a"+
				" where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.car_mng_id is not null"+
				" and a.bus_id2<>nvl(a.mng_id,a.bus_id2) and a.mng_id='"+s_user+"'"+where;

		if(s_mng_st.equals("1"))		sub_query = o_query;
		else if(s_mng_st.equals("2"))	sub_query = t_query1+" union all "+t_query2;
		else							sub_query = o_query+" union all "+t_query1+" union all "+t_query2;


		query = " select a.mng_st, b.*, c.car_no, c.car_nm "+
				" from ("+sub_query+") a, cont_n_view b, car_reg c \n "+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id = c.car_mng_id(+) \n"+
				" order by  b.firm_nm ";

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
			System.out.println("[StatMngDatabase:getStatMngCarList]"+e);
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

