package tax;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;


public class TaxDatabase
{
	private Connection conn = null;
	public static TaxDatabase db;
	
	public static TaxDatabase getInstance()
	{
		if(TaxDatabase.db == null)
			TaxDatabase.db = new TaxDatabase();
		return TaxDatabase.db;	
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
			conn = null ;
		}		
	}


	//계약현황 리스트 - 대차료 제외
	public Vector getTaxList2(String client_id, String site_id, String s_yy, String s_mm)
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
				" decode(a.tax_type,'2',e.enp_no,decode(d.client_st,'2',d.ssn,d.enp_no)) enp_no,"+
				" a.client_id, a.seq, a.tax_type, a.item_id, a.resseq, b.pubcode, "+
				" a.reg_dt, a.fee_tm as tm, a.gubun, nvl(b.recconame,d.firm_nm) firm_nm, nvl(b.reccoregno,d.enp_no) enp_no "+
				" from tax a, saleebill b,"+
				" (select a.pubcode, a.status from eb_history a, (select pubcode, max(statusdate) statusdate from eb_history where status not in ('11','14') group by pubcode) b where a.status not in ('11','14') and a.pubcode=b.pubcode and a.statusdate=b.statusdate) c,"+
				" client d, client_site e"+
				" where a.client_id='"+client_id+"' and nvl(a.gubun,'1') not in ('13')  and a.tax_st<>'C' "+
				" and a.resseq=b.resseq(+) and b.pubcode=c.pubcode(+)"+
				" and a.client_id=d.client_id and a.client_id=e.client_id(+) and a.seq=e.seq(+) and nvl(a.rent_l_cd,'1')<>'A'";

		if(!site_id.equals("")){
			if(site_id.equals("00"))	query += " and a.seq is null ";
			else						query += " and a.seq='"+site_id+"'";
		}


		search_dt = "a.tax_dt";

		if(!s_yy.equals("") && !s_mm.equals(""))	query += " and "+search_dt+" like '%"+s_yy+s_mm+"%'";
		if(!s_yy.equals("") && s_mm.equals(""))		query += " and "+search_dt+" like '%"+s_yy+"%'";

			
		query += " order by a.tax_dt";


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
			System.out.println("[TaxDatabase:getTaxList2]\n"+e);
			System.out.println("[TaxDatabase:getTaxList2]\n"+query);
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

	//문자보내기
	public void insertsendMail_V5_H(String sendphone, String sendname, String destphone, String destname, String tax_mon, String rqdate, String msg_type, String msg_subject, String msg, String rent_l_cd, String client_id, String user_id, String dest_gubun)
	{
		getConnection();

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;

		String query = "";
			
		String cmid = "";
		String query2 = "";

		query2 = " select to_char(sysdate,'YYYYMMDDhh24miss')||nvl(ltrim(to_char(to_number(max(substr(cmid,15,5))+1), '000')), '001') cmid"+
				 " from   ums_data "+
				 " where  substr(cmid,1,14)=to_char(sysdate,'YYYYMMDDhh24miss')";

        query=" INSERT INTO ums_data "+
				" ( cmid, send_phone, send_name, dest_phone, dest_name, request_time, status, msg_type, subject, msg_body, etc2, etc3, etc4, etc5 ) "
            + " VALUES "+
				" ( ?, replace(?,'-',''), substr(?,1,10), replace(?,'-',''), substr(?,1,10), sysdate"+rqdate+", 0, ?, ?, ?, ?, ?, ?, ?) ";

		//rqdate=to_char(sysdate+0.1,'YYYYMMDDhh24miss') => 현재시간(세금계산서작성시간)으로 부터 2시간후에 발송시작

		//세금계산서 작성   : 현재시간
		//트러스빌 전송시간 : 현재시간       ~ 현재시간+1시간
		//메일발송시간      : 현재시간+1시간 ~ 현재시간+2시간
		//문자발송시간      : 현재시간+2시간 ~

		if(sendphone.equals(""))	sendphone = "027570802";
		if(sendname.equals(""))		sendname  = "아마존카";

		try 
		{
			conn.setAutoCommit(false);
		
			if(!msg.equals("")){

				pstmt2 = conn.prepareStatement(query2);
				rs = pstmt2.executeQuery();
   	
				if(rs.next())
				{				
					cmid = rs.getString(1);
				}
				rs.close();
				pstmt2.close();

				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, cmid			);
				pstmt.setString(2, sendphone	);
				pstmt.setString(3, sendname		);
				pstmt.setString(4, destphone	);
				pstmt.setString(5, destname		);
				pstmt.setString(6, msg_type		);
				pstmt.setString(7, msg_subject	);
				pstmt.setString(8, msg			);
				pstmt.setString(9, rent_l_cd	);
				pstmt.setString(10,client_id	);
				pstmt.setString(11,user_id		);
				pstmt.setString(12,dest_gubun	);
				pstmt.executeUpdate();	
				pstmt.close();
			}

			conn.commit();							 
		
	 	} catch (Exception e) {
            try{
				System.out.println("[TaxDatabase:insertsendMail_V5]\n"+e);
				System.out.println("[sendphone	]\n"+sendphone	);
				System.out.println("[sendname	]\n"+sendname	);
				System.out.println("[destphone	]\n"+destphone	);
				System.out.println("[destname	]\n"+destname	);
				System.out.println("[msg_type	]\n"+msg_type	);
				System.out.println("[msg_subject]\n"+msg_subject);
				System.out.println("[msg		]\n"+msg		);
				System.out.println("[rent_l_cd	]\n"+rent_l_cd	);
				System.out.println("[client_id	]\n"+client_id	);
				System.out.println("[user_id	]\n"+user_id	);
				System.out.println("[dest_gubun	]\n"+dest_gubun	);
                conn.rollback();
				e.printStackTrace();
		  		flag = false;
            }catch(SQLException _ignored){}
		} finally {
			try{	
				conn.setAutoCommit(true);
				if(rs != null)		rs.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt != null)	pstmt.close();				
			}catch(Exception ignore){}
			closeConnection();
		}			
	}
   

}