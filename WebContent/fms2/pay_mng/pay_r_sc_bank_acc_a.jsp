<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.user_mng.*"%>
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
	
	
	int count = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	
	

%>


<%

	String vid1[] 	= request.getParameterValues("actseq");
	String vid2[] 	= request.getParameterValues("conf_st");
	
	int vid_size = vid1.length;
	
	String actseq 	= "";
	String conf_st 	= "";
	
	
	//out.println(vid_size);
	
	
	
	
	for(int i=0;i < vid_size;i++){
	
	
		actseq = vid1[i];
		conf_st = vid2[i];

		//out.println("<br>");
		//out.println("actseq="+actseq);
		//out.println(", conf_st="+conf_st);
		
		
			
		//송금원장
		PayMngActBean act 	= pm_db.getPayAct(actseq);
	


		BankAccBean ba_bean = c_db.getBankAcc("tran", act.getBank_no(), 1);
	
	
		ba_bean.setConf_st	(conf_st);


		if(ba_bean.getOff_st().equals("") && !conf_st.equals("")){
			ba_bean.setOff_st	("tran");
			ba_bean.setOff_id	(act.getBank_no());
			ba_bean.setSeq		(1);	
			count = c_db.insertBankAcc(ba_bean);			
		}else{				
			count = c_db.updateBankAcc(ba_bean);
		}		
	
	}
	
	//if(1==1)return;
	
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
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name="mode" 	value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>"> 
</form>
<script language='javascript'>
<!--
<%	if(count==1){//정상%>
		alert("처리하였습니다.");
		go_step();
<%	}else{%>
		alert("에러가 발생하였습니다.");
<%	}%>
//-->
</script>
</body>
</html>