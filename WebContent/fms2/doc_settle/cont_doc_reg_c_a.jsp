<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_office.*, acar.res_search.*, acar.ext.*, acar.doc_settle.*"%>
<%@ page import="acar.user_mng.*, acar.car_sche.*, acar.fee.*, acar.insur.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String m_id		 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String l_cd		 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	
	String c_id 		= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	
	UserMngDatabase umd 	= UserMngDatabase.getInstance();
	InsDatabase ins_db 		= InsDatabase.getInstance();
	
	String cng_dt 	= request.getParameter("cng_dt")	==null?"":request.getParameter("cng_dt");
	String cng_etc 	= request.getParameter("cng_etc")	==null?"":request.getParameter("cng_etc");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	String doc_no 		= "";
	String ch_before 	= "";
	String ch_after 	= "";
	String reg_code  	= Long.toString(System.currentTimeMillis());
	
	//처리상태
	int flag = 0;
	
	if(c_id.equals("")){
		c_id = "AAAAAA";
	}
	

	
	String u_chk = request.getParameter("u_chk")			==null?"":request.getParameter("u_chk");
	
	String value01 = request.getParameter("value01")		==null?"":request.getParameter("value01");
	String value02 = request.getParameter("value02")		==null?"":request.getParameter("value02");
	String value03 = request.getParameter("value03")	==null?"":request.getParameter("value03");
	String value04 = request.getParameter("value04")	==null?"":request.getParameter("value04");
	String value05 = request.getParameter("value05")		==null?"":request.getParameter("value05");	
	String value06 = request.getParameter("value06")		==null?"":request.getParameter("value06");	
	
	InsurChangeBean d_bean = new InsurChangeBean();
	d_bean.setIns_doc_no		(reg_code);
	d_bean.setCar_mng_id		(c_id);
	d_bean.setIns_st				("0");
	d_bean.setCh_dt					(cng_dt);
	d_bean.setCh_etc				(cng_etc);
	d_bean.setUpdate_id			(user_id);
	d_bean.setRent_mng_id		(rent_mng_id);
	d_bean.setRent_l_cd			(rent_l_cd);
	d_bean.setRent_st				(rent_st);
	d_bean.setDoc_st				("4");

	if(!ins_db.insertInsChangeDoc(d_bean)) flag += 1;
	
	if(value03.equals("")) value03 = " ";

	ch_after 	= value01+"||"+value02+"||"+value03+"||"+value04+"||"+value05+"||"+value06;
	
	CarMgrBean mgr = a_db.getCarMgr(rent_mng_id, rent_l_cd, "차량이용자");
	
	ch_before 	= mgr.getMgr_nm()+"||"+mgr.getMgr_title()+"||"+mgr.getMgr_tel()+"||"+mgr.getMgr_m_tel()+"||"+mgr.getLic_no()+"||"+mgr.getMgr_email();
	
	InsurChangeBean bean = new InsurChangeBean();
	bean.setIns_doc_no		(reg_code);
	bean.setCar_mng_id		(c_id);
	bean.setCh_tm					("0");
	bean.setCh_dt					(cng_dt);
	bean.setCh_amt				(0);
	bean.setUpdate_id			(user_id);
	bean.setRent_mng_id		(rent_mng_id);
	bean.setRent_l_cd			(rent_l_cd);
	bean.setCh_item				("차량이용자");
	bean.setCh_before			(ch_before);
	bean.setCh_after			(ch_after.trim());
	
	if(!ins_db.insertInsChangeDocList(bean)) flag += 1;
	
	
	//보험변경리스트
	Vector ins_cha = ins_db.getInsChangeDocList(reg_code);
	int ins_cha_size = ins_cha.size();
	
	if(ins_cha_size >0){
	
		boolean flag6 = true;
		
		
				
		
		//문서기안
		String firm_nm	= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
		
		String sub 	= "계약변경요청문서 품의";
		String cont 	= "["+firm_nm+"] 계약변경문서를 등록하였으니 결재바랍니다.";
		
		DocSettleBean doc = new DocSettleBean();
		doc.setDoc_st		("42");
		doc.setDoc_id		(reg_code);
		doc.setSub			(sub);
		doc.setCont			(cont);
		doc.setEtc			(cng_etc);
		doc.setUser_nm1	("기안자");
		doc.setUser_nm2	("");
		doc.setUser_nm3	("");
		doc.setUser_nm4	("");
		doc.setUser_nm5	("");
		doc.setUser_id1	(user_id);
		doc.setDoc_bit	("0");
		doc.setDoc_step	("0");//기안
		
		//=====[doc_settle] insert=====
		flag6 = d_db.insertDocSettle2(doc);
		
		doc = d_db.getDocSettleCommi("42", reg_code);
		
		doc_no = doc.getDoc_no();

	}
%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="rent_st" 			value="<%=rent_st%>">   
  <input type='hidden' name="c_id" 				value="<%=c_id%>">
  <input type="hidden" name="doc_no" 			value="<%=doc_no%>">       
</form>
<script language='javascript'>
<%	if(flag > 0){%>
		alert("등록하지 않았습니다.");
<%	}else{		%>		
		alert("등록되었습니다.");
		var fm = document.form1;
		fm.target='d_content';
		fm.action='cont_doc_frame.jsp';
		fm.submit();
		window.close();
<%	}			%>
</script>
</body>
</html>