<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.account.AccountDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	//�α���-�뿩����:����
	CommonDataBase c_db = CommonDataBase.getInstance();
	String auth = c_db.getUserAuth(user_id);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 2; //��Ȳ ��� �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='c_id' value=''>
<input type='hidden' name='r_st' value=''>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='mode' value='client'>
<input type='hidden' name='page_st' value='fee'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ��� > <span class=style5>�뿩����Ȳ</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>
	<tr>		
        <td class='line'> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td rowspan="2" width=16% class='title' align="center">����</td>
                    <td colspan="2" class='title' align="center">���</td>
                    <td colspan="2" class='title' align="center">����</td>
                    <td colspan="2" class='title' align="center">��ü</td>
                    <td colspan="2" class='title' align="center">�հ�</td>
                </tr>
                <tr align="center"> 
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                    <td width=9% class='title'>�Ǽ�</td>
                    <td width=12% class='title'>�ݾ�</td>
                </tr>
		  
<%	//�뿩�� ��Ȳ----------------------------------------------------------------------
	Vector fees = ac_db.getFeeStat(br_id, "", "", "");
	int fee_size = fees.size();
	if(fee_size > 0){
		for (int i = 0 ; i < fee_size ; i++){
			IncomingSBean fee = (IncomingSBean)fees.elementAt(i);%>		
                <tr> 
                    <td align="center" class='title'><%=fee.getGubun()%></td>
                    <td align="right"><%if(fee.getGubun().equals("����")){%><%=fee.getTot_su1()%>%<% }else{%><%=fee.getTot_su1()%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(fee.getGubun().equals("����")){%><%=fee.getTot_amt1()%>%<%}else{%><%=Util.parseDecimal(fee.getTot_amt1())%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(fee.getGubun().equals("����")){%><%=fee.getTot_su2()%>%<% }else{%><%=fee.getTot_su2()%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(fee.getGubun().equals("����")){%><%=fee.getTot_amt2()%>%<%}else{%><%=Util.parseDecimal(fee.getTot_amt2())%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(fee.getGubun().equals("����")){%><%=fee.getTot_su3()%>%<% }else{%><%=fee.getTot_su3()%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(fee.getGubun().equals("����")){%><%=fee.getTot_amt3()%>%<%}else{%><%=Util.parseDecimal(fee.getTot_amt3())%>��<%}%>&nbsp;</td>
                    <td align="right"><%if(fee.getGubun().equals("����")){%>-<%}else{%><%=Integer.parseInt(fee.getTot_su2())+Integer.parseInt(fee.getTot_su3())%>��<%}%>&nbsp;</td>  
        			<td align="right">
                      <%if(!fee.getGubun().equals("����")){%><%=Util.parseDecimal(String.valueOf(Integer.parseInt(fee.getTot_amt2())+Integer.parseInt(fee.getTot_amt3())))%>��<%}else{%>-&nbsp;<%}%>&nbsp;</td>
                </tr>
<%		}
	}else{%>		
		        <tr>
			        <td colspan="9" align="center">�ڷᰡ �����ϴ�.</td>
		        </tr>
<%	}%>	

<%	//�뿩�� ��Ȳ - ��ü��-------------------------------------------------------------
	Vector feedps = ac_db.getFeeStat_Dlyper(br_id, "", "", "");
	int feedp_size = feedps.size();
	if(feedp_size > 0){
		for (int i = 0 ; i < feedp_size ; i++){
			IncomingSBean feedp = (IncomingSBean)feedps.elementAt(i);%>		
                <tr> 
                    <td class='title'>�Ѵ뿩��</td>
                    <td colspan="2" align="right"><b><%=Util.parseDecimalLong(feedp.getTot_amt1())%>��</b>&nbsp;</td>
                    <td class='title'>��ü�뿩��</td>
                    <td colspan="2" align="right"><b><font color='red'><%=Util.parseDecimal(feedp.getTot_amt2())%>��</font></b>&nbsp;</td>
                    <td class='title'>��ü��</td>
                    <td colspan="2" align="center"><b><font color='red'><%=feedp.getTot_su1()%>%</font></b>&nbsp;</td>
                </tr>
<%		}
	}%>				  
            </table>
        </td>
    </tr>	
    <tr>
	    <td align="right">
	    <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
	    </td>
    </tr>  
</table>
</form>
</body>
</html>
