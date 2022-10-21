package acar.stat_bus;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;
import acar.account.*;
import acar.stat_applet.*;
import acar.common.*;
import acar.admin.*;

public class StatBusDatabase
{
	private Connection conn = null;
	public static StatBusDatabase db;
	
	public static StatBusDatabase getInstance()
	{
		if(StatBusDatabase.db == null)
			StatBusDatabase.db = new StatBusDatabase();
		return StatBusDatabase.db;
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
			System.out.println("[StatBusDatabase:getStatDebt]"+table_nm+e);
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
			System.out.println("[StatBusDatabase:getMaxSaveDt]"+table_nm+e);
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
		    
	  	} catch (Exception e) {
			System.out.println("[StatBusDatabase:getInsertYn]"+table_nm+e);
			e.printStackTrace();
		} finally {
			try{	
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
	 *	���ϱ��� ��ȸ(�ܵ�,���� ����)-���� ����ġ
	 */
	public Vector getStatMng(String br_id, String save_dt, String dept_id, String cg, String gg1, String gg2, String gg3, String gg4, String gg5, String bg1, String bg2, String bg3, String bg4, String bg5, String pg1, String pg2, String pg3, String pg4, String pg5)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";

		if(save_dt.equals("")){
			query = " select f.nm, e.user_nm, e.user_id, e.enter_dt, "+
					" nvl(a1.cnt,0) c_cnt,"+
					" ( nvl(a1.cnt,0)*"+cg+" ) c_ga, "+
					" nvl(b1.cnt,0) g_cnt1, nvl(b2.cnt,0) g_cnt2, nvl(b3.cnt,0) g_cnt3, nvl(b4.cnt,0) g_cnt4, nvl(b5.cnt,0) g_cnt5,"+
					" ( (nvl(b1.cnt,0)*"+gg1+") + (nvl(b2.cnt,0)*"+gg2+") + (nvl(b3.cnt,0)*"+gg3+") + (nvl(b4.cnt,0)*"+gg4+") + (nvl(b5.cnt,0)*"+gg5+") ) g_ga, "+
					" nvl(d1.cnt,0) p_cnt1, nvl(d2.cnt,0) p_cnt2, nvl(d3.cnt,0) p_cnt3, nvl(d4.cnt,0) p_cnt4, nvl(d5.cnt,0) p_cnt5,"+
					" ( (nvl(d1.cnt,0)*"+pg1+") + (nvl(d2.cnt,0)*"+pg2+") + (nvl(d3.cnt,0)*"+pg3+") + (nvl(d4.cnt,0)*"+pg4+") + (nvl(d5.cnt,0)*"+pg5+") ) p_ga, "+
					" nvl(c1.cnt,0) b_cnt1, nvl(c2.cnt,0) b_cnt2, nvl(c3.cnt,0) b_cnt3, nvl(c4.cnt,0) b_cnt4, nvl(c5.cnt,0) b_cnt5,"+
					" ( (nvl(c1.cnt,0)*"+bg1+") + (nvl(c2.cnt,0)*"+bg2+") + (nvl(c3.cnt,0)*"+bg3+") + (nvl(c4.cnt,0)*"+bg4+") + (nvl(c5.cnt,0)*"+bg5+") ) b_ga, e.dept_id "+
					" from  "+
					//�������
					" (select user_id from users) u, "+// where nvl(use_yn,'Y')='Y'
					//��ü��=���ʿ�����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from (select a.bus_id, a.client_id, count(0) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') group by a.bus_id, a.client_id, a.r_site) a group by bus_id) a1, "+
					//�Ϲݽ�=�ű�
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.rent_st='1' group by a.bus_id) b1, "+
					//�Ϲݽ�=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont_n_view a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.rent_way_cd='1' and a.rent_st='3' group by a.bus_id) b2, "+
					//�Ϲݽ�=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.rent_st='4' group by a.bus_id) b3, "+
					//�Ϲݽ�=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.rent_st in ('2','5') group by a.bus_id) b4, "+
					//�Ϲݽ�=������(6����)
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.rent_st='6' group by a.bus_id) b5, "+
					//�⺻��=�ű�
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.rent_st='1' group by a.bus_id) c1, "+
					//�⺻��=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.rent_st='3' group by a.bus_id) c2, "+
					//�⺻��=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.rent_st='4' group by a.bus_id) c3, "+
					//�⺻��=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.rent_st in ('2','5') group by a.bus_id) c4, "+
					//�⺻��=������(6����)
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.rent_st='6' group by a.bus_id) c5, "+
					//�����=�ű�
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.rent_st='1' group by a.bus_id) d1, "+
					//�����=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.rent_st='3' group by a.bus_id) d2, "+
					//�����=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.rent_st='4' group by a.bus_id) d3, "+
					//�����=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.rent_st in ('2','5') group by a.bus_id) d4, "+
					//�����=������(6����)
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.rent_st='6' group by a.bus_id) d5, "+
					" users e, code f"+
					" where u.user_id=a1.user_id(+)"+
					" and u.user_id=b1.user_id(+) and u.user_id=b2.user_id(+) and u.user_id=b3.user_id(+) and u.user_id=b4.user_id(+) and u.user_id=b5.user_id(+) "+
					" and u.user_id=c1.user_id(+) and u.user_id=c2.user_id(+) and u.user_id=c3.user_id(+) and u.user_id=c4.user_id(+) and u.user_id=c5.user_id(+) "+
					" and u.user_id=d1.user_id(+) and u.user_id=d2.user_id(+) and u.user_id=d3.user_id(+) and u.user_id=d4.user_id(+) and u.user_id=d5.user_id(+) "+
					" and u.user_id=e.user_id and e.dept_id=f.code(+) and f.c_st='0002' and f.code<>'0000' "+
					" and ( (nvl(b1.cnt,0)) + (nvl(b2.cnt,0)) + (nvl(b3.cnt,0)) + (nvl(b4.cnt,0)) + (nvl(b5.cnt,0)) + (nvl(c1.cnt,0)) + (nvl(c2.cnt,0)) + (nvl(c3.cnt,0)) + (nvl(c4.cnt,0)) + (nvl(c5.cnt,0)) + (nvl(d1.cnt,0)) + (nvl(d2.cnt,0)) + (nvl(d3.cnt,0)) + (nvl(d4.cnt,0)) + (nvl(d5.cnt,0)) ) > 0";

			if(dept_id.equals("0001") || dept_id.equals("0002")){
				query += " and e.dept_id='"+dept_id+"' and e.loan_st in ('1','2') ";
				query2+="select * from ("+query+") order by (c_ga+g_ga+p_ga+b_ga) desc";
			}else{
  				query += " and (e.dept_id not in ('0001', '0002') or (e.user_pos not in ('���','�븮','����','����','����') and e.loan_st is null))";
				query2+="select * from ("+query+") order by dept_id, user_id";
			}	  

		}else{
			query = " select c.nm, b.user_nm, b.user_id, b.enter_dt,"+
					" a.client_cnt, a.client_ga,"+
					" a.gen_cnt_1, a.gen_cnt_2, a.gen_cnt_3, a.gen_cnt_4, a.gen_cnt_5, a.gen_ga,"+
					" a.put_cnt_1, a.put_cnt_2, a.put_cnt_3, a.put_cnt_4, a.put_cnt_5, a.put_ga,"+
					" a.bas_cnt_1, a.bas_cnt_2, a.bas_cnt_3, a.bas_cnt_4, a.bas_cnt_5, a.bas_ga"+
					" from stat_bus a, users b, code c"+
					" where a.user_id=b.user_id and b.dept_id=c.code and c.c_st='0002' and c.code<>'0000'"+
					" and a.save_dt=replace('"+save_dt+"', '-', '')";

			if(dept_id.equals("0001") || dept_id.equals("0002")){
				query += " and b.dept_id='"+dept_id+"' and b.loan_st in ('1','2')";
				query2 = "select * from ("+query+") order by (client_ga+gen_ga+put_ga+bas_ga) desc";
			}else{
  				query += " and (b.dept_id not in ('0001', '0002') or (b.user_pos not in ('���','�븮','����','����','����') and b.loan_st is null))";
				query2 = "select * from ("+query+") order by user_id desc";
			}

			query2 = "select * from ("+query+") order by (client_ga+gen_ga+put_ga+bas_ga) desc";
					
		}

		try {

			pstmt = conn.prepareStatement(query2);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
				StatBusBean bean = new StatBusBean();
				
				bean.setDept_nm(rs.getString(1));
				bean.setUser_nm(rs.getString(2));
				bean.setUser_id(rs.getString(3));
				bean.setEnter_dt(rs.getString(4));
				bean.setClient_cnt(rs.getInt(5));
				bean.setClient_ga(rs.getFloat(6));
				bean.setGen_cnt_1(rs.getInt(7));
				bean.setGen_cnt_2(rs.getInt(8));
				bean.setGen_cnt_3(rs.getInt(9));
				bean.setGen_cnt_4(rs.getInt(10));
				bean.setGen_cnt_5(rs.getInt(11));
				bean.setGen_ga(rs.getFloat(12));
				bean.setPut_cnt_1(rs.getInt(13));
				bean.setPut_cnt_2(rs.getInt(14));
				bean.setPut_cnt_3(rs.getInt(15));
				bean.setPut_cnt_4(rs.getInt(16));
				bean.setPut_cnt_5(rs.getInt(17));
				bean.setPut_ga(rs.getFloat(18));
				bean.setBas_cnt_1(rs.getInt(19));
				bean.setBas_cnt_2(rs.getInt(20));
				bean.setBas_cnt_3(rs.getInt(21));
				bean.setBas_cnt_4(rs.getInt(22));
				bean.setBas_cnt_5(rs.getInt(23));
				bean.setBas_ga(rs.getFloat(24));

				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatBusDatabase:getStatMng]"+e);
			System.out.println("[StatBusDatabase:getStatMng]"+query2);
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
	 *	���ϱ��� ��ȸ(�ܵ�,���� ����)-���� ����ġ->cont_view���� �뿩������ �������� ���� -- ������������ ���� - 20130711
	 */
	public Vector getStatBus(String br_id, String save_dt, String dept_id, String cg, String gg1, String gg2, String gg3, String gg4, String gg5, String bg1, String bg2, String bg3, String bg4, String bg5, String pg1, String pg2, String pg3, String pg4, String pg5)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";

	
			query = " select   c.nm, b.user_nm, b.user_id, b.enter_dt, \n"+
					" a.client_cnt, a.client_ga, \n"+
					" a.gen_cnt_1, a.gen_cnt_2, a.gen_cnt_3, a.gen_cnt_4, a.gen_cnt_5, a.gen_ga,\n"+
					" a.put_cnt_1, a.put_cnt_2, a.put_cnt_3, a.put_cnt_4, a.put_cnt_5, a.put_ga, \n"+
					" (a.bas_cnt_1+a.put_cnt_1) AS bas_cnt_1, (a.bas_cnt_2+a.put_cnt_2) AS bas_cnt_2, (a.bas_cnt_3+a.put_cnt_3) AS bas_cnt_3, \n"+
					" (a.bas_cnt_4+a.put_cnt_4) AS bas_cnt_4, (a.bas_cnt_5+a.put_cnt_5) AS bas_cnt_5, (a.bas_ga+a.put_ga) AS bas_ga , b.dept_id \n"+
					" from stat_bus a, users b, code c \n"+
					" where a.user_id=b.user_id and b.dept_id=c.code and c.c_st='0002' and c.code<>'0000' \n"+
					" and a.save_dt=replace('"+save_dt+"', '-', '')";

			if(!br_id.equals("")) query += " and b.br_id='"+br_id+"'";

			if(dept_id.equals("0001") || dept_id.equals("0002") || dept_id.equals("0007") || dept_id.equals("0008") || dept_id.equals("0009") || dept_id.equals("0010") || dept_id.equals("0011") || dept_id.equals("0012") || dept_id.equals("0013") || dept_id.equals("0014") || dept_id.equals("0015") || dept_id.equals("0016") || dept_id.equals("0017") || dept_id.equals("0018")){
				query += " and b.dept_id='"+dept_id+"' and b.loan_st in ('1','2') ";
				query2 = "select * from ("+query+") order by (client_ga+gen_ga+put_ga+bas_ga) desc";
			} else if(dept_id.equals("all") ){
				query += " and b.dept_id in ('0001','0002', '0007', '0008','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018') and b.loan_st in ('1','2') ";		
				query2 ="select * from ("+query+") order by  decode( dept_id,  '0002',2, '0001',1, '0004',3, '0007',4, '0008',5, '0009',6, '0010',7, '0011',8,  '0012',9, '0013',10, '0014',11, '0015',12, '0016',13,'0017',14,'0018',15,16),  user_id";	
			}else{
  				query += " and b.user_pos not in ('���','�븮','����','����','����') and b.loan_st is null";
				query2+= "select * from ("+query+") order by user_id desc";
			}

					

		try {

			pstmt = conn.prepareStatement(query2);
	    	rs = pstmt.executeQuery();
	    	
	    	
			while(rs.next())
			{				
				StatBusBean bean = new StatBusBean();
				
				bean.setDept_nm(rs.getString(1));
				bean.setUser_nm(rs.getString(2));
				bean.setUser_id(rs.getString(3));
				bean.setEnter_dt(rs.getString(4));
				bean.setClient_cnt(rs.getInt(5));
				bean.setClient_ga(rs.getFloat(6));
				bean.setGen_cnt_1(rs.getInt(7));
				bean.setGen_cnt_2(rs.getInt(8));
				bean.setGen_cnt_3(rs.getInt(9));
				bean.setGen_cnt_4(rs.getInt(10));
				bean.setGen_cnt_5(rs.getInt(11));
				bean.setGen_ga(rs.getFloat(12));
				bean.setPut_cnt_1(rs.getInt(13));
				bean.setPut_cnt_2(rs.getInt(14));
				bean.setPut_cnt_3(rs.getInt(15));
				bean.setPut_cnt_4(rs.getInt(16));
				bean.setPut_cnt_5(rs.getInt(17));
				bean.setPut_ga(rs.getFloat(18));
				bean.setBas_cnt_1(rs.getInt(19));
				bean.setBas_cnt_2(rs.getInt(20));
				bean.setBas_cnt_3(rs.getInt(21));
				bean.setBas_cnt_4(rs.getInt(22));
				bean.setBas_cnt_5(rs.getInt(23));
				bean.setBas_ga(rs.getFloat(24));

				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatBusDatabase:getStatBus]"+e);
			System.out.println("[StatBusDatabase:getStatBus]"+query2);
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
	 *	���������Ȳ
	 */
	public Vector getStatBusAvg(String br_id, String s_yy, String s_mm, String dept_id, String cg, String gg1, String gg2, String gg3, String gg4, String gg5, String bg1, String bg2, String bg3, String bg4, String bg5, String pg1, String pg2, String pg3, String pg4, String pg5)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select c.nm, b.user_nm, b.user_id, b.enter_dt, \n"+
				" a.client_cnt, a.client_ga,"+
				" a.gen_cnt_1, a.gen_cnt_2, a.gen_cnt_3, a.gen_cnt_4, a.gen_cnt_5, a.gen_ga, \n"+
				" a.put_cnt_1, a.put_cnt_2, a.put_cnt_3, a.put_cnt_4, a.put_cnt_5, a.put_ga,"+
				" a.bas_cnt_1, a.bas_cnt_2, a.bas_cnt_3, a.bas_cnt_4, a.bas_cnt_5, a.bas_ga \n"+
				" from \n"+
				" (select user_id, avg(client_cnt) client_cnt, avg(client_ga) client_ga,"+
				" avg(gen_cnt_1) gen_cnt_1, avg(gen_cnt_2) gen_cnt_2, avg(gen_cnt_3) gen_cnt_3,  avg(gen_cnt_4) gen_cnt_4, avg(gen_cnt_5) gen_cnt_5, avg(gen_ga) gen_ga, \n"+
				" avg(put_cnt_1) put_cnt_1, avg(put_cnt_2) put_cnt_2, avg(put_cnt_3) put_cnt_3,  avg(put_cnt_4) put_cnt_4, avg(put_cnt_5) put_cnt_5, avg(put_ga) put_ga, \n"+
				" avg(bas_cnt_1) bas_cnt_1, avg(bas_cnt_2) bas_cnt_2, avg(bas_cnt_3) bas_cnt_3,  avg(bas_cnt_4) bas_cnt_4, avg(bas_cnt_5) bas_cnt_5, avg(bas_ga) bas_ga"+
				" from stat_bus where save_dt between replace('"+s_yy+"','-','') and replace('"+s_mm+"','-','') group by user_id) a, \n"+ //like '%"+s_yy+AddUtil.addZero(s_mm)+"%'
				" users b, code c"+
				" where a.user_id=b.user_id and b.dept_id=c.code and c.c_st='0002' and c.code<>'0000' and b.loan_st in ('1','2') ";

		if(!br_id.equals("")) query += " and b.br_id='"+br_id+"'";

		if(dept_id.equals("0004")){
  				query += " and b.user_pos not in ('���','�븮','����','����','����') ";
		} else if(dept_id.equals("all") ){
				query += "  and b.dept_id in ('0001','0002','0007','0008','0009','0010','0011','0012','0013','0014','0015','0016') \n";		
		} else {
				query += " and b.dept_id='"+dept_id+"' ";
		}
		

		query +=" order by  b.dept_id,  (a.client_ga+a.gen_ga+a.put_ga+a.bas_ga) desc";

		try {

			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
	    	
			while(rs.next())
			{				
				StatBusBean bean = new StatBusBean();
				
				bean.setDept_nm(rs.getString(1));
				bean.setUser_nm(rs.getString(2));
				bean.setUser_id(rs.getString(3));
				bean.setEnter_dt(rs.getString(4));
				bean.setClient_cnt(rs.getInt(5));
				bean.setClient_ga(rs.getFloat(6));
				bean.setGen_cnt_1(rs.getInt(7));
				bean.setGen_cnt_2(rs.getInt(8));
				bean.setGen_cnt_3(rs.getInt(9));
				bean.setGen_cnt_4(rs.getInt(10));
				bean.setGen_cnt_5(rs.getInt(11));
				bean.setGen_ga(rs.getFloat(12));
				bean.setPut_cnt_1(rs.getInt(13));
				bean.setPut_cnt_2(rs.getInt(14));
				bean.setPut_cnt_3(rs.getInt(15));
				bean.setPut_cnt_4(rs.getInt(16));
				bean.setPut_cnt_5(rs.getInt(17));
				bean.setPut_ga(rs.getFloat(18));
				bean.setBas_cnt_1(rs.getInt(19));
				bean.setBas_cnt_2(rs.getInt(20));
				bean.setBas_cnt_3(rs.getInt(21));
				bean.setBas_cnt_4(rs.getInt(22));
				bean.setBas_cnt_5(rs.getInt(23));
				bean.setBas_ga(rs.getFloat(24));

				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatBusDatabase:getStatBusAvg]"+e);
			System.out.println("[StatBusDatabase:getStatBusAvg]"+query);
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
	public Vector getStatBusSearch(String br_id, String s_yy, String s_mm, String dept_id, String cg, String gg1, String gg2, String gg3, String gg4, String gg5, String bg1, String bg2, String bg3, String bg4, String bg5, String pg1, String pg2, String pg3, String pg4, String pg5)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";
		String s_dt = "";
		String s_dt2 = "";
		String s_dt3 = "";

		//��ళ���� ����
		if(!s_yy.equals("") && s_mm.equals(""))		s_dt  = " and a.rent_dt like '"+AddUtil.replace(s_yy, "-", "")+"%'";
		if(!s_yy.equals("") && !s_mm.equals(""))	s_dt  = " and a.rent_dt between replace('"+s_yy+"','-','') and replace('"+s_mm+"','-','')";
		if(!s_yy.equals("") && s_mm.equals(""))		s_dt2 = " and b.rent_start_dt like '"+AddUtil.replace(s_yy, "-", "")+"%'";
		if(!s_yy.equals("") && !s_mm.equals(""))	s_dt2 = " and b.rent_start_dt between replace('"+s_yy+"','-','') and replace('"+s_mm+"','-','')";


		query = " select f.nm, e.user_nm, e.user_id, e.enter_dt, "+
				" nvl(a1.cnt,0) c_cnt,"+
				" ( nvl(a1.cnt,0)*"+cg+" ) c_ga, "+
				" nvl(b1.cnt,0) g_cnt1, nvl(b2.cnt,0) g_cnt2, nvl(b3.cnt,0) g_cnt3, nvl(b4.cnt,0) g_cnt4, nvl(b5.cnt,0) g_cnt5,"+
				" ( (nvl(b1.cnt,0)) + (nvl(b2.cnt,0)) + (nvl(b3.cnt,0)) + (nvl(b4.cnt,0)) + (nvl(b5.cnt,0)) ) g_ga, "+
				" nvl(d1.cnt,0) p_cnt1, nvl(d2.cnt,0) p_cnt2, nvl(d3.cnt,0) p_cnt3, nvl(d4.cnt,0) p_cnt4, nvl(d5.cnt,0) p_cnt5,"+
				" ( (nvl(d1.cnt,0)) + (nvl(d2.cnt,0)) + (nvl(d3.cnt,0)) + (nvl(d4.cnt,0)) + (nvl(d5.cnt,0)) ) p_ga, "+
				" nvl(c1.cnt,0) b_cnt1, nvl(c2.cnt,0) b_cnt2, nvl(c3.cnt,0) b_cnt3, nvl(c4.cnt,0) b_cnt4, nvl(c5.cnt,0) b_cnt5,"+
				" ( (nvl(c1.cnt,0)) + (nvl(c2.cnt,0)) + (nvl(c3.cnt,0)) + (nvl(c4.cnt,0)) + (nvl(c5.cnt,0)) ) b_ga "+
				" from  "+
				//�������
				" (select user_id from users) u, "+
				//��ü��=���ʿ�����
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from (select a.bus_id, a.client_id, count(0) cnt from cont_n_view a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt+" group by a.bus_id, a.client_id, a.r_site) a group by bus_id) a1, "+
				//�Ϲݽ�=�ű�
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='1' and a.rent_st='1' group by a.bus_id) b1, "+
				//�Ϲݽ�=����
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='1' and a.rent_st='3' group by a.bus_id) b2, "+
				//�Ϲݽ�=����
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='1' and a.rent_st='4' group by a.bus_id) b3, "+
				//�Ϲݽ�=����
				" (select nvl(b.ext_agnt,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='1' and a.rent_st in ('2','5') group by b.ext_agnt) b4, "+
				//�Ϲݽ�=������(6����)
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='1' and a.rent_st='6' group by a.bus_id) b5, "+
				//�⺻��=�ű�
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='3' and a.rent_st='1' group by a.bus_id) c1, "+
				//�⺻��=����
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='3' and a.rent_st='3' group by a.bus_id) c2, "+
				//�⺻��=����
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='3' and a.rent_st='4' group by a.bus_id) c3, "+
				//�⺻��=����
				" (select nvl(b.ext_agnt,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='3' and a.rent_st in ('2','5') group by b.ext_agnt) c4, "+
				//�⺻��=������(6����)
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='3' and a.rent_st='6' group by a.bus_id) c5, "+
				//�����=�ű�
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='2' and a.rent_st='1' group by a.bus_id) d1, "+
				//�����=����
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='2' and a.rent_st='3' group by a.bus_id) d2, "+
				//�����=����
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='2' and a.rent_st='4' group by a.bus_id) d3, "+
				//�����=����
				" (select nvl(b.ext_agnt,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='2' and a.rent_st in ('2','5') group by b.ext_agnt) d4, "+
				//�����=������(6����)
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='2' and a.rent_st='6' group by a.bus_id) d5, "+
				" users e, code f"+
				" where u.user_id=a1.user_id(+)"+
				" and u.user_id=b1.user_id(+) and u.user_id=b2.user_id(+) and u.user_id=b3.user_id(+) and u.user_id=b4.user_id(+) and u.user_id=b5.user_id(+) "+
				" and u.user_id=c1.user_id(+) and u.user_id=c2.user_id(+) and u.user_id=c3.user_id(+) and u.user_id=c4.user_id(+) and u.user_id=c5.user_id(+) "+
				" and u.user_id=d1.user_id(+) and u.user_id=d2.user_id(+) and u.user_id=d3.user_id(+) and u.user_id=d4.user_id(+) and u.user_id=d5.user_id(+) "+
				" and u.user_id=e.user_id and e.dept_id=f.code(+) and f.c_st='0002' and f.code<>'0000' "+
				" and ( (nvl(b1.cnt,0)) + (nvl(b2.cnt,0)) + (nvl(b3.cnt,0)) + (nvl(b4.cnt,0)) + (nvl(b5.cnt,0)) + (nvl(c1.cnt,0)) + (nvl(c2.cnt,0)) + (nvl(c3.cnt,0)) + (nvl(c4.cnt,0)) + (nvl(c5.cnt,0)) + (nvl(d1.cnt,0)) + (nvl(d2.cnt,0)) + (nvl(d3.cnt,0)) + (nvl(d4.cnt,0)) + (nvl(d5.cnt,0)) ) > 0";

		if(dept_id.equals("0001") || dept_id.equals("0002")){
			query += " and e.dept_id='"+dept_id+"' and e.loan_st in ('1','2') ";
			query2+="select * from ("+query+") order by (c_ga+g_ga+p_ga+b_ga) desc";
		}else{
  			query += " and (e.dept_id not in ('0001', '0002') or (e.user_pos not in ('���','�븮','����','����','����') and e.loan_st is null))";
			query2+="select * from ("+query+") order by user_id desc";
	    }

		try {

			pstmt = conn.prepareStatement(query2);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
				StatBusBean bean = new StatBusBean();
				
				bean.setDept_nm(rs.getString(1));
				bean.setUser_nm(rs.getString(2));
				bean.setUser_id(rs.getString(3));
				bean.setEnter_dt(rs.getString(4));
				bean.setClient_cnt(rs.getInt(5));
				bean.setClient_ga(rs.getFloat(6));
				bean.setGen_cnt_1(rs.getInt(7));
				bean.setGen_cnt_2(rs.getInt(8));
				bean.setGen_cnt_3(rs.getInt(9));
				bean.setGen_cnt_4(rs.getInt(10));
				bean.setGen_cnt_5(rs.getInt(11));
				bean.setGen_ga(rs.getFloat(12));
				bean.setPut_cnt_1(rs.getInt(13));
				bean.setPut_cnt_2(rs.getInt(14));
				bean.setPut_cnt_3(rs.getInt(15));
				bean.setPut_cnt_4(rs.getInt(16));
				bean.setPut_cnt_5(rs.getInt(17));
				bean.setPut_ga(rs.getFloat(18));
				bean.setBas_cnt_1(rs.getInt(19));
				bean.setBas_cnt_2(rs.getInt(20));
				bean.setBas_cnt_3(rs.getInt(21));
				bean.setBas_cnt_4(rs.getInt(22));
				bean.setBas_cnt_5(rs.getInt(23));
				bean.setBas_ga(rs.getFloat(24));

				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatBusDatabase:getStatBusSearch]"+e);
			System.out.println("[StatBusDatabase:getStatBusSearch]"+query2);
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
	 *	���ϱ��� ��ȸ(�ܵ�,���� ����)-���� ����ġ-cont_view�� �뿩������ �������� ����
	 */
	public Vector getStatBusSearch4(String br_id, String s_yy, String s_mm, String dept_id, String cg, String gg1, String gg2, String gg3, String gg4, String gg5, String bg1, String bg2, String bg3, String bg4, String bg5, String pg1, String pg2, String pg3, String pg4, String pg5)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";
		String s_dt = "";
		String s_dt2 = "";
		String s_dt3 = "";

		if(!s_yy.equals("") && s_mm.equals(""))		s_dt  = " and rent_dt like '"+AddUtil.ChangeDate2(s_yy).substring(0,6)+"%'";
		if(!s_yy.equals("") && !s_mm.equals(""))	s_dt  = " and rent_dt between '"+AddUtil.ChangeDate2(s_yy)+"' and '"+AddUtil.ChangeDate2(s_mm)+"'";
		if(!s_yy.equals("") && s_mm.equals(""))		s_dt2 = " and rent_dt like '"+AddUtil.ChangeDate2(s_yy).substring(0,6)+"%'";
		if(!s_yy.equals("") && !s_mm.equals(""))	s_dt2 = " and rent_dt between '"+AddUtil.ChangeDate2(s_yy)+"' and '"+AddUtil.ChangeDate2(s_mm)+"'";
		if(!s_yy.equals("") && s_mm.equals(""))		s_dt3 = " and rent_dt2 like '"+AddUtil.ChangeDate2(s_yy).substring(0,6)+"%'";
		if(!s_yy.equals("") && !s_mm.equals(""))	s_dt3 = " and rent_dt2 between '"+AddUtil.ChangeDate2(s_yy)+"' and '"+AddUtil.ChangeDate2(s_mm)+"'";

		query = " select f.nm, e.user_nm, e.user_id, e.enter_dt, "+
				" nvl(a1.cnt,0) c_cnt,"+
				" ( nvl(a1.cnt,0)*"+cg+" ) c_ga, "+
				" nvl(b1.cnt,0) g_cnt1, nvl(b2.cnt,0) g_cnt2, nvl(b3.cnt,0) g_cnt3, nvl(b4.cnt,0) g_cnt4, nvl(b5.cnt,0) g_cnt5,"+
				" ( (nvl(b1.cnt,0)) + (nvl(b2.cnt,0)) + (nvl(b3.cnt,0)) + (nvl(b4.cnt,0)) + (nvl(b5.cnt,0)) ) g_ga, "+
				" nvl(d1.cnt,0) p_cnt1, nvl(d2.cnt,0) p_cnt2, nvl(d3.cnt,0) p_cnt3, nvl(d4.cnt,0) p_cnt4, nvl(d5.cnt,0) p_cnt5,"+
				" ( (nvl(d1.cnt,0)) + (nvl(d2.cnt,0)) + (nvl(d3.cnt,0)) + (nvl(d4.cnt,0)) + (nvl(d5.cnt,0)) ) p_ga, "+
				" nvl(c1.cnt,0) b_cnt1, nvl(c2.cnt,0) b_cnt2, nvl(c3.cnt,0) b_cnt3, nvl(c4.cnt,0) b_cnt4, nvl(c5.cnt,0) b_cnt5,"+
				" ( (nvl(c1.cnt,0)) + (nvl(c2.cnt,0)) + (nvl(c3.cnt,0)) + (nvl(c4.cnt,0)) + (nvl(c5.cnt,0)) ) b_ga "+
				" from  "+
				//�������
				" (select user_id from users) u, "+
				//��ü��=���ʿ�����
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from (select bus_id, client_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt+" group by bus_id, client_id, r_site) a group by bus_id) a1, "+
				//�Ϲݽ�=�ű�
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='1' and rent_st='1' group by bus_id) b1, "+
				//�Ϲݽ�=����
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='1' and rent_st='3' group by bus_id) b2, "+
				//�Ϲݽ�=����
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='1' and rent_st='4' group by bus_id) b3, "+
				//�Ϲݽ�=����(6�����̻�)
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt3+" and rent_way_cd='1' and rent_st='2' group by bus_id) b4, "+//in ('2','5')
				//�Ϲݽ�=������(6�����̻�)
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='1' and rent_st='6' group by bus_id) b5, "+
				//�⺻��=�ű�
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='3' and rent_st='1' group by bus_id) c1, "+
				//�⺻��=����
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='3' and rent_st='3' group by bus_id) c2, "+
				//�⺻��=����
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='3' and rent_st='4' group by bus_id) c3, "+
				//�⺻��=����(6�����̻�)
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt3+" and rent_way_cd='3' and rent_st='2' group by bus_id) c4, "+//in ('2','5')
				//�⺻��=������(6�����̻�)
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='3' and rent_st='6' group by bus_id) c5, "+
				//�����=�ű�
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='2' and rent_st='1' group by bus_id) d1, "+
				//�����=����
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='2' and rent_st='3' group by bus_id) d2, "+
				//�����=����
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='2' and rent_st='4' group by bus_id) d3, "+
				//�����=����(6�����̻�)
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt3+" and rent_way_cd='2' and rent_st='2' group by bus_id) d4, "+//in ('2','5')
				//�����=������(6�����̻�)
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='2' and rent_st='6' group by bus_id) d5, "+
				" users e, code f"+
				" where u.user_id=a1.user_id(+)"+
				" and u.user_id=b1.user_id(+) and u.user_id=b2.user_id(+) and u.user_id=b3.user_id(+) and u.user_id=b4.user_id(+) and u.user_id=b5.user_id(+) "+
				" and u.user_id=c1.user_id(+) and u.user_id=c2.user_id(+) and u.user_id=c3.user_id(+) and u.user_id=c4.user_id(+) and u.user_id=c5.user_id(+) "+
				" and u.user_id=d1.user_id(+) and u.user_id=d2.user_id(+) and u.user_id=d3.user_id(+) and u.user_id=d4.user_id(+) and u.user_id=d5.user_id(+) "+
				" and u.user_id=e.user_id and e.dept_id=f.code(+) and f.c_st='0002' and f.code<>'0000' "+
				" and ( (nvl(b1.cnt,0)) + (nvl(b2.cnt,0)) + (nvl(b3.cnt,0)) + (nvl(b4.cnt,0)) + (nvl(b5.cnt,0)) + (nvl(c1.cnt,0)) + (nvl(c2.cnt,0)) + (nvl(c3.cnt,0)) + (nvl(c4.cnt,0)) + (nvl(c5.cnt,0)) + (nvl(d1.cnt,0)) + (nvl(d2.cnt,0)) + (nvl(d3.cnt,0)) + (nvl(d4.cnt,0)) + (nvl(d5.cnt,0)) ) > 0";

		if(!br_id.equals("")) query += " and e.br_id='"+br_id+"'";

		if(dept_id.equals("0001") || dept_id.equals("0002")){
			query += " and e.dept_id='"+dept_id+"' and e.loan_st in ('1','2') ";
			query2+="select * from ("+query+") order by (c_ga+g_ga+p_ga+b_ga) desc";
		}else{
  			query += " and e.user_pos not in ('���','�븮','����','����','����') and e.loan_st is null";
			query2+="select * from ("+query+") order by user_id desc";
	    }

		try {

			pstmt = conn.prepareStatement(query2);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
				StatBusBean bean = new StatBusBean();
				
				bean.setDept_nm(rs.getString(1));
				bean.setUser_nm(rs.getString(2));
				bean.setUser_id(rs.getString(3));
				bean.setEnter_dt(rs.getString(4));
				bean.setClient_cnt(rs.getInt(5));
				bean.setClient_ga(rs.getFloat(6));
				bean.setGen_cnt_1(rs.getInt(7));
				bean.setGen_cnt_2(rs.getInt(8));
				bean.setGen_cnt_3(rs.getInt(9));
				bean.setGen_cnt_4(rs.getInt(10));
				bean.setGen_cnt_5(rs.getInt(11));
				bean.setGen_ga(rs.getFloat(12));
				bean.setPut_cnt_1(rs.getInt(13));
				bean.setPut_cnt_2(rs.getInt(14));
				bean.setPut_cnt_3(rs.getInt(15));
				bean.setPut_cnt_4(rs.getInt(16));
				bean.setPut_cnt_5(rs.getInt(17));
				bean.setPut_ga(rs.getFloat(18));
				bean.setBas_cnt_1(rs.getInt(19));
				bean.setBas_cnt_2(rs.getInt(20));
				bean.setBas_cnt_3(rs.getInt(21));
				bean.setBas_cnt_4(rs.getInt(22));
				bean.setBas_cnt_5(rs.getInt(23));
				bean.setBas_ga(rs.getFloat(24));

				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatBusDatabase:getStatBusSearch4]"+e);
			System.out.println("[StatBusDatabase:getStatBusSearch4]"+query2);
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
	 *	���ϱ��� ��ȸ(�ܵ�,���� ����)-���� ����ġ-cont_view�� �뿩������ �������� ����
	 */
	public Vector getStatBusSearch3(String br_id, String s_yy, String s_mm, String dept_id, String cg, String gg1, String gg2, String gg3, String gg4, String gg5, String bg1, String bg2, String bg3, String bg4, String bg5, String pg1, String pg2, String pg3, String pg4, String pg5)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";
		String s_dt = "";
		String s_dt2 = "";
		String s_dt3 = "";

		if(!s_yy.equals("") && s_mm.equals(""))		s_dt  = " and rent_dt like '"+AddUtil.ChangeDate2(s_yy).substring(0,6)+"%'";
		if(!s_yy.equals("") && !s_mm.equals(""))	s_dt  = " and rent_dt between '"+AddUtil.ChangeDate2(s_yy)+"' and '"+AddUtil.ChangeDate2(s_mm)+"'";
		if(!s_yy.equals("") && s_mm.equals(""))		s_dt2 = " and rent_start_dt like '"+AddUtil.ChangeDate2(s_yy).substring(0,6)+"%'";
		if(!s_yy.equals("") && !s_mm.equals(""))	s_dt2 = " and rent_start_dt between '"+AddUtil.ChangeDate2(s_yy)+"' and '"+AddUtil.ChangeDate2(s_mm)+"'";

		query = " select f.nm, e.user_nm, e.user_id, e.enter_dt, "+
				" nvl(a1.cnt,0) c_cnt,"+
				" ( nvl(a1.cnt,0)*"+cg+" ) c_ga, "+
				" nvl(b1.cnt,0) g_cnt1, nvl(b2.cnt,0) g_cnt2, nvl(b3.cnt,0) g_cnt3, nvl(b4.cnt,0) g_cnt4, nvl(b5.cnt,0) g_cnt5,"+
				" ( (nvl(b1.cnt,0)) + (nvl(b2.cnt,0)) + (nvl(b3.cnt,0)) + (nvl(b4.cnt,0)) + (nvl(b5.cnt,0)) ) g_ga, "+
				" nvl(d1.cnt,0) p_cnt1, nvl(d2.cnt,0) p_cnt2, nvl(d3.cnt,0) p_cnt3, nvl(d4.cnt,0) p_cnt4, nvl(d5.cnt,0) p_cnt5,"+
				" ( (nvl(d1.cnt,0)) + (nvl(d2.cnt,0)) + (nvl(d3.cnt,0)) + (nvl(d4.cnt,0)) + (nvl(d5.cnt,0)) ) p_ga, "+
				" nvl(c1.cnt,0) b_cnt1, nvl(c2.cnt,0) b_cnt2, nvl(c3.cnt,0) b_cnt3, nvl(c4.cnt,0) b_cnt4, nvl(c5.cnt,0) b_cnt5,"+
				" ( (nvl(c1.cnt,0)) + (nvl(c2.cnt,0)) + (nvl(c3.cnt,0)) + (nvl(c4.cnt,0)) + (nvl(c5.cnt,0)) ) b_ga "+
				" from  "+
				//�������
				" (select user_id from users) u, "+
				//��ü��=���ʿ�����
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from (select bus_id, client_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt+" group by bus_id, client_id, r_site) a group by bus_id) a1, "+
				//�Ϲݽ�=�ű�
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='1' and rent_st='1' group by bus_id) b1, "+
				//�Ϲݽ�=����
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='1' and rent_st='3' group by bus_id) b2, "+
				//�Ϲݽ�=����
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='1' and rent_st='4' group by bus_id) b3, "+
				//�Ϲݽ�=����(6�����̻�)
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='1' and rent_st='2' group by bus_id) b4, "+// in ('2','5')
				//�Ϲݽ�=������(6�����̻�)
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='1' and rent_st='6' group by bus_id) b5, "+
				//�⺻��=�ű�
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='3' and rent_st='1' group by bus_id) c1, "+
				//�⺻��=����
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='3' and rent_st='3' group by bus_id) c2, "+
				//�⺻��=����
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='3' and rent_st='4' group by bus_id) c3, "+
				//�⺻��=����(6�����̻�)
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='3' and rent_st='2' group by bus_id) c4, "+// in ('2','5')
				//�⺻��=������(6�����̻�)
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='3' and rent_st='6' group by bus_id) c5, "+
				//�����=�ű�
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='2' and rent_st='1' group by bus_id) d1, "+
				//�����=����
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='2' and rent_st='3' group by bus_id) d2, "+
				//�����=����
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='2' and rent_st='4' group by bus_id) d3, "+
				//�����=����(6�����̻�)
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='2' and rent_st='2' group by bus_id) d4, "+// in ('2','5')
				//�����=������(6�����̻�)
				" (select nvl(bus_id,'999999') as user_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+s_dt2+" and rent_way_cd='2' and rent_st='6' group by bus_id) d5, "+
				" users e, code f"+
				" where u.user_id=a1.user_id(+)"+
				" and u.user_id=b1.user_id(+) and u.user_id=b2.user_id(+) and u.user_id=b3.user_id(+) and u.user_id=b4.user_id(+) and u.user_id=b5.user_id(+) "+
				" and u.user_id=c1.user_id(+) and u.user_id=c2.user_id(+) and u.user_id=c3.user_id(+) and u.user_id=c4.user_id(+) and u.user_id=c5.user_id(+) "+
				" and u.user_id=d1.user_id(+) and u.user_id=d2.user_id(+) and u.user_id=d3.user_id(+) and u.user_id=d4.user_id(+) and u.user_id=d5.user_id(+) "+
				" and u.user_id=e.user_id and e.dept_id=f.code(+) and f.c_st='0002' and f.code<>'0000' "+
				" and ( (nvl(b1.cnt,0)) + (nvl(b2.cnt,0)) + (nvl(b3.cnt,0)) + (nvl(b4.cnt,0)) + (nvl(b5.cnt,0)) + (nvl(c1.cnt,0)) + (nvl(c2.cnt,0)) + (nvl(c3.cnt,0)) + (nvl(c4.cnt,0)) + (nvl(c5.cnt,0)) + (nvl(d1.cnt,0)) + (nvl(d2.cnt,0)) + (nvl(d3.cnt,0)) + (nvl(d4.cnt,0)) + (nvl(d5.cnt,0)) ) > 0";

		if(!br_id.equals("")) query += " and e.br_id='"+br_id+"'";

		if(dept_id.equals("0001") || dept_id.equals("0002")){
			query += " and e.dept_id='"+dept_id+"' and e.loan_st in ('1','2') ";
			query2+="select * from ("+query+") order by (c_ga+g_ga+p_ga+b_ga) desc";
		}else{
  			query += " and (e.dept_id not in ('0001', '0002') or (e.user_pos not in ('���','�븮','����','����','����') and e.loan_st is null))";
			query2+="select * from ("+query+") order by user_id desc";
	    }

		try {

			pstmt = conn.prepareStatement(query2);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
				StatBusBean bean = new StatBusBean();
				
				bean.setDept_nm(rs.getString(1));
				bean.setUser_nm(rs.getString(2));
				bean.setUser_id(rs.getString(3));
				bean.setEnter_dt(rs.getString(4));
				bean.setClient_cnt(rs.getInt(5));
				bean.setClient_ga(rs.getFloat(6));
				bean.setGen_cnt_1(rs.getInt(7));
				bean.setGen_cnt_2(rs.getInt(8));
				bean.setGen_cnt_3(rs.getInt(9));
				bean.setGen_cnt_4(rs.getInt(10));
				bean.setGen_cnt_5(rs.getInt(11));
				bean.setGen_ga(rs.getFloat(12));
				bean.setPut_cnt_1(rs.getInt(13));
				bean.setPut_cnt_2(rs.getInt(14));
				bean.setPut_cnt_3(rs.getInt(15));
				bean.setPut_cnt_4(rs.getInt(16));
				bean.setPut_cnt_5(rs.getInt(17));
				bean.setPut_ga(rs.getFloat(18));
				bean.setBas_cnt_1(rs.getInt(19));
				bean.setBas_cnt_2(rs.getInt(20));
				bean.setBas_cnt_3(rs.getInt(21));
				bean.setBas_cnt_4(rs.getInt(22));
				bean.setBas_cnt_5(rs.getInt(23));
				bean.setBas_ga(rs.getFloat(24));

				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatBusDatabase:getStatBusSearch3]"+e);
			System.out.println("[StatBusDatabase:getStatBusSearch3]"+query2);
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
	public Vector getStatBusSearch2(String br_id, String s_yy, String s_mm, String dept_id, String cg, String gg1, String gg2, String gg3, String gg4, String gg5, String bg1, String bg2, String bg3, String bg4, String bg5, String pg1, String pg2, String pg3, String pg4, String pg5)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";
		String s_dt = "";
		String s_dt2 = "";

		//��ళ���� ����
		if(!s_yy.equals("") && s_mm.equals(""))		s_dt  = " and a.rent_dt like '"+AddUtil.replace(s_yy, "-", "")+"%'";
		if(!s_yy.equals("") && !s_mm.equals(""))	s_dt  = " and a.rent_dt between replace('"+s_yy+"','-','') and replace('"+s_mm+"','-','')";
		if(!s_yy.equals("") && s_mm.equals(""))		s_dt2 = " and b.rent_start_dt like '"+AddUtil.replace(s_yy, "-", "")+"%'";
		if(!s_yy.equals("") && !s_mm.equals(""))	s_dt2 = " and b.rent_start_dt between replace('"+s_yy+"','-','') and replace('"+s_mm+"','-','')";

		query = " select f.nm, e.user_nm, e.user_id, e.enter_dt, "+
				" nvl(a1.cnt,0) c_cnt,"+
				" ( nvl(a1.cnt,0)*"+cg+" ) c_ga, "+
				" nvl(b1.cnt,0) g_cnt1, nvl(b2.cnt,0) g_cnt2, nvl(b3.cnt,0) g_cnt3, nvl(b4.cnt,0) g_cnt4, nvl(b5.cnt,0) g_cnt5,"+
				" ( (nvl(b1.cnt,0)) + (nvl(b2.cnt,0)) + (nvl(b3.cnt,0)) + (nvl(b4.cnt,0)) + (nvl(b5.cnt,0)) ) g_ga, "+
				" nvl(d1.cnt,0) p_cnt1, nvl(d2.cnt,0) p_cnt2, nvl(d3.cnt,0) p_cnt3, nvl(d4.cnt,0) p_cnt4, nvl(d5.cnt,0) p_cnt5,"+
				" ( (nvl(d1.cnt,0)) + (nvl(d2.cnt,0)) + (nvl(d3.cnt,0)) + (nvl(d4.cnt,0)) + (nvl(d5.cnt,0)) ) p_ga, "+
				" nvl(c1.cnt,0) b_cnt1, nvl(c2.cnt,0) b_cnt2, nvl(c3.cnt,0) b_cnt3, nvl(c4.cnt,0) b_cnt4, nvl(c5.cnt,0) b_cnt5,"+
				" ( (nvl(c1.cnt,0)) + (nvl(c2.cnt,0)) + (nvl(c3.cnt,0)) + (nvl(c4.cnt,0)) + (nvl(c5.cnt,0)) ) b_ga "+
				" from  "+
				//�������
				" (select user_id from users) u, "+
				//��ü��=���ʿ�����
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from (select a.bus_id, a.client_id, count(0) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt+" group by a.bus_id, a.client_id, a.r_site) a group by bus_id) a1, "+
				//�Ϲݽ�=�ű�
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='1' and a.rent_st='1' group by a.bus_id) b1, "+
				//�Ϲݽ�=����
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='1' and a.rent_st='3' group by a.bus_id) b2, "+
				//�Ϲݽ�=����
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='1' and a.rent_st='4' group by a.bus_id) b3, "+
				//�Ϲݽ�=����
				" (select nvl(b.ext_agnt,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='1' and a.rent_st in ('2','5') group by b.ext_agnt) b4, "+
				//�Ϲݽ�=������(6����)
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='1' and a.rent_st='6' group by a.bus_id) b5, "+
				//�⺻��=�ű�
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='3' and a.rent_st='1' group by a.bus_id) c1, "+
				//�⺻��=����
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='3' and a.rent_st='3' group by a.bus_id) c2, "+
				//�⺻��=����
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='3' and a.rent_st='4' group by a.bus_id) c3, "+
				//�⺻��=����
				" (select nvl(b.ext_agnt,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='3' and a.rent_st in ('2','5') group by b.ext_agnt) c4, "+
				//�⺻��=������(6����)
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='3' and a.rent_st='6' group by a.bus_id) c5, "+
				//�����=�ű�
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='2' and a.rent_st='1' group by a.bus_id) d1, "+
				//�����=����
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='2' and a.rent_st='3' group by a.bus_id) d2, "+
				//�����=����
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='2' and a.rent_st='4' group by a.bus_id) d3, "+
				//�����=����
				" (select nvl(b.ext_agnt,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='2' and a.rent_st in ('2','5') group by b.ext_agnt) d4, "+
				//�����=������(6����)
				" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt from cont a, fee b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') "+s_dt2+" and b.rent_way='2' and a.rent_st='6' group by a.bus_id) d5, "+
				" users e, code f"+
				" where u.user_id=a1.user_id(+)"+
				" and u.user_id=b1.user_id(+) and u.user_id=b2.user_id(+) and u.user_id=b3.user_id(+) and u.user_id=b4.user_id(+) and u.user_id=b5.user_id(+) "+
				" and u.user_id=c1.user_id(+) and u.user_id=c2.user_id(+) and u.user_id=c3.user_id(+) and u.user_id=c4.user_id(+) and u.user_id=c5.user_id(+) "+
				" and u.user_id=d1.user_id(+) and u.user_id=d2.user_id(+) and u.user_id=d3.user_id(+) and u.user_id=d4.user_id(+) and u.user_id=d5.user_id(+) "+
				" and u.user_id=e.user_id and e.dept_id=f.code(+) and f.c_st='0002' and f.code<>'0000' "+
				" and ( (nvl(b1.cnt,0)) + (nvl(b2.cnt,0)) + (nvl(b3.cnt,0)) + (nvl(b4.cnt,0)) + (nvl(b5.cnt,0)) + (nvl(c1.cnt,0)) + (nvl(c2.cnt,0)) + (nvl(c3.cnt,0)) + (nvl(c4.cnt,0)) + (nvl(c5.cnt,0)) + (nvl(d1.cnt,0)) + (nvl(d2.cnt,0)) + (nvl(d3.cnt,0)) + (nvl(d4.cnt,0)) + (nvl(d5.cnt,0)) ) > 0";

		if(dept_id.equals("0001") || dept_id.equals("0002")){
			query += " and e.dept_id='"+dept_id+"' and e.loan_st in ('1','2') ";
			query2+="select * from ("+query+") order by (c_ga+g_ga+p_ga+b_ga) desc";
		}else{
  			query += " and (e.dept_id not in ('0001', '0002') or (e.user_pos not in ('���','�븮','����','����','����') and e.loan_st is null))";
			query2+="select * from ("+query+") order by user_id desc";
	    }

		try {

			pstmt = conn.prepareStatement(query2);
	    	rs = pstmt.executeQuery();
			while(rs.next())
			{				
				StatBusBean bean = new StatBusBean();
				
				bean.setDept_nm(rs.getString(1));
				bean.setUser_nm(rs.getString(2));
				bean.setUser_id(rs.getString(3));
				bean.setEnter_dt(rs.getString(4));
				bean.setClient_cnt(rs.getInt(5));
				bean.setClient_ga(rs.getFloat(6));
				bean.setGen_cnt_1(rs.getInt(7));
				bean.setGen_cnt_2(rs.getInt(8));
				bean.setGen_cnt_3(rs.getInt(9));
				bean.setGen_cnt_4(rs.getInt(10));
				bean.setGen_cnt_5(rs.getInt(11));
				bean.setGen_ga(rs.getFloat(12));
				bean.setPut_cnt_1(rs.getInt(13));
				bean.setPut_cnt_2(rs.getInt(14));
				bean.setPut_cnt_3(rs.getInt(15));
				bean.setPut_cnt_4(rs.getInt(16));
				bean.setPut_cnt_5(rs.getInt(17));
				bean.setPut_ga(rs.getFloat(18));
				bean.setBas_cnt_1(rs.getInt(19));
				bean.setBas_cnt_2(rs.getInt(20));
				bean.setBas_cnt_3(rs.getInt(21));
				bean.setBas_cnt_4(rs.getInt(22));
				bean.setBas_cnt_5(rs.getInt(23));
				bean.setBas_ga(rs.getFloat(24));

				vt.add(bean);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[StatBusDatabase:getStatBusSearch2]"+e);
			System.out.println("[StatBusDatabase:getStatBusSearch2]"+query2);
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
	 *	����� ����������Ȳ ���
	 */
	public boolean insertStatBus(StatBusBean bean)
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		int chk = 0;

		String query = " insert into stat_bus values (?, ?, ?, ?, ?,"+
						" ?, ?, ?, ?, ?, ?,"+
						" ?, ?, ?, ?, ?, ?,"+
						" ?, ?, ?, ?, ?, ?,"+
						" ?, to_char(sysdate,'YYYYMMDD'), 'Y')";

		//�Է�üũ
		String query2 = "select count(0) from stat_bus where save_dt=? and seq=?";

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
				pstmt.setString(1, bean.getSave_dt());		
				pstmt.setString(2, bean.getSeq());	
				pstmt.setString(3, bean.getUser_id());	
				pstmt.setInt(4, bean.getClient_cnt());
				pstmt.setFloat(5, bean.getClient_ga());
				pstmt.setInt(6, bean.getGen_cnt_1());
				pstmt.setInt(7, bean.getGen_cnt_2());
				pstmt.setInt(8, bean.getGen_cnt_3());
				pstmt.setInt(9, bean.getGen_cnt_4());
				pstmt.setInt(10, bean.getGen_cnt_5());
				pstmt.setFloat(11, bean.getGen_ga());
				pstmt.setInt(12, bean.getPut_cnt_1());
				pstmt.setInt(13, bean.getPut_cnt_2());
				pstmt.setInt(14, bean.getPut_cnt_3());
				pstmt.setInt(15, bean.getPut_cnt_4());
				pstmt.setInt(16, bean.getPut_cnt_5());
				pstmt.setFloat(17, bean.getPut_ga());
				pstmt.setInt(18, bean.getBas_cnt_1());
				pstmt.setInt(19, bean.getBas_cnt_2());
				pstmt.setInt(20, bean.getBas_cnt_3());
				pstmt.setInt(21, bean.getBas_cnt_4());
				pstmt.setInt(22, bean.getBas_cnt_5());
				pstmt.setFloat(23, bean.getBas_ga());
				pstmt.setString(24, bean.getReg_id());				
				pstmt.executeUpdate();
				pstmt.close();
			}

			conn.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[StatBusDatabase:insertStatBus]"+e);
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
			System.out.println("[StatBusDatabase:getStatMngUser]"+e);
			System.out.println("[StatBusDatabase:getStatMngUser]"+query);
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
			System.out.println("[StatBusDatabase:getStatMngClientList]"+e);
			System.out.println("[StatBusDatabase:getStatMngClientList]"+query);
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
			System.out.println("[StatBusDatabase:getStatMngClientUsers]"+e);
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

		query = " select a.*, c.car_no, c.car_nm  from cont_n_view a, car_reg c where  a.car_mng_id = c.car_mng_id and a.client_id='"+ client_id +"'"+
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
			System.out.println("[StatBusDatabase:getClientCarList]\n"+e);
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
				" from ("+sub_query+") a, cont_n_view b, car_reg c "+
				" where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id = c.car_mng_id(+) "+
				" order by b.firm_nm ";

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
			System.out.println("[StatBusDatabase:getStatMngCarList]"+e);
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
	 *	���ϱ��� ��ȸ(�ܵ�,���� ����)-���� ����ġ-cont_view�� �뿩������ �������� ����
	 */
	public Vector getStatBusSearch_20070515(String gubun, String br_id, String s_yy, String s_mm, String dept_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";
		String search_query = "";
		String search_dt = "replace(nvl(b.rent_dt,a.rent_dt), ' ', '')";

		if(gubun.equals("5"))	search_dt = "b.rent_start_dt";
		if(gubun.equals("6"))	search_dt = "replace(nvl(b.rent_dt,a.rent_dt), ' ', '')";

		if(!s_yy.equals("") && s_mm.equals(""))		search_query  = " and "+search_dt+" like '%"+s_yy+"%'";
		if(!s_yy.equals("") && !s_mm.equals(""))	search_query  = " and "+search_dt+" between '"+s_yy+"' and '"+s_mm+"'";

		query = " select"+
				"	d.br_nm, c.nm, b.user_nm, b.enter_dt, a.*"+
				" from"+
				"	("+
				"		select"+
				"			decode(b.rent_st,'1',a.bus_id,b.ext_agnt) bus_id,"+
				"      count(0) tot_cnt,"+
				"      sum(decode(a.rent_st,'1',1,0)) cnt01,"+
				"      sum(decode(a.rent_st,'3',1,0)) cnt02,"+
				"      sum(decode(a.rent_st,'4',1,0)) cnt03,"+
				"      sum(decode(a.rent_st,'2',1,'5',1,0)) cnt04,"+
				"      sum(decode(a.rent_st,'6',1,'7',1,0)) cnt05,"+
				"      sum(decode(b.rent_way,'1',1,0)) cnt10,"+
				"      sum(decode(b.rent_way,'2',1,0)) cnt20,"+
				"      sum(decode(b.rent_way,'3',1,0)) cnt30,"+
				"      sum(decode(b.rent_way||a.rent_st,'11',1,0)) cnt11,"+
				"      sum(decode(b.rent_way||a.rent_st,'13',1,0)) cnt12,"+
				"      sum(decode(b.rent_way||a.rent_st,'14',1,0)) cnt13,"+
				"      sum(decode(b.rent_way||a.rent_st,'12',1,'15',1,0)) cnt14,"+
				"      sum(decode(b.rent_way||a.rent_st,'16',1,'17',1,0)) cnt15,"+
				"      sum(decode(b.rent_way||a.rent_st,'21',1,0)) cnt21,"+
				"      sum(decode(b.rent_way||a.rent_st,'23',1,0)) cnt22,"+
				"      sum(decode(b.rent_way||a.rent_st,'24',1,0)) cnt23,"+
				"      sum(decode(b.rent_way||a.rent_st,'22',1,'25',1,0)) cnt24,"+
				"      sum(decode(b.rent_way||a.rent_st,'26',1,'27',1,0)) cnt25,"+
				"      sum(decode(b.rent_way||a.rent_st,'31',1,0)) cnt31,"+
				"      sum(decode(b.rent_way||a.rent_st,'33',1,0)) cnt32,"+
				"      sum(decode(b.rent_way||a.rent_st,'34',1,0)) cnt33,"+
				"      sum(decode(b.rent_way||a.rent_st,'32',1,'35',1,0)) cnt34,"+
				"      sum(decode(b.rent_way||a.rent_st,'36',1,'37',1,0)) cnt35,"+
				"      count(distinct a.client_id) c_cnt"+
				"		from cont a, fee b"+
				"		where"+
				"			nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and b.con_mon>= 6"+
				"			and a.rent_l_cd=b.rent_l_cd"+
							search_query+
				"		group by decode(b.rent_st,'1',a.bus_id,b.ext_agnt)"+
				"	) a, users b, (select * from code where c_st='0002') c, branch d"+
				" where a.bus_id=b.user_id"+
				" and b.dept_id=c.code and b.br_id=d.br_id";

		if(!br_id.equals("")) query += " and b.br_id='"+br_id+"'";

		if(dept_id.equals("0001") || dept_id.equals("0002") || dept_id.equals("0007") || dept_id.equals("0008")){
			query += " and b.dept_id='"+dept_id+"' and b.loan_st in ('1','2')";
		}else{
  			query += " and b.user_pos not in ('���','�븮','����','����','����') and b.loan_st is null";
	    }

		query += " order by b.dept_id desc, a.tot_cnt desc, b.enter_dt";

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
			System.out.println("[StatBusDatabase:getStatBusSearch_20070515]"+e);
			System.out.println("[StatBusDatabase:getStatBusSearch_20070515]"+query);
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
	 *	���ϱ��� ��ȸ(�ܵ�,���� ����)-���� ����ġ-cont_view�� �뿩������ �������� ���� , �������к� ��Ȳ
	 */
	public Vector getStatBusSearch_20070927(String gubun, String br_id, String s_yy, String s_mm, String dept_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";
		String search_query = "";
		String search_dt = "replace(nvl(b.rent_dt,a.rent_dt), ' ', '')";

		if(gubun.equals("5"))	search_dt = "b.rent_start_dt";
		if(gubun.equals("6"))	search_dt = "replace(nvl(b.rent_dt,a.rent_dt), ' ', '')";

		if(!s_yy.equals("") && s_mm.equals(""))		search_query  = " and "+search_dt+" like '%"+s_yy+"%'";
		if(!s_yy.equals("") && !s_mm.equals(""))	search_query  = " and "+search_dt+" between '"+s_yy+"' and '"+s_mm+"'";

		query = " select"+
				"	d.br_nm, c.nm, b.user_nm, b.enter_dt, a.*"+
				" from \n"+
				"	("+
				"		select"+
				"			decode(b.rent_st,'1',a.bus_id,b.ext_agnt) bus_id,"+
				"      count(0) tot_cnt,"+
				"      sum(decode(a.bus_st,'1',1,'5','1', 0)) cnt01,"+
				"      sum(decode(a.bus_st,'2',1,0)) cnt02,"+
				"      sum(decode(a.bus_st,'6',1,0)) cnt03,"+
				"      sum(decode(a.bus_st,'3',1,0)) cnt04,"+
				"      sum(decode(a.bus_st,'4',1,0)) cnt05,"+
				"      sum(decode(b.rent_way,'1',1,0)) cnt10,"+
				"      sum(decode(b.rent_way,'3',1,'2',1,0)) cnt20,"+
				"      sum(decode(b.rent_way||a.bus_st,'11',1,'15',1,0)) cnt11,"+
				"      sum(decode(b.rent_way||a.bus_st,'12',1,0)) cnt12,"+
				"      sum(decode(b.rent_way||a.bus_st,'16',1,0)) cnt13,"+
				"      sum(decode(b.rent_way||a.bus_st,'13',1,0)) cnt14,"+
				"      sum(decode(b.rent_way||a.bus_st,'14',1,0)) cnt15,"+
				"      sum(decode(b.rent_way||a.bus_st,'31',1,'35',1,'21',1,'25',1,0)) cnt21,"+
				"      sum(decode(b.rent_way||a.bus_st,'32',1,'22',1,0)) cnt22,"+
				"      sum(decode(b.rent_way||a.bus_st,'36',1,'26',1,0)) cnt23,"+
				"      sum(decode(b.rent_way||a.bus_st,'33',1,'23',1,0)) cnt24,"+
				"      sum(decode(b.rent_way||a.bus_st,'34',1,'24',1,0)) cnt25, \n"+
				"      count(distinct a.client_id) c_cnt"+
				"		from cont a, fee b"+
				"		where"+
				"			nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and b.con_mon>= 6"+
				"			and a.rent_l_cd=b.rent_l_cd"+
							search_query+
				"		group by decode(b.rent_st,'1',a.bus_id,b.ext_agnt)"+
				"	) a, users b, (select * from code where c_st='0002') c, branch d"+
				" where b.user_id = a.bus_id(+) "+
				" and b.dept_id=c.code and b.br_id=d.br_id and b.loan_st  in ('1', '2') \n";

		if(!br_id.equals("")) query += " and b.br_id='"+br_id+"'";

		if(dept_id.equals("0001") || dept_id.equals("0002") || dept_id.equals("0007") || dept_id.equals("0008")  || dept_id.equals("0009")  || dept_id.equals("0010")  || dept_id.equals("0011")  || dept_id.equals("0012")  || dept_id.equals("0013") || dept_id.equals("0014")  || dept_id.equals("0015")  || dept_id.equals("0016")  || dept_id.equals("0017")  || dept_id.equals("0018")  ){
			query += " and b.dept_id='"+dept_id+"' \n";
		} else if(dept_id.equals("all") ){
			query += "  and b.dept_id in ('0001','0002', '0007', '0008','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018' ) \n";		
			
		}else{
  			query += " and b.user_pos not in ('���','�븮','����','����','����') and b.loan_st is null";
	    }

		query += " order by b.dept_id , a.tot_cnt desc, b.enter_dt";

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
			System.out.println("[StatBusDatabase:getStatBusSearch_20070927]"+e);
			System.out.println("[StatBusDatabase:getStatBusSearch_20070927]"+query);
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
	 *	���ϱ��� ��ȸ(�ܵ�,���� ����)-���� ����ġ-cont_view�� �뿩������ �������� ����  
	 */
	public Vector getStatBusSearch_20080917(String gubun, String br_id, String s_yy, String s_mm, String dept_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";
		String search_query = "";
		String search_dt = "replace(nvl(rent_dt2,rent_dt), '-', '')";


		if(gubun.equals("5"))	search_dt = "replace(rent_start_dt, '-', '')";
		if(gubun.equals("6"))	search_dt = "replace(nvl(rent_dt2,rent_dt), '-', '')";

		if(!s_yy.equals("") && s_mm.equals(""))		search_query  = " and "+search_dt+" like '%"+s_yy+"%'";
		if(!s_yy.equals("") && !s_mm.equals(""))	search_query  = " and "+search_dt+" between '"+s_yy+"' and '"+s_mm+"'";
	
			query = " select  /*+ leading(U) use_nl(u) */ "+
					" decode(e.dept_id,'0001','������','0002','��������','0009','������', '0012', '������',  '1000', '������Ʈ',  decode(e.loan_st,'1','���� ��������','���� ������')) nm,"+
					" decode(e.dept_id,'0001','������','0002','��������','0009','���� ������', '0012', '��õ ������',  '1000', '������Ʈ',  decode(e.dept_id,'0007','�λ� ','0008','���� ','0010','���� ','0011','�뱸 ')||decode(e.loan_st,'1','��������','������')) nm1,"+
					" e.dept_id, e.user_nm, u.user_id bus_id, e.enter_dt, \n"+
					" nvl(b1.cnt,0)+nvl(c1.cnt,0)+nvl(d1.cnt,0)+nvl(b2.cnt,0)+nvl(c2.cnt,0)+nvl(d2.cnt,0)+nvl(b3.cnt,0)+nvl(c3.cnt,0)+nvl(d3.cnt,0)+nvl(b4.cnt,0)+nvl(c4.cnt,0)+nvl(d4.cnt,0)+nvl(b5.cnt,0)+nvl(c5.cnt,0)+nvl(d5.cnt,0) tot_cnt,\n"+
					" nvl(a1.cnt,0) c_cnt, nvl(b1.cnt,0)+nvl(c1.cnt,0)+nvl(d1.cnt,0)  cnt01, nvl(b2.cnt,0)+nvl(c2.cnt,0)+nvl(d2.cnt,0) cnt02, nvl(b3.cnt,0)+nvl(c3.cnt,0)+nvl(d3.cnt,0) cnt03, nvl(b4.cnt,0)+nvl(c4.cnt,0)+nvl(d4.cnt,0) cnt04, nvl(b5.cnt,0)+nvl(c5.cnt,0)+nvl(d5.cnt,0) cnt05,\n"+
					" nvl(b1.cnt,0)+ nvl(b2.cnt,0)+nvl(b3.cnt,0)+nvl(b4.cnt,0)+nvl(b5.cnt,0) cnt10, nvl(b1.cnt,0) cnt11, nvl(b2.cnt,0) cnt12, nvl(b3.cnt,0) cnt13, nvl(b4.cnt,0) cnt14, nvl(b5.cnt,0) cnt15,\n"+
					" nvl(d1.cnt,0)+ nvl(d2.cnt,0)+nvl(d3.cnt,0)+nvl(d4.cnt,0)+nvl(d5.cnt,0) cnt20, nvl(d1.cnt,0) cnt21, nvl(d2.cnt,0) cnt22, nvl(d3.cnt,0) cnt23, nvl(d4.cnt,0) cnt24, nvl(d5.cnt,0) cnt25,\n"+
					" nvl(c1.cnt,0)+nvl(c2.cnt,0)+nvl(c3.cnt,0)+nvl(c4.cnt,0)+nvl(c5.cnt,0)+nvl(d1.cnt,0)+ nvl(d2.cnt,0)+nvl(d3.cnt,0)+nvl(d4.cnt,0)+nvl(d5.cnt,0) cnt30, \n"+
					" nvl(c1.cnt,0)+nvl(d1.cnt,0) cnt31, nvl(c2.cnt,0)+nvl(d2.cnt,0) cnt32, nvl(c3.cnt,0)+nvl(d3.cnt,0) cnt33, nvl(c4.cnt,0)+nvl(d4.cnt,0) cnt34, nvl(c5.cnt,0)+nvl(d5.cnt,0) cnt35, \n"+
					" nvl(b1.e_cnt,0)+nvl(c1.e_cnt,0)+nvl(d1.e_cnt,0)+nvl(b2.e_cnt,0)+nvl(c2.e_cnt,0)+nvl(d2.e_cnt,0)+nvl(b3.e_cnt,0)+nvl(c3.e_cnt,0)+nvl(d3.e_cnt,0)+nvl(b4.e_cnt,0)+nvl(c4.e_cnt,0)+nvl(d4.e_cnt,0)+nvl(b5.e_cnt,0)+nvl(c5.e_cnt,0)+nvl(d5.e_cnt,0) e_tot_cnt,\n"+
				    " nvl(b1.e_cnt,0)+nvl(c1.e_cnt,0)+nvl(d1.e_cnt,0)  e_cnt01, nvl(b2.e_cnt,0)+nvl(c2.e_cnt,0)+nvl(d2.e_cnt,0) e_cnt02, nvl(b3.e_cnt,0)+nvl(c3.e_cnt,0)+nvl(d3.e_cnt,0) e_cnt03, nvl(b4.e_cnt,0)+nvl(c4.e_cnt,0)+nvl(d4.e_cnt,0) e_cnt04, nvl(b5.e_cnt,0)+nvl(c5.e_cnt,0)+nvl(d5.e_cnt,0) e_cnt05\n"+
					" from  "+
					//�������
					" (select user_id from users) u,\n "+
					//��ü��=���ʿ�����
					" (select nvl(bus_id,'999999') as user_id, count(0) cnt from (select bus_id, client_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st<>'2' "+search_query+" AND client_id <> '000228' group by bus_id, client_id, r_site) a group by bus_id) a1, \n"+
					//�Ϲݽ�=�ű�
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a, (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+) and  nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='1' and a.rent_st='1' and a.fee_rent_st = '1'  "+search_query+" AND client_id <> '000228' group by bus_id) b1, \n"+
					//�Ϲݽ�=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+) and  nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='1' and a.rent_st='3' and a.fee_rent_st = '1' "+search_query+" AND a.client_id <> '000228' group by bus_id) b2, \n"+
					//�Ϲݽ�=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='1' and a.rent_st='4' and a.fee_rent_st = '1' "+search_query+" AND a.client_id <> '000228' group by bus_id) b3, \n"+
					//�Ϲݽ�=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+) and  nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='1' and a.fee_rent_st > '1'  "+search_query+" AND a.client_id <> '000228' group by bus_id) b4, \n"+
					//�Ϲݽ�=������
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='1' and rent_st='6' and fee_rent_st = '1' "+search_query+" AND a.client_id <> '000228' group by bus_id) b5,\n"+
					//�⺻��=�ű�
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='3' and a.rent_st='1' and a.fee_rent_st = '1' "+search_query+" AND a.client_id <> '000228' group by bus_id) c1,\n "+
					//�⺻��=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='3' and a.rent_st='3' and a.fee_rent_st = '1' "+search_query+" AND client_id <> '000228' group by bus_id) c2, \n"+
					//�⺻��=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='3' and a.rent_st='4' and a.fee_rent_st = '1' "+search_query+" AND client_id <> '000228' group by bus_id) c3, \n"+
					//�⺻��=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view  a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='3' and a.fee_rent_st > '1'  "+search_query+" AND client_id <> '000228' group by bus_id) c4, \n"+
					//�⺻��=������
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='3' and a.rent_st='6' and a.fee_rent_st = '1' "+search_query+" AND client_id <> '000228' group by bus_id) c5, \n"+
					//�����=�ű�
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='2' and a.rent_st='1' and a.fee_rent_st = '1' "+search_query+" AND client_id <> '000228' group by bus_id) d1, \n"+
					//�����=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and  nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='2' and a.rent_st='3' and a.fee_rent_st = '1' "+search_query+" AND client_id <> '000228' group by bus_id) d2, \n"+
					//�����=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='2' and a.rent_st='4' and a.fee_rent_st = '1' "+search_query+" AND client_id <> '000228' group by bus_id) d3, \n"+
					//�����=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='2' and a.fee_rent_st > '1'  "+search_query+" AND client_id <> '000228' group by bus_id) d4, \n"+
					//�����=������
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='2' and a.rent_st='6' and a.fee_rent_st = '1' "+search_query+" AND client_id <> '000228' group by bus_id) d5, \n"+
					" users e, code f "+
					" where u.user_id=a1.user_id(+)\n"+
					" and u.user_id=b1.user_id(+) and u.user_id=b2.user_id(+) and u.user_id=b3.user_id(+) and u.user_id=b4.user_id(+) and u.user_id=b5.user_id(+) \n"+
					" and u.user_id=c1.user_id(+) and u.user_id=c2.user_id(+) and u.user_id=c3.user_id(+) and u.user_id=c4.user_id(+) and u.user_id=c5.user_id(+) \n"+
					" and u.user_id=d1.user_id(+) and u.user_id=d2.user_id(+) and u.user_id=d3.user_id(+) and u.user_id=d4.user_id(+) and u.user_id=d5.user_id(+) \n"+
					" and u.user_id=e.user_id and e.dept_id=f.code(+) and f.c_st='0002' and f.code<>'0000' \n";
					
			if(dept_id.equals("0001") || dept_id.equals("0002") || dept_id.equals("0007") || dept_id.equals("0008") || dept_id.equals("0009") || dept_id.equals("0010") || dept_id.equals("0011") || dept_id.equals("0012")){
					query += " and e.dept_id='"+dept_id+"' and e.loan_st in ('1','2') \n";
						
			} else if(dept_id.equals("all") ){
				      query += " and  (  ( e.dept_id in ('0001','0002', '0007', '0008','0009','0010','0011', '0012','0013','0014','0015','0016','0017','0018') and e.loan_st in ('1', '2') )  or ( e.dept_id = '1000' and e.user_id not in ('000221') ) ) \n";
		
			}else{
  					query += " and e.user_pos not in ('���','�븮','����','����','����') and e.loan_st is null"; 
	   		}		
	  		
	   		query += " order by  decode(e.dept_id,'0001','1','0002','3','0009','1', '0012','1', '1000', '6',  decode(e.loan_st,'1','4','2')),  7 desc, e.enter_dt";

	
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
			System.out.println("[StatBusDatabase:getStatBusSearch_20080917]"+e);
			System.out.println("[StatBusDatabase:getStatBusSearch_20080917]"+query);
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
	 *	����������Ȳ/������Ȳ : ��ü/����/�縮�� ��ȸ �߰�
	 */
	public Vector getStatBusSearch_20140101(String gubun, String gubun2, String br_id, String s_yy, String s_mm, String dept_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";
		String search_query = "";
		String search_dt = "replace(nvl(rent_dt2,rent_dt), '-', '')";


		if(gubun.equals("5"))	search_dt = "replace(rent_start_dt, '-', '')";
		if(gubun.equals("6"))	search_dt = "replace(nvl(rent_dt2,rent_dt), '-', '')";

		if(!s_yy.equals("") && s_mm.equals(""))		search_query  = " and "+search_dt+" like '%"+s_yy+"%'";
		if(!s_yy.equals("") && !s_mm.equals(""))	search_query  = " and "+search_dt+" between '"+s_yy+"' and '"+s_mm+"'";

		if(gubun2.equals("0"))	search_query += " and car_gu='0' ";
		if(gubun2.equals("1"))	search_query += " and car_gu='1' ";

	
			query = " select  /*+ leading(U) use_nl(u) */ "+
					" decode(e.dept_id,'0001','������ ������','0002','������ ��������',  '0014', '������ ��������',  '0015', '������ ��������',  '1000', '������Ʈ',   decode(e.dept_id,'0007','���� ','0008','���� ','0010','���� ','0011','���� ' , '0016','���� ' ,  '0013',  '������ ' , '0009', '������ ',  '0012', '������ ',  '0017', '������ ', '0018',  '������ '    )||decode(e.loan_st,'1','��������','������') ) nm,"+
					" decode(e.dept_id,'0001','������','0002','��������',  '0014', '���� ��������',  '0015', '���� ��������',  '0016', '��� ������',   '1000', '������Ʈ',  decode(e.dept_id,'0007','�λ� ','0008','���� ','0010','���� ','0011','�뱸 ', '0013', '���� ', '0018', '���� ', '0017', '��ȭ�� ',  '0009', '���� ',   '0012', '��õ '     )||decode(e.loan_st,'1','��������','������')) nm1,"+
					" e.dept_id, e.user_nm, u.user_id bus_id, e.enter_dt, \n"+
					" nvl(b1.cnt,0)+nvl(c1.cnt,0)+nvl(d1.cnt,0)+nvl(b2.cnt,0)+nvl(c2.cnt,0)+nvl(d2.cnt,0)+nvl(b3.cnt,0)+nvl(c3.cnt,0)+nvl(d3.cnt,0)+nvl(b4.cnt,0)+nvl(c4.cnt,0)+nvl(d4.cnt,0)+nvl(b5.cnt,0)+nvl(c5.cnt,0)+nvl(d5.cnt,0) tot_cnt,\n"+
					" nvl(a1.cnt,0) c_cnt, nvl(b1.cnt,0)+nvl(c1.cnt,0)+nvl(d1.cnt,0)  cnt01, nvl(b2.cnt,0)+nvl(c2.cnt,0)+nvl(d2.cnt,0) cnt02, nvl(b3.cnt,0)+nvl(c3.cnt,0)+nvl(d3.cnt,0) cnt03, nvl(b4.cnt,0)+nvl(c4.cnt,0)+nvl(d4.cnt,0) cnt04, nvl(b5.cnt,0)+nvl(c5.cnt,0)+nvl(d5.cnt,0) cnt05,\n"+
					" nvl(b1.cnt,0)+ nvl(b2.cnt,0)+nvl(b3.cnt,0)+nvl(b4.cnt,0)+nvl(b5.cnt,0) cnt10, nvl(b1.cnt,0) cnt11, nvl(b2.cnt,0) cnt12, nvl(b3.cnt,0) cnt13, nvl(b4.cnt,0) cnt14, nvl(b5.cnt,0) cnt15,\n"+
					" nvl(d1.cnt,0)+ nvl(d2.cnt,0)+nvl(d3.cnt,0)+nvl(d4.cnt,0)+nvl(d5.cnt,0) cnt20, nvl(d1.cnt,0) cnt21, nvl(d2.cnt,0) cnt22, nvl(d3.cnt,0) cnt23, nvl(d4.cnt,0) cnt24, nvl(d5.cnt,0) cnt25,\n"+
					" nvl(c1.cnt,0)+nvl(c2.cnt,0)+nvl(c3.cnt,0)+nvl(c4.cnt,0)+nvl(c5.cnt,0)+nvl(d1.cnt,0)+ nvl(d2.cnt,0)+nvl(d3.cnt,0)+nvl(d4.cnt,0)+nvl(d5.cnt,0) cnt30, \n"+
					" nvl(c1.cnt,0)+nvl(d1.cnt,0) cnt31, nvl(c2.cnt,0)+nvl(d2.cnt,0) cnt32, nvl(c3.cnt,0)+nvl(d3.cnt,0) cnt33, nvl(c4.cnt,0)+nvl(d4.cnt,0) cnt34, nvl(c5.cnt,0)+nvl(d5.cnt,0) cnt35, \n"+
					" nvl(b1.e_cnt,0)+nvl(c1.e_cnt,0)+nvl(d1.e_cnt,0)+nvl(b2.e_cnt,0)+nvl(c2.e_cnt,0)+nvl(d2.e_cnt,0)+nvl(b3.e_cnt,0)+nvl(c3.e_cnt,0)+nvl(d3.e_cnt,0)+nvl(b4.e_cnt,0)+nvl(c4.e_cnt,0)+nvl(d4.e_cnt,0)+nvl(b5.e_cnt,0)+nvl(c5.e_cnt,0)+nvl(d5.e_cnt,0) e_tot_cnt,\n"+
				    " nvl(b1.e_cnt,0)+nvl(c1.e_cnt,0)+nvl(d1.e_cnt,0)  e_cnt01, nvl(b2.e_cnt,0)+nvl(c2.e_cnt,0)+nvl(d2.e_cnt,0) e_cnt02, nvl(b3.e_cnt,0)+nvl(c3.e_cnt,0)+nvl(d3.e_cnt,0) e_cnt03, nvl(b4.e_cnt,0)+nvl(c4.e_cnt,0)+nvl(d4.e_cnt,0) e_cnt04, nvl(b5.e_cnt,0)+nvl(c5.e_cnt,0)+nvl(d5.e_cnt,0) e_cnt05\n"+
					" from  "+
					//�������
					" (select user_id from users) u,\n "+
					//��ü��=���ʿ�����
					" (select nvl(bus_id,'999999') as user_id, count(0) cnt from (select bus_id, client_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st not in('2','5') "+search_query+" AND client_id <> '000228' group by bus_id, client_id, r_site) a group by bus_id) a1, \n"+
					//�Ϲݽ�=�ű�
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a, (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+) and  nvl(use_yn,'Y')='Y' and car_st in ('1','3') and rent_way_cd='1' and rent_st='1' and fee_rent_st = '1'  "+search_query+" AND client_id <> '000228' group by bus_id) b1, \n"+
					//�Ϲݽ�=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+) and  nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='1' and rent_st='3' and a.fee_rent_st = '1' "+search_query+" AND a.client_id <> '000228' group by bus_id) b2, \n"+
					//�Ϲݽ�=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='1' and rent_st='4' and a.fee_rent_st = '1' "+search_query+" AND a.client_id <> '000228' group by bus_id) b3, \n"+
					//�Ϲݽ�=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+) and  nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='1' and fee_rent_st not in ('1')  "+search_query+" AND a.client_id <> '000228' group by bus_id) b4, \n"+
					//�Ϲݽ�=������
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='1' and rent_st='6' and fee_rent_st = '1' "+search_query+" AND a.client_id <> '000228' group by bus_id) b5,\n"+
					//�⺻��=�ű�
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='3' and a.rent_st='1' and a.fee_rent_st = '1' "+search_query+" AND a.client_id <> '000228' group by bus_id) c1,\n "+
					//�⺻��=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='3' and a.rent_st='3' and a.fee_rent_st = '1' "+search_query+" AND client_id <> '000228' group by bus_id) c2, \n"+
					//�⺻��=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='3' and a.rent_st='4' and a.fee_rent_st = '1' "+search_query+" AND client_id <> '000228' group by bus_id) c3, \n"+
					//�⺻��=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view  a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='3' and a.fee_rent_st not in ('1')  "+search_query+" AND client_id <> '000228' group by bus_id) c4, \n"+
					//�⺻��=������
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='3' and a.rent_st='6' and a.fee_rent_st = '1' "+search_query+" AND client_id <> '000228' group by bus_id) c5, \n"+
					//�����=�ű�
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='2' and a.rent_st='1' and a.fee_rent_st = '1' "+search_query+" AND client_id <> '000228' group by bus_id) d1, \n"+
					//�����=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and  nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='2' and a.rent_st='3' and a.fee_rent_st = '1' "+search_query+" AND client_id <> '000228' group by bus_id) d2, \n"+
					//�����=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='2' and a.rent_st='4' and a.fee_rent_st = '1' "+search_query+" AND client_id <> '000228' group by bus_id) d3, \n"+
					//�����=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='2' and a.fee_rent_st not in ('1')  "+search_query+" AND client_id <> '000228' group by bus_id) d4, \n"+
					//�����=������
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='2' and a.rent_st='6' and a.fee_rent_st = '1' "+search_query+" AND client_id <> '000228' group by bus_id) d5, \n"+
					" users e, code f, car_off_emp g, car_off h "+
					" where u.user_id=a1.user_id(+)\n"+
					" and u.user_id=b1.user_id(+) and u.user_id=b2.user_id(+) and u.user_id=b3.user_id(+) and u.user_id=b4.user_id(+) and u.user_id=b5.user_id(+) \n"+
					" and u.user_id=c1.user_id(+) and u.user_id=c2.user_id(+) and u.user_id=c3.user_id(+) and u.user_id=c4.user_id(+) and u.user_id=c5.user_id(+) \n"+
					" and u.user_id=d1.user_id(+) and u.user_id=d2.user_id(+) and u.user_id=d3.user_id(+) and u.user_id=d4.user_id(+) and u.user_id=d5.user_id(+) \n"+
					" and u.user_id=e.user_id and e.dept_id=f.code(+) and f.c_st='0002' and f.code<>'0000' \n"+
                    " and e.sa_code=g.emp_id(+) and g.agent_id=h.car_off_id(+) \n"+
					"	";
					
			if(dept_id.equals("0001") || dept_id.equals("0002") || dept_id.equals("0007") || dept_id.equals("0008") || dept_id.equals("0009") || dept_id.equals("0010") || dept_id.equals("0011") || dept_id.equals("0012")  || dept_id.equals("0013")  || dept_id.equals("0014")   || dept_id.equals("0015")   || dept_id.equals("0016") || dept_id.equals("0017")|| dept_id.equals("0018") ){
					query += " and e.dept_id='"+dept_id+"' and e.loan_st in ('1','2') \n";
						
			} else if(dept_id.equals("all") ){
				      query += " and  (  ( e.dept_id in ('0001','0002', '0007', '0008','0009','0010','0011', '0012', '0013','0014','0015','0016','0017','0018') and e.loan_st in ('1','2') )  or ( e.dept_id = '1000' ) ) \n";
		
			}else{
  					query += " and e.user_pos not in ('���','�븮','����','����','����') and e.loan_st is null"; 
	   		}	

			//������Ʈ�� ������ ������ ����� ���� '�ǿ�ö','���ο�', '�����','�̽���' e.user_id not in ('000230','000235', '000250','000252')
			query += " and nvl(h.work_st,'C')='C' and nvl(h.use_yn,'Y')='Y'";  //����/��� ��� ����, �ŷ���ü

	  		
	  		query += " order by decode(e.dept_id,'0001','1','0002','2',  '1000', '5', '0014', '2', '0015', '2', '0016', '3',  decode(e.dept_id ||e.loan_st,  '00091' , '2', '00092', '1',   '00121' , '2', '00122', '1',  '00171' , '2', '00172', '1',   '00181' , '2', '00182', '1',    '00131' , '2', '00132', '1', '00071', '4',  '00072', '3',   '00081', '4',  '00082', '3',   '00101', '4',  '00102', '3',   '00111', '4',  '00112', '3',    '00013', '4',  '00132', '3')  ) , e.dept_id, 7 desc, e.enter_dt";

	
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
			System.out.println("[StatBusDatabase:getStatBusSearch_20140101]"+e);
			System.out.println("[StatBusDatabase:getStatBusSearch_20140101]"+query);
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
	 *	����������Ȳ2/������Ȳ : ��ü/����/�縮�� ��ȸ �߰�
	 */
	public Vector getStatBusSearch_20150315(String gubun, String gubun2, String br_id, String s_yy, String s_mm, String dept_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";
		String search_query = "";
		String search_dt = "replace(nvl(rent_dt2,rent_dt), '-', '')"; //�⺻ �����Ȳ


		if(gubun.equals("5"))	search_dt = "replace(rent_start_dt, '-', '')";
		if(gubun.equals("6"))	search_dt = "replace(nvl(rent_dt2,rent_dt), '-', '')";

		if(!s_yy.equals("") && s_mm.equals(""))		search_query  = " and "+search_dt+" like '%"+s_yy+"%'";
		if(!s_yy.equals("") && !s_mm.equals(""))	search_query  = " and "+search_dt+" between '"+s_yy+"' and '"+s_mm+"'";

		if(gubun2.equals("0"))	search_query += " and car_gu='0' ";
		if(gubun2.equals("1"))	search_query += " and car_gu='1' ";

	
			query = " select  /*+ leading(U) use_nl(u) */ "+
					" decode(e.dept_id,'0001','������ ������','0002','������ ��������',  '0014', '������ ��������',  '0015', '������ ��������',  '1000', '������Ʈ',   decode(e.dept_id,'0007','���� ','0008','���� ','0010','���� ','0011','���� ' , '0016','���� ' ,  '0013',  '������ ' , '0009', '������ ',  '0012', '������ ',  '0017', '������ ', '0018',  '������ '    )||decode(e.loan_st,'1','��������','������') ) nm,"+
					" decode(e.dept_id,'0001','������','0002','��������',  '0014', '���� ��������',  '0015', '���� ��������',  '0016', '��� ������',   '1000', '������Ʈ',  decode(e.dept_id,'0007','�λ� ','0008','���� ','0010','���� ','0011','�뱸 ', '0013', '���� ', '0018', '���� ', '0017', '��ȭ�� ',  '0009', '���� ',   '0012', '��õ '     )||decode(e.loan_st,'1','��������','������')) nm1,"+
					" e.dept_id, e.user_nm, u.user_id bus_id, e.enter_dt, \n"+
					" nvl(b1.cnt,0)+nvl(c1.cnt,0)+nvl(d1.cnt,0)+nvl(b2.cnt,0)+nvl(c2.cnt,0)+nvl(d2.cnt,0)+nvl(b3.cnt,0)+nvl(c3.cnt,0)+nvl(d3.cnt,0) tot_cnt,\n"+
					" nvl(a1.cnt,0) c_cnt, nvl(b1.cnt,0)+nvl(c1.cnt,0)+nvl(d1.cnt,0)  cnt01, nvl(b2.cnt,0)+nvl(c2.cnt,0)+nvl(d2.cnt,0) cnt02, nvl(b3.cnt,0)+nvl(c3.cnt,0)+nvl(d3.cnt,0) cnt03, nvl(b4.cnt,0)+nvl(c4.cnt,0)+nvl(d4.cnt,0) cnt04, nvl(b5.cnt,0)+nvl(c5.cnt,0)+nvl(d5.cnt,0) cnt05,\n"+
					" nvl(b1.cnt,0)+ nvl(b2.cnt,0)+nvl(b3.cnt,0) cnt10, nvl(b1.cnt,0) cnt11, nvl(b2.cnt,0) cnt12, nvl(b3.cnt,0) cnt13, nvl(b4.cnt,0) cnt14, nvl(b5.cnt,0) cnt15,\n"+
					" nvl(d1.cnt,0)+ nvl(d2.cnt,0)+nvl(d3.cnt,0)+nvl(d4.cnt,0)+nvl(d5.cnt,0) cnt20, nvl(d1.cnt,0) cnt21, nvl(d2.cnt,0) cnt22, nvl(d3.cnt,0) cnt23, nvl(d4.cnt,0) cnt24, nvl(d5.cnt,0) cnt25,\n"+
					" nvl(c1.cnt,0)+nvl(c2.cnt,0)+nvl(c3.cnt,0)+nvl(c4.cnt,0)+nvl(c5.cnt,0)+nvl(d1.cnt,0)+ nvl(d2.cnt,0)+nvl(d3.cnt,0) cnt30, \n"+
					" nvl(c1.cnt,0)+nvl(d1.cnt,0) cnt31, nvl(c2.cnt,0)+nvl(d2.cnt,0) cnt32, nvl(c3.cnt,0)+nvl(d3.cnt,0) cnt33, nvl(c4.cnt,0)+nvl(d4.cnt,0) cnt34, nvl(c5.cnt,0)+nvl(d5.cnt,0) cnt35, \n"+
					" nvl(b1.e_cnt,0)+nvl(c1.e_cnt,0)+nvl(d1.e_cnt,0)+nvl(b2.e_cnt,0)+nvl(c2.e_cnt,0)+nvl(d2.e_cnt,0)+nvl(b3.e_cnt,0)+nvl(c3.e_cnt,0)+nvl(d3.e_cnt,0)+nvl(b4.e_cnt,0)+nvl(c4.e_cnt,0)+nvl(d4.e_cnt,0)+nvl(b5.e_cnt,0)+nvl(c5.e_cnt,0)+nvl(d5.e_cnt,0) e_tot_cnt,\n"+
				    " nvl(b1.e_cnt,0)+nvl(c1.e_cnt,0)+nvl(d1.e_cnt,0)  e_cnt01, nvl(b2.e_cnt,0)+nvl(c2.e_cnt,0)+nvl(d2.e_cnt,0) e_cnt02, nvl(b3.e_cnt,0)+nvl(c3.e_cnt,0)+nvl(d3.e_cnt,0) e_cnt03, nvl(b4.e_cnt,0)+nvl(c4.e_cnt,0)+nvl(d4.e_cnt,0) e_cnt04, nvl(b5.e_cnt,0)+nvl(c5.e_cnt,0)+nvl(d5.e_cnt,0) e_cnt05\n"+
					" from  "+
					//�������
					" (select user_id from users) u,\n "+
					//��ü��=���ʿ�����
					" (select nvl(bus_id,'999999') as user_id, count(0) cnt from (select bus_id, client_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st not in ('2','5') "+search_query+" AND client_id <> '000228' group by bus_id, client_id, r_site) a group by bus_id) a1, \n"+
					//�Ϲݽ�=�ű�
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a, (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+) and  nvl(use_yn,'Y')='Y' and car_st in ('1','3') and rent_way_cd='1' and fee_rent_st ='1' and car_gu='1'  "+search_query+" AND client_id <> '000228' group by bus_id) b1, \n"+
					//�Ϲݽ�=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+) and  nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='1'  and fee_rent_st ='1'  and  car_gu='0' "+search_query+" AND a.client_id <> '000228' group by bus_id) b2, \n"+
					//�Ϲݽ�=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='1'  and fee_rent_st not in ('1') "+search_query+" AND a.client_id <> '000228' group by bus_id) b3, \n"+
					//�Ϲݽ�=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+) and  nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='1' and fee_rent_st not in ('1')  "+search_query+" AND a.client_id <> '000228' group by bus_id) b4, \n"+
					//�Ϲݽ�=������
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='1' and rent_st='6' and fee_rent_st = '1' "+search_query+" AND a.client_id <> '000228' group by bus_id) b5,\n"+
					//�⺻��=�ű�
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='3' and fee_rent_st ='1' and car_gu='1' "+search_query+" AND a.client_id <> '000228' group by bus_id) c1,\n "+
					//�⺻��=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='3' and fee_rent_st ='1'  and  car_gu='0' "+search_query+" AND client_id <> '000228' group by bus_id) c2, \n"+
					//�⺻��=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='3' and fee_rent_st not in ('1') "+search_query+" AND client_id <> '000228' group by bus_id) c3, \n"+
					//�⺻��=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view  a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='3' and a.fee_rent_st not in ('1')  "+search_query+" AND client_id <> '000228' group by bus_id) c4, \n"+
					//�⺻��=������
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='3' and a.rent_st='6' and a.fee_rent_st = '1' "+search_query+" AND client_id <> '000228' group by bus_id) c5, \n"+
					//�����=�ű�
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='2' and a.rent_st='1' and a.fee_rent_st = '1' "+search_query+" AND client_id <> '000228' group by bus_id) d1, \n"+
					//�����=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and  nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='2' and fee_rent_st ='1'  and  car_gu='0' "+search_query+" AND client_id <> '000228' group by bus_id) d2, \n"+
					//�����=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='2' and fee_rent_st not in ('1') "+search_query+" AND client_id <> '000228' group by bus_id) d3, \n"+
					//�����=����
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='2' and a.fee_rent_st not in ('1')  "+search_query+" AND client_id <> '000228' group by bus_id) d4, \n"+
					//�����=������
					" (select nvl(a.bus_id,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='2' and a.rent_st='6' and a.fee_rent_st = '1' "+search_query+" AND client_id <> '000228' group by bus_id) d5, \n"+
					" users e, code f, car_off_emp g, car_off h "+
					" where u.user_id=a1.user_id(+)\n"+
					" and u.user_id=b1.user_id(+) and u.user_id=b2.user_id(+) and u.user_id=b3.user_id(+) and u.user_id=b4.user_id(+) and u.user_id=b5.user_id(+) \n"+
					" and u.user_id=c1.user_id(+) and u.user_id=c2.user_id(+) and u.user_id=c3.user_id(+) and u.user_id=c4.user_id(+) and u.user_id=c5.user_id(+) \n"+
					" and u.user_id=d1.user_id(+) and u.user_id=d2.user_id(+) and u.user_id=d3.user_id(+) and u.user_id=d4.user_id(+) and u.user_id=d5.user_id(+) \n"+
					" and u.user_id=e.user_id and e.dept_id=f.code(+) and f.c_st='0002' and f.code<>'0000' \n"+
					" and e.sa_code=g.emp_id(+) and g.agent_id=h.car_off_id(+) \n"+
                    " ";  
					
			if(dept_id.equals("0001") || dept_id.equals("0002") || dept_id.equals("0007") || dept_id.equals("0008") || dept_id.equals("0009") || dept_id.equals("0010") || dept_id.equals("0011") || dept_id.equals("0012")  || dept_id.equals("0013")  || dept_id.equals("0014")   || dept_id.equals("0015")   || dept_id.equals("0016") || dept_id.equals("0017")|| dept_id.equals("0018") ){
					query += " and e.dept_id='"+dept_id+"' and e.loan_st in ('1','2') \n";
						
			} else if(dept_id.equals("all") ){
				      query += " and  (  ( e.dept_id in ('0001','0002', '0007', '0008','0009','0010','0011', '0012', '0013','0014','0015','0016','0017','0018') and e.loan_st in ('1', '2') )  or ( e.dept_id = '1000'  ) ) \n";
		
			}else{
  					query += " and e.user_pos not in ('���','�븮','����','����','����') and e.loan_st is null"; 
	   		}	

			//������Ʈ�� ������ ������ ����� ���� '�ǿ�ö','���ο�', '�����','�̽���' e.user_id not in ('000230','000235', '000250','000252')
			query += " and nvl(h.work_st,'C')='C' and nvl(h.use_yn,'Y')='Y'";  //����/��� ��� ����, �ŷ���ü

	  		
	  		query += " order by decode(e.dept_id,'0001','1','0002','2',  '1000', '5', '0014', '2', '0015', '2', '0016', '3',  decode(e.dept_id ||e.loan_st,  '00091' , '2', '00092', '1',   '00121' , '2', '00122', '1',  '00171' , '2', '00172', '1',   '00181' , '2', '00182', '1',    '00131' , '2', '00132', '1', '00071', '4',  '00072', '3',   '00081', '4',  '00082', '3',   '00101', '4',  '00102', '3',   '00111', '4',  '00112', '3',    '00013', '4',  '00132', '3')  ) , e.dept_id, 7 desc, e.enter_dt";

	
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
			System.out.println("[StatBusDatabase:getStatBusSearch_20140101]"+e);
			System.out.println("[StatBusDatabase:getStatBusSearch_20140101]"+query);
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
	 *	�����������Ȳ/������Ȳ : ��ü/����/�縮�� ��ȸ �߰�
	 */
	public Vector getStatBusSearch_20160314(String gubun, String gubun2, String br_id, String s_yy, String s_mm, String dept_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";
		String search_query = "";
		String search_dt = "replace(nvl(rent_dt2,rent_dt), '-', '')";


		if(gubun.equals("5"))	search_dt = "replace(rent_start_dt, '-', '')";
		if(gubun.equals("6"))	search_dt = "replace(nvl(rent_dt2,rent_dt), '-', '')";

		if(!s_yy.equals("") && s_mm.equals(""))		search_query  = " and "+search_dt+" like '%"+s_yy+"%'";
		if(!s_yy.equals("") && !s_mm.equals(""))	search_query  = " and "+search_dt+" between '"+s_yy+"' and '"+s_mm+"'";

		if(gubun2.equals("0"))	search_query += " and car_gu='0' ";
		if(gubun2.equals("1"))	search_query += " and car_gu='1' ";

	
			query = " select  /*+ leading(U) use_nl(u) */ "+
					" decode(e.dept_id,'0001','������ ������','0002','������ ��������',  '0014', '������ ��������',  '0015', '������ ��������',  '1000', '������Ʈ',   decode(e.dept_id,'0007','���� ','0008','���� ','0010','���� ','0011','���� ' , '0016','���� ' ,  '0013',  '������ ' , '0009', '������ ',  '0012', '������ ',  '0017', '������ ', '0018',  '������ '    )||decode(e.loan_st,'1','��������','������') ) nm,"+
					" decode(e.dept_id,'0001','������','0002','��������',  '0014', '���� ��������',  '0015', '���� ��������',  '0016', '��� ������',   '1000', '������Ʈ',  decode(e.dept_id,'0007','�λ� ','0008','���� ','0010','���� ','0011','�뱸 ', '0013', '���� ', '0018', '���� ', '0017', '��ȭ�� ',  '0009', '���� ',   '0012', '��õ '     )||decode(e.loan_st,'1','��������','������')) nm1,"+
					" e.dept_id, e.user_nm, u.user_id bus_id2, e.enter_dt, \n"+
					" nvl(b1.cnt,0)+nvl(c1.cnt,0)+nvl(d1.cnt,0)+nvl(b2.cnt,0)+nvl(c2.cnt,0)+nvl(d2.cnt,0)+nvl(b3.cnt,0)+nvl(c3.cnt,0)+nvl(d3.cnt,0) tot_cnt,\n"+
					" nvl(a1.cnt,0) c_cnt, nvl(b1.cnt,0)+nvl(c1.cnt,0)+nvl(d1.cnt,0)  cnt01, nvl(b2.cnt,0)+nvl(c2.cnt,0)+nvl(d2.cnt,0) cnt02, nvl(b3.cnt,0)+nvl(c3.cnt,0)+nvl(d3.cnt,0) cnt03, nvl(b4.cnt,0)+nvl(c4.cnt,0)+nvl(d4.cnt,0) cnt04, nvl(b5.cnt,0)+nvl(c5.cnt,0)+nvl(d5.cnt,0) cnt05,\n"+
					" nvl(b1.cnt,0)+ nvl(b2.cnt,0)+nvl(b3.cnt,0) cnt10, nvl(b1.cnt,0) cnt11, nvl(b2.cnt,0) cnt12, nvl(b3.cnt,0) cnt13, nvl(b4.cnt,0) cnt14, nvl(b5.cnt,0) cnt15,\n"+
					" nvl(d1.cnt,0)+ nvl(d2.cnt,0)+nvl(d3.cnt,0)+nvl(d4.cnt,0)+nvl(d5.cnt,0) cnt20, nvl(d1.cnt,0) cnt21, nvl(d2.cnt,0) cnt22, nvl(d3.cnt,0) cnt23, nvl(d4.cnt,0) cnt24, nvl(d5.cnt,0) cnt25,\n"+
					" nvl(c1.cnt,0)+nvl(c2.cnt,0)+nvl(c3.cnt,0)+nvl(d1.cnt,0)+ nvl(d2.cnt,0)+nvl(d3.cnt,0) cnt30, \n"+
					" nvl(c1.cnt,0)+nvl(d1.cnt,0) cnt31, nvl(c2.cnt,0)+nvl(d2.cnt,0) cnt32, nvl(c3.cnt,0)+nvl(d3.cnt,0) cnt33, nvl(c4.cnt,0)+nvl(d4.cnt,0) cnt34, nvl(c5.cnt,0)+nvl(d5.cnt,0) cnt35, \n"+
					" nvl(b1.e_cnt,0)+nvl(c1.e_cnt,0)+nvl(d1.e_cnt,0)+nvl(b2.e_cnt,0)+nvl(c2.e_cnt,0)+nvl(d2.e_cnt,0)+nvl(b3.e_cnt,0)+nvl(c3.e_cnt,0)+nvl(d3.e_cnt,0)+nvl(b4.e_cnt,0)+nvl(c4.e_cnt,0)+nvl(d4.e_cnt,0)+nvl(b5.e_cnt,0)+nvl(c5.e_cnt,0)+nvl(d5.e_cnt,0) e_tot_cnt,\n"+
				    " nvl(b1.e_cnt,0)+nvl(c1.e_cnt,0)+nvl(d1.e_cnt,0)  e_cnt01, nvl(b2.e_cnt,0)+nvl(c2.e_cnt,0)+nvl(d2.e_cnt,0) e_cnt02, nvl(b3.e_cnt,0)+nvl(c3.e_cnt,0)+nvl(d3.e_cnt,0) e_cnt03, nvl(b4.e_cnt,0)+nvl(c4.e_cnt,0)+nvl(d4.e_cnt,0) e_cnt04, nvl(b5.e_cnt,0)+nvl(c5.e_cnt,0)+nvl(d5.e_cnt,0) e_cnt05\n"+
					" from  "+
					//�������
					" (select user_id from users WHERE loan_st='1') u,\n "+
					//��ü��=���ʿ�����
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt from (select bus_id2, client_id, count(0) cnt from cont_n_view where nvl(use_yn,'Y')='Y' and car_st not in ('2','5') "+search_query+" AND client_id <> '000228' group by bus_id2, client_id, r_site) a group by bus_id2) a1, \n"+
					//�Ϲݽ�=�ű�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a, (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+) and  nvl(use_yn,'Y')='Y' and car_st in ('1','3') and rent_way_cd='1'  and fee_rent_st ='1' and car_gu='1'  "+search_query+" AND client_id <> '000228' group by bus_id2) b1, \n"+
					//�Ϲݽ�=����
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+) and  nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='1' and fee_rent_st ='1'  and  car_gu='0' "+search_query+" AND a.client_id <> '000228' group by bus_id2) b2, \n"+
					//�Ϲݽ�=����
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='1' and fee_rent_st not in ('1') "+search_query+" AND a.client_id <> '000228' group by bus_id2) b3, \n"+
					//�Ϲݽ�=����
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+) and  nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='1' and fee_rent_st not in ('1')  "+search_query+" AND a.client_id <> '000228' group by bus_id2) b4, \n"+
					//�Ϲݽ�=������
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='1' and rent_st='6' and fee_rent_st = '1' "+search_query+" AND a.client_id <> '000228' group by bus_id2) b5,\n"+
					//�⺻��=�ű�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='3' and fee_rent_st ='1' and car_gu='1' "+search_query+" AND a.client_id <> '000228' group by bus_id2) c1,\n "+
					//�⺻��=����
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='3'  and fee_rent_st ='1'  and  car_gu='0' "+search_query+" AND client_id <> '000228' group by bus_id2) c2, \n"+
					//�⺻��=����
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='3' and fee_rent_st not in ('1') "+search_query+" AND client_id <> '000228' group by bus_id2) c3, \n"+
					//�⺻��=����
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view  a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='3' and a.fee_rent_st not in ('1')  "+search_query+" AND client_id <> '000228' group by bus_id2) c4, \n"+
					//�⺻��=������
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='3' and a.rent_st='6' and a.fee_rent_st = '1' "+search_query+" AND client_id <> '000228' group by bus_id2) c5, \n"+
					//�����=�ű�
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='2' and fee_rent_st ='1' and car_gu='1' "+search_query+" AND client_id <> '000228' group by bus_id2) d1, \n"+
					//�����=����
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and  nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='2'  and fee_rent_st ='1'   and  car_gu='0' "+search_query+" AND client_id <> '000228' group by bus_id2) d2, \n"+
					//�����=����
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='2' and fee_rent_st not in ('1') "+search_query+" AND client_id <> '000228' group by bus_id2) d3, \n"+
					//�����=����
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='2' and a.fee_rent_st not in ('1')  "+search_query+" AND client_id <> '000228' group by bus_id2) d4, \n"+
					//�����=������
					" (select nvl(a.bus_id2,'999999') as user_id, count(0) cnt, count(decode(a.fee_rent_st,'1',decode( q.emp_id,'','',a.rent_l_cd))) e_cnt from cont_n_view a,  (select rent_mng_id, rent_l_cd, emp_id   from   commi   where  agnt_st='1'   and    emp_id is not null and    nvl(commi_st, '1')='1') q  where a.rent_mng_id = q.rent_mng_id(+) and a.rent_l_cd = q.rent_l_cd(+)  and nvl(a.use_yn,'Y')='Y' and a.car_st in ('1','3') and a.rent_way_cd='2' and a.rent_st='6' and a.fee_rent_st = '1' "+search_query+" AND client_id <> '000228' group by bus_id2) d5, \n"+
					" users e, code f, car_off_emp g, car_off h "+
					" where u.user_id=a1.user_id(+)\n"+
					" and u.user_id=b1.user_id(+) and u.user_id=b2.user_id(+) and u.user_id=b3.user_id(+) and u.user_id=b4.user_id(+) and u.user_id=b5.user_id(+) \n"+
					" and u.user_id=c1.user_id(+) and u.user_id=c2.user_id(+) and u.user_id=c3.user_id(+) and u.user_id=c4.user_id(+) and u.user_id=c5.user_id(+) \n"+
					" and u.user_id=d1.user_id(+) and u.user_id=d2.user_id(+) and u.user_id=d3.user_id(+) and u.user_id=d4.user_id(+) and u.user_id=d5.user_id(+) \n"+
					" and u.user_id=e.user_id and e.dept_id=f.code(+) and f.c_st='0002' and f.code<>'0000' \n"+
					" and e.sa_code=g.emp_id(+) and g.agent_id=h.car_off_id(+) \n"+	
					" ";
					
			if(dept_id.equals("0001") || dept_id.equals("0002") || dept_id.equals("0007") || dept_id.equals("0008") || dept_id.equals("0009") || dept_id.equals("0010") || dept_id.equals("0011") || dept_id.equals("0012")  || dept_id.equals("0013")  || dept_id.equals("0014")   || dept_id.equals("0015")   || dept_id.equals("0016") || dept_id.equals("0017")|| dept_id.equals("0018") ){
					query += " and e.dept_id='"+dept_id+"' and e.loan_st in ('1','2') \n";
						
			} else if(dept_id.equals("all") ){
				      query += " and  (  ( e.dept_id in ('0001','0002', '0007', '0008','0009','0010','0011', '0012', '0013','0014','0015','0016','0017','0018') and e.loan_st in ('1', '2') )  or ( e.dept_id = '1000'  ) ) \n";
		
			}else{
  					query += " and e.user_pos not in ('���','�븮','����','����','����') and e.loan_st is null"; 
	   		}	

			//������Ʈ�� ������ ������ ����� ���� '�ǿ�ö','���ο�', '�����','�̽���' e.user_id not in ('000230','000235', '000250','000252')"; 
			query += " and nvl(h.work_st,'C')='C' and nvl(h.use_yn,'Y')='Y'";  //����/��� ��� ����, �ŷ���ü

	  		
	  		query += " order by decode(e.dept_id,'0001','1','0002','2',  '1000', '5', '0014', '2', '0015', '2', '0016', '3',  decode(e.dept_id ||e.loan_st,  '00091' , '2', '00092', '1',   '00121' , '2', '00122', '1',  '00171' , '2', '00172', '1',   '00181' , '2', '00182', '1',    '00131' , '2', '00132', '1', '00071', '4',  '00072', '3',   '00081', '4',  '00082', '3',   '00101', '4',  '00102', '3',   '00111', '4',  '00112', '3',    '00013', '4',  '00132', '3')  ) , e.dept_id, 7 desc, e.enter_dt";

	
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
			System.out.println("[StatBusDatabase:getStatBusSearch_20140101]"+e);
			System.out.println("[StatBusDatabase:getStatBusSearch_20140101]"+query);
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
	 *	���ϱ��� ��ȸ(2011�� �����Ǻ���
	 */
	public Vector getStatClsSearch(String gubun, String br_id, String s_yy, String s_mm, String dept_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";
		String search_query = "";
		String search_dt = "";
		
		if(!s_yy.equals("") && s_mm.equals(""))		search_query  = " and cc.cls_dt like '"+s_yy+"%'";
		if(!s_yy.equals("") && !s_mm.equals(""))	search_query  = " and cc.cls_dt between '"+s_yy+"' and '"+s_mm+"'";
	
		query = " select car_gu, car_st, rent_way, car_st||rent_way gubun, "+
				"	sum(decode(cls_st, '1', 1, 0))     cnt0, "+
				"	sum(decode(cls_st, '1', d_cnt, 0)) cnt1, "+
				"	sum(decode(cls_st, '8', 1, 0))     cnt2, "+
				"	sum(decode(cls_st, '8', d_cnt, 0)) cnt3, "+
				"	sum(decode(cls_st, '2', 1, 0))     cnt4, "+
				"	sum(decode(cls_st, '2', d_cnt, 0)) cnt5, "+
				"	sum(decode(cls_st, '9', 1, 0))     cnt6, \n"+
				"	sum(decode(cls_st, '9', d_cnt, 0)) cnt7 \n"+
				"	from (  \n"+
				"	select a.rent_mng_id, a.rent_l_cd,  "+
				"	    decode(a.fee_rent_st, '1', decode(a.car_gu, '0', '2', '1') , '9') car_gu , a.rent_way_cd rent_way, a.car_st, "+
				"       case when c.cls_st  =  '1' then '1' "+
                "              when c.cls_st  =  '2' then '2' "+
                "              when c.cls_st  =  '8' then '8' "+
                "              when cc.cls_dt <= add_months(to_date(replace(a.rent_end_dt, '-', '')) , -1) then '9'  "+
                "              else '8' end cls_st,	"+		 	
				"       decode(b.rent_l_cd, null, 0 , 1) d_cnt   \n"+
				"	 from cont_n_view a, cont_etc b, (select * from cls_etc ) c , cls_cont cc   \n"+
				"	 where cc.cls_dt > '20101231' and a.rent_mng_id = cc.rent_mng_id(+) and a.rent_l_cd = cc.rent_l_cd(+) and a.rent_mng_id = b.grt_suc_m_id(+) and a.rent_l_cd = b.grt_suc_l_cd(+)  \n "+
				"	 and   cc.cls_st in ( '1', '2', '8' ) \n "+
				"	 and a.rent_mng_id = c.rent_mng_id(+) and a.rent_l_cd = c.rent_l_cd(+) "+ search_query+
				"	) a  \n"+
				"	group by car_gu, car_st, rent_way \n"+
				"	order by car_gu, car_st, rent_way ";

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
			System.out.println("[StatBusDatabase:getStatClsSearch]"+e);
			System.out.println("[StatBusDatabase:getStatClsSearch]"+query);
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
	 *	���ϱ��� ��ȸ(2011�� �����Ǻ��� - bm: 1->���ʿ����� 2->���������
	 */
	public Vector getStatClsSearch1(String gubun, String br_id, String s_yy, String s_mm, String bm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";
		String search_query = "";
		String search_id = "";
		String search_br_id = "";
		 
		if ( bm.equals("1") ) {
			search_id = "a.bus_id";			
		} else {
			search_id = "a.mng_id";
		}		
		
		
		if(!s_yy.equals("") && s_mm.equals(""))		search_query  = " and cc.cls_dt like '"+s_yy+"%'";
		if(!s_yy.equals("") && !s_mm.equals(""))	search_query  = " and cc.cls_dt between '"+s_yy+"' and '"+s_mm+"'";
	
		if (!br_id.equals("") ) 	search_br_id  = " and u.dept_id = '"+br_id+"'";
		
		query = " select u.dept_id, a.bus_id,  a.rent_way, u.user_nm, ROW_NUMBER() OVER (PARTITION BY u.dept_id, a.bus_id ORDER BY a.rent_way ) data_rn, "+
				"	sum(decode(cls_st, '1', 1, 0))     cnt0, "+
				"	sum(decode(cls_st, '1', d_cnt, 0)) cnt1, "+
				"	sum(decode(cls_st, '8', 1, 0))     cnt2, "+
				"	sum(decode(cls_st, '8', d_cnt, 0)) cnt3, "+
				"	sum(decode(cls_st, '2', 1, 0))     cnt4, "+
				"	sum(decode(cls_st, '2', d_cnt, 0)) cnt5, "+
				"	sum(decode(cls_st, '9', 1, 0))     cnt6, \n"+
				"	sum(decode(cls_st, '9', d_cnt, 0)) cnt7 \n"+
				"	from (  \n"+
				"	select a.rent_mng_id, a.rent_l_cd, " + search_id + " as bus_id, a.rent_way_cd rent_way,  "+		
				"       case when c.cls_st  =  '1' then '1' "+
                "              when c.cls_st  =  '2' then '2' "+
                "              when c.cls_st  =  '8' then '8' "+
                "              when cc.cls_dt <= add_months(to_date(replace(a.rent_end_dt, '-', '')) , -1) then '9'  "+
                "              else '8' end cls_st,	"+		 	
				"       decode(b.rent_l_cd, null, 0 , 1) d_cnt   \n"+
				"	 from cont_n_view a, cont_etc b, (select * from cls_etc ) c , cls_cont cc  \n"+
				"	 where cc.cls_dt > '20101231' and a.rent_mng_id = b.grt_suc_m_id(+) and a.rent_l_cd = b.grt_suc_l_cd(+)  \n "+
				"	 and a.rent_mng_id = cc.rent_mng_id(+) and a.rent_l_cd = cc.rent_l_cd(+)  \n "+
				"	 and   cc.cls_st in ( '1', '2', '8' ) \n "+
				"	 and a.rent_mng_id = c.rent_mng_id(+) and a.rent_l_cd = c.rent_l_cd(+) "+ search_query+
				"	 order by " + search_id + ", rent_way_cd ) a  , users u   \n"+
                "  where a.bus_id = u.user_id and u.use_yn = 'Y'  "+ search_br_id + "   \n"+
				"	 group by  bus_id, rent_way, dept_id, u.user_nm  \n"+
				"	 order by  u.dept_id, a.bus_id, data_rn desc, a.rent_way ";				
		
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
			System.out.println("[StatBusDatabase:getStatClsSearch1]"+e);
			System.out.println("[StatBusDatabase:getStatClsSearch1]"+query);
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
	 *	LPG���������Ȳ
	 */
	public Vector getStatLpgList(String mode, String s_yy, String s_mm, int days, int f_year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";
		String stat_st = "d";
		 		
		b_query = " select a.rent_l_cd, \n"+
				"        decode(b.rent_st||a.car_gu,'11','����','10','�縮��','12','�縮��','����') car_gu, \n"+
				"        decode(substr(d.s_st,1,1),'3','LPG����','��LPG����') s_st, \n"+
				"        decode(b.rent_st,'1',a.rent_dt,b.rent_dt) rent_dt \n"+
				" from   cont a, fee b, car_etc c, car_nm d, car_reg g, cls_cont e, fee_etc h, \n"+
				"        (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) f \n"+
				" where  a.car_st in ('1','3')  and a.client_id not in ('000228','000231') \n";

		//�Ϻ�
		if(!s_yy.equals("") && !s_mm.equals("")){

			b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+""+s_mm+"%' \n";
			stat_st = "d";

		//����
		}else if(!s_yy.equals("") && s_mm.equals("")){

			b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+"%' \n";
			stat_st = "m";

		//�⵵��
		}else if(s_yy.equals("") && s_mm.equals("")){

			stat_st = "y";
		}

		b_query += "     and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				"        and a.car_mng_id=g.car_mng_id(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.cls_st,'0') not in ('7','10')  \n"+
				"        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+) \n"+
				"        and a.rent_mng_id=f.rent_mng_id(+) and a.reg_dt=f.reg_dt(+) \n"+
				"        and case when f.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),f.reg_dt)  then '' else f.rent_l_cd end is null \n"+
				" ";				

		//����
		if(mode.equals("1")) 		b_query += " and b.rent_st = '1' and a.car_gu = '1' \n";

		//�縮��+�߰���
		if(mode.equals("2")) 		b_query += " and b.rent_st = '1' and a.car_gu <> '1' \n";

		//����
		if(mode.equals("3")) 		b_query += " and b.rent_st <> '1' \n";

		
		query = " select car_gu, s_st, \n";


		if(stat_st.equals("d")){
			for (int i = 0 ; i < days ; i++){
				query += " count(decode(to_number(substr(rent_dt,7,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("m")){
			for (int i = 0 ; i < 12 ; i++){
				query += " count(decode(to_number(substr(rent_dt,5,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("y")){
			for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
				query += " count(decode(to_number(substr(rent_dt,1,4)),"+(i)+",rent_l_cd)) cnt"+(i-2000)+", \n";	
			}
		}


		query += " count(rent_l_cd) cnt0 \n"+
				" from   ("+b_query+") \n"+
				" group by car_gu, s_st \n"+
				" order by decode(s_st,'LPG����','0','1')\n"+
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
			System.out.println("[StatBusDatabase:getStatLpgList]"+e);
			System.out.println("[StatBusDatabase:getStatLpgList]"+query);
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
	 *	LPG���������Ȳ
	 */
	public Vector getStatLpgRentwayList(String lpg_yn, String mode, String s_yy, String s_mm, int days, int f_year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";
		String stat_st = "d";
		 		
		b_query = " select a.rent_l_cd, \n"+
				"        decode(b.rent_st||a.car_gu,'11','����','10','�縮��','12','�縮��','����') car_gu, \n"+
				"        decode(substr(d.s_st,1,1),'3','LPG����','��LPG����') s_st, \n"+
				"        decode(b.rent_way,'1','�Ϲݽ�','�⺻��') rent_way, \n"+
				"        decode(b.rent_st,'1',a.rent_dt,b.rent_dt) rent_dt \n"+
				" from   cont a, fee b, car_etc c, car_nm d, car_reg g, cls_cont e, fee_etc h, \n"+
				"        (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) f \n"+
				" where  a.car_st in ('1','3')  and a.client_id not in ('000228','000231') \n";

		//LPG��������
		if(lpg_yn.equals("Y")) 		b_query += " and decode(substr(d.s_st,1,1),'3','LPG����','��LPG����') = 'LPG����' \n";
		else						b_query += " and decode(substr(d.s_st,1,1),'3','LPG����','��LPG����') = '��LPG����' \n";


		//�Ϻ�
		if(!s_yy.equals("") && !s_mm.equals("")){

			b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+""+s_mm+"%' \n";
			stat_st = "d";

		//����
		}else if(!s_yy.equals("") && s_mm.equals("")){

			b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+"%' \n";
			stat_st = "m";

		//�⵵��
		}else if(s_yy.equals("") && s_mm.equals("")){

			stat_st = "y";
		}

		b_query += "     and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				"        and a.car_mng_id=g.car_mng_id(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.cls_st,'0') not in ('7','10')  \n"+
				"        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+) \n"+
				"        and a.rent_mng_id=f.rent_mng_id(+) and a.reg_dt=f.reg_dt(+) \n"+
				"        and case when f.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),f.reg_dt)  then '' else f.rent_l_cd end is null \n"+
				" ";				

		//����
		if(mode.equals("1")) 		b_query += " and b.rent_st = '1' and a.car_gu = '1' \n";

		//�縮��+�߰���
		if(mode.equals("2")) 		b_query += " and b.rent_st = '1' and a.car_gu <> '1' \n";

		//����
		if(mode.equals("3")) 		b_query += " and b.rent_st <> '1' \n";

		
		query = " select car_gu, rent_way, \n";


		if(stat_st.equals("d")){
			for (int i = 0 ; i < days ; i++){
				query += " count(decode(to_number(substr(rent_dt,7,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("m")){
			for (int i = 0 ; i < 12 ; i++){
				query += " count(decode(to_number(substr(rent_dt,5,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("y")){
			for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
				query += " count(decode(to_number(substr(rent_dt,1,4)),"+(i)+",rent_l_cd)) cnt"+(i-2000)+", \n";	
			}
		}


		query += " count(rent_l_cd) cnt0 \n"+
				" from   ("+b_query+") \n"+
				" group by car_gu, rent_way \n"+
				" order by decode(rent_way,'�Ϲݽ�','0','1')\n"+
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
			System.out.println("[StatBusDatabase:getStatLpgRentwayList]"+e);
			System.out.println("[StatBusDatabase:getStatLpgRentwayList]"+query);
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
	 *	������Ʈ�������Ȳ
	 */
	public Vector getStatBusRootList(String mode, String s_yy, String s_mm, int days, int f_year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";
		String stat_st = "d";
		 		
		b_query = " select a.rent_l_cd, \n"+
				"        decode(b.rent_st||a.car_gu,'11','����','10','�縮��','12','�縮��','����') car_gu, \n"+
				"        decode(substr(d.s_st,1,1),'3','LPG����','��LPG����') s_st, \n"+
				"        decode(b.rent_st,'1',decode(a.rent_st,'1','�ű�','3','����','4','����','�ű�'),'') rent_st, \n"+
				"        decode(b.rent_st,'1',decode(a.bus_st,'1','���ͳ�,��ȭ���','2','�������','3','��ü�Ұ�,������ü','4','���ͳ�,��ȭ���','5','���ͳ�,��ȭ���','6','��ü�Ұ�,������ü','���ͳ�,��ȭ���'),'') bus_st1, \n"+
				"        decode(b.rent_st,'1',decode(a.bus_st,'2','�������','�ڷ¿���'),'') bus_st2, \n"+
				"        decode(b.rent_st,'1',a.rent_dt,b.rent_dt) rent_dt \n"+
				" from   cont a, fee b, car_etc c, car_nm d, car_reg g, cls_cont e, fee_etc h, \n"+
				"        (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) f \n"+
				" where  a.car_st in ('1','3')  and a.client_id not in ('000228','000231') \n";

		//�Ϻ�
		if(!s_yy.equals("") && !s_mm.equals("")){

			b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+""+s_mm+"%' \n";
			stat_st = "d";

		//����
		}else if(!s_yy.equals("") && s_mm.equals("")){

			b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+"%' \n";
			stat_st = "m";

		//�⵵��
		}else if(s_yy.equals("") && s_mm.equals("")){

			stat_st = "y";
		}

		b_query += "     and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				"        and a.car_mng_id=g.car_mng_id(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.cls_st,'0') not in ('7','10')  \n"+
				"        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+) \n"+
				"        and a.rent_mng_id=f.rent_mng_id(+) and a.reg_dt=f.reg_dt(+) \n"+
				"        and case when f.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),f.reg_dt)  then '' else f.rent_l_cd end is null \n"+
				" ";				

		//����
		if(mode.equals("1")||mode.equals("2")||mode.equals("3")) 		b_query += " and b.rent_st = '1' and a.car_gu = '1' \n";

		//�縮��+�߰���
		if(mode.equals("4")||mode.equals("5")) 							b_query += " and b.rent_st = '1' and a.car_gu <> '1' \n";

		//����
		if(mode.equals("6")) 											b_query += " and b.rent_st <> '1' \n";


		//����/�縮��-�ű�
		query = " select car_gu, rent_st, bus_st1, \n";

		//����,����
		if(mode.equals("2")||mode.equals("3"))	query = " select car_gu, rent_st, bus_st2, \n";

		//�縮��-����,����, ����
		if(mode.equals("5")||mode.equals("6"))	query = " select car_gu, rent_st, \n";


		if(stat_st.equals("d")){
			for (int i = 0 ; i < days ; i++){
				query += " count(decode(to_number(substr(rent_dt,7,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("m")){
			for (int i = 0 ; i < 12 ; i++){
				query += " count(decode(to_number(substr(rent_dt,5,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("y")){
			for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
				query += " count(decode(to_number(substr(rent_dt,1,4)),"+(i)+",rent_l_cd)) cnt"+(i-2000)+", \n";	
			}
		}


		if(mode.equals("1")||mode.equals("4")){
			query += " count(rent_l_cd) cnt0 \n"+
					" from   ("+b_query+") \n"+
					" where  rent_st='�ű�' \n"+
		            " group by car_gu, rent_st, bus_st1 \n"+
					" order by decode(bus_st1,'�������','1','���ͳ�,��ȭ���','2','3')\n"+
					" ";				
		}


		if(mode.equals("2")){
			query += " count(rent_l_cd) cnt0 \n"+
					" from   ("+b_query+") \n"+
					" where  rent_st='����' \n"+
		            " group by car_gu, rent_st, bus_st2 \n"+
					" order by decode(bus_st2,'�������','1','2')\n"+
					" ";				
		}

		if(mode.equals("3")){
			query += " count(rent_l_cd) cnt0 \n"+
					" from   ("+b_query+") \n"+
					" where  rent_st='����' \n"+
		            " group by car_gu, rent_st, bus_st2 \n"+
					" order by decode(bus_st2,'�������','1','2')\n"+
					" ";				
		}

		if(mode.equals("5")){
			query += " count(rent_l_cd) cnt0 \n"+
					" from   ("+b_query+") \n"+
					" where  rent_st<>'�ű�' \n"+
		            " group by car_gu, rent_st \n"+
					" order by decode(rent_st,'����','1','����','2','3')\n"+
					" ";				
		}

		if(mode.equals("6")){
			query += " count(rent_l_cd) cnt0 \n"+
					" from   ("+b_query+") \n"+
		            " group by car_gu, rent_st \n"+
					" order by decode(rent_st,'����','1','����','2','3')\n"+
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
			System.out.println("[StatBusDatabase:getStatBusRootList]"+e);
			System.out.println("[StatBusDatabase:getStatBusRootList]"+query);
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
	 *	������Ʈ�������Ȳ
	 */
	public Vector getStatBusRootList(String mode, String s_yy, String s_mm, int days, int f_year, String gubun1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";
		String stat_st = "d";
		 		
		b_query = " select a.rent_l_cd, \n"+
				"        decode(b.rent_st||a.car_gu,'11','����','10','�縮��','12','�縮��','����') car_gu, \n"+
				"        decode(substr(d.s_st,1,1),'3','LPG����','��LPG����') s_st, \n"+
				"        decode(b.rent_st,'1',decode(a.rent_st,'1','�ű�','3','����','4','����','�ű�'),'') rent_st, \n"+
				"        decode(b.rent_st,'1',decode(a.bus_st,'7','������Ʈ','1','��ȭ���,���ͳ�','2','�������','3','��ü�Ұ�,������ü','4','��ȭ���,���ͳ�','5','��ȭ���,���ͳ�','6','��ü�Ұ�,������ü','8','��ȭ���,���ͳ�','��ȭ���,���ͳ�'),'') bus_st1, \n"+
				"        decode(b.rent_st,'1',decode(a.bus_st,'2','�������','7','������Ʈ','�ڷ¿���'),'') bus_st2, \n"+
				"        decode(b.rent_st,'1',a.rent_dt,b.rent_dt) rent_dt \n"+
				" from   cont a, fee b, car_etc c, car_nm d, car_reg g, cls_cont e, fee_etc h, \n"+
				"        (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) f \n"+
				" where  a.car_st in ('1','3')  and a.client_id not in ('000228','000231') \n";

		//�Ϻ�
		if(!s_yy.equals("") && !s_mm.equals("")){

			b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+""+s_mm+"%' \n";
			stat_st = "d";

		//����
		}else if(!s_yy.equals("") && s_mm.equals("")){

			b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+"%' \n";
			stat_st = "m";

		//�⵵��
		}else if(s_yy.equals("") && s_mm.equals("")){

			stat_st = "y";
		}

		b_query += "     and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				"        and a.car_mng_id=g.car_mng_id(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.cls_st,'0') not in ('7','10')  \n"+
				"        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+) \n"+
				"        and a.rent_mng_id=f.rent_mng_id(+) and a.reg_dt=f.reg_dt(+) \n"+
				"        and case when f.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),f.reg_dt)  then '' else f.rent_l_cd end is null \n"+
				" ";				
		if(gubun1.equals("0001")) 											b_query += " and d.car_comp_id = '0001' \n";
		else if(gubun1.equals("0002"))										b_query += " and d.car_comp_id = '0002' \n";
		else if(gubun1.equals("0003"))										b_query += " and d.car_comp_id = '0003' \n";
		else if(gubun1.equals("0004"))										b_query += " and d.car_comp_id = '0004' \n";
		else if(gubun1.equals("0005"))										b_query += " and d.car_comp_id = '0005' \n";
		else if(gubun1.equals("0006"))										b_query += " and nvl(d.car_comp_id,'n') not in('0001','0002','0003','0004','0005') \n";
		/*����gubun����..*/
		if(gubun1.equals("1")) 											b_query += " and d.car_comp_id = '0001' \n";
		if(gubun1.equals("2")) 											b_query += " and d.car_comp_id <>'0001' \n";

		//����
		if(mode.equals("1")||mode.equals("2")||mode.equals("3")) 		b_query += " and b.rent_st = '1' and a.car_gu = '1' \n";

		//�縮��+�߰���
		if(mode.equals("4")||mode.equals("5")) 							b_query += " and b.rent_st = '1' and a.car_gu <> '1' \n";

		//����
		if(mode.equals("6")) 											b_query += " and b.rent_st <> '1' \n";


		//����/�縮��-�ű�
		query = " select car_gu, rent_st, bus_st1, \n";

		//����,����
		if(mode.equals("2")||mode.equals("3"))	query = " select car_gu, rent_st, bus_st2, \n";

		//�縮��-����,����, ����
		if(mode.equals("5")||mode.equals("6"))	query = " select car_gu, rent_st, \n";


		if(stat_st.equals("d")){
			for (int i = 0 ; i < days ; i++){
				query += " count(decode(to_number(substr(rent_dt,7,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("m")){
			for (int i = 0 ; i < 12 ; i++){
				query += " count(decode(to_number(substr(rent_dt,5,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("y")){
			for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
				query += " count(decode(to_number(substr(rent_dt,1,4)),"+(i)+",rent_l_cd)) cnt"+(i-2000)+", \n";	
			}
		}


		if(mode.equals("1")||mode.equals("4")){
			query += " count(rent_l_cd) cnt0 \n"+
					" from   ("+b_query+") \n"+
					" where  rent_st='�ű�' \n"+
		            " group by car_gu, rent_st, bus_st1 \n"+
					" order by decode(bus_st1,'������Ʈ',1,'�������','2','��ȭ���,���ͳ�','3','6')\n"+
					" ";				
		}


		if(mode.equals("2")){
			query += " count(rent_l_cd) cnt0 \n"+
					" from   ("+b_query+") \n"+
					" where  rent_st='����' \n"+
		            " group by car_gu, rent_st, bus_st2 \n"+
					" order by decode(bus_st2,'������Ʈ','1','�������','2','3')\n"+
					" ";				
		}

		if(mode.equals("3")){
			query += " count(rent_l_cd) cnt0 \n"+
					" from   ("+b_query+") \n"+
					" where  rent_st='����' \n"+
		            " group by car_gu, rent_st, bus_st2 \n"+
					" order by decode(bus_st2,'������Ʈ','1','�������','2','3')\n"+
					" ";				
		}

		if(mode.equals("5")){
			query += " count(rent_l_cd) cnt0 \n"+
					" from   ("+b_query+") \n"+
					" where  rent_st<>'�ű�' \n"+
		            " group by car_gu, rent_st \n"+
					" order by decode(rent_st,'����','1','����','2','3')\n"+
					" ";				
		}

		if(mode.equals("6")){
			query += " count(rent_l_cd) cnt0 \n"+
					" from   ("+b_query+") \n"+
		            " group by car_gu, rent_st \n"+
					" order by decode(rent_st,'����','1','����','2','3')\n"+
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
			System.out.println("[StatBusDatabase:getStatBusRootList]"+e);
			System.out.println("[StatBusDatabase:getStatBusRootList]"+query);
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
	 *	������Ʈ�������Ȳ ���θ���Ʈ
	 */
	public Vector getStatBusRootListSub(String mode, String s_yy, String s_mm, int days, int f_year, String gubun1, String car_gu, String rent_st, String bus_st1)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";
		String stat_st = "d";
		 		
		b_query = " select a.rent_l_cd, \n"+
				"        decode(b.rent_st||a.car_gu,'11','����','10','�縮��','12','�縮��','����') car_gu, \n"+
				"        decode(substr(d.s_st,1,1),'3','LPG����','��LPG����') s_st, \n"+
				"        decode(b.rent_st,'1',decode(a.rent_st,'1','�ű�','3','����','4','����','�ű�'),'') rent_st, \n"+
				"        decode(a.bus_st, '1','���ͳ�','2','�������','3','��ü�Ұ�','4','ī�޷α�','5','��ȭ���','6','������ü', '7', '������Ʈ','8','�����') bus_st, \n"+
				"        decode(b.rent_st,'1',decode(a.bus_st,'7','������Ʈ','1','��ȭ���,���ͳ�','2','�������','3','��ü�Ұ�,������ü','4','��ȭ���,���ͳ�','5','��ȭ���,���ͳ�','6','��ü�Ұ�,������ü','8','��ȭ���,���ͳ�','��ȭ���,���ͳ�'),'') bus_st1, \n"+
				"        decode(b.rent_st,'1',decode(a.bus_st,'2','�������','7','������Ʈ','�ڷ¿���'),'') bus_st2, \n"+
				"        decode(b.rent_st,'1',a.rent_dt,b.rent_dt) rent_dt, \n"+
				"        g.car_no, i.firm_nm, j.car_nm, d.car_name "+
				" from   cont a, fee b, car_etc c, car_nm d, car_mng j, car_reg g, cls_cont e, fee_etc h, client i, \n"+
				"        (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) f \n"+
				" where  a.car_st in ('1','3')  and a.client_id not in ('000228','000231') \n";

		//�Ϻ�
		if(!s_yy.equals("") && !s_mm.equals("")){

			b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+""+s_mm+"%' \n";
			stat_st = "d";

		//����
		}else if(!s_yy.equals("") && s_mm.equals("")){

			b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+"%' \n";
			stat_st = "m";

		//�⵵��
		}else if(s_yy.equals("") && s_mm.equals("")){

			stat_st = "y";
		}

		b_query += "     and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				"        and d.car_comp_id=j.car_comp_id and d.car_cd=j.code \n"+
				"        and a.car_mng_id=g.car_mng_id(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.cls_st,'0') not in ('7','10')  \n"+
				"        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+) \n"+
				"        and a.client_id=i.client_id "+
				"        and a.rent_mng_id=f.rent_mng_id(+) and a.reg_dt=f.reg_dt(+) \n"+
				"        and case when f.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),f.reg_dt)  then '' else f.rent_l_cd end is null \n"+
				" ";				
		if(gubun1.equals("0001")) 											b_query += " and d.car_comp_id = '0001' \n";
		else if(gubun1.equals("0002"))										b_query += " and d.car_comp_id = '0002' \n";
		else if(gubun1.equals("0003"))										b_query += " and d.car_comp_id = '0003' \n";
		else if(gubun1.equals("0004"))										b_query += " and d.car_comp_id = '0004' \n";
		else if(gubun1.equals("0005"))										b_query += " and d.car_comp_id = '0005' \n";
		else if(gubun1.equals("0006"))										b_query += " and nvl(d.car_comp_id,'n') not in('0001','0002','0003','0004','0005') \n";
		/*����gubun����..*/
		if(gubun1.equals("1")) 											b_query += " and d.car_comp_id = '0001' \n";
		if(gubun1.equals("2")) 											b_query += " and d.car_comp_id <>'0001' \n";

		//����
		if(mode.equals("1")||mode.equals("2")||mode.equals("3")) 		b_query += " and b.rent_st = '1' and a.car_gu = '1' \n";

		//�縮��+�߰���
		if(mode.equals("4")||mode.equals("5")) 							b_query += " and b.rent_st = '1' and a.car_gu <> '1' \n";

		//����
		if(mode.equals("6")) 											b_query += " and b.rent_st <> '1' \n";


		query = " select * from ( "+b_query+" ) where car_gu='"+car_gu+"' and rent_st='"+rent_st+"' and bus_st1='"+bus_st1+"' order by rent_dt, bus_st  ";	


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
			System.out.println("[StatBusDatabase:getStatBusRootListSub]"+e);
			System.out.println("[StatBusDatabase:getStatBusRootListSub]"+query);
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
	 *	������Ʈ�������Ȳ -> �ܺα����û���� Ȱ��
	 */
	public Vector getStatBusRootListOTSearch(String mode, String s_yy, String s_mm, int days, int f_year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";
		String stat_st = "d";
		 		
		b_query = " select a.rent_l_cd, \n"+
				"        decode(b.rent_st||a.car_gu,'11','����','10','�縮��','12','�縮��','����') car_gu, \n"+
				"        decode(substr(d.s_st,1,1),'3','LPG����','��LPG����') s_st, \n"+
				"        decode(b.rent_st,'1',decode(a.rent_st,'1','�ű�','3','����','4','����','�ű�'),'') rent_st, \n"+
				"        decode(b.rent_st,'1',decode(a.bus_st,'1','���ͳ�,��ȭ���','2','�������','3','��ü�Ұ�,������ü','4','���ͳ�,��ȭ���','5','���ͳ�,��ȭ���','6','��ü�Ұ�,������ü','���ͳ�,��ȭ���'),'') bus_st1, \n"+
				"        decode(b.rent_st,'1',decode(a.bus_st,'2','�������','�ڷ¿���'),'') bus_st2, \n"+
				"        decode(b.rent_st,'1',a.rent_dt,b.rent_dt) rent_dt, \n"+
				"        ((b.fee_s_amt*b.con_mon)+b.pp_s_amt) as cont_amt \n"+
				" from   cont a, fee b, car_etc c, car_nm d, car_reg g, cls_cont e, fee_etc h, \n"+
				"        (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) f, \n"+
				"        users i "+
				" where  a.car_st in ('1','3')  and a.client_id not in ('000228','000231') \n";

		//�Ϻ�
		if(!s_yy.equals("") && !s_mm.equals("")){

			b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+""+s_mm+"%' \n";
			stat_st = "d";

		//����
		}else if(!s_yy.equals("") && s_mm.equals("")){

			b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+"%' \n";
			stat_st = "m";

		//�⵵��
		}else if(s_yy.equals("") && s_mm.equals("")){

			stat_st = "y";
		}

		b_query += "     and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				"        and a.car_mng_id=g.car_mng_id(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.cls_st,'0') not in ('7','10')  \n"+
				"        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+) \n"+
				"        and a.rent_mng_id=f.rent_mng_id(+) and a.reg_dt=f.reg_dt(+) \n"+
				"        and case when f.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),f.reg_dt)  then '' else f.rent_l_cd end is null \n"+
				"        and decode(b.rent_st,'1',a.bus_id,b.ext_agnt)=i.user_id "+
				" ";				


		//2�� ����
		b_query += " and i.loan_st = '2' \n";


		//����
		if(mode.equals("1")||mode.equals("2")||mode.equals("3")) 		b_query += " and b.rent_st = '1' and a.car_gu = '1' \n";

		//�縮��+�߰���
		if(mode.equals("4")||mode.equals("5")) 							b_query += " and b.rent_st = '1' and a.car_gu <> '1' \n";

		//����
		if(mode.equals("6")) 											b_query += " and b.rent_st <> '1' \n";


		//����/�縮��-�ű�
		query = " select car_gu, rent_st, bus_st1, \n";

		//����,����
		if(mode.equals("2")||mode.equals("3"))	query = " select car_gu, rent_st, bus_st2, \n";

		//�縮��-����,����, ����
		if(mode.equals("5")||mode.equals("6"))	query = " select car_gu, rent_st, \n";


		if(stat_st.equals("d")){
			for (int i = 0 ; i < days ; i++){
				query += " count(decode(to_number(substr(rent_dt,7,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("m")){
			for (int i = 0 ; i < 12 ; i++){
				query += " count(decode(to_number(substr(rent_dt,5,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("y")){
			for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
				query += " count(decode(to_number(substr(rent_dt,1,4)),"+(i)+",rent_l_cd)) cnt"+(i-2000)+", \n";	
			}
		}


		if(mode.equals("1")||mode.equals("4")){
			query += " count(rent_l_cd) cnt0 \n"+
					" from   ("+b_query+") \n"+
					" where  rent_st='�ű�' \n"+
		            " group by car_gu, rent_st, bus_st1 \n"+
					" order by decode(bus_st1,'�������','1','���ͳ�,��ȭ���','2','3')\n"+
					" ";				
		}


		if(mode.equals("2")){
			query += " count(rent_l_cd) cnt0 \n"+
					" from   ("+b_query+") \n"+
					" where  rent_st='����' \n"+
		            " group by car_gu, rent_st, bus_st2 \n"+
					" order by decode(bus_st2,'�������','1','2')\n"+
					" ";				
		}

		if(mode.equals("3")){
			query += " count(rent_l_cd) cnt0 \n"+
					" from   ("+b_query+") \n"+
					" where  rent_st='����' \n"+
		            " group by car_gu, rent_st, bus_st2 \n"+
					" order by decode(bus_st2,'�������','1','2')\n"+
					" ";				
		}

		if(mode.equals("5")){
			query += " count(rent_l_cd) cnt0 \n"+
					" from   ("+b_query+") \n"+
					" where  rent_st<>'�ű�' \n"+
		            " group by car_gu, rent_st \n"+
					" order by decode(rent_st,'����','1','����','2','3')\n"+
					" ";				
		}

		if(mode.equals("6")){
			query += " count(rent_l_cd) cnt0 \n"+
					" from   ("+b_query+") \n"+
		            " group by car_gu, rent_st \n"+
					" order by decode(rent_st,'����','1','����','2','3')\n"+
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
			System.out.println("[StatBusDatabase:getStatBusRootListOTSearch]"+e);
			System.out.println("[StatBusDatabase:getStatBusRootListOTSearch]"+query);
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
	 *	�����������Ȳ
	 */
	public Vector getStatRentCarList(String mode, String s_yy, String s_mm, int days, int f_year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";
		String stat_st = "d";
		 		
		b_query = " select a.rent_l_cd, \n"+
				"        decode(b.rent_st||a.car_gu,'11','����','10','�縮��','12','�縮��','����') car_gu, \n"+
				"        decode(a.car_st,'1','��Ʈ','3','����') car_st, \n"+
				"        decode(d.s_st, '101','100', '409','100', '102','112', '105','104', decode(substr(d.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', d.s_st)) s_st, \n"+
				"        decode(b.rent_st,'1',a.rent_dt,b.rent_dt) rent_dt \n"+
				" from   cont a, fee b, car_etc c, car_nm d, car_reg g, cls_cont e, fee_etc h, \n"+
				"        (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) f \n"+
				" where  a.car_st in ('1','3')  and a.client_id not in ('000228','000231') \n";

		//�Ϻ�
		if(!s_yy.equals("") && !s_mm.equals("")){

			b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+""+s_mm+"%' \n";
			stat_st = "d";

		//����
		}else if(!s_yy.equals("") && s_mm.equals("")){

			b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+"%' \n";
			stat_st = "m";

		//�⵵��
		}else if(s_yy.equals("") && s_mm.equals("")){

			stat_st = "y";
		}

		b_query += "     and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				"        and a.car_mng_id=g.car_mng_id(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.cls_st,'0') not in ('7','10')  \n"+
				"        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+) \n"+
				"        and a.rent_mng_id=f.rent_mng_id(+) and a.reg_dt=f.reg_dt(+) \n"+
				"        and case when f.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),f.reg_dt)  then '' else f.rent_l_cd end is null \n"+
				" ";				

		//����
		if(mode.equals("1")||mode.equals("2")) 		b_query += " and b.rent_st = '1' and a.car_gu = '1' \n";

		//�縮��+�߰���
		if(mode.equals("3")||mode.equals("4"))		b_query += " and b.rent_st = '1' and a.car_gu <> '1' \n";

		//����
		if(mode.equals("5")||mode.equals("6"))		b_query += " and b.rent_st <> '1' \n";


		//����/�縮��-��Ʈ
		query = " select car_gu, car_st, s_st, \n";


		if(stat_st.equals("d")){
			for (int i = 0 ; i < days ; i++){
				query += " count(decode(to_number(substr(rent_dt,7,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("m")){
			for (int i = 0 ; i < 12 ; i++){
				query += " count(decode(to_number(substr(rent_dt,5,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("y")){
			for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
				query += " count(decode(to_number(substr(rent_dt,1,4)),"+(i)+",rent_l_cd)) cnt"+(i-2000)+", \n";	
			}
		}

		query += " count(rent_l_cd) cnt0 \n"+
				 " from   ("+b_query+") \n";


		//��Ʈ
		if(mode.equals("1")||mode.equals("3")||mode.equals("5")){
			query += " where  car_st='��Ʈ' ";				
		}

		//����
		if(mode.equals("2")||mode.equals("4")||mode.equals("6")){
			query += " where  car_st='����' and s_st not in ('300','301','302') ";				
		}
				
		query += " group by car_gu, car_st, s_st \n"+
				 " order by decode(s_st, '300',0, '301',1, '302',2, '100',3, '409',3, '112',4, '103',5, '104',6, '401',7, '701',8, '801',9)\n"+
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
			System.out.println("[StatBusDatabase:getStatRentCarList]"+e);
			System.out.println("[StatBusDatabase:getStatRentCarList]"+query);
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
	 *	���ͳ������������Ȳ
	 */
	public Vector getStatRentCarNmEList(String mode, String s_yy, String s_mm, int days, int f_year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";
		String stat_st = "d";
		 		
		b_query = " select a.rent_l_cd, \n"+
				"        decode(b.rent_st||a.car_gu,'11','����','10','�縮��','12','�縮��','����') car_gu, \n"+
				"        decode(a.car_st,'1','��Ʈ','3','����') car_st, \n"+
				"        decode(d.s_st, '101','100', '409','100', '102','112', '105','104', decode(substr(d.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', d.s_st)) s_st, \n"+
				"        decode(b.rent_st,'1',a.rent_dt,b.rent_dt) rent_dt, \n"+
				"        m.car_nm \n"+
				" from   cont a, fee b, car_etc c, car_nm d, car_mng m, car_reg g, cls_cont e, fee_etc h, \n"+
				"        (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) f \n"+
				" where  a.car_st in ('1','3') and a.client_id not in ('000228','000231') and a.bus_st not in ('2','3','6','7') and a.rent_st not in ('3','4') \n";

		//�Ϻ�
		if(!s_yy.equals("") && !s_mm.equals("")){

			b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+""+s_mm+"%' \n";
			stat_st = "d";

		//����
		}else if(!s_yy.equals("") && s_mm.equals("")){

			b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+"%' \n";
			stat_st = "m";

		//�⵵��
		}else if(s_yy.equals("") && s_mm.equals("")){

			stat_st = "y";
		}

		b_query += "     and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				"        and d.car_comp_id=m.car_comp_id and d.car_cd=m.code \n"+
				"        and a.car_mng_id=g.car_mng_id(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.cls_st,'0') not in ('7','10')  \n"+
				"        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+) \n"+
				"        and a.rent_mng_id=f.rent_mng_id(+) and a.reg_dt=f.reg_dt(+) \n"+
				"        and case when f.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),f.reg_dt)  then '' else f.rent_l_cd end is null \n"+
				" ";				

		//����
		if(mode.equals("1")||mode.equals("2")) 		b_query += " and b.rent_st = '1' and a.car_gu = '1' \n";

		//�縮��+�߰���
		if(mode.equals("3")||mode.equals("4"))		b_query += " and b.rent_st = '1' and a.car_gu <> '1' \n";

		//����
		//if(mode.equals("5")||mode.equals("6"))		b_query += " and b.rent_st <> '1' \n";


		//����/�縮��-��Ʈ
		query = " select car_gu, car_st, s_st, car_nm, \n";


		if(stat_st.equals("d")){
			for (int i = 0 ; i < days ; i++){
				query += " count(decode(to_number(substr(rent_dt,7,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("m")){
			for (int i = 0 ; i < 12 ; i++){
				query += " count(decode(to_number(substr(rent_dt,5,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("y")){
			for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
				query += " count(decode(to_number(substr(rent_dt,1,4)),"+(i)+",rent_l_cd)) cnt"+(i-2000)+", \n";	
			}
		}

		query += " count(rent_l_cd) cnt0 \n"+
				 " from   ("+b_query+") \n";


		//��Ʈ
		if(mode.equals("1")||mode.equals("3")||mode.equals("5")){
			query += " where  car_st='��Ʈ'  \n";				
		}

		//����
		if(mode.equals("2")||mode.equals("4")||mode.equals("6")){
			query += " where  car_st='����' and s_st not in ('300','301','302')  \n";				
		}
				
		query += " group by car_gu, car_st, s_st, car_nm \n"+
				 " order by decode(s_st, '300',0, '301',1, '302',2, '100',3, '409',3, '112',4, '103',5, '104',6, '401',7, '701',8, '801',9), car_nm \n"+
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
			System.out.println("[StatBusDatabase:getStatRentCarNmEList]"+e);
			System.out.println("[StatBusDatabase:getStatRentCarNmEList]"+query);
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
	 *	���������������Ȳ
	 */
	public Vector getStatRentCarNmList(String mode, String s_yy, String s_mm, int days, int f_year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";
		String stat_st = "d";
		 		
		b_query = " select a.rent_l_cd, \n"+
				"        decode(b.rent_st||a.car_gu,'11','����','10','�縮��','12','�縮��','����') car_gu, \n"+
				"        decode(a.car_st,'1','��Ʈ','3','����') car_st, \n"+
				"        decode(d.s_st, '101','100', '409','100', '102','112', '105','104', decode(substr(d.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', d.s_st)) s_st, \n"+
				"        decode(b.rent_st,'1',a.rent_dt,b.rent_dt) rent_dt, \n"+
				"        m.car_nm \n"+
				" from   cont a, fee b, car_etc c, car_nm d, car_mng m, car_reg g, cls_cont e, fee_etc h, \n"+
				"        (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) f \n"+
				" where  a.car_st in ('1','3')  and a.client_id not in ('000228','000231')\n";

		//�Ϻ�
		if(!s_yy.equals("") && !s_mm.equals("")){

			b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+""+s_mm+"%' \n";
			stat_st = "d";

		//����
		}else if(!s_yy.equals("") && s_mm.equals("")){

			b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+"%' \n";
			stat_st = "m";

		//�⵵��
		}else if(s_yy.equals("") && s_mm.equals("")){

			stat_st = "y";
		}

		b_query += "     and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				"        and d.car_comp_id=m.car_comp_id and d.car_cd=m.code \n"+
				"        and a.car_mng_id=g.car_mng_id(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.cls_st,'0') not in ('7','10')  \n"+
				"        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+) \n"+
				"        and a.rent_mng_id=f.rent_mng_id(+) and a.reg_dt=f.reg_dt(+) \n"+
				"        and case when f.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),f.reg_dt)  then '' else f.rent_l_cd end is null \n"+
				" ";				

		//����
		if(mode.equals("1")||mode.equals("2")) 		b_query += " and b.rent_st = '1' and a.car_gu = '1' \n";

		//�縮��+�߰���
		if(mode.equals("3")||mode.equals("4"))		b_query += " and b.rent_st = '1' and a.car_gu <> '1' \n";

		//����
		if(mode.equals("5")||mode.equals("6"))		b_query += " and b.rent_st <> '1' \n";


		//����/�縮��-��Ʈ
		query = " select car_gu, car_st, s_st, car_nm, \n";


		if(stat_st.equals("d")){
			for (int i = 0 ; i < days ; i++){
				query += " count(decode(to_number(substr(rent_dt,7,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("m")){
			for (int i = 0 ; i < 12 ; i++){
				query += " count(decode(to_number(substr(rent_dt,5,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("y")){
			for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
				query += " count(decode(to_number(substr(rent_dt,1,4)),"+(i)+",rent_l_cd)) cnt"+(i-2000)+", \n";	
			}
		}

		query += " count(rent_l_cd) cnt0 \n"+
				 " from   ("+b_query+") \n";


		//��Ʈ
		if(mode.equals("1")||mode.equals("3")||mode.equals("5")){
			query += " where  car_st='��Ʈ'  \n";				
		}

		//����
		if(mode.equals("2")||mode.equals("4")||mode.equals("6")){
			query += " where  car_st='����' and s_st not in ('300','301','302')  \n";				
		}
				
		query += " group by car_gu, car_st, s_st, car_nm \n"+
				 " order by decode(s_st, '300',0, '301',1, '302',2, '100',3, '409',3, '112',4, '103',5, '104',6, '401',7, '701',8, '801',9), car_nm \n"+
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
			System.out.println("[StatBusDatabase:getStatRentCarNmList]"+e);
			System.out.println("[StatBusDatabase:getStatRentCarNmList]"+query);
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
	 *	�μ��������Ȳ
	 */
	public Vector getStatDeptList(String mode, String gubun1, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";
		String stat_st = "d";
		 		
		b_query = " select a.rent_l_cd, \n"+
				"        decode(b.rent_st||a.car_gu,'11','����','10','�縮��','12','�縮��','����') car_gu, \n"+
				"        decode(b.rent_way,'1','�Ϲݽ�','�⺻��') rent_way, \n"+
				"        decode(b.rent_st,'1',a.rent_dt,b.rent_dt) rent_dt, \n"+
				"        i.br_id, i.dept_id \n"+
				" from   cont a, fee b, car_etc c, car_nm d, car_reg g, cls_cont e, fee_etc h, \n"+
				"        (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) f, users i \n"+
				" where  a.car_st in ('1','3') and a.client_id not in ('000228','000231')  \n";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		
		dt1 = "substr(decode(b.rent_st,'1',a.rent_dt,b.rent_dt),1,6)";
		dt2 = "decode(b.rent_st,'1',a.rent_dt,b.rent_dt)";


		if(gubun1.equals("1"))				b_query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";		
		else if(gubun1.equals("2"))			b_query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD') \n";		
		else if(gubun1.equals("3"))			b_query += " and "+dt2+" = to_char(sysdate-2,'YYYYMMDD') \n";		
		else if(gubun1.equals("4"))			b_query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' \n";
		else if(gubun1.equals("5"))			b_query += " and "+dt2+" like TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%' \n";
		else if(gubun1.equals("6"))			b_query += " and "+dt2+" like TO_CHAR(ADD_MONTHS(SYSDATE,-2),'YYYYMM')||'%' \n";
		else if(gubun1.equals("9")){
			if(!st_dt.equals("") && end_dt.equals(""))	b_query += " and "+dt2+" like replace('"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) b_query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		b_query += "     and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				"        and a.car_mng_id=g.car_mng_id(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.cls_st,'0') not in ('7','10')  \n"+
				"        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+) \n"+
				"        and a.rent_mng_id=f.rent_mng_id(+) and a.reg_dt=f.reg_dt(+) \n"+
				"        and case when f.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),f.reg_dt)  then '' else f.rent_l_cd end is null \n"+
				"        and decode(b.rent_st,'1',a.bus_id,nvl(b.ext_agnt,a.bus_id))=i.user_id "+
				" ";				

		//����
		if(mode.equals("1")) 		b_query += " and b.rent_st = '1' and a.car_gu = '1' \n";

		//�縮��+�߰���
		if(mode.equals("2")) 		b_query += " and b.rent_st = '1' and a.car_gu <> '1' \n";

		//����
		if(mode.equals("3")) 		b_query += " and b.rent_st <> '1' \n";



		
		query = " select car_gu, rent_way, \n";
	
		query += " count(decode(dept_id,'0001',rent_l_cd)) cnt0, \n";	
		query += " count(decode(dept_id,'0002',rent_l_cd)) cnt1, \n";	
		query += " count(decode(dept_id,'0001',1,'0002',1)) cnt2, \n";	
		query += " count(decode(dept_id,'0007',rent_l_cd)) cnt3, \n";	
		query += " count(decode(dept_id,'0008',rent_l_cd)) cnt4, \n";	
		query += " count(decode(dept_id,'0009',rent_l_cd)) cnt5, \n";	
		query += " count(decode(dept_id,'0010',rent_l_cd)) cnt6, \n";	
		query += " count(decode(dept_id,'0011',rent_l_cd,'0016',rent_l_cd)) cnt7, \n";	
		query += " count(decode(dept_id,'0012',rent_l_cd)) cnt8, \n";	
		query += " count(decode(dept_id,'0013',rent_l_cd)) cnt9, \n";	
		query += " count(decode(dept_id,'0014',rent_l_cd)) cnt10, \n";
		query += " count(decode(dept_id,'0015',rent_l_cd)) cnt11, \n";
		query += " count(decode(dept_id,'0017',rent_l_cd)) cnt12, \n";
		query += " count(decode(dept_id,'0018',rent_l_cd)) cnt13, \n";
		query += " count(decode(dept_id,'1000',rent_l_cd)) cnt14, \n";

		query += " count(rent_l_cd) cnt15 \n"+
				" from   ("+b_query+") \n"+
				" group by car_gu, rent_way \n"+
				" order by decode(rent_way,'�⺻��','0','1')\n"+
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
			System.out.println("[StatBusDatabase:getStatDeptList]"+e);
			System.out.println("[StatBusDatabase:getStatDeptList]"+query);
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
	 *	�μ��������Ȳ-����Ʈ
	 */
	public Vector getStatDeptRmList(String mode, String gubun1, String st_dt, String end_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";
		String b_query2 = "";
		String stat_st = "d";
		 		
		//rent_cont
		b_query = " select a.rent_s_cd, \n"+
				  "        a.rent_st, a.rent_dt, \n"+
				  "        i.br_id, i.dept_id \n"+
				  " from   rent_cont a, users i \n"+
				  " where  a.rent_st='12' and a.use_st<>'5'  \n";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		
		dt1 = "substr(a.rent_dt,1,6)";
		dt2 = "a.rent_dt";


		if(gubun1.equals("1"))				b_query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";		
		else if(gubun1.equals("2"))			b_query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD') \n";		
		else if(gubun1.equals("3"))			b_query += " and "+dt2+" = to_char(sysdate-2,'YYYYMMDD') \n";		
		else if(gubun1.equals("4"))			b_query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' \n";
		else if(gubun1.equals("5"))			b_query += " and "+dt2+" like TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%' \n";
		else if(gubun1.equals("6"))			b_query += " and "+dt2+" like TO_CHAR(ADD_MONTHS(SYSDATE,-2),'YYYYMM')||'%' \n";
		else if(gubun1.equals("9")){
			if(!st_dt.equals("") && end_dt.equals(""))	b_query += " and "+dt2+" like replace('"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) b_query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		b_query += "     and a.bus_id=i.user_id "+
				" ";				

		//cont
		b_query2 = " select a.rent_l_cd as rent_s_cd, \n"+
				  "        '12' rent_st, a.rent_dt, \n"+
				  "        i.br_id, i.dept_id \n"+
				  " from   cont a, users i, cls_cont b, fee_rm d \n"+
				  " where  a.car_st='4' and a.rent_l_cd not like 'RM%' and a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+)"+
				  "	       and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and d.rent_st='1' "+
				  "        and nvl(a.rent_start_dt,substr(d.deli_plan_dt,1,8))<>nvl(b.cls_dt,nvl(a.rent_end_dt,substr(d.ret_plan_dt,1,8)))  \n";

		
		dt1 = "substr(a.rent_dt,1,6)";
		dt2 = "a.rent_dt";


		if(gubun1.equals("1"))				b_query2 += " and "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";		
		else if(gubun1.equals("2"))			b_query2 += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD') \n";		
		else if(gubun1.equals("3"))			b_query2 += " and "+dt2+" = to_char(sysdate-2,'YYYYMMDD') \n";		
		else if(gubun1.equals("4"))			b_query2 += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' \n";
		else if(gubun1.equals("5"))			b_query2 += " and "+dt2+" like TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%' \n";
		else if(gubun1.equals("6"))			b_query2 += " and "+dt2+" like TO_CHAR(ADD_MONTHS(SYSDATE,-2),'YYYYMM')||'%' \n";
		else if(gubun1.equals("9")){
			if(!st_dt.equals("") && end_dt.equals(""))	b_query2 += " and "+dt2+" like replace('"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) b_query2 += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		b_query2 += "     and a.bus_id=i.user_id "+
				" ";	

		
		query = " select rent_st, \n";
	
		query += " count(decode(dept_id,'0001',rent_s_cd)) cnt0, \n";	
		query += " count(decode(dept_id,'0002',rent_s_cd)) cnt1, \n";	
		query += " count(decode(dept_id,'0001',1,'0002',1)) cnt2, \n";	
		query += " count(decode(dept_id,'0007',rent_s_cd)) cnt3, \n";	
		query += " count(decode(dept_id,'0008',rent_s_cd)) cnt4, \n";	
		query += " count(decode(dept_id,'0009',rent_s_cd)) cnt5, \n";	
		query += " count(decode(dept_id,'0010',rent_s_cd)) cnt6, \n";	
		query += " count(decode(dept_id,'0011',rent_s_cd,'0016',rent_s_cd)) cnt7, \n";	
		query += " count(decode(dept_id,'0012',rent_s_cd)) cnt8, \n";	
		query += " count(decode(dept_id,'0013',rent_s_cd)) cnt9, \n";	
		query += " count(decode(dept_id,'0014',rent_s_cd)) cnt10, \n";
		query += " count(decode(dept_id,'0015',rent_s_cd)) cnt11, \n";
		query += " count(decode(dept_id,'0017',rent_s_cd)) cnt12, \n";
		query += " count(decode(dept_id,'0018',rent_s_cd)) cnt13, \n";
		query += " count(decode(dept_id,'1000',rent_s_cd)) cnt14, \n";

		query += " count(rent_s_cd) cnt15 \n"+
				" from   ("+b_query+" union all "+b_query2+") \n"+
				" group by rent_st \n"+
				" order by rent_st\n"+
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
			System.out.println("[StatBusDatabase:getStatDeptRmList]"+e);
			System.out.println("[StatBusDatabase:getStatDeptRmList]"+query);
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
	 *	�μ��������Ȳ
	 */
	public Vector getStatDeptListSub(String mode, String gubun1, String st_dt, String end_dt, String rent_way, String br_id, String dept_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";
		String stat_st = "d";
		 		
		b_query = " select a.rent_l_cd, \n"+
				"        decode(b.rent_st||a.car_gu,'11','����','10','�縮��','12','�縮��','����') car_gu, \n"+
				"        decode(b.rent_way,'1','�Ϲݽ�','�⺻��') rent_way, \n"+
				"        decode(b.rent_st,'1',a.rent_dt,b.rent_dt) rent_dt, \n"+
				"        i.br_id, i.dept_id, i.user_nm, \n"+
				"        j.firm_nm, g.car_no, k.car_nm, d.car_name "+
				" from   cont a, fee b, car_etc c, car_nm d, car_reg g, cls_cont e, fee_etc h, \n"+
				"        (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) f, \n"+
				"        users i, client j, car_mng k \n"+
				" where  a.car_st in ('1','3') and a.client_id not in ('000228','000231')  \n";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		
		dt1 = "substr(decode(b.rent_st,'1',a.rent_dt,b.rent_dt),1,6)";
		dt2 = "decode(b.rent_st,'1',a.rent_dt,b.rent_dt)";


		if(gubun1.equals("1"))				b_query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";		
		else if(gubun1.equals("2"))			b_query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD') \n";		
		else if(gubun1.equals("3"))			b_query += " and "+dt2+" = to_char(sysdate-2,'YYYYMMDD') \n";		
		else if(gubun1.equals("4"))			b_query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' \n";
		else if(gubun1.equals("5"))			b_query += " and "+dt2+" like TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%' \n";
		else if(gubun1.equals("6"))			b_query += " and "+dt2+" like TO_CHAR(ADD_MONTHS(SYSDATE,-2),'YYYYMM')||'%' \n";
		else if(gubun1.equals("9")){
			if(!st_dt.equals("") && end_dt.equals(""))	b_query += " and "+dt2+" like replace('"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) b_query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		if(!rent_way.equals(""))			b_query += " and decode(b.rent_way,'1','�Ϲݽ�','�⺻��')='"+rent_way+"' ";


		b_query += "     and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				"        and a.car_mng_id=g.car_mng_id(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.cls_st,'0') not in ('7','10')  \n"+
				"        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+) \n"+
				"        and a.rent_mng_id=f.rent_mng_id(+) and a.reg_dt=f.reg_dt(+) \n"+
				"        and case when f.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),f.reg_dt)  then '' else f.rent_l_cd end is null \n"+
				"        and decode(b.rent_st,'1',a.bus_id,nvl(b.ext_agnt,a.bus_id))=i.user_id "+
				"        and a.client_id=j.client_id "+
				"        and d.car_comp_id=k.car_comp_id and d.car_cd=k.code "+
				" ";				

		if(!br_id.equals(""))				b_query += " and decode(i.br_id,'U1','G1',i.br_id)='"+br_id+"' ";
		if(!dept_id.equals(""))				b_query += " and decode(i.dept_id,'0016','0011',i.dept_id)='"+dept_id+"' ";

		//����
		if(mode.equals("1")) 		b_query += " and b.rent_st = '1' and a.car_gu = '1' \n";

		//�縮��+�߰���
		if(mode.equals("2")) 		b_query += " and b.rent_st = '1' and a.car_gu <> '1' \n";

		//����
		if(mode.equals("3")) 		b_query += " and b.rent_st <> '1' \n";


		
		query = b_query;
	
		query += " order by decode(b.rent_st||a.car_gu,'11','����','10','�縮��','12','�縮��','����'), decode(b.rent_way,'1','�Ϲݽ�','�⺻��'), decode(b.rent_st,'1',a.rent_dt,b.rent_dt), i.br_id, i.dept_id \n"+
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
			System.out.println("[StatBusDatabase:getStatDeptListSub]"+e);
			System.out.println("[StatBusDatabase:getStatDeptListSub]"+query);
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
	 *	�μ��������Ȳ-����Ʈ
	 */
	public Vector getStatDeptRmListSub(String mode, String gubun1, String st_dt, String end_dt, String rent_way, String br_id, String dept_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";
		String b_query2 = "";
		String stat_st = "d";
		 		
		b_query = " select a.rent_s_cd, \n"+
				"        a.rent_st, a.rent_dt, \n"+
				"        i.br_id, i.dept_id, i.user_nm, \n"+
				"        j.firm_nm, g.car_no, g.car_nm, d.car_name, '' car_gu, '' rent_way "+
				" from   rent_cont a, users i, car_reg g, client j, \n"+
				"        (select a.* FROM CONT a, (SELECT car_mng_id, min(rent_l_cd) rent_l_cd from cont where car_st<>'4' group by car_mng_id) b WHERE a.car_mng_id=b.car_mng_id AND a.rent_l_cd=b.rent_l_cd) b, \n"+
				"        car_etc c, car_nm d"+ 
				" where  a.rent_st='12' and a.use_st<>'5'  \n";

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		
		dt1 = "substr(a.rent_dt,1,6)";
		dt2 = "a.rent_dt";


		if(gubun1.equals("1"))				b_query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";		
		else if(gubun1.equals("2"))			b_query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD') \n";		
		else if(gubun1.equals("3"))			b_query += " and "+dt2+" = to_char(sysdate-2,'YYYYMMDD') \n";		
		else if(gubun1.equals("4"))			b_query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' \n";
		else if(gubun1.equals("5"))			b_query += " and "+dt2+" like TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%' \n";
		else if(gubun1.equals("6"))			b_query += " and "+dt2+" like TO_CHAR(ADD_MONTHS(SYSDATE,-2),'YYYYMM')||'%' \n";
		else if(gubun1.equals("9")){
			if(!st_dt.equals("") && end_dt.equals(""))	b_query += " and "+dt2+" like replace('"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) b_query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		b_query +=  "     and a.bus_id=i.user_id \n"+
					"     and a.car_mng_id=g.car_mng_id \n"+
					"     and a.cust_id=j.client_id \n"+
					"     and a.car_mng_id=b.car_mng_id \n"+
					"     and b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd \n"+
					"     and c.car_id=d.car_id and c.car_seq=d.car_seq "+
				" ";				

		if(!br_id.equals(""))				b_query += " and decode(i.br_id,'U1','G1',i.br_id)='"+br_id+"' ";
		if(!dept_id.equals(""))				b_query += " and decode(i.dept_id,'0016','0011',i.dept_id)='"+dept_id+"' ";




		//cont
		b_query2 = " select a.rent_l_cd as rent_s_cd, \n"+
				  "        '12' rent_st, a.rent_dt, \n"+
				  "        i.br_id, i.dept_id, i.user_nm, \n"+
				  "        j.firm_nm, g.car_no, g.car_nm, d.car_name, '' car_gu, '' rent_way "+
				  " from   cont a, users i, cls_cont b, fee_rm d, client j, car_reg g, car_etc c, car_nm d \n"+
				  " where  a.car_st='4' and a.rent_l_cd not like 'RM%' and a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+)"+
				  "	       and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and d.rent_st='1' "+
				  "        and nvl(a.rent_start_dt,substr(d.deli_plan_dt,1,8))<>nvl(b.cls_dt,nvl(a.rent_end_dt,substr(d.ret_plan_dt,1,8))) "+
				  " \n";


		dt1 = "substr(a.rent_dt,1,6)";
		dt2 = "a.rent_dt";


		if(gubun1.equals("1"))				b_query2 += " and "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";		
		else if(gubun1.equals("2"))			b_query2 += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD') \n";		
		else if(gubun1.equals("3"))			b_query2 += " and "+dt2+" = to_char(sysdate-2,'YYYYMMDD') \n";		
		else if(gubun1.equals("4"))			b_query2 += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' \n";
		else if(gubun1.equals("5"))			b_query2 += " and "+dt2+" like TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%' \n";
		else if(gubun1.equals("6"))			b_query2 += " and "+dt2+" like TO_CHAR(ADD_MONTHS(SYSDATE,-2),'YYYYMM')||'%' \n";
		else if(gubun1.equals("9")){
			if(!st_dt.equals("") && end_dt.equals(""))	b_query2 += " and "+dt2+" like replace('"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) b_query2 += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		b_query2 +=  "    and a.bus_id=i.user_id \n"+
					"     and a.car_mng_id=g.car_mng_id \n"+
					"     and a.client_id=j.client_id \n"+
					"     and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
					"     and c.car_id=d.car_id and c.car_seq=d.car_seq "+
				" ";				

		if(!br_id.equals(""))				b_query2 += " and decode(i.br_id,'U1','G1',i.br_id)='"+br_id+"' ";
		if(!dept_id.equals(""))				b_query2 += " and decode(i.dept_id,'0016','0011',i.dept_id)='"+dept_id+"' ";


		query = b_query2;
		
	

		query += " order by rent_st, rent_dt, br_id, dept_id \n"+
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
			System.out.println("[StatBusDatabase:getStatDeptRmListSub]"+e);
			System.out.println("[StatBusDatabase:getStatDeptRmListSub]"+query);
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
	 *	���Ⱓ�������Ȳ
	 */
	public Vector getStatConMonList(String mode, String s_yy, String s_mm, int days, int f_year, String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";
		String stat_st = "d";
		 		
		b_query = " select a.rent_l_cd, \n"+
				"        decode(b.rent_st||a.car_gu,'11','����','10','�縮��','12','�縮��','����') car_gu, \n"+
				"        decode(substr(d.s_st,1,1),'3','LPG����','��LPG����') s_st, \n"+
				"        decode(b.rent_st,'1',a.rent_dt,b.rent_dt) rent_dt, b.rent_start_dt, \n"+
                "        CASE WHEN to_number(b.con_mon) BETWEEN 0  AND  12 THEN '12' WHEN b.con_mon BETWEEN '13' AND '24' THEN '24' WHEN b.con_mon BETWEEN '25' AND '36' THEN '36' WHEN b.con_mon BETWEEN '37' AND '48' THEN '48' WHEN b.con_mon BETWEEN '49' AND '99' THEN '60' else '12' end con_mon \n"+            
				" from   cont a, fee b, car_etc c, car_nm d, car_reg g, cls_cont e, fee_etc h, \n"+
				"        (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) f \n"+
				" where  a.car_st in ('1','3')  and a.client_id<>'000228'  \n";

		//�Ϻ�
		if(!s_yy.equals("") && !s_mm.equals("")){

			if(gubun2.equals("1"))	b_query += " and b.rent_start_dt like '"+s_yy+""+s_mm+"%' \n";
			else                    b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+""+s_mm+"%' \n";

			stat_st = "d";

		//����
		}else if(!s_yy.equals("") && s_mm.equals("")){

			if(gubun2.equals("1"))	b_query += " and b.rent_start_dt like '"+s_yy+"%' \n";
			else                  	b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+"%' \n";

			stat_st = "m";

		//�⵵��
		}else if(s_yy.equals("") && s_mm.equals("")){

			stat_st = "y";
		}

		b_query += "     and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				"        and a.car_mng_id=g.car_mng_id(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.cls_st,'0') not in ('7','10')  \n"+
				"        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+) \n"+
				"        and a.rent_mng_id=f.rent_mng_id(+) and a.reg_dt=f.reg_dt(+) \n"+
				"        and case when f.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),f.reg_dt)  then '' else f.rent_l_cd end is null \n"+
				" ";				

		if(gubun1.equals("1")) 											b_query += " and a.car_st='1' and decode(substr(d.s_st,1,1),'3','LPG����','��LPG����')='LPG����' \n";
		if(gubun1.equals("2")) 											b_query += " and a.car_st='1' and decode(substr(d.s_st,1,1),'3','LPG����','��LPG����')='��LPG����' \n";
		if(gubun1.equals("3")) 											b_query += " and a.car_st='1' \n";
		if(gubun1.equals("4")) 											b_query += " and a.car_st='3' \n";


		//����
		if(mode.equals("1")) 		b_query += " and b.rent_st = '1' and a.car_gu = '1' \n";

		//�縮��+�߰���
		if(mode.equals("2"))		b_query += " and b.rent_st = '1' and a.car_gu <> '1' \n";

		//����
		if(mode.equals("3"))		b_query += " and b.rent_st <> '1' \n";



		query = " select decode(con_mon,'��Ÿ',con_mon,con_mon||'����') con_mon, \n";



		if(gubun2.equals("1")){
			if(stat_st.equals("d")){
				for (int i = 0 ; i < days ; i++){
					query += " count(decode(to_number(substr(rent_start_dt,7,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
				}
			}else if(stat_st.equals("m")){
				for (int i = 0 ; i < 12 ; i++){
					query += " count(decode(to_number(substr(rent_start_dt,5,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
				}
			}else if(stat_st.equals("y")){
				for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
					query += " count(decode(to_number(substr(rent_start_dt,1,4)),"+(i)+",rent_l_cd)) cnt"+(i-2000)+", \n";	
				}
			}
		}else{
			if(stat_st.equals("d")){
				for (int i = 0 ; i < days ; i++){
					query += " count(decode(to_number(substr(rent_dt,7,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
				}
			}else if(stat_st.equals("m")){
				for (int i = 0 ; i < 12 ; i++){
					query += " count(decode(to_number(substr(rent_dt,5,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
				}
			}else if(stat_st.equals("y")){
				for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
					query += " count(decode(to_number(substr(rent_dt,1,4)),"+(i)+",rent_l_cd)) cnt"+(i-2000)+", \n";	
				}
			}
		}


			query += " count(rent_l_cd) cnt0 \n"+
					" from   ("+b_query+") \n"+
		            " group by con_mon \n"+
					" order by decode(con_mon,'��Ÿ','99',con_mon)\n"+
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
			System.out.println("[StatBusDatabase:getStatConMonList]"+e);
			System.out.println("[StatBusDatabase:getStatConMonList]"+query);
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
	 *	���Ằ(������)�����Ȳ
	 */
	public Vector getStatFuelList(String mode, String s_yy, String s_mm, int days, int f_year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";
		String stat_st = "d";
		 		
		b_query = " select a.rent_l_cd, \n"+
				"       decode(b.rent_st||a.car_gu,'11','����','10','�縮��','12','�縮��','����') car_gu, \n"+
				" 		(case when d.diesel_yn = '2' and d.s_st in ('300','301','302') then '3' \n"+
				"			  when d.diesel_yn = '2' and d.s_st not in ('300','301','302') then '4' \n"+
				"			  when d.diesel_yn = 'Y' then '2' \n"+
				" 			  when d.diesel_yn = '3' then '5' \n"+
				" 			  when d.diesel_yn = '4' then '6' \n"+
				"  			  when d.diesel_yn = '5' then '7' \n"+
				"  			  when d.diesel_yn = '6' then '8' \n"+
				"			  else '1' end ) diesel_yn, \n"+
				"		decode(d.s_st, '101','100', '409','100', '102','112', '105','104', decode(substr(d.s_st,1,1),'4','401','5','401','6','401','7','701','8','801','9','104', d.s_st)) s_st, \n"+
				"       decode(b.rent_st,'1',a.rent_dt,b.rent_dt) rent_dt \n"+
				" from  cont a, fee b, car_etc c, car_nm d, car_reg g, cls_cont e, fee_etc h, \n"+
				"       (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) f \n"+
				" where a.car_st in ('1','3')  and a.client_id not in ('000228','000231') \n";
				
		//�Ϻ�
		if(!s_yy.equals("") && !s_mm.equals("")){

			b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+""+s_mm+"%' \n";
			stat_st = "d";

		//����
		}else if(!s_yy.equals("") && s_mm.equals("")){

			b_query += " and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) like '"+s_yy+"%' \n";
			stat_st = "m";

		//�⵵��
		}else if(s_yy.equals("") && s_mm.equals("")){

			stat_st = "y";
		}

		b_query += "     and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.car_id=d.car_id and c.car_seq=d.car_seq \n"+
				"        and a.car_mng_id=g.car_mng_id(+) \n"+
				"        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.cls_st,'0') not in ('7','10')  \n"+
				"        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+) \n"+
				"        and a.rent_mng_id=f.rent_mng_id(+) and a.reg_dt=f.reg_dt(+) \n"+
				"        and case when f.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),f.reg_dt)  then '' else f.rent_l_cd end is null \n"+
				" ";				

		//����
		if(mode.equals("1")||mode.equals("2")) 		b_query += " and b.rent_st = '1' and a.car_gu = '1' \n";

		//�縮��+�߰���
		if(mode.equals("3")||mode.equals("4"))		b_query += " and b.rent_st = '1' and a.car_gu <> '1' \n";

		//����
		if(mode.equals("5")||mode.equals("6"))		b_query += " and b.rent_st <> '1' \n";


		//����/�縮��-��Ʈ
		query = " select car_gu, diesel_yn, \n";


		if(stat_st.equals("d")){
			for (int i = 0 ; i < days ; i++){
				query += " count(decode(to_number(substr(rent_dt,7,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("m")){
			for (int i = 0 ; i < 12 ; i++){
				query += " count(decode(to_number(substr(rent_dt,5,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("y")){
			for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
				query += " count(decode(to_number(substr(rent_dt,1,4)),"+(i)+",rent_l_cd)) cnt"+(i-2000)+", \n";	
			}
		}

		query += " count(rent_l_cd) cnt0 \n"+
				 " from   ("+b_query+") \n"+						
				 " group by car_gu, diesel_yn \n"+
				 " order by diesel_yn asc \n"+
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
			System.out.println("[StatBusDatabase:getStatFuelList]"+e);
			System.out.println("[StatBusDatabase:getStatFuelList]"+query);
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
	 *	���������������Ȳ
	 */
	public Vector getStatAccidUserList(String mode, String s_yy, String s_mm, int days, int f_year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";
		String stat_st = "d";
		 		
		//�Ϻ�
		if(!s_yy.equals("") && !s_mm.equals("")){
			stat_st = "d";
		//����
		}else if(!s_yy.equals("") && s_mm.equals("")){
			stat_st = "m";
		//�⵵��
		}else if(s_yy.equals("") && s_mm.equals("")){
			stat_st = "y";
		}
		
		query = " SELECT b.loan_st, b.user_id,  \n"+
				"        DECODE(grouping_id (b.loan_st, b.user_id),1,'�Ұ�',3,'�հ�',MAX(b.user_nm)) user_nm,  \n"+
				"        nvl(COUNT(a.accid_id),0) cnt0,  \n";

		if(stat_st.equals("d")){
			for (int i = 0 ; i < days ; i++){
				query += " nvl(count(decode(to_number(substr(a.reg_dt,7,2)),"+(i+1)+",a.accid_id)),0) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("m")){
			for (int i = 0 ; i < 12 ; i++){
				query += " nvl(count(decode(to_number(substr(a.reg_dt,5,2)),"+(i+1)+",a.accid_id)),0) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("y")){
			for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
				query += " nvl(count(decode(to_number(substr(a.reg_dt,1,4)),"+(i)+",a.accid_id)),0) cnt"+(i-(f_year-1))+", \n";	
			}
		}

		query +="        grouping_id(b.loan_st, b.user_id) d \n"+
				" FROM   (select loan_st, user_id, user_nm from users where use_yn='Y' and loan_st in ('1','2')) b, "+
				"        (select accid_id, accid_st, reg_dt, reg_id from ACCIDENT where reg_dt>='"+f_year+"0101'";

		if(!mode.equals("")){
			query += " and accid_st='"+mode+"' \n";
		}else{
			query += " and accid_st IN ('3','8','1') \n";
		}

		//�Ϻ�
		if(stat_st.equals("d")){
			query += " and reg_dt like '"+s_yy+""+s_mm+"%' \n";
		//����
		}else if(stat_st.equals("m")){
			query += " and reg_dt like '"+s_yy+"%' \n";
		}

		query +="        ) a  \n"+
				" WHERE  b.user_id=a.reg_id(+) \n"+
				" ";


				
		query += " group by grouping sets ((b.loan_st, b.user_id), (b.loan_st), ()) \n"+
			   	 " order by b.loan_st, grouping_id(b.loan_st, b.user_id) , 4 desc,  b.user_id  \n"+
		//		 " order by b.loan_st, b.user_id, grouping_id(b.loan_st, b.user_id) \n"+
				 " ";				

		try {

			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

	 //   	System.out.println("[StatBusDatabase:getStatAccidUserList]"+query);
	    	
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
			System.out.println("[StatBusDatabase:getStatAccidUserList]"+e);
			System.out.println("[StatBusDatabase:getStatAccidUserList]"+query);
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
	 *	��������Կɼ���������Ȳ
	 */
	public Vector getStatClsUserList(String mode, String s_yy, String s_mm, int days, int f_year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";
		String b_query2 = "";
		String b_query3 = "";
		String b_query4 = "";
		String stat_st = "m";
		 		
		//�Ϻ�
		if(!s_yy.equals("") && !s_mm.equals("")){
			stat_st = "d";
		//����
		}else if(!s_yy.equals("") && s_mm.equals("")){
			stat_st = "m";
		//�⵵��
		}else if(s_yy.equals("") && s_mm.equals("")){
			stat_st = "y";
		}
		
		// ���Կɼ� ���

		b_query = " SELECT b.loan_st, b.user_id,  \n"+
				"        DECODE(grouping_id (b.loan_st, b.user_id),1,'�Ұ�',3,'�հ�',MAX(b.user_nm)) user_nm,  \n"+
				"        nvl(COUNT(a.rent_l_cd),0) cnt0,  \n";

		if(stat_st.equals("d")){
			for (int i = 0 ; i < days ; i++){
				b_query += " nvl(count(decode(to_number(substr(a.cls_dt,7,2)),"+(i+1)+",a.rent_l_cd)),0) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("m")){
			for (int i = 0 ; i < 12 ; i++){
				b_query += " nvl(count(decode(to_number(substr(a.cls_dt,5,2)),"+(i+1)+",a.rent_l_cd)),0) cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("y")){
			for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
				b_query += " nvl(count(decode(to_number(substr(a.cls_dt,1,4)),"+(i)+",a.rent_l_cd)),0) cnt"+(i-(f_year-1))+", \n";	
			}
		}

		b_query +="        grouping_id(b.loan_st, b.user_id) d \n"+
				" FROM   (select loan_st, user_id, user_nm from users where use_yn='Y' AND loan_st IN ('1','2')) b,  \n"+
				"        (select a.rent_l_cd, a.cls_st, a.cls_dt, decode(c.user_id1,'',a.reg_id,c.user_id1) reg_id \n"+
				"         from   cls_cont a, (select doc_id, user_id1 from doc_settle where doc_st='11') c \n"+
				"         where  a.cls_dt>='"+f_year+"0101' and a.rent_l_cd=c.doc_id(+) \n";

		if(!mode.equals("")){
			b_query += " and a.cls_st='"+mode+"' \n";
		}else{
			b_query += " and a.cls_st IN ('8','1','2') \n";
		}

		//�Ϻ�
		if(stat_st.equals("d")){
			b_query += " and a.cls_dt like '"+s_yy+""+s_mm+"%' \n";
		//����
		}else if(stat_st.equals("m")){
			b_query += " and a.cls_dt like '"+s_yy+"%' \n";
		}

		b_query+="        ) a \n"+
				" WHERE  b.user_id=a.reg_id(+) \n"+
				" ";

				
		b_query += " group by grouping sets ((b.loan_st, b.user_id), (b.loan_st), ()) \n"+
				 " ";	

		//��հ������

		b_query2 = " SELECT b.loan_st, b.user_id,  \n"+
				"        MAX(b.user_nm) user_nm,  \n"+
				"   ";

		if(stat_st.equals("d")){
			for (int i = 0 ; i < days ; i++){
				b_query2 += " nvl(round(avg(decode(to_number(substr(a.save_dt,7,2)),"+(i+1)+",a.c_gen_cnt_b2+a.c_bp_cnt_b2))),0)";	
				if((i+1)==days){
					b_query2 += " a_cnt0, \n";
				}else{
					b_query2 += " + \n";
				}
			}
			for (int i = 0 ; i < days ; i++){
				b_query2 += " round(avg(decode(to_number(substr(a.save_dt,7,2)),"+(i+1)+",a.c_gen_cnt_b2+a.c_bp_cnt_b2))) a_cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("m")){
			for (int i = 0 ; i < 12 ; i++){
				b_query2 += " nvl(round(avg(decode(to_number(substr(a.save_dt,5,2)),"+(i+1)+",a.c_gen_cnt_b2+a.c_bp_cnt_b2))),0)";	
				if((i+1)==12){
					b_query2 += " a_cnt0, \n";
				}else{
					b_query2 += " + \n";
				}
			}
			for (int i = 0 ; i < 12 ; i++){
				b_query2 += " round(avg(decode(to_number(substr(a.save_dt,5,2)),"+(i+1)+",a.c_gen_cnt_b2+a.c_bp_cnt_b2))) a_cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("y")){
			for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
				b_query2 += " nvl(round(avg(decode(to_number(substr(a.save_dt,1,4)),"+(i)+",a.c_gen_cnt_b2+a.c_bp_cnt_b2))),0)";	
				if(i==AddUtil.getDate2(1)){
					b_query2 += " a_cnt0, \n";
				}else{
					b_query2 += " + \n";
				}
			}
			for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
				b_query2 += " round(avg(decode(to_number(substr(a.save_dt,1,4)),"+(i)+",a.c_gen_cnt_b2+a.c_bp_cnt_b2))) a_cnt"+(i-(f_year-1))+", \n";	
			}
		}

		b_query2 +=" count(0) d FROM   stat_mng a, users b \n"+
				" WHERE  a.user_id=b.user_id and b.use_yn='Y' and b.loan_st in ('1','2') and a.save_dt>='"+f_year+"0101' \n"+
				" ";
		
		//�Ϻ�
		if(stat_st.equals("d")){
			b_query2 += " and a.save_dt like '"+s_yy+""+s_mm+"%' \n";
		//����
		}else if(stat_st.equals("m")){
			b_query2 += " and a.save_dt like '"+s_yy+"%' \n";
		}
				
		b_query2 += " group by b.loan_st, b.user_id \n"+
				 " ";	

		b_query3 = " select loan_st, '' user_id, '�Ұ�' user_nm, sum(a_cnt0) a_cnt0,";

		if(stat_st.equals("d")){
			for (int i = 0 ; i < days ; i++){
				b_query3 += " sum(a_cnt"+(i+1)+") a_cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("m")){
			for (int i = 0 ; i < 12 ; i++){
				b_query3 += " sum(a_cnt"+(i+1)+") a_cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("y")){
			for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
				b_query3 += " sum(a_cnt"+(i-(f_year-1))+") a_cnt"+(i-(f_year-1))+", \n";	
			}
		}

		b_query3+= " count(0) d from ("+b_query2+") group by loan_st ";

		b_query4 = " select '' loan_st, '' user_id, '�հ�' user_nm, sum(a_cnt0) a_cnt0,";

		if(stat_st.equals("d")){
			for (int i = 0 ; i < days ; i++){
				b_query4 += " sum(a_cnt"+(i+1)+") a_cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("m")){
			for (int i = 0 ; i < 12 ; i++){
				b_query4 += " sum(a_cnt"+(i+1)+") a_cnt"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("y")){
			for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
				b_query4 += " sum(a_cnt"+(i-(f_year-1))+") a_cnt"+(i-(f_year-1))+", \n";	
			}
		}

		b_query4+= " count(0) d from ("+b_query2+") ";


		query = " select a.loan_st, a.user_id, a.user_nm, \n";

		if(stat_st.equals("d")){
			for (int i = 0 ; i < days ; i++){
				query += " a.cnt"+(i+1)+", b.a_cnt"+(i+1)+", nvl(round(a.cnt"+(i+1)+"/decode(b.a_cnt"+(i+1)+",0,null,b.a_cnt"+(i+1)+")*100,1),0) per"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("m")){
			for (int i = 0 ; i < 12 ; i++){
				query += " a.cnt"+(i+1)+", b.a_cnt"+(i+1)+", nvl(round(a.cnt"+(i+1)+"/decode(b.a_cnt"+(i+1)+",0,null,b.a_cnt"+(i+1)+")*100,1),0) per"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("y")){
			for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
				query += " a.cnt"+(i-(f_year-1))+", b.a_cnt"+(i-(f_year-1))+", nvl(round(a.cnt"+(i-(f_year-1))+"/decode(b.a_cnt"+(i-(f_year-1))+",0,null,b.a_cnt"+(i-(f_year-1))+")*100,1),0) per"+(i-(f_year-1))+", \n";	
			}
		}

		query += " a.cnt0, b.a_cnt0, round(a.cnt0/decode(b.a_cnt0,0,null,b.a_cnt0)*100,1) per0 \n"+
				 " from    \n"+
				 "         ("+b_query+") a,\n"+
				 "         ("+b_query2+" \n "+
				 "           union all "+b_query3+" \n"+
				 "           union all "+b_query4+" \n"+
				 "         ) b \n"+
				 " where   a.loan_st||a.user_id||a.user_nm=b.loan_st||b.user_id||b.user_nm order by a.loan_st, a.user_id, a.d ";

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

			//System.out.println("[StatBusDatabase:getStatClsUserList]"+query);

		} catch (SQLException e) {
			System.out.println("[StatBusDatabase:getStatClsUserList]"+e);
			System.out.println("[StatBusDatabase:getStatClsUserList]"+query);
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
	 *	���Կɼǽ�����Ȳ
	 */
	public Vector getStatCls2UserList(String mode, String s_yy, String s_mm, int days, int f_year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String b_query = "";
		String stat_st = "d";
		 		
		//�Ϻ�
		if(!s_yy.equals("") && !s_mm.equals("")){
			stat_st = "d";
		//����
		}else if(!s_yy.equals("") && s_mm.equals("")){
			stat_st = "m";
		//�⵵��
		}else if(s_yy.equals("") && s_mm.equals("")){
			stat_st = "y";
		}

		if(mode.equals("81")){
			b_query += " decode(a.cls_st2,'1',a.rent_l_cd) \n";
		}else if(mode.equals("82")){
			b_query += " decode(a.cls_st2,'2',a.rent_l_cd) \n";
		}else{
			b_query += " decode(a.cls_st,'"+mode+"',a.rent_l_cd) \n";
		}
		
		query = " SELECT b.loan_st, b.user_id,  \n"+
				"        DECODE(grouping_id (b.loan_st, b.user_id),1,'�Ұ�',3,'�հ�',MAX(b.user_nm)) user_nm,  \n"+
				"        nvl(COUNT(a.rent_l_cd),0) a_cnt0,  nvl(COUNT("+b_query+"),0) cnt0, nvl(round(COUNT("+b_query+")/decode(COUNT(a.rent_l_cd),0,null,COUNT(a.rent_l_cd))*100,1),0) per0, \n";

		if(stat_st.equals("d")){
			for (int i = 0 ; i < days ; i++){
				query += " nvl(count(decode(to_number(substr(a.cls_dt,7,2)),"+(i+1)+",a.rent_l_cd)),0) a_cnt"+(i+1)+", \n";	
				query += " nvl(count(decode(to_number(substr(a.cls_dt,7,2)),"+(i+1)+","+b_query+")),0) cnt"+(i+1)+", \n";	
				query += " nvl(round(count(decode(to_number(substr(a.cls_dt,7,2)),"+(i+1)+","+b_query+"))/decode(count(decode(to_number(substr(a.cls_dt,7,2)),"+(i+1)+",a.rent_l_cd)),0,null,count(decode(to_number(substr(a.cls_dt,7,2)),"+(i+1)+",a.rent_l_cd)))*100,1),0) per"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("m")){
			for (int i = 0 ; i < 12 ; i++){
				query += " nvl(count(decode(to_number(substr(a.cls_dt,5,2)),"+(i+1)+",a.rent_l_cd)),0) a_cnt"+(i+1)+", \n";	
				query += " nvl(count(decode(to_number(substr(a.cls_dt,5,2)),"+(i+1)+","+b_query+")),0) cnt"+(i+1)+", \n";	
				query += " nvl(round(count(decode(to_number(substr(a.cls_dt,5,2)),"+(i+1)+","+b_query+"))/decode(count(decode(to_number(substr(a.cls_dt,5,2)),"+(i+1)+",a.rent_l_cd)),0,null,count(decode(to_number(substr(a.cls_dt,5,2)),"+(i+1)+",a.rent_l_cd)))*100,1),0) per"+(i+1)+", \n";	
			}
		}else if(stat_st.equals("y")){
			for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
				query += " nvl(count(decode(to_number(substr(a.cls_dt,1,4)),"+(i)+",a.rent_l_cd)),0) a_cnt"+(i-(f_year-1))+", \n";	
				query += " nvl(count(decode(to_number(substr(a.cls_dt,1,4)),"+(i)+","+b_query+")),0) cnt"+(i-(f_year-1))+", \n";	
				query += " nvl(round(count(decode(to_number(substr(a.cls_dt,1,4)),"+(i)+","+b_query+"))/decode(count(decode(to_number(substr(a.cls_dt,1,4)),"+(i)+",a.rent_l_cd)),0,null,count(decode(to_number(substr(a.cls_dt,1,4)),"+(i)+",a.rent_l_cd)))*100,1),0) per"+(i-(f_year-1))+", \n";	
			}
		}

		query +="        grouping_id(b.loan_st, b.user_id) d \n"+
				" FROM   (select loan_st, user_id, user_nm from users where use_yn='Y' and loan_st in ('1','2')) b, \n"+
				"        (select a.rent_l_cd, \n"+
				"                a.cls_st, case when a.cls_st='8' and a.r_mon >= b.con_mon then '1' when a.cls_st='8' and a.r_mon < b.con_mon then '2' else '' end cls_st2, \n"+
				"                a.cls_dt, decode(c.user_id1,'',a.reg_id,c.user_id1) reg_id \n"+
				"         from   cls_cont a, (select doc_id, user_id1 from doc_settle where doc_st='11') c, (select rent_l_cd, sum(con_mon) con_mon from fee group by rent_l_cd) b \n"+
				"         where  a.cls_dt>='"+f_year+"0101' and a.cls_st IN ('8','1','2') and a.rent_l_cd=c.doc_id(+) and a.rent_l_cd=b.rent_l_cd \n";

		//�Ϻ�
		if(stat_st.equals("d")){
			query += " and a.cls_dt like '"+s_yy+""+s_mm+"%' \n";
		//����
		}else if(stat_st.equals("m")){
			query += " and a.cls_dt like '"+s_yy+"%' \n";
		}

		query +="        ) a  \n"+
				" WHERE  b.user_id=a.reg_id(+) \n"+
				" ";

				
		query += " group by grouping sets ((b.loan_st, b.user_id), (b.loan_st), ()) \n"+
				 " order by b.loan_st, grouping_id(b.loan_st, b.user_id) ,  6 desc, b.user_id \n"+
				// " order by b.loan_st, b.user_id, grouping_id(b.loan_st, b.user_id) \n"+
				 " ";				

		try {

//			System.out.println("[StatBusDatabase:getStatCls2UserList]"+query);

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
			System.out.println("[StatBusDatabase:getStatCls2UserList]"+e);
			System.out.println("[StatBusDatabase:getStatCls2UserList]"+query);
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

	//����������Ȳ
public Vector getStatRentUser(String s_yy, String s_mm)
{
	getConnection();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	Vector vt = new Vector();
	String query = "";

	query = " SELECT DECODE(grouping_id(a.br_nm),1,'�հ�',DECODE(grouping_id(a.loan_st, a.loc_st, a.dept_id, a.br_nm, a.user_id, a.user_nm, a.enter_dt),0,a.br_nm,'�Ұ�')) br_nm,\r\n" + 
			"              a.user_id, a.enter_dt, \r\n" + 
			"              DECODE(grouping_id(a.br_nm),1,'�հ�',DECODE(grouping_id(a.loan_st, a.loc_st, a.dept_id, a.br_nm, a.user_id, a.user_nm, a.enter_dt),0,a.user_nm,'�Ұ�')) user_nm, \r\n" + 
			"              count(DECODE(b.car_st,'���',b.rent_l_cd)) cnt0,\r\n" + 
			"              COUNT(DECODE(b.car_gu,'�ű�',b.rent_l_cd)) cnt1,\r\n" + 
			"              COUNT(DECODE(b.car_gu,'����',b.rent_l_cd)) cnt2,\r\n" + 
			"              COUNT(DECODE(b.car_gu,'����',b.rent_l_cd)) cnt3,\r\n" + 
			"              COUNT(DECODE(b.car_gu,'�ű�',b.rent_l_cd,'����',b.rent_l_cd,'����',b.rent_l_cd)) cnt4,\r\n" + 
			"              COUNT(DECODE(b.car_gu,'�縮',b.rent_l_cd)) cnt5,\r\n" + 
			"              COUNT(DECODE(b.car_gu,'����',b.rent_l_cd)) cnt6,\r\n" + 
			"              count(DECODE(b.car_st,'���',b.rent_l_cd)) cnt7,\r\n" + 
			"              COUNT(DECODE(b.rent_way,'�Ϲݽ�',DECODE(b.car_gu,'�ű�',b.rent_l_cd))) cnt8,\r\n" + 
			"              COUNT(DECODE(b.rent_way,'�Ϲݽ�',DECODE(b.car_gu,'����',b.rent_l_cd))) cnt9,\r\n" + 
			"              COUNT(DECODE(b.rent_way,'�Ϲݽ�',DECODE(b.car_gu,'����',b.rent_l_cd))) cnt10,\r\n" + 
			"              COUNT(DECODE(b.rent_way,'�Ϲݽ�',DECODE(b.car_gu,'�ű�',b.rent_l_cd,'����',b.rent_l_cd,'����',b.rent_l_cd))) cnt11,\r\n" + 
			"              COUNT(DECODE(b.rent_way,'�Ϲݽ�',DECODE(b.car_gu,'�縮',b.rent_l_cd))) cnt12,\r\n" + 
			"              COUNT(DECODE(b.rent_way,'�Ϲݽ�',DECODE(b.car_gu,'����',b.rent_l_cd))) cnt13,\r\n" + 
			"              COUNT(DECODE(b.rent_way,'�Ϲݽ�',b.rent_l_cd)) cnt14,\r\n" + 
			"              COUNT(DECODE(b.rent_way,'�⺻��',DECODE(b.car_gu,'�ű�',b.rent_l_cd))) cnt15,\r\n" + 
			"              COUNT(DECODE(b.rent_way,'�⺻��',DECODE(b.car_gu,'����',b.rent_l_cd))) cnt16,\r\n" + 
			"              COUNT(DECODE(b.rent_way,'�⺻��',DECODE(b.car_gu,'����',b.rent_l_cd))) cnt17,\r\n" + 
			"              COUNT(DECODE(b.rent_way,'�⺻��',DECODE(b.car_gu,'�ű�',b.rent_l_cd,'����',b.rent_l_cd,'����',b.rent_l_cd))) cnt18,\r\n" + 
			"              COUNT(DECODE(b.rent_way,'�⺻��',DECODE(b.car_gu,'�縮',b.rent_l_cd))) cnt19,\r\n" + 
			"              COUNT(DECODE(b.rent_way,'�⺻��',DECODE(b.car_gu,'����',b.rent_l_cd))) cnt20,\r\n" + 
			"              COUNT(DECODE(b.rent_way,'�⺻��',b.rent_l_cd)) cnt21,\r\n" + 
			"              count(DECODE(b.car_st,'����Ʈ',b.rent_l_cd)) cnt22, \r\n" + 
			"              count(DECODE(b.e_doc,'����',b.rent_l_cd)) cnt23 \r\n" +			
			"       FROM   \r\n" + 
			"              (\r\n" + 
			"                    SELECT a.dept_id, a.user_id, a.br_id, a.loan_st, a.user_nm, a.enter_dt, \r\n" + 
			"                           DECODE(b.br_nm,'����','',REPLACE(b.br_nm,'����',''))||DECODE(a.loan_st,'1','��������','������') br_nm,\r\n" + 
			"                           DECODE(SUBSTR(a.br_id,1,1),'S','1','I','1','K','1','2') loc_st \r\n" + 
			"                    FROM   users a, branch b, code c\r\n" + 
			"                    WHERE  a.use_yn='Y' AND a.loan_st IN ('1','2')\r\n" + 
			"                           AND a.br_id=b.br_id\r\n" + 
			"                           AND a.dept_id=c.code AND c.c_st='0002'\r\n" + 
			"                    UNION all        \r\n" + 
			"                    SELECT a.dept_id, a.user_id, a.br_id, '3' loan_st, a.user_nm, a.enter_dt, \r\n" + 
			"                           '������Ʈ' br_nm, \r\n" + 
			"                           '1' loc_st  \r\n" + 
			"                    FROM   users a, car_off_emp b, car_off c\r\n" + 
			"                    WHERE  a.use_yn='Y' AND a.dept_id='1000'\r\n" + 
			"                           AND a.sa_code=b.emp_id and b.agent_id=c.car_off_id \r\n" + 
			"                           and nvl(c.work_st,'C')='C' and nvl(c.use_yn,'Y')='Y' \r\n" + 
			"              ) a,        \r\n" + 
			"              (\r\n" + 
			"		            select a.rent_l_cd, '���' AS car_st,\r\n" + 
			"			         	       decode(b.rent_st||a.car_gu,'11',decode(a.rent_st,'1','�ű�','3','����','4','����','�ű�'),'10','�縮','12','�縮��','����') car_gu, \r\n" + 
			"                       DECODE(b.rent_way,'1','�Ϲݽ�','�⺻��') rent_way,\r\n" + 
			"                       decode(b.rent_st,'1',a.bus_id,b.ext_agnt) bus_id, \r\n" +
			"                       decode(c.rent_l_cd,'','','����') e_doc \n"+
			"		            from   cont a, fee b, cls_cont e, fee_etc h,   \r\n" + 
			"		                   (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) f, \r\n" +
			//"--��Ÿ����Ʈ ���ڰ�༭
			"                          (SELECT a.rent_l_cd, a.rent_st FROM alink.lc_rent_link_m a, alink.tmsg_queue b WHERE a.doc_code=b.link_key AND b.tmsg_kncd in ('AC713','AC813') AND b.tmsg_type='2' AND b.content LIKE '%zip%' GROUP BY a.rent_l_cd, a.rent_st \r\n" +
			"                           UNION all \r\n" +
			//"--���Ǹ��� ���ڰ�༭  
			"                           SELECT a.rent_l_cd, a.rent_st FROM alink.lc_rent_link a, alink.contract_status b WHERE a.doc_yn<>'D' AND a.rent_l_cd||a.rent_st||a.im_seq=substr(b.key_index,2) AND b.index_status='�Ϸ�' GROUP BY a.rent_l_cd, a.RENT_ST \r\n" +
            "                          ) c \r\n" +
			"		            where  a.car_st in ('1','3')  and a.client_id not in ('000228','000231')\r\n" + 
			"                          and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) between '"+s_yy+"' and '"+s_mm+"' \r\n" + 
			"                     	   and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\r\n" + 
			"		         		       and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.cls_st,'0') not in ('7','10')\r\n" + 
			"		         		       and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+)\r\n" + 
			"		         		       and a.rent_mng_id=f.rent_mng_id(+) and a.reg_dt=f.reg_dt(+)\r\n" + 
			"		         		       and case when f.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),f.reg_dt)  then '' else f.rent_l_cd end is NULL\r\n" + 
			"                              and b.rent_l_cd=c.rent_l_cd(+) and b.rent_st=c.rent_st(+) "+
			"                UNION ALL\r\n" + 
			"                SELECT a.rent_l_cd, '����Ʈ' AS car_st, '' AS car_gu, '' AS rent_way, a.bus_id, '' e_doc \r\n" + 
			"                FROM   cont a, fee b, cls_cont e\r\n" + 
			"                WHERE  a.car_st='4' AND a.client_id NOT IN ('000228','000231')\r\n" + 
			"                       AND a.rent_dt between '"+s_yy+"' and '"+s_mm+"'  \r\n" + 
			"                       and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd AND b.rent_st='1' AND b.rent_start_dt IS NOT NULL       \r\n" + 
			"                       and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.cls_dt,b.rent_end_dt) > b.rent_start_dt\r\n" + 
			"              ) b\r\n" + 
			"       WHERE a.user_id=b.bus_id(+) \r\n" + 
			"       group by grouping sets ((a.loan_st, a.loc_st, a.dept_id, a.br_nm, a.user_id, a.user_nm, a.enter_dt), (a.br_nm), ()) \n";
	 
	
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
		System.out.println("[StatBusDatabase:getStatRentUser]"+e);
		System.out.println("[StatBusDatabase:getStatRentUser]"+query);
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

//����������Ȳ
public Vector getStatRentUserDept(String s_mode, String s_gubun1, String s_yy, String s_mm)
{
getConnection();
PreparedStatement pstmt = null;
ResultSet rs = null;
Vector vt = new Vector();
String query = "";
String dt_query = "";


if(s_gubun1.equals("4")){						dt_query += " like to_char(sysdate,'YYYYMM')||'%' \n";
}else if(s_gubun1.equals("5")){					dt_query += " like TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%' \n";
}else if(s_gubun1.equals("6")){					dt_query += " like TO_CHAR(ADD_MONTHS(SYSDATE,-2),'YYYYMM')||'%' \n";
}else if(s_gubun1.equals("8")){					dt_query += " like to_char(sysdate,'YYYY')||'%' \n";
}else if(s_gubun1.equals("9")){
	if(!s_yy.equals("") && s_mm.equals(""))		dt_query += " like '%"+s_yy+"%' \n";
	if(!s_yy.equals("") && !s_mm.equals("")) 	dt_query += " between '"+s_yy+"' and '"+s_mm+"' \n";
}else {
	dt_query += " between '"+s_yy+"' and '"+s_mm+"' \n";
}

query = " SELECT a.loan_st, a.br_nm, a.user_id, a.enter_dt, a.user_nm,  \r\n" + 
		"              count(DECODE(b.car_st,'���',b.rent_l_cd)) cnt0,\r\n" + 
		"              COUNT(DECODE(b.car_gu,'�ű�',b.rent_l_cd)) cnt1,\r\n" + 
		"              COUNT(DECODE(b.car_gu,'����',b.rent_l_cd)) cnt2,\r\n" + 
		"              COUNT(DECODE(b.car_gu,'����',b.rent_l_cd)) cnt3,\r\n" + 
		"              COUNT(DECODE(b.car_gu,'�ű�',b.rent_l_cd,'����',b.rent_l_cd,'����',b.rent_l_cd)) cnt4,\r\n" + 
		"              COUNT(DECODE(b.car_gu,'�縮',b.rent_l_cd)) cnt5,\r\n" + 
		"              COUNT(DECODE(b.car_gu,'����',b.rent_l_cd)) cnt6,\r\n" + 
		"              count(DECODE(b.car_st,'���',b.rent_l_cd)) cnt7,\r\n" + 
		"              COUNT(DECODE(b.rent_way,'�Ϲݽ�',DECODE(b.car_gu,'�ű�',b.rent_l_cd))) cnt8,\r\n" + 
		"              COUNT(DECODE(b.rent_way,'�Ϲݽ�',DECODE(b.car_gu,'����',b.rent_l_cd))) cnt9,\r\n" + 
		"              COUNT(DECODE(b.rent_way,'�Ϲݽ�',DECODE(b.car_gu,'����',b.rent_l_cd))) cnt10,\r\n" + 
		"              COUNT(DECODE(b.rent_way,'�Ϲݽ�',DECODE(b.car_gu,'�ű�',b.rent_l_cd,'����',b.rent_l_cd,'����',b.rent_l_cd))) cnt11,\r\n" + 
		"              COUNT(DECODE(b.rent_way,'�Ϲݽ�',DECODE(b.car_gu,'�縮',b.rent_l_cd))) cnt12,\r\n" + 
		"              COUNT(DECODE(b.rent_way,'�Ϲݽ�',DECODE(b.car_gu,'����',b.rent_l_cd))) cnt13,\r\n" + 
		"              COUNT(DECODE(b.rent_way,'�Ϲݽ�',b.rent_l_cd)) cnt14,\r\n" + 
		"              COUNT(DECODE(b.rent_way,'�⺻��',DECODE(b.car_gu,'�ű�',b.rent_l_cd))) cnt15,\r\n" + 
		"              COUNT(DECODE(b.rent_way,'�⺻��',DECODE(b.car_gu,'����',b.rent_l_cd))) cnt16,\r\n" + 
		"              COUNT(DECODE(b.rent_way,'�⺻��',DECODE(b.car_gu,'����',b.rent_l_cd))) cnt17,\r\n" + 
		"              COUNT(DECODE(b.rent_way,'�⺻��',DECODE(b.car_gu,'�ű�',b.rent_l_cd,'����',b.rent_l_cd,'����',b.rent_l_cd))) cnt18,\r\n" + 
		"              COUNT(DECODE(b.rent_way,'�⺻��',DECODE(b.car_gu,'�縮',b.rent_l_cd))) cnt19,\r\n" + 
		"              COUNT(DECODE(b.rent_way,'�⺻��',DECODE(b.car_gu,'����',b.rent_l_cd))) cnt20,\r\n" + 
		"              COUNT(DECODE(b.rent_way,'�⺻��',b.rent_l_cd)) cnt21,\r\n" + 
		"              count(DECODE(b.e_doc,'����',b.rent_l_cd)) cnt22, \r\n" +			
		"              count(DECODE(b.car_st,'����Ʈ',b.rent_l_cd)) cnt23 \r\n" + 
		"       FROM   \r\n" + 
		"              (\r\n" + 
		"                    SELECT a.dept_id, a.user_id, a.br_id, a.loan_st, a.user_nm, a.enter_dt, \r\n" + 
		"                           DECODE(b.br_nm,'����','',REPLACE(b.br_nm,'����',''))||DECODE(a.loan_st,'1','��������','������') br_nm,\r\n" + 
		"                           DECODE(SUBSTR(a.br_id,1,1),'S','1','I','1','K','1','2') loc_st \r\n" + 
		"                    FROM   users a, branch b, code c\r\n" + 
		"                    WHERE  a.use_yn='Y' AND a.loan_st IN ('1','2')\r\n" + 
		"                           AND a.br_id=b.br_id\r\n" + 
		"                           AND a.dept_id=c.code AND c.c_st='0002'\r\n" + 
		"                    UNION all        \r\n" + 
		"                    SELECT a.dept_id, a.user_id, a.br_id, '3' loan_st, a.user_nm, a.enter_dt, \r\n" + 
		"                           '������Ʈ' br_nm, \r\n" + 
		"                           '3' loc_st  \r\n" + 
		"                    FROM   users a, car_off_emp b, car_off c\r\n" + 
		"                    WHERE  a.use_yn='Y' AND a.dept_id='1000'\r\n" + 
		"                           AND a.sa_code=b.emp_id and b.agent_id=c.car_off_id \r\n" + 
		"                           and nvl(c.work_st,'C')='C' and nvl(c.use_yn,'Y')='Y' \r\n" + 
		"              ) a,        \r\n" + 
		"              (\r\n" + 
		"		            select a.rent_l_cd, '���' AS car_st,\r\n" + 
		"			         	       decode(b.rent_st||a.car_gu,'11',decode(a.rent_st,'1','�ű�','3','����','4','����','�ű�'),'10','�縮','12','�縮��','����') car_gu, \r\n" + 
		"                       DECODE(b.rent_way,'1','�Ϲݽ�','�⺻��') rent_way,\r\n" + 
		"                       decode(b.rent_st,'1',a.bus_id,b.ext_agnt) bus_id, \r\n" +
		"                       decode(c.rent_l_cd,'','','����') e_doc \n"+
		"		            from   cont a, fee b, cls_cont e, fee_etc h,   \r\n" + 
		"		                   (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) f, \r\n" +
		//"--��Ÿ����Ʈ ���ڰ�༭
		"                          (SELECT a.rent_l_cd, a.rent_st FROM alink.lc_rent_link_m a, alink.tmsg_queue b WHERE a.doc_code=b.link_key AND b.tmsg_kncd in ('AC713','AC813') AND b.tmsg_type='2' AND b.content LIKE '%zip%' GROUP BY a.rent_l_cd, a.rent_st \r\n" +
		"                           UNION all \r\n" +
		//"--���Ǹ��� ���ڰ�༭  
		"                           SELECT a.rent_l_cd, a.rent_st FROM alink.lc_rent_link a, alink.contract_status b WHERE a.doc_yn<>'D' AND a.rent_l_cd||a.rent_st||a.im_seq=substr(b.key_index,2) AND b.index_status='�Ϸ�' GROUP BY a.rent_l_cd, a.RENT_ST \r\n" +
        "                          ) c \r\n" +
		"		            where  a.car_st in ('1','3')  and a.client_id not in ('000228','000231')\r\n" + 
		"                          and decode(b.rent_st,'1',a.rent_dt,b.rent_dt) "+dt_query+"  \r\n" + 
		"                     	   and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd\r\n" + 
		"		         		       and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.cls_st,'0') not in ('7','10')\r\n" + 
		"		         		       and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+)\r\n" + 
		"		         		       and a.rent_mng_id=f.rent_mng_id(+) and a.reg_dt=f.reg_dt(+)\r\n" + 
		"		         		       and case when f.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),f.reg_dt)  then '' else f.rent_l_cd end is NULL\r\n" + 
		"                              and b.rent_l_cd=c.rent_l_cd(+) and b.rent_st=c.rent_st(+) "+
		"                UNION ALL\r\n" + 
		"                SELECT a.rent_l_cd, '����Ʈ' AS car_st, '' AS car_gu, '' AS rent_way, a.bus_id, '' e_doc \r\n" + 
		"                FROM   cont a, fee b, cls_cont e\r\n" + 
		"                WHERE  a.car_st='4' AND a.client_id NOT IN ('000228','000231')\r\n" + 
		"                       AND a.rent_dt "+dt_query+" \r\n" + 
		"                       and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd AND b.rent_st='1' AND b.rent_start_dt IS NOT NULL       \r\n" + 
		"                       and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.cls_dt,b.rent_end_dt) > b.rent_start_dt\r\n" + 
		"              ) b\r\n" + 
		"       WHERE a.user_id=b.bus_id(+) \r\n" + 
		"       group by a.loc_st, a.loan_st, a.dept_id, a.br_nm, a.user_id, a.enter_dt, a.user_nm ";

		if(s_mode.contentEquals("smart")) {
			query += "       order by decode(a.loan_st,'1','2','2','1','3'), count(DECODE(b.car_st,'���',b.rent_l_cd)) desc \n";
		}else {
			query += "       order by a.loc_st, a.loan_st desc, a.dept_id, count(DECODE(b.car_st,'���',b.rent_l_cd)) desc \n";			
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
	System.out.println("[StatBusDatabase:getStatRentUserDept]"+e);
	System.out.println("[StatBusDatabase:getStatRentUserDept]"+query);
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

//����������Ȳ
public Vector getStatRentDept()
{
getConnection();
PreparedStatement pstmt = null;
ResultSet rs = null;
Vector vt = new Vector();
String query = "";

query = " SELECT loc_st, loan_st, dept_id, br_nm \r\n" + 			
		"       FROM   \r\n" + 
		"              (\r\n" + 
		"                    SELECT a.dept_id, a.user_id, a.br_id, a.loan_st, a.user_nm, a.enter_dt, \r\n" + 
		"                           DECODE(b.br_nm,'����','',REPLACE(b.br_nm,'����',''))||DECODE(a.loan_st,'1','��������','������') br_nm,\r\n" + 
		"                           DECODE(SUBSTR(a.br_id,1,1),'S','1','I','1','K','1','2') loc_st \r\n" + 
		"                    FROM   users a, branch b, code c\r\n" + 
		"                    WHERE  a.use_yn='Y' AND a.loan_st IN ('1','2')\r\n" + 
		"                           AND a.br_id=b.br_id\r\n" + 
		"                           AND a.dept_id=c.code AND c.c_st='0002'\r\n" + 
		"                    UNION all        \r\n" + 
		"                    SELECT a.dept_id, a.user_id, a.br_id, '3' loan_st, a.user_nm, a.enter_dt, \r\n" + 
		"                           '������Ʈ' br_nm, \r\n" + 
		"                           '3' loc_st  \r\n" + 
		"                    FROM   users a, car_off_emp b, car_off c\r\n" + 
		"                    WHERE  a.use_yn='Y' AND a.dept_id='1000'\r\n" + 
		"                           AND a.sa_code=b.emp_id and b.agent_id=c.car_off_id \r\n" + 
		"                           and nvl(c.work_st,'C')='C' and nvl(c.use_yn,'Y')='Y' \r\n" + 
		"              ) a        \r\n" + 
		"       group by loc_st, loan_st, dept_id, br_nm \r\n" + 
        "       ORDER by loc_st, loan_st desc, dept_id \r\n" ;

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
	System.out.println("[StatBusDatabase:getStatRentDept]"+e);
	System.out.println("[StatBusDatabase:getStatRentDept]"+query);
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
 *	����к������Ȳ
 */
public Vector getStatComList(String gubun, String s_yy)
{
	getConnection();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	Vector vt = new Vector();
	String query = "";
	String b_query = "";
	String stat_st = "d";
	String b_dt = "rent_dt";
	
	if(gubun.equals("2")){
		b_dt = "dlv_dt";
	}
	
	b_query = " select a.rent_l_cd,\r\n"
			+ "               CASE WHEN i.one_self='Y' AND i.dir_pur_yn='Y' THEN '��ü���(Ư��)'\r\n"
			+ "                    WHEN i.one_self='Y' AND NVL(i.dir_pur_yn,'N')<>'Y' THEN '��ü���(�븮��)' \r\n"
			+ "                    WHEN NVL(i.one_self,'N')='N' THEN '��Ÿ�븮��'\r\n"
			+ "                    END pur_st,\r\n"
			+ "               i.one_self,\r\n"
			+ "               i.dir_pur_yn,\r\n"
			+ "				  a.rent_dt,\r\n"
			+ "               a.dlv_dt,\r\n"
			+ "               d.car_comp_id, \r\n"
			+ "               i.dlv_brch \r\n"
			+ "				from  cont a, fee b, car_etc c, car_nm d, car_reg g, cls_cont e, fee_etc h, \r\n"
			+ "				      (select rent_mng_id, rent_l_cd, cls_dt, cls_st, nvl(reg_dt,cls_dt) reg_dt from cls_cont where cls_st in ('4','5')) f,\r\n"
			+ "                   car_pur i \r\n"
			+ "				where   a.car_st in ('1','3') AND NVL(a.reject_car,'N')<>'Y' and a.client_id<>'000228' \r\n"
			+ "                     and a."+b_dt+" like '"+s_yy+"%' \r\n"
			+ "                     and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \r\n"
			+ "				        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \r\n"
			+ "				        and c.car_id=d.car_id and c.car_seq=d.car_seq\r\n"
			+ "                     AND d.car_comp_id <= '0005' \r\n"
			+ "				        and a.car_mng_id=g.car_mng_id(+) \r\n"
			+ "				        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and nvl(e.cls_st,'0') not in ('7','10')  \r\n"
			+ "				        and b.rent_mng_id=h.rent_mng_id(+) and b.rent_l_cd=h.rent_l_cd(+) and b.rent_st=h.rent_st(+) \r\n"
			+ "				        and a.rent_mng_id=f.rent_mng_id(+) and a.reg_dt=f.reg_dt(+)\r\n"
			+ "                     and a.rent_mng_id=i.rent_mng_id and a.rent_l_cd=i.rent_l_cd \r\n"
			+ "				        and case when f.rent_l_cd is not null and a.reg_dt < nvl(to_char(h.reg_dt,'YYYYMMDD'),f.reg_dt)  then '' else f.rent_l_cd end is null \r\n"
			+ "                     and b.rent_st = '1' and a.car_gu = '1' \n";

	if(gubun.equals("2")){
		b_query += " and a.car_mng_id is not null ";
	}
	
	query = " SELECT car_comp_id, pur_st, \n";

	for (int i = 0 ; i < 12 ; i++){
		query += " count(decode(to_number(substr("+b_dt+",5,2)),"+(i+1)+",rent_l_cd)) cnt"+(i+1)+", \n";	
	}

	query += " count(rent_l_cd) cnt0 \n"+
			 " from   ("+b_query+") \n"+						
			 " GROUP BY car_comp_id, pur_st \n"+
			 " ORDER BY car_comp_id, DECODE(pur_st,'��Ÿ�븮��',1,0), pur_st desc \n"+
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
		System.out.println("[StatBusDatabase:getStatComList]"+e);
		System.out.println("[StatBusDatabase:getStatComList]"+query);
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
