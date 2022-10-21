package acar.pay_mng;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Hashtable;
import java.util.Vector;

import acar.common.CodeBean;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.DatabaseException;

public class PaySearchDatabase
{
	private static PaySearchDatabase instance;
	private Connection conn = null;
    private DBConnectionManager connMgr;   
    private final String DATA_SOURCE    = "acar";
	private final String DATA_SOURCE1	= "neoe"; 
 
	public static synchronized PaySearchDatabase getInstance() {
        if (instance == null)
            instance = new PaySearchDatabase();
        return instance;
    }
    
   	private PaySearchDatabase()  {
        connMgr = DBConnectionManager.getInstance();
    }



	/**********************************************/	
	/*                                            */
	/*       출금원장 조회등록분 검색메소드       */
	/*                                            */
	/**********************************************/	


	/**
	 *	01 자동차대금 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt01List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  \n"+
				"        decode(a.trf_st, '1','5', '2','2', '3','3', '7','7') as p_way, \n"+
				"        a.rent_mng_id as p_cd1, a.rent_l_cd as p_cd2, a.gubun as p_cd3, c.car_st as p_cd4, a.gubun as p_cd5, \n"+
				"        '1' as p_st1, '자동차대금' as p_st2, decode(a.trf_st, '1','계좌이체', '2','선불카드', '3','후불카드', '7','카드할부') as p_st3, \n"+
				"        decode(a.gubun,'5','임시운행보험료','0','계약금',decode(a.trf_st, '1','잔금', '2','선불카드', '3','후불카드', '7','카드할부')) p_st4, '' p_st5, \n"+

				"        decode(a.trf_st, '1','car_off_id', '2','com_code', '3','com_code', '7','com_code') as off_st, \n"+
				"     	 decode(k.card_kind_cd,'0001','996214',decode(a.trf_st, '1',h.car_off_id, '2',k.com_code, '3',k.com_code, '7',k.com_code)) as off_id, \n"+
				"	     decode(k.card_kind_cd,'0001','광주카드선불(0679)차량대금',decode(a.trf_st, '1',h.car_off_nm, '2',k.com_name, '3',k.com_name, '7',k.com_name)) as off_nm, \n"+
				"	     decode(a.trf_st, '1',h.car_off_tel, '2','', '3','', '7','') as off_tel, \n"+

				"        decode(k.card_kind_cd,'0001','996214',decode(a.trf_st, '1',h.ven_code, '2',k.com_code, '3',k.com_code, '7',k.com_code)) as ven_code, \n"+
				"        decode(k.card_kind_cd,'0001','광주카드선불(0679)차량대금',decode(a.trf_st, '1','', '2',k.com_name, '3',k.com_name, '7',k.com_name)) as ven_name, "+

				"        nvl(a.pur_est_dt,to_char(sysdate,'YYYYMMDD')) as est_dt, a.trf_amt as amt, "+

				"		 decode(k.card_kind_cd,'0011','',decode(a.trf_st, '1',decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0')))  bank_id, \n"+
				"        decode(k.card_kind_cd,'0011','',decode(a.trf_st, '1',a.card_kind)) as bank_nm, "+		
				"        decode(k.card_kind_cd,'0011','',decode(a.trf_st, '1',a.cardno   )) as bank_no, \n"+		

				"		 '' as a_bank_id, \n"+
				"        '' as a_bank_nm, "+
				"        decode(a.trf_st, '2',k.acc_no,    '3',k.acc_no,    '7',k.acc_no, ''   ) as a_bank_no, \n"+

				"        decode(a.trf_st, '2',k.com_code, '3',k.com_code, '7',k.com_code, '' ) card_id,"+
				"        decode(a.trf_st, '2',a.card_kind,'3',a.card_kind,'7',a.card_kind, '') card_nm,"+
				"        decode(a.trf_st, '2',a.cardno,   '3',a.cardno,   '7',a.cardno, ''   ) card_no,"+

				"        '자동차대금 '||decode(a.gubun,'0','계약금 ','5','임시운행보험료 ','잔금 ')||decode(a.trf_st, '1','계좌이체', '2','선불카드', '3','후불카드', '7','카드할부')||' ('||d.firm_nm||'-'||g.car_nm||' '||h.car_off_nm||' '||l.user_nm||')' as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, nvl(b.user_id1,c.bus_id) as buy_user_id, '' s_idno, \n"+

				"        decode(a.gubun,'0','13100',decode(a.trf_st, '1','25300', '2','13100', '3','25300', '7','25300')) acct_code, \n"+

				"        decode(a.gubun,'0',nvl(a.trf_cont,nvl(h.acc_nm,h.car_off_nm)),decode(a.trf_st,'1',a.trf_cont))  bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from \n"+
				"        ( \n"+
				"          select '0' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, decode(con_amt_pay_req,'',nvl(nvl(con_pay_dt,con_est_dt),substr(dlv_est_dt,1,8)),to_char(con_amt_pay_req,'YYYYMMDD')) as pur_est_dt, nvl(trf_st0,'1') as trf_st, con_amt as trf_amt, nvl(con_bank,'') as card_kind, nvl(con_acc_no,'') as cardno, nvl(con_acc_nm,'') as trf_cont, con_pay_dt as pur_pay_dt from car_pur where con_amt>0 and nvl(trf_st0,'1') in ('1','2','3') and con_acc_no is not null  \n"+ 
				"          union all \n"+
				"          select '1' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st1 as trf_st, trf_amt1 as trf_amt, card_kind1 as card_kind, cardno1 as cardno, trf_cont1 as trf_cont, trf_pay_dt1 as pur_pay_dt from car_pur where trf_st1 in ('1','2','3','7')  \n"+//,'3' 후불제외
				"          union all \n"+
				"          select '2' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st2 as trf_st, trf_amt2 as trf_amt, card_kind2 as card_kind, cardno2 as cardno, trf_cont2 as trf_cont, trf_pay_dt2 as pur_pay_dt from car_pur where trf_st2 in ('1','2','3','7')  \n"+//,'3'
				"          union all \n"+
				"          select '3' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st3 as trf_st, trf_amt3 as trf_amt, card_kind3 as card_kind, cardno3 as cardno, trf_cont3 as trf_cont, trf_pay_dt3 as pur_pay_dt from car_pur where trf_st3 in ('1','2','3','7')  \n"+//,'3'
				"          union all \n"+
				"          select '4' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st4 as trf_st, trf_amt4 as trf_amt, card_kind4 as card_kind, cardno4 as cardno, trf_cont4 as trf_cont, trf_pay_dt4 as pur_pay_dt from car_pur where trf_st4 in ('1','2','3','7')  \n"+//,'3'
				"          union all \n"+
				"          select '5' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, decode(trf_amt_pay_req,'',nvl(trf_est_dt5,pur_est_dt),to_char(trf_amt_pay_req,'YYYYMMDD')) pur_est_dt, trf_st5 as trf_st, trf_amt5 as trf_amt, nvl(card_kind5,con_bank) as card_kind, nvl(cardno5,con_acc_no) as cardno, nvl(trf_cont5,con_acc_nm) as trf_cont, trf_pay_dt5 as pur_pay_dt from car_pur where trf_st5 in ('1','2','3') and trf_pay_dt5 is null and nvl(cardno5,con_acc_no) is not null  \n"+
				"        ) a,  \n"+
				"       (select * from doc_settle where doc_st='4' and doc_step='3') b,  \n"+//차량대금요청 doc_st='4', rent_l_cd=doc_id
				"       cont c, client d, car_etc e, car_nm f, car_mng g, car_reg i, users l, card k, \n"+
				"       (select a.rent_mng_id, a.rent_l_cd, b.*, c.car_off_nm, c.car_off_tel, c.bank, c.acc_no, c.acc_nm, c.ven_code from commi a, car_off_emp b, car_off c where a.agnt_st='2' and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id) h, \n"+
				"       (select * from code where c_st='0003') o, (select * from code where c_st='0003') o2, \n"+
				"	    pay_item p \n"+
				" where  \n"+
				"       a.rent_l_cd=b.doc_id(+) and decode(a.gubun,'0','3','5','3',b.doc_step)='3'  \n"+
				"       and a.pur_pay_dt is null"+
				"       and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.car_gu='1' "+
				"	    and nvl(c.use_yn,'Y')='Y' \n"+
				"       and c.client_id=d.client_id \n"+
				"       and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n "+
				"       and e.car_id=f.car_id and e.car_seq=f.car_seq  \n"+
				"       and f.car_comp_id=g.car_comp_id and f.car_cd=g.code \n"+
				"       and c.car_mng_id=i.car_mng_id(+) and c.bus_id=l.user_id \n"+
				"       and a.rent_mng_id=h.rent_mng_id(+) and a.rent_l_cd=h.rent_l_cd(+) \n"+
				"       and a.cardno=k.cardno(+) \n"+
				"       and '1'=p.p_st1(+) and a.rent_mng_id=p.p_cd1(+) and a.rent_l_cd=p.p_cd2(+) and a.gubun=p.p_cd3(+) "+
				"       and a.card_kind=o.nm(+)"+
				"       and h.bank=o2.nm(+)"+
				"       and a.trf_amt >0 "+
				"	    and nvl(c.dlv_dt,to_char(sysdate,'YYYYMMDD')) > '20091231' "+
				" "; 


		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))		query += " and decode(a.trf_st, '1',h.car_off_nm, '2',k.com_name, '3',k.com_name, '7',k.com_name) like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))		query += " and decode(a.gubun,'0',c.rent_dt,'5',nvl(a.pur_est_dt,c.rent_dt),a.pur_est_dt) like replace('"+st_dt+"%', '-','') \n";

		if(s_kd.equals("1"))		what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("2"))		what = "upper(nvl(a.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))		what = "upper(nvl(i.car_no||' '||i.first_car_no, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%')  \n";
		}	

		query += " order by l.dept_id, d.firm_nm, a.rent_l_cd, a.trf_st, a.card_kind, a.cardno, d.firm_nm";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt01List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	06 자동차대금 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt06List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  \n"+
				"        decode(a.trf_st, '0','5', '1','5', '2','2', '3','3', '7','7') as p_way, \n"+
				"        a.rent_mng_id as p_cd1, a.rent_l_cd as p_cd2, a.gubun as p_cd3, c.car_st as p_cd4, a.gubun as p_cd5, \n"+
				"        '6' as p_st1, '중고차대금' as p_st2, decode(a.trf_st, '0','계좌이체', '1','계좌이체', '2','선불카드', '3','후불카드', '7','카드할부') as p_st3, decode(a.gubun, '1','매매금액', '2','중개수수료', '3','보관료') p_st4, '' p_st5, \n"+

				"        'car_off_id' as off_st, \n"+
				"     	 decode(a.gubun,'1',h2.car_off_id,'2',h.car_off_id,'3',h.car_off_id) as off_id, \n"+
				"	     decode(a.gubun,'1',h2.car_off_nm,'2',h.car_off_nm,'3',h.car_off_nm) as off_nm, \n"+
				"	     decode(a.gubun,'1',h2.car_off_tel,'2',h.car_off_tel,'3',h.car_off_tel) as off_tel, \n"+
				"        decode(a.gubun,'1',h2.ven_code,'2',h.ven_code,'3',h.ven_code) as ven_code, \n"+
				"        '' as ven_name, "+

				"        nvl(a.pur_est_dt,to_char(sysdate,'YYYYMMDD')) as est_dt, a.trf_amt as amt, "+

				"		 o.cms_bk as bank_id, \n"+
				"        a.card_kind as bank_nm, "+	
				"        a.cardno as bank_no, \n"+		

				"		 '' as a_bank_id, \n"+
				"        '' as a_bank_nm, "+
				"        '' as a_bank_no, \n"+

				"        decode(a.trf_st, '2',k.com_code, '3',k.com_code, '7',k.com_code ) card_id, "+
				"        decode(a.trf_st, '2',a.card_kind,'3',a.card_kind,'7',a.card_kind) card_nm, "+
				"        decode(a.trf_st, '2',a.cardno,   '3',a.cardno,   '7',a.cardno   ) card_no, "+

				"        '중고차대금 '||decode(a.gubun,'1','매매금액','2','중개수수료','3','보관료')||' ('||a.est_car_no||'-'||g.car_nm||' '||l.user_nm||')' as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, nvl(b.user_id1,c.bus_id) as buy_user_id, '' s_idno, \n"+

				"        '25300' acct_code, \n"+

				"        decode(a.gubun,'1', a.con_acc_nm, h.emp_acc_nm)  bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from \n"+
				"        ( \n"+
				"          select '1' gubun, est_car_no, con_acc_nm, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st1 as trf_st, trf_amt1 as trf_amt, card_kind1 as card_kind, cardno1 as cardno, trf_cont1 as trf_cont, trf_pay_dt1 as pur_pay_dt from car_pur where trf_st1 in ('1','2','3','7')  \n"+
				"          union all \n"+
				"          select '2' gubun, est_car_no, con_acc_nm, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st2 as trf_st, trf_amt2 as trf_amt, card_kind2 as card_kind, cardno2 as cardno, trf_cont2 as trf_cont, trf_pay_dt2 as pur_pay_dt from car_pur where trf_st2 in ('1','2','3','7')  \n"+
				"          union all \n"+
				"          select '3' gubun, est_car_no, con_acc_nm, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, pur_est_dt, trf_st3 as trf_st, trf_amt3 as trf_amt, card_kind3 as card_kind, cardno3 as cardno, trf_cont3 as trf_cont, trf_pay_dt3 as pur_pay_dt from car_pur where trf_st3 in ('1','2','3','7')  \n"+
				"        ) a,  \n"+
				"       (select * from doc_settle where doc_st='4' and doc_step='3') b,  \n"+
				"       cont c, client d, car_etc e, car_nm f, car_mng g, car_reg i, users l, card k, \n"+
				"       (select a.rent_mng_id, a.rent_l_cd, a.emp_bank, a.bank_cd, a.emp_acc_no, a.emp_acc_nm, b.car_off_id, c.car_off_nm, c.car_off_tel, c.ven_code from commi a, car_off_emp b, car_off c where a.agnt_st='5' and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id) h, \n"+
				"       (select a.rent_mng_id, a.rent_l_cd, a.emp_bank, a.bank_cd, a.emp_acc_no, a.emp_acc_nm, b.car_off_id, c.car_off_nm, c.car_off_tel, c.ven_code from commi a, car_off_emp b, car_off c where a.agnt_st='6' and a.emp_id=b.emp_id and b.car_off_id=c.car_off_id) h2, \n"+
				"       (select * from code where c_st='0003') o, \n"+
				"	    pay_item p \n"+
				" where  \n"+
				"       a.rent_l_cd=b.doc_id(+) and decode(a.gubun,'0','3',b.doc_step)='3'  \n"+
				"       and a.pur_pay_dt is null"+
				"       and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.car_gu='2' "+
				"	    and nvl(c.use_yn,'Y')='Y' \n"+
				"       and c.client_id=d.client_id \n"+
				"       and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n "+
				"       and e.car_id=f.car_id and e.car_seq=f.car_seq  \n"+
				"       and f.car_comp_id=g.car_comp_id and f.car_cd=g.code \n"+
				"       and c.car_mng_id=i.car_mng_id(+) and c.bus_id=l.user_id \n"+
				"       and a.rent_mng_id=h.rent_mng_id(+) and a.rent_l_cd=h.rent_l_cd(+) \n"+
				"       and a.rent_mng_id=h2.rent_mng_id and a.rent_l_cd=h2.rent_l_cd \n"+
				"       and a.cardno=k.cardno(+) \n"+
				"       and '6'=p.p_st1(+) and a.rent_mng_id=p.p_cd1(+) and a.rent_l_cd=p.p_cd2(+) and a.gubun=p.p_cd3(+) "+
				"       and a.card_kind=o.nm"+
				"       and a.trf_amt >0 "+
				"	    and c.rent_dt > '20161130' "+
				" "; 


		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))		query += " and decode(a.gubun,'1',h2.car_off_nm,'2',h.car_off_nm,'3',h.car_off_nm) like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))		query += " and decode(a.gubun,'0',c.rent_dt,a.pur_est_dt) like replace('"+st_dt+"%', '-','') \n";

		if(s_kd.equals("1"))		what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("2"))		what = "upper(nvl(a.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))		what = "upper(nvl(a.est_car_no, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%')  \n";
		}	

		query += " order by l.dept_id, d.firm_nm, a.rent_l_cd, a.trf_st, a.card_kind, a.cardno, d.firm_nm";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt06List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }
    
	/**
	 *	07 사전계약 계약금 리스트 조회
	 */
    public Vector getPayEstAmt07List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  \n"+
				"        decode(a.trf_st0, '0','5', '1','5', '2','2', '3','3', '7','7') as p_way, \n"+
				"        a.com_con_no as p_cd1, a.car_off_id as p_cd2, '' as p_cd3, '' as p_cd4, '0' as p_cd5, \n"+
				"        '7' as p_st1, '사전계약계약금' as p_st2, decode(a.trf_st0, '1','계좌이체', '3','후불카드') as p_st3, a.car_off_nm as p_st4, '' p_st5, \n"+
				
				"        decode(a.trf_st0, '1','car_off_id', '2','com_code', '3','com_code') as off_st, \n"+
				"     	 decode(k.card_kind_cd,'0001','996214',decode(a.trf_st0, '1',h.car_off_id, '2',k.com_code, '3',k.com_code)) as off_id, \n"+
				"	     decode(k.card_kind_cd,'0001','광주카드선불(0679)차량대금',decode(a.trf_st0, '1',h.car_off_nm, '2',k.com_name, '3',k.com_name)) as off_nm, \n"+
				"	     decode(a.trf_st0, '0',h.car_off_tel, '1',h.car_off_tel, '2','', '3','', '7','') as off_tel, \n"+

				"        decode(k.card_kind_cd,'0001','996214',decode(a.trf_st0, '1',h.ven_code, '2',k.com_code, '3',k.com_code)) as ven_code, \n"+
				"        decode(k.card_kind_cd,'0001','광주카드선불(0679)차량대금',decode(a.trf_st0, '1','', '2',k.com_name, '3',k.com_name)) as ven_name, "+

				"        nvl(a.con_est_dt,to_char(sysdate,'YYYYMMDD')) as est_dt, a.con_amt as amt, "+

				"		 decode(k.card_kind_cd,'0011','',decode(a.trf_st0, '1',decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0')))  bank_id, \n"+
				"        decode(k.card_kind_cd,'0011','',decode(a.trf_st0, '1',a.con_bank)) as bank_nm, "+		
				"        decode(k.card_kind_cd,'0011','',decode(a.trf_st0, '1',a.con_acc_no   )) as bank_no, \n"+		

				"		 '' as a_bank_id, \n"+
				"        '' as a_bank_nm, "+
				"        decode(a.trf_st0, '2',k.acc_no,   '3',k.acc_no,   '') as a_bank_no, \n"+

				"        decode(a.trf_st0, '2',k.com_code, '3',k.com_code, '') card_id,"+
				"        decode(a.trf_st0, '2',a.con_bank,'3',a.con_bank,'') card_nm,"+
				"        decode(a.trf_st0, '2',a.con_acc_no,   '3',a.con_acc_no,   '') card_no,"+

				"        '자동차대금 사전계약계약금 '||' ('||a.com_con_no||'-'||substr(a.car_nm,1,15)||' '||a.car_off_nm||')' as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, c.user_id as buy_user_id, '' s_idno, \n"+

				"        '13100' acct_code, \n"+

				"        decode(a.trf_st0,'1', a.con_acc_nm)  bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from \n"+
				"       car_pur_com_pre a, car_off h, card k, (SELECT b.* FROM us_me_w a, users b WHERE a.w_nm='사전계약관리' AND a.user_id=b.user_id) c, \n"+
				"       (select * from code where c_st='0003') o, \n"+
				"	    pay_item p, pay_item p2 \n"+
				" where  \n"+
				"       a.use_yn='Y' and a.con_amt >0  \n"+
				"       and (a.con_pay_dt is null or a.con_pay_dt='-') and (a.trf_st0='3' or (nvl(a.trf_st0,'1')='1' and a.con_bank is not null) )  \n"+				
				"       and a.car_off_id=h.car_off_id"+
				"       and a.con_acc_no=k.cardno(+)"+				
				"       and a.con_bank=o.nm(+)"+
				"       and '7'=p.p_st1(+) and a.com_con_no=p.p_cd1(+) "+
				"       and '8'=p2.p_st1(+) and a.com_con_no=p2.p_cd3(+) "+
				" "; 


		if(!yet_again.equals("Y"))	query += " and p.reqseq is null and p2.reqseq is null \n";

		if(!pay_off.equals(""))		query += " and a.car_off_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))		query += " and nvl(a.con_est_dt,to_char(sysdate,'YYYYMMDD')) like replace('"+st_dt+"%', '-','') \n";

		if(s_kd.equals("1"))		what = "upper(a.com_con_no)";
		if(s_kd.equals("2"))		what = "a.car_off_nm";				
		if(s_kd.equals("3"))		what = "a.car_nm";
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%')  \n";
		}	

		query += " order by a.con_est_dt ";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt07List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }   
    
	/**
	 *	08 계약금카드결재 계약금 리스트 조회 - 20220920 의무보험료 제외
	 */
    public Vector getPayEstAmt08List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  \n"+
				"        decode(a.trf_st, '0','5', '1','5', '2','2', '3','3', '7','7') as p_way, \n"+
				"        a.rent_mng_id as p_cd1, a.rent_l_cd as p_cd2, nvl(a.rpt_no,f.com_con_no) as p_cd3, h.car_off_id as p_cd4, a.gubun as p_cd5, \n"+
				"        '8' as p_st1, '계약금카드결제' as p_st2, decode(a.trf_st, '1','계좌이체', '2','선불카드', '3','후불카드') as p_st3, h.car_off_nm as p_st4, '' p_st5, \n"+
				
				"        decode(a.trf_st, '1','car_off_id', '2','com_code', '3','com_code') as off_st, \n"+
				"     	 decode(k.card_kind_cd,'0001','996214',decode(a.trf_st, '1',h.car_off_id, '2',k.com_code, '3',k.com_code)) as off_id, \n"+
				"	     decode(k.card_kind_cd,'0001','광주카드선불(0679)차량대금',decode(a.trf_st, '1',h.car_off_nm, '2',k.com_name, '3',k.com_name)) as off_nm, \n"+
				"	     decode(a.trf_st, '0',h.car_off_tel, '1',h.car_off_tel, '2','', '3','', '7','') as off_tel, \n"+

				"        decode(k.card_kind_cd,'0001','996214',decode(a.trf_st, '1',h.ven_code, '2',k.com_code, '3',k.com_code)) as ven_code, \n"+
				"        decode(k.card_kind_cd,'0001','광주카드선불(0679)차량대금',decode(a.trf_st, '1','', '2',k.com_name, '3',k.com_name)) as ven_name, "+

				"        nvl(a.pur_est_dt,to_char(sysdate,'YYYYMMDD')) as est_dt, a.trf_amt as amt, "+

				"		 decode(k.card_kind_cd,'0011','',decode(a.trf_st, '1',decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0')))  bank_id, \n"+
				"        decode(k.card_kind_cd,'0011','',decode(a.trf_st, '1',a.card_kind)) as bank_nm, "+		
				"        decode(k.card_kind_cd,'0011','',decode(a.trf_st, '1',a.cardno   )) as bank_no, \n"+		

				"		 '' as a_bank_id, \n"+
				"        '' as a_bank_nm, "+
				"        decode(a.trf_st, '2',k.acc_no,   '3',k.acc_no,   '') as a_bank_no, \n"+

				"        decode(a.trf_st, '2',k.com_code, '3',k.com_code, '') card_id,"+
				"        decode(a.trf_st, '2',a.card_kind,'3',a.card_kind,'') card_nm,"+
				"        decode(a.trf_st, '2',a.cardno,   '3',a.cardno,   '') card_no,"+

				"        '자동차대금 '||decode(a.gubun,'0','계약금','5','임시운행보험료')||'카드결제 '||' ('||i.firm_nm||'-'||substr(f.car_nm,1,15)||' '||h.car_off_nm||' '||c.user_nm||')' as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, b.bus_id as buy_user_id, '' s_idno, \n"+

				"        '13100' acct_code, \n"+

				"        decode(a.trf_st,'1', a.trf_cont)  bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from \n"+
				"        ( \n"+
				"          select '0' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, con_est_dt as pur_est_dt, trf_st0 as trf_st, con_amt as trf_amt, con_bank as card_kind, con_acc_no as cardno, con_acc_nm as trf_cont, con_pay_dt as pur_pay_dt from car_pur where con_amt>0 and trf_st0 in ('2','3') and con_pay_dt is null  \n"+ 
//				"          union all \n"+
//				"          select '5' gubun, rpt_no, rent_mng_id, rent_l_cd, dlv_brch, substr(dlv_est_dt,1,8) dlv_est_dt, req_code, trf_est_dt5 as pur_est_dt, trf_st5 as trf_st, trf_amt5 as trf_amt, card_kind5 as card_kind, cardno5 as cardno, trf_cont5 as trf_cont, trf_pay_dt5 as pur_pay_dt from car_pur where trf_amt5>0 and trf_st5 in ('2','3') and trf_pay_dt5 is null \n"+
				"        ) a,  \n"+				
				"       cont b, commi d, car_off_emp e, car_off h, car_pur_com f, client i, card k, users c, \n"+
				"       (select * from code where c_st='0003') o, \n"+
				"	    pay_item p, pay_item p2, pay_item p3 \n"+
				" where  \n"+
				"       a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(b.use_yn,'Y')='Y' "+
				"       and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd and d.agnt_st='2' and d.emp_id=e.emp_id and e.car_off_id=h.car_off_id"+
				"       and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) and b.client_id=i.client_id "+				
				"       and a.cardno=k.cardno(+) and b.bus_id=c.user_id "+				
				"       and a.card_kind=o.nm(+)"+
				"       and '8'=p.p_st1(+) and a.rent_mng_id=p.p_cd1(+) and a.rent_l_cd=p.p_cd2(+) and a.gubun=p.p_cd5(+) "+
				"       and '7'=p2.p_st1(+) and f.com_con_no=p2.p_cd3(+) "+
				"       and '7'=p3.p_st1(+) and a.rpt_no=p3.p_cd3(+) "+				
				" "; 


		if(!yet_again.equals("Y"))	query += " and p.reqseq is null and p2.reqseq is null and p3.reqseq is null \n";

		if(!pay_off.equals(""))		query += " and h.car_off_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))		query += " and nvl(a.pur_est_dt,to_char(sysdate,'YYYYMMDD')) like replace('"+st_dt+"%', '-','') \n";

		if(s_kd.equals("1"))		what = "upper(a.rpt_no)";
		if(s_kd.equals("2"))		what = "h.car_off_nm";				
		if(s_kd.equals("3"))		what = "f.car_nm";
		if(s_kd.equals("4"))		what = "i.firm_nm";
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%')  \n";
		}	

		query += " order by a.pur_est_dt ";
		
	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt08List]"+se);
			System.out.println("[PaySearchDatabase:getPayEstAmt08List]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }       

	/**
	 *	02 영업수당 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt02List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";
		
		//String base_dt = "decode(a.agnt_st,'7',nvl(c.user_dt8,c.user_dt7),to_date(e.rent_start_dt,'YYYYMMDD'))";
		//결재일 기준으로 한다.
		String base_dt = "nvl(c.user_dt8,c.user_dt7)";

		String est_dt = " CASE WHEN d2.car_off_id is not null and d2.pay_st='1' AND TO_NUMBER(d2.est_day) < '31' THEN to_char(add_months("+base_dt+",NVL(d2.est_mon_st,0)),'YYYYMM')||DECODE(LENGTH(d2.est_day),1,'0',0,'01')||d2.est_day \n"+
                        "      WHEN d2.car_off_id is not null and d2.pay_st='1' AND TO_NUMBER(d2.est_day) = '31' THEN TO_CHAR(LAST_DAY(add_months("+base_dt+",NVL(d2.est_mon_st,0))),'YYYYMMDD') \n"+
                        "      WHEN d2.car_off_id is null     and d.pay_st='1'  AND TO_NUMBER(d.est_day) < '31'  THEN to_char(add_months("+base_dt+",NVL(d.est_mon_st,0)),'YYYYMM')||DECODE(LENGTH(d.est_day),1,'0',0,'01')||d.est_day \n"+
                        "      WHEN d2.car_off_id is null     and d.pay_st='1'  AND TO_NUMBER(d.est_day) = '31'  THEN TO_CHAR(LAST_DAY(add_months("+base_dt+",NVL(d.est_mon_st,0))),'YYYYMMDD') \n"+
                        "      ELSE to_char(nvl(c.user_dt8,c.user_dt7),'YYYYMMDD') END ";
	
		query = " select   \n"+
				"        '5' as p_way, \n"+
				"        a.rent_mng_id as p_cd1, a.rent_l_cd as p_cd2, a.agnt_st as p_cd3, '' p_cd4, '' p_cd5, \n"+
				"        '2' as p_st1, '영업수당' as p_st2, '계좌이체' as p_st3, decode(nvl(a.vat_amt,0),0,'','vat') p_st4, '' p_st5, \n"+

				"        decode(d2.doc_st,'2','car_off_id','emp_id') as off_st, "+
				"	     decode(d2.doc_st,'2',d2.car_off_id,a.emp_id) as off_id, "+
				"	     decode(d2.doc_st,'2',d2.car_off_nm,b.emp_nm) as off_nm,  "+
				"	     b.emp_m_tel as off_tel, \n"+
				"        decode(d2.doc_st,'2',d2.ven_code,decode(nvl(d2.car_off_id,'')||d.doc_st,'2',d.ven_code,'')) as ven_code, "+
				"	     decode(d2.doc_st,'2',d2.car_off_nm,decode(nvl(d2.car_off_id,'')||d.doc_st,'2',d.car_off_nm,replace(h.nm,'자동차','')||' '||d.car_off_nm||' '||b.emp_nm)) as ven_name, \n"+

				"        "+est_dt+" as est_dt, \n"+

				"        a.dif_amt as amt, "+

				"		 decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0') bank_id, \n"+
				"	     a.emp_bank as bank_nm, a.emp_acc_no as bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        decode(a.agnt_st,'1','영업수당 ','4','영업대리수당 ','7','계약승계 ')||DECODE(a.dlv_con_commi,'0','','-출고보전수당 ')||DECODE(a.dlv_tns_commi,'0','','-실적이관권장수당 ')||DECODE(a.agent_commi,'0','','-업무진행수당 ')||replace(decode(h.nm,'기타','에이전트',h.nm),'자동차','')||' '||d.car_off_nm||' '||b.emp_nm||' ('||g.firm_nm||'-'||f.car_nm||','||f.car_no||')' as p_cont, \n"+

				"        a.commi+nvl(a.dlv_con_commi,0)+nvl(a.dlv_tns_commi,0)+nvl(a.agent_commi,0)+decode(a.add_st1,'1',nvl(a.add_amt1,0),0)+decode(a.add_st2,'1',nvl(a.add_amt2,0),0)+decode(a.add_st3,'1',nvl(a.add_amt3,0),0) as sub_amt1, \n"+
				"        nvl(a.inc_amt,0)+nvl(a.vat_amt,0) as sub_amt2, nvl(a.res_amt,0) as sub_amt3, \n"+
				"		 decode(a.add_st1,'1',nvl(a.add_amt1,0),0)+decode(a.add_st2,'1',nvl(a.add_amt2,0),0)+decode(a.add_st3,'1',nvl(a.add_amt3,0),0) as sub_amt4, \n"+
				"	     decode(a.add_st1,'2',nvl(a.add_amt1,0),0)+decode(a.add_st2,'2',nvl(a.add_amt2,0),0)+decode(a.add_st3,'2',nvl(a.add_amt3,0),0) as sub_amt5, 0 sub_amt6, \n"+
				"	     decode(d2.doc_st,'2',nvl(e.bus_id2,'000003'),nvl(c.user_id1,e.bus_id)) as buy_user_id, '' s_idno, \n"+

				"        '45500' acct_code, \n"+

				"        nvl(a.emp_acc_nm,b.emp_nm) as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   commi a, car_off_emp b, doc_settle c, car_off d, cont e, car_reg f, client g, code h, (select * from code where c_st='0003') o, pay_item p, "+
				"	     (select * from car_off where car_comp_id='1000') d2 \n"+
				" where  a.agnt_st in ('1','4','7') and a.dif_amt >0  \n"+
				"        and a.sup_dt is null \n"+
				"        and a.emp_id=b.emp_id \n"+
				"        and a.rent_l_cd=c.doc_id and c.doc_st='1' and c.doc_step='3' \n"+
				"        and b.car_off_id=d.car_off_id \n"+
				"        and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
				"        and e.car_mng_id=f.car_mng_id(+) \n"+
				"        and e.client_id=g.client_id \n"+
				"        and d.car_comp_id=h.code and h.c_st='0001' and h.code<>'0000'"+
				"        and '2'=p.p_st1(+) and a.rent_mng_id=p.p_cd1(+) and a.rent_l_cd=p.p_cd2(+) and a.agnt_st=p_cd3(+) "+
				"        and a.emp_bank=o.nm(+)"+
				"        and b.agent_id=d2.car_off_id(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))		query += " and decode(d2.doc_st,'2',d2.car_off_nm,b.emp_nm) like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and "+est_dt+" like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("1"))	what = "upper(nvl(g.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
		if(s_kd.equals("8"))	what = "upper(nvl(b.emp_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(f.car_no||' '||f.first_car_no, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by c.doc_no";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt02List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	03 자동차보험료 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt03List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

	
		query = " select   \n"+		
				"        decode(c.bank_kind, '1','5', '2','2', '3','3','4') as p_way, \n"+
				"        a.car_mng_id as p_cd1, a.ins_st as p_cd2, a.ins_tm as p_cd3, a.ins_tm2 as p_cd4, a.ch_tm as p_cd5, \n"+
				"        '3' as p_st1, '자동차보험료' as p_st2, decode(c.bank_kind, '1','계좌이체', '2','선불카드', '3','후불카드') as p_st3, "+
				"        decode(a.ins_tm2,'2','해지',decode(a.ch_tm,'',decode(a.ins_st,'0','신규','갱신'),'추가')) as p_st4, '' p_st5, \n"+

				"        'ins_com_id' as off_st, c.ins_com_id as off_id, c.ins_com_nm as off_nm, c.agnt_tel as off_tel, \n"+
				"        c.ven_code, c.ven_name,"+

				"        a.r_ins_est_dt as est_dt, "+
				"	     decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt) as amt, "+

				"		 decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0') bank_id, \n"+
				"        decode(c.bank_kind, '1',c.bank_nm, '') as bank_nm, "+
				"        decode(c.bank_kind, '1',c.bank_no, d.acc_no) as bank_no, \n"+

				"		 '' as a_bank_id, \n"+
				"        '' as a_bank_nm, "+
				"        d.acc_no as a_bank_no, \n"+

				"        decode(c.bank_kind, '1','',d.com_code) card_id,"+
				"        decode(c.bank_kind, '1','',d.card_kind) card_nm,"+
				"        decode(c.bank_kind, '1','',d.cardno) card_no,"+

				"        '자동차보험료 '||c.ins_com_nm||' '||decode(a.ins_tm2,'2','해지',decode(a.ch_tm,'',decode(a.ins_st,'0','신규','갱신'),'추가'))||' '||e.car_nm||','||e.car_no as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, '' s_idno, '25300' acct_code, \n"+
					
				"        c.ven_name as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   scd_ins a, insur b, ins_com c, card d, car_reg e, (select * from code where c_st='0003') o, pay_item p \n"+//pay_search p, 
				" where  "+
				"        a.pay_dt is null \n"+
				"	     and a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"        and b.ins_com_id=c.ins_com_id \n"+
				"        and c.bank_no=d.cardno(+) \n"+
				"        and a.car_mng_id=e.car_mng_id(+) \n"+
				"        and '3'=p.p_st1(+) and a.car_mng_id=p.p_cd1(+) and a.ins_st=p.p_cd2(+) and a.ins_tm=p_cd3(+) "+
				"        and c.bank_nm=o.nm(+)"+

				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))		query += " and c.ins_com_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.r_ins_est_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("1"))	what = "upper(nvl(e.car_no, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.ins_con_no, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(e.car_no||' '||e.first_car_no, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by c.ins_com_id, a.ins_tm2, e.car_nm";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt03List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	03 자동차보험료 지급예정 리스트 조회--묶음
	 */
    public Vector getPayEstAmt03_2List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

	
		query = " select   \n"+
				"        decode(c.bank_kind, '1','5', '2','2', '3','3','4') as p_way, \n"+
				"        a.r_ins_est_dt as p_cd1, a.ins_com_id as p_cd2, a.car_use as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '3' as p_st1, '자동차보험료' as p_st2, decode(c.bank_kind, '1','계좌이체', '2','선불카드', '3','후불카드', '4','자동이체') as p_st3, "+
				"        decode(a.car_use,'1','영업용','2','업무용') as p_st4, '' p_st5, \n"+

				"        'ins_com_id' as off_st, c.ins_com_id as off_id, c.ins_com_nm as off_nm, c.agnt_tel as off_tel, \n"+
				"        c.ven_code, c.ven_name,"+

				"        a.r_ins_est_dt as est_dt, "+
				"        a.tot_amt as amt, "+

				"		 decode(c.bank_kind, '1',decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0')) bank_id, \n"+
				"        decode(c.bank_kind, '1',c.bank_nm) as bank_nm, "+
				"        decode(c.bank_kind, '1',c.bank_no) as bank_no, \n"+

				"		 decode(c.bank_kind,'4','260','') as a_bank_id, \n"+ //260	신한	140-004-023871
				"        decode(c.bank_kind,'4','신한','') as a_bank_nm, "+
				"        decode(c.bank_kind,'4','140-004-023871',d.acc_no) as a_bank_no, \n"+

				"        decode(c.bank_kind, '1','','4','',d.com_code) card_id,"+
				"        decode(c.bank_kind, '1','','4','',d.card_kind) card_nm,"+
				"        decode(c.bank_kind, '1','','4','',d.cardno) card_no,"+

				"        '자동차보험료 '||c.ins_com_nm||' '||decode(a.car_use,'1','영업용','2','업무용','3','개인용')||' '||a.ins_est_dt||' 결제분' as p_cont, \n"+

				"        a.sub_amt1, a.sub_amt2, a.sub_amt3, a.sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, '' s_idno, '25300' acct_code, \n"+

				"	     decode(c.bank_kind,'4','',c.ven_name)  as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   ( select a.r_ins_est_dt, b.ins_com_id, b.car_use, max(a.ins_est_dt) ins_est_dt, \n"+
				"                 count(*) cnt, sum(decode(a.ins_tm2,'2',-a.pay_amt,a.pay_amt)) tot_amt, \n"+
				"                 sum(decode(a.ins_tm2,'2',0,decode(a.ch_tm,'',a.pay_amt))) sub_amt1, \n"+
				"                 sum(decode(a.ins_tm2,'2',0,decode(a.ch_tm,'',0,decode(sign(a.pay_amt),1,a.pay_amt)))) sub_amt2, \n"+
				"                 sum(decode(a.ins_tm2,'2',-a.pay_amt)) sub_amt3, \n"+
				"                 sum(decode(a.ins_tm2,'2',0,decode(a.ch_tm,'',0,decode(sign(a.pay_amt),-1,a.pay_amt)))) sub_amt4, \n"+
				"                 count(decode(a.ins_tm2,'2','',decode(a.ch_tm,'',a.pay_amt))) cnt1, \n"+
				"                 count(decode(a.ins_tm2,'2','',decode(a.ch_tm,'','',decode(sign(a.pay_amt),1,a.pay_amt)))) cnt2, \n"+
				"                 count(decode(a.ins_tm2,'2',a.pay_amt)) cnt3, \n"+
				"                 count(decode(a.ins_tm2,'2','',decode(a.ch_tm,'','',decode(sign(a.pay_amt),-1,a.pay_amt)))) cnt4 \n"+
				"          from scd_ins a, insur b \n"+
				"          where "+
				"                a.pay_dt is not null and \n"+ 
				"	             a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"+
				"          group by a.r_ins_est_dt, b.ins_com_id, b.car_use ) a, "+
				"	     ins_com c, card d, (select * from code where c_st='0003') o, pay_item p \n"+ 
				" where   \n"+
				"        a.ins_com_id=c.ins_com_id \n"+
				"        and c.bank_no=d.cardno(+) \n"+
				"        and '3'=p.p_st1(+) and a.r_ins_est_dt=p.p_cd1(+) and a.ins_com_id=p.p_cd2(+) and a.car_use=p.p_cd3(+) "+
				"        and c.bank_nm=o.nm(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))		query += " and c.ins_com_nm like '%"+pay_off+"%' \n";


		if(!st_dt.equals(""))   query += " and a.r_ins_est_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("8"))	what = "upper(nvl(c.ins_com_nm, ' '))";
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.r_ins_est_dt, c.ins_com_id";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt03_2List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	04 할부금 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt04List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select \n"+	
				"        decode(c.p_bank_id,'',decode(a.cpt_nm,'농심캐피탈','5','한국투자캐피탈','5', decode(a.lend_id,'0273','5','0354','5','4')),'5') as p_way, \n"+
				"        decode(a.lend_id,'',a.car_mng_id,a.lend_id||a.rtn_seq) p_cd1, a.alt_tm as p_cd2, a.rent_mng_id as p_cd3, a.rent_l_cd as p_cd4, b.acct_code as p_cd5, \n"+
				"        '4' as p_st1, '할부금' as p_st2, \n"+
				"        decode(c.p_bank_id,'',decode(a.cpt_nm,'농심캐피탈','계좌이체','한국투자캐피탈','계좌이체',decode(a.lend_id,'0273','계좌이체','0354','계좌이체','자동이체')),'계좌이체') as p_st3, \n"+
				"        decode(a.lend_id,'','개별','묶음') as  p_st4, a.gubun as p_st5, \n"+

				"        'cpt_cd' as off_st, a.cpt_cd as off_id, a.cpt_nm as off_nm, \n"+
				"        decode(a.lend_id,'',b.ven_code,d.ven_code) as ven_code, '' as ven_name, \n"+

				"        replace(a.r_alt_est_dt,'-','') as est_dt, \n"+
				"        a.alt_amt as amt, \n"+

                         //[계좌이체] 한화생명보험(0273)-하나은행, 우리은행(0354)-우리은행, 농심캐피탈-우리은행
			    "        decode(c.p_bank_id,'',decode(a.cpt_nm,'농심캐피탈','020','한국투자캐피탈','003',           decode(a.lend_id,'0273','810',            '0354','020',           '')),c.p_bank_id) bank_id, \n"+
				"	     decode(c.p_bank_id,'',decode(a.cpt_nm,'농심캐피탈','우리은행','한국투자캐피탈','IBK기업은행',      decode(a.lend_id,'0273','KEB하나은행',       '0354','우리은행',      '')),c.p_bank_nm) bank_nm, \n"+
				"	     decode(c.p_bank_id,'',decode(a.cpt_nm,'농심캐피탈','1005701224726','한국투자캐피탈','500-029989-01-013', decode(a.lend_id,'0273','35990019287637', '0354','1005701224726', '')),c.p_bank_no) bank_no, \n"+ 

				"        decode(a.lend_id,'',b.bank_code,c.bank_code) as a_bank_id, \n"+
				"        '' as a_bank_nm, \n"+
				"        decode(a.lend_id,'',b.deposit_no,c.deposit_no) as a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        '할부금 '||a.cpt_nm||' '||a.alt_tm||'회차 '||decode(a.lend_id,'',a.car_no,a.lend_id)||decode(a.gubun,'3',' [기타비용]') as p_cont, \n"+

				"        a.alt_prn as sub_amt1, a.alt_int as sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, '' s_idno, '29300' acct_code, \n"+

				"     	 a.cpt_nm as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   DEBT_PAY_VIEW a, allot b, lend_bank c, bank_rtn d, \n"+
				"	     (select reqseq, p_st1, p_cd1, p_cd2, p_st5, substr(reqseq,1,8) alt_dt from pay_item where p_st1='4') p \n"+//pay_search p
				" where  \n"+
				"		 a.cls_rtn_dt is null \n"+
				"	     and a.car_mng_id=b.car_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) \n"+
				"        and a.lend_id=c.lend_id(+) \n"+
				"        and a.lend_id=d.lend_id(+) and a.rtn_seq=d.seq(+) \n"+
				"        and '4'=p.p_st1(+) and decode(a.lend_id,'',a.car_mng_id,a.lend_id||a.rtn_seq)=p.p_cd1(+) and a.alt_tm=p.p_cd2(+) and a.gubun=p.p_st5(+) and replace(a.r_alt_est_dt,'-','')=p.alt_dt(+) \n"+
				" "; 

		if(yet_again.equals("N"))	query += " and p.reqseq is null \n";

		if(!yet_again.equals("P"))	query += " and a.pay_dt1 is null \n";

		if(!pay_off.equals(""))	query += " and a.cpt_nm like '%"+pay_off+"%' \n";


		if(!st_dt.equals(""))   query += " and replace(a.r_alt_est_dt,'-','') like replace('"+st_dt+"%', '-','') \n";

		if(s_kd.equals("3"))	what = "upper(nvl(a.car_no||' '||a.first_car_no, ' '))";	
		if(s_kd.equals("8"))	what = "upper(nvl(a.cpt_nm, ' '))";	
		if(s_kd.equals("9"))	what = "a.alt_tm";	
			
		if(!what.equals("") && !t_wd.equals("")){
			if(s_kd.equals("9")) {
				query += " and "+what+" = '"+t_wd+"' \n";
			}else{
				query += " and "+what+" like upper('%"+t_wd+"%')  \n";
			}
		}	

		query += " order by a.cpt_nm, decode(a.lend_id,'',b.deposit_no,c.deposit_no) \n";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt04List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	04 할부금 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt04ListStat(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String stat_query = "";
		String what = "";

		query = " select  /*+  merge(a) */ \n"+	
				"        decode(a.cpt_nm,'농심캐피탈','5',       decode(a.lend_id,'0273','5','0354','5','4')) as p_way, \n"+
				"        decode(a.lend_id,'',a.car_mng_id,a.lend_id||a.rtn_seq) p_cd1, a.alt_tm as p_cd2, a.rent_mng_id as p_cd3, a.rent_l_cd as p_cd4, b.acct_code as p_cd5, \n"+
				"        '4' as p_st1, '할부금' as p_st2, \n"+
				"        decode(a.cpt_nm,'농심캐피탈','계좌이체',decode(a.lend_id,'0273','계좌이체','0354','계좌이체','자동이체')) as p_st3, \n"+
				"        decode(a.lend_id,'','개별','묶음') as  p_st4, a.gubun as p_st5, \n"+

				"        'cpt_cd' as off_st, a.cpt_cd as off_id, a.cpt_nm as off_nm, \n"+
				"        decode(a.lend_id,'',b.ven_code,d.ven_code) as ven_code, '' as ven_name, \n"+

				"        replace(a.r_alt_est_dt,'-','') as est_dt, \n"+
				"        a.alt_amt as amt, \n"+

                         //[계좌이체] 한화생명보험(0273)-하나은행, 우리은행(0354)-우리은행, 농심캐피탈-우리은행
			    "        decode(a.cpt_nm,'농심캐피탈','020',           decode(a.lend_id,'0273','810',            '0354','020',           '')) bank_id, \n"+
				"	     decode(a.cpt_nm,'농심캐피탈','우리은행',      decode(a.lend_id,'0273','KEB하나은행',       '0354','우리은행',      '')) bank_nm, \n"+
				"	     decode(a.cpt_nm,'농심캐피탈','1005701224726', decode(a.lend_id,'0273','35990019287637', '0354','1005701224726', '')) bank_no, \n"+ 

				"        decode(a.lend_id,'',b.bank_code,c.bank_code) as a_bank_id, \n"+
				"        '' as a_bank_nm, \n"+
				"        decode(a.lend_id,'',b.deposit_no,c.deposit_no) as a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        '할부금 '||a.cpt_nm||' '||a.alt_tm||'회차 '||decode(a.lend_id,'',a.car_no,a.lend_id)||decode(a.gubun,'3',' [기타비용]') as p_cont, \n"+

				"        a.alt_prn as sub_amt1, a.alt_int as sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, '' s_idno, '29300' acct_code, \n"+

				"     	 a.cpt_nm as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   DEBT_PAY_VIEW a, allot b, lend_bank c, bank_rtn d, \n"+
				"	     (select reqseq, p_st1, p_cd1, p_cd2, p_st5, substr(reqseq,1,8) alt_dt from pay_item where p_st1='4') p \n"+//pay_search p
				" where  \n"+
				"		 a.pay_dt1 is null \n"+
				"	     and a.cls_rtn_dt is null \n"+
				"	     and a.car_mng_id=b.car_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) \n"+
				"        and a.lend_id=c.lend_id(+) \n"+
				"        and a.lend_id=d.lend_id(+) and a.rtn_seq=d.seq(+) \n"+
				"        and '4'=p.p_st1(+) and decode(a.lend_id,'',a.car_mng_id,a.lend_id||a.rtn_seq)=p.p_cd1(+) and a.alt_tm=p.p_cd2(+) and a.gubun=p.p_st5(+) and replace(a.r_alt_est_dt,'-','')=p.alt_dt(+) \n"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and a.cpt_nm like '%"+pay_off+"%' \n";


		if(!st_dt.equals(""))   query += " and replace(a.r_alt_est_dt,'-','') like replace('"+st_dt+"%', '-','') \n";

		if(s_kd.equals("3"))	what = "upper(nvl(a.car_no||' '||a.first_car_no, ' '))";	
		if(s_kd.equals("8"))	what = "upper(nvl(a.cpt_nm, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%')  \n";
		}	

		stat_query += " select off_nm, est_dt, count(0) cnt, sum(amt) amt from ("+query+") group by off_nm, est_dt order by off_nm, est_dt ";

	    try{
            pstmt = con.prepareStatement(stat_query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt04ListStat]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	05 할부금중도상환 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt05List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  /*+  merge(a) */ \n"+
				"        '5' as p_way, \n"+
				"        decode(a.lend_id,'',a.car_mng_id,a.lend_id||a.rtn_seq) p_cd1, a.alt_tm as p_cd2, a.rent_mng_id as p_cd3, a.rent_l_cd as p_cd4, b.acct_code as p_cd5, \n"+
				"        '5' as p_st1, '할부금중도상환' as p_st2, '계좌이체' as p_st3, decode(a.lend_id,'','개별','묶음') as  p_st4, '' p_st5, \n"+

				"        'cpt_cd' as off_st, a.cpt_cd as off_id, a.cpt_nm as off_nm, \n"+
				"        decode(a.lend_id,'',b.ven_code,d.ven_code) as ven_code, '' as ven_name, \n"+

				"        replace(a.cls_rtn_dt,'-','') as est_dt, \n"+
				"        a.alt_amt as amt, \n"+

			    "        decode(a.lend_id,'',f.bk_code,e.bk_code) as bank_id, \n"+
				" 		 decode(a.lend_id,'',j2.nm,    j1.nm    ) as bank_nm, \n"+
				"		 decode(a.lend_id,'',f.acnt_no,e.acnt_no) as bank_no, \n"+

				"        '' as a_bank_id, \n"+
				"        '' as a_bank_nm, \n"+
				"        '' as a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        '할부금중도상환 '||a.cpt_nm||' '||decode(a.lend_id,'',a.car_no,a.lend_id) as p_cont, \n"+

				"        decode(a.lend_id,'',f.nalt_rest,      e.nalt_rest      ) as sub_amt1, "+
				"	     decode(a.lend_id,'',f.nalt_rest_1,    e.nalt_rest_1    ) as sub_amt2, "+
				"	     decode(a.lend_id,'',f.nalt_rest_2,    e.nalt_rest_2    ) as sub_amt3, "+
				"	     decode(a.lend_id,'',f.cls_rtn_fee,	   e.cls_rtn_fee    ) as sub_amt4, "+
				" 	     decode(a.lend_id,'',f.cls_rtn_int_amt,e.cls_rtn_int_amt) as sub_amt5, "+
				" 	     decode(a.lend_id,'',f.cls_etc_fee,    e.cls_etc_fee    ) as sub_amt6, "+

				"	 	 '' buy_user_id, '' s_idno, '29300' acct_code, \n"+

				"     	 decode(a.lend_id,'',f.acnt_user,e.acnt_user) as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   DEBT_PAY_VIEW a, allot b, lend_bank c, bank_rtn d, cls_bank e, cls_allot f, \n"+
				"	     (select * from code where c_st='0003') j1,  (select * from code where c_st='0003') j2, pay_item p  \n"+
				" where  a.cls_rtn_dt is not null "+
				"        and a.pay_dt1 is null  "+
				"	     and a.car_mng_id=b.car_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) \n"+
				"        and a.lend_id=c.lend_id(+) \n"+
				"        and a.lend_id=d.lend_id(+) and a.rtn_seq=d.seq(+)"+
				"        and a.lend_id=e.lend_id(+) and a.rtn_seq=e.rtn_seq(+) and a.cls_rtn_dt=e.cls_rtn_dt(+)"+
				"        and a.car_mng_id=f.car_mng_id(+) and a.cls_rtn_dt=f.cls_rtn_dt(+)"+
				"        and e.bk_code=j1.code(+) and f.bk_code=j2.code(+)"+		
				"        and '5'=p.p_st1(+) and decode(a.lend_id,'',a.car_mng_id,a.lend_id||a.rtn_seq)=p.p_cd1(+) and a.alt_tm=p_cd2(+) "+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and a.cpt_nm like '%"+pay_off+"%' \n";


		if(!st_dt.equals(""))   query += " and replace(a.cls_rtn_dt,'-','') like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("3"))	what = "upper(nvl(a.car_no||' '||a.first_car_no, ' '))";	
		if(s_kd.equals("8"))	what = "upper(nvl(a.cpt_nm, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.cpt_nm, decode(a.lend_id,'',b.deposit_no,c.deposit_no)";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt05List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	11 정비비 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt11List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.car_mng_id as p_cd1, a.serv_id as p_cd2, a.accid_id as p_cd3, a.rent_mng_id as p_cd4, a.rent_l_cd as p_cd5,    \n"+
				"        '11' as p_st1, '정비비' as p_st2, '계좌이체' as p_st3,  \n"+
				"        decode(a.serv_st,'1','순환점검','2','일반수리','3','보증수리','4','운행자차','5','사고자차','6','수해','7','재리스정비') as p_st4, '' as p_st5, \n"+

				"        'off_id' as off_st, b.off_id, b.off_nm, b.off_tel, \n"+
				"        nvl(b.ven_code,bn.ven_code) as ven_code, bn.ven_name as ven_name, \n"+

				"        a.serv_dt as est_dt, "+
				"        a.tot_amt as amt, "+

				"        decode(b.bank,'',bn.bank_id, decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0')) bank_id, \n"+
				"	     nvl(b.bank,bn.bank_nm) as bank_nm, nvl(b.acc_no,bn.bank_no) as bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        decode(a.serv_st,'1','순환점검','2','일반수리','3','보증수리','4','운행자차','5','사고자차','6','수해','7','재리스정비')||' '||d.firm_nm||' '||e.car_no||' ('||u.user_nm||')' as p_cont, \n"+

				"        sup_amt as sub_amt1, add_amt as sub_amt2, a.dc sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, nvl(a.checker,nvl(c.mng_id,c.bus_id2)) as buy_user_id, b.ent_no as s_idno, "+

				"	     decode(a.serv_st,'2','45700','45600') acct_code, \n"+

				"	     nvl(nvl(b.acc_nm,bn.bank_acc_nm),b.off_nm||' '||b.own_nm) as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   service a, serv_off b, cont c, client d, car_reg e, users u, (select * from code where c_st='0003') o, pay_item p, \n"+
				"		 ( select a.* from pay_search a, (select off_st, off_id, max(reqseq) reqseq from pay_search where bank_no is not null group by off_st, off_id) b where a.off_st=b.off_st and a.off_id=b.off_id and a.reqseq=b.reqseq) bn, \n"+
				"        ( select * from card_doc where acct_code_g='6' and acct_code in ('00005','00006') AND NVL(app_id,'-') NOT IN ('cancel','cance0')) an, \n"+
				"	     ( select * from pay_search where p_gubun='99' and acct_code in ('45700','45600') ) pn \n"+
				" where  a.tot_amt>0 "+
				"	     and a.set_dt is null\n"+
				"        and a.off_id=b.off_id \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.client_id=d.client_id \n"+
				"        and a.car_mng_id=e.car_mng_id \n"+
                "        and a.checker=u.user_id(+) \n"+ 
				"        and '11'=p.p_st1(+) and a.car_mng_id=p.p_cd1(+) and a.serv_id=p.p_cd2(+) "+
				"        and 'off_id'=bn.off_st(+) and b.off_id=bn.off_id(+)"+
				"        and b.bank=o.nm(+)"+
				"        and a.serv_dt=an.buy_dt(+) and a.tot_amt=an.buy_amt(+) and a.rent_l_cd=an.rent_l_cd(+) and an.cardno is null"+//카드등록분제외
				"        and a.car_mng_id=pn.p_cd3(+) and a.serv_id=pn.p_cd5(+) and pn.reqseq is null"+
				"         \n"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.off_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.serv_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("1"))	what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(e.car_no||' '||e.first_car_no, ' '))";	
		if(s_kd.equals("7"))	what = "upper(nvl(e.car_num, ' '))";	
		if(s_kd.equals("8"))	what = "upper(nvl(b.off_nm, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.serv_dt";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt11List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	14 정비비(정산-명진/부경) 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt14List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.j_acct as p_cd1, a.j_yy as p_cd2, a.j_mm as p_cd3, a.j_seq as p_cd4, '' p_cd5,    \n"+
				"        '14' as p_st1, '정비비(정산)' as p_st2, '계좌이체' as p_st3, a.update_dt as p_st4, a.update_id as p_st5, \n"+

				"        'off_id' as off_st, b.off_id, b.off_nm, b.off_tel,  \n"+
				"        nvl(b.ven_code,bn.ven_code) as ven_code, bn.ven_name as ven_name, \n"+

				"        a.update_dt as est_dt, "+
				"        trunc((a.j_g_amt+a.j_b_amt-a.j_g_dc_amt-a.j_ext_amt-a.j_dc_amt)*1.1,-1) as amt, "+

				"        decode(b.bank,'',bn.bank_id, decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0')) bank_id, \n"+
				"	     nvl(b.bank,bn.bank_nm) as bank_nm, nvl(b.acc_no,bn.bank_no) as bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        decode(b.off_id,'000620','명진자동차공업사',b.off_nm)||' '||a.j_yy||'년'||a.j_mm||'월 '||a.j_seq||'회차' ||'차량정비비' as p_cont, \n"+

				"        a.j_g_amt as sub_amt1, a.j_b_amt as sub_amt2, a.j_g_dc_amt sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, a.update_id as buy_user_id, b.ent_no as s_idno, "+

				"	     '25300' acct_code, \n"+

				"	     nvl(b.acc_nm,bn.bank_acc_nm) as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   mj_jungsan a, serv_off b, (select * from code where c_st='0003') o, pay_item p, \n"+
				"		 ( select a.* from pay_search a, (select off_st, off_id, max(reqseq) reqseq from pay_search where bank_no is not null group by off_st, off_id) b where a.off_st=b.off_st and a.off_id=b.off_id and a.reqseq=b.reqseq) bn \n"+
				" where  trunc((a.j_g_amt+a.j_b_amt-a.j_g_dc_amt)*1.1,0)>0 "+
				"        and a.update_dt > '20091023' \n"+		
				"	     and a.pay_dt is null \n"+
				"        and a.j_acct=b.off_id \n"+
				"        and '14'=p.p_st1(+) and a.j_acct=p.p_cd1(+) and a.j_yy=p.p_cd2(+) and a.j_mm=p.p_cd3(+) and a.j_seq=p.p_cd4(+) "+
				"        and 'off_id'=bn.off_st(+) and b.off_id=bn.off_id(+) "+
				"		 and b.off_id not in ( '000092', '009694' , '008634', '005392', '011605', '011771' ) "+
				"        and b.bank=o.nm(+)"+
				"         \n"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.off_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.update_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("8"))	what = "upper(nvl(b.off_nm, ' '))";	
					
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by b.off_id, a.update_dt";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt14List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

    /**
	 *	14 정비비(정산- 1달 1회 결재 주거래처 - 스피드메이트 등) 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt14_2List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.j_acct as p_cd1, a.j_yy as p_cd2, a.j_mm as p_cd3, a.j_seq as p_cd4, '' p_cd5,    \n"+
				"        '14' as p_st1, '정비비' as p_st2, '계좌이체' as p_st3, a.update_dt as p_st4, a.update_id as p_st5, \n"+

				"        'off_id' as off_st, b.off_id, b.off_nm, b.off_tel,  \n"+
				"        nvl(b.ven_code,bn.ven_code) as ven_code, bn.ven_name as ven_name, \n"+

				"        a.update_dt as est_dt, "+				
				"        trunc((a.j_g_amt+a.j_b_amt-a.j_dc_amt)*1.1,-1) as amt, "+

				"        decode(b.bank,'',bn.bank_id, decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0')) bank_id, \n"+
				"	     nvl(b.bank,bn.bank_nm) as bank_nm, nvl(b.acc_no,bn.bank_no) as bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+
				"        '' card_id, '' card_nm, '' card_no, \n"+

				"		 decode(b.off_id,'009694','SK네트웍스(주)',b.off_nm)||' '||a.j_yy||'년'||a.j_mm||'월 ' as p_cont, \n"+
		
				"        a.j_g_amt as sub_amt1, a.j_b_amt as sub_amt2, a.j_dc_amt + a.j_add_dc_amt sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, a.update_id as buy_user_id, b.ent_no as s_idno, "+

				"	     '25300' acct_code, \n"+

				"	     nvl(b.acc_nm,bn.bank_acc_nm) as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   mj_jungsan a, serv_off b, (select * from code where c_st='0003') o, pay_item p, \n"+
				"		 ( select a.* from pay_search a, (select off_st, off_id, max(reqseq) reqseq from pay_search where bank_no is not null group by off_st, off_id) b where a.off_st=b.off_st and a.off_id=b.off_id and a.reqseq=b.reqseq) bn \n"+
				" where  trunc((a.j_g_amt+a.j_b_amt)*1.1,0)>0 "+
				"        and a.update_dt > '20210901' \n"+		
				"	     and a.pay_dt is null \n"+
				"        and a.j_acct=b.off_id \n"+
				"        and '14'=p.p_st1(+) and a.j_acct=p.p_cd1(+) and a.j_yy=p.p_cd2(+) and a.j_mm=p.p_cd3(+) and a.j_seq=p.p_cd4(+) "+
				"        and 'off_id'=bn.off_st(+) and b.off_id=bn.off_id(+)"+
				"        and b.bank=o.nm(+)"+
				"         \n"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.off_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.update_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("8"))	what = "upper(nvl(b.off_nm, ' '))";	
		if(s_kd.equals("9"))	what = "upper(nvl(a.j_acct||a.j_yy||a.j_mm, ' '))";
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by b.off_id, a.update_dt";
		
	//	System.out.println("query=" + query);

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt14List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

    
	/**
	 *	15 피해사고공임부가세 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt15List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.car_mng_id as p_cd1, a.serv_id as p_cd2, a.accid_id as p_cd3, a.rent_mng_id as p_cd4, a.rent_l_cd as p_cd5,    \n"+
				"        '15' as p_st1, '피해사고공임부가세' as p_st2, '계좌이체' as p_st3,  \n"+
				"        decode(a.serv_st,'1','순환점검','2','일반수리','3','보증수리','4','운행자차','5','사고자차','6','수해','7','재리스정비') as p_st4, decode(f.accid_st,'1','피해','3','쌍방') as p_st5, \n"+

				"        'off_id' as off_st, nvl(b.off_id,'000000') off_id, nvl(b.off_nm,'미정') off_nm, b.off_tel, \n"+
				"        nvl(b.ven_code,bn.ven_code) as ven_code, bn.ven_name as ven_name, \n"+

				"        nvl(a.serv_dt,substr(f.accid_dt,1,8)) as est_dt, "+
				"        0 as amt, "+

				"        decode(b.bank,'',bn.bank_id, decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0')) bank_id, \n"+
				"	     nvl(b.bank,bn.bank_nm) as bank_nm, nvl(b.acc_no,bn.bank_no) as bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        d.firm_nm||' '||e.car_no||' '||substr(f.accid_dt,1,8)||' '||decode(f.accid_st,'1','피해','3','쌍방')||' 당사과실'||f.our_fault_per||'% 공임 부가세분 ('||nvl(u.user_nm,u2.user_nm)||')' as p_cont, \n"+

				"        a.r_labor as sub_amt1, 0 as sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, nvl(nvl(a.checker,f.reg_id),nvl(c.mng_id,c.bus_id2)) as buy_user_id, b.ent_no as s_idno, "+

				"	     '13500' as acct_code, \n"+

				"	     nvl(nvl(b.acc_nm,bn.bank_acc_nm),b.off_nm||' '||b.own_nm) as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   accident f, service a, serv_off b, cont c, client d, car_reg e, users u, users u2, (select * from code where c_st='0003') o, pay_item p, \n"+//pay_search p, 
				"		 ( select a.* from pay_search a, (select off_st, off_id, max(reqseq) reqseq from pay_search where bank_no is not null group by off_st, off_id) b where a.off_st=b.off_st and a.off_id=b.off_id and a.reqseq=b.reqseq) bn \n"+
				" where  f.accid_st in ('1','3')\n"+
				"        and f.car_mng_id=a.car_mng_id(+) and f.accid_id=a.accid_id(+) \n"+
				"        and a.off_id=b.off_id(+) \n"+
				"        and f.rent_mng_id=c.rent_mng_id and f.rent_l_cd=c.rent_l_cd \n"+
				"        and c.client_id=d.client_id \n"+
				"        and f.car_mng_id=e.car_mng_id \n"+
                "        and f.reg_id=u.user_id(+) \n"+ 
                "        and a.checker=u2.user_id(+) \n"+ 
				"        and '15'=p.p_st1(+) and f.car_mng_id=p.p_cd1(+) and f.accid_id=p.p_cd3(+) "+
				"        and 'off_id'=bn.off_st(+) and b.off_id=bn.off_id(+)"+
				"        and b.bank=o.nm(+)"+
				"         \n"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.off_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and nvl(a.serv_dt,substr(f.accid_dt,1,8)) like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("1"))	what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(e.car_no||' '||e.first_car_no, ' '))";	
		if(s_kd.equals("7"))	what = "upper(nvl(e.car_num, ' '))";	
		if(s_kd.equals("8"))	what = "upper(nvl(b.off_nm, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by b.off_id, a.serv_dt";

	    try{
            pstmt = con.prepareStatement(query);
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
        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt15List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	16 피해사고부품부가세 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt16List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        f.car_mng_id as p_cd1, a.serv_id as p_cd2, f.accid_id as p_cd3, f.rent_mng_id as p_cd4, f.rent_l_cd as p_cd5,    \n"+
				"        '16' as p_st1, '피해사고부품부가세' as p_st2, '계좌이체' as p_st3,  \n"+
				"        decode(a.serv_st,'1','순환점검','2','일반수리','3','보증수리','4','운행자차','5','사고자차','6','수해','7','재리스정비') as p_st4, decode(f.accid_st,'1','피해','3','쌍방') as p_st5, \n"+

				"        'off_id' as off_st, nvl(b.off_id,'000000') off_id, nvl(b.off_nm,'미정') off_nm, b.off_tel, \n"+
				"        nvl(b.ven_code,bn.ven_code) as ven_code, bn.ven_name as ven_name, \n"+

				"        nvl(a.serv_dt,substr(f.accid_dt,1,8)) as est_dt, "+
				"        0 as amt, "+

				"        decode(b.bank,'',bn.bank_id, decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0')) bank_id, \n"+
				"	     nvl(b.bank,bn.bank_nm) as bank_nm, nvl(b.acc_no,bn.bank_no) as bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        d.firm_nm||' '||e.car_no||' '||substr(f.accid_dt,1,8)||' '||decode(f.accid_st,'1','피해','3','쌍방')||' 당사과실'||f.our_fault_per||'% 부품 부가세분 ('||nvl(u.user_nm,u2.user_nm)||')' as p_cont, \n"+

				"        a.r_amt as sub_amt1, 0 as sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, nvl(nvl(a.checker,f.reg_id),nvl(c.mng_id,c.bus_id2)) as buy_user_id, b.ent_no as s_idno, "+

				"	     '13500' as acct_code, \n"+

				"	     nvl(nvl(nvl(b.acc_nm,bn.bank_acc_nm),b.off_nm||' '||b.own_nm),'') as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   accident f, service a, serv_off b, cont c, client d, car_reg e, users u, users u2, (select * from code where c_st='0003') o, pay_item p, \n"+//pay_search p, 
				"		 ( select a.* from pay_search a, (select off_st, off_id, max(reqseq) reqseq from pay_search where bank_no is not null group by off_st, off_id) b where a.off_st=b.off_st and a.off_id=b.off_id and a.reqseq=b.reqseq) bn \n"+
				" where  f.accid_st in ('1','3')  \n"+
				"        and f.car_mng_id=a.car_mng_id(+) and f.accid_id=a.accid_id(+) \n"+
				"        and a.off_id=b.off_id(+) \n"+
				"        and f.rent_mng_id=c.rent_mng_id and f.rent_l_cd=c.rent_l_cd \n"+
				"        and c.client_id=d.client_id \n"+
				"        and f.car_mng_id=e.car_mng_id \n"+
                "        and f.reg_id=u.user_id(+) \n"+ 
                "        and a.checker=u2.user_id(+) \n"+ 
				"        and '16'=p.p_st1(+) and f.car_mng_id=p.p_cd1(+) and f.accid_id=p.p_cd3(+) "+
				"        and 'off_id'=bn.off_st(+) and b.off_id=bn.off_id(+)"+
				"        and b.bank=o.nm(+)"+
				"         \n"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.off_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and nvl(a.serv_dt,substr(f.accid_dt,1,8)) like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("1"))	what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(e.car_no||' '||e.first_car_no, ' '))";	
		if(s_kd.equals("7"))	what = "upper(nvl(e.car_num, ' '))";	
		if(s_kd.equals("8"))	what = "upper(nvl(b.off_nm, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by b.off_id, a.serv_dt";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt16List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	18 피해사고렌트부가세 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt18List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.car_mng_id as p_cd1, a.serv_id as p_cd2, a.accid_id as p_cd3, a.rent_mng_id as p_cd4, a.rent_l_cd as p_cd5,    \n"+
				"        '18' as p_st1, '피해사고렌트부가세' as p_st2, '계좌이체' as p_st3,  \n"+
				"        decode(a.serv_st,'1','순환점검','2','일반수리','3','보증수리','4','운행자차','5','사고자차','6','수해','7','재리스정비') as p_st4, decode(f.accid_st,'1','피해','3','쌍방') as p_st5, \n"+

				"        'off_id' as off_st, nvl(b.off_id,'000000') off_id, nvl(b.off_nm,'미정') off_nm, b.off_tel, \n"+
				"        nvl(b.ven_code,bn.ven_code) as ven_code, bn.ven_name as ven_name, \n"+

				"        nvl(a.serv_dt,substr(f.accid_dt,1,8)) as est_dt, "+
				"        0 as amt, "+

				"        decode(b.bank,'',bn.bank_id, decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0')) bank_id, \n"+
				"	     nvl(b.bank,bn.bank_nm) as bank_nm, nvl(b.acc_no,bn.bank_no) as bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        d.firm_nm||' '||e.car_no||' '||substr(f.accid_dt,1,8)||' '||decode(f.accid_st,'1','피해','3','쌍방')||' 당사과실'||f.our_fault_per||'% 렌트 부가세분 ('||nvl(u.user_nm,u2.user_nm)||')' as p_cont, \n"+

				"        a.r_labor as sub_amt1, 0 as sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, nvl(nvl(a.checker,f.reg_id),nvl(c.mng_id,c.bus_id2)) as buy_user_id, b.ent_no as s_idno, "+

				"	     '13500' as acct_code, \n"+

				"	     nvl(nvl(b.acc_nm,bn.bank_acc_nm),b.off_nm||' '||b.own_nm) as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   accident f, service a, serv_off b, cont c, client d, car_reg e, users u, users u2, (select * from code where c_st='0003') o, pay_item p, \n"+//pay_search p, 
				"		 ( select a.* from pay_search a, (select off_st, off_id, max(reqseq) reqseq from pay_search where bank_no is not null group by off_st, off_id) b where a.off_st=b.off_st and a.off_id=b.off_id and a.reqseq=b.reqseq) bn \n"+
				" where  f.accid_st in ('1','3')\n"+
				"        and f.car_mng_id=a.car_mng_id(+) and f.accid_id=a.accid_id(+) \n"+
				"        and a.off_id=b.off_id(+) \n"+
				"        and f.rent_mng_id=c.rent_mng_id and f.rent_l_cd=c.rent_l_cd \n"+
				"        and c.client_id=d.client_id \n"+
				"        and f.car_mng_id=e.car_mng_id \n"+
                "        and f.reg_id=u.user_id(+) \n"+ 
                "        and a.checker=u2.user_id(+) \n"+ 
				"        and '18'=p.p_st1(+) and f.car_mng_id=p.p_cd1(+) and f.accid_id=p.p_cd3(+) "+
				"        and 'off_id'=bn.off_st(+) and b.off_id=bn.off_id(+)"+
				"        and b.bank=o.nm(+)"+
				"         \n"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.off_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and nvl(a.serv_dt,substr(f.accid_dt,1,8)) like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("1"))	what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(e.car_no||' '||e.first_car_no, ' '))";	
		if(s_kd.equals("7"))	what = "upper(nvl(e.car_num, ' '))";	
		if(s_kd.equals("8"))	what = "upper(nvl(b.off_nm, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by b.off_id, a.serv_dt";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt18List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	19 피해사고유리부가세 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt19List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.car_mng_id as p_cd1, a.serv_id as p_cd2, a.accid_id as p_cd3, a.rent_mng_id as p_cd4, a.rent_l_cd as p_cd5,    \n"+
				"        '19' as p_st1, '피해사고유리부가세' as p_st2, '계좌이체' as p_st3,  \n"+
				"        decode(a.serv_st,'1','순환점검','2','일반수리','3','보증수리','4','운행자차','5','사고자차','6','수해','7','재리스정비') as p_st4, decode(f.accid_st,'1','피해','3','쌍방') as p_st5, \n"+

				"        'off_id' as off_st, nvl(b.off_id,'000000') off_id, nvl(b.off_nm,'미정') off_nm, b.off_tel, \n"+
				"        nvl(b.ven_code,bn.ven_code) as ven_code, bn.ven_name as ven_name, \n"+

				"        nvl(a.serv_dt,substr(f.accid_dt,1,8)) as est_dt, "+
				"        0 as amt, "+

				"        decode(b.bank,'',bn.bank_id, decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0')) bank_id, \n"+
				"	     nvl(b.bank,bn.bank_nm) as bank_nm, nvl(b.acc_no,bn.bank_no) as bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        d.firm_nm||' '||e.car_no||' '||substr(f.accid_dt,1,8)||' '||decode(f.accid_st,'1','피해','3','쌍방')||' 당사과실'||f.our_fault_per||'% 유리 부가세분 ('||nvl(u.user_nm,u2.user_nm)||')' as p_cont, \n"+

				"        a.r_labor as sub_amt1, 0 as sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, nvl(nvl(a.checker,f.reg_id),nvl(c.mng_id,c.bus_id2)) as buy_user_id, b.ent_no as s_idno, "+

				"	     '13500' as acct_code, \n"+

				"	     nvl(nvl(b.acc_nm,bn.bank_acc_nm),b.off_nm||' '||b.own_nm) as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   accident f, service a, serv_off b, cont c, client d, car_reg e, users u, users u2, (select * from code where c_st='0003') o, pay_item p, \n"+//pay_search p, 
				"		 ( select a.* from pay_search a, (select off_st, off_id, max(reqseq) reqseq from pay_search where bank_no is not null group by off_st, off_id) b where a.off_st=b.off_st and a.off_id=b.off_id and a.reqseq=b.reqseq) bn \n"+
				" where  f.accid_st in ('1','3')\n"+
				"        and f.car_mng_id=a.car_mng_id(+) and f.accid_id=a.accid_id(+) \n"+
				"        and a.off_id=b.off_id(+) \n"+
				"        and f.rent_mng_id=c.rent_mng_id and f.rent_l_cd=c.rent_l_cd \n"+
				"        and c.client_id=d.client_id \n"+
				"        and f.car_mng_id=e.car_mng_id \n"+
                "        and f.reg_id=u.user_id(+) \n"+ 
                "        and a.checker=u2.user_id(+) \n"+ 
				"        and '19'=p.p_st1(+) and f.car_mng_id=p.p_cd1(+) and f.accid_id=p.p_cd3(+) "+
				"        and 'off_id'=bn.off_st(+) and b.off_id=bn.off_id(+)"+
				"        and b.bank=o.nm(+)"+
				"         \n"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.off_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and nvl(a.serv_dt,substr(f.accid_dt,1,8)) like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("1"))	what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(e.car_no||' '||e.first_car_no, ' '))";	
		if(s_kd.equals("7"))	what = "upper(nvl(e.car_num, ' '))";	
		if(s_kd.equals("8"))	what = "upper(nvl(b.off_nm, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by b.off_id, a.serv_dt";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt19List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }


	/**
	 *	12 탁송료 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt12List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.cons_no as p_cd1, to_char(a.seq) as p_cd2, '' as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '12' as p_st1, '탁송료' as p_st2, '계좌이체' as p_st3, '' as p_st4, '' as p_st5, \n"+

				"        'off_id' as off_st, a.off_id, a.off_nm, b.off_tel, \n"+
				"        b.ven_code, '' as ven_name, \n"+

				"        a.req_dt as est_dt, (a.tot_amt+trunc(a.tot_amt*10/100,0)) as amt, "+

				"        decode(b.bank,'',bn.bank_id, decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0')) bank_id, \n"+
				"	     nvl(b.bank,bn.bank_nm) as bank_nm, nvl(b.acc_no,bn.bank_no) as bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        '탁송료 '||a.off_nm||' '||substr(a.from_dt,1,8)||' '||d.firm_nm||' '||a.car_no||' '||a.car_nm as p_cont, \n"+

				"        a.tot_amt as sub_amt1, trunc(a.tot_amt*10/100,0) sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, c.user_id1 as buy_user_id, b.ent_no as s_idno, \n"+
				"	    '25300' acct_code, nvl(nvl(b.acc_nm,bn.bank_acc_nm),b.off_nm||' '||b.own_nm) as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   consignment a, serv_off b, doc_settle c, client d, (select * from code where c_st='0003') o, pay_item p, \n"+//pay_search p, 
				"		 (select a.* from pay_search a, (select off_st, off_id, max(reqseq) reqseq from pay_search where bank_no is not null group by off_st, off_id) b where a.off_st=b.off_st and a.off_id=b.off_id and a.reqseq=b.reqseq) bn \n"+
				" where  a.pay_dt is null and a.off_id=b.off_id \n"+
				"        and a.cons_no=c.doc_id and c.doc_st='2' and c.doc_step='3' \n"+
				"        and a.client_id=d.client_id(+) \n"+
				"        and a.req_dt is not null and a.conf_dt is not null  \n"+
				"        and '12'=p.p_st1(+) and a.cons_no=p.p_cd1(+) and to_char(a.seq)=p.p_cd2(+) "+
				"        and b.bank=o.nm(+)"+
				"        and 'off_id'=bn.off_st(+) and b.off_id=bn.off_id(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and a.off_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.req_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("1"))	what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.car_no, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.off_id, a.from_dt";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt12List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	12 탁송료 지급예정 리스트 조회-묶음
	 */
    public Vector getPayEstAmt12_2List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.req_code as p_cd1, '' as p_cd2, '' as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '12' as p_st1, '탁송료' as p_st2, '계좌이체' as p_st3, '' as p_st4, '' as p_st5, \n"+

				"        'off_id' as off_st, a.off_id, b.off_nm, b.off_tel, \n"+
				"        b.ven_code, '' as ven_name, \n"+

				"        a.req_dt, decode(a.st,'2',a.tot_amt,(a.tot_amt+trunc(a.tot_amt*10/100,0))) as amt, \n"+

				"        decode(b.bank,'',bn.bank_id, decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0')) bank_id, \n"+
				"	     nvl(b.bank,bn.bank_nm) as bank_nm, nvl(b.acc_no,bn.bank_no) as bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        decode(a.st,'2','배달')||'탁송료 '||b.off_nm||' ('||a.min_dt||'~'||a.max_dt||')' as p_cont, \n"+

				"        decode(a.st,'2',a.tot_amt/1.1,a.tot_amt) as sub_amt1, decode(a.st,'2',a.tot_amt-(a.tot_amt/1.1),trunc(a.tot_amt*10/100,0)) sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, b.ent_no as s_idno, \n"+
				"	     '25300' acct_code, nvl(nvl(b.acc_nm,bn.bank_acc_nm),b.off_nm||' '||b.own_nm) as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk, a.est_dt \n"+

				" from    \n"+
				"        ( select '1' st, a.req_code, a.off_id, a.req_dt, to_char(nvl(b.user_dt2,b.user_dt1),'YYYYMMDD') est_dt, "+
				"      	          count(*) cnt, sum(a.tot_amt) tot_amt, min(substr(a.from_dt,1,8)) min_dt, max(substr(a.from_dt,1,8)) max_dt  \n"+
				"          from   consignment a, doc_settle b \n"+
				"          where  a.req_code=b.doc_id and b.doc_st='3'  \n"+
				"                 and a.pay_dt is null   \n"+
				"          group by a.req_code, a.off_id, a.req_dt, to_char(nvl(b.user_dt2,b.user_dt1),'YYYYMMDD') \n"+
				"	       UNION all \n"+
                "          select '2' st, a.req_code, b.off_id, a.req_dt, to_char(nvl(c.user_dt2,c.user_dt1),'YYYYMMDD') est_dt, \n"+
                "                 count(*) cnt, sum(b.cons_amt1) tot_amt, min(nvl(a.dlv_dt,a.udt_dt)) min_dt, max(nvl(a.dlv_dt,a.udt_dt)) max_dt  \n"+
                "          from   cons_pur a, car_pur b, doc_settle c \n"+
                "          where  a.pay_dt is null \n"+
                "                 and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
                "                 and a.req_code=c.doc_id and c.doc_st='34' \n"+
                "          group by a.req_code, b.off_id, a.req_dt, to_char(nvl(c.user_dt2,c.user_dt1),'YYYYMMDD') \n"+
				"        ) a, "+
				"	     serv_off b, (select * from code where c_st='0003') o, pay_item p, \n"+ 
				"		 (select a.* from pay_search a, (select off_st, off_id, max(reqseq) reqseq from pay_search where bank_no is not null group by off_st, off_id) b where a.off_st=b.off_st and a.off_id=b.off_id and a.reqseq=b.reqseq) bn \n"+
				" where  a.off_id=b.off_id \n"+
				"        and '12'=p.p_st1(+) and a.req_code=p.p_cd1(+) "+
				"        and b.bank=o.nm(+)"+
				"        and 'off_id'=bn.off_st(+) and b.off_id=bn.off_id(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.off_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.req_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("8"))	what = "upper(nvl(b.off_nm, ' '))";

		if(s_kd.equals("9"))	what = "upper(nvl(a.req_code||a.off_id, ' '))";
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.off_id, a.est_dt";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt12_2List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	13 용품비 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt13List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.tint_no as p_cd1, '' as p_cd2, '' as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '13' as p_st1, '용품비' as p_st2, '계좌이체' as p_st3, '' as p_st4, '' as p_st5, \n"+

				"        'off_id' as off_st, a.off_id, a.off_nm, b.off_tel, \n"+
				"        b.ven_code, '' as ven_name, \n"+

				"        a.req_dt as est_dt, (a.tot_amt+trunc(a.tot_amt*10/100,0)) as amt, \n"+

				"        decode(b.bank,'',bn.bank_id, decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0')) bank_id, \n"+
				"	     nvl(b.bank,bn.bank_nm) as bank_nm, nvl(b.acc_no,bn.bank_no) as bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        '용품비 '||a.off_nm||' '||substr(a.sup_dt,1,8)||' '||d.firm_nm||' '||a.car_no||' '||a.car_nm as p_cont, \n"+

				"        a.tot_amt as sub_amt1, trunc(a.tot_amt*10/100,0) sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, c.user_id1 as buy_user_id, b.ent_no as s_idno, \n"+

				"	     '25300' acct_code, nvl(nvl(b.acc_nm,bn.bank_acc_nm),b.off_nm||' '||b.own_nm) as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   tint a, serv_off b, doc_settle c, client d, (select * from code where c_st='0003') o, pay_item p, \n"+
				"		 (select a.* from pay_search a, (select off_st, off_id, max(reqseq) reqseq from pay_search where bank_no is not null group by off_st, off_id) b where a.off_st=b.off_st and a.off_id=b.off_id and a.reqseq=b.reqseq) bn \n"+
				" where  "+
				"		 a.off_id=b.off_id \n"+
				"        and a.tint_no=c.doc_id and c.doc_st='6' and c.doc_step='3' \n"+
				"        and a.client_id=d.client_id(+) \n"+
				"        and a.req_dt is not null and a.conf_dt is not null  \n"+
				"        and '13'=p.p_st1(+) and a.tint_no=p.p_cd1(+) "+
				"        and b.bank=o.nm(+)"+
				"        and 'off_id'=bn.off_st(+) and b.off_id=bn.off_id(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and a.off_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.req_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("1"))	what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.car_no, ' '))";	
		if(s_kd.equals("7"))	what = "upper(nvl(a.car_num, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.off_id, a.sup_dt";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt13List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	13 용품비 지급예정 리스트 조회-묶음
	 */
    public Vector getPayEstAmt13_2List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.req_code as p_cd1, '' as p_cd2, '' as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '13' as p_st1, '용품비' as p_st2, '계좌이체' as p_st3, '' as p_st4, '' as p_st5, \n"+

				"        'off_id' as off_st, a.off_id, b.off_nm, b.off_tel, \n"+
				"        b.ven_code, '' as ven_name, \n"+

				"        a.req_dt, (a.tot_amt+trunc(a.tot_amt*10/100,0)) as amt, \n"+

				"        decode(b.bank,'',bn.bank_id, decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0')) bank_id, \n"+
				"	     nvl(b.bank,bn.bank_nm) as bank_nm, nvl(b.acc_no,bn.bank_no) as bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        '용품비 '||b.off_nm||' ('||a.min_dt||'~'||a.max_dt||')' as p_cont, \n"+

				"        a.tot_amt as sub_amt1, trunc(a.tot_amt*10/100,0) sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, b.ent_no as s_idno,  \n"+

				"	     '25300' acct_code, nvl(nvl(b.acc_nm,bn.bank_acc_nm),b.off_nm||' '||b.own_nm) as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk, a.est_dt \n"+

				" from    \n"+
				"        ( "+
				"		   select a.req_code, a.off_id, a.req_dt, to_char(nvl(b.user_dt2,b.user_dt1),'YYYYMMDD') est_dt, "+
				"      	          count(*) cnt, sum(a.tot_amt) tot_amt, min(substr(a.sup_dt,1,8)) min_dt, max(substr(a.sup_dt,1,8)) max_dt  \n"+
				"          from   tint a, doc_settle b \n"+
				"          where  a.req_code=b.doc_id and b.doc_st='7' \n"+
				"          group by a.req_code, a.off_id, a.req_dt, to_char(nvl(b.user_dt2,b.user_dt1),'YYYYMMDD') \n"+
				"          union all "+
				"		   select a.req_code, a.off_id, a.req_dt, to_char(nvl(b.user_dt2,b.user_dt1),'YYYYMMDD') est_dt, "+
				"      	          count(*) cnt, sum(a.r_tint_amt) tot_amt, min(substr(a.sup_dt,1,8)) min_dt, max(substr(a.sup_dt,1,8)) max_dt  \n"+
				"          from   car_tint a, doc_settle b \n"+
				"          where  a.req_code=b.doc_id and b.doc_st='7' \n"+
				"          group by a.req_code, a.off_id, a.req_dt, to_char(nvl(b.user_dt2,b.user_dt1),'YYYYMMDD') \n"+						
				"        ) a, "+
				"	     serv_off b, (select * from code where c_st='0003') o, pay_item p, \n"+ 
				"		 (select a.* from pay_search a, (select off_st, off_id, max(reqseq) reqseq from pay_search where bank_no is not null group by off_st, off_id) b where a.off_st=b.off_st and a.off_id=b.off_id and a.reqseq=b.reqseq) bn \n"+
				" where  a.off_id=b.off_id \n"+
				"        and '13'=p.p_st1(+) and a.req_code=p.p_cd1(+) "+
				"        and b.bank=o.nm(+)"+
				"        and 'off_id'=bn.off_st(+) and b.off_id=bn.off_id(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.off_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.req_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("8"))	what = "upper(nvl(b.off_nm, ' '))";
		if(s_kd.equals("9"))	what = "upper(nvl(a.req_code||a.off_id, ' '))";
		
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	


		query += " order by a.off_id, a.est_dt";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt13_2List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	17 검사비 지급예정 리스트 조회-묶음
	 */
    public Vector getPayEstAmt17_2List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.req_code as p_cd1, '' as p_cd2, '' as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '17' as p_st1, '검사비' as p_st2, '계좌이체' as p_st3, '' as p_st4, '' as p_st5, \n"+

				"        'off_id' as off_st, a.off_id, b.off_nm, b.off_tel, \n"+
				"        b.ven_code, '' as ven_name, \n"+

				"        a.jung_dt, (a.tot_amt+trunc(a.tot_amt*10/100,0)) as amt, \n"+

				"        decode(b.bank,'',bn.bank_id, decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0')) bank_id, \n"+
				"	     nvl(b.bank,bn.bank_nm) as bank_nm, nvl(b.acc_no,bn.bank_no) as bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        '검사비 '||b.off_nm||' ('||a.min_dt||'~'||a.max_dt||')' as p_cont, \n"+

				"        a.tot_amt as sub_amt1, trunc(a.tot_amt*10/100,0) sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, b.ent_no as s_idno,  \n"+

				"	     '25300' acct_code, nvl(nvl(b.acc_nm,bn.bank_acc_nm),b.off_nm||' '||b.own_nm) as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk, a.est_dt \n"+

				" from    \n"+
				"        ( select a.req_code, a.off_id, a.req_dt, a.jung_dt, to_char(nvl(b.user_dt2,b.user_dt1),'YYYYMMDD') est_dt,  \n"+
				"      	          count(*) cnt, sum(a.che_amt) tot_amt, min(substr(a.che_dt,1,8)) min_dt, max(substr(a.che_dt,1,8)) max_dt \n"+
				"          from   car_maint_req a, doc_settle b  \n"+
				"          where  a.req_code=b.doc_id and b.doc_st='51'  \n"+
				"          and a.jung_dt is not null \n"+
				"          group by a.req_code, a.off_id, a.req_dt, a.jung_dt, to_char(nvl(b.user_dt2,b.user_dt1),'YYYYMMDD') \n"+
				"        ) a, "+
				"	     serv_off b, (select * from code where c_st='0003') o, pay_item p, \n"+ 
				"		 (select a.* from pay_search a, (select off_st, off_id, max(reqseq) reqseq from pay_search where bank_no is not null group by off_st, off_id) b where a.off_st=b.off_st and a.off_id=b.off_id and a.reqseq=b.reqseq) bn \n"+
				" where  a.off_id=b.off_id \n"+
				"        and '17'=p.p_st1(+) and a.req_code=p.p_cd1(+) "+
				"        and b.bank=o.nm(+)"+
				"        and 'off_id'=bn.off_st(+) and b.off_id=bn.off_id(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.off_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.jung_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("8"))	what = "upper(nvl(b.off_nm, ' '))";
		if(s_kd.equals("9"))	what = "upper(nvl(a.req_code||a.off_id, ' '))";
		
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	


		query += " order by a.off_id, a.est_dt";

	    try{
            pstmt = con.prepareStatement(query);
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
        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt17_2List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	21 과태료 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt21List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

	
		query = " select  \n"+
				"        '5' as p_way, \n"+
				"        a.car_mng_id as p_cd1, a.seq_no as p_cd2, a.rent_mng_id as p_cd3, a.rent_l_cd as p_cd4, '' as p_cd5, \n"+
				"        '21' as p_st1, '과태료' as p_st2, '계좌이체' as p_st3, decode(a.fault_st,'1','고객과실','2','업무상과실') as p_st4, '' as p_st5, \n"+

				"        'gov_id' as off_st, b.gov_id as off_id, b.gov_nm as off_nm, b.tel as off_tel, \n"+

				"        d.ven_code as ven_code, nvl(d2.ln_partner,d.firm_nm) as ven_name, \n"+

				"        a.paid_end_dt as est_dt, \n"+
				"        a.paid_amt as amt, \n"+

				"		 nvl(e2.bank_id,decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0')) bank_id, \n"+
				"	     nvl(e2.bank_nm,b.bank_nm) bank_nm, nvl(e2.bank_no,b.bank_no) bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        '과태료 '||decode(a.fault_st,'2','업무상과실')||' '||nvl(i.user_nm,decode(a.rent_s_cd, '',d.firm_nm, decode(f.cust_st,'1',g.firm_nm,h.user_nm)))||' '||e.car_no||' '||e.car_nm as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, nvl(a.mng_id,c.bus_id2) as buy_user_id, '' s_idno, '12400' acct_code, \n"+

				"        '<br>'||a.vio_dt||'<br>'||a.vio_pla||'<br>'||a.vio_cont as etc_cont, \n"+

				"		 b.gov_nm as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk  "+

				" from   fine a, fine_gov b, cont c, client d, neoe.MA_PARTNER d2, car_reg e, rent_cont f, client g, users h, users i, (select * from code where c_st='0003') o, pay_item p, \n"+//pay_search p, 
		        "        (SELECT off_id, bank_id, bank_nm, bank_no, bank_acc_nm FROM pay WHERE off_st='gov_id' and (off_id, reg_dt, reqseq) in (select off_id, max(reg_dt), max(reqseq) from pay where off_st='gov_id' and bank_no is not null group by off_id)) e2 \n"+
				" where  a.proxy_dt is null and a.paid_st<>'1' and a.paid_amt>0 \n"+
				"        and a.pol_sta=b.gov_id \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.client_id=d.client_id \n"+
				" 	     and d.ven_code=d2.cd_partner(+)\n"+
				"        and a.car_mng_id=e.car_mng_id \n"+
				"        and a.car_mng_id=f.car_mng_id(+) and a.rent_s_cd=f.rent_s_cd(+) \n"+
				"        and f.cust_id=g.client_id(+) \n"+
				"        and f.cust_id=h.user_id(+) \n"+
				"        and a.fault_nm=i.user_id(+) \n"+
				"        and '21'=p.p_st1(+) and a.car_mng_id=p.p_cd1(+) and a.seq_no=p.p_cd2(+) and a.rent_mng_id=p.p_cd3(+) and a.rent_l_cd=p.p_cd4(+) "+
				"        and b.bank_nm=o.nm(+)"+
				"        and b.gov_id=e2.off_id(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.gov_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and nvl(a.paid_end_dt,a.notice_dt) like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("1"))	what = "upper(nvl(nvl(i.user_nm,decode(a.rent_s_cd, '',d.firm_nm, decode(f.cust_st,'1',g.firm_nm,h.user_nm))), ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(e.car_no||' '||e.first_car_no, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(a.paid_no, ' '))";	
		if(s_kd.equals("6"))	what = "upper(nvl(b.gov_nm, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by e.car_no, a.paid_end_dt";

	    try{
            pstmt = con.prepareStatement(query);
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
        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt21List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	22 개별소비세 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt22List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  /*+ rule */ \n"+
				"        '4' as p_way, \n"+
				"        a.car_mng_id as p_cd1, a.seq as p_cd2, a.rent_mng_id as p_cd3, a.rent_l_cd as p_cd4, '' as p_cd5, \n"+
				"        '22' as p_st1, '개별소비세' as p_st2, '자동이체' as p_st3, decode(a.tax_st,'1','장기대여','2','매각','3','용도변경','4','폐차') as p_st4, '' as p_st5, \n"+

				"        'gov_id' as off_st, b.gov_id as off_id, b.gov_nm as off_nm, b.tel as off_tel, \n"+
				"        b.ven_code, b.ven_name, \n"+

				"        a.est_dt, a.pay_amt as amt, \n"+

			    "        '' bank_id, '' bank_nm, '' bank_no, \n"+

				"		 decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0') a_bank_id, \n"+
				"	     b.bank_nm as a_bank_nm, b.bank_no as a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        '개별소비세 '||decode(a.tax_st,'1','장기대여','2','매각','3','용도변경','4','폐차')||' '||d.firm_nm||' '||e.car_no||' '||e.car_nm as p_cont, \n"+

				"        a.spe_tax_amt as sub_amt1, a.edu_tax_amt as sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, '' s_idno, \n"+

				"	    '26100' acct_code, b.gov_nm as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   car_tax a, fine_gov b, cont c, client d, car_reg e, (select * from code where c_st='0003') o, pay_item p \n"+//pay_search p, 
				" where  a.pay_dt is null and a.pay_amt>0  \n"+
				"        and b.gov_id='334' \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
				"        and c.client_id=d.client_id \n"+
				"        and a.car_mng_id=e.car_mng_id \n"+
				"        and '22'=p.p_st1(+) and a.car_mng_id=p.p_cd1(+) and a.seq=p.p_cd2(+) and a.rent_mng_id=p.p_cd3(+) and a.rent_l_cd=p.p_cd4(+) "+
				"        and b.bank_nm=o.nm(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.gov_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.est_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("1"))	what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(e.car_no, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.est_dt, a.tax_st";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt22List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	22 개별소비세 지급예정 리스트 조회-묶음
	 */
    public Vector getPayEstAmt22_2List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  /*+ rule */ \n"+
				"        '4' as p_way, \n"+
				"        a.est_dt as p_cd1, '' as p_cd2, '' as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '22' as p_st1, '개별소비세' as p_st2, '자동이체' as p_st3, '' as p_st4, '' as p_st5, \n"+

				"        'gov_id' as off_st, b.gov_id as off_id, b.gov_nm as off_nm, b.tel as off_tel, \n"+
				"        b.ven_code, b.ven_name, \n"+

				"        a.est_dt, a.tot_amt as amt, \n"+

			    "        '' bank_id, '' bank_nm, '' bank_no, \n"+

				"		 decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0') a_bank_id, \n"+
				"	     b.bank_nm as a_bank_nm, b.bank_no as a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        '개별소비세 '||substr(a.tax_dt,1,6)||'월 실적분' as p_cont, \n"+

				"        a.sub_amt1, a.sub_amt2, a.sub_amt3, a.sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, '' s_idno, \n"+

				"   	 '26100' acct_code, b.gov_nm as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   ( select a.est_dt, \n"+
				"                 count(*) cnt, sum(a.pay_amt) tot_amt, max(substr(a.tax_come_dt,1,6)) tax_dt, \n"+
				"                 sum(decode(a.tax_st,'1',a.pay_amt)) sub_amt1, \n"+
				"                 sum(decode(a.tax_st,'2',a.pay_amt)) sub_amt2, \n"+
				"                 sum(decode(a.tax_st,'3',a.pay_amt)) sub_amt3, \n"+
				"                 sum(decode(a.tax_st,'4',a.pay_amt)) sub_amt4  \n"+
				"          from car_tax a \n"+
				"          where a.pay_dt is null \n"+
				"          group by a.est_dt) a, "+
				"        fine_gov b, (select * from code where c_st='0003') o, pay_item p \n"+
				" where  a.tot_amt>0  \n"+
				"        and b.gov_id='334' \n"+
				"        and '22'=p.p_st1(+) and a.est_dt=p.p_cd1(+) "+
				"        and b.bank_nm=o.nm(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.gov_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.est_dt like replace('"+st_dt+"%', '-','')";


		query += " order by a.est_dt";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt22_2List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	23 자동차세 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt23List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  /*+ rule */ \n"+
				"        '1' as p_way, \n"+
				"        a.car_mng_id as p_cd1, a.exp_est_dt as p_cd2, a.exp_st as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '23' as p_st1, '자동차세' as p_st2, '현금지출' as p_st3, decode(e.car_use,'1','영업용','2','업무용') as p_st4, a.exp_start_dt||a.exp_end_dt as p_st5, \n"+

				"        'gov_id' as off_st, b.gov_id as off_id, b.gov_nm as off_nm, b.tel as off_tel, \n"+
				"        b.ven_code, b.ven_name, \n"+

				"        a.exp_est_dt as est_dt, a.exp_amt as amt, \n"+

				"		 decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0') bank_id, \n"+
				"	     b.bank_nm, b.bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        '자동차세 '||decode(e.car_use,'1','영업용','2','업무용')||' '||a.car_no||' '||e.car_nm as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, '' s_idno, "+

				"		 '26100' acct_code, "+ //미지급세금

				"        b.gov_nm as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   gen_exp a, fine_gov b, car_reg e, (select * from code where c_st='0003') o, pay_search p, (select * from code where c_st='0032') c  \n"+
				" where  a.exp_dt is null and a.exp_amt>0 and a.exp_st='3'  \n"+
				"        and decode(e.car_ext,'1','106','2','180','3','058','4','029','5','042','6','182','7','153','8','166','9','805','10','226')=b.gov_id \n"+
				"        and a.car_mng_id=e.car_mng_id \n"+
				"        and '23'=p.p_st1(+) and a.car_mng_id=p.p_cd1(+) and a.exp_est_dt=p.p_cd2(+) "+
				"        and b.bank_nm=o.nm(+)"+
				"        AND e.CAR_EXT = c.nm_cd "+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.gov_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.exp_est_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("4"))	what = "upper(nvl(c.nm, ' '))";
		if(s_kd.equals("3"))	what = "upper(nvl(a.car_no||' '||e.car_no||' '||e.first_car_no, ' '))";
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.exp_est_dt, a.car_ext";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt23List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	23 자동차세 지급예정 리스트 조회-묶음
	 */
    public Vector getPayEstAmt23_2List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  /*+ rule */ \n"+
				"        '1' as p_way, \n"+
				"        a.exp_est_dt as p_cd1, a.car_ext as p_cd2, a.exp_type as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '23' as p_st1, '자동차세' as p_st2, '현금지출' as p_st3, '' as p_st4, a.exp_type as p_st5, \n"+

				"        'gov_id' as off_st, b.gov_id as off_id, b.gov_nm as off_nm, b.tel as off_tel, \n"+
				"        b.ven_code, b.ven_name, \n"+

				"        a.exp_est_dt as est_dt, a.tot_amt as amt, \n"+

				"		 decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0') bank_id, \n"+
				"	     b.bank_nm, b.bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        '자동차세 '||a.exp_type||''||substr(a.exp_est_dt,1,6)||'월납 '||a.cnt||'건' as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, '' s_idno, "+

				"		 decode(a.exp_type,'수시','81700','선납','12300') acct_code, "+ //세금과공과

				"	     b.gov_nm as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   ( select a.exp_est_dt, a.car_ext, \n"+
				"                 count(*) cnt, sum(a.exp_amt) tot_amt, "+
				"                 decode(sign(a.exp_end_dt-a.exp_est_dt),1,'선납','수시') exp_type \n"+
				"          from gen_exp a, car_reg b, code c \n"+
				"          where "+
				"	             a.exp_dt is null and "+
				"	             a.exp_st='3' and c.c_st='0032' and a.car_mng_id=b.car_mng_id "+
				"	             and b.car_ext = c.nm_cd \n";
			
		if(s_kd.equals("3") && !t_wd.equals("")){
			query += " and b.car_no like upper('%"+t_wd+"%') ";
		}	

		query += "          group by a.exp_est_dt, a.car_ext, decode(sign(a.exp_end_dt-a.exp_est_dt),1,'선납','수시') \n"+
				"	     ) a, \n"+
				"	     fine_gov b, (select * from code where c_st='0003') o, pay_item p \n"+
				" where  a.tot_amt>0   \n"+
				"        and decode(a.car_ext,'1','106','2','180','3','058','4','029','5','042','6','182','7','153','8','166','9','805','10','226')=b.gov_id \n"+
				"        and '23'=p.p_st1(+) and a.exp_est_dt=p.p_cd1(+) and a.car_ext=p.p_cd2(+) and a.exp_type=p.p_cd3(+) "+
				"        and b.bank_nm=o.nm(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.gov_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.exp_est_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("4"))	what = "upper(nvl(c.nm, ' '))";
			
		if(s_kd.equals("4") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.exp_est_dt, a.car_ext";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt23_2List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	24 환경개선부담금 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt24List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  /*+ rule */ \n"+
				"        '1' as p_way, \n"+
				"        a.car_mng_id as p_cd1, a.exp_est_dt as p_cd2, a.exp_st as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '24' as p_st1, '환경개선부담금' as p_st2, '현금지출' as p_st3, e.car_use as p_st4, a.exp_start_dt||a.exp_end_dt as p_st5, \n"+

				"        'gov_id' as off_st, b.gov_id as off_id, b.gov_nm as off_nm, b.tel as off_tel, \n"+
				"        b.ven_code, b.ven_name, \n"+

				"        a.exp_est_dt as est_dt, a.exp_amt as amt, \n"+

				"		 decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0') bank_id, \n"+
				"	     b.bank_nm, b.bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        '환경개선부담금 '||decode(e.car_use,'1','영업용','2','업무용')||' '||a.car_no||' '||e.car_nm as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, '' s_idno, '46300' acct_code, "+
				"	     b.gov_nm as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   gen_exp a, fine_gov b, car_reg e, (select * from code where c_st='0003') o, pay_item p \n"+//pay_search p, 
				" where  a.exp_dt is null and a.exp_amt>0 and a.exp_st='2' and c.c_st='0032' \n"+
				"        and decode(e.car_ext,'1','106','2','180','3','058','4','029','5','042','6','182','7','153','8','166','9','805','10','226')=b.gov_id \n"+
				"        and a.car_mng_id=e.car_mng_id \n"+
				"        and '24'=p.p_st1(+) and a.car_mng_id=p.p_cd1(+) and a.exp_est_dt=p.p_cd2(+) "+
				"        and b.bank_nm=o.nm(+) "+
				"        and e.car_ext = c.nm_cd "+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.gov_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.exp_est_dt like replace('"+st_dt+"%', '-','')";
		
		if(s_kd.equals("4"))	what = "upper(nvl(c.nm,' '))";
		if(s_kd.equals("3"))	what = "upper(nvl(a.car_no||' '||e.car_no, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.exp_est_dt, a.car_ext";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt24List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	24 환경개선부담금 지급예정 리스트 조회 - 묶음
	 */
    public Vector getPayEstAmt24_2List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  /*+ rule */ \n"+
				"        '1' as p_way, \n"+
				"        a.exp_est_dt as p_cd1, a.car_ext as p_cd2, a.cnt as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '24' as p_st1, '환경개선부담금' as p_st2, '현금지출' as p_st3, c.nm as p_st4, '' as p_st5, \n"+

				"        'gov_id' as off_st, b.gov_id as off_id, b.gov_nm as off_nm, b.tel as off_tel, \n"+
				"        b.ven_code, b.ven_name, \n"+

				"        a.exp_est_dt as est_dt, a.tot_amt as amt, \n"+

				"		 decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0') bank_id, \n"+
				"	     b.bank_nm, b.bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        '환경개선부담금 '||substr(a.exp_est_dt,1,6)||'월납 '||c.nm||' '||a.cnt||'건' as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, '' s_idno, '46300' acct_code, "+
				"		 b.gov_nm as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   ( select a.exp_est_dt, a.car_ext, \n"+
				"                 count(*) cnt, sum(a.exp_amt) tot_amt \n"+
				"          from gen_exp a \n"+
				"          where a.exp_dt is null and a.exp_st='2' \n"+
				"          group by a.exp_est_dt, a.car_ext) a, \n"+
				"	     fine_gov b, (select * from code where c_st='0003') o, pay_item p, (select * from code where c_st='0032') c \n"+
				" where  a.tot_amt>0   \n"+
				"        and decode(a.car_ext,'1','106','2','180','3','058','4','029','5','042','6','182','7','153','8','166','9','805','10','226')=b.gov_id \n"+
				"        and '23'=p.p_st1(+) and a.exp_est_dt=p.p_cd1(+) and a.car_ext=p.p_cd2(+) and to_char(a.cnt)=p.p_cd3(+) and a.tot_amt=p.i_amt(+) "+
				"        and b.bank_nm=o.nm(+)"+
				"        and a.car_ext = c.nm_cd"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.gov_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.exp_est_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("4"))	what = "upper(nvl(c.nm, ' '))";
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.exp_est_dt, a.car_ext";


	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt24_2List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	25 취득세 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt25List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  /*+ rule */ \n"+
				"        '4' as p_way, \n"+
				"        a.car_mng_id as p_cd1, '' as p_cd2, '' as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '25' as p_st1, '취득세' as p_st2, '자동이체' as p_st3, a.car_use as p_st4, a.car_ext as p_st5, \n"+

				"        'gov_id' as off_st, b.gov_id as off_id, b.gov_nm as off_nm, b.tel as off_tel, \n"+
				"        b.ven_code, b.ven_name, \n"+

				"        a.acq_f_dt as est_dt, a.acq_acq as amt, \n"+

				"		 decode(length(o.cms_bk), 0,'', 3,o.cms_bk, 2,o.cms_bk||'0') bank_id, \n"+
				"        b.bank_nm, b.bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        '취득세 '||decode(a.car_use,'1','영업용','2','자가용')||' '||a.car_no||' '||a.car_nm||' '||d.firm_nm as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, '' s_idno, \n"+

				"	     decode(a.car_use,'1','21700','21900') acct_code, b.gov_nm as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   car_reg a, fine_gov b, cont c, client d, (select * from code where c_st='0003') o, pay_item p, (select * from code where c_st='0032') c \n"+
				" where  a.acq_acq>0  \n"+
				"        and a.acq_ex_dt is null \n"+
				"        and decode(a.car_ext,'1','106','2','180','3','058','4','029','5','042','6','182','7','153','8','166','9','805','10','226')=b.gov_id \n"+
				"        and a.car_mng_id=c.car_mng_id and nvl(c.use_yn,'Y')='Y' \n"+
				"        and c.client_id=d.client_id \n"+
				"        and '25'=p.p_st1(+) and a.car_mng_id=p.p_cd1(+) \n"+
				"        and b.bank_nm=o.nm(+) \n"+
				"        and a.car_ext = c.nm_cd \n"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.gov_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.acq_f_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("4"))	what = "upper(nvl(c.nm, ' '))";
		if(s_kd.equals("3"))	what = "upper(nvl(a.car_no, ' '))";	
		if(s_kd.equals("1"))	what = "upper(nvl(d.firm_nm, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.acq_f_dt, a.car_ext";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt25List]"+se);
			System.out.println("[PaySearchDatabase:getPayEstAmt25List]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	31 해지정산금환불 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt31List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  \n"+
				"        '5' as p_way, \n"+
				"        a.rent_mng_id as p_cd1, a.rent_l_cd as p_cd2, a.ext_st as p_cd3, a.ext_tm as p_cd4, '' as p_cd5, \n"+
				"        '31' as p_st1, '해지정산금환불' as p_st2, '계좌이체' as p_st3, '' as p_st4, '' as p_st5, \n"+

				"        'client_id' as off_st, d.client_id as off_id, d.firm_nm as off_nm, d.o_tel as off_tel, \n"+
				"        decode(c.tax_type,'2',nvl(d2.ven_code,d.ven_code),d.ven_code) ven_code, '' ven_name, \n"+

				"        nvl(a.ext_est_dt,b.cls_dt) as est_dt, -(a.ext_s_amt+a.ext_v_amt+nvl(g.grt_suc_r_amt,0)) amt, \n"+

				"        decode(length(nvl(t.re_bank,decode(b.cls_st,'8',o.cms_bk,''))), 0,'', 3,nvl(t.re_bank,decode(b.cls_st,'8',o.cms_bk,'')), 2,nvl(t.re_bank,decode(b.cls_st,'8',o.cms_bk,''))||'0') as bank_id, \n"+  //20171204 해지문서에 있는 계좌만 가져오도록 수정
				"        nvl(o2.nm,decode(b.cls_st,'8',f.cms_bank,'')) as bank_nm, nvl(t.re_acc_no,decode(b.cls_st,'8',f.cms_acc_no,'')) as bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        decode(c.car_st,'4','월렌트-')||'해지정산금환불 '||decode(b.cls_st,'8','(매입옵션) ')||d.firm_nm||' '||e.car_no||' '||e.car_nm as p_cont, \n"+

				"        a.ext_s_amt as sub_amt1, a.ext_v_amt as sub_amt2, nvl(g.grt_suc_r_amt,0) as sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, t.reg_id as buy_user_id, decode(d.client_st,'2',substr(TEXT_DECRYPT(d.ssn, 'pw' ) ,1,6), d.enp_no) as s_idno, \n"+

				"	     '25300' acct_code, "+
				"	     nvl(t.re_acc_nm,decode(b.cls_st,'8',f.cms_dep_nm,'')) as  bank_acc_nm, "+

				"		 '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   scd_ext a, cls_cont b, cont c, client d, car_reg e, cls_etc t, pay_item p, client_site d2,\n"+
				"        (select * from code where c_st='0003') o, bnk b2, (select * from code where c_st='0003') o2, "+ // and nm not in ('외환은행','제일은행')
				"	     cont_etc g, (select rent_mng_id, rent_l_cd, use_yn from cont where nvl(use_yn,'Y')='Y') h, \n"+ // S108HRTR00380 데이타로 확인 - 출고전해지, 개시전해지 제외
				"        (select a.* from cms_mng a, (select rent_mng_id, rent_l_cd, max(seq) seq from cms_mng group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.seq=b.seq) f \n"+		
				" where  a.ext_st='4' and (a.ext_s_amt+a.ext_v_amt)<0 and nvl(a.bill_yn,'Y')='Y' \n"+
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.car_st in ('1','3') \n"+
				"        and c.client_id=d.client_id \n"+
				"        and c.car_mng_id=e.car_mng_id(+) \n"+
				"        and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) \n"+
				"        and a.rent_mng_id=t.rent_mng_id and a.rent_l_cd=t.rent_l_cd \n"+
				"        and replace(f.cms_bank,'중소기업','기업')=o.nm(+)"+
				"        and t.re_bank=b2.bcode(+) and b2.c_code=o2.code(+)"+
				"        and b.cls_dt > '20090331' \n"+
				"        and '31'=p.p_st1(+) and a.rent_mng_id=p.p_cd1(+) and a.rent_l_cd=p.p_cd2(+) and a.ext_st=p.p_cd3(+) and a.ext_tm=p.p_cd4(+) "+
				"        and c.client_id=d2.client_id(+) and c.r_site=d2.seq(+)"+		
				"        and a.rent_mng_id=g.grt_suc_m_id(+) and a.rent_l_cd=g.grt_suc_l_cd(+) \n"+		
				"        and g.rent_mng_id=h.rent_mng_id(+) and g.rent_l_cd=h.rent_l_cd(+) "+
				"        and a.ext_pay_dt is null \n"+
				"        and a.rent_l_cd not in ('S110KK5R00045','S110KK5R00046','B110HM4L00006','B110HM4L00005') "+		
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and d.firm_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and nvl(a.ext_est_dt,b.cls_dt) like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("1"))	what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(e.car_no, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.ext_est_dt";

	    try{
            pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt31List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	33 계약승계보증금 승계
	 */
    public Vector getPayEstAmt33List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String base_query = "";
		String query = "";
		String what = "";

		base_query = " select e.car_no, b.bus_id2, \n"+
					 "        c.client_id, c.o_tel, decode(c.client_st,'2',substr(TEXT_DECRYPT(c.ssn, 'pw' ) ,1,6), c.enp_no) s_idno, \n"+
					 "        c.firm_nm as a_firm_nm, c.ven_code as a_ven_code, \n"+
					 "        b.rent_mng_id as a_rent_mng_id, b.rent_l_cd as a_rent_l_cd, "+
					 "        f.grt_suc_o_amt as a_grt_amt, \n"+
					 "        c2.firm_nm as b_firm_nm, c2.ven_code as b_ven_code, \n"+
					 "        b2.rent_mng_id as b_rent_mng_id, b2.rent_l_cd as b_rent_l_cd, "+
					 "        f.grt_suc_r_amt as b_grt_amt, \n"+
					 "        nvl(f.rent_suc_dt,a.cls_dt) rent_suc_dt, \n"+
					 "        f.grt_suc_o_amt-f.grt_suc_r_amt as grt_cha_amt, \n"+
					 "        g.cms_bank, g.cms_acc_no, g.cms_dep_nm, g.bank_cd, h.cms_bk \n"+	
					 " from   cls_cont a, cont b, client c, \n"+
					 "        (select rent_mng_id, rent_l_cd, max(ext_pay_dt) ext_pay_dt, sum(ext_s_amt) grt_amt from scd_ext where ext_st='0' and ext_tm='1' group by rent_mng_id, rent_l_cd) d, \n"+
					 "        car_reg e, \n"+
					 "        cont b2, client c2, \n"+
					 "        (select rent_mng_id, rent_l_cd, max(ext_pay_dt) ext_pay_dt, sum(ext_s_amt) grt_amt from scd_ext where ext_st='0' and ext_tm='1' group by rent_mng_id, rent_l_cd) d2, \n"+
					 "        cont_etc f, \n"+
					 "        (select a.* from cms_mng a, (select rent_mng_id, rent_l_cd, max(seq) seq from cms_mng group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.seq=b.seq) g, \n"+
					 "        (select * from code where c_st='0003') h, (select * from fee_etc where cng_chk_id is not null and cng_chk_dt is not null) i \n"+
					 " where  a.cls_st='5' and a.reg_dt>'20100430' \n"+
					 " and    a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
					 " and    b.client_id=c.client_id \n"+
					 " and    b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd \n"+
					 " and    b.car_mng_id=e.car_mng_id \n"+
					 " and    a.rent_mng_id=b2.rent_mng_id and a.reg_dt=b2.reg_dt \n"+
					 " and    b2.client_id=c2.client_id \n"+
					 " and    b2.rent_mng_id=d2.rent_mng_id and b2.rent_l_cd=d2.rent_l_cd \n"+
					 " and    b2.rent_mng_id=f.rent_mng_id and b2.rent_l_cd=f.rent_l_cd and f.rent_suc_grt_yn='0' \n"+
					 " and    a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+) \n"+
					 " and    g.bank_cd=h.code(+) \n"+
					 " and    b2.rent_mng_id=i.rent_mng_id(+) and b2.rent_l_cd=i.rent_l_cd(+) \n"+
					 " and    b.rent_mng_id not in ('014185','015563','016748')"+	
					 " ";


		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.a_rent_mng_id as p_cd1, a.a_rent_l_cd as p_cd2, a.b_rent_mng_id as p_cd3, a.b_rent_l_cd as p_cd4, a.b_ven_code as p_cd5, \n"+
				"        '33' as p_st1, '계약승계보증금' as p_st2, '계좌이체' as p_st3, '' as p_st4, '' as p_st5, \n"+

				"        'client_id' as off_st, a.client_id as off_id, a.a_firm_nm as off_nm, a.o_tel as off_tel, \n"+
				"        a.a_ven_code as ven_code, a.a_firm_nm as ven_name, \n"+

				"        a.rent_suc_dt as est_dt, decode(sign(a.grt_cha_amt),-1,0,a.grt_cha_amt) amt, \n"+

				"        a.cms_bk as bank_id, \n"+
				"        a.cms_bank as bank_nm, a.cms_acc_no as bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        '계약승계보증금 '||a.a_firm_nm||'->'||a.b_firm_nm||' ('||a.car_no||')' as p_cont, \n"+

				"        a.a_grt_amt as sub_amt1, decode(sign(a.grt_cha_amt),-1,a.a_grt_amt,a.b_grt_amt) as sub_amt2, 0 as sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, \n"+

				"	     a.bus_id2 as buy_user_id, a.s_idno as s_idno, \n"+

				"	     '31100' acct_code, a.cms_dep_nm as  bank_acc_nm, a.cms_bk as bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   ( "+base_query+" ) a, pay_item p \n"+
				" where  a.a_grt_amt >0 \n"+
				"        and '33'=p.p_st1(+) "+
				"	     and a.a_rent_mng_id=p.p_cd1(+) and a.a_rent_l_cd=p.p_cd2(+) and a.b_rent_mng_id=p.p_cd3(+) and a.b_rent_l_cd=p.p_cd4(+) "+ 
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and a.a_firm_nm||a.b_firm_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.rent_suc_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("3"))	what = "upper(nvl(a.car_no, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.rent_suc_dt";

	    try{
            pstmt = con.prepareStatement(query);
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


		}catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt33List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	34 대차승계보증금
	 */
    public Vector getPayEstAmt34List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String base_query = "";
		String query = "";
		String what = "";

		base_query = " select a.grt_suc_c_no as car_no, b.bus_id2, \n"+
					 "        c.client_id, c.o_tel, decode(c.client_st,'2',substr(TEXT_DECRYPT(c.ssn, 'pw' ) ,1,6), c.enp_no) s_idno, \n"+
					 "        c.firm_nm as a_firm_nm, c.ven_code as a_ven_code, \n"+
					 "        b.rent_mng_id as a_rent_mng_id, b.rent_l_cd as a_rent_l_cd, b.rent_st as a_rent_st, a.grt_suc_o_amt as a_grt_amt, \n"+
					 "        a.rent_mng_id as b_rent_mng_id, a.rent_l_cd as b_rent_l_cd, a.rent_st as b_rent_st, a.grt_suc_r_amt as b_grt_amt, \n"+
					 "        (a.grt_suc_o_amt-a.grt_suc_r_amt) as grt_cha_amt, \n"+
					 "        decode(length(nvl(t.re_bank,o.cms_bk)), 0,'', 3,nvl(t.re_bank,o.cms_bk), 2,nvl(t.re_bank,o.cms_bk)||'0') as bank_id, \n"+
					 "        nvl(o2.nm,f.cms_bank) as bank_nm, nvl(t.re_acc_no,f.cms_acc_no) as bank_no, \n"+
					 "        nvl(t.re_acc_nm,f.cms_dep_nm) as  bank_acc_nm, \n"+
					 "        nvl(o2.cms_bk,o.cms_bk) as  bank_cms_bk, t.cls_dt, b2.rent_dt \n"+
					 " from   cont_etc a, cont b, cont b2, client c, \n"+
					 "        (select a.* from cms_mng a, (select rent_mng_id, rent_l_cd, max(seq) seq from cms_mng group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.seq=b.seq) f, cls_etc t, \n"+
					 "        (select * from code where c_st='0003') o, (select * from code where c_st='0003' and nm not in ('외환은행','제일은행')) o2 \n"+
					 " where  a.grt_suc_r_amt>0  \n"+
					 " and    a.grt_suc_m_id=b.rent_mng_id and a.grt_suc_l_cd=b.rent_l_cd \n"+
					 " and    a.rent_mng_id=b2.rent_mng_id and a.rent_l_cd=b2.rent_l_cd \n"+
					 " and    b.client_id=c.client_id \n"+
					 " and    b.rent_mng_id=f.rent_mng_id(+) and b.rent_l_cd=f.rent_l_cd(+) \n"+
					 " and    b.rent_mng_id=t.rent_mng_id(+) and b.rent_l_cd=t.rent_l_cd(+) \n"+
					 " and    f.bank_cd=o.code(+) \n"+
					 " and    t.re_bank=o2.cms_bk(+)\n"+
					 " and    b2.reg_dt>'20100531'"+
					 " ";

		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.a_rent_mng_id as p_cd1, a.a_rent_l_cd as p_cd2, a.b_rent_mng_id as p_cd3, a.b_rent_l_cd as p_cd4, a.b_rent_st as p_cd5, \n"+
				"        '34' as p_st1, '대차승계보증금' as p_st2, '계좌이체' as p_st3, '' as p_st4, '' as p_st5, \n"+

				"        'client_id' as off_st, a.client_id as off_id, a.a_firm_nm as off_nm, a.o_tel as off_tel, \n"+
				"        a.a_ven_code as ven_code, a.a_firm_nm as ven_name, \n"+

				"        a.cls_dt as est_dt, 0 amt, \n"+

				"        a.bank_id as bank_id, \n"+
				"        a.bank_nm as bank_nm, a.bank_no as bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        '대차승계보증금 '||a.a_rent_l_cd||'->'||a.b_rent_l_cd||' ('||a.a_firm_nm||')' as p_cont, \n"+

				"        a.a_grt_amt as sub_amt1, a.b_grt_amt as sub_amt2, 0 as sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, \n"+

				"	     a.bus_id2 as buy_user_id, a.s_idno as s_idno, \n"+

				"	     '31100' acct_code, a.bank_acc_nm as  bank_acc_nm, a.bank_cms_bk as bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   ( "+base_query+" ) a, pay_item p \n"+
				" where  a.b_grt_amt >0 \n"+
				"        and '34'=p.p_st1(+) "+
				"	     and a.a_rent_mng_id=p.p_cd1(+) and a.a_rent_l_cd=p.p_cd2(+) and a.b_rent_mng_id=p.p_cd3(+) and a.b_rent_l_cd=p.p_cd4(+) "+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and a.a_firm_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.cls_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("3"))	what = "upper(nvl(a.car_no, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.cls_dt";

	    try{
            pstmt = con.prepareStatement(query);
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


		}catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt34List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	35 계약승계보증금환불
	 */
    public Vector getPayEstAmt35List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String base_query = "";
		String query = "";
		String what = ""; 

		base_query = " select e.car_no, b.bus_id2, \n"+
					 "        c.client_id, c.o_tel, decode(c.client_st,'2',substr(TEXT_DECRYPT(c.ssn, 'pw' ) ,1,6), c.enp_no) s_idno, \n"+
					 "        c.firm_nm as a_firm_nm, c.ven_code as a_ven_code, \n"+
					 "        b.rent_mng_id as a_rent_mng_id, b.rent_l_cd as a_rent_l_cd, "+
					 "	      d.grt_amt as a_grt_amt, \n"+
					 "        c2.firm_nm as b_firm_nm, c2.ven_code as b_ven_code, \n"+
					 "        b2.rent_mng_id as b_rent_mng_id, b2.rent_l_cd as b_rent_l_cd, "+
			         "        d2.grt_amt as b_grt_amt, \n"+
					 "        nvl(f.rent_suc_dt,a.cls_dt) rent_suc_dt, \n"+
					 "        d.grt_amt-d2.grt_amt as grt_cha_amt, \n"+
					 "        g.cms_bank, g.cms_acc_no, g.cms_dep_nm, g.bank_cd, h.cms_bk, \n"+	
					 "        f.rent_suc_grt_yn, f.grt_suc_o_amt, f.grt_suc_r_amt, \n"+
					 "        decode(f.rent_suc_grt_yn,'0',f.grt_suc_o_amt-f.grt_suc_r_amt,'1',f.grt_suc_o_amt) amt"+
					 " from   cls_cont a, cont b, client c, \n"+
					 "        (select rent_mng_id, rent_l_cd, max(ext_pay_dt) ext_pay_dt, sum(ext_s_amt) grt_amt from scd_ext where ext_st='0' and ext_tm='1' group by rent_mng_id, rent_l_cd) d, \n"+
					 "        car_reg e, \n"+
					 "        cont b2, client c2, \n"+
					 "        (select rent_mng_id, rent_l_cd, max(ext_pay_dt) ext_pay_dt, sum(ext_s_amt) grt_amt from scd_ext where ext_st='0' and ext_tm='1' group by rent_mng_id, rent_l_cd) d2, \n"+
					 "        cont_etc f, \n"+
					 "        (select a.* from cms_mng a, (select rent_mng_id, rent_l_cd, max(seq) seq from cms_mng group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.seq=b.seq) g, \n"+
					 "        (select * from code where c_st='0003') h \n"+
					 " where  a.cls_st='5' and a.reg_dt>'20100331' \n"+
					 " and    a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
					 " and    b.client_id=c.client_id \n"+
					 " and    b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd \n"+
					 " and    b.car_mng_id=e.car_mng_id \n"+
					 " and    a.rent_mng_id=b2.rent_mng_id and a.reg_dt=b2.reg_dt \n"+
					 " and    b2.client_id=c2.client_id \n"+
					 " and    b2.rent_mng_id=d2.rent_mng_id and b2.rent_l_cd=d2.rent_l_cd \n"+
					 " and    b2.rent_mng_id=f.rent_mng_id and b2.rent_l_cd=f.rent_l_cd \n"+
					 " and    a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+) \n"+
					 " and    g.bank_cd=h.code(+) \n"+
					 " and    f.grt_suc_o_amt>0 "+
					 " and    f.rent_suc_grt_yn is not null "+
					 " and    b.rent_l_cd not in ('D110KK7R00058','S112HHLR00058','B112KRLR00029','B115KK5R00951','S113KK5R00742')  "+ //직접처리분 제외
					 " ";


		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.a_rent_mng_id as p_cd1, a.a_rent_l_cd as p_cd2, a.b_rent_mng_id as p_cd3, a.b_rent_l_cd as p_cd4, a.b_ven_code as p_cd5, \n"+
				"        '35' as p_st1, '계약승계보증금환불' as p_st2, '계좌이체' as p_st3, '' as p_st4, '' as p_st5, \n"+

				"        'client_id' as off_st, a.client_id as off_id, a.a_firm_nm as off_nm, a.o_tel as off_tel, \n"+
				"        a.a_ven_code as ven_code, a.a_firm_nm as ven_name, \n"+

				"        a.rent_suc_dt as est_dt, a.amt amt, \n"+

				"        a.cms_bk as bank_id, \n"+
				"        a.cms_bank as bank_nm, a.cms_acc_no as bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        '계약승계보증금환불 '||a.a_firm_nm||' ('||a.car_no||')' as p_cont, \n"+

				"        a.a_grt_amt as sub_amt1, a.b_grt_amt as sub_amt2, 0 as sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, \n"+

				"	     a.bus_id2 as buy_user_id, a.s_idno as s_idno, \n"+

				"	     '31100' acct_code, a.cms_dep_nm as  bank_acc_nm, a.cms_bk as bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   ( "+base_query+" ) a, pay_item p \n"+
				" where  a.amt >0 \n"+
				"        and '35'=p.p_st1(+) "+
				"	     and a.a_rent_mng_id=p.p_cd1(+) and a.a_rent_l_cd=p.p_cd2(+) and a.b_rent_mng_id=p.p_cd3(+) and a.b_rent_l_cd=p.p_cd4(+) "+//and a.b_ven_code=p.p_cd5(+) 
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and a.a_firm_nm||a.b_firm_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.rent_suc_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("3"))	what = "upper(nvl(a.car_no, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.rent_suc_dt";

	    try{
            pstmt = con.prepareStatement(query);
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


		}catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt35List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	36 연장계약보증금환불
	 */
    public Vector getPayEstAmt36List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String base_query = "";
		String query = "";
		String what = "";

		base_query = " select f.car_no, c.bus_id2, \n"+
					 "        d.client_id, d.o_tel, decode(d.client_st,'2',substr(TEXT_DECRYPT(d.ssn, 'pw' ) ,1,6), d.enp_no) s_idno, \n"+
					 " 		  d.firm_nm as firm_nm, d.ven_code as ven_code, \n"+
					 "        a.rent_mng_id, a.rent_l_cd, a.rent_st, a.rent_dt, c.use_yn, \n"+
					 "        a.grt_amt_s as a_grt_amt, \n"+
					 "        b.grt_amt_s as b_grt_amt, \n"+
					 "        (b.grt_amt_s-a.grt_amt_s) add_amt, \n"+
					 "        nvl(e.est_s_amt,0) est_s_amt, nvl(e.pay_amt,0) pay_amt, \n"+
					 "        g.cms_bank, g.cms_acc_no, g.cms_dep_nm, g.bank_cd, h.cms_bk \n"+
					 " from   fee a, fee b, cont c, client d, car_reg f, \n"+
					 "        (select rent_mng_id, rent_l_cd, rent_st, sum(ext_s_amt) est_s_amt, sum(ext_pay_amt) pay_amt from scd_ext where ext_st='0' group by rent_mng_id, rent_l_cd, rent_st) e, \n"+
					 "        (select a.* from cms_mng a, (select rent_mng_id, rent_l_cd, max(seq) seq from cms_mng group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.seq=b.seq) g, \n"+
					 "        (select * from code where c_st='0003') h \n"+
					 " where  a.rent_st > '1' and a.rent_dt > to_char(sysdate-100,'YYYYMMDD') \n"+
					 "        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=(b.rent_st+1) \n"+
					 "        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"+
					 "        and c.client_id=d.client_id \n"+
					 "        and c.car_mng_id=f.car_mng_id \n"+
					 "        and a.grt_amt_s < b.grt_amt_s \n"+
					 "        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+) and a.rent_st=e.rent_st(+) \n"+
					 "        and nvl(e.pay_amt,0)=0 \n"+
					 "        and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+) \n"+
					 "        and g.bank_cd=h.code(+) \n"+
					 " order by d.firm_nm  "+ 
					 " ";


		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.rent_mng_id as p_cd1, a.rent_l_cd as p_cd2, a.rent_st as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '36' as p_st1, '연장계약보증금환불' as p_st2, '계좌이체' as p_st3, '' as p_st4, '' as p_st5, \n"+

				"        'client_id' as off_st, a.client_id as off_id, a.firm_nm as off_nm, a.o_tel as off_tel, \n"+
				"        a.ven_code as ven_code, a.firm_nm as ven_name, \n"+

				"        a.rent_dt as est_dt, a.add_amt as amt, \n"+

				"        a.cms_bk as bank_id, \n"+
				"        a.cms_bank as bank_nm, a.cms_acc_no as bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        '연장계약보증금환불 '||a.firm_nm||' ('||a.car_no||')' as p_cont, \n"+

				"        a.a_grt_amt as sub_amt1, a.b_grt_amt as sub_amt2, a.add_amt as sub_amt3, a.est_s_amt sub_amt4, 0 sub_amt5, 0 sub_amt6, \n"+

				"	     a.bus_id2 as buy_user_id, a.s_idno as s_idno, \n"+

				"	     '31100' acct_code, a.cms_dep_nm as  bank_acc_nm, a.cms_bk as bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   ( "+base_query+" ) a, pay_item p \n"+
				" where  a.add_amt >0 \n"+
				"        and '36'=p.p_st1(+) "+
				"	     and a.rent_mng_id=p.p_cd1(+) and a.rent_l_cd=p.p_cd2(+) and a.rent_st=p.p_cd3(+) "+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and a.firm_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.rent_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("3"))	what = "upper(nvl(a.car_no, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.rent_dt";

	    try{
            pstmt = con.prepareStatement(query);
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


		}catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt36List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	37 월렌트정산금환불 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt37List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select  \n"+
				"        '5' as p_way, \n"+
				"        a.rent_mng_id as p_cd1, a.rent_l_cd as p_cd2, a.ext_st as p_cd3, a.ext_tm as p_cd4, '' as p_cd5, \n"+
				"        '31' as p_st1, '해지정산금환불' as p_st2, '계좌이체' as p_st3, '' as p_st4, '' as p_st5, \n"+

				"        'client_id' as off_st, d.client_id as off_id, d.firm_nm as off_nm, d.o_tel as off_tel, \n"+
				"        decode(c.tax_type,'2',nvl(d2.ven_code,d.ven_code),d.ven_code) ven_code, '' ven_name, \n"+

				"        nvl(a.ext_est_dt,b.cls_dt) as est_dt, -(a.ext_s_amt+a.ext_v_amt+nvl(g.grt_suc_r_amt,0)) amt, \n"+

				"        decode(length(nvl(t.re_bank,decode(b.cls_st,'8',o.cms_bk,''))), 0,'', 3,nvl(t.re_bank,decode(b.cls_st,'8',o.cms_bk,'')), 2,nvl(t.re_bank,decode(b.cls_st,'8',o.cms_bk,''))||'0') as bank_id, \n"+  //20171204 해지문서에 있는 계좌만 가져오도록 수정
				"        nvl(o2.nm,decode(b.cls_st,'8',f.cms_bank,'')) as bank_nm, nvl(t.re_acc_no,decode(b.cls_st,'8',f.cms_acc_no,'')) as bank_no, \n"+

			    "        '' a_bank_id, '' a_bank_nm, '' a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        decode(c.car_st,'4','월렌트-')||'해지정산금환불 '||decode(b.cls_st,'8','(매입옵션) ')||d.firm_nm||' '||e.car_no||' '||e.car_nm as p_cont, \n"+

				"        a.ext_s_amt as sub_amt1, a.ext_v_amt as sub_amt2, nvl(g.grt_suc_r_amt,0) as sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, t.reg_id as buy_user_id, decode(d.client_st,'2',substr(TEXT_DECRYPT(d.ssn, 'pw' ) ,1,6), d.enp_no) as s_idno, \n"+

				"	     '25300' acct_code, "+
				"	     nvl(t.re_acc_nm,decode(b.cls_st,'8',f.cms_dep_nm,'')) as  bank_acc_nm, "+

				"		 '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   scd_ext a, cls_cont b, cont c, client d, car_reg e, cls_etc t, pay_item p, client_site d2,\n"+
				"        (select * from code where c_st='0003') o, bnk b2, (select * from code where c_st='0003') o2, "+ // and nm not in ('외환은행','제일은행')
				"	     cont_etc g, (select rent_mng_id, rent_l_cd, use_yn from cont where nvl(use_yn,'Y')='Y') h, \n"+ // S108HRTR00380 데이타로 확인 - 출고전해지, 개시전해지 제외
				"        (select a.* from cms_mng a, (select rent_mng_id, rent_l_cd, max(seq) seq from cms_mng group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.seq=b.seq) f \n"+		
				" where  a.ext_st='4' and (a.ext_s_amt+a.ext_v_amt)<0 and nvl(a.bill_yn,'Y')='Y' \n"+
				"        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
				"        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.car_st ='4' \n"+
				"        and c.client_id=d.client_id \n"+
				"        and c.car_mng_id=e.car_mng_id(+) \n"+
				"        and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) \n"+
				"        and a.rent_mng_id=t.rent_mng_id and a.rent_l_cd=t.rent_l_cd \n"+
				"        and replace(f.cms_bank,'중소기업','기업')=o.nm(+)"+
				"        and t.re_bank=b2.bcode(+) and b2.c_code=o2.code(+) "+
				"        and b.cls_dt > '20090331' \n"+
				"        and '37'=p.p_st1(+) and a.rent_mng_id=p.p_cd1(+) and a.rent_l_cd=p.p_cd2(+) and a.ext_st=p.p_cd3(+) and a.ext_tm=p.p_cd4(+) "+
				"        and c.client_id=d2.client_id(+) and c.r_site=d2.seq(+)"+		
				"        and a.rent_mng_id=g.grt_suc_m_id(+) and a.rent_l_cd=g.grt_suc_l_cd(+) \n"+		
				"        and g.rent_mng_id=h.rent_mng_id(+) and g.rent_l_cd=h.rent_l_cd(+) "+
				"        and a.ext_pay_dt is null \n"+
				"        and a.rent_l_cd not in ('S110KK5R00045','S110KK5R00046','B110HM4L00006','B110HM4L00005') "+		
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and d.firm_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and nvl(a.ext_est_dt,b.cls_dt) like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("1"))	what = "upper(nvl(d.firm_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(b.rent_l_cd, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(e.car_no, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.ext_est_dt";
		
		

	    try{
            pstmt = con.prepareStatement(query);
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


		}catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt37List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	41 법인카드대금 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt41List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null; 
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String base_query = ""; 
		String what = "";
		String s_query = "";
		
		//20210701 2020년05월이후 전북카드 미사용
		/*
		if(pay_off.equals("전북카드") && st_dt.equals("2019-08-25") ) {
			base_query = " select \n"+
					 "        a.cardno, b.pay_day, b.use_s_m, b.use_s_day, b.use_e_m, b.use_e_day, a.buy_dt, a.buy_amt, \n"+
                     "        '20190825' as pay_dt \n"+
					 " from   card_doc a, card b \n"+
					 " where  a.ven_name<>'우리비씨카드(하이패스)' and a.cardno=b.cardno and b.use_e_day is not null \n"+
					 "        and a.cardno<>'0000-0000-0000-0000' AND NVL(a.app_id,'-') NOT IN ('cancel','cance0') \n"+
					 "        and b.card_name not like '%지방세%'\n"+
					 "        and NVL(a.acct_cont,' ') not like '%자동차대금%' "+
			         "        and b.card_kind='전북카드' and nvl(a.r_buy_dt,a.buy_dt) between '20190711' and '20190719' \n"+
			         " ";				
		}else if(pay_off.equals("전북카드") && st_dt.equals("2019-08-15") ) {
			base_query = " select \n"+
					 "        a.cardno, b.pay_day, b.use_s_m, b.use_s_day, b.use_e_m, b.use_e_day, a.buy_dt, a.buy_amt, \n"+
                    "        '20190815' as pay_dt \n"+
					 " from   card_doc a, card b \n"+
					 " where  a.ven_name<>'우리비씨카드(하이패스)' and a.cardno=b.cardno and b.use_e_day is not null \n"+
					 "        and a.cardno<>'0000-0000-0000-0000' AND NVL(a.app_id,'-') NOT IN ('cancel','cance0')\n"+
					 "        and b.card_name not like '%지방세%'\n"+
					 "        and NVL(a.acct_cont,' ') not like '%자동차대금%' "+
			         "        and b.card_kind='전북카드' and nvl(a.r_buy_dt,a.buy_dt) between '20190720' and '20190731' \n"+
			         " ";								
		}else if(pay_off.equals("전북카드") && !st_dt.equals("2019-08-25") && !st_dt.equals("2019-08-15") ) {
			base_query = " select \n"+
					 "        a.cardno, b.pay_day, b.use_s_m, b.use_s_day, b.use_e_m, b.use_e_day, a.buy_dt, a.buy_amt, \n"+
                     "        a.charge_dt as pay_dt \n"+
					 " from   card_doc a, card b \n"+
					 " where  a.ven_name<>'우리비씨카드(하이패스)' and a.cardno=b.cardno and b.use_e_day is not null \n"+
					 "        and a.cardno<>'0000-0000-0000-0000' AND NVL(a.app_id,'-') NOT IN ('cancel','cance0')\n"+
					 "        and b.card_name not like '%지방세%'\n"+
					 "        and NVL(a.acct_cont,' ') not like '%자동차대금%' "+
			         "        and b.card_kind='전북카드' and a.charge_dt is not null  \n"+
			         " ";								
		}else {
		*/
		
			base_query = " select \n"+
					 "        a.cardno, b.pay_day, b.use_s_m, b.use_s_day, b.use_e_m, b.use_e_day, a.buy_dt, a.buy_amt, \n"+
                     "        CASE WHEN a.buy_dt BETWEEN TO_CHAR(ADD_MONTHS(sysdate,DECODE(b.use_s_m,'1',-2,'2',-1,0)),'YYYYMM')||b.use_s_day AND TO_CHAR(ADD_MONTHS(sysdate,DECODE(b.use_e_m,'2',-1,0)),'YYYYMM')||b.use_e_day THEN TO_CHAR(SYSDATE,'YYYYMM')||b.pay_day\r\n" + 
                     "             WHEN a.buy_dt BETWEEN TO_CHAR(ADD_MONTHS(sysdate,DECODE(b.use_s_m,'1',-2,'2',-1,0)+1),'YYYYMM')||b.use_s_day AND TO_CHAR(ADD_MONTHS(sysdate,DECODE(b.use_e_m,'2',-1,0)+1),'YYYYMM')||b.use_e_day THEN TO_CHAR(ADD_MONTHS(SYSDATE,+1),'YYYYMM')||b.pay_day\r\n" + 
                     "             WHEN a.buy_dt BETWEEN TO_CHAR(ADD_MONTHS(sysdate,DECODE(b.use_s_m,'1',-2,'2',-1,0)+2),'YYYYMM')||b.use_s_day AND TO_CHAR(ADD_MONTHS(sysdate,DECODE(b.use_e_m,'2',-1,0)+2),'YYYYMM')||b.use_e_day THEN TO_CHAR(ADD_MONTHS(SYSDATE,+2),'YYYYMM')||b.pay_day\r\n" +
                     "             WHEN a.buy_dt BETWEEN TO_CHAR(ADD_MONTHS(sysdate,DECODE(b.use_s_m,'1',-2,'2',-1,0)+3),'YYYYMM')||b.use_s_day AND TO_CHAR(ADD_MONTHS(sysdate,DECODE(b.use_e_m,'2',-1,0)+3),'YYYYMM')||b.use_e_day THEN TO_CHAR(ADD_MONTHS(SYSDATE,+3),'YYYYMM')||b.pay_day\r\n" +
                     "             WHEN a.buy_dt BETWEEN TO_CHAR(ADD_MONTHS(sysdate,DECODE(b.use_s_m,'1',-2,'2',-1,0)-1),'YYYYMM')||b.use_s_day AND TO_CHAR(ADD_MONTHS(sysdate,DECODE(b.use_e_m,'2',-1,0)-1),'YYYYMM')||b.use_e_day THEN TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||b.pay_day\r\n" + 
                     "             WHEN a.buy_dt BETWEEN TO_CHAR(ADD_MONTHS(sysdate,DECODE(b.use_s_m,'1',-2,'2',-1,0)-2),'YYYYMM')||b.use_s_day AND TO_CHAR(ADD_MONTHS(sysdate,DECODE(b.use_e_m,'2',-1,0)-2),'YYYYMM')||b.use_e_day THEN TO_CHAR(ADD_MONTHS(SYSDATE,-2),'YYYYMM')||b.pay_day\r\n" +
                     "             WHEN nvl(a.r_buy_dt,a.buy_dt) > DECODE(b.use_e_day,'31',TO_CHAR(last_day(ADD_MONTHS(TO_date(nvl(a.r_buy_dt,a.buy_dt),'YYYYMMDD'),DECODE(b.use_e_m,'2',-1,'3',-2,0))),'YYYYMMDD'),TO_CHAR(ADD_MONTHS(TO_date(nvl(a.r_buy_dt,a.buy_dt),'YYYYMMDD'),DECODE(b.use_e_m,'2',-1,'3',-2,0)),'YYYYMM')||b.use_e_day) THEN TO_CHAR(ADD_MONTHS(TO_date(nvl(a.r_buy_dt,a.buy_dt),'YYYYMMDD'),1),'YYYYMM')||b.pay_day \r\n" + 
                     "             ELSE SUBSTR(nvl(a.r_buy_dt,a.buy_dt),1,6)||b.pay_day END pay_dt  \n"+
					 " from   card_doc a, card b \n"+
					 " where  a.ven_name<>'우리비씨카드(하이패스)' and a.cardno=b.cardno and b.use_e_day is not null \n"+
					 "        and a.cardno<>'0000-0000-0000-0000' AND NVL(a.app_id,'-') NOT IN ('cancel','cance0')\n"+
					 "        and a.buy_dt >= '20100801' and a.buy_dt < '20210701' and b.card_name not like '%지방세%'\n"+
					 "        and nvl(a.reg_dt,a.buy_dt) not in ('20120402','20120403')"+ 
					 "        and NVL(a.acct_cont,' ') not like '%자동차대금%' "+
			         " union all "+					 
			         " select \n"+
					 "        a.cardno, b.pay_day, b.use_s_m, b.use_s_day, b.use_e_m, b.use_e_day, a.buy_dt, a.buy_amt, \n"+
                     "        F_getCardRtnDay(a.cardno, a.buy_dt) pay_dt  \n"+
					 " from   card_doc a, card b \n"+
					 " where  a.ven_name<>'우리비씨카드(하이패스)' and a.cardno=b.cardno and b.use_e_day is not null \n"+
					 "        and a.cardno<>'0000-0000-0000-0000' AND NVL(a.app_id,'-') NOT IN ('cancel','cance0')\n"+
					 "        and a.buy_dt >= '20210701' and b.card_name not like '%지방세%'\n"+
					 "        and nvl(a.reg_dt,a.buy_dt) not in ('20120402','20120403')"+ 
					 "        and NVL(a.acct_cont,' ') not like '%자동차대금%' "+					 
			         " union all "+ 
		             " select \n"+
					 "        a.cardno, b.pay_day, b.use_s_m, b.use_s_day, b.use_e_m, b.use_e_day, a.buy_dt, a.buy_amt, \n"+
					 "        substr(a.reg_dt,1,6)||b.pay_day as pay_dt \n"+
					 " from   card_doc a, card b \n"+
					 " where  a.ven_name='우리비씨카드(하이패스)' and a.cardno=b.cardno and b.use_e_day is not null  and nvl(b.card_paid,'0')<>'7' \n"+
					 "        and a.cardno<>'0000-0000-0000-0000' AND NVL(a.app_id,'-') NOT IN ('cancel','cance0') \n"+
					 "        and a.buy_dt >= '20100801' and b.card_name not like '%지방세%'\n"+
					 "        and a.reg_dt not in ('20120402','20120403')"+ 
					 "        and NVL(a.acct_cont,' ') not like '%자동차대금%' "+
					 " ";			

		//} 
		
		query = " select   \n"+
				"        '4' as p_way, \n"+
				"        a.est_dt as p_cd1, a.cardno as p_cd2, '' as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '41' as p_st1, '법인카드대금' as p_st2, '자동이체' as p_st3, b.card_name as p_st4, '' as p_st5, \n"+

				"        'com_code' as off_st, b.com_code as off_id, b.com_name as off_nm, '' off_tel, \n"+
				"        b.com_code as ven_code, b.com_name as ven_name, \n"+

				"        a.est_dt, a.est_amt as amt, \n"+

			    "        '' bank_id, '' bank_nm, '' bank_no, \n"+

				"		 '' a_bank_id, \n"+
				"	     '' as a_bank_nm, b.acc_no as a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        substr(a.est_dt,5,2)||'월 카드대금 '||b.card_name as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, '' s_idno, \n"+

				"	     '25300' acct_code, b.com_name as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   ( select cardno, pay_dt as est_dt, sum(buy_amt) est_amt \n"+
				"		   from ( "+base_query+" ) \n"+
				"          group by cardno, pay_dt \n"+
				"        ) a, "+
				"        card b, pay_item p \n"+
				" where  a.cardno=b.cardno \n"+
				"        and '41'=p.p_st1(+) and a.est_dt=p.p_cd1(+) and a.cardno=p.p_cd2(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";
		
		if(pay_off.equals("전북카드") && (st_dt.equals("2019-08-25") || st_dt.equals("2019-08-15")) ) {
			
		}else {

			if(!pay_off.equals(""))	query += " and b.card_kind||b.card_name like '%"+pay_off+"%' \n";

			if(!st_dt.equals(""))   query += " and a.est_dt like replace('"+st_dt+"%', '-','')";
		}

		if(s_kd.equals("3"))	what = "upper(nvl(b.card_name, ' '))";

			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.est_dt, a.cardno";


	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt41List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	42 법인카드대금(지방세20일결재) 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt42List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String base_query = "";
		String what = "";

		base_query = " select \n"+
					 "        a.cardno, b.pay_day, b.use_s_m, b.use_s_day, b.use_e_m, b.use_e_day, a.buy_dt, a.buy_amt, \n"+
					 "        decode(sign('15'-substr(a.buy_dt,7,2)),-1,to_char(add_months(to_date(a.buy_dt,'YYYYMMDD'),1),'YYYYMM')||'05',substr(a.buy_dt,1,6)||'20') pay_dt \n"+
					 " from   card_doc a, card b \n"+
					 " where  a.cardno=b.cardno  and nvl(b.card_paid,'0')<>'7' \n"+
					 "        and a.cardno not in ('0000-0000-0000-0000','9410-8531-0252-3300','9410-8523-7439-8400') AND NVL(a.app_id,'-') NOT IN ('cancel','cance0')\n"+
					 "        and a.buy_dt >= '20100801' and b.card_name like '%지방세%' \n"+
					 "        and sign('15'-substr(a.buy_dt,7,2)) in (0,1) \n"+
					 "        and a.reg_dt not in ('20120402','20120403')"+ 	
					 " ";

		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.est_dt as p_cd1, a.cardno as p_cd2, '' as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '42' as p_st1, '법인카드대금(지방세20일결재)' as p_st2, '계좌이체' as p_st3, b.card_name as p_st4, '' as p_st5, \n"+

				"        'com_code' as off_st, b.com_code as off_id, b.com_name as off_nm, '' off_tel, \n"+
				"        b.com_code as ven_code, b.com_name as ven_name, \n"+

				"        a.est_dt, a.est_amt as amt, \n"+

			    "        '' bank_id, '' bank_nm, '' bank_no, \n"+

				"		 '' a_bank_id, \n"+
				"	     '' as a_bank_nm, b.acc_no as a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        substr(a.est_dt,5,2)||'월 지방세 카드대금 '||b.card_name as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, '' s_idno, \n"+

				"	     '25300' acct_code, b.com_name as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   ( select cardno, pay_dt as est_dt, sum(buy_amt) est_amt \n"+
				"		   from ( "+base_query+" ) \n"+
				"          group by cardno, pay_dt \n"+
				"        ) a, "+
				"        card b, pay_item p \n"+
				" where  a.cardno=b.cardno \n"+
				"        and '42'=p.p_st1(+) and a.est_dt=p.p_cd1(+) and a.cardno=p.p_cd2(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.card_kind||b.card_name like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.est_dt like replace('"+st_dt+"%', '-','')";


		query += " order by a.est_dt";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt42List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	43 법인카드대금(지방세익월5일결재) 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt43List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String base_query = "";
		String what = "";

		base_query = " select \n"+
					 "        a.cardno, b.pay_day, b.use_s_m, b.use_s_day, b.use_e_m, b.use_e_day, a.buy_dt, a.buy_amt, \n"+
					 "        decode(sign('15'-substr(a.buy_dt,7,2)),-1,to_char(add_months(to_date(a.buy_dt,'YYYYMMDD'),1),'YYYYMM')||'05',substr(a.buy_dt,1,6)||'20') pay_dt \n"+
					 " from   card_doc a, card b \n"+
					 " where  a.cardno=b.cardno  and nvl(b.card_paid,'0')<>'7' \n"+
					 "        and a.cardno not in ('0000-0000-0000-0000','9410-8531-0252-3300','9410-8523-7439-8400') AND NVL(a.app_id,'-') NOT IN ('cancel','cance0')\n"+
					 "        and a.buy_dt >= '20100801' and b.card_name like '%지방세%' \n"+
					 "        and sign('15'-substr(a.buy_dt,7,2)) in (-1) \n"+
					 "        and a.reg_dt not in ('20120402','20120403')"+ 	
					 " ";

		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.est_dt as p_cd1, a.cardno as p_cd2, '' as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '43' as p_st1, '법인카드대금(지방세익월5일결재)' as p_st2, '계좌이체' as p_st3, b.card_name as p_st4, '' as p_st5, \n"+

				"        'com_code' as off_st, b.com_code as off_id, b.com_name as off_nm, '' off_tel, \n"+
				"        b.com_code as ven_code, b.com_name as ven_name, \n"+

				"        a.est_dt, a.est_amt as amt, \n"+

			    "        '' bank_id, '' bank_nm, '' bank_no, \n"+

				"		 '' a_bank_id, \n"+
				"	     '' as a_bank_nm, b.acc_no as a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        substr(a.est_dt,5,2)||'월 지방세 카드대금 '||b.card_name as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, '' s_idno, \n"+

				"	     '25300' acct_code, b.com_name as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   ( select cardno, pay_dt as est_dt, sum(buy_amt) est_amt \n"+
				"		   from ( "+base_query+" ) \n"+
				"          group by cardno, pay_dt \n"+
				"        ) a, "+
				"        card b, pay_item p \n"+
				" where  a.cardno=b.cardno \n"+
				"        and '43'=p.p_st1(+) and a.est_dt=p.p_cd1(+) and a.cardno=p.p_cd2(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.card_kind||b.card_name like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.est_dt = replace('"+st_dt+"', '-','')";


		query += " order by a.est_dt";

	    try{
            pstmt = con.prepareStatement(query);
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



        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt43List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	44 법인카드대금(자동차대금) 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt44List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String base_query = "";
		String what = "";


		base_query = " select \n"+
					 "        b.cardno, b.pay_day, b.use_s_m, b.use_s_day, b.use_e_m, b.use_e_day, a.p_pay_dt buy_dt, c.i_amt as buy_amt, \n"+
				
				     "        decode(b.card_kind_cd,'0016', f_getvalddt(a.p_pay_dt,nvl(d.give_day,3)), \n"+ //우리비씨
					 "                              '0008', f_getvalddt(a.p_pay_dt,nvl(d.give_day,3)), \n"+ //부산비씨
					 "                              '0002', f_getvalddt(a.p_pay_dt,nvl(d.give_day,4)), \n"+ //국민카드
					 "                              '0011', F_getAfterDay(a.p_pay_dt,nvl(d.give_day,4)), \n"+ //삼성카드
					 "                              '0022', TO_CHAR(TO_DATE(a.p_pay_dt,'YYYYMMDD')+decode(TO_CHAR(TO_DATE(a.p_pay_dt,'YYYYMMDD'),'D'), 2,9, 3,8, 4,7, 5,6, 6,5),'YYYYMMDD'), \n"+ //현대카드
					 "                              '0001', f_getvalddt(a.p_pay_dt,nvl(d.give_day,3)), \n"+ //광주카드
					 "                              '0012', f_getvalddt(a.p_pay_dt,nvl(d.give_day,1)), \n"+ //신한카드
					 "                              '0007', f_getvalddt(a.p_pay_dt,nvl(d.give_day,2)), \n"+ //롯데카드
					 "                              '0017', f_getvalddt(a.p_pay_dt,nvl(d.give_day,3)), \n"+ //전북카드
				     
                     "        DECODE(a.card_no,'4101-2099-9988-5475',f_getvalddt(a.p_pay_dt,nvl(d.give_day,3)), \n"+ //우리비씨  f_getvalddt(a.p_pay_dt,3)
                     "                         '9435-2017-0060-9548',f_getvalddt(a.p_pay_dt,nvl(d.give_day,3)), \n"+ //우리비씨
                     "                         '9435-2017-0476-3432',f_getvalddt(a.p_pay_dt,nvl(d.give_day,3)), \n"+ //우리비씨
                     "                         '9435-2017-1000-5190',F_getCardRtnDay(a.card_no, a.p_pay_dt), \n"+ //우리비씨 후불카드
                     "                         '5585-3211-1128-0998',f_getvalddt(a.p_pay_dt,nvl(d.give_day,3)), \n"+ //부산비씨
                     "                         '4265-8691-0190-9612',f_getvalddt(a.p_pay_dt,nvl(d.give_day,1)), \n"+ //국민카드
                     "                         '9410-8521-7513-7700',F_getAfterDay(a.p_pay_dt,nvl(d.give_day,4)), \n"+ //삼성카드 -> 20170712 +2->+4 변경					 
                     "                         '9410-8523-1417-2600',F_getAfterDay(a.p_pay_dt,nvl(d.give_day,4)), \n"+ //삼성카드 -> 20170712 +2->+4 변경					 
                     "                         '4327-6800-0000-0122',F_getAfterDay(a.p_pay_dt,nvl(d.give_day,4)), \n"+ //삼성카드 -> 20190819
                     "                         '9490-2200-0201-3706',TO_CHAR(TO_DATE(a.p_pay_dt,'YYYYMMDD')+decode(TO_CHAR(TO_DATE(a.p_pay_dt,'YYYYMMDD'),'D'), 2,9, 3,8, 4,7, 5,6, 6,5),'YYYYMMDD'), \n"+ //현대카드
                     "                         '9490-2200-0201-3904',TO_CHAR(TO_DATE(a.p_pay_dt,'YYYYMMDD')+decode(TO_CHAR(TO_DATE(a.p_pay_dt,'YYYYMMDD'),'D'), 2,9, 3,8, 4,7, 5,6, 6,5),'YYYYMMDD'), \n"+
                     "                         '9490-2200-0201-3805',TO_CHAR(TO_DATE(a.p_pay_dt,'YYYYMMDD')+decode(TO_CHAR(TO_DATE(a.p_pay_dt,'YYYYMMDD'),'D'), 2,9, 3,8, 4,7, 5,6, 6,5),'YYYYMMDD'), \n"+
                     "                         '9530-0128-0890-0679',f_getvalddt(a.p_pay_dt,nvl(d.give_day,2)), \n"+ //광주카드 -> 20170929 +3->+2
                     "                         '9530-0181-3014-3557',f_getvalddt(a.p_pay_dt,nvl(d.give_day,2)), \n"+ //광주카드
                     "                         '9410-6440-9632-7739',f_getvalddt(a.p_pay_dt,nvl(d.give_day,1)), \n"+ //신한카드
                     "                         '9409-2000-2060-6665',f_getvalddt(a.p_pay_dt,nvl(d.give_day,2)), \n"+ //롯데카드
                     "                         '9410-4991-6395-8688',f_getvalddt(a.p_pay_dt,nvl(d.give_day,2)), \n"+ //국민선불카드(당일->3일->2일)
                     "                         '5585-2693-6819-1881',f_getvalddt(a.p_pay_dt,nvl(d.give_day,2)), \n"+ //국민선불카드(당일->3일->2일)
                     "                         '5535-3109-0001-4982',f_getvalddt(a.p_pay_dt,nvl(d.give_day,3)), \n"+ //전북카드
                     "                         '5535-3109-0005-0853',f_getvalddt(a.p_pay_dt,nvl(d.give_day,3)), \n"+ //전북카드                     
					 "        		decode(sign(b.use_e_day-substr(a.p_pay_dt,7,2)),-1,to_char(add_months(to_date(a.p_pay_dt,'YYYYMMDD'),2),'YYYYMM')||decode(length(b.pay_day),1,'0','')||b.pay_day,  \n"+
                     "               		                                           to_char(add_months(to_date(a.p_pay_dt,'YYYYMMDD'),1),'YYYYMM')||decode(length(b.pay_day),1,'0','')||b.pay_day   \n"+
                     "               ) \n"+
                     "        )) pay_dt 	 \n"+
					 " from   pay a, card b, pay_item c, card_cont d, (select cardno, max(seq) seq from card_cont group by cardno) e \n"+
					 " where  "+
					 "	      a.reqseq > '20181231' and a.reqseq < '20210701' and c.p_gubun in ('01','07','08') \n"+//자동차대금
					 "        and a.card_no=b.cardno and a.reqseq=c.reqseq and b.cardno=d.cardno and d.cardno=e.cardno and d.seq=e.seq and nvl(b.card_paid,'0')<>'7' \n"+
					 " union all"+
					 " select \n"+
					 "        b.cardno, b.pay_day, b.use_s_m, b.use_s_day, b.use_e_m, b.use_e_day, a.p_pay_dt buy_dt, c.i_amt as buy_amt, \n"+				
				     "        F_getAfterDay(F_getCardRtnDay(b.cardno, a.p_pay_dt),0) pay_dt \n"+ //우리비씨					 
					 " from   pay a, card b, pay_item c, card_cont d, (select cardno, max(seq) seq from card_cont group by cardno) e \n"+
					 " where  "+
					 "	      a.reqseq >= '20210701' and c.p_gubun in ('01','07','08') \n"+//자동차대금
					 "        and a.card_no=b.cardno and a.reqseq=c.reqseq and b.cardno=d.cardno and d.cardno=e.cardno and d.seq=e.seq and nvl(b.card_paid,'0')<>'7' \n"+
					 " ";
		
		// 20210827 롯데카드 후불카드 변경으로 계좌이체->자동이체 
		
		query = " select  \n"+
				"        decode(b.card_kind_cd,'0011','5','0007','4','4') as p_way, \n"+ //삼성카드,롯데카드=5
				"        a.est_dt as p_cd1, a.cardno as p_cd2, a.buy_dt as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '44' as p_st1, '법인카드대금(자동차대금)' as p_st2, "+
				"        decode(b.card_kind_cd,'0011','계좌이체','0007','자동이체','자동이체')  as p_st3, \n"+
			    "        b.card_name as p_st4, '' as p_st5, \n"+

				"        'com_code' as off_st, "+
				"	     decode(b.card_kind_cd,'0001','996214',b.com_code) as off_id, "+ //광주카드 996214
				"	     decode(b.card_kind_cd,'0001','광주카드선불(0679)차량대금',b.com_name) as off_nm, "+ //광주카드 광주카드선불(0679)차량대금
				"	     '' off_tel, \n"+

				"        decode(b.card_kind_cd,'0001','996214',b.com_code) as ven_code, "+ //광주카드 996214
				"	     decode(b.card_kind_cd,'0001','광주카드선불(0679)차량대금',b.com_name) as ven_name, \n"+ //광주카드 광주카드선불(0679)차량대금

				"        a.est_dt, a.est_amt as amt, \n"+

			    //"      decode(b.card_kind_cd,'0011','026','0012','026','0007','','') as bank_id, "+
				//"	     decode(b.card_kind_cd,'0011','신한은행','0012','신한은행','0007','','') as bank_nm, "+ //삼성카드,신한카드=신한은행, 롯데카드=KEB하나은행 117-13-63701-9
				//"	     decode(b.card_kind_cd,'0011',decode(a.cardno,'4327-6800-0000-0122','562-13-423346720','300-05-016904'),'0012','56202200894865','0007','','') as bank_no, \n"+
				
				//삼성카드 4327-6800-0000-0122 는 가상계좌 신한 562-13-423346720
				
				//20211012 모두 후불카드 변경하면서 입금정보 불필요해짐 
			    "        '' as bank_id, "+
				"	     '' as bank_nm, "+ //삼성카드,신한카드=신한은행, 롯데카드=KEB하나은행 117-13-63701-9
				"	     '' as bank_no, \n"+

				
				"        decode(b.card_kind_cd,'0011','026','0007','026','') as a_bank_id, \n"+
				"	     decode(b.card_kind_cd,'0011','신한은행','0007','신한은행','') as a_bank_nm, \n"+
				"	     decode(b.card_kind_cd,'0011','140-004-023871','0007','140-004-023871',b.acc_no) as a_bank_no, \n"+

				"        decode(b.card_kind_cd,'0011','003671','') as card_id, \n"+
				"	     decode(b.card_kind_cd,'0011','삼성카드','') as card_nm, \n"+
				"	     decode(b.card_kind_cd,'0011',a.cardno,'') as card_no, \n"+

				"        a.buy_dt||' '||substr(a.est_dt,5,2)||'월 자동차대금 카드대금 '||b.card_name as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, '' s_idno, \n"+

				"	     '25300' acct_code, b.com_name as bank_acc_nm, "+

				//"	     decode(b.card_kind_cd,'0011','026','0007','','') as bank_cms_bk, "+
				"	     '' as bank_cms_bk, "+
				"	     decode(b.card_kind_cd,'0011','026','0007','026','') as a_bank_cms_bk \n"+

				" from   ( select cardno, sum(buy_amt) est_amt, buy_dt, "+
				"                 decode(cardno||buy_dt,'4327-6800-0000-012220210128','20210208',pay_dt) as est_dt \n"+ 
				"		   from ( "+base_query+" ) \n"+
				"          group by cardno, pay_dt, buy_dt \n"+
				"        ) a, "+
				"        card b, pay_item p \n"+
				" where  a.cardno=b.cardno \n"+
				"        and '44'=p.p_st1(+) and a.cardno=p.p_cd2(+) and a.buy_dt=p.p_cd3(+) "+
				"        and a.est_dt > '20120924' "+
				" ";
				
		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.card_kind||b.card_name like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.est_dt like replace('"+st_dt+"%', '-','')";


		query += " order by a.est_dt";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt44List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	46 법인카드대금(선불기타) 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt46List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String base_query = "";
		String what = "";


		base_query = " select \n"+
					 "        a.off_nm, b.cardno, b.pay_day, b.use_s_m, b.use_s_day, b.use_e_m, b.use_e_day, a.p_pay_dt buy_dt, c.i_amt as buy_amt, \n"+
				
				     "        decode(b.card_kind_cd,'0016', f_getvalddt(a.p_pay_dt,nvl(d.give_day,3)), \n"+ //우리비씨
					 "                              '0008', f_getvalddt(a.p_pay_dt,nvl(d.give_day,3)), \n"+ //부산비씨
					 "                              '0002', f_getvalddt(a.p_pay_dt,nvl(d.give_day,4)), \n"+ //국민카드
					 "                              '0011', F_getAfterDay(a.p_pay_dt,nvl(d.give_day,4)), \n"+ //삼성카드
					 "                              '0022', TO_CHAR(TO_DATE(a.p_pay_dt,'YYYYMMDD')+decode(TO_CHAR(TO_DATE(a.p_pay_dt,'YYYYMMDD'),'D'), 2,9, 3,8, 4,7, 5,6, 6,5),'YYYYMMDD'), \n"+ //현대카드
					 "                              '0001', f_getvalddt(a.p_pay_dt,nvl(d.give_day,3)), \n"+ //광주카드
					 "                              '0012', f_getvalddt(a.p_pay_dt,nvl(d.give_day,1)), \n"+ //신한카드
					 "                              '0007', f_getvalddt(a.p_pay_dt,nvl(d.give_day,2)), \n"+ //롯데카드
					 "                              '0017', f_getvalddt(a.p_pay_dt,nvl(d.give_day,3)), \n"+ //전북카드
					 
                     "        DECODE(a.card_no,'4101-2099-9988-5475',f_getvalddt(a.p_pay_dt,nvl(d.give_day,3)), \n"+ //우리비씨  f_getvalddt(a.p_pay_dt,3)
                     "                         '9435-2017-0060-9548',f_getvalddt(a.p_pay_dt,nvl(d.give_day,3)), \n"+ //우리비씨
                     "                         '9435-2017-0476-3432',f_getvalddt(a.p_pay_dt,nvl(d.give_day,3)), \n"+ //우리비씨
                     "                         '9435-2017-1000-5190',F_getCardRtnDay(a.card_no, a.p_pay_dt), \n"+ //우리비씨 후불카드
                     "                         '5585-3211-1128-0998',f_getvalddt(a.p_pay_dt,nvl(d.give_day,3)), \n"+ //부산비씨
                     "                         '4265-8691-0190-9612',f_getvalddt(a.p_pay_dt,nvl(d.give_day,1)), \n"+ //국민카드
                     "                         '9410-8521-7513-7700',F_getAfterDay(a.p_pay_dt,nvl(d.give_day,4)), \n"+ //삼성카드 -> 20170712 +2->+4 변경					 
                     "                         '9410-8523-1417-2600',F_getAfterDay(a.p_pay_dt,nvl(d.give_day,4)), \n"+ //삼성카드 -> 20170712 +2->+4 변경					 
                     "                         '4327-6800-0000-0122',F_getAfterDay(a.p_pay_dt,nvl(d.give_day,4)), \n"+ //삼성카드 -> 20190819
                     "                         '9490-2200-0201-3706',TO_CHAR(TO_DATE(a.p_pay_dt,'YYYYMMDD')+decode(TO_CHAR(TO_DATE(a.p_pay_dt,'YYYYMMDD'),'D'), 2,9, 3,8, 4,7, 5,6, 6,5),'YYYYMMDD'), \n"+ //현대카드
                     "                         '9490-2200-0201-3904',TO_CHAR(TO_DATE(a.p_pay_dt,'YYYYMMDD')+decode(TO_CHAR(TO_DATE(a.p_pay_dt,'YYYYMMDD'),'D'), 2,9, 3,8, 4,7, 5,6, 6,5),'YYYYMMDD'), \n"+
                     "                         '9490-2200-0201-3805',TO_CHAR(TO_DATE(a.p_pay_dt,'YYYYMMDD')+decode(TO_CHAR(TO_DATE(a.p_pay_dt,'YYYYMMDD'),'D'), 2,9, 3,8, 4,7, 5,6, 6,5),'YYYYMMDD'), \n"+
                     "                         '9530-0128-0890-0679',f_getvalddt(a.p_pay_dt,nvl(d.give_day,2)), \n"+ //광주카드 -> 20170929 +3->+2
                     "                         '9530-0181-3014-3557',f_getvalddt(a.p_pay_dt,nvl(d.give_day,2)), \n"+ //광주카드
                     "                         '9410-6440-9632-7739',f_getvalddt(a.p_pay_dt,nvl(d.give_day,1)), \n"+ //신한카드
                     "                         '9409-2000-2060-6665',f_getvalddt(a.p_pay_dt,nvl(d.give_day,2)), \n"+ //롯데카드
                     "                         '9410-4991-6395-8688',f_getvalddt(a.p_pay_dt,nvl(d.give_day,2)), \n"+ //국민선불카드(당일->3일->2일)
                     "                         '5585-2693-6819-1881',f_getvalddt(a.p_pay_dt,nvl(d.give_day,2)), \n"+ //국민선불카드(당일->3일->2일)                     
                     "                         '5535-3109-0001-4982',f_getvalddt(a.p_pay_dt,nvl(d.give_day,3)), \n"+ //전북카드
                     "                         '5535-3109-0005-0853',f_getvalddt(a.p_pay_dt,nvl(d.give_day,3)), \n"+ //전북카드                     
					 "        		decode(sign(b.use_e_day-substr(a.p_pay_dt,7,2)),-1,to_char(add_months(to_date(a.p_pay_dt,'YYYYMMDD'),2),'YYYYMM')||decode(length(b.pay_day),1,'0','')||b.pay_day,  \n"+
                     "               		                                           to_char(add_months(to_date(a.p_pay_dt,'YYYYMMDD'),1),'YYYYMM')||decode(length(b.pay_day),1,'0','')||b.pay_day   \n"+
                     "               ) \n"+
                     "        )) pay_dt 	 \n"+
					 " from   pay a, card b, pay_item c, card_cont d, (select cardno, max(seq) seq from card_cont group by cardno) e \n"+
					 " where  "+
					 "	      a.reqseq > '20181231' and a.reqseq < '20210701' and c.p_gubun not in ('01','44','07') \n"+//자동차대금,법인카드대금(자동차대금) 제외
					 "        and a.card_no=b.cardno and a.reqseq=c.reqseq  and b.cardno=d.cardno and d.cardno=e.cardno and d.seq=e.seq and nvl(b.card_paid,'0')<>'7'  \n"+
					 "        and b.card_name not like '%지방세%' \n"+ //지방세 제외
					 "        and a.off_nm not like '%지방세%' \n"+ //지방세 제외
					 " union all "+
					 " select \n"+
					 "        a.off_nm, b.cardno, b.pay_day, b.use_s_m, b.use_s_day, b.use_e_m, b.use_e_day, a.p_pay_dt buy_dt, c.i_amt as buy_amt, \n"+				
				     "        F_getAfterDay(F_getCardRtnDay(b.cardno, a.p_pay_dt),0) pay_dt  \n"+
					 " from   pay a, card b, pay_item c, card_cont d, (select cardno, max(seq) seq from card_cont group by cardno) e \n"+
					 " where  "+
					 "	      a.reqseq >= '20210701' and c.p_gubun not in ('01','44','07') \n"+//자동차대금,법인카드대금(자동차대금) 제외
					 "        and a.card_no=b.cardno and a.reqseq=c.reqseq  and b.cardno=d.cardno and d.cardno=e.cardno and d.seq=e.seq and nvl(b.card_paid,'0')<>'7'  \n"+
					 "        and b.card_name not like '%지방세%' \n"+ //지방세 제외
					 "        and a.off_nm not like '%지방세%' \n"+ //지방세 제외
					 " ";

		query = " select  \n"+
				"        decode(b.card_kind_cd,'0011','5','4') as p_way, \n"+
				"        a.est_dt as p_cd1, a.cardno as p_cd2, '' as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '46' as p_st1, '법인카드대금(선불기타)' as p_st2, \n"+
			    "        decode(b.card_kind_cd,'0011','계좌이체','자동이체') as p_st3, \n"+
			    "        b.card_name as p_st4, '' as p_st5, \n"+

				"        'com_code' as off_st, b.com_code as off_id, b.com_name as off_nm, '' off_tel, \n"+
				"        b.com_code as ven_code, b.com_name as ven_name, \n"+

				"        a.est_dt, a.est_amt as amt, \n"+
				
			    "        decode(b.card_kind_cd,'0011','026','0012','026','0007','081','') as bank_id, "+
				"	     decode(b.card_kind_cd,'0011','신한은행','0012','신한은행','0007','KEB하나은행','') as bank_nm, "+ //삼성카드,신한카드=신한은행, 롯데카드=하나은행
				"	     decode(b.card_kind_cd,'0011','300-05-016904','0012','56202200894865','0007','117-13-63701-9','') as bank_no, \n"+

				"        decode(b.card_kind_cd,'0011','026','0007','026','') as a_bank_id, \n"+
				"	     decode(b.card_kind_cd,'0011','신한은행','0007','신한은행','') as a_bank_nm, \n"+
				"	     decode(b.card_kind_cd,'0011','140-004-023871','0007','140-004-023871',b.acc_no) as a_bank_no, \n"+

				"        decode(b.card_kind_cd,'0011','003671','') as card_id, \n"+
				"	     decode(b.card_kind_cd,'0011','삼성카드','') as card_nm, \n"+
				"	     decode(b.card_kind_cd,'0011',a.cardno,'') as card_no, \n"+				

				"        a.off_nm||' '||a.buy_dt||' '||substr(a.est_dt,5,2)||'월 선불카드대금 '||b.card_name as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, '' s_idno, \n"+

				"	     '25300' acct_code, b.com_name as bank_acc_nm, \n"+

				"	     decode(b.card_kind_cd,'0011','026','0007','081','') as bank_cms_bk, "+
				"	     decode(b.card_kind_cd,'0011','026','0007','026','') as a_bank_cms_bk \n"+

				" from   ( select off_nm, cardno, pay_dt as est_dt, sum(buy_amt) est_amt, min(buy_dt) buy_dt \n"+
				"		   from ( "+base_query+" ) \n"+
				"          group by off_nm, cardno, pay_dt \n"+
				"        ) a, "+
				"        card b, pay_item p \n"+
				" where  a.cardno=b.cardno \n"+
				"        and '46'=p.p_st1(+) and a.est_dt=p.p_cd1(+) and a.cardno=p.p_cd2(+) and a.est_amt=p.i_amt(+) "+
				"        and a.est_dt > '20111215' "+
				" "; 

		if(!yet_again.equals("Y"))	query += " and a.est_amt<>nvl(p.i_amt,0)\n";

		if(!pay_off.equals(""))	query += " and b.card_kind||b.card_name like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.est_dt like replace('"+st_dt+"%', '-','')";


		query += " order by a.est_dt";

	    try{
            pstmt = con.prepareStatement(query);
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


        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt46List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	42 법인카드대금(지방세23일결재) 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt45List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String base_query = "";
		String what = "";

		base_query = " select \n"+
					 "        a.cardno, b.pay_day, b.use_s_m, b.use_s_day, b.use_e_m, b.use_e_day, a.buy_dt, a.buy_amt, \n"+
					 "        to_char(add_months(to_date(a.buy_dt,'YYYYMMDD'),decode(b.use_s_m,1,2,1)),'YYYYMM')||'23' pay_dt \n"+
					 " from   card_doc a, card b \n"+
					 " where  a.cardno=b.cardno  and nvl(b.card_paid,'0')<>'7' \n"+
					 "        and a.cardno not in ('0000-0000-0000-0000','9410-8531-0252-3300','9410-8523-7439-8400') AND NVL(a.app_id,'-') NOT IN ('cancel','cance0')\n"+
					 "        and a.buy_dt >= '20100801' "+
					 "	      and (b.card_name like '%지방세%' or a.ven_name ='인천계양구청(지방세카드)')\n"+
					 "        and b.pay_day='23' "+  
					 "        and b.use_s_day='1' \n"+
					 "        and a.reg_dt not in ('20120402','20120403')"+ 	
					 " ";

		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.est_dt as p_cd1, a.cardno as p_cd2, '' as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '45' as p_st1, '법인카드대금(지방세23일결재)' as p_st2, '계좌이체' as p_st3, b.card_name as p_st4, '' as p_st5, \n"+

				"        'com_code' as off_st, b.com_code as off_id, b.com_name as off_nm, '' off_tel, \n"+
				"        b.com_code as ven_code, b.com_name as ven_name, \n"+

				"        a.est_dt, a.est_amt as amt, \n"+

			    "        '' bank_id, '' bank_nm, '' bank_no, \n"+

				"		 '' a_bank_id, \n"+
				"	     '' as a_bank_nm, b.acc_no as a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        substr(a.est_dt,5,2)||'월 지방세 카드대금 '||b.card_name as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, '' s_idno, \n"+

				"	     '25300' acct_code, b.com_name as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   ( select cardno, pay_dt as est_dt, sum(buy_amt) est_amt \n"+
				"		   from ( "+base_query+" ) \n"+
				"          group by cardno, pay_dt \n"+
				"        ) a, "+
				"        card b, pay_item p \n"+
				" where  a.cardno=b.cardno \n"+
				"        and '45'=p.p_st1(+) and a.est_dt=p.p_cd1(+) and a.cardno=p.p_cd2(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.card_kind||b.card_name like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.est_dt like replace('"+st_dt+"%', '-','')";

		query += " order by a.est_dt";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt45List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	51 캠페인포상
	 */
    public Vector getPayEstAmt51List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String base_query = "";
		String what = "";


		base_query = " select b.user_id, b.user_nm, b.id, b.ven_code, c.cms_bk, b.bank_nm, b.bank_no, \n"+
					 "        a.save_dt, a.gubun, a.amt, a.c_yy, a.c_mm, \n"+
					 "        decode(a.gubun,'1','채권','2','영업','5','비용','6','제안') gubun_nm \n"+
					 " from   STAT_CMP a, users b, (select code, nm, replace(nm,'은행','') nm2, cms_bk from code where c_st='0003' and code<>'0000') c \n"+
					 " where  a.save_dt > '20100531' \n"+
					 " and    a.amt>0 \n"+
					 " and    a.user_id=b.user_id \n"+
					 " and    replace(b.bank_nm,'은행','')=nm2(+) \n"+
					 " order by a.save_dt, a.gubun, a.seq\n"+
					 " ";


		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.save_dt as p_cd1, a.gubun as p_cd2, a.user_id as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '51' as p_st1, '캠페인포상' as p_st2, '계좌이체' as p_st3, a.gubun_nm as p_st4, '' as p_st5, \n"+

				"        'user_id' as off_st, a.user_id as off_id, a.user_nm as off_nm, '' off_tel, \n"+
				"        a.id as ven_code, a.user_nm as ven_name, \n"+

				"        a.save_dt as est_dt, a.amt as amt, \n"+

			    "        a.cms_bk as bank_id, a.bank_nm as bank_nm, a.bank_no as bank_no, \n"+

				"		 '' a_bank_id, '' as a_bank_nm, '' as a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        a.c_yy||'년'||a.c_mm||'분기 '||a.gubun_nm||'캠페인 포상금 '||a.user_nm as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, a.user_id as buy_user_id, '' s_idno, \n"+

				"	     '13400' acct_code, a.user_nm as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   ( "+base_query+" ) a, "+
				"        pay_item p \n"+
				" where  '51'=p.p_st1(+) and a.save_dt=p.p_cd1(+) and a.gubun=p.p_cd2(+) and a.user_id=p.p_cd3(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and a.user_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.save_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("1"))	what = "upper(nvl(a.gubun_nm, ' '))";
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	


		query += " order by a.save_dt";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt51List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	52 제안포상
	 */
    public Vector getPayEstAmt52List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String base_query = "";
		String what = "";


		base_query = " select b.user_id, b.user_nm, b.id, b.ven_code, c.cms_bk, b.bank_nm, b.bank_no, \n"+
					 "        a.prop_id, a.jigub_dt as est_dt, "+
					 "        nvl(a.jigub_amt,a.prize) as amt, "+ //완료기한에 따른 배율 적용한 금액
					 "        a.title, substr(a.title,1,15)||'..' as title2 \n"+
					 " from   prop_bbs a, users b, (select code, nm, replace(nm,'은행','') nm2, cms_bk from code where c_st='0003' and code<>'0000') c \n"+
					 " where  a.jigub_dt > '20100531' \n"+
					 " and    a.prize>0 \n"+
					 " and    a.reg_id=b.user_id \n"+
					 " and    replace(b.bank_nm,'은행','')=nm2(+) \n"+
					 " order by a.jigub_dt, a.reg_id\n"+
					 " ";


		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.est_dt as p_cd1, a.prop_id as p_cd2, a.user_id as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '52' as p_st1, '제안포상' as p_st2, '계좌이체' as p_st3, '' as p_st4, '' as p_st5, \n"+

				"        'user_id' as off_st, a.user_id as off_id, a.user_nm as off_nm, '' off_tel, \n"+
				"        a.id as ven_code, a.user_nm as ven_name, \n"+

				"        a.est_dt as est_dt, a.amt as amt, \n"+

			    "        a.cms_bk as bank_id, a.bank_nm as bank_nm, a.bank_no as bank_no, \n"+

				"		 '' a_bank_id, '' as a_bank_nm, '' as a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        a.est_dt||' 제안포상금 '||a.user_nm||'-'||a.title2 as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, a.user_id as buy_user_id, '' s_idno, \n"+

				"	     '13400' acct_code, a.user_nm as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   ( "+base_query+" ) a, "+
				"        pay_item p \n"+
				" where  '52'=p.p_st1(+) and a.est_dt=p.p_cd1(+) and to_char(a.prop_id)=p.p_cd2(+) and a.user_id=p.p_cd3(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and a.user_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.est_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("1"))	what = "upper(nvl(a.title, ' '))";
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	


		query += " order by a.est_dt";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt52List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	53 귀향여비
	 */
    public Vector getPayEstAmt53List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String base_query = "";
		String what = "";


		base_query = " select a.hday as est_dt, a.hday_nm as gubun, \n"+
					 "        b.user_id, b.user_nm, b.id, b.ven_code, c.cms_bk, b.bank_nm, b.bank_no, b.dept_id, b.enter_dt, \n"+
					 "        trunc(months_between(to_date(a.hday,'YYYYMMDD'),to_date(b.enter_dt,'YYYYMMDD')),0) mons, \n"+
					 "        case when trunc(months_between(to_date(a.hday,'YYYYMMDD'),to_date(b.enter_dt,'YYYYMMDD')),0)>=3 then 500000 else 250000 end amt \n"+
					 " from \n"+
					 "        ( \n"+
					 "          select a.hday, a.hday_nm \n"+
					 "          from   holiday a, \n"+
					 "                 ( select hday_nm, substr(hday,1,6) hmon, min(hday) hday \n"+
					 "                   from   holiday \n"+
					 "                   where  hday_nm in ('설날','추석') \n"+
					 "                   and    hday like to_char(sysdate,'YYYY')||'%' \n"+
					 "                   group by hday_nm, substr(hday,1,6) \n"+
					 "                 ) b \n"+
					 "          where  a.hday_nm in ('설날','추석') \n"+
					 "          and    a.hday like to_char(sysdate,'YYYY')||'%' \n"+
					 "          and    a.hday >= to_char(sysdate,'YYYYMMDD') \n"+
					 "          and    a.hday=b.hday and a.hday_nm=b.hday_nm \n"+
					 "          union all \n"+
					 "          select to_char(sysdate,'YYYY')||'0715' hday, '휴가비' hday_nm from dual where to_char(sysdate,'YYYYMMDD')<=to_char(sysdate,'YYYY')||'0715' \n"+
					 "        ) a, \n"+
					 "        users b, \n"+
					 "        (select code, nm, replace(nm,'은행','') nm2, cms_bk from code where c_st='0003' and code<>'0000') c \n"+
					 " where  b.use_yn='Y' and b.dept_id not in ('0005','8888','0004') \n"+
					 " and    replace(b.bank_nm,'은행','')=nm2(+) \n"+
					 " order by a.hday, b.dept_id, b.enter_dt\n"+
					 " ";


		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.est_dt as p_cd1, a.gubun as p_cd2, a.user_id as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '53' as p_st1, '귀향여비' as p_st2, '계좌이체' as p_st3, '' as p_st4, '' as p_st5, \n"+

				"        'user_id' as off_st, a.user_id as off_id, a.user_nm as off_nm, '' off_tel, \n"+
				"        a.ven_code as ven_code, a.user_nm as ven_name, \n"+

				"        a.est_dt as est_dt, a.amt as amt, \n"+

			    "        a.cms_bk as bank_id, a.bank_nm as bank_nm, a.bank_no as bank_no, \n"+

				"		 '' a_bank_id, '' as a_bank_nm, '' as a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        a.gubun||decode(a.gubun,'휴가비',' ',' 귀향여비 ')||a.user_nm as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, a.user_id as buy_user_id, '' s_idno, \n"+

				"	     '81100' acct_code, a.user_nm as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   ( "+base_query+" ) a, "+
				"        pay_item p \n"+
				" where  '53'=p.p_st1(+) and a.est_dt=p.p_cd1(+) and a.gubun=p.p_cd2(+) and a.user_id=p.p_cd2(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and a.user_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.est_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("1"))	what = "upper(nvl(a.gubun, ' '))";
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	


		query += " order by a.est_dt";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt53List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	54 인터넷당직비
	 */
    public Vector getPayEstAmt54List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String base_query = "";
		String what = "";


		base_query = " select to_char(sysdate,'YYYYMMDD') as est_dt, '인터넷당직' as gubun, \n"+
					 "        b.user_id, b.user_nm, b.id, b.ven_code, c.cms_bk, b.bank_nm, b.bank_no, b.dept_id, b.enter_dt, \n"+
					 "        a.watch_dt, a.amt \n"+
					 " from \n"+
					 "        ( \n"+
					 "          select member_id, start_year||start_mon||start_day as watch_dt, watch_amt as amt\n"+
					 "          from   sch_watch\n"+
					 "          where  watch_type=2 and pay_dt is null \n"+
					 "          and    start_year||start_mon||start_day\n"+
					 "                     between to_char(sysdate+decode(to_char(sysdate,'D'),2,-7,3,-8,4,-9,5,-10,6,-11),'YYYYMMDD')\n"+
					 "                     and     to_char(sysdate+decode(to_char(sysdate,'D'),2,-1,3,-2,4,-3,5,-4,6,-5),'YYYYMMDD')\n"+
					 "        ) a, \n"+
					 "        users b, \n"+
					 "        (select code, nm, replace(nm,'은행','') nm2, cms_bk from code where c_st='0003' and code<>'0000') c \n"+
					 " where  a.member_id=b.user_id \n"+
					 " and    replace(b.bank_nm,'은행','')=c.nm2(+) \n"+
					 " order by a.watch_dt\n"+
					 " ";


		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.watch_dt as p_cd1, a.gubun as p_cd2, a.user_id as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '54' as p_st1, '인터넷당직비' as p_st2, '계좌이체' as p_st3, '' as p_st4, '' as p_st5, \n"+

				"        'user_id' as off_st, a.user_id as off_id, a.user_nm as off_nm, '' off_tel, \n"+
				"        a.ven_code as ven_code, a.user_nm as ven_name, \n"+

				"        a.est_dt as est_dt, a.amt as amt, \n"+

			    "        a.cms_bk as bank_id, a.bank_nm as bank_nm, a.bank_no as bank_no, \n"+

				"		 '' a_bank_id, '' as a_bank_nm, '' as a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        a.gubun||' '||a.user_nm||' '||a.watch_dt as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, a.user_id as buy_user_id, '' s_idno, \n"+

				"	     '81100' acct_code, a.user_nm as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+ //복리후생비

				" from   ( "+base_query+" ) a, "+
				"        pay_item p \n"+
				" where  '54'=p.p_st1(+) and a.watch_dt=p.p_cd1(+) and a.gubun=p.p_cd2(+) and a.user_id=p.p_cd2(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and a.user_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.est_dt like replace('"+st_dt+"%', '-','')";

		if(s_kd.equals("1"))	what = "upper(nvl(a.gubun, ' '))";
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	


		query += " order by a.watch_dt";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt54List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	55 당직비
	 */
    public Vector getPayEstAmt55List(String s_kd, String t_wd, String st_dt, String end_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String base_query = "";
		String what = "";


		base_query = " select to_char(sysdate,'YYYYMMDD') as est_dt, '당직-'||d.br_nm as gubun, \n"+
					 "        b.user_id, b.user_nm, b.id, b.ven_code, c.cms_bk, b.bank_nm, b.bank_no, b.dept_id, b.enter_dt, \n"+
					 "        a.watch_dt, a.amt, a.watch_type \n"+
					 " from \n"+
					 "        ( \n"+
					 "          select member_id, start_year||start_mon||start_day as watch_dt, watch_amt as amt, watch_type\n"+
					 "          from   sch_watch\n"+
					 "          where  watch_type <>'2'  and pay_dt is null \n"+ 
					 "                 and start_year||start_mon||start_day < '20200210' \n"+ 
					 "          UNION all         \r\n" + 
					 "          SELECT user_id AS member_id, doc_dt AS watch_dt, SUM(call_amt) amt, '0' watch_type\r\n" + 
					 "        	FROM   ars_call_stat  \r\n" + 
					 "        	WHERE  doc_dt IS NOT NULL AND call_amt>0 and pay_dt is null \r\n" + 
					 "          GROUP BY user_id, doc_dt"+
					 "        ) a, \n"+
					 "        users b, branch d, \n"+
					 "        (select code, nm, replace(nm,'은행','') nm2, cms_bk from code where c_st='0003' and code<>'0000') c \n"+
					 " where  a.member_id=b.user_id and b.br_id=d.br_id \n"+
					 " and    replace(b.bank_nm,'은행','')=c.nm2(+) \n"+
					 " order by a.watch_dt, a.watch_type\n"+
					 " ";


		query = " select  /*+ rule */ \n"+
				"        '4' as p_way, \n"+
				"        a.watch_dt as p_cd1, a.gubun as p_cd2, a.user_id as p_cd3, a.watch_type as p_cd4, '' as p_cd5, \n"+
				"        '55' as p_st1, '당직비' as p_st2, '자동이체' as p_st3, '' as p_st4, '' as p_st5, \n"+

				"        'user_id' as off_st, a.user_id as off_id, a.user_nm as off_nm, '' off_tel, \n"+
				"        a.ven_code as ven_code, a.user_nm as ven_name, \n"+

				"        a.est_dt as est_dt, a.amt as amt, \n"+

			    //"        a.cms_bk as bank_id, a.bank_nm as bank_nm, a.bank_no as bank_no, \n"+
			    "        '' as bank_id, '' as bank_nm, '' as bank_no, \n"+

				//"		 '' a_bank_id, '' as a_bank_nm, '' as a_bank_no, \n"+
				"        '026' as a_bank_id, \n"+
				"	     '신한은행' as a_bank_nm, \n"+
				"	     '140-004-023871' as a_bank_no, \n"+				

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        a.gubun||' '||a.user_nm||' '||a.watch_dt as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, a.user_id as buy_user_id, '' s_idno, \n"+

				"	     '81100' acct_code, a.user_nm as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+ //복리후생비

				" from   ( "+base_query+" ) a, "+
				"        pay_item p \n"+
				" where  '55'=p.p_st1(+) and a.watch_dt=p.p_cd1(+) and a.gubun=p.p_cd2(+) and a.user_id=p.p_cd3(+) and a.watch_type=p.p_cd4(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and a.user_nm like '%"+pay_off+"%' \n";

		if(!st_dt.equals("") && end_dt.equals(""))	query += " and a.watch_dt like replace('"+st_dt+"%', '-','') \n";
		if(!st_dt.equals("") && !end_dt.equals("")) query += " and a.watch_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";

		if(s_kd.equals("1"))	what = "upper(nvl(a.gubun, ' '))";
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	


		query += " order by a.watch_dt, a.watch_type";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt55List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**********************************************/	
	/*                                            */
	/*             기타 코드 검색메소드           */
	/*                                            */
	/**********************************************/	


	/**
     * acar 은행 계좌번호 리스트
     */
    public Hashtable getBankCode(String code, String nm) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE);
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Hashtable ht = new Hashtable();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "SELECT a.* \n"
        		+ "FROM CODE a\n"
        		+ "where a.C_ST='0003'\n";


		if(!code.equals("")) query += " and a.code='"+code+"'";

		if(!nm.equals("")) query += " and replace(a.nm,'은행','') like '%'||replace('"+nm+"','은행','')||'%' ";


	    try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	

            if(rs.next()){                
				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
            }
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getBankCode]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con1);
			con1 = null;
        }
        return ht;
    }

	/**
     * neoe 계좌번호 '-' 생성하기
     */
    public Hashtable getBankBarNum(String bank_n) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Hashtable ht = new Hashtable();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String query = "";
        
        query = "select a.nm_deposit AS deposit_name, a.no_deposit AS deposit_no, a.cd_bank, a.cd_bank_send, yn_use, NVL(b.ln_partner,SUBSTR(a.nm_deposit,1,2)) as checkd_name \n"+
				" from   FI_DEPOSIT a, MA_PARTNER b \n"+
				" WHERE  a.cd_company='1000' AND NVL(a.yn_use,'Y')='Y' AND a.CD_BANK=b.cd_partner(+) \n";

		if(!bank_n.equals("")) query += " AND REPLACE(a.no_deposit,'-','') = REPLACE('"+bank_n+"','-','') \n";


	    try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	

            if(rs.next()){                
				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
            }
            rs.close();
            pstmt.close();
            
            //System.out.println("[PaySearchDatabase:getBankBarNum]"+query);

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getBankBarNum]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return ht;
    }


	/**
	 *	코드리스트
	 */
    public Vector getCodeList(String c_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, decode(length(a.cms_bk), 0,'', 3,a.cms_bk, 2,a.cms_bk||'0') bank_id "+
				" from code a where a.c_st='"+c_st+"' and a.code<>'0000' "+
				" "; 

		if(c_st.equals("0003")) query += " and a.cms_bk is not null order by decode(a.c_st,'0003',decode(a.nm,'신한은행',0,1),1), a.nm, a.cms_bk";
		else					query += " order by a.code";


	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getCodeList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }


	/**
	 *	거래처조회리스트
	 */
    public Vector getOffSearchList(String off_st, String t_wd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";


		if(off_st.equals("cpt_cd")){//할부금융사

			query = " select distinct a.off_id, c.nm as off_nm, b.no_company as off_idno, c.nm as bank_acc_nm, \n"+
				    "                 nvl(a.ven_code,e.ven_code) as ven_code, nvl(b.ln_partner,e.ven_name) as ven_name, \n"+
				    "                 b.dc_ads1_h as ven_addr, nvl(d.ven_st,'0') as ven_st, \n"+
					"                 '' bank_id, '' as bank_nm, '' as bank_no, '' as own_nm, '' off_tel"+
					" from \n"+
					"        (select cpt_cd as off_id, ven_code from allot group by cpt_cd, ven_code \n"+
					"         union all \n"+
					"         select a.cont_bn as off_id, b.ven_code from lend_bank a, bank_rtn b where a.lend_id=b.lend_id group by a.cont_bn, b.ven_code \n"+
					"        ) a, \n"+
					"        neoe.MA_PARTNER b, \n"+
					"        (select * from code where c_st='0003') c, \n"+
			        "        (SELECT cust_code, ven_st FROM trade_his WHERE ven_st is not null and (cust_code, reg_dt) in (select cust_code, max(reg_dt) from trade_his where ven_st is not null group by cust_code)) d, \n"+
			        "        (SELECT off_id, ven_code, ven_name FROM pay WHERE off_st='"+off_st+"' and (off_id, reg_dt, reqseq) in (select off_id, max(reg_dt), max(reqseq) from pay where off_st='"+off_st+"' and ven_code is not null group by off_id)) e \n"+
					" where  a.ven_code=b.cd_partner(+) \n"+
				    "        and a.off_id=c.code \n"+
				    "        and a.ven_code=d.cust_code(+) \n"+
                    "        and a.off_id=e.off_id(+) \n"+
			        "        and c.nm||b.ln_partner||b.no_company like '%"+t_wd+"%'"+
					" ";
		
		}else if(off_st.equals("com_code")){//카드사

			query = " select distinct a.com_code as off_id, a.com_name as off_nm, b.no_company as off_idno, a.com_name as bank_acc_nm, \n"+
				    "                 a.com_code as ven_code, a.com_name as ven_name, \n"+
				    "                 b.dc_ads1_h as ven_addr, d.ven_st, \n"+
					"                 '' bank_id, '' as bank_nm, '' as bank_no, '' as own_nm, '' off_tel"+
                    " from   card a, neoe.MA_PARTNER b, \n"+
                    "        (SELECT cust_code, ven_st FROM trade_his WHERE ven_st is not null and (cust_code, reg_dt) in (select cust_code, max(reg_dt) from trade_his where ven_st is not null group by cust_code)) d \n"+
                    " where  a.com_code=b.cd_partner \n"+
                    "        and a.com_code=d.cust_code(+) \n"+
                    "        and a.com_name||b.no_company like '%"+t_wd+"%' \n"+
					" ";		

		}else if(off_st.equals("ins_com_id")){//보험사

			query = " select   a.ins_com_id as off_id, a.ins_com_nm as off_nm, b.no_company as off_idno, a.ins_com_nm as bank_acc_nm, \n"+
				    "        nvl(a.ven_code,e.ven_code) as ven_code, nvl(a.ven_name,e.ven_name) as ven_name, \n"+
				    "        b.dc_ads1_h as ven_addr, nvl(d.ven_st,'0') as ven_st, \n"+
					"        '' bank_id, '' as bank_nm, '' as bank_no, '' as own_nm, a.agnt_tel as off_tel"+
                    " from   ins_com a, neoe.MA_PARTNER b, \n"+
                    "        (SELECT cust_code, ven_st FROM trade_his WHERE ven_st is not null and (cust_code, reg_dt) in (select cust_code, max(reg_dt) from trade_his where ven_st is not null group by cust_code)) d, \n"+
			        "        (SELECT off_id, ven_code, ven_name FROM pay WHERE off_st='"+off_st+"' and (off_id, reg_dt, reqseq) in (select off_id, max(reg_dt), max(reqseq) from pay where off_st='"+off_st+"' and ven_code is not null group by off_id)) e \n"+
                    " where  a.ven_code=b.cd_partner(+) \n"+
                    "        and a.ven_code=d.cust_code(+) \n"+
                    "        and a.ins_com_id=e.off_id(+) \n"+
                    "        and a.ins_com_nm||b.no_company like '%"+t_wd+"%' \n"+
					" ";		

		}else if(off_st.equals("car_off_id")){//자동차영업소

			query = " select  a.car_off_id as off_id, a.car_off_nm as off_nm, b.no_company as off_idno, nvl(e2.bank_acc_nm,nvl(a.acc_nm,a.car_off_nm)) as bank_acc_nm, \n"+
				    "        nvl(a.ven_code,e.ven_code) as ven_code, nvl(b.ln_partner,e.ven_name) as ven_name, \n"+
				    "        b.dc_ads1_h as ven_addr, nvl(d.ven_st,'1') ven_st, \n"+
					"        nvl(e2.bank_id,'') bank_id, nvl(e2.bank_nm,a.bank) as bank_nm, nvl(e2.bank_no,a.acc_no) as bank_no, '' as own_nm, a.car_off_tel as off_tel"+
                    " from   car_off a, neoe.MA_PARTNER b, \n"+
                    "        (SELECT cust_code, ven_st FROM trade_his WHERE ven_st is not null and (cust_code, reg_dt) in (select cust_code, max(reg_dt) from trade_his where ven_st is not null group by cust_code)) d, \n"+
			        "        (SELECT off_id, ven_code, ven_name FROM pay WHERE off_st='"+off_st+"' and (off_id, reg_dt, reqseq) in (select off_id, max(reg_dt), max(reqseq) from pay where off_st='"+off_st+"' and ven_code is not null group by off_id)) e, \n"+
			        "        (SELECT off_id, bank_id, bank_nm, bank_no, bank_acc_nm FROM pay WHERE off_st='"+off_st+"' and (off_id, reg_dt, reqseq) in (select off_id, max(reg_dt), max(reqseq) from pay where off_st='"+off_st+"' and bank_no is not null group by off_id)) e2 \n"+
                    " where  a.ven_code=b.cd_partner(+) \n"+
                    "        and a.ven_code=d.cust_code(+) \n"+
                    "        and a.car_off_id=e.off_id(+) \n"+
                    "        and a.car_off_id=e2.off_id(+) \n"+
                    "        and a.car_off_nm||b.no_company like '%"+t_wd+"%' \n"+
					" ";	
			
		}else if(off_st.equals("tax_car_off_id")){//자동차영업소-캐쉬백수익 발행 영업소

			query = " select  a.car_off_id as off_id, a.car_off_nm as off_nm, b.no_company as off_idno, nvl(e2.bank_acc_nm,nvl(a.acc_nm,a.car_off_nm)) as bank_acc_nm, \n"+
				    "        nvl(nvl(a.cashback_ven_code,a.ven_code),e.ven_code) as ven_code, nvl(b.ln_partner,e.ven_name) as ven_name, \n"+
				    "        b.dc_ads1_h as ven_addr, nvl(d.ven_st,'1') ven_st, \n"+
					"        nvl(e2.bank_id,'') bank_id, nvl(e2.bank_nm,a.bank) as bank_nm, nvl(e2.bank_no,a.acc_no) as bank_no, '' as own_nm, a.car_off_tel as off_tel"+
                    " from   car_off a, neoe.MA_PARTNER b, \n"+
                    "        (SELECT cust_code, ven_st FROM trade_his WHERE ven_st is not null and (cust_code, reg_dt) in (select cust_code, max(reg_dt) from trade_his where ven_st is not null group by cust_code)) d, \n"+
			        "        (SELECT off_id, ven_code, ven_name FROM pay WHERE off_st='"+off_st+"' and (off_id, reg_dt, reqseq) in (select off_id, max(reg_dt), max(reqseq) from pay where off_st='"+off_st+"' and ven_code is not null group by off_id)) e, \n"+
			        "        (SELECT off_id, bank_id, bank_nm, bank_no, bank_acc_nm FROM pay WHERE off_st='"+off_st+"' and (off_id, reg_dt, reqseq) in (select off_id, max(reg_dt), max(reqseq) from pay where off_st='"+off_st+"' and bank_no is not null group by off_id)) e2 \n"+
                    " where  one_self_yn='Y' and nvl(a.cashback_ven_code,a.ven_code)=b.cd_partner(+) \n"+
                    "        and nvl(a.cashback_ven_code,a.ven_code)=d.cust_code(+) \n"+
                    "        and a.car_off_id=e.off_id(+) \n"+
                    "        and a.car_off_id=e2.off_id(+) \n"+
                    "        and a.car_off_nm||b.no_company like '%"+t_wd+"%' \n"+
					" ";	

		}else if(off_st.equals("emp_id")){//자동차영업사원

			query = " select  a.emp_id as off_id, a.emp_nm as off_nm, substr(a.emp_ssn,1,6) as off_idno, nvl(a.emp_acc_nm,a.emp_nm) as bank_acc_nm, \n"+
				    "        '' ven_code, replace(c.nm,'자동차','')||' '||b.car_off_nm||' '||a.emp_nm as ven_name, \n"+
				    "        a.emp_addr as ven_addr, '0' as ven_st, \n"+
					"        a.emp_bank as bank_id, '' as bank_nm, a.emp_acc_no as bank_no, '' as own_nm, a.emp_m_tel as off_tel"+
                    " from   car_off_emp a, car_off b, (select * from code where c_st='0001') c \n"+
                    " where  a.car_off_id=b.car_off_id \n"+
                    "        and b.car_comp_id=c.code \n"+
                    "        and c.nm||b.car_off_nm||a.emp_nm like '%"+t_wd+"%' \n"+
					" ";	
			
		}else if(off_st.equals("off_id")){//협력업체

			query = " select  a.off_id, a.off_nm, a.ent_no as off_idno, nvl(nvl(a.acc_nm,e2.bank_acc_nm),a.off_nm) as bank_acc_nm, \n"+
				    "        nvl(a.ven_code,e.ven_code) as ven_code, nvl(b.ln_partner,e.ven_name) as ven_name, \n"+
				    "        a.off_addr as ven_addr, nvl(d.ven_st,'1') as ven_st, \n"+
					"        '' bank_id, nvl(a.bank,e2.bank_nm) as bank_nm, nvl(a.acc_no,e2.bank_no) as bank_no, a.own_nm, a.off_tel"+
                    " from   serv_off a, neoe.MA_PARTNER b, \n"+
                    "        (SELECT cust_code, ven_st FROM trade_his WHERE ven_st is not null and (cust_code, reg_dt) in (select cust_code, max(reg_dt) from trade_his where ven_st is not null group by cust_code)) d, \n"+
			        "        (SELECT off_id, ven_code, ven_name FROM pay WHERE off_st='"+off_st+"' and (off_id, reg_dt, reqseq) in (select off_id, max(reg_dt), max(reqseq) from pay where off_st='"+off_st+"' and ven_code is not null group by off_id)) e, \n"+
			        "        (SELECT off_id, bank_id, bank_nm, bank_no, bank_acc_nm FROM pay WHERE off_st='"+off_st+"' and (off_id, reg_dt, reqseq) in (select off_id, max(reg_dt), max(reqseq) from pay where off_st='"+off_st+"' and bank_no is not null group by off_id)) e2 \n"+
                    " where  a.ven_code=b.cd_partner(+) \n"+
                    "        and a.ven_code=d.cust_code(+) \n"+
                    "        and a.off_id=e.off_id(+) \n"+
                    "        and a.off_id=e2.off_id(+) \n"+
                    "        and a.off_nm||a.ent_no like '%"+t_wd+"%' \n"+
					" ";	
			
		}else if(off_st.equals("gov_id")){//관공서

			query = " select  a.gov_id as  off_id, a.gov_nm as off_nm, b.no_company as off_idno, nvl(e2.bank_acc_nm,a.gov_nm) as bank_acc_nm, \n"+
				    //"        nvl(a.ven_code,e.ven_code) as ven_code, nvl(a.ven_name,e.ven_name) as ven_name, \n"+ //출금직접등록인 경우 잘못연동될수도 있음.
				    "        a.ven_code, a.ven_name, \n"+					
				    "        a.addr as ven_addr, nvl(d.ven_st,'4') as ven_st, \n"+
					"        nvl(e2.bank_id,'') bank_id, nvl(e2.bank_nm,a.bank_nm) as bank_nm, nvl(e2.bank_no,a.bank_no) as bank_no, '' as own_nm, a.tel as off_tel"+
                    " from   fine_gov a, neoe.MA_PARTNER b, \n"+
                    "        (SELECT cust_code, ven_st FROM trade_his WHERE ven_st is not null and (cust_code, reg_dt) in (select cust_code, max(reg_dt) from trade_his where ven_st is not null group by cust_code)) d, \n"+
			        "        (SELECT off_id, ven_code, ven_name FROM pay WHERE off_st='"+off_st+"' and (off_id, reg_dt, reqseq) in (select off_id, max(reg_dt), max(reqseq) from pay where off_st='"+off_st+"' and ven_code is not null group by off_id)) e, \n"+
			        "        (SELECT off_id, bank_id, bank_nm, bank_no, bank_acc_nm FROM pay WHERE off_st='"+off_st+"' and (off_id, reg_dt, reqseq) in (select off_id, max(reg_dt), max(reqseq) from pay where off_st='"+off_st+"' and bank_no is not null group by off_id)) e2 \n"+
                    " where  a.ven_code=b.cd_partner(+) \n"+
                    "        and a.ven_code=d.cust_code(+) \n"+
                    "        and a.gov_id=e.off_id(+) \n"+
                    "        and a.gov_id=e2.off_id(+) \n"+
                    "        and a.gov_nm||b.no_company like '%"+t_wd+"%' \n"+
					" ";	
		}else if(off_st.equals("client_id")){//고객

			query = " select   a.client_id as off_id, a.firm_nm as off_nm, decode(a.client_st,'2',substr(TEXT_DECRYPT(a.ssn, 'pw' ) ,1,6),a.enp_no) as off_idno, nvl(nvl(e2.bank_acc_nm,c.re_acc_nm),a.firm_nm||' '||a.client_nm) as bank_acc_nm, \n"+
				    "        nvl(a.ven_code,e.ven_code) as ven_code, nvl(b.ln_partner,e.ven_name) as ven_name, \n"+
				    "        b.dc_ads1_h as ven_addr, decode(a.client_st,'2','0','1') as ven_st, \n"+
					"        nvl(e2.bank_id,'') bank_id, nvl(e2.bank_nm,c.nm) as bank_nm, nvl(e2.bank_no,c.re_acc_no) as bank_no, '' as own_nm, a.o_tel as off_tel"+
                    " from   client a, neoe.MA_PARTNER b, \n"+
					"        (select b.client_id, a.re_bank, a.re_acc_no, a.re_acc_nm, c.code, c.nm from cls_etc a, cont b, (select * from code where c_st='0003') c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.re_bank=c.cms_bk) c, \n"+
                    "        (SELECT cust_code, ven_st FROM trade_his WHERE ven_st is not null and (cust_code, reg_dt) in (select cust_code, max(reg_dt) from trade_his where ven_st is not null group by cust_code)) d, \n"+
			        "        (SELECT off_id, ven_code, ven_name FROM pay WHERE off_st='"+off_st+"' and (off_id, reg_dt, reqseq) in (select off_id, max(reg_dt), max(reqseq) from pay where off_st='"+off_st+"' and ven_code is not null group by off_id)) e, \n"+
			        "        (SELECT off_id, bank_id, bank_nm, bank_no, bank_acc_nm FROM pay WHERE off_st='"+off_st+"' and (off_id, reg_dt, reqseq) in (select off_id, max(reg_dt), max(reqseq) from pay where off_st='"+off_st+"' and bank_no is not null group by off_id)) e2 \n"+
                    " where  a.ven_code=b.cd_partner(+) \n"+
                    "        and a.client_id=c.client_id(+) \n"+
                    "        and a.ven_code=d.cust_code(+) \n"+
                    "        and a.client_id=e.off_id(+) \n"+
                    "        and a.client_id=e2.off_id(+) \n"+
                    "        and a.firm_nm||a.enp_no like '%"+t_wd+"%' \n"+
					" ";	
		}else if(off_st.equals("user_id")){//아마존카사원

			query = " select a.user_id as off_id, a.user_nm as off_nm, '' as off_idno, a.user_nm as bank_acc_nm, \n"+
				    "        nvl(a.ven_code,a.id) as ven_code, a.user_nm as ven_name, \n"+
				    "        a.addr ven_addr, '0' as ven_st, \n"+
					"        '' as bank_id, a.bank_nm, a.bank_no, '' as own_nm, a.user_m_tel as off_tel"+
                    " from   users a \n"+
                    " where  a.user_nm like '%"+t_wd+"%' \n"+
					" ";	
		}else if(off_st.equals("br_id")){//아마존카

			query = " select a.br_id as off_id, a.br_nm as off_nm, a.br_ent_no as off_idno, a.br_nm as bank_acc_nm, \n"+
				    "        '000131' as ven_code, a.br_nm as ven_name, \n"+
				    "        a.br_addr ven_addr, '0' as ven_st, \n"+
					"        '' as bank_id, '' as bank_nm, ''  as bank_no, '' as own_nm, a.tel as off_tel"+
                    " from   branch a \n"+
                    " where  a.br_nm||a.br_ent_no like '%"+t_wd+"%' \n"+
					" ";	
		}else if(off_st.equals("other")){//기타-네오엠

			query = " select   '' as  off_id, b.ln_partner as off_nm, b.no_company as off_idno, nvl(b.nm_deposit,nvl(e2.bank_acc_nm,b.ln_partner||' '||b.nm_ceo)) as bank_acc_nm, \n"+
				    "        b.cd_partner as ven_code, b.ln_partner as ven_name, \n"+
				    "        b.dc_ads1_h as ven_addr, nvl(d.ven_st,'4') as ven_st, \n"+
					"        decode(b.nm_text,'출금관리 계좌미표시','',nvl(e2.bank_id,'')) bank_id, "+
					"        decode(b.nm_text,'출금관리 계좌미표시','',nvl(e2.bank_nm,'')) as bank_nm, "+
					"        decode(b.nm_text,'출금관리 계좌미표시','',nvl(e2.bank_no,'')) as bank_no, "+
					"        b.nm_ceo as own_nm, b.no_tel as off_tel"+
                    " from   neoe.MA_PARTNER b, \n"+
                    "        (SELECT cust_code, ven_st FROM trade_his WHERE ven_st is not null and (cust_code, reg_dt) in (select cust_code, max(reg_dt) from trade_his where ven_st is not null group by cust_code)) d, \n"+
			        "        (SELECT ven_code, ven_name FROM pay WHERE off_st='"+off_st+"' and (ven_code, reg_dt, reqseq) in (select ven_code, max(reg_dt), max(reqseq) from pay where off_st='"+off_st+"' and ven_code is not null group by ven_code)) e, \n"+
			        "        (SELECT ven_code, bank_id, bank_nm, bank_no, bank_acc_nm FROM pay WHERE ven_code not in ('120698') and off_st='"+off_st+"' and (ven_code, reg_dt, reqseq) in (select ven_code, max(reg_dt), max(reqseq) from pay where off_st='"+off_st+"' and bank_no is not null group by ven_code)) e2 \n"+
                    " where  b.cd_partner=d.cust_code(+) \n"+
                    "        and b.cd_partner=e.ven_code(+) \n"+
                    "        and b.cd_partner=e2.ven_code(+) \n"+
                    "        and b.ln_partner||b.no_company like '%"+t_wd+"%' \n"+
					" ";	

		}else{//그외 -> 기타-네오엠

			query = " select   '' as  off_id, b.ln_partner as off_nm, b.no_company as off_idno, nvl(b.nm_deposit,nvl(e2.bank_acc_nm,b.ln_partner||' '||b.nm_ceo)) as bank_acc_nm, \n"+
				    "        b.cd_partner as ven_code, b.ln_partner as ven_name, \n"+
				    "        b.dc_ads1_h as ven_addr, nvl(d.ven_st,'4') as ven_st, \n"+
					"        decode(b.nm_text,'출금관리 계좌미표시','',nvl(e2.bank_id,'')) bank_id, "+
					"        decode(b.nm_text,'출금관리 계좌미표시','',nvl(e2.bank_nm,'')) as bank_nm, "+
					"        decode(b.nm_text,'출금관리 계좌미표시','',nvl(e2.bank_no,'')) as bank_no, "+
					"        '' as own_nm, b.no_tel as off_tel"+
                    " from   neoe.MA_PARTNER b, \n"+
                    "        (SELECT cust_code, ven_st FROM trade_his WHERE ven_st is not null and (cust_code, reg_dt) in (select cust_code, max(reg_dt) from trade_his where ven_st is not null group by cust_code)) d, \n"+
			        "        (SELECT ven_code, ven_name FROM pay WHERE off_st='"+off_st+"' and (ven_code, reg_dt, reqseq) in (select ven_code, max(reg_dt), max(reqseq) from pay where off_st='"+off_st+"' and ven_code is not null group by ven_code)) e, \n"+
			        "        (SELECT ven_code, bank_id, bank_nm, bank_no, bank_acc_nm FROM pay WHERE off_st='"+off_st+"' and (ven_code, reg_dt, reqseq) in (select ven_code, max(reg_dt), max(reqseq) from pay where off_st='"+off_st+"' and bank_no is not null group by ven_code)) e2 \n"+
                    " where  b.cd_partner=d.cust_code(+) \n"+
                    "        and b.cd_partner=e.ven_code(+) \n"+
                    "        and b.cd_partner=e2.ven_code(+) \n"+
                    "        and b.ln_partner||b.no_company like '%"+t_wd+"%' \n"+
					" ";	

		}


	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getOffSearchList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**********************************************/	
	/*                                            */
	/*           네오엠 코드 검색메소드           */
	/*                                            */
	/**********************************************/	


	/**
     * 네오엠-은행 계좌번호 리스트
     */
    public Hashtable getDepositma(String bank_no) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);//neom(dzais.)
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Hashtable ht = new Hashtable();
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";

        query = " select a.nm_deposit AS deposit_name, a.no_deposit AS deposit_no, a.cd_bank, a.cd_bank_send, yn_use, NVL(b.ln_partner,SUBSTR(a.nm_deposit,1,2)) as checkd_name \n"+
				" from   FI_DEPOSIT a, MA_PARTNER b \n"+
				" WHERE  a.cd_company='1000' AND NVL(a.yn_use,'Y')='Y' AND a.CD_BANK=b.cd_partner(+) "+
				"        and replace(a.no_deposit,'-','')=replace('"+bank_no+"','-','')"+
				" ORDER BY decode(SUBSTR(a.nm_deposit,1,2), '신한','1', '하나','2', '국민','3', '9'), a.nm_deposit \n"+
				" ";

	    try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	

            if(rs.next()){                
				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
            }
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getDepositma]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return ht;
    }


	/**
     * 네오엠-은행 계좌번호 리스트
     */
    public Hashtable getCheckd(String check_code, String bank_nm) throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);//neom(dzais.)
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Hashtable ht = new Hashtable();
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";

		query = " SELECT cd_partner as checkd_code  FROM MA_PARTNER where fg_partner='002' and cd_company = '1000' "+
				" and decode(ln_partner,'농협중','농협','농협회','단위농협',replace(ln_partner,'은행',''))=replace('"+bank_nm+"','은행','')";

	    try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	

            if(rs.next()){                
				
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
            }
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getCheckd]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return ht;
    }

	/**
     * 네오엠-은행 계좌번호 리스트
     */
    public Vector getDepositList() throws DatabaseException, DataSourceEmptyException{
        Connection con1 = connMgr.getConnection(DATA_SOURCE1);
		if(con1 == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		Vector vt = new Vector();
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";

        query = " select a.nm_deposit AS deposit_name, a.no_deposit AS deposit_no, a.cd_bank, a.cd_bank_send, yn_use, NVL(b.ln_partner,SUBSTR(a.nm_deposit,1,2)) as checkd_name \n"+
				" from   FI_DEPOSIT a, MA_PARTNER b \n"+
				" WHERE  a.cd_company='1000' AND NVL(a.yn_use,'Y')='Y' AND a.CD_BANK=b.cd_partner(+) \n"+
				"        and a.nm_deposit not like '%미사용%' "+
				"        and a.nm_deposit not like '%MMF%' "+
				"        and a.nm_deposit not like '%만기%' "+
				"        and a.nm_deposit not like '%예금%' "+
				"        and a.nm_deposit not like '%자동차%' "+
				"        and a.nm_deposit not like '%투자%' "+
				"        and a.nm_deposit not like '%퇴직%' "+
				"		 and a.no_deposit not in ('257-910011-93104','659-910015-41004','163-01374-244','716-00034-242-01','601-053501-13-101','221-181337-31-00031') "+
				" ORDER BY decode(SUBSTR(a.nm_deposit,1,2), '신한','1', '하나','2', '국민','3', '9'), a.nm_deposit, b.ln_partner, a.no_deposit \n"+
				" ";

	    try{
            pstmt = con1.prepareStatement(query);
            rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	

            while(rs.next()){                
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getDepositList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con1);
			con1 = null;
        }
        return vt;
    }

	/**
	 *	출금등록관리
	 */
    public Hashtable getPayServ(String car_mng_id, String serv_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		//직접등록
		query = " select d.user_nm as reg_nm, a.reg_id, a.reg_dt, a.p_pay_dt, a.off_id, \n"+
				"        decode(b.serv_reg_yn,'',decode(a.reg_id||to_char(a.reg_dt,'YYYYMMDD'),nvl(c.reg_id||c.reg_dt,c.update_id||c.update_dt),'Y'),b.serv_reg_yn) as serv_reg_st, b.*, \n"+
				"        decode(a.filename1,'',0,1)+decode(a.filename2,'',0,1)+decode(a.filename3,'',0,1)+decode(a.filename4,'',0,1)+decode(a.filename5,'',0,1) file_cnt, "+
				"        a.SAVEPATH, a.filename1, a.filename2, a.filename3, a.filename4, a.filename5 "+
				" from \n"+
				"        pay a, pay_item b, service c, users d \n"+
				" where \n"+
				"       a.reg_st='D' and a.reqseq=b.reqseq \n"+
				"       and b.p_cd3='"+car_mng_id+"' and b.p_cd5='"+serv_id+"'\n"+
				"       and b.p_cd3=c.car_mng_id and b.p_cd5=c.serv_id"+
				"       and a.reg_id=d.user_id"+
				" union all "+
				" select d.user_nm as reg_nm, a.reg_id, a.reg_dt, a.p_pay_dt, a.off_id, \n"+
				"        'S' as serv_reg_st, b.*, \n"+
				"        decode(a.filename1,'',0,1)+decode(a.filename2,'',0,1)+decode(a.filename3,'',0,1)+decode(a.filename4,'',0,1)+decode(a.filename5,'',0,1) file_cnt, "+
				"        a.SAVEPATH, a.filename1, a.filename2, a.filename3, a.filename4, a.filename5 "+
				" from \n"+
				"        pay a, pay_item b, service c, users d \n"+
				" where \n"+
				"       a.reg_st='S' and a.reqseq=b.reqseq \n"+
				"       and b.p_cd1='"+car_mng_id+"' and b.p_cd2='"+serv_id+"'\n"+
				"       and b.p_cd1=c.car_mng_id and b.p_cd2=c.serv_id"+
				"       and a.reg_id=d.user_id"+
				" "; 


	    try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	

			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
            rs.close();
            pstmt.close();

		}catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayServ]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }

	/**
	 *	출금등록관리
	 */
    public Hashtable getPayServ(String car_mng_id, String serv_id, int rep_amt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		//직접등록
		query = " select d.user_nm as reg_nm, a.reg_id, a.reg_dt, a.p_pay_dt, a.off_id, \n"+
				"        decode(b.serv_reg_yn,'',decode(a.reg_id||to_char(a.reg_dt,'YYYYMMDD'),nvl(c.reg_id||c.reg_dt,c.update_id||c.update_dt),'Y'),b.serv_reg_yn) as serv_reg_st, b.*, \n"+
				"        decode(a.filename1,'',0,1)+decode(a.filename2,'',0,1)+decode(a.filename3,'',0,1)+decode(a.filename4,'',0,1)+decode(a.filename5,'',0,1) file_cnt, "+
				"        a.SAVEPATH, a.filename1, a.filename2, a.filename3, a.filename4, a.filename5 "+
				" from \n"+
				"        pay a, pay_item b, service c, users d \n"+
				" where \n"+
				"       a.reg_st='D' and a.reqseq=b.reqseq \n"+
				"       and b.p_cd3='"+car_mng_id+"' and b.p_cd5='"+serv_id+"' and b.i_amt="+rep_amt+" \n"+
				"       and b.p_cd3=c.car_mng_id and b.p_cd5=c.serv_id"+
				"       and a.reg_id=d.user_id"+
				" union all "+
				" select d.user_nm as reg_nm, a.reg_id, a.reg_dt, a.p_pay_dt, a.off_id, \n"+
				"        'S' as serv_reg_st, b.*, \n"+
				"        decode(a.filename1,'',0,1)+decode(a.filename2,'',0,1)+decode(a.filename3,'',0,1)+decode(a.filename4,'',0,1)+decode(a.filename5,'',0,1) file_cnt, "+
				"        a.SAVEPATH, a.filename1, a.filename2, a.filename3, a.filename4, a.filename5 "+
				" from \n"+
				"        pay a, pay_item b, service c, users d \n"+
				" where \n"+
				"       a.reg_st='S' and a.reqseq=b.reqseq \n"+
				"       and b.p_cd1='"+car_mng_id+"' and b.p_cd2='"+serv_id+"' and b.i_amt="+rep_amt+" \n"+
				"       and b.p_cd1=c.car_mng_id and b.p_cd2=c.serv_id"+
				"       and a.reg_id=d.user_id"+
				" "; 


	    try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	

			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
            rs.close();
            pstmt.close();

		}catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayServ]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }

	/**
	 *	카드등록관리
	 */
    public Hashtable getCardServ(String car_mng_id, String serv_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		//직접등록
		query = " select a.*, b.buy_dt from card_doc_item a, card_doc b where a.cardno=b.cardno and a.buy_id=b.buy_id \n"+
				"       and b.item_code='"+car_mng_id+"' and b.serv_id='"+serv_id+"'\n"+
				" "; 


	    try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	

			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
            rs.close();
            pstmt.close();

		}catch(SQLException se){
			System.out.println("[PaySearchDatabase:getCardServ]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }

	/**
	 *	보증금환불확인
	 */
    public Hashtable getGrtPay(String p_gubun, String rent_mng_id, String rent_l_cd) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		
		//해지정산환불금중 승계보증금 대체분
		query = " select b.AUTODOCU_WRITE_DATE, b.AUTODOCU_DATA_NO, \n"+
				"        a.* \n"+
				" from   pay_item a, pay b \n"+
				" where  a.p_gubun =? \n"+
				" and    a.reqseq=b.reqseq \n"+
				" and    decode(a.p_gubun,'31',a.sub_amt3,a.sub_amt2)>0\n"+
				" "; 

		if(p_gubun.equals("31") || p_gubun.equals("37")) query += " and a.p_cd1='"+rent_mng_id+"' and a.p_cd2='"+rent_l_cd+"' ";
		if(p_gubun.equals("33")) query += " and a.p_cd1||a.p_cd3 like '%"+rent_mng_id+"%' and a.p_cd2||a.p_cd4 like '%"+rent_l_cd+"%' ";

	    try{
            pstmt = con.prepareStatement(query);
			pstmt.setString(1, p_gubun);
            rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	

			if(rs.next())
			{								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++)
				{
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
            rs.close();
            pstmt.close();

		}catch(SQLException se){
			System.out.println("[PaySearchDatabase:getGrtPay]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return ht;
    }

	/**
	 *	네오엠매입세금계산서 -- 사용안함
	 */
    public Vector getNeomTax21List(String s_kd, String t_wd, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE1);//neom
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.deci_date, a.tax_no, a.c_code, \n"+
				"        c.ven_name, b.acct_code, b.note_name, b.dr_amt, b.cr_amt, a.bal_date, a.tax_gu, a.gong_amt, a.tax_vat, (a.gong_amt+a.tax_vat) tax_amt, \n"+
				"        a.s_idno, a.docu_stat, a.cardno, a.jeonja_yn \n"+
				" from   tax a, DOCUD b, vendor c \n"+
				" where  a.tax_gu='21' \n"+//--과세매입
				" and    a.deci_date=b.DECI_DATE and a.deci_no=b.deci_no and a.line_no=b.line_no \n"+
				" and    b.ven_code=c.ven_code \n"+
				" and    a.s_idno=c.s_idno"+
				" and    a.BAL_DATE > '20091231'"+
				" "; 

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		
		dt1 = "substr(a.deci_date,1,6)";
		dt2 = "a.deci_date";


		if(gubun1.equals("2"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' \n";
		else if(gubun1.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";
		else if(gubun1.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		if(!gubun2.equals(""))	query += " and a.jeonja_yn = '"+gubun2+"'"; 

		if(s_kd.equals("1"))	what = "upper(nvl(c.ven_name, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.s_idno, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(b.note_name, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(a.gong_amt, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(a.tax_vat, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') \n";
		}	

		query += " order by a.deci_date";

	    try{
            pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
			System.out.println("[PayMngDatabase:getNeomTax21List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	네오엠매출세금계산서 - 사용안함
	 */
    public Vector getNeomTax11List(String s_kd, String t_wd, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE1);//neom
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.deci_date, a.tax_no, a.c_code, \n"+
				"        c.ven_name, b.acct_code, b.note_name, b.dr_amt, b.cr_amt, a.bal_date, a.tax_gu, a.gong_amt, a.tax_vat, (a.gong_amt+a.tax_vat) tax_amt, \n"+
				"        a.s_idno, a.docu_stat, a.cardno, a.jeonja_yn \n"+
				" from   tax a, DOCUD b, vendor c \n"+
				" where  a.tax_gu='11' \n"+//--과세매출
				" and    a.deci_date=b.DECI_DATE and a.deci_no=b.deci_no and a.line_no=b.line_no \n"+
				" and    b.ven_code=c.ven_code \n"+
				" and    a.s_idno=c.s_idno"+
				" and    a.BAL_DATE > '20091231'"+
				" "; 

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		
		dt1 = "substr(a.deci_date,1,6)";
		dt2 = "a.deci_date";


		if(gubun1.equals("2"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' \n";
		else if(gubun1.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";
		else if(gubun1.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		if(!gubun2.equals(""))	query += " and a.jeonja_yn = '"+gubun2+"'"; 

		if(s_kd.equals("1"))	what = "upper(nvl(c.ven_name, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.s_idno, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(b.note_name, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(a.gong_amt, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(a.tax_vat, ' '))";	
			
		if(!what.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') \n";
		}	

		query += " order by a.deci_date";

	    try{
            pstmt = con.prepareStatement(query);
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

		}catch(SQLException se){
			System.out.println("[PayMngDatabase:getNeomTax11List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con);
			con = null;
        }
        return vt;
    }

    /**
     *	거래처 수정 -- 사용안함
     */
    public boolean updateTaxJeonjaYn(String tax_key, String jeonja_yn) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE1);//neom

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

        PreparedStatement pstmt = null;
        String query = "";
		boolean flag = true;
                
		query =" update tax set "+
				"       jeonja_yn	= ? "+
				" where deci_date||tax_no||c_code=?";


	   try{

            con.setAutoCommit(false);

			pstmt = con.prepareStatement(query);
			pstmt.setString(1,  jeonja_yn);
			pstmt.setString(2,  tax_key);
			pstmt.executeUpdate();
   
            pstmt.close();
            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE1, con);
			con = null;
        }
        return flag;
    }

	/**
	 *	사고처리마감에서 피해사고부가세 조회
	 */
    public Vector getPayAccidResultList(String car_mng_id, String accid_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " select b.p_est_dt, b.p_pay_dt, nvl(b.off_nm,b.ven_name) off_nm, a.* \n"+
				" from   pay_item a, pay b \n"+
				" where  a.P_ST1 in ('15','16','18','19') \n"+
				"        and a.reqseq=b.reqseq \n"+
				"        and a.p_cd1='"+car_mng_id+"' and a.p_cd3='"+accid_id+"' \n"+
				" "; 

		query += " order by a.reqseq";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayAccidResultList]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }
    
  //금융사 코드 1건 조회(20190701)
	public Hashtable getFinanceCode(String f_nm) throws DatabaseException, DataSourceEmptyException{
	    Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)		throw new DataSourceEmptyException("Can't get Connection !!");
	
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		query = " select * from code where c_st = '0003' and nm like '%"+f_nm+"%' ";		
	
	    try{
	        pstmt = con.prepareStatement(query);
	        rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();    	
	
			if(rs.next()){								
				for(int pos =1; pos <= rsmd.getColumnCount();pos++){
					 String columnName = rsmd.getColumnName(pos);
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
			}
	        rs.close();
	        pstmt.close();
		}catch(SQLException se){
			System.out.println("[PaySearchDatabase:getFinanceCode]"+se);
			 throw new DatabaseException();
	    }finally{
	        try{
	            if(rs != null ) rs.close();
	            if(pstmt != null) pstmt.close();
	        }catch(SQLException _ignored){}
	        connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
	    }
	    return ht;
	}
	
	//금융사코드 1건 등록(20190701)
	public boolean insertFinanceCode(CodeBean bean){
		Connection conn = connMgr.getConnection(DATA_SOURCE);
	    PreparedStatement pstmt = null;
	    PreparedStatement pstmt1 = null;
	    ResultSet rs = null;
		boolean flag = true;       
	    String code_sql = "";
	    String query = "";
		String code = "";
		
		code_sql="select nvl(ltrim(to_char(to_number(MAX(code))+1, '0000')), '0001') code from code where c_st=?";
	    query = "insert into code (c_st, code, nm_cd, nm, app_st, cms_bk, etc) values (?, ?, ?, ?, ?, ?, ?)";
	
	    try{
			conn.setAutoCommit(false);
	
	        pstmt1 = conn.prepareStatement(code_sql);
			pstmt1.setString(1, bean.getC_st());
	    	rs = pstmt1.executeQuery();
	    	if(rs.next()){
	    		code=rs.getString(1);
	    	}
	        rs.close();
	        pstmt1.close();
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getC_st());		
			pstmt.setString(2, code);	
			pstmt.setString(3, bean.getNm_cd());
			pstmt.setString(4, bean.getNm());
			pstmt.setString(5, bean.getApp_st());
			pstmt.setString(6, bean.getCms_bk());
			pstmt.setString(7, bean.getGubun());
		    pstmt.executeUpdate();
	        pstmt.close();
	
			conn.commit();
	
	    }catch(Exception e){
			System.out.println("[AddMarkDatabase:insertFinanceCode]"+e);
			e.printStackTrace();
	  		flag = false;
			conn.rollback();
	    }finally{
			try{
				conn.setAutoCommit(true);
	            if(rs != null )		rs.close();
	            if(pstmt != null)	pstmt.close();
	            if(pstmt1 != null)	pstmt1.close();
			}catch(Exception ignore){}
			connMgr.freeConnection(DATA_SOURCE, conn);
			conn = null;
			return flag;
	    }
	}

	/**
	 *	47 법인카드대금(지방세말일결재) 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt47List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String base_query = "";
		String what = "";

		base_query = " select \n"+
					 "        a.cardno, b.pay_day, b.use_s_m, b.use_s_day, b.use_e_m, b.use_e_day, a.buy_dt, a.buy_amt, \n"+
					 "        decode(sign('15'-substr(a.buy_dt,7,2)),-1,to_char(add_months(to_date(a.buy_dt,'YYYYMMDD'),1),'YYYYMM')||'05',substr(a.buy_dt,1,6)||TO_CHAR(LAST_DAY(TO_DATE(a.buy_dt,'YYYYMMDD')),'DD')) pay_dt \n"+
					 " from   card_doc a, card b \n"+
					 " where  a.cardno in ('9410-8531-0252-3300','9410-8523-7439-8400') and a.cardno=b.cardno  and nvl(b.card_paid,'0')<>'7' \n"+
					 "        and a.cardno<>'0000-0000-0000-0000' AND NVL(a.app_id,'-') NOT IN ('cancel','cance0')\n"+
					 "        and a.buy_dt >= '20100801' and b.card_name like '%지방세%' \n"+
					 "        and sign('15'-substr(a.buy_dt,7,2)) in (0,1) \n"+  //1~15 : 당월말일 납부
					 "        and a.reg_dt not in ('20120402','20120403')"+ 	
					 " ";

		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.est_dt as p_cd1, a.cardno as p_cd2, '' as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '47' as p_st1, '법인카드대금(지방세말일결재)' as p_st2, '계좌이체' as p_st3, b.card_name as p_st4, '' as p_st5, \n"+

				"        'com_code' as off_st, b.com_code as off_id, b.com_name as off_nm, '' off_tel, \n"+
				"        b.com_code as ven_code, b.com_name as ven_name, \n"+

				"        a.est_dt, a.est_amt as amt, \n"+

			    "        '' bank_id, '' bank_nm, '' bank_no, \n"+

				"		 '' a_bank_id, \n"+
				"	     '' as a_bank_nm, b.acc_no as a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        substr(a.est_dt,5,2)||'월 지방세 카드대금 '||b.card_name as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, '' s_idno, \n"+

				"	     '25300' acct_code, b.com_name as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   ( select cardno, pay_dt as est_dt, sum(buy_amt) est_amt \n"+
				"		   from ( "+base_query+" ) \n"+
				"          group by cardno, pay_dt \n"+
				"        ) a, "+
				"        card b, pay_item p \n"+
				" where  a.cardno=b.cardno \n"+
				"        and '47'=p.p_st1(+) and a.est_dt=p.p_cd1(+) and a.cardno=p.p_cd2(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.card_kind||b.card_name like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.est_dt like replace('"+st_dt+"%', '-','')";


		query += " order by a.est_dt";

	    try{
            pstmt = con.prepareStatement(query);
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

        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt47List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }

	/**
	 *	48 법인카드대금(지방세익월8일결재) 지급예정 리스트 조회
	 */
    public Vector getPayEstAmt48List(String s_kd, String t_wd, String st_dt, String pay_off, String yet_again) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String base_query = "";
		String what = "";

		base_query = " select \n"+
					 "        a.cardno, b.pay_day, b.use_s_m, b.use_s_day, b.use_e_m, b.use_e_day, a.buy_dt, a.buy_amt, \n"+
					 "        decode(sign('15'-substr(a.buy_dt,7,2)),-1,to_char(add_months(to_date(a.buy_dt,'YYYYMMDD'),1),'YYYYMM')||'08') pay_dt \n"+
					 " from   card_doc a, card b \n"+
					 " where  a.cardno in ('9410-8531-0252-3300','9410-8523-7439-8400') and a.cardno=b.cardno  and nvl(b.card_paid,'0')<>'7' \n"+
					 "        and a.cardno<>'0000-0000-0000-0000' AND NVL(a.app_id,'-') NOT IN ('cancel','cance0')\n"+
					 "        and a.buy_dt >= '20100801' and b.card_name like '%지방세%' \n"+
					 "        and sign('15'-substr(a.buy_dt,7,2)) in (-1) \n"+ //16~말일 익월8일
					 "        and a.reg_dt not in ('20120402','20120403')"+ 	
					 " ";

		query = " select  /*+ rule */ \n"+
				"        '5' as p_way, \n"+
				"        a.est_dt as p_cd1, a.cardno as p_cd2, '' as p_cd3, '' as p_cd4, '' as p_cd5, \n"+
				"        '48' as p_st1, '법인카드대금(지방세익월8일결재)' as p_st2, '계좌이체' as p_st3, b.card_name as p_st4, '' as p_st5, \n"+

				"        'com_code' as off_st, b.com_code as off_id, b.com_name as off_nm, '' off_tel, \n"+
				"        b.com_code as ven_code, b.com_name as ven_name, \n"+

				"        a.est_dt, a.est_amt as amt, \n"+

			    "        '' bank_id, '' bank_nm, '' bank_no, \n"+

				"		 '' a_bank_id, \n"+
				"	     '' as a_bank_nm, b.acc_no as a_bank_no, \n"+

				"        '' card_id, '' card_nm, '' card_no, \n"+

				"        substr(a.est_dt,5,2)||'월 지방세 카드대금 '||b.card_name as p_cont, \n"+

				"        0 sub_amt1, 0 sub_amt2, 0 sub_amt3, 0 sub_amt4, 0 sub_amt5, 0 sub_amt6, '' buy_user_id, '' s_idno, \n"+

				"	     '25300' acct_code, b.com_name as bank_acc_nm, '' bank_cms_bk, '' a_bank_cms_bk \n"+

				" from   ( select cardno, pay_dt as est_dt, sum(buy_amt) est_amt \n"+
				"		   from ( "+base_query+" ) \n"+
				"          group by cardno, pay_dt \n"+
				"        ) a, "+
				"        card b, pay_item p \n"+
				" where  a.cardno=b.cardno \n"+
				"        and '48'=p.p_st1(+) and a.est_dt=p.p_cd1(+) and a.cardno=p.p_cd2(+)"+
				" "; 

		if(!yet_again.equals("Y"))	query += " and p.reqseq is null \n";

		if(!pay_off.equals(""))	query += " and b.card_kind||b.card_name like '%"+pay_off+"%' \n";

		if(!st_dt.equals(""))   query += " and a.est_dt = replace('"+st_dt+"', '-','')";


		query += " order by a.est_dt";

	    try{
            pstmt = con.prepareStatement(query);
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



        }catch(SQLException se){
			System.out.println("[PaySearchDatabase:getPayEstAmt48List]"+se);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return vt;
    }	
}

