<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.add_mark.*" %>
<jsp:useBean id="am_db" scope="page" class="acar.add_mark.AddMarkDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String brch = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String br_id = "";
	String dept_id = "0000";
	String gubun = "0003";
	String mng_who = "4";
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	

	//������ ����Ʈ
	Vector adds = am_db.getAddMarks(br_id, dept_id, gubun, mng_who);
	int add_size = adds.size();	
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	//�����ϱ�
	function update(idx){
		var fm = document.form1;	
		if(fm.add_size.value == 1){	
			if(fm.u_marks.value == ''){ alert("���������� Ȯ���Ͻʽÿ�."); fm.u_marks.focus(); return; }
			fm.seq.value = fm.u_seq.value;				
			fm.marks.value = fm.u_marks.value;				
			fm.end_dt.value = fm.u_end_dt.value;							
		}else{
			if(fm.u_marks[idx].value == ''){ alert("���������� Ȯ���Ͻʽÿ�."); fm.u_marks[idx].focus(); return; }
			fm.seq.value = fm.u_seq[idx].value;				
			fm.marks.value = fm.u_marks[idx].value;	
			fm.end_dt.value = fm.u_end_dt[idx].value;													
		}
		if(!confirm('�����Ͻðڽ��ϱ�?'))	return;
		fm.target='i_no';
		fm.submit();		
	}			
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:self.focus()">
<form action="./stat_total_help_null.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=brch%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='add_size' value='<%=add_size%>'>
<input type="hidden" name="cmd" value="u">
<input type="hidden" name="seq" value="">
<input type="hidden" name="end_dt" value="">
<input type="hidden" name="marks" value="">
<table border=0 cellspacing=0 cellpadding=0 width="550">
  <tr>
    	<td colspan=3>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�濵���� > ������Ȳ > ����� �λ����� > <span class=style5>�������ü������Ȳ ����ġ �ο���� </span></span></td>
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
            <table border="0" cellspacing="1" cellpadding="0" width="550">
                <tr> 
                    <td width="80" class=title>�����Ҹ�</td>
                    <td width="70" class=title>�μ���</td>
                    <td width="80" class=title>��������</td>
                    <td width="150" class=title>�������</td>
                    <td class=title width="80">������</td>
                    <td class=title>ó��</td>		  
                </tr>
                <%for(int i = 0 ; i < add_size ; i++){
			    Hashtable add = (Hashtable)adds.elementAt(i);%>
                <tr> 
		        <input type="hidden" name="u_seq" value="<%=add.get("SEQ")%>">
		        <input type="hidden" name="u_end_dt" value="<%=add.get("END_DT")%>">
                  <td align=center><%=c_db.getNameById(String.valueOf(add.get("BR_ID")),"BRCH")%></td>
                  <td align=center><%if(String.valueOf(add.get("DEPT_ID")).equals("0000")){%>��ü<%}else{%><%=c_db.getNameById((String)add.get("DEPT_ID"),"DEPT")%><%}%></td>
                  <td align=center>
        		  <%if(String.valueOf(add.get("MNG_WAY")).equals("0")){%>��ü<%}%>
        		  <%if(String.valueOf(add.get("MNG_WAY")).equals("1")){%>�Ϲݽ�<%}%>
        		  <%if(String.valueOf(add.get("MNG_WAY")).equals("2")){%>�����<%}%>		  		  
        		  <%if(String.valueOf(add.get("MNG_WAY")).equals("3")){%>�⺻��<%}%>		  		  		  
        		  <%if(String.valueOf(add.get("MNG_WAY")).equals("9")){%>�����/�⺻��<%}%>		  		  		  		  
        		  </td>
                  <td align=center>
        		  <%if(String.valueOf(add.get("MNG_ST")).equals("1")){%>�ܵ�<%}%>
        		  <%if(String.valueOf(add.get("MNG_ST")).equals("2")){%>����<%}%>
        		  <%if(String.valueOf(add.get("MNG_ST")).equals("3")){%>���ʿ���<%}%>
        		  <%if(String.valueOf(add.get("MNG_ST")).equals("4")){%>��������<%}%>
        		  <%if(String.valueOf(add.get("MNG_ST")).equals("5")){%>�������<%}%>
        		  <%if(String.valueOf(add.get("MNG_ST")).equals("6")){%>�ű԰��<%}%>
        		  <%if(String.valueOf(add.get("MNG_ST")).equals("7")){%>�������<%}%>
        		  <%if(String.valueOf(add.get("MNG_ST")).equals("8")){%>�������<%}%>
        		  <%if(String.valueOf(add.get("MNG_ST")).equals("9")){%>������<%}%>
        		  <%if(String.valueOf(add.get("MNG_ST")).equals("10")){%>������(6�����̻�)<%}%>
        		  <%if(String.valueOf(add.get("MNG_ST")).equals("11")){%>��ü��-��<%}%>
        		  <%if(String.valueOf(add.get("MNG_ST")).equals("12")){%>��ü��-��<%}%>		  		  
        		  <%if(String.valueOf(add.get("MNG_ST")).equals("13")){%>����-��<%}%>		  		  		  
        		  </td>
                  <td align=center><input type="text" name="u_marks" size="4" class="num" value="<%=String.valueOf(add.get("MARKS"))%>">��</td>
                  <td align="center"> 
        			<%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>			
                      <a href="javascript:update('<%=i%>');"><img src=../images/center/button_in_modify.gif border=0 align=absmiddle></a>
        			<%	}%>			  
                  </td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
    <tr>    	
        <td align="right"><a href="javascript:self.close();windows.close();"><img src=../images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>