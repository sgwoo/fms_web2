package card;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.client.*;
import acar.common.*;
import acar.cont.*;
import acar.fee.*;
import acar.util.*;
import acar.res_search.*;
import acar.user_mng.*;

public class JungSanDatabase
{
	private Connection conn = null;
	public static JungSanDatabase db;
	
	public static JungSanDatabase getInstance()
	{
		if(JungSanDatabase.db == null)
			JungSanDatabase.db = new JungSanDatabase();
		return JungSanDatabase.db;	
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
	
  
 	//정산서 보기 -임원포함
	public Vector getCardJungDtStatINew(String dt, String ref_dt1, String ref_dt2, String br_id, String dept_id, String user_id, String s_yy)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
     	
		String f_date1="";
		String t_date1="";
	
		String s_year = s_yy;
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		
		if(dt.equals("2")) { //전반기 1월~6월
			f_date1 = s_year+ "0101";
			t_date1 = s_year+ "0630";
		}
		if(dt.equals("5")) {//후반기 7월~12월
			f_date1 = s_year+ "0701";
			t_date1 = s_year+ "1231";
		}
		if(dt.equals("3")) {
			f_date1 = s_year+ "0101";
			t_date1 = s_year+ "1231";
		}
		
		if(dt.equals("4")) {
			if(!ref_dt1.equals("")) {
				f_date1=  ref_dt1;
				t_date1=  ref_dt2;
			} else {
				f_date1 = s_year+ "0101";
				t_date1 = s_year+ "1231";
			}		
		}
		
		
		query = " SELECT u.use_yn, a.user_id, u.user_nm, u.user_pos, u.br_id, c.br_nm ,\n"+
				" decode( u.br_id, 'S1', '1', 'B1', '2', 'D1', '3', '4' ) AS br_sort, decode( u.user_pos, '대표이사', 1, '이사', 2, '팀장', 3, '차장', 4, '과장', 5, '대리', 6, 9 ) pos_sort,  \n"+
				" u.dept_id, e.nm as dept_nm , sum(a.w_cnt ) AS w_cnt, \n"+
			//	" a.prv as prv_amt,  sum( a.basic_amt ) AS basic_amt, sum(a.real_amt ) AS real_amt, sum( a.remain_amt ) AS remain_amt,  \n"+
			//	" sum( a.g3_amt ) AS g3_amt, sum( a.g2_amt ) AS g2_amt, sum( a.g4_amt ) AS g4_amt, sum( a.s_g4_amt ) AS s_g4_amt,  sum( a.g9_amt ) AS g9_amt , sum( a.eg4_amt ) AS eg4_amt \n"+
				" a.prv as amt9, sum( a.basic_amt ) AS amt8, sum(a.real_amt ) AS amt1,  "+
				" sum( a.g2_amt ) AS amt2, sum( a.g3_amt ) AS amt3,  sum( a.g4_amt ) AS amt4, sum( a.s_g4_amt ) AS amt5, sum( a.eg4_amt ) AS amt6, sum( a.g9_amt ) AS amt7 ,  sum( a.g8_amt ) AS amt10 "+
				" FROM ( SELECT u.use_yn, u.user_id, a.buy_dt, a.w_cnt, a.basic_amt, a.real_amt,  \n"+
				" a.remain_amt, d.g3_amt, e.g2_amt, o.g9_amt, f.g4_amt, f.s_g4_amt, f.prv , ff.eg4_amt, d8.g8_amt  FROM users u,  \n"+
				//--중식대
				"( SELECT a.user_id, substr(a.jung_dt,1,6) buy_dt, sum( decode( a.remark, 'W', 1, 0 )) AS w_cnt, sum( a.basic_amt ) AS basic_amt, sum(a.real_amt ) AS real_amt, sum( a.remain_amt ) AS remain_amt  \n"+
				" FROM card_doc_jungsan a  WHERE a.jung_dt BETWEEN replace( '" + f_date1 + "', '-', '' ) AND replace( '" + t_date1 + "', '-', '' ) GROUP BY a.user_id, substr(a.jung_dt,1,6) ) a, \n"+
				//--특근식대
				"( SELECT b.doc_user, substr(a.buy_dt,1,6) buy_dt, sum( b.doc_amt ) AS g8_amt FROM card_doc a, card_doc_user b  WHERE a.buy_dt BETWEEN replace( '" + f_date1 + "', '-', '' )  \n"+
				" AND replace( '" + t_date1 + "', '-', '' ) AND a.acct_code = '00001' AND a.acct_code_g = '1' and a.acct_code_g2 = '3' AND a.cardno = b.cardno(+) AND a.buy_id = b.buy_id(+) "+
				" GROUP BY b.doc_user, substr(a.buy_dt,1,6) ) d8,  \n"+
				//--기타비용
				"( SELECT b.doc_user, substr(a.buy_dt,1,6) buy_dt, sum( b.doc_amt ) AS g3_amt FROM card_doc a, card_doc_user b  WHERE a.buy_dt BETWEEN replace( '" + f_date1 + "', '-', '' )  \n"+
				" AND replace( '" + t_date1 + "', '-', '' ) AND a.acct_code = '00001' AND a.acct_code_g = '3' AND a.cardno = b.cardno(+) AND a.buy_id = b.buy_id(+) "+
				" GROUP BY b.doc_user, substr(a.buy_dt,1,6) ) d,  \n"+
				//--복지비
				"( SELECT b.doc_user, substr(a.buy_dt,1,6) buy_dt, sum( b.doc_amt ) AS g2_amt FROM card_doc a, card_doc_user b WHERE a.buy_dt BETWEEN replace( '" + f_date1 + "', '-', '' )  \n"+
				" AND replace( '" + t_date1 + "', '-', '' ) AND a.acct_code = '00001' AND a.acct_code_g = '2' AND a.cardno = b.cardno(+) AND a.buy_id = b.buy_id(+) \n"+
				" GROUP BY b.doc_user, substr(a.buy_dt,1,6) ) e,  \n"+
				//--유류대정산
				"( SELECT a.user_id, substr(a.save_dt,1,6) buy_dt, sum( a.jung_amt ) AS g9_amt FROM stat_car_oil a WHERE substr(a.save_dt,1,6) BETWEEN replace( '" + f_date1 + "', '-', '' )    \n"+
				" AND replace( '" + t_date1 + "', '-', '' ) and magam = 'Y'  and a.save_dt < '20120601'   GROUP BY a.user_id, substr(a.save_dt,1,6) ) o, \n"+
				//--복지비한도
				" ( select user_id, buy_dt,prv, g4_amt, s_g4_amt from ( "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'01' buy_dt, jan g4_amt, jan1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1'  \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'02' buy_dt, feb g4_amt, feb1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1'  \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'03' buy_dt, mar g4_amt, mar1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'04' buy_dt, apr g4_amt, apr1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'05' buy_dt, may g4_amt, may1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1'  \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'06' buy_dt, jun g4_amt, jun1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'07' buy_dt, jul g4_amt, jul1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'08' buy_dt, aug g4_amt, aug1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1'  \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'09' buy_dt, sep g4_amt, sep1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1'  \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'10' buy_dt, oct g4_amt, oct1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1'  \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'11' buy_dt, nov g4_amt, nov1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'12' buy_dt, dec g4_amt, dec1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' \n"+
				" ) ) f , \n"+
				//--팀장이상 - 기타 한도
				" ( select user_id, buy_dt,  eg4_amt from ( "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'01' buy_dt, jan eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3'  \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'02' buy_dt, feb eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3'  \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'03' buy_dt, mar eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3' \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'04' buy_dt, apr eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3' \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'05' buy_dt, may eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3'  \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'06' buy_dt, jun eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3' \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'07' buy_dt, jul eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3' \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'08' buy_dt, aug eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3'  \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'09' buy_dt, sep eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3'  \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'10' buy_dt, oct eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3'  \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'11' buy_dt, nov eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3' \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'12' buy_dt, dec eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3' \n"+
				" ) ) ff  \n"+        
				
				" WHERE u.user_id = a.user_id(+) AND a.user_id = d.doc_user(+) and a.buy_dt=d.buy_dt(+) AND a.user_id = e.doc_user(+) and a.buy_dt=e.buy_dt(+) AND a.user_id = o.user_id(+) and a.buy_dt=o.buy_dt(+) \n"+  
				" AND a.user_id = D8.doc_user(+) and a.buy_dt=d8.buy_dt(+) AND a.user_id = f.user_id(+) and a.buy_dt=f.buy_dt(+) AND a.user_id = ff.user_id(+) and a.buy_dt=ff.buy_dt(+) ) a, users u ,  \n" +
				"  branch c ,  ( select c_st, code, nm_cd, nm from code where c_st = '0002' and code <> '0000'  )  e  \n"+
				" WHERE a.user_id = u.user_id AND a.user_id NOT IN ('000037', '000044',  '000102', '000035', '000203' ,  '000238' , '000285' , '000293' , '000302', '000329','000330')  \n"+
				" AND u.dept_id NOT IN ( '8888' , '1000') and u.id not like 'develop%'  AND  u.use_yn = 'Y'   and u.br_id=c.br_id and u.dept_id = e.code  ";
        
        if ( !user_id.equals("")) {
        	 query = query + " and u.user_id ='"+ user_id+"'";
        }	 
				
		query += " GROUP BY u.use_yn, a.user_id, u.user_nm, u.user_pos, u.br_id, u.dept_id,a.prv  , c.br_nm, e.nm  \n";
		query += " order by 1 desc, decode(u.user_pos,'대표이사',1,'이사',2,'팀장',4, 5), DECODE(a.user_id, '000004',1,'000005',2,4), decode(u.dept_id,'0020','0000',u.dept_id), decode(a.user_id, '000237', '0', decode(u.user_pos, '팀장', 0, '부장', 1, '차장', 2, '과장',3,'대리', 4, 5)), a.user_id";

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
			System.out.println("[JungSanDatabase:getCardJungDtStatINew]\n"+e);
			System.out.println("[JungSanDatabase:getCardJungDtStatINew]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
    
    
    public Vector getCardJungDtStatNew(String dt, String ref_dt1, String ref_dt2, String br_id, String dept_id, String user_id, String s_yy)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
     	
		String f_date1="";
		String t_date1="";
	
		String s_year = s_yy;
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		

		if(dt.equals("2")) { //전반기 1월~6월
			f_date1 = s_year+ "01" + "01";
			t_date1 = s_year+ "06" + "30";
		}
		if(dt.equals("5")) {//후반기 7월~12월
			f_date1 = s_year+ "07" + "01";
			t_date1 = s_year+ "12" + "31";
		}
		
		if(dt.equals("3")) {
			f_date1 = s_year+ "0101";
			t_date1 = s_year+ "12" + "31";
		}
		
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}
		
			query = " SELECT u.use_yn, a.user_id, u.user_nm, u.user_pos, u.br_id, decode( u.br_id, 'S1', '본사', 'B1', '부산지점', 'D1', '대전지점', '' ) AS br_nm, "+
				" decode( u.br_id, 'S1', '1', 'B1', '2', 'D1', '3', '4' ) AS br_sort, decode( u.user_pos, '대표이사', 1, '이사', 2, '팀장', 3, '차장', 4,  '과장', 5, '대리', 6, 9  ) pos_sort, "+
				" u.dept_id, decode( u.dept_id, '0001', '영업팀', '0002', '고객지원팀', '0003', '총무팀', '0005', '채권관리팀', '0007', '부산지점', '0008', '대전지점', '8888', '아마존카외', '7777', '아르바이트', ' ' ) AS dept_nm, "+
				" a.prv as prv_amt,sum(a.w_cnt ) AS w_cnt, sum( a.basic_amt ) AS basic_amt, sum(a.real_amt ) AS real_amt, sum( a.remain_amt ) AS remain_amt, "+
				" sum( a.g3_amt ) AS g3_amt, sum( a.g2_amt ) AS g2_amt, sum( a.g4_amt ) AS g4_amt FROM ( SELECT u.use_yn, u.user_id, a.buy_dt, a.w_cnt, a.basic_amt, a.real_amt, "+
				" a.remain_amt, d.g3_amt, e.g2_amt, f.g4_amt, f.prv  FROM users u, "+
				//--중식대
				"( SELECT a.user_id, substr(a.jung_dt,1,6) buy_dt, sum( decode( a.remark, 'W', 1, 0 )) AS w_cnt, sum( a.basic_amt ) AS basic_amt, sum(a.real_amt ) AS real_amt, sum( a.remain_amt ) AS remain_amt "+
				" FROM card_doc_jungsan a  WHERE a.jung_dt BETWEEN replace( '" + f_date1 + "', '-', '' ) AND replace( '" + t_date1 + "', '-', '' ) GROUP BY a.user_id, substr(a.jung_dt,1,6) ) a, "+
				//--기타비용
				"( SELECT b.doc_user, substr(a.buy_dt,1,6) buy_dt, sum( b.doc_amt ) AS g3_amt FROM card_doc a, card_doc_user b  WHERE a.buy_dt BETWEEN replace( '" + f_date1 + "', '-', '' ) "+
				" AND replace( '" + t_date1 + "', '-', '' ) AND a.acct_code = '00001' AND a.acct_code_g = '3' AND a.cardno = b.cardno(+) AND a.buy_id = b.buy_id(+) "+
				" GROUP BY b.doc_user, substr(a.buy_dt,1,6) ) d, "+
				//--복지비
				"( SELECT b.doc_user, substr(a.buy_dt,1,6) buy_dt, sum( b.doc_amt ) AS g2_amt FROM card_doc a, card_doc_user b WHERE a.buy_dt BETWEEN replace( '" + f_date1 + "', '-', '' ) "+
				" AND replace( '" + t_date1 + "', '-', '' ) AND a.acct_code = '00001' AND a.acct_code_g = '2' AND a.cardno = b.cardno(+) AND a.buy_id = b.buy_id(+) "+
				" GROUP BY b.doc_user, substr(a.buy_dt,1,6) ) e, "+
				//--복지비한도
				" ( select user_id, buy_dt, prv, g4_amt from ( "+
                " select user_id, prv, substr('" + f_date1 + "', 1,4)||'01' buy_dt, jan g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, prv, substr('" + f_date1 + "', 1,4)||'02' buy_dt, feb g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, prv, substr('" + f_date1 + "', 1,4)||'03' buy_dt, mar g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, prv, substr('" + f_date1 + "', 1,4)||'04' buy_dt, apr g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, prv, substr('" + f_date1 + "', 1,4)||'05' buy_dt, may g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, prv, substr('" + f_date1 + "', 1,4)||'06' buy_dt, jun g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, prv, substr('" + f_date1 + "', 1,4)||'07' buy_dt, jul g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, prv, substr('" + f_date1 + "', 1,4)||'08' buy_dt, aug g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, prv, substr('" + f_date1 + "', 1,4)||'09' buy_dt, sep g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, prv, substr('" + f_date1 + "', 1,4)||'10' buy_dt, oct g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, prv, substr('" + f_date1 + "', 1,4)||'11' buy_dt, nov g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, prv, substr('" + f_date1 + "', 1,4)||'12' buy_dt, dec g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
				" ) ) f "+
				" WHERE u.user_id = a.user_id(+) AND a.user_id = d.doc_user(+) and a.buy_dt=d.buy_dt(+) AND a.user_id = e.doc_user(+) and a.buy_dt=e.buy_dt(+) AND a.user_id = f.user_id(+) and a.buy_dt=f.buy_dt(+) ) a, users u "+
				" WHERE a.user_id = u.user_id AND a.user_id NOT IN ( '000000', '000035', '000037', '000044', '000047', '000003', '000004', '000005', '000006', '000071', '000081', '000084', '000094', '000095', '000103', '000104', '000105', '000102' ) "+
				" AND u.dept_id NOT IN ( '8888' )  AND  u.use_yn = 'Y' ";
				
		query += " GROUP BY u.use_yn, a.user_id, u.user_nm, u.user_pos, u.br_id, u.dept_id, a.prv";
		query += " order by 1 desc, decode(u.user_pos,'대표이사',1,'이사',2,'부장',3,'팀장', 4, 5), DECODE(a.user_id, '000004',1,'000005',2,'000237',3,4), decode(u.br_id,'S1',1,'B1',2,'S2',3,4), decode(u.dept_id,'0004','0000',u.dept_id), decode(u.user_pos,'인턴사원','4','사원','3','대리','2','1') ,a.user_id";

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
			System.out.println("[JungSanDatabase:getCardJungDtStatNew]\n"+e);
			System.out.println("[JungSanDatabase:getCardJungDtStatNew]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	 
	 
		

//정산서 - 월별내용 보기(임원포함)
public Vector getCardJungDtStatINew_mon(String dt, String st_year, String st_mon, String ref_dt1, String ref_dt2, String br_id, String dept_id, String user_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
     	
		String f_date1="";
		String t_date1="";
		
	
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	

		
		s_month = AddUtil.addZero(s_month);
		st_mon = AddUtil.addZero(st_mon);

		if(st_year.equals("")){
			f_date1 = s_year+s_month;
			t_date1 = s_year+s_month;
		}else{
			f_date1 = st_year+st_mon;
			t_date1 = st_year+st_mon;
		}
				
			query = " SELECT u.use_yn, a.user_id, u.user_nm, u.user_pos, u.br_id, c.br_nm, "+
				" decode( u.br_id, 'S1', '1', 'B1', '2', 'D1', '3', '4' ) AS br_sort, decode( u.user_pos, '대표이사', 1, '이사', 2, '팀장', 3, '차장', 4, '과장', 5, '대리', 6, 9 ) pos_sort, "+
				" u.dept_id, e.nm as dept_nm,  sum(a.w_cnt ) AS w_cnt, "+				
				//" sum( a.basic_amt ) AS basic_amt, sum(a.real_amt ) AS real_amt, sum( a.remain_amt ) AS remain_amt, "+
			//	" sum( a.g3_amt ) AS g3_amt, sum( a.g2_amt ) AS g2_amt, sum( a.g4_amt ) AS g4_amt ,sum( a.s_g4_amt ) AS s_g4_amt , sum( a.eg4_amt ) AS eg4_amt , sum( a.g9_amt ) AS g9_amt " +
				" sum( a.basic_amt ) AS amt8, sum(a.real_amt ) AS amt1,  "+
				" sum( a.g2_amt ) AS amt2, sum( a.g3_amt ) AS amt3,  sum( a.g4_amt ) AS amt4, sum( a.s_g4_amt ) AS amt5, sum( a.eg4_amt ) AS amt6, sum( a.g9_amt ) AS amt7  "+
				" FROM ( SELECT u.use_yn, u.user_id, a.buy_dt, a.w_cnt, a.basic_amt, a.real_amt, "+
				" a.remain_amt, d.g3_amt, e.g2_amt, f.g4_amt, f.s_g4_amt , ff.eg4_amt, o.g9_amt  FROM users u, "+
				//--중식대
				"( SELECT a.user_id, substr(a.jung_dt,1,6) buy_dt, sum( decode( a.remark, 'W', 1, 0 )) AS w_cnt, sum( a.basic_amt ) AS basic_amt, sum(a.real_amt ) AS real_amt, sum( a.remain_amt ) AS remain_amt "+
				" FROM card_doc_jungsan a  WHERE substr(a.jung_dt,1,6) BETWEEN replace( '" + f_date1 + "', '-', '' ) AND replace( '" + t_date1 + "', '-', '' ) GROUP BY a.user_id, substr(a.jung_dt,1,6) ) a, "+
				//--기타비용
				"( SELECT b.doc_user, substr(a.buy_dt,1,6) buy_dt, sum( b.doc_amt ) AS g3_amt FROM card_doc a, card_doc_user b  WHERE substr(a.buy_dt,1,6) BETWEEN replace( '" + f_date1 + "', '-', '' ) "+
				" AND replace( '" + t_date1 + "', '-', '' ) AND a.acct_code = '00001' AND a.acct_code_g = '3' AND a.cardno = b.cardno(+) AND a.buy_id = b.buy_id(+) "+
				" GROUP BY b.doc_user, substr(a.buy_dt,1,6) ) d, "+
				//--복지비
				"( SELECT b.doc_user, substr(a.buy_dt,1,6) buy_dt, sum( b.doc_amt ) AS g2_amt FROM card_doc a, card_doc_user b WHERE substr(a.buy_dt,1,6) BETWEEN replace( '" + f_date1 + "', '-', '' ) "+
				" AND replace( '" + t_date1 + "', '-', '' ) AND a.acct_code = '00001' AND a.acct_code_g = '2' AND a.cardno = b.cardno(+) AND a.buy_id = b.buy_id(+) "+
				" GROUP BY b.doc_user, substr(a.buy_dt,1,6) ) e, "+
				//--유류대정산 - 2012년 1분기까지만 복지비 차감 - 그 후 캠페인 금액 차감으로 바뀜 20120601
				"( SELECT a.user_id, substr(a.save_dt,1,6) buy_dt, sum( a.jung_amt ) AS g9_amt FROM stat_car_oil a WHERE substr(a.save_dt,1,6) BETWEEN replace( '" + f_date1 + "', '-', '' ) "+
				" AND replace( '" + t_date1 + "', '-', '' ) and magam = 'Y'  and a.save_dt  < '20120601' GROUP BY a.user_id, substr(a.save_dt,1,6) ) o,"+
				//--복지비한도
				" ( select user_id, buy_dt,prv, g4_amt, s_g4_amt from ( "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'01' buy_dt, jan g4_amt, jan1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1'  \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'02' buy_dt, feb g4_amt, feb1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1'  \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'03' buy_dt, mar g4_amt, mar1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'04' buy_dt, apr g4_amt, apr1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'05' buy_dt, may g4_amt, may1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1'  \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'06' buy_dt, jun g4_amt, jun1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'07' buy_dt, jul g4_amt, jul1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'08' buy_dt, aug g4_amt, aug1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1'  \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'09' buy_dt, sep g4_amt, sep1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1'  \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'10' buy_dt, oct g4_amt, oct1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1'  \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'11' buy_dt, nov g4_amt, nov1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' \n"+
		                " union all "+
		                " select user_id,prv, substr('" + f_date1 + "', 1,4)||'12' buy_dt, dec g4_amt, dec1 s_g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' \n"+
				" ) ) f , \n"+
				//--팀장이상 - 기타 한도
				" ( select user_id, buy_dt,  eg4_amt from ( "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'01' buy_dt, jan eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3'  \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'02' buy_dt, feb eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3'  \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'03' buy_dt, mar eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3' \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'04' buy_dt, apr eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3' \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'05' buy_dt, may eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3'  \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'06' buy_dt, jun eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3' \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'07' buy_dt, jul eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3' \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'08' buy_dt, aug eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3'  \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'09' buy_dt, sep eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3'  \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'10' buy_dt, oct eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3'  \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'11' buy_dt, nov eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3' \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'12' buy_dt, dec eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3' \n"+
				" ) ) ff  \n"+        
				" WHERE u.user_id = a.user_id(+) AND a.user_id = d.doc_user(+) and a.buy_dt=d.buy_dt(+) AND a.user_id = e.doc_user(+) and a.buy_dt=e.buy_dt(+) AND a.user_id = o.user_id(+) and a.buy_dt=o.buy_dt(+) " +
				" AND a.user_id = f.user_id(+) and a.buy_dt=f.buy_dt(+)  AND a.user_id = ff.user_id(+) and a.buy_dt=ff.buy_dt(+)     ) a, users u , " +
				"  branch c ,   ( select c_st, code, nm_cd, nm from code where c_st = '0002' and code <> '0000'  ) e   "+
				" WHERE a.user_id = u.user_id AND a.user_id NOT IN ('000037', '000044',  '000102', '000035', '000203' , '000238', '000285' , '000293' , '000302', '000329','000330' )  and u.br_id = c.br_id and u.dept_id = e.code  "+
				" AND u.dept_id NOT IN ( '8888' , '1000' )  and u.id not like 'develop%' AND ( u.use_yn = 'Y'  OR u.out_dt > replace( '" + f_date1 + "', '-', '' )||'01')  ";

		query += " GROUP BY u.use_yn, a.user_id, u.user_nm, u.user_pos, u.br_id, u.dept_id , c.br_nm, e.nm ";
		query += " order by 1 desc, decode(u.user_pos,'대표이사',1,'이사',2,'팀장',4, 5), DECODE(a.user_id, '000004',1,'000005',2,4), decode(u.dept_id,'0020','0000',u.dept_id), decode(a.user_id, '000237', '0', decode(u.user_pos, '팀장', 0, '부장', 1, '차장', 2, '과장',3,'대리', 4, 5)) ,a.user_id";

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
			System.out.println("[JungSanDatabase:getCardJungDtStatNew_mon]\n"+e);
			System.out.println("[JungSanDatabase:getCardJungDtStatNew_mon]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

//정산서 - 개인별 세부내용 보기(임원포함)
public Vector getCardJungDtStatINew_1st(String dt, String st_year, String ref_dt1, String ref_dt2, String br_id, String dept_id, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
     	
		String f_date1="";
		String t_date1="";
	
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		
		if(dt.equals("2")) {
			if(!st_year.equals("")){
				f_date1 = st_year+ "0101";
				t_date1 = st_year+ "12" + "31";
			}else{
				f_date1 = s_year+ "0101";
				t_date1 = s_year+ "12" + "31";
			}
		}

		query = " SELECT u.use_yn, a.user_id, u.user_nm, u.user_pos, u.br_id, decode( u.br_id, 'S1', '본사', 'B1', '부산지점', 'D1', '대전지점', '' ) AS br_nm, "+
				" decode( u.br_id, 'S1', '1', 'B1', '2', 'D1', '3', '4' ) AS br_sort, decode( u.user_pos, '대표이사', 1, '이사', 2, '팀장', 3, '차장', 4,  '과장', 5, '대리', 6, 9  ) pos_sort, "+
				" u.dept_id, decode( u.dept_id, '0001', '영업팀', '0002', '고객지원팀', '0003', '총무팀', '0005', '채권관리팀', '0007', '부산지점', '0008', '대전지점', '8888', '아마존카외', '7777', '아르바이트', ' ' ) AS dept_nm, "+
				" substr(a.buy_dt, 1, 4 ) yyyy, substr( a.buy_dt, 5, 2 ) mm, sum(a.w_cnt ) AS w_cnt, sum( a.basic_amt ) AS basic_amt, sum(a.real_amt ) AS real_amt, sum( a.remain_amt ) AS remain_amt, "+
				" sum( a.g3_amt ) AS g3_amt, sum( a.g2_amt ) AS g2_amt, sum( a.g4_amt ) AS g4_amt FROM ( SELECT u.use_yn, u.user_id, a.buy_dt, a.w_cnt, a.basic_amt, a.real_amt, "+
				" a.remain_amt, d.g3_amt, e.g2_amt, g4_amt  FROM users u, "+
				//--중식대
				"( SELECT a.user_id, substr(a.jung_dt,1,6) buy_dt, sum( decode( a.remark, 'W', 1, 0 )) AS w_cnt, sum( a.basic_amt ) AS basic_amt, sum(a.real_amt ) AS real_amt, sum( a.remain_amt ) AS remain_amt "+
				" FROM card_doc_jungsan a  WHERE a.jung_dt BETWEEN replace( '" + f_date1 + "', '-', '' ) AND replace( '" + t_date1 + "', '-', '' ) GROUP BY a.user_id, substr(a.jung_dt,1,6) ) a, "+
				//--기타비용
				"( SELECT b.doc_user, substr(a.buy_dt,1,6) buy_dt, sum( b.doc_amt ) AS g3_amt FROM card_doc a, card_doc_user b  WHERE a.buy_dt BETWEEN replace( '" + f_date1 + "', '-', '' ) "+
				" AND replace( '" + t_date1 + "', '-', '' ) AND a.acct_code = '00001' AND a.acct_code_g = '3' AND a.cardno = b.cardno(+) AND a.buy_id = b.buy_id(+) "+
				" GROUP BY b.doc_user, substr(a.buy_dt,1,6) ) d, "+
				//--복지비
				"( SELECT b.doc_user, substr(a.buy_dt,1,6) buy_dt, sum( b.doc_amt ) AS g2_amt FROM card_doc a, card_doc_user b WHERE a.buy_dt BETWEEN replace( '" + f_date1 + "', '-', '' ) "+
				" AND replace( '" + t_date1 + "', '-', '' ) AND a.acct_code = '00001' AND a.acct_code_g = '2' AND a.cardno = b.cardno(+) AND a.buy_id = b.buy_id(+) "+
				" GROUP BY b.doc_user, substr(a.buy_dt,1,6) ) e, "+
				//--복지비한도
				" ( select user_id, buy_dt, g4_amt from ( "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'01' buy_dt, jan g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'02' buy_dt, feb g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'03' buy_dt, mar g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'04' buy_dt, apr g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'05' buy_dt, may g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'06' buy_dt, jun g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'07' buy_dt, jul g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'08' buy_dt, aug g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'09' buy_dt, sep g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'10' buy_dt, oct g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'11' buy_dt, nov g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'12' buy_dt, dec g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
				" ) ) f "+
				" WHERE u.user_id = a.user_id(+) AND a.user_id = d.doc_user(+) and a.buy_dt=d.buy_dt(+) AND a.user_id = e.doc_user(+) and a.buy_dt=e.buy_dt(+) AND a.user_id = f.user_id(+) and a.buy_dt=f.buy_dt(+) ) a, users u "+
				" WHERE a.user_id = u.user_id AND a.user_id NOT IN ('000037', '000035', '000044', '000047' , '000071' , '000081', '000094', '000095', '000103', '000104', '000105','000102' ) "+
				" AND u.dept_id NOT IN ( '8888' )  AND ( u.use_yn = 'Y' OR u.out_dt > replace( '" + f_date1 + "', '-', '' )||'01') AND a.user_id = '" + user_id + "' ";
				
		query += " GROUP BY u.use_yn, a.user_id, u.user_nm, u.user_pos, u.br_id, u.dept_id, substr( a.buy_dt, 1, 4 ), substr( a.buy_dt, 5, 2 ) ";
		query += " order by 1 desc, decode(u.user_pos,'대표이사',1,'이사',2,'부장',3,'팀장', 4, 5), DECODE(a.user_id, '000004',1,'000005',2,'000237',3,4), decode(u.br_id,'S1',1,'B1',2,'S2',3,4), decode(u.dept_id,'0004','0000',u.dept_id), decode(u.user_pos,'인턴사원','4','사원','3','대리','2','1') ,a.user_id";

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
			System.out.println("[JungSanDatabase:getCardJungDtStatNew_1st]\n"+e);
			System.out.println("[JungSanDatabase:getCardJungDtStatNew_1st]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

//정산서 - 월별내용 보기
public Vector getCardJungDtStatNew_mon(String dt, String st_year, String st_mon, String ref_dt1, String ref_dt2, String br_id, String dept_id, String user_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
     	
		String f_date1="";
		String t_date1="";
		
	
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	

		
		s_month = AddUtil.addZero(s_month);
		st_mon = AddUtil.addZero(st_mon);

		if(st_year.equals("")){
			f_date1 = s_year+s_month;
			t_date1 = s_year+s_month;
		}else{
			f_date1 = st_year+st_mon;
			t_date1 = st_year+st_mon;
		}

		
				
			query = " SELECT u.use_yn, a.user_id, u.user_nm, u.user_pos, u.br_id, decode( u.br_id, 'S1', '본사', 'B1', '부산지점', 'D1', '대전지점', '' ) AS br_nm, "+
				" decode( u.br_id, 'S1', '1', 'B1', '2', 'D1', '3', '4' ) AS br_sort, decode( u.user_pos, '대표이사', 1, '이사', 2, '팀장', 3, '차장', 4,  '과장', 5, '대리', 6, 9 ) pos_sort, "+
				" u.dept_id, decode( u.dept_id, '0001', '영업팀', '0002', '고객지원팀', '0003', '총무팀', '0005', '채권관리팀', '0007', '부산지점', '0008', '대전지점', '8888', '아마존카외', '7777', '아르바이트', ' ' ) AS dept_nm, "+
				" sum(a.w_cnt ) AS w_cnt, sum( a.basic_amt ) AS basic_amt, sum(a.real_amt ) AS real_amt, sum( a.remain_amt ) AS remain_amt, "+
				" sum( a.g3_amt ) AS g3_amt, sum( a.g2_amt ) AS g2_amt, sum( a.g4_amt ) AS g4_amt FROM ( SELECT u.use_yn, u.user_id, a.buy_dt, a.w_cnt, a.basic_amt, a.real_amt, "+
				" a.remain_amt, d.g3_amt, e.g2_amt, g4_amt  FROM users u, "+
				//--중식대
				"( SELECT a.user_id, substr(a.jung_dt,1,6) buy_dt, sum( decode( a.remark, 'W', 1, 0 )) AS w_cnt, sum( a.basic_amt ) AS basic_amt, sum(a.real_amt ) AS real_amt, sum( a.remain_amt ) AS remain_amt "+
				" FROM card_doc_jungsan a  WHERE substr(a.jung_dt,1,6) BETWEEN replace( '" + f_date1 + "', '-', '' ) AND replace( '" + t_date1 + "', '-', '' ) GROUP BY a.user_id, substr(a.jung_dt,1,6) ) a, "+
				//--기타비용
				"( SELECT b.doc_user, substr(a.buy_dt,1,6) buy_dt, sum( b.doc_amt ) AS g3_amt FROM card_doc a, card_doc_user b  WHERE substr(a.buy_dt,1,6) BETWEEN replace( '" + f_date1 + "', '-', '' ) "+
				" AND replace( '" + t_date1 + "', '-', '' ) AND a.acct_code = '00001' AND a.acct_code_g = '3' AND a.cardno = b.cardno(+) AND a.buy_id = b.buy_id(+) "+
				" GROUP BY b.doc_user, substr(a.buy_dt,1,6) ) d, "+
				//--복지비
				"( SELECT b.doc_user, substr(a.buy_dt,1,6) buy_dt, sum( b.doc_amt ) AS g2_amt FROM card_doc a, card_doc_user b WHERE substr(a.buy_dt,1,6) BETWEEN replace( '" + f_date1 + "', '-', '' ) "+
				" AND replace( '" + t_date1 + "', '-', '' ) AND a.acct_code = '00001' AND a.acct_code_g = '2' AND a.cardno = b.cardno(+) AND a.buy_id = b.buy_id(+) "+
				" GROUP BY b.doc_user, substr(a.buy_dt,1,6) ) e, "+
				//--복지비한도
				" ( select user_id, buy_dt, g4_amt from ( "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'01' buy_dt, jan g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'02' buy_dt, feb g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'03' buy_dt, mar g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'04' buy_dt, apr g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'05' buy_dt, may g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'06' buy_dt, jun g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'07' buy_dt, jul g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'08' buy_dt, aug g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'09' buy_dt, sep g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'10' buy_dt, oct g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'11' buy_dt, nov g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
                " union all "+
                " select user_id, substr('" + f_date1 + "', 1,4)||'12' buy_dt, dec g4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
				" ) ) f "+
				" WHERE u.user_id = a.user_id(+) AND a.user_id = d.doc_user(+) and a.buy_dt=d.buy_dt(+) AND a.user_id = e.doc_user(+) and a.buy_dt=e.buy_dt(+) AND a.user_id = f.user_id(+) and a.buy_dt=f.buy_dt(+) ) a, users u "+
				" WHERE a.user_id = u.user_id AND a.user_id NOT IN ( '000000', '000035', '000037', '000044', '000047', '000071', '000081', '000084', '000094', '000095', '000103', '000104', '000105', '000102' ) "+
				" AND u.dept_id NOT IN ( '8888' )  AND ( u.use_yn = 'Y' OR u.out_dt > replace( '" + f_date1 + "', '-', '' )||'01')  ";

		query += " GROUP BY u.use_yn, a.user_id, u.user_nm, u.user_pos, u.br_id, u.dept_id ";
		query += " order by 1 desc, decode(u.user_pos,'대표이사',1,'이사',2,'부장',3,'팀장', 4, 5),  DECODE(a.user_id, '000004',1,'000005',2,'000237',3,4), decode(u.br_id,'S1',1,'B1',2,'S2',3,4), decode(u.dept_id,'0004','0000',u.dept_id), decode(u.user_pos,'인턴사원','4','사원','3','대리','2','1') ,a.user_id";

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
			System.out.println("[JungSanDatabase:getCardJungDtStatNew_mon]\n"+e);
			System.out.println("[JungSanDatabase:getCardJungDtStatNew_mon]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

//정산서 - 개인별 세부내용 보기- 복리후생비
public Vector getCardJungDtStatNew_1st(String dt, String st_year, String ref_dt1, String ref_dt2, String br_id, String dept_id, String user_id, String s_gubun3)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
     	
		String f_date1="";
		String t_date1="";

		String s_user_id = "";
	
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);

		if(s_gubun3.equals("")){
			s_user_id = user_id;
		}else{
			s_user_id = s_gubun3;
		}

		if(dt.equals("2")) {
			if(!st_year.equals("")){
				f_date1 = st_year+ "0101";
				t_date1 = st_year+ "12" + "31";
			}else{
				f_date1 = s_year+ "0101";
				t_date1 = s_year+ "12" + "31";
			}
		}

		query = " SELECT substr(a.buy_dt, 1, 4 ) yyyy, substr( a.buy_dt, 5, 2 ) mm, u.use_yn, a.user_id, u.user_nm,  "+
			//	" sum( a.basic_amt ) AS basic_amt, sum(a.real_amt ) AS real_amt, sum( a.remain_amt ) AS remain_amt, "+
			//	" sum( a.g3_amt ) AS g3_amt, sum( a.g2_amt ) AS g2_amt, sum( a.g4_amt ) AS g4_amt, sum( a.s_g4_amt ) AS s_g4_amt, sum( a.eg4_amt ) AS eg4_amt, sum( a.g9_amt ) AS g9_amt  "+
				" sum( a.basic_amt ) AS amt8, sum(a.real_amt ) AS amt1,  "+
				" sum( a.g2_amt ) AS amt2, sum( a.g3_amt ) AS amt3,  sum( a.g4_amt ) AS amt4, sum( a.s_g4_amt ) AS amt5, sum( a.eg4_amt ) AS amt6, sum( a.g9_amt ) AS amt7  "+
				" FROM ( SELECT u.use_yn, u.user_id, f.buy_dt, a.w_cnt, a.basic_amt, a.real_amt, "+
				" a.remain_amt, d.g3_amt, e.g2_amt, f.g4_amt, f.s_g4_amt, ff.eg4_amt, o.g9_amt FROM users u, \n "+
				//--중식대
				"( SELECT a.user_id, substr(a.jung_dt,1,6) buy_dt, sum( decode( a.remark, 'W', 1, 0 )) AS w_cnt, sum( a.basic_amt ) AS basic_amt, sum(a.real_amt ) AS real_amt, sum( a.remain_amt ) AS remain_amt "+
				" FROM card_doc_jungsan a  WHERE a.jung_dt BETWEEN replace( '" + f_date1 + "', '-', '' ) AND replace( '" + t_date1 + "', '-', '' ) GROUP BY a.user_id, substr(a.jung_dt,1,6) ) a, \n "+							
				//--기타비용
				"( SELECT b.doc_user, substr(a.buy_dt,1,6) buy_dt, sum( b.doc_amt ) AS g3_amt FROM card_doc a, card_doc_user b  WHERE a.buy_dt BETWEEN replace( '" + f_date1 + "', '-', '' ) "+
				" AND replace( '" + t_date1 + "', '-', '' ) AND a.acct_code = '00001' AND a.acct_code_g = '3' AND a.cardno = b.cardno(+) AND a.buy_id = b.buy_id(+) "+
				" GROUP BY b.doc_user, substr(a.buy_dt,1,6) ) d, \n "+
				//--복지비
				"( SELECT b.doc_user, substr(a.buy_dt,1,6) buy_dt, sum( b.doc_amt ) AS g2_amt FROM card_doc a, card_doc_user b WHERE a.buy_dt BETWEEN replace( '" + f_date1 + "', '-', '' ) "+
				" AND replace( '" + t_date1 + "', '-', '' ) AND a.acct_code = '00001' AND a.acct_code_g = '2' AND a.cardno = b.cardno(+) AND a.buy_id = b.buy_id(+) "+
				" GROUP BY b.doc_user, substr(a.buy_dt,1,6) ) e, \n"+
				//--유류대정산
				"( SELECT a.user_id, substr(a.save_dt,1,6) buy_dt, sum( a.jung_amt ) AS g9_amt FROM stat_car_oil a WHERE substr(a.save_dt,1,6) BETWEEN replace( '" + f_date1 + "', '-', '' ) "+
				" AND replace( '" + t_date1 + "', '-', '' ) and magam = 'Y' and a.save_dt < '20120601'  GROUP BY a.user_id, substr(a.save_dt,1,6) ) o, \n"+
				//--복지비한도
				" ( select user_id, buy_dt, g4_amt, s_g4_amt from ( \n "+
				    " select user_id, substr('" + f_date1 + "', 1,4)||'00' buy_dt, prv g4_amt,  0   s_g4_amt  from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
	                " union all \n "+
	                " select user_id, substr('" + f_date1 + "', 1,4)||'01' buy_dt, jan g4_amt, jan1 s_g4_amt  from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
	                " union all \n "+
	                " select user_id, substr('" + f_date1 + "', 1,4)||'02' buy_dt, feb g4_amt, feb1 s_g4_amt  from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
	                " union all \n "+
	                " select user_id, substr('" + f_date1 + "', 1,4)||'03' buy_dt, mar g4_amt, mar1 s_g4_amt  from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
	                " union all \n "+
	                " select user_id, substr('" + f_date1 + "', 1,4)||'04' buy_dt, apr g4_amt, apr1 s_g4_amt  from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
	                " union all \n "+
	                " select user_id, substr('" + f_date1 + "', 1,4)||'05' buy_dt, may g4_amt, may1 s_g4_amt  from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
	                " union all \n "+
	                " select user_id, substr('" + f_date1 + "', 1,4)||'06' buy_dt, jun g4_amt, jun1 s_g4_amt  from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
	                " union all \n "+
	                " select user_id, substr('" + f_date1 + "', 1,4)||'07' buy_dt, jul g4_amt, jul1 s_g4_amt  from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
	                " union all \n "+
	                " select user_id, substr('" + f_date1 + "', 1,4)||'08' buy_dt, aug g4_amt, aug1 s_g4_amt  from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
	                " union all \n "+
	                " select user_id, substr('" + f_date1 + "', 1,4)||'09' buy_dt, sep g4_amt, sep1 s_g4_amt  from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
	                " union all \n "+
	                " select user_id, substr('" + f_date1 + "', 1,4)||'10' buy_dt, oct g4_amt, oct1 s_g4_amt  from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
	                " union all \n "+
	                " select user_id, substr('" + f_date1 + "', 1,4)||'11' buy_dt, nov g4_amt, nov1 s_g4_amt  from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
	                " union all \n "+
	                " select user_id, substr('" + f_date1 + "', 1,4)||'12' buy_dt, dec g4_amt, dec1 s_g4_amt  from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='1' "+
					" ) ) f , \n "+
				//--팀장이상 - 기타 한도
				" ( select user_id, buy_dt,  eg4_amt from ( "+
						" select user_id, substr('" + f_date1 + "', 1,4)||'00' buy_dt,  0 eg4_amt  from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3' "+
						" union all \n "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'01' buy_dt, jan eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3'  \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'02' buy_dt, feb eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3'  \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'03' buy_dt, mar eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3' \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'04' buy_dt, apr eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3' \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'05' buy_dt, may eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3'  \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'06' buy_dt, jun eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3' \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'07' buy_dt, jul eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3' \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'08' buy_dt, aug eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3'  \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'09' buy_dt, sep eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3'  \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'10' buy_dt, oct eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3'  \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'11' buy_dt, nov eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3' \n"+
		                " union all "+
		                " select user_id,substr('" + f_date1 + "', 1,4)||'12' buy_dt, dec eg4_amt from budget where byear=substr('" + f_date1 + "', 1,4) and bgubun='3' \n"+
				" ) ) ff  \n"+       
				" WHERE u.user_id = f.user_id(+) AND f.user_id = d.doc_user(+) and f.buy_dt=d.buy_dt(+) AND f.user_id = e.doc_user(+) and f.buy_dt=e.buy_dt(+) \n"+
				 " AND f.user_id = o.user_id(+) and f.buy_dt=o.buy_dt(+) AND f.user_id = a.user_id(+) and f.buy_dt=a.buy_dt(+)  AND f.user_id = ff.user_id(+) and f.buy_dt=ff.buy_dt(+) ) a, users u \n "+
				
				" WHERE a.user_id = u.user_id AND a.user_id NOT IN ('000037', '000044',  '000102', '000035', '000203' ) \n "+
				" AND u.dept_id NOT IN ( '8888', '1000' )  AND ( u.use_yn = 'Y' OR u.out_dt > replace( '" + f_date1 + "', '-', '' )) AND a.user_id = '" + s_user_id + "' ";
				
		query += " GROUP BY u.use_yn, a.user_id, u.user_nm, substr( a.buy_dt, 1, 4 ), substr( a.buy_dt, 5, 2 ) ";
		query += " order by 1, 2 ";

		try {
			pstmt = conn.prepareStatement(query);
			
//			System.out.println("getCardJungDtStatNew_1st query=" + query);
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
			System.out.println("[JungSanDatabase:getCardJungDtStatNew_1st]\n"+e);
			System.out.println("[JungSanDatabase:getCardJungDtStatNew_1st]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}


//복리후생비정산 세부내용
public Vector getJungDtStatNew(String dt, String st_year, String st_mon, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String f_date1="";
		String t_date1="";
	
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		
		if(st_year.equals("")) {
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}else{
			
			f_date1 = st_year+ st_mon + "01";
			t_date1 = st_year+ st_mon + "31";
		}
		
		if(dt.equals("3")) {
			f_date1 = s_year+ "0101";
			t_date1 = s_year+ s_month + "31";
		}
		

		query = "	select  a.user_id, a.jung_dt, decode(a.remark , 'W', '근무일', 'H', '공휴일', 'T', '토요일', 'S', '일요일', 'M', '기타' , 'N', ' ' ) as  remark_desc,  sum(a.w_cnt) as w_cnt, sum(a.basic_amt) as basic_amt, sum(a.real_amt) as real_amt, sum(a.remain_amt) as remain_amt , sum(a.g2_1_amt) as g2_1_amt, sum(a.g2_3_amt) as g2_3_amt, sum(a.g3_amt) as g3_amt, sum(a.g2_amt) as g2_amt, sum(a.g4_amt) as g4_amt, sum(a.g15_amt) as g15_amt \n" +
				"	from (		\n" +
				"		select   u.user_id, u.jung_dt, a.remark, a.w_cnt, a.basic_amt, a.real_amt, a.remain_amt, b.g2_1_amt, c.g2_3_amt , d.g3_amt, e.g2_amt, g.g4_amt, gg.g15_amt from  card_doc_jungsan u ,  	\n" +		
				"			 ( select   a.user_id,  a.jung_dt, a.remark, sum(decode(a.remark, 'W', 1, 0)) as w_cnt, sum(a.basic_amt) as basic_amt, sum(a.real_amt) as real_amt, sum(a.remain_amt) as remain_amt \n" +
				"					         from card_doc_jungsan a        where a.jung_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  group by a.user_id, a.jung_dt, a.remark ) a, \n" +
				"			 ( select  b.doc_user, a.buy_dt,  sum(b.doc_amt)  as g2_1_amt  from card_doc a, card_doc_user  b where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '1' and a.acct_code_g2 = '1'  and   \n" +
				"				      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user, a.buy_dt ) b , \n" +
				"			 ( select  b.doc_user, a.buy_dt, sum(b.doc_amt)  as g2_3_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and a.acct_code = '00001' and a.acct_code_g = '1' and a.acct_code_g2 = '3'  and  \n" +
				"				      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user, a.buy_dt ) c, \n" +
				"			 ( select  b.doc_user, a.buy_dt, sum(b.doc_amt)  as g3_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and a.acct_code = '00001' and a.acct_code_g = '3' and   \n" +
				"				      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user, a.buy_dt ) d, \n" +
				"			 ( select  b.doc_user, a.buy_dt, sum(b.doc_amt)  as g2_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and a.acct_code = '00001' and a.acct_code_g = '2' and   \n" +
				"				      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user, a.buy_dt ) e, \n" +
				"			 ( select  b.doc_user, a.buy_dt, sum(b.doc_amt)  as g15_amt from card_doc a, card_doc_user  b	where a.buy_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and a.acct_code = '00001' and a.acct_code_g = '15' and   \n" +
				"				      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user, a.buy_dt ) gg, \n" +
				"		     ( select  b.doc_user, a.buy_dt, sum(b.doc_amt)  as g4_amt from card_doc a, card_doc_user  b	where a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.acct_code = '00001' and a.acct_code_g = '4' and \n" +
				"			      	         	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+)  group by b.doc_user,  a.buy_dt ) g \n" +
				"		where u.user_id = a.user_id(+) and u.user_id = b.doc_user(+) and u.user_id = c.doc_user(+) and u.user_id = d.doc_user(+) and u.user_id = e.doc_user(+) and u.user_id = gg.doc_user(+) and u.user_id = g.doc_user(+) \n" +
				"		      and u.jung_dt = a.jung_dt(+) and u.jung_dt = b.buy_dt(+) and u.jung_dt = c.buy_dt(+) and u.jung_dt = d.buy_dt(+)and u.jung_dt = e.buy_dt(+) and  u.jung_dt = g.buy_dt(+) and  u.jung_dt = gg.buy_dt(+) \n" +
				"		      and u.jung_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n" +
				"			) a, users u " +
				"	 where a.user_id = u.user_id  and ( u.use_yn = 'Y' or u.out_dt > '" + f_date1 + "' )  " ;
		
		if(!user_id.equals(""))		query += " and a.user_id='"+user_id+"'";
				 
		query += "	group by a.user_id, a.jung_dt, a.remark order by  a.user_id, a.jung_dt ";
	
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
			System.out.println("[JungSanDatabase:getJungDtStatNew]\n"+e);
			System.out.println("[JungSanDatabase:getJungDtStatNew]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	
	/* 복지비 사용 내역 */
	 public Vector getJungDtStatG4New(String dt, String st_year, String st_mon, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
     	
		String f_date1="";
		String t_date1="";
	
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);
		
		if(st_year.equals("")) {
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}else{
			f_date1 = st_year+ st_mon + "01";
			t_date1 = st_year+ st_mon + "31";
		}
		
		if(dt.equals("3")) {
			f_date1 = s_year+ "0101";
			t_date1 = s_year+ s_month + "31";
		}
		

		query =	"	select  u.user_id, h.buy_dt, h.doc_amt from  users u ,  " +				
				"		 ( select  b.doc_user, a.buy_dt, sum(b.doc_amt) doc_amt from card_doc a, card_doc_user  b	where substr(a.buy_dt,1,4) = substr('" + f_date1 + "',1,4) and a.acct_code = '00001' and a.acct_code_g  in ('2', '4') and " + 
				"			      	     	a.cardno = b.cardno(+) and a.buy_id = b.buy_id(+) group by b.doc_user, a.buy_dt  ) h " +
				"	where u.user_id = h.doc_user(+)" ;
									
		if(!user_id.equals(""))		query += " and u.user_id='"+user_id+"'";

		query += "	order by   u.user_id, h.buy_dt ";

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
			System.out.println("[JungSanDatabase:getJungDtStatG4New]\n"+e);
	  		e.printStackTrace();
			System.out.println(query);
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}


		//유류대
	public Vector getCardJungOilDtStat(String s_year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = " select  a.*, decode(a.gubun1, '11', '21', a.gubun1) gubun    from ( 	  \n" +
		                   " select b.user_id, u.user_nm, u.dept_id, u.loan_st,  \n" +
				" decode(u.dept_id,'0001','1','0002','2','0007','3','0008', '3', '0009', '1', '0010', '3', '0011', '3' , '0012', '1', '0013', '1' , '0014', '2', '0015', '2', '0016', '3') || u.loan_st as gubun1 , \n" +
				" e.nm as  dept_nm, \n" +
				" decode(u.user_pos,'대표이사',1,'이사', 2, '팀장', 3, '차장', 4 , '과장', 5, '대리', 6,  9) pos_sort, \n" +
				"     sum(decode(acct_code_g2, '11', a1_amt, 0)) a1_1,  sum(decode(acct_code_g2, '12', a1_amt, 0)) a1_2, sum(decode(acct_code_g2, '13', a1_amt, 0)) a1_3, \n" +
				"     sum(decode(acct_code_g2, '11', a2_amt, 0)) a2_1,  sum(decode(acct_code_g2, '12', a2_amt, 0)) a2_2, sum(decode(acct_code_g2, '13', a2_amt, 0)) a2_3, \n" +
				"     sum(decode(acct_code_g2, '11', a3_amt, 0)) a3_1,  sum(decode(acct_code_g2, '12', a3_amt, 0)) a3_2, sum(decode(acct_code_g2, '13', a3_amt, 0)) a3_3, \n" +
				"     sum(decode(acct_code_g2, '11', a4_amt, 0)) a4_1,  sum(decode(acct_code_g2, '12', a4_amt, 0)) a4_2, sum(decode(acct_code_g2, '13', a4_amt, 0)) a4_3 \n" +
				" from ( \n" +
				" select user_id, acct_code_g2, \n" +
				" sum(decode(buy_mm, '01', oil_amt, '02', oil_amt , '03', oil_amt, 0 ) ) a1_amt, \n" +
				" sum(decode(buy_mm, '04', oil_amt, '05', oil_amt , '06', oil_amt, 0 ) ) a2_amt, \n" +
				" sum(decode(buy_mm, '07', oil_amt, '08', oil_amt , '09', oil_amt, 0 ) ) a3_amt, \n" +
				" sum(decode(buy_mm, '10', oil_amt, '11', oil_amt , '12', oil_amt, 0 ) ) a4_amt  \n" +
				" from ( \n" +
				"  select buy_user_id user_id,  substr(buy_dt, 5, 2) buy_mm, acct_code_g2, sum(buy_amt) as oil_amt  \n" +
				"    from card_doc where acct_code = '00004' and buy_dt like '" + s_year + "%' \n" +
				"    group by  buy_user_id,  substr(buy_dt, 5, 2) , acct_code_g2 \n" +
				"    union all \n" +
				"  select   b.buy_user_id user_id, substr(a.p_pay_dt, 5, 2) buy_mm, b.acct_code_g2, sum(b.i_amt ) as oil_amt  \n"+        
				"		 from pay a, pay_item b  where a.reqseq=b.reqseq  and b.acct_code='45800'   and a.p_pay_dt like '"+s_year+"%'   \n"+
				"    group by  b.buy_user_id,  substr(a.p_pay_dt, 5, 2) , b.acct_code_g2 \n" +      
				"    union all \n" +
				"  select /*+ leading(b) merge(a) */  b.req_id user_id,  substr(b.req_dt, 5, 2) buy_mm, \n" +
			          "        decode(a.firm_nm , '(주)아마존카', '12', '13') acct_code_g2, sum(b.oil_amt) as oil_amt \n" +
			          "         from cont_n_view a, consignment b, ( select * from code where c_st= '0015' and code <> '0000' ) c , users u \n" +
			          "         where b.rent_mng_id= a.rent_mng_id and b.rent_l_cd = a.rent_l_cd and u.dept_id not in ( '1000')  \n" +
			          "         and b.cost_st = '1' and b.oil_amt > 0 and b.cons_cau = c.nm_cd(+) \n" +
			          "         and b.req_id = u.user_id   \n" +
			          "         and b.oil_amt > 0 and b.req_dt like '" + s_year + "%' \n" +
			          "     group by  b.req_id,  substr(b.req_dt, 5, 2) , decode(a.firm_nm , '(주)아마존카', '12', '13')  \n" +
				" ) a \n" +
				" group by user_id, acct_code_g2 \n" +
				" ) b , users u,  ( select c_st, code, nm_cd, nm from code where c_st = '0002' and code <> '0000'  ) e   \n" +
				" where b.user_id = u.user_id  and u.loan_st in ('1', '2')  and u.use_yn = 'Y' and u.dept_id = e.code  \n" +
				" group by b.user_id, u.user_nm, u.dept_id , e.nm,  decode(u.user_pos,'대표이사',1,'이사', 2, '팀장', 3, '차장', 4 , '과장', 5, '대리', 6,  9) ,  u.loan_st \n" +
				" union all  \n" +
				" select b.user_id, u.user_nm, u.dept_id,  '3'  loan_st,  \n" +
				" '51'  gubun, \n" +
				" e.nm as dept_nm, \n" +
				" decode(u.user_pos,'대표이사',1,'이사', 2, '팀장', 3, '차장', 4 , '과장', 5, '대리', 6,  9) pos_sort, \n" +
				"     sum(decode(acct_code_g2, '11', a1_amt, 0)) a1_1,  sum(decode(acct_code_g2, '12', a1_amt, 0)) a1_2, sum(decode(acct_code_g2, '13', a1_amt, 0)) a1_3, \n" +
				"     sum(decode(acct_code_g2, '11', a2_amt, 0)) a2_1,  sum(decode(acct_code_g2, '12', a2_amt, 0)) a2_2, sum(decode(acct_code_g2, '13', a2_amt, 0)) a2_3, \n" +
				"     sum(decode(acct_code_g2, '11', a3_amt, 0)) a3_1,  sum(decode(acct_code_g2, '12', a3_amt, 0)) a3_2, sum(decode(acct_code_g2, '13', a3_amt, 0)) a3_3, \n" +
				"     sum(decode(acct_code_g2, '11', a4_amt, 0)) a4_1,  sum(decode(acct_code_g2, '12', a4_amt, 0)) a4_2, sum(decode(acct_code_g2, '13', a4_amt, 0)) a4_3 \n" +
				" from ( \n" +
				" select user_id, acct_code_g2, \n" +
				" sum(decode(buy_mm, '01', oil_amt, '02', oil_amt , '03', oil_amt, 0 ) ) a1_amt, \n" +
				" sum(decode(buy_mm, '04', oil_amt, '05', oil_amt , '06', oil_amt, 0 ) ) a2_amt, \n" +
				" sum(decode(buy_mm, '07', oil_amt, '08', oil_amt , '09', oil_amt, 0 ) ) a3_amt, \n" +
				" sum(decode(buy_mm, '10', oil_amt, '11', oil_amt , '12', oil_amt, 0 ) ) a4_amt  \n" +
				" from ( \n" +
				"  select buy_user_id user_id,  substr(buy_dt, 5, 2) buy_mm, acct_code_g2, sum(buy_amt) as oil_amt  \n" +
				"    from card_doc where acct_code = '00004' and buy_dt like '" + s_year + "%' \n" +
				"    group by  buy_user_id,  substr(buy_dt, 5, 2) , acct_code_g2 \n" +
				"    union all \n" +
				"  select   b.buy_user_id user_id, substr(a.p_pay_dt, 5, 2) buy_mm, b.acct_code_g2, sum(b.i_amt ) as oil_amt  \n"+        
				"		 from pay a, pay_item b  where a.reqseq=b.reqseq  and b.acct_code='45800'   and a.p_pay_dt like '"+s_year+"%'   \n"+
				"    group by  b.buy_user_id,  substr(a.p_pay_dt, 5, 2) , b.acct_code_g2 \n" +      
				"    union all \n" +
				"  select /*+ leading(b) merge(a) */  b.req_id user_id,  substr(b.req_dt, 5, 2) buy_mm, \n" +
			          "        decode(a.firm_nm , '(주)아마존카', '12', '13') acct_code_g2, sum(b.oil_amt) as oil_amt \n" +
			          "         from cont_n_view a, consignment b, ( select * from code where c_st= '0015' and code <> '0000' ) c , users u \n" +
			          "         where b.rent_mng_id= a.rent_mng_id and b.rent_l_cd = a.rent_l_cd \n" +
			          "         and b.cost_st = '1' and b.oil_amt > 0 and b.cons_cau = c.nm_cd(+) \n" +
			          "         and b.req_id = u.user_id   \n" +
			          "         and b.oil_amt > 0 and b.req_dt like '" + s_year + "%' \n" +
			          "     group by  b.req_id,  substr(b.req_dt, 5, 2) , decode(a.firm_nm , '(주)아마존카', '12', '13')  \n" +
				" ) a \n" +
				" group by user_id, acct_code_g2 \n" +
				" ) b , users u,  ( select c_st, code, nm_cd, nm from code where c_st = '0002' and code <> '0000'  ) e    \n" +
				" where b.user_id = u.user_id  and u.loan_st is null   and u.use_yn = 'Y'  and u.dept_id not in ( '1000') and u.dept_id = e.code \n" +
				" group by b.user_id, u.user_nm, u.dept_id , e.nm, decode(u.user_pos,'대표이사',1,'이사', 2, '팀장', 3, '차장', 4 , '과장', 5, '대리', 6,  9) \n" +
				" ) a \n" +
  				"	order by a.loan_st desc,  5, a.pos_sort,  a.user_id ";				
			
		 
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
			System.out.println("[JungSanDatabase:getCardJungOilDtStat]\n"+e);
			System.out.println("[JungSanDatabase:getCardJungOilDtStat]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}


	//유류대
	public Vector getCardJungOilDtStat1(String s_year)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
			
		query = " select b.user_id, u.user_nm, u.dept_id, u.loan_st,  \n" +
				" decode(u.dept_id,'0001','1','0002','2','0007','3','0008', '3') || u.loan_st as gubun, \n" +
				" decode(u.dept_id,'0001','영업팀','0002','고객지원팀','0007','부산지점','0008', '대전지점', '0009', '강남영업소', '0010', '광주지점', '0011', '대구지점') as dept_nm, \n" +
				" decode(u.user_pos,'대표이사',1,'이사', 2, '팀장', 3, '차장', 4 , '과장', 5, '대리', 6,  9) pos_sort, \n" +
				"     sum(decode(acct_code_g2, '11', a1_amt, 0)) a1_1,  sum(decode(acct_code_g2, '12', a1_amt, 0)) a1_2, sum(decode(acct_code_g2, '13', a1_amt, 0)) a1_3, \n" +
				"     sum(decode(acct_code_g2, '11', a2_amt, 0)) a2_1,  sum(decode(acct_code_g2, '12', a2_amt, 0)) a2_2, sum(decode(acct_code_g2, '13', a2_amt, 0)) a2_3, \n" +
				"     sum(decode(acct_code_g2, '11', a3_amt, 0)) a3_1,  sum(decode(acct_code_g2, '12', a3_amt, 0)) a3_2, sum(decode(acct_code_g2, '13', a3_amt, 0)) a3_3, \n" +
				"     sum(decode(acct_code_g2, '11', a4_amt, 0)) a4_1,  sum(decode(acct_code_g2, '12', a4_amt, 0)) a4_2, sum(decode(acct_code_g2, '13', a4_amt, 0)) a4_3 \n" +
				" from ( \n" +
				" select user_id, acct_code_g2, \n" +
				" sum(decode(buy_mm, '01', oil_amt, '02', oil_amt , '03', oil_amt, 0 ) ) a1_amt, \n" +
				" sum(decode(buy_mm, '04', oil_amt, '05', oil_amt , '06', oil_amt, 0 ) ) a2_amt, \n" +
				" sum(decode(buy_mm, '07', oil_amt, '08', oil_amt , '09', oil_amt, 0 ) ) a3_amt, \n" +
				" sum(decode(buy_mm, '10', oil_amt, '11', oil_amt , '12', oil_amt, 0 ) ) a4_amt  \n" +
				" from ( \n" +
				"  select buy_user_id user_id,  substr(buy_dt, 5, 2) buy_mm, acct_code_g2, sum(buy_amt) as oil_amt  \n" +
				"    from card_doc where acct_code = '00004' and buy_dt like '" + s_year + "%' \n" +
				"    group by  buy_user_id,  substr(buy_dt, 5, 2) , acct_code_g2 \n" +
				"    union all \n" +
				"  select   b.buy_user_id user_id, substr(a.p_pay_dt, 5, 2) buy_mm, b.acct_code_g2, sum(b.i_amt ) as oil_amt  \n"+        
				"		 from pay a, pay_item b  where a.reqseq=b.reqseq  and b.acct_code='45800'   and a.p_pay_dt like '"+s_year+"%'   \n"+
				"    group by  b.buy_user_id,  substr(a.p_pay_dt, 5, 2) , b.acct_code_g2 \n" +      
				"    union all \n" +
				"  select /*+ leading(b) merge(a) */  b.req_id user_id,  substr(b.req_dt, 5, 2) buy_mm, \n" +
			          "        decode(a.firm_nm , '(주)아마존카', '12', '13') acct_code_g2, sum(b.oil_amt) as oil_amt \n" +
			          "         from cont_n_view a, consignment b, ( select * from code where c_st= '0015' and code <> '0000' ) c , users u \n" +
			          "         where b.rent_mng_id= a.rent_mng_id and b.rent_l_cd = a.rent_l_cd \n" +
			          "         and b.cost_st = '1' and b.oil_amt > 0 and b.cons_cau = c.nm_cd(+) \n" +
			          "         and b.req_id = u.user_id   \n" +
			          "         and b.oil_amt > 0 and b.req_dt like '" + s_year + "%' \n" +
			          "     group by  b.req_id,  substr(b.req_dt, 5, 2) , decode(a.firm_nm , '(주)아마존카', '12', '13')  \n" +
				" ) a \n" +
				" group by user_id, acct_code_g2 \n" +
				" ) b , users u \n" +
				" where b.user_id = u.user_id  and u.loan_st in ('1', '2')  and u.use_yn = 'Y' \n" +
				" group by b.user_id, u.user_nm, u.dept_id , decode(u.user_pos,'대표이사',1,'부장', 2, '팀장', 3, '차장', 4 , '과장', 5, '대리', 6,  9) ,  u.loan_st \n" +
				" order by u.loan_st desc,  5, decode(u.user_pos,'대표이사',1,'이사', 2, '부장', 3, '차장', 4 , '과장', 5, '대리', 6,  9),  b.user_id";
		 
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
			System.out.println("[JungSanDatabase:getCardJungOilDtStat]\n"+e);
			System.out.println("[JungSanDatabase:getCardJungOilDtStat]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	
	//유류대
	public Vector getCardJungOilDtStatList(String ref_dt1,String ref_dt2, String gubun3, String gubun4)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	
				
		query = " select b.* from ( \n"+
			     "    select  a.buy_dt, b.user_nm, a.buy_user_id, b1.user_nm owner_nm, a.acct_code_g2,  \n"+
		                "     decode(a.acct_code_g2,'11','업무차량', '12', '예비차량', '13', '고객차량' ) acct_code_g2_nm, \n"+
		                "     cr.car_no, cr.car_nm , v.firm_nm , c.nm c_nm, a.buy_amt , 'CD' gubun , a.m_amt m_amt , a.oil_liter ,  a.tot_dist \n"+
						" from card_doc a, users b, users b1, cont_n_view v,  car_reg cr,  ( select * from code where c_st= '0015' and code <> '0000' ) c, \n"+
						" (select cardno, max(seq) seq from card_user group by cardno) f, card_user g \n"+
						" where a.acct_code = '00004' and a.rent_l_cd = v.rent_l_cd  and v.car_mng_id = cr.car_mng_id(+) and a.buy_user_id=b.user_id and a.o_cau = c.nm_cd(+) \n"+
						" and a.cardno=f.cardno(+) and f.cardno=g.cardno(+) and f.seq=g.seq(+) and g.user_id=b1.user_id(+)  \n"+
				        " and a.buy_dt between replace('"+ref_dt1+"','-','') and replace('"+ref_dt2+"','-','')  \n"+        
				"  union all       \n"+ 																																																																																																																																																																																																																																																
				"	 select  a.p_pay_dt buy_dt, u.user_nm, b.buy_user_id,'' owner_nm, b.acct_code_g2,    \n"+        																																																																																																																																																																																																																																																
			         "        decode(b.acct_code_g2,'11','업무차량', '12', '예비차량', '13', '고객차량' ) acct_code_g2_nm,   \n"+        																																																																																																																																																																																																																																																
			         "     cr.car_no, cr.car_nm , v.firm_nm , c.nm c_nm, b.i_amt buy_amt , 'CA' gubun , b.m_amt m_amt  , 0 oil_liter , nvl(b.tot_dist,0) tot_dist  \n"+        																																																																																																																																																																																																																																																
				"		 from pay a, pay_item b,  users u, cont_n_view v, car_reg cr,  ( select * from code where c_st= '0015' and code <> '0000' ) c   \n"+        																																																																																																																																																																																																																																																
				"		 where a.reqseq=b.reqseq  and b.acct_code='45800'  and b.p_cd2 = v.rent_l_cd and v.car_mng_id = cr.car_mng_id and b.buy_user_id=u.user_id and b.o_cau = c.nm_cd(+) 		\n"+          																																																																																																																																																																																																																																																
				"	         and a.p_pay_dt between replace('"+ref_dt1+"','-','') and replace('"+ref_dt2+"','-','')         \n"+        																																																																																																																																																																																																																																																
		            	" union all       \n"+ 
		             	" select /*+ leading(b) merge(a) */ substr(b.from_req_dt, 1, 8)  buy_dt, u.user_nm, b.req_id buy_user_id,  '' owner_nm,\n"+
		                   "      decode(a.firm_nm , '(주)아마존카', '12', '13') acct_code_g2,\n"+
		                   "      decode(a.firm_nm , '(주)아마존카', '예비차량', '고객차량') acct_code_g2_nm,\n"+
		                   "      cr.car_no, cr.car_nm, a.firm_nm, c.nm c_nm , b.oil_amt buy_amt  ,  'CA' gubun  , b.m_amt m_amt , 0 oil_liter ,0 tot_dist \n"+       
		                   " from cont_n_view a, consignment b,  car_reg cr, ( select * from code where c_st= '0015' and code <> '0000' ) c , users u \n"+
		                   " where b.rent_mng_id= a.rent_mng_id and b.rent_l_cd = a.rent_l_cd  and a.car_mng_id = cr.car_mng_id(+) \n"+
		                   " and b.cost_st = '1' and b.oil_amt > 0 and b.cons_cau = c.nm_cd(+) \n"+
		                " and b.req_id = u.user_id   \n"+
		                " and substr(b.from_req_dt, 1, 8) between replace('"+ref_dt1+"','-','') and replace('"+ref_dt2+"','-','') \n"+
		                " ) b , users u where b.buy_user_id = u.user_id \n";	                
                
			//용도구분
		if(!gubun3.equals(""))		query += " and b.acct_code_g2 = '"+gubun3+"'";
		
			//사용자
		if(!gubun4.equals(""))		query += " and b.buy_user_id = '"+gubun4+"'";	
		            
       query += " order by 1 ";
        
        
        
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
			System.out.println("[JungSanDatabase:getCardJungOilDtStatList(]\n"+e);
			System.out.println("[JungSanDatabase:getCardJungOilDtStatList(]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
			//유류대
	public Vector getJungMngStat(String s_year, String st_mon)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String f_date1="";
		String t_date1="";
		String t_mm="";		
				
		if(st_mon.equals("1")) { //1분기 1월~3월
			f_date1 = s_year+ "0101";
			t_date1 = s_year+ "0331";
			t_mm = s_year + "03";
		}
		if(st_mon.equals("2")) { //2분기 4월~6월
			f_date1 = s_year+ "0401";
			t_date1 = s_year+ "0630";
			t_mm = s_year + "06";
		}
		if(st_mon.equals("3")) { //3분기 7월~9월
			f_date1 = s_year+ "0701";
			t_date1 = s_year+ "0930";
			t_mm = s_year + "09";
		}
		if(st_mon.equals("4")) { //4분기 10월~12월
			f_date1 = s_year+ "1001";
			t_date1 = s_year+ "1231";
			t_mm = s_year + "12";
		}
		
		
		
		query = " select c.user_id, c.user_nm, c.dept_id, c.loan_st, c.gubun, c.dept_nm, c.pos_sort, b.car_no, b.car_nm ,  \n" +
        		"   sum(amt) amt, sum(oil_amt) oil_amt, sum(case when c.est_tel = a2.est_tel then amt else 0 end) fee_s_amt  from (  \n" +
       			"   select c.user_id, c.user_nm, c.dept_id, c.loan_st,     \n" +
                "     decode(c.dept_id,'0001','1','0002','2','0007','3','0008', '3') || c.loan_st as gubun,    \n" +
                "     decode(c.dept_id,'0001','영업팀','0002','고객지원팀','0007','부산지점','0008', '대전지점') as dept_nm,    \n" +
                "     decode(c.user_pos,'대표이사',1,'이사', 2, '차장', 3, '팀장', 4 , '과장', 5, '대리', 6,  9) pos_sort,    \n" +
                "     nvl(a.fee_s_amt, 0)  amt , a.est_tel , nvl(d.oil_amt, 0)  oil_amt   \n" +
                "     from estimate_sh a, users c,   \n" +
                "         ( select  est_nm , est_tel, max(rent_dt) rent_dt from estimate_sh where est_from ='emp_car' and est_fax='Y' and est_tel||'01' between '" + f_date1 + "' and '"+ t_date1 + "' group by est_nm, est_tel ) a1,   \n" +
                "         ( select buy_user_id, substr(buy_dt, 1, 6) buy_ym, sum(buy_amt) as oil_amt from card_doc where   acct_code = '00004' and acct_code_g2 = '11' and buy_dt between '" + f_date1 + "' and '"+ t_date1 + "' group by buy_user_id , substr(buy_dt, 1, 6)) d  \n" +
                "          where a.est_from ='emp_car' and a.est_fax='Y'    \n" +                        
                "             and a.est_nm = a1.est_nm and a.est_tel = a1.est_tel and a.rent_dt = a1.rent_dt   \n" +
                "             and a.est_nm=c.user_id and c.user_pos in ('사원','대리','과장') and  c.loan_st in ('1', '2' )  and c.user_id not in ('000076')  \n" +
                "             and a.est_tel||'01' between '" + f_date1 + "' and '"+ t_date1 + "'   \n" +
                "             and a.est_nm = d.buy_user_id(+)    \n" +
                "             and a.est_tel = d.buy_ym(+)     \n" +
                "             order by c.user_id  \n" +
				"        ) c, car_reg b,   \n" +
				"       ( select  distinct a.est_nm, a.est_ssn, a.est_tel from estimate_sh a, (select est_nm, max(rent_dt) rent_dt from estimate_sh where est_from ='emp_car' and est_fax='Y' and est_tel||'01' between '" + f_date1 + "' and '"+ t_date1 + "' group by est_nm ) b \n" +
				"            where  a.est_nm =  b.est_nm and a.rent_dt = b.rent_dt ) a2  \n" +
				"       where  c.user_id = a2.est_nm and a2.est_ssn=b.car_mng_id  \n" +
				"        group by c.user_id, c.user_nm, c.dept_id, c.loan_st, c.gubun, c.dept_nm, c.pos_sort , b.car_no, b.car_nm \n" +
				"   	order by c.loan_st desc,  5, amt+oil_amt asc ";    	
        	
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
			System.out.println("[JungSanDatabase:getJungMngStat]\n"+e);
			System.out.println("[JungSanDatabase:getJungMngStat]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	
    //마감 유류대정산
	public Vector getCarOilStat(String s_year, String st_mon)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String f_date1="";
		String t_date1="";
		String t_mm="";		
		String user_not = "";		
						
		query = " select a.*,  u.user_nm  \n" +
			    "	from STAT_CAR_OIL a , users u  \n" +
			    "	where a.c_yy ='" + s_year + "' and a.c_mm ='" + st_mon + "' and a.user_id = u.user_id  and a.magam = 'Y' \n" +
			    "	order by a.loan_st , a.gubun , a.amt+a.oil_amt+nvl(a.oil_1_amt,0)+nvl(a.oil_2_amt,0)  asc";
        	
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
			System.out.println("[JungSanDatabase:getCarOilStat]\n"+e);
			System.out.println("[JungSanDatabase:getCarOilStat]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	} 


    //마감전 유류대정산 - 20120604 유류대정산은 마감으로 변경 (실시간에서) - 201208 입사자 제외 (2012년 3분기)
	public Vector getJungCarOilStat(String s_year, String st_mon)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String f_date1="";
		String t_date1="";
		String t_mm="";		
		String user_not = "";		
		
		if ( !st_mon.equals(""))	{
		    query = " select  a.* ,  u.user_nm  \n" +
			    "	from STAT_CAR_OIL a , users u  \n" +
			    "	where a.c_yy ='" + s_year + "' and a.user_id = u.user_id    \n" ;	
	    	query += " and a.c_mm ='" + st_mon + "'  \n" ;	     
		    query +=	  "	order by a.loan_st , a.gubun , a.cal_amt   asc";
		} else {
		
			query = "select a.r_loan_st loan_st , b.user_id, b.car_no, b.gubun, b.car_nm, b.fuel_kd, b.fee_s_amt, b.cont_s_amt, a.user_nm,   \n" +
		       " sum(amt) amt, sum(oil_amt) oil_amt, sum(tot_amt) tot_amt, sum(cal_amt) cal_amt, sum(jung_amt) jung_amt, sum(sale_cnt) sale_cnt,  \n" +
		       " sum(oil_1_amt) oil_1_amt, sum(oil_2_amt) oil_2_amt, trunc(avg(mng_cnt)) mng_cnt, trunc(avg(tot_cnt)) tot_cnt, trunc(avg(a_cnt)) a_cnt,  \n" +
		       " sum(cal_1_amt) cal_1_amt, sum(cal_2_amt) cal_2_amt, sum(d_amt) d_amt , sum(j_amt) j_amt , sum(hi_amt) hi_amt,  \n" +
		       " sum(oil_c_1_amt) oil_c_1_amt, sum(oil_c_2_amt) oil_c_2_amt, sum(j_1_amt) j_1_amt , sum(j_2_amt) j_2_amt  \n" +
			   "		from ( select  a.* ,  u.user_nm  , u.loan_st r_loan_st  \n" +
			   "						from STAT_CAR_OIL a, users u      \n" +         
			   "						where a.c_yy ='" + s_year + "' and a.user_id = u.user_id  \n" + 
			   "		      )    a,     \n" + 
			   "		      (  select  a.user_id, a.car_no, a.gubun, a.car_nm, a.fuel_kd, a.fee_s_amt, a.cont_s_amt  \n" + 
			   "		          from  STAT_CAR_OIL a, ( select user_id, max(c_mm) m_c_mm from STAT_CAR_OIL where c_yy ='" + s_year + "'  group by user_id ) b   \n" +   
		       "			           where a.c_yy ='" + s_year + "' and a.user_id = b.user_id and a.c_mm = b.m_c_mm   \n" + 
		       "			       ) b  \n" + 
			   " 		  where a.user_id = b.user_id  \n" + 
			   "		 group by  a.r_loan_st ,  b.user_id, b.car_no, b.gubun, b.car_nm, b.fuel_kd, b.fee_s_amt, b.cont_s_amt , a.user_nm  \n" + 		  		 
			   "	 	order by 1 , 4 , 13 asc ";
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
			System.out.println("[JungSanDatabase:getCarOilStat]\n"+e);
			System.out.println("[JungSanDatabase:getCarOilStat]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	public boolean insertStatCarOil(String st_year, String st_mon, String u_u_id, String u_d_id, String u_l_st, String u_g, String u_p_s, String u_car_no, String u_car_nm, int i_amt, int i_oil_amt, int i_fee_s_amt, int i_tot_amt, int i_cal_amt, int i_jung_amt )					
	{
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
	
		query = " INSERT INTO STAT_CAR_OIL ("+
				"	SAVE_DT,				"+
				"	C_YY,				"+
				"	C_MM,				"+
				"	USER_ID,			"+
				"	DEPT_ID,			"+
				"	LOAN_ST,			"+
				"	POS_SORT,	        "+
				"	GUBUN,		        "+
				"	CAR_NO,			    "+
				"	CAR_NM,			    "+ //9				
				"	AMT,		    	"+
				"	OIL_AMT,			"+		
				"	FEE_S_AMT,			"+	
				"	TOT_AMT,			"+	
				"	CAL_AMT,			"+					
				"	JUNG_AMT			"+ //6
				" ) VALUES "+
				" ( to_char(sysdate,'YYYYMMdd'), ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
				"   ?, ?, ?, ?, ?, ?  )";

		try 
		{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,		st_year);
			pstmt.setString	(2,		st_mon);
			pstmt.setString	(3,		u_u_id );
			pstmt.setString	(4,		u_d_id );
			pstmt.setString	(5,		u_l_st );
			pstmt.setString	(6,		u_p_s );
			pstmt.setString	(7,		u_g );
			pstmt.setString	(8,		u_car_no );
			pstmt.setString	(9,		u_car_nm );
			pstmt.setInt	(10,	i_amt);
			pstmt.setInt	(11,	i_oil_amt);
			pstmt.setInt	(12,	i_fee_s_amt);
			pstmt.setInt	(13,	i_tot_amt);
			pstmt.setInt	(14,	i_cal_amt);	
			pstmt.setInt	(15,	i_jung_amt);			
			pstmt.executeUpdate();
			conn.commit();
			pstmt.close();
			
	  	} catch (Exception e) {
			System.out.println("[CardDatabase:insertStatCarOil]\n"+e);
			e.printStackTrace();
	  		flag = false;
	  		conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);			
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return flag;
		}
	}


	/* 유류대정산이 마감되었는지 확인 */
	public int checkStatCarOil(String c_yy, String c_mm)
      {
       	getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;	
		String query = "";		     
        int c_cnt = 0;
	           	        
	    query="SELECT count(0)  FROM STAT_CAR_OIL where C_YY = '"+ c_yy + "' and C_MM = '"+ c_mm + "' and magam = 'Y' "; 
		
		try{
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
	            
	        if(rs.next())
				c_cnt = rs.getInt(1);
	
	        rs.close();
	        pstmt.close();
		} catch (SQLException e) {
			System.out.println("[JungSanDatabase:checkStatCarOil]\n"+e);
			System.out.println("[JungSanDatabase:checkStatCarOil]\n"+query);
		  	e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return c_cnt;
		}		
	}
	
	
	/*
	 *	유류대정산 프로시져 호출
	*/
	public String call_sp_oil_jungsan(String st_year, String st_mon)
	{
    	 	getConnection();
    	    	
    		String f_date1="";
		String t_date1="";
						
		if(st_mon.equals("1")) { //1분기 1월~3월
			f_date1 = st_year+ "0101";
			t_date1 = st_year+ "0331";			
		}
		if(st_mon.equals("2")) { //2분기 4월~6월
			f_date1 = st_year+ "0401";
			t_date1 = st_year+ "0630";		
		}
		if(st_mon.equals("3")) { //3분기 7월~9월
			f_date1 = st_year+ "0701";
			t_date1 = st_year+ "0930";			
		}
		if(st_mon.equals("4")) { //4분기 10월~12월
			f_date1 = st_year+ "1001";
			t_date1 = st_year+ "1231";			
		}
			    	
    	String query = "{CALL P_OIL_JUNGSAN (?, ?, ?, ?, ?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, st_year);
			cstmt.setString(2, st_mon);
			cstmt.setString(3, f_date1);
			cstmt.setString(4, t_date1);
			cstmt.registerOutParameter( 5, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(5); // 결과값
			cstmt.close();
				
	
		} catch (SQLException e) {
			System.out.println("[JungSanDatabase:call_sp_oil_jungsan]\n"+e);
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
     *  유류대 정산 마감등록
     */
    public int updateOilJungMagam(String st_yy, String st_mm) {
		getConnection();
            
 		int result = 0;
		PreparedStatement pstmt = null;
		String query = "";
        query=" UPDATE  stat_car_oil SET magam = 'Y'   WHERE c_yy  = '"+st_yy+"' and c_mm = '"+st_mm+"' and magam = 'N' " ;				

	try 
		{
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

		   	result = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		    
	  	} catch (Exception e) {
	  		System.out.println("[JungSanDatabase:updateCardScan]\n"+e);
			System.out.println("[JungSanDatabase:updateCardScan]\n"+query);
	  		e.printStackTrace();
			conn.rollback();
		} finally {
			try{
				conn.setAutoCommit(true);
				if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}
	
	
		/* 유류대 캠페인 사용자 적용 */
     public int  getM_cnt(String s_year, String s_mon)
      {
       	getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;		
		Vector vt = new Vector();
		String query = "";
		int m_cnt = 0;
		           	        
	  //   query="SELECT  count(0)  FROM STAT_CAR_OIL  where c_yy= '"+ s_year + "'  and  c_mm = '"+ s_mon + "' and magam = 'Y'   and  gong_amt  <> 0  "; 
	     query="SELECT  count(0)  FROM STAT_CAR_OIL  where c_yy= '"+ s_year + "'  and  c_mm = '"+ s_mon + "' and magam = 'Y'    "; 
	
	
	       try {
			pstmt = conn.prepareStatement(query);
		    rs = pstmt.executeQuery();
		      
		    if(rs.next())
			{				
				m_cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[JungSanDatabase::getM_cnt(]\n"+e);
			System.out.println("[JungSanDatabase::getM_cnt(]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return m_cnt;
		}		
	}

    	
//정산서 - 월별내용 보기(임원포함)   = to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm') ";
public Vector getCardJungDtStatONew_mon(String dt, String st_year, String st_mon, String ref_dt1, String ref_dt2, String br_id, String dept_id, String user_nm)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
     	
		String f_date1="";
		String t_date1="";
		
		String p_date = "";
		
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		
		f_date1 = ref_dt1;
		t_date1 = ref_dt2;			
	
		query = " select b.*  \n"+
				" from (  \n"+
				"        select  RANK() OVER (ORDER BY ave_amt ASC) AS amt_rnk, RANK() OVER (ORDER BY  r_ave_dist desc) AS dist_rnk, a.*  \n"+
  			  	"        from (  \n"+
		 		"               SELECT u.use_yn, a.user_id, u.user_nm, u.user_pos, u.br_id, \n"+
				"                      decode( u.br_id, 'S1', '1', 'B1', '2', 'D1', '3', '4' ) AS br_sort, decode(u.user_pos,'대표이사',1,'이사', 2, '팀장', 3, '차장', 4 , '과장', 5, '대리', 6,  9)  pos_sort, \n"+
				"                      u.dept_id, e.nm as dept_nm,  \n"+
				"                      c.car_no, c.car_nm, e2.nm as fuel_kd,  \n"+
				"                      v.tot_dist,  v1.p_tot_dist,   v.tot_dist -  v1.p_tot_dist  r_tot_dist,     case when sum(a.oil_liter) = 0 then 0 else round(( v.tot_dist -  v1.p_tot_dist) / sum( a.oil_liter ) , 1) end   ave_dist,  \n"+
				"                      nvl(case when sum(a.oil_liter) = 0 then 0 else round(( v.tot_dist -  v1.p_tot_dist) / sum( a.oil_liter ) , 1) end , 0.001)  r_ave_dist ,  \n"+
				"                      sum( a.oil_liter ) AS oil_liter , sum( a.oil_amt ) AS oil_amt  ,  case when sum(a.oil_liter) = 0 then 0 else  round(sum( a.oil_amt ) /  sum( a.oil_liter ),1) end   ave_amt , a.row_cnt \n"+
				"               FROM  ( SELECT u.use_yn, u.user_id,  a.car_mng_id,  a.oil_liter, a.oil_amt, a.row_cnt  \n"+
				"                        FROM   users u, \n"+
                                     	        //--oil 
				"                               ( SELECT a.buy_user_id user_id,  a.item_code car_mng_id,  sum(nvl(a.oil_liter,0)) oil_liter, sum( a.buy_amt ) AS oil_amt ,   \n"+
				"                                        count(0) OVER(PARTITION BY a.buy_user_id ) row_cnt   \n"+
				"	                              FROM   card_doc a   "+
				"                                 WHERE a.buy_dt BETWEEN replace( '" + f_date1 + "', '-', '' ) AND to_char(to_date('"+ t_date1 + "')-1 , 'yyyymmdd')    and a.acct_code = '00004'  and a.acct_code_g2 = '11'   \n"+
				"	                              GROUP BY a.buy_user_id,  a.item_code  "+
				"                               ) a \n"+	
				"                        WHERE u.user_id = a.user_id(+)  \n"+
				"                       ) a, \n"+
				"                       users u, car_reg c, \n"+
				"                       ( select c_st, code, nm_cd, nm from code where c_st = '0002' and code <> '0000'  ) e,  \n"+
				"                       ( select c_st, code, nm_cd, nm from code where c_st = '0039') e2,  \n"+
				"                      ( select a.item_code car_mng_id , max(a.tot_dist) tot_dist  \n"+
			    "   						from   card_doc a , ( select item_code, max(buy_dt) tot_dt from card_doc  \n"+
		        "  								where  buy_dt BETWEEN replace( '" + f_date1 + "', '-', '' ) AND to_char(to_date('"+ t_date1 + "')-1 , 'yyyymmdd') and acct_code = '00004'  and acct_code_g2 = '11'  group by item_code ) b   \n"+ 
		        "  							where a.item_code  = b.item_code and a.buy_dt = b.tot_dt  and a.acct_code = '00004'  and a.acct_code_g2 = '11'  group by a.item_code  \n"+
				//연비는 카드전표로만 - 20191104
				//"                       ( select a.car_mng_id , max(a.tot_dist) tot_dist  \n"+
				//"                         from   v_dist a , ( select car_mng_id, max(tot_dt) tot_dt from v_dist where  tot_dt BETWEEN replace( '" + f_date1 + "', '-', '' ) AND to_char(to_date('"+ t_date1 + "')-1 , 'yyyymmdd')    group by car_mng_id ) b   \n"+
  				//"                         where a.car_mng_id  = b.car_mng_id and a.tot_dt = b.tot_dt group by a.car_mng_id \n"+
				"                       ) v ,  \n"+
				" 					( select a.item_code car_mng_id , max(a.tot_dist)  p_tot_dist \n"+
				"    					from   card_doc a , ( select item_code, max(buy_dt) tot_dt from card_doc \n"+
			    "   							 where  buy_dt  <=   to_char(to_date('"+ f_date1 + "')-1 , 'yyyymmdd')  and acct_code = '00004'  and acct_code_g2 = '11'    group by item_code ) b   \n"+
			  	"       			  where a.item_code  = b.item_code and a.buy_dt = b.tot_dt and a.acct_code = '00004'  and a.acct_code_g2 = '11'  group by a.item_code \n"+
  				//연비는 카드전표로만 - 20191104
  			//	"                       ( select a.car_mng_id , max(a.tot_dist)  p_tot_dist \n"+
			//	"                         from   v_dist a , ( select car_mng_id, max(tot_dt) tot_dt from v_dist where  tot_dt  <=   to_char(to_date('"+ f_date1 + "')-1 , 'yyyymmdd')     group by car_mng_id ) b   \n"+
  			//	"                         where a.car_mng_id  = b.car_mng_id and a.tot_dt = b.tot_dt  group by a.car_mng_id \n"+
				"                       ) v1   \n"+  				
				"               WHERE a.user_id = u.user_id and u.dept_id = e.code and c.fuel_kd=e2.nm_cd and  a.user_id NOT IN ( '000037', '000035', '000044', '000047' , '000071' , '000081', '000094', '000095', '000103', '000104', '000105','000102' ) \n"+
				"               and   a.car_mng_id = c.car_mng_id(+)  and a.car_mng_id = v.car_mng_id(+)  and a.car_mng_id = v1.car_mng_id(+)   \n"+
				"               AND u.dept_id NOT IN ( '8888' )  AND  u.use_yn = 'Y'    and a.oil_amt > 0  \n";
		
 
		query += "               GROUP BY u.use_yn, a.user_id, u.user_nm, u.user_pos, u.br_id, u.dept_id, e.nm,  c.car_no, c.car_nm, e2.nm, v.tot_dist,  v1.p_tot_dist , a.row_cnt \n";
		query += "           ) a \n";
		query += "    ) b ";
		
		if(dt.equals("1")){
			query += " order by decode(b.row_cnt, 1 , b.dist_rnk, 999 ) asc , decode(b.row_cnt, 1 , '100000', b.user_id ) , decode(b.user_pos,'대표이사',6,'이사',7,'팀장',8,'차장', 9, 5)   \n";
		
		} else {
			query += " order by decode(b.row_cnt, 1 , b.amt_rnk, 999 ) asc , decode(b.row_cnt, 1 , '100000', b.user_id ) , decode(b.user_pos,'대표이사',6,'이사',7,'팀장',8,'차장', 9, 5)   \n";
	
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
			System.out.println("[JungSanDatabase:getCardJungDtStatONew_mon]\n"+e);
			System.out.println("[JungSanDatabase:getCardJungDtStatONew_mon]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	
	
	//정산서 - 개인별 세부내용 보기- 유류비
	public Vector getCardJungDtStatONew_1st(String dt, String st_year, String ref_dt1, String ref_dt2, String br_id, String dept_id, String user_id, String s_gubun3)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
     	     		     		
		String f_date1="";
		String t_date1="";

		String s_user_id = "";
	
		String s_year = Integer.toString(AddUtil.getDate2(1));	
		String s_month =Integer.toString(AddUtil.getDate2(2));	
		s_month = AddUtil.addZero(s_month);

		if(s_gubun3.equals("")){
			s_user_id = user_id;
		}else{
			s_user_id = s_gubun3;
		}

		if(dt.equals("2")) {
			if(!st_year.equals("")){
				f_date1 = st_year+ "0101";
				t_date1 = st_year+ "1231";
			}else{
				f_date1 = s_year+ "0101";
				t_date1 = s_year+ "1231";
			}
		}			
										
		query =   "	SELECT substr(a.buy_dt, 1, 4 ) yyyy, substr( a.buy_dt, 5, 2 ) mm, u.use_yn, a.user_id, u.user_nm,  \n"+
			      "	       c.car_no, c.car_nm, d.nm as fuel_kd,   \n"+
			      "	       v.tot_dist ,  v1.p_tot_dist ,   v.tot_dist -  v1.p_tot_dist  r_tot_dist,   case when sum(a.oil_liter) = 0 then 0 else round(( v.tot_dist -  v1.p_tot_dist) / sum( a.oil_liter ) , 1) end   ave_dist,     \n"+
			      "        sum( a.oil_liter ) AS oil_liter , sum( a.oil_amt ) AS oil_amt  , case when sum(a.oil_liter) = 0 then 0 else  round(sum( a.oil_amt ) /  sum( a.oil_liter ),1) end  ave_amt ,  a.row_cnt \n"+
			      "	FROM   ( SELECT u.use_yn, u.user_id, a.buy_dt, a.car_mng_id, a.oil_liter, a.oil_amt,  a.row_cnt \n"+
			      "          FROM   users u,   \n"+
			      "	                ( SELECT a.buy_user_id user_id,  a.item_code car_mng_id, substr(a.buy_dt,1,6) buy_dt, sum( a.oil_liter ) oil_liter, sum( a.buy_amt ) AS oil_amt  ,  \n"+
			      "                          count(0) OVER(PARTITION BY substr(a.buy_dt,1,6)||a.buy_user_id) row_cnt   \n"+
			      "		              FROM card_doc a   WHERE a.buy_dt BETWEEN replace( '" + f_date1 + "', '-', '' ) AND replace( '" + t_date1 + "', '-', '' ) and a.acct_code = '00004'  and a.acct_code_g2 = '11'    \n"+
			      "		              GROUP BY a.buy_user_id,  a.item_code, substr(a.buy_dt,1,6) \n"+
			      "                 ) a      \n"+
			      "	         WHERE u.user_id = a.user_id(+) \n"+
			      "        ) a, users u  , car_reg c , \n"+
				  "		 (  select a.item_code car_mng_id , substr(a.buy_dt, 1, 6) tot_dt, max(a.tot_dist) tot_dist  \n"+
				  "		         from card_doc a , ( select item_code , substr(buy_dt,1,6),  max(buy_dt) tot_dt   \n"+
			      "            from card_doc where  buy_dt BETWEEN replace( '" + f_date1 + "', '-', '' ) AND replace( '" + t_date1 + "', '-', '' ) and acct_code = '00004'  and acct_code_g2 = '11'   \n"+
			      "            group by item_code , substr(buy_dt,1,6) ) b \n"+  
				  "		        where a.item_code  = b.item_code and a.buy_dt = b.tot_dt and a.acct_code = '00004' and a.acct_code_g2 = '11'  \n"+  
				  "		         group by a.item_code , substr(a.buy_dt, 1, 6) \n"+  
			      // - 20191104 연비계산을 카드 전표에서만 			      
			      //"        ( select a.car_mng_id , substr(a.tot_dt, 1, 6) tot_dt, max(a.tot_dist) tot_dist  \n"+
			      //"          from v_dist a , ( select car_mng_id, substr(tot_dt,1,6),  max(tot_dt) tot_dt from v_dist where  tot_dt BETWEEN replace( '" + f_date1 + "', '-', '' ) AND replace( '" + t_date1 + "', '-', '' )  group by car_mng_id , substr(tot_dt,1,6) ) b   \n"+
			      //"          where a.car_mng_id  = b.car_mng_id and a.tot_dt = b.tot_dt \n"+
			      //"          group by a.car_mng_id , substr(a.tot_dt, 1, 6) \n"+
			      "        ) v, \n"+
			      " (  select  car_mng_id, to_char(add_months(to_date(tot_dt||'01'), 1), 'yyyymm') tot_dt , tot_dist p_tot_dist  \n"+
		          "   from    ( select a.item_code car_mng_id, substr(a.buy_dt, 1, 6) tot_dt, max(a.tot_dist) tot_dist    \n"+ 
				  "	                   from   card_doc a,  ( select item_code, substr(buy_dt,1,6),  max(buy_dt) tot_dt  \n"+ 
	              "                     from card_doc where  substr(buy_dt,1,6)  BETWEEN   to_char( add_months(to_date( replace( '" + f_date1 + "', '-', '' )), -1) , 'yyyymm')   AND to_char( add_months(to_date( replace( '" + t_date1 + "', '-', '' )), -1) , 'yyyymm') \n"+
	              "                       and acct_code = '00004'  and acct_code_g2 = '11'  \n"+
	              "                      group by item_code , substr(buy_dt,1,6) ) b    \n"+ 
				  " 	            where  a.item_code  = b.item_code and a.buy_dt = b.tot_dt   and a.acct_code = '00004'  and a.acct_code_g2 = '11'  \n"+
				  "    	                group by a.item_code , substr(a.buy_dt, 1, 6)   ) a \n"+
			      //  // - 20191104 연비계산을 카드 전표에서만 	
			      //"        ( select  car_mng_id, to_char(add_months(to_date(tot_dt||'01'), 1), 'yyyymm') tot_dt , tot_dist p_tot_dist \n"+
			      //"          from    ( select a.car_mng_id, substr(a.tot_dt, 1, 6) tot_dt, max(a.tot_dist) tot_dist      \n"+
			      //"	                   from   v_dist a, ( select car_mng_id, substr(tot_dt,1,6),  max(tot_dt) tot_dt from v_dist where  substr(tot_dt,1,6)  BETWEEN   to_char( add_months(to_date( replace( '" + f_date1 + "', '-', '' )), -1) , 'yyyymm')   AND to_char( add_months(to_date( replace( '" + t_date1 + "', '-', '' )), -1) , 'yyyymm')  group by car_mng_id , substr(tot_dt,1,6) ) b       \n"+
			      //"	                   where  a.car_mng_id  = b.car_mng_id and a.tot_dt = b.tot_dt      \n"+
			      //"	                   group by a.car_mng_id , substr(a.tot_dt, 1, 6) \n"+
			      //"                  ) a \n"+
			      "        ) v1, \n"+
			      "        (select * from code where c_st='0039') d "+
			      " WHERE a.user_id = u.user_id AND a.user_id NOT IN ( '000000', '000035', '000037', '000044', '000047',  '000071', '000081', '000084', '000094', '000095', '000103', '000104', '000105', '000102' )   \n"+
			      "       and a.car_mng_id = c.car_mng_id(+)  and a.car_mng_id = v.car_mng_id(+) and a.buy_dt = v.tot_dt(+)  and a.car_mng_id = v1.car_mng_id(+) and a.buy_dt = v1.tot_dt(+)   \n"+
			      "       and c.fuel_kd=d.nm_cd "+
			      "       AND u.dept_id NOT IN ( '8888' )  AND ( u.use_yn = 'Y' OR u.out_dt > replace( '" + f_date1 + "', '-', '' )) AND a.user_id = '" + s_user_id + "'  \n";

		query += " GROUP BY u.use_yn, a.user_id, u.user_nm, substr( a.buy_dt, 1, 4 ), substr( a.buy_dt, 5, 2 ) , c.car_no, c.car_nm , d.nm, v.tot_dist , v1.p_tot_dist , a.row_cnt  \n";
		query += " order by 1, 2 ";

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
			System.out.println("[JungSanDatabase:getCardJungDtStatONew_1st]\n"+e);
			System.out.println("[JungSanDatabase:getCardJungDtStatONew_1st]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	/*
	 *	유류대 캠페인 반영  프로시져 호출
	*/
	public String call_sp_car_oil_cmp_jungsan(String o_year, String o_mon,  String st_year, String st_mon, String st_mode)
	{
    	 	getConnection();
    	    	    					    	
    		String query = "{CALL P_CAR_OIL_CMP_JUNGSAN (?, ?, ?, ?, ?, ?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, o_year);
			cstmt.setString(2, o_mon);
			cstmt.setString(3, st_year);
			cstmt.setString(4, st_mon);
			cstmt.setString(5, st_mode);		
			cstmt.registerOutParameter( 6, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(6); // 결과값
			cstmt.close();
				
	
		} catch (SQLException e) {
			System.out.println("[JungSanDatabase:call_sp_car_oil_cmp_jungsan]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
 
 
   //유류대 공제현황 
	public Vector getOilGongList(String o_year, String o_mon, String user_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String f_date1="";
		String t_date1="";
		String t_mm="";		
		String user_not = "";		
						
		query = " select  a.* ,  u.user_nm  \n" +
			    "	from stat_car_oil_gong a , users u  \n" +
			    "	where a.o_yy ='" + o_year + "' and a.o_mm ='" + o_mon + "' and a.user_id = u.user_id   and a.amt < 0  and a.user_id = '"+ user_id + "' \n" +
			    "	order by a.reg_dt  asc";
        	
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
			System.out.println("[JungSanDatabase:getOilGongList]\n"+e);
			System.out.println("[JungSanDatabase:getOilGongList]\n"+query);
	  		e.printStackTrace();
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}

	//유류대 : dt->2:5년내 , 4:기간 검색
	
	public Vector getCardJungOilDtStat(String dt, String ref_dt1, String ref_dt2, String sort)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		Vector vt = new Vector();
		String query = "";
				
		String sub_query = "";
		
		String f_date1="";
		String t_date1="";
								
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}
						       
	/*	       
		query = " select a.user_id, b.user_nm, b.u_mon, b.dept_id, b.user_pos, sum(a.oil_amt) oil_amt, round(sum(a.oil_amt) / b.u_mon ) a_oil from ( \n" +
		        " select a.buy_user_id user_id , a.buy_amt oil_amt \n" +
		        " from  card_doc a \n" +
		        "	 where a.acct_code = '00004' and a.acct_code_g2 = '11'       \n" +            					
		      	"        and a.buy_dt between replace('20170601','-','') and replace('20220531','-','')  \n" +
		        " union all  \n" +
		        "  select  b.buy_user_id user_id, b.i_amt  oil_amt			 \n" +																																																																																																																																																																																																																																		
		      	"   from pay a, pay_item b 	 \n" +																																																																																																																																																																																																																																														
		      	"     where a.reqseq=b.reqseq  and b.acct_code='45800'  and  b.acct_code_g2 = '11'     \n" +   																																																																																																																																																																																																																																																
		      	"  and a.p_pay_dt between replace('20170601','-','') and replace('20220531','-','')  \n" +    
		        " ) a, \n" +
		        "   ( select case when ( to_date('20220630') - to_date(enter_dt) ) /365*12 > 60 then 60  \n" +
		        "                                             else round(( to_date('20220630') - to_date(enter_dt) ) /365*12 ,1) end  u_mon, user_nm ,user_id , dept_id, user_pos  \n" +
		        "                                             from users   where use_yn = 'Y' \n" +
		        "                                             and ( dept_id not in ( '1000', '8888', '0003') or  user_id in ( '000004') ) and id not like 'devel%' ) b \n" +
		        " where a.user_id = b.user_id  \n" +
		        " group by a.user_id  , b.user_nm , b.u_mon , b.dept_id , b.user_pos  \n" + 
		        " order by 7 desc ";
		*/
		if(dt.equals("2")) {  // 5년내 	
			query = "  select a.user_id, b.user_nm, b.u_mon, b.dept_id, b.user_pos, c.fuel_kd, e2.nm fuel_nm, sum(a.oil_amt) oil_amt, \n" +
					" round(sum(decode(c.fuel_kd, '3', a.oil_amt , 0) ) / b.u_mon ) o1_amt ,  \n" +
					" round(sum(decode(c.fuel_kd, '8', a.oil_amt ,'9', a.oil_amt , 0) ) / b.u_mon ) o3_amt ,  \n" +
					" round(sum(decode(c.fuel_kd, '3', 0, '8', 0, '9', 0, a.oil_amt ) ) / b.u_mon)  o2_amt ,  \n" +
					" decode(c.fuel_kd, '3', b.u_mon , 0) u1_mon ,  \n" +
					" decode(c.fuel_kd, '8', b.u_mon , '9', b.u_mon , 0) u3_mon ,  \n" +
					" decode(c.fuel_kd, '3', 0, '8', 0,'9', 0, b.u_mon )  u2_mon ,  \n" +
					" round(sum(a.oil_amt) / b.u_mon ) a_oil from (  \n" +
					" select a.buy_user_id user_id , a.buy_amt oil_amt  \n" +
					" from  card_doc a  \n" +
					"	 where a.acct_code = '00004' and a.acct_code_g2 = '11'    \n" +
			        "     and a.buy_dt between to_char(add_months(sysdate, -60), 'yyyymmdd') and to_char(sysdate, 'yyyymmdd')  \n" +
			        " union all   \n" +
					"  select  b.buy_user_id user_id, b.i_amt  oil_amt		 \n" +	 
					"   from pay a, pay_item b 	 \n" + 
					"     where a.reqseq=b.reqseq  and b.acct_code='45800'  and  b.acct_code_g2 = '11'     \n" +
				 	"    and a.p_pay_dt between to_char(add_months(sysdate, -60), 'yyyymmdd') and to_char(sysdate, 'yyyymmdd')  \n" +
			        "  ) a,  \n" +
					"   ( select case when ( sysdate - to_date(enter_dt) ) /365*12 > 60 then 60   \n" +
					"                                             else round(( sysdate - to_date(enter_dt) ) /365*12 ,1) end  u_mon, user_nm ,user_id , dept_id, user_pos  \n" + 
					"                                             from users   where use_yn = 'Y'  \n" +
					"                                             and ( dept_id not in ( '1000', '8888', '0003') or  user_id in ( '000004') ) and id not like 'devel%' ) b , \n" +			                                     
					"   (   select a.bus_id, c.fuel_kd  from cont a,  \n" +
					"       ( select  bus_id, max(rent_start_dt)  rent_start_dt from cont where car_st = '5' and use_yn = 'Y'  group by bus_id) b  , car_reg c  \n" +
					"    where a.bus_id = b.bus_id and a.rent_start_dt = b.rent_start_dt    and a.car_mng_id = c.car_mng_id  and a.car_mng_id = c.car_mng_id  and a.car_st = '5' and a.use_yn = 'Y' ) c  \n" +
					"      , ( select c_st, code, nm_cd, nm from code where c_st = '0039'   ) e2    \n" +                             
					" where a.user_id = b.user_id   and a.user_id = c.bus_id  and c.fuel_kd = e2.nm_cd  \n" +
					" group by a.user_id  , b.user_nm , b.u_mon , b.dept_id , b.user_pos  , c.fuel_kd ,  e2.nm  \n" ;
				
		} else {
				query = "  select a.user_id, b.user_nm, b.u_mon, b.dept_id, b.user_pos, c.fuel_kd, e2.nm fuel_nm, sum(a.oil_amt) oil_amt, \n" +
						" round(sum(decode(c.fuel_kd, '3', a.oil_amt , 0) ) / b.u_mon ) o1_amt ,  \n" +
						" round(sum(decode(c.fuel_kd, '8', a.oil_amt ,'9', a.oil_amt , 0) ) / b.u_mon ) o3_amt ,  \n" +
						" round(sum(decode(c.fuel_kd, '3', 0, '8', 0, '9', 0, a.oil_amt ) ) / b.u_mon)  o2_amt ,  \n" +
						" decode(c.fuel_kd, '3', b.u_mon , 0) u1_mon ,  \n" +
						" decode(c.fuel_kd, '8', b.u_mon , '9', b.u_mon , 0) u3_mon ,  \n" +
						" decode(c.fuel_kd, '3', 0, '8', 0,'9', 0, b.u_mon )  u2_mon ,  \n" +
						" round(sum(a.oil_amt) / b.u_mon ) a_oil from (  \n" +
						" select a.buy_user_id user_id , a.buy_amt oil_amt  \n" +
						" from  card_doc a  \n" +
						"	 where a.acct_code = '00004' and a.acct_code_g2 = '11'    \n" +
						" and a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n" +
				        " union all   \n" +
						"  select  b.buy_user_id user_id, b.i_amt  oil_amt		 \n" +	 
						"   from pay a, pay_item b 	 \n" + 
						"     where a.reqseq=b.reqseq  and b.acct_code='45800'  and  b.acct_code_g2 = '11'     \n" +
						"    and a.p_pay_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n" +
				        "  ) a,  \n" +
						"   ( select round(( to_date(replace('" + t_date1 + "','-','')) - to_date( case when replace('" + f_date1 + "','-','') > enter_dt then replace('" + f_date1 + "','-','') else enter_dt end ) ) /365*12 ,1)  u_mon, user_nm ,user_id , dept_id, user_pos  \n" + 
						"                                             from users   where use_yn = 'Y'  \n" +
						"                                             and ( dept_id not in ( '1000', '8888', '0003') or  user_id in ( '000004') ) and id not like 'devel%' ) b , \n" +			                                     
						"   (   select a.bus_id, c.fuel_kd  from cont a,  \n" +
						"       ( select  bus_id, max(rent_start_dt)  rent_start_dt from cont where car_st = '5' and use_yn = 'Y'  group by bus_id) b  , car_reg c  \n" +
						"    where a.bus_id = b.bus_id and a.rent_start_dt = b.rent_start_dt    and a.car_mng_id = c.car_mng_id  and a.car_mng_id = c.car_mng_id  and a.car_st = '5' and a.use_yn = 'Y' ) c  \n" +
						"      , ( select c_st, code, nm_cd, nm from code where c_st = '0039'   ) e2    \n" +                             
						" where a.user_id = b.user_id   and a.user_id = c.bus_id  and c.fuel_kd = e2.nm_cd  \n" +
						" group by a.user_id  , b.user_nm , b.u_mon , b.dept_id , b.user_pos  , c.fuel_kd ,  e2.nm  \n" ;
		} 
	
		if ( sort.equals("1")){
			query +=	" order by 9 desc ";
		} else if ( sort.equals("2")){
			query +=	" order by 11 desc ";
		} else if ( sort.equals("3")){
			query +=	" order by 10 desc ";
		} else {
			query +=	" order by 15 desc ";	
		}
		
	//		System.out.println("query="+query);				
				
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
			System.out.println("[JungSanDatabase:getCardJungOilDtStat]\n"+e);
	  		e.printStackTrace();
			System.out.println(query);
		} finally {
			try{
				if ( rs != null )		rs.close();
				if ( pstmt != null )	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}		
	}
	
	
	//유류대 : dt->2:5년내 , 4:기간 검색
	
	public Vector getCardJungOilDtStatNew(String dt, String ref_dt1, String ref_dt2, String sort, String ck_acar_id)
		{
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			Vector vt = new Vector();
			String query = "";
					
			String sub_query = "";
			
			String f_date1="";
			String t_date1="";
									
			if(dt.equals("4")) {
				f_date1=  ref_dt1;
				t_date1=  ref_dt2;
			}
			
		
			query = " select a.user_id, a.user_nm, a.u_mon, a.dept_id, a.user_pos, a.fuel_kd, e2.nm fuel_nm ,  \n" +
					    "    a.o_amt oil_amt,   \n" +
					    "    round( a.o1_amt / decode (a.u1_mon, 0 , 1, a.u1_mon) ) o1_amt , \n" +					   
					    "    round( a.o3_amt / decode (a.u3_mon, 0 , 1, a.u3_mon) ) o3_amt , \n" +
					    "    round( a.o2_amt / decode (a.u2_mon, 0 , 1, a.u2_mon) ) o2_amt , \n" +					
					    "   a.u1_mon, a.u3_mon, a.u2_mon, a.c_ave a_oil , \n" +
					    "   a.o1_amt oil1_amt, a.o2_amt oil2_amt, a.o3_amt oil3_amt \n" +
						"   from car_oil a , ( select c_st, code, nm_cd, nm from code where c_st = '0039'  ) e2  \n" +
						"	   where   a.fuel_kd = e2.nm_cd  and gubun = '"+ dt + "'";
			
			if(dt.equals("4")) {						
				query +=" and reg_id = '"+ ck_acar_id + "'";
			}					
			/*	 
			} else {
					query = "  select a.user_id, b.user_nm, b.u_mon, b.dept_id, b.user_pos, c.fuel_kd, e2.nm fuel_nm, sum(a.oil_amt) oil_amt, \n" +
							" round(sum(decode(c.fuel_kd, '3', a.oil_amt , 0) ) / b.u_mon ) o1_amt ,  \n" +
							" round(sum(decode(c.fuel_kd, '8', a.oil_amt ,'9', a.oil_amt , 0) ) / b.u_mon ) o3_amt ,  \n" +
							" round(sum(decode(c.fuel_kd, '3', 0, '8', 0, '9', 0, a.oil_amt ) ) / b.u_mon)  o2_amt ,  \n" +
							" decode(c.fuel_kd, '3', b.u_mon , 0) u1_mon ,  \n" +
							" decode(c.fuel_kd, '8', b.u_mon , '9', b.u_mon , 0) u3_mon ,  \n" +
							" decode(c.fuel_kd, '3', 0, '8', 0,'9', 0, b.u_mon )  u2_mon ,  \n" +
							" round(sum(a.oil_amt) / b.u_mon ) a_oil from (  \n" +
							" select a.buy_user_id user_id , a.buy_amt oil_amt  \n" +
							" from  card_doc a  \n" +
							"	 where a.acct_code = '00004' and a.acct_code_g2 = '11'    \n" +
							" and a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n" +
					        " union all   \n" +
							"  select  b.buy_user_id user_id, b.i_amt  oil_amt		 \n" +	 
							"   from pay a, pay_item b 	 \n" + 
							"     where a.reqseq=b.reqseq  and b.acct_code='45800'  and  b.acct_code_g2 = '11'     \n" +
							"    and a.p_pay_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n" +
					        "  ) a,  \n" +
							"   ( select round(( to_date(replace('" + t_date1 + "','-','')) - to_date( case when replace('" + f_date1 + "','-','') > enter_dt then replace('" + f_date1 + "','-','') else enter_dt end ) ) /365*12 ,1)  u_mon, user_nm ,user_id , dept_id, user_pos  \n" + 
							"                                             from users   where use_yn = 'Y'  \n" +
							"                                             and ( dept_id not in ( '1000', '8888', '0003') or  user_id in ( '000004') ) and id not like 'devel%' ) b , \n" +			                                     
							"   (   select a.bus_id, c.fuel_kd  from cont a,  \n" +
							"       ( select  bus_id, max(rent_start_dt)  rent_start_dt from cont where car_st = '5' and use_yn = 'Y'  group by bus_id) b  , car_reg c  \n" +
							"    where a.bus_id = b.bus_id and a.rent_start_dt = b.rent_start_dt    and a.car_mng_id = c.car_mng_id  and a.car_mng_id = c.car_mng_id  and a.car_st = '5' and a.use_yn = 'Y' ) c  \n" +
							"      , ( select c_st, code, nm_cd, nm from code where c_st = '0039'   ) e2    \n" +                             
							" where a.user_id = b.user_id   and a.user_id = c.bus_id  and c.fuel_kd = e2.nm_cd  \n" +
							" group by a.user_id  , b.user_nm , b.u_mon , b.dept_id , b.user_pos  , c.fuel_kd ,  e2.nm  \n" ;
			} 
		*/
			
			if ( sort.equals("1")){
				query +=	" order by 9 desc ";
			} else if ( sort.equals("2")){
				query +=	" order by 11 desc ";
			} else if ( sort.equals("3")){
				query +=	" order by 10 desc ";
			} else {
				query +=	" order by 15 desc ";	
			}
			
		//  System.out.println("query="+query);				
					
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
				System.out.println("[JungSanDatabase:getCardJungOilDtStatNew]\n"+e);
		  		e.printStackTrace();
				System.out.println(query);
			} finally {
				try{
					if ( rs != null )		rs.close();
					if ( pstmt != null )	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return vt;
			}		
		}
	
	    
	/*
	 *	유류대정산 프로시져 호출 
	*/
	public String call_sp_oil_jungsanNew(String dt, String st_dt , String en_dt, String ck_acar_id)
	{
    	getConnection();
    					    	
    	String query = "{CALL P_CAR_OIL(?, ?, ?, ?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, dt);
			cstmt.setString(2, st_dt);
			cstmt.setString(3, en_dt);
			cstmt.setString(4, ck_acar_id);
						
			cstmt.execute();		
			cstmt.close();
					
		} catch (SQLException e) {
			System.out.println("[JungSanDatabase:call_sp_oil_jungsanNew]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	
}


	