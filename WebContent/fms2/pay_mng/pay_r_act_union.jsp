<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.user_mng.*, acar.doc_settle.*, acar.biz_partner.*, acar.inside_bank.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
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
	
	
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	BizPartnerDatabase 	bp_db 	= BizPartnerDatabase.getInstance();
	InsideBankDatabase 	ib_db 	= InsideBankDatabase.getInstance();
	
	String actseq 	= request.getParameter("actseq")==null? "":request.getParameter("actseq");
	
	String bank_code 	= request.getParameter("bank_code")==null? "":request.getParameter("bank_code");
	String p_pay_dt 	= request.getParameter("p_pay_dt")==null? "":request.getParameter("p_pay_dt");
	String off_nm 		= request.getParameter("off_nm")==null? "":request.getParameter("off_nm");
	String bank_no 		= request.getParameter("bank_no")==null? "":request.getParameter("bank_no");
	String a_bank_no 	= request.getParameter("a_bank_no")==null? "":request.getParameter("a_bank_no");
	
	if(actseq.equals("")){
		actseq = pm_db.getActSeqSearch(bank_code, p_pay_dt, off_nm, bank_no, a_bank_no);
	}
	
	//�۱ݿ���
	PayMngActBean act 	= pm_db.getPayAct(actseq);
	
	//�۱ݼ����� ó��-���忡�� ó��
	Vector vt =  pm_db.getPayActList(act.getBank_code(), "", act.getOff_nm(), act.getBank_no(), act.getA_bank_no());
	int vt_size = vt.size();
	
	//���࿬���� ���� ���������� �ξ�� ��--������Ʈ��
	ErpTransBean et = bp_db.getErpTransCase(actseq);
	
	//���࿬���� ���� ���������� �ξ�� ��--�λ���Ʈ��ũ
	IbBulkTranBean it = ib_db.getIbBulkTranCase(actseq);
	
	
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;
	long total_amt11 = 0;
	long total_amt12 = 0;
	long total_amt13 = 0;
	long total_amt14 = 0;
	long total_amt15 = 0;
	long total_amt16 = 0;
	
	int s1 = 0;
	int b1 = 0;
	int d1 = 0;
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	function save()
	{
		var fm = document.form1;
		
		var a_amt = toInt(parseDigit(fm.act_amt.value));
		var t_amt = toInt(parseDigit(fm.t_amt.value))-toInt(parseDigit(fm.t_m_amt.value));
		
		var a_commi = toInt(parseDigit(fm.commi.value));
		var t_commi = toInt(parseDigit(fm.t_commi.value));

				
		if(confirm('�۱��Ͻðڽ��ϱ�?')){
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('ó�� ���Դϴ�. ��ø� ��ٷ��ּ���');");
			
			fm.action = 'pay_r_act_u_a.jsp';
			fm.target = 'i_no';
			fm.submit();	
			
			link.getAttribute('href',originFunc);	
		}
	}
	
	function sum_amt(){
		var fm = document.form1;
		var t_amt = 0;
		var t_m_amt = 0;
		var t_commi = 0;		
		if(<%=vt_size%> == 1){
			fm.t_amt.value 	 = fm.p_amt.value;		
			fm.t_m_amt.value = fm.p_m_amt.value;		
			fm.t_commi.value = fm.p_commi.value;					
		}else{
			for(var i = 0 ; i < <%=vt_size%> ; i ++){
				t_amt += toInt(parseDigit(fm.p_amt[i].value));
				t_m_amt += toInt(parseDigit(fm.p_m_amt[i].value));
				t_commi += toInt(parseDigit(fm.p_commi[i].value));
			}
			fm.t_amt.value 		= parseDecimal(t_amt);
			fm.t_m_amt.value 	= parseDecimal(t_m_amt);
			fm.t_commi.value 	= parseDecimal(t_commi);
		}
	}		
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">
  <input type='hidden' name="actseq" 	value="<%=actseq%>">  
  <input type='hidden' name="vt_size" 	value="<%=vt_size%>">    



<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td><< �۱ݿ�û >></td>
    </tr>  
    <tr>
      <td class=line2></td>
    </tr>    
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="15%" class=title>�۱��ڵ�</td>
            <td >&nbsp;			  
              <%=actseq%> </td>
          </tr>		
          <tr>
            <td class=title>�ݾ�</td>
            <td>&nbsp;
              <input type='text' name='act_amt' size='15' value='<%=AddUtil.parseDecimalLong(act.getAmt())%>' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>
              �� &nbsp;
		    </td>
          </tr>		
          <tr>
            <td class=title>������</td>
            <td>&nbsp;
              <input type='text' name='commi' size='6' maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(act.getCommi())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
              �� &nbsp;
		    </td>
          </tr>		  		    
          <tr>
            <td width="15%" class=title>�������</td>
            <td >&nbsp;			  
              <input type='text' name='act_dt' size='11' value='<%=AddUtil.ChangeDate2(act.getAct_dt())%>' class='default' > </td>
          </tr>		
          <tr>
            <td class=title>����ó</td>
            <td>&nbsp;              
              <%=act.getOff_nm()%>
            </td>
          </tr>		
          <tr>
            <td class=title>�Աݰ���</td>
            <td >
			  <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                   <td width="15%">&nbsp;			  
				     <input type='text' name='bank_nm' size='15' value='<%=act.getBank_nm()%>' class='default' ></td>
				   <td width="25%"><input type='text' name='bank_no' size='25' value='<%=act.getBank_no()%>' class='default' ></td>
				   <td width="60%">������ : <input type='text' name='bank_acc_nm' size='33' value='<%=act.getBank_acc_nm()%>' class='default' > </td>
				 </tr>
			  </table>	 
            </td>
          </tr>
          <tr>
            <td class=title>��ݰ���</td>
            <td >
			  <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                   <td width="15%">&nbsp;	
				     <input type='text' name='a_bank_nm' size='15' value='<%=act.getA_bank_nm()%>' class='default' ></td>
				   <td width="25%"><input type='text' name='a_bank_no' size='25' value='<%=act.getA_bank_no()%>' class='default' ></td>
				   <td width="60%"></td>
				 </tr>
			  </table>	 			
            </td>
          </tr>		
          <tr>
            <td width="15%" class=title>�Ա���ǥ��</td>
            <td >&nbsp;			  
              <input type='text' name='bank_memo' size='20' value='<%=act.getBank_memo()%>' class='default' > </td>
          </tr>				  		    		  
          <tr>
            <td width="15%" class=title>CMS�ڵ�</td>
            <td >&nbsp;			  
              <input type='text' name='cms_code' size='20' value='<%=act.getCms_code()%>' class='default' > </td>
          </tr>				  		    		  
		</table>
	  </td>
	</tr> 	
	<%if(!et.getTran_dt().equals("")){%>
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���࿬��(������Ʈ��)</span></td>
	</tr>  		
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="14%" class=title>�ݾ�</td>									
			      <td width="7%" class=title>������</td>			
            <td width="7%" class=title>�������</td>			
            <td width="16%" class=title>�Աݰ��¹�ȣ</td>						
            <td width="13%" class=title>�Աݰ��¿�����</td>			
            <td width="16%" class=title>��ݰ���</td>
            <td width="14%" class=title>�Ա���ǥ��</td>			
            <td width="10%" class=title>CMS�ڵ�</td>						
			<td width="3%" class=title>����</td>			
          </tr>
          <tr>
            <td align="center"><input type='text' name='e_act_amt' size='15' value='<%=AddUtil.parseDecimalLong(et.getTran_amt())%>' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>						
            <td align="right"><%=Util.parseDecimal(et.getTran_fee())%>��</td>									
            <td align="center"><%=AddUtil.ChangeDate2(et.getTran_dt())%></td>									
            <td align="center"><input type='text' name='e_bank_id' size='3' value='<%=et.getIn_bank_id()%>' class='default' >
			                   &nbsp;<input type='text' name='e_bank_nm' size='15' value='<%=et.getIn_bank_name()%>' class='default' >
			                   <br><input type='text' name='e_bank_no' size='20' value='<%=et.getIn_acct_no()%>' class='default' ></td>
            <td align="center"><input type='text' name='e_bank_acc_nm' size='15' value='<%=et.getReceip_owner_name()%>' class='default' ></td>			
            <td align="center"><input type='text' name='e_a_bank_id' size='3' value='<%=et.getOut_bank_id()%>' class='default' >
			                   &nbsp;<input type='text' name='e_a_bank_nm' size='15' value='<%=et.getOut_bank_name()%>' class='default' >
			                   <br><input type='text' name='e_a_bank_no' size='20' value='<%=et.getOut_acct_no()%>' class='default' ></td>												
			<td align="center"><input type='text' name='e_bank_memo' size='15' value='<%=et.getIn_acct_memo()%>' class='default' ></td>
			<td align="center"><input type='text' name='e_cms_code' size='10' value='<%=et.getCms_code()%>' class='default' ></td>			
			<td align="center"><b><%=et.getErr_reason()%></b></td>
          </tr>		  
		</table>
	  </td>
	</tr> 				
	<tr>
		<td>* ���࿬�� ���°� ����϶��� �Ա���ǥ�� �� CMS�ڵ带 �����մϴ�.</td>	
	</tr>	
	<%}%>		
	<%if(!it.getTran_dt().equals("")){%>
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���࿬��(�λ��̵��ũ)</span></td>
	</tr>  		
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="14%" class=title>�ݾ�</td>									
			      <td width="7%" class=title>������</td>			
            <td width="7%" class=title>�������</td>			
            <td width="16%" class=title>�Աݰ��¹�ȣ</td>						
            <td width="13%" class=title>�Աݰ��¿�����</td>			
            <td width="16%" class=title>��ݰ���</td>
            <td width="14%" class=title>�Ա���ǥ��</td>			
            <td width="10%" class=title>CMS�ڵ�</td>						
			      <td width="3%" class=title>����</td>			
          </tr>
          <tr>
            <td align="center"><input type='text' name='i_act_amt' size='15' value='<%=AddUtil.parseDecimalLong(it.getTran_amt_req())%>' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value);'>��</td>						
            <td align="right"><%=Util.parseDecimal(it.getTran_fee())%>��</td>									
            <td align="center"><%=AddUtil.ChangeDate2(it.getTran_dt())%></td>									
            <td align="center"><input type='text' name='i_bank_id' size='3' value='<%=it.getTran_ip_bank_id()%>' class='default' >
			                   <br><input type='text' name='i_bank_no' size='20' value='<%=it.getTran_ip_acct_nb()%>' class='default' ></td>
            <td align="center"><input type='text' name='i_bank_acc_nm' size='15' value='<%=it.getTran_remittee_nm()%>' class='default' ></td>			
            <td align="center">����<br><input type='text' name='i_a_bank_no' size='20' value='<%=it.getTran_ji_acct_nb()%>' class='default' ></td>												
			<td align="center"><input type='text' name='i_bank_memo' size='15' value='<%=it.getTran_ip_naeyong()%>' class='default' ></td>
			<td align="center"><input type='text' name='i_cms_code' size='10' value='<%=it.getTran_cms_cd()%>' class='default' ></td>			
			<td align="center"><b><%if(it.getTran_result_cd().equals("00")){%>ó����
			<%}else if(it.getTran_result_cd().equals("01")){%>ó����
			<%}else if(it.getTran_result_cd().equals("02")){%>����ó��
			<%}else if(it.getTran_result_cd().equals("03")){%>ó������
			<%}%>
			</b></td>
          </tr>		  
		</table>
	  </td>
	</tr> 				
	<tr>
		<td>* ���࿬�� ���°� ����϶��� �Ա���ǥ�� �� CMS�ڵ带 �����մϴ�.</td>	
	</tr>	
	<%}%>			
	<tr>
	  <td><hr></td>
	</tr>  			
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���θ���Ʈ</span></td>
	</tr>  		
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="3%" class=title>����</td>
            <td width="12%" class=title>������ȣ</td>
            <td width="12%" class=title>�ݾ�</td>									
            <td width="10%" class=title>������ݾ�</td>												
			<td width="6%" class=title>������</td>			
            <td width="9%" class=title>�������</td>			
            <td width="16%" class=title>�Աݰ��¹�ȣ</td>						
            <td width="13%" class=title>�Աݰ��¿�����</td>			
            <td width="16%" class=title>��ݰ���</td>									
			<td width="3%" class=title>����</td>			
          </tr>
          <%
		 	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
				total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("M_AMT")));
				total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("COMMI")));%>			  
          <tr>
            <td align="center"><%=i+1%><input type="hidden" name="p_reqseq" 	value="<%=ht.get("REQSEQ")%>"></td>
            <td align="center"><%=ht.get("REQSEQ")%></td>
            <td align="right"><input type='text' name='p_amt' size='15' value='<%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%>' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); sum_amt();'>��</td>						
            <td align="right"><input type='text' name='p_m_amt' size='7' value='<%=Util.parseDecimal(String.valueOf(ht.get("M_AMT")))%>' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); sum_amt();'>��</td>									
            <td align="right"><input type='text' name='p_commi' size='5' value='<%=Util.parseDecimal(String.valueOf(ht.get("COMMI")))%>' class='defaultnum' onBlur='javascript:this.value=parseDecimal(this.value); sum_amt();'>��</td>									
            <td align="center"><input type='text' name='p_p_pay_dt' size='11' value='<%=AddUtil.ChangeDate2(String.valueOf(ht.get("P_PAY_DT")))%>' class='default' ></td>									
            <td align="center"><input type='text' name='p_bank_nm' size='20' value='<%=ht.get("BANK_NM")%>' class='default' ><br><input type='text' name='p_bank_no' size='20' value='<%=ht.get("BANK_NO")%>' class='default' ></td>
            <td align="center"><input type='text' name='p_bank_acc_nm' size='15' value='<%=ht.get("BANK_ACC_NM")%>' class='default' ></td>			
            <td align="center"><input type='text' name='p_a_bank_nm' size='20' value='<%=ht.get("A_BANK_NM")%>' class='default' ><br><input type='text' name='p_a_bank_no' size='20' value='<%=ht.get("A_BANK_NO")%>' class='default' ></td>												
			<td align="center"><%=ht.get("P_STEP")%></td>
          </tr>
	      <%}%>		
		  <tr>
		    <td class=title colspan='2'>�հ�</td>
		    <td align="right"><input type='num' name='t_amt' size='15' value='<%=AddUtil.parseDecimalLong(total_amt1)%>' class='whitenum' >��</td>
		    <td align="right"><input type='text' name='t_m_amt' size='7' value='<%=AddUtil.parseDecimalLong(total_amt2)%>' class='defaultnum' >��</td>
		    <td align="right"><input type='text' name='t_commi' size='5' value='<%=AddUtil.parseDecimalLong(total_amt3)%>' class='defaultnum' >��</td>
		    <td class=title colspan='5'>&nbsp;</td>			
		  </tr>
		</table>
	  </td>
	</tr> 				
	<tr>
		<td>&nbsp;</td>	
	</tr>		
    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>	
    <tr>
	    <td align='center'>
	    <a id="submitLink" href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
	    </td>
	</tr>	
    <%}%>	
</table>
</form>  
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
