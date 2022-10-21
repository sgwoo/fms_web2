<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.bill_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>�ŷ�ó ���� �̷�</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String ven_code 	= request.getParameter("ven_code")==null?"":request.getParameter("ven_code");
	
	String ven_st = "";
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//�ŷ�ó����
	TradeBean[] vens = neoe_db.getTradeHisList(ven_code);//-> neoe_db ��ȯ
	int ven_size = vens.length;
%>
<form name='form1' method='post' action='vendor_list.jsp'>
<input type='hidden' name='ven_code' value=''>
<input type='hidden' name='ven_name' value=''>
<input type='hidden' name='ven_nm_cd' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1000>
    	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>�繫ȸ�� > ������ǥ���� > <span class=style5>�ŷ�ó ���� �̷�</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td></td></tr>    
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='30' class='title'>����</td>
            <td width="30" class='title'>����</td>			
            <td width="90" class='title'>����ڹ�ȣ</td>
            <td width="200" class='title'>�ŷ�ó��</td>			
            <td width="80" class='title'>��ǥ�ڸ�</td>						
            <td width="200" class='title'>�ּ�</td>						
            <td width="80" class='title'>��������</td>						
            <td width="100" class='title'>���</td>
            <td width="130" class='title'>�������</td>
            <td width="60" class='title'>�����</td>						
          </tr>
                <%if(ven_size > 0){
						for(int i = 0 ; i < ven_size ; i++){
							TradeBean ven = vens[i];	
				%>
          <tr> 
            <td align="center"><%=i+1%></td>
            <td align="center"><%if(ven.getMd_gubun().equals("N")){%>����<%}else{%>����<%}%></td>			
            <td align="center"><%= AddUtil.ChangeEnt_no(ven.getS_idno())%></td>
            <td>&nbsp;<%= ven.getCust_name()%></td>            
            <td align="center"><%= ven.getDname()%></td>            			
            <td>&nbsp;<span title='<%=ven.getS_address()%>'><%=Util.subData(ven.getS_address(), 20)%></span></td>			
            <td align="center"><%if(ven.getVen_st().equals("1")){%>�Ϲݰ���<%}else if(ven.getVen_st().equals("2")){%>���̰���<%}else if(ven.getVen_st().equals("3")){%>�鼼<%}else if(ven.getVen_st().equals("4")){%>�񿵸�����(�������/��ü)<%}%></td>						
            <td>&nbsp;<%= ven.getDc_rmk()%></td>
            <td align="center"><%= ven.getReg_dt()%></td>
            <td align="center"><%=c_db.getNameById(ven.getUser_id(),"USER")%></td>						
          </tr>
                <%	}
				}%>		  
        </table>
      </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
      <td align='right'>
      	<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> 
      </td>
    </tr>
  </table>
</form>
</body>
</html>