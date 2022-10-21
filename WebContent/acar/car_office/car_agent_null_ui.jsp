<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*" %>
<%@ page import="acar.car_office.*, acar.bill_mng.*" %>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String st 	= request.getParameter("st")==null?"":request.getParameter("st");
	
	String car_off_id = request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");


	int count = 0;
	int flag = 0;
	
	if(cmd.equals("u")){
		co_bean = cod.getCarOffBean(car_off_id);
	}

	
	co_bean.setCar_off_st	(request.getParameter("car_off_st")==null?"":request.getParameter("car_off_st"));
	co_bean.setCar_off_nm	(request.getParameter("car_off_nm")==null?"":request.getParameter("car_off_nm"));
	co_bean.setOwner_nm	(request.getParameter("owner_nm")==null?"":request.getParameter("owner_nm"));
	co_bean.setCar_off_tel	(request.getParameter("car_off_tel")==null?"":request.getParameter("car_off_tel"));
	co_bean.setCar_off_fax	(request.getParameter("car_off_fax")==null?"":request.getParameter("car_off_fax"));
	co_bean.setCar_off_post	(request.getParameter("car_off_post")==null?"":request.getParameter("car_off_post"));
	co_bean.setCar_off_addr	(request.getParameter("car_off_addr")==null?"":request.getParameter("car_off_addr"));
	co_bean.setBank		(request.getParameter("bank")==null?"":request.getParameter("bank"));
	co_bean.setAcc_no	(request.getParameter("acc_no")==null?"":request.getParameter("acc_no"));
	co_bean.setAcc_nm	(request.getParameter("acc_nm")==null?"":request.getParameter("acc_nm"));
	co_bean.setEnp_no	(request.getParameter("enp_no")==null?"":request.getParameter("enp_no"));		
	co_bean.setAgent_st	(request.getParameter("agent_st")==null?"":request.getParameter("agent_st"));
	co_bean.setEnp_st	(request.getParameter("enp_st")==null?"":request.getParameter("enp_st"));
	co_bean.setEnp_reg_st	(request.getParameter("enp_reg_st")==null?"":request.getParameter("enp_reg_st"));
	co_bean.setDoc_st	(request.getParameter("doc_st")==null?"":request.getParameter("doc_st"));
	co_bean.setEst_day	(request.getParameter("est_day")==null?"":request.getParameter("est_day"));
	co_bean.setReq_st	(request.getParameter("req_st")==null?"":request.getParameter("req_st"));
	co_bean.setPay_st	(request.getParameter("pay_st")==null?"":request.getParameter("pay_st"));
	co_bean.setReg_id	(user_id);
	co_bean.setReg_dt	(request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt"));
	co_bean.setWork_st	(request.getParameter("work_st")==null?"C":request.getParameter("work_st"));
	co_bean.setUse_yn	(request.getParameter("use_yn")==null?"":request.getParameter("use_yn"));
	co_bean.setBank_cd(request.getParameter("bank_cd")==null?"":request.getParameter("bank_cd"));
	
	if(!co_bean.getBank_cd().equals("")){
		co_bean.setBank		(c_db.getNameById(co_bean.getBank_cd(), "BANK"));
	}	

	//견적만
	if(co_bean.getWork_st().equals("E")){
		co_bean.setEnp_reg_st	("");
		co_bean.setDoc_st			("");
		co_bean.setEst_day		("");
		co_bean.setReq_st			("");
		co_bean.setPay_st			("");	
	}
		
	if(co_bean.getEst_day().equals("D")){
		co_bean.setEst_day(request.getParameter("est_day_sub")==null?"":request.getParameter("est_day_sub"));	
		co_bean.setEst_mon_st(request.getParameter("est_mon_st")==null?"":request.getParameter("est_mon_st"));	
	}else{
		co_bean.setEst_day("");	
	}
	
		
	if(cmd.equals("i"))
	{
		co_bean.setCar_comp_id	("1000");
			
		count = cod.insertCarOff(co_bean);
		
	}else if(cmd.equals("u")){
	
		co_bean.setVen_code	(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
		
		count = cod.updateCarOff(co_bean);
		
	}
	
	
		//네오엠거래처 처리
		
		if(co_bean.getVen_code().equals("") && co_bean.getDoc_st().equals("2")){
			
			String ven_code = "";
			
			//중복체크
			if(co_bean.getEnp_st().equals("2")){//법인
				ven_code = neoe_db.getVenCodeChk("1", co_bean.getCar_off_nm(), "", co_bean.getEnp_no());
			}else{//개인
				ven_code = neoe_db.getVenCodeChk("2", co_bean.getCar_off_nm(), co_bean.getEnp_no(), "");
			}
		
			if(ven_code.equals("")){
				
				TradeBean t_bean = new TradeBean();
			
				t_bean.setCust_name	(AddUtil.substring(co_bean.getCar_off_nm(),15));
			
				if(co_bean.getEnp_st().equals("2")){//법인
					t_bean.setS_idno	(co_bean.getEnp_no());
				}else{//개인
					t_bean.setId_no		(co_bean.getEnp_no());
				}
											
				t_bean.setDname		(AddUtil.substring(co_bean.getOwner_nm(),15));
				t_bean.setMail_no	(co_bean.getCar_off_post());
				t_bean.setS_address	(AddUtil.substring(co_bean.getCar_off_addr(),30));
				t_bean.setUptae		("");
				t_bean.setJong		("");
						
				if(!neoe_db.insertTrade(t_bean)) flag += 1;	
		
				if(co_bean.getEnp_st().equals("2")){//법인
					ven_code = neoe_db.getVenCodeChk("1", co_bean.getCar_off_nm(), "", co_bean.getEnp_no());
				}else{//개인
					ven_code = neoe_db.getVenCodeChk("2", co_bean.getCar_off_nm(), co_bean.getEnp_no(), "");
				}
		
				co_bean.setVen_code	(ven_code);
			
			}else{
				co_bean.setVen_code	(ven_code);
			}	
			
			System.out.println("<에이전트등록>");
			System.out.println("co_bean.getCar_off_nm()="+co_bean.getCar_off_nm());
			System.out.println("ven_code="+ven_code);
		
			count = cod.updateCarOff(co_bean);
		}	
	
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function NullAction()
{
	<%if(cmd.equals("u") || cmd.equals("neom")){%>


		alert("정상적으로 수정되었습니다.");

    	
    		<%if(st.equals("car_off")){%>
			window.close();		
		<%}else{%>
		<%	if(mode.equals("car_pur")){%>
			var theForm = document.form1;
			theForm.action="/fms2/car_pur/view_car_office.jsp";
			theForm.submit();	
		<%	}else{%>
			var theForm = document.form1;
			theForm.action="/acar/car_office/car_agent_c.jsp";
			theForm.target="d_content";
			theForm.submit();		
		<%	}%>	
		<%}%>
		
	<%}else{
		if(count==1){%>
		
			alert("정상적으로 등록되었습니다.");
			var theForm = document.form1;
			theForm.action="/acar/car_office/car_agent_frame.jsp";
			theForm.target="d_content";
			theForm.submit();
			
	<%	}
	  }%>
}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">
<form action="./car_agent_frame.jsp" name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="user_id" value="<%= user_id %>">
<input type="hidden" name="br_id" value="<%= br_id %>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="gubun3" value="<%=gubun3%>">
<input type="hidden" name="gubun4" value="<%=gubun4%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="car_off_id" value="<%=car_off_id%>">
</form>
</body>
</html>