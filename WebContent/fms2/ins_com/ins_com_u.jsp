<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	InsComDatabase ic_db = InsComDatabase.getInstance();
		
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");

	String reg_code 	= request.getParameter("code")==null?"":request.getParameter("code");
	String seq 	= request.getParameter("seq")==null?"":request.getParameter("seq");
	
	
	InsurExcelBean iec_bean = ic_db.getInsExcelCom(reg_code, seq);
	
	Hashtable ht = ic_db.getInsExcelComCase(reg_code, seq);
	
	int b_size = 33;
	
	if(iec_bean.getGubun().equals("����")) b_size = 49;
	if(iec_bean.getGubun().equals("�輭")) b_size = 38;
	
	String value_nm[]	 = new String[b_size+1];
	
	
	if(iec_bean.getGubun().equals("����")){
		value_nm[1]  = "��";
		value_nm[33]  = "��ȣ(������)";
		value_nm[2]  = "����ڵ�Ϲ�ȣ";
		value_nm[3]  = "����";
		value_nm[4]  = "������ȣ";
		value_nm[5]  = "�����ȣ";
		value_nm[6]  = "�����Һ��ڰ�";
		value_nm[7]  = "�����ڿ���";
		value_nm[8]  = "�빰���";
		value_nm[9]  = "�ڱ��ü���";
		value_nm[10] = "����������";
		value_nm[11] = "���ڽ�";
		value_nm[12] = "����(���ް�)";
		value_nm[13] = "�ø����ȣ";
		value_nm[14] = "������ڵ�";
	}
	
	if(iec_bean.getGubun().equals("����")){
		value_nm[1]  = "�������";
		value_nm[2]  = "���Ժ����";
		value_nm[3]  = "������";
		value_nm[4]  = "������ȣ";
		value_nm[5]  = "�����ȣ";
		value_nm[6]  = "����";
		value_nm[7]  = "����";
		value_nm[8]  = "��������";
		value_nm[9]  = "���ʵ����";
		value_nm[10] = "�����";
		value_nm[11] = "�ڵ����ӱ�";
		value_nm[12] = "ABS��ġ";
		value_nm[13] = "���ڽ�";
		value_nm[14] = "����";
		value_nm[15] = "�빰";
		value_nm[16] = "�ڱ��ü���";
		value_nm[17] = "�ڱ��ü�λ�";
		value_nm[18] = "����";
		value_nm[19] = "������";
		value_nm[20] = "����";
		value_nm[21] = "����������";
		value_nm[22] = "���ǹ�ȣ";
		value_nm[23] = "���ŷ�ó";
		value_nm[24] = "���������";
		value_nm[25] = "����ڹ�ȣ";
		value_nm[26] = "�뿩�Ⱓ";
		value_nm[27] = "���ڽ�";
		value_nm[28] = "����(���ް�)";
		value_nm[29] = "�ø����ȣ";
		value_nm[30] = "������ڵ�";
		value_nm[49] = "��ȣ(������)";
	}	
	
	if(iec_bean.getGubun().equals("�輭")){
		value_nm[1]  = "������ȣ";
		value_nm[2]  = "���ǹ�ȣ";
		value_nm[3]  = "��";
		value_nm[4]  = "����";
		value_nm[5]  = "����ڹ�ȣ";
		value_nm[6]  = "���������";
		value_nm[7]  = "���踸����";
		value_nm[8]  = "�輭�׸��";
		value_nm[9]  = "������";
		value_nm[10] = "������";
		value_nm[11] = "�������";
		value_nm[12] = "�����û��";
		value_nm[13] = "���";
		value_nm[14] = "������ڵ�";
		value_nm[36] = "��ȣ(������)";
		value_nm[38] = "�Ǻ����ں���";
	}	
	
	if(iec_bean.getGubun().equals("����")){
		value_nm[10] = "�Ǻ����ں���";
	}	
%>

<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<script language='javascript'>
<!--
	function update(){
		var fm = document.form1;
		fm.action = 'ins_com_u_a.jsp';
		fm.target = 'i_no';
		fm.submit();
	}
	
//-->
</script>
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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src='//rawgit.com/tuupola/jquery_chained/master/jquery.chained.min.js'></script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body leftmargin=15>
<form name='form1' action='' target='' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name='from_page' value='<%=from_page%>'>
  <input type='hidden' name='reg_code' value='<%=reg_code%>'>
  <input type='hidden' name='seq' value='<%=seq%>'>

<div class="navigation">
	<span class=style1>������� ></span><span class=style5>�����û����</span>
</div>

<table border="0" cellspacing="0" cellpadding="0" width='650'>    
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td width='200' class='title'>����</td>
					<td width='450' class='title'>��</td>
			  </tr>
			  <%for (int i = 1 ; i <= b_size ; i++){%>
			   <%  if(value_nm[i] != null){%>
				<tr>
					<td class='title'><%=value_nm[i]%></td>
					<td>&nbsp;<input type='text' name="value<%=AddUtil.addZero2(i)%>" value='<%=ht.get("VALUE"+AddUtil.addZero2(i))%>' size="60"></td>
			  </tr>
			  	<%}%>
			  <%}%>
			</table>
		</td>
	</tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">		
		<%	if(nm_db.getWorkAuthUser("������",user_id)||nm_db.getWorkAuthUser("�������",user_id)){%>
		<a href="javascript:update()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;
		<%	}%>
		<a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
