<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*"%>
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int sh_height 	= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	String vid[] 	= request.getParameterValues("reqseq");
	String deposit_no 	= request.getParameter("deposit_no")==null?"":request.getParameter("deposit_no");
	
	String reqseq 	= "";
	
	int vid_size = vid.length;
	
	
	PayMngDatabase 		pm_db 	= PayMngDatabase.getInstance();
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	
	int flag = 0;
	
	
	for(int i=0;i < vid_size;i++){
		
		reqseq = vid[i];
		
		//��ݿ���
		PayMngBean bean 	= pm_db.getPay(reqseq);
		
		bean.setP_way		(request.getParameter("p_way")==null?"5":request.getParameter("p_way"));
		if(bean.getP_way().equals("1")) 	bean.setP_st3("����");
		if(bean.getP_way().equals("2")) 	bean.setP_st3("����ī��");
		if(bean.getP_way().equals("3")) 	bean.setP_st3("�ĺ�ī��");
		if(bean.getP_way().equals("4")) 	bean.setP_st3("�ڵ���ü");
		if(bean.getP_way().equals("5")) 	bean.setP_st3("������ü");
		if(bean.getP_way().equals("7")) 	bean.setP_st3("ī���Һ�");
		bean.setBank_id		(request.getParameter("s_bank_id")	==null?"":request.getParameter("s_bank_id"));
		bean.setBank_nm		(request.getParameter("bank_nm")	==null?"":request.getParameter("bank_nm"));
		bean.setBank_no		(request.getParameter("bank_no")	==null?"":request.getParameter("bank_no"));
		bean.setBank_acc_nm	(request.getParameter("bank_acc_nm")==null?"":request.getParameter("bank_acc_nm"));	
		
		bean.setCard_id		(request.getParameter("card_id")==null?"":request.getParameter("card_id"));
		bean.setCard_nm		(request.getParameter("card_nm")==null?"":request.getParameter("card_nm"));
		bean.setCard_no		(request.getParameter("card_no")==null?"":request.getParameter("card_no"));
		
		//������ü(����ó) �����ڵ�-code
		if(bean.getBank_cms_bk().equals("") && !bean.getBank_nm().equals("")){
			Hashtable ht = ps_db.getBankCode("", bean.getBank_nm());
			if(String.valueOf(ht.get("CMS_BK")).equals("null")){
			}else{
				bean.setBank_cms_bk(String.valueOf(ht.get("CMS_BK")));
			}
		}	
		
		//������ü(����ó) �����ڵ�-�׿���
		if(bean.getBank_id().equals("") && !bean.getBank_nm().equals("")){
			Hashtable ht = ps_db.getCheckd("A03", bean.getBank_nm());
			if(String.valueOf(ht.get("CHECKD_CODE")).equals("null")){
			}else{
				bean.setBank_id(String.valueOf(ht.get("CHECKD_CODE")));
			}
		}
		
		if(!deposit_no.equals("")){
			//��������
			Hashtable acc = ps_db.getDepositma(deposit_no);
			bean.setA_bank_id	(String.valueOf(acc.get("BANK_CODE"))==null?"":String.valueOf(acc.get("BANK_CODE")));
			bean.setA_bank_nm	(String.valueOf(acc.get("CHECKD_NAME"))==null?"":String.valueOf(acc.get("CHECKD_NAME")));
			bean.setA_bank_no	(deposit_no);
		}
		//������ü(����ó) �����ڵ�-code
		if(!bean.getA_bank_nm().equals("") && bean.getP_way().equals("5")){
			Hashtable ht = ps_db.getBankCode("", bean.getA_bank_nm());
			if(String.valueOf(ht.get("CMS_BK")).equals("null")){
			}else{
				bean.setA_bank_cms_bk(String.valueOf(ht.get("CMS_BK")));
			}
		}
		//������ü(����ó) �����ڵ�-�׿���
		if(!bean.getA_bank_nm().equals("") && bean.getP_way().equals("5")){
			Hashtable ht = ps_db.getCheckd("A03", bean.getA_bank_nm());
			if(String.valueOf(ht.get("CHECKD_CODE")).equals("null")){
			}else{
				bean.setA_bank_id(String.valueOf(ht.get("CHECKD_CODE")));
			}
		}
		
		if(!pm_db.updatePayAccCng(bean)) flag += 1;
	}

%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		if(fm.from_page.value == ''){
			fm.action = 'pay_b_frame.jsp';
		}else{
			fm.action = '<%=from_page%>';		
		}
		fm.target = 'd_content';
		fm.submit();
		
		parent.window.close();
	}
//-->
</script>
</head>
<body>
<form name='form1' action='' target='' method='post'>
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
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='from_page' value='<%=from_page%>'>  
</form>
<script language='javascript'>
<!--
<%	if(flag > 0){//�����߻�%>
		alert("������ �߻��Ͽ����ϴ�.");
<%	}else{//����%>
		alert("�����Ͽ����ϴ�.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
