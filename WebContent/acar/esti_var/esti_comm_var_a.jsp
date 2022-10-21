<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String a_a = request.getParameter("a_a")==null?"":request.getParameter("a_a");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int count = 0;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	bean.setA_a			(a_a);
	bean.setSeq			(seq);
	bean.setA_f			(request.getParameter("a_f")==null?0:AddUtil.parseFloat(request.getParameter("a_f")));
	bean.setA_g_1		(request.getParameter("a_g_1")==null?0:AddUtil.parseDigit(request.getParameter("a_g_1"))); //미사용
	bean.setA_g_2		(request.getParameter("a_g_2")==null?0:AddUtil.parseDigit(request.getParameter("a_g_2"))); //미사용
	bean.setA_g_3		(request.getParameter("a_g_3")==null?0:AddUtil.parseDigit(request.getParameter("a_g_3"))); //미사용
	bean.setA_g_4		(request.getParameter("a_g_4")==null?0:AddUtil.parseDigit(request.getParameter("a_g_4"))); //미사용
	bean.setA_g_5		(request.getParameter("a_g_5")==null?0:AddUtil.parseDigit(request.getParameter("a_g_5"))); //미사용
	bean.setA_g_6		(request.getParameter("a_g_6")==null?0:AddUtil.parseDigit(request.getParameter("a_g_6"))); //미사용
	bean.setA_g_7		(request.getParameter("a_g_7")==null?0:AddUtil.parseDigit(request.getParameter("a_g_7"))); //미사용
	bean.setA_j			(request.getParameter("a_j")==null?"":request.getParameter("a_j"));
	bean.setO_8_1		(request.getParameter("o_8_1")==null?0:AddUtil.parseFloat(request.getParameter("o_8_1")));
	bean.setO_8_2		(request.getParameter("o_8_2")==null?0:AddUtil.parseFloat(request.getParameter("o_8_2")));
	bean.setO_9_1		(request.getParameter("o_9_1")==null?0:AddUtil.parseDigit(request.getParameter("o_9_1")));
	bean.setO_9_2		(request.getParameter("o_9_2")==null?0:AddUtil.parseDigit(request.getParameter("o_9_2")));
	bean.setO_10		(request.getParameter("o_10")==null?0:AddUtil.parseFloat(request.getParameter("o_10"))); //미사용
	bean.setO_12		(request.getParameter("o_12")==null?0:AddUtil.parseFloat(request.getParameter("o_12")));
	bean.setO_e			(request.getParameter("o_e")==null?"":request.getParameter("o_e")); //미사용
	bean.setOa_b		(request.getParameter("oa_b")==null?0:AddUtil.parseDigit(request.getParameter("oa_b"))); //미사용
	bean.setOa_c		(request.getParameter("oa_c")==null?0:AddUtil.parseFloat(request.getParameter("oa_c")));
	bean.setG_1			(request.getParameter("g_1")==null?0:AddUtil.parseDigit(request.getParameter("g_1")));
	bean.setG_3			(request.getParameter("g_3")==null?0:AddUtil.parseFloat(request.getParameter("g_3")));
	bean.setG_5			(request.getParameter("g_5")==null?0:AddUtil.parseFloat(request.getParameter("g_5")));
	bean.setG_8			(request.getParameter("g_8")==null?0:AddUtil.parseFloat(request.getParameter("g_8")));
	bean.setG_9_1		(request.getParameter("g_9_1")==null?0:AddUtil.parseFloat(request.getParameter("g_9_1")));
	bean.setG_9_2		(request.getParameter("g_9_2")==null?0:AddUtil.parseFloat(request.getParameter("g_9_2"))); //미사용
	bean.setG_9_3		(request.getParameter("g_9_3")==null?0:AddUtil.parseFloat(request.getParameter("g_9_3"))); //미사용
	bean.setG_9_4		(request.getParameter("g_9_4")==null?0:AddUtil.parseFloat(request.getParameter("g_9_4"))); //미사용
	bean.setG_9_5		(request.getParameter("g_9_5")==null?0:AddUtil.parseFloat(request.getParameter("g_9_5"))); //미사용
	bean.setG_9_6		(request.getParameter("g_9_6")==null?0:AddUtil.parseFloat(request.getParameter("g_9_6"))); //미사용
	bean.setG_9_7		(request.getParameter("g_9_7")==null?0:AddUtil.parseFloat(request.getParameter("g_9_7"))); //미사용
	bean.setG_10		(request.getParameter("g_10")==null?0:AddUtil.parseDigit(request.getParameter("g_10")));
	bean.setG_11_1		(request.getParameter("g_11_1")==null?0:AddUtil.parseFloat(request.getParameter("g_11_1")));
	bean.setG_11_2		(request.getParameter("g_11_2")==null?0:AddUtil.parseFloat(request.getParameter("g_11_2"))); //미사용
	bean.setG_11_3		(request.getParameter("g_11_3")==null?0:AddUtil.parseFloat(request.getParameter("g_11_3"))); //미사용
	bean.setG_11_4		(request.getParameter("g_11_4")==null?0:AddUtil.parseFloat(request.getParameter("g_11_4"))); //미사용
	bean.setG_11_5		(request.getParameter("g_11_5")==null?0:AddUtil.parseFloat(request.getParameter("g_11_5"))); //미사용
	bean.setG_11_6		(request.getParameter("g_11_6")==null?0:AddUtil.parseFloat(request.getParameter("g_11_6"))); //미사용
	bean.setG_11_7		(request.getParameter("g_11_7")==null?0:AddUtil.parseFloat(request.getParameter("g_11_7"))); //미사용
	bean.setCompanys	(request.getParameter("companys")==null?"":request.getParameter("companys")); //미사용
	bean.setQuiry_nm	(request.getParameter("quiry_nm")==null?"":request.getParameter("quiry_nm")); //미사용
	bean.setQuiry_tel	(request.getParameter("quiry_tel")==null?"":request.getParameter("quiry_tel")); //미사용
	bean.setOa_f		(request.getParameter("oa_f")==null?0:AddUtil.parseFloat(request.getParameter("oa_f")));
	bean.setOa_g		(request.getParameter("oa_g")==null?0:AddUtil.parseFloat(request.getParameter("oa_g")));
	bean.setOa_h		(request.getParameter("oa_h")==null?0:AddUtil.parseFloat(request.getParameter("oa_h"))); //미사용	
	bean.setA_y_1		(request.getParameter("a_y_1")==null?0:AddUtil.parseFloat(request.getParameter("a_y_1")));
	bean.setA_y_2		(request.getParameter("a_y_2")==null?0:AddUtil.parseFloat(request.getParameter("a_y_2")));
	bean.setA_y_3		(request.getParameter("a_y_3")==null?0:AddUtil.parseFloat(request.getParameter("a_y_3")));
	bean.setA_y_4		(request.getParameter("a_y_4")==null?0:AddUtil.parseFloat(request.getParameter("a_y_4")));
	bean.setA_y_5		(request.getParameter("a_y_5")==null?0:AddUtil.parseFloat(request.getParameter("a_y_5")));
	bean.setA_y_6		(request.getParameter("a_y_6")==null?0:AddUtil.parseFloat(request.getParameter("a_y_6")));	
	//우량기업 20050325.
	bean.setA_f_w		(request.getParameter("a_f_w")==null?0:AddUtil.parseFloat(request.getParameter("a_f_w"))); //미사용	
	bean.setA_g_1_w		(request.getParameter("a_g_1_w")==null?0:AddUtil.parseDigit(request.getParameter("a_g_1_w"))); //미사용
	bean.setA_g_2_w		(request.getParameter("a_g_2_w")==null?0:AddUtil.parseDigit(request.getParameter("a_g_2_w"))); //미사용
	bean.setA_g_3_w		(request.getParameter("a_g_3_w")==null?0:AddUtil.parseDigit(request.getParameter("a_g_3_w"))); //미사용
	bean.setA_g_4_w		(request.getParameter("a_g_4_w")==null?0:AddUtil.parseDigit(request.getParameter("a_g_4_w"))); //미사용
	bean.setA_g_5_w		(request.getParameter("a_g_5_w")==null?0:AddUtil.parseDigit(request.getParameter("a_g_5_w"))); //미사용
	bean.setA_g_6_w		(request.getParameter("a_g_6_w")==null?0:AddUtil.parseDigit(request.getParameter("a_g_6_w"))); //미사용
	bean.setA_g_7_w		(request.getParameter("a_g_7_w")==null?0:AddUtil.parseDigit(request.getParameter("a_g_7_w"))); //미사용	
	bean.setG_9_11_w	(request.getParameter("g_9_11_w")==null?0:AddUtil.parseFloat(request.getParameter("g_9_11_w"))); //미사용
	//초우량기업 20050511.
	bean.setA_f_uw		(request.getParameter("a_f_uw")==null?0:AddUtil.parseFloat(request.getParameter("a_f_uw"))); //미사용	
	bean.setA_g_1_uw	(request.getParameter("a_g_1_uw")==null?0:AddUtil.parseDigit(request.getParameter("a_g_1_uw"))); //미사용
	bean.setA_g_2_uw	(request.getParameter("a_g_2_uw")==null?0:AddUtil.parseDigit(request.getParameter("a_g_2_uw"))); //미사용
	bean.setA_g_3_uw	(request.getParameter("a_g_3_uw")==null?0:AddUtil.parseDigit(request.getParameter("a_g_3_uw"))); //미사용
	bean.setA_g_4_uw	(request.getParameter("a_g_4_uw")==null?0:AddUtil.parseDigit(request.getParameter("a_g_4_uw"))); //미사용
	bean.setA_g_5_uw	(request.getParameter("a_g_5_uw")==null?0:AddUtil.parseDigit(request.getParameter("a_g_5_uw"))); //미사용
	bean.setA_g_6_uw	(request.getParameter("a_g_6_uw")==null?0:AddUtil.parseDigit(request.getParameter("a_g_6_uw"))); //미사용
	bean.setA_g_7_uw	(request.getParameter("a_g_7_uw")==null?0:AddUtil.parseDigit(request.getParameter("a_g_7_uw"))); //미사용
	bean.setG_9_11_uw	(request.getParameter("g_9_11_uw")==null?0:AddUtil.parseFloat(request.getParameter("g_9_11_uw"))); //미사용
	//우량,초우량 일반식추가. 기존것은 기본식으로 20050823
	bean.setG_11_w		(request.getParameter("g_11_w")==null?0:AddUtil.parseFloat(request.getParameter("g_11_w"))); //미사용
	bean.setG_11_uw		(request.getParameter("g_11_uw")==null?0:AddUtil.parseFloat(request.getParameter("g_11_uw"))); //미사용
	bean.setJg_c_1		(request.getParameter("jg_c_1")==null?0:AddUtil.parseFloat(request.getParameter("jg_c_1")));
	bean.setJg_c_2		(request.getParameter("jg_c_2")==null?0:AddUtil.parseFloat(request.getParameter("jg_c_2")));
	bean.setJg_c_3		(request.getParameter("jg_c_3")==null?0:AddUtil.parseFloat(request.getParameter("jg_c_3")));
	bean.setJg_c_32		(request.getParameter("jg_c_32")==null?0:AddUtil.parseFloat(request.getParameter("jg_c_32")));
	bean.setJg_c_4		(request.getParameter("jg_c_4")==null?0:AddUtil.parseFloat(request.getParameter("jg_c_4")));
	bean.setJg_c_5		(request.getParameter("jg_c_5")==null?0:AddUtil.parseFloat(request.getParameter("jg_c_5")));
	bean.setJg_c_6		(request.getParameter("jg_c_6")==null?0:AddUtil.parseFloat(request.getParameter("jg_c_6")));
	bean.setJg_c_a		(request.getParameter("jg_c_a")==null?0:AddUtil.parseDigit(request.getParameter("jg_c_a"))); //미사용
	bean.setJg_c_b		(request.getParameter("jg_c_b")==null?0:AddUtil.parseDigit(request.getParameter("jg_c_b"))); //미사용
	bean.setJg_c_c		(request.getParameter("jg_c_c")==null?0:AddUtil.parseFloat(request.getParameter("jg_c_c")));
	bean.setJg_c_d		(request.getParameter("jg_c_d")==null?0:AddUtil.parseFloat(request.getParameter("jg_c_d")));
	bean.setJg_c_12		(request.getParameter("jg_c_12")==null?0:AddUtil.parseFloat(request.getParameter("jg_c_12")));
	bean.setO_8_3		(request.getParameter("o_8_3")==null?0:AddUtil.parseFloat(request.getParameter("o_8_3")));
	bean.setO_8_4		(request.getParameter("o_8_4")==null?0:AddUtil.parseFloat(request.getParameter("o_8_4")));
	bean.setO_8_5		(request.getParameter("o_8_5")==null?0:AddUtil.parseFloat(request.getParameter("o_8_5")));
	bean.setO_8_7		(request.getParameter("o_8_7")==null?0:AddUtil.parseFloat(request.getParameter("o_8_7")));
	bean.setO_8_8		(request.getParameter("o_8_8")==null?0:AddUtil.parseFloat(request.getParameter("o_8_8")));
	bean.setO_9_3		(request.getParameter("o_9_3")==null?0:AddUtil.parseDigit(request.getParameter("o_9_3")));
	bean.setO_9_4		(request.getParameter("o_9_4")==null?0:AddUtil.parseDigit(request.getParameter("o_9_4")));
	bean.setO_9_5		(request.getParameter("o_9_5")==null?0:AddUtil.parseDigit(request.getParameter("o_9_5")));
	bean.setO_9_7		(request.getParameter("o_9_7")==null?0:AddUtil.parseDigit(request.getParameter("o_9_7")));
	bean.setO_9_8		(request.getParameter("o_9_8")==null?0:AddUtil.parseDigit(request.getParameter("o_9_8")));
	bean.setJg_c_71		(request.getParameter("jg_c_71")==null?0:AddUtil.parseDigit(request.getParameter("jg_c_71")));
	bean.setJg_c_72		(request.getParameter("jg_c_72")==null?0:AddUtil.parseDigit(request.getParameter("jg_c_72")));
	bean.setJg_c_73		(request.getParameter("jg_c_73")==null?0:AddUtil.parseDigit(request.getParameter("jg_c_73")));
	bean.setJg_c_81		(request.getParameter("jg_c_81")==null?0:AddUtil.parseFloat(request.getParameter("jg_c_81"))); //미사용
	bean.setJg_c_82		(request.getParameter("jg_c_82")==null?0:AddUtil.parseFloat(request.getParameter("jg_c_82"))); //미사용
	bean.setJg_c_9		(request.getParameter("jg_c_9") ==null?0:AddUtil.parseFloat(request.getParameter("jg_c_9")));
	bean.setJg_c_10		(request.getParameter("jg_c_10")==null?0:AddUtil.parseFloat(request.getParameter("jg_c_10")));
	bean.setJg_c_11		(request.getParameter("jg_c_11")==null?0:AddUtil.parseFloat(request.getParameter("jg_c_11")));
	bean.setSh_c_a		(request.getParameter("sh_c_a")==null?0:AddUtil.parseFloat(request.getParameter("sh_c_a")));
	bean.setSh_c_b1		(request.getParameter("sh_c_b1")==null?0:AddUtil.parseFloat(request.getParameter("sh_c_b1"))); //미사용
	bean.setSh_c_b2		(request.getParameter("sh_c_b2")==null?0:AddUtil.parseFloat(request.getParameter("sh_c_b2"))); //미사용
	bean.setSh_c_d1		(request.getParameter("sh_c_d1")==null?0:AddUtil.parseFloat(request.getParameter("sh_c_d1")));
	bean.setSh_c_d2		(request.getParameter("sh_c_d2")==null?0:AddUtil.parseFloat(request.getParameter("sh_c_d2")));
	bean.setA_m_1		(request.getParameter("a_m_1")==null?0:AddUtil.parseFloat(request.getParameter("a_m_1")));
	bean.setA_m_2		(request.getParameter("a_m_2")==null?0:AddUtil.parseFloat(request.getParameter("a_m_2")));
	bean.setSh_a_m_1	(request.getParameter("sh_a_m_1")==null?0:AddUtil.parseFloat(request.getParameter("sh_a_m_1")));
	bean.setSh_a_m_2	(request.getParameter("sh_a_m_2")==null?0:AddUtil.parseFloat(request.getParameter("sh_a_m_2")));
	bean.setSh_p_1		(request.getParameter("sh_p_1")==null?0:AddUtil.parseDigit(request.getParameter("sh_p_1"))); //미사용
	bean.setSh_p_2		(request.getParameter("sh_p_2")==null?0:AddUtil.parseFloat(request.getParameter("sh_p_2"))); //미사용
	bean.setBc_s_i		(request.getParameter("bc_s_i")==null?0:AddUtil.parseFloat(request.getParameter("bc_s_i"))); //미사용
	
	bean.setAx_n		(request.getParameter("ax_n")==null?0:AddUtil.parseFloat(request.getParameter("ax_n"))); //미사용
	bean.setAx_n_c		(request.getParameter("ax_n_c")==null?0:AddUtil.parseFloat(request.getParameter("ax_n_c"))); //미사용
	bean.setAx_p		(request.getParameter("ax_p")==null?0:AddUtil.parseDigit(request.getParameter("ax_p"))); //미사용
	bean.setAx_q		(request.getParameter("ax_q")==null?0:AddUtil.parseFloat(request.getParameter("ax_q")));
	bean.setAx_r_1		(request.getParameter("ax_r_1")==null?0:AddUtil.parseFloat(request.getParameter("ax_r_1"))); //미사용
	bean.setAx_r_2		(request.getParameter("ax_r_2")==null?0:AddUtil.parseFloat(request.getParameter("ax_r_2"))); //미사용
	
	bean.setK_su_1		(request.getParameter("k_su_1")==null?0:AddUtil.parseFloat(request.getParameter("k_su_1")));
	bean.setK_su_2		(request.getParameter("k_su_2")==null?0:AddUtil.parseFloat(request.getParameter("k_su_2")));
	bean.setA_cb_1		(request.getParameter("a_cb_1")==null?0:AddUtil.parseFloat(request.getParameter("a_cb_1")));
	//20150512 사고수리비
	bean.setAccid_a		(request.getParameter("accid_a")==null?0:AddUtil.parseFloat(request.getParameter("accid_a")));
	bean.setAccid_b		(request.getParameter("accid_b")==null?0:AddUtil.parseFloat(request.getParameter("accid_b")));
	bean.setAccid_c		(request.getParameter("accid_c")==null?0:AddUtil.parseFloat(request.getParameter("accid_c")));
	bean.setAccid_d		(request.getParameter("accid_d")==null?0:AddUtil.parseFloat(request.getParameter("accid_d")));
	bean.setAccid_e		(request.getParameter("accid_e")==null?0:AddUtil.parseFloat(request.getParameter("accid_e")));
	bean.setAccid_f		(request.getParameter("accid_f")==null?0:AddUtil.parseFloat(request.getParameter("accid_f")));
	bean.setAccid_g		(request.getParameter("accid_g")==null?0:AddUtil.parseFloat(request.getParameter("accid_g")));
	bean.setAccid_h		(request.getParameter("accid_h")==null?0:AddUtil.parseFloat(request.getParameter("accid_h")));
	bean.setAccid_j		(request.getParameter("accid_j")==null?0:AddUtil.parseFloat(request.getParameter("accid_j")));
	bean.setAccid_k		(request.getParameter("accid_k")==null?0:AddUtil.parseFloat(request.getParameter("accid_k")));
	bean.setAccid_m		(request.getParameter("accid_m")==null?0:AddUtil.parseFloat(request.getParameter("accid_m")));
	bean.setAccid_n		(request.getParameter("accid_n")==null?0:AddUtil.parseFloat(request.getParameter("accid_n")));
	
	bean.setSh_c_k		(request.getParameter("sh_c_k")==null?0:AddUtil.parseFloat(request.getParameter("sh_c_k"))); //미사용
	bean.setSh_c_m		(request.getParameter("sh_c_m")==null?0:AddUtil.parseFloat(request.getParameter("sh_c_m"))); //미사용

	bean.setEcar_tax	(request.getParameter("ecar_tax")==null?0:AddUtil.parseDigit(request.getParameter("ecar_tax")));	
	bean.setEcar_0_yn	(request.getParameter("ecar_0_yn")==null?"":request.getParameter("ecar_0_yn"));
	bean.setEcar_1_yn	(request.getParameter("ecar_1_yn")==null?"":request.getParameter("ecar_1_yn"));
	bean.setEcar_2_yn	(request.getParameter("ecar_2_yn")==null?"":request.getParameter("ecar_2_yn"));
	bean.setEcar_3_yn	(request.getParameter("ecar_3_yn")==null?"":request.getParameter("ecar_3_yn"));
	bean.setEcar_4_yn	(request.getParameter("ecar_4_yn")==null?"":request.getParameter("ecar_4_yn"));
	bean.setEcar_5_yn	(request.getParameter("ecar_5_yn")==null?"":request.getParameter("ecar_5_yn"));
	bean.setEcar_6_yn	(request.getParameter("ecar_6_yn")==null?"":request.getParameter("ecar_6_yn"));
	bean.setEcar_7_yn	(request.getParameter("ecar_7_yn")==null?"":request.getParameter("ecar_7_yn"));
	bean.setEcar_8_yn	(request.getParameter("ecar_8_yn")==null?"":request.getParameter("ecar_8_yn"));
	bean.setEcar_9_yn	(request.getParameter("ecar_9_yn")==null?"":request.getParameter("ecar_9_yn"));
	bean.setEcar_0_amt(request.getParameter("ecar_0_amt")==null?0:AddUtil.parseDigit(request.getParameter("ecar_0_amt")));
	bean.setEcar_1_amt(request.getParameter("ecar_1_amt")==null?0:AddUtil.parseDigit(request.getParameter("ecar_1_amt")));
	bean.setEcar_2_amt(request.getParameter("ecar_2_amt")==null?0:AddUtil.parseDigit(request.getParameter("ecar_2_amt")));
	bean.setEcar_3_amt(request.getParameter("ecar_3_amt")==null?0:AddUtil.parseDigit(request.getParameter("ecar_3_amt")));
	bean.setEcar_4_amt(request.getParameter("ecar_4_amt")==null?0:AddUtil.parseDigit(request.getParameter("ecar_4_amt")));
	bean.setEcar_5_amt(request.getParameter("ecar_5_amt")==null?0:AddUtil.parseDigit(request.getParameter("ecar_5_amt")));
	bean.setEcar_6_amt(request.getParameter("ecar_6_amt")==null?0:AddUtil.parseDigit(request.getParameter("ecar_6_amt")));
	bean.setEcar_7_amt(request.getParameter("ecar_7_amt")==null?0:AddUtil.parseDigit(request.getParameter("ecar_7_amt")));
	bean.setEcar_8_amt(request.getParameter("ecar_8_amt")==null?0:AddUtil.parseDigit(request.getParameter("ecar_8_amt")));
	bean.setEcar_9_amt(request.getParameter("ecar_9_amt")==null?0:AddUtil.parseDigit(request.getParameter("ecar_9_amt")));
	bean.setEcar_bat_cost(request.getParameter("ecar_bat_cost")==null?0:AddUtil.parseDigit(request.getParameter("ecar_bat_cost")));
	
	bean.setEcar_10_yn (request.getParameter("ecar_10_yn")==null?"":request.getParameter("ecar_10_yn"));
	bean.setEcar_10_amt(request.getParameter("ecar_10_amt")==null?0:AddUtil.parseDigit(request.getParameter("ecar_10_amt")));
	
	bean.setHcar_0_amt(request.getParameter("hcar_0_amt")==null?0:AddUtil.parseDigit(request.getParameter("hcar_0_amt")));
	bean.setHcar_1_amt(request.getParameter("hcar_1_amt")==null?0:AddUtil.parseDigit(request.getParameter("hcar_1_amt")));
	bean.setHcar_2_amt(request.getParameter("hcar_2_amt")==null?0:AddUtil.parseDigit(request.getParameter("hcar_2_amt")));
	bean.setHcar_3_amt(request.getParameter("hcar_3_amt")==null?0:AddUtil.parseDigit(request.getParameter("hcar_3_amt")));
	bean.setHcar_4_amt(request.getParameter("hcar_4_amt")==null?0:AddUtil.parseDigit(request.getParameter("hcar_4_amt")));
	bean.setHcar_5_amt(request.getParameter("hcar_5_amt")==null?0:AddUtil.parseDigit(request.getParameter("hcar_5_amt")));
	bean.setHcar_6_amt(request.getParameter("hcar_6_amt")==null?0:AddUtil.parseDigit(request.getParameter("hcar_6_amt")));
	bean.setHcar_7_amt(request.getParameter("hcar_7_amt")==null?0:AddUtil.parseDigit(request.getParameter("hcar_7_amt")));
	bean.setHcar_8_amt(request.getParameter("hcar_8_amt")==null?0:AddUtil.parseDigit(request.getParameter("hcar_8_amt")));
	bean.setHcar_9_amt(request.getParameter("hcar_9_amt")==null?0:AddUtil.parseDigit(request.getParameter("hcar_9_amt")));
	bean.setHcar_cost	(request.getParameter("hcar_cost")==null?0:AddUtil.parseDigit(request.getParameter("hcar_cost")));
	
	bean.setA_f_2		(request.getParameter("a_f_2")==null?0:AddUtil.parseFloat(request.getParameter("a_f_2")));
	bean.setA_f_3		(request.getParameter("a_f_3")==null?0:AddUtil.parseFloat(request.getParameter("a_f_3")));
	bean.setOa_extra	(request.getParameter("oa_extra")==null?0:AddUtil.parseFloat(request.getParameter("oa_extra")));
	bean.setOa_g_1		(request.getParameter("oa_g_1")==null?0:AddUtil.parseFloat(request.getParameter("oa_g_1")));
	bean.setOa_g_2		(request.getParameter("oa_g_2")==null?0:AddUtil.parseFloat(request.getParameter("oa_g_2")));
	bean.setOa_g_3		(request.getParameter("oa_g_3")==null?0:AddUtil.parseFloat(request.getParameter("oa_g_3")));
	bean.setOa_g_4		(request.getParameter("oa_g_4")==null?0:AddUtil.parseFloat(request.getParameter("oa_g_4")));
	bean.setOa_g_5		(request.getParameter("oa_g_5")==null?0:AddUtil.parseFloat(request.getParameter("oa_g_5")));
	bean.setOa_g_6		(request.getParameter("oa_g_6")==null?0:AddUtil.parseFloat(request.getParameter("oa_g_6")));
	bean.setOa_g_7		(request.getParameter("oa_g_7")==null?0:AddUtil.parseFloat(request.getParameter("oa_g_7")));
	
	//20200623 재리스지점간 이동 탁송료
	bean.setBr_cons_00(request.getParameter("br_cons_00")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_00")));
	bean.setBr_cons_01(request.getParameter("br_cons_01")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_01")));
	bean.setBr_cons_02(request.getParameter("br_cons_02")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_02")));
	bean.setBr_cons_03(request.getParameter("br_cons_03")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_03")));
	bean.setBr_cons_04(request.getParameter("br_cons_04")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_04")));
	bean.setBr_cons_10(request.getParameter("br_cons_10")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_10")));
	bean.setBr_cons_11(request.getParameter("br_cons_11")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_11")));
	bean.setBr_cons_12(request.getParameter("br_cons_12")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_12")));
	bean.setBr_cons_13(request.getParameter("br_cons_13")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_13")));
	bean.setBr_cons_14(request.getParameter("br_cons_14")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_14")));
	bean.setBr_cons_20(request.getParameter("br_cons_20")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_20")));
	bean.setBr_cons_21(request.getParameter("br_cons_21")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_21")));
	bean.setBr_cons_22(request.getParameter("br_cons_22")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_22")));
	bean.setBr_cons_23(request.getParameter("br_cons_23")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_23")));
	bean.setBr_cons_24(request.getParameter("br_cons_24")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_24")));
	bean.setBr_cons_30(request.getParameter("br_cons_30")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_30")));
	bean.setBr_cons_31(request.getParameter("br_cons_31")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_31")));
	bean.setBr_cons_32(request.getParameter("br_cons_32")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_32")));
	bean.setBr_cons_33(request.getParameter("br_cons_33")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_33")));
	bean.setBr_cons_34(request.getParameter("br_cons_34")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_34")));
	bean.setBr_cons_40(request.getParameter("br_cons_40")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_40")));
	bean.setBr_cons_41(request.getParameter("br_cons_41")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_41")));
	bean.setBr_cons_42(request.getParameter("br_cons_42")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_42")));
	bean.setBr_cons_43(request.getParameter("br_cons_43")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_43")));
	bean.setBr_cons_44(request.getParameter("br_cons_44")==null?0:AddUtil.parseDigit(request.getParameter("br_cons_44")));
	
	bean.setCar_maint_amt1	(request.getParameter("car_maint_amt1")==null?0:AddUtil.parseDigit(request.getParameter("car_maint_amt1")));
	bean.setCar_maint_amt2	(request.getParameter("car_maint_amt2")==null?0:AddUtil.parseDigit(request.getParameter("car_maint_amt2")));
	bean.setCar_maint_amt3	(request.getParameter("car_maint_amt3")==null?0:AddUtil.parseDigit(request.getParameter("car_maint_amt3")));
	bean.setTint_b_amt		(request.getParameter("tint_b_amt")==null?0:AddUtil.parseDigit(request.getParameter("tint_b_amt")));
	bean.setTint_s_amt		(request.getParameter("tint_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("tint_s_amt")));
	bean.setTint_n_amt		(request.getParameter("tint_n_amt")==null?0:AddUtil.parseDigit(request.getParameter("tint_n_amt")));
	bean.setTint_eb_amt		(request.getParameter("tint_eb_amt")==null?0:AddUtil.parseDigit(request.getParameter("tint_eb_amt")));
	bean.setTint_bn_amt		(request.getParameter("tint_bn_amt")==null?0:AddUtil.parseDigit(request.getParameter("tint_bn_amt")));
	bean.setLegal_amt		(request.getParameter("legal_amt")==null?0:AddUtil.parseDigit(request.getParameter("legal_amt")));
	bean.setCar_maint_amt4	(request.getParameter("car_maint_amt4")==null?0:AddUtil.parseDigit(request.getParameter("car_maint_amt4")));
	
	
	if(cmd.equals("i") || cmd.equals("up")){
		seq = e_db.insertEstiCommVar(bean);
	}else if(cmd.equals("u")){
		count = e_db.updateEstiCommVar(bean);
	}
%>
<html>
<head>

<title>차종</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="esti_comm_var_i.jsp" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">        
  <input type="hidden" name="a_a" value="<%=a_a%>">          
  <input type="hidden" name="seq" value="<%=seq%>">          
  <input type="hidden" name="cmd" value="u">
</form>
<script>
<%	if(cmd.equals("u")){
		if(count==1){%>
		alert("정상적으로 수정되었습니다.");
		document.form1.target='d_content';
		document.form1.submit();		
<%		}else{%>
		alert("에러발생!");
<%		}
	}else{
		if(!seq.equals("")){%>
		alert("정상적으로 등록되었습니다.");
		document.form1.target='d_content';
		document.form1.submit();		
<%		}else{%>
		alert("에러발생!");
<%		}
	}	%>
</script>
</body>
</html>
