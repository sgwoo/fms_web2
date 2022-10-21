package acar.off_anc;

import java.util.*;
import java.sql.*;
import acar.util.*;
import java.text.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;


public class OffPropDatabase {


    private static OffPropDatabase instance;
    private DBConnectionManager connMgr;   
    // Pool로 부터 Connection 객체를 가져올때 사용하는 Pool Name 
    private final String DATA_SOURCE = "acar"; 
 
    // 싱글톤 클래스로 구현 
    // 생성자를 private 로 선언
    public static synchronized OffPropDatabase getInstance() throws DatabaseException {
        if (instance == null)
            instance = new OffPropDatabase();
        return instance;
    }
    
    private OffPropDatabase() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }
    
    //제안함 리스트
	public Vector getOffPropList(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt, String gubun2, String gubun3, String gubun4, String user_id )throws DatabaseException, DataSourceEmptyException{
	
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String useyn = "";
		
		
		if (gubun3.equals("1")) {
			useyn = "'Y'" ;			
		}else if (gubun3.equals("2")) {
			useyn = "'N'" ;
	
		} else  if (gubun3.equals("0")) {
			useyn = "'N', 'Y'" ;
		}	


		query = " select a.*, b.user_nm, c.br_nm, d.nm, nvl(f.cnt1,0) cnt1, nvl(f.cnt2,0) cnt2, nvl(f.cnt3,0) cnt3,"+
				" decode(nvl(e.cnt,0),0,'N','Y') read_yn, a.open_yn,  "+
				" decode(a.prop_step,'1','수렴','2','심사', '3','재심', '6','처리중','7','완료', '5','보류' , '9', '이관' ) step,"+
				" decode(a.reg_dt,to_char(sysdate,'YYYYMMDD'),'new') new_yn,"+
				" decode(b.loan_st,'',0,1) loan_st, \n"+
				" nvl(ff.r_cnt1,0) r_cnt1, nvl(ff.r_cnt2,0) r_cnt2, nvl(ff.r_cnt3,0) r_cnt3, \n"+

				" decode(g.e_amt3,'','미등록',0,'미등록','-') eval_e3, \n"+
				" decode(g.e_amt4,'','미등록',0,'미등록','-') eval_e4, \n"+
				" decode(g.e_amt5,'','미등록',0,'미등록','-') eval_e5, \n"+
				" decode(g.e_amt6,'','미등록',0,'미등록','-') eval_e6, \n"+
				" decode(g.e_amt7,'','미등록',0,'미등록','-') eval_e7, \n"+

				" decode(a.use_yn,'Y',decode(gg.p_amt3,'','미등록',0,'미등록','-'),'M',decode(gg.p_amt3,'','미등록',0,'미등록','-'),'-') eval_p3, \n"+
				" decode(a.use_yn,'Y',decode(gg.p_amt4,'','미등록',0,'미등록','-'),'M',decode(gg.p_amt4,'','미등록',0,'미등록','-'),'-') eval_p4, \n"+
				" decode(a.use_yn,'Y',decode(gg.p_amt5,'','미등록',0,'미등록','-'),'M',decode(gg.p_amt5,'','미등록',0,'미등록','-'),'-') eval_p5, \n"+
				" decode(a.use_yn,'Y',decode(gg.p_amt6,'','미등록',0,'미등록','-'),'M',decode(gg.p_amt6,'','미등록',0,'미등록','-'),'-') eval_p6, \n"+
				" decode(a.use_yn,'Y',decode(gg.p_amt7,'','미등록',0,'미등록','-'),'M',decode(gg.p_amt7,'','미등록',0,'미등록','-'),'-') eval_p7, \n"+

				" decode(h.prop_id,'',f.cnt1+f.cnt2||'건', decode(f.cnt1+f.cnt2-h.e_cnt3,0,'-',f.cnt1+f.cnt2-h.e_cnt3||'건')) eval_c3, \n"+
				" decode(h.prop_id,'',f.cnt1+f.cnt2||'건', decode(f.cnt1+f.cnt2-h.e_cnt4,0,'-',f.cnt1+f.cnt2-h.e_cnt4||'건')) eval_c4, \n"+
				" decode(h.prop_id,'',f.cnt1+f.cnt2||'건', decode(f.cnt1+f.cnt2-h.e_cnt5,0,'-',f.cnt1+f.cnt2-h.e_cnt5||'건')) eval_c5, \n"+
				" decode(h.prop_id,'',f.cnt1+f.cnt2||'건', decode(f.cnt1+f.cnt2-h.e_cnt6,0,'-',f.cnt1+f.cnt2-h.e_cnt6||'건')) eval_c6,  \n"+
				" decode(h.prop_id,'',f.cnt1+f.cnt2||'건', decode(f.cnt1+f.cnt2-h.e_cnt7,0,'-',f.cnt1+f.cnt2-h.e_cnt7||'건')) eval_c7  \n"+

//				" case when a.use_yn = 'Y' then decode(gg.p_amt,'','미등록','-') else '-' end  eval_st3, "+
//			 	" case when nvl(f.cnt1,0) + nvl(f.cnt2,0) = 0 then '-' else decode( nvl(f.cnt1,0) + nvl(f.cnt2,0)- nvl(h.cnt,0), 0, '-',  nvl(f.cnt1,0) + nvl(f.cnt2,0)- nvl(h.cnt,0) ||'건') end eval_st2 "+
				" from prop_bbs a, users b, branch c, \n"+
				" (select * from code where c_st='0002' and code<>'0000') d,\n"+
				" (select prop_id, count(0) cnt from prop_comment where com_st='1' and reg_id='"+user_id+"' group by prop_id) e,\n"+
				" (select prop_id, count(decode(com_st,'1',prop_id)) cnt1, count(decode(nvl(com_st, '2'),'2',prop_id)) cnt2, count(decode(com_st,'3',prop_id)) cnt3 from prop_comment where reg_id not in ('000003','000004','000005','000006', '000026', '000237') group by prop_id) f,\n"+
				" (select prop_id, count(decode(yn,'0',prop_id)) r_cnt1, count(decode(yn,'1',prop_id)) r_cnt2, count(decode(yn,'2',prop_id)) r_cnt3 from prop_comment where reg_id not in ('000003','000004','000005','000006' , '000026' , '000237') group by prop_id) ff,\n"+
				
				" (select a.prop_id, b.e_amt3, b.e_amt4, b.e_amt5, b.e_amt6 , b.e_amt7 "+
				"  from   prop_bbs a, "+
				"		  (select prop_id, seq, "+
				"	              nvl(sum(decode(eval_id,'000003',e_amt)),0) e_amt3, "+
				"	              nvl(sum(decode(eval_id,'000004',e_amt)),0) e_amt4, "+
				"	              nvl(sum(decode(eval_id,'000005',e_amt)),0) e_amt5, "+
				"	              nvl(sum(decode(eval_id,'000006',e_amt)),0) + nvl(sum(decode(eval_id,'000026',e_amt)),0) e_amt6 , "+
				"	              nvl(sum(decode(eval_id,'000237',e_amt)),0) e_amt7  "+
				"	       from   prop_c_eval where seq='0' group by prop_id, seq) b "+
                "  where  a.prop_id=b.prop_id) g, \n"+
                
				" (select a.prop_id, b.p_amt3, b.p_amt4, b.p_amt5, b.p_amt6 , b.p_amt7 "+
				"  from   prop_bbs a, "+
				"	      (select prop_id, seq, "+
				"	              nvl(sum(decode(eval_id,'000003',p_amt)),0) p_amt3, "+
				"	              nvl(sum(decode(eval_id,'000004',p_amt)),0) p_amt4, "+
				"	              nvl(sum(decode(eval_id,'000005',p_amt)),0) p_amt5, "+
				"	              nvl(sum(decode(eval_id,'000006',p_amt)),0)   + nvl(sum(decode(eval_id,'000026',p_amt)),0) p_amt6,  "+
				"	              nvl(sum(decode(eval_id,'000237',p_amt)),0) p_amt7 "+
				"	       from   prop_c_eval where seq='0' group by prop_id, seq) b "+
                "  where  a.prop_id=b.prop_id and a.use_yn in ('Y', 'M') ) gg, \n"+

				" (select a.prop_id, "+
				"	      count(decode(b.e_amt3,'','','0','',b.prop_id)) e_cnt3, "+
				"	      count(decode(b.e_amt4,'','','0','',b.prop_id)) e_cnt4, "+
				"	      count(decode(b.e_amt5,'','','0','',b.prop_id)) e_cnt5, "+
				"	      count(decode(b.e_amt6,'','','0','',b.prop_id)) e_cnt6, "+
				"	      count(decode(b.e_amt7,'','','0','',b.prop_id)) e_cnt7  "+
				"  from   prop_comment a, "+
				"	      (select prop_id, seq, "+
				"	              nvl(sum(decode(eval_id,'000003',e_amt)),0) e_amt3, "+
				"	              nvl(sum(decode(eval_id,'000004',e_amt)),0) e_amt4, "+
				"	              nvl(sum(decode(eval_id,'000005',e_amt)),0) e_amt5, "+
				"	              nvl(sum(decode(eval_id,'000006',e_amt)),0) + nvl(sum(decode(eval_id,'000026',e_amt)),0) e_amt6,  "+
				"	              nvl(sum(decode(eval_id,'000237',e_amt)),0) e_amt7 "+
				"	       from   prop_c_eval where seq<>'0' group by prop_id, seq) b "+
                "  where  a.prop_id=b.prop_id(+) and a.seq=b.seq(+) "+
				"         and b.prop_id is not null and a.reg_id not in ('000003','000004','000005','000006', '000026', '000237')"+
				"  group by a.prop_id) h \n"+

				" where a.reg_id=user_id and b.br_id=c.br_id and b.dept_id=d.code and a.prop_id=e.prop_id(+) and a.prop_id=f.prop_id(+) and a.prop_id=ff.prop_id(+) "+
				"       and a.prop_id=g.prop_id(+)"+
				"       and a.prop_id=gg.prop_id(+)"+
				"       and a.prop_id=h.prop_id(+)"+
				" ";

		if(!useyn.equals(""))	query += " and b.use_yn  in ( " + useyn + " ) ";
				
		String search = "";
		String what = "";

		if(s_kd.equals("1"))	what = "upper(nvl(a.title, ' '))";
		//if(s_kd.equals("2"))	what = "upper(nvl(a.content1||a.content2||a.content3, ' '))";  //ORA-01489 문자열 연결의 결과가 너무 깁니다 발생	
		if(s_kd.equals("3"))	what = "upper(nvl(b.user_nm, ' '))";
			
		if(s_kd.equals("2")&& !t_wd.equals("")) { 
				query += " and (upper(a.content1) like upper('%"+t_wd+"%') OR upper(a.content2) like upper('%"+t_wd+"%') OR upper(a.content3) like upper('%"+t_wd+"%'))";
		}else {		
			if(!what.equals("") && !t_wd.equals("")){
				query += " and "+what+" like upper('%"+t_wd+"%') ";
			}							
		}	

		if(s_kd.equals("3"))			query += " and a.open_yn = 'Y' ";
			
		if(gubun1.equals("1"))			query += " and ( ( a.reg_dt like to_char(sysdate,'YYYYMM')||'%') or (a.prop_step <> '7' )   or  (a.eval_magam  is null ) or  ( nvl(g.e_amt3, 0) = 0 or  nvl(g.e_amt4, 0) =  0 or nvl(g.e_amt5,0) = 0 or nvl(g.e_amt6, 0) = 0 or nvl(g.e_amt7, 0) = 0)  )  ";
		else if(gubun1.equals("5"))		query += " and a.reg_dt like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'";
		else if(gubun1.equals("3"))		query += " and a.reg_dt = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("4"))		query += " and ( ( a.reg_dt like to_char(sysdate,'YYYY')||'%') or (a.prop_step  not in ( '9', '7' )  )  or   (a.eval_magam  is null ) or ( nvl(g.e_amt3, 0) = 0 and  nvl(g.e_amt4, 0) =  0 and nvl(g.e_amt5,0) = 0 and  nvl(g.e_amt6, 0) = 0   and  nvl(g.e_amt7, 0) = 0 )     )  ";
		else if(gubun1.equals("2")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.reg_dt like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.reg_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(gubun2.equals("1"))	query += " and a.use_yn = 'Y'";
		if(gubun2.equals("2"))	query += " and a.use_yn  = 'N'";
		if(gubun2.equals("3"))	query += " and a.use_yn  = 'O'";
		if(gubun2.equals("4"))	query += " and a.use_yn  = 'M'";
		if(gubun2.equals("6"))	query += " and a.use_yn  = 'I'";
      
      	if(gubun2.equals("O"))	query += " and a.public_yn  = 'Y'";  //외부업체 허용건  


		if(gubun4.equals("1"))	query += " and a.prop_step = '7'  ";
		if(gubun4.equals("3"))	query += " and a.prop_step  = '6' ";
		if(gubun4.equals("2"))	query += " and a.prop_step  = '5' ";
		if(gubun4.equals("4"))	query += " and a.prop_step  = '9' ";

		query += " order by a.prop_step, a.reg_dt desc, a.prop_id desc ";

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
			System.out.println("[OffPropDatabase:getOffPropList]\n"+e);
			System.out.println("[OffPropDatabase:getOffPropList]\n"+query);
	  		e.printStackTrace();
		} finally {
			 try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }		
			return vt;		
	}

    //제안함 리스트
	public Vector getOffPropListPrint(String s_kd, String t_wd, String gubun1, String st_dt, String end_dt, String gubun2, String gubun3, String gubun4, String user_id )throws DatabaseException, DataSourceEmptyException{
	
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String useyn = "";
		
	   
	
		if (gubun3.equals("1")) {
			useyn = "'Y'" ;			
		}else if (gubun3.equals("2")) {
			useyn = "'N'" ;
		} else  if (gubun3.equals("0")) {
			useyn = "'N', 'Y'" ;
		}	

		query = " select substr(a.reg_dt, 5, 4) aa_dt, a.*, b.user_nm, c.br_nm, d.nm, nvl(f.cnt1,0) cnt1, nvl(f.cnt2,0) cnt2, nvl(f.cnt3,0) cnt3,"+
				" decode(nvl(e.cnt,0),0,'N','Y') read_yn, a.open_yn,  "+
				" decode(a.prop_step,'1','수렴','2','심사', '3','재심', '6','처리중','7','완료', '5','보류') step,"+
				" decode(a.reg_dt,to_char(sysdate,'YYYYMMDD'),'new') new_yn,"+
				" decode(b.loan_st,'',0,1) loan_st, \n"+
				" nvl(ff.r_cnt1,0) r_cnt1, nvl(ff.r_cnt2,0) r_cnt2, nvl(ff.r_cnt3,0) r_cnt3, \n"+

				" decode(g.e_amt3,'','미등록',0,'미등록','-') eval_e3, \n"+
				" decode(g.e_amt4,'','미등록',0,'미등록','-') eval_e4, \n"+
				" decode(g.e_amt5,'','미등록',0,'미등록','-') eval_e5, \n"+
				" decode(g.e_amt6,'','미등록',0,'미등록','-') eval_e6, \n"+
				
				" decode(a.use_yn,'Y',decode(gg.p_amt3,'','미등록',0,'미등록','-'),'M',decode(gg.p_amt3,'','미등록',0,'미등록','-'),'-') eval_p3, \n"+
				" decode(a.use_yn,'Y',decode(gg.p_amt4,'','미등록',0,'미등록','-'),'M',decode(gg.p_amt4,'','미등록',0,'미등록','-'),'-') eval_p4, \n"+
				" decode(a.use_yn,'Y',decode(gg.p_amt5,'','미등록',0,'미등록','-'),'M',decode(gg.p_amt5,'','미등록',0,'미등록','-'),'-') eval_p5, \n"+
				" decode(a.use_yn,'Y',decode(gg.p_amt6,'','미등록',0,'미등록','-'),'M',decode(gg.p_amt6,'','미등록',0,'미등록','-'),'-') eval_p6, \n"+

				" decode(h.prop_id,'',f.cnt1+f.cnt2||'건', decode(f.cnt1+f.cnt2-h.e_cnt3,0,'-',f.cnt1+f.cnt2-h.e_cnt3||'건')) eval_c3, \n"+
				" decode(h.prop_id,'',f.cnt1+f.cnt2||'건', decode(f.cnt1+f.cnt2-h.e_cnt4,0,'-',f.cnt1+f.cnt2-h.e_cnt4||'건')) eval_c4, \n"+
				" decode(h.prop_id,'',f.cnt1+f.cnt2||'건', decode(f.cnt1+f.cnt2-h.e_cnt5,0,'-',f.cnt1+f.cnt2-h.e_cnt5||'건')) eval_c5, \n"+
				" decode(h.prop_id,'',f.cnt1+f.cnt2||'건', decode(f.cnt1+f.cnt2-h.e_cnt6,0,'-',f.cnt1+f.cnt2-h.e_cnt6||'건')) eval_c6  \n"+

//				" case when a.use_yn = 'Y' then decode(gg.p_amt,'','미등록','-') else '-' end  eval_st3, "+
//			 	" case when nvl(f.cnt1,0) + nvl(f.cnt2,0) = 0 then '-' else decode( nvl(f.cnt1,0) + nvl(f.cnt2,0)- nvl(h.cnt,0), 0, '-',  nvl(f.cnt1,0) + nvl(f.cnt2,0)- nvl(h.cnt,0) ||'건') end eval_st2 "+
				" from prop_bbs a, users b, branch c, \n"+
				" (select * from code where c_st='0002' and code<>'0000') d,\n"+
				" (select prop_id, count(0) cnt from prop_comment where com_st='1' and reg_id='"+user_id+"' group by prop_id) e,\n"+
				" (select prop_id, count(decode(com_st,'1',prop_id)) cnt1, count(decode(com_st,'2',prop_id)) cnt2, count(decode(com_st,'3',prop_id)) cnt3 from prop_comment where reg_id not in ('000003','000004','000005','000006') group by prop_id) f,\n"+
				" (select prop_id, count(decode(yn,'0',prop_id)) r_cnt1, count(decode(yn,'1',prop_id)) r_cnt2, count(decode(yn,'2',prop_id)) r_cnt3 from prop_comment where reg_id not in ('000003','000004','000005','000006') group by prop_id) ff,\n"+
				
				" (select a.prop_id, b.e_amt3, b.e_amt4, b.e_amt5, b.e_amt6  "+
				"  from   prop_bbs a, "+
				"		  (select prop_id, seq, "+
				"	              nvl(sum(decode(eval_id,'000003',e_amt)),0) e_amt3, "+
				"	              nvl(sum(decode(eval_id,'000004',e_amt)),0) e_amt4, "+
				"	              nvl(sum(decode(eval_id,'000005',e_amt)),0) e_amt5, "+
				"	              nvl(sum(decode(eval_id,'000006',e_amt)),0) e_amt6  "+
				"	       from   prop_c_eval where seq='0' group by prop_id, seq) b "+
                "  where  a.prop_id=b.prop_id) g, \n"+
                
				" (select a.prop_id, b.p_amt3, b.p_amt4, b.p_amt5, b.p_amt6  "+
				"  from   prop_bbs a, "+
				"	      (select prop_id, seq, "+
				"	              nvl(sum(decode(eval_id,'000003',p_amt)),0) p_amt3, "+
				"	              nvl(sum(decode(eval_id,'000004',p_amt)),0) p_amt4, "+
				"	              nvl(sum(decode(eval_id,'000005',p_amt)),0) p_amt5, "+
				"	              nvl(sum(decode(eval_id,'000006',p_amt)),0) p_amt6  "+
				"	       from   prop_c_eval where seq='0' group by prop_id, seq) b "+
                "  where  a.prop_id=b.prop_id and a.use_yn in ('Y', 'M') ) gg, \n"+

				" (select a.prop_id, "+
				"	      count(decode(b.e_amt3,'','','0','',b.prop_id)) e_cnt3, "+
				"	      count(decode(b.e_amt4,'','','0','',b.prop_id)) e_cnt4, "+
				"	      count(decode(b.e_amt5,'','','0','',b.prop_id)) e_cnt5, "+
				"	      count(decode(b.e_amt6,'','','0','',b.prop_id)) e_cnt6  "+
				"  from   prop_comment a, "+
				"	      (select prop_id, seq, "+
				"	              nvl(sum(decode(eval_id,'000003',e_amt)),0) e_amt3, "+
				"	              nvl(sum(decode(eval_id,'000004',e_amt)),0) e_amt4, "+
				"	              nvl(sum(decode(eval_id,'000005',e_amt)),0) e_amt5, "+
				"	              nvl(sum(decode(eval_id,'000006',e_amt)),0) e_amt6  "+
				"	       from   prop_c_eval where seq<>'0' group by prop_id, seq) b "+
                "  where  a.prop_id=b.prop_id(+) and a.seq=b.seq(+) "+
				"         and b.prop_id is not null and a.reg_id not in ('000003','000004','000005','000006')"+
				"  group by a.prop_id) h \n"+

				" where a.prop_step in ('1','2','3','5') "+
				"	    and a.reg_id=b.user_id and  b.br_id=c.br_id and b.dept_id=d.code and a.prop_id=e.prop_id(+) and a.prop_id=f.prop_id(+) and a.prop_id=ff.prop_id(+) "+
				"       and a.prop_id=g.prop_id(+)"+
				"       and a.prop_id=gg.prop_id(+)"+
				"       and a.prop_id=h.prop_id(+)" +		
				" ";

		if(!useyn.equals(""))	query += " and b.use_yn  in ( " + useyn + " ) ";


		String search = "";
		String what = "";

		query += " and  ( a.reg_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')   or (a.prop_step not in ( '1', '7' ) ) )  ";
		 
		query += " order by a.prop_step, a.reg_dt asc, a.prop_id asc ";

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
			System.out.println("[OffPropDatabase:getOffPropListPrint]\n"+e);
			System.out.println("[OffPropDatabase:getOffPropListPrint]\n"+query);
	  		e.printStackTrace();
		} finally {
			 try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }		
			return vt;		
	}

	/**
     * 제안함
     */
    private PropBean makePropBean(ResultSet results) throws DatabaseException {

        try {
            PropBean bean = new PropBean();

		    bean.setProp_id	(results.getInt   ("prop_id"));
		    bean.setReg_id	(results.getString("REG_ID"));
		    bean.setUser_nm	(results.getString("USER_NM"));
		    bean.setBr_id	(results.getString("BR_ID"));
		    bean.setBr_nm	(results.getString("BR_NM"));
		    bean.setDept_id	(results.getString("DEPT_ID"));
		    bean.setDept_nm	(results.getString("DEPT_NM"));
		    bean.setReg_dt	(results.getString("REG_DT"));
		    bean.setExp_dt	(results.getString("EXP_DT"));
		    bean.setTitle	(results.getString("TITLE"));
		    bean.setContent(results.getString("CONTENT"));	
		    bean.setContent1(results.getString("CONTENT1"));	
		    bean.setContent2(results.getString("CONTENT2"));	
		    bean.setContent3(results.getString("CONTENT3"));
		    bean.setProp_step(results.getString("prop_step"));
		    bean.setAct_yn	(results.getString("ACT_YN"));
		    bean.setAct_dt	(results.getString("ACT_DT"));
			bean.setPrize (results.getInt ("PRIZE"));
			bean.setUse_yn	(results.getString("use_yn"));
			bean.setJigub_dt(results.getString("jigub_dt"));
			bean.setCnt1 (results.getInt ("cnt1"));
			bean.setCnt2 (results.getInt ("cnt2"));
			bean.setCnt3 (results.getInt ("cnt3"));
			bean.setCnt4 (results.getInt ("cnt4"));
			bean.setCnt5 (results.getInt ("cnt5"));
			bean.setFile_name1(results.getString("file_name1"));
			bean.setFile_name2(results.getString("file_name2"));
			bean.setFile_name3(results.getString("file_name3"));
			
			bean.setPp_amt (results.getInt ("pp_amt"));
			bean.setPe_amt (results.getInt ("pe_amt"));
		    bean.setOpen_yn	(results.getString("OPEN_YN"));
			bean.setDay7	(results.getString("day7"));
			bean.setEval_dt	(results.getString("eval_dt"));
			bean.setJigub_amt (results.getInt ("jigub_amt"));
			bean.setEval (results.getInt ("eval"));
			bean.setEval_magam	(results.getString("eval_magam"));
   			bean.setPublic_yn	(results.getString("PUBLIC_YN"));
            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}

 	/**
     * 제안함 개별 조회
     */    
    public PropBean getPropBean(int prop_id) throws UnknownDataException, DataSourceEmptyException, DatabaseException {
        Connection con = connMgr.getConnection(DATA_SOURCE);
        if(con == null) 
            throw new DataSourceEmptyException("Can't get connection.!!");

        PropBean p_bean;

        Statement stmt = null;
        ResultSet rs = null;
        String query = "";

        query = " select "+
				//" case when substr(reg_dt, 7,2) between '01' and '15' then substr(reg_dt, 0,6)||'23' when substr(reg_dt, 7,2) between '16' and '31' then to_char(trunc(add_months(reg_dt, 1), 'MONTH')+7, 'YYYYMMDD') end day7, "+
			//	" to_char(last_day(reg_dt), 'yyyymmdd') as day7, "+
				"  F_getAfterDay1(to_char(trunc(add_months(to_date(reg_dt), 1), 'MONTH')+4, 'YYYYMMDD'), 1) as day7,  \n"+
				" p.cnt1, p.cnt2, p.cnt3, p.cnt4, p.cnt5, a.prop_id as prop_id, a.reg_id as REG_ID, b.user_nm as USER_NM, \n"+
				" b.br_id as BR_ID, c.br_nm as BR_NM, b.dept_id as DEPT_ID, d.nm as DEPT_NM,   decode(a.eval_magam, 'Y', a.prize, f.pe_amt) as pe_amt,    decode(a.eval_magam, 'Y', a.prize, f.pp_amt) as pp_amt,     \n"+
				" a.reg_dt, a.exp_dt, a.title as TITLE, a.content as CONTENT, a.content1 as CONTENT1, a.content2 as CONTENT2, a.content3 as CONTENT3,\n"+
				" a.prop_step, a.act_yn, a.act_dt, a.prize as PRIZE, a.use_yn, a.jigub_dt, a.file_name1, a.file_name2, a.file_name3 , a.open_yn, a.eval_dt, nvl(a.jigub_amt, 0) as jigub_amt ,   nvl(a.eval, 0) as eval,  a.eval_magam  , a.public_yn  \n"+  
				" from prop_bbs a, users b, branch c, code d, (select prop_id, count(0) as comment_cnt from prop_comment group by prop_id) e, \n"+
				" (select c.prop_id,  trunc(sum(c.e_amt) /count(c.eval_id))  as  pe_amt, trunc(sum(c.p_amt) /count(c.eval_id))  as  pp_amt from prop_c_eval c where  c.seq = 0 group by c.prop_id) f, \n"+
				" ( select prop_id, count(decode(eval_id, '000003',e_amt)) cnt1, count(decode(eval_id, '000004',e_amt)) cnt2, count(decode(eval_id, '000005',e_amt)) cnt3, count(decode(eval_id, '000006',e_amt)) + count(decode(eval_id, '000026',e_amt))  cnt4 , count(decode(eval_id, '000237',e_amt))   cnt5 \n"+
   				"	   from (  select prop_id, eval_id, e_amt  from prop_c_eval where seq  = 0 ) group by  prop_id ) p \n"+
				" where a.prop_id=" + prop_id + " and a.reg_id=b.user_id and b.br_id=c.br_id \n"+
				" and d.c_st='0002' and d.code <> '0000' and b.dept_id=d.code and a.prop_id=e.prop_id(+) and a.prop_id=f.prop_id(+) and  a.prop_id=p.prop_id(+)\n";

		
        try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);
    
            if (rs.next())
                p_bean = makePropBean(rs);
            else
                throw new UnknownDataException("Could not find Appcode # " + prop_id );
 		
 			rs.close();
            stmt.close();
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){} 
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return p_bean;
	}

	/**
     * 제안함 댓글
     */
    private PropCommentBean makePropCommentBean(ResultSet results) throws DatabaseException {

        try {
            PropCommentBean bean = new PropCommentBean();

		    bean.setProp_id(results.getInt("prop_id"));
		    bean.setSeq(results.getInt("SEQ"));
		    bean.setContent(results.getString("CONTENT"));	
			bean.setReg_id(results.getString("REG_ID"));
		    bean.setReg_dt(results.getString("REG_DT"));
			bean.setUser_nm(results.getString("USER_NM"));
			bean.setUser_pos(results.getString("USER_POS"));
			bean.setCom_st(results.getString("COM_ST"));
			bean.setCom_yn(results.getString("COM_YN"));
			bean.setYn(results.getInt("YN"));
			bean.setCnt1 (results.getInt ("cnt1"));
			bean.setCnt2 (results.getInt ("cnt2"));
			bean.setCnt3 (results.getInt ("cnt3"));
			bean.setCnt4 (results.getInt ("cnt4"));
			bean.setCnt5 (results.getInt ("cnt5"));
			bean.setOpen_yn(results.getString("OPEN_YN"));
			bean.setRe_seq(results.getInt("RE_SEQ"));
			

            return bean;
        }catch (SQLException e) {
            throw new DatabaseException(e.getMessage());
        }

	}

	/**
     * 제안함 댓글 리스트
     */
    public PropCommentBean [] getPropCommentList(int prop_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String query = "";
                            
        query = " select p.cnt1, p.cnt2, p.cnt3, p.cnt4, p.cnt5,  a.prop_id, a.seq, a.re_seq, a.reg_id, a.content, to_char(a.reg_dt,'YYYY-MM-DD') reg_dt, b.user_nm, b.user_pos, a.com_st, a.com_yn, a.yn , a.open_yn  \n"+
				  "	from prop_comment a, users b, prop_bbs pb, \n"+
				  " ( select prop_id, seq, re_seq,  count(decode(eval_id, '000003',e_amt)) cnt1, count(decode(eval_id, '000004',e_amt)) cnt2, count(decode(eval_id, '000005',e_amt)) cnt3, count(decode(eval_id, '000006',e_amt)) + count(decode(eval_id, '000026',e_amt)) cnt4 , count(decode(eval_id, '000237',e_amt)) cnt5 \n"+
   		   		  "  	from (  select prop_id, seq, re_seq,  eval_id, e_amt  from prop_c_eval where seq  <> 0 ) group by  prop_id ,seq , re_seq  ) p \n"+	
				  "	where a.prop_id="+prop_id+" and pb.prop_id = a.prop_id(+)  and a.prop_id = p.prop_id(+) and a.seq = p.seq(+) and a.re_seq = p.re_seq(+)  and a.reg_id=b.user_id and nvl(a.com_st , '1')  in ( '1', '2' ) \n"+
   		   	//	  "       and nvl(a.re_seq,0)=0 \n"+ //댓글원글만
				  " order by a.com_st, a.reg_dt ";     
            

        Collection<PropCommentBean> col = new ArrayList<PropCommentBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            while(rs.next()){
				col.add(makePropCommentBean(rs));
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (PropCommentBean[])col.toArray(new PropCommentBean[0]);
    }
    
	/**
     * 제안함 댓글 리스트 - 의견에 댓글을 단경우 
     */
    public PropCommentBean [] getPropCommentAllList(int prop_id, int seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
        String subQuery = "";
        String query = "";
                            
        query = " select p.cnt1, p.cnt2, p.cnt3, p.cnt4, p.cnt5,  a.prop_id, a.seq, a.re_seq, a.reg_id, a.content, to_char(a.reg_dt,'YYYY-MM-DD') reg_dt, b.user_nm, b.user_pos, a.com_st, a.com_yn, a.yn , a.open_yn  \n"+
				  "	from prop_comment a, users b, prop_bbs pb, \n"+
				  " ( select prop_id, seq, re_seq,  count(decode(eval_id, '000003',e_amt)) cnt1, count(decode(eval_id, '000004',e_amt)) cnt2, count(decode(eval_id, '000005',e_amt)) cnt3, count(decode(eval_id, '000006',e_amt)) + count(decode(eval_id, '000026',e_amt)) cnt4 , count(decode(eval_id, '000237',e_amt)) cnt5 \n"+
   		   		  "  	from (  select prop_id, seq,  re_seq ,  eval_id, e_amt  from prop_c_eval where seq  <> 0 ) group by  prop_id ,seq , re_seq ) p \n"+	
				  "	where a.prop_id="+prop_id+" and a.seq="+seq+" and pb.prop_id = a.prop_id(+)  and a.prop_id = p.prop_id(+) and a.seq = p.seq(+) and a.re_seq = p.re_seq(+)  and a.reg_id=b.user_id \n"+
				  " order by nvl(a.re_seq,0) ";     
            

        Collection<PropCommentBean> col = new ArrayList<PropCommentBean>();
        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            while(rs.next()){
				col.add(makePropCommentBean(rs));
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return (PropCommentBean[])col.toArray(new PropCommentBean[0]);
    }    
    
    


    
    /**
     * 제안함 등록
     */
    public int insertProp(PropBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
               
		try{
        
			query = " insert into prop_bbs "+
					" ( prop_id, prop_step, REG_ID, REG_DT, TITLE, CONTENT, "+
					"   CONTENT1, CONTENT2, CONTENT3 , OPEN_YN, PUBLIC_YN )\n"+
                    "   SELECT "+
					"		nvl(max(prop_id)+1,1), '1', '"+bean.getReg_id()+"', to_char(sysdate,'YYYYMMDD'),"+
					"		'"+bean.getTitle().trim()+"', '"+bean.getContent().trim()+"', '"+bean.getContent1().trim()+"', '"+bean.getContent2().trim()+"', '"+bean.getContent3().trim()+"', '"+bean.getOpen_yn()+"' , '"+ bean.getPublic_yn() + "' FROM prop_bbs ";

            con.setAutoCommit(false);
            pstmt = con.createStatement();
            count = pstmt.executeUpdate(query);
                      
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
                con.rollback();
				System.out.println("[OffAncDB-insertProp]"+se);
				System.out.println("[OffAncDB-insertProp]"+query);
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
    /**
     * 제안함 수정
     */
    public int updateProp(PropBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
               
 
       try{
            
	       query="UPDATE prop_bbs SET \n"
       			+ "prop_step		='"+bean.getProp_step().trim()+"',	\n"
				+ "TITLE		='"+bean.getTitle().trim()+"',		\n"
	       		+ "CONTENT		='"+bean.getContent().trim()+"',	\n" //추가
	       		+ "CONTENT1		='"+bean.getContent1().trim()+"',	\n"
	       		+ "CONTENT2		='"+bean.getContent2().trim()+"',	\n"
	       		+ "CONTENT3		='"+bean.getContent3().trim()+"',	\n"
				+ "EXP_DT		=replace('"+bean.getExp_dt().trim()+"','-',''),\n"
				+ "ACT_DT		=replace('"+bean.getAct_dt().trim()+"','-',''),\n"
	       		+ "ACT_YN		='"+bean.getAct_yn().trim()+"',\n"
				+ "PRIZE		="+bean.getPrize()+", \n"
				+ "JIGUB_AMT	="+bean.getJigub_amt()+", \n"
				+ "EVAL	="+bean.getEval()+", \n"
				+ "USE_YN		='"+bean.getUse_yn().trim()+"', \n"
				+ "PUBLIC_YN		='"+bean.getPublic_yn().trim()+"', \n"
				+ "EVAL_DT		=replace('"+bean.getEval_dt().trim()+"','-',''),\n"
				+ "JIGUB_DT		=replace('"+bean.getJigub_dt().trim()+"','-',''), \n"		
				+ "EVAL_MAGAM	='"+bean.getEval_magam().trim()+"' \n"				
    	       	+ "WHERE prop_id="+bean.getProp_id();

            con.setAutoCommit(false);
            pstmt = con.createStatement();
            count = pstmt.executeUpdate(query);
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
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

	/**
     * 제안함 한건 삭제
     */
    public int deleteProp(int prop_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
               
        query  = "DELETE prop_bbs WHERE prop_id="+prop_id;
 
       try{
            
            con.setAutoCommit(false);
                      
            pstmt = con.prepareStatement(query);            
            count = pstmt.executeUpdate();

            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
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
    
	/**
     * 제안함-의견 삭제
     */
    public int deletePropComment(int prop_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
               
        query  = "DELETE prop_comment WHERE prop_id="+prop_id;
 
       try{
            
            con.setAutoCommit(false);
                      
            pstmt = con.prepareStatement(query);            
            count = pstmt.executeUpdate();

            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
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

    /**
     * 제안함 댓글 등록
     */
    public int insertPropComment(PropCommentBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
        int count2 = 0;
               
		try{
        
	       query = " insert into prop_comment "+
					" (PROP_ID, SEQ, REG_DT, REG_ID, CONTENT, COM_ST, YN, OPEN_YN, re_seq )\n"
                      + " SELECT '"+bean.getProp_id()+"', nvl(max(SEQ)+1,1), sysdate,\n"
					  + " '"+bean.getReg_id().trim()+"','"+bean.getContent().trim()+"','"+bean.getCom_st().trim()+"','"+bean.getYn()+"', '"+bean.getOpen_yn() + "', 0 \n"  
			   		  + " FROM prop_comment where PROP_ID='"+bean.getProp_id()+"'";

            con.setAutoCommit(false);
            pstmt = con.createStatement();
            count = pstmt.executeUpdate(query);

            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
                con.rollback();
				System.out.println("[OffPropDatabase:getEvalMemo]\n"+se);
				System.out.println("[OffPropDatabase:getEvalMemo]\n"+query);
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
    
    /**
     * 제안함 댓글 등록
     */
    public int insertPropReComment(PropCommentBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
        int count2 = 0;
               
		try{
        
	       query = " insert into prop_comment "+
					" (PROP_ID, SEQ, REG_DT, REG_ID, CONTENT, COM_ST, YN, OPEN_YN, re_seq )\n"
                      + " SELECT '"+bean.getProp_id()+"', "+bean.getSeq()+", sysdate,\n"
					  + " '"+bean.getReg_id().trim()+"','"+bean.getContent().trim()+"','"+bean.getCom_st().trim()+"','"+bean.getYn()+"', '"+bean.getOpen_yn() + "', "+bean.getRe_seq()+" \n"  
			   		  + " FROM dual ";

            con.setAutoCommit(false);
            pstmt = con.createStatement();
            count = pstmt.executeUpdate(query);

            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
                con.rollback();
				System.out.println("[OffPropDatabase:insertPropReComment]\n"+se);
				System.out.println("[OffPropDatabase:insertPropReComment]\n"+query);
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
        
    
    //댓글 평가 prop_id, seq, user_id
	public Vector getEvalMemo(String prop_id, String seq, String re_seq, String user_id )throws DatabaseException, DataSourceEmptyException{
	
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String useyn = "";
			
		query = " select e.*, u.user_nm "+
				" from  prop_bbs a, prop_comment b, prop_c_eval e, users u \n"+
				" where a.prop_id = b.prop_id and b.prop_id = e.prop_id(+) and b.seq = e.seq(+) and b.re_seq = e.re_seq(+)  \n "+
				" and  e.eval_id = u.user_id(+) and e.prop_id = "+ prop_id + " and e.seq = " + seq  + " and e.re_seq = "+ re_seq ;
	
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
			System.out.println("[OffPropDatabase:getEvalMemo]\n"+e);
			System.out.println("[OffPropDatabase:getEvalMemo]\n"+query);
	  		e.printStackTrace();
		} finally {
			 try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }		
			return vt;		
	}
    
	 //댓글 평가 prop_id, seq, user_id
		public Vector getEvalMemo(String prop_id, String seq, String user_id )throws DatabaseException, DataSourceEmptyException{
		
			Connection con = connMgr.getConnection(DATA_SOURCE);
			if(con == null)
	            throw new DataSourceEmptyException("Can't get Connection !!");

			Statement stmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";
			String useyn = "";
				
			query = " select e.*, u.user_nm "+
					" from  prop_bbs a, prop_comment b, prop_c_eval e, users u "+
					" where a.prop_id = b.prop_id and b.prop_id = e.prop_id(+) and b.seq = e.seq(+)"+
					" and  e.eval_id = u.user_id(+) and e.prop_id = "+ prop_id + " and e.seq = " + seq ;
		
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
				System.out.println("[OffPropDatabase:getEvalMemo]\n"+e);
				System.out.println("[OffPropDatabase:getEvalMemo]\n"+query);
		  		e.printStackTrace();
			} finally {
				 try{
	                if(rs != null ) rs.close();
	                if(stmt != null) stmt.close();
	            }catch(SQLException _ignored){}
	            connMgr.freeConnection(DATA_SOURCE, con);
				con = null;
	        }		
				return vt;		
		}
		
    
    /**
     * 제안함-댓글 평가
     */
     
    public boolean insertCommentEval(String prop_id, String seq, String user_id, int e_amt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        
        String query = "";
        String query1 = "";
        String query2 = "";
          
      	boolean flag = true;
       	ResultSet rs = null;  
       	int cnt = 0;
          
        query1 = "select count(0) cnt1 from prop_c_eval where prop_id = to_number(?) and seq = to_number(?) and eval_id = ? ";
        
        query2 = "delete from prop_c_eval where prop_id = to_number(?) and seq = to_number(?) and eval_id = ? ";
                 
        query  = "insert into prop_c_eval (prop_id, seq, eval_id, e_amt) values ( to_number(?), to_number(?), ?, ?)";
 
       try{
            
            con.setAutoCommit(false);
                   
            pstmt1 = con.prepareStatement(query1);       
            
            pstmt1.setString(1, prop_id);
			pstmt1.setString(2, seq);
			pstmt1.setString(3, user_id);    
			rs = pstmt1.executeQuery();

            if(rs.next()){                
				cnt = rs.getInt(1);
         	}   
			rs.close();
			pstmt1.close();
							
			
			if (cnt > 0 ) {
				 pstmt2 = con.prepareStatement(query2);    
            
           		 pstmt2.setString(1, prop_id);
				 pstmt2.setString(2, seq);
				 pstmt2.setString(3, user_id);
				 pstmt2.executeUpdate();				 
				 pstmt2.close();	 							
			}	
						
            pstmt = con.prepareStatement(query);    
            
            pstmt.setString(1, prop_id);
			pstmt.setString(2, seq);
			pstmt.setString(3, user_id);
			pstmt.setInt(4, e_amt);			
			pstmt.executeUpdate();
			pstmt.close();		

			con.commit();
      
        }catch(SQLException se){
            try{
				System.out.println("[OffPropDatabase:insertCommentEval]"+se);			
				flag = false;
	            con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null )		rs.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return flag;
        
      }
  
    /**
     * 제안함-댓글 평가
     */
     
    public boolean insertCommentEval(String prop_id, String seq, String re_seq, String user_id, int e_amt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        
        String query = "";
        String query1 = "";
        String query2 = "";
          
      	boolean flag = true;
       	ResultSet rs = null;  
       	int cnt = 0;
          
        query1 = "select count(0) cnt1 from prop_c_eval where prop_id = to_number(?) and seq = to_number(?) and re_seq = to_number(?) and eval_id = ? ";
        
        query2 = "delete from prop_c_eval where prop_id = to_number(?) and seq = to_number(?) and re_seq = to_number(?) and eval_id = ? ";
                 
        query  = "insert into prop_c_eval (prop_id, seq, eval_id, e_amt, re_seq) values ( to_number(?), to_number(?), ?, ?, ?)";
 
       try{
            
            con.setAutoCommit(false);
                   
            pstmt1 = con.prepareStatement(query1);       
            
            pstmt1.setString(1, prop_id);
			pstmt1.setString(2, seq);
			pstmt1.setString(3, re_seq);
			pstmt1.setString(4, user_id);    
			rs = pstmt1.executeQuery();

            if(rs.next()){                
				cnt = rs.getInt(1);
         	}   
			rs.close();
			pstmt1.close();
							
			
			if (cnt > 0 ) {
				 pstmt2 = con.prepareStatement(query2);    
            
           		 pstmt2.setString(1, prop_id);
				 pstmt2.setString(2, seq);
				 pstmt2.setString(3, re_seq);
				 pstmt2.setString(4, user_id);
				 pstmt2.executeUpdate();				 
				 pstmt2.close();	 							
			}	
						
            pstmt = con.prepareStatement(query);    
            
            pstmt.setString(1, prop_id);
			pstmt.setString(2, seq);			
			pstmt.setString(3, user_id);
			pstmt.setInt(4, e_amt);
			pstmt.setString(5, re_seq);
			pstmt.executeUpdate();
			pstmt.close();		

			con.commit();
      
        }catch(SQLException se){
            try{
				System.out.println("[OffPropDatabase:insertCommentEval]"+se);			
				flag = false;
	            con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null )		rs.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return flag;
        
      }
      
  
    //제안 평가 prop_id, seq, user_id
	public Vector getEvalMemo(String prop_id, String user_id )throws DatabaseException, DataSourceEmptyException{
	
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String useyn = "";
			
		query = " select e.*, u.user_nm "+
				" from  prop_bbs a, prop_c_eval e, users u "+
				" where a.prop_id = e.prop_id(+) "+
				" and  e.eval_id = u.user_id(+) and e.prop_id = "+ prop_id + " and e.seq = 0" ;
	
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
			System.out.println("[OffPropDatabase:getEvalMemo]\n"+e);
			System.out.println("[OffPropDatabase:getEvalMemo]\n"+query);
	  		e.printStackTrace();
		} finally {
			 try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }		
			return vt;		
	}
	
   /**
     * 제안함-제안 평가
     */
   public boolean insertCommentEval(String prop_id, String seq, String re_seq, String user_id, int e_amt, int p_amt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;
        
        String query = "";
        String query1 = "";
        String query2 = "";
          
      	boolean flag = true;
       	ResultSet rs = null;  
       	int cnt = 0;
          
        query1 = "select count(0) cnt1 from prop_c_eval where prop_id = to_number(?) and seq = 0 and re_seq = 0 and eval_id = ? ";
        
        query2 = "delete from prop_c_eval where prop_id = to_number(?) and seq = 0 and re_seq = 0 and eval_id = ? ";
                 
        query  = "insert into prop_c_eval (prop_id, seq, eval_id, e_amt, p_amt, re_seq) values ( to_number(?), 0, ?, ?, ?, 0)";
 
       try{
            
            con.setAutoCommit(false);
                   
            pstmt1 = con.prepareStatement(query1);       
            
            pstmt1.setString(1, prop_id);
			pstmt1.setString(2, user_id);    
			rs = pstmt1.executeQuery();

            if(rs.next()){                
				cnt = rs.getInt(1);
         	}   
			rs.close();						
			pstmt1.close();		              
			
			if (cnt > 0 ) {
				 pstmt2 = con.prepareStatement(query2);                
           		 pstmt2.setString(1, prop_id);
				 pstmt2.setString(2, user_id);
				 pstmt2.executeUpdate();				 
				 pstmt2.close();	 							
			}	
						
            pstmt = con.prepareStatement(query);                
            pstmt.setString(1, prop_id);
			pstmt.setString(2, user_id);
			pstmt.setInt(3, e_amt);
			pstmt.setInt(4, p_amt);			
			pstmt.executeUpdate();
			pstmt.close();		

			con.commit();
      
        }catch(SQLException se){
            try{
				System.out.println("[OffPropDatabase:insertCommentEval]"+se);			
				flag = false;
	            con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                con.setAutoCommit(true);
                if(rs != null )		rs.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt2 != null) pstmt2.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }

        return flag;
        
      }
  
	/**
     * 제안함 댓글 조회
     */
    public PropCommentBean getPropComment(int prop_id, int seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		PropCommentBean bean = new PropCommentBean();
        String subQuery = "";
        String query = "";
                        
        query = "select 0 cnt1, 0 cnt2, 0 cnt3, 0 cnt4, a.prop_id, a.seq, a.reg_id, a.content, to_char(a.reg_dt,'YYYY-MM-DD') reg_dt, b.user_nm, b.user_pos, a.com_st, a.com_yn, a.yn\n"   
				+ "from prop_comment a, users b\n"
				+ "where a.prop_id="+prop_id+" and a.seq="+seq+" and a.reg_id=b.user_id";
      

        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            if(rs.next()){
				bean.setProp_id	(rs.getInt	 ("prop_id"));
				bean.setSeq		(rs.getInt	 ("SEQ"));
				bean.setContent	(rs.getString("CONTENT")==null?"":rs.getString("CONTENT"));	
				bean.setReg_id	(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				bean.setReg_dt	(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				bean.setUser_nm	(rs.getString("USER_NM")==null?"":rs.getString("USER_NM"));
				bean.setUser_pos(rs.getString("USER_POS")==null?"":rs.getString("USER_POS"));
				bean.setCom_st	(rs.getString("COM_ST")==null?"":rs.getString("COM_ST"));
				bean.setCom_yn	(rs.getString("COM_YN")==null?"":rs.getString("COM_YN"));
				bean.setYn		(rs.getInt   ("YN"));
				bean.setCnt1	(rs.getInt   ("cnt1"));
				bean.setCnt2	(rs.getInt   ("cnt2"));
				bean.setCnt3	(rs.getInt   ("cnt3"));
				bean.setCnt4	(rs.getInt   ("cnt4"));
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }
    
	/**
     * 제안함 댓글 조회
     */
    public PropCommentBean getPropComment(int prop_id, int seq, int re_seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        
        Statement stmt = null;
        ResultSet rs = null;
		PropCommentBean bean = new PropCommentBean();
        String subQuery = "";
        String query = "";
                        
        query = "select 0 cnt1, 0 cnt2, 0 cnt3, 0 cnt4, a.prop_id, a.seq, a.re_seq, a.reg_id, a.content, to_char(a.reg_dt,'YYYY-MM-DD') reg_dt, b.user_nm, b.user_pos, a.com_st, a.com_yn, a.yn\n"   
				+ "from prop_comment a, users b\n"
				+ "where a.prop_id="+prop_id+" and a.seq="+seq+" and a.re_seq="+re_seq+" and a.reg_id=b.user_id";
      

        try{
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);

            if(rs.next()){
				bean.setProp_id	(rs.getInt	 ("prop_id"));
				bean.setSeq		(rs.getInt	 ("SEQ"));
				bean.setContent	(rs.getString("CONTENT")==null?"":rs.getString("CONTENT"));	
				bean.setReg_id	(rs.getString("REG_ID")==null?"":rs.getString("REG_ID"));
				bean.setReg_dt	(rs.getString("REG_DT")==null?"":rs.getString("REG_DT"));
				bean.setUser_nm	(rs.getString("USER_NM")==null?"":rs.getString("USER_NM"));
				bean.setUser_pos(rs.getString("USER_POS")==null?"":rs.getString("USER_POS"));
				bean.setCom_st	(rs.getString("COM_ST")==null?"":rs.getString("COM_ST"));
				bean.setCom_yn	(rs.getString("COM_YN")==null?"":rs.getString("COM_YN"));
				bean.setYn		(rs.getInt   ("YN"));
				bean.setCnt1	(rs.getInt   ("cnt1"));
				bean.setCnt2	(rs.getInt   ("cnt2"));
				bean.setCnt3	(rs.getInt   ("cnt3"));
				bean.setCnt4	(rs.getInt   ("cnt4"));
				bean.setRe_seq	(rs.getInt	 ("RE_SEQ"));
            }
            rs.close();
            stmt.close();
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }    
    
    /**
     * 제안함 댓글 수정
     */
    public int updatePropComment(PropCommentBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
         
       query = " update prop_comment set                         "+
			   "        content='"+bean.getContent().trim()+"',  "+
		       "        yn     ="+bean.getYn()+"                 "+
		       " where  prop_id="+bean.getProp_id()+"            "+
		       "        and seq="+bean.getSeq()+" and re_seq="+bean.getRe_seq()+"   ";
			   
		try{
        
            con.setAutoCommit(false);
            pstmt = con.createStatement();
            count = pstmt.executeUpdate(query);
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
                con.rollback();
				System.out.println("[OffPropDatabase:updatePropComment]"+se);			
				System.out.println("[OffPropDatabase:updatePropComment]"+query);			
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

    /**
     * 제안함 댓글 삭제
     */
    public int deletePropComment(PropCommentBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
         
       query = " delete from prop_comment                        "+
		       " where  prop_id="+bean.getProp_id()+"            "+
		       "        and seq="+bean.getSeq()+"  and re_seq="+bean.getRe_seq()+"               ";
			   
		try{
        
            con.setAutoCommit(false);
            pstmt = con.createStatement();
            count = pstmt.executeUpdate(query);
            pstmt.close();
            con.commit();

        }catch(SQLException se){
            try{
                con.rollback();
				System.out.println("[OffPropDatabase:deletePropComment]"+se);			
				System.out.println("[OffPropDatabase:deletePropComment]"+query);			
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
    
    
     //심사결과
	public Vector getOffPropEvalList(String eval_dt)throws DatabaseException, DataSourceEmptyException{
	
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					
		query = " select a.open_yn, a.title, decode(a.use_yn, 'Y', '채택', 'N', '불채택', 'M', '수정채택', 'O', '업무시정채택',  'I', '정보제공') use_yn_nm, a.content, u.user_nm , a.reg_dt  "+
				" from  prop_bbs a, users u "+
				" where a.reg_id = u.user_id  and a.eval_dt = replace('"+ eval_dt +"', '-', '') order by a.reg_dt , a.prop_id ";
	
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
			System.out.println("[OffPropDatabase:getOffPropEvalList]\n"+e);
			System.out.println("[OffPropDatabase:getOffPropEvalList]\n"+query);
	  		e.printStackTrace();
		} finally {
			 try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }		
			return vt;		
	}
    
    /**
	 *	//prop_bbs 심사일 조회하기
	 */
	public Vector getEvalDate() throws DatabaseException, DataSourceEmptyException{
	
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select eval_dt from prop_bbs where eval_dt is not null group by eval_dt order by eval_dt desc";

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
			System.out.println("[OffPropDatabase:getEvalDate]\n"+e);
			System.out.println("[OffPropDatabase:getEvalDate]\n"+query);
	  		e.printStackTrace();
		} finally {
			 try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }		
			return vt;		
	}
	
	 /**
     * 제안파일첨부
     */
    public int updatePropScan(int prop_id, String idx, String file_name) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String query = "";
        int count = 0;            
                	
	    if ( idx.equals("1") ) {
               query=" UPDATE  prop_bbs SET file_name1 = ? WHERE prop_id =?  ";				
        } else if ( idx.equals("2") ) {
               query=" UPDATE  prop_bbs SET file_name2 = ? WHERE prop_id =?  ";				
        } else {
               query=" UPDATE  prop_bbs SET file_name3 = ? WHERE prop_id =?  ";			
        } 		
		      
       try{
       
        	con.setAutoCommit(false);       
        	pstmt = con.prepareStatement(query);
			pstmt.setString(1, file_name);
            pstmt.setInt(2, prop_id);
    
            count = pstmt.executeUpdate();             
			pstmt.close();	
            con.commit(); 

        }catch(SQLException se){
            try{
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

	
	//제안파일
	public String  getProScan( int prop_id, String idx)throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
            
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";		
		String re_file_name = "";		
		
		             	
	    if ( idx.equals("1") ) {
               query=" SELECT  file_name1  from prop_bbs WHERE prop_id ="+prop_id ;	
        } else if ( idx.equals("2") ) {
               query=" SELECT  file_name2  from prop_bbs WHERE prop_id ="+prop_id ;				
        } else {
               query=" SELECT  file_name3  from prop_bbs WHERE prop_id ="+prop_id ;	
        } 		
        
   		 					
		try {
			pstmt = con.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		if(rs.next())
			{		
				re_file_name = rs.getString(1);
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
        return re_file_name;
   }
		
		
    /**
	 *	제안회의예약년월 조회하기
	 */
	public Vector getPropResYMList() throws DatabaseException, DataSourceEmptyException{
	
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select substr(prop_ym,1,4) prop_y from prop_res group by substr(prop_ym,1,4) order by substr(prop_ym,1,4) ";

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
			System.out.println("[OffPropDatabase:getPropResYMList]\n"+e);
			System.out.println("[OffPropDatabase:getPropResYMList]\n"+query);
	  		e.printStackTrace();
		} finally {
			 try{
                if(rs != null )		rs.close();
                if(stmt != null)	stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }		
			return vt;		
	}

    /**
	 *	제안회의예약 조회하기
	 */
	public Vector getPropResList(String s_ym) throws DatabaseException, DataSourceEmptyException{
	
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, nvl(prop_dt,prop_est_dt) r_prop_dt, "+
				"        DECODE(TO_CHAR(TO_DATE(nvl(prop_dt,prop_est_dt),'YYYYMMDD'),'d'),'1','일','2','월','3','화','4','수','5','목','6','금','7','토') weekday "+
				" from   prop_res a where a.prop_ym like '"+s_ym+"%' order by a.prop_ym ";

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
			System.out.println("[OffPropDatabase:getPropResList]\n"+e);
			System.out.println("[OffPropDatabase:getPropResList]\n"+query);
	  		e.printStackTrace();
		} finally {
			 try{
                if(rs != null )		rs.close();
                if(stmt != null)	stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }		
			return vt;		
	}

    /**
	 *	제안회의예약 조회하기
	 */
	public int getPropResUserCount(String s_ym, String user_id) throws DatabaseException, DataSourceEmptyException{
	
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " select count(0) from prop_res where prop_ym like '"+s_ym+"%' and res_ids like '%"+user_id+"%' ";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
    		
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[OffPropDatabase:getPropResUserCount]\n"+e);
			System.out.println("[OffPropDatabase:getPropResUserCount]\n"+query);
	  		e.printStackTrace();
		} finally {
			 try{
                if(rs != null )		rs.close();
                if(stmt != null)	stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }		
			return count;		
	}

    /**
	 *	제안건에 대한 댓글기한 조회하기(2012변경분 반영)
	 */
	public String getPropResCommentEndDt(String reg_dt) throws DatabaseException, DataSourceEmptyException{
	
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		String comment_end_dt = "";
		String query = "";

		query = " select comment_end_dt from prop_res where '"+reg_dt+"' between start_dt and end_dt ";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);    		
			if(rs.next())
			{				
				comment_end_dt = rs.getString(1)==null?"":rs.getString(1);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[OffPropDatabase:getPropResCommentEndDt]\n"+e);
			System.out.println("[OffPropDatabase:getPropResCommentEndDt]\n"+query);
	  		e.printStackTrace();
		} finally {
			 try{
                if(rs != null )		rs.close();
                if(stmt != null)	stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }		
			return comment_end_dt;		
	}

    /**
     * 제안참석예약 등록
     */
    public int insertPropResId(String prop_ym, String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
               
       query = " UPDATE prop_res SET \n"+
       		   "        res_ids =res_ids||'"+user_id+"'||'/' \n"+
    	       " WHERE  prop_ym='"+prop_ym+"' AND NVL(instr(res_ids,'"+user_id+"'),0)=0 ";

		try{


            con.setAutoCommit(false);
            pstmt = con.createStatement();
            count = pstmt.executeUpdate(query);
                      
            pstmt.close();
            con.commit();



        }catch(SQLException se){
            try{
                con.rollback();
				System.out.println("[OffAncDB-insertPropResId]"+se);
				System.out.println("[OffAncDB-insertPropResId]"+query);
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

    /**
     * 제안참석예약 취소
     */
    public int deletePropResId(String prop_ym, String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
               
       query = " UPDATE prop_res SET \n"+
       		   "        res_ids =replace(res_ids,'"+user_id+"'||'/','') \n"+
    	       " WHERE  prop_ym='"+prop_ym+"' AND NVL(instr(res_ids,'"+user_id+"'),0) > 0 ";

		try{


            con.setAutoCommit(false);
            pstmt = con.createStatement();
            count = pstmt.executeUpdate(query);
                      
            pstmt.close();
            con.commit();



        }catch(SQLException se){
            try{
                con.rollback();
				System.out.println("[OffAncDB-deletePropResId]"+se);
				System.out.println("[OffAncDB-deletePropResId]"+query);
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

    /**
     * 제안참석예약 취소
     */
    public int updatePropDt(String prop_ym, String prop_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");
        Statement pstmt = null;
        String query = "";
        int count = 0;
               
       query = " UPDATE prop_res SET \n"+
       		   "        prop_dt =replace('"+prop_dt+"','-','') \n"+
    	       " WHERE  prop_ym='"+prop_ym+"' ";

		try{


            con.setAutoCommit(false);
            pstmt = con.createStatement();
            count = pstmt.executeUpdate(query);
                      
            pstmt.close();
            con.commit();



        }catch(SQLException se){
            try{
                con.rollback();
				System.out.println("[OffAncDB-updatePropDt]"+se);
				System.out.println("[OffAncDB-updatePropDt]"+query);
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

    /**
	 *	제안회의예약 조회하기
	 */
	public Hashtable getPropResCase(String prop_dt) throws DatabaseException, DataSourceEmptyException{
	
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select a.* from prop_res a where nvl(a.prop_dt,a.prop_est_dt)=replace('"+prop_dt+"','-','') ";

		try {
			stmt = con.createStatement();
	    	rs = stmt.executeQuery(query);
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
		} catch (SQLException e) {
			System.out.println("[OffPropDatabase:getPropResCase]\n"+e);
			System.out.println("[OffPropDatabase:getPropResCase]\n"+query);
	  		e.printStackTrace();
		} finally {
			 try{
                if(rs != null )		rs.close();
                if(stmt != null)	stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }		
			return ht;		
	}

	/****************************************************************************************
	*******************************************   smart
    ****************************************************************************************/
	
  //제안함 리스트
	public Vector getOffPropList(String gubun, String t_wd, String gubun1,  String gubun2, String gubun3, String user_id )throws DatabaseException, DataSourceEmptyException{
	
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String useyn = "";
		
		if (gubun3.equals("1")) {
			useyn = "'Y'" ;			
		}else if (gubun3.equals("2")) {
			useyn = "'N'" ;
		} else  if (gubun3.equals("0")) {
			useyn = "'N', 'Y'" ;
		}	

		query = " select a.*, b.user_nm, c.br_nm, d.nm, nvl(f.cnt1,0) cnt1, nvl(f.cnt2,0) cnt2, nvl(f.cnt3,0) cnt3,"+
				" decode(nvl(e.cnt,0),0,'N','Y') read_yn, "+
				" decode(a.prop_step,'1','수렴','2','심사', '3','재심', '6','처리','7','완료', '5','보류') step,"+
				" decode(a.reg_dt,to_char(sysdate,'YYYYMMDD'),'new') new_yn,"+
				" decode(b.loan_st,'',0,1) loan_st, \n"+
				" nvl(ff.r_cnt1,0) r_cnt1, nvl(ff.r_cnt2,0) r_cnt2, nvl(ff.r_cnt3,0) r_cnt3, \n"+

				" decode(g.e_amt3,'','미등록',0,'미등록','-') eval_e3, \n"+
				" decode(g.e_amt4,'','미등록',0,'미등록','-') eval_e4, \n"+
				" decode(g.e_amt5,'','미등록',0,'미등록','-') eval_e5, \n"+
				" decode(g.e_amt6,'','미등록',0,'미등록','-') eval_e6, \n"+

				" decode(a.use_yn,'Y',decode(gg.p_amt3,'','미등록',0,'미등록','-'),'-') eval_p3, \n"+
				" decode(a.use_yn,'Y',decode(gg.p_amt4,'','미등록',0,'미등록','-'),'-') eval_p4, \n"+
				" decode(a.use_yn,'Y',decode(gg.p_amt5,'','미등록',0,'미등록','-'),'-') eval_p5, \n"+
				" decode(a.use_yn,'Y',decode(gg.p_amt6,'','미등록',0,'미등록','-'),'-') eval_p6, \n"+

				" decode(h.prop_id,'',f.cnt1+f.cnt2||'건', decode(f.cnt1+f.cnt2-h.e_cnt3,0,'-',f.cnt1+f.cnt2-h.e_cnt3||'건')) eval_c3, \n"+
				" decode(h.prop_id,'',f.cnt1+f.cnt2||'건', decode(f.cnt1+f.cnt2-h.e_cnt4,0,'-',f.cnt1+f.cnt2-h.e_cnt4||'건')) eval_c4, \n"+
				" decode(h.prop_id,'',f.cnt1+f.cnt2||'건', decode(f.cnt1+f.cnt2-h.e_cnt5,0,'-',f.cnt1+f.cnt2-h.e_cnt5||'건')) eval_c5, \n"+
				" decode(h.prop_id,'',f.cnt1+f.cnt2||'건', decode(f.cnt1+f.cnt2-h.e_cnt6,0,'-',f.cnt1+f.cnt2-h.e_cnt6||'건')) eval_c6  \n"+

//				" case when a.use_yn = 'Y' then decode(gg.p_amt,'','미등록','-') else '-' end  eval_st3, "+
//			 	" case when nvl(f.cnt1,0) + nvl(f.cnt2,0) = 0 then '-' else decode( nvl(f.cnt1,0) + nvl(f.cnt2,0)- nvl(h.cnt,0), 0, '-',  nvl(f.cnt1,0) + nvl(f.cnt2,0)- nvl(h.cnt,0) ||'건') end eval_st2 "+
				" from prop_bbs a, users b, branch c, \n"+
				" (select * from code where c_st='0002' and code<>'0000') d,\n"+
				" (select prop_id, count(0) cnt from prop_comment where com_st='1' and reg_id='"+user_id+"' group by prop_id) e,\n"+
				" (select prop_id, count(decode(com_st,'1',prop_id)) cnt1, count(decode(com_st,'2',prop_id)) cnt2, count(decode(com_st,'3',prop_id)) cnt3 from prop_comment where reg_id not in ('000003','000004','000005','000006') group by prop_id) f,\n"+
				" (select prop_id, count(decode(yn,'0',prop_id)) r_cnt1, count(decode(yn,'1',prop_id)) r_cnt2, count(decode(yn,'2',prop_id)) r_cnt3 from prop_comment where reg_id not in ('000003','000004','000005','000006') group by prop_id) ff,\n"+
				
				" (select a.prop_id, b.e_amt3, b.e_amt4, b.e_amt5, b.e_amt6  "+
				"  from   prop_bbs a, "+
				"		  (select prop_id, seq, "+
				"	              nvl(sum(decode(eval_id,'000003',e_amt)),0) e_amt3, "+
				"	              nvl(sum(decode(eval_id,'000004',e_amt)),0) e_amt4, "+
				"	              nvl(sum(decode(eval_id,'000005',e_amt)),0) e_amt5, "+
				"	              nvl(sum(decode(eval_id,'000006',e_amt)),0) e_amt6  "+
				"	       from   prop_c_eval where seq='0' group by prop_id, seq) b "+
                "  where  a.prop_id=b.prop_id) g, \n"+
                
				" (select a.prop_id, b.p_amt3, b.p_amt4, b.p_amt5, b.p_amt6  "+
				"  from   prop_bbs a, "+
				"	      (select prop_id, seq, "+
				"	              nvl(sum(decode(eval_id,'000003',p_amt)),0) p_amt3, "+
				"	              nvl(sum(decode(eval_id,'000004',p_amt)),0) p_amt4, "+
				"	              nvl(sum(decode(eval_id,'000005',p_amt)),0) p_amt5, "+
				"	              nvl(sum(decode(eval_id,'000006',p_amt)),0) p_amt6  "+
				"	       from   prop_c_eval where seq='0' group by prop_id, seq) b "+
                "  where  a.use_yn = 'Y' and a.prop_id=b.prop_id) gg, \n"+

				" (select a.prop_id, "+
				"	      count(decode(b.e_amt3,'','','0','',b.prop_id)) e_cnt3, "+
				"	      count(decode(b.e_amt4,'','','0','',b.prop_id)) e_cnt4, "+
				"	      count(decode(b.e_amt5,'','','0','',b.prop_id)) e_cnt5, "+
				"	      count(decode(b.e_amt6,'','','0','',b.prop_id)) e_cnt6  "+
				"  from   prop_comment a, "+
				"	      (select prop_id, seq, "+
				"	              nvl(sum(decode(eval_id,'000003',e_amt)),0) e_amt3, "+
				"	              nvl(sum(decode(eval_id,'000004',e_amt)),0) e_amt4, "+
				"	              nvl(sum(decode(eval_id,'000005',e_amt)),0) e_amt5, "+
				"	              nvl(sum(decode(eval_id,'000006',e_amt)),0) e_amt6  "+
				"	       from   prop_c_eval where seq<>'0' group by prop_id, seq) b "+
                "  where  a.prop_id=b.prop_id(+) and a.seq=b.seq(+) "+
				"         and b.prop_id is not null and a.reg_id not in ('000003','000004','000005','000006')"+
				"  group by a.prop_id) h \n"+

				" where a.reg_id=user_id and b.br_id=c.br_id and b.dept_id=d.code and a.prop_id=e.prop_id(+) and a.prop_id=f.prop_id(+) and a.prop_id=ff.prop_id(+) "+
				"       and a.prop_id=g.prop_id(+)"+
				"       and a.prop_id=gg.prop_id(+)"+
				"       and a.prop_id=h.prop_id(+)"+
				"  ";

		if(!useyn.equals(""))	query += " and b.use_yn  in ( " + useyn + " ) ";

        
		if(gubun.equals("title"))		query += " and upper(nvl(a.title, ' ')) like upper('%"+t_wd+"%') ";
		if(gubun.equals("content"))		query += " and (upper(a.content1) like upper('%"+t_wd+"%') OR upper(a.content2) like upper('%"+t_wd+"%') OR upper(a.content3) like upper('%"+t_wd+"%'))";
		if(gubun.equals("user_nm"))		query += " and upper(nvl(b.user_nm, ' ')) like upper('%"+t_wd+"%') ";
		if(gubun.equals("c_year"))		query += " and a.reg_dt like to_char(sysdate, 'yyyy')||'%'  ";
		if(gubun.equals("c_mon"))		query += " and a.reg_dt like to_char(sysdate,'YYYYMM')||'%'  ";
		if(gubun.equals("b_mon"))		query += " and a.reg_dt like to_char(to_date(to_char(sysdate,'YYYYMM'),'YYYYMM')-1,'YYYYMM')||'%'  ";
		    			
		query += " order by a.prop_step, a.reg_dt desc, a.prop_id desc ";

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
			System.out.println("[OffPropDatabase:getOffPropList]\n"+e);
			System.out.println("[OffPropDatabase:getOffPropList]\n"+query);
	  		e.printStackTrace();
		} finally {
			 try{
                if(rs != null ) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }		
			return vt;		
	}
	
	//최근 30일이내 제안완료건
	public Vector getProp30EndList() throws DatabaseException, DataSourceEmptyException{
		
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select prop_id, exp_dt, title\r\n"
				+ "FROM   prop_bbs\r\n"
				+ "WHERE  prop_step='7' --완료\r\n"
				+ "       AND use_yn IN ('Y','M','O') --채택,수정채택,업무시정채택\r\n"
				+ "       AND exp_dt >= TO_CHAR(SYSDATE-30,'YYYYMMDD') --30일이내  \r\n"
				+ "       AND exp_dt not in ( '20211012' ) -- 이관정리건 제외 \r\n"  
				+ "ORDER BY exp_dt DESC ";

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
			System.out.println("[OffPropDatabase:getProp30EndList]\n"+e);
			System.out.println("[OffPropDatabase:getProp30EndList]\n"+query);
	  		e.printStackTrace();
		} finally {
			 try{
                if(rs != null )		rs.close();
                if(stmt != null)	stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }		
			return vt;		
	}


}
