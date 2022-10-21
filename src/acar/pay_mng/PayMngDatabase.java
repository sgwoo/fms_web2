package acar.pay_mng;

import java.io.*;
import java.sql.*;
import java.util.*;
import acar.util.*;
import acar.common.*;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.UnknownDataException;
import acar.exception.DatabaseException;

public class PayMngDatabase
{
	private static PayMngDatabase instance;
	private Connection conn = null;
    private DBConnectionManager connMgr;   
    private final String DATA_SOURCE    = "acar";
 
	public static synchronized PayMngDatabase getInstance() {
        if (instance == null)
            instance = new PayMngDatabase();
        return instance;
    }
    
   	private PayMngDatabase()  {
        connMgr = DBConnectionManager.getInstance();
    }



	/**********************************************/	
	/*                                            */
	/*        데  이  타  등 록 및 수 정          */
	/*                                            */
	/**********************************************/	
	

    /**
     *	출금(조회-원본)원장 등록
     */
    public String insertPaySearch(PayMngBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String id_query = "";

		query = " INSERT INTO pay_search									"+
				" ( reqseq, p_est_dt, p_gubun, p_way,						"+
				"   p_cd1, p_cd2, p_cd3, p_cd4, p_cd5,						"+
				"   p_st1, p_st2, p_st3, p_st4, p_st5,						"+
				"   p_cont, off_st, off_id, off_nm, ven_code, ven_name,		"+
				"   amt, bank_nm, bank_no, reg_dt, reg_id,					"+
				"   p_step, p_gubun_etc, acct_code, bank_id, p_req_dt,		"+
				"   sub_amt1, sub_amt2, sub_amt3, sub_amt4, sub_amt5,		"+
			    "   card_id, card_nm, card_no,								"+
			    "   a_bank_id, a_bank_nm, a_bank_no,						"+
				"   r_est_dt, p_pay_dt, bank_code, a_pay_dt,				"+
				"   buy_user_id, ven_st, tax_yn, savepath,					"+
				"   filename1, filename2, filename3, filename4, filename5,	"+
				"   acct_code_g, acct_code_g2, o_cau,						"+
				"   call_t_nm, call_t_tel, call_t_chk, user_su, user_cont,	"+
				"   acct_code2, acct_code3, acct_code4, acct_code5, reg_st, "+
				"   s_idno, r_acct_code, p_cd6, search_code, acct_code_st,  "+
			    "   bank_acc_nm, bank_cms_bk, a_bank_cms_bk, off_tel,       "+
				"   act_union_yn, cash_acc_no, i_s_amt, i_v_amt, sub_amt6   "+
				" ) VALUES													"+
				" ( ?, replace(?, '-', ''), ?, ?,							"+
				"   ?, ?, ?, ?, ?,											"+
				"   ?, ?, ?, ?, ?,											"+
				"   ?, ?, ?, ?, ?, ?,										"+
				"   ?, ?, ?, sysdate, ?,									"+
				"   ?, ?, ?, ?, replace(?, '-', ''),						"+
				"   ?, ?, ?, ?, ?,											"+
				"   ?, ?, ?,												"+
				"   ?, ?, ?,												"+
				"   replace(?, '-', ''), replace(?, '-', ''), ?, replace(?, '-', ''),  "+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?,                              "+
				"   ?, ?, ?, ?, ?, ?, ?, ?,									"+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,                           "+
				"   ?, ?, ?, ?, ?, ?, ?, ?, ?                               "+
				"  )";

		id_query = " select to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(reqseq,9,7))+1), '0000000')), '0000001') reqseq"+
				" from pay_search "+
				" where substr(reqseq,1,8)=to_char(sysdate,'YYYYMMDD')";

	   try{

            con.setAutoCommit(false);

			//새 reqseq 조회
			pstmt1 = con.prepareStatement(id_query);
	    	rs = pstmt1.executeQuery();   	
			if(rs.next())
			{				
				bean.setReqseq(rs.getString(1));
			}
			rs.close();
			pstmt1.close();

			if(bean.getP_st4().equals("엑셀등록")){
				bean.setP_cd1		(bean.getReqseq());
			}

			//등록
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,		bean.getReqseq			());
			pstmt.setString	(2,		bean.getP_est_dt		());
			pstmt.setString	(3,		bean.getP_gubun			());
			pstmt.setString	(4,		bean.getP_way			());
			pstmt.setString	(5,		bean.getP_cd1			());
			pstmt.setString	(6,		bean.getP_cd2			());
			pstmt.setString	(7,		bean.getP_cd3			());
			pstmt.setString	(8,		bean.getP_cd4			());
			pstmt.setString (9,		bean.getP_cd5			());
			pstmt.setString (10,	bean.getP_st1			());
			pstmt.setString	(11,	bean.getP_st2			());
			pstmt.setString	(12,	bean.getP_st3			());
			pstmt.setString	(13,	bean.getP_st4			());
			pstmt.setString	(14,	bean.getP_st5			());
			pstmt.setString	(15,	bean.getP_cont			());
			pstmt.setString	(16,	bean.getOff_st			());
			pstmt.setString	(17,	bean.getOff_id			());
			pstmt.setString	(18,	bean.getOff_nm			().trim());
			pstmt.setString	(19,	bean.getVen_code		());
			pstmt.setString (20,	bean.getVen_name		());
			pstmt.setLong	(21,	bean.getAmt				());
			pstmt.setString	(22,	bean.getBank_nm			());
			pstmt.setString	(23,	bean.getBank_no			().trim());
			pstmt.setString	(24,	bean.getReg_id			());
			pstmt.setString	(25,	bean.getP_step			());
			pstmt.setString	(26,	bean.getP_gubun_etc		());
			pstmt.setString	(27,	bean.getAcct_code		());
			pstmt.setString	(28,	bean.getBank_id			());
			pstmt.setString	(29,	bean.getP_req_dt		());
			pstmt.setLong	(30,	bean.getSub_amt1		());
			pstmt.setLong	(31,	bean.getSub_amt2		());
			pstmt.setLong	(32,	bean.getSub_amt3		());
			pstmt.setLong	(33,	bean.getSub_amt4		());
			pstmt.setLong	(34,	bean.getSub_amt5		());
			pstmt.setString	(35,	bean.getCard_id			());
			pstmt.setString	(36,	bean.getCard_nm			());
			pstmt.setString	(37,	bean.getCard_no			());
			pstmt.setString	(38,	bean.getA_bank_id		());
			pstmt.setString	(39,	bean.getA_bank_nm		());
			pstmt.setString	(40,	bean.getA_bank_no		().trim());
			pstmt.setString	(41,	bean.getR_est_dt		());
			pstmt.setString	(42,	bean.getP_pay_dt		());
			pstmt.setString	(43,	bean.getBank_code		());
			pstmt.setString	(44,	bean.getA_pay_dt		());
			pstmt.setString	(45,	bean.getBuy_user_id		());
			pstmt.setString	(46,	bean.getVen_st			());
			pstmt.setString	(47,	bean.getTax_yn			());
			pstmt.setString	(48,	bean.getSavepath		());
			pstmt.setString	(49,	bean.getFilename1		());
			pstmt.setString	(50,	bean.getFilename2		());
			pstmt.setString	(51,	bean.getFilename3		());
			pstmt.setString	(52,	bean.getFilename4		());
			pstmt.setString (53,	bean.getFilename5		());
			pstmt.setString (54,	bean.getAcct_code_g		());
			pstmt.setString	(55,	bean.getAcct_code_g2	());
			pstmt.setString	(56,	bean.getO_cau			());
			pstmt.setString	(57,	bean.getCall_t_nm		());
			pstmt.setString	(58,	bean.getCall_t_tel		());
			pstmt.setString	(59,	bean.getCall_t_chk		());
			pstmt.setString	(60,	bean.getUser_su			());
			pstmt.setString	(61,	bean.getUser_cont		());
			pstmt.setString (62,	bean.getAcct_code2		());
			pstmt.setString (63,	bean.getAcct_code3		());
			pstmt.setString (64,	bean.getAcct_code4		());
			pstmt.setString (65,	bean.getAcct_code5		());
			pstmt.setString	(66,	bean.getReg_st			());
			pstmt.setString	(67,	bean.getS_idno			());
			pstmt.setString (68,	bean.getR_acct_code		());
			pstmt.setString (69,	bean.getP_cd5			());
			pstmt.setString (70,	bean.getSearch_code		());
			pstmt.setString (71,	bean.getAcct_code_st	());
			pstmt.setString (72,	bean.getBank_acc_nm		());
			pstmt.setString (73,	bean.getBank_cms_bk		());
			pstmt.setString (74,	bean.getA_bank_cms_bk	());
			pstmt.setString	(75,	bean.getOff_tel			());
			pstmt.setString	(76,	bean.getAct_union_yn	());
			pstmt.setString	(77,	bean.getCash_acc_no  	());
			pstmt.setLong	(78,	bean.getI_s_amt			());
			pstmt.setLong	(79,	bean.getI_v_amt			());
			pstmt.setLong	(80,	bean.getSub_amt6		());

			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;

				System.out.println("[PayMngDatabase:insertPaySearch]"+se);
				System.out.println("[bean.getReqseq			()]\n"+bean.getReqseq		());
				System.out.println("[bean.getP_est_dt		()]\n"+bean.getP_est_dt		());
				System.out.println("[bean.getP_gubun		()]\n"+bean.getP_gubun		());
				System.out.println("[bean.getP_way			()]\n"+bean.getP_way		());
				System.out.println("[bean.getP_cd1			()]\n"+bean.getP_cd1		());
				System.out.println("[bean.getP_cd2			()]\n"+bean.getP_cd2		());
				System.out.println("[bean.getP_cd3			()]\n"+bean.getP_cd3		());
				System.out.println("[bean.getP_cd4			()]\n"+bean.getP_cd4		());
				System.out.println("[bean.getP_cd5			()]\n"+bean.getP_cd5		());
				System.out.println("[bean.getP_st1			()]\n"+bean.getP_st1		());
				System.out.println("[bean.getP_st2			()]\n"+bean.getP_st2		());
				System.out.println("[bean.getP_st3			()]\n"+bean.getP_st3		());
				System.out.println("[bean.getP_st4			()]\n"+bean.getP_st4		());
				System.out.println("[bean.getP_st5			()]\n"+bean.getP_st5		());
				System.out.println("[bean.getP_cont			()]\n"+bean.getP_cont		());
				System.out.println("[bean.getOff_st			()]\n"+bean.getOff_st		());
				System.out.println("[bean.getOff_id			()]\n"+bean.getOff_id		());
				System.out.println("[bean.getOff_nm			()]\n"+bean.getOff_nm		());
				System.out.println("[bean.getVen_code		()]\n"+bean.getVen_code		());
				System.out.println("[bean.getVen_name		()]\n"+bean.getVen_name		());
				System.out.println("[bean.getAmt			()]\n"+bean.getAmt			());
				System.out.println("[bean.getBank_nm		()]\n"+bean.getBank_nm		());
				System.out.println("[bean.getBank_no		()]\n"+bean.getBank_no		());
				System.out.println("[bean.getReg_id			()]\n"+bean.getReg_id		());
				System.out.println("[bean.getP_gubun_etc	()]\n"+bean.getP_gubun_etc	());
				System.out.println("[bean.getAcct_code		()]\n"+bean.getAcct_code	());
				System.out.println("[bean.getBank_id		()]\n"+bean.getBank_id		());
				System.out.println("[bean.getP_req_dt		()]\n"+bean.getP_req_dt		());
				System.out.println("[bean.getSub_amt1		()]\n"+bean.getSub_amt1		());
				System.out.println("[bean.getSub_amt2		()]\n"+bean.getSub_amt2		());
				System.out.println("[bean.getSub_amt3		()]\n"+bean.getSub_amt3		());
				System.out.println("[bean.getSub_amt4		()]\n"+bean.getSub_amt4		());
				System.out.println("[bean.getSub_amt5		()]\n"+bean.getSub_amt5		());
				System.out.println("[bean.getSub_amt6		()]\n"+bean.getSub_amt6		());
				System.out.println("[bean.getCard_id		()]\n"+bean.getCard_id		());
				System.out.println("[bean.getCard_nm		()]\n"+bean.getCard_nm		());
				System.out.println("[bean.getCard_no		()]\n"+bean.getCard_no		());
				System.out.println("[bean.getA_bank_id		()]\n"+bean.getA_bank_id	());
				System.out.println("[bean.getA_bank_nm		()]\n"+bean.getA_bank_nm	());
				System.out.println("[bean.getA_bank_no		()]\n"+bean.getA_bank_no	());
				System.out.println("[bean.getR_est_dt		()]\n"+bean.getR_est_dt		());
				System.out.println("[bean.getP_pay_dt		()]\n"+bean.getP_pay_dt		());
				System.out.println("[bean.getBank_code		()]\n"+bean.getBank_code	());
				System.out.println("[bean.getBuy_user_id	()]\n"+bean.getBuy_user_id	());
				System.out.println("[bean.getVen_st			()]\n"+bean.getVen_st		());
				System.out.println("[bean.getTax_yn			()]\n"+bean.getTax_yn		());
				System.out.println("[bean.getSavepath		()]\n"+bean.getSavepath		());
				System.out.println("[bean.getFilename1		()]\n"+bean.getFilename1	());
				System.out.println("[bean.getFilename2		()]\n"+bean.getFilename2	());
				System.out.println("[bean.getFilename3		()]\n"+bean.getFilename3	());
				System.out.println("[bean.getFilename4		()]\n"+bean.getFilename4	());
				System.out.println("[bean.getFilename5		()]\n"+bean.getFilename5	());
				System.out.println("[bean.getAcct_code_g	()]\n"+bean.getAcct_code_g	());
				System.out.println("[bean.getAcct_code_g2	()]\n"+bean.getAcct_code_g2	());
				System.out.println("[bean.getO_cau			()]\n"+bean.getO_cau		());
				System.out.println("[bean.getCall_t_nm		()]\n"+bean.getCall_t_nm	());
				System.out.println("[bean.getCall_t_tel		()]\n"+bean.getCall_t_tel	());
				System.out.println("[bean.getCall_t_chk		()]\n"+bean.getCall_t_chk	());
				System.out.println("[bean.getUser_su		()]\n"+bean.getUser_su		());
				System.out.println("[bean.getUser_cont		()]\n"+bean.getUser_cont	());
				System.out.println("[bean.getOff_tel		()]\n"+bean.getOff_tel		());
				System.out.println("[bean.getAct_union_yn	()]\n"+bean.getAct_union_yn	());

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
				if(rs != null )	    rs.close();
				if(pstmt1 != null )	pstmt1.close();
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean.getReqseq();
    }
	
	/**
     *	집금 등록
     */
    public String insertPay2(PayMngBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String id_query = "";
		String p_est_dt = bean.getP_est_dt();
		p_est_dt = p_est_dt.replace("/","");

		query = " INSERT INTO pay											"+
				" ( reqseq, reg_dt, reg_id , reg_st, p_way,					"+
				"   off_nm,  ven_name,  amt,  bank_nm,   					"+
				"   bank_no, a_bank_nm, a_bank_no,							"+
				"   p_est_dt, p_req_dt, a_pay_dt, bank_code,p_step,  		"+
				"   bank_acc_nm, p_pay_dt, commi							"+
				" ) VALUES													"+
				" ( ?,sysdate, ?, ?, ?,										"+
				"   ?, ?, ?, ?,												"+
				"   ?, ?, ?, 												"+
				"   ?, ?, ?, sysdate, ?, 									"+
				"   ?, ?, ?													"+
				"  )";

		id_query = " select to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(reqseq,9,7))+1), '0000000')), '0000001') reqseq"+
				" from pay "+
				" where substr(reqseq,1,8)=to_char(sysdate,'YYYYMMDD')";

	   try{

            con.setAutoCommit(false);

			//새 reqseq 조회
			pstmt1 = con.prepareStatement(id_query);
	    	rs = pstmt1.executeQuery();   	
			if(rs.next())
			{				
				bean.setReqseq(rs.getString(1));
			}
			rs.close();
			pstmt1.close();

			//등록
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,		bean.getReqseq			());
			pstmt.setString	(2,		bean.getReg_id			());
			pstmt.setString	(3,		bean.getReg_st			());
			pstmt.setString	(4,		bean.getP_way			());
			pstmt.setString	(5,		bean.getOff_nm			());
			pstmt.setString	(6,		bean.getVen_name		());
			pstmt.setLong	(7,		bean.getAmt				());
			pstmt.setString	(8,		bean.getBank_nm			());
			pstmt.setString (9,		bean.getBank_no			());
			pstmt.setString (10,	bean.getA_bank_nm		());
			pstmt.setString	(11,	bean.getA_bank_no		());
			pstmt.setString (12,	p_est_dt				  );
			pstmt.setString (13,	p_est_dt				  );
			pstmt.setString (14,	p_est_dt		          );
			pstmt.setString	(15,	bean.getP_step			());
			pstmt.setString	(16,	bean.getBank_acc_nm		());
			pstmt.setString	(17,	p_est_dt				  );
			pstmt.setInt	(18,	bean.getCommi			());
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;

				System.out.println("[PayMngDatabase:insertPay2]"+se);
				System.out.println("[bean.getReqseq			()]\n"+bean.getReqseq		());
				System.out.println("[bean.getReg_id			()]\n"+bean.getReg_id       ());
				System.out.println("[bean.getReg_st			()]\n"+bean.getReg_st		());
				System.out.println("[bean.getP_way			()]\n"+bean.getP_way		());
				System.out.println("[bean.getOff_nm			()]\n"+bean.getOff_nm		());
				System.out.println("[bean.getVen_name		()]\n"+bean.getVen_name		());
				System.out.println("[bean.getAmt			()]\n"+bean.getAmt			());
				System.out.println("[bean.getBank_nm		()]\n"+bean.getBank_nm		());
				System.out.println("[bean.getBank_no		()]\n"+bean.getBank_no		());
				System.out.println("p_est_dt				()]\n"+p_est_dt				  );
				System.out.println("[bean.getP_step			()]\n"+bean.getP_step		());
				System.out.println("[bean.getBank_acc_nm	()]\n"+bean.getBank_acc_nm	());
				System.out.println("[bean.getCommi			()]\n"+bean.getCommi		());
				

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
				if(rs != null )	    rs.close();
				if(pstmt1 != null )	pstmt1.close();
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean.getReqseq();
    }
	/**
     *	집금 등록
     */
    public boolean insertPayItem2(PayMngBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";
		String r_est_dt = bean.getR_est_dt();
		r_est_dt = r_est_dt.replace("/","");

		query = " INSERT INTO pay_item  									"+ 
				" ( reqseq, i_seq, p_gubun, 				  				"+ //1
				"   p_st2, p_st3, r_est_dt,									"+ //3
				"   i_amt, i_s_amt,											"+ //4
				"   acct_code,  p_cont 										"+ //6
				" ) VALUES													"+
				" ( ?, ?, ?,												"+ //1
				"   ?, ?, ?,												"+ //3
				"   ?, ?, 													"+ //4
				"   ?, ?													"+ //6
				"  )";														   


	   try{

            con.setAutoCommit(false);

			//등록
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,		bean.getReqseq			());
			pstmt.setInt	(2,		bean.getI_seq			());
			pstmt.setString	(3,		bean.getP_gubun			());
			pstmt.setString	(4,		bean.getP_st2			());
			pstmt.setString	(5,		bean.getP_st3			());
			pstmt.setString	(6,		r_est_dt				  );
			pstmt.setLong	(7,		bean.getI_amt			());
			pstmt.setLong   (8,		bean.getI_s_amt			());
			pstmt.setString (9,		bean.getAcct_code		());
			pstmt.setString (10,	bean.getP_cont			());
		
							
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;

				System.out.println("[PayMngDatabase:insertPayItem2]"+se);
				System.out.println("[bean.getReqseq			()]\n"+bean.getReqseq			());
				System.out.println("[bean.getI_seq			()]\n"+bean.getI_seq			());
				System.out.println("[bean.getP_gubun		()]\n"+bean.getP_gubun			());
				System.out.println("[bean.getP_st2			()]\n"+bean.getP_st2			());
				System.out.println("[bean.getP_st3			()]\n"+bean.getP_st3			());
				System.out.println("[bean.getR_est_dt		()]\n"+bean.getR_est_dt			());
				System.out.println("[bean.getI_amt			()]\n"+bean.getI_amt			());
				System.out.println("[bean.getI_s_amt		()]\n"+bean.getI_s_amt			());
				System.out.println("[bean.getAcct_code		()]\n"+bean.getAcct_code		());
				System.out.println("[bean.getP_cont			()]\n"+bean.getP_cont			());

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }


    /**
     *	출금(조회-원본)원장 등록
     */
    public String insertPay(PayMngBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String id_query = "";

		query = " INSERT INTO pay														"+
				" ( reqseq, reg_dt, reg_id, reg_st, p_way,								"+ //1 (5)
				"   off_st, off_id, off_nm, ven_code, ven_name,	ven_st, s_idno,			"+ //2 (7)
				"   amt, bank_id, bank_nm, bank_no, card_id, card_nm, card_no,			"+ //3 (7)
				"   a_bank_id, a_bank_nm, a_bank_no, tax_yn, r_acct_code,				"+ //4 (5)
				"   p_est_dt, p_req_dt, p_pay_dt, a_pay_dt,								"+ //5 (4)
				"   savepath, filename1, filename2, filename3, filename4, filename5,	"+ //6 (6)
				"   search_code, bank_code, p_step, acct_code_st, cash_acc_no, 			"+ //7 (3)
				"   bank_acc_nm, bank_cms_bk, a_bank_cms_bk, off_tel, at_once,          "+
                "   act_union_yn                                                        "+
				" ) VALUES																"+
				" ( ?, sysdate, ?, ?, ?,												"+ //1
				"   ?, ?, ?, ?, ?, ?, ?,												"+ //2
				"   ?, ?, ?, ?, ?, ?, ?,												"+ //3
				"   ?, ?, ?, ?, ?,														"+ //4
				"   replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''), replace(?, '-', ''), "+ //5
				"   ?, ?, ?, ?, ?, ?,													"+ //6
				"   ?, ?, ?, ?, ?,														"+ //7
				"   ?, ?, ?, ?, ?, ?                                                    "+
				"  )";

		id_query = " select to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(reqseq,9,7))+1), '0000000')), '0000001') reqseq"+
				" from pay "+
				" where substr(reqseq,1,8)=to_char(sysdate,'YYYYMMDD')";

	   try{

            con.setAutoCommit(false);

			//새 reqseq 조회
			pstmt1 = con.prepareStatement(id_query);
	    	rs = pstmt1.executeQuery();   	
			if(rs.next())
			{				
				bean.setReqseq(rs.getString(1));
			}
			rs.close();
			pstmt1.close();

			//등록
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,		bean.getReqseq			());
			pstmt.setString	(2,		bean.getReg_id			());
			pstmt.setString	(3,		bean.getReg_st			());
			pstmt.setString	(4,		bean.getP_way			());
			pstmt.setString	(5,		bean.getOff_st			());
			pstmt.setString	(6,		bean.getOff_id			());
			pstmt.setString	(7,		bean.getOff_nm			().trim());
			pstmt.setString	(8,		bean.getVen_code		());
			pstmt.setString (9,		bean.getVen_name		());
			pstmt.setString	(10,	bean.getVen_st			());
			pstmt.setString	(11,	bean.getS_idno			());
			pstmt.setLong	(12,	bean.getAmt				());
			pstmt.setString	(13,	bean.getBank_id			());
			pstmt.setString	(14,	bean.getBank_nm			());
			pstmt.setString	(15,	bean.getBank_no			().trim());
			pstmt.setString	(16,	bean.getCard_id			());
			pstmt.setString	(17,	bean.getCard_nm			());
			pstmt.setString	(18,	bean.getCard_no			());
			pstmt.setString	(19,	bean.getA_bank_id		());
			pstmt.setString	(20,	bean.getA_bank_nm		());
			pstmt.setString	(21,	bean.getA_bank_no		().trim());
			pstmt.setString	(22,	bean.getTax_yn			());
			pstmt.setString (23,	bean.getR_acct_code		());
			pstmt.setString	(24,	bean.getP_est_dt		());
			pstmt.setString	(25,	bean.getP_req_dt		());
			pstmt.setString	(26,	bean.getP_pay_dt		());
			pstmt.setString	(27,	bean.getA_pay_dt		());
			pstmt.setString	(28,	bean.getSavepath		());
			pstmt.setString	(29,	bean.getFilename1		());
			pstmt.setString	(30,	bean.getFilename2		());
			pstmt.setString	(31,	bean.getFilename3		());
			pstmt.setString	(32,	bean.getFilename4		());
			pstmt.setString (33,	bean.getFilename5		());
			pstmt.setString	(34,	bean.getSearch_code		());
			pstmt.setString	(35,	bean.getBank_code		());
			pstmt.setString	(36,	bean.getP_step			());
			pstmt.setString	(37,	bean.getAcct_code_st	());
			pstmt.setString	(38,	bean.getCash_acc_no		());
			pstmt.setString	(39,	bean.getBank_acc_nm		());
			pstmt.setString	(40,	bean.getBank_cms_bk		());
			pstmt.setString	(41,	bean.getA_bank_cms_bk	());
			pstmt.setString	(42,	bean.getOff_tel			());
			pstmt.setString	(43,	bean.getAt_once			());
			pstmt.setString	(44,	bean.getAct_union_yn	());

			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				bean.setReqseq("");

				System.out.println("[PayMngDatabase:insertPay]"+se);
				System.out.println("[bean.getReqseq			()]\n"+bean.getReqseq			());
				System.out.println("[bean.getReg_id			()]\n"+bean.getReg_id			());
				System.out.println("[bean.getReg_st			()]\n"+bean.getReg_st			());
				System.out.println("[bean.getP_way			()]\n"+bean.getP_way			());
				System.out.println("[bean.getOff_st			()]\n"+bean.getOff_st			());
				System.out.println("[bean.getOff_id			()]\n"+bean.getOff_id			());
				System.out.println("[bean.getOff_nm			()]\n"+bean.getOff_nm			());
				System.out.println("[bean.getVen_code		()]\n"+bean.getVen_code			());
				System.out.println("[bean.getVen_name		()]\n"+bean.getVen_name			());
				System.out.println("[bean.getVen_st			()]\n"+bean.getVen_st			());
				System.out.println("[bean.getS_idno			()]\n"+bean.getS_idno			());
				System.out.println("[bean.getAmt			()]\n"+bean.getAmt				());
				System.out.println("[bean.getBank_id		()]\n"+bean.getBank_id			());
				System.out.println("[bean.getBank_nm		()]\n"+bean.getBank_nm			());
				System.out.println("[bean.getBank_no		()]\n"+bean.getBank_no			());
				System.out.println("[bean.getCard_id		()]\n"+bean.getCard_id			());
				System.out.println("[bean.getCard_nm		()]\n"+bean.getCard_nm			());
				System.out.println("[bean.getCard_no		()]\n"+bean.getCard_no			());
				System.out.println("[bean.getA_bank_id		()]\n"+bean.getA_bank_id		());
				System.out.println("[bean.getA_bank_nm		()]\n"+bean.getA_bank_nm		());
				System.out.println("[bean.getA_bank_no		()]\n"+bean.getA_bank_no		());
				System.out.println("[bean.getTax_yn			()]\n"+bean.getTax_yn			());
				System.out.println("[bean.getR_acct_code	()]\n"+bean.getR_acct_code		());
				System.out.println("[bean.getP_est_dt		()]\n"+bean.getP_est_dt			());
				System.out.println("[bean.getP_req_dt		()]\n"+bean.getP_req_dt			());
				System.out.println("[bean.getP_pay_dt		()]\n"+bean.getP_pay_dt			());
				System.out.println("[bean.getR_est_dt		()]\n"+bean.getR_est_dt			());
				System.out.println("[bean.getA_pay_dt		()]\n"+bean.getA_pay_dt			());
				System.out.println("[bean.getSavepath		()]\n"+bean.getSavepath			());
				System.out.println("[bean.getFilename1		()]\n"+bean.getFilename1		());
				System.out.println("[bean.getFilename2		()]\n"+bean.getFilename2		());
				System.out.println("[bean.getFilename3		()]\n"+bean.getFilename3		());
				System.out.println("[bean.getFilename4		()]\n"+bean.getFilename4		());
				System.out.println("[bean.getFilename5		()]\n"+bean.getFilename5		());
				System.out.println("[bean.getSearch_code	()]\n"+bean.getSearch_code		());
				System.out.println("[bean.getP_step			()]\n"+bean.getP_step			());
				System.out.println("[bean.getBank_code		()]\n"+bean.getBank_code		());
				System.out.println("[bean.getAcct_code_st	()]\n"+bean.getAcct_code_st		());
				System.out.println("[bean.getCash_acc_no	()]\n"+bean.getCash_acc_no		());
				System.out.println("[bean.getBank_acc_nm	()]\n"+bean.getBank_acc_nm		());
				System.out.println("[bean.getOff_tel		()]\n"+bean.getOff_tel			());
				System.out.println("[bean.getAt_once		()]\n"+bean.getAt_once			());
				System.out.println("[bean.getAct_union_yn	()]\n"+bean.getAct_union_yn		());

				con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
				if(rs != null )	    rs.close();
				if(pstmt1 != null )	pstmt1.close();
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean.getReqseq();
    }


    /**
     *	출금(조회-원본)원장 등록
     */
    public boolean insertPayItem(PayMngBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";

		query = " INSERT INTO pay_item  									"+ 
				" ( reqseq, i_seq, p_gubun, 				  				"+ //1
				"   p_cd1, p_cd2, p_cd3, p_cd4, p_cd5, p_cd6,				"+ //2
				"   p_st1, p_st2, p_st3, p_st4, p_st5,						"+ //3
				"   r_est_dt, buy_user_id, i_amt, i_s_amt, i_v_amt, 		"+ //4
				"   sub_amt1, sub_amt2, sub_amt3, sub_amt4, sub_amt5,		"+ //5
				"   acct_code, acct_code_g, acct_code_g2, p_cont, 			"+ //6
				"   o_cau, call_t_nm, call_t_tel, call_t_chk,				"+ //7
				"   user_su, user_cont, cost_gubun, sub_amt6, tot_dist		"+ //9
				" ) VALUES													"+
				" ( ?, ?, ?,												"+ //1
				"   ?, ?, ?, ?, ?, ?, 										"+ //2
				"   ?, ?, ?, ?, ?,											"+ //3
				"   replace(?, '-', ''), ?, ?, ?, ?, 						"+ //4
				"   ?, ?, ?, ?, ?,											"+ //5
				"   ?, ?, ?, ?,												"+ //6
				"   ?, ?, ?, ?, 											"+ //7
				"   ?, ?, ?, ?, ?											"+ //9
				"  )";														   


	   try{

            con.setAutoCommit(false);

			//등록
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,		bean.getReqseq			());
			pstmt.setInt	(2,		bean.getI_seq			());
			pstmt.setString	(3,		bean.getP_gubun			());
			pstmt.setString	(4,		bean.getP_cd1			());
			pstmt.setString	(5,		bean.getP_cd2			());
			pstmt.setString	(6,		bean.getP_cd3			());
			pstmt.setString	(7,		bean.getP_cd4			());
			pstmt.setString (8,		bean.getP_cd5			());
			pstmt.setString (9,		bean.getP_cd6			());
			pstmt.setString (10,	bean.getP_st1			());
			pstmt.setString	(11,	bean.getP_st2			());
			pstmt.setString	(12,	bean.getP_st3			());
			pstmt.setString	(13,	bean.getP_st4			());
			pstmt.setString	(14,	bean.getP_st5			());
			pstmt.setString	(15,	bean.getR_est_dt		());
			pstmt.setString	(16,	bean.getBuy_user_id		());
			pstmt.setLong	(17,	bean.getI_amt			());
			pstmt.setLong	(18,	bean.getI_s_amt			());
			pstmt.setLong	(19,	bean.getI_v_amt			());
			pstmt.setLong	(20,	bean.getSub_amt1		());
			pstmt.setLong	(21,	bean.getSub_amt2		());
			pstmt.setLong	(22,	bean.getSub_amt3		());
			pstmt.setLong	(23,	bean.getSub_amt4		());
			pstmt.setLong	(24,	bean.getSub_amt5		());
			pstmt.setString	(25,	bean.getAcct_code		());
			pstmt.setString (26,	bean.getAcct_code_g		());
			pstmt.setString	(27,	bean.getAcct_code_g2	());
			pstmt.setString	(28,	bean.getP_cont			());
			pstmt.setString	(29,	bean.getO_cau			());
			pstmt.setString	(30,	bean.getCall_t_nm		());
			pstmt.setString	(31,	bean.getCall_t_tel		());
			pstmt.setString	(32,	bean.getCall_t_chk		());
			pstmt.setString	(33,	bean.getUser_su			());
			pstmt.setString	(34,	bean.getUser_cont		());
			pstmt.setString	(35,	bean.getCost_gubun		());
			pstmt.setLong	(36,	bean.getSub_amt6		());
			pstmt.setInt	(37,	bean.getTot_dist		());
							
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;

				System.out.println("[PayMngDatabase:insertPayItem]"+se);
				System.out.println("[bean.getReqseq			()]\n"+bean.getReqseq			());
				System.out.println("[bean.getI_seq			()]\n"+bean.getI_seq			());
				System.out.println("[bean.getP_gubun		()]\n"+bean.getP_gubun			());
				System.out.println("[bean.getP_cd1			()]\n"+bean.getP_cd1			());
				System.out.println("[bean.getP_cd2			()]\n"+bean.getP_cd2			());
				System.out.println("[bean.getP_cd3			()]\n"+bean.getP_cd3			());
				System.out.println("[bean.getP_cd4			()]\n"+bean.getP_cd4			());
				System.out.println("[bean.getP_cd5			()]\n"+bean.getP_cd5			());
				System.out.println("[bean.getP_cd6			()]\n"+bean.getP_cd6			());
				System.out.println("[bean.getP_st1			()]\n"+bean.getP_st1			());
				System.out.println("[bean.getP_st2			()]\n"+bean.getP_st2			());
				System.out.println("[bean.getP_st3			()]\n"+bean.getP_st3			());
				System.out.println("[bean.getP_st4			()]\n"+bean.getP_st4			());
				System.out.println("[bean.getP_st5			()]\n"+bean.getP_st5			());
				System.out.println("[bean.getR_est_dt		()]\n"+bean.getR_est_dt			());
				System.out.println("[bean.getBuy_user_id	()]\n"+bean.getBuy_user_id		());
				System.out.println("[bean.getI_amt			()]\n"+bean.getI_amt			());
				System.out.println("[bean.getI_s_amt		()]\n"+bean.getI_s_amt			());
				System.out.println("[bean.getI_v_amt		()]\n"+bean.getI_v_amt			());
				System.out.println("[bean.getSub_amt1		()]\n"+bean.getSub_amt1			());
				System.out.println("[bean.getSub_amt2		()]\n"+bean.getSub_amt2			());
				System.out.println("[bean.getSub_amt3		()]\n"+bean.getSub_amt3			());
				System.out.println("[bean.getSub_amt4		()]\n"+bean.getSub_amt4			());
				System.out.println("[bean.getSub_amt5		()]\n"+bean.getSub_amt5			());
				System.out.println("[bean.getSub_amt6		()]\n"+bean.getSub_amt6			());
				System.out.println("[bean.getAcct_code		()]\n"+bean.getAcct_code		());
				System.out.println("[bean.getAcct_code_g	()]\n"+bean.getAcct_code_g		());
				System.out.println("[bean.getAcct_code_g2	()]\n"+bean.getAcct_code_g2		());
				System.out.println("[bean.getP_cont			()]\n"+bean.getP_cont			());
				System.out.println("[bean.getO_cau			()]\n"+bean.getO_cau			());
				System.out.println("[bean.getCall_t_nm		()]\n"+bean.getCall_t_nm		());
				System.out.println("[bean.getCall_t_tel		()]\n"+bean.getCall_t_tel		());
				System.out.println("[bean.getCall_t_chk		()]\n"+bean.getCall_t_chk		());
				System.out.println("[bean.getUser_su		()]\n"+bean.getUser_su			());
				System.out.println("[bean.getUser_cont		()]\n"+bean.getUser_cont		());

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	출금원장 사용자 등록
     */
    public boolean insertPayItemUser(PayMngUserBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query = "";

		query = " INSERT INTO pay_item_user ("+
				"	reqseq,		"+
				"	i_seq,	   	"+
				"	u_seq,	   	"+
				"	pay_user,   "+
				"	pay_amt 	"+
				" ) VALUES"+
				" ( ?, ?, ?, ?, ?)";

	   try{

            con.setAutoCommit(false);

			//등록
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,		bean.getReqseq		());
			pstmt.setInt	(2,		bean.getI_seq		());
			pstmt.setInt	(3,		bean.getU_seq		());
			pstmt.setString	(4,		bean.getPay_user	());
			pstmt.setInt	(5,		bean.getPay_amt		());

			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:insertPayItemUser]"+se);

				System.out.println("[bean.getReqseq		()]\n"+bean.getReqseq	()+"|");
				System.out.println("[bean.getI_seq		()]\n"+bean.getI_seq	()+"|");
				System.out.println("[bean.getU_seq		()]\n"+bean.getU_seq	()+"|");
				System.out.println("[bean.getPay_user	()]\n"+bean.getPay_user	()+"|");
				System.out.println("[bean.getPay_amt	()]\n"+bean.getPay_amt	()+"|");

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	출금원장 등록
     */
    public boolean insertPayAct(PayMngActBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String query = "";
		String id_query = "";

		query = " INSERT INTO pay_act							"+
				" ( actseq, reg_dt, reg_id,						"+
				"   act_st, act_dt, amt, commi,					"+
				"   bank_id, bank_nm, bank_no,					"+
				"   a_bank_id, a_bank_nm, a_bank_no,			"+
				"   act_bit, bank_code, off_nm,					"+
				"   bank_acc_nm, bank_cms_bk, a_bank_cms_bk,    "+
				"   app_id, bank_memo, at_once                  "+
				" ) VALUES										"+
				" ( ?, sysdate, ?,								"+
				"   ?, replace(?, '-', ''), ?, ?,				"+
				"   ?, ?, ?,									"+
				"   ?, ?, ?,									"+
				"   ?, ?, ?, ?, ?, ?,							"+
				"   ?, ?, ?                                     "+
				"  )";

		id_query = " select to_char(sysdate,'YYYYMMDD')||nvl(ltrim(to_char(to_number(max(substr(actseq,9,7))+1), '0000000')), '0000001') actseq"+
				" from pay_act "+
				" where substr(actseq,1,8)=to_char(sysdate,'YYYYMMDD')";

	   try{

            con.setAutoCommit(false);

			//새 actseq 조회
			pstmt1 = con.prepareStatement(id_query);
	    	rs = pstmt1.executeQuery();   	
			if(rs.next())
			{				
				bean.setActseq(rs.getString(1));
			}
			rs.close();
			pstmt1.close();

			//등록
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,		bean.getActseq			());
			pstmt.setString	(2,		bean.getReg_id			());
			pstmt.setString	(3,		bean.getAct_st			());
			pstmt.setString	(4,		bean.getAct_dt			());
			pstmt.setLong	(5,		bean.getAmt				());
			pstmt.setInt	(6,		bean.getCommi			());
			pstmt.setString	(7,		bean.getBank_id			());
			pstmt.setString	(8,		bean.getBank_nm			());
			pstmt.setString (9,		bean.getBank_no			().trim());
			pstmt.setString (10,	bean.getA_bank_id		());
			pstmt.setString	(11,	bean.getA_bank_nm		());
			pstmt.setString	(12,	bean.getA_bank_no		().trim());
			pstmt.setString	(13,	bean.getAct_bit			());
			pstmt.setString	(14,	bean.getBank_code		());
			pstmt.setString	(15,	bean.getOff_nm			().trim());
			pstmt.setString	(16,	bean.getBank_acc_nm		());
			pstmt.setString	(17,	bean.getBank_cms_bk		());
			pstmt.setString	(18,	bean.getA_bank_cms_bk	());
			pstmt.setString	(19,	bean.getApp_id			());
			pstmt.setString	(20,	bean.getBank_memo		());
			pstmt.setString	(21,	bean.getAt_once			());


			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:insertPayAct]"+se);

				System.out.println("[bean.getActseq			()]\n"+bean.getActseq			()+"|");
				System.out.println("[bean.getReg_id			()]\n"+bean.getReg_id			()+"|");
				System.out.println("[bean.getAct_st			()]\n"+bean.getAct_st			()+"|");
				System.out.println("[bean.getAct_dt			()]\n"+bean.getAct_dt			()+"|");
				System.out.println("[bean.getAmt			()]\n"+bean.getAmt				()+"|");
				System.out.println("[bean.getCommi			()]\n"+bean.getCommi			()+"|");
				System.out.println("[bean.getBank_id		()]\n"+bean.getBank_id			()+"|");
				System.out.println("[bean.getBank_nm		()]\n"+bean.getBank_nm			()+"|");
				System.out.println("[bean.getBank_no		()]\n"+bean.getBank_no			()+"|");
				System.out.println("[bean.getA_bank_id		()]\n"+bean.getA_bank_id		()+"|");
				System.out.println("[bean.getA_bank_nm		()]\n"+bean.getA_bank_nm		()+"|");
				System.out.println("[bean.getA_bank_no		()]\n"+bean.getA_bank_no		()+"|");
				System.out.println("[bean.getAct_bit		()]\n"+bean.getAct_bit			()+"|");
				System.out.println("[bean.getBank_code		()]\n"+bean.getBank_code		()+"|");
				System.out.println("[bean.getOff_nm			()]\n"+bean.getOff_nm			()+"|");
				System.out.println("[bean.getBank_acc_nm	()]\n"+bean.getBank_acc_nm		()+"|");
				System.out.println("[bean.getBank_cms_bk	()]\n"+bean.getBank_cms_bk		()+"|");
				System.out.println("[bean.getA_bank_cms_bk	()]\n"+bean.getA_bank_cms_bk	()+"|");
				System.out.println("[bean.getApp_id			()]\n"+bean.getApp_id			()+"|");
				System.out.println("[bean.getBank_memo		()]\n"+bean.getBank_memo		()+"|");

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
				if(rs != null )	    rs.close();
				if(pstmt1 != null )	pstmt1.close();
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	출금원장 수정
     */
    public boolean updatePay(PayMngBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update pay set "+

						"        p_est_dt			=replace(?,'-',''), "+	
						"        p_way				=?, "+
						"        off_st				=?, "+
						"        off_id				=?, "+
						"        off_nm				=?, "+
						"        ven_code			=?, "+
						"        ven_name			=?, "+
						"        amt				=?, "+
						"        bank_nm			=?, "+
						"        bank_no			=?, "+
						"        p_pay_dt			=replace(?,'-',''),  "+
						"        doc_code			=?, "+
						"        bank_id			=?, "+
						"        p_req_dt			=replace(?,'-',''), "+
						"        a_bank_id			=?, "+
						"        a_bank_nm			=?, "+
						"        a_bank_no			=?, "+
						"        a_pay_dt			=replace(?,'-',''), "+
						"        pay_code			=?, "+
						"        card_id			=?, "+
						"        card_nm			=?, "+
						"        card_no			=?, "+
						"        bank_code			=?, "+
						"        ven_st				=?, "+
						"        tax_yn				=?, "+
						"        s_idno				=?, "+
						"        acct_code_st		=?, "+
						"        cash_acc_no		=?, "+
						"        bank_acc_nm		=?, "+
						"        bank_cms_bk		=?, "+
						"        a_bank_cms_bk		=?, "+
						"        off_tel			=?,  "+
						"        p_est_dt2			=replace(?,'-',''), "+	
						"        at_once			=?  "+
						" where  reqseq				=?  ";


	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);
			
			pstmt.setString (1,		bean.getP_est_dt		());
			pstmt.setString	(2,		bean.getP_way			());
			pstmt.setString	(3,		bean.getOff_st			());
			pstmt.setString (4,		bean.getOff_id			());
			pstmt.setString	(5,		bean.getOff_nm			().trim());
			pstmt.setString	(6,		bean.getVen_code		());
			pstmt.setString	(7,		bean.getVen_name		());
			pstmt.setLong   (8,		bean.getAmt				());
			pstmt.setString	(9,		bean.getBank_nm			());
			pstmt.setString	(10,	bean.getBank_no			().trim());
			pstmt.setString	(11,	bean.getP_pay_dt		());
			pstmt.setString	(12,	bean.getDoc_code		());
			pstmt.setString	(13,	bean.getBank_id			());
			pstmt.setString (14,	bean.getP_req_dt		());
			pstmt.setString	(15,	bean.getA_bank_id		());
			pstmt.setString	(16,	bean.getA_bank_nm		());
			pstmt.setString (17,	bean.getA_bank_no		().trim());
			pstmt.setString	(18,	bean.getA_pay_dt		());
			pstmt.setString (19,	bean.getPay_code		());
			pstmt.setString	(20,	bean.getCard_id			());
			pstmt.setString	(21,	bean.getCard_nm			());
			pstmt.setString (22,	bean.getCard_no			());
			pstmt.setString	(23,	bean.getBank_code		());
			pstmt.setString (24,	bean.getVen_st			());
			pstmt.setString	(25,	bean.getTax_yn			());
			pstmt.setString (26,	bean.getS_idno			());
			pstmt.setString (27,	bean.getAcct_code_st	());
			pstmt.setString (28,	bean.getCash_acc_no		());
			pstmt.setString (29,	bean.getBank_acc_nm		());
			pstmt.setString	(30,	bean.getBank_cms_bk		());
			pstmt.setString	(31,	bean.getA_bank_cms_bk	());
			pstmt.setString	(32,	bean.getOff_tel			());
			pstmt.setString (33,	bean.getP_est_dt2		());
			pstmt.setString (34,	bean.getAt_once			());
			pstmt.setString	(35,	bean.getReqseq			());


			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePay]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	출금원장 수정
     */
    public boolean updatePayItem(PayMngBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update pay_item set "+

						"        p_cd1				=?, "+
						"        p_cd2				=?, "+
						"        p_cd3				=?, "+
						"        p_cd4				=?, "+
						"        p_cd5				=?, "+
						"        p_cd6				=?, "+
						"        p_st1				=?, "+
						"        p_st2				=?, "+
						"        p_st3				=?, "+
						"        p_st4				=?, "+
						"        p_st5				=?, "+
						"        p_cont				=?, "+
						"        i_amt				=?, "+
						"        i_s_amt			=?, "+
						"        i_v_amt			=?, "+
						"        acct_code			=?, "+
						"        sub_amt1			=?, "+
						"        sub_amt2			=?, "+
						"        sub_amt3			=?, "+
						"        sub_amt4			=?, "+
						"        sub_amt5			=?, "+
						"        buy_user_id		=?, "+
						"        acct_code_g		=?, "+
						"        acct_code_g2		=?, "+
						"        o_cau				=?, "+
						"        call_t_nm			=?, "+
						"        call_t_tel			=?, "+
						"        call_t_chk			=?, "+
						"        user_su			=?, "+
						"        user_cont			=?, "+
						"        accid_reg_yn		=?, "+
						"        serv_reg_yn		=?, "+
						"        maint_reg_yn		=?, "+
						"        cost_gubun			=?, "+
						"        sub_amt6			=? "+

						" where  reqseq				=?  "+
						"        and i_seq			=?	"+ 
						" ";


	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);
			
			pstmt.setString	(1,		bean.getP_cd1			());
			pstmt.setString (2,		bean.getP_cd2			());
			pstmt.setString	(3,		bean.getP_cd3			());
			pstmt.setString	(4,		bean.getP_cd4			());
			pstmt.setString	(5,		bean.getP_cd5			());
			pstmt.setString (6,		bean.getP_cd6			());
			pstmt.setString	(7,		bean.getP_st1			());
			pstmt.setString	(8,		bean.getP_st2			());
			pstmt.setString	(9,		bean.getP_st3			());
			pstmt.setString (10,	bean.getP_st4			());
			pstmt.setString	(11,	bean.getP_st5			());
			pstmt.setString	(12,	bean.getP_cont			());
			pstmt.setLong   (13,	bean.getI_amt			());
			pstmt.setLong   (14,	bean.getI_s_amt			());
			pstmt.setLong   (15,	bean.getI_v_amt			());
			pstmt.setString	(16,	bean.getAcct_code		());
			pstmt.setLong  	(17,	bean.getSub_amt1		());
			pstmt.setLong  	(18,	bean.getSub_amt2		());
			pstmt.setLong  	(19,	bean.getSub_amt3		());
			pstmt.setLong   (20,	bean.getSub_amt4		());
			pstmt.setLong  	(21,	bean.getSub_amt5		());
			pstmt.setString	(22,	bean.getBuy_user_id		());
			pstmt.setString (23,	bean.getAcct_code_g		());
			pstmt.setString	(24,	bean.getAcct_code_g2	());
			pstmt.setString	(25,	bean.getO_cau			());
			pstmt.setString	(26,	bean.getCall_t_nm		());
			pstmt.setString (27,	bean.getCall_t_tel		());
			pstmt.setString	(28,	bean.getCall_t_chk		());
			pstmt.setString	(29,	bean.getUser_su			());
			pstmt.setString	(30,	bean.getUser_cont		());			
			pstmt.setString	(31,	bean.getAccid_reg_yn	());			
			pstmt.setString	(32,	bean.getServ_reg_yn		());			
			pstmt.setString	(33,	bean.getMaint_reg_yn	());			
			pstmt.setString	(34,	bean.getCost_gubun		());		
			pstmt.setLong  	(35,	bean.getSub_amt6		());

			pstmt.setString	(36,	bean.getReqseq			());
			pstmt.setInt    (37,	bean.getI_seq			());

			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayItem]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	출금원장 수정
     */
    public boolean updatePayAmt(String reqseq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update pay set "+
						"        amt	=( select sum(i_amt) from pay_item where reqseq=?) "+
						" where  reqseq	=?  "+
						" ";

	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);			
			pstmt.setString	(1,		reqseq);
			pstmt.setString (2,		reqseq);
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayAmt]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	출금원장 수정
     */
    public boolean updateServiceSpdchk(String car_mng_id, String serv_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update service set "+
						"        spdchk	='1:radiobutton30/1:radiobutton31/1:radiobutton32/1:radiobutton33/1:radiobutton11/1:radiobutton12/1:radiobutton13/1:radiobutton14/1:radiobutton15/1:radiobutton16/1:radiobutton17/1:radiobutton18/3:radiobutton19/1:radiobutton10/1:radiobutton0/1:radiobutton1/1:radiobutton2/1:radiobutton4/1:radiobutton5/1:radiobutton6/1:radiobutton7/1:radiobutton9/1:radiobutton8/1:radiobutton3/1:radiobutton24/1:radiobutton25/1:radiobutton26/1:radiobutton27/1:radiobutton28/1:radiobutton29/1:radiobutton23/1:radiobutton22/1:radiobutton21/1:radiobutton20/' "+
						" where  car_mng_id	=? and serv_id=?  "+
						" ";

	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);			
			pstmt.setString	(1,		car_mng_id);
			pstmt.setString (2,		serv_id);
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updateServiceSpdchk]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	출금원장 수정
     */
    public boolean updateServiceCall(String car_mng_id, String serv_id, String call_t_nm, String call_t_tel) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update service set "+
						"        call_t_nm=?, call_t_tel=? "+
						" where  car_mng_id	=? and serv_id=?  "+
						" ";

	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);			
			pstmt.setString	(1,		call_t_nm);
			pstmt.setString (2,		call_t_tel);
			pstmt.setString	(3,		car_mng_id);
			pstmt.setString (4,		serv_id);
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updateServiceCall]"+se);
				System.out.println(" update service set  call_t_nm="+call_t_nm+", call_t_tel="+call_t_tel+" where  car_mng_id	="+car_mng_id+" and serv_id="+serv_id+"");
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	출금원장 수정
     */
    public boolean updatePayBF(PayMngBean bean, String file_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update pay set savepath=? ";

		if(file_st.equals("1")) query += 	"        , filename1	=? ";
		if(file_st.equals("2")) query += 	"        , filename2	=? ";
		if(file_st.equals("3")) query += 	"        , filename3	=? ";
		if(file_st.equals("4")) query += 	"        , filename4	=? ";
		if(file_st.equals("5")) query += 	"        , filename5	=? ";

		query += " where  reqseq		=?    ";


	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);

			pstmt.setString	(1,	 bean.getSavepath	());

			if(file_st.equals("1"))		pstmt.setString	(2,	 bean.getFilename1	());
			if(file_st.equals("2"))		pstmt.setString	(2,	 bean.getFilename2	());
			if(file_st.equals("3"))		pstmt.setString	(2,	 bean.getFilename3	());
			if(file_st.equals("4"))		pstmt.setString	(2,	 bean.getFilename4	());
			if(file_st.equals("5"))		pstmt.setString	(2,	 bean.getFilename5	());

			pstmt.setString	(3,	 bean.getReqseq		());


			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayBF]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	출금원장 수정
     */
    public boolean updatePayBFD(PayMngBean bean, String file_st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update pay set ";

		if(file_st.equals("1")) query += 	"         filename1	='' ";
		if(file_st.equals("2")) query += 	"         filename2	='' ";
		if(file_st.equals("3")) query += 	"         filename3	='' ";
		if(file_st.equals("4")) query += 	"         filename4	='' ";
		if(file_st.equals("5")) query += 	"         filename5	='' ";

		query += " where  reqseq		=?    ";


	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	 bean.getReqseq		());
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayBFD]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	기안결정
     */
    public boolean updatePayDoccode(String reqseq, String doc_code, String req_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update pay set "+
						"        doc_code	=replace(?,'-',''), "+
						"        p_req_dt	=replace(?,'-',''), "+
						"        p_step		='1' "+
						" where  reqseq=?   and p_step='0'";

	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);
			pstmt.setString(1,  doc_code);
			pstmt.setString(2,  req_dt);
			pstmt.setString(3,  reqseq);
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayDoccode]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	기안결정
     */
    public boolean updatePayDC(String reqseq, String req_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update pay set "+
						"        p_req_dt	=replace(?,'-',''), "+
						"        p_pay_dt	=replace(?,'-',''), "+
						"        p_step		='4' "+
						" where  reqseq=?   and p_step='0'";

	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);
			pstmt.setString(1,  req_dt);
			pstmt.setString(2,  req_dt);
			pstmt.setString(3,  reqseq);
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayDC]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	기안등록
     */
    public boolean updatePayD(PayMngBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update pay set						"+
						"        doc_code	=?,					"+
						"        p_est_dt2	=replace(?,'-',''),	"+
						"        p_step		=?	                "+
						" where  reqseq		=?					";


	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	bean.getDoc_code	());
			pstmt.setString	(2,	bean.getP_est_dt2	());
			pstmt.setString	(3,	bean.getP_step		());
			pstmt.setString	(4, bean.getReqseq		());
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayD]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	회계송금요청결정
     */
    public boolean updatePayABankcode(String reqseq, String bank_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update pay set "+
						"        bank_code	=replace(?,'-','') "+
						" where  reqseq=? and a_pay_dt is null";

	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);
			pstmt.setString(1,  bank_code);
			pstmt.setString(2,  reqseq);
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayABankcode]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	회계송금요청결정
     */
    public boolean updatePayABankcodeNull(String bank_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update pay set  "+
						"        bank_code	= '' "+
						" where  bank_code=replace(?,'-','')";

	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);
			pstmt.setString(1,  bank_code);
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayABankcodeNull]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	회계송금요청결정
     */
    public boolean updatePayABankcodeM(String reqseq, String bank_code, int m_amt, String m_cau) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update pay set "+
						"        bank_code	=replace(?,'-',''), "+
						"        m_amt		=?,                 "+
						"        m_cau		=?                  "+
						" where  reqseq=? ";

	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);
			pstmt.setString(1,  bank_code);
			pstmt.setInt   (2,  m_amt);
			pstmt.setString(3,  m_cau);
			pstmt.setString(4,  reqseq);
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayABankcodeM]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	출금원장 수정
     */
    public boolean updatePayA(PayMngBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update pay      set						"+
						"        a_bank_id		=?,					"+
						"        a_bank_nm		=?,					"+
						"        a_bank_no		=?,					"+
						"        a_bank_cms_bk	=?,					"+
						"        bank_id		=?,					"+
						"        bank_nm		=?,					"+
						"        bank_no		=?,					"+
						"        bank_cms_bk	=?,					"+
						"        a_pay_dt		=replace(?,'-',''),	"+
						"        p_pay_dt		=replace(?,'-',''),	"+
						"        p_step			=?	                "+
						" where  reqseq			=?					";


	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);

			pstmt.setString	(1,	 bean.getA_bank_id		());
			pstmt.setString	(2,	 bean.getA_bank_nm		());
			pstmt.setString	(3,	 bean.getA_bank_no		().trim());
			pstmt.setString	(4,	 bean.getA_bank_cms_bk	());
			pstmt.setString	(5,	 bean.getBank_id		());
			pstmt.setString	(6,	 bean.getBank_nm		());
			pstmt.setString	(7,	 bean.getBank_no		().trim());
			pstmt.setString	(8,	 bean.getBank_cms_bk	());
			pstmt.setString	(9,	 bean.getA_pay_dt		());
			pstmt.setString	(10, bean.getP_pay_dt		());
			pstmt.setString	(11, bean.getP_step			());
			pstmt.setString	(12, bean.getReqseq			());
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayA]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	출금원장 수정
     */
    public boolean updatePayR(PayMngBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update pay      set					"+
						"        commi		=?					"+
						" where  reqseq		=?					";

	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);

			pstmt.setInt	(1,	bean.getCommi		());
			pstmt.setString	(2, bean.getReqseq		());
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayR]"+se);
				System.out.println("[PayMngDatabase:updatePayR]"+query);
				System.out.println("[PayMngDatabase:updatePayR]"+bean.getCommi		());
				System.out.println("[PayMngDatabase:updatePayR]"+bean.getReqseq		());

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	출금원장 수정
     */
    public boolean updatePayAccCng(PayMngBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " update pay			set "+
						"        p_way			=?, "+
						"        bank_id		=?, "+
						"        bank_nm		=?, "+
						"        bank_no		=?, "+
						"        bank_cms_bk	=?, "+
						"        bank_acc_nm	=?, "+
						"        a_bank_id		=?, "+
						"        a_bank_nm		=?, "+
						"        a_bank_no		=?, "+
						"        a_bank_cms_bk	=?, "+
						"        card_id		=?, "+
						"        card_nm		=?, "+
						"        card_no		=?, "+
						"        act_union_yn	=?  "+
						" where  reqseq			=?  ";

		String query2 =  " update pay_item		set "+
						"        p_st3			=?  "+
						" where  reqseq			=?  ";


	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	 bean.getP_way			());
			pstmt.setString	(2,	 bean.getBank_id		());
			pstmt.setString	(3,	 bean.getBank_nm		());
			pstmt.setString	(4,	 bean.getBank_no		().trim());
			pstmt.setString	(5,	 bean.getBank_cms_bk	());
			pstmt.setString	(6,	 bean.getBank_acc_nm	());
			pstmt.setString	(7,	 bean.getA_bank_id		());
			pstmt.setString	(8,	 bean.getA_bank_nm		());
			pstmt.setString	(9,	 bean.getA_bank_no		().trim());
			pstmt.setString	(10, bean.getA_bank_cms_bk	());
			pstmt.setString	(11, bean.getCard_id		());
			pstmt.setString	(12, bean.getCard_nm		());
			pstmt.setString (13, bean.getCard_no		());
			pstmt.setString (14, bean.getAct_union_yn	());
			pstmt.setString	(15, bean.getReqseq			());
			pstmt.executeUpdate();		

			//수정
			pstmt = con.prepareStatement(query2);
			pstmt.setString	(1,	 bean.getP_st3		());
			pstmt.setString	(2,  bean.getReqseq		());
			pstmt.executeUpdate();						

            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayAccCng]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	출금원장 수정
     */
    public boolean updatePayActBK(PayMngActBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update pay_act set						"+
						"        bank_id		=?,					"+
						"        bank_cms_bk	=?,					"+
						"        a_bank_id		=?,					"+
						"        a_bank_cms_bk	=?					"+
						" where  actseq			=?					"+
						" ";


	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	bean.getBank_id			());
			pstmt.setString	(2,	bean.getBank_cms_bk		());
			pstmt.setString	(3,	bean.getA_bank_id		());
			pstmt.setString	(4,	bean.getA_bank_cms_bk	());
			pstmt.setString	(5,	bean.getActseq			());
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayAct]"+se);
				System.out.println("[bean.getBank_id		()]"+bean.getBank_id		());
				System.out.println("[bean.getBank_cms_bk	()]"+bean.getBank_cms_bk	());
				System.out.println("[bean.getA_bank_id		()]"+bean.getA_bank_id		());
				System.out.println("[bean.getA_bank_cms_bk	()]"+bean.getA_bank_cms_bk	());
				System.out.println("[bean.getActseq			()]"+bean.getActseq			());

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	출금원장 수정
     */
    public boolean updatePayAntApp(String bank_code, String app_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update pay_act set						"+
						"        app_id			=?					"+
						" where  bank_code		=?					"+
						" ";

	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	app_id		);
			pstmt.setString	(2,	bank_code	);
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayAntApp]"+se);
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	출금원장 수정
     */
    public boolean updatePayAntR(PayMngActBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;

		String query =  " update pay_act set					"+
						"        r_act_dt		=replace(?,'-',''),	"+
						"        commi			=?,					"+
						"        rs_code		=?,					"+
						"        act_bit		=?					"+
						" where  actseq			=?					"+
						" ";

		String query2 = " update pay     set						"+
						"        p_pay_dt		=replace(?,'-',''),	"+
						"        p_step			='4'				"+
						" where  bank_code		=?					"+
						"        and off_nm		=?                  "+
						"        and bank_no	=?                  "+
						"        and a_bank_no	=?                  "+
						" ";


	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	bean.getR_act_dt	());
			pstmt.setInt	(2,	bean.getCommi		());
			pstmt.setString	(3,	bean.getRs_code		());
			pstmt.setString	(4,	bean.getAct_bit		());
			pstmt.setString	(5,	bean.getActseq		());
			pstmt.executeUpdate();						
            pstmt.close();

			pstmt2 = con.prepareStatement(query2);
			pstmt2.setString	(1,	bean.getR_act_dt	());
			pstmt2.setString	(2,	bean.getBank_code	());
			pstmt2.setString	(3,	bean.getOff_nm		());
			pstmt2.setString	(4,	bean.getBank_no		());
			pstmt2.setString	(5,	bean.getA_bank_no	());
			pstmt2.executeUpdate();						
            pstmt2.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayAntR]"+se);
				System.out.println("[bean.getR_act_dt	()]"+bean.getR_act_dt	());
				System.out.println("[bean.getCommi		()]"+bean.getCommi		());
				System.out.println("[bean.getRs_code	()]"+bean.getRs_code	());
				System.out.println("[bean.getAct_bit	()]"+bean.getAct_bit	());
				System.out.println("[bean.getActseq		()]"+bean.getActseq		());
				System.out.println("[bean.getBank_code	()]"+bean.getBank_code	());
				System.out.println("[bean.getOff_nm		()]"+bean.getOff_nm		());
				System.out.println("[bean.getBank_no	()]"+bean.getBank_no	());
				System.out.println("[bean.getA_bank_no	()]"+bean.getA_bank_no	());
                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                if(pstmt2 != null)	pstmt2.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	출금원장 수정
     */
    public boolean updatePayAntU(PayMngActBean o_bean, PayMngActBean n_bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;

		String query =  " update pay_act set					"+
						"        bank_no		=?,					"+
						"        bank_acc_nm	=?,					"+
						"        a_bank_no		=?					"+
						" where  actseq			=?					"+
						" ";

		String query2 = " update pay     set						"+
						"        bank_no		=?,					"+
						"        bank_acc_nm	=?,					"+
						"        a_bank_no		=?					"+
						" where  bank_code		=?					"+
						"        and off_nm		=?                  "+
						"        and bank_no	=?                  "+
						"        and a_bank_no	=?                  "+
						" ";


	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	n_bean.getBank_no		().trim());
			pstmt.setString	(2,	n_bean.getBank_acc_nm	());
			pstmt.setString	(3,	n_bean.getA_bank_no		().trim());
			pstmt.setString	(4,	o_bean.getActseq		());
			pstmt.executeUpdate();						
            pstmt.close();

			pstmt2 = con.prepareStatement(query2);
			pstmt2.setString	(1,	n_bean.getBank_no		().trim());
			pstmt2.setString	(2,	n_bean.getBank_acc_nm	());
			pstmt2.setString	(3,	n_bean.getA_bank_no		().trim());
			pstmt2.setString	(4,	o_bean.getBank_code		());
			pstmt2.setString	(5,	o_bean.getOff_nm		());
			pstmt2.setString	(6,	o_bean.getBank_no		());
			pstmt2.setString	(7,	o_bean.getA_bank_no		());
			pstmt2.executeUpdate();						
            pstmt2.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayAntU]"+se);
				System.out.println("[n_bean.getBank_no		()]"+n_bean.getBank_no		());
				System.out.println("[n_bean.getBank_acc_nm	()]"+n_bean.getBank_acc_nm	());
				System.out.println("[n_bean.getA_bank_no	()]"+n_bean.getA_bank_no	());
				System.out.println("[o_bean.getActseq		()]"+o_bean.getActseq		());
				System.out.println("[o_bean.getBank_code	()]"+o_bean.getBank_code	());
				System.out.println("[o_bean.getOff_nm		()]"+o_bean.getOff_nm		());
				System.out.println("[o_bean.getBank_no		()]"+o_bean.getBank_no		());
				System.out.println("[o_bean.getA_bank_no	()]"+o_bean.getA_bank_no	());

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	출금원장 수정
     */
    public boolean updatePayAntRU1(PayMngActBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update pay_act set						"+
						"        bank_no		=?,					"+
						"        bank_acc_nm	=?,					"+
						"        a_bank_no		=?,					"+
						"        act_dt			=replace(?,'-',''),	"+
						"        r_act_dt		=replace(?,'-',''),	"+
						"        commi			=?,					"+
						"        amt			=?,					"+
						"        bank_id		=?,					"+
						"        bank_cms_bk	=?,					"+
						"        bank_memo		=?,					"+
						"        cms_code		=?,					"+
						"        bank_nm		=?,					"+
						"        a_bank_nm		=?,					"+
						"        a_bank_id		=?,					"+
						"        a_bank_cms_bk	=?,					"+
						"        off_nm			=?					"+
						" where  actseq			=?					"+
						" ";

	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	 bean.getBank_no		().trim());
			pstmt.setString	(2,	 bean.getBank_acc_nm	());
			pstmt.setString	(3,	 bean.getA_bank_no		().trim());
			pstmt.setString	(4,	 bean.getAct_dt			());
			pstmt.setString	(5,	 bean.getAct_dt			());
			pstmt.setInt	(6,	 bean.getCommi			());
			pstmt.setLong	(7,	 bean.getAmt			());
			pstmt.setString	(8,	 bean.getBank_id		());
			pstmt.setString	(9,	 bean.getBank_cms_bk	());
			pstmt.setString	(10, bean.getBank_memo		());
			pstmt.setString	(11, bean.getCms_code		());
			pstmt.setString	(12, bean.getBank_nm		());
			pstmt.setString	(13, bean.getA_bank_nm		());
			pstmt.setString	(14, bean.getA_bank_id		());
			pstmt.setString	(15, bean.getA_bank_cms_bk	());
			pstmt.setString	(16, bean.getOff_nm			().trim());
			pstmt.setString	(17, bean.getActseq			());
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayAntRU1]"+se);
				System.out.println("[bean.getBank_no		()]"+bean.getBank_no		());
				System.out.println("[bean.getBank_acc_nm	()]"+bean.getBank_acc_nm	());
				System.out.println("[bean.getA_bank_no		()]"+bean.getA_bank_no		());
				System.out.println("[bean.getAct_dt			()]"+bean.getAct_dt			());
				System.out.println("[bean.getCommi			()]"+bean.getCommi			());
				System.out.println("[bean.getAmt			()]"+bean.getAmt			());
				System.out.println("[bean.getBank_id		()]"+bean.getBank_id		());
				System.out.println("[bean.getBank_cms_bk	()]"+bean.getBank_cms_bk	());
				System.out.println("[bean.getBank_memo		()]"+bean.getBank_memo		());
				System.out.println("[bean.getCms_code		()]"+bean.getCms_code		());
				System.out.println("[bean.getActseq			()]"+bean.getActseq			());

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	출금원장 수정
     */
    public boolean updatePayAntRU2(PayMngBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query  = " update pay     set						"+
						"        bank_no		=?,					"+
						"        bank_acc_nm	=?,					"+
						"        a_bank_no		=?,					"+
						"        p_pay_dt		=replace(?,'-',''),	"+
						"        commi			=?,					"+
						"        m_amt			=?,					"+
						"        bank_id		=?,					"+
						"        bank_cms_bk	=?,					"+
						"        amt			=?,					"+
						"        bank_nm		=?,					"+
						"        a_bank_nm		=?,					"+
						"        a_bank_id		=?,					"+
						"        a_bank_cms_bk	=? 					"+
						" where  reqseq			=?					"+
						" ";

	   try{

            con.setAutoCommit(false);

			pstmt = con.prepareStatement(query);
			pstmt.setString	(1,	bean.getBank_no			().trim());
			pstmt.setString	(2,	bean.getBank_acc_nm		());
			pstmt.setString	(3,	bean.getA_bank_no		().trim());
			pstmt.setString	(4,	bean.getP_pay_dt		());
			pstmt.setInt	(5,	bean.getCommi			());
			pstmt.setInt	(6,	bean.getM_amt			());
			pstmt.setString	(7,	bean.getBank_id			());
			pstmt.setString	(8,	bean.getBank_cms_bk		());
			pstmt.setLong	(9,	bean.getAmt				());
			pstmt.setString	(10,bean.getBank_nm			());
			pstmt.setString	(11,bean.getA_bank_nm		());
			pstmt.setString	(12,bean.getA_bank_id		());
			pstmt.setString	(13,bean.getA_bank_cms_bk	());
			pstmt.setString	(14,bean.getReqseq			());
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayAntRU2]"+se);
				System.out.println("[bean.getBank_no		()]"+bean.getBank_no		());
				System.out.println("[bean.getBank_acc_nm	()]"+bean.getBank_acc_nm	());
				System.out.println("[bean.getA_bank_no		()]"+bean.getA_bank_no		());
				System.out.println("[bean.getP_pay_dt		()]"+bean.getP_pay_dt		());
				System.out.println("[bean.getCommi			()]"+bean.getCommi			());
				System.out.println("[bean.getM_amt			()]"+bean.getM_amt			());
				System.out.println("[bean.getAmt			()]"+bean.getAmt			());
				System.out.println("[bean.getReqseq			()]"+bean.getReqseq			());

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	회계처리결정
     */
    public boolean updatePayPaycode(String reqseq, String pay_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update pay set "+
						"        pay_code	=replace(?,'-','') "+
						" where  reqseq=?";

	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);
			pstmt.setString(1,  pay_code);
			pstmt.setString(2,  reqseq);
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayPaycode]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	회계처리결정
     */
    public boolean updatePayAccountEtc(String reqseq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update pay set "+
						"        p_step	='5' "+
						" where  reqseq=?";

	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);
			pstmt.setString(1,  reqseq);
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayAccountEtc]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	회계처리결정
     */
    public boolean updatePayACancel(String reqseq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update pay set "+
						"        p_step	='0', doc_code='' "+
						" where  reqseq=?";

	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);
			pstmt.setString(1,  reqseq);
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayACancel]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	회계처리결정
     */
    public boolean updatePayDCancel(String reqseq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update pay set "+
						"        p_step	='0', doc_code='', p_req_dt='' "+
						" where  reqseq=?";

	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);
			pstmt.setString(1,  reqseq);
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayDCancel]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	회계처리결정
     */
    public boolean updatePayRCancel(String reqseq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update pay set "+
						"        p_step	='2', bank_code='', a_pay_dt='', p_pay_dt='' "+
						" where  reqseq=?";

	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);
			pstmt.setString(1,  reqseq);
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayRCancel]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	회계처리결정
     */
    public boolean updatePayAutodocuCancel(String reqseq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query =  " update pay set "+
						"        p_step	='4', pay_code='', autodocu_write_date='', autodocu_data_no='', autodocu_data_gubun='' "+
						" where  reqseq=? and p_step='5' and autodocu_write_date is not null ";

	   try{

            con.setAutoCommit(false);

			//수정
			pstmt = con.prepareStatement(query);
			pstmt.setString(1,  reqseq);
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:updatePayAutodocuCancel]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	등록삭제
     */
    public boolean deletePaySearchReg(String search_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;

		String query1 =  " delete from pay_item   where reqseq in (select reqseq from pay where search_code=?)";
		String query2 =  " delete from pay        where search_code=? ";
		String query3 =  " delete from pay_search where search_code=? ";
	   try{

            con.setAutoCommit(false);

			//삭제
			pstmt = con.prepareStatement(query1);
			pstmt.setString(1,  search_code);
			pstmt.executeUpdate();						
            pstmt.close();

			pstmt2 = con.prepareStatement(query2);
			pstmt2.setString(1,  search_code);
			pstmt2.executeUpdate();						
            pstmt2.close();

			pstmt3 = con.prepareStatement(query3);
			pstmt3.setString(1,  search_code);
			pstmt3.executeUpdate();						
            pstmt3.close();

			con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:deletePaySearchReg]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
				if(pstmt3 != null)	pstmt3.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	등록삭제
     */
    public boolean deletePayItemUser(String reqseq, int i_seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		String query =  " delete from pay_item_user where reqseq=? and i_seq=? ";


	   try{

            con.setAutoCommit(false);

			//삭제
			pstmt = con.prepareStatement(query);
			pstmt.setString(1,  reqseq);
			pstmt.setInt   (2,  i_seq);
			pstmt.executeUpdate();						
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:deletePayItemUser]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	등록삭제
     */
    public boolean deletePayItem(String reqseq, int i_seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;

		String query1 =  " delete from pay_item_user where reqseq=? and i_seq=? ";
		String query2 =  " delete from pay_item where reqseq=? and i_seq=? ";


	   try{

            con.setAutoCommit(false);

			//삭제
			pstmt = con.prepareStatement(query1);
			pstmt.setString(1,  reqseq);
			pstmt.setInt   (2,  i_seq);
			pstmt.executeUpdate();	
			pstmt.close();

			pstmt2 = con.prepareStatement(query2);
			pstmt2.setString(1,  reqseq);
			pstmt2.setInt   (2,  i_seq);
			pstmt2.executeUpdate();						
            pstmt2.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:deletePayItem]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	등록삭제
     */
    public boolean deletePay(String reqseq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query1 =  " delete from pay_item_user where reqseq=? ";
		String query2 =  " delete from pay_item      where reqseq=? ";
		String query3 =  " delete from pay           where reqseq=? ";
		String query4 =  " delete from pay_search    where search_code in (select search_code from pay where reqseq=?) ";

//		String query5 =  " delete from DZAIS.autodocu where docu_stat='0' and (DATA_GUBUN, WRITE_DATE, DATA_NO) in (select autodocu_data_gubun, autodocu_write_date, autodocu_data_no from pay where reqseq=?) ";


	   try{

            con.setAutoCommit(false);

			//삭제
			pstmt = con.prepareStatement(query1);
			pstmt.setString(1,  reqseq);
			pstmt.executeUpdate();						

			pstmt = con.prepareStatement(query2);
			pstmt.setString(1,  reqseq);
			pstmt.executeUpdate();						

			pstmt = con.prepareStatement(query3);
			pstmt.setString(1,  reqseq);
			pstmt.executeUpdate();						

			pstmt = con.prepareStatement(query4);
			pstmt.setString(1,  reqseq);
			pstmt.executeUpdate();						
/*
			pstmt = con.prepareStatement(query5);
			pstmt.setString(1,  reqseq);
			pstmt.executeUpdate();						
*/
            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:deletePay]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	등록삭제
     */
    public boolean deletePayAct(String actseq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;

		String query1 =  " delete from pay_act where actseq=? ";


	   try{

            con.setAutoCommit(false);

			//삭제
			pstmt = con.prepareStatement(query1);
			pstmt.setString(1,  actseq);
			pstmt.executeUpdate();											

            pstmt.close();

            con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:deletePayAct]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }

    /**
     *	송금요청 초기화
     */
    public boolean cancelPayAct() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar

        if(con == null)
            throw new DataSourceEmptyException("Can't get Connection !!");

		boolean flag = true;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;

		String query1 =  " delete from pay_act   where bank_code in ( select bank_code from pay where p_step='2' and reqseq BETWEEN to_char(sysdate-1,'YYYYMMDD')||'0000000' AND to_char(sysdate,'YYYYMMDD')||'9999999' )";
		String query2 =  " update pay set a_pay_dt='', bank_code='' where p_step='2' and reqseq BETWEEN to_char(sysdate-1,'YYYYMMDD')||'0000000' AND to_char(sysdate,'YYYYMMDD')||'9999999' ";
		
	    try{

            con.setAutoCommit(false);

			//삭제
			pstmt = con.prepareStatement(query1);
			pstmt.executeUpdate();						
            pstmt.close();
            //수정
			pstmt2 = con.prepareStatement(query2);
			pstmt2.executeUpdate();						
            pstmt2.close();

			con.commit();

		}catch(Exception se){
            try{
		  		flag = false;
				System.out.println("[PayMngDatabase:cancelPayAct]"+se);

                con.rollback();
            }catch(SQLException _ignored){}
              throw new DatabaseException("exception");
        }finally{
            try{
                if(pstmt != null)	pstmt.close();
				if(pstmt2 != null)	pstmt2.close();				
                con.setAutoCommit(true);
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return flag;
    }    

	/**********************************************/	
	/*                                            */
	/*        데  이  타        조    회          */
	/*                                            */
	/**********************************************/	
	

	/**
	 *	출금원장조회등록-처리2단계에서 코드별 묶음
	 */
    public Vector getPaySearchBundle(String search_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
				" off_st, off_id, ven_code, p_gubun, p_way, bank_no, a_bank_no, card_no, p_est_dt, count(0) cnt, sum(amt) amt, min(reqseq) reqseq \n"+
				" from pay_search \n"+
				" where search_code='"+search_code+"' \n"+
				" group by off_st, off_id, ven_code, p_gubun, p_way, bank_no, a_bank_no, card_no, p_est_dt \n"+
				" order by off_st, off_id, ven_code, p_gubun, p_way, bank_no, a_bank_no, card_no, p_est_dt"; 

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
			System.out.println("[PayMngDatabase:getPaySearchBundle]"+se);
			System.out.println("[PayMngDatabase:getPaySearchBundle]"+query);
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
	 *	출금원장조회등록-처리2단계에서 코드별 묶음
	 */
    public Vector getPaySearchBundleCaseByCase(String search_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
				" * \n"+
				" from pay_search \n"+
				" where search_code='"+search_code+"' \n"+
				" order by reqseq "; 

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
			System.out.println("[PayMngDatabase:getPaySearchBundleCaseByCase]"+se);
			System.out.println("[PayMngDatabase:getPaySearchBundleCaseByCase]"+query);
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
	 *	출금원장조회등록-처리2단계에서 코드별 묶음 세부
	 */
    public Vector getPaySearchBundleList(String search_code, String off_st, String off_id, String ven_code, String p_gubun, String p_way, String bank_no, String a_bank_no, String p_est_dt, String card_no) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
				" * \n"+
				" from  pay_search \n"+
				" where     search_code			='"+search_code+"'  \n"+
				"       and off_st				='"+off_st+"'		\n"+ 
				"       and off_id				='"+off_id+"'		\n"+ 
				"       and p_gubun				='"+p_gubun+"'		\n"+ 
				"       and p_way				='"+p_way+"'		\n"+ 
				"       and p_est_dt			='"+p_est_dt+"'		\n"+ 
				" "; 

		if(ven_code.equals(""))		query += " and ven_code is null";
		else						query += " and ven_code='"+ven_code+"'";

		if(bank_no.equals(""))		query += " and bank_no is null";
		else						query += " and bank_no='"+bank_no+"'";

		if(a_bank_no.equals(""))	query += " and a_bank_no is null";
		else						query += " and a_bank_no='"+a_bank_no+"'";

		if(card_no.equals(""))		query += " and card_no is null";
		else						query += " and card_no='"+card_no+"'";

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
			System.out.println("[PayMngDatabase:getPaySearchBundleList]"+se);
			System.out.println("[PayMngDatabase:getPaySearchBundleList]"+query);
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
	 *	출금원장조회등록-처리2단계에서 코드별 묶음 세부
	 */
    public Vector getPaySearchBundleCaseByCaseList(String reqseq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
				" * \n"+
				" from  pay_search \n"+
				" where     reqseq			='"+reqseq+"'  \n"+
				" "; 

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
			System.out.println("[PayMngDatabase:getPaySearchBundleCaseByCaseList]"+se);
			System.out.println("[PayMngDatabase:getPaySearchBundleCaseByCaseList]"+query);
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
	 *	출금등록현황
     */
    public PayMngBean getPaySearch(String reqseq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PayMngBean bean = new PayMngBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";

		query = " select a.* from pay_search a where a.reqseq=?"+
				" "; 

	    try{
            pstmt = con.prepareStatement(query);
			pstmt.setString(1, reqseq);
		   	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				bean.setReqseq				(rs.getString("reqseq")			==null?"":rs.getString("reqseq"));
				bean.setP_est_dt			(rs.getString("p_est_dt")		==null?"":rs.getString("p_est_dt"));
	 			bean.setP_gubun				(rs.getString("p_gubun")		==null?"":rs.getString("p_gubun"));	
	 			bean.setP_way				(rs.getString("p_way")			==null?"":rs.getString("p_way"));	
				bean.setP_cd1				(rs.getString("p_cd1")			==null?"":rs.getString("p_cd1"));
				bean.setP_cd2				(rs.getString("p_cd2")			==null?"":rs.getString("p_cd2"));
				bean.setP_cd3				(rs.getString("p_cd3")			==null?"":rs.getString("p_cd3"));
				bean.setP_cd4				(rs.getString("p_cd4")			==null?"":rs.getString("p_cd4"));
				bean.setP_cd5				(rs.getString("p_cd5")			==null?"":rs.getString("p_cd5"));	
				bean.setP_cd6				(rs.getString("p_cd6")			==null?"":rs.getString("p_cd6"));	
				bean.setP_st1				(rs.getString("p_st1")			==null?"":rs.getString("p_st1"));
				bean.setP_st2				(rs.getString("p_st2")			==null?"":rs.getString("p_st2"));
				bean.setP_st3				(rs.getString("p_st3")			==null?"":rs.getString("p_st3"));
				bean.setP_st4				(rs.getString("p_st4")			==null?"":rs.getString("p_st4"));
	 			bean.setP_st5				(rs.getString("p_st5")			==null?"":rs.getString("p_st5"));	
	 			bean.setP_cont				(rs.getString("p_cont")			==null?"":rs.getString("p_cont"));	
				bean.setOff_st				(rs.getString("off_st")			==null?"":rs.getString("off_st"));
				bean.setOff_id				(rs.getString("off_id")			==null?"":rs.getString("off_id"));
				bean.setOff_nm				(rs.getString("off_nm")			==null?"":rs.getString("off_nm"));
				bean.setVen_code			(rs.getString("ven_code")		==null?"":rs.getString("ven_code"));
				bean.setVen_name			(rs.getString("ven_name")		==null?"":rs.getString("ven_name"));	
				bean.setAmt					(rs.getLong  ("amt"));
				bean.setBank_nm				(rs.getString("bank_nm")		==null?"":rs.getString("bank_nm"));
				bean.setBank_no				(rs.getString("bank_no")		==null?"":rs.getString("bank_no"));
				bean.setReg_dt				(rs.getString("reg_dt")			==null?"":rs.getString("reg_dt"));
	 			bean.setReg_id				(rs.getString("reg_id")			==null?"":rs.getString("reg_id"));	
	 			bean.setReg_st				(rs.getString("reg_st")			==null?"":rs.getString("reg_st"));	
	 			bean.setP_pay_dt			(rs.getString("p_pay_dt")		==null?"":rs.getString("p_pay_dt"));	
				bean.setDoc_code			(rs.getString("doc_code")		==null?"":rs.getString("doc_code"));
				bean.setP_step				(rs.getString("p_step")			==null?"":rs.getString("p_step"));
	 			bean.setP_gubun_etc			(rs.getString("p_gubun_etc")	==null?"":rs.getString("p_gubun_etc"));	
				bean.setAcct_code			(rs.getString("acct_code")		==null?"":rs.getString("acct_code"));
				bean.setBank_id				(rs.getString("bank_id")		==null?"":rs.getString("bank_id"));
	 			bean.setP_req_dt			(rs.getString("p_req_dt")		==null?"":rs.getString("p_req_dt"));	
	 			bean.setR_est_dt			(rs.getString("r_est_dt")		==null?"":rs.getString("r_est_dt"));	
				bean.setA_bank_id			(rs.getString("a_bank_id")		==null?"":rs.getString("a_bank_id"));
				bean.setA_bank_nm			(rs.getString("a_bank_nm")		==null?"":rs.getString("a_bank_nm"));
				bean.setA_bank_no			(rs.getString("a_bank_no")		==null?"":rs.getString("a_bank_no"));
				bean.setA_pay_dt			(rs.getString("a_pay_dt")		==null?"":rs.getString("a_pay_dt"));
				bean.setAutodocu_write_date	(rs.getString("autodocu_write_date")	==null?"":rs.getString("autodocu_write_date"));
				bean.setAutodocu_data_no	(rs.getString("autodocu_data_no")		==null?"":rs.getString("autodocu_data_no"));
				bean.setCard_id				(rs.getString("card_id")		==null?"":rs.getString("card_id"));
				bean.setCard_nm				(rs.getString("card_nm")		==null?"":rs.getString("card_nm"));
				bean.setCard_no				(rs.getString("card_no")		==null?"":rs.getString("card_no"));
				bean.setSub_amt1			(rs.getLong  ("sub_amt1"));
				bean.setSub_amt2			(rs.getLong  ("sub_amt2"));
				bean.setSub_amt3			(rs.getLong  ("sub_amt3"));
				bean.setSub_amt4			(rs.getLong  ("sub_amt4"));
				bean.setSub_amt5			(rs.getLong  ("sub_amt5"));
				bean.setSub_amt6			(rs.getLong  ("sub_amt6"));
				bean.setPay_code			(rs.getString("pay_code")		==null?"":rs.getString("pay_code"));
				bean.setBank_code			(rs.getString("bank_code")		==null?"":rs.getString("bank_code"));
				bean.setBuy_user_id			(rs.getString("buy_user_id")	==null?"":rs.getString("buy_user_id"));
				bean.setVen_st				(rs.getString("ven_st")			==null?"":rs.getString("ven_st"));
				bean.setTax_yn				(rs.getString("tax_yn")			==null?"":rs.getString("tax_yn"));
	 			bean.setSavepath			(rs.getString("savepath")		==null?"":rs.getString("savepath"));	
	 			bean.setFilename1			(rs.getString("filename1")		==null?"":rs.getString("filename1"));	
	 			bean.setFilename2			(rs.getString("filename2")		==null?"":rs.getString("filename2"));	
				bean.setFilename3			(rs.getString("filename3")		==null?"":rs.getString("filename3"));
				bean.setFilename4			(rs.getString("filename4")		==null?"":rs.getString("filename4"));
	 			bean.setFilename5			(rs.getString("filename5")		==null?"":rs.getString("filename5"));	
				bean.setAcct_code_g			(rs.getString("acct_code_g")	==null?"":rs.getString("acct_code_g"));
				bean.setAcct_code_g2		(rs.getString("acct_code_g2")	==null?"":rs.getString("acct_code_g2"));
	 			bean.setO_cau				(rs.getString("o_cau")			==null?"":rs.getString("o_cau"));	
	 			bean.setCall_t_nm			(rs.getString("call_t_nm")		==null?"":rs.getString("call_t_nm"));	
				bean.setCall_t_tel			(rs.getString("call_t_tel")		==null?"":rs.getString("call_t_tel"));
				bean.setCall_t_chk			(rs.getString("call_t_chk")		==null?"":rs.getString("call_t_chk"));
				bean.setUser_su				(rs.getString("user_su")		==null?"":rs.getString("user_su"));
				bean.setUser_cont			(rs.getString("user_cont")		==null?"":rs.getString("user_cont"));
				bean.setAcct_code2			(rs.getString("acct_code2")		==null?"":rs.getString("acct_code2"));
				bean.setAcct_code3			(rs.getString("acct_code3")		==null?"":rs.getString("acct_code3"));
				bean.setAcct_code4			(rs.getString("acct_code4")		==null?"":rs.getString("acct_code4"));
				bean.setAcct_code5			(rs.getString("acct_code5")		==null?"":rs.getString("acct_code5"));
				bean.setS_idno				(rs.getString("s_idno")			==null?"":rs.getString("s_idno"));
				bean.setAutodocu_data_gubun (rs.getString("autodocu_data_gubun")==null?"":rs.getString("autodocu_data_gubun"));
				bean.setR_acct_code			(rs.getString("r_acct_code")	==null?"":rs.getString("r_acct_code"));
				bean.setM_amt				(rs.getInt   ("m_amt"));
				bean.setM_cau				(rs.getString("m_cau")			==null?"":rs.getString("m_cau"));
				bean.setSearch_code			(rs.getString("search_code")	==null?"":rs.getString("search_code"));
				bean.setAcct_code_st		(rs.getString("acct_code_st")	==null?"":rs.getString("acct_code_st"));
				bean.setBank_acc_nm			(rs.getString("bank_acc_nm")	==null?"":rs.getString("bank_acc_nm"));
				bean.setBank_cms_bk			(rs.getString("bank_cms_bk")	==null?"":rs.getString("bank_cms_bk"));
				bean.setA_bank_cms_bk		(rs.getString("a_bank_cms_bk")	==null?"":rs.getString("a_bank_cms_bk"));
				bean.setOff_tel				(rs.getString("off_tel")		==null?"":rs.getString("off_tel"));
				bean.setAct_union_yn		(rs.getString("act_union_yn")	==null?"":rs.getString("act_union_yn"));
				bean.setCash_acc_no			(rs.getString("cash_acc_no")	==null?"":rs.getString("cash_acc_no"));
				bean.setI_s_amt				(rs.getLong  ("i_s_amt"));
				bean.setI_v_amt				(rs.getLong  ("i_v_amt"));

			}
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[PayMngDatabase:getPaySearch]"+se);
			System.out.println("[PayMngDatabase:getPaySearch]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }


	/**
	 *	출금원장 조회
     */
    public PayMngBean getPay(String reqseq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PayMngBean bean = new PayMngBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";

		query = " select a.* from pay a where a.reqseq=?"+
				" "; 

	    try{
            pstmt = con.prepareStatement(query);
			pstmt.setString(1, reqseq);
		   	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				bean.setReqseq				(rs.getString("reqseq")			==null?"":rs.getString("reqseq"));
				bean.setReg_dt				(rs.getString("reg_dt")			==null?"":rs.getString("reg_dt"));
	 			bean.setReg_id				(rs.getString("reg_id")			==null?"":rs.getString("reg_id"));	
	 			bean.setReg_st				(rs.getString("reg_st")			==null?"":rs.getString("reg_st"));	
	 			bean.setP_way				(rs.getString("p_way")			==null?"":rs.getString("p_way"));	
				bean.setOff_st				(rs.getString("off_st")			==null?"":rs.getString("off_st"));
				bean.setOff_id				(rs.getString("off_id")			==null?"":rs.getString("off_id"));
				bean.setOff_nm				(rs.getString("off_nm")			==null?"":rs.getString("off_nm"));
				bean.setVen_code			(rs.getString("ven_code")		==null?"":rs.getString("ven_code"));
				bean.setVen_name			(rs.getString("ven_name")		==null?"":rs.getString("ven_name"));	
				bean.setVen_st				(rs.getString("ven_st")			==null?"":rs.getString("ven_st"));
				bean.setS_idno				(rs.getString("s_idno")			==null?"":rs.getString("s_idno"));
				bean.setAmt					(rs.getLong  ("amt"));
				bean.setM_amt				(rs.getInt   ("m_amt"));
				bean.setM_cau				(rs.getString("m_cau")			==null?"":rs.getString("m_cau"));
				bean.setBank_id				(rs.getString("bank_id")		==null?"":rs.getString("bank_id"));
				bean.setBank_nm				(rs.getString("bank_nm")		==null?"":rs.getString("bank_nm"));
				bean.setBank_no				(rs.getString("bank_no")		==null?"":rs.getString("bank_no"));
				bean.setA_bank_id			(rs.getString("a_bank_id")		==null?"":rs.getString("a_bank_id"));
				bean.setA_bank_nm			(rs.getString("a_bank_nm")		==null?"":rs.getString("a_bank_nm"));
				bean.setA_bank_no			(rs.getString("a_bank_no")		==null?"":rs.getString("a_bank_no"));
				bean.setCard_id				(rs.getString("card_id")		==null?"":rs.getString("card_id"));
				bean.setCard_nm				(rs.getString("card_nm")		==null?"":rs.getString("card_nm"));
				bean.setCard_no				(rs.getString("card_no")		==null?"":rs.getString("card_no"));
				bean.setP_est_dt			(rs.getString("p_est_dt")		==null?"":rs.getString("p_est_dt"));
	 			bean.setP_req_dt			(rs.getString("p_req_dt")		==null?"":rs.getString("p_req_dt"));	
	 			bean.setP_pay_dt			(rs.getString("p_pay_dt")		==null?"":rs.getString("p_pay_dt"));
				bean.setA_pay_dt			(rs.getString("a_pay_dt")		==null?"":rs.getString("a_pay_dt"));
				bean.setDoc_code			(rs.getString("doc_code")		==null?"":rs.getString("doc_code"));
				bean.setPay_code			(rs.getString("pay_code")		==null?"":rs.getString("pay_code"));
				bean.setBank_code			(rs.getString("bank_code")		==null?"":rs.getString("bank_code"));
				bean.setTax_yn				(rs.getString("tax_yn")			==null?"":rs.getString("tax_yn"));
				bean.setR_acct_code			(rs.getString("r_acct_code")	==null?"":rs.getString("r_acct_code"));			
				bean.setAutodocu_data_gubun (rs.getString("autodocu_data_gubun")==null?"":rs.getString("autodocu_data_gubun"));
				bean.setAutodocu_write_date	(rs.getString("autodocu_write_date")	==null?"":rs.getString("autodocu_write_date"));
				bean.setAutodocu_data_no	(rs.getString("autodocu_data_no")		==null?"":rs.getString("autodocu_data_no"));
	 			bean.setSavepath			(rs.getString("savepath")		==null?"":rs.getString("savepath"));	
	 			bean.setFilename1			(rs.getString("filename1")		==null?"":rs.getString("filename1"));	
	 			bean.setFilename2			(rs.getString("filename2")		==null?"":rs.getString("filename2"));	
				bean.setFilename3			(rs.getString("filename3")		==null?"":rs.getString("filename3"));
				bean.setFilename4			(rs.getString("filename4")		==null?"":rs.getString("filename4"));
	 			bean.setFilename5			(rs.getString("filename5")		==null?"":rs.getString("filename5"));	
				bean.setSearch_code			(rs.getString("search_code")	==null?"":rs.getString("search_code"));
				bean.setP_step				(rs.getString("p_step")			==null?"":rs.getString("p_step"));
				bean.setAcct_code_st		(rs.getString("acct_code_st")	==null?"":rs.getString("acct_code_st"));
				bean.setCash_acc_no			(rs.getString("cash_acc_no")	==null?"":rs.getString("cash_acc_no"));
				bean.setBank_acc_nm			(rs.getString("bank_acc_nm")	==null?"":rs.getString("bank_acc_nm"));
				bean.setCommi				(rs.getInt   ("commi"));
				bean.setP_est_dt2			(rs.getString("p_est_dt2")		==null?"":rs.getString("p_est_dt2"));
				bean.setAt_once				(rs.getString("at_once")		==null?"":rs.getString("at_once"));
				bean.setAct_union_yn		(rs.getString("act_union_yn")	==null?"":rs.getString("act_union_yn"));
			}
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[PayMngDatabase:getPay]"+se);
			System.out.println("[PayMngDatabase:getPay]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

	/**
	 *	출금세부항목 조회
     */
    public PayMngBean getPayItem(String reqseq, int i_seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PayMngBean bean = new PayMngBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";

		query = " select a.* from pay_item a where a.reqseq=? and a.i_seq=?"+
				" "; 

	    try{
            pstmt = con.prepareStatement(query);
			pstmt.setString(1, reqseq);
			pstmt.setInt   (2, i_seq);
		   	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				bean.setReqseq				(rs.getString("reqseq")			==null?"":rs.getString("reqseq"));
				bean.setI_seq				(rs.getInt   ("i_seq"));
	 			bean.setP_gubun				(rs.getString("p_gubun")		==null?"":rs.getString("p_gubun"));	
				bean.setP_cd1				(rs.getString("p_cd1")			==null?"":rs.getString("p_cd1"));
				bean.setP_cd2				(rs.getString("p_cd2")			==null?"":rs.getString("p_cd2"));
				bean.setP_cd3				(rs.getString("p_cd3")			==null?"":rs.getString("p_cd3"));
				bean.setP_cd4				(rs.getString("p_cd4")			==null?"":rs.getString("p_cd4"));
				bean.setP_cd5				(rs.getString("p_cd5")			==null?"":rs.getString("p_cd5"));	
				bean.setP_cd6				(rs.getString("p_cd6")			==null?"":rs.getString("p_cd6"));	
				bean.setP_st1				(rs.getString("p_st1")			==null?"":rs.getString("p_st1"));
				bean.setP_st2				(rs.getString("p_st2")			==null?"":rs.getString("p_st2"));
				bean.setP_st3				(rs.getString("p_st3")			==null?"":rs.getString("p_st3"));
				bean.setP_st4				(rs.getString("p_st4")			==null?"":rs.getString("p_st4"));
	 			bean.setP_st5				(rs.getString("p_st5")			==null?"":rs.getString("p_st5"));	
	 			bean.setR_est_dt			(rs.getString("r_est_dt")		==null?"":rs.getString("r_est_dt"));	
				bean.setBuy_user_id			(rs.getString("buy_user_id")	==null?"":rs.getString("buy_user_id"));
				bean.setI_amt				(rs.getLong  ("i_amt"));
				bean.setI_s_amt				(rs.getLong  ("i_s_amt"));
				bean.setI_v_amt				(rs.getLong  ("i_v_amt"));
				bean.setSub_amt1			(rs.getLong  ("sub_amt1"));
				bean.setSub_amt2			(rs.getLong  ("sub_amt2"));
				bean.setSub_amt3			(rs.getLong  ("sub_amt3"));
				bean.setSub_amt4			(rs.getLong  ("sub_amt4"));
				bean.setSub_amt5			(rs.getLong  ("sub_amt5"));
				bean.setSub_amt6			(rs.getLong  ("sub_amt6"));
				bean.setAcct_code			(rs.getString("acct_code")		==null?"":rs.getString("acct_code"));
				bean.setAcct_code_g			(rs.getString("acct_code_g")	==null?"":rs.getString("acct_code_g"));
				bean.setAcct_code_g2		(rs.getString("acct_code_g2")	==null?"":rs.getString("acct_code_g2"));
	 			bean.setP_cont				(rs.getString("p_cont")			==null?"":rs.getString("p_cont"));	
	 			bean.setO_cau				(rs.getString("o_cau")			==null?"":rs.getString("o_cau"));	
	 			bean.setCall_t_nm			(rs.getString("call_t_nm")		==null?"":rs.getString("call_t_nm"));	
				bean.setCall_t_tel			(rs.getString("call_t_tel")		==null?"":rs.getString("call_t_tel"));
				bean.setCall_t_chk			(rs.getString("call_t_chk")		==null?"":rs.getString("call_t_chk"));
				bean.setUser_su				(rs.getString("user_su")		==null?"":rs.getString("user_su"));
				bean.setUser_cont			(rs.getString("user_cont")		==null?"":rs.getString("user_cont"));
				bean.setAccid_reg_yn		(rs.getString("accid_reg_yn")	==null?"":rs.getString("accid_reg_yn"));
				bean.setServ_reg_yn			(rs.getString("serv_reg_yn")	==null?"":rs.getString("serv_reg_yn"));
				bean.setMaint_reg_yn		(rs.getString("maint_reg_yn")	==null?"":rs.getString("maint_reg_yn"));
				bean.setCost_gubun			(rs.getString("cost_gubun")		==null?"":rs.getString("cost_gubun"));
				bean.setM_doc_code			(rs.getString("m_doc_code")		==null?"":rs.getString("m_doc_code"));
			
			}
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[PayMngDatabase:getPayItem]"+se);
			System.out.println("[PayMngDatabase:getPayItem]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

	/**
	 *	출금세부항목 조회
     */
    public PayMngBean getPayItemExcel(String s_reqseq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PayMngBean bean = new PayMngBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";

		query = " select a.* from pay_item a where a.p_st4='엑셀등록' and a.p_cd1=?"+
				" "; 

	    try{
            pstmt = con.prepareStatement(query);
			pstmt.setString(1, s_reqseq);
		   	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				bean.setReqseq				(rs.getString("reqseq")			==null?"":rs.getString("reqseq"));
				bean.setI_seq				(rs.getInt   ("i_seq"));
	 			bean.setP_gubun				(rs.getString("p_gubun")		==null?"":rs.getString("p_gubun"));	
				bean.setP_cd1				(rs.getString("p_cd1")			==null?"":rs.getString("p_cd1"));
				bean.setP_cd2				(rs.getString("p_cd2")			==null?"":rs.getString("p_cd2"));
				bean.setP_cd3				(rs.getString("p_cd3")			==null?"":rs.getString("p_cd3"));
				bean.setP_cd4				(rs.getString("p_cd4")			==null?"":rs.getString("p_cd4"));
				bean.setP_cd5				(rs.getString("p_cd5")			==null?"":rs.getString("p_cd5"));	
				bean.setP_cd6				(rs.getString("p_cd6")			==null?"":rs.getString("p_cd6"));	
				bean.setP_st1				(rs.getString("p_st1")			==null?"":rs.getString("p_st1"));
				bean.setP_st2				(rs.getString("p_st2")			==null?"":rs.getString("p_st2"));
				bean.setP_st3				(rs.getString("p_st3")			==null?"":rs.getString("p_st3"));
				bean.setP_st4				(rs.getString("p_st4")			==null?"":rs.getString("p_st4"));
	 			bean.setP_st5				(rs.getString("p_st5")			==null?"":rs.getString("p_st5"));	
	 			bean.setR_est_dt			(rs.getString("r_est_dt")		==null?"":rs.getString("r_est_dt"));	
				bean.setBuy_user_id			(rs.getString("buy_user_id")	==null?"":rs.getString("buy_user_id"));
				bean.setI_amt				(rs.getLong  ("i_amt"));
				bean.setI_s_amt				(rs.getLong  ("i_s_amt"));
				bean.setI_v_amt				(rs.getLong  ("i_v_amt"));
				bean.setSub_amt1			(rs.getLong  ("sub_amt1"));
				bean.setSub_amt2			(rs.getLong  ("sub_amt2"));
				bean.setSub_amt3			(rs.getLong  ("sub_amt3"));
				bean.setSub_amt4			(rs.getLong  ("sub_amt4"));
				bean.setSub_amt5			(rs.getLong  ("sub_amt5"));
				bean.setSub_amt6			(rs.getLong  ("sub_amt6"));
				bean.setAcct_code			(rs.getString("acct_code")		==null?"":rs.getString("acct_code"));
				bean.setAcct_code_g			(rs.getString("acct_code_g")	==null?"":rs.getString("acct_code_g"));
				bean.setAcct_code_g2		(rs.getString("acct_code_g2")	==null?"":rs.getString("acct_code_g2"));
	 			bean.setP_cont				(rs.getString("p_cont")			==null?"":rs.getString("p_cont"));	
	 			bean.setO_cau				(rs.getString("o_cau")			==null?"":rs.getString("o_cau"));	
	 			bean.setCall_t_nm			(rs.getString("call_t_nm")		==null?"":rs.getString("call_t_nm"));	
				bean.setCall_t_tel			(rs.getString("call_t_tel")		==null?"":rs.getString("call_t_tel"));
				bean.setCall_t_chk			(rs.getString("call_t_chk")		==null?"":rs.getString("call_t_chk"));
				bean.setUser_su				(rs.getString("user_su")		==null?"":rs.getString("user_su"));
				bean.setUser_cont			(rs.getString("user_cont")		==null?"":rs.getString("user_cont"));
				bean.setAccid_reg_yn		(rs.getString("accid_reg_yn")	==null?"":rs.getString("accid_reg_yn"));
				bean.setServ_reg_yn			(rs.getString("serv_reg_yn")	==null?"":rs.getString("serv_reg_yn"));
				bean.setMaint_reg_yn		(rs.getString("maint_reg_yn")	==null?"":rs.getString("maint_reg_yn"));
				bean.setCost_gubun			(rs.getString("cost_gubun")		==null?"":rs.getString("cost_gubun"));
			}
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[PayMngDatabase:getPayItem]"+se);
			System.out.println("[PayMngDatabase:getPayItem]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

	/**
	 *	송금등록현황
     */
    public PayMngActBean getPayAct(String actseq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PayMngActBean bean = new PayMngActBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";

		query = " select a.* from pay_act a where a.actseq=?"+
				" "; 

	    try{
            pstmt = con.prepareStatement(query);
			pstmt.setString(1, actseq);
		   	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				bean.setActseq				(rs.getString("actseq")		==null?"":rs.getString("actseq"));
				bean.setReg_dt				(rs.getString("reg_dt")		==null?"":rs.getString("reg_dt"));
	 			bean.setReg_id				(rs.getString("reg_id")		==null?"":rs.getString("reg_id"));	
	 			bean.setAct_st				(rs.getString("act_st")		==null?"":rs.getString("act_st"));	
				bean.setAct_dt				(rs.getString("act_dt")		==null?"":rs.getString("act_dt"));
				bean.setAmt					(rs.getLong  ("amt"));
				bean.setCommi				(rs.getInt   ("commi"));
				bean.setOff_nm				(rs.getString("off_nm")		==null?"":rs.getString("off_nm"));
				bean.setBank_id				(rs.getString("bank_id")	==null?"":rs.getString("bank_id"));
				bean.setBank_nm				(rs.getString("bank_nm")	==null?"":rs.getString("bank_nm"));
				bean.setBank_no				(rs.getString("bank_no")	==null?"":rs.getString("bank_no"));
				bean.setA_bank_id			(rs.getString("a_bank_id")	==null?"":rs.getString("a_bank_id"));
				bean.setA_bank_nm			(rs.getString("a_bank_nm")	==null?"":rs.getString("a_bank_nm"));
				bean.setA_bank_no			(rs.getString("a_bank_no")	==null?"":rs.getString("a_bank_no"));
				bean.setBank_code			(rs.getString("bank_code")	==null?"":rs.getString("bank_code"));
				bean.setAct_bit				(rs.getString("act_bit")	==null?"":rs.getString("act_bit"));
				bean.setR_act_dt			(rs.getString("r_act_dt")	==null?"":rs.getString("r_act_dt"));
				bean.setBank_acc_nm			(rs.getString("bank_acc_nm")==null?"":rs.getString("bank_acc_nm"));
				bean.setBank_memo			(rs.getString("bank_memo")	==null?"":rs.getString("bank_memo"));
				bean.setCms_code			(rs.getString("cms_code")	==null?"":rs.getString("cms_code"));
			}
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[PayMngDatabase:getPayAct]"+se);
			System.out.println("[PayMngDatabase:getPayAct]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }

	/**
	 *	송금등록현황
     */
    public PayMngActBean getPayAct(String bank_code, String p_pay_dt, String off_nm, String bank_no, String a_bank_no) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PayMngActBean bean = new PayMngActBean();
        PreparedStatement pstmt = null;
        ResultSet rs = null;        
        String query = "";

		query = " select a.* from pay_act a where a.bank_code=? and a.act_dt=? and a.off_nm=? and a.bank_no=? and a.a_bank_no=?"+
				" "; 

	    try{
            pstmt = con.prepareStatement(query);
			pstmt.setString(1, bank_code);
			pstmt.setString(2, p_pay_dt);
			pstmt.setString(3, off_nm);
			pstmt.setString(4, bank_no);
			pstmt.setString(5, a_bank_no);
		   	rs = pstmt.executeQuery();
    	
			if(rs.next())
			{				
				bean.setActseq				(rs.getString("actseq")		==null?"":rs.getString("actseq"));
				bean.setReg_dt				(rs.getString("reg_dt")		==null?"":rs.getString("reg_dt"));
	 			bean.setReg_id				(rs.getString("reg_id")		==null?"":rs.getString("reg_id"));	
	 			bean.setAct_st				(rs.getString("act_st")		==null?"":rs.getString("act_st"));	
				bean.setAct_dt				(rs.getString("act_dt")		==null?"":rs.getString("act_dt"));
				bean.setAmt					(rs.getLong  ("amt"));
				bean.setCommi				(rs.getInt   ("commi"));
				bean.setOff_nm				(rs.getString("off_nm")		==null?"":rs.getString("off_nm"));
				bean.setBank_id				(rs.getString("bank_id")	==null?"":rs.getString("bank_id"));
				bean.setBank_nm				(rs.getString("bank_nm")	==null?"":rs.getString("bank_nm"));
				bean.setBank_no				(rs.getString("bank_no")	==null?"":rs.getString("bank_no"));
				bean.setA_bank_id			(rs.getString("a_bank_id")	==null?"":rs.getString("a_bank_id"));
				bean.setA_bank_nm			(rs.getString("a_bank_nm")	==null?"":rs.getString("a_bank_nm"));
				bean.setA_bank_no			(rs.getString("a_bank_no")	==null?"":rs.getString("a_bank_no"));
				bean.setBank_code			(rs.getString("bank_code")	==null?"":rs.getString("bank_code"));
				bean.setAct_bit				(rs.getString("act_bit")	==null?"":rs.getString("act_bit"));
				bean.setR_act_dt			(rs.getString("r_act_dt")	==null?"":rs.getString("r_act_dt"));
				bean.setBank_acc_nm			(rs.getString("bank_acc_nm")==null?"":rs.getString("bank_acc_nm"));
				bean.setBank_memo			(rs.getString("bank_memo")	==null?"":rs.getString("bank_memo"));
				bean.setCms_code			(rs.getString("cms_code")	==null?"":rs.getString("cms_code"));

			}
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[PayMngDatabase:getPayAct]"+se);
			System.out.println("[PayMngDatabase:getPayAct]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return bean;
    }


	/**
	 *	출금원장조회등록-처리2단계에서 코드별 묶음
	 */
    public Vector getPayItemList(String reqseq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.*, b.user_nm as buy_user_nm from pay_item a, users b where a.reqseq=? and a.buy_user_id=b.user_id(+) order by a.i_seq "+
				" "; 


	    try{
            pstmt = con.prepareStatement(query);
			pstmt.setString(1, reqseq);
            rs = pstmt.executeQuery();
    		ResultSetMetaData rsmd = rs.getMetaData();    	

			while(rs.next())
			{	
				PayMngBean bean = new PayMngBean();
				bean.setReqseq				(rs.getString("reqseq")			==null?"":rs.getString("reqseq"));
				bean.setI_seq				(rs.getInt   ("i_seq"));
	 			bean.setP_gubun				(rs.getString("p_gubun")		==null?"":rs.getString("p_gubun"));	
				bean.setP_cd1				(rs.getString("p_cd1")			==null?"":rs.getString("p_cd1"));
				bean.setP_cd2				(rs.getString("p_cd2")			==null?"":rs.getString("p_cd2"));
				bean.setP_cd3				(rs.getString("p_cd3")			==null?"":rs.getString("p_cd3"));
				bean.setP_cd4				(rs.getString("p_cd4")			==null?"":rs.getString("p_cd4"));
				bean.setP_cd5				(rs.getString("p_cd5")			==null?"":rs.getString("p_cd5"));	
				bean.setP_cd6				(rs.getString("p_cd6")			==null?"":rs.getString("p_cd6"));	
				bean.setP_st1				(rs.getString("p_st1")			==null?"":rs.getString("p_st1"));
				bean.setP_st2				(rs.getString("p_st2")			==null?"":rs.getString("p_st2"));
				bean.setP_st3				(rs.getString("p_st3")			==null?"":rs.getString("p_st3"));
				bean.setP_st4				(rs.getString("p_st4")			==null?"":rs.getString("p_st4"));
	 			bean.setP_st5				(rs.getString("p_st5")			==null?"":rs.getString("p_st5"));	
	 			bean.setR_est_dt			(rs.getString("r_est_dt")		==null?"":rs.getString("r_est_dt"));	
				bean.setBuy_user_id			(rs.getString("buy_user_id")	==null?"":rs.getString("buy_user_id"));
				bean.setI_amt				(rs.getLong  ("i_amt"));
				bean.setI_s_amt				(rs.getLong  ("i_s_amt"));
				bean.setI_v_amt				(rs.getLong  ("i_v_amt"));
				bean.setSub_amt1			(rs.getLong  ("sub_amt1"));
				bean.setSub_amt2			(rs.getLong  ("sub_amt2"));
				bean.setSub_amt3			(rs.getLong  ("sub_amt3"));
				bean.setSub_amt4			(rs.getLong  ("sub_amt4"));
				bean.setSub_amt5			(rs.getLong  ("sub_amt5"));
				bean.setSub_amt6			(rs.getLong  ("sub_amt6"));
				bean.setAcct_code			(rs.getString("acct_code")		==null?"":rs.getString("acct_code"));
				bean.setAcct_code_g			(rs.getString("acct_code_g")	==null?"":rs.getString("acct_code_g"));
				bean.setAcct_code_g2		(rs.getString("acct_code_g2")	==null?"":rs.getString("acct_code_g2"));
	 			bean.setP_cont				(rs.getString("p_cont")			==null?"":rs.getString("p_cont"));	
	 			bean.setO_cau				(rs.getString("o_cau")			==null?"":rs.getString("o_cau"));	
	 			bean.setCall_t_nm			(rs.getString("call_t_nm")		==null?"":rs.getString("call_t_nm"));	
				bean.setCall_t_tel			(rs.getString("call_t_tel")		==null?"":rs.getString("call_t_tel"));
				bean.setCall_t_chk			(rs.getString("call_t_chk")		==null?"":rs.getString("call_t_chk"));
				bean.setUser_su				(rs.getString("user_su")		==null?"":rs.getString("user_su"));
				bean.setUser_cont			(rs.getString("user_cont")		==null?"":rs.getString("user_cont"));
				bean.setAccid_reg_yn		(rs.getString("accid_reg_yn")	==null?"":rs.getString("accid_reg_yn"));
				bean.setServ_reg_yn			(rs.getString("serv_reg_yn")	==null?"":rs.getString("serv_reg_yn"));
				bean.setMaint_reg_yn		(rs.getString("maint_reg_yn")	==null?"":rs.getString("maint_reg_yn"));
				bean.setBuy_user_nm			(rs.getString("buy_user_nm")	==null?"":rs.getString("buy_user_nm"));
				bean.setCost_gubun			(rs.getString("cost_gubun")		==null?"":rs.getString("cost_gubun"));

				vt.add(bean);	
			}
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[PayMngDatabase:getPayItemList]"+se);
			System.out.println("[PayMngDatabase:getPayItemList]"+query);
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
	 *	출금원장 참가자리스트
	 */
    public Vector getPayItemUserList(String reqseq, int i_seq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				" b.*, nvl(c.user_nm,b.pay_user) user_nm, c.dept_id"+
				" from pay_item_user b, users c"+
				" where b.reqseq='"+reqseq+"' and i_seq="+i_seq+" "+
				" and b.pay_user=c.user_id(+) order by b.u_seq";

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
			System.out.println("[PayMngDatabase:getPayItemUserList]"+se);
			System.out.println("[PayMngDatabase:getPayItemUserList]"+query);
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
	 *	출금등록관리
	 */
    public Vector getPayBList(String s_kd, String t_wd, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
				"        a.*, "+
				"        c.p_gubun, c.acct_code, c.p_cont, "+
				"        d.i_seq, nvl(d.i_amt,0) i_amt, nvl(d.i_cnt,0) i_cnt, \n"+
				"        decode(a.amt,d.i_amt,'완결',0,'미완','미완') reg_end, "+
				"        decode(a.reg_st,'D','직접','A','자동','조회') reg_st_nm, \n"+
//				"        decode(a.r_acct_code,'=',c.acct_code,a.r_acct_code) r_acct_code_nm, \n"+
//				"        decode(a.r_acct_code,'1','모른다','2','기발행','3','등록시발행','4','처리안한다') r_acct_code_nm, \n"+
				"        decode(a.acct_code_st,'1','모른다','2','기발행','3','등록시발행','4','처리안한다') acct_code_st_nm, \n"+
				"        decode(a.p_way,'1','현금지출','2','선불카드','3','후불카드','4','자동이체','5','계좌이체','7','카드할부') way_nm, \n"+
				"        decode(c.p_gubun,'01','자동차대금','06','중고차대금','07','사전계약계약금','08','계약금카드결제','02','영업수당','03','자동차보험료','04','할부금','05','할부금중도상환', \n"+
				"	                      '11','정비비','14','정비비(정산)','15','피해사고공임부가세','16','피해사고부품부가세', '18','피해사고렌트부가세', '19','피해사고유리부가세', \n"+
				"	                      '12','탁송료','13','용품비', '17','검사비', \n"+
				"                         '21','과태료','22','개별소비세','23','자동차세','24','환경개선부담금', '25','취득세', \n"+
				"                         '31','해지정산금환불','32','CMS과출금','33','계약승계보증금','34','대차승계보증금', '35','계약승계보증금환불', '36','연장계약보증금환불', '37','월렌트정산금환불', \n"+
				"	                      '41','법인카드대금','42','법인카드대금(지방세)','43','법인카드대금(지방세)','44','법인카드대금(자동차대금)', '45','법인카드대금(지방세23일)', '46','법인카드대금(선불기타)', '47','법인카드대금(지방세말일결재)', '48','법인카드대금(지방세익월8일결재)', \n"+
				"	                      '51','캠페인포상금','52','제안포상금','53','귀향여비','54','인터넷당직비', '55','당직비', \n"+
				"	                      '60','자금집금','61','이체수수료','99',c.p_st2) gubun_nm, \n"+//||decode(nvl(d.i_cnt,0),'0','','1','','외')
//				"        decode(a.filename1,'',0,1)+decode(a.filename2,'',0,1)+decode(a.filename3,'',0,1)+decode(a.filename4,'',0,1)+decode(a.filename5,'',0,1) file_cnt,"+
				"        b.user_nm as reg_nm, \n"+
				"        c.p_cd1, c.p_cd2, c.p_cd3, c.p_cd4, c.p_cd5, c.p_cd6, c.p_st1, c.p_st4, h3.file_cnt"+
				" from \n"+
				"        pay a, users b, "+
				"        (select * from pay_item where i_seq='1') c, "+
				"        (select reqseq, min(i_seq) i_seq, sum(i_amt) i_amt, count(0) i_cnt from pay_item group by reqseq) d, \n"+
				"        (select content_seq as reqseq, count(0) file_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='PAY' group by content_seq) h3 "+
				" where \n"+
				"       a.p_step='0' \n"+
				"       and a.reg_id=b.user_id \n"+
				"       and a.reqseq=c.reqseq(+) and a.reqseq=d.reqseq(+)"+
				"       and to_char(a.reg_dt,'YYYYMMDD') >= '20091130'"+
				"       and a.reqseq=h3.reqseq(+) "+
				" "; 

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		
		dt1 = "substr(a.p_est_dt,1,6)";
		dt2 = "a.p_est_dt";

		if(gubun4.equals("2")){
			dt1 = "to_char(a.reg_dt,'YYYYMM')";
			dt2 = "to_char(a.reg_dt,'YYYYMMDD')";
		}

		if(gubun1.equals("2"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' \n";
		else if(gubun1.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";
		else if(gubun1.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		if(!gubun2.equals(""))	query += " and a.p_way = '"+gubun2+"'"; 

		if(!gubun3.equals(""))	query += " and ( c.p_gubun = '"+gubun3+"' or c.acct_code = '"+gubun3+"' )"; 

		if(s_kd.equals("1"))	what = "upper(nvl(a.off_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(c.p_cont, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.bank_nm, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(a.bank_no, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(a.a_bank_nm, ' '))";	
		if(s_kd.equals("6"))	what = "upper(nvl(a.a_bank_no, ' '))";	
		if(s_kd.equals("7"))	what = "upper(nvl(a.card_nm, ' '))";	
		if(s_kd.equals("8"))	what = "upper(nvl(a.card_no, ' '))";	
		if(s_kd.equals("9"))	what = "upper(nvl(b.user_nm, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') \n";
		}	

		query += " order by a.reg_st, a.p_est_dt, c.p_gubun, a.p_way, a.a_bank_no, a.reg_dt";

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
			System.out.println("[PayMngDatabase:getPayBList]"+se);
			System.out.println("[PayMngDatabase:getPayBList]"+query);
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
	 *	출금문서관리
	 */
    public Vector getPayDList(String s_kd, String t_wd, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
		        "        a.*, "+
				"        c.br_id as br_id2, b.doc_no, substr(b.doc_no,9) doc_no2, "+
				"        b.user_id1, b.user_dt1, b.user_id2, b.user_dt2, b.user_id3, b.user_dt3, "+
				"        c.user_nm as user_nm1, d.user_nm as user_nm2, e.user_nm as user_nm3, f.user_nm as reg_nm, \n"+
				"        decode(a.p_gubun,'01','자동차대금','06','중고차대금','07','사전계약계약금','08','계약금카드결제','02','영업수당','03','자동차보험료','04','할부금','05','할부금중도상환', \n"+
				"	                      '11','정비비','14','정비비(정산)','15','피해사고공임부가세','16','피해사고부품부가세', '18','피해사고렌트부가세', '19','피해사고유리부가세', \n"+
				"	                      '12','탁송료','13','용품비', '17','검사비', \n"+
				"                         '21','과태료','22','개별소비세','23','자동차세','24','환경개선부담금', '25','취득세', \n"+
				"                         '31','해지정산금환불','32','CMS과출금','33','계약승계보증금','34','대차승계보증금', '35','계약승계보증금환불', '36','연장계약보증금환불', '37','월렌트정산금환불', \n"+
				"	                      '41','법인카드대금','42','법인카드대금(지방세)','43','법인카드대금(지방세)','44','법인카드대금(자동차대금)', '45','법인카드대금(지방세23일)', '46','법인카드대금(선불기타)', '47','법인카드대금(지방세말일결재)', '48','법인카드대금(지방세익월8일결재)', \n"+
				"	                      '51','캠페인포상금','52','제안포상금','53','귀향여비','54','인터넷당직비', '55','당직비', \n"+
				"	                      '60','자금집금','61','이체수수료','99',a.p_st2||decode(a.tot_cnt,1,'','외')) gubun_nm"+
				" from \n"+
				"        (select \n"+
				"                nvl(a.at_once,'N') at_once, a.doc_code, a.p_req_dt, a.p_est_dt, a.p_est_dt2, c.p_gubun, nvl(c.acct_code,'00000') acct_code, a.reg_id, d.br_id, "+
				"                count(0) tot_cnt, sum(a.amt) tot_amt, \n"+
				"                sum(decode(a.p_way,'1',a.amt)) amt1, \n"+
				"                sum(decode(a.p_way,'2',a.amt)) amt2, \n"+
				"                sum(decode(a.p_way,'3',a.amt)) amt3, \n"+
				"                sum(decode(a.p_way,'4',a.amt)) amt4, \n"+
				"                sum(decode(a.p_way,'5',a.amt)) amt5, \n"+
				"                sum(decode(a.p_way,'7',a.amt)) amt7, \n"+
				"                min(a.p_est_dt) min_dt, max(a.p_est_dt) max_dt, max(c.p_st2) p_st2 \n"+
				"         from   pay a, (select * from pay_item where i_seq='1') c, users d \n"+
				"         where  to_number(a.p_step) > 0 \n"+//a.p_req_dt is not null 
				"                and a.reqseq=c.reqseq \n"+
				"                and a.reg_id=d.user_id \n"+
				"                and to_char(a.reg_dt,'YYYYMMDD') >= '20091130'"+
				"                and (a.amt >0 or a.amt <0)"+
				"         group by nvl(a.at_once,'N'), a.doc_code, a.p_req_dt, a.p_est_dt, a.p_est_dt2, c.p_gubun, c.acct_code, a.reg_id, d.br_id \n"+
				"        ) a, \n"+
				"        (select * from doc_settle where doc_st='31') b, users c, users d, users e, users f, BRANCH g \n"+
				" where a.p_gubun not in ('60','61')  "+
				"       and a.doc_code=b.doc_id(+) and b.user_id1=c.user_id(+) and b.user_id2=d.user_id(+) and b.user_id3=e.user_id(+) and a.reg_id=f.user_id \n"+
				"       and a.br_id=g.br_id(+)"+
				" "; 

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		
		dt1 = "substr(a.p_req_dt,1,6)";
		dt2 = "a.p_req_dt";

		if(gubun1.equals("2"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%' \n";
		else if(gubun1.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD') \n";
		else if(gubun1.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','') \n";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n";
		}

		if(gubun2.equals("1"))	query += " and nvl(b.doc_step,'0')<>'3'"; 
		if(gubun2.equals("2"))	query += " and nvl(b.doc_step,'0')='3'"; 

		if(!gubun3.equals(""))	query += " and ( a.p_gubun = '"+gubun3+"' or a.acct_code = '"+gubun3+"' )"; 


		if(s_kd.equals("1"))	what = "upper(nvl(f.user_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(c.user_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(g.br_nm, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(substr(b.doc_no,9), ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.doc_code, a.reg_id, a.p_req_dt, a.p_gubun";

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
			System.out.println("[PayMngDatabase:getPayDList]"+se);
			System.out.println("[PayMngDatabase:getPayDList]"+query);
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
	 *	출금송금관리
	 */
    public Vector getPayAList(String s_kd, String t_wd, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
				"        a.*, substr(b2.doc_no,9) doc_no2, i.p_gubun, i.p_cont||decode(i2.item_cnt,1,'',' 외'||i2.item_cnt||'건') p_cont, nvl(i2.item_cnt,0) i_cnt, \n"+
				"        decode(a.reg_st,'D','직접','A','자동','조회') reg_st_nm, \n"+
				"        decode(a.p_way,'1','현금지출','2','선불카드','3','후불카드','4','자동이체','5','계좌이체','7','카드할부') way_nm, \n"+
				"        decode(i.p_gubun,'01','자동차대금','06','중고차대금','07','사전계약계약금','08','계약금카드결제','02','영업수당','03','자동차보험료','04','할부금','05','할부금중도상환', \n"+
				"	                      '11','정비비','14','정비비(정산)','15','피해사고공임부가세','16','피해사고부품부가세', '18','피해사고렌트부가세', '19','피해사고유리부가세', \n"+
				"	                      '12','탁송료','13','용품비', '17','검사비', \n"+
				"                         '21','과태료','22','개별소비세','23','자동차세','24','환경개선부담금', '25','취득세', \n"+
				"                         '31','해지정산금환불','32','CMS과출금','33','계약승계보증금','34','대차승계보증금', '35','계약승계보증금환불', '36','연장계약보증금환불', '37','월렌트정산금환불', \n"+
				"	                      '41','법인카드대금','42','법인카드대금(지방세)','43','법인카드대금(지방세)','44','법인카드대금(자동차대금)', '45','법인카드대금(지방세23일)', '46','법인카드대금(선불기타)', '47','법인카드대금(지방세말일결재)', '48','법인카드대금(지방세익월8일결재)', \n"+
				"	                      '51','캠페인포상금','52','제안포상금','53','귀향여비','54','인터넷당직비', '55','당직비', \n"+
				"	                      '60','자금집금','61','이체수수료','99',i.p_st2||decode(i2.item_cnt,1,'',' 외')) gubun_nm, \n"+
//				"        decode(a.filename1,'',0,1)+decode(a.filename2,'',0,1)+decode(a.filename3,'',0,1)+decode(a.filename4,'',0,1)+decode(a.filename5,'',0,1) file_cnt,"+
				"        c.user_nm as reg_nm, \n"+
				"        d.user_nm as user_nm1, \n"+
				"        decode(b2.doc_step,'3',decode(b2.user_dt2,'','사후결재',e.user_nm)) as user_nm2, "+
				"        b2.user_dt1, b2.user_dt2, b2.doc_no,  \n"+
				"        d1.user_nm as d_user_nm1, "+
				"        decode(d1.br_id,'S1','',decode(b.user_id2,'XXXXXX','부재중결재',d2.user_nm)) as d_user_nm2, "+
				"        decode(b.doc_step,'3',decode(b.user_dt3,'','사후결재',d3.user_nm)) as d_user_nm3, "+
				"        i.p_cd1, i.p_cd2, i.p_cd3, i.p_cd4, i.p_cd5, i.p_cd6, i.p_st1, i.p_st4, h3.file_cnt "+
				" from \n"+
				"        pay a, "+
				"        (select * from pay_item where i_seq=1) i, "+
				"        (select reqseq, max(i_seq) max_seq, count(0) item_cnt from pay_item group by reqseq) i2, \n"+
				"        (select * from doc_settle where doc_st='31' ) b, users c, users d1, users d2, users d3, \n"+
				"        (select * from doc_settle where doc_st='32' ) b2, users d, users e, BRANCH f, "+
				"        (select content_seq as reqseq, count(0) file_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='PAY' group by content_seq) h3 "+
				" where \n"+
				"       a.reqseq=i.reqseq and a.reqseq=i2.reqseq \n"+
				"       and a.doc_code=b.doc_id(+) and decode(i.p_gubun,'60','3',b.doc_step)='3'\n"+//
				"       and a.reg_id=c.user_id \n"+
				"       and a.bank_code=b2.doc_id(+) "+
				"       and b.user_id1=d1.user_id(+) \n"+
				"       and b.user_id2=d2.user_id(+) \n"+
				"       and b.user_id3=d3.user_id(+) \n"+
				"       and b2.user_id1=d.user_id(+) \n"+
				"       and b2.user_id2=e.user_id(+) \n"+
				"       and to_char(a.reg_dt,'YYYYMMDD') >= '20091130'"+
				"       and c.br_id=f.br_id(+) \n"+
				"       and a.reqseq=h3.reqseq(+) "+
				" "; 

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		
		if(gubun5.equals("1"))	query += " and nvl(b2.doc_step,'0')<>'3'"; //a.p_step in ('2') and 
		if(gubun5.equals("2"))	query += " and nvl(b2.doc_step,'0')='3'"; 

		dt1 = "substr(a.p_est_dt,1,6)";
		dt2 = "a.p_est_dt";

		if(gubun4.equals("2")){
			dt1 = "substr(nvl(a.p_est_dt2,a.p_req_dt),1,6)";
			dt2 = "nvl(a.p_est_dt2,a.p_req_dt)";
		}

		if(gubun1.equals("2"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun2.equals(""))	query += " and a.p_way = '"+gubun2+"'"; 

		if(!gubun3.equals(""))	query += " and ( i.p_gubun = '"+gubun3+"' or i.acct_code = '"+gubun3+"' )"; 


		if(s_kd.equals("1"))	what = "upper(nvl(a.off_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.bank_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.bank_no, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(i.p_cont, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(c.user_nm, ' '))";	
		if(s_kd.equals("6"))	what = "upper(nvl(d1.user_nm, ' '))";	
		if(s_kd.equals("7"))	what = "upper(nvl(d.user_nm, ' '))";	
		if(s_kd.equals("8"))	what = "upper(nvl(f.br_nm, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.bank_code, decode(a.p_way,'1','2','5','1','4','3','2','4',a.p_way), i.p_gubun, a.p_req_dt, a.bank_no, a.reg_dt";


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
			System.out.println("[PayMngDatabase:getPayAList]"+se);
			System.out.println("[PayMngDatabase:getPayAList]"+query);
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
	 *	출금송금관리
	 */
    public Vector getPayRList(String s_kd, String t_wd, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = ""; 
		String sub_query = "";
		
		if(!gubun5.equals("")) {
			sub_query = " where reqseq LIKE TO_CHAR(SYSDATE,'YYYYMM')||'%' and reqseq in (select reqseq from pay_item where i_seq='1' and (p_gubun = '"+gubun5+"' or nvl(acct_code,'00000') = '"+gubun5+"' ) )";
		}

		query = " select \n"+
				"        a.*, \n"+
				"        decode(a.act_st,'1','즉시','예약') act_st_nm, \n"+
				"        decode(nvl(a.act_bit,'0'),'0','대기','1','성공') act_bit_nm, \n"+
				"        b.user_nm as reg_nm, \n"+
				"        c.tran_dt, c.tran_fee, c.tran_remain, c.tran_tm, c.err_code, c.err_reason, "+
				"        decode(c.err_code,'','','000','등록','001','상신','002','승인','003','처리전','004','처리중','005','정상','011','승인취소','012','반려_승인','006','확인','016','반려_확인','오류') err_code_nm, "+
				"        decode(d.tran_status,'','','00','처리전','01','처리중','02',decode(d.tran_result_cd,'00000000','정상처리',d.tran_result_cd),'03','처리오류','10','상신','11','확인','12','승인','21','확인자반려','22','승인자반려','20','반려','30','취소','31','상신취소','32','승인취소') tran_status_nm, "+
				"        d.tran_dt as i_tran_dt, d.tran_fee as i_tran_fee, d.tr_time, d.tran_status, d.tran_result_cd, "+
				"        f.user_nm as pay_reg_nm, \n"+
				"        decode(nvl(g.conf_st,''),'1','확인','2','상시','-') conf_st_nm, \n"+
				"        d2.RESULT_NM, decode(d2.MATCH_YN,'Y','일치','N','불일치','X','처리전','E','오류','') MATCH_YN \n"+
				" from \n"+
				"        pay_act a, users b, \n"+
				"        (select * from ebank.erp_trans where (actseq,tran_cnt) in (select actseq, max(tran_cnt) tran_cnt from ebank.erp_trans group by actseq)) c, "+
				"        (select * from ebank.IB_BULK_TRAN where (upche_key,tran_dt_seq) in (select upche_key, max(tran_dt_seq) tran_dt_seq from ebank.IB_BULK_TRAN group by upche_key)) d, "+
				"        ebank.IB_REMITTEE_NM d2, "+				
				"        (select bank_code, off_nm, bank_no, a_bank_no, min(reg_id) reg_id from PAY "+sub_query+" group by bank_code, off_nm, bank_no, a_bank_no) e, users f, "+
				"        (select * from bank_acc where off_st='tran' and seq='1') g "+
				" where \n"+
				"        a.reg_id=b.user_id(+) \n"+
				"       and a.act_dt=c.tran_dt(+) and a.actseq=c.actseq(+) \n"+
				"       and a.act_dt=d.tran_dt(+) and a.actseq=d.upche_key(+) \n"+
				"       and to_char(a.reg_dt,'YYYYMMDD') >= '20091130' \n"+
				"       and a.bank_code=e.bank_code(+) and a.off_nm=e.off_nm(+) and a.bank_no=e.bank_no(+) and a.a_bank_no=e.a_bank_no(+) \n"+
				"       and e.reg_id=f.user_id(+) \n"+
				"       and a.bank_no=g.off_id(+) "+
				"       and a.actseq=d2.UDK01(+) \n"+				
				" "; 
		
		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		
		if(gubun2.equals("1"))			query += " and nvl(a.act_bit,'0')='0' and a.app_id is not null";
		if(gubun2.equals("2"))			query += " and nvl(a.act_bit,'0')='1'";

		if(gubun3.equals("Y"))			query += " and a.a_bank_no = '140-004-023871'";
		if(gubun3.equals("N"))			query += " and a.a_bank_no <>'140-004-023871'";

		dt1 = "substr(a.act_dt,1,6)";
		dt2 = "a.act_dt";

		if(gubun4.equals("2")){
			dt1 = "substr(a.r_act_dt,1,6)";
			dt2 = "a.r_act_dt";
		}


		if(gubun1.equals("2"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";//전일
		else if(gubun1.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(s_kd.equals("1"))	what = "upper(nvl(a.off_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.bank_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.bank_no, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(a.a_bank_nm, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(a.a_bank_no, ' '))";	
		if(s_kd.equals("6"))	what = "upper(nvl(b.user_nm, ' '))";	
		if(s_kd.equals("7"))	what = "upper(nvl(f.user_nm, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		if(!gubun5.equals("")) {
			query += " and e.bank_code is not null ";
			
			//System.out.println("[PayMngDatabase:getPayRList]"+query);
		}

		
		query += " order by c.err_code, d.tran_status, a.act_dt, f.user_id, a.actseq";

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
			System.out.println("[PayMngDatabase:getPayRList]"+se);
			System.out.println("[PayMngDatabase:getPayRList]"+query);
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
	 *	출금송금관리
	 */
    public Vector getPayABankCodeDList(String bank_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query1 = "";
		String sub_query2 = "";
		String query = "";

		query = " select \n"+
				"        a.*, \n"+
				"        i.p_gubun, i.acct_code, i.p_cont, "+
				"        i.p_cd1, i.p_cd2, i.p_cd3, i.p_cd4, i.p_cd5, i.p_cd6, i.p_st1, i.p_st4, \n"+
				"        i2.i_seq, nvl(i2.i_amt,0) i_amt, nvl(i2.i_cnt,0) i_cnt, \n"+
				"        decode(a.reg_st,'D','직접','A','자동','조회') reg_st_nm, \n"+
				"        decode(a.p_way,'1','현금지출','2','선불카드','3','후불카드','4','자동이체','5','계좌이체','7','카드할부') way_nm, \n"+
				"        decode(i.p_gubun,'01','자동차대금','06','중고차대금','07','사전계약계약금','08','계약금카드결제','02','영업수당','03','자동차보험료','04','할부금','05','할부금중도상환', \n"+
				"	                      '11','정비비','14','정비비(정산)','15','피해사고공임부가세','16','피해사고부품부가세', '18','피해사고렌트부가세', '19','피해사고유리부가세', \n"+
				"	                      '12','탁송료','13','용품비', '17','검사비', \n"+
				"                         '21','과태료','22','개별소비세','23','자동차세','24','환경개선부담금', '25','취득세', \n"+
				"                         '31','해지정산금환불','32','CMS과출금','33','계약승계보증금','34','대차승계보증금', '35','계약승계보증금환불', '36','연장계약보증금환불', '37','월렌트정산금환불', \n"+
				"	                      '41','법인카드대금','42','법인카드대금(지방세)','43','법인카드대금(지방세)','44','법인카드대금(자동차대금)', '45','법인카드대금(지방세23일)', '46','법인카드대금(선불기타)', '47','법인카드대금(지방세말일결재)', '48','법인카드대금(지방세익월8일결재)', \n"+
				"	                      '51','캠페인포상금','52','제안포상금','53','귀향여비','54','인터넷당직비', '55','당직비', \n"+
				"	                      '60','자금집금','61','이체수수료','99',i.p_st2||decode(nvl(i2.i_cnt,0),'0','','1','','외')) gubun_nm, \n"+
//				"        decode(a.filename1,'',0,1)+decode(a.filename2,'',0,1)+decode(a.filename3,'',0,1)+decode(a.filename4,'',0,1)+decode(a.filename5,'',0,1) file_cnt,"+
				"        c.user_nm as reg_nm, \n"+
				"        d.user_nm as user_nm1, \n"+
				"        decode(e.user_nm,d.user_nm,'',e.user_nm) as user_nm2, h3.file_cnt  \n"+
				" from \n"+
				"        pay a, (select * from doc_settle where doc_st='31' and doc_step='3') b, users c, users d, users e, \n"+
				"        (select * from pay_item where i_seq='1') i, "+
				"        (select reqseq, min(i_seq) i_seq, sum(i_amt) i_amt, count(0) i_cnt from pay_item group by reqseq) i2, \n"+
				"        (select content_seq as reqseq, count(0) file_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='PAY' group by content_seq) h3 "+
				" where \n"+
				"       a.bank_code='"+bank_code+"' and i.p_gubun<>'60' \n"+
				"       and a.doc_code=b.doc_id \n"+
				"       and a.reg_id=c.user_id \n"+
				"       and b.user_id1=d.user_id \n"+
				"       and b.user_id2=e.user_id(+) \n"+
				"       and a.reqseq=i.reqseq \n"+
				"       and a.reqseq=i2.reqseq \n"+
				"       and a.reqseq=h3.reqseq(+) "+
				" order by a.p_way, a.off_nm"+
				" "; 


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
			System.out.println("[PayMngDatabase:getPayABankCodeDList]"+se);
			System.out.println("[PayMngDatabase:getPayABankCodeDList]"+query);
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
	 *	출금송금관리
	 */
    public Vector getPayActDocBankCodeList(String bank_code, String doc_no) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query1 = "";
		String sub_query2 = "";
		String query = "";

		query = " select \n"+
				"        a.*, \n"+
				"        i.p_gubun, i.acct_code, i.p_cont, "+
				"        i.p_cd1, i.p_cd2, i.p_cd3, i.p_cd4, i.p_cd5, i.p_cd6, i.p_st1, i.p_st4, \n"+
				"        i2.i_seq, nvl(i2.i_amt,0) i_amt, nvl(i2.i_cnt,0) i_cnt, \n"+
				"        decode(a.reg_st,'D','직접','A','자동','조회') reg_st_nm, \n"+
				"        decode(a.p_way,'1','현금지출','2','선불카드','3','후불카드','4','자동이체','5','계좌이체','7','카드할부') way_nm, \n"+
				"        decode(i.p_gubun,'01','자동차대금','06','중고차대금','07','사전계약계약금','08','계약금카드결제','02','영업수당','03','자동차보험료','04','할부금','05','할부금중도상환', \n"+
				"	                      '11','정비비','14','정비비(정산)','15','피해사고공임부가세','16','피해사고부품부가세', '18','피해사고렌트부가세', '19','피해사고유리부가세', \n"+
				"	                      '12','탁송료','13','용품비', '17','검사비', \n"+
				"                         '21','과태료','22','개별소비세','23','자동차세','24','환경개선부담금', '25','취득세', \n"+
				"                         '31','해지정산금환불','32','CMS과출금','33','계약승계보증금','34','대차승계보증금', '35','계약승계보증금환불', '36','연장계약보증금환불', '37','월렌트정산금환불', \n"+
				"	                      '41','법인카드대금','42','법인카드대금(지방세)','43','법인카드대금(지방세)','44','법인카드대금(자동차대금)', '45','법인카드대금(지방세23일)', '46','법인카드대금(선불기타)', '47','법인카드대금(지방세말일결재)', '48','법인카드대금(지방세익월8일결재)', \n"+
				"	                      '51','캠페인포상금','52','제안포상금','53','귀향여비','54','인터넷당직비', '55','당직비', \n"+
				"	                      '60','자금집금','61','이체수수료','99',i.p_st2||decode(nvl(i2.i_cnt,0),'0','','1','','외')) gubun_nm, \n"+
//				"        decode(a.filename1,'',0,1)+decode(a.filename2,'',0,1)+decode(a.filename3,'',0,1)+decode(a.filename4,'',0,1)+decode(a.filename5,'',0,1) file_cnt,"+
				"        c.user_nm as reg_nm, \n"+
				"        d.user_nm as user_nm1, \n"+
				"        decode(e.user_nm,d.user_nm,'',e.user_nm) as user_nm2, b2.user_dt1, b2.user_dt2, h3.file_cnt  \n"+
				" from \n"+
				"        pay a, (select * from doc_settle where doc_st='31' and doc_step='3') b, users c, users d, users e, \n"+
				"        (select * from pay_item where i_seq='1') i, "+
				"        (select reqseq, min(i_seq) i_seq, sum(i_amt) i_amt, count(0) i_cnt from pay_item group by reqseq) i2, \n"+
				"        (select * from doc_settle where doc_st='32') b2, "+
				"        (select content_seq as reqseq, count(0) file_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='PAY' group by content_seq) h3 "+
				" where \n"+
				"       a.bank_code='"+bank_code+"' and b2.doc_no='"+doc_no+"' \n"+ 
				"       and a.doc_code=b.doc_id(+) \n"+
				"       and a.bank_code=b2.doc_id \n"+
				"       and a.reg_id=c.user_id \n"+
				"       and b2.user_id1=d.user_id \n"+
				"       and b2.user_id2=e.user_id \n"+
				"       and a.reqseq=i.reqseq \n"+
				"       and a.reqseq=i2.reqseq \n"+
				"       and a.reqseq=h3.reqseq(+) "+
				" order by a.p_way, a.off_nm"+
				" "; 


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
			System.out.println("[PayMngDatabase:getPayActDocBankCodeList]"+se);
			System.out.println("[PayMngDatabase:getPayActDocBankCodeList]"+query);
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
	 *	출금송금관리
	 */
    public Vector getPayActDocBankCodeList2(String bank_code, String doc_no, String st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query1 = "";
		String sub_query2 = "";
		String query = "";

		query = " select \n"+
				"        a.*, \n"+
				"        i.p_gubun, i.acct_code, i.p_cont, "+
				"        i2.i_seq, nvl(i2.i_amt,0) i_amt, nvl(i2.i_cnt,0) i_cnt, \n"+
				"        decode(a.reg_st,'D','직접','A','자동','조회') reg_st_nm, \n"+
				"        decode(a.p_way,'1','현금지출','2','선불카드','3','후불카드','4','자동이체','5','계좌이체','7','카드할부') way_nm, \n"+
				"        decode(i.p_gubun,'01','자동차대금','06','중고차대금','07','사전계약계약금','08','계약금카드결제','02','영업수당','03','자동차보험료','04','할부금','05','할부금중도상환', \n"+
				"	                      '11','정비비','14','정비비(정산)','15','피해사고공임부가세','16','피해사고부품부가세', '18','피해사고렌트부가세', '19','피해사고유리부가세', \n"+
				"	                      '12','탁송료','13','용품비', '17','검사비', \n"+
				"                         '21','과태료','22','개별소비세','23','자동차세','24','환경개선부담금', '25','취득세', \n"+
				"                         '31','해지정산금환불','32','CMS과출금','33','계약승계보증금','34','대차승계보증금', '35','계약승계보증금환불', '36','연장계약보증금환불', '37','월렌트정산금환불', \n"+
				"	                      '41','법인카드대금','42','법인카드대금(지방세)','43','법인카드대금(지방세)','44','법인카드대금(자동차대금)', '45','법인카드대금(지방세23일)', '46','법인카드대금(선불기타)', '47','법인카드대금(지방세말일결재)', '48','법인카드대금(지방세익월8일결재)', \n"+
				"	                      '51','캠페인포상금','52','제안포상금','53','귀향여비','54','인터넷당직비', '55','당직비', \n"+
				"	                      '60','자금집금','61','이체수수료','99',i.p_st2||decode(nvl(i2.i_cnt,0),'0','','1','','외')) gubun_nm, \n"+
//				"        decode(a.filename1,'',0,1)+decode(a.filename2,'',0,1)+decode(a.filename3,'',0,1)+decode(a.filename4,'',0,1)+decode(a.filename5,'',0,1) file_cnt,"+
				"        c.user_nm as reg_nm, \n"+
				"        d.user_nm as user_nm1, \n"+
				"        decode(e.user_nm,d.user_nm,'',e.user_nm) as user_nm2, b2.user_dt1, b2.user_dt2, h3.file_cnt  \n"+
				" from \n"+
				"        pay a, (select * from doc_settle where doc_st='31' and doc_step='3') b, users c, users d, users e, \n"+
				"        (select * from pay_item where i_seq='1') i, "+
				"        (select reqseq, min(i_seq) i_seq, sum(i_amt) i_amt, count(0) i_cnt from pay_item group by reqseq) i2, \n"+
				"        (select * from doc_settle where doc_st='32') b2, "+
				"        (select content_seq as reqseq, count(0) file_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='PAY' group by content_seq) h3 "+
				" where \n"+
				"       a.bank_code='"+bank_code+"' and b2.doc_no='"+doc_no+"' \n"+ 
				"       and a.doc_code=b.doc_id(+) \n"+
				"       and a.bank_code=b2.doc_id \n"+
				"       and a.reg_id=c.user_id \n"+
				"       and b2.user_id1=d.user_id \n"+
				"       and b2.user_id2=e.user_id \n"+
				"       and a.reqseq=i.reqseq \n"+
				"       and a.reqseq=i2.reqseq \n"+
				"       and a.reqseq=h3.reqseq(+) "+
			    " ";

		if(st.equals("1")) query += " AND i.p_st2='할부금'";
		if(st.equals("2")) query += " AND i.p_st2='과태료'";
		if(st.equals("3")) query += " AND i.p_st2 NOT IN ('할부금','과태료')";				

		query += " order by a.p_way, a.off_nm"+
				" "; 


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
			System.out.println("[PayMngDatabase:getPayActDocBankCodeList]"+se);
			System.out.println("[PayMngDatabase:getPayActDocBankCodeList]"+query);
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
	 *	출금송금관리
	 */
    public Vector getPayActDocBankCodeList_Sub(String bank_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query1 = "";
		String sub_query2 = "";
		String query = "";

		query = " select \n"+
				"        a.* \n"+
				" from \n"+
				"        pay_act a "+
				" where \n"+
				"       a.bank_code='"+bank_code+"'  \n"+ 
//				" order by a.p_way, a.off_nm"+
				" "; 


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
			System.out.println("[PayMngDatabase:getPayActDocBankCodeList_Sub]"+se);
			System.out.println("[PayMngDatabase:getPayActDocBankCodeList_Sub]"+query);
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
	 *	출금송금관리
	 */
    public Vector getPayABankCodeList(String bank_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query1 = "";
		String sub_query2 = "";
		String query = "";

		sub_query1 = " select \n"+
				"        a.*, \n"+
				"        i.p_gubun, i.acct_code, i.p_cont, i.p_st5, "+
				"        i2.i_seq, nvl(i2.i_amt,0) i_amt, nvl(i2.i_cnt,0) i_cnt, \n"+
				"        decode(a.reg_st,'D','직접','A','자동','조회') reg_st_nm, \n"+
				"        decode(a.p_way,'1','현금지출','2','선불카드','3','후불카드','4','자동이체','5','계좌이체','7','카드할부') way_nm, \n"+
				"        decode(i.p_gubun,'01','자동차대금','06','중고차대금','07','사전계약계약금','08','계약금카드결제','02','영업수당','03','자동차보험료','04','할부금','05','할부금중도상환', \n"+
				"	                      '11','정비비','14','정비비(정산)','15','피해사고공임부가세','16','피해사고부품부가세', '18','피해사고렌트부가세', '19','피해사고유리부가세', \n"+
				"	                      '12','탁송료','13','용품비', '17','검사비', \n"+
				"                         '21','과태료','22','개별소비세','23','자동차세','24','환경개선부담금', '25','취득세', \n"+
				"                         '31','해지정산금환불','32','CMS과출금','33','계약승계보증금','34','대차승계보증금', '35','계약승계보증금환불', '36','연장계약보증금환불', '37','월렌트정산금환불', \n"+
				"	                      '41','법인카드대금','42','법인카드대금(지방세)','43','법인카드대금(지방세)','44','법인카드대금(자동차대금)', '45','법인카드대금(지방세23일)', '46','법인카드대금(선불기타)', '47','법인카드대금(지방세말일결재)', '48','법인카드대금(지방세익월8일결재)', \n"+
				"	                      '51','캠페인포상금','52','제안포상금','53','귀향여비','54','인터넷당직비', '55','당직비', \n"+
				"	                      '60','자금집금','61','이체수수료','99',i.p_st2||decode(nvl(i2.i_cnt,0),'0','','1','','외')) gubun_nm, \n"+
//				"        decode(a.filename1,'',0,1)+decode(a.filename2,'',0,1)+decode(a.filename3,'',0,1)+decode(a.filename4,'',0,1)+decode(a.filename5,'',0,1) file_cnt,"+
				"        c.user_nm as reg_nm, \n"+
				"        d.user_nm as user_nm1, \n"+
				"        e.user_nm as user_nm2, h3.file_cnt  \n"+
				" from \n"+
				"        pay a, (select * from doc_settle where doc_st='31' and doc_step='3') b, users c, users d, users e, \n"+
				"        (select * from pay_item where i_seq='1') i, "+
				"        (select reqseq, min(i_seq) i_seq, sum(i_amt) i_amt, count(0) i_cnt from pay_item group by reqseq) i2, \n"+
				"        (select content_seq as reqseq, count(0) file_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='PAY' group by content_seq) h3 "+
				" where \n"+
				"       a.bank_code='"+bank_code+"' and a.p_way<>'1' and a.bank_no is not null \n"+// and i.p_gubun<>'60'
				"       and a.doc_code=b.doc_id \n"+
				"       and a.reg_id=c.user_id \n"+
				"       and b.user_id1=d.user_id(+) \n"+
				"       and b.user_id2=e.user_id(+) \n"+
				"       and a.reqseq=i.reqseq \n"+
				"       and a.reqseq=i2.reqseq \n"+
				"       and a.reqseq=h3.reqseq(+) "+
				" "; 

		sub_query2 = " select \n"+
				"        a.*, \n"+
				"        i.p_gubun, i.acct_code, i.p_cont, i.p_st5, "+
				"        i2.i_seq, nvl(i2.i_amt,0) i_amt, nvl(i2.i_cnt,0) i_cnt, \n"+
				"        decode(a.reg_st,'D','직접','A','자동','조회') reg_st_nm, \n"+
				"        decode(a.p_way,'1','현금지출','2','선불카드','3','후불카드','4','자동이체','5','계좌이체','7','카드할부') way_nm, \n"+
				"        decode(i.p_gubun,'01','자동차대금','06','중고차대금','07','사전계약계약금','08','계약금카드결제','02','영업수당','03','자동차보험료','04','할부금','05','할부금중도상환', \n"+
				"	                      '11','정비비','14','정비비(정산)','15','피해사고공임부가세','16','피해사고부품부가세', '18','피해사고렌트부가세', '19','피해사고유리부가세', \n"+
				"	                      '12','탁송료','13','용품비', '17','검사비', \n"+
				"                         '21','과태료','22','개별소비세','23','자동차세','24','환경개선부담금', '25','취득세', \n"+
				"                         '31','해지정산금환불','32','CMS과출금','33','계약승계보증금','34','대차승계보증금', '35','계약승계보증금환불', '36','연장계약보증금환불', '37','월렌트정산금환불', \n"+
				"	                      '41','법인카드대금','42','법인카드대금(지방세)','43','법인카드대금(지방세)','44','법인카드대금(자동차대금)', '45','법인카드대금(지방세23일)', '46','법인카드대금(선불기타)', '47','법인카드대금(지방세말일결재)', '48','법인카드대금(지방세익월8일결재)', \n"+
				"	                      '51','캠페인포상금','52','제안포상금','53','귀향여비','54','인터넷당직비', '55','당직비', \n"+
				"	                      '60','자금집금','61','이체수수료','99',i.p_st2||decode(nvl(i2.i_cnt,0),'0','','1','','외')) gubun_nm, \n"+
//				"        decode(a.filename1,'',0,1)+decode(a.filename2,'',0,1)+decode(a.filename3,'',0,1)+decode(a.filename4,'',0,1)+decode(a.filename5,'',0,1) file_cnt,"+
				"        c.user_nm as reg_nm, \n"+
				"        d.user_nm as user_nm1, \n"+
				"        decode(e.user_nm,d.user_nm,'',e.user_nm) as user_nm2, h3.file_cnt  \n"+
				" from \n"+
				"        pay a, (select * from doc_settle where doc_st='31' and doc_step='3') b, users c, users d, users e, \n"+
				"        (select * from pay_item where i_seq='1') i, "+
				"        (select reqseq, min(i_seq) i_seq, sum(i_amt) i_amt, count(0) i_cnt from pay_item group by reqseq) i2, \n"+
				"        (select content_seq as reqseq, count(0) file_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='PAY' group by content_seq) h3 "+
				" where \n"+
				"       a.bank_code='"+bank_code+"' and a.bank_no is null and i.p_gubun<>'60' \n"+//and a.p_way<>'5' 
				"       and a.doc_code=b.doc_id \n"+
				"       and a.reg_id=c.user_id \n"+
				"       and b.user_id1=d.user_id(+) \n"+
				"       and b.user_id2=e.user_id(+) \n"+
				"       and a.reqseq=i.reqseq \n"+
				"       and a.reqseq=i2.reqseq \n"+
				"       and a.reqseq=h3.reqseq(+) "+
				" "; 


		query = " select '5' p_way, '계좌이체' way_nm, "+
				"        decode(act_union_yn,'N',decode(p_gubun,'21',decode(off_nm,'한국도로공사','',p_st5),'')) bank_memo, "+
				"        off_nm, bank_id, bank_no, max(bank_nm) bank_nm, max(bank_acc_nm) bank_acc_nm, "+
				"        a_bank_id, a_bank_no, max(a_bank_nm) a_bank_nm, (sum(amt)-sum(nvl(m_amt,0))) amt, min(p_cont) p_cont, count(0) cnt, max(at_once) at_once "+
				" from ("+sub_query1+") "+
				" group by "+
				"        decode(act_union_yn,'N',decode(p_gubun,'21',decode(off_nm,'한국도로공사','',p_st5),'')), "+
				"        off_nm, bank_id, bank_no, a_bank_id, a_bank_no"+
				" union all "+
				" select p_way, way_nm, '' bank_memo, "+
				"        off_nm, bank_id, bank_no, bank_nm, bank_acc_nm, a_bank_id, a_bank_no, a_bank_nm, amt, p_cont, 1 as cnt, at_once "+
				" from ("+sub_query2+") "+
				" ";



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
			System.out.println("[PayMngDatabase:getPayABankCodeList]"+se);
			System.out.println("[PayMngDatabase:getPayABankCodeList]"+query);
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
	 *	출금송금관리
	 */
    public Vector getPayABankCodeList2(String bank_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String sub_query1 = "";
		String sub_query2 = "";
		String query = "";

		sub_query1 = " select \n"+
				"        a.*, to_char(b2.user_dt2,'YYYYMMDD') pay_dt, \n"+
				"        i.p_gubun, i.acct_code, i.p_cont, "+
				"        i2.i_seq, nvl(i2.i_amt,0) i_amt, nvl(i2.i_cnt,0) i_cnt, \n"+
				"        decode(a.reg_st,'D','직접','A','자동','조회') reg_st_nm, \n"+
				"        decode(a.p_way,'1','현금지출','2','선불카드','3','후불카드','4','자동이체','5','계좌이체','7','카드할부') way_nm, \n"+
				"        decode(i.p_gubun,'01','자동차대금','06','중고차대금','07','사전계약계약금','08','계약금카드결제','02','영업수당','03','자동차보험료','04','할부금','05','할부금중도상환', \n"+
				"	                      '11','정비비','14','정비비(정산)','15','피해사고공임부가세','16','피해사고부품부가세', '18','피해사고렌트부가세', '19','피해사고유리부가세', \n"+
				"	                      '12','탁송료','13','용품비', '17','검사비', \n"+
				"                         '21','과태료','22','개별소비세','23','자동차세','24','환경개선부담금', '25','취득세', \n"+
				"                         '31','해지정산금환불','32','CMS과출금','33','계약승계보증금','34','대차승계보증금', '35','계약승계보증금환불', '36','연장계약보증금환불', '37','월렌트정산금환불', \n"+
				"	                      '41','법인카드대금','42','법인카드대금(지방세)','43','법인카드대금(지방세)','44','법인카드대금(자동차대금)', '45','법인카드대금(지방세23일)', '46','법인카드대금(선불기타)', '47','법인카드대금(지방세말일결재)', '48','법인카드대금(지방세익월8일결재)', \n"+
				"	                      '51','캠페인포상금','52','제안포상금','53','귀향여비','54','인터넷당직비', '55','당직비', \n"+
				"	                      '60','자금집금','61','이체수수료','99',i.p_st2||decode(nvl(i2.i_cnt,0),'0','','1','','외')) gubun_nm, \n"+
				"        c.user_nm as reg_nm, \n"+
				"        d.user_nm as user_nm1, \n"+
				"        e.user_nm as user_nm2, h3.file_cnt  \n"+
				" from \n"+
				"        pay a, (select * from doc_settle where doc_st='31' and doc_step='3') b, users c, users d, users e, \n"+
				"        (select * from pay_item where i_seq='1') i, (select * from doc_settle where doc_st='32' and doc_step='3') b2, "+
				"        (select reqseq, min(i_seq) i_seq, sum(i_amt) i_amt, count(0) i_cnt from pay_item group by reqseq) i2, \n"+
				"        (select content_seq as reqseq, count(0) file_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='PAY' group by content_seq) h3 "+
				" where \n"+
				"       a.bank_code='"+bank_code+"' and a.bank_no is not null  and i.p_gubun<>'60' and a.p_pay_dt is null \n"+//
				"       and a.doc_code=b.doc_id \n"+
				"       and a.bank_code=b2.doc_id \n"+
				"       and a.reg_id=c.user_id \n"+
				"       and b.user_id1=d.user_id(+) \n"+
				"       and b.user_id2=e.user_id(+) \n"+
				"       and a.reqseq=i.reqseq \n"+
				"       and a.reqseq=i2.reqseq \n"+
				"       and a.reqseq=h3.reqseq(+) "+
				" "; 




		query = " select '5' p_way, '계좌이체' way_nm, "+
				"        pay_dt, off_nm, bank_id, bank_no, a_bank_id, a_bank_no, "+
				"        max(a_bank_nm) a_bank_nm, max(bank_nm) bank_nm, max(bank_acc_nm) bank_acc_nm, "+
				"        max(bank_cms_bk) bank_cms_bk, max(a_bank_cms_bk) a_bank_cms_bk, "+
				"        (sum(amt)-sum(nvl(m_amt,0))) amt, min(p_cont) p_cont, count(0) cnt "+
				" from   ("+sub_query1+") "+
				" group by pay_dt, off_nm, bank_id, bank_no, a_bank_id, a_bank_no"+
				" order by pay_dt, off_nm, bank_id, bank_no, a_bank_id, a_bank_no"+
				" ";



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
			System.out.println("[PayMngDatabase:getPayABankCodeList2]"+se);
			System.out.println("[PayMngDatabase:getPayABankCodeList2]"+query);
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
	 *	출금회계관리
	 */
    public Vector getPayCList(String s_kd, String t_wd, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
				"        a.*, \n"+
				"        i.p_gubun, i.acct_code, i.p_cont, "+
				"        i2.i_seq, nvl(i2.i_amt,0) i_amt, nvl(i2.i_s_amt,0) i_s_amt, nvl(i2.i_v_amt,0) i_v_amt, nvl(i2.i_cnt,0) i_cnt, \n"+
				"        decode(a.reg_st,'D','직접','A','자동','조회') reg_st_nm, \n"+
				"        decode(a.acct_code_st,'1','모른다','2','기발행','3','등록시발행','4','처리안한다') acct_code_st_nm, \n"+
				"        decode(a.p_way,'1','현금지출','2','선불카드','3','후불카드','4','자동이체','5','계좌이체','7','카드할부') way_nm, \n"+
				"        decode(i.p_gubun,'01','자동차대금','06','중고차대금','07','사전계약계약금','08','계약금카드결제','02','영업수당','03','자동차보험료','04','할부금','05','할부금중도상환', \n"+
				"	                      '11','정비비','14','정비비(정산)','15','피해사고공임부가세','16','피해사고부품부가세', '18','피해사고렌트부가세', '19','피해사고유리부가세', \n"+
				"	                      '12','탁송료','13','용품비', '17','검사비', \n"+
				"                         '21','과태료','22','개별소비세','23','자동차세','24','환경개선부담금', '25','취득세', \n"+
				"                         '31','해지정산금환불','32','CMS과출금','33','계약승계보증금','34','대차승계보증금', '35','계약승계보증금환불', '36','연장계약보증금환불', '37','월렌트정산금환불', \n"+
				"	                      '41','법인카드대금','42','법인카드대금(지방세)','43','법인카드대금(지방세)','44','법인카드대금(자동차대금)', '45','법인카드대금(지방세23일)', '46','법인카드대금(선불기타)', '47','법인카드대금(지방세말일결재)', '48','법인카드대금(지방세익월8일결재)', \n"+
				"	                      '51','캠페인포상금','52','제안포상금','53','귀향여비','54','인터넷당직비', '55','당직비', \n"+
				"	                      '60','자금집금','61','이체수수료','99',i.p_st2||decode(nvl(i2.i_cnt,0),'0','','1','','외')) gubun_nm, \n"+
				"        c.user_nm as reg_nm, \n"+
				"        d.user_nm as user_nm1, \n"+
				"        case when d.br_id='S1' then decode(b.user_dt2,'','',e.user_nm) else decode(b.user_id2,'XXXXXX','부재중결재',decode(b.user_dt2,'','',e.user_nm)) end user_nm2, \n"+
				"        decode(b.doc_step,'3',decode(b.user_dt3,'','사후결재',f.user_nm)) as user_nm3, \n"+
				"        decode(b2.user_dt1,'','',d1.user_nm) as d_user_nm1, \n"+
				"        decode(b2.doc_step,'3',decode(b2.user_dt2,'','사후결재',d2.user_nm)) as d_user_nm2,  \n"+
				"        i.p_cd1, i.p_cd2, i.p_cd3, i.p_cd4, i.p_cd5, i.p_cd6, i.p_st1, i.p_st4, h3.file_cnt "+
				" from \n"+
				"        pay a, (select * from doc_settle where doc_st='31') b, users c, users d, users e, users f, users d1, users d2, \n"+
				"        (select * from pay_item where i_seq='1') i, (select * from doc_settle where doc_st='32') b2, "+
				"        (select reqseq, min(i_seq) i_seq, sum(i_amt) i_amt, sum(i_s_amt) i_s_amt, sum(i_v_amt) i_v_amt, count(0) i_cnt from pay_item group by reqseq) i2, \n"+
				"        (select content_seq as reqseq, count(0) file_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='PAY' group by content_seq) h3 "+
				" where \n"+
				"		a.doc_code=b.doc_id(+) "+
				"       and a.bank_code=b2.doc_id(+) "+
				"       and a.reg_id=c.user_id \n"+
				"       and b.user_id1=d.user_id(+) \n"+
				"       and b.user_id2=e.user_id(+) \n"+
				"       and b.user_id3=f.user_id(+) \n"+
				"       and b2.user_id1=d1.user_id(+) \n"+
				"       and b2.user_id2=d2.user_id(+) \n"+
				"       and a.reqseq=i.reqseq \n"+
				"       and a.reqseq=i2.reqseq \n"+
				"       and to_char(a.reg_dt,'YYYYMMDD') >= '20091130'"+
				"       and a.reqseq=h3.reqseq(+) "+
				" "; 

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		
		dt1 = "substr(a.p_pay_dt,1,6)";
		dt2 = "a.p_pay_dt";

		if(gubun5.equals("1"))	query += " and a.p_step='4' and a.AUTODOCU_WRITE_DATE is null"; 
		if(gubun5.equals("2"))	query += " and a.p_step='5' and a.AUTODOCU_WRITE_DATE is not null"; 

		if(gubun1.equals("2"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
		else if(gubun1.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
		else if(gubun1.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";//전일
		else if(gubun1.equals("3")){
			if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
			if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
		}

		if(!gubun2.equals(""))	query += " and a.p_way = '"+gubun2+"'"; 

		if(!gubun3.equals(""))	query += " and ( i.p_gubun = '"+gubun3+"' or i.acct_code = '"+gubun3+"' )"; 


		if(s_kd.equals("1"))	what = "upper(nvl(a.off_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.bank_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.bank_no, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(i.p_cont, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(c.user_nm, ' '))";	
		if(s_kd.equals("6"))	what = "upper(nvl(d.user_nm, ' '))";	
		if(s_kd.equals("7"))	what = "upper(nvl(d1.user_nm, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by i.p_gubun, i.acct_code, a.p_pay_dt, i.p_cd1, i.p_cd2, i.p_cd3, i.p_cd4, i.p_cd5";

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
			System.out.println("[PayMngDatabase:getPayCList]"+se);
			System.out.println("[PayMngDatabase:getPayCList]"+query);
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
	 *	출금원장관리
	 */
    public Vector getPayMList(String s_kd, String t_wd, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4, String gubun5) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
				"        a.*, substr(b.doc_no,9) doc_no1, substr(b2.doc_no,9) doc_no2, b.doc_no as doc_no11, b2.doc_no as doc_no22, \n"+
				"        i.p_gubun, i.acct_code, i.p_cont, i.p_cd1, i.p_cd2, i.p_cd3, i.p_cd4, i.p_cd5, i.p_cd6, i.p_st1, i.p_st4, \n"+
				"        i2.i_seq, nvl(i2.i_amt,0) i_amt, nvl(i2.i_cnt,0) i_cnt, \n"+
				"        decode(a.amt,i2.i_amt,'완결','미완') reg_end, "+
				"        decode(a.reg_st,'D','직접','A','자동','조회') reg_st_nm, \n"+
//				"        decode(a.r_acct_code,'=',i.acct_code,a.r_acct_code) r_acct_code_nm, \n"+
//				"        decode(a.r_acct_code,'1','모른다','2','기발행','3','등록시발행','4','처리안한다') r_acct_code_nm, \n"+
				"        decode(a.acct_code_st,'1','모른다','2','기발행','3','등록시발행','4','처리안한다') acct_code_st_nm, \n"+
				"        decode(a.p_way,'1','현금지출','2','선불카드','3','후불카드','4','자동이체','5','계좌이체','7','카드할부') way_nm, \n"+
				"        decode(i.p_gubun,'01','자동차대금','06','중고차대금','07','사전계약계약금','08','계약금카드결제','02','영업수당','03','자동차보험료','04','할부금','05','할부금중도상환', \n"+
				"	                      '11','정비비','14','정비비(정산)','15','피해사고공임부가세','16','피해사고부품부가세', '18','피해사고렌트부가세', '19','피해사고유리부가세', \n"+
				"	                      '12','탁송료','13','용품비', '17','검사비', \n"+
				"                         '21','과태료','22','개별소비세','23','자동차세','24','환경개선부담금', '25','취득세', \n"+
				"                         '31','해지정산금환불','32','CMS과출금','33','계약승계보증금','34','대차승계보증금', '35','계약승계보증금환불', '36','연장계약보증금환불', '37','월렌트정산금환불', \n"+
				"	                      '41','법인카드대금','42','법인카드대금(지방세)','43','법인카드대금(지방세)','44','법인카드대금(자동차대금)', '45','법인카드대금(지방세23일)', '46','법인카드대금(선불기타)', '47','법인카드대금(지방세말일결재)', '48','법인카드대금(지방세익월8일결재)', \n"+
				"	                      '51','캠페인포상금','52','제안포상금','53','귀향여비','54','인터넷당직비', '55','당직비', \n"+
				"	                      '60','자금집금','61','이체수수료','99',i.p_st2||decode(nvl(i2.i_cnt,0),'0','','1','','외')) gubun_nm, \n"+
				"        decode(a.p_step,'0','원장등록','1','기안대기','2','문서기안','3','송금요청','4','송금완료','5','회계처리') step_nm, \n"+
				"        to_char(a.reg_dt,'YYYYMMDD') p_reg_dt, \n"+
//				"        decode(a.filename1,'',0,1)+decode(a.filename2,'',0,1)+decode(a.filename3,'',0,1)+decode(a.filename4,'',0,1)+decode(a.filename5,'',0,1) file_cnt,"+
				"        c.user_nm as reg_nm, \n"+

				"        d.user_nm as user_nm1, d.br_id, \n"+
				"        case when d.br_id='S1' then decode(b.user_dt2,'','',e.user_nm) else decode(b.user_id2,'XXXXXX','부재중결재',decode(b.user_dt2,'','',e.user_nm)) end user_nm2, \n"+
				"        decode(b.doc_step,'3',decode(b.user_dt3,'','사후결재',f.user_nm)) as user_nm3, \n"+
				"        decode(b2.user_dt1,'','',d1.user_nm) as d_user_nm1, \n"+
				"        decode(b2.doc_step,'3',decode(b2.user_dt2,'','사후결재',d2.user_nm)) as d_user_nm2, h3.file_cnt  \n"+
/*
				"        d.user_nm as user_nm1, \n"+
				"        decode(b.user_dt2,'','',e.user_nm) as user_nm2, \n"+
				"        decode(b.user_dt3,'','',f.user_nm) as user_nm3, \n"+
				"        decode(b2.user_dt1,'','',d1.user_nm) as d_user_nm1, \n"+
				"        decode(b2.user_dt2,'','',d2.user_nm) as d_user_nm2  \n"+
*/
				" from \n"+
				"        pay a, (select * from doc_settle where doc_st='31') b, users c, users d, users e, users f, users d1, users d2, users g, \n"+
				"        (select * from pay_item where i_seq='1') i, (select * from doc_settle where doc_st='32') b2, "+
				"        (select reqseq, min(i_seq) i_seq, sum(i_amt) i_amt, count(0) i_cnt from pay_item group by reqseq) i2, \n"+
				"        (select content_seq as reqseq, count(0) file_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='PAY' group by content_seq) h3 "+
				" where \n"+
				"       a.doc_code=b.doc_id(+)\n"+// and decode(a.p_gubun,'60','3',b.doc_step)='3'
				"       and a.bank_code=b2.doc_id(+) "+
				"       and a.reg_id=c.user_id \n"+
				"       and b.user_id1=d.user_id(+) \n"+
				"       and b.user_id2=e.user_id(+) \n"+
				"       and b.user_id3=f.user_id(+) \n"+
				"       and b2.user_id1=d1.user_id(+) \n"+
				"       and b2.user_id2=d2.user_id(+) \n"+
				"       and a.reqseq=i.reqseq \n"+
				"       and a.reqseq=i2.reqseq \n"+
				"       and to_char(a.reg_dt,'YYYYMMDD') >= '20091130'"+
				"       and i.buy_user_id=g.user_id(+) "+
				"       and a.reqseq=h3.reqseq(+) "+
				" "; 

		String search = "";
		String what = "";
		String dt1 = "";
		String dt2 = "";
		
		if(gubun5.equals("2")){
			query += " and (decode(b.doc_step||b.user_dt3,'3',1,0)+decode(b2.doc_step||b2.user_dt2,'3',1,0)) >0 "; 
		}else{
			dt1 = "substr(a.p_pay_dt,1,6)";
			dt2 = "a.p_pay_dt";

			if(gubun4.equals("2")){
				dt1 = "substr(a.p_est_dt,1,6)";
				dt2 = "a.p_est_dt";
			}else if(gubun4.equals("3")){
				dt1 = "to_char(a.reg_dt,'YYYYMM')";
				dt2 = "to_char(a.reg_dt,'YYYYMMDD')";
			}


			if(gubun1.equals("2"))			query += " and "+dt2+" like to_char(sysdate,'YYYYMM')||'%'";
			else if(gubun1.equals("1"))		query += " and "+dt2+" = to_char(sysdate,'YYYYMMDD')";
			else if(gubun1.equals("4"))		query += " and "+dt2+" = to_char(sysdate-1,'YYYYMMDD')";//전일
			else if(gubun1.equals("3")){
				if(!st_dt.equals("") && end_dt.equals(""))	query += " and "+dt2+" like replace('"+st_dt+"%', '-','')";
				if(!st_dt.equals("") && !end_dt.equals("")) query += " and "+dt2+" between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')";
			}

		}

		if(!gubun2.equals(""))	query += " and a.p_way = '"+gubun2+"'"; 

//		if(!gubun3.equals(""))	query += " and a.p_gubun = '"+gubun3+"'"; 
		
		//영업수당(vat)
		if(gubun3.equals("02vat")){ 
			query += " and i.p_gubun = '02' and i.P_ST4 = 'vat'";
		//항목별	
		}else {
			if(!gubun3.equals(""))	query += " and ( i.p_gubun = '"+gubun3+"' or i.acct_code = '"+gubun3+"' )";
		}	

		if(s_kd.equals("1"))	what = "upper(nvl(a.off_nm, ' '))";
		if(s_kd.equals("2"))	what = "upper(nvl(a.bank_nm, ' '))";	
		if(s_kd.equals("3"))	what = "upper(nvl(a.bank_no, ' '))";	
		if(s_kd.equals("4"))	what = "upper(nvl(i.p_cont, ' '))";	
		if(s_kd.equals("5"))	what = "upper(nvl(c.user_nm, ' '))";	
		if(s_kd.equals("6"))	what = "upper(nvl(d.user_nm, ' '))";	
		if(s_kd.equals("7"))	what = "upper(nvl(d1.user_nm, ' '))";	
		if(s_kd.equals("8"))	what = "upper(nvl(a.reqseq, ' '))";	
		if(s_kd.equals("9"))	what = "upper(nvl(a.s_idno, ' '))";	
		if(s_kd.equals("10"))	what = "upper(nvl(a.bank_acc_nm, ' '))";	
		if(s_kd.equals("11"))	what = "upper(nvl(a.autodocu_data_no, ' '))";	
		if(s_kd.equals("12"))	what = "upper(nvl(g.user_nm, ' '))";	
			
		if(!s_kd.equals("") && !t_wd.equals("")){
			query += " and "+what+" like upper('%"+t_wd+"%') ";
		}	

		query += " order by a.p_pay_dt, a.p_est_dt, i.p_gubun, i.p_cd1, i.p_cd2, i.p_cd3, i.p_cd4, i.p_cd5";


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
			System.out.println("[PayMngDatabase:getPayMList]"+se);
			System.out.println("[PayMngDatabase:getPayMList]"+query);
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
	 *	출금결재문서
	 */
    public Vector getPayDocList(String doc_code, String p_est_dt, String p_gubun, String p_br_id, String doc_no) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				"        a.*, i.p_gubun, i.p_cont||decode(i2.item_cnt,1,'',' 외'||i2.item_cnt||'건') p_cont, nvl(i2.item_cnt,0) i_cnt, c.user_nm as reg_nm, to_char(a.reg_dt,'MM-DD')||' '||to_char(a.reg_dt,'HH24:MI') reg_dt_nm, \n"+
				"        decode(a.reg_st,'D','직접','A','자동','조회') reg_st_nm, \n"+
				"        decode(a.p_way,'1','현금지출','2','선불카드','3','후불카드','4','자동이체','5','계좌이체','7','카드할부') way_nm,"+
				"        decode(i.p_gubun,'01','자동차대금','06','중고차대금','07','사전계약계약금','08','계약금카드결제','02','영업수당','03','자동차보험료','04','할부금','05','할부금중도상환', \n"+
				"	                      '11','정비비','14','정비비(정산)','15','피해사고공임부가세','16','피해사고부품부가세', '18','피해사고렌트부가세', '19','피해사고유리부가세', \n"+
				"	                      '12','탁송료','13','용품비', '17','검사비', \n"+
				"                         '21','과태료','22','개별소비세','23','자동차세','24','환경개선부담금', '25','취득세', \n"+
				"                         '31','해지정산금환불','32','CMS과출금','33','계약승계보증금','34','대차승계보증금', '35','계약승계보증금환불', '36','연장계약보증금환불', '37','월렌트정산금환불', \n"+
				"	                      '41','법인카드대금','42','법인카드대금(지방세)','43','법인카드대금(지방세)','44','법인카드대금(자동차대금)', '45','법인카드대금(지방세23일)', '46','법인카드대금(선불기타)', '47','법인카드대금(지방세말일결재)', '48','법인카드대금(지방세익월8일결재)', \n"+
				"	                      '51','캠페인포상금','52','제안포상금','53','귀향여비','54','인터넷당직비', '55','당직비', \n"+
				"	                      '60','자금집금','61','이체수수료','99',i.p_st2||decode(i2.item_cnt,1,'',' 외')) gubun_nm,"+
//				"        decode(a.filename1,'',0,1)+decode(a.filename2,'',0,1)+decode(a.filename3,'',0,1)+decode(a.filename4,'',0,1)+decode(a.filename5,'',0,1) file_cnt, "+
				"        i.p_cd1, i.p_cd2, i.p_cd3, i.p_cd4, i.p_cd5, i.p_cd6, i.p_st1, i.p_st4, h3.file_cnt "+
				" from"+
				"        pay a, (select * from pay_item where i_seq=1) i, (select reqseq, max(i_seq) max_seq, count(0) item_cnt from pay_item group by reqseq) i2, doc_settle b, users c, "+
				"        (select content_seq as reqseq, count(0) file_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='PAY' group by content_seq) h3 "+
				" where "+
				"       a.reqseq=i.reqseq and a.reqseq=i2.reqseq and a.doc_code=b.doc_id(+) "+//a.p_step='2' and 
				"       and a.reg_id=c.user_id(+)"+
				"       and a.reqseq=h3.reqseq(+) "+
				" "; 

		if(!doc_code.equals(""))	query += " and a.doc_code='"+doc_code+"'";

		if(!doc_no.equals("")){
			query += " and b.doc_no='"+doc_no+"'";
		}else{	
			if(!p_est_dt.equals(""))	query += " and a.p_est_dt='"+p_est_dt+"'";
			if(!p_gubun.equals(""))		query += " and i.p_gubun='"+p_gubun+"'";
			if(!p_br_id.equals(""))		query += " and c.br_id='"+p_br_id+"'";
		}

		if(p_est_dt.equals("app_st")){
			if(p_gubun.equals("1")) query += " AND i.p_st2='할부금'";
			if(p_gubun.equals("2")) query += " AND i.p_st2='과태료'";
			if(p_gubun.equals("3")) query += " AND i.p_st2 NOT IN ('할부금','과태료')";				
		}


		query += " order by a.p_way, a.reqseq";

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
			System.out.println("[PayMngDatabase:getPayDocList]"+se);
			System.out.println("[PayMngDatabase:getPayDocList]"+query);
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
	 *	출금결재문서
	 */
    public Vector getPayDocLists(String p_req_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select "+
				"        a.*, \n"+
				"        i.p_gubun, i.p_cont||decode(i2.item_cnt,1,'',' 외'||i2.item_cnt||'건') p_cont, \n"+
				"        nvl(i2.item_cnt,0) i_cnt, c.user_nm as reg_nm, to_char(a.reg_dt,'MM-DD')||' '||to_char(a.reg_dt,'HH24:MI') reg_dt_nm, \n"+
				"        decode(a.reg_st,'D','직접','A','자동','조회') reg_st_nm, \n"+
				"        decode(a.p_way,'1','현금지출','2','선불카드','3','후불카드','4','자동이체','5','계좌이체','7','카드할부') way_nm,"+
				"        decode(i.p_gubun,'01','자동차대금','06','중고차대금','07','사전계약계약금','08','계약금카드결제','02','영업수당','03','자동차보험료','04','할부금','05','할부금중도상환', \n"+
				"	                      '11','정비비','14','정비비(정산)','15','피해사고공임부가세','16','피해사고부품부가세', '18','피해사고렌트부가세', '19','피해사고유리부가세', \n"+
				"	                      '12','탁송료','13','용품비', '17','검사비', \n"+
				"                         '21','과태료','22','개별소비세','23','자동차세','24','환경개선부담금', '25','취득세', \n"+
				"                         '31','해지정산금환불','32','CMS과출금','33','계약승계보증금','34','대차승계보증금', '35','계약승계보증금환불', '36','연장계약보증금환불', '37','월렌트정산금환불', \n"+
				"	                      '41','법인카드대금','42','법인카드대금(지방세)','43','법인카드대금(지방세)','44','법인카드대금(자동차대금)', '45','법인카드대금(지방세23일)', '46','법인카드대금(선불기타)', '47','법인카드대금(지방세말일결재)', '48','법인카드대금(지방세익월8일결재)', \n"+
				"	                      '51','캠페인포상금','52','제안포상금','53','귀향여비','54','인터넷당직비', '55','당직비', \n"+
				"	                      '60','자금집금','61','이체수수료','99',i.p_st2||decode(i2.item_cnt,1,'',' 외')) gubun_nm,"+
//				"        decode(a.filename1,'',0,1)+decode(a.filename2,'',0,1)+decode(a.filename3,'',0,1)+decode(a.filename4,'',0,1)+decode(a.filename5,'',0,1) file_cnt, \n"+
				"        i.p_cd1, i.p_cd2, i.p_cd3, i.p_cd4, i.p_cd5, i.p_st1, i.p_st4, h3.file_cnt \n"+
				" from"+
				"        pay a, (select * from pay_item where i_seq=1) i, (select reqseq, max(i_seq) max_seq, count(0) item_cnt from pay_item group by reqseq) i2, doc_settle b, users c, "+
				"        (select content_seq as reqseq, count(0) file_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='PAY' group by content_seq) h3 "+
				" where "+
				"       a.p_step='1' and a.doc_code is null and a.reqseq=i.reqseq and a.reqseq=i2.reqseq and a.doc_code=b.doc_id(+) "+
				"       and a.reg_id=c.user_id(+)"+
				"       and a.reqseq=h3.reqseq(+) "+
				" "; 

		if(!p_req_dt.equals(""))	query += " and a.p_req_dt||i.p_gubun||a.reg_id||nvl(i.acct_code,'00000')||nvl(a.at_once,'N') in "+p_req_dt+"";


		query += " order by i.p_gubun, a.p_way, a.reqseq";

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
			System.out.println("[PayMngDatabase:getPayDocLists]"+se);
			System.out.println("[PayMngDatabase:getPayDocLists]"+query);
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
	 *	출금결재문서
	 */
    public Vector getPayDocStats(String p_req_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";

		query = " select "+
				"        a.*, c.user_nm as reg_nm,"+
				"        decode(a.reg_st,'D','직접','A','자동','조회') reg_st_nm, \n"+
				"        decode(a.p_way,'1','현금지출','2','선불카드','3','후불카드','4','자동이체','5','계좌이체','7','카드할부') way_nm,"+
				"        decode(a.p_gubun,'01','자동차대금','06','중고차대금','07','사전계약계약금','08','계약금카드결제','02','영업수당','03','자동차보험료','04','할부금','05','할부금중도상환', \n"+
				"	                      '11','정비비','14','정비비(정산)','15','피해사고공임부가세','16','피해사고부품부가세', '18','피해사고렌트부가세', '19','피해사고유리부가세', \n"+
				"	                      '12','탁송료','13','용품비', '17','검사비', \n"+
				"                         '21','과태료','22','개별소비세','23','자동차세','24','환경개선부담금', '25','취득세', \n"+
				"                         '31','해지정산금환불','32','CMS과출금','33','계약승계보증금','34','대차승계보증금', '35','계약승계보증금환불', '36','연장계약보증금환불', '37','월렌트정산금환불', \n"+
				"	                      '41','법인카드대금','42','법인카드대금(지방세)','43','법인카드대금(지방세)','44','법인카드대금(자동차대금)', '45','법인카드대금(지방세23일)', '46','법인카드대금(선불기타)', '47','법인카드대금(지방세말일결재)', '48','법인카드대금(지방세익월8일결재)', \n"+
				"	                      '51','캠페인포상금','52','제안포상금','53','귀향여비','54','인터넷당직비', '55','당직비', \n"+
				"	                      '60','자금집금','61','이체수수료','99',a.p_st2||decode(a.acct_code2,'','','외')) gubun_nm, "+
//				"        decode(a.filename1,'',0,1)+decode(a.filename2,'',0,1)+decode(a.filename3,'',0,1)+decode(a.filename4,'',0,1)+decode(a.filename5,'',0,1) file_cnt"+
				"        h3.file_cnt"+
				" from"+
				"        pay a, pay_item d, doc_settle b, users c,"+
				"        (select content_seq as reqseq, count(0) file_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='PAY' group by content_seq) h3 "+
				" where "+
				"       a.doc_code=b.doc_id(+) "+
				"       and a.reg_id=c.user_id(+) "+
				"       and a.reqseq=h3.reqseq(+) "+
				" "; 

		if(!p_req_dt.equals(""))	query += " and a.p_req_dt||a.p_gubun in "+p_req_dt+"";

		query += " order by a.p_way, a.reqseq";

		query2 = " select a.*, b.* from (select nvl(bank_nm,'-') bank_nm, nvl(bank_no,'현금+계좌이체+자동이체') bank_no, sum(amt) amt from ("+query+") group by nvl(bank_nm,'현금'), bank_no) a, card b where a.bank_no=b.cardno(+)";

		query2 += " order by decode(a.bank_nm,'현금','a',a.bank_nm)";

	    try{
            pstmt = con.prepareStatement(query2);
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
			System.out.println("[PayMngDatabase:getPayDocStat]"+se);
			System.out.println("[PayMngDatabase:getPayDocStat]"+query2);
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
	 *	출금결재문서
	 */
    public Vector getPayDocAmtStat(String doc_code, String p_est_dt, String p_gubun, String p_br_id, String doc_no) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
		String query2 = "";

		query = " select a.doc_code, b.p_st2, b.p_gubun, c.br_id, count(0) tot_cnt, sum(a.amt) tot_amt, \n"+
				"        decode(b.p_st2,'',decode(b.p_gubun,'01','자동차대금','06','중고차대금','07','사전계약계약금','08','계약금카드결제','02','영업수당','03','자동차보험료','04','할부금','05','할부금중도상환', \n"+
				"	                      '11','정비비','14','정비비(정산)','15','피해사고공임부가세','16','피해사고부품부가세', '18','피해사고렌트부가세', '19','피해사고유리부가세', \n"+
				"	                      '12','탁송료','13','용품비', '17','검사비', \n"+
				"                         '21','과태료','22','개별소비세','23','자동차세','24','환경개선부담금', '25','취득세', \n"+
				"                         '31','해지정산금환불','32','CMS과출금','33','계약승계보증금','34','대차승계보증금', '35','계약승계보증금환불', '36','연장계약보증금환불', '37','월렌트정산금환불', \n"+
				"	                      '41','법인카드대금','42','법인카드대금(지방세)','43','법인카드대금(지방세)','44','법인카드대금(자동차대금)', '45','법인카드대금(지방세23일)', '46','법인카드대금(선불기타)', '47','법인카드대금(지방세말일결재)', '48','법인카드대금(지방세익월8일결재)', \n"+
				"	                      '51','캠페인포상금','52','제안포상금','53','귀향여비','54','인터넷당직비', '55','당직비', \n"+
				"	                      '60','자금집금','61','이체수수료'),b.p_st2) gubun_nm, \n"+		
				"        sum(decode(a.p_way,'1',a.amt,0)) amt1, \n"+
				"        sum(decode(a.p_way,'5',a.amt,0)) amt2, \n"+
				"        sum(decode(a.p_way,'4',a.amt,0)) amt3, \n"+
				"        sum(decode(a.p_way,'2',a.amt,0)) amt4, \n"+
				"        sum(decode(a.p_way,'3',a.amt,0)) amt5, \n"+
				"        sum(decode(a.p_way,'7',a.amt,0)) amt7, \n"+
				"        count(decode(a.p_way,'1',a.reqseq)) cnt1, \n"+
				"        count(decode(a.p_way,'5',a.reqseq)) cnt2, \n"+
				"        count(decode(a.p_way,'4',a.reqseq)) cnt3, \n"+
				"        count(decode(a.p_way,'2',a.reqseq)) cnt4, \n"+
				"        count(decode(a.p_way,'3',a.reqseq)) cnt5, \n"+
				"        count(decode(a.p_way,'7',a.reqseq)) cnt7  \n"+
				" from   pay a, pay_item b, users c \n"+
				" where  a.doc_code='"+doc_code+"' and a.reqseq=b.reqseq and b.i_seq=1 and a.reg_id=c.user_id \n"+
				" group by a.doc_code, b.p_st2, b.p_gubun, c.br_id"+
				" order by b.p_gubun"+
				" "; 

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
			System.out.println("[PayMngDatabase:getPayDocAmtStat]"+se);
			System.out.println("[PayMngDatabase:getPayDocAmtStat]"+query2);
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
	 *	출금송금결과-송금수수료 관리
	 */
    public Vector getPayActBankRsList(String rs_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select act_dt, a_bank_id, a_bank_nm, a_bank_no, count(0) cnt, sum(commi) commi "+
				" from   pay_act "+
				"        where rs_code='"+rs_code+"' and commi>0 group by act_dt, a_bank_id, a_bank_nm, a_bank_no "+
				" ";

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
			System.out.println("[PayMngDatabase:getPayActBankRsList]"+se);
			System.out.println("[PayMngDatabase:getPayActBankRsList]"+query);
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
	 *	출금송금결과-송금수수료 관리
	 */
    public Vector getPayActBankRsCommiList(String rs_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.reqseq, a.* \n"+
				" from pay_act a, (select bank_code, off_nm, bank_no, a_bank_no, min(reqseq) reqseq from pay group by bank_code, off_nm, bank_no, a_bank_no ) b \n"+
				" where a.rs_code='"+rs_code+"' and a.commi>0 \n"+
				" and a.bank_code=b.bank_code and a.off_nm=b.off_nm and a.bank_no=b.bank_no and a.a_bank_no=b.a_bank_no"+
				" ";

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
			System.out.println("[PayMngDatabase:getPayActBankRsCommiList]"+se);
			System.out.println("[PayMngDatabase:getPayActBankRsCommiList]"+query);
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
	 *	출금송금결과-송금수수료 관리
	 */
    public Vector getPayActBankRsCarAmtList(String rs_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select b.reqseq, a.* \n"+
				" from pay_act a, pay b, pay_item c \n"+
				" where a.rs_code='"+rs_code+"' and a.commi>0 \n"+
				" and a.bank_code=b.bank_code and a.off_nm=b.off_nm and a.bank_no=b.bank_no and a.a_bank_no=b.a_bank_no"+
				" and b.reqseq=c.reqseq and c.p_gubun='01' "+
				" ";

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
			System.out.println("[PayMngDatabase:getPayActBankRsCarAmtList]"+se);
			System.out.println("[PayMngDatabase:getPayActBankRsCarAmtList]"+query);
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
	 *	송금-출금원장관리
	 */
    public Vector getPayActList(String bank_code, String p_pay_dt, String off_nm, String bank_no, String a_bank_no) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
				"        a.*, \n"+
				"        i.p_gubun, i.acct_code, i.p_cont, "+
				"        i.p_cd1, i.p_cd2, i.p_cd3, i.p_cd4, i.p_cd5, i.p_cd6, i.p_st1, i.p_st4, \n"+
				"        i2.i_seq, nvl(i2.i_amt,0) i_amt, nvl(i2.i_cnt,0) i_cnt, \n"+
				"        decode(a.amt,i2.i_amt,'완결','미완') reg_end, "+
				"        decode(a.reg_st,'D','직접','A','자동','조회') reg_st_nm, \n"+
//				"        decode(a.r_acct_code,'=',i.acct_code,a.r_acct_code) r_acct_code_nm, \n"+
//				"        decode(a.r_acct_code,'1','모른다','2','기발행','3','등록시발행','4','처리안한다') r_acct_code_nm, \n"+
				"        decode(a.acct_code_st,'1','모른다','2','기발행','3','등록시발행','4','처리안한다') acct_code_st_nm, \n"+
				"        decode(a.p_way,'1','현금지출','2','선불카드','3','후불카드','4','자동이체','5','계좌이체','7','카드할부') way_nm, \n"+
				"        decode(i.p_gubun,'01','자동차대금','06','중고차대금','07','사전계약계약금','08','계약금카드결제','02','영업수당','03','자동차보험료','04','할부금','05','할부금중도상환', \n"+
				"	                      '11','정비비','14','정비비(정산)','15','피해사고공임부가세','16','피해사고부품부가세', '18','피해사고렌트부가세', '19','피해사고유리부가세', \n"+
				"	                      '12','탁송료','13','용품비', '17','검사비', \n"+
				"                         '21','과태료','22','개별소비세','23','자동차세','24','환경개선부담금', '25','취득세', \n"+
				"                         '31','해지정산금환불','32','CMS과출금','33','계약승계보증금','34','대차승계보증금', '35','계약승계보증금환불', '36','연장계약보증금환불', '37','월렌트정산금환불', \n"+
				"	                      '41','법인카드대금','42','법인카드대금(지방세)','43','법인카드대금(지방세)','44','법인카드대금(자동차대금)', '45','법인카드대금(지방세23일)', '46','법인카드대금(선불기타)', '47','법인카드대금(지방세말일결재)', '48','법인카드대금(지방세익월8일결재)', \n"+
				"	                      '51','캠페인포상금','52','제안포상금','53','귀향여비','54','인터넷당직비', '55','당직비', \n"+
				"	                      '60','자금집금','61','이체수수료','99',i.p_st2||decode(nvl(i2.i_cnt,0),'0','','1','','외')) gubun_nm, \n"+
				"        decode(a.p_step,'0','원장등록','1','기안대기','2','문서기안','3','송금요청','4','송금완료','5','회계처리') step_nm, \n"+
				"        to_char(a.reg_dt,'YYYYMMDD') p_reg_dt, \n"+
//				"        decode(a.filename1,'',0,1)+decode(a.filename2,'',0,1)+decode(a.filename3,'',0,1)+decode(a.filename4,'',0,1)+decode(a.filename5,'',0,1) file_cnt,"+
				"        c.user_nm as reg_nm, \n"+
				"        d.user_nm as user_nm1, \n"+
				"        e.user_nm as user_nm2, h3.file_cnt  \n"+
				" from \n"+
				"        pay a, (select * from doc_settle where doc_st='31') b, users c, users d, users e, \n"+
				"        (select * from pay_item where i_seq='1') i, "+
				"        (select reqseq, min(i_seq) i_seq, sum(i_amt) i_amt, count(0) i_cnt from pay_item group by reqseq) i2, \n"+
				"        (select content_seq as reqseq, count(0) file_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='PAY' group by content_seq) h3 "+
				" where \n"+
				"       a.bank_code='"+bank_code+"' and a.off_nm='"+off_nm+"' "+
				"       and a.doc_code=b.doc_id(+)\n"+
				"       and a.reg_id=c.user_id \n"+
				"       and b.user_id1=d.user_id(+) \n"+
				"       and b.user_id2=e.user_id(+) \n"+
				"       and a.reqseq=i.reqseq \n"+
				"       and a.reqseq=i2.reqseq \n"+
				"       and a.reqseq=h3.reqseq(+) "+
				" "; 

		if(!bank_no.equals(""))			query += " and replace(a.bank_no,' ','')=replace('"+bank_no+"',' ','') ";

		if(!a_bank_no.equals(""))		query += " and a.a_bank_no='"+a_bank_no+"' ";

		if(!p_pay_dt.equals(""))		query += " and a.p_pay_dt='"+p_pay_dt+"' ";


		query += " order by i.reqseq";

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
			System.out.println("[PayMngDatabase:getPayActList]"+se);
			System.out.println("[PayMngDatabase:getPayActList]"+query);
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
	 *	송금-출금원장관리
	 */
    public Vector getPayActCarAmtList(String bank_code, String p_pay_dt, String off_nm, String bank_no, String a_bank_no) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select \n"+
				"        a.*, \n"+
				"        i.p_gubun, i.acct_code, i.p_cont, "+
				"        i2.i_seq, nvl(i2.i_amt,0) i_amt, nvl(i2.i_cnt,0) i_cnt, \n"+
				"        decode(a.amt,i2.i_amt,'완결','미완') reg_end, "+
				"        decode(a.reg_st,'D','직접','A','자동','조회') reg_st_nm, \n"+
//				"        decode(a.r_acct_code,'=',i.acct_code,a.r_acct_code) r_acct_code_nm, \n"+
//				"        decode(a.r_acct_code,'1','모른다','2','기발행','3','등록시발행','4','처리안한다') r_acct_code_nm, \n"+
				"        decode(a.acct_code_st,'1','모른다','2','기발행','3','등록시발행','4','처리안한다') acct_code_st_nm, \n"+
				"        decode(a.p_way,'1','현금지출','2','선불카드','3','후불카드','4','자동이체','5','계좌이체','7','카드할부') way_nm, \n"+
				"        decode(i.p_gubun,'01','자동차대금','06','중고차대금','07','사전계약계약금','08','계약금카드결제','02','영업수당','03','자동차보험료','04','할부금','05','할부금중도상환', \n"+
				"	                      '11','정비비','14','정비비(정산)','15','피해사고공임부가세','16','피해사고부품부가세', '18','피해사고렌트부가세', '19','피해사고유리부가세', \n"+
				"	                      '12','탁송료','13','용품비', '17','검사비', \n"+
				"                         '21','과태료','22','개별소비세','23','자동차세','24','환경개선부담금', '25','취득세', \n"+
				"                         '31','해지정산금환불','32','CMS과출금','33','계약승계보증금','34','대차승계보증금', '35','계약승계보증금환불', '36','연장계약보증금환불', '37','월렌트정산금환불', \n"+
				"	                      '41','법인카드대금','42','법인카드대금(지방세)','43','법인카드대금(지방세)','44','법인카드대금(자동차대금)', '45','법인카드대금(지방세23일)', '46','법인카드대금(선불기타)', '47','법인카드대금(지방세말일결재)', '48','법인카드대금(지방세익월8일결재)', \n"+
				"	                      '51','캠페인포상금','52','제안포상금','53','귀향여비','54','인터넷당직비', '55','당직비', \n"+
				"	                      '60','자금집금','61','이체수수료','99',i.p_st2||decode(nvl(i2.i_cnt,0),'0','','1','','외')) gubun_nm, \n"+
				"        decode(a.p_step,'0','원장등록','1','기안대기','2','문서기안','3','송금요청','4','송금완료','5','회계처리') step_nm, \n"+
				"        to_char(a.reg_dt,'YYYYMMDD') p_reg_dt, \n"+
//				"        decode(a.filename1,'',0,1)+decode(a.filename2,'',0,1)+decode(a.filename3,'',0,1)+decode(a.filename4,'',0,1)+decode(a.filename5,'',0,1) file_cnt,"+
				"        c.user_nm as reg_nm, \n"+
				"        d.user_nm as user_nm1, \n"+
				"        e.user_nm as user_nm2, h3.file_cnt  \n"+
				" from \n"+
				"        pay a, (select * from doc_settle where doc_st='31') b, users c, users d, users e, \n"+
				"        (select * from pay_item where i_seq='1') i, "+
				"        (select reqseq, min(i_seq) i_seq, sum(i_amt) i_amt, count(0) i_cnt from pay_item group by reqseq) i2, \n"+
				"        (select content_seq as reqseq, count(0) file_cnt from ACAR_ATTACH_FILE where ISDELETED='N' and content_code='PAY' group by content_seq) h3 "+
				" where \n"+
				"       a.bank_code='"+bank_code+"' and a.off_nm='"+off_nm+"' and a.bank_no='"+bank_no+"' and a.a_bank_no='"+a_bank_no+"' "+
				"       and i.p_gubun='01'"+
				"       and a.doc_code=b.doc_id(+)\n"+
				"       and a.reg_id=c.user_id \n"+
				"       and b.user_id1=d.user_id(+) \n"+
				"       and b.user_id2=e.user_id(+) \n"+
				"       and a.reqseq=i.reqseq \n"+
				"       and a.reqseq=i2.reqseq \n"+
				"       and a.reqseq=h3.reqseq(+) "+
				" "; 

		if(!p_pay_dt.equals(""))		query += " and a.p_pay_dt='"+p_pay_dt+"' ";


		query += " order by i.reqseq";

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

			System.out.println("[자동차대금 은행연동시 알람메시지 발송 목록]"+query);

		}catch(SQLException se){
			System.out.println("[PayMngDatabase:getPayActCarAmtList]"+se);
			System.out.println("[PayMngDatabase:getPayActCarAmtList]"+query);
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
	 *	출금송금관리
	 */
    public Vector getPayRErpTransList() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";
/*
		query = " select \n"+
				"        c.*, \n"+
				"        decode(c.err_code,'','','000','등록','001','상신','002','승인','003','처리전','004','처리중','005','정상','011','승인취소','012','반려_승인','006','확인','016','반려_확인','오류') err_code_nm "+
				" from \n"+
				"        pay_act a, \n"+
				"        (select * from ebank.erp_trans where (actseq,tran_cnt) in (select actseq, max(tran_cnt) tran_cnt from ebank.erp_trans group by actseq)) c "+
				" where \n"+
				"       a.actseq=c.actseq "+
				"       and a.act_bit is null and c.err_code='005' "+
				" "; 
*/

		query = " select \n"+
				"        a.actseq, c.*, \n"+
				"        decode(c.tran_status,'','','00','처리전','01','처리중','02','정상처리','03','처리오류','10','상신','11','확인','12','승인','21','확인자반려','22','승인자반려','20','반려','30','취소','31','상신취소','32','승인취소') tran_status_nm "+
				" from \n"+
				"        pay_act a, \n"+
				"        (select * from ebank.IB_BULK_TRAN where (upche_key,tran_dt_seq) in (select upche_key, max(tran_dt_seq) tran_dt_seq from ebank.IB_BULK_TRAN group by upche_key)) c "+
				" where \n"+
				"       a.act_dt=c.tran_dt and a.actseq=c.upche_key "+
				"       and a.act_bit is null and c.tran_status='02'"+// and c.tran_result_cd='00000000'
				" "; 

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
			System.out.println("[PayMngDatabase:getPayRErpTransList]"+se);
			System.out.println("[PayMngDatabase:getPayRErpTransList]"+query);
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
	 *	송금-출금원장관리
	 */
    public String getActSeqSearch(String bank_code, String p_pay_dt, String off_nm, String bank_no, String a_bank_no) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String actseq = "";
		String query = "";

		query = " select actseq from pay_act where bank_code='"+bank_code+"' and off_nm='"+off_nm+"' and bank_no='"+bank_no+"' and a_bank_no='"+a_bank_no+"' "+
				" "; 

		if(!p_pay_dt.equals(""))		query += " and r_act_dt='"+p_pay_dt+"' ";


	    try{
            pstmt = con.prepareStatement(query);
            rs = pstmt.executeQuery();

			if(rs.next())
			{				
				actseq = rs.getString(1)==null?"":rs.getString(1);
			}
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[PayMngDatabase:getActSeqSearch]"+se);
			System.out.println("[PayMngDatabase:getActSeqSearch]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return actseq;
    }

	/**
	 *	사후결재문서
	 */
    public Vector getPayDoc31LastList() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.doc_no, a.doc_id, to_char(a.user_dt1,'YYYYMMDD') reg_dt, b.user_nm as reg_nm "+
				" from   doc_settle a, users b "+
				" where  a.doc_st='31' and a.doc_step='3' and a.doc_bit<>'3' and to_char(a.user_dt1,'YYYYMMDD')>'20091231' "+
				"        and a.user_id1=b.user_id "+
				" order by a.doc_no ";

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
			System.out.println("[PayMngDatabase:getPayDoc31LastList]"+se);
			System.out.println("[PayMngDatabase:getPayDoc31LastList]"+query);
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
	 *	사후결재문서
	 */
    public Vector getPayDoc31LastList2(String st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.doc_no, a.doc_id, to_char(a.user_dt1,'YYYYMMDD') reg_dt, b.user_nm as reg_nm "+
				" from   doc_settle a, users b, "+
                "        (SELECT a.doc_code FROM PAY a, PAY_ITEM b WHERE a.reqseq=b.reqseq AND b.i_seq=1 ";

		if(st.equals("1")) query += " AND b.p_st2='할부금'";
		if(st.equals("2")) query += " AND b.p_st2='과태료'";
        if(st.equals("3")) query += " AND b.p_st2 NOT IN ('할부금','과태료')";

        query += "         GROUP BY a.doc_code "+
                "        ) c  "+
				" where  a.doc_st='31' and a.doc_step='3' and a.doc_bit<>'3' and to_char(a.user_dt1,'YYYYMMDD')>'20091231' "+
				"        and a.user_id1=b.user_id "+
				"        AND a.doc_id=c.doc_code "+		
				" order by a.doc_no ";

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
			System.out.println("[PayMngDatabase:getPayDoc31LastList2]"+se);
			System.out.println("[PayMngDatabase:getPayDoc31LastList2]"+query);
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
	 *	사후결재문서
	 */
    public Vector getPayDoc32LastList() throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.doc_no, a.doc_id, to_char(a.user_dt1,'YYYYMMDD') reg_dt, b.user_nm as reg_nm "+
				" from   doc_settle a, users b "+
				" where  a.doc_st='32' and a.doc_step='3' and a.doc_bit<>'2' and to_char(a.user_dt1,'YYYYMMDD')>'20091231' "+
				"        and a.user_id1=b.user_id "+
				" order by a.doc_no ";

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
			System.out.println("[PayMngDatabase:getPayDoc32LastList]"+se);
			System.out.println("[PayMngDatabase:getPayDoc32LastList]"+query);
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
	 *	사후결재문서
	 */
    public Vector getPayDoc32LastList2(String st) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.doc_no, a.doc_id, to_char(a.user_dt1,'YYYYMMDD') reg_dt, b.user_nm as reg_nm "+
				" from   doc_settle a, users b, "+
                "        (SELECT a.bank_code FROM PAY a, PAY_ITEM b WHERE a.reqseq=b.reqseq AND b.i_seq=1 ";

		if(st.equals("1")) query += " AND b.p_st2='할부금'";
		if(st.equals("2")) query += " AND b.p_st2='과태료'";
        if(st.equals("3")) query += " AND b.p_st2 NOT IN ('할부금','과태료')";

        query += "         GROUP BY a.bank_code "+
                "        ) c  "+
				" where  a.doc_st='32' and a.doc_step='3' and a.doc_bit<>'2' and to_char(a.user_dt1,'YYYYMMDD')>'20091231' "+
				"        and a.user_id1=b.user_id "+
				"        AND a.doc_id=c.bank_code "+		
				" order by a.doc_no ";

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
			System.out.println("[PayMngDatabase:getPayDoc32LastList2]"+se);
			System.out.println("[PayMngDatabase:getPayDoc32LastList2]"+query);
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
	 *	출금직접등록 중복체크
	 */	
    public int getPayRegChk(PayMngBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " select count(0) as cnt "+
				" from   pay "+
				" where  p_est_dt=? and off_nm=? and amt=? and reg_st='D' and off_st='off_id' ";

	    try{
            pstmt = con.prepareStatement(query);
			pstmt.setString	(1,		bean.getP_est_dt	()); 
			pstmt.setString	(2,		bean.getOff_nm		()); 
			pstmt.setLong 	(3,		bean.getAmt			()); 
            rs = pstmt.executeQuery();    		

			if(rs.next())
			{				
				count = rs.getInt("cnt");
			}
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[PayMngDatabase:getPayRegChk]"+se);
			System.out.println("[PayMngDatabase:getPayRegChk]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }

	/**
	 *	출금직접등록 중복체크
	 */	
    public int getPayRegChk2(PayMngBean bean) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		String query = "";

		query = " select count(0) as cnt "+
				" from   pay "+
				" where  p_est_dt=? and off_nm=? and off_id=? and amt=? and reg_st='D' ";

	    try{
            pstmt = con.prepareStatement(query);
			pstmt.setString	(1,		bean.getP_est_dt	()); 
			pstmt.setString	(2,		bean.getOff_nm		()); 
			pstmt.setString	(3,		bean.getOff_id		()); 
			pstmt.setLong 	(4,		bean.getAmt			()); 
            rs = pstmt.executeQuery();    		

			if(rs.next())
			{				
				count = rs.getInt("cnt");
			}
            rs.close();
            pstmt.close();

        }catch(SQLException se){
			System.out.println("[PayMngDatabase:getPayRegChk2]"+se);
			System.out.println("[PayMngDatabase:getPayRegChk2]"+query);
			 throw new DatabaseException();
        }finally{
            try{
                if(rs != null ) rs.close();
                if(pstmt != null) pstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return count;
    }


	/**********************************************/	
	/*                                            */
	/*        프   로   시   저   호   출         */
	/*                                            */
	/**********************************************/	
	


	/**
     * 프로시져 호출
     */
    public String call_sp_pay_25300_autodocu(String user_nm, String reqseq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		String sResult = "";
        
//    	String query1 = "{CALL P_PAY_25300_AUTODOCU          (?,?,?)}";
    	String query1 = "{CALL P_PAY_25300_AUTODOCU_NEOE     (?,?,?)}";

	    try{

			//회계처리 프로시저1 호출(조회등록)
			cstmt = con.prepareCall(query1);				
			cstmt.setString(1, user_nm);
			cstmt.setString(2, reqseq);
			cstmt.registerOutParameter(3, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값

			cstmt.close();


		}catch(SQLException se){
			System.out.println("[PayMngDatabase:call_sp_pay_25300_autodocu]"+se);
			System.out.println("[PayMngDatabase:call_sp_pay_25300_autodocu]sResult="+sResult);
			 throw new DatabaseException();
        }finally{
            try{
                if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return sResult;
    }

	/**
     * 프로시져 호출
     */
    public String call_sp_pay_account(String user_nm, String pay_code, String doc_type, String doc_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_PAY_ACCOUNT_NEOE     (?,?,?,?,?)}";

    	String query2 = "{CALL P_PAY_ACCOUNT_ETC_NEOE (?,?,?,?,?)}";

    	String query3 = "{CALL P_PAY_RESULT_SEND      (?,?,?,?,?)}";

	    try{

			//회계처리 프로시저1 호출(조회등록)
			cstmt = con.prepareCall(query1);				
			cstmt.setString(1, user_nm);
			cstmt.setString(2, pay_code);
			cstmt.setString(3, doc_type);
			cstmt.setString(4, doc_dt);
			cstmt.registerOutParameter(5, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(5); // 결과값

			//회계처리 프로시저2 호출(직접등록)
			cstmt = con.prepareCall(query2);				
			cstmt.setString(1, user_nm);
			cstmt.setString(2, pay_code);
			cstmt.setString(3, doc_type);
			cstmt.setString(4, doc_dt);
			cstmt.registerOutParameter(5, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(5); // 결과값

			//회계처리 프로시저2 호출(결과안내)
			cstmt = con.prepareCall(query3);				
			cstmt.setString(1, user_nm);
			cstmt.setString(2, pay_code);
			cstmt.setString(3, doc_type);
			cstmt.setString(4, doc_dt);
			cstmt.registerOutParameter(5, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(5); // 결과값

			cstmt.close();

        }catch(SQLException se){
			System.out.println("[PayMngDatabase:call_sp_pay_account]"+se);
			System.out.println("[PayMngDatabase:call_sp_pay_account]sResult="+sResult);
			 throw new DatabaseException();
        }finally{
            try{
                if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return sResult;
    }

	/**
     * 프로시져 호출
     */
    public String call_sp_pay_25300_s_autodocu(String user_nm, String reqseq) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_PAY_25300_S_AUTODOCU_NEOE     (?,?,?)}";

	    try{

			//회계처리 프로시저1 호출(조회등록)
			cstmt = con.prepareCall(query1);				
			cstmt.setString(1, user_nm);
			cstmt.setString(2, reqseq);
			cstmt.registerOutParameter(3, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(3); // 결과값

			cstmt.close();


		}catch(SQLException se){
			System.out.println("[PayMngDatabase:call_sp_pay_25300_s_autodocu]"+se);
			System.out.println("[PayMngDatabase:call_sp_pay_25300_s_autodocu]sResult="+sResult);
			 throw new DatabaseException();
        }finally{
            try{
                if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return sResult;
    }

	/**
     * 프로시져 호출
     */
    public String call_sp_pay_result_send_caramt(String user_nm, String reqseq, String doc_type, String doc_dt) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		String sResult = "";
        
    	String query1 = "{CALL P_PAY_RESULT_SEND_CARAMT (?,?,?,?,?)}";

    	String query2 = "{CALL P_PAY_RESULT_SEND_CARAMT_FAX (?,?,?,?,?)}";

	    try{

			//회계처리 프로시저1 호출(조회등록)
			cstmt = con.prepareCall(query1);				
			cstmt.setString(1, user_nm);
			cstmt.setString(2, reqseq);
			cstmt.setString(3, doc_type);
			cstmt.setString(4, doc_dt);
			cstmt.registerOutParameter(5, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(5); // 결과값

			//회계처리 프로시저1 호출(조회등록)
			cstmt = con.prepareCall(query2);				
			cstmt.setString(1, user_nm);
			cstmt.setString(2, reqseq);
			cstmt.setString(3, doc_type);
			cstmt.setString(4, doc_dt);
			cstmt.registerOutParameter(5, java.sql.Types.VARCHAR );
			cstmt.execute();
			sResult = cstmt.getString(5); // 결과값

			cstmt.close();

        }catch(SQLException se){
			System.out.println("[PayMngDatabase:call_sp_pay_result_send_caramt]"+se);
			System.out.println("[PayMngDatabase:call_sp_pay_result_send_caramt]sResult="+sResult);
			 throw new DatabaseException();
        }finally{
            try{
                if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return sResult;
    }

	/**
	 *	출금송금관리
	 */
    public Vector getPayBankCodeList(String bank_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " select a.* from pay a where a.bank_code='"+bank_code+"'";

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
			System.out.println("[PayMngDatabase:getPayBankCodeList"+se);
			System.out.println("[PayMngDatabase:getPayBankCodeList]"+query);
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
	 *	출금송금관리-사후체크
	 */
    public Vector getPayRCheckList(String s_kd, String t_wd, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.actseq, "+
				"        b.tr_date, b.tr_time, b.tran_ji_acct_nb, a.bank_nm, b.tran_ip_acct_nb, b.tran_memo, b.tran_remittee_nm, b.tran_amt, b.tran_ji_naeyong, "+
				"        c.gubun_nm, c.p_cont, "+
				"        d.conf_st, decode(nvl(d.conf_st,''),'1','확인','2','상시','-') conf_st_nm, c.off_st, nvl(c.client_nm,'') client_nm \n"+
                " FROM   PAY_ACT a, ebank.IB_BULK_TRAN b,  \n"+
                "        (  \n"+
                "          SELECT a.bank_code, a.off_st, a.off_nm, a.bank_no, a.a_bank_no, \n"+
                "                 decode(MIN(b.p_gubun),'01','자동차대금','06','중고차대금','07','사전계약계약금','08','계약금카드결제','02','영업수당','03','자동차보험료','04','할부금','05','할부금중도상환', \n"+
                " 					                    '11','정비비','14','정비비(정산)','15','피해사고공임부가세','16','피해사고부품부가세', '18','피해사고렌트부가세', '19','피해사고유리부가세',  \n"+
                " 					                    '12','탁송료','13','용품비', '17','검사비',  \n"+
                " 				                        '21','과태료','22','개별소비세','23','자동차세','24','환경개선부담금', '25','취득세',  \n"+
                " 				                        '31','해지정산금환불','32','CMS과출금','33','계약승계보증금','34','대차승계보증금', '35','계약승계보증금환불', '36','연장계약보증금환불', '37','월렌트정산금환불',  \n"+
                " 					                    '41','법인카드대금','42','법인카드대금(지방세)','43','법인카드대금(지방세)','44','법인카드대금(자동차대금)', '45','법인카드대금(지방세23일)', '46','법인카드대금(선불기타)', '47','법인카드대금(지방세말일결재)', '48','법인카드대금(지방세익월8일결재)',  \n"+
                " 					                    '51','캠페인포상금','52','제안포상금','53','귀향여비','54','인터넷당직비', '55','당직비',  \n"+
                " 					                    '60','자금집금','61','이체수수료','99',MIN(b.p_st2)||decode(count(0),1,'','외')) gubun_nm,  \n"+
                "                 MIN(b.p_cont)||DECODE(count(0),1,'',' 외') p_cont, min(d.client_nm) client_nm \n"+
                "          FROM   PAY a, PAY_ITEM b, cont c, client d \n"+
                "          WHERE  "+		
				"                 a.p_pay_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')"+
			    "                 AND a.reqseq=b.reqseq and b.p_cd1=c.rent_mng_id(+) and b.p_cd2=c.rent_l_cd(+) and c.client_id=d.client_id(+) \n"+
                "          GROUP BY a.bank_code, a.off_st, a.off_nm, a.bank_no, a.a_bank_no \n"+
                "        ) c, \n"+
				"        (select * from bank_acc where off_st='tran' and seq='1') d "+
                " WHERE  "+
				"        a.r_act_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n"+
                "        AND a.actseq=b.upche_key  \n"+
                "        AND a.bank_code=c.bank_code AND a.off_nm=c.off_nm AND a.bank_no=c.bank_no AND a.a_bank_no=c.a_bank_no \n"+
				"        and a.bank_no=d.off_id(+) "+
				" "; 

		query += " order by decode(nvl(d.conf_st,'0'),'1','3','2','2','1'), b.tr_date, b.tr_time";

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
			System.out.println("[PayMngDatabase:getPayRCheckList]"+se);
			System.out.println("[PayMngDatabase:getPayRCheckList]"+query);
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
	 *	출금송금관리-사후체크
	 */
    public Vector getPayRCheckList2(String s_kd, String t_wd, String st_dt, String end_dt, String gubun1, String gubun2, String gubun3, String gubun4) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT * "+
				" FROM   ( "+

				"          SELECT a.actseq, b.tr_date, b.tr_time, b.tran_ji_acct_nb, a.bank_nm, b.tran_ip_acct_nb, b.tran_memo, b.tran_remittee_nm, b.tran_amt, b.tran_ji_naeyong, "+
				"                 c.gubun_nm, c.p_cont, d.conf_st, decode(nvl(d.conf_st,''),'1','확인','2','상시','-') conf_st_nm,  e.tot_amt  \n"+
                "          FROM   PAY_ACT a, ebank.IB_BULK_TRAN b,  \n"+
                "                 (  \n"+
                "                   SELECT a.bank_code, a.off_nm, a.bank_no, a.a_bank_no, \n"+
                "                          decode(MIN(b.p_gubun),'01','자동차대금','06','중고차대금','07','사전계약계약금','08','계약금카드결제','02','영업수당','03','자동차보험료','04','할부금','05','할부금중도상환', \n"+
                " 					                    '11','정비비','14','정비비(정산)','15','피해사고공임부가세','16','피해사고부품부가세', '18','피해사고렌트부가세', '19','피해사고유리부가세',  \n"+
                " 					                    '12','탁송료','13','용품비', '17','검사비',  \n"+
                " 				                        '21','과태료','22','개별소비세','23','자동차세','24','환경개선부담금', '25','취득세',  \n"+
                " 				                        '31','해지정산금환불','32','CMS과출금','33','계약승계보증금','34','대차승계보증금', '35','계약승계보증금환불', '36','연장계약보증금환불', '37','월렌트정산금환불',  \n"+
                " 					                    '41','법인카드대금','42','법인카드대금(지방세)','43','법인카드대금(지방세)','44','법인카드대금(자동차대금)', '45','법인카드대금(지방세23일)', '46','법인카드대금(선불기타)', '47','법인카드대금(지방세말일결재)', '48','법인카드대금(지방세익월8일결재)',  \n"+
                " 					                    '51','캠페인포상금','52','제안포상금','53','귀향여비','54','인터넷당직비', '55','당직비',  \n"+
                " 					                    '60','자금집금','61','이체수수료','99',MIN(b.p_st2)||decode(count(0),1,'','외')) gubun_nm,  \n"+
                "                          MIN(b.p_cont)||DECODE(count(0),1,'',' 외') p_cont \n"+
                "                   FROM   PAY a, PAY_ITEM b \n"+
                "                   WHERE  "+		
				"                          a.p_pay_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','')"+
			    "                          AND a.reqseq=b.reqseq \n"+
                "                   GROUP BY a.bank_code, a.off_nm, a.bank_no, a.a_bank_no \n"+
                "                 ) c, \n"+
				"                 (select * from bank_acc where off_st='tran' and seq='1') d, "+
			    "                 (SELECT bank_no, SUM(amt) tot_amt FROM PAY_ACT WHERE r_act_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') GROUP BY bank_no) e "+
                "          WHERE  "+
				"                 a.r_act_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') \n"+
                "                 AND a.actseq=b.upche_key  \n"+
                "                 AND a.bank_code=c.bank_code AND a.off_nm=c.off_nm AND a.bank_no=c.bank_no AND a.a_bank_no=c.a_bank_no \n"+
				"                 and a.bank_no=d.off_id(+) "+
				"                 and a.bank_no=e.bank_no "+

				"          UNION ALL \n"+

				"          SELECT '999999999999999' actseq, '' tr_date, '' tr_time, '' tran_ji_acct_nb, '' bank_nm, a.bank_no AS tran_ip_acct_nb, '' tran_memo, '' tran_remittee_nm, TO_CHAR(SUM(a.amt)) tran_amt, '' tran_ji_naeyong, "+
				"                 '' gubun_nm, '' p_cont, min(d.conf_st) conf_st, decode(nvl(min(d.conf_st),''),'1','확인','2','상시','-') conf_st_nm, SUM(a.amt) tot_amt \n"+
				"          FROM   PAY_ACT a, ebank.IB_BULK_TRAN b, "+
				"	              (select a.bank_code, a.off_nm, a.bank_no, a.a_bank_no FROM PAY a, PAY_ITEM b where a.p_pay_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') AND a.reqseq=b.reqseq GROUP BY a.bank_code, a.off_nm, a.bank_no, a.a_bank_no ) c, "+
				" 	              (select * from bank_acc where off_st='tran' and seq='1') d, \n"+
			    "                 (SELECT bank_no, SUM(amt) tot_amt FROM PAY_ACT WHERE r_act_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') GROUP BY bank_no) e "+
				"          WHERE  a.r_act_dt between replace('"+st_dt+"', '-','') and replace('"+end_dt+"', '-','') AND a.a_bank_no='140-004-023871'  \n"+
                "                 AND a.actseq=b.upche_key  \n"+
                "                 AND a.bank_code=c.bank_code AND a.off_nm=c.off_nm AND a.bank_no=c.bank_no AND a.a_bank_no=c.a_bank_no \n"+
				"                 and a.bank_no=d.off_id(+) "+
				"                 and a.bank_no=e.bank_no "+
				"          GROUP BY a.bank_no \n"+ 				 

				"        ) \n"+
				" order by decode(conf_st,'1',1,'2',2,3) desc, tot_amt desc, REPLACE(tran_ip_acct_nb,'-',''), actseq"; 


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
			System.out.println("[PayMngDatabase:getPayRCheckList2]"+se);
			System.out.println("[PayMngDatabase:getPayRCheckList2]"+query);
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
     * 프로시져 호출
     */
    public String call_sp_pay_25300_e_autodocu(String user_nm, String search_code) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		CallableStatement cstmt = null;
		String sResult = "";        
    	String query1 = "{CALL P_PAY_25300_E_AUTODOCU_NEOE (?,?)}";

	    try{
			//회계처리 프로시저1 호출(조회등록)
			cstmt = con.prepareCall(query1);				
			cstmt.setString(1, user_nm);
			cstmt.setString(2, search_code);
			cstmt.execute();
			cstmt.close();
		}catch(SQLException se){
			System.out.println("[PayMngDatabase:call_sp_pay_25300_e_autodocu]"+se);
			System.out.println("[PayMngDatabase:call_sp_pay_25300_e_autodocu]"+user_nm);
			System.out.println("[PayMngDatabase:call_sp_pay_25300_e_autodocu]"+search_code);
			 throw new DatabaseException();
        }finally{
            try{
                if(cstmt != null)	cstmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }
        return sResult;
    }
    
	/**
	 *	직원전기차충전등록 리스트
	 */
    public Vector getPayDirUserList(String user_id) throws DatabaseException, DataSourceEmptyException{
        Connection con = connMgr.getConnection(DATA_SOURCE);//acar
		if(con == null)
	           throw new DataSourceEmptyException("Can't get Connection !!");

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector vt = new Vector();
		String query = "";

		query = " SELECT a.p_cont, b.off_nm, b.amt, b.p_pay_dt\r\n" + 
				"FROM   pay_item a, pay b\r\n" + 
				"WHERE  a.buy_user_id='"+user_id+"' \r\n" + 
				"AND a.p_cont LIKE '%업무용 전기차충전%'\r\n" + 
				"AND a.p_gubun='99' AND a.p_st2='차량유류대' AND a.p_st3='계좌이체'\r\n" + 
				"AND a.reqseq=b.reqseq\r\n" + 
				"ORDER BY b.p_pay_dt DESC"; 


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
			System.out.println("[PayMngDatabase:getPayDirUserList]"+se);
			System.out.println("[PayMngDatabase:getPayDirUserList]"+query);
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