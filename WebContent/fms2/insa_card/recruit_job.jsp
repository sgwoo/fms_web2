<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.common.*, acar.util.*, acar.insa_card.*"%>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   

<%
	int rc_no=Integer.parseInt(request.getParameter("rc_no"));

	InsaRcDatabase icd = new InsaRcDatabase();
	Insa_Rc_JobBean JbBean = icd.InsaRcJobselectOne(rc_no);
	
	// �ڵ� ����Ʈ
	Vector vt_job = icd.getList("1");
	int vt_size = vt_job.size();
				
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<SCRIPT SRC="../lib/ckeditor/ckeditor.js"></SCRIPT>
<script language='javascript'>
<!--
	function infoCan(){ 
		opener.window.location='recruit_job_sc.jsp';
		close();
	}
	
	function deleteRc(){ 
		var theForm = document.form;
		if(!confirm('�����Ͻðڽ��ϱ�?')){		return;	}

		theForm.action = "recruit_job_up.jsp?gubun=d";
		theForm.submit();
	}
	
	function updateRc(){ 
		var theForm = document.form;
		
		if ( theForm.rc_job.value =="") { alert("������ �����Ͻʽÿ�."); return; }	
		
		if(!confirm('�����Ͻðڽ��ϱ�?')){		return;	}
				
		theForm.action = "recruit_job_up.jsp";
		theForm.submit();
	}
	
//-->	
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form'class="form" method='post' target='qfList'>
<%@ include file="/include/search_hidden.jsp" %>
  <table border="0" cellspacing="0" cellpadding="0" width="800">
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr><td class=line2></td></tr>
    <tr>
        <td class="line" width='100%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>   
				
	        	<tr>
	        		<td class='title' width='20%'>����</th>
	        		<td width='80%'>&nbsp;
	        		  <select name='rc_job'>	
	        		  <% //�űԵ���̸� 
	        		  if ( rc_no == 0 ) { %>
	        		    <option value="">--����--</option>
	        		  <%	if(vt_size > 0){
								for(int i = 0 ; i < vt_size ; i++){
									Hashtable ht = (Hashtable)vt_job.elementAt(i); %>
		                <option value='<%=ht.get("RC_CODE")%>'> <%= ht.get("RC_NM")%></option>
		                <%		}
							}%>
	        		 <% } else { %> 
	        		  
		                <%	if(vt_size > 0){
								for(int i = 0 ; i < vt_size ; i++){
									Hashtable ht = (Hashtable)vt_job.elementAt(i); %>
		                <option value='<%=ht.get("RC_CODE")%>' <%if(JbBean.getRc_job().equals((String)ht.get("RC_CODE"))){%>selected<%}%>><%= ht.get("RC_NM")%></option>
		                <%		}
							}%>
					<% } %>		
		              </select>
			        </td>	        		
	        	</tr>
	        	<tr>
	        		<td class='title' width='20%'>��������</th>
	        		<td width='80%'><textarea name="rc_job_cont" cols='80' rows='18'><%=JbBean.getRc_job_cont()==null?"":JbBean.getRc_job_cont()%></textarea>
					<script>
					CKEDITOR.replace( 'rc_job_cont', {
						toolbar: [
						    { name: 'links', items:['Link']},
						    { name: 'styles', items: [ 'Format', 'Font', 'FontSize' ] },
							{ name: 'basicstyles', items: [ 'Bold', 'Italic' ] },
							{ name: 'insert', items: ['Table','HorizontalRule'] },
							{ name: 'tools', items:['Maximize']}
						],
						height:"300px",
						enterMode: CKEDITOR.ENTER_DIV
					});
					</script>			</td>
	        	</tr> 
	        	
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>  	
    <tr>
        <td align='right'>
        		<input type="hidden" name="rc_no" value="<%=JbBean.getRc_no()%>">
				<button value="<%=JbBean.getRc_no()%>" style="float:right;" onclick="infoCan();" >�ݱ�</button>&nbsp;&nbsp;
				<button onclick="updateRc();" value="<%=JbBean.getRc_no()%>" style="float:right;">����</button>&nbsp;&nbsp;	
				<button onclick="deleteRc();" value="<%=JbBean.getRc_no()%>" style="float:right;">����</button>&nbsp;&nbsp;						
        </td>
    </tr>            
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
