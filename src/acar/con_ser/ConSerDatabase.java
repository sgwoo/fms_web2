/**
 * �����
 */
package acar.con_ser;

import java.util.*;
import java.sql.*;
import acar.util.*;
import acar.common.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;
import acar.cont.*;
import acar.car_service.*;

public class ConSerDatabase {

    private static ConSerDatabase instance;
    private DBConnectionManager connMgr;   
    private final String DATA_SOURCE = "acar"; 
 
    public static synchronized ConSerDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new ConSerDatabase();
        return instance;
    }
    
    private ConSerDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }


	// ��ȸ -------------------------------------------------------------------------------------------------

	//����� ����Ʈ ��ȸ(������Ȳ) - ���Ǻ��� ����???
	public Vector getServiceList(String br_id, String gubun1, String gubun2, String gubun3, String gubun4, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select \n"+
				"        a.car_mng_id, a.serv_id, a.accid_id, a.rent_mng_id, a.rent_l_cd, b.firm_nm,  b.client_nm,\n"+
				"        c.car_no, c.car_nm, decode(a.set_dt, '','�̼���','����') gubun,\n"+
				"        decode(a.serv_st, '1','��ȸ����', '2','�Ϲݼ���', '3','��������', '4','��������','5','�������','7','�縮������', '12',  '��������', '13', '����' ) serv_st, d.off_nm, a.rep_cont, a.tot_dist,"+
				"        nvl(a.checker,'���Է�') checker, a.tot_amt   ,       b.use_yn, b.mng_id, a.reg_id,"+ 
				"        nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),'') serv_dt,\n"+
				"        nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),'') set_dt \n"+
				" from   service a, cont_n_view b, serv_off d , car_reg c \n"+
				" where \n"+
				"        a.tot_amt > 0 "+
				"        and a.car_mng_id=b.car_mng_id and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id =c.car_mng_id "+
				"        and a.off_id=d.off_id\n"+
				" ";

		/*����ȸ&&������ȸ*/

		//���-��ȹ
		if(gubun2.equals("1") && gubun3.equals("1")){		query += " and a.serv_dt like to_char(sysdate,'YYYYMM')||'%' ";
		//���-����
		}else if(gubun2.equals("1") && gubun3.equals("2")){	query += " and a.serv_dt like to_char(sysdate,'YYYYMM')||'%' and a.set_dt is not null";
		//���-�̼���
		}else if(gubun2.equals("1") && gubun3.equals("3")){	query += " and a.serv_dt like to_char(sysdate,'YYYYMM')||'%' and a.set_dt is null";
		//����-��ȹ
		}else if(gubun2.equals("2") && gubun3.equals("1")){	query += " and a.serv_dt = to_char(sysdate,'YYYYMMDD')";
		//����-����
		}else if(gubun2.equals("2") && gubun3.equals("2")){	query += " and a.serv_dt = to_char(sysdate,'YYYYMMDD') and a.set_dt = to_char(sysdate,'YYYYMMDD')";
		//����-�̼���
		}else if(gubun2.equals("2") && gubun3.equals("3")){	query += " and a.serv_dt = to_char(sysdate,'YYYYMMDD') and a.set_dt is null";
		//��ü-��ȹ
		}else if(gubun2.equals("3") && gubun3.equals("1")){	query += " and a.serv_dt < to_char(sysdate,'YYYYMMDD') and (a.set_dt is null or a.set_dt = to_char(sysdate,'YYYYMMDD'))";
		//��ü-����
		}else if(gubun2.equals("3") && gubun3.equals("2")){	query += " and a.serv_dt < to_char(sysdate,'YYYYMMDD') and a.set_dt = to_char(sysdate,'YYYYMMDD')";
		//��ü-�̼���
		}else if(gubun2.equals("3") && gubun3.equals("3")){	query += " and a.serv_dt < to_char(sysdate,'YYYYMMDD') and a.set_dt is null";
		//�Ⱓ-��ȹ
		}else if(gubun2.equals("4") && gubun3.equals("1")){	query += " and a.serv_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"'";
		//�Ⱓ-����
		}else if(gubun2.equals("4") && gubun3.equals("2")){	query += " and a.set_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.set_dt is not null";
		//�Ⱓ-�̼���
		}else if(gubun2.equals("4") && gubun3.equals("3")){	query += " and a.serv_dt BETWEEN '"+st_dt+"' AND '"+end_dt+"' and a.set_dt is null";
		//����+��ü-��ȹ
		}else if(gubun2.equals("6") && gubun3.equals("1")){	query += " and a.serv_dt <= to_char(sysdate,'YYYYMMDD') and (a.set_dt is null or a.set_dt = to_char(sysdate,'YYYYMMDD'))";
		//����+��ü-����
		}else if(gubun2.equals("6") && gubun3.equals("2")){	query += " and a.serv_dt <= to_char(sysdate,'YYYYMMDD') and a.set_dt = to_char(sysdate,'YYYYMMDD')";
		//����+��ü-�̼���
		}else if(gubun2.equals("6") && gubun3.equals("3")){	query += " and a.serv_dt <= to_char(sysdate,'YYYYMMDD') and a.set_dt is null";
		//�˻�-����
		}else if(gubun2.equals("5") && gubun3.equals("2")){	query += " and a.set_dt  is not null";
		//�˻�-�̼���
		}else if(gubun2.equals("5") && gubun3.equals("3")){	query += " and a.set_dt is null";
		}


		if(gubun4.equals("2"))			query += " and a.serv_st='1'";
		else if(gubun4.equals("3"))		query += " and a.serv_st='2'";
		else if(gubun4.equals("4"))		query += " and a.serv_st='3'";
		else if(gubun4.equals("5"))		query += " and a.serv_st='4'";


		/*�˻�����*/
			
		if(s_kd.equals("1"))		query += " and nvl(b.firm_nm, '') like '%"+t_wd+"%'\n";			
		else if(s_kd.equals("2"))	query += " and nvl(b.client_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("3"))	query += " and upper(b.rent_l_cd) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("4"))	query += " and nvl(c.car_no, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("5"))	query += " and a.tot_amt like '%"+t_wd+"%'\n";
		else if(s_kd.equals("6"))	query += " and upper(b.brch_id) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("7"))	query += " and nvl(b.r_site, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("8"))	query += " and b.mng_id= '"+t_wd+"'\n";
		else if(s_kd.equals("9"))	query += " and nvl(c.car_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("10"))	query += " and nvl(a.serv_dt, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("11"))	query += " and nvl(d.off_nm, '') like '%"+t_wd+"%'\n";
		else if(s_kd.equals("12"))	query += " and upper(a.rep_cont) like upper('%"+t_wd+"%')\n";
		else if(s_kd.equals("13"))	query += " and a.tot_dist like '%"+t_wd+"%'\n";
		else if(s_kd.equals("14"))	query += " and a.checker= '"+t_wd+"'\n";
		else if(s_kd.equals("15"))	query += " and a.reg_id= '"+t_wd+"'\n";

		//�˻��ϰ�� �ؾ�ǿ����� ��������
		String sort = asc.equals("0")?" asc":" desc";

		/*��������*/

		if(sort_gubun.equals("0"))		query += " order by b.use_yn desc, a.serv_dt "+sort+", a.set_dt, b.firm_nm";
		else if(sort_gubun.equals("1"))	query += " order by b.use_yn desc, b.firm_nm "+sort+", a.set_dt, a.serv_dt";
		else if(sort_gubun.equals("2"))	query += " order by b.use_yn desc, d.off_nm "+sort+", b.firm_nm, a.serv_dt";
		else if(sort_gubun.equals("3"))	query += " order by b.use_yn desc, a.tot_amt "+sort+", a.set_dt, b.firm_nm, a.serv_dt";
		else if(sort_gubun.equals("5"))	query += " order by b.use_yn desc, c.car_no "+sort+", b.firm_nm, a.serv_dt";
	
		try {
			stmt = con.createStatement();
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
			System.out.println("[ConSerDatabase:getServiceList]\n"+e);
			System.out.println("[ConSerDatabase:getServiceList]\n"+query);
			throw new DatabaseException();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;	
	}

	// ����� �Ǻ� ������ ����Ʈ ��ȸ
	public Vector getServiceScd(String m_id, String l_cd, String c_id) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		query = " select"+
					" a.accid_id, a.serv_id,"+
					" decode(a.serv_st, '1','��ȸ����', '2','�Ϲݼ���', '3','��������', '4','��������', '5','�������','7','�縮������') serv_st,"+
					" nvl(a.checker,'���Է�') checker, a.off_id, b.off_nm, a.tot_dist, (a.tot_amt+a.dc) rep_amt, a.dc, a.tot_amt,"+
					" nvl2(a.serv_dt,substr(a.serv_dt,1,4)||'-'||substr(a.serv_dt,5,2)||'-'||substr(a.serv_dt,7,2),' ') serv_dt,"+
					" nvl2(a.set_dt,substr(a.set_dt,1,4)||'-'||substr(a.set_dt,5,2)||'-'||substr(a.set_dt,7,2),' ') set_dt"+
					" from service a, serv_off b"+
					" where"+
					" a.rent_mng_id='"+m_id+"' and a.rent_l_cd='"+l_cd+"' and a.car_mng_id='"+c_id+"'"+
					" and a.off_id=b.off_id"+
					" and a.tot_amt > 0 "+
					" order by a.serv_dt desc";
	
		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
			while(rs.next())
			{				
	            ServiceBean bean = new ServiceBean();

				bean.setRent_mng_id(m_id); 
				bean.setRent_l_cd(l_cd); 
			    bean.setCar_mng_id(c_id); 					
				bean.setServ_id(rs.getString("serv_id")); 
				bean.setAccid_id(rs.getString("accid_id")); 				
				bean.setServ_st(rs.getString("serv_st")); 
				bean.setChecker(rs.getString("checker")); 
				bean.setOff_id(rs.getString("off_id"));
				bean.setOff_nm(rs.getString("off_nm")); 
				bean.setTot_dist(rs.getString("tot_dist")); 
				bean.setRep_amt(rs.getInt("rep_amt")); 
				bean.setDc(rs.getInt("dc")); 
				bean.setTot_amt(rs.getInt("tot_amt")); 
				bean.setServ_dt(rs.getString("serv_dt").trim());
				bean.setSet_dt(rs.getString("set_dt").trim());
				vt.add(bean);	
			}
			rs.close();
            stmt.close();
		} catch (SQLException e) {
			System.out.println("[ConSerDatabase:getServiceScd]\n"+e);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
		}
		return vt;
	}

	/**
	 *	����� ������ �������� : �Ա�ó��, ����
	 */
	public boolean updateServiceScd(String m_id, String l_cd, String c_id, String accid_id, String serv_id, String set_dt, String user_id) throws DatabaseException, DataSourceEmptyException
	{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		//1.�Ա�ó��
		String query1 = " UPDATE service SET set_dt=replace(?, '-', ''), update_dt=to_char(sysdate,'YYYYMMDD'), update_id=?"+
						" WHERE rent_mng_id=? and rent_l_cd=? and car_mng_id=? and serv_id=?";//and accid_id=? 

		try 
		{
			con.setAutoCommit(false);
		
			pstmt = con.prepareStatement(query1);
			pstmt.setString(1, set_dt);
			pstmt.setString(2, user_id);
			pstmt.setString(3, m_id);
			pstmt.setString(4, l_cd);
			pstmt.setString(5, c_id);
			pstmt.setString(6, serv_id);
		    pstmt.executeUpdate();

		    pstmt.close();
			con.commit();
		    
	  	} catch (Exception e) {
			System.out.println("[ConSerDatabase:updateServiceScd]\n"+e);
			e.printStackTrace();
	  		flag = false;
			con.rollback();
		} finally {
			try{	
				con.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}
			catch(Exception ignore){}
            connMgr.freeConnection(DATA_SOURCE, con);
			return flag;
		}
	}


}