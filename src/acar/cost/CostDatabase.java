package acar.cost;

import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.util.*;

public class CostDatabase
{
	private Connection conn = null;
	public static CostDatabase db;
	
	public static CostDatabase getInstance()
	{
		if(CostDatabase.db == null)
			CostDatabase.db = new CostDatabase();
		return CostDatabase.db;
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
	

	//부채현황-------------------------------------------------------------------------------------

	/**
	 *	당일기준 조회
	 */
	public Vector getStatDebt(String br_id, String save_dt, String st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query1 = "";
		String query2 = "";
		String sub_qu = "";
		if(st.equals("1"))		sub_qu = " and c.cpt_cd between '0001' and '0007' ";
		else if(st.equals("2"))	sub_qu = " and ( c.cpt_cd between '0008' and '0015' or c.cpt_cd in ('0018','0020','0030','0038','0039','0040') )";
		else if(st.equals("3"))	sub_qu = " and c.cpt_cd in ('0016', '0017', '0021')";

		String b_ym = "";
		String a_ym = "";
		String a_ymd = "";
		b_ym = "to_char(add_months(sysdate,-1),'YYYY-MM')";//전월
		a_ym = "to_char(sysdate,'YYYY-MM')";//현재월
		a_ymd = "to_char(sysdate, 'YYYY-MM-DD')";//현재일자

/*		if(1==1){
			b_ym = "'2007-07'";//전월
			a_ym = "'2007-08'";//현재월
			a_ymd = "'2007-08-23'";//현재일자
		}
*/

		String seq = "decode(cpt_cd, '0005',1,'0001',2,'0007',3,'0002',4,'0004',5,'0010',6,'0009',7,'0030','8','0014',9,'0018',10,'0011',11,'0013',12,'0012',13,'0020',14,'0016',15)";

		query1= " select"+
				" c.cpt_cd, nvl(a.last_mon_amt,0) last_mon_amt, nvl(b.this_mon_new_amt,0) this_mon_new_amt,"+
				" nvl(c.this_mon_plan_amt,0) this_mon_plan_amt, nvl(d.this_mon_pay_amt,0) this_mon_pay_amt, 0 whan_amt,"+
				" nvl(c.this_mon_plan_int_amt,0) this_mon_plan_int_amt, nvl(d.this_mon_pay_int_amt,0) this_mon_pay_int_amt, 0 this_mon_jan_amt "+
				" from"+
				"	(select "+seq+" seq, cpt_cd, sum(alt_prn) this_mon_plan_amt, sum(alt_int) this_mon_plan_int_amt from debt_pay_view where substr(alt_est_dt,1,7) = "+a_ym+" group by cpt_cd) c,"+
				"	(select decode(a.cpt_cd, '0005',1,'0001',2,'0007',3,'0002',4,'0004',5,'0010',6,'0009',7,'0030','8','0014',9,'0018',10,'0011',11,'0013',12,'0012',13,'0020',14,'0016',15) seq, a.cpt_cd, sum(a.alt_rest) last_mon_amt"+
				"	from debt_pay_view a, (select gubun, rent_l_cd, rtn_seq, max(alt_tm) alt_tm from debt_pay_view where substr(alt_est_dt,1,7) = "+b_ym+" group by gubun, rent_l_cd, rtn_seq) b "+ 
				"	where a.gubun=b.gubun and a.rent_l_cd=b.rent_l_cd and nvl(a.rtn_seq,'0')=nvl(b.rtn_seq,'0') and a.alt_tm=b.alt_tm and substr(a.alt_est_dt,1,7) = "+b_ym+" group by a.cpt_cd) a,"+
				"	(select "+seq+" seq, cpt_cd, sum(alt_rest) this_mon_new_amt from debt_pay_view where substr(alt_est_dt,1,7) = "+a_ym+" and alt_tm='0' group by cpt_cd) b,"+
				"	(select "+seq+" seq, cpt_cd, sum(alt_prn) this_mon_pay_amt, sum(alt_int) this_mon_pay_int_amt from debt_pay_view where substr(alt_est_dt,1,7) = "+a_ym+" and alt_est_dt <= "+a_ymd+" group by cpt_cd) d"+//pay_yn='1' 
				" where c.cpt_cd=a.cpt_cd(+) and c.cpt_cd=b.cpt_cd(+) and c.cpt_cd=d.cpt_cd(+)"+
				sub_qu+
				" order by c.seq";


		query2= " select * from stat_debt c where c.save_dt='"+save_dt+"' "+ sub_qu;


		try {
			if(save_dt.equals("")){
				pstmt = conn.prepareStatement(query1);
			}else{
				pstmt = conn.prepareStatement(query2);
			}

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
			System.out.println("[CostDatabase:getStatDebt]"+e);
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
	 *	사원별 비용지출 현황
 	 */
	public Vector getDlyCostStat(String dt, String ref_dt1, String ref_dt2)
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
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}
		

		query = " select z.user_nm, z.dept_id, z.user_id, z.enter_dt, c.cnt0, c.cnt, i.cnt1, j.amt1, k.cnt2, l.amt2, m.cnt3, n.amt3, r.cnt7, p.amt7, t.cnt8, s.amt8, q.amt10, v.amt11, jj.a_amt1, jj.l_amt1, ll.a_amt2, ll.l_amt2, nn.a_amt3, nn.l_amt3, pp.amt13, qq.amt14 \n"+ 
				" from\n"+
				//-- 관리대수
				" (select decode(a.bus_id2,'000037',a.mng_id, a.bus_id2) as user_id, count(decode(a.rent_way, '일반식', a.rent_l_cd)) cnt0, count(*) cnt from cont_n_view a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')  group by decode(a.bus_id2,'000037',a.mng_id, a.bus_id2) ) c,\n"+
				//--일반수리  건수
				" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt1 from cont_n_view a, service b, cont c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd  and a.client_id not in ('000231', '000228') and b.serv_st ='2' and ( a.rent_way='일반식' or a.rent_way='기본식' and c.car_gu='1' ) and b.serv_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and b.tot_amt > 0 group by a.bus_id2  ) i,\n"+
				//--일반수리 금액
				" (select nvl(a.bus_id2,'999999') as user_id, sum(b.tot_amt) amt1 from cont_n_view a, service b, cont c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.client_id not in ('000231', '000228') and b.serv_st ='2' and ( a.rent_way='일반식' or a.rent_way='기본식' and c.car_gu='1' ) and b.serv_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') group by a.bus_id2 ) j,\n"+
				//--a/s  건수
				" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt2 from cont_n_view a, service b, cont c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd   and a.client_id not in ('000231', '000228') and b.serv_st = '2' and a.rent_way='기본식' and c.car_gu = '0'  and b.serv_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and b.tot_amt > 0 group by a.bus_id2 ) k,\n"+
				//--a/s 금액
				" (select nvl(a.bus_id2,'999999') as user_id, sum(b.tot_amt) amt2 from cont_n_view a, service b, cont c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd  and a.client_id not in ('000231', '000228') and b.serv_st = '2' and a.rent_way ='기본식' and c.car_gu = '0' and  b.serv_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') group by a.bus_id2 ) l,\n"+
				//--사고수리  건수
				" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt3 from cont_n_view a, service b, accident ac, ( select car_mng_id, max(ins_st) ins_st , ins_sts , con_f_nm  from insur group by car_mng_id , ins_sts , con_f_nm ) i where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and  a.client_id not in ('000231', '000228') and b.serv_st in ('4', '5') and b.car_mng_id = ac.car_mng_id(+) and b.accid_id = ac.accid_id(+) and  b.car_mng_id = i.car_mng_id and i.ins_sts = '1' and con_f_nm like '%아마존카%' and b.serv_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and (b.tot_amt * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) > 0  group by a.bus_id2  ) m,\n"+
				//--사고수리 금액
				" (select nvl(a.bus_id2,'999999') as user_id,  sum(b.tot_amt * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) amt3 from cont_n_view a, service b, accident ac, ( select car_mng_id, max(ins_st) ins_st , ins_sts , con_f_nm  from insur group by car_mng_id , ins_sts , con_f_nm ) i  where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.client_id not in ('000231', '000228') and b.serv_st in ('4', '5') and b.car_mng_id = ac.car_mng_id(+) and b.accid_id = ac.accid_id(+) and b.car_mng_id = i.car_mng_id and i.ins_sts = '1' and con_f_nm like '%아마존카%' and b.serv_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and (b.tot_amt * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) > 0 group by a.bus_id2 ) n,\n"+
				//--유류비 건수
				" (select nvl(a.buy_user_id,'999999') as user_id, count(*) cnt7 from card_doc a where  a.acct_code = '00004' and a.acct_code_g2 in ('12', '13') and a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') group by a.buy_user_id ) r,\n"+
				//--유류비 금액
				" (select nvl(a.buy_user_id,'999999') as user_id, sum(a.buy_amt) amt7 from card_doc a where    a.acct_code = '00004' and a.acct_code_g2 in ('12', '13') and a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') group by a.buy_user_id ) p,\n"+
				//--고객분담금  건수
				" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt8 from cont_n_view a, service b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  and a.client_id not in ('000231', '000228') and (nvl(b.cust_amt,0) + nvl(b.ext_amt,0)) > 0 and b.serv_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') group by a.bus_id2  ) t,\n"+
				//--고객분담금 금액
				" (select nvl(a.bus_id2,'999999') as user_id, sum(nvl(b.cust_amt,0)+nvl(b.ext_amt,0)) amt8 from cont_n_view a, service b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.client_id not in ('000231', '000228') and (nvl(b.cust_amt,0) + nvl(b.ext_amt,0)) > 0 and b.serv_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') group by a.bus_id2 ) s,\n"+
				//--유류비 (활동비)
				" (select nvl(a.buy_user_id,'999999') as user_id, sum(a.buy_amt) amt10 from card_doc a where    a.acct_code = '00004' and a.acct_code_g2 = '11' and a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') group by a.buy_user_id ) q,\n"+
				//--영업수당 
				" (select nvl(a.bus_id,'999999') as user_id, sum(b.commi) amt11 from cont_n_view a, commi b where a.rent_mng_id= b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and  b.commi_st = '1'  and b.sup_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') group by a.bus_id ) v,\n"+
				//--일반수리 부품, 공임
				" (select nvl(a.bus_id2,'999999') as user_id, sum(i.amt) a_amt1, sum(i.labor) l_amt1 from cont_n_view a, service b, cont c, serv_item i  where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd  and b.car_mng_id = i.car_mng_id and b.serv_id = i.serv_id and a.client_id not in ('000231', '000228') and b.serv_st ='2' and ( a.rent_way='일반식' or a.rent_way='기본식' and c.car_gu='1' ) and b.serv_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') group by a.bus_id2 ) jj,\n"+
				//--a/s(재리스) 부품, 공임
			    " (select nvl(a.bus_id2,'999999') as user_id, sum(i.amt) a_amt2, sum(i.labor) l_amt2 from cont_n_view a, service b, cont c, serv_item i  where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd  and b.car_mng_id = i.car_mng_id and b.serv_id = i.serv_id and a.client_id not in ('000231', '000228') and b.serv_st ='2' and a.rent_way ='기본식' and c.car_gu = '0' and b.serv_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') group by a.bus_id2 ) ll,\n"+
				//--사고수리 부품, 공임
				" (select nvl(a.bus_id2,'999999') as user_id,  sum(ii.amt * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) a_amt3, sum(ii.labor * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) l_amt3 from cont_n_view a, service b, accident ac, ( select car_mng_id, max(ins_st) ins_st , ins_sts , con_f_nm  from insur group by car_mng_id , ins_sts , con_f_nm ) i, serv_item ii where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id = ii.car_mng_id and b.serv_id = ii.serv_id and a.client_id not in ('000231', '000228') and b.serv_st in ('4', '5') and b.car_mng_id = ac.car_mng_id(+) and b.accid_id = ac.accid_id(+) and b.car_mng_id = i.car_mng_id and i.ins_sts = '1' and con_f_nm like '%아마존카%' and b.serv_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and (b.tot_amt * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) > 0 group by a.bus_id2 ) nn,\n"+
				//--여비교통비
				" (select nvl(a.buy_user_id,'999999') as user_id, sum(a.buy_amt) amt13 from card_doc a where    a.acct_code = '00003' and a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') group by a.buy_user_id ) pp,\n"+
				//--탁송료 
				" (select nvl(b.reg_id,'999999') as user_id, sum(b.tot_amt) amt14 from cont_n_view a, consignment b where a.rent_mng_id= b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and  b.cost_st = '1'  and b.req_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') group by b.reg_id ) qq,\n"+
				" users z\n"+
				" where \n"+
				" c.user_id=i.user_id(+) \n"+
				" and c.user_id=j.user_id(+)  \n"+
				" and c.user_id=k.user_id(+)  \n"+
				" and c.user_id=l.user_id(+)  \n"+
				" and c.user_id=m.user_id(+)  \n"+
				" and c.user_id=n.user_id(+)  \n"+
				" and c.user_id=r.user_id(+)  \n"+
				" and c.user_id=p.user_id(+)  \n"+
				" and c.user_id=q.user_id(+)  \n"+
				" and c.user_id=s.user_id(+)  \n"+
				" and c.user_id=t.user_id(+)  \n"+
				" and c.user_id=v.user_id(+)  \n"+
				" and c.user_id=jj.user_id(+)  \n"+
				" and c.user_id=ll.user_id(+)  \n"+
				" and c.user_id=nn.user_id(+)  \n"+
				" and c.user_id=pp.user_id(+)  \n"+
				" and c.user_id=qq.user_id(+)  \n"+
			    " and c.user_id=z.user_id and z.user_pos in ('사원','대리','과장') and z.dept_id not in ('0003') and z.loan_st = '1' ";
			 //    " and c.user_id=z.user_id and z.user_pos in ('사원','대리','과장') and z.loan_st = '1'";
		
		//sort
		query += " order by z.dept_id, z.user_nm  asc ";
	
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
			System.out.println("[CostDatabase:getDlyCostStat]"+e);
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
	 *	사원별 비용지출 현황 - 고객지원팀 관리비용
 	 */
	public Vector getDlyCostStatMList(String dt, String ref_dt1, String ref_dt2, String mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		String f_date1="";
		String t_date1="";
		
		f_date1=  ref_dt1;
		t_date1=  ref_dt2;
	
	    query = " select '1' gg, a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, ca.car_nm, a.firm_nm, nvl(a.bus_id2,'999999') as user_id, a.rent_l_cd, b.serv_dt,  '일반정비비' gubun, sum( case when b.tot_amt > 600000 then 600000 else b.tot_amt end ) amt, 0 per from cont_n_view a, service b, cont c , car_reg cr  where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd  and a.car_mng_id = cr.car_mng_id and  a.client_id not in ('000231', '000228') and b.serv_st ='2' and ( a.rent_way='일반식'  or a.rent_way='기본식' )  and c.car_gu <> '0'  and nvl(a.bus_id4, a.bus_id2)   = '" + mng_id + "' and  b.serv_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and b.serv_dt >= replace(a.rent_start_dt, '-', '') and nvl(b.tot_amt, 0) > 0 \n"+ 
 			   " group by  a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, cr.car_nm, a.firm_nm, nvl(a.bus_id2,'999999') , a.rent_l_cd, b.serv_dt \n"+ 
 			   " 	union all \n"+ 
			   " select '2' gg, a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no,cra.car_nm, a.firm_nm, nvl(a.bus_id2,'999999') as user_id, a.rent_l_cd, b.serv_dt,  'A/S(재리스)' gubun, sum(b.tot_amt) amt,  0 per from contn__view a, service b, cont c, car_reg cr  where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.car_mng_id = cr.car_mng_id and  a.client_id not in ('000231', '000228') and b.serv_st = '2' and (a.rent_way='일반식'  or a.rent_way='기본식' ) and c.car_gu = '0' and nvl(a.bus_id4, a.bus_id2)   = '" + mng_id + "' and b.serv_dt >= replace(a.rent_start_dt, '-', '') and  b.serv_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and nvl(b.tot_amt, 0) > 0 \n"+ 
 			   " group by  a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, cr.car_nm, a.firm_nm, nvl(a.bus_id2,'999999') , a.rent_l_cd, b.serv_dt  \n"+ 
 			   " 	union all \n"+ 
			   " select '3' gg, a.use_yn, a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, cr.car_nm, a.firm_nm, nvl(a.bus_id2,'999999') as user_id, a.rent_l_cd, b.serv_dt,  '사고수리비' gubun, sum(case  when  (decode(nvl(b.r_j_amt,0), 0,(b.r_labor+b.r_j_amt)*1.1, b.tot_amt ) * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.ext_amt,0)*1.1)) > 2000000  then 2000000 + (((decode(nvl(b.r_j_amt,0), 0,(b.r_labor+b.r_j_amt)*1.1, b.tot_amt ) * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.ext_amt,0)*1.1)) - 2000000)*20/100)  else  ( decode( nvl(b.r_j_amt,0), 0,(b.r_labor+b.r_j_amt)*1.1, b.tot_amt ) * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.ext_amt,0)*1.1) ) end) amt, decode(ac.accid_st, '4', 100, ac.our_fault_per) per from cont_n_view a, service b, car_reg cr,  accident ac,  ( select car_mng_id, max(ins_st) ins_st , ins_sts , con_f_nm  from insur group by car_mng_id , ins_sts , con_f_nm ) i  where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id = cr.car_mng_id  and  a.client_id not in ('000231', '000228') and b.serv_st in ('4', '5') and b.car_mng_id = ac.car_mng_id(+) and b.accid_id = ac.accid_id(+) and b.car_mng_id = i.car_mng_id and i.ins_sts = '1' and con_f_nm like '%아마존카%' and nvl(a.bus_id4, a.bus_id2)   = '" + mng_id + "' and b.serv_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and b.serv_dt >= replace(a.rent_start_dt, '-', '') and  (decode(nvl(b.r_j_amt,0), 0,(b.r_labor+b.r_j_amt)*1.1, b.tot_amt ) * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) > 0 \n" +
   			   " group by  a.use_yn, a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, cr.car_nm, a.firm_nm, nvl(a.bus_id2,'999999') , a.rent_l_cd, b.serv_dt , decode(ac.accid_st, '4', 100, ac.our_fault_per) \n" +
   			   " 	union all \n"+ 
   			   " select '4' gg,  v.use_yn use_yn, c.dpm car_st, a.rent_s_cd rent_l_cd, substr(a.deli_dt, 1,8) rent_way, c.car_no, cr.car_nm, v.firm_nm, nvl(v.bus_id2,'999999') as user_id,  a.rent_s_cd rent_l_cd,  substr(a.ret_dt,1,8) serv_dt, '대차비용' gubun,\n"+ 
   			   " case when to_number(c.dpm) < 2000 then   (case when trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8))) +1 ) > 10 then 10 else trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8)))+1) end)  * 20000 \n"+ 
               "      when to_number(c.dpm) >=2700 then   (case when trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8))) +1 ) > 10 then 10 else trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8)))+1) end)  * 40000 \n"+ 
               "      else  (case when trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8))) +1 ) > 10 then 10 else trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8)))+1) end) * 30000 end amt,  \n"+ 
               " case when trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8))) +1 ) > 10 then 10 else trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8)))+1) end  per \n"+ 
               "  from RENT_CONT a, CAR_REG c, users u, cont_n_view v \n"+ 
               "  where a.use_st  in ('2' , '3', '4' )  and a.car_mng_id=c.car_mng_id  and a.rent_st in ('2', '3', '8','9') \n"+ 
               "  and nvl(v.bus_id4, v.bus_id2) = '" + mng_id + "' and a.deli_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n"+ 
               "  and a.sub_l_cd = v.rent_l_cd(+)  and a.bus_id=u.user_id and u.user_pos in ('사원','대리','과장') and  u.loan_st = '1' \n"+  
   		  	   " 	union all \n"+ 
   		  	   "  select  '5' gg, b.use_yn,  b.car_st, b.rent_l_cd, b.rent_way, cr.car_no, cr.car_nm, b.firm_nm, nvl(b.bus_id4, b.bus_id2) as user_id, b.rent_l_cd, e.pay_dt, '휴/대차료' gubun, e.pay_amt as amt, 0 per 	from accident a, cont_n_view b, my_accid e  \n"+ 
   			   "	where e.req_st in ('1' , '2')  and e.car_mng_id=a.car_mng_id and e.accid_id=a.accid_id and a.car_mng_id=b.car_mng_id  and nvl(b.bus_id4, b.bus_id2)   = '" + mng_id + "' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd   and a.car_mng_id = cr.car_mng_id and e.pay_dt  between  replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') "; 
       			   
	  	query += "  order by gg, rent_way, serv_dt ";
	  	
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
			System.out.println("[CostDatabase:getDlyCostStatMList]"+e);
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
	 *	사원별 비용지출 현황 
 	 */
 	
	public Vector getDlyCostStatMList(String dt, String ref_dt1, String ref_dt2, String mng_id, int amt1, int amt2, int amt1_per , int amt2_per, int amt3_per, int bus_cost_per, int mng_cost_per )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		String f_date1="";
		String t_date1="";
		
		f_date1=  ref_dt1;
		t_date1=  ref_dt2;
	 	
 			//신차 정비 
 	   query = "  select /*+ leading(b) merge(a) */ '01' gg, a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, cr.car_nm, a.firm_nm, '' user_id, c.serv_dt, '일반정비비' gubun, sum(c.bus_amt + c.mng_amt ) amt, 0 per from ( \n" +
          	   "  	select /*+ leading(b) merge(a) */ b.rent_mng_id, b.rent_l_cd,  a.bus_id, a.mng_id, nvl(b.serv_dt, b.reg_dt) serv_dt, \n"+
               "		decode( a.bus_id, '" + mng_id + "', ( sum ( case when decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)) > "+ amt1+"  then "+ amt1 + " + ((decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt) ) - "+amt1+")*"+amt1_per+"/100)  else  decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)) end) * "+bus_cost_per+"/ 100 ) , 0 ) bus_amt,  \n"+
               "  		decode( a.mng_id, '" + mng_id + "', ( sum ( case when decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)) > "+ amt1+"  then "+ amt1 + " + ((decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt) ) - "+amt1+")*"+amt1_per+"/100)  else  decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)) end) * "+mng_cost_per+"/ 100 ) , 0 )  mng_amt    \n"+  
			   "       from cont_n_view a, service b \n"+
			   "       where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.client_id not in ('000231', '000228') \n"+
			   "       and b.serv_st not in ('11', '4', '5')  and a.car_gu  = '1'  \n"+
			   "       and nvl(b.serv_dt, b.reg_dt) between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and replace(a.rent_start_dt, '-', '') <= nvl(b.serv_dt, b.reg_dt)  \n"+
			   "       and (a.bus_id = '" + mng_id + "' or  nvl(a.bus_id4, a.bus_id2) = '" + mng_id + "' )  \n"+
			   "	   and nvl(decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)*1.1 ), 0) > 0  \n"+
			   "       group by b.rent_mng_id, b.rent_l_cd,  a.bus_id, a.mng_id , nvl(b.serv_dt, b.reg_dt) \n"+
			   ") c, cont_n_view a , car_reg cr \n"+ 
			   "where c.rent_mng_id = a.rent_mng_id and c.rent_l_cd = a.rent_l_cd  and a.car_mng_id = cr.car_mng_id\n"+ 
			   "group by  a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, cr.car_nm, a.firm_nm, c.serv_dt  \n"+ 		
			 
 				//재리스 일반식
 			   " 	union all \n"+	
 			   "  select /*+ leading(b) merge(a) */ '01' gg, a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, cr.car_nm, a.firm_nm, '' user_id, c.serv_dt, '일반정비비' gubun, sum(c.bus_amt + c.mng_amt ) amt, 0 per from ( \n" +
          	   "  	select /*+ leading(b) merge(a) */ b.rent_mng_id, b.rent_l_cd,  a.bus_id, a.mng_id, nvl(b.serv_dt, b.reg_dt) serv_dt, \n"+
               "		decode( a.bus_id, '" + mng_id + "', ( sum ( case when decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)) > "+ amt1+"  then "+ amt1 + " + ((decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt) ) - "+amt1+")*"+amt1_per+"/100)  else  decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)) end) * "+bus_cost_per+"/ 100 ) , 0 ) bus_amt,  \n"+
               "  		decode( a.mng_id, '" + mng_id + "', ( sum ( case when decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)) > "+ amt1+"  then "+ amt1 + " + ((decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt) ) - "+amt1+")*"+amt1_per+"/100)  else  decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)) end) * "+mng_cost_per+"/ 100 ) , 0 )  mng_amt    \n"+  
			   "       from cont_n_view a, service b \n"+
			   "       where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.client_id not in ('000231', '000228') \n"+
			   "       and b.serv_st not in ('11', '4', '5')  and a.car_gu  = '0' and a.rent_way ='일반식'  \n"+
			   " 	   and nvl(b.serv_dt, b.reg_dt)  >= to_char(add_months(to_date(a.rent_start_dt), 2), 'yyyymmdd') and nvl(b.serv_dt, b.reg_dt) between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and replace(a.rent_start_dt, '-', '') <= nvl(b.serv_dt, b.reg_dt) \n"+
			   "       and (a.bus_id = '" + mng_id + "' or  nvl(a.bus_id4, a.bus_id2)  = '" + mng_id + "' )  \n"+
			   "	   and nvl(decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)*1.1 ), 0) > 0  \n"+
			   "       group by b.rent_mng_id, b.rent_l_cd,  a.bus_id, a.mng_id , nvl(b.serv_dt, b.reg_dt) \n"+
			   ") c, cont_n_view a , car_reg cr \n"+ 
			   "where c.rent_mng_id = a.rent_mng_id and c.rent_l_cd = a.rent_l_cd and a.car_mng_id = cr.car_mng_id \n"+ 
			   "group by  a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, cr.car_nm, a.firm_nm, c.serv_dt  \n"+ 		
		  
 			    " 	union all \n"+  		  			       
			   " select '03' gg, 'Y' use_yn, '' car_st, '자동차검사' rent_l_cd,  '자동차검사' rent_way, a.item_name car_no, b.car_nm car_nm , substr(a.acct_cont,1, 10) firm_nm, nvl(a.buy_user_id,'999999') as user_id,  a.buy_dt serv_dt,  \n"+ 
    		   "  '자동차검사' gubun , a.buy_amt amt , 0 per  \n"+ 
       		   " from card_doc a, car_reg b where   a.acct_code = '00005' and a.acct_code_g = '7' and a.acct_cont not like '%아마존카%' and nvl(a.buy_user_id,'999999')  = '" + mng_id + "' and a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and a.item_code = b.car_mng_id(+)  \n"+ 
       		   " 	union all \n"+ 
       		   " select '03' gg, a.use_yn,  a.car_st, a.rent_l_cd, '마스타검사' rent_way, cr.car_no, cr.car_nm, a.firm_nm, b.bus_id as user_id, b.js_dt serv_dt,   \n"+  
			   "  '자동차검사' gubun, b.sbgb_amt amt, 0 per  from cont_n_view a, master_car b , car_reg cr  \n"+  
			   "   where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  and a.car_mng_id = cr.car_mng_id and b.sbshm = '1' and a.car_st <>'2'  \n"+ 
			   "     and b.bus_id  = '" + mng_id + "' and  b.js_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n"+ 
			   " 	union all \n"+ 
       		   " select '03' gg, a.use_yn,  a.car_st, a.rent_l_cd, '성수검사' rent_way, cr.car_no, cr.car_nm, a.firm_nm, b.mng_id as user_id, b.che_dt serv_dt,   \n"+  
			   "  '자동차검사' gubun, b.che_amt amt, 0 per  from cont_n_view a, car_maint_req b , car_reg cr  \n"+  
			   "   where a.rent_l_cd=b.rent_l_cd and a.car_st <>'2'  and a.car_mng_id = cr.car_mng_id \n"+ 
			   "     and a.mng_id  = '" + mng_id + "' and  b.che_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n"+ 
			   " union all \n"+    
				  
   			  	   //사고     	
 			   " select /*+ leading(b) merge(a) */ '04' gg, a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, cr.car_nm, a.firm_nm, '' user_id, c.serv_dt, '사고수리비' gubun, sum(c.bus_amt + c.mng_amt ) amt, c.per per from (  \n"+ 
          	   "  	select /*+ leading(b) merge(a) */ b.rent_mng_id, b.rent_l_cd,  a.bus_id, nvl(ac.bus_id2, nvl(a.bus_id4, a.mng_id)) mng_id  , nvl(b.serv_dt, b.reg_dt) serv_dt,  \n"+ 
               "		    decode( a.bus_id, '" + mng_id + "', ( sum( case  when  (b.tot_amt * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) > "+ amt2+" then "+ amt2 + " + ( (((b.tot_amt * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1))  - "+amt2+"))*"+amt2_per+"/100)   else  ( b.tot_amt * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) end) * "+bus_cost_per+"/ 100 ) , 0 ) bus_amt,   \n"+ 
               "  		    decode( nvl(ac.bus_id2, nvl(a.bus_id4, a.mng_id)) , '" + mng_id + "', ( sum( case  when  (b.tot_amt * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) > "+ amt2+" then "+ amt2 + " + ( ((( b.tot_amt * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1))  - "+amt2+"))*"+amt2_per+"/100)   else  ( b.tot_amt * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) end) * "+mng_cost_per+"/ 100 ) , 0 ) mng_amt,    \n"+    
			   "            decode( ac.accid_st, '4', 100, nvl(ac.our_fault_per,100)) per      \n"+ 
               "      from cont_n_view a, service b ,  accident ac  \n"+ 
			   "       where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.client_id not in ('000231', '000228')   \n"+ 
               "       and b.car_mng_id = ac.car_mng_id(+) and b.accid_id = ac.accid_id(+)   \n"+ 
			   "       and b.serv_st in ('4', '5')   \n"+ 
			   "       and nvl(b.serv_dt, b.reg_dt) between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and replace(a.rent_start_dt, '-', '') <= nvl(b.serv_dt, b.reg_dt)   \n"+ 
			   "       and (a.bus_id = '" + mng_id + "' or  nvl(ac.bus_id2, nvl(a.bus_id4, a.mng_id))  = '" + mng_id + "' )  \n"+ 			
			   "       group by b.rent_mng_id, b.rent_l_cd,  a.bus_id, nvl(ac.bus_id2, nvl(a.bus_id4, a.mng_id))  , nvl(b.serv_dt, b.reg_dt) , decode(ac.accid_st, '4', 100, nvl(ac.our_fault_per,100))  \n"+ 
			   ") c, cont_n_view a, car_reg cr  \n"+ 
			   " where c.rent_mng_id = a.rent_mng_id and c.rent_l_cd = a.rent_l_cd and a.car_mng_id = cr.car_mng_id   \n"+ 
			   " group by  a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, cr.car_nm, a.firm_nm, c.serv_dt , c.per  	 \n"+ 	
			     			  
   			     //사고폐차    
   			   " 	union all \n"+	   
			   " select /*+ leading(b) merge(a) */ '04' gg, a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no,  cr.car_nm, a.firm_nm, '' user_id, c.serv_dt, '폐차' gubun, sum(c.bus_amt + c.mng_amt ) amt, 100 per from (    \n"+  				 
			   "	   select  c.rent_mng_id, c.rent_l_cd, c.bus_id , c.mng_id,  c.rent_way, a.serv_dt ,  \n"+ 
			   "	    decode( c.bus_id,  '" + mng_id + "', ( sum( case  when  (a.sh_car_amt - a.sale_amt ) > "+ amt2+" then "+ amt2+" + ( (a.sh_car_amt - a.sale_amt -  "+ amt2+" )* "+amt2_per+"/100)  else  ( a.sh_car_amt - a.sale_amt ) end ) * "+bus_cost_per+"/ 100 ) , 0 ) bus_amt,  \n"+ 
			   "		decode( c.mng_id,  '" + mng_id + "', ( sum( case  when  (a.sh_car_amt - a.sale_amt ) > "+ amt2+" then "+ amt2+" + ( (a.sh_car_amt - a.sale_amt -  "+ amt2+" )* "+amt2_per+"/100)  else  ( a.sh_car_amt - a.sale_amt ) end ) * "+mng_cost_per+"/ 100 ) , 0 ) mng_amt  \n"+ 
			   "	   from (  \n"+ 
			   "	        select  /*+  merge(v) */ v.rent_mng_id , v.rent_l_cd, fm.sh_car_amt , fm.sale_amt , m.car_mng_id , fm.assch_date serv_dt  \n"+ 
			   "	          from  fassetmove fm, fassetma m , cont_n_view  v , (select car_mng_id, max(rent_dt) rent_dt from cont_n_view group by car_mng_id ) c    \n"+ 
			   "	          where fm.assch_date between  replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and   fm.assch_type = '3' and fm.asset_code = m.asset_code  \n"+ 
			   "	            and ( fm.assch_rmk = '폐차' or fm.asset_code = 'A003391') and m.car_mng_id =  v.car_mng_id and v.car_mng_id = c.car_mng_id and v.rent_dt = c.rent_dt ) a, cont_n_view c  \n"+ 
			   "	    where a.rent_mng_id =c.rent_mng_id and a.car_mng_id = c.car_mng_id and c.car_st <> '2'   \n"+ 
			   "	     and (c.bus_id = '" + mng_id + "' or c.mng_id = '" + mng_id + "' )  	 \n"+ 
			   "	    group by  c.rent_mng_id, c.rent_l_cd,  c.bus_id , c.mng_id , c.rent_way , a.serv_dt  \n"+ 
			   "	  ) c, cont_n_view a  , car_reg cr    \n"+ 
			   "	  where c.rent_mng_id = a.rent_mng_id and c.rent_l_cd = a.rent_l_cd  and a.car_mng_id = cr.car_mng_id   \n"+ 
			   "	 group by  a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, cr.car_nm, a.firm_nm , c.serv_dt  \n"+               
   		
   		  	   //대차비용		  	
   		  	   " 	union all \n"+ 
   		  	   " select  /*+ leading(b) merge(a) */ '05' gg,  v.use_yn use_yn, c.dpm car_st, a.rent_s_cd|| ' ' || decode(a.rent_st , '2', '정비', '3', '사고', '8', '수리', '9', '보험' )  rent_l_cd, substr(a.deli_dt, 1,8) rent_way, c.car_no,  \n"+
               "    c.car_nm, v.firm_nm, nvl(v.bus_id4, v.mng_id) as user_id,   substr(a.ret_dt,1,8) serv_dt, '대차비용' gubun,  \n"+
   			   "  ( case when v.car_gu = 0 and decode(v.rent_way_cd, '1', '1' , '2') <> '1' and a.rent_st = '2' then 0   \n"+
               "         when v.car_gu = 0 and decode(v.rent_way_cd, '1', '1' , '2') = '1' and a.rent_st = '2' and substr(a.deli_dt,1,8)  < to_char(add_months(to_date(v.rent_start_dt), 2), 'yyyymmdd') then 0  \n"+
               "         else  trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8)))+1)  end ) * b.day_s_amt   amt,    \n"+
               "    case when v.car_gu = 0 and decode(v.rent_way_cd, '1', '1' , '2') <> '1' and a.rent_st = '2' then 0   \n"+
               "         when v.car_gu = 0 and decode(v.rent_way_cd, '1', '1' , '2') = '1' and a.rent_st = '2' and substr(a.deli_dt,1,8)  < to_char(add_months(to_date(v.rent_start_dt), 2), 'yyyymmdd') then 0  \n"+
               "         else  trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8)))+1)  end   per  \n"+
               " from RENT_CONT a, CAR_REG c, users u, cont_n_view v ,   \n"+
               "   (  select  a.est_ssn as car_mng_id, a.est_tel as rent_mon, a.fee_s_amt, round(a.fee_s_amt/30,-3) as day_s_amt    \n"+
               "    	from   estimate_sh a,    \n"+
               "     	    ( select est_ssn, max(est_id) est_id from estimate_sh where est_from ='res_car' and est_fax='Y' and rent_dt like to_char(sysdate,'YYYYMM')||'%' group by est_ssn ) b   \n"+
               "  	   where  a.est_from ='res_car' and a.est_fax='Y' and a.rent_dt like to_char(sysdate,'YYYYMM')||'%'    \n"+
               "  	     and    a.est_ssn=b.est_ssn and a.est_id=b.est_id ) b       \n"+       
               "  where a.use_st  in ('2' , '3', '4' )  and a.car_mng_id=c.car_mng_id  and a.rent_st in ('2', '3', '8','9')  \n"+
               "  and nvl(v.bus_id4, v.mng_id) = '" + mng_id + "' and a.deli_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')   \n"+
               "  and a.sub_l_cd = v.rent_l_cd(+)  and v.mng_id=u.user_id and u.user_pos in ('사원','대리','과장') and u.user_id not in ('000006') and a.car_mng_id=b.car_mng_id(+)   \n"+
   		  	  		  	
   		  	   " 	union all \n"+ 
   		  	   "  select  /*+ leading(b) merge(a) */ '06' gg, b.use_yn,  b.car_st, b.rent_l_cd, b.rent_way, cr.car_no, cr.car_nm, b.firm_nm, e.bus_id2 as user_id, se.ext_pay_dt serv_dt, '휴/대차료' gubun, se.ext_pay_amt*(-1) as amt, 0 per 	from accident a, cont_n_view b, my_accid e , scd_ext se , car_reg cr  \n"+ 
   			   "	where e.req_st in ('1' , '2')  and e.car_mng_id=a.car_mng_id and e.accid_id=a.accid_id and a.car_mng_id=b.car_mng_id  and e.bus_id2  = '" + mng_id + "' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id = cr.car_mng_id and a.rent_mng_id=se.rent_mng_id and a.rent_l_cd=se.rent_l_cd and se.ext_st = '6' and e.accid_id||e.seq_no = se.ext_id and se.ext_pay_dt  between  replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n"+     		
	           " 	union all \n"+        		
       		
       		  " select a.* from ( \n" +       		  
			  " select  '07' gg, d.use_yn,  a.cons_st car_st, decode(a.cons_cau, '4', '(자)정비대차인도', '5', '(자)사고대차인도', '6', '(자)정비차량인도', '7', '(자)사고차량인도', '9', '(자)정비대차회수', '10', '(자)사고대차회수', '11', '(자)정비차량회수' , '12', '(자)사고차량회수', '13', '(자)중도해지회수', '14', '(자)만기반납', '16', '(자)본사이동', '(자)17', '지점이동' , '(자)18', '(자)정기검사', '19', '(자)차량점검', '20', '(자)기타'  ) rent_l_cd,   \n"+  
			  "  decode(a.cons_st, '1', '편도', '왕복') rent_way, a.car_no, a.car_nm, d.firm_nm,  decode(d.car_st, '2',  a.req_id, nvl(d.bus_id4, d.mng_id) )  as user_id,  a.reg_dt serv_dt, '탁송료' gubun, \n"+ 
			  "  ( case when decode(b.sub_l_cd,'',d.car_gu,c.car_gu)  = 0 and decode(b.sub_l_cd,'',d.rent_way_cd,c.rent_way_cd) <> '1' and a.cons_cau  in ('4', '6', '9', '11')  then 0   \n"+  
              "         when decode(b.sub_l_cd,'',d.car_gu,c.car_gu)  = 0 and decode(b.sub_l_cd,'',d.rent_way_cd,c.rent_way_cd) = '1'  and a.cons_cau  in ('4', '6', '9', '11')  and a.reg_dt  < to_char(add_months(to_date(d.rent_start_dt), 2), 'yyyymmdd') then 0 else  1  end )* ( a.tot_amt - a.oil_amt ) as amt, 0 per \n"+
              "        from   consignment a, (select car_mng_id, cust_id, substr(nvl(deli_dt,deli_plan_dt),1,8) deli_dt, sub_l_cd from rent_cont) b, cont_n_view c, cont_n_view d \n"+ 
              "          where  a.reg_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and decode(d.car_st, '2',  a.req_id, nvl(d.bus_id4, d.mng_id) )  = '" + mng_id + "' and a.off_id not in ('003158') \n"+ 
              "                 and a.cost_st = '1'  and a.cons_cau not in ('1', '3', '8', '15' , '16', '17')  and a.car_mng_id=b.car_mng_id(+) and a.client_id=b.cust_id(+) \n"+ 
              "                 and substr(nvl(a.from_dt,a.from_req_dt),1,8)=deli_dt(+) and b.sub_l_cd=c.rent_l_cd(+)  and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd  ) a where a.amt > 0  \n"+ 
                     		  
       		   " 	union all \n"+   
       		   " select  /*+ leading(b) merge(a) */  '07' gg, b.use_yn, '' car_st, '기타' rent_l_cd, '' rent_way, cr.car_no,cr.car_nm, b.firm_nm, a.cost_id as user_id, a.cost_dt serv_dt, '탁송료' gubun, a.cost_amt as amt, 0 per 	 from cost_neom a, cont_n_view b, car_reg cr  \n"+
			   "  where a.gubun = '1' and a.c_st = '2' and a.rent_mng_id = b.rent_mng_id(+) and a.rent_l_cd = b.rent_l_cd(+)  and b.car_mng_id = cr.car_mng_id (+)\n"+ 
			   "  and a.cost_id = '" + mng_id + "' and a.cost_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n"+     
       		   " 	union all \n"+         			
			   " select /*+ leading(b d) use_nl(b d) merge(a) index(d DOC_SETTLE_IDX2) */ '07' gg, a.use_yn,  b.cons_st car_st, decode(b.cons_cau, '4', '(자)정비대차인도', '5', '(자)사고대차인도', '6', '(자)정비차량인도', '7', '(자)사고차량인도', '9', '(자)정비대차회수', '10', '(자)사고대차회수', '11', '(자)정비차량회수' , '12', '(자)사고차량회수', '13', '(자)중도해지회수', '14', '(자)만기반납', '16', '(자)본사이동', '(자)17', '지점이동' , '(자)18', '(자)정기검사', '19', '(자)차량점검', '20', '(자)기타'  ) rent_l_cd,  \n"+  
			   "  decode(b.cons_st, '1', '편도', '왕복') rent_way, cr.car_no, cr.car_nm, a.firm_nm,  nvl(d.user_id1,'999999')  as user_id,  b.reg_dt serv_dt, '탁송료' gubun, \n"+ 
			   "   nvl(c.cms_bk *c.app_st, 0)  as amt, 0 per \n"+ 
			   "	from cont_n_view a, consignment b, doc_settle d,  (select * from code where c_st='0022') c , car_reg cr where a.rent_mng_id= b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and a.car_mng_id = cr.car_mng_id(+)  \n"+ 
			   " 	and b.cost_st = '1' and b.cmp_app=c.nm_cd(+)  and b.cons_cau not in ('1', '3', '8', '15', '16', '17' ) and d.doc_st = '2'  and b.off_id = '003158' \n"+ 
			   "    and d.doc_id = b.cons_no and d.user_id1 <> b.driver_nm and nvl(d.user_id1,'999999') = '" + mng_id + "'\n"+ 
			   "	and b.reg_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n"+  
						
			   " union all \n"+  
			   " select /*+ leading(b d) use_nl(b d) merge(a) index(d DOC_SETTLE_IDX2)  */ '07' gg, a.use_yn,  b.cons_st car_st, decode(b.cons_cau, '4', '(자)정비대차인도', '5', '(자)사고대차인도', '6', '(자)정비차량인도', '7', '(자)사고차량인도', '9', '(자)정비대차회수', '10', '(자)사고대차회수', '11', '(자)정비차량회수' , '12', '(자)사고차량회수', '13', '(자)중도해지회수', '14', '(자)만기반납', '16', '(자)본사이동', '17', '(자)지점이동' , '18', '(자)정기검사', '19', '(자)차량점검', '20', '(자)기타'  ) rent_l_cd,  \n"+ 
			   "   decode(b.cons_st, '1', '편도', '왕복') rent_way, cr.car_no, cr.car_nm, a.firm_nm, nvl(b.driver_nm,'999999')  as user_id, b.reg_dt serv_dt, '탁송료' gubun, \n"+ 
			   "	nvl(c.cms_bk *c.app_st, 0) * (-1)  as amt, 0 per \n"+ 
			   "	 from cont_n_view a, consignment b, doc_settle d,  (select * from code where c_st='0022') c, car_reg cr  where a.rent_mng_id= b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and a.car_mng_id = cr.car_mng_id(+) \n"+ 
			   "	 and b.cost_st = '1' and b.cmp_app=c.nm_cd(+)  and b.cons_cau not in ('1', '3', '8', '15', '16', '17' ) and d.doc_st = '2'  and b.off_id = '003158' \n"+ 
			   "	 and d.doc_id = b.cons_no and d.user_id1 <> b.driver_nm and nvl(b.driver_nm,'999999')  = '" + mng_id + "'\n"+ 
			   "	 and b.reg_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  \n"+         		
       		
       		   " union all \n"+ 
       		  " select a.* from ( \n" +       		  
			  " select  '08' gg, d.use_yn,  a.cons_st car_st, decode(a.cons_cau, '4', '(자)정비대차인도', '5', '(자)사고대차인도', '6', '(자)정비차량인도', '7', '(자)사고차량인도', '9', '(자)정비대차회수', '10', '(자)사고대차회수', '11', '(자)정비차량회수' , '12', '(자)사고차량회수', '13', '(자)중도해지회수', '14', '(자)만기반납', '16', '(자)본사이동', '(자)17', '지점이동' , '(자)18', '(자)정기검사', '19', '(자)차량점검', '20', '(자)기타'  ) rent_l_cd,   \n"+  
			  "  decode(a.cons_st, '1', '편도', '왕복') rent_way, a.car_no, a.car_nm, d.firm_nm,  decode(d.car_st, '2',  a.req_id, nvl(d.bus_id4, d.mng_id) )  as user_id,  a.reg_dt serv_dt, '유류대' gubun, \n"+ 
			  "  ( case when decode(b.sub_l_cd,'',d.car_gu,c.car_gu)  = 0 and decode(b.sub_l_cd,'',d.rent_way_cd,c.rent_way_cd) <> '1' and a.cons_cau  in ('4', '6', '9', '11')  then 0   \n"+  
              "         when decode(b.sub_l_cd,'',d.car_gu,c.car_gu)  = 0 and decode(b.sub_l_cd,'',d.rent_way_cd,c.rent_way_cd) = '1'  and a.cons_cau  in ('4', '6', '9', '11')  and a.reg_dt  < to_char(add_months(to_date(d.rent_start_dt), 2), 'yyyymmdd') then 0 else  1  end )* ( a.oil_amt ) as amt, 0 per \n"+
              "        from   consignment a, (select car_mng_id, cust_id, substr(nvl(deli_dt,deli_plan_dt),1,8) deli_dt, sub_l_cd from rent_cont) b, cont_n_view c, cont_n_view d \n"+ 
              "          where  a.reg_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and decode(d.car_st, '2',  a.req_id, nvl(d.bus_id4, d.mng_id) )  = '" + mng_id + "' and a.off_id not in ('003158') \n"+ 
              "                 and a.cost_st = '1'  and a.cons_cau not in ('1', '3', '8', '15' , '16', '17')  and a.car_mng_id=b.car_mng_id(+) and a.client_id=b.cust_id(+) \n"+ 
              "                 and substr(nvl(a.from_dt,a.from_req_dt),1,8)=deli_dt(+) and b.sub_l_cd=c.rent_l_cd(+)  and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd  ) a where a.amt > 0  \n"+ 
                     		          		
	           " union all \n"+ 	        
       		   " select '08' gg, 'Y' use_yn, '' car_st, decode(a.o_cau, '1', '대여차량인도', '3', '지연대차인도', '4', '정비대차인도', '5', '사고대차인도', '6', '정비차량인도', '7', '사고차량인도','8', '지연대차회수',  '9', '정비대차회수', '10', '사고대차회수', '11', '정비차량회수' , '12', '사고차량회수', '13', '중도해지회수', '14', '만기반납', '15', '대여차량회수', '16', '본사이동', '17', '지점이동' , '18', '정기검사', '19', '차량점검', '20', '기타'  ) rent_l_cd,  '카드' rent_way, a.item_name car_no, b.car_nm car_nm , '' firm_nm, nvl(a.buy_user_id,'999999') as user_id, a.buy_dt serv_dt,  \n"+ 
    		   "  '유류대' gubun , a.buy_amt amt , 0 per  \n"+ 
       		   " from card_doc a , car_reg b where    a.acct_code = '00004' and a.acct_code_g2 in ( '12', '13') and  a.o_cau not in ('1','3','8', '15', '16', '17') and nvl(a.buy_user_id,'999999')  = '" + mng_id + "' and a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.item_code = b.car_mng_id(+) \n"+ 
		 	   " union all \n"+	
       		   " select '08' gg, 'Y' use_yn,  '' car_st, decode(b.o_cau, '1', '대여차량인도', '3', '지연대차인도', '4', '정비대차인도', '5', '사고대차인도', '6', '정비차량인도', '7', '사고차량인도','8', '지연대차회수',  '9', '정비대차회수', '10', '사고대차회수', '11', '정비차량회수' , '12', '사고차량회수', '13', '중도해지회수', '14', '만기반납', '15', '대여차량회수', '16', '본사이동', '17', '지점이동' , '18', '정기검사', '19', '차량점검', '20', '기타', b.p_cont  )  rent_l_cd, ''  rent_way, '' car_no, '' car_nm, '' firm_nm, b.buy_user_id as user_id, a.p_pay_dt serv_dt,   \n"+  
			   "  '유류대' gubun, b.i_amt amt, 0 per  from pay a, pay_item b \n"+ 
			   " where a.reqseq=b.reqseq and b.acct_code='45800' and b.buy_user_id  = '" + mng_id + "' and a.p_pay_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and b.o_cau not in ('1','3','8', '15', '16', '17')  \n"+  
			   " union all \n"+    
		 	   " select  '08' gg, b.use_yn, '' car_st, '탁송유류비' rent_l_cd, '' rent_way, cr.car_no, cr.car_nm, b.firm_nm, a.cost_id as user_id,  a.cost_dt serv_dt, '유류대' gubun, a.cost_amt as amt, 0 per 	 from cost_neom a, cont_n_view b , car_reg cr  \n"+
			   "  where a.gubun = '5' and a.c_st = '2' and a.rent_mng_id = b.rent_mng_id(+) and a.rent_l_cd = b.rent_l_cd(+)  and b.car_mng_id = cr.car_mng_id(+) \n"+ 
			   "  and a.cost_id = '" + mng_id + "' and a.cost_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n"+     			      			       			
       		   " 	union all \n"+  	            		 
			   " select '10' gg, a.use_yn,  a.car_st, a.rent_l_cd, b.sbshm rent_way, cr.car_no, cr.car_nm, a.firm_nm, b.bus_id as user_id,  b.js_dt serv_dt,   \n"+  
			   "  '긴급출동' gubun, b.sbgb_amt amt, 0 per  from cont_n_view a, master_car b , car_reg cr \n"+  
			   "   where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id = cr.car_mng_id and b.sbshm <> '1' \n"+ 
			   "     and b.bus_id  = '" + mng_id + "' and  b.js_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n"+ 
			   " union all \n"+         		 
			   " select '11' gg, 'Y' use_yn,  '' car_st, '통신비'  rent_l_cd, ''  rent_way, '' car_no, '' car_nm, '' firm_nm, c.pay_user as user_id,  a.p_pay_dt serv_dt,   \n"+  
			   "  '통신비' gubun, c.pay_amt amt, 0 per  from pay a, pay_item b, pay_item_user c \n"+ 
			   " where a.reqseq=b.reqseq and b.reqseq=c.reqseq and b.i_seq=c.i_seq and b.acct_code='81400' and c.pay_user  = '" + mng_id + "' and a.p_pay_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  \n"+  
		   " 	union all \n"+  
			   " select '13' gg, 'Y' use_yn,  '' car_st, '교통비'  rent_l_cd, ''  rent_way, '' car_no, '' car_nm, '' firm_nm, b.buy_user_id as user_id, a.p_pay_dt serv_dt,   \n"+  
			   "  '교통비외' gubun, b.i_amt amt, 0 per  from pay a, pay_item b \n"+ 
			   " where a.reqseq=b.reqseq and b.acct_code='81200' and b.buy_user_id  = '" + mng_id + "' and a.p_pay_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n"+  
			   " 	union all \n"+ 	  			       
			   " select '13' gg, 'Y' use_yn, '' car_st, decode(a.acct_code_g, '9', '출장비', '10', '기타교통비', '20', '하이패스', '') rent_l_cd,  '카드' rent_way, a.item_name car_no, '' car_nm , '' firm_nm, nvl(a.buy_user_id,'999999') as user_id,  a.buy_dt serv_dt,  \n"+ 
    		   "  '교통비외' gubun , a.buy_amt amt , 0 per  \n"+ 
       		   " from card_doc a where    a.acct_code = '00003'  and nvl(a.buy_user_id,'999999')  = '" + mng_id + "' and a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  ";
       		   
	   
	  	query += "  order by gg, rent_way, serv_dt ";
	  	
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
			System.out.println("[CostDatabase:getDlyCostStatMList]"+e);
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
	 *	사원별 관리비용지출 현황 - 영업팀
 	 */
	public Vector getDlyCost3StatMList(String dt, String ref_dt1, String ref_dt2, String mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		String f_date1="";
		String t_date1="";
		
		f_date1=  ref_dt1;
		t_date1=  ref_dt2;
			
	   query = " select '3' gg, a.use_yn, a.car_st, a.rent_l_cd, a.rent_way, a.car_no, cr.car_nm, cr.firm_nm, nvl(a.bus_id2,'999999') as user_id, a.rent_l_cd, b.serv_dt,  '사고수리비' gubun, sum(case  when  (b.tot_amt * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.ext_amt,0)*1.1) ) > 2000000  then 2000000  else  ( b.tot_amt * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.ext_amt,0)*1.1) ) end) amt, decode(ac.accid_st, '4', 100, ac.our_fault_per) per from cont_n_view a, service b, accident ac, car_regc cr,  ( select car_mng_id, max(ins_st) ins_st , ins_sts , con_f_nm  from insur group by car_mng_id , ins_sts , con_f_nm ) i  where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.car_mng_id = cr.car_mng_id(+) and  a.client_id not in ('000231', '000228') and b.serv_st in ('4', '5') and b.car_mng_id = ac.car_mng_id(+) and b.accid_id = ac.accid_id(+) and b.car_mng_id = i.car_mng_id and i.ins_sts = '1' and con_f_nm like '%아마존카%' and nvl(a.bus_id4, a.bus_id2)   = '" + mng_id + "' and b.serv_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and b.serv_dt >= replace(a.rent_start_dt, '-', '') and (b.tot_amt * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) > 0 \n" +
   			   " group by  a.use_yn, a.car_st, a.rent_l_cd, a.rent_way, a.car_no, cr.car_nm, cr.firm_nm, nvl(a.bus_id2,'999999') , a.rent_l_cd, b.serv_dt , decode(ac.accid_st, '4', 100, ac.our_fault_per) \n" +
   			   " 	union all \n"+ 
   			   " select '4' gg,  v.use_yn use_yn, c.dpm car_st, a.rent_s_cd rent_l_cd, substr(a.deli_dt, 1,8) rent_way, c.car_no, c.car_nm, v.firm_nm, nvl(v.bus_id2,'999999') as user_id,  a.rent_s_cd rent_l_cd,  substr(a.ret_dt,1,8) serv_dt, '대차비용' gubun,\n"+ 
   			   " case when to_number(c.dpm) < 2000 then   (case when trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8))) +1 ) > 10 then 10 else trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8)))+1) end)  * 20000 \n"+ 
               "      when to_number(c.dpm) >=2700 then   (case when trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8))) +1 ) > 10 then 10 else trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8)))+1) end)  * 40000 \n"+ 
               "      else  (case when trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8))) +1 ) > 10 then 10 else trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8)))+1) end) * 30000 end amt,  \n"+ 
               " case when trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8))) +1 ) > 10 then 10 else trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8)))+1) end  per \n"+ 
               "  from RENT_CONT a, CAR_REG c, users u, cont_n_view v \n"+ 
               "  where a.use_st  in ('2' , '3', '4' )  and a.car_mng_id=c.car_mng_id  and a.rent_st in ('2', '3', '8','9') \n"+ 
               "  and nvl(v.bus_id4, v.bus_id2) = '" + mng_id + "' and a.deli_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n"+ 
               "  and a.sub_l_cd = v.rent_l_cd(+)  and a.bus_id=u.user_id and u.user_pos in ('사원','대리','과장') and  u.loan_st = '2' \n"+  
   		       " 	union all \n"+ 
   		  	   "  select  '5' gg, b.use_yn,  b.car_st, b.rent_l_cd, b.rent_way, cr.car_no,cr.car_nm, b.firm_nm, nvl(b.bus_id4, b.bus_id2) as user_id, b.rent_l_cd, e.pay_dt, '휴/대차료' gubun, e.pay_amt as amt, 0 per 	from accident a, cont_n_view b, my_accid e , car_reg cr \n"+ 
   			   "	where e.req_st in ('1' , '2')  and e.car_mng_id=a.car_mng_id and e.accid_id=a.accid_id and a.car_mng_id=b.car_mng_id  and a.car_mng_id = cr.car_mng_id  and nvl(b.bus_id4, b.bus_id2)   = '" + mng_id + "' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  and e.pay_dt  between  replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') "; 
       			   
   			   
	  	query += "  order by gg, rent_way, serv_dt ";
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
			System.out.println("[CostDatabase:getDlyCostStatMList]"+e);
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
	 *	사원별 관리비용지출 현황 - 영업팀
 	 */
	public Vector getDlyCost3StatMList(String dt, String ref_dt1, String ref_dt2, String mng_id, int amt2, int amt2_per)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String f_date1="";
		String t_date1="";
		
		f_date1=  ref_dt1;
		t_date1=  ref_dt2;
	
   		query =" select '3' gg, a.use_yn, a.car_st, a.rent_l_cd, a.rent_way, cr.car_no,cr.car_nm, a.firm_nm, nvl(a.bus_id2,'999999') as user_id, a.rent_l_cd, b.serv_dt,  '사고수리비' gubun, sum(case  when  (b.tot_amt * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.ext_amt,0)*1.1)) > " + amt2+ "  then " + amt2 + " + (((b.tot_amt * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.ext_amt,0)*1.1)) - " + amt2+ ")*"+amt2_per+"/100)  else  ( b.tot_amt * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.ext_amt,0)*1.1) ) end) amt, decode(ac.accid_st, '4', 100, ac.our_fault_per) per \n" +
   		"	from  cont_n_view a, service b, accident ac, car_reg cr,   ( select car_mng_id, max(ins_st) ins_st , ins_sts , con_f_nm  from insur group by car_mng_id , ins_sts , con_f_nm ) i  where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  and a.car_mng_id = cr.car_mng_id and  a.client_id not in ('000231', '000228') and b.serv_st in ('4', '5') and b.car_mng_id = ac.car_mng_id(+) and b.accid_id = ac.accid_id(+) and b.car_mng_id = i.car_mng_id and i.ins_sts = '1' and con_f_nm like '%아마존카%' and nvl(a.bus_id4, a.bus_id2)   = '" + mng_id + "' and b.serv_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and b.serv_dt >= replace(a.rent_start_dt, '-', '') and  (b.tot_amt * decode(ac.accid_st, '4', 100, ac.our_fault_per)/100) > 0 \n" +
   			   " group by  a.use_yn, a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, cr.car_nm, a.firm_nm, nvl(a.bus_id2,'999999') , a.rent_l_cd, b.serv_dt , decode(ac.accid_st, '4', 100, ac.our_fault_per) \n" +
   			   " 	union all \n"+ 
   			   " select '4' gg,  v.use_yn use_yn, c.dpm car_st, a.rent_s_cd rent_l_cd, substr(a.deli_dt, 1,8) rent_way, c.car_no, c.car_nm, v.firm_nm, nvl(v.bus_id2,'999999') as user_id,  a.rent_s_cd rent_l_cd,  substr(a.ret_dt,1,8) serv_dt, '대차비용' gubun,\n"+ 
   			   " case when to_number(c.dpm) < 2000 then   (case when trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8))) +1 ) > 10 then 10 else trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8)))+1) end)  * 20000 \n"+ 
               "      when to_number(c.dpm) >=2700 then   (case when trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8))) +1 ) > 10 then 10 else trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8)))+1) end)  * 40000 \n"+ 
               "      else  (case when trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8))) +1 ) > 10 then 10 else trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8)))+1) end) * 30000 end amt,  \n"+ 
               " case when trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8))) +1 ) > 10 then 10 else trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8)))+1) end  per \n"+ 
               "  from RENT_CONT a, CAR_REG c, users u, cont_n_view v \n"+ 
               "  where a.use_st  in ('2' , '3', '4' )  and a.car_mng_id=c.car_mng_id  and a.rent_st in ('2', '3', '8','9') \n"+ 
               "  and nvl(v.bus_id4, v.bus_id2) = '" + mng_id + "' and a.deli_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n"+ 
               "  and a.sub_l_cd = v.rent_l_cd(+)  and a.bus_id=u.user_id and u.user_pos in ('사원','대리','과장') and  u.loan_st = '2' \n"+  
   		       " 	union all \n"+ 
   		  	   "  select  '5' gg, b.use_yn,  b.car_st, b.rent_l_cd, b.rent_way, cr.car_no, cr.car_nm, b.firm_nm, nvl(b.bus_id4, b.bus_id2) as user_id, b.rent_l_cd, e.pay_dt, '휴/대차료' gubun, e.pay_amt as amt, 0 per \n" +
   		  	   " 	from accident a, cont_n_view b, my_accid e , car_reg cr  \n"+ 
   			   "	where e.req_st in ('1' , '2')  and e.car_mng_id=a.car_mng_id and e.accid_id=a.accid_id and a.car_mng_id=b.car_mng_id  and a.car_mng_id = cr.car_mng_id and nvl(b.bus_id4, b.bus_id2)   = '" + mng_id + "' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  and e.pay_dt  between  replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') "; 
       			   
   			   
	  	query += "  order by gg, rent_way, serv_dt ";
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
			System.out.println("[CostDatabase:getDlyCostStatMList]"+e);
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
	 *	사원별 영업비용지출 현황 - 영업팀
 	 */
	public Vector getDlyCostStatSList(String dt, String ref_dt1, String ref_dt2, String mng_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";		
		
		String f_date1="";
		String t_date1="";
				
		f_date1=  ref_dt1;
		t_date1=  ref_dt2;
			    
	   query = "   select '1' gg, a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, cr.car_nm, a.firm_nm, nvl(a.bus_id,'999999') as user_id, a.rent_dt, '메이커 정상 D/C' gubun, sum(b.s_dc_amt) amt, 0 per   \n"+
	 		   "	from (  \n"+
	           "		select rent_mng_id, rent_l_cd, s_dc1_amt s_dc_amt from car_etc where s_dc1_amt > 0 and s_dc1_re like '%판매%' and s_dc1_yn = 'Y'  \n"+
	           "			union all  \n"+
	           "		select rent_mng_id, rent_l_cd, s_dc2_amt s_dc_amt from car_etc where s_dc2_amt > 0 and s_dc2_re  like '%판매%' and s_dc2_yn = 'Y'  \n"+
	           "			union all  \n"+
	           "		select rent_mng_id, rent_l_cd, s_dc3_amt s_dc_amt from car_etc where s_dc3_amt > 0 and s_dc3_re  like '%판매%' and s_dc3_yn = 'Y' ) b, cont_n_view a, cont c , car_reg cr  \n"+
  			   " where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd  and c.car_mng_id = cr.car_mng_id  \n"+
       		   "	and  a.client_id not in ('000231', '000228') and  ( a.rent_way='일반식' or a.rent_way='기본식' and c.car_gu='1' ) and a.bus_id ='" +mng_id +"'    \n"+
	   		   "	and  replace(a.rent_dt, '-', '') between '" + f_date1 + "' and '" + t_date1 + "'   \n"+
     		   "	group by  a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, cr.car_nm, a.firm_nm, nvl(a.bus_id,'999999') , a.rent_dt   \n"+
     		   " union all \n"+
     		   "   select '2' gg, a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no,cr.car_nm, a.firm_nm, nvl(a.bus_id,'999999') as user_id, a.rent_dt, '메이커 추가 D/C' gubun, sum(b.s_dc_amt) amt, 0 per   \n"+
	 		   "	from (  \n"+
	           "		select rent_mng_id, rent_l_cd, s_dc1_amt s_dc_amt from car_etc where s_dc1_amt > 0 and s_dc1_re not like '%판매%' and s_dc1_yn = 'Y'  \n"+
	           "			union all  \n"+
	           "		select rent_mng_id, rent_l_cd, s_dc2_amt s_dc_amt from car_etc where s_dc2_amt > 0 and s_dc2_re  not like '%판매%' and s_dc2_yn = 'Y'  \n"+
	           "			union all  \n"+
	           "		select rent_mng_id, rent_l_cd, s_dc3_amt s_dc_amt from car_etc where s_dc3_amt > 0 and s_dc3_re  not like '%판매%' and s_dc3_yn = 'Y' ) b, cont_n_view a, cont c  , car_reg cr  \n"+
  			   " where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and c.car_mng_id = cr.car_mng_id \n"+
       		   "	and  a.client_id not in ('000231', '000228') and  ( a.rent_way='일반식' or a.rent_way='기본식' and c.car_gu='1' ) and a.bus_id ='" +mng_id +"'    \n"+
	   		   "	and  replace(a.rent_dt, '-', '') between '" + f_date1 + "' and '" + t_date1 + "'   \n"+
     		   "	group by  a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, a.car_no, a.car_nm, a.firm_nm, nvl(a.bus_id,'999999') , a.rent_dt  \n";
   
	  	query += "  order by gg, rent_way, rent_dt ";
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
			System.out.println("[CostDatabase:getDlyCostStatSList]"+e);
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
	 * 비용캠페인 : 고객지원팀 적용변수
	*/
	public Hashtable getCostCampaignVar(String gubun){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		
		String query =  " SELECT  *  FROM cost_campaign "+
						" WHERE ( year||tm) in (   select max(year||tm) from cost_campaign where  gubun = '" + gubun + "') and gubun = '" + gubun + "'" ;						

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

	
			
			ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
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
			System.out.println("[CostDatabase:getCostCampaignVar()]"+e);
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



	/**
	 * 결과 :마감테이블 조회 - 영업팀
	*/
	public Vector getCostSaleCampaign(String save_dt, String gubun, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select decode(b.user_pos,'대표이사',1,'부장', 2, '차장', 3, '과장', 4 , '대리', 5, 9) pos_sort,"+
					   " (a.amt4+ a.amt5 + a.amt6 + a.amt16)/(a.rent_way_1_cnt+a.rent_way_2_cnt) rent_per, a.*," +
					   " b.dept_id, b.user_nm, b.user_id  "+
					   " from stat_bus_cost_cmp a, users b where a.bus_id=b.user_id and a.gubun = '" + gubun + "' and a.save_dt='"+save_dt+"' and b.use_yn = 'Y'";

	//	if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

	//	if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by 2 ";

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
			System.out.println("[CostDatabase:getCostSaleCampaign(String save_dt, String gubun, String loan_st, String s_dt, String e_dt)]"+e);
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
	 * 결과 :마감테이블 조회  
	*/
	public Vector getCostCampaign(String save_dt, String gubun, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select decode(b.user_pos,'대표이사',1,'부장', 2, '차장', 3, '과장', 4 , '대리', 5, 9) pos_sort,"+
					   " (a.amt5 + a.amt6 + a.amt8 + a.amt9 + a.amt10 + a.amt16)/(a.rent_way_1_cnt+a.rent_way_2_cnt) rent_per, a.*," +
					   " b.dept_id, b.user_nm, b.user_id  from stat_bus_cost_cmp a, users b where a.bus_id=b.user_id and a.gubun = '" + gubun + "' and a.save_dt='"+save_dt+"' and b.use_yn = 'Y'";

	//	if(!loan_st.equals("") && ns_dt.equals(""))		query += " and sysdate-to_date(b.enter_dt,'YYYYMMDD') >= 365 and b.loan_st='"+loan_st+"'";

	//	if(loan_st.equals("") && !ns_dt.equals(""))		query += " and b.enter_dt between '"+ns_dt+"' and '"+ne_dt+"'";


		query += " order by 2 ";

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
			System.out.println("[CostDatabase:getCostCampaign(String save_dt, String gubun, String loan_st, String s_dt, String e_dt)]"+e);
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
	
	public Vector getCostManCampaign(String save_dt, String gubun, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	  
		if (gubun.equals("1")) { //고객지원팀

			 query = " select decode(b.user_pos,'대표이사',1,'부장', 2, '차장', 3, '과장', 4 , '대리', 5, 9) pos_sort,"+
					   " (a.amt10 / a.rent_way_1_cnt) * c.su_1_cnt / (c.su_1_cnt + c.su_2_cnt ) + ( (a.amt14 + a.amt9 - a.amt23 +  a.amt19 + a.amt17 + a.amt5+ a.amt6 + a.amt7 + a.amt8 + a.amt25)/(a.rent_way_1_cnt+a.rent_way_2_cnt)) rent_per, a.*," +
					   " b.dept_id, b.user_nm, b.user_id , decode(b.dept_id,'0001','영업팀','0002','고객지원팀','0003','총무팀','0007','부산지점','0008','대전지점','8888', '기타', ' ') as dept_nm from stat_bus_cost_cmp a, users b, " +
					   " (select sum(rent_way_1_cnt) su_1_cnt, sum(rent_way_2_cnt) su_2_cnt from stat_bus_cost_cmp a,  users b where a.bus_id=b.user_id and a.gubun = '"+gubun+"' and a.save_dt='"+save_dt+"' and b.use_yn = 'Y') c " +
					   " where a.bus_id=b.user_id and a.gubun = '"+gubun+"' and a.save_dt='"+save_dt+"' and b.use_yn = 'Y'";
		}else {
			 query = " select decode(b.user_pos,'대표이사',1,'부장', 2, '차장', 3, '과장', 4 , '대리', 5, 9) pos_sort,"+
					   " (a.amt10 / case when a.rent_way_1_cnt = 0 then 1 else  a.rent_way_1_cnt end ) * c.su_1_cnt / (c.su_1_cnt + c.su_2_cnt ) + ( (a.amt14 + a.amt9 - a.amt23 +  a.amt19 + a.amt17 + a.amt5+ a.amt6 + a.amt7 + a.amt8 + a.amt25)/(a.rent_way_1_cnt+a.rent_way_2_cnt)) rent_per, a.*," +
					   " b.dept_id, b.user_nm, b.user_id, decode(b.dept_id,'0001','영업팀','0002','고객지원팀','0003','총무팀','0007','부산지점','0008','대전지점','8888', '기타', ' ') as dept_nm  from stat_bus_cost_cmp a, users b, " +
					   " (select sum(rent_way_1_cnt) su_1_cnt, sum(rent_way_2_cnt) su_2_cnt from stat_bus_cost_cmp a,  users b where a.bus_id=b.user_id and a.gubun = '"+gubun+"' and a.save_dt='"+save_dt+"' and b.use_yn = 'Y') c " +
					   " where a.bus_id=b.user_id and a.gubun = '"+gubun+"' and a.save_dt='"+save_dt+"' and b.use_yn = 'Y'";
					   
		
		}	
	
		query += " order by 2 ";

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
			System.out.println("[CostDatabase:getCostManCampaign(String save_dt, String gubun, String loan_st, String s_dt, String e_dt)]"+e);
			System.out.println("[CostDatabase:getCostManCampaign(String save_dt, String gubun, String loan_st, String s_dt, String e_dt)]"+query);			
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
	
	public Vector getCostManCampaignNew(String save_dt, String gubun, int base_cnt, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	  
		if (gubun.equals("1")) { //고객지원팀

		
				 query = " select '0' po , aa.ave_amt  r_one_per_cost, aa.c_ave_amt one_per_cost ,\n"+
				         " trunc(aa.all_i_amt / aa.su_1_cnt)  ave_all_i_amt, trunc(aa.all_b_amt / aa.su_2_cnt)  ave_all_b_amt, \n"+
				         " trunc(aa.way1_amt / aa.rent_way_1_cnt)  ave_i_amt, trunc(aa.way2_amt / aa.rent_way_2_cnt) ave_b_amt,  \n"+
				     //    " trunc((aa.r_all_b_amt + aa.r_all_i_amt ) /  ( aa.su_1_cnt + aa.su_2_cnt)) one_per_cost,	\n"+			       
				  		 " aa.* from ( \n"+
						 "	 select decode(b.user_pos,'대표이사',1,'부장', 2, '차장', 3, '과장', 4 , '대리', 5, 9) pos_sort, c.su_1_cnt, c.su_2_cnt, c.all_i_amt, c.all_b_amt,  \n"+
						 "	 a.*, b.dept_id, b.user_nm, b.user_id , decode(b.dept_id,'0001','영업팀','0002','고객지원팀','0003','총무팀','0007','부산지점','0008','대전지점','8888', '기타', ' ') as dept_nm \n"+
						 "	 from stat_bus_cost_cmp a, users b, \n"+ 
						 "	 (select sum(a.way1_amt) all_i_amt, sum(a.way2_amt) all_b_amt, sum(rent_way_1_cnt) su_1_cnt, sum(rent_way_2_cnt) su_2_cnt from stat_bus_cost_cmp a,  users b where a.bus_id=b.user_id and a.gubun = '"+gubun+"' and a.save_dt='"+save_dt+"'  and b.use_yn = 'Y'  ) c \n"+
						 "	  where a.bus_id=b.user_id  and a.gubun =  '"+gubun+"' and a.save_dt='"+save_dt+"' and b.use_yn = 'Y'   ) aa \n ";
	
		}else {
			//관리대수가 50대가 미만인 경우는 포상제외
			  query = " select case when  ( aa.rent_way_1_cnt + aa.rent_way_2_cnt ) >= " + base_cnt + "  then '0' else '9' end po, aa.ave_amt  r_one_per_cost, aa.c_ave_amt one_per_cost ,\n"+				
				         " trunc(aa.all_i_amt / aa.su_1_cnt)  ave_all_i_amt, trunc(aa.all_b_amt / aa.su_2_cnt)  ave_all_b_amt, \n"+
				         " trunc(aa.way1_amt / decode(aa.rent_way_1_cnt, 0, 1 ,aa.rent_way_1_cnt))  ave_i_amt, trunc(aa.way2_amt / aa.rent_way_2_cnt) ave_b_amt,  \n"+
				     //    " trunc((aa.r_all_b_amt + aa.r_all_i_amt ) /  ( aa.su_1_cnt + aa.su_2_cnt)) one_per_cost,	\n"+			       
				  		 " aa.* from ( \n"+
						 "	 select decode(b.user_pos,'대표이사',1,'부장', 2, '차장', 3, '과장', 4 , '대리', 5, 9) pos_sort, c.su_1_cnt, c.su_2_cnt, c.all_i_amt, c.all_b_amt,  \n"+
						 "	 a.*, b.dept_id, b.user_nm, b.user_id , decode(b.dept_id,'0001','영업팀','0002','고객지원팀','0003','총무팀','0007','부산지점','0008','대전지점','8888', '기타', ' ') as dept_nm \n"+
						 "	 from stat_bus_cost_cmp a, users b, \n"+ 
						 "	 (select sum(a.way1_amt) all_i_amt, sum(a.way2_amt) all_b_amt, sum(rent_way_1_cnt) su_1_cnt, sum(rent_way_2_cnt) su_2_cnt from stat_bus_cost_cmp a,  users b where a.bus_id=b.user_id and a.gubun = '"+gubun+"' and a.save_dt='"+save_dt+"'  and b.use_yn = 'Y' and ( a.rent_way_1_cnt + a.rent_way_2_cnt ) >=  " + base_cnt + "  ) c \n"+
						 "	  where a.bus_id=b.user_id  and a.gubun =  '"+gubun+"' and a.save_dt='"+save_dt+"' and b.use_yn = 'Y'  ) aa \n ";
						 
			
		}	
	
		query += " order by 1 , 2 ";
		
	

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
			System.out.println("[CostDatabase:getCostManCampaignNew(String save_dt, String gubun, int base_cnt, String s_dt, String e_dt)]"+e);
			System.out.println("[CostDatabase:getCostManCampaignNew(String save_dt, String gubun, int base_cnt, String s_dt, String e_dt)]"+query);
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
	
	//마감에서 조회용 
	public Vector getCostManCampaignNew1(String save_dt, String gubun, int base_cnt, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	  
		if (gubun.equals("1")) { //고객지원팀
		
			 query = " select  0  po, \n"+
     					 "	   a.ave_amt r_one_per_cost, a.c_ave_amt one_per_cost ,  decode(b.user_pos,'대표이사',1,'부장', 2, '차장', 3, '과장', 4 , '대리', 5, 9) pos_sort, \n"+
     					 "	   a.rent_way_1_cnt, a.rent_way_2_cnt, a.p_amt , \n"+		
					     "     b.dept_id, b.user_nm, b.user_id, decode(b.dept_id,'0001','영업팀','0002','고객지원팀','0003','총무팀','0007','부산지점','0008','대전지점','8888', '기타', ' ') as dept_nm   \n"+
				         "     from stat_bus_cost_cmp a, users b  \n"+
						 "		 where a.bus_id=b.user_id and a.gubun = '"+gubun+"' and a.save_dt='"+save_dt+"' and b.use_yn = 'Y' ";   
		}else {			
		
			 	 query = " select  case when a.save_dt > '20101101' then  case when  ( a.rent_way_1_cnt + a.rent_way_2_cnt )  >= " + base_cnt + "  then '0' else '9' end else '0' end   po, \n"+
     					 "		   a.ave_amt r_one_per_cost, a.c_ave_amt one_per_cost ,  decode(b.user_pos,'대표이사',1,'부장', 2, '차장', 3, '과장', 4 , '대리', 5, 9) pos_sort, \n"+
     					 "		   a.rent_way_1_cnt, a.rent_way_2_cnt, a.p_amt , \n"+		
					     "         b.dept_id, b.user_nm, b.user_id, decode(b.dept_id,'0001','영업팀','0002','고객지원팀','0003','총무팀','0007','부산지점','0008','대전지점','8888', '기타', ' ') as dept_nm   \n"+
				         "     from stat_bus_cost_cmp a, users b  \n"+
						 "		 where a.bus_id=b.user_id and a.gubun = '"+gubun+"' and a.save_dt='"+save_dt+"' and b.use_yn = 'Y' ";            		
 
		}	
	
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
			System.out.println("[CostDatabase:getCostManCampaignNew1(String save_dt, String gubun , int base_cnt,, String s_dt, String e_dt)]"+e);
			System.out.println(query);
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
	
	
	public Vector getCostManCampaignNew1(String save_dt, String gubun, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	  
		if (gubun.equals("1")) { //고객지원팀

			
				 query = " select trunc( round(trunc(aa.b_amt / aa.rent_way_2_cnt) / trunc(aa.r_all_b_amt / aa.su_2_cnt) * ( aa.b_amt / (aa.b_amt + aa.i_amt ) ) + trunc(aa.i_amt / aa.rent_way_1_cnt) / trunc(aa.r_all_i_amt / aa.su_1_cnt) * ( aa.i_amt / (aa.b_amt + aa.i_amt ) ), 3) * trunc((aa.r_all_b_amt + aa.r_all_i_amt ) /  ( aa.su_1_cnt + aa.su_2_cnt))) r_one_per_cost, \n"+
				         " trunc(aa.r_all_i_amt / aa.su_1_cnt)  ave_all_i_amt, trunc(aa.r_all_b_amt / aa.su_2_cnt)  ave_all_b_amt, \n"+
				         " trunc(aa.i_amt / aa.rent_way_1_cnt)  ave_i_amt, trunc(aa.b_amt / aa.rent_way_2_cnt) ave_b_amt,  \n"+
				         " trunc((aa.r_all_b_amt + aa.r_all_i_amt ) /  ( aa.su_1_cnt + aa.su_2_cnt)) one_per_cost,	\n"+			       
				  		 " aa.* from ( \n"+
						 "	 select decode(b.user_pos,'대표이사',1,'부장', 2, '차장', 3, '과장', 4 , '대리', 5, 9) pos_sort, c.su_1_cnt, c.su_2_cnt, \n"+
						 "	 trunc(c.all_g_amt/(c.su_1_cnt+c.su_2_cnt)*c.su_1_cnt + c.all_i_amt) r_all_i_amt, \n"+
						 "	 trunc(c.all_g_amt/(c.su_1_cnt+c.su_2_cnt)*c.su_2_cnt + c.all_b_amt) r_all_b_amt, \n"+
						 "	 trunc(((a.amt5+ a.amt6+ a.amt7+a.amt8+a.amt14+a.amt26)/ (a.rent_way_1_cnt + a.rent_way_2_cnt) * a.rent_way_1_cnt) + a.amt1 + a.amt4  - a.amt11 + a.amt15  +  a.amt21 + a.amt24)  i_amt, \n"+
						 "	 trunc(((a.amt5+a.amt6 +a.amt7+ a.amt8+a.amt14+a.amt26)/ (a.rent_way_1_cnt + a.rent_way_2_cnt) * a.rent_way_2_cnt) + a.amt12 + a.amt18  - a.amt20 + a.amt16 +  a.amt22 + a.amt2)  b_amt, \n"+
						 "	 a.*, b.dept_id, b.user_nm, b.user_id , decode(b.dept_id,'0001','영업팀','0002','고객지원팀','0003','총무팀','0007','부산지점','0008','대전지점','8888', '기타', ' ') as dept_nm \n"+
						 "	 from stat_bus_cost_cmp a, users b, \n"+ 
						 "	 (select sum(amt5+amt6+amt7+amt8+amt14+amt26) all_g_amt, sum(amt1 + amt4  - amt11  + amt15  +  amt21 + amt24) all_i_amt, sum( amt12 + amt18  - amt20 + amt16 +  amt22 + amt2) all_b_amt, sum(rent_way_1_cnt) su_1_cnt, sum(rent_way_2_cnt) su_2_cnt from stat_bus_cost_cmp a,  users b where a.bus_id=b.user_id and a.gubun = '"+gubun+"' and a.save_dt='"+save_dt+"'  and b.use_yn = 'Y') c \n"+
						 "	  where a.bus_id=b.user_id and a.gubun =  '"+gubun+"' and a.save_dt='"+save_dt+"' and b.use_yn = 'Y'  ) aa \n ";
				 
//			 query = " select decode(b.user_pos,'대표이사',1,'부장', 2, '차장', 3, '과장', 4 , '대리', 5, 9) pos_sort,"+
//					   " (a.amt10 / a.rent_way_1_cnt) * c.su_1_cnt / (c.su_1_cnt + c.su_2_cnt ) + ( (a.amt14 + a.amt9 - a.amt23 +  a.amt19 + a.amt17 + a.amt5+ a.amt6 + a.amt7 + a.amt8 + a.amt25)/(a.rent_way_1_cnt+a.rent_way_2_cnt)) rent_per, a.*," +
//					   " b.dept_id, b.user_nm, b.user_id , decode(b.dept_id,'0001','영업팀','0002','고객지원팀','0003','총무팀','0007','부산지점','0008','대전지점','8888', '기타', ' ') as dept_nm from stat_bus_cost_cmp a, users b, " +
//					   " (select sum(rent_way_1_cnt) su_1_cnt, sum(rent_way_2_cnt) su_2_cnt from stat_bus_cost_cmp a,  users b where a.bus_id=b.user_id and a.gubun = '"+gubun+"' and a.save_dt='"+save_dt+"' and b.use_yn = 'Y') c " +
//					   " where a.bus_id=b.user_id and a.gubun = '"+gubun+"' and a.save_dt='"+save_dt+"' and b.use_yn = 'Y'";
		}else {
			
			  query = " select trunc( round(trunc(aa.b_amt / aa.rent_way_2_cnt) / trunc(aa.r_all_b_amt / aa.su_2_cnt) * ( aa.b_amt / (aa.b_amt + aa.i_amt ) ) + trunc(aa.i_amt / decode(aa.rent_way_1_cnt, 0, 1, aa.rent_way_1_cnt)) / trunc(aa.r_all_i_amt / aa.su_1_cnt) * ( aa.i_amt / (aa.b_amt + aa.i_amt ) ), 3) * trunc((aa.r_all_b_amt + aa.r_all_i_amt ) /  ( aa.su_1_cnt + aa.su_2_cnt))) r_one_per_cost, \n"+
  						 " trunc(aa.r_all_i_amt / aa.su_1_cnt)  ave_all_i_amt, trunc(aa.r_all_b_amt / aa.su_2_cnt)  ave_all_b_amt, \n"+
				         " trunc(aa.i_amt / decode(aa.rent_way_1_cnt, 0, 1 ,aa.rent_way_1_cnt))  ave_i_amt, trunc(aa.b_amt / aa.rent_way_2_cnt) ave_b_amt,  \n"+
				         " trunc((aa.r_all_b_amt + aa.r_all_i_amt ) /  ( aa.su_1_cnt + aa.su_2_cnt)) one_per_cost,	\n"+			       
				  		 " aa.* from ( \n"+
						 "	 select decode(b.user_pos,'대표이사',1,'부장', 2, '차장', 3, '과장', 4 , '대리', 5, 9) pos_sort, c.su_1_cnt, c.su_2_cnt, \n"+
						 "	 trunc(c.all_g_amt/(c.su_1_cnt+c.su_2_cnt)*c.su_1_cnt + c.all_i_amt) r_all_i_amt, \n"+
						 "	 trunc(c.all_g_amt/(c.su_1_cnt+c.su_2_cnt)*c.su_2_cnt + c.all_b_amt) r_all_b_amt, \n"+
						 "	 trunc(((a.amt5+ a.amt6+ a.amt7+a.amt8)/ (a.rent_way_1_cnt + a.rent_way_2_cnt) * decode(b.user_id, '000076', 0, a.rent_way_1_cnt)) + decode(b.dept_id, '0001', 0, '0007', 0, a.amt1) + decode(b.dept_id, '0001', 0, '0007', 0, a.amt3) + decode(b.dept_id, '0001', 0, '0007', 0, a.amt4) - decode(b.dept_id, '0001', 0, '0007', 0, a.amt11) + decode(b.dept_id, '0001', 0, '0007', 0, a.amt15)  + decode(b.dept_id, '0001', 0, '0007', 0, a.amt21) + decode(b.dept_id, '0001', 0, '0007', 0, a.amt24))  i_amt, \n"+
						 "	 trunc(((a.amt5+a.amt6 +a.amt7+ a.amt8)/ (a.rent_way_1_cnt + a.rent_way_2_cnt) * decode(b.user_id, '000076', a.rent_way_2_cnt+ a.rent_way_1_cnt, a.rent_way_2_cnt)) +  decode(b.dept_id, '0001', a.amt10, '0007', a.amt10, a.amt12) + decode(b.dept_id, '0001', a.amt14, '0007', a.amt14, a.amt13)+ decode(b.dept_id, '0001', a.amt19, '0007', a.amt19, a.amt18) - decode(b.dept_id, '0001', a.amt23, '0007', a.amt23, a.amt20) + decode(b.dept_id, '0001', a.amt15+a.amt16, '0007', a.amt15+a.amt16,  a.amt16 )+decode(b.dept_id, '0001', a.amt9, '0007', a.amt9, a.amt22) + decode(b.dept_id, '0001', a.amt25, '0007', a.amt25, a.amt2))  b_amt, \n"+
						 "	 a.*, b.dept_id, b.user_nm, b.user_id , decode(b.dept_id,'0001','영업팀','0002','고객지원팀','0003','총무팀','0007','부산지점','0008','대전지점','8888', '기타', ' ') as dept_nm \n"+
						 "	 from stat_bus_cost_cmp a, users b, \n"+ 
						 "	 (select sum(amt5+amt6+amt7+amt8) all_g_amt, sum(decode(dept_id, '0001', 0, '0007', 0, amt1)  + decode(dept_id, '0001', 0, '0007', 0, amt3) + decode(dept_id, '0001', 0, '0007', 0, amt4)   - decode(dept_id, '0001', 0, '0007', 0, amt11)  + decode(dept_id, '0001', 0, '0007', 0, amt15)  +  decode(dept_id, '0001', 0, '0007',0, amt21) + decode(dept_id, '0001', 0, '0007', 0, amt24)) all_i_amt,  \n"+
						 "     sum( decode(dept_id,'0001', amt10, '0007', amt10, amt12)+ decode(dept_id, '0001', amt14, '0007', amt14, amt13) + decode(dept_id, '0001', amt19, '0007', amt19, amt18) - decode(dept_id, '0001', amt23, '0007', amt23, amt20) + decode(dept_id, '0001', amt15+amt16, '0007', amt15+amt16, amt16 ) + decode(dept_id, '0001', amt9, '0007', amt9, amt22) + decode(dept_id, '0001', amt25, '0007', amt25, amt2)) all_b_amt, \n"+
						 "     sum(rent_way_1_cnt) su_1_cnt, sum(rent_way_2_cnt) su_2_cnt from stat_bus_cost_cmp a,  users b where a.bus_id=b.user_id and a.gubun = '"+gubun+"' and a.save_dt='"+save_dt+"'  and b.use_yn = 'Y') c \n"+
						 "	  where a.bus_id=b.user_id and a.gubun =  '"+gubun+"' and a.save_dt='"+save_dt+"' and b.use_yn = 'Y'  ) aa \n ";
				 
					   
		
		}	
	
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
			System.out.println("[CostDatabase:getCostManCampaign(String save_dt, String gubun, String loan_st, String s_dt, String e_dt)]"+e);
			System.out.println(query);
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
	 *	비용마감 프로시져 호출
	*/
	public String call_sp_cost_magam(String s_day, String gubun, String s_user_id)
	{
    	getConnection();
    	
    	String query = "{CALL P_COST_MAGAM (?,?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, s_day);
			cstmt.setString(2, gubun);
			cstmt.setString(3, s_user_id);
			cstmt.registerOutParameter( 4, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(4); // 결과값
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[CostDatabase:call_sp_cost_magam]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	
	/*
	 *	비용마감 프로시져 호출
	*/
	public String call_sp_sale_cost_magam(String s_day, String s_user_id)
	{
    	getConnection();
    	
    	String query = "{CALL P_SALE_COST_MAGAM (?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, s_day);
			cstmt.setString(2, s_user_id);
			cstmt.registerOutParameter( 3, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[CostDatabase:call_sp_sale_cost_magam]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	
	/*
	 *	비용마감 프로시져 호출 - 사고별
	*/
	public String call_sp_cost_accident_magam(String s_day, String s_user_id)
	{
    	getConnection();
    	
    	String query = "{CALL P_MAN_COST_ACCIDENT (?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, s_day);
			cstmt.setString(2, s_user_id);
			cstmt.registerOutParameter( 3, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[CostDatabase:call_sp_cost_accident_magam]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	
	
	/*
	 *	비용마감 프로시져 호출 - 계약별
	*/
	public String call_sp_cost_base_magam(String s_day, String s_user_id)
	{
    	getConnection();
    	
    	String query = "{CALL P_MAN_COST_BASE (?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, s_day);
			cstmt.setString(2, s_user_id);
			cstmt.registerOutParameter( 3, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[CostDatabase:call_sp_cost_base_magam]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	
	
	/*
	 *	비용마감 프로시져 호출 - 보유차해당건
	*/
	public String call_sp_cost_pre_base_magam(String s_day, String s_user_id)
	{
    	getConnection();
    	
    	String query = "{CALL P_MAN_COST_PRE_BASE (?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, s_day);
			cstmt.setString(2, s_user_id);
			cstmt.registerOutParameter( 3, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[CostDatabase:call_sp_cost_pre_base_magam]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	

	/*
	 *	비용마감 프로시져 호출 - 관리팀 관리비용 마감
	*/
	public String call_sp_man_cost_magam(String s_day, String s_user_id)
	{
    	getConnection();
    	
    	String query = "{CALL P_MAN_COST_MAGAM (?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, s_day);
			cstmt.setString(2, s_user_id);
			cstmt.registerOutParameter( 3, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[CostDatabase:call_sp_man_cost_magam]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	
	/*
	 *	비용마감 프로시져 호출 - 영업팀 관리비용 마감
	*/
	public String call_sp_man_cost3_magam(String s_day, String s_user_id)
	{
    	getConnection();
    	
    	String query = "{CALL P_MAN_COST3_MAGAM (?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, s_day);
			cstmt.setString(2, s_user_id);
			cstmt.registerOutParameter( 3, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[CostDatabase:call_sp_man_cost3_magam]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	
	/*
	 *	비용마감 프로시져 호출
	*/
	public String call_sp_sale_cost_base_magam(String s_day, String s_user_id)
	{
    	getConnection();
    	
    	String query1 = "{CALL P_SALE_COST_BASE_MAGAM (?)}";

    	String query2 = "{CALL P_SALE_COST_BASE_MAGAM2 (?)}";

		String query3 = "{CALL P_SALE_COST_BASE_MAGAM3 (?)}";

    	String query4 = "{CALL P_SALE_COST_BASE_MAGAM4 (?)}";

    	String query5 = "{CALL P_SALE_COST_BASE_MAGAM5 (?)}";

    	String query6 = "{CALL P_SALE_COST_BASE_MAGAM6 (?)}";

    	String query7 = "{CALL P_SALE_COST_BASE_MAGAM7 (?)}";

    	String query8 = "{CALL P_SALE_COST_BASE_MAGAM8 (?)}";

    	String query9 = "{CALL P_SALE_COST_BASE_MAGAM9 (?)}";

    	String query10 = "{CALL P_SALE_COST_BASE_MAGAM10 (?)}";

    	String query11 = "{CALL P_SALE_COST_BASE_MAGAM11 (?)}";

    	String query13 = "{CALL P_SALE_COST_BASE_MAGAM13 (?)}";

    	String query14 = "{CALL P_SALE_COST_BASE_MAGAM_APPLY (?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		CallableStatement cstmt2 = null;
		CallableStatement cstmt3 = null;
		CallableStatement cstmt4 = null;
		CallableStatement cstmt5 = null;
		CallableStatement cstmt6 = null;
		CallableStatement cstmt7 = null;
		CallableStatement cstmt8 = null;
		CallableStatement cstmt9 = null;
		CallableStatement cstmt10 = null;
		CallableStatement cstmt11 = null;
		CallableStatement cstmt12 = null;
		CallableStatement cstmt13 = null;
		
		
		try {

			cstmt = conn.prepareCall(query1);			
			cstmt.registerOutParameter( 1, java.sql.Types.VARCHAR );			
			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값
			cstmt.close();

			cstmt2 = conn.prepareCall(query2);			
			cstmt2.registerOutParameter( 1, java.sql.Types.VARCHAR );			
			cstmt2.execute();
			sResult = cstmt2.getString(1); // 결과값
			cstmt2.close();

			cstmt3 = conn.prepareCall(query3);			
			cstmt3.registerOutParameter( 1, java.sql.Types.VARCHAR );			
			cstmt3.execute();
			sResult = cstmt3.getString(1); // 결과값
			cstmt3.close();

			cstmt4 = conn.prepareCall(query4);			
			cstmt4.registerOutParameter( 1, java.sql.Types.VARCHAR );			
			cstmt4.execute();
			sResult = cstmt4.getString(1); // 결과값
			cstmt4.close();

			cstmt5 = conn.prepareCall(query5);			
			cstmt5.registerOutParameter( 1, java.sql.Types.VARCHAR );			
			cstmt5.execute();
			sResult = cstmt5.getString(1); // 결과값
			cstmt5.close();

			cstmt6 = conn.prepareCall(query6);			
			cstmt6.registerOutParameter( 1, java.sql.Types.VARCHAR );			
			cstmt6.execute();
			sResult = cstmt6.getString(1); // 결과값
			cstmt6.close();
	
			cstmt7 = conn.prepareCall(query7);			
			cstmt7.registerOutParameter( 1, java.sql.Types.VARCHAR );			
			cstmt7.execute();
			sResult = cstmt7.getString(1); // 결과값
			cstmt7.close();

			cstmt8 = conn.prepareCall(query8);			
			cstmt8.registerOutParameter( 1, java.sql.Types.VARCHAR );			
			cstmt8.execute();
			sResult = cstmt8.getString(1); // 결과값
			cstmt8.close();

			cstmt9 = conn.prepareCall(query9);			
			cstmt9.registerOutParameter( 1, java.sql.Types.VARCHAR );			
			cstmt9.execute();
			sResult = cstmt9.getString(1); // 결과값
			cstmt9.close();

			cstmt10 = conn.prepareCall(query10);			
			cstmt10.registerOutParameter( 1, java.sql.Types.VARCHAR );			
			cstmt10.execute();
			sResult = cstmt10.getString(1); // 결과값
			cstmt10.close();

			cstmt11 = conn.prepareCall(query11);			
			cstmt11.registerOutParameter( 1, java.sql.Types.VARCHAR );			
			cstmt11.execute();
			sResult = cstmt11.getString(1); // 결과값
			cstmt11.close();

			cstmt12 = conn.prepareCall(query13);			
			cstmt12.registerOutParameter( 1, java.sql.Types.VARCHAR );			
			cstmt12.execute();
			sResult = cstmt12.getString(1); // 결과값
			cstmt12.close();

			cstmt13 = conn.prepareCall(query14);			
			cstmt13.registerOutParameter( 1, java.sql.Types.VARCHAR );			
			cstmt13.execute();
			sResult = cstmt13.getString(1); // 결과값
			cstmt13.close();


		} catch (SQLException e) {
			System.out.println("[CostDatabase:call_sp_sale_cost_base_magam]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)		cstmt.close();
				 if(cstmt2 != null)		cstmt2.close();
				 if(cstmt3 != null)		cstmt3.close();
				 if(cstmt4 != null)		cstmt4.close();
				 if(cstmt5 != null)		cstmt5.close();
				 if(cstmt6 != null)		cstmt6.close();
				 if(cstmt7 != null)		cstmt7.close();
				 if(cstmt8 != null)		cstmt8.close();
				 if(cstmt9 != null)		cstmt9.close();
				 if(cstmt10 != null)	cstmt10.close();
				 if(cstmt11 != null)	cstmt11.close();
				 if(cstmt12 != null)	cstmt12.close();
				 if(cstmt13 != null)	cstmt13.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	


//13 parameter
public Vector getDlyCostStatMList3(String dt, String ref_dt1, String ref_dt2, String mng_id, int amt1, int amt2, int amt1_per , int amt2_per, int amt3_per, int bus_cost_per, int mng_cost_per , String gg, String mng_br_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		String f_date1="";
		String t_date1="";
		
		f_date1=  ref_dt1;
		t_date1=  ref_dt2;
	
	
	        if ( gg.equals("03") ) {
	        	
	         query = " select '03' gg, 'Y' use_yn, '' car_st, '자동차검사' rent_l_cd,  ' 직접검사' rent_way, a.item_name car_no, b.car_nm car_nm , substr(a.acct_cont,1, 10) firm_nm, nvl(a.buy_user_id,'999999') as user_id,  a.buy_dt serv_dt,  \n"+ 
	    		   "  '자동차검사' gubun , a.buy_amt amt , 0 per  \n"+ 
	       		   " from card_doc a, car_reg b where   a.acct_code = '00005' and a.acct_code_g = '7' and a.acct_cont not like '%아마존카%' and nvl(a.buy_user_id,'999999')  = '" + mng_id + "' and a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and a.item_code = b.car_mng_id(+)  \n"+ 
	       		   " 	union all \n"+ 
	       		   " select '03' gg, a.use_yn,  a.car_st, a.rent_l_cd, '마스타검사' rent_way, cr.car_no, cr.car_nm, a.firm_nm, b.bus_id as user_id, b.js_dt serv_dt,   \n"+  
				   "  '자동차검사' gubun, b.sbgb_amt amt, 0 per  from cont_n_view a, master_car b , car_reg cr   \n"+  
				   "   where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.sbshm = '1' and a.car_st <>'2' and a.car_mng_id = cr.car_mng_id  \n"+ 
				   "     and b.bus_id  = '" + mng_id + "' and  b.js_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n"+ 
				   " 	union all \n"+ 
	       		   " select '03' gg, a.use_yn,  a.car_st, a.rent_l_cd, '성수검사' rent_way, cr.car_no, cr.car_nm, a.firm_nm, b.mng_id as user_id, b.che_dt serv_dt,   \n"+  
				   "  '자동차검사' gubun, b.che_amt amt, 0 per  from cont_n_view a, car_maint_req b , car_reg cr   \n"+  
				   "   where a.rent_l_cd=b.rent_l_cd and a.car_st <>'2'  and a.car_mng_id = cr.car_mng_id \n"+ 
				   "     and a.mng_id  = '" + mng_id + "' and  b.che_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n";
			   
	        } else    if ( gg.equals("10") ) {
	        	
	         query = " select '10' gg, a.use_yn,  a.car_st, a.rent_l_cd, b.sbshm rent_way, cr.car_no, cr.car_nm, a.firm_nm, b.bus_id as user_id,  b.js_dt serv_dt,   \n"+  
			   "  '긴급출동' gubun, b.sbgb_amt amt, 0 per  from cont_n_view a, master_car b , car_reg cr  \n"+  
			   "   where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.sbshm <> '1' and a.car_mng_id = cr.car_mng_id  \n"+ 
			   "     and b.bus_id  = '" + mng_id + "' and  b.js_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n";
			   
	        } else    if ( gg.equals("07") ) {

		                //탁송료   	
		                query =	  " select a.* from ( \n" +     	              
    		            		 "  select   /*+ leading(c b) use_nl(c b) index(d DOC_SETTLE_IDX2) merge(a) */  '07' gg, a.use_yn,  b.cons_st car_st, decode(b.cons_cau, '4', '(자)정비대차인도', '5', '(자)사고대차인도', '6', '(자)정비차량인도', '7', '(자)사고차량인도', '9', '(자)정비대차회수', '10', '(자)사고대차회수', '11', '(자)정비차량회수' , '12', '(자)사고차량회수', '13', '(자)중도해지회수', '14', '(자)만기반납', '16', '(자)본사이동', '17', '지점이동' , '18', '(자)정기검사', '19', '(자)차량점검', '20', '(자)기타'  ) rent_l_cd,    	\n"+  
		            		 "  decode(b.cons_st, '1', '편도', '왕복') rent_way, cr.car_no, cr.car_nm, a.firm_nm,  decode(a.car_st, '2',  nvl(b.req_id, d.user_id1), nvl(a.bus_id4, a.mng_id) )   as user_id,  b.req_dt serv_dt, '탁송료' gubun,  c.cons_amt/ c.cons_cnt  amt, 0 per   \n"+ 
		            		 "   from consignment b, doc_settle d,  cont_n_view a,  car_reg cr,  (   select /*+ leading(b d) */  b.cons_no, count(b.cons_no) cons_cnt,  sum(b.tot_amt) - sum(b.oil_amt) cons_amt from consignment b, doc_settle d  \n"+ 
                           			 "	   where b.cost_st = '1'  and b.cons_cau not in ('1', '3', '8', '14', '15' , '16', '17') and d.doc_st = '2'  and b.off_id not in ('003158') and d.doc_id = b.cons_no and  b.req_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') group by b.cons_no  ) c  \n"+ 
                           			 "  where b.cons_no = d.doc_id and d.doc_st = '2' and  b.cons_no = c.cons_no    \n"+    
			                    "      and  b.rent_mng_id= a.rent_mng_id and b.rent_l_cd = a.rent_l_cd  and b.cons_cau not in ('1', '3', '8', '14', '15' , '16', '17')   and a.car_mng_id = cr.car_mng_id(+)  \n"+        
			    		"       and decode(a.car_st, '2',  nvl(b.req_id, d.user_id1), nvl(a.bus_id4, a.mng_id) ) = '" + mng_id + "' and  b.req_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')   ) a where a.amt > 0  \n"+           
    		   " 	union all \n"+         			
			   " select /*+ leading(b d) use_nl(b d) merge(a) index(d DOC_SETTLE_IDX2) */ '07' gg, a.use_yn,  b.cons_st car_st, decode(b.cons_cau, '4', '(자)정비대차인도', '5', '(자)사고대차인도', '6', '(자)정비차량인도', '7', '(자)사고차량인도', '9', '(자)정비대차회수', '10', '(자)사고대차회수', '11', '(자)정비차량회수' , '12', '(자)사고차량회수', '13', '(자)중도해지회수', '14', '(자)만기반납', '16', '(자)본사이동', '17', '지점이동' , '18', '(자)정기검사', '19', '(자)차량점검', '20', '(자)기타'  ) rent_l_cd,  \n"+  
			   "  decode(b.cons_st, '1', '편도', '왕복') rent_way, cr.car_no, cr.car_nm, a.firm_nm,  nvl(d.user_id1,'999999')  as user_id,  b.reg_dt serv_dt, '탁송료' gubun, \n"+ 
			   "   nvl(c.cms_bk *c.app_st, 0)  as amt, 0 per \n"+ 
			   "	from cont_n_view a, consignment b, doc_settle d, car_reg cr,   (select * from code where c_st='0022') c where a.rent_mng_id= b.rent_mng_id and a.rent_l_cd = b.rent_l_cd  and a.car_mng_id = cr.car_mng_id(+) \n"+ 
			   " 	and b.cost_st = '1' and b.cmp_app=c.nm_cd(+)  and b.cons_cau not in ('1', '3', '8', '14', '15', '16', '17' ) and d.doc_st = '2'  and b.off_id = '003158' \n"+ 
			   "    and d.doc_id = b.cons_no and d.user_id1 <> b.driver_nm and nvl(d.user_id1,'999999') = '" + mng_id + "'\n"+ 
			   "	and b.reg_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n"+  
			   " union all \n"+  
			   " select /*+ leading(b d) use_nl(b d) merge(a) index(d DOC_SETTLE_IDX2)  */ '07' gg, a.use_yn,  b.cons_st car_st, decode(b.cons_cau, '4', '(자)정비대차인도', '5', '(자)사고대차인도', '6', '(자)정비차량인도', '7', '(자)사고차량인도', '9', '(자)정비대차회수', '10', '(자)사고대차회수', '11', '(자)정비차량회수' , '12', '(자)사고차량회수', '13', '(자)중도해지회수', '14', '(자)만기반납', '16', '(자)본사이동', '17', '(자)지점이동' , '18', '(자)정기검사', '19', '(자)차량점검', '20', '(자)기타'  ) rent_l_cd,  \n"+ 
			   "   decode(b.cons_st, '1', '편도', '왕복') rent_way, cr.car_no, cr.car_nm, a.firm_nm, nvl(b.driver_nm,'999999')  as user_id, b.reg_dt serv_dt, '탁송료' gubun, \n"+ 
			   "	nvl(c.cms_bk *c.app_st, 0) * (-1)  as amt, 0 per \n"+ 
			   "	 from cont_n_view a, consignment b, doc_settle d,  car_reg cr,  (select * from code where c_st='0022') c where a.rent_mng_id= b.rent_mng_id and a.rent_l_cd = b.rent_l_cd  and a.car_mng_id = cr.car_mng_id(+) \n"+ 
			   "	 and b.cost_st = '1' and b.cmp_app=c.nm_cd(+)  and b.cons_cau not in ('1', '3', '8', '14',  '15', '16', '17' ) and d.doc_st = '2'  and b.off_id = '003158' \n"+ 
			   "	 and d.doc_id = b.cons_no and d.user_id1 <> b.driver_nm and nvl(b.driver_nm,'999999')  = '" + mng_id + "'\n"+ 
			   "	 and b.reg_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  \n";        	
	
	        } else    if ( gg.equals("08") ) {  //유류대 - 탁송:청구일자 금액 setting 
	 	   
	 	            query =	  " select '08' gg, 'Y' use_yn, '' car_st, decode(a.o_cau, '1', '대여차량인도', '3', '지연대차인도', '4', '정비대차인도', '5', '사고대차인도', '6', '정비차량인도', '7', '사고차량인도','8', '지연대차회수',  '9', '정비대차회수', '10', '사고대차회수', '11', '정비차량회수' , '12', '사고차량회수', '13', '중도해지회수', '14', '만기반납', '15', '대여차량회수', '16', '본사이동', '17', '지점이동' , '18', '정기검사', '19', '차량점검', '20', '기타'  ) rent_l_cd,   \n"+  
	 	             " '카드' rent_way, a.item_name car_no, b.car_nm car_nm , '' firm_nm, nvl(a.buy_user_id,'999999') as user_id, a.buy_dt serv_dt,  \n"+ 
    		             "  '유류대' gubun , (a.buy_amt - nvl(a.m_amt,0))  amt , 0 per  \n"+ 
       		             " from card_doc a , car_reg b where    a.acct_code = '00004' and a.acct_code_g2 in ( '12', '13') and   nvl(a.buy_user_id,'999999')  = '" + mng_id + "' and a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and a.item_code = b.car_mng_id(+) \n"+ 
       		                " union all \n"+ 	        
       		             " select '08' gg, 'Y' use_yn,  '' car_st, decode(b.o_cau, '1', '대여차량인도', '3', '지연대차인도', '4', '정비대차인도', '5', '사고대차인도', '6', '정비차량인도', '7', '사고차량인도','8', '지연대차회수',  '9', '정비대차회수', '10', '사고대차회수', '11', '정비차량회수' , '12', '사고차량회수', '13', '중도해지회수', '14', '만기반납', '15', '대여차량회수', '16', '본사이동', '17', '지점이동' , '18', '정기검사', '19', '차량점검', '20', '기타', b.p_cont  )  rent_l_cd,  \n"+  
       		             " '현금'  rent_way, '' car_no, '' car_nm, '' firm_nm, b.buy_user_id as user_id, a.p_pay_dt serv_dt,   \n"+  
			    "  '유류대' gubun, b.i_amt amt, 0 per  from pay a, pay_item b \n"+ 
			    " where a.reqseq=b.reqseq and b.acct_code='45800' and b.buy_user_id  = '" + mng_id + "' and a.p_pay_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  \n"+ 
			    " union all \n"+ //탁송유류         
			   " select /*+ leading(b d) merge(a) index(d DOC_SETTLE_IDX2)*/ '08' gg, a.use_yn,  b.cons_st car_st, decode(b.cons_cau, '1', '대여차량인도', '3', '지연대차인도', '4', '정비대차인도', '5', '사고대차인도', '6', '정비차량인도', '7', '사고차량인도','8', '지연대차회수',  '9', '정비대차회수', '10', '사고대차회수', '11', '정비차량회수' , '12', '사고차량회수', '13', '중도해지회수', '14', '만기반납', '15', '대여차량회수', '16', '본사이동', '17', '지점이동' , '18', '정기검사', '19', '차량점검', '20', '기타'  ) rent_l_cd, \n"+  
   			   "  decode(b.cons_st, '1', '편도', '왕복') rent_way, cr.car_no, cr.car_nm, a.firm_nm, decode(a.car_st, '2',  nvl(b.req_id, d.user_id1), nvl(a.bus_id4, a.mng_id) )as user_id, b.req_dt serv_dt, '유류대' gubun, nvl(b.oil_amt,0) - nvl(b.m_amt,0)  as amt, 0 per   \n"+
	 		   "  from cont_n_view a, consignment b, doc_settle d, car_reg cr  where a.rent_mng_id= b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and a.car_mng_id = cr.car_mng_id(+) \n"+
	    		   " and b.cost_st = '1'  and  d.doc_st = '2'  \n"+
	        		   " and  nvl(b.oil_amt,0) > 0 and d.doc_id = b.cons_no and decode(a.car_st, '2',  nvl(b.req_id, d.user_id1), nvl(a.bus_id4, a.mng_id) ) = '" + mng_id + "' and  b.req_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')    \n"; 			      			      
	         	          		        		        	
	        } else    if ( gg.equals("05") ) {  		        	
	
	       query =  " select   '05' gg,  v.use_yn use_yn, c.dpm car_st, a.rent_s_cd|| ' ' || decode(a.rent_st , '2', '정비', '3', '사고' )  rent_l_cd, substr(a.deli_dt, 1,8) rent_way, c.car_no,  \n"+    
	       		    "    c.car_nm, v.firm_nm, a. bus_id  as user_id,   substr(a.ret_dt,1,8) serv_dt, '대차비용' gubun,  \n"+		                       
                     	   "   ( case when v.car_gu = 0 and decode(v.rent_way_cd, '1', '1' , '2') <> '1' and a.rent_st = '2' then 0  \n"+
                               "            when v.car_gu = 0 and decode(v.rent_way_cd, '1', '1' , '2') = '1' and a.rent_st = '2' and substr(a.deli_dt,1,8)  < to_char(add_months(to_date(v.rent_start_dt), 2), 'yyyymmdd') then 0 \n"+
                        	   "     	  else  trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8)))+1)  end  ) *  nvl(round(sh.fee_s_amt/30,-3), 0)  amt ,  \n"+          
                               "   case when v.car_gu = 0 and decode(v.rent_way_cd, '1', '1' , '2') <> '1' and a.rent_st = '2' then 0  \n"+
                               "            when v.car_gu = 0 and decode(v.rent_way_cd, '1', '1' , '2') = '1' and a.rent_st = '2' and substr(a.deli_dt,1,8)  < to_char(add_months(to_date(v.rent_start_dt), 2), 'yyyymmdd') then 0 \n"+
                        	   "     	  else  trunc((nvl(to_date(substr(a.ret_dt, 1, 8)), sysdate) -  to_date(substr(a.deli_dt, 1, 8)))+1)  end per \n"+
		            "        from RENT_CONT a, CAR_REG c, users u, cont_n_view v,  \n"+
		            "          (  select rent_s_cd, max(reg_dt) reg_dt from ( \n"+
		            "            SELECT r.rent_s_cd, r.car_mng_id , a.est_id , a.reg_dt  \n"+
		            "                from  rent_cont r, ( select * from  estimate_sh where est_from ='res_car' and est_fax='Y' ) a \n"+
		            "            WHERE r.use_st in  ('2', '3', '4') and r.rent_st in ('2', '3')  and  r.deli_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  \n"+
		            "            and a.rent_dt between substr(r.deli_dt,0,6) and substr(nvl(r.ret_dt,to_char(sysdate,'YYYYMMDD')),0,8) \n"+
		            "            AND r.car_mng_id = a.est_ssn \n"+
		            "            )a group by rent_s_cd ) b , estimate_sh sh\n"+
		            "          where a.use_st  in ('2' , '3', '4' )    and a.car_mng_id=c.car_mng_id  and a.rent_st in ('2', '3')  \n"+
		             "            and a.deli_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  \n"+
		             "            and a.sub_l_cd = v.rent_l_cd(+)  \n"+
		             "            and a.rent_s_cd = b.rent_s_cd(+) and b.reg_dt = sh.reg_dt and a.car_mng_id = sh.est_ssn \n"+
		             "            and sh.est_from ='res_car' and sh.est_fax='Y' \n"+
		             "            and  a.bus_id=u.user_id and u.user_pos in ('사원','대리','과장', '차장') and a.bus_id = '" + mng_id + "'    \n"+
		             "            and u.user_id not in ('000006') and a.car_mng_id=c.car_mng_id(+)  " ;            
	
	  // 
	       } else    if ( gg.equals("06") ) {  		        	
	          query =	  "  select  /*+ leading(b) merge(a) */ '06' gg, b.use_yn,  b.car_st, b.rent_l_cd, b.rent_way, cr.car_no, cr.car_nm, b.firm_nm, e.bus_id2 as user_id, se.ext_pay_dt serv_dt, '휴/대차료' gubun, se.ext_pay_amt*(-1) as amt, 0 per 	from accident a, cont_n_view b, my_accid e , scd_ext se , car_reg cr  \n"+ 
   			   "	where e.req_st in ('1' , '2', '3')  and e.car_mng_id=a.car_mng_id and e.accid_id=a.accid_id and a.car_mng_id=b.car_mng_id  and nvl(e.bus_id2, b.bus_id2)  = '" + mng_id + "' \n" +
   			   "    and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id=se.rent_mng_id and a.rent_l_cd=se.rent_l_cd and se.ext_st = '6' and e.accid_id||e.seq_no = se.ext_id  \n" +
   			   "    and a.car_mng_id = cr.car_mng_id(+) and se.ext_pay_dt  between  replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n" + 	
   		            " union all  \n" +
   			   "   select   '06' gg, b.use_yn,  b.car_st, b.rent_l_cd, b.rent_way, c.car_no, c.car_nm, b.firm_nm, o.amor_req_id  as user_id, o.amor_pay_dt serv_dt, '경락손해' gubun , o.amor_pay_amt*(-1)  as amt, 0 per \n"+
   			   "   from ot_accid o, accident a, cont_n_view b , car_reg c  where  o.car_mng_id = a.car_mng_id and o.accid_id = a.accid_id and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd  \n" +
   			   "  and o.car_mng_id = c.car_mng_id and nvl(c.f5_chk, 'N') < > 'Y' and  o.amor_type = '1'   \n" +
   			   "   and o.amor_pay_dt  between   replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')   and  o.amor_req_id  = '" + mng_id + "'    \n"+             
                               " ";                   
   	
   	       } else    if ( gg.equals("11") ) {  				   
   		query =    " select '11' gg, 'Y' use_yn,  '' car_st, '통신비'  rent_l_cd, ''  rent_way, '' car_no, '' car_nm, '' firm_nm, c.pay_user as user_id,  a.p_pay_dt serv_dt,   \n"+  
			   "  '통신비' gubun, c.pay_amt amt, 0 per  from pay a, pay_item b, pay_item_user c \n"+ 
			   " where a.reqseq=b.reqseq and b.reqseq=c.reqseq and b.i_seq=c.i_seq and b.acct_code='81400' and c.pay_user  = '" + mng_id + "' \n" +
			   "   and a.p_pay_dt between replace('" + f_date1 + "','-','') and replace('20111130','-','')  \n";
			     
	       } else    if ( gg.equals("13") ) {  					   
   		query =    " select '13' gg, 'Y' use_yn,  '' car_st, '교통비'  rent_l_cd, ''  rent_way, '' car_no, '' car_nm, '' firm_nm, b.buy_user_id as user_id, a.p_pay_dt serv_dt,   \n"+  
			   "  '교통비외' gubun, b.i_amt amt, 0 per  from pay a, pay_item b \n"+ 
			   " where a.reqseq=b.reqseq and b.acct_code='81200' and b.buy_user_id  = '" + mng_id + "' and a.p_pay_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n"+  
			   " 	union all \n"+ 	  			       
			   " select '13' gg, 'Y' use_yn, '' car_st, decode(a.acct_code_g, '9', '출장비', '10', '기타교통비', '20', '하이패스', '') rent_l_cd,  '카드' rent_way, a.item_name car_no, '' car_nm , '' firm_nm, nvl(a.buy_user_id,'999999') as user_id,  a.buy_dt serv_dt,  \n"+ 
	    		   "  '교통비외' gubun , a.buy_amt amt , 0 per  \n"+ 
	       		   " from card_doc a where    a.acct_code = '00003'  and a.acct_code_g not in ('32')  and  nvl(a.buy_user_id,'999999')  = '" + mng_id + "' and a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n"+  
	       		      " 	union all \n"+ 	 
	       		     " select '13' gg, 'Y' use_yn, '' car_st,  ' 주차요금',  '카드' rent_way, a.item_name car_no, '' car_nm , '' firm_nm, nvl(a.buy_user_id,'999999') as user_id,  a.buy_dt serv_dt,  \n"+ 
	    		   "  '교통비외' gubun , a.buy_amt amt , 0 per  \n"+ 
	       		   " from card_doc a where    a.acct_code = '00019'  and nvl(a.buy_user_id,'999999')  = '" + mng_id + "' and a.buy_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n"+ 
	       		    " 	union all \n"+ 
	       		    	   //본사 고객지원
	       		    " select '13' gg, 'Y' use_yn,  '' car_st, '주차요금'  rent_l_cd, ''  rent_way, '' car_no, '' car_nm, '' firm_nm,  ''  as user_id, a.p_pay_dt serv_dt,   \n"+  
			   "  '교통비외' gubun, sum( b.i_amt ) /17  amt, 0 per  from pay a, pay_item b, users u  \n"+ 
			   " where a.reqseq=b.reqseq and b.acct_code='81900' and a.off_id = '300891'   and u.user_id ='" + mng_id + "' and u.dept_id = '0002'  and a.p_pay_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n"+  		
	       		  "  group by a.p_pay_dt  \n"+
	       		   " 	union all \n"+ 
	       		      	   //본사 영업팀
	       		    " select '13' gg, 'Y' use_yn,  '' car_st, '주차요금'  rent_l_cd, ''  rent_way, '' car_no, '' car_nm, '' firm_nm,  ''  as user_id, a.p_pay_dt serv_dt,   \n"+  
			   "  '교통비외' gubun, sum( b.i_amt ) /6  amt, 0 per  from pay a, pay_item b, users u  \n"+ 
			   " where a.reqseq=b.reqseq and b.acct_code='81900' and a.off_id = '001253'  and b.p_cont like '%주차%'  and u.user_id = '000028'   and u.user_id ='" + mng_id + "' and u.dept_id = '0001'  and a.p_pay_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n"+  		
	       		  "  group by a.p_pay_dt  \n"+
	       		  
	       		   " 	union all \n"+ 	
	       		     //부산지점
	       		  " select '13' gg, 'Y' use_yn,  '' car_st, '주차요금'  rent_l_cd, ''  rent_way, '' car_no, '' car_nm, '' firm_nm, '' as user_id, a.p_pay_dt serv_dt,   \n"+  
			   "  '교통비외' gubun, sum( b.i_amt ) /13  amt, 0 per  from pay a, pay_item b, users u  \n"+ 
			   " where a.reqseq=b.reqseq and b.acct_code='81900'  and a.off_id = '1003748' and u.user_id ='" + mng_id + "'  and u.dept_id = '0007'    and a.p_pay_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n" +
			   "  group by a.p_pay_dt  \n";     		
	       		   	
                  } else    if ( gg.equals("01") ) {  		    
	        					
 			//신차 정비 
 	 	  query = "  select /*+ leading(b) merge(a) */ '01' gg, a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, cr.car_nm, a.firm_nm, '' user_id, c.serv_dt, '정비비 ' || c.gubun   gubun, sum(c.bus_amt + c.mng_amt ) amt, 0 per from ( \n" +
          	   "  	select /*+ leading(b) merge(a) */ b.rent_mng_id, b.rent_l_cd,  a.bus_id, nvl(b.bus_id2, a.mng_id) mng_id, nvl(b.reg_dt, b.serv_dt) serv_dt,  b.serv_dt gubun , \n"+
               "		decode( a.bus_id, '" + mng_id + "', ( sum ( case when decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)) > "+ amt1+"  then "+ amt1 + " + ((decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt) ) - "+amt1+")*"+amt1_per+"/100)  else  decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)) end) * "+bus_cost_per+"/ 100 ) , 0 ) bus_amt,  \n"+
               "  		decode(nvl(b.bus_id2, a.mng_id), '" + mng_id + "', ( sum ( case when decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)) > "+ amt1+"  then "+ amt1 + " + ((decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt) ) - "+amt1+")*"+amt1_per+"/100)  else  decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)) end) * "+mng_cost_per+"/ 100 ) , 0 )  mng_amt    \n"+  
			   "       from cont_n_view a, service b \n"+
			   "       where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.client_id not in ('000231', '000228') \n"+
			   "       and b.serv_st not in ('11', '4', '5', '12',  '13')  and a.car_gu  = '1'  \n"+
			   "       and nvl(b.reg_dt, b.serv_dt) between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and replace(a.rent_start_dt, '-', '') <= nvl(b.reg_dt, b.serv_dt)  \n"+
			   "       and (a.bus_id = '" + mng_id + "' or  nvl(b.bus_id2, a.mng_id) = '" + mng_id + "' )  \n"+
			   "	   and nvl(decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)*1.1 ), 0) > 0  \n"+
			   "       group by b.rent_mng_id, b.rent_l_cd,  a.bus_id, nvl(b.bus_id2, a.mng_id) , nvl(b.reg_dt, b.serv_dt) , b.serv_dt \n"+
			   ") c, cont_n_view a , car_reg cr \n"+ 
			   "where c.rent_mng_id = a.rent_mng_id and c.rent_l_cd = a.rent_l_cd and a.car_mng_id = cr.car_mng_id(+)  \n"+ 
			   "group by  a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, cr.car_nm, a.firm_nm, c.serv_dt ,  c.gubun \n"+ 					   		   			
 	
 				//재리스 일반식
 			   " 	union all \n"+	
 			   "  select /*+ leading(b) merge(a) */ '01' gg, a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, cr.car_nm, a.firm_nm, '' user_id, c.serv_dt, '정비비 ' || c.gubun  gubun, sum(c.bus_amt + c.mng_amt ) amt, 0 per from ( \n" +
          	   "  	select /*+ leading(b) merge(a) */ b.rent_mng_id, b.rent_l_cd,  a.bus_id, nvl(b.bus_id2, a.mng_id) mng_id, nvl(b.reg_dt, b.serv_dt) serv_dt,  b.serv_dt  gubun , \n"+
               "		decode( a.bus_id, '" + mng_id + "', ( sum ( case when decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)) > "+ amt1+"  then "+ amt1 + " + ((decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt) ) - "+amt1+")*"+amt1_per+"/100)  else  decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)) end) * "+bus_cost_per+"/ 100 ) , 0 ) bus_amt,  \n"+
               "  		decode(nvl(b.bus_id2, a.mng_id), '" + mng_id + "', ( sum ( case when decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)) > "+ amt1+"  then "+ amt1 + " + ((decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt) ) - "+amt1+")*"+amt1_per+"/100)  else  decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)) end) * "+mng_cost_per+"/ 100 ) , 0 )  mng_amt    \n"+  
			   "       from cont_n_view a, service b \n"+
			   "       where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.client_id not in ('000231', '000228') \n"+
			   "       and b.serv_st not in ('11', '4', '5', '12' , '13')  and a.car_gu  = '0' and a.rent_way ='일반식'  \n"+
			   " 	   and nvl(b.reg_dt, b.serv_dt)  >= to_char(add_months(to_date(a.rent_start_dt), 2), 'yyyymmdd') and nvl(b.reg_dt, b.serv_dt) between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  and replace(a.rent_start_dt, '-', '') <= nvl(b.reg_dt, b.serv_dt) \n"+
			   "       and (a.bus_id = '" + mng_id + "' or  nvl(b.bus_id2, a.mng_id)  = '" + mng_id + "' )  \n"+
			   "	   and nvl(decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)*1.1 ), 0) > 0  \n"+
			   "       group by b.rent_mng_id, b.rent_l_cd,  a.bus_id, nvl(b.bus_id2, a.mng_id)  , nvl(b.reg_dt, b.serv_dt) , b.serv_dt \n"+
			   ") c, cont_n_view a , car_reg cr  \n"+ 
			   "where c.rent_mng_id = a.rent_mng_id and c.rent_l_cd = a.rent_l_cd and a.car_mng_id = cr.car_mng_id(+) \n"+ 
			   "group by  a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, cr.car_nm, a.firm_nm, c.serv_dt, c.gubun \n"+ 		
			   
				//업무용차량 기본식
 			   " 	union all \n"+	   
			"    select /*+ leading(b) merge(a) */  '01' gg, 'Y' use_yn , '',   b.rent_l_cd, '기본식' as rent_way ,  c.car_no, c.car_nm, '',  '' user_id,  nvl(b.reg_dt, b.serv_dt)  serv_dt,   '정비비 ' || b.serv_dt gubun,  \n"+		         
           		 "  	decode( r.cust_id, '" + mng_id + "', ( sum ( case when decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)) > "+ amt1+"  then "+ amt1 + " + ((decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt) ) - "+amt1+")*"+amt1_per+"/100)  else  decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)) end) * 100/ 100 ) , 0 )   amt,  0 per   \n"+  
               		"	       from cont_n_view a, service b , car_reg c ,  \n"+
			"	       ( select a.rent_s_cd, a.car_mng_id, a.cust_id , a.deli_dt, a.ret_dt   \n"+
			"	            from rent_cont a where a.rent_st = '4' and  nvl(a.ret_dt, '99999999')  >=replace('" + f_date1 + "','-','')  and  nvl(a.deli_dt, '99999999')  <=   replace('" + t_date1 + "','-','') ) r \n"+
			"	        where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.client_id in ('000231', '000228') and a.car_mng_id = c.car_mng_id \n"+
			"	        and b.serv_st not in ('11', '4', '5', '7', '12' , '13')  and a.car_st  = '2'  and b.tot_amt > 0  \n"+
			"	        and nvl(b.reg_dt, b.serv_dt) between  replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n"+
			"	        and a.car_mng_id = r.car_mng_id    and r.cust_id = '" + mng_id + "' \n"+
			"	        and replace(nvl(r.ret_dt, '99999999'), '-', '') >  nvl(b.reg_dt, b.serv_dt)   \n"+
			"	        and replace(r.deli_dt, '-', '') <= nvl(b.reg_dt, b.serv_dt)   \n"+
			"	         group by  b.rent_l_cd,  c.car_no, c.car_nm,  nvl(b.reg_dt, b.serv_dt) , b.serv_dt , r.cust_id \n" ;          
			   	
 	    } else    if ( gg.equals("04") ) {  					   
//		    //사고     - 	두바이카 수수료를 면책금처리한건제외 ( car_mng_id :005938, accid_id = '014279' ) 	  - 마감데이타로 cOST_CMP_ACCIDENT 
	 /*	 query = "  select  '04' gg, a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no,cr.car_nm, a.firm_nm, '' user_id, c.serv_dt,   '수리비 ' || c.gubun  gubun, sum(c.bus_amt + c.mng_amt ) amt, c.per from (  \n"+ 			   
		   "         select b.rent_mng_id, b.rent_l_cd,  a.bus_id,  b.bus_id2 as mng_id , b.serv_dt, b.per,  b.gubun,   \n"+ 
		   "		decode( a.bus_id, '" + mng_id + "', sum(b.a_amt *"+ bus_cost_per+"/ 100) , 0 ) bus_amt,  decode( b.bus_id2, '" + mng_id + "',  sum(b.a_amt *"+mng_cost_per+"/ 100) , 0 ) mng_amt    \n"+ 
	   "		 from (		 \n"+ 		 
		   "		    select   b.rent_mng_id, b.rent_l_cd,  nvl(ac.bus_id2,  nvl(a.bus_id4, a.mng_id))  bus_id2 , b.serv_dt,   b.serv_dt gubun ,  \n"+ 
		   "		     case  when  (b.tot_amt * decode(ac.accid_st, '4', 100, '5', 100, '6', 100, '8', 100,  ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) > "+ amt2+" then "+ amt2 + " +  ( (((b.tot_amt * decode(ac.accid_st, '2', 100,  '4', 100,  '5', 100, '6', 100,  '8', 100, ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) )  - "+amt2+"))*"+amt2_per+"/100)    else  ( b.tot_amt * decode(ac.accid_st, '2', 100, '4', 100,  '5', 100, '6', 100, '8', 100 , ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) end a_amt,   \n"+ 
		   "		        decode( ac.accid_st, '2', 100,  '4', 100, '5', 100, '6', 100, '8', 100,  nvl(ac.our_fault_per,100)) per   \n"+ 
		   "		      FROM  accident ac , cont a , \n"+ 
		   "       ( select car_mng_id, accid_id,  rent_mng_id, rent_l_cd, max(nvl(reg_dt, serv_dt)) serv_dt, sum(tot_amt) tot_amt, sum(cust_amt) cust_amt, sum(cls_amt) cls_amt, sum(ext_amt) ext_amt \n"+ 
   		   "          from service where serv_st in ('4', '5', '12')  and nvl(reg_dt, serv_dt) between  replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') group by car_mng_id, accid_id, rent_mng_id, rent_l_cd) b \n"+ 
		   "		      where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  and a.client_id not in ('000228', '000231')  \n"+ 
		   "		           and b.car_mng_id = ac.car_mng_id(+) and b.accid_id = ac.accid_id(+)  and   b.car_mng_id||b.accid_id not in ('005938014279')    \n"+ 
		   "		           and b.serv_dt between   replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')    \n"+ 
		   "		     union all  \n"+ 
		   "		    select nvl(dd.rent_mng_id, b.rent_mng_id ) rent_mng_id, nvl(dd.rent_l_cd, b.rent_l_cd) rent_l_cd ,    \n"+ 
		   "		     nvl(b.bus_id2, nvl(dd.mng_id, a.mng_id ) ) bus_id2 ,  nvl(b.reg_dt, b.serv_dt)  serv_dt,  b.serv_dt gubun ,   \n"+ 
		   "		     case  when  (b.tot_amt * decode(ac.accid_st, '4', 100, '5', 100, '6', 100, '8', 100, ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) > "+ amt2+" then "+ amt2 + " +  ( (((b.tot_amt * decode(ac.accid_st, '2', 100, '4', 100,  '5', 100, '6', 100, '8', 100,   ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) )  - "+amt2+"))*"+amt2_per+"/100)    else  ( b.tot_amt * decode(ac.accid_st, '2', 100, '4', 100,  '5', 100, '6', 100, '8', 100,  ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) end a_amt ,   \n"+ 
		   "		        decode( ac.accid_st,  '2', 100,  '4', 100, '5', 100, '6', 100, '8', 100,  nvl(ac.our_fault_per,100)) per    \n"+ 
		   "		      FROM service b, accident ac , cont a , rent_cont g , cont dd  \n"+ 
	  	   "		       where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  and b.serv_st in ('4', '5', '12')  and ac.rent_s_cd is not null and ac.sub_rent_gu <> '4'   \n"+ 
	 	   "		           and b.car_mng_id = ac.car_mng_id(+) and b.accid_id = ac.accid_id(+)  and   b.car_mng_id||b.accid_id not in ('005938014279')     \n"+ 
		   "		           and nvl(b.reg_dt, b.serv_dt) between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')    \n"+ 
		   "		           and ac.rent_s_cd=g.rent_s_cd(+) and g.sub_l_cd=dd.rent_l_cd(+)   \n"+ 
		   "		   ) b , cont_n_view a    \n"+ 
		   "		   where b.rent_mng_id = a.rent_mng_id and b.rent_l_cd = a.rent_l_cd  \n"+ 
		   "		   and (  a.bus_id = '" + mng_id + "'  or  b.bus_id2 = '" + mng_id + "') 	  \n"+ 
		   "		   and replace(a.rent_start_dt, '-', '') <= b.serv_dt   \n"+ 
		   "		   group by  b.rent_mng_id, b.rent_l_cd, a.bus_id,  b.bus_id2 ,  b.serv_dt, b.per  , b.gubun  \n"+ 
		   "	   ) c, cont_n_view a , car_reg cr  \n"+ 
		   "	   where c.rent_mng_id = a.rent_mng_id and c.rent_l_cd = a.rent_l_cd and a.car_mng_id = cr.car_mng_id(+)  \n"+ 
		   "	   group by  a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, cr.car_nm, a.firm_nm, c.serv_dt , c.gubun ,  c.per   \n"+ 	  */
		   
		   		   
		  // 사고 
		  query = "     select '04' gg, a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no,cr.car_nm, a.firm_nm, '' user_id, b.serv_dt,   '수리비'  gubun,     \n"+ 
 			"		 decode( b.bus_id, '" + mng_id + "', (nvl(b.real_amt, 0)+nvl(b.ave_amt, 0)) *"+ bus_cost_per+"/100 , 0 ) +  decode( b.user_id, '" + mng_id + "', (nvl(b.real_amt, 0)+nvl(b.ave_amt, 0)) *"+mng_cost_per+"/100 , 0 )  amt,  b.fault_per per    \n"+ 
			"		  from (    \n"+ 
			"		  select   b.rent_mng_id, b.rent_l_cd,  b.bus_id, b.user_id, b.car_mng_id, b.serv_dt , b.fault_per,     \n"+ 
			"		    (  case  when  (b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) > "+ amt2+"  then  "+ amt2 + " + ( (((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) )   - "+amt2+"))*"+amt2_per+"/100)       \n"+ 
			"		          else  ( b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) end  ) * 50 /100  real_amt ,    \n"+ 
			"		    (  case  when  (b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) >  "+ amt2+"  then "+ amt2 + " + ( (((b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) )    - "+amt2+"))*"+amt2_per+"/100)          \n"+ 
			"		          else  ( b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) end ) * 50 /100 ave_amt     \n"+ 
			"		      FROM  cost_cmp_accident  b , ( select max(save_dt) save_dt from cost_cmp_accident ) c    \n"+ 
			"		      where  b.save_dt = c.save_dt  and b.accid_id <> '999999' ) b  , cont_n_view a, car_reg cr    \n"+ 
			"		  where b.rent_mng_id = a.rent_mng_id and b.rent_l_cd = a.rent_l_cd and b.car_mng_id = cr.car_mng_id   \n"+ 
			"		   and ( b.bus_id = '" + mng_id + "'  or  b.user_id = '" + mng_id + "') 	  \n"+ 
  		
   			     //사고폐차    
   			" 	union all \n"+	  
   			"     select '04' gg, a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no,cr.car_nm, a.firm_nm, '' user_id, b.serv_dt,   '폐차'  gubun,     \n"+ 
 			"		 decode( b.bus_id, '" + mng_id + "', (nvl(b.real_amt, 0)+nvl(b.ave_amt, 0)) *"+ bus_cost_per+"/100 , 0 ) +  decode( b.user_id, '" + mng_id + "', (nvl(b.real_amt, 0)+nvl(b.ave_amt, 0)) *"+mng_cost_per+"/100 , 0 )  amt,  b.fault_per per    \n"+ 
			"		  from (    \n"+ 
			"		  select   b.rent_mng_id, b.rent_l_cd,  b.bus_id, b.user_id, b.car_mng_id, b.serv_dt , b.fault_per,     \n"+ 
			"		    (  case  when  (b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) > "+ amt2+"  then  "+ amt2 + " + ( (((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) )   - "+amt2+"))*"+amt2_per+"/100)       \n"+ 
			"		          else  ( b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) end  ) * 50 /100  real_amt ,    \n"+ 
			"		    (  case  when  (b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) >  "+ amt2+"  then "+ amt2 + " + ( (((b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) )    - "+amt2+"))*"+amt2_per+"/100)          \n"+ 
			"		          else  ( b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) end ) * 50 /100 ave_amt     \n"+ 
			"		      FROM  cost_cmp_accident  b , ( select max(save_dt) save_dt from cost_cmp_accident ) c    \n"+ 
			"		      where  b.save_dt = c.save_dt  and b.accid_id =  '999999' ) b  , cont_n_view a, car_reg cr    \n"+ 
			"		  where b.rent_mng_id = a.rent_mng_id and b.rent_l_cd = a.rent_l_cd and b.car_mng_id = cr.car_mng_id   \n"+ 
			"		   and ( b.bus_id = '" + mng_id + "'  or  b.user_id = '" + mng_id + "') 	  \n";
			/* 
			   " select  '04' gg, a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, cr.car_nm, a.firm_nm, '' user_id, c.serv_dt, '폐차' gubun, sum(c.bus_amt + c.mng_amt ) amt, 100 per from (    \n"+  				 
			   "	   select  c.rent_mng_id, c.rent_l_cd, c.bus_id , c.mng_id,  c.rent_way, a.serv_dt ,  \n"+ 
			   "	    decode( c.bus_id,  '" + mng_id + "', ( sum( case  when  (a.sh_car_amt - a.sale_amt -  a.amor_pay_amt ) > "+ amt2+" then "+ amt2+" + ( (a.sh_car_amt - a.sale_amt - a.amor_pay_amt  -  "+ amt2+" )* "+amt2_per+"/100)  else  ( a.sh_car_amt - a.sale_amt - a.amor_pay_amt ) end ) * "+bus_cost_per+"/ 100 ) , 0 ) bus_amt,  \n"+ 
			   "		decode( c.mng_id,  '" + mng_id + "', ( sum( case  when  (a.sh_car_amt - a.sale_amt - a.amor_pay_amt) > "+ amt2+" then "+ amt2+" + ( (a.sh_car_amt - a.sale_amt - a.amor_pay_amt -  "+ amt2+" )* "+amt2_per+"/100)  else  ( a.sh_car_amt - a.sale_amt - a.amor_pay_amt ) end ) * "+mng_cost_per+"/ 100 ) , 0 ) mng_amt  \n"+ 
			   "	   from (  \n"+ 
			   "	        select v.rent_mng_id , v.rent_l_cd, fm.sh_car_amt , fm.sale_amt , nvl(ot.amor_pay_amt,0) amor_pay_amt,  m.car_mng_id , fm.assch_date serv_dt  \n"+ 
			   "	          from  fassetmove fm, fassetma m , cont_n_view  v , (select car_mng_id, max(rent_dt) rent_dt from cont_n_view group by car_mng_id ) c ,      \n"+ 
			   "		      ( select car_mng_id,  sum(amor_pay_amt)  amor_pay_amt from ot_accid group by car_mng_id ) ot   \n"+ 
			   "	          where fm.assch_date between  replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') and   fm.assch_type = '3' and fm.asset_code = m.asset_code  \n"+ 
			   "	            and ( fm.assch_rmk = '폐차' or fm.asset_code = 'A003391') and m.car_mng_id =  v.car_mng_id and v.car_mng_id = c.car_mng_id and v.rent_dt = c.rent_dt  and m.car_mng_id = ot.car_mng_id(+)   ) a, cont_n_view c ,  \n"+ 
			   "                  (select rent_mng_id, max(rent_l_cd) rent_l_cd from cont where car_st <> '2' group by rent_mng_id) c1    \n"+ 
			   "	    where a.rent_mng_id =c.rent_mng_id and a.car_mng_id = c.car_mng_id and c.car_st <> '2'   \n"+ 
			   "            and c.rent_mng_id = c1.rent_mng_id  and c.rent_l_cd = c1.rent_l_cd   \n"+ 
			   "	     and (c.bus_id = '" + mng_id + "' or c.mng_id = '" + mng_id + "' )  	 \n"+ 
			   "	    group by  c.rent_mng_id, c.rent_l_cd,  c.bus_id , c.mng_id , c.rent_way , a.serv_dt  \n"+ 
			   "	  ) c, cont_n_view a , car_reg cr    \n"+ 
			   "	  where c.rent_mng_id = a.rent_mng_id and c.rent_l_cd = a.rent_l_cd   and a.car_mng_id = cr.car_mng_id(+)   \n"+ 
			   "	 group by  a.use_yn,  a.car_st, a.rent_l_cd, a.rent_way, cr.car_no, cr.car_nm, a.firm_nm , c.serv_dt     \n"+ 			   
			*/   
			   	//업무용차량 기본식
 		//	   " 	union all \n"+	   
		//	"    select /*+ leading(b) merge(a) */  '04' gg, 'Y' use_yn , '',   b.rent_l_cd, '기본식' as rent_way ,  c.car_no, c.car_nm, '',  '' user_id,  nvl(b.reg_dt, b.serv_dt)  serv_dt,   '수리비 ' || b.serv_dt gubun,  \n"+	
		//	"   sum(case  when  (b.tot_amt * decode(ac.accid_st, '2',100, '4', 100, '5', 100, '6', 100,  '8', 100, ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) > "+ amt2+" then "+ amt2 + " + ( (((b.tot_amt * decode(ac.accid_st, '2', 100, '4', 100,  '5', 100, '6', 100, '8', 100,  ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) - "+amt2+"))*"+amt2_per+"/100)   else  ( b.tot_amt * decode(ac.accid_st, '2', 100,'4', 100,  '5', 100, '6', 100, '8', 100, ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) end )  a_amt ,\n"+ 	 
		//	"  decode( ac.accid_st,  '2', 100,  '4', 100, '5', 100, '6', 100, '8', 100, nvl(ac.our_fault_per,100)) per  \n"+ 
                 //		"	       from cont_n_view a, service b , car_reg c ,  accident ac, \n"+
		//	"	       ( select a.rent_s_cd, a.car_mng_id, a.cust_id , a.deli_dt, a.ret_dt   \n"+
		//	"	            from rent_cont a where a.rent_st = '4' and  nvl(a.ret_dt, '99999999')  >=replace('" + f_date1 + "','-','')  and  nvl(a.deli_dt, '99999999')  <=   replace('" + t_date1 + "','-','') ) r \n"+
		//	"	        where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.client_id in ('000231', '000228') and a.car_mng_id = c.car_mng_id \n"+
		//	"	        and b.serv_st  in ( '4', '5' )  and a.car_st  = '2'  and  b.accid_id = ac.accid_id and b.car_mng_id = ac.car_mng_id \n"+
		//	"	        and nvl(b.reg_dt, b.serv_dt) between  replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n"+
		//	"	        and a.car_mng_id = r.car_mng_id    and r.cust_id = '" + mng_id + "' \n"+
		//	"	        and replace(r.deli_dt, '-', '') <= nvl(b.reg_dt, b.serv_dt)   \n"+
		//	"	         group by  b.rent_l_cd,  c.car_no, c.car_nm,  nvl(b.reg_dt, b.serv_dt) , b.serv_dt , r.cust_id, decode( ac.accid_st,  '2', 100,  '4', 100, '5', 100, '6', 100, '8', 100, nvl(ac.our_fault_per,100))  \n" ;          
       		 } else    if ( gg.equals("15") ) {  
       		 //보유차관련 정비 			  
       		    query = "  select/*+ leading(b) merge(a) */  '15' gg, 'Y' use_yn , '',   b.rent_l_cd, '기본식' as rent_way ,  cr.car_no, cr.car_nm,  a.firm_nm,  '' user_id,  nvl(b.reg_dt, b.serv_dt)  serv_dt,   '정비비 ' || b.serv_dt gubun,   \n"+
				  " case when decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)) > 1000000  then 1000000 + ((decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt) ) - 1000000)*10/100)  else  decode(nvl(b.r_j_amt,0), 0, b.tot_amt, (b.r_labor+b.r_j_amt)) end amt  ,  0 per \n"+ 
				 " from cont_n_view a, service b , COST_CMP_PRE_BASE c, car_reg cr   \n"+ 
				 "  where c.save_dt = to_char(sysdate,'YYYYMMdd') and c.br_id = '"+ mng_br_id + "'  \n"+ 
				   "   and c.rent_mng_id = a.rent_mng_id and  c.rent_l_cd = a.rent_l_cd     and c.rent_mng_id = b.rent_mng_id and c.rent_l_cd = b.rent_l_cd and b.car_mng_id = cr.car_mng_id  \n"+ 
				   "   and b.serv_st not in ('11', '4', '5', '7')  and a.car_st  = '2'  and b.tot_amt > 0  and b.rep_cont not like '%월렌트%' and c.gubun = 'J'  \n"+ 
				   "   and nvl(b.reg_dt, b.serv_dt) between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  \n"+				   
				 "   union all  \n"+	
				"	 select/*+ leading(b) merge(a) */  '15' gg, 'Y' use_yn , '',   b.rent_l_cd, '기본식' as rent_way ,   \n"+	
				"	 cr.car_no, cr.car_nm,  a.firm_nm,  '' user_id,  nvl(b.reg_dt, b.serv_dt)  serv_dt,  '수리비 '  || b.serv_dt gubun,   \n"+	
				"	 case  when  (b.tot_amt * decode(ac.accid_st,  '2',100,  '4', 100, '5', 100, '6', 100,  '8', 100, ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) > 1000000  then 1000000 + ( (((b.tot_amt * decode(ac.accid_st,  '2',100, '4', 100,  '5', 100, '6', 100,  '8', 100, ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) )  - 1000000))*10/100)   else  ( b.tot_amt * decode(ac.accid_st, '4', 100,  '5', 100, '6', 100, '8', 100, ac.our_fault_per)/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) end amt ,  ac.our_fault_per  per \n"+	
				"	 from cont_n_view a, service b , COST_CMP_PRE_BASE c , accident ac , car_reg cr   \n"+	
				"	 where c.save_dt = to_char(sysdate,'YYYYMMdd') and c.br_id = '"+ mng_br_id + "'  \n"+ 
				"	      and c.rent_mng_id = a.rent_mng_id and  c.rent_l_cd = a.rent_l_cd  and  b.car_mng_id = cr.car_mng_id \n"+	
				"	      and c.rent_mng_id = b.rent_mng_id and c.rent_l_cd = b.rent_l_cd and b.car_mng_id = ac.car_mng_id(+) and b.accid_id = ac.accid_id(+)  and c.gubun = 'A'  \n"+	
				"	      and b.serv_st  in ('4', '5') and a.car_st  = '2'  and b.tot_amt <> 0  \n"+	
				"	      and nvl(b.reg_dt, b.serv_dt) between  replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','')  \n";
				
	          } 
	  	
	  	query += "  order by  1, 5, 10 ";
//	  	query += "  order by  gg, rent_way, serv_dt ";
	  	

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
			System.out.println("[CostDatabase:getDlyCostStatMList3]"+e);
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
	*	변수수정
	*/
	public int updateVar(String year, String tm, String gubun, String cs_dt, String ce_dt, int amt1, int amt2, int amt3, int amt4, int rent_way_1_per, int rent_way_2_per, int max_day, int second_per, int maker_dc_a, int commi_per, int cam_per, int cc1, int cc2, int cc3, int cc4, int da_amt1, int da_amt2, int da_amt3, int amt1_per, int amt2_per, int bus_cost_per, int mng_cost_per, int car_cnt, int sale_cnt, int base_cnt, int a_cam_per )
	{
			
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "UPDATE cost_campaign "+
			" SET cs_dt=?, ce_dt=? "+
			"	 ,amt1=?, amt2=?, amt3=?, amt4=? "+
			"    ,rent_way_1_per=?, rent_way_2_per=? "+
			"	 ,max_day=?, second_per=?, maker_dc_a = ?, commi_per=? , cam_per=? ,"+
			"	 cc1=?, cc2=?, cc3 = ?, cc4=? ,"+
			"	 da_amt1=?, da_amt2=?, da_amt3=?, amt1_per=?, amt2_per=?, "+
			"	 bus_cost_per=?,  mng_cost_per=? , car_cnt = ?, sale_cnt = ?, base_cnt = ? ,  a_cam_per = ?  "+
			" WHERE year=? and tm=? and gubun = ? ";

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cs_dt);
			pstmt.setString(2, ce_dt);
			pstmt.setInt(3, amt1);
			pstmt.setInt(4, amt2);
			pstmt.setInt(5, amt3);
			pstmt.setInt(6, amt4);
			pstmt.setInt(7, rent_way_1_per);
			pstmt.setInt(8, rent_way_2_per);
			
			pstmt.setInt(9, max_day);
			pstmt.setInt(10, second_per);
			pstmt.setInt(11, maker_dc_a);
			pstmt.setInt(12, commi_per);
			pstmt.setInt(13, cam_per);
		
			pstmt.setInt(14, cc1);
			pstmt.setInt(15, cc2);
			pstmt.setInt(16, cc3);
			pstmt.setInt(17, cc4);

			pstmt.setInt(18, da_amt1);
			pstmt.setInt(19, da_amt2);
			pstmt.setInt(20, da_amt3);

			pstmt.setInt(21, amt1_per);
			pstmt.setInt(22, amt2_per);
		
			pstmt.setInt(23, bus_cost_per);
			pstmt.setInt(24, mng_cost_per);
			pstmt.setInt(25, car_cnt);
			pstmt.setInt(26, sale_cnt);
			pstmt.setInt(27, base_cnt);	
			pstmt.setInt(28, a_cam_per);	
					
			pstmt.setString(29, year);
			pstmt.setString(30, tm);
			pstmt.setString(31, gubun);

			result = pstmt.executeUpdate();

			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[CostDatabase:updateVar]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}
	
		/**
	*	변수수정
	*/
	public int insertVar(String year, String tm, String gubun, String cs_dt, String ce_dt, int amt1, int amt2, int amt3, int amt4, int rent_way_1_per, int rent_way_2_per, int max_day, int second_per, int maker_dc_a, int commi_per, int cam_per, int cc1, int cc2, int cc3, int cc4, int da_amt1, int da_amt2, int da_amt3, int amt1_per, int amt2_per, int bus_cost_per, int mng_cost_per, int car_cnt, int sale_cnt, int base_cnt , int a_cam_per)
	{
			
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
				
		String query = "insert into cost_campaign ( year,  tm,  gubun,  "+  //3
			"                 cs_dt, ce_dt, amt1, amt2, amt3, amt4, "+  //6
			"                 rent_way_1_per, rent_way_2_per, max_day, second_per, maker_dc_a, commi_per , cam_per ,"+ //7
			"	         cc1, cc2, cc3 , cc4 , da_amt1, da_amt2, da_amt3, amt1_per, amt2_per, "+ //9
			"	         bus_cost_per,  mng_cost_per , car_cnt, sale_cnt, base_cnt , rs_dt, re_dt, a_cam_per) "+   //8
			"                 values (   ?, ?, ? ,  "+   //3
			"                ?, ?, ?, ?, ?, ?,  "+   //6
			"                ?, ?, ?, ?, ?, ?, ?,  "+    //7
			"                ?, ?, ?, ?, ?, ?, ?, ?, ? ,   "+  //9
			"                ?, ?, ?, ?, ?,?, ?, ? )  ";  //8				
	
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, year);
			pstmt.setString(2, tm);
			pstmt.setString(3, gubun);
			
			pstmt.setString(4, cs_dt);
			pstmt.setString(5, ce_dt);
			pstmt.setInt(6, amt1);
			pstmt.setInt(7, amt2);
			pstmt.setInt(8, amt3);
			pstmt.setInt(9, amt4);
			
			pstmt.setInt(10, rent_way_1_per);
			pstmt.setInt(11, rent_way_2_per);
			pstmt.setInt(12, max_day);
			pstmt.setInt(13, second_per);
			pstmt.setInt(14, maker_dc_a);
			pstmt.setInt(15, commi_per);
			pstmt.setInt(16, cam_per);
		
			pstmt.setInt(17, cc1);
			pstmt.setInt(18, cc2);
			pstmt.setInt(19, cc3);
			pstmt.setInt(20, cc4);
			pstmt.setInt(21, da_amt1);
			pstmt.setInt(22, da_amt2);
			pstmt.setInt(23, da_amt3);
			pstmt.setInt(24, amt1_per);
			pstmt.setInt(25, amt2_per);
		
			pstmt.setInt(26, bus_cost_per);
			pstmt.setInt(27, mng_cost_per);
			pstmt.setInt(28, car_cnt);
			pstmt.setInt(29, sale_cnt);
			pstmt.setInt(30, base_cnt);	
			pstmt.setString(31, cs_dt);
			pstmt.setString(32, ce_dt);		
			pstmt.setInt(33, a_cam_per);		

			result = pstmt.executeUpdate();

			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[CostDatabase:insertVar]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}
			
	  /**
     * 영업효율내역 조회
     */    
	public Vector getSaleCostCampaign(String ns_dt, String ne_dt, String bus_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();


		String query = " select a.bus_id, a.rent_start_dt, u.user_nm,  a.firm_nm, cr.car_nm, cr.car_no, decode(a.car_gu, '0', '재리스', '1' ,'신차', '2', '중고차' ) car_gu_nm, fe.bus_agnt_id, u2.user_nm as bus_agnt_nm, \n"+
					   " decode(a.fee_rent_st, '1', decode(a.rent_st, '1', '신규', '3', '대차', '4', '증차' ), '연장') rent_st_nm,  \n"+
					   " decode(a.car_st, '1', '렌트', '2' ,'보유차', '3', '리스' ) car_st_nm, a.rent_way, a.con_mon,  \n"+
					   " decode(c.spr_kd, '0', '일반', '1', '우량', '2', '초우량', '3', '신설') spr_kd_nm, fe.bc_s_g+nvl(fe.driver_add_amt,0) AS bc_s_g, f.fee_s_amt, \n"+
					   " decode(a.fee_rent_st, '1', decode(cm.emp_id, null, '무', '유' ), '무') commi2_nm,  \n"+
					   " case when nvl(fe.bc_s_a, 0) = 0 then 0 else trunc( nvl(f.fee_s_amt,0) / decode(fe.bc_s_a, 0, 1, null, 1, fe.bc_s_a) * 100000 ) end af_amt, cd.trf_amt, nvl(fe.bc_b_a,0)  amt1, nvl(fe.bc_b_b,0) amt2, \n"+
					   " case when nvl(fe.bc_s_c, 0) = 0 then 0 else  trunc( ( (nvl(fe.bc_s_c,0) * ( (nvl(fe.bc_s_d,0)/100) - ( nvl(fe.bc_s_e,0)/100 ) ))  - ( nvl(fe.bc_s_g,0)+nvl(fe.driver_add_amt,0) - nvl(f.fee_s_amt,0) ) )/ decode(fe.bc_s_a, 0, 1, null, 1, fe.bc_s_a) * 100000 + nvl(fe.bc_s_f,0) ) end   amt3,   \n"+
					   " nvl(fe.bc_b_d,0) amt4, case when nvl(f.opt_yn, 'N') = 'Y' then 0 else  trunc( (nvl(fe.bc_b_e1,0)/100 - 1 ) * nvl(fe.bc_b_e2,0) ) end amt5,  \n"+
					   " trunc( (nvl(cd.trf_amt,0) * nvl(fe.bc_s_i, 1.8375) ) /100) amt6, nvl(fe.bc_b_g,0) amt7 ,\n"+
					   " nvl(fe.bc_b_a,0)  +  nvl(fe.bc_b_b,0) + ( case when nvl(fe.bc_s_c, 0) = 0 then 0 else  trunc( ( (nvl(fe.bc_s_c,0) * ( (nvl(fe.bc_s_d,0)/100) - ( nvl(fe.bc_s_e,0)/100 ) ))  - ( nvl(fe.bc_s_g,0)+nvl(fe.driver_add_amt,0) - nvl(f.fee_s_amt,0) ) )/ decode(fe.bc_s_a, 0, 1, null, 1, fe.bc_s_a) * 100000 + nvl(fe.bc_s_f,0) ) end ) + nvl(fe.bc_b_d,0) + ( (nvl(fe.bc_b_e1,0)/100 - 1 ) * nvl(fe.bc_b_e2,0)) + ( trunc( (nvl(cd.trf_amt,0) * nvl(fe.bc_s_i, 1.8375) ) /100)) + nvl(fe.bc_b_g,0)  amt8,   \n"+ 
					   " 0 amt9, nvl(fe.bc_b_k,0) amt10, s.tot_amt amt11 , trunc(nvl(s.tot_amt,0)*0.5) amt12 ,  \n"+
					   " nvl(ce.sd_cs_amt, 0) + nvl(ce.sd_cv_amt, 0) - nvl(fe.bc_b_n,0)  amt13 , nvl(cons.tot_amt,0) - nvl(cons.oil_amt, 0) + nvl(p1.cost_amt,0) amt14 , nvl(t.tint_amt,0) + nvl(q1.tint_amt,0) amt15, nvl(t.cleaner_amt,0) + nvl(r1.cleaner_amt,0) amt16,   \n"+
					   " ce.extra_amt amt17, nvl(cons.oil_amt, 0) + nvl(t1.oil_amt,0) amt18, nvl(fe.bc_b_u,0) amt19, \n"+ 
					   "  nvl(fe.bc_b_k,0) +  nvl(s.tot_amt,0) + ( nvl(ce.sd_cs_amt, 0) + nvl(ce.sd_cv_amt, 0) - nvl(fe.bc_b_n,0))  +  (nvl(cons.tot_amt,0) - nvl(cons.oil_amt,0) + nvl(p1.cost_amt,0) ) +  nvl(t.tint_amt,0) + nvl(q1.tint_amt,0) + nvl(t.cleaner_amt,0)+ nvl(r1.cleaner_amt,0) + nvl(ce.extra_amt,0) +  nvl(cons.oil_amt,0) + nvl(t1.oil_amt,0) + nvl(fe.bc_b_u,0) + nvl(vins.spe_amt,0) amt20, \n"+ 
					   "  nvl(fe.bc_b_k,0) +  trunc(nvl(s.tot_amt,0)*0.5) + ( nvl(ce.sd_cs_amt, 0)+ nvl(ce.sd_cv_amt, 0) - nvl(fe.bc_b_n,0))  +  (nvl(cons.tot_amt,0) - nvl(cons.oil_amt,0) + nvl(p1.cost_amt,0) ) +  nvl(t.tint_amt,0) + nvl(q1.tint_amt,0) + nvl(t.cleaner_amt,0)+ nvl(r1.cleaner_amt,0) + nvl(ce.extra_amt,0) + nvl(cons.oil_amt,0) + nvl(t1.oil_amt,0) + nvl(fe.bc_b_u,0) + nvl(vins.spe_amt,0) amt21, \n"+ 
					   " trunc(x.amt22) amt22, trunc(x1.amt23) amt23, trunc( ( nvl(fe.bc_s_c,0) * nvl(fe.bc_s_e,0) / decode(fe.bc_s_a, 0, 1, null, 1, fe.bc_s_a) * 100000 )) amt24, \n"+
					   " fe.cls_n_amt amt25, aa.amt26, nvl(fe.bc_b_ac,0) amt29 , ( trunc(nvl(x1.amt23,0)) + trunc( (nvl(fe.bc_s_c,0) * nvl(fe.bc_s_e,0) / decode(fe.bc_s_a, 0, 1, null, 1, fe.bc_s_a) * 100000))  - nvl(aa.amt26,0) + nvl(fe.bc_b_ac,0) ) amt30,  \n"+
					   " vins.spe_amt as amt33 \n"+
					   " from cont_n_view a, cont c, users u, users u2, car_etc ce, fee_etc fe , fee f , car_reg cr, (select rent_mng_id, rent_l_cd, emp_id from commi where AGNT_ST = '2' ) cm, ( select b.rent_mng_id, b.rent_l_cd, sum(b.trf_amt) trf_amt from  \n"+
					   "	 ( select rent_mng_id, rent_l_cd, sum(nvl(trf_amt1,0)) trf_amt from car_pur where  trf_st1 in ('2', '3') group by rent_mng_id, rent_l_cd  union all  \n"+
					   "	   select rent_mng_id, rent_l_cd, sum(nvl(trf_amt2,0)) trf_amt from car_pur where  trf_st2 in ('2', '3') group by rent_mng_id, rent_l_cd  union all  \n"+
					   "	   select rent_mng_id, rent_l_cd, sum(nvl(trf_amt3,0)) trf_amt  from car_pur where  trf_st3 in ('2', '3') group by rent_mng_id, rent_l_cd union all  \n"+
					   "	   select rent_mng_id, rent_l_cd, sum(nvl(trf_amt4,0)) trf_amt from car_pur where  trf_st4 in ('2', '3') group by rent_mng_id, rent_l_cd  \n"+
					   "	                             ) b group by b.rent_mng_id, b.rent_l_cd ) cd,  \n"+
					   " (select b.rent_mng_id, b.rent_l_cd, b.serv_dt, a.bus_id, sum(b.tot_amt) tot_amt from cont_n_view a, service b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  and b.serv_st = '2'and  a.rent_way ='기본식' and a.car_gu = '0'  \n"+
   					   "  and a.rent_start_dt between '" + ns_dt + "' and '" + ne_dt +"' and b.serv_dt between replace(a.rent_start_dt, '-', '') and replace(a.rent_end_dt, '-', '') group by b.rent_mng_id, b.rent_l_cd, b.serv_dt, a.bus_id) s , \n"+
   					   " (select a.rent_mng_id, a.rent_l_cd, a.bus_id, b.tot_amt,  b.oil_amt  from cont_n_view a, consignment b, doc_settle d where a.rent_mng_id= b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and  b.cost_st = '1' and b.cons_cau in ( '1', '3', '8' ) and d.doc_st = '2' and d.doc_id = b.cons_no and a.rent_start_dt between '" + ns_dt + "' and '" + ne_dt +"'  ) cons , \n"+
 					   " (select a.rent_mng_id, a.rent_l_cd, a.bus_id, b.tint_amt , b.cleaner_amt  from cont_n_view a, tint b where a.rent_mng_id= b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and b.a_amt > 0 and a.rent_start_dt between '" + ns_dt + "' and '" + ne_dt +"'  ) t,  \n"+ 					  
 					   " (select a.rent_mng_id, a.rent_l_cd, a.bus_id, trunc( nvl(c.cls_n_amt,0) - ( b.fee_s_amt *  nvl(c.bc_s_b, 0) * 0.03 ) ) amt26 from cont_n_view a, fee b, fee_etc c where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  and a.fee_rent_st = b.rent_st and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd  and a.fee_rent_st = c.rent_st and a.car_st <> '2' and  a.rent_start_dt between  '" + ns_dt + "' and '" + ne_dt +"'  ) aa, \n"+ 	
   					   " (select  a.rent_mng_id, a.rent_l_cd, b.bus_id, sum(a.s_dc_amt) amt22 from (  \n"+
					   "       select rent_mng_id, rent_l_cd, s_dc1_amt/1.1 s_dc_amt from car_etc where s_dc1_amt > 0 and s_dc1_re in ('판매자정상조건','추가탁송료D/C') union all  \n"+
					   "       select rent_mng_id, rent_l_cd, s_dc2_amt/1.1 s_dc_amt from car_etc where s_dc2_amt > 0 and s_dc2_re in ('판매자정상조건','추가탁송료D/C') union all  \n"+
					   "       select rent_mng_id, rent_l_cd, s_dc3_amt/1.1 s_dc_amt from car_etc where s_dc3_amt > 0 and s_dc3_re in ('판매자정상조건','추가탁송료D/C') ) a, cont_n_view b  \n"+
					   "   where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and b.rent_start_dt between '2008-09-01' and '2008-11-30'  and nvl(b.use_yn , 'Y') = 'Y' group by   a.rent_mng_id, a.rent_l_cd, b.bus_id ) x,  \n"+
					   "(select  a.rent_mng_id, a.rent_l_cd, b.bus_id, sum(case when a.s_dc_amt > 1000000 then 1000000 else a.s_dc_amt  end ) amt23 from ( \n"+
                       "   select  b.rent_mng_id, b.rent_l_cd,  sum(b.s_dc_amt) s_dc_amt  from  ( \n"+
                       "      select rent_mng_id, rent_l_cd, s_dc1_amt/1.1 s_dc_amt from car_etc where s_dc1_amt > 0 and s_dc1_re not in ('판매자정상조건','추가탁송료D/C')  union all \n"+
                       "      select rent_mng_id, rent_l_cd, s_dc2_amt/1.1 s_dc_amt from car_etc where s_dc2_amt > 0 and s_dc2_re not in ('판매자정상조건','추가탁송료D/C')   union all \n"+
                       "      select rent_mng_id, rent_l_cd, s_dc3_amt/1.1 s_dc_amt from car_etc where s_dc3_amt > 0 and s_dc3_re not in ('판매자정상조건','추가탁송료D/C') ) b group by rent_mng_id, rent_l_cd ) a, cont_n_view b \n"+
                       "    where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and b.rent_start_dt between '" + ns_dt + "' and '" + ne_dt +"' and nvl(b.use_yn , 'Y') = 'Y' group by  a.rent_mng_id, a.rent_l_cd, b.bus_id )  x1,   \n"+
                       "(select a.cost_id, a.rent_mng_id, a.rent_l_cd, sum(nvl(a.cost_amt,0)) cost_amt from cost_neom a, cont_n_view b where a.gubun = '1' and a.c_st = '1' and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and b.rent_start_dt between '" + ns_dt + "' and '" + ne_dt +"' group by a.cost_id, a.rent_mng_id, a.rent_l_cd ) p1,  \n"+
                       "(select a.cost_id, a.rent_mng_id, a.rent_l_cd, sum(nvl(a.cost_amt,0)) oil_amt  from cost_neom a, cont_n_view b where a.gubun = '5' and a.c_st = '1' and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and b.rent_start_dt between '" + ns_dt + "' and '" + ne_dt +"' group by a.cost_id, a.rent_mng_id, a.rent_l_cd ) t1,  \n"+    
                       "(select a.cost_id, a.rent_mng_id, a.rent_l_cd, sum(nvl(a.cost_amt,0)) tint_amt from cost_neom a, cont_n_view b where a.gubun = '4' and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and b.rent_start_dt between '" + ns_dt + "' and '" + ne_dt +"' group by a.cost_id, a.rent_mng_id, a.rent_l_cd ) q1,  \n"+    
                       "(select a.cost_id, a.rent_mng_id, a.rent_l_cd, sum(nvl(a.cost_amt,0)) cleaner_amt from cost_neom a, cont_n_view b where  a.gubun = '6' and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and b.rent_start_dt between '" + ns_dt + "' and '" + ne_dt +"' group by a.cost_id, a.rent_mng_id, a.rent_l_cd ) r1,  \n"+
                       " (select "+
                       "	    a.rent_mng_id, a.rent_l_cd, a.rent_st, a.rent_start_dt, a.con_mon-nvl(d.cls_n_mon,0) con_mon, c.ins_start_dt, c.ins_exp_dt, c.vins_spe_amt, e.ch_dt, e.ch_amt, "+
                       "  	    to_date(c.ins_exp_dt,'YYYYMMDD')-to_date(nvl(e.ch_dt,c.ins_start_dt),'YYYYMMDD') j_day, "+
                       "  		trunc(nvl(e.ch_amt,c.vins_spe_amt)/(to_date(c.ins_exp_dt,'YYYYMMDD')-to_date(nvl(e.ch_dt,c.ins_start_dt),'YYYYMMDD'))*365/12*(a.con_mon-nvl(d.cls_n_mon,0)),0) spe_amt "+
                       "  	 	from fee a, cont_n_view b, insur c, fee_etc d, (select * from ins_change where ch_item='6' and ch_amt>0) e "+
                       "  	where "+
                       "  	 	a.rent_st='1' and a.rent_start_dt >= '20080101' "+
                       "  	 	and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "+
                       "  	 	and b.car_st not in ('2','5') and b.car_no like '%허%' "+
                       "  	 	and b.car_mng_id=c.car_mng_id "+
                       "  	 	and c.vins_spe_amt>0  "+
                       "  		and a.rent_start_dt between c.ins_start_dt and c.ins_exp_dt "+
                       "  		and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) and a.rent_st=d.rent_st(+) "+
                       "  		and c.car_mng_id=e.car_mng_id(+) and c.ins_st=e.ins_st(+) "+
					   " ) vins "+
                       " where a.rent_mng_id =  c.rent_mng_id and a.rent_l_cd = c.rent_l_cd  and a.car_mng_id = cr.car_mng_id(+) \n"+
					   "	 and  a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.fee_rent_st = f.rent_st  \n"+
					   "	 and  a.rent_mng_id = fe.rent_mng_id(+) and a.rent_l_cd = fe.rent_l_cd(+) and a.fee_rent_st = fe.rent_st(+)  \n"+
					   "	 and  a.rent_mng_id = cm.rent_mng_id(+) and a.rent_l_cd = cm.rent_l_cd(+) \n"+
					   "	 and  a.rent_mng_id = cd.rent_mng_id(+) and a.rent_l_cd = cd.rent_l_cd(+) \n"+
					   "	 and  a.rent_mng_id = s.rent_mng_id(+) and a.rent_l_cd = s.rent_l_cd(+) \n"+
					   "	 and  a.rent_mng_id = ce.rent_mng_id(+) and a.rent_l_cd = ce.rent_l_cd(+) \n"+
					   "	 and  a.rent_mng_id = cons.rent_mng_id(+) and a.rent_l_cd = cons.rent_l_cd(+) \n"+
					   "	 and  a.rent_mng_id = t.rent_mng_id(+) and a.rent_l_cd = t.rent_l_cd(+) \n"+
					   "	 and  a.rent_mng_id = aa.rent_mng_id(+) and a.rent_l_cd = aa.rent_l_cd(+) \n"+
					   "	 and  a.rent_mng_id = x.rent_mng_id(+) and a.rent_l_cd = x.rent_l_cd(+) \n"+
					   "	 and  a.rent_mng_id = x1.rent_mng_id(+) and a.rent_l_cd = x1.rent_l_cd(+) \n"+
					   "	 and  a.rent_mng_id = p1.rent_mng_id(+) and a.rent_l_cd = p1.rent_l_cd(+) \n"+
					   "	 and  a.rent_mng_id = t1.rent_mng_id(+) and a.rent_l_cd = t1.rent_l_cd(+) \n"+
					   "	 and  a.rent_mng_id = q1.rent_mng_id(+) and a.rent_l_cd = q1.rent_l_cd(+) \n"+
					   "	 and  a.rent_mng_id = r1.rent_mng_id(+) and a.rent_l_cd = r1.rent_l_cd(+) \n"+
					   "	 and  a.rent_mng_id = vins.rent_mng_id(+) and a.rent_l_cd = vins.rent_l_cd(+) \n"+
					   "     and  a.bus_id = u.user_id and fe.bus_agnt_id = u2.user_id(+)\n"+
					   " 	 and a.rent_start_dt  between '" + ns_dt + "' and '" + ne_dt +"' and a.use_yn = 'Y'\n";
				 

		if(!bus_id.equals("") )		query += " and a.bus_id = '"+bus_id+"'";

		query += " order by 1 , 2 ";

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
			System.out.println("[CostDatabase:getCostManCampaign(String save_dt, String gubun, String loan_st, String s_dt, String e_dt)]"+e);
			System.out.println("[CostDatabase]"+query);
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
	 * 결과 :마감테이블 조회 - 영업팀
	*/
	public Vector getCostSaleCampaign_20081208(String gubun, String loan_st, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();


		
		String query = " select b.dept_id, decode(b.user_pos,'대표이사',1,'팀장', 2, '차장', 3, '과장', 4 , '대리', 5, 9) pos_sort, "+
					   "        b.user_nm, b.user_id, a.bus_id, "+
					   "        count(decode(a.cost_st,'1',decode(a.rent_way,'1',a.rent_l_cd))) RENT_WAY_1_CNT, "+
					   "        count(decode(a.cost_st,'1',decode(a.rent_way,'1','',a.rent_l_cd))) RENT_WAY_2_CNT, "+
					   "        sum(a.amt1 ) amt1 ,"+
					   "        sum(a.amt2 ) amt2 ,"+
					   "        sum(a.amt3 ) amt3 ,"+
					   "        sum(a.amt4 ) amt4 ,"+
					   "        sum(a.amt5 ) amt5 ,"+
					   "        sum(a.amt6 ) amt6 ,"+
					   "        sum(a.amt7 ) amt7 ,"+
					   "        sum(a.amt8 ) amt8 ,"+
					   "        sum(a.amt9 ) amt9 ,"+
					   "        sum(a.amt10) amt10,"+
					   "        sum(a.amt11) amt11,"+
					   "        sum(a.amt12) amt12,"+
					   "        sum(a.amt13) amt13,"+
					   "        sum(a.amt14) amt14,"+
					   "        sum(a.amt15) amt15,"+
					   "        sum(a.amt16) amt16,"+
					   "        sum(a.amt17) amt17,"+
					   "        sum(a.amt18) amt18,"+
					   "        sum(a.amt19) amt19,"+
					   "        sum(a.amt20) amt20,"+
					   "        sum(a.amt21) amt21,"+
					   "        sum(a.amt22) amt22,"+
					   "        sum(a.amt23) amt23,"+
					   "        sum(a.amt24) amt24,"+
					   "        sum(a.amt25) amt25,"+
					   "        sum(a.amt26) amt26,"+
					   "        sum(a.amt27) amt27,"+
					   "        sum(a.amt28) amt28,"+
					   "        sum(a.amt29) amt29,"+
					   "        sum(a.amt30) amt30,"+
					   "        sum(a.amt31) amt31,"+
					   "        sum(a.amt33) amt33, "+
					   "        sum(a.amt34) amt34, "+
			           "        (sum(a.amt4 )+ sum(a.amt5 ) + sum(a.amt6 ) + sum(a.amt16 ))/(count(decode(a.rent_way,'1',a.rent_l_cd))+count(decode(a.rent_way,'1','',a.rent_l_cd))) as rent_per,"+
					   "        sum(case when nvl(fe.bc_s_a, 0) = 0 then 0 else trunc( nvl(f.fee_s_amt,0) / decode(fe.bc_s_a, 0, 1, null, 1, fe.bc_s_a) * 100000 ) end) af_amt, "+
					   "        sum(fe.bc_s_g) bc_s_g, sum(f.fee_s_amt) fee_s_amt"+
					   " from   stat_bus_cost_cmp_base a, users b, cont c, fee f, fee_etc fe, cls_cont cs"+
					   " where  a.gubun = '" + gubun + "' and decode(a.cost_st,'1',f.rent_start_dt,'3',cs.cls_dt) between '"+cs_dt+"' and '"+ce_dt+"' and a.bus_id=b.user_id"+
			           "        and b.use_yn='Y' and b.loan_st in ('1','2')"+
			           "        and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd  \n"+
					   "	    and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_st = f.rent_st  \n"+
					   "	    and a.rent_mng_id = fe.rent_mng_id(+) and a.rent_l_cd = fe.rent_l_cd(+) and a.rent_st = fe.rent_st(+)  \n"+
					   "        and a.rent_mng_id = cs.rent_mng_id(+) and a.rent_l_cd=cs.rent_l_cd(+) \n"+
				       " group by b.dept_id, b.user_pos, b.user_nm, b.user_id, a.bus_id"+
                       " order by (sum(a.amt4 )+ sum(a.amt5 ) + sum(a.amt6 ) + sum(a.amt16 ))/(count(decode(a.rent_way,'1',a.rent_l_cd))+count(decode(a.rent_way,'1','',a.rent_l_cd)))"+
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
			System.out.println("[CostDatabase:getCostSaleCampaign_20081208(String gubun, String loan_st, String cs_dt, String ce_dt)]"+e);
			System.out.println("[CostDatabase:getCostSaleCampaign_20081208()]"+query);
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
     * 영업효율내역 조회
     */    
	public Vector getSaleCostCampaign_20081208(String cs_dt, String ce_dt, String bus_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();



		String query = " select a.*, f.rent_start_dt, u.user_nm, c.firm_nm, d.car_nm, d.car_no, "+
			           "        decode(b.car_gu, '0', '재리스', '1' ,'신차', '2', '중고차' ) car_gu_nm, fe.bus_agnt_id, u2.user_nm as bus_agnt_nm, \n"+
					   "        decode(a.cost_st,'3','해지','2','추가', '14', '월렌트',decode(a.rent_st, '1', decode(b.rent_st, '1', '신규', '3', '대차', '4', '증차' ), '연장')) rent_st_nm,  \n"+
					   "        decode(b.car_st, '1', '렌트', '2' ,'보유차', '3', '리스' ) car_st_nm, \n"+
			           "        decode(a.rent_way, '1', '일반식', '기본식') rent_way_nm, f.con_mon,  \n"+
					   "        decode(b.spr_kd, '0', '일반', '1', '우량', '2', '초우량', '3', '신설') spr_kd_nm, fe.bc_s_g+nvl(fe.driver_add_amt,0) AS bc_s_g, f.fee_s_amt, \n"+
//					   "        decode(a.rent_st, '1', decode(b.car_gu,'0','-', decode(cm.emp_id, null, '무', decode(cd.one_self,'Y','자체출고','영업사원출고') )), '-') commi2_nm,  \n"+
					   "        decode(a.rent_st, '1', decode(b.car_gu,'0','-', decode(cd.one_self,'Y','자체출고','영업사원출고') ), '-') commi2_nm,  \n"+
					   "        case when nvl(fe.bc_s_a, 0) = 0 then 0 else trunc( nvl(f.fee_s_amt,0) / decode(fe.bc_s_a, 0, 1, null, 1, fe.bc_s_a) * 100000 ) end af_amt, "+
			           "        (decode(cd.trf_st1,'2',nvl(cd.trf_amt1,0),'3',nvl(cd.trf_amt1,0),0)+decode(cd.trf_st2,'2',nvl(cd.trf_amt2,0),'3',nvl(cd.trf_amt2,0),0)+decode(cd.trf_st3,'2',nvl(cd.trf_amt3,0),'3',nvl(cd.trf_amt3,0),0)+decode(cd.trf_st4,'2',nvl(cd.trf_amt4,0),'3',nvl(cd.trf_amt4,0),0)) trf_amt \n"+
					   " from   stat_bus_cost_cmp_base a, cont b, fee f, fee_etc fe , car_etc ce, car_pur cd, users u, users u2, "+
			           "        (select rent_mng_id, rent_l_cd, emp_id from commi where AGNT_ST = '2' ) cm, client c, car_reg d \n"+
                       " where  a.cmp_dt between replace('" + cs_dt + "','-','') and replace('" + ce_dt +"','-','')"+
			           "        and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd  \n"+
					   "	    and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_st = f.rent_st  \n"+
					   "	    and a.rent_mng_id = fe.rent_mng_id(+) and a.rent_l_cd = fe.rent_l_cd(+) and a.rent_st = fe.rent_st(+)  \n"+
					   "	    and a.rent_mng_id = ce.rent_mng_id(+) and a.rent_l_cd = ce.rent_l_cd(+) \n"+
					   "	    and a.rent_mng_id = cd.rent_mng_id(+) and a.rent_l_cd = cd.rent_l_cd(+) \n"+
					   "        and a.bus_id = u.user_id and fe.bus_agnt_id = u2.user_id(+)\n"+
					   "	    and a.rent_mng_id = cm.rent_mng_id(+) and a.rent_l_cd = cm.rent_l_cd(+) \n"+
			           "        and b.client_id=c.client_id and b.car_mng_id=d.car_mng_id"+
					   " ";
				 
		if(!bus_id.equals("") )		query += " and a.bus_id = '"+bus_id+"'";

		query += " order by a.bus_id, f.rent_start_dt ";


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
			System.out.println("[CostDatabase:getSaleCostCampaign_20081208(String ns_dt, String ne_dt, String bus_id)]"+e);
			System.out.println("[CostDatabase]"+query);
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
     * 영업효율내역 조회
     */    
	public Hashtable getSaleCostCampaignCase_20081208(String rent_mng_id, String rent_l_cd, String rent_st, String cs_dt, String ce_dt, String second_per)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String sub_query = " "+
		 " select  a.bus_id, a.rent_mng_id, a.rent_l_cd, a.rent_st, a.rent_way, a.rent_dt, \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt1,0)) amt1,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt2,0)) amt2,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt3,0)) amt3,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt4,0)) amt4,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt5,0)) amt5,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt6,0)) amt6,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt7,0)) amt7,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt10,0)) amt10,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(s.amt11,0)+nvl(s2.amt11,0)) amt11,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt13,0)) amt13,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(p.amt14,0)+nvl(p2.amt14,0)) amt14,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(q.amt15,0)+nvl(q2.amt15,0)) amt15,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(q.amt16,0)+nvl(q2.amt16,0)) amt16,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(q.amt17,0)+nvl(q2.amt17,0)) amt17,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(p.amt18,0)+nvl(p2.amt18,0)) amt18,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt19,0)) amt19,  \n"+
         "      0 as amt22, \n"+
         "      0 as amt23, \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt24,0)) amt24,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt25,0)) amt25,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(decode(sign(a.amt26),-1,0,a.amt26),0)) amt26,  \n"+
         "      0 as amt27,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt29,0)) amt29,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt33,0)) amt33,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(-i2.amt34,0)) amt34,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(c.cost_amt,0)+nvl(c2.cost_amt,0)) cost_amt,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(c.oil_amt,0)+nvl(c2.oil_amt,0)) oil_amt,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(c.sun_amt,0)+nvl(c2.sun_amt,0)) sun_amt,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(c.tint_amt,0)+nvl(c2.tint_amt,0)) tint_amt,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.af_amt,0)) af_amt,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.bc_s_g,0)) bc_s_g,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.bc_s_c,0)) bc_s_c,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.fee_s_amt,0)) fee_s_amt,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.con_mon,0)) con_mon,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt35,0)) amt35,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt36,0)) amt36,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt39,0)) amt39,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt40,0)) amt40,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt41,0)) amt41,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt42,0)) amt42,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt43,0)) amt43,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt44,0)) amt44,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt45,0)) amt45,  \n" + 
         "      decode(a.bc_s_c,0,0,nvl(a.amt46,0)) amt46   \n"+
    	 " from \n"+
     	 "	       ( \n"+
         "        select e.rent_mng_id, e.rent_l_cd, a.car_gu, e.rent_st, e.rent_way, e.rent_start_dt, "+
		 "	             c.bc_s_g+nvl(c.driver_add_amt,0)+NVL(e.ins_s_amt,0) AS bc_s_g, c.bc_s_c, "+
		 "	             decode(e.rent_st,'1',a.rent_dt,e.rent_dt) rent_dt, \n"+
         "               decode(decode(e.rent_st,'1',a.bus_id,e.ext_agnt),'000037',a.mng_id, decode(e.rent_st,'1',a.bus_id,nvl(e.ext_agnt,a.bus_id))) bus_id, c.bus_agnt_id, \n"+
		 "	             b.car_cs_amt,\n"+
         "               c.bc_b_a as amt1, c.bc_b_b as amt2, \n"+
         "               case when nvl(c.bc_s_c, 0)=0 then 0 else \n"+
         "                    trunc( (  ( nvl(c.bc_s_c,0) * ( (nvl(c.bc_s_d,0)/100) - (nvl(c.bc_s_e,0)/100) ) ) - ( nvl(c.bc_s_g,0)+nvl(c.driver_add_amt,0)+NVL(e.ins_s_amt,0) - nvl(e.fee_s_amt,0) ) )/ decode(c.bc_s_a, 0, 1, null, 1, c.bc_s_a) * 100000 + nvl(c.bc_s_f,0) ) \n"+
         "               end amt3, \n"+
         "               decode(a.car_gu,'1',0,c.bc_b_d) as amt4, \n"+
         "               case when a.car_gu='0' AND nvl(decode(e2.rent_l_cd,'',e.opt_chk,e2.opt_chk), '0') = '1' then 0 "+
		 "	                  WHEN a.car_gu='0' AND nvl(decode(e2.rent_l_cd,'',e.opt_chk,e2.opt_chk), '0') ='0' AND g2.rent_dt >= '20180109' THEN trunc((nvl(c.bc_b_e1,0)/100 - 1 )/36*(CASE WHEN TO_NUMBER(g2.a_b)>36 THEN 36 ELSE TO_NUMBER(g2.a_b) end)* nvl(c.bc_b_e2,0))  "+
		 "	                  WHEN a.car_gu='0' AND nvl(decode(e2.rent_l_cd,'',e.opt_chk,e2.opt_chk), '0') ='0' AND g2.rent_dt < '20180109'  then trunc((nvl(c.bc_b_e1,0)/100 - 1 ) * nvl(c.bc_b_e2,0))  "+
		 "	             end amt5, \n"+
         "               trunc((decode(d.trf_st1,'2',nvl(d.trf_amt1,0),'3',nvl(d.trf_amt1,0),'7',nvl(d.trf_amt1,0),0)+ \n"+
         "                      decode(d.trf_st2,'2',nvl(d.trf_amt2,0),'3',nvl(d.trf_amt2,0),'7',nvl(d.trf_amt2,0),0)+ \n"+
         "                      decode(d.trf_st3,'2',nvl(d.trf_amt3,0),'3',nvl(d.trf_amt3,0),'7',nvl(d.trf_amt3,0),0)+ \n"+
         "                      decode(d.trf_st4,'2',nvl(d.trf_amt4,0),'3',nvl(d.trf_amt4,0),'7',nvl(d.trf_amt4,0),0)) \n"+
         "                      *nvl(c.bc_s_i,1.8375)/100 \n"+
         "               ,0) as amt6, \n"+ 

         "               case when e.rent_start_dt >= '20141101' AND e.RENT_ST='1' AND a.car_gu='1' then c.bc_b_g+(NVL(b.R_IMPORT_CASH_BACK,0)-NVL(b.IMPORT_CASH_BACK,0)-(NVL(b.R_IMPORT_BANK_AMT,0)-NVL(b.IMPORT_BANK_AMT,0))) else c.bc_b_g end amt7, "+ 
		 "	             c.bc_b_b as amt10, \n"+
         "               decode(a.car_gu,'1',decode(e.rent_st,'1',trunc((DECODE(d.cons_st,'2',d.cons_amt1, nvl(b.sd_cs_amt, 0) + nvl(b.sd_cv_amt, 0)) - nvl(c.bc_b_n,0))/1.1,0),0),0) amt13, \n"+
         "               decode(e.rent_st,'1',nvl(trunc(b.extra_amt/1.1,0), 0),0) amt17, \n"+
         "               nvl(c.bc_b_u,0) amt19, \n"+
         "               trunc(nvl(c.bc_s_c,0) * (nvl(c.bc_s_e,0)/100) / decode(c.bc_s_a, 0, 1, null, 1, c.bc_s_a) * 100000,0) as amt24, \n"+
         "               nvl(c.cls_n_amt,0) amt25, \n"+
         "               trunc(decode(c.cls_n_amt,0,0,trunc(nvl(c.cls_n_amt,0) - ( ( e.fee_s_amt *  nvl(c.bc_s_b, 0) + e.pp_s_amt ) * 0.03 ),0))) as amt26,       \n"+
         "               nvl(f.rent_suc_commi,0) amt27, \n"+
         "               nvl(c.bc_b_ac,0) amt29, \n"+
         "               case when nvl(c.bc_s_a, 0) = 0 then 0 else trunc( ( nvl(e.fee_s_amt,0) / decode(c.bc_s_a, 0, 1, null, 1, c.bc_s_a) * 100000 ) + e.pp_s_amt) end af_amt, \n"+
         "               e.fee_s_amt, e.con_mon, \n"+
         "               CASE WHEN a.rent_dt < '20130109' THEN 0 ELSE DECODE(e.rent_st,'1',NVL(cm2.dlv_con_commi,0),0) END amt35, \n"+
         "               CASE WHEN a.rent_dt < '20130109' THEN 0 ELSE DECODE(e.rent_st,'1',NVL(cm2.dlv_tns_commi,0),0) END amt36, \n"+
         "               CASE WHEN a.rent_dt < '20130501' THEN 0 ELSE DECODE(e.rent_st,'1',NVL(cm2.agent_commi,0)+NVL(cm3.commi,0),0) END amt39,  \n"+
         "               trunc(DECODE(decode(nvl(g.jg_w,''),'',decode(b.car_origin,'2','1','0'),g.jg_w), \n"+
         "                      '1',nvl(b.import_card_amt,0)*nvl(c.bc_s_i,0)/100, \n"+
         "                      decode(g.jg_g_7,'3',(nvl(g.s_a,0)-nvl(g.bk_128,0)-nvl(g.bk_129,0))*nvl(c.bc_s_i2,0)/100, \n"+
         "                                      '4',(nvl(g.s_a,0)-nvl(g.bk_128,0)-nvl(g.bk_129,0))*nvl(c.bc_s_i2,0)/100, \n"+
         "                                      nvl(g.s_a,0)*nvl(c.bc_s_i2,0)/100) \n"+
         "                       ),0)-case when a.rent_dt <'20210101' and h.jg_code in ('9015435','9025435') then 2300000 when a.rent_dt >='20210101' and h.jg_code in ('9015435','9025435') then 1500000 else 0 end AS amt40, \n"+
         "               trunc(DECODE(decode(nvl(g.jg_w,''),'',decode(b.car_origin,'2','1','0'),g.jg_w),'1',nvl(g.k_su_12,0),0),0) amt41, "+
		 "		         nvl(c.bc_b_t,0) amt42, \n"+
         "               NVL(g.ax116,0) tint_bsn_amt, \n"+ 
         "			     nvl(g.k_so,0) amt43, \n"+
         "               nvl(g.ax117,0) amt44, \n"+
         "               DECODE(e.rent_st,'1',NVL(g.ax116,0),0) amt45, DECODE(e.rent_st,'1',NVL(g.br_cons_amt,0),0) amt46, \n"+ 
		 "	             nvl(d.trf_amt5,0) amt33 \n"+
         "        from   cont a,  fee e, fee_etc c, car_pur d, car_etc b, cont_etc f, \n"+
		 "               (select * from cls_cont where cls_st in ('4','5')) y, \n"+
         "               (select rent_mng_id, rent_l_cd, emp_id from commi where AGNT_ST = '2' ) cm, \n"+
         "               (select rent_mng_id, rent_l_cd, emp_id, commi, dlv_con_commi, dlv_tns_commi, agent_commi from commi where AGNT_ST = '1'  AND NVL(dlv_con_commi,0)+NVL(dlv_tns_commi,0)+NVL(agent_commi,0)>0) cm2, \n"+
         "               (select rent_mng_id, rent_l_cd, emp_id, commi from commi where AGNT_ST = '4' AND commi>0  ) cm3, "+
		 "	             fee e2, ESTI_EXAM g, \n"+
		 "	             estimate g2, car_nm h, \n"+
         "               (SELECT rent_mng_id, rent_l_cd, emp_id FROM COMMI WHERE agnt_st='1') cm4 \n"+
         "        where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and e.rent_st='"+rent_st+"' \n"+
         "               and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd \n"+
         "               and e.rent_mng_id=c.rent_mng_id and e.rent_l_cd=c.rent_l_cd and e.rent_st = c.rent_st and nvl(c.bc_s_a,0) > 0 \n"+
         "               and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd \n"+
         "               and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd \n"+
         "               and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd=f.rent_l_cd \n"+
         "               and a.rent_mng_id=y.rent_mng_id(+) and a.reg_dt=y.reg_dt(+) \n"+
         "               and a.rent_mng_id = cm.rent_mng_id(+) and a.rent_l_cd=cm.rent_l_cd(+) \n"+
         "               and a.rent_mng_id = cm2.rent_mng_id(+) and a.rent_l_cd=cm2.rent_l_cd(+) \n"+
         "               and a.rent_mng_id = cm3.rent_mng_id(+) and a.rent_l_cd=cm3.rent_l_cd(+) \n"+
		 "               and e.rent_mng_id = e2.rent_mng_id(+) and e.rent_l_cd = e2.rent_l_cd(+) and (e.rent_st-1)=e2.rent_st(+) \n"+
		 "               and nvl(y.cls_dt,nvl(e.rent_dt,a.rent_dt))<=nvl(e.rent_dt,a.rent_dt) \n"+	
         "               AND c.bc_est_id=g.est_id(+) \n"+
         "               AND g.est_id=g2.est_id(+) AND g2.car_id=h.car_id(+) AND g2.car_seq=h.car_seq(+) \n"+
         "               and a.rent_mng_id = cm4.rent_mng_id(+) and a.rent_l_cd=cm4.rent_l_cd(+) \n"+
		 
         "      ) a, \n"+
    	 "		     -- 일반식 재리스수리비금액(amt11) \n"+
    	 "			   ( select e.rent_mng_id, e.rent_l_cd, e.rent_st, sum(b.tot_amt-nvl(b.sh_amt,0)) amt11 \n"+
         "        from   cont a, service b, fee e \n"+
         "        where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and e.rent_st='"+rent_st+"' \n"+
         "               and a.car_mng_id=b.car_mng_id  \n"+
         "               and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
         "               and a.car_gu = '0' \n"+
		 "               and b.serv_st='7' "+	
		 "               and e.rent_way='1' "+	
         "               and b.reg_dt between to_char(to_date(e.rent_start_dt,'YYYYMMDD')-7,'YYYYMMDD') and to_char(add_months(to_date(e.rent_start_dt,'YYYYMMDD'),2),'YYYYMMDD') \n"+
		 "               and b.reg_dt <= to_char(sysdate,'YYYYMMDD') "+	
		 "               AND b.tot_amt-nvl(b.sh_amt,0)>0 "+	
         "        group by e.rent_mng_id, e.rent_l_cd, e.rent_st \n"+
         "      ) s, \n"+
    	 "		     -- 기본식 재리스수리비금액(amt11) \n"+
    	 "			   ( select e.rent_mng_id, e.rent_l_cd, e.rent_st, sum(b.tot_amt-nvl(b.sh_amt,0)) amt11 \n"+
         "        from   cont a, service b, fee e \n"+
         "        where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and e.rent_st='"+rent_st+"' \n"+
         "               and a.car_mng_id=b.car_mng_id  \n"+
         "               and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
         "               and a.car_gu = '0' \n"+
		 "               and b.serv_st in ('7','2') "+	
		 "               and e.rent_way<>'1' "+	
         "               and b.reg_dt between to_char(to_date(e.rent_start_dt,'YYYYMMDD')-7,'YYYYMMDD') and to_char(add_months(to_date(e.rent_start_dt,'YYYYMMDD'),2),'YYYYMMDD') \n"+
		 "               and b.reg_dt <= to_char(sysdate,'YYYYMMDD') "+	
		 "               AND b.tot_amt-nvl(b.sh_amt,0)>0 "+	
         "        group by e.rent_mng_id, e.rent_l_cd, e.rent_st \n"+
         "      ) s2, \n"+
    	 "	       -- 탁송료 : 차량인도 탁송료(amt14), 탁송 유류비 금액(amt18) \n"+
         "      (  select e.rent_mng_id, e.rent_l_cd, e.rent_st, \n"+
         "               sum((nvl(b.amt14,0)+nvl(c.amt14,0)+nvl(d.amt14,0))) as amt14, sum((nvl(b.amt18,0)+nvl(c.amt18,0)+nvl(d.amt18,0))) amt18 \n"+
         "        from   cont a, fee e, \n"+
         "               --외부업체 탁송 \n"+
         "               ( \n"+
         "                   select rent_mng_id, rent_l_cd, (tot_amt-oil_amt) as amt14, oil_amt as amt18 \n"+
         "                   from   consignment \n"+
         "                   where  off_nm <>'(주)아마존카' and cons_cau in ('1','3','8') \n"+
         "               ) b, \n"+
         "               --자체탁송 탁송료 \n"+
         "               ( \n"+
         "                   select a.rent_mng_id, a.rent_l_cd, 0 as amt14, 0 as amt18 \n"+
         "                   from   consignment a, (select * from code where c_st='0022' ) b \n"+
         "                   where  a.off_nm ='(주)아마존카' and a.cons_cau in ('1','3','8') \n"+
         "                          and a.cmp_app=b.nm_cd \n"+
         "               ) c, \n"+
         "               --자체탁송 유류대 \n"+
         "               ( \n"+
         "                   select a.rent_mng_id, a.rent_l_cd, 0 as amt14, b.buy_amt as amt18 \n"+
         "                   from   consignment a, \n"+
         "                          (select buy_dt, ven_name, buy_amt, rent_l_cd, item_name from card_doc where acct_code='00004' and acct_code_g2 in ('12','13') ) b \n"+
         "                   where  a.off_nm ='(주)아마존카' and a.cons_cau in ('1','3','8') \n"+
         "                          and substr(a.from_req_dt,1,8)=b.buy_dt(+) and instr(b.item_name,a.car_no) > 0 \n"+
         "                ) d \n"+
         "        where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and e.rent_st='"+rent_st+"' \n"+
         "               and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
         "               and e.rent_st='1' \n"+
         "               and a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) \n"+
         "               and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) \n"+
         "               and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+) \n"+
         "               and (nvl(b.amt14,0)+nvl(b.amt18,0)+nvl(c.amt14,0)+nvl(c.amt18,0)+nvl(d.amt14,0)+nvl(d.amt18,0))>0 \n"+
         "        group by e.rent_mng_id, e.rent_l_cd, e.rent_st \n"+
         "      ) p, \n"+
    	 "	       -- 탁송료 : 차량인도 탁송료(amt14), 탁송 유류비 금액(amt18) \n"+
    	 "	   ( select e.rent_mng_id, e.rent_l_cd, e.rent_st, \n"+
         "               sum(nvl(d.amt14,0)) as amt14, sum(nvl(d.amt18,0)) amt18 \n"+
         "        from   cont a, fee e, taecha t, \n"+
         "               ( \n"+
         "                   --외부업체 탁송 \n"+
         "                   select client_id, car_mng_id, rent_mng_id, rent_l_cd, substr(from_dt,1,8) cons_dt, (tot_amt-oil_amt) as amt14, oil_amt as amt18 \n"+
         "                   from   consignment \n"+
         "                   where  off_nm <>'(주)아마존카' and cons_cau in ('3','8') \n"+
         "                   union all \n"+
         "                   --자체탁송 탁송료1 \n"+
         "                   select a.client_id, a.car_mng_id, a.rent_mng_id, a.rent_l_cd, substr(a.from_dt,1,8) cons_dt, 0 as amt14, 0 as amt18 \n"+
         "                   from   consignment a, (select * from code where c_st='0022' ) b \n"+
         "                   where  a.off_nm ='(주)아마존카' and a.cons_cau in ('3','8') \n"+
         "                          and a.cmp_app=b.nm_cd \n"+
         "                          and a.cons_su=1 \n"+
         "                   union all \n"+
         "                   --자체탁송 탁송료2 \n"+
         "                   select a.client_id, a.car_mng_id, a.rent_mng_id, a.rent_l_cd, substr(a.from_dt,1,8) cons_dt, 0 as amt14, 0 as amt18 \n"+
         "                   from   consignment a, (select * from code where c_st='0022' ) b \n"+
         "                   where  a.off_nm ='(주)아마존카' and a.cons_cau in ('3','8') \n"+
         "                          and a.cmp_app=b.nm_cd \n"+
         "                          and a.cons_su<>1 \n"+
         "                   union all \n"+
         "                   --자체탁송 유류대 \n"+
         "                   select a.client_id, a.car_mng_id, a.rent_mng_id, a.rent_l_cd, substr(a.from_dt,1,8) cons_dt, 0 as amt14, b.buy_amt as amt18 \n"+
         "                   from   consignment a, \n"+
         "                          (select buy_dt, ven_name, buy_amt, rent_l_cd, item_name from card_doc where acct_code='00004' and acct_code_g2 in ('12','13') ) b \n"+
         "                   where  a.off_nm ='(주)아마존카' and a.cons_cau in ('3','8') \n"+
         "                          and substr(a.from_req_dt,1,8)=b.buy_dt(+) and instr(b.item_name,a.car_no) > 0 \n"+
         "                ) d \n"+
         "        where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and e.rent_st='"+rent_st+"' \n"+
         "               and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
         "               and a.rent_mng_id=t.rent_mng_id and a.rent_l_cd=t.rent_l_cd \n"+
         "               and nvl(e.prv_mon_yn,'0')<>'0' \n"+
         "               and e.rent_st='1' \n"+
         "               and t.car_mng_id=d.car_mng_id \n"+
         "               and a.client_id=d.client_id \n"+
         "               and (nvl(d.amt14,0)+nvl(d.amt18,0))>0 \n"+
         "        group by e.rent_mng_id, e.rent_l_cd, e.rent_st \n"+
         "      ) p2, \n"+
    	 "	    -- 용품 : 썬팅비용(amt15), 지급용품(amt16) \n"+
    	 "		( select e.rent_mng_id, e.rent_l_cd, e.rent_st, \n"+
         "               sum(decode(a.car_gu,'1',decode(b.tint_amt,   0,0,nvl(b.tint_amt,0)   -nvl(b.e_tint_amt,0)   -nvl(b.c_tint_amt,0)   ),0)) amt15,--신차만 \n"+
         "               sum(                    decode(b.cleaner_amt,0,0,nvl(b.cleaner_amt,0)-nvl(b.e_cleaner_amt,0)-nvl(b.c_cleaner_amt,0)   )) amt16, \n"+
         "               sum(                    decode(b.navi_amt+b.other_amt,   0,0,nvl(b.navi_amt,0)+nvl(b.other_amt,0)-nvl(b.e_navi_amt,0)-nvl(b.c_navi_amt,0)-nvl(b.e_other_amt,0)-nvl(b.c_other_amt,0)   )) amt17 \n"+
         "        from   cont a, tint b, fee e \n"+
         "        where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and e.rent_st='"+rent_st+"' \n"+
         "               and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
         "               and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
         "               and e.rent_st='1' \n"+
         "        group by e.rent_mng_id, e.rent_l_cd, e.rent_st \n"+
         "      ) q, \n"+
    	 "	       -- new 용품 : 썬팅비용(amt15), 지급용품(amt16) : 20091027 재리스차량 용품등록분만 반영 \n"+
    	 "	       (  \n"+
         "        select e.rent_mng_id, e.rent_l_cd, e.rent_st, \n"+
         "               sum(decode(a.car_gu,'1',decode(b.tint_st,'1',nvl(b.tint_amt,0),'2',nvl(b.tint_amt,0),0),0)) amt15,--신차만 \n"+
         "               sum(decode(b.tint_st,'1',0,'2',0,'3',nvl(decode(b.TINT_AMT,20000,92727,15000,87727,b.tint_amt),0),nvl(b.tint_amt,0))) amt16, \n"+
         "               0 amt17 \n"+
         "        from   cont a, car_tint b, fee e \n"+
         "        where \n"+
         "               a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and e.rent_st='"+rent_st+"' \n"+
         "               and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd AND b.tint_yn='Y' \n"+
         "               and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
         "               and e.rent_st='1' \n"+
         "        group by e.rent_mng_id, e.rent_l_cd, e.rent_st \n"+
         "      ) q2, \n"+
         "      -- 렌트긴급출동보험가입비(amt33) \n"+
         "      ( select e.rent_mng_id, e.rent_l_cd, e.rent_st, \n"+
         "               sum(trunc(nvl(d.ch_amt,b.vins_spe_amt)/(to_date(b.ins_exp_dt,'YYYYMMDD')-to_date(nvl(d.ch_dt,b.ins_start_dt),'YYYYMMDD'))*365/12*(e.con_mon-nvl(c.cls_n_mon,0)),0)) amt33 \n"+
         "        from   cont a, fee e, fee_etc c, insur b, (select * from ins_change where ch_item='6' and ch_amt>0) d \n"+
         "        where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and a.car_st='1'\n"+
         "               and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd \n"+
         "               and e.rent_mng_id=c.rent_mng_id and e.rent_l_cd=c.rent_l_cd and e.rent_st = c.rent_st \n"+
         "               and a.car_mng_id=b.car_mng_id \n"+
         "               and b.car_mng_id=d.car_mng_id(+) and b.ins_st=d.ins_st(+) \n"+
         "               and b.vins_spe_amt>0 \n"+
         "               and nvl(e.rent_start_dt,a.rent_start_dt) between b.ins_start_dt and to_char(to_date(b.ins_exp_dt,'YYYYMMDD')-1,'YYYYMMDD') \n"+
       "        group by e.rent_mng_id, e.rent_l_cd, e.rent_st \n"+
         "      ) i, \n"+
         "      -- 고객피보험자 (amt34) \n"+
         "      ( select e.rent_mng_id, e.rent_l_cd, e.rent_st, \n"+
         "               sum(trunc((b.rins_pcp_amt+b.vins_pcp_amt+b.vins_gcp_amt+b.vins_bacdt_amt+b.vins_canoisr_amt+b.vins_cacdt_cm_amt+b.vins_spe_amt)/12/c.bc_s_a*100000,0)) amt34 \n"+ 
         "        from   cont a, fee e, fee_etc c, insur b, cont_etc f, ins_cls g \n"+
         "        where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' \n"+
         "               and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd \n"+
         "               and e.rent_mng_id=c.rent_mng_id and e.rent_l_cd=c.rent_l_cd and e.rent_st = c.rent_st \n"+
         "               and a.car_mng_id=b.car_mng_id \n"+
		 "               and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd \n"+
         "               and b.car_mng_id=g.car_mng_id(+) and b.ins_st=g.ins_st(+)  \n"+
		 "               and decode(f.insur_per,'2','고객','아마존카')<>'아마존카' \n"+	
         "               and b.con_f_nm<>'아마존카' AND b.conr_nm='아마존카' \n"+
         "               and c.bc_s_a >0 \n"+
		 "      	     and ( b.ins_start_dt between e.rent_start_dt and e.rent_end_dt  or \n"+
         "                     to_char(to_date(nvl(g.req_dt,b.ins_exp_dt),'YYYYMMDD')-1,'YYYYMMDD') between e.rent_start_dt and e.rent_end_dt ) \n"+
         "               and a.reg_dt < '20180313' \n"+
         "        group by e.rent_mng_id, e.rent_l_cd, e.rent_st \n"+
         "      ) i2, \n"+
         "      --관리비용(네오엠비용) \n"+
         "      ( select e.rent_mng_id, e.rent_l_cd, e.rent_st, \n"+
         "               sum(decode(b.gubun,'1',decode(b.c_st,'1',b.cost_amt,0),0)) cost_amt, \n"+
         "               0 oil_amt, \n"+
         "               sum(decode(b.gubun,'4',b.cost_amt,0)) sun_amt, \n"+
         "               sum(decode(b.gubun,'6',b.cost_amt,0)) tint_amt \n"+
         "        from   cont a, fee e, fee_etc c, cost_neom b \n"+
         "        where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and e.rent_st='"+rent_st+"'\n"+
         "               and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd \n"+
         "               and e.rent_mng_id=c.rent_mng_id and e.rent_l_cd=c.rent_l_cd and e.rent_st = c.rent_st \n"+
         "               and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd \n"+
         "               and nvl(e.ext_agnt,decode(a.bus_id,'000037',a.mng_id,a.bus_id))=b.cost_id \n"+
         "               and b.gubun in ('1','5','4','6') \n"+
         "               and b.cost_dt between nvl(e.rent_start_dt,a.rent_start_dt) and nvl(e.rent_end_dt,'99999999') \n"+
         "        group by e.rent_mng_id, e.rent_l_cd, e.rent_st \n"+
         "      ) c, \n"+
         "      --관리비용(출금) \n"+
         "      ( select e.rent_mng_id, e.rent_l_cd, e.rent_st, \n"+
         "               sum(decode(b.cost_gubun,'1',b.i_amt,0)) cost_amt, \n"+
         "               0 oil_amt, \n"+
         "               sum(decode(b.cost_gubun,'4',b.i_amt,0)) sun_amt, \n"+
         "               sum(decode(b.cost_gubun,'6',b.i_amt,0)) tint_amt \n"+
         "        from   cont a, fee e, fee_etc c, pay_item b, pay p \n"+
         "        where \n"+
         "               a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and e.rent_st='"+rent_st+"'\n"+
         "               and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd \n"+
         "               and e.rent_mng_id=c.rent_mng_id and e.rent_l_cd=c.rent_l_cd and e.rent_st = c.rent_st \n"+
         "               and a.rent_mng_id = b.p_cd1 and a.rent_l_cd = b.p_cd2 \n"+
         "               and b.reqseq=p.reqseq \n"+
         "               and nvl(e.ext_agnt,decode(a.bus_id,'000037',a.mng_id,a.bus_id))=b.buy_user_id \n"+
         "               and b.cost_gubun in ('1','5','4','6') \n"+
         "               and p.p_pay_dt between nvl(e.rent_start_dt,a.rent_start_dt) and nvl(e.rent_end_dt,'99999999') \n"+
         "               and p.p_pay_dt >= '20091201' \n"+
         "        group by e.rent_mng_id, e.rent_l_cd, e.rent_st \n"+
         "      ) c2 \n"+
    	 " where    a.rent_mng_id=s.rent_mng_id(+) and a.rent_l_cd=s.rent_l_cd(+) and a.rent_st=s.rent_st(+) \n"+
         "      and a.rent_mng_id=s2.rent_mng_id(+) and a.rent_l_cd=s2.rent_l_cd(+) and a.rent_st=s2.rent_st(+) \n"+
         "      and a.rent_mng_id=p.rent_mng_id(+) and a.rent_l_cd=p.rent_l_cd(+) and a.rent_st=p.rent_st(+) \n"+
         "      and a.rent_mng_id=p2.rent_mng_id(+) and a.rent_l_cd=p2.rent_l_cd(+) and a.rent_st=p2.rent_st(+) \n"+
         "      and a.rent_mng_id=q.rent_mng_id(+) and a.rent_l_cd=q.rent_l_cd(+) and a.rent_st=q.rent_st(+) \n"+
         "      and a.rent_mng_id=q2.rent_mng_id(+) and a.rent_l_cd=q2.rent_l_cd(+) and a.rent_st=q2.rent_st(+) \n"+
         "      and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) and a.rent_st=i.rent_st(+) \n"+
         "      and a.rent_mng_id=i2.rent_mng_id(+) and a.rent_l_cd=i2.rent_l_cd(+) and a.rent_st=i2.rent_st(+) \n"+
         "      and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and a.rent_st=c.rent_st(+) \n"+
		 "      and a.rent_mng_id=c2.rent_mng_id(+) and a.rent_l_cd=c2.rent_l_cd(+) and a.rent_st=c2.rent_st(+) \n"+		
         " ";


		String query = " select a.*, f.rent_start_dt, u.user_nm, c.firm_nm, d.car_nm, d.car_no, ce.car_id, ce.car_seq, decode(f.rent_st,'1',b.rent_dt,f.rent_dt) rent_dt, "+
			           "        decode(b.car_gu, '0', '재리스', '1' ,'신차', '2', '중고차' ) car_gu_nm, fe.bus_agnt_id, u2.user_nm as bus_agnt_nm, \n"+
					   "        decode(a.cost_st,'3','해지','2','추가', '14', '월렌트',decode(a.rent_st, '1', decode(b.rent_st, '1', '신규', '3', '대차', '4', '증차' ), '연장')) rent_st_nm,  \n"+
					   "        decode(b.car_st, '1', '렌트', '2' ,'보유차', '3', '리스' ) car_st_nm, \n"+
			           "        decode(a.rent_way, '1', '일반식', '기본식') rent_way_nm, f.con_mon,  \n"+
					   "        decode(b.spr_kd, '0', '일반', '1', '우량', '2', '초우량', '3', '신설') spr_kd_nm, fe.bc_s_g+nvl(fe.driver_add_amt,0) AS bc_s_g, fe.bc_s_c, f.fee_s_amt, \n"+
					   "        decode(a.rent_st, '1', decode(b.car_gu,'0','-', decode(cd.one_self,'Y','자체출고','영업사원출고') ), '-') commi2_nm,  \n"+
					   "        case when nvl(fe.bc_s_a, 0) = 0 then 0 else trunc( ( nvl(f.fee_s_amt,0) / decode(fe.bc_s_a, 0, 1, null, 1, fe.bc_s_a) * 100000 ) + f.pp_s_amt ) end af_amt, "+
			           "        (decode(cd.trf_st1,'2',nvl(cd.trf_amt1,0),'3',nvl(cd.trf_amt1,0),0)+decode(cd.trf_st2,'2',nvl(cd.trf_amt2,0),'3',nvl(cd.trf_amt2,0),0)+decode(cd.trf_st3,'2',nvl(cd.trf_amt3,0),'3',nvl(cd.trf_amt3,0),0)+decode(cd.trf_st4,'2',nvl(cd.trf_amt4,0),'3',nvl(cd.trf_amt4,0),0)) trf_amt \n"+
					   " from   ( select '"+cs_dt+"' cs_dt, '"+ce_dt+"' ce_dt, '1' cost_st, '2' gubun, \n"+
			           "                 rent_mng_id, rent_l_cd, rent_st, bus_id, rent_way, \n"+
              	       "                 amt1, amt2, amt3, amt4, amt5, \n"+
              	       "                 amt6, amt7, trunc(nvl(amt1,0)+nvl(amt2,0)+nvl(amt3,0)+nvl(amt4,0)+nvl(amt5,0)+nvl(amt6,0)+nvl(amt7,0)+nvl(amt34,0)-nvl(amt35,0)-nvl(amt36,0)-nvl(amt39,0)-nvl(amt40,0)+nvl(amt41,0)+nvl(amt46,0),0) amt8, 0 amt9, amt10, \n"+
              	       "                 amt11, trunc(amt11*"+second_per+"/100,0) amt12, amt13, (amt14+cost_amt) amt14, (amt15+sun_amt) amt15, \n"+
              	       "                 (amt16+tint_amt) amt16, amt17, (amt18+oil_amt) amt18, amt19, \n"+
                       "                 (amt10+amt11+amt13+amt14+cost_amt+amt15+sun_amt+amt16+tint_amt+amt17+amt18+oil_amt+amt19+amt33) amt20,  \n"+
              	       "                 (amt10+trunc(amt11*"+second_per+"/100,0)+amt13+amt14+cost_amt+amt15+sun_amt+amt16+tint_amt+amt17+amt18+oil_amt+amt19+amt33+amt46-amt45) amt21, \n"+
                       "                 amt22, amt23, amt24, amt25, \n"+
              	       "                 amt26, amt27, 0 amt28, amt29, \n"+
                       "                 (amt23+amt24-amt26+amt27+amt29) amt30, amt33, amt34, amt35*-1 as amt35, amt36*-1 as amt36, amt39*-1 as amt39, amt40*-1 as amt40, amt41, amt42, amt45, amt46  from ("+sub_query+") ) a, "+
					   "        cont b, fee f, fee_etc fe , car_etc ce, car_pur cd, users u, users u2, "+
			           "        (select rent_mng_id, rent_l_cd, emp_id from commi where AGNT_ST = '2' ) cm, client c, car_reg d \n"+
                       " where  "+
			           "            a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd  \n"+
					   "	    and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_st = f.rent_st  \n"+
					   "	    and a.rent_mng_id = fe.rent_mng_id(+) and a.rent_l_cd = fe.rent_l_cd(+) and a.rent_st = fe.rent_st(+)  \n"+
					   "	    and a.rent_mng_id = ce.rent_mng_id(+) and a.rent_l_cd = ce.rent_l_cd(+) \n"+
					   "	    and a.rent_mng_id = cd.rent_mng_id(+) and a.rent_l_cd = cd.rent_l_cd(+) \n"+
					   "        and a.bus_id = u.user_id and fe.bus_agnt_id = u2.user_id(+)\n"+
					   "	    and a.rent_mng_id = cm.rent_mng_id(+) and a.rent_l_cd = cm.rent_l_cd(+) \n"+
			           "        and b.client_id=c.client_id and b.car_mng_id=d.car_mng_id(+)"+
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
			System.out.println("[CostDatabase:getSaleCostCampaignCase_20081208(String rent_mng_id, String rent_l_cd, String rent_st)]"+e);
			System.out.println("[CostDatabase]"+query);
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

	  /**
     * 영업효율내역 조회
     */    
	public Hashtable getSaleCostCampaignAddCase_20090302(String rent_mng_id, String rent_l_cd, String rent_st, String cs_dt, String ce_dt, String second_per)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String sub_query = " "+
		 " select  a.bus_id, a.rent_mng_id, a.rent_l_cd, a.rent_st, a.rent_way,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt1,0)) amt1,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt2,0)) amt2,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt3,0)) amt3,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt4,0)) amt4,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt5,0)) amt5,  \n"+
         "      decode(a.bc_s_c,0,0,decode(a.rent_st,'t',0,nvl(a.amt6,0))) amt6,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt7,0)) amt7,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt10,0)) amt10,  \n"+
         "      decode(a.bc_s_c,0,0,decode(a.rent_st,'t',0,nvl(s.amt11,0))) amt11,  \n"+
         "      decode(a.bc_s_c,0,0,decode(a.rent_st,'t',0,nvl(a.amt13,0))) amt13,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(p.amt14,0)) amt14,  \n"+
         "      decode(a.bc_s_c,0,0,decode(a.rent_st,'t',0,nvl(q.amt15,0))) amt15,  \n"+
         "      decode(a.bc_s_c,0,0,decode(a.rent_st,'t',0,nvl(q.amt16,0))) amt16,  \n"+
         "      decode(a.bc_s_c,0,0,decode(a.rent_st,'t',0,nvl(a.amt17,0))) amt17,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(p.amt18,0)) amt18,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt19,0)) amt19,  \n"+
//         "      decode(a.bc_s_c,0,0,decode(a.rent_st,'t',0,nvl(a.amt22,0))) amt22,  \n"+
//         "      decode(a.bc_s_c,0,0,decode(a.rent_st,'t',0,nvl(  \n"+
//         "      trunc(decode(sign(a.amt23-(a.car_cs_amt*0.05)),1,(a.car_cs_amt*0.05)*0.5,(a.amt23*0.5)),0)+  \n"+
//         "      trunc(decode(sign(a.amt23-(a.car_cs_amt*0.05)),1,(a.amt23-(a.car_cs_amt*0.05))*0.2,0),0)  \n"+
//         "      ,0))) amt23,  \n"+
         "      0 as amt22, \n"+
         "      0 as amt23, \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt24,0)) amt24,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt25,0)) amt25,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(decode(sign(a.amt26),-1,0,a.amt26),0)) amt26,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt27,0)) amt27,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(a.amt29,0)) amt29,  \n"+
         "      decode(a.bc_s_c,0,0,decode(a.rent_st,'t',0,nvl(i.amt33,0))) amt33,  \n"+
         "      decode(a.bc_s_c,0,0,decode(a.rent_st,'t',0,nvl(-i2.amt34,0))) amt34,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(c.cost_amt,0)) cost_amt,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(c.oil_amt,0)) oil_amt,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(c.sun_amt,0)) sun_amt,  \n"+
         "      decode(a.bc_s_c,0,0,nvl(c.tint_amt,0)) tint_amt  \n"+
    	 " from \n"+
    	 "        -- 기본정보, \n"+
    	 "		     -- 기본식관리비(amt1), 일반식추가관리비(amt2), 기대마진(amt3), 재리스초기영업비용(amt4), 재리스중고차평가이익(amt5), \n"+
    	 "		     -- 기타수익(amt7), 일반식최소관리비용(amt10), 카드결재 cashback(amt6), 메이커추가탁송비용(amt13), \n"+
    	 "		     -- 견적미반영 서비스 품목(amt17), 기타비용(amt19), 정상D/C(amt22), 추가D/C(amt23), 잔가리스크감소효과(amt24), \n"+
    	 "		     -- 대차계약시 이전차 위약금 면제(amt25), 평가적용 위약금 면제금액(amt26), 승계수수료(amt27), 기타효율(amt29) \n"+
     	 "	       ( \n"+
         "        select e.rent_mng_id, e.rent_l_cd, a.car_gu, e.rent_st, e.rent_way, e.rent_start_dt, c.bc_s_g+nvl(c.driver_add_amt,0) AS bc_s_g, \n"+
         "               decode(nvl(e.ext_agnt,a.bus_id),'000037',a.mng_id, a.bus_id) bus_id, c.bus_agnt_id, b.car_cs_amt,\n"+
         "               c.bc_b_a as amt1, c.bc_b_b as amt2, \n"+
         "               case when nvl(c.bc_s_c, 0)=0 then 0 else \n"+
         "                    trunc( (  ( nvl(c.bc_s_c,0) * ( (nvl(c.bc_s_d,0)/100) - (nvl(c.bc_s_e,0)/100) ) ) - ( nvl(c.bc_s_g,0)+nvl(c.driver_add_amt,0) - nvl(e.fee_s_amt,0) ) )/ decode(c.bc_s_a, 0, 1, null, 1, c.bc_s_a) * 100000 + nvl(c.bc_s_f,0) ) \n"+
         "               end amt3, \n"+
         "               c.bc_b_d as amt4, \n"+
         "               case when nvl(e2.opt_chk, '0') = '1' then 0 else (nvl(c.bc_b_e1,0)/100 - 1 ) * nvl(c.bc_b_e2,0)  end amt5, \n"+
         "               trunc((decode(d.trf_st1,'2',nvl(d.trf_amt1,0),'3',nvl(d.trf_amt1,0),'7',nvl(d.trf_amt1,0),0)+ \n"+
         "                      decode(d.trf_st2,'2',nvl(d.trf_amt2,0),'3',nvl(d.trf_amt2,0),'7',nvl(d.trf_amt2,0),0)+ \n"+
         "                      decode(d.trf_st3,'2',nvl(d.trf_amt3,0),'3',nvl(d.trf_amt3,0),'7',nvl(d.trf_amt3,0),0)+ \n"+
         "                      decode(d.trf_st4,'2',nvl(d.trf_amt4,0),'3',nvl(d.trf_amt4,0),'7',nvl(d.trf_amt4,0),0)) \n"+
         "                      *nvl(c.bc_s_i,1.8375)/100 \n"+
         "               ,0) as amt6, \n"+
         "               c.bc_b_g as amt7, "+
//		 "	             c.bc_b_k as amt10, \n"+
		 "	             c.bc_b_b as amt10, \n"+
         "               decode(a.car_gu,'1',decode(e.rent_st,'1',trunc((nvl(b.sd_cs_amt, 0) + nvl(b.sd_cv_amt, 0) - nvl(c.bc_b_n,0))/1.1,0),0),0) amt13, \n"+
         "               decode(e.rent_st,'1',nvl(trunc(b.extra_amt/1.1,0), 0),0) amt17, \n"+
         "               nvl(c.bc_b_u,0) amt19, \n"+
//         "               decode(a.car_gu,'1',decode(e.rent_st,'1',trunc((decode(b.s_dc1_re,'판매자정상조건',nvl(b.s_dc1_amt,0),'추가탁송료D/C',nvl(b.s_dc1_amt,0),0)+ \n"+
//         "                                           decode(b.s_dc2_re,'판매자정상조건',nvl(b.s_dc2_amt,0),'추가탁송료D/C',nvl(b.s_dc2_amt,0),0)+ \n"+
//         "                                           decode(b.s_dc3_re,'판매자정상조건',nvl(b.s_dc3_amt,0),'추가탁송료D/C',nvl(b.s_dc3_amt,0),0)) \n"+
//         "                                           /1.1,0),0)) as amt22, \n"+
//         "               decode(a.car_gu,'1',decode(e.rent_st,'1',trunc((decode(b.s_dc1_re,'판매자정상조건',0,'추가탁송료D/C',0,nvl(b.s_dc1_amt,0))+ \n"+
//         "                                           decode(b.s_dc2_re,'판매자정상조건',0,'추가탁송료D/C',0,nvl(b.s_dc2_amt,0))+ \n"+
//         "                                           decode(b.s_dc3_re,'판매자정상조건',0,'추가탁송료D/C',0,nvl(b.s_dc3_amt,0))) \n"+
//         "                                           /1.1,0),0)) as amt23, \n"+
         "               trunc(nvl(c.bc_s_c,0) * (nvl(c.bc_s_e,0)/100) / decode(c.bc_s_a, 0, 1, null, 1, c.bc_s_a) * 100000,0) as amt24, \n"+
         "               nvl(c.cls_n_amt,0) amt25, \n"+
         "               decode(c.cls_n_amt,0,0,trunc(nvl(c.cls_n_amt,0) - ( ( e.fee_s_amt *  nvl(c.bc_s_b, 0) + e.pp_s_amt ) * 0.03 ),0)) as amt26,       \n"+
         "               nvl(f.rent_suc_commi,0) amt27, \n"+
         "               nvl(c.bc_b_ac,0) amt29 \n"+
         "        from   cont a,  fee_add e, fee_etc_add c, car_pur d, car_etc b, cont_etc f, \n"+
         "               (select rent_mng_id, rent_l_cd, emp_id from commi where AGNT_ST = '2' ) cm, fee e2, "+
		 "	             (select rent_mng_id, rent_l_cd, max(rent_st) rent_st from fee group by rent_mng_id,rent_l_cd) e3 \n"+
         "        where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and e.rent_st='"+rent_st+"' \n"+
         "               and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd \n"+
         "               and e.rent_mng_id=c.rent_mng_id(+) and e.rent_l_cd=c.rent_l_cd(+) and e.rent_st = c.rent_st(+) \n"+
         "               and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd \n"+
         "               and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd \n"+
         "               and a.rent_mng_id = f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+) \n"+
         "               and a.rent_mng_id = cm.rent_mng_id(+) and a.rent_l_cd=cm.rent_l_cd(+) \n"+
		 "               and e.rent_mng_id = e2.rent_mng_id and e.rent_l_cd = e2.rent_l_cd "+
		 "               and e.rent_mng_id = e3.rent_mng_id and e.rent_l_cd = e3.rent_l_cd "+
		 "	             and decode(e.rent_st,'t','1',e3.rent_st)=e2.rent_st"+  
         "      ) a, \n"+
    	 "		     -- 재리스수리비금액(amt11) \n"+
    	 "			   ( select e.rent_mng_id, e.rent_l_cd, e.rent_st, sum(b.tot_amt) amt11 \n"+
         "        from   cont a, service b, fee_add e \n"+
         "        where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and e.rent_st='"+rent_st+"' \n"+
         "               and a.car_mng_id=b.car_mng_id  \n"+
         "               and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
         "               and a.car_gu = '0' \n"+
         "               and b.serv_dt between to_char(to_date(e.rent_start_dt,'YYYYMMDD')-7,'YYYYMMDD') and to_char(add_months(to_date(e.rent_start_dt,'YYYYMMDD'),2),'YYYYMMDD') \n"+
         "               and b.serv_dt < e.rent_end_dt \n"+
         "        group by e.rent_mng_id, e.rent_l_cd, e.rent_st \n"+
         "      ) s, \n"+
    	 "	       -- 탁송료 : 차량인도 탁송료(amt14), 탁송 유류비 금액(amt18) \n"+
    	 "			   ( select e.rent_mng_id, e.rent_l_cd, e.rent_st, sum(b.tot_amt)-sum(b.oil_amt) amt14, sum(b.oil_amt) amt18 \n"+
         "        from   cont a, consignment b, fee_add e \n"+
         "        where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and e.rent_st='"+rent_st+"' \n"+
         "               and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"+
         "               and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
         "               and decode(e.rent_st,'t',decode(b.cons_cau,'1','',b.cons_cau),b.cons_cau) in ('1','3','8') \n"+
//         "               and e.rent_st='1' \n"+
         "        group by e.rent_mng_id, e.rent_l_cd, e.rent_st \n"+
         "      ) p, \n"+
    	 "	       -- 용품 : 썬팅비용(amt15), 지급용품(amt16) \n"+
    	 "			   ( select e.rent_mng_id, e.rent_l_cd, e.rent_st, sum(decode(a.car_gu,'1',decode(b.tint_amt,0,25000,nvl(b.tint_amt,25000)),0)) amt15, sum(decode(b.cleaner_amt,0,12500,nvl(b.cleaner_amt,12500))) amt16 \n"+
         "        from   cont a, tint b, fee_add e \n"+
         "        where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and e.rent_st='"+rent_st+"' \n"+
         "               and a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) \n"+
         "               and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd \n"+
         "               and e.rent_st='1' \n"+
         "        group by e.rent_mng_id, e.rent_l_cd, e.rent_st \n"+
         "      ) q, \n"+
         "      -- 렌트긴급출동보험가입비(amt33) \n"+
         "      ( select e.rent_mng_id, e.rent_l_cd, e.rent_st, \n"+
         "               sum(trunc(nvl(d.ch_amt,b.vins_spe_amt)/(to_date(b.ins_exp_dt,'YYYYMMDD')-to_date(nvl(d.ch_dt,b.ins_start_dt),'YYYYMMDD'))*365/12*(e.con_mon-nvl(c.cls_n_mon,0)),0)) amt33 \n"+
         "        from   cont a, fee_add e, fee_etc_add c, insur b, (select * from ins_change where ch_item='6' and ch_amt>0) d \n"+
         "        where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and a.car_st='1'\n"+
         "               and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd \n"+
         "               and e.rent_mng_id=c.rent_mng_id(+) and e.rent_l_cd=c.rent_l_cd(+) and e.rent_st = c.rent_st(+) \n"+
         "               and a.car_mng_id=b.car_mng_id \n"+
         "               and b.car_mng_id=d.car_mng_id(+) and b.ins_st=d.ins_st(+) \n"+
         "               and e.rent_st='1' \n"+
         "               and b.vins_spe_amt>0 \n"+
         "               and nvl(e.rent_start_dt,a.rent_start_dt) between b.ins_start_dt and b.ins_exp_dt \n"+
         "        group by e.rent_mng_id, e.rent_l_cd, e.rent_st \n"+
         "      ) i, \n"+
         "      -- 고객피보험자 (amt34) \n"+
         "      ( select e.rent_mng_id, e.rent_l_cd, e.rent_st, \n"+
         "               sum(trunc((b.rins_pcp_amt+b.vins_pcp_amt+b.vins_gcp_amt+b.vins_bacdt_amt+b.vins_canoisr_amt+b.vins_cacdt_cm_amt+b.vins_spe_amt)/12/c.bc_s_a*100000,0)) amt34 \n"+ 
         "        from   cont a, fee_add e, fee_etc_add c, insur b, cont_etc f, ins_cls g \n"+
         "        where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' \n"+
         "               and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd \n"+
         "               and e.rent_mng_id=c.rent_mng_id and e.rent_l_cd=c.rent_l_cd and e.rent_st = c.rent_st \n"+
         "               and a.car_mng_id=b.car_mng_id \n"+
 		 "          	 and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd \n"+
         "               and b.car_mng_id=g.car_mng_id(+) and b.ins_st=g.ins_st(+) \n"+
		 "               and decode(f.insur_per,'2','고객','아마존카')<>'아마존카' \n"+	
         "               and b.con_f_nm<>'아마존카' AND b.conr_nm='아마존카' \n"+
//       "               and nvl(e.rent_start_dt,a.rent_start_dt) between b.ins_start_dt and b.ins_exp_dt \n"+
		 "      	     and ( b.ins_start_dt between e.rent_start_dt and e.rent_end_dt or \n"+
         "                     to_char(to_date(nvl(g.req_dt,b.ins_exp_dt),'YYYYMMDD')-1,'YYYYMMDD') between e.rent_start_dt and e.rent_end_dt ) \n"+
         "        group by e.rent_mng_id, e.rent_l_cd, e.rent_st \n"+
         "      ) i2, \n"+
         "      --관리비용 \n"+
         "      ( select e.rent_mng_id, e.rent_l_cd, e.rent_st, \n"+
         "               sum(decode(b.gubun,'1',decode(b.c_st,'1',b.cost_amt,0),0)) cost_amt, \n"+
         "               sum(decode(b.gubun,'5',decode(b.c_st,'1',b.cost_amt,0),0)) oil_amt, \n"+
         "               sum(decode(b.gubun,'4',b.cost_amt,0)) sun_amt, \n"+
         "               sum(decode(b.gubun,'6',b.cost_amt,0)) tint_amt \n"+
         "        from   cont a, fee_add e, fee_etc_add c, cost_neom b \n"+
         "        where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and e.rent_st='"+rent_st+"'\n"+
         "               and a.rent_mng_id = e.rent_mng_id and a.rent_l_cd = e.rent_l_cd \n"+
         "               and e.rent_mng_id=c.rent_mng_id(+) and e.rent_l_cd=c.rent_l_cd(+) and e.rent_st = c.rent_st(+) \n"+
         "               and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd \n"+
         "               and nvl(e.ext_agnt,decode(a.bus_id,'000037',a.mng_id,a.bus_id))=b.cost_id \n"+
         "               and b.gubun in ('1','5','4','6') \n"+
         "               and b.cost_dt between nvl(e.rent_start_dt,a.rent_start_dt) and nvl(e.rent_end_dt,'99999999') \n"+
         "        group by e.rent_mng_id, e.rent_l_cd, e.rent_st \n"+
         "      ) c \n"+
    	 " where     a.rent_mng_id=s.rent_mng_id(+) and a.rent_l_cd=s.rent_l_cd(+) and a.rent_st=s.rent_st(+) \n"+
         "      and a.rent_mng_id=p.rent_mng_id(+) and a.rent_l_cd=p.rent_l_cd(+) and a.rent_st=p.rent_st(+) \n"+
         "      and a.rent_mng_id=q.rent_mng_id(+) and a.rent_l_cd=q.rent_l_cd(+) and a.rent_st=q.rent_st(+) \n"+
         "      and a.rent_mng_id=i.rent_mng_id(+) and a.rent_l_cd=i.rent_l_cd(+) and a.rent_st=i.rent_st(+) \n"+
         "      and a.rent_mng_id=i2.rent_mng_id(+) and a.rent_l_cd=i2.rent_l_cd(+) and a.rent_st=i2.rent_st(+) \n"+
         "      and a.rent_mng_id=c.rent_mng_id(+) and a.rent_l_cd=c.rent_l_cd(+) and a.rent_st=c.rent_st(+) \n"+
         " ";


		String query = " select a.*, f.rent_start_dt, u.user_nm, c.firm_nm, d.car_nm, d.car_no, "+
			           "        decode(b.car_gu, '0', '재리스', '1' ,'신차', '2', '중고차' ) car_gu_nm, fe.bus_agnt_id, u2.user_nm as bus_agnt_nm, \n"+
					   "        decode(a.cost_st,'3','해지','2','추가', '14', '월렌트',decode(a.rent_st, '1', decode(b.rent_st, '1', '신규', '3', '대차', '4', '증차' ), '연장')) rent_st_nm,  \n"+
					   "        decode(b.car_st, '1', '렌트', '2' ,'보유차', '3', '리스' ) car_st_nm, \n"+
			           "        decode(a.rent_way, '1', '일반식', '기본식') rent_way_nm, f.con_mon,  \n"+
					   "        decode(b.spr_kd, '0', '일반', '1', '우량', '2', '초우량', '3', '신설') spr_kd_nm, fe.bc_s_g+nvl(fe.driver_add_amt,0) AS bc_s_g, f.fee_s_amt, \n"+
//					   "        decode(a.rent_st, '1', decode(b.car_gu,'0','-', decode(cm.emp_id, null, '무', decode(cd.one_self,'Y','자체출고','영업사원출고') )), '-') commi2_nm,  \n"+
					   "        decode(a.rent_st, '1', decode(b.car_gu,'0','-', decode(cd.one_self,'Y','자체출고','영업사원출고') ), '-') commi2_nm,  \n"+
					   "        case when nvl(fe.bc_s_a, 0) = 0 then 0 else trunc( nvl(f.fee_s_amt,0) / decode(fe.bc_s_a, 0, 1, null, 1, fe.bc_s_a) * 100000 ) end af_amt, "+
			           "        (decode(cd.trf_st1,'2',nvl(cd.trf_amt1,0),'3',nvl(cd.trf_amt1,0),0)+decode(cd.trf_st2,'2',nvl(cd.trf_amt2,0),'3',nvl(cd.trf_amt2,0),0)+decode(cd.trf_st3,'2',nvl(cd.trf_amt3,0),'3',nvl(cd.trf_amt3,0),0)+decode(cd.trf_st4,'2',nvl(cd.trf_amt4,0),'3',nvl(cd.trf_amt4,0),0)) trf_amt \n"+
					   " from   ( select '"+cs_dt+"' cs_dt, '"+ce_dt+"' ce_dt, '1' cost_st, '2' gubun, \n"+
			           "                 rent_mng_id, rent_l_cd, rent_st, bus_id, rent_way, \n"+
              	       "                 amt1, amt2, amt3, amt4, amt5, \n"+
              	       "                 amt6, amt7, (amt1+amt2+amt3+amt4+amt5+amt6+amt7+amt34) amt8, 0 amt9, amt10, \n"+
              	       "                 amt11, trunc(amt11*"+second_per+"/100,0) amt12, amt13, (amt14+cost_amt) amt14, (amt15+sun_amt) amt15, \n"+
              	       "                 (amt16+tint_amt) amt16, amt17, (amt18+oil_amt) amt18, amt19, \n"+
                       "                 (amt10+amt11+amt13+amt14+cost_amt+amt15+sun_amt+amt16+tint_amt+amt17+amt18+oil_amt+amt19+amt33) amt20,  \n"+
              	       "                 (amt10+trunc(amt11*"+second_per+"/100,0)+amt13+amt14+cost_amt+amt15+sun_amt+amt16+tint_amt+amt17+amt18+oil_amt+amt19+amt33) amt21, \n"+
                       "                 amt22, amt23, amt24, amt25, \n"+
              	       "                 amt26, amt27, 0 amt28, amt29, \n"+
                       "                 (amt23+amt24-amt26+amt27+amt29) amt30, amt33, amt34 from ("+sub_query+") ) a, "+
					   "        cont b, fee_add f, fee_etc_add fe , car_etc ce, car_pur cd, users u, users u2, "+
			           "        (select rent_mng_id, rent_l_cd, emp_id from commi where AGNT_ST = '2' ) cm, client c, car_reg d \n"+
                       " where  "+
			           "            a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd  \n"+
					   "	    and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_st = f.rent_st  \n"+
					   "	    and a.rent_mng_id = fe.rent_mng_id(+) and a.rent_l_cd = fe.rent_l_cd(+) and a.rent_st = fe.rent_st(+)  \n"+
					   "	    and a.rent_mng_id = ce.rent_mng_id(+) and a.rent_l_cd = ce.rent_l_cd(+) \n"+
					   "	    and a.rent_mng_id = cd.rent_mng_id(+) and a.rent_l_cd = cd.rent_l_cd(+) \n"+
					   "        and a.bus_id = u.user_id and fe.bus_agnt_id = u2.user_id(+)\n"+
					   "	    and a.rent_mng_id = cm.rent_mng_id(+) and a.rent_l_cd = cm.rent_l_cd(+) \n"+
			           "        and b.client_id=c.client_id and b.car_mng_id=d.car_mng_id(+)"+
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
			System.out.println("[CostDatabase:getSaleCostCampaignAddCase_20090302(String rent_mng_id, String rent_l_cd, String rent_st)]"+e);
			System.out.println("[CostDatabase]"+query);
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

	/**
	 * 비용캠페인 : 고객지원팀 적용변수
	*/
	public Hashtable getCostCampaignVar2(String gubun){
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();

		String query =  " SELECT  *  FROM cost_campaign "+
		                " where (year||tm) in (select max(year||tm) from cost_campaign where gubun = '" + gubun + "') and gubun = '" + gubun + "'"; 
					
						

		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();

			
			ResultSetMetaData rsmd = rs.getMetaData();    	
			while(rs.next())
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
			System.out.println("[CostDatabase:getCostCampaignVar2()]"+e);
			System.out.println(query);
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

	  /**
     * 영업효율내역 조회
     */    

	public Vector getSaleCostCampaignMngList(String s_kd, String t_wd, String sort, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select a.CMP_DT,a.COST_ST,a.GUBUN,a.RENT_MNG_ID,a.RENT_L_CD,a.RENT_ST,a.BUS_ID,a.BUS_AGNT_ID,a.RENT_WAY,  \n"+
					   "       a.AMT1,a.AMT2,a.AMT3,a.AMT4,a.AMT5,a.AMT6,a.AMT7,a.AMT8,a.AMT9,a.AMT10, \n"+
					   "       a.AMT11,a.AMT12,a.AMT13,a.AMT14,a.AMT15,a.AMT16,a.AMT17,a.AMT18,a.AMT19,a.AMT20, \n"+
					   "       a.AMT21,a.AMT22,a.AMT23,a.AMT24,a.AMT25,a.AMT26, \n"+
					   "	   DECODE(a.cost_st,'5',DECODE(SIGN(TO_NUMBER(a.cmp_dt)-20160501),-1,a.amt27,a.amt27/5),a.amt27) AMT27, \n"+
			           "       a.AMT28,a.AMT29, \n"+
			           "       DECODE(a.cost_st,'5',DECODE(SIGN(TO_NUMBER(a.cmp_dt)-20160501),-1,a.amt30,a.amt30/5),a.amt30) AMT30, \n"+
					   "       a.AMT31,a.AMT33,a.AMT34, \n"+
			           "       DECODE(a.cost_st,'5',DECODE(SIGN(TO_NUMBER(a.cmp_dt)-20160501),-1,a.ea_amt,a.ea_amt/5),a.ea_amt) EA_AMT, \n"+
			           "       a.AF_AMT,a.BC_S_G,a.FEE_S_AMT,a.CON_MON,a.BC_S_C, \n"+
					   "       a.AMT35,a.AMT36,a.AMT37,a.CON_DAY,a.AMT38,a.AMT39,a.AMT40,a.AMT41,a.AMT42,a.CMP_EA_AMT,a.BUS_EMP_ID, \n"+
					   "       a.AMT43,a.AMT44,a.EA_PER,a.DC_PER,a.FEE_PER,a.AMT45,a.AMT46, \n"+
			           "        nvl(f2.rent_start_dt,f.rent_start_dt) rent_start_dt, f3.rent_st as max_rent_st, \n"+
			           "        nvl(f2.rent_dt,nvl(f.rent_dt,b.rent_dt)) rent_dt, cc.cls_dt, \n"+
					   "        u.user_nm, c.firm_nm, d.car_nm, d.car_no, \n"+
					   "        decode(a.cost_st,'1',decode(a.rent_st,'1',decode(b.car_gu,'1','신차','재리스'),'연장'), \n"+
					   "	                     '3',decode(cc.cls_st,'1','만기','중도')||'해지정산금발생', \n"+
					   "	                     '4',decode(cc.cls_st,'1','만기','중도')||'해지정산금수금', \n"+
					   "	                     '2','추가이용','6',decode(f3.rent_st,'1',decode(b.car_gu,'1','신차','재리스'),'연장')||'정산','5','계약승계', \n"+
					   "	                     '7',decode(f3.rent_st,'1',decode(b.car_gu,'1','신차','재리스'),'연장')||'정산반영값',\n"+
					   "	                     '8',decode(f3.rent_st,'1',decode(b.car_gu,'1','신차','재리스'),'연장')||'승계정산반영값', \n"+
					   "	                     '9','출고지연대차','10','재리스수리비추가분','11','해지정산경감원계약자','12','해지정산경감부담자') cmp_st_nm,  \n"+
					   "        decode(y.cls_st,'4','차종변경','5','계약승계') cng_st, \n"+
			           "        decode(b.car_gu, '0', '재리스', '1' ,'신차', '2', '중고차' ) car_gu_nm, \n"+
			           "        nvl(fe2.bus_agnt_id,fe.bus_agnt_id) bus_agnt_id, nvl(u3.user_nm,u2.user_nm) as bus_agnt_nm, \n"+
					   "        decode(a.rent_st, '1', decode(b.rent_st, '1', '신규', '3', '대차', '4', '증차' ), 'a','추가', 's','정산', 't','출고전대차', '연장') rent_st_nm,  \n"+
					   "        decode(b.car_st, '1', '렌트', '2' ,'보유차', '3', '리스' ) car_st_nm, \n"+
			           "        decode(a.rent_way, '1', '일반식', '기본식') rent_way_nm, \n"+
					   "        nvl(f2.con_mon,f.con_mon) con_mon,  \n"+
					   "        decode(b.spr_kd, '0', '일반', '1', '우량', '2', '초우량', '3', '신설') spr_kd_nm, \n"+
					   "        decode(decode(a.rent_st,'s',f3.rent_st,a.rent_st), '1', decode(b.car_gu,'0','-', decode(decode(d2.rent_l_cd,'',cd.one_self,d2.one_self),'Y','자체출고','영업사원출고') ), '-') commi2_nm,  \n"+
			           "        decode(decode(a.rent_st,'s',f3.rent_st,a.rent_st), '1', decode(b.car_gu,'0',0,  ( "+
					   "               decode(d2.rent_l_cd,'',	"+
					   "	                  decode(cd.trf_st1,'2',nvl(cd.trf_amt1,0),'3',nvl(cd.trf_amt1,0),0) + decode(cd.trf_st2,'2',nvl(cd.trf_amt2,0),'3',nvl(cd.trf_amt2,0),0) + decode(cd.trf_st3,'2',nvl(cd.trf_amt3,0),'3',nvl(cd.trf_amt3,0),0) + decode(cd.trf_st4,'2',nvl(cd.trf_amt4,0),'3',nvl(cd.trf_amt4,0),0), "+
					   "	                  decode(d2.trf_st1,'2',nvl(d2.trf_amt1,0),'3',nvl(d2.trf_amt1,0),0) + decode(d2.trf_st2,'2',nvl(d2.trf_amt2,0),'3',nvl(d2.trf_amt2,0),0) + decode(d2.trf_st3,'2',nvl(d2.trf_amt3,0),'3',nvl(d2.trf_amt3,0),0) + decode(d2.trf_st4,'2',nvl(d2.trf_amt4,0),'3',nvl(d2.trf_amt4,0),0)  "+
		               "        )))) trf_amt \n"+
					   " from   stat_bus_cost_cmp_base a, cont b, fee f, fee_etc fe , car_etc ce, car_pur cd, users u, users u2, \n"+
			           "        (select rent_mng_id, rent_l_cd, emp_id from commi where AGNT_ST = '2' ) cm, \n"+
					   " 	    client c, car_reg d, estimate em, cls_cont cc, cls_cont y, cont_etc ct, fee_add f2, fee_etc_add fe2, estimate em2, users u3, \n"+
					   "        (select rent_mng_id, rent_l_cd, max(rent_st) rent_st from fee group by rent_mng_id, rent_l_cd) f3, \n"+		
                       "        CAR_PUR d2 "+
                       " where  \n"+
			           "        a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd  \n"+
					   "	    and a.rent_mng_id = f.rent_mng_id(+) and a.rent_l_cd = f.rent_l_cd(+) and a.rent_st = f.rent_st(+) \n"+
					   "	    and a.rent_mng_id = fe.rent_mng_id(+) and a.rent_l_cd = fe.rent_l_cd(+) and a.rent_st = fe.rent_st(+)  \n"+
					   "	    and a.rent_mng_id = ce.rent_mng_id(+) and a.rent_l_cd = ce.rent_l_cd(+) \n"+
					   "	    and a.rent_mng_id = cd.rent_mng_id(+) and a.rent_l_cd = cd.rent_l_cd(+) \n"+
					   "        and a.bus_id = u.user_id \n"+
			           "        and fe.bus_agnt_id = u2.user_id(+)\n"+
					   "	    and a.rent_mng_id = cm.rent_mng_id(+) and a.rent_l_cd = cm.rent_l_cd(+) \n"+
			           "        and b.client_id = c.client_id and b.car_mng_id = d.car_mng_id(+) \n"+
					   "        and fe.bc_est_id = em.est_id(+) \n"+	
			           "        and a.rent_mng_id = cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+) \n"+
					   "        and b.rent_mng_id = y.rent_mng_id(+) and b.reg_dt=y.reg_dt(+) \n"+
			           "        and a.rent_mng_id = ct.rent_mng_id(+) and a.rent_l_cd=ct.rent_l_cd(+) \n"+
					   "	    and a.rent_mng_id = f2.rent_mng_id(+) and a.rent_l_cd = f2.rent_l_cd(+) and a.rent_st = f2.rent_st(+) \n"+
					   "	    and a.rent_mng_id = fe2.rent_mng_id(+) and a.rent_l_cd = fe2.rent_l_cd(+) and a.rent_st = fe2.rent_st(+)  \n"+
					   "        and fe2.bc_est_id = em2.est_id(+) \n"+	
			           "        and fe2.bus_agnt_id = u3.user_id(+)\n"+
					   "	    and a.rent_mng_id = f3.rent_mng_id(+) and a.rent_l_cd = f3.rent_l_cd(+) \n"+
					   "     	and nvl(f2.rent_start_dt,f.rent_start_dt) is not null  \n"+
                       "        AND ct.rent_suc_m_id=d2.rent_mng_id(+) AND ct.rent_suc_l_cd=d2.rent_l_cd(+) \n"+
//                       "        and a.cost_st not in ('7')"+
					   " ";

		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun1.equals("1")){
			dt1		= "substr(a.cmp_dt,1,6)";
			dt2		= "a.cmp_dt";
		}else if(gubun1.equals("2")){
			dt1		= "substr(decode(a.rent_st,'1',b.rent_dt,nvl(f2.rent_dt,f.rent_dt)),1,6)";
			dt2		= "decode(a.rent_st,'1',b.rent_dt,nvl(f2.rent_dt,f.rent_dt))";
		}else if(gubun1.equals("3")){
			dt1		= "substr(nvl(f2.rent_start_dt,f.rent_start_dt),1,6)";
			dt2		= "nvl(f2.rent_start_dt,f.rent_start_dt)";
		}else if(gubun1.equals("4")){
			dt1		= "substr(cc.cls_dt,1,6)";
			dt2		= "cc.cls_dt";
		}else if(gubun1.equals("21")){
			dt1		= "substr(decode(a.rent_st,'1',b.rent_dt,nvl(f2.rent_start_dt,f.rent_start_dt)),1,6)";
			dt2		= "decode(a.rent_st,'1',b.rent_dt,nvl(f2.rent_start_dt,f.rent_start_dt))";
		}else if(gubun1.equals("22")){
			dt1		= "substr(nvl(em2.update_dt,em.update_dt),1,6)";
			dt2		= "substr(nvl(em2.update_dt,em.update_dt),1,8)";
		}

		if(gubun2.equals("2"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' ";
		else if(gubun2.equals("6"))		query += " and "+dt2+" like to_char(add_months(sysdate,-1),'YYYYMM')||'%' ";
		else if(gubun2.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD') ";
		else if(gubun2.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun2.equals("5"))		query += " and "+dt2+" between replace('"+cs_dt+"', '-','') and replace('"+ce_dt+"', '-','') ";
		else if(gubun2.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}


		if(gubun3.equals("1"))	query += " and a.cost_st='1' and a.rent_st='1' and b.car_gu='1' \n";			//신차
		if(gubun3.equals("2"))	query += " and a.cost_st='1' and a.rent_st='1' and b.car_gu in ('0','2') \n";	//재리스
		if(gubun3.equals("3"))	query += " and a.cost_st='1' and a.rent_st<>'1' \n";							//연장
		if(gubun3.equals("12"))	query += " and a.cost_st='6' and f3.rent_st='1' and b.car_gu='1' \n";			//신차정산
		if(gubun3.equals("4"))	query += " and a.cost_st='6' and f3.rent_st='1' and b.car_gu in ('0','2') \n";	//재리스정산
		if(gubun3.equals("9"))	query += " and a.cost_st='6' and f3.rent_st<>'1' \n";							//연장정산
		if(gubun3.equals("5"))	query += " and a.cost_st='2' \n";												//추가이용
		if(gubun3.equals("6"))	query += " and a.cost_st='5' \n";												//계약승계수수료
		if(gubun3.equals("7"))	query += " and a.cost_st='3' and cc.cls_st='2' \n";								//중도해지정산금발생
		if(gubun3.equals("10"))	query += " and a.cost_st='3' and cc.cls_st='1' \n";								//만기해지정산금발생
		if(gubun3.equals("8"))	query += " and a.cost_st='4' and cc.cls_st='2' \n";								//중도해지정산금수금
		if(gubun3.equals("11"))	query += " and a.cost_st='4' and cc.cls_st='1' \n";								//만기해지정산금수금
//		if(gubun3.equals("8"))	query += " and a.cost_st='4' and a.rent_st='1' and b.car_gu='1'\n";				//신차위약금수금
//		if(gubun3.equals("10"))	query += " and a.cost_st='4' and a.rent_st='1' and b.car_gu in ('0','2') \n";	//재리스위약금수금
//		if(gubun3.equals("11"))	query += " and a.cost_st='4' and a.rent_st<>'1' \n";							//연장위약금수금
		if(gubun3.equals("13"))	query += " and a.cost_st='9' \n";												//출고지연대차
		if(gubun3.equals("14"))	query += " and a.cost_st='10' \n";												//재리스수리비추가분
		if(gubun3.equals("15"))	query += " and a.cost_st='11' \n";												//해지정산경감원계약자
		if(gubun3.equals("16"))	query += " and a.cost_st='12' \n";												//해지정산경감부담자
		if(gubun3.equals("17"))	query += " and a.cost_st='14' \n";												//월렌트

		if(gubun4.equals("1"))	query += " and b.car_st='1' \n";
		if(gubun4.equals("2"))	query += " and b.car_st='3' \n";

		if(gubun5.equals("1"))	query += " and a.rent_way='1' \n";
		if(gubun5.equals("2"))	query += " and a.rent_way in ('2','3') \n";

		if(gubun6.equals("1"))	query += " and u.use_yn='Y' and u.dept_id='0001' \n";
		if(gubun6.equals("2"))	query += " and u.use_yn='Y' and u.dept_id='0002' \n";
		if(gubun6.equals("3"))	query += " and u.use_yn='Y' and u.dept_id='0007' \n";
		if(gubun6.equals("4"))	query += " and u.use_yn='Y' and u.dept_id='0008' \n";
		if(gubun6.equals("5"))	query += " and u.use_yn='N' \n";

		if(s_kd.equals("1"))	what = "upper(nvl(c.firm_nm, ' '))";	
		if(s_kd.equals("2"))	what = "upper(nvl(d.car_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(d.car_no, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(u.user_nm, ' '))";
		if(s_kd.equals("5"))	what = "upper(nvl(nvl(u3.user_nm,u2.user_nm), ' '))";
		if(s_kd.equals("6"))	what = "upper(nvl(a.rent_l_cd, ' '))";
		if(s_kd.equals("7"))	what = "upper(nvl(fe.bc_b_u||fe.bc_b_u_cont, ' '))";
		if(s_kd.equals("8"))	what = "upper(nvl(fe.bc_b_g||fe.bc_b_g_cont, ' '))";
		if(s_kd.equals("9"))	what = "upper(nvl(fe.bc_b_ac||fe.bc_b_ac_cont, ' '))";
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%')  \n";
		}	

		if(sort.equals("1"))	query += " order by c.firm_nm";	
		if(sort.equals("2"))	query += " order by d.car_nm, decode(a.rent_st,'1',b.rent_dt,nvl(f2.rent_start_dt,f.rent_start_dt))";	
		if(sort.equals("3"))	query += " order by d.car_no";
		if(sort.equals("4"))	query += " order by u.user_nm, decode(a.rent_st,'1',b.rent_dt,nvl(f2.rent_start_dt,f.rent_start_dt))";
		if(sort.equals("5"))	query += " order by nvl(u3.user_nm,u2.user_nm), decode(a.rent_st,'1',b.rent_dt,nvl(f2.rent_start_dt,f.rent_start_dt))";	
		if(sort.equals("6"))	query += " order by to_number(a.cost_st), a.cmp_dt";	
		if(sort.equals("7"))	query += " order by to_number(a.cost_st), decode(f.rent_st,'1',1,2) desc, decode(nvl(b.car_gu,b.reg_id),'0','1','2','2','1','3'), b.rent_st desc, a.cmp_dt";

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
//			System.out.println("[CostDatabase:getSaleCostCampaignMngList()]"+query);
		} catch (SQLException e) {
			System.out.println("[CostDatabase:getSaleCostCampaignMngList()]"+e);
			System.out.println("[CostDatabase:getSaleCostCampaignMngList()]"+query);
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
     * 영업효율내역 조회 - 월렌트
     */    

	public Vector getSaleCostCampaignMngListRm(String s_kd, String t_wd, String sort, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();


		String query = " select a.*, \n"+
			           "        a.cmp_dt as rent_start_dt, a.rent_st as max_rent_st, "+
			           "        decode(a.rent_st,'1',b.rent_dt,fe.rent_dt) rent_dt, b.cls_dt, \n"+
					   "        u.user_nm, c.firm_nm, d.car_nm, d.car_no, \n"+
					   "        '월렌트' cmp_st_nm, \n"+
					   "        '' cng_st, \n"+
			           "        '월렌트' car_gu_nm, \n"+
			           "        '' bus_agnt_id, '' as bus_agnt_nm, \n"+
					   "        decode(a.rent_st,'1','신규','연장') rent_st_nm,  \n"+
					   "        '보유차' car_st_nm, \n"+
			           "        decode(a.rent_way, '1', '일반식', '기본식') rent_way_nm, \n"+
					   "        '' spr_kd_nm, \n"+
					   "        '' commi2_nm,  \n"+
			           "        '' trf_amt \n"+
					   " from   stat_bus_cost_cmp_base a, rent_cont b, rent_fee f, rent_cont_ext fe, users u, \n"+
					   " 	    client c, car_reg d, estimate_sh em \n"+
                       " where  \n"+
			           "        a.rent_mng_id = b.car_mng_id and a.rent_l_cd = b.rent_s_cd  \n"+
					   "	    and a.rent_l_cd = f.rent_s_cd \n"+
					   "	    and a.rent_l_cd = fe.rent_s_cd(+) and to_char(to_number(a.rent_st)-1,'09') = fe.seq(+) \n"+
					   "        and a.bus_id = u.user_id \n"+
			           "        and b.cust_id = c.client_id and b.car_mng_id = d.car_mng_id \n"+
					   "        and f.est_id = em.est_id \n"+	
					   " ";

		String what = "";
		String dt1 = "";
		String dt2 = "";

		if(gubun1.equals("1")){
			dt1		= "substr(a.cmp_dt,1,6)";
			dt2		= "a.cmp_dt";
		}else if(gubun1.equals("2")){
			dt1		= "substr(decode(a.rent_st,'1',b.rent_dt,fe.rent_dt),1,6)";
			dt2		= "decode(a.rent_st,'1',b.rent_dt,fe.rent_dt)";
		}else if(gubun1.equals("3")){
			dt1		= "substr(a.cmp_dt,1,6)";
			dt2		= "a.cmp_dt";
		}else if(gubun1.equals("4")){
			dt1		= "substr(b.cls_dt,1,6)";
			dt2		= "b.cls_dt";
		}else{
			dt1		= "substr(a.cmp_dt,1,6)";
			dt2		= "a.cmp_dt";
		}

		if(gubun2.equals("2"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' ";
		else if(gubun2.equals("6"))		query += " and "+dt2+" like to_char(add_months(sysdate,-1),'YYYYMM')||'%' ";
		else if(gubun2.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD') ";
		else if(gubun2.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun2.equals("5"))		query += " and "+dt2+" between replace('"+cs_dt+"', '-','') and replace('"+ce_dt+"', '-','') ";
		else if(gubun2.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}
	
		if(gubun4.equals("1"))	query += " and d.car_use='1' \n";
		if(gubun4.equals("2"))	query += " and b.car_use='2' \n";

		if(gubun5.equals("1"))	query += " and a.rent_way='1' \n";
		if(gubun5.equals("2"))	query += " and a.rent_way in ('2','3') \n";

		if(gubun6.equals("1"))	query += " and u.use_yn='Y' and u.dept_id='0001' \n";
		if(gubun6.equals("2"))	query += " and u.use_yn='Y' and u.dept_id='0002' \n";
		if(gubun6.equals("3"))	query += " and u.use_yn='Y' and u.dept_id='0007' \n";
		if(gubun6.equals("4"))	query += " and u.use_yn='Y' and u.dept_id='0008' \n";
		if(gubun6.equals("5"))	query += " and u.use_yn='N' \n";

		if(s_kd.equals("1"))	what = "upper(nvl(c.firm_nm, ' '))";	
		if(s_kd.equals("2"))	what = "upper(nvl(d.car_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(d.car_no, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(u.user_nm, ' '))";
		if(s_kd.equals("6"))	what = "upper(nvl(a.rent_l_cd, ' '))";
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%')  \n";
		}	

		if(sort.equals("1"))	query += " order by c.firm_nm";	
		if(sort.equals("2"))	query += " order by d.car_nm, a.cmp_dt";	
		if(sort.equals("3"))	query += " order by d.car_no";
		if(sort.equals("4"))	query += " order by u.user_nm, a.cmp_dt";
		if(sort.equals("5"))	query += " order by u.user_nm, a.cmp_dt";	
		if(sort.equals("6"))	query += " order by to_number(a.cost_st), a.cmp_dt";	
		if(sort.equals("7"))	query += " order by to_number(a.cost_st), decode(a.rent_st,'1',1,2) desc, a.cmp_dt";

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
//			System.out.println("[CostDatabase:getSaleCostCampaignMngListRm()]"+query);
		} catch (SQLException e) {
			System.out.println("[CostDatabase:getSaleCostCampaignMngListRm()]"+e);
			System.out.println("[CostDatabase:getSaleCostCampaignMngListRm()]"+query);
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
     * 영업효율내역 조회
     */    

	public Vector getSaleCostCampaignMngListSub(String rent_l_cd, String max_rent_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();


		String query = " select a.*, \n"+
			           "        nvl(f2.rent_start_dt,f.rent_start_dt) rent_start_dt, "+
			           "        nvl(f2.rent_dt,nvl(f.rent_dt,b.rent_dt)) rent_dt, cc.cls_dt, \n"+
					   "        u.user_nm, c.firm_nm, d.car_nm, d.car_no, \n"+
					   "        decode(a.cost_st,'1','신차/재리스/연장','3','신차미수령위약금','4','실수령위약금','2','추가이용','6','재리스/연장정산','5','계약승계','7','재리스/연장정산반영값') cmp_st_nm,  \n"+
					   "        decode(y.cls_st,'4','차종변경','5','계약승계') cng_st, \n"+
			           "        decode(b.car_gu, '0', '재리스', '1' ,'신차', '2', '중고차' ) car_gu_nm, \n"+
			           "        nvl(fe2.bus_agnt_id,fe.bus_agnt_id) bus_agnt_id, nvl(u3.user_nm,u2.user_nm) as bus_agnt_nm, \n"+
					   "        decode(a.rent_st, '1', decode(b.rent_st, '1', '신규', '3', '대차', '4', '증차' ), '연장') rent_st_nm,  \n"+
					   "        decode(b.car_st, '1', '렌트', '2' ,'보유차', '3', '리스' ) car_st_nm, \n"+
			           "        decode(a.rent_way, '1', '일반식', '기본식') rent_way_nm, \n"+
					   "        nvl(f2.con_mon,f.con_mon) con_mon,  \n"+
					   "        decode(b.spr_kd, '0', '일반', '1', '우량', '2', '초우량', '3', '신설') spr_kd_nm, \n"+
					   "        decode(a.rent_st, '1', decode(b.car_gu,'0','-', decode(cd.one_self,'Y','자체출고','영업사원출고') ), '-') commi2_nm,  \n"+
			           "        decode(a.rent_st, '1', decode(b.car_gu,'0',0,  (decode(cd.trf_st1,'2',nvl(cd.trf_amt1,0),'3',nvl(cd.trf_amt1,0),0)+decode(cd.trf_st2,'2',nvl(cd.trf_amt2,0),'3',nvl(cd.trf_amt2,0),0)+decode(cd.trf_st3,'2',nvl(cd.trf_amt3,0),'3',nvl(cd.trf_amt3,0),0)+decode(cd.trf_st4,'2',nvl(cd.trf_amt4,0),'3',nvl(cd.trf_amt4,0),0)))) trf_amt \n"+
					   " from   stat_bus_cost_cmp_base a, cont b, fee f, fee_etc fe , car_etc ce, car_pur cd, users u, users u2, \n"+
			           "        (select rent_mng_id, rent_l_cd, emp_id from commi where AGNT_ST = '2' ) cm, \n"+
					   " 	    client c, car_reg d, estimate em, cls_cont cc, cls_cont y, cont_etc ct, fee_add f2, fee_etc_add fe2, estimate em2, users u3, \n"+
					   "        (select rent_mng_id, rent_l_cd, max(rent_st) rent_st from fee group by rent_mng_id, rent_l_cd) f3 \n"+		
                       " where  \n"+
			           "        a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd  \n"+
					   "	    and a.rent_mng_id = f.rent_mng_id(+) and a.rent_l_cd = f.rent_l_cd(+) and a.rent_st = f.rent_st(+) \n"+
					   "	    and a.rent_mng_id = fe.rent_mng_id(+) and a.rent_l_cd = fe.rent_l_cd(+) and a.rent_st = fe.rent_st(+)  \n"+
					   "	    and a.rent_mng_id = ce.rent_mng_id(+) and a.rent_l_cd = ce.rent_l_cd(+) \n"+
					   "	    and a.rent_mng_id = cd.rent_mng_id(+) and a.rent_l_cd = cd.rent_l_cd(+) \n"+
					   "        and a.bus_id = u.user_id \n"+
			           "        and fe.bus_agnt_id = u2.user_id(+)\n"+
					   "	    and a.rent_mng_id = cm.rent_mng_id(+) and a.rent_l_cd = cm.rent_l_cd(+) \n"+
			           "        and b.client_id = c.client_id and b.car_mng_id = d.car_mng_id \n"+
					   "        and fe.bc_est_id = em.est_id(+) \n"+	
			           "        and a.rent_mng_id = cc.rent_mng_id(+) and a.rent_l_cd=cc.rent_l_cd(+) \n"+
					   "        and b.rent_mng_id = y.rent_mng_id(+) and b.reg_dt=y.reg_dt(+) \n"+
			           "        and a.rent_mng_id = ct.rent_mng_id(+) and a.rent_l_cd=ct.rent_l_cd(+) \n"+
					   "	    and a.rent_mng_id = f2.rent_mng_id(+) and a.rent_l_cd = f2.rent_l_cd(+) and a.rent_st = f2.rent_st(+) \n"+
					   "	    and a.rent_mng_id = fe2.rent_mng_id(+) and a.rent_l_cd = fe2.rent_l_cd(+) and a.rent_st = fe2.rent_st(+)  \n"+
					   "        and fe2.bc_est_id = em2.est_id(+) \n"+	
			           "        and fe2.bus_agnt_id = u3.user_id(+)\n"+
					   "	    and a.rent_mng_id = f3.rent_mng_id(+) and a.rent_l_cd = f3.rent_l_cd(+) \n"+
					   "     	and nvl(f2.rent_start_dt,f.rent_start_dt) is not null  \n"+
                       "        and a.rent_l_cd='"+rent_l_cd+"'"+
					   "        and (a.cost_st='7' or (a.cost_st='1' and a.rent_st='"+max_rent_st+"'))"+ 	
					   " order by a.cost_st";


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
			System.out.println("[CostDatabase:getSaleCostCampaignMngListSub()]"+e);
			System.out.println("[CostDatabase]"+query);
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
	 * 결과 :마감테이블 조회 - 사원별
	*/
	public Vector getSaleCostCampaignUserStatList(String s_kd, String t_wd, String sort, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();


		
		String query = " select b.user_nm, \n"+
					   "        decode(max(b.use_yn),'Y',decode(max(b.dept_id),'0001','영업팀','0002','고객지원팀','0007','부산지점','0008','대전지점','0009','강남지점','0010','광주지점','0011','대구지점'),'퇴사자') dept_nm, \n"+
					   "        max   (b.enter_dt) enter_dt,"+

					   "        count (decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,'',a.rent_l_cd))) RENT_WAY_1_CNT, \n"+		//영업대수
					   "        count (a.rent_l_cd) RENT_WAY_2_CNT, \n"+										//발생건수
					   "        nvl(sum   (a.con_mon),0) CON_MON, \n"+													//총개월수

					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt1  ),a.amt1 )),0) amt1 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt2  ),a.amt2 )),0) amt2 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt3  ),a.amt3 )),0) amt3 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt4  ),a.amt4 )),0) amt4 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt5  ),a.amt5 )),0) amt5 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt6  ),a.amt6 )),0) amt6 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt7  ),a.amt7 )),0) amt7 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt8  ),a.amt8 )),0) amt8 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt9  ),a.amt9 )),0) amt9 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt10 ),a.amt10)),0) amt10, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt11 ),a.amt11)),0) amt11, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt12 ),a.amt12)),0) amt12, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt13 ),a.amt13)),0) amt13, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt14 ),a.amt14)),0) amt14, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt15 ),a.amt15)),0) amt15, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt16 ),a.amt16)),0) amt16, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt17 ),a.amt17)),0) amt17, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt18 ),a.amt18)),0) amt18, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt19 ),a.amt19)),0) amt19, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt20 ),a.amt20)),0) amt20, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt21 ),a.amt21)),0) amt21, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt22 ),a.amt22)),0) amt22, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt23 ),a.amt23)),0) amt23, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt24 ),a.amt24)),0) amt24, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt25 ),a.amt25)),0) amt25, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt26 ),a.amt26)),0) amt26, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt27 ),a.amt27)),0) amt27, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt28 ),a.amt28)),0) amt28, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt29 ),a.amt29)),0) amt29, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt30 ),a.amt30)),0) amt30, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt31 ),a.amt31)),0) amt31, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt33 ),a.amt33)),0) amt33, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt34 ),a.amt34)),0) amt34, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt35 ),a.amt35)),0) amt35, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt36 ),a.amt36)),0) amt36, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt39 ),a.amt39)),0) amt39, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.amt40 ),a.amt40)),0) amt40, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.af_amt),a.af_amt)),0) af_amt, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.bc_s_g),a.bc_s_g)),0) bc_s_g, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(f.con_mon-6),-1,0,a.fee_s_amt),a.fee_s_amt)),0) fee_s_amt, \n"+
                       
					   //신차 
					   "        count (decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,'',a.rent_l_cd))) RENT_WAY_1_CNT_1, \n"+		//영업대수
					   "        count (decode(a.cost_st||c.car_gu||f.rent_st,'111',a.rent_l_cd)) RENT_WAY_2_CNT_1, \n"+										//발생건수
					   "        nvl(sum   (decode(a.cost_st||c.car_gu||f.rent_st,'111',a.con_mon)),0) CON_MON_1, \n"+													//총개월수

					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt1  ))),0) amt1_1 , \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt2  ))),0) amt2_1 , \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt3  ))),0) amt3_1 , \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt4  ))),0) amt4_1 , \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt5  ))),0) amt5_1 , \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt6  ))),0) amt6_1 , \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt7  ))),0) amt7_1 , \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt8  ))),0) amt8_1 , \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt9  ))),0) amt9_1 , \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt10 ))),0) amt10_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt11 ))),0) amt11_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt12 ))),0) amt12_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt13 ))),0) amt13_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt14 ))),0) amt14_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt15 ))),0) amt15_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt16 ))),0) amt16_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt17 ))),0) amt17_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt18 ))),0) amt18_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt19 ))),0) amt19_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt20 ))),0) amt20_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt21 ))),0) amt21_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt22 ))),0) amt22_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt23 ))),0) amt23_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt24 ))),0) amt24_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt25 ))),0) amt25_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt26 ))),0) amt26_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt27 ))),0) amt27_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt28 ))),0) amt28_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt29 ))),0) amt29_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt30 ))),0) amt30_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt31 ))),0) amt31_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt33 ))),0) amt33_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt34 ))),0) amt34_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt35 ))),0) amt35_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt36 ))),0) amt36_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt39 ))),0) amt39_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.amt40 ))),0) amt40_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.af_amt))),0) af_amt_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.bc_s_g))),0) bc_s_g_1, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'111',decode(sign(f.con_mon-6),-1,0,a.fee_s_amt))),0) fee_s_amt_1, \n"+

					   //재리스
					   "        count (decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,'',a.rent_l_cd))) RENT_WAY_1_CNT_2, \n"+		//영업대수
					   "        count (decode(a.cost_st||c.car_gu||f.rent_st,'101',a.rent_l_cd)) RENT_WAY_2_CNT_2, \n"+										//발생건수
					   "        nvl(sum   (decode(a.cost_st||c.car_gu||f.rent_st,'101',a.con_mon)),0) CON_MON_2, \n"+													//총개월수

					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt1  ))),0) amt1_2 , \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt2  ))),0) amt2_2 , \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt3  ))),0) amt3_2 , \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt4  ))),0) amt4_2 , \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt5  ))),0) amt5_2 , \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt6  ))),0) amt6_2 , \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt7  ))),0) amt7_2 , \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt8  ))),0) amt8_2 , \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt9  ))),0) amt9_2 , \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt10 ))),0) amt10_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt11 ))),0) amt11_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt12 ))),0) amt12_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt13 ))),0) amt13_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt14 ))),0) amt14_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt15 ))),0) amt15_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt16 ))),0) amt16_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt17 ))),0) amt17_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt18 ))),0) amt18_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt19 ))),0) amt19_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt20 ))),0) amt20_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt21 ))),0) amt21_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt22 ))),0) amt22_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt23 ))),0) amt23_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt24 ))),0) amt24_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt25 ))),0) amt25_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt26 ))),0) amt26_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt27 ))),0) amt27_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt28 ))),0) amt28_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt29 ))),0) amt29_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt30 ))),0) amt30_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt31 ))),0) amt31_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt33 ))),0) amt33_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt34 ))),0) amt34_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt35 ))),0) amt35_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt36 ))),0) amt36_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt39 ))),0) amt39_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.amt40 ))),0) amt40_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.af_amt))),0) af_amt_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.bc_s_g))),0) bc_s_g_2, \n"+
					   "        nvl(sum(decode(a.cost_st||c.car_gu||f.rent_st,'101',decode(sign(f.con_mon-6),-1,0,a.fee_s_amt))),0) fee_s_amt_2, \n"+

					   //연장
					   "        count  (decode(a.cost_st,'1',decode(f.rent_st,'1','',decode(sign(f.con_mon-6),-1,'',a.rent_l_cd)))) RENT_WAY_1_CNT_3, \n"+		//영업대수
					   "        count  (decode(a.cost_st,'1',decode(f.rent_st,'1','',a.rent_l_cd))) RENT_WAY_2_CNT_3, \n"+											//발생건수
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,a.con_mon))),0) CON_MON_3, \n"+													//총개월수

					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt1  )))),0) amt1_3 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt2  )))),0) amt2_3 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt3  )))),0) amt3_3 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt4  )))),0) amt4_3 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt5  )))),0) amt5_3 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt6  )))),0) amt6_3 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt7  )))),0) amt7_3 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt8  )))),0) amt8_3 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt9  )))),0) amt9_3 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt10 )))),0) amt10_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt11 )))),0) amt11_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt12 )))),0) amt12_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt13 )))),0) amt13_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt14 )))),0) amt14_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt15 )))),0) amt15_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt16 )))),0) amt16_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt17 )))),0) amt17_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt18 )))),0) amt18_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt19 )))),0) amt19_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt20 )))),0) amt20_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt21 )))),0) amt21_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt22 )))),0) amt22_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt23 )))),0) amt23_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt24 )))),0) amt24_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt25 )))),0) amt25_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt26 )))),0) amt26_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt27 )))),0) amt27_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt28 )))),0) amt28_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt29 )))),0) amt29_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt30 )))),0) amt30_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt31 )))),0) amt31_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt33 )))),0) amt33_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt34 )))),0) amt34_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt35 )))),0) amt35_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt36 )))),0) amt36_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt39 )))),0) amt39_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.amt40 )))),0) amt40_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.af_amt)))),0) af_amt_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.bc_s_g)))),0) bc_s_g_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(f.rent_st,'1',0,decode(sign(f.con_mon-6),-1,0,a.fee_s_amt)))),0) fee_s_amt_3, \n"+

					   //기타
					   "        0 RENT_WAY_1_CNT_4, \n"+												//영업대수
					   "        count (decode(a.cost_st,'1','',a.rent_l_cd)) RENT_WAY_2_CNT_4, \n"+		//발생건수
					   "        0 CON_MON_4, \n"+														//총개월수

					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt1  )),0) amt1_4 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt2  )),0) amt2_4 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt3  )),0) amt3_4 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt4  )),0) amt4_4 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt5  )),0) amt5_4 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt6  )),0) amt6_4 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt7  )),0) amt7_4 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt8  )),0) amt8_4 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt9  )),0) amt9_4 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt10 )),0) amt10_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt11 )),0) amt11_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt12 )),0) amt12_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt13 )),0) amt13_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt14 )),0) amt14_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt15 )),0) amt15_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt16 )),0) amt16_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt17 )),0) amt17_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt18 )),0) amt18_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt19 )),0) amt19_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt20 )),0) amt20_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt21 )),0) amt21_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt22 )),0) amt22_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt23 )),0) amt23_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt24 )),0) amt24_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt25 )),0) amt25_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt26 )),0) amt26_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt27 )),0) amt27_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt28 )),0) amt28_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt29 )),0) amt29_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt30 )),0) amt30_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt31 )),0) amt31_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt33 )),0) amt33_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt34 )),0) amt34_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt35 )),0) amt35_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt36 )),0) amt36_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt39 )),0) amt39_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt40 )),0) amt40_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.af_amt)),0) af_amt_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.bc_s_g)),0) bc_s_g_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.fee_s_amt)),0) fee_s_amt_4 \n"+
 
					   " from   stat_bus_cost_cmp_base a, users b, cont c, fee f, fee_etc fe, estimate em, fee_add f2, fee_etc_add fe2, estimate em2 \n"+
					   " where  a.gubun = '2' and a.cost_st not in ('6') \n"+
					   "        and a.bus_id=b.user_id \n"+
			           "        and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd  \n"+
					   "	    and a.rent_mng_id = f.rent_mng_id(+) and a.rent_l_cd = f.rent_l_cd(+) and a.rent_st = f.rent_st(+)  \n"+
					   "	    and a.rent_mng_id = fe.rent_mng_id(+) and a.rent_l_cd = fe.rent_l_cd(+) and a.rent_st = fe.rent_st(+)  \n"+
					   "        and fe.bc_est_id = em.est_id(+) \n"+
					   "	    and a.rent_mng_id = f2.rent_mng_id(+) and a.rent_l_cd = f2.rent_l_cd(+) and a.rent_st = f2.rent_st(+)  \n"+
					   "	    and a.rent_mng_id = fe2.rent_mng_id(+) and a.rent_l_cd = fe2.rent_l_cd(+) and a.rent_st = fe2.rent_st(+)  \n"+
					   "        and fe2.bc_est_id = em2.est_id(+) \n"+
					   " ";

		String dt1 = "";
		String dt2 = "";

		if(gubun1.equals("1")){
			dt1		= "substr(a.cmp_dt,1,6)";
			dt2		= "a.cmp_dt";
		}else if(gubun1.equals("2")){
			dt1		= "substr(decode(a.rent_st,'1',b.rent_dt,f.rent_dt),1,6)";
			dt2		= "decode(a.rent_st,'1',b.rent_dt,f.rent_dt)";
		}else if(gubun1.equals("3")){
			dt1		= "substr(f.rent_start_dt,1,6)";
			dt2		= "f.rent_start_dt";
		}else if(gubun1.equals("4")){
			dt1		= "substr(cc.cls_dt,1,6)";
			dt2		= "cc.cls_dt";
		}else if(gubun1.equals("21")){
			dt1		= "substr(decode(a.rent_st,'1',b.rent_dt,f.rent_start_dt),1,6)";
			dt2		= "decode(a.rent_st,'1',b.rent_dt,f.rent_start_dt)";
		}else if(gubun1.equals("22")){
			dt1		= "substr(em.update_dt,1,6)";
			dt2		= "substr(em.update_dt,1,8)";
		}


		if(gubun2.equals("2"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("6"))		query += " and "+dt2+" like to_char(add_months(sysdate,-1),'YYYYMM')||'%'";
		else if(gubun2.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun2.equals("5"))		query += " and "+dt2+" between replace('"+cs_dt+"', '-','') and replace('"+ce_dt+"', '-','')";
		else if(gubun2.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		query +=       " group by b.user_nm \n"+
                       " order by max(b.use_yn) desc, max(b.dept_id), (sum(a.amt8)-sum(a.amt21)+sum(a.amt30)) desc \n"+
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
			System.out.println("[CostDatabase:getSaleCostCampaignUserStatList()]"+e);
			System.out.println("[CostDatabase:getSaleCostCampaignUserStatList()]"+query);
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
	 * 결과 :마감테이블 조회 - 사원별
	*/
	public Vector getSaleCostCampaignUserStatListRm(String s_kd, String t_wd, String sort, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();


		String dt_query = "";
		String dt1 = "";
		String dt2 = "";

		dt1		= "substr(a.cmp_dt,1,6)";
		dt2		= "a.cmp_dt";

		if(gubun2.equals("2"))			dt_query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("6"))		dt_query += " and "+dt2+" like to_char(add_months(sysdate,-1),'YYYYMM')||'%'";
		else if(gubun2.equals("1"))		dt_query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("4"))		dt_query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun2.equals("5"))		dt_query += " and "+dt2+" between replace('"+cs_dt+"', '-','') and replace('"+ce_dt+"', '-','')";
		else if(gubun2.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	dt_query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) dt_query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}
		

		String query = " select b.user_nm, \n"+
					   "        decode(max(b.use_yn),'Y',decode(max(b.dept_id),'0001','영업팀','0002','고객지원팀','0007','부산지점','0008','대전지점','0009','강남지점','0010','광주지점','0011','대구지점','0012','인천지점','0013','수원지점','0014','강서지점','0015','구로지점','0016','울산지점','1000','에이전트','0017','광화문지점','0018','송파지점'),'퇴사자') dept_nm, \n"+
					   "        max   (b.enter_dt) enter_dt,"+

					   "        count (decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,'',a.rent_l_cd))) RENT_WAY_1_CNT, \n"+		//영업대수
					   "        count (a.rent_l_cd) RENT_WAY_2_CNT, \n"+										//발생건수
					   "        nvl(sum   (a.con_mon),0) CON_MON, \n"+													//총개월수

					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt1  ),a.amt1 )),0) amt1 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt2  ),a.amt2 )),0) amt2 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt3  ),a.amt3 )),0) amt3 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt4  ),a.amt4 )),0) amt4 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt5  ),a.amt5 )),0) amt5 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt6  ),a.amt6 )),0) amt6 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt7  ),a.amt7 )),0) amt7 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt8  ),a.amt8 )),0) amt8 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt9  ),a.amt9 )),0) amt9 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt10 ),a.amt10)),0) amt10, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt11 ),a.amt11)),0) amt11, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt12 ),a.amt12)),0) amt12, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt13 ),a.amt13)),0) amt13, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt14 ),a.amt14)),0) amt14, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt15 ),a.amt15)),0) amt15, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt16 ),a.amt16)),0) amt16, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt17 ),a.amt17)),0) amt17, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt18 ),a.amt18)),0) amt18, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt19 ),a.amt19)),0) amt19, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt20 ),a.amt20)),0) amt20, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt21 ),a.amt21)),0) amt21, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt22 ),a.amt22)),0) amt22, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt23 ),a.amt23)),0) amt23, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt24 ),a.amt24)),0) amt24, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt25 ),a.amt25)),0) amt25, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt26 ),a.amt26)),0) amt26, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt27 ),a.amt27)),0) amt27, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt28 ),a.amt28)),0) amt28, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt29 ),a.amt29)),0) amt29, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt30 ),a.amt30)),0) amt30, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt31 ),a.amt31)),0) amt31, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt33 ),a.amt33)),0) amt33, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt34 ),a.amt34)),0) amt34, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt35 ),a.amt35)),0) amt35, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt36 ),a.amt36)),0) amt36, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt39 ),a.amt39)),0) amt39, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt40 ),a.amt40)),0) amt40, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt43 ),a.amt43)),0) amt43, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt44 ),a.amt44)),0) amt44, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt45 ),a.amt45)),0) amt45, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.amt46 ),a.amt46)),0) amt46, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.af_amt),a.af_amt)),0) af_amt, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.bc_s_g),a.bc_s_g)),0) bc_s_g, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(sign(a.fee_con_mon-6),-1,0,a.fee_s_amt),a.fee_s_amt)),0) fee_s_amt, \n"+
                       
					   //신차 
					   "        count (decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,'',a.rent_l_cd))) RENT_WAY_1_CNT_1, \n"+		//영업대수
					   "        count (decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',a.rent_l_cd)) RENT_WAY_2_CNT_1, \n"+										//발생건수
					   "        nvl(sum   (decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',a.con_mon)),0) CON_MON_1, \n"+													//총개월수

					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt1  ))),0) amt1_1 , \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt2  ))),0) amt2_1 , \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt3  ))),0) amt3_1 , \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt4  ))),0) amt4_1 , \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt5  ))),0) amt5_1 , \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt6  ))),0) amt6_1 , \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt7  ))),0) amt7_1 , \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt8  ))),0) amt8_1 , \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt9  ))),0) amt9_1 , \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt10 ))),0) amt10_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt11 ))),0) amt11_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt12 ))),0) amt12_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt13 ))),0) amt13_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt14 ))),0) amt14_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt15 ))),0) amt15_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt16 ))),0) amt16_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt17 ))),0) amt17_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt18 ))),0) amt18_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt19 ))),0) amt19_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt20 ))),0) amt20_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt21 ))),0) amt21_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt22 ))),0) amt22_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt23 ))),0) amt23_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt24 ))),0) amt24_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt25 ))),0) amt25_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt26 ))),0) amt26_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt27 ))),0) amt27_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt28 ))),0) amt28_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt29 ))),0) amt29_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt30 ))),0) amt30_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt31 ))),0) amt31_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt33 ))),0) amt33_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt34 ))),0) amt34_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt35 ))),0) amt35_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt36 ))),0) amt36_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt39 ))),0) amt39_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt40 ))),0) amt40_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt43 ))),0) amt43_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt44 ))),0) amt44_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt45 ))),0) amt45_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.amt46 ))),0) amt46_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.af_amt))),0) af_amt_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.bc_s_g))),0) bc_s_g_1, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'111',decode(sign(a.fee_con_mon-6),-1,0,a.fee_s_amt))),0) fee_s_amt_1, \n"+

					   //재리스
					   "        count (decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,'',a.rent_l_cd))) RENT_WAY_1_CNT_2, \n"+		//영업대수
					   "        count (decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',a.rent_l_cd)) RENT_WAY_2_CNT_2, \n"+										//발생건수
					   "        nvl(sum   (decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',a.con_mon)),0) CON_MON_2, \n"+													//총개월수

					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt1  ))),0) amt1_2 , \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt2  ))),0) amt2_2 , \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt3  ))),0) amt3_2 , \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt4  ))),0) amt4_2 , \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt5  ))),0) amt5_2 , \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt6  ))),0) amt6_2 , \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt7  ))),0) amt7_2 , \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt8  ))),0) amt8_2 , \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt9  ))),0) amt9_2 , \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt10 ))),0) amt10_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt11 ))),0) amt11_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt12 ))),0) amt12_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt13 ))),0) amt13_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt14 ))),0) amt14_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt15 ))),0) amt15_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt16 ))),0) amt16_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt17 ))),0) amt17_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt18 ))),0) amt18_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt19 ))),0) amt19_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt20 ))),0) amt20_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt21 ))),0) amt21_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt22 ))),0) amt22_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt23 ))),0) amt23_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt24 ))),0) amt24_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt25 ))),0) amt25_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt26 ))),0) amt26_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt27 ))),0) amt27_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt28 ))),0) amt28_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt29 ))),0) amt29_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt30 ))),0) amt30_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt31 ))),0) amt31_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt33 ))),0) amt33_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt34 ))),0) amt34_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt35 ))),0) amt35_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt36 ))),0) amt36_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt39 ))),0) amt39_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt40 ))),0) amt40_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt43 ))),0) amt43_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt44 ))),0) amt44_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt45 ))),0) amt45_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.amt46 ))),0) amt46_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.af_amt))),0) af_amt_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.bc_s_g))),0) bc_s_g_2, \n"+
					   "        nvl(sum(decode(a.cost_st||a.car_gu||a.fee_rent_st,'101',decode(sign(a.fee_con_mon-6),-1,0,a.fee_s_amt))),0) fee_s_amt_2, \n"+

					   //연장
					   "        count  (decode(a.cost_st,'1',decode(a.fee_rent_st,'1','',decode(sign(a.fee_con_mon-6),-1,'',a.rent_l_cd)))) RENT_WAY_1_CNT_3, \n"+		//영업대수
					   "        count  (decode(a.cost_st,'1',decode(a.fee_rent_st,'1','',a.rent_l_cd))) RENT_WAY_2_CNT_3, \n"+											//발생건수
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,a.con_mon))),0) CON_MON_3, \n"+													//총개월수

					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt1  )))),0) amt1_3 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt2  )))),0) amt2_3 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt3  )))),0) amt3_3 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt4  )))),0) amt4_3 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt5  )))),0) amt5_3 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt6  )))),0) amt6_3 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt7  )))),0) amt7_3 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt8  )))),0) amt8_3 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt9  )))),0) amt9_3 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt10 )))),0) amt10_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt11 )))),0) amt11_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt12 )))),0) amt12_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt13 )))),0) amt13_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt14 )))),0) amt14_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt15 )))),0) amt15_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt16 )))),0) amt16_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt17 )))),0) amt17_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt18 )))),0) amt18_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt19 )))),0) amt19_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt20 )))),0) amt20_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt21 )))),0) amt21_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt22 )))),0) amt22_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt23 )))),0) amt23_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt24 )))),0) amt24_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt25 )))),0) amt25_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt26 )))),0) amt26_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt27 )))),0) amt27_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt28 )))),0) amt28_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt29 )))),0) amt29_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt30 )))),0) amt30_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt31 )))),0) amt31_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt33 )))),0) amt33_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt34 )))),0) amt34_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt35 )))),0) amt35_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt36 )))),0) amt36_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt39 )))),0) amt39_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt40 )))),0) amt40_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt43 )))),0) amt43_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt44 )))),0) amt44_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt45 )))),0) amt45_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.amt46 )))),0) amt46_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.af_amt)))),0) af_amt_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.bc_s_g)))),0) bc_s_g_3, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',decode(a.fee_rent_st,'1',0,decode(sign(a.fee_con_mon-6),-1,0,a.fee_s_amt)))),0) fee_s_amt_3, \n"+

					   //기타
					   "        0 RENT_WAY_1_CNT_4, \n"+												//영업대수
					   "        count (decode(a.cost_st,'1','',a.rent_l_cd)) RENT_WAY_2_CNT_4, \n"+		//발생건수
					   "        0 CON_MON_4, \n"+														//총개월수

					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt1  )),0) amt1_4 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt2  )),0) amt2_4 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt3  )),0) amt3_4 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt4  )),0) amt4_4 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt5  )),0) amt5_4 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt6  )),0) amt6_4 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt7  )),0) amt7_4 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt8  )),0) amt8_4 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt9  )),0) amt9_4 , \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt10 )),0) amt10_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt11 )),0) amt11_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt12 )),0) amt12_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt13 )),0) amt13_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt14 )),0) amt14_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt15 )),0) amt15_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt16 )),0) amt16_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt17 )),0) amt17_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt18 )),0) amt18_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt19 )),0) amt19_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt20 )),0) amt20_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt21 )),0) amt21_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt22 )),0) amt22_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt23 )),0) amt23_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt24 )),0) amt24_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt25 )),0) amt25_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt26 )),0) amt26_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,DECODE(a.cost_st,'5',DECODE(SIGN(TO_NUMBER(a.cmp_dt)-20160501),-1,a.amt27,a.amt27/5),a.amt27) )),0) amt27_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt28 )),0) amt28_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt29 )),0) amt29_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,DECODE(a.cost_st,'5',DECODE(SIGN(TO_NUMBER(a.cmp_dt)-20160501),-1,a.amt30,a.amt30/5),a.amt30) )),0) amt30_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt31 )),0) amt31_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt33 )),0) amt33_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt34 )),0) amt34_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt35 )),0) amt35_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt36 )),0) amt36_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt39 )),0) amt39_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt40 )),0) amt40_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt43 )),0) amt43_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt44 )),0) amt44_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt45 )),0) amt45_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.amt46 )),0) amt46_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.af_amt)),0) af_amt_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.bc_s_g)),0) bc_s_g_4, \n"+
					   "        nvl(sum(decode(a.cost_st,'1',0,a.fee_s_amt)),0) fee_s_amt_4 \n"+
 
					   " from   ( "+
					   "		  SELECT b.car_gu, c.rent_st AS fee_rent_st, c.con_mon AS fee_con_mon, a.* "+
					   " 		  FROM   STAT_BUS_COST_CMP_BASE a, CONT b, FEE c "+
					   "	      WHERE  a.gubun = '2' and a.cost_st NOT IN ('6','13','14') "+dt_query+
					   "	      AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND a.rent_mng_id=c.rent_mng_id(+) AND a.rent_l_cd=c.rent_l_cd(+) AND a.rent_st=c.rent_st(+) "+
                       "          UNION ALL "+
                       "          SELECT '3' car_gu, a.rent_st AS fee_rent_st, TO_char(a.con_mon) AS fee_con_mon, a.* "+
					   "	      FROM   STAT_BUS_COST_CMP_BASE a "+
					   "	      WHERE  a.gubun = '2' and a.cost_st in ('13','14') "+dt_query+
					   "        ) a, users b "+ 	
					   " where  a.bus_id=b.user_id ";



		query +=       " group by b.user_nm \n"+
                       " order by max(b.use_yn) desc, decode(max(b.dept_id),'0001','01','0002','02','0007','03','0008','04','0009','05','0010','06','0011','07','0012','08','0013','09','0014','10','0015','11','0016','12','0017','13','0018','14','1000','15','16'), (sum(a.amt8)-sum(a.amt21)+sum(a.amt30)) desc \n"+
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
			System.out.println("[CostDatabase:getSaleCostCampaignUserStatListRm()]"+e);
			System.out.println("[CostDatabase:getSaleCostCampaignUserStatListRm()]"+query);
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
	 * 결과 :마감테이블 조회 - 부서별
	*/
	public Vector getSaleCostCampaignDeptStatList(String s_kd, String t_wd, String sort, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();


		
		String query = " select b.dept_id, \n"+
					   "        count(decode(a.cost_st,'1',decode(a.rent_way,'1',a.rent_l_cd))) RENT_WAY_1_CNT, \n"+
					   "        count(decode(a.cost_st,'1',decode(a.rent_way,'1','',a.rent_l_cd))) RENT_WAY_2_CNT, \n"+
					   "        sum(a.amt1 ) amt1 , \n"+
					   "        sum(a.amt2 ) amt2 , \n"+
					   "        sum(a.amt3 ) amt3 , \n"+
					   "        sum(a.amt4 ) amt4 , \n"+
					   "        sum(a.amt5 ) amt5 , \n"+
					   "        sum(a.amt6 ) amt6 , \n"+
					   "        sum(a.amt7 ) amt7 , \n"+
					   "        sum(a.amt8 ) amt8 , \n"+
					   "        sum(a.amt9 ) amt9 , \n"+
					   "        sum(a.amt10) amt10, \n"+
					   "        sum(a.amt11) amt11, \n"+
					   "        sum(a.amt12) amt12, \n"+
					   "        sum(a.amt13) amt13, \n"+
					   "        sum(a.amt14) amt14, \n"+
					   "        sum(a.amt15) amt15, \n"+
					   "        sum(a.amt16) amt16, \n"+
					   "        sum(a.amt17) amt17, \n"+
					   "        sum(a.amt18) amt18, \n"+
					   "        sum(a.amt19) amt19, \n"+
					   "        sum(a.amt20) amt20, \n"+
					   "        sum(a.amt21) amt21, \n"+
					   "        sum(a.amt22) amt22, \n"+
					   "        sum(a.amt23) amt23, \n"+
					   "        sum(a.amt24) amt24, \n"+
					   "        sum(a.amt25) amt25, \n"+
					   "        sum(a.amt26) amt26, \n"+
					   "        sum(a.amt27) amt27, \n"+
					   "        sum(a.amt28) amt28, \n"+
					   "        sum(a.amt29) amt29, \n"+
					   "        sum(a.amt30) amt30, \n"+
					   "        sum(a.amt31) amt31, \n"+
					   "        sum(a.amt33) amt33, \n"+
					   "        sum(a.amt34) amt34, \n"+
					   "        sum(a.amt35) amt35, \n"+
					   "        sum(a.amt36) amt36, \n"+
					   "        sum(a.amt39) amt39, \n"+
					   "        sum(a.amt40) amt40, \n"+
					   "        sum(a.amt43) amt43, \n"+
					   "        sum(a.amt44) amt44, \n"+
					   "        sum(a.amt45) amt45, \n"+
					   "        sum(a.amt46) amt46, \n"+
			           "        (sum(a.amt4 )+ sum(a.amt5 ) + sum(a.amt6 ) + sum(a.amt16 ))/(count(decode(a.rent_way,'1',a.rent_l_cd))+count(decode(a.rent_way,'1','',a.rent_l_cd))) as rent_per, \n"+
					   "        sum(case when nvl(fe.bc_s_a, 0) = 0 then 0 else trunc( nvl(f.fee_s_amt,0) / decode(fe.bc_s_a, 0, 1, null, 1, fe.bc_s_a) * 100000 ) end) af_amt, \n"+
					   "        sum(fe.bc_s_g) bc_s_g, sum(f.fee_s_amt) fee_s_amt \n"+
					   " from   stat_bus_cost_cmp_base a, users b, cont c, fee f, fee_etc fe, estimate em \n"+
					   " where  a.gubun = '2' and a.bus_id=b.user_id \n"+
//			           "        and b.use_yn='Y' and b.loan_st in ('1','2') \n"+
			           "        and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd  \n"+
					   "	    and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_st = f.rent_st  \n"+
					   "	    and a.rent_mng_id = fe.rent_mng_id(+) and a.rent_l_cd = fe.rent_l_cd(+) and a.rent_st = fe.rent_st(+)  \n"+
					   "        and fe.bc_est_id=em.est_id(+) ";

		String dt1 = "";
		String dt2 = "";

		if(gubun1.equals("1")){
			dt1		= "substr(a.cmp_dt,1,6)";
			dt2		= "a.cmp_dt";
		}else if(gubun1.equals("2")){
			dt1		= "substr(decode(a.rent_st,'1',b.rent_dt,f.rent_dt),1,6)";
			dt2		= "decode(a.rent_st,'1',b.rent_dt,f.rent_dt)";
		}else if(gubun1.equals("3")){
			dt1		= "substr(f.rent_start_dt,1,6)";
			dt2		= "f.rent_start_dt";
		}else if(gubun1.equals("4")){
			dt1		= "substr(cc.cls_dt,1,6)";
			dt2		= "cc.cls_dt";
		}else if(gubun1.equals("21")){
			dt1		= "substr(decode(a.rent_st,'1',b.rent_dt,f.rent_start_dt),1,6)";
			dt2		= "decode(a.rent_st,'1',b.rent_dt,f.rent_start_dt)";
		}else if(gubun1.equals("22")){
			dt1		= "substr(em.update_dt,1,6)";
			dt2		= "substr(em.update_dt,1,8)";
		}

		if(gubun2.equals("2"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("6"))		query += " and "+dt2+" like to_char(add_months(sysdate,-1),'YYYYMM')||'%'";
		else if(gubun2.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun2.equals("5"))		query += " and "+dt2+" between replace('"+cs_dt+"', '-','') and replace('"+ce_dt+"', '-','')";
		else if(gubun2.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		query +=       " group by b.dept_id \n"+
                       " order by b.dept_id \n"+
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
			System.out.println("[CostDatabase:getSaleCostCampaignDeptStatList()]"+e);
			System.out.println("[CostDatabase:getSaleCostCampaignDeptStatList()]"+query);
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
	 * 결과 :마감테이블 조회 - 상품별
	*/
	public Vector getSaleCostCampaignGoodStatList(String s_kd, String t_wd, String sort, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();


		
		String query = " select \n"+
					   " 		decode(f.rent_st,'1',decode(c.car_gu,'1','1','0','2'),'3') car_type, \n"+
					   "    	decode(c.car_st,'1','1','2')||decode(a.rent_way,'1','1','2') good, \n"+
					   "        count (decode(sign(f.con_mon-6),-1,'',a.rent_l_cd)) RENT_WAY_1_CNT, \n"+		//영업대수
					   "        count (a.rent_l_cd) RENT_WAY_2_CNT, \n"+										//발생건수
					   "        sum   (f.con_mon) CON_MON, \n"+													//총개월수
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt1 )) amt1 , \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt2 )) amt2 , \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt3 )) amt3 , \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt4 )) amt4 , \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt5 )) amt5 , \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt6 )) amt6 , \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt7 )) amt7 , \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt8 )) amt8 , \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt9 )) amt9 , \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt10)) amt10, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt11)) amt11, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt12)) amt12, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt13)) amt13, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt14)) amt14, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt15)) amt15, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt16)) amt16, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt17)) amt17, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt18)) amt18, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt19)) amt19, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt20)) amt20, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt21)) amt21, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt22)) amt22, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt23)) amt23, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt24)) amt24, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt25)) amt25, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt26)) amt26, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt27)) amt27, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt28)) amt28, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt29)) amt29, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt30)) amt30, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt31)) amt31, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt33)) amt33, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt34)) amt34, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt35)) amt35, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt36)) amt36, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt39)) amt39, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt40)) amt40, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt43)) amt43, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt44)) amt44, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt45)) amt45, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.amt46)) amt46, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.af_amt)) af_amt, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,a.bc_s_g)) bc_s_g, \n"+
					   "	    sum(decode(sign(f.con_mon-6),-1,0,a.fee_s_amt)) fee_s_amt, \n"+
					   "        sum(decode(sign(f.con_mon-6),-1,0,(f.fee_s_amt*f.con_mon)+f.pp_s_amt)) af_amt2, \n"+
					   "	    sum(decode(sign(f.con_mon-6),-1,0,decode(d.s_dc1_re,'포인트DC',d.s_dc1_amt,0)+decode(d.s_dc2_re,'포인트DC',d.s_dc2_amt,0)+decode(d.s_dc3_re,'포인트DC',d.s_dc3_amt,0))) point_dc_amt \n"+
					   " from   stat_bus_cost_cmp_base a, users b, cont c, fee f, fee_etc fe, estimate em, car_etc d \n"+
					   " where  a.cost_st='1' and a.gubun = '2' and a.bus_id=b.user_id \n"+
			           "        and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd  \n"+
					   "	    and a.rent_mng_id = f.rent_mng_id and a.rent_l_cd = f.rent_l_cd and a.rent_st = f.rent_st  \n"+
					   "	    and a.rent_mng_id = fe.rent_mng_id(+) and a.rent_l_cd = fe.rent_l_cd(+) and a.rent_st = fe.rent_st(+)  \n"+
					   "        and fe.bc_est_id=em.est_id(+) "+
					   "        and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd ";

		String dt1 = "";
		String dt2 = "";

		if(gubun1.equals("1")){
			dt1		= "substr(a.cmp_dt,1,6)";
			dt2		= "a.cmp_dt";
		}else if(gubun1.equals("2")){
			dt1		= "substr(decode(a.rent_st,'1',b.rent_dt,f.rent_dt),1,6)";
			dt2		= "decode(a.rent_st,'1',b.rent_dt,f.rent_dt)";
		}else if(gubun1.equals("3")){
			dt1		= "substr(f.rent_start_dt,1,6)";
			dt2		= "f.rent_start_dt";
		}else if(gubun1.equals("4")){
			dt1		= "substr(cc.cls_dt,1,6)";
			dt2		= "cc.cls_dt";
		}else if(gubun1.equals("21")){
			dt1		= "substr(decode(a.rent_st,'1',b.rent_dt,f.rent_start_dt),1,6)";
			dt2		= "decode(a.rent_st,'1',b.rent_dt,f.rent_start_dt)";
		}else if(gubun1.equals("22")){
			dt1		= "substr(em.update_dt,1,6)";
			dt2		= "substr(em.update_dt,1,8)";
		}

		if(gubun2.equals("2"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun2.equals("6"))		query += " and "+dt2+" like to_char(add_months(sysdate,-1),'YYYYMM')||'%'";
		else if(gubun2.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun2.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";
		else if(gubun2.equals("5"))		query += " and "+dt2+" between replace('"+cs_dt+"', '-','') and replace('"+ce_dt+"', '-','')";
		else if(gubun2.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		query +=       " group by decode(f.rent_st,'1',decode(c.car_gu,'1','1','0','2'),'3'), decode(c.car_st,'1','1','2'), decode(a.rent_way,'1','1','2') \n"+
                       " order by decode(f.rent_st,'1',decode(c.car_gu,'1','1','0','2'),'3'), decode(c.car_st,'1','1','2'), decode(a.rent_way,'1','1','2') \n"+
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
			System.out.println("[CostDatabase:getSaleCostCampaignGoodStatList()]"+e);
			System.out.println("[CostDatabase:getSaleCostCampaignGoodStatList()]"+query);
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
	 * 결과 :마감테이블 조회 - 상품별
	*/
	public Vector getSaleCostCampaignGoodEtcStatList(String s_kd, String t_wd, String sort, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select \n"+
					   " 		'4' car_type, \n"+
					   "	    decode(a.cost_st, '7', decode(a.rent_st,'1',decode(c.car_gu,'1','0','1'),'2'), "+
					   "				          '8', decode(a.rent_st,'1',decode(c.car_gu,'1','0','1'),'2'), "+
					   "                          '2', '3',   '5', '4', "+
			           "                          '3', decode(s.cls_st,'1','10','7'), "+
			           "                          '4', decode(s.cls_st,'1','11','8'), "+
					   "                          '9',  '13', "+
					   "                          '10', '14', "+
					   "                          '11', '15', "+
					   "                          '12', '16',  "+
					   "                          '13', '17',  "+
					   "                          '14', '17'  "+
					   "	    ) good, \n"+
					   "        0 RENT_WAY_1_CNT, \n"+															//영업대수
					   "        count (a.rent_l_cd) RENT_WAY_2_CNT, \n"+										//발생건수
					   "        sum   (decode(a.cost_st,'2',f2.con_mon,'9',f2.con_mon)) con_mon, \n"+			//총개월수
					   "        sum(a.amt1 ) amt1 , \n"+
					   "        sum(a.amt2 ) amt2 , \n"+
					   "        sum(a.amt3 ) amt3 , \n"+
					   "        sum(a.amt4 ) amt4 , \n"+
					   "        sum(a.amt5 ) amt5 , \n"+
					   "        sum(a.amt6 ) amt6 , \n"+
					   "        sum(a.amt7 ) amt7 , \n"+
					   "        sum(a.amt8 ) amt8 , \n"+
					   "        sum(a.amt9 ) amt9 , \n"+
					   "        sum(a.amt10) amt10, \n"+
					   "        sum(a.amt11) amt11, \n"+
					   "        sum(a.amt12) amt12, \n"+
					   "        sum(a.amt13) amt13, \n"+
					   "        sum(a.amt14) amt14, \n"+
					   "        sum(a.amt15) amt15, \n"+
					   "        sum(a.amt16) amt16, \n"+
					   "        sum(a.amt17) amt17, \n"+
					   "        sum(a.amt18) amt18, \n"+
					   "        sum(a.amt19) amt19, \n"+
					   "        sum(a.amt20) amt20, \n"+
					   "        sum(a.amt21) amt21, \n"+
					   "        sum(a.amt22) amt22, \n"+
					   "        sum(a.amt23) amt23, \n"+
					   "        sum(a.amt24) amt24, \n"+
					   "        sum(a.amt25) amt25, \n"+
					   "        sum(a.amt26) amt26, \n"+
					   "        sum(DECODE(a.cost_st,'5',DECODE(SIGN(TO_NUMBER(a.cmp_dt)-20160501),-1,a.amt27,a.amt27/5),a.amt27)) amt27, \n"+
					   "        sum(a.amt28) amt28, \n"+
					   "        sum(a.amt29) amt29, \n"+
					   "        sum(DECODE(a.cost_st,'5',DECODE(SIGN(TO_NUMBER(a.cmp_dt)-20160501),-1,a.amt30,a.amt30/5),a.amt30)) amt30, \n"+
					   "        sum(a.amt31) amt31, \n"+
					   "        sum(a.amt33) amt33, \n"+
					   "        sum(a.amt34) amt34, \n"+
					   "        sum(a.amt35) amt35, \n"+
					   "        sum(a.amt36) amt36, \n"+
					   "        sum(a.amt39) amt39, \n"+
					   "        sum(a.amt40) amt40, \n"+
					   "        sum(a.amt43) amt43, \n"+
					   "        sum(a.amt44) amt44, \n"+
					   "        sum(a.amt45) amt45, \n"+
					   "        sum(a.amt46) amt46, \n"+
					   "        sum(a.af_amt) af_amt, \n"+
					   "        sum(a.bc_s_g) bc_s_g, \n"+
					   "        sum(a.fee_s_amt) fee_s_amt, 0 point_dc_amt \n"+
					   " from   stat_bus_cost_cmp_base a, users b, cont c, fee f, fee_etc fe, estimate em, fee_add f2, fee_etc_add fe2, estimate em2, cls_cont s \n"+
					   " where  a.cost_st in ('2','3','4','5','7','8','9','10','11','12','13','14') and a.gubun = '2' and a.bus_id=b.user_id \n"+
			           "        and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd  \n"+
					   "	    and a.rent_mng_id = f.rent_mng_id(+) and a.rent_l_cd = f.rent_l_cd(+) and a.rent_st = f.rent_st(+)  \n"+
					   "	    and a.rent_mng_id = fe.rent_mng_id(+) and a.rent_l_cd = fe.rent_l_cd(+) and a.rent_st = fe.rent_st(+)  \n"+
					   "	    and a.rent_mng_id = f2.rent_mng_id(+) and a.rent_l_cd = f2.rent_l_cd(+) and a.rent_st = f2.rent_st(+)  \n"+
					   "	    and a.rent_mng_id = fe2.rent_mng_id(+) and a.rent_l_cd = fe2.rent_l_cd(+) and a.rent_st = fe2.rent_st(+)  \n"+
					   "        and fe.bc_est_id = em.est_id(+) \n"+
					   "        and fe2.bc_est_id = em2.est_id(+) \n"+
					   "	    and a.rent_mng_id = s.rent_mng_id(+) and a.rent_l_cd = s.rent_l_cd(+) \n"+
					   " ";

		String dt1 = "";
		String dt2 = "";

		if(gubun1.equals("1")){
			dt1		= "substr(a.cmp_dt,1,6)";
			dt2		= "a.cmp_dt";
		}else if(gubun1.equals("2")){
			dt1		= "substr(decode(a.rent_st,'1',b.rent_dt,f.rent_dt),1,6)";
			dt2		= "decode(a.rent_st,'1',b.rent_dt,f.rent_dt)";
		}else if(gubun1.equals("3")){
			dt1		= "substr(f.rent_start_dt,1,6)";
			dt2		= "f.rent_start_dt";
		}else if(gubun1.equals("4")){
			dt1		= "substr(cc.cls_dt,1,6)";
			dt2		= "cc.cls_dt";
		}else if(gubun1.equals("21")){
			dt1		= "substr(decode(a.rent_st,'1',b.rent_dt,f.rent_start_dt),1,6)";
			dt2		= "decode(a.rent_st,'1',b.rent_dt,f.rent_start_dt)";
		}else if(gubun1.equals("22")){
			dt1		= "substr(em.update_dt,1,6)";
			dt2		= "substr(em.update_dt,1,8)";
		}

		if(gubun2.equals("2"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' \n";
		else if(gubun2.equals("6"))		query += " and "+dt2+" like to_char(add_months(sysdate,-1),'YYYYMM')||'%' \n";
		else if(gubun2.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";
		else if(gubun2.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD') \n";
		else if(gubun2.equals("5"))		query += " and "+dt2+" between replace('"+cs_dt+"', '-','') and replace('"+ce_dt+"', '-','') \n";
		else if(gubun2.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		query +=       " group by decode(a.cost_st, '7', decode(a.rent_st,'1',decode(c.car_gu,'1','0','1'),'2'), "+
					   "                            '8', decode(a.rent_st,'1',decode(c.car_gu,'1','0','1'),'2'), "+	
					   "                            '2', '3',   '5', '4', "+
			           "                            '3', decode(s.cls_st,'1','10','7'), "+
			           "                            '4', decode(s.cls_st,'1','11','8'), "+
			           "                            '9', '13', "+
					   "                            '10','14', '11','15', '12','16', '13','17', '14','17') \n"+
                       " order by to_number(decode(a.cost_st, '7', decode(a.rent_st,'1',decode(c.car_gu,'1','0','1'),'2'), "+
					   "                            '8', decode(a.rent_st,'1',decode(c.car_gu,'1','0','1'),'2'), "+	
					   "                            '2', '3',   '5', '4', "+
			           "                            '3', decode(s.cls_st,'1','10','7'), "+
			           "                            '4', decode(s.cls_st,'1','11','8'), "+
			           "                            '9', '13', "+
			           "                            '10','14', '11','15', '12','16', '13','17', '14','17'))  \n"+
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
			System.out.println("[CostDatabase:getSaleCostCampaignGoodEtcStatList()]"+e);
			System.out.println("[CostDatabase:getSaleCostCampaignGoodEtcStatList()]"+query);
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
	 * 결과 :마감테이블 조회 - 상품별 (월렌트)
	*/
	public Vector getSaleCostCampaignGoodEtcStatListRm(String s_kd, String t_wd, String sort, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();


		
		String query = " select \n"+
					   " 		'4' car_type, \n"+
					   "	    '17' good, \n"+
					   "        count (a.rent_l_cd) RENT_WAY_1_CNT, \n"+										//영업대수
					   "        count (a.rent_l_cd) RENT_WAY_2_CNT, \n"+										//발생건수
					   "        sum   (a.con_mon) con_mon, \n"+			//총개월수
					   "        sum   (a.con_day) con_day, \n"+			//총개월수
					   "        sum(a.amt1 ) amt1 , \n"+
					   "        sum(a.amt2 ) amt2 , \n"+
					   "        sum(a.amt3 ) amt3 , \n"+
					   "        sum(a.amt4 ) amt4 , \n"+
					   "        sum(a.amt5 ) amt5 , \n"+
					   "        sum(a.amt6 ) amt6 , \n"+
					   "        sum(a.amt7 ) amt7 , \n"+
					   "        sum(a.amt8 ) amt8 , \n"+
					   "        sum(a.amt9 ) amt9 , \n"+
					   "        sum(a.amt10) amt10, \n"+
					   "        sum(a.amt11) amt11, \n"+
					   "        sum(a.amt12) amt12, \n"+
					   "        sum(a.amt13) amt13, \n"+
					   "        sum(a.amt14) amt14, \n"+
					   "        sum(a.amt15) amt15, \n"+
					   "        sum(a.amt16) amt16, \n"+
					   "        sum(a.amt17) amt17, \n"+
					   "        sum(a.amt18) amt18, \n"+
					   "        sum(a.amt19) amt19, \n"+
					   "        sum(a.amt20) amt20, \n"+
					   "        sum(a.amt21) amt21, \n"+
					   "        sum(a.amt22) amt22, \n"+
					   "        sum(a.amt23) amt23, \n"+
					   "        sum(a.amt24) amt24, \n"+
					   "        sum(a.amt25) amt25, \n"+
					   "        sum(a.amt26) amt26, \n"+
					   "        sum(a.amt27) amt27, \n"+
					   "        sum(a.amt28) amt28, \n"+
					   "        sum(a.amt29) amt29, \n"+
					   "        sum(a.amt30) amt30, \n"+
					   "        sum(a.amt31) amt31, \n"+
					   "        sum(a.amt33) amt33, \n"+
					   "        sum(a.amt34) amt34, \n"+
					   "        sum(a.amt35) amt35, \n"+
					   "        sum(a.amt36) amt36, \n"+
					   "        sum(a.amt37) amt37, \n"+
					   "        sum(a.amt39) amt39, \n"+
					   "        sum(a.amt40) amt40, \n"+
					   "        sum(a.amt43) amt43, \n"+
					   "        sum(a.amt44) amt44, \n"+
					   "        sum(a.amt45) amt45, \n"+
					   "        sum(a.amt46) amt46, \n"+
					   "        sum(a.af_amt) af_amt, \n"+
					   "        sum(a.bc_s_g) bc_s_g, \n"+
					   "        sum(a.fee_s_amt) fee_s_amt, 0 point_dc_amt \n"+
					   " from   stat_bus_cost_cmp_base a, users b, rent_cont c, rent_fee f, rent_cont_ext fe, estimate_sh em  \n"+
					   " where  a.cost_st in ('13','14') and a.gubun = '2' and a.bus_id=b.user_id \n"+
			           "        and a.rent_mng_id = c.car_mng_id and a.rent_l_cd = c.rent_s_cd  \n"+
					   "	    and c.rent_s_cd = f.rent_s_cd "+
					   "	    and a.rent_l_cd = fe.rent_s_cd(+) and to_char(to_number(a.rent_st)-1,'09') = fe.seq(+) \n"+
					   "        and f.est_id = em.est_id \n"+
					   " ";

		String dt1 = "";
		String dt2 = "";

		if(gubun1.equals("1")){
			dt1		= "substr(a.cmp_dt,1,6)";
			dt2		= "a.cmp_dt";
		}else if(gubun1.equals("2")){
			dt1		= "substr(decode(a.rent_st,'1',c.rent_dt,fe.rent_dt),1,6)";
			dt2		= "decode(a.rent_st,'1',c.rent_dt,fe.rent_dt)";
		}else if(gubun1.equals("3")){
			dt1		= "substr(a.cmp_dt,1,6)";
			dt2		= "a.cmp_dt";
		}else if(gubun1.equals("4")){
			dt1		= "substr(c.cls_dt,1,6)";
			dt2		= "c.cls_dt";
		}else if(gubun1.equals("21")){
			dt1		= "substr(a.cmp_dt,1,6)";
			dt2		= "a.cmp_dt";
		}else if(gubun1.equals("22")){
			dt1		= "substr(em.update_dt,1,6)";
			dt2		= "substr(em.update_dt,1,8)";
		}

		if(gubun2.equals("2"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' \n";
		else if(gubun2.equals("6"))		query += " and "+dt2+" like to_char(add_months(sysdate,-1),'YYYYMM')||'%' \n";
		else if(gubun2.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";
		else if(gubun2.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD') \n";
		else if(gubun2.equals("5"))		query += " and "+dt2+" between replace('"+cs_dt+"', '-','') and replace('"+ce_dt+"', '-','') \n";
		else if(gubun2.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		query +=       " group by a.cost_st \n"+
                       " order by a.cost_st  \n"+
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
			System.out.println("[CostDatabase:getSaleCostCampaignGoodEtcStatListRm()]"+e);
			System.out.println("[CostDatabase:getSaleCostCampaignGoodEtcStatListRm()]"+query);
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
	 * 결과 :마감테이블 조회 - 상품별
	*/
	public Vector getSaleCostCampaignGoodClsStatList(String s_kd, String t_wd, String sort, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5, String gubun6, String cs_dt, String ce_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();


		
		String query = " select \n"+
					   " 		'4' car_type, \n"+
					   "	    decode(f.rent_st,'1','1','2') good, \n"+
					   "        0 RENT_WAY_2_CNT, \n"+															//영업대수
					   "        count (a.rent_l_cd) RENT_WAY_1_CNT, \n"+										//발생건수
					   "        sum   (f2.con_mon) con_mon, \n"+												//총개월수
					   "        sum(a.amt1 -a2.amt1 ) amt1 , \n"+
					   "        sum(a.amt2 -a2.amt2 ) amt2 , \n"+
					   "        sum(a.amt3 -a2.amt3 ) amt3 , \n"+
					   "        sum(a.amt4 -a2.amt4 ) amt4 , \n"+
					   "        sum(a.amt5 -a2.amt5 ) amt5 , \n"+
					   "        sum(a.amt6 -a2.amt6 ) amt6 , \n"+
					   "        sum(a.amt7 -a2.amt7 ) amt7 , \n"+
					   "        sum(a.amt8 -a2.amt8 ) amt8 , \n"+
					   "        sum(a.amt9 -a2.amt9 ) amt9 , \n"+
					   "        sum(a.amt10-a2.amt10) amt10, \n"+
					   "        sum(a.amt11-a2.amt11) amt11, \n"+
					   "        sum(a.amt12-a2.amt12) amt12, \n"+
					   "        sum(a.amt13-a2.amt13) amt13, \n"+
					   "        sum(a.amt14-a2.amt14) amt14, \n"+
					   "        sum(a.amt15-a2.amt15) amt15, \n"+
					   "        sum(a.amt16-a2.amt16) amt16, \n"+
					   "        sum(a.amt17-a2.amt17) amt17, \n"+
					   "        sum(a.amt18-a2.amt18) amt18, \n"+
					   "        sum(a.amt19-a2.amt19) amt19, \n"+
					   "        sum(a.amt20-a2.amt20) amt20, \n"+
					   "        sum(a.amt21-a2.amt21) amt21, \n"+
					   "        sum(a.amt22-a2.amt22) amt22, \n"+
					   "        sum(a.amt23-a2.amt23) amt23, \n"+
					   "        sum(a.amt24-a2.amt24) amt24, \n"+
					   "        sum(a.amt25-a2.amt25) amt25, \n"+
					   "        sum(a.amt26-a2.amt26) amt26, \n"+
					   "        sum(a.amt27-a2.amt27) amt27, \n"+
					   "        sum(a.amt28-a2.amt28) amt28, \n"+
					   "        sum(a.amt29-a2.amt29) amt29, \n"+
					   "        sum(a.amt30-a2.amt30) amt30, \n"+
					   "        sum(a.amt31-a2.amt31) amt31, \n"+
					   "        sum(a.amt33-a2.amt33) amt33, \n"+
					   "        sum(a.amt34-a2.amt34) amt34, \n"+
					   "        sum(a.amt35-a2.amt35) amt35, \n"+
					   "        sum(a.amt36-a2.amt36) amt36, \n"+
					   "        sum(a.amt39-a2.amt39) amt39, \n"+
					   "        sum(a.amt40-a2.amt40) amt40, \n"+
					   "        sum(a.af_amt-a2.af_amt) af_amt, \n"+
					   "        sum(a.bc_s_g-a2.bc_s_g) bc_s_g, \n"+
					   "	    sum(a.fee_s_amt-a2.fee_s_amt) fee_s_amt \n"+
					   " from   stat_bus_cost_cmp_base a, users b, cont c, fee_add f2, fee_etc_add fe2, estimate em2, fee f, fee_etc fe, estimate em, stat_bus_cost_cmp_base a2 \n"+
					   " where  a.cost_st in ('6') and a.gubun = '2' and a.bus_id=b.user_id \n"+
//			           "        and b.use_yn='Y' and b.loan_st in ('1','2') \n"+
			           "        and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd  \n"+
					   "	    and a.rent_mng_id = f2.rent_mng_id and a.rent_l_cd = f2.rent_l_cd and a.rent_st = f2.rent_st  \n"+
					   "	    and a.rent_mng_id = fe2.rent_mng_id and a.rent_l_cd = fe2.rent_l_cd and a.rent_st = fe2.rent_st  \n"+
					   "        and fe2.bc_est_id = em2.est_id(+) \n"+
					   "	    and f2.rent_mng_id = f.rent_mng_id and f2.rent_l_cd = f.rent_l_cd and f2.car_st = f.rent_st  \n"+
					   "	    and f2.rent_mng_id = fe.rent_mng_id and f2.rent_l_cd = fe.rent_l_cd and f2.car_st = fe.rent_st  \n"+
					   "        and fe.bc_est_id = em.est_id(+) \n"+
					   "	    and f2.rent_mng_id = a2.rent_mng_id and f2.rent_l_cd = a2.rent_l_cd and f2.car_st = a2.rent_st  \n"+
					   " ";

		String dt1 = "";
		String dt2 = "";

		if(gubun1.equals("1")){
			dt1		= "substr(a.cmp_dt,1,6)";
			dt2		= "a.cmp_dt";
		}else if(gubun1.equals("2")){
			dt1		= "substr(decode(a.rent_st,'1',b.rent_dt,f2.rent_dt),1,6)";
			dt2		= "decode(a.rent_st,'1',b.rent_dt,f2.rent_dt)";
		}else if(gubun1.equals("3")){
			dt1		= "substr(f2.rent_start_dt,1,6)";
			dt2		= "f2.rent_start_dt";
		}else if(gubun1.equals("4")){
			dt1		= "substr(cc.cls_dt,1,6)";
			dt2		= "cc.cls_dt";
		}else if(gubun1.equals("21")){
			dt1		= "substr(decode(a.rent_st,'1',b.rent_dt,f2.rent_start_dt),1,6)";
			dt2		= "decode(a.rent_st,'1',b.rent_dt,f2.rent_start_dt)";
		}else if(gubun1.equals("22")){
			dt1		= "substr(em2.update_dt,1,6)";
			dt2		= "substr(em2.update_dt,1,8)";
		}

		if(gubun2.equals("2"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' \n";
		else if(gubun2.equals("6"))		query += " and "+dt2+" like to_char(add_months(sysdate,-1),'YYYYMM')||'%' \n";
		else if(gubun2.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";
		else if(gubun2.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD') \n";
		else if(gubun2.equals("5"))		query += " and "+dt2+" between replace('"+cs_dt+"', '-','') and replace('"+ce_dt+"', '-','') \n";
		else if(gubun2.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		query +=       " group by decode(f.rent_st,'1','1','2') \n"+
                       " order by decode(f.rent_st,'1','1','2')  \n"+
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
			System.out.println("[CostDatabase:getSaleCostCampaignGoodClsStatList()]"+e);
			System.out.println("[CostDatabase:getSaleCostCampaignGoodClsStatList()]"+query);
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
     * 영업효율내역 조회
     */    
	public Hashtable getSaleCostCampaignCase(String cost_st, String rent_mng_id, String rent_l_cd, String rent_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();



		String query = " select a.*, f.rent_start_dt, decode(f.rent_st,'1',b.rent_dt,f.rent_dt) rent_dt, u.user_nm, c.firm_nm, d.car_nm, d.car_no, "+
			           "        decode(b.car_gu, '0', '재리스', '1' ,'신차', '2', '중고차', '3', '월렌트' ) car_gu_nm, "+
					   "	    fe.bus_agnt_id, u2.user_nm as bus_agnt_nm, \n"+
					   "        decode(a.cost_st,'3','해지','2','추가','14','월렌트',decode(a.rent_st, '1', decode(b.rent_st, '1', '신규', '3', '대차', '4', '증차' ), '연장')) rent_st_nm,  \n"+
					   "        decode(b.car_st, '1', '렌트', '2' ,'보유차', '3', '리스', '4', '월렌트' ) car_st_nm, \n"+
			           "        decode(a.rent_way, '1', '일반식', '기본식') rent_way_nm, f.con_mon,  \n"+
					   "        decode(b.spr_kd, '0', '일반', '1', '우량', '2', '초우량', '3', '신설') spr_kd_nm, \n"+
					   "        decode(a.rent_st, '1', decode(b.car_gu,'0','-', decode(cd.one_self,'Y','자체출고','영업사원출고') ), '-') commi2_nm,  \n"+
			           "        (decode(cd.trf_st1,'2',nvl(cd.trf_amt1,0),'3',nvl(cd.trf_amt1,0),0)+decode(cd.trf_st2,'2',nvl(cd.trf_amt2,0),'3',nvl(cd.trf_amt2,0),0)+decode(cd.trf_st3,'2',nvl(cd.trf_amt3,0),'3',nvl(cd.trf_amt3,0),0)+decode(cd.trf_st4,'2',nvl(cd.trf_amt4,0),'3',nvl(cd.trf_amt4,0),0)) trf_amt \n"+
					   " from   stat_bus_cost_cmp_base a, "+
					   "        cont b, fee f, fee_etc fe , car_etc ce, car_pur cd, users u, users u2, "+
			           "        (select rent_mng_id, rent_l_cd, emp_id from commi where AGNT_ST = '2' ) cm, client c, car_reg d \n"+
                       " where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and a.rent_st='"+rent_st+"' and a.cost_st='"+cost_st+"' \n"+
			           "        and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd  \n"+
					   "	    and a.rent_mng_id = f.rent_mng_id(+) and a.rent_l_cd = f.rent_l_cd(+) and a.rent_st = f.rent_st(+)  \n"+
					   "	    and a.rent_mng_id = fe.rent_mng_id(+) and a.rent_l_cd = fe.rent_l_cd(+) and a.rent_st = fe.rent_st(+)  \n"+
					   "	    and a.rent_mng_id = ce.rent_mng_id(+) and a.rent_l_cd = ce.rent_l_cd(+) \n"+
					   "	    and a.rent_mng_id = cd.rent_mng_id(+) and a.rent_l_cd = cd.rent_l_cd(+) \n"+
					   "        and a.bus_id = u.user_id and fe.bus_agnt_id = u2.user_id(+)\n"+
					   "	    and a.rent_mng_id = cm.rent_mng_id(+) and a.rent_l_cd = cm.rent_l_cd(+) \n"+
			           "        and b.client_id=c.client_id and b.car_mng_id=d.car_mng_id(+)"+
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
			System.out.println("[CostDatabase:getSaleCostCampaignCase(String rent_mng_id, String rent_l_cd, String rent_st)]"+e);
			System.out.println("[CostDatabase]"+query);
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

	  /**
     * 영업효율내역 조회
     */    
	public Hashtable getSaleCostCampaignCaseRm(String cost_st, String rent_mng_id, String rent_l_cd, String rent_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();



		String query = " select a.*, decode(a.rent_st,'1',b.rent_dt,fe.rent_dt) rent_dt, u.user_nm, c.firm_nm, d.car_nm, d.car_no, "+
					   "        decode(a.rent_st,'1','신규', '연장') rent_st_nm,  \n"+
					   "        '보유차' car_st_nm, \n"+
			           "        '일반식' rent_way_nm, \n"+
					   "        '일반' spr_kd_nm, \n"+
					   "        '' commi2_nm,  \n"+
			           "        0 trf_amt \n"+
					   " from   stat_bus_cost_cmp_base a, "+
					   "        rent_cont b, rent_fee f, rent_cont_ext fe, users u, "+
			           "        client c, car_reg d \n"+
                       " where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and a.rent_st='"+rent_st+"' and a.cost_st='"+cost_st+"' \n"+
			           "        and a.rent_mng_id = b.car_mng_id and a.rent_l_cd = b.rent_s_cd  \n"+
					   "	    and b.rent_s_cd = f.rent_s_cd \n"+
					   "	    and a.rent_l_cd = fe.rent_s_cd(+) and to_char(to_number(a.rent_st)-1,'09') = fe.seq(+) \n"+
					   "        and a.bus_id = u.user_id \n"+
			           "        and b.cust_id=c.client_id and b.car_mng_id=d.car_mng_id "+
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
			System.out.println("[CostDatabase:getSaleCostCampaignCaseRm(String rent_mng_id, String rent_l_cd, String rent_st)]"+e);
			System.out.println("[CostDatabase]"+query);
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

	  /**
     * 영업효율내역 조회
     */    
	public Hashtable getSaleCostCampaignBcCase(String cost_st, String rent_mng_id, String rent_l_cd, String rent_st)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();



		String query = " select a.*, f.rent_start_dt, u.user_nm, c.firm_nm, decode(a.rent_st,'t',j.car_nm,d.car_nm) car_nm, decode(a.rent_st,'t',j.car_no,d.car_no) car_no, "+
			           "        decode(b.car_gu, '0', '재리스', '1' ,'신차', '2', '중고차', '3', '월렌트' ) car_gu_nm, "+
			           "        fe.bus_agnt_id, u2.user_nm as bus_agnt_nm, \n"+
					   "        decode(a.cost_st,'3','해지','2','추가','6','정산','9','출고전대차', '14', '월렌트',decode(a.rent_st, '1', decode(b.rent_st, '1', '신규', '3', '대차', '4', '증차' ), '연장')) rent_st_nm,  \n"+
					   "        decode(b.car_st, '1', '렌트', '2' ,'보유차', '3', '리스', '4', '월렌트' ) car_st_nm, \n"+
			           "        decode(a.rent_way, '1', '일반식', '기본식') rent_way_nm, f.con_mon,  \n"+
					   "        decode(b.spr_kd, '0', '일반', '1', '우량', '2', '초우량', '3', '신설') spr_kd_nm, \n"+
					   "        decode(a.rent_st||k.rent_st, 's1', decode(b.car_gu,'0','-', decode(cd.one_self,'Y','자체출고','영업사원출고') ), '-') commi2_nm,  \n"+
			           "        decode(a.cost_st,'14',0,(decode(cd.trf_st1,'2',nvl(cd.trf_amt1,0),'3',nvl(cd.trf_amt1,0),0)+decode(cd.trf_st2,'2',nvl(cd.trf_amt2,0),'3',nvl(cd.trf_amt2,0),0)+decode(cd.trf_st3,'2',nvl(cd.trf_amt3,0),'3',nvl(cd.trf_amt3,0),0)+decode(cd.trf_st4,'2',nvl(cd.trf_amt4,0),'3',nvl(cd.trf_amt4,0),0))) trf_amt \n"+
					   " from   stat_bus_cost_cmp_base a, "+
					   "        cont b, fee_add f, fee_etc_add fe , car_etc ce, car_pur cd, users u, users u2, "+
			           "        (select rent_mng_id, rent_l_cd, emp_id from commi where AGNT_ST = '2' ) cm, client c, car_reg d, taecha i, car_reg j, \n"+
					   "        (select rent_mng_id, rent_l_cd, max(rent_st) rent_st from fee where rent_mng_id='"+rent_mng_id+"' and rent_l_cd='"+rent_l_cd+"' group by rent_mng_id, rent_l_cd) k"+
                       " where  a.rent_mng_id='"+rent_mng_id+"' and a.rent_l_cd='"+rent_l_cd+"' and a.rent_st='"+rent_st+"' and a.cost_st='"+cost_st+"' \n"+
			           "        and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd  \n"+
					   "	    and a.rent_mng_id = f.rent_mng_id(+) and a.rent_l_cd = f.rent_l_cd(+) and a.rent_st = f.rent_st(+)  \n"+
					   "	    and a.rent_mng_id = fe.rent_mng_id(+) and a.rent_l_cd = fe.rent_l_cd(+) and a.rent_st = fe.rent_st(+)  \n"+
					   "	    and a.rent_mng_id = ce.rent_mng_id(+) and a.rent_l_cd = ce.rent_l_cd(+) \n"+
					   "	    and a.rent_mng_id = cd.rent_mng_id(+) and a.rent_l_cd = cd.rent_l_cd(+) \n"+
					   "        and a.bus_id = u.user_id and fe.bus_agnt_id = u2.user_id(+)\n"+
					   "	    and a.rent_mng_id = cm.rent_mng_id(+) and a.rent_l_cd = cm.rent_l_cd(+) \n"+
			           "        and b.client_id=c.client_id and b.car_mng_id=d.car_mng_id(+)"+
					   "	    and a.rent_mng_id = i.rent_mng_id(+) and a.rent_l_cd = i.rent_l_cd(+) \n"+
			           "        and i.car_mng_id=j.car_mng_id(+)"+
					   "	    and a.rent_mng_id = k.rent_mng_id and a.rent_l_cd = k.rent_l_cd \n"+
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
			System.out.println("[CostDatabase:getSaleCostCampaignBcCase(String rent_mng_id, String rent_l_cd, String rent_st)]"+e);
			System.out.println("[CostDatabase]"+query);
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
	
	public Vector getPropCampaign(String save_dt, String gubun, String loan_st, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	 

		query = " select a.pp_amt, a.r_amt, decode(b.user_pos,'대표이사',1,'부장', 2, '팀장', 3, '차장', 4, '과장', 5 , '대리', 6, 9) pos_sort, a.*, "+
					   " b.dept_id, b.user_nm, b.user_id, b.dept_id, c.nm_cd  as dept_nm , b.loan_st "+
					   " from stat_bus_prop a, users b ,  (select * from code where c_st='0002') c  " +
					   " where a.gubun = '"+gubun+"' and a.save_dt='"+save_dt+"' and b.use_yn = 'Y' and a.bus_id=b.user_id  and  b.dept_id=c.code " ;
					 
				
		query += " order by 1 desc , 2 desc, a.cnt1 desc,  a.cnt2 desc, a.cnt3 desc ";
 					    
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
			System.out.println("[CostDatabase:getPropCampaign(String save_dt, String gubun, String loan_st, String s_dt, String e_dt)]"+e);
			System.out.println(query);
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
	 *	내근캠페인 프로시져 호출 - 
	*/
	public String call_sp_prop_magam(String s_day, String s_user_id)
	{
    	getConnection();
    	
    	String query = "{CALL P_PROP_MAGAM (?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, s_day);
			cstmt.setString(2, s_user_id);
			cstmt.registerOutParameter( 3, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[CostDatabase:call_sp_prop_magam]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	
	/*
	 *	외근캠페인 프로시져 호출 - 
	*/
	public String call_sp_prop_magam1(String s_day, String s_user_id)
	{
    	getConnection();
    	
    	String query = "{CALL P_PROP_MAGAM1 (?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, s_day);
			cstmt.setString(2, s_user_id);
			cstmt.registerOutParameter( 3, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[CostDatabase:call_sp_prop_magam1]\n"+e);
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
	*	제안캠페인 포상관련 변수수정
	*/
	public int updatePropVar(String year, String tm, String gubun, String cs_dt, String ce_dt, int amt1, int amt2, int amt3, int cam_per, int amt1_per )
	{
			
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = "UPDATE cost_campaign "+
			" SET cs_dt=?, ce_dt=?, amt1 = ?, amt2 = ?, amt3 = ?, cam_per = ? , amt1_per = ? "+
			" WHERE year=? and tm=? and gubun = ? ";

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cs_dt);
			pstmt.setString(2, ce_dt);
		
			pstmt.setInt(3, amt1);
			pstmt.setInt(4, amt2);
			pstmt.setInt(5, amt3);
			pstmt.setInt(6, cam_per);
			pstmt.setInt(7, amt1_per);
					
			pstmt.setString(8, year);
			pstmt.setString(9, tm);
			pstmt.setString(10, gubun);

			result = pstmt.executeUpdate();

			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[CostDatabase:updateVar]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}
	
	/**
	*	제안캠페인 포상관련 변수 추가
	*/
	public int insertPropVar(String year, String tm, String gubun, String cs_dt, String ce_dt, int amt1, int amt2, int amt3, int cam_per, int amt1_per )
	{
			
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = " insert into  cost_campaign  (  year ,  tm ,  gubun , "+
		                             "  cs_dt, ce_dt, amt1, amt2, amt3,  cam_per,  amt1_per )  "+
		                             " values ( ?, ?, ?, "+
		                             " ?, ?, ?, ?, ?, ?, ? ) " ;                
		
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, year);
			pstmt.setString(2, tm);
			pstmt.setString(3, gubun);
			
			pstmt.setString(4, cs_dt);
			pstmt.setString(5, ce_dt);
		
			pstmt.setInt(6, amt1);
			pstmt.setInt(7, amt2);
			pstmt.setInt(8, amt3);
			pstmt.setInt(9, cam_per);
			pstmt.setInt(10, amt1_per);
				
			result = pstmt.executeUpdate();

			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			System.out.println("[CostDatabase:insertPropVar]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}
	
	
	/**
	 *	사원별 제안캠페인 현황  
 	 */
	public Vector getPropCostStatList(String dt, String ref_dt1, String ref_dt2, String mng_id, int amt1, int amt3, int amt1_per )
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		String f_date1="";
		String t_date1="";
		
		f_date1=  ref_dt1;
		t_date1=  ref_dt2;		
		
		  query = "  select  1 gg,  '제안평가' gubun, p.reg_id, p.prop_id, 0 seq, p.title ,  decode(p.eval_magam, 'Y',  p.eval, trunc(sum(c.e_amt) / count(c.eval_id)) ) e_amt , decode(p.eval_magam, 'Y',  p.prize, trunc(sum(c.p_amt) / count(c.eval_id)) )  p_amt  \n" + 
       		     "   from (select * from prop_c_eval  where seq = 0 ) c , prop_bbs p \n" + 
   				 "	 where p.prop_step <> '5' and p.prop_id = c.prop_id(+)  and p.reg_dt between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n" + 
   				 "   and p.reg_id  = '" + mng_id + "'\n" + 
    			 "	 group by  p.reg_id, p.prop_id,  p.title, p.eval_magam, p.eval, p.prize  \n" + 
    			 " union all \n" + 
    			 "  select 2 gg,  '댓글평가' gubun,  cc.reg_id, cc.prop_id, cc.seq , cc.content title,  sum(c.e_amt) e_amt, 0 p_amt  \n" + 
				 "	 from  ( select * from prop_c_eval where seq <> 0 ) c, prop_comment cc,  prop_bbs p \n" + 
				 "	 where p.prop_step <> '5' and p.prop_id = cc.prop_id(+) and cc.prop_id = c.prop_id(+) and cc.seq = c.seq(+) and cc.re_seq = c.re_seq(+) and p.reg_dt  between replace('" + f_date1 + "','-','') and replace('" + t_date1 + "','-','') \n" + 
				 "	 and cc.reg_id  = '" + mng_id + "'\n" + 
				 "	 group by cc.reg_id, cc.prop_id, cc.seq , cc.content \n";
			   
   		query += "  order by 1, 4, 5 ";
  		   		    
	  	
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
			System.out.println("[CostDatabase:getPropCostStatList]"+e);
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
	 *	캠페인 평가 관련  - 
	 */
	public Vector getStatCmpList(String gubun1, String gubun2, String loan_st)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_q = "";
		
		if ( gubun2.equals("30")) {
			sub_q = " s.gubun in  ( '30', '5', '28' )  ";
		}else {
			sub_q = " s.gubun = " + gubun2;
		}
				
		query = "select u.user_id, u.user_nm, decode(u.loan_st, '1', '4', null, '5', u.loan_st) as loan_st, c.nm, decode(u.user_pos,'대표이사',1,'이사', 2, '부장', 3, '차장', 4, '과장', 5 , '대리', 6, 9) pos_sort, u.enter_dt, \n" +
				"	  sum(decode(to_char(s.c_mm) || s.gubun,  '12', nvl(s.amt1,0),0)) as s1, \n" +
		       	"	  sum(decode(to_char(s.c_mm) || s.gubun,  '11', nvl(s.amt1,0),0)) as d1, \n" +
		       	"	  sum(decode(to_char(s.c_mm) || s.gubun,  '15', nvl(s.amt1,0),0)) as c1, \n" +
		       	"	  sum(decode(to_char(s.c_mm) || s.gubun,  '16', nvl(s.amt1,0),0)) as p1, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '22', nvl(s.amt1,0),0)) as s2, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '21', nvl(s.amt1,0),0)) as d2, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '25', nvl(s.amt1,0),0)) as c2, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '26', nvl(s.amt1,0),0)) as p2, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '32', nvl(s.amt1,0),0)) as s3, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '31', nvl(s.amt1,0),0)) as d3, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '35', nvl(s.amt1,0),0)) as c3, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '36', nvl(s.amt1,0),0)) as p3, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '42', nvl(s.amt1,0),0)) as s4, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '41', nvl(s.amt1,0),0)) as d4,  \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '128', nvl(s.amt1,0),0)) as f1,  \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '228', nvl(s.amt1,0),0)) as f2, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '328', nvl(s.amt1,0),0)) as f3,  \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '428', nvl(s.amt1,0),0)) as f4,  \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '129', nvl(s.amt1,0),0)) as g1,  \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '229', nvl(s.amt1,0),0)) as g2,  \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '329', nvl(s.amt1,0),0)) as g3,  \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '429', nvl(s.amt1,0),0)) as g4,  \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '130', nvl(s.amt1,0),0)) as e1,  \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '230', nvl(s.amt1,0),0)) as e2,  \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '330', nvl(s.amt1,0),0)) as e3,  \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '430', nvl(s.amt1,0),0)) as e4  \n" +
		       	"	from stat_cmp s, users u, code c  \n" +		
  				"	where s.c_yy = '"+gubun1 + "' and u.user_id = s.user_id(+) and c.c_st = '0002' and u.dept_id = c.code and  u.use_yn = 'Y' and u.dept_id not in ('8888', '0004') and  u.user_id not in  ('000026' , '000003' )  and  u.user_pos not in (  '팀장' )  \n";
  		
  		if  ( loan_st.equals("3") ) {
  				query += " and  s.s_type = '2' and u.loan_st is null and " + sub_q  ;
  		} else {
  				query += " and  s.s_type = '2' and  u.loan_st in ('1', '2')  and " + sub_q ;
  		}	
  			  			
  		query += "	group by u.user_id, u.user_nm, u.loan_st, c.nm, decode(u.user_pos,'대표이사',1,'이사', 2, '부장', 3, '차장', 4,  '과장', 5 , '대리', 6, 9), u.enter_dt \n" +
				     "	order by 3,5, 6 ";
		
		try {
			stmt = conn.createStatement();
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
			System.out.println("[CostDatabase:getStatCmpList]\n"+e);			
			System.out.println(query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
	
	
	/** 
	 *	캠페인 평가 관련  - 채권 외근
	 */
	public Vector getStatCmpList1(String gubun1, String gubun2)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = "select u.user_id, u.user_nm, decode(u.loan_st, '1', '4', null, '5', u.loan_st) as loan_st, c.nm, decode(u.user_pos,'대표이사',1,'부장', 2, '팀장', 3, '차장', 4, '과장', 5 , '대리', 6, 9) pos_sort, u.enter_dt, \n" +
				"	  sum(decode(to_char(s.c_mm) || s.gubun,  '11', decode(s.gubun||s.s_type,'12',(nvl(s.amt1,0)+nvl(s.amt2,0))/2,nvl(s.amt2,0)),0)) as d1, \n" +
			   	"	  sum(decode(to_char(s.c_mm) || s.gubun,  '21', decode(s.gubun||s.s_type,'12',(nvl(s.amt1,0)+nvl(s.amt2,0))/2,nvl(s.amt2,0)),0)) as d2, \n" +
			   	"	  sum(decode(to_char(s.c_mm) || s.gubun,  '31', decode(s.gubun||s.s_type,'12',(nvl(s.amt1,0)+nvl(s.amt2,0))/2,nvl(s.amt2,0)),0)) as d3, \n" +
			   	"	  sum(decode(to_char(s.c_mm) || s.gubun,  '41', decode(s.gubun||s.s_type,'12',(nvl(s.amt1,0)+nvl(s.amt2,0))/2,nvl(s.amt2,0)),0)) as d4, \n" +


				"     ( sum(decode(to_char(s.c_mm) || s.gubun,  '11', decode(s.gubun||s.s_type,'12',(nvl(s.amt1,0)+nvl(s.amt2,0))/2,nvl(s.amt2,0)),0))+ "+
				"       sum(decode(to_char(s.c_mm) || s.gubun,  '21', decode(s.gubun||s.s_type,'12',(nvl(s.amt1,0)+nvl(s.amt2,0))/2,nvl(s.amt2,0)),0))+ "+
				"       sum(decode(to_char(s.c_mm) || s.gubun,  '31', decode(s.gubun||s.s_type,'12',(nvl(s.amt1,0)+nvl(s.amt2,0))/2,nvl(s.amt2,0)),0))+ "+
				"       sum(decode(to_char(s.c_mm) || s.gubun,  '41', decode(s.gubun||s.s_type,'12',(nvl(s.amt1,0)+nvl(s.amt2,0))/2,nvl(s.amt2,0)),0))) as sum_per1, "+

				"     ( sum(decode(to_char(s.c_mm) || s.gubun,  '11', decode(s.gubun||s.s_type,'12',(nvl(s.amt1,0)+nvl(s.amt2,0))/2,nvl(s.amt2,0)),0))+ "+
				"       sum(decode(to_char(s.c_mm) || s.gubun,  '21', decode(s.gubun||s.s_type,'12',(nvl(s.amt1,0)+nvl(s.amt2,0))/2,nvl(s.amt2,0)),0))+ "+
				"       sum(decode(to_char(s.c_mm) || s.gubun,  '31', decode(s.gubun||s.s_type,'12',(nvl(s.amt1,0)+nvl(s.amt2,0))/2,nvl(s.amt2,0)),0))+ "+
				"       sum(decode(to_char(s.c_mm) || s.gubun,  '41', decode(s.gubun||s.s_type,'12',(nvl(s.amt1,0)+nvl(s.amt2,0))/2,nvl(s.amt2,0)),0)))/4 as ave_per1 "+

		       	"	from stat_cmp s, users u, code c ,   \n" +
		       	"  (select bus_id2, avg_per ave_per from stat_settle se, (select max(save_dt) save_dt from stat_settle) b where se.save_dt = b.save_dt) se  \n" +	
  				"	where s.c_yy = '"+gubun1 + "' and u.user_id = s.user_id(+) and c.c_st = '0002' and u.dept_id = c.code and  u.use_yn = 'Y' and u.dept_id not in ('8888', '0004', '0005', '1000') and  u.user_pos not in ( '팀장' )  \n";
  		 		
  		query += " and u.user_id = se.bus_id2 and s.s_type = '2' and  u.loan_st in ('1', '2') and  s.gubun = '" + gubun2 +"'" ;
  		  		 			  			
  		query += "	group by u.user_id, u.user_nm, u.loan_st, c.nm, decode(u.user_pos,'대표이사',1,'부장', 2, '팀장', 3, '차장', 4,  '과장', 5 , '대리', 6, 9), u.enter_dt, se.ave_per \n" +
				     "	order by 3,5, 6 ";
		
		try {
			stmt = conn.createStatement();
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
			System.out.println("[CostDatabase:getStatCmpList1]\n"+e);
			System.out.println(query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
		
	/** 
	 *	캠페인 평가 관련  - 채권 내근
	 */
	public Vector getStatCmpList2(String gubun1, String gubun2)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = "select u.user_id, u.user_nm, decode(u.loan_st, '1', '4', null, '5', u.loan_st) as loan_st, c.nm, decode(u.user_pos,'대표이사',1,'부장', 2, '팀장', 3, '차장', 4, '과장', 5 , '대리', 6, 9) pos_sort, u.enter_dt, \n" +
			   	"	  sum(decode(to_char(s.c_mm) || s.gubun,  '11', nvl(s.amt1,0),0)) as d1, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '21', nvl(s.amt1,0),0)) as d2, \n" +		     
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '31', nvl(s.amt1,0),0)) as d3, \n" +	
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '41', nvl(s.amt1,0),0)) as d4,  \n" +
		       	"	  sum(decode(to_char(s.c_mm) || s.gubun,  '11', nvl(s.amt3,0)- nvl(s.amt2,0),0)) as cd1, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '21', nvl(s.amt3,0)- nvl(s.amt2,0),0)) as cd2, \n" +		     
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '31', nvl(s.amt3,0)- nvl(s.amt2,0),0)) as cd3, \n" +	
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '41', nvl(s.amt3,0)- nvl(s.amt2,0),0)) as cd4  \n" +
		       	"	from stat_cmp s, users u, code c  \n" +		      
  				"	where s.c_yy = '"+gubun1 + "' and u.user_id = s.user_id(+) and c.c_st = '0002' and u.dept_id = c.code and  u.use_yn = 'Y' and u.dept_id not in ('8888', '0004', '1000') and  u.user_id not in ('000053', '000052', '000028') and u.user_pos not in (  '팀장' )   \n";
  		 		
  		query += " and s.s_type = '2' and  u.loan_st is null and  s.gubun = '" + gubun2 +"'" ;
  		  		 			  			
  		query += "	group by u.user_id, u.user_nm, u.loan_st, c.nm, decode(u.user_pos,'대표이사',1,'부장', 2, '팀장', 3, '차장', 4,  '과장', 5 , '대리', 6, 9), u.enter_dt \n" +
				     "	order by 3,5, 6 ";
		
		try {
			stmt = conn.createStatement();
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
			System.out.println("[CostDatabase:getStatCmpList2]\n"+e);
			System.out.println(query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}	
	
		
	/** 
	 *	관리대수 - 고객지원팀
	 */
	public Vector getStatCmpList7(String gubun1, String gubun2)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = "select u.user_id, u.user_nm, decode(u.loan_st, '1', '4', null, '5', u.loan_st) as loan_st, c.nm, decode(u.user_pos,'대표이사',1,'부장', 2, '팀장', 3, '차장', 4, '과장', 5 , '대리', 6, 9) pos_sort, u.enter_dt, DECODE(u.BR_ID, 'G1', 2, 'B1', 2, 'D1', 3 , 'J1', '3' ,  1) br_id, \n" +
			   	"	  sum(decode(to_char(s.c_mm) || s.gubun,  '17', nvl(s.amt,0),0)) as d1, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '27', nvl(s.amt,0),0)) as d2, \n" +		     
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '37', nvl(s.amt,0),0)) as d3, \n" +	
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '47', nvl(s.amt,0),0)) as d4,  \n" +
		       	"	  sum(decode(to_char(s.c_mm) || s.gubun,  '17', nvl(s.amt1,0),0)) as cd1, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '27', nvl(s.amt1,0),0)) as cd2, \n" +		     
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '37', nvl(s.amt1,0),0)) as cd3, \n" +	
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '47', nvl(s.amt1,0),0)) as cd4  \n" +
		       	"	from stat_cmp s, users u, code c  \n" +		      
  				"	where s.c_yy = '"+gubun1 + "' and u.user_id = s.user_id(+) and c.c_st = '0002' and u.dept_id = c.code and  u.use_yn = 'Y' and u.dept_id not in ('8888', '0004', '0005') and  u.user_id not in (  '000031') and u.user_pos not in ( '팀장' )  \n";
  		 		
  		query += " and s.s_type = '1' and  u.loan_st = '1' and  s.gubun = '" + gubun2 +"'" ;
  		  		 			  			
  		query += "	group by u.user_id, u.user_nm, u.loan_st, c.nm, decode(u.user_pos,'대표이사',1,'부장', 2, '팀장', 3, '차장', 4,  '과장', 5 , '대리', 6, 9), u.enter_dt, u.br_id \n" +
				     "	order by 7, 3, 5, 6 ";
		
		try {
			stmt = conn.createStatement();
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
			System.out.println("[CostDatabase:getStatCmpList7]\n"+e);
			System.out.println(query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}			
		
	
	 /**
	 *	사원별 관리비용 기초 - 사고는 사고시점의 담당자
 	 */
 	
	public Vector getCostBaseList(String save_dt, String c_e_dt, String mng_id, int bus_cost_per, int mng_cost_per)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		query = "  select a.rent_way_cd , a.rent_dt , a.rent_l_cd, cr.car_no, a.rent_way, cr.car_nm, a.con_f_nm, a.firm_nm,  a.use_yn, a.bus_nm, a.mng_nm,  \n" +	
				" 		  sum(a.f_amt) f_amt, sum(a.j_amt) j_amt,  sum(a.a_amt) a_amt,  sum(a.p_amt) p_amt from (  \n" +	
				" 			select a.rent_l_cd, a.car_no, a.rent_way, a.car_nm, a.con_f_nm, v.rent_way_cd , v.rent_dt,  \n" +	
		        "    			a.f_bus_amt  as f_amt, ( a.j_bus_amt + a.sh_j_bus_amt  )   j_amt ,  \n" +
		        "    			case when b1.gubun = 'A' then b1.bus_amt else 0  end  as a_amt,   case when b1.gubun = 'P' then b1.bus_amt else 0  end as p_amt ,  v.firm_nm,  v.use_yn, u1.user_nm bus_nm, u2.user_nm mng_nm  \n" +	
		        "     		  from cost_cmp_base a, users u1, users u2, cont_n_view v ,  car_reg cr,    \n" +	
		        "        		  (select  bus_id, rent_mng_id, rent_l_cd, gubun, sum(bus_amt)  bus_amt from   COST_CMP_BASE1   \n" +	
                "         	    where   save_dt = replace('" + save_dt + "','-','') and c_e_dt = replace('" + c_e_dt + "','-','')  group by  bus_id, rent_mng_id, rent_l_cd, gubun )  b1     \n" +	             
		        "    		where  a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd and  a.bus_id ='" + mng_id + "'  and a.bus_id = u1.user_id(+) and a.user_id = u2.user_id(+)   \n" +	
		     	" 			and a.rent_mng_id = b1.rent_mng_id(+) and a.rent_l_cd = b1.rent_l_cd(+)  and v.car_mng_id = cr.car_mng_id(+) \n" +	
		        "   	 	and a.save_dt = replace('" + save_dt + "','-','') and a.c_e_dt = replace('" + c_e_dt + "','-','') \n" +	
				"   		union all  \n" +	
			    " 			select  a.rent_l_cd, cr.car_no, a.rent_way, cr.car_nm, a.con_f_nm, v.rent_way_cd , v.rent_dt, \n" +	
		        "   			a.f_user_amt as f_amt, ( a.j_user_amt + a.sh_j_user_amt  )  j_amt ,  \n" +	
		        "    			case when b1.gubun = 'A' then b1.user_amt else 0  end  as a_amt,   case when b1.gubun = 'P' then b1.user_amt else 0  end as p_amt ,  v.firm_nm,  v.use_yn, u1.user_nm bus_nm, u2.user_nm mng_nm  \n" +	
		        "   		from cost_cmp_base a, users u1, users u2, cont_n_view v,   car_reg cr, \n" +	
		        "        		  (select  user_id, rent_mng_id, rent_l_cd, gubun, sum(user_amt)  user_amt from   COST_CMP_BASE1   \n" +	
                "         	    where   save_dt = replace('" + save_dt + "','-','') and c_e_dt = replace('" + c_e_dt + "','-','') and user_id  = '" + mng_id + "'  group by  user_id, rent_mng_id, rent_l_cd, gubun )  b1     \n" +	             
			    "    		 where  a.rent_mng_id = v.rent_mng_id and a.rent_l_cd = v.rent_l_cd and v.car_mng_id = cr.car_mng_id(+)  \n" +	 //
			    "			 and  case when b1.user_id <> a.user_id then b1.user_id  else a.user_id end = '" + mng_id + "'  and a.bus_id = u1.user_id(+) and a.user_id = u2.user_id(+)   \n" +
			 //   "            and  a.user_id  = '" + mng_id + "'  and a.bus_id = u1.user_id(+) and a.user_id = u2.user_id(+)   \n" +	
			   	" 			 and a.rent_mng_id = b1.rent_mng_id(+) and a.rent_l_cd = b1.rent_l_cd(+) \n" +	
		        "     		 and a.save_dt = replace('" + save_dt + "','-','') and a.c_e_dt = replace('" + c_e_dt + "','-','')   \n" +	
		        " ) a   \n" +			
         "  group by a.rent_way_cd , a.rent_dt , a.rent_l_cd, cr.car_no, a.rent_way, cr.car_nm, a.con_f_nm, a.firm_nm,  a.use_yn, a.bus_nm, a.mng_nm \n" +	
         "  order by a.rent_way_cd , a.rent_dt ";	
                    
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
			System.out.println("[CostDatabase:getCostBaseList]"+e);
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
	 *	캠페인 지급 현황 - 년도 관련 해서 수정해야 함. 보완할 것 :직급 등 -- 분기별 마감이 끝나지 않았다면 먼저 마감된건 확정으로..
	 */
	 
	public Vector getStatCmpList(String gubun1, String gubun2)
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
					 		
		query = "select u.user_id, u.user_nm, decode(u.loan_st, '1', '4', null, '5', u.loan_st) as loan_st, c.nm, decode(u.user_pos,'대표이사',1,'부장', 2, '차장', 3, '팀장', 4, '과장', 5 , '대리', 6, 9) pos_sort, u.enter_dt, \n" +
				" 		t.s0, t.d0, t.c0, t.p0, \n" +
				"	  sum(decode(to_char(s.c_mm) || s.gubun,  '12', nvl(s.amt,0),0)) as s1, \n" +
		       	"	  sum(decode(to_char(s.c_mm) || s.gubun,  '11', nvl(s.amt,0),0)) as d1, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '22', nvl(s.amt,0),0)) as s2, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '21', nvl(s.amt,0),0)) as d2, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '25', nvl(s.amt,0),0)) as c2, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '26', nvl(s.amt,0),0)) as p2, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '32', nvl(s.amt,0),0)) as s3, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '31', nvl(s.amt,0),0)) as d3, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '36', nvl(s.amt,0),0)) as p3, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '35', nvl(s.amt,0),0)) as c3, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '42', nvl(s.amt,0),0)) as s4, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '41', nvl(s.amt,0),0)) as d4, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '45', nvl(s.amt,0),0)) as c4, \n" +
		        "     sum(decode(to_char(s.c_mm) || s.gubun,  '46', nvl(s.amt,0),0)) as p4 \n" +
		      	"			from stat_cmp s, users u, code c,  \n" +
		      	"			(select user_id,  sum(decode(gubun , '2', amt , 0)) s0, sum(decode(gubun , '1', amt , 0))  d0 , sum(decode(gubun , '3', amt , 0))  c0, sum(decode(gubun , '4', amt , 0))  p0 from (  \n" +
             	"				select a.save_dt, '2'  as gubun, a.bus_id as user_id, to_number(a.amt2) as amt  from stat_bus_cmp a, ( select max(save_dt) max_dt from  stat_bus_cmp where save_dt like '" + gubun1+ "%' ) b where a.save_dt = max_dt    \n" +
             	"				union all  \n" +
             	"				select a.save_dt, '3'  as gubun, a.bus_id as user_id, a.p_amt as amt  from stat_bus_cost_cmp a, ( select max(save_dt) max_dt from  stat_bus_cost_cmp where save_dt like '" + gubun1+ "%' ) b where a.save_dt = max_dt    \n" +
 			    "				union all  \n" +
 			    "				select a.save_dt, '4'  as gubun, a.bus_id as user_id, a.pp_amt as amt  from stat_bus_prop a, ( select max(save_dt) max_dt from  stat_bus_prop where save_dt like '" + gubun1+ "%' ) b where a.save_dt = max_dt    \n" +
 			    "				union all  \n" +
             	"				select a.save_dt,  '1' as gubun , a.bus_id2 as user_id, a.amt_out as amt  from stat_settle a, ( select max(save_dt) max_dt from  stat_settle where save_dt like '" + gubun1 + "%' ) b where a.save_dt = max_dt    \n" +
             	"				union all  \n" +
             	" 				select a.save_dt,  '1' as gubun , a.partner_id as user_id , sum(a.amt_in) as amt  from stat_settle  a, ( select max(save_dt) max_dt from  stat_settle where save_dt like '" + gubun1 + "%' ) b where a.save_dt = max_dt   and  a.partner_id  is not null  \n" +
             	" 					group by a.save_dt, a.partner_id ) a  \n" +
  				"			group by  user_id     ) t  \n" +	 
  				"	where s.c_yy = '"+gubun1 + "' and s.user_id = t.user_id(+) and u.user_id = s.user_id(+) and c.c_st = '0002' and u.dept_id = c.code and  u.use_yn = 'Y' and u.dept_id not in ('8888', '0004', '0005') and  u.user_pos not in ('부장', '차장', '팀장' )  \n" +
		//		"	and t.user_id not in ( '000005', '000006', '000004', '000003', '000035' ) \n" +
				"	group by u.user_id, u.user_nm, u.loan_st, c.nm, decode(u.user_pos,'대표이사',1,'부장', 2, '차장', 3, '팀장', 4,  '과장', 5 , '대리', 6, 9), u.enter_dt, t.s0, t.d0 , t.c0 , t.p0 \n" +
				"	order by 3,5, 6   \n";
		
		try {
			stmt = conn.createStatement();
	    	rs = stmt.executeQuery(query);
	   	//	System.out.println("[AdminDatabase:getStatCmpList] "+ query);
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
			System.out.println("[CostDatabase:getStatCmpList]\n"+e);
			System.out.println(query);
	  		e.printStackTrace();
		} finally {
			try{
				if(rs != null )		rs.close();
				if(stmt != null)	stmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return vt;
		}
	}
		

     //  유류대정산 : -인경우 차감, +인경우 복지비에 반영 -2014년부터
	public Vector S_MoneyListM(String dt, String ref_dt1, String ref_dt2, String gubun1, String minus)
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
			
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("3")) {
			f_date1 = s_year+ "0101";
			t_date1 = s_year+ "1231";
		}
					
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}
			
		
	    if ( !gubun1.equals("9")) {
	      query = " select  u.user_id, u.id, u.user_nm, sum(a.amt) amt, sum(a.gong_amt) oil_amt,  sum(a.amt + a.gong_amt ) prize  from STAT_CMP a, users u \n"+
	       	       "  where a.user_id  = u.user_id and a.save_dt between replace('"+f_date1+"', '-','') and replace('"+t_date1+"', '-','') and gubun = '"+gubun1+"' ";
	       	       
	       	          if(minus.equals("Y")) {
	       	           	 query += " and (a.amt > 0  or a.gong_amt <> 0 )   group by u.user_id, u.id, u.user_nm  \n" ;
	       	          } else {
	       	          	 query += " and a.amt + a.gong_amt > 0  group by u.user_id, u.id, u.user_nm  \n" ;	       	          	
	       	          }		
	    } else {
	    	
	      query = " select  u.user_id, u.id, u.user_nm,  sum(a.jigub_amt) amt, 0 oil_amt,  sum(a.jigub_amt) prize   from prop_bbs a, users u \n"+
	       	       "  where a.reg_id  = u.user_id and a.jigub_dt between replace('"+f_date1+"', '-','') and replace('"+t_date1+"', '-','')  group by u.user_id, u.id, u.user_nm  ";
	    } 	    	
	    
	    //	query += "order by , 6 desc";	
	     	query += "order by case when amt = 0 then 9 else 0 end , 6 desc ";


	//		System.out.println("S_MoneyList="+query);

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CostDatabase:S_MoneyList]"+e);
			System.out.println("[CostDatabase:S_MoneyList]"+query);
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
	 *	인사관리 -> 특정수당 -> 특정수당 전체 리스트
	 */
	
	public Vector S_MoneySubList(String dt, String ref_dt1, String ref_dt2, String gubun1, String user_id)
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
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("3")) {
			f_date1 = s_year+ "0101";
			t_date1 = s_year+ "1231";
		}
		
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}
		
		
		
	    if ( !gubun1.equals("9")) {//캠페인포상
			query = " select  a.save_dt as dt, u.id, u.user_nm, a.amt as amt , a.gong_amt as oil_amt, a.amt + a.gong_amt  as prize , a.c_yy||'년도 '||a.c_mm||'분기' AS p_cont, nvl(p2.p_pay_dt,'') p_pay_dt \n"+
					" from    STAT_CMP a, users u, pay_item p, pay p2 \n"+
	       	        " where   a.save_dt between replace('"+f_date1+"', '-','') and replace('"+t_date1+"', '-','') \n"+
					"         and a.user_id='"+user_id+"' and a.user_id  = u.user_id \n"+
					"         and a.gubun = '"+gubun1+"' and   a.amt + a.gong_amt  > 0  and a.s_type = '1'  \n"+
					"         and '51'=p.p_st1(+) and a.save_dt=p.p_cd1(+) and a.gubun=p.p_cd2(+) and a.user_id=p.p_cd3(+)"+
					"         and p.reqseq=p2.reqseq(+) "+
					"   ";
	    } else { //제안포상
	    	
			query = " select  a.jigub_dt as dt, u.id, u.user_nm, a.jigub_amt as amt,  0 as oil_amt ,  a.jigub_amt as prize, a.title AS p_cont, nvl(p2.p_pay_dt,'') p_pay_dt \n"+
					" from    prop_bbs a, users u, pay_item p, pay p2 \n"+
	       	        " where   a.jigub_dt between replace('"+f_date1+"', '-','') and replace('"+t_date1+"', '-','')\n"+
					"         and a.reg_id='"+user_id+"' and a.reg_id  = u.user_id \n"+
					"         and '52'=p.p_st1(+) and a.jigub_dt=p.p_cd1(+) and a.prop_id=p.p_cd2(+) and a.reg_id=p.p_cd3(+)"+
					"         and p.reqseq=p2.reqseq(+) "+
					"   ";
	    } 	    		
		
		query += "order by 1 ";


		//	System.out.println("S_MoneyList="+query);

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CostDatabase:S_MoneySubList]"+e);
			System.out.println("[CostDatabase:S_MoneySubList]"+query);
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
	*	stat_cmp 통신비영수증 등록
	*/

	public int InsertMtel_Scan(String year, String mon, String user_id, String gubun, String type, int amt, String mtel_scan )
	{
			
		getConnection();

		PreparedStatement pstmt = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs = null;
     
        String query = "";
        String seqQuery = "";
        int count = 0;
        int seq = 0;
				
		query = "	insert into stat_cmp ( seq, c_yy,  c_mm,  gubun, user_id, s_type, amt, file_name, save_dt, gong_amt) "+   //
					   "    values ( ?, ?, ?, ?, ?, ?, ?, ?,  to_char(sysdate,'YYYYMMDD'), 0 )  ";  //				
		
		seqQuery = "select nvl(max(seq),0 ) + 1  from stat_cmp where save_dt = to_char(sysdate,'YYYYMMDD') and gubun = '8' ";     

		try{
			conn.setAutoCommit(false);
			
			pstmt1 = conn.prepareStatement(seqQuery);
			rs = pstmt1.executeQuery();
            
            if(rs.next())
            	seq = rs.getInt(1);
            rs.close();
			pstmt1.close();

			pstmt = conn.prepareStatement(query);
			
			pstmt.setInt(1, seq);
			pstmt.setString(2, year);
			pstmt.setString(3, mon);
			pstmt.setString(4, gubun);
			pstmt.setString(5, user_id);
			pstmt.setString(6, type);
			pstmt.setInt(7, amt);
			pstmt.setString(8, mtel_scan);
		

			count = pstmt.executeUpdate();

			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			count = 1;
			System.out.println("[CostDatabase:InsertMtel_Scan]"+e);
			System.out.println("[CostDatabase:InsertMtel_Scan]"+query);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
				if(rs != null) rs.close();
                if(pstmt1 != null) pstmt1.close();
                if(pstmt != null)  pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}


	
	/**
	*	stat_cmp 통신비영수증 시퀀스 찾기
	*/
public int Mtel_ScanSeq()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int seq = 0;
		
	
	 query = " select nvl(max(seq),0 ) + 1  from stat_cmp where save_dt = to_char(sysdate,'YYYYMMDD') and gubun = '8'	";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
            	seq = rs.getInt(1);
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CostDatabase:Mtel_ScanSeq]"+e);
			System.out.println("[CostDatabase:Mtel_ScanSeq]"+query);
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

	
	/**
	*	stat_cmp 통신비영수증등록 리스트
	*/
public Vector Mtel_ScanList(String dt, String ref_dt1, String ref_dt2, String gubun1, String minus)
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
		
		if(dt.equals("1")||dt.equals("2")) {
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("3")) {
			f_date1 = s_year+ "0101";
			t_date1 = s_year+ "1231";
		}
		
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}
	
	if(!dt.equals("1")) {
      query = " select  u.user_id, u.id, b.br_nm, c.nm  as dept_nm, u.user_nm, a.file_name, a.seq, a.save_dt, a.gubun, a.c_yy, a.c_mm " +
                    "   from STAT_CMP a, users u , branch b,   ( select c_st, code, nm_cd, nm from code where c_st = '0002' and code <> '0000'  ) c \n"+
	       	       "  where a.user_id  = u.user_id  and u.br_id = b.br_id and u.dept_id = c.code  and a.save_dt between replace('"+f_date1+"', '-','') and replace('"+t_date1+"', '-','') and gubun = '"+gubun1+"' ";
		
	}else{
	 query = " SELECT u.user_id, u.id, b.br_nm, c.nm  as dept_nm, u.user_nm, a.file_name, a.seq, a.save_dt, a.gubun, a.c_yy, a.c_mm " + 
	                "  FROM  (SELECT * FROM STAT_CMP WHERE gubun='8' AND save_dt BETWEEN replace('20130701', '-','') AND replace('20130731', '-','')  ) a,  "+
			 " (SELECT * FROM USERS WHERE loan_st IS NOT NULL AND dept_id NOT IN('8888','9999','1000') ) u ,   branch b,   ( select c_st, code, nm_cd, nm from code where c_st = '0002' and code <> '0000'  ) c  " +
			 "   WHERE a.user_id (+)= u.user_id  and u.br_id = b.br_id and u.dept_id = c.code  AND a.file_name  is  null	";
	 }
		
		query += "order by decode(u.br_id,'S1',1,'S2',2,'B1',7,'D1',6,'J1',4,'G1',5,'I1',3),u.dept_id, 2 desc";


//	System.out.println("S_MoneyList="+query);

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CostDatabase:Mtel_ScanList]"+e);
			System.out.println("[CostDatabase:Mtel_ScanList]"+query);
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

//통신부 영수증 삭제
 public int deleteMtel_scan(String file)
    {
      	getConnection();
    		
        PreparedStatement pstmt = null;
        String query = "";
    
        int count = 0;
                
        query="delete stat_cmp  \n"
            + "WHERE file_name=? and gubun ='8' ";
 

       try{
            conn.setAutoCommit(false);
            
           
            pstmt = conn.prepareStatement(query);

            pstmt.setString(1, file);
            
            count = pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

     	}catch(SQLException e){
			System.out.println("[CostDatabase:deleteMtel_scan]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}
//통신비 영수증 삭제
 public int deleteMtel_scan(String save_dt,String seq,String c_yy, String c_mm)
    {
      	getConnection();
    		
        PreparedStatement pstmt = null;
        String query = "";
    
        int count = 0;
                
        query="delete stat_cmp  \n"
            + "WHERE save_dt=? and seq =? and c_yy =? and c_mm =? and gubun ='8' ";
 

       try{
            conn.setAutoCommit(false);
            
           
            pstmt = conn.prepareStatement(query);

            pstmt.setString(1, save_dt);
			pstmt.setString(2, seq);
			pstmt.setString(3, c_yy);
			pstmt.setString(4, c_mm);
            
            count = pstmt.executeUpdate();
             
            pstmt.close();
            conn.commit();

     	}catch(SQLException e){
			System.out.println("[CostDatabase:deleteMtel_scan]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}


	/**
	*	year_jungsan 통신비영수증 등록
	*/

	public int InsertYear_jungsan_Scan(String year, String dept_id, String sa_no, String reg_id, String file_name1, String file_name2, String file_name3, String file3_yn, String file_name4, String file4_yn, String file_name5, String file5_yn, String file_name6, String file6_yn, String file_name7, String file7_yn, String file_name8, String file8_yn, String change_his )
	{
			
		getConnection();
		PreparedStatement pstmt = null;
        String query = "";
        int count = 0;
				
		query = "	insert into year_jungsan ( c_yy, dept_id, sa_no, reg_id, reg_dt, file_name1, file_name2, file_name3, file3_yn, "+
				"   file_name4, file4_yn, file_name5, file5_yn, file_name6, file6_yn, file_name7, file7_yn, file_name8, file8_yn, change_his) "+   //
				"    values ( ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), ?, ?, ?, ?,  ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )  ";  //				

		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, year);
			pstmt.setString(2, dept_id);
			pstmt.setString(3, sa_no);
			pstmt.setString(4, reg_id);
			pstmt.setString(5, file_name3);
			pstmt.setString(6, file_name4);
			pstmt.setString(7, file_name5);
			pstmt.setString(8, file3_yn);
			pstmt.setString(9, file_name6);
			pstmt.setString(10, file4_yn);
			pstmt.setString(11, file_name7);
			pstmt.setString(12, file5_yn);
			pstmt.setString(13, file_name8);
			pstmt.setString(14, file6_yn);
			pstmt.setString(15, file_name1);
			pstmt.setString(16, file7_yn);
			pstmt.setString(17, file_name2);
			pstmt.setString(18, file8_yn);
			pstmt.setString(19, change_his);

			count = pstmt.executeUpdate();

			pstmt.close();
			conn.commit();

		}catch(SQLException e){
			count = 1;
			System.out.println("[CostDatabase:InsertYear_jungsan_Scan]"+e);
			System.out.println("[CostDatabase:InsertYear_jungsan_Scan]"+query);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
                if(pstmt != null)  pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}

//연말정산리스트
public Vector Year_jungsan_List(String c_yy)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	
      query = " select  * from year_jungsan where c_yy = '"+c_yy+"'  order by reg_dt, sa_no ";
		
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CostDatabase:Year_jungsan_List]"+e);
			System.out.println("[CostDatabase:Year_jungsan_List]"+query);
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

//확정완료처리
public int updateEnd_dt(String c_yy, String sa_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";


		query = " update year_jungsan set\n"+
				" update_dt = to_char(sysdate,'YYYYMMDD'), \n"+
			    " end_dt = to_char(sysdate,'YYYYMMDD') \n"+
				" where c_yy = ? and sa_no=?";		

		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, c_yy);
			pstmt.setString(2, sa_no);


			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[CostDatabase:updateEnd_dt]\n"+e);
			System.out.println("[CostDatabase:updateEnd_dt]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
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

	//확정완료처리_취소
public int updateEnd_dt_cancel(String c_yy, String sa_no)
	{
		getConnection();
		PreparedStatement pstmt = null;
		int count = 0;
		String query = "";


		query = " update year_jungsan set\n"+
				" update_dt = to_char(sysdate,'YYYYMMDD'), \n"+
			    " end_dt = '' \n"+
				" where c_yy = ? and sa_no=?";		

		try 
		{		
			conn.setAutoCommit(false);	
		
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, c_yy);
			pstmt.setString(2, sa_no);


			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[CostDatabase:updateEnd_dt_cancel]\n"+e);
			System.out.println("[CostDatabase:updateEnd_dt_cancel]\n"+query);
	  		e.printStackTrace();
	  		count = 0;
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
	 *	인사관리 -> 특정수당 -> 특정수당 전체 리스트
	 */
	
	public Vector S_MoneyList(String dt, String ref_dt1, String ref_dt2, String gubun1)
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
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("3")) {
			f_date1 = s_year+ "0101";
			t_date1 = s_year+ "1231";
		}
		
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}
	
		
	    if ( !gubun1.equals("9")) {
	      query = " select  u.user_id, u.id, u.user_nm, sum(a.amt) amt, sum(a.gong_amt) oil_amt,  sum(a.amt + a.gong_amt ) prize from STAT_CMP a, users u \n"+
	       	       "  where a.user_id  = u.user_id and a.save_dt between replace('"+f_date1+"', '-','') and replace('"+t_date1+"', '-','') and gubun = '"+gubun1+"' and  a.amt + a.gong_amt > 0 group by u.user_id, u.id, u.user_nm  ";
	    } else {
	    	
	      query = " select  u.user_id, u.id, u.user_nm,  sum(a.jigub_amt) amt, 0 oil_amt,  sum(a.jigub_amt) prize from prop_bbs a, users u \n"+
	       	       "  where a.reg_id  = u.user_id and a.jigub_dt between replace('"+f_date1+"', '-','') and replace('"+t_date1+"', '-','')  group by u.user_id, u.id, u.user_nm  ";
	    } 	    		
		
		query += "order by case when amt= 0 then 9 else 0 end , 6 desc";


		//	System.out.println("S_MoneyList="+query);

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CostDatabasebase:S_MoneyList]"+e);
			System.out.println("[CostDatabase:S_MoneyList]"+query);
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
	 *	인사관리 -> 특정수당 -> 특정수당 전체 리스트 - 급여계좌포함
	 */
	
	public Vector S_MoneyList1(String dt, String ref_dt1, String ref_dt2, String gubun1)
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
			f_date1 = s_year+ s_month + "01";
			t_date1 = s_year+ s_month + "31";
		}
		
		if(dt.equals("3")) {
			f_date1 = s_year+ "0101";
			t_date1 = s_year+ "1231";
		}
		
		if(dt.equals("4")) {
			f_date1=  ref_dt1;
			t_date1=  ref_dt2;
		}
			 		
		
	/*
	    if ( !gubun1.equals("9")) {
	      query = " select  p.bank, p.bank_no, p.user_nm,  sum(a.amt + ( case when a.gong_amt < 0 then  a.gong_amt  else 0 end ) ) prize   from STAT_CMP a, users u,  user_pay p \n"+
	       	       "  where a.user_id  = u.user_id  and u.id = p.id and a.save_dt between replace('"+f_date1+"', '-','') and replace('"+t_date1+"', '-','') and gubun = '"+gubun1+"' and a.amt > 0  group by p.bank, p.bank_no, p.user_nm  ";
	    } else {
	    	
	      query = " select    p.bank, p.bank_no, p.user_nm,  sum(a.jigub_amt) prize from prop_bbs a, users u,  user_pay p  \n"+
	       	       "  where a.reg_id  = u.user_id  and u.id = p.id  and a.jigub_dt between replace('"+f_date1+"', '-','') and replace('"+t_date1+"', '-','')  group by p.bank, p.bank_no, p.user_nm  ";
	    } 	    		
	    */
				
	    if ( !gubun1.equals("9")) {
	      query = " select  '88' bank,  replace(u.bank_no, '-', '') bank_no ,  u.user_nm,  sum(a.amt + ( case when a.gong_amt < 0 then  a.gong_amt  else 0 end ) ) prize ,  u.id   from STAT_CMP a, users u \n"+
	       	       "  where a.user_id  = u.user_id and a.save_dt between replace('"+f_date1+"', '-','') and replace('"+t_date1+"', '-','') and gubun = '"+gubun1+"' and a.amt > 0  group by  u.bank_no, u.user_nm , u.id ";
	    } else {
	    	
	      query = " select    '88' bank, replace(u.bank_no, '-', '') bank_no, u.user_nm,  sum(a.jigub_amt) prize ,  u.id  from prop_bbs a, users u  \n"+
	       	       "  where a.reg_id  = u.user_id    and a.jigub_dt between replace('"+f_date1+"', '-','') and replace('"+t_date1+"', '-','')  group by u.bank_no, u.user_nm , u.id ";
	    } 	    		
		
		query += "order by 4 desc";


		//	System.out.println("S_MoneyList1="+query);

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CostDatabasebase:S_MoneyList1]"+e);
			System.out.println("[CostDatabase:S_MoneyList1]"+query);
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
	 *	인사관리 -> 특정수당 -> 특정수당 전체 리스트 - 급여계좌포함
	 */
	
	public Vector S_MoneyList3()
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
			 	    	
	    query = " select    '88' bank, replace(u.bank_no, '-', '') bank_no, u.user_nm,  0 prize ,  u.id  from  users u  \n"+
	       	       "  where  u.use_yn = 'Y' and u.dept_id not in  ( '1000', '8888' )  and u.id not like 'devel%' and u.user_id not in ( '000177', '000035')  order by u.enter_dt ";
	     	    		
	
		//	System.out.println("S_MoneyList1="+query);

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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CostDatabasebase:S_MoneyList1]"+e);
			System.out.println("[CostDatabase:S_MoneyList1]"+query);
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
	
	public Vector getCostManCampaignNewJ(String save_dt, String gubun, int base_cnt, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	  
		if (gubun.equals("J")) { //고객지원팀
			
				 query = " select case when  ( aa.rent_way_1_cnt + aa.rent_way_2_cnt ) >= " + base_cnt + "  then '0' else '9' end po , aa.ave_amt  r_one_per_cost, aa.c_ave_amt one_per_cost ,\n"+
				         " trunc(aa.all_i_amt / aa.su_1_cnt)  ave_all_i_amt, trunc(aa.all_b_amt / aa.su_2_cnt)  ave_all_b_amt, \n"+
				         " trunc(aa.way1_amt / aa.rent_way_1_cnt)  ave_i_amt, trunc(aa.way2_amt / aa.rent_way_2_cnt) ave_b_amt,  \n"+
				     //    " trunc((aa.r_all_b_amt + aa.r_all_i_amt ) /  ( aa.su_1_cnt + aa.su_2_cnt)) one_per_cost,	\n"+			       
				  		 " aa.* from ( \n"+
						 "	 select decode(b.user_pos,'대표이사',1,'부장', 2, '차장', 3, '과장', 4 , '대리', 5, 9) pos_sort, c.su_1_cnt, c.su_2_cnt, c.all_i_amt, c.all_b_amt,  \n"+
						 "	 a.*, b.dept_id, b.user_nm, b.user_id  \n"+
						 "	 from stat_bus_cost_j_cmp a, users b, \n"+ 
						 "	 (select sum(a.way1_amt) all_i_amt, sum(a.way2_amt) all_b_amt, sum(rent_way_1_cnt) su_1_cnt, sum(rent_way_2_cnt) su_2_cnt from stat_bus_cost_j_cmp a,  users b where a.bus_id=b.user_id and a.gubun = '"+gubun+"' and a.save_dt='"+save_dt+"'  and b.use_yn = 'Y'  ) c \n"+
						 "	  where a.bus_id=b.user_id  and a.gubun =  '"+gubun+"' and a.save_dt='"+save_dt+"' and b.use_yn = 'Y'   ) aa \n ";
	
		}else {
			//관리대수가 50대가 미만인 경우는 포상제외
			  query = " select case when  ( aa.rent_way_1_cnt + aa.rent_way_2_cnt ) >= " + base_cnt + "  then '0' else '9' end po, aa.ave_amt  r_one_per_cost, aa.c_ave_amt one_per_cost ,\n"+
				      //   " 0  ave_all_i_amt, trunc((aa.all_b_amt + aa.all_i_amt)/ (aa.su_2_cnt+ aa.su_1_cnt))  ave_all_b_amt, \n"+
				      //   " 0  ave_i_amt, trunc( (aa.way2_amt + aa.way1_amt) / (aa.rent_way_1_cnt + aa.rent_way_2_cnt )) ave_b_amt,  \n"+
				         " trunc(aa.all_i_amt / aa.su_1_cnt)  ave_all_i_amt, trunc(aa.all_b_amt / aa.su_2_cnt)  ave_all_b_amt, \n"+
				         " trunc(aa.way1_amt / decode(aa.rent_way_1_cnt, 0, 1 ,aa.rent_way_1_cnt))  ave_i_amt, trunc(aa.way2_amt / aa.rent_way_2_cnt) ave_b_amt,  \n"+
				     //    " trunc((aa.r_all_b_amt + aa.r_all_i_amt ) /  ( aa.su_1_cnt + aa.su_2_cnt)) one_per_cost,	\n"+			       
				  		 " aa.* from ( \n"+
						 "	 select decode(b.user_pos,'대표이사',1,'부장', 2, '차장', 3, '과장', 4 , '대리', 5, 9) pos_sort, c.su_1_cnt, c.su_2_cnt, c.all_i_amt, c.all_b_amt,  \n"+
						 "	 a.*, b.dept_id, b.user_nm, b.user_id \n"+
						 "	 from stat_bus_cost_j_cmp a, users b, \n"+ 
						 "	 (select sum(a.way1_amt) all_i_amt, sum(a.way2_amt) all_b_amt, sum(rent_way_1_cnt) su_1_cnt, sum(rent_way_2_cnt) su_2_cnt from stat_bus_cost_j_cmp a,  users b where a.bus_id=b.user_id and a.gubun = '"+gubun+"' and a.save_dt='"+save_dt+"'  and b.use_yn = 'Y' and ( a.rent_way_1_cnt + a.rent_way_2_cnt ) >=  " + base_cnt + "  ) c \n"+
						 "	  where a.bus_id=b.user_id  and a.gubun =  '"+gubun+"' and a.save_dt='"+save_dt+"' and b.use_yn = 'Y'  ) aa \n ";
						 
		
		}	
	
		query += " order by 1 , 2 ";
		
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
			System.out.println("[CostDatabase:getCostManCampaignNew(String save_dt, String gubun, int base_cnt, String s_dt, String e_dt)]"+e);
			System.out.println(query);
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
	
	public Vector getCostManCampaignNewA(String save_dt, String gubun, int base_cnt, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	  
		if (gubun.equals("J")) { //고객지원팀
			
				 query = " select case when  ( aa.rent_way_1_cnt + aa.rent_way_2_cnt ) >= " + base_cnt + "  then '0' else '9' end po , aa.ave_amt  r_one_per_cost, aa.c_ave_amt one_per_cost ,\n"+
				         " trunc(aa.all_i_amt / aa.su_1_cnt)  ave_all_i_amt, trunc(aa.all_b_amt / aa.su_2_cnt)  ave_all_b_amt, \n"+
				         " trunc(aa.way1_amt / aa.rent_way_1_cnt)  ave_i_amt, trunc(aa.way2_amt / aa.rent_way_2_cnt) ave_b_amt,  \n"+
				     //    " trunc((aa.r_all_b_amt + aa.r_all_i_amt ) /  ( aa.su_1_cnt + aa.su_2_cnt)) one_per_cost,	\n"+			       
				  		 " aa.* from ( \n"+
						 "	 select decode(b.user_pos,'대표이사',1,'부장', 2, '차장', 3, '과장', 4 , '대리', 5, 9) pos_sort, c.su_1_cnt, c.su_2_cnt, c.all_i_amt, c.all_b_amt,  \n"+
						 "	 a.*, b.dept_id, b.user_nm, b.user_id  \n"+
						 "	 from stat_bus_cost_a_cmp a, users b, \n"+ 
						 "	 (select sum(a.way1_amt) all_i_amt, sum(a.way2_amt) all_b_amt, sum(rent_way_1_cnt) su_1_cnt, sum(rent_way_2_cnt) su_2_cnt from stat_bus_cost_a_cmp a,  users b where a.bus_id=b.user_id and a.gubun = '"+gubun+"' and a.save_dt='"+save_dt+"'  and b.use_yn = 'Y'  ) c \n"+
						 "	  where a.bus_id=b.user_id  and a.gubun =  '"+gubun+"' and a.save_dt='"+save_dt+"' and b.use_yn = 'Y'   ) aa \n ";
	
		}else {
			//관리대수가 50대가 미만인 경우는 포상제외
			  query = " select case when  ( aa.rent_way_1_cnt + aa.rent_way_2_cnt ) >= " + base_cnt + "  then '0' else '9' end po, aa.ave_amt  r_one_per_cost, aa.c_ave_amt one_per_cost ,\n"+
				      //   " 0  ave_all_i_amt, trunc((aa.all_b_amt + aa.all_i_amt)/ (aa.su_2_cnt+ aa.su_1_cnt))  ave_all_b_amt, \n"+
				      //   " 0  ave_i_amt, trunc( (aa.way2_amt + aa.way1_amt) / (aa.rent_way_1_cnt + aa.rent_way_2_cnt )) ave_b_amt,  \n"+
				         " trunc(aa.all_i_amt / aa.su_1_cnt)  ave_all_i_amt, trunc(aa.all_b_amt / aa.su_2_cnt)  ave_all_b_amt, \n"+
				         " trunc(aa.way1_amt / decode(aa.rent_way_1_cnt, 0, 1 ,aa.rent_way_1_cnt))  ave_i_amt, trunc(aa.way2_amt / aa.rent_way_2_cnt) ave_b_amt,  \n"+
				     //    " trunc((aa.r_all_b_amt + aa.r_all_i_amt ) /  ( aa.su_1_cnt + aa.su_2_cnt)) one_per_cost,	\n"+			       
				  		 " aa.* from ( \n"+
						 "	 select decode(b.user_pos,'대표이사',1,'부장', 2, '차장', 3, '과장', 4 , '대리', 5, 9) pos_sort, c.su_1_cnt, c.su_2_cnt, c.all_i_amt, c.all_b_amt,  \n"+
						 "	 a.*, b.dept_id, b.user_nm, b.user_id \n"+
						 "	 from stat_bus_cost_a_cmp a, users b, \n"+ 
						 "	 (select sum(a.way1_amt) all_i_amt, sum(a.way2_amt) all_b_amt, sum(rent_way_1_cnt) su_1_cnt, sum(rent_way_2_cnt) su_2_cnt from stat_bus_cost_a_cmp a,  users b where a.bus_id=b.user_id and a.gubun = '"+gubun+"' and a.save_dt='"+save_dt+"'  and b.use_yn = 'Y' and ( a.rent_way_1_cnt + a.rent_way_2_cnt ) >=  " + base_cnt + "  ) c \n"+
						 "	  where a.bus_id=b.user_id  and a.gubun =  '"+gubun+"' and a.save_dt='"+save_dt+"' and b.use_yn = 'Y'  ) aa \n ";
						 
		
		}	
	
		query += " order by 1 , 2 ";
		
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
			System.out.println("[CostDatabase:getCostManCampaignNew(String save_dt, String gubun, int base_cnt, String s_dt, String e_dt)]"+e);
		//	System.out.println(query);
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
	* 관리비용 캠페인 정비 마감       
	*
	*/
	
		/*
	 *	비용마감 프로시져 호출 - 계약별
	*/
	public String call_sp_cost_base1_magam(String s_day, String s_user_id)
	{
    	getConnection();
    	
    	String query = "{CALL P_MAN_COST_BASE1_MAGAM (?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, s_day);
			cstmt.setString(2, s_user_id);
			cstmt.registerOutParameter( 3, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[CostDatabase:call_sp_cost_base1_magam]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	
	
	
		/*
	 *	비용마감 프로시져 호출 - 계약별
	*/
	public String call_sp_cost_base2_magam(String s_day, String s_user_id)
	{
    	getConnection();
    	
    	String query = "{CALL P_MAN_COST_BASE2_MAGAM (?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, s_day);
			cstmt.setString(2, s_user_id);
			cstmt.registerOutParameter( 3, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[CostDatabase:call_sp_cost_base2_magam]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
	
	
	
		/*
	 *	비용마감 프로시져 호출 - 계약별
	*/
	public String call_sp_cost_base3_magam(String s_day, String s_user_id)
	{
    	getConnection();
    	
    	String query = "{CALL P_MAN_COST_BASE3_MAGAM (?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
			cstmt = conn.prepareCall(query);
			
			cstmt.setString(1, s_day);
			cstmt.setString(2, s_user_id);
			cstmt.registerOutParameter( 3, java.sql.Types.VARCHAR );
			
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값
			cstmt.close();
		
	
		} catch (SQLException e) {
			System.out.println("[CostDatabase:call_sp_cost_base3_magam]\n"+e);
			e.printStackTrace();
		} finally {
			try{
			     if(cstmt != null)	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}	
		
	// 사고수리비 절감 캠페인
	public Vector getDlyCostStatAList3(String save_dt, String mng_id, int amt1, int amt2, int amt1_per , int amt2_per, int amt3_per, int bus_cost_per, int mng_cost_per , String gg, String mng_br_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
							   
	         if ( gg.equals("07") ) {       //탁송
	  	//	 query = "select b.j_dt, b.rent_l_cd, decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0) amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
	  		 query = "select b.j_dt, b.rent_l_cd, nvl( user_amt , 0) amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
	  		 	      "	from COST_CMP_BASE_J b , cont_n_view c , car_reg cr   \n"+ 
                          	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and gubun  in  ('C10', 'C7', 'C5', 'C12' )     \n"+ 
                                            " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd    and b.chk = '4'   and c.car_mng_id = cr.car_mng_id \n"+ 
                                            "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";                       
	         } else    if ( gg.equals("08") ) {  //유류대 - 탁송:청구일자 금액 setting   	         	
	/*         	  query = "   select  b.*, c.use_yn, c.firm_nm, c.car_no, c.car_nm from COST_CMP_BASE_J b , cont_view c \n"+ 
                          	       "    where  b.save_dt = replace('" + save_dt + "','-','') and gubun  in ('O10', 'O7', 'O5', 'O12' )  \n"+ 
                                   "       and b.user_id = '" + mng_id + "'  and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd  ";       */
                   //  query = "select b.j_dt,  b.rent_l_cd, decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0) amt , b.rent_way, b.etc,   c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
                     query = "select b.j_dt,  b.rent_l_cd,  nvl(, user_amt , 0) amt , b.rent_way, b.etc,   c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
	  		 	      "	from COST_CMP_BASE_J b , cont_n_view c , car_reg cr    \n"+ 
                          	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and gubun  in   ('O10', 'O7', 'O5', 'O12' )  and c.car_mng_id = cr.car_mng_id  \n"+ 
                                            " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd       and b.chk = '4'  \n"+ 
                                            "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";                                    	
                  } else    if ( gg.equals("05") ) {  //대차비용   	         	
	     //    	      query = "select b.j_dt, b.rent_l_cd, decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0) amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
	         	      query = "select b.j_dt, b.rent_l_cd, nvl(user_amt , 0) amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
	  		 	      "	from COST_CMP_BASE_J b , cont_n_view c , car_reg cr    \n"+ 
                          	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and gubun  in   ('R3' )  \n"+ 
                                            " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd      and b.chk = '4'  and c.car_mng_id = cr.car_mng_id  \n"+ 
                                            "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";        
                  } else    if ( gg.equals("06") ) {  //대차료   	         	
	         	   //   query = "select b.j_dt, b.rent_l_cd, (decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0)) * (-1)  amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
	         	       query = "select b.j_dt, b.rent_l_cd,  nvl( user_amt , 0) * (-1)  amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
	  		 	      "	from COST_CMP_BASE_J b , cont_n_view c  , car_reg cr   \n"+ 
                          	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and gubun  in   ('PP' )  \n"+ 
                                            " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd     and b.chk = '4'  and c.car_mng_id = cr.car_mng_id  \n"+ 
                                            "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";                                                                         
                                                                         
                  } else    if ( gg.equals("01") ) {  //사고   	       
                  	 query = "   select  b.serv_dt j_dt, a.rent_l_cd, a.use_yn,  a.rent_way, cr.car_no,cr.car_nm, a.firm_nm, '사고수리비' etc ,    \n"+ 
 		//	"		 decode( b.bus_id, '" + mng_id + "', (nvl(b.real_amt, 0)+nvl(b.ave_amt, 0)) *"+ bus_cost_per+"/100 , 0 ) +  decode( b.user_id, '" + mng_id + "', (nvl(b.real_amt, 0)+nvl(b.ave_amt, 0)) *"+mng_cost_per+"/100 , 0 )  amt,  b.fault_per per    \n"+ 
 			"		decode(b.rent_l_cd , 'K315B52R00016', -3100000 , nvl(b.real_amt, 0)+nvl(b.ave_amt, 0) )   amt,  b.fault_per per    \n"+ 
			"		  from (    \n"+ 
			"		  select   b.rent_mng_id, b.rent_l_cd,  b.bus_id, b.user_id, b.car_mng_id, b.serv_dt , b.fault_per,     \n"+ 		
			"	     case   when abs( (b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) )  >"+ amt2+"   \n"+ 
			"	         then   \n"+ 
			"	            case when (b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) )   > "+ amt2+"   \n"+ 
			"	                    then   "+amt2+"          + (((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) -  "+amt2+" )* "+amt2_per+"/100)  \n"+ 
			"	                    else   "+amt2+"* (-1)  +  (((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) +  "+amt2+" )*"+amt2_per+"/100)  end   \n"+ 
			"	         else  ( b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) end  * 50 /100  real_amt ,		 \n"+ 	     
			"	   case  when abs( (b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) ) > "+ amt2+"   \n"+ 
			"	        then   \n"+ 
			"	            case when (b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) )   >"+ amt2+"   \n"+ 
			"	                    then  "+amt2+"   +           (((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) - "+amt2+"  )*"+amt2_per+" /100)  \n"+ 
			"	                    else   "+amt2+"* (-1)   +  (((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) +  "+amt2+" )*"+amt2_per+" /100)  end    \n"+    
			"		      else  ( b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) end  * 50 /100 ave_amt  \n"+ 			
	//		"		    (  case  when  abs((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) ) > "+ amt2+"  then  "+ amt2 + " + abs( ( (((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) )  - "+amt2+"))*"+amt2_per+"/100)       \n"+ 
	//		"		          else  ( b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) end  ) * 50 /100  real_amt ,    \n"+ 
	//		"		    (  case  when abs( (b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) ) >  "+ amt2+"  then "+ amt2 + " + abs( ( (((b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) )   - "+amt2+"))*"+amt2_per+"/100)          \n"+ 
	//		"		          else  ( b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) end ) * 50 /100 ave_amt     \n"+ 
			"		      FROM  COST_CMP_BASE_A  b    \n"+ 
			"		      where  b.save_dt = replace('" + save_dt + "','-','')  and b.gubun not in ( 'P1' , 'DA')    and b.chk = '4'   ) b  , cont_n_view a, car_reg cr    \n"+ 
			"		  where b.rent_mng_id = a.rent_mng_id and b.rent_l_cd = a.rent_l_cd and b.car_mng_id = cr.car_mng_id  \n"+ 
			"		   and ( b.bus_id = '" + mng_id + "'  or  b.user_id = '" + mng_id +  "' )   \n"+ 
			"   union all   \n"+ 
    		"    select  b.serv_dt j_dt, a.rent_l_cd, a.use_yn,  a.rent_way, cr.car_no,cr.car_nm, a.firm_nm, '사고수리비차감' etc ,     \n"+ 
 		   	"		  nvl(b.real_amt, 0) * (-1)  amt,  b.fault_per per     \n"+ 
			"		  from (     \n"+ 
			"		  select   b.rent_mng_id, b.rent_l_cd,  b.bus_id, b.user_id, b.car_mng_id, b.serv_dt , b.fault_per,  \n"+ 
			"		      case  when  b.tot_amt  > 300000  then  300000 + ( (b.tot_amt  - 300000)*10/100)     else   b.tot_amt end  real_amt ,     0  ave_amt     \n"+ 
			"		      FROM  COST_CMP_BASE_A  b    \n"+ 
			"		      where  b.save_dt =  replace('" + save_dt + "','-','')   and b.gubun in ( 'DA')    and b.chk = '4'   ) b  , cont_n_view a, car_reg cr      \n"+ 
			"		  where b.rent_mng_id = a.rent_mng_id and b.rent_l_cd = a.rent_l_cd and b.car_mng_id = cr.car_mng_id    \n"+ 
			"		   and ( b.bus_id = '" + mng_id + "'  or  b.user_id = '" + mng_id +  "' )  \n  "; 
	            	        	                         		        	
	         } 
	  	                          
	  	query += "  order by  1, 2";
	  	
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
			System.out.println("[CostDatabase:getDlyCostStatAList3]"+e);
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
	
	
		// 일반정비비 절감 캠페인
	public Vector getDlyCostStatJList3(String save_dt, String mng_id, int amt1, int amt2, int amt1_per , int amt2_per, int amt3_per, int bus_cost_per, int mng_cost_per , String gg, String mng_br_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
							   
	         if ( gg.equals("07") ) {       //탁송
	  	//	 query = "select b.j_dt, b.rent_l_cd, decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0) amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
	  		  query = "select b.j_dt, b.rent_l_cd,  nvl( user_amt , 0) amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
	  		 	      "	from COST_CMP_BASE_J b , cont_n_view c , car_reg cr    \n"+ 
                          	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and gubun  like 'C%' and gubun not in ('C10', 'C7', 'C5', 'C12' )      \n"+ 
                                            " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd   and b.chk = '1' and c.car_mng_id = cr.car_mng_id  \n"+ 
                                            "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";                       
	         } else    if ( gg.equals("08") ) {  //유류대 - 탁송:청구일자 금액 setting            	
	
              //       query = "select b.j_dt,  b.rent_l_cd, decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0) amt , b.rent_way, b.etc,   c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
                          query = "select b.j_dt,  b.rent_l_cd,  nvl( user_amt , 0) amt , b.rent_way, b.etc,   c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
	  		 	      "	from COST_CMP_BASE_J b , cont_n_view c , car_reg cr   \n"+ 
                          	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and gubun  like 'O%' and gubun not in ('O10', 'O7', 'O5', 'O12' ) \n"+ 
                                            " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd    and b.chk = '1'  and c.car_mng_id = cr.car_mng_id  \n"+ 
                                            "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";             
                    } else    if ( gg.equals("10") ) {  //긴급출동
	
             //        query = "select b.j_dt,  b.rent_l_cd, decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0) amt , b.rent_way, b.etc,   c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
                       query = "select b.j_dt,  b.rent_l_cd,  nvl( user_amt , 0) amt , b.rent_way, b.etc,   c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
	  		 	      "	from COST_CMP_BASE_J b , cont_n_view c   , car_reg cr  \n"+ 
                          	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and b.gubun like 'EM%'  \n"+ 
                                            " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd    and b.chk = '1' and c.car_mng_id = cr.car_mng_id    \n"+ 
                                            "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";                   
                     } else    if ( gg.equals("03") ) {  //검사비
	
             //        query = "select b.j_dt,  b.rent_l_cd, decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0) amt , b.rent_way, b.etc,   c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
                        query = "select b.j_dt,  b.rent_l_cd, nvl( user_amt , 0) amt , b.rent_way, b.etc,   c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
	  		 	      "	from COST_CMP_BASE_J b , cont_n_view c , car_reg cr    \n"+ 
                          	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and b.gubun like 'SS%'  \n"+ 
                                            " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd    and b.chk = '1' and c.car_mng_id = cr.car_mng_id   \n"+ 
                                            "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";                                                                                               	
                  } else    if ( gg.equals("05") ) {  //대차   	         	
	         	   //   query = "select b.j_dt, b.rent_l_cd, decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0) amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
	         	      query = "select b.j_dt, b.rent_l_cd,  nvl( user_amt , 0) amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
	  		 	      "	from COST_CMP_BASE_J b , cont_n_view c  , car_reg cr  \n"+ 
                          	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and gubun  in   ('R2' )  \n"+ 
                                            " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd     and b.chk = '1' and c.car_mng_id = cr.car_mng_id  \n"+ 
                                            "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";        
                  } else    if ( gg.equals("01") ) {  //정비비
                  	 //	query = "select b.j_dt, b.rent_l_cd, decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0) amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
                  	 	query = "select b.j_dt, b.rent_l_cd,  nvl( user_amt , 0) amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
	  		 	      "	from COST_CMP_BASE_J b , cont_n_view c , car_reg cr    \n"+ 
                          	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and gubun  in ('J1', 'J2', 'J3' , 'J4' )      \n"+ 
                                            " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd     and b.chk = '1' and c.car_mng_id = cr.car_mng_id  \n"+ 
                                            "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";                      
                                            
                        	        	                         		        	
	         } 
	  	                          
	  	query += "  order by  1, 2";
	  	
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
			System.out.println("[CostDatabase:getDlyCostStatAList3]"+e);
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
	
	
	public Vector getCostManCampaignNew2(String save_dt, String gubun, int base_cnt, String ns_dt, String ne_dt)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	  
		if (gubun.equals("1")) { //고객지원팀

		
				 query = " select '0' po , aa.ave_amt  r_one_per_cost, aa.c_ave_amt one_per_cost ,\n"+
				         " trunc(aa.all_i_amt / aa.su_1_cnt)  ave_all_i_amt, trunc(aa.all_b_amt / aa.su_2_cnt)  ave_all_b_amt, \n"+
				      //   " trunc(aa.way1_amt / aa.rent_way_1_cnt)  ave_i_amt, trunc(aa.way2_amt / aa.rent_way_2_cnt) ave_b_amt,  \n"+
				         " trunc(aa.way1_amt / decode(aa.rent_way_1_cnt, 0, 1 ,aa.rent_way_1_cnt))  ave_i_amt, trunc(aa.way2_amt / aa.rent_way_2_cnt) ave_b_amt,  \n"+
				     //    " trunc((aa.r_all_b_amt + aa.r_all_i_amt ) /  ( aa.su_1_cnt + aa.su_2_cnt)) one_per_cost,	\n"+			       
				  		 " aa.* from ( \n"+
						 "	 select decode(b.user_pos,'대표이사',1,'부장', 2, '차장', 3, '과장', 4 , '대리', 5, 9) pos_sort, c.su_1_cnt, c.su_2_cnt, c.all_i_amt, c.all_b_amt,  \n"+
						 "	 a.*, b.dept_id, b.user_nm, b.user_id  \n"+
						 "	 from stat_bus_cost_2_cmp a, users b, \n"+ 
						 "	 (select sum(a.way1_amt) all_i_amt, sum(a.way2_amt) all_b_amt, sum(rent_way_1_cnt) su_1_cnt, sum(rent_way_2_cnt) su_2_cnt from stat_bus_cost_2_cmp a,  users b where a.bus_id=b.user_id and a.gubun = '"+gubun+"' and a.save_dt='"+save_dt+"'  and b.use_yn = 'Y'  ) c \n"+
						 "	  where a.bus_id=b.user_id  and a.gubun =  '"+gubun+"' and a.save_dt='"+save_dt+"' and b.use_yn = 'Y'   ) aa \n ";
	
		}else { //영업팀
			//관리대수가 50대가 미만인 경우는 포상제외
			  query = " select decode(aa.user_id, '000076', '0',  case when  ( aa.rent_way_1_cnt + aa.rent_way_2_cnt ) >= " + base_cnt + "  then '0' else '9' end) po, aa.ave_amt  r_one_per_cost, aa.c_ave_amt one_per_cost ,\n"+				
				         " trunc(aa.all_i_amt / aa.su_1_cnt)  ave_all_i_amt, trunc(aa.all_b_amt / aa.su_2_cnt)  ave_all_b_amt, \n"+
				         " trunc(aa.way1_amt / decode(aa.rent_way_1_cnt, 0, 1 ,aa.rent_way_1_cnt))  ave_i_amt, trunc(aa.way2_amt / aa.rent_way_2_cnt) ave_b_amt,  \n"+
				     //    " trunc((aa.r_all_b_amt + aa.r_all_i_amt ) /  ( aa.su_1_cnt + aa.su_2_cnt)) one_per_cost,	\n"+			       
				  		 " aa.* from ( \n"+
						 "	 select decode(b.user_pos,'대표이사',1,'부장', 2, '차장', 3, '과장', 4 , '대리', 5, 9) pos_sort, c.su_1_cnt, c.su_2_cnt, c.all_i_amt, c.all_b_amt,  \n"+
						 "	 a.*, b.dept_id, b.user_nm, b.user_id  \n"+
						 "	 from stat_bus_cost_2_cmp a, users b, \n"+ 
						 "	 (select sum(a.way1_amt) all_i_amt, sum(a.way2_amt) all_b_amt, sum(rent_way_1_cnt) su_1_cnt, sum(rent_way_2_cnt) su_2_cnt from stat_bus_cost_2_cmp a,  users b where a.bus_id=b.user_id and a.gubun = '"+gubun+"' and a.save_dt='"+save_dt+"'  and b.use_yn = 'Y' and ( a.rent_way_1_cnt + a.rent_way_2_cnt ) >=  " + base_cnt + "  ) c \n"+
						 "	  where a.bus_id=b.user_id  and a.gubun =  '"+gubun+"' and a.save_dt='"+save_dt+"' and b.use_yn = 'Y'  ) aa \n ";
						 
			
		}	
	
		query += " order by 1 , 2 ";
		
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
			System.out.println("[CostDatabase:getCostManCampaignNew(String save_dt, String gubun, int base_cnt, String s_dt, String e_dt)]"+e);
		//	System.out.println(query);
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
	
	
		// 2군 관리비용 캠페인
		//11 parameter
	public Vector getDlyCostStatMList3(String save_dt, String mng_id, int amt1, int amt2, int amt1_per , int amt2_per, int amt3_per, int bus_cost_per, int mng_cost_per , String gg, String mng_br_id)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
							   
	         if ( gg.equals("07") ) {       //탁송
	  	//	 query = "select b.j_dt, b.rent_l_cd, decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0) amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
	  		  query = "select b.j_dt, b.rent_l_cd,  nvl( bus_amt , 0)  amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
	  		 	      "	from COST_CMP_BASE_J b , cont_n_view c , car_reg cr    \n"+ 
                          	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and gubun  like 'C%' and gubun not in ('C10', 'C7', 'C5', 'C12' )      \n"+ 
                                            " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd   and b.chk = '2'  and c.car_mng_id = cr.car_mng_id  \n"+ 
                                            "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";                       
	         } else    if ( gg.equals("08") ) {  //유류대 - 탁송:청구일자 금액 setting            	
	
                  //   query = "select b.j_dt,  b.rent_l_cd, decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0) amt , b.rent_way, b.etc,   c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
                            query = "select b.j_dt,  b.rent_l_cd,  nvl(bus_amt , 0)  amt , b.rent_way, b.etc,   c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
	  		 	      "	from COST_CMP_BASE_J b , cont_n_view c , car_reg cr    \n"+ 
                          	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and gubun  like 'O%' and gubun not in ('O10', 'O7', 'O5', 'O12' ) \n"+ 
                                            " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd    and b.chk = '2' and c.car_mng_id = cr.car_mng_id   \n"+ 
                                            "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";             
                    } else    if ( gg.equals("10") ) {  //긴급출동
	
          //           query = "select b.j_dt,  b.rent_l_cd, decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0) amt , b.rent_way, b.etc,   c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
                         query = "select b.j_dt,  b.rent_l_cd, nvl( bus_amt , 0)  amt , b.rent_way, b.etc,   c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
	  		 	      "	from COST_CMP_BASE_J b , cont_n_view c , car_reg cr     \n"+ 
                          	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and b.gubun like 'EM%'  \n"+ 
                                            " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd    and b.chk = '2' and c.car_mng_id = cr.car_mng_id     \n"+ 
                                            "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";                   
                     } else    if ( gg.equals("03") ) {  //검사비
	
              //       query = "select b.j_dt,  b.rent_l_cd, decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0) amt , b.rent_way, b.etc,   c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
                        query = "select b.j_dt,  b.rent_l_cd,  nvl( bus_amt , 0) amt , b.rent_way, b.etc,   c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
	  		 	      "	from COST_CMP_BASE_J b , cont_n_view c , car_reg cr    \n"+ 
                          	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and b.gubun like 'SS%'  \n"+ 
                                            " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd    and b.chk = '2' and c.car_mng_id = cr.car_mng_id   \n"+ 
                                            "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";                                                                                               	
                  } else    if ( gg.equals("05") ) {  //대차   	         	
	         	  //    query = "select b.j_dt, b.rent_l_cd, decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0) amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
	         	      query = "select b.j_dt, b.rent_l_cd, nvl( bus_amt , 0)  amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
	  		 	      "	from COST_CMP_BASE_J b , cont_n_view c , car_reg cr   \n"+ 
                          	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and gubun  in   ('R2' , 'R3')  \n"+ 
                                            " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd     and b.chk = '2' and c.car_mng_id = cr.car_mng_id  \n"+ 
                                            "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";        
                  } else    if ( gg.equals("01") ) {  //정비비
                  	 //	query = "select b.j_dt, b.rent_l_cd, decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0) amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
                  	 	query = "select b.j_dt, b.rent_l_cd, nvl( bus_amt , 0)  amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
	  		 	      "	from COST_CMP_BASE_J b , cont_n_view c , car_reg cr   \n"+ 
                          	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and gubun  in ('J1', 'J2', 'J3' , 'J4' )      \n"+ 
                                            " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd     and b.chk = '2'  and c.car_mng_id = cr.car_mng_id  \n"+ 
                                            "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";        
                    } else    if ( gg.equals("06") ) {  //휴/대차료   	         	
	         	 //     query = "select b.j_dt, b.rent_l_cd, (decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0)) * (-1)  amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
	         	        query = "select b.j_dt, b.rent_l_cd, nvl( bus_amt , 0)  * (-1)  amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
	  		 	      "	from COST_CMP_BASE_J b , cont_n_view c , car_reg cr    \n"+ 
                          	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and gubun  in   ('PP' )  \n"+ 
                                            " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd     and b.chk = '2'  and c.car_mng_id = cr.car_mng_id  \n"+ 
                                            "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";                                   
                  } else    if ( gg.equals("04") ) {  //사고   
                	  query = "   select  b.serv_dt j_dt, a.rent_l_cd, a.use_yn,  a.rent_way, cr.car_no,cr.car_nm, a.firm_nm, '사고수리비' etc ,    \n"+ 
              	  			"		 decode( b.bus_id, '" + mng_id + "', (nvl(b.real_amt, 0)+nvl(b.ave_amt, 0)) *"+ bus_cost_per+"/100 , 0 ) +  decode( b.user_id, '" + mng_id + "', (nvl(b.real_amt, 0)+nvl(b.ave_amt, 0)) *"+mng_cost_per+"/100 , 0 )  amt,  b.fault_per per  , b.ave_per  \n"+ 
              	 		//	"		 decode(b.rent_l_cd , 'K315B52R00016', -3100000 , nvl(b.real_amt, 0)+nvl(b.ave_amt, 0) )   amt  ,  b.fault_per per    \n"+ 
              	 			"		  from (    \n"+ 
          					"	  select   b.rent_mng_id, b.rent_l_cd,  b.bus_id, b.user_id, b.car_mng_id, b.serv_dt , b.fault_per,  b.ave_per,     \n"+ 
          					"	   case    when abs( (b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) )  >  "+ amt2+"  \n"+ 
          				    "                  then   \n"+ 
          				    "                   case when (b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) )   >  "+ amt2+"   \n"+ 
          				    "                        then  "+ amt2 + " +  (((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) -  "+ amt2+" )*"+amt2_per+"/100)  \n"+ 
          				    "                        else  "+ amt2 + "*(-1) +  (((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) +  "+ amt2+" ) *"+amt2_per+"/100)  end   \n"+ 
          				    "           else  ( b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) end  * 50 /100  real_amt ,  \n"+ 
          				    "           case  when abs( (b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) ) >  "+ amt2+"   \n"+ 
          				     "                then   \n"+ 
          				     "                 case when (b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) )   >  "+ amt2+"    \n"+ 
          				     "                      then  "+ amt2 + " +  (((b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) -  "+ amt2+" )*"+amt2_per+"/100)  \n"+ 
          				     "                      else  "+ amt2 + "*(-1) +  (((b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) +  "+ amt2+" )*"+amt2_per+"/100)  end      \n"+  
          				     "             else  ( b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) end  * 50 /100 ave_amt   \n"+ 
          				      	"		      FROM  COST_CMP_BASE_A  b    \n"+ 
          		    			"		      where  b.save_dt = replace('" + save_dt + "','-','')  and b.gubun not in ( 'P1', 'DA', 'A2')  and b.chk = '2'  and  b.rent_l_cd||b.gubun not in ('K315B52R00016A2')  ) b  , cont_n_view a, car_reg cr    \n"+ 
          		    			"		  where b.rent_mng_id = a.rent_mng_id and b.rent_l_cd = a.rent_l_cd and b.car_mng_id = cr.car_mng_id    \n"+ 
          		    			"		   and ( b.bus_id = '" + mng_id + "'  or  b.user_id = '" + mng_id +  "' )   \n"+ 	
          						"  union all   \n"+ 
          		    			"   select  b.serv_dt j_dt, a.rent_l_cd, a.use_yn,  a.rent_way, cr.car_no,cr.car_nm, a.firm_nm, '사고수리비(폐차)' etc ,    \n"+ 
          	              	  			"		 decode( b.bus_id, '" + mng_id + "', (nvl(b.real_amt, 0)+nvl(b.ave_amt, 0)) *"+ bus_cost_per+"/100 , 0 ) +  decode( b.user_id, '" + mng_id + "', (nvl(b.real_amt, 0)+nvl(b.ave_amt, 0)) *"+mng_cost_per+"/100 , 0 )  amt,  b.fault_per per  , b.ave_per  \n"+ 
          	              	 		//	"		 decode(b.rent_l_cd , 'K315B52R00016', -3100000 , nvl(b.real_amt, 0)+nvl(b.ave_amt, 0) )   amt  ,  b.fault_per per    \n"+ 
          	              	 			"		  from (    \n"+ 
          	          					"	  select   b.rent_mng_id, b.rent_l_cd,  b.bus_id, b.user_id, b.car_mng_id, b.serv_dt , b.fault_per,  b.ave_per,     \n"+ 
          	          					"	   case    when abs( (b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) )  >  "+ amt2+"  \n"+ 
          	          				    "                  then   \n"+ 
          	          				    "                   case when (b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) )   >  "+ amt2+"   \n"+ 
          	          				    "                        then  "+ amt2 + " +  (((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) -  "+ amt2+" )*"+amt2_per+"/100)  \n"+ 
          	          				    "                        else  "+ amt2 + "*(-1) +  (((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) +  "+ amt2+" ) *"+amt2_per+"/100)  end   \n"+ 
          	          				    "           else  ( b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) end  * 50 /100  real_amt ,  \n"+ 
          	          				    "           case  when abs( (b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) ) >  "+ amt2+"   \n"+ 
          	          				     "                then   \n"+ 
          	          				     "                 case when (b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) )   >  "+ amt2+"    \n"+ 
          	          				     "                      then  "+ amt2 + " +  (((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) -  "+ amt2+" )*"+amt2_per+"/100)  \n"+ 
          	          				     "                      else  "+ amt2 + "*(-1) +  (((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) +  "+ amt2+" )*"+amt2_per+"/100)  end      \n"+  
          	          				     "             else  ( b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) end  * 50 /100 ave_amt   \n"+ 
          	          				      	"		      FROM  COST_CMP_BASE_A  b    \n"+ 
          	          		    			"		      where  b.save_dt = replace('" + save_dt + "','-','')  and b.gubun  in ( 'A2')  and b.chk = '2'  and  b.rent_l_cd||b.gubun not in ('K315B52R00016A2')  ) b  , cont_n_view a, car_reg cr    \n"+ 
          	          		    			"		  where b.rent_mng_id = a.rent_mng_id and b.rent_l_cd = a.rent_l_cd and b.car_mng_id = cr.car_mng_id    \n"+ 
          	          		    			"		   and ( b.bus_id = '" + mng_id + "'  or  b.user_id = '" + mng_id +  "' )   \n"+ 	
          						"  union all   \n"+ 
          			    		"    select  b.serv_dt j_dt, a.rent_l_cd, a.use_yn,  a.rent_way, cr.car_no,cr.car_nm, a.firm_nm, '사고수리비차감' etc ,     \n"+ 
          			 		   	"		  nvl(b.real_amt, 0) * (-1)  amt,  b.fault_per per  , b.ave_per   \n"+ 
          						"		  from (     \n"+ 
          						"		  select   b.rent_mng_id, b.rent_l_cd,  b.bus_id, b.user_id, b.car_mng_id, b.serv_dt , b.fault_per,  b.ave_per , \n"+ 
          				        "          case when to_date(b.serv_dt) - to_date(b.accid_dt) > 120 then  \n"+ 
				                "                case  when  b.tot_amt  > 1000000  then ( 100000 + ( ( b.tot_amt - 1000000)*5/100 ) )  \n"+ 
				                "                 else   100000 end * 0.1 \n"+ 
				                "            when to_date(b.serv_dt) - to_date(b.accid_dt) between 60 and 120 then  \n"+ 
				                "                 case  when  b.tot_amt  > 1000000  then ( 100000 + ( ( b.tot_amt - 1000000)*5/100 ) )  \n"+ 
				                "                  else   100000 end * 0.4 \n"+  
				                "            else \n"+ 
				                "                 case  when  b.tot_amt  > 1000000  then  100000 + ( ( b.tot_amt - 1000000)*5/100 ) \n"+ 
				                "                  else   100000 end * 1 \n"+ 
				                "            end     real_amt,    0  ave_amt     \n"+ 
          						"		      FROM  COST_CMP_BASE_A  b    \n"+ 
          						"		      where  b.save_dt =  replace('" + save_dt + "','-','')   and b.gubun in ( 'DA')    and b.chk = '2'   ) b  , cont_n_view a, car_reg cr      \n"+ 
          						"		  where b.rent_mng_id = a.rent_mng_id and b.rent_l_cd = a.rent_l_cd and b.car_mng_id = cr.car_mng_id    \n"+ 
          						"		   and ( b.bus_id = '" + mng_id + "'  or  b.user_id = '" + mng_id +  "' )  \n  "; 
                	  
               /*   
                 	 	 query = "   select  b.serv_dt j_dt, a.rent_l_cd, a.use_yn,  a.rent_way, cr.car_no,cr.car_nm, a.firm_nm, '사고수리비' etc ,    \n"+ 
	 		//	"		 decode( b.bus_id, '" + mng_id + "', (nvl(b.real_amt, 0)+nvl(b.ave_amt, 0)) *"+ bus_cost_per+"/100 , 0 ) +  decode( b.user_id, '" + mng_id + "', (nvl(b.real_amt, 0)+nvl(b.ave_amt, 0)) *"+mng_cost_per+"/100 , 0 )  amt,  b.fault_per per    \n"+ 
				"		 decode(b.rent_l_cd , 'K315B52R00016', -3100000 , nvl(b.real_amt, 0)+nvl(b.ave_amt, 0) )   amt  ,  b.fault_per per    \n"+ 
				"		  from (    \n"+ 
				"		  select   b.rent_mng_id, b.rent_l_cd,  b.bus_id, b.user_id, b.car_mng_id, b.serv_dt , b.fault_per,     \n"+ 
				"		    (  case  when  (b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) > "+ amt2+"  then  "+ amt2 + " + ( (((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) )   - "+amt2+"))*"+amt2_per+"/100)       \n"+ 
				"		          else  ( b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) end  ) * 50 /100  real_amt ,    \n"+ 
				"		    (  case  when  (b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) >  "+ amt2+"  then "+ amt2 + " + ( (((b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) )    - "+amt2+"))*"+amt2_per+"/100)          \n"+ 
				"		          else  ( b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)*1.1) ) end ) * 50 /100 ave_amt     \n"+ 
				"		      FROM  COST_CMP_BASE_A  b    \n"+ 
				"		      where  b.save_dt = replace('" + save_dt + "','-','')  and b.gubun not in ( 'P1', 'DA')  and b.chk = '2'  and  b.rent_l_cd||b.gubun not in ('K315B52R00016A2')  ) b  , cont_n_view a, car_reg cr    \n"+ 
				"		  where b.rent_mng_id = a.rent_mng_id and b.rent_l_cd = a.rent_l_cd and b.car_mng_id = cr.car_mng_id    \n"+ 
				"		   and ( b.bus_id = '" + mng_id + "'  or  b.user_id = '" + mng_id +  "' )   \n"+ 
				
				
               	"  union all   \n"+  	 	 
	    			"    select  b.serv_dt j_dt, a.rent_l_cd, a.use_yn,  a.rent_way, cr.car_no,cr.car_nm, a.firm_nm, '사고수리비차감' etc ,     \n"+ 
	 		   	"		  nvl(b.real_amt, 0) * (-1)  amt,  b.fault_per per     \n"+ 
				"		  from (     \n"+ 
				"		  select   b.rent_mng_id, b.rent_l_cd,  b.bus_id, b.user_id, b.car_mng_id, b.serv_dt , b.fault_per,  \n"+ 
				"		      case  when  b.tot_amt  > 300000  then  300000 + ( (b.tot_amt  - 300000)*10/100)     else   b.tot_amt end  real_amt ,     0  ave_amt     \n"+ 
				"		      FROM  COST_CMP_BASE_A  b    \n"+ 
				"		      where  b.save_dt =  replace('" + save_dt + "','-','')   and b.gubun in ( 'DA')    and b.chk = '2'   ) b  , cont_n_view a, car_reg cr      \n"+ 
				"		  where b.rent_mng_id = a.rent_mng_id and b.rent_l_cd = a.rent_l_cd and b.car_mng_id = cr.car_mng_id    \n"+ 
				"		   and ( b.bus_id = '" + mng_id + "'  or  b.user_id = '" + mng_id +  "' )  \n  "; */
	         } 
	                  
	  	query += "  order by  1, 2";
	  	
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
			System.out.println("[CostDatabase:getDlyCostStatMList3(]"+e);
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
	
	// 1군 관리비용 캠페인
	//11 parameter
public Vector getDlyCostStatMList1(String save_dt, String mng_id, int amt1, int amt2, int amt1_per , int amt2_per, int amt3_per, int bus_cost_per, int mng_cost_per , String gg, String mng_br_id)
{
	getConnection();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	Vector vt = new Vector();
	String query = "";
						   
         if ( gg.equals("07") ) {       //탁송
  	//	 query = "select b.j_dt, b.rent_l_cd, decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0) amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
  		  query = "select b.j_dt, b.rent_l_cd,  nvl( bus_amt , 0)  amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
  		 	      "	from COST_CMP_BASE_J b , cont_n_view c , car_reg cr    \n"+ 
                      	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and gubun  like 'C%' and gubun not in ('C10', 'C7', 'C5', 'C12' )      \n"+ 
                                        " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd   and b.chk = '1'  and c.car_mng_id = cr.car_mng_id  \n"+ 
                                        "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";                       
         } else    if ( gg.equals("08") ) {  //유류대 - 탁송:청구일자 금액 setting            	

              //   query = "select b.j_dt,  b.rent_l_cd, decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0) amt , b.rent_way, b.etc,   c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
                        query = "select b.j_dt,  b.rent_l_cd,  nvl(bus_amt , 0)  amt , b.rent_way, b.etc,   c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
  		 	      "	from COST_CMP_BASE_J b , cont_n_view c , car_reg cr    \n"+ 
                      	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and gubun  like 'O%' and gubun not in ('O10', 'O7', 'O5', 'O12' ) \n"+ 
                                        " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd    and b.chk = '1' and c.car_mng_id = cr.car_mng_id   \n"+ 
                                        "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";             
                } else    if ( gg.equals("10") ) {  //긴급출동

      //           query = "select b.j_dt,  b.rent_l_cd, decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0) amt , b.rent_way, b.etc,   c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
                     query = "select b.j_dt,  b.rent_l_cd, nvl( bus_amt , 0)  amt , b.rent_way, b.etc,   c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
  		 	      "	from COST_CMP_BASE_J b , cont_n_view c , car_reg cr     \n"+ 
                      	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and b.gubun like 'EM%'  \n"+ 
                                        " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd    and b.chk = '1' and c.car_mng_id = cr.car_mng_id     \n"+ 
                                        "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";                   
                 } else    if ( gg.equals("03") ) {  //검사비

          //       query = "select b.j_dt,  b.rent_l_cd, decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0) amt , b.rent_way, b.etc,   c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
                    query = "select b.j_dt,  b.rent_l_cd,  nvl( bus_amt , 0) amt , b.rent_way, b.etc,   c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
  		 	      "	from COST_CMP_BASE_J b , cont_n_view c , car_reg cr    \n"+ 
                      	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and b.gubun like 'SS%'  \n"+ 
                                        " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd    and b.chk = '1' and c.car_mng_id = cr.car_mng_id   \n"+ 
                                        "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";                                                                                               	
              } else    if ( gg.equals("05") ) {  //대차   	         	
         	  //    query = "select b.j_dt, b.rent_l_cd, decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0) amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
         	      query = "select b.j_dt, b.rent_l_cd, nvl( bus_amt , 0)  amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
  		 	      "	from COST_CMP_BASE_J b , cont_n_view c , car_reg cr   \n"+ 
                      	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and gubun  in   ('R2', 'R3')  \n"+ 
                                        " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd     and b.chk = '1' and c.car_mng_id = cr.car_mng_id  \n"+ 
                                        "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";        
              } else    if ( gg.equals("01") ) {  //정비비
              	// 	query = "select b.j_dt, b.rent_l_cd,   \n"+ 	      	 			
            	//	" decode( b.bus_id, '" + mng_id + "', (bus_amt) *"+ bus_cost_per+"/100 , 0 ) +  decode( b.user_id, '" + mng_id + "', (user_amt) *"+mng_cost_per+"/100 , 0 )  amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
              	 	query = "select b.j_dt, b.rent_l_cd, nvl( bus_amt , 0)  amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
  		 	      "	from COST_CMP_BASE_J b , cont_n_view c , car_reg cr   \n"+ 
                      	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and gubun  in ('J1', 'J2', 'J3' , 'J4' )      \n"+ 
                                        " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd     and b.chk = '1'  and c.car_mng_id = cr.car_mng_id  \n"+ 
                                        "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";        
                } else    if ( gg.equals("06") ) {  //휴/대차료   	         	
         	 //     query = "select b.j_dt, b.rent_l_cd, (decode(b.bus_id, '"+mng_id+"', bus_amt , 0) + decode(b.user_id, '"+mng_id+"', user_amt , 0)) * (-1)  amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, c.car_no, c.car_nm    \n"+ 
         	        query = "select b.j_dt, b.rent_l_cd, nvl( bus_amt , 0)  * (-1)  amt , b.rent_way, b.etc,  c.use_yn, c.firm_nm, cr.car_no, cr.car_nm    \n"+ 
  		 	      "	from COST_CMP_BASE_J b , cont_n_view c , car_reg cr    \n"+ 
                      	     	      " where  b.save_dt = replace('" + save_dt + "','-','') and gubun  in   ('PP' )  \n"+ 
                                        " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd     and b.chk = '1'  and c.car_mng_id = cr.car_mng_id  \n"+ 
                                        "  and ( b.user_id = '" + mng_id + "'   or b.bus_id = '" + mng_id + "' ) ";                                   
              } else    if ( gg.equals("04") ) {  //사고   	
           /*   
             	 	 query = "   select  b.serv_dt j_dt, a.rent_l_cd, a.use_yn,  a.rent_way, cr.car_no,cr.car_nm, a.firm_nm, '사고수리비' etc ,    \n"+ 
 			"		 decode( b.bus_id, '" + mng_id + "', (nvl(b.real_amt, 0)+nvl(b.ave_amt, 0)) *"+ bus_cost_per+"/100 , 0 ) +  decode( b.user_id, '" + mng_id + "', (nvl(b.real_amt, 0)+nvl(b.ave_amt, 0)) *"+mng_cost_per+"/100 , 0 )  amt,  b.fault_per per    \n"+ 
		//	"		 decode(b.rent_l_cd , 'K315B52R00016', -3100000 , nvl(b.real_amt, 0)+nvl(b.ave_amt, 0) )   amt  ,  b.fault_per per    \n"+ 
			"		  from (    \n"+ 
			"		  select   b.rent_mng_id, b.rent_l_cd,  b.bus_id, b.user_id, b.car_mng_id, b.serv_dt , b.fault_per,     \n"+ 
			"		    (  case  when  (b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) > "+ amt2+"  then  "+ amt2 + " + ( (((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) )   - "+amt2+"))*"+amt2_per+"/100)       \n"+ 
			"		          else  ( b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) end  ) * 50 /100  real_amt ,    \n"+ 
			"		    (  case  when  (b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) >  "+ amt2+"  then "+ amt2 + " + ( (((b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) )    - "+amt2+"))*"+amt2_per+"/100)          \n"+ 
			"		          else  ( b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) end ) * 50 /100 ave_amt     \n"+ 
			"		      FROM  COST_CMP_BASE_A  b    \n"+ 
			"		      where  b.save_dt = replace('" + save_dt + "','-','')  and b.gubun not in ( 'P1', 'DA')  and b.chk = '1'  and  b.rent_l_cd||b.gubun not in ('K315B52R00016A2')  ) b  , cont_n_view a, car_reg cr    \n"+ 
			"		  where b.rent_mng_id = a.rent_mng_id and b.rent_l_cd = a.rent_l_cd and b.car_mng_id = cr.car_mng_id    \n"+ 
			"		   and ( b.bus_id = '" + mng_id + "'  or  b.user_id = '" + mng_id +  "' )   \n"+ 
			"  union all   \n"+ 
    			"    select  b.serv_dt j_dt, a.rent_l_cd, a.use_yn,  a.rent_way, cr.car_no,cr.car_nm, a.firm_nm, '사고수리비차감' etc ,     \n"+ 
 		   	"		  nvl(b.real_amt, 0) * (-1)  amt,  b.fault_per per     \n"+ 
			"		  from (     \n"+ 
			"		  select   b.rent_mng_id, b.rent_l_cd,  b.bus_id, b.user_id, b.car_mng_id, b.serv_dt , b.fault_per,  \n"+ 
			"		      case  when  b.tot_amt  > 300000  then  300000 + ( (b.tot_amt  - 300000)*10/100)     else   b.tot_amt end  real_amt ,     0  ave_amt     \n"+ 
			"		      FROM  COST_CMP_BASE_A  b    \n"+ 
			"		      where  b.save_dt =  replace('" + save_dt + "','-','')   and b.gubun in ( 'DA')    and b.chk = '1'   ) b  , cont_n_view a, car_reg cr      \n"+ 
			"		  where b.rent_mng_id = a.rent_mng_id and b.rent_l_cd = a.rent_l_cd and b.car_mng_id = cr.car_mng_id    \n"+ 
			"		   and ( b.bus_id = '" + mng_id + "'  or  b.user_id = '" + mng_id +  "' )  \n  "; 
        */
    	 	 query = "   select  b.serv_dt j_dt, a.rent_l_cd, a.use_yn,  a.rent_way, cr.car_no,cr.car_nm, a.firm_nm, '사고수리비' etc ,    \n"+ 
    	  			"		 decode( b.bus_id, '" + mng_id + "', (nvl(b.real_amt, 0)+nvl(b.ave_amt, 0)) *"+ bus_cost_per+"/100 , 0 ) +  decode( b.user_id, '" + mng_id + "', (nvl(b.real_amt, 0)+nvl(b.ave_amt, 0)) *"+mng_cost_per+"/100 , 0 )  amt,  b.fault_per per  , b.ave_per  \n"+ 
    	 		//	"		 decode(b.rent_l_cd , 'K315B52R00016', -3100000 , nvl(b.real_amt, 0)+nvl(b.ave_amt, 0) )   amt  ,  b.fault_per per    \n"+ 
    	 			"		  from (    \n"+ 
					"	  select   b.rent_mng_id, b.rent_l_cd,  b.bus_id, b.user_id, b.car_mng_id, b.serv_dt , b.fault_per,  b.ave_per,     \n"+ 
					"	   case    when abs( (b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) )  >  "+ amt2+"  \n"+ 
				    "                  then   \n"+ 
				    "                   case when (b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) )   >  "+ amt2+"   \n"+ 
				    "                        then  "+ amt2 + " +  (((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) -  "+ amt2+" )*"+amt2_per+"/100)  \n"+ 
				    "                        else  "+ amt2 + "*(-1) +  (((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) +  "+ amt2+" ) *"+amt2_per+"/100)  end   \n"+ 
				    "           else  ( b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) end  * 50 /100  real_amt ,  \n"+ 
				    "           case  when abs( (b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) ) >  "+ amt2+"   \n"+ 
				     "                then   \n"+ 
				     "                 case when (b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) )   >  "+ amt2+"    \n"+ 
				     "                      then  "+ amt2 + " +  (((b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) -  "+ amt2+" )*"+amt2_per+"/100)  \n"+ 
				     "                      else  "+ amt2 + "*(-1) +  (((b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) +  "+ amt2+" )*"+amt2_per+"/100)  end      \n"+  
				     "             else  ( b.tot_amt * b.ave_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) end  * 50 /100 ave_amt   \n"+ 
				      	"		      FROM  COST_CMP_BASE_A  b    \n"+ 
		    			"		      where  b.save_dt = replace('" + save_dt + "','-','')  and b.gubun not in ( 'P1', 'DA' , 'A2' )  and b.chk = '1'  and  b.rent_l_cd||b.gubun not in ('K315B52R00016A2')  ) b  , cont_n_view a, car_reg cr    \n"+ 
		    			"		  where b.rent_mng_id = a.rent_mng_id and b.rent_l_cd = a.rent_l_cd and b.car_mng_id = cr.car_mng_id    \n"+ 
		    			"		   and ( b.bus_id = '" + mng_id + "'  or  b.user_id = '" + mng_id +  "' )   \n"+ 
		    			"  union all   \n"+ 	
		    			"   select  b.serv_dt j_dt, a.rent_l_cd, a.use_yn,  a.rent_way, cr.car_no,cr.car_nm, a.firm_nm, '사고수리비(폐차)' etc ,    \n"+ 
		    	    	  			"		 decode( b.bus_id, '" + mng_id + "', (nvl(b.real_amt, 0)+nvl(b.ave_amt, 0)) *"+ bus_cost_per+"/100 , 0 ) +  decode( b.user_id, '" + mng_id + "', (nvl(b.real_amt, 0)+nvl(b.ave_amt, 0)) *"+mng_cost_per+"/100 , 0 )  amt,  b.fault_per per  , b.ave_per  \n"+ 
		    	    	 		//	"		 decode(b.rent_l_cd , 'K315B52R00016', -3100000 , nvl(b.real_amt, 0)+nvl(b.ave_amt, 0) )   amt  ,  b.fault_per per    \n"+ 
		    	    	 			"		  from (    \n"+ 
		    						"	  select   b.rent_mng_id, b.rent_l_cd,  b.bus_id, b.user_id, b.car_mng_id, b.serv_dt , b.fault_per,  b.ave_per,     \n"+ 
		    						"	   case    when abs( (b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) )  >  "+ amt2+"  \n"+ 
		    					    "                  then   \n"+ 
		    					    "                   case when (b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) )   >  "+ amt2+"   \n"+ 
		    					    "                        then  "+ amt2 + " +  (((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) -  "+ amt2+" )*"+amt2_per+"/100)  \n"+ 
		    					    "                        else  "+ amt2 + "*(-1) +  (((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) +  "+ amt2+" ) *"+amt2_per+"/100)  end   \n"+ 
		    					    "           else  ( b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) end  * 50 /100  real_amt ,  \n"+ 
		    					    "           case  when abs( (b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) ) >  "+ amt2+"   \n"+ 
		    					     "                then   \n"+ 
		    					     "                 case when (b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) )   >  "+ amt2+"    \n"+ 
		    					     "                      then  "+ amt2 + " +  (((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) -  "+ amt2+" )*"+amt2_per+"/100)  \n"+ 
		    					     "                      else  "+ amt2 + "*(-1) +  (((b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) +  "+ amt2+" )*"+amt2_per+"/100)  end      \n"+  
		    					     "             else  ( b.tot_amt * b.fault_per/100) - ( (nvl(b.cust_amt,0)+nvl(b.cls_amt,0)+nvl(b.ext_amt,0)) ) end  * 50 /100 ave_amt   \n"+ 
		    					    	"		      FROM  COST_CMP_BASE_A  b    \n"+ 
		    			    			"		      where  b.save_dt = replace('" + save_dt + "','-','')  and b.gubun in ( 'A2')  and b.chk = '1'  and  b.rent_l_cd||b.gubun not in ('K315B52R00016A2')  ) b  , cont_n_view a, car_reg cr    \n"+ 
		    			    			"		  where b.rent_mng_id = a.rent_mng_id and b.rent_l_cd = a.rent_l_cd and b.car_mng_id = cr.car_mng_id    \n"+ 
		    			    			"		   and ( b.bus_id = '" + mng_id + "'  or  b.user_id = '" + mng_id +  "' )   \n"	+	    			
		    			    				"  union all   \n"+ 
			    		"    select  b.serv_dt j_dt, a.rent_l_cd, a.use_yn,  a.rent_way, cr.car_no,cr.car_nm, a.firm_nm, '사고수리비차감' etc ,     \n"+ 
			 		   	"		  nvl(b.real_amt, 0) * (-1)  amt,  b.fault_per per  , b.ave_per   \n"+ 
						"		  from (     \n"+ 
						"		  select   b.rent_mng_id, b.rent_l_cd,  b.bus_id, b.user_id, b.car_mng_id, b.serv_dt , b.fault_per,  b.ave_per , \n"+ 					  
					//    "           case  when  b.tot_amt  > 1000000  then 100000 + ( ( b.tot_amt - 1000000)*5/100 )    \n"+ 
					//    "            else   100000 end   real_amt,    0  ave_amt     \n"+   	
					  "          case when to_date(b.serv_dt) - to_date(b.accid_dt) > 120 then  \n"+ 
		                "                case  when  b.tot_amt  > 1000000  then ( 100000 + ( ( b.tot_amt - 1000000)*5/100 ) )  \n"+ 
		                "                 else   100000 end * 0.1 \n"+ 
		                "            when to_date(b.serv_dt) - to_date(b.accid_dt) between 60 and 120 then  \n"+ 
		                "                 case  when  b.tot_amt  > 1000000  then ( 100000 + ( ( b.tot_amt - 1000000)*5/100 ) )  \n"+ 
		                "                  else   100000 end * 0.4 \n"+  
		                "            else \n"+ 
		                "                 case  when  b.tot_amt  > 1000000  then  100000 + ( ( b.tot_amt - 1000000)*5/100 ) \n"+ 
		                "                  else   100000 end * 1 \n"+ 
		                "            end     real_amt,    0  ave_amt     \n"+
					
						"		      FROM  COST_CMP_BASE_A  b    \n"+ 
						"		      where  b.save_dt =  replace('" + save_dt + "','-','')   and b.gubun in ( 'DA')    and b.chk = '1'   ) b  , cont_n_view a, car_reg cr      \n"+ 
						"		  where b.rent_mng_id = a.rent_mng_id and b.rent_l_cd = a.rent_l_cd and b.car_mng_id = cr.car_mng_id    \n"+ 
						"		   and ( b.bus_id = '" + mng_id + "'  or  b.user_id = '" + mng_id +  "' )  \n  "; 
              
              } 
                  
  	query += "  order by  1, 2";
  	
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
		System.out.println("[CostDatabase:getDlyCostStatMList3(]"+e);
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

//연말정산리스트
public Vector Year_jungsan_List(String c_yy, String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	
		query = " select a.* from year_jungsan a, users b where a.c_yy = '"+c_yy+"' and a.reg_id=b.user_id ";
	  
		if(!gubun1.equals("")) query += " and b.user_nm like '%"+gubun1+"%' ";

		if(gubun2.equals("1"))			query += " order by a.reg_dt, a.sa_no ";
		else if(gubun2.equals("2"))		query += " order by b.user_nm, a.end_dt desc ";	 
		else 							query += " order by a.reg_dt, a.sa_no ";
			
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CostDatabase:Year_jungsan_List(String c_yy, String gubun1)]"+e);
			System.out.println("[CostDatabase:Year_jungsan_List(String c_yy, String gubun1)]"+query);
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

    //캠페인 포상일   
	public Vector getSaveDt(String gubun1, String gubun2)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
	
		query = " select distinct save_dt  from stat_cmp where gubun = '" + gubun2 + "'  and save_dt like '"+gubun1+"%' order by 1 "; 	
			 			
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
					 ht.put(columnName, (rs.getString(columnName))==null?"":rs.getString(columnName).trim());
				}
				vt.add(ht);	
			}
			rs.close();
			pstmt.close();
	
		} catch (SQLException e) {
			System.out.println("[CostDatabase:getSaveDt(String gubun1, String gubun2)]"+e);
			System.out.println("[CostDatabase:getSaveDt(String gubun1, String gubun2)]"+query);
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
	*	stat_cmp  시퀀스 찾기
	*/
public int ScanSeq(String gubun)
	{
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		int seq = 0;
		
	
	 query = " select nvl(max(seq),0 ) + 1  from stat_cmp where save_dt = to_char(sysdate,'YYYYMMDD') and gubun = '"+ gubun + "'";


		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
			if(rs.next())
            	seq = rs.getInt(1);
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[CostDatabase:ScanSeq]"+e);
			System.out.println("[CostDatabase:ScanSeq]"+query);
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

/**
*	제안캠페인 실제 마감데이타 (마감 포상시 생성) 
*/
	public int insertMagamProp(String save_dt )
	{
			
		getConnection();
		PreparedStatement pstmt = null;
		int result = 0;
		String query = " insert into  stat_bus_prop_magam   select * from stat_bus_prop  where  save_dt = ? " ;                
		
		try{
			conn.setAutoCommit(false);
			
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, save_dt);
					
			result = pstmt.executeUpdate();
	
			pstmt.close();
			conn.commit();
	
		}catch(SQLException e){
			System.out.println("[CostDatabase:insertMagamProp]"+e);
			e.printStackTrace();
			conn.rollback();
		}finally{
			try{
				conn.setAutoCommit(true);
	            if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return result;
		}
	}

	/* **
	*	비용페인 실제 마감데이타 (마감 포상시 생성) 
	*/
		public int insertMagamCost(String save_dt, String gubun )
		{
				
			getConnection();
			PreparedStatement pstmt = null;
			int result = 0;
			String query = " insert into  STAT_BUS_COST_2_CMP_MAGAM   select * from STAT_BUS_COST_2_CMP  where  save_dt = ?  and gubun = ? " ;                
			
			try{
				conn.setAutoCommit(false);
				
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, save_dt);
				pstmt.setString(2, gubun);
						
				result = pstmt.executeUpdate();
		
				pstmt.close();
				conn.commit();
		
			}catch(SQLException e){
				System.out.println("[CostDatabase:insertMagamCost]"+e);
				e.printStackTrace();
				conn.rollback();
			}finally{
				try{
					conn.setAutoCommit(true);
		            if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return result;
			}
		}
		
}		
		