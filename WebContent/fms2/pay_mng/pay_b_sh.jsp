<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();

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
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	//����׸񱸺�
	CodeBean[] codes = c_db.getCodeAll("0044");
	int c_size = codes.length;
		
	//��������
	CodeBean[] accts = c_db.getCodeAll_0043();
	int a_size = accts.length;	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�˻��ϱ�
	function search(){
		var fm = document.form1;
		fm.t_wd.value = replaceString("&","AND",fm.t_wd.value);
		fm.action = 'pay_b_sc.jsp';
		fm.target='c_foot';
		fm.submit();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
//-->
</script>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ��� > <span class=style5>
						��ݵ�ϰ���</span></span></td>
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
      <td class=line>
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
              <tr>
                <td class="title">��ȸ����</td>
                <td width="40%">&nbsp;
				  <select name='gubun4'>
                    <option value="1" <%if(gubun4.equals("1"))%>selected<%%>>�ŷ�����</option>
                    <option value="2" <%if(gubun4.equals("2"))%>selected<%%>>�������</option>
                  </select>			
				  &nbsp;	
				  <select name='gubun1'>
                    <option value="1" <%if(gubun1.equals("1"))%>selected<%%>>����</option>
                    <option value="2" <%if(gubun1.equals("2"))%>selected<%%>>���</option>
                    <option value="3" <%if(gubun1.equals("3"))%>selected<%%>>�Ⱓ</option>					
                  </select>		
				  &nbsp;				  
                    <input type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text">
					~
					<input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text"></td>
                <td width="10%" class="title">���޹��</td>
                <td width="40%">&nbsp;
                  <select name='gubun2'>
                    <option value="">����</option>
                    <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>��������</option>
                    <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>������ü</option>					
                    <option value="4" <%if(gubun2.equals("4"))%>selected<%%>>�ڵ���ü</option>
                    <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>����ī��</option>
                    <option value="3" <%if(gubun2.equals("3"))%>selected<%%>>�ĺ�ī��</option>					
                    <option value="7" <%if(gubun2.equals("7"))%>selected<%%>>ī���Һ�</option>
                  </select></td>
              </tr>
              <tr>
                <td width="10%" class="title">�˻�����</td>
                <td>&nbsp;
                  <select name='s_kd'>
                    <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>����ó </option>
                    <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>����</option>					
                    <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>�Ա�����</option>
                    <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>�Աݰ���</option>
                    <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>�������</option>
                    <option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>��ݰ���</option>
                    <option value='7' <%if(s_kd.equals("7")){%>selected<%}%>>ī���</option>
                    <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>ī���ȣ</option>
                    <option value='9' <%if(s_kd.equals("9")){%>selected<%}%>>�����</option>					
                  </select>
					&nbsp;&nbsp;&nbsp;
					<input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'></td>
                <td class="title">����׸�</td>
                <td>&nbsp;
                    <select name='gubun3'>
                      	<option value="">����</option>
						<option value="">==��ȸ���==</option>		
						<%for(int i = 0 ; i < c_size ; i++){
       						CodeBean code = codes[i];	%>
		        		<option value='<%=code.getNm_cd()%>' <%if(code.getNm_cd().equals(gubun3)){%>selected<%}%>><%= code.getNm()%></option>
		        		<%}%>	
						<option value="">==�������==</option>
						<%for(int i = 0 ; i < a_size ; i++){
       						CodeBean code = accts[i];	%>
		        		<option value='<%=code.getNm_cd()%>' <%if(code.getNm_cd().equals(gubun3) && !code.getCode().equals("0000")){%>selected<%}%>><%= code.getNm()%></option>
		        		<%}%>		        		
                  	</select>
                </td>
              </tr>
            </table></td>
    </tr>
    <tr align="right">
        <td colspan="2"><a href="javascript:search()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
    </tr>	 
</table>
</form>
</body>
</html>

