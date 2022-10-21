<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.insa_card.*"%>
<jsp:useBean id="sc_bean" scope="page" class="acar.insa_card.Insa_ScBean"/>  
<jsp:useBean id="ib_bean" scope="page" class="acar.insa_card.Insa_IbBean"/>  
<jsp:useBean id="sb_bean" scope="page" class="acar.insa_card.Insa_SbBean"/>  
<jsp:useBean id="fy_bean" scope="page" class="acar.insa_card.Insa_FyBean"/>  
<jsp:useBean id="sw_bean" scope="page" class="acar.insa_card.Insa_SwBean"/>  
<jsp:useBean id="wk_bean" scope="page" class="acar.insa_card.Insa_WkBean"/>  		
<jsp:useBean id="ls_bean" scope="page" class="acar.insa_card.Insa_LsBean"/>	
<jsp:useBean id="jg_bean" scope="page" class="acar.insa_card.Insa_JGBean"/>	
<%@ include file="/acar/cookies.jsp" %>
<%

	//중복되는 변수
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String st 	= request.getParameter("st")==null?"":request.getParameter("st");
	
	String cmd	= request.getParameter("cmd")==null?"":request.getParameter("cmd");

	String from_page	= request.getParameter("from_page")==null?"":request.getParameter("from_page");  
 	
	//insa_school
	String sc_gubun = request.getParameter("sc_gubun")==null?"":request.getParameter("sc_gubun");
	String sc_ed_dt = request.getParameter("sc_ed_dt")==null?"":request.getParameter("sc_ed_dt");
	String sc_name = request.getParameter("sc_name")==null?"":request.getParameter("sc_name");
	String sc_study = request.getParameter("sc_study")==null?"":request.getParameter("sc_study");
	String sc_st = request.getParameter("sc_st")==null?"":request.getParameter("sc_st");
	
	//insa_ib
	String ib_dt = request.getParameter("ib_dt")==null?"":request.getParameter("ib_dt");
	String ib_gubun = request.getParameter("ib_gubun")==null?"":request.getParameter("ib_gubun");
	String ib_content = request.getParameter("ib_content")==null?"":request.getParameter("ib_content");
	String ib_job = request.getParameter("ib_job")==null?"":request.getParameter("ib_job");
	String ib_type = request.getParameter("ib_type")==null?"":request.getParameter("ib_type"); // 1:직군변경, 2:부서변경
	String ib_dept = request.getParameter("ib_dept")==null?"":request.getParameter("ib_dept");  //부서
	
	//insa_sb
	String sb_dt = request.getParameter("sb_dt")==null?"":request.getParameter("sb_dt");
	String sb_gubun = request.getParameter("sb_gubun")==null?"":request.getParameter("sb_gubun");
	String sb_content = request.getParameter("sb_content")==null?"":request.getParameter("sb_content");
	String sb_js_dt = request.getParameter("sb_js_dt")==null?"":request.getParameter("sb_js_dt");
	String sb_je_dt = request.getParameter("sb_je_dt")==null?"":request.getParameter("sb_je_dt");
	
	//insa_fy
	String fy_gubun = request.getParameter("fy_gubun")==null?"":request.getParameter("fy_gubun");
	String fy_name = request.getParameter("fy_name")==null?"":request.getParameter("fy_name");
	String fy_birth = request.getParameter("fy_birth")==null?"":request.getParameter("fy_birth");
	String fy_age = request.getParameter("fy_age")==null?"":request.getParameter("fy_age");
		
	//insa_sw
	String sw_gubun = request.getParameter("sw_gubun")==null?"":request.getParameter("sw_gubun");
	String sw_name = request.getParameter("sw_name")==null?"":request.getParameter("sw_name");
	String sw_ssn = request.getParameter("sw_ssn")==null?"":request.getParameter("sw_ssn");
	String sw_addr = request.getParameter("sw_addr")==null?"":request.getParameter("sw_addr");
	String sw_tel = request.getParameter("sw_tel")==null?"":request.getParameter("sw_tel");
	String sw_my_gubun = request.getParameter("sw_my_gubun")==null?"":request.getParameter("sw_my_gubun");
	String sw_st_dt = request.getParameter("sw_st_dt")==null?"":request.getParameter("sw_st_dt");
	String sw_ed_dt = request.getParameter("sw_ed_dt")==null?"":request.getParameter("sw_ed_dt");
	String sw_up_dt = request.getParameter("sw_up_dt")==null?"":request.getParameter("sw_up_dt");
	String sw_insu_nm = request.getParameter("sw_insu_nm")==null?"":request.getParameter("sw_insu_nm");
	String sw_insu_no = request.getParameter("sw_insu_no")==null?"":request.getParameter("sw_insu_no");
	String sw_insu_money = request.getParameter("sw_insu_money")==null?"":request.getParameter("sw_insu_money");
	
	//insa_wk
	String wk_st_dt = request.getParameter("wk_st_dt")==null?"":request.getParameter("wk_st_dt");
	String wk_ed_dt = request.getParameter("wk_ed_dt")==null?"":request.getParameter("wk_ed_dt");
	String wk_name = request.getParameter("wk_name")==null?"":request.getParameter("wk_name");
	String wk_pos = request.getParameter("wk_pos")==null?"":request.getParameter("wk_pos");
	String wk_work = request.getParameter("wk_work")==null?"":request.getParameter("wk_work");
	String wk_emp = request.getParameter("wk_emp")==null?"":request.getParameter("wk_emp");	
	String wk_title = request.getParameter("wk_title")==null?"":request.getParameter("wk_title");	
		
	//insa_ls
	String ls_dt = request.getParameter("ls_dt")==null?"":request.getParameter("ls_dt");
	String ls_name = request.getParameter("ls_name")==null?"":request.getParameter("ls_name");
	String ls_num = request.getParameter("ls_num")==null?"":request.getParameter("ls_num");
	String ls_bmng = request.getParameter("ls_bmng")==null?"":request.getParameter("ls_bmng");
	
	//insa_jg
	String jg_dt = request.getParameter("jg_dt")==null?"":request.getParameter("jg_dt");
	String br_dt = request.getParameter("br_dt")==null?"":request.getParameter("br_dt");
	String pos = request.getParameter("pos")==null?"":request.getParameter("pos");  //진급 -직급
	String note = request.getParameter("note")==null?"":request.getParameter("note");
	
	int count = 0;
		
	InsaCardDatabase icd = InsaCardDatabase.getInstance();	

if(cmd.equals("sc")){
	sc_bean.setUser_id(user_id);
	sc_bean.setSeq(seq);
	sc_bean.setSc_gubun(sc_gubun);
	sc_bean.setSc_ed_dt(sc_ed_dt);
	sc_bean.setSc_name(sc_name);
	sc_bean.setSc_study(sc_study);
	sc_bean.setSc_st(sc_st);
	
	count = icd.insertSchool(sc_bean);
	
}else if(cmd.equals("ib")){
	ib_bean.setUser_id(user_id);
	ib_bean.setSeq(seq);
	ib_bean.setIb_dt(ib_dt);
	ib_bean.setIb_gubun(ib_gubun);
	ib_bean.setIb_content(ib_content);
	ib_bean.setIb_job(ib_job);
	ib_bean.setIb_type(ib_type);
	ib_bean.setIb_dept(ib_dept);
	
	count = icd.insertIb(ib_bean); //user_info 테이블도 변경 
			
	if ( ib_type.equals("1")) {  //직군변경
		 // ib_job 1:1군, 2:2군, 3:내근직 (users의 loan_st 수정 )
		count = icd.updateUserLoanSt(user_id, ib_job); //user_info 테이블도 변경 
	} else {   //부서변경  
		//(users의 dept_id, br_id 수정)
		count = icd.updateUserDeptId(user_id, ib_dept ); //user_info 테이블도 변경		
		//부서이동 연동 프로시져 호출
			
		String  flag =  icd.call_sp_make_pl_user(ib_dt.substring(0,4), ib_dt.substring(5,7) , "1", user_id );
		
		System.out.println("부서변경 프로시져호출 ="+flag);
		
	}
			
}else if(cmd.equals("sb")){
	sb_bean.setUser_id(user_id);
	sb_bean.setSeq(seq);
	sb_bean.setSb_dt(sb_dt);
	sb_bean.setSb_gubun(sb_gubun);
	sb_bean.setSb_content(sb_content);
	sb_bean.setSb_js_dt(sb_js_dt);
	sb_bean.setSb_je_dt(sb_je_dt);

	count = icd.insertSb(sb_bean);
	
}else if(cmd.equals("fy")){
	fy_bean.setUser_id(user_id);
	fy_bean.setSeq(seq);
	fy_bean.setFy_gubun(fy_gubun);
	fy_bean.setFy_name(fy_name);
	fy_bean.setFy_birth(fy_birth);
//	fy_bean.setFy_age(fy_age);
	
	count = icd.insertFy(fy_bean);
	
}else if(cmd.equals("sw")){
	sw_bean.setUser_id(user_id);
	sw_bean.setSeq(seq);
	sw_bean.setSw_gubun(sw_gubun);
	sw_bean.setSw_name(sw_name);
	sw_bean.setSw_ssn(sw_ssn);
	sw_bean.setSw_addr(sw_addr);
	sw_bean.setSw_tel(sw_tel);
	sw_bean.setSw_my_gubun(sw_my_gubun);
	sw_bean.setSw_st_dt(sw_st_dt);
	sw_bean.setSw_ed_dt(sw_ed_dt);
	sw_bean.setSw_up_dt(sw_up_dt);
	sw_bean.setSw_insu_nm(sw_insu_nm);
	sw_bean.setSw_insu_no(sw_insu_no);
	sw_bean.setSw_insu_money(sw_insu_money);
	
	count = icd.insertSw(sw_bean);
	
}else if(cmd.equals("wk")){
	wk_bean.setUser_id(user_id);
	wk_bean.setSeq(seq);
	wk_bean.setWk_st_dt(wk_st_dt);
	wk_bean.setWk_ed_dt(wk_ed_dt);
	wk_bean.setWk_name(wk_name);
	wk_bean.setWk_pos(wk_pos);
	wk_bean.setWk_work(wk_work);
	wk_bean.setWk_emp(wk_emp);
	wk_bean.setWk_title(wk_title);
	
	count = icd.insertWk(wk_bean);
	
}else if(cmd.equals("ls")){
	ls_bean.setUser_id(user_id);
	ls_bean.setSeq(seq);
	ls_bean.setLs_dt(ls_dt);
	ls_bean.setLs_name(ls_name);
	ls_bean.setLs_num(ls_num);
	ls_bean.setLs_bmng(ls_bmng);
	
	count = icd.insertLs(ls_bean);
	
}else if(cmd.equals("jg")){
	jg_bean.setUser_id(user_id);
	jg_bean.setSeq(seq);
	jg_bean.setJg_dt(jg_dt);
	jg_bean.setBr_dt(br_dt);
	jg_bean.setPos(pos);
	jg_bean.setNote(note);
	
	count = icd.insertJg(jg_bean);
}else if(cmd.equals("del")){

	count = icd.delete_Data(user_id, seq, st);

}


%>
<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15" >

<form name='form1' method='post'>
<input type="hidden" name="user_id" 	value="<%=user_id%>">
<input type="hidden" name="auth_rw" 	value="<%=auth_rw%>">
<input type="hidden" name="cmd" 	value="<%=cmd%>">

</form>
<script language='javascript'>
<!--
	var fm = document.form1;

<%	if(cmd.equals("sc")){
		if(count==1){		
%>
		alert("정상적으로 등록되었습니다.");
		fm.action='./insa_card_c.jsp?user_id=<%=user_id%>';
		fm.target='d_content';
		parent.close();	
		fm.submit();		

<%	}
	}else if(cmd.equals("ib")){
		if(count==1){		
%>
		alert("정상적으로 등록되었습니다.");
		fm.action='./insa_card_c.jsp?user_id=<%=user_id%>';
		fm.target='d_content';
		parent.close();	
		fm.submit();		
	
<%	}
}else if(cmd.equals("sb")){
		if(count==1){
%>
		alert("정상적으로 등록되었습니다.");
		fm.action='./insa_card_c.jsp?user_id=<%=user_id%>';
		fm.target='d_content';
		parent.close();	
		fm.submit();					
<%	}
}else if(cmd.equals("fy")){
		if(count==1){
%>
		alert("정상적으로 등록되었습니다.");
		fm.action='./insa_card_c.jsp?user_id=<%=user_id%>';
		fm.target='d_content';
		parent.close();	
		fm.submit();					
<%	}
}else if(cmd.equals("sw")){
		if(count==1){
%>
		alert("정상적으로 등록되었습니다.");
		fm.action='./insa_card_c.jsp?user_id=<%=user_id%>';
		fm.target='d_content';
		parent.close();	
		fm.submit();					
<%	}
}else if(cmd.equals("wk")){
		if(count==1){
%>
		alert("정상적으로 등록되었습니다.");
		fm.action='./insa_card_c.jsp?user_id=<%=user_id%>';
		fm.target='d_content';
		parent.close();	
		fm.submit();					
<%	}
}else if(cmd.equals("ls")){
		if(count==1){
%>
		alert("정상적으로 등록되었습니다.");
		
		fm.action='insa_card_c.jsp?user_id=<%=user_id%>';
		//fm.target='';
		//parent.close();
		//fm.submit();		
		fm.target='d_content';
		parent.close();	
		fm.submit();							
<%	}
}else if(cmd.equals("jg")){
		if(count==1){
%>
		alert("정상적으로 등록되었습니다.");		
		if (!from_page.equals("")) {
			fm.action=<%=from_page%>;
			fm.target = '_parent';				
		} else {
			fm.action='insa_card_c.jsp?user_id=<%=user_id%>';
			fm.target='d_content';
			parent.close();				
		}
		fm.submit();	
<%	}
}else if(cmd.equals("del")){
		if(count==1){
%>
		alert("정상적으로 삭제되었습니다.");		
		fm.action='insa_card_c.jsp?user_id=<%=user_id%>';
		fm.target='d_content';
		parent.close();	
		fm.submit();									
<%	}
}else{
%>
	alert("에러입니다.");
<%
}
%>
//-->

</script>
</body>
</html>
