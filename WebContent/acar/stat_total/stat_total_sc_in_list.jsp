<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function view_stat_mng(save_dt){
		parent.document.form1.view_dt.value = save_dt;

		var fm = document.form1;	
		fm.brch_id.value = parent.document.form1.brch_id.value;		
		fm.save_dt.value = ChangeDate_nb(save_dt);
		fm.submit();		
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String brch_id = request.getParameter("brch_id")==null?br_id:request.getParameter("brch_id");
	
	//��ä��Ȳ
	Vector deb1s = ad_db.getStatDebtList("stat_total");
	int deb1_size = deb1s.size();
%>
<form name='form1' action='stat_total_sc_in_view.jsp' target='i_view'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=save_dt%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width="<%if(deb1_size==0){%>200<%}else{%><%=(deb1_size*70)+80%><%}%>">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" width='80' >��������</td>
          <%if(deb1_size > 0){
				for(int i = 0 ; i < deb1_size ; i++){
					StatDebtBean sd = (StatDebtBean)deb1s.elementAt(i);%>			
                    <td width='80' align='center'><a href="javascript:view_stat_mng('<%=sd.getSave_dt()%>');"><%=sd.getSave_dt()%></a></td>
          <%	}
			}else{%>
			        <td align='center' width='120'>����Ÿ�� �����ϴ�</td>						
          <%}%>
                </tr>		  
            </table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
