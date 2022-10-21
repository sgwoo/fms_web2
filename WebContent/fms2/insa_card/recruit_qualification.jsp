<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.insa_card.*"%>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   

<%
	int rc_no=Integer.parseInt(request.getParameter("rc_no"));
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String reg_edu = request.getParameter("reg_edu")==null?"":request.getParameter("reg_edu");

	InsaRcDatabase icd = new InsaRcDatabase();
	Insa_Rc_QfBean QfBean = icd.InsaQfselectOne(rc_no);
	
	// �ڵ� ����Ʈ
	Vector vt_job = icd.getList("2");
	int vt_size = vt_job.size();
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function infoCan(){ 
		opener.window.location='recruit_qualification_sc.jsp';
		close();
	}
	
	function deleteQf(){ 
		var theForm = document.form;
		if(!confirm('�����Ͻðڽ��ϱ�?')){		return;	}
	
		theForm.action = "recruit_qualification_up.jsp.jsp?gubun=d";
		theForm.submit();
	}
	
	function updateQf(){ 
		var theForm = document.form;
		
		if ( theForm.rc_edu.value =="") { alert("�з������� �����Ͻʽÿ�."); return; }	
		
		if(!confirm('�����Ͻðڽ��ϱ�?')){		return;	}
				
		theForm.action = "recruit_qualification_up.jsp.jsp";
		theForm.submit();
	}
	
//-->	
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form'class="form"  method='post' target='qfList'>
<%@ include file="/include/search_hidden.jsp" %>
  <table border="0" cellspacing="0" cellpadding="0" width="800">
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�����ڰ�/�ٹ�����</span></td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr><td class=line2></td></tr>
    <tr>
        <td class="line" width='100%'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>   
				
	        	<tr>
	        		<td class='title' width='20%'>�з�����</th>
	        		<td width='80%'>&nbsp;
	        		  <select name='rc_edu'>	
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
		                <option value='<%=ht.get("RC_CODE")%>' <%if(QfBean.getRc_edu().equals((String)ht.get("RC_CODE"))){%>selected<%}%>><%= ht.get("RC_NM")%></option>
		                <%		}
							}%>
					<% } %>		
		              </select>
			        </td>	        	
	              		
	        	</tr>
	        	<tr>
	        		<td class='title' width='20%'>�������</th>
	        		<td width='80%'>&nbsp;
	        		  <select name="rc_qf_var1" >
	        		<% //�űԵ���̸� 
	        		  if ( rc_no == 0 ) { %>
	        		  	  <option value="������" selected>������</option>
                 		  <option value="��������">��������</option>                 
	        		 <% } else { %> 
	        		    <option value="������" <% if(QfBean.getRc_qf_var1().equals("������")){%>selected<%}%>>������</option>
               			<option value="��������" <% if(QfBean.getRc_qf_var1().equals("��������")){%>selected<%}%>>��������</option>
					<% } %>	
             		 </select>
              		</td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>�������</th>
	        		<td width='80%'>&nbsp;<input type="text" name="rc_qf_var2" size='40' value="<%=QfBean.getRc_qf_var2()==null?"":QfBean.getRc_qf_var2() %>"/></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>�ӱ�</th>
	        		<td width='80%'>&nbsp;<input type="text" name="rc_qf_var3" size='40' value="<%=QfBean.getRc_qf_var3()==null?"":QfBean.getRc_qf_var3() %>"/></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>���ӿ���</th>
	        		<td width='80%'>&nbsp;<input type="text" name="rc_qf_var4" size='40' value="<%=QfBean.getRc_qf_var4()==null?"":QfBean.getRc_qf_var4() %>"/></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>�ٹ�����</th>
	        		<td width='80%'>&nbsp;<input type="text" name="rc_qf_var5" size='40' value="<%=QfBean.getRc_qf_var5()==null?"":QfBean.getRc_qf_var5() %>"/></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>�ٷνð�</th>
	        		<td width='80%'>&nbsp;<input type="text" name="rc_qf_var6" size='40' value="<%=QfBean.getRc_qf_var6()==null?"":QfBean.getRc_qf_var6() %>"/></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>�ٹ��ð�</th>
	        		<td width='80%'>&nbsp;<input type="text" name="rc_qf_var7" size='40' value="<%=QfBean.getRc_qf_var7()==null?"":QfBean.getRc_qf_var7() %>"/></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>��ȸ����</th>
	        		<td width='80%'>&nbsp;<input type="text" name="rc_qf_var8" size='40' value="<%=QfBean.getRc_qf_var8()==null?"":QfBean.getRc_qf_var8() %>"/></td>
	        	</tr> 
	        	<tr>
	        		<td class='title' width='20%'>�����޿�</th>
	        		<td width='80%'>&nbsp;<input type="text" name="rc_qf_var9" size='40' value="<%=QfBean.getRc_qf_var9()==null?"":QfBean.getRc_qf_var9() %>"/></td>
	        	</tr> 
            </table>
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>  	
    <tr>
        <td align='right'>
        		<input type="hidden" name="rc_no" value="<%=QfBean.getRc_no()%>">
				<button value="<%=QfBean.getRc_no()%>" style="float:right;" onclick="infoCan();" >�ݱ�</button>
				<button onclick="updateQf();" value="<%=QfBean.getRc_no()%>" style="float:right;">����</button>	
				<button onclick="deleteQf();" value="<%=QfBean.getRc_no()%>" style="float:right;">����</button>				
        </td>
    </tr>            
  </table>
</form>
</body>
</html>
