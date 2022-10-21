<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.settle_acc.*, acar.cont.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.car_sche.*, acar.accid.*, acar.ext.*, acar.forfeit_mng.*, acar.con_ins_m.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");	
	String gubun1 = request.getParameter("gubun1")==null?"7":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String today = request.getParameter("today")==null?AddUtil.getDate():request.getParameter("today");
	
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	String page_st = request.getParameter("page_st")==null?"":request.getParameter("page_st");
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_bit	 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	
	String bad_debt_cau	= request.getParameter("bad_debt_cau")==null?"":request.getParameter("bad_debt_cau");
	String bad_debt_st 	= request.getParameter("bad_debt_st")==null?"":request.getParameter("bad_debt_st");
	String reject_cau 	= request.getParameter("reject_cau")==null?"":request.getParameter("reject_cau");
	int    bad_amt		= request.getParameter("bad_amt")==null?0:AddUtil.parseInt(request.getParameter("bad_amt"));
	int    seq			= request.getParameter("seq")==null?0:AddUtil.parseInt(request.getParameter("seq"));
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	int count = 0;
	
	
	
	
	AddCarAccidDatabase a_cad = AddCarAccidDatabase.getInstance();
	
	
	//요청내용 및 처리구분 관리
	BadDebtReqBean bad_debt = a_db.getBadDebtReq(m_id, l_cd, seq);
	
	
			String vid1[] 		= request.getParameterValues("item_gubun");
			String vid2[] 		= request.getParameterValues("item_cd1");
			String vid3[] 		= request.getParameterValues("item_cd2");
			String vid4[] 		= request.getParameterValues("item_cd3");
			String vid5[] 		= request.getParameterValues("item_cd4");
			String vid6[] 		= request.getParameterValues("item_cd5");
			
			for(int j=0;j < vid1.length;j++){
				
				if(vid1[j].equals("보증금") || vid1[j].equals("선납금") || vid1[j].equals("개시대여료") || vid1[j].equals("승계수수료") || vid1[j].equals("해지정산금") || vid1[j].equals("면책금") || vid1[j].equals("대차료")){
					
					String e_rent_st 	= vid2[j];
					String e_ext_st 	= vid3[j];
					String e_ext_tm 	= vid4[j];
					String e_ext_id 	= vid5[j];
					
					flag4 = s_db.updateBadDebtExt(ck_acar_id, m_id, l_cd, e_rent_st, e_ext_st, e_ext_tm);
					
				}else if(vid1[j].equals("과태료")){
					
					String f_car_mng_id = vid2[j];
					String f_seq_no	 	= vid3[j];
					String f_m_id	 	= vid4[j];
					String f_l_cd	 	= vid5[j];
					
					flag4 = s_db.updateBadDebtFine(ck_acar_id, f_m_id, f_l_cd, f_car_mng_id, AddUtil.parseInt(f_seq_no));
					
				}
			}
			
			//대손채권관련 메모에 넣기
			InsMemoBean memo = new InsMemoBean();
			memo.setRent_mng_id	(m_id);
			memo.setRent_l_cd	(l_cd);
			memo.setCar_mng_id	(c_id);
			memo.setTm_st		("9");
			memo.setAccid_id	("종료");
			memo.setServ_id		("");
			memo.setSeq			("");
			memo.setReg_id		(ck_acar_id);	// cookie세팅
			memo.setReg_dt		(AddUtil.getDate());
			memo.setContent		("소액채권 대손처리 요청 처리");
			memo.setSpeaker		("");
			
			flag5 = a_cad.insertInsMemo(memo);
	
	
	bad_debt.setBus_id2_cng_yn	("Y");				//변경여부
	bad_debt.setCng_id			(ck_acar_id);		//변경자
	
	flag2 = a_db.updateBadDebtReqBusid2Cng(bad_debt);
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<form name='form1' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='page_st' value='<%=page_st%>'>
<input type='hidden' name="doc_no" 	value="<%=doc_no%>">		
<input type='hidden' name="seq" 	value="<%=seq%>">		
</form>
<script language='javascript'>
<%	if(flag1){	%>		
	var fm = document.form1;	
	fm.action = 'bad_debt_doc.jsp';
	fm.target = 'd_content';
	fm.submit();
	
	parent.self.window.close();
	
<%	}else{	%>
		alert('데이터베이스 에러입니다.\n\n등록되지 않았습니다');		
<%	}	%>
</script>
<body>
</body>
</html>