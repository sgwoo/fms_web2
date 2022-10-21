<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.user_mng.*"%>
<%@ page import="acar.pay_mng.*, acar.bill_mng.*"%>
<%@ include file="/acar/cookies.jsp"%>


<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	
	
	
	PayMngDatabase 		pm_db 	= PayMngDatabase.getInstance();
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();
	
	
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	
	out.println("start_row="+start_row+"<br>");
	out.println("value_line="+value_line+"<br>");
	
	
	String value00[] = request.getParameterValues("value00");//상태
	String value01[] = request.getParameterValues("value01");//실행여부
	String value02[] = request.getParameterValues("value02");//집금일자
	String value03[] = request.getParameterValues("value03");//집금시간
	String value04[] = request.getParameterValues("value04");//집금구분
	String value05[] = request.getParameterValues("value05");//집금단계
	String value06[] = request.getParameterValues("value06");//자계좌은행
	String value07[] = request.getParameterValues("value07");//자계좌번호
	String value08[] = request.getParameterValues("value08");//모계좌은행
	String value09[] = request.getParameterValues("value09");//모계좌번호
	String value10[] = request.getParameterValues("value10");//집금유형
	String value11[] = request.getParameterValues("value11");//집금의뢰액
	String value12[] = request.getParameterValues("value12");//집금액
	String value13[] = request.getParameterValues("value13");//수수료
	String value14[] = request.getParameterValues("value14");//지불가능잔액(이체전)
	String value15[] = request.getParameterValues("value15");//실행결과메시지
	
	String result[]  = new String[value00.length];
	String payseq[]  = new String[value00.length];
	
	int flag = 0;
	int seq = 0;
	String reqseq		= "";
	String a_bank_nm="";
	int a_index_nm =0;
	String bank_nm="";
	int index_nm =0;
	String search_code  = Long.toString(System.currentTimeMillis());
	String bank_n="";
	
	
	for(int i=start_row ; i <= value_line ; i++){
		
		result[i] = "";
		
		PayMngBean bean = new PayMngBean();
		
		bean.setReqseq		("");
		bean.setReg_id		(user_id);
		bean.setReg_st		("A");
		bean.setP_way		("5");
		bean.setOff_nm		("(주)아마존카");
		bean.setVen_name		("(주)아마존카");
		bean.setAmt			(value12[i]==null?0:AddUtil.parseDigit4(value12[i]));
		
		//bank_nm
		if(value08[i]==null){
		
		}else{
			
			bank_nm=value08[i];
			index_nm = bank_nm.indexOf("(");
			if(index_nm>0){
				bank_nm = bank_nm.substring(0,index_nm);
			}
			if(bank_nm.equals("SC")){
				bank_nm = "제일";
			}else if(bank_nm.equals("농협")){
				bank_nm = "NH농협";
			}
			Hashtable bank_ht = ps_db.getBankCode("", bank_nm);
			if(String.valueOf(bank_ht.get("NM")).equals("null")){
			}else{
				bean.setBank_nm(String.valueOf(bank_ht.get("NM")).replace("은행",""));
			}
		}
			
			
		
		bean.setBank_no	(value09[i]==null?"":value09[i]);
		
		//a_bank_nm
		if(value06[i]==null){
		
		}else{
			
			a_bank_nm=value06[i];
			a_index_nm = a_bank_nm.indexOf("(");
			if(a_index_nm>0){
				a_bank_nm = a_bank_nm.substring(0,a_index_nm);
			}
			if(a_bank_nm.equals("SC")){
				a_bank_nm = "제일";
			}else if(a_bank_nm.equals("농협")){
				a_bank_nm = "NH농협";
			}
			Hashtable bank_ht2 = ps_db.getBankCode("", a_bank_nm);
			if(String.valueOf(bank_ht2.get("NM")).equals("null")){
				if(a_bank_nm.equals("시티")){
					bean.setA_bank_nm("시티");
				}
			}else{
				bean.setA_bank_nm(String.valueOf(bank_ht2.get("NM")).replace("은행",""));
			}
		}
		
		if(value07[i]==null){
		
		}else{
			
			Hashtable bank_ht3 = ps_db.getBankBarNum(AddUtil.replace(value07[i],"-",""));
				bean.setA_bank_no(String.valueOf(bank_ht3.get("DEPOSIT_NO")));
				bank_n =String.valueOf(bank_ht3.get("DEPOSIT_NO"));
		}
		
		
		bean.setP_est_dt	(value02[i]==null?"":value02[i]);
		bean.setP_step  ("4");
		bean.setBank_acc_nm		("(주)아마존카");
		bean.setCommi(value13[i]==null?0:AddUtil.parseInt(value13[i]));
		
		//out.println("value09[i]="+value09[i]);
		//out.println("bank_no="+bean.getBank_no());
		//out.println("value07[i]="+value07[i]);
		//out.println("a_bank_no="+bean.getA_bank_no());
		
		reqseq = pm_db.insertPay2(bean);
		
		payseq[i] = reqseq;
		
		out.println("<br>");
		
		if(!reqseq.equals("")){
			PayMngBean bean2 	= new PayMngBean();
				
			bean2.setReqseq			(reqseq);
			bean2.setI_seq			(1);
			bean2.setP_gubun		("60");
			bean2.setP_st2			("자금집금");
			bean2.setP_st3			("계좌이체");
			bean2.setR_est_dt		(value02[i]==null?"":value02[i]);
			bean2.setI_amt			(value12[i]==null?0:AddUtil.parseDigit4(value12[i]));
			bean2.setI_s_amt		(value12[i]==null?0:AddUtil.parseDigit4(value12[i]));
			bean2.setAcct_code	("10300");
			String p_cont1 = "";
			p_cont1 = bank_n;
			String p_cont2 = "";
			p_cont2 = value09[i]==null?"":value09[i];
			bean2.setP_cont			("자금집금("+a_bank_nm+p_cont1+"->"+bank_nm+p_cont2+")");
		
			if(!pm_db.insertPayItem2(bean2)) flag += 1;
		}
		reqseq="";
}
	
	
	if(1==1) return;
	
	
	
	
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'pay_excel_reg_bank_step3.jsp';
		fm.submit();
	}
//-->
</script>
</HEAD>
<BODY>
<p>엑셀 파일 읽어 집금 등록하기
</p>
<form action="" method='post' name="form1">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='from_page' value='/fms2/pay_mng/pay_excel_reg_bank_step2.jsp'>
<input type='hidden' name='search_code' value='<%=search_code%>'>
<%for(int i=start_row ; i <= value_line ; i++){%>
<input type='hidden' name='payseq' value='<%=payseq[i]%>'>
<%}%>
	<%for(int i=start_row ; i <= value_line ; i++){%>
<%=payseq[i]%><br>
<%}%>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--	
<%	if(flag==1){//에러발생%>
		alert("에러가 발생하였습니다.");
<%	}else{//정상%>
	alert("등록하였습니다.");
<%	}%>	
//-->
</SCRIPT>
</BODY>
</HTML>