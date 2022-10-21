/**
 * 해지정산 관리
 */
package acar.receive;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.database.*;
import acar.common.*;
import acar.credit.*;
import acar.util.*;

public class ReceiveDatabase {
	private Connection conn = null;
	public static ReceiveDatabase c_db;

	public static ReceiveDatabase getInstance() {
		if (ReceiveDatabase.c_db == null)
			ReceiveDatabase.c_db = new ReceiveDatabase();
		return ReceiveDatabase.c_db;
	}

	private DBConnectionManager connMgr = null;

	private void getConnection() {
		try {
			if (connMgr == null)
				connMgr = DBConnectionManager.getInstance();
			if (conn == null)
				conn = connMgr.getConnection("acar");
		} catch (Exception e) {
			System.out.println(" i can't get a connection........");
		}
	}

	private void closeConnection() {
		if (conn != null) {
			connMgr.freeConnection("acar", conn);
			conn = null;
		}
	}

	/**
	 * 채권조사 insert
	 */
	public boolean insertClsCarExam(ClsCarExamBean cr) {
		getConnection();
		boolean flag = true;

		String query = "insert into cls_car_exam ( " + " RENT_MNG_ID, RENT_L_CD, s_seq, exam_dt, exam_id, "
				+ " s_gu1, s_gu2, s_gu3, s_gu4, s_remark, s_result) values(" + " ?, ?, ?, replace(?, '-', ''), ?," + // 5
				" ?, ?, ?, ?, ?, ? )"; // 6

		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cr.getRent_mng_id());
			pstmt.setString(2, cr.getRent_l_cd());
			pstmt.setInt(3, cr.getS_seq());
			pstmt.setString(4, cr.getExam_dt());
			pstmt.setString(5, cr.getExam_id());
			pstmt.setString(6, cr.getS_gu1());
			pstmt.setString(7, cr.getS_gu2());
			pstmt.setString(8, cr.getS_gu3());
			pstmt.setString(9, cr.getS_gu4());
			pstmt.setString(10, cr.getS_remark());
			pstmt.setString(11, cr.getS_result());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
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

	/* 채권 - 사업장 조사 */
	public ClsCarExamBean getClsCarExam(String rent_mng_id, String rent_l_cd) {
		getConnection();
		ClsCarExamBean carE = new ClsCarExamBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " select " + " a.RENT_MNG_ID, a.RENT_L_CD,  "
				+ " a.s_seq, a.exam_dt, a.exam_id, s_gu1, s_gu2, s_gu3, s_gu4, " + " a.s_remark, s_result "
				+ " from cls_car_exam a , ( select rent_mng_id, rent_l_cd, max(s_seq)  s_seq from cls_car_exam group by rent_mng_id, rent_l_cd ) b \n"
				+ "  where  a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and a.s_seq = b.s_seq and  a.RENT_MNG_ID = ? and a.RENT_L_CD = ? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				carE.setRent_mng_id(rs.getString("RENT_MNG_ID") == null ? "" : rs.getString("RENT_MNG_ID"));
				carE.setRent_l_cd(rs.getString("RENT_L_CD") == null ? "" : rs.getString("RENT_L_CD"));
				carE.setS_seq(rs.getInt("s_seq"));
				carE.setExam_dt(rs.getString("exam_dt") == null ? "" : rs.getString("exam_dt"));
				carE.setExam_id(rs.getString("exam_id") == null ? "" : rs.getString("exam_id"));
				carE.setS_gu1(rs.getString("s_gu1") == null ? "" : rs.getString("s_gu1"));
				carE.setS_gu2(rs.getString("s_gu2") == null ? "" : rs.getString("s_gu2"));
				carE.setS_gu3(rs.getString("s_gu3") == null ? "" : rs.getString("s_gu3"));
				carE.setS_gu4(rs.getString("s_gu4") == null ? "" : rs.getString("s_gu4"));
				carE.setS_remark(rs.getString("s_remark") == null ? "" : rs.getString("s_remark"));
				carE.setS_result(rs.getString("s_result") == null ? "" : rs.getString("s_result"));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ReceiveDatabase:getClsCarExam]\n" + e);
			System.out.println(query);
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
			return carE;
		}
	}

	/* 채권 - 사업장 조사 */
	public ClsCarExamBean getClsCarExam(String rent_mng_id, String rent_l_cd, int s_seq) {
		getConnection();
		ClsCarExamBean carE = new ClsCarExamBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " select " + " a.RENT_MNG_ID, a.RENT_L_CD,  "
				+ " a.s_seq, a.exam_dt, a.exam_id, s_gu1, s_gu2, s_gu3, s_gu4, " + " a.s_remark, s_result "
				+ " from cls_car_exam a  \n" + "  where  a.RENT_MNG_ID = ? and a.RENT_L_CD = ? and a.s_seq = ?  ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			pstmt.setInt(3, s_seq);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				carE.setRent_mng_id(rs.getString("RENT_MNG_ID") == null ? "" : rs.getString("RENT_MNG_ID"));
				carE.setRent_l_cd(rs.getString("RENT_L_CD") == null ? "" : rs.getString("RENT_L_CD"));
				carE.setS_seq(rs.getInt("s_seq"));
				carE.setExam_dt(rs.getString("exam_dt") == null ? "" : rs.getString("exam_dt"));
				carE.setExam_id(rs.getString("exam_id") == null ? "" : rs.getString("exam_id"));
				carE.setS_gu1(rs.getString("s_gu1") == null ? "" : rs.getString("s_gu1"));
				carE.setS_gu2(rs.getString("s_gu2") == null ? "" : rs.getString("s_gu2"));
				carE.setS_gu3(rs.getString("s_gu3") == null ? "" : rs.getString("s_gu3"));
				carE.setS_gu4(rs.getString("s_gu4") == null ? "" : rs.getString("s_gu4"));
				carE.setS_remark(rs.getString("s_remark") == null ? "" : rs.getString("s_remark"));
				carE.setS_result(rs.getString("s_result") == null ? "" : rs.getString("s_result"));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ReceiveDatabase:getClsCarExam]\n" + e);
			System.out.println(query);
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
			return carE;
		}
	}

	/**
	 * 해지차량회수관련삭제 - 담당자 결재요청전
	 */
	/*
	public boolean deleteClsCarExam(String rent_mng_id, String rent_l_cd) {
		getConnection();
		boolean flag = true;
		String query = "delete from cls_car_exam " + " where rent_mng_id = ? and rent_l_cd = ?  "; // 2

		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
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
  */
	/**
	 * 해지차량회수관련삭제 - 담당자 결재요청전
	 */
	/*
	public boolean deleteClsCarGur(String rent_mng_id, String rent_l_cd) {
		getConnection();
		boolean flag = true;
		String query = "delete from cls_car_gur " + " where rent_mng_id = ? and rent_l_cd = ?  "; // 2

		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
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
*/
	
	/**
	 * 차량회수 insert
	 */
	public boolean updateClsCarExam(ClsCarExamBean cce) {
		getConnection();
		boolean flag = true;
		String query = "update cls_car_exam set " + " exam_dt  =  replace(?, '-', ''), exam_id = ?,  " + // 2
				" s_gu1 = ?, s_gu2 =?, s_gu3 = ?, s_gu4= ?,  " + // 4
				" s_remark = ?, s_result = ?  " + // 2
				" where rent_mng_id = ? and rent_l_cd = ? and s_seq = ?  "; // 3

		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, cce.getExam_dt());
			pstmt.setString(2, cce.getExam_id());

			pstmt.setString(3, cce.getS_gu1());
			pstmt.setString(4, cce.getS_gu2());
			pstmt.setString(5, cce.getS_gu3());
			pstmt.setString(6, cce.getS_gu4());

			pstmt.setString(7, cce.getS_remark());
			pstmt.setString(8, cce.getS_result());

			pstmt.setString(9, cce.getRent_mng_id());
			pstmt.setString(10, cce.getRent_l_cd());
			pstmt.setInt(11, cce.getS_seq());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
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
	 * 차량채권 - 회수활동 수정
	 */

	public boolean updateClsCarCredit(CarCreditBean cr) {
		getConnection();
		boolean flag = true;
		String query = "update car_credit set " + " crd_reg_gu1 = ?, crd_reg_gu2 = ?, crd_reg_gu3 = ?, crd_reg_gu4 = ?,"
				+ // 4
				" crd_remark1 = ?, crd_remark2 = ?, crd_remark3 = ?, crd_remark4 = ?, " + // 4
				" crd_req_gu1 = ?, crd_req_gu2 = ?, crd_req_gu3 = ?, crd_req_gu4 = ?," + // 4
				" crd_pri1 = ?, crd_pri2 = ?, crd_pri3 = ?, crd_pri4 = ?, " + // 4
				" upd_id = ? , upd_dt=to_char(sysdate,'YYYYMMdd')   " + // 2(1)
				" where rent_mng_id = ? and rent_l_cd = ?  "; // 2

		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, cr.getCrd_reg_gu1());
			pstmt.setString(2, cr.getCrd_reg_gu2());
			pstmt.setString(3, cr.getCrd_reg_gu3());
			pstmt.setString(4, cr.getCrd_reg_gu4());

			pstmt.setString(5, cr.getCrd_remark1());
			pstmt.setString(6, cr.getCrd_remark2());
			pstmt.setString(7, cr.getCrd_remark3());
			pstmt.setString(8, cr.getCrd_remark4());

			pstmt.setString(9, cr.getCrd_req_gu1());
			pstmt.setString(10, cr.getCrd_req_gu2());
			pstmt.setString(11, cr.getCrd_req_gu3());
			pstmt.setString(12, cr.getCrd_req_gu4());

			pstmt.setString(13, cr.getCrd_pri1());
			pstmt.setString(14, cr.getCrd_pri2());
			pstmt.setString(15, cr.getCrd_pri3());
			pstmt.setString(16, cr.getCrd_pri4());

			pstmt.setString(17, cr.getUpd_id());

			pstmt.setString(18, cr.getRent_mng_id());
			pstmt.setString(19, cr.getRent_l_cd());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
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
	 * 연대보증 insert
	 */
	public boolean insertClsCarGur(ClsCarGurBean cg) {
		getConnection();
		boolean flag = true;

		String query = "insert into cls_car_gur ( " + " RENT_MNG_ID, RENT_L_CD, gu_seq, gu_nm, gu_addr, gu_zip,  "
				+ " gu_tel,gu_rel, plan_st, eff_st, plan_rem, eff_rem) values(" + " ?, ?, ?, ?, ?, ?, " + // 6
				" ?, ?, ?, ?, ?, ? )"; // 6

		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cg.getRent_mng_id());
			pstmt.setString(2, cg.getRent_l_cd());
			pstmt.setInt(3, cg.getGu_seq());
			pstmt.setString(4, cg.getGu_nm());
			pstmt.setString(5, cg.getGu_addr());
			pstmt.setString(6, cg.getGu_zip());
			pstmt.setString(7, cg.getGu_tel());
			pstmt.setString(8, cg.getGu_rel());
			pstmt.setString(9, cg.getPlan_st());
			pstmt.setString(10, cg.getEff_st());
			pstmt.setString(11, cg.getPlan_rem());
			pstmt.setString(12, cg.getEff_rem());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
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

	// 연대보증인 리스트
	public Vector getClsCarGurList(String rent_mng_id, String rent_l_cd) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  * " + " from cls_car_gur " + " where rent_mng_id =? and rent_l_cd =? order by gu_seq";

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
			System.out.println("[RecevieDatabase:getClsCarGurList]\n" + e);
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

	// 연대보증인 리스트

	public ClsCarGurBean getClsCarGurList(String rent_mng_id, String rent_l_cd, String gu_nm) {
		getConnection();
		ClsCarGurBean carE = new ClsCarGurBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " select  * " + " from cls_car_gur "
				+ " where rent_mng_id =? and rent_l_cd =? and gu_nm = ? order by gu_seq";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			pstmt.setString(3, gu_nm);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				carE.setRent_mng_id(rs.getString("RENT_MNG_ID") == null ? "" : rs.getString("RENT_MNG_ID"));
				carE.setRent_l_cd(rs.getString("RENT_L_CD") == null ? "" : rs.getString("RENT_L_CD"));
				carE.setGu_seq(rs.getInt("gu_seq"));
				carE.setGu_nm(rs.getString("gu_nm") == null ? "" : rs.getString("gu_nm"));
				carE.setGu_addr(rs.getString("gu_addr") == null ? "" : rs.getString("gu_addr"));
				carE.setGu_zip(rs.getString("gu_zip") == null ? "" : rs.getString("gu_zip"));
				carE.setGu_tel(rs.getString("gu_tel") == null ? "" : rs.getString("gu_tel"));
				carE.setGu_rel(rs.getString("gu_rel") == null ? "" : rs.getString("gu_rel"));
				carE.setPlan_st(rs.getString("plan_st") == null ? "" : rs.getString("plan_st"));
				carE.setEff_st(rs.getString("eff_st") == null ? "" : rs.getString("eff_st"));
				carE.setPlan_rem(rs.getString("plan_rem") == null ? "" : rs.getString("plan_rem"));
				carE.setEff_rem(rs.getString("eff_rem") == null ? "" : rs.getString("eff_rem"));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ReceiveDatabase:getClsCarGurList]\n" + e);
			System.out.println(query);
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
			return carE;
		}
	}

	// 연대보증인
	public boolean updateClsCarGur(ClsCarGurBean ccg) {
		getConnection();
		boolean flag = true;
		String query = "update cls_car_gur set " + " gu_nm  = ?, gu_addr = ?, gu_zip = ?,  gu_tel = ?, gu_rel = ?,  " + // 5
				" plan_st = ?, eff_st =?,  plan_rem = ?,  eff_rem= ?  " + // 4
				" where rent_mng_id = ? and rent_l_cd = ? and gu_seq = ?  "; // 3

		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, ccg.getGu_nm());
			pstmt.setString(2, ccg.getGu_addr());
			pstmt.setString(3, ccg.getGu_zip());
			pstmt.setString(4, ccg.getGu_tel());
			pstmt.setString(5, ccg.getGu_rel());

			pstmt.setString(6, ccg.getPlan_st());
			pstmt.setString(7, ccg.getEff_st());
			pstmt.setString(8, ccg.getPlan_rem());
			pstmt.setString(9, ccg.getEff_rem());

			pstmt.setString(10, ccg.getRent_mng_id());
			pstmt.setString(11, ccg.getRent_l_cd());
			pstmt.setInt(12, ccg.getGu_seq());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
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

	// 소송/추심비용 등록
	/*
	 * public int insertIOamt(Rece_ioamtBean bean) { getConnection();
	 * PreparedStatement pstmt = null;
	 * 
	 * ResultSet rs = null; Statement stmt = null; int count = 0; String query =
	 * ""; String query_seq = "";
	 * 
	 * int seq = 0;
	 * 
	 * 
	 * query_seq =
	 * "select nvl(max(seq_no)+1, 1)  from RECE_IOAMT where rent_l_cd = '" +
	 * bean.getRent_l_cd() + "'";
	 * 
	 * query = " insert into RECE_IOAMT \n"+
	 * " (RENT_L_CD, SEQ_NO, RENT_MNG_ID, CAR_MNG_ID, IOAMT_ST, AMT_GUBUN, AMT, AMT_DT, AMT_OFF, NOTE, REG_DT, REG_ID,  \n"
	 * +
	 * "  IAMT_GUBUN, IAMT, IAMT_DT, INMG_AMT, OAMT_GUBUN, OAMT, OAMT_DT, IOAMT_OFF \n"
	 * + " ) values ("+ " ?, ?, ?, ?, "+ " ?, ?, ?, replace(?, '-', ''),"+
	 * " ?, ?, to_char(sysdate,'YYYYMMDD'), ?, "+
	 * " ?, ?, replace(?, '-', ''), ?, ?, ?, replace(?, '-', ''), ? ) "+
	 * 
	 * " ";
	 * 
	 * 
	 * try { conn.setAutoCommit(false);
	 * 
	 * stmt = conn.createStatement(); rs = stmt.executeQuery(query_seq);
	 * 
	 * if(rs.next()) seq = rs.getInt(1); rs.close(); stmt.close();
	 * 
	 * pstmt = conn.prepareStatement(query); pstmt.setString(1,
	 * bean.getRent_l_cd()); pstmt.setInt(2, seq); pstmt.setString(3,
	 * bean.getRent_mng_id()); pstmt.setString(4, bean.getCar_mng_id());
	 * pstmt.setString(5, bean.getIoamt_st()); pstmt.setString(6,
	 * bean.getAmt_gubun()); pstmt.setInt(7, bean.getAmt()); pstmt.setString(8,
	 * bean.getAmt_dt()); pstmt.setString(9, bean.getAmt_off());
	 * pstmt.setString(10, bean.getNote()); pstmt.setString(11,
	 * bean.getReg_id());
	 * 
	 * pstmt.setString(12, bean.getIamt_gubun()); pstmt.setInt(13,
	 * bean.getIamt()); pstmt.setString(14, bean.getIamt_dt()); pstmt.setInt(15,
	 * bean.getInmg_amt()); pstmt.setString(16, bean.getOamt_gubun());
	 * pstmt.setInt(17, bean.getOamt()); pstmt.setString(18, bean.getOamt_dt());
	 * pstmt.setString(19, bean.getIoamt_off()); count = pstmt.executeUpdate();
	 * pstmt.close();
	 * 
	 * conn.commit();
	 * 
	 * 
	 * 
	 * } catch (SQLException e) {
	 * System.out.println("[ReceiveDatabase:insertIOamt]\n"+e);
	 * System.out.println("[ReceiveDatabase:insertIOamt]\n"+query);
	 * e.printStackTrace(); count = 0; conn.rollback();
	 * 
	 * } finally { try{ conn.setAutoCommit(true); if(rs != null) rs.close();
	 * if(stmt != null) stmt.close(); if(pstmt != null) pstmt.close();
	 * }catch(Exception ignore){} closeConnection(); return count; } }
	 * 
	 * 
	 * //소송/추심비용리스트 -- public Vector getIoamt_sscslist(String rent_mng_id,
	 * String rent_l_cd) { getConnection(); PreparedStatement pstmt = null;
	 * ResultSet rs = null; Vector vt = new Vector(); String query = "";
	 * 
	 * query = " select  * "+ " from RECE_IOAMT "+
	 * " where rent_mng_id =? and rent_l_cd =? order by seq_no";
	 * 
	 * try{ pstmt = conn.prepareStatement(query); pstmt.setString(1,
	 * rent_mng_id); pstmt.setString(2, rent_l_cd);
	 * 
	 * rs = pstmt.executeQuery(); ResultSetMetaData rsmd = rs.getMetaData();
	 * while(rs.next()) { Hashtable ht = new Hashtable(); for(int pos =1; pos <=
	 * rsmd.getColumnCount();pos++) { String columnName =
	 * rsmd.getColumnName(pos); ht.put(columnName,
	 * (rs.getString(columnName))==null?"":rs.getString(columnName)); }
	 * vt.add(ht); } rs.close(); pstmt.close(); } catch (SQLException e) {
	 * System.out.println("[RecevieDatabase:getIoamt_sscslist]\n"+e);
	 * e.printStackTrace(); } finally { try{ if(rs != null ) rs.close();
	 * if(pstmt != null) pstmt.close(); }catch(Exception ignore){}
	 * closeConnection(); return vt; } }
	 * 
	 * //소송/추심비용 삭제 public int deleteIOamt(String rent_l_cd, String rent_mng_id,
	 * String car_mng_id, String ioamt_st, int seq_no) { getConnection();
	 * PreparedStatement pstmt = null; int count2 = 0; String query = "";
	 * 
	 * query = " delete from RECE_IOAMT "+
	 * " where rent_mng_id ='"+rent_mng_id+"' and rent_l_cd ='"
	 * +rent_l_cd+"' and car_mng_id='"+car_mng_id+"' and ioamt_st = '"
	 * +ioamt_st+"' and seq_no = '"+seq_no+"' ";
	 * 
	 * 
	 * try { conn.setAutoCommit(false);
	 * 
	 * pstmt = conn.prepareStatement(query); count2 = pstmt.executeUpdate();
	 * pstmt.close();
	 * 
	 * conn.commit();
	 * 
	 * } catch (Exception e) {
	 * System.out.println("[RecevieDatabase:deleteIOamt]\n"+e);
	 * System.out.println("[RecevieDatabase:deleteIOamt]\n"+query);
	 * e.printStackTrace(); conn.rollback(); } finally { try{
	 * conn.setAutoCommit(true); if(pstmt != null) pstmt.close();
	 * }catch(Exception ignore){} closeConnection(); return count2; } }
	 */

	/**
	 * 거래처관리 : 거래처조회리스트 - 월렌트 포함
	 */
	public Vector getClsListSearch(String s_br, String s_kd, String t_wd, String use_yn) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

		query = " select a.car_gu, d.cls_st, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.use_yn, a.firm_nm, a.client_nm, c.car_no, c.car_nm, c.car_num, a.rent_start_dt, a.rent_end_dt, d.cls_dt, a.car_st, a.bus_id2 \n"
				+ " from cont_n_view a, car_reg c, cls_cont d  \n"
				+ " where  a.car_mng_id = c.car_mng_id(+) and a.rent_mng_id = d.rent_mng_id(+) and a.rent_l_cd = d.rent_l_cd(+)  and a.client_id <> '000228'  ";

		if (s_kd.equals("1"))
			query += " and a.car_st != '5' and a.firm_nm like '%" + t_wd + "%'";
		else if (s_kd.equals("2"))
			query += " and a.car_st != '5' and c.car_no||' '||c.first_car_no like '%" + t_wd + "%'";
		
        if  ( use_yn.equals("Y") ) {
        	query += "	and a.use_yn in (  'N' , 'Y' ) \n";
        } else {
        	query += "	and a.use_yn = 'N' \n";
        }
		query += " order by  d.cls_dt desc";

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
			System.out.println("[RecevieDatabase:getClsListSearch]\n" + e);
			System.out.println("[RecevieDatabase:getClsListSearch]\n" + query);
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

	public Hashtable getClsContInfo(String rent_mng_id, String rent_l_cd) {
		getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		Hashtable ht = new Hashtable();
		String query = "";

		// code(g.gi_st,'0','면제','1','가입') gi_st"+

		query = " 	 select  b.rent_mng_id, b.rent_l_cd, b.car_mng_id, b.firm_nm, b.client_nm, b.client_id, c.car_no, c.car_nm, cn.car_name,  \n "
				+ "    		 b.bus_id2, b.rent_st, b.r_site, b.mng_id, b.use_yn, d.cls_dt, g.gi_st, b.rent_way, b.rent_start_dt, c.init_reg_dt  \n "
				+ "  		 from cont_n_view b,  cls_cont d , car_reg c,  car_etc g, car_nm cn  \n "
				+ "  	where	 b.rent_mng_id=d.rent_mng_id(+) and b.rent_l_cd=d.rent_l_cd(+) \n "
				+ "  			and b.car_mng_id = c.car_mng_id  and b.rent_mng_id = g.rent_mng_id(+)  and b.rent_l_cd = g.rent_l_cd(+) \n "
				+ "  	      and g.car_id=cn.car_id(+)  and    g.car_seq=cn.car_seq(+) \n "
			//	+ "  			 and a.ext_s_amt is not null and  nvl(a.bill_yn,'Y')='Y'\n "
				+ "  			 and b.rent_mng_id =  '" + rent_mng_id + "'  and b.rent_l_cd = '" + rent_l_cd + "' ";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			ResultSetMetaData rsmd = rs.getMetaData();
			while (rs.next()) {
				for (int pos = 1; pos <= rsmd.getColumnCount(); pos++) {
					String columnName = rsmd.getColumnName(pos);
					ht.put(columnName, (rs.getString(columnName)) == null ? "" : rs.getString(columnName));
				}
			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[RecevieDatabase:getClsContInfo]\n" + e);
			System.out.println("[RecevieDatabase:getClsContInfo]\n" + query);
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

	// 최초 차량 개시일 - rent_st = '1'
	public String getRent_start_dt(String l_cd) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String start_dt = "";
		String query = "";
		query = " select rent_start_dt from fee where rent_st = '1' and rent_l_cd='" + l_cd + "'";

		try {
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				start_dt = rs.getString(1);
			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[RecevieDatabase:getRent_start_dt]\n" + e);
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
			return start_dt;
		}
	}

	/**
	 * 채권추심 insert
	 */
	public boolean insertClsBand(ClsBandBean cr) {
		getConnection();
		boolean flag = true;

		String query = "insert into cls_band ( " + " seq, RENT_MNG_ID, RENT_L_CD,  req_dt, n_ven_code,  n_ven_name,  " + // 6(5)
				" re_rate, re_dept, re_nm, re_fax, re_tel, re_phone, re_mail , " + // 7
				" bank_cd, bank_nm, bank_no, re_bank_cd, re_bank_nm, re_bank_no," + // 6
				"  band_amt, basic_dt, no_re_amt, car_jan_amt, re_st, reg_dt, reg_id , tot_amt, remarks) "
				+ "  values ( " + // 13(12)
				" cls_band_seq.nextval,  ?,  ?,  replace(?, '-', '') ,  ?,  ?, " + "  ?,  ?,  ?,  ?,  ?,  ?,  ?, " + // 7
				" ?,  ?,  ?,  ?,  ?,  ?, " + // 6
				" ?,  replace(?, '-', '') ,  ?,  ?,  ?, sysdate, ?, ?, ? " + " )"; // 13(12)

		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cr.getRent_mng_id());
			pstmt.setString(2, cr.getRent_l_cd());
			pstmt.setString(3, cr.getReq_dt());
			pstmt.setString(4, cr.getN_ven_code());
			pstmt.setString(5, cr.getN_ven_name());

			pstmt.setInt(6, cr.getRe_rate());
			pstmt.setString(7, cr.getRe_dept());
			pstmt.setString(8, cr.getRe_nm());
			pstmt.setString(9, cr.getRe_fax());
			pstmt.setString(10, cr.getRe_tel());
			pstmt.setString(11, cr.getRe_phone());
			pstmt.setString(12, cr.getRe_mail());

			pstmt.setString(13, cr.getBank_cd());
			pstmt.setString(14, cr.getBank_nm());
			pstmt.setString(15, cr.getBank_no());
			pstmt.setString(16, cr.getRe_bank_cd());
			pstmt.setString(17, cr.getRe_bank_nm());
			pstmt.setString(18, cr.getRe_bank_no());

			pstmt.setInt(19, cr.getBand_amt());
			pstmt.setString(20, cr.getBasic_dt());
			pstmt.setInt(21, cr.getNo_re_amt());
			pstmt.setInt(22, cr.getCar_jan_amt());
			pstmt.setString(23, cr.getRe_st());
			pstmt.setString(24, cr.getReg_id());
			pstmt.setInt(25, cr.getTot_amt());
			pstmt.setString(26, cr.getRemarks());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
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
	 * 채권추심 insert
	 */
	public boolean updateClsBand(ClsBandBean cr) {
		getConnection();
		boolean flag = true;

		String query = "update cls_band set  "
				+ " settle_dt = replace(?, '-', '') ,  n_ven_code = ? ,  n_ven_name = ? ,  " + // 3
				" re_rate = ? , re_dept = ?, re_nm = ?, re_fax = ?, re_tel = ?, re_phone = ?, re_mail  = ?, " + // 7
				" bank_cd = ?, bank_nm = ?, bank_no = ? , re_bank_cd = ?, re_bank_nm = ? , re_bank_no = ? ," + // 6
				" band_amt = ? , basic_dt = replace(?, '-', '')  , no_re_amt = ? , car_jan_amt = ? , re_st = ? , " + //5
				" upd_dt = sysdate , upd_id = ?  , tot_amt = ?, remarks = ?  " + //3
				" where  rent_mng_id = ? and  rent_l_cd = ? ";

		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, cr.getSettle_dt());
			pstmt.setString(2, cr.getN_ven_code());
			pstmt.setString(3, cr.getN_ven_name());

			pstmt.setInt(4, cr.getRe_rate());
			pstmt.setString(5, cr.getRe_dept());
			pstmt.setString(6, cr.getRe_nm());
			pstmt.setString(7, cr.getRe_fax());
			pstmt.setString(8, cr.getRe_tel());
			pstmt.setString(9, cr.getRe_phone());
			pstmt.setString(10, cr.getRe_mail());

			pstmt.setString(11, cr.getBank_cd());
			pstmt.setString(12, cr.getBank_nm());
			pstmt.setString(13, cr.getBank_no());
			pstmt.setString(14, cr.getRe_bank_cd());
			pstmt.setString(15, cr.getRe_bank_nm());
			pstmt.setString(16, cr.getRe_bank_no());

			pstmt.setInt(17, cr.getBand_amt());
			pstmt.setString(18, cr.getBasic_dt());
			pstmt.setInt(19, cr.getNo_re_amt());
			pstmt.setInt(20, cr.getCar_jan_amt());
			pstmt.setString(21, cr.getRe_st());
			pstmt.setString(22, cr.getUpd_id());			
			pstmt.setInt(23, cr.getTot_amt());
			pstmt.setString(24, cr.getRemarks());
                    
			pstmt.setString(25, cr.getRent_mng_id());
			pstmt.setString(26, cr.getRent_l_cd());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
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

	/* 추심후 소송 진행 */
	public boolean insertClsSuit(ClsSuitBean cr) {
		getConnection();
		boolean flag = true;

		String query = "insert into cls_suit ( RENT_MNG_ID, RENT_L_CD,  req_dt, REQ_REM,  S_TYPE,  " + // 5
				" SUIT_DT, SUIT_NO, SUIT_AMT, AMT1 , " + // 4
				"   reg_dt, reg_id ) " + "  values ( " + //
				"  ?,  ?,  replace(?, '-', '') ,  ?,  ?, " + // 5
				"  replace(?, '-', ''),  ?,  ?,  ?,  " + // 4
				"  sysdate,  ? " + // 1
				" )"; //

		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cr.getRent_mng_id());
			pstmt.setString(2, cr.getRent_l_cd());
			pstmt.setString(3, cr.getReq_dt());
			pstmt.setString(4, cr.getReq_rem());
			pstmt.setString(5, cr.getS_type());

			pstmt.setString(6, cr.getSuit_dt());
			pstmt.setString(7, cr.getSuit_no());
			pstmt.setInt(8, cr.getSuit_amt());
			pstmt.setInt(9, cr.getAmt1());
			
			pstmt.setString(10, cr.getReg_id());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
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

	// 채권 리스트 조회 - chk:1:수수료 , doc_settle : doc_st: 95->추심수수료
	public Vector getClsBandDocList(String s_kd, String t_wd, String gubun1, String andor, String chk) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

		query = " select  a.car_gu,  b.cls_st , b.cls_dt , a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.use_yn, a.firm_nm, a.client_nm, c.car_no, c.car_nm,  d.req_dt, a.car_st, a.rent_dt, \n"
				+ " decode(b.cls_st,'1','계약만료','2','중도해약', '8', '매입옵션', '7', '출고전해지(신차)', '10', '개시전해지(재리스)',  '14', '월렌트해지' ,  '') cls_st_nm, \n"
				+ " l.doc_no, l.doc_step, l.user_id1, l.user_id2, l.user_id3, l.user_id4,  l.user_dt1, l.user_dt2 , l.user_dt3, l.user_dt4 \n"
				+ " from cont_n_view a, car_reg c, cls_band d ,  cls_etc b , \n"
				+ " (select * from doc_settle where doc_st='95') l \n"
				+ " where  a.car_mng_id = c.car_mng_id(+) and a.rent_mng_id=b.RENT_MNG_ID(+) and a.rent_l_cd=b.rent_l_cd(+) and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd  and a.client_id <> '000228' \n"
				+ " and a.rent_l_cd=l.doc_id(+) \n";

		// if(s_kd.equals("1")) query += " and a.car_st != '4' and a.firm_nm
		// like '%"+t_wd+"%'";
		
		if(gubun1.equals("1"))			query += " and l.user_dt4 is null";//미결
		else if(gubun1.equals("2"))		query += " and l.user_dt4 is not null";//결재- 완결 
		
		if (s_kd.equals("1"))
			query += " and  a.firm_nm like '%" + t_wd + "%'";
		else if (s_kd.equals("2"))
			query += " and a.rent_l_cd like '%" + t_wd + "%'";
		else if (s_kd.equals("3"))
			query += " and  c.car_no||' '||c.first_car_no like '%" + t_wd + "%'";
		
		if(s_kd.equals("5") && gubun1.equals("2") ) {
			if ( !t_wd.equals("")) {
				query += " and d.req_dt like '"+t_wd+"%'";			
			}
		}
		
		query += " order by  d.req_dt desc";

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
			System.out.println("[RecevieDatabase:getClsBandDocList]\n" + e);
			System.out.println("[RecevieDatabase:getClsBandDocList]\n" + query);
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

	// 리스트 조회 - chk:1:수수료 , doc_settle : doc_st: 95->추심수수료
	public Vector getClsBandDocList(String chk, String gubun0, String gubun2, String st_dt, String end_dt, String s_kd, String t_wd, String sort_gubun, String asc) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

		query = " select  a.car_gu,  b.cls_st , b.cls_dt , a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.use_yn, cl.firm_nm, cl.client_nm, c.car_no, c.car_nm,  d.req_dt, a.car_st, a.rent_dt, \n"
				+ " decode(b.cls_st,'1','계약만료','2','중도해약', '8', '매입옵션', '7', '출고전해지(신차)', '10', '개시전해지(재리스)',  '14', '월렌트해지' ,  '') cls_st_nm, \n"
				+ " d.settle_dt, d.n_ven_code, d.n_ven_name, d.re_rate, d.tot_amt , e.ip_amt , e.draw_amt, e.rate_amt, d.seize_amt, \n"
				+ " cl.client_st, nvl(cl.enp_no, TEXT_DECRYPT(cl.ssn, 'pw' ) ) enp_no,  TEXT_DECRYPT(cl.ssn, 'pw' ) ssn , substr(TEXT_DECRYPT(cl.ssn, 'pw' ), 1, 6) ssn1 , \n"
			    + " decode(b.cls_st,'1','계약만료','2','중도해약', '8', '매입옵션', '7', '출고전해지(신차)', '10', '개시전해지(재리스)',  '14', '월렌트해지' ,  '') cls_st_nm , \n"
				+ " s.suit_amt , s.amt1 , s.amt2 , d.settle_dt ,  \n"
			    +"  decode( a.use_yn, 'N', decode(b.cls_st, '14' , '월렌트', '장기렌트' ) , '' )   gubun_nm  \n"
				+ " from cont a, car_reg c, cls_band d ,  cls_etc b , cls_suit s, client cl,  \n"
				+ " ( select rent_mng_id, rent_l_cd ,  sum(draw_amt) draw_amt, sum(ip_amt) ip_amt ,  sum(rate_amt) rate_amt from cls_band_etc group by rent_mng_id, rent_l_cd ) e   \n"
				+ " where  a.car_mng_id = c.car_mng_id(+) and a.rent_mng_id=b.RENT_MNG_ID(+) and a.rent_l_cd=b.RENT_L_CD(+) and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd  \n"
				+ " 	and a.rent_mng_id = e.rent_mng_id(+) and a.rent_l_cd = e.rent_l_cd(+)  \n"
				+ " 	and a.rent_mng_id = s.rent_mng_id(+) and a.rent_l_cd = s.rent_l_cd(+)  \n"
				+ " 	and a.client_id <> '000228' and a.client_id = cl.client_id \n";

		/* 상세조회 */
		// 청구일자
		if (gubun0.equals("1")) {
			if (gubun2.equals("1")) {
				query += " and d.req_dt like to_char(SYSDATE, 'YYYY')||'%' "; // 당해
			} else if (gubun2.equals("2")) {
				query += " and d.req_dt like to_char(sysdate,'YYYYMM')||'%' ";
			} else if (gubun2.equals("4")) {
				query += " and d.req_dt BETWEEN  replace('" + st_dt + "' , '-', '')  AND replace('" + end_dt
						+ "', '-', '') ";
			} else if (gubun2.equals("6")) {
				query += "and d.req_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
			}
		} else { // 해지
			if (gubun2.equals("1")) {
				query += " and b.cls_dt like to_char(SYSDATE, 'YYYY')||'%' ";
			} else if (gubun2.equals("2")) {
				query += " and b.cls_dt like to_char(sysdate,'YYYYMM')||'%' ";
			} else if (gubun2.equals("4")) {
				query += " and b.cls_dt BETWEEN  replace('" + st_dt + "' , '-', '')  AND replace('" + end_dt
						+ "', '-', '') ";
			} else if (gubun2.equals("6")) {
				query += "and b.cls_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
			}
		}

		if (s_kd.equals("1"))
			query += " and a.car_st != '5' and a.firm_nm like '%" + t_wd + "%'";
		else if (s_kd.equals("3"))
			query += " and a.car_st != '5' and d.rent_l_cd '%" + t_wd + "%'";
		else if (s_kd.equals("4"))
			query += " and a.car_st != '5' and c.car_no||' '||c.first_car_no like '%" + t_wd + "%'";
		else if (s_kd.equals("5"))
			query += " and a.car_st != '5' and d.n_ven_name like '%" + t_wd + "%'";

	    if (chk.equals("Y")) 
	    	query += " and ( e.draw_amt > 0 or d.seize_amt > 0 or s.amt1 > 0) ";
	    		
		query += " order by  d.req_dt desc";

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
			System.out.println("[RecevieDatabase:getClsBandDocList]\n" + e);
			System.out.println("[RecevieDatabase:getClsBandDocList]\n" + query);
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

	// 추심정보
	public ClsBandBean getClsBandInfo(String rent_mng_id, String rent_l_cd) {
		getConnection();
		ClsBandBean carB = new ClsBandBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " select  * " + " from cls_band " + " where rent_mng_id =? and rent_l_cd =? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				carB.setSeq(rs.getInt("seq"));
				carB.setRent_mng_id(rs.getString("RENT_MNG_ID") == null ? "" : rs.getString("RENT_MNG_ID"));
				carB.setRent_l_cd(rs.getString("RENT_L_CD") == null ? "" : rs.getString("RENT_L_CD"));

				carB.setReq_dt(rs.getString("req_dt") == null ? "" : rs.getString("req_dt"));
				carB.setN_ven_code(rs.getString("n_ven_code") == null ? "" : rs.getString("n_ven_code"));
				carB.setN_ven_name(rs.getString("n_ven_name") == null ? "" : rs.getString("n_ven_name"));
				carB.setRe_rate(rs.getInt("re_rate"));
				carB.setRe_dept(rs.getString("re_dept") == null ? "" : rs.getString("re_dept"));
				carB.setRe_nm(rs.getString("re_nm") == null ? "" : rs.getString("re_nm"));

				carB.setRe_fax(rs.getString("re_fax") == null ? "" : rs.getString("re_fax"));
				carB.setRe_tel(rs.getString("re_tel") == null ? "" : rs.getString("re_tel"));
				carB.setRe_phone(rs.getString("re_phone") == null ? "" : rs.getString("re_phone"));
				carB.setRe_mail(rs.getString("re_mail") == null ? "" : rs.getString("re_mail"));
				carB.setBank_cd(rs.getString("bank_cd") == null ? "" : rs.getString("bank_cd"));
				carB.setBank_nm(rs.getString("bank_nm") == null ? "" : rs.getString("bank_nm"));
				carB.setBank_no(rs.getString("bank_no") == null ? "" : rs.getString("bank_no"));
				carB.setRe_bank_cd(rs.getString("re_bank_cd") == null ? "" : rs.getString("re_bank_cd"));
				carB.setRe_bank_nm(rs.getString("re_bank_nm") == null ? "" : rs.getString("re_bank_nm"));
				carB.setRe_bank_no(rs.getString("re_bank_no") == null ? "" : rs.getString("re_bank_no"));
				carB.setBand_amt(rs.getInt("band_amt"));
				carB.setBasic_dt(rs.getString("basic_dt") == null ? "" : rs.getString("basic_dt"));
				carB.setNo_re_amt(rs.getInt("no_re_amt"));
				carB.setCar_jan_amt(rs.getInt("car_jan_amt"));
				carB.setTot_amt(rs.getInt("tot_amt"));
				carB.setRe_st(rs.getString("re_st") == null ? "" : rs.getString("re_st"));
				carB.setSettle_dt(rs.getString("settle_dt") == null ? "" : rs.getString("settle_dt"));
				carB.setRemarks(rs.getString("remarks") == null ? "" : rs.getString("remarks"));
				carB.setSeize_dt(rs.getString("seize_dt") == null ? "" : rs.getString("seize_dt"));
				carB.setSeize_amt(rs.getInt("seize_amt"));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ReceiveDatabase:getClsBandInfo]\n" + e);
			System.out.println(query);
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
			return carB;
		}
	}

	/**
	 * 채권추심 수수료 insert
	 */
	public boolean insertClsBandEtc(ClsBandEtcBean cr) {
		getConnection();
		boolean flag = true;

		int seq = 0;

		String query_seq = "select nvl(max(seq)+1, 1)  from cls_band_etc  where rent_mng_id  = '" + cr.getRent_mng_id()
				+ "'  and rent_l_cd = '" + cr.getRent_l_cd() + "'";

		String query = "insert into cls_band_etc ( " + " RENT_MNG_ID, RENT_L_CD, seq,   band_st, band_ip_dt,  " + // 5
				" draw_amt, ip_amt, rate_amt, rate_jp_dt , " + // 4
				"  reg_dt, reg_id , user_id1, user_id2 ) " + "  values ( " + "  ?,  ?,  ?, ?,  replace(?, '-', '') ,  "
				+ "  ?,  ?,  ?,   replace(?, '-', '') ,  " + // 4
				"  sysdate, ? , ? , ? " + " )";

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Statement stmt = null;

		try {
			conn.setAutoCommit(false);

			stmt = conn.createStatement();
			rs = stmt.executeQuery(query_seq);
			if (rs.next())
				seq = rs.getInt(1);
			rs.close();
			stmt.close();

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cr.getRent_mng_id());
			pstmt.setString(2, cr.getRent_l_cd());
			pstmt.setInt(3, seq);
			pstmt.setString(4, cr.getBand_st());
			pstmt.setString(5, cr.getBand_ip_dt());

			pstmt.setInt(6, cr.getDraw_amt());
			pstmt.setInt(7, cr.getIp_amt());
			pstmt.setInt(8, cr.getRate_amt());
			pstmt.setString(9, cr.getRate_jp_dt());

			pstmt.setString(10, cr.getReg_id());
			pstmt.setString(11, cr.getUser_id1());
			pstmt.setString(12, cr.getUser_id2()); // 총무팀장

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
			e.printStackTrace();
			flag = false;
			conn.rollback();
		} finally {
			try {
				conn.setAutoCommit(true);
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return flag;
		}
	}

	// 채권추심 - 수수료 리스트
	public Vector getClsBandEtcList(String rent_mng_id, String rent_l_cd) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String where = "";

		query = " select   a.rent_mng_id, a.rent_l_cd, a.seq,  a.band_st, a.draw_amt, a.band_ip_dt , a.rate_jp_dt , a.rate_amt , a.user_id1, a.user_dt1, a.user_id2, a.user_dt2  \n"
				+ " from cls_band_etc a \n" + " where  a.rent_mng_id = '" + rent_mng_id + "' and  a.rent_l_cd = '"
				+ rent_l_cd + "' ";
		query += " order by  a.seq  desc";

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
			System.out.println("[RecevieDatabase:getClsBandEtcList]\n" + e);
			System.out.println("[RecevieDatabase:getClsBandEtcList]\n" + query);
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

	// 추심정보
	public ClsBandEtcBean getClsBandEtcInfo(String rent_mng_id, String rent_l_cd, String seq) {
		getConnection();
		ClsBandEtcBean carB = new ClsBandEtcBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		int i_seq = AddUtil.parseInt(seq);

		query = " select  * " + " from cls_band_etc " + " where rent_mng_id =? and rent_l_cd =? and seq = ? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			pstmt.setInt(3, i_seq);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				carB.setRent_mng_id(rs.getString("RENT_MNG_ID") == null ? "" : rs.getString("RENT_MNG_ID"));
				carB.setRent_l_cd(rs.getString("RENT_L_CD") == null ? "" : rs.getString("RENT_L_CD"));
				carB.setSeq(rs.getInt("seq"));

				carB.setBand_st(rs.getString("band_st") == null ? "" : rs.getString("band_st"));
				carB.setBand_ip_dt(rs.getString("band_ip_dt") == null ? "" : rs.getString("band_ip_dt"));
				carB.setDraw_amt(rs.getInt("draw_amt"));
				carB.setIp_amt(rs.getInt("ip_amt"));
				carB.setRate_amt(rs.getInt("rate_amt"));
				carB.setRate_jp_dt(rs.getString("rate_jp_dt") == null ? "" : rs.getString("rate_jp_dt"));

				carB.setUser_id1(rs.getString("user_id1") == null ? "" : rs.getString("user_id1"));
				carB.setUser_dt1(rs.getString("user_dt1") == null ? "" : rs.getString("user_dt1"));
				carB.setUser_id2(rs.getString("user_id2") == null ? "" : rs.getString("user_id2"));
				carB.setUser_dt2(rs.getString("user_dt2") == null ? "" : rs.getString("user_dt2"));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[ReceiveDatabase:getClsBandEtcInfo]\n" + e);
			System.out.println(query);
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
			return carB;
		}
	}

	public boolean updateClsBandEtc(String rent_mng_id, String rent_l_cd, String seq, String doc_bit) {
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update cls_band_etc set user_dt" + doc_bit
				+ "=sysdate where rent_mng_id=? and rent_l_cd = ? and seq = ? ";

		int i_seq = AddUtil.parseInt(seq);

		try {
			conn.setAutoCommit(false);

			if (!doc_bit.equals("")) {
				pstmt = conn.prepareStatement(query);
				pstmt.setString(1, rent_mng_id);
				pstmt.setString(2, rent_l_cd);
				pstmt.setInt(3, i_seq);
				pstmt.executeUpdate();
				pstmt.close();
			}

			conn.commit();

		} catch (Exception e) {
			System.out.println("[ReceiveDatabase:updateClsBandEtc]\n" + e);
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

	// 추심종결
	public boolean updateSettleDt(String rent_mng_id, String rent_l_cd, String settle_dt, String user_id) {
		getConnection();
		PreparedStatement pstmt = null;
		boolean flag = true;
		String query = "";

		query = " update cls_band set settle_dt = replace(?, '-', '')  , upd_dt = sysdate , upd_id =?  where rent_mng_id=? and rent_l_cd = ?  ";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, settle_dt);
			pstmt.setString(2, user_id);
			pstmt.setString(3, rent_mng_id);
			pstmt.setString(4, rent_l_cd);

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
			System.out.println("[ReceiveDatabase:updateSettleDt]\n" + e);
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
	 * 보증보험 청구료 insert
	 */
	public boolean insertClsGuar(ClsGuarBean cr) {
		getConnection();
		boolean flag = true;

		String query = "insert into cls_guar ( " + " RENT_MNG_ID, RENT_L_CD,   req_dt, req_amt,  " + // 4
				" guar_nm, guar_tel, damdang_id,  bank_nm, bank_no,  " + // 5
				"  reg_dt, reg_id ) " + "  values ( " + "  ?,  ?, replace(?, '-', '') ,  ?,   "
				+ "  ?,  ?,  ?,  ?,  ?,    " + // 6
				"  sysdate, ? " + " )";

		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, cr.getRent_mng_id());
			pstmt.setString(2, cr.getRent_l_cd());
			pstmt.setString(3, cr.getReq_dt());
			pstmt.setInt(4, cr.getReq_amt());

			pstmt.setString(5, cr.getGuar_nm());
			pstmt.setString(6, cr.getGuar_tel());
			pstmt.setString(7, cr.getDamdang_id());
			pstmt.setString(8, cr.getBank_nm());
			pstmt.setString(9, cr.getBank_no());

			pstmt.setString(10, cr.getReg_id());

			pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (Exception e) {
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

	// 보증보험청구정보
	public ClsGuarBean getClsGuarInfo(String rent_mng_id, String rent_l_cd) {
		getConnection();
		ClsGuarBean carB = new ClsGuarBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " select  * " + " from cls_guar " + " where rent_mng_id =? and rent_l_cd =? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				carB.setRent_mng_id(rs.getString("RENT_MNG_ID") == null ? "" : rs.getString("RENT_MNG_ID"));
				carB.setRent_l_cd(rs.getString("RENT_L_CD") == null ? "" : rs.getString("RENT_L_CD"));

				carB.setReq_dt(rs.getString("req_dt") == null ? "" : rs.getString("req_dt"));
				carB.setReq_amt(rs.getInt("req_amt"));
				carB.setN_ven_code(rs.getString("n_ven_code") == null ? "" : rs.getString("n_ven_code"));
				carB.setN_ven_name(rs.getString("n_ven_name") == null ? "" : rs.getString("n_ven_name"));
				carB.setGuar_nm(rs.getString("guar_nm") == null ? "" : rs.getString("guar_nm"));
				carB.setGuar_tel(rs.getString("guar_tel") == null ? "" : rs.getString("guar_tel"));
				carB.setDamdang_id(rs.getString("damdang_id") == null ? "" : rs.getString("damdang_id"));
				carB.setBank_cd(rs.getString("bank_cd") == null ? "" : rs.getString("bank_cd"));
				carB.setBank_nm(rs.getString("bank_nm") == null ? "" : rs.getString("bank_nm"));
				carB.setBank_no(rs.getString("bank_no") == null ? "" : rs.getString("bank_no"));
				carB.setIp_dt(rs.getString("ip_dt") == null ? "" : rs.getString("ip_dt"));
				carB.setIp_amt(rs.getInt("ip_amt"));
				carB.setRemark(rs.getString("remark") == null ? "" : rs.getString("remark"));
				carB.setP_st(rs.getString("p_st") == null ? "" : rs.getString("p_st"));

			}
			rs.close();
			pstmt.close();

		} catch (SQLException e) {
			System.out.println("[ReceiveDatabase:getClsGuarInfo]\n" + e);
			System.out.println(query);
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
			return carB;
		}
	}

	/**
	 * 보증보험 단계
	 */
	public boolean updateClsGuarSt(String rent_mng_id, String rent_l_cd, String p_st) {
		getConnection();
		boolean flag = true;
		String query = "update cls_guar set " + " p_st = ?, upd_dt = sysdate  " + // 2
				" where rent_mng_id = ? and rent_l_cd = ?  "; // 3

		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, p_st);
			pstmt.setString(2, rent_mng_id);
			pstmt.setString(3, rent_l_cd);

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
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
	 * 보증보험 입금
	 */
	public boolean updateClsGuarIp(ClsGuarBean cr) {
		getConnection();
		boolean flag = true;
		String query = "update cls_guar set "
				+ " ip_dt = replace(?, '-', '') , ip_amt = ?,  remark = ? , upd_id= ?,  upd_dt = sysdate  " + // 2
				" where rent_mng_id = ? and rent_l_cd = ?  "; // 3

		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, cr.getIp_dt());
			pstmt.setInt(2, cr.getIp_amt());
			pstmt.setString(3, cr.getRemark());
			pstmt.setString(4, cr.getUpd_id());
			pstmt.setString(5, cr.getRent_mng_id());
			pstmt.setString(6, cr.getRent_l_cd());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
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
	 * 보증보험 입금 전 삭제
	 */
	public boolean deleteClsGuarIp(String rent_mng_id, String rent_l_cd ) {
		getConnection();
		boolean flag = true;
		
		String query = "delete from cls_guar " + 
						" where rent_mng_id = ? and rent_l_cd = ?  "; // 2

		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
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

	// 보증보험 진행현황
	public Vector getClsGurDocList(String s_kd, String t_wd, String gubun1, String andor, String chk) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  \n"
				+ " a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, b.req_dt, d.cls_dt, d.cls_st,\n"
				+ " a.rent_dt, a.firm_nm, c.car_no, c.car_nm, a.rent_start_dt, \n"
				+ " b.req_amt, b.guar_nm, b.guar_tel, b.ip_amt, b.ip_dt,  g.gi_amt, g.gi_no , g.gi_start_dt , g.gi_end_dt   \n"
				+ " from cont_n_view a, cls_guar b,  car_reg c,  cls_cont d ,  \n"
				+ "  ( select a.* from gua_ins a, (select rent_mng_id, rent_l_cd , max(to_number(rent_st)) rent_st  , max(gi_dt) gi_dt  from gua_ins group by rent_mng_id, rent_l_cd ) b \n"
				+ "				where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and a.rent_st = b.rent_st  and a.gi_dt=b.gi_dt) g \n"
				+ " where a.car_st<>'2' \n" + " and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd \n"
				+ " and a.rent_mng_id=d.RENT_MNG_ID and a.rent_l_cd=d.rent_l_cd \n" +
				" and a.rent_mng_id=g.RENT_MNG_ID and a.rent_l_cd=g.rent_l_cd \n"
				+ " and  a.car_mng_id = c.car_mng_id(+) ";

		if (s_kd.equals("1"))
			query += " and nvl(a.firm_nm, ' ') like '%" + t_wd + "%'";
		if (s_kd.equals("2"))
			query += " and nvl(a.rent_l_cd, ' ') like '%" + t_wd + "%'";
		if (s_kd.equals("3"))
			query += " and nvl(c.car_no, ' ') like '%" + t_wd + "%'";
		if (s_kd.equals("4"))
			query += " and nvl(i.user_nm, ' ') like '%" + t_wd + "%'";

		if (s_kd.equals("5") && gubun1.equals("2")) {
			if (!t_wd.equals("")) {
				query += " and b.req_dt like '" + t_wd + "%'";
			} else {
				if (chk.equals("2")) {
					query += " and  b.req_dt like to_char(sysdate, 'yyyy')||'%'";
				} else {
					query += " and  b.req_dt like to_char(sysdate,'YYYYMM')||'%'";
				}
			}

		}

		query += " order by b.req_dt desc , a.rent_dt, a.rent_start_dt, a.rent_mng_id";

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
			System.out.println("[ReceiveDatabase:getClsGurDocList]\n" + e);
			System.out.println("[ReceiveDatabase:getClsGurDocList]\n" + query);
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

	// 보증보험 진행현황
	public Vector getClsGurDocList(String br_id, String gubun0, String gubun2, String st_dt, String end_dt, String s_kd,
			String t_wd, String sort_gubun, String asc) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select  \n"
				+ " a.rent_mng_id, a.rent_l_cd, a.client_id, a.car_mng_id, b.req_dt, d.cls_dt, d.cls_st,\n"
				+ " a.rent_dt, a.firm_nm, c.car_no, c.car_nm, a.rent_start_dt, decode(nvl(c.prepare, '1'), '9', '9', '4', '4',  '1')  prepare , \n"
				+ " b.req_amt, b.guar_nm, b.guar_tel, b.ip_amt, b.ip_dt,  g.gi_amt, g.gi_no , g.gi_start_dt , g.gi_end_dt   \n"
				+ " from cont_n_view a, cls_guar b,  car_reg c,  cls_cont d ,  \n"
				+ "  ( select a.* from gua_ins a, (select rent_mng_id, rent_l_cd , max(to_number(rent_st)) rent_st  , max(gi_dt) gi_dt  from gua_ins group by rent_mng_id, rent_l_cd ) b \n"
				+ "				where a.rent_mng_id = b.rent_mng_id and a.rent_l_cd = b.rent_l_cd and a.rent_st = b.rent_st  and a.gi_dt=b.gi_dt) g \n"
				+ " where a.car_st<>'2' \n" + " and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd \n"
				+ " and a.rent_mng_id=d.RENT_MNG_ID and a.rent_l_cd=d.rent_l_cd \n" +
				" and a.rent_mng_id=g.RENT_MNG_ID and a.rent_l_cd=g.rent_l_cd \n"
				+ " and  a.car_mng_id = c.car_mng_id(+) ";

		/* 상세조회 */
		// 청구일자
		if (gubun0.equals("1")) {
			if (gubun2.equals("1")) {
				query += " and b.req_dt like to_char(SYSDATE, 'YYYY')||'%' "; // 당해
			} else if (gubun2.equals("2")) {
				query += " and b.req_dt like to_char(sysdate,'YYYYMM')||'%' ";
			} else if (gubun2.equals("4")) {
				query += " and b.req_dt BETWEEN  replace('" + st_dt + "' , '-', '')  AND replace('" + end_dt
						+ "', '-', '') ";
			} else if (gubun2.equals("6")) {
				query += "and b.req_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
			}
		} else { // 입금일자
			if (gubun2.equals("1")) {
				query += " and b.ip_dt like to_char(SYSDATE, 'YYYY')||'%' ";
			} else if (gubun2.equals("2")) {
				query += " and b.ip_dt like to_char(sysdate,'YYYYMM')||'%' ";
			} else if (gubun2.equals("4")) {
				query += " and b.ip_dt BETWEEN  replace('" + st_dt + "' , '-', '')  AND replace('" + end_dt
						+ "', '-', '') ";
			} else if (gubun2.equals("6")) {
				query += "and b.ip_dt like to_char(add_months(to_date(to_char(sysdate,'YYYYMMDD')), -1), 'yyyymm')||'%' ";
			}
		}

		if (s_kd.equals("3"))
			query += " and upper(a.rent_l_cd) like upper('%" + t_wd + "%')\n";
		else if (s_kd.equals("4"))
			query += " and nvl(c.car_no, '') like '%" + t_wd + "%'\n";		
		else
			query += " and nvl(a.firm_nm, '') like '%" + t_wd + "%'\n";

		// 검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0") ? " asc" : " desc";

		/* 정렬조건 */
		if (sort_gubun.equals("0"))
			query += " order by b.req_dt " + sort + ", a.firm_nm ";
		if (sort_gubun.equals("1"))
			query += " order by b.ip_dt " + sort + ", a.firm_nm";

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
			System.out.println("[ReceiveDatabase:getClsGurDocList]\n" + e);
			System.out.println("[ReceiveDatabase:getClsGurDocList]\n" + query);
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

	// 해지 - 자동이관 리스트

	public Vector getClsFeeScdList(String gubun2, String gubun5, String st_dt, String end_dt, String s_kd, String t_wd,
			String sort_gubun, String asc) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		// 정산금
		String query1 = "";

		query1 = " select  \n"
				+ " '정산금' cls_gubun, a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.firm_nm, b.client_nm, b.client_id, e.enp_no, e.ssn, \n"
				+ " c.car_no, c.car_nm,cn.car_name, decode(a.ext_pay_dt, '','미수금','수금') gubun, a.ext_s_amt as s_amt, (nvl(a.ext_s_amt,0)+nvl(a.ext_v_amt,0)) as amt,"
				+ " a.ext_tm as tm, decode(a.ext_tm,'1','','(잔)') tm_st, a.dly_amt, to_number(a.dly_days) as dly_days, b.bus_id2, b.rent_st, b.r_site, b.mng_id, b.use_yn, \n"
				+ " d.cls_dt, nvl(nvl(d.cls_est_dt, a.ext_est_dt), d.cls_dt)  as est_dt, a.ext_pay_dt as pay_dt,  decode(nvl(c.prepare, '1'), '9', '9', '4', '4',  '1')  prepare, \n"
				+ " decode(ce.gi_st,'0','면제','1','가입') gi_st, g.gi_amt gi_amt  \n"
				+ " from scd_ext a, cont_n_view b,  cls_cont d,   car_reg c,  car_etc ce, car_nm cn ,   "
				+ "	   (select a.* from gua_ins a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, max(gi_dt) gi_dt from gua_ins group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.gi_dt=b.gi_dt) g, "
				+ "	   client e " + " where\n"
				+ " a.ext_st = '4' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "
				+ " and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd   "
				+ " and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+) "
				+ " and b.client_id=e.client_id "
				+ "	and b.car_mng_id = c.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"
				+ "	and ce.car_id=cn.car_id(+)  and   ce.car_seq=cn.car_seq(+)  \n"
				+ " and (a.ext_s_amt+a.ext_v_amt) >0  and nvl(a.bill_yn,'Y')='Y' and a.ext_pay_dt is null ";// d.cls_dt
																											// >
																											// '20030531'
		// 해지대여료/
		String query2 = "";

		// 합체
		String query = " select * from ( \n" + query1 + "\n ) where rent_l_cd is not null ";

		/* 상세조회&&세부조회 */
		if (gubun2.equals("1")) {
			query += " and cls_dt <= to_char(sysdate,'YYYYMMDD') and pay_dt is null";
			// 기간-미수금
		} else if (gubun2.equals("4")) {
			query += " and est_dt BETWEEN  replace('" + st_dt + "' , '-', '')  AND replace('" + end_dt
					+ "', '-', '')  and pay_dt is null";
		}

		/* 검색조건 */

		if (s_kd.equals("2"))
			query += " and nvl(client_nm, '') like '%" + t_wd + "%'\n";
		else if (s_kd.equals("3"))
			query += " and upper(rent_l_cd) like upper('%" + t_wd + "%')\n";
		else if (s_kd.equals("4"))
			query += " and nvl(car_no, '') like '%" + t_wd + "%'\n";
		else if (s_kd.equals("5"))
			query += " and est_dt like '" + t_wd + "%'\n";
		else if (s_kd.equals("6"))
			query += " and substr(rent_l_cd,1,2) like upper('%" + t_wd + "%')\n";
		else if (s_kd.equals("7"))
			query += " and nvl(r_site, '') like '%" + t_wd + "%'\n";
		else if (s_kd.equals("8"))
			query += " and bus_id2= '" + t_wd + "'\n";
		else if (s_kd.equals("11"))
			query += " and mng_id= '" + t_wd + "'\n";
		else if (s_kd.equals("9"))
			query += " and car_nm||car_name like '%" + t_wd + "%'\n";
		else if (s_kd.equals("10"))
			query += " and nvl(cls_dt, '') like '%" + t_wd + "%'\n";
		else
			query += " and nvl(firm_nm, '') like '%" + t_wd + "%'\n";

		// 검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0") ? " asc" : " desc";

		/* 정렬조건 */

		// if(sort_gubun.equals("0")) query += " order by
		// decode(bus_id2,'000004','0','000006','1','2') desc, use_yn desc,
		// est_dt "+sort+", pay_dt, firm_nm";
		if (sort_gubun.equals("0"))
			query += " order by prepare,  cls_dt " + sort + ", pay_dt, firm_nm";

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
			System.out.println("[ReceiveDatabase:getClsFeeScdList]\n" + e);
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
	 * 통합채권으로 이관
	 */
	public boolean insertClsTrans(String rent_mng_id, String rent_l_cd, String reg_id) {
		getConnection();
		boolean flag = true;

		String query = "insert into cls_trans ( " + " RENT_MNG_ID, RENT_L_CD,  trans_dt, reg_id,  reg_dt ) values ("
				+ " ?, ?,  to_char(sysdate,'YYYYMMdd') , ?,  sysdate )"; // 5

		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			pstmt.setString(3, reg_id);
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
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

	// 해지 - 자동이관 리스트

	public Vector getClsTransList(String gubun2, String st_dt, String end_dt, String s_kd, String t_wd,
			String sort_gubun, String asc) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		// 정산금
		String query1 = "";

		query1 = " select  \n"
				+ " '정산금' cls_gubun, a.rent_mng_id, a.rent_l_cd, b.car_mng_id, b.firm_nm, b.client_nm, b.client_id, e.enp_no, e.ssn, \n"
				+ " c.car_no, c.car_nm,cn.car_name, decode(a.ext_pay_dt, '','미수금','수금') gubun, a.ext_s_amt as s_amt, (nvl(a.ext_s_amt,0)+nvl(a.ext_v_amt,0)) as amt,"
				+ " a.ext_tm as tm, decode(a.ext_tm,'1','','(잔)') tm_st, a.dly_amt, to_number(a.dly_days) as dly_days, b.bus_id2, b.rent_st, b.r_site, b.mng_id, b.use_yn, \n"
				+ " d.cls_dt, nvl(nvl(d.cls_est_dt, a.ext_est_dt), d.cls_dt)  as est_dt, a.ext_pay_dt as pay_dt,  decode(nvl(c.prepare, '1'), '9', '9', '4', '4',  '1')  prepare, \n"
				+ " decode(ce.gi_st,'0','면제','1','가입') gi_st, g.gi_amt gi_amt  \n"
				+ " from scd_ext a, cont_n_view b,  cls_cont d,   car_reg c,  car_etc ce, car_nm cn, "
				+ "	   (select a.* from gua_ins a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, max(gi_dt) gi_dt from gua_ins group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.gi_dt=b.gi_dt) g, "
				+ "	   client e " + " where\n"
				+ " a.ext_st = '4' and a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd "
				+ " and a.rent_mng_id=d.rent_mng_id and a.rent_l_cd=d.rent_l_cd   "
				+ " and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+) "
				+ " and b.client_id=e.client_id "
				+ "	and b.car_mng_id = c.car_mng_id  and a.rent_mng_id = ce.rent_mng_id(+)  and a.rent_l_cd = ce.rent_l_cd(+)  \n"
				+ "	and ce.car_id=cn.car_id(+)  and   ce.car_seq=cn.car_seq(+)  \n"
				+ " and (a.ext_s_amt+a.ext_v_amt) >0  and nvl(a.bill_yn,'Y')='Y' and a.ext_pay_dt is null ";// d.cls_dt
																											// >
																											// '20030531'
		// 해지대여료/
		String query2 = "";
		/*
		 * query2 =
		 * " select '대여료' cls_gubun, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.firm_nm, a.client_nm, '' client_id, e.enp_no, e.ssn, "
		 * +
		 * " a.car_no, a.car_nm, a.car_name, decode(a.rc_yn, '1', '수금','미수금') gubun, a.fee_s_amt as s_amt, a.fee_amt as amt,"
		 * +
		 * " a.fee_tm as tm, decode(a.tm_st1,'0','','(잔)') tm_st, 0 dly_amt, a.dly_day as dly_days, a.bus_id2, a.rent_st, c.r_site, c.mng_id, c.use_yn,"
		 * +
		 * " b.cls_dt, nvl(b.cls_est_dt, a.fee_est_dt) as est_dt, a.rc_dt as pay_dt,"
		 * + " '' gi_st, g.gi_amt gi_amt \n"+
		 * " from fee_view a, cls_cont b, cont c,  car_reg cr ,  "+
		 * "      (select a.* from gua_ins a, (select rent_mng_id, rent_l_cd, max(to_number(rent_st)) rent_st, max(gi_dt) gi_dt from gua_ins group by rent_mng_id, rent_l_cd) b where a.rent_mng_id=b.rent_mng_id and a.rent_l_cd=b.rent_l_cd and a.rent_st=b.rent_st and a.gi_dt=b.gi_dt) g, "
		 * + "      client e \n"+
		 * " where a.rent_l_cd=b.rent_l_cd and a.rent_l_cd=c.rent_l_cd and a.use_yn='N' and nvl(a.bill_yn,'Y')='Y'"
		 * +
		 * " and a.rent_mng_id=g.rent_mng_id(+) and a.rent_l_cd=g.rent_l_cd(+) and c.client_id=e.client_id \n"
		 * + " and b.cls_st in ('1','2') and c.car_mng_id = cr.car_mng_id  ";
		 */
		// 합체
		// String query = " select * from ( \n"+query1+"\n union all
		// \n"+query2+"\n ) where rent_l_cd is not null ";
		String query = " select * from ( \n" + query1 + "\n ) where rent_l_cd is not null ";

		/* 상세조회&&세부조회 */
		if (gubun2.equals("1")) {
			query += " and cls_dt <= to_char(sysdate,'YYYYMMDD') and pay_dt is null";
			// 기간-미수금
		} else if (gubun2.equals("4")) {
			query += " and est_dt BETWEEN  replace('" + st_dt + "' , '-', '')  AND replace('" + end_dt
					+ "', '-', '')  and pay_dt is null";
		}

		/* 검색조건 */

		if (s_kd.equals("2"))
			query += " and nvl(client_nm, '') like '%" + t_wd + "%'\n";
		else if (s_kd.equals("3"))
			query += " and upper(rent_l_cd) like upper('%" + t_wd + "%')\n";
		else if (s_kd.equals("4"))
			query += " and nvl(car_no, '') like '%" + t_wd + "%'\n";
		else if (s_kd.equals("5"))
			query += " and est_dt like '" + t_wd + "%'\n";
		else if (s_kd.equals("6"))
			query += " and substr(rent_l_cd,1,2) like upper('%" + t_wd + "%')\n";
		else if (s_kd.equals("7"))
			query += " and nvl(r_site, '') like '%" + t_wd + "%'\n";
		else if (s_kd.equals("8"))
			query += " and bus_id2= '" + t_wd + "'\n";
		else if (s_kd.equals("11"))
			query += " and mng_id= '" + t_wd + "'\n";
		else if (s_kd.equals("9"))
			query += " and car_nm||car_name like '%" + t_wd + "%'\n";
		else if (s_kd.equals("10"))
			query += " and nvl(cls_dt, '') like '%" + t_wd + "%'\n";
		else
			query += " and nvl(firm_nm, '') like '%" + t_wd + "%'\n";

		// 검색일경우 해약건에대한 정렬위해
		String sort = asc.equals("0") ? " asc" : " desc";

		/* 정렬조건 */

		// if(sort_gubun.equals("0")) query += " order by
		// decode(bus_id2,'000004','0','000006','1','2') desc, use_yn desc,
		// est_dt "+sort+", pay_dt, firm_nm";
		if (sort_gubun.equals("0"))
			query += " order by prepare,  cls_dt " + sort + ", pay_dt, firm_nm";

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
			System.out.println("[ReceiveDatabase:getClsFeeScdList]\n" + e);
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

	public int insertReceive(ReceiveBean bean) {
		getConnection();

		PreparedStatement pstmt = null;
		Statement stmt = null;
		ResultSet rs = null;
		String query = "";
		String seqQuery = "";
		String car_mng_id = "";
		String rent_mng_id = "";
		String rent_l_cd = "";
		int seq_no = 0;
		int count = 0;

		car_mng_id = bean.getCar_mng_id().trim();
		rent_mng_id = bean.getRent_mng_id().trim();
		rent_l_cd = bean.getRent_l_cd().trim();

		seqQuery = "select nvl(max(SEQ_NO)+1,1) from receive  where car_mng_id='" + car_mng_id + "' and rent_mng_id='"
				+ rent_mng_id + "' and rent_l_cd='" + rent_l_cd + "'\n";

		query = " INSERT INTO RECEIVE (SEQ_NO,CAR_MNG_ID,RENT_MNG_ID,RENT_L_CD,CALL_NM,TEL,VIO_DT,VIO_PLA,"
				+ " VIO_CONT, POL_STA, NOTE, REG_ID, REG_DT, NOTICE_DT,RENT_S_CD)\n"
				+ " values(?, ?, ?, ?, ?, ?, replace( ?,'-',''), ?," + // 8
				" ?, ? ,?, ?, to_char(sysdate,'YYYYMMdd'), replace(?,'-',''), ?)\n"; // 7

		try {
			conn.setAutoCommit(false);

			stmt = conn.createStatement();
			rs = stmt.executeQuery(seqQuery);
			if (rs.next())
				seq_no = rs.getInt(1);
			rs.close();
			stmt.close();

			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, seq_no);
			pstmt.setString(2, car_mng_id);
			pstmt.setString(3, rent_mng_id);
			pstmt.setString(4, rent_l_cd);
			pstmt.setString(5, bean.getCall_nm().trim());
			pstmt.setString(6, bean.getTel().trim());
			pstmt.setString(7, bean.getVio_dt().trim());
			pstmt.setString(8, bean.getVio_pla().trim());
			pstmt.setString(9, bean.getVio_cont().trim());
			pstmt.setString(10, bean.getPol_sta().trim());
			pstmt.setString(11, bean.getNote().trim());
			pstmt.setString(12, bean.getReg_id().trim());
			pstmt.setString(13, bean.getNotice_dt().trim());
			pstmt.setString(14, bean.getRent_s_cd().trim());
			count = pstmt.executeUpdate();
			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[ReceiveDatabase:insertReceive]\n" + e);
			System.out.println("[ReceiveDatabase:insertReceive]\n" + query);
			e.printStackTrace();
			count = 0;
			conn.rollback();

		} finally {
			try {
				conn.setAutoCommit(true);
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
				if (pstmt != null)
					pstmt.close();
			} catch (Exception ignore) {
			}
			closeConnection();
			return count;
		}
	}

	/**
	 * 과태료/범칙금 수정
	 */
	public int updateReceive(ReceiveBean bean) {
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		String car_mng_id = "";
		String rent_mng_id = "";
		String rent_l_cd = "";
		int seq_no = 0;
		int count = 0;
		seq_no = bean.getSeq_no();
		car_mng_id = bean.getCar_mng_id().trim();
		rent_mng_id = bean.getRent_mng_id().trim();
		rent_l_cd = bean.getRent_l_cd().trim();

		query = " update receive  set CALL_NM=?,TEL=?,VIO_PLA=?,VIO_CONT=?,  POL_STA=?,"
				+ " NOTE=?, UPDATE_ID=?,UPDATE_DT=to_char(sysdate,'YYYYMMDD'),"
				+ " rent_s_cd=?, notice_dt=replace(?,'-','') "
				+ " where seq_no=? and car_mng_id=? and rent_mng_id=? and rent_l_cd=?";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, bean.getCall_nm().trim());
			pstmt.setString(2, bean.getTel().trim());
			pstmt.setString(3, bean.getVio_pla().trim());
			pstmt.setString(4, bean.getVio_cont().trim());
			pstmt.setString(5, bean.getPol_sta().trim());

			pstmt.setString(6, bean.getNote().trim());
			pstmt.setString(7, bean.getUpdate_id().trim());
			pstmt.setString(8, bean.getRent_s_cd().trim());
			pstmt.setString(9, bean.getNotice_dt().trim());

			pstmt.setInt(10, seq_no);
			pstmt.setString(11, car_mng_id);
			pstmt.setString(12, rent_mng_id);
			pstmt.setString(13, rent_l_cd);

			count = pstmt.executeUpdate();

			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[ReceiveDatabase:updateReceive]\n" + e);
			System.out.println("[ReceiveDatabase:updateReceive]\n" + query);
			e.printStackTrace();
			count = 0;
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

	public int deleteReceive(ReceiveBean bean) {
		getConnection();

		PreparedStatement pstmt = null;
		String query = "";
		String car_mng_id = "";
		String rent_mng_id = "";
		String rent_l_cd = "";
		int seq_no = 0;
		int count = 0;
		seq_no = bean.getSeq_no();
		car_mng_id = bean.getCar_mng_id().trim();
		rent_mng_id = bean.getRent_mng_id().trim();
		rent_l_cd = bean.getRent_l_cd().trim();

		query = " delete from fine where seq_no=? and car_mng_id=? and rent_mng_id=? and rent_l_cd=?";

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, seq_no);
			pstmt.setString(2, car_mng_id);
			pstmt.setString(3, rent_mng_id);
			pstmt.setString(4, rent_l_cd);
			pstmt.executeUpdate();

			pstmt.close();
			conn.commit();

		} catch (SQLException e) {
			System.out.println("[ReceiveDatabase:deleteReceive]\n" + e);
			System.out.println("[ReceiveDatabase:deleteReceive]\n" + query);
			e.printStackTrace();
			count = 0;
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

	public ReceiveBean getReceiveDetailAll(String car_mng_id, String rent_mng_id, String rent_l_cd, String seq_no) {
		getConnection();

		ReceiveBean bean = new ReceiveBean();
		Statement stmt = null;
		ResultSet rs = null;

		String query = "";

		query = " select   a.seq_no, a.car_mng_id, a.rent_mng_id, a.rent_l_cd,  a.call_nm, a.tel,  \n" + // 6
				" a.vio_pla, a.vio_cont ,  a.pol_sta,  a.note,   a.update_id, a.update_dt, a.reg_id, a.reg_dt,  a.rent_s_cd, a.notice_dt  \n" // 11
				+ "from receive  a, car_reg b, cont c, client d \n" + "where a.car_mng_id='" + car_mng_id
				+ "' and a.rent_mng_id='" + rent_mng_id + "' and a.rent_l_cd='" + rent_l_cd + "' and a.seq_no=" + seq_no
				+ "and a.car_mng_id=b.car_mng_id\n"
				+ "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n" + "and c.client_id = d.client_id";

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			if (rs.next()) {

				bean.setSeq_no(rs.getInt(1));
				bean.setCar_mng_id(rs.getString(2));
				bean.setRent_mng_id(rs.getString(3));
				bean.setRent_l_cd(rs.getString(4));
				bean.setCall_nm(rs.getString(5));
				bean.setTel(rs.getString(6));
				bean.setVio_pla(rs.getString(7));
				bean.setVio_cont(rs.getString(8));
				bean.setPol_sta(rs.getString(9));
				bean.setNote(rs.getString(10));
				bean.setUpdate_id(rs.getString(11));
				bean.setUpdate_dt(rs.getString(12));
				bean.setReg_id(rs.getString(13));
				bean.setReg_dt(rs.getString(14));
				bean.setRent_s_cd(rs.getString(15));
				bean.setNotice_dt(rs.getString(16));

			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[ReceiveDatabase:getReceiveDetailAll]\n" + e);
			System.out.println("[ReceiveDatabase:getReceiveDetailAll]\n" + query);
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
			return bean;
		}
	}

	// 해지정산처리관리 리스트 조회 - chk:1:수수료 , doc_settle : doc_st: 96-> 소송
	public Vector getClsSuitDocList(String s_kd, String t_wd, String gubun1, String andor, String chk) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

		query = " select  a.car_gu,  b.cls_st , b.cls_dt , a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.use_yn, a.firm_nm, a.client_nm, c.car_no, c.car_nm,  d.req_dt, a.car_st, a.rent_dt, \n"
				+ " decode(b.cls_st,'1','계약만료','2','중도해약', '8', '매입옵션', '7', '출고전해지(신차)', '10', '개시전해지(재리스)',  '14', '월렌트해지' ,  '') cls_st_nm, \n"
				+ " l.doc_no, l.doc_step, l.user_id1, l.user_id2,  l.user_dt1, l.user_dt2 , e.req_dt suit_dt  \n"
				+ " from cont_n_view a, car_reg c, cls_band d ,  cls_etc b , cls_suit e , \n"
				+ " (select * from doc_settle where doc_st='96') l \n"
				+ " where  a.car_mng_id = c.car_mng_id(+) and a.rent_mng_id=b.RENT_MNG_ID and a.rent_l_cd=b.rent_l_cd and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd and a.use_yn = 'N' and a.client_id <> '000228' \n"
				+ " and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd = e.rent_l_cd  \n"
				+ " and a.rent_l_cd=l.doc_id(+) \n";

		// if(s_kd.equals("1")) query += " and a.car_st != '4' and a.firm_nm
		// like '%"+t_wd+"%'";
		if (s_kd.equals("1"))
			query += " and a.car_st != '5' and a.firm_nm like '%" + t_wd + "%'";
		else if (s_kd.equals("2"))
			query += " and a.car_st != '5' and c.car_no||' '||c.first_car_no like '%" + t_wd + "%'";

		//결재여부 
		if(gubun1.equals("1"))			query += " and l.user_dt2 is null";//미결
		else if(gubun1.equals("2"))		query += " and l.user_dt2 is not null";//결재- 완결 
		
		query += " order by  d.req_dt desc";

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
			System.out.println("[RecevieDatabase:getClsBandDocList]\n" + e);
			System.out.println("[RecevieDatabase:getClsBandDocList]\n" + query);
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
	
	// 소송관리 리스트- chk:1:수수료 , doc_settle : doc_st: 96-> 소송   and a.use_yn = 'N'
	public Vector getClsSuitDocList2(String s_kd, String t_wd, String gubun1, String andor, String chk) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

		query = " select  a.car_gu,  b.cls_st , b.cls_dt , a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, e.req_dt, a.use_yn, a.firm_nm, a.client_nm, c.car_no, c.car_nm,  a.car_st, a.rent_dt, \n"
				+ " decode(b.cls_st,'1','계약만료','2','중도해약', '8', '매입옵션', '7', '출고전해지(신차)', '10', '개시전해지(재리스)',  '14', '월렌트해지' , '5', '계약승계', null, '-' ,  '') cls_st_nm, \n"
				+ " l.doc_no, l.doc_step, l.user_id1, l.user_id2,  l.user_dt1, l.user_dt2 , e.req_dt suit_dt  \n"
				+ " from cont_n_view a, car_reg c, cls_cont b , cls_suit e , \n"
				+ " (select * from doc_settle where doc_st='96') l \n"
				+ " where  a.car_mng_id = c.car_mng_id(+) and a.rent_mng_id=b.RENT_MNG_ID(+) and a.rent_l_cd=b.rent_l_cd(+)  and a.client_id <> '000228' \n"
				+ " and a.rent_mng_id=e.rent_mng_id and a.rent_l_cd = e.rent_l_cd  \n"
				+ " and a.rent_l_cd=l.doc_id(+) \n";

		// if(s_kd.equals("1")) query += " and a.car_st != '4' and a.firm_nm  
		// like '%"+t_wd+"%'";
		if (s_kd.equals("1"))
			query += " and a.car_st != '5' and a.firm_nm like '%" + t_wd + "%'";
		else if (s_kd.equals("2"))
			query += " and a.car_st != '5' and c.car_no||' '||c.first_car_no like '%" + t_wd + "%'";

		//결재여부 
		if(gubun1.equals("1"))			query += " and l.user_dt2 is null";//미결
		else if(gubun1.equals("2"))		query += " and l.user_dt2 is not null";//결재- 완결 
		
		query += " order by  e.req_dt desc";

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
			System.out.println("[RecevieDatabase:getClsBandDocList]\n" + e);
			System.out.println("[RecevieDatabase:getClsBandDocList]\n" + query);
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


	// 추심정보
	public ClsSuitBean getClsSuitInfo(String rent_mng_id, String rent_l_cd) {
		getConnection();
		ClsSuitBean carB = new ClsSuitBean();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";

		query = " select  * from cls_suit  where rent_mng_id =? and rent_l_cd =? ";

		try {
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				carB.setRent_mng_id(rs.getString("RENT_MNG_ID") == null ? "" : rs.getString("RENT_MNG_ID"));
				carB.setRent_l_cd(rs.getString("RENT_L_CD") == null ? "" : rs.getString("RENT_L_CD"));
				carB.setReq_dt(rs.getString("req_dt") == null ? "" : rs.getString("req_dt"));

				carB.setReq_rem(rs.getString("req_rem") == null ? "" : rs.getString("req_rem"));
				carB.setS_type(rs.getString("s_type") == null ? "" : rs.getString("s_type"));
				carB.setSuit_amt(rs.getInt("suit_amt"));
				carB.setSuit_dt(rs.getString("suit_dt") == null ? "" : rs.getString("suit_dt"));
				carB.setSuit_no(rs.getString("suit_no") == null ? "" : rs.getString("suit_no"));
				carB.setAmt1(rs.getInt("amt1"));
				carB.setAmt2(rs.getInt("amt1"));
				carB.setMean_dt(rs.getString("mean_dt") == null ? "" : rs.getString("mean_dt"));
				carB.setSuit_rem(rs.getString("suit_rem") == null ? "" : rs.getString("suit_rem"));

			}
			rs.close();
			pstmt.close();
		} catch (SQLException e) {
			System.out.println("[getClsSuitInfo]\n" + e);
			System.out.println(query);
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
			return carB;
		}
	}

	/**
	 * 고소고발 .
	 */
	public ReceiveBean[] getReceiveDetailKSKBSS(String car_mng_id, String rent_mng_id, String rent_l_cd, String gubun) {
		getConnection();

		Statement stmt = null;
		ResultSet rs = null;

		String query = "";

		query = " select   a.seq_no, a.car_mng_id, a.rent_mng_id, a.rent_l_cd,  a.call_nm, a.tel,  \n" + // 6
				" a.vio_pla, a.vio_cont ,  a.pol_sta,  a.note,   a.update_id, a.update_dt, a.reg_id, a.reg_dt,  a.rent_s_cd, a.notice_dt  \n" // 11
				+ "from receive  a, car_reg b, cont c, client d \n" + "where a.car_mng_id='" + car_mng_id
				+ "' and a.rent_l_cd='" + rent_l_cd + "' \n" + "and a.car_mng_id=b.car_mng_id and a.gubun= '" + gubun
				+ "' \n" + "and a.rent_mng_id = c.rent_mng_id and a.rent_l_cd = c.rent_l_cd\n"
				+ "and c.client_id = d.client_id \n" + "order by a.notice_dt desc, a.seq_no ";

		Collection col = new ArrayList();

		try {
			stmt = conn.createStatement();

			rs = stmt.executeQuery(query);
			while (rs.next()) {

				ReceiveBean bean = new ReceiveBean();

				bean.setSeq_no(rs.getInt(1));
				bean.setCar_mng_id(rs.getString(2));
				bean.setRent_mng_id(rs.getString(3));
				bean.setRent_l_cd(rs.getString(4));
				bean.setCall_nm(rs.getString(5));
				bean.setTel(rs.getString(6));
				bean.setVio_pla(rs.getString(7));
				bean.setVio_cont(rs.getString(8));
				bean.setPol_sta(rs.getString(9));
				bean.setNote(rs.getString(10));
				bean.setUpdate_id(rs.getString(11));
				bean.setUpdate_dt(rs.getString(12));
				bean.setReg_id(rs.getString(13));
				bean.setReg_dt(rs.getString(14));
				bean.setRent_s_cd(rs.getString(15));
				bean.setNotice_dt(rs.getString(16));

				col.add(bean);

			}
			rs.close();
			stmt.close();
		} catch (SQLException e) {
			System.out.println("[ReceiveDatabase:getReceiveDetailKSKBSS]\n" + e);
			System.out.println("[ReceiveDatabase:getReceiveDetailKSKBSS]\n" + query);
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
			return (ReceiveBean[]) col.toArray(new ReceiveBean[0]);
		}
	}

	// 해지정산처리관리 리스트 조회 - chk:1:수수료 , doc_settle : doc_st: 95->추심수수료
	public Vector getClsReceiveList(String s_kd, String t_wd, String gubun1, String andor, String chk) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

		query = " select  a.car_gu, a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.use_yn, a.firm_nm, a.client_nm, c.car_no, c.car_nm,  d.req_dt, a.car_st,   d.re_rate,  a.rent_dt, \n"
				+ " l.doc_no, l.doc_step, l.user_id1, l.user_id2, l.user_id3, l.user_id4, l.user_dt1, l.user_dt2 , l.user_dt3, l.user_dt4  \n"
				+ " from cont_n_view a, car_reg c, cls_band d , \n"
				+ " (select * from doc_settle where doc_st='95') l \n"
				+ " where  a.car_mng_id = c.car_mng_id(+) and a.rent_mng_id = d.rent_mng_id and a.rent_l_cd = d.rent_l_cd and a.use_yn = 'N' and a.client_id <> '000228' \n"
				+ " and a.rent_l_cd=l.doc_id(+) \n";

		if (s_kd.equals("1"))
			query += " and a.car_st != '5' and a.firm_nm like '%" + t_wd + "%'";
		else if (s_kd.equals("2"))
			query += " and a.car_st != '5' and c.car_no||' '||c.first_car_no like '%" + t_wd + "%'";

		query += " order by  d.req_dt desc";

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
			System.out.println("[RecevieDatabase:getClsReceiveList]\n" + e);
			System.out.println("[RecevieDatabase:getClsReceiveList]\n" + query);
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
	 * 추심의뢰삭제 -
	 */
	public boolean deleteClsBand(String rent_mng_id, String rent_l_cd) {
		getConnection();
		boolean flag = true;
		String query = "delete from cls_band  " + " where rent_mng_id = ? and rent_l_cd = ?  "; // 2

		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);

			pstmt.executeUpdate();

			conn.commit();

		} catch (Exception e) {
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
	 * 추심의뢰 문서처리 삭제 - 담당자 기안 후 발신처 결제권자 삭제
	 */
	public boolean deleteDocSettleBand(String rent_l_cd) {
		getConnection();
		boolean flag = true;
		String query = "delete from doc_settle " + " where doc_st in ( '95' ) and doc_id = ?  "; // 2

		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, rent_l_cd);

			pstmt.executeUpdate();

			conn.commit();

		} catch (Exception e) {
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
	 * 채권소송의뢰 문서처리 삭제 - 담당자 기안 후 발신처 결제권자 삭제
	 */

	public boolean deleteDocSettleSuit(String rent_l_cd) {
		getConnection();
		boolean flag = true;
		String query = "delete from doc_settle " + " where doc_st in ( '96' ) and doc_id = ?  "; // 2

		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, rent_l_cd);

			pstmt.executeUpdate();

			conn.commit();

		} catch (Exception e) {
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
	
	public boolean deleteClsBandEtc(String rent_mng_id, String rent_l_cd, String seq) {
		getConnection();
		boolean flag = true;
		String query = "delete from cls_band_etc  where rent_mng_id = ? and rent_l_cd = ?  and seq = ? "; // 2

		int i_seq = AddUtil.parseInt(seq);
		
		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, rent_mng_id);
			pstmt.setString(2, rent_l_cd);
			pstmt.setInt(3, i_seq);

			pstmt.executeUpdate();

			conn.commit();

		} catch (Exception e) {
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
	 * 차량회수 insert
	 */
	public boolean updateClsBandEtc(ClsBandEtcBean cbe) {
		getConnection();
		boolean flag = true;
		String query = "update cls_band_etc set  " + // 
				" band_st  = ?, band_ip_dt = replace(?, '-', '') , draw_amt = ?, ip_amt= ?,  " + // 4
				" rate_amt = ?, rate_jp_dt = replace(?, '-', '') , upd_dt = sysdate , upd_id = ?  " + // 3
				" where rent_mng_id = ? and rent_l_cd = ? and seq = ?  "; // 3
		
		
		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, cbe.getBand_st());
			pstmt.setString(2, cbe.getBand_ip_dt());
			pstmt.setInt(3, cbe.getDraw_amt());
			pstmt.setInt(4, cbe.getIp_amt());
			
			pstmt.setInt(5, cbe.getRate_amt());
			pstmt.setString(6, cbe.getRate_jp_dt());
			pstmt.setString(7, cbe.getUpd_id());
		
			pstmt.setString(8, cbe.getRent_mng_id());
			pstmt.setString(9, cbe.getRent_l_cd());
			pstmt.setInt(10, cbe.getSeq());

			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
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
	
	//추심 - 
	public boolean updateClsSeize(String rent_mng_id, String rent_l_cd , String seize_dt , int seize_amt) {
		getConnection();
		boolean flag = true;
		String query = "update cls_band set  " + // 
				" seize_dt = replace(?, '-', '') , seize_amt= ?  " + // 2
				" where rent_mng_id = ? and rent_l_cd = ?  "; // 2
		
		
		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, seize_dt);
			pstmt.setInt(2, seize_amt);
			
			pstmt.setString(3, rent_mng_id);
			pstmt.setString(4, rent_l_cd);
			
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
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
	 * 차량추심 소송 update
	 */
	public boolean updateClsSuit(ClsSuitBean cbe) {
		getConnection();
		boolean flag = true;
		String query = "update cls_suit set  " + // 
				" REQ_REM  = ?, REQ_DT = replace(?, '-', '') , s_type = ?, SUIT_DT = replace(?, '-', '') , suit_no  = ?, SUIT_AMT= ?,  " + // 6
				" MEAN_DT = replace(?, '-', ''), SUIT_REM = ? , AMT1 = ?,  upd_dt = sysdate , upd_id = ?  " + // 4
				" where rent_mng_id = ? and rent_l_cd = ?  "; // 2		
		
		PreparedStatement pstmt = null;

		try {
			conn.setAutoCommit(false);

			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, cbe.getReq_rem());
			pstmt.setString(2, cbe.getReq_dt());
			pstmt.setString(3, cbe.getS_type());
			pstmt.setString(4, cbe.getSuit_dt());
			pstmt.setString(5, cbe.getSuit_no());
			pstmt.setInt(6, cbe.getSuit_amt());
			
			pstmt.setString(7, cbe.getMean_dt());
			pstmt.setString(8, cbe.getSuit_rem());
			pstmt.setInt(9, cbe.getAmt1());
			pstmt.setString(10, cbe.getUpd_id());
		
			pstmt.setString(11, cbe.getRent_mng_id());
			pstmt.setString(12, cbe.getRent_l_cd());
			
			pstmt.executeUpdate();
			pstmt.close();

			conn.commit();

		} catch (Exception e) {
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
	
	
	// 미회수 차량  리스트 조회 - chk:1:수수료 , doc_settle : doc_st: 95->추심수수료
	public Vector getClsCarRecoList(String s_kd, String t_wd, String gubun1, String andor, String chk) {
		getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "", query1 = "", query2 = "";
		String where = "";

		query = " select  a.car_gu,  b.cls_st , b.cls_dt , a.rent_mng_id, a.rent_l_cd, a.car_mng_id, a.client_id, a.use_yn, a.firm_nm, a.client_nm, c.car_no, c.car_nm,  d.req_dt, a.car_st, a.rent_dt, \n"
				+ " decode(b.cls_st,'1','계약만료','2','중도해약', '8', '매입옵션', '7', '출고전해지(신차)', '10', '개시전해지(재리스)',  '14', '월렌트해지' ,  '') cls_st_nm, \n"
				+ " l.doc_no, l.doc_step, l.user_id1, l.user_id2, l.user_id3, l.user_id4,  l.user_dt1, l.user_dt2 , l.user_dt3, l.user_dt4 , r.ip_dt  \n"
				+ " from cont_n_view a, car_reg c, cls_band d ,  cls_etc b ,   car_reco r , \n"
				+ " (select * from doc_settle where doc_st='99') l \n"
				+ " where  a.car_mng_id = c.car_mng_id(+) and a.rent_mng_id=b.RENT_MNG_ID(+) and a.rent_l_cd=b.rent_l_cd(+) and a.rent_mng_id = d.rent_mng_id(+) and a.rent_l_cd = d.rent_l_cd(+)  and a.client_id <> '000228' \n"
				+ " and a.rent_mng_id = r.rent_mng_id and a.rent_l_cd = r.rent_l_cd and r.reco_st = 'N' \n"
				+ " and a.rent_l_cd=l.doc_id(+) \n";

		// if(s_kd.equals("1")) query += " and a.car_st != '4' and a.firm_nm
		// like '%"+t_wd+"%'";
		if (s_kd.equals("1"))
			query += " and a.car_st != '5' and a.firm_nm like '%" + t_wd + "%'";
		else if (s_kd.equals("2"))
			query += " and a.car_st != '5' and c.car_no||' '||c.first_car_no like '%" + t_wd + "%'";

		query += " order by  r.reco_dt desc, b.cls_dt desc ";

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
			System.out.println("[RecevieDatabase:getClsBandDocList]\n" + e);
			System.out.println("[RecevieDatabase:getClsBandDocList]\n" + query);
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

	 //삭제괸련  table 정리		
	public boolean deleteInfo(String rent_mng_id, String rent_l_cd, String table_nm)
	{
			getConnection();
			boolean flag = true;
			String query = "delete from "+table_nm+""+
							" where rent_mng_id = ? and rent_l_cd = ?  ";  //2
			
			PreparedStatement pstmt = null;

			try 
			{
				conn.setAutoCommit(false);

				pstmt = conn.prepareStatement(query);
						
				pstmt.setString(1, rent_mng_id);
				pstmt.setString(2, rent_l_cd);
				
			    pstmt.executeUpdate();

				conn.commit();
			    
		  	} catch (Exception e) {
		  		e.printStackTrace();
		  		flag = false;
				conn.rollback();
			} finally {
				try{	
					conn.setAutoCommit(true);
					if(pstmt != null)	pstmt.close();
				}catch(Exception ignore){}
				closeConnection();
				return flag;
			}			
	} 
	
}