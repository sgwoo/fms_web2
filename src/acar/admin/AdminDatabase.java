package acar.admin;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Calendar;
import java.util.Hashtable;
import java.util.Vector;

import acar.account.IncomingSBean;
import acar.common.RentListBean;
import acar.database.DBConnectionManager;
import acar.stat_applet.LastDay;
import acar.stat_applet.LastMonth;
import acar.util.AddUtil;

public class AdminDatabase {
	private Connection conn = null;
	public static AdminDatabase db;

	private final String DATA_SOURCE = "acar";
	private final String DATA_SOURCE1 = "biztalk"; // acar에서 biztalk으로 변경예정

	public static AdminDatabase getInstance() {
		if (AdminDatabase.db == null)
			AdminDatabase.db = new AdminDatabase();
		return AdminDatabase.db;
	}

	private DBConnectionManager connMgr = null;

	private void getConnection() {
		try {
			if (connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if (conn == null)
				conn = connMgr.getConnection(DATA_SOURCE);
		} catch (Exception e) {
			System.out.println(" i can't get a connection........");
		}
	}

	private void closeConnection() {
		if (conn != null) {
			connMgr.freeConnection(DATA_SOURCE, conn);
			conn = null;
		}
	}

	private void getConnection2() {
		try {
			if (connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if (conn == null)
				conn = connMgr.getConnection(DATA_SOURCE1);
		} catch (Exception e) {
			System.out.println(" i can't get a connection........");
		}
	}

	private void closeConnection2() {
		if (conn != null) {
			connMgr.freeConnection(DATA_SOURCE1, conn);
			conn = null;
		}
	}

	// 부채현황-------------------------------------------------------------------------------------

	/**
	 * 당일기준 조회
	 */
	public Vector getStatDebt(String br_id, String save_dt, String st) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query1 = "";
		String query2 = "";
		String sub_qu = "";

		if (st.equals("1"))
			sub_qu = " and c.cpt_cd_st='1' ";
		else if (st.equals("2"))
			sub_qu = " AND c.cpt_cd_st='2' and c.cpt_cd not in ('0016', '0017', '0021') ";
		else if (st.equals("3"))
			sub_qu = " and c.cpt_cd_st='2' and c.cpt_cd in ('0016', '0017', '0021')";

		String b_ym = "";
		String a_ym = "";
		String a_ymd = "";
		b_ym = "to_char(add_months(sysdate,-1),'YYYY-MM')";// 전월
		a_ym = "to_char(sysdate,'YYYY-MM')";// 현재월
		a_ymd = "to_char(sysdate, 'YYYY-MM-DD')";// 현재일자

		String seq = "decode(cpt_cd, '0005',1,'0001',2,'0007',3,'0002',4,'0004',5,'0010',6,'0009',7,'0030',8,'0014',9,'0018',10,'0011',11,'0013',12,'0012',13,'0020',14,'0016',15,'0042',16, '0043', 17, '0044', 18, '0051', 19, '0052', 20, '0055', 21, '0056', 22, '0057', 23, '0026', 24,'0058', 25, '0059', 26, '0060', 27, TO_NUMBER(cpt_cd))";

		query1 = " select"
				+ "        c.cpt_cd, nvl(a.last_mon_amt,0) last_mon_amt, nvl(b.this_mon_new_amt,0) this_mon_new_amt,"
				+ "        nvl(c.this_mon_plan_amt,0) this_mon_plan_amt, nvl(d.this_mon_pay_amt,0) this_mon_pay_amt, 0 whan_amt,"
				+ "        nvl(c.this_mon_plan_int_amt,0) this_mon_plan_int_amt, nvl(d.this_mon_pay_int_amt,0) this_mon_pay_int_amt, 0 this_mon_jan_amt "
				+ " from" + "        ( select " + seq
				+ " seq, cpt_cd, sum(alt_prn) this_mon_plan_amt, sum(alt_int) this_mon_plan_int_amt from debt_pay_view where substr(alt_est_dt,1,7) = "
				+ a_ym + " group by cpt_cd) c,"
				+ "        ( select decode(a.cpt_cd, '0005',1,'0001',2,'0007',3,'0002',4,'0004',5,'0010',6,'0009',7,'0030',8,'0014',9,'0018',10,'0011',11,'0013',12,'0012',13,'0020',14,'0016',15,'0042',16,'0043',17, '0044',18, '0051', 19, '0052', 20, '0055', 21, '0056', 22, '0057', 23, '0026', 24,'0058', 25, '0059', 26, '0060', 27, TO_NUMBER(cpt_cd) ) seq, a.cpt_cd, sum(a.alt_rest) last_mon_amt"
				+ "	       from debt_pay_view a, (select gubun, rent_l_cd, rtn_seq, max(alt_tm) alt_tm from debt_pay_view where substr(alt_est_dt,1,7) = "
				+ b_ym + " group by gubun, rent_l_cd, rtn_seq) b "
				+ "	       where a.gubun=b.gubun and a.rent_l_cd=b.rent_l_cd and nvl(a.rtn_seq,'0')=nvl(b.rtn_seq,'0') and a.alt_tm=b.alt_tm and substr(a.alt_est_dt,1,7) = "
				+ b_ym + " group by a.cpt_cd) a," + "	     ( select " + seq
				+ " seq, cpt_cd, sum(alt_rest) this_mon_new_amt from debt_pay_view where substr(alt_est_dt,1,7) = "
				+ a_ym + " and alt_tm='0' group by cpt_cd) b," + "	     ( select " + seq
				+ " seq, cpt_cd, sum(alt_prn) this_mon_pay_amt, sum(alt_int) this_mon_pay_int_amt from debt_pay_view where substr(alt_est_dt,1,7) = "
				+ a_ym + " and alt_est_dt <= " + a_ymd + " group by cpt_cd) d" + // pay_yn='1'
				" where  c.cpt_cd=a.cpt_cd(+) and c.cpt_cd=b.cpt_cd(+) and c.cpt_cd=d.cpt_cd(+)" + " order by c.seq";

		query2 = " select * from stat_debt c where c.save_dt='" + save_dt + "' and nvl(c.acct_code,'26400') in ('26400','29300') "
				+ sub_qu + " order by c.seq ";

		try {
			if (save_dt.equals("")) {
				pstmt = conn.prepareStatement(query1);
			} else {
				pstmt = conn.prepareStatement(query2);
			}

			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatDebt]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 당일기준 조회
	 */
	public Vector getStatDebtLs(String br_id, String save_dt, String st) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query1 = "";
		String query2 = "";
		String sub_qu = "";

		if (st.equals("1"))
			sub_qu = " and c.cpt_cd_st='1' ";
		else if (st.equals("2"))
			sub_qu = " AND c.cpt_cd_st='2' and c.cpt_cd not in ('0016', '0017', '0021') ";
		else if (st.equals("3"))
			sub_qu = " and c.cpt_cd_st='2' and c.cpt_cd in ('0016', '0017', '0021')";

		query2 = " select * from stat_debt c where c.save_dt='" + save_dt + "' and acct_code='45450' " + sub_qu
				+ " order by c.seq ";

		try {

			pstmt = conn.prepareStatement(query2);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatDebtLs]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 부채현황 등록
	 */
	public boolean insertStatDebt(StatDebtBean sd) {
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		int chk = 0;

		String query = "insert into stat_debt values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Y')";

		// 입력체크
		String query2 = "select count(*) from stat_debt where save_dt=? and seq=?";

		try {
			conn.setAutoCommit(false);

			pstmt2 = conn.prepareStatement(query2);
			pstmt2.setString(1, sd.getSave_dt());
			pstmt2.setString(2, sd.getSeq());
			rs = pstmt2.executeQuery();
			if (rs.next()) {
				chk = rs.getInt(1);
			}
			rs.close();
			pstmt2.close();

			if (chk == 0) {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, sd.getSave_dt());
				pstmt.setString(2, sd.getSeq());
				pstmt.setString(3, sd.getCpt_cd());
				pstmt.setLong(4, sd.getLast_mon_amt());
				pstmt.setLong(5, sd.getOver_mon_amt());
				pstmt.setLong(6, sd.getThis_mon_new_amt());
				pstmt.setLong(7, sd.getThis_mon_plan_amt());
				pstmt.setLong(8, sd.getThis_mon_pay_amt());
				pstmt.setLong(9, sd.getThis_mon_jan_amt());
				pstmt.setString(10, sd.getReg_id());
				pstmt.setLong(11, sd.getWhan_amt());
				pstmt.executeUpdate();
				pstmt.close();

			}

			conn.commit();

		} catch (Exception e) {
			System.out.println("[AdminDatabase:insertStatDebt]" + e);
			e.printStackTrace();
			flag = false;
			conn.rollback();
		} finally {
			try {
				conn.setAutoCommit(true);
				if (pstmt != null)
					pstmt.close();
				if (pstmt2 != null)
					pstmt2.close();
				if (rs != null)
					rs.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return flag;
		}
	}

	/**
	 * 리스트조회 -년도별 -
	 */
	public Vector getStatDebtList(String table_nm) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

	
		//당월
		//당해 당월이전 월말일
		//당해이전 년말
		query = " SELECT decode(save_dt, '', '', substr(save_dt, 1, 4)||'-'||substr(save_dt, 5, 2)||'-'||substr(save_dt, 7, 2)) save_dt FROM "+table_nm+" WHERE save_dt LIKE TO_CHAR(SYSDATE,'YYYYMM')||'%' GROUP BY save_dt\r\n" 
				+ "UNION all \r\n"
				+ "SELECT decode(MAX(save_dt), '', '', substr(MAX(save_dt), 1, 4)||'-'||substr(MAX(save_dt), 5, 2)||'-'||substr(MAX(save_dt), 7, 2)) save_dt FROM "+table_nm+" WHERE save_dt < TO_CHAR(SYSDATE,'YYYYMM') AND save_dt LIKE TO_CHAR(SYSDATE,'YYYY')||'%' GROUP BY SUBSTR(save_dt,1,6)\r\n" 
				+ "UNION all\r\n"
				+ "SELECT decode(MAX(save_dt), '', '', substr(MAX(save_dt), 1, 4)||'-'||substr(MAX(save_dt), 5, 2)||'-'||substr(MAX(save_dt), 7, 2)) save_dt FROM "+table_nm+" WHERE save_dt < TO_CHAR(SYSDATE,'YYYY') and save_dt > '20061231' GROUP BY SUBSTR(save_dt,1,4)\r\n"
				+ "ORDER BY 1 DESC";
		
		if (table_nm.equals("stat_rent_month")) {
			//당월
			//당해 당월이전 월말일
			//당해이전 년말
			query = " SELECT decode(save_dt, '', '', substr(save_dt, 1, 4)||'-'||substr(save_dt, 5, 2)||'-'||substr(save_dt, 7, 2)) save_dt, max(reg_dt) reg_dt  FROM "+table_nm+" WHERE save_dt LIKE TO_CHAR(SYSDATE,'YYYYMM')||'%' GROUP BY save_dt\r\n" 
					+ "UNION all \r\n"
					+ "SELECT decode(MAX(save_dt), '', '', substr(MAX(save_dt), 1, 4)||'-'||substr(MAX(save_dt), 5, 2)||'-'||substr(MAX(save_dt), 7, 2)) save_dt, max(reg_dt) reg_dt  FROM "+table_nm+" WHERE save_dt < TO_CHAR(SYSDATE,'YYYYMM') AND save_dt LIKE TO_CHAR(SYSDATE,'YYYY')||'%' GROUP BY SUBSTR(save_dt,1,6)\r\n" 
					+ "UNION all\r\n"
					+ "SELECT decode(MAX(save_dt), '', '', substr(MAX(save_dt), 1, 4)||'-'||substr(MAX(save_dt), 5, 2)||'-'||substr(MAX(save_dt), 7, 2)) save_dt, max(reg_dt) reg_dt  FROM "+table_nm+" WHERE save_dt < TO_CHAR(SYSDATE,'YYYY') and save_dt > '20061231' GROUP BY SUBSTR(save_dt,1,4)\r\n"
					+ "ORDER BY 1 DESC";
		}
			
		
		

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				StatDebtBean sd = new StatDebtBean();
				sd.setSave_dt(rs.getString(1));
				if (table_nm.equals("stat_rent_month")) {
					sd.setReg_dt(rs.getString(2));
				}
				vt.add(sd);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatDebt]" + e);
			System.out.println("[AdminDatabase:getStatDebt]" + query);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 리스트조회
	 */
	public Vector getStatDebtList(String table_nm, String gubun) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select"
				+ " decode(save_dt, '', '', substr(save_dt, 1, 4)||'-'||substr(save_dt, 5, 2)||'-'||substr(save_dt, 7, 2)) save_dt"
				+ " from " + table_nm + "";

		// 날짜 제한 2007년 이전은 안보이게
		query += " where ( save_dt > to_char(sysdate,'YYYY')-3||'1231' or save_dt like '%1231')";

		// 당월은 전부, 그전에는 말일자만 나오게..
		query += " and ( save_dt=TO_CHAR(LAST_DAY(save_dt),'YYYYMMDD') or save_dt like TO_CHAR(SYSDATE,'YYYYMM')||'%' )";

		if (gubun.equals("s")) {
			query += " and gubun='2'  ";
		} else if (gubun.equals("p")) {
			query += " and gubun  in ('5', '6')  ";
		} else if (gubun.equals("ls")) {
			if (table_nm.equals("stat_debt")) {
				query += " and acct_code='45450'  ";
			}
		} else {
			query += " and gubun  in ('1', '3') ";

		}

		query += " group by save_dt order by save_dt desc ";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				StatDebtBean sd = new StatDebtBean();
				sd.setSave_dt(rs.getString(1));
				vt.add(sd);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatDebt]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	public Vector getServAllNew1(String gubun, String gubun_nm, String gubun3, String sort, String car_ck) {
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";
		Vector vt = new Vector();

		if (gubun.equals("car_no")) {
			subQuery = "and b.car_no like '%" + gubun_nm + "%'\n";
		} else if (gubun.equals("firm_nm")) {
			if (car_ck.equals("1")) {
				subQuery = "and c.firm_nm like '%" + gubun_nm + "%' and rr.user_nm is not null \n";
			} else {
				subQuery = "and c.firm_nm like '%" + gubun_nm + "%' \n";
			}
		} else if (gubun.equals("client_nm")) {
			subQuery = "and c.client_nm like '%" + gubun_nm + "%'\n";
		} else if (gubun.equals("car_nm")) {
			subQuery = "and b.car_nm||h.car_name like '%" + gubun_nm + "%'\n";
		} else if (gubun.equals("jg_code")) {
			subQuery = "and h.jg_code like '%" + gubun_nm + "%'\n";
		} else {

		}

		if (gubun3.equals("1") || gubun3.equals("2")) {
			subQuery += "and decode(b.car_use,'',decode(a.car_st,'1','1','3','2'),b.car_use)='" + gubun3 + "'";
		}
		if (gubun3.equals("3") || gubun3.equals("4")) {
			subQuery += "and decode(ff.rent_way,'1','3','4')='" + gubun3 + "'";
		}

		query = "  select  \n"
				+ "        to_number(case when a.ddtt > 7 and a.tot_dist > 0 then a.tot_dist/a.ddtt * 30*12   else a.tot_dist/7 * 30*12 end) ss, \n"// 7이하는
																																					// 7로
																																					// 나눔,
																																					// 연평균주행거리
				+ "	       nvl(a.tot_dist,0) tot_dist, a.init_reg_dt, a.*    \n" + " from ( \n"
				+ "        select a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, \n"
				+ "	              b.car_mng_id as CAR_MNG_ID, b.car_no as CAR_NO, \n"
				+ "               rr.user_nm as USER_NM, rr.work_dt as WORK_DT, rr.sr as SR,  \n"
				+ "	              substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2) as RENT_DT, \n"
				+ "	              decode(b.init_reg_dt,'','',substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2)) as INIT_REG_DT, \n"
				+ "	              decode(f.rent_start_dt,'','',substr(f.rent_start_dt,1,4)||'-'||substr(f.rent_start_dt,5,2)||'-'||substr(f.rent_start_dt,7,2)) as RENT_START_DT, \n"
				+ "	              cm.user_nm as mng_user_nm, \n" + "	              c.client_nm, \n"
				+ "               c.firm_nm as FIRM_NM, j.car_nm || h.car_name as CAR_NM,  \n"
				+ "               vt.tot_dt as SERV_DT, vt.tot_dist as TOT_DIST, to_date(vt.tot_dt,'YYYYMMDD')-to_date(b.init_reg_dt,'YYYYMMDD') as DDTT, \n"
				+ "               decode(sign(to_number(to_date(nvl(vt.tot_dt,b.init_reg_dt),'YYYYMMDD')-to_date(b.init_reg_dt))-15),-1,1,0) reg_15_st \n"
				+ "	       from   cont a, car_reg b, client c, v_tot_dist vt, \n"
				+ "	              car_etc g, car_nm h, car_mng j, users cm, \n"
				+ "               ( select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, max(rent_start_dt) as rent_start_dt FROM fee group by rent_mng_id, rent_l_cd ) f, fee ff, \n"
				+ "               ( select 'Y' as SR, a.car_mng_id , a.cust_id, u.user_nm, a.rent_dt as work_dt \n"
				+ "                 from   rent_cont a , users u \n"
				+ "                 where  a.cust_id = u.user_id and a.rent_st in ('4','5') and a.use_st='2' \n"
				+ "               ) rr \n" + "	       where  \n" + "                   nvl(a.use_yn, 'Y')= 'Y' \n"
				+ "	              and nvl(b.prepare,'1')<>'4'  \n" // 도난차량 제외
				+ "               and a.car_mng_id=b.car_mng_id \n" + "	              and a.client_id=c.client_id \n"
				+ "               and a.car_mng_id=vt.car_mng_id(+) \n"
				+ "               and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd \n"
				+ "               and g.car_id = h.car_id and g.car_seq= h.car_seq and h.car_comp_id=j.car_comp_id and h.car_cd=j.code \n"
				+ "               and nvl(a.mng_id,a.bus_id2)=cm.user_id \n"
				+ "	              and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd  \n"
				+ "	              and f.rent_mng_id=ff.rent_mng_id and f.rent_l_cd=ff.rent_l_cd and f.rent_st=ff.rent_st \n"
				+ "               and b.car_mng_id=rr.car_mng_id(+)\n" + subQuery + " \n" + " ) a \n";

		if (sort.equals("1")) {
			query += "order by  a.reg_15_st, 2 desc, 3 asc, a.rent_start_dt \n";
		} else if (sort.equals("2")) {
			query += "order by  a.reg_15_st, 1 desc, 2 desc, 3 asc, a.rent_start_dt \n";
		} else if (sort.equals("3")) {
			query += "order by  a.reg_15_st, 3 asc, a.rent_start_dt \n";
		}

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getServAllNew1]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	public Vector getServAllNew2(String gubun, String gubun_nm, String gubun3, String gubun2, String sort,
			String car_ck) {
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";
		Vector vt = new Vector();

		if (gubun.equals("car_no")) {
			subQuery = "and a.car_no like '%" + gubun_nm + "%'\n";
		} else if (gubun.equals("firm_nm")) {
			if (car_ck.equals("1")) {
				subQuery = "and a.firm_nm like '%" + gubun_nm + "%'   \n";
			} else {
				subQuery = "and a.firm_nm like '%" + gubun_nm + "%' \n";
			}
		} else if (gubun.equals("car_nm")) {
			subQuery = "and a.car_nm||h.car_name like '%" + gubun_nm + "%'\n";
		} else if (gubun.equals("jg_code")) {
			subQuery = "and a.jg_code like '%" + gubun_nm + "%'\n";
		} else if (gubun.equals("mng_nm")) {
			subQuery = "and a.mng_nm like '%" + gubun_nm + "%'\n";
		} else {

		}

		if (gubun3.equals("1") || gubun3.equals("2")) {
			subQuery += "and decode(a.car_use,'',decode(a.car_st,'1','1','3','2'),a.car_use)='" + gubun3 + "'";
		}
		if (gubun2.equals("3") || gubun2.equals("4")) {
			subQuery += "and decode(a.rent_way,'1','3','4')='" + gubun2 + "'";
		}

		query = " select  a.*, decode(a.rent_way, '1', '일반식', '3', '기본식', '보유차' ) rent_way_nm  from stat_car_mng a , users u  \n"
				+ "  where  a.mng_id = u.user_id(+)" + subQuery;

		if (sort.equals("1")) {
			query += "order by  a.reg_15_st, a.tot_dist  desc, a.init_reg_dt asc, a.rent_start_dt \n";
		} else if (sort.equals("2")) {
			query += "order by  a.reg_15_st, a.y_ave_dist desc, a.tot_dist desc, a.init_reg_dt asc, a.rent_start_dt \n";
		} else if (sort.equals("3")) {
			query += "order by  a.reg_15_st, a.init_reg_dt asc, a.rent_start_dt \n";
		}

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getServAllNew2]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	public Vector getServAllCost(String gubun, String gubun_nm, String gubun3, String gubun4, String sort,
			String car_ck) {
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";
		Vector vt = new Vector();

		if (gubun_nm.equals("")) {
			gubun_nm = "^^^";
		}

		if (gubun.equals("car_no")) {
			subQuery = " and a.car_no like '%" + gubun_nm + "%'\n";
		} else if (gubun.equals("firm_nm")) {
			if (car_ck.equals("1")) {
				subQuery = " and a.firm_nm like '%" + gubun_nm + "%' and rr.user_nm is not null \n";
			} else {
				subQuery = " and a.firm_nm like '%" + gubun_nm + "%' \n";
			}
		} else if (gubun.equals("car_nm")) {
			subQuery = " and a.car_nm like '%" + gubun_nm + "%'\n";
		} else if (gubun.equals("jg_code")) {
			subQuery = " and a.jg_code like '%" + gubun_nm + "%'\n";
		} else if (gubun.equals("bus_itm")) {
			subQuery = " and c.bus_itm like '%" + gubun_nm + "%'\n";
		} else {

		}

		if (gubun3.equals("1") || gubun3.equals("2")) {
			subQuery += "and decode(a.car_use,'',decode(a.car_st,'1','1','3','2'),a.car_use)='" + gubun3 + "'";
		}
		if (gubun3.equals("3") || gubun3.equals("4")) {
			subQuery += "and decode(a.rent_way,'1','3','4')='" + gubun3 + "'";
		}

		if (!gubun4.equals("")) {
			subQuery += "and a.car_gu = '" + gubun4 + "'";
		}

		query = " select decode(a.car_st,  '2', '4', '1', '1', '3', '1') p_sort,  a.*, decode(a.rent_way,  '3', '기본식', '1', '일반식', '예비차' ) rent_way_nm, c.bus_itm, \n"
				+ "        d.nm as fuel_nm, \n"
				+ "        decode(a.rent_st,  '1', '신규', '3', '대차',  '4', '증차', '' ) rent_st_nm, \n"
				+ "        decode(a.car_gu,  '0', '재리스', '1', '신차',  '2', '중고차', '3', '월렌트', '' ) car_gu_nm, \n"
				+ "        decode(a.etc_gu,  '1', '연장', '2', '승계',  '4', '차종변경', '' ) etc_gu_nm ,  d.agree_dist, \n"
				+ "        trunc(months_between(sysdate, to_date(a.rent_start_dt, 'yyyy-mm-dd') ), 1) umon \n"
				+ "  from  stat_car_mng a , client c , fee_etc d, (select * from code where c_st='0039') d \n"
				+ "  where a.client_id = c.client_id(+) and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd and nvl(a.rent_st, '1') = d.rent_st and a.fuel_kd=d.nm_cd \n"
				+ subQuery;

		if (sort.equals("1")) {
			query += " order by  decode(a.car_st,  '2', '4', '1', '1', '3', '1'  ) asc , a.reg_15_st,  a.tot_dist  desc, a.init_reg_dt asc, a.rent_start_dt \n";
		} else if (sort.equals("2")) {
			query += " order by  decode(a.car_st,  '2', '4', '1', '1', '3', '1'  ) asc,  a.reg_15_st,  a.y_ave_dist desc, a.tot_dist desc, a.init_reg_dt asc, a.rent_start_dt \n";
		} else if (sort.equals("3")) {
			query += " order by  decode(a.car_st,  '2', '4', '1', '1', '3', '1'  ) asc,  a.reg_15_st,  a.init_reg_dt asc, a.rent_start_dt \n";
		} else if (sort.equals("4")) {
			query += " order by  decode(a.car_st,  '2', '4', '1', '1', '3', '1'  ) asc,  a.reg_15_st,  a.amt9 desc, a.rent_start_dt \n";
		} else if (sort.equals("5")) {
			query += " order by  decode(a.car_st,  '2', '4', '1', '1', '3', '1'  ) asc,  a.reg_15_st,  a.amt10 desc, a.rent_start_dt \n";
		} else if (sort.equals("6")) {
			query += " order by  decode(a.car_st,  '2', '4', '1', '1', '3', '1'  ) asc,  a.reg_15_st,  a.firm_nm asc, a.rent_start_dt \n";
		} else if (sort.equals("7")) {
			query += " order by  decode(a.car_st,  '2', '4', '1', '1', '3', '1'  ) asc,  a.reg_15_st,  a.jg_code asc, a.rent_start_dt \n";
		}

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getServAllCost]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/* chk1: 1-> 한달전 */
	public Vector getServAllCost(String st_dt, String end_dt, String gubun, String gubun_nm, String gubun3,
			String gubun4, String chk1, String sort, String car_ck) {
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";
		Vector vt = new Vector();

		if (gubun_nm.equals("")) {
			gubun_nm = "^^^";
		}

		if (gubun.equals("car_no")) {
			subQuery = " and a.car_no like '%" + gubun_nm + "%'\n";
		} else if (gubun.equals("firm_nm")) {
			if (car_ck.equals("1")) {
				subQuery = " and a.firm_nm like '%" + gubun_nm + "%' and rr.user_nm is not null \n";
			} else {
				subQuery = " and a.firm_nm like '%" + gubun_nm + "%' \n";
			}
		} else if (gubun.equals("car_nm")) {
			subQuery = " and a.car_nm like '%" + gubun_nm + "%'\n";
		} else if (gubun.equals("jg_code")) {
			subQuery = " and a.jg_code like '%" + gubun_nm + "%'\n";
		} else if (gubun.equals("bus_itm")) {
			subQuery = " and c.bus_itm like '%" + gubun_nm + "%'\n";
		} else {

		}

		if (gubun3.equals("1") || gubun3.equals("2")) {
			subQuery += "and decode(a.car_use,'',decode(a.car_st,'1','1','3','2'),a.car_use)='" + gubun3 + "'";
		}
		if (gubun3.equals("3") || gubun3.equals("4")) {
			subQuery += "and decode(a.rent_way,'1','3','4')='" + gubun3 + "'";
		}

		if (!gubun4.equals("")) {
			subQuery += "and a.car_gu = '" + gubun4 + "'";
		}

		if (!st_dt.equals("") && !end_dt.equals("")) {
			subQuery += " and replace(a.rent_start_dt, '-' , '') between replace('" + st_dt
					+ "', '-', '')  and  replace('" + end_dt + "', '-', '') \n";
		}

		query = " select decode(a.car_st,  '2', '4', '1', '1', '3', '1') p_sort,  a.*, decode(a.rent_way,  '3', '기본식', '1', '일반식', '예비차' ) rent_way_nm, c.bus_itm,  \n "
				+ " e.nm as fuel_nm,  \n "
				+ " decode(a.rent_st,  '1', '신규', '3', '대차',  '4', '증차', '' ) rent_st_nm,   \n "
				+ " decode(a.car_gu,  '0', '재리스', '1', '신차',  '2', '중고차', '3', '월렌트', '' ) car_gu_nm ,  \n "
				+ " decode(a.etc_gu,  '1', '연장', '2', '승계',  '4', '차종변경', '' ) etc_gu_nm ,    \n"
				+ "  trunc(months_between(sysdate, to_date(a.rent_start_dt, 'yyyy-mm-dd') ), 2) umon,  \n "
				+ "  trunc(months_between(add_months(sysdate , -1), to_date(a.rent_start_dt, 'yyyy-mm-dd') ), 2) umon1 \n "
				+ "  from stat_car_mng a , client c , (select * from code where c_st='0039') e  \n"
				+ "  where  a.client_id = c.client_id(+) and  a.fuel_kd=e.nm_cd \n" + subQuery;

		if (chk1.equals("1"))
			query += " and a.chk1 = '1'";
		else
			query += " and a.chk1 is null ";

		if (sort.equals("1")) {
			query += " order by  decode(a.car_st,  '2', '4', '1', '1', '3', '1'  ) asc , a.reg_15_st,  a.tot_dist  desc, a.init_reg_dt asc, a.rent_start_dt \n";
		} else if (sort.equals("2")) {
			query += " order by  decode(a.car_st,  '2', '4', '1', '1', '3', '1'  ) asc,  a.reg_15_st,  a.y_ave_dist desc, a.tot_dist desc, a.init_reg_dt asc, a.rent_start_dt \n";
		} else if (sort.equals("3")) {
			query += " order by  decode(a.car_st,  '2', '4', '1', '1', '3', '1'  ) asc,  a.reg_15_st,  a.init_reg_dt asc, a.rent_start_dt \n";
		} else if (sort.equals("4")) {
			query += " order by  decode(a.car_st,  '2', '4', '1', '1', '3', '1'  ) asc,  a.reg_15_st,  a.amt17 desc, a.rent_start_dt \n";
		} else if (sort.equals("5")) {
			query += " order by  decode(a.car_st,  '2', '4', '1', '1', '3', '1'  ) asc,  a.reg_15_st,  a.amt18 desc, a.rent_start_dt \n";
		} else if (sort.equals("6")) {
			query += " order by  decode(a.car_st,  '2', '4', '1', '1', '3', '1'  ) asc,  a.reg_15_st,  a.firm_nm asc, a.rent_start_dt \n";
		} else if (sort.equals("7")) {
			query += " order by  decode(a.car_st,  '2', '4', '1', '1', '3', '1'  ) asc,  a.reg_15_st,  a.jg_code asc, a.rent_start_dt \n";
		}

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			// System.out.println("AdminDatabase:getServAllCost:"+query);

			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getServAllCost]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 마지막 등록일자 조회
	 */
	public String getMaxSaveDt(String table_nm) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String save_dt = "";

		String query = "select max(save_dt) from " + table_nm;

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				save_dt = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (Exception e) {
			System.out.println("[AdminDatabase:getMaxSaveDt]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return save_dt;
		}
	}

	public String getMaxSaveDtChk(String table_nm, String gubun) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String save_dt = "";

		String query = "select max(save_dt) from " + table_nm + " where gubun = '" + gubun + "'";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				save_dt = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (Exception e) {
			System.out.println("[AdminDatabase:getMaxSaveDt]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return save_dt;
		}
	}

	/**
	 * 중복등록 확인
	 */
	public int getInsertYn(String table_nm, String today) {
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		int count = 0;

		String query = "select count(*) from " + table_nm + " where save_dt='" + today + "'";

		String query2 = "delete from " + table_nm + " where save_dt='" + today + "'";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

			if (count > 0) {
				pstmt2 = conn.prepareStatement(query2);
				pstmt2.executeUpdate();
				pstmt2.close();
				count = 0;
			}

			conn.commit();
		} catch (Exception e) {
			System.out.println("[AdminDatabase:getInsertYn]" + e);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (pstmt2 != null)
					pstmt2.close();
				conn.setAutoCommit(true);
			} catch (Exception ignore) {
			}
			closeConnection();
			return count;
		}
	}

	/**
	 * 중복등록 확인 - 캠페인 지급 및 실적 관련
	 */
	public int getInsertYn(String table_nm, String today, String mode, String s_type) {
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		int count = 0;
		String r_mode = "";

		if (mode.equals("12")) {
			r_mode = "2";
		} else if (mode.equals("13")) {
			r_mode = "1";
		} else if (mode.equals("25")) { // 1군정비
			r_mode = "5";
		} else if (mode.equals("26")) {
			r_mode = "6";
		} else if (mode.equals("28")) { // 1군사고
			r_mode = "28";
		} else if (mode.equals("29")) { // 2군비용
			r_mode = "29";
		} else if (mode.equals("30")) { // 1군 비용
			r_mode = "30";
		}

		String query = "select count(*) from " + table_nm + " where save_dt='" + today + "' and gubun = '" + r_mode
				+ "' and s_type = '" + s_type + "'";

		String query2 = "delete from " + table_nm + " where save_dt='" + today + "' and gubun = '" + r_mode
				+ "' and s_type = '" + s_type + "'";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

			if (count > 0) {
				pstmt2 = conn.prepareStatement(query2);
				pstmt2.executeUpdate();
				pstmt2.close();
				count = 0;
			}

			conn.commit();
		} catch (Exception e) {
			System.out.println("[AdminDatabase:getInsertYn]" + e);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (pstmt2 != null)
					pstmt2.close();
				conn.setAutoCommit(true);
			} catch (Exception ignore) {
			}
			closeConnection();
			return count;
		}
	}

	// 일자별 max
	public int getMaxSeq(String table_nm, String today, String mode) {
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		int count = 0;
		String r_mode = "";

		if (mode.equals("12")) {
			r_mode = "2";
		} else if (mode.equals("13")) {
			r_mode = "1";
		} else if (mode.equals("25")) {
			r_mode = "5";
		} else if (mode.equals("26")) {
			r_mode = "6";
		} else if (mode.equals("28")) { // 1군사고
			r_mode = "28";
		} else if (mode.equals("29")) { // 2군
			r_mode = "29";
		} else if (mode.equals("30")) { // 1군
			r_mode = "30";
		}

		String query = "select nvl(max(seq),0)  from " + table_nm + " where save_dt='" + today + "' and gubun = '"
				+ r_mode + "'";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (Exception e) {
			System.out.println("[AdminDatabase:getMaxSeq]" + e);
			e.printStackTrace();

		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();

			} catch (Exception ignore) {
			}
			closeConnection();
			return count;
		}
	}

	/**
	 * 차량 중복 확인
	 */
	public int getCarOverlapChk() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

		String query = " select count(*) " + " from   cont a, car_reg b "
				+ " where  nvl(a.use_yn,'Y')='Y' and a.car_mng_id is not null and a.car_mng_id=b.car_mng_id and a.rent_l_cd not like 'RM%' "
				+ " group by b.car_num having count(*) > 1";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (Exception e) {
			System.out.println("[AdminDatabase:getCarOverlapChk]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return count;
		}
	}

	// 자동차보유현황-------------------------------------------------------------------------------

	/**
	 * 2000년 이전 등록차량 대수
	 */
	public int getBeforeCarCnt() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int cnt = 0;
		String query = " select count(*) from car_reg where init_reg_dt < '20000101'";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				cnt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getBeforeCarCnt]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return cnt;
		}
	}

	/**
	 * 당일기준 조회
	 */
	public Vector getStatCar() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " select "
				+ " b.car_no, decode(substr(b.car_no,1,2), '서울','서울','경기','파주', decode(nvl(b.car_ext,c.car_ext),'1','서울','2','경기','6','파주')) age,"
				+ "  decode(b.car_use , '1','영업용',  '자가용') use,			\n"
				+ " to_number(b.car_kd), to_number(substr(b.init_reg_dt, 1,4)) year, c.car_ext "
				+ " from cont a, car_reg b, car_etc c where a.car_mng_id=b.car_mng_id and nvl(a.use_yn,'Y')='Y'"
				+ " and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and nvl(b.prepare,'1')<>'4'";//

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				StatCarBean bean = new StatCarBean();

				bean.setCar_no(rs.getString(1));
				bean.setAge(rs.getString(2));
				bean.setUse(rs.getString(3));
				bean.setKd(rs.getInt(4));
				bean.setYear(rs.getInt(5));

				vt.add(bean);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatCar]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 당일기준 조회
	 */
	public Vector getStatCar2() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select" + " car_ext, car_use, decode(car_use,'1',car_kd1,'2',car_kd2) car_kd,"
				+ " count(decode(init_year,'2000',car_mng_id)) cnt0, "
				+ " count(decode(init_year,'2001',car_mng_id)) cnt1, "
				+ " count(decode(init_year,'2002',car_mng_id)) cnt2, "
				+ " count(decode(init_year,'2003',car_mng_id)) cnt3, "
				+ " count(decode(init_year,'2004',car_mng_id)) cnt4, "
				+ " count(decode(init_year,'2005',car_mng_id)) cnt5, "
				+ " count(decode(init_year,'2006',car_mng_id)) cnt6, "
				+ " count(decode(init_year,'2007',car_mng_id)) cnt7, "
				+ " count(decode(init_year,'2008',car_mng_id)) cnt8, "
				+ " count(decode(init_year,'2009',car_mng_id)) cnt9, "
				+ " count(decode(init_year,'2010',car_mng_id)) cnt10,"
				+ " count(decode(init_year,'2011',car_mng_id)) cnt11,"
				+ " count(decode(init_year,'2012',car_mng_id)) cnt12,"
				+ " count(decode(init_year,'2013',car_mng_id)) cnt13,"
				+ " count(decode(init_year,'2014',car_mng_id)) cnt14,"
				+ " count(decode(init_year,'2015',car_mng_id)) cnt15,"
				+ " count(decode(init_year,'2016',car_mng_id)) cnt16,"
				+ " count(decode(init_year,'2017',car_mng_id)) cnt17,"
				+ " count(decode(init_year,'2018',car_mng_id)) cnt18,"
				+ " count(decode(init_year,'2019',car_mng_id)) cnt19,"
				+ " count(decode(init_year,'2020',car_mng_id)) cnt20 " + " from" + " ("
				+ " select b.car_mng_id, b.car_ext, b.car_use, decode(substr(b.init_reg_dt,1,4),'1998','2000',substr(b.init_reg_dt,1,4)) init_year,"
				+ " decode(b.car_kd, '1','1','2','1','3','1','9','1', '4','2', '5','3') car_kd1,"
				+ " decode(b.car_kd, '1','1','2','1','3','1','9','1', '4','2','5','2', '6','3','7','3','8','3') car_kd2"
				+ " from cont a, car_reg b"
				+ " where nvl(a.use_yn,'Y')='Y' and nvl(b.prepare,'0')<>'4' and a.car_mng_id=b.car_mng_id"
				+ " ) group by car_ext, car_use, decode(car_use,'1',car_kd1,'2',car_kd2) "
				+ "   order by car_ext, car_use, decode(car_use,'1',car_kd1,'2',car_kd2)";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatCar2]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 마감 조회
	 */
	public Vector getStatCar(String save_dt) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " select * from stat_car where save_dt=replace(?, '-', '') order by seq";

		try {

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, save_dt);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				StatCarBean bean = new StatCarBean();

				bean.setSave_dt(rs.getString(1));
				bean.setSeq(rs.getString(2));
				bean.setY2000(rs.getInt(3));
				bean.setY2001(rs.getInt(4));
				bean.setY2002(rs.getInt(5));
				bean.setY2003(rs.getInt(6));
				bean.setY2004(rs.getInt(7));
				bean.setY2005(rs.getInt(8));
				bean.setReg_id(rs.getString(9));
				bean.setY2006(rs.getInt(11));
				bean.setY2009(rs.getInt(12));
				bean.setY2008(rs.getInt(13));
				bean.setY2007(rs.getInt(14));
				bean.setY2010(rs.getInt(15));
				bean.setY2011(rs.getInt(16));
				bean.setY2012(rs.getInt(17));
				bean.setY2013(rs.getInt(18));
				bean.setY2014(rs.getInt(19));
				bean.setY2015(rs.getInt(20));
				bean.setY2016(rs.getInt(21));
				bean.setY2017(rs.getInt(22));
				bean.setY2018(rs.getInt(23));
				bean.setY2019(rs.getInt(24));
				bean.setY2020(rs.getInt(25));
				vt.add(bean);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatCar(save_dt)]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 자동차보유현황 등록
	 */
	public boolean insertStatCar(StatCarBean bean) {
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = "insert into stat_car values (?, ?, ?, ?, ?, ?, ?, ?, ?, 'Y', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getSave_dt());
			pstmt.setString(2, bean.getSeq());
			pstmt.setInt(3, bean.getY2000());
			pstmt.setInt(4, bean.getY2001());
			pstmt.setInt(5, bean.getY2002());
			pstmt.setInt(6, bean.getY2003());
			pstmt.setInt(7, bean.getY2004());
			pstmt.setInt(8, bean.getY2005());
			pstmt.setString(9, bean.getReg_id());
			pstmt.setInt(10, bean.getY2006());
			pstmt.setInt(11, bean.getY2009());
			pstmt.setInt(12, bean.getY2008());
			pstmt.setInt(13, bean.getY2007());
			pstmt.setInt(14, bean.getY2010());
			pstmt.setInt(15, bean.getY2011());
			pstmt.setInt(16, bean.getY2012());
			pstmt.setInt(17, bean.getY2013());
			pstmt.setInt(18, bean.getY2014());
			pstmt.setInt(19, bean.getY2015());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
			System.out.println("[AdminDatabase:insertStatDebt]" + e);
			e.printStackTrace();
			flag = false;
			conn.rollback();
		} finally {
			try {
				conn.setAutoCommit(true);
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return flag;
		}
	}

	// 연체현황-----------------------------------------------------------------------------------------------

	/**
	 * 연체현황
	 */
	public Vector getDlyBusStat(String brch_id, String dept_id, String save_dt) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_qu = "";

		if (save_dt.equals("")) {
			query = " select b.bus_id2, c.user_nm, c.br_id, c.dept_id, b.tot_su, b.tot_amt, nvl(a.su,0) su, nvl(a.amt,0) amt,"
					+ "        to_number(nvl(to_char((a.amt/b.tot_amt)*100, 999.99),0)) per1, '' per2, c.partner_id, e.user_nm as partner_nm"
					+ " from"
					+ "	     ( select /*+  merge(b) */ b.bus_id2, count(*) su, sum(a.fee_s_amt+a.fee_v_amt) amt"
					+ "	       from   scd_fee a, cont_n_view b, cls_cont c "
					+ "          where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_mng_id=c.rent_mng_id(+) and b.rent_l_cd=c.rent_l_cd(+) "
					+ "	              and a.rc_yn='0' and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and a.bill_yn<>'N' and a.tm_st2<>'4' and nvl(c.cls_st,'0')<>'2'"
					+ "	       group by b.bus_id2" + "        ) a, "
					+ "	     ( select /*+  merge(b) */ b.bus_id2, count(*) tot_su, sum(a.fee_s_amt+a.fee_v_amt) tot_amt"
					+ "	       from   scd_fee a, cont_n_view b, cls_cont c "
					+ "          where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  and b.rent_mng_id=c.rent_mng_id(+) and b.rent_l_cd=c.rent_l_cd(+) "
					+ "	              and a.rc_yn='0' and a.bill_yn<>'N' and a.tm_st2<>'4' and nvl(c.cls_st,'0')<>'2'"
					+ "	       group by b.bus_id2" + "        ) b, "
					+ "        users c, (select bus_id2 from cont group by bus_id2) d, users e"
					+ " where  d.bus_id2=a.bus_id2(+) and d.bus_id2=b.bus_id2(+) and d.bus_id2=c.user_id and c.partner_id=e.user_id(+)"
					+ "        and b.bus_id2 is not null";
			sub_qu = "to_number(nvl(to_char((a.amt/b.tot_amt)*100, 999.99),0))";
		} else {
			query = " select a.save_dt, a.seq, a.bus_id2, a.tot_amt, a.su, a.amt, "
					+ "        case when a.per1>1 then a.per1 else to_char(a.per1, '0.99') end per1,"
					+ "        case when a.per2>1 then a.per2 else to_char(a.per2, '0.99') end per2,"
					+ "        a.reg_id, a.use_yn, a.tot_dly_amt, 0 tot_su, c.br_id, c.dept_id, c.partner_id, d.user_nm as partner_nm "
					+ " from   stat_dly a, users c, users d "
					+ " where  a.bus_id2=c.user_id and c.partner_id=d.user_id(+) " + "	     and a.save_dt='" + save_dt
					+ "'";
			sub_qu = "seq";
		}
		if (!brch_id.equals(""))
			query += " and c.br_id='" + brch_id + "'";
		if (!dept_id.equals(""))
			query += " and c.dept_id='" + dept_id + "'";

		query += " order by " + sub_qu + " , a.amt desc";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString("bus_id2"));
				fee.setBr_id(rs.getString("br_id"));
				fee.setDept_id(rs.getString("dept_id"));
				fee.setTot_su1(rs.getString("tot_su"));
				fee.setTot_amt1(rs.getString("tot_amt"));
				fee.setTot_su2(rs.getString("su"));
				fee.setTot_amt2(rs.getString("amt"));
				fee.setTot_su3(rs.getString("per1"));
				fee.setTot_su4(rs.getString("per2") == null ? "" : rs.getString("per2"));
				fee.setPartner_id(rs.getString("partner_id") == null ? "" : rs.getString("partner_id"));
				fee.setPartner_nm(rs.getString("partner_nm") == null ? "" : rs.getString("partner_nm"));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getDlyBusStat]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 연체현황
	 */
	public Vector getDlyBusStatAvg(String brch_id, String dept_id, String s_yy, String s_mm) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_qu = "";

		query = " select a.*, 0 tot_su, c.br_id, c.dept_id, c.enter_dt \n" + " from \n "
				+ " (select bus_id2, trunc(avg(tot_amt)) tot_amt, trunc(avg(su)) su, trunc(avg(amt)) amt, avg(per1) per1, avg(per2) per2"
				+ " from stat_dly where save_dt between replace('" + s_yy + "','-','') and replace('" + s_mm
				+ "','-','') group by bus_id2) a," + " users c \n" + " where a.bus_id2=c.user_id";

		if (!brch_id.equals(""))
			query += " and c.br_id='" + brch_id + "'";

		if (dept_id.equals("all")) {
			query += "  and c.dept_id in ('0001','0002','0007','0008','0009','0010','0011','0012','0013','0014','0015','0016', '0017', '0018' ) "
					+ " and c.user_pos in ('사원','대리','과장','차장') \n";
		} else {
			if (!dept_id.equals("0004"))
				query += " and c.dept_id='" + dept_id + "' and c.user_pos in ('사원','대리','과장','차장')";
			else
				query += " and c.user_pos not in ('사원','대리','과장','차장')";
		}

		query += " order by c.dept_id,  a.per1";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun_sub(rs.getString("enter_dt"));
				fee.setGubun(rs.getString("bus_id2"));
				fee.setBr_id(rs.getString("br_id"));
				fee.setDept_id(rs.getString("dept_id"));
				fee.setTot_su1(rs.getString("tot_su"));
				fee.setTot_amt1(rs.getString("tot_amt"));
				fee.setTot_su2(rs.getString("su"));
				fee.setTot_amt2(rs.getString("amt"));
				fee.setTot_su3(rs.getString("per1"));
				fee.setTot_su4(rs.getString("per2") == null ? "" : rs.getString("per2"));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getDlyBusStat]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 연체현황 등록
	 */
	public boolean insertStatDly(StatDlyBean sd) {
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = "insert into stat_dly values (?, ?, ?, ?, ?, ?, ?, ?, ?, 'Y', ?)";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, sd.getSave_dt());
			pstmt.setString(2, sd.getSeq());
			pstmt.setString(3, sd.getBus_id2());
			pstmt.setLong(4, sd.getTot_amt());
			pstmt.setInt(5, sd.getSu());
			pstmt.setLong(6, sd.getAmt());
			pstmt.setString(7, sd.getPer1());
			pstmt.setString(8, sd.getPer2());
			pstmt.setString(9, sd.getReg_id());
			pstmt.setLong(10, sd.getTot_dly_amt());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
			System.out.println("[AdminDatabase:insertStatDly]" + e);
			e.printStackTrace();
			flag = false;
			conn.rollback();
		} finally {
			try {
				conn.setAutoCommit(true);
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return flag;
		}
	}

	/**
	 * 미수금 연체현황
	 */
	public Vector getSettleBusStatAvg(String brch_id, String dept_id, String s_yy, String s_mm) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_qu = "";

		query = " select a.*, 0 tot_su, c.br_id, c.dept_id, c.enter_dt" + " from"
				+ " (select bus_id2, trunc(avg(tot_amt)) tot_amt, trunc(avg(su)) su, trunc(avg(amt)) amt, trunc(avg(per1),2) per1, trunc(avg(per2),2) per2"
				+ " from stat_settle where save_dt between replace('" + s_yy + "','-','') and replace('" + s_mm
				+ "','-','') group by bus_id2) a," + " users c" + " where a.bus_id2=c.user_id";

		if (!brch_id.equals(""))
			query += " and c.br_id='" + brch_id + "'";

		if (dept_id.equals("all")) {
			query += "  and c.dept_id in ('0001','0002','0007','0008','0009','0010','0011','0012','0013','0014','0015','0016', '0017', '0018' ) "
					+ "  and c.user_pos in ('사원','대리','과장','차장') \n";
		} else {
			if (!dept_id.equals("0004"))
				query += " and c.dept_id='" + dept_id + "' and c.user_pos in ('사원','대리','과장','차장') ";
			else
				query += " and c.user_pos not in ('사원','대리','과장','차장')";
		}

		query += " order by c.dept_id, a.per1";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun_sub(rs.getString("enter_dt"));
				fee.setGubun(rs.getString("bus_id2"));
				fee.setBr_id(rs.getString("br_id"));
				fee.setDept_id(rs.getString("dept_id"));
				fee.setTot_su1(rs.getString("tot_su"));
				fee.setTot_amt1(rs.getString("tot_amt"));
				fee.setTot_su2(rs.getString("su"));
				fee.setTot_amt2(rs.getString("amt"));
				fee.setTot_su3(rs.getString("per1"));
				fee.setTot_su4(rs.getString("per2") == null ? "" : rs.getString("per2"));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleBusStatAvg]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 미수금현황 등록
	 */
	public boolean insertStatSettle(StatDlyBean sd) {
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = "insert into stat_settle values (?, ?, ?, ?, ?, ?, ?, ?, ?, 'Y', ?, ?, 0, 0, '', ?, ?)";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, sd.getSave_dt());
			pstmt.setString(2, sd.getSeq());
			pstmt.setString(3, sd.getBus_id2());
			pstmt.setLong(4, sd.getTot_amt());
			pstmt.setInt(5, sd.getSu());
			pstmt.setLong(6, sd.getAmt());
			pstmt.setString(7, sd.getPer1());
			pstmt.setString(8, sd.getPer2());
			pstmt.setString(9, sd.getReg_id());
			pstmt.setLong(10, sd.getTot_dly_amt());
			pstmt.setLong(11, sd.getThree_amt());
			pstmt.setString(12, sd.getAvg_per());
			pstmt.setString(13, sd.getCmp_per());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
			System.out.println("[AdminDatabase:insertStatSettle]" + e);
			e.printStackTrace();
			flag = false;
			conn.rollback();
		} finally {
			try {
				conn.setAutoCommit(true);
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return flag;
		}
	}

	/**
	 * 연체현황 통계자료
	 */
	public String getDlyPers(String mode, String brch_id, String bus_id2, String st_dt, String end_dt) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		LastDay ld = new LastDay();
		LastMonth lm = new LastMonth();
		String result = "";
		String jobday = "";
		String jobmonth = "";
		String day = "";
		String all = "";
		int day_minus = 0;
		int while_day = 0;
		int count = 0;
		String query = "";

		// 일별통계
		if (mode.equals("d")) {

			if (brch_id.equals("") && bus_id2.equals("")) { // 아마존카전체
				query = " select save_dt, to_char(to_number(avg(per1))*10, 999) per1" + " from stat_dly"
						+ " where save_dt between '" + st_dt + "' and '" + end_dt + "'"
						+ " group by save_dt order by save_dt";
			} else if (!brch_id.equals("") && bus_id2.equals("")) { // 영업소전체
				query = " select a.save_dt, to_char(to_number(avg(a.per1))*10, 999) per1" + " from stat_dly a, users c"
						+ " where a.bus_id2=c.user_id" + " and a.save_dt between '" + st_dt + "' and '" + end_dt
						+ "' and c.br_id='" + brch_id + "'" + " group by a.save_dt order by a.save_dt";
			} else {
				query = " select a.save_dt, to_char(to_number(a.per1)*10, 999) per1 " + " from stat_dly a, users c"
						+ " where a.bus_id2=c.user_id" + " and a.save_dt between '" + st_dt + "' and '" + end_dt + "'"
						+ " and c.user_id='" + bus_id2 + "'" + " order by a.save_dt";
			}
			while_day = 31;

			// 월별통계
		} else {

			if (brch_id.equals("") && bus_id2.equals("")) { // 아마존카전체
				query = " select substr(save_dt,1,6) save_dt, to_char(to_number(avg(per1))*10, 999) per1"
						+ " from stat_dly" + " where save_dt between '" + st_dt.substring(0, 6) + "01' and '"
						+ end_dt.substring(0, 6) + "31'" + " group by substr(save_dt,1,6) order by substr(save_dt,1,6)";
			} else if (!brch_id.equals("") && bus_id2.equals("")) { // 영업소전체
				query = " select substr(a.save_dt,1,6) save_dt, to_char(to_number(avg(a.per1))*10, 999) per1"
						+ " from stat_dly a, users c" + " where a.bus_id2=c.user_id"
						+ " and a.save_dt between '" + st_dt.substring(0, 6) + "01' and '"
						+ end_dt.substring(0, 6) + "31' and c.br_id='" + brch_id + "'"
						+ " group by substr(a.save_dt,1,6) order by substr(a.save_dt,1,6)";
			} else {
				query = " select substr(a.save_dt,1,6) save_dt, to_char(to_number(avg(a.per1))*10, 999) per1 "
						+ " from " + " ( select bus_id2, substr(save_dt,1,6) save_dt, avg(per1) per1 "
						+ "   from   stat_dly" + "   group by bus_id2, substr(save_dt,1,6) " + "     ) a, users c"
						+ " where a.bus_id2=c.user_id" + " and a.save_dt between '" + st_dt.substring(0, 6)
						+ "01' and '" + end_dt.substring(0, 6) + "31'" + " and c.br_id='" + brch_id + "' and c.user_id='"
						+ bus_id2 + "'" + " group by substr(a.save_dt,1,6) " + " order by substr(a.save_dt,1,6)";
			}

			while_day = 12;
		}

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			day_minus = while_day;

			while (rs.next()) {

				if (mode.equals("d")) {
					jobday = rs.getString("save_dt");
					day = ld.addDay(st_dt, while_day - day_minus);
					while ((!jobday.equals(day)) && day_minus > 0) {
						all = all + "/0";
						day_minus--;
						day = ld.addDay(st_dt, while_day - day_minus);
					}
					day_minus--;
					all = all + "/" + rs.getString("per1").trim() + "";
				} else {
					jobmonth = rs.getString("save_dt");
					day = lm.addMonth(st_dt, while_day - day_minus);
					while ((!jobmonth.equals(day)) && day_minus > 0) {
						all = all + "/0";
						day_minus--;
						day = lm.addMonth(st_dt, while_day - day_minus);
					}
					day_minus--;
					all = all + "/" + rs.getString("per1").trim() + "";
				}
				count++;
			}

			while (day_minus > 0) {
				all = all + "/0";
				if (mode.equals("d")) {
					day = ld.addDay(st_dt, while_day - day_minus);
				} else {
					day = lm.addMonth(st_dt, while_day - day_minus);
				}
				day_minus--;
			}

			// 레코드가 존재할 경우 처음 '/'는 제거한다.
			if (count > 0)
				all = all.substring(1);

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getDlyPers]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return all;
		}
	}

	/**
	 * 연체현황 통계자료 리스트
	 */
	public String getDlyPersList(String mode, String brch_id, String bus_id2, String st_dt, String end_dt) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		LastDay ld = new LastDay();
		LastMonth lm = new LastMonth();
		String result = "";
		String jobday = "";
		String jobmonth = "";
		String day = "";
		String all = "";
		int day_minus = 0;
		int while_day = 0;
		int count = 0;
		String query = "";

		// 일별통계
		if (mode.equals("d")) {

			if (brch_id.equals("") && bus_id2.equals("")) { // 아마존카전체
				query = " select save_dt, per1" + " from stat_dly" + " where save_dt between '" + st_dt + "' and '"
						+ end_dt + "'" + " group by save_dt order by save_dt";
			} else if (!brch_id.equals("") && bus_id2.equals("")) { // 영업소전체
				query = " select a.save_dt, per1" + " from stat_dly a, users c" + " where a.bus_id2=c.user_id"
						+ " and a.save_dt between '" + st_dt + "' and '" + end_dt + "' and c.br_id='" + brch_id + "'"
						+ " group by a.save_dt order by a.save_dt";
			} else {
				query = " select a.save_dt, per1 " + " from stat_dly a, users c" + " where a.bus_id2=c.user_id"
						+ " and a.save_dt between '" + st_dt + "' and '" + end_dt + "'" + " and c.user_id='" + bus_id2
						+ "'" + " order by a.save_dt";
			}
			while_day = 31;

			// 월별통계
		} else {

			if (brch_id.equals("") && bus_id2.equals("")) { // 아마존카전체
				query = " select substr(save_dt,1,6) save_dt, AVG(per1) per1" + " from stat_dly"
						+ " where save_dt between '" + st_dt.substring(0, 6) + "01' and '"
						+ end_dt.substring(0, 6) + "31'" + " group by substr(save_dt,1,6) order by substr(save_dt,1,6)";
			} else if (!brch_id.equals("") && bus_id2.equals("")) { // 영업소전체
				query = " select substr(a.save_dt,1,6) save_dt, AVG(per1) per1" + " from stat_dly a, users c"
						+ " where a.bus_id2=c.user_id" + " and a.save_dt between '" + st_dt.substring(0, 6)
						+ "01' and '" + end_dt.substring(0, 6) + "31' and c.br_id='" + brch_id + "'"
						+ " group by substr(a.save_dt,1,6) order by substr(a.save_dt,1,6)";
			} else {
				query = " select a.save_dt, a.per1 " + " from "
						+ " ( select bus_id2, substr(save_dt,1,6) save_dt, avg(per1) per1 from stat_dly"
						+ "   group by bus_id2, substr(save_dt,1,6)) a, users c" + " where a.bus_id2=c.user_id"
						+ " and a.save_dt between '" + st_dt.substring(0, 6) + "01' and '"
						+ end_dt.substring(0, 6) + "31'" + " and c.user_id='" + bus_id2 + "'" + " order by a.save_dt";
			}

			while_day = 12;
		}

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			day_minus = while_day;

			while (rs.next()) {

				if (mode.equals("d")) {
					jobday = rs.getString("save_dt");
					day = ld.addDay(st_dt, while_day - day_minus);
					while ((!jobday.equals(day)) && day_minus > 0) {
						all = all + "/0";
						day_minus--;
						day = ld.addDay(st_dt, while_day - day_minus);
					}
					day_minus--;
					all = all + "/" + rs.getString("per1").trim() + "";
				} else {
					jobmonth = rs.getString("save_dt");
					day = lm.addMonth(st_dt, while_day - day_minus);
					while ((!jobmonth.equals(day)) && day_minus > 0) {
						all = all + "/0";
						day_minus--;
						day = lm.addMonth(st_dt, while_day - day_minus);
					}
					day_minus--;
					all = all + "/" + rs.getString("per1").trim() + "";
				}
				count++;
			}

			while (day_minus > 0) {
				all = all + "/0";
				if (mode.equals("d")) {
					day = ld.addDay(st_dt, while_day - day_minus);
				} else {
					day = lm.addMonth(st_dt, while_day - day_minus);
				}
				day_minus--;
			}

			// 레코드가 존재할 경우 처음 '/'는 제거한다.
			if (count > 0)
				all = all.substring(1);

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getDlyPersList]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return all;
		}
	}

	// 사원별관리현황-------------------------------------------------------------------------------

	/**
	 * 당일기준 조회(관리담당자 기준)
	 */
	public Vector getStatMng(String br_id, String save_dt, String dept_id) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select f.nm, e.user_nm, e.user_id, e.enter_dt," + " nvl(h.cnt,0) as c_cnt, h.cnt*3 as c_ga,"
				+ " nvl(b.cnt,0)+nvl(i.cnt,0) as g_cnt, (nvl(b.cnt,0)*3)+(nvl(i.cnt,0)*1.5) g_ga,"
				+ " nvl(c.cnt,0)+nvl(j.cnt,0) as p_cnt, (nvl(c.cnt,0)*1)+(nvl(j.cnt,0)*0.5) p_ga,"
				+ " nvl(d.cnt,0)+nvl(k.cnt,0) as b_cnt, (nvl(d.cnt,0)*1)+(nvl(k.cnt,0)*0.5) b_ga,"
				+ " (nvl(b.cnt,0)+nvl(c.cnt,0)+nvl(d.cnt,0)) as tot_cnt2,"
				+ " (nvl(b.cnt,0)*3)+(nvl(i.cnt,0)*1.5)+(nvl(c.cnt,0)*1)+(nvl(i.cnt,0)*0.5)+(nvl(d.cnt,0)*1)+(nvl(i.cnt,0)*0.5) as tot_ga"
				+ " from" +
				// --차량합계
				" (select a.mng_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') group by a.mng_id) a,"
				+
				// --일반식
				" (select a.mng_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' group by a.mng_id) b,"
				+
				// --맞춤식
				" (select a.mng_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' group by a.mng_id) c,"
				+
				// --기본식
				" (select a.mng_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' group by a.mng_id) d,"
				+ " users e, code f," +
				// --업체수
				" (select a.mng_id, count(*) cnt from (select a.mng_id, a.client_id, count(*) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') group by a.mng_id, a.client_id, a.r_site) a group by mng_id) h,"
				+
				// --일반식2
				" (select a.mng_id2 as mng_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' group by a.mng_id2) i,"
				+
				// --맞춤식
				" (select a.mng_id2 as mng_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' group by a.mng_id2) j,"
				+
				// --기본식
				" (select a.mng_id2 as mng_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' group by a.mng_id2) k"
				+ " where a.mng_id=b.mng_id(+) and a.mng_id=c.mng_id(+) and a.mng_id=d.mng_id(+) and a.mng_id=e.user_id(+) and a.mng_id=h.mng_id(+) and e.dept_id=f.code and f.c_st='0002' and f.code<>'0000'"
				+ " and a.mng_id=i.mng_id(+) and a.mng_id=j.mng_id(+) and a.mng_id=k.mng_id(+)" + " and e.dept_id='"
				+ dept_id + "'"
				+ " order by (nvl(b.cnt,0)*3)+(nvl(i.cnt,0)*1.5)+(nvl(c.cnt,0)*1)+(nvl(i.cnt,0)*0.5)+(nvl(d.cnt,0)*1)+(nvl(i.cnt,0)*0.5) desc";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while (rs.next()) {
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
			System.out.println("[AdminDatabase:getStatMng]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 당일기준 조회(단독,공동 기준)-고정 가중치
	 */
	public Vector getStatMng2(String br_id, String save_dt, String dept_id) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if (save_dt.equals("")) {

			query = " select f.nm, e.user_nm, e.user_id, e.enter_dt, "
					+ " nvl(a1.cnt,0) c_cnt_o, nvl(a2.cnt,0)+nvl(a3.cnt,0) c_cnt_t,  "
					+ " (nvl(a1.cnt,0)+nvl(a2.cnt,0)+nvl(a3.cnt,0)) c_cnt, "
					+ " (nvl(a1.cnt,0)+nvl(a2.cnt,0)+nvl(a3.cnt,0))*3 c_ga, "
					+ " nvl(b1.cnt,0) g_cnt_o, nvl(b2.cnt,0)+nvl(b3.cnt,0) g_cnt_t,  "
					+ " (nvl(b1.cnt,0)+nvl(b2.cnt,0)+nvl(b3.cnt,0)) g_cnt, "
					+ " (nvl(b1.cnt,0)*3)+(nvl(b2.cnt,0)+nvl(b3.cnt,0))*1.5 g_ga, "
					+ " nvl(c1.cnt,0) p_cnt_o, nvl(c2.cnt,0)+nvl(c3.cnt,0) p_cnt_t,  "
					+ " (nvl(c1.cnt,0)+nvl(c2.cnt,0)+nvl(c3.cnt,0)) p_cnt, "
					+ " (nvl(c1.cnt,0)*1)+(nvl(c2.cnt,0)+nvl(c3.cnt,0))*0.5 p_ga, "
					+ " nvl(d1.cnt,0) b_cnt_o, nvl(d2.cnt,0)+nvl(d3.cnt,0) b_cnt_t,  "
					+ " (nvl(d1.cnt,0)+nvl(d2.cnt,0)+nvl(d3.cnt,0)) b_cnt, "
					+ " (nvl(d1.cnt,0)*1)+(nvl(d2.cnt,0)+nvl(d3.cnt,0))*0.5 b_ga, "
					+ " ((nvl(b1.cnt,0)+nvl(b2.cnt,0)+nvl(b3.cnt,0))+(nvl(c1.cnt,0)+nvl(c2.cnt,0)+nvl(c3.cnt,0))+(nvl(d1.cnt,0)+nvl(d2.cnt,0)+nvl(d3.cnt,0))) tot_cnt, "
					+ " (((nvl(b1.cnt,0)*3)+(nvl(b2.cnt,0)+nvl(b3.cnt,0))*1.5)+((nvl(c1.cnt,0)*1)+(nvl(c2.cnt,0)+nvl(c3.cnt,0))*0.5)+((nvl(d1.cnt,0)*1)+(nvl(d2.cnt,0)+nvl(d3.cnt,0))*0.5)) tot_ga "
					+ " from  " +
					// 담당직원
					" (select mng_id as user_id from cont where nvl(use_yn,'Y')='Y' and client_id not in ('000231', '000228') group by mng_id) u, "
					+
					// 업체수=단독
					" (select nvl(a.bus_id2,'999999') as user_id, sum(a.cnt) cnt from (select a.bus_id2, a.client_id, count(*) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2=nvl(a.mng_id,a.bus_id2) group by a.bus_id2, a.client_id, a.r_site) a group by bus_id2) a1, "
					+
					// 업체수=공동(영업)
					" (select nvl(a.bus_id2,'999999') as user_id, sum(a.cnt) cnt from (select a.bus_id2, a.client_id, count(*) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2<>a.mng_id group by a.bus_id2, a.client_id, a.r_site) a group by bus_id2) a2, "
					+
					// 업체수=공동(관리)
					" (select nvl(a.mng_id,'999999') as user_id, sum(a.cnt) cnt from (select a.mng_id, a.client_id, count(*) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2<>a.mng_id group by a.mng_id, a.client_id, a.r_site) a group by mng_id) a3, "
					+
					// 일반식=단독
					" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2=nvl(a.mng_id,a.bus_id2) group by a.bus_id2) b1, "
					+
					// 일반식=공동(영업)
					" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2<>a.mng_id group by a.bus_id2) b2, "
					+
					// 일반식=공동(관리)
					" (select nvl(a.mng_id,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2<>a.mng_id group by a.mng_id) b3, "
					+
					// 맞춤식=단독
					" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2=nvl(a.mng_id,a.bus_id2) group by a.bus_id2) c1, "
					+
					// 맞춤식=공동(영업)
					" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2<>a.mng_id group by a.bus_id2) c2, "
					+
					// 맞춤식=공동(관리)
					" (select nvl(a.mng_id,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2<>a.mng_id group by a.mng_id) c3, "
					+
					// 기본식=단독
					" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2=nvl(a.mng_id,a.bus_id2) group by a.bus_id2) d1, "
					+
					// 기본식=공동(영업)
					" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2<>a.mng_id group by a.bus_id2) d2, "
					+
					// 기본식=공동(관리)
					" (select nvl(a.mng_id,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2<>a.mng_id group by a.mng_id) d3, "
					+ " users e, code f"
					+ " where u.user_id=a1.user_id(+) and u.user_id=a2.user_id(+) and u.user_id=a3.user_id(+)  "
					+ " and u.user_id=b1.user_id(+) and u.user_id=b2.user_id(+) and u.user_id=b3.user_id(+) "
					+ " and u.user_id=c1.user_id(+) and u.user_id=c2.user_id(+) and u.user_id=c3.user_id(+) "
					+ " and u.user_id=d1.user_id(+) and u.user_id=d2.user_id(+) and u.user_id=d3.user_id(+) "
					+ " and u.user_id=e.user_id and e.dept_id=f.code(+) and f.c_st='0002' and f.code<>'0000' "
					+ " and e.dept_id='" + dept_id + "'"
					+ " order by (((nvl(b1.cnt,0)*3)+(nvl(b2.cnt,0)+nvl(b3.cnt,0))*1.5)+((nvl(c1.cnt,0)*1)+(nvl(c2.cnt,0)+nvl(c3.cnt,0))*0.5)+((nvl(d1.cnt,0)*1)+(nvl(d2.cnt,0)+nvl(d3.cnt,0))*0.5)) desc";
		} else {
			query = " select c.nm, b.user_nm, b.user_id, b.enter_dt, 0 c_cnt_o, 0 c_cnt_t, a.client_cnt, a.client_ga,"
					+ " a.gen_cnt_o, a.gen_cnt_t, (a.gen_cnt_o+a.gen_cnt_t) as gen_cnt, a.gen_ga,"
					+ " a.put_cnt_o, a.put_cnt_t, (a.put_cnt_o+a.put_cnt_t) as put_cnt, a.put_ga,"
					+ " a.bas_cnt_o, a.bas_cnt_t, (a.bas_cnt_o+a.bas_cnt_t) as bas_cnt, a.bas_ga,"
					+ " (a.gen_cnt_o+a.gen_cnt_t+a.put_cnt_o+a.put_cnt_t+a.bas_cnt_o+a.bas_cnt_t) tot_cnt,"
					+ " (a.gen_ga+a.put_ga+a.bas_ga) tot_ga" + " from stat_mng a, users b, code c"
					+ " where a.user_id=b.user_id and b.dept_id=c.code and c.c_st='0002' and c.code<>'0000'"
					+ " and b.dept_id='" + dept_id + "' and a.save_dt=replace('" + save_dt + "', '-', '')"
					+ " order by a.seq";
		}
		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while (rs.next()) {
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
			System.out.println("[AdminDatabase:getStatMng2]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 당일기준 조회(단독,공동 기준)-가변 가중치
	 */
	public Vector getStatMng3(String br_id, String save_dt, String dept_id, int c_o, int c_t, int g_o, int g_t1,
			int g_t2, int b_o, double b_t, int p_o, double p_t) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if (save_dt.equals("")) {

			query = " select f.nm, e.user_nm, e.user_id, e.enter_dt, " + " nvl(a1.cnt,0) c_cnt_o,"
					+ " ( nvl(a2.cnt,0) + nvl(a3.cnt,0) ) c_cnt_t,"
					+ " ( nvl(a1.cnt,0) + nvl(a2.cnt,0) + nvl(a3.cnt,0) ) c_cnt, " + " ( (nvl(a1.cnt,0)*" + c_o
					+ ") + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))*" + c_t + ") ) c_ga, " + " nvl(b1.cnt,0) g_cnt_o,"
					+ " ( nvl(b2.cnt,0) + nvl(b3.cnt,0) ) g_cnt_t,"
					+ " ( nvl(b1.cnt,0) + nvl(b2.cnt,0) + nvl(b3.cnt,0) ) g_cnt," + " ( (nvl(b1.cnt,0)*" + g_o
					+ ") + (nvl(b2.cnt,0)*decode(e.dept_id,'0001'," + g_t1 + "," + g_t2
					+ ")) + (nvl(b3.cnt,0)*decode(e.dept_id,'0001'," + g_t1 + "," + g_t2 + ")) ) g_ga, "
					+ " nvl(c1.cnt,0) p_cnt_o," + " ( nvl(c2.cnt,0) + nvl(c3.cnt,0) ) p_cnt_t,"
					+ " ( nvl(c1.cnt,0) + nvl(c2.cnt,0) + nvl(c3.cnt,0)) p_cnt, " + " ( (nvl(c1.cnt,0)*" + p_o
					+ ") + ((nvl(c2.cnt,0)+nvl(c3.cnt,0))*" + p_t + ") ) p_ga, " + " nvl(d1.cnt,0) b_cnt_o,"
					+ " ( nvl(d2.cnt,0) + nvl(d3.cnt,0) ) b_cnt_t,"
					+ " ( nvl(d1.cnt,0) + nvl(d2.cnt,0) + nvl(d3.cnt,0) ) b_cnt," + " ( (nvl(d1.cnt,0)*" + b_o
					+ ") + ((nvl(d2.cnt,0)+nvl(d3.cnt,0))*" + b_t + ") ) b_ga" + " from  " +
					// 담당직원
					" (select mng_id as user_id from cont where nvl(use_yn,'Y')='Y' and client_id not in ('000231', '000228') group by mng_id) u, "
					+
					// 업체수=단독
					" (select nvl(a.bus_id2,'999999') as user_id, sum(a.cnt) cnt from (select a.bus_id2, a.client_id, count(*) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2=nvl(a.mng_id,a.bus_id2) group by a.bus_id2, a.client_id, a.r_site) a group by bus_id2) a1, "
					+
					// 업체수=공동(영업)
					" (select nvl(a.bus_id2,'999999') as user_id, sum(a.cnt) cnt from (select a.bus_id2, a.client_id, count(*) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2<>a.mng_id group by a.bus_id2, a.client_id, a.r_site) a group by bus_id2) a2, "
					+
					// 업체수=공동(관리)
					" (select nvl(a.mng_id,'999999') as user_id, sum(a.cnt) cnt from (select a.mng_id, a.client_id, count(*) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2<>a.mng_id group by a.mng_id, a.client_id, a.r_site) a group by mng_id) a3, "
					+
					// 일반식=단독
					" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_mng_id is not null group by a.bus_id2) b1, "
					+
					// 일반식=공동(영업)
					" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.bus_id2) b2, "
					+
					// 일반식=공동(관리)
					" (select nvl(a.mng_id,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.mng_id) b3, "
					+
					// 맞춤식=단독
					" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_mng_id is not null group by a.bus_id2) c1, "
					+
					// 맞춤식=공동(영업)
					" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.bus_id2) c2, "
					+
					// 맞춤식=공동(관리)
					" (select nvl(a.mng_id,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.mng_id) c3, "
					+
					// 기본식=단독
					" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_mng_id is not null group by a.bus_id2) d1, "
					+
					// 기본식=공동(영업)
					" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.bus_id2) d2, "
					+
					// 기본식=공동(관리)
					" (select nvl(a.mng_id,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.mng_id) d3, "
					+ " users e, code f"
					+ " where u.user_id=a1.user_id(+) and u.user_id=a2.user_id(+) and u.user_id=a3.user_id(+)  "
					+ " and u.user_id=b1.user_id(+) and u.user_id=b2.user_id(+) and u.user_id=b3.user_id(+) "
					+ " and u.user_id=c1.user_id(+) and u.user_id=c2.user_id(+) and u.user_id=c3.user_id(+) "
					+ " and u.user_id=d1.user_id(+) and u.user_id=d2.user_id(+) and u.user_id=d3.user_id(+) "
					+ " and u.user_id=e.user_id and e.dept_id=f.code(+) and f.c_st='0002' and f.code<>'0000' "
					+ " and e.dept_id='" + dept_id + "'" + " order by ((nvl(a1.cnt,0)*" + c_o
					+ ") + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))*" + c_t + ") + (nvl(b1.cnt,0)*" + g_o
					+ ") + (nvl(b2.cnt,0)*decode(e.dept_id,'0001'," + g_t1 + "," + g_t2
					+ ")) + (nvl(b3.cnt,0)*decode(e.dept_id,'0001'," + g_t1 + "," + g_t2 + ")) + (nvl(c1.cnt,0)*" + p_o
					+ ") + ((nvl(c2.cnt,0)+nvl(c3.cnt,0))*" + p_t + ") + (nvl(d1.cnt,0)*" + b_o
					+ ") + ((nvl(d2.cnt,0)+nvl(d3.cnt,0))*" + b_t + ")) desc";
		} else {
			query = " select c.nm, b.user_nm, b.user_id, b.enter_dt,"
					+ " a.client_cnt_o, a.client_cnt_t, (a.client_cnt_o+a.client_cnt_t) as client_cnt, a.client_ga,"
					+ " a.gen_cnt_o, a.gen_cnt_t, (a.gen_cnt_o+a.gen_cnt_t) as gen_cnt, a.gen_ga,"
					+ " a.put_cnt_o, a.put_cnt_t, (a.put_cnt_o+a.put_cnt_t) as put_cnt, a.put_ga,"
					+ " a.bas_cnt_o, a.bas_cnt_t, (a.bas_cnt_o+a.bas_cnt_t) as bas_cnt, a.bas_ga"
					+ " from stat_mng a, users b, code c"
					+ " where a.user_id=b.user_id and b.dept_id=c.code and c.c_st='0002' and c.code<>'0000'"
					+ " and b.dept_id='" + dept_id + "' and a.save_dt=replace('" + save_dt + "', '-', '')"
					+ " order by a.seq";
		}
		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while (rs.next()) {
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

				vt.add(bean);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatMng3]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 당일기준 조회(단독,공동 기준)-가변 가중치
	 */
	public Vector getStatMng3(String br_id, String save_dt, String dept_id, String c_o, String c_t, String g_o,
			String g_t, String b_o, String b_t, String p_o, String p_t) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		if (save_dt.equals("")) {

			query = " select f.nm, e.user_nm, e.user_id, e.enter_dt, " + " nvl(a1.cnt,0) c_cnt_o,"
					+ " ( nvl(a2.cnt,0) + nvl(a3.cnt,0) ) c_cnt_t,"
					+ " ( nvl(a1.cnt,0) + nvl(a2.cnt,0) + nvl(a3.cnt,0) ) c_cnt, " + " ( (nvl(a1.cnt,0)*" + c_o
					+ ") + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))*" + c_t + ") ) c_ga, " + " nvl(b1.cnt,0) g_cnt_o,"
					+ " ( nvl(b2.cnt,0) + nvl(b3.cnt,0) ) g_cnt_t,"
					+ " ( nvl(b1.cnt,0) + nvl(b2.cnt,0) + nvl(b3.cnt,0) ) g_cnt," + " ( (nvl(b1.cnt,0)*" + g_o
					+ ") + ((nvl(b2.cnt,0)+nvl(b3.cnt,0))*" + g_t + ") ) g_ga, " + " nvl(c1.cnt,0) p_cnt_o,"
					+ " ( nvl(c2.cnt,0) + nvl(c3.cnt,0) ) p_cnt_t,"
					+ " ( nvl(c1.cnt,0) + nvl(c2.cnt,0) + nvl(c3.cnt,0)) p_cnt, " + " ( (nvl(c1.cnt,0)*" + p_o
					+ ") + ((nvl(c2.cnt,0)+nvl(c3.cnt,0))*" + p_t + ") ) p_ga, " + " nvl(d1.cnt,0) b_cnt_o,"
					+ " ( nvl(d2.cnt,0) + nvl(d3.cnt,0) ) b_cnt_t,"
					+ " ( nvl(d1.cnt,0) + nvl(d2.cnt,0) + nvl(d3.cnt,0) ) b_cnt," + " ( (nvl(d1.cnt,0)*" + b_o
					+ ") + ((nvl(d2.cnt,0)+nvl(d3.cnt,0))*" + b_t + ") ) b_ga" + " from  " +
					// 담당직원
					" (select mng_id as user_id from cont where nvl(use_yn,'Y')='Y' and client_id not in ('000231', '000228') group by mng_id) u, "
					+
					// 업체수=단독
					" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt from (select a.bus_id2, a.client_id, a.r_site, count(*) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2=nvl(a.mng_id,a.bus_id2) group by a.bus_id2, a.client_id, a.r_site) a group by bus_id2) a1, "
					+
					// 업체수=공동(영업)
					" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt from (select a.bus_id2, a.client_id, a.r_site, count(*) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2<>nvl(a.mng_id,a.bus_id2) group by a.bus_id2, a.client_id, a.r_site) a group by bus_id2) a2, "
					+
					// 업체수=공동(관리)
					" (select nvl(a.mng_id,'999999') as user_id, count(*) cnt from (select a.mng_id, a.client_id, a.r_site, count(*) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.bus_id2<>nvl(a.mng_id,a.bus_id2) group by a.mng_id, a.client_id, a.r_site) a group by mng_id) a3, "
					+
					// 일반식=단독
					" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_mng_id is not null group by a.bus_id2) b1, "
					+
					// 일반식=공동(영업)
					" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.bus_id2) b2, "
					+
					// 일반식=공동(관리)
					" (select nvl(a.mng_id,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='1' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.mng_id) b3, "
					+
					// 맞춤식=단독
					" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_mng_id is not null group by a.bus_id2) c1, "
					+
					// 맞춤식=공동(영업)
					" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.bus_id2) c2, "
					+
					// 맞춤식=공동(관리)
					" (select nvl(a.mng_id,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='2' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.mng_id) c3, "
					+
					// 기본식=단독
					" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.car_mng_id is not null group by a.bus_id2) d1, "
					+
					// 기본식=공동(영업)
					" (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.bus_id2) d2, "
					+
					// 기본식=공동(관리)
					" (select nvl(a.mng_id,'999999') as user_id, count(*) cnt from cont a, fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and b.rent_st='1' and a.client_id not in ('000231', '000228') and b.rent_way='3' and a.bus_id2<>a.mng_id and a.car_mng_id is not null group by a.mng_id) d3, "
					+ " users e, code f"
					+ " where u.user_id=a1.user_id(+) and u.user_id=a2.user_id(+) and u.user_id=a3.user_id(+)  "
					+ " and u.user_id=b1.user_id(+) and u.user_id=b2.user_id(+) and u.user_id=b3.user_id(+) "
					+ " and u.user_id=c1.user_id(+) and u.user_id=c2.user_id(+) and u.user_id=c3.user_id(+) "
					+ " and u.user_id=d1.user_id(+) and u.user_id=d2.user_id(+) and u.user_id=d3.user_id(+) "
					+ " and u.user_id=e.user_id and e.dept_id=f.code(+) and f.c_st='0002' and f.code<>'0000' "
					+ " and e.dept_id='" + dept_id + "'" + " order by ((nvl(a1.cnt,0)*" + c_o
					+ ") + ((nvl(a2.cnt,0)+nvl(a3.cnt,0))*" + c_t + ") + (nvl(b1.cnt,0)*" + g_o
					+ ") + ((nvl(b2.cnt,0)+nvl(b3.cnt,0))*" + g_t + ") + (nvl(c1.cnt,0)*" + p_o
					+ ") + ((nvl(c2.cnt,0)+nvl(c3.cnt,0))*" + p_t + ") + (nvl(d1.cnt,0)*" + b_o
					+ ") + ((nvl(d2.cnt,0)+nvl(d3.cnt,0))*" + b_t + ")) desc";
		} else {
			query = " select c.nm, b.user_nm, b.user_id, b.enter_dt,"
					+ " a.client_cnt_o, a.client_cnt_t, (a.client_cnt_o+a.client_cnt_t) as client_cnt, a.client_ga,"
					+ " a.gen_cnt_o, a.gen_cnt_t, (a.gen_cnt_o+a.gen_cnt_t) as gen_cnt, a.gen_ga,"
					+ " a.put_cnt_o, a.put_cnt_t, (a.put_cnt_o+a.put_cnt_t) as put_cnt, a.put_ga,"
					+ " a.bas_cnt_o, a.bas_cnt_t, (a.bas_cnt_o+a.bas_cnt_t) as bas_cnt, a.bas_ga"
					+ " from stat_mng a, users b, code c"
					+ " where a.user_id=b.user_id and b.dept_id=c.code and c.c_st='0002' and c.code<>'0000'"
					+ " and b.dept_id='" + dept_id + "' and a.save_dt=replace('" + save_dt + "', '-', '')"
					+ " order by a.seq";
		}
		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while (rs.next()) {
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
				bean.setDept_id(dept_id);

				vt.add(bean);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatMng3]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 마감 조회
	 */
	public Vector getStatMng(String save_dt) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select c.nm, b.user_nm, a.user_id, b.enter_dt,"
				+ " a.client_cnt, a.client_ga, a.gen_cnt, a.gen_ga, a.put_cnt, a.put_ga, a.bas_cnt, a.bas_ga"
				+ " from stat_mng a, users b, code c"
				+ " where a.user_id=b.user_id and b.dept_id=c.code and c.c_st='0002' c.code<>'0000'"
				+ " and a.save_dt=replace(?, '-', '') order by a.seq";

		try {

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, save_dt);
			rs = pstmt.executeQuery();
			while (rs.next()) {
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
			System.out.println("[AdminDatabase:getStatMng(save_dt)]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 자동차보유현황 등록
	 */
	public boolean insertStatMng(StatMngBean bean) {
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = " insert into stat_mng values (?, ?, ?, ?, ?, ?, ?, ?,"
				+ " ?, ?, ?, ?, ?, ?, ?, ?, to_char(sysdate,'YYYYMMDD'), 'Y'," + " 0, 0, 0, 0, 0, 0, 0, 0)";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, bean.getSave_dt());
			pstmt.setString(2, bean.getSeq());
			pstmt.setString(3, bean.getUser_id());
			pstmt.setInt(4, bean.getClient_cnt_o());
			pstmt.setInt(5, bean.getClient_cnt_t());
			pstmt.setFloat(6, bean.getClient_ga());
			pstmt.setInt(7, bean.getGen_cnt_o());
			pstmt.setInt(8, bean.getGen_cnt_t());
			pstmt.setFloat(9, bean.getGen_ga());
			pstmt.setInt(10, bean.getPut_cnt_o());
			pstmt.setInt(11, bean.getPut_cnt_t());
			pstmt.setFloat(12, bean.getPut_ga());
			pstmt.setInt(13, bean.getBas_cnt_o());
			pstmt.setInt(14, bean.getBas_cnt_t());
			pstmt.setFloat(15, bean.getBas_ga());
			pstmt.setString(16, bean.getReg_id());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
			System.out.println("[AdminDatabase:insertStatMng]" + e);
			e.printStackTrace();
			flag = false;
			conn.rollback();
		} finally {
			try {
				conn.setAutoCommit(true);
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return flag;
		}
	}

	/**
	 * 개인별 세부리스트에서 담당자 리스트
	 */
	public Vector getStatMngUser() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.user_id, b.user_nm "
				+ " from (select mng_id as user_id from cont where nvl(use_yn,'Y')='Y' and client_id not in ('000231', '000228') group by mng_id) a, users b"
				+ " where a.user_id=b.user_id order by b.dept_id desc, b.enter_dt, b.user_id";
		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatMngUser]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 개인별 관리업체 리스트
	 */
	public Vector getStatMngClientList(String s_user, String s_mng_st) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String o_query = "";
		String t_query1 = "";
		String t_query2 = "";

		// 단독
		o_query = " select DISTINCT '단독' mng_st, a.bus_id2, a.mng_id, a.client_id, a.r_site from cont a"
				+ " where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')"
				+ " and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.bus_id2='" + s_user + "'";
		// 공동
		t_query1 = " select DISTINCT '공동' mng_st, a.bus_id2, a.mng_id, a.client_id, a.r_site from cont a"
				+ " where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')"
				+ " and a.bus_id2<>nvl(a.mng_id,a.bus_id2) and a.bus_id2='" + s_user + "'";
		// 공동
		t_query2 = " select DISTINCT '공동' mng_st, a.bus_id2, a.mng_id, a.client_id, a.r_site from cont a"
				+ " where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')"
				+ " and a.bus_id2<>nvl(a.mng_id,a.bus_id2) and a.mng_id='" + s_user + "'";

		if (s_mng_st.equals("1"))
			sub_query = o_query;
		else if (s_mng_st.equals("2"))
			sub_query = t_query1 + " union all " + t_query2;
		else
			sub_query = o_query + " union all " + t_query1 + " union all " + t_query2;

		query = " select DISTINCT a.mng_st, a.client_id, a.r_site, nvl(b.firm_nm,b.client_nm) firm_nm, b.client_nm, c.r_site as r_site_nm, b.o_tel, b.m_tel, nvl(d.y_cnt,0) y_cnt, nvl(e.n_cnt,0) n_cnt"
				+ " from (" + sub_query + ") a," + " client b, client_site c,"
				+ " (select client_id, nvl(r_site,' ') r_site, count(*) as y_cnt from cont where nvl(use_yn,'Y')='Y' group by client_id, r_site) d,"
				+ " (select client_id, nvl(r_site,' ') r_site, count(*) as n_cnt from cont where use_yn='N' group by client_id, r_site) e"
				+ " where a.client_id=b.client_id and a.client_id=c.client_id(+) and a.r_site=c.seq(+)"
				+ " and a.client_id=d.client_id(+) and nvl(a.r_site,' ')=d.r_site(+) and a.client_id=e.client_id(+) and nvl(a.r_site,' ')=e.r_site(+)"
				+ " order by nvl(b.firm_nm,b.client_nm)";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatMngClientList]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 개인별 관리업체 리스트 : 담당자들
	 */
	public String getStatMngClientUsers(String client_id, String r_site, String gubun) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String users = "";
		String query = "";
		String sub_query = "";

		if (r_site.equals("")) {
			sub_query = "select " + gubun + " from cont where nvl(use_yn,'Y')='Y' and client_id='" + client_id
					+ "' group by " + gubun;
		} else {
			sub_query = "select " + gubun + " from cont where nvl(use_yn,'Y')='Y' and client_id='" + client_id
					+ "' and r_site='" + r_site + "' group by " + gubun;
		}

		query = " select b.user_nm" + " from (" + sub_query + ") a, users b" + " where a." + gubun + "=b.user_id";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (!users.equals(""))
					users = users + ",";
				users = users + rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatMngClientUsers]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return users;
		}
	}

	// 개인별 관리업체 리스트 : 업체별 차량 리스트
	public Vector getClientCarList(String client_id) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector rtn = new Vector();
		String query = "";

		query = " select /*+  merge(a) */ a.*, c.car_no, c.car_nm, cn.car_name , c.init_reg_dt,  c.car_num , g.car_id  , cc.cls_st,  a.rent_way,  '' cpt_cd,  \n"
				+ " decode(c.init_reg_dt, null, 'id', 'ud') as  reg_gubun,  cp.rpt_no,   decode(cp.reg_ext_dt, '', '', substr(cp.reg_ext_dt, 1, 4) || '-' || substr(cp.reg_ext_dt, 5, 2) || '-'||substr(cp.reg_ext_dt, 7, 2)) REG_EXT_DT,  '' scan_file  \n"
				+ "  from cont_n_view a ,  car_reg c,  car_etc g, car_nm cn , cls_cont cc , car_pur cp \n"
				+ "	where a.client_id='" + client_id + "'"
				+ "	and a.car_mng_id = c.car_mng_id  and a.rent_mng_id = g.rent_mng_id(+)  and a.rent_l_cd = g.rent_l_cd(+)  \n"
				+ "	and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) \n"
				+ "	and a.rent_mng_id = cc.rent_mng_id(+)  and a.rent_l_cd = cc.rent_l_cd(+)  \n"
				+ "	and a.rent_mng_id = cp.rent_mng_id(+)  and a.rent_l_cd = cp.rent_l_cd(+)  \n"
				+ " order by a.use_yn desc, a.rent_dt, a.rent_mng_id";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				RentListBean bean = new RentListBean();

				bean.setRent_mng_id(rs.getString("RENT_MNG_ID")); // 계약관리ID
				bean.setRent_l_cd(rs.getString("RENT_L_CD")); // 계약코드
				bean.setRent_dt(rs.getString("RENT_DT")); // 계약일자
				bean.setDlv_dt(rs.getString("DLV_DT")); // 출고일자
				bean.setClient_id(rs.getString("CLIENT_ID")); // 고객ID
				bean.setClient_nm(rs.getString("CLIENT_NM")); // 고객 대표자명
				bean.setFirm_nm(rs.getString("FIRM_NM")); // 상호
				bean.setBr_id(rs.getString("BRCH_ID")); // 상호
				bean.setCar_mng_id(rs.getString("CAR_MNG_ID")); // 자동차관리ID
				bean.setInit_reg_dt(rs.getString("INIT_REG_DT")); // 최초등록일
				bean.setReg_gubun(rs.getString("REG_GUBUN")); // 최초등록일
				bean.setCar_no(rs.getString("CAR_NO")); // 차량번호
				bean.setCar_num(rs.getString("CAR_NUM")); // 차대번호
				bean.setRent_way(rs.getString("RENT_WAY")); // 대여방식명
				bean.setCon_mon(rs.getString("CON_MON")); // 대여개월
				bean.setCar_id(rs.getString("CAR_ID")); // 차명ID
				bean.setRent_start_dt(rs.getString("RENT_START_DT")); // 대여개시일
				bean.setRent_end_dt(rs.getString("RENT_END_DT")); // 대여종료일
				bean.setReg_ext_dt(rs.getString("REG_EXT_DT")); // 등록예정일?
				bean.setRpt_no(rs.getString("RPT_NO")); // 계출번호
				bean.setCpt_cd(rs.getString("CPT_CD")); // 은행코드
				bean.setBus_id2(rs.getString("BUS_ID2"));
				bean.setMng_id(rs.getString("MNG_ID"));
				bean.setUse_yn(rs.getString("USE_YN"));
				bean.setRent_st(rs.getString("RENT_ST"));
				bean.setCls_st(rs.getString("CLS_ST"));
				bean.setCar_st(rs.getString("CAR_ST"));
				bean.setScan_file(rs.getString("SCAN_FILE"));
				bean.setR_site(rs.getString("R_SITE"));
				bean.setCar_nm(rs.getString("CAR_NM"));
				bean.setCar_name(rs.getString("CAR_NAME"));

				rtn.add(bean);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getClientCarList(]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return rtn;
		}
	}

	/**
	 * 개인별 관리차량 리스트
	 */
	public Vector getStatMngCarList(String s_user, String s_mng_way, String s_mng_st) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		String o_query = "";
		String t_query1 = "";
		String t_query2 = "";
		String b1_query = "";
		String b2_query = "";
		String m1_query = "";
		String where = "";

		if (!s_mng_way.equals("") && !s_mng_way.equals("9"))
			where = " and a.rent_way_cd ='" + s_mng_way + "'";
		if (s_mng_way.equals("9"))
			where = " and a.rent_way_cd in ('2','3')";

		// 단독
		o_query = " select /*+  merge(a) */ DISTINCT '단독' mng_st, a.rent_mng_id, a.rent_l_cd, a.bus_id, a.bus_id2, a.mng_id, a.car_mng_id "
				+ " from   cont_n_view a"
				+ " where  nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.car_mng_id is not null"
				+ "        and a.bus_id2=nvl(a.mng_id,a.bus_id2) and a.bus_id2='" + s_user + "'" + where;
		// 공동
		t_query1 = " select /*+  merge(a) */ DISTINCT '공동' mng_st, a.rent_mng_id, a.rent_l_cd, a.bus_id, a.bus_id2, a.mng_id, a.car_mng_id "
				+ " from   cont_n_view a"
				+ " where  nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.car_mng_id is not null"
				+ "        and a.bus_id2<>nvl(a.mng_id,a.bus_id2) and a.bus_id2='" + s_user + "'" + where;
		// 공동
		t_query2 = " select /*+  merge(a) */ DISTINCT '공동' mng_st, a.rent_mng_id, a.rent_l_cd, a.bus_id, a.bus_id2, a.mng_id, a.car_mng_id "
				+ " from   cont_n_view a"
				+ " where  nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.car_mng_id is not null"
				+ "        and a.bus_id2<>nvl(a.mng_id,a.bus_id2) and a.mng_id='" + s_user + "'" + where;

		// 최초영업
		b1_query = " select /*+  merge(a) */ DISTINCT '최초영업' mng_st, a.rent_mng_id, a.rent_l_cd, a.bus_id, a.bus_id2, a.mng_id, a.car_mng_id "
				+ " from   cont_n_view a"
				+ " where  nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.car_mng_id is not null"
				+ "        and a.bus_id='" + s_user + "'" + where;

		// 영업관리
		b2_query = " select /*+  merge(a) */ DISTINCT '영업관리' mng_st, a.rent_mng_id, a.rent_l_cd, a.bus_id, a.bus_id2, a.mng_id, a.car_mng_id "
				+ " from   cont_n_view a"
				+ " where  nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.car_mng_id is not null"
				+ "        and a.bus_id2='" + s_user + "'" + where;

		// 정비관리
		m1_query = " select /*+  merge(a) */ DISTINCT '정비관리' mng_st, a.rent_mng_id, a.rent_l_cd, a.bus_id, a.bus_id2, a.mng_id, a.car_mng_id "
				+ " from   cont_n_view a"
				+ " where  nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.car_mng_id is not null"
				+ "        and a.mng_id='" + s_user + "'" + where;

		if (s_mng_st.equals("1"))
			sub_query = o_query;
		else if (s_mng_st.equals("2"))
			sub_query = t_query1 + " union all " + t_query2;
		else if (s_mng_st.equals("0"))
			sub_query = o_query + " union all " + t_query1 + " union all " + t_query2;
		else if (s_mng_st.equals("3"))
			sub_query = b1_query;
		else if (s_mng_st.equals("4"))
			sub_query = b2_query;
		else if (s_mng_st.equals("5"))
			sub_query = m1_query;

		query = " select /*+  merge(b) */ a.mng_st, b.*" + " from (" + sub_query + ") a, cont_n_view b"
				+ " where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"
				+ " order by nvl(b.firm_nm,b.client_nm)";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatMngCarList]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	// 영업담당배정-------------------------------------------------------------------------------------------------------------

	/**
	 * 영업담당배정 - 영업담당 배정 상단 리스트
	 */
	public Vector getDlyBusStatMD(String br_id, String sort, String asc) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_qu = "";

		query = " select z.user_nm, a.user_id, z.enter_dt, a.t_cnt, b.t_amt, c.cnt1, d.amt1, e.cnt2, f.amt2, g.cnt3, h.amt3, i.cnt4, j.amt4, trunc((h.amt3/b.t_amt)*100,2) per\n"
				+ " from \n" +
				// --총 관리대수
				"        (select /*+  merge(a) */ decode(a.bus_id2,'000037',a.mng_id, a.bus_id2) as user_id, count(*) t_cnt from cont_n_view a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.rent_way_cd  is not null group by decode(a.bus_id2,'000037',a.mng_id, a.bus_id2)) a,\n"
				+
				// --총 대여료
				"        (select /*+  merge(a) */ decode(a.bus_id2,'000037',a.mng_id, a.bus_id2) as user_id, sum(b.fee_s_amt+b.fee_v_amt) t_amt from cont_n_view a, scd_fee b, cls_cont c  where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and b.rc_yn='0' and nvl(b.bill_yn,'Y')<>'N' and b.tm_st2<>'4' and a.rent_mng_id = c.rent_mng_id(+) and   a.rent_l_cd = c.rent_l_cd(+) and  nvl(c.cls_st,'0')<>'2' group by decode(a.bus_id2,'000037',a.mng_id, a.bus_id2)) b,\n"
				+
				// --일반식 관리대수
				"        (select /*+  merge(a) */ decode(a.bus_id2,'000037',a.mng_id, a.bus_id2) as user_id, count(*) cnt1 from cont_n_view a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.rent_way_cd='1' group by decode(a.bus_id2,'000037',a.mng_id, a.bus_id2)) c,\n"
				+
				// --일반식 대여료
				"        (select /*+  merge(a) */ decode(a.bus_id2,'000037',a.mng_id, a.bus_id2) as user_id, sum(b.fee_s_amt+b.fee_v_amt) amt1 from cont_n_view a, scd_fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')  and a.rent_way_cd='1' and b.rc_yn='0' and b.tm_st2<>'4' group by decode(a.bus_id2,'000037',a.mng_id, a.bus_id2)) d,\n"
				+
				// --기본식/맞춤식 관리대수
				"        (select /*+  merge(a) */ nvl(a.bus_id2,'999999') as user_id, count(*) cnt2 from cont_n_view a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.rent_way_cd in ('2','3') group by a.bus_id2) e,\n"
				+
				// --기본식/맞춤식 대여료
				"        (select /*+  merge(a) */ nvl(a.bus_id2,'999999') as user_id, sum(b.fee_s_amt+b.fee_v_amt) amt2 from cont_n_view a, scd_fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')  and a.rent_way_cd in ('2','3') and b.rc_yn='0' and b.tm_st2<>'4' group by a.bus_id2) f,\n"
				+
				// --업체관리수
				"        (select nvl(a.bus_id2,'999999') as user_id, count(*) cnt3 from (select decode(a.bus_id2,'000037',a.mng_id, a.bus_id2) bus_id2, a.client_id, count(*) cnt from cont a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') group by decode(a.bus_id2,'000037',a.mng_id, a.bus_id2), a.client_id, a.r_site) a group by bus_id2) g,\n"
				+
				// --연체대여료
				"        (select /*+  merge(a) */ decode(a.bus_id2,'000037',a.mng_id, a.bus_id2) as user_id, sum(b.fee_s_amt+b.fee_v_amt) amt3 from cont_n_view a, scd_fee b, cls_cont c  where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and b.rc_yn='0' and b.r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and nvl(b.bill_yn,'Y')<>'N' and b.tm_st2<>'4' and a.rent_mng_id = c.rent_mng_id(+) and a.rent_l_cd = c.rent_l_cd(+) and  nvl(c.cls_st,'0')<>'2' group by decode(a.bus_id2,'000037',a.mng_id, a.bus_id2)) h,\n"
				+
				// --기본식3개월이전
				"        (select /*+  merge(a) */ nvl(a.mng_id,'999999') as user_id, count(*) cnt4 from cont_n_view a where nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and a.rent_way_cd in ('2','3') group by a.mng_id) i,\n"
				+
				// --기본식3개월이전 대여료
				"        (select /*+  merge(a) */ nvl(a.mng_id,'999999') as user_id, sum(b.fee_s_amt+b.fee_v_amt) amt4 from cont_n_view a, scd_fee b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228')  and a.rent_way_cd in ('2','3') and b.rc_yn='0' and b.tm_st2<>'4' group by a.mng_id) j,\n"
				+ "        users z\n" + " where \n" + " a.user_id=b.user_id\n" + " and a.user_id=c.user_id\n"
				+ " and a.user_id=d.user_id\n" + " and a.user_id=e.user_id\n" + " and a.user_id=f.user_id\n"
				+ " and a.user_id=g.user_id\n" + " and a.user_id=h.user_id\n" + " and a.user_id=i.user_id\n"
				+ " and a.user_id=j.user_id\n" + " and a.user_id=z.user_id and z.user_pos in ('차장', '사원','대리','과장') ";

		if (sort.equals("1"))
			query += " order by z.user_nm " + asc;
		else if (sort.equals("2"))
			query += " order by z.enter_dt " + asc;
		else if (sort.equals("3"))
			query += " order by c.cnt1+e.cnt2+i.cnt4 " + asc + " , t_amt desc ";
		else if (sort.equals("4"))
			query += " order by b.t_amt " + asc;
		else if (sort.equals("5"))
			query += " order by c.cnt1 " + asc;
		else if (sort.equals("6"))
			query += " order by d.amt1 " + asc;
		else if (sort.equals("7"))
			query += " order by e.cnt2 " + asc;
		else if (sort.equals("8"))
			query += " order by f.amt2 " + asc;
		else if (sort.equals("9"))
			query += " order by g.cnt3 " + asc;
		else if (sort.equals("10"))
			query += " order by trunc((h.amt3/b.t_amt)*100,2) " + asc;

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				IncomingSBean fee = new IncomingSBean();
				fee.setGubun(rs.getString("user_id"));
				fee.setGubun_sub(rs.getString("user_nm"));
				fee.setTot_su1(rs.getString("t_cnt"));
				fee.setTot_amt1(rs.getString("t_amt"));
				fee.setTot_su2(rs.getString("cnt1"));
				fee.setTot_amt2(rs.getString("amt1"));
				fee.setTot_su3(rs.getString("cnt2"));
				fee.setTot_amt3(rs.getString("amt2"));
				fee.setTot_su4(rs.getString("cnt3"));
				fee.setTot_amt4(rs.getString("per"));
				fee.setTot_su5(rs.getString("cnt4"));
				fee.setTot_amt5(rs.getString("amt4"));
				vt.add(fee);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getDlyBusStatMD]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 영업담당배정 - 영업담당별 세부 리스트
	 */
	public Vector getDlyBusStatMDSub(String bus_id) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_qu = "";

		query = " select /*+  merge(a) */ a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.firm_nm, c.car_no, c.car_nm, a.rent_start_dt, a.rent_end_dt,"
				+ "        a.rent_way, nvl(d.t_amt,0) t_amt, nvl(e.d_amt,0) d_amt, trunc((e.d_amt/d.t_amt)*100,2) per"
				+ " from   cont_n_view a, car_reg c , \n" +
				// --총 대여료
				"        (select a.rent_mng_id, a.rent_l_cd, sum(b.fee_s_amt+b.fee_v_amt) t_amt from cont_n_view a, scd_fee b, cls_cont c  where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and b.rc_yn='0' and nvl(b.bill_yn,'Y')<>'N' and b.tm_st2<>'4' and a.rent_mng_id = c.rent_mng_id(+) and a.rent_l_cd = c.rent_l_cd(+) and nvl(c.cls_st,'0')<>'2' group by a.rent_mng_id, a.rent_l_cd) d,\n"
				+
				// --연체대여료
				"        (select a.rent_mng_id, a.rent_l_cd, sum(b.fee_s_amt+b.fee_v_amt) d_amt from cont_n_view a, scd_fee b, cls_cont c  where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and nvl(a.use_yn,'Y')='Y' and a.client_id not in ('000231', '000228') and b.rc_yn='0' and b.r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and nvl(b.bill_yn,'Y')<>'N' and b.tm_st2<>'4' and a.rent_mng_id = c.rent_mng_id(+) and a.rent_l_cd = c.rent_l_cd(+) and nvl(c.cls_st,'0')<>'2' group by a.rent_mng_id, a.rent_l_cd) e\n"
				+ " where  nvl(a.use_yn,'Y')='Y' and a.bus_id2='" + bus_id + "'\n"
				+ "        and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+)\n"
				+ "        and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)\n"
				+ "        and a.car_mng_id = c.car_mng_id " + " order by a.firm_nm, c.car_no";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getDlyBusStatMDSub]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 영업담당배정 - 담당자 변경
	 */
	public int updateBusId2(String m_id, String l_cd, String bus_id2) {
		getConnection();
		int count = 0;
		PreparedStatement pstmt = null;

		String query = " update cont set bus_id2='" + bus_id2 + "' where rent_mng_id='" + m_id + "' and rent_l_cd='"
				+ l_cd + "'";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			count = pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
			System.out.println("[AdminDatabase:insertStatMng]" + e);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try {
				conn.setAutoCommit(true);
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return count;
		}
	}

	/**
	 * 최초영업자 채권관리 3개월경과 이관처리시스템 대상 조회
	 */
	public void getContBusId2() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String l_cds = "";

		query = " select a.rent_l_cd" + "	from cont a, fee b, users c, "
				+ "	(select rent_mng_id, rent_l_cd, sum(fee_s_amt) dly_fee_amt from scd_fee where rc_yn='0' and tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') group by rent_mng_id, rent_l_cd ) d"
				+ "	where "
				+ "	nvl(a.use_yn,'Y')='Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' "
				+
				// " --기본식"+
				"	and b.rent_way='3'" + "	and a.bus_id2=c.user_id" +
				// " --영업담당자가 영업부"+
				"	and c.dept_id='0001'" +
				// " --대여개시후3개월경과"+
				"	and add_months(to_date(b.rent_start_dt,'YYYYMMDD'),3) <= sysdate" +
				// " --연체대여료이 없어야함"+
				"	and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+)" + "	and nvl(d.dly_fee_amt,0)=0"
				+
				// " --2005년7월부터"+
				"	and b.rent_start_dt >= '20050701'";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (!l_cds.equals(""))
					l_cds = l_cds + ",";
				l_cds = l_cds + rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getContBusId2]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
		}
	}

	/**
	 * 최초영업자 채권관리 3개월경과 이관처리시스템
	 */
	public void updateContBusId2() {
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";

		query = " update cont set bus_id2='000006'" + // 관리부 허승범 차장님으로 이관
				" where (rent_mng_id, rent_l_cd) in " + " ( select" + "		a.rent_mng_id, a.rent_l_cd"
				+ "	from cont a, fee b, users c, "
				+ "	(select rent_mng_id, rent_l_cd, sum(fee_s_amt) dly_fee_amt from scd_fee where rc_yn='0' and tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') group by rent_mng_id, rent_l_cd ) d"
				+ "	where "
				+ "	nvl(a.use_yn,'Y')='Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' "
				+
				// " --기본식"+
				"	and b.rent_way='3'" + "	and a.bus_id2=c.user_id" +
				// " --영업담당자가 영업부"+
				"	and c.dept_id='0001'" +
				// " --대여개시후3개월경과"+
				"	and add_months(to_date(b.rent_start_dt,'YYYYMMDD'),3) <= sysdate" +
				// " --연체대여료이 없어야함"+
				"	and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+)" + "	and nvl(d.dly_fee_amt,0)=0"
				+
				// " --2005년7월부터"+
				"	and b.rent_start_dt >= '20050701'" + " )";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
			try {
				System.out.println("[AdminDatabase:updateContBusId2]" + e);
				conn.rollback();
			} catch (SQLException _ignored) {
			}
			e.printStackTrace();
			flag = false;
		} finally {
			try {
				conn.setAutoCommit(true);
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
		}
	}

	/**
	 * 영업담당배정 - 영업담당별 세부 리스트
	 */
	public Vector getContBusId2V() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_qu = "";

		query = " select a.rent_mng_id, a.rent_l_cd, a.bus_id2, nvl(a.mng_id, decode(c.dept_id,'0001','000006','0007','000066','0008',a.bus_id2)) mng_id"
				+ "	from cont a, fee b, users c, "
				+ "	(select rent_mng_id, rent_l_cd, sum(fee_s_amt) dly_fee_amt from scd_fee where fee_tm='3' and rc_yn='0' and tm_st2<>'4' group by rent_mng_id, rent_l_cd ) d,"
				+ "	(select rent_mng_id, rent_l_cd, sum(fee_s_amt) dly_fee_amt from scd_fee where r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and rc_yn='0' and tm_st2<>'4' group by rent_mng_id, rent_l_cd ) e"
				+ "	where "
				+ "	nvl(a.use_yn,'Y')='Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' "
				+
				// " --기본식"+
				"	and b.rent_way='3'" + "	and a.bus_id2=c.user_id" +
				// " --영업담당자가 영업부"+
				"	and c.dept_id='0001' and c.br_id='S1'" +
				// " --2008-05-14일 이전에는 대여개시후 3개월경과 이후는 4개월경과 : 2008년5월13일 수정"+
				"	and add_months(to_date(b.rent_start_dt,'YYYYMMDD'),decode(sign(to_date('20080514','YYYYMMDD')-to_date(a.rent_dt,'YYYYMMDD')),1,3,4)) <= sysdate"
				+
				// " --3회차 연체대여료이 없어야함"+
				"	and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+)" + "	and nvl(d.dly_fee_amt,0)=0"
				+
				// " --3회이후에 오늘 이전 대여료에 대한 연체대여료이 없어야함"+
				"	and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)" + "	and nvl(e.dly_fee_amt,0)=0"
				+
				// " --2005년7월부터"+
				"	and b.rent_start_dt >= '20050701'";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getContBusId2]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 영업담당배정 - 영업담당별 세부 리스트
	 */
	public Vector getContBusId2V_200805() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_qu = "";

		query = " select a.rent_mng_id, a.rent_l_cd, a.bus_id2, nvl(a.mng_id, decode(c.dept_id,'0001','000006','0007','000066','0008',a.bus_id2)) mng_id"
				+ "	from cont a, fee b, users c, "
				+ "	(select b.rent_mng_id, b.rent_l_cd, sum(b.fee_s_amt) dly_fee_amt from scd_fee b, cont a where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.fee_tm=decode(sign(to_date('20080514','YYYYMMDD')-to_date(a.rent_dt,'YYYYMMDD')),1,'3','4') and b.rc_yn='0' and b.tm_st2<>'4' group by b.rent_mng_id, b.rent_l_cd ) d,"
				+ "	(select rent_mng_id, rent_l_cd, sum(fee_s_amt) dly_fee_amt from scd_fee where r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and rc_yn='0' and tm_st2<>'4' group by rent_mng_id, rent_l_cd ) e,"
				+ "   (select a.rent_mng_id, a.rent_l_cd, sum(a.paid_amt) paid_amt from fine a where a.paid_amt>0 and a.vio_cont not like '%통행료%' and a.coll_dt is null and nvl(a.bill_yn,'Y')='Y' and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N' group by a.rent_mng_id, a.rent_l_cd) f,"
				+ "	(select rent_mng_id, rent_l_cd, sum(ext_s_amt) dly_ext_amt from scd_ext where ext_st='3' and ext_est_dt < to_char(sysdate,'YYYYMMDD') and ext_pay_dt is null and nvl(bill_yn,'Y')='Y' group by rent_mng_id, rent_l_cd ) g"
				+ "	where "
				+ "	nvl(a.use_yn,'Y')='Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' "
				+
				// " --기본식"+
				"	and b.rent_way='3'" + "	and a.bus_id2=c.user_id" +
				// " --영업담당자가 영업부"+
				"	and c.dept_id='0001' and c.br_id='S1'" +
				// " --2008-05-14일 이전에는 대여개시후 3개월경과 이후는 4개월경과 : 2008년5월13일 수정"+
				"	and add_months(to_date(b.rent_start_dt,'YYYYMMDD'),decode(sign(to_date('20080514','YYYYMMDD')-to_date(a.rent_dt,'YYYYMMDD')),1,3,4)) <= sysdate"
				+
				// " --3회차 연체대여료이 없어야함"+
				"	and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+)" + "	and nvl(d.dly_fee_amt,0)=0"
				+
				// " --3회이후에 오늘 이전 대여료에 대한 연체대여료이 없어야함"+
				"	and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)" + "	and nvl(e.dly_fee_amt,0)=0"
				+
				// " --2005년7월부터"+
				"	and b.rent_start_dt >= '20050701'" +
				// " --미수과태료가 없어야 함"+
				"	and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+)" + "   and nvl(f.paid_amt,0)=0 " +
				// " --미수면책금이 없어야 함"+
				"	and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+)"
				+ "   and nvl(g.dly_ext_amt,0)=0 ";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getContBusId2V_200805]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 영업담당배정 - 영업담당별 세부 리스트
	 */
	public Vector getContBusId2V_200806() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_qu = "";

		query = " select a.rent_mng_id, a.rent_l_cd, a.bus_id2, "
				+ "   decode(a.mng_id,'', decode(c.dept_id,'0001','000006','0007','000053','0008',a.bus_id2), a.bus_id2, decode(c.dept_id,'0001','000006','0007','000053','0008',a.bus_id2), a.mng_id) mng_id"
				+ "	from cont a, fee b, users c, "
				+ "	(select b.rent_mng_id, b.rent_l_cd, sum(b.fee_s_amt) dly_fee_amt from scd_fee b, cont a, users c "
				+ "	 where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.bus_id2=c.user_id "
				+ "	        and b.fee_tm=decode(c.br_id,'B1','6',decode(sign(to_date('20080514','YYYYMMDD')-to_date(a.rent_dt,'YYYYMMDD')),1,'3','6')) "
				+ "			and b.rc_yn='0' and b.tm_st2<>'4' group by b.rent_mng_id, b.rent_l_cd ) d,"
				+ "	(select rent_mng_id, rent_l_cd, sum(fee_s_amt) dly_fee_amt from scd_fee where r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and rc_yn='0' and tm_st2<>'4' group by rent_mng_id, rent_l_cd ) e,"
				+ "   (select a.rent_mng_id, a.rent_l_cd, sum(a.paid_amt) paid_amt from fine a where a.paid_amt>0 and a.vio_cont not like '%통행료%' and a.coll_dt is null and nvl(a.bill_yn,'Y')='Y' and a.paid_st in ('3','4') and nvl(a.no_paid_yn,'N')='N' group by a.rent_mng_id, a.rent_l_cd) f,"
				+ "	(select rent_mng_id, rent_l_cd, sum(ext_s_amt) dly_ext_amt from scd_ext where ext_st='3' and ext_est_dt < to_char(sysdate,'YYYYMMDD') and ext_pay_dt is null and nvl(bill_yn,'Y')='Y' group by rent_mng_id, rent_l_cd ) g"
				+ "	where "
				+ "	nvl(a.use_yn,'Y')='Y' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_st='1' "
				+
				// " --기본식"+
				"	and b.rent_way='3'" + "	and a.bus_id2=c.user_id" +
				// " --영업담당자가 영업부/부산지점"+
				"	and c.loan_st ='2' and c.dept_id not in ('0008','9999')" + // 대전지점,퇴사자는 제외
				// " --2008-05-14일 이전에는 대여개시후 3개월경과 이후는 4개월경과 : 2008년5월13일 수정"+
				"	and add_months(to_date(b.rent_start_dt,'YYYYMMDD'),decode(c.br_id,'B1',6,decode(sign(to_date('20080514','YYYYMMDD')-to_date(a.rent_dt,'YYYYMMDD')),1,3,6))) <= sysdate"
				+
				// " --6회차 연체대여료이 없어야함"+
				"	and a.rent_mng_id=d.rent_mng_id(+) and a.rent_l_cd=d.rent_l_cd(+)" + "	and nvl(d.dly_fee_amt,0)=0"
				+
				// " --3회이후에 오늘 이전 대여료에 대한 연체대여료이 없어야함"+
				"	and a.rent_mng_id=e.rent_mng_id(+) and a.rent_l_cd=e.rent_l_cd(+)" + "	and nvl(e.dly_fee_amt,0)=0"
				+
				// " --2005년7월부터"+
				"	and b.rent_start_dt >= '20050701'" +
				// " --미수과태료가 없어야 함"+
				"	and a.rent_mng_id=f.rent_mng_id(+) and a.rent_l_cd=f.rent_l_cd(+)" + "   and nvl(f.paid_amt,0)=0 " +
				// " --미수면책금이 없어야 함"+
				"	and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+)"
				+ "   and nvl(g.dly_ext_amt,0)=0 ";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getContBusId2V_200806]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 최초영업자 채권관리 3개월경과 이관처리시스템
	 */
	public void updateContBusId2(String rent_l_cd) {
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";

		query = " update cont set bus_id2=nvl(mng_id,'000006') " + // 관리부 허승범 차장님으로 이관
				" where rent_l_cd = '" + rent_l_cd + "'";
		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
			try {
				System.out.println("[AdminDatabase:updateContBusId2(String rent_l_cd)]" + e);
				conn.rollback();
				e.printStackTrace();
				flag = false;
			} catch (SQLException _ignored) {
			}
		} finally {
			try {
				conn.setAutoCommit(true);
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
		}
	}

	/**
	 * 최초영업자 채권관리 3개월경과 이관처리시스템
	 */
	public void updateContBusId2(String rent_mng_id, String rent_l_cd, String bus_id2, String mng_id) {
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		String query = "";
		String i_query = "";

		query = " update cont set bus_id2=nvl(mng_id,'000006'), mng_id='' " + // 관리부 허승범 차장님으로 이관
				" where rent_l_cd = '" + rent_l_cd + "'";

		i_query = " insert into cont_bus_cng_h (rent_mng_id, rent_l_cd, be_bus_id, af_bus_id, cng_dt)" + " values ('"
				+ rent_mng_id + "', '" + rent_l_cd + "', '" + bus_id2 + "',";

		if (mng_id.equals(""))
			i_query += "'000006', to_char(sysdate,'YYYYMMDD'))";
		if (!mng_id.equals(""))
			i_query += "'" + mng_id + "', to_char(sysdate,'YYYYMMDD'))";

		try {
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query);
			pstmt1.executeUpdate();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(i_query);
			pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();

		} catch (Exception e) {
			try {
				System.out.println(
						"[AdminDatabase:updateContBusId2(String rent_mng_id, String rent_l_cd, String bus_id2, String mng_id)]"
								+ e);
				conn.rollback();
				e.printStackTrace();
				flag = false;
			} catch (SQLException _ignored) {
			}
		} finally {
			try {
				conn.setAutoCommit(true);
				if (pstmt1 != null)
					pstmt1.close();
				if (pstmt2 != null)
					pstmt2.close();
			} catch (Exception ignore) {
			}
			closeConnection();
		}
	}

	/**
	 * 최초영업자 채권관리 3개월경과 이관처리시스템
	 */
	public void updateContBusIdCng(String rent_mng_id, String rent_l_cd, String bus_id2, String cng_id) {
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		String query = "";
		String i_query = "";

		query = " update cont set bus_id2='" + cng_id + "' where rent_l_cd = '" + rent_l_cd + "'";

		i_query = " insert into cont_bus_cng_h (rent_mng_id, rent_l_cd, be_bus_id, af_bus_id, cng_dt)" + " values ('"
				+ rent_mng_id + "', '" + rent_l_cd + "', '" + bus_id2 + "', '" + cng_id
				+ "', to_char(sysdate,'YYYYMMDD'))";

		try {
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(query);
			pstmt1.executeUpdate();
			pstmt1.close();

			pstmt2 = conn.prepareStatement(i_query);
			pstmt2.executeUpdate();
			pstmt2.close();

			conn.commit();

		} catch (Exception e) {
			try {
				System.out.println(
						"[AdminDatabase:updateContBusIdCng(String rent_mng_id, String rent_l_cd, String bus_id2, String cng_id)]"
								+ e);
				conn.rollback();
				e.printStackTrace();
				flag = false;
			} catch (SQLException _ignored) {
			}
		} finally {
			try {
				conn.setAutoCommit(true);
				if (pstmt1 != null)
					pstmt1.close();
				if (pstmt2 != null)
					pstmt2.close();
			} catch (Exception ignore) {
			}
			closeConnection();
		}
	}

	/**
	 * 최초영업자 채권관리 3개월경과 이관처리시스템 이력 리스트 조회
	 */
	public Vector getContBusCngHList() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_qu = "";

		query = " select /*+  merge(b) */ a.*, b.firm_nm, c.car_no, c.car_nm, b.rent_start_dt"
				+ " from cont_bus_cng_h a, cont_n_view b, car_reg c \n"
				+ " where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  and b.car_mng_id = c.car_mng_id "
				+ " order by a.cng_dt desc";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getContBusCngHList]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 최초영업자 채권관리 3개월경과 이관처리시스템 이력 리스트 조회
	 */
	public Vector getContBusCngHList(String user_id) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_qu = "";

		query = " select /*+  merge(b) */ a.*, b.firm_nm, c.car_no, c.car_nm, b.rent_start_dt, b.bus_id2"
				+ " from cont_bus_cng_h a, cont_n_view b , car_reg c \n"
				+ " where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id = c.car_mng_id "
				+ "  and a.cng_dt between to_char(add_months(sysdate,-3),'YYYYMM')||'01' and to_char(sysdate,'YYYYMM')||'31'";

		if (!user_id.equals(""))
			query += " and a.af_bus_id='" + user_id + "'";// and b.bus_id2='"+user_id+"'

		if (!user_id.equals(""))
			query += "union "
					+ " select /*+  merge(b) */ a.*, b.firm_nm, c.car_no, c.car_nm, b.rent_start_dt, b.mng_id2"
					+ " from cont_bus_cng_h a, cont_n_view b, car_reg c \n"
					+ " where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id = c.car_mng_id "
					+ " and a.cng_dt between to_char(add_months(sysdate,-3),'YYYYMM')||'01' and to_char(sysdate,'YYYYMM')||'31'"
					+ " and b.mng_id2 ='" + user_id + "'";

		query += " order by 5 desc";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getContBusCngHList(String user_id)]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 최초영업자 채권관리 6개월경과 이관처리시스템 이력 리스트 조회 - 보유차 영업담당자는 제외
	 */
	public Vector getContBusCngHListNew(String user_id) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_qu = "";

		query = " select /*+  merge(b) */ a.*, b.fee_rent_st, b.rent_way, b.firm_nm, c.car_no, c.car_nm, b.rent_start_dt, b.bus_id2"
				+ " from lc_rent_cng_h a, cont_n_view b, car_reg c \n"
				+ " where nvl(b.use_yn,'Y')='Y' and b.client_id <> '000228' and b.car_st in ('1','3') and a.cng_item='bus_id2' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.car_mng_id = c.car_mng_id \n"
				+ "  and a.cng_dt between to_char(add_months(sysdate,-1),'YYYYMM')||'01' and to_char(sysdate,'YYYYMM')||'31' \n";

		if (!user_id.equals(""))
			query += " and a.new_value like '%" + user_id + "%'";

		if (!user_id.equals("")) {
			query += "union \n"
					+ " select /*+  merge(b) */ a.*, b.fee_rent_st, b.rent_way, b.firm_nm, c.car_no, c.car_nm, b.rent_start_dt, b.mng_id2"
					+ " from lc_rent_cng_h a, cont_n_view b, car_reg c \n"
					+ " where nvl(b.use_yn,'Y')='Y' and b.client_id <> '000228' and b.car_st in ('1','3') and a.cng_item='bus_id2' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and  b.car_mng_id = c.car_mng_id \n"
					+ " and a.cng_dt between to_char(add_months(sysdate,-1),'YYYYMM')||'01' and to_char(sysdate,'YYYYMM')||'31' "
					+ " and b.mng_id ='" + user_id + "' and a.new_value not like '%" + user_id + "%'";
		}

		query += " order by 9 desc, 2, 3";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getContBusCngHListNew(String user_id)]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 최초영업자 채권관리 3개월경과 이관처리시스템 이력 리스트 조회
	 */
	public Vector getContBusCngHList(String rent_mng_id, String rent_l_cd) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_qu = "";

		query = " select /*+  merge(b) */ a.*, b.firm_nm, c.car_no, c.car_nm, b.rent_start_dt, b.bus_id2"
				+ " from cont_bus_cng_h a, cont_n_view b, car_reg c \n"
				+ " where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and  b.car_mng_id = c.car_mng_id \n"
				+ "  and a.cng_dt between to_char(add_months(sysdate,-3),'YYYYMM')||'01' and to_char(sysdate,'YYYYMM')||'31' "
				+ "  and a.rent_mng_id=? and a.rent_l_cd=?";

		query += " order by 5 desc";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getContBusCngHList(String user_id)]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	// 제조사별 자동차 현황
	// 20050905-------------------------------------------------------------------------------------------------------------

	/**
	 * 자동차 현황 (제조사별 전체) 20050905
	 */
	public Hashtable getStatMakerCarAll() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = "select sum(decode(n.car_comp_id,'0001',1,0)) h, to_char(sum(decode(n.car_comp_id,'0001',1,0))*100/count(*),'90.99') hp, "
				+ " 	sum(decode(n.car_comp_id,'0002',1,0)) k, to_char(sum(decode(n.car_comp_id,'0002',1,0))*100/count(*),'90.99') kp, "
				+ " 	sum(decode(n.car_comp_id,'0003',1,0)) r, to_char(sum(decode(n.car_comp_id,'0003',1,0))*100/count(*),'90.99') rp, "
				+ " 	sum(decode(n.car_comp_id,'0004',1,0)) g, to_char(sum(decode(n.car_comp_id,'0004',1,0))*100/count(*),'90.99') gp, "
				+ " 	sum(decode(n.car_comp_id,'0005',1,0)) s, to_char(sum(decode(n.car_comp_id,'0005',1,0))*100/count(*),'90.99') sp, "
				+ " 	sum(decode(sign(to_number(n.car_comp_id)-5),1,1,0)) e, to_char(sum(decode(sign(to_number(n.car_comp_id)-5),1,1,0))*100/count(*),'90.99') ep, "
				+ " 	count(*) total " + " from car_reg C, cont t, car_etc e, car_nm n "
				+ " where c.car_mng_id = t.car_mng_id " + " and t.rent_mng_id = e.rent_mng_id "
				+ " and t.rent_l_cd = e.rent_l_cd " + " and  nvl(t.use_yn,'Y')='Y' and nvl(prepare,'1') <>'4' "
				+ " and e.car_id = n.car_id " + " and e.car_seq = n.car_seq ";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatMakerCar()]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return ht;
		}
	}

	/**
	 * 제조사 개별 자동차 현황 20050905
	 */
	public Vector getStatMakerCar(String maker) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery = "";

		if (maker.equals("0000"))
			subQuery = " and d.car_comp_id > '0005' ";
		else if (maker.equals("total"))
			subQuery = "";
		else
			subQuery = " and d.car_comp_id = '" + maker + "' ";

		query = "select e.s_st, f.s_sd, d.car_nm, "
				+ " 	sum(decode(sign(substr(a.init_reg_dt,1,4)-2002),-1,1,0)) y2001, "
				+ " 	sum(decode(substr(a.init_reg_dt,1,4),'2002',1,0)) y2002, "
				+ " 	sum(decode(substr(a.init_reg_dt,1,4),'2003',1,0)) y2003, "
				+ " 	sum(decode(substr(a.init_reg_dt,1,4),'2004',1,0)) y2004, "
				+ " 	sum(decode(substr(a.init_reg_dt,1,4),'2005',1,0)) y2005, "
				+ " 	sum(decode(substr(a.init_reg_dt,1,4),'2006',1,0)) y2006, "
				+ " 	sum(decode(substr(a.init_reg_dt,1,4),'2007',1,0)) y2007, "
				+ " 	sum(decode(substr(a.init_reg_dt,1,4),'2008',1,0)) y2008, " + "   count(*) total "
				+ " from car_reg a, cont b, car_etc c, car_mng d, car_nm e, "
				+ "	(select * from esti_car_var where seq = (select max(seq) from esti_car_var a where a.a_e = a_e) and a_a='1') f "
				+ " where a.car_mng_id = b.car_mng_id "
				+ " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd "
				+ " and c.car_id = e.car_id and c.car_seq = e.car_seq "
				+ " and d.car_comp_id = e.car_comp_id and d.code = e.car_cd "
				+ " and nvl(b.use_yn,'Y') = 'Y' and nvl(prepare,'1') <>'4' " + " and e.s_st = f.a_e(+) " + subQuery
				+ " group by e.s_st, f.s_sd, d.car_nm order by total desc ";
		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatMakerCar(String maker)]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 제조사 개별 자동차 현황2, 구분없이 차종별로만. 20050907
	 */
	public Vector getStatMakerCar2(String maker) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery = "";

		if (maker.equals("0000"))
			subQuery = " and d.car_comp_id > '0005' ";
		else if (maker.equals("total"))
			subQuery = "";
		else
			subQuery = " and d.car_comp_id = '" + maker + "' ";

		query = "select d.car_nm, " + " 	sum(decode(sign(substr(a.init_reg_dt,1,4)-2002),-1,1,0)) y2001, "
				+ " 	sum(decode(substr(a.init_reg_dt,1,4),'2002',1,0)) y2002, "
				+ " 	sum(decode(substr(a.init_reg_dt,1,4),'2003',1,0)) y2003, "
				+ " 	sum(decode(substr(a.init_reg_dt,1,4),'2004',1,0)) y2004, "
				+ " 	sum(decode(substr(a.init_reg_dt,1,4),'2005',1,0)) y2005, "
				+ " 	sum(decode(substr(a.init_reg_dt,1,4),'2006',1,0)) y2006, "
				+ " 	sum(decode(substr(a.init_reg_dt,1,4),'2007',1,0)) y2007, "
				+ " 	sum(decode(substr(a.init_reg_dt,1,4),'2008',1,0)) y2008, " + "   count(*) total "
				+ " from car_reg a, cont b, car_etc c, car_mng d, car_nm e " + " where a.car_mng_id = b.car_mng_id "
				+ " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd "
				+ " and c.car_id = e.car_id and c.car_seq = e.car_seq "
				+ " and d.car_comp_id = e.car_comp_id and d.code = e.car_cd "
				+ " and nvl(b.use_yn,'Y') = 'Y' and nvl(prepare,'1') <>'4' " + subQuery
				+ " group by d.car_nm order by total desc ";
		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatMakerCar(String maker)]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * //일반식 고객 미관리 리스트
	 */
	public Vector getClientBusNotMngList(String user_id) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select" + " c.user_nm 담당자," + " a.firm_nm 상호, " + " b.use_y_cnt 대여대수,"
				+ " b.min_dt 최초대여개시일, b.max_dt 최근대여개시일," + " decode(b.way_2+b.way_3,0,'일반식',"
				+ "        decode(b.way_1+b.way_3,0,'맞춤식',"
				+ "               decode(b.way_1+b.way_2,0,'기본식','혼합'))) 대여방식," + " d.vst_cnt 방문횟수,"
				+ " d.vst_dt 최근방문일자," + " e.serv_dt 최근정비일자" + " from client a,"
				+ "      (select a.client_id, a.bus_id2," + "              min(nvl(a.rent_start_dt,a.rent_dt)) min_dt,"
				+ "              max(nvl(a.rent_start_dt,a.rent_dt)) max_dt,"
				+ "              count(decode(a.use_yn,'Y',a.rent_l_cd)) use_y_cnt,"
				+ "              count(decode(a.use_yn,'N',a.rent_l_cd)) use_n_cnt,"
				+ "              count(decode(a.use_yn,'Y',decode(b.rent_way,'1',a.rent_l_cd))) way_1,"
				+ "              count(decode(a.use_yn,'Y',decode(b.rent_way,'2',a.rent_l_cd))) way_2,"
				+ "              count(decode(a.use_yn,'Y',decode(b.rent_way,'3',a.rent_l_cd))) way_3"
				+ "      from cont a, fee b where a.rent_l_cd=b.rent_l_cd and b.rent_st='1' group by a.client_id, a.bus_id2) b,"
				+ "      users c,"
				+ "      (select client_id, count(*) vst_cnt, max(vst_dt) vst_dt from cycle_vst group by client_id) d,"
				+ "      (select b.client_id, max(a.serv_dt) serv_dt from service a, cont b where a.rent_l_cd=b.rent_l_cd group by b.client_id) e"
				+ " where a.firm_nm not like '%아마존카%'" + " and a.client_id=b.client_id and b.bus_id2=c.user_id(+)"
				+ " and b.use_y_cnt > 0" + " and a.client_id=d.client_id(+)" + " and b.way_1 > 0"
				+ " and a.client_id=e.client_id(+)" + " and nvl(d.vst_dt,e.serv_dt) is null";

		if (!user_id.equals(""))
			query += " and b.bus_id2='" + user_id + "'";

		if (!user_id.equals(""))
			query += " union " + " select" + " c.user_nm 담당자," + " a.firm_nm 상호, " + " b.use_y_cnt 대여대수,"
					+ " b.min_dt 최초대여개시일, b.max_dt 최근대여개시일," + " decode(b.way_2+b.way_3,0,'일반식',"
					+ "        decode(b.way_1+b.way_3,0,'맞춤식',"
					+ "               decode(b.way_1+b.way_2,0,'기본식','혼합'))) 대여방식," + " d.vst_cnt 방문횟수,"
					+ " d.vst_dt 최근방문일자," + " e.serv_dt 최근정비일자" + " from client a,"
					+ "      (select a.client_id, a.mng_id2,"
					+ "              min(nvl(a.rent_start_dt,a.rent_dt)) min_dt,"
					+ "              max(nvl(a.rent_start_dt,a.rent_dt)) max_dt,"
					+ "              count(decode(a.use_yn,'Y',a.rent_l_cd)) use_y_cnt,"
					+ "              count(decode(a.use_yn,'N',a.rent_l_cd)) use_n_cnt,"
					+ "              count(decode(a.use_yn,'Y',decode(b.rent_way,'1',a.rent_l_cd))) way_1,"
					+ "              count(decode(a.use_yn,'Y',decode(b.rent_way,'2',a.rent_l_cd))) way_2,"
					+ "              count(decode(a.use_yn,'Y',decode(b.rent_way,'3',a.rent_l_cd))) way_3"
					+ "      from cont a, fee b where a.rent_l_cd=b.rent_l_cd and b.rent_st='1' group by a.client_id, a.mng_id2) b,"
					+ "      users c,"
					+ "      (select client_id, count(*) vst_cnt, max(vst_dt) vst_dt from cycle_vst group by client_id) d,"
					+ "      (select b.client_id, max(a.serv_dt) serv_dt from service a, cont b where a.rent_l_cd=b.rent_l_cd group by b.client_id) e"
					+ " where a.firm_nm not like '%아마존카%'" + " and a.client_id=b.client_id and b.mng_id2=c.user_id(+)"
					+ " and b.use_y_cnt > 0" + " and a.client_id=d.client_id(+)" + " and b.way_1 > 0"
					+ " and a.client_id=e.client_id(+)" + " and nvl(d.vst_dt,e.serv_dt) is null " + " and b.mng_id2='"
					+ user_id + "'";

		query += " order by 1, 8 ";

		try {
			pstmt = conn.prepareStatement(query);

			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getClientBusNotMngList(String user_id)]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * //영업용차량 차령만료예정-today-90일까지 - 예비배정자 :예비차는 황수연 : 관리담당자, 부산은 정준형, 대전은
	 * 대전은심재홍->박영규(광주지점 임시폐쇄로 인해 관리담당자 변경 20131016)
	 */
	public Vector getCarEndDtEstList(String user_id) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.* ,   decode(a.bus_id2, '000003', '000013', '000004','000013','000005','000013' ,'000006','000013','000037','000013','000035','000013', '000031','000013','000077','000013','000144','000013', '000126','000013', '000026', '000013',  a.bus_id2)  mng_id , c.user_nm \n"
				+ " from " + " (  \n"
				+ "        select /*+  merge(a) */ decode(rm.use_yn , 'N', '','X', '', b.m1_chk ) m1_chk, nvl(rm.m1_dt, b.m1_dt ) m1_dt,   b.dg_yn,  b.dg_no, a.rent_mng_id, a.rent_l_cd, a.fee_rent_st,"
				+ "        b.car_no, b.car_nm, b.dpm, b.init_reg_dt, b.car_end_dt as reg_car_end_dt, b.car_end_yn, decode(a.car_st, '4', '0', b.car_mng_id)  rrm ,  b.maint_st_dt, b.maint_end_dt, \n"
				+ "        decode(length(replace(b.car_end_dt,' ','')),8,b.car_end_dt,decode(sign(b.dpm-2000),1,to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*8),'YYYYMMDD'),to_char(to_date(b.init_reg_dt,'YYYYMMDD')+(365*5),'YYYYMMDD'))) est_car_end_dt,  \n"
				+ "        d.firm_nm, e.rent_end_dt, decode(a.car_st, '4', a.mng_id2,  '2', nvl(a.mng_id, '000013') , nvl(a.mng_id, a.bus_id2) )  as bus_id2,  b.OFF_LS, b.car_mng_id , b.car_doc_no \n"
				+ "        from cont_n_view a, car_reg b, client d, (select rent_l_cd, max(rent_end_dt) rent_end_dt from fee group by rent_l_cd) e , \n"
				+ "       ( select m.* from car_maint_req m , (select car_mng_id, max(m1_no)  m1_no from car_maint_req  where gubun = 'Y'  group by car_mng_id ) m1     where  m.car_mng_id = m1.car_mng_id and m.m1_no = m1.m1_no  ) rm   \n"
				+ "        where a.car_mng_id=b.car_mng_id and nvl(a.use_yn,'Y')='Y' and nvl(b.prepare,'0') not in ('4','5')   \n"
				+ "        and a.client_id=d.client_id   \n" + "        and b.car_mng_id = rm.car_mng_id(+) \n"
				+ "        and a.rent_l_cd=e.rent_l_cd  \n" + "        and b.car_use = '1'   \n" + " )  a,  users c  \n"
				+ " where a.est_car_end_dt < to_char(sysdate+90,'YYYYMMDD')  and  decode(a.bus_id2, '000003', '000013', '000004','000013','000005','000013' ,'000006','000013','000037','000013','000035','000013', '000031','000013','000077','000013','000144','000013', '000126','000013', '000026', '000013',  a.bus_id2)  = c.user_id ";

		if (!user_id.equals(""))
			query += " and   decode(a.bus_id2, '000003', '000013', '000004','000013','000005','000013' ,'000006','000013','000037','000013','000035','000013', '000031','000013','000077','000013','000144','000013', '000126','000013', '000026', '000013',  a.bus_id2)   ='"
					+ user_id + "'";

		query += " order by 12, 10 ";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getCarEndDtEstList(String user_id)]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}

	}

	// 한국교통안전공단 검사만료 도래 5일wjs
	public Vector getCarCybertsList() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select t.*, a.rent_mng_id, a.rent_l_cd, \n"
				+ " b.init_reg_dt, b.car_end_dt as reg_car_end_dt, b.car_end_yn, decode(a.car_st, '4', '0', b.car_mng_id)  rrm ,		\n"
				+ " d.firm_nm, e.rent_end_dt, decode(a.car_st, '4', a.mng_id2,  '2', nvl(a.mng_id, '000013') , nvl(a.mng_id, a.bus_id2) )  as bus_id2 , b.car_doc_no  \n"
				+ "from  cyberts t,	car_reg b,  cont_n_view a, 	client d, (select rent_l_cd, max(rent_end_dt) rent_end_dt from fee group by rent_l_cd) e  \n"
				+ " where t.car_mng_id = b.car_mng_id(+) \n" + " and t.rent_l_cd = a.rent_l_cd(+)   \n"
				+ " and a.rent_l_cd=e.rent_l_cd(+) 	 \n" + "and a.client_id=d.client_id(+)  order by t.end_dt  ";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getCarCybertsList]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}

	}

	/*
	 * 부채마감 프로시져 호출
	 */
	public String call_sp_debt_magam(String s_day, String s_user_id) {
		getConnection();

		String query = "{CALL P_DEBT_MAGAM (?,?,?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {
			cstmt = conn.prepareCall(query);

			cstmt.setString(1, s_day);
			cstmt.setString(2, s_user_id);
			cstmt.registerOutParameter(3, java.sql.Types.VARCHAR);

			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_debt_magam]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/**
	 * Poll 리스트
	 */
	public Vector getPollAll() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.* FROM poll a order by a.use_yn, a.p_num ";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getPollAll]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	// 사내 설문조사
	public PollBean insertPoll(PollBean poll) {
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		String id_sql = " select MAX(nvl(p_num, 0))+1  as ID from poll ";
		int c_id = 0;
		try {
			pstmt1 = conn.prepareStatement(id_sql);
			rs = pstmt1.executeQuery();
			if (rs.next()) {
				c_id = rs.getInt(1);
			}
			rs.close();
			pstmt1.close();

		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		if (c_id == 0)
			c_id = 1;
		poll.setP_num(c_id);

		String query = " insert into POLL ( P_NUM, P_TITLE, P_QCOUNT, P_Q1, P_Q2, P_Q3, P_Q4, P_Q5, P_Q6, P_Q7, "
				+ " P_Q8, USE_YN, Q1_REM, Q2_REM, Q3_REM, Q4_REM, Q5_REM, Q6_REM, Q7_REM, Q8_REM , P_DATE, "
				+ "P_Q1_COUNT, P_Q2_COUNT, P_Q3_COUNT, P_Q4_COUNT, P_Q5_COUNT, P_Q6_COUNT, P_Q7_COUNT, P_Q8_COUNT, "
				+ "P_Q1_COUNT_U, P_Q2_COUNT_U, P_Q3_COUNT_U, P_Q4_COUNT_U, P_Q5_COUNT_U, P_Q6_COUNT_U, P_Q7_COUNT_U, P_Q8_COUNT_U, "
				+ "P_VOTE_COUNT, P_TOTAL_COUNT, EN_DT_YN ) values (" + " ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "
				+ " ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, sysdate, " + " 0,0,0,0,0,0,0,0,  0,0,0,0,0,0,0,0,   0,0, ? )";
		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, poll.getP_num());
			pstmt.setString(2, poll.getP_title().trim());
			pstmt.setInt(3, poll.getP_qcount());
			pstmt.setString(4, poll.getP_q1().trim());
			pstmt.setString(5, poll.getP_q2().trim());
			pstmt.setString(6, poll.getP_q3().trim());
			pstmt.setString(7, poll.getP_q4().trim());
			pstmt.setString(8, poll.getP_q5().trim());
			pstmt.setString(9, poll.getP_q6().trim());
			pstmt.setString(10, poll.getP_q7().trim());
			pstmt.setString(11, poll.getP_q8().trim());
			pstmt.setString(12, poll.getUse_yn());
			pstmt.setString(13, poll.getQ1_rem());
			pstmt.setString(14, poll.getQ2_rem());
			pstmt.setString(15, poll.getQ3_rem());
			pstmt.setString(16, poll.getQ4_rem());
			pstmt.setString(17, poll.getQ5_rem());
			pstmt.setString(18, poll.getQ6_rem());
			pstmt.setString(19, poll.getQ7_rem());
			pstmt.setString(20, poll.getQ8_rem());
			pstmt.setString(21, poll.getEn_dt_yn());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:insertPoll]\n" + e);
			e.printStackTrace();
			conn.rollback();
		} catch (Exception e) {
			System.out.println("[AdminDatabase:insertPoll]\n" + e);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try {
				conn.setAutoCommit(true);
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (pstmt1 != null)
					pstmt1.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return poll;
		}
	}

	/* poll 수정 */
	public boolean updatePoll(PollBean poll) {
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query = " update POLL set " + " P_TITLE = ?, " + " P_QCOUNT = ?, " + " P_Q1 = ?, " + " P_Q2 = ?, "
				+ " P_Q3 = ?, " + " P_Q4 = ?, " + " P_Q5 = ?, " + " P_Q6 = ?, " + " P_Q7 = ?, " + " P_Q8 = ?, "
				+ " USE_YN = ?, " + " Q1_REM = ?, " + " Q2_REM = ?, " + " Q3_REM = ?, " + " Q4_REM = ?, "
				+ " Q5_REM = ?, " + " Q6_REM = ?, " + " Q7_REM = ?, " + " Q8_REM = ?, " + " EN_DT_YN = ? "
				+ " where P_NUM = ? ";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, poll.getP_title());
			pstmt.setInt(2, poll.getP_qcount());
			pstmt.setString(3, poll.getP_q1());
			pstmt.setString(4, poll.getP_q2());
			pstmt.setString(5, poll.getP_q3());
			pstmt.setString(6, poll.getP_q4());
			pstmt.setString(7, poll.getP_q5());
			pstmt.setString(8, poll.getP_q6());
			pstmt.setString(9, poll.getP_q7());
			pstmt.setString(10, poll.getP_q8());
			pstmt.setString(11, poll.getUse_yn());
			pstmt.setString(12, poll.getQ1_rem());
			pstmt.setString(13, poll.getQ2_rem());
			pstmt.setString(14, poll.getQ3_rem());
			pstmt.setString(15, poll.getQ4_rem());
			pstmt.setString(16, poll.getQ5_rem());
			pstmt.setString(17, poll.getQ6_rem());
			pstmt.setString(18, poll.getQ7_rem());
			pstmt.setString(19, poll.getQ8_rem());
			pstmt.setString(20, poll.getEn_dt_yn());
			pstmt.setInt(21, poll.getP_num());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:updatePoll]\n" + e);
			e.printStackTrace();
			flag = false;
			conn.rollback();
		} catch (Exception e) {
			System.out.println("[AdminDatabase:updatePoll]\n" + e);
			e.printStackTrace();
			flag = false;
			conn.rollback();
		} finally {
			try {
				conn.setAutoCommit(true);
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return flag;
		}
	}

	public PollBean getPollBean(String p_num) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PollBean bean = new PollBean();
		String query = "";

		query = " SELECT P_NUM, P_TITLE, P_QCOUNT, P_Q1, P_Q2, P_Q3, P_Q4, P_Q5, P_Q6, P_Q7, "
				+ " P_Q8, USE_YN, Q1_REM, Q2_REM, Q3_REM, Q4_REM, Q5_REM, Q6_REM, Q7_REM, Q8_REM , nvl(EN_DT_YN, 'Y') EN_DT_YN "
				+ " FROM POLL where P_NUM =" + Integer.parseInt(p_num);

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				bean.setP_num(rs.getInt("P_NUM"));
				bean.setP_title(rs.getString("P_TITLE"));
				bean.setP_qcount(rs.getInt("P_QCOUNT"));
				bean.setP_q1(rs.getString("P_Q1"));
				bean.setP_q2(rs.getString("P_Q2") == null ? "" : rs.getString("P_Q2"));
				bean.setP_q3(rs.getString("P_Q3") == null ? "" : rs.getString("P_Q3"));
				bean.setP_q4(rs.getString("P_Q4") == null ? "" : rs.getString("P_Q4"));
				bean.setP_q5(rs.getString("P_Q5") == null ? "" : rs.getString("P_Q5"));
				bean.setP_q6(rs.getString("P_Q6") == null ? "" : rs.getString("P_Q6"));
				bean.setP_q7(rs.getString("P_Q7") == null ? "" : rs.getString("P_Q7"));
				bean.setP_q8(rs.getString("P_Q8") == null ? "" : rs.getString("P_Q8"));
				bean.setQ1_rem(rs.getString("Q1_REM") == null ? "0" : rs.getString("Q1_REM"));
				bean.setQ2_rem(rs.getString("Q2_REM") == null ? "0" : rs.getString("Q2_REM"));
				bean.setQ3_rem(rs.getString("Q3_REM") == null ? "0" : rs.getString("Q3_REM"));
				bean.setQ4_rem(rs.getString("Q4_REM") == null ? "0" : rs.getString("Q4_REM"));
				bean.setQ5_rem(rs.getString("Q5_REM") == null ? "0" : rs.getString("Q5_REM"));
				bean.setQ6_rem(rs.getString("Q6_REM") == null ? "0" : rs.getString("Q6_REM"));
				bean.setQ7_rem(rs.getString("Q7_REM") == null ? "0" : rs.getString("Q7_REM"));
				bean.setQ8_rem(rs.getString("Q8_REM") == null ? "0" : rs.getString("Q8_REM"));
				bean.setUse_yn(rs.getString("USE_YN"));
				bean.setEn_dt_yn(rs.getString("EN_DT_YN"));

			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getPollBean]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return bean;
		}
	}

	public Vector getPollList() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT P_NUM, P_TITLE, P_QCOUNT, P_Q1, P_Q2, P_Q3, P_Q4, P_Q5, P_Q6, P_Q7, "
				+ " P_Q8, USE_YN, Q1_REM, Q2_REM, Q3_REM, Q4_REM, Q5_REM, Q6_REM, Q7_REM, Q8_REM , nvl(EN_DT_YN, 'Y') EN_DT_YN "
				+ " FROM POLL where use_yn = 'Y' order by p_num ";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getPollList]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	// 입사 1년 여부
	public int getPollTailCnt(String p_num) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

		String query = "select  count(*) cnt from poll_tail where  P_NUM =" + Integer.parseInt(p_num);

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (Exception e) {
			System.out.println("[AdminDatabase:getPollTailCnt]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return count;
		}
	}

	// 입사 1년 여부
	public int checkEnter_dt(String user_id) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

		String query = "select 	TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE( enter_dt, 'YYYYMMDD'))/12) i_year from users where nvl(use_yn,'Y')='Y' and user_id = '"
				+ user_id + "'";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (Exception e) {
			System.out.println("[AdminDatabase:checkEnter_dt]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return count;
		}
	}

	// 사내 설문조사
	public boolean insertPollTail(PollTailBean pt_bean) {
		getConnection();
		PreparedStatement pstmt = null;

		boolean flag = true;

		String query = " insert into POLL_TAIL ( P_NUM, P_USER_ID, P_DATE ) " + " values ( ?, ?, sysdate)";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, pt_bean.getP_num());
			pstmt.setString(2, pt_bean.getUser_id().trim());
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:insertPollTail]\n" + e);
			e.printStackTrace();
			conn.rollback();
		} catch (Exception e) {
			System.out.println("[AdminDatabase:insertPollTail]\n" + e);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try {
				conn.setAutoCommit(true);
				if (pstmt != null)
					pstmt.close();

			} catch (Exception ignore) {
			}
			closeConnection();
			return flag;
		}
	}

	// 사내 설문조사
	public boolean insertPollEtc(PollTailBean pt_bean) {
		getConnection();
		PreparedStatement pstmt = null;

		boolean flag = true;

		String query = " insert into POLL_ETC ( P_NUM, P_DATE, "
				+ "Q_REM1, Q_REM2, Q_REM3, Q_REM4, Q_REM5, Q_REM6, Q_REM7, Q_REM8 ) " + " values ( ?,  sysdate, "
				+ " ?, ?, ?, ?, ?, ?, ?, ?  ) ";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, pt_bean.getP_num());
			pstmt.setString(2, pt_bean.getQ_rem1().trim());
			pstmt.setString(3, pt_bean.getQ_rem2().trim());
			pstmt.setString(4, pt_bean.getQ_rem3().trim());
			pstmt.setString(5, pt_bean.getQ_rem4().trim());
			pstmt.setString(6, pt_bean.getQ_rem5().trim());
			pstmt.setString(7, pt_bean.getQ_rem6().trim());
			pstmt.setString(8, pt_bean.getQ_rem7().trim());
			pstmt.setString(9, pt_bean.getQ_rem8().trim());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:insertPollEtc]\n" + e);
			e.printStackTrace();
			conn.rollback();
		} catch (Exception e) {
			System.out.println("[AdminDatabase:insertPollEtc]\n" + e);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try {
				conn.setAutoCommit(true);
				if (pstmt != null)
					pstmt.close();

			} catch (Exception ignore) {
			}
			closeConnection();
			return flag;
		}
	}

	/* poll count 수정 */

	public boolean updatePollCount(PollBean poll) {
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;

		String query = " update POLL set " + " P_Q1_COUNT = P_Q1_COUNT + ?, " + " P_Q2_COUNT = P_Q2_COUNT + ?, "
				+ " P_Q3_COUNT = P_Q3_COUNT + ?, " + " P_Q4_COUNT = P_Q4_COUNT + ?, " + " P_Q5_COUNT = P_Q5_COUNT + ?, "
				+ " P_Q6_COUNT = P_Q6_COUNT + ?, " + " P_Q7_COUNT = P_Q7_COUNT + ?, " + " P_Q8_COUNT = P_Q8_COUNT + ?, "
				+ " P_Q1_COUNT_U = P_Q1_COUNT_U + ?, " + " P_Q2_COUNT_U = P_Q2_COUNT_U + ?, "
				+ " P_Q3_COUNT_U = P_Q3_COUNT_U + ?, " + " P_Q4_COUNT_U = P_Q4_COUNT_U + ?, "
				+ " P_Q5_COUNT_U = P_Q5_COUNT_U + ?, " + " P_Q6_COUNT_U = P_Q6_COUNT_U + ?, "
				+ " P_Q7_COUNT_U = P_Q7_COUNT_U + ?, " + " P_Q8_COUNT_U = P_Q8_COUNT_U + ? " + " where P_NUM = ? ";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, poll.getP_q1_count());
			pstmt.setInt(2, poll.getP_q2_count());
			pstmt.setInt(3, poll.getP_q3_count());
			pstmt.setInt(4, poll.getP_q4_count());
			pstmt.setInt(5, poll.getP_q5_count());
			pstmt.setInt(6, poll.getP_q6_count());
			pstmt.setInt(7, poll.getP_q7_count());
			pstmt.setInt(8, poll.getP_q8_count());
			pstmt.setInt(9, poll.getP_q1_count_u());
			pstmt.setInt(10, poll.getP_q2_count_u());
			pstmt.setInt(11, poll.getP_q3_count_u());
			pstmt.setInt(12, poll.getP_q4_count_u());
			pstmt.setInt(13, poll.getP_q5_count_u());
			pstmt.setInt(14, poll.getP_q6_count_u());
			pstmt.setInt(15, poll.getP_q7_count_u());
			pstmt.setInt(16, poll.getP_q8_count_u());
			pstmt.setInt(17, poll.getP_num());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:updatePollCount]\n" + e);
			e.printStackTrace();
			flag = false;
			conn.rollback();
		} catch (Exception e) {
			System.out.println("[AdminDatabase:updatePollCount]\n" + e);
			e.printStackTrace();
			flag = false;
			conn.rollback();
		} finally {
			try {
				conn.setAutoCommit(true);
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return flag;
		}
	}

	// 투표 여부
	public int checkPoll_count(String user_id, int p_num) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;

		String query = "select count(*) cnt from  poll_tail where  p_user_id = '" + user_id + "' and p_num =" + p_num;

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (Exception e) {
			System.out.println("[AdminDatabase:checkPoll_count]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return count;
		}
	}

	public PollBean getPollBean(String p_num, String r) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PollBean bean = new PollBean();
		String query = "";

		query = " SELECT P_NUM, P_TITLE, P_QCOUNT, P_Q1, P_Q2, P_Q3, P_Q4, P_Q5, P_Q6, P_Q7, "
				+ " P_Q8, USE_YN, P_Q1_COUNT,  P_Q2_COUNT, P_Q3_COUNT, P_Q4_COUNT, P_Q5_COUNT, P_Q6_COUNT, P_Q7_COUNT, P_Q8_COUNT, "
				+ " P_Q1_COUNT_U, P_Q2_COUNT_U, P_Q3_COUNT_U, P_Q4_COUNT_U, P_Q5_COUNT_U, P_Q6_COUNT_U, P_Q7_COUNT_U, P_Q8_COUNT_U, nvl(EN_DT_YN, 'N') EN_DT_YN "
				+ " FROM POLL where P_NUM =" + Integer.parseInt(p_num);

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				bean.setP_num(rs.getInt("P_NUM"));
				bean.setP_title(rs.getString("P_TITLE"));
				bean.setP_qcount(rs.getInt("P_QCOUNT"));
				bean.setP_q1(rs.getString("P_Q1"));
				bean.setP_q2(rs.getString("P_Q2") == null ? "" : rs.getString("P_Q2"));
				bean.setP_q3(rs.getString("P_Q3") == null ? "" : rs.getString("P_Q3"));
				bean.setP_q4(rs.getString("P_Q4") == null ? "" : rs.getString("P_Q4"));
				bean.setP_q5(rs.getString("P_Q5") == null ? "" : rs.getString("P_Q5"));
				bean.setP_q6(rs.getString("P_Q6") == null ? "" : rs.getString("P_Q6"));
				bean.setP_q7(rs.getString("P_Q7") == null ? "" : rs.getString("P_Q7"));
				bean.setP_q8(rs.getString("P_Q8") == null ? "" : rs.getString("P_Q8"));
				bean.setP_q1_count(rs.getString("P_Q1_COUNT") == null ? 0 : rs.getInt("P_Q1_COUNT"));
				bean.setP_q2_count(rs.getString("P_Q2_COUNT") == null ? 0 : rs.getInt("P_Q2_COUNT"));
				bean.setP_q3_count(rs.getString("P_Q3_COUNT") == null ? 0 : rs.getInt("P_Q3_COUNT"));
				bean.setP_q4_count(rs.getString("P_Q4_COUNT") == null ? 0 : rs.getInt("P_Q4_COUNT"));
				bean.setP_q5_count(rs.getString("P_Q5_COUNT") == null ? 0 : rs.getInt("P_Q5_COUNT"));
				bean.setP_q6_count(rs.getString("P_Q6_COUNT") == null ? 0 : rs.getInt("P_Q6_COUNT"));
				bean.setP_q7_count(rs.getString("P_Q7_COUNT") == null ? 0 : rs.getInt("P_Q7_COUNT"));
				bean.setP_q8_count(rs.getString("P_Q8_COUNT") == null ? 0 : rs.getInt("P_Q8_COUNT"));
				bean.setP_q1_count_u(rs.getString("P_Q1_COUNT_U") == null ? 0 : rs.getInt("P_Q1_COUNT_U"));
				bean.setP_q2_count_u(rs.getString("P_Q2_COUNT_U") == null ? 0 : rs.getInt("P_Q2_COUNT_U"));
				bean.setP_q3_count_u(rs.getString("P_Q3_COUNT_U") == null ? 0 : rs.getInt("P_Q3_COUNT_U"));
				bean.setP_q4_count_u(rs.getString("P_Q4_COUNT_U") == null ? 0 : rs.getInt("P_Q4_COUNT_U"));
				bean.setP_q5_count_u(rs.getString("P_Q5_COUNT_U") == null ? 0 : rs.getInt("P_Q5_COUNT_U"));
				bean.setP_q6_count_u(rs.getString("P_Q6_COUNT_U") == null ? 0 : rs.getInt("P_Q6_COUNT_U"));
				bean.setP_q7_count_u(rs.getString("P_Q7_COUNT_U") == null ? 0 : rs.getInt("P_Q7_COUNT_U"));
				bean.setP_q8_count_u(rs.getString("P_Q8_COUNT_U") == null ? 0 : rs.getInt("P_Q8_COUNT_U"));

				bean.setUse_yn(rs.getString("USE_YN"));
				bean.setEn_dt_yn(rs.getString("EN_DT_YN"));

			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getPollBean]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return bean;
		}
	}

	/**
	 * poll 기타 의견
	 */
	public Vector getPollTailAll(String p_num) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " select nvl(pt.q_rem1, '')  rem  from poll_tail pt, poll p where p.p_num = pt.p_num and p.q1_rem = '1' and pt.p_num = "
				+ Integer.parseInt(p_num) + " union "
				+ " select nvl(pt.q_rem2, '')  rem  from poll_tail pt, poll p where p.p_num = pt.p_num and p.q2_rem = '1' and pt.p_num = "
				+ Integer.parseInt(p_num) + " union "
				+ " select nvl(pt.q_rem3, '')  rem  from poll_tail pt, poll p where p.p_num = pt.p_num and p.q3_rem = '1' and pt.p_num = "
				+ Integer.parseInt(p_num) + " union "
				+ " select nvl(pt.q_rem4, '')  rem  from poll_tail pt, poll p where p.p_num = pt.p_num and p.q4_rem = '1' and pt.p_num = "
				+ Integer.parseInt(p_num) + " union "
				+ " select nvl(pt.q_rem5, '')  rem  from poll_tail pt, poll p where p.p_num = pt.p_num and p.q5_rem = '1' and pt.p_num = "
				+ Integer.parseInt(p_num) + " union "
				+ " select nvl(pt.q_rem6, '')  rem  from poll_tail pt, poll p where p.p_num = pt.p_num and p.q6_rem = '1' and pt.p_num = "
				+ Integer.parseInt(p_num) + " union "
				+ " select nvl(pt.q_rem7, '')  rem  from poll_tail pt, poll p where p.p_num = pt.p_num and p.q7_rem = '1' and pt.p_num = "
				+ Integer.parseInt(p_num) + " union "
				+ " select nvl(pt.q_rem8, '')  rem  from poll_tail pt, poll p where p.p_num = pt.p_num and p.q8_rem = '1' and pt.p_num = "
				+ Integer.parseInt(p_num);

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getPollTailAll]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * poll 기타 의견
	 */
	public Vector getPollEtcAll(String p_num) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " select nvl(pt.q_rem1, '')  rem  from poll_etc pt, poll p where p.p_num = pt.p_num and p.q1_rem = '1' and pt.p_num = "
				+ Integer.parseInt(p_num) + " union "
				+ " select nvl(pt.q_rem2, '')  rem  from poll_etc pt, poll p where p.p_num = pt.p_num and p.q2_rem = '1' and pt.p_num = "
				+ Integer.parseInt(p_num) + " union "
				+ " select nvl(pt.q_rem3, '')  rem  from poll_etc pt, poll p where p.p_num = pt.p_num and p.q3_rem = '1' and pt.p_num = "
				+ Integer.parseInt(p_num) + " union "
				+ " select nvl(pt.q_rem4, '')  rem  from poll_etc pt, poll p where p.p_num = pt.p_num and p.q4_rem = '1' and pt.p_num = "
				+ Integer.parseInt(p_num) + " union "
				+ " select nvl(pt.q_rem5, '')  rem  from poll_etc pt, poll p where p.p_num = pt.p_num and p.q5_rem = '1' and pt.p_num = "
				+ Integer.parseInt(p_num) + " union "
				+ " select nvl(pt.q_rem6, '')  rem  from poll_etc pt, poll p where p.p_num = pt.p_num and p.q6_rem = '1' and pt.p_num = "
				+ Integer.parseInt(p_num) + " union "
				+ " select nvl(pt.q_rem7, '')  rem  from poll_etc pt, poll p where p.p_num = pt.p_num and p.q7_rem = '1' and pt.p_num = "
				+ Integer.parseInt(p_num) + " union "
				+ " select nvl(pt.q_rem8, '')  rem  from poll_etc pt, poll p where p.p_num = pt.p_num and p.q8_rem = '1' and pt.p_num = "
				+ Integer.parseInt(p_num);

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getPollTailAll]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 영업캠페인 지급마감
	 */
	public Vector getStatCampSale(String save_dt) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " select save_dt,  '2' as gubun , bus_id , to_number(amt2) amt from stat_bus_cmp_v19 where save_dt = '"
				+ save_dt + "'";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatCampSale]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 영업캠페인 실적마감
	 */
	public Vector getStatCampSale1(String save_dt) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = " select save_dt,  '2' as gubun , bus_id , c_tot_cnt amt1 from stat_bus_cmp_v19 where save_dt = '"
				+ save_dt + "'";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatCampSale1]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 채권캠페인 지급마감
	 */
	public Vector getStatCampSettle(String save_dt) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select a.save_dt,  '1' as gubun , a.bus_id2 as bus_id , a.amt_out + nvl(a.eff_amt_out,0)  as amt from stat_settle  a, users u   where  a.bus_id2 = u.user_id and u.loan_st in ('1', '2' ) and a.bus_id2 not in ('000003', '000004', '000005', '000006', '000035',  '000144', '000077' ) and a.save_dt = '"
				+ save_dt + "'" + " union all "
				+ " select save_dt,  '1' as gubun , partner_id as bus_id , sum(amt_in + nvl(eff_amt_in, 0) ) as amt from stat_settle  where partner_id is not null and save_dt = '"
				+ save_dt + "' group by save_dt, partner_id ";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatCampSettle]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 채권캠페인 실적마감 - 사장님 조회용 - amt1:평균 amt2 :마감 (1군) , amt1:평균 amt2: 1개월마감 amt3:마감
	 * (2군)
	 */
	public Vector getStatCampSettle1(String save_dt) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select save_dt,  '1' as gubun , bus_id2 as bus_id , to_number(avg_per)  as amt1 , to_number(per1) amt2 , 0 amt3  from stat_settle  where bus_id2 not in ('000003', '000004', '000005', '000006', '000035', '000077', '000144' ) and    bus_id2 not like 'E%'   and save_dt = '"
				+ save_dt + "'" + " union all "
				+ " select save_dt,  '1' as gubun , partner_id as bus_id , to_number(avg_per)  as amt1 , bamt amt2  , aamt amt3 \n"
				+ "	from stat_settle s,  \n"
				+ "   ( select partner_id as bus_id, to_number(nvl(per1,0)) bamt  from stat_settle where partner_id is not null and save_dt = ( select var_sik from esti_sik_var where var_cd = 'dly1_bus13' ) ) b, \n"
				+ "   ( select partner_id as bus_id, to_number(nvl(per1,0)) aamt  from stat_settle where partner_id is not null and save_dt = ( select var_sik from esti_sik_var where var_cd = 'dly1_bus3' ) ) c \n"
				+ " where s.partner_id is not null and s.save_dt = '" + save_dt + "' \n"
				+ "  and s.partner_id = b.bus_id(+)   \n" + "  and s.partner_id = c.bus_id(+)   ";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatCampSettle1]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 비용캠페인 지급마감
	 */
	public Vector getStatCampCost(String save_dt) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select save_dt,  decode(gubun, 'a', '28', '2', '29', '5') as gubun , user_id bus_id , sum(amt) amt  from v_stat_bus_cost_cmp "
				+ " where save_dt =  '" + save_dt
				+ "'   group by save_dt, decode(gubun, 'a', '28', '2', '29', '5'), user_id  ";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatCampCost]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 비용캠페인 지급마감
	 */
	public Vector getStatCampCost(String save_dt, String gubun) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String r_mode = "";

		if (gubun.equals("25")) { // 1군정비
			r_mode = "5";
		} else if (gubun.equals("28")) { // 1군사고
			r_mode = "28";
		} else if (gubun.equals("29")) { // 2군
			r_mode = "29";
		} else if (gubun.equals("30")) { // 1군
			r_mode = "30";
		}

		String query = " select save_dt,  decode(gubun, 'a', '28', '2', '29','n', '30' , '5') as gubun , user_id bus_id , sum(amt) amt  from v_stat_bus_cost_cmp "
				+ " where save_dt =  '" + save_dt + "'  and decode(gubun, 'a', '28', '2', '29', 'n', '30' , '5') =  '"
				+ r_mode + "'   group by save_dt, decode(gubun, 'a', '28', '2', '29', 'n', '30' , '5'), user_id  ";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatCampCost]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 비용캠페인 실적마감
	 */
	public Vector getStatCampCost1(String save_dt) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select save_dt, '5' as gubun , user_id bus_id , sum(amt1) amt1  from v_stat_bus_cost_cmp where save_dt = '"
				+ save_dt + "'  group by save_dt, user_id ";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatCampCost1]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 비용캠페인 실적마감
	 */
	public Vector getStatCampCost1(String save_dt, String gubun) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String r_mode = "";

		if (gubun.equals("25")) { // 1군정비
			r_mode = "5";
		} else if (gubun.equals("28")) { // 1군사고
			r_mode = "28";
		} else if (gubun.equals("29")) { // 2군
			r_mode = "29";
		} else if (gubun.equals("30")) { // 1군
			r_mode = "30";
		}

		String query = " select save_dt,  decode(gubun, 'a', '28', '2', '29', 'n', '30' , '5') as gubun , user_id bus_id , sum(amt1) amt1  from v_stat_bus_cost_cmp "
				+ " where save_dt =  '" + save_dt + "' and decode(gubun, 'a', '28', '2', '29', 'n', '30', '5') =  '"
				+ r_mode + "'   group by save_dt, decode(gubun, 'a', '28', '2', '29', 'n', '30', '5'), user_id  ";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatCampCost1]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 제안캠페인 지급마감
	 */
	public Vector getStatCampProp(String save_dt) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select save_dt,  '6' as gubun , bus_id , pp_amt amt from stat_bus_prop where save_dt = '"
				+ save_dt + "'";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatCampProp]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 제안캠페인 실적마감
	 */
	public Vector getStatCampProp1(String save_dt) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select save_dt,  '6' as gubun , bus_id , r_amt amt1 from stat_bus_prop where save_dt = '"
				+ save_dt + "'";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatCampProp1]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 캠페인지급액 등록
	 */
	public boolean insertStatCmp(StatCmpBean sd) {
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = "insert into stat_cmp values (?, ?, ?, ?, ?, ?, ?, ?, ?, ? , ? , ?, ? ,? )";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, sd.getSave_dt());
			pstmt.setInt(2, sd.getSeq());
			pstmt.setString(3, sd.getC_yy());
			pstmt.setString(4, sd.getC_mm());
			pstmt.setString(5, sd.getGubun());
			pstmt.setString(6, sd.getUser_id());
			pstmt.setInt(7, sd.getAmt());
			pstmt.setFloat(8, sd.getAmt1());
			pstmt.setFloat(9, sd.getAmt2());
			pstmt.setString(10, sd.getS_type());
			pstmt.setFloat(11, sd.getAmt3());
			pstmt.setInt(12, 0); // 정산액 추가 또는 차감
			pstmt.setString(13, ""); // 파일
			pstmt.setString(14, ""); //

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
			System.out.println("[AdminDatabase:insertStatCmp]" + e);
			e.printStackTrace();
			flag = false;
			conn.rollback();
		} finally {
			try {
				conn.setAutoCommit(true);
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return flag;
		}
	}

	/**
	 * 과태료 포함 여부
	 */
	public String getUserDeptNm(String user_id) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String dept_nm = "";
		String query = "";

		query = " select c.nm_cd  as dept_nm  \n"
				+ " from   users u , (select * from code where c_st='0002') c    where  u.user_id = '" + user_id
				+ "' and u.dept_id = c.code ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			if (rs.next()) {
				dept_nm = rs.getString("dept_nm") == null ? "" : rs.getString("dept_nm");
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getUserDeptNm]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return dept_nm;
		}
	}

	/**
	 * 캠페인 지급 현황 - 년도 관련 해서 수정해야 함. 보완할 것 :직급 등 -- 분기별 마감이 끝나지 않았다면 먼저 마감된건 확정으로..
	 * :gubun1:년도
	 */
	public Vector getStatCmpList(String gubun1) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "select u.user_id, u.user_nm, decode(u.loan_st, '1', '4', null, '5', u.loan_st) as loan_st, c.nm, decode(u.user_pos,'대표이사',1,'이사', 2, '부장', 3, '차장', 4, '과장', 5 , '대리', 6, 9) pos_sort, u.enter_dt,  trunc(MONTHS_BETWEEN(SYSDATE, TO_DATE(enter_dt)))  wy, \n"
				+ " 		t.s0, t.d0, t.c0, t.c_1_0 e0, t.c_2_0 f0, 0 g0, t.p0, sum(nvl(s.amt,0)) t_amt, \n"
				+ "	  sum(decode(to_char(s.c_mm) || s.gubun,  '12', nvl(s.amt,0),0)) as s1, \n"
				+ "	  sum(decode(to_char(s.c_mm) || s.gubun,  '11', nvl(s.amt,0),0)) as d1, \n"
				+ "	  sum(decode(to_char(s.c_mm) || s.gubun,  '15', nvl(s.amt,0),0)) as c1, \n"
				+ "	  sum(decode(to_char(s.c_mm) || s.gubun,  '128', nvl(s.amt,0),0)) as e1, \n"
				+ "	  sum(decode(to_char(s.c_mm) || s.gubun,  '129', nvl(s.amt,0),0)) as f1, \n"
				+ "	  sum(decode(to_char(s.c_mm) || s.gubun,  '130', nvl(s.amt,0),0)) as g1, \n"
				+ "	  sum(decode(to_char(s.c_mm) || s.gubun,  '16', nvl(s.amt,0),0)) as p1, \n"
				+ "     sum(decode(to_char(s.c_mm) || s.gubun,  '22', nvl(s.amt,0),0)) as s2, \n"
				+ "     sum(decode(to_char(s.c_mm) || s.gubun,  '21', nvl(s.amt,0),0)) as d2, \n"
				+ "     sum(decode(to_char(s.c_mm) || s.gubun,  '25', nvl(s.amt,0),0)) as c2, \n"
				+ "     sum(decode(to_char(s.c_mm) || s.gubun,  '228', nvl(s.amt,0),0)) as e2, \n"
				+ "     sum(decode(to_char(s.c_mm) || s.gubun,  '229', nvl(s.amt,0),0)) as f2, \n"
				+ "     sum(decode(to_char(s.c_mm) || s.gubun,  '230', nvl(s.amt,0),0)) as g2, \n"
				+ "     sum(decode(to_char(s.c_mm) || s.gubun,  '26', nvl(s.amt,0),0)) as p2, \n"
				+ "     sum(decode(to_char(s.c_mm) || s.gubun,  '32', nvl(s.amt,0),0)) as s3, \n"
				+ "     sum(decode(to_char(s.c_mm) || s.gubun,  '31', nvl(s.amt,0),0)) as d3, \n"
				+ "     sum(decode(to_char(s.c_mm) || s.gubun,  '36', nvl(s.amt,0),0)) as p3, \n"
				+ "     sum(decode(to_char(s.c_mm) || s.gubun,  '35', nvl(s.amt,0),0)) as c3, \n"
				+ "     sum(decode(to_char(s.c_mm) || s.gubun,  '328', nvl(s.amt,0),0)) as e3, \n"
				+ "     sum(decode(to_char(s.c_mm) || s.gubun,  '329', nvl(s.amt,0),0)) as f3, \n"
				+ "     sum(decode(to_char(s.c_mm) || s.gubun,  '330', nvl(s.amt,0),0)) as g3, \n"
				+ "     sum(decode(to_char(s.c_mm) || s.gubun,  '42', nvl(s.amt,0),0)) as s4, \n"
				+ "     sum(decode(to_char(s.c_mm) || s.gubun,  '41', nvl(s.amt,0),0)) as d4, \n"
				+ "     sum(decode(to_char(s.c_mm) || s.gubun,  '45', nvl(s.amt,0),0)) as c4, \n"
				+ "     sum(decode(to_char(s.c_mm) || s.gubun,  '428', nvl(s.amt,0),0)) as e4, \n"
				+ "     sum(decode(to_char(s.c_mm) || s.gubun,  '429', nvl(s.amt,0),0)) as f4, \n"
				+ "     sum(decode(to_char(s.c_mm) || s.gubun,  '430', nvl(s.amt,0),0)) as g4, \n"
				+ "     sum(decode(to_char(s.c_mm) || s.gubun,  '46', nvl(s.amt,0),0)) as p4 \n"
				+ "			from stat_cmp s, users u, code c,  \n"
				+ "			(select user_id,  sum(decode(gubun , '2', amt , 0)) s0, sum(decode(gubun , '1', amt , 0))  d0 , sum(decode(gubun , '3', amt , 0))  c0, 0  c_1_0, sum(decode(gubun , '3_2', amt , 0))  c_2_0,  sum(decode(gubun , '4', amt , 0))  p0 from (  \n"
				+ "				select a.save_dt, '2'  as gubun, a.bus_id as user_id, to_number(a.amt2) as amt  from stat_bus_cmp_v19 a, ( select max(save_dt) max_dt from  stat_bus_cmp_v19  ) b where a.save_dt = max_dt    \n"
				+ "	             		 union all  \n"
				+ "	                               select a.save_dt, '3'  as gubun, a.user_id, sum(a.amt) amt  from v_stat_bus_cost_cmp a, ( select max(save_dt) max_dt from  v_stat_bus_cost_cmp where gubun in ( 'j', '3' , 'n') ) b  where a.save_dt = max_dt  and  gubun in ( 'j', '3' , 'n')  group by a.save_dt, a.user_id   \n"
				+ "	                            union all  \n"
				+ "	                                  select a.save_dt, '3_2'  as gubun, a.user_id, sum(a.amt) amt  from v_stat_bus_cost_cmp a, ( select max(save_dt) max_dt from  v_stat_bus_cost_cmp where  gubun = '2' ) b  where a.save_dt = max_dt and gubun = '2'  group by a.save_dt, a.user_id  \n"
				+ "	                            union all       \n"
				+ "				select a.save_dt, '4'  as gubun, a.bus_id as user_id, a.pp_amt as amt  from stat_bus_prop a, ( select max(save_dt) max_dt from  stat_bus_prop  ) b where a.save_dt = max_dt    \n"
				+ "				union all  \n"
				+ "				select a.save_dt,  '1' as gubun , a.bus_id2 as user_id, a.amt_out + nvl(a.eff_amt_out, 0) as amt  from stat_settle a, ( select max(save_dt) max_dt from  stat_settle ) b where a.save_dt = max_dt    \n"
				+ "				union all  \n"
				+ " 				select a.save_dt,  '1' as gubun , a.partner_id as user_id , sum(a.amt_in + nvl(a.eff_amt_in,0) ) as amt  from stat_settle  a, ( select max(save_dt) max_dt from  stat_settle  ) b where a.save_dt = max_dt   and  a.partner_id  is not null  \n"
				+ " 					group by a.save_dt, a.partner_id ) a  \n"
				+ "			group by  user_id     ) t  \n" + "	where s.c_yy = '" + gubun1
				+ "' and s.user_id = t.user_id(+) and s.s_type = '1' and u.user_id = s.user_id(+) and c.c_st = '0002' and u.dept_id = c.code and  u.use_yn = 'Y' and u.dept_id not in ('8888', '0004',  '1000')  and  u.user_pos not in ('이사',  '팀장' )  and s.gubun not in  ( '8' )  \n"
				+ "	and t.user_id not in ( '000177' ) and u.user_id not in ( '1000', '8888' ) \n"
				+ "	group by u.user_id, u.user_nm, u.loan_st, c.nm, decode(u.user_pos,'대표이사',1,'이사', 2, '부장', 3, '차장', 4,  '과장', 5 , '대리', 6, 9), u.enter_dt, t.s0, t.d0 , t.c0 , t.c_1_0 ,t.c_2_0 ,t.p0 \n"
				+ "	order by 3,15 desc, 5, 6   \n";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);
			
		//	System.out.println("query=" +query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatCmpList]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 캠페인 지급 현황 - 년도 관련 해서 수정해야 함. 보완할 것 :직급 등
	 */
	public float getStatCmpTotAmt(String gubun1) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		float tamt = 0;

		query = "select nvl(sum(a.amt2), 0)  as tamt "
				+ "  from stat_bus_cmp a, ( select max(save_dt) max_dt from  stat_bus_cmp where save_dt like '" + gubun1 + "%' ) b where a.save_dt = max_dt";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				tamt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (Exception e) {
			System.out.println("[AdminDatabase:getStatCmpTotAmt]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return tamt;
		}
	}

	/**
	 * 캠페인 지급 현황 - 년도 관련 해서 수정해야 함. 보완할 것 :직급 등
	 */
	public float getStatCmpTotAmt(String gubun1, String loan_st) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		float tamt = 0;

		query = "select nvl(sum(a.amt2), 0)  as tamt "
				+ "  from stat_bus_cmp a, users u, ( select max(save_dt) max_dt from  stat_bus_cmp where save_dt like '" + gubun1 + "%' ) b "
				+ "  where a.save_dt = b.max_dt and a.bus_id = u.user_id and u.loan_st = '" + loan_st + "'";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				tamt = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

		} catch (Exception e) {
			System.out.println("[AdminDatabase:getStatCmpTotAmt]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return tamt;
		}
	}

	/**
	 * 자동차주행거리 관련 조회
	 */

	public Vector getServAllNew(String gubun, String gubun_nm, String sort, String car_ck) {
		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String subQuery = "";
		Vector vt = new Vector();

		if (gubun.equals("car_no")) {
			subQuery = "and b.car_no like '%" + gubun_nm + "%'\n";
		} else if (gubun.equals("firm_nm")) {
			if (car_ck.equals("1")) {
				subQuery = "and c.firm_nm like '%" + gubun_nm + "%' and rr.user_nm is not null \n";
			} else {
				subQuery = "and c.firm_nm like '%" + gubun_nm + "%' \n";
			}
		} else if (gubun.equals("client_nm")) {
			subQuery = "and c.client_nm like '%" + gubun_nm + "%'\n";
		} else if (gubun.equals("car_nm")) {
			subQuery = "and b.car_nm||h.car_name like '%" + gubun_nm + "%'\n";
		} else if (gubun.equals("jg_code")) {
			subQuery = "and h.jg_code like '%" + gubun_nm + "%'\n";
		} else {

		}

		query = "  select  \n"
				+ "        to_number(case when a.ddtt > 7 and a.tot_dist > 0 then a.tot_dist/a.ddtt * 30*12   else a.tot_dist/7 * 30*12 end) ss, \n"// 7이하는
																																					// 7로
																																					// 나눔,
																																					// 연평균주행거리
				+ "	       nvl(a.tot_dist,0) tot_dist, a.init_reg_dt, a.*    \n" + " from ( \n"
				+ "        select a.rent_mng_id as RENT_MNG_ID, a.rent_l_cd as RENT_L_CD, \n"
				+ "	              b.car_mng_id as CAR_MNG_ID, b.car_no as CAR_NO, \n"
				+ "               rr.user_nm as USER_NM, rr.work_dt as WORK_DT, rr.sr as SR,  \n"
				+ "	              substr(a.rent_dt,1,4)||'-'||substr(a.rent_dt,5,2)||'-'||substr(a.rent_dt,7,2) as RENT_DT, \n"
				+ "	              decode(b.init_reg_dt,'','',substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2)) as INIT_REG_DT, \n"
				+ "	              decode(f.rent_start_dt,'','',substr(f.rent_start_dt,1,4)||'-'||substr(f.rent_start_dt,5,2)||'-'||substr(f.rent_start_dt,7,2)) as RENT_START_DT, \n"
				+ "	              cm.user_nm as mng_user_nm, \n" + "	              c.client_nm, \n"
				+ "               c.firm_nm as FIRM_NM, j.car_nm || h.car_name as CAR_NM,  \n"
				+ "               vt.tot_dt as SERV_DT, vt.tot_dist as TOT_DIST, to_date(vt.tot_dt,'YYYYMMDD')-to_date(b.init_reg_dt,'YYYYMMDD') as DDTT, \n"
				+ "               decode(sign(to_number(to_date(nvl(vt.tot_dt,b.init_reg_dt),'YYYYMMDD')-to_date(b.init_reg_dt))-15),-1,1,0) reg_15_st \n"
				+ "	       from   cont a, car_reg b, client c, v_tot_dist vt, \n"
				+ "	              car_etc g, car_nm h, car_mng j, users cm, \n"
				+ "               ( select rent_mng_id, rent_l_cd, max(rent_start_dt) as rent_start_dt FROM fee group by rent_mng_id, rent_l_cd ) f, \n"
				+ "               ( select 'Y' as SR, a.car_mng_id , a.cust_id, u.user_nm, a.rent_dt as work_dt \n"
				+ "                 from   rent_cont a , users u \n"
				+ "                 where  a.cust_id = u.user_id and a.rent_st in ('4','5') and a.use_st='2' \n"
				+ "               ) rr \n" + "	       where  \n" + "                   nvl(a.use_yn, 'Y')= 'Y' \n"
				+ "	              and nvl(b.prepare,'1')<>'4'  \n" // 도난차량 제외
				+ "               and a.car_mng_id=b.car_mng_id \n" + "	              and a.client_id=c.client_id \n"
				+ "               and a.car_mng_id=vt.car_mng_id(+) \n"
				+ "               and a.rent_mng_id = g.rent_mng_id and a.rent_l_cd = g.rent_l_cd \n"
				+ "               and g.car_id = h.car_id and g.car_seq= h.car_seq and h.car_comp_id=j.car_comp_id and h.car_cd=j.code \n"
				+ "               and nvl(a.mng_id,a.bus_id2)=cm.user_id \n"
				+ "	              and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd  \n"
				+ "               and b.car_mng_id=rr.car_mng_id(+)\n" + subQuery + " \n" + " ) a \n";

		if (sort.equals("1")) {
			query += "order by  a.reg_15_st, 2 desc, 3 asc, a.rent_start_dt \n";
		} else if (sort.equals("2")) {
			query += "order by  a.reg_15_st, 1 desc, 2 desc, 3 asc, a.rent_start_dt \n";
		} else if (sort.equals("3")) {
			query += "order by  a.reg_15_st, 3 asc, a.rent_start_dt \n";
		}

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getServAllNew]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 자동차주행거리 관련 조회
	 */

	/**
	 * 채권캠페인지급액 등록
	 */
	public boolean updateStatSettleAmt(String save_dt, String bus_id2, String partner_id, int amt_out, int amt_in) {
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = "update stat_settle set partner_id=?, amt_out=?, amt_in=? where save_dt=? and bus_id2=?";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, partner_id);
			pstmt.setInt(2, amt_out);
			pstmt.setInt(3, amt_in);
			pstmt.setString(4, save_dt);
			pstmt.setString(5, bus_id2);

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
			System.out.println("[AdminDatabase:updateStatSettleAmt]" + e);
			e.printStackTrace();
			flag = false;
			conn.rollback();
		} finally {
			try {
				conn.setAutoCommit(true);
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return flag;
		}
	}

	/**
	 * 사용본거지 일괄변경시 전국번호 리스트 조회
	 */
	public Vector getCarExtCngExcelList(String car_ext) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select distinct" + " b.car_mng_id, b.car_doc_no, b.car_no, b.car_nm, b.init_reg_dt, a.rent_end_dt"
				+ " from cont a, car_reg b, car_change c, sui d" + " where a.car_mng_id=b.car_mng_id"
				+ " and nvl(a.use_yn,'Y')='Y' and nvl(b.off_ls,'0')='0'"
				+ " and b.car_no=c.CAR_NO and b.init_reg_dt=c.cha_dt"
				+ " and a.car_mng_id=d.car_mng_id(+) and d.cont_dt is null" + " and b.car_use='1'" + " ";

		if (car_ext.equals("1")) {
			query += " and b.car_ext='1' and b.car_no not like '%서울%'";
		} else if (car_ext.equals("2")) {
			query += " and b.car_ext='2' and b.car_no not like '%경기%'";
		} else if (car_ext.equals("3")) {
			query += " and b.car_ext='3' and b.car_no not like '%부산%'";
		} else if (car_ext.equals("4")) {
			query += " and b.car_ext='4' and b.car_no not like '%경남%'";
		} else if (car_ext.equals("5")) {
			query += " and b.car_ext='5' and b.car_no not like '%대전%'";
		} else if (car_ext.equals("6")) {
			query += " and b.car_ext='6' and b.car_no not like '%경기%'";
		} else if (car_ext.equals("7")) {
			query += " and b.car_ext='7' and b.car_no not like '%인천%'";
		} else if (car_ext.equals("8")) {
			query += " and b.car_ext='8' and b.car_no not like '%제주%'";
		} else if (car_ext.equals("9")) {
			query += " and b.car_ext='9' and b.car_no not like '%광주%'";
		} else if (car_ext.equals("10")) {
			query += " and b.car_ext='10' and b.car_no not like '%대구%'";
		}

		query += " order by b.init_reg_dt, b.car_doc_no";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getCarExtCngExcelList]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 사용본거지 일괄변경시 전국번호 리스트 조회
	 */
	public Vector getCarExtCngExcelList3(String car_ext) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select distinct" + " b.car_mng_id, b.car_doc_no, b.car_no, b.car_nm, b.init_reg_dt, a.rent_end_dt"
				+ " from cont a, car_reg b, sui d" + " where a.car_mng_id=b.car_mng_id"
				+ " and nvl(a.use_yn,'Y')='Y' and nvl(b.off_ls,'0')='0'"
				+ " and a.car_mng_id=d.car_mng_id(+) and d.cont_dt is null" + " and b.car_use='1'" + " ";

		if (car_ext.equals("1")) {
			query += " and b.car_ext='1' and b.car_no not like '%서울%'";
		} else if (car_ext.equals("2")) {
			query += " and b.car_ext='2' and b.car_no not like '%경기%'";
		} else if (car_ext.equals("3")) {
			query += " and b.car_ext='3' and b.car_no not like '%부산%'";
		} else if (car_ext.equals("4")) {
			query += " and b.car_ext='4' and b.car_no not like '%경남%'";
		} else if (car_ext.equals("5")) {
			query += " and b.car_ext='5' and b.car_no not like '%대전%'";
		} else if (car_ext.equals("6")) {
			query += " and b.car_ext='6' and b.car_no not like '%경기%'";
		} else if (car_ext.equals("7")) {
			query += " and b.car_ext='7' and b.car_no not like '%인천%'";
		} else if (car_ext.equals("8")) {
			query += " and b.car_ext='8' and b.car_no not like '%제주%'";
		} else if (car_ext.equals("9")) {
			query += " and b.car_ext='9' and b.car_no not like '%광주%'";
		} else if (car_ext.equals("10")) {
			query += " and b.car_ext='10' and b.car_no not like '%대구%'";
		}

		query += " order by b.init_reg_dt, b.car_doc_no";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getCarExtCngExcelList3]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 사용본거지 일괄변경시 전국번호 리스트 조회
	 */
	public Vector getCarExtCngExcelList2(String car_ext) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select distinct" + " b.car_mng_id, b.car_doc_no, b.car_no, b.car_nm, b.init_reg_dt, a.rent_end_dt"
				+ " from cont a, car_reg b, sui d" + " where a.car_mng_id=b.car_mng_id"
				+ " and nvl(a.use_yn,'Y')='Y' and nvl(b.off_ls,'0')='0'"
				+ " and a.car_mng_id=d.car_mng_id(+) and d.cont_dt is null" + " and b.car_use='1'" + " ";

		if (car_ext.equals("1")) {
			query += " and b.car_ext='1' and b.car_no like '%서울%'";
		} else if (car_ext.equals("2")) {
			query += " and b.car_ext='2' and b.car_no like '%경기%'";
		} else if (car_ext.equals("3")) {
			query += " and b.car_ext='3' and b.car_no like '%부산%'";
		} else if (car_ext.equals("4")) {
			query += " and b.car_ext='4' and b.car_no like '%경남%'";
		} else if (car_ext.equals("5")) {
			query += " and b.car_ext='5' and b.car_no like '%대전%'";
		} else if (car_ext.equals("6")) {
			query += " and b.car_ext='6' and b.car_no like '%경기%'";
		} else if (car_ext.equals("7")) {
			query += " and b.car_ext='7' and b.car_no like '%인천%'";
		} else if (car_ext.equals("8")) {
			query += " and b.car_ext='8' and b.car_no like '%제주%'";
		} else if (car_ext.equals("9")) {
			query += " and b.car_ext='9' and b.car_no not like '%광주%'";
		} else if (car_ext.equals("10")) {
			query += " and b.car_ext='10' and b.car_no not like '%대구%'";
		}

		query += " order by b.init_reg_dt, b.car_doc_no";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getCarExtCngExcelList2]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 사용본거지 일괄변경시 리스트 조회
	 */
	public Vector getCarExtCngExcelList5(String car_ext) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select distinct \n"
				+ " 		 b.car_mng_id, b.car_doc_no, b.car_no, b.car_nm, e.car_name, b.init_reg_dt, \n"
				+ "        decode(a.car_st,'2','',a.rent_start_dt) rent_start_dt, decode(a.car_st,'2','',a.rent_end_dt) rent_end_dt, g.firm_nm, \n"
				+ " 		 j.nm as car_kd, \n" + " 		 h.nm as car_ext, \n" + " 		 i.nm as fuel_kd, \n"
				+ "        b.dpm, c.colo, b.car_y_form, f.nm \n"
				+ " from   cont a, car_reg b, sui d, car_etc c, car_nm e, client g , \n"
				+ "        (select * from code where c_st='0001') f, \n"
				+ "        (select * from code where c_st='0032') h, \n"
				+ "        (select * from code where c_st='0039') i, \n"
				+ "        (select * from code where c_st='0041') j  \n" + " where  a.car_mng_id=b.car_mng_id \n"
				+ " 		 and nvl(a.use_yn,'Y')='Y' and nvl(b.off_ls,'0')='0' \n"
				+ " 		 and a.car_mng_id=d.car_mng_id(+) and d.cont_dt is null \n"
				+ " 		 and b.car_use='1' \n"
				+ " 		 and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"
				+ " 		 and c.car_id=e.car_id and c.car_seq=e.car_seq \n" + " 		 and e.car_comp_id=f.code \n"
				+ " 		 and b.car_ext  =h.nm_cd \n" + "        and a.client_id=g.client_id \n"
				+ " 		 and b.fuel_kd  =i.nm_cd \n" + " 		 and b.car_kd   =j.nm_cd \n" + " ";

		if (car_ext.equals("1")) {
			query += " and b.car_ext='1'";
		} else if (car_ext.equals("2")) {
			query += " and b.car_ext='2'";
		} else if (car_ext.equals("3")) {
			query += " and b.car_ext='3'";
		} else if (car_ext.equals("4")) {
			query += " and b.car_ext='4'";
		} else if (car_ext.equals("5")) {
			query += " and b.car_ext='5'";
		} else if (car_ext.equals("6")) {
			query += " and b.car_ext='6'";
		} else if (car_ext.equals("7")) {
			query += " and b.car_ext='7'";
		} else if (car_ext.equals("8")) {
			query += " and b.car_ext='8'";
		} else if (car_ext.equals("9")) {
			query += " and b.car_ext='9' ";
		} else if (car_ext.equals("10")) {
			query += " and b.car_ext='10' ";
		}

		query += " order by b.init_reg_dt, b.car_no, b.car_doc_no";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getCarExtCngExcelList5]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 사용본거지 일괄변경시 리스트 조회
	 */
	public Vector getCarExtCngExcelList5(String car_ext, String st_dt, String end_dt, String s_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select distinct \n"
				+ " 		 b.car_mng_id, b.car_doc_no, b.car_no, b.car_nm, e.car_name, b.init_reg_dt, \n"
				+ "        decode(a.car_st,'2','',a.rent_start_dt) rent_start_dt, decode(a.car_st,'2','',a.rent_end_dt) rent_end_dt, g.firm_nm, \n"
				+ " 		 j.nm as car_kd, \n" + " 		 h.nm as car_ext, \n" + " 		 i.nm as fuel_kd, \n"
				+ "        b.dpm, c.colo, b.car_y_form, f.nm \n"
				+ " from   cont a, car_reg b, sui d, car_etc c, car_nm e, client g , \n"
				+ "        (select * from code where c_st='0001') f, \n"
				+ "        (select * from code where c_st='0032') h, \n"
				+ "        (select * from code where c_st='0039') i, \n"
				+ "        (select * from code where c_st='0041') j \n" + " where  a.car_mng_id=b.car_mng_id \n"
				+ " 		 and nvl(a.use_yn,'Y')='Y' and nvl(b.off_ls,'0')='0' \n"
				+ " 		 and a.car_mng_id=d.car_mng_id(+) and d.cont_dt is null \n"
				+ " 		 and b.car_use='1' \n"
				+ " 		 and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"
				+ " 		 and c.car_id=e.car_id and c.car_seq=e.car_seq \n" + " 		 and e.car_comp_id=f.code \n"
				+ " 		 and b.car_ext=h.nm_cd \n" + "        and a.client_id=g.client_id \n"
				+ " 		 and b.fuel_kd=i.nm_cd \n" + " 		 and b.car_kd=j.nm_cd \n" + " ";

		if (car_ext.equals("1")) {
			query += " and b.car_ext='1'";
		} else if (car_ext.equals("2")) {
			query += " and b.car_ext='2'";
		} else if (car_ext.equals("3")) {
			query += " and b.car_ext='3'";
		} else if (car_ext.equals("4")) {
			query += " and b.car_ext='4'";
		} else if (car_ext.equals("5")) {
			query += " and b.car_ext='5'";
		} else if (car_ext.equals("6")) {
			query += " and b.car_ext='6'";
		} else if (car_ext.equals("7")) {
			query += " and b.car_ext='7'";
		} else if (car_ext.equals("8")) {
			query += " and b.car_ext='8'";
		} else if (car_ext.equals("9")) {
			query += " and b.car_ext='9' ";
		} else if (car_ext.equals("10")) {
			query += " and b.car_ext='10' ";
		}

		if (!st_dt.equals("") && end_dt.equals(""))
			query += " and " + s_dt + " like replace('" + st_dt + "%', '-','')";
		if (!st_dt.equals("") && !end_dt.equals(""))
			query += " and " + s_dt + " between replace('" + st_dt + "', '-','') and replace('" + end_dt + "', '-','')";

		query += " order by b.init_reg_dt, b.car_no, b.car_doc_no";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getCarExtCngExcelList5]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 사용본거지 일괄변경시 리스트 조회
	 */
	public Vector getCarExtCngExcelList5(String car_ext, String car_use, String st_dt, String end_dt, String s_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select distinct \n"
				+ "        b.car_mng_id, b.car_doc_no, b.car_no, b.car_nm, e.car_name, b.init_reg_dt, b.car_end_dt, \n"
				+ "        decode(a.car_st,'2','',a.rent_start_dt) rent_start_dt, decode(a.car_st,'2','',a.rent_end_dt) rent_end_dt, g.firm_nm, \n"
				+ "        j.nm as car_kd, \n" + "        h.nm as car_ext, \n" + "        i.nm as fuel_kd, \n"
				+ "        b.dpm, c.colo, b.car_y_form, f.nm, b.car_use, b.off_ls, g.o_addr as addr, nvl(nvl(nvl(g.o_tel,g.h_tel),g.m_tel),g.con_agnt_o_tel) tel \n"
				+ " from   cont a, car_reg b, sui d, car_etc c, car_nm e, client g, \n"
				+ "        (select * from code where c_st='0001') f, \n"
				+ "        (select * from code where c_st='0032') h, \n"
				+ "        (select * from code where c_st='0039') i, \n"
				+ "        (select * from code where c_st='0041') j  \n" + " where  a.car_mng_id=b.car_mng_id \n"
				+ "        and nvl(a.use_yn,'Y')='Y' and nvl(b.off_ls,'0')='0' \n"
				+ "        and a.car_mng_id=d.car_mng_id(+) and d.cont_dt is null \n"
				+ "        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"
				+ "        and c.car_id=e.car_id and c.car_seq=e.car_seq \n" + "        and e.car_comp_id=f.code \n"
				+ "        and b.car_ext=h.nm_cd \n" + "        and a.client_id=g.client_id \n"
				+ "        and b.fuel_kd<>'4' \n" + // 경유차량 제외
				"        and b.fuel_kd=i.nm_cd \n" + "        and b.car_kd=j.nm_cd \n" + " ";

		if (car_use.equals("1")) {
			query += " and b.car_use='1'";
		} else if (car_use.equals("2")) {
			query += " and b.car_use='2'";
		}

		if (car_ext.equals("1")) {
			query += " and b.car_ext='1'";
		} else if (car_ext.equals("2")) {
			query += " and b.car_ext='2'";
		} else if (car_ext.equals("3")) {
			query += " and b.car_ext='3'";
		} else if (car_ext.equals("4")) {
			query += " and b.car_ext='4'";
		} else if (car_ext.equals("5")) {
			query += " and b.car_ext='5'";
		} else if (car_ext.equals("6")) {
			query += " and b.car_ext='6'";
		} else if (car_ext.equals("7")) {
			query += " and b.car_ext='7'";
		} else if (car_ext.equals("8")) {
			query += " and b.car_ext='8'";
		} else if (car_ext.equals("9")) {
			query += " and b.car_ext='9'";
		} else if (car_ext.equals("10")) {
			query += " and b.car_ext='10'";
		}

		if (!st_dt.equals("") && end_dt.equals(""))
			query += " and " + s_dt + " like replace('" + st_dt + "%', '-','')";
		if (!st_dt.equals("") && !end_dt.equals(""))
			query += " and " + s_dt + " between replace('" + st_dt + "', '-','') and replace('" + end_dt + "', '-','')";

		query += " order by b.init_reg_dt, b.car_no, b.car_doc_no";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getCarExtCngExcelList5]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 사용본거지 일괄변경시 리스트 조회 -- 연료 추가 (경유차량)
	 */
	public Vector getCarExtCngExcelList5(String car_ext, String car_use, String st_dt, String end_dt, String s_dt,
			String car_fuel) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select distinct \n"
				+ " 		 b.car_mng_id, b.car_doc_no, b.car_no, b.car_nm, e.car_name, b.init_reg_dt, b.car_end_dt, \n"
				+ "        decode(a.car_st,'2','',a.rent_start_dt) rent_start_dt, decode(a.car_st,'2','',a.rent_end_dt) rent_end_dt, g.firm_nm, \n"
				+ " 		 j.nm as car_kd, \n" + " 		 h.nm as car_ext, \n" + " 		 i.nm as fuel_kd, \n"
				+ "        b.dpm, c.colo, b.car_y_form, f.nm, b.car_use, b.off_ls, g.o_addr as addr, nvl(nvl(nvl(g.o_tel,g.h_tel),g.m_tel),g.con_agnt_o_tel) tel \n"
				+ " from   cont a, car_reg b, sui d, car_etc c, car_nm e, client g, \n"
				+ "        (select * from code where c_st='0001') f, \n"
				+ "        (select * from code where c_st='0032') h, \n"
				+ "        (select * from code where c_st='0039') i, \n"
				+ "        (select * from code where c_st='0041') j  \n" + " where  a.car_mng_id=b.car_mng_id \n"
				+ " 		 and nvl(a.use_yn,'Y')='Y' and nvl(b.off_ls,'0')='0' \n"
				+ " 		 and a.car_mng_id=d.car_mng_id(+) and d.cont_dt is null \n"
				+ " 		 and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"
				+ " 		 and c.car_id=e.car_id and c.car_seq=e.car_seq \n" + " 		 and e.car_comp_id=f.code \n"
				+ " 		 and b.car_ext=h.nm_cd \n" + "        and a.client_id=g.client_id \n"
				+ " 		 and b.fuel_kd=i.nm_cd \n" + " 		 and b.car_kd=j.nm_cd \n" + " ";

		if (car_use.equals("1")) {
			query += " and b.car_use='1'";
		} else if (car_use.equals("2")) {
			query += " and b.car_use='2'";
		}

		if (car_fuel.equals("1")) { // 경유차량 제외
			query += " and b.fuel_kd<>'4' ";
		} else if (car_fuel.equals("3")) { // 경유차량만
			query += " and b.fuel_kd = '4' ";
		}

		if (car_ext.equals("1")) {
			query += " and b.car_ext='1'";
		} else if (car_ext.equals("2")) {
			query += " and b.car_ext='2'";
		} else if (car_ext.equals("3")) {
			query += " and b.car_ext='3'";
		} else if (car_ext.equals("4")) {
			query += " and b.car_ext='4'";
		} else if (car_ext.equals("5")) {
			query += " and b.car_ext='5'";
		} else if (car_ext.equals("6")) {
			query += " and b.car_ext='6'";
		} else if (car_ext.equals("7")) {
			query += " and b.car_ext='7'";
		} else if (car_ext.equals("8")) {
			query += " and b.car_ext='8'";
		} else if (car_ext.equals("9")) {
			query += " and b.car_ext='9'";
		} else if (car_ext.equals("10")) {
			query += " and b.car_ext='10'";
		}

		if (!st_dt.equals("") && end_dt.equals(""))
			query += " and " + s_dt + " like replace('" + st_dt + "%', '-','')";
		if (!st_dt.equals("") && !end_dt.equals(""))
			query += " and " + s_dt + " between replace('" + st_dt + "', '-','') and replace('" + end_dt + "', '-','')";

		query += " order by b.init_reg_dt, b.car_no, b.car_doc_no";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getCarExtCngExcelList5]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 사용본거지 일괄변경시 리스트 조회
	 */
	public Vector getCarExtCngExcelList6(String car_ext, String car_use) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select distinct" + " b.car_mng_id, b.car_doc_no, b.car_no, b.car_nm, b.init_reg_dt, a.rent_end_dt"
				+ " from cont a, car_reg b, sui d" + " where a.car_mng_id=b.car_mng_id"
				+ " and nvl(a.use_yn,'Y')='Y' and nvl(b.prepare,'0') not in ('4','5')"
				+ " and a.car_mng_id=d.car_mng_id(+) " + " and nvl(b.off_ls,'0') in ('0','1') "
				+ " and b.car_no <> '22부4368'" + " ";

		if (car_use.equals("1")) {
			query += " and b.car_use='1'";
		} else if (car_use.equals("2")) {
			query += " and b.car_use='2'";
		}

		if (car_ext.equals("1")) {
			query += " and b.car_ext='1'";
		} else if (car_ext.equals("2")) {
			query += " and b.car_ext='2'";
		} else if (car_ext.equals("3")) {
			query += " and b.car_ext='3'";
		} else if (car_ext.equals("4")) {
			query += " and b.car_ext='4'";
		} else if (car_ext.equals("5")) {
			query += " and b.car_ext='5'";
		} else if (car_ext.equals("6")) {
			query += " and b.car_ext='6'";
		} else if (car_ext.equals("7")) {
			query += " and b.car_ext='7'";
		} else if (car_ext.equals("8")) {
			query += " and b.car_ext='8'";
		} else if (car_ext.equals("9")) {
			query += " and b.car_ext='9'";
		} else if (car_ext.equals("10")) {
			query += " and b.car_ext='10'";
		}

		query += " order by b.init_reg_dt, b.car_doc_no";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getCarExtCngExcelList6]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 사용본거지 일괄변경시 리스트 조회 - 오프리스차량
	 */
	public Vector getCarExtCngExcelList7(String car_ext) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select distinct"
				+ " b.car_mng_id, b.car_doc_no, b.car_no, b.car_nm, b.init_reg_dt, d.cont_dt, a.rent_end_dt, "
				+ " h.nm car_ext, "
				+ " decode(b.car_ext, '1','1', '2','2', '6','3', '7','4', '3','5', '4','6', '5','7', '8','8', '9','9', '10','10') car_ext2,"
				+ " decode(b.off_ls,'1','매각결정','2','소매','3','경매장','4','수의','5','경매처분현황','6','사후관리') off_ls"
				+ " from cont a, car_reg b, sui d , (select * from code where c_st='0032' and code <> '0000'  ) h \n"
				+ " where a.car_mng_id=b.car_mng_id"
				+ " and nvl(a.use_yn,'Y')='Y' and nvl(b.prepare,'0') not in ('4','5')"
				+ " and a.car_mng_id=d.car_mng_id(+) " + " and b.car_ext=h.nm_cd(+) \n"
				+ " and nvl(b.off_ls,'0') not in ('0','1') " + " ";

		query += " order by h.app_st, b.init_reg_dt, b.car_doc_no";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getCarExtCngExcelList7]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 사용본거지 일괄변경시 리스트 조회
	 */
	public Vector getCarExtCngExcelList8(String car_ext, String car_use) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select distinct" + " b.car_mng_id, b.car_doc_no, b.car_no, b.car_nm, b.init_reg_dt, a.rent_end_dt"
				+ " from cont a, car_reg b, sui d" + " where a.car_mng_id=b.car_mng_id"
				+ " and nvl(a.use_yn,'Y')='Y' and nvl(b.prepare,'0') not in ('4','5')"
				+ " and a.car_mng_id=d.car_mng_id(+) " + " and nvl(b.off_ls,'0') in ('0','1') "
				+ " and b.car_no <> '22부4368'" + " and d.cont_dt is null" + " and b.fuel_kd='4' " + " ";

		if (car_use.equals("1")) {
			query += " and b.car_use='1'";
		} else if (car_use.equals("2")) {
			query += " and b.car_use='2'";
		}

		if (car_ext.equals("1")) {
			query += " and b.car_ext='1' and b.car_no not like '%서울%'";
		} else if (car_ext.equals("2")) {
			query += " and b.car_ext='2' and b.car_no not like '%경기%'";
		} else if (car_ext.equals("3")) {
			query += " and b.car_ext='3' and b.car_no not like '%부산%'";
		} else if (car_ext.equals("4")) {
			query += " and b.car_ext='4' and b.car_no not like '%경남%'";
		} else if (car_ext.equals("5")) {
			query += " and b.car_ext='5' and b.car_no not like '%대전%'";
		} else if (car_ext.equals("6")) {
			query += " and b.car_ext='6' and b.car_no not like '%경기%'";
		} else if (car_ext.equals("7")) {
			query += " and b.car_ext='7' and b.car_no not like '%인천%'";
		} else if (car_ext.equals("8")) {
			query += " and b.car_ext='8' and b.car_no not like '%제주%'";
		} else if (car_ext.equals("9")) {
			query += " and b.car_ext='9' and b.car_no not like '%광주%'";
		} else if (car_ext.equals("10")) {
			query += " and b.car_ext='10' and b.car_no not like '%대구%'";
		}

		query += " order by b.init_reg_dt, b.car_doc_no";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getCarExtCngExcelList8]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	// 제조사별 자동차 현황
	// 20050905-------------------------------------------------------------------------------------------------------------

	/**
	 * 자동차 현황 (제조사별 전체) 20050905
	 */
	public Hashtable getStatMakerCarAll2(String gubun2, String gubun3, String gubun4, String st_dt, String end_dt) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		String when_dt = "C.init_reg_dt";

		if (gubun4.equals("2"))
			when_dt = "t.rent_dt";
		if (gubun4.equals("3"))
			when_dt = "t.dlv_dt";

		query = "select "
				+ "   sum(decode(n.car_comp_id,'0001',1,0)) h, to_char(sum(decode(n.car_comp_id,'0001',1,0))*100/count(*),'90.99') hp, \n"
				+ " 	sum(decode(n.car_comp_id,'0002',1,0)) k, to_char(sum(decode(n.car_comp_id,'0002',1,0))*100/count(*),'90.99') kp, \n"
				+ " 	sum(decode(n.car_comp_id,'0003',1,0)) r, to_char(sum(decode(n.car_comp_id,'0003',1,0))*100/count(*),'90.99') rp, \n"
				+ " 	sum(decode(n.car_comp_id,'0004',1,0)) g, to_char(sum(decode(n.car_comp_id,'0004',1,0))*100/count(*),'90.99') gp, \n"
				+ " 	sum(decode(n.car_comp_id,'0005',1,0)) s, to_char(sum(decode(n.car_comp_id,'0005',1,0))*100/count(*),'90.99') sp, \n"
				+ " 	sum(decode(sign(to_number(n.car_comp_id)-5),1,1,0)) e, to_char(sum(decode(sign(to_number(n.car_comp_id)-5),1,1,0))*100/count(*),'90.99') ep, \n"
				+ " 	count(*) total \n" + " from car_reg C, cont t, car_etc e, car_nm n \n"
				+ " where c.car_mng_id = t.car_mng_id \n" + " and t.rent_mng_id = e.rent_mng_id \n"
				+ " and t.rent_l_cd = e.rent_l_cd \n"
				+ " and  nvl(t.use_yn,'Y')='Y' and nvl(prepare,'1') <>'4' and t.rent_l_cd not like 'RM%' \n"
				+ " and e.car_id = n.car_id \n" + " and e.car_seq = n.car_seq \n";

		if (gubun2.equals("2")) {// 당월
			query += " and " + when_dt + " like to_char(sysdate,'YYYYMM')||'%' \n";
		} else if (gubun2.equals("3")) {// 기간
			if (!st_dt.equals("") && end_dt.equals(""))
				query += " and " + when_dt + " like replace('" + st_dt + "%', '-','') \n";
			if (!st_dt.equals("") && !end_dt.equals(""))
				query += " and " + when_dt + " between replace('" + st_dt + "', '-','') and replace('" + end_dt
						+ "', '-','') \n";
		}

		if (!gubun3.equals(""))
			query += " and C.car_use='" + gubun3 + "' \n";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatMakerCar2()]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return ht;
		}
	}

	/**
	 * 제조사 개별 자동차 현황 20050905
	 */
	public Vector getStatMakerCarDt(String maker, String gubun2, String gubun3, String gubun4, String st_dt,
			String end_dt) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery = "";

		String when_dt = "a.init_reg_dt";

		if (gubun4.equals("2"))
			when_dt = "b.rent_dt";
		if (gubun4.equals("3"))
			when_dt = "b.dlv_dt";

		if (maker.equals("0000"))
			subQuery = " and d.car_comp_id > '0005' ";
		else if (maker.equals("total"))
			subQuery = "";
		else
			subQuery = " and d.car_comp_id = '" + maker + "' ";

		if (gubun2.equals("2")) {// 당월
			subQuery += " and " + when_dt + " like to_char(sysdate,'YYYYMM')||'%' ";
		} else if (gubun2.equals("3")) {// 기간
			if (!st_dt.equals("") && end_dt.equals(""))
				subQuery += " and " + when_dt + " like replace('" + st_dt + "%', '-','')";
			if (!st_dt.equals("") && !end_dt.equals(""))
				subQuery += " and " + when_dt + " between replace('" + st_dt + "', '-','') and replace('" + end_dt
						+ "', '-','')";
		}

		if (!gubun3.equals(""))
			subQuery += " and a.car_use='" + gubun3 + "'";

		
		int end_year 	= AddUtil.getDate2(1);		//현재년도
		int start_year 	= end_year-10;				//표시시작년도
	 	int td_size 	= end_year-start_year+1;	//표시년도갯수

		query = "select "
				+ "   substr(e.jg_code,1,1)||decode(substr(e.jg_code,1,1)||h.jg_2,'21','L','31','L','41','L') as s_st, "
				+ "	  d.car_nm, ";
		
		for(int h = start_year ; h <= end_year ; h++){
			if(h==start_year) {
				query += " 	sum(decode(sign(substr(a.init_reg_dt,1,4)-"+(h+1)+"),-1,1,0)) y"+h+", ";
			}else {
				query += " 	sum(decode(substr(a.init_reg_dt,1,4),'"+h+"',1,0)) y"+h+", ";
			}			
		}		
		
		
	 	query += "   count(0) total "
				+ " from  car_reg a, cont b, car_etc c, car_mng d, car_nm e, "
				+ "	    (select * from esti_car_var where seq = (select max(seq) from esti_car_var a where a.a_e = a_e) and a_a='1') f, "
				+ "	    ( select sh_code, jg_a, nvl(jg_b,'0') jg_b, nvl(jg_s,'0') jg_s, jg_t, nvl(jg_2,'0') jg_2  \n"
				+ "		  from esti_jg_var  \n"
				+ "		  where (sh_code, seq) in (select sh_code, max(seq) from esti_jg_var group by sh_code)  \n"
				+ "	    ) h  \n" + " where a.car_mng_id = b.car_mng_id "
				+ "       and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd and b.rent_l_cd not like 'RM%' "
				+ "       and c.car_id = e.car_id and c.car_seq = e.car_seq  "
				+ "       and d.car_comp_id = e.car_comp_id and d.code = e.car_cd "
				+ "       and nvl(b.use_yn,'Y') = 'Y' and nvl(prepare,'1') <>'4' " + "       and e.s_st = f.a_e(+) "
				+ "       and e.jg_code=h.sh_code(+)  \n" + subQuery
				+ " group by substr(e.jg_code,1,1)||decode(substr(e.jg_code,1,1)||h.jg_2,'21','L','31','L','41','L'), "
				+ "	       d.car_nm "
				+ " order by substr(e.jg_code,1,1)||decode(substr(e.jg_code,1,1)||h.jg_2,'21','L','31','L','41','L'), "
				+ "	       d.car_nm " + " ";
		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();
			
			

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatMakerCarDt(String maker, String gubun2, String st_dt, String end_dt)]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 제조사 개별 자동차 현황2, 구분없이 차종별로만. 20050907
	 */
	public Vector getStatMakerCarDt2(String maker, String gubun2, String gubun3, String gubun4, String st_dt,
			String end_dt) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery = "";

		String when_dt = "a.init_reg_dt";

		if (gubun4.equals("2"))
			when_dt = "b.rent_dt";
		if (gubun4.equals("3"))
			when_dt = "b.dlv_dt";

		if (maker.equals("0000"))
			subQuery = " and d.car_comp_id > '0005' ";
		else if (maker.equals("total"))
			subQuery = "";
		else
			subQuery = " and d.car_comp_id = '" + maker + "' ";

		if (gubun2.equals("2")) {// 당월
			subQuery += " and " + when_dt + " like to_char(sysdate,'YYYYMM')||'%'";
		} else if (gubun2.equals("3")) {// 기간
			if (!st_dt.equals("") && end_dt.equals(""))
				subQuery += " and " + when_dt + " like replace('" + st_dt + "%', '-','')";
			if (!st_dt.equals("") && !end_dt.equals(""))
				subQuery += " and " + when_dt + " between replace('" + st_dt + "', '-','') and replace('" + end_dt
						+ "', '-','')";
		}

		if (gubun3.equals("1"))
			subQuery += " and a.car_use='1' ";
		else if (gubun3.equals("2"))
			subQuery += " and a.car_use='2' ";
		
		
		int end_year 	= AddUtil.getDate2(1);		//현재년도
		int start_year 	= end_year-10;				//표시시작년도
	 	int td_size 	= end_year-start_year+1;	//표시년도갯수

		query = "select d.car_nm, ";
		
		for(int h = start_year ; h <= end_year ; h++){
			if(h==start_year) {
				query += " 	sum(decode(sign(substr(a.init_reg_dt,1,4)-"+(h+1)+"),-1,1,0)) y"+h+", ";
			}else {
				query += " 	sum(decode(substr(a.init_reg_dt,1,4),'"+h+"',1,0)) y"+h+", ";
			}			
		}
		
		query 	+= "   count(0) total "
				+ " from car_reg a, cont b, car_etc c, car_mng d, car_nm e " + " where a.car_mng_id = b.car_mng_id "
				+ " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd and b.rent_l_cd not like 'RM%' "
				+ " and c.car_id = e.car_id and c.car_seq = e.car_seq "
				+ " and d.car_comp_id = e.car_comp_id and d.code = e.car_cd "
				+ " and nvl(b.use_yn,'Y') = 'Y' and nvl(prepare,'1') <>'4' " + subQuery
				+ " group by d.car_nm order by total desc ";
		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println(
					"[AdminDatabase:getStatMakerCarDt2(String maker, String gubun2, String st_dt, String end_dt)]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 제조사 개별 자동차 현황 20151105 수입차는 제조사별
	 */
	public Vector getStatMakerCarDt3(String maker, String gubun2, String gubun3, String gubun4, String st_dt,
			String end_dt) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery = "";

		String when_dt = "a.init_reg_dt";

		if (gubun4.equals("2"))
			when_dt = "b.rent_dt";
		if (gubun4.equals("3"))
			when_dt = "b.dlv_dt";

		if (maker.equals("0000"))
			subQuery = " and d.car_comp_id > '0005' ";
		else if (maker.equals("total"))
			subQuery = "";
		else
			subQuery = " and d.car_comp_id = '" + maker + "' ";

		if (gubun2.equals("2")) {// 당월
			subQuery += " and " + when_dt + " like to_char(sysdate,'YYYYMM')||'%";
		} else if (gubun2.equals("3")) {// 기간
			if (!st_dt.equals("") && end_dt.equals(""))
				subQuery += " and " + when_dt + " like replace('" + st_dt + "%', '-','')";
			if (!st_dt.equals("") && !end_dt.equals(""))
				subQuery += " and " + when_dt + " between replace('" + st_dt + "', '-','') and replace('" + end_dt
						+ "', '-','')";
		}

		if (!gubun3.equals(""))
			subQuery += " and a.car_use='" + gubun3 + "'";
		

		int end_year 	= AddUtil.getDate2(1);		//현재년도
		int start_year 	= end_year-10;				//표시시작년도
	 	int td_size 	= end_year-start_year+1;	//표시년도갯수

		query = "select g.nm AS car_comp_id, D.CAR_NM, ";
//				+ " 	sum(decode(sign(substr(a.init_reg_dt,1,4)-2008),-1,1,0)) y2007, "
//				+ " 	sum(decode(substr(a.init_reg_dt,1,4),'2008',1,0)) y2008, "
//				+ " 	sum(decode(substr(a.init_reg_dt,1,4),'2009',1,0)) y2009, "
//				+ " 	sum(decode(substr(a.init_reg_dt,1,4),'2010',1,0)) y2010, "
//				+ " 	sum(decode(substr(a.init_reg_dt,1,4),'2011',1,0)) y2011, "
		
		for(int h = start_year ; h <= end_year ; h++){
			if(h==start_year) {
				query += " 	sum(decode(sign(substr(a.init_reg_dt,1,4)-"+(h+1)+"),-1,1,0)) y"+h+", ";
			}else {
				query += " 	sum(decode(substr(a.init_reg_dt,1,4),'"+h+"',1,0)) y"+h+", ";
			}			
		}
		
/*
		query = " SELECT g.nm AS car_comp_id, D.CAR_NM, "
				+ "        sum(decode(sign(substr(a.init_reg_dt,1,4)-2008),-1,1,0)) y2007, "
				+ "        sum(decode(substr(a.init_reg_dt,1,4),'2008',1,0)) y2008,  "
				+ "	     sum(decode(substr(a.init_reg_dt,1,4),'2009',1,0)) y2009,  "
				+ " 	     sum(decode(substr(a.init_reg_dt,1,4),'2010',1,0)) y2010,  "
				+ " 	     sum(decode(substr(a.init_reg_dt,1,4),'2011',1,0)) y2011,  "
				+ " 	     sum(decode(substr(a.init_reg_dt,1,4),'2012',1,0)) y2012,  "
				+ " 	     sum(decode(substr(a.init_reg_dt,1,4),'2013',1,0)) y2013,  "
				+ " 	     sum(decode(substr(a.init_reg_dt,1,4),'2014',1,0)) y2014,  "
				
				+ " 	     sum(decode(substr(a.init_reg_dt,1,4),'2015',1,0)) y2015,  "
				+ " 	     sum(decode(substr(a.init_reg_dt,1,4),'2016',1,0)) y2016,  "
				+ " 	     sum(decode(substr(a.init_reg_dt,1,4),'2017',1,0)) y2017,  "
				+ " 	     sum(decode(substr(a.init_reg_dt,1,4),'2018',1,0)) y2018,  "
				+ " 	     sum(decode(substr(a.init_reg_dt,1,4),'2019',1,0)) y2019,  "
				+ " 	     sum(decode(substr(a.init_reg_dt,1,4),'2020',1,0)) y2020,  "
*/
		
		query += "        count(0) total,                          " 
		        + "        GROUPING (d.car_nm) AS grouping_id "
				+ " from   car_reg a, cont b, car_etc c, car_nm e, car_mng d, "
				+ "        (select * from code where c_st='0001') g " + " where  a.car_mng_id = b.car_mng_id "
				+ "        and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd and b.rent_l_cd not like 'RM%' "
				+ "        and c.car_id = e.car_id and c.car_seq = e.car_seq "
				+ "        and e.car_comp_id = d.car_comp_id and e.car_cd = d.code "
				+ "        and nvl(b.use_yn,'Y') = 'Y' and nvl(prepare,'1') <>'4'	"
				+ "        and e.car_comp_id=G.CODE " + "        AND G.CODE > '0005' " + subQuery
				+ " GROUP BY ROLLUP(g.nm, d.car_nm) " + " order by g.nm, d.car_nm " + " ";
		
		
		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println(
					"[AdminDatabase:getStatMakerCarDt3(String maker, String gubun2, String st_dt, String end_dt)]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 제조사별 현황 통합보기 from : getStatMakerCarMon2(String maker, String gubun2, String
	 * gubun3, String gubun4, String st_dt, String end_dt) date : 2016.12. 29 author
	 * : 성승현
	 */
	public Vector getStatMakerCarMon3(String gubun2, String gubun3, String gubun4, String st_dt, String end_dt) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery = "";

		String when_dt = "a.init_reg_dt";

		if (gubun4.equals("2"))
			when_dt = "b.rent_dt";
		if (gubun4.equals("3"))
			when_dt = "b.dlv_dt";

		if (gubun2.equals("2")) {// 당월
			subQuery += " and " + when_dt + " like to_char(sysdate,'YYYYMM')||'%' \n";
		} else if (gubun2.equals("3")) {// 기간
			if (!st_dt.equals("") && end_dt.equals(""))
				subQuery += " and " + when_dt + " like replace('" + st_dt + "%', '-','') \n";
			if (!st_dt.equals("") && !end_dt.equals(""))
				subQuery += " and " + when_dt + " between replace('" + st_dt + "', '-','') and replace('" + end_dt
						+ "', '-','') \n";
		}

		if (!gubun3.equals(""))
			subQuery += " and a.car_use='" + gubun3 + "' \n";

		query = "SELECT D.CAR_NM CAR_NM, D.CAR_COMP_ID CAR_COMP_ID, COUNT(DECODE(NVL(F.EMP_ID,''), '030849', A.CAR_MNG_ID)) CNT1, \n"
				+ " 	COUNT(DECODE(NVL(F.EMP_ID,''),'030849', '',  A.CAR_MNG_ID)) CNT2, COUNT(0) TOTAL \n"
				+ " FROM CAR_REG A, CONT B, CAR_ETC C, CAR_MNG D, CAR_NM E,  \n"
				+ "	(SELECT CAR_MNG_ID, MAX(B.EMP_ID) EMP_ID \n" + "		FROM CONT A, COMMI B \n"
				+ "		WHERE A.RENT_L_CD=B.RENT_L_CD AND B.AGNT_ST='2' AND B.EMP_ID IS NOT NULL \n"
				+ "		GROUP BY A.CAR_MNG_ID) F \n" + " WHERE A.CAR_MNG_ID = B.CAR_MNG_ID  \n"
				+ " 	AND B.RENT_MNG_ID = C.RENT_MNG_ID AND B.RENT_L_CD = C.RENT_L_CD \n"
				+ " 	AND C.CAR_ID = E.CAR_ID AND C.CAR_SEQ = E.CAR_SEQ  \n"
				+ " 	AND D.CAR_COMP_ID = E.CAR_COMP_ID AND D.CODE = E.CAR_CD  \n"
				+ " 	AND NVL(B.USE_YN,'Y') = 'Y' AND NVL(PREPARE,'1') <>'4'  \n"
				+ " 	AND D.CAR_COMP_ID <= '0005' \n" + " 	AND A.CAR_MNG_ID=F.CAR_MNG_ID(+) \n" + subQuery
				+ " GROUP BY D.CAR_NM, D.CAR_COMP_ID  \n" + " UNION ALL \n"
				+ " SELECT D.CAR_NM CAR_NM, '0000', COUNT(DECODE(NVL(F.EMP_ID,''), '030849', A.CAR_MNG_ID)) CNT1, \n"
				+ " 	COUNT(DECODE(F.EMP_ID,'030849', '',  A.CAR_MNG_ID)) CNT2, COUNT(*) TOTAL  \n"
				+ " FROM CAR_REG A, CONT B, CAR_ETC C, CAR_MNG D, CAR_NM E,  \n"
				+ "	(SELECT CAR_MNG_ID, MAX(B.EMP_ID) EMP_ID \n" + "		FROM CONT A, COMMI B \n"
				+ "		WHERE A.RENT_L_CD=B.RENT_L_CD AND B.AGNT_ST='2' AND B.EMP_ID IS NOT NULL \n"
				+ "		GROUP BY A.CAR_MNG_ID) F \n" + " WHERE A.CAR_MNG_ID = B.CAR_MNG_ID  \n"
				+ " 	AND B.RENT_MNG_ID = C.RENT_MNG_ID AND B.RENT_L_CD = C.RENT_L_CD \n"
				+ " 	AND C.CAR_ID = E.CAR_ID AND C.CAR_SEQ = E.CAR_SEQ  \n"
				+ " 	AND D.CAR_COMP_ID = E.CAR_COMP_ID AND D.CODE = E.CAR_CD  \n"
				+ " 	AND NVL(B.USE_YN,'Y') = 'Y' AND NVL(PREPARE,'1') <>'4'  \n"
				+ " 	AND D.CAR_COMP_ID > '0005' \n" + " 	AND A.CAR_MNG_ID=F.CAR_MNG_ID(+) \n" + subQuery
				+ " GROUP BY D.CAR_NM  \n" + " ORDER BY 5 DESC \n";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println(
					"[AdminDatabase:getStatMakerCarMon2(String maker, String gubun2, String st_dt, String end_dt)]"
							+ e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 제조사 개별 자동차 현황2, 구분없이 차종별로만. 20050907
	 */
	public Vector getStatMakerCarMon2(String maker, String gubun2, String gubun3, String gubun4, String st_dt,
			String end_dt) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery = "";

		if (maker.equals("0000"))
			subQuery = " and d.car_comp_id > '0005' ";
		else if (maker.equals("total"))
			subQuery = "";
		else
			subQuery = " and d.car_comp_id = '" + maker + "' ";

		String when_dt = "a.init_reg_dt";

		if (gubun4.equals("2"))
			when_dt = "b.rent_dt";
		if (gubun4.equals("3"))
			when_dt = "b.dlv_dt";

		if (gubun2.equals("2")) {// 당월
			subQuery += " and " + when_dt + " like to_char(sysdate,'YYYYMM')||'%' \n";
		} else if (gubun2.equals("3")) {// 기간
			if (!st_dt.equals("") && end_dt.equals(""))
				subQuery += " and " + when_dt + " like replace('" + st_dt + "%', '-','') \n";
			if (!st_dt.equals("") && !end_dt.equals(""))
				subQuery += " and " + when_dt + " between replace('" + st_dt + "', '-','') and replace('" + end_dt
						+ "', '-','') \n";
		}

		if (!gubun3.equals(""))
			subQuery += " and a.car_use='" + gubun3 + "' \n";

		query = "select d.car_nm car_nm," + " 	sum(decode(substr(a.init_reg_dt,5,2),'01',1,0)) y01,  \n"
				+ " 	sum(decode(substr(a.init_reg_dt,5,2),'02',1,0)) y02,  \n"
				+ " 	sum(decode(substr(a.init_reg_dt,5,2),'03',1,0)) y03,  \n"
				+ " 	sum(decode(substr(a.init_reg_dt,5,2),'04',1,0)) y04,  \n"
				+ " 	sum(decode(substr(a.init_reg_dt,5,2),'05',1,0)) y05,  \n"
				+ " 	sum(decode(substr(a.init_reg_dt,5,2),'06',1,0)) y06,  \n"
				+ " 	sum(decode(substr(a.init_reg_dt,5,2),'07',1,0)) y07,  \n"
				+ " 	sum(decode(substr(a.init_reg_dt,5,2),'08',1,0)) y08,  \n"
				+ " 	sum(decode(substr(a.init_reg_dt,5,2),'09',1,0)) y09,  \n "
				+ " 	sum(decode(substr(a.init_reg_dt,5,2),'10',1,0)) y10,  \n "
				+ " 	sum(decode(substr(a.init_reg_dt,5,2),'11',1,0)) y11,  \n"
				+ " 	sum(decode(substr(a.init_reg_dt,5,2),'12',1,0)) y12,  \n" + "   count(*) total  \n"
				+ " from car_reg a, cont b, car_etc c, car_mng d, car_nm e  \n"
				+ " where a.car_mng_id = b.car_mng_id  \n"
				+ " and b.rent_mng_id = c.rent_mng_id and b.rent_l_cd = c.rent_l_cd  and b.car_st <>'4'  \n"
				+ " and c.car_id = e.car_id and c.car_seq = e.car_seq  \n"
				+ " and d.car_comp_id = e.car_comp_id and d.code = e.car_cd  \n"
				+ " and nvl(b.use_yn,'Y') = 'Y' and nvl(prepare,'1') <>'4'  \n" + subQuery
				+ " group by d.car_nm order by total desc  \n";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println(
					"[AdminDatabase:getStatMakerCarMon2(String maker, String gubun2, String st_dt, String end_dt)]"
							+ e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 테이블 레이아웃 조회
	 */
	public Vector getDescTable(String table) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select * from USER_TAB_COLUMNS where table_name=upper('" + table + "') order by COLUMN_ID";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getDescTable]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 영업대리인 셋팅
	 */
	public Vector getBusAgntIdFeeEtcNullList() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select" + " a.rent_mng_id, a.rent_l_cd, a.bus_agnt_id, c.rent_dt, d.rent_dt"
				+ " from cont_etc a, fee_etc b, fee c, cont d"
				+ " where a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+)" + // and b.rent_st='1'
				" and b.rent_mng_id=c.rent_mng_id(+) and b.rent_l_cd=c.rent_l_cd(+) and b.rent_st=c.rent_st(+)"
				+ " and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd"
				+ " and b.bus_agnt_id is null and a.bus_agnt_id is not null" + " ";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getBusAgntIdFeeEtcNullList]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 영업대리인 실적 셋팅
	 */
	public Vector getBusAgntPerFeeEtcNullList() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select" + " b.rent_mng_id, b.rent_l_cd, b.rent_st, b.bus_agnt_id, c.rent_dt, d.rent_dt"
				+ " from fee_etc b, fee c, cont d"
				+ " where b.rent_mng_id=c.rent_mng_id and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st"
				+ " and b.rent_mng_id=d.rent_mng_id and b.rent_l_cd=d.rent_l_cd"
				+ " and b.bus_agnt_id is not null and nvl(b.bus_agnt_r_per,0) =0" + " and c.rent_dt > '20080631'" + " ";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getBusAgntPerFeeEtcNullList]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 업무대여 사원 네오엠 거래처 미등록 리스트
	 */
	public Vector getUserVenCodeNonRegList() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select b.*"
				+ " from (select cust_id from rent_cont where use_st='2' and cust_st='4' group by cust_id) a, users b"
				+ " where a.cust_id=b.user_id"
				+ " and b.use_yn='Y' and b.dept_id<>'0004' and b.user_pos not in ('팀장','부장') and b.ven_code is null"
				+ " ";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getUserVenCodeNonRegList]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 업무대여 사원 네오엠 거래처 등록 리스트
	 */
	public Vector getUserVenCodeRegList() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select b.*"
				+ " from (select cust_id from rent_cont where use_st='2' and cust_st='4' group by cust_id) a, users b"
				+ " where a.cust_id=b.user_id"
				+ " and b.use_yn='Y' and b.dept_id<>'0004' and b.user_pos not in ('팀장','부장') and b.ven_code is not null"
				+ " ";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getUserVenCodeRegList]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 업무대여 사원 네오엠 거래처 등록 리스트
	 */
	public Vector getChkMngDeptBusid2Mngid2List1(String bus_id2) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select"
				+ " a.mng_id2, d.user_nm, c.firm_nm, f.car_no, decode(e.rent_way,'1','일반식','3','기본식') rent_way, a.rent_start_dt, a.rent_end_dt, b.*, trunc((b.dly_amt/b.tot_amt*100),2) dly_per"
				+ " from cont a," + " (" + "  select rent_mng_id, rent_l_cd," + "  count(rent_l_cd) cnt,"
				+ "  sum(fee_s_amt+fee_v_amt) tot_amt,"
				+ "  sum(decode(nvl(dly_fee,0),0,0,fee_s_amt+fee_v_amt)) dly_amt,"
				+ "  count(decode(nvl(dly_fee,0),0,'',rent_l_cd)) dly_cnt"
				+ "  from scd_fee where rc_yn='0' and nvl(bill_yn,'Y')='Y' and tm_st2<>'4' "
				+ "  group by rent_mng_id, rent_l_cd ) b," + " client c, users d, fee e, car_reg f" + " where"
				+ " a.bus_id2='" + bus_id2 + "'" + " and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"
				+ " and a.client_id=c.client_id and a.bus_id2=d.user_id"
				+ " and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd and e.rent_st='1'"
				+ " and a.car_mng_id=f.car_mng_id" + " and a.bus_id2=nvl(a.mng_id2,a.bus_id2)"
				+ " order by e.rent_way, b.dly_cnt desc, a.rent_start_dt" + " ";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getChkMngDeptBusid2Mngid2List1]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 업무대여 사원 네오엠 거래처 등록 리스트
	 */
	public Vector getChkMngDeptBusid2Mngid2List2(String bus_id2) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select"
				+ " a.mng_id2, d.user_nm, c.firm_nm, f.car_no, decode(e.rent_way,'1','일반식','3','기본식') rent_way, a.rent_start_dt, a.rent_end_dt, b.*, trunc((b.dly_amt/b.tot_amt*100),2) dly_per"
				+ " from cont a," + " (" + "  select rent_mng_id, rent_l_cd," + "  count(rent_l_cd) cnt,"
				+ "  sum(fee_s_amt+fee_v_amt) tot_amt,"
				+ "  sum(decode(nvl(dly_fee,0),0,0,fee_s_amt+fee_v_amt)) dly_amt,"
				+ "  count(decode(nvl(dly_fee,0),0,'',rent_l_cd)) dly_cnt"
				+ "  from scd_fee where rc_yn='0' and nvl(bill_yn,'Y')='Y' and tm_st2<>'4' "
				+ "  group by rent_mng_id, rent_l_cd ) b," + " client c, users d, fee e, car_reg f" + " where"
				+ " a.bus_id2='" + bus_id2 + "'" + " and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"
				+ " and a.client_id=c.client_id and a.bus_id2=d.user_id"
				+ " and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd and e.rent_st='1'"
				+ " and a.car_mng_id=f.car_mng_id" + " and a.bus_id2<>nvl(a.mng_id2,a.bus_id2)"
				+ " order by e.rent_way, b.dly_cnt desc, c.firm_nm, a.rent_start_dt" + " ";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getChkMngDeptBusid2Mngid2List2]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 업무대여 사원 네오엠 거래처 등록 리스트
	 */
	public Vector getChkMngDeptBusid2Mngid2Stat() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query1 = " select"
				+ " a.bus_id2, a.mng_id2, d.user_nm, c.firm_nm, f.car_no, decode(e.rent_way,'1','일반식','3','기본식') rent_way, a.rent_start_dt, a.rent_end_dt, b.*, trunc((b.dly_amt/b.tot_amt*100),2) dly_per"
				+ " from cont a," + " (" + "  select rent_mng_id, rent_l_cd," + "  count(rent_l_cd) cnt,"
				+ "  sum(fee_s_amt+fee_v_amt) tot_amt,"
				+ "  sum(decode(nvl(dly_fee,0),0,0,fee_s_amt+fee_v_amt)) dly_amt,"
				+ "  count(decode(nvl(dly_fee,0),0,'',rent_l_cd)) dly_cnt"
				+ "  from scd_fee where rc_yn='0' and nvl(bill_yn,'Y')='Y' and tm_st2<>'4' "
				+ "  group by rent_mng_id, rent_l_cd ) b," + " client c, users d, fee e, car_reg f" + " where"
				+ " a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"
				+ " and a.client_id=c.client_id and a.bus_id2=d.user_id"
				+ " and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd and e.rent_st='1'"
				+ " and a.car_mng_id=f.car_mng_id" + " and a.bus_id2=nvl(a.mng_id2,a.bus_id2)" + " ";

		String query2 = " select"
				+ " a.bus_id2, a.mng_id2, d.user_nm, c.firm_nm, f.car_no, decode(e.rent_way,'1','일반식','3','기본식') rent_way, a.rent_start_dt, a.rent_end_dt, b.*, trunc((b.dly_amt/b.tot_amt*100),2) dly_per"
				+ " from cont a," + " (" + "  select rent_mng_id, rent_l_cd," + "  count(rent_l_cd) cnt,"
				+ "  sum(fee_s_amt+fee_v_amt) tot_amt,"
				+ "  sum(decode(nvl(dly_fee,0),0,0,fee_s_amt+fee_v_amt)) dly_amt,"
				+ "  count(decode(nvl(dly_fee,0),0,'',rent_l_cd)) dly_cnt"
				+ "  from scd_fee where rc_yn='0' and nvl(bill_yn,'Y')='Y' and tm_st2<>'4' "
				+ "  group by rent_mng_id, rent_l_cd ) b," + " client c, users d, fee e, car_reg f" + " where"
				+ " a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"
				+ " and a.client_id=c.client_id and a.bus_id2=d.user_id"
				+ " and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd and e.rent_st='1'"
				+ " and a.car_mng_id=f.car_mng_id" + " and a.bus_id2<>nvl(a.mng_id2,a.bus_id2)" + " ";

		String query = "";

		query = " select c.nm, c.user_nm, c.user_id, " + " a.tot_amt1, a.dly_amt1, a.dly_per1, "
				+ " b.tot_amt2, b.dly_amt2, b.dly_per2, " + " (nvl(a.tot_amt1,0)+nvl(b.tot_amt2,0)) tot_amt0,"
				+ " (nvl(a.dly_amt1,0)+nvl(b.dly_amt2,0)) dly_amt0,"
				+ " trunc(((nvl(a.dly_amt1,0)+nvl(b.dly_amt2,0))/(nvl(a.tot_amt1,0)+nvl(b.tot_amt2,0))*100),2) dly_per0"
				+ " from "
				+ " (select b.nm, a.* from users a, (select * from code where c_st='0002' and code<>'0000') b where a.loan_st='1' and a.use_yn='Y' and a.loan_st is not null and a.dept_id=b.code) c, "
				+ " (select bus_id2, sum(tot_amt) tot_amt1, sum(dly_amt) dly_amt1, trunc((sum(dly_amt)/sum(tot_amt)*100),2) dly_per1 from ("
				+ query1 + ") group by bus_id2) a,"
				+ " (select bus_id2, sum(tot_amt) tot_amt2, sum(dly_amt) dly_amt2, trunc((sum(dly_amt)/sum(tot_amt)*100),2) dly_per2 from ("
				+ query2 + ") group by bus_id2) b " + " where c.user_id=a.bus_id2(+) and c.user_id=b.bus_id2(+)"
				+ " order by trunc(((nvl(a.dly_amt1,0)+nvl(b.dly_amt2,0))/(nvl(a.tot_amt1,0)+nvl(b.tot_amt2,0))*100),2)"
				+ "";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getChkMngDeptBusid2Mngid2Stat]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 업무대여 사원 네오엠 거래처 등록 리스트
	 */
	public Vector getChkBusDeptBusid2Mngid2Stat() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query1 = " select"
				+ " a.bus_id2, a.mng_id2, d.user_nm, c.firm_nm, f.car_no, decode(e.rent_way,'1','일반식','3','기본식') rent_way, a.rent_start_dt, a.rent_end_dt, b.*, trunc((b.dly_amt/b.tot_amt*100),2) dly_per"
				+ " from cont a," + " (" + "  select rent_mng_id, rent_l_cd," + "  count(rent_l_cd) cnt,"
				+ "  sum(fee_s_amt+fee_v_amt) tot_amt,"
				+ "  sum(decode(nvl(dly_fee,0),0,0,fee_s_amt+fee_v_amt)) dly_amt,"
				+ "  count(decode(nvl(dly_fee,0),0,'',rent_l_cd)) dly_cnt"
				+ "  from scd_fee where rc_yn='0' and nvl(bill_yn,'Y')='Y' and tm_st2<>'4' "
				+ "  group by rent_mng_id, rent_l_cd ) b," + " client c, users d, fee e, car_reg f" + " where"
				+ " a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"
				+ " and a.client_id=c.client_id and a.bus_id2=d.user_id"
				+ " and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd and e.rent_st='1'"
				+ " and a.car_mng_id=f.car_mng_id" +
				// " and a.bus_id2=nvl(a.mng_id2,a.bus_id2)"+
				" ";

		String query2 = " select"
				+ " a.bus_id2, a.mng_id2, d.user_nm, c.firm_nm, f.car_no, decode(e.rent_way,'1','일반식','3','기본식') rent_way, a.rent_start_dt, a.rent_end_dt, b.*, trunc((b.dly_amt/b.tot_amt*100),2) dly_per"
				+ " from cont a," + " (" + "  select rent_mng_id, rent_l_cd," + "  count(rent_l_cd) cnt,"
				+ "  sum(fee_s_amt+fee_v_amt) tot_amt,"
				+ "  sum(decode(nvl(dly_fee,0),0,0,fee_s_amt+fee_v_amt)) dly_amt,"
				+ "  count(decode(nvl(dly_fee,0),0,'',rent_l_cd)) dly_cnt"
				+ "  from scd_fee where rc_yn='0' and nvl(bill_yn,'Y')='Y' and tm_st2<>'4' "
				+ "  group by rent_mng_id, rent_l_cd ) b," + " client c, users d, fee e, car_reg f" + " where"
				+ " a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"
				+ " and a.client_id=c.client_id and a.bus_id2=d.user_id"
				+ " and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd and e.rent_st='1'"
				+ " and a.car_mng_id=f.car_mng_id" + " ";

		String query = "";

		query = " select c.nm, c.user_nm, c.user_id, " + " a.tot_amt1, a.dly_amt1, a.dly_per1, "
				+ " b.tot_amt2, b.dly_amt2, b.dly_per2, " + " (nvl(a.tot_amt1,0)+nvl(b.tot_amt2,0)) tot_amt0,"
				+ " (nvl(a.dly_amt1,0)+nvl(b.dly_amt2,0)) dly_amt0,"
				+ " trunc(((nvl(a.dly_amt1,0)+nvl(b.dly_amt2,0))/(nvl(a.tot_amt1,0)+nvl(b.tot_amt2,0))*100),2) dly_per0"
				+ " from "
				+ " (select b.nm, a.* from users a, (select * from code where c_st='0002' and code<>'0000') b where a.loan_st='2' and a.use_yn='Y' and a.loan_st is not null and a.dept_id=b.code) c, "
				+ " (select bus_id2, sum(tot_amt) tot_amt1, sum(dly_amt) dly_amt1, trunc((sum(dly_amt)/sum(tot_amt)*100),2) dly_per1 from ("
				+ query1 + ") group by bus_id2) a,"
				+ " (select mng_id2, sum(tot_amt) tot_amt2, sum(dly_amt) dly_amt2, trunc((sum(dly_amt)/sum(tot_amt)*100),2) dly_per2 from ("
				+ query1 + ") group by mng_id2) b " + " where c.user_id=a.bus_id2(+) and c.user_id=b.mng_id2(+)"
				+ " order by trunc(((nvl(a.dly_amt1,0)+nvl(b.dly_amt2,0))/(nvl(a.tot_amt1,0)+nvl(b.tot_amt2,0))*100),2)"
				+ "";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getChkBusDeptBusid2Mngid2Stat]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 업무대여 사원 네오엠 거래처 등록 리스트
	 */
	public Vector getChkBusDeptBusid2Mngid2List1(String bus_id2) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select"
				+ " a.mng_id2, d.user_nm, c.firm_nm, f.car_no, decode(e.rent_way,'1','일반식','3','기본식') rent_way, a.rent_start_dt, a.rent_end_dt, b.*, trunc((b.dly_amt/b.tot_amt*100),2) dly_per"
				+ " from cont a," + " (" + "  select rent_mng_id, rent_l_cd," + "  count(rent_l_cd) cnt,"
				+ "  sum(fee_s_amt+fee_v_amt) tot_amt,"
				+ "  sum(decode(nvl(dly_fee,0),0,0,fee_s_amt+fee_v_amt)) dly_amt,"
				+ "  count(decode(nvl(dly_fee,0),0,'',rent_l_cd)) dly_cnt"
				+ "  from scd_fee where rc_yn='0' and nvl(bill_yn,'Y')='Y' and tm_st2<>'4' "
				+ "  group by rent_mng_id, rent_l_cd ) b," + " client c, users d, fee e, car_reg f" + " where"
				+ " a.mng_id2 in ('000005', '000053')" + " and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"
				+ " and a.client_id=c.client_id and a.bus_id2=d.user_id"
				+ " and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd and e.rent_st='1'"
				+ " and a.car_mng_id=f.car_mng_id" + " order by e.rent_way, b.dly_cnt desc, a.rent_start_dt" + " ";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getChkBusDeptBusid2Mngid2List1]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 업무대여 사원 네오엠 거래처 등록 리스트
	 */
	public Vector getChkBusDeptBusid2Mngid2List2(String bus_id2) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String query = " select"
				+ " a.mng_id2, d.user_nm, c.firm_nm, f.car_no, decode(e.rent_way,'1','일반식','3','기본식') rent_way, a.rent_start_dt, a.rent_end_dt, b.*, trunc((b.dly_amt/b.tot_amt*100),2) dly_per"
				+ " from cont a," + " (" + "  select rent_mng_id, rent_l_cd," + "  count(rent_l_cd) cnt,"
				+ "  sum(fee_s_amt+fee_v_amt) tot_amt,"
				+ "  sum(decode(nvl(dly_fee,0),0,0,fee_s_amt+fee_v_amt)) dly_amt,"
				+ "  count(decode(nvl(dly_fee,0),0,'',rent_l_cd)) dly_cnt"
				+ "  from scd_fee where rc_yn='0' and nvl(bill_yn,'Y')='Y' and tm_st2<>'4' "
				+ "  group by rent_mng_id, rent_l_cd ) b," + " client c, users d, fee e, car_reg f"
				+ " where d.loan_st='2'" + " and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd"
				+ " and a.client_id=c.client_id and a.mng_id_id2=d.user_id"
				+ " and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd and e.rent_st='1'"
				+ " and a.car_mng_id=f.car_mng_id" + " and a.bus_id2<>nvl(a.mng_id2,a.bus_id2)"
				+ " order by e.rent_way, b.dly_cnt desc, a.rent_start_dt" + " ";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getChkBusDeptBusid2Mngid2List2]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/*
	 * 부채마감 프로시져 호출
	 */
	public void call_p_fee_dly_sms() {
		getConnection();

		String query = "{CALL P_FEE_DLY_SMS }";

		String sResult = "";

		CallableStatement cstmt = null;

		try {
			cstmt = conn.prepareCall(query);

			cstmt.execute();
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_p_fee_dly_sms]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
		}
	}

	/**
	 * 업무담당자별 고객리스트
	 */
	public Vector getLcRentUserList(String st, String user_id) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();

		String where = "";

		if (st.equals("1"))
			where = " and d.bus_id  = '" + user_id + "'";
		if (st.equals("2"))
			where = " and d.bus_id2 = '" + user_id + "'";
		if (st.equals("3"))
			where = " and d.mng_id  = '" + user_id + "'";

		String query = " select " + " e.firm_nm, c.car_no, o.car_nm," + " decode(h.rent_way,'1','일반식','기본식') rent_way,"
				+ " h.rent_end_dt," + " e.client_nm, e.m_tel, e.h_tel, e.o_tel, e.fax,"
				+ " g.mgr_nm as mgr_nm1, g.mgr_m_tel as mgr_m_tel1, g.mgr_tel as mgr_tel1,"
				+ " i.mgr_nm as mgr_nm2, i.mgr_m_tel as mgr_m_tel2, i.mgr_tel as mgr_tel2,"
				+ " j.mgr_nm as mgr_nm3, j.mgr_m_tel as mgr_m_tel3, j.mgr_tel as mgr_tel3,"
				+ " k.mgr_nm as mgr_nm4, k.mgr_m_tel as mgr_m_tel4, k.mgr_tel as mgr_tel4," + " e.o_addr,"
				+ " l.user_nm as bus_nm," + " m.user_nm as bus_nm2," + " n.user_nm as mng_nm" + " from"
				+ " cont d, client e, client_site f, car_reg c, car_etc b, car_nm a, car_mng o,"
				+ " (select * from car_mgr where mgr_st='회계관리자') g,"
				+ " (select * from car_mgr where mgr_st='차량관리자') i,"
				+ " (select * from car_mgr where mgr_st='차량이용자') j,"
				+ " (select * from car_mgr where mgr_st='계약담당자') k,"
				+ " (select rent_mng_id, rent_l_cd, min(rent_way) rent_way, max(nvl(rent_end_dt,'-')) rent_end_dt from fee group by rent_mng_id, rent_l_cd) h,"
				+ " users l, users m, users n" + " where d.use_yn='Y' and d.car_st in ('1','3','4') " + where
				+ " and d.client_id=e.client_id" + " and d.client_id=f.CLIENT_ID(+) and d.r_site=f.seq(+)"
				+ " and d.car_mng_id=c.car_mng_id(+)" + " and d.rent_mng_id=b.rent_mng_id and d.rent_l_cd=b.rent_l_cd"
				+ " and b.car_id=a.car_id and b.car_seq=a.car_seq"
				+ " and a.car_comp_id=o.car_comp_id and a.car_cd=o.code"
				+ " and d.rent_mng_id=g.rent_mng_id and d.rent_l_cd=g.rent_l_cd"
				+ " and d.rent_mng_id=i.rent_mng_id and d.rent_l_cd=i.rent_l_cd"
				+ " and d.rent_mng_id=j.rent_mng_id and d.rent_l_cd=j.rent_l_cd"
				+ " and d.rent_mng_id=k.rent_mng_id(+) and d.rent_l_cd=k.rent_l_cd(+)"
				+ " and d.rent_mng_id=h.rent_mng_id and d.rent_l_cd=h.rent_l_cd" + " and d.bus_id=l.user_id"
				+ " and d.bus_id2=m.user_id(+)" + " and d.mng_id=n.user_id(+)"
				+ " order by h.rent_way, e.firm_nm, h.rent_end_dt" + " ";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getLcRentUserList]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/*
	 * 부채마감 프로시져 호출
	 */
	public String call_P_SALE_COST_BASE_MAGAM() {
		getConnection();

		String query = "{CALL P_SALE_COST_BASE_MAGAM (?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {
			cstmt = conn.prepareCall(query);

			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);

			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_P_SALE_COST_BASE_MAGAM]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/**
	 * 월마감-계약현황
	 */
	public Vector getSelectStatEndContList(String cont_end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "
				+ "        b.client_id, b.firm_nm as 거래처명, count(a.rent_l_cd) 대여대수, sum(f.fee_s_amt+f.fee_v_amt) 월대여료"
				+ " from   cont a, client b, car_reg c, car_etc d, car_nm e, fee f,"
				+ "        (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) g"
				+ " where" + " nvl(a.use_yn,'Y')='Y'" + // --살아있는계약
				" and a.car_st<>'2'" + // --보유차제외
				" and a.client_id=b.client_id" + " and a.car_mng_id=c.car_mng_id"
				+ " and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd"
				+ " and d.car_id=e.car_id and d.car_seq=e.car_seq"
				+ " and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd"
				+ " and f.rent_mng_id=g.rent_mng_id and f.rent_l_cd=g.rent_l_cd and f.rent_st=g.rent_st"
				+ " and nvl(f.rent_dt,a.rent_dt) <= replace('" + cont_end_dt + "','-','')" + // --마감일까지 계약된것
				" group by b.client_id, b.firm_nm" + " order by count(a.rent_l_cd) desc, b.firm_nm" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndContList]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 월마감-계약현황
	 */
	public Vector getSelectStatEndContListDB(String save_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.client_id, b.firm_nm as 거래처명, \n" 
		        + "        count(a.rent_l_cd) 대여대수, \n"
				+ "        sum(a.fee_s_amt+decode(a.fee_s_amt,c.fee_s_amt,c.fee_v_amt,trunc(a.fee_s_amt*0.1))) 월대여료, \n"
				+ "        '' 비고 \n" 
				+ " from   stat_rent_month a, client b, fee c, car_reg d \n"
				+ " where  a.save_dt=replace('" + save_dt + "','-','') \n"
				+ "        and a.car_st<>'2' and a.client_id<>'000228' \n" 
				+ "        and a.client_id=b.client_id \n"
				+ "        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.fee_rent_st=c.rent_st \n"
				+ "        and a.car_mng_id=d.car_mng_id \n" 
				+ "        and a.prepare not in ('4','5') \n" // 말소,도난차량																												
				+ " group by b.client_id, b.firm_nm \n" 
				+ " order by count(a.rent_l_cd) desc, b.firm_nm" + " ";

		// 2017년도부터는 계약기준이 아닌 자동차등록 기준으로 변경

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndContListDB]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 월마감-차량현황
	 */
	public Vector getSelectStatEndCarList(String car_end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select" + " b.car_nm||' '||d.car_name 차명, b.car_no 차량번호,"
				+ " substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2) 등록일"
				+ " , decode(b.prepare,'1','','2','','3','','4','말소차량','5','도난차량','6','경매','7','','8','')as 비고"
				+ " from cont a, car_reg b, car_etc c, car_nm d" + " where" + " nvl(a.use_yn,'Y')='Y'" + // --살아있는 계약
				" and b.init_reg_dt <= replace('" + car_end_dt + "','-','')" + // --마감일까지 등록된것
				" and a.car_mng_id=b.car_mng_id" + " and a.rent_l_cd=c.rent_l_cd"
				+ " and c.car_id=d.car_id and c.car_seq=d.car_seq" + " order by b.init_reg_dt, a.car_mng_id" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndCarList]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 월마감-차량현황
	 */
	public Vector getSelectStatEndCarListDB(String save_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.car_nm||' '||d.car_name 차명, \n" + "        b.car_no 차량번호, \n"
				+ "        substr(b.init_reg_dt,1,4)||'-'||substr(b.init_reg_dt,5,2)||'-'||substr(b.init_reg_dt,7,2) 등록일, \n"
				+ "        decode(a.prepare,'1','','2','','3','','4','말소차량','5','도난차량','6','경매','7','','8','') as 비고 \n"
				+ " from   stat_rent_month a, car_reg b, car_etc c, car_nm d \n" + " where  a.save_dt=replace('"
				+ save_dt + "','-','') \n" + "        and a.car_mng_id=b.car_mng_id \n"
				+ "        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"
				+ "        and c.car_id=d.car_id and c.car_seq=d.car_seq \n"
				+ " order by decode(a.prepare,'4',1,'5',2,0), b.init_reg_dt, a.car_mng_id \n" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndCarListDB]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 월마감-차입금상환일정표
	 */
	public Vector getSelectStatEndBankDebtList(String bank_end_dt, String s_var) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select" + " alt_est_dt 귀속년월, sum(alt_prn) 상환, sum(alt_rest) 잔액" + " from" + "     ( select"
				+ "              substr(a.alt_est_dt,1,7) alt_est_dt, a.rent_l_cd, a.rtn_seq, sum(a.alt_prn) alt_prn, min(a.alt_rest) alt_rest"
				+ "       from   debt_pay_view a, allot b, lend_bank c " + "       where"
				+ "              a.alt_est_dt >='" + bank_end_dt + "'" + // 마감월 초부터
				"              and decode(a.cpt_cd, '0068','0077', '0073','0077', '0051','0078', '0064','0079', a.cpt_cd)='"
				+ s_var + "'" + "              and a.car_mng_id=b.car_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) \n"
				+ "              and a.lend_id=c.lend_id(+) and nvl(a.acct_code,'26400') in ('26400','29300')\n"
				+ "              and substr(decode(a.lend_id,'',b.lend_dt, c.cont_dt),1,6) <= substr(replace('"
				+ bank_end_dt + "','-',''),1,6) " + // 마감기준일보다 큰것은 안가져옴
				"       group by substr(a.alt_est_dt,1,7), a.rent_l_cd, a.rtn_seq " + "	   ) "
				+ " group by alt_est_dt order by alt_est_dt" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndBankDebtList]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 월마감-차입금상환일정표
	 */
	public Vector getSelectStatEndBankDebtLsList(String bank_end_dt, String s_var) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select" + " alt_est_dt 귀속년월, sum(alt_prn) 상환, sum(alt_rest) 잔액" + " from" + "     ( select"
				+ "              substr(a.alt_est_dt,1,7) alt_est_dt, a.rent_l_cd, a.rtn_seq, sum(a.alt_prn) alt_prn, min(a.alt_rest) alt_rest"
				+ "       from   debt_pay_view a, allot b, lend_bank c " + "       where"
				+ "              a.alt_est_dt >='" + bank_end_dt + "'" + // 마감월 초부터
				"              and decode(a.cpt_cd, '0068','0077', '0073','0077', '0051','0078', '0064','0079', a.cpt_cd)='"
				+ s_var + "'" + "              and a.car_mng_id=b.car_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) \n"
				+ "              and a.lend_id=c.lend_id(+) and nvl(a.acct_code,'26400')='45450'\n"
				+ "              and substr(decode(a.lend_id,'',b.lend_dt, c.cont_dt),1,6) <= substr(replace('"
				+ bank_end_dt + "','-',''),1,6) " + // 마감기준일보다 큰것은 안가져옴
				"       group by substr(a.alt_est_dt,1,7), a.rent_l_cd, a.rtn_seq " + "	   ) "
				+ " group by alt_est_dt order by alt_est_dt" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndBankDebtLsList]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 월마감-차입금상환일정표 마감분 조회
	 */
	public Vector getSelectStatEndBankDebtListDB(String save_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		String bank_cd[] = new String[18];
		bank_cd[0] = "0005";
		bank_cd[1] = "0001";
		bank_cd[2] = "0002";
		bank_cd[3] = "0003";
		bank_cd[4] = "0004";
		bank_cd[5] = "0010";
		bank_cd[6] = "0009";
		bank_cd[7] = "0018";
		bank_cd[8] = "0038";
		bank_cd[9] = "0039";
		bank_cd[10] = "0040";
		bank_cd[11] = "0041";
		bank_cd[12] = "0042";
		bank_cd[13] = "0043";
		bank_cd[14] = "0044";
		bank_cd[15] = "0051";
		bank_cd[16] = "0052";
		bank_cd[17] = "0055";

		query = " select est_mon, \n";

		for (int j = 0; j < 18; j++) {
			query += "        nvl(sum(decode(bank_cd,'" + bank_cd[j] + "',prn_amt )),0) p_amt_" + bank_cd[j] + ", \n"
					+ "        nvl(sum(decode(bank_cd,'" + bank_cd[j] + "',rest_amt)),0) r_amt_" + bank_cd[j] + ", \n";
		}

		query += "        nvl(sum(prn_amt ),0) p_amt, \n" + "        nvl(sum(rest_amt),0) r_amt  \n"
				+ " from   stat_debt_month \n" + " where  save_dt=replace('" + save_dt + "','-','') \n"
				+ " group by est_mon \n" + " order by est_mon \n" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "0" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndBankDebtListDB]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 월마감-차입금상환일정표 마감분 조회
	 */
	public Vector getSelectStatEndBankDebtListDB(String save_dt, Vector bank_vt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		int vt_size2 = bank_vt.size();
		String bank_cd[] = new String[vt_size2];

		for (int i = 0; i < vt_size2; i++) {
			Hashtable bank_ht = (Hashtable) bank_vt.elementAt(i);
			bank_cd[i] = String.valueOf(bank_ht.get("BANK_CD"));
		}

		query = " select est_mon, \n";

		for (int j = 0; j < vt_size2; j++) {
			query += "        nvl(sum(decode(bank_cd,'" + bank_cd[j] + "',prn_amt )),0) p_amt_" + bank_cd[j] + ", \n"
					+ "        nvl(sum(decode(bank_cd,'" + bank_cd[j] + "',int_amt)),0)  i_amt_" + bank_cd[j] + ", \n"
					+ "        nvl(sum(decode(bank_cd,'" + bank_cd[j] + "',rest_amt)),0) r_amt_" + bank_cd[j] + ", \n";
		}

		query += "        nvl(sum(prn_amt ),0) p_amt, \n" + "        nvl(sum(int_amt),0)  i_amt,  \n"
				+ "        nvl(sum(rest_amt),0) r_amt  \n" + " from   stat_debt_month \n" + " where  save_dt=replace('"
				+ save_dt + "','-','')  and nvl(acct_code,'26400') in ('26400','29300') \n" + " group by est_mon \n"
				+ " order by est_mon \n" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "0" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndBankDebtListDB]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 월마감-차입금상환일정표 마감분 조회
	 */
	public Vector getSelectStatEndBankDebtLsListDB(String save_dt, Vector bank_vt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		int vt_size2 = bank_vt.size();
		String bank_cd[] = new String[vt_size2];

		for (int i = 0; i < vt_size2; i++) {
			Hashtable bank_ht = (Hashtable) bank_vt.elementAt(i);
			bank_cd[i] = String.valueOf(bank_ht.get("BANK_CD"));
		}

		query = " select est_mon, \n";

		for (int j = 0; j < vt_size2; j++) {
			query += "        nvl(sum(decode(bank_cd,'" + bank_cd[j] + "',prn_amt )),0) p_amt_" + bank_cd[j] + ", \n"
					+ "        nvl(sum(decode(bank_cd,'" + bank_cd[j] + "',int_amt)),0)  i_amt_" + bank_cd[j] + ", \n"
					+ "        nvl(sum(decode(bank_cd,'" + bank_cd[j] + "',rest_amt)),0) r_amt_" + bank_cd[j] + ", \n";
		}

		query += "        nvl(sum(prn_amt ),0) p_amt, \n" + "        nvl(sum(int_amt),0)  i_amt,  \n"
				+ "        nvl(sum(rest_amt),0) r_amt  \n" + " from   stat_debt_month \n" + " where  save_dt=replace('"
				+ save_dt + "','-','')  and nvl(acct_code,'26400')='45450' \n" + " group by est_mon \n"
				+ " order by est_mon \n" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "0" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndBankDebtLsListDB]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 월마감-차입금상환일정표 마감분 조회
	 */
	public Vector getSelectStatEndBankDebtListDB_Bank(String save_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select save_dt, seq, bank_cd \n" + " from   stat_debt_month \n" + " where  save_dt=replace('"
				+ save_dt + "','-','') and nvl(acct_code,'26400') in ('26400','29300') \n" + " group by save_dt, seq, bank_cd \n"
				+ " order by save_dt, seq, bank_cd \n" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "0" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndBankDebtListDB_Bank]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 월마감-차입금상환일정표 마감분 조회
	 */
	public Vector getSelectStatEndBankDebtLsListDB_Bank(String save_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select save_dt, seq, bank_cd \n" + " from   stat_debt_month \n" + " where  save_dt=replace('"
				+ save_dt + "','-','') and nvl(acct_code,'26400')='45450' \n" + " group by save_dt, seq, bank_cd \n"
				+ " order by save_dt, seq, bank_cd \n" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "0" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndBankDebtListDB_Bank]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 입출금예정-할부금
	 */
	public Vector getSelectAccountEstDebtList(String debt_end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select substr(a.dt,9,2) day, a.dt, b.* \n"+
		        " from   ( SELECT TO_CHAR(TO_DATE('"+debt_end_dt+"'||'01','YYYYMMDD') + LEVEL -1, 'YYYY-MM-DD') AS dt FROM dual CONNECT BY LEVEL <= ( LAST_DAY(TO_DATE('"+debt_end_dt+"'||'01','YYYYMMDD')) - TO_DATE('"+debt_end_dt+"'||'01','YYYYMMDD') +1)) a,\n"+
				"        (select r_alt_est_dt, r_alt_est_dt 일자, sum(alt_amt) 금액, sum(alt_prn) 원금, sum(alt_int) 이자 from debt_pay_view where r_alt_est_dt like '" + AddUtil.ChangeDate2(debt_end_dt) + "%' group by r_alt_est_dt) b \n"+
				" where a.dt=b.r_alt_est_dt(+) order by a.dt ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectAccountEstDebtList]\n" + e);
			System.out.println("[AdminDatabase:getSelectAccountEstDebtList]\n" + query);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 입출금예정-할부금
	 */
	public Vector getSelectAccountEstInsList(String ins_end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select" + " dt 일자, sum(ins_amt) 금액" + " from" + " ("
				+ " select r_ins_est_dt as dt, sum(pay_amt) ins_amt from scd_ins "
				+ "        where substr(r_ins_est_dt,1,6) >= substr(replace('" + ins_end_dt
				+ "','-',''),1,6) and pay_dt is null group by r_ins_est_dt" + " union" + " select"
				+ " b.ins_exp_dt as dt, sum(b.rins_pcp_amt+b.vins_pcp_amt+b.vins_gcp_amt+b.vins_bacdt_amt+b.vins_canoisr_amt+b.vins_cacdt_cm_amt+b.vins_spe_amt) ins_amt"
				+ " from cont a, insur b" + " where nvl(a.use_yn,'Y')='Y'" + " and a.car_mng_id=b.car_mng_id"
				+ " and b.ins_sts='1' "
				+ " and to_char(to_date(substr(b.ins_exp_dt,1,6),'YYYYMM')-1,'YYYYMM') >= substr(replace('" + ins_end_dt
				+ "','-',''),1,6)" + " group by b.ins_exp_dt" + " )" + " group by dt order by dt" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectAccountEstInsList]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 입출금예정-대여료
	 */
	public Vector getSelectAccountEstFeeList(String fee_end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select r_fee_est_dt 일자, sum(fee_s_amt+fee_v_amt) 금액 " + " from scd_fee "
				+ " where rc_yn='0'  and tm_st2<>'4' "
				+ " and r_fee_est_dt like substr(replace('" + fee_end_dt + "','-',''),1,6)||'%' "
				+ " group by r_fee_est_dt order by r_fee_est_dt" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectAccountEstFeeList]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 입출금예정-대여료
	 */
	public Vector getSelectAccountEstFeePayList(String fee_end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select rc_dt 일자, sum(rc_amt) 금액 " + " from scd_fee " + " where rc_yn='1' and tm_st2<>'4'  "
				+ " and rc_dt like substr(replace('" + fee_end_dt + "','-',''),1,6)||'%' "
				+ " group by rc_dt order by rc_dt" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectAccountEstFeePayList]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 입출금예정-대여료
	 */
	public Vector getSelectAccountEstFeeCmsList(String fee_end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select adate 일자, sum(aoutamt) 금액 " + " from acms " + " where aoutamt > 0"
				+ " and adate like substr(replace('" + fee_end_dt + "','-',''),1,6)||'%' "
				+ " group by adate order by adate" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectAccountEstFeeCmsList]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 입출금예정-대여료
	 */
	public Vector getSelectAccountEstFeeList_20120130(String fee_end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select SUBSTR(a.b_dt,7,2) 일자, \n"
				+ "        sum(DECODE(substr(a.b_dt,1,6), TO_CHAR(ADD_MONTHS(TO_DATE('" + fee_end_dt
				+ "','YYYY-MM'),-2),'YYYYMM'),  a.rc_amt)) 전전월, \n"
				+ "        sum(DECODE(substr(a.b_dt,1,6), TO_CHAR(ADD_MONTHS(TO_DATE('" + fee_end_dt
				+ "','YYYY-MM'),-1),'YYYYMM'),  a.rc_amt)) 전월, \n"
				+ "        sum(DECODE(substr(a.b_dt,1,6), substr(replace('" + fee_end_dt
				+ "','-',''),1,6),  a.rc_amt)) 당월, \n"
				+ "        sum(DECODE(a.adate,'',0,DECODE(substr(a.b_dt,1,6), TO_CHAR(ADD_MONTHS(TO_DATE('" + fee_end_dt
				+ "','YYYY-MM'),-2),'YYYYMM'),  a.rc_amt))) 전전월_CMS, \n"
				+ "        sum(DECODE(a.adate,'',0,DECODE(substr(a.b_dt,1,6), TO_CHAR(ADD_MONTHS(TO_DATE('" + fee_end_dt
				+ "','YYYY-MM'),-1),'YYYYMM'),  a.rc_amt))) 전월_CMS, \n"
				+ "        sum(DECODE(a.adate,'',0,DECODE(substr(a.b_dt,1,6), substr(replace('" + fee_end_dt
				+ "','-',''),1,6),  a.rc_amt))) 당월_CMS, \n"
				+ "        sum(DECODE(a.adate,'',DECODE(substr(a.b_dt,1,6), TO_CHAR(ADD_MONTHS(TO_DATE('" + fee_end_dt
				+ "','YYYY-MM'),-2),'YYYYMM'),  a.rc_amt))) 전전월_기타, \n"
				+ "        sum(DECODE(a.adate,'',DECODE(substr(a.b_dt,1,6), TO_CHAR(ADD_MONTHS(TO_DATE('" + fee_end_dt
				+ "','YYYY-MM'),-1),'YYYYMM'),  a.rc_amt))) 전월_기타, \n"
				+ "        sum(DECODE(a.adate,'',DECODE(substr(a.b_dt,1,6), substr(replace('" + fee_end_dt
				+ "','-',''),1,6),  a.rc_amt))) 당월_기타, \n"
				+ "        sum(DECODE(a.rc_yn,'0', a.fee_s_amt+a.fee_v_amt)) 당월예정, \n"
				+ "        sum(DECODE(a.CODE,'',0,DECODE(a.rc_yn,'0', a.fee_s_amt+a.fee_v_amt))) 당월예정_CMS, \n"
				+ "        sum(DECODE(a.CODE,'',DECODE(a.rc_yn,'0', a.fee_s_amt+a.fee_v_amt))) 당월예정_기타  \n" +

				" from   (" +
				// 전전월,전월,해당월 입금
				"		  SELECT nvl(b.aipdate,a.rc_dt) AS b_dt, '' CODE, a.* \n"
				+ "         FROM   scd_fee a, cms.file_ea21 b \n"
				+ "         where  a.bill_yn='Y'  and a.tm_st2<>'4' \n"
				+ "                AND a.rc_dt BETWEEN TO_CHAR(TO_DATE('" + fee_end_dt
				+ "'||'-01','YYYY-MM-DD')-100,'YYYYMMDD') AND TO_CHAR(TO_DATE('" + fee_end_dt
				+ "'||'-01','YYYY-MM-DD')+35,'YYYYMMDD') "
				+ "                and a.rent_l_cd=b.user_no(+) and a.adate=b.adate(+) "
				+ "                and substr(nvl(b.aipdate,a.rc_dt),1,6) IN (substr(replace('" + fee_end_dt
				+ "','-',''),1,6), \n"
				+ "                                                           TO_CHAR(ADD_MONTHS(TO_DATE('" + fee_end_dt
				+ "','YYYY-MM'),-1),'YYYYMM'), \n"
				+ "                                                           TO_CHAR(ADD_MONTHS(TO_DATE('" + fee_end_dt
				+ "','YYYY-MM'),-2),'YYYYMM') ) \n" + "         UNION all \n" +
				// 해당월 예정
				"         SELECT decode(b.cms_primary_seq,'',a.r_fee_est_dt,F_getCmsIncomDt(a.r_fee_est_dt)) AS b_dt, B.cms_primary_seq CODE, a.* \n"
				+ "         FROM   scd_fee a, ( SELECT * FROM CMS.MEMBER_USER WHERE cms_status = '3') b \n"
				+ "         where  a.bill_yn='Y' AND a.rc_amt=0  and a.tm_st2<>'4' \n"
				+ "                AND a.rent_l_cd=b.cms_primary_seq(+) \n"
				+ "                AND a.r_fee_est_dt BETWEEN TO_CHAR(TO_DATE('" + fee_end_dt
				+ "'||'-01','YYYY-MM-DD')-5,'YYYYMMDD') AND TO_CHAR(TO_DATE('" + fee_end_dt
				+ "'||'-01','YYYY-MM-DD')+35,'YYYYMMDD') "
				+ "                AND decode(b.cms_primary_seq,'',a.r_fee_est_dt,F_getCmsIncomDt(a.r_fee_est_dt)) like substr(replace('"
				+ fee_end_dt + "','-',''),1,6)||'%' \n"
				+ "                AND decode(b.cms_primary_seq,'',a.r_fee_est_dt,F_getCmsIncomDt(a.r_fee_est_dt))>=TO_CHAR(sysdate,'YYYYMMDD') \n"
				+ "        ) a  \n" +

				" group by SUBSTR(a.b_dt,7,2)  \n" + " order by SUBSTR(a.b_dt,7,2)  \n" + " ";

		try {

			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectAccountEstFeeList_20120130]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 사용본거지 최초등록 차량 리스트 조회
	 */
	public Vector getCarExtCngExcelList4(String car_ext) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select distinct" + " b.car_mng_id, b.car_doc_no, b.car_no, b.car_nm, b.init_reg_dt, b.first_car_no"
				+ " from (select car_mng_id from cont where rent_l_cd not like 'RM%' group by car_mng_id) a, car_reg b "
				+ " where a.car_mng_id=b.car_mng_id" + " and b.first_car_no like '%허%'" + " ";

		if (car_ext.equals("1")) {
			query += " and (b.acq_is_o like '%서울%' or b.acq_is_o like '%영등포%')";
		} else if (car_ext.equals("2")) {
			query += " and (b.acq_is_o like '%경기%' or b.acq_is_o like '%파주%')";
		} else if (car_ext.equals("3")) {
			query += " and (b.acq_is_o like '%부산%' or b.acq_is_o like '%연제%')";
		} else if (car_ext.equals("4")) {
			query += " and b.acq_is_o like '%김해%'";
		} else if (car_ext.equals("5")) {
			query += " and (b.acq_is_o like '%대전%' or b.acq_is_o like '%유성%')";
		} else if (car_ext.equals("6")) {
			query += " and b.acq_is_o like '%포천%'";
		} else if (car_ext.equals("7")) {
			query += " and b.acq_is_o like '%인천%'";
		} else if (car_ext.equals("8")) {
			query += " and b.acq_is_o like '%제주%'";
		} else if (car_ext.equals("9")) {
			query += " and b.acq_is_o like '%광주%'";
		} else if (car_ext.equals("10")) {
			query += " and b.acq_is_o like '%대구%'";
		}

		query += " order by b.init_reg_dt, b.car_doc_no";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getCarExtCngExcelList4]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 마스타자동차 제출자료
	 */
	public Vector getMasterCarComAcarExcelList() {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select decode(nvl(b.m1_chk, ''),'1','요청',' ') 요청, \n"
				+ " '등록' 구분, b.init_reg_dt 등록일자, b.car_no 차량번호, b.car_nm||' '||d.car_name 차종, replace(e.nm,'자동차','') 제조사, substr(b.init_reg_dt,1,4) as 연식, \n"
				+ " decode(d.auto_yn,'Y','오토',decode(sign(instr(c.opt,'자동변속기')),1,'오토','수동')) 미션, \n"
				+ " e2.nm as 연료, \n" + " o.firm_nm 고객, \n" + " nvl(o.o_tel,o.con_agnt_o_tel) 사무실, \n"
				+ " nvl(o.m_tel,o.con_agnt_m_tel) 휴대폰, \n" + " jj.mgr_m_tel  실운전자, \n" + " o.o_addr 주소, \n"
				+ " o.CON_AGNT_EMAIL 이메일, \n" + " j.ins_com_nm 보험사, h.ins_start_dt||'~'||h.ins_exp_dt 대여기간, \n"
				+ " '자배법시행령에서 정한 금액' 대인배상Ⅰ, \n" + " decode(h.vins_pcp_kd,'1','무한','2','유한') 대인배상Ⅱ, \n"
				+ " decode(h.vins_gcp_kd,'1','3000만원','2','1500만원',  '3','1억원',   '4','5000만원','5','1000만원','미가입') 대물배상, \n"
				+ " decode(h.vins_bacdt_kd,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_사망장애, \n"
				+ " decode(h.vins_bacdt_kc2,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_부상, \n"
				+ " decode(h.vins_cacdt_car_amt,0,'',h.vins_cacdt_car_amt||'만원') 자차차량, \n"
				+ " decode(h.vins_cacdt_me_amt,0,'',h.vins_cacdt_me_amt||'만원') 자차자기부담금, \n"
				+ " decode(h.vins_canoisr_amt,0,'','가입') 무보험, \n" + " decode(h.car_use,'1','영업용','2','업무용') 보험종류, \n"
				+ " decode(h.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상') 연령범위, \n"
				+ " decode(h.air_ds_yn,'Y',1,0)+decode(h.air_as_yn,'Y',1,0) 에어백, \n"
				+ " h.con_f_nm 피보험자, b.init_reg_dt 최초등록일, hh.nm 등록지역, \n"
				+ " decode(f.rent_way,'1','일반식','기본식') 대여방식, g.user_nm 관리담당자, g.user_m_tel 연락처 \n"
				+ " from cont a, car_reg b, car_etc c, car_nm d, client o, \n"
				+ "      (select * from car_mgr where mgr_st='차량이용자') jj, \n"
				+ "      (select * from code where c_st='0032') hh, \n"
				+ "      (select * from code where c_st='0001') e, \n"
				+ "      (select * from code where c_st='0039') e2, \n"
				+ "      (select a.* from insur a, (select car_mng_id, max(ins_exp_dt) ins_exp_dt from insur group by car_mng_id) b where a.car_mng_id=b.car_mng_id and a.ins_exp_dt=b.ins_exp_dt) h, \n"
				+ "      ins_com j, fee f, users g \n" + " where \n" + " nvl(a.use_yn,'Y')='Y' \n"
				+ " and nvl(b.prepare,'0') not in ('4','5') \n" + " and a.car_mng_id=b.car_mng_id \n"
				+ " and a.rent_l_cd=c.rent_l_cd \n" + " and c.car_id=d.car_id and c.car_seq=d.car_seq \n"
				+ " and d.car_comp_id=e.code \n" + " and a.client_id=o.client_id \n"
				+ " and a.car_mng_id=h.car_mng_id(+) \n" + " and h.ins_com_id=j.ins_com_id(+) \n"
				+ " and b.car_ext =hh.nm_cd \n" + " and b.fuel_kd =e2.nm_cd \n"
				+ " and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and f.rent_st='1' \n"
				+ " and a.rent_mng_id=jj.rent_mng_id(+) and a.rent_l_cd=jj.rent_l_cd(+) \n"
				+ " and nvl(a.mng_id,a.bus_id2)=g.user_id" + " ";

		query += " order by d.jg_code";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getMasterCarComAcarExcelList]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 마스타자동차 제출자료
	 */
	public Vector getMasterCarComAcarExcelList(String s_kd, String st_dt, String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select '1' gg, decode(nvl(b.m1_chk, ''),'1','요청',' ') 요청, \n"
				+ " '등록' 구분, b.init_reg_dt 등록일자,  b.car_no 차량번호, b.car_nm||' '||d.car_name 차종, replace(e.nm,'자동차','') 제조사, substr(b.init_reg_dt,1,4) as 연식, \n"
				+ " decode(d.auto_yn,'Y','오토',decode(sign(instr(c.opt,'자동변속기')),1,'오토','수동')) 미션, \n"
				+ " e2.nm as 연료, \n" + " o.firm_nm 고객, \n" + " nvl(o.o_tel,o.con_agnt_o_tel) 사무실, \n"
				+ " nvl(o.m_tel,o.con_agnt_m_tel) 휴대폰, \n" + " jj.mgr_m_tel  실운전자, \n" + " o.o_addr 주소, \n"
				+ " o.CON_AGNT_EMAIL 이메일, \n" + " j.ins_com_nm 보험사, h.ins_start_dt||'~'||h.ins_exp_dt 대여기간, \n"
				+ " '자배법시행령에서 정한 금액' 대인배상Ⅰ, \n" + " decode(h.vins_pcp_kd,'1','무한','2','유한') 대인배상Ⅱ, \n"
				+ " decode(h.vins_gcp_kd,'1','3000만원','2','1500만원',  '3','1억원',   '4','5000만원','5','1000만원','미가입') 대물배상, \n"
				+ " decode(h.vins_bacdt_kd,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_사망장애, \n"
				+ " decode(h.vins_bacdt_kc2,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_부상, \n"
				+ " decode(h.vins_cacdt_car_amt,0,'',h.vins_cacdt_car_amt||'만원') 자차차량, \n"
				+ " decode(h.vins_cacdt_me_amt,0,'',h.vins_cacdt_me_amt||'만원') 자차자기부담금, \n"
				+ " decode(h.vins_canoisr_amt,0,'','가입') 무보험, \n" + " decode(h.car_use,'1','영업용','2','업무용') 보험종류, \n"
				+ " decode(h.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상') 연령범위, \n"
				+ " decode(h.air_ds_yn,'Y',1,0)+decode(h.air_as_yn,'Y',1,0) 에어백, \n"
				+ " h.con_f_nm 피보험자, b.init_reg_dt 최초등록일, hh.nm 등록지역, \n"
				+ " decode(f.rent_way,'1','일반식','기본식') 대여방식, g.user_nm 관리담당자, g.user_m_tel 연락처 \n"
				+ " from cont a, car_reg b, car_etc c, car_nm d, client o, \n"
				+ "      (select * from car_mgr where mgr_st='차량이용자') jj, \n"
				+ "      (select * from code where c_st='0032') hh, \n"
				+ "      (select * from code where c_st='0001') e, \n"
				+ "      (select * from code where c_st='0039') e2, \n"
				+ "      (select a.* from insur a, (select car_mng_id, max(ins_exp_dt) ins_exp_dt from insur group by car_mng_id) b \n"
				+ "         where a.car_mng_id=b.car_mng_id and a.ins_exp_dt=b.ins_exp_dt \n" + "      ) h, \n"
				+ " ins_com j, fee f, users g \n" + " where \n" + " nvl(a.use_yn,'Y')='Y' \n"
				+ " and nvl(b.prepare,'0') not in ('4','5') \n" + " and a.car_mng_id=b.car_mng_id \n"
				+ " and a.rent_l_cd=c.rent_l_cd \n" + " and c.car_id=d.car_id and c.car_seq=d.car_seq \n"
				+ " and d.car_comp_id=e.code \n" + " and a.client_id=o.client_id \n"
				+ " and a.car_mng_id=h.car_mng_id(+) \n" + " and h.ins_com_id=j.ins_com_id(+) \n"
				+ " and b.car_ext=hh.nm_cd \n" + " and b.fuel_kd=e2.nm_cd \n"
				+ " and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and f.rent_st='1' \n"
				+ " and a.rent_mng_id=jj.rent_mng_id(+) and a.rent_l_cd=jj.rent_l_cd(+) \n"
				+ " and nvl(a.mng_id,a.bus_id2)=g.user_id" + " ";

		if (s_kd.equals("1"))
			query += " and b.init_reg_dt = to_char(sysdate,'YYYYMMDD')";
		else if (s_kd.equals("3"))
			query += " and b.init_reg_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if (s_kd.equals("4"))
			query += " and b.init_reg_dt = to_char(to_date(to_char(sysdate,'YYYYMMDD')) - 1, 'yyyymmdd') ";
		else if (s_kd.equals("5"))
			query += " and b.init_reg_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
		else if (s_kd.equals("2")) {
			if (!st_dt.equals("") && end_dt.equals(""))
				query += " and b.init_reg_dt like replace('" + st_dt + "%', '-','')";
			if (!st_dt.equals("") && !end_dt.equals(""))
				query += " and b.init_reg_dt between replace('" + st_dt + "', '-','') and replace('" + end_dt
						+ "', '-','')";
		}

		query += " union all";

		query += " select '2' gg, decode(nvl(b.m1_chk, ''),'1','요청',' ') 요청, \n"
				+ " '매각' 구분, s.jan_pr_dt 등록일자, b.car_no 차량번호, b.car_nm||' '||d.car_name 차종, replace(e.nm,'자동차','') 제조사, substr(b.init_reg_dt,1,4) as 연식, \n"
				+ " decode(d.auto_yn,'Y','오토',decode(sign(instr(c.opt,'자동변속기')),1,'오토','수동')) 미션, \n"
				+ " e2.nm as 연료, \n" + " o.firm_nm 고객, \n" + " nvl(o.o_tel,o.con_agnt_o_tel) 사무실, \n"
				+ " nvl(o.m_tel,o.con_agnt_m_tel) 휴대폰, \n" + " jj.mgr_m_tel  실운전자, \n" + " o.o_addr 주소, \n"
				+ " o.CON_AGNT_EMAIL 이메일, \n" + " j.ins_com_nm 보험사, h.ins_start_dt||'~'||h.ins_exp_dt 대여기간, \n"
				+ " '자배법시행령에서 정한 금액' 대인배상Ⅰ, \n" + " decode(h.vins_pcp_kd,'1','무한','2','유한') 대인배상Ⅱ, \n"
				+ " decode(h.vins_gcp_kd,'1','3000만원','2','1500만원',  '3','1억원',   '4','5000만원','5','1000만원','미가입') 대물배상, \n"
				+ " decode(h.vins_bacdt_kd,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_사망장애, \n"
				+ " decode(h.vins_bacdt_kc2,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_부상, \n"
				+ " decode(h.vins_cacdt_car_amt,0,'',h.vins_cacdt_car_amt||'만원') 자차차량, \n"
				+ " decode(h.vins_cacdt_me_amt,0,'',h.vins_cacdt_me_amt||'만원') 자차자기부담금, \n"
				+ " decode(h.vins_canoisr_amt,0,'','가입') 무보험, \n" + " decode(h.car_use,'1','영업용','2','업무용') 보험종류, \n"
				+ " decode(h.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상') 연령범위, \n"
				+ " decode(h.air_ds_yn,'Y',1,0)+decode(h.air_as_yn,'Y',1,0) 에어백, \n"
				+ " h.con_f_nm 피보험자, b.init_reg_dt 최초등록일, hh.nm 등록지역, \n"
				+ " decode(f.rent_way,'1','일반식','기본식') 대여방식, g.user_nm 관리담당자, g.user_m_tel 연락처 \n"
				+ " from cont a, car_reg b, car_etc c, car_nm d, client o, \n"
				+ "      (select * from car_mgr where mgr_st='차량이용자') jj, \n"
				+ "      (select * from code where c_st='0032') hh, \n"
				+ "      (select * from code where c_st='0001') e, \n"
				+ "      (select * from code where c_st='0039') e2, \n"
				+ "      (select a.* from insur a, (select car_mng_id, max(ins_exp_dt) ins_exp_dt from insur group by car_mng_id) b \n"
				+ "         where a.car_mng_id=b.car_mng_id and a.ins_exp_dt=b.ins_exp_dt \n" + "      ) h, \n"
				+ "      ins_com j, sui s, \n"
				+ "      (select car_mng_id, max(rent_dt) rent_dt, max(reg_dt) reg_dt from cont where rent_l_cd not like 'RM%' group by car_mng_id) n, fee f, users g\n"
				+ " where \n" + " nvl(a.use_yn,'Y')='N' \n" + " and nvl(b.prepare,'0') not in ('4','5','9') \n"
				+ " and a.car_mng_id=b.car_mng_id \n" + " and a.rent_l_cd=c.rent_l_cd \n"
				+ " and c.car_id=d.car_id and c.car_seq=d.car_seq \n" + " and d.car_comp_id=e.code \n"
				+ " and a.client_id=o.client_id \n" + " and a.car_mng_id=h.car_mng_id(+) \n"
				+ " and h.ins_com_id=j.ins_com_id(+) \n" + " and a.car_mng_id=s.car_mng_id"
				+ " and b.car_ext=hh.nm_cd \n" + " and b.fuel_kd=e2.nm_cd \n"
				+ " and a.car_mng_id=n.car_mng_id and a.rent_dt=n.rent_dt and a.reg_dt=n.reg_dt"
				+ " and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and f.rent_st='1' \n"
				+ " and a.rent_mng_id=jj.rent_mng_id(+) and a.rent_l_cd=jj.rent_l_cd(+) \n"
				+ " and nvl(a.mng_id,a.bus_id2)=g.user_id" + " ";

		if (s_kd.equals("1"))
			query += " and s.jan_pr_dt = to_char(sysdate,'YYYYMMDD')";
		else if (s_kd.equals("3"))
			query += " and s.jan_pr_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if (s_kd.equals("4"))
			query += " and s.jan_pr_dt = to_char(to_date(to_char(sysdate,'YYYYMMDD')) - 1, 'yyyymmdd') ";
		else if (s_kd.equals("5"))
			query += " and s.jan_pr_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
		else if (s_kd.equals("2")) {
			if (!st_dt.equals("") && end_dt.equals(""))
				query += " and s.jan_pr_dt like replace('" + st_dt + "%', '-','')";
			if (!st_dt.equals("") && !end_dt.equals(""))
				query += " and s.jan_pr_dt between replace('" + st_dt + "', '-','') and replace('" + end_dt
						+ "', '-','')";
		}

		query += " union all";

		query += " select '3' gg, decode(nvl(b.m1_chk, ''),'1','요청',' ') 요청, \n"
				+ "  '검사' 구분, case when b.m1_chk ='1' then b.m1_dt else ' ' end 등록일자,  b.car_no 차량번호, b.car_nm||' '||d.car_name 차종, replace(e.nm,'자동차','') 제조사, substr(b.init_reg_dt,1,4) as 연식, \n"
				+ " decode(d.auto_yn,'Y','오토',decode(sign(instr(c.opt,'자동변속기')),1,'오토','수동')) 미션, \n"
				+ " e2.nm as 연료, \n" + " o.firm_nm 고객, \n" + " nvl(o.o_tel,o.con_agnt_o_tel) 사무실, \n"
				+ " nvl(o.m_tel,o.con_agnt_m_tel) 휴대폰, \n" + " jj.mgr_m_tel  실운전자, \n" + " o.o_addr 주소, \n"
				+ " o.CON_AGNT_EMAIL 이메일, \n" + " j.ins_com_nm 보험사, h.ins_start_dt||'~'||h.ins_exp_dt 대여기간, \n"
				+ " '자배법시행령에서 정한 금액' 대인배상Ⅰ, \n" + " decode(h.vins_pcp_kd,'1','무한','2','유한') 대인배상Ⅱ, \n"
				+ " decode(h.vins_gcp_kd,'1','3000만원','2','1500만원',  '3','1억원',   '4','5000만원','5','1000만원','미가입') 대물배상, \n"
				+ " decode(h.vins_bacdt_kd,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_사망장애, \n"
				+ " decode(h.vins_bacdt_kc2,'1','3억원',   '2','1억5천만원','3','3000만원','4','1500만원','5','5000만원','6','1억원','미가입') 자기신체사고_부상, \n"
				+ " decode(h.vins_cacdt_car_amt,0,'',h.vins_cacdt_car_amt||'만원') 자차차량, \n"
				+ " decode(h.vins_cacdt_me_amt,0,'',h.vins_cacdt_me_amt||'만원') 자차자기부담금, \n"
				+ " decode(h.vins_canoisr_amt,0,'','가입') 무보험, \n" + " decode(h.car_use,'1','영업용','2','업무용') 보험종류, \n"
				+ " decode(h.age_scp,'1','21세이상','2','26세이상','3','모든운전자','4','24세이상') 연령범위, \n"
				+ " decode(h.air_ds_yn,'Y',1,0)+decode(h.air_as_yn,'Y',1,0) 에어백, \n"
				+ " h.con_f_nm 피보험자, b.init_reg_dt 최초등록일, hh.nm 등록지역, \n"
				+ " decode(f.rent_way,'1','일반식','기본식') 대여방식, g.user_nm 관리담당자, g.user_m_tel 연락처 \n"
				+ " from cont a, car_reg b, car_etc c, car_nm d, client o, \n"
				+ "      (select * from car_mgr where mgr_st='차량이용자') jj, \n"
				+ "      (select * from code where c_st='0032') hh, \n"
				+ "      (select * from code where c_st='0001') e, \n"
				+ "      (select * from code where c_st='0039') e2, \n"
				+ "      (select a.* from insur a, (select car_mng_id, max(ins_exp_dt) ins_exp_dt from insur group by car_mng_id) b \n"
				+ "         where a.car_mng_id=b.car_mng_id and a.ins_exp_dt=b.ins_exp_dt \n" + "      ) h, \n"
				+ "      ins_com j, fee f, users g \n" + " where \n" + " nvl(a.use_yn,'Y')='Y' \n"
				+ " and nvl(b.prepare,'0') not in ('4','5','9') \n" + " and a.car_mng_id=b.car_mng_id \n"
				+ " and a.rent_l_cd=c.rent_l_cd \n" + " and c.car_id=d.car_id and c.car_seq=d.car_seq \n"
				+ " and d.car_comp_id=e.code \n" + " and a.client_id=o.client_id \n"
				+ " and a.car_mng_id=h.car_mng_id(+) \n" + " and h.ins_com_id=j.ins_com_id(+) \n"
				+ " and b.car_ext=hh.nm_cd \n" + " and b.fuel_kd=e2.nm_cd \n"
				+ " and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd and f.rent_st='1' \n"
				+ " and a.rent_mng_id=jj.rent_mng_id(+) and a.rent_l_cd=jj.rent_l_cd(+) \n"
				+ " and nvl(a.mng_id,a.bus_id2)=g.user_id and b.m1_chk = '1' " + " ";

		if (s_kd.equals("1"))
			query += " and b.m1_dt = to_char(sysdate,'YYYYMMDD')";
		else if (s_kd.equals("3"))
			query += " and b.m1_dt like to_char(sysdate,'YYYYMM')||'%'";
		else if (s_kd.equals("4"))
			query += " and b.m1_dt = to_char(to_date(to_char(sysdate,'YYYYMMDD')) - 1, 'yyyymmdd') ";
		else if (s_kd.equals("5"))
			query += " and b.m1_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
		else if (s_kd.equals("2")) {
			if (!st_dt.equals("") && end_dt.equals(""))
				query += " and b.m1_dt like replace('" + st_dt + "%', '-','')";
			if (!st_dt.equals("") && !end_dt.equals(""))
				query += " and b.m1_dt between replace('" + st_dt + "', '-','') and replace('" + end_dt + "', '-','')";
		}

		query += " order by  1,  4  ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getMasterCarComAcarExcelList]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 대한의사복지공제회 연체리스트
	 */
	public Vector getSelectFeeArrearYmdList(String min_mon) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select '상호' firm_nm, '차량번호' car_no, '입금예정일' est_day, "
				+ "        to_number(to_char(add_months(to_date('" + min_mon + "','YYYYMM'),0),'YYYYMM')) as fee_amt0,"
				+ "        to_number(to_char(add_months(to_date('" + min_mon + "','YYYYMM'),1),'YYYYMM')) as fee_amt1,"
				+ "        to_number(to_char(add_months(to_date('" + min_mon + "','YYYYMM'),2),'YYYYMM')) as fee_amt2,"
				+ "        to_number(to_char(add_months(to_date('" + min_mon + "','YYYYMM'),3),'YYYYMM')) as fee_amt3,"
				+ "        to_number(to_char(add_months(to_date('" + min_mon + "','YYYYMM'),4),'YYYYMM')) as fee_amt4,"
				+ "        to_number(to_char(add_months(to_date('" + min_mon + "','YYYYMM'),5),'YYYYMM')) as fee_amt5,"
				+ "        to_number(to_char(add_months(to_date('" + min_mon + "','YYYYMM'),6),'YYYYMM')) as fee_amt6,"
				+ "        to_number(to_char(add_months(to_date('" + min_mon + "','YYYYMM'),7),'YYYYMM')) as fee_amt7,"
				+ "        to_number(to_char(add_months(to_date('" + min_mon + "','YYYYMM'),8),'YYYYMM')) as fee_amt8,"
				+ "        0 dly_amt, 0 tot_amt " + " from   dual" +

				" union all" +

				" select * " + " from   ( " + "          select"
				+ "                 c.firm_nm, d.car_no, nvl(f.cms_day,e.fee_est_day)||decode(f.rent_l_cd,'','','(CMS)') est_day,"
				+ "                 s0.fee_amt as fee_amt0, gg.fee_amt as fee_amt1, g.fee_amt as fee_amt2, h.fee_amt as fee_amt3, i.fee_amt as fee_amt4, j.fee_amt as fee_amt5, "
				+ "                 s6.fee_amt as fee_amt6, s7.fee_amt as fee_amt7, s8.fee_amt as fee_amt8, "
				+ "                 (nvl(k.dly_amt,0)-nvl(l.pay_amt,0)) as dly_amt,"
				+ "                 nvl(s0.fee_amt,0)+nvl(s6.fee_amt,0)+nvl(gg.fee_amt,0)+nvl(g.fee_amt,0)+nvl(h.fee_amt,0)+nvl(i.fee_amt,0)+nvl(j.fee_amt,0)+nvl(k.dly_amt,0)-nvl(l.pay_amt,0) tot_amt"
				+ "          from   cont a, car_mgr b, client c, car_reg d, fee e, cms_mng f, users m, car_etc p, "
				+ "                 (select rent_l_cd, sum(fee_s_amt+fee_v_amt) fee_amt from scd_fee where rc_yn='0'  and tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and fee_est_dt like to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),0),'YYYYMM')||'%' group by rent_l_cd) s0,"
				+ "                 (select rent_l_cd, sum(fee_s_amt+fee_v_amt) fee_amt from scd_fee where rc_yn='0'  and tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and fee_est_dt like to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),1),'YYYYMM')||'%' group by rent_l_cd) gg,"
				+ "                 (select rent_l_cd, sum(fee_s_amt+fee_v_amt) fee_amt from scd_fee where rc_yn='0'  and tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and fee_est_dt like to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),2),'YYYYMM')||'%' group by rent_l_cd) g,"
				+ "                 (select rent_l_cd, sum(fee_s_amt+fee_v_amt) fee_amt from scd_fee where rc_yn='0'  and tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and fee_est_dt like to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),3),'YYYYMM')||'%' group by rent_l_cd) h,"
				+ "                 (select rent_l_cd, sum(fee_s_amt+fee_v_amt) fee_amt from scd_fee where rc_yn='0'  and tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and fee_est_dt like to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),4),'YYYYMM')||'%' group by rent_l_cd) i,"
				+ "                 (select rent_l_cd, sum(fee_s_amt+fee_v_amt) fee_amt from scd_fee where rc_yn='0'  and tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and fee_est_dt like to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),5),'YYYYMM')||'%' group by rent_l_cd) j,"
				+ "                 (select rent_l_cd, sum(fee_s_amt+fee_v_amt) fee_amt from scd_fee where rc_yn='0'  and tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and fee_est_dt like to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),6),'YYYYMM')||'%' group by rent_l_cd) s6,"
				+ "                 (select rent_l_cd, sum(fee_s_amt+fee_v_amt) fee_amt from scd_fee where rc_yn='0'  and tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and fee_est_dt like to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),7),'YYYYMM')||'%' group by rent_l_cd) s7,"
				+ "                 (select rent_l_cd, sum(fee_s_amt+fee_v_amt) fee_amt from scd_fee where rc_yn='0'  and tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and fee_est_dt like to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),8),'YYYYMM')||'%' group by rent_l_cd) s8,"
				+ "                 (select rent_l_cd, sum(dly_fee) dly_amt from scd_fee where tm_st2<>'4' group by rent_l_cd) k,"
				+ "                 (select rent_l_cd, sum(pay_amt) pay_amt from scd_dly group by rent_l_cd) l"
				+ "          where " + "                 (b.mgr_nm='조관수' or c.firm_nm like '%젊은의사%') and a.use_yn='Y'"
				+ "                 and b.mgr_st='회계관리자'" + "                 and a.rent_l_cd=b.rent_l_cd"
				+ "                 and a.client_id=c.client_id" + "                 and a.car_mng_id=d.car_mng_id"
				+ "                 and e.rent_st='1' and a.rent_l_cd=e.rent_l_cd"
				+ "                 and a.rent_l_cd=f.rent_l_cd(+)" + "                 and a.rent_l_cd=s0.rent_l_cd(+)"
				+ "                 and a.rent_l_cd=gg.rent_l_cd(+)" + "                 and a.rent_l_cd=g.rent_l_cd(+)"
				+ "                 and a.rent_l_cd=h.rent_l_cd(+)" + "                 and a.rent_l_cd=i.rent_l_cd(+)"
				+ "                 and a.rent_l_cd=j.rent_l_cd(+)" + "                 and a.rent_l_cd=s6.rent_l_cd(+)"
				+ "                 and a.rent_l_cd=s7.rent_l_cd(+)"
				+ "                 and a.rent_l_cd=s8.rent_l_cd(+)" + "                 and a.rent_l_cd=k.rent_l_cd(+)"
				+ "                 and a.rent_l_cd=l.rent_l_cd(+)" + "                 and a.rent_l_cd=p.rent_l_cd"
				+ "                 and a.bus_id2=m.user_id" + "          order by c.firm_nm, a.rent_start_dt"
				+ "        )";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectFeeArrearYmdList]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 고객별 연체리스트
	 */
	public Vector getSelectFeeArrearYmdSsnList(String ssn, String min_mon) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select '상호' firm_nm, '차량번호' car_no, '입금예정일' est_day, " + " to_number(to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),0),'YYYYMM')) as fee_amt0," + " to_number(to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),1),'YYYYMM')) as fee_amt1," + " to_number(to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),2),'YYYYMM')) as fee_amt2," + " to_number(to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),3),'YYYYMM')) as fee_amt3," + " to_number(to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),4),'YYYYMM')) as fee_amt4," + " to_number(to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),5),'YYYYMM')) as fee_amt5," + " to_number(to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),6),'YYYYMM')) as fee_amt6," + " to_number(to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),7),'YYYYMM')) as fee_amt7," + " to_number(to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),8),'YYYYMM')) as fee_amt8," + " 0 dly_amt, 0 tot_amt from dual" + " union all"
				+ " select * from ( " + " select"
				+ " c.firm_nm, d.car_no, nvl(f.cms_day,e.fee_est_day)||decode(f.rent_l_cd,'','','(CMS)') est_day,"
				+ " s0.fee_amt as fee_amt0, gg.fee_amt as fee_amt1, g.fee_amt as fee_amt2, h.fee_amt as fee_amt3, i.fee_amt as fee_amt4, j.fee_amt as fee_amt5, "
				+ " s6.fee_amt as fee_amt6, s7.fee_amt as fee_amt7, s8.fee_amt as fee_amt8, "
				+ " (nvl(k.dly_amt,0)-nvl(l.pay_amt,0)) as dly_amt,"
				+ " nvl(s0.fee_amt,0)+nvl(s6.fee_amt,0)+nvl(gg.fee_amt,0)+nvl(g.fee_amt,0)+nvl(h.fee_amt,0)+nvl(i.fee_amt,0)+nvl(j.fee_amt,0)+nvl(k.dly_amt,0)-nvl(l.pay_amt,0) tot_amt"
				+ " from cont a, client c, car_reg d, fee e, cms_mng f, users m, car_etc p, "
				+ " (select rent_l_cd, sum(fee_s_amt+fee_v_amt) fee_amt from scd_fee where rc_yn='0'  and tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and substr(fee_est_dt,1,6) = to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),0),'YYYYMM') group by rent_l_cd) s0,"
				+ " (select rent_l_cd, sum(fee_s_amt+fee_v_amt) fee_amt from scd_fee where rc_yn='0'  and tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and substr(fee_est_dt,1,6) = to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),1),'YYYYMM') group by rent_l_cd) gg,"
				+ " (select rent_l_cd, sum(fee_s_amt+fee_v_amt) fee_amt from scd_fee where rc_yn='0'  and tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and substr(fee_est_dt,1,6) = to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),2),'YYYYMM') group by rent_l_cd) g,"
				+ " (select rent_l_cd, sum(fee_s_amt+fee_v_amt) fee_amt from scd_fee where rc_yn='0'  and tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and substr(fee_est_dt,1,6) = to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),3),'YYYYMM') group by rent_l_cd) h,"
				+ " (select rent_l_cd, sum(fee_s_amt+fee_v_amt) fee_amt from scd_fee where rc_yn='0'  and tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and substr(fee_est_dt,1,6) = to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),4),'YYYYMM') group by rent_l_cd) i,"
				+ " (select rent_l_cd, sum(fee_s_amt+fee_v_amt) fee_amt from scd_fee where rc_yn='0'  and tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and substr(fee_est_dt,1,6) = to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),5),'YYYYMM') group by rent_l_cd) j,"
				+ " (select rent_l_cd, sum(fee_s_amt+fee_v_amt) fee_amt from scd_fee where rc_yn='0'  and tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and substr(fee_est_dt,1,6) = to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),6),'YYYYMM') group by rent_l_cd) s6,"
				+ " (select rent_l_cd, sum(fee_s_amt+fee_v_amt) fee_amt from scd_fee where rc_yn='0'  and tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and substr(fee_est_dt,1,6) = to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),7),'YYYYMM') group by rent_l_cd) s7,"
				+ " (select rent_l_cd, sum(fee_s_amt+fee_v_amt) fee_amt from scd_fee where rc_yn='0'  and tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') and substr(fee_est_dt,1,6) = to_char(add_months(to_date('"
				+ min_mon + "','YYYYMM'),8),'YYYYMM') group by rent_l_cd) s8,"
				+ " (select rent_l_cd, sum(dly_fee) dly_amt from scd_fee where tm_st2<>'4' group by rent_l_cd) k,"
				+ " (select rent_l_cd, sum(pay_amt) pay_amt from scd_dly group by rent_l_cd) l" + " where"
				+ " TEXT_DECRYPT(c.ssn, 'pw' ) =replace('" + ssn + "','-','') and a.use_yn='Y'"
				+ " and a.client_id=c.client_id" + " and a.car_mng_id=d.car_mng_id"
				+ " and e.rent_st='1' and a.rent_l_cd=e.rent_l_cd" + " and a.rent_l_cd=f.rent_l_cd(+)"
				+ " and a.rent_l_cd=s0.rent_l_cd(+)" + " and a.rent_l_cd=gg.rent_l_cd(+)"
				+ " and a.rent_l_cd=g.rent_l_cd(+)" + " and a.rent_l_cd=h.rent_l_cd(+)"
				+ " and a.rent_l_cd=i.rent_l_cd(+)" + " and a.rent_l_cd=j.rent_l_cd(+)"
				+ " and a.rent_l_cd=s6.rent_l_cd(+)" + " and a.rent_l_cd=s7.rent_l_cd(+)"
				+ " and a.rent_l_cd=s8.rent_l_cd(+)" + " and a.rent_l_cd=k.rent_l_cd(+)"
				+ " and a.rent_l_cd=l.rent_l_cd(+)" + " and a.rent_l_cd=p.rent_l_cd" + " and a.bus_id2=m.user_id"
				+ " order by c.firm_nm, a.rent_start_dt" + " )";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectFeeArrearYmdSsnList]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 대한의사복지공제회 연체리스트
	 */
	public String getSelectFeeArrearYmdMinMon() {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String min_mon = "";
		String query = "";

		query = " select min(substr(r_fee_est_dt,1,6)) min_mon \n" + " from   cont a, car_mgr b, client c, scd_fee d \n"
				+ " where  (b.mgr_nm='조관수' or c.firm_nm like '%젊은의사%') and a.use_yn='Y' \n"
				+ "        and b.mgr_st='회계관리자' \n"
				+ "        and d.rc_yn='0'  and d.tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') \n"
				+ "        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"
				+ "        and a.client_id=c.client_id \n"
				+ "        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			if (rs.next()) {
				min_mon = rs.getString("min_mon") == null ? "" : rs.getString("min_mon");
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectFeeArrearYmdMinMon]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return min_mon;
		}
	}

	/**
	 * 고객별 연체리스트
	 */
	public String getSelectFeeArrearYmdMinMonSsn(String ssn) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String min_mon = "";
		String query = "";

		query = " select min(substr(r_fee_est_dt,1,6)) min_mon \n" + " from   cont a, client c, scd_fee d \n"
				+ " where  TEXT_DECRYPT(c.ssn, 'pw' ) =replace('" + ssn + "','-','') and a.use_yn='Y' \n"
				+ "        and d.rc_yn='0'  and d.tm_st2<>'4' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') \n"
				+ "        and a.client_id=c.client_id \n"
				+ "        and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			if (rs.next()) {
				min_mon = rs.getString("min_mon") == null ? "" : rs.getString("min_mon");
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectFeeArrearYmdMinMonSsn]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return min_mon;
		}
	}

	/**
	 * 거래처 네오엠fms 불합치 리스트 조회
	 */
	public Vector getClientTradeErrorList() {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.cd_partner, b.ln_partner, b.no_company, a.client_id, a.firm_nm, a.enp_no \n"
				+ " from client a,  neoe.MA_PARTNER  b, (select client_id from cont where use_yn='Y' and r_site is null group by client_id) c \n"
				+ " where \n" + " a.client_st<>'2' \n" + " and a.ven_code=b.cd_partner \n"
				+ " and a.client_id=c.client_id \n"
				+ " and (a.enp_no<>b.no_company or replace(replace(replace(substr(a.firm_nm,0,15),'주식회사',''),'(주)',''),' ','')<>replace(replace(replace(substr(b.ln_partner,0,15),'주식회사',''),'(주)',''),' ',''))\n"
				+ " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getClientTradeErrorList]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 외부요청자료 01
	 */
	public Vector getOutsideReq01(String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select " + " b.firm_nm, " + " decode(b.client_st,'1','법인','2','개인','개인사업자') client_st, "
				+ " b.bus_cdt, b.bus_itm, " + " a.cnt, " + " a.tot_amt, " + " a.jan_fee_amt, " + " a.fee_amt "
				+ " from " + " ( " + "  select "
				+ "        client_id, count(*) cnt, sum(tot_amt) tot_amt, sum(jan_fee_amt) jan_fee_amt, sum(fee_amt) fee_amt "
				+ "  from " 
				+ "  ( " 
				+ "      select "
				+ "           a.client_id, a.rent_l_cd, decode(c.tot_amt,0,pp_amt,c.tot_amt) tot_amt, decode(f.rent_l_cd,'',c.tot_amt,nvl(e.jan_fee_amt,0)) jan_fee_amt, (d.fee_s_amt+d.fee_v_amt) fee_amt "
				+ "      from cont a, "
				+ "           (select rent_l_cd, max(to_number(rent_st)) rent_st, sum((fee_s_amt+fee_v_amt)*con_mon) tot_amt, sum(pp_s_amt+pp_v_amt) pp_amt from fee group by rent_l_cd) c, "
				+ "           fee d, "
				+ "           (select rent_l_cd, count(*), sum(fee_s_amt+fee_v_amt) jan_fee_amt from scd_fee where nvl(bill_yn,'Y')='Y'  and tm_st2<>'4' and rc_yn='0' and fee_s_amt>0 group by rent_l_cd) e, "
				+ "           (select rent_l_cd, max(fee_est_dt) fee_est_dt from scd_fee where fee_s_amt>0  and tm_st2<>'4' group by rent_l_cd) f "
				+ "      where " + "           a.use_yn='Y' and a.car_st<>'2' "
				+ "           and a.rent_l_cd=c.rent_l_cd "
				+ "           and c.rent_l_cd=d.rent_l_cd and c.rent_st=d.rent_st "
				+ "           and a.rent_l_cd=e.rent_l_cd(+) " 
				+ "           and a.rent_l_cd=f.rent_l_cd(+) " 
				+ "  ) "
				+ "  group by client_id " 
				+ " ) a, client b " 
				+ " where a.client_id=b.client_id "
				+ " order by b.firm_nm" 
				+ " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getOutsideReq01]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 외부요청자료 02
	 */
	public Vector getOutsideReq02(String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select substr(fee_est_dt,1,6) ym, count(*) cnt, sum(fee_s_amt+fee_v_amt) amt " + " from   scd_fee "
				+ " where  nvl(bill_yn,'Y')='Y'  and tm_st2<>'4' and rc_yn='0' and fee_s_amt>0 "
				+ " group by substr(fee_est_dt,1,6) order by substr(fee_est_dt,1,6) " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getOutsideReq02]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 외부요청자료 03
	 */
	public Vector getOutsideReq03(String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select " + "        c.firm_nm, d.car_nm, d.car_no, a.cnt, a.amt " + " from "
				+ "        (select rent_l_cd, count(*) cnt, sum(fee_s_amt+fee_v_amt) amt " + "         from   scd_fee "
				+ "         where  nvl(bill_yn,'Y')='Y'  and tm_st2<>'4' and fee_s_amt>0 and rc_yn='0' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') "
				+ "         group by rent_l_cd) a, " + "        cont b, client c, car_reg d "
				+ " where  a.rent_l_cd=b.rent_l_cd " + "        and b.client_id=c.client_id "
				+ "        and b.car_mng_id=d.car_mng_id " + " order by c.firm_nm " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getOutsideReq03]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 외부요청자료 03
	 */
	public Vector getOutsideReq03_Cms(String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select " + "        c.firm_nm, d.car_nm, d.car_no, a.cnt, a.amt " + " from "
				+ "        (select /*+ rule */ "
				+ "                a.rent_l_cd, count(*) cnt, sum(a.fee_s_amt+a.fee_v_amt) amt "
				+ "         from   scd_fee a "
				+ "         where  nvl(a.bill_yn,'Y')='Y'  and a.tm_st2<>'4' and a.fee_s_amt>0 and a.rc_yn='0' and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD') "
				+ "         group by a.rent_l_cd) a, " + "        cont b, client c, car_reg d "
				+ " where  a.rent_l_cd=b.rent_l_cd " + "        and b.client_id=c.client_id "
				+ "        and b.car_mng_id=d.car_mng_id " + " order by c.firm_nm " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getOutsideReq03_Cms]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 영업담당자 엑셀파일을 이용한 배정시스템
	 */
	public void insertConvBusid2(Vector vt) {
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		String query1 = " delete from busid2";

		String query2 = " insert into busid2 (rent_l_cd, bus_id2) " + " select ?, user_id from users where user_nm=? ";

		try {
			conn.setAutoCommit(false);

			// 삭제
			pstmt1 = conn.prepareStatement(query1);
			pstmt1.executeUpdate();
			pstmt1.close();

			// 등록
			pstmt2 = conn.prepareStatement(query2);

			for (int i = 0; i < vt.size(); i++) {
				Hashtable ht = (Hashtable) vt.elementAt(i);
				pstmt2.setString(1, String.valueOf(ht.get("RENT_L_CD")));
				pstmt2.setString(2, String.valueOf(ht.get("BUS_NM2")));
				pstmt2.executeUpdate();
				break;
			}
			pstmt2.close();

			conn.commit();

		} catch (Exception e) {
			try {
				System.out.println("[AdminDatabase:insertConvBusid2(Vector vt)]" + e);
				conn.rollback();
				e.printStackTrace();
				flag = false;
			} catch (SQLException _ignored) {
			}
		} finally {
			try {
				conn.setAutoCommit(true);
				if (pstmt1 != null)
					pstmt1.close();
				if (pstmt2 != null)
					pstmt2.close();
			} catch (Exception ignore) {
			}
			closeConnection();
		}
	}

	/**
	 * 영업담당자 엑셀파일을 이용한 배정시스템
	 */
	public void deleteConvBusid2Case() {
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = " truncate table busid2 ";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
			try {
				System.out.println("[AdminDatabase:deleteConvBusid2Case]" + e);
				conn.rollback();
				e.printStackTrace();
				flag = false;
			} catch (SQLException _ignored) {
			}
		} finally {
			try {
				conn.setAutoCommit(true);
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
		}
	}

	/**
	 * 영업담당자 엑셀파일을 이용한 배정시스템
	 */
	public void insertConvBusid2Case(String rent_l_cd, String user_nm) {
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = " insert into busid2 (rent_l_cd, bus_id2) " + " select '" + rent_l_cd
				+ "', user_id from users where user_nm='" + user_nm + "' ";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
			try {
				System.out.println("[AdminDatabase:insertConvBusid2Case(String rent_l_cd, String user_nm)]" + e);
				conn.rollback();
				e.printStackTrace();
				flag = false;
			} catch (SQLException _ignored) {
			}
		} finally {
			try {
				conn.setAutoCommit(true);
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
		}
	}

	/**
	 * 담당자배정프로시저호출
	 */
	public String call_sp_conv_busid2_excel() {
		getConnection();

		CallableStatement cstmt = null;

		String sResult = "";

		String query = "{CALL P_CONV_BUSID2 }";

		try {

			// 프로시저 호출
			cstmt = conn.prepareCall(query);
			cstmt.execute();
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_conv_busid2_excel]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/**
	 * 예비 관리담당자배정프로시저호출 2016-03-29 Ryu
	 */
	public String call_sp_conv_mngid2_excel() {
		getConnection();

		CallableStatement cstmt = null;

		String sResult = "";

		String query = "{CALL P_CONV_MNGID2 }";

		try {

			// 프로시저 호출
			cstmt = conn.prepareCall(query);
			cstmt.execute();
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_conv_mngid2_excel]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/**
	 * 영업담당자 엑셀파일을 이용한 배정시스템 2016.15.16 Ryu
	 */
	public void insertConvBusid2Case_New(String rent_l_cd, String user_nm, String user_id) {
		getConnection();
		boolean flag = true;
		PreparedStatement pstmt = null;

		String query = " insert into busid2 (rent_l_cd, up_id, up_date, bus_id2) " + " select '" + rent_l_cd + "', '"
				+ user_id + "', sysdate,  user_id from users where user_nm='" + user_nm + "' ";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
			try {
				System.out.println("[AdminDatabase:insertConvBusid2Case_New(String rent_l_cd, String user_nm)]" + e);
				conn.rollback();
				e.printStackTrace();
				flag = false;
			} catch (SQLException _ignored) {
			}
		} finally {
			try {
				conn.setAutoCommit(true);
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
		}
	}

	/**
	 * 영업/관리담당자배정프로시저호출 2016-05-16 Ryu
	 */
	public String call_sp_conv_busidmngid_excel() {
		getConnection();

		CallableStatement cstmt = null;

		String sResult = "";

		String query = "{CALL P_CONV_BUSIDMNGID }";

		try {

			// 프로시저 호출
			cstmt = conn.prepareCall(query);
			cstmt.execute();
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_conv_busidmngid_excel]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/**
	 * 외부요청자료 04
	 */
	public Vector getOutsideReq04(String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT /*+  merge(a) */ a.*, b.rent_dt,  "
				+ "        decode(c.cls_st, '1','계약만료','2','중도해약','3','영업소 변경','4','차종변경','5','계약이관','6','매각','7','출고전해지','8','매입옵션','9','페차','10','개시전해지') as clsst "
				+ " FROM   debt_scd_view a, cont b, cls_cont c"
				+ " WHERE  a.rent_l_cd = b.rent_l_cd and a.rent_l_cd = c.rent_l_cd(+)"
				+ "        AND a.cpt_cd = '0043' " + "        and replace( a.lend_dt, '-', '' ) <= replace( '" + end_dt
				+ "', '-', '' ) " + " ORDER BY all_yn DESC, lend_dt ASC, firm_nm ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getOutsideReq04]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 외부요청자료 04
	 */
	public Vector getOutsideReq04_20100413(String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select d.car_no, d.car_nm, a.lend_dt, b.rent_dt, e.firm_nm, e.client_nm, "
				+ "        decode(f.firm_nm,e.firm_nm,'',f.firm_nm) firm_nm2, decode(f.client_nm,e.client_nm,'',f.client_nm) client_nm2, f.cls_dt, f.clsst \n"
				+ " from allot a, cont b, \n"
				+ "      (select car_mng_id, min(rent_mng_id||reg_dt) min_rent from cont where car_st<>'2' and rent_l_cd not like 'RM%' group by car_mng_id) c, \n"
				+ "      car_reg d, client e, \n"
				+ "      (select a.car_mng_id, b.firm_nm, b.client_nm, d.cls_dt, d.cls_st, \n"
				+ "	          decode(d.cls_st, '1','계약만료','2','중도해약','3','영업소 변경','4','차종변경','5','계약이관','6','매각','7','출고전해지','8','매입옵션','9','페차','10','개시전해지') as clsst \n"
				+ "       from cont a, client b, \n"
				+ "            (select car_mng_id, max(rent_mng_id||reg_dt) max_rent from cont where car_st<>'2' and rent_l_cd not like 'RM%' group by car_mng_id) c, \n"
				+ "            cls_cont d \n" + "       where a.client_id=b.client_id \n"
				+ "             and a.car_mng_id=c.car_mng_id and a.rent_mng_id||a.reg_dt=c.max_rent \n"
				+ "             and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n" + "      ) f \n"
				+ " where replace(a.lend_dt,'-','') <= replace('" + end_dt + "','-','') \n"
				+ "       and a.cpt_cd='0043' \n"
				+ "       and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"
				+ "       and b.car_mng_id=c.car_mng_id and b.rent_mng_id||b.reg_dt=c.min_rent \n"
				+ "       and a.car_mng_id=d.car_mng_id \n" + "       and b.client_id=e.client_id \n"
				+ "       and a.car_mng_id=f.car_mng_id(+) \n" + " ORDER BY a.lend_dt ASC, e.firm_nm ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getOutsideReq04]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 외부요청자료 05
	 */
	public Vector getOutsideReq05_20110517() {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.firm_nm, a.car_no, a.tot_amt3, nvl(b.tot_amt4,0)-a.tot_amt3 amt4 "
				+ " from   (select /*+  merge(b) */  b.firm_nm, cc.car_no, a.rent_l_cd, "
				+ "                count(*) tot_su3, nvl(sum(a.fee_s_amt+a.fee_v_amt),0) tot_amt3 "
				+ "         from   scd_fee a, cont_n_view b, car_reg cc, cls_cont c "
				+ "         where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and b.rent_l_cd=c.rent_l_cd(+) and b.car_mng_id = cc.car_mng_id  "
				+ "                and nvl(c.cls_st,'0') not in ('1','2') "
				+ "                and nvl(a.bill_yn,'Y')='Y'  and a.tm_st2<>'4' "
				+ "                and a.r_fee_est_dt < to_char(sysdate,'YYYYMMDD') "
				+ "                and a.rc_yn='0' " + "                and a.fee_s_amt>0 "
				+ "         group by b.firm_nm, cc.car_no, a.rent_l_cd " + "        ) a, "
				+ "        (select a.rent_l_cd, count(*) tot_su4, nvl(sum(a.fee_s_amt+a.fee_v_amt),0) tot_amt4 "
				+ "         from   scd_fee a " + "         where  nvl(a.bill_yn,'Y')='Y' and a.tm_st2<>'4'  "
				+ "                and a.rc_yn='0' " + "                and a.fee_s_amt>0 "
				+ "         group by a.rent_l_cd " + "         ) b " + " where a.rent_l_cd=b.rent_l_cd "
				+ " order by a.tot_amt3 desc ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getOutsideReq05_20110517]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 외부요청자료 06
	 */
	public Vector getOutsideReq06_20110518(String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select substr(b.cls_dt,1,6) as ym, count(*) as cnt\n" + " from   cont a, cls_cont b, \n"
				+ "        (select rent_mng_id, rent_l_cd, max(rent_end_dt) from fee group by rent_mng_id, rent_l_cd) c, \n"
				+ "        (select rent_mng_id, rent_l_cd, max(use_e_dt) from scd_fee where tm_st2<>'4' group by rent_mng_id, rent_l_cd) d \n"
				+ " where  a.rent_dt <= replace('" + end_dt + "','-','') and a.car_st<>'2' \n"
				+ " and    a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"
				+ " and    a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"
				+ " and    a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n" + " and    b.cls_dt > replace('"
				+ end_dt + "','-','') \n" + " and    b.cls_st not in ('4','5') \n" + " group by substr(b.cls_dt,1,6) \n"
				+ " order by substr(b.cls_dt,1,6) \n" + "  ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getOutsideReq06_20110518]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 외부요청자료 07
	 */
	public Vector getOutsideReq07_20110518(String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select substr(case when c.rent_end_dt < d.use_e_dt then d.use_e_dt else c.rent_end_dt end,1,6) as ym, count(*) as cnt\n"
				+ " from   cont a, cls_cont b, \n"
				+ "        (select rent_mng_id, rent_l_cd, max(rent_end_dt) rent_end_dt from fee group by rent_mng_id, rent_l_cd) c, \n"
				+ "        (select rent_mng_id, rent_l_cd, max(use_e_dt) use_e_dt from scd_fee where tm_st2<>'4' group by rent_mng_id, rent_l_cd) d \n"
				+ " where  a.rent_dt <= replace('" + end_dt + "','-','') and a.car_st<>'2' \n"
				+ " and    a.rent_mng_id=b.rent_mng_id(+) and a.rent_l_cd=b.rent_l_cd(+) \n"
				+ " and    a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"
				+ " and    a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd \n"
				+ " and    b.rent_l_cd is null \n"
				+ " and    substr(case when c.rent_end_dt < d.use_e_dt then d.use_e_dt else c.rent_end_dt end,1,6) > substr(replace('"
				+ end_dt + "','-',''),1,6) \n"
				+ " group by substr(case when c.rent_end_dt < d.use_e_dt then d.use_e_dt else c.rent_end_dt end,1,6) \n"
				+ " order by substr(case when c.rent_end_dt < d.use_e_dt then d.use_e_dt else c.rent_end_dt end,1,6) \n"
				+ "  ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getOutsideReq07_20110518]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 외부요청자료 08
	 */
	public Vector getOutsideReq08(String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT /*+ RULE */ \n"
				+ "        SUBSTR(NVL(d.car_tax_dt,a.dlv_dt),1,4)  yyyy, decode(a.rent_st,'3','대차','신차') cont_st, \n"
				+ "        COUNT(*) cnt, COUNT(DECODE(c.lend_prn,0,'',c.rent_l_cd)) yes_allot, COUNT(DECODE(c.lend_prn,0,c.rent_l_cd)) no_allot, \n"
				+ "        SUM(nvl(d.car_fs_amt,0) + nvl(d.sd_cs_amt,0) - nvl(d.dc_cs_amt,0)+nvl(d.car_fv_amt,0) + nvl(d.sd_cv_amt,0) - nvl(d.dc_cv_amt,0)) car_amt, \n"
				+ "        SUM(f.acq_amt) car_acq_amt, \n"
				+ "        SUM(f.reg_amt+f.no_m_amt+f.stamp_amt+f.etc+f.loan_s_amt) car_etc_amt \n"
				+ " FROM   CONT a, CAR_PUR b, ALLOT c, CAR_ETC d, DOC_SETTLE e, CAR_REG f \n"
				+ " WHERE  a.car_mng_id IS NOT NULL \n"
				+ "        AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \n"
				+ "        AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd \n"
				+ "        AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd \n"
				+ "        AND NVL(d.car_tax_dt,a.dlv_dt) <= replace('" + end_dt + "','-','') \n"
				+ "        AND b.rent_l_cd=e.doc_id \n" + "        AND e.DOC_ST='4' \n"
				+ "        AND a.car_mng_id=f.car_mng_id \n"
				+ " GROUP by SUBSTR(NVL(d.car_tax_dt,a.dlv_dt),1,4), decode(a.rent_st,'3','대차','신차') \n"
				+ " ORDER by SUBSTR(NVL(d.car_tax_dt,a.dlv_dt),1,4), decode(a.rent_st,'3','대차','신차') desc \n" + "  ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getOutsideReq08]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 외부요청자료 09
	 */
	public Hashtable getOutsideReq09(String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";
		int v_year = 0;

		query = " SELECT a.save_dt, \n" +

				"        COUNT(CASE WHEN a.car_st<>'2' AND e.client_st IN ('1') THEN a.car_mng_id end) cnt1, \n"
				+ "        COUNT(CASE WHEN a.car_st<>'2' AND e.client_st IN ('2','3','4','5') THEN a.car_mng_id end) cnt2, \n"
				+ "        SUM  (CASE WHEN a.car_st<>'2' AND e.client_st IN ('1') THEN a.fee_s_amt end) amt1, \n"
				+ "        SUM  (CASE WHEN a.car_st<>'2' AND e.client_st IN ('2','3','4','5') THEN a.fee_s_amt end) amt2, \n"
				+

				"        COUNT(CASE WHEN a.car_use='1' AND b.FUEL_kd IN ('3') THEN a.car_mng_id end) cnt3, \n"
				+ "        COUNT(CASE WHEN a.car_use='1' AND b.FUEL_kd NOT IN ('3') THEN a.car_mng_id end) cnt4, \n"
				+ "        SUM  (CASE WHEN a.car_use='1' AND b.FUEL_kd IN ('3') THEN d.jangbu end) amt3, \n"
				+ "        SUM  (CASE WHEN a.car_use='1' AND b.FUEL_kd NOT IN ('3') THEN d.jangbu end) amt4, \n" +

				"        COUNT(CASE WHEN a.car_use='2' AND b.FUEL_kd IN ('3') THEN a.car_mng_id end) cnt5, \n"
				+ "        COUNT(CASE WHEN a.car_use='2' AND b.FUEL_kd NOT IN ('3') THEN a.car_mng_id end) cnt6, \n"
				+ "        SUM  (CASE WHEN a.car_use='2' AND b.FUEL_kd IN ('3') THEN d.jangbu end) amt5, \n"
				+ "        SUM  (CASE WHEN a.car_use='2' AND b.FUEL_kd NOT IN ('3') THEN d.jangbu end) amt6, \n" +

				"        COUNT(CASE WHEN b.CAR_kd IN ('1','2','3','9') AND b.dpm < 1500 THEN a.car_mng_id end) cnt7, \n"
				+ "        COUNT(CASE WHEN b.CAR_kd IN ('1','2','3','9') AND b.dpm >= 1500 AND b.dpm < 2000 THEN a.car_mng_id end) cnt8, \n"
				+ "        COUNT(CASE WHEN b.CAR_kd IN ('1','2','3','9') AND b.dpm >= 2000 THEN a.car_mng_id end) cnt9, \n"
				+ "        COUNT(CASE WHEN b.CAR_kd IN ('4','5','6','7','8') THEN a.car_mng_id end) cnt10, \n" +

				"        COUNT(CASE WHEN a.car_st<>'2' AND e.client_st IN ('1','2','3','4','5') AND c.con_mon = 12 THEN a.car_mng_id end) cnt11, \n"
				+ "        COUNT(CASE WHEN a.car_st<>'2' AND e.client_st IN ('1','2','3','4','5') AND c.con_mon = 24 THEN a.car_mng_id end) cnt12, \n"
				+ "        COUNT(CASE WHEN a.car_st<>'2' AND e.client_st IN ('1','2','3','4','5') AND c.con_mon = 36 THEN a.car_mng_id end) cnt13, \n"
				+ "        COUNT(CASE WHEN a.car_st<>'2' AND e.client_st IN ('1','2','3','4','5') AND c.con_mon = 48 THEN a.car_mng_id end) cnt14, \n"
				+ "        COUNT(CASE WHEN a.car_st<>'2' AND e.client_st IN ('1','2','3','4','5') AND c.con_mon = 60 THEN a.car_mng_id end) cnt15, \n"
				+ "        COUNT(CASE WHEN a.car_st<>'2' AND e.client_st IN ('1','2','3','4','5') AND c.con_mon NOT IN (12,24,36,48) THEN a.car_mng_id end) cnt16, \n";

		for (int i = AddUtil.parseInt(end_dt.substring(0, 4)); i >= AddUtil.parseInt(end_dt.substring(0, 4)) - 7; i--) {
			v_year = i;
			query += "   COUNT(CASE WHEN SUBSTR(b.init_reg_dt,1,4) = '" + v_year + "' THEN a.car_mng_id end) cnt"
					+ v_year + ", \n";
			query += "   SUM  (CASE WHEN SUBSTR(b.init_reg_dt,1,4) = '" + v_year + "' THEN d.jangbu end) amt" + v_year
					+ ", \n";
		}

		query += "       COUNT(CASE WHEN SUBSTR(b.init_reg_dt,1,4) < '" + v_year + "' THEN a.car_mng_id end) cnt"
				+ v_year + "b, \n" + "        SUM  (CASE WHEN SUBSTR(b.init_reg_dt,1,4) < '" + v_year
				+ "' THEN d.jangbu end) amt" + v_year + "b, \n" + "        COUNT(*) cnt0 \n"
				+ " FROM   STAT_RENT_MONTH a, CAR_REG b, FEE c, CLIENT e, \n" + "        (select a.car_mng_id, \n"
				+ "                a.asset_code, a.asset_name, a.get_date, \n" + "                a.deprf_yn, \n"
				+ "                decode(  a.deprf_yn , '5', 0, ya.get_amt + ya.book_dr - ya.book_cr - ya.jun_reser - ya.dep_amt ) jangbu \n"
				+ "         from   fassetma_bak2 a, ( select * from  fassetmove_bak2 where assch_type = '3' ) m,  \n"
				+ "                ( select * from  fyassetdep_bak2 where gisu = (select max(gisu) from fyassetdep_bak2 )) ya \n"
				+ "         where  a.asset_code = ya.asset_code  and a.asset_code = m.asset_code(+)  \n"
				+ "                and a.deprf_yn <> '6' \n" + "        ) d,  \n" + "        CAR_ETC f, CAR_NM g  \n"
				+ " WHERE  a.save_dt = replace('" + end_dt + "','-','') \n"
				+ " AND a.car_mng_id=b.car_mng_id and a.prepare not in ('4','5') \n" + // 말소,도난차량 제외
				" and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd AND a.fee_rent_st=c.rent_st \n"
				+ " AND a.client_id=e.client_id \n" + " AND a.car_mng_id=d.car_mng_id(+) \n"
				+ " and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd \n"
				+ " AND f.car_id=g.car_id AND f.car_seq=g.car_seq  \n" + " GROUP BY a.save_dt \n"
				+ " ORDER BY a.save_dt \n" + "  ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			if (rs.next()) {
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getOutsideReq09]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return ht;
		}
	}

	/**
	 * 외부요청자료 09
	 */
	public Vector getOutsideReq09_2(String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT h.nm, \n" + "        COUNT(*) cnt0 \n"
				+ " FROM   STAT_RENT_MONTH a, CAR_REG b, FEE c, CLIENT e, \n" + "        (select a.car_mng_id, \n"
				+ "                a.asset_code, a.asset_name, a.get_date,  \n" + "                a.deprf_yn,  \n"
				+ "                decode(  a.deprf_yn , '5', 0, ya.get_amt + ya.book_dr - ya.book_cr - ya.jun_reser - ya.dep_amt ) jangbu \n"
				+ "         from   fassetma_bak2 a, ( select * from  fassetmove_bak2 where assch_type = '3' ) m,  \n"
				+ "                ( select * from  fyassetdep_bak2 where gisu = (select max(gisu) from fyassetdep_bak2 )) ya \n"
				+ "         where  a.asset_code = ya.asset_code  and a.asset_code = m.asset_code(+)  \n"
				+ "                and a.deprf_yn <> '6'  \n" + "        ) d,  \n"
				+ "        CAR_ETC f, CAR_NM g, (SELECT * FROM CODE WHERE c_st='0001') h  \n"
				+ " WHERE  a.save_dt=replace('" + end_dt + "','-','') \n"
				+ " AND a.car_mng_id=b.car_mng_id  and a.prepare not in ('4','5') \n" + // 말소,도난차량 제외
				" and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd AND a.fee_rent_st=c.rent_st \n"
				+ " AND a.client_id=e.client_id \n" + " AND a.car_mng_id=d.car_mng_id(+) \n"
				+ " and a.rent_mng_id=f.rent_mng_id and a.rent_l_cd=f.rent_l_cd \n"
				+ " AND f.car_id=g.car_id AND f.car_seq=g.car_seq \n" + " AND g.car_comp_id=h.code  \n"
				+ " GROUP BY h.nm, h.code \n" + " ORDER BY h.code \n" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getOutsideReq09_2]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/*
	 * 사원별대여료연체현황 마감 프로시져 호출
	 */
	public String call_sp_stat_dly_magam() {
		getConnection();

		String query = "{CALL P_STAT_DLY_MAGAM (?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {
			cstmt = conn.prepareCall(query);

			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);

			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_stat_dly_magam]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/*
	 * 자동차현황 마감 프로시져 호출
	 */
	public String call_sp_stat_car_magam() {
		getConnection();

		String query = "{CALL P_STAT_CAR_MAGAM (?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {
			cstmt = conn.prepareCall(query);

			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);

			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_stat_car_magam]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/*
	 * 사원별관리영업현황 마감 프로시져 호출
	 */
	public String call_sp_stat_mng_magam() {
		getConnection();

		String query = "{CALL P_STAT_MNG_MAGAM (?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {
			cstmt = conn.prepareCall(query);

			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);

			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_stat_mng_magam]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/*
	 * 사원별영업실적현황 마감 프로시져 호출
	 */
	public String call_sp_stat_bus_magam() {
		getConnection();

		String query = "{CALL P_STAT_BUS_MAGAM (?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {
			cstmt = conn.prepareCall(query);

			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);

			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_stat_bus_magam]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/*
	 * 인사평점현황 마감 프로시져 호출
	 */
	public String call_sp_stat_total_magam() {
		getConnection();

		String query = "{CALL P_STAT_TOTAL_MAGAM (?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {
			cstmt = conn.prepareCall(query);

			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);

			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_stat_total_magam]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/*
	 * 채권캠페인 마감 프로시져 호출
	 */
	public String call_sp_stat_settle_magam() {
		getConnection();

		String query = "{CALL P_STAT_SETTLE_MAGAM (?)}";

		String query2 = "{CALL P_STAT_SETTLE_MAGAM2 (?)}";

		String query3 = "{CALL P_STAT_SETTLE_MAGAM3 (?)}";

		String query4 = "{CALL P_STAT_SETTLE_BUSID2_CNG_MAGAM (?)}";

		String sResult = "";

		CallableStatement cstmt = null;
		CallableStatement cstmt2 = null;
		CallableStatement cstmt3 = null;
		CallableStatement cstmt4 = null;

		try {

			cstmt = conn.prepareCall(query);
			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값

			cstmt2 = conn.prepareCall(query2);
			cstmt2.registerOutParameter(1, java.sql.Types.VARCHAR);
			cstmt2.execute();
			sResult = cstmt2.getString(1); // 결과값

			cstmt3 = conn.prepareCall(query3);
			cstmt3.registerOutParameter(1, java.sql.Types.VARCHAR);
			cstmt3.execute();
			sResult = cstmt3.getString(1); // 결과값

			cstmt4 = conn.prepareCall(query4);
			cstmt4.registerOutParameter(1, java.sql.Types.VARCHAR);
			cstmt4.execute();
			sResult = cstmt4.getString(1); // 결과값

			cstmt.close();
			cstmt2.close();
			cstmt3.close();
			cstmt4.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_stat_settle_magam]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
				if (cstmt2 != null)
					cstmt2.close();
				if (cstmt3 != null)
					cstmt3.close();
				if (cstmt4 != null)
					cstmt4.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/*
	 * 영업캠페인 마감 프로시져 호출 P_STAT_BUS_CMP_MAGAM
	 */
	public String call_sp_stat_bus_cmp_magam() {
		getConnection();

		String query = "{CALL P_STAT_BUS_CMP_MAGAM (?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {

			cstmt = conn.prepareCall(query);
			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값

			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_stat_bus_cmp_magam]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/*
	 * 영업캠페인 마감 프로시져 호출 P_STAT_BUS_CMP_MAGAM
	 */
	public String call_sp_stat_bus_cmp_magam_v19() {
		getConnection();

		String query = "{CALL P_STAT_BUS_CMP_MAGAM_V19 (?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {

			cstmt = conn.prepareCall(query);
			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값

			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_stat_bus_cmp_magam]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/*
	 * 영업캠페인 기본 마감 프로시져 호출 P_STAT_BUS_CMP_BASE_MAGAM
	 */
	public String call_sp_stat_bus_cmp_base_magam() {
		getConnection();

		String query = "{CALL P_STAT_BUS_CMP_BASE_MAGAM (?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {

			cstmt = conn.prepareCall(query);
			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값

			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_stat_bus_cmp_base_magam]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/*
	 * 수금/지출현황 마감 프로시져 호출
	 */
	public String call_sp_stat_incom_pay_magam() {
		getConnection();

		String query = "{CALL P_STAT_INCOM_PAY_MAGAM }";

		String sResult = "";

		CallableStatement cstmt = null;

		try {
			cstmt = conn.prepareCall(query);
			cstmt.execute();
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_stat_incom_pay_magam]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	// 계약 한건 검색 : mail_addrss
	public Hashtable getContEmail(String rent_mng_id, String rent_l_cd) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = " select a.rent_mng_id, a.rent_l_cd, a.client_id, a.r_site, \n"
				+ "        nvl(decode(a.r_site, '', h.firm_nm, decode(a.tax_type, '2',  g.r_site, h.firm_nm ) ), '고객') firm_nm, \n"
				+ "        decode( m.mgr_email , '', decode(a.r_site, '', h.con_agnt_email, decode(a.tax_type, '2',  g.agnt_email, h.con_agnt_email) ), null, decode(a.r_site, '', h.con_agnt_email, decode(a.tax_type, '2',  g.agnt_email, h.con_agnt_email) ), m.mgr_email ) email \n"
				+ " from   cont a, client h, client_site g, \n"
				+ "        ( select rent_mng_id, rent_l_cd,  MIN(mgr_id) AS MGR_ID, MIN(mgr_email) KEEP (DENSE_RANK FIRST ORDER BY MGR_ID) AS MGR_EMAIL  from car_mgr where  rent_mng_id = '"
				+ rent_mng_id + "' and rent_l_cd='" + rent_l_cd
				+ "' AND REGEXP_LIKE(mgr_email, '.+@.+') GROUP BY RENT_MNG_ID, RENT_L_CD ) m \n"
				+ " where a.use_yn = 'Y' and a.client_id = h.client_id and  a.r_site = g.seq(+) and a.client_id = g.client_id(+) \n"
				+ " and a.rent_mng_id='" + rent_mng_id + "' and a.rent_l_cd='" + rent_l_cd
				+ "' and a.rent_mng_id = m.rent_mng_id(+) and a.rent_l_cd= m.rent_l_cd(+) ";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getContEmail]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return ht;
		}
	}

	/**
	 * 과태료 포함 여부
	 */
	public String getClientFineYn(String client_id) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		String fine_yn = "";
		String query = "";

		query = " select decode(nvl(fine_yn, 'Y'), 'Y', '포함청구', '') fine_yn \n" + " from   client  where  client_id = '"
				+ client_id + "'";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			if (rs.next()) {
				fine_yn = rs.getString("fine_yn") == null ? "" : rs.getString("fine_yn");
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getClientFineYn]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return fine_yn;
		}
	}

	/**
	 * 주요거래처
	 */
	public Vector getHpSpClientList(String s_var, String gubun1, String gubun2, String gubun3) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String amt_nm = "";
		int s_amt = AddUtil.parseDigit(gubun2);
		int e_amt = AddUtil.parseDigit(gubun3);

		query = " select " + "        replace(a.firm_nm,'(주)','') firm_nm, b.cnt, a.client_nm, a.bus_cdt, a.bus_itm,  "
				+ "        c.c_asset_tot,         " + // --당기 자산총계
				"        c.c_cap,               " + // --당기 자본금
				"        c.c_cap_tot,           " + // --자본총계
				"        c.c_sale,              " + // --당기매출
				"        c.c_profit             " + // --당기순이익
				" from   client a, "
				+ "        (select client_id, count(*) cnt from cont where use_yn='Y' and car_st in ('1','3') and rent_l_cd not like 'RM%'  group by client_id) b, "
				+ // --대여중
				"        (select client_id, count(*) cnt from cont where car_st in ('1','3') and rent_l_cd not like 'RM%' and spr_kd='2' group by client_id) b2, "
				+ // --초우량기업
				"        (select a.* from client_fin a, (select client_id, max(f_seq) f_seq from client_fin group by client_id) b where a.client_id=b.client_id and a.f_seq=b.f_seq) c "
				+ // 재무제표
				" where  a.client_st='1' " + // --법인
				" and    a.client_id=b.client_id " + " and    a.client_id=b2.client_id(+) "
				+ " and    a.client_id=c.client_id(+) " + " ";

		if ((s_amt + e_amt) > 0) {

			if (gubun1.equals("1"))
				amt_nm = " nvl(c.c_asset_tot,0)		";
			else if (gubun1.equals("2"))
				amt_nm = " nvl(c.c_cap_tot,c.c_cap)	";
			else if (gubun1.equals("3"))
				amt_nm = " nvl(c.c_sale,0)			";

			if (s_amt > 0)
				query += " and " + amt_nm + " >= " + s_amt + " ";
			if (e_amt > 0)
				query += " and " + amt_nm + " <= " + e_amt + " ";
		}

		if (s_var.equals("일반대기업")) {

			query += " and a.bus_cdt||a.bus_itm not like '%금융%'	" + // 금융권 X
					" and a.firm_nm not like '%코리아%'			" + // 외국계 X
					" and a.firm_nm not like '%한국%'				" + // 외구계 X
					" and a.firm_nm not like '%법인%'				" + // 주요기관 X
					" and a.firm_nm not like '%협회%'				" + // 주요기관 X
					" and a.firm_nm not like '%공제%'				" + // 주요기관 X
					" and a.firm_nm not like '%조합%'				" + // 주요기관 X
					" and a.firm_nm not like '%한국%원'			" + // 주요기관 X
					" and a.firm_nm not like '%대한%회'			" + // 주요기관 X
					" and a.firm_nm not like '%병원%'				" + // 주요기관 X
					" and a.firm_nm not like '%의원%'				" + // 주요기관 X
					" and substr(a.enp_no,4,2)<>'83'				" + // 주요기관 X (국가/지방자치단체/지방자치단체조합)
					" and b2.cnt>0									" + // 초우량기업
					" ";

		} else if (s_var.equals("중견기업")) {

			query += " and a.bus_cdt||a.bus_itm not like '%금융%'	" + // 금융권 X
					" and a.firm_nm not like '%코리아%'			" + // 외국계 X
					" and a.firm_nm not like '%한국%'				" + // 외구계 X
					" and a.firm_nm not like '%법인%'				" + // 주요기관 X
					" and a.firm_nm not like '%협회%'				" + // 주요기관 X
					" and a.firm_nm not like '%공제%'				" + // 주요기관 X
					" and a.firm_nm not like '%조합%'				" + // 주요기관 X
					" and a.firm_nm not like '%한국%원'			" + // 주요기관 X
					" and a.firm_nm not like '%대한%회'			" + // 주요기관 X
					" and a.firm_nm not like '%병원%'				" + // 주요기관 X
					" and a.firm_nm not like '%의원%'				" + // 주요기관 X
					" and a.firm_nm not like '%전자%'				" + // 벤처,IT X
					" and a.bus_cdt||a.bus_itm not like '%반도체%' " + // 벤처,IT X
					" and a.bus_cdt||a.bus_itm not like '%전자%'	" + // 벤처,IT X
					" and a.bus_itm not like '%소프트웨어%'		" + // 벤처,IT X
					" and a.bus_itm not like '%개발%'				" + // 벤처,IT X
					" and a.bus_itm not like '%로봇%'				" + // 벤처,IT X
					" and substr(a.enp_no,4,2)<>'83'				" + // 주요기관 X (국가/지방자치단체/지방자치단체조합)
					" and b2.cnt>0									" + // 초우량기업
					" ";

		} else if (s_var.equals("금융권")) {

			query += " and (a.bus_cdt||a.bus_itm like '%금융%') " + " and substr(a.enp_no,4,2)<>'83'				" + // 주요기관
																													// X
																													// (국가/지방자치단체/지방자치단체조합)
					" and b2.cnt>0									" + // 초우량기업
					" ";

		} else if (s_var.equals("외국계기업")) {

			query += " and (a.firm_nm like '%코리아%' or a.firm_nm like '%한국%' or substr(a.enp_no,4,2)='84' or length(a.client_nm) >8)"
					+ " and a.bus_cdt||a.bus_itm not like '%금융%'	" + // 금융권 X
					" and a.firm_nm not like '%한국%원'			" + // 주요기관
					" and a.firm_nm not like '%한국%회'			" + // 주요기관
					" and a.firm_nm not like '%한국%사업단'		" + // 주요기관
					" and substr(a.enp_no,4,2)<>'83'				" + // 주요기관 X (국가/지방자치단체/지방자치단체조합)
					" and b2.cnt>0									" + // 초우량기업
					" ";

		} else if (s_var.equals("벤처,IT기업")) {

			query += " and (a.bus_cdt||a.bus_itm like '%IT%' or a.bus_cdt||a.bus_itm like '%인터넷%' or a.bus_cdt||a.bus_itm like '%전자%' or a.bus_cdt||a.bus_itm like '%반도체%' or a.bus_cdt||a.bus_itm like '%소프트웨어%' or a.bus_cdt||a.bus_itm like '%개발%')"
					+ " and a.bus_cdt||a.bus_itm not like '%금융%'	" + // 금융권
					" and a.firm_nm not like '%코리아%'			" + // 외국계
					" and a.firm_nm not like '%한국%'				" + // 외구계
					" and a.firm_nm not like '%법인%'				" + // 주요기관
					" and a.firm_nm not like '%협회%'				" + // 주요기관
					" and a.firm_nm not like '%공제%'				" + // 주요기관
					" and a.firm_nm not like '%조합%'				" + // 주요기관
					" and a.firm_nm not like '%한국%원'			" + // 주요기관
					" and a.firm_nm not like '%대한%회'			" + // 주요기관
					" and a.firm_nm not like '%병원%'				" + // 주요기관
					" and a.firm_nm not like '%의원%'				" + // 주요기관
					" and substr(a.enp_no,4,2)<>'83'				" + // 주요기관 X (국가/지방자치단체/지방자치단체조합)
					" and b2.cnt>0									" + // 초우량기업
					" ";

		} else if (s_var.equals("정부기관")) {

			query += " and (substr(a.enp_no,4,2)='83' or a.firm_type in ('6','7','8','9'))				" + // 주요기관 O
																											// (국가/지방자치단체/지방자치단체조합)
					" and substr(a.enp_no,4,2) not in ('81','86','82')	" + // 주요기관 X (국가/지방자치단체/지방자치단체조합)
					" ";

		} else if (s_var.equals("재단/법무/회계/세무/노무/관세법인")) {

			query += " and a.firm_nm like '%법인%'					"
					+ " and substr(a.enp_no,4,2)<>'82'				" + " ";

		} else if (s_var.equals("비영리법인")) {

			query += " and substr(a.enp_no,4,2)='82'				" + " ";

		}
		query += " order by nvl(c.c_asset_tot,0) desc, c.c_cap_tot+c.c_cap desc";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getHpSpClientList]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 매출현황-대여료 정상발행분
	 */
	public Vector getPrecostSaleFeeList(String gubun1, String gubun2) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		// 기준년월
		String tax_ym = gubun1 + "" + gubun2;

		query = " select \n" + "        b.car_use, \n" + "        sum(decode(substr(a.tax_dt,1,6),to_char(to_date('"
				+ tax_ym + "','YYYYMM')-1,'YYYYMM'),b.item_supply)) amt1, \n"
				+ "        sum(decode(substr(a.tax_dt,1,6),'" + tax_ym + "',b.item_supply)) amt2 \n"
				+ " from   tax a, tax_item_list b \n" + " where  substr(a.tax_dt,1,6) between to_char(to_date('"
				+ tax_ym + "','YYYYMM')-1,'YYYYMM') and '" + tax_ym + "' \n" + "        and a.tax_st<>'C' \n"
				+ "        and a.item_id=b.item_id \n" + "        and b.gubun in ('1') \n" + " group by b.car_use \n"
				+ " order by b.car_use ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getPrecostSaleFeeList]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 매출현황-연체해소로 미발행분 일괄발행
	 */
	public Vector getPrecostSaleFeeList2(String gubun1, String gubun2, String dt_st) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		// 기준년월
		String tax_ym = gubun1 + "" + gubun2;

		query = " select \n" + "        b.car_use, sum(b.item_supply) amt \n"
				+ " from   tax a, tax_item_list b, scd_fee c \n" + " where  a.tax_dt like '" + tax_ym
				+ "%' and a.tax_st<>'C' \n" + "        and a.item_id=b.item_id \n" + "        and b.gubun in ('1') \n"
				+ "        and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and b.rent_seq=c.rent_seq and b.tm=c.fee_tm \n"
				+ "        and substr(c.tax_out_dt,1,6) <> '" + tax_ym + "'  and c.tm_st2<>'4' \n"
				+ " group by b.car_use \n" + " order by b.car_use ";

		if (dt_st.equals("last month")) {
			query = " select \n" + "        b.car_use, sum(b.item_supply) amt \n"
					+ " from   tax a, tax_item_list b, scd_fee c \n"
					+ " where  a.tax_dt like to_char(to_date('" + tax_ym
					+ "','YYYYMM')-1,'YYYYMM')||'%' and a.tax_st<>'C' \n" + "        and a.item_id=b.item_id \n"
					+ "        and b.gubun in ('1') \n"
					+ "        and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.rent_st and b.rent_seq=c.rent_seq and b.tm=c.fee_tm \n"
					+ "        and substr(c.tax_out_dt,1,6) <> to_char(to_date('" + tax_ym
					+ "','YYYYMM')-1,'YYYYMM') and c.tm_st2<>'4' \n" + " group by b.car_use \n"
					+ " order by b.car_use ";
		}

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getPrecostSaleFeeList2]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 매출현황-연체발행중지로 미발행분
	 */
	public Vector getPrecostSaleFeeList3(String gubun1, String gubun2, String dt_st) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		// 기준년월
		String tax_ym = gubun1 + "" + gubun2;

		query = " select \n" + "        d.car_use, -sum(b.fee_s_amt+b.fee_v_amt) amt \n"
				+ " from   scd_fee_stop a, scd_fee b, cont c, car_reg d \n"
				+ " where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd \n"
				+ "        and a.STOP_S_DT like '" + tax_ym + "%' \n"
				+ "        and b.tax_out_dt like '" + tax_ym + "%' and b.tm_st2<>'4'  \n"
				+ "        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"
				+ "        and c.car_mng_id=d.car_mng_id\n" + " group by d.car_use \n" + " order by d.car_use ";

		if (dt_st.equals("last month")) {
			query = " select \n" + "        d.car_use, -sum(b.fee_s_amt+b.fee_v_amt) amt \n"
					+ " from   scd_fee_stop a, scd_fee b, cont c, car_reg d \n"
					+ " where  a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd  and b.tm_st2<>'4' \n"
					+ "        and a.STOP_S_DT like to_char(to_date('" + tax_ym + "','YYYYMM')-1,'YYYYMM')||'%' \n"
					+ "        and b.tax_out_dt like to_char(to_date('" + tax_ym + "','YYYYMM')-1,'YYYYMM')||'%' \n"
					+ "        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd \n"
					+ "        and c.car_mng_id=d.car_mng_id\n" + " group by d.car_use \n" + " order by d.car_use ";
		}

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getPrecostSaleFeeList3]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 매출현황-선수금 정상발행분
	 */
	public Vector getPrecostSaleFeeList4(String gubun1, String gubun2) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		// 기준년월
		String tax_ym = gubun1 + "" + gubun2;

		query = " select \n" + "        b.car_use, \n" + "        sum(decode(substr(a.tax_dt,1,6),to_char(to_date('"
				+ tax_ym + "','YYYYMM')-1,'YYYYMM'),b.item_supply)) amt1, \n"
				+ "        sum(decode(substr(a.tax_dt,1,6),'" + tax_ym + "',b.item_supply)) amt2 \n"
				+ " from   tax a, tax_item_list b \n" + " where  substr(a.tax_dt,1,6) between to_char(to_date('"
				+ tax_ym + "','YYYYMM')-1,'YYYYMM') and '" + tax_ym + "' \n" + "        and a.tax_st<>'C' \n"
				+ "        and a.item_id=b.item_id \n" + "        and b.gubun in ('3','4','14') \n"
				+ " group by b.car_use \n" + " order by b.car_use ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getPrecostSaleFeeList4]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 매출현황-기타매출(대여료,선수금,매각제외) 정상발행분
	 */
	public Vector getPrecostSaleFeeList5(String gubun1, String gubun2) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		// 기준년월
		String tax_ym = gubun1 + "" + gubun2;

		query = " select \n" + "        decode(b.car_use,'3','2',b.car_use) car_use, \n"
				+ "        sum(decode(substr(a.tax_dt,1,6),to_char(to_date('" + tax_ym
				+ "','YYYYMM')-1,'YYYYMM'),b.item_supply)) amt1, \n" + "        sum(decode(substr(a.tax_dt,1,6),'"
				+ tax_ym + "',b.item_supply)) amt2, \n"
				+ "        sum(decode(b.gubun,'7',decode(substr(a.tax_dt,1,6),to_char(to_date('" + tax_ym
				+ "','YYYYMM')-1,'YYYYMM'),b.item_supply))) amt1_1, \n"
				+ "        sum(decode(b.gubun,'7',decode(substr(a.tax_dt,1,6),'" + tax_ym
				+ "',b.item_supply))) amt2_1, \n"
				+ "        sum(decode(b.gubun,'11',decode(substr(a.tax_dt,1,6),to_char(to_date('" + tax_ym
				+ "','YYYYMM')-1,'YYYYMM'),b.item_supply))) amt1_2, \n"
				+ "        sum(decode(b.gubun,'11',decode(substr(a.tax_dt,1,6),'" + tax_ym
				+ "',b.item_supply))) amt2_2, \n"
				+ "        sum(decode(b.gubun,'9',decode(substr(a.tax_dt,1,6),to_char(to_date('" + tax_ym
				+ "','YYYYMM')-1,'YYYYMM'),b.item_supply))) amt1_3, \n"
				+ "        sum(decode(b.gubun,'9',decode(substr(a.tax_dt,1,6),'" + tax_ym
				+ "',b.item_supply))) amt2_3, \n"
				+ "        sum(decode(b.gubun,'13',decode(substr(a.tax_dt,1,6),to_char(to_date('" + tax_ym
				+ "','YYYYMM')-1,'YYYYMM'),b.item_supply))) amt1_4, \n"
				+ "        sum(decode(b.gubun,'13',decode(substr(a.tax_dt,1,6),'" + tax_ym
				+ "',b.item_supply))) amt2_4, \n"
				+ "        sum(decode(b.gubun,'15',decode(substr(a.tax_dt,1,6),to_char(to_date('" + tax_ym
				+ "','YYYYMM')-1,'YYYYMM'),b.item_supply))) amt1_5, \n"
				+ "        sum(decode(b.gubun,'15',decode(substr(a.tax_dt,1,6),'" + tax_ym
				+ "',b.item_supply))) amt2_5 \n" + " from   tax a, tax_item_list b \n"
				+ " where  substr(a.tax_dt,1,6) between to_char(to_date('" + tax_ym + "','YYYYMM')-1,'YYYYMM') and '"
				+ tax_ym + "' \n" + "        and a.tax_st<>'C' \n" + "        and a.item_id=b.item_id \n"
				+ "        and b.gubun in ('7','11','9','13','15') \n"
				+ " group by decode(b.car_use,'3','2',b.car_use) \n" + " order by decode(b.car_use,'3','2',b.car_use) ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getPrecostSaleFeeList5]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/*
	 * 계약현황 마감 프로시져 호출
	 */
	public String call_sp_stat_rent_mon_magam() {
		getConnection();

		String query = "{CALL P_STAT_RENT_MON_MAGAM (?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {
			cstmt = conn.prepareCall(query);

			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);

			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_stat_rent_mon_magam]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/**
	 * 관리비용 분기마감관련
	 */
	public Vector getStatMngSettle(String c_yy, String c_mm) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query1 = "";

		if (c_mm.equals("1")) {
			query1 = " between  '" + c_yy + "0101' and '" + c_yy + "0331'";
		} else if (c_mm.equals("2")) {
			query1 = " between  '" + c_yy + "0401' and '" + c_yy + "0630'";
		} else if (c_mm.equals("3")) {
			query1 = " between  '" + c_yy + "0701' and '" + c_yy + "0930'";
		} else if (c_mm.equals("4")) {
			query1 = " between  '" + c_yy + "1001' and '" + c_yy + "1231'";
		}

		String query = " select '7' gubun, a.user_id bus_id, trunc(sum(c_gen_cnt_b2)/count(a.user_id)) as amt, trunc(sum(ins_cnt_b2)/count(a.user_id)) as amt1 \n "
				+ "  from stat_mng a, users u where a.save_dt " + query1
				+ " and a.user_id = u.user_id and u.loan_st = '1' \n" + " group by a.user_id ";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}

			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatMngSettle]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 장기대여보증금 네오엠 비교
	 */
	public Vector getNeoMCGrtAmtChk(String s_idno, String ven_code, String ven_name) {
		getConnection();
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		Vector vt = new Vector();
		int count = 0;

		String query = " SELECT d.enp_no, substr(TEXT_DECRYPT(d.ssn, 'pw' ),1,6) ssn , TEXT_DECRYPT(e.enp_no, 'pw' )   AS site_enp_no, \n"
				+ "        MIN(d.firm_nm) firm_nm, MIN(d.ven_code) ven_code, MIN(e.r_site) site_nm, MIN(e.ven_code) site_ven_code, SUM(b.GRT_AMT_S) amt \n"
				+ " FROM   CONT a, FEE b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c, CLIENT d, CLIENT_SITE e \n"
				+ " WHERE  a.use_yn='Y' AND a.car_st in ('1','3','4') \n"
				+ "        AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND b.GRT_AMT_S>0 \n"
				+ "        AND b.rent_mng_id=c.rent_mng_id AND b.rent_l_cd=c.rent_l_cd AND b.RENT_ST=c.rent_st \n"
				+ "        AND a.client_id=d.client_id \n"
				+ "        AND a.client_id=e.client_id(+) AND a.R_SITE=e.seq(+) \n";

		if (!s_idno.equals("")) {
			query += "        AND d.enp_no||' '||TEXT_DECRYPT(d.ssn, 'pw' )||' '||NVL(TEXT_DECRYPT(e.enp_no, 'pw' ),'') LIKE '%"
					+ s_idno + "%' \n";
		} else {
			query += "        AND d.ven_code||' '||NVL(e.ven_code,'') LIKE '%" + ven_code + "%' \n";
		}

		query += " GROUP BY  d.enp_no, TEXT_DECRYPT(d.ssn, 'pw' ), TEXT_DECRYPT(e.enp_no, 'pw' )  \n";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				count++;
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

			if (!s_idno.equals("") && count == 0) {
				query = " SELECT d.enp_no, substr(TEXT_DECRYPT(d.ssn, 'pw'),1,6) ssn,TEXT_DECRYPT(e.enp_no, 'pw' )  AS site_enp_no, \n"
						+ "        MIN(d.firm_nm) firm_nm, MIN(d.ven_code) ven_code, MIN(e.r_site) site_nm, MIN(e.ven_code) site_ven_code, SUM(b.GRT_AMT_S) amt \n"
						+ " FROM   CONT a, FEE b, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st from fee group by rent_mng_id, rent_l_cd) c, CLIENT d, CLIENT_SITE e \n"
						+ " WHERE  a.use_yn='Y' AND a.car_st in ('1','3','4') \n"
						+ "        AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND b.GRT_AMT_S>0 \n"
						+ "        AND b.rent_mng_id=c.rent_mng_id AND b.rent_l_cd=c.rent_l_cd AND b.RENT_ST=c.rent_st \n"
						+ "        AND a.client_id=d.client_id \n"
						+ "        AND a.client_id=e.client_id(+) AND a.R_SITE=e.seq(+) \n";

				query += "        AND d.ven_code||' '||NVL(e.ven_code,'') LIKE '%" + ven_code + "%' \n";
				query += " GROUP BY  d.enp_no, TEXT_DECRYPT(d.ssn, 'pw' ), TEXT_DECRYPT(e.enp_no, 'pw' )  \n";

				pstmt2 = conn.prepareStatement(query);
				rs2 = pstmt2.executeQuery();
				rsmd = rs2.getMetaData();
				while (rs2.next()) {
					count++;
					Hashtable ht = new Hashtable();
					for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
						String columnName = rsmd.getColumnName(pos);
						ht.put(columnName, (rs2.getString(columnName)) == null ? "" : rs2.getString(columnName));
					}
					vt.add(ht);
				}
				rs2.close();
				pstmt2.close();
			}

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getNeoMCGrtAmtChk]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (rs2 != null)
					rs2.close();
				if (pstmt2 != null)
					pstmt2.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료1 - 자동차보험료 전년대비 지급현황
	 */
	public Vector getSettleAccount_list1(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n" + "       ins_com_id, ins_com_nm, decode(car_use,'1','영업용','업무용') car_use, t_cnt,  \n"
				+ "       (cnt1+cnt2+cnt3+cnt4+cnt5) t1, \n"
				+ "       (nvl(amt1,0)+nvl(amt2,0)+nvl(amt3,0)-nvl(amt4,0)+nvl(amt5,0)) t2, \n"
				+ "       cnt1+cnt2 cnt1, nvl(amt1,0)+nvl(amt2,0) amt1, \n" + "       cnt3, amt3, \n"
				+ "       (cnt1+cnt2+cnt3) t3, \n" + "       (nvl(amt1,0)+nvl(amt2,0)+nvl(amt3,0)) t4, \n"
				+ "       cnt4, amt4, \n" + "       cnt5, -amt5 as amt5, \n" + "       (cnt4+cnt5) t5, \n"
				+ "       (nvl(amt4,0)-nvl(amt5,0)) t6 \n" + " from \n" + " ( \n" + " select \n"
				+ "        b.ins_com_id, d.ins_com_nm, --보험사 \n"
				+ "        decode(b.car_use,'3',c.car_use,b.car_use) car_use, --차량구분 \n"
				+ "        count(*) t_cnt, --차량대수 \n"
				+ "        count(decode(nvl(a.ins_tm2,'0'),'0',decode(a.ins_tm,'1',a.car_mng_id))) cnt1, --1회차보험료(1) \n"
				+ "        sum  (decode(nvl(a.ins_tm2,'0'),'0',decode(a.ins_tm,'1',a.pay_amt))) amt1,     \n"
				+ "        count(decode(nvl(a.ins_tm2,'0'),'0',decode(a.ins_tm,'1','',a.car_mng_id))) cnt2,--분납보험료(2) \n"
				+ "        sum  (decode(nvl(a.ins_tm2,'0'),'0',decode(a.ins_tm,'1',0,a.pay_amt))) amt2, \n"
				+ "        count(decode(nvl(a.ins_tm2,'0'),'1',decode(sign(a.pay_amt),1,a.car_mng_id))) cnt3, --추가가입보험료(3) \n"
				+ "        sum  (decode(nvl(a.ins_tm2,'0'),'1',decode(sign(a.pay_amt),1,a.pay_amt))) amt3, \n"
				+ "        count(decode(nvl(a.ins_tm2,'0'),'2',a.car_mng_id)) cnt4, --환급보험료(4) \n"
				+ "        sum  (decode(nvl(a.ins_tm2,'0'),'2',a.pay_amt)) amt4, \n"
				+ "        count(decode(nvl(a.ins_tm2,'0'),'1',decode(sign(a.pay_amt),1,0,a.car_mng_id))) cnt5, --추가환급보험료(5) \n"
				+ "        sum  (decode(nvl(a.ins_tm2,'0'),'1',decode(sign(a.pay_amt),1,0,a.pay_amt))) amt5 \n"
				+ " from   scd_ins a, car_reg c, insur b, ins_com d \n" + " where \n"
				+ "        a.car_mng_id=c.car_mng_id \n" + " and    a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"
				+ " and    a.pay_dt like '" + settle_year + "%' \n" + " and    b.ins_com_id=d.ins_com_id "
				+ " group by b.ins_com_id, d.ins_com_nm, decode(b.car_use,'3',c.car_use,b.car_use) \n"
				+ " order by b.ins_com_id, d.ins_com_nm, decode(b.car_use,'3',c.car_use,b.car_use) \n" + " ) \n" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list1]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료6 - 선급보험료 가입분조회
	 */
	public Vector getSettleAccount_list6(String insurmmyy1, String insurgubun) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		if (insurgubun.equals("1")) {
			sub_query = " and a.car_use='1' ";
		}
		if (insurgubun.equals("2")) {
			sub_query = " and a.car_use<>'1' ";
		}

		query = "  SELECT * FROM ( \n"
				+ "  select a.car_no, (b.cost_amt+b.rest_amt)-a.rest_amt as amt, c.car_no AS car_no2  \n"
				+ "  from   precost a, precost b, car_reg c \n" + "  where  a.cost_st='2'  \n"
				+ "  and a.car_mng_id=b.car_mng_id and a.cost_st=b.cost_st and a.cost_id=b.cost_id  \n"
				+ "  and a.cost_tm=(b.cost_tm-1)  \n" + "  and b.cost_ym='" + insurmmyy1 + "'  \n"
				+ "  and a.rest_amt-(b.cost_amt+b.rest_amt)<>0  \n" + sub_query + "  and a.car_mng_id=c.car_mng_id  \n"
				+ "  UNION all  \n" + "  select a.car_no, a.cost_amt+a.REST_AMT as amt, c.car_no AS car_no2  \n"
				+ "  from   precost a, insur b, car_reg c  \n" + "  where  a.cost_st='2' and a.cost_ym='" + insurmmyy1
				+ "' and a.cost_tm='1'  \n" + sub_query + "  and a.car_mng_id=b.car_mng_id and a.cost_id=b.ins_st  \n"
				+ "   AND a.car_mng_id=c.car_mng_id        \n" + "  )    order by 1  \n" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list6]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료7 - 선급보험료 변경분조회
	 */
	public Vector getSettleAccount_list7(String changemmyy1, String changegubun) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		if (changegubun.equals("1")) {
			sub_query = " and a.car_use='1' ";
		}
		if (changegubun.equals("2")) {
			sub_query = " and a.car_use<>'1' ";
		}

		query = "  select a.car_no, (b.cost_amt+b.rest_amt)-a.rest_amt as amt  \n"
				+ "  from   precost a, precost b, car_reg c   \n" + "  where  a.cost_st='2' and a.cost_ym='"
				+ changemmyy1 + "'  " + "  and a.rest_amt>0  "
				+ "  and a.car_mng_id=b.car_mng_id and a.cost_st=b.cost_st and a.cost_id=b.cost_id and a.cost_tm=(b.cost_tm-1)  \n"
				+ "  and a.rest_amt-(b.cost_amt+b.rest_amt)<>0   \n  " + sub_query + "  and a.car_mng_id=c.car_mng_id  "
				+ "  order by (b.cost_amt+b.rest_amt)-a.rest_amt, a.car_no  " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list7]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료1 - 자동차보험료 전년대비 지급현황 - 차량대수
	 */
	public Vector getSettleAccount_list1_sub1(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.ins_com_id, decode(b.car_use,'3',c.car_use,b.car_use) car_use, \n"
				+ "        count(*) t_cnt, sum(a.pay_amt) pay_amt \n"
				+ " from   (select car_mng_id, ins_st, sum(decode(nvl(ins_tm2,'0'),'2',-pay_amt,pay_amt)) pay_amt from scd_ins \n"
				+ "         where pay_dt like '" + settle_year + "%' group by car_mng_id, ins_st) a, \n"
				+ "        insur b, car_reg c \n" + " where  a.car_mng_id=b.car_mng_id and a.ins_st=b.ins_st \n"
				+ " and    a.car_mng_id=c.car_mng_id \n"
				+ " group by b.ins_com_id, decode(b.car_use,'3',c.car_use,b.car_use) \n"
				+ " order by b.ins_com_id, decode(b.car_use,'3',c.car_use,b.car_use) \n" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list1_sub1]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료2 - 1월 지급(예정) 할부금 리스트
	 */
	public Vector getSettleAccount_list2(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "                select \r\n"
				+ "				        rent_l_cd, rtn_seq, car_no, cpt_nm, lend_int, alt_tm, s_dt, cls_rtn_dt, alt_est_dt, alt_prn, alt_int, alt_amt, alt_rest, \r\n"
				+ "				        trunc(alt_int/days1*days2,0) amt, \r\n"
				+ "				        days1, days2 \r\n" 
				+ "				 from \r\n" 
				+ "				   ( \r\n"
				+ "				      select \r\n" 
				+ "				      a.*, \r\n"
				+ "				      to_date(alt_est_dt,'YYYY-MM-DD')-to_date(s_dt,'YYYY-MM-DD') days1, \r\n"
				+ "				      to_date('" + settle_year + "-12-31','YYYY-MM-DD')-to_date(s_dt,'YYYY-MM-DD') days2 \r\n" 
				+ "				      from \r\n"
				+ "				      ( \r\n"
				+ "				      select to_char(add_months(to_date(a.alt_est_dt,'YYYY-MM-DD'),-1),'YYYY-MM-DD') s_dt, a.cls_rtn_dt, a.alt_est_dt, a.alt_prn, a.alt_int, a.alt_amt, a.alt_rest, a.rent_l_cd, a.rtn_seq, a.car_no, a.cpt_nm, a.lend_int, a.alt_tm \r\n"
				+ "				           from debt_pay_view a\r\n"
				+ "				           where a.alt_est_dt like '" + (AddUtil.parseInt(settle_year) + 1)+ "-01%' and a.alt_tm <>'0' AND a.lend_id IS NULL AND SUBSTR(lend_dt,1,4) <='" + settle_year + "1231' \r\n"
				+ "                   UNION ALL \r\n"
				+ "                   select to_char(add_months(to_date(a.alt_est_dt,'YYYY-MM-DD'),-1),'YYYY-MM-DD') s_dt, a.cls_rtn_dt, a.alt_est_dt, a.alt_prn, a.alt_int, a.alt_amt, a.alt_rest, a.rent_l_cd, a.rtn_seq, a.car_no, a.cpt_nm, a.lend_int, a.alt_tm \r\n"
				+ "				           from debt_pay_view a\r\n"
				+ "				           where a.alt_est_dt like '" + (AddUtil.parseInt(settle_year) + 1)+ "-01%' and a.alt_tm <>'0' AND a.lend_id IS NOT NULL AND SUBSTR(lend_dt,1,4) <='" + settle_year + "1231' \r\n"
				+ "				      ) a \r\n" 
				+ "				   )\r\n" 
				+ "           ORDER BY decode(cls_rtn_dt,'',0,1), alt_est_dt";
				

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list2]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료3 - 영업사원수당 지급현황
	 */
	public Vector getSettleAccount_list3(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT " + "        a.rent_l_cd, a.emp_acc_nm, a.sup_dt, a.commi_car_amt, a.comm_r_rt,  "
				+ "        NVL(A.COMMI,0) COMMI, NVL(a.dlv_con_commi,0) dlv_con_commi, nvl(a.dlv_tns_commi,0) dlv_tns_commi, NVL(a.agent_commi,0) agent_commi,  "
				+ "        DECODE(a.add_st1,'1',NVL(a.add_amt1,0),0)+DECODE(a.add_st2,'1',NVL(a.add_amt2,0),0)+DECODE(a.add_st3,'1',NVL(a.add_amt3,0),0) add_amt_a,  "
				+ "        NVL(A.COMMI,0)+NVL(a.dlv_con_commi,0)+nvl(a.dlv_tns_commi,0)+NVL(a.agent_commi,0)+DECODE(a.add_st1,'1',NVL(a.add_amt1,0),0)+DECODE(a.add_st2,'1',NVL(a.add_amt2,0),0)+DECODE(a.add_st3,'1',NVL(a.add_amt3,0),0) a_amt, "
				+ "        a.tot_per, NVL(a.inc_amt,0) inc_amt, NVL(a.res_amt,0) res_amt, NVL(a.tot_amt,0) tot_amt,  "
				+ "        DECODE(a.add_st1,'2',NVL(a.add_amt1,0),0)+DECODE(a.add_st2,'2',NVL(a.add_amt2,0),0)+DECODE(a.add_st3,'2',NVL(a.add_amt3,0),0) b_amt, "
				+ "        a.dif_amt " + " FROM   COMMI a " + " WHERE  a.sup_dt like '" + settle_year + "%' "
				+ " ORDER BY a.sup_dt  " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list3]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료4 - 계약보증금리스트
	 */
	public Vector getSettleAccount_list4(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT "
				+ "        d.ven_code, d.firm_nm, DECODE(d.client_st,'2',substr(TEXT_DECRYPT(ssn, 'pw'),1,6) ,enp_no) enp_no, NVL(g.car_no,'미등록') car_no, "
				+ "        a.rent_dt, " + "        DECODE(b.rent_st,'1','','연장') rent_st, "
				+ "        b.rent_start_dt, b.rent_end_dt, "
				+ "        case when b.rent_end_dt<h.rent_end_dt then h.rent_end_dt ELSE '' end im_end_dt, "
				+ "        f.cls_dt, "
				+ "        b.grt_amt_s grt_amt, b.grt_amt_s-e.pay_amt dly_amt, b.grt_amt_s-( b.grt_amt_s-e.pay_amt) r_grt_amt, "
				+ "        case when b.rent_end_dt<h.rent_end_dt then h.rent_end_dt ELSE b.rent_end_dt END e_dt, "
				+ "        substr(case when b.rent_end_dt<h.rent_end_dt then h.rent_end_dt ELSE b.rent_end_dt END,1,4) e_year "
				+ " FROM   CONT a, CLS_CONT f, FEE b, "
				+ "        ( SELECT rent_mng_id, rent_l_cd, MAX(to_number(rent_st)) rent_st FROM FEE GROUP BY rent_mng_id, rent_l_cd ) c, "
				+ "		   CLIENT d, "
				+ " 	   ( select rent_mng_id, rent_l_cd, sum(ext_pay_amt) pay_amt, MIN(ext_pay_dt) pay_dt  "
				+ " 		   from   scd_ext  " + " 		   where  ext_st='0' and ext_pay_amt>0 AND ext_pay_dt < '"
				+ (AddUtil.parseInt(settle_year) + 1) + "0101'  " + " 		   group by rent_mng_id, rent_l_cd  "
				+ " 		 ) e, " + "        CAR_REG g, "
				+ "        (SELECT rent_mng_id, rent_l_cd, MAX(rent_end_dt) rent_end_dt FROM FEE_IM GROUP BY rent_mng_id, rent_l_cd) h  "
				+ " WHERE  a.car_st in ('1','3','4') AND a.rent_l_cd NOT LIKE 'RM%' "
				+ "        AND a.rent_mng_id=f.rent_mng_id(+) AND a.rent_l_cd=f.rent_l_cd(+) "
				+ "        AND (NVL(a.use_yn,'Y')='Y' OR f.cls_dt >= '" + (AddUtil.parseInt(settle_year) + 1)
				+ "0101') " + " 		 AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd "
				+ " 		 AND b.rent_mng_id=c.rent_mng_id AND b.rent_l_cd=c.rent_l_cd AND b.rent_st=c.rent_st  "
				+ " 		 AND b.grt_amt_s>0  " + " 		 AND a.client_id=d.client_id  "
				+ " 		 and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd "
				+ "        AND a.car_mng_id=g.car_mng_id(+)  "
				+ "        AND a.rent_mng_id=h.rent_mng_id(+) AND a.rent_l_cd=h.rent_l_cd(+) "
				+ " ORDER BY d.ven_code  " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list4]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	// 계약 한건 검색 : cont 조회 // rent_mng_id
	public String getRent_mng_id(String rent_l_cd) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String rtnStr = "";

		query = " select  rent_mng_id from cont where rent_l_cd= ? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_l_cd);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				rtnStr = rs.getString(1) == null ? "" : rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return rtnStr;
		}
	}

	/**
	 * 인천과태료리스트
	 */

	public Vector acar_car_excel_incheon(String s_kd, String st_dt, String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select d.CLIENT_ST, cc.CAR_NO, c.FIRM_NM, c.CLIENT_ID, c.CLIENT_NM, c.RENT_START_DT, c.RENT_END_DT, d.O_ADDR, d.O_ZIP, d.CON_AGNT_O_TEL, d.O_TEL, d.M_TEL, d.ENP_NO, TEXT_DECRYPT(d.ssn, 'pw' )  SSN, a.* \n"
				+ " FROM FINE a,  CONT_N_VIEW c, CLIENT d, car_reg cc   WHERE   a.RENT_MNG_ID = c.RENT_MNG_ID AND a.RENT_L_CD = c.RENT_L_CD AND a.CAR_MNG_ID = c.CAR_MNG_ID AND c.CLIENT_ID = d.CLIENT_ID and  a.car_mng_id = cc.car_mng_id \n"
				+ " and a.note = '인천과태료 엑셀파일로 한꺼번에 등록' ";

		if (!st_dt.equals("") && end_dt.equals(""))
			query += " and a.reg_dt like replace('" + st_dt + "%', '-','')";

		if (!st_dt.equals("") && !end_dt.equals(""))
			query += " and a.reg_dt between replace('" + st_dt + "', '-','') and replace('" + end_dt + "', '-','')";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:acar_car_excel_incheon]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 도로공사 과태료리스트
	 */

	public Vector acar_car_excel_doro(String s_kd, String st_dt, String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select d.CLIENT_ST, cc.CAR_NO, c.FIRM_NM, c.CLIENT_ID, c.CLIENT_NM, c.RENT_START_DT, c.RENT_END_DT, d.O_ADDR, d.O_ZIP, d.CON_AGNT_O_TEL, d.O_TEL, d.M_TEL, d.ENP_NO, TEXT_DECRYPT(d.ssn, 'pw' )  SSN, a.* \n"
				+ " FROM FINE a,  CONT_N_VIEW c, CLIENT d, car_reg cc   WHERE   a.RENT_MNG_ID = c.RENT_MNG_ID AND a.RENT_L_CD = c.RENT_L_CD AND a.CAR_MNG_ID = c.CAR_MNG_ID AND c.CLIENT_ID = d.CLIENT_ID and  a.car_mng_id = cc.car_mng_id \n"
				+ " and a.note like '%한꺼번에 등록%' ";

		if (!st_dt.equals("") && end_dt.equals(""))
			query += " and a.reg_dt like replace('" + st_dt + "%', '-','')";

		if (!st_dt.equals("") && !end_dt.equals(""))
			query += " and a.reg_dt between replace('" + st_dt + "', '-','') and replace('" + end_dt + "', '-','')";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:acar_car_excel_incheon]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 월마감-제조사별차량현황
	 */
	public Vector getSelectStatEndCarCompDB(String save_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT d.nm 제조사, COUNT(*) 차량대수 " + " FROM STAT_RENT_MONTH a, CAR_ETC b, CAR_NM c, CODE d  "
				+ " WHERE a.save_dt=replace('" + save_dt
				+ "','-','') AND a.car_mng_id IS NOT NULL AND a.prepare NOT IN ('4','5')  "
				+ " AND a.rent_l_cd=b.rent_l_cd " + " AND b.car_id=c.CAR_id AND b.car_seq=c.car_seq "
				+ " AND c.car_comp_id=D.CODE AND d.c_st='0001' " + " GROUP BY c.car_comp_id, d.nm "
				+ " order BY c.car_comp_id " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndCarCompDB]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 내부요청자료 01
	 */
	public Vector getInsideReq01(String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "
				+ "        a.rent_l_cd, d.car_nm, c.car_name, e.car_no, nvl(f.firm_nm,f.client_nm) firm_nm, f.client_nm,  "
				+ "        DECODE(a.car_st,'2','보유차',decode(a.car_gu,'1','신차','0','재리스','3','월렌트')) car_gu, "
				+ "        decode(a.car_st,'2','보유차','1','렌트','3','리스','4','월렌트','5','업무대여') car_st, "
				+ "        decode(a.rent_st,'1','신규','3','대차','4','증차')||DECODE(g.rent_st,'1','','(연장)') rent_st, "
				+ "        decode(g.rent_way,'1','일반식','2','맞춤식','3','기본식') rent_way,  "
				+ "        (g.fee_s_amt+g.fee_v_amt) fee_amt,  "
				+ "        decode(a.rent_start_dt,null,'',substr(a.rent_start_dt,1,4)||'-'||substr(a.rent_start_dt,5,2)||'-'||substr(a.rent_start_dt,7,2)) as rent_start_dt, "
				+ "        decode(g.rent_end_dt,null,'',substr(g.rent_end_dt,1,4)||'-'||substr(g.rent_end_dt,5,2)||'-'||substr(g.rent_end_dt,7,2)) as rent_end_dt, "
				+ "        j.nm as car_kd, " + "        e.dpm,  " + "        (b.car_cs_amt+b.car_cv_amt) car_c_amt, "
				+ "        (b.opt_cs_amt+b.opt_cv_amt) opt_c_amt, b.opt, "
				+ "        (b.clr_cs_amt+b.clr_cv_amt) clr_c_amt, b.colo, b.in_col, b.garnish_col, "
				+ "        (b.sd_cs_amt+b.sd_cv_amt) sd_c_amt, "
				+ "        (b.tax_dc_s_amt+b.tax_dc_v_amt) tax_dc_amt, "
				+ "        (b.car_cs_amt+b.car_cv_amt+b.opt_cs_amt+b.opt_cv_amt+b.clr_cs_amt+b.clr_cv_amt+b.sd_cs_amt+b.sd_cv_amt-b.tax_dc_s_amt-b.tax_dc_v_amt) car_ct_amt, "
				+ "        (b.car_fs_amt+b.car_fv_amt) car_f_amt, " + "        (b.dc_cs_amt+b.dc_cv_amt) dc_c_amt, "
				+ "        (b.car_fs_amt+b.car_fv_amt-b.dc_cs_amt-b.dc_cv_amt) car_ft_amt, "
				+ "        decode(a.dlv_dt,null,'',substr(a.dlv_dt,1,4)||'-'||substr(a.dlv_dt,5,2)||'-'||substr(a.dlv_dt,7,2)) as dlv_dt, "
				+ "        decode(e.init_reg_dt,null,'',substr(e.init_reg_dt,1,4)||'-'||substr(e.init_reg_dt,5,2)||'-'||substr(e.init_reg_dt,7,2)) as init_reg_dt, "
				+ "        i.nm as fuel_kd, "
				+ "        decode(vt.tot_dist,'',0,'0',0,decode(vt.tot_dt,nvl(a.dlv_dt,e.init_reg_dt),0,vt.tot_dist+round(vt.tot_dist/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(nvl(a.dlv_dt,e.init_reg_dt),'YYYYMMDD')))*(to_date(to_char(sysdate,'YYYYMMDD'),'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))) as TODAY_DIST "
				+ " from   cont a, car_etc b, car_nm c, car_mng d, car_reg e, client f, fee g, "
				+ "        v_tot_dist vt, " + "        (select * from code where c_st='0039') i, "
				+ "        (select * from code where c_st='0041') j  " + " where  NVL(a.use_yn,'Y')='Y'  "
				+ "        and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "
				+ "        and b.car_id=c.car_id and b.car_seq=c.car_seq and c.car_comp_id=d.car_comp_id and c.car_cd=d.code "
				+ "        and a.car_mng_id=e.car_mng_id(+) " + "        and a.client_id=f.client_id "
				+ "        and a.rent_mng_id=g.rent_mng_id and a.rent_l_cd=g.rent_l_cd "
				+ "        and g.rent_st=(select max(to_number(rent_st)) from fee where rent_mng_id=a.rent_mng_id and rent_l_cd=a.rent_l_cd) "
				+ "        and a.car_mng_id = vt.car_mng_id(+) " + "        and e.fuel_kd=i.nm_cd "
				+ "        and e.car_kd=j.nm_cd " + " ORDER BY a.dlv_dt, a.rent_dt" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getInsideReq01]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 내부요청자료 02
	 */
	public Vector getInsideReq02() {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "  SELECT DISTINCT A.RENT_L_CD AS rent_l_cd , " + "  G.CLIENT_NM AS client_nm,    "
				+ "  G.FIRM_NM AS firm_nm,      " + "  F.USER_NM AS user_nm,  " + "  c.jg_code AS jg_code,    "
				+ "  d.car_nm AS car_nm,        " + "  c.car_name AS car_name,      "
				+ "  (b.car_cs_amt+b.car_cv_amt) AS car_amt,    " + "  b.opt AS opt,   "
				+ "  (b.opt_cs_amt+b.opt_cv_amt) AS opt_amt,     "
				+ "  B.COLO AS colo, B.IN_COL AS in_col, B.garnish_col,  " + // 내장색상 추가(20190828)
				"  (b.clr_cs_amt+b.clr_cv_amt) AS clr_amt,     "
				+ "  (b.car_cs_amt+b.car_cv_amt + b.opt_cs_amt+b.opt_cv_amt + b.clr_cs_amt+b.clr_cv_amt ) AS cs_amt,  "
				+ "  H.DLV_BRCH AS dlv_brch,   " + "  A.RENT_DT AS rent_dt,      "
				+ "  decode(H.ONE_SELF, 'Y','자체출고','N','영업사원출고') AS one_self,  " + "  H.DLV_EST_DT AS dlv_est_dt,  "
				+ "  A.DLV_DT AS dlv_dt_as,   " + "  e.INIT_REG_DT AS init_reg_dt,  " + "  e.CAR_NO AS car_no,      "
				+ "  e.car_num AS car_num      "
				+ "  FROM cont a, car_etc b, car_nm c, car_mng d, car_reg e, USERS F, CLIENT G, CAR_PUR H  "
				+ "  WHERE a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd   "
				+ "  AND b.car_id=c.car_id AND b.car_seq=c.car_seq  "
				+ "  AND c.car_comp_id=d.car_comp_id AND c.car_cd=d.code " + "  AND a.car_mng_id=e.car_mng_id   "
				+ "  AND A.BUS_ID = F.USER_ID        " + "  AND A.CLIENT_ID = G.CLIENT_ID   "
				+ "  AND B.RENT_MNG_ID = H.RENT_MNG_ID AND B.RENT_L_CD = H.RENT_L_CD   "
				+ "  AND NVL(a.USE_YN,'N') = 'Y'   " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getInsideReq02]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 내부요청자료 03
	 */
	public Vector getInsideReq03(String start_dt, String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "  SELECT DISTINCT g.CAR_NUM as CAR_NUM, " + "  d.s_st as s_st,  " + "  d.jg_code as jg_code,  "
				+ "  d.sh_code as sh_code ,  " + "  i.CAR_NM as car_nm,  " + "  g.CAR_Y_FORM as car_y_form,  "
				+ "  g.dpm as dpm,  " + "  i2.nm as fuel_kd, " + "  d.car_name as car_name, " + "  g.car_no as car_no, "
				+ "  g.FIRST_CAR_NO as first_car_no,  " + "  g.init_reg_dt as INIT_REG_DT , " + "  a.DLV_DT as DLV_DT, "
				+ "  ( c.car_cs_amt + c.car_cv_amt ) as car_amt, " + "  ( c.opt_cs_amt + c.opt_cv_amt ) as opt_amt, "
				+ "   c.CAR_FS_AMT AS car_fs_amt, c.CAR_FV_AMT AS CAR_FV_AMT, "
				+ "  ( c.car_fs_amt + c.car_fv_amt ) as car_fsv_amt , " + "  c.OPT as opt, "
				+ "  ( c.clr_cs_amt + c.clr_cv_amt ) as clr_amt, "
				+ "  c.COLO as colo, c.IN_COL as in_col, c.garnish_col, "
				+ "  ( c.DC_CS_AMT + c.DC_CV_AMT ) AS dc_amt , "
				+ "   decode( c.PURC_GU, 0, '면세', 1, '과세' ) AS PURC_GU , " + "   d.AUTO_YN AS AUTO, " + "   d.CAR_B , "
				+ "   CASE WHEN d.AUTO_YN = 'Y' THEN 'A/T' WHEN c.OPT LIKE '%변속기%' OR c.OPT LIKE '%DCT%' OR c.OPT LIKE '%C-TECH%' OR c.OPT LIKE '%A/T%' THEN 'A/T' WHEN d.CAR_B LIKE '%자동변속기%' OR d.CAR_B LIKE '%무단 변속기%' THEN 'A/T' ELSE 'M/T' END AS auto_yn"
				+ "   FROM  cont a, fee b, car_etc c, car_nm d, car_reg g, cls_cont e, fee_etc h, (SELECT * FROM cls_cont WHERE cls_st IN ( '4', '5' ) ) f, car_mng i, "
				+ "         (select * from code where c_st='0039') i2 "
				+ "   WHERE a.car_st NOT IN('2','4') AND a.car_gu = '1'  "
				+ "   AND a.rent_mng_id = b.rent_mng_id AND a.rent_l_cd = b.rent_l_cd AND b.rent_st = '1' "
				+ "   AND a.rent_mng_id = c.rent_mng_id AND a.rent_l_cd = c.rent_l_cd "
				+ "   AND c.car_id = d.car_id AND c.car_seq = d.car_seq  " + "   AND a.car_mng_id = g.car_mng_id "
				+ "   AND a.rent_mng_id = e.rent_mng_id(+) AND a.rent_l_cd = e.rent_l_cd(+) AND nvl(e.cls_st,'0') NOT IN ('7','10') "
				+ "   AND b.rent_mng_id = h.rent_mng_id AND b.rent_l_cd = h.rent_l_cd AND b.rent_st = h.rent_st "
				+ "   AND a.rent_mng_id = f.rent_mng_id(+) AND a.reg_dt = f.reg_dt(+) "
				+ "   AND d.car_comp_id = i.car_comp_id AND d.car_cd = i.code "
				+ "   AND CASE WHEN f.rent_l_cd IS NOT NULL AND a.reg_dt < to_char( nvl( h.reg_dt, b.rent_dt ), 'YYYYMMDD' ) THEN '' ELSE f.rent_l_cd END IS NULL "
				+ "   and g.FUEL_KD=i2.nm_cd " + " ";

		if (!start_dt.equals("")) {
			query += "AND a.DLV_DT >= " + start_dt;
		}
		if (!end_dt.equals("")) {
			query += "AND a.DLV_DT <= " + end_dt;
		}
		if (start_dt.equals("") && end_dt.equals("")) {

			// 현재 년월 구하기
			Calendar calendar = Calendar.getInstance();
			int curYear = calendar.get(Calendar.YEAR);
			int curMonth = calendar.get(Calendar.MONTH) + 1;
			String stringMonth = "";
			if (curMonth < 10) {
				stringMonth = "0" + String.valueOf(curMonth);
			} else {
				stringMonth = String.valueOf(curMonth);
			}
			String curYM = String.valueOf(curYear) + stringMonth;

			query += "AND a.DLV_DT LIKE '" + curYM + "%'";
		}

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getInsideReq03]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 내부요청자료 04
	 */
	public Vector getInsideReq04() {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT f.nm as car_comp_nm, b.car_num, e.car_nm, d.car_name, DECODE(a.car_st,'1','렌트','2','보유차','3','리스','4','월렌트','-') car_st "
				+ " FROM   cont a, car_reg b, car_etc c, car_nm d, car_mng e, (SELECT code, nm, app_st FROM code WHERE c_st='0001' AND CODE<>'0000') f "
				+ " WHERE  (a.use_yn='Y' OR a.use_yn IS null) " + "        AND a.car_mng_id=b.car_mng_id "
				+ "        AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd "
				+ "        AND c.car_id=d.car_id AND c.car_seq=d.car_seq "
				+ "        AND d.car_comp_id=e.car_comp_id AND d.car_cd=e.code " + "        AND d.car_comp_id=f.code  "
				+ " ORDER BY f.app_st, f.nm, e.car_nm, d.jg_code, d.car_b_p " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getInsideReq04]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료4 - 차입금현황
	 */
	public Vector getSettleAccount_list5(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT "
				+ "        d.nm, round(b.over_mon_amt,-3)/1000 amt2, round(a.over_mon_amt,-3)/1000 amt1, round(f.alt_rest,-3)/1000 amt3, "
				+ "        TO_CHAR(c.min_int,99.99) min_int, TO_CHAR(c.max_int,99.99) max_int,  "
				+ "        TO_CHAR(c2.min_int,99.99) min_int2, TO_CHAR(c2.max_int,99.99) max_int2  " + " FROM "
				+ "        (SELECT cpt_cd_st, cpt_cd FROM STAT_DEBT WHERE save_dt IN ('" + settle_year + "1231','"
				+ (AddUtil.parseInt(settle_year) - 1) + "1231') GROUP BY cpt_cd_st, cpt_cd) e, "
				+ "        (SELECT cpt_cd, over_mon_amt FROM STAT_DEBT WHERE save_dt='" + settle_year + "1231') a, " + // 결산년도현황
				"        (SELECT cpt_cd, over_mon_amt FROM STAT_DEBT WHERE save_dt='"
				+ (AddUtil.parseInt(settle_year) - 1) + "1231') b, " + // 결산전년도현황
				"        (SELECT cpt_cd, MIN(TO_NUMBER(lend_int)) min_int, MAX(TO_NUMBER(lend_int)) max_int FROM DEBT_pay_VIEW WHERE lend_dt LIKE '"
				+ settle_year + "%' GROUP BY cpt_cd) c, " + // 결산년도이자
				"        (SELECT cpt_cd, MIN(TO_NUMBER(lend_int)) min_int, MAX(TO_NUMBER(lend_int)) max_int FROM DEBT_pay_VIEW WHERE lend_dt LIKE '"
				+ (AddUtil.parseInt(settle_year) - 1) + "%' GROUP BY cpt_cd) c2, " + // 결산전년도이자
				"        (SELECT cpt_cd, SUM(alt_rest) alt_rest FROM DEBT_pay_VIEW WHERE lend_dt LIKE  '" + settle_year
				+ "%'  AND alt_tm=0 GROUP BY cpt_cd) f, " + // 결산당기 신규차입금
				"        (SELECT * FROM CODE  WHERE c_st='0003') d " + " WHERE  " + " e.cpt_cd=a.cpt_cd(+) "
				+ " AND e.cpt_cd=b.cpt_cd(+) " + " AND e.cpt_cd=c.cpt_cd(+) " + " AND e.cpt_cd=c2.cpt_cd(+) "
				+ " AND e.cpt_cd=f.cpt_cd(+) " + " AND e.cpt_cd=D.CODE " + " ORDER BY e.cpt_cd_st, e.cpt_cd  " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list5]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 사원별차량배정현황 20140416
	 */
	public Vector getDlyBusStatMD2(String br_id, String sort, String asc) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT \n" + "        b.loan_st, b.br_id, b.user_id, b.user_nm, min(b.enter_dt) enter_dt,  \n"
				+ "        COUNT(a.rent_l_cd) cnt0, SUM(a.fee_amt) fee_amt0, SUM(a.dly_amt) dly_amt0, trunc((SUM(a.dly_amt)/SUM(a.fee_amt))*100,2) per0, \n"
				+ "        COUNT(DECODE(a.rent_way,'1',a.rent_l_cd)) cnt1, SUM(DECODE(a.rent_way,'1',a.fee_amt)) fee_amt1, SUM(DECODE(a.rent_way,'1',a.dly_amt)) dly_amt1, trunc((SUM(DECODE(a.rent_way,'1',a.dly_amt))/SUM(DECODE(a.rent_way,'1',a.fee_amt)))*100,2) per1, \n"
				+ "        COUNT(DECODE(a.rent_way,'3',a.rent_l_cd)) cnt2, SUM(DECODE(a.rent_way,'3',a.fee_amt)) fee_amt2, SUM(DECODE(a.rent_way,'3',a.dly_amt)) dly_amt2, trunc((SUM(DECODE(a.rent_way,'3',a.dly_amt))/SUM(DECODE(a.rent_way,'3',a.fee_amt)))*100,2) per2 \n"
				+ " from   \n" + "        ( \n"
				+ "          SELECT a.rent_l_cd, a.client_id, a.bus_id2, b.rent_way, DECODE(c.rent_l_cd, '', (b.fee_s_amt+b.fee_v_amt)*b.con_mon, c.fee_amt) fee_amt, NVL(c.dly_amt,0) dly_amt \n"
				+ "          FROM   CONT a, FEE b,  \n" + "                 ( SELECT rent_mng_id, rent_l_cd, \n"
				+ "                          sum(DECODE(tm_st1,'0',fee_s_amt+fee_v_amt,0)) fee_amt,  \n"
				+ "                          SUM(CASE WHEN rc_amt=0 AND r_fee_est_dt<TO_CHAR(SYSDATE,'YYYYMMDD') THEN fee_s_amt+fee_v_amt ELSE 0 end) dly_amt  \n"
				+ "                   FROM   SCD_FEE WHERE bill_yn='Y' and tm_st2<>'4' GROUP BY rent_mng_id, rent_l_cd \n"
				+ "                 ) c        \n"
				+ "          WHERE  NVL(a.use_yn,'Y')='Y' AND a.car_st in ('1','3') and nvl(a.reg_step,'4')<>'1' \n"
				+ "                 AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \n"
				+ "                 AND b.RENT_ST IN (SELECT MAX(to_number(rent_st)) rent_st FROM FEE WHERE rent_l_cd=a.rent_l_cd) \n"
				+ "                 AND a.rent_mng_id=c.rent_mng_id(+) AND a.rent_l_cd=c.rent_l_cd(+) \n"
				+ "        ) a, USERS b \n" + " WHERE  a.bus_id2=b.user_id and b.dept_id not in ('0003') \n"
				+ " GROUP BY b.loan_st, b.br_id, b.user_id, b.user_nm \n" + " ";

		if (sort.equals("1"))
			query += " order by b.loan_st, b.br_id, b.user_id, b.user_nm " + asc;
		else if (sort.equals("2"))
			query += " order by b.loan_st, b.br_id, min(b.enter_dt) " + asc;
		else if (sort.equals("3"))
			query += " order by COUNT(a.rent_l_cd) " + asc + ", SUM(a.fee_amt) desc ";
		else if (sort.equals("4"))
			query += " order by SUM(a.fee_amt) " + asc;
		else if (sort.equals("5"))
			query += " order by COUNT(DECODE(a.rent_way,'1',a.rent_l_cd)) " + asc
					+ ", SUM(DECODE(a.rent_way,'1',a.fee_amt)) desc ";
		else if (sort.equals("6"))
			query += " order by SUM(DECODE(a.rent_way,'1',a.fee_amt)) " + asc;
		else if (sort.equals("7"))
			query += " order by COUNT(DECODE(a.rent_way,'3',a.rent_l_cd)) " + asc
					+ ", SUM(DECODE(a.rent_way,'3',a.fee_amt)) desc ";
		else if (sort.equals("8"))
			query += " order by SUM(DECODE(a.rent_way,'3',a.fee_amt)) " + asc;
		else if (sort.equals("10"))
			query += " order by trunc((SUM(a.dly_amt)/SUM(a.fee_amt))*100,2) " + asc;

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getDlyBusStatMD2]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	// 계약 한건 검색 : cont 조회 // rent_mng_id
	public String getSysPrvDt() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String rtnStr = "";

		query = " select to_char(add_months(sysdate, -1), 'YYYYMMDD') from dual ";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				rtnStr = rs.getString(1) == null ? "" : rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return rtnStr;
		}
	}

	// 기본식 케어 대상자
	public Vector getContCare() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "   select b.mgr_email     \n" + "	        from cont_n_view a, car_mgr b     \n"
				+ "	        where a.use_yn = 'Y' and a.rent_way_cd = '3' and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd     \n"
				+ "	        and b.mgr_email is not null and length(trim(b.mgr_email)) >12  \n"
				+ "	        group by   b.mgr_email ";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getContCare]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	// 계약 한건 검색 : mail_addrss
	public Vector getContCareEmail(String e_mail) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "  select distinct    c.car_nm, c.car_no, u.user_pos, u.user_nm, u.user_m_tel       \n"
				+ "               from cont_n_view a, car_mgr b, car_reg c, users u \n"
				+ "               where a.use_yn = 'Y' and a.rent_way_cd = '3' and a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd \n"
				+ "               and a.car_mng_id = c.car_mng_id and a.mng_id = u.user_id \n"
				+ "               and b.mgr_email = '" + e_mail + "' ";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getContCareEmail]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	// 싼파페보상 대상자
	public Vector getSantafeCont() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.* , b.firm_nm, b.CON_AGNT_EMAIL , u.user_nm ,  u.user_pos,  u.user_m_tel  from temp_car_no a, cont c, client b , users u   \n"
				+ "	where a.rent_l_cd =  c.rent_l_cd and c.client_id = b.client_id  and c.mng_id = u.user_id   order by a.num  ";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSantafeCont]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/*
	 * 영업수당 스캔파일 동기화 호출
	 */
	public String call_sp_commi_scanfile_syn(String rent_mng_id, String rent_l_cd, String user_id) {
		getConnection();

		String query = "{CALL p_commi_scanfile_syn (?,?,?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {
			cstmt = conn.prepareCall(query);

			cstmt.setString(1, rent_mng_id);
			cstmt.setString(2, rent_l_cd);
			cstmt.setString(3, user_id);

			cstmt.execute();
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_commi_scanfile_syn]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/*
	 * 장기대여계약 스캔파일 동기화 호출
	 */
	public String call_sp_lc_rent_scanfile_syn(String rent_mng_id, String rent_l_cd, String user_id) {
		getConnection();

		String query = "{CALL P_LC_RENT_SCANFILE_SYN (?,?,?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {
			cstmt = conn.prepareCall(query);

			cstmt.setString(1, rent_mng_id);
			cstmt.setString(2, rent_l_cd);
			cstmt.setString(3, user_id);

			cstmt.execute();
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_lc_rent_scanfile_syn]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	// paging
	public Vector getServAllNew3(String gubun, String gubun_nm, String gubun3, String gubun2, String sort,
			String car_ck, int page, int rowsPerPage) {
		int ROWS_PER_PAGE = 100;

		if (page <= 0) {
			page = 1;
		}

		if (rowsPerPage <= 0) {
			rowsPerPage = ROWS_PER_PAGE;
		}

		getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;

		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;

		String query = "";
		String subQuery = "";

		Vector vt = new Vector();

		if (gubun.equals("car_no")) {
			subQuery = "and a.car_no like '%" + gubun_nm + "%' \n";
		} else if (gubun.equals("firm_nm")) {
			subQuery = "and a.firm_nm like '%" + gubun_nm + "%' \n";
		} else if (gubun.equals("car_nm")) {
			subQuery = "and a.car_name like '%" + gubun_nm + "%' \n";
		} else if (gubun.equals("jg_code")) {
			subQuery = "and a.jg_code like '%" + gubun_nm + "%' \n";
		} else if (gubun.equals("mng_nm")) {
			subQuery = "and a.mng_nm like '%" + gubun_nm + "%' \n";
		}

		if (gubun3.equals("1") || gubun3.equals("2")) {
			subQuery += "and decode(a.car_use, '', decode(a.car_st, '1', '1', '3', '2'), a.car_use) = '" + gubun3 + "'";
		}

		if (gubun2.equals("3") || gubun2.equals("4")) {
			subQuery += "and decode(a.rent_way, '1', '3', '4') = '" + gubun2 + "'";
		}

		query = " select a.*, decode(a.rent_way, '1', '일반식', '3', '기본식', '보유차') rent_way_nm "
				+ "   from stat_car_mng a , users u  \n" + "  where a.mng_id = u.user_id(+) and a.chk1 is null "
				+ subQuery;

		if (sort.equals("1")) {
			query += "order by  a.reg_15_st, a.tot_dist  desc, a.init_reg_dt asc, a.rent_start_dt \n";
		} else if (sort.equals("2")) {
			query += "order by  a.reg_15_st, a.y_ave_dist desc, a.tot_dist desc, a.init_reg_dt asc, a.rent_start_dt \n";
		} else if (sort.equals("3")) {
			query += "order by  a.reg_15_st, a.init_reg_dt asc, a.rent_start_dt \n";
		}

		try {
			// 전체 레코드 개수를 가져오는 쿼리
			String prefixCountQuery = " select count(mng_id) from ( ";

			String suffixCountQuery = " ) countRows ";

			String countQuery = prefixCountQuery + query + suffixCountQuery;

			pstmt = conn.prepareStatement(countQuery);
			rs = pstmt.executeQuery();

			// 전체 레코드 개수
			int totalCount = 0;

			if (rs.next()) {
				totalCount = rs.getInt(1);
			}
			rs.close();
			pstmt.close();

			int startRecord = 1;
			int endRecord = 1;

			startRecord = (page - 1) * rowsPerPage; // 시작 레코드을 구함
			endRecord = startRecord + rowsPerPage; // 마지막 레코드를 구함

			// 페이지별로 레코드를 가져오는 쿼리
			String prefixPageQuery = " select *" + "   from (select ROWNUM as RNUM, T1.*" + "           from ( ";

			String suffixPageQUery = "        ) T1" + " ) WHERE RNUM >= " + (startRecord + 1) + " AND " + " RNUM <= "
					+ endRecord;

			String pageQuery = prefixPageQuery + query + suffixPageQUery;

			pstmt2 = conn.prepareStatement(pageQuery);
			rs2 = pstmt2.executeQuery();

			ResultSetMetaData rsmd = rs2.getMetaData();

			while (rs2.next()) {
				Hashtable ht = new Hashtable();

				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);

					ht.put(columnName, (rs2.getString(columnName)) == null ? "" : rs2.getString(columnName));
				}

				vt.add(ht);
			}

			rs2.close();
			pstmt2.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getServAllNew3]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (pstmt != null) {
					pstmt.close();
				}
				if (rs2 != null) {
					rs2.close();
				}
				if (pstmt2 != null) {
					pstmt2.close();
				}
			} catch (Exception ignore) {
			}

			closeConnection();
		}

		return vt;
	}

	/**
	 * 리스트조회
	 */
	public Vector getStatAttachFileStat() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT content_code, COUNT(0) cnt FROM ACAR_ATTACH_FILE GROUP BY content_code order BY content_code ";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();

			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatAttachFileStat]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/*
	 * 차량관리비용 마감 프로시져 호출
	 */
	public String call_sp_stat_car_mng_magam() {
		getConnection();

		String query = "{CALL P_STAT_CAR_MNG_MAGAM (?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {
			cstmt = conn.prepareCall(query);

			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);

			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_stat_car_mng_magam]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/*
	 * 장기대여계약 스캔파일 동기화 호출
	 */

	public String call_sp_lc_rent_scanfile_syn2(String cls_st, String rent_mng_id, String rent_l_cd,
			String new_rent_l_cd, String user_id) {
		getConnection();

		String query = "{CALL P_LC_RENT_SCANFILE_SYN2 (?,?,?,?,?)}";

		String sResult = "";

		CallableStatement cstmt = null;

		try {
			cstmt = conn.prepareCall(query);

			cstmt.setString(1, cls_st);
			cstmt.setString(2, rent_mng_id);
			cstmt.setString(3, rent_l_cd);
			cstmt.setString(4, new_rent_l_cd);
			cstmt.setString(5, user_id);

			cstmt.execute();
			cstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_lc_rent_scanfile_syn2]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/**
	 * 프로시져 호출
	 */
	public String call_sp_pay_account(String user_nm, String pay_code, String doc_type, String doc_dt) {
		getConnection();

		CallableStatement cstmt = null;
		CallableStatement cstmt2 = null;
		CallableStatement cstmt3 = null;

		String sResult = "";

		String query4 = "{CALL P_PAY_ACCOUNT_NEOE		(?,?,?,?,?)}";

		String query5 = "{CALL P_PAY_ACCOUNT_ETC_NEOE	(?,?,?,?,?)}";

		String query3 = "{CALL P_PAY_RESULT_SEND		(?,?,?,?,?)}";

		try {

			// 회계처리 프로시저 NEOE 1 호출(조회등록)
			cstmt = conn.prepareCall(query4);
			cstmt.setString(1, user_nm);
			cstmt.setString(2, pay_code);
			cstmt.setString(3, doc_type);
			cstmt.setString(4, doc_dt);
			cstmt.registerOutParameter(5, java.sql.Types.VARCHAR);
			cstmt.execute();
			sResult = cstmt.getString(5); // 결과값
			cstmt.close();

			// 회계처리 프로시저 NEOE 2 호출(직접등록)
			cstmt2 = conn.prepareCall(query5);
			cstmt2.setString(1, user_nm);
			cstmt2.setString(2, pay_code);
			cstmt2.setString(3, doc_type);
			cstmt2.setString(4, doc_dt);
			cstmt2.registerOutParameter(5, java.sql.Types.VARCHAR);
			cstmt2.execute();
			sResult = cstmt2.getString(5); // 결과값
			cstmt2.close();

			// 회계처리 프로시저2 호출(결과안내)
			cstmt3 = conn.prepareCall(query3);
			cstmt3.setString(1, user_nm);
			cstmt3.setString(2, pay_code);
			cstmt3.setString(3, doc_type);
			cstmt3.setString(4, doc_dt);
			cstmt3.registerOutParameter(5, java.sql.Types.VARCHAR);
			cstmt3.execute();
			sResult = cstmt3.getString(5); // 결과값
			cstmt3.close();

		} catch (Exception e) {
			System.out.println("[AdminDatabase:call_sp_pay_account]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
				if (cstmt2 != null)
					cstmt2.close();
				if (cstmt3 != null)
					cstmt3.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/**
	 * 프로시져 호출
	 */
	public String call_sp_pay_25300_autodocu(String user_nm, String reqseq) {
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";

		String query1 = "{CALL P_PAY_25300_AUTODOCU_NEOE     (?,?,?)}";

		try {

			// 회계처리 프로시저1 호출(조회등록)
			cstmt = conn.prepareCall(query1);
			cstmt.setString(1, user_nm);
			cstmt.setString(2, reqseq);
			cstmt.registerOutParameter(3, java.sql.Types.VARCHAR);
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값

			cstmt.close();

		} catch (Exception e) {
			System.out.println("[AdminDatabase:call_sp_pay_25300_autodocu]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/**
	 * 프로시져 호출
	 */
	public String call_sp_pay_25300_s_autodocu(String user_nm, String reqseq) {
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";

		String query1 = "{CALL P_PAY_25300_S_AUTODOCU_NEOE     (?,?,?)}";

		try {

			// 회계처리 프로시저1 호출(조회등록)
			cstmt = conn.prepareCall(query1);
			cstmt.setString(1, user_nm);
			cstmt.setString(2, reqseq);
			cstmt.registerOutParameter(3, java.sql.Types.VARCHAR);
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값

			cstmt.close();

		} catch (Exception e) {
			System.out.println("[AdminDatabase:call_sp_pay_25300_s_autodocu]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/**
	 * 결산관련자료4 - 계약보증금리스트
	 */
	public Vector getSettleAccount_list4_2016(String settle_year, String settle_st) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT "
				+ "        d.ven_code, d.firm_nm, DECODE(d.client_st,'2',TEXT_DECRYPT(d.ssn, 'pw'), d.enp_no) enp_no, NVL(g.car_no,'미등록') car_no, "
				+ "        a.rent_dt, " 
				+ "        DECODE(b.rent_st,'1','','연장') rent_st, "
				+ "        b.rent_start_dt, b.rent_end_dt, "
				+ "        case when b.rent_end_dt<h.rent_end_dt then h.rent_end_dt ELSE '' end im_end_dt, "
				+ "        f.cls_dt, "
				+ "        b.grt_amt_s grt_amt, e.pay_amt, (b.grt_amt_s-e.pay_amt) dly_amt, b.grt_amt_s-( b.grt_amt_s-e.pay_amt) r_grt_amt, "
				+ "        case when b.rent_end_dt<h.rent_end_dt then h.rent_end_dt ELSE b.rent_end_dt END e_dt, "
				+ "        substr(case when b.rent_end_dt<h.rent_end_dt then h.rent_end_dt ELSE b.rent_end_dt END,1,4) e_year "
				+ " FROM   CONT a, CLS_CONT f, FEE b, "
				+ "        ( SELECT rent_mng_id, rent_l_cd, MAX(to_number(rent_st)) rent_st " 
				+ " 	       FROM   FEE "
				+ " 	       GROUP BY rent_mng_id, rent_l_cd " 
				+ " 	     ) c, " 
				+ " 		 CLIENT d, "
				+ " 		 ( select rent_mng_id, rent_l_cd, sum(ext_pay_amt) pay_amt, MIN(ext_pay_dt) pay_dt  "
				+ " 		   from   scd_ext  " 
				+ " 		   where  ext_st='0' and ext_pay_amt>0 AND ext_pay_dt < '"	+ (AddUtil.parseInt(settle_year) + 1) + "0101'  " 
				+ " 		   group by rent_mng_id, rent_l_cd  "
				+ " 		 ) e, " 
				+ "        CAR_REG g, "
				+ "        (SELECT rent_mng_id, rent_l_cd, MAX(rent_end_dt) rent_end_dt FROM FEE_IM GROUP BY rent_mng_id, rent_l_cd) h  "
				+ " WHERE  a.car_st in ('1','3','4') AND a.rent_l_cd NOT LIKE 'RM%' "
				+ "        AND a.rent_mng_id=f.rent_mng_id(+) AND a.rent_l_cd=f.rent_l_cd(+) "
				+ "        AND (NVL(a.use_yn,'Y')='Y' OR f.cls_dt >= '" + (AddUtil.parseInt(settle_year) + 1) + "0101') " 
				+ " 		 AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd "
				+ " 		 AND b.rent_mng_id=c.rent_mng_id AND b.rent_l_cd=c.rent_l_cd AND b.rent_st=c.rent_st  "
				+ " 		 AND b.grt_amt_s>0  " + " 		 AND a.client_id=d.client_id  "
				+ " 		 and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd "
				+ "        AND a.car_mng_id=g.car_mng_id(+)  "
				+ "        AND a.rent_mng_id=h.rent_mng_id(+) AND a.rent_l_cd=h.rent_l_cd(+) " 
				+ " ";

		if (settle_st.equals("client")) {
			// 거래처별 보증금 현황
			query = " select enp_no, min(firm_nm) firm_nm, sum(grt_amt) grt_amt, sum(pay_amt) pay_amt, sum(dly_amt) dly_amt, sum(r_grt_amt) r_grt_amt from ("
					+ query + ") group by enp_no order by enp_no ";
		} else {
			// 계약별 보증금 현황
			query += " ORDER BY d.ven_code ";
		}

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list4_2016]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료4 - 계약보증금리스트
	 */
	public Vector getSettleAccount_list4_2016(String settle_year, String settle_st, String neom, String gubun) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String sub_query = "";
		
		query = " SELECT "
				+ "        d.ven_code, d.firm_nm, DECODE(d.client_st,'2',TEXT_DECRYPT(d.ssn, 'pw'), d.enp_no) enp_no, NVL(g.car_no,'미등록') car_no, \n"
				+ "        a.rent_dt,  \n"
				+ "        DECODE(b.rent_st,'1','','연장') rent_st,  \n"
				+ "        b.rent_start_dt, b.rent_end_dt,  \n"
				+ "        case when b.rent_end_dt<h.rent_end_dt then h.rent_end_dt ELSE '' end im_end_dt,  \n"
				+ "        f.cls_dt,  \n"
				+ "        b.grt_amt_s grt_amt, e.pay_amt, (b.grt_amt_s-e.pay_amt) dly_amt, b.grt_amt_s-( b.grt_amt_s-e.pay_amt) r_grt_amt,  \n"
				+ "        case when b.rent_end_dt<h.rent_end_dt then h.rent_end_dt ELSE b.rent_end_dt END e_dt,  \n"
				+ "        substr(case when b.rent_end_dt<h.rent_end_dt then h.rent_end_dt ELSE b.rent_end_dt END,1,4) e_year  \n"
				+ " FROM   CONT a, CLS_CONT f, FEE b,   \n"
				+ "        ( SELECT rent_mng_id, rent_l_cd, MAX(to_number(rent_st)) rent_st "
				+ " 	       FROM   FEE "
				+ " 	       GROUP BY rent_mng_id, rent_l_cd " 
				+ " 	     ) c,  \n"
				+ " 		 CLIENT d, "
				+ " 		 ( select rent_mng_id, rent_l_cd, sum(ext_pay_amt) pay_amt, MIN(ext_pay_dt) pay_dt  "
				+ " 		   from   scd_ext  " 
				+ " 		   where  ext_st='0' and ext_pay_amt>0 AND ext_pay_dt < '"	+ (AddUtil.parseInt(settle_year) + 1) + "0101'  " 
				+ " 		   group by rent_mng_id, rent_l_cd  "
				+ " 		 ) e,  \n"
				+ "        CAR_REG g,  \n"
				+ "        (SELECT rent_mng_id, rent_l_cd, MAX(rent_end_dt) rent_end_dt FROM FEE_IM GROUP BY rent_mng_id, rent_l_cd) h  \n"
				+ " WHERE  a.car_st in ('1','3','4') AND a.rent_l_cd NOT LIKE 'RM%'  \n"
				+ "        AND a.rent_mng_id=f.rent_mng_id(+) AND a.rent_l_cd=f.rent_l_cd(+)  \n"
				+ "        AND (NVL(a.use_yn,'Y')='Y' OR f.cls_dt >= '" + (AddUtil.parseInt(settle_year) + 1) + "0101')  \n"
				+ " 		 AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd  \n"
				+ " 		 AND b.rent_mng_id=c.rent_mng_id AND b.rent_l_cd=c.rent_l_cd AND b.rent_st=c.rent_st  \n"
				+ " 		 AND b.grt_amt_s>0  " + " 		 AND a.client_id=d.client_id  \n"
				+ " 		 and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd=e.rent_l_cd  \n"
				+ "        AND a.car_mng_id=g.car_mng_id(+)   \n"
				+ "        AND a.rent_mng_id=h.rent_mng_id(+) AND a.rent_l_cd=h.rent_l_cd(+)  \n"
				+ " ";

		if ( gubun.equals("1")) {
			sub_query =  " where  t.acct_code = a.ven_code(+) ";
		} else  if (  gubun.equals("2")) {
			sub_query =  " where  t.acct_code(+) = a.ven_code ";			
		}
		if (settle_st.equals("client")) {
			// 거래처별 보증금 현황
			query = " select t.acct_code, enp_no, sum(pay_amt) -  to_number(t.acct_amt) cal_amt ,  min(firm_nm) firm_nm, sum(grt_amt) grt_amt, sum(pay_amt) pay_amt, sum(dly_amt) dly_amt, sum(r_grt_amt) r_grt_amt ,  to_number(t.acct_amt) acct_amt  from ( "
					+ query + ") a, acct_temp t  \n"
					 + sub_query 
					 + " group by acct_code, enp_no , acct_amt \n"
					 + " order by 3 desc ";
						
		} else {
			// 계약별 보증금 현황
			query += " ORDER BY d.ven_code ";
		}

	//	System.out.println("query="+ query);
		
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list4_2016]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	
	/**
	 * 프로시져 호출
	 */
	public String call_sp_im_dmail_info_send_bulk(String client_id, String email, String lc_id) {
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "0";

		String query1 = "{CALL P_IM_DMAIL_INFO_SEND_BULK     (?,?,?)}";

		try {

			// 프로시저 호출
			cstmt = conn.prepareCall(query1);
			cstmt.setString(1, client_id);
			cstmt.setString(2, email);
			cstmt.setString(3, lc_id);
			cstmt.execute();
			cstmt.close();

		} catch (Exception e) {
			System.out.println("[AdminDatabase:call_sp_im_dmail_info_send_bulk]\n" + e);
			e.printStackTrace();
			sResult = "1";
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/**
	 * 월마감-대여료연체현황
	 */
	public Vector getSelectStatEndFeeDlyListDB(String save_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.client_id, b.firm_nm as 거래처명, \n"
				+ "        d.car_no 차량번호, a.FEE_DLY_CNT 연체건수, a.fee_dly_amt 연체금액 \n"
				+ " from   stat_rent_month a, client b, fee c, car_reg d \n" + " where  a.save_dt=replace('" + save_dt
				+ "','-','') and nvl(a.fee_dly_amt,0)>0 \n" + "        and a.car_st<>'2' and a.client_id<>'000228' \n"
				+ "        and a.client_id=b.client_id \n"
				+ "        and a.rent_mng_id=c.rent_mng_id and a.rent_l_cd=c.rent_l_cd and a.fee_rent_st=c.rent_st \n"
				+ "        and a.car_mng_id=d.car_mng_id " + " order by b.firm_nm" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndFeeDlyListDB]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 협력업체 공임비현황
	 */
	public Vector getStatOffSellMon(String s_yy) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		int f_year = 2015;
		
		if(s_yy.equals("")){

			query = " select br_id, decode(grouping_id (br_id, st),0,st,1,'소계',3,'합계') st, \n"
					+ "        decode(br_id,'S1','영남','D1','대전','J1','광주','G1','대구','B1','부산') br_nm, \n"
					+ "        nvl(sum(cnt),0) cnt"+(f_year-2000-1)+",\n" 
					+ "        nvl(sum(profit_amt),0) amt"+(f_year-2000-1)+", \n";
					
				for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
					query += " nvl(sum(decode(to_number(substr(save_dt,1,4)),"+(i)+",cnt)),0) cnt"+(i-2000)+", \n";	
					query += " nvl(sum(decode(to_number(substr(save_dt,1,4)),"+(i)+",profit_amt)),0) amt"+(i-2000)+", \n";
				}
			
			query	+="        grouping(st) as grouping_id, \n" 
			        + "        grouping_id (br_id, st) as grouping_id2 \n"
					+ " from   stat_off_sell \n" + " where  st not in ('정비') \n"
					+ " group by grouping sets ((br_id, st), (br_id), ()) \n"
					+ " order by decode(br_id,'S1',0,'D1',1,'J1',2,'G1',3,'B1',4), decode(st,'탁송',5,'측후면',1,'전면',2,'블랙박스',3,'내비게이션',4,6)"
					+ " ";	
			
			
			
		}else {

			query = " select br_id, decode(grouping_id (br_id, st),0,st,1,'소계',3,'합계') st, \n"
				+ "        decode(br_id,'S1','영남','D1','대전','J1','광주','G1','대구','B1','부산') br_nm, \n"
				+ "        nvl(sum(cnt),0) cnt0, \n" + "        nvl(sum(profit_amt),0) amt0, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'01',cnt)),0) cnt1, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'01',profit_amt)),0) amt1, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'02',cnt)),0) cnt2, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'02',profit_amt)),0) amt2, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'03',cnt)),0) cnt3, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'03',profit_amt)),0) amt3, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'04',cnt)),0) cnt4, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'04',profit_amt)),0) amt4, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'05',cnt)),0) cnt5, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'05',profit_amt)),0) amt5, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'06',cnt)),0) cnt6, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'06',profit_amt)),0) amt6, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'07',cnt)),0) cnt7, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'07',profit_amt)),0) amt7, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'08',cnt)),0) cnt8, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'08',profit_amt)),0) amt8, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'09',cnt)),0) cnt9, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'09',profit_amt)),0) amt9, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'10',cnt)),0) cnt10, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'10',profit_amt)),0) amt10, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'11',cnt)),0) cnt11, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'11',profit_amt)),0) amt11, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'12',cnt)),0) cnt12, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'12',profit_amt)),0) amt12, \n"
				+ "        grouping(st) as grouping_id, \n" + "        grouping_id (br_id, st) as grouping_id2 \n"
				+ " from   stat_off_sell \n" + " where  substr(save_dt,1,4)='" + s_yy + "' and st not in ('정비') \n"
				+ " group by grouping sets ((br_id, st), (br_id), ()) \n"
				+ " order by decode(br_id,'S1',0,'D1',1,'J1',2,'G1',3,'B1',4), decode(st,'탁송',5,'측후면',1,'전면',2,'블랙박스',3,'내비게이션',4,6)"
				+ " ";
		
		}

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatOffSellMon]\n" + e);
			System.out.println("[AdminDatabase:getStatOffSellMon]\n" + query);			
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 협력업체 공임비현황
	 */

	public Vector getStatOffSellServMon(String s_yy, String gubun1) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		int f_year = 2017;
		
		if(s_yy.equals("")){
			query = " select br_id, "
					+ "        decode(grouping_id (br_id, decode(off_nm,'MJ모터스','신엠제이모터스+MJ모터스+우리자동차공업사','(주)우리자동차공업사','신엠제이모터스+MJ모터스+우리자동차공업사','(주)신엠제이모터스','신엠제이모터스+MJ모터스+우리자동차공업사',"
					+ "                                          '서광모터스','강서현대+충정로점현대+서광모터스',  '강서현대서비스','강서현대+충정로점현대+서광모터스','충정로점현대자동차','강서현대+충정로점현대+서광모터스',off_nm)),0,"
					+ "                                   decode(off_nm,'MJ모터스','신엠제이모터스+MJ모터스+우리자동차공업사','(주)우리자동차공업사','신엠제이모터스+MJ모터스+우리자동차공업사','(주)신엠제이모터스','신엠제이모터스+MJ모터스+우리자동차공업사',"
					+ "                                          '서광모터스','강서현대+충정로점현대+서광모터스',  '강서현대서비스','강서현대+충정로점현대+서광모터스','충정로점현대자동차','강서현대+충정로점현대+서광모터스',off_nm),1,'소계',3,'합계') st, \n"
					+ "        decode(br_id,'S1','본사','D1','대전','J1','광주','G1','대구','B1','부산' , 'XX', '경정비' , 'TT', '타이어' , 'ZZ', '긴급출동' ) br_nm, \n"
					+ "        nvl(sum(cnt),0) cnt"+(f_year-2000-1)+",\n" 
					+ "        nvl(sum(decode(" + gubun1 + ",1,profit_amt,2,cost_amt,3,sell_amt)),0) amt"+(f_year-2000-1)+", \n";

					for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
						
						query += " nvl(sum(decode(to_number(substr(save_dt,1,4)),"+(i)+",cnt)),0) cnt"+(i-2000)+", \n";	
						query += " nvl(sum(decode(to_number(substr(save_dt,1,4)),"+(i)+",decode(" + gubun1 + ",1,profit_amt,2,cost_amt,3,sell_amt))),0) amt"+(i-2000)+", \n";
						
					}
					
					
			query	+=" grouping(decode(off_nm,     'MJ모터스','신엠제이모터스+MJ모터스+우리자동차공업사','(주)우리자동차공업사','신엠제이모터스+MJ모터스+우리자동차공업사','(주)신엠제이모터스','신엠제이모터스+MJ모터스+우리자동차공업사',"
					+ "                                                '서광모터스','강서현대+충정로점현대+서광모터스',  '강서현대서비스','강서현대+충정로점현대+서광모터스','충정로점현대자동차','강서현대+충정로점현대+서광모터스',off_nm)) as grouping_id, \n"
					+ "        grouping_id (br_id, decode(off_nm,     'MJ모터스','신엠제이모터스+MJ모터스+우리자동차공업사','(주)우리자동차공업사','신엠제이모터스+MJ모터스+우리자동차공업사','(주)신엠제이모터스','신엠제이모터스+MJ모터스+우리자동차공업사',"
					+ "                                              '서광모터스','강서현대+충정로점현대+서광모터스', '강서현대서비스', '강서현대+충정로점현대+서광모터스','충정로점현대자동차','강서현대+충정로점현대+서광모터스',off_nm)) as grouping_id2 \n"
					+ " from   stat_off_sell \n" 
					+ " where  save_dt >= '"+f_year+"0101' and st ='정비' \n"
					+ " group by grouping sets ((br_id, decode(off_nm,'MJ모터스','신엠제이모터스+MJ모터스+우리자동차공업사','(주)우리자동차공업사','신엠제이모터스+MJ모터스+우리자동차공업사','(주)신엠제이모터스','신엠제이모터스+MJ모터스+우리자동차공업사',"
					+ "                                               '서광모터스','강서현대+충정로점현대+서광모터스', '강서현대서비스', '강서현대+충정로점현대+서광모터스','충정로점현대자동차','강서현대+충정로점현대+서광모터스',off_nm)), (br_id), ()) \n"
					+ " order by decode(br_id,'S1',0,'D1',1,'J1',2,'G1',3,'B1',4, 'XX', 5 , 'TT', 6, 'ZZ', 7 ), "
					+ "          decode(decode(off_nm,                'MJ모터스','신엠제이모터스+MJ모터스+우리자동차공업사','(주)우리자동차공업사','신엠제이모터스+MJ모터스+우리자동차공업사','(주)신엠제이모터스','신엠제이모터스+MJ모터스+우리자동차공업사',"
					+ "                                                '서광모터스','강서현대+충정로점현대+서광모터스', '강서현대서비스','강서현대+충정로점현대+서광모터스','충정로점현대자동차','강서현대+충정로점현대+서광모터스',off_nm),"
					+
					"                                               '주식회사 아마존모터스','1','주식회사 오토크린','2','강서모터스', '3', '신엠제이모터스+MJ모터스+우리자동차공업사', '4', '강서현대+충정로점현대','5','정일현대자동차정비공업(주)','6','7'), "
					+ "          replace(decode(off_nm,               'MJ모터스','신엠제이모터스+MJ모터스+우리자동차공업사','(주)우리자동차공업사','신엠제이모터스+MJ모터스+우리자동차공업사','(주)신엠제이모터스','신엠제이모터스+MJ모터스+우리자동차공업사',"
					+ "                                                '서광모터스','강서현대+충정로점현대+서광모터스', '강서현대서비스','강서현대+충정로점현대+서광모터스','충정로점현대자동차','강서현대+충정로점현대+서광모터스',off_nm),'(주)','') "
					+ " ";		
			
			//System.out.println("query=" + query);
			
		}else {
			query = " select br_id, "
				+ "        decode(grouping_id (br_id, decode(off_nm,'MJ모터스','신엠제이모터스+MJ모터스+우리자동차공업사','(주)우리자동차공업사','신엠제이모터스+MJ모터스+우리자동차공업사','(주)신엠제이모터스','신엠제이모터스+MJ모터스+우리자동차공업사',"
				+ "                                          '서광모터스','강서현대+충정로점현대+서광모터스',  '강서현대서비스','강서현대+충정로점현대+서광모터스','충정로점현대자동차','강서현대+충정로점현대+서광모터스',off_nm)),0,"
				+ "                                   decode(off_nm,'MJ모터스','신엠제이모터스+MJ모터스+우리자동차공업사','(주)우리자동차공업사','신엠제이모터스+MJ모터스+우리자동차공업사','(주)신엠제이모터스','신엠제이모터스+MJ모터스+우리자동차공업사',"
				+ "                                          '서광모터스','강서현대+충정로점현대+서광모터스',  '강서현대서비스','강서현대+충정로점현대+서광모터스','충정로점현대자동차','강서현대+충정로점현대+서광모터스',off_nm),1,'소계',3,'합계') st, \n"
				+
				// " decode(br_id,'S1','목동','D1','대전','J1','광주','G1','대구','B1','부산') br_nm, \n"+
				"        decode(br_id,'S1','본사','D1','대전','J1','광주','G1','대구','B1','부산' , 'XX', '경정비' , 'TT', '타이어' , 'ZZ', '긴급출동' ) br_nm, \n"
				+ "        nvl(sum(cnt),0) cnt0, \n" + "        nvl(sum(decode(" + gubun1
				+ ",1,profit_amt,2,cost_amt,3,sell_amt)),0) amt0, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'01',cnt)),0) cnt1, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'01',decode(" + gubun1
				+ ",1,profit_amt,2,cost_amt,3,sell_amt))),0) amt1, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'02',cnt)),0) cnt2, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'02',decode(" + gubun1
				+ ",1,profit_amt,2,cost_amt,3,sell_amt))),0) amt2, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'03',cnt)),0) cnt3, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'03',decode(" + gubun1
				+ ",1,profit_amt,2,cost_amt,3,sell_amt))),0) amt3, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'04',cnt)),0) cnt4, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'04',decode(" + gubun1
				+ ",1,profit_amt,2,cost_amt,3,sell_amt))),0) amt4, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'05',cnt)),0) cnt5, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'05',decode(" + gubun1
				+ ",1,profit_amt,2,cost_amt,3,sell_amt))),0) amt5, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'06',cnt)),0) cnt6, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'06',decode(" + gubun1
				+ ",1,profit_amt,2,cost_amt,3,sell_amt))),0) amt6, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'07',cnt)),0) cnt7, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'07',decode(" + gubun1
				+ ",1,profit_amt,2,cost_amt,3,sell_amt))),0) amt7, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'08',cnt)),0) cnt8, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'08',decode(" + gubun1
				+ ",1,profit_amt,2,cost_amt,3,sell_amt))),0) amt8, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'09',cnt)),0) cnt9, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'09',decode(" + gubun1
				+ ",1,profit_amt,2,cost_amt,3,sell_amt))),0) amt9, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'10',cnt)),0) cnt10, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'10',decode(" + gubun1
				+ ",1,profit_amt,2,cost_amt,3,sell_amt))),0) amt10, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'11',cnt)),0) cnt11, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'11',decode(" + gubun1
				+ ",1,profit_amt,2,cost_amt,3,sell_amt))),0) amt11, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'12',cnt)),0) cnt12, \n"
				+ "        nvl(sum(decode(substr(save_dt,5,2),'12',decode(" + gubun1
				+ ",1,profit_amt,2,cost_amt,3,sell_amt))),0) amt12, \n"
				+ "        grouping(decode(off_nm,     'MJ모터스','신엠제이모터스+MJ모터스+우리자동차공업사','(주)우리자동차공업사','신엠제이모터스+MJ모터스+우리자동차공업사','(주)신엠제이모터스','신엠제이모터스+MJ모터스+우리자동차공업사',"
				+ "                                                '서광모터스','강서현대+충정로점현대+서광모터스',  '강서현대서비스','강서현대+충정로점현대+서광모터스','충정로점현대자동차','강서현대+충정로점현대+서광모터스',off_nm)) as grouping_id, \n"
				+ "        grouping_id (br_id, decode(off_nm,     'MJ모터스','신엠제이모터스+MJ모터스+우리자동차공업사','(주)우리자동차공업사','신엠제이모터스+MJ모터스+우리자동차공업사','(주)신엠제이모터스','신엠제이모터스+MJ모터스+우리자동차공업사',"
				+ "                                              '서광모터스','강서현대+충정로점현대+서광모터스', '강서현대서비스', '강서현대+충정로점현대+서광모터스','충정로점현대자동차','강서현대+충정로점현대+서광모터스',off_nm)) as grouping_id2 \n"
				+ " from   stat_off_sell \n" + " where  substr(save_dt,1,4)='" + s_yy + "' and st ='정비' \n"
				+ " group by grouping sets ((br_id, decode(off_nm,'MJ모터스','신엠제이모터스+MJ모터스+우리자동차공업사','(주)우리자동차공업사','신엠제이모터스+MJ모터스+우리자동차공업사','(주)신엠제이모터스','신엠제이모터스+MJ모터스+우리자동차공업사',"
				+ "                                               '서광모터스','강서현대+충정로점현대+서광모터스', '강서현대서비스', '강서현대+충정로점현대+서광모터스','충정로점현대자동차','강서현대+충정로점현대+서광모터스',off_nm)), (br_id), ()) \n"
				+ " order by decode(br_id,'S1',0,'D1',1,'J1',2,'G1',3,'B1',4, 'XX', 5 , 'TT', 6, 'ZZ', 7 ), "
				+ "          decode(decode(off_nm,                'MJ모터스','신엠제이모터스+MJ모터스+우리자동차공업사','(주)우리자동차공업사','신엠제이모터스+MJ모터스+우리자동차공업사','(주)신엠제이모터스','신엠제이모터스+MJ모터스+우리자동차공업사',"
				+ "                                                '서광모터스','강서현대+충정로점현대+서광모터스', '강서현대서비스','강서현대+충정로점현대+서광모터스','충정로점현대자동차','강서현대+충정로점현대+서광모터스',off_nm),"
				+
				// " '신엠제이모터스+MJ모터스+우리자동차공업사','1','주식회사
				// 오토크린','2','강서현대+충정로점현대','3','정일현대자동차정비공업(주)','4','5'), "+
				"                                               '주식회사 아마존모터스','1','주식회사 오토크린','2','강서모터스', '3', '신엠제이모터스+MJ모터스+우리자동차공업사', '4', '강서현대+충정로점현대','5','정일현대자동차정비공업(주)','6','7'), "
				+ "          replace(decode(off_nm,               'MJ모터스','신엠제이모터스+MJ모터스+우리자동차공업사','(주)우리자동차공업사','신엠제이모터스+MJ모터스+우리자동차공업사','(주)신엠제이모터스','신엠제이모터스+MJ모터스+우리자동차공업사',"
				+ "                                                '서광모터스','강서현대+충정로점현대+서광모터스', '강서현대서비스','강서현대+충정로점현대+서광모터스','충정로점현대자동차','강서현대+충정로점현대+서광모터스',off_nm),'(주)','') "
				+ " ";
			
		}
		
	//	System.out.println("query=" + query);
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatOffSellServMon]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 협력업체 공임비현황
	 */

	public Vector getStatOffSellServStMon(String s_yy) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		
		int f_year = 2017;
		
		if(s_yy.equals("")){
			
			query = " select  decode(grouping_id(br_id, off_nm) , 7, '', decode(br_id,'S1','수도권', 'XX',  '비수도권' )) br_nm ,   \n"+
					" decode(grouping_id (br_id, off_nm), 0, off_nm, 1,'소계',3,'합계') off_nm,    \n"+
					" decode(grouping_id(br_id, off_nm, st) , 1, '소계', decode(st,'2','일반정비', '7', '재리스정비' , '12', '해지정비', '13', '자차') ) st_nm ,  \n"+          

					" nvl(sum(cnt),0) cnt"+(f_year-2000-1)+", \n"+
					" nvl(sum(j_amt),0) j_amt"+(f_year-2000-1)+", \n"+
					" nvl(sum(l_amt),0) l_amt"+(f_year-2000-1)+", \n"+
					" nvl(sum(t_amt),0) t_amt"+(f_year-2000-1)+", \n"+
					" nvl(sum(e_amt),0) e_amt"+(f_year-2000-1)+", \n";
					
				for (int i = f_year ; i <= AddUtil.getDate2(1) ; i++){
					query += " nvl(sum(decode(to_number(substr(save_dt,1,4)),"+(i)+",cnt)),0) cnt"+(i-2000)+", \n";	
					query += " nvl(sum(decode(to_number(substr(save_dt,1,4)),"+(i)+",j_amt)),0) j_amt"+(i-2000)+", \n";
					query += " nvl(sum(decode(to_number(substr(save_dt,1,4)),"+(i)+",l_amt)),0) l_amt"+(i-2000)+", \n";
					query += " nvl(sum(decode(to_number(substr(save_dt,1,4)),"+(i)+",t_amt)),0) t_amt"+(i-2000)+", \n";
					query += " nvl(sum(decode(to_number(substr(save_dt,1,4)),"+(i)+",e_amt)),0) e_amt"+(i-2000)+", \n";
				}
				
			query +=" grouping_id (br_id , off_nm  , st ) as grouping_id2 \n"+
					" from   stat_off_service \n"+
					" where save_dt >= '"+f_year+"0101' \n"+
					" group by grouping sets ((br_id, off_nm, st),  (br_id, off_nm), (br_id), ()) \n"+				         
					" order by decode(br_id,'S1',0, 'XX', 1 , 2), decode(off_nm,  '주식회사 아마존모터스', '01',  '주식회사 오토크린', '02', '강서모터스', '03', '(주)신엠제이모터스', '04',  '(주)현대카독크', '05', '(주)성서현대정비센터', '06', '부경자동차정비', '07', '삼일정비', '08', '상무1급자동차공업사', '09', 'SNP모터스', '10'),  to_number(st) \n"+
	                " "; 
			
			//System.out.println("query=" + query);
			
		}else {
		

			query = " select  decode(grouping_id(br_id, off_nm) , 7, '', decode(br_id,'S1','수도권', 'XX',  '비수도권' )) br_nm ,   \n"+
				" decode(grouping_id (br_id, off_nm), 0, off_nm, 1,'소계',3,'합계') off_nm,    \n"+
				" decode(grouping_id(br_id, off_nm, st) , 1, '소계', decode(st,'2','일반정비', '7', '재리스정비' , '12', '해지정비', '13', '자차') ) st_nm ,  \n"+          
       
				" nvl(sum(cnt),0) cnt0, \n"+
				" nvl(sum(j_amt),0) j_amt0, \n"+
				" nvl(sum(l_amt),0) l_amt0, \n"+
				" nvl(sum(t_amt),0) t_amt0, \n"+
				" nvl(sum(e_amt),0) e_amt0, \n"+
              
				" nvl(sum(decode(substr(save_dt,5,2),'01',cnt)),0) cnt1,    \n"+     
				" nvl(sum(decode(substr(save_dt,5,2),'01',j_amt)),0) j_amt1,   \n"+   
				" nvl(sum(decode(substr(save_dt,5,2),'01',l_amt)),0) l_amt1,   \n"+   
				" nvl(sum(decode(substr(save_dt,5,2),'01',t_amt)),0) t_amt1,   \n"+   
				" nvl(sum(decode(substr(save_dt,5,2),'01',e_amt)),0) e_amt1,   \n"+   
        
				" nvl(sum(decode(substr(save_dt,5,2),'02',cnt)),0) cnt2, \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'02',j_amt)),0) j_amt2,    \n"+ 
				" nvl(sum(decode(substr(save_dt,5,2),'02',l_amt)),0) l_amt2,    \n"+   
				" nvl(sum(decode(substr(save_dt,5,2),'02',t_amt)),0) t_amt2,    \n"+  
				" nvl(sum(decode(substr(save_dt,5,2),'02',e_amt)),0) e_amt2,    \n"+  
              
				" nvl(sum(decode(substr(save_dt,5,2),'03',cnt)),0) cnt3, \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'03',j_amt)),0) j_amt3,  \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'03',l_amt)),0) l_amt3,  \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'03',t_amt)),0) t_amt3,  \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'03',e_amt)),0) e_amt3,  \n"+
        
				" nvl(sum(decode(substr(save_dt,5,2),'04',cnt)),0) cnt4, \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'04',j_amt)),0) j_amt4,  \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'04',l_amt)),0) l_amt4,  \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'04',t_amt)),0) t_amt4,  \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'04',e_amt)),0) e_amt4,  \n"+
               
				" nvl(sum(decode(substr(save_dt,5,2),'05',cnt)),0) cnt5,   \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'05',j_amt)),0) j_amt5,     \n"+    
				" nvl(sum(decode(substr(save_dt,5,2),'05',l_amt)),0) l_amt5,     \n"+    
				" nvl(sum(decode(substr(save_dt,5,2),'05',t_amt)),0) t_amt5,     \n"+    
				" nvl(sum(decode(substr(save_dt,5,2),'05',e_amt)),0) e_amt5,     \n"+    
				
				" nvl(sum(decode(substr(save_dt,5,2),'06',cnt)),0) cnt6, \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'06',j_amt)),0) j_amt6,   \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'06',l_amt)),0) l_amt6,   \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'06',t_amt)),0) t_amt6,   \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'06',e_amt)),0) e_amt6,   \n"+
        
				" nvl(sum(decode(substr(save_dt,5,2),'07',cnt)),0) cnt7, \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'07',j_amt)),0) j_amt7,  \n"+ 
				" nvl(sum(decode(substr(save_dt,5,2),'07',l_amt)),0) l_amt7,  \n"+ 
				" nvl(sum(decode(substr(save_dt,5,2),'07',t_amt)),0) t_amt7,  \n"+ 
				" nvl(sum(decode(substr(save_dt,5,2),'07',e_amt)),0) e_amt7,  \n"+ 
        
				" nvl(sum(decode(substr(save_dt,5,2),'08',cnt)),0) cnt8, \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'08',j_amt)),0) j_amt8, \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'08',l_amt)),0) l_amt8, \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'08',t_amt)),0) t_amt8, \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'08',e_amt)),0) t_amt8, \n"+
        
				" nvl(sum(decode(substr(save_dt,5,2),'09',cnt)),0) cnt9, \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'09',j_amt)),0) j_amt9,    \n"+  
				" nvl(sum(decode(substr(save_dt,5,2),'09',l_amt)),0) l_amt9,    \n"+  
				" nvl(sum(decode(substr(save_dt,5,2),'09',t_amt)),0) t_amt9,    \n"+  
				" nvl(sum(decode(substr(save_dt,5,2),'09',e_amt)),0) e_amt9,    \n"+  
        
				" nvl(sum(decode(substr(save_dt,5,2),'10',cnt)),0) cnt10, \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'10',j_amt)),0) j_amt10,   \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'10',l_amt)),0) l_amt10,   \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'10',t_amt)),0) t_amt10,   \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'10',e_amt)),0) e_amt10,   \n"+
        
				" nvl(sum(decode(substr(save_dt,5,2),'11',cnt)),0) cnt11, \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'11',j_amt)),0) j_amt11,    \n"+      
				" nvl(sum(decode(substr(save_dt,5,2),'11',l_amt)),0) l_amt11,    \n"+      
				" nvl(sum(decode(substr(save_dt,5,2),'11',t_amt)),0) t_amt11,    \n"+      
				" nvl(sum(decode(substr(save_dt,5,2),'11',e_amt)),0) e_amt11,    \n"+      
        
				" nvl(sum(decode(substr(save_dt,5,2),'12',cnt)),0) cnt12, \n"+
				" nvl(sum(decode(substr(save_dt,5,2),'12',j_amt)),0) j_amt12,     \n"+  
				" nvl(sum(decode(substr(save_dt,5,2),'12',l_amt)),0) l_amt12,     \n"+  
				" nvl(sum(decode(substr(save_dt,5,2),'12',t_amt)),0) t_amt12,     \n"+  
				" nvl(sum(decode(substr(save_dt,5,2),'12',e_amt)),0) e_amt12,     \n"+  
  
   // --    grouping_id (br_id , off_nm ) as grouping_br ,
				" grouping_id (br_id , off_nm  , st ) as grouping_id2 \n"+
				" from   stat_off_service \n"+
				" where  substr(save_dt,1,4)='" + s_yy + "'  \n"+
				  
				" group by grouping sets ((br_id, off_nm, st),  (br_id, off_nm), (br_id), ()) \n"+				         
				" order by decode(br_id,'S1',0, 'XX', 1 , 2), decode(off_nm,  '주식회사 아마존모터스', '01',  '주식회사 오토크린', '02', '강서모터스', '03', '(주)신엠제이모터스', '04',  '(주)현대카독크', '05', '(주)성서현대정비센터', '06', '부경자동차정비', '07', '삼일정비', '08', '상무1급자동차공업사', '09', 'SNP모터스', '10'),  to_number(st) \n"+
                " "; 	
		}	
 
	//	  System.out.println("query=" + query);
		
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatOffSellServStMon]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	
	/**
	 * 블랙박스재고현황
	 */
	public Vector getStatOffBlackbox() {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select sup_dt, st, c_su, d_su, \n" + "        sum(c_su-d_su) over (order by sup_dt,st) as j_su  \n"
				+ " from \n" + "        ( \n"
				+ "          select substr(sup_dt,1,8) sup_dt, '입고' st, tint_su as c_su, 0 d_su from car_tint where off_nm='젤존코리아' and tint_yn='Y' and sup_dt is not null \n"
				+ "          union all \n"
				+ "          select substr(sup_dt,1,8) sup_dt, '출고' st, 0 c_su, sum(tint_su) d_su from car_tint where tint_st='3' and tint_yn='Y' and sup_dt>='201611010000' and com_nm like '%이노픽스%' and doc_code is not null group by substr(sup_dt,1,8) \n"
				+ "        ) \n" + " order by sup_dt desc, st desc " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatOffBlackbox]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 전날짜 - working day 기준
	 */
	public String getWortPreDay(String work_dt, int p_day) {
		getConnection();

		String query = "";

		String sResult = "";
		CallableStatement cstmt = null;

		try {
			cstmt = conn.prepareCall("{ ? =  call F_getPreDay( ?, ? ) }");

			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
			cstmt.setString(2, work_dt);
			cstmt.setInt(3, p_day);

			cstmt.execute();
			sResult = cstmt.getString(1); // 결과값
			cstmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getWortPreDay]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	// - day
	public String getPreDay(String v_date, int i) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String rtnStr = "";

		query = " select F_getPreDay(?, ?) from dual ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, v_date);
			pstmt.setInt(2, i);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				rtnStr = rs.getString(1) == null ? "" : rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return rtnStr;
		}
	}

	// +day
	public String getAfterDay(String v_date, int i) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String rtnStr = "";

		query = " select F_getafterDay(?, ?) from dual ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, v_date);
			pstmt.setInt(2, i);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				rtnStr = rs.getString(1) == null ? "" : rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return rtnStr;
		}
	}

	// + working day
		public String getWorkDay(String v_date, int i) {
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String query = "";
			String rtnStr = "";

			query = " select F_getValdDt(replace(?, '-', '') , ?) from dual ";

			try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, v_date);
				pstmt.setInt(2, i);

				rs = pstmt.executeQuery();
				while (rs.next()) {
					rtnStr = rs.getString(1) == null ? "" : rs.getString(1);
				}
				rs.close();
				pstmt.close();

			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				try {
					if (rs != null)
						rs.close();
					if (pstmt != null)
						pstmt.close();
				} catch (Exception ignore) {
				}
				closeConnection();
				return rtnStr;
			}
		}
		
	/**
	 * 결산관련자료8 - 계산서발행리스트 - 개시대여료
	 */
	public Vector getSettleAccount_list8(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT tax_dt, recconame, tax_supply, tax_value, tax_bigo FROM TAX WHERE tax_dt LIKE '" + settle_year
				+ "%' AND gubun='4' AND tax_st<>'C' ORDER BY tax_dt, recconame " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list8]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료9 - 계산서발행리스트 - 대여료 - 미회수채권
	 */
	public Vector getSettleAccount_list9(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.recconame, DECODE(LENGTHB(a.RECCOREGNO),13,SUBSTR(a.reccoregno,1,6),a.reccoregno) reccoregno, count(0) cnt, sum(fee_s_amt) sum_amt, min(fee_est_dt) min_dt, max(fee_est_dt) max_dt "
				+ " from tax a, tax_item_list b, scd_fee c " + " where a.tax_dt like '" + settle_year
				+ "%' and a.tax_st='O' " + " and a.item_id=b.item_id " + " and b.gubun='1' "
				+ " and b.rent_l_cd=c.rent_l_cd and b.rent_st=c.RENT_ST and b.rent_seq=c.rent_seq and b.tm=c.fee_tm "
				+ " and (c.rc_dt is NULL OR c.rc_dt > '" + settle_year + "1231') and c.bill_yn='Y' and c.tm_st2<>'4'  "
				+ " group by a.recconame, a.reccoregno " + " order by min(fee_est_dt) " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list9]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료10 - 계산서발행리스트 - 해지 - 미회수채권
	 */
	public Vector getSettleAccount_list10(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.recconame, DECODE(LENGTHB(a.RECCOREGNO),13,SUBSTR(a.reccoregno,1,6),a.reccoregno) reccoregno, a.rent_l_cd, "
				+ "        a.cnt, a.tax_dt, a.item_g, a.item_car_no, a.item_supply, a.item_value, a.item_amt, "
				+ "        c.ext_amt, c.ext_pay_amt, c.jan_amt, " + "        c.dly_days "
				+ " from (select b.rent_l_cd, a.recconame, a.reccoregno, " + "              count(*) cnt, "
				+ "              min(a.tax_dt) tax_dt, " + "              min(b.item_g) item_g, "
				+ "              min(b.item_car_no) item_car_no, " + "              sum(b.item_supply) item_supply, "
				+ "              sum(b.item_value) item_value, "
				+ "              sum(b.item_supply+b.item_value) item_amt              "
				+ "       from   tax a, tax_item_list b " + "       where  a.tax_dt like '" + settle_year
				+ "%' and a.tax_st='O' " + "              and a.item_id=b.item_id "
				+ "              and b.item_g like '%해지%' " + "       group by b.rent_l_cd, a.recconame, a.reccoregno "
				+ "       ) a, " + "      (select rent_l_cd, "
				+ "              sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt)) ext_amt, "
				+ "              sum(nvl(ext_pay_amt,0)) ext_pay_amt, "
				+ "              sum(decode(ext_tm,'1',ext_s_amt+ext_v_amt))-sum(nvl(ext_pay_amt,0)) jan_amt, "
				+ "              MAX(dly_days) dly_days " + "       from   scd_ext "
				+ "       where  ext_st='4' and bill_yn='Y' " + "              and ext_s_amt>0 "
				+ "       group by rent_l_cd " + "      ) c " + " where a.rent_l_cd=c.rent_l_cd "
				+ " order by nvl(c.jan_amt,0) desc " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list10]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 자동차보유현황 group by ROLLUP
	 */
	public Vector getStatCarG(String save_dt, int start_year, int end_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT car_ext, car_use, car_kd, \n"
				+ "        DECODE(car_ext,'1','서울','2','파주','3','부산','4','김해','5','대전','6','포천','7','인천','8','제주','9','광주','10','대구') car_ext_nm, \n"
				+ "        DECODE(car_use,'1','렌트사업용','2','리스사업용') car_use_nm, \n"
				+ "        DECODE(car_use||car_kd,'11','승용','13','승합','21','승용','22','승합','23','화물',DECODE(GROUPING_ID(car_ext, car_use, car_kd),1,'소계')) car_kd_nm,  \n"
				+ " ";

		for (int i = start_year; i <= end_year; i++) {
			// 이전묶음
			if (i == start_year) {
				query += " SUM(";
				for (int j = 2000; j <= start_year; j++) {
					query += "nvl(y" + j + ",0)";
					if (j < start_year) {
						query += "+";
					}
				}
				query += ") cnt_" + i + ", ";
			} else {
				query += " SUM(nvl(y" + i + ",0)) cnt_" + i + ", ";
			}
		}

		query += " SUM(";
		for (int j = 2000; j <= end_year; j++) {
			query += "nvl(y" + j + ",0)";
			if (j < end_year) {
				query += "+";
			}
		}
		query += ") cnt_t,";

		query += "        GROUPING(car_ext) a, \n" + "        GROUPING(car_use) b, \n"
				+ "        GROUPING(car_kd) c, \n" + "        GROUPING_ID(car_ext, car_use, car_kd) d \n"
				+ " FROM   stat_car  \n" + " WHERE  save_dt='" + save_dt + "' AND car_use||car_kd<>'12' \n"
				+ " GROUP BY ROLLUP (car_ext, car_use, car_kd) \n"
				+ " HAVING GROUPING_ID(car_ext, car_use, car_kd) NOT IN ('3','7') \n" + " UNION  \n"
				+ " SELECT '합계' AS car_ext, car_use, car_kd, \n"
				+ "        DECODE(GROUPING_ID(car_use, car_kd),3,'총계','합계') car_ext_nm, \n"
				+ "        DECODE(car_use,'1','렌트사업용','2','리스사업용') car_use_nm, \n"
				+ "        DECODE(car_use||car_kd,'11','승용','13','승합','21','승용','22','승합','23','화물',DECODE(GROUPING_ID(car_use, car_kd),1,'소계')) car_kd_nm,  \n"
				+ " ";

		for (int i = start_year; i <= end_year; i++) {
			// 이전묶음
			if (i == start_year) {
				query += " SUM(";
				for (int j = 2000; j <= start_year; j++) {
					query += "nvl(y" + j + ",0)";
					if (j < start_year) {
						query += "+";
					}
				}
				query += ") cnt_" + i + ", ";
			} else {
				query += " SUM(nvl(y" + i + ",0)) cnt_" + i + ", ";
			}
		}

		query += " SUM(";
		for (int j = 2000; j <= end_year; j++) {
			query += "nvl(y" + j + ",0)";
			if (j < end_year) {
				query += "+";
			}
		}
		query += ") cnt_t,";

		query += "        0 a,        \n" + "        GROUPING(car_use) b, \n" + "        GROUPING(car_kd) c, \n"
				+ "        GROUPING_ID(car_use, car_kd) d \n" + " FROM   stat_car  \n" + " WHERE  save_dt='" + save_dt
				+ "' AND car_use||car_kd<>'12' \n" + " GROUP BY ROLLUP (car_use, car_kd) \n" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatCarG]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 자동차보유현황 group by ROLLUP
	 */
	public Vector getStatCarNow(String save_dt, int start_year, int end_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT car_ext, car_use, car_kd, \n"
				+ "        DECODE(car_ext,'1','서울','2','파주','3','부산','4','김해','5','대전','6','포천','7','인천','8','제주','9','광주','10','대구') car_ext_nm, \n"
				+ "        DECODE(car_use,'1','렌트사업용','2','리스사업용') car_use_nm, \n"
				+ "        DECODE(car_use||car_kd,'11','승용','13','승합','21','승용','22','승합','23','화물',DECODE(GROUPING_ID(car_ext, car_use, car_kd),1,'소계')) car_kd_nm,  \n"
				+ " ";

		for (int i = start_year; i <= end_year; i++) {
			// 이전묶음
			if (i == start_year) {
				query += " SUM(";
				for (int j = 2000; j <= start_year; j++) {
					query += "nvl(y" + j + ",0)";
					if (j < start_year) {
						query += "+";
					}
				}
				query += ") cnt_" + i + ", ";
			} else {
				query += " SUM(nvl(y" + i + ",0)) cnt_" + i + ", ";
			}
		}

		query += " SUM(";
		for (int j = 2000; j <= end_year; j++) {
			query += "nvl(y" + j + ",0)";
			if (j < end_year) {
				query += "+";
			}
		}
		query += ") cnt_t,";

		query += "        GROUPING(car_ext) a, \n" + "        GROUPING(car_use) b, \n"
				+ "        GROUPING(car_kd) c, \n" + "        GROUPING_ID(car_ext, car_use, car_kd) d \n" + " FROM   ("
				+ "          select\r\n" + "               c.seq,\r\n" + "               nvl(c.cnt0,0) as y2000,\r\n"
				+ "               nvl(c.cnt1,0) as y2001,\r\n" + "               nvl(c.cnt2,0) as y2002,\r\n"
				+ "               nvl(c.cnt3,0) as y2003,\r\n" + "               nvl(c.cnt4,0) as y2004,\r\n"
				+ "               nvl(c.cnt5,0) as y2005,\r\n" + "               nvl(c.cnt6,0) as y2006,\r\n"
				+ "               nvl(c.cnt7,0) as y2007,\r\n" + "               nvl(c.cnt8,0) as y2008,\r\n"
				+ "               nvl(c.cnt9,0) as y2009,\r\n" + "               nvl(c.cnt10,0) as y2010,\r\n"
				+ "               nvl(c.cnt11,0) as y2011,\r\n" + "               nvl(c.cnt12,0) as y2012,\r\n"
				+ "               nvl(c.cnt13,0) as y2013,\r\n" + "               nvl(c.cnt14,0) as y2014,\r\n"
				+ "               nvl(c.cnt15,0) as y2015,\r\n" + "               nvl(c.cnt16,0) as y2016,\r\n"
				+ "               nvl(c.cnt17,0) as y2017,\r\n" + "               nvl(c.cnt18,0) as y2018,\r\n"
				+ "               nvl(c.cnt19,0) as y2019,\r\n" + "               nvl(c.cnt20,0) as y2020,\r\n"
				+ "               nvl(c.cnt21,0) as y2021,\r\n" + "               nvl(c.cnt22,0) as y2022,\r\n"
				+ "               nvl(c.cnt23,0) as y2023,\r\n" + "               nvl(c.cnt24,0) as y2024,\r\n"
				+ "               nvl(c.cnt25,0) as y2025,\r\n" + "               nvl(c.cnt26,0) as y2026,\r\n"
				+ "               nvl(c.cnt27,0) as y2027,\r\n" + "               nvl(c.cnt28,0) as y2028,\r\n"
				+ "               nvl(c.cnt29,0) as y2029,\r\n" + "               nvl(c.cnt30,0) as y2030,\r\n"
				+ "               c.car_ext, c.car_use, c.car_kd\r\n" + "        from\r\n"
				+ "               ( select\r\n"
				+ "                       decode(car_ext||car_use||decode(car_use,'1',car_kd1,'2',car_kd2),\r\n"
				+ "\r\n" + "                             '111','00','112','01','113','02',--서울렌트\r\n"
				+ "                             '121','03','122','04','123','05',--서울리스\r\n" + "\r\n"
				+ "                             '211','06','212','07','213','08',--파주렌트\r\n"
				+ "                             '221','09','222','10','223','11',--파주리스\r\n" + "\r\n"
				+ "                             '311','12','312','13','313','14',--부산렌트\r\n"
				+ "                             '321','15','322','16','323','17',--부산리스\r\n" + "\r\n"
				+ "                             '411','18','412','19','413','20',--김해렌트\r\n"
				+ "                             '421','21','422','22','423','23',--김해리스\r\n" + "\r\n"
				+ "                             '511','24','512','25','513','26',--대전렌트\r\n"
				+ "                             '521','27','522','28','523','29',--대전리스\r\n" + "\r\n"
				+ "                             '611','30','612','31','613','32',--포천렌트\r\n"
				+ "                             '621','33','622','34','623','35',--포천리스\r\n" + "\r\n"
				+ "                             '711','36','712','37','713','38',--인천렌트\r\n"
				+ "                             '721','39','722','40','723','41',--인천리스\r\n" + "\r\n"
				+ "                             '811','42','812','43','813','44',--제주렌트\r\n"
				+ "                             '821','45','822','46','823','47',--제주리스\r\n" + "\r\n"
				+ "                             '911','48','912','49','913','50',--광주렌트\r\n"
				+ "                             '921','51','922','52','923','53',--광주리스\r\n" + "\r\n"
				+ "                             '1011','54','1012','55','1013','56',--대구렌트\r\n"
				+ "                             '1021','57','1022','58','1023','59' --대구리스\r\n" + "\r\n"
				+ "                       ) seq,\r\n"
				+ "                       car_ext, car_use, decode(car_use,'1',car_kd1,'2',car_kd2) car_kd,\r\n"
				+ "                       count(decode(init_year,'2000',car_mng_id)) cnt0,\r\n"
				+ "                       count(decode(init_year,'2001',car_mng_id)) cnt1,\r\n"
				+ "                       count(decode(init_year,'2002',car_mng_id)) cnt2,\r\n"
				+ "                       count(decode(init_year,'2003',car_mng_id)) cnt3,\r\n"
				+ "                       count(decode(init_year,'2004',car_mng_id)) cnt4,\r\n"
				+ "                       count(decode(init_year,'2005',car_mng_id)) cnt5,\r\n"
				+ "                       count(decode(init_year,'2006',car_mng_id)) cnt6,\r\n"
				+ "                       count(decode(init_year,'2007',car_mng_id)) cnt7,\r\n"
				+ "                       count(decode(init_year,'2008',car_mng_id)) cnt8,\r\n"
				+ "                       count(decode(init_year,'2009',car_mng_id)) cnt9,\r\n"
				+ "                       count(decode(init_year,'2010',car_mng_id)) cnt10,\r\n"
				+ "                       count(decode(init_year,'2011',car_mng_id)) cnt11,\r\n"
				+ "                       count(decode(init_year,'2012',car_mng_id)) cnt12,\r\n"
				+ "                       count(decode(init_year,'2013',car_mng_id)) cnt13,\r\n"
				+ "                       count(decode(init_year,'2014',car_mng_id)) cnt14,\r\n"
				+ "                       count(decode(init_year,'2015',car_mng_id)) cnt15,\r\n"
				+ "                       count(decode(init_year,'2016',car_mng_id)) cnt16,\r\n"
				+ "                       count(decode(init_year,'2017',car_mng_id)) cnt17,\r\n"
				+ "                       count(decode(init_year,'2018',car_mng_id)) cnt18,\r\n"
				+ "                       count(decode(init_year,'2019',car_mng_id)) cnt19,\r\n"
				+ "                       count(decode(init_year,'2020',car_mng_id)) cnt20,\r\n"
				+ "                       count(decode(init_year,'2021',car_mng_id)) cnt21,\r\n"
				+ "                       count(decode(init_year,'2022',car_mng_id)) cnt22,\r\n"
				+ "                       count(decode(init_year,'2023',car_mng_id)) cnt23,\r\n"
				+ "                       count(decode(init_year,'2024',car_mng_id)) cnt24,\r\n"
				+ "                       count(decode(init_year,'2025',car_mng_id)) cnt25,\r\n"
				+ "                       count(decode(init_year,'2026',car_mng_id)) cnt26,\r\n"
				+ "                       count(decode(init_year,'2027',car_mng_id)) cnt27,\r\n"
				+ "                       count(decode(init_year,'2028',car_mng_id)) cnt28,\r\n"
				+ "                       count(decode(init_year,'2029',car_mng_id)) cnt29,\r\n"
				+ "                       count(decode(init_year,'2030',car_mng_id)) cnt30\r\n"
				+ "                 from\r\n" + "                       (\r\n" + "\r\n"
				+ "                         select b.car_mng_id, b.car_ext, b.car_use, decode(substr(b.init_reg_dt,1,4),'1998','2000',substr(b.init_reg_dt,1,4)) init_year,\r\n"
				+ "                                decode(b.car_kd, '1','1','2','1','3','1','9','1', '5','3', '4','3') car_kd1,  --소형승합,중형승합은 승합 하나로 합침\r\n"
				+ "                                decode(b.car_kd, '1','1','2','1','3','1','9','1', '4','2','5','2', '6','3','7','3','8','3') car_kd2\r\n"
				+ "                         from   cont a, car_reg b\r\n"
				+ "                         where  nvl(a.use_yn,'Y')='Y' and nvl(b.prepare,'0') NOT IN ('4') and a.car_mng_id=b.car_mng_id\r\n"
				+ "                                AND a.rent_l_cd NOT LIKE 'RM%'\r\n" + "                       )\r\n"
				+ "                 group by car_ext, car_use, decode(car_use,'1',car_kd1,'2',car_kd2)\r\n"
				+ "                ) c" + " union all " + "                 SELECT a.seq,\r\n"
				+ "              0 y2000, 0 y2001, 0 y2002, 0 y2003, 0 y2004, 0 y2005, 0 y2006, 0 y2007, 0 y2008, 0 y2009,\r\n"
				+ "              0 y2010, 0 y2011, 0 y2012, 0 y2013, 0 y2014, 0 y2015, 0 y2016, 0 y2017, 0 y2018, 0 y2019,\r\n"
				+ "              0 y2020, 0 y2021, 0 y2022, 0 y2023, 0 y2024, 0 y2025, 0 y2026, 0 y2027, 0 y2028, 0 y2029,\r\n"
				+ "              0 y2030,\r\n" + "              a.car_ext, a.car_use, a.car_kd\r\n"
				+ "       FROM   stat_car a,\r\n"
				+ "              (SELECT MAX(save_dt) save_dt FROM stat_car where save_dt < to_char(sysdate,'YYYYMMDD')) b,\r\n"
				+ "              (SELECT * FROM stat_car WHERE save_dt = to_char(sysdate,'YYYYMMDD')) c\r\n"
				+ "       WHERE  a.save_dt=b.save_dt\r\n" + "              AND a.seq=c.seq(+) AND c.seq IS NULL"
				+ "        )  \n" + " WHERE  car_use||car_kd<>'12' \n"
				+ " GROUP BY ROLLUP (car_ext, car_use, car_kd) \n"
				+ " HAVING GROUPING_ID(car_ext, car_use, car_kd) NOT IN ('3','7') \n" + " UNION  \n"
				+ " SELECT '합계' AS car_ext, car_use, car_kd, \n"
				+ "        DECODE(GROUPING_ID(car_use, car_kd),3,'총계','합계') car_ext_nm, \n"
				+ "        DECODE(car_use,'1','렌트사업용','2','리스사업용') car_use_nm, \n"
				+ "        DECODE(car_use||car_kd,'11','승용','13','승합','21','승용','22','승합','23','화물',DECODE(GROUPING_ID(car_use, car_kd),1,'소계')) car_kd_nm,  \n"
				+ " ";

		for (int i = start_year; i <= end_year; i++) {
			// 이전묶음
			if (i == start_year) {
				query += " SUM(";
				for (int j = 2000; j <= start_year; j++) {
					query += "nvl(y" + j + ",0)";
					if (j < start_year) {
						query += "+";
					}
				}
				query += ") cnt_" + i + ", ";
			} else {
				query += " SUM(nvl(y" + i + ",0)) cnt_" + i + ", ";
			}
		}

		query += " SUM(";
		for (int j = 2000; j <= end_year; j++) {
			query += "nvl(y" + j + ",0)";
			if (j < end_year) {
				query += "+";
			}
		}
		query += ") cnt_t,";

		query += "        0 a,        \n" + "        GROUPING(car_use) b, \n" + "        GROUPING(car_kd) c, \n"
				+ "        GROUPING_ID(car_use, car_kd) d \n" + " FROM   (" + "           select\r\n"
				+ "               c.seq,\r\n" + "               nvl(c.cnt0,0) as y2000,\r\n"
				+ "               nvl(c.cnt1,0) as y2001,\r\n" + "               nvl(c.cnt2,0) as y2002,\r\n"
				+ "               nvl(c.cnt3,0) as y2003,\r\n" + "               nvl(c.cnt4,0) as y2004,\r\n"
				+ "               nvl(c.cnt5,0) as y2005,\r\n" + "               nvl(c.cnt6,0) as y2006,\r\n"
				+ "               nvl(c.cnt7,0) as y2007,\r\n" + "               nvl(c.cnt8,0) as y2008,\r\n"
				+ "               nvl(c.cnt9,0) as y2009,\r\n" + "               nvl(c.cnt10,0) as y2010,\r\n"
				+ "               nvl(c.cnt11,0) as y2011,\r\n" + "               nvl(c.cnt12,0) as y2012,\r\n"
				+ "               nvl(c.cnt13,0) as y2013,\r\n" + "               nvl(c.cnt14,0) as y2014,\r\n"
				+ "               nvl(c.cnt15,0) as y2015,\r\n" + "               nvl(c.cnt16,0) as y2016,\r\n"
				+ "               nvl(c.cnt17,0) as y2017,\r\n" + "               nvl(c.cnt18,0) as y2018,\r\n"
				+ "               nvl(c.cnt19,0) as y2019,\r\n" + "               nvl(c.cnt20,0) as y2020,\r\n"
				+ "               nvl(c.cnt21,0) as y2021,\r\n" + "               nvl(c.cnt22,0) as y2022,\r\n"
				+ "               nvl(c.cnt23,0) as y2023,\r\n" + "               nvl(c.cnt24,0) as y2024,\r\n"
				+ "               nvl(c.cnt25,0) as y2025,\r\n" + "               nvl(c.cnt26,0) as y2026,\r\n"
				+ "               nvl(c.cnt27,0) as y2027,\r\n" + "               nvl(c.cnt28,0) as y2028,\r\n"
				+ "               nvl(c.cnt29,0) as y2029,\r\n" + "               nvl(c.cnt30,0) as y2030,\r\n"
				+ "               c.car_ext, c.car_use, c.car_kd\r\n" + "        from\r\n"
				+ "               ( select\r\n"
				+ "                       decode(car_ext||car_use||decode(car_use,'1',car_kd1,'2',car_kd2),\r\n"
				+ "\r\n" + "                             '111','00','112','01','113','02',--서울렌트\r\n"
				+ "                             '121','03','122','04','123','05',--서울리스\r\n" + "\r\n"
				+ "                             '211','06','212','07','213','08',--파주렌트\r\n"
				+ "                             '221','09','222','10','223','11',--파주리스\r\n" + "\r\n"
				+ "                             '311','12','312','13','313','14',--부산렌트\r\n"
				+ "                             '321','15','322','16','323','17',--부산리스\r\n" + "\r\n"
				+ "                             '411','18','412','19','413','20',--김해렌트\r\n"
				+ "                             '421','21','422','22','423','23',--김해리스\r\n" + "\r\n"
				+ "                             '511','24','512','25','513','26',--대전렌트\r\n"
				+ "                             '521','27','522','28','523','29',--대전리스\r\n" + "\r\n"
				+ "                             '611','30','612','31','613','32',--포천렌트\r\n"
				+ "                             '621','33','622','34','623','35',--포천리스\r\n" + "\r\n"
				+ "                             '711','36','712','37','713','38',--인천렌트\r\n"
				+ "                             '721','39','722','40','723','41',--인천리스\r\n" + "\r\n"
				+ "                             '811','42','812','43','813','44',--제주렌트\r\n"
				+ "                             '821','45','822','46','823','47',--제주리스\r\n" + "\r\n"
				+ "                             '911','48','912','49','913','50',--광주렌트\r\n"
				+ "                             '921','51','922','52','923','53',--광주리스\r\n" + "\r\n"
				+ "                             '1011','54','1012','55','1013','56',--대구렌트\r\n"
				+ "                             '1021','57','1022','58','1023','59' --대구리스\r\n" + "\r\n"
				+ "                       ) seq,\r\n"
				+ "                       car_ext, car_use, decode(car_use,'1',car_kd1,'2',car_kd2) car_kd,\r\n"
				+ "                       count(decode(init_year,'2000',car_mng_id)) cnt0,\r\n"
				+ "                       count(decode(init_year,'2001',car_mng_id)) cnt1,\r\n"
				+ "                       count(decode(init_year,'2002',car_mng_id)) cnt2,\r\n"
				+ "                       count(decode(init_year,'2003',car_mng_id)) cnt3,\r\n"
				+ "                       count(decode(init_year,'2004',car_mng_id)) cnt4,\r\n"
				+ "                       count(decode(init_year,'2005',car_mng_id)) cnt5,\r\n"
				+ "                       count(decode(init_year,'2006',car_mng_id)) cnt6,\r\n"
				+ "                       count(decode(init_year,'2007',car_mng_id)) cnt7,\r\n"
				+ "                       count(decode(init_year,'2008',car_mng_id)) cnt8,\r\n"
				+ "                       count(decode(init_year,'2009',car_mng_id)) cnt9,\r\n"
				+ "                       count(decode(init_year,'2010',car_mng_id)) cnt10,\r\n"
				+ "                       count(decode(init_year,'2011',car_mng_id)) cnt11,\r\n"
				+ "                       count(decode(init_year,'2012',car_mng_id)) cnt12,\r\n"
				+ "                       count(decode(init_year,'2013',car_mng_id)) cnt13,\r\n"
				+ "                       count(decode(init_year,'2014',car_mng_id)) cnt14,\r\n"
				+ "                       count(decode(init_year,'2015',car_mng_id)) cnt15,\r\n"
				+ "                       count(decode(init_year,'2016',car_mng_id)) cnt16,\r\n"
				+ "                       count(decode(init_year,'2017',car_mng_id)) cnt17,\r\n"
				+ "                       count(decode(init_year,'2018',car_mng_id)) cnt18,\r\n"
				+ "                       count(decode(init_year,'2019',car_mng_id)) cnt19,\r\n"
				+ "                       count(decode(init_year,'2020',car_mng_id)) cnt20,\r\n"
				+ "                       count(decode(init_year,'2021',car_mng_id)) cnt21,\r\n"
				+ "                       count(decode(init_year,'2022',car_mng_id)) cnt22,\r\n"
				+ "                       count(decode(init_year,'2023',car_mng_id)) cnt23,\r\n"
				+ "                       count(decode(init_year,'2024',car_mng_id)) cnt24,\r\n"
				+ "                       count(decode(init_year,'2025',car_mng_id)) cnt25,\r\n"
				+ "                       count(decode(init_year,'2026',car_mng_id)) cnt26,\r\n"
				+ "                       count(decode(init_year,'2027',car_mng_id)) cnt27,\r\n"
				+ "                       count(decode(init_year,'2028',car_mng_id)) cnt28,\r\n"
				+ "                       count(decode(init_year,'2029',car_mng_id)) cnt29,\r\n"
				+ "                       count(decode(init_year,'2030',car_mng_id)) cnt30\r\n"
				+ "                 from\r\n" + "                       (\r\n" + "\r\n"
				+ "                         select b.car_mng_id, b.car_ext, b.car_use, decode(substr(b.init_reg_dt,1,4),'1998','2000',substr(b.init_reg_dt,1,4)) init_year,\r\n"
				+ "                                decode(b.car_kd, '1','1','2','1','3','1','9','1', '5','3', '4','3') car_kd1,  --소형승합,중형승합은 승합 하나로 합침\r\n"
				+ "                                decode(b.car_kd, '1','1','2','1','3','1','9','1', '4','2','5','2', '6','3','7','3','8','3') car_kd2\r\n"
				+ "                         from   cont a, car_reg b\r\n"
				+ "                         where  nvl(a.use_yn,'Y')='Y' and nvl(b.prepare,'0') NOT IN ('4') and a.car_mng_id=b.car_mng_id\r\n"
				+ "                                AND a.rent_l_cd NOT LIKE 'RM%'\r\n" + "                       )\r\n"
				+ "                 group by car_ext, car_use, decode(car_use,'1',car_kd1,'2',car_kd2)\r\n"
				+ "                ) c" + " union all " + "                 SELECT a.seq,\r\n"
				+ "              0 y2000, 0 y2001, 0 y2002, 0 y2003, 0 y2004, 0 y2005, 0 y2006, 0 y2007, 0 y2008, 0 y2009,\r\n"
				+ "              0 y2010, 0 y2011, 0 y2012, 0 y2013, 0 y2014, 0 y2015, 0 y2016, 0 y2017, 0 y2018, 0 y2019,\r\n"
				+ "              0 y2020, 0 y2021, 0 y2022, 0 y2023, 0 y2024, 0 y2025, 0 y2026, 0 y2027, 0 y2028, 0 y2029,\r\n"
				+ "              0 y2030,\r\n" + "              a.car_ext, a.car_use, a.car_kd\r\n"
				+ "       FROM   stat_car a,\r\n"
				+ "              (SELECT MAX(save_dt) save_dt FROM stat_car where save_dt < to_char(sysdate,'YYYYMMDD')) b,\r\n"
				+ "              (SELECT * FROM stat_car WHERE save_dt = to_char(sysdate,'YYYYMMDD')) c\r\n"
				+ "       WHERE  a.save_dt=b.save_dt\r\n" + "              AND a.seq=c.seq(+) AND c.seq IS NULL"
				+ "        )  \n" + " WHERE  car_use||car_kd<>'12' \n" + " GROUP BY ROLLUP (car_use, car_kd) \n" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatCarNow]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	// 초과운행차량현항
	public Vector getStatRentDistList(String s_kd, String t_wd, String gubun1, String gubun2, String gubun3,
			String st_dt, String end_dt, String sort) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String what = "";

		query = " SELECT a.car_mng_id, a.RENT_MNG_ID, a.rent_l_cd, --계약번호 \n" 
		        + "        a.rent_dt, --계약일 \n"
				+ "        b.FIRM_NM, --상호 \n"
				+ "        trunc(MONTHS_BETWEEN(sysdate,TO_DATE(e.rent_start_dt,'YYYYMMDD')+1),1) use_mon, --대여경과개월수 \n"
				+ "        trunc(d.AGREE_DIST/12*trunc(MONTHS_BETWEEN(sysdate,TO_DATE(e.rent_start_dt,'YYYYMMDD')+1),1)) use_agree_dist, --약정운행거리 \n"
				+ "        vt.tot_dist+trunc((vt.tot_dist-DECODE(NVL(d.over_bas_km,0),0,d.sh_km,d.over_bas_km))/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(e.rent_start_dt,'YYYYMMDD'))*(sysdate-to_date(vt.tot_dt,'YYYYMMDD')))-DECODE(NVL(d.over_bas_km,0),0,d.sh_km,d.over_bas_km) as use_TODAY_DIST, --경과운행거리 \n"
				+ "        trunc((vt.tot_dist-DECODE(NVL(d.over_bas_km,0),0,d.sh_km,d.over_bas_km))/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(e.rent_start_dt,'YYYYMMDD'))*365) as USE_YEAR_DIST, --연환산운행거리 \n"
				+ "        vt.tot_dist+trunc((vt.tot_dist-DECODE(NVL(d.over_bas_km,0),0,d.sh_km,d.over_bas_km))/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(e.rent_start_dt,'YYYYMMDD'))*(sysdate-to_date(vt.tot_dt,'YYYYMMDD')))-DECODE(NVL(d.over_bas_km,0),0,d.sh_km,d.over_bas_km) \n"
				+ "           -trunc(d.AGREE_DIST/12*trunc(MONTHS_BETWEEN(sysdate,TO_DATE(e.rent_start_dt,'YYYYMMDD')+1),1)) AS use_cha_dist, --초과운행거리 \n"
				+ "        (vt.tot_dist+trunc((vt.tot_dist-DECODE(NVL(d.over_bas_km,0),0,d.sh_km,d.over_bas_km))/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(e.rent_start_dt,'YYYYMMDD'))*(sysdate-to_date(vt.tot_dt,'YYYYMMDD')))-DECODE(NVL(d.over_bas_km,0),0,d.sh_km,d.over_bas_km) \n"
				+ "           -trunc(d.AGREE_DIST/12*trunc(MONTHS_BETWEEN(sysdate,TO_DATE(e.rent_start_dt,'YYYYMMDD')+1),1))) \n"
				+ "           *d.OVER_RUN_AMT AS use_agree_dist_amt, --초과운행대여료 \n" 
				+ "        e.con_mon, --대여개월수 \n"
				+ "        trunc(d.agree_dist/12*e.con_mon) AS end_agree_dist, --약정운행거리 \n"
				+ "  		 vt.tot_dist+trunc((vt.tot_dist-DECODE(NVL(d.over_bas_km,0),0,d.sh_km,d.over_bas_km))/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(e.rent_start_dt,'YYYYMMDD'))*(to_date(e.rent_end_dt,'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))-DECODE(NVL(d.over_bas_km,0),0,d.sh_km,d.over_bas_km) as end_TODAY_DIST, --운행거리 \n"
				+ "        vt.tot_dist+trunc((vt.tot_dist-DECODE(NVL(d.over_bas_km,0),0,d.sh_km,d.over_bas_km))/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(e.rent_start_dt,'YYYYMMDD'))*(to_date(e.rent_end_dt,'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))-DECODE(NVL(d.over_bas_km,0),0,d.sh_km,d.over_bas_km) \n"
				+ "           -trunc(d.agree_dist/12*e.con_mon) end_cha_dist, --초과운행거리 \n"
				+ "        (vt.tot_dist+trunc((vt.tot_dist-DECODE(NVL(d.over_bas_km,0),0,d.sh_km,d.over_bas_km))/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(e.rent_start_dt,'YYYYMMDD'))*(to_date(e.rent_end_dt,'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))-DECODE(NVL(d.over_bas_km,0),0,d.sh_km,d.over_bas_km) \n"
				+ "           -trunc(d.agree_dist/12*e.con_mon)) \n"
				+ "           *d.OVER_RUN_AMT as end_agree_dist_amt, --초과운행대여료 \n"
				+ "        a.bus_id2, f.user_nm AS bus_nm2, --관리담당자 \n" 
				+ "        c.CAR_NO, --차량번호 \n"
				+ "        c.CAR_NM, --차종 \n" 
				+ "        e.RENT_START_DT, --대여개시일 \n"
				+ "        d.agree_dist, --연간약정운행거리 \n" 
				+ "        d.OVER_RUN_AMT, --1km당 초과운행대여료 \n"
				+ "        vt.tot_dist+trunc((vt.tot_dist-DECODE(NVL(d.over_bas_km,0),0,d.sh_km,d.over_bas_km))/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(e.rent_start_dt,'YYYYMMDD'))*(sysdate-to_date(vt.tot_dt,'YYYYMMDD'))) as TODAY_DIST, --현재예상주행거리 \n"
				+ "        DECODE(a.CAR_gu,'0','재리스','1','신차') car_gu, --차량구분 \n"
				+ "        DECODE(g.rent_way,'1','일반식','기본식') rent_way, --관리구분 \n" 
				+ "        vt.tot_dt, --주행거리 확인일 \n"
				+ "        DECODE(NVL(d.over_bas_km,0),0,d.sh_km,d.over_bas_km) f_dist, --초기주행거리 \n"
				+ "        p.reg_dt as mm_reg_dt, p.speaker as mm_speaker, p.content as mm_content "
				+ " FROM   cont a, client b, car_reg c, \n"
				+ "        (SELECT rent_mng_id, rent_l_cd, SUM(con_mon) con_mon, MIN(rent_start_dt) rent_start_dt, MAX(rent_end_dt) rent_end_dt, MAX(to_number(rent_st)) rent_st \n"
				+ "         FROM   fee \n" 
				+ "         GROUP BY rent_mng_id, rent_l_cd \n" 
				+ "        ) e, \n"
				+ "        fee_etc d, \n" 
				+ "        users f, users f2, \n" 
				+ "        v_tot_dist vt, \n"
				+ "        fee g, \n" 
				+ "        (select a.rent_mng_id, a.rent_l_cd, a.reg_dt, a.speaker, a.content \n"
				+ "	      from   DLY_MM a,  \n"
				+ "               (SELECT /*+ index(DLY_MM, DLY_MM_PK) */ rent_mng_id, rent_l_cd, max(reg_dt||reg_dt_time||seq) KEEP( DENSE_RANK FIRST ORDER BY rent_mng_id, rent_l_cd, reg_dt||reg_dt_time||seq DESC) AS seq \n"
				+ "                FROM   DLY_MM " 
				+ "                where  mm_st='dist' "
				+ "                GROUP BY rent_mng_id, rent_l_cd ) b  \n"
				+ "         where  a.mm_st='dist' and a.rent_mng_id = b.rent_mng_id \n"
				+ "                AND a.rent_l_cd = b.rent_l_cd  \n"
				+ "                AND a.reg_dt||a.reg_dt_time||a.seq = b.seq " 
				+ "        ) p \n"
				+ " WHERE  a.car_st IN ('1','3') AND a.use_yn='Y' AND a.rent_start_dt IS NOT NULL AND a.rent_end_dt IS NOT null \n"
				+ "        AND a.client_id=b.CLIENT_ID \n" 
				+ "        AND a.car_mng_id=c.CAR_MNG_ID \n"
				+ "        AND a.rent_mng_id=e.rent_mng_id AND a.rent_l_cd=e.RENT_L_CD \n"
				+ "        AND e.rent_end_dt IS NOT NULL \n"
				+ "        AND e.rent_mng_id=d.rent_mng_id AND e.rent_l_cd=d.RENT_L_CD AND d.rent_st='1' \n"
				+ "        AND d.agree_dist > 0 \n" 
				+ "        AND a.bus_id2=f.user_id AND a.bus_id=f2.user_id \n"
				+ "        AND a.car_mng_id=vt.car_mng_id \n" 
				+ "        AND vt.tot_dist > 0 \n"
				+ "        AND e.rent_mng_id=g.rent_mng_id AND e.rent_l_cd=g.RENT_L_CD AND e.rent_st=g.rent_st \n"
				+ "        and a.rent_mng_id=p.rent_mng_id(+) and a.rent_l_cd=p.rent_l_cd(+) \n" 
				+ " ";

		if (!gubun1.equals(""))
			query += " and (f.user_nm='" + gubun1 + "' or f2.user_nm='" + gubun1 + "')\n";

		if (!gubun2.equals(""))
			query += " and g.rent_way ='" + gubun2 + "' \n";

		if (s_kd.equals("1"))
			what = "b.firm_nm";
		if (s_kd.equals("2"))
			what = "c.car_no";

		if (!s_kd.equals("") && !t_wd.equals("") && !what.equals("")) {
			query += " and " + what + " like '%" + t_wd + "%' \n";
		}

		query += "        AND trunc(MONTHS_BETWEEN(sysdate,TO_DATE(e.rent_start_dt,'YYYYMMDD')+1),1) > 6 \n"
				+ "        AND trunc(MONTHS_BETWEEN(TO_DATE(vt.tot_dt,'YYYYMMDD'),TO_DATE(a.rent_start_dt,'YYYYMMDD')+1),1) > 6 \n"
				+ "        AND vt.tot_dist+trunc((vt.tot_dist-DECODE(NVL(d.over_bas_km,0),0,d.sh_km,d.over_bas_km))/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(e.rent_start_dt,'YYYYMMDD'))*(sysdate-to_date(vt.tot_dt,'YYYYMMDD')))-DECODE(NVL(d.over_bas_km,0),0,d.sh_km,d.over_bas_km) \n"
				+ " 				           -trunc(d.AGREE_DIST/12*trunc(MONTHS_BETWEEN(sysdate,TO_DATE(e.rent_start_dt,'YYYYMMDD')+1),1)) > 0 \n"
				+ "        AND vt.tot_dist+trunc((vt.tot_dist-DECODE(NVL(d.over_bas_km,0),0,d.sh_km,d.over_bas_km))/(to_date(vt.tot_dt,'YYYYMMDD')-to_date(e.rent_start_dt,'YYYYMMDD'))*(to_date(e.rent_end_dt,'YYYYMMDD')-to_date(vt.tot_dt,'YYYYMMDD')))-DECODE(NVL(d.over_bas_km,0),0,d.sh_km,d.over_bas_km) \n"
				+ "                    -trunc(d.agree_dist/12*e.con_mon) > 0 \n" + " ";

		query += " ORDER BY 10 desc ";

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatRentDistList]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 월마감-분기별 자산현황
	 */
	public Vector getSelectStatEndAssetDB(String save_dt, String gubun) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String base_query = "";
		String base_query2 = "";
		String query = "";

		base_query = " SELECT b.car_no, b.init_reg_dt, "
				+ " 	      a.car_b_amt, a.car_c_amt, a.car_amt, a.dep_amt, a.book_amt, a.book_per, a.sh_amt, a.sh_per, "
				+ "        a.alt_prn, a.alt_int, a.alt_amt, a.grt_amt_s, a.debt_amt, a.sh_amt AS sh_amt2, a.sh_debt_per, a.gain_sd_amt, "
				+ "        a.fee_est_amt, a.fee_debt_per, a.gain_fd_amt, a.alt_fee, a.alt_pf_sum, "
				+ "        TRUNC(NVL(a.gain_fd_amt/DECODE(a.alt_amt,0,NULL,a.alt_amt),0)*100,2) gain_fd_per  "
				+ " FROM   stat_rent_month a, car_reg b " + " WHERE  a.save_dt=replace('" + save_dt + "','-','') "
				+ "        AND a.car_mng_id=b.car_mng_id " + "        AND a.prepare not in ('4','5') " + " ";

		if (gubun.equals("list")) {
			query = base_query + " order by b.init_reg_dt ";
		} else {
			base_query2 = " SELECT SUBSTR(init_reg_dt,1,4) yyyy, COUNT(0) cnt, "
					+ "        SUM(car_b_amt) car_b_amt, SUM(car_c_amt) car_c_amt, SUM(car_amt) car_amt,  "
					+ "        SUM(dep_amt) dep_amt, SUM(book_amt) book_amt, TRUNC(SUM(book_amt)/SUM(car_amt)*100,2) book_per,  "
					+ "        SUM(sh_amt) sh_amt, TRUNC(SUM(sh_amt)/SUM(car_amt)*100,2) sh_per, "
					+ "        SUM(alt_prn) alt_prn, SUM(alt_fee) alt_fee, SUM(alt_pf_sum) alt_pf_sum, SUM(grt_amt_s) grt_amt_s, SUM(debt_amt) debt_amt, "
					+ "        SUM(sh_amt) sh_amt2, TRUNC(NVL(SUM(sh_amt)/DECODE(SUM(debt_amt),0,NULL,SUM(debt_amt)),0)*100,2) sh_debt_per, SUM(gain_sd_amt) gain_sd_amt, "
					+ "        SUM(alt_prn) alt_prn2, SUM(alt_int) alt_int2, SUM(alt_amt) alt_amt2, SUM(grt_amt_s) grt_amt_s2, SUM(debt_amt) debt_amt2, "
					+ "        SUM(fee_est_amt) fee_est_amt, TRUNC(NVL(SUM(fee_est_amt)/DECODE(SUM(alt_amt),0,NULL,SUM(alt_amt)),0)*100,2) fee_debt_per, "
					+ "        SUM(gain_fd_amt) gain_fd_amt, TRUNC(NVL(SUM(gain_fd_amt)/DECODE(SUM(alt_amt),0,NULL,SUM(alt_amt)),0)*100,2) gain_fd_per "
					+ " FROM  " + " ( " + base_query + " ) " + " GROUP BY SUBSTR(init_reg_dt,1,4) ";

			query = " SELECT a.yyyy, a.cnt, " + "        a.car_b_amt, a.car_c_amt, a.car_amt, "
					+ "        a.dep_amt, a.book_amt, a.book_per, " + "        a.sh_amt, a.sh_per, " +

					"        DECODE(NVL(b.alt_prn,0),0,NVL(c.alt_prn,0),nvl(b.alt_prn,0)) alt_prn, "
					+ "        DECODE(NVL(b.alt_fee,0),0,NVL(c.alt_fee,0),nvl(b.alt_fee,0)) alt_fee, "
					+ "        DECODE(NVL(b.alt_pf_sum,0),0,NVL(c.alt_pf_sum,0),nvl(b.alt_pf_sum,0)) alt_pf_sum, "
					+ "        a.grt_amt_s, "
					+ "        (DECODE(NVL(b.alt_pf_sum,0),0,NVL(c.alt_pf_sum,0),nvl(b.alt_pf_sum,0))+a.grt_amt_s) debt_amt, "
					+ "        a.sh_amt2, "
					+ "        TRUNC(NVL(a.sh_amt2/DECODE((DECODE(NVL(b.alt_pf_sum,0),0,NVL(c.alt_pf_sum,0),nvl(b.alt_pf_sum,0))+a.grt_amt_s),0,NULL,(DECODE(NVL(b.alt_pf_sum,0),0,NVL(c.alt_pf_sum,0),nvl(b.alt_pf_sum,0))+a.grt_amt_s)),0)*100,2) sh_debt_per, "
					+ "        (a.sh_amt2-(DECODE(NVL(b.alt_pf_sum,0),0,NVL(c.alt_pf_sum,0),nvl(b.alt_pf_sum,0))+a.grt_amt_s)) gain_sd_amt, "
					+ "        DECODE(NVL(b.alt_prn2,0),0,NVL(c.alt_prn,0),nvl(b.alt_prn2,0)) alt_prn2, "
					+ "        DECODE(NVL(b.alt_int2,0),0,NVL(c.alt_int,0),nvl(b.alt_int2,0)) alt_int2, "
					+ "        DECODE(NVL(b.alt_amt2,0),0,NVL(c.alt_amt,0),nvl(b.alt_amt2,0)) alt_amt2, "
					+ "        a.fee_est_amt, "
					+ "        TRUNC(NVL(a.fee_est_amt/DECODE(DECODE(NVL(b.alt_amt2,0),0,NVL(c.alt_amt,0),nvl(b.alt_amt2,0)),0,NULL,DECODE(NVL(b.alt_amt2,0),0,NVL(c.alt_amt,0),nvl(b.alt_amt2,0))),0)*100,2) fee_debt_per, "
					+ "        (a.fee_est_amt-DECODE(NVL(b.alt_amt2,0),0,NVL(c.alt_amt,0),nvl(b.alt_amt2,0))) gain_fd_amt, "
					+ "        TRUNC(NVL((a.fee_est_amt-DECODE(NVL(b.alt_amt2,0),0,NVL(c.alt_amt,0),nvl(b.alt_amt2,0)))/DECODE(DECODE(NVL(b.alt_amt2,0),0,NVL(c.alt_amt,0),nvl(b.alt_amt2,0)),0,NULL,DECODE(NVL(b.alt_amt2,0),0,NVL(c.alt_amt,0),nvl(b.alt_amt2,0))),0)*100,2) gain_fd_per "
					+ " FROM  " + " ( " + base_query2 + " ) a, "
					+ " 	    ( select * from stat_debt_asset where save_dt=replace('" + save_dt + "','-','') ) b, " +

					" ( SELECT SUBSTR(lend_dt,1,4) yyyy, "
					+ "          SUM(alt_prn) AS alt_prn, TRUNC(SUM(alt_prn)*0.01) AS alt_fee, TRUNC(SUM(alt_prn)*1.01) AS alt_pf_sum, SUM(alt_int) AS alt_int, SUM(alt_prn+alt_int) AS alt_amt "
					+ "   FROM   debt_pay_view " + "   WHERE  (pay_yn='0' OR alt_est_dt1 > replace('" + save_dt
					+ "','-','')) AND lend_dt<=replace('" + save_dt + "','-','') " + "   GROUP BY SUBSTR(lend_dt,1,4) "
					+ " ) c " +

					" where a.yyyy=b.year(+) and a.yyyy=c.yyyy(+) " + " ORDER BY a.yyyy desc ";

		}

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}

			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndAssetDB]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 월마감-분기별 자산현황 - 부채현황
	 */
	public Vector getSelectStatEndAssetDB_debt(String save_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT SUBSTR(lend_dt,1,4) yyyy, "
				+ "        SUM(alt_prn) AS alt_prn, TRUNC(SUM(alt_prn)*0.01) AS alt_fee, TRUNC(SUM(alt_prn)*1.01) AS alt_pf_sum, SUM(alt_int) AS alt_int, SUM(alt_prn+alt_int) AS alt_amt "
				+ " FROM   debt_pay_view " + " WHERE  (pay_yn='0' OR alt_est_dt1 > replace('" + save_dt
				+ "','-','')) AND lend_dt<=replace('" + save_dt + "','-','') " + " GROUP BY SUBSTR(lend_dt,1,4) "
				+ " ORDER BY SUBSTR(lend_dt,1,4) desc " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}

			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndAssetDB_debt]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 월마감-분기별 자산현황 - 부채현황
	 */
	public Vector getSelectStatEndAssetDB_debt(String save_dt, String year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT alt_prn, alt_fee, alt_pf_sum, alt_prn2, alt_int2, alt_amt2 " + " FROM   stat_debt_asset "
				+ " WHERE  save_dt=replace('" + save_dt + "','-','') and year='" + year + "' " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}

			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndAssetDB_debt(String save_dt, String year)]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 연료별보유현황
	 */
	public Vector getStatCarFuel(String save_dt, int start_year, int end_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT seq, \n"
				+ "        DECODE(seq,'1','가솔린','2','디젤','3','일반승용LPG','4','기타차종LPG','5','하이브리드','6','플러그인HEV','7','전기','8','수소') fuel_nm, \n"
				+ " ";

		for (int i = start_year; i <= end_year; i++) {
			// 이전묶음
			if (i == start_year) {
				query += " ";
				for (int j = 2000; j <= start_year; j++) {
					query += "nvl(y" + j + ",0)";
					if (j < start_year) {
						query += "+";
					}
				}
				query += " as cnt_" + i + ", ";
			} else {
				query += " nvl(y" + i + ",0) cnt_" + i + ", ";
			}
		}

		query += " ";
		for (int j = 2000; j <= end_year; j++) {
			query += "nvl(y" + j + ",0)";
			if (j < end_year) {
				query += "+";
			}
		}
		query += " as cnt_t";

		query += " FROM   stat_car_fuel  \n" + " WHERE  save_dt='" + save_dt + "' \n" + " UNION  \n"
				+ " SELECT '99' seq, '합계' AS fuel_nm, \n" + " ";

		for (int i = start_year; i <= end_year; i++) {
			// 이전묶음
			if (i == start_year) {
				query += " SUM(";
				for (int j = 2000; j <= start_year; j++) {
					query += "nvl(y" + j + ",0)";
					if (j < start_year) {
						query += "+";
					}
				}
				query += ") cnt_" + i + ", ";
			} else {
				query += " SUM(nvl(y" + i + ",0)) cnt_" + i + ", ";
			}
		}

		query += " SUM(";
		for (int j = 2000; j <= end_year; j++) {
			query += "nvl(y" + j + ",0)";
			if (j < end_year) {
				query += "+";
			}
		}
		query += ") cnt_t ";

		query += " FROM   stat_car_fuel  \n" + " WHERE  save_dt='" + save_dt + "' \n" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatCarFuel]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 연료별보유현황
	 */
	public Vector getStatCarFuelNow(String save_dt, int start_year, int end_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT seq, \n"
				+ "        DECODE(seq,'1','가솔린','2','디젤','3','일반승용LPG','4','기타차종LPG','5','하이브리드','6','플러그인HEV','7','전기','8','수소') fuel_nm, \n"
				+ " ";

		for (int i = start_year; i <= end_year; i++) {
			// 이전묶음
			if (i == start_year) {
				query += " ";
				for (int j = 2000; j <= start_year; j++) {
					query += "nvl(y" + j + ",0)";
					if (j < start_year) {
						query += "+";
					}
				}
				query += " as cnt_" + i + ", ";
			} else {
				query += " nvl(y" + i + ",0) cnt_" + i + ", ";
			}
		}

		query += " ";
		for (int j = 2000; j <= end_year; j++) {
			query += "nvl(y" + j + ",0)";
			if (j < end_year) {
				query += "+";
			}
		}
		query += " as cnt_t";

		query += " FROM   (SELECT fuel_st as seq, 0 y2000, 0 y2001, \r\n"
				+ "              count(decode(init_year,'2002',car_mng_id)) y2002,\r\n"
				+ "              count(decode(init_year,'2003',car_mng_id)) y2003,\r\n"
				+ "              count(decode(init_year,'2004',car_mng_id)) y2004,\r\n"
				+ "              count(decode(init_year,'2005',car_mng_id)) y2005,\r\n"
				+ "              count(decode(init_year,'2006',car_mng_id)) y2006,\r\n"
				+ "              count(decode(init_year,'2007',car_mng_id)) y2007,\r\n"
				+ "              count(decode(init_year,'2008',car_mng_id)) y2008,\r\n"
				+ "              count(decode(init_year,'2009',car_mng_id)) y2009,\r\n"
				+ "              count(decode(init_year,'2010',car_mng_id)) y2010,\r\n"
				+ "              count(decode(init_year,'2011',car_mng_id)) y2011,\r\n"
				+ "              count(decode(init_year,'2012',car_mng_id)) y2012,\r\n"
				+ "              count(decode(init_year,'2013',car_mng_id)) y2013,\r\n"
				+ "              count(decode(init_year,'2014',car_mng_id)) y2014,\r\n"
				+ "              count(decode(init_year,'2015',car_mng_id)) y2015,\r\n"
				+ "              count(decode(init_year,'2016',car_mng_id)) y2016,\r\n"
				+ "              count(decode(init_year,'2017',car_mng_id)) y2017,\r\n"
				+ "              count(decode(init_year,'2018',car_mng_id)) y2018,\r\n"
				+ "              count(decode(init_year,'2019',car_mng_id)) y2019,\r\n"
				+ "              count(decode(init_year,'2020',car_mng_id)) y2020,\r\n"
				+ "              count(decode(init_year,'2021',car_mng_id)) y2021,\r\n"
				+ "              count(decode(init_year,'2022',car_mng_id)) y2022,\r\n"
				+ "              count(decode(init_year,'2023',car_mng_id)) y2023,\r\n"
				+ "              count(decode(init_year,'2024',car_mng_id)) y2024,\r\n"
				+ "              count(decode(init_year,'2025',car_mng_id)) y2025,\r\n"
				+ "              count(decode(init_year,'2026',car_mng_id)) y2026,\r\n"
				+ "              count(decode(init_year,'2027',car_mng_id)) y2027,\r\n"
				+ "              count(decode(init_year,'2028',car_mng_id)) y2028,\r\n"
				+ "              count(decode(init_year,'2029',car_mng_id)) y2029,\r\n"
				+ "              count(decode(init_year,'2030',car_mng_id)) y2030            \r\n"
				+ "       FROM        \r\n" + "       (\r\n"
				+ "       SELECT a.car_mng_id, SUBSTR(d.init_reg_dt,1,4) init_year,			 \r\n"
				+ "			        case when c.diesel_yn = '2' and c.s_st in ('300','301','302') then '3'\r\n"
				+ "				           when c.diesel_yn = '2' and c.s_st not in ('300','301','302') then '4'\r\n"
				+ "						       when c.diesel_yn = 'Y' then '2'\r\n"
				+ "       				 		 when c.diesel_yn = '3' then '5'\r\n"
				+ "			       	 		 when c.diesel_yn = '4' then '6'\r\n"
				+ "				  	       when c.diesel_yn = '5' then '7'\r\n"
				+ "				  	       when c.diesel_yn = '6' then '8'\r\n"
				+ "						       else '1' \r\n" + "			        end  fuel_st\r\n"
				+ "       FROM   cont a, car_etc b, car_nm c, car_reg d\r\n"
				+ "       WHERE  NVL(a.use_yn,'Y')='Y' \r\n"
				+ "              AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \r\n"
				+ "              AND b.car_id=c.car_id AND b.car_seq=c.car_seq\r\n"
				+ "              AND a.car_mng_id=d.car_mng_id\r\n"
				+ "              AND nvl(d.prepare,'0') NOT IN ('4')\r\n" + "       )   \r\n"
				+ "       GROUP BY fuel_st     \r\n" + "       ORDER BY fuel_st)  \n" + " UNION  \n"
				+ " SELECT '99' seq, '합계' AS fuel_nm, \n" + " ";

		for (int i = start_year; i <= end_year; i++) {
			// 이전묶음
			if (i == start_year) {
				query += " SUM(";
				for (int j = 2000; j <= start_year; j++) {
					query += "nvl(y" + j + ",0)";
					if (j < start_year) {
						query += "+";
					}
				}
				query += ") cnt_" + i + ", ";
			} else {
				query += " SUM(nvl(y" + i + ",0)) cnt_" + i + ", ";
			}
		}

		query += " SUM(";
		for (int j = 2000; j <= end_year; j++) {
			query += "nvl(y" + j + ",0)";
			if (j < end_year) {
				query += "+";
			}
		}
		query += ") cnt_t ";

		query += " FROM   (SELECT fuel_st as seq, 0 y2000, 0 y2001, \r\n"
				+ "              count(decode(init_year,'2002',car_mng_id)) y2002,\r\n"
				+ "              count(decode(init_year,'2003',car_mng_id)) y2003,\r\n"
				+ "              count(decode(init_year,'2004',car_mng_id)) y2004,\r\n"
				+ "              count(decode(init_year,'2005',car_mng_id)) y2005,\r\n"
				+ "              count(decode(init_year,'2006',car_mng_id)) y2006,\r\n"
				+ "              count(decode(init_year,'2007',car_mng_id)) y2007,\r\n"
				+ "              count(decode(init_year,'2008',car_mng_id)) y2008,\r\n"
				+ "              count(decode(init_year,'2009',car_mng_id)) y2009,\r\n"
				+ "              count(decode(init_year,'2010',car_mng_id)) y2010,\r\n"
				+ "              count(decode(init_year,'2011',car_mng_id)) y2011,\r\n"
				+ "              count(decode(init_year,'2012',car_mng_id)) y2012,\r\n"
				+ "              count(decode(init_year,'2013',car_mng_id)) y2013,\r\n"
				+ "              count(decode(init_year,'2014',car_mng_id)) y2014,\r\n"
				+ "              count(decode(init_year,'2015',car_mng_id)) y2015,\r\n"
				+ "              count(decode(init_year,'2016',car_mng_id)) y2016,\r\n"
				+ "              count(decode(init_year,'2017',car_mng_id)) y2017,\r\n"
				+ "              count(decode(init_year,'2018',car_mng_id)) y2018,\r\n"
				+ "              count(decode(init_year,'2019',car_mng_id)) y2019,\r\n"
				+ "              count(decode(init_year,'2020',car_mng_id)) y2020,\r\n"
				+ "              count(decode(init_year,'2021',car_mng_id)) y2021,\r\n"
				+ "              count(decode(init_year,'2022',car_mng_id)) y2022,\r\n"
				+ "              count(decode(init_year,'2023',car_mng_id)) y2023,\r\n"
				+ "              count(decode(init_year,'2024',car_mng_id)) y2024,\r\n"
				+ "              count(decode(init_year,'2025',car_mng_id)) y2025,\r\n"
				+ "              count(decode(init_year,'2026',car_mng_id)) y2026,\r\n"
				+ "              count(decode(init_year,'2027',car_mng_id)) y2027,\r\n"
				+ "              count(decode(init_year,'2028',car_mng_id)) y2028,\r\n"
				+ "              count(decode(init_year,'2029',car_mng_id)) y2029,\r\n"
				+ "              count(decode(init_year,'2030',car_mng_id)) y2030            \r\n"
				+ "       FROM        \r\n" + "       (\r\n"
				+ "       SELECT a.car_mng_id, SUBSTR(d.init_reg_dt,1,4) init_year,			 \r\n"
				+ "			        case when c.diesel_yn = '2' and c.s_st in ('300','301','302') then '3'\r\n"
				+ "				           when c.diesel_yn = '2' and c.s_st not in ('300','301','302') then '4'\r\n"
				+ "						       when c.diesel_yn = 'Y' then '2'\r\n"
				+ "       				 		 when c.diesel_yn = '3' then '5'\r\n"
				+ "			       	 		 when c.diesel_yn = '4' then '6'\r\n"
				+ "				  	       when c.diesel_yn = '5' then '7'\r\n"
				+ "				  	       when c.diesel_yn = '6' then '8'\r\n"
				+ "						       else '1' \r\n" + "			        end  fuel_st\r\n"
				+ "       FROM   cont a, car_etc b, car_nm c, car_reg d\r\n"
				+ "       WHERE  NVL(a.use_yn,'Y')='Y' \r\n"
				+ "              AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \r\n"
				+ "              AND b.car_id=c.car_id AND b.car_seq=c.car_seq\r\n"
				+ "              AND a.car_mng_id=d.car_mng_id\r\n"
				+ "              AND nvl(d.prepare,'0') NOT IN ('4')\r\n" + "       )   \r\n"
				+ "       GROUP BY fuel_st     \r\n" + "       ORDER BY fuel_st)  \n" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatCarFuelNow]\n" + e);
			System.out.println("[AdminDatabase:getStatCarFuelNow]\n" + query);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 연료별보유현황
	 */
	public Vector getStatCarFuelPer(String save_dt, int start_year, int end_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.seq, \n"
				+ "        DECODE(a.seq,'1','가솔린','2','디젤','3','일반승용LPG','4','기타차종LPG','5','하이브리드','6','플러그인HEV','7','전기','8','수소') fuel_nm, \n"
				+ " ";

		for (int i = start_year; i <= end_year; i++) {
			// 이전묶음
			if (i == start_year) {
				query += " round((";
				for (int j = 2000; j <= start_year; j++) {
					query += "nvl(a.y" + j + ",0)";
					if (j < start_year) {
						query += "+";
					}
				}
				query += " )/decode(b.cnt_" + i + ",0,null,b.cnt_" + i + ")*100,1) as cnt_" + i + ", ";
			} else {
				query += " round(nvl(a.y" + i + ",0)/decode(b.cnt_" + i + ",0,null,b.cnt_" + i + ")*100,1) as cnt_" + i
						+ ", ";
			}
		}

		query += " round((";
		for (int j = 2000; j <= end_year; j++) {
			query += "nvl(a.y" + j + ",0)";
			if (j < end_year) {
				query += "+";
			}
		}
		query += " )/decode(b.cnt_t,0,null,b.cnt_t)*100,1) as cnt_t";

		query += " FROM   stat_car_fuel a, \n" + " ( SELECT '99' seq, '합계' AS fuel_nm, \n" + " ";

		for (int i = start_year; i <= end_year; i++) {
			// 이전묶음
			if (i == start_year) {
				query += " SUM(";
				for (int j = 2000; j <= start_year; j++) {
					query += "nvl(y" + j + ",0)";
					if (j < start_year) {
						query += "+";
					}
				}
				query += ") cnt_" + i + ", ";
			} else {
				query += " SUM(nvl(y" + i + ",0)) cnt_" + i + ", ";
			}
		}

		query += " SUM(";
		for (int j = 2000; j <= end_year; j++) {
			query += "nvl(y" + j + ",0)";
			if (j < end_year) {
				query += "+";
			}
		}
		query += ") cnt_t ";

		query += " FROM   stat_car_fuel  \n" + " WHERE  save_dt='" + save_dt + "' ) b \n" +

				" WHERE  a.save_dt='" + save_dt + "' \n" +

				" ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatCarFuelPer]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 연료별보유현황
	 */
	public Vector getStatCarFuelPerNow(String save_dt, int start_year, int end_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.seq, \n"
				+ "        DECODE(a.seq,'1','가솔린','2','디젤','3','일반승용LPG','4','기타차종LPG','5','하이브리드','6','플러그인HEV','7','전기','8','수소') fuel_nm, \n"
				+ " ";

		for (int i = start_year; i <= end_year; i++) {
			// 이전묶음
			if (i == start_year) {
				query += " round((";
				for (int j = 2000; j <= start_year; j++) {
					query += "nvl(a.y" + j + ",0)";
					if (j < start_year) {
						query += "+";
					}
				}
				query += " )/decode(b.cnt_" + i + ",0,null,b.cnt_" + i + ")*100,1) as cnt_" + i + ", ";
			} else {
				query += " round(nvl(a.y" + i + ",0)/decode(b.cnt_" + i + ",0,null,b.cnt_" + i + ")*100,1) as cnt_" + i
						+ ", ";
			}
		}

		query += " round((";
		for (int j = 2000; j <= end_year; j++) {
			query += "nvl(a.y" + j + ",0)";
			if (j < end_year) {
				query += "+";
			}
		}
		query += " )/decode(b.cnt_t,0,null,b.cnt_t)*100,1) as cnt_t";

		query += " FROM   (SELECT fuel_st as seq, 0 y2000, 0 y2001,\r\n"
				+ "              count(decode(init_year,'2002',car_mng_id)) y2002,\r\n"
				+ "              count(decode(init_year,'2003',car_mng_id)) y2003,\r\n"
				+ "              count(decode(init_year,'2004',car_mng_id)) y2004,\r\n"
				+ "              count(decode(init_year,'2005',car_mng_id)) y2005,\r\n"
				+ "              count(decode(init_year,'2006',car_mng_id)) y2006,\r\n"
				+ "              count(decode(init_year,'2007',car_mng_id)) y2007,\r\n"
				+ "              count(decode(init_year,'2008',car_mng_id)) y2008,\r\n"
				+ "              count(decode(init_year,'2009',car_mng_id)) y2009,\r\n"
				+ "              count(decode(init_year,'2010',car_mng_id)) y2010,\r\n"
				+ "              count(decode(init_year,'2011',car_mng_id)) y2011,\r\n"
				+ "              count(decode(init_year,'2012',car_mng_id)) y2012,\r\n"
				+ "              count(decode(init_year,'2013',car_mng_id)) y2013,\r\n"
				+ "              count(decode(init_year,'2014',car_mng_id)) y2014,\r\n"
				+ "              count(decode(init_year,'2015',car_mng_id)) y2015,\r\n"
				+ "              count(decode(init_year,'2016',car_mng_id)) y2016,\r\n"
				+ "              count(decode(init_year,'2017',car_mng_id)) y2017,\r\n"
				+ "              count(decode(init_year,'2018',car_mng_id)) y2018,\r\n"
				+ "              count(decode(init_year,'2019',car_mng_id)) y2019,\r\n"
				+ "              count(decode(init_year,'2020',car_mng_id)) y2020,\r\n"
				+ "              count(decode(init_year,'2021',car_mng_id)) y2021,\r\n"
				+ "              count(decode(init_year,'2022',car_mng_id)) y2022,\r\n"
				+ "              count(decode(init_year,'2023',car_mng_id)) y2023,\r\n"
				+ "              count(decode(init_year,'2024',car_mng_id)) y2024,\r\n"
				+ "              count(decode(init_year,'2025',car_mng_id)) y2025,\r\n"
				+ "              count(decode(init_year,'2026',car_mng_id)) y2026,\r\n"
				+ "              count(decode(init_year,'2027',car_mng_id)) y2027,\r\n"
				+ "              count(decode(init_year,'2028',car_mng_id)) y2028,\r\n"
				+ "              count(decode(init_year,'2029',car_mng_id)) y2029,\r\n"
				+ "              count(decode(init_year,'2030',car_mng_id)) y2030            \r\n"
				+ "       FROM        \r\n" + "       (\r\n"
				+ "       SELECT a.car_mng_id, SUBSTR(d.init_reg_dt,1,4) init_year,			 \r\n"
				+ "			        case when c.diesel_yn = '2' and c.s_st in ('300','301','302') then '3'\r\n"
				+ "				           when c.diesel_yn = '2' and c.s_st not in ('300','301','302') then '4'\r\n"
				+ "						       when c.diesel_yn = 'Y' then '2'\r\n"
				+ "       				 		 when c.diesel_yn = '3' then '5'\r\n"
				+ "			       	 		 when c.diesel_yn = '4' then '6'\r\n"
				+ "				  	       when c.diesel_yn = '5' then '7'\r\n"
				+ "				  	       when c.diesel_yn = '6' then '8'\r\n"
				+ "						       else '1' \r\n" + "			        end  fuel_st\r\n"
				+ "       FROM   cont a, car_etc b, car_nm c, car_reg d\r\n"
				+ "       WHERE  NVL(a.use_yn,'Y')='Y' \r\n"
				+ "              AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \r\n"
				+ "              AND b.car_id=c.car_id AND b.car_seq=c.car_seq\r\n"
				+ "              AND a.car_mng_id=d.car_mng_id\r\n"
				+ "              AND nvl(d.prepare,'0') NOT IN ('4')\r\n" + "       )   \r\n"
				+ "       GROUP BY fuel_st     \r\n" + "       ORDER BY fuel_st) a, \n"
				+ " ( SELECT '99' seq, '합계' AS fuel_nm, \n" + " ";

		for (int i = start_year; i <= end_year; i++) {
			// 이전묶음
			if (i == start_year) {
				query += " SUM(";
				for (int j = 2000; j <= start_year; j++) {
					query += "nvl(y" + j + ",0)";
					if (j < start_year) {
						query += "+";
					}
				}
				query += ") cnt_" + i + ", ";
			} else {
				query += " SUM(nvl(y" + i + ",0)) cnt_" + i + ", ";
			}
		}

		query += " SUM(";
		for (int j = 2000; j <= end_year; j++) {
			query += "nvl(y" + j + ",0)";
			if (j < end_year) {
				query += "+";
			}
		}
		query += ") cnt_t ";

		query += " FROM   (SELECT fuel_st as seq, 0 y2000, 0 y2001,\r\n"
				+ "              count(decode(init_year,'2002',car_mng_id)) y2002,\r\n"
				+ "              count(decode(init_year,'2003',car_mng_id)) y2003,\r\n"
				+ "              count(decode(init_year,'2004',car_mng_id)) y2004,\r\n"
				+ "              count(decode(init_year,'2005',car_mng_id)) y2005,\r\n"
				+ "              count(decode(init_year,'2006',car_mng_id)) y2006,\r\n"
				+ "              count(decode(init_year,'2007',car_mng_id)) y2007,\r\n"
				+ "              count(decode(init_year,'2008',car_mng_id)) y2008,\r\n"
				+ "              count(decode(init_year,'2009',car_mng_id)) y2009,\r\n"
				+ "              count(decode(init_year,'2010',car_mng_id)) y2010,\r\n"
				+ "              count(decode(init_year,'2011',car_mng_id)) y2011,\r\n"
				+ "              count(decode(init_year,'2012',car_mng_id)) y2012,\r\n"
				+ "              count(decode(init_year,'2013',car_mng_id)) y2013,\r\n"
				+ "              count(decode(init_year,'2014',car_mng_id)) y2014,\r\n"
				+ "              count(decode(init_year,'2015',car_mng_id)) y2015,\r\n"
				+ "              count(decode(init_year,'2016',car_mng_id)) y2016,\r\n"
				+ "              count(decode(init_year,'2017',car_mng_id)) y2017,\r\n"
				+ "              count(decode(init_year,'2018',car_mng_id)) y2018,\r\n"
				+ "              count(decode(init_year,'2019',car_mng_id)) y2019,\r\n"
				+ "              count(decode(init_year,'2020',car_mng_id)) y2020,\r\n"
				+ "              count(decode(init_year,'2021',car_mng_id)) y2021,\r\n"
				+ "              count(decode(init_year,'2022',car_mng_id)) y2022,\r\n"
				+ "              count(decode(init_year,'2023',car_mng_id)) y2023,\r\n"
				+ "              count(decode(init_year,'2024',car_mng_id)) y2024,\r\n"
				+ "              count(decode(init_year,'2025',car_mng_id)) y2025,\r\n"
				+ "              count(decode(init_year,'2026',car_mng_id)) y2026,\r\n"
				+ "              count(decode(init_year,'2027',car_mng_id)) y2027,\r\n"
				+ "              count(decode(init_year,'2028',car_mng_id)) y2028,\r\n"
				+ "              count(decode(init_year,'2029',car_mng_id)) y2029,\r\n"
				+ "              count(decode(init_year,'2030',car_mng_id)) y2030            \r\n"
				+ "       FROM        \r\n" + "       (\r\n"
				+ "       SELECT a.car_mng_id, SUBSTR(d.init_reg_dt,1,4) init_year,			 \r\n"
				+ "			        case when c.diesel_yn = '2' and c.s_st in ('300','301','302') then '3'\r\n"
				+ "				           when c.diesel_yn = '2' and c.s_st not in ('300','301','302') then '4'\r\n"
				+ "						       when c.diesel_yn = 'Y' then '2'\r\n"
				+ "       				 		 when c.diesel_yn = '3' then '5'\r\n"
				+ "			       	 		 when c.diesel_yn = '4' then '6'\r\n"
				+ "				  	       when c.diesel_yn = '5' then '7'\r\n"
				+ "				  	       when c.diesel_yn = '6' then '8'\r\n"
				+ "						       else '1' \r\n" + "			        end  fuel_st\r\n"
				+ "       FROM   cont a, car_etc b, car_nm c, car_reg d\r\n"
				+ "       WHERE  NVL(a.use_yn,'Y')='Y' \r\n"
				+ "              AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd \r\n"
				+ "              AND b.car_id=c.car_id AND b.car_seq=c.car_seq\r\n"
				+ "              AND a.car_mng_id=d.car_mng_id\r\n"
				+ "              AND nvl(d.prepare,'0') NOT IN ('4')\r\n" + "       )   \r\n"
				+ "       GROUP BY fuel_st     \r\n" + "       ORDER BY fuel_st)  \n" + "  ) b \n" +

				" ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatCarFuelPerNow]\n" + e);
			System.out.println("[AdminDatabase:getStatCarFuelPerNow]\n" + query);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/*
	 * 계약 담당자 배정
	 */
	public String call_sp_rent_busid2_auto_reg(String rent_mng_id, String rent_l_cd) {
		getConnection();
		String sResult = "";
		CallableStatement cstmt = null;
		String query = "{CALL P_RENT_BUSID2_AUTO_REG (?,?)}";
		try {
			cstmt = conn.prepareCall(query);
			cstmt.setString(1, rent_mng_id);
			cstmt.setString(2, rent_l_cd);
			cstmt.execute();
			cstmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_rent_busid2_auto_reg]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/*
	 * 계약 담당자 배정
	 */
	public String call_sp_agent_users() {
		getConnection();
		String sResult = "";
		CallableStatement cstmt = null;
		String query = "{CALL P_AGENT_USERS }";
		try {
			cstmt = conn.prepareCall(query);
			cstmt.execute();
			cstmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_agent_users]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/**
	 * 월마감-금융사별차입금세부현황
	 */
	public Vector getSelectStatEndBankDebtStatDB(String save_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.etc, a.cpt_cd, a.nm, \n" + "        a.cnt1, a.cnt2, a.cnt, \n"
				+ "        NVL(a.amt1,0) amt1, NVL(a.amt2,0) amt2, NVL(a.amt,0) amt, \n"
				+ "        NVL(a.amt3,0) amt3, \n" + "        NVL(round(b.over_mon_amt/1000000),0) over_mon_amt, \n"
				+ "        NVL(a.amt3,0)-NVL(round(b.over_mon_amt/1000000),0) cha_amt \n" + " from \n" + "        ( \n"
				+ "          SELECT b.etc, a.cpt_cd, b.nm, COUNT(0) cnt, \n"
				+ "                 COUNT(DECODE(NVL(a.alt_amt,0),0,'',a.rent_l_cd)) cnt1, \n" + // --상환중
				"                 COUNT(DECODE(NVL(a.alt_amt,0),0,a.rent_l_cd)) cnt2, \n" + // --상환완료
				"                 round(SUM(a.sh_amt)/1000000) amt, \n"
				+ "                 round(SUM(DECODE(NVL(a.alt_amt,0),0,'',a.sh_amt))/1000000) amt1, \n" + // --상환중
				"                 round(SUM(DECODE(NVL(a.alt_amt,0),0,a.sh_amt))/1000000) amt2, \n" + // --상환완료
				"                 round(SUM(a.FEE_EST_AMT)/1000000) amt3 \n"
				+ "          FROM   STAT_RENT_MONTH a, (SELECT * FROM code WHERE c_st='0003') b \n"
				+ "          WHERE  a.save_dt=replace('" + save_dt
				+ "','-','') AND a.car_mng_id IS not NULL AND a.cpt_cd=b.code(+) \n"
				+ "                 and a.prepare not in ('4','5') \n" + // 말소,도난차량 제외
				"          GROUP BY b.etc, a.cpt_cd, b.nm \n"
				+ "        ) a, (SELECT * FROM stat_debt WHERE save_dt=replace('" + save_dt + "','-','')) b \n"
				+ " WHERE  a.cpt_cd=b.cpt_cd(+) \n" + " ORDER BY a.etc, a.cpt_cd \n" + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}

			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndBankDebtStatDB]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 내부요청자료 07
	 */
	public Vector getInsideReq07(String start_dt, String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT \n"
				+ "        DECODE(e.rent_suc_dt,'',a.rent_start_dt,e.rent_suc_dt) rent_start_dt, l.cls_dt, \n"
				+ "        a.rent_l_cd, a.use_yn, \n" + "        b.client_st, e.client_guar_st, e.client_share_st, \n"
				+ "        b.firm_nm, c.car_nm,         \n"
				+ "        (d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt) o_1,  \n"
				+ "        c.car_no, \n"
				+ "        decode(a.bus_st, '1','인터넷','2','영업사원','3','업체소개','4','카달로그','5','전화상담','6','기존업체', '7', '에이젼트','8','모바일') bus_st, \n"
				+ "        f.user_nm AS bus_nm, f2.user_nm AS bus_nm2, \n"
				+ "        DECODE(a.car_gu,'0','재리스','1','신차','3','중고차','4','월렌트') car_gu, \n"
				+ "        DECODE(a.car_st,'1','렌트','3','리스','4','월렌트') car_st, \n"
				+ "        DECODE(g.rent_way,'1','일반식','기본식') rent_way, \n" + "        g2.con_mon, \n"
				+ "        DECODE(h1.eval_off,'1','크레탑','2','NICE','3','KCB') eval_off1, i1.nm AS eval_gr1, \n"
				+ "        DECODE(h2.eval_off,'1','크레탑','2','NICE','3','KCB') eval_off2, i2.nm AS eval_gr2, \n"
				+ "        DECODE(h3.eval_off,'1','크레탑','2','NICE','3','KCB') eval_off3, i3.nm AS eval_gr3, \n"
				+ "        DECODE(h4.eval_off,'1','크레탑','2','NICE','3','KCB') eval_off4, i4.nm AS eval_gr4, \n"
				+ "        DECODE(h5.eval_off,'1','크레탑','2','NICE','3','KCB') eval_off5, i5.nm AS eval_gr5, \n"
				+ "        g.grt_amt_s, g.gur_p_per,  \n" + "        (g.pp_s_amt+g.pp_v_amt) pp_amt, g.pere_r_per,  \n"
				+ "        (g.ifee_s_amt+g.ifee_v_amt) ifee_amt, \n"
				+ "        DECODE(g.ifee_s_amt,0,0,TRUNC((g.ifee_s_amt+g.ifee_v_amt)/DECODE(a.car_gu,'1',d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt,j.sh_amt)*100,1)) ifee_per, \n"
				+ "        n.gi_amt, \n"
				+ "        DECODE(n.gi_amt,0,0,TRUNC(n.gi_amt/DECODE(a.car_gu,'1',d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt,j.sh_amt)*100,1)) gi_per, \n"
				+ "        k.o_dly_days, k.o_dly_amt, \n" + "        k.n_dly_days, k.n_dly_amt, \n"
				+ "        k.t_fee_amt, k.dly_fee_amt, DECODE(nvl(k.dly_fee_amt,0),0,0,TRUNC(k.dly_fee_amt/k.t_fee_amt*100,3)) dly_per \n"
				+ " FROM   cont a, client b, car_reg c, car_etc d, cont_etc e, users f, users f2, fee g, fee_etc j, cls_cont l, \n"
				+ "        (SELECT rent_mng_id, rent_l_cd, MAX(to_number(rent_st)) rent_st, SUM(con_mon) con_mon FROM fee GROUP BY rent_mng_id, rent_l_cd) g2, \n"
				+ "        (SELECT * FROM cont_eval WHERE eval_gr IS NOT NULL AND eval_gr NOT IN ('없음','생략') AND eval_gu='1') h1, \n"
				+ "        (SELECT * FROM cont_eval WHERE eval_gr IS NOT NULL AND eval_gr NOT IN ('없음','생략') AND eval_gu IN ('2','3')) h2, \n"
				+ "        (SELECT * FROM cont_eval WHERE eval_gr IS NOT NULL AND eval_gr NOT IN ('없음','생략') AND eval_gu IN ('6','5')) h3, \n"
				+ "        (SELECT * FROM cont_eval WHERE eval_gr IS NOT NULL AND eval_gr NOT IN ('없음','생략') AND eval_gu='7') h4, \n"
				+ "        (SELECT * FROM cont_eval WHERE eval_gr IS NOT NULL AND eval_gr NOT IN ('없음','생략') AND eval_gu='8') h5, \n"
				+ "        (SELECT * FROM code WHERE c_st='0013') i1,  \n"
				+ "        (SELECT * FROM code WHERE c_st='0013') i2, \n"
				+ "        (SELECT * FROM code WHERE c_st='0013') i3, \n"
				+ "        (SELECT * FROM code WHERE c_st='0013') i4, \n"
				+ "        (SELECT * FROM code WHERE c_st='0013') i5, \n"
				+ "        (SELECT rent_mng_id, rent_l_cd,  \n"
				+ "                SUM(DECODE(rc_dt,'',0,dly_days)) o_dly_days, SUM(DECODE(rc_dt,'',0,dly_fee)) o_dly_amt,  \n"
				+ "                SUM(DECODE(rc_dt,'',dly_days)) n_dly_days, SUM(DECODE(rc_dt,'',dly_fee)) n_dly_amt, \n"
				+ "                SUM(DECODE(rc_dt,'',DECODE(dly_fee,0,0,fee_s_amt+fee_v_amt))) dly_fee_amt, \n"
				+ "                SUM(DECODE(rc_dt,'',fee_s_amt+fee_v_amt)) t_fee_amt \n"
				+ "         FROM   scd_fee  \n" + "         WHERE bill_yn='Y'  \n"
				+ "         GROUP BY rent_mng_id, rent_l_cd \n" 
				+ "        ) k, \n" 
				+ "        gua_ins n          \n"
				+ " WHERE  a.car_st IN ('1','3','4') \n"
				+ "        AND DECODE(e.rent_suc_dt,'',a.rent_start_dt,e.rent_suc_dt) between '" + start_dt + "' and '"	+ end_dt + "' \n" 
				+ "        AND a.client_id=b.client_id \n"
				+ "        AND a.car_mng_id=c.car_mng_id \n"
				+ "        AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd \n"
				+ "        AND a.rent_mng_id=e.rent_mng_id AND a.rent_l_cd=e.rent_l_cd \n"
				+ "        AND a.BUS_ID=f.user_id \n" + "        AND a.bus_id2=f2.user_id \n"
				+ "        AND a.rent_mng_id=g.rent_mng_id AND a.rent_l_cd=g.rent_l_cd \n"
				+ "        AND g.rent_mng_id=g2.rent_mng_id AND g.rent_l_cd=g2.rent_l_cd AND g.RENT_ST=g2.rent_st \n"
				+ "        AND g.rent_mng_id=j.rent_mng_id AND g.rent_l_cd=j.rent_l_cd AND g.RENT_ST=j.rent_st \n"
				+ "        AND a.rent_mng_id=h1.rent_mng_id(+) AND a.rent_l_cd=h1.rent_l_cd(+) \n"
				+ "        AND a.rent_mng_id=h2.rent_mng_id(+) AND a.rent_l_cd=h2.rent_l_cd(+) \n"
				+ "        AND a.rent_mng_id=h3.rent_mng_id(+) AND a.rent_l_cd=h3.rent_l_cd(+) \n"
				+ "        AND a.rent_mng_id=h4.rent_mng_id(+) AND a.rent_l_cd=h4.rent_l_cd(+) \n"
				+ "        AND a.rent_mng_id=h5.rent_mng_id(+) AND a.rent_l_cd=h5.rent_l_cd(+) \n"
				+ "        AND h1.eval_gr=i1.nm_cd(+) \n" 
				+ "        AND h2.eval_gr=i2.nm_cd(+) \n"
				+ "        AND h3.eval_gr=i3.nm_cd(+) \n" 
				+ "        AND h4.eval_gr=i4.nm_cd(+) \n"
				+ "        AND h5.eval_gr=i5.nm_cd(+) \n"
				+ "        AND a.rent_mng_id=k.rent_mng_id(+) AND a.rent_l_cd=k.rent_l_cd(+) \n"
				+ "        AND a.rent_mng_id=l.rent_mng_id(+) AND a.rent_l_cd=l.rent_l_cd(+) \n"
				+ "        AND g.rent_mng_id=n.rent_mng_id(+) AND g.rent_l_cd=n.rent_l_cd(+) AND g.RENT_ST=n.rent_st(+) \n"
				+ " ORDER BY DECODE(a.car_st,'1','1','3','1','4','2'), DECODE(e.rent_suc_dt,'',a.rent_start_dt,e.rent_suc_dt), a.client_id, c.car_nm, c.init_reg_dt "
				+ " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getInsideReq07]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/*
	 * 자동차 주행거리 등록시 주행거리점검
	 */
	public String call_sp_dist_case_ck(String car_mng_id, String user_id) {
		getConnection();
		String sResult = "";
		CallableStatement cstmt = null;
		String query = "{CALL P_DIST_CASE_CHK (?,?)}";
		try {
			cstmt = conn.prepareCall(query);
			cstmt.setString(1, car_mng_id);
			cstmt.setString(2, user_id);
			cstmt.execute();
			cstmt.close();
			System.out.println("[AdminDatabase:call_sp_dist_case_ck]\n" + car_mng_id);
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_dist_case_ck]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/**
	 * 외부요청자료 03
	 */
	public Vector getOutsideReq03(String end_dt, String bank_cd) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select " + "        c.firm_nm, d.car_nm, d.car_no, a.cnt, a.amt " + " from "
				+ "        (select rent_l_cd, count(*) cnt, sum(fee_s_amt+fee_v_amt) amt " + "         from   scd_fee "
				+ "         where  nvl(bill_yn,'Y')='Y'  and tm_st2<>'4' and fee_s_amt>0 and rc_yn='0' and r_fee_est_dt < to_char(sysdate,'YYYYMMDD') "
				+ "         group by rent_l_cd) a, " + "        cont b, client c, car_reg d, allot e "
				+ " where  a.rent_l_cd=b.rent_l_cd " + "        and b.client_id=c.client_id "
				+ "        and b.car_mng_id=d.car_mng_id " + "        and b.rent_l_cd=e.rent_l_cd and e.cpt_cd='"
				+ bank_cd + "' " + " order by c.firm_nm " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getOutsideReq03(String end_dt, String bank_cd)]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/*
	 * 자동차 주행거리 등록시 주행거리점검
	 */
	public String call_sp_dist_etc_ck(String car_mng_id, String work_nm, String dist_km, String dist_dt,
			String user_id) {
		getConnection();
		String sResult = "";
		CallableStatement cstmt = null;
		String query = "{CALL P_DIST_ETC_CHK (?,?,?,?,?)}";
		try {
			cstmt = conn.prepareCall(query);
			cstmt.setString(1, car_mng_id);
			cstmt.setString(2, work_nm);
			cstmt.setString(3, dist_km);
			cstmt.setString(4, dist_dt);
			cstmt.setString(5, user_id);
			cstmt.execute();
			cstmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_dist_etc_ck]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	// 내부요청자료08 (20190906)
	public Vector getInsideReq08(String start_dt, String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "  SELECT g.CAR_NUM as CAR_NUM, " + "  d.s_st as s_st,  " + "  d.jg_code as jg_code,  "
				+ "  d.sh_code as sh_code ,  " + "  i.CAR_NM as car_nm,  " + "  g.CAR_Y_FORM as car_y_form,  "
				+ "  g.dpm as dpm,  " + "  i2.nm as fuel_kd, " + "  d.car_name as car_name, " + "  g.car_no as car_no, "
				+ "  g.FIRST_CAR_NO as first_car_no,  " + "  g.init_reg_dt as INIT_REG_DT , "
				+ "  a.DLV_DT as DLV_DT, a.RENT_DT as RENT_DT, " + "  ( c.car_cs_amt + c.car_cv_amt ) as car_amt, "
				+ "  ( c.opt_cs_amt + c.opt_cv_amt ) as opt_amt, "
				+ "   c.CAR_FS_AMT AS car_fs_amt, c.CAR_FV_AMT AS CAR_FV_AMT, "
				+ "  ( c.car_fs_amt + c.car_fv_amt ) as car_fsv_amt , " + "  c.OPT as opt, "
				+ "  ( c.clr_cs_amt + c.clr_cv_amt ) as clr_amt, "
				+ "  c.COLO as colo, c.IN_COL as in_col, c.garnish_col, "
				+ "  ( c.DC_CS_AMT + c.DC_CV_AMT ) AS dc_amt , "
				+ "   decode( c.PURC_GU, 0, '면세', 1, '과세' ) AS PURC_GU , " + "   d.AUTO_YN AS AUTO, " + "   d.CAR_B , "
				+ "   CASE WHEN d.AUTO_YN = 'Y' THEN 'A/T' WHEN c.OPT LIKE '%변속기%' OR c.OPT LIKE '%DCT%' OR c.OPT LIKE '%C-TECH%' OR c.OPT LIKE '%A/T%' THEN 'A/T' WHEN d.CAR_B LIKE '%자동변속기%' OR d.CAR_B LIKE '%무단 변속기%' THEN 'A/T' ELSE 'M/T' END AS auto_yn"
				+ "   FROM  cont a, fee b, car_etc c, car_nm d, car_reg g, cls_cont e, fee_etc h, cont_etc f, car_mng i, "
				+ "         (select * from code where c_st='0039') i2 "
				+ "   WHERE a.car_st NOT IN('2','4') AND a.car_gu = '1'  "
				+ "   AND a.rent_mng_id = b.rent_mng_id AND a.rent_l_cd = b.rent_l_cd AND b.rent_st = '1' "
				+ "   AND a.rent_mng_id = c.rent_mng_id AND a.rent_l_cd = c.rent_l_cd "
				+ "   AND c.car_id = d.car_id AND c.car_seq = d.car_seq  " + "   AND a.car_mng_id = g.car_mng_id(+) "
				+ "   AND a.rent_mng_id = e.rent_mng_id(+) AND a.rent_l_cd = e.rent_l_cd(+) AND nvl(e.cls_st,'0') NOT IN ('7','10') "
				+ "   AND b.rent_mng_id = h.rent_mng_id AND b.rent_l_cd = h.rent_l_cd AND b.rent_st = h.rent_st "
				+ "   AND a.rent_mng_id = f.rent_mng_id AND a.rent_l_cd = f.rent_l_cd AND f.rent_suc_dt IS NULL "
				+ "   AND d.car_comp_id = i.car_comp_id AND d.car_cd = i.code " + "   and g.FUEL_KD=i2.nm_cd(+) " + " ";

		if (!start_dt.equals("")) {
			query += "AND a.RENT_DT >= " + start_dt;
		}
		if (!end_dt.equals("")) {
			query += "AND a.RENT_DT <= " + end_dt;
		}
		if (start_dt.equals("") && end_dt.equals("")) {

			// 현재 년월 구하기
			Calendar calendar = Calendar.getInstance();
			int curYear = calendar.get(Calendar.YEAR);
			int curMonth = calendar.get(Calendar.MONTH) + 1;
			String stringMonth = "";
			if (curMonth < 10) {
				stringMonth = "0" + String.valueOf(curMonth);
			} else {
				stringMonth = String.valueOf(curMonth);
			}
			String curYM = String.valueOf(curYear) + stringMonth;

			query += "AND a.RENT_DT LIKE '" + curYM + "%'";
		}

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getInsideReq08]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	// 내부요청자료08_2 (20191029)
	public Vector getInsideReq08_2(String start_dt, String end_dt, String jg_code, String car_nm) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = 
				"	SELECT\r\n" + 
				"	g.CAR_MNG_ID, g.CAR_NUM AS CAR_NUM,d.s_st AS s_st,d.jg_code AS jg_code,d.sh_code AS sh_code ,\r\n" + 
				"	i.CAR_NM AS car_nm,	g.CAR_Y_FORM AS car_y_form,	g.dpm AS dpm, d.car_id, d.car_seq, \r\n" + 
				"	CASE\r\n" + 
				"		WHEN d.AUTO_YN = 'Y' THEN 'A/T'\r\n" + 
				"		WHEN c.OPT LIKE '%변속기%'\r\n" + 
				"		OR c.OPT LIKE '%DCT%'\r\n" + 
				"		OR c.OPT LIKE '%C-TECH%'\r\n" + 
				"		OR c.OPT LIKE '%A/T%' THEN 'A/T'\r\n" + 
				"		WHEN d.CAR_B LIKE '%자동변속기%'\r\n" + 
				"		OR d.CAR_B LIKE '%무단 변속기%' THEN 'A/T'\r\n" + 
				"		ELSE 'M/T'\r\n" + 
				"	END AS auto_yn,\r\n" + 
				"	i2.nm AS fuel_kd,	d.car_name AS car_name,	g.car_no AS car_no,	g.FIRST_CAR_NO AS first_car_no,\r\n" + 
				"	g.init_reg_dt AS INIT_REG_DT ,	a.DLV_DT AS DLV_DT,	( c.car_cs_amt + c.car_cv_amt ) AS car_amt,\r\n" + 
				"	( c.opt_cs_amt + c.opt_cv_amt ) AS opt_amt,	c.CAR_FS_AMT AS car_fs_amt,	c.CAR_FV_AMT AS CAR_FV_AMT,\r\n" + 
				"	( c.car_fs_amt + c.car_fv_amt ) AS car_fsv_amt ,	c.OPT AS opt,	c.ECAR_PUR_SUB_AMT AS ECAR_PUR_SUB_AMT,\r\n" + 
				"	( c.clr_cs_amt + c.clr_cv_amt ) AS clr_amt,	\r\n" + 
				"	( c.car_cs_amt + c.car_cv_amt + c.opt_cs_amt + c.opt_cv_amt + c.clr_cs_amt + c.clr_cv_amt ) sum_amt ,\r\n" + 
				"	c.COLO AS colo,	c.IN_COL AS in_col,	c.garnish_col,	( c.DC_CS_AMT + c.DC_CV_AMT ) AS dc_amt ,\r\n" + 
				"	decode( c.PURC_GU, 0, '면세', 1, '과세' ) AS PURC_GU ,	a.rent_l_cd,	a.rent_dt,	j.firm_nm,	b.con_mon,\r\n" + 
				"	b.Max_ja,	b.Opt_per,	k.user_nm,	i3.nm,	i4.nm AS car_ext,	a.p_addr,	l.rpt_no,	o1.mgr_nm,	o1.mgr_m_tel,\r\n" + 
				"	DECODE(o1.mgr_email, '', j.con_agnt_email, o1.mgr_email) mgr_email,	h.agree_dist,	co.car_off_nm,\r\n" + 
				"	b.GUR_P_PER,	--보증금율	\r\n" + 
				"	b.GRT_AMT_S,	--보증금\r\n" + 
				"	(b.PP_S_AMT + b.PP_V_AMT) AS PP_AMT,	--선납금\r\n" + 
				"	b.PERE_R_PER,	--선납금율\r\n" + 
				"	(b.IFEE_S_AMT + b.IFEE_V_AMT) AS IFEE_AMT,	--개시대여료\r\n" + 
				"	b.PERE_R_MTH,	--개시대여료 개월수\r\n" + 
				"	gu.GI_AMT,	--보증보험금액\r\n" + 
				"	b.cls_r_per,	--위약금율\r\n" + 
				"	(b.fee_s_amt+b.fee_v_amt) rent_fee,	--월대여료\r\n" + 
				"	CASE\r\n" + 
				"		WHEN TO_NUMBER(d.CAR_COMP_ID) >5 THEN 1  \r\n" + 
				"		ELSE 0\r\n" + 
				"	END AS 	CAR_COMP_ID,	--수입차여부\r\n" + 
				"	decode(est.JG_2, '1', DECODE(d.DUTY_FREE_OPT, '0', 'Y', 'N'), est.JG_2) JG_2	--일반승용 LPG차 과세가 여부\r\n" + 
				"   FROM  cont a, fee b, car_etc c, car_nm d, car_reg g, cls_cont e, fee_etc h, cont_etc f, car_mng i, \r\n" + 
				"   (SELECT * FROM commi WHERE agnt_st = '2') cm, car_off_emp coe, car_off co, gua_ins gu,\r\n" + 
				"   (select * from code where c_st='0040') i2, \r\n" + 
				"   (select * from code where c_st='0035') i3, \r\n" + 
				"   (select * from code where c_st='0032') i4, \r\n" + 
				"   (SELECT * FROM ESTI_JG_VAR e1 WHERE (SH_CODE, SEQ) IN (((SELECT  SH_CODE, MAX(seq) FROM ESTI_JG_VAR WHERE jg_2  IS NOT NULL GROUP BY SH_CODE)))) est, \r\n" + 
				"   client j, users k, car_pur l,  \r\n" + 
				"   (SELECT * FROM car_mgr WHERE mgr_st='차량이용자') o1	\r\n" + 
				"WHERE a.car_st NOT IN('2', '4')\r\n" + 
				"AND a.car_gu = '1'\r\n" + 
				"AND a.rent_mng_id = b.rent_mng_id\r\n" + 
				"AND a.rent_l_cd = b.rent_l_cd\r\n" + 
				"AND b.rent_st = '1'\r\n" + 
				"AND a.rent_mng_id = c.rent_mng_id\r\n" + 
				"AND a.rent_l_cd = c.rent_l_cd\r\n" + 
				"AND c.car_id = d.car_id\r\n" + 
				"AND c.car_seq = d.car_seq\r\n" + 
				"AND a.car_mng_id = g.car_mng_id(+)\r\n" + 
				"AND a.rent_mng_id = e.rent_mng_id(+)\r\n" + 
				"AND a.rent_l_cd = e.rent_l_cd(+)\r\n" + 
				"AND (nvl(e.cls_st, '0') NOT IN ('7', '10') or (a.client_id='000228' and a.use_yn='N' and e.cls_st is null))\r\n" + 
				"AND b.rent_mng_id = h.rent_mng_id\r\n" + 
				"AND b.rent_l_cd = h.rent_l_cd\r\n" + 
				"AND b.rent_st = h.rent_st\r\n" + 
				"AND a.rent_mng_id = f.rent_mng_id\r\n" + 
				"AND a.rent_l_cd = f.rent_l_cd\r\n" + 
				"AND f.rent_suc_dt IS NULL\r\n" + 
				"AND d.car_comp_id = i.car_comp_id\r\n" + 
				"AND d.car_cd = i.code\r\n" + 
				"AND d.Diesel_yn = i2.nm_cd\r\n" + 
				"AND d.JG_CODE = est.SH_CODE(+)\r\n" + 
				"AND a.client_id = j.client_id\r\n" + 
				"AND a.BUS_ID = k.user_id\r\n" + 
				"AND a.rent_mng_id = l.rent_mng_id\r\n" + 
				"AND a.rent_l_cd = l.rent_l_cd\r\n" + 
				"AND l.Udt_st = i3.nm_cd(+)\r\n" + 
				"and c.car_ext = i4.nm_cd(+) \r\n" + 
				"AND a.rent_mng_id = o1.rent_mng_id\r\n" + 
				"AND a.rent_l_cd = o1.rent_l_cd\r\n" + 
				"AND a.rent_mng_id = cm.rent_mng_id(+)\r\n" + 
				"AND a.rent_l_cd = cm.rent_l_cd(+)\r\n" + 
				"AND cm.emp_id = coe.emp_id(+)\r\n" + 
				"AND coe.car_off_id = co.car_off_id(+)\r\n" + 
				"AND a.RENT_L_CD = gu.RENT_L_CD(+)\r\n" + 
				"AND a.RENT_MNG_ID = gu.RENT_MNG_ID(+)\r\n" + 
				"AND a.RENT_ST = gu.RENT_ST(+)\r\n" + 
				"";
		
		if (!start_dt.equals("")) {
			query += " AND a.RENT_DT >= " + start_dt;
		}

		if (!end_dt.equals("")) {
			query += " AND a.RENT_DT <= " + end_dt;
		}

		if (start_dt.equals("") && end_dt.equals("")) {

			// 현재 년월 구하기
			Calendar calendar = Calendar.getInstance();
			int curYear = calendar.get(Calendar.YEAR);
			int curMonth = calendar.get(Calendar.MONTH) + 1;
			String stringMonth = "";
			if (curMonth < 10) {
				stringMonth = "0" + String.valueOf(curMonth);
			} else {
				stringMonth = String.valueOf(curMonth);
			}
			String curYM = String.valueOf(curYear) + stringMonth;

			query += " AND a.RENT_DT LIKE '" + curYM + "%'";
		}

		if (!jg_code.equals("")) {
			query += " AND d.jg_code ='" + jg_code + "'";
		}

		if (!car_nm.equals(""))
			query += " AND upper(i.car_nm||d.car_name) LIKE upper('%" + car_nm + "%')";

		query += " ORDER BY a.rent_dt ";
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getInsideReq08_2]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}
	
	
	// 경매장 데이터8_3 (20200128)
		public Hashtable getInsideReq08_3(String car_mng_id) {
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Hashtable ht = new Hashtable();
			String query = "";

			query = " SELECT \r\n" + 
					"       DECODE(mm.rent_st,'1',nvl(d.RENT_DT, a.RENT_DT), mm2.SH_DAY_BAS_DT) AS ACTN_DT, --낙찰일\r\n" + 
					"	   '분당' ACTN_OFF_NM,\r\n" + 
					"       '8888' ACTN_CNT,--경매회차\r\n" + 
					"       '10000' ACTN_NUM,--출품번호\r\n" + 
					"		f.CAR_NM ||' '|| i.CAR_NAME CAR_NAME, --차명\r\n" + 
					"		f.car_y_form,--연식\r\n" + 
					"		decode(i.AUTO_YN,'Y','자동','수동') auto_yn , --AUTO_YN|\r\n" + 
					"		fuel_cd.nm FUEL_KD,--FUEL_KD\r\n" + 
					"		nvl(f.dpm,0) DPM,--DPM \r\n" + 
					"		DECODE(mm.rent_st,'1',mm.SH_KM, mm2.SH_KM) AGREE_DIST,--AGREE_DIST\r\n" + 
					"		h.COLO COL,--COL|\r\n" + 
					"		decode(f.CAR_USE,'1','렌트','리스') car_use,--CAR_USE  \r\n" + 
					"		'법인' car_own,--CAR_OWN|\r\n" + 
					"		'' SKILL1,--SKILL1\r\n" + 
					"		'' SKILL2,--SKILL2 \r\n" + 
					"		'' SKILL3,--SKILL3\r\n" + 
					"		'' SKILL4,--SKILL4  \r\n" + 
					"		'' SKILL5,--SKILL5\r\n" + 
					"		'' SKILL6,--SKILL6\r\n" + 
					"		'' SKILL7,--SKILL7\r\n" + 
					"		'' SKILL8,--SKILL8\r\n" + 
					"		'' RATING1,--RATING1\r\n" + 
					"		'' RATING2,--RATING2\r\n" + 
					"		'' ST_PR,--ST_PR\r\n" + 
					"		decode(mm.BC_B_E2,0,0,mm.BC_B_E2/10000) NAK_PR,--NAK_PR\r\n" + 
					"		f.CAR_NM ||' '|| i.CAR_NAME CAR_NAME2,--CAR_NAME2\r\n" + 
					"		i.jg_code,--차종코드\r\n" + 
					"		f.init_reg_dt, --최초등록일 \r\n" + 
					"		nvl(h.opt,'') opt,-- 옵션\r\n" + 
					"		'' etc, --ETC\r\n" + 
					"		nvl(round((h.car_cs_amt + h.car_cv_amt + h.opt_cs_amt + h.opt_cv_amt + h.clr_cs_amt + h.clr_cv_amt )/10000),0) AS ACTN_CAR_AMT,--ACTN_CAR_AMT\r\n" + 
					"		nvl(f.TAKING_P,0) TAKING_P,--TAKING_P\r\n" + 
					"		sysdate,--REG_DTTM\r\n" + 
					"		'' FILE_SEQ,--FILE_SEQ\r\n" + 
					"		f.car_no --차량번호\r\n" + 
					"FROM cont a, client b, cont_etc c, fee d,  car_reg f, car_etc h, car_nm i, car_mng j, fee_etc mm,  \r\n" + 
					" 	(SELECT rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, sum(con_mon) con_mon, min(nvl(rent_start_dt,'')) \r\n" + 
					" 	 rent_start_dt, max(nvl(rent_end_dt,'')) rent_end_dt \r\n" + 
					"	FROM fee GROUP BY rent_mng_id, rent_l_cd ) m, \r\n" + 
					"	(SELECT * FROM code WHERE c_st='0039') fuel_cd ,\r\n" + 
					"	(SELECT  RENT_L_CD , RENT_MNG_ID, SH_KM, SH_DAY_BAS_DT FROM fee_etc WHERE RENT_ST = 1) mm2\r\n" + 
					"	WHERE 1=1\r\n" + 
					"	AND a.car_st NOT IN ('2', '4')\r\n" + 
					"	AND a.car_st <> '2'\r\n" + 
					"	AND a.car_gu = '1'\r\n" + 
					"	AND c.rent_suc_dt IS NULL\r\n" + 
					"	AND a.client_id = b.client_id\r\n" + 
					"	AND a.rent_mng_id = c.rent_mng_id\r\n" + 
					"	AND a.rent_l_cd = c.rent_l_cd\r\n" + 
					"	AND a.rent_mng_id = d.rent_mng_id\r\n" + 
					"	AND a.rent_l_cd = d.rent_l_cd\r\n" + 
					"	AND a.car_mng_id = f.car_mng_id(+)\r\n" + 
					"	AND a.rent_mng_id = h.rent_mng_id\r\n" + 
					"	AND a.rent_l_cd = h.rent_l_cd\r\n" + 
					"	AND h.car_id = i.car_id\r\n" + 
					"	AND h.car_seq = i.car_seq\r\n" + 
					"	AND i.car_comp_id = j.car_comp_id\r\n" + 
					"	AND i.car_cd = j.code\r\n" + 
					"	AND d.rent_l_cd = m.rent_l_cd\r\n" + 
					"	AND d.rent_st = m.rent_st\r\n" + 
					"	AND d.rent_mng_id = mm.rent_mng_id\r\n" + 
					"	AND d.rent_l_cd = mm.rent_l_cd\r\n" + 
					"	AND d.rent_st = mm.rent_st\r\n" + 
					"	AND i.Diesel_yn = fuel_cd.nm_cd(+)\r\n" + 
					"	AND a.rent_l_cd = mm2.rent_l_cd(+)\r\n" + 
					"	AND a.rent_mng_id = mm2.rent_mng_id(+)\r\n" + 
					"   AND a.car_mng_id = ?";
			try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString	(1,  car_mng_id	);
				rs = pstmt.executeQuery();

				ResultSetMetaData rsmd = rs.getMetaData();
				while (rs.next()) {
					for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
						String columnName = rsmd.getColumnName(pos);
						ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
					}
				}
				rs.close();
				pstmt.close();

			} catch (SQLException e) {
				System.out.println("[AdminDatabase:getInsideReq8_3]" + e);
				e.printStackTrace();
			} finally {
				try {
					if (rs != null)
						rs.close();
					if (pstmt != null)
						pstmt.close();
				} catch (Exception ignore) {
				}
				closeConnection();
				return ht;
			}
		}
		
	

	/**
	 * 내부요청자료 09
	 */
	public Vector getInsideReq09(String start_dt, String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT SUBSTR(b.tax_dt,1,6) tax_m, SUM(a.item_supply) amt \n"
				+ " FROM   tax_item_list a, tax b, cont c, car_reg d \n"
				+ " WHERE  a.item_id=b.item_id AND b.tax_dt BETWEEN replace('" + start_dt + "','-','') AND replace('"
				+ end_dt + "','-','') AND b.tax_st<>'C' \n"
				+ "       AND a.rent_l_cd=c.RENT_L_CD AND c.car_mng_id=d.car_mng_id \n" + "       AND d.fuel_kd='8' \n"
				+ " GROUP BY SUBSTR(b.tax_dt,1,6) \n" + " ORDER BY SUBSTR(b.tax_dt,1,6) " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getInsideReq09(String start_dt, String bank_cd)]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	// 내부요청자료10 (20200907)
	public Vector getInsideReq10(String start_dt, String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "  SELECT \r\n" + 
				"	f.CAR_MNG_ID, f.CAR_NUM, a.RENT_L_CD,  DECODE(mm.rent_st,'1',nvl(d.RENT_DT, a.RENT_DT), mm2.SH_DAY_BAS_DT) RENT_DT,\r\n" + 
				"	 b.FIRM_NM, nvl(c.RENT_SUC_DT, o.CLS_DT) AS RENT_SUC_DT,\r\n" + 
				"	i.JG_CODE, f.CAR_NO, j.CAR_NM, i.CAR_NAME, f.INIT_REG_DT,\r\n" + 
				"	ROUND(((to_date(nvl(d.RENT_DT, a.RENT_DT), 'YYYYMMDD')-to_date(f.INIT_REG_DT, 'YYYYMMDD'))/365*12),2) CAR_AGE,\r\n" + 
				"	((to_date(nvl(d.RENT_DT, a.RENT_DT), 'YYYYMMDD')-to_date(f.INIT_REG_DT, 'YYYYMMDD'))/365*12) CAR_AGE_ORG,\r\n" + 
				"	DECODE(mm.rent_st,'1',mm.SH_KM, mm2.SH_KM) TOT_DIST,	(h.car_cs_amt + h.car_cv_amt) AS car_amt, h.OPT, (h.opt_cs_amt + h.opt_cv_amt) AS opt_amt, h.COLO, h.IN_COL,\r\n" + 
				"	( h.clr_cs_amt + h.clr_cv_amt ) AS clr_amt,\r\n" + 
				"	( h.car_cs_amt + h.car_cv_amt + h.opt_cs_amt + h.opt_cv_amt + h.clr_cs_amt + h.clr_cv_amt ) AS car_fsv_amt ,\r\n" + 
				"	decode(est.JG_2, '1', DECODE(i.DUTY_FREE_OPT, '0', 'Y', 'N'), est.JG_2) JG_2,\r\n" + 
				"	(h.CAR_fS_AMT + h.SD_CS_AMT -h.DC_CS_AMT)+(h.CAR_FV_AMT + h.SD_CV_AMT-h.DC_CV_AMT) CAR_SLL_AMT,\r\n" + 
				"	mm.BC_B_E2, ROUND((mm.BC_B_E2 /(h.car_cs_amt + h.car_cv_amt + h.opt_cs_amt + h.opt_cv_amt + h.clr_cs_amt + h.clr_cv_amt)* 100), 2) BC_FSV_PER,\r\n" + 
				"	mm.SH_AMT, ROUND((NVL(mm.SH_AMT / decode((h.car_cs_amt + h.car_cv_amt + h.opt_cs_amt + h.opt_cv_amt + h.clr_cs_amt + h.clr_cv_amt), 0, NULL,(h.car_cs_amt + 	h.car_cv_amt + h.opt_cs_amt + h.opt_cv_amt + h.clr_cs_amt + h.clr_cv_amt)), 0)* 100), 2) SH_FSV_PER,\r\n" + 
				"	TOT_AMT,\r\n" + 
				"	ROUND((NVL(TOT_AMT / decode((h.car_fs_amt + h.car_fv_amt), 0, NULL,(h.car_fs_amt + h.car_fv_amt)), 0)* 100), 2) ACC_FSV_PER,\r\n" + 
				"	f.dpm, fuel_cd.nm AS fuel_kd, f.CAR_Y_FORM, \r\n" + 
				"	decode(i.AUTO_YN, 'Y', 'A/T', 'M/T') AUTO_TN,DECODE(f.DIST_CNG, '', 'N', 'Y') AS dist_cng_yn,\r\n" + 
				"	decode(nvl(accid.a_cnt, 0), '0', 'N', 'Y') AS a_cnt_yn,\r\n" + 
				"    f.car_no,\r\n" + 
				"	to_char(ROUND(ej.JG_1*100,2),'FM90.00') AS M, --현시점 차령 24개월 잔가율 \r\n" + 
				"	to_char(ROUND(ee.JG_C_1*100,2),'FM90.00') AS N, --0 개월 기준잔가\r\n" + 
				"	nvl(ej.JG_G_9,'0') AS O,  --0개월잔가 적용방식 구분 0.조정율미적용 1.조정율적용\r\n" + 
				"	to_char(ROUND(nvl(ej.JG_G_10,'0'),3),'FM90.000') AS P, --0개월 기준잔가 조정율\r\n" + 
				"	to_char(ROUND(ej.JG_4*100,2),'FM90.00') AS Q, --최저잔가율 조정 승수 (최대 0.4)\r\n" + 
				"	to_char(ec.SH_A_M_1*nvl(ej.jg_g_45,1),'FM900.00') AS R, --재리스 현재 중고차 경기지수\r\n" + 
				"	ec.SH_A_M_1*nvl(ej.jg_g_45,1) SH_A_M_1,\r\n" + 
				"	decode(ej.JG_B,'1',ec.JG_C_72,'2',ec.JG_C_73,ec.JG_C_71) AS S, --3년 표준주행거리(km)\r\n" + 
				"	to_char(ROUND(ee.O_E*(ec.SH_A_M_1*nvl(ej.jg_g_45,1)/100)*100,2),'FM90.00') AS jg_1_sh_a_m_1, --해당차량 주행거리 반영 잔가율\r\n" + 
				"	to_char(ROUND(ej.JG_14,3),'FM90.000') AS T, --초과 10,000km당 중고차가 조정율\r\n" + 
				"	to_char(ee.O_E*ee.O_R*ec.SH_A_M_1*nvl(ej.jg_g_45,1),'FM90.00') AS U, --차령,주행거리 반영 차종코드 잔가율\r\n" + 
				"	to_char(ROUND(nvl(ee.N_VAR1,0),5),'FM990.00000') AS V, --현시점 수출효과\r\n" + 
				"	nvl(ac.car_amt_n_lo,0) car_amt_n_lo, --계약시점환산소비자가\r\n" + 
				"    nvl(ac.car_amt_r_p,0) car_amt_r_p, --소비자가2\r\n" + 
				"	nvl(ac.car_amt_r_n,0) car_amt_r_n,  --계약시점환산소비자가2\r\n" + 
				"	ac.auto, --구동방식\r\n" + 
				"	ac.wheel_drive,  --변속기2\r\n" + 
				"	ac.option_b, --옵션2\r\n" + 
				"	ac.gaesu_rate_p, --구입시점개소세율 \r\n" + 
				"	ac.gaesu_yn, --구입시점 개소세 과세여부\r\n" + 
				"	ac.gaesu_real_amt_p, --구입시점 개소세 실감면액(소비자가2기준)\r\n" + 
				"	ac.gaesu_rate_n, --계약시점 개소세율\r\n" + 
				"	ac.gaesu_n_yn, --계약시점 개소세 과세여부\r\n" + 
				"	ac.gaesu_real_amt_n, --계약시점 개소세 실감면액(소비자2기준)\r\n" + 
				"	ej.JG_G_21 AS W, --수출불가 사양\r\n" + 
				"	ee.O_S*10000 AS AH, --사고수리비 반영전 예상낙찰가\r\n" + 
				"	to_char(ROUND(ee.N_VAR2,5),'FM990.00000') AS BA, --재리스 종료시점 수출효과\r\n" + 
				"	d.CON_MON AS AW,\r\n" + 
				"	d.RENT_START_DT AS AX, \r\n" + 
				"	d.RENT_END_DT AS AY,\r\n" + 
				"	em.b_agree_dist AS AZ, --표준약정주행거리\r\n" + 
				"	em.agree_dist AS BC, --계약약정주행거리\r\n" + 
				"	to_char(em.b_o_13,'FM90.00') AS BB, --표준최대잔가\r\n" + 
				"	to_char(em.o_13,'FM90.00') AS BD, --조정최대잔가\r\n" + 
				"	to_char(nvl(d.opt_per,0),'FM90.00') AS BE, --매입옵션 적용잔가\r\n" + 
				"	(d.opt_s_amt+d.opt_v_amt) AS BF, --매입옵션금액\r\n" + 
				"	em.accid_serv_amt1 AS AM, --1위 사고수리비\r\n" + 
				"	em.accid_serv_amt2 AS AN, --2위 사고수리비\r\n" + 
				"   decode(ee.FW917,'',trunc(to_number(to_date(a.rent_dt,'YYYYMMDD')-to_date(f.init_reg_dt,'YYYYMMDD'))/365*12,9), ee.FW917) FW917, \r\n" + 
				"	decode(ee.GB917,'',trunc(to_number(to_date(a.rent_dt,'YYYYMMDD')-to_date(f.init_reg_dt,'YYYYMMDD'))/365*12,9) + d.CON_MON, ee.GB917) GB917, \r\n" + 
				"	ej.sh_code, ej.seq --잔가 반영 색상 및 사양 연동처리용  \r\n" + 
				"FROM cont a, client b, cont_etc c, fee d,  car_reg f, car_etc h, car_nm i, car_mng j,  cls_cont o,  fee_etc mm,  \r\n" + 
				" 	estimate em, esti_exam ee, esti_jg_var ej, esti_comm_var ec,	(SELECT rent_mng_id, rent_l_cd, min(to_number(rent_st)) rent_st, sum(con_mon) con_mon, min(nvl(rent_start_dt,'')) rent_start_dt, max(nvl(rent_end_dt,'')) rent_end_dt \r\n" + 
				"	FROM fee GROUP BY rent_mng_id, rent_l_cd ) m, \r\n" + 
				"   (SELECT rent_mng_id, reg_dt, cls_dt, cls_st from cls_cont where cls_st in ('4','5')) y, \r\n" + 
				"   (SELECT * from code where c_st='0032') ec, \r\n" + 
				"   (SELECT CAR_MNG_ID, tot_dist FROM (SELECT CAR_MNG_ID, tot_dist, ROW_NUMBER() over(PARTITION BY CAR_MNG_ID ORDER BY tot_dist desc ) AS row_idx FROM SERVICE) WHERE row_idx = 1) s,\r\n" + 
				"   (SELECT * FROM ESTI_JG_VAR e1 WHERE (SH_CODE, SEQ) IN (((SELECT  SH_CODE, MAX(seq) FROM ESTI_JG_VAR WHERE jg_2  IS NOT NULL GROUP BY SH_CODE)))) est,\r\n" + 
				"   (SELECT CAR_MNG_ID, sum(tot_amt) tot_amt FROM (SELECT  a.car_mng_id, b.tot_amt tot_amt FROM ACCIDENT a, SERVICE b, cont c \r\n" + 
				"   WHERE 1=1 AND a.car_mng_id=b.car_mng_id AND a.accid_id=b.accid_id AND b.tot_amt>0 AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd  AND b.serv_st NOT IN ('7','12')  \r\n" + 
				"	    UNION ALL SELECT  a.CAR_MNG_ID ,b.accid_serv_amt tot_amt FROM    cont a, car_etc b WHERE 1=1 AND a.car_gu='2' and a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND nvl(b.accid_serv_amt,0)>0 )GROUP BY car_mng_id ) serv2,\r\n" + 
				" 	(SELECT /*+ FIRST_ROWS */car_mng_id, count(0) as a_cnt from AMAZONCAR.ACCIDENT where accid_st='6' group by car_mng_id) accid,\r\n" + 
				"	(SELECT * FROM code WHERE c_st='0039') fuel_cd ,\r\n" + 
				"	(SELECT  RENT_L_CD , RENT_MNG_ID, SH_KM, SH_DAY_BAS_DT FROM fee_etc WHERE RENT_ST = 1) mm2,\r\n" + 
				"	(select /*+ RULE */ ai.car_no, am.car_amt_r_p, am.car_amt_r_n, am.car_amt_p_lo, am.car_amt_n_lo, am.auto, am.wheel_drive, am.option_b, \r\n" + 
				"			am.gaesu_rate_p, am.gaesu_yn, am.gaesu_real_amt_p, gaesu_n_yn, am.gaesu_rate_n, am.gaesu_real_amt_n\r\n" + 
				"	from ACTN_RAW@auction110 ar, ACTN_RAW_info@auction110 ai, actn_master@auction110 am \r\n" + 
				"	WHERE 1=1 AND ai.amz_is_yn='Y' AND ar.seq = ai.raw_seq AND ar.seq = am.raw_seq) ac\r\n" + 
				"WHERE 1=1\r\n" + 
				"	AND b.client_id NOT IN ('000228','000231')\r\n" + 
				"	AND a.car_st NOT IN ('2', '4', '5')\r\n" + 
				"	AND a.car_st <> '2'\r\n" + 
				"	AND a.car_gu = '0'\r\n" + 
				"	AND a.client_id = b.client_id\r\n" + 
				"	AND a.rent_mng_id = c.rent_mng_id\r\n" + 
				"	AND a.rent_l_cd = c.rent_l_cd\r\n" + 
				"	AND a.rent_mng_id = d.rent_mng_id\r\n" + 
				"	AND a.rent_l_cd = d.rent_l_cd\r\n" + 
				"	AND a.car_mng_id = f.car_mng_id(+)\r\n" + 
				"	AND a.rent_mng_id = h.rent_mng_id\r\n" + 
				"	AND a.rent_l_cd = h.rent_l_cd\r\n" + 
				"	AND h.car_id = i.car_id\r\n" + 
				"	AND h.car_seq = i.car_seq\r\n" + 
				"	AND i.car_comp_id = j.car_comp_id\r\n" + 
				"	AND i.car_cd = j.code\r\n" + 
				"	AND d.rent_mng_id = m.rent_mng_id\r\n" + 
				"	AND d.rent_l_cd = m.rent_l_cd\r\n" + 
				"	AND d.rent_st = m.rent_st\r\n" + 
				"	AND a.rent_mng_id = o.rent_mng_id(+)\r\n" + 
				"	AND a.rent_l_cd = o.rent_l_cd(+)\r\n" + 
				"	AND nvl(o.cls_st,'0') NOT IN ('4','5','7','10') \r\n" +
				"	AND a.rent_mng_id = y.rent_mng_id(+)\r\n" + 
				"	AND a.reg_dt = y.reg_dt(+)\r\n" + 
				"	AND d.rent_mng_id = mm.rent_mng_id\r\n" + 
				"	AND d.rent_l_cd = mm.rent_l_cd\r\n" + 
				"	AND d.rent_st = mm.rent_st\r\n" + 
				"	AND f.car_ext = ec.nm_cd(+)\r\n" + 
				"	AND f.car_mng_id = s.car_mng_id(+)\r\n" + 
				"	AND i.JG_CODE = est.SH_CODE(+)\r\n" + 
				"	AND f.CAR_MNG_ID = serv2.CAR_MNG_ID(+)\r\n" + 
				"	AND f.CAR_MNG_ID = accid.CAR_MNG_ID(+)\r\n" + 
				"	AND f.FUEL_KD = fuel_cd.nm_cd(+)\r\n" + 
				"	AND a.rent_l_cd = mm2.rent_l_cd(+)\r\n" + 
				"	AND a.rent_mng_id = mm2.rent_mng_id(+)	AND mm.bc_est_id=em.est_id \r\n" + 
				"	AND mm.bc_est_id=ee.est_id\r\n" + 
				"	AND i.jg_code=ej.sh_code AND ee.jg_b_dt=ej.reg_dt \r\n" + 
				"	AND ee.em_a_j=ec.a_j AND ec.a_a=substr(em.a_a,1,1)\r\n" + 
				"    AND f.car_no=  ac.car_no(+) \r\n" + 
				"    ";

		if (!start_dt.equals("")) {
			query += "AND a.RENT_DT >= " + start_dt;
		}
		if (!end_dt.equals("")) {
			query += "AND a.RENT_DT <= " + end_dt;
		}
		if (start_dt.equals("") && end_dt.equals("")) {

			// 현재 년월 구하기
			Calendar calendar = Calendar.getInstance();
			int curYear = calendar.get(Calendar.YEAR);
			int curMonth = calendar.get(Calendar.MONTH) + 1;
			String stringMonth = "";
			if (curMonth < 10) {
				stringMonth = "0" + String.valueOf(curMonth);
			} else {
				stringMonth = String.valueOf(curMonth);
			}
			String curYM = String.valueOf(curYear) + stringMonth;

			query += "AND a.RENT_DT LIKE '" + curYM + "%'";
		}

		query += "ORDER BY  DECODE(mm.rent_st,'1',nvl(d.RENT_DT, a.RENT_DT), mm2.SH_DAY_BAS_DT) DESC";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getInsideReq10]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	// 내부요청자료10_1 (20201104)
	public Vector getInsideReq10_1(double fw917, String sh_code, String seq) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT sh_code, seq, jg_opt_st, jg_opt_1, ROUND(NVL(aw+CASE WHEN ax<0 THEN 0 ELSE jg_opt_4*ax END,0),1) as V_T_BD\r\n"
				+ "  FROM\r\n" + "     (\r\n"
				+ "         SELECT sh_code, seq, jg_opt_st, jg_opt_1, jg_opt_2, jg_opt_3, jg_opt_4, jg_opt_5, jg_opt_6, jg_opt_7,\r\n"
				+ "           CASE WHEN ? < 36 THEN jg_opt_2 ELSE jg_opt_2*(1-(?-36)*0.0125) END as aw,\r\n"
				+ "	         CASE WHEN jg_opt_5 > 0 AND ? < (jg_opt_3-3) THEN 1-((jg_opt_3-3)-?)*0.5/jg_opt_5\r\n"
				+ "  	            WHEN jg_opt_5 > 0 AND ? > (jg_opt_3+3) THEN 1-(?-(jg_opt_3+3))*0.5/jg_opt_5\r\n"
				+ "    	          WHEN jg_opt_5 > 0 THEN 1\r\n" + "      	        ELSE 0 END as ax\r\n"
				+ "         FROM   ESTI_JG_OPT_VAR\r\n" + "      WHERE sh_code=? AND seq=?\r\n" + "        )";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setDouble(1, fw917);
			pstmt.setDouble(2, fw917);
			pstmt.setDouble(3, fw917);
			pstmt.setDouble(4, fw917);
			pstmt.setDouble(5, fw917);
			pstmt.setDouble(6, fw917);
			pstmt.setString(7, sh_code);
			pstmt.setString(8, seq);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getInsideReq10]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	// 내부요청자료10_2 (20201104)
	public Vector getInsideReq10_2(double gb917, String sh_code, String seq) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT sh_code, seq, jg_opt_st, jg_opt_1, ROUND(NVL(aw+CASE WHEN ax<0 THEN 0 ELSE jg_opt_4*ax END,0),1) as V_T_BD\r\n"
				+ "  FROM\r\n" + "     (\r\n"
				+ "         SELECT sh_code, seq, jg_opt_st, jg_opt_1, jg_opt_2, jg_opt_3, jg_opt_4, jg_opt_5, jg_opt_6, jg_opt_7,\r\n"
				+ "           CASE WHEN ? < 36 THEN jg_opt_2 ELSE jg_opt_2*(1-(?-36)*0.0125) END as aw,\r\n"
				+ "	         CASE WHEN jg_opt_5 > 0 AND ? < (jg_opt_3-3) THEN 1-((jg_opt_3-3)-?)*0.5/jg_opt_5\r\n"
				+ "  	            WHEN jg_opt_5 > 0 AND ? > (jg_opt_3+3) THEN 1-(?-(jg_opt_3+3))*0.5/jg_opt_5\r\n"
				+ "    	          WHEN jg_opt_5 > 0 THEN 1\r\n" + "      	        ELSE 0 END as ax\r\n"
				+ "         FROM   ESTI_JG_OPT_VAR\r\n" + "      WHERE sh_code=? AND seq=?\r\n" + "        )";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setDouble(1, gb917);
			pstmt.setDouble(2, gb917);
			pstmt.setDouble(3, gb917);
			pstmt.setDouble(4, gb917);
			pstmt.setDouble(5, gb917);
			pstmt.setDouble(6, gb917);
			pstmt.setString(7, sh_code);
			pstmt.setString(8, seq);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();

			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getInsideReq10]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}
	
	// 경매장 데이터10_3 (20201230)
	public Hashtable getInsideReq10_3(String car_mng_id) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query =" SELECT \r\n" + 
				"       DECODE(mm.rent_st,'1',nvl(d.RENT_DT, a.RENT_DT), mm2.SH_DAY_BAS_DT) AS ACTN_DT, --낙찰일\r\n" + 
				"	   '분당' ACTN_OFF_NM,\r\n" + 
				"       '9999' ACTN_CNT,--경매회차\r\n" + 
				"    	'' ACTN_NUM,--출품번호\r\n" + 
				"		f.CAR_NM ||' '|| i.CAR_NAME CAR_NAME, --차명\r\n" + 
				"		f.car_y_form,--연식\r\n" + 
				"		decode(i.AUTO_YN,'Y','자동','수동') auto_yn , --AUTO_YN|\r\n" + 
				"		fuel_cd.nm FUEL_KD,--FUEL_KD\r\n" + 
				"		nvl(f.dpm,0) DPM,--DPM \r\n" + 
				"		DECODE(mm.rent_st,'1',mm.SH_KM, mm2.SH_KM) AGREE_DIST,--AGREE_DIST\r\n" + 
				"		h.COLO COL,--COL|\r\n" + 
				"		decode(f.CAR_USE,'1','렌트','리스') car_use,--CAR_USE  \r\n" + 
				"		'법인' car_own,--CAR_OWN|\r\n" + 
				"		'' SKILL1,--SKILL1\r\n" + 
				"		'' SKILL2,--SKILL2 \r\n" + 
				"		'' SKILL3,--SKILL3\r\n" + 
				"		'' SKILL4,--SKILL4  \r\n" + 
				"		'' SKILL5,--SKILL5\r\n" + 
				"		'' SKILL6,--SKILL6\r\n" + 
				"		'' SKILL7,--SKILL7\r\n" + 
				"		'' SKILL8,--SKILL8\r\n" + 
				"		'' RATING1,--RATING1\r\n" + 
				"		'' RATING2,--RATING2\r\n" + 
				"		'' ST_PR,--ST_PR\r\n" + 
				"		decode(mm.BC_B_E2,0,0,mm.BC_B_E2/10000) NAK_PR,--NAK_PR\r\n" + 
				"		f.CAR_NM ||' '|| i.CAR_NAME CAR_NAME2,--CAR_NAME2\r\n" + 
				"		i.jg_code,--차종코드\r\n" + 
				"		f.init_reg_dt, --최초등록일 \r\n" + 
				"		nvl(h.opt,'') opt,-- 옵션\r\n" + 
				"		'' etc, --ETC\r\n" + 
				"		nvl(round((h.car_cs_amt + h.car_cv_amt + h.opt_cs_amt + h.opt_cv_amt + h.clr_cs_amt + h.clr_cv_amt )/10000),0) AS ACTN_CAR_AMT,--ACTN_CAR_AMT\r\n" + 
				"		nvl(f.TAKING_P,0) TAKING_P,--TAKING_P\r\n" + 
				"		sysdate,--REG_DTTM\r\n" + 
				"		'' FILE_SEQ,--FILE_SEQ\r\n" + 
				"		f.car_no --차량번호\r\n" + 
				"FROM cont a, client b, cont_etc c, fee d,  car_reg f, car_etc h, car_nm i, car_mng j, fee_etc mm,  \r\n" + 
				" 	(SELECT rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, sum(con_mon) con_mon, min(nvl(rent_start_dt,'')) \r\n" + 
				" 	 rent_start_dt, max(nvl(rent_end_dt,'')) rent_end_dt \r\n" + 
				"	FROM fee GROUP BY rent_mng_id, rent_l_cd ) m, \r\n" + 
				"	(SELECT * FROM code WHERE c_st='0039') fuel_cd ,\r\n" + 
				"	(SELECT  RENT_L_CD , RENT_MNG_ID, SH_KM, SH_DAY_BAS_DT FROM fee_etc WHERE RENT_ST = 1) mm2\r\n" + 
				"	WHERE 1=1\r\n" + 
				"	AND b.client_id NOT IN ('000228','000231')\r\n" + 
				"	AND a.car_st NOT IN ('2', '4', '5')\r\n" + 
				"	AND a.car_st <> '2'\r\n" + 
				"	AND a.car_gu = '0'\r\n" + 
				"	AND (a.use_yn IS NULL OR a.use_yn = 'Y')\r\n" + 
				"	AND a.client_id = b.client_id\r\n" + 
				"	AND a.rent_mng_id = c.rent_mng_id\r\n" + 
				"	AND a.rent_l_cd = c.rent_l_cd\r\n" + 
				"	AND a.rent_mng_id = d.rent_mng_id\r\n" + 
				"	AND a.rent_l_cd = d.rent_l_cd\r\n" + 
				"	AND a.car_mng_id = f.car_mng_id(+)\r\n" + 
				"	AND a.rent_mng_id = h.rent_mng_id\r\n" + 
				"	AND a.rent_l_cd = h.rent_l_cd\r\n" + 
				"	AND h.car_id = i.car_id\r\n" + 
				"	AND h.car_seq = i.car_seq\r\n" + 
				"	AND i.car_comp_id = j.car_comp_id\r\n" + 
				"	AND i.car_cd = j.code\r\n" + 
				"	AND d.rent_l_cd = m.rent_l_cd\r\n" + 
				"	AND d.rent_st = m.rent_st\r\n" + 
				"	AND d.rent_mng_id = mm.rent_mng_id\r\n" + 
				"	AND d.rent_l_cd = mm.rent_l_cd\r\n" + 
				"	AND d.rent_st = mm.rent_st\r\n" + 
				"	AND f.FUEL_KD = fuel_cd.nm_cd(+)\r\n" + 
				"	AND a.rent_l_cd = mm2.rent_l_cd(+)\r\n" + 
				"	AND a.rent_mng_id = mm2.rent_mng_id(+)\r\n"+
				"   AND a.car_mng_id = ?";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,  car_mng_id	);
			rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getInsideReq10_3]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return ht;
		}
	}
	

	// 내부요청자료11 (20201119)
	public Vector getInsideReq11(String start_dt, String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT \r\n" + 
				"        b.firm_nm ||''|| s.actn_wh actn_wh, --갱매장\r\n" + 
				"        uc.ACTN_CNT , --경매회차\r\n" + 
				"        uc.ACTN_NUM , --출품번호\r\n" + 
				"        uc.actn_dt,  --경매일자\r\n" + 
				"		a.CAR_NM, --차명\r\n" + 
				"        a.car_no, --차량번호\r\n" + 
				"        e.CAR_NAME,--모델\r\n" + 
				"        a.init_reg_dt, --최초등록일 \r\n" + 
				"        ROUND(((to_date(uc.actn_dt, 'YYYYMMDD')-to_date(a.INIT_REG_DT, 'YYYYMMDD'))/365*12),2) CAR_AGE,--차령\r\n" + 
				"        (to_date(uc.actn_dt, 'YYYYMMDD')-to_date(a.INIT_REG_DT, 'YYYYMMDD'))/365*12 CAR_AGE_ORG,--차령(총값)\r\n" + 
				"        s.KM ,--적용주행거리\r\n" + 
				"        e.jg_code,--차종코드\r\n" + 
				" 		(d.CAR_CS_AMT+d.CAR_CV_AMT) AS car_amt, -- 기존가\r\n" + 
				" 		nvl(d.opt,'') opt, -- 옵션\r\n" + 
				" 		(d.opt_cs_amt + d.opt_cv_amt) AS opt_amt, -- 옵션가격\r\n" + 
				" 		d.COLO,--색상\r\n" + 
				" 		d.IN_COL,--내장색상\r\n" + 
				" 		(d.clr_cs_amt + d.clr_cv_amt ) AS clr_amt,--색상가격\r\n" + 
				" 		(d.car_cs_amt + d.car_cv_amt + d.opt_cs_amt + d.opt_cv_amt + d.clr_cs_amt + d.clr_cv_amt ) AS car_fsv_amt,--소비자가 \r\n" + 
				" 		(d.CAR_fS_AMT + d.SD_CS_AMT -d.DC_CS_AMT)+(d.CAR_FV_AMT + d.SD_CV_AMT-d.DC_CV_AMT) AS CAR_SLL_AMT,--구입가\r\n" + 
				"		nvl(ac.car_amt_n_lo,0) car_amt_n_lo, --계약시점환산소비자가\r\n" + 
				" 		nvl(ac.car_amt_r_p,0) car_amt_r_p, --소비자가2\r\n" + 
				"		nvl(ac.car_amt_r_n,0) car_amt_r_n,  --계약시점환산소비자가2\r\n" + 
				"		ac.auto, --구동방식\r\n" + 
				"		ac.wheel_drive,  --변속기2\r\n" + 
				"		ac.option_b, --옵션2\r\n" + 
				"		ac.gaesu_rate_p, --구입시점개소세율 \r\n" + 
				"		ac.gaesu_yn, --구입시점 개소세 과세여부\r\n" + 
				"		ac.gaesu_real_amt_p, --구입시점 개소세 실감면액(소비자가2기준)\r\n" + 
				"		ac.gaesu_rate_n, --계약시점 개소세율\r\n" + 
				"		ac.gaesu_n_yn, --계약시점 개소세 과세여부\r\n" + 
				"		ac.gaesu_real_amt_n, --계약시점 개소세 실감면액(소비자2기준)\r\n" + 
				" 		uc.hp_pr,--희망가\r\n" + 
				" 		uc.o_s_amt as car_s_amt,--예상낙찰가\r\n" + 
				" 		to_char(ROUND((uc.o_s_amt /(d.car_cs_amt + d.car_cv_amt + d.opt_cs_amt + d.opt_cv_amt + d.clr_cs_amt + d.clr_cv_amt)* 100), 2),'FM90.00') car_s_per,    --소비자가대비 경매장 예상낙찰가\r\n" + 
				" 		serv2.tot_amt,--전체금액\r\n" + 
				"   	 	to_char(ROUND((NVL(serv2.TOT_AMT / decode((d.car_fs_amt + d.car_fv_amt), 0, NULL,(d.car_fs_amt + d.car_fv_amt)), 0)* 100), 2),'FM90.00') ACC_FSV_PER,--소비자가대비\r\n" + 
				"    	DECODE(NVL(serv2.tot_amt,0),0,0,ROUND((serv2.tot_amt*100)/(d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt),2)) se_per,--소비자가대비\r\n" + 
				"        su.mm_pr nak_pr, --낙찰가\r\n" + 
				"        decode(nvl(uc.nak_pr,0),0,0,ROUND((uc.nak_pr*100)/NULLIF((d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt),0),2)) hp_c_per, --소비자가대비 \r\n" + 
				"        decode(nvl(uc.nak_pr,0),0,0,ROUND((uc.nak_pr*100)/NULLIF((d.car_fs_amt+d.car_fv_amt+d.sd_cs_amt+d.sd_cv_amt-d.dc_cs_amt-d.dc_cv_amt),0),2)) hp_f_per, --구입가 대비\r\n" + 
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.o_s_amt,0),0,0,ROUND((uc.nak_pr*100)/uc.o_s_amt,2))) hp_s_per, --예상낙찰가 대비\r\n" + 
				"        (uc.nak_pr-uc.o_s_amt) hp_s_cha_amt, --편차금액\r\n" + 
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.o_s_amt,0),0,0,ROUND((uc.nak_pr-uc.o_s_amt)/(d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt)*100,2))) hp_c_cha_per, --편차%(예상)\r\n" + 
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.o_s_amt,0),0,0,ROUND((uc.nak_pr-uc.o_s_amt)/uc.o_s_amt*100,2))) abs_hp_s_cha_per, --편차%(소비자)\r\n" + 
				"        decode(nvl(uc.nak_pr,0),0,0,decode(nvl(uc.o_s_amt,0),0,0,ROUND(abs(uc.nak_pr-uc.o_s_amt)/(d.car_cs_amt+d.car_cv_amt+d.opt_cs_amt+d.opt_cv_amt+d.clr_cs_amt+d.clr_cv_amt)*100,2))) abs_hp_c_cha_per, \r\n" + 
				"        decode(su.migr_no,'수출말소','수출말소','자진말소수출','수출말소', '','미입력','이전등록') as migr_stat, --명의이전		 \r\n" + 
				"        uc.actn_jum,  --경매장평점\r\n" + 
				"        s.km, decode(sq.car_mng_id,'','무','유') accid_yn, --사고유무\r\n" + 
				"        su.sui_nm, --낙찰자\r\n" + 
				"        a.dpm, --배기량\r\n" + 
				"        f.nm as fuel_kd, --연료\r\n" + 
				"        a.car_y_form, --모델연도\r\n" + 
				"        decode(e.AUTO_YN, 'Y', 'A/T', 'M/T') AUTO_YN, --변속기\r\n" + 
				"        uc.actn_rsn, --평가요인\r\n" + 
				"        decode(nvl(ak.a_cnt,0),'0','','Y') as a_cnt_yn, --침수차여부\r\n" + 
				"        DECODE(a.DIST_CNG,'','','Y') AS dist_cng_yn,--계기판교체여부\r\n" + 
				"        cg.car_no as car_pre_no,--변경전 차량번호\r\n" + 
				"        uc.seq-1 AS offer_cnt,  --유찰횟수\r\n" + 
				"        trunc(to_number(to_date(c.rent_dt,'YYYYMMDD')-to_date(a.init_reg_dt,'YYYYMMDD'))/365*12,9) as fw917,\r\n" + 
				"        a.CAR_MNG_ID, e.car_id, e.car_seq \r\n" + 
				" FROM   CAR_REG a, APPRSL s, AUCTION uc, CLIENT b, CONT c,  fee g, fee_etc h,\r\n" + 
				"        CAR_ETC d, CAR_NM e, sui su,\r\n" + 
				"        (SELECT  RENT_L_CD , RENT_MNG_ID, SH_KM, SH_DAY_BAS_DT FROM fee_etc WHERE RENT_ST = 1) g2,\r\n" + 
				"        (SELECT car_mng_id, max(rent_start_dt) rent_start_dt, max(reg_dt) reg_dt FROM CONT WHERE car_st='2' GROUP BY car_mng_id) c2, \r\n" + 
				"	    (select car_mng_id, COUNT(0) accid_cnt from accident group by car_mng_id) sq, \r\n" + 
				"        (select car_mng_id, count(0) as a_cnt from accident where accid_st='6' group by car_mng_id) ak, \r\n" + 
				"        (select * from code where c_st='0039') f,\r\n" + 
				"        (SELECT car_mng_id, cha_dt, car_no FROM car_change a WHERE a.cha_seq = to_char(to_number((select max(b.cha_seq) from car_change b where a.car_mng_id = b.car_mng_id))-1)) cg,\r\n" + 
				"		(SELECT CAR_MNG_ID, sum(tot_amt) tot_amt FROM (SELECT  a.car_mng_id, b.tot_amt tot_amt FROM ACCIDENT a, SERVICE b, cont c\r\n" + 
				"	 	WHERE 1=1 AND a.car_mng_id=b.car_mng_id AND a.accid_id=b.accid_id AND b.tot_amt>0 AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd  AND b.serv_st NOT IN ('7','12')\r\n" + 
				"   		UNION ALL SELECT  a.CAR_MNG_ID ,b.accid_serv_amt tot_amt FROM    cont a, car_etc b WHERE 1=1 AND a.car_gu='2' and a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND nvl(b.accid_serv_amt,0)>0 )GROUP BY car_mng_id ) serv2,\r\n" + 
				"		(select /*+ RULE */ ai.car_no, am.car_amt_r_p, am.car_amt_r_n, am.car_amt_p_lo, am.car_amt_n_lo, am.auto, am.wheel_drive, am.option_b, \r\n" + 
				"				am.gaesu_rate_p, am.gaesu_yn, am.gaesu_real_amt_p, gaesu_n_yn, am.gaesu_rate_n, am.gaesu_real_amt_n\r\n" + 
				"    		from ACTN_RAW@auction110 ar, ACTN_RAW_info@auction110 ai, actn_master@auction110 am \r\n" + 
				"    		WHERE 1=1 AND ai.amz_is_yn='Y' AND ar.seq = ai.raw_seq AND ar.seq = am.raw_seq) ac\r\n" + 
				" WHERE  a.off_ls IN ('5','6')\r\n" + 
				"    AND a.car_mng_id=s.car_mng_id \r\n" + 
				"    AND a.car_mng_id=uc.car_mng_id AND uc.actn_st='4' \r\n" + 
				"    AND s.actn_id=b.client_id \r\n" + 
				"    AND a.car_mng_id=c.car_mng_id \r\n" + 
				"    AND c.car_st='2' \r\n" + 
				"    AND c.car_mng_id=c2.car_mng_id AND c.rent_start_dt=c2.rent_start_dt AND c.reg_dt=c2.reg_dt \r\n" + 
				"    AND c.rent_mng_id=d.rent_mng_id AND c.rent_l_cd=d.rent_l_cd \r\n" + 
				"    AND d.car_id=e.car_id AND d.car_seq=e.car_seq \r\n" + 
				"    AND a.car_mng_id=su.car_mng_id \r\n" + 
				"    AND c.RENT_L_CD = g.RENT_L_CD \r\n" + 
				"    AND c.RENT_MNG_ID = g.RENT_MNG_ID \r\n" + 
				"    AND g.rent_mng_id = h.rent_mng_id\r\n" + 
				"    AND g.rent_l_cd = h.rent_l_cd\r\n" + 
				"	AND g.rent_st = h.rent_st\r\n" + 
				"    and a.fuel_kd = f.nm_cd \r\n" + 
				"	AND c.rent_l_cd = g2.rent_l_cd(+)\r\n" + 
				"	AND c.rent_mng_id = g2.rent_mng_id(+)	\r\n" + 
				"    AND a.car_mng_id=sq.car_mng_id(+) \r\n" + 
				"    and a.car_mng_id = ak.car_mng_id(+) \r\n" + 
				"    AND a.car_mng_id = cg.car_mng_id(+) \r\n" + 
				"    AND a.CAR_MNG_ID = serv2.car_mng_id(+) \r\n" + 
				"    AND a.car_no=  ac.car_no(+) \r\n";
		
		if (!start_dt.equals("")) {
			query += "AND  uc.actn_dt >= " + start_dt;
		}
		if (!end_dt.equals("")) {
			query += "AND  uc.actn_dt <= " + end_dt;
		}
		if (start_dt.equals("") && end_dt.equals("")) {

			// 현재 년월 구하기
			Calendar calendar = Calendar.getInstance();
			int curYear = calendar.get(Calendar.YEAR);
			int curMonth = calendar.get(Calendar.MONTH) + 1;
			String stringMonth = "";
			if (curMonth < 10) {
				stringMonth = "0" + String.valueOf(curMonth);
			} else {
				stringMonth = String.valueOf(curMonth);
			}
			String curYM = String.valueOf(curYear) + stringMonth;

			query += "AND  uc.actn_dt LIKE '" + curYM + "%'";
		}

		query += "ORDER BY uc.actn_dt DESC";

		
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getInsideReq10]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}
		
	// 내부요청자료11_1 (20201119)
	public Hashtable getInsideReq11_1(String car_mng_id) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		query = "SELECT \r\n" + 
				"  em.est_ssn AS car_mng_id,\r\n" + 
				"  --추가\r\n" + 
				"  to_char(ROUND(ej.JG_1*100,2),'FM90.00') AS JG_1, --현시점 차령 24개월 잔가율 \r\n" + 
				"  to_char(ROUND(ee.JG_C_1*100,2),'FM90.00') AS JG_C_1, --0 개월 기준잔가\r\n" + 
				"  nvl(ej.JG_G_9,'0') AS JG_G_9,  --0개월잔가 적용방식 구분 0.조정율미적용 1.조정율적용\r\n" + 
				"  to_char(ROUND(nvl(ej.JG_G_10,'0'),3),'FM90.000') AS JG_G_10, --0개월 기준잔가 조정율\r\n" + 
				"  to_char(ROUND(ej.JG_4*100,2),'FM90.00') AS JG_4, --최저잔가율 조정 승수 (최대 0.4)\r\n" + 
				"  to_char(ec.SH_A_M_1*nvl(ej.jg_g_45,1),'FM900.00') AS SH_A_M_1, --재리스 현재 중고차 경기지수\r\n" + 
				"  decode(ej.JG_B,'1',ec.JG_C_72,'2',ec.JG_C_73,ec.JG_C_71) AS y3_km, --3년 표준주행거리(km)\r\n" + 
				"  ej.JG_14 AS JG_14, --초과 10,000km당 중고차가 조정율\r\n" + 
				"  to_char(ee.O_E*ee.O_R*ec.SH_A_M_1*nvl(ej.jg_g_45,1),'FM90.00') AS U, --차령,주행거리 반영 차종코드 잔가율\r\n" + 
				"  ee.o_e, ee.o_r, ec.sh_a_m_1*nvl(ej.jg_g_45,1) sh_a_m_1,\r\n" + 
				"  to_char(ROUND(nvl(ee.N_VAR1,0),5),'FM990.00000') AS N_VAR1, --현시점 수출효과\r\n" + 
				"  ej.JG_G_21 AS JG_G_21, --수출불가 사양\r\n" + 
				"  (ee.O_S*10000) AS O_S, --사고수리비 반영전 예상낙찰가\r\n" + 
				"  ee.ACCID_SIK_J, --사고수리비 반영전 예상낙찰가\r\n" + 
				"  ee.N_VAR2 AS N_VAR2, --재리스 종료시점 수출효과\r\n" + 
				"  em.b_agree_dist AS b_agree_dist, --표준약정주행거리\r\n" + 
				"  em.agree_dist AS agree_dist, --계약약정주행거리\r\n" + 
				"  em.b_o_13 AS b_o_13, --표준최대잔가\r\n" + 
				"  em.o_13 AS o_13, --조정최대잔가  \r\n" + 
				"  em.accid_serv_amt1 AS accid_serv_amt1, --1위 사고수리비\r\n" + 
				"  em.accid_serv_amt2 AS accid_serv_amt2, --2위 사고수리비\r\n" + 
				"  ee.FW917, ej.sh_code, ej.seq, --잔가 반영 색상 및 사양 연동처리용  \r\n" + 
				"  decode(ej.JG_2, '1', DECODE(i.DUTY_FREE_OPT, '0', 'Y', 'N'), ej.JG_2) AS JG_2 --일반승용LPG  \r\n" + 
				"FROM   (SELECT * FROM ESTIMATE WHERE  (est_id, EST_SSN)  in (SELECT max(est_id), EST_SSN  FROM estimate WHERE est_from='off_ls'  GROUP BY  EST_SSN)) em, \r\n" + 
				"	   esti_exam ee, car_nm i, esti_jg_var ej, esti_comm_var ec\r\n" + 
				"WHERE  em.est_from='off_ls'\r\n" + 
				"AND em.est_id=ee.est_id \r\n" + 
				"AND em.car_id=i.car_id AND em.car_seq=i.car_seq\r\n" + 
				"AND i.jg_code=ej.sh_code AND ee.jg_b_dt=ej.reg_dt \r\n" + 
				"AND ee.em_a_j=ec.a_j AND ec.a_a=substr(em.a_a,1,1) \r\n" +
				"AND em.est_ssn = ?";
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,  car_mng_id	);
			rs = pstmt.executeQuery();

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getInsideReq11_1]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return ht;
		}
	}
	
	// 경매장 데이터11_2 (20201124)
		public Hashtable getActionInfo(String car_no) {
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Hashtable ht = new Hashtable();
			String query = "";

			query = "select /*+ RULE */ am.car_amt_r_p, am.car_amt_r_n, am.car_amt_p_lo, am.car_amt_n_lo\r\n" + 
					"from ACTN_RAW@auction110 ar, ACTN_RAW_info@auction110 ai, actn_master@auction110 am\r\n" + 
					"WHERE 1=1\r\n" + 
					"AND ai.amz_is_yn='Y'\r\n" + 
					"AND ar.seq = ai.raw_seq\r\n" + 
					"AND ar.seq = am.raw_seq\r\n" + 
					"AND ar.car_no=?";
			try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString	(1,  car_no	);
				rs = pstmt.executeQuery();

				ResultSetMetaData rsmd = rs.getMetaData();
				while (rs.next()) {
					for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
						String columnName = rsmd.getColumnName(pos);
						ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
					}
				}
				rs.close();
				pstmt.close();

			} catch (SQLException e) {
				System.out.println("[AdminDatabase:getInsideReq11_1]" + e);
				e.printStackTrace();
			} finally {
				try {
					if (rs != null)
						rs.close();
					if (pstmt != null)
						pstmt.close();
				} catch (Exception ignore) {
				}
				closeConnection();
				return ht;
			}
		}
		
		// 경매장 데이터11_2 (20201124)
		public Hashtable getInsideReq11_2(String car_mng_id) {
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			Hashtable ht = new Hashtable();
			String query = "";

			query = " SELECT \r\n" + 
					"    	uc.actn_dt,--낙찰일\r\n" + 
					"    	--(b.firm_nm ||''|| s.actn_wh) actn_wh, --갱매장\r\n" + 
					"    	case\r\n" + 
					"		   when b.firm_nm ||''|| s.actn_wh like '%분당%' then '분당'\r\n" + 
					"		   when b.firm_nm ||''|| s.actn_wh like '%시화%' then '시화'\r\n" + 
					"		   when b.firm_nm ||''|| s.actn_wh like '%양산%' then '양산'\r\n" + 
					"		   when b.firm_nm ||''|| s.actn_wh like '%롯데%' then '롯데(KT)'\r\n" + 
					"		   when b.firm_nm ||''|| s.actn_wh like '%에이제이%' then 'AJ'\r\n" + 
					"		   else ''\r\n" + 
					"		END ACTN_OFF_NM,\r\n" + 
					"    	nvl(uc.ACTN_CNT,0) ACTN_CNT,--경매회차\r\n" + 
					"    	nvl(uc.ACTN_NUM,0) ACTN_NUM  ,--출품번호\r\n" + 
					"		a.CAR_NM ||' '|| e.CAR_NAME CAR_NAME, --차명\r\n" + 
					"		a.car_y_form,--연식\r\n" + 
					"		decode(e.AUTO_YN,'Y','자동','수동') auto_yn , --AUTO_YN|\r\n" + 
					"		f.nm FUEL_KD,--FUEL_KD\r\n" + 
					"		nvl(a.dpm,0) DPM,--DPM \r\n" + 
					"		nvl(s.KM,0) AGREE_DIST,--AGREE_DIST\r\n" + 
					"		d.COLO COL,--COL|\r\n" + 
					"		decode(a.CAR_USE,'1','렌트','리스') car_use,--CAR_USE  \r\n" + 
					"		'법인' car_own,--CAR_OWN|\r\n" + 
					"		'' SKILL1,--SKILL1\r\n" + 
					"		'' SKILL2,--SKILL2 \r\n" + 
					"		'' SKILL3,--SKILL3\r\n" + 
					"		'' SKILL4,--SKILL4  \r\n" + 
					"		'' SKILL5,--SKILL5\r\n" + 
					"		'' SKILL6,--SKILL6\r\n" + 
					"		'' SKILL7,--SKILL7\r\n" + 
					"		'' SKILL8,--SKILL8\r\n" + 
					"		substr(uc.ACTN_JUM,0,1) RATING1,--RATING1\r\n" + 
					"		substr(uc.ACTN_JUM,-1) RATING2,--RATING2\r\n" + 
					"		decode(uc.ST_PR,0,0,uc.ST_PR/10000) ST_PR,--ST_PR\r\n" + 
					"		decode(uc.NAK_PR,0,0,uc.NAK_PR/10000) NAK_PR,--NAK_PR\r\n" + 
					"		a.CAR_NM ||' '|| e.CAR_NAME CAR_NAME2,--CAR_NAME2\r\n" + 
					"		e.jg_code,--차종코드\r\n" + 
					"		a.init_reg_dt, --최초등록일 \r\n" + 
					"		nvl(d.opt,'') opt,-- 옵션\r\n" + 
					"		uc.actn_rsn etc, --ETC\r\n" + 
					"		nvl(round((d.car_cs_amt + d.car_cv_amt + d.opt_cs_amt + d.opt_cv_amt + d.clr_cs_amt + d.clr_cv_amt )/10000),0) AS ACTN_CAR_AMT,--ACTN_CAR_AMT\r\n" + 
					"		nvl(a.TAKING_P,0) TAKING_P,--TAKING_P\r\n" + 
					"		sysdate,--REG_DTTM\r\n" + 
					"		'' FILE_SEQ,--FILE_SEQ\r\n" + 
					"		a.car_no, --차량번호\r\n" + 
					"		decode(uc.HP_PR,0,0,uc.HP_PR/10000) HP_PR--HOPE_PR\r\n" + 
					" FROM   CAR_REG a, APPRSL s, AUCTION uc, CLIENT b, CONT c,  fee g, fee_etc h,\r\n" + 
					"        CAR_ETC d, CAR_NM e, sui su,\r\n" + 
					"        (SELECT car_mng_id, max(rent_start_dt) rent_start_dt, max(reg_dt) reg_dt FROM CONT WHERE car_st='2' GROUP BY car_mng_id) c2, \r\n" + 
					"        (select * from code where c_st='0039') f\r\n" + 
					" WHERE  a.off_ls IN ('5','6')\r\n" + 
					"    AND a.car_mng_id=s.car_mng_id \r\n" + 
					"    AND a.car_mng_id=uc.car_mng_id AND uc.actn_st='4' \r\n" + 
					"    AND s.actn_id=b.client_id \r\n" + 
					"    AND a.car_mng_id=c.car_mng_id \r\n" + 
					"    AND c.car_st='2' \r\n" + 
					"    AND c.car_mng_id=c2.car_mng_id AND c.rent_start_dt=c2.rent_start_dt AND c.reg_dt=c2.reg_dt \r\n" + 
					"    AND c.rent_mng_id=d.rent_mng_id AND c.rent_l_cd=d.rent_l_cd \r\n" + 
					"    AND d.car_id=e.car_id AND d.car_seq=e.car_seq \r\n" + 
					"    AND a.car_mng_id=su.car_mng_id \r\n" + 
					"    AND c.RENT_L_CD = g.RENT_L_CD \r\n" + 
					"    AND c.RENT_MNG_ID = g.RENT_MNG_ID \r\n" + 
					"    AND g.rent_mng_id = h.rent_mng_id\r\n" + 
					"	 AND g.rent_l_cd = h.rent_l_cd\r\n" + 
					"	 AND g.rent_st = h.rent_st\r\n" + 
					"    and a.fuel_kd = f.nm_cd \r\n" + 
					"    AND a.car_mng_id = ?";
			try {
				pstmt = conn.prepareStatement(query);
				pstmt.setString	(1,  car_mng_id	);
				rs = pstmt.executeQuery();

				ResultSetMetaData rsmd = rs.getMetaData();
				while (rs.next()) {
					for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
						String columnName = rsmd.getColumnName(pos);
						ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
					}
				}
				rs.close();
				pstmt.close();

			} catch (SQLException e) {
				System.out.println("[AdminDatabase:getInsideReq11_2]" + e);
				e.printStackTrace();
			} finally {
				try {
					if (rs != null)
						rs.close();
					if (pstmt != null)
						pstmt.close();
				} catch (Exception ignore) {
				}
				closeConnection();
				return ht;
			}
		}
		
	// 경매장 데이터  (20201124)
	public int getAucSeq() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";
		
		query = "SELECT max(seq) seq from ACTN_RAW@auction110";
		
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getAucSeq()]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}
	
	// 경매장 데이터  (20201124)
	public int getAucFileSeq() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";
		
		query = "SELECT max(file_seq)+1 file_seq from ACTN_RAW@auction110";
		
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getAucSeq()]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}
	
	// 경매장 데이터  (20201124)
	public int getAucCnt(AucBean auc) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";
		
		query = "SELECT count(*) cnt from ACTN_RAW_INFO@auction110 "+
				" WHERE CAR_NO = ? ";
		
		
		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString	(1,  auc.getCar_no());
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getAucSeq()]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}
	
	// 경매장 데이터  (20201124)
	public int getAucRelSeq() {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";
		
		query = " SELECT nvl(max(actn_num),0)+1 FROM  ACTN_RAW@auction110 "+
				" WHERE actn_off_nm ='분당' AND actn_cnt = '9999' AND d_gubun='fms_rel'";
		
		
		try {
			pstmt = conn.prepareStatement(query);
	    	rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();
    	
			if(rs.next())
			{				
				count = rs.getInt(1);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getAucRelSeq()]"+ e);
	  		e.printStackTrace();
		} finally {
			try{
                if(rs != null)		rs.close();
                if(pstmt != null)	pstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return count;
		}
	}
	
	
	// 경매장 데이터  (20201124)
		public int getAucNewSeq() {
			getConnection();
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int count = 0;
			String query = "";
			
			query = " SELECT nvl(max(actn_num),10000)+1 FROM  ACTN_RAW@auction110 "+
					" WHERE actn_off_nm ='분당' AND actn_cnt = '8888' AND d_gubun='fms_new'";
			
			
			try {
				pstmt = conn.prepareStatement(query);
		    	rs = pstmt.executeQuery();
	    		ResultSetMetaData rsmd = rs.getMetaData();
	    	
				if(rs.next())
				{				
					count = rs.getInt(1);
				}
				rs.close();
				pstmt.close();
			} catch (SQLException e) {
				System.out.println("[AdminDatabase:getAucNewSeq()]"+ e);
		  		e.printStackTrace();
			} finally {
				try{
	                if(rs != null)		rs.close();
	                if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return count;
			}
		}
	
	public int insertActnRaw(AucBean auc) {

		getConnection();

		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;

		String query = "";
		String seqQuery = "";
		String seqQuery2 = "";
		int count = 0;
		int seq = 0;
		int file_seq = 0;

		query = "	insert into ACTN_RAW@auction110 "+
				"   (	SEQ, NAK_DT, ACTN_OFF_NM, ACTN_CNT, ACTN_NUM,"+ //1
				"		CAR_NAME, CAR_Y_FORM, AUTO_YN, FUEL_KD, DPM," + 
				"		AGREE_DIST, COL, CAR_USE, CAR_OWN, RATING1,"  + //3
				"		RATING2, ST_PR, NAK_PR, CAR_NAME2,  " +
				"		INIT_REG_DT, OPT, ETC, ACTN_CAR_AMT, TAKING_P,"+ //5
				"		CAR_NO, HOPE_PR, FILE_SEQ, D_GUBUN) " + 
				"    values ( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,  ?,?,?,?,?, ?,?,?,? )  "; //

		seqQuery = "select nvl(max(seq),0 ) + 1  from ACTN_RAW@auction110";
		
		
		try {
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(seqQuery);
			rs = pstmt1.executeQuery();

			if (rs.next())
				seq = rs.getInt(1);
			rs.close();
			pstmt1.close();

			pstmt = conn.prepareStatement(query);

			pstmt.setInt(1, seq);
			pstmt.setDate(2,   new java.sql.Date(auc.getActn_dt().getTime()));
			pstmt.setString(3, auc.getActn_off_nm());
			pstmt.setInt(4, auc.getActn_cnt());
			pstmt.setInt(5, auc.getActn_num());
			
			pstmt.setString(6, auc.getCar_name());
			pstmt.setString(7, auc.getCar_y_form());
			pstmt.setString(8, auc.getAuto_yn());
			pstmt.setString(9, auc.getFuel_kd());
			pstmt.setInt(10, auc.getDpm());
			
			pstmt.setInt(11, auc.getAgree_dist());
			pstmt.setString(12, auc.getCol());
			pstmt.setString(13, auc.getCar_use());
			pstmt.setString(14, auc.getCar_own());
			pstmt.setString(15, auc.getRating1());
			
			pstmt.setString(16, auc.getRating2());
			pstmt.setInt(17, auc.getSt_pr());
			pstmt.setInt(18, auc.getNak_pr());
			pstmt.setString(19, auc.getCar_name2());
			
			pstmt.setDate(20, new java.sql.Date(auc.getInit_reg_dt().getTime()));
			pstmt.setString(21, auc.getOpt());
			pstmt.setString(22, auc.getEtc());
			pstmt.setInt(23, auc.getActn_car_amt());
			pstmt.setInt(24, auc.getTaking_p());
			
			pstmt.setString(25, auc.getCar_no());
			pstmt.setInt(26, auc.getHp_pr());
			pstmt.setInt(27, auc.getFile_seq());
			pstmt.setString(28, auc.getD_gubun());

			count = pstmt.executeUpdate();

			pstmt.close();
			conn.commit();

		} catch (Exception e) {
			count = 1;
			System.out.println("[AdminDatabase:insertActnRaw]" + e);
			System.out.println("[AdminDatabase:insertActnRaw]" + query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try {
				conn.setAutoCommit(true);
				if (rs != null)
					rs.close();
				if (pstmt1 != null)
					pstmt1.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return count;
		}
	}

	
	public int insertHist(int file_seq, String file_name, String file_type, int succ_cnt, int fail_cnt,int skip_cnt ) {

		getConnection();

		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;

		String query = "";
		int count = 0;
		int seq = 0;

		query = "	insert into ACTN_HIST@auction110 "+
				"   (	SEQ, FILE_NAME, FILE_TYPE, SUCC_CNT, FAIL_CNT,"+ //1
				"		SKIP_CNT ) " + 
				"    values ( ?,?,?,?,?,?)  "; //

		
		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setInt(1, file_seq);
			pstmt.setString(2, file_name);
			pstmt.setString(3, file_type);
			pstmt.setInt(4, succ_cnt);
			pstmt.setInt(5, fail_cnt);
			pstmt.setInt(6, skip_cnt);

			count = pstmt.executeUpdate();

			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			count = 1;
			System.out.println("[AdminDatabase:insertHist]" + e);
			System.out.println("[AdminDatabase:insertHist]" + query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try {
				conn.setAutoCommit(true);
				if (rs != null)
					rs.close();
				if (pstmt1 != null)
					pstmt1.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return count;
		}
	}
		
	/**
	 * 내부요청자료 12
	 */
	public Vector getInsideReq12(String start_dt, String end_dt, String fuel_kd) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "SELECT DISTINCT\r\n" + 
				"  A.RENT_L_CD AS rent_l_cd ,   	--계약번호\r\n" + 
				"  G.FIRM_NM AS firm_nm,        	--상호\r\n" + 
				"  e.CAR_NO AS car_no,      		--차량번호\r\n" + 
				"  e.car_num AS car_num,      	--차대번호\r\n" + 
				"  d.car_nm ||''|| c.CAR_NAME car_nm,   --차종 \r\n" + 
				"  i.nm AS fuel,					--연료    \r\n" + 
				"  e.INIT_REG_DT AS init_reg_dt,  --등록일\r\n" + 
				"  A.RENT_DT AS rent_dt,      	--계약일\r\n" + 
				"  DECODE(j.RENT_WAY,'1','일반식','2','맞춤식','3','기본식') retn_way,	--관리구분\r\n" + 
				"  DECODE(a.CAR_ST,'1','렌트','2','예비','3','리스','4','월렌트','5','업무대여') car_st, --용도구분\r\n" + 
				"  k.EST_AREA ||' '||k.COUNTY est_rea,	--차량이용지역\r\n" + 
				"  substr(nvl(g.HO_ADDR,g.O_ADDR),0,10) ||'...' addr , --고객주소\r\n" + 
				"  con_mon AS con_mon, --대여일\r\n" + 
				"  a.BUS_ID, --최초영업\r\n" + 
				"  a.BUS_ID2, --영업\r\n" + 
				"  a.MNG_ID  -- 관리\r\n" + 
				"  FROM cont a, car_etc b, car_nm c, car_mng d, car_reg e, USERS f, CLIENT g, CAR_PUR h,  \r\n" + 
				"  (select * from code where c_st='0039') i,\r\n" + 
				"  (SELECT RENT_MNG_ID, RENT_L_CD, RENT_WAY,  max(RENT_ST), sum(CON_MON) con_mon FROM fee\r\n" + 
				"  GROUP BY RENT_L_CD, RENT_MNG_ID, RENT_WAY ) j, cont_etc k\r\n" + 
				"  WHERE 1=1 \r\n" + 
				"  AND NVL(a.USE_YN,'N') = 'Y'    \r\n" + 
				"  AND a.RENT_MNG_ID=b.RENT_MNG_ID \r\n" + 
				"  AND a.RENT_L_CD=b.RENT_L_CD   \r\n" + 
				"  AND b.CAR_ID=c.CAR_ID \r\n" + 
				"  AND b.CAR_SEQ=c.CAR_SEQ  \r\n" + 
				"  AND c.CAR_COMP_ID=d.CAR_COMP_ID\r\n" + 
				"  AND c.CAR_CD=d.CODE   AND a.CAR_MNG_ID=e.CAR_MNG_ID   \r\n" + 
				"  AND a.BUS_ID = f.USER_ID          \r\n" + 
				"  AND a.CLIENT_ID = g.CLIENT_ID   \r\n" + 
				"  AND b.RENT_MNG_ID = h.RENT_MNG_ID \r\n" + 
				"  AND b.RENT_L_CD = h.RENT_L_CD  \r\n" + 
				"  AND e.FUEL_KD = i.NM_CD\r\n" + 
				"  AND a.RENT_L_CD = j.RENT_L_CD\r\n" + 
				"  AND a.RENT_MNG_ID = j.RENT_MNG_ID\r\n" + 
				"  AND a.RENT_L_CD = k.RENT_L_CD \r\n" + 
				"  AND a.RENT_MNG_ID = k.RENT_MNG_ID \r\n";

			if (!fuel_kd.equals("")) {
				query += " AND  e.FUEL_KD = '" + fuel_kd+"'";
			}
			if (!start_dt.equals("")) {
				query += " AND  e.INIT_REG_DT >= " + start_dt;
			}
			if (!end_dt.equals("")) {
				query += " AND  e.INIT_REG_DT <= " + end_dt;
			}
			if (start_dt.equals("") && end_dt.equals("")) {
	
				// 현재 년월 구하기
				Calendar calendar = Calendar.getInstance();
				int curYear = calendar.get(Calendar.YEAR);
				int curMonth = calendar.get(Calendar.MONTH) + 1;
				String stringMonth = "";
				if (curMonth < 10) {
					stringMonth = "0" + String.valueOf(curMonth);
				} else {
					stringMonth = String.valueOf(curMonth);
				}
				String curYM = String.valueOf(curYear) + stringMonth;
	
				query += " AND  e.INIT_REG_DT LIKE '" + curYM + "%'";
			}
	
			query += " ORDER BY e.INIT_REG_DT DESC";
		
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getInsideReq12]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}
	
	/**
	 * 결산관련자료10 - 계약개시대여료
	 */
	public Vector getSettleAccount_list10(String settle_year, String settle_st) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "SELECT d.ven_code, d.firm_nm, nvl(d.enp_no,substr(text_decrypt(d.ssn, 'pw'),1,6)) enp_no, NVL(g.car_no,'미등록') car_no, \r\n"
				+ "       a.rent_dt,\r\n" + "       DECODE(b.rent_st,'1','','연장') rent_st, \r\n"
				+ "       b.rent_start_dt, b.rent_end_dt, \r\n"
				+ "       case when b.rent_end_dt<h.rent_end_dt then h.rent_end_dt ELSE '' end im_end_dt, \r\n"
				+ "       f.cls_dt, \r\n"
				+ "       b.ifee_s_amt, b.IFEE_V_AMt, b.IFEE_S_amt+b.IFEE_v_amt ifee_amt, e.pay_amt, (b.IFEE_S_amt+b.IFEE_v_amt-e.pay_amt) dly_amt, b.IFEE_S_amt+b.IFEE_v_amt-(b.IFEE_S_amt+b.IFEE_v_amt-e.pay_amt) r_ifee_amt, "
				+ "       case when b.rent_end_dt<h.rent_end_dt then h.rent_end_dt ELSE b.rent_end_dt END e_dt, "
				+ "       substr(case when b.rent_end_dt<h.rent_end_dt then h.rent_end_dt ELSE b.rent_end_dt END,1,4) e_year "
				+ "FROM   CONT a, CLS_CONT f, FEE b, \r\n"
				+ "       ( SELECT rent_mng_id, rent_l_cd, MAX(to_number(rent_st)) rent_st FROM FEE GROUP BY rent_mng_id, rent_l_cd ) c, \r\n"
				+ "       CLIENT d, \r\n"
				+ "       ( select rent_mng_id, rent_l_cd, rent_st, sum(ext_pay_amt) pay_amt, MIN(ext_pay_dt) pay_dt \r\n"
				+ "         from   scd_ext \r\n" 
				+ "         where  ext_st='2' and ext_pay_amt>0  AND ext_pay_dt < '"+ (AddUtil.parseInt(settle_year) + 1) + "0101' \r\n"
				+ "         group by rent_mng_id, rent_l_cd, rent_st \r\n" 
				+ "       ) e,\r\n" 
				+ "       CAR_REG g,\r\n"
				+ "       (SELECT rent_mng_id, rent_l_cd, MAX(rent_end_dt) rent_end_dt FROM FEE_IM GROUP BY rent_mng_id, rent_l_cd) h \r\n"
				+ "WHERE  a.car_st<>'2'\r\n"
				+ "       AND a.rent_mng_id=f.rent_mng_id(+) AND a.rent_l_cd=f.rent_l_cd(+)\r\n"
				+ "       AND (NVL(a.use_yn,'Y')='Y' OR f.cls_dt >= '" + (AddUtil.parseInt(settle_year) + 1)+ "0101') \r\n" 
				+ "			 AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd\r\n"
				+ "			 AND b.rent_mng_id=c.rent_mng_id AND b.rent_l_cd=c.rent_l_cd AND b.rent_st=c.rent_st \r\n"
				+ "			 AND b.ifee_s_amt>0 \r\n" 
				+ "			 AND a.client_id=d.client_id \r\n"
				+ "			 and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd and b.rent_st=e.rent_st \r\n"
				+ "       AND a.car_mng_id=g.car_mng_id(+) \r\n"
				+ "       AND a.rent_mng_id=h.rent_mng_id(+) AND a.rent_l_cd=h.rent_l_cd(+)";

		if (settle_st.equals("client")) {
			// 거래처별
			query = " select enp_no, min(firm_nm) firm_nm, sum(ifee_s_amt) ifee_s_amt, sum(ifee_amt) ifee_amt, sum(pay_amt) pay_amt, sum(dly_amt) dly_amt, sum(r_ifee_amt) r_ifee_amt from ("
					+ query + ") group by enp_no order by enp_no ";
		} else {
			// 계약별
			query += " ORDER BY d.ven_code ";
		}

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list10]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료11 - 선납금
	 */
	public Vector getSettleAccount_list11(String settle_year, String settle_st) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "SELECT d.ven_code, d.firm_nm, nvl(d.enp_no,substr(text_decrypt(d.ssn, 'pw'),1,6)) enp_no, NVL(g.car_no,'미등록') car_no, \r\n"
				+ "       a.rent_dt,\r\n" + "       DECODE(b.rent_st,'1','','연장') rent_st, \r\n"
				+ "       b.rent_start_dt, b.rent_end_dt, \r\n"
				+ "       case when b.rent_end_dt<h.rent_end_dt then h.rent_end_dt ELSE '' end im_end_dt, \r\n"
				+ "       f.cls_dt, \r\n"
				+ "       b.pp_s_amt, b.pp_V_AMt, b.pp_S_amt+b.pp_v_amt pp_amt, e.pay_amt, (b.pp_S_amt+b.pp_v_amt-e.pay_amt) dly_amt, b.pp_S_amt+b.pp_v_amt-(b.pp_S_amt+b.pp_v_amt-e.pay_amt) r_pp_amt, "
				+ "       case when b.rent_end_dt<h.rent_end_dt then h.rent_end_dt ELSE b.rent_end_dt END e_dt, "
				+ "       substr(case when b.rent_end_dt<h.rent_end_dt then h.rent_end_dt ELSE b.rent_end_dt END,1,4) e_year "
				+ "FROM   CONT a, CLS_CONT f, FEE b, \r\n"
				+ "       ( SELECT rent_mng_id, rent_l_cd, MAX(to_number(rent_st)) rent_st FROM FEE GROUP BY rent_mng_id, rent_l_cd ) c, \r\n"
				+ "       CLIENT d, \r\n"
				+ "       ( select rent_mng_id, rent_l_cd, rent_st, sum(ext_pay_amt) pay_amt, MIN(ext_pay_dt) pay_dt \r\n"
				+ "         from   scd_ext \r\n" 
				+ "         where  ext_st='1' and ext_pay_amt>0  AND ext_pay_dt < '"+ (AddUtil.parseInt(settle_year) + 1) + "0101' \r\n"
				+ "         group by rent_mng_id, rent_l_cd, rent_st \r\n" 
				+ "       ) e,\r\n" 
				+ "       CAR_REG g,\r\n"
				+ "       (SELECT rent_mng_id, rent_l_cd, MAX(rent_end_dt) rent_end_dt FROM FEE_IM GROUP BY rent_mng_id, rent_l_cd) h \r\n"
				+ "WHERE  a.car_st<>'2'\r\n"
				+ "       AND a.rent_mng_id=f.rent_mng_id(+) AND a.rent_l_cd=f.rent_l_cd(+)\r\n"
				+ "       AND (NVL(a.use_yn,'Y')='Y' OR f.cls_dt >= '" + (AddUtil.parseInt(settle_year) + 1)+ "0101') \r\n" 
				+ "			 AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd\r\n"
				+ "			 AND b.rent_mng_id=c.rent_mng_id AND b.rent_l_cd=c.rent_l_cd AND b.rent_st=c.rent_st \r\n"
				+ "			 AND b.pp_s_amt>0 \r\n" 
				+ "			 AND a.client_id=d.client_id \r\n"
				+ "			 and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd and b.rent_st=e.rent_st \r\n"
				+ "       AND a.car_mng_id=g.car_mng_id(+) \r\n"
				+ "       AND a.rent_mng_id=h.rent_mng_id(+) AND a.rent_l_cd=h.rent_l_cd(+)";

		if (settle_st.equals("client")) {
			// 거래처별
			query = " select enp_no, min(firm_nm) firm_nm, sum(pp_s_amt) pp_s_amt, sum(pp_amt) pp_amt, sum(pay_amt) pay_amt, sum(dly_amt) dly_amt, sum(r_pp_amt) r_pp_amt from ("
					+ query + ") group by enp_no order by enp_no ";
		} else {
			// 계약별
			query += " ORDER BY d.ven_code ";
		}

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list11]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료12 - 선납금 년도별금액(선수대여료스케줄)
	 */
	public Vector getSettleAccount_list12(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "SELECT d.ven_code, d.firm_nm, nvl(d.enp_no,substr(text_decrypt(d.ssn, 'pw'),1,6)) enp_no, DECODE(a.car_st,'3','리스','렌트') car_st, NVL(g.car_no,'미등록') car_no, \r\n"
				+ "       a.rent_dt,\r\n" + "       DECODE(b.rent_st,'1','','연장') rent_st, \r\n"
				+ "       b.rent_start_dt, b.rent_end_dt, \r\n" + "       b.con_mon, \r\n"
				+ "       b.pp_s_amt, b.pp_V_AMt, b.pp_S_amt+b.pp_v_amt pp_amt,\r\n"
				+ "       NVL(i.amt_p1,0) amt_p1,\r\n" + "       NVL(i.amt_p2,0) amt_p2,\r\n"
				+ "       NVL(i.amt_p3,0) amt_p3,\r\n" + "       NVL(i.amt_p4,0) amt_p4,\r\n"
				+ "       NVL(i.amt_p5,0) amt_p5,\r\n"
				+ "       NVL(i.amt_p1,0)+NVL(i.amt_p2,0)+NVL(i.amt_p3,0)+NVL(i.amt_p4,0)+NVL(i.amt_p5,0) AS amtsum \r\n"
				+ "FROM   CONT a, CLS_CONT f, FEE b, \r\n" + "       CLIENT d, \r\n"
				+ "       ( select rent_mng_id, rent_l_cd, rent_st, sum(ext_pay_amt) pay_amt, MIN(ext_pay_dt) pay_dt \r\n"
				+ "         from   scd_ext \r\n" + "         where  ext_st='1' and ext_pay_amt>0  AND ext_pay_dt < '"
				+ (AddUtil.parseInt(settle_year) + 1) + "0101' \r\n"
				+ "         group by rent_mng_id, rent_l_cd, rent_St \r\n" + "       ) e,\r\n" + "       CAR_REG g,\r\n"
				+ "       (SELECT rent_mng_id, rent_l_cd, MAX(rent_end_dt) rent_end_dt FROM FEE_IM GROUP BY rent_mng_id, rent_l_cd) h, \r\n"
				+ "       (SELECT rent_mng_id, rent_l_cd, rent_st,\r\n"
				+ "               SUM(DECODE(substr(est_dt,1,4),'" + (AddUtil.parseInt(settle_year) + 1)
				+ "',est_amt)) amt_p1,  \r\n" + "               SUM(DECODE(substr(est_dt,1,4),'"
				+ (AddUtil.parseInt(settle_year) + 2) + "',est_amt)) amt_p2,\r\n"
				+ "               SUM(DECODE(substr(est_dt,1,4),'" + (AddUtil.parseInt(settle_year) + 3)
				+ "',est_amt)) amt_p3,\r\n" + "               SUM(DECODE(substr(est_dt,1,4),'"
				+ (AddUtil.parseInt(settle_year) + 4) + "',est_amt)) amt_p4,\r\n"
				+ "               SUM(DECODE(substr(est_dt,1,4),'" + (AddUtil.parseInt(settle_year) + 5) + "',est_amt,'"
				+ (AddUtil.parseInt(settle_year) + 6) + "',est_amt)) amt_p5\r\n"
				+ "        FROM scd_pp_cost WHERE  \r\n" + "        tm NOT IN ('0','99') AND gubun2='1' \r\n"
				+ "        GROUP BY rent_mng_id, rent_l_cd, rent_st\r\n" + "        ) i\r\n"
				+ "WHERE  a.car_st<>'2'\r\n"
				+ "       AND a.rent_mng_id=f.rent_mng_id(+) AND a.rent_l_cd=f.rent_l_cd(+)\r\n"
				+ "       AND (NVL(a.use_yn,'Y')='Y' OR f.cls_dt >= '" + (AddUtil.parseInt(settle_year) + 1)
				+ "0101') \r\n" + "		AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd\r\n"
				+ "		AND b.pp_s_amt>0 AND NVL(b.pp_chk,'1')<>'0' \r\n" + "		AND a.client_id=d.client_id \r\n"
				+ "		and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd AND b.rent_st=e.rent_st\r\n"
				+ "       AND a.car_mng_id=g.car_mng_id(+) \r\n"
				+ "       AND a.rent_mng_id=h.rent_mng_id(+) AND a.rent_l_cd=h.rent_l_cd(+)\r\n"
				+ "       AND (b.rent_end_dt > '" + (AddUtil.parseInt(settle_year))
				+ "1231' OR b.rent_start_dt IS NULL) \r\n"
				+ "       AND b.rent_mng_id=i.rent_mng_id(+) AND b.rent_l_cd=i.rent_l_cd(+) AND b.rent_st=i.rent_st(+)\r\n"
				+ "       AND NVL(i.amt_p1,0)+NVL(i.amt_p2,0)+NVL(i.amt_p3,0)+NVL(i.amt_p4,0)+NVL(i.amt_p5,0)>0\r\n"
				+ "ORDER BY DECODE(a.car_st,'3','리스','렌트'), CASE WHEN h.rent_l_cd IS NOT NULL AND b.rent_end_dt < h.rent_end_dt THEN h.rent_end_dt ELSE b.rent_end_dt END, b.rent_start_dt \r\n"
				+ "";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list12]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료13 - 개시대여료 년도별금액(선수대여료스케줄)
	 */
	public Vector getSettleAccount_list13(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "SELECT d.ven_code, d.firm_nm, nvl(d.enp_no,substr(text_decrypt(d.ssn, 'pw'),1,6)) enp_no, DECODE(a.car_st,'3','리스','렌트') car_st, NVL(g.car_no,'미등록') car_no, \r\n"
				+ "       a.rent_dt,\r\n" + "       DECODE(b.rent_st,'1','','연장') rent_st, \r\n"
				+ "       b.rent_start_dt, b.rent_end_dt, \r\n" + "       b.con_mon, \r\n"
				+ "       b.ifee_s_amt, b.ifee_V_AMt, b.ifee_S_amt+b.ifee_v_amt ifee_amt,\r\n"
				+ "       NVL(i.amt_p1,0) amt_p1,\r\n" + "       NVL(i.amt_p2,0) amt_p2,\r\n"
				+ "       NVL(i.amt_p3,0) amt_p3,\r\n" + "       NVL(i.amt_p4,0) amt_p4,\r\n"
				+ "       NVL(i.amt_p5,0) amt_p5,\r\n"
				+ "       NVL(i.amt_p1,0)+NVL(i.amt_p2,0)+NVL(i.amt_p3,0)+NVL(i.amt_p4,0)+NVL(i.amt_p5,0) AS amtsum \r\n"
				+ "FROM   CONT a, CLS_CONT f, FEE b, \r\n" + "       CLIENT d, \r\n"
				+ "       ( select rent_mng_id, rent_l_cd, rent_st, sum(ext_pay_amt) pay_amt, MIN(ext_pay_dt) pay_dt \r\n"
				+ "         from   scd_ext \r\n" + "         where  ext_st='2' and ext_pay_amt>0  AND ext_pay_dt < '"
				+ (AddUtil.parseInt(settle_year) + 1) + "0101' \r\n"
				+ "         group by rent_mng_id, rent_l_cd, rent_St \r\n" + "       ) e,\r\n" + "       CAR_REG g,\r\n"
				+ "       (SELECT rent_mng_id, rent_l_cd, MAX(rent_end_dt) rent_end_dt FROM FEE_IM GROUP BY rent_mng_id, rent_l_cd) h, \r\n"
				+ "       (SELECT rent_mng_id, rent_l_cd, rent_st,\r\n"
				+ "               SUM(DECODE(substr(est_dt,1,4),'" + (AddUtil.parseInt(settle_year) + 1)
				+ "',est_amt)) amt_p1,  \r\n" + "               SUM(DECODE(substr(est_dt,1,4),'"
				+ (AddUtil.parseInt(settle_year) + 2) + "',est_amt)) amt_p2,\r\n"
				+ "               SUM(DECODE(substr(est_dt,1,4),'" + (AddUtil.parseInt(settle_year) + 3)
				+ "',est_amt)) amt_p3,\r\n" + "               SUM(DECODE(substr(est_dt,1,4),'"
				+ (AddUtil.parseInt(settle_year) + 4) + "',est_amt)) amt_p4,\r\n"
				+ "               SUM(DECODE(substr(est_dt,1,4),'" + (AddUtil.parseInt(settle_year) + 5) + "',est_amt,'"
				+ (AddUtil.parseInt(settle_year) + 6) + "',est_amt)) amt_p5\r\n"
				+ "        FROM scd_pp_cost WHERE  \r\n" + "        tm NOT IN ('0','99') AND gubun2='2' \r\n"
				+ "        GROUP BY rent_mng_id, rent_l_cd, rent_st\r\n" + "        ) i\r\n"
				+ "WHERE  a.car_st<>'2'\r\n"
				+ "       AND a.rent_mng_id=f.rent_mng_id(+) AND a.rent_l_cd=f.rent_l_cd(+)\r\n"
				+ "       AND (NVL(a.use_yn,'Y')='Y' OR f.cls_dt >= '" + (AddUtil.parseInt(settle_year) + 1)
				+ "0101') \r\n" + "		AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd\r\n"
				+ "		AND b.ifee_s_amt>0  \r\n" + "		AND a.client_id=d.client_id \r\n"
				+ "		and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd AND b.rent_st=e.rent_st\r\n"
				+ "       AND a.car_mng_id=g.car_mng_id(+) \r\n"
				+ "       AND a.rent_mng_id=h.rent_mng_id(+) AND a.rent_l_cd=h.rent_l_cd(+)\r\n"
				+ "       AND (b.rent_end_dt > '" + (AddUtil.parseInt(settle_year))
				+ "1231' OR b.rent_start_dt IS NULL) \r\n"
				+ "       AND b.rent_mng_id=i.rent_mng_id(+) AND b.rent_l_cd=i.rent_l_cd(+) AND b.rent_st=i.rent_st(+)\r\n"
				+ "       AND NVL(i.amt_p1,0)+NVL(i.amt_p2,0)+NVL(i.amt_p3,0)+NVL(i.amt_p4,0)+NVL(i.amt_p5,0)>0\r\n"
				+ "ORDER BY DECODE(a.car_st,'3','리스','렌트'), CASE WHEN h.rent_l_cd IS NOT NULL AND b.rent_end_dt < h.rent_end_dt THEN h.rent_end_dt ELSE b.rent_end_dt END, b.rent_start_dt \r\n"
				+ "";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list13]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료14 - 대여료일시납 년도별금액(선수대여료스케줄)
	 */
	public Vector getSettleAccount_list14(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "SELECT d.ven_code, d.firm_nm, nvl(d.enp_no,substr(text_decrypt(d.ssn, 'pw'),1,6)) enp_no, DECODE(a.car_st,'3','리스','렌트') car_st, NVL(g.car_no,'미등록') car_no, \r\n"
				+ "       a.rent_dt,\r\n" + "       DECODE(b.rent_st,'1','','연장') rent_st, \r\n"
				+ "       b.rent_start_dt, b.rent_end_dt, \r\n" + "       b.con_mon, \r\n"
				+ "       e.est_dt, e.rest_amt, \r\n" + "       NVL(i.amt_p1,0) amt_p1,\r\n"
				+ "       NVL(i.amt_p2,0) amt_p2,\r\n" + "       NVL(i.amt_p3,0) amt_p3,\r\n"
				+ "       NVL(i.amt_p4,0) amt_p4,\r\n" + "       NVL(i.amt_p5,0) amt_p5,\r\n"
				+ "       NVL(i.amt_p1,0)+NVL(i.amt_p2,0)+NVL(i.amt_p3,0)+NVL(i.amt_p4,0)+NVL(i.amt_p5,0) AS amtsum \r\n"
				+ "FROM   CONT a, CLS_CONT f, FEE b, \r\n" + "       CLIENT d, \r\n"
				+ "       ( select rent_mng_id, rent_l_cd, rent_st, min(est_dt) est_dt, Max(rest_amt) rest_amt \r\n"
				+ "         from   scd_pp_cost \r\n" + "         where  tm='0' AND gubun2='3' AND est_dt < '"
				+ (AddUtil.parseInt(settle_year) + 1) + "0101' \r\n"
				+ "         group by rent_mng_id, rent_l_cd, rent_St \r\n" + "       ) e,\r\n" + "       CAR_REG g,\r\n"
				+ "       (SELECT rent_mng_id, rent_l_cd, MAX(rent_end_dt) rent_end_dt FROM FEE_IM GROUP BY rent_mng_id, rent_l_cd) h, \r\n"
				+ "       (SELECT rent_mng_id, rent_l_cd, rent_st,\r\n"
				+ "               SUM(DECODE(substr(est_dt,1,4),'" + (AddUtil.parseInt(settle_year) + 1)
				+ "',est_amt)) amt_p1,  \r\n" + "               SUM(DECODE(substr(est_dt,1,4),'"
				+ (AddUtil.parseInt(settle_year) + 2) + "',est_amt)) amt_p2,\r\n"
				+ "               SUM(DECODE(substr(est_dt,1,4),'" + (AddUtil.parseInt(settle_year) + 3)
				+ "',est_amt)) amt_p3,\r\n" + "               SUM(DECODE(substr(est_dt,1,4),'"
				+ (AddUtil.parseInt(settle_year) + 4) + "',est_amt)) amt_p4,\r\n"
				+ "               SUM(DECODE(substr(est_dt,1,4),'" + (AddUtil.parseInt(settle_year) + 5) + "',est_amt,'"
				+ (AddUtil.parseInt(settle_year) + 6) + "',est_amt)) amt_p5\r\n"
				+ "        FROM scd_pp_cost WHERE  \r\n" + "        tm NOT IN ('0','99') AND gubun2='3' \r\n"
				+ "        GROUP BY rent_mng_id, rent_l_cd, rent_st\r\n" + "        ) i\r\n"
				+ "WHERE  a.car_st<>'2'\r\n"
				+ "       AND a.rent_mng_id=f.rent_mng_id(+) AND a.rent_l_cd=f.rent_l_cd(+)\r\n"
				+ "       AND (NVL(a.use_yn,'Y')='Y' OR f.cls_dt >= '" + (AddUtil.parseInt(settle_year) + 1)
				+ "0101') \r\n" + "		AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd\r\n"
				+ "		AND a.client_id=d.client_id \r\n"
				+ "		and b.rent_mng_id=e.rent_mng_id and b.rent_l_cd=e.rent_l_cd AND b.rent_st=e.rent_st\r\n"
				+ "       AND a.car_mng_id=g.car_mng_id(+) \r\n"
				+ "       AND a.rent_mng_id=h.rent_mng_id(+) AND a.rent_l_cd=h.rent_l_cd(+)\r\n"
				+ "       AND b.rent_mng_id=i.rent_mng_id(+) AND b.rent_l_cd=i.rent_l_cd(+) AND b.rent_st=i.rent_st(+)\r\n"
				+ "       AND NVL(i.amt_p1,0)+NVL(i.amt_p2,0)+NVL(i.amt_p3,0)+NVL(i.amt_p4,0)+NVL(i.amt_p5,0)>0\r\n"
				+ "ORDER BY DECODE(a.car_st,'3','리스','렌트'), CASE WHEN h.rent_l_cd IS NOT NULL AND b.rent_end_dt < h.rent_end_dt THEN h.rent_end_dt ELSE b.rent_end_dt END, b.rent_start_dt \r\n"
				+ "";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list14]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료15 - 계산서발행리스트 - 선납금
	 */
	public Vector getSettleAccount_list15(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT tax_dt, recconame, tax_supply, tax_value, tax_bigo FROM TAX WHERE tax_dt LIKE '" + settle_year
				+ "%' AND (gubun='3' or tax_g='선납금') AND tax_st<>'C' ORDER BY tax_dt, recconame " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list15]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료16 - 결산년도 1월 대여료청구리스트 사용기간 년도별금액
	 */
	public Vector getSettleAccount_list16(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT car_no, car_st, rent_start_dt, rent_end_dt, \r\n"
				+ "       tax_out_dt, fee_s_amt, fee_v_amt, fee_amt,\r\n" + "       use_s_dt, use_e_dt, tday, \r\n"
				+ "       DECODE(SUBSTR(use_s_dt,1,4),'" + settle_year + "',0,   DECODE(SUBSTR(use_e_dt,1,4),'"
				+ (AddUtil.parseInt(settle_year) - 1) + "',tday,tday-mday)) day1,     \r\n"
				+ "       DECODE(SUBSTR(use_s_dt,1,4),'" + settle_year + "',tday,DECODE(SUBSTR(use_e_dt,1,4),'"
				+ (AddUtil.parseInt(settle_year) - 1) + "',0,mday)) day2,\r\n" + "       DECODE(SUBSTR(use_s_dt,1,4),'"
				+ settle_year + "',0,              \r\n" + "       DECODE(SIGN(mday),-1,fee_s_amt,0,fee_s_amt,\r\n"
				+ "                          1, fee_s_amt-\r\n"
				+ "                             TRUNC(fee_s_amt/tday*(DECODE(SUBSTR(use_s_dt,1,4),'" + settle_year
				+ "',tday,DECODE(SUBSTR(use_e_dt,1,4),'" + (AddUtil.parseInt(settle_year) - 1) + "',0,mday))))\r\n"
				+ "       )) amt1,\r\n" + "       DECODE(SUBSTR(use_s_dt,1,4),'" + settle_year + "',fee_s_amt,\r\n"
				+ "       DECODE(SIGN(mday),-1,0,0,0,\r\n"
				+ "                          1, TRUNC(fee_s_amt/tday*(DECODE(SUBSTR(use_s_dt,1,4),'" + settle_year
				+ "',tday,DECODE(SUBSTR(use_e_dt,1,4),'" + (AddUtil.parseInt(settle_year) - 1) + "',0,mday))))\r\n"
				+ "       )) amt2\r\n" + "FROM \r\n" + "(\r\n" + "SELECT  \r\n"
				+ "       c.car_no, DECODE(b.car_st,'3','리스','렌트') car_st,\r\n"
				+ "       b.rent_start_dt, b.rent_end_dt, \r\n"
				+ "       a.tax_out_dt, a.fee_s_amt, a.fee_v_amt, a.fee_s_amt+a.fee_v_amt fee_amt,\r\n"
				+ "       a.use_s_dt, a.use_e_dt,\r\n"
				+ "       TO_DATE(a.use_e_dt,'YYYYMMDD')-TO_DATE(a.use_s_dt,'YYYYMMDD')+1 AS tday,       \r\n"
				+ "       TO_DATE(a.use_e_dt,'YYYYMMDD')-TO_DATE('" + (AddUtil.parseInt(settle_year) - 1)
				+ "1231','YYYYMMDD') AS mday,\r\n" + "       TO_DATE(a.use_s_dt,'YYYYMMDD')-TO_DATE('"
				+ (AddUtil.parseInt(settle_year) - 1) + "1231','YYYYMMDD') AS mday2\r\n"
				+ "FROM   SCD_FEE a, CONT b, CAR_REG c, \r\n"
				+ "       (SELECT rent_mng_id, rent_l_cd, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt FROM FEE GROUP BY rent_mng_id, rent_l_cd) d\r\n"
				+ "WHERE  NVL(a.bill_yn,'Y')='Y'\r\n" + "       AND a.tax_out_dt LIKE '" + settle_year + "01%'\r\n"
				+ "       AND a.tm_st1='0'\r\n"
				+ "       AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd       \r\n"
				+ "       AND b.car_mng_id=c.car_mng_id\r\n"
				+ "       AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd  \r\n" + ")          \r\n"
				+ "ORDER BY car_st, tax_out_dt, use_s_dt, use_e_dt " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list16]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료17 - 결산익도 1월 대여료청구리스트 사용기간 년도별금액
	 */
	public Vector getSettleAccount_list17(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT car_no, car_st, rent_start_dt, rent_end_dt, \r\n"
				+ "       tax_out_dt, fee_s_amt, fee_v_amt, fee_amt,\r\n" + "       use_s_dt, use_e_dt, tday, \r\n"
				+ "       DECODE(SUBSTR(use_s_dt,1,4),'" + (AddUtil.parseInt(settle_year) + 1)
				+ "',0,   DECODE(SUBSTR(use_e_dt,1,4),'" + settle_year + "',tday,tday-mday)) day1, \r\n"
				+ "       DECODE(SUBSTR(use_s_dt,1,4),'" + (AddUtil.parseInt(settle_year) + 1)
				+ "',tday,DECODE(SUBSTR(use_e_dt,1,4),'" + settle_year + "',0,mday)) day2,\r\n"
				+ "       DECODE(SUBSTR(use_s_dt,1,4),'" + (AddUtil.parseInt(settle_year) + 1) + "',0, \r\n"
				+ "       DECODE(SIGN(mday),-1,fee_s_amt,0,fee_s_amt,\r\n"
				+ "                          1, fee_s_amt-\r\n"
				+ "                             TRUNC(fee_s_amt/tday*(DECODE(SUBSTR(use_s_dt,1,4),'"
				+ (AddUtil.parseInt(settle_year) + 1) + "',tday,DECODE(SUBSTR(use_e_dt,1,4),'" + settle_year
				+ "',0,mday))))\r\n" + "       )) amt1,\r\n" + "       DECODE(SUBSTR(use_s_dt,1,4),'"
				+ (AddUtil.parseInt(settle_year) + 1) + "',fee_s_amt,\r\n" + "       DECODE(SIGN(mday),-1,0,0,0,\r\n"
				+ "                          1, TRUNC(fee_s_amt/tday*(DECODE(SUBSTR(use_s_dt,1,4),'"
				+ (AddUtil.parseInt(settle_year) + 1) + "',tday,DECODE(SUBSTR(use_e_dt,1,4),'" + settle_year
				+ "',0,mday))))\r\n" + "       )) amt2\r\n" + "FROM \r\n" + "(\r\n" + "SELECT  \r\n"
				+ "       c.car_no, DECODE(b.car_st,'3','리스','렌트') car_st,\r\n"
				+ "       b.rent_start_dt, b.rent_end_dt, \r\n"
				+ "       a.tax_out_dt, a.fee_s_amt, a.fee_v_amt, a.fee_s_amt+a.fee_v_amt fee_amt,\r\n"
				+ "       a.use_s_dt, a.use_e_dt,\r\n"
				+ "       TO_DATE(a.use_e_dt,'YYYYMMDD')-TO_DATE(a.use_s_dt,'YYYYMMDD')+1 AS tday,       \r\n"
				+ "       TO_DATE(a.use_e_dt,'YYYYMMDD')-TO_DATE('" + settle_year + "1231','YYYYMMDD') AS mday,\r\n"
				+ "       TO_DATE(a.use_s_dt,'YYYYMMDD')-TO_DATE('" + settle_year + "1231','YYYYMMDD') AS mday2\r\n"
				+ "FROM   SCD_FEE a, CONT b, CAR_REG c, \r\n"
				+ "       (SELECT rent_mng_id, rent_l_cd, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt FROM FEE GROUP BY rent_mng_id, rent_l_cd) d\r\n"
				+ "WHERE  NVL(a.bill_yn,'Y')='Y'\r\n" + "       AND a.tax_out_dt LIKE '"
				+ (AddUtil.parseInt(settle_year) + 1) + "01%'\r\n" + "       AND a.tm_st1='0'\r\n"
				+ "       AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd       \r\n"
				+ "       AND b.car_mng_id=c.car_mng_id\r\n"
				+ "       AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd  \r\n" + ")          \r\n"
				+ "ORDER BY car_st, tax_out_dt, use_s_dt, use_e_dt " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list17]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}
	
	/**
	 * 결산관련자료17 - 결산익도 2월 대여료청구리스트 사용기간 년도별금액
	 */
	public Vector getSettleAccount_list17_2(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT car_no, car_st, rent_start_dt, rent_end_dt, \r\n"
				+ "       tax_out_dt, fee_s_amt, fee_v_amt, fee_amt,\r\n" + "       use_s_dt, use_e_dt, tday, \r\n"
				+ "       DECODE(SUBSTR(use_s_dt,1,4),'" + (AddUtil.parseInt(settle_year) + 1)
				+ "',0,   DECODE(SUBSTR(use_e_dt,1,4),'" + settle_year + "',tday,tday-mday)) day1, \r\n"
				+ "       DECODE(SUBSTR(use_s_dt,1,4),'" + (AddUtil.parseInt(settle_year) + 1)
				+ "',tday,DECODE(SUBSTR(use_e_dt,1,4),'" + settle_year + "',0,mday)) day2,\r\n"
				+ "       DECODE(SUBSTR(use_s_dt,1,4),'" + (AddUtil.parseInt(settle_year) + 1) + "',0, \r\n"
				+ "       DECODE(SIGN(mday),-1,fee_s_amt,0,fee_s_amt,\r\n"
				+ "                          1, fee_s_amt-\r\n"
				+ "                             TRUNC(fee_s_amt/tday*(DECODE(SUBSTR(use_s_dt,1,4),'"
				+ (AddUtil.parseInt(settle_year) + 1) + "',tday,DECODE(SUBSTR(use_e_dt,1,4),'" + settle_year
				+ "',0,mday))))\r\n" + "       )) amt1,\r\n" + "       DECODE(SUBSTR(use_s_dt,1,4),'"
				+ (AddUtil.parseInt(settle_year) + 1) + "',fee_s_amt,\r\n" + "       DECODE(SIGN(mday),-1,0,0,0,\r\n"
				+ "                          1, TRUNC(fee_s_amt/tday*(DECODE(SUBSTR(use_s_dt,1,4),'"
				+ (AddUtil.parseInt(settle_year) + 1) + "',tday,DECODE(SUBSTR(use_e_dt,1,4),'" + settle_year
				+ "',0,mday))))\r\n" + "       )) amt2\r\n" + "FROM \r\n" + "(\r\n" + "SELECT  \r\n"
				+ "       c.car_no, DECODE(b.car_st,'3','리스','렌트') car_st,\r\n"
				+ "       b.rent_start_dt, b.rent_end_dt, \r\n"
				+ "       a.tax_out_dt, a.fee_s_amt, a.fee_v_amt, a.fee_s_amt+a.fee_v_amt fee_amt,\r\n"
				+ "       a.use_s_dt, a.use_e_dt,\r\n"
				+ "       TO_DATE(a.use_e_dt,'YYYYMMDD')-TO_DATE(a.use_s_dt,'YYYYMMDD')+1 AS tday,       \r\n"
				+ "       TO_DATE(a.use_e_dt,'YYYYMMDD')-TO_DATE('" + settle_year + "1231','YYYYMMDD') AS mday,\r\n"
				+ "       TO_DATE(a.use_s_dt,'YYYYMMDD')-TO_DATE('" + settle_year + "1231','YYYYMMDD') AS mday2\r\n"
				+ "FROM   SCD_FEE a, CONT b, CAR_REG c, \r\n"
				+ "       (SELECT rent_mng_id, rent_l_cd, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt FROM FEE GROUP BY rent_mng_id, rent_l_cd) d\r\n"
				+ "WHERE  NVL(a.bill_yn,'Y')='Y'\r\n" + "       AND a.tax_out_dt LIKE '"
				+ (AddUtil.parseInt(settle_year) + 1) + "02%'\r\n" + "       AND a.tm_st1='0'\r\n"
				+ "       AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd       \r\n"
				+ "       AND b.car_mng_id=c.car_mng_id\r\n"
				+ "       AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd  \r\n" + ")          \r\n"
				+ "ORDER BY car_st, tax_out_dt, use_s_dt, use_e_dt " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list17_2]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}	

	/**
	 * 결산관련자료18 - 결산년도 대여료청구리스트 사용기간 2달이상
	 */
	public Vector getSettleAccount_list18(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.TAX_dt, a.recconame, b.*, TRUNC(b.item_supply/b.tday*b.mday) AS amt, b.item_supply-trunc(b.item_supply/b.tday*b.mday) AS amt2 \r\n"
				+ "FROM   tax a, \r\n" + "       (\r\n"
				+ "        SELECT item_id, rent_l_cd, MIN(item_dt1) item_dt1, MAX(item_dt2) item_dt2, SUM(item_supply) item_supply, \r\n"
				+ "               TO_DATE(MAX(item_dt2),'YYYYMMDD')-TO_DATE(MIN(item_dt1),'YYYYMMDD')+1 AS tday,\r\n"
				+ "               TO_DATE('" + settle_year
				+ "1231','YYYYMMDD')-TO_DATE(MIN(item_dt1),'YYYYMMDD')+1 AS mday,\r\n"
				+ "               TO_DATE(MAX(item_dt2),'YYYYMMDD')-TO_DATE('" + settle_year
				+ "1231','YYYYMMDD') AS mday2\r\n" + "        FROM   tax_item_list \r\n"
				+ "        group BY item_id, rent_l_cd\r\n"
				+ "        HAVING MONTHS_BETWEEN(TO_DATE(MAX(item_dt2),'YYYYMMDD'),TO_DATE(MIN(item_dt1),'YYYYMMDD')) > 2 \r\n"
				+ "        ) b \r\n" + "WHERE  a.tax_dt BETWEEN '" + settle_year + "0101' AND '" + settle_year
				+ "1231' AND b.item_dt1 >= '" + settle_year + "0101' AND b.item_dt2 > '" + settle_year + "1231' \r\n"
				+ "       AND a.gubun='1' AND a.tax_st<>'C'\r\n" + "       AND a.item_id=b.item_id\r\n"
				+ "ORDER BY b.item_dt1 " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list18]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료20 - 결산년도 1월1일이후 계약 만기리스트
	 */
	public Vector getSettleAccount_list20(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT c.car_no, e.rent_start_dt, e.rent_end_dt, b.cls_dt, \r\n"
				+ "       d.fee_s_amt, d.fee_v_amt, (d.fee_s_amt+d.fee_v_amt) fee_amt, \r\n"
				+ "       (d.pp_s_amt+d.ifee_s_amt) AS pp_s_amt, (d.pp_v_amt+d.ifee_v_amt) pp_v_amt, (d.pp_s_amt+d.pp_v_amt+d.ifee_s_amt+d.ifee_v_amt) pp_amt\r\n"
				+ "FROM   CONT a, CLS_CONT b, CAR_REG c, FEE d,\r\n"
				+ "       (SELECT rent_mng_id, rent_l_cd, min(rent_start_dt) rent_start_dt, max(rent_end_dt) rent_end_dt FROM FEE GROUP BY rent_mng_id, rent_l_cd) e\r\n"
				+ "WHERE   \r\n" + "       a.car_st NOT IN ('2','4')\r\n"
				+ "       AND a.rent_mng_id=b.rent_mng_id(+) AND a.rent_l_cd=b.rent_l_cd(+)\r\n"
				+ "       AND a.car_mng_id=c.car_mng_id \r\n"
				+ "       AND NVL(b.cls_st,'0') NOT IN ('4','5','7','10')\r\n"
				+ "       AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd AND d.RENT_ST='1' \r\n"
				+ "       AND a.rent_mng_id=e.rent_mng_id AND a.rent_l_cd=e.rent_l_cd\r\n"
				+ "       AND e.rent_end_dt > '" + settle_year + "0101'\r\n" + "       AND e.rent_start_dt < '"
				+ (AddUtil.parseInt(settle_year) + 1) + "0101' \r\n" + "ORDER BY e.rent_start_dt, a.rent_l_cd  " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list20]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료21 - 보증보험 가입현황
	 */
	public Vector getSettleAccount_list21(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT e.firm_nm, d.car_no, d.CAR_NM, b.GI_dt, b.gi_jijum, b.gi_no, b.gi_amt, b.gi_fee, b.gi_start_dt, b.gi_end_dt \r\n"
				+ "FROM   STAT_RENT_MONTH a, GUA_INS b, CONT c, car_reg d, client e\r\n" + "WHERE  a.save_dt='"
				+ settle_year
				+ "1231' AND a.rent_mng_id=b.rent_mng_id AND a.rent_l_cd=b.rent_l_cd AND a.fee_rent_st=b.rent_st AND b.gi_amt>0\r\n"
				+ "AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd\r\n"
				+ "AND c.car_mng_id=d.car_mng_id(+)\r\n" + "AND c.client_id=e.client_id\r\n" + "ORDER BY b.gi_dt "
				+ " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list21]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료22 - 대여&리스 연도별 수금계획
	 */
	public Vector getSettleAccount_list22(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT\r\n" + "               sum(DECODE(SUBSTR(seq,1,4),'" + (AddUtil.parseInt(settle_year) + 1)
				+ "',fee_s_amt)) amt_p1,\r\n" + "               sum(DECODE(SUBSTR(seq,1,4),'"
				+ (AddUtil.parseInt(settle_year) + 2) + "',fee_s_amt)) amt_p2,\r\n"
				+ "               sum(DECODE(SUBSTR(seq,1,4),'" + (AddUtil.parseInt(settle_year) + 3)
				+ "',fee_s_amt)) amt_p3,\r\n" + "               sum(CASE WHEN SUBSTR(seq,1,4)>='"
				+ (AddUtil.parseInt(settle_year) + 4) + "' THEN fee_s_amt ELSE 0 end) amt_p4\r\n"
				+ "FROM STAT_FEE_DEBT_GAP WHERE save_dt='" + settle_year + "1231' " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list22]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료23 - 연월차수당
	 */
	public Vector getSettleAccount_list23(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subquery  = ""; //매년 휴직자 - 결산시점
		if (settle_year.equals("2021") ) {
			subquery = " and b.user_id not in ('000058' , '000212') ";
		}
		
		query = " SELECT case when trunc(sysdate - to_date(b.enter_dt, 'yyyymmdd' ) ) > 365 then 1 else 0 end t_days,  \r\n"
				+ "       b.id , b.dept_nm, b.user_pos, b.user_nm, b.enter_dt, b.year , b.month, b.day , a.vacation,	\r\n"
				+ "       nvl( decode(TRUNC( MONTHS_BETWEEN( to_date('" + (AddUtil.parseInt(settle_year) + 1)
				+ "0101', 'yyyymmdd'), TO_DATE( b.enter_dt, 'YYYYMMDD' ))/ 12 ), 0, d.su,  c.su ), 0 ) su, 	\r\n"
				+ "		  b.r_month, b.r_day , round(a.vacation /12*b.r_month) r_vacation	\r\n"
				+ "FROM   (\r\n" + "        SELECT  a.user_id, a.end_dt, a.vacation, a.save_dt \r\n"
				+ "        FROM   VACATION_MAGAM a, \r\n"
				+ "               (SELECT user_id, max(save_dt) save_dt FROM VACATION_MAGAM GROUP BY user_id) b \r\n"
				+ "        WHERE  a.USER_ID = b.user_id AND a.SAVE_DT = b.save_dt\r\n" + "       ) a, 	\r\n"
				+ "       (\r\n" + "        SELECT TRUNC(MONTHS_BETWEEN(to_date('" + (AddUtil.parseInt(settle_year) + 1)
				+ "0101', 'yyyymmdd'), TO_DATE(enter_dt, 'YYYYMMDD'))/12) YEAR, 	\r\n"
				+ "               TRUNC(MONTHS_BETWEEN(to_date('" + (AddUtil.parseInt(settle_year) + 1)
				+ "0101', 'yyyymmdd'), TO_DATE(enter_dt, 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN(to_date('"
				+ (AddUtil.parseInt(settle_year) + 1)
				+ "0101', 'yyyymmdd'), TO_DATE(enter_dt, 'YYYYMMDD'))/12) * 12) MONTH, 	\r\n"
				+ "               TRUNC((MONTHS_BETWEEN(to_date('" + (AddUtil.parseInt(settle_year) + 1)
				+ "0101', 'yyyymmdd'),TO_DATE(enter_dt, 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN(to_date('"
				+ (AddUtil.parseInt(settle_year) + 1)
				+ "0101', 'yyyymmdd'), TO_DATE(enter_dt, 'YYYYMMDD')))) * 30.5) DAY,  	\r\n"
					+ "               TRUNC(MONTHS_BETWEEN(to_date('" + (AddUtil.parseInt(settle_year) )
				+ "1231', 'yyyymmdd'), TO_DATE(enter_dt, 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN(to_date('"
				+ (AddUtil.parseInt(settle_year) )
				+ "1231', 'yyyymmdd'), TO_DATE(enter_dt, 'YYYYMMDD'))/12) * 12) R_MONTH, 	\r\n"
				+ "               TRUNC((MONTHS_BETWEEN(to_date('" + (AddUtil.parseInt(settle_year) )
				+ "1231', 'yyyymmdd'),TO_DATE(enter_dt, 'YYYYMMDD')) - TRUNC(MONTHS_BETWEEN(to_date('"
				+ (AddUtil.parseInt(settle_year) )
				+ "1231', 'yyyymmdd'), TO_DATE(enter_dt, 'YYYYMMDD')))) * 30.5) R_DAY,  	\r\n"
				+ "               u.id, user_id, u.br_id, b.br_nm, u.dept_id, c.nm dept_nm,	\r\n"
				+ "               user_pos, user_nm,  enter_dt \r\n"
				+ "        FROM   users u, ( select c_st, code, nm_cd, nm from code where c_st = '0002' and code <> '0000'  ) c, branch b \r\n"
				+ "        WHERE  u.use_yn='Y'   	\r\n"
				+ "               AND u.user_pos IN ('팀장', '부장', '차장', '과장', '대리', '사원', '인턴사원')  and u.dept_id = c.code and u.br_id = b.br_id   \r\n"
				+ "       ) b, 	\r\n" + "       (\r\n"
				+ "        SELECT b.user_id, sum(decode(count, 'B1', 0.5, 'B2', 0.5, 1))AS su,  sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt 	\r\n"
				+ "	      FROM   sch_prv a, users b   \r\n"
				+ " 	      WHERE  start_year||start_mon||start_day BETWEEN to_char(to_date('"
				+ (AddUtil.parseInt(settle_year) + 1)
				+ "0101', 'yyyymmdd'),'yyyy')||substr(b.enter_dt,5,4) AND to_char(to_date('"
				+ (AddUtil.parseInt(settle_year) + 1) + "0101', 'yyyymmdd'),'yyyy')+1||substr(b.enter_dt,5,4)-1 \r\n"
				+ " 	             AND sch_chk ='3' AND to_number(to_char(to_date('"
				+ (AddUtil.parseInt(settle_year) + 1)
				+ "0101', 'yyyymmdd'),'mmdd')) >= to_number(substr(b.enter_dt,5,4)) AND nvl(a.gj_ck,'Y') = 'Y'  and b.user_id not in ( '000177')  \r\n"			
				+ "	             AND a.user_id(+) = b.user_id  GROUP BY b.user_id \r\n" + "	      UNION \r\n"
				+ "	      SELECT b.user_id, sum(decode(count, 'B1', 0.5, 'B2', 0.5, 1))AS su, \r\n"
				+ "	             sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt  \r\n"
				+ "        FROM   sch_prv a, users b 	\r\n"
				+ "        WHERE  start_year||start_mon||start_day BETWEEN (to_char(to_date('"
				+ (AddUtil.parseInt(settle_year) + 1) + "0101', 'yyyymmdd'),'yyyy')-1)||substr(b.enter_dt,5,4) AND '"
				+ settle_year + "1231'	\r\n" + "	             AND sch_chk ='3' \r\n"
				+ "               AND nvl(a.gj_ck,'Y') = 'Y' 	\r\n"
				+ "	             AND a.user_id(+) = b.user_id  GROUP BY b.user_id  \r\n" + "       ) c, \r\n"
				+ "       (\r\n"
				+ "        SELECT b.user_id, sum(decode(count, 'B1', 0.5, 'B2', 0.5, 1)) AS su, sum(decode(ov_yn, 'Y', 1, 0)) ov_cnt  \r\n"
				+ "        FROM   sch_prv a, users b 	\r\n"
				+ "        WHERE  start_year||start_mon||start_day BETWEEN b.enter_dt AND substr(b.enter_dt,0,4)+2||substr(b.enter_dt,5,4)-1  AND nvl(a.gj_ck,'Y') = 'Y' AND sch_chk ='3' AND a.user_id(+) = b.user_id \r\n"
				+ "        GROUP BY b.user_id \r\n" + "       ) d 	\r\n"
				+ "WHERE a. USER_ID = b.USER_ID AND b.user_id=c.user_id(+) AND b.user_id=d.user_id(+)  and b.user_id not in ('000177')  and b.dept_id IN ('0001','0002','0003','0005', '0007', '0008','0009','0010','0011', '0012', '0013','0014','0015','0016','0017','0018','0020') 	\r\n"
			    + subquery 
				+ "ORDER BY 5 asc , decode(sign(to_number(substr(b.enter_dt,5,2))-to_number(to_char(to_date('"
				+ (AddUtil.parseInt(settle_year) + 1) + "0101', 'yyyymmdd'),'mm'))),-1, to_number(to_char(to_date('"
				+ (AddUtil.parseInt(settle_year) + 1)
				+ "0101', 'yyyymmdd'),'mm'))-to_number(substr(b.enter_dt,5,2))-12, to_number(to_char(to_date('"
				+ (AddUtil.parseInt(settle_year) + 1)
				+ "0101', 'yyyymmdd'),'mm'))-to_number(substr(b.enter_dt,5,2)) ) desc, 	\r\n"
				+ "         substr(b.enter_dt,7,2) 	 " + " ";
		
	//	System.out.println("query="+query);

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list23]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * stat_cmp 파일 등록
	 */

	public int InsertStatCmp_Scan(String year, String mon, String gubun, String s_type, String s_chk) {

		getConnection();

		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;

		String query = "";
		String seqQuery = "";
		int count = 0;
		int seq = 0;

		query = "	insert into stat_cmp ( seq, c_yy,  c_mm,  gubun, user_id,  s_type, save_dt, s_chk) " + //
				"    values ( ?, ?, ?, ?, '999999', ?, ?, ?,  to_char(sysdate,'YYYYMMDD') , ? )  "; //

		seqQuery = "select nvl(max(seq),0 ) + 1  from stat_cmp where save_dt = to_char(sysdate,'YYYYMMDD') and gubun = '"
				+ gubun + "'";

		try {
			conn.setAutoCommit(false);

			pstmt1 = conn.prepareStatement(seqQuery);
			rs = pstmt1.executeQuery();

			if (rs.next())
				seq = rs.getInt(1);
			rs.close();
			pstmt1.close();

			pstmt = conn.prepareStatement(query);

			pstmt.setInt(1, seq);
			pstmt.setString(2, year);
			pstmt.setString(3, mon);
			pstmt.setString(4, gubun);
			pstmt.setString(5, s_type);
			pstmt.setString(6, s_chk);

			count = pstmt.executeUpdate();

			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			count = 1;
			System.out.println("[AdminDatabase:InsertStatCmp_Scan]" + e);
			System.out.println("[AdminDatabase:InsertStatCmp_Scan]" + query);
			e.printStackTrace();
			conn.rollback();
		} finally {
			try {
				conn.setAutoCommit(true);
				if (rs != null)
					rs.close();
				if (pstmt1 != null)
					pstmt1.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return count;
		}
	}

	/**
	 * 기타현황 - ARS파트너현황
	 */
	public Vector getSelectStatEtc_list1() {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.br_id, a.user_nm, "
				+ "        b.br_id as br_id_1, b.user_nm as user_nm_1, c.br_id as br_id_2, c.user_nm as user_nm_2, "
				+ "        d1.br_nm, d2.br_nm as br_nm_1, d3.br_nm as br_nm_2  \r\n"
				+ "FROM   users a, users b, users c, BRANCH d1, BRANCH d2, BRANCH d3 \r\n"
				+ "WHERE  a.use_yn='Y' AND a.loan_st='1' \r\n" + "       AND SUBSTR(a.ars_group,1,6)=b.user_id(+) \r\n"
				+ "       AND SUBSTR(a.ars_group,8,6)=c.user_id(+)\r\n"
				+ "       and a.br_id=d1.br_id and b.br_id=d2.br_id(+) and c.br_id=d3.br_id(+) "
				+ "ORDER BY decode(substr(a.br_id,1,1),'S',1,'I',2,'K',3,'B',4,'G',5,'D',6,'J',7), a.br_id, a.user_id  "
				+ " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEtc_list1]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 기타현황 - 년도별 알림톡발송현황 전송결과
	 */
	public Vector getSelectStatEtc_list_y1_code(String settle_year) {
		getConnection2();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " --알림톡,친구톡 전송결과\r\n"
				+ "SELECT DECODE(msg_type,1008,'알림톡','친구톡') msg_type, report_code, SUM(cnt) cnt FROM (\r\n";

		for (int i = 1; i <= 12; i++) {
			query += "SELECT msg_type, report_code, COUNT(0) cnt \r\n" + "FROM   ata_mmt_log_" + settle_year + ""
					+ AddUtil.addZero2(i) + " GROUP BY msg_type, report_code\r\n";
			if (i < 12) {
				query += "UNION ALL\r\n";
			}
		}

		query += ") GROUP BY msg_type, report_code \r\n" + "UNION ALL \r\n" + "--장문자 전송결과\r\n"
				+ "SELECT '장문자' msg_type, mt_report_code_ib AS report_code, SUM(cnt) cnt FROM (\r\n";

		for (int i = 1; i <= 12; i++) {
			query += "SELECT mt_report_code_ib, COUNT(0) cnt \r\n" + "FROM   em_mmt_log_" + settle_year + ""
					+ AddUtil.addZero2(i) + " GROUP BY mt_report_code_ib\r\n";
			if (i < 12) {
				query += "UNION ALL\r\n";
			}
		}

		query += ") GROUP BY mt_report_code_ib \r\n" + "UNION ALL\r\n" + "--단문자 전송결과\r\n"
				+ "SELECT '단문자' msg_type, mt_report_code_ib AS report_code, SUM(cnt) cnt FROM (\r\n";

		for (int i = 1; i <= 12; i++) {
			query += "SELECT mt_report_code_ib, COUNT(0) cnt \r\n" + "FROM   em_smt_log_" + settle_year + ""
					+ AddUtil.addZero2(i) + " GROUP BY mt_report_code_ib\r\n";
			if (i < 12) {
				query += "UNION ALL\r\n";
			}
		}

		query += ") GROUP BY mt_report_code_ib\r\n" + "ORDER BY 1,2 " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEtc_list_y1_code]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection2();
			return vt;
		}
	}

	/**
	 * 기타현황 - 년도별 알림톡발송현황
	 */
	public Vector getSelectStatEtc_list_y1(String settle_year) {
		getConnection2();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " --알림톡,친구톡 발송현황\r\n" + "\r\n"
				+ "SELECT DECODE(msg_type,1008,'알림톡','친구톡') msg_type, template_code, \r\n"
				+ "       sum(cnt) cnt, sum(y_cnt) y_cnt, sum(n_cnt) n_cnt,\r\n";

		for (int i = 1; i <= 12; i++) {
			query += " min(DECODE(ym,'" + settle_year + "" + AddUtil.addZero2(i) + "',cnt)) cnt_" + i
					+ ", min(DECODE(ym,'" + settle_year + "" + AddUtil.addZero2(i) + "',y_cnt)) y_cnt_" + i
					+ ", min(DECODE(ym,'" + settle_year + "" + AddUtil.addZero2(i) + "',n_cnt)) n_cnt_" + i + ",\r\n";
		}

		query += "       '' etc \r\n" + "FROM (\r\n";

		for (int i = 1; i <= 12; i++) {
			query += "SELECT msg_type, template_code, '" + settle_year + "" + AddUtil.addZero2(i)
					+ "' ym, COUNT(0) AS cnt, COUNT(DECODE(report_code,'1000',template_code)) y_cnt, COUNT(DECODE(report_code,'1000','',template_code)) n_cnt \r\n"
					+ "FROM   ata_mmt_log_" + settle_year + "" + AddUtil.addZero2(i)
					+ " GROUP BY msg_type, template_code\r\n";
			if (i < 12) {
				query += "UNION ALL\r\n";
			}
		}

		query += ") GROUP BY msg_type, template_code \r\n" + "\r\n" + "UNION all\r\n" + "\r\n" + "--알림톡 장문자\r\n"
				+ "\r\n" + "SELECT '장문자' msg_type, '' template_code,\r\n"
				+ "       sum(cnt) cnt, sum(y_cnt) y_cnt, sum(n_cnt) n_cnt,\r\n";

		for (int i = 1; i <= 12; i++) {
			query += " min(DECODE(ym,'" + settle_year + "" + AddUtil.addZero2(i) + "',cnt)) cnt_" + i
					+ ", min(DECODE(ym,'" + settle_year + "" + AddUtil.addZero2(i) + "',y_cnt)) y_cnt_" + i
					+ ", min(DECODE(ym,'" + settle_year + "" + AddUtil.addZero2(i) + "',n_cnt)) n_cnt_" + i + ",\r\n";
		}

		query += "       '' etc \r\n" + "FROM (\r\n";

		for (int i = 1; i <= 12; i++) {
			query += "SELECT  '" + settle_year + "" + AddUtil.addZero2(i)
					+ "' ym, COUNT(0) AS cnt, COUNT(DECODE(mt_report_code_ib,'1000',mt_pr)) y_cnt, COUNT(DECODE(mt_report_code_ib,'1000','',mt_pr)) n_cnt \r\n"
					+ "FROM   em_mmt_log_" + settle_year + "" + AddUtil.addZero2(i) + " \r\n";
			if (i < 12) {
				query += "UNION ALL\r\n";
			}
		}

		query += ")\r\n" + "\r\n" + "UNION ALL\r\n" + "\r\n" + "--알림톡 단문자\r\n" + "\r\n"
				+ "SELECT '단문자' msg_type, '' template_code,\r\n"
				+ "       sum(cnt) cnt, sum(y_cnt) y_cnt, sum(n_cnt) n_cnt,\r\n";

		for (int i = 1; i <= 12; i++) {
			query += " min(DECODE(ym,'" + settle_year + "" + AddUtil.addZero2(i) + "',cnt)) cnt_" + i
					+ ", min(DECODE(ym,'" + settle_year + "" + AddUtil.addZero2(i) + "',y_cnt)) y_cnt_" + i
					+ ", min(DECODE(ym,'" + settle_year + "" + AddUtil.addZero2(i) + "',n_cnt)) n_cnt_" + i + ",\r\n";
		}

		query += "       '' etc \r\n" + "FROM (\r\n";

		for (int i = 1; i <= 12; i++) {
			query += "SELECT  '" + settle_year + "" + AddUtil.addZero2(i)
					+ "' ym, COUNT(0) AS cnt, COUNT(DECODE(mt_report_code_ib,'1000',mt_pr)) y_cnt, COUNT(DECODE(mt_report_code_ib,'1000','',mt_pr)) n_cnt \r\n"
					+ "FROM   em_smt_log_" + settle_year + "" + AddUtil.addZero2(i) + " \r\n";
			if (i < 12) {
				query += "UNION ALL\r\n";
			}
		}

		query += ")  " + " order by 1,2 ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEtc_list_y1]\n" + e);
			System.out.println("[AdminDatabase:getSelectStatEtc_list_y1]\n" + query);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection2();
			return vt;
		}
	}

	/**
	 * 기타현황 - 년도별 알림톡발송현황
	 */
	public Vector getSelectStatEtc_list_y1_sublist(String content_code, String settle_year, String settle_month) {
		getConnection2();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "SELECT date_client_req, content, callback, recipient_num, date_mt_sent, decode(report_code,'1000','성공','실패') report_code_nm, report_code, etc_text_1, etc_text_2  \r\n"
				+ "FROM   ata_mmt_log_" + settle_year + "" + settle_month + "\r\n" + "WHERE  template_code='"
				+ content_code + "' \r\n" + "ORDER BY 1";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEtc_list_y1_sublist]\n" + e);
			System.out.println("[AdminDatabase:getSelectStatEtc_list_y1_sublist]\n" + query);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection2();
			return vt;
		}
	}

	/**
	 * 기타현황 - 년도별 스캔파일 현황
	 */
	public Vector getSelectStatEtc_list_y2(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "SELECT content_code, COUNT(0) cnt, \r\n";

		for (int i = 1; i <= 12; i++) {
			query += " COUNT(DECODE(TO_CHAR(reg_date,'MM'),'" + AddUtil.addZero2(i) + "',content_code)) cnt_" + i
					+ ", \r\n";
		}

		query += "       '' etc \r\n" + "FROM   ACAR_ATTACH_FILE \r\n" + "where  TO_CHAR(reg_date,'YYYY')='"
				+ settle_year + "' AND isdeleted='N' \r\n" + "GROUP BY content_code\r\n" + "order BY 1";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEtc_list_y2]\n" + e);
			System.out.println("[AdminDatabase:getSelectStatEtc_list_y2]\n" + query);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 기타현황 - 년도별 스캔파일 현황
	 */
	public Vector getSelectStatEtc_list_y2_sublist(String content_code, String settle_year, String settle_month) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "SELECT b.user_nm, a.* \r\n" + "FROM   ACAR_ATTACH_FILE a, users b \r\n" + "where  a.content_code='"
				+ content_code + "' AND TO_CHAR(a.reg_date,'YYYYMM')='" + settle_year + "" + settle_month
				+ "' AND a.isdeleted='N' \r\n" + "       AND a.reg_userseq=b.user_id\r\n" + "ORDER BY a.reg_date";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEtc_list_y2_sublist]\n" + e);
			System.out.println("[AdminDatabase:getSelectStatEtc_list_y2_sublist]\n" + query);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 결산관련자료20 - 계약현황
	 */
	public Vector getSettleAccount_list24(String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.rent_l_cd, b.car_no, DECODE(a.car_st,'1','렌트','3','리스','4','월렌트','5','업무대여') car_st, \r\n"
				+ "       c.firm_nm, nvl(c.enp_no,substr(text_decrypt(c.ssn, 'pw'),1,6)) enp_no, a.grt_amt_s, a.fee_s_amt, \r\n"
				+ "       d.rent_start_dt, CASE WHEN d.rent_end_dt < e.rent_end_dt THEN e.rent_end_dt ELSE d.rent_end_dt END rent_end_dt    \r\n"
				+ "FROM   stat_rent_month a, car_reg b, client c, fee d, \r\n"
				+ "       (SELECT rent_mng_id, rent_l_cd, rent_st, max(rent_end_dt) rent_end_dt FROM fee_im GROUP BY rent_mng_id, rent_l_cd, rent_st) e\r\n"
				+ "WHERE  a.save_dt='" + settle_year
				+ "1231' AND a.car_st <>'2' AND a.car_mng_id=b.car_mng_id(+) AND a.client_id=c.client_id \r\n"
				+ "AND a.rent_l_cd=d.rent_l_cd AND a.fee_rent_st=d.rent_st  \r\n"
				+ "AND a.rent_l_cd=e.rent_l_cd(+) AND a.fee_rent_st=e.rent_st(+)\r\n"
				+ "ORDER BY DECODE(a.car_st,'1','렌트','3','리스','4','월렌트','5','업무대여'), CASE WHEN d.rent_end_dt < e.rent_end_dt THEN e.rent_end_dt ELSE d.rent_end_dt END  "
				+ " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list24]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	public String call_sp_rent_cont_copy(String rent_mng_id, String rent_l_cd, String copy_cnt) {
		getConnection();
		String sResult = "";
		CallableStatement cstmt = null;
		String query = "{CALL P_RENT_CONT_COPY (?,?,?)}";
		try {
			cstmt = conn.prepareCall(query);
			cstmt.setString(1, rent_mng_id);
			cstmt.setString(2, rent_l_cd);
			cstmt.setString(3, copy_cnt);
			cstmt.execute();
			cstmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_rent_cont_copy]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (cstmt != null)
					cstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return sResult;
		}
	}

	/**
	 * 외부요청자료 11
	 */
	public Vector getOutsideReq11(String bank_cd) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select " + " a.lend_dt, a.allot_st, b.firm_nm, c.car_no, c.car_nm, c.car_num, "
				+ " decode(b.client_st,'1','법인','2','개인','개인사업자') client_st, " + " b.bus_cdt, b.bus_itm, " +
				// " a.cnt, "+
				" a.tot_amt, " + " a.jan_fee_amt, " + " a.fee_amt, a.con_mon, a.rent_start_dt, a.rent_end_dt "
				+ " from " + " ( " +
				// " select "+
				// " client_id, rent_l_cd, car_mng_id, count(0) cnt, min(con_mon) con_mon,
				// min(allot_st) allot_st, sum(tot_amt) tot_amt, sum(jan_fee_amt) jan_fee_amt,
				// sum(fee_amt) fee_amt "+
				// " from "+
				// " ( "+
				"      select "
				+ "           a.client_id, a.rent_l_cd, a.car_mng_id, c.con_mon, c.rent_start_dt, c.rent_end_dt, b.lend_dt, decode((nvl(sb1.alt_prn,0)+nvl(sb2.alt_prn,0)),0,'대출완료','대출상환중') allot_st, "
				+ "           decode(c.tot_amt,0,pp_amt,c.tot_amt) tot_amt, decode(f.rent_l_cd,'',c.tot_amt,nvl(e.jan_fee_amt,0)) jan_fee_amt, (d.fee_s_amt+d.fee_v_amt) fee_amt "
				+ "      from cont a, allot b, "
				+ "           (select rent_l_cd, max(to_number(rent_st)) rent_st, sum(con_mon) con_mon, MIN(rent_start_dt) rent_start_dt, MAX(rent_end_dt) rent_end_dt, sum((fee_s_amt+fee_v_amt)*con_mon) tot_amt, sum(pp_s_amt+pp_v_amt) pp_amt from fee group by rent_l_cd) c, "
				+ "           fee d, "
				+ "           (select rent_l_cd, count(0), sum(fee_s_amt+fee_v_amt) jan_fee_amt from scd_fee where nvl(bill_yn,'Y')='Y'  and tm_st2<>'4' and rc_yn='0' and fee_s_amt>0 group by rent_l_cd) e, "
				+ "           (select rent_l_cd, max(fee_est_dt) fee_est_dt from scd_fee where fee_s_amt>0  and tm_st2<>'4' group by rent_l_cd) f, "
				+ "           (SELECT lend_id, rtn_seq, SUM(alt_prn_amt) alt_prn FROM scd_bank WHERE pay_dt IS NULL GROUP BY lend_id, rtn_seq) sb1, "
				+ "           (SELECT car_mng_id, SUM(alt_prn) alt_prn FROM scd_alt_case WHERE pay_dt IS NULL GROUP BY car_mng_id) sb2  "
				+ "      where " 
				+ "           a.use_yn='Y' and a.car_st<>'2' "
				+ "           and a.rent_l_cd=b.rent_l_cd and b.cpt_cd='" + bank_cd + "' "
				+ "           and a.rent_l_cd=c.rent_l_cd "
				+ "           and c.rent_l_cd=d.rent_l_cd and c.rent_st=d.rent_st "
				+ "           and a.rent_l_cd=e.rent_l_cd(+) " 
				+ "           and a.rent_l_cd=f.rent_l_cd(+) "
				+ "           and b.lend_id=sb1.lend_id(+) and b.rtn_seq=sb1.rtn_seq(+) "
				+ "           and a.car_mng_id=sb2.car_mng_id(+) " +
				// " ) "+
				// " group by client_id, rent_l_cd, car_mng_id "+
				" ) a, client b, car_reg c " + " where a.client_id=b.client_id and a.car_mng_id=c.car_mng_id "
				+ " order by 1, 2 " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getOutsideReq11]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 거래처연체현황
	 */
	public Vector getClientDlyStat(String gubun2, String gubun3, String s_kd, String t_wd ) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.rent_mng_id, a.rent_l_cd, c.rent_dt, \r\n" + 
				"       DECODE(a.fee_rent_st,'1',DECODE(a.car_gu,'1','신차','0','재리스','2','중고차','3','월렌트'),'연장') rent_st, \r\n" + 
				"       decode(c.bus_st, '1','인터넷','2','영업사원','3','업체소개','4','카달로그','5','전화상담','6','기존업체','7','에이젼트','8','모바일') bus_st,\r\n" + 
				"       DECODE(f.pur_bus_st,'1','자체영업','2','영업사원영업','4','에이전트') pur_bus_st,\r\n" + 
				"       g.car_no, g.car_nm,\r\n" + 
				"       decode(b.client_st,'1','법인','2','개인','개인사업자') client_st,\r\n" + 
				"       b.firm_nm, b.bus_cdt, b.bus_itm,         \r\n" + 
				"       d.credit_r_per, d.grt_amt_s, (d.pp_s_amt+d.pp_v_amt) pp_amt, (d.ifee_s_amt+d.ifee_v_amt) ifee_amt, h.gi_amt, \r\n" + 
				"       a.fee_dly_cnt, a.fee_dly_amt,\r\n" + 
				"       e.user_nm \r\n" + 
				"FROM   stat_rent_month a, client b, cont c, fee d, users e, car_pur f, car_reg g, gua_ins h \r\n" + 
				"WHERE  a.save_dt=replace('"+gubun2+"','-','') \r\n" + 
				"AND a.CLIENT_ID=b.client_id  \r\n" + 
				"AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd\r\n" + 
				"AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd AND a.fee_rent_st=d.rent_st\r\n" + 
				"AND c.bus_id2=e.user_id  \r\n" + 
				"AND a.rent_mng_id=f.rent_mng_id AND a.rent_l_cd=f.rent_l_cd\r\n" + 
				"AND c.car_mng_id=g.car_mng_id \r\n" + 
				"AND a.rent_mng_id=h.rent_mng_id(+) AND a.rent_l_cd=h.rent_l_cd(+) AND a.fee_rent_st=h.rent_st(+)\r\n" + 
				" ";
		
		
		if(gubun3.equals("1")) {
			query += "AND a.fee_dly_cnt=1 ";
		}		
		if(gubun3.equals("2")) {
			query += "AND a.fee_dly_cnt=2 ";
		}	
		if(gubun3.equals("3")) {
			query += "AND a.fee_dly_cnt>2 ";
		}	
		
		String what = "";

		if(s_kd.equals("1"))	what = "b.firm_nm";
		if(s_kd.equals("2"))	what = "b.bus_cdt||b.bus_itm";	
		if(s_kd.equals("3"))	what = "e.user_nm";		
		if(s_kd.equals("4"))	what = "g.car_nm";	
		
		if(!what.equals("") && !t_wd.equals("")){			
			query += " and "+what+" like '%"+t_wd+"%' ";
		}
		
		query += " order by a.fee_dly_cnt ";
		
		

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getClientDlyStat]\n" + e);
			System.out.println("[AdminDatabase:getClientDlyStat]\n" + query);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	/**
	 * 월마감-계약현황
	 */
	public Vector getSelectStatEndContFeeListDB(String save_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT NVL(d.car_no,'미등록') car_no, NVL(d.car_nm,h.car_nm) car_nm, d.init_reg_dt,\r\n" + 
				"       DECODE(a.car_use,'1','영업용','2','자가용') car_use,\r\n" + 
				"       DECODE(a.fee_rent_st,'1',DECODE(a.car_gu,'1','신차','0','재리스','2','중고차','3','월렌트'),'연장') rent_st,\r\n" + 
				"       DECODE(a.car_st,'1','렌트','2','보유차','3','리스','4','월렌트','5','업무대여') car_st,   \r\n" + 
				"       e.firm_nm,\r\n" + 
				"       a.grt_amt_s AS d_grt_amt, --보증금 \r\n" + 
				"       b.pp_s_amt, --선납금 \r\n" + 
				"       b.ifee_s_amt, --개시대여료 \r\n" + 
				"       b.fee_s_amt, --월대여료\r\n" + 
				"       b.con_mon,\r\n" + 
				"       b.rent_start_dt,\r\n" + 
				"       b.rent_end_dt,\r\n" + 
				"       i.SCD_END_DT\r\n" + 
				"  FROM stat_rent_month a, \r\n" + 
				"       fee b, \r\n" + 
				"       fee_etc c, \r\n" + 
				"       car_reg d, \r\n" + 
				"       client e,\r\n" + 
				"       (select rent_l_cd, max(use_e_dt) as SCD_END_DT from scd_fee WHERE bill_yn='Y' GROUP BY rent_l_cd) i,\r\n" + 
				"       car_etc f, car_nm g, car_mng h \r\n" + 
				" WHERE a.save_dt=replace('" + save_dt + "','-','') \r\n" + 
				"       AND a.rent_mng_id=b.rent_mng_id \r\n" + 
				"       AND a.rent_l_cd=b.rent_l_cd \r\n" + 
				"       AND a.fee_rent_st=b.rent_st \r\n" + 
				"       AND a.rent_mng_id=c.rent_mng_id \r\n" + 
				"       AND a.rent_l_cd=c.rent_l_cd \r\n" + 
				"       AND a.fee_rent_st=c.rent_st \r\n" + 
				"       AND a.car_mng_id=d.car_mng_id(+) \r\n" + 
				"       AND a.client_id=e.client_id\r\n" + 
				"       AND a.rent_l_cd=i.rent_l_cd(+)\r\n" + 
				"       AND a.rent_l_cd=f.rent_l_cd \r\n" + 
				"       AND f.car_id=g.car_id AND f.car_seq=g.car_seq \r\n" + 
				"       AND g.car_comp_id=h.car_comp_id AND g.car_cd=h.code \r\n" + 
				"       and nvl(a.prepare,'0') NOT IN ('4')\r\n" + 
				" ORDER BY d.init_reg_dt";
		

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndContFeeListDB]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}
	
	/**
	 * 월마감-연체현황
	 */
	public Vector getSelectStatEndCont14ListDB(String save_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT \r\n" + 
				"       a.rent_l_cd, b.car_no, trunc(a.fee_s_amt*1.1) fee_amt, \r\n" + 
				"       a.fee_dly_amt,\r\n" + 
				"       NVL(a.n_mon,0)+DECODE(a.n_mon,0,DECODE(NVL(a.n_day,0),0,0,1),1) n_mon, \r\n" + 
				"       trunc(NVL(a.fee_est_amt,0)*1.1) fee_est_amt,\r\n" + 
				"       (trunc(NVL(a.fee_est_amt,0)*1.1)+a.fee_dly_amt) h_fee_amt\r\n" +  
				"FROM   stat_rent_month a, car_reg b, client c, fee d,\r\n" + 
				"       (SELECT rent_l_cd, rent_mng_id, rent_st, MAX(use_e_dt) use_e_dt, SUM(DECODE(tm_st1,'0',fee_s_amt)) FROM scd_fee WHERE bill_yn='Y' GROUP BY rent_l_cd, rent_mng_id, rent_st) e,\r\n" + 
				"       allot f, bank_rtn g, fee_etc h, car_etc i, cls_cont j\r\n" + 
				" WHERE a.save_dt=replace('" + save_dt + "','-','') \r\n" + 
				"AND a.fee_dly_amt >0 \r\n" + 
				"AND a.car_mng_id=b.car_mng_id\r\n" + 
				"AND a.client_id=c.client_id \r\n" + 
				"AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd AND a.fee_rent_st=d.rent_st\r\n" + 
				"AND a.rent_mng_id=e.rent_mng_id(+) AND a.rent_l_cd=e.rent_l_cd(+) AND a.fee_rent_st=e.rent_st(+)\r\n" + 
				"AND a.rent_mng_id=f.rent_mng_id AND a.rent_l_cd=f.rent_l_cd\r\n" + 
				"AND f.lend_id=g.lend_id(+) AND f.rtn_seq=g.seq(+) \r\n" + 
				"AND a.rent_mng_id=h.rent_mng_id AND a.rent_l_cd=h.rent_l_cd AND a.fee_rent_st=h.rent_st\r\n" + 
				"AND a.rent_mng_id=i.rent_mng_id AND a.rent_l_cd=i.rent_l_cd\r\n" + 
				"AND a.rent_mng_id=j.rent_mng_id(+) AND a.rent_l_cd=j.rent_l_cd(+)\r\n" + 
				"ORDER BY d.rent_end_dt" ;
						

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndCont14ListDB]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}	
	
	/**
	 * 월마감-금융사별대출현황
	 */
	public Vector getSelectStatEndCont15ListDB(String save_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select cpt_nm, alt_start_dt, alt_end_dt, SUM(lend_prn) lend_prn,\r\n" + 
				"            rtn_cdt, tot_alt_tm, lend_int, SUM(alt_rest) alt_rest \r\n" + 
				"     FROM (                \r\n" + 
				"         select \r\n" + 
				"                a.cpt_nm, a.lend_dt, a.cpt_cd, a.cpt_cd_st, h.etc,\r\n" + 
				"                DECODE(a.lend_id,'',c.alt_start_dt,d.cont_start_dt) alt_start_dt, \r\n" + 
				"                DECODE(a.lend_id,'',c.alt_end_dt,d.cont_end_dt) alt_end_dt, \r\n" + 
				"                DECODE(a.lend_id,'',c.lend_prn,d.rtn_cont_amt) lend_prn, \r\n" + 
				"                DECODE(DECODE(a.lend_id,'',c.rtn_cdt,d.rtn_cdt),'1','원리금균등','2','원금균등') rtn_cdt, \r\n" + 
				"                DECODE(a.lend_id,'',c.tot_alt_tm,d.cont_term) tot_alt_tm,\r\n" + 
				"                a.lend_int, a.alt_rest,                \r\n" + 
				"                DECODE(NVL(e.cltr_rat,0),0,DECODE(NVL(e.cltr_amt,0),0,DECODE(NVL(g.max_cltr_rat,0),0,'X','O'),'O'),'O') cltr_st \r\n" + 
				"		     from   debt_pay_view a, \r\n" + 
				"                (select gubun, rent_l_cd, rtn_seq, max(TO_NUMBER(alt_tm)) alt_tm from debt_pay_view where alt_est_dt like '" + save_dt + "%' group by gubun, rent_l_cd, rtn_seq) b,\r\n" + 
				"                allot c, bank_rtn d, \r\n" + 
				"                (SELECT DISTINCT b.rent_mng_id, b.rent_l_cd, a.cltr_rat, a.cltr_amt \r\n" + 
				"                 FROM   fine_doc a, fine_doc_list b\r\n" + 
				"                 WHERE  a.doc_id LIKE '총무%' and a.doc_id=b.doc_id\r\n" + 
				"                ) e,  \r\n" + 
				"                lend_bank g, (SELECT * FROM code WHERE c_st='0003') h\r\n" + 
				"		     where  a.gubun=b.gubun and a.rent_l_cd=b.rent_l_cd and nvl(a.rtn_seq,'0')=nvl(b.rtn_seq,'0') and a.alt_tm=b.alt_tm         \r\n" + 
				"                and a.alt_est_dt like '" + save_dt + "%'\r\n" + 
				"                AND a.rent_l_cd=c.rent_l_cd(+) AND a.car_mng_id=c.car_mng_id(+)\r\n" + 
				"                AND a.lend_id=d.lend_id(+) AND a.rtn_seq=d.seq(+)\r\n" + 
				"                AND c.rent_mng_id=e.rent_mng_id(+) AND c.rent_l_cd=e.rent_l_cd(+)\r\n" + 
				"                AND a.lend_id=g.lend_id(+)\r\n" + 
				"                AND a.CPT_CD=h.code    \r\n" + 
				"          )          \r\n" + 
				"          GROUP BY etc, cpt_nm, alt_start_dt, alt_end_dt, rtn_cdt, tot_alt_tm, lend_int \r\n" + 
				"         ORDER BY etc, cpt_nm, alt_start_dt" ;
						

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndCont15ListDB]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}	
	
	/**
	 * 월마감-신규영업 중단하고 대여사업 계속시(현재가치,백만원단위)
	 */
	public Vector getSelectStatEndCont12ListDB(String save_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT c.etc, NVL(c.nm,'비차입') nm, \r\n" + 
				"       b.cnt1, --상환중\r\n" + 
				"       b.cnt2, --상환완료\r\n" + 
				"       (b.cnt1+b.cnt2) cnt, --차량대수합계\r\n" + 
				"       NVL(a.d_alt_amt,0) d_alt_amt, --대출잔액 \r\n" + 
				"       b.d_grt_amt, --보증금현재가치 \r\n" + 
				"       (NVL(a.d_alt_amt,0)+b.d_grt_amt) d_amt, --부채합계 \r\n" + 
				"       b.a_car_amt, --만기시잔가현재가치 \r\n" + 
				"       b.a_fee_amt, --대여료현재가치 \r\n" + 
				"       b.a_pay_amt, --비용현재가치\r\n" + 
				"       (b.a_car_amt+b.a_fee_amt+b.a_pay_amt) a_amt, --자산합계 \r\n" + 
				"       (b.a_car_amt+b.a_fee_amt+b.a_pay_amt)-(NVL(a.d_alt_amt,0)+b.d_grt_amt) c_amt --자산-부채\r\n" + 
				"  FROM \r\n" + 
				"       (SELECT decode(a.cpt_cd,'','비차입','0068','0077','0073','0077','0051','0078',a.cpt_cd) cpt_cd, \r\n" + 
				"              ROUND(SUM(a.d_grt_amt2)/1000000) AS d_grt_amt, \r\n" + 
				"              ROUND(SUM(a.a_car_amt)/1000000) AS a_car_amt, \r\n" + 
				"              ROUND(SUM(a.a_fee_amt_1)/1000000) AS a_fee_amt, \r\n" + 
				"              ROUND(SUM(-1*a.a_pay_amt)/1000000) AS a_pay_amt,\r\n" + 
				"              COUNT(DECODE(NVL(a.alt_amt,0),0,'',a.rent_l_cd)) cnt1, \r\n" + 
				"				      COUNT(DECODE(NVL(a.alt_amt,0),0,a.rent_l_cd)) cnt2\r\n" + 
				"         FROM stat_rent_month a \r\n" + 
				"        WHERE a.save_dt=replace('" + save_dt + "','-','')  \r\n" + 
				"        AND a.car_mng_id IS NOT NULL   \r\n" + 
				"        and a.prepare not in ('4','5')\r\n" + 
				"        GROUP BY decode(a.cpt_cd,'','비차입','0068','0077','0073','0077','0051','0078',a.cpt_cd) \r\n" + 
				"       ) b, \r\n" + 
				"       (SELECT cpt_cd, \r\n" + 
				"              ROUND(over_mon_amt/1000000) AS d_alt_amt \r\n" + 
				"         FROM stat_debt \r\n" + 
				"        WHERE save_dt=replace('" + save_dt + "','-','') \r\n" + 
				"        UNION ALL\r\n" + 
				"        SELECT '비차입' cpt_cd, 0 d_alt_amt FROM dual\r\n" + 
				"       ) a, \r\n" + 
				"       (SELECT * \r\n" + 
				"         FROM code \r\n" + 
				"        WHERE c_st='0003' \r\n" + 
				"       ) c \r\n" + 
				" WHERE b.cpt_cd=a.cpt_cd(+)   \r\n" + 
				"       AND b.cpt_cd=c.code(+)   \r\n" + 
				"ORDER BY c.etc, \r\n" + 
				"       b.cpt_cd";
		

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}

			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndCont12ListDB]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}	
	
	/**
	 * 월마감-신규영업 중단하고 대여사업 계속시(현재가치,원단위)
	 */
	public Vector getSelectStatEndCont13ListDB(String save_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT c.etc, NVL(c.nm,'비차입') nm, \r\n" + 
				"       b.cnt1, --상환중\r\n" + 
				"       b.cnt2, --상환완료\r\n" + 
				"       (b.cnt1+b.cnt2) cnt, --차량대수합계\r\n" + 
				"       NVL(a.d_alt_amt,0) d_alt_amt, --대출잔액 \r\n" + 
				"       b.d_grt_amt, --보증금현재가치 \r\n" + 
				"       (NVL(a.d_alt_amt,0)+b.d_grt_amt) d_amt, --부채합계 \r\n" + 
				"       b.a_car_amt, --만기시잔가현재가치 \r\n" + 
				"       b.a_fee_amt, --대여료현재가치 \r\n" + 
				"       b.a_pay_amt, --비용현재가치\r\n" + 
				"       (b.a_car_amt+b.a_fee_amt+b.a_pay_amt) a_amt, --자산합계 \r\n" + 
				"       (b.a_car_amt+b.a_fee_amt+b.a_pay_amt)-(NVL(a.d_alt_amt,0)+b.d_grt_amt) c_amt --자산-부채\r\n" + 
				"  FROM \r\n" + 
				"       (SELECT decode(a.cpt_cd,'','비차입','0068','0077','0073','0077','0051','0078',a.cpt_cd) cpt_cd, \r\n" + 
				"              SUM(a.d_grt_amt2) AS d_grt_amt, \r\n" + 
				"              SUM(a.a_car_amt) AS a_car_amt, \r\n" + 
				"              SUM(a.a_fee_amt_1) AS a_fee_amt, \r\n" + 
				"              SUM(-1*a.a_pay_amt) AS a_pay_amt,\r\n" + 
				"              COUNT(DECODE(NVL(a.alt_amt,0),0,'',a.rent_l_cd)) cnt1, \r\n" + 
				"				      COUNT(DECODE(NVL(a.alt_amt,0),0,a.rent_l_cd)) cnt2\r\n" + 
				"         FROM stat_rent_month a \r\n" + 
				"        WHERE a.save_dt=replace('" + save_dt + "','-','')  \r\n" + 
				"        AND a.car_mng_id IS NOT NULL   \r\n" + 
				"        and a.prepare not in ('4','5')\r\n" + 
				"        GROUP BY decode(a.cpt_cd,'','비차입','0068','0077','0073','0077','0051','0078',a.cpt_cd) \r\n" + 
				"       ) b, \r\n" + 
				"       (SELECT cpt_cd, \r\n" + 
				"              over_mon_amt AS d_alt_amt \r\n" + 
				"         FROM stat_debt \r\n" + 
				"        WHERE save_dt=replace('" + save_dt + "','-','') \r\n" + 
				"        UNION ALL\r\n" + 
				"        SELECT '비차입' cpt_cd, 0 d_alt_amt FROM dual\r\n" + 
				"       ) a, \r\n" + 
				"       (SELECT * \r\n" + 
				"         FROM code \r\n" + 
				"        WHERE c_st='0003' \r\n" + 
				"       ) c \r\n" + 
				" WHERE b.cpt_cd=a.cpt_cd(+)   \r\n" + 
				"       AND b.cpt_cd=c.code(+)   \r\n" + 
				"ORDER BY c.etc, \r\n" + 
				"       b.cpt_cd";
		

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}

			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndCont13ListDB]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}		
	
	/**
	 * 월마감-대여일시종료시 정산가치(원단위) - 점검용
	 */
	public Vector getSelectStatEndCont18ListDB(String save_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT c.etc, NVL(c.nm,'비차입') nm, \r\n" + 
				"       b.cnt1, --상환중\r\n" + 
				"       b.cnt2, --상환완료\r\n" + 
				"       (b.cnt1+b.cnt2) cnt, --차량대수\r\n" + 
				"       NVL(a.d_alt_amt,0) d_alt_amt, --대출잔액 \r\n" + 
				"       b.d_grt_amt, --보증금 \r\n" + 
				"       b.d_ext_amt, --잔여선납금 \r\n" + 
				"       (NVL(a.d_alt_amt,0)+b.d_grt_amt+b.d_ext_amt) d_amt, --부채소계 \r\n" + 
				"       b.a_car_amt, --차량현재잔가 \r\n" + 
				"       b.a_fee_amt, --미수대여료 \r\n" + 
				"       b.a_cls_amt, --위약금 \r\n" + 
				"       (b.a_car_amt+b.a_fee_amt+b.a_pay_amt+b.a_cls_amt) a_amt, --자산소계 \r\n" + 
				"       (b.a_car_amt+b.a_fee_amt+b.a_pay_amt+b.a_cls_amt)-(NVL(a.d_alt_amt,0)+b.d_grt_amt+b.d_ext_amt) c_amt --자산-부채\r\n" + 
				"  FROM \r\n" + 
				"       (SELECT decode(a.cpt_cd,'','비차입','0068','0077','0073','0077','0051','0078',a.cpt_cd) cpt_cd, \r\n" + 
				"              SUM(a.d_grt_amt) AS d_grt_amt, \r\n" + 
				"              SUM(a.d_ext_amt) AS d_ext_amt, \r\n" + 
				"              SUM(a.a_car_amt2) AS a_car_amt,\r\n" + 
				"              SUM(a.a_dly_amt) AS a_fee_amt,\r\n" + 
				"              0 AS a_pay_amt,\r\n" + 
				"              SUM(a.a_cls_amt) AS a_cls_amt,\r\n" + 
				"              COUNT(DECODE(NVL(a.alt_amt,0),0,'',a.rent_l_cd)) cnt1, \r\n" + 
				"				      COUNT(DECODE(NVL(a.alt_amt,0),0,a.rent_l_cd)) cnt2                \r\n" + 
				"         FROM stat_rent_month a \r\n" + 
				"        WHERE a.save_dt=replace('" + save_dt + "','-','')  \r\n" + 
				"        AND a.car_mng_id IS NOT NULL \r\n" + 
				"        and a.prepare not in ('4','5')\r\n" + 
				"        GROUP BY decode(a.cpt_cd,'','비차입','0068','0077','0073','0077','0051','0078',a.cpt_cd) \r\n" + 
				"       ) b, \r\n" + 
				"       (SELECT cpt_cd, \r\n" + 
				"              over_mon_amt AS d_alt_amt \r\n" + 
				"         FROM stat_debt \r\n" + 
				"        WHERE save_dt=replace('" + save_dt + "','-','') \r\n" + 
				"        UNION ALL\r\n" + 
				"        SELECT '비차입' cpt_cd, 0 d_alt_amt FROM dual\r\n" + 
				"       ) a, \r\n" + 
				"       (SELECT * \r\n" + 
				"         FROM code \r\n" + 
				"        WHERE c_st='0003' \r\n" + 
				"       ) c \r\n" + 
				" WHERE b.cpt_cd=a.cpt_cd(+)  \r\n" + 
				"       AND b.cpt_cd=c.code(+)  \r\n" + 
				"ORDER BY c.etc, \r\n" + 
				"       b.cpt_cd";
		

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}

			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndCont18ListDB]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}		
	
	/**
	 * 월마감-신규영업 중단하고 대여사업 계속시(현재가치) 차량별세부리스트 - 점검용
	 */
	public Vector getSelectStatEndCont17ListDB(String save_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT\r\n" + 
				"              NVL(d.nm,'비차입') nm,  \r\n" + 
				"              b.car_no, b.init_reg_dt, b.car_nm, \r\n" + 
				"              h.jg_g_7, h.jg_a,\r\n" + 
				"              c.firm_nm,\r\n" + 
				"              DECODE(a.fee_rent_st,'1',DECODE(a.car_gu,'1','신차','0','재리스','2','중고차','3','월렌트'),'연장') rent_st, \r\n" + 
				"	            DECODE(a.car_st,'1','렌트','2','보유차','3','리스','4','월렌트','5','업무대여') car_st,\r\n" + 
				"              DECODE(a.car_use,'1','영업용','자가용') car_use,\r\n" + 
				"              DECODE(a.rent_way,'1','일반식','기본식') rent_way,\r\n" + 
				"              a.b_car_mon, a.b_end_mon,\r\n" + 
				"              a.rent_start_dt, a.rent_end_dt, \r\n" + 
				"              a.n_mon, a.n_day, a.n_mon+(a.n_day/30) n_monday,\r\n" + 
				"              a.d_grt_amt AS d_grt_amt, --보증금 \r\n" + 
				"              a.d_grt_amt2 AS d_grt_amt2, --보증금현재가치 \r\n" + 
				"              a.d_ext_amt AS d_ext_amt, --잔여선납금 \r\n" + 
				"              a.b_opt_amt, --만기시잔가\r\n" + 
				"              a.a_car_amt AS a_car_amt, --만기시잔가현재가치\r\n" + 
				"              a.a_car_amt2 AS a_car_amt2, --차량현재잔가\r\n" + 
				"              a.a_fee_amt_2 AS a_fee_amt_2, --대여료현재가치(대여료+선수금효과)\r\n" + 
				"              a.a_fee_amt_1 AS a_fee_amt_1, --대여료현재가치(대여료)\r\n" + 
				"              a.a_dly_amt AS a_dly_amt, --미수대여료\r\n" + 
				"              -1*a.a_pay_amt AS a_pay_amt, --비용현재가치\r\n" + 
				"              a.a_cls_amt AS a_cls_amt, --위약금\r\n" + 
				"              a.a_fee_amt,\r\n" + 
				"              a.a_tax_amt2,\r\n" + 
				"              a.a_ins_amt,\r\n" + 
				"              a.a_tax_amt,\r\n" + 
				"              a.a_serv_amt,\r\n" + 
				"              a.a_maint_amt,\r\n" + 
				"              a.a_grt_eff_amt,\r\n" + 
				"              a.a_pp_eff_amt,\r\n" + 
				"              a.a_ifee_eff_amt,\r\n" + 
				"              '' gong,\r\n" + 
				"              a.b_fee_amt,\r\n" + 
				"              a.b_ins_amt,\r\n" + 
				"              a.b_tax_amt,\r\n" + 
				"              a.b_serv_amt,\r\n" + 
				"              a.b_maint_amt,\r\n" + 
				"              a.b_cls_per,\r\n" + 
				"              a.a_g,\r\n" + 
				"              a.o_maint_amt\r\n" + 
				"              --견적점검용\r\n" + 
				"              ,\r\n" + 
				"              '' gong2, \r\n" + 
				"              e.reg_dt, e.rent_dt, e.car_amt, e.opt_amt, e.col_amt, e.tax_dc_amt, h.sh_code, b.init_reg_dt, e.today_dist, \r\n" + 
				"              e.accid_serv_amt1, e.accid_serv_amt2, e.jg_opt_st, e.jg_col_st                            \r\n" + 
				"         FROM stat_rent_month a, car_reg b, client c, (SELECT * FROM code WHERE c_st='0003') d, estimate e, esti_exam f, car_nm g, esti_jg_var h \r\n" + 
				"        WHERE a.save_dt=replace('" + save_dt + "','-','') \r\n" + 
				"        AND a.car_mng_id=b.car_mng_id \r\n" + 
				"        and a.prepare not in ('4','5')\r\n" + 
				"        AND a.client_id=c.client_id \r\n" + 
				"        AND a.cpt_cd=d.code(+)\r\n" + 
				"        AND a.est_id=e.est_id \r\n" + 
				"        AND a.est_id=f.est_id\r\n" + 
				"        AND e.car_id=g.car_id AND e.car_seq=g.car_seq\r\n" + 
				"        AND g.jg_code=h.sh_code AND f.jg_b_dt=h.reg_dt\r\n" + 
				"        ORDER BY d.etc, a.cpt_cd, a.rent_start_dt ";
		

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}

			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndCont17ListDB]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}		
	
	/**
	 * 월마감-유동성장기보증금(1년이내도래분)
	 */
	public Vector getSelectStatEndGrt1YearEndListDB(String save_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT b.firm_nm, c.car_no, a.grt_amt_s, a.rent_start_dt, a.rent_end_dt, to_char(ADD_MONTHS(TO_DATE(a.save_dt,'YYYYMMDD'),12),'YYYYMMDD') AS grt_end_dt\r\n" + 
				"FROM   STAT_RENT_MONTH a, client b, car_reg c\r\n" + 
				"WHERE  a.save_dt=replace('" + save_dt + "','-','') AND a.grt_amt_s >0 AND a.car_st<>'2' AND a.rent_end_dt<>'-'\r\n" + 
				"       AND a.rent_end_dt <= to_char(ADD_MONTHS(TO_DATE(a.save_dt,'YYYYMMDD'),12),'YYYYMMDD')\r\n" + 
				"       AND a.client_id=b.client_id\r\n" + 
				"       AND a.car_mng_id=c.car_mng_id  \r\n" + 
				"ORDER BY a.rent_end_dt, a.rent_start_dt ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndGrtDebt1YearEndListDB]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}
	
	/**
	 * 월마감-유동성장기보증금(1년이내도래분)
	 */
	public Vector getSelectStatEndDebt1YearEndListDB(String save_dt, String save_dt2) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  \r\n" + 
				"				                f.firm_nm, nvl(g.car_no,a.lend_id) car_no, g.car_nm, \r\n" + 
				"                               a.rent_l_cd, a.car_mng_id, a.cpt_nm, a.lend_dt, a.cpt_cd, a.cpt_cd_st, \r\n" + 
				"				                DECODE(a.lend_id,'',c.alt_start_dt,d.cont_start_dt) alt_start_dt,  \r\n" + 
				"				                DECODE(a.lend_id,'',c2.alt_est_dt,d2.alt_est_dt) alt_end_dt,  \r\n" + 				  
				"				                a.alt_rest\r\n" +  
				"						     from   debt_pay_view a,  \r\n" + 
				"				                (select gubun, rent_l_cd, rtn_seq, max(TO_NUMBER(alt_tm)) alt_tm from debt_pay_view where alt_est_dt like '" + save_dt2 + "%' group by gubun, rent_l_cd, rtn_seq) b, \r\n" + 
				"				                allot c, bank_rtn d,\r\n" + 
				"				                (select car_mng_id, max(alt_est_dt) alt_est_dt from scd_alt_case group by car_mng_id) c2, (select lend_id, rtn_seq, max(alt_est_dt) alt_est_dt from scd_bank group by lend_id, rtn_seq) d2,\r\n" +
				"                        cont e, client f, car_reg g\r\n" + 
				"						     where  a.gubun=b.gubun and a.rent_l_cd=b.rent_l_cd and nvl(a.rtn_seq,'0')=nvl(b.rtn_seq,'0') and a.alt_tm=b.alt_tm          \r\n" + 
				"				                and a.alt_est_dt like '" + save_dt2 + "%' \r\n" + 
				"				                AND a.rent_l_cd=c.rent_l_cd(+) AND a.car_mng_id=c.car_mng_id(+) \r\n" + 
				"				                AND a.lend_id=d.lend_id(+) AND a.rtn_seq=d.seq(+)\r\n" +
				"                               and a.car_mng_id=c2.car_mng_id(+) and a.lend_id=d2.lend_id(+) and a.rtn_seq=d2.rtn_seq(+) "+
				"                        AND a.alt_rest > 0 \r\n" + 
				"                        AND DECODE(a.lend_id,'',c2.alt_est_dt,d2.alt_est_dt) <= to_char(ADD_MONTHS(TO_DATE(replace('" + save_dt + "','-',''),'YYYYMMDD'),12),'YYYYMMDD')\r\n" + 
				"                        AND c.rent_mng_id=e.rent_mng_id(+) AND c.rent_l_cd=e.rent_l_cd(+) \r\n" + 
				"                        AND e.client_id=f.client_id(+) \r\n" + 
				"                        AND e.car_mng_id=g.car_mng_id(+) \r\n" + 
				"                 ORDER BY 11, 10 ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndDebt1YearEndListDB]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}
		
	/**
	 * 월마감-신규영업 중단하고 대여사업 계속시 CASH FLOW(종합)
	 */
	public Vector getSelectStatEndCont19ListDB(String save_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.cash_ym, a.debt_st1, a.debt_st2, a.debt_st3, a.cnt, \r\n" + 
				"       a.d_amt, a.c_amt, a.m_fee_amt, a.m_sui_amt, a.m_book_amt, a.a_amt, \r\n" + 
				"       b.prn_amt, a.m_grt_amt, (a.e_amt+nvl(b.prn_amt,0)) e_amt, a.f_amt, \r\n" + 
				"       a.m_tax_amt, a.m_ins_amt, a.m_ins_amt2, a.m_serv_amt, a.m_maint_amt,\r\n" + 
				"       a.g_amt, a.gong4, (a.b_amt+nvl(b.prn_amt,0)) b_amt   \r\n" + 
				"FROM \r\n" + 
				"(\r\n" + 
				"SELECT a.cash_ym, \r\n" + 
				"       SUM(DECODE(a.debt_st,'1',1,0)) debt_st1, \r\n" + 
				"       SUM(DECODE(a.debt_st,'2',1,0)) debt_st2, \r\n" + 
				"       SUM(DECODE(a.debt_st,'0',1,0)) debt_st3, \r\n" + 
				"       SUM(DECODE(a.debt_st,'1',1,0)+DECODE(a.debt_st,'2',1,0)+DECODE(a.debt_st,'0',1,0)) cnt, \r\n" + 
				"       SUM(0) d_amt, \r\n" + 
				"       SUM(0) c_amt, \r\n" + 
				"       ROUND(SUM(a.m_fee_amt)/1000000) m_fee_amt, \r\n" + 
				"       ROUND(SUM(a.m_sui_amt)/1000000) m_sui_amt, \r\n" + 
				"       ROUND(SUM(a.m_book_amt)/1000000) m_book_amt, \r\n" +
				"       ROUND(SUM((a.m_fee_amt+a.m_sui_amt))/1000000) a_amt, \r\n" + 
				"       SUM(0) gong3, \r\n" + 
				"       ROUND(SUM(a.m_grt_amt)/1000000) m_grt_amt, \r\n" + 
				"       ROUND(SUM((0+a.m_grt_amt))/1000000) e_amt, \r\n" + 
				"       ROUND(SUM(a.m_tax_amt2)/1000000) AS f_amt, \r\n" + 
				"       ROUND(SUM(a.m_tax_amt)/1000000) m_tax_amt, \r\n" + 
				"       ROUND(SUM(a.m_ins_amt)/1000000) m_ins_amt, \r\n" + 
				"       ROUND(SUM(a.m_ins_amt2)/1000000) m_ins_amt2, \r\n" + 
				"       ROUND(SUM(a.m_serv_amt)/1000000) m_serv_amt, \r\n" + 
				"       ROUND(SUM(a.m_maint_amt)/1000000) m_maint_amt, \r\n" + 
				"       ROUND(SUM((a.m_tax_amt+a.m_ins_amt+a.m_ins_amt2+a.m_serv_amt+a.m_maint_amt))/1000000) g_amt, \r\n" + 
				"       0 gong4, \r\n" + 
				"       ROUND(SUM((0+a.m_grt_amt+a.m_tax_amt2+a.m_tax_amt+a.m_ins_amt+a.m_ins_amt2+a.m_serv_amt+a.m_maint_amt))/1000000) b_amt \r\n" + 
				"  FROM stat_rent_month_cash a, stat_rent_month b, \r\n" + 
				"       (SELECT * \r\n" + 
				"         FROM code \r\n" + 
				"        WHERE c_st='0003'\r\n" + 
				"       ) c, car_reg d \r\n" + 
				" WHERE a.save_dt=replace('" + save_dt + "','-','') \r\n" + 
				"       AND a.save_dt=b.save_dt \r\n" + 
				"       AND a.rent_l_cd=b.rent_l_cd \r\n" + 
				"       AND b.prepare NOT IN ('4','5') \r\n" + 
				"       AND b.cpt_cd=c.code(+) \r\n" + 
				"       AND b.car_mng_id=d.car_mng_id(+) \r\n" + 
				" GROUP BY a.cash_ym \r\n" + 
				") a, \r\n" + 
				"(\r\n" + 
				"SELECT est_mon, ROUND(SUM(prn_amt+int_amt)/1000000) prn_amt\r\n" + 
				"FROM  STAT_DEBT_MONTH\r\n" + 
				"WHERE save_dt=replace('" + save_dt + "','-','')\r\n" + 
				"GROUP BY est_mon\r\n" + 
				") b\r\n" + 
				"WHERE a.cash_ym=b.est_mon(+) \r\n" + 
				"ORDER BY a.cash_ym";
		

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}

			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndCont19ListDB]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}	
	
	/**
	 * 월마감-신규영업 중단하고 대여사업 계속시 CASH FLOW(종합)-원단위
	 */
	public Vector getSelectStatEndCont20ListDB(String save_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.cash_ym, a.debt_st1, a.debt_st2, a.debt_st3, a.cnt, \r\n" + 
				"       a.d_amt, a.c_amt, a.m_fee_amt, a.m_sui_amt, a.m_book_amt, a.a_amt, \r\n" + 
				"       b.prn_amt, a.m_grt_amt, (a.e_amt+nvl(b.prn_amt,0)) e_amt, a.f_amt, \r\n" + 
				"       a.m_tax_amt, a.m_ins_amt, a.m_ins_amt2, a.m_serv_amt, a.m_maint_amt,\r\n" + 
				"       a.g_amt, a.gong4, (a.b_amt+nvl(b.prn_amt,0)) b_amt   \r\n" + 
				"FROM \r\n" + 
				"(\r\n" + 
				"SELECT a.cash_ym, \r\n" + 
				"       SUM(DECODE(a.debt_st,'1',1,0)) debt_st1, \r\n" + 
				"       SUM(DECODE(a.debt_st,'2',1,0)) debt_st2, \r\n" + 
				"       SUM(DECODE(a.debt_st,'0',1,0)) debt_st3, \r\n" + 
				"       SUM(DECODE(a.debt_st,'1',1,0)+DECODE(a.debt_st,'2',1,0)+DECODE(a.debt_st,'0',1,0)) cnt, \r\n" + 
				"       SUM(0) d_amt, \r\n" + 
				"       SUM(0) c_amt, \r\n" + 
				"       SUM(a.m_fee_amt) m_fee_amt, \r\n" + 
				"       SUM(a.m_sui_amt) m_sui_amt, \r\n" + 
				"       SUM(a.m_book_amt) m_book_amt, \r\n" +
				"       SUM((a.m_fee_amt+a.m_sui_amt)) a_amt, \r\n" + 
				"       SUM(0) gong3, \r\n" + 
				"       SUM(a.m_grt_amt) m_grt_amt, \r\n" + 
				"       SUM((0+a.m_grt_amt)) e_amt, \r\n" + 
				"       SUM(a.m_tax_amt2) AS f_amt, \r\n" + 
				"       SUM(a.m_tax_amt) m_tax_amt, \r\n" + 
				"       SUM(a.m_ins_amt) m_ins_amt, \r\n" + 
				"       SUM(a.m_ins_amt2) m_ins_amt2, \r\n" + 
				"       SUM(a.m_serv_amt) m_serv_amt, \r\n" + 
				"       SUM(a.m_maint_amt) m_maint_amt, \r\n" + 
				"       SUM((a.m_tax_amt+a.m_ins_amt+a.m_ins_amt2+a.m_serv_amt+a.m_maint_amt)) g_amt, \r\n" + 
				"       0 gong4, \r\n" + 
				"       SUM((0+a.m_grt_amt+a.m_tax_amt2+a.m_tax_amt+a.m_ins_amt+a.m_ins_amt2+a.m_serv_amt+a.m_maint_amt)) b_amt \r\n" + 
				"  FROM stat_rent_month_cash a, stat_rent_month b, \r\n" + 
				"       (SELECT * \r\n" + 
				"         FROM code \r\n" + 
				"        WHERE c_st='0003'\r\n" + 
				"       ) c, car_reg d \r\n" + 
				" WHERE a.save_dt=replace('" + save_dt + "','-','') \r\n" + 
				"       AND a.save_dt=b.save_dt \r\n" + 
				"       AND a.rent_l_cd=b.rent_l_cd \r\n" + 
				"       AND b.prepare NOT IN ('4','5') \r\n" + 
				"       AND b.cpt_cd=c.code(+) \r\n" + 
				"       AND b.car_mng_id=d.car_mng_id(+) \r\n" + 
				" GROUP BY a.cash_ym \r\n" + 
				") a, \r\n" + 
				"(\r\n" + 
				"SELECT est_mon, SUM(prn_amt+int_amt) prn_amt\r\n" + 
				"FROM  STAT_DEBT_MONTH\r\n" + 
				"WHERE save_dt=replace('" + save_dt + "','-','')\r\n" + 
				"GROUP BY est_mon\r\n" + 
				") b\r\n" + 
				"WHERE a.cash_ym=b.est_mon(+) \r\n" + 
				"ORDER BY a.cash_ym";
		

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}

			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectStatEndCont20ListDB]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}
	
	/**
	 * 입출금예정-할부금
	 */
	public Vector getSelectAccountEstDebtList2(String debt_end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select alt_est_Dt1 일자, sum(alt_prn) 금액 from debt_pay_view where "
				+ " alt_est_Dt1 like substr(replace('" + debt_end_dt + "','-',''),1,6)||'%' "
				+ " group by alt_est_Dt1 order by alt_est_Dt1 " + " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSelectAccountEstDebtList2]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}
	
	/**
	 * 현대,기아차구입현황
	 */
	public Vector getStatMakerCarTax(String gubun2, String gubun3, String gubun4, String st_dt, String end_dt) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String subQuery = "";
		String when_dt = "d.car_tax_dt";
		
		if (gubun4.equals("2")) {
			when_dt = "e.init_reg_dt";
		}

		if (!gubun3.equals("")) {
			subQuery += " and e.car_use = '"+gubun3+"' ";
		}
		
		if (gubun2.equals("1")) { //이번주
			subQuery += " and " + when_dt + " BETWEEN TO_CHAR(trunc(SYSDATE,'iw'),'YYYYMMDD') AND TO_CHAR(trunc(SYSDATE,'iw')+6,'YYYYMMDD') ";
		} else if (gubun2.equals("2")) { //지난주
			subQuery += " and " + when_dt + " BETWEEN TO_CHAR(trunc(SYSDATE,'iw')-7,'YYYYMMDD') AND TO_CHAR(trunc(SYSDATE,'iw')-1,'YYYYMMDD') ";
		} else if (gubun2.equals("3")) { //지지난주
			subQuery += " and " + when_dt + " BETWEEN TO_CHAR(trunc(SYSDATE,'iw')-14,'YYYYMMDD') AND TO_CHAR(trunc(SYSDATE,'iw')-8,'YYYYMMDD') ";
		} else if (gubun2.equals("4")) {// 당월
			subQuery += " and " + when_dt + " like to_char(sysdate,'YYYYMM')||'%' ";	
		} else if (gubun2.equals("5")) {// 전월
			subQuery += " and " + when_dt + " like TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM')||'%' ";	
		} else if (gubun2.equals("6")) {// 전전월
			subQuery += " and " + when_dt + " like TO_CHAR(ADD_MONTHS(SYSDATE,-2),'YYYYMM')||'%' ";	
		} else if (gubun2.equals("7")) {// 기간
			if (!st_dt.equals("") && end_dt.equals(""))
				subQuery += " and " + when_dt + " like replace('" + st_dt + "%', '-','')";
			if (!st_dt.equals("") && !end_dt.equals(""))
				subQuery += " and " + when_dt + " between replace('" + st_dt + "', '-','') and replace('" + end_dt + "', '-','')";
		}
				
	 	query += " SELECT car_com_st, COUNT(0) cnt, SUM(car_f_amt) car_f_amt\r\n"
	 			+ "FROM (\r\n"
	 			+ "       SELECT DECODE(f.car_comp_id,'0001','현대차','0002','기아차','기타') car_com_st,\r\n"
	 			+ "              DECODE(f.car_comp_id,'0001','0001','0002','0002','9999') car_com_cd,\r\n"
	 			+ "              (d.car_fs_amt+d.car_fv_amt+d.sd_cs_amt+d.sd_cv_amt-d.dc_cs_amt-d.dc_cv_amt) car_f_amt,\r\n"
	 			+ "              f.car_comp_id, g.nm, a.pur_pay_dt, c.dlv_dt, e.init_reg_dt, d.car_tax_dt, e.car_no\r\n"
	 			+ "       FROM   car_pur a, doc_settle b, cont c, car_etc d, car_reg e, car_nm f, code g\r\n"
	 			+ "       WHERE  a.rent_l_cd=b.doc_id AND b.DOC_ST='4' AND b.doc_step='3'\r\n"
	 			+ "       AND a.rent_mng_id=c.rent_mng_id AND a.rent_l_cd=c.rent_l_cd \r\n"
	 			+ "       AND a.rent_mng_id=d.rent_mng_id AND a.rent_l_cd=d.rent_l_cd\r\n"
	 			+ "       AND c.car_mng_id=e.car_mng_id\r\n"
	 			+ "       AND d.car_id=f.car_id AND d.car_seq=f.car_seq\r\n"
	 			+ "       AND f.car_comp_id=g.code AND g.c_st='0001'\r\n"
	 			+ subQuery
	 			+ "     )\r\n"
	 			+ "GROUP BY car_com_st, car_com_cd\r\n"
	 			+ "ORDER BY car_com_cd ";		

		try {

			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getStatMakerCarTax()]" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}	
	
	/**
	 *	//jip_cms  출금의뢰일 조회하기 where aipbit = '1'  and pross = '3'
	 */
	public Vector getAJipCmsDate()
	{
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select adate from cms.file_ea21 where aipbit = '1'  and pross = '3'  and amount - r_amount > 0  group by adate order by adate desc";

		try {
			stmt = conn.createStatement();
	//	System.out.println("query=" + query);
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
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getAJipCmsDate]\n"+e);
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
	
	//취소건은 r_amount가 0 이다  -/
		public Vector   getACardJipCmsDate()
		{
			getConnection();
			Statement stmt = null;
			ResultSet rs = null;
			Vector vt = new Vector();
			String query = "";

			//query = " select adate from cms.card_cms_pay  where aipbit = '1'  and result = 'Y'  and result_info not in  ('정상취소' , '취소 성공' )   group by adate order by adate desc";

		
		       query = "  select distinct adate from ( " + 
			       " 		select adate from cms.card_cms_pay  where aipbit = '1'  and result = 'Y' and result_info not in  ('정상취소' , '취소 성공' ) " +
			       " 		union " + 
			       " 		select adate from cms.card_cms_pay  where aipbit = '1'  and result = 'Y' and pross = 'C' " +
			       "	) " ; 
			
			try {
				stmt = conn.createStatement();
		//	System.out.println("query=" + query);
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
			} catch (SQLException e) {
				System.out.println("[AdminDatabase:getACardJipCmsDate]\n"+e);
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
		
				
	/*
	 *	cms 처리 procedure 호출
	*/
	public String call_sp_incom_card_cms_magam(String adate, String user_id,  String incom_dt, String ama_id )
	{
       	getConnection();
     
    	String query = "{CALL P_CARD_CMS_PAY_MAGAM (?,?,?,?,?)}";

		String sResult = "";
		
		CallableStatement cstmt = null;
		
		try {
						
			cstmt = conn.prepareCall(query);
					
			cstmt.setString(1, adate);
			cstmt.setString(2, user_id);
			cstmt.setString(3, incom_dt);
			cstmt.setString(4, ama_id);	
			cstmt.registerOutParameter( 5, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(5); // 결과값
			
			cstmt.close();
		
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:call_sp_incom_card_cms_magam]"+e);
			e.printStackTrace();
		} finally {
			try{
            if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
			closeConnection();			
		}
		return sResult;
	}

	
	/**
     * 프로시져 호출
     */
    public String call_sp_tax_ebill_etc(String user_nm, String regcode) 
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
        
//    	String query1 = "{CALL P_TAX_EBILL_ETC		    (?,?,?)}";
    	String query1 = "{CALL P_TAX_EBILL_ETC_NEOE     (?,?,?)}";

	    try{

			//회계처리 프로시저1 호출(조회등록)
			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, user_nm);
			cstmt.setString(2, regcode);
			cstmt.registerOutParameter(3, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값

			cstmt.close();

	  	} catch (Exception e) {
			System.out.println("[AdminDatabase:call_sp_tax_ebill_etc]\n"+e);
			e.printStackTrace();
		} finally {
			try{
				if ( cstmt != null )	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}

	/**
	 * 내부요청자료 13
	 */
	public Vector getInsideReq13(String start_dt, String end_dt, String car_nm) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = "SELECT DISTINCT '신차견적내기' st, a.est_nm, d.user_nm, a.reg_dt, b.car_nm, c.car_name, a.opt, A.COL, a.in_col,	a.garnish_col \r\n"
				+ "FROM   estimate a, car_mng b, car_nm c, users d\r\n"
				+ "WHERE  a.reg_dt >= '"+start_dt+"' \r\n"
				+ "AND a.car_comp_id=b.car_comp_id AND a.car_cd=b.code AND b.car_nm LIKE '%"+car_nm+"%'\r\n"
				+ "AND a.car_id=c.car_id AND a.car_seq=c.car_seq\r\n"
				+ "AND a.reg_id=d.user_id \r\n"
				+ "AND a.job='org' \r\n"
				+ "UNION all\r\n"
				+ "SELECT DISTINCT '고객견적내기' st, a.est_email, d.user_nm, a.reg_dt, b.car_nm, c.car_name, replace(replace(a.opt,chr(10),' '),chr(13),' ') opt, A.COL, a.in_col,	a.garnish_col \r\n"
				+ "FROM   estimate_cu a, car_mng b, car_nm c, users d\r\n"
				+ "WHERE  a.reg_dt >= '"+start_dt+"' \r\n"
				+ "AND a.car_comp_id=b.car_comp_id AND a.car_cd=b.code AND b.car_nm LIKE '%"+car_nm+"%'\r\n"
				+ "AND a.car_id=c.car_id AND a.car_seq=c.car_seq\r\n"
				+ "AND a.reg_id=d.user_id(+) \r\n"
				+ "AND a.job='org' \r\n"
				+ "ORDER BY 1, 4";

		
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getInsideReq13]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}
	
	
	/**
	 * 결산관련자료25 - 카드캐쉬백입금현황
	 */
	public Vector getSettleAccount_list25(String card_kind, String settle_year) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT  a.incom_dt, \r\n"
				+ "       SUM(DECODE(a.tm,1,a.scd_amt,0)) scd_amt, SUM(DECODE(a.tm,1,a.save_amt,0)) save_amt, \r\n"
				+ "       SUM(a.incom_amt) incom_amt, SUM(NVL(a.m_amt,0)) m_amt, \r\n"
				+ "       SUM(a.incom_amt)-SUM(NVL(a.m_amt,0)) r_incom_amt, SUM(DECODE(a.tm,1,a.save_amt,0))-SUM(a.incom_amt) def_amt\r\n"
				+ "FROM  card_stat_scd a \r\n"
				+ "WHERE a.incom_dt LIKE '"+settle_year+"%'\r\n"
				+ "AND a.card_kind='"+card_kind+"' \r\n"
				+ "GROUP BY a.incom_dt \r\n"
				+ "ORDER BY a.incom_dt \r\n"
				+ " ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getSettleAccount_list25]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}	
	
	
	/**
     * 프로시져 호출 - plit (인사/급여 시스템과 연동) 
     */
    public String call_sp_make_plit(String st_year, String st_mon, String gubun) 
	{
		getConnection();

		CallableStatement cstmt = null;
		String sResult = "";
      
    	String query1 = "{CALL P_MAKE_PLIT     (?,?,?,?)}";

	    try{

			//회계처리 프로시저1 호출(조회등록)
			cstmt = conn.prepareCall(query1);				
			cstmt.setString(1, st_year);
			cstmt.setString(2, st_mon);
			cstmt.setString(3, gubun);
			cstmt.registerOutParameter(4, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(4); // 결과값

			cstmt.close();

	  	} catch (Exception e) {
			System.out.println("[AdminDatabase:call_sp_make_plit]\n"+e);
			e.printStackTrace();
		} finally {
			try{
				if ( cstmt != null )	cstmt.close();
			}catch(Exception ignore){}
			closeConnection();
			return sResult;
		}
	}
    
    /**
	 * 외부요청자료 12
	 */
	public Vector getOutsideReq12(String end_dt) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT SUBSTR(b.tax_dt,1,6) tax_m, SUM(a.item_supply) amt, SUM(DECODE(d.fuel_kd,'8',a.item_supply)) e_amt, \r\n"
				+ "       SUM(CASE WHEN TO_NUMBER(e.con_mon) >= 12 THEN a.item_supply end) amt11, \r\n"
				+ "       SUM(CASE WHEN TO_NUMBER(e.con_mon) < 12 THEN a.item_supply end)amt12\r\n"
				+ "FROM   tax_item_list a, tax b, cont c, car_reg d, (SELECT rent_l_cd, sum(con_mon) con_mon FROM fee GROUP BY rent_l_cd) e\r\n"
				+ "WHERE  a.item_id=b.item_id AND b.tax_dt >= replace('"+end_dt+"','-','') AND b.tax_st<>'C'\r\n"
				+ "       AND a.rent_l_cd=c.RENT_L_CD AND c.car_mng_id=d.car_mng_id(+) \r\n"
				+ "       AND c.rent_l_cd=e.rent_l_cd\r\n"
				+ "GROUP BY SUBSTR(b.tax_dt,1,6) \r\n"
				+ "ORDER BY SUBSTR(b.tax_dt,1,6) ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				Hashtable ht = new Hashtable();
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
				vt.add(ht);
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[AdminDatabase:getOutsideReq12]\n" + e);
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return vt;
		}
	}

	
}
