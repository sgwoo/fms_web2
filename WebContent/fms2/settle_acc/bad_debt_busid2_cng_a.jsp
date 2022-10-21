<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.car_sche.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
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
	int result = 0;
	int count = 0;
	
	
	
	
	
	//요청내용 및 처리구분 관리
	BadDebtReqBean bad_debt = a_db.getBadDebtReq(m_id, l_cd, seq);
	
	LcRentCngHBean bean = new LcRentCngHBean();
	
	bean.setRent_mng_id	(m_id);
	bean.setRent_l_cd	(l_cd);
	bean.setCng_item	("bus_id2");
	bean.setOld_value	(bad_debt.getOld_bus_id2());
	bean.setNew_value	(bad_debt.getNew_bus_id2());
	bean.setCng_cau		("소액채권대손처리요청");
	bean.setCng_id		(ck_acar_id);
	bean.setRent_st		("");
	bean.setS_amt		(0);
	bean.setV_amt		(0);
	
	flag1 = a_db.updateLcRentCngH(bean);
	
	
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