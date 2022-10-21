<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.* "%>
<%@ page import="acar.inside_bank.*"%>
<jsp:useBean id="ib_db" scope="page" class="acar.inside_bank.InsideBankDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>
<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String dt = request.getParameter("dt")==null?"1":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String s_wd = request.getParameter("s_wd")==null?"":request.getParameter("s_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup ��û�� ������
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String from_dt =AddUtil.getReplace_dt ( c_db.minusDay(AddUtil.getDate(4), 7) )  ;
	
	
	Vector clients = new Vector();
	int client_size = 0;		
		
	if (!s_wd.equals("")) {	
		clients = ib_db.getIbAcctAllTrDdList(dt, ref_dt1, ref_dt2, s_wd, asc);
		
	}		
	client_size = clients.size();	


%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�˻��ϱ�
	function search(){
		var fm = document.form1;	
		if(fm.s_wd.value == ''){ alert('������ �Է��Ͻʽÿ�.'); fm.s_wd.focus(); return; }	
		
		fm.submit();
	}
	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function setIncom(bank_id, acct_num, bank_code, deposit_no, tran_date, tran_date_seq, tran_content, tran_amt, tran_branch, acct_seq){
		var fm = opener.document.form1;
		fm.bank_code3.value = bank_code;
		fm.deposit_no3.value = deposit_no;	
		fm.incom_dt.value = tran_date;		
		fm.tran_date_seq.value = tran_date_seq;		
		fm.remark.value = tran_content;		
		fm.incom_amt.value = tran_amt;		
		fm.bank_office.value = tran_branch;	
		fm.tran_date.value = tran_date;	
		fm.bank_id.value = bank_id;	
		fm.acct_num.value = acct_num;	
		fm.acct_seq.value = acct_seq;	
		
		fm.incom_gubun[1].checked = true;  //���ݼ���	
		
		window.close();
	}
	
	function setDemandFmsYn(acct_seq, tran_date, tran_date_seq){
		var fm = document.form1;
				
		if(!confirm('FMS �ݿ�ó���Ͻðڽ��ϱ�?'))	return;		
			
		fm.target="i_no";
		fm.action = "./shinhan_erp_null_inside_ui.jsp?s_kd="+fm.s_kd.value+"&t_wd="+fm.t_wd.value+"&acct_seq=" + acct_seq +  "&tran_date="+ tran_date + "&tran_date_seq="+tran_date_seq;
		fm.submit();
	}
		
	function ChangeDT(arg)
	{
		var theForm = document.form1;
		if(arg=="ref_dt1")
		{
		theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
		}else if(arg=="ref_dt2"){
		theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
		}	
	}		
	
	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='shinhan_erp_demand_inside_s.jsp'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">     
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>    
<input type='hidden' name='from_page' value='<%=from_page%>'> 

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > <span class=style5>
						�����Ա���ȸ</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr> 
	
    <tr> 
    	<td>
     	<table border="0" cellspacing="1" >
	         <td width="370">&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
	                  <input type="radio" name="dt" value="1" <%if(dt.equals("1"))%>checked<%%>>
	                  ���� 
	                  <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
	                  ��� 
	                  <input type="radio" name="dt" value="4" <%if(dt.equals("4"))%>checked<%%>>
	                  ���� 
	                  <input type="radio" name="dt" value="5" <%if(dt.equals("5"))%>checked<%%>>
	                  ���� 
	                  <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
	                  ��ȸ�Ⱓ </td>
	          <td width="450"><input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
	                  ~ 
	                  <input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" >                    
			    &nbsp;�˻���(�ݾ�����):<input type="text" name="s_wd" value="<%=s_wd%>" size="20" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>     
			    &nbsp;<a href="javascript:search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
			   &nbsp;
			  <!--  <a href="javascript:self.close();" onMouseOver="window.status=''; return true"><img src="/acar./images/center/button_close.gif" align=absmiddle border=0></a>&nbsp; -->
	        </td>
	    </table>
	   </td>     
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr></tr><tr></tr><tr></tr>
    	
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=4%>����</td>
                    <td class=title width=10%>�����ڵ�</td>
                    <td class=title width=8%>�����</td>
                    <td class=title width=11%>���¹�ȣ</td>
                    <td class=title width=7%>�ŷ���</td>
                    <td class=title width=14%>�ŷ�����</td>
                    <td class=title width=6%>�Աݾ�</td>
                    <td class=title width=5%>����</td>
                                
                </tr>
          <%for (int i = 0 ; i < client_size ; i++){
				Hashtable ht = (Hashtable)clients.elementAt(i);%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=ht.get("BANK_ID")%>(<%=ht.get("BANK_NM")%>)</td>
                    <td align="center"><%=ht.get("BANK_NAME")%></td>
                    <td align="center"><%=ht.get("ACCT_NB")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TR_DATE")))%></td>
                    <td align="center"> <%=ht.get("NAEYONG")%>                    
                   <%  if (     Integer.parseInt(from_dt) <=  Integer.parseInt(String.valueOf(ht.get("TR_DATE") ))   &&     Integer.parseInt(String.valueOf(ht.get("TR_DATE") ) )   <=     Integer.parseInt(AddUtil.getDate(4))    ) {%>        
                        <%  if (  !String.valueOf(ht.get("JUNG_TYPE") ).equals("1")  ) {%>       
                          <a  href="javascript:MM_openBrWindow('shinhan_erp_demand_inside_incomreq.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&tr_date=<%=ht.get("TR_DATE")%>&ip_amt=<%=ht.get("IP_AMT")%>&naeyong=<%=ht.get("NAEYONG")%>&bank_name=<%=ht.get("BANK_NAME")%>&acct_nb=<%=ht.get("ACCT_NB")%>','I_Reply','scrollbars=no,status=yes,resizable=yes,width=550,height=320,left=50, top=50')">
             		    [�޼���������]</a>
                      <%  }
                        } %>   
                    </td>               
                    <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("IP_AMT")))%></td>
                    <td align="center"><%=ht.get("ERP_FMS_YN")%> (<% if ( String.valueOf(ht.get("JUNG_TYPE")).equals("0")  ) { %>Ȯ���� <% }  else if ( String.valueOf(ht.get("JUNG_TYPE")).equals("1")  ) { %>�Ϸ� <% }  else if ( String.valueOf(ht.get("JUNG_TYPE")).equals("2")  ) { %>������ <% } %> )                  
                    </td>
                </tr>
          <%		}%>
          
          <%if (s_wd.equals("")) {	%>
                <tr> 
                    <td align="center" colspan="8">�˻�� �Է��ϰ� �˻��Ͻʽÿ�.</td>
                </tr>
          <%}else{%>
           <%if (client_size ==0){%>
                <tr> 
                    <td align="center" colspan="8">��ȸ������ �����ϴ�.</td>
                </tr>
          <%		}%>
          <%}%>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;<font color=red>*</font>&nbsp;����ŷ������� 30�и��� ���ŵ˴ϴ�.</td>
    </tr>
    <tr>
	       <td><font color=red>*</font>&nbsp;<b>(�Ϸ�)</b>�� ǥ�õ��� �ʴ� ���� ����� Ȯ������(�Ա�������ȸ, ��������ȸ, �Աݴ���ڿ���ȭ ���) ���Դϴ�.!!</td>
	 <tr>
	 <tr>
	       <td><font color=red>*</font>&nbsp;<b>���� �Ա�ó���� ���� ����ڰ� �˰��ִ� ����(��������, �Ա��׸� ��)�� �Աݴ���ڿ��� �˷��ּ���.!!!</b></td>
	 <tr>
	
    		     
</table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="100"  frameborder="0" noresize> </iframe>
</body>
</html>