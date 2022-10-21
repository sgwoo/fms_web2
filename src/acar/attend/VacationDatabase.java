package acar.attend;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;

public class VacationDatabase
{
	private Connection conn = null;
	public static VacationDatabase db;
	
	public static VacationDatabase getInstance()
	{
		if(VacationDatabase.db == null)
			VacationDatabase.db = new VacationDatabase();
		return VacationDatabase.db;
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
	*	����ں� �����ϼ�,����ϼ�,�����ϼ� ��� - 2005.12.27.ȭ.
	*/
	public Hashtable getVacation(String user_id){
		getConnection();
		Hashtable ht = new Hashtable();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

	/*
		query = " SELECT a.END_DT, b.*, \n"+
				"        trunc(MONTHS_BETWEEN(TO_DATE \n"+
				"          ( \n"+
				"           CASE \n"+
				"           WHEN trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt,'yyyymmdd'))/12 *12) >=24 \n"+
				"           THEN to_char(add_months(to_date(b.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') \n"+
				"           ELSE to_char( add_months(to_date(b.enter_dt, 'yyyymmdd'),24 ), 'yyyymmdd') \n"+
				"           END \n"+
				"           ,'yyyymmdd') \n"+
				"        , sysdate))RE_MONTH,  \n"+
				"        ceil(MOD(MONTHS_BETWEEN(TO_DATE \n"+
				"          ( \n"+
				"           CASE WHEN trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt,'yyyymmdd'))/12 *12) >=24 \n"+
				"           THEN to_char(add_months(to_date(b.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') \n"+
				"           ELSE to_char( add_months(to_date(b.enter_dt, 'yyyymmdd'),24 ), 'yyyymmdd') END \n"+
				"           ,'yyyymmdd'), sysdate) ,1 ) * 30) RE_DAY, \n"+
				"        a.VACATION, \n"+
				"        nvl(decode(b.YEAR, 0, d.ov_cnt, 1, decode(substr(b.enter_dt,0,4),'2004',c.ov_cnt,d.ov_cnt), c.ov_cnt ) ,0) OV_CNT , \n"+
				"        nvl( decode(TRUNC( MONTHS_BETWEEN( SYSDATE, TO_DATE( b.enter_dt, 'YYYYMMDD' ))/ 12 ), 0, d.su,  c.su ), 0 ) su \n"+		
				" FROM \n"+
				"       (SELECT a.user_id, a.end_dt, a.vacation, a.save_dt FROM VACATION_MAGAM a, (SELECT user_id, max(save_dt) save_dt FROM VACATION_MAGAM GROUP BY user_id) b WHERE a.USER_ID = b.user_id AND a.SAVE_DT = b.save_dt) a, \n"+
				"       (SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD'))/12) YEAR, \n"+
				"               TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD'))/12) * 12) MONTH, \n"+
				"               TRUNC((MONTHS_BETWEEN(SYSDATE,TO_DATE(enter_dt, 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD')))) * 30.5) DAY, \n"+
				"               user_id, u.br_id, b.br_nm, u.dept_id, c.nm dept_nm, \n"+
				"               user_pos, user_nm, enter_dt \n"+
				"        FROM   users u, ( select c_st, code, nm_cd, nm from code where c_st = '0002' and code <> '0000'  ) c, branch b   \n"+
				"        WHERE  u.use_yn='Y' AND u.user_pos IN ('�̻�', '����', '����', '����', '����', '�븮', '���', '���ϻ��')  and u.dept_id = c.code and u.br_id = b.br_id   ) b, \n"+
				"       (SELECT b.user_id, sum(decode(count, 'B1', 0.5, 'B2', 0.5, '��������',0.5,'���Ĺ���',0.5,1))AS su, sum(decode(ov_yn, 'Y', 0, 1)) vacation_cnt, sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt \n"+
				"        FROM sch_prv a, users b   \n"+	
				"        WHERE start_year||start_mon||start_day BETWEEN to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4) AND to_char(sysdate,'yyyy')+1||substr(b.enter_dt,5,4)-1 \n"+
				"        AND sch_chk ='3' AND to_number(to_char(sysdate,'mmdd')) >= to_number(substr(b.enter_dt,5,4)) AND nvl(a.gj_ck,'Y') = 'Y'  \n"+			
				"        AND a.user_id(+) = b.user_id  GROUP BY b.user_id \n"+
				"        UNION \n"+
				"        SELECT b.user_id, sum(decode(count, 'B1', 0.5, 'B2', 0.5, '��������',0.5,'���Ĺ���',0.5,1))AS su, sum(decode(ov_yn, 'Y', 0, 1)) vacation_cnt, \n"+
				"        sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt  FROM sch_prv a, users b WHERE start_year||start_mon||start_day BETWEEN (to_char(sysdate,'yyyy')-1)||substr(b.enter_dt,5,4) AND to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4)-1 \n"+
				"        AND sch_chk ='3' AND to_number(to_char(sysdate,'mmdd')) < to_number(substr(b.enter_dt,5,4)) AND nvl(a.gj_ck,'Y') = 'Y' \n"+
				"        AND a.user_id(+) = b.user_id  GROUP BY b.user_id ) c, \n"+
				"       (SELECT b.user_id, sum(decode(count, 'B1', 0.5, 'B2', 0.5, '��������',0.5,'���Ĺ���',0.5,1))AS su, sum(decode(ov_yn, 'Y', 0, 1)) vacation_cnt, \n"+
				"        sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt  FROM sch_prv a, users b \n"+
				"        WHERE start_year||start_mon||start_day BETWEEN b.enter_dt AND substr(b.enter_dt,0,4)+2||substr(b.enter_dt,5,4)-1 \n"+
				"        AND nvl(a.gj_ck,'Y') = 'Y' AND sch_chk ='3' AND a.user_id(+) = b.user_id GROUP BY b.user_id ) d \n"+
				" WHERE a.user_id=? AND a.USER_ID = b.USER_ID AND b.user_id=c.user_id(+) AND b.user_id=d.user_id(+) and b.dept_id IN ('0001','0002','0003', '0005', '0007', '0008','0009','0010','0011', '0012', '0013','0014','0015','0016','0017','0018' , '0020') " ;				
 */
	
	/*			
		query = "SELECT b.*, "+
				" trunc(MONTHS_BETWEEN(TO_DATE(case when trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt))/12 *12) >=24 then to_char(add_months(to_date(b.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') else  to_char( add_months(to_date(b.enter_dt, 'yyyymmdd'),24 ), 'yyyymmdd') end), sysdate))RE_MONTH,  "+
				" ceil(MOD(MONTHS_BETWEEN(TO_DATE(case when trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt))/12 *12) >=24 then to_char(add_months(to_date(b.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') else  to_char( add_months(to_date(b.enter_dt, 'yyyymmdd'),24 ), 'yyyymmdd') end), sysdate) ,1 ) * 30) RE_DAY, "+
				" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12) YEAR,  "+
				" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD')) -  "+
				" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12) * 12) MONTH,  "+
				" TRUNC((MONTHS_BETWEEN(SYSDATE,TO_DATE(b.enter_dt, 'YYYYMMDD')) -  "+
				" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD')))) * 30.5) DAY, "+
				" decode(TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12), "+
				" 		0,TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12) * 12), "+
				" 		1,15, 2,15, 3,16, 4,16, 5,17, 6,17,	7,18, 8,18, 9,19, 10,19, 11,20, 12,20, 13,21, 14,21, 15,22, 16,22, 17,23, 18,23, 19,24, 20,24, "+
				"		decode(sign(TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12)-21),0,25,1,25,0)  \n"+
				"		) VACATION,  \n"+
				" nvl(decode(TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12),  \n"+
				"            0, d.vacation_cnt, 1, decode(substr(b.enter_dt,0,4),'2004',c.vacation_cnt,d.vacation_cnt), c.vacation_cnt  \n"+
				"           )  \n"+
				"  ,0) V_CNT,  \n"+
				" nvl(decode(TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12), "+
				"            0, d.ov_cnt, 1, decode(substr(b.enter_dt,0,4),'2004',c.ov_cnt,d.ov_cnt), c.ov_cnt  \n"+
				"           )  \n"+
				"  ,0) OV_CNT , nvl( decode(TRUNC( MONTHS_BETWEEN( SYSDATE, TO_DATE( b.enter_dt, 'YYYYMMDD' ))/ 12 ), 0, d.su, 1, decode( substr( b.enter_dt, 0, 4 ), '2004', c.su, d.su ), c.su ), 0 ) su \n"+
				
				" FROM (select  b.end_dt, b.vacation, a.user_id, a.br_id, decode(a.br_id,'S1','����','B1','�λ�����','D1','��������','S2','��������','J1','��������','G1','�뱸����','I1','��õ����','') br_nm,   \n"+
				"	a.dept_id, decode(a.dept_id,'0001','������','0002','��������','0003','�ѹ���','0007','�λ�����','0008','��������','0009','��������','0010','��������','0011','�뱸����','0012','��õ����','') dept_nm,   \n"+
				"	a.user_pos,a.user_nm, a.enter_dt, a.id, a.addr, a.user_h_tel, a.user_m_tel, a.user_email, b.save_dt  \n"+
				"			from users a, (SELECT a.user_id, a.end_dt, a.vacation, a.save_dt FROM VACATION_MAGAM a, (SELECT user_id, max(save_dt) save_dt FROM VACATION_MAGAM GROUP BY user_id) b WHERE a.USER_ID = b.user_id AND a.SAVE_DT = b.save_dt) b where a.user_id = b.user_id and ( a.use_yn = 'Y' or b.end_dt >= to_char(sysdate,'YYYYMMdd') ) ) b,  \n"+
				"	   (select b.user_id,  sum(decode(count, 'B1', 0.5, 'B2', 0.5, '��������',0.5,'���Ĺ���',0.5,1))as su, sum(decode(ov_yn, 'Y', 0, 1)) vacation_cnt,  sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt    \n"+
				"		from sch_prv a, users b   \n"+
				"		where start_year||start_mon||start_day between to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4) and to_char(sysdate,'yyyy')+1||substr(b.enter_dt,5,4)-1  \n"+
				"		and sch_chk ='3'  "+
				"		and to_number(to_char(sysdate,'mmdd')) >= to_number(substr(b.enter_dt,5,4)) and nvl(a.gj_ck, 'Y') ='Y'  \n"+
				"		and a.user_id(+) = b.user_id  \n"+
				"		group by b.user_id		  \n"+
				"		union  \n"+
				"		select b.user_id, sum(decode(count, 'B1', 0.5, 'B2', 0.5, '��������',0.5,'���Ĺ���',0.5,1))as su, sum(decode(ov_yn, 'Y', 0, 1)) vacation_cnt,  sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt    \n"+
				"		from sch_prv a, users b   \n"+
				"		where start_year||start_mon||start_day between (to_char(sysdate,'yyyy')-1)||substr(b.enter_dt,5,4) and to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4)-1  \n"+
				"		and sch_chk ='3' \n"+
				"		and to_number(to_char(sysdate,'mmdd')) < to_number(substr(b.enter_dt,5,4))  and nvl(a.gj_ck, 'Y') ='Y' \n"+
				"		and a.user_id(+) = b.user_id  \n"+
				"		group by b.user_id  \n"+
				"		) c, \n"+
				"		(select b.user_id, sum(decode(count, 'B1', 0.5, 'B2', 0.5, '��������',0.5,'���Ĺ���',0.5,1))as su, sum(decode(ov_yn, 'Y', 0, 1)) vacation_cnt,  sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt    \n"+
				"		from sch_prv a, users b \n"+
				"		where start_year||start_mon||start_day between b.enter_dt and substr(b.enter_dt,0,4)+2||substr(b.enter_dt,5,4)-1   and nvl(a.gj_ck, 'Y') ='Y' \n"+
				"		and sch_chk ='3' \n"+
				"		and a.user_id(+) = b.user_id \n"+
				"		group by b.user_id \n"+
				"		) d \n"+
				" where b.user_id=c.user_id(+) and b.user_id=d.user_id(+) and b.user_id=?	 \n"+
				"order by b.br_id desc, b.dept_id, b.enter_dt";
				*/
		
		// query = " SELECT a.END_DT, a.VACATION, a.remain, a.due_dt, u.*,  \n"+
		// query = " SELECT a.END_DT, a.VACATION, a.remain, to_char(to_date(a.end_dt)+30 , 'yyyymmdd') due_dt, u.*,  \n"+
		
 		query = " SELECT  a.END_DT, a.VACATION, a.remain, a.due_dt ,  to_char(to_date(a.end_dt)+30 , 'yyyymmdd') c_due_dt , \n"+
                "   to_char(add_months(to_date(a.end_dt, 'yyyymmdd'), -3) , 'yyyymmdd') d_90_dt ,  to_char(sysdate,'YYYYMMdd') today ,   u.*, \n"+	
				 " trunc(MONTHS_BETWEEN(TO_DATE  \n"+
				 " ( 	\n"+
				 " CASE  \n"+
				 " WHEN trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(u.enter_dt, 'yyyymmdd'))/12 *12) >=24 	 \n"+
				 " THEN to_char(add_months(to_date(u.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(u.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') 	 \n"+
				 " ELSE to_char( add_months(to_date(u.enter_dt, 'yyyymmdd'),24 ), 'yyyymmdd') 	\n"+
				 " END 	 \n"+
				 " , 'yyyymmdd')  \n"+
				 " , sysdate))RE_MONTH,   \n"+
				 " ceil(MOD(MONTHS_BETWEEN(TO_DATE ( CASE 	\n"+
				 " WHEN trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(u.enter_dt, 'yyyymmdd'))/12 *12) >=24 	 \n"+
				 " THEN to_char(add_months(to_date(u.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(u.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') 	 \n"+
				 " ELSE to_char( add_months(to_date(u.enter_dt, 'yyyymmdd'),24 ), 'yyyymmdd') END, 'yyyymmdd' ), sysdate) ,1 ) * 30) RE_DAY , 	 \n"+ //--�����ϼ� (�������� ��������)
				 " NVL(c.ov_cnt, 0) ov_cnt ,	 \n"+  //-- ���� ,
				 " NVL(c.su, 0) su 	, \n"+ //-- ���	
				 " NVL(c.iwol_su, 0) iwol_su 	 \n"+ //-- ���		
				 "      FROM VACATION_MAGAM a, (SELECT user_id, max(save_dt) save_dt FROM VACATION_MAGAM GROUP BY user_id) b , 	 \n"+			       
				 "     ( SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD'))/12) YEAR,  \n"+
				 "               TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD'))/12) * 12) MONTH,  \n"+
				 "               TRUNC((MONTHS_BETWEEN(SYSDATE,TO_DATE(enter_dt, 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD')))) * 30.5) DAY,  \n"+
				 "               user_id, u.br_id, b.br_nm, u.dept_id, c.nm dept_nm,  \n"+
				 "               user_pos, user_nm, enter_dt  \n"+
				 "        FROM   users u, ( select c_st, code, nm_cd, nm from code where c_st = '0002' and code <> '0000'  ) c, branch b   \n"+ 
				 "        WHERE  u.use_yn='Y' AND u.user_pos IN ('�̻�', '����', '����', '����', '����', '�븮', '���', '���ϻ��')  and u.dept_id = c.code and u.br_id = b.br_id  ) u , \n"+
				 "          ( select b.user_id, nvl(count(*),0) vacation_cnt, sum(decode(iwol, 'Y', 0, decode(count, 'B1', 0.5, 'B2', 0.5, 1)))AS su ,  sum(decode(iwol, 'Y', decode(count, 'B1', 0.5, 'B2', 0.5, 1),0) ) AS iwol_su , sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt from sch_prv a, users b   \n"+
				 "         where start_year||start_mon||start_day between to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4) and to_char(to_date(to_char(sysdate,'yyyy')+1||substr(b.enter_dt,5,4))-1, 'yyyymmdd')  and sch_chk ='3'  AND nvl(gj_ck,'Y') = 'Y'		and to_number(to_char(sysdate,'mmdd')) >= to_number(substr(b.enter_dt,5,4))  	and a.user_id(+) = b.user_id  	group by b.user_id  \n"+
				 "             union  \n"+
				 "          select b.user_id, nvl(count(*),0) vacation_cnt, sum(decode(iwol, 'Y', 0, decode(count, 'B1', 0.5, 'B2', 0.5, 1)))AS su ,  sum(decode(iwol, 'Y', decode(count, 'B1', 0.5, 'B2', 0.5, 1),0) ) AS iwol_su , sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt from sch_prv a, users b   \n"+
				 "            where start_year||start_mon||start_day between (to_char(sysdate,'yyyy')-1)||substr(b.enter_dt,5,4) and  to_char(to_date(to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4))-1  , 'yyyymmdd')  and sch_chk ='3'  AND nvl(gj_ck,'Y') = 'Y'		and to_number(to_char(sysdate,'mmdd')) < to_number(substr(b.enter_dt,5,4))  and a.user_id(+) = b.user_id  	group by b.user_id  ) c  \n"+
				 "        WHERE a.USER_ID = b.user_id AND a.SAVE_DT = b.save_dt and a.user_id = u.user_id  \n"+
				 "             and a.user_id = c.user_id(+)  \n"+
				 "             and a.user_id= ?  ";				        
		 
		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, user_id);
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

		}catch(SQLException e){
			System.out.println("[VacationDatabase:getVacation(String user_id)]"+e);
			System.out.println("[VacationDatabase:getVacation(String user_id)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}

	/**
	*	����ں� �����ϼ�,����ϼ�,�����ϼ� ��� - 2005.12.27.ȭ.
	*/
	public Vector getVacationAll(String br_id, String dept_id, String user_nm){
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";

		if(!br_id.equals(""))	subQuery = "  and b.br_id='"+br_id+"' ";
		if(!dept_id.equals("")) subQuery += " and b.dept_id='"+dept_id+"' ";
		if(!user_nm.equals("")) subQuery += " and b.user_nm like '%"+user_nm+"%' ";

		query = "SELECT b.*, "+
				" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12) YEAR,  "+
				" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD')) -  "+
				" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12) * 12) MONTH,  "+
				" TRUNC((MONTHS_BETWEEN(SYSDATE,TO_DATE(b.enter_dt, 'YYYYMMDD')) -  "+
				" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD')))) * 30.5) DAY, "+
				" decode(TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12), "+
				" 		0,TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12) * 12), "+
				" 		1,15, 2,15, 3,16, 4,16, 5,17, 6,17,	7,18, 8,18, 9,19, 10,19, 11,20, 12,20, 13,21, 14,21, 15,22, 16,22, 17,23, 18,23, 19,24, 20,24, "+
				"		decode(sign(TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12)-21),0,25,1,25,0) "+
				"		) VACATION, "+
				" nvl(decode(TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12), "+
				"            0, d.vacation_cnt, 1, decode(substr(b.enter_dt,0,4),'2004',c.vacation_cnt,d.vacation_cnt), c.vacation_cnt "+
				"           ) "+
				"  ,0) V_CNT "+
				" FROM DUAL a, (select user_id, br_id, decode(br_id,'S1','����','B1','�λ�����','D1','��������','S2','��������','J1','��������','G1','�뱸����','I1','��õ����','S3','��������','S4','��������','U1','�������','S5','��ȭ������','S6','��������') br_nm,   "+
				"					   dept_id, decode(dept_id,'0001','������','0002','��������','0003','�ѹ���','0005','IT��','') dept_nm,   "+
				"					   user_pos,user_nm, enter_dt   "+
				"			from users where use_yn='Y') b,  "+
				"	   (select b.user_id, nvl(count(*),0) vacation_cnt   "+
				"		from sch_prv a, users b   "+
				"		where start_year||start_mon||start_day between to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4) and to_char(sysdate,'yyyy')+1||substr(b.enter_dt,5,4)-1  "+
				"		and sch_chk ='3'  "+
				"		and to_number(to_char(sysdate,'mmdd')) >= to_number(substr(b.enter_dt,5,4))  "+
				"		and a.user_id(+) = b.user_id  "+
				"		group by b.user_id		  "+
				"		union  "+
				"		select b.user_id, nvl(count(*),0) vacation_cnt   "+
				"		from sch_prv a, users b   "+
				"		where start_year||start_mon||start_day between (to_char(sysdate,'yyyy')-1)||substr(b.enter_dt,5,4) and to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4)-1  "+
				"		and sch_chk ='3'  "+
				"		and to_number(to_char(sysdate,'mmdd')) < to_number(substr(b.enter_dt,5,4))  "+
				"		and a.user_id(+) = b.user_id  "+
				"		group by b.user_id  "+
				"		) c, "+
				"		(select b.user_id, nvl(count(*),0) vacation_cnt "+
				"		from sch_prv a, users b "+
				"		where start_year||start_mon||start_day between b.enter_dt and substr(b.enter_dt,0,4)+2||substr(b.enter_dt,5,4)-1 "+
				"		and sch_chk ='3' "+
				"		and a.user_id(+) = b.user_id "+
				"		group by b.user_id "+
				"		) d "+
				" where b.user_id=c.user_id(+) and b.user_id=d.user_id(+) and b.dept_id in ('0001','0002','0003','0005','0007','0008','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018' , '0020') "+
				subQuery+
				" order by decode(sign(to_number(substr(b.enter_dt,5,2))-to_number(to_char(sysdate,'mm'))),-1,  "+
				"                 to_number(to_char(sysdate,'mm'))-to_number(substr(b.enter_dt,5,2))-12,  "+
				"                 to_number(to_char(sysdate,'mm'))-to_number(substr(b.enter_dt,5,2))  "+
				"         ) desc , substr(b.enter_dt,7,2)	   ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();

			while(rs.next()){
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

		}catch(SQLException e){
			System.out.println("[VacationDatabase:getVacationAll()]"+e);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return vt;
		}		
	}

	/**
	*	����ں� �����ϼ�,����ϼ�,�����ϼ� ��� - 2007.2.14.��
	*/
	public Vector getVacationAll2(String br_id, String dept_id, String user_nm){
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";

		if(!br_id.equals(""))	subQuery = "  and b.br_id='"+br_id+"' ";
		if(!dept_id.equals("")) subQuery += " and b.dept_id='"+dept_id+"' ";
		if(!user_nm.equals("")) subQuery += " and b.user_nm like '%"+user_nm+"%' ";

	

				query = " SELECT to_char(to_date( case when trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'yyyymmdd'))/12 *12) >=24 then to_char(add_months(to_date(b.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') else  to_char( add_months(to_date(b.enter_dt, 'yyyymmdd'),24 ), 'yyyymmdd') end)-1, 'yyyymmdd') END_DT,  b.*, \n"+
				" trunc(MONTHS_BETWEEN(TO_DATE(case when trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'yyyymmdd'))/12 *12) >=24 then to_char(add_months(to_date(b.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') else  to_char( add_months(to_date(b.enter_dt, 'yyyymmdd'),24 ), 'yyyymmdd') end), sysdate))RE_MONTH,   \n"+
				" ceil(MOD(MONTHS_BETWEEN(TO_DATE(case when trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'yyyymmdd'))/12 *12) >=24 then to_char(add_months(to_date(b.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') else  to_char( add_months(to_date(b.enter_dt, 'yyyymmdd'),24 ), 'yyyymmdd') end), sysdate) ,1 ) * 30) RE_DAY,  \n"+
				" decode(b.YEAR,  \n"+//+decode(b.YEAR,0,0,1)
				" 		0,b.MONTH,  \n"+//1��̸��ڴ� ������
				" 		1,15, 2,15, 3,16, 4,16, 5,17, 6,17,	7,18, 8,18, 9,19, 10,19, 11,20, 12,20, 13,21, 14,21, 15,22, 16,22, 17,23, 18,23, 19,24, 20,24,  \n"+
				"		decode(sign(b.YEAR-21),0,25,1,25,0)  \n"+
				"		) VACATION,  \n"+
				" nvl(decode(b.YEAR,  \n"+
				"            0, d.vacation_cnt, 1, decode(substr(b.enter_dt,0,4),'2004',c.vacation_cnt,d.vacation_cnt), c.vacation_cnt  \n"+
				"           )  \n"+
				"  ,0) V_CNT,  \n"+
				" nvl(decode(b.YEAR,  \n"+
				"            0, d.ov_cnt, 1, decode(substr(b.enter_dt,0,4),'2004',c.ov_cnt,d.ov_cnt), c.ov_cnt  \n"+
				"           )  \n"+
				"  ,0) OV_CNT , nvl( decode(TRUNC( MONTHS_BETWEEN( SYSDATE, TO_DATE( b.enter_dt, 'YYYYMMDD' ))/ 12 ), 0, d.su, 1, decode( substr( b.enter_dt, 0, 4 ), '2004', c.su, d.su ), c.su ), 0 ) su \n"+
				" FROM DUAL a, (select  \n"+
				"					TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD'))/12) YEAR,   \n"+
				"					TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD')) -   \n"+
				"					TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD'))/12) * 12) MONTH,   \n"+
				"					TRUNC((MONTHS_BETWEEN(SYSDATE,TO_DATE(enter_dt, 'YYYYMMDD')) -   \n"+
				"					TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD')))) * 30.5) DAY,  \n"+
				" 					   user_id, br_id, decode(br_id,'S1','����','B1','�λ�����','D1','��������','S2','��������','J1','��������','G1','�뱸����','I1','��õ����','S3','��������','S4','��������','U1','�������','S5','��ȭ������','S6','��������') br_nm,    \n"+
				"					   dept_id, decode(dept_id,'0001','������','0002','��������','0003','�ѹ���','0005','IT��','0007','�λ�����','0008','��������','0009','��������','0010','��������','0011','�뱸����','0012','��õ����','0014','��������','0015','��������','0016','�������','0017','��ȭ������','0018','��������') dept_nm,    \n"+
				"					   user_pos,user_nm, enter_dt    \n"+
				"			from users where use_yn='Y' and user_pos in  ('�̻�','����', '����', '����', '����', '�븮', '���', '���ϻ��') ) b,   \n"+
				"	   (select b.user_id, sum(decode(count, 'B1', 0.5, 'B2', 0.5, '��������',0.5,'���Ĺ���',0.5, '��������',0.5,'���Ĺ���',0.5,1))as su, sum(decode(ov_yn, 'Y', 0, 1)) vacation_cnt,  sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt    \n"+
				"		from sch_prv a, users b    \n"+
				"		where start_year||start_mon||start_day between to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4) and to_char(sysdate,'yyyy')+1||substr(b.enter_dt,5,4)-1   \n"+
				"		and sch_chk ='3'   \n"+
				"		and to_number(to_char(sysdate,'mmdd')) >= to_number(substr(b.enter_dt,5,4)) and nvl(a.gj_ck,'Y') = 'Y'  \n"+
				"		and a.user_id(+) = b.user_id   \n"+
				"		group by b.user_id		   \n"+
				"		union   \n"+
			//	"		select b.user_id, nvl(count(*),0) vacation_cnt,  sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt    \n"+
				"		select b.user_id,  sum(decode(count, 'B1', 0.5, 'B2', 0.5, '��������',0.5,'���Ĺ���',0.5, '��������',0.5,'���Ĺ���',0.5,1))as su, sum(decode(ov_yn, 'Y', 0, 1)) vacation_cnt,  sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt    \n"+
				"		from sch_prv a, users b    \n"+
				"		where start_year||start_mon||start_day between (to_char(sysdate,'yyyy')-1)||substr(b.enter_dt,5,4) and to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4)-1   \n"+
				"		and sch_chk ='3'   \n"+
				"		and to_number(to_char(sysdate,'mmdd')) < to_number(substr(b.enter_dt,5,4)) and nvl(a.gj_ck,'Y') = 'Y'   \n"+
				"		and a.user_id(+) = b.user_id   \n"+
				"		group by b.user_id   \n"+
				"		) c,  \n"+
				"		(select b.user_id, sum(decode(count, 'B1', 0.5, 'B2', 0.5, '��������',0.5,'���Ĺ���',0.5, '��������',0.5,'���Ĺ���',0.5,1))as su, sum(decode(ov_yn, 'Y', 0, 1)) vacation_cnt,  sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt  \n"+
				"		from sch_prv a, users b  \n"+
				"		where start_year||start_mon||start_day between b.enter_dt and substr(b.enter_dt,0,4)+2||substr(b.enter_dt,5,4)-1  and nvl(a.gj_ck,'Y') = 'Y'  \n"+
				"		and sch_chk ='3'  \n"+
				"		and a.user_id(+) = b.user_id  \n"+
				"		group by b.user_id  \n"+
				"		) d  \n"+
				" where b.user_id=c.user_id(+) and b.user_id=d.user_id(+) and b.dept_id in ('0001','0002','0003','0005', '0007', '0008','0009','0010','0011','0012','0013','0014','0015','0016','0017','0018' , '0020')  \n"+
				subQuery+
				"  \n order by decode(sign(to_number(substr(b.enter_dt,5,2))-to_number(to_char(sysdate,'mm'))),-1,   \n"+
				"                 to_number(to_char(sysdate,'mm'))-to_number(substr(b.enter_dt,5,2))-12,   \n"+
				"                 to_number(to_char(sysdate,'mm'))-to_number(substr(b.enter_dt,5,2))   \n"+
				"         ) desc , substr(b.enter_dt,7,2)	   ";

		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			

			ResultSetMetaData rsmd = rs.getMetaData();

			while(rs.next()){
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

		}catch(SQLException e){
			System.out.println("[VacationDatabase:getVacationAll2()]"+e);
			System.out.println("[VacationDatabase:getVacationAll2()]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return vt;
		}		
	}

	/**
	 *	����ں� ������볻�� - 2005.12.27.ȭ.
	 */
	public Vector getVacationList(String user_id, String year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

	/*	if(year.equals("0") ){ //1��̸� 
			query = " select a.* , decode(to_char( to_date(a.start_year||a.start_mon||a.start_day, 'yyyymmdd'), 'd'), '1', '�Ͽ���', '2', '������', '3', 'ȭ����', '4', '������', '5', '�����', '6', '�ݿ���', '7', '�����' ) day_nm  "+
			"		from sch_prv a, users b  "+
			"		where start_year||start_mon||start_day between b.enter_dt and substr(b.enter_dt,0,4)+1||substr(b.enter_dt,5,4)-1  "+
			"		and sch_chk ='3'  "+
			"		and a.user_id = b.user_id(+)  and nvl(a.gj_ck, 'Y') = 'Y' "+
			"		and b.user_id='"+user_id+"'	 "+
			"		order by 3,4,5 ";
		}else{ */
			query = " select a.*, decode(to_char( to_date(a.start_year||a.start_mon||a.start_day, 'yyyymmdd'), 'd'), '1', '�Ͽ���', '2', '������', '3', 'ȭ����', '4', '������', '5', '�����', '6', '�ݿ���', '7', '�����' ) day_nm "+
			"		from sch_prv a, users b  "+
			"		where start_year||start_mon||start_day between to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4) and to_char(sysdate,'yyyy')+1||substr(b.enter_dt,5,4)-1  "+
			"		and sch_chk ='3'  "+
			"		and to_number(to_char(sysdate,'mmdd')) >= to_number(substr(b.enter_dt,5,4))  "+
			"		and a.user_id = b.user_id(+)  and nvl(a.gj_ck, 'Y') = 'Y'  "+
			"		and b.user_id='"+user_id+"'	 "+ //1���̻��� 
			"		union  "+
			"		select a.*, decode(to_char( to_date(a.start_year||a.start_mon||a.start_day, 'yyyymmdd'), 'd'), '1', '�Ͽ���', '2', '������', '3', 'ȭ����', '4', '������', '5', '�����', '6', '�ݿ���', '7', '�����' ) day_nm "+
			"		from sch_prv a, users b   "+
			"		where start_year||start_mon||start_day between (to_char(sysdate,'yyyy')-1)||substr(b.enter_dt,5,4) and to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4)-1  "+
			"		and sch_chk ='3'  "+
			"		and to_number(to_char(sysdate,'mmdd')) < to_number(substr(b.enter_dt,5,4))  "+
			"		and a.user_id = b.user_id(+) and nvl(a.gj_ck, 'Y') = 'Y'  "+
			"		and b.user_id='"+user_id+"'	 "+  //1�� �̸� 
			"		order by 3,4,5 ";
	//	}

			//System.out.println("getVacationList= "+query);

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			while(rs.next()){
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
			System.out.println("[VacationDatabase:getVacationList(String user_id)]"+e);
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
	 *	����ں� ���� ���� ī��Ʈ - 2011.08.17
	 */
	public Hashtable getVacationBan(String user_id){
		getConnection();
		Hashtable ht = new Hashtable();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

	
		query = " SELECT count(decode(count, 'B1',1)) as B1,count(decode(count, 'B2',1)) as B2 "+
				" FROM sch_prv WHERE sch_chk = '3' AND COUNT IS NOT NULL  AND nvl( gj_ck, 'Y' ) = 'Y' "+
				" AND user_id = ?";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, user_id);
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

		}catch(SQLException e){
			System.out.println("[VacationDatabase:getVacationBan(String user_id)]"+e);
			System.out.println("[VacationDatabase:getVacationBan(String user_id)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}

	/**
	 *	����ں� ������� ī��Ʈ - 2012.10.29
	 */
	public Hashtable getVacationBan2(String user_id){
		getConnection();
		Hashtable ht = new Hashtable();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

	
		query = " SELECT b.user_id,  \n"+
				"	sum(decode(count, 'B1', 0.5, 'B2', 0.5, '��������',0.5,'���Ĺ���',0.5, '��������',0.5,'���Ĺ���',0.5,1))AS su,  \n"+
				"	sum(decode(ov_yn, 'Y', 0, 1)) vacation_cnt,  \n"+
				"	sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt, \n"+
				"	count(decode(count, 'B1',1)) AS B1,  \n"+
				"	count(decode(count, 'B2',1)) AS B2  \n"+
				"	FROM sch_prv a, users b  \n"+
				"	WHERE a.start_year||a.start_mon||a.start_day BETWEEN to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4) AND to_char(to_date(to_char(sysdate,'yyyy')+1||substr(b.enter_dt,5,4))-1, 'yyyymmdd')   \n"+
				"	AND sch_chk ='3'  \n"+
				"	AND to_number(to_char(sysdate,'mmdd')) >= to_number(substr(b.enter_dt,5,4))  \n"+
				"	AND nvl(a.gj_ck,'Y') = 'Y'  and nvl(a.iwol, 'N')  <> 'Y' \n"+
				"	AND a.user_id(+) = b.user_id  \n"+
				"	AND a.USER_ID = ? \n"+
				"	GROUP BY b.user_id  \n"+
				"	UNION  \n"+
				"	SELECT b.user_id,  \n"+
				"	sum(decode(count, 'B1', 0.5, 'B2', 0.5, '��������',0.5,'���Ĺ���',0.5, '��������',0.5,'���Ĺ���',0.5,1))AS su,  \n"+
				"	sum(decode(ov_yn, 'Y', 0, 1)) vacation_cnt,  \n"+
				"	sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt, \n"+
				"	count(decode(count, 'B1',1)) AS B1,  \n"+
				"	count(decode(count, 'B2',1)) AS B2   \n"+
				"	FROM sch_prv a,  \n"+
				"	users b  \n"+
				"	WHERE a.start_year||a.start_mon||a.start_day BETWEEN (to_char(sysdate,'yyyy')-1)||substr(b.enter_dt,5,4) AND  to_char(to_date(to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4))-1  , 'yyyymmdd')  \n"+
				"	AND sch_chk ='3'  \n"+
				"	AND to_number(to_char(sysdate,'mmdd')) < to_number(substr(b.enter_dt,5,4))  \n"+
				"	AND nvl(a.gj_ck,'Y') = 'Y' and nvl(a.iwol, 'N')  <> 'Y'  \n"+
				"	AND a.user_id(+) = b.user_id  \n"+
				"	AND a.USER_ID = ? \n"+
				"	GROUP BY b.user_id ";


		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, user_id);
			pstmt.setString(2, user_id);
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

		}catch(SQLException e){
			System.out.println("[VacationDatabase:getVacationBan2(String user_id)]"+e);
			System.out.println("[VacationDatabase:getVacationBan2(String user_id)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}

	
	/**
	 *	����ں� �̻�뿬���뺸���� - 2005.12.27.ȭ.
	 */
	public Vector getVacationForceList(String user_id, String year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

			query = " select a.* , decode(to_char( to_date(a.start_year||a.start_mon||a.start_day, 'yyyymmdd'), 'd'), '1', '�Ͽ���', '2', '������', '3', 'ȭ����', '4', '������', '5', '�����', '6', '�ݿ���', '7', '�����' ) day_nm \n"+
			"		from sch_force a, users b  "+
			"		where a.start_year||a.start_mon||a.start_day between to_char( add_months( to_date(case when trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt))/12 *12) >=12 then to_char(add_months(to_date(b.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') else  to_char( add_months(to_date(b.enter_dt, 'yyyymmdd'),12 ), 'yyyymmdd') end ), -3 ), 'yyyymmdd')    and case when trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt))/12 *12) >=12 then to_char(add_months(to_date(b.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') else  to_char( add_months(to_date(b.enter_dt, 'yyyymmdd'),12 ), 'yyyymmdd') end  "+
	//		"		where a.start_year||a.start_mon||a.start_day between to_char( add_months( to_date(case when trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt))/12 *12) >=24 then to_char(add_months(to_date(b.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') else  to_char( add_months(to_date(b.enter_dt, 'yyyymmdd'),24 ), 'yyyymmdd') end ), -3 ), 'yyyymmdd')    and case when trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt))/12 *12) >=24 then to_char(add_months(to_date(b.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') else  to_char( add_months(to_date(b.enter_dt, 'yyyymmdd'),24 ), 'yyyymmdd') end  "+
			"		and a.sch_chk ='3'  "+
			"		and a.user_id(+) = b.user_id  "+
			"		and b.user_id='"+user_id+"'	 "+
			"		order by 3,4,5 ";
 
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			while(rs.next()){
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
			System.out.println("[VacationDatabase:getVacationList(String user_id)]"+e);
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
	 *	�������� ���ν��� ȣ��
	*/
	/*
	public String call_p_vacation_magam()
	{
    	getConnection();
    	
    	String query = "{CALL P_VACATION_MAGAM (?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.registerOutParameter( 1, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(1); // �����
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[VacationDatabase:call_p_vacation_magam]\n"+e);
			System.out.println("[VacationDatabase:call_p_vacation_magam]\n"+query);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}
*/

public String call_p_vacation_magam()
	{
    	getConnection();
    	
    	String query = "{CALL P_VACATION_MAGAM }";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);					
			cstmt.execute();
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[VacationDatabase:call_p_vacation_magam]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	



	/**
	*	����ں� �����ϼ�,����ϼ�,�����ϼ� ���_NEW
	*/
	
	public Vector getVacationAll2_new(String br_id, String dept_id, String user_nm){
		getConnection();
		Vector vt = new Vector();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";

		if(!br_id.equals(""))	subQuery = "  and u.br_id='"+br_id+"' ";
		if(!dept_id.equals("")) subQuery += " and u.dept_id='"+dept_id+"' ";
		if(!user_nm.equals("")) subQuery += " and u.user_nm like '%"+user_nm+"%' ";

	/*

		query = " SELECT trunc(sysdate - to_date(b.enter_dt, 'yyyymmdd' ) ) t_days, a.END_DT, a.VACATION, b.*, \n"+
				"trunc(MONTHS_BETWEEN(TO_DATE \n"+
				" ( \n"+
				" CASE \n"+
				" WHEN trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'yyyymmdd'))/12 *12) >=24 \n"+
				" THEN to_char(add_months(to_date(b.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') \n"+
				" ELSE to_char( add_months(to_date(b.enter_dt, 'yyyymmdd'),24 ), 'yyyymmdd') \n"+
				" END \n"+
				" , 'yyyymmdd') \n"+
				" , sysdate))RE_MONTH,  \n"+  
				" ceil(MOD(MONTHS_BETWEEN(TO_DATE ( CASE \n"+
				" WHEN trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'yyyymmdd'))/12 *12) >=24 \n"+
				" THEN to_char(add_months(to_date(b.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') \n"+
				" ELSE to_char( add_months(to_date(b.enter_dt, 'yyyymmdd'),24 ), 'yyyymmdd') END, 'yyyymmdd' ), sysdate) ,1 ) * 30) RE_DAY,  \n"+  // �̻�뿬��  �Ҹ� ���� �Ⱓ
				" nvl(decode(b.YEAR, 0, d.ov_cnt, 1, d.ov_cnt, c.ov_cnt ) ,0) OV_CNT , \n"+ //����
				" nvl( decode(TRUNC( MONTHS_BETWEEN( SYSDATE, TO_DATE( b.enter_dt, 'YYYYMMDD' ))/ 12 ), 0, d.su,  c.su ), 0 ) su \n"+
				" FROM (SELECT a.user_id, a.end_dt, a.vacation, a.save_dt FROM VACATION_MAGAM a, (SELECT user_id, max(save_dt) save_dt FROM VACATION_MAGAM GROUP BY user_id) b WHERE a.USER_ID = b.user_id AND a.SAVE_DT = b.save_dt) a, \n"+
				" (SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD'))/12) YEAR, \n"+
				" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD'))/12) * 12) MONTH, \n"+
				" TRUNC((MONTHS_BETWEEN(SYSDATE,TO_DATE(enter_dt, 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD')))) * 30.5) DAY, \n"+ //��� �ٹ��Ⱓ
				" user_id, u.br_id, b.br_nm, u.dept_id, c.nm dept_nm, \n"+
				" u.loan_st, text_decrypt(u.user_ssn,'pw') user_ssn, \n"+	//��,��,��,�ܱ��� ��� ������� �߰�(2018.05.04)
				"  user_pos, user_nm,  enter_dt FROM users u, ( select c_st, code, nm_cd, nm from code where c_st = '0002' and code <> '0000'  ) c  , branch b WHERE u.use_yn='Y'   \n"+
				"  AND u.user_pos IN ('�̻�', '����', '����', '����', '����', '�븮', '���', '���ϻ��')  and u.dept_id = c.code and u.br_id = b.br_id   ) b, \n"+
				" (SELECT b.user_id, sum(decode(count, 'B1', 0.5, 'B2', 0.5, '��������',0.5,'���Ĺ���',0.5,1))AS su, sum(decode(ov_yn, 'Y', 0, 1)) vacation_cnt, sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt \n"+
				"	 FROM sch_prv a, users b   \n"+	
				" 	WHERE start_year||start_mon||start_day BETWEEN to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4) AND to_char(sysdate,'yyyy')+1||substr(b.enter_dt,5,4)-1 \n"+
				" 	AND sch_chk ='3' AND to_number(to_char(sysdate,'mmdd')) >= to_number(substr(b.enter_dt,5,4)) AND nvl(a.gj_ck,'Y') = 'Y' \n"+	//  and b.user_id not in ( '000177')  \n"+			
				"	 AND a.user_id(+) = b.user_id  GROUP BY b.user_id \n"+
				"	 UNION \n"+
				"	 SELECT b.user_id, sum(decode(count, 'B1', 0.5, 'B2', 0.5, '��������',0.5,'���Ĺ���',0.5,1))AS su, sum(decode(ov_yn, 'Y', 0, 1)) vacation_cnt, \n"+
				"	 sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt  FROM sch_prv a, users b WHERE start_year||start_mon||start_day BETWEEN (to_char(sysdate,'yyyy')-1)||substr(b.enter_dt,5,4) AND to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4)-1 \n"+
				"	 AND sch_chk ='3' AND to_number(to_char(sysdate,'mmdd')) < to_number(substr(b.enter_dt,5,4)) AND nvl(a.gj_ck,'Y') = 'Y' \n"+
				"	 AND a.user_id(+) = b.user_id  GROUP BY b.user_id  ) c, \n"+  //2���̻����� ���  ������밹��
				" (SELECT b.user_id, sum(decode(count, 'B1', 0.5, 'B2', 0.5, '��������',0.5,'���Ĺ���',0.5,1))AS su, sum(decode(ov_yn, 'Y', 0, 1)) vacation_cnt,  sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt  FROM sch_prv a, users b \n"+
				" WHERE start_year||start_mon||start_day BETWEEN b.enter_dt AND substr(b.enter_dt,0,4)+2||substr(b.enter_dt,5,4)-1  AND nvl(a.gj_ck,'Y') = 'Y' AND sch_chk ='3' AND a.user_id(+) = b.user_id GROUP BY b.user_id ) d \n"+  // �Ի�2����� ��뿬�� ����
				" WHERE a. USER_ID = b.USER_ID AND b.user_id=c.user_id(+) AND b.user_id=d.user_id(+) \n"+
				//" and b.user_id not in ( '000177') \n"+
				" and b.dept_id IN ('0001','0002','0003','0005', '0007', '0008','0009','0010','0011', '0012', '0013','0014','0015','0016','0017','0018','0020') \n"+
				subQuery+
				" ORDER BY decode(sign(to_number(substr(b.enter_dt,5,2))-to_number(to_char(sysdate,'mm'))),-1, to_number(to_char(sysdate,'mm'))-to_number(substr(b.enter_dt,5,2))-12, to_number(to_char(sysdate,'mm'))-to_number(substr(b.enter_dt,5,2)) ) desc , \n"+
				" substr(b.enter_dt,7,2) \n";
*/
		       
	//	query = " SELECT trunc(sysdate - to_date(u.enter_dt, 'yyyymmdd' ) ) t_days, a.END_DT, a.VACATION, a.remain, a.due_dt, u.*, \n"+
		query = " SELECT trunc(sysdate - to_date(u.enter_dt, 'yyyymmdd' ) ) t_days, a.END_DT, a.VACATION, a.remain, a.due_dt ,  to_char(to_date(a.end_dt)+30 , 'yyyymmdd') c_due_dt , \n"+
	            "   to_char(add_months(to_date(a.end_dt, 'yyyymmdd'), -3) , 'yyyymmdd') d_90_dt ,  to_char(sysdate,'YYYYMMdd') today ,   u.*, \n"+
				"	trunc(MONTHS_BETWEEN(TO_DATE \n"+
				"	 ( \n"+
				"	 CASE  \n"+
				"	 WHEN trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(u.enter_dt, 'yyyymmdd'))/12 *12) >=24  \n"+
				"	 THEN to_char(add_months(to_date(u.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(u.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') \n"+
				"	 ELSE to_char( add_months(to_date(u.enter_dt, 'yyyymmdd'),24 ), 'yyyymmdd') \n"+
				"	 END \n"+
				"	 , 'yyyymmdd') \n"+
				"	 , sysdate))RE_MONTH,  \n"+  
				"	 ceil(MOD(MONTHS_BETWEEN(TO_DATE ( CASE \n"+  
				"	 WHEN trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(u.enter_dt, 'yyyymmdd'))/12 *12) >=24 \n"+  
				"	 THEN to_char(add_months(to_date(u.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(u.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') \n"+  
				"	 ELSE to_char( add_months(to_date(u.enter_dt, 'yyyymmdd'),24 ), 'yyyymmdd') END, 'yyyymmdd' ), sysdate) ,1 ) * 30) RE_DAY , \n"+    //�����ϼ� (�������� ��������)
				"	 NVL(c.ov_cnt, 0) ov_cnt , \n"+   // ���� ,
				"	 NVL(c.su, 0) su ,\n" +  // ���
				"	 NVL(c.iwol_su, 0) iwol_su \n" +  // �̿����
				
		        "    FROM VACATION_MAGAM a, (SELECT user_id, max(save_dt) save_dt FROM VACATION_MAGAM GROUP BY user_id) b ,  \n"+					      
				"	      ( SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD'))/12) YEAR,  \n"+
				"	 TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD'))/12) * 12) MONTH,  \n"+
				"	 TRUNC((MONTHS_BETWEEN(SYSDATE,TO_DATE(enter_dt, 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD')))) * 30.5) DAY,  \n"+
				"	 u.user_id, u.br_id, b.br_nm, u.dept_id, c.nm dept_nm, \n"+
				"	 u.loan_st, substr(text_decrypt(u.user_ssn,'pw') , 1, 8) user_ssn,  \n"+
				"	  user_pos, user_nm,  enter_dt FROM users u, ( select c_st, code, nm_cd, nm from code where c_st = '0002' and code <> '0000'  ) c  , branch b WHERE u.use_yn='Y' \n"+
				"	  AND u.user_pos IN ('�̻�', '����', '����', '����', '����', '�븮', '���', '���ϻ��')  and u.dept_id = c.code and u.br_id = b.br_id  ) u ,  \n"+
		        "  ( select b.user_id, nvl(count(*),0) vacation_cnt,sum(decode(iwol, 'Y', 0, decode(count, 'B1', 0.5, 'B2', 0.5, 1)))AS su ,  sum(decode(iwol, 'Y', decode(count, 'B1', 0.5, 'B2', 0.5, 1),0) ) AS iwol_su , sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt from sch_prv a, users b  \n"+
		        " 	where start_year||start_mon||start_day between to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4) and  to_char(to_date(to_char(sysdate,'yyyy')+1||substr(b.enter_dt,5,4))-1, 'yyyymmdd')  and sch_chk ='3' AND nvl(gj_ck,'Y') = 'Y'  and to_number(to_char(sysdate,'mmdd')) >= to_number(substr(b.enter_dt,5,4))  		and a.user_id(+) = b.user_id  		group by b.user_id \n"+
		        "     union \n"+	
		        "  select b.user_id, nvl(count(*),0) vacation_cnt,sum(decode(iwol, 'Y', 0, decode(count, 'B1', 0.5, 'B2', 0.5, 1)))AS su ,  sum(decode(iwol, 'Y', decode(count, 'B1', 0.5, 'B2', 0.5, 1),0) ) AS iwol_su , sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt from sch_prv a, users b  \n"+
		        "    where start_year||start_mon||start_day between (to_char(sysdate,'yyyy')-1)||substr(b.enter_dt,5,4) and  to_char(to_date(to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4))-1  , 'yyyymmdd')  and sch_chk ='3' AND nvl(gj_ck,'Y') = 'Y'  and  to_number(to_char(sysdate,'mmdd')) < to_number(substr(b.enter_dt,5,4))  		and a.user_id(+) = b.user_id  		group by b.user_id  \n"+
		        "	) c \n"+ // �������� 	
		        " WHERE a.USER_ID = b.user_id AND a.SAVE_DT = b.save_dt and a.user_id = u.user_id \n"+
		        "     and a.user_id = c.user_id(+) \n"+
		    	subQuery+
		        " ORDER BY decode(sign(to_number(substr(u.enter_dt,5,2))-to_number(to_char(sysdate,'mm'))),-1, to_number(to_char(sysdate,'mm'))-to_number(substr(u.enter_dt,5,2))-12, to_number(to_char(sysdate,'mm'))-to_number(substr(u.enter_dt,5,2)) ) desc , \n"+
		        "  substr(u.enter_dt,7,2) \n";
				
     //    System.out.println("getVacationAll2_new ="+ query);
		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			
			ResultSetMetaData rsmd = rs.getMetaData();

			while(rs.next()){
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

		}catch(SQLException e){
			System.out.println("[VacationDatabase:getVacationAll2_new()]"+e);
			System.out.println("[VacationDatabase:getVacationAll2_new()]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}

			closeConnection();
			return vt;
		}		
	}


//�� �������� ����.
 public int insertCNT_SU(String cnt_su, String user_id)
    {
		getConnection();
		
        PreparedStatement pstmt = null;
        String query = "";
     
        int count = 0;
                
        query = " UPDATE VACATION_MAGAM SET vacation = '"+cnt_su+"'  WHERE user_id = '"+user_id+"' AND save_dt =  (SELECT MAX(save_dt) last_dt FROM VACATION_MAGAM  WHERE user_id = '"+user_id+"' )     ";
       try{
            conn.setAutoCommit(false);
                       
            pstmt = conn.prepareStatement(query);
            
            count = pstmt.executeUpdate();
            
			conn.commit(); 
            pstmt.close();
        
        } catch (Exception e) {
			System.out.println("[VacationDatabase:insertCNT_SU]"+e);
			System.out.println("[VacationDatabase:insertCNT_SU]"+query);
			e.printStackTrace();
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


	/**
	*	����ں� �����ϼ�,����ϼ�,�����ϼ� ��� - 2005.12.27.ȭ.
	*/
	public Hashtable getVacation2016(String user_id){
		getConnection();
		Hashtable ht = new Hashtable();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

	
	query = " SELECT a.END_DT, b.*, \n"+
				"trunc(MONTHS_BETWEEN(TO_DATE \n"+
				" ( \n"+
				" CASE \n"+
				" WHEN trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'yyyymmdd'))/12 *12) >=24 \n"+
				" THEN to_char(add_months(to_date(b.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') \n"+
				" ELSE to_char( add_months(to_date(b.enter_dt, 'yyyymmdd'),24 ), 'yyyymmdd') \n"+
				" END \n"+
				" ) \n"+
				" , sysdate))RE_MONTH,  \n"+
				" ceil(MOD(MONTHS_BETWEEN(TO_DATE ( CASE \n"+
				" WHEN trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'yyyymmdd'))/12 *12) >=24 \n"+
				" THEN to_char(add_months(to_date(b.enter_dt, 'yyyymmdd'),(12+(12*TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(b.enter_dt, 'YYYYMMDD'))/12)))), 'yyyymmdd') \n"+
				" ELSE to_char( add_months(to_date(b.enter_dt, 'yyyymmdd'),24 ), 'yyyymmdd') END ), sysdate) ,1 ) * 30) RE_DAY, a.VACATION, \n"+
				" nvl(decode(b.YEAR, 0, d.vacation_cnt, 1, decode(substr(b.enter_dt,0,4),'2004',c.vacation_cnt,d.vacation_cnt), c.vacation_cnt ) ,0) V_CNT, \n"+
				" nvl(decode(b.YEAR, 0, d.ov_cnt, 1, decode(substr(b.enter_dt,0,4),'2004',c.ov_cnt,d.ov_cnt), c.ov_cnt ) ,0) OV_CNT , \n"+
				" nvl( decode(TRUNC( MONTHS_BETWEEN( SYSDATE, TO_DATE( b.enter_dt, 'YYYYMMDD' ))/ 12 ), 0, d.su, 1, decode( substr( b.enter_dt, 0, 4 ), '2004', c.su, d.su ), c.su ), 0 ) su \n"+
					" FROM (SELECT a.user_id, a.end_dt, a.vacation, a.save_dt FROM VACATION_MAGAM a, (SELECT user_id, max(save_dt) save_dt FROM VACATION_MAGAM GROUP BY user_id) b WHERE a.USER_ID = b.user_id AND a.SAVE_DT = b.save_dt) a, \n"+
				" (SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD'))/12) YEAR, \n"+
				" TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD'))/12) * 12) MONTH, \n"+
				" TRUNC((MONTHS_BETWEEN(SYSDATE,TO_DATE(enter_dt, 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt, 'YYYYMMDD')))) * 30.5) DAY, \n"+
				" user_id, u.br_id, b.br_nm, u.dept_id, c.nm dept_nm, \n"+
				"  user_pos, user_nm, enter_dt FROM users u, ( select c_st, code, nm_cd, nm from code where c_st = '0002' and code <> '0000'  ) c  , branch b WHERE u.use_yn='Y'   \n"+
				"  AND u.user_pos IN ('�̻�', '����', '����', '����', '����', '�븮', '���', '���ϻ��')  and u.dept_id = c.code and u.br_id = b.br_id   ) b, \n"+
				" (SELECT b.user_id, sum(decode(count, 'B1', 0.5, 'B2', 0.5, '��������',0.5,'���Ĺ���',0.5, '��������',0.5,'���Ĺ���',0.5,1))AS su, sum(decode(ov_yn, 'Y', 0, 1)) vacation_cnt, sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt \n"+
				" FROM sch_prv a, users b   \n"+	
				" WHERE start_year||start_mon||start_day BETWEEN to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4) AND to_char(sysdate,'yyyy')+1||substr(b.enter_dt,5,4)-1 \n"+
				" AND sch_chk ='3' AND to_number(to_char(sysdate,'mmdd')) >= to_number(substr(b.enter_dt,5,4)) AND nvl(a.gj_ck,'Y') = 'Y'  \n"+			
				" AND a.user_id(+) = b.user_id  GROUP BY b.user_id \n"+
				" UNION \n"+
				" SELECT b.user_id, sum(decode(count, 'B1', 0.5, 'B2', 0.5, '��������',0.5,'���Ĺ���',0.5, '��������',0.5,'���Ĺ���',0.5,1))AS su, sum(decode(ov_yn, 'Y', 0, 1)) vacation_cnt, \n"+
				" sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt  FROM sch_prv a, users b WHERE start_year||start_mon||start_day BETWEEN (to_char(sysdate,'yyyy')-1)||substr(b.enter_dt,5,4) AND to_char(sysdate,'yyyy')||substr(b.enter_dt,5,4)-1 \n"+
				" AND sch_chk ='3' AND to_number(to_char(sysdate,'mmdd')) < to_number(substr(b.enter_dt,5,4)) AND nvl(a.gj_ck,'Y') = 'Y' \n"+
				" AND a.user_id(+) = b.user_id  GROUP BY b.user_id  ) c, \n"+
				" (SELECT b.user_id, sum(decode(count, 'B1', 0.5, 'B2', 0.5, '��������',0.5,'���Ĺ���',0.5, '��������',0.5,'���Ĺ���',0.5,1))AS su, sum(decode(ov_yn, 'Y', 0, 1)) vacation_cnt, \n"+
				" sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt  FROM sch_prv a, users b \n"+
				" WHERE start_year||start_mon||start_day BETWEEN b.enter_dt AND substr(b.enter_dt,0,4)+2||substr(b.enter_dt,5,4)-1 \n"+
				" AND nvl(a.gj_ck,'Y') = 'Y' AND sch_chk ='3' AND a.user_id(+) = b.user_id GROUP BY b.user_id ) d \n"+
				" WHERE a. USER_ID = b.USER_ID AND b.user_id=c.user_id(+) AND b.user_id=d.user_id(+) and b.user_id=? AND b.dept_id IN ('0001','0002','0003', '0005', '0007', '0008','0009','0010','0011', '0012', '0013','0014','0015','0016','0017','0018') " ;				


		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, user_id);
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

		}catch(SQLException e){
			System.out.println("[VacationDatabase:getVacation(String user_id)]"+e);
			System.out.println("[VacationDatabase:getVacation(String user_id)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}



/**
	*	����ں� �����ϼ�,����ϼ�,�����ϼ� ��� - 2005.12.27.ȭ.
	*/
	public Hashtable getVacation2016DT(String user_id, String ref_dt1, String ref_dt2){
		getConnection();
		Hashtable ht = new Hashtable();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

	
	query = " SELECT a.doc_no, a.user_id USER_ID, NVL(A.START_DATE,'') START_DATE, NVL(a.end_date,'') END_DATE, b.user_nm USER_NM, a.title,  \n"+
				  " MONTHS_BETWEEN( LAST_DAY(TO_DATE(a.end_date, 'yyyymmdd')-14) + 1 , TRUNC(TO_DATE(a.start_date, 'yyyymmdd')+14, 'mm') ) m, \n"+
				  " TO_DATE(a.end_date, 'YYYYMMDD') -  TO_DATE(a.start_date, 'YYYYMMDD') +1 AS DateDiff, \n"+
				  " round((365-(TO_DATE(a.end_date, 'YYYYMMDD') -  TO_DATE(a.start_date, 'YYYYMMDD') +1))/365*100, 0) AS datep \n"+
				  " FROM  \n"+
				  " (SELECT title, work_id, cm_check, user_id, START_DATE, end_date, sch_chk, doc_no FROM free_time ) a, users b , (SELECT * FROM DOC_SETTLE WHERE doc_st = '21' )c \n"+
                  " WHERE a.user_id=b.user_id AND a.doc_no = c.doc_id(+) AND a.user_id = ? AND b.use_yn = 'Y' AND a.sch_chk IN ('5','8') ";  

	query += " and replace(a.start_date,'-','') between '"+ref_dt1+"' and '"+ref_dt2+"' ";

		try{
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, user_id);
			rs = pstmt.executeQuery();
			
//System.out.println("getVacation2016DT: "+query);

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

		}catch(SQLException e){
			System.out.println("[VacationDatabase:getVacation2016DT(String user_id)]"+e);
			System.out.println("[VacationDatabase:getVacation2016DT(String user_id)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}

   
   public Hashtable getReturnYMD(int days){
		getConnection();
		Hashtable ht = new Hashtable();
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";

	
	   query = " select trunc("+ days + "/365)  yy , trunc(mod("+days + ",365) / 30 ) mm  , mod(mod("+ days + ",365) ,30)  dd from dual " ;
	
	
		try{
			
			  stmt = conn.createStatement();
            rs = stmt.executeQuery(query);
     			
//System.out.println("getVacation2016DT: "+query);

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
			stmt.close();

		}catch(SQLException e){
			System.out.println("[VacationDatabase:getReturnYMD(int days)]"+e);
			System.out.println("[VacationDatabase:getReturnYMD(int days)]"+query);
			e.printStackTrace();
		}finally{
			try{
				if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return ht;
		}		
	}


}

