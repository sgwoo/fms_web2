<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.doc_settle.*, acar.car_sche.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 


<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int flag = 0;
	int result = 0;
	
	
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//??????
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
%>


<%
	String rs_value01[] = request.getParameterValues("actseq");
	String rs_value02[] = request.getParameterValues("act_dt");
	String rs_value03[] = request.getParameterValues("commi");
	String actseq 	= "";
	String act_dt	= "";
	int    commi    = 0;
	
	int vid_size = rs_value01.length;
	
	String rs_code  = Long.toString(System.currentTimeMillis());
	
	out.println("???ðǼ?="+vid_size+"<br><br>");
	
	
	for(int i=0;i < vid_size;i++){
		
		actseq 		= rs_value01[i];
		act_dt 		= rs_value02[i]==null?"":rs_value02[i];
		commi 		= rs_value03[i]==null?0:AddUtil.parseDigit(rs_value03[i]);
		
		//?۱ݿ???
		PayMngActBean act 	= pm_db.getPayAct(actseq);
		
		act.setR_act_dt		(act_dt);
		act.setCommi		(commi);
		act.setAct_bit		("1");
		act.setRs_code		(rs_code);
		
		//=====[PAY_LEGDER_ACT] update=====
		if(!pm_db.updatePayAntR(act)) flag += 1; //pay_act / pay ó??
		
		//???μ??? ?????? ???ڹ߼?
		if(act.getOff_nm().equals("???ι???(????)??????")){
					String sendphone 	= sender_bean.getUser_m_tel();
					String sendname 	= "(??)?Ƹ???ī "+sender_bean.getUser_nm();
					String destphone 	= "010-2310-6248";
					String destname 	= "????ī?? ?赿?? ????";
					String msg_cont		= "(??)?Ƹ???ī "+act.getR_act_dt()+" ?????????? ???޵Ǿ????ϴ?. ("+act.getAmt()+") Ȯ?ιٶ??ϴ?.-?Ƹ???ī-";
					IssueDb.insertsendMail(sendphone, sendname, destphone, destname, "", "", msg_cont);
		}
		
	}
	
	//?۱ݼ????? ó??-???忡?? ó??
	Vector vt =  pm_db.getPayActBankRsCommiList(rs_code);
	int vt_size = vt.size();
	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		//???ݿ???
		PayMngBean bean 	= pm_db.getPay(String.valueOf(ht.get("REQSEQ")));
		
		bean.setCommi		(AddUtil.parseDigit(String.valueOf(ht.get("COMMI"))));
		
		if(!pm_db.updatePayR(bean)) flag += 1;
	}
	

	%>
	
<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">	
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		if(fm.from_page.value == ''){
			fm.action = 'pay_r_frame.jsp';
		}else{
			fm.action = '<%=from_page%>';		
		}
		fm.target = 'd_content';
		fm.submit();
		
		parent.window.close();
	}
//-->
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>"> 
</form>
<script language='javascript'>
<!--
<%	if(flag > 0){//?????߻?%>
		alert("?????? ?߻??Ͽ????ϴ?.");
<%	}else{//????%>
		alert("ó???Ͽ????ϴ?.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>