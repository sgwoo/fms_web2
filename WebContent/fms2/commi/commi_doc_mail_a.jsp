<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.user_mng.*, tax.*, acar.im_email.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String emp_email 	= request.getParameter("emp_email")==null?"":request.getParameter("emp_email");
	String emp_m_tel 	= request.getParameter("emp_m_tel")==null?"":request.getParameter("emp_m_tel");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	
	//영업수당+영업소 담당자
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	
	//영업사원
	coe_bean = cod.getCarOffEmpBean(emp1.getEmp_id());
%>


<%
	String subject 		= emp1.getEmp_nm()+"님, (주)아마존카 영업수당 지급내역입니다.";
	String msg 			= emp1.getEmp_nm()+"님, (주)아마존카 영업수당이 지급되었습니다.";
	String sendname 	= "(주)아마존카";
	String sendphone 	= "02-392-4243";
	int seqidx			= 0;
	
	if(!emp_email.equals("")){
		//	1. d-mail 등록-------------------------------
		DmailBean d_bean = new DmailBean();
		d_bean.setSubject			(subject);
		d_bean.setSql				("SSV:"+emp_email.trim());
		d_bean.setReject_slist_idx	(0);
		d_bean.setBlock_group_idx	(0);
		d_bean.setMailfrom			("\"아마존카\"<tax@amazoncar.co.kr>");
		d_bean.setMailto			("\""+emp1.getEmp_nm()+"\"<"+emp_email.trim()+">");
		d_bean.setReplyto			("\"아마존카\"<tax@amazoncar.co.kr>");
		d_bean.setErrosto			("\"아마존카\"<tax@amazoncar.co.kr>");
		d_bean.setHtml				(1);
		d_bean.setEncoding			(0);
		d_bean.setCharset			("euc-kr");
		d_bean.setDuration_set		(1);
		d_bean.setClick_set			(0);
		d_bean.setSite_set			(0);
		d_bean.setAtc_set			(0);
		d_bean.setGubun				(rent_l_cd+"commi");
		d_bean.setRname				("mail");
		d_bean.setMtype       		(0);
		d_bean.setU_idx       		(1);//admin계정
		d_bean.setG_idx				(1);//admin계정
		d_bean.setMsgflag     		(0);
		d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/s_man/c_trans.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd);
		
		seqidx = ImEmailDb.insertDEmail2(d_bean, "4", "", "+7");
	}
	
	if(!emp_m_tel.equals("")){
		//2. SMS 등록-------------------------------
		IssueDb.insertsendMail(sendphone, sendname, emp_m_tel, emp1.getEmp_nm(), "", "+0.05", msg);
	}
	
	if(seqidx >0){
		emp1.setSeqidx(String.valueOf(seqidx));
		//=====[commi] update=====
		flag1 = a_db.updateCommiNew(emp1);
		out.println("영업수당정보 수정<br>");
	}
	%>
<script language='javascript'>
<%		if(!emp_email.equals("") && seqidx == 0){	%>		alert('영업수당메일 발송 에러입니다.\n\n확인하십시오');		<%		}	%>
<%		if(!flag1){	%>										alert('영업수당 수정 에러입니다.\n\n확인하십시오');			<%		}	%>
</script>

<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="doc_no" 			value="<%=doc_no%>">
  <input type='hidden' name='gubun1'  			value='<%=gubun1%>'>    
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = 'commi_doc_u.jsp';
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>