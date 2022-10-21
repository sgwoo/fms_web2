<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.bill_mng.*, acar.user_mng.*"%>
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
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int sh_height 	= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	String reqseq 	= request.getParameter("reqseq")==null?"":request.getParameter("reqseq");
	
	
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//��ݿ���
	PayMngBean pay 	= pm_db.getPay(reqseq);
	
	Vector vt = new Vector();
	
	if(!pay.getAutodocu_write_date().equals("")){
		vt = neoe_db.getAutodocuPayList(pay.getAutodocu_write_date(), pay.getAutodocu_data_no(), pay.getAutodocu_data_gubun());
	}
	
	int vt_size = vt.size();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	//�����ϱ�
	function autodoc_delete(write_date, data_no, data_gubun, taxrela){
		fm = document.form1;
		fm.d_write_date.value 	= write_date;
		fm.d_data_no.value 		= data_no;
		fm.d_data_gubun.value 	= data_gubun;
		fm.d_taxrela.value 		= taxrela;								
		if(!confirm("�����Ͻðڽ��ϱ�?"))		return;
		fm.action = "pay_autodocu_del_a.jsp";
		fm.target = "i_no";
		fm.submit();
	}		
	
	//ȸ��ó������ϱ�
	function autodoc_cancel(){
		fm = document.form1;
		if(!confirm("ȸ��ó�� ����Ͻðڽ��ϱ�?"))		return;
		fm.action = "pay_autodocu_cancel_a.jsp";
		fm.target = "i_no";
		fm.submit();		
	}
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='from_page' value='<%=from_page%>'>  
  <input type='hidden' name='reqseq' 	value='<%=reqseq%>'>    
  <input type='hidden' name="d_write_date" value="">
  <input type='hidden' name="d_data_no" value="">
  <input type='hidden' name="d_data_gubun" value="">
  <input type='hidden' name="d_taxrela" value="">          
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ��� > <span class=style5>
						��ݿ��� �ڵ���ǥ </span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
      <td class=h></td>
    </tr>
	<tr>
	  <td align="right">&nbsp;</td>
	<tr> 	
    <tr>
      <td class=line2></td>
    </tr>    
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=15%>�ŷ�����</td>
            <td>&nbsp;<%=AddUtil.ChangeDate2(pay.getP_est_dt())%></td>
          </tr>
		</table>
	  </td>
	</tr>	 	
	<tr>
	  <td>�� ��ݿ�û����</td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="15%" class=title>��ݹ��</td>
            <td>&nbsp;
			  	<input type='radio' name="p_way" value='1' <%if(pay.getP_way().equals("1"))%>checked<%%>>
				��������
			  	<input type='radio' name="p_way" value='5' <%if(pay.getP_way().equals("5"))%>checked<%%>>
				������ü
				<input type='radio' name="p_way" value='4' <%if(pay.getP_way().equals("4"))%>checked<%%>>
				�ڵ���ü
				<input type='radio' name="p_way" value='2' <%if(pay.getP_way().equals("2"))%>checked<%%>>
				����ī��
				<input type='radio' name="p_way" value='3' <%if(pay.getP_way().equals("3"))%>checked<%%>>
				�ĺ�ī��
				<input type='radio' name="p_way" value='7' <%if(pay.getP_way().equals("7"))%>checked<%%>>
				ī���Һ�
				</td>
          </tr>
          <tr>
            <td class=title>�ݾ�</td>
            <td>&nbsp; <%=AddUtil.parseDecimalLong(pay.getAmt())%>�� </td>
          </tr>
          <tr>				
            <td class=title>����ó</td>
            <td>&nbsp;[
                <%if(pay.getOff_st().equals("cpt_cd")){		%>
                ������
                <%}%>
                <%if(pay.getOff_st().equals("com_code")){	%>
                �ڵ�����
                <%}%>
                <%if(pay.getOff_st().equals("ins_com_id")){	%>
                �����
                <%}%>
                <%if(pay.getOff_st().equals("car_off_id")){	%>
                ������
                <%}%>
                <%if(pay.getOff_st().equals("emp_id")){		%>
                �������
                <%}%>
                <%if(pay.getOff_st().equals("off_id")){		%>
                ���¾�ü
                <%}%>
                <%if(pay.getOff_st().equals("gov_id")){		%>
                ���α��
                <%}%>
                <%if(pay.getOff_st().equals("br_id"))	{	%>
                �Ƹ���ī
                <%}%>
                <%if(pay.getOff_st().equals("user_id")){		%>
                �Ƹ���ī����
                <%}%>
                <%if(pay.getOff_st().equals("other")){		%>
                ��Ÿ
                <%}%>
                ]&nbsp;<%=pay.getOff_nm()%> &nbsp; <img src=/acar/images/center/arrow.gif align=absmiddle> �ڵ� : <%=pay.getOff_id()%> </td>
          </tr>
          <tr>				
            <td class=title>�׿����ŷ�ó</td>
            <td>&nbsp;
			  <%=pay.getVen_name()%> &nbsp; <img src=/acar/images/center/arrow.gif align=absmiddle> �ڵ� : <%=pay.getVen_code()%> </td>
          </tr>
		</table>
	  </td>
	</tr>  
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width=7%>����</td>
                    <td class="title" width=13%>ó������</td>
                    <td class="title" width=10%>��ȣ</td>
                    <td class="title" width=13%>����</td>
                    <td class="title" width=40%>����</td>
                    <td class="title" width=9%>����</td>					
                    <td class="title" width=8%>����</td>			  
                </tr>
            <% 	if(vt_size>0){ 
					for(int i=0;i < vt_size;i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);%>
                <tr>
                    <td align="center"><%= i+1 %></td>
                    <td align="center"><%= AddUtil.ChangeDate2(String.valueOf(ht.get("WRITE_DATE"))) %></td>
                    <td align="center"><%= ht.get("DATA_NO") %></td>
                    <td align="center"><%= ht.get("GUBUN") %></td>
                    <td align="center"><%= ht.get("CONT") %></td>
                    <td align="center"><%if(String.valueOf(ht.get("DOCU_STAT")).equals("0")||String.valueOf(ht.get("DOCU_STAT")).equals("N")){%>��ó��<%}else{%>��ǥó��<%}%></td>					
                    <td align="center">
					<%if(String.valueOf(ht.get("DOCU_STAT")).equals("0")||String.valueOf(ht.get("DOCU_STAT")).equals("N")){%>
			        <a href="javascript:autodoc_delete('<%= ht.get("WRITE_DATE") %>','<%= ht.get("DATA_NO") %>','<%= ht.get("DATA_GUBUN") %>','<%= ht.get("TAXRELA") %>');"><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a>
					<%}%>
			        </td>
                </tr>
            <% 		}
		  		}else{ %>
                <tr>
                    <td colspan="7" class=""><div align="center">�ش� �ڵ���ǥ�� �����ϴ�.
					<%if(!pay.getAutodocu_data_no().equals("")){%>
					<a href="javascript:autodoc_cancel();">[ȸ��ó���� ����]</a>
					<%}%>
					</div>
					</td>
                </tr>
            <% 	} %>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">
		<%if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("��ݴ��",ck_acar_id) || nm_db.getWorkAuthUser("�Աݴ��",ck_acar_id)){%>		
		<%	if(!pay.getAutodocu_data_no().equals("")){%>
					<a href="javascript:autodoc_cancel();">[ȸ��ó���� ���� (ȸ��ó�����)]</a>
		<%	}%>
		<%}%>		
		</td>
    </tr>
    <tr>
        <td>* ��ó����ǥ�� ���� �����մϴ�.</td>
    </tr>	
    <tr>
	    <td align='center'>
		
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
	    </td>
	</tr>	
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>		
  </table>
</form>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

